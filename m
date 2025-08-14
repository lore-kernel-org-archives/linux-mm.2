Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F43BCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 16:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8709001A6; Thu, 14 Aug 2025 12:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97839900172; Thu, 14 Aug 2025 12:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867699001A6; Thu, 14 Aug 2025 12:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70910900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:27:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF8D7140694
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:27:30 +0000 (UTC)
X-FDA: 83775893460.25.5152038
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf30.hostedemail.com (Postfix) with ESMTP id C057880017
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:27:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=j8zGTjgi;
	spf=pass (imf30.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755188849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKRpkbuM0/E1wsSLFsbRln4KtsFPqU6wbMr0a/aHKeA=;
	b=pb6YLvkvKpmdD54rtZXMVh5nlPxBup3FXtJl/ivCer1/YVRe6gkMw+/79L6rcZdUXOH38N
	fAEvp+HGB3KwfXkPmm6GSjHNAnqOBew4B6UPFAR+7WyZbbAu1Fy+iqidrNfR2iLmAaNMPK
	zlo3VeQYy2+sv4Esj7IjXvh5GJ/9zjo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=j8zGTjgi;
	spf=pass (imf30.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755188849; a=rsa-sha256;
	cv=none;
	b=Xw4vqrpLN3jIa7tU7McPoJR6urhZyHk4nFaPGNc+iNY2+Jf++JILj2yaY/i5xsdS8jibX7
	HkcwT5BPkkvgMWh7NpvtCrlWbRAojovqESKLSXdYqwYSic3pJMyoG5N59lj96icQ6OtkHx
	IxlsPndHQjOweN/Wxc7/zINMbYAYqb4=
DKIM-Signature: a=rsa-sha256; t=1755188844; x=1755793644; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=GKRpkbuM0/E1wsSLFsbRln4KtsFPqU6wbMr0a/aHKeA=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=j8zGTjgiu1Lbnh6rbl49SMWTbww4nmtpvOx4j5K9rUFmeSWNGesTct+bV42djMrLiH/FD4mRmjhcOwc6h705IPcgywAdEGBDHgTXHReEDGwba3mM1Ce4YtaUuXxfz9/lPBiXKI4OV3qEpbU8fi7Gf531nRoGCltjXZbkwX5rNDM=
Received: from [10.26.1.187] ([80.250.18.198])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202508141827234129;
        Thu, 14 Aug 2025 18:27:23 +0200
Message-ID: <4937aca8-8ebb-47d5-986f-7bb27ddbdaba@cdn77.com>
Date: Thu, 14 Aug 2025 18:27:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
 <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
 <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
 <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
 <0f6a8c37-95e0-4009-a13b-99ce0e25ea47@cdn77.com>
 <qsncixzj7s7jd7f3l2erjjs7cx3fanmlbkh4auaapsvon45rx3@62o2nqwrb43e>
Content-Language: en-US
From: Matyas Hurtik <matyas.hurtik@cdn77.com>
In-Reply-To: <qsncixzj7s7jd7f3l2erjjs7cx3fanmlbkh4auaapsvon45rx3@62o2nqwrb43e>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A00210F.689E0DCE.007A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Queue-Id: C057880017
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: igandiz6jyydfra6yhzb6fn3b1hwtihz
X-HE-Tag: 1755188848-524034
X-HE-Meta: U2FsdGVkX18R99bXUVoAcrHL44E2A4GZQBWueYLHHhcVR5GrIQ2CNZ3WExvT67ispOvTB+yw5MK/vYRyBKWXiSI2iGp5pZCmmM2zAYBlgmfCY+/tNZcy/TxMz+OT1+5QLYBaAANvN/uANGwp1jm1RRfBYC3GTesCuyBNn0YyYm7pGrth8rrh1rwY3pNkvrXuAmgp3QKaBblwmCGo5fmDOBNlWhA9avQ87RG0FFi8KibTcQ4CrkSIqjiobqeHqdgOErTXV3ZSWtyoeQsp4Kzb2urU1KFN3N/pMAaStr18vi6aavf6bPKVUxun2ZbXdoPGEmo1b8tueRbwk8pr7BwbMA+OnnXSXwPLFQe80q572ZUchPu588kg2ssHJU4Dy9lzzl8MSw5vcGzswtxluNd9iG1RTPCmUh1zjmlBReHdMgkhw34YmLnVbWvwxLtYM9ducp5lHbAhT9DEQX/a/Rm41/ONnTSAkG23ANjkZQKC/nEXtpyni1jdv6ms+MlEMy+/KO8liXRAas7wdfjlo6hH4UiAsqtQ75c3dHyxBVKZKhs1nbuYTMxikMZ7wVh6h9zG761GCGvrn3WX6RsbxU5ua9INPZiNeKi9i4Ox0unR+K4BUxTEbBCM6NMrG6+QysEpqSmkGIajkUocp1KSLgx5ys+YolQr+6XW4NC4Ke05bsmYR/CRyXI/vwCk1fAw+aElfmnMG6VTpeNgO2TfPIeUA2bIQKil4LYDn2103hS1oiUzSjg7LTZukzue0I4A5pB3XK3At+X/B6SWnXFLV4X/IPoeaBtkoUaT0s8Pw4X+dQi2UNsJGiwdafgAFehWk9lquDRpXhVxfwjKklhvRoyr07OIfqh6SitjceMtbVcBQ1Xl3WApo1lqVHOYA7MEqrbAtKw7J0TRDT7wzU9l030QQ4hkEYKsD+4UDLWNXuyRbRs2kb8uTgWNjK/DkOt7xVX3cKRyH3/yKMSli9KTZeR
 yQM9Yoth
 FFMxCzfUEBAYr6J93jaYMbmeyXTra2lcp+zTKjwQ51iTmrT8WDIbbHXHfyby+I4M8mmrlzaioKpTKFE5q0gMQOjglFg2j+59ujNdjsdyvAKX3qxEdj8Mty2PfClzWbvGmKSP8xwVwKBnoRnRuCYlOFIVs4f7oX8asBaI1WS3yflu+SeOhVr+La/bCX2P/sIz4+lmZG6YMj0tFLxDXeK6FLQ6nD/G+t0KOlFHlbYJTOf6Hha8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/25 10:52 PM, Shakeel Butt wrote:

> We definitely don't need a global lock. For memcg->net_pressure_lock, we
> need to be very clear why we need this lock. Basically we are doing RMW
> on memcg->socket_pressure and we want known 'consistently' how much
> further we are pushing memcg->socket_pressure. In other words the
> consistent value of diff. The lock is one way to get that consistent
> diff. We can also play some atomic ops trick to get the consistent value
> without lock but I don't think that complexity is worth it.

Hello,


I tried implementing the second option, making the diff consistent using 
atomics.
Would something like this work?

if (level > VMPRESSURE_LOW) {
   unsigned long new_socket_pressure;
   unsigned long old_socket_pressure;
   unsigned long duration_to_add;
   /*
     * Let the socket buffer allocator know that
     * we are having trouble reclaiming LRU pages.
     *
     * For hysteresis keep the pressure state
     * asserted for a second in which subsequent
     * pressure events can occur.
     */
   new_socket_pressure = jiffies + HZ;
   old_socket_pressure = atomic_long_xchg(
     &memcg->socket_pressure, new_socket_pressure);

   duration_to_add = jiffies_to_usecs(
     min(new_socket_pressure - old_socket_pressure, HZ));

   do {
     atomic_long_add(duration_to_add, &memcg->socket_pressure_duration);
   } while ((memcg = parent_mem_cgroup(memcg)));
}

memcg->socket_pressure would need to be changed into atomic_long_t,
but we avoid adding the memcg->net_pressure_lock.

> We don't need memcg->net_pressure_lock's protection for
> sk_pressure_duration of the memcg and its ancestors if additions to
> sk_pressure_duration are atomic.

With regards to the hierarchical propagation I noticed during testing that
vmpressure() was sometimes called with memcgs, created for systemd oneshot
services, that were at that time no longer present in the /sys/fs/cgroup 
tree.
This then made their parent counters a lot larger than just sum of the 
subtree
plus value of self. Would this behavior be correct?


Thanks,

Matyas


