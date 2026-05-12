Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89448CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30FF6B008A; Tue, 12 May 2026 12:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08BF6B0092; Tue, 12 May 2026 12:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1EA66B0093; Tue, 12 May 2026 12:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0C466B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:05:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 848A740590
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:05:18 +0000 (UTC)
X-FDA: 84759242316.24.1C7DDA6
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D28314000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:05:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MPgSnf6W;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778601916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fEDDU+f7CbkQFEw8YKAGo16eQTvjIgO+nLY/Z+AdBuk=;
	b=Ty2wGJeeBLfvfYGIemDl5ivcfnZHpdtKb0kYDKRu5gHuC/6+wYC05r7Q3zgQ7y0tvxy7hs
	qbd8CBsUsmgjfJ4zc6st2+KoouChWT1KCmZXIS9I39CQ8RadGoDYwNGcsD6wCDK/Ap0HlU
	stPQZwfOybJifMwxUh+jUa7u+Irkf2I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MPgSnf6W;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778601916; a=rsa-sha256;
	cv=none;
	b=s9SxfYDqTcsuUiRaYgfp4gwu4M4YlPRgu0O1/5jTWGjFZxLjDRH00dk+VyPEqvTzgSZeVl
	ZP2y1hG9NJb2PUypLx9KCP07oFJmZMxSXnhlrseT6CX0N2e/ZyMPblWak2z1CXJWLHNfrP
	lXSzIn4OVtso2eJ+cjL61n50NREgd/o=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40ede943bf0so4164535fac.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 09:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778601915; x=1779206715; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fEDDU+f7CbkQFEw8YKAGo16eQTvjIgO+nLY/Z+AdBuk=;
        b=MPgSnf6WsO7iJ8ALb+TtUbZ6g6/dE5U7NVog2qFwzijZjdCdFfaPI4FedBnPGg2sUV
         8dK4FaNr5bz/Fb+xeaU+VMqc3T3Maawn9RebI2yYgobDKAqJFJUcFED2ns8waw7I8X6s
         l6t838JIrzhmAyY1tuuz3ucygln+xa8yxo/DiEr9Ps3IT5efd8PB6kVDixOaemT1gplc
         LINWmmuFrq5xouMYsUFCFyBOAopgvk1c/P4DnX1uPpVZdcX0xs5HLsHbHM+0fLgH1q+r
         wpYhZR2LEDSyDS7vytLfi2P0e6wZkcsod5rCzzV6wlcsDyHkt+y7iEg4W27UV4bDtZw1
         UZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778601915; x=1779206715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fEDDU+f7CbkQFEw8YKAGo16eQTvjIgO+nLY/Z+AdBuk=;
        b=dNkEy96EMSrXUgM9phTkVkwBrI4/bjw9Y2QejZBH9+1Thfati9BaGKd6XawLRUqUSm
         7mKaQ4DBPqW6MwyBNU4wXIeXBM5otck03TdKNlm0fSCrYSGmZ0XxHUgYM0JrMcw66/PZ
         XXBSvkfCUCDERDYGtqds/6XxST0csZg9r5R7Iz1c098yqmvg1B9qPfKR621g+RZ1OWQC
         uXnH3RVQtrpPqX/ZdKtE7oLIQT0kP/loZfF1Das9Fmh6cKCVBpj1Or8rzVbq1PTVwfXe
         V5xeqOiDgDhanJksCfB5C41NGu7gMTBvtiMybrFJDasq1D7/0VhWXV6t7byPrRvV9De4
         XJCw==
X-Forwarded-Encrypted: i=1; AFNElJ8YiS7Qm1CPRlDfHlchPKT/YHUaCrnnQ2TojzFU+e9TYP6kJk5ubOnIBf2dN4iMPHpuAb03TKngsA==@kvack.org
X-Gm-Message-State: AOJu0YzIZ5hosKUpj6Ll3tNZn3AWIaI6QtdGXgIz1mpVuBj3W+2kJxeT
	sGJRLIWDiM4VIm0QqWKezZ7pNZ7CHOu3oTIiSZplzVku4VmZxDuNgvwxI+4FwyMU0FIIi4yPQ60
	ZF+W4
X-Gm-Gg: Acq92OF3uDrAYD2sNZ8Y5NEyzCS+sMKuxueXjT1vF1hfudYZjIs49NpAeADHGWwyPoh
	DoDyHENYMul6ak4/NAs7/UEx5br1hAFMBoJ16+1t9t4bARLEqbyHvtFkyXYDIe3WISov6f3edZh
	ZPv6sFQf4jUqdPq7Nt8OrkuO+mkVG596HEEzYMiqqivp33DH9RGN1dfYm94xzN+xVXkfGHrIHf4
	xxxPY1iP6GkPZbhXd0LPvL08lvL4dhElhnr55hfz50gsr6VbEgcIYEBQUVsYk6WsnspoAFL80db
	gHVNXPievSa8UEZcFU1UvHQxBVQBgEvLtlkUhuRZTlH7mnmppMuEx5tcc91X2lv0Ds641Orbneh
	vo7GbIQAsdUWcOw290eFCCnJwI781f49buUT2AEictsLSU6QAbs3GIYB8S7Eg/lfnivDxmXKUvE
	SRVSG4bRJtBaI9Ra51NjsBdYhp+YFFbpzil3wO42g7DVa0A99Ctrd4k/xaV2s0PANxL4E/ITx5s
	Ykhe1mHBpaI
X-Received: by 2002:a05:620a:46a5:b0:8cf:d6f8:599f with SMTP id af79cd13be357-90cffa5b9a3mr483433885a.57.1778601500616;
        Tue, 12 May 2026 08:58:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b8e9b24asm1421777085a.18.2026.05.12.08.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 08:58:19 -0700 (PDT)
Date: Tue, 12 May 2026 11:58:17 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH resend v6 21/30] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <agNOGSyndMSU33WO@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <57d30ce615c23d3f3737e38d300f4613b3ebadbc.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57d30ce615c23d3f3737e38d300f4613b3ebadbc.1778489843.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D28314000D
X-Stat-Signature: w3z8n7kyzaruhwg3ryqiy3xiypidd6oi
X-HE-Tag: 1778601916-132839
X-HE-Meta: U2FsdGVkX1/sArDpckNYvnfpomB9mkuzV8rqflPTJX5+fv4hPAvLBEWjgNJ87LfyprMDTf/owIuDhLTTtG6ZcMippibYRZqAxFJEX3wYVGL+p9PX0e8VvHlhpm2SDfWzO7VjGFYqLGGjrZKrRg8iAOT7hKgoK+DrUbu2duqZl0PVhuE3no6jyJoiwXR9x1ap9b5xqiVGs9SBxdtlI72peJ1Wxay+ruE4oeZG2wb3aTK4v99p/G3FTbm3kGtQuCVbnYi+aEH0DweIlKBPHcXfU5MAZ2l0+yYKOcOCVRfKB6oC0NFjCaoD2HqQaBXiZmq2AgolDmWQ/3Ta2GjOoUMmoQl5gXrTDrO8HaZo+Juap/LxeOXh+UjSzItCyRNtQ2Vqm90Dn+QPRpfCok5Dmkj+gWgIshpD6wXHjwn8srDBs/PL5MTahl72BZNJO3Wge5DcYVo9iAoSHka2cc1P6o3QYQa3tDSiQyPzQZd0ll6RLFwKhyISv5SdOffiUVXco9f1lq+3eajwIfTRPFtrTgw7AOYX1rPwJKXGBrlqHp1qZXjOGNB6TibiMQrLLgEONpUGcsvF3wUwqSOI65MungdMIn/LixZAJoLYskYn+sYZpHVykt1dmU5lVfCQCdhmqcfc7Y+7GWjyD6/am6X70+XYp5gT4SXXVcaSafs95bi/oIcng99cVQON+f1OgWSLLAJte0sOLpb0NjjN918THVoIMpwdqt1Ye5bidzklMXgE+BrRtly53ry8fMlJlEHYVRRMjaqazcF/n91w+MPdQIT4U7cDoBbEo/ulvF2ttBSK/y0T5Dd8Ai64PB0VndHeETnfj6IcXjOpuUtaRiUgo9Ils5lBmm3tdpw5YOBxHppy71JiO7Qr/niozR3BXnaDWC+7FIyp/WzLyF+wft9NNeCQ+oPcNdW+b9oBbpVYVeIvEFQ9vUKEJIgDHUEdTZ9BEnCVbQh9hKxht8xkz9jJN+y
 iW5Jq29s
 9K3HCgiuG5RTrZAi8ptNL0dybfRKUXzCf6/Xb9yqeeriAiCZhKFXjo2MXfULYcuQlZWxefJdbXsNBgCP8pguR+beJl0iZYn2VNSOOINIvMOUJhEHn7VQjUUWaK4PQUZk0vk6gAXCSBn3D9hrJe2kTFr5inzqBC7onULpIgGcPD1j7emkBz6JFkD0mbJQrsfm3+FHglCx2nQi5sFKcjN80TZCcylbS+doxwOHzyweDqNrdaQ5x3G6u4ScsClIjyeJV9jAuT+T420pZhMA055J7KIKxNyx2htuf5Cl1UhGGAGdEcpi0r/lgIiRkHcwzVrJPPCq+51B4zmyeOKxGUpUT1HfKyQF4hwpJQ6n2CWcLPuTlssZ1FR9wQSAev9tYWTl6pUexADoxeG6NybhAflv60vmOtIeXjCcthpfpWqj8HjLOIckUpK1+ZDNsewhbU0LidEknSNQ0xjsy7B0b+EJZXcW5hvMcn3J1sWwXNu9vLgudERzQWk59+BRA2eS/WMw9MMWhRS7PtBPBV33E00Z87tf13qMeLhnuUAedE2VoveeGvo9kpXrCFqAMGC9TCFTVtVzyXMOXLhJDu7BgvVmTPVG7S4vpEkt5cFzyN6N/C2Nsn2sJ5MPG8wvBJvI5kHqJpED7pqhoXiIVCLOXJCsKA30qfikkHSfZPTHj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:03:41AM -0400, Michael S. Tsirkin wrote:
> Propagate PG_zeroed through buddy splits in page_del_and_expand()
> and try_to_claim_block().  When a zeroed high-order page is split
> to satisfy a smaller allocation, the sub-pages placed back on the
> free lists keep PG_zeroed.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  mm/page_alloc.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d70c9ba6b329..468e8bde7d34 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1712,7 +1712,8 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>   * -- nyc
>   */
>  static inline unsigned int expand(struct zone *zone, struct page *page, int low,
> -				  int high, int migratetype, bool reported)
> +				  int high, int migratetype, bool reported,
> +				  bool zeroed)
>  {
>  	unsigned int size = 1 << high;
>  	unsigned int nr_added = 0;
> @@ -1743,6 +1744,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
>  		 */
>  		if (reported)
>  			__SetPageReported(&page[size]);
> +		if (zeroed)
> +			__SetPageZeroed(&page[size]);
>  	}
>  
>  	return nr_added;
> @@ -1754,10 +1757,12 @@ static __always_inline void page_del_and_expand(struct zone *zone,
>  {
>  	int nr_pages = 1 << high;
>  	bool was_reported = page_reported(page);
> +	bool was_zeroed = PageZeroed(page);
>  
>  	__del_page_from_free_list(page, zone, high, migratetype);
>  
> -	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
> +	nr_pages -= expand(zone, page, low, high, migratetype, was_reported,
> +			   was_zeroed);
>  	account_freepages(zone, -nr_pages, migratetype);
>  }
>  
> @@ -2335,11 +2340,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
>  	if (current_order >= pageblock_order) {
>  		unsigned int nr_added;
>  		bool was_reported = page_reported(page);
> +		bool was_zeroed = PageZeroed(page);
>  
>  		del_page_from_free_list(page, zone, current_order, block_type);
>  		change_pageblock_range(page, current_order, start_type);
>  		nr_added = expand(zone, page, order, current_order, start_type,
> -				  was_reported);
> +				  was_reported, was_zeroed);
>  		account_freepages(zone, nr_added, start_type);
>  		return page;
>  	}
> -- 
> MST
> 

