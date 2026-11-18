Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D2D606A335
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TvEqUEM4
Received: by kanga.kvack.org (Postfix)
	id 8D29C6B00EF; Tue, 17 Nov 2026 22:29:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8838B6B05B0; Tue, 17 Nov 2026 22:29:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775126B05B1; Tue, 17 Nov 2026 22:29:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F76E6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:29:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 381231405F9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:29:51 +0000 (UTC)
X-FDA: 85446810582.13.5064B9A
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 821E4180002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:29:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TvEqUEM4;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794972589;
	b=pVPU3ovC33/YTqt+LX1/TsuxEFdyQUFdlEicagRr/9P5finY46kTrMn6Xmvb0qEghVxwpI
	+h+7L8107ubJ6bMpcHnr847zvfsaY65t6fzHIfTxpcXot/6qI3WTl+RjwMe+kTOSxQFNfk
	GtzjYe+LEdHbUfrfeE4gp74y4LCBsKY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TvEqUEM4;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794972589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMLr7cDs8jSU5K/R3Qlsx01wbp/x5n9NRNsZwAR7Ef4=;
	b=wM/b/gzu6KVnna6vr+IRtACS/4wbsyHGR23h6bVkqpnuDEW+61yngBg22DxhpoSQvzsgjd
	9eRZPqUc/zvAjH6MM1aQSZxJlWkqHVULf16RMsnAKWh3Cw4Bl+e2PjUfqnK6X/o280VnFJ
	jml7SOGgVx7PWG2xriDYHJhC8QafIVU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794972582; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IMLr7cDs8jSU5K/R3Qlsx01wbp/x5n9NRNsZwAR7Ef4=;
	b=TvEqUEM4LZK/cCDFe75dqgjFqc+A3H0IDYhJzLCj0RU9xeehmF72NUMqZj2aCvwWoNqK+N13bnlIMokeMWkosztjWhO1Uonn9xMQ02NJzN/p2atOAFzQ3KzRMEqe6QVI2bcNuViZFZwRC5HQZPyN5Sx4mPePCK05uq3MXfdhWqg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XF.Bvbd_1794972581;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XF.Bvbd_1794972581 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 11:29:42 +0800
Message-ID: <8d90ee6b-ed72-4ace-b667-42e35c5baa5a@linux.alibaba.com>
Date: Wed, 18 Nov 2026 11:29:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: avoid zeroing new folios twice with
 init_on_alloc=1
To: samridh@modal.com, Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 821E4180002
X-Stat-Signature: x7kdawxhwcb4kjnxztdmracdeduhzf71
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794972587-701448
X-HE-Meta: U2FsdGVkX1/c391lrRj4m9Om1Fr8/idToDmPuAB7/nDeffkM/aAZgJdFUafVgOlhg9ByqwpJQRm4PNJ4xwwyS/UjMDaZ4ir7V83Zoi6gS5bVcdPZxyLAJ79CbSKhk4XiD2uTyMpNtIpHSwuhNYeNmNGcfv6UGLNfQBokie5s2oCC/9aPz8OEaFc9IH2d62NRsDIklQhELlB/CcAwgzGJkh8uzrjicuLuopYIGOEMy2jaEVdzVFJfQf5nNHoaKKvpjvG+2lGOBIK0/6FyU0iwRueTicVyjJymX54qkWIt1aY2mOYPKgB18AP1uXYNE8osx5rIk1qb6wyX6vPxSwmP1WoxXjIzsRX2kp3qIAoX6YGAp3N9TwDUoRVij/toIsOlAEJKDv6CoSToQH9XLlbECp64vVc9r+uc3bFZmv0lkXCX4p/uq/xCHLvA4Fqnj7eyeX4Q4fnySHe/V6pddfOuwZlQSu4K8vGxZAl6pDYDNo5e/XhtqRqK+qhv+t8VB4gvc9RO9fOsztCTk16oVjc8OTvXboFywjQGNaS+bOjX8Iuas2cHOGnQK7/rPlQZvV6KsLq9lxyhnBBC5QAFMEwLy1JHE4/yiZ+1kZJWyiCSkE3k6iTI3GQJbAD0CgvDdHtTb4W0IjDZnVsQFv0Fjq8n+tHaFeJsPNh06BRoBOiLO16QfIsBiPQ77lOeLcR2yVepZyS2z/B1I3+4CfbscVt+Z+TBEJI68C14VwFEWzn4dPdxyFb5/3dO542ZXrd5KK3WCgjJxX6wi7D0lMJndzD9/jo8wm/0aLTnY7NvWhyDqzSNIZK4/8wXjJZH09u4E4VKJTzznNgMXZgcxzCA0v5T/qz7loN9oOfC8O2Wdz0jf5KshXT/8XfNtTTuGjjzNjFRpkeAX8EpZQQtDwzaQSq+EG422tKaJIefjJ6ZQU8I2kI6wcpKGUKfZTo/GClVoOirEDGlJhFbnbTKDzIijLC
 I0ExGukL
 tmIjXDma1QQnl1RPIomtLuKe8bUTn4BPaJGS0J8yL6Hi02itaJZfvxIVLyPmVaU62ROyP3RegBFxPHsaXb2Q1+iX9cc1ztO04G4u/Gt+mNsKtCsjAjPuX9lZYI+DVU8TZI+4i6mFUnDXEUmzFjbLzr/H9xkVvBTFuztWKjaqxDEzrQS1O5kND0emixHDvf/cHc+MzDsIA/aq9ydtex2f70JZR1yIwiOjC6RMCGl4BqUd66Hfl9E9UusRZ3mnV768Bpc37JcFqO1wmTE+KYicezZNDLdltXcmVAzGc19mJ0iJmfs6CWRdv8FevyWol81O2iVmsxadf9yp44J0+xnNlbVPaYcn8PiIT06RVFY9UwOIY2fgeXE9kMj9z03REOkDXW/LHvmWBjLBNefv+wRUW69LjJyd3OTWvZBbPoujXKheikJrebjz87OcOhay72uFc+//c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/18/26 3:32 AM, Samridh via B4 Relay wrote:
> From: Samridh <samridh@modal.com>
> 
> shmem_get_folio_gfp() clears a new folio before marking it uptodate.
> With init_on_alloc=1 the page allocator has already zeroed it, so the
> folio ends up being zeroed twice.
> 
> For SGP_CACHE, the only mode that clears a new folio, ask the page
> allocator for a zeroed folio with __GFP_ZERO. Folios that are already in
> the page cache but not uptodate, such as those left by fallocate(), are
> still cleared. With init_on_alloc=0 the zeroing moves into the
> allocator, so a folio is zeroed for nothing when the memcg charge, the
> page cache insert or the block accounting fails.
> 
> Time to write one byte to each page of a new 4 GiB memfd mapping, with
> shmem_enabled=always and init_on_alloc=1 (median of 24 runs on 6.18.55,
> x86_64 VMs):
> 
>                    before   after
>    Xeon 6975P-C    0.620s   0.416s
>    EPYC 9R14       0.216s   0.158s
> 
> With 4K folios, or with init_on_alloc=0, the times change by 3% or
> less. We found this while running gVisor, which keeps sandbox memory in
> a memfd.
> 
> I wrote this patch with help from an AI coding assistant (Claude Code),
> then reviewed and tested it.
> 
> Signed-off-by: Samridh <samridh@modal.com>
> ---
> Tested on 6.18.55 with this change backported, on Intel and AMD x86_64
> VMs, and build-tested on mm/core for-next. I also wrote a simple test.
> It fills memory with data, frees it, and then checks that new memfd
> pages read as zero. It covers MADV_HUGEPAGE and MADV_NOHUGEPAGE on the
> fault and fallocate paths. It passes on both machines with
> init_on_alloc/init_on_free at 1/0, 0/0 and 1/1.
> 
> The idea came from David's comment on the __GFP_PREZEROED RFC [1].
> One thing I'm not sure about is whether flush_dcache_folio() after the
> allocator has zeroed the folio is enough on architectures with cache
> aliasing, so a second look there would be welcome.
> 
> [1] https://lore.kernel.org/all/b258160c-5287-43dd-b56e-268c403b85ea@kernel.org/
> ---
>   mm/shmem.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5cb628cc9c6b..d2c6781e86a5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2692,6 +2692,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   	int error;
>   	bool alloced;
>   	unsigned long orders = 0;
> +	gfp_t zero_gfp = sgp == SGP_CACHE ? __GFP_ZERO : 0;
>   
>   	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
>   		return -EINVAL;
> @@ -2770,7 +2771,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   
>   		huge_gfp = vma_thp_gfp_mask(vma);
>   		huge_gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
> -		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
> +		folio = shmem_alloc_and_add_folio(vmf, huge_gfp | zero_gfp,
>   				inode, index, fault_mm, orders);
>   		if (!IS_ERR(folio)) {
>   			if (folio_test_pmd_mappable(folio))
> @@ -2782,7 +2783,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   			goto repeat;
>   	}
>   
> -	folio = shmem_alloc_and_add_folio(vmf, gfp, inode, index, fault_mm, 0);
> +	folio = shmem_alloc_and_add_folio(vmf, gfp | zero_gfp, inode, index,
> +					  fault_mm, 0);
>   	if (IS_ERR(folio)) {
>   		error = PTR_ERR(folio);
>   		if (error == -EEXIST)
> @@ -2810,8 +2812,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   	if (sgp != SGP_WRITE && !folio_test_uptodate(folio)) {
>   		long i, n = folio_nr_pages(folio);
>   
> -		for (i = 0; i < n; i++)
> -			clear_highpage(folio_page(folio, i));
> +		/* A folio allocated with __GFP_ZERO is already zeroed. */
> +		if (!alloced || !zero_gfp) {

I don't like the GFP flag hack. Why not use user_alloc_needs_zeroing() 
to decide whether we need to zero folios, like anonymous memory does?

