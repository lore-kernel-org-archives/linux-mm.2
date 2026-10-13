Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633F5CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E876B0095; Tue, 13 Oct 2026 11:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63EEC6B0096; Tue, 13 Oct 2026 11:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556B26B0098; Tue, 13 Oct 2026 11:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 182106B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:04:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 937A3A0C48
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:04:42 +0000 (UTC)
X-FDA: 85317924804.27.19A447C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D3B1A4000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:04:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GVgbI6ap;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791903880;
	b=mlsIE2SkhtApt0X28DREUERU9F8pleFLW20uT9PFFzcRC1hopPJPi+XdvjeSRymyzhFX6G
	F+eFF8WbkFfvWl4hSGZngYTN/JpsdYEugJuZ+pvx7yUT3jhOQN5dkwaTPMjwDWwhR8FdgK
	hSoxp5sONRPHicdvfuar+BzV8d1ntFo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GVgbI6ap;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791903880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4WyTCLD/TtiSn6CjA6uGQFIb/xY+wFvIHGUv0Trrdo=;
	b=cKRbGSXci27ybcSMkvI42vngVIYvJtQNmvYBgYjtItQqMDV1vfjNjojgJuGWkKhlJIBctF
	JG7RCnwFdFj0IsdptSAS/JpJZI7s5KbNCpQiZJiR7TgPTG/fcrDZHggBh1ZsJTiWJyWmqt
	wPU6skqSYiSPR8NBgOIHSICMs3SwGWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E1C160A56;
	Tue, 13 Oct 2026 15:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151DC1F000FF;
	Tue, 13 Oct 2026 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791903880;
	bh=r4WyTCLD/TtiSn6CjA6uGQFIb/xY+wFvIHGUv0Trrdo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GVgbI6ap9ekVxLrxQcUPcwFnpUr5X7id2J6mNgSjf46AGprjLyPQ40B9VAgCg7Gru
	 ztQ82X1+DIOx6V5ZFXZSotu8vj37Nbm+JnCvxJJADGCljW+QWlXV5ex1Jme50ZYGzB
	 cNJGXj4nuYIeIMMGxAqRqkFNs9FdzidVUNeXRiN3ZUvunBQEBq32JGB6dOuwLCfphI
	 7sr1Yn48WwG47H5l8MJvGDbky0W+s6ylT4tkzk8juiZ4GYwkWVIsvcj7QK7+mCFVuD
	 0Ux9LYfe3FtOUl5lmlJ5kzWnqwx7LLb9uwbcXSi0m2gGtDAAOozgdDWYTS6gYnrIiR
	 PhaWjPdBzCvNw==
Message-ID: <bb2a67db-fb38-43a9-b50e-38e078ad2d1f@kernel.org>
Date: Tue, 13 Oct 2026 17:04:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/hugetlb: fix max-only subpool accounting on
 alloc_hugetlb_folio failure
To: Zhao Li <enderaoelyther@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mawupeng1@huawei.com, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260427145247.84157-2-enderaoelyther@gmail.com>
 <20260428030712.66256-2-enderaoelyther@gmail.com>
 <20260428113037.88766-2-enderaoelyther@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428113037.88766-2-enderaoelyther@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D3B1A4000B
X-Stat-Signature: 1wn7qd33ppc3x3kc59hp4sg67ej19wc4
X-HE-Tag: 1791903880-906683
X-HE-Meta: U2FsdGVkX19DDY4QXdofMJV4/a1zUP7789xYrZa9naJQBcSLDiHuk06pNL93+U3uE++JM7RxPxw+30sAQrkUECrmAo9SgaNgbkaM+d3eaV9qojoO7k2u6dfT1wi73V0+RQMrgzNaE+/fEz9/QrFmp1WBz2HfHF5IP/P++tCO486GQj8Y+qlpO95N/gZUFz+3VDMso0n0fleJpr3G2Bb2xqsicTd83SBNthpWBx97jP7ibv6pd8Cwv+9R7rPu2hvyEgdiSgeS78DGCMUDD6AIBbUCi90KD+wz9G/Un02GyGr5yd0CBUTJwyhm+aiQRY3rofhEQidMJQgR6HlHoh8ZMXsv9W6VsS9e/cXT55RtPf6RVJBivK/ymn1mb2Osgy9kgd1uCazYbbUgxfdAuwJcBpHs9ah9juMvb+hOxysVp4MYbHiBbUyH1j7WXqGHprAI1oLFA3XnWfkD4TKaQY5os0raLewHlyYAWv+JytP9wN2JUAB/4huGYu1Hj7+7y0V4JuIXo9B+Z+b4E8i3j8Kk7fm853wq/KY3Drbxtct6vo9Ty5fUj1yED7fVmyf0n+mEfMo96Fj0bGFtaQhDKXj+GMx6fsvGUf7G/ipCsXVMJWd7ytci81kwxG1THRV0Lpj8sL1I03hvziEtE19AFELCAs1vUuVxahvxr4UtsJ2bRcloEwNUovHY+ExE4kXD/NDM5Ss8/26M3hBEr/4u72AqlGT2H2zOj9+ygJMjOlC1Rl18N4tBeeATYP4NJWRL5dHqxsGTJxwPTwDSDXHrbuJMu1KmUIj2VtJMi+zNYCgdpZ3uJJZg8uxX6SzfBYbnbFvZXzrnt13e0iGiUsJHIpP3gqTCHR8gYKbSKnRHi4PlR2/GBgqDmlYld9Wh7/PE5bj+dh/hLZJSDCkZFRkHnFGNs1qFjh2HwjTedoWvCNRPwHPPt39cSLhGtp5eYvBp5+nv/peEK3wyEWpdyYOlAXA
 lEy9JMIk
 /Por18aTkkfQkbY49DOgyQP25SEAVHmFUsUNcNg0BbaVNmzCDxzsBWt3+WpITZWeBtXDrXqmwrhEYwcQVoBxfdrMvEZi2r0DZTc/dHT4242T52ToWG+cg0neGgLS89KDfl0Wgzh87mZ/Kh7aYpequHD2WmZ/UAnikN2OSNUvxMDxUNxCKckHTtcJ5YnYpRKmBXU+7zyRxfd1QiFb+n6Is2ObpTN5ynNJhRi1BCpcgfbGe546Ws7v53/XZBDIO4TdQmz6F3UTgo3heXHmp1f2I+5TFU+0xx2kq9sK2eqiLnKShpExXVf498tL7JcVRu4ZoIKykIFtrzgmj24g1E9GH3NDRlyUZOgkBcoLO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 13:30, Zhao Li wrote:
> alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg
> is set.  For a subpool with max_hpages != -1, that bumps used_hpages
> regardless of whether it returns gbl_chg = 0 (rsv slot consumed) or
> gbl_chg > 0 (used_hpages slot only).  If the allocation later fails
> before a folio is returned, the unwind must undo the used_hpages
> bump.  The old cleanup only ran for !gbl_chg, leaking used_hpages on
> the gbl_chg > 0 path.
> 
> For gbl_chg > 0 on max-only subpools (max_hpages != -1, min_hpages
> == -1), hugepage_subpool_get_pages() took only a speculative
> used_hpages slot.  Drop that slot directly under spool->lock.  In
> that configuration hugepage_subpool_put_pages() cannot restore
> rsv_hpages, so the direct decrement is the exact inverse and is
> race-free against concurrent puts.  This matches the used_hpages-only
> part of hugetlb_reserve_pages()'s out_put_pages cleanup, but
> restricts it to the max-only case where no rsv_hpages restoration is
> possible.
> 
> Mounts with min_hpages != -1 are left unchanged for now.  v2's
> approach (hugepage_subpool_put_pages() + h->resv_huge_pages++ to
> back a restored rsv_hpages slot) double-counts global backing under
> concurrent free_huge_folio() and creates phantom reservations under
> concurrent hugetlb_unreserve_pages().  Safe cleanup of that quadrant
> needs a coordinated fix across multiple call sites.
> 
> Reproduced on size=20M hugetlbfs with the faulting task in a hugetlb
> cgroup whose limit is exceeded.  Vanilla leaks 6/8 hugepages of
> subpool quota; this patch leaks 0/8.  Verified under QEMU.
> 
> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Cc: stable@vger.kernel.org # v6.15+
> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
> ---
> Changes in v3:
> - Replace v2's hugepage_subpool_put_pages() + h->resv_huge_pages++ on
>   the gbl_chg > 0 branch with a direct used_hpages-- under spool->lock.
> - Restrict the cleanup to (max_hpages != -1, min_hpages == -1) where
>   the direct decrement is the exact inverse of the speculative bump.
> 
> Changes in v2:
> - Skip the gbl_chg > 0 cleanup when max_hpages is unset.
> - Add hugepage_subpool_put_pages() + h->resv_huge_pages++ on the
>   gbl_chg > 0 branch.
> 
>  mm/hugetlb.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be047e..cfdeaf6394c5b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3025,13 +3025,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
>  						    h_cg);
>  out_subpool_put:
> -	/*
> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
> -	 * during hugepage_subpool_get_pages.
> -	 */
> -	if (map_chg && !gbl_chg) {
> -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> -		hugetlb_acct_memory(h, -gbl_reserve);
> +	if (map_chg) {


I agree with Muchuns comment about removing the "gbl_chg > 0" check.

You could consider the following structure, which reduces indentation and avoids
touching the existing handling.

if (map_chg && !gbl_chg) {
	...
} else if (map_chg && spool && spool->min_hpages == -1 &&
	   spool->max_hpages != -1) {
	...
}

But the code would read a lot nicer as

if (map_chg && !gbl_chg) {
	...
} else if (map_chg) {
	hugepage_subpool_XXX_pages()
}

Whereby the spool checks etc are handled in there.

Muchun things that we might just be able to use hugepage_subpool_put_pages(). It
that's possible, great. Otherwise create a new helper that wraps all the logic
below.

-- 
Cheers,

David

