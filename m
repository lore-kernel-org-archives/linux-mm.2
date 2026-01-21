Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1AA8C44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 11:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27AF6B0005; Wed, 21 Jan 2026 06:22:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1D16B0088; Wed, 21 Jan 2026 06:22:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32386B0089; Wed, 21 Jan 2026 06:22:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D53596B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:22:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79658C37F8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:22:11 +0000 (UTC)
X-FDA: 84355732062.29.86110ED
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 54B1140007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:22:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NEErvpnf;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768994529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqhAFzJjI/DgbR47XPHmTUNDQmb22woy0wLaS+F3G48=;
	b=AWXfl0iMSsTeshnufkDEJwRRb2XsrXLDdtBp0J2aRbEbwcrjJvpG7yL9v8Ye4mAN6UZjrB
	m2k30tjjRxkB/wpzuvJn3m4UZq4flYfAjqQNmaPMXC6FNejLa5yC8vGtpOaeco5yw57R5L
	U1hPA2uxO1Szw1l6YVXEOKjW+3gJoSo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NEErvpnf;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768994529; a=rsa-sha256;
	cv=none;
	b=dgGJB0Qhu9dbUxxiTzcHsUYCYc0D36hh99aH434tS2yeqZ+NTJdNEDP8Gs8HCp4XhvHgCn
	1AZ451ZYkUSPFYtlEWAole8nc2jVgwVmM+x+oq5Uq1HHNfQpwz2IPcBHJZyWx4rpylg407
	d35BwGS3wbwvtqwxpTuC0qzkx4OnWN8=
Message-ID: <b7ae0bf1-2a37-4848-80b3-7affa25cbde0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768994526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqhAFzJjI/DgbR47XPHmTUNDQmb22woy0wLaS+F3G48=;
	b=NEErvpnf+3SVo2420D1iw9gprXB3BTqiAM33r/uRjkK0hi0Y/fuIwdNJfhWFkwkYDC+c4G
	qTkD02heYrDr8N0t/aJQS1SfgYz0ybVwc2YeKOLhsTkwZAc/x/QdpTcbg8qW3O3J0I73vO
	Ce0rkbMrWZhoouAnbTdHwgoRcCkUAvo=
Date: Wed, 21 Jan 2026 19:21:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 26/30 fix] mm: mglru: do not call update_lru_size()
 during reparenting
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
 <20260115104444.85986-1-qi.zheng@linux.dev> <aXBNuLDtUmDVyXTv@hyeyoo>
 <aXBT0R42Xuzwr3Ns@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aXBT0R42Xuzwr3Ns@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 54B1140007
X-Rspam-User: 
X-Stat-Signature: ohbh57ad8bfaieuxnn5e5q17ma9fo7eu
X-Rspamd-Server: rspam08
X-HE-Tag: 1768994529-184259
X-HE-Meta: U2FsdGVkX19eU5w/XrUVku9rGortpiciZiUN1oQkQxfsoSoJltrSiiRuilP9s0IFAQZwIDHBKl/uptugSMAvKbAI+Cv2RVSqnTQiSmMh+rfkytnNuddWpU2JefsrwnNXELwG3jxM060w0VMLG9Ff4Ppb/r7uwXKfAaUnDCZm9EKwyXg2IXId2jPJ0c0NE5WPxxY6WTfpaWLExOfOEKb0ZeTxNNJzqHiu3E1+5+nXStsanEJVaKWYKQCcKr6JLBgvGFPKzvwQSW5BbPVS9MH75x52BZAMMepOjYfBCAFXqpPkhSzSxYMscjzTtsoWGub9B5zTWLwXwLF2erWhqTs5o493/JTTq9DPc4WWa1Da79tKCpJYC05lsVPrNKYdAj9htC52AlJXoirotIurjQsqq3f/iU0cIe1G+Qkr3ANOd+FxTUo/AnkIqRa3kjJSisvMG+hpaseDwkfey7CCHKbUBcAEge6KJDImMvGGKiYW97PU3H1WLiXRQQEpqOATz5/gpsSmU5ONoOgWXU6sBgyhQ4B1IrYk3YQMSHfD5zj4wYE81+Eo2V6/YMnzHAYU11SoLtiHuytfFuLwgxHppBe99HQhxtntpjo7+cjmCoYVJJQ7tFG/g87NOvn3g6FTfCJyyv76eLdjZL1PU7tK/OXa7oDFc9O0eK2Pg35PCzK8o01gCKegId+FWSC3YUmApzxqeoPWA1KzR3Y7rtM1lVOMcECGdiSIKpxF+ozDVGKswJR170Aj5BZa3epGhWIY4w2SbYVzc7FKfRKgLFTeyAXESQi+vUWxmHUVYDoFaWFtAbvVwUcL/cZSA2WJ3JSoPWWijOnCURwHf4jzdA81Njf8IH/JF7lYSIyqhF6a8toml5wft4UbGBw5A/Oh+qsZ11e2E1olwY3Nq4TFgf5jaXULQlVpgv/4iN7Je1ELKCujqYxN3EE0uQdA13XR8wHo8ZSLg7D3Z4j+AgafL7P8X6W
 l59pl9BU
 IilNcNoqB6LgiAnEta/AKcUznQO2hnoB1YBYZ6OBXVIdDVv7MYrHJsjGp9K90yKvsYwnpNaUcewI3hM6DjvejJEHHB7PDrBU6Ym1UtnCRufRWq5tU0aNKgBas9opbH8mV8thpK21RzrZbgVflKlu1V9QnZqEWckgZAdX/xnn5QlA1eED0QBZyO44GLLHRHAAY/Zt+N/T8mpOlBF/k9iSeVZPvIB5oC59cbQKT3Lr+qzQcvH3chb2KKmNKhxQ/TWCIHMyK4ZbhCIafuabnS9biKUoVOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/21/26 12:19 PM, Harry Yoo wrote:
> On Wed, Jan 21, 2026 at 12:53:28PM +0900, Harry Yoo wrote:
>> On Thu, Jan 15, 2026 at 06:44:44PM +0800, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Only non-hierarchical lruvec_stats->state_local needs to be reparented,
>>> so handle it in reparent_state_local(), and remove the unreasonable
>>> update_lru_size() call in __lru_gen_reparent_memcg().
>>
>> Hmm well, how are the hierarchical statistics consistent when pages are
>> reparented from an "active" gen to an "inactive" gen, or the other way around?

Oh, I completely forgot about that. If update_lru_size() is not called
during the rreparenting, this issue should be considered separately.

>>
>> They'll become inconsistent when those pages are reclaimed or
>> moved between generations?
> 
> FYI we've observed this while testing downstream implementation
> as it led to MemAvailable being unreasonably high due to inconsistent
> statistics.
> 
> The solution was, if lru_gen_is_active(child, gen) and
> lru_gen_is_active(parent, gen) do not match, # of pages being
> reparented must be subtracted from the child's statistics
> (and up to the root, as it's hierarchical), and added to the parent's
> statistics for the generation.

Make sense, will fix it in v4.

Thanks!

> 


