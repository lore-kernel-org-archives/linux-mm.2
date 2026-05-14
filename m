Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C01CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2756B00CF; Thu, 14 May 2026 10:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93706B00D0; Thu, 14 May 2026 10:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82116B00D1; Thu, 14 May 2026 10:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96EFA6B00CF
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:16:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F849160417
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:16:20 +0000 (UTC)
X-FDA: 84766225320.10.8A716AA
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E51440008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:16:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vTs4YJIp;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.167.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778768178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/aRcyReAB/yBt5Ujgx4hlVRsrvunB+iUEF0sUUUSTA=;
	b=uXCbzzWRs06ARrW4IlEPR7xyopfw8Z1l0QxJRhPmMx5762alSK//JnHer0SkhmdQ97ySLl
	pLTLcPnl9qedmKQrn4eh3dlKmVJbUIGzf4JSWzzwsYkQNXi0CHCNe2hSB65VAYbye0PwZb
	A8Cfje+sB8qGlLjzH2jen4RyR0PfRrQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vTs4YJIp;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.167.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778768178; a=rsa-sha256;
	cv=none;
	b=KXu/fnmpl8YwdQIHqN+cPyvg+omD19CrsmQ3ADwqXQwbh4KmiQUR+zSmGXt3Hb0vvgym/2
	xAheElBxGEXtjy83IHlZdSXp28La2R331cdz5rYFtelGNdn67l6j5S4w8cdzruaQ0TkPKP
	46l8h2T+QDQPC7a5DQcTKZjMcgnl/hA=
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-47c7b282d73so4640670b6e.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 07:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778768177; x=1779372977; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D/aRcyReAB/yBt5Ujgx4hlVRsrvunB+iUEF0sUUUSTA=;
        b=vTs4YJIpURaoUuCVhRsc5QgqlczJqOM4jiL2bg08IcdRs+l1pG4TiK0Lp+jxN0AzO4
         cJ+PelFPjY2qDVZ2We/+4nkotv+DInoj+QUgT6++0wTwbN51PGL6fmOloZuUa5IlpuFw
         FJ+xRHwoTVWuOjzMmOEVwQIxLWxOX9QbwHE1fiKwrCu20C/12yc4zomZaNO2DUv0G2WY
         074FtAiXZORxVlSC2L1/uy3Tr/0tKrwuwnrUiel85Z0alA/ccdGBt3MmPUKZ/0xEKF2G
         Inj3om23Bjjg77ha1zwECM8zaNJ7MHAbRZU45Wm+4wvSsTKq7Xnl51CWGSHYNvWTiixV
         JmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778768177; x=1779372977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/aRcyReAB/yBt5Ujgx4hlVRsrvunB+iUEF0sUUUSTA=;
        b=D77xQaLIo/maLOExAlFbt3izhDzRIF6t92OYdrflTgjm0hngMc5oJO+S+AR1TPgJjf
         cZLpLXxSfgB7DoD6AVCo1oYznMhOpU+MRgrvzpt7iYCaq/RLNPHfMpKaFXFvZydSJJaE
         w5RGG6hqNQJhYJxCiDwiMGEu/1DuHYBD/TZDKGJPvnhMoMRGzAjfjUeceiJcBpTkoyfE
         FUqBRTBW7SVjC5Xb+754DAPu6q15UUQgyCtMHzmOxcea/DP5iI9X338LBczwOtkX9AwY
         4zTem99fxCa7bt7L8mfcwfFOlqygRwyvPIiurrv5PhiAKjzMjBX0cTzjrjBsyOwBs59h
         lyiw==
X-Forwarded-Encrypted: i=1; AFNElJ9+GtH5TDRYVNzoyx7VnfFFy7SkKEUzV0gfGAmpEmG3TVFNtQY5D2fQtBPcfqeq9NtSDcW5+us2tQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3NDwmaUJuBjUa+h3uQySkpgn989IomtKnjhuxFkmarWKNspKQ
	clWGLH1K0g7zQO7uFN3+KKXD5zDrsQR5iqTSow/wof30kAFtSGqAHgV8f9499zByiF65jmMy0EG
	oNEwd
X-Gm-Gg: Acq92OHRQ9mbnhJL+P4C+GIGTn5YBp8C7/lWIdIG956qltKDy8TNStI7yYLkUMcQD2G
	WQelLHmpxczuokzTYS9c1UfIXKNsB5dBF6pnQTUlBOX4rsk8wNlbz64gWKmKMWymVPalY5Q1ceB
	r3taWG2Re1N2LWvFnFmlSc4IUwJvS1yALZoFYi3rScBvsTvmN7VrjK5gz1eCfhRSufooZsYhUuJ
	JrOb8V+pAI5SJmnRs89iEWQ3YWcHjxHzYQMn27RdlVl+MTxI3sUtGjcc4Ae3V/Cf+fp3nUKqWo+
	dV+jLFja83Zr9jhG5XODp433vGS/V8ZFTIyyWllySXMu0vgnxc+OOu+RlakVdpiWulBFsT64bf5
	lL9Q4FOUtXDCK0KBDYU/Hzx8bPd4IK+WrNP2f6DUNCK6itxWZAEy2AeTvYEZlFXv1bho60j9s9s
	6ddJ6KTTyv8tvDT5QkfXiq94oheQlY5jYJ0NYHs9OxGfohjOGwTAMhsxlQsiGIT22NnTog1QSH4
	Hx/7oARt5Cj
X-Received: by 2002:a05:6214:4291:b0:8ae:6460:c544 with SMTP id 6a1803df08f44-8c7bc05a2b9mr122449846d6.41.1778768157667;
        Thu, 14 May 2026 07:15:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90c359c74sm24280456d6.45.2026.05.14.07.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:15:57 -0700 (PDT)
Date: Thu, 14 May 2026 10:15:55 -0400
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
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: Re: [PATCH v7 22/31] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <agXZGjyvs0AHCpnZ@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E51440008
X-Rspam-User: 
X-Stat-Signature: fob6jmtqpaf6dci38qn3zhadzgse34rc
X-HE-Tag: 1778768177-472873
X-HE-Meta: U2FsdGVkX19Kczmh5GEvaDApCpee3z32+SsoFowji6YYe7eA6YCDNewkVelS8OOUQmDLP5zYr5weLFFss7A/hQ6Ie67tWIxLtu401ueTliUhMVdHVR2yFfxhoJdnm/5h7dVrh/tHEBacA9jhV7RzrfnbyLPNDjBK9I9DrKfJFutqikOGAxXrh4iHMHG/4rQlLlQe3AbvbyavXMKtNSubQWkfTjFvG7c00D8BeoenojwWkcHRY4knnbfX4hEkgS2P41R+v+kdpC+trzphNZNWbpLmtcVSw11+EtjQlGNIzLrndjCGjpDnet7w2H+zX8iZH1X14U+e9DVri3kJS7SvYGfFDupoY6Eh/4H/FhX5HAfWiZUtqoIfjO2g703PRYKT6RF+/HqHI2oF1Ch1wtycjx1nrG4SCXt/+3JzquwJe+uAZ2+xQoWAZL2AoQa1u6tMKyJJw5/7sN6UCCm2ERHfOtFDD5DlnQKzTZ6/qm1pmhLCL0mFUcduvRLqdnOGvJNpGa1+bbvMpZD2IDKrbsT+KO1mX4ee+hTgQwK6slEtl/NCCdbw7tJouRJIVsu1hcvP4fo6i9dia04nMtprSJ+XlGi7ySmPZpBXEdc01/n9QlM4y6DPZgVOoN/bmzOhWSISltrmuJ8YBG9/jLPD1MzgkN3Cr7eAal/SNv4BQQFO2Z/1ajWQzkrvWqmUbzCppUhjeL5eEyUse0bwB5xdW90QtE2GliV5e3c5albmpI9eLwPcjZ3mbWz+PFMID9jsXXyIGj1smXeyMMkAGL12r39SWdJzSqaIo1FcomcZ8Bw2paU9irUVJaaKeGON58BDmJrlltSBEGHbDP9NE2AnVnuzTizFLPBoGACOBMG1WEJefe3yIKREhIc4EEDSet1eEK9FywrHdij5UaDVtjnNbdxFWCE0FKgRFGU7KqW0Pc/4t4xX+uhPlitA6Y2zf1i+PZRiXd1mx5tHHn8PZb+p3pU
 p+NkM8/F
 gPIcLlx+IGFzk0UqV3V15O6sumStX6pgn8lQTtuQbusSI2At+U0xpRjyoKyPfg8Sjqk8PfmQMB/Eb0vp8AfpKLMtVufvfYWNMOoiaCyKsdCzSGu8ksZeo6P6B/4Qs/Mv3RhgR/0QyA7nOoP1/yBELZn+Tgke7kqRzqPNOLLH00fonk07IGiS50FU3mctEA+hDyWkwY1MO0wEg6eSo2Gsr/+YXqOyttgmtK8ahwrl3G92TP+htLs9rSDtTiTuTt+0LpdOpR9sxnmjnTYSkBiYy+s4dTQWS3CxQPrr3Niczy0THNfr2QkGW3PfBBFhQLn1BMmrflyMAsHP240pPiNs8fMrjh453HJaLjMP6YGAU1E77bVbuGAFYDPAVqubONuGHmEaux5Kjxk1AZFb2QCw1cp7LMT5pp5N0ov7CcYPuLdv41TnjJxF8Ve/9+0cDRUEThFQIQ885YcerhObVbIXZ9Vsq+GcJ1HOtAp0pEVUwhuDL4T3kAGz1SUv+nkZFV7huY6edE2mjJzif/v11aRAja2+6hb8ZbRuMi5m/vWy9nx4wgana8VLrHIw779krwtekhnCX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:07:05PM -0400, Michael S. Tsirkin wrote:
> Propagate PG_zeroed through buddy splits in page_del_and_expand()
> and try_to_claim_block().  When a zeroed high-order page is split
> to satisfy a smaller allocation, the sub-pages placed back on the
> free lists keep PG_zeroed.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh

Already reviewed this, but noticing the same pattern - wondering if we
should just snapshot all the flags and plumb it through instead of just
extending functions like this to have infinite bools.

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

