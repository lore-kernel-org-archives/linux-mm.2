Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24CC5CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 21:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3278E0005; Mon,  8 Sep 2025 17:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA8F8E0001; Mon,  8 Sep 2025 17:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707A48E0005; Mon,  8 Sep 2025 17:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7078E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:09:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0883D8595B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:09:19 +0000 (UTC)
X-FDA: 83867323638.19.9FBA0D8
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	by imf25.hostedemail.com (Postfix) with ESMTP id EBB8FA000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:09:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AFzIepHD;
	spf=pass (imf25.hostedemail.com: domain of "prvs=339869f4a=ajgja@amazon.com" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=339869f4a=ajgja@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757365757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQiAiwFq2l0plLev52Qgg3ckSPW1kQUzFe2aH9v9SLY=;
	b=qyrOp101n2NkWpP2BeycMBUa9dCViozcN9iC3PQnDxoBBopYG+XfWKEc+7g8LNdzHsTofc
	uArNC8Ct2Z6O4idAauLthS0cktEgZnt3ByovEAbYggNTyaPPkWzfj1JcoIGI7df4neTMXA
	ONPaHwtXu6htdAiLD53xYPOZVRBHSJs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757365757; a=rsa-sha256;
	cv=none;
	b=cMFpA+qFvRXZV4+I2zPpHlSGhytxlGeWBWNlRFIG4Gw4kvFWMWORGdX8JDv5UVRDew3SqD
	6e+IJyQCEKHy21zYfC85qgvmI2qnFauXXvzgg1kESEZIq+TBnueh1ulpAoTQHmrSb125hu
	r7RfhLWTifI03sLqNxZV+uCot9i7/uk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AFzIepHD;
	spf=pass (imf25.hostedemail.com: domain of "prvs=339869f4a=ajgja@amazon.com" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=339869f4a=ajgja@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1757365757; x=1788901757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gQiAiwFq2l0plLev52Qgg3ckSPW1kQUzFe2aH9v9SLY=;
  b=AFzIepHDOd61BEHHZcJlDogK3RGZkoKlKX8KBJCp3RnP0Nvdo68e9GXd
   FPH75MX8b2m6ilvmavAuIUCYnLqc/rcTLG91SPO4PW13qe2ImERI6YBXJ
   /psSsnz6zJVulIM9hkPccPGxldD4ZftUMZx2xmYsfOmbz/o8n1vJ8lfUC
   af62AdK2SNkRjuqg5gByksLiq+N0s9o6cplc47wpjZMgRB96oGGYHFn/u
   ZWBrhqIBdHn+3x46Grlzx47//YLLFsNDvap1fuS0aAFlh49mAmzpCi8zy
   9A/uzYZyZiMJfIjlFk8CeH0UvGSb1J3w3sFVgC1Qv3iWz+90GuoEz7yKu
   A==;
X-CSE-ConnectionGUID: HNW4PmLhTby4S2UJFDMUVg==
X-CSE-MsgGUID: NyZMZRApT9qBGIzBV4tvyA==
X-IronPort-AV: E=Sophos;i="6.18,249,1751241600"; 
   d="scan'208";a="2524191"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 21:09:15 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.38.20:23813]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.90:2525] with esmtp (Farcaster)
 id a7cc81e2-07cb-4676-b62c-df1fbd09d378; Mon, 8 Sep 2025 21:09:15 +0000 (UTC)
X-Farcaster-Flow-ID: a7cc81e2-07cb-4676-b62c-df1fbd09d378
Received: from EX19D032UWA001.ant.amazon.com (10.13.139.62) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 8 Sep 2025 21:09:15 +0000
Received: from dev-dsk-ajgja-2a-6a9b5603.us-west-2.amazon.com (172.22.68.79)
 by EX19D032UWA001.ant.amazon.com (10.13.139.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 8 Sep 2025 21:09:15 +0000
From: Andrew Guerrero <ajgja@amazon.com>
To: <gregkh@linuxfoundation.org>
CC: <ajgja@amazon.com>, <akpm@linux-foundation.org>,
	<cgroups@vger.kernel.org>, <gunnarku@amazon.com>, <guro@fb.com>,
	<hannes@cmpxchg.org>, <roman.gushchin@linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <mhocko@kernel.org>,
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <stable@vger.kernel.org>,
	<vdavydov.dev@gmail.com>
Subject: Re: [PATCH] mm: memcontrol: fix memcg accounting during cpu hotplug
Date: Mon, 8 Sep 2025 21:09:00 +0000
Message-ID: <20250908210900.24088-1-ajgja@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2025090735-glade-paralegal-cdd1@gregkh>
References: <2025090735-glade-paralegal-cdd1@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.22.68.79]
X-ClientProxiedBy: EX19D036UWB002.ant.amazon.com (10.13.139.139) To
 EX19D032UWA001.ant.amazon.com (10.13.139.62)
X-Stat-Signature: rmrtd4ran75ssd9cufn46bhmoiruqgxp
X-Rspam-User: 
X-Rspamd-Queue-Id: EBB8FA000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757365756-681163
X-HE-Meta: U2FsdGVkX1/+URkPuoaSs4nSm1pG8Q48mKLNae2pDwoYhCUOcf9BeYnnjDdSdGzyoErpa15TY9tEt5G7tTKUdKg+jjcnGgxv9b5csALNUMP4zt6ezeTBeUFUyP4aFnEKhV4XDcR31ZlDbF+CgxkCKKRkU/wNkGT8R4ARqQrEP5+hQyuQnxvtcjnqMlTrHz//3BwUECu9tOXHxyKgF2m+fx5V+yejol50TT36uHvNOVhog9fJpmPr9Dqa1Uxr7n96sKvBlmy4pWOMktnw7MqxInUC4/0pEky0NCKYmdiTkqclso4Xaifttgb1tN127eRTEos8QJJz7/8qfgWEhyA+q/YATDAW52HdJCrbNzzglF7ZAWqxohqhFK8SQU9W634RlUNs6CVS3a+SBPAzSz1iLwm/KFswvGlZLNdcMRp/IWdhbFRxswO/225hneU614iVtPTzH1WDWHAdq+Ei7PyGMwjD5bBuo2LUa120txrgtvOouERg/hOWvZ61SuzB68Hx4l16ubYpTwLIeX2Nw1a6DIHAZMLLpDihffiH51qVO19TZotRguctRe6QOVN05UkRUqeAZcbWNPJTwnXxOUCkWwwmkuxQ6TZUkLWnjlUzTyLraxGdxQdlD0srqlWQtOe+Y0MMmOhZ2+SFZDq59JNQJHWCgjkPrzgHDYkGfCFFtWAM2H8YYDsnhxSkH0ZU3GmlvWNUY89PKCHU14nkiflJWu9Lp8QICy5Vjwk5EvRQgQaX4Q14bd5YdBiYOkondCLyoRHji8mSrOo9GTKVvuyfP+v6+OXfyD+Xmi84vcHDdVxiO+sFLzlc9GmWmpYhG/3ztU3+kDH5AgS39xpO08oEo3+zRj142qVF5T+xdCSdLZmrF3kHEJJZXIYLPStn+vn9eS0hB7rqEW/M05u50ln3v9BDY7w5Ol1T254X9Bszgq6xulF7X0QDNDBhsHzNH+YGjEFAokViWXFLCuSzVAO
 jEF53o+a
 8YiFjZY72TloaBErKAd+jJC4iGB/7jB1dWNmXlXCZBSyZxc83gVW4eAJgiR43z1iSUM2JeRtVOXqqcTRdYrNOHUTXioqm5hOk87uFlCK97F0s7T5IIqucWuUAu/CQm8lAj15Sh1JXz4pUFMDizNFvpf/vEKr5NDP92J7fi3EbqpF/2X/Lj6o5vVB3MwzwLzBQ4dhe9L2rIsFw0PyfFUXNKDB9y0MYDaP0VyrAbebb7dEH9BvlLHhVMCBhALGhCF0owvJzKusd05dHDjYaDmAeOX2dpJSBsf1mcLF8kHrc1paHbheQTKxNKYjI6O/gQo55OuBNfGy92Gm/KczjF53XcwkdnhGpsu0F84NgjbE5hKTajrp23PsmGclQWlTokYIX++dTLV93TYrY34kxFXdlXKe4ll1IVkEEEnuUoxnl76CyCfEjO7/7hPVKNzPb9/mrIFHLY6TXF4jdBkkXz6KnKAMS6xjpaGRoagvzaa7Q0+gyEbEKes//F6vdRczpzGtT4IwNlkVBQngmItRKVFtKZbPc0sEN1hKLO4+rlrpP8manrNvs9+//pSxDzNbdvOXevnpFV4I3QHFrDoCbUB5/MxjO6DfurcvAUFxz4XT8SV7ld8SNDrZBnJzSQ57ACjfXKwj6H5+gGn1Vv54Krn5BNNnp57MabzVooKLLEzi4WdtgI44fJdCISePC1EGmwj+EICctSrWAg6SnsHVzyKDgVgkO2pO1NdaLkVoRLf3pqJ1PxrJkb8GaazvbnYPVOb0+Q9/zeUnd3r9b/jtcXKpFaDeDBuLxC0bL0Nkj63xbn68ed17eCLS9cPAXXHV5w4H6jI/U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-07 13:10 UTC, Greg KH wrote:
> On Sat, Sep 06, 2025 at 03:21:08AM +0000, Andrew Guerrero wrote:
> > This patch is intended for the 5.10 longterm release branch. It will not apply
> > cleanly to mainline and is inadvertantly fixed by a larger series of changes in 
> > later release branches:
> > a3d4c05a4474 ("mm: memcontrol: fix cpuhotplug statistics flushing").
> 
> Why can't we take those instead?
> 
> > In 5.15, the counter flushing code is completely removed. This may be another
> > viable option here too, though it's a larger change.
> 
> If it's not needed anymore, why not just remove it with the upstream
> commits as well?

Yeah, my understanding is the typical flow is to pull commits from upstream into
stable branches. However, I'm not confident I know the the answer to "which
upstream commits?" To get started,

`git log -L :memcg_hotplug_cpu_dead:mm/memcontrol.c linux-5.10.y..linux-5.15.y`

tells me that the upstream changes to pull are:

- https://lore.kernel.org/all/20210209163304.77088-1-hannes@cmpxchg.org/T/#u
- https://lore.kernel.org/all/20210716212137.1391164-1-shakeelb@google.com/T/#u

However, these are substantial features that "fix" the issue indirectly by
transitioning the memcg accounting system over to rstats. I can pick these 10
upstream commits, but I'm worried I may overlook some additional patches from
5.15.y that need to go along with them. I may need some guidance if we go this
route.

Another reasonable option is to take neither route. We can maintain this patch
internally and then drop it once we upgrade to a new kernel version.

Let me know how you would like to proceed.

Thanks!
Andrew

