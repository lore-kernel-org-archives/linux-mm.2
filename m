Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D83DC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6A0A6B0093; Fri, 18 Sep 2026 17:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C199C6B0095; Fri, 18 Sep 2026 17:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08D76B0098; Fri, 18 Sep 2026 17:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4066B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:02:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 324FA1C30A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:02:35 +0000 (UTC)
X-FDA: 85228106670.09.CF8E600
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 573C7160004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:02:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/mV7mHb";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789765353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rT6GbagmOOTUela/pJbPVBxH2Xo3VSFNdj9hyDoNywA=;
	b=qVsWuGY3p4kfyDAnwLydp5H+b4fjjc2JbPkJfM0qVJPsao7No3JREVDtkT1x2MfUVMDFuS
	d8IGSsytI/gZC30+2qXeGivOWLcmSNqEtUm2T+L5JpTKEDtD+Vt6w8tuiF3w7/c/qesoDi
	w0CByCLeZpLnF3F40N74m7Em5egr4qk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789765353;
	b=SQzlI4PvNy5ZItpX+csPbotTqR7WtAfTtemrC9Yk298A6rcZnuTDToBoBsaFlpI9FVj8h3
	L/x5OubbErUu1m2pBSDFJ3bMX9+qNJzu2sKrbQSl054u6F1mGeAtMjeSCYK7k1zYYWCLcR
	rGi4WsDW28+ZtJD/dK1PR1l3PLZuqug=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/mV7mHb";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87C34409E9;
	Fri, 18 Sep 2026 21:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE211F00898;
	Fri, 18 Sep 2026 21:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765352;
	bh=rT6GbagmOOTUela/pJbPVBxH2Xo3VSFNdj9hyDoNywA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I/mV7mHbfio5LCWlsIrA3VXWdNmX6zkN0T5K014oTYvj006zO3GzpLIXJ7CbJUA28
	 YGQnYDEWeWsUNUDHGbYrpCHFqAOL6K9WO8od9M6vdofBGKlshgK9Fyk9U87ypOH3hX
	 X1PJSRSsNWyftbusBP2eW9ZHRVfMSZCO2eAMvrcSQ5Y+Kp1dRmiHoV2op5NtccWp8D
	 +2CyLiRi3SvZAgfYuGpTJaqj3FDviQpRSqZxVVd6poBv7C3ZbfQJ9B8KwseeoujDiA
	 YnIiBhGed0ZjBazkYq/WEj6yWtsmKuinUwyeYpipgKNdciWrKR+fIodNVmm4rjpLOU
	 5qLs9TMSsCYkg==
Message-ID: <4015259a-cc44-4bfd-b9c4-39ae96d48057@kernel.org>
Date: Fri, 18 Sep 2026 23:02:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/17] mm/huge_memory: move anon_vma handling into the
 anon split helper
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
 <20260915-swap-thp-cleanup-v5-12-39878b37dfb0@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260915-swap-thp-cleanup-v5-12-39878b37dfb0@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 573C7160004
X-Stat-Signature: 3ickotr3733c7mexzn7jrjkrpzmdjhup
X-Rspam-User: 
X-HE-Tag: 1789765353-176498
X-HE-Meta: U2FsdGVkX1/3Rco8dtj/SyUdWOTZAFxBXRA86fuoMwMxsla+uONoie/u688UJ35QGotifxcx4XCSk3XGToQ0tQf4bAs3a3iAlCob8/bjd7sTUwn8jWb3JoWstZrTTsx5y/WzZGr5gSRM1dssOpvU6THbYXm+0TivcYubLC++l3vCpLeJu8EKgJ6ocl/rEF4b6V0yqLpVbENaBqvcSCeV69X0G4C7WUD/f5T/GEzxAG8IXl2dh+DXpWco0YktNbM5u1jxnLDob3uJA/keGD2LayVMYl/zWO9NaXdxHAmXXVWcMzPCXsxPWJdbVXWEwdK28dA6986XZXd1MWJeu4LIPqkod59pn97oQBrTmYHM+12SvNO9pcwLv4uHAwCQ1p3T1gQPIAYHoNWDqq8s95dTCGDZDbnK3/GW8vyU2Bk4gMs6bFXqXXPd5nQrA3h4J8wuQXph67C6BnyGg+YWai0NtL9E9YYhES9JtqrwHiktHPmJXcIxTk228NINeY92f96V+dfsrNuRCAVDBP6Z/u6sboxi8H5hk2T1gEjVM3/oCnqRfRaSuIWdwutho6Oe0+a9JGqqHTT94KdpZ4NdWt1TLI0MMnTwBgHjEtNlBvu3eoZeC0owgxnSO6w63AooxiuCsZxjvVF/5ghXgQlDgCDacuwP/pIACYRUro7Wlzx3mGfQeGcEgxDQUMwplA2pj2KARqvyROTvf2VzPY8Yaq2DulZKwDVTknXwEeFdIXhAyD+7Br/MFVtspTxAheytxvdOLftMpvj14878Rdl/jtZiM+jrX/f8LrlHAEssKM4YM36XIGZ59M/pvF45ceSV1jaReQd4/oulAng0/mvLETtory5wyLxazoIEj3MScznaIm765A+07nVmdiW7YmwULwJ6WXxgFjplCMra5QpKa6/C2gE998iVobrEhIxtjr0kyZOrdkTHSuI5nJjKoa0SzaYJAo9VCfgE0/SArXaZsj0
 iD/NqhSc
 79owfVDBf8c+XM/Nfn7YSDaUiuN5Y2kchvTcspukwS5wQAzP1camjjnHRRGm463ULaCaGu3UvTMJyoLkXCUUSjoYlgAD5H5TC//VtHqzDBEtAif5HdUs+KKXJSiHYQcqvf4l4ewTomQIZTT/2NiPIv5g15exXbmaZ/E14m6KQgSgpY8MYm3lMMEeZkxj6Sj4L2J5SZT92Spa1KtHxsPwIR4ooaqXXLbZ4F0CCtj6Kn7NtbQiF1M17s3TI5Y0rMWU7o9YKO5JYRTljsRKxjG8VadsOe1F6fBRWAKLQfEdCpEObUkvovitXTAsELmockg8FeX8Y7MkTw0mzPrpZjLNA5vRvSp9IYsNmUdJ0HYkd1eUa6DKMIJHgM8h4a31giS7QXI5T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 19:14, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Only anon split needs the anon_vma, and it only needs it to unmap and
> remap.  Move the folio_get_anon_vma()/anon_vma_lock_write() pair out of
> __folio_split() into the anon helper next to the folio_mapped()
> check that already gates unmap_folio().
> 
> This makes the anon_vma conditional on folio_mapped(), which is a
> behaviour change but should be fine.  folio_get_anon_vma() returns
> NULL whenever !folio_mapped(), so an anon folio with
> folio_mapcount() == 0 used to get -EBUSY from split_huge_page() and is
> now split instead.  A realistic case is a THP that has been fully
> swapped out and is still in the swap cache: swap PTEs do not contribute
> mapcount, so it is !folio_mapped() but still alive.
> 
> That should be safe and right to have because:
> 
> - folio_ref_freeze() below still rejects a folio that picked up any
>   reference, a mapping or a GUP pin, in the meantime.
> 
> - A parallel split is excluded by the folio lock.  The anon_vma
>   write lock was added to serialize split in commit 062f1af2170a
>   ("mm: thp: acquire the anon_vma rwsem for write during split"), when
>   split_huge_page() did not hold the folio lock throughout. commit
>   e9b61f19858a ("thp: reintroduce split_huge_page()") later made the
>   folio lock a caller requirement and added the folio_ref_freeze()
>   scheme, so that has been covered ever since.
> 
> - Unmapped path is already exercised by folio_split_unmapped(),
>   and the swap cache split already runs well for a partially
>   swapped-out mapped THP.
> 
> - A !folio_mapped() folio cannot become mapped meanwhile: mapping it
>   requires the folio lock.
> 
> For mapped folios the anon_vma write lock is now released before
> __folio_split() unlocks the after-split sub-folios, where previously it
> was held across that loop; that window is harmless as the sub-folios
> stay folio-locked and referenced until it.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 31 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8fc1dd5b8354..a4c2e38f4a6d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4029,16 +4029,38 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  	struct swap_cluster_info *ci = NULL;
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
> +	struct anon_vma *anon_vma = NULL;
>  	enum ttu_flags ttu_flags = 0;
>  	struct lruvec *lruvec;
> -	bool need_remap = false;
>  	int ret = 0;
>  
> +	/*
> +	 * Unmap/remap needs the anon_vma, so we first take a reference on
> +	 * it to prevent it from disappearing, and lock it for write here,
> +	 * letting unmap_folio() walk the rmap with TTU_RMAP_LOCKED.
> +	 *
> +	 * folio_mapped() is not stable here, but it can only change in
> +	 * one direction while the folio is locked. The mapcount can drop
> +	 * to zero at any time, zap_pte_range() takes no folio lock. It
> +	 * cannot go up: swapin, migration and uffd move all lock the folio
> +	 * before mapping it, and fork only copies PTEs that already exist.
> +	 *
> +	 * So if we see the folio mapped, the worst case is an empty rmap
> +	 * walk. If we see it unmapped, it stays unmapped and needs neither
> +	 * the reference nor the lock. Anything else needs a reference
> +	 * first and folio_ref_freeze() below catches it.
> +	 *
> +	 * Note a swapped-out THP counts as unmapped here as swap PTEs do
> +	 * not contribute mapcount, and they are splittable.

Helpful, thanks. I'd rewrite the last part to

"Note that entirely swapped-out THPs are unmapped but can be split."

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

