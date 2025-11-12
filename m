Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6036CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03098E0005; Wed, 12 Nov 2025 02:07:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDAA28E0002; Wed, 12 Nov 2025 02:07:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D177A8E0005; Wed, 12 Nov 2025 02:07:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C12B18E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:07:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6408D1603C7
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:07:35 +0000 (UTC)
X-FDA: 84101074470.03.0F576D9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2BF0A0009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:07:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=doEOEIfp;
	spf=none (imf25.hostedemail.com: domain of BATV+e9bda1b28d6a176676cb+8116+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9bda1b28d6a176676cb+8116+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762931254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5+DZIdYmdMUBYPf9tQoU3zDHSAGhrCH2u+Z/t1MhZo=;
	b=K7T4XMgPi3bFpl+CQ/nk/0qItdAATPBMeEf0igYRqLmU6/RqZfA10ICdwmNzpHPiYGAAZo
	tUgAv18kTFc1Zqy/m7jG8iZFRSbvUJLfv7JersVkXHM7p/seInm4TpzY8N7bp1xKi+HfGh
	6YwD/fbunNPSqKzRylesGoOSZnF/+4w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=doEOEIfp;
	spf=none (imf25.hostedemail.com: domain of BATV+e9bda1b28d6a176676cb+8116+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9bda1b28d6a176676cb+8116+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762931254; a=rsa-sha256;
	cv=none;
	b=kmdeqvOxmR0dT1VaC9saqYUMEISEVIG6UNiMQZ3gXyYSIGn3bG+ZRKURfQ//k2v0DkKthb
	TwTvE8tX6QA1ezKBZNF01DJXB0Fnbh7+77Lr1ubQeZaeVKFLRDOb3CUXDkwH2tyQAZ4Et+
	AajJfL2x4FC20OUpWUepfv99iAV60Do=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n5+DZIdYmdMUBYPf9tQoU3zDHSAGhrCH2u+Z/t1MhZo=; b=doEOEIfptDBs3uw6k01V4qPd5y
	7xc4xmrg/SbLNsi5vYU4DCPZWWPSXq7/FsoY9skCInDV84g6MmFDBVbxQ8mtCEZd68ElmMnB0OsRD
	2bjVhF3SCCnvyar5L44YeZgng1WxVtltRo3simsOqrl/4vq/RyhFhjJPR40TmVkwej919EqAnP3d8
	Ynff4ZZWbx81sGEEWzLxp6L8X/htxV8jsF5qQjvVP18hlUg+D3QEFbTGyz4vqrmXPG6GV9VUK+ee8
	sUrbVwk4xkn/pYQ/mnDRPzGJu9nqGd0EN3Xr/87nwoEb85Qkr2BGL4eYXJNoJ3HkPfEuEYXeyt+s3
	+LLKvT+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ4wz-00000008Fz7-2dPw;
	Wed, 12 Nov 2025 07:07:29 +0000
Date: Tue, 11 Nov 2025 23:07:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: syzbot ci <syzbot+ci9989da8336cb2bc7@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, hch@infradead.org, hch@lst.de,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	vishal.moola@gmail.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRQyMck_MeVvvCdX@infradead.org>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
 <69123b72.a70a0220.22f260.0105.GAE@google.com>
 <aROasppMPmek9Afh@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aROasppMPmek9Afh@milan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: D2BF0A0009
X-Stat-Signature: zj8wa71xgijykjwomsio98ukik5kkyhf
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762931252-228228
X-HE-Meta: U2FsdGVkX19NiuaouAtHq4PB/cGJ6Wruwh5ZXuN6CtpEES7AMx923oDhLynleaTN13Yb2Ah9u/K+V1vfvIRvz3DKJ22rgTQ5hoAkQ4aHI/eD/4wWM7EUM1L982i7/a61qzCoa2+on70UVoK9ApejjEiPhEj6hjFMpLpq1GVenJ62ZU7x7PcAZijXwqhanIBtq1hqNPC5+oCbWFrT5ayEXmP3XSZ7O8bdxxp4Bw5OHVPr27/V35TinuHdCYpEPxfuFqUZ9VQqiKiGk0Il/uFxQ6JEj5itBWXMQzexKp6VyqkoG5KMslq4ZBYWD0m76XMOsu+vTFIrzM5lXH68R7uWtaLun6XWPQwDklFw5gPcq0YRh9sloXAhpJTUy+K7K98Qc8M5mG9GDHPgrjrFyn58ov2/8sWJxEOMBmvin2aB8pGoqYoDug3UcdToB1C/VxdZNdXCxHw/fNKLOWct6OVJ5dIZsTAJ/80nAiZyvTo3kuDOps7UvhDGjuLZa8Y2ppo1PIzo+Yw94fYMlOXK17AZVHyGrI8z7ZPtjoZppBIFrx3TKIXCrVfMCgyv5neeKqchXLsKbdQXd1cdEF75AjhuFlT48Xl1SPTZI4yirJRHxNzsYuVLQRbiwHNQ4YKFlMyjkDAnYBVKRMdSTVztLN0L6pijrWbCOOWzobY1vhth6kmoYZCXs3wv0ldhobufFJqdDfIKXwIhl4vCGZgUJYOcSkuU6SmI/MqvkaOyYVGozRyTAwGJTzSPare3B7cwGfftlMMsFIHYdOm3FMAj58rZOafSzbvTnjGENEUOH0rbr7AsFKqf8xdS3XU4/QcfEvR8EBK0fssoJZovko8z80qO30gWYJFoVi91nD8/F7gCrqr05GCNleDCpTFHu2/Srm5gQlgivav8GKM39Vqu7OIQLbQt1RrKklkZVjG4SGt2C4baKz+YwoV/WL+b7BSJKKIGBzixSuazvdw2xfpzkG6
 SzCQXtik
 fiZo5bfbBTVmefKOuI0zyMgs2GIurFdwBc1446ADP354M6FWti8nlCELZx9yL9lnH/ISkcDD3hBl3FDJ6dxJ65s0hNywT48R3zQ14y05Ko6yWD9S2FI/HP+Qyr9WUz8uqicKZWsAsHNXBInOgcPmp1uDLBswglWoFwD7wqb3aBpNqx3CyI9Tu7HoP05R/TGZbEnwIp5qgDEFFTiiY6lp30bJm3C+0Zco6a7Z8ftmkjtj11qk398bE3/2dFfLhp3Ao++wpYc8PKpZ8csMh9Vt3N+pDsMLLlXEQ1OXzHp6uQofcPOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 09:21:06PM +0100, Uladzislau Rezki wrote:
> > Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> >
> It looks like we need to add __GFP_HARDWALL to the white-list-mask.

__GFP_HARDWALL is part of GFP_USER.  Doing GFP_USER vmalloc sounds like
a bit of an odd idea to me, but there are a few users mostly in bpf
and drm code (why do these always show up for odd API usage patterns?).

So I guess yes, we'll need to allow it for now, but I'd like to start
a discussion if it really makes much sense.


