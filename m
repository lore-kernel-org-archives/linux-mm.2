Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3C3CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 17:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977736B0147; Wed, 27 May 2026 13:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928886B0148; Wed, 27 May 2026 13:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83EB76B0149; Wed, 27 May 2026 13:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73D226B0147
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:51:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A49D91C1E36
	for <linux-mm@kvack.org>; Wed, 27 May 2026 17:51:06 +0000 (UTC)
X-FDA: 84813940932.07.5C2D487
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id C982340011
	for <linux-mm@kvack.org>; Wed, 27 May 2026 17:51:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cu+uzFWP;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779904264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hS9rtV02plSUcr5CmEuAfEmwWOS8suPI5jczfgl+/Y0=;
	b=dCiphWWpZTO2+tVFfqqa41BtleWfxpO2jhRWUSqZHWnWpallbQ9MP9H/GfMQQ3lHTbQ/8l
	/AUkW3su7m6CpWk+exeblgeYgG4v5g2Zx06niRzKqP8gz/vPxsiRCLgNJgX8BAWkbFOihZ
	FJEzMZ+DVP0Pmf5Oubl0SwelJFS2zEE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cu+uzFWP;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779904264; a=rsa-sha256;
	cv=none;
	b=HiCCPqDNMH1ggTrLxS/QOrll2aQf5+vqwVvAq1VNezRkWClvUizmB9SOLUIiXM6T9YE0SF
	9jVamXjLUf95NlfeY+RiwyXt8Yp8df8Qi0+3NZA1YmJZinTsmOeGpIIoVIg5PdRBHgzhgv
	vxl44qbEqCAQLAHBGlBiiUFNDjLsxA0=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36622412e97so9088069a91.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 10:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779904264; x=1780509064; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hS9rtV02plSUcr5CmEuAfEmwWOS8suPI5jczfgl+/Y0=;
        b=Cu+uzFWPdhqlLk2/TkGth3rpxOyldSQ407UMusp4UP8dV6u/sXweGQcUOiams6O7oR
         sCA5oiC0BVDmezv9zq+4IGsqi++t4+J4q+0l16n6eNGSfLKQooDb1uDYuEWN0HribGQV
         UfksMEnm6ExSycaXmQNFcFCfe21xmgFmoeHNUnjNZinktgE4qHEopPoEX5yuLFaq3Byd
         N7KJVkcS/3NQGsbQXJ4LElPoCQ0oNIC3Svgx0opk4KTGKPktW1+e7aM89BQnuWmWGW13
         LFST46WAxehEVbonmwzPu1OhtkFcnA49X4ghJxPsL2r1bL5mbwJLsyVVeAKw1gRUMhsF
         TcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779904264; x=1780509064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hS9rtV02plSUcr5CmEuAfEmwWOS8suPI5jczfgl+/Y0=;
        b=HF3AlTAV63Kzt1ZLemdvrBgl9tA19rpP8AbfFn1YclY0Hhk5l5plU0uxCUVy7Sp3IC
         peCVEo/qCDI4b0tVmh05Ti/1TeTeJuLHfoQfH8C9xNoq97GMg5DRE3hxyxg9049Qk7Lm
         t89fmhYalwj3dCaQrBz8Cr9JdpOyseTquvLi98hgbN7y8QU4xmPSHZ4ClRlT9uUZ0LkO
         27Zfp8gKzkoQWUF5RmE+Z/KnmTJUJdIb/5q7PeGXODvaNqZh5XMTEQ24DaX2tvVVVMeB
         Rw2sK0v6S5pgbX5Y5UXXMdaatrwGhFbmQS96VXqlzHOBD0gTaqhUT0M2+hF3qynETWci
         ctJw==
X-Forwarded-Encrypted: i=1; AFNElJ8lcKkwmvnnqUmnu6OFK/OxTubbkQobrHm3+fR2oIJudVJNgOlkbbDA5v6iuW2bE5vtJEdEAWDeBA==@kvack.org
X-Gm-Message-State: AOJu0YxTH7uMEoM1gCXHS+w7MkhS6XVz82RBxixE+c0BudZk7sCw4gt4
	FpzfmVvF3kLtSjM1DQgUdz72cbqAVn3kHKH+tDhGqagdRpF3wU21So9S
X-Gm-Gg: Acq92OFXCymCA0YLVr/OTTazMP9e72QnT3L4wEF8D0V3n+APKtJxOZJizXo3Mxlkm6I
	raAeYRhrioeqqsf85og5tTSPU5xvETUb4hSxdw6hF7W9G/150UbES6/RvTlZ1wAZTWZKFeR/I9R
	jIrlH5M5jAxcYiUgVbJsvsQZPKuyijRb6YGy4JiyqjgT5sI91kzZa3GKUY8WvwQg/+pfXvD+l63
	c0dAYhHS87ELewQSP/OOfGjFKlbN8QTYO/om+r4hPo3Ngcvl02KEcdPYlP7VUZVj1iXZROeSZ2P
	yejhBYmUEgPMOlhYeMbVWUgK7gnIuJEETDZY+pKu1V+uD48nPqKhFVlnDFBEdC0qJ9duIRWZXzv
	Mis3qBPJIOvaSbyrndO+7A3yQ2HwMCYTwk0yiYmskPy6VSzgSyL2037BYXYMseBtZqGpBagbHRR
	Jn+Qqon1cImCQeXEiCCmGkr98Issv9J4lk3gsi0tB/9sQI6MPb3gE/kITnpTl0rtv4vJ3PpJVPo
	hlSKtPkvNNO
X-Received: by 2002:a17:90b:3f44:b0:36a:9d7:8589 with SMTP id 98e67ed59e1d1-36a6763a97amr26262173a91.21.1779904263550;
        Wed, 27 May 2026 10:51:03 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8520561e94sm14405043a12.22.2026.05.27.10.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 10:51:02 -0700 (PDT)
Date: Thu, 28 May 2026 01:50:55 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com, 
	matia.kim@lge.com
Subject: Re: [PATCH v7 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <ahcuEuPhyvOSaBH4@KASONG-MC4>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
 <20260527062247.3440692-5-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527062247.3440692-5-youngjun.park@lge.com>
X-Stat-Signature: 5i66ppdogfrd75t9eid85xqay5oetuor
X-Rspamd-Queue-Id: C982340011
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779904264-76446
X-HE-Meta: U2FsdGVkX1+Q0Z1+kTLh1BDU7O6PP32qyeoj1dm174gwVZzz+6TsKpBzuD5m11ya7V0PF67lue9MeZh8grpIHln3Th7aD/24ReYy5AYlMjpaBEI6DcNUBewlq488gOhJEehq0mEXeDfD/mcP74ngY0WGkd8Y1Am+qaOatsieZlkmTSTfXtkBxLlVZG92oHJNlkOx912sU0J1qb0D673E5kkxSNFOqnHOxtmBzO9nkghyGnTeyggdWZvKIVVT7yRLHszVbODuHhybqRVJ+a6SxT2xaZzAY7HbSCe6NZHRpcdiYUDM5Uhwge62x9JZ9eh/lGrLql5ybi+mY7RuGX+SGJ2h4mJc7NsEfMdCW3Urem2hA9Yzj6geoTGeYIrC+0410QR0D2luWVecOP1Y83r+qL78cFWq/Fg2DDb+vTHCnSUeR9EzVWzexj5bs3ZAllh6SKfsjixCCfMX+eK0iLr1cVHkv7IlogmxRT5QbjS4Kn1deW4ad8jwaiZSF6GuqUZVzZyYncQO03QN7oW1LaQeoAvi+19C0GA+613AVC/TuzvZ3oUbzWZ4IPX1kev2UanSvEf4CbGazI4Hf0XK7tjpDmnvaNNSpIpRTQ4JWFFw5ASgPq64CGJa9lPVs6ALylMPml8yhI/4Y3QjrVR+xxA8HeRXYeZDJyWJKhztAcucTXTF0wGPgupb+vW7v0YRacYhRnoI5Mi+WtM3CESSoVjadVFnHlVdInO/xkydFfXvSyM5ByLtTFxq0Eh3iBwZ9qc4Ud9egI3+WoLlMTXGqaH5gQwkwkc/669MwSIKJu1sqebejM0jhdw+mX3AlAXuEagYe5sJKQ7L6HwJhH5J/ZOLKZwpZuHTKWErFQw+U16yaXmxm0sIYaqUaqhSexVi2903MexanQRsCpRrWXYKRlJunyAj8WB+AYxaUTa/0at5m+Zd5Y1dMvQAsLaM+5BqlojjrRN7hoCOMhc+tFYcIB8
 6zLflxhL
 BWjQJf+mUc2VyxNpTDmJlcHPZpLG5r5nbWLplNG8875P2SYaPGUrhr34wdG5wsAOHjy6C0p4BEfML4Tttmwrtp6MUlKpHxFMrWFgldyPB12E+76uTi6yEeAoip+qqKFOVVuiRcJDiwnVQ/B8vUvPUPFXuzP0/o4DACNfE7YCeTzdKcUWkv/VxIIzMnsukyKsLZwIR6TYM1BBm9d1i97IXHnkkd6aNIOo5JJ+TaNcsjPbIxbInQIoemSwfNChE6lX3vcIk8neFAee55srF3025YUJe2goNfB/dhnbY7lLeoYjIdDSCbbKk8+vSDH3IrXAQy+Y6XjMLkCnlii4iNqjVIEnT4klGhwQ6FHjq8l706J1XHPnkqIeYeKjHGU7uqwXCRDiqkLS04svmTcUl2vCoge+sTObxbAlhjqPdf5AyU1gITCx4FUO1L1/6BopuokN0QcAHFnrCFD+Lj/ydJihdOXcU1PCsBRH+tCoc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 03:22:47PM +0800, Youngjun Park wrote:
> Apply memcg tier effective mask during swap slot allocation to
> enforce per-cgroup swap tier restrictions.
> 
> In the fast path, check the percpu cached swap_info's tier_mask
> against the folio's effective mask. If it does not match, fall
> through to the slow path. In the slow path, skip swap devices
> whose tier_mask is not covered by the folio's effective mask.
> 
> This works correctly when there is only one non-rotational
> device in the system and no devices share the same priority.
> However, there are known limitations:
> 
>  - When non-rotational devices are distributed across multiple
>    tiers, and different memcgs are configured to use those
>    distinct tiers, they may constantly overwrite the shared
>    percpu swap cache. This cache thrashing leads to frequent
>    fast path misses.
> 
>  - Combined with the above issue, if same-priority devices exist
>    among them, a percpu cache miss (overwritten by another memcg)
>    forces the allocator to round-robin to the next device
>    prematurely, even if the current cluster is not fully
>    exhausted.
> 
> These edge cases do not affect the primary use case of
> directing swap traffic per cgroup. Further optimization is
> planned for future work.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9a86ebe992f4..1a2d29735b71 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1365,14 +1365,18 @@ static bool swap_alloc_fast(struct folio *folio)
>  	struct swap_cluster_info *ci;
>  	struct swap_info_struct *si;
>  	unsigned int offset;
> +	int mask = folio_tier_effective_mask(folio);
>  
>  	/*
>  	 * Once allocated, swap_info_struct will never be completely freed,
>  	 * so checking it's liveness by get_swap_device_info is enough.
>  	 */
>  	si = this_cpu_read(percpu_swap_cluster.si[order]);
> +	if (!si || !swap_tiers_mask_test(si->tier_mask, mask))
> +		return false;
> +
>  	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
> -	if (!si || !offset || !get_swap_device_info(si))
> +	if (!offset || !get_swap_device_info(si))
>  		return false;
>  
>  	ci = swap_cluster_lock(si, offset);
> @@ -1392,10 +1396,14 @@ static bool swap_alloc_fast(struct folio *folio)
>  static void swap_alloc_slow(struct folio *folio)
>  {
>  	struct swap_info_struct *si, *next;
> +	int mask = folio_tier_effective_mask(folio);
>  
>  	spin_lock(&swap_avail_lock);
>  start_over:
>  	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> +		if (!swap_tiers_mask_test(si->tier_mask, mask))
> +			continue;
> +
>  		/* Rotate the device and switch to a new cluster */
>  		plist_requeue(&si->avail_list, &swap_avail_head);
>  		spin_unlock(&swap_avail_lock);
> -- 
> 2.34.1

This part looks good to me, the known limitations are not regression
and only for tiering, so can be improved later, and we do have plan
to refine the priority / rotation / pcp cluster so they aligns well.

Reviewed-by: Kairui Song <kasong@tencent.com>

