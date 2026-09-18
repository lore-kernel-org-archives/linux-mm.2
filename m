Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45EF6C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598AF6B008C; Fri, 18 Sep 2026 16:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5703D6B0093; Fri, 18 Sep 2026 16:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486466B009D; Fri, 18 Sep 2026 16:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 237B86B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:48:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B17A0C0765
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:48:36 +0000 (UTC)
X-FDA: 85228071432.04.940A45E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id EFD4A40005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:48:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XOsaW+VG;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789764514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKI3PdAMWU3qUd28Sse7u/fTqIHi4DUOdVSXdW5dPEI=;
	b=ttXvSNim+yVoHbKw8FW/XVpjuMp7YWvbbCzAROMXu0D3bt785RpvC0Ds5yJ6lqNxEUm6ao
	p45qYGMiKIbAVXv9+zV622t2alvg7d2FAql3kjYtcdki606qxDY72izCJ4zytjI0SgZXCm
	cZ134SLFZMLMTQ/cuiVUUaV9Xj94coQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XOsaW+VG;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789764515;
	b=CcTqrm8dd3/1VNtZerP9VNSsyPbQcgUo4VxuOmjib3BWVdCG1bQhnGM+FkY4+jSW2/p6A/
	cI33P64hePLC4heNBKpD9lnnGtdvITEzqrkO5QHELESbSILtmVePWwSQ4NVc3D8L1CUBcG
	YJQfTUgUkSee5AxNteHFsmdfguin3K8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90C046053D;
	Fri, 18 Sep 2026 20:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7DF1F000FF;
	Fri, 18 Sep 2026 20:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789764514;
	bh=MKI3PdAMWU3qUd28Sse7u/fTqIHi4DUOdVSXdW5dPEI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XOsaW+VGO8UZiMZ4sBmZBLBoHAxWUssvRUp8SjA9e28obRuLnM98ODFDekhR9w0Pf
	 /4VndGGl41icOZmZMIiTWUYu11n2+uPQJvtIY5GeIegYNAFivFGvPCxF5zB09Y35bH
	 X6SHqyKLNTiMbdZO8vwKOkRVy3mzkTmycpN+tBP9jwoosyauYAZEbyZys4mvMIxe+s
	 nMDsam1vA857x2Vme3G1dPYGVki9lcF1n4wvCNCFo7U/Slsv0DMJhJVJBsMUrGeVn/
	 qN6ZHLs4lTthFyH+gGkLxx0ollSTMykK05bbJDhNeMyhrIfmev6+7lnr6s/9ptnHVN
	 17W5OSTaXaLxA==
Message-ID: <c757fa39-3b21-486a-b7c1-07d27ea5774f@kernel.org>
Date: Fri, 18 Sep 2026 22:48:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/17] mm/huge_memory: move unmap and remap into the
 split helpers
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-8-39878b37dfb0@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260915-swap-thp-cleanup-v5-8-39878b37dfb0@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EFD4A40005
X-Stat-Signature: 1edtdfe6tgzpey6qpq3bgdcr4qnq478n
X-Rspam-User: 
X-HE-Tag: 1789764514-406941
X-HE-Meta: U2FsdGVkX18GSi2BjjHOZfYGfXC+GBwr4C0nrjy15YXq+/42xT9CoIsy3Zl6+jvNE14S4J1BZQu9YW+vXqhAMHSbRXybkvyjaPceL4XsbHlCV/tphzFv4rAiTaUx4x5ojAK6NDgnWqfpsw/nrJ+w1DkZX+Ax6z9Lmkk39aF4h+h/zVQyo2vVBZ8/tfvaOCMubMzYT9dCRVsR2r+yiQHCctc8kQiKIaf/z1AMzFZPr69Ss89l0FosCAjlVXcHlUePzggWiElaEghMTWMe8GwOm5Xv5ZRFxYdGu8kP4RbhKIMt6ZdwvBQ68S1j5ig24eRIamd3nsHdYBzNnqc7KUPc3o6CHI6fFcBizhrL+7VdOX7QI9Qd/1PlF6nuoCUM3pakJ6YqmjRgDtmFu/YaSGXLhrm6DrKVBd4IXZAz/4QWb7PeCkh2yc8KlLvLITCPNu44qLZxBVf1NJQK8X0VO4Ncwgtyiyxy6f2n44biEOST5OuMdtYVikgidNj6kk+K4EzgCyyuWil/MxpKwHMChgitYxek+Udgm4LlReE4/bdYH4nIDBCPJL36SXtvWH6E2SuEZo4Vz7C7v8OqKwCKyAH2HoR1YrtQyN67ItzFDFtjXBdPwB3hpKPtTGNh4shWlbmnJFUCIUuODqj1bEwNS4/Qfc5ioCamE+Ro3rGpkga6rd/wvp9kswn77W9qTbDApDv76zvI4JWWHLTR+Tu/xIOYT5MQTvLP7xsb/Cl/M/Y1z6EWT9Jql7ajtrFVpN2c/m9KiqBc8Ryzked0m4F3KurbgKCXXnnDasIUdX4UScMpVu0Fya8bdMDAoM48csAVpZVFi6aE8AQaHBWJC3wgxTvbf0l3/4Ayzl42YCLkeOJJL87p4QCIeoJX9iJJXq4vpVw1XFmBT495rFXPt10jYDVJ5VIFvRoR8tvpjFSfaTJ0tpdoThM1rTZaX1YJB/8eJmJyJgBXSGN/6OeqZKCGwu1
 /KkdikM+
 HNgw8SK668Rtid2l+rNELHtKyHtVtYgLZR5tMFoxw/8tfmxwq85S2OpfsejV/QLhG1yoQYoT2hnoiHLbDc7dXJbFJFo/mIILFMVet7Ebj9nh1Uyq72fOqlC0HnqTBkkZKrGP03DBbZw6LJsV9vvjoEaqrLRX6q0BUU6a4wrhqGogKi3+Kd+7dQVgZw9U/ToHOgT3JqtxYIhBnEbwq5pSrG3lGNIa5K66RK+uM0yds1nNRhPqlmp5sIFX8NWZk7+r7OUa6Q4CoE6WQs//Lfnjy1hJ10O5aC9ZHoxF3BJNwhJLWsgP8gUsVFObz5mjeB+elKeH28UstC6fLQrfjvi2eSHxHScCBK1EJMNAtpY1Klo+NHZVWMcq7+gQe/B7xvf2HaiCGBsDg9ZsRhhyPW7mSbPTlfdMSu6UXk33j1KiZUEbSXUJfX55/FTYxRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 19:14, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To prepare for further cleanup, move the unmap/remap handling from
> __folio_split() into the split helpers.  Only anon folios need to
> be remapped, so remap_page() is now only called for anon splits and
> the anon check in remap_page() is redundant and can be removed.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5ba3bcdfc42d..1749905ade6a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3641,9 +3641,6 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
>  {
>  	int i = 0;
>  
> -	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
> -	if (!folio_test_anon(folio))
> -		return;
>  	for (;;) {
>  		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
>  		i += folio_nr_pages(folio);
> @@ -4017,15 +4014,23 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  {
>  	struct folio *end_folio = folio_next(folio);
>  	struct swap_cluster_info *ci = NULL;
> +	int old_order = folio_order(folio);

const

>  	struct folio *new_folio, *next;
> +	enum ttu_flags ttu_flags = 0;
>  	struct lruvec *lruvec;
> +	bool need_remap = false;
>  	int ret = 0;
>  

[...]

>  
>  	return ret;
>  }
> @@ -4106,6 +4117,8 @@ static int __folio_freeze_split_file(struct folio *folio,
>  	if (shmem_mapping(mapping))
>  		end = shmem_fallocend(mapping->host, end);
>  
> +	unmap_folio(folio);
> +
>  	xas_lock_irq(xas);
>  
>  	/*
> @@ -4190,8 +4203,11 @@ static int __folio_freeze_split_file(struct folio *folio,
>  
>  	if (do_lru)
>  		lruvec_unlock(lruvec);
> -
>  fail:
> +	/*
> +	 * If we want to use try_to_migrate() on file in unmap_folio,
> +	 * remember to add remap_page() and adapt it.

Again, remove that entirely.

> +	 */
>  	xas_unlock_irq(xas);
>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

