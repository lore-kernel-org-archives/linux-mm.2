Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38063CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896626B0291; Mon,  1 Jun 2026 02:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D366B0293; Mon,  1 Jun 2026 02:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7836E6B0294; Mon,  1 Jun 2026 02:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 697B66B0291
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:56:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40E21140567
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:56:01 +0000 (UTC)
X-FDA: 84830434122.08.0B120E4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46215140009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:55:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l2XcYZnB;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780296959; a=rsa-sha256;
	cv=none;
	b=wZoeHil9JodhroLFfDBvcFP28Mmg03bCGQWTzL8SmxeUY5F/8xeevY2xpwbtfARblOIWGm
	yLoaMvIxFjp3u0vyEqXcsS+0fXn3bDG16oOP5FhAbwNea1IV3SKdMeb5gy60HvcnXHl/jX
	9NGha8ukoyFsTIn55cWCRZiNaCqFoRQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l2XcYZnB;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780296959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wk+nsIKgyjH4f8EhJCPQpsqqzMyFKl93mEZrNp5rlbU=;
	b=s/43ZRDCyL9fbWAVqQwgYzuYWyL1XOrmQZMREU67pGjfeQ7sHiD8kHBy+ZsuDl2qZiiYlD
	nVfkQ2Lo6CL5toRR6yJ4Naq914atx5Ah3cYAFY4n+DQ6qkPxSvL8UFRsS+30XeiofxVr7G
	PNmcvF7c5AxXm4W0Zxb6SAe3o6pFZ7A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 286A8267F;
	Sun, 31 May 2026 23:55:53 -0700 (PDT)
Received: from [10.164.148.35] (MacBook-Pro.blr.arm.com [10.164.148.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC3C33F905;
	Sun, 31 May 2026 23:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780296958; bh=P4ci7939oAoSFX3QZMcR+g9OzCdRhMWsgsON9iJyDxY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l2XcYZnBFq46QasN5IndOOMdI3pzz+fV5RWUDhOxVW+rQDMeCXIqTS+7r8segYuJW
	 Xghmnvke/cDzfY9U1/KdC1zwyc3pK96gURH8EJf03SAAs84PvL1aZlWNR8oq58Rhsz
	 VmZRPn1pITg0z0mXpWYMu0RlNiY8/t5hC/Nueiww=
Message-ID: <167e9c40-bae2-46a2-bef2-e0240fe0ef35@arm.com>
Date: Mon, 1 Jun 2026 12:25:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/37] mm: hugetlb: remove dead alloc_hugetlb_folio
 stub
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
 <8e2d9431b0e324100d550c765024c883560a4367.1780067977.git.mst@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <8e2d9431b0e324100d550c765024c883560a4367.1780067977.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 46215140009
X-Rspamd-Server: rspam03
X-Stat-Signature: g51ufqi5jqfoikfb6rf7uiz8o6mjcsfa
X-HE-Tag: 1780296959-217262
X-HE-Meta: U2FsdGVkX18ubmoJrn3uS21ZNPhoxjvG6/oUUJ4JpDH6sMw8KWNauzi2xtUfTi8urLp2E/foY94/JexsY3TB+QLvvyj6nX7wV5mBlHUQu3nksC94FYYHo2hxqcGM0UJMgntpdUQSnGn3UuCD+rcDy7Qv+OSX4vot/fLgdHK088AFHceIPZIJEQHWuY77WIKh0EZKyXfpDImFXpFsOw+w6PVAGk/AufPHLJhV4FhU6iBhFKViL2ntSNEwc7OI/FYg69pduMtEL8Mj/MgY14+ABTQFdYB+nYCfYW7Kl0QFmVqJPDnLzPYCTwHUIylkqVavToHJElnTs1vGBXcv2F9Ro8NZhUb4ZyjYUZzT/bSdNjL603ptEQwOzFK0HCMozmH/HAg9UIU8eeE22eAYDf884uHf+22VRnQ6pVK3M1fx82YZVAZ3IT9z6bpFkUhs9www6N/UySpskq0xnzABUs7oAXmNNzHz6sPyXa93y46vhHzU3zWrnEinu0xDcs/kjTw7AuTBNCqM2jKWafJF894Hf9UBZLSuL2LEt/e/ErPWOR+2/AGFyFymelYO5UPxj7SpkKmtYzz0mRoi7qID5vKtBhumnWCYVV0r6HH7zouPIIjusueUSrq+D14WIP4Hmvhfg1W6qj4YyDTFwcSjhAluAYnFW5IvGT5upP1+PCF8MiS2FDu7Vcvz7lUXZIbhqsppS8VvHRcVzqMmQsP/AQq5PbYHZ3aexNyi/GQbP2ugIhcdW+VBYGX/mW5XfqRpdWRwJanGQVQ68spgBBz5gJ1NEiAqh4FtbL8WcnzLbCfMkH7xpt1lUjYvrrytBGZje8PYrv09wNsSlzcyi+gjnvVsPcgcmgeZ0/HSf6LLqga/naDOmaCaWgE7YO5QyIozvP6TRVPF6bmBmnFKBago0Bod3CbrMfBcq90qhSpu2trpQyYI/9sOAhUL2ITw53K4pQuCeZTSTJOEYmbxRZjeKsH
 BXMqE3S7
 EC3zhQ2nnzbzGLsqJUyHjlo4d/OLm8gKldIBMwyXHMdWEXrF5RUcaS9lrryvwA7F1nOjKgmYsik0VhhqH0RJ4pQSr1yqi2bXuHDBbDor1xUh7KbMRH60QZqkeLPDhBQXhuupJhmUvM2NefWgApkjg+xNB+r4NCB1nOGqBQGdGnnFJC2EB1jTnG1yb4+m/eNIYScZADDMSuiN0+kKoAnpss2vJkAdjaKcVLRMrLSShWKDZEuiHvMOKE3yjAorWz7G+zPXa3vNWULGxFjyW05B1GeBmqb8BQkAJVLO4sqDBMELtaJ/oqaLZluYuIZVxGexGJlHh6B+gsLCQwHtDeJpxQ1lPlsdYeBPswg10q1uKVzJM+w7IkecEeCo8AFFvwT47DcIuOW1WG5e4TAfF2yXBidLfrbndc54Sl+Wua252KnCgT/y7Ns1QIsffFloUfkOBRftq9xOsa7kpQghG9d/Hc+x797zMM3rjLoZQoRj1echPTjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/26 8:52 pm, Michael S. Tsirkin wrote:
> Remove the !CONFIG_HUGETLB_PAGE stub for alloc_hugetlb_folio().
> 
> The stub is dead code: all callers are in mm/hugetlb.c
> (CONFIG_HUGETLB_PAGE) or fs/hugetlbfs/inode.c (CONFIG_HUGETLBFS),
> and CONFIG_HUGETLB_PAGE is def_bool HUGETLBFS with nothing
> selecting it independently.
> 
> The stub is also broken: it returns NULL, but all callers check
> IS_ERR(folio), so a NULL return would not be caught and would
> crash on the subsequent folio dereference.
> 
> Remove it now since follow-up patches change the signature of
> alloc_hugetlb_folio and would otherwise need to update the
> broken stub too.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Assisted-by: Claude:claude-opus-4-6
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  include/linux/hugetlb.h | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 93418625d3c5..f016bc2e8936 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1129,13 +1129,6 @@ static inline void wait_for_freed_hugetlb_folios(void)
>  {
>  }
>  
> -static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
> -					   unsigned long addr,
> -					   bool cow_from_owner)
> -{
> -	return NULL;
> -}
> -
>  static inline struct folio *
>  alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>  			    nodemask_t *nmask, gfp_t gfp_mask)


