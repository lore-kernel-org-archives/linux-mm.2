Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A83CC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB176B008A; Thu, 10 Sep 2026 09:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3824E6B0092; Thu, 10 Sep 2026 09:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA0E6B0093; Thu, 10 Sep 2026 09:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5EE6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:33:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0DD8A4FA4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:33:22 +0000 (UTC)
X-FDA: 85197944244.11.2471D09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 014F020013
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:33:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9J3F+S3;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789047201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lftml6AJcq9A3OGxnesrZC+T3UxNownm0IfBvjzdSl8=;
	b=Mlwx+NScPtha4WykNVGynq1bFt1ZjIVbYcLObgrQ6O3Zx7SnYTHtwrFbDW5rLABQI2xKnL
	qS49OlaYd3MSCx/UN/fUkErQwKiIIz2SXM86JR81qxgThbUCNL3+2uvt3Aqvuu72RX/g7n
	5hAFWjIWX96hbLU6UWZZEj+SEc4lnA4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789047201;
	b=6yde8f8xVam4YoLPOb8S4bM2ecZ5JkY4eiqaW6QhILLdsmX1aHEZwEEL2N+NCIP7moPXvj
	BodbhWupNvCpZ2VIDuA5Ltkj9gIlqSujEO21I+Vvy+/ld5+cd+e+QjccPbHkp6ybtp66x5
	OViaD5sxJV7jsbgoZ+kVnjdck9LuC6g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9J3F+S3;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE80443E41;
	Thu, 10 Sep 2026 13:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C815A1F000FF;
	Thu, 10 Sep 2026 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789047199;
	bh=Lftml6AJcq9A3OGxnesrZC+T3UxNownm0IfBvjzdSl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P9J3F+S3y8d1fPxy39R2EfAtPQImCqmyD6WsXLMnoyJ03DnwMyvctJAqB2jE7EOj0
	 ii2cRCVuHh9iN3bOwEi89Tgop2GwedqfXvOTzRPZr7D1BhukAduO3wMzErYtGxTSUo
	 +z/7OY0BUD/NEy0f6s2GSKpF9zJJrDgpSTmc3uhPk7tiJfrEgdrJ2m27sKSfjUM/Id
	 V1cuje2kQEJMmzoSeZMXSR3rkDvr/3ks4VpRtLMTgrBnH95B1RvADu+l6+q2xkk/wK
	 U/BiJF1tlvwNC/9YCo2mIYe+Kn0DTBvXMItKlm8jYbRpRu53wb/aGb8SbEcUGpXI5G
	 TJ02MPWKnfc3A==
Date: Thu, 10 Sep 2026 14:33:10 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/12] mm/sparse: move mem_section init to
 sparse_extreme_init()
Message-ID: <aqKxAhOGpUxyjycf@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-1-008fc8d579fe@kernel.org>
 <aqKnDa6ukWwAXs19@gremlin>
 <ff5ac35e-1dfa-483c-82b1-0e542a850550@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff5ac35e-1dfa-483c-82b1-0e542a850550@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 014F020013
X-Stat-Signature: xr5fjpsk1ohpjdbx9u5jtizozhhugqin
X-Rspam-User: 
X-HE-Tag: 1789047200-868524
X-HE-Meta: U2FsdGVkX1/dPRaAL+dD3Q2wqBrxtz4E9OuWRpIi0K3ks6YsaROHqiiQJNt8ghtyYM1RMRlT4h25Hauol5I1JiodgdxCLvsnpYg8YmDUoo9430rvF/mGeqyCYuEsRbv89t7iyYVB0uOdbo2fGqtY0PSLUrYMWukFBkhDEQkyaBJfTQ60xP6CcDzwjB/uwNo7hCLDa87+NSdLeqPEC7MGsBJKFpBMU7xdiemEkGT6Paxeaf47XOuwsdoiibA4g3UdoY6jY9uY0ri4hONhNU2tUqPugXy6F9DhawJ2Sw+z4CgnGselCRvMv8o+2s4Ltq8eJwKQKLD1Y5i1arBgGWxAqRqSOTYIWCD0VXXZUedj3Kv4dve2ZrpSfV8OCXb5eNTHLLBmYIpx9Tyv9U2XOS7Vqe0viIH44+iku7YEqvg9o/NwRM7C+0jzDpH+YwhAgcHnnBHibavgmFS9ywzHatBiAX5oKtA0Ijg8fstiL4fUHck52vGHwntGekF2Wn+v9SRVkdsxvXZAOyEjVRB1og1oBqRKuN7YwSPMI3V3zIOJRzZ13xLbmVOFuUmS4c7FI0iWjUCqzdi8hEugDbkcdOvzYN6ReCWyymBc3ZdsGROkXIAKKoZbbBUJtkZy+a02e2HtlIb+++gKxMyQ1F0Lwpm4s+n2DgQeIxX/1zcJnnMhByGv9UW+WwV3VQ2z6DBBNg3y9EGCv0z73ga9nq+/ZG1EIweTbHLS9KUjknHfCulU8XfucrjPNng0tDQKvaIOngL4qLTAdnes/JfmKMiGlHMcfjrtLq9C7bQE7u0ABTvUFqGpHrQfcGcaonWqGF/1wq9csQOeNWy9UGAv80wol9TmZyBKgUzR+0/yu/62/JkyLTzwUYQpukuwb5zm/sf6fBVpCLLgYHe1FoLq/qqGpsD3qHwiTAY4iI6iZhnG458R2tFcAM38OqnMN4eLyi7ceRgBQb/tS+gCFyeC0rwURxh
 b9O3mZrG
 VE6fz1/k5uUiz1QcAxN+EXrPUXUPF2mGQreVWBhBJyieAllFepTNEpO2qusy9w02HHEHdLvbfAQPRknCoxBawwtBz+mZQHZQ12Q4mYGdV99/9Uuaztr47vb2P3/e2fhojFB0iwbs+xzBT45qKLbH4b7RMhZkv+k7d6WpM9BBPaDVfh+kdri9S8TkYgry3xj9DNcZVBfotDBl/NouJOzx6DX86gw1tSgnPmUi87lQYTQjQe5WrtU0+7YhbOWR3PgDUeL4Bt7U60ZjuZOELz+0Bw9Yf43udMvWNoKIfOodnH0tHP3oO9HQmLicTS7BjDwFT0qoe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 03:13:26PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 14:52, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 09, 2026 at 03:32:54PM +0200, David Hildenbrand (Arm) wrote:
> >> Let's just avoid another pair of ifdef inside a function. While at it,
> >> switch to INTERNODE_CACHE_BYTES by just defining a fallback in cache.h
> >> as well, given that the x86 variant already provides one.
> >>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > Nic ecleanup, one nit below.
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> >> ---
> >>  include/linux/cache.h |  1 +
> >>  mm/sparse.c           | 19 ++++++++++++-------
> >>  2 files changed, 13 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/include/linux/cache.h b/include/linux/cache.h
> >> index e69768f50d532..b6e857b985bca 100644
> >> --- a/include/linux/cache.h
> >> +++ b/include/linux/cache.h
> >> @@ -89,6 +89,7 @@
> >>   */
> >>  #ifndef INTERNODE_CACHE_SHIFT
> >>  #define INTERNODE_CACHE_SHIFT L1_CACHE_SHIFT
> >> +#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
> >
> > NIT: 1UL?
>
> I decided to replicate the existing
>
> arch/x86/include/asm/cache.h:#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
>
> If the shifted value would ever not fit into an int something would be
> going really wrong ;)

Yup, fair enough!

>
> Thanks!
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

