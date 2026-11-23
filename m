Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBF7606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LFO5kG6Y
Received: by kanga.kvack.org (Postfix)
	id 54B2A6B05B4; Mon, 23 Nov 2026 02:00:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5016B05B5; Mon, 23 Nov 2026 02:00:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BE16B05B6; Mon, 23 Nov 2026 02:00:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 164F66B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:00:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6F40C065F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:00:19 +0000 (UTC)
X-FDA: 85465484958.05.C515BA4
Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 802A080007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:00:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LFO5kG6Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795417218;
	b=68rPfqagp1xcT4jRV/i2ucpuqR8VuaFv04VVZDWt8dgbPUFYcFLkij2eCejn9xzTr1Zp6Z
	WiMMSU7kJYJQd4f9m2rLyHFeksgtADipY4l6h/HcTZUAUAfOEqDnj1Eec60xLHycnLBcXJ
	uJeyNMWvtEvX9KG4ATQz2aXqQtWr+TA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795417218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wz61PR6m+Hv4KIDjJgpzt68ZFn1R+shrC/4PW4HJ6X8=;
	b=ZAToddN9FykJ9g1k3ehLivM7i7kWwAyl9fhLTYl6bM67KKfbdFhTS7O6D1vFBsWACgSwwC
	irSJpJ2H3VU5jbXGuG33uxL6dPTSVtOg2Ps8VpKxGhJ5elO6P0viZB5KahNKHmvYFpDwDn
	rFioaqsE7Gq8/7hMVqIX6SU+p/dTQ68=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LFO5kG6Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y6IFXvtm+aIMH3lUM18yqu4CvE/ZO2f55GMqbnpqCPA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795417215; v=1; x=1796022015;
 b=LFO5kG6YIw05GsVw8di3zyy/dHt3+da6fDxo6VYUV2g3lNk9Y3crl4iFetc0riIlFd+Cjkyw
 4Lx2EBBqCCYLAfy2tL84QauWVI11AOAdVxeCnZE57Qlybmv2sfzljdWAqWCeb3V08klUk+AM07l
 M4/4WTlLtMW7qkIupbEVPHCE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f0ff690aa2f0d91c;
	Mon, 23 Nov 2026 07:00:13 +0000
X-Mizu-Trace-ID: f0ff690aa2f0d91c
X-Migadu-Flow: FLOW_OUT
Message-ID: <a3add5b9-a69e-4e06-b91c-c23db9b6e1ca@linux.dev>
Date: Mon, 23 Nov 2026 15:00:04 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/11] mm/mm_init: factor out common struct page
 initialization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-3-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 802A080007
X-Stat-Signature: mxbt47dwhi3mr5pks19tuuzm96siatos
X-HE-Tag: 1795417217-433575
X-HE-Meta: U2FsdGVkX187SmmuO3Tww+OxMStjS5YqO5HFlqwDAqU8VeSvQdiUl+0UN+e7ut3vP1w1BrMZ3XravsgGVY9XiVMF0I4QLiqoMGKRAXW1ozuAWpr0XjpKIPLzBNAM4cXJYRr0SAt05sfrj4QPSeIvDb3raWTB3Bh3nCQnS+tnSq9HBd5w/7E2YbkRdDk/kBzEr2jizHDe71WdGZ886M9fw33rabZZ7u2YRqmindRy299ADUmnQFMFMuknjch3t1gN3uJYm5TrUXzI8774GVH+2akekUDfHSRH3pDWgKq03PmS1bs29/iZQjSD5cPq9kla14Zf1TD0/3/MSJ3Vj6aY8NS/AiSJW5rBq2DvogA/TIjLWUAJ0tfufPFb/YbU84PGr+ozv0efzUQVYhgDI3Evj9vOCp8dELblNUDNdipMXbSAn2riRVw43gN8s6dS81Yo2SEjuIGib1uwTGg/eybmDv6sSNnn5HGfPsSvIkJ9sItOGTfxv5khNSM7Zn9k3g0hPwtRj8tJioN7+bG3cKdFtop/ccmVyFNFcXmsKOsi2Xv01CwP/55lMC9LKO66HmyCroMSzyQ+4jQv2kjmNH7tYfIOrQ5O+lffCE/HWHOSUjUGrfFl8tFGJ5fEYmZTtMzBWIBt/YN041TKKgEA6Bg/ldWbidKKYX5PpomKWeuN7E/NTOoOdImoeID1wUvEr9etpmA+Ub1cBJojwleOz860vzKWFKc/v0nFH08jTZ6YN6WwHc2oCingCoW/9uYYaeN9zaWRpr/Tw7G6nsPGom4hroGGTXbeE7Eo5EvbVSiFi8/5Qq8UWUG22JKuowzY8g0o6147yR61I5f61YVT5mnc8JfFjR2EySjBgCq/ivQPp4o0UvUETusKRcTI08rR8OoUNF8bp+xlSoj5cAed6HJLIKxVI5XzLm6a4Nxz/J5HjqFE7O1ZdhjC5ftHnaU28fVY/DGC4/TPG3vv0VAtxiu
 YXCZHe/i
 BsHcGTjjEDN8Ju5mebF3qKczExUcloaWdHzJEumXV5xNUDh9yFKBYhr568IBUmjvoISVtZLr1mbbBrR6Ybg3iEqjGZ6yD+eN08IJajbWBuJQAfh98yDspQCyaOUs1iU6AH58nauud6eIY2pnGdNxZGk3mbU4k0JRAULAiLRi5QQSFGFAGoDXx6td/3/csoD7WunbPTBz5ubJcp3dqZ8jRrcUh9s4SKszsf786iU5RlfJgQzL6w+yQ5msRYC0O7XS7+eu3sABlHfXpUbd+07hllU8NiTYJDafl5AjLDQtpSqnJ6RmLhKRnY1CgaEtScmhth3VCmmuiPDLRe/f2e5VgOBFido9nUjMKw3GM35usQHqm1QBu5n8Aj0PU9MDd+hRRT9Eo6c3hCaRsQKAshmLpin122cf0499AGFfOjXpcsLCUgQzB53siToCGF6/Kj8ujBxKylfM06bf8R/GfdV5rd8W8tbHoecUVrGgVTwUid/IK4N3elnd9scoY5RbxH5Uq/f5XljVuWKkIal1sy0FIT1VL0KoIdD9e2pdLnOzeNmxM0S4phQWJXVN12A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 6:08 PM, Muchun Song wrote:
> Several struct page fields have the same initial values for every page in
> a zone. __init_single_page() initializes this state as part of its
> per-page setup, while the shared vmemmap tail path open-codes only a
> subset.
> 
> Factor the PFN-independent state into memmap_init_page() and use it for
> both regular and shared tail struct pages. Keep section-, PFN- and
> instance-specific initialization in __init_single_page().
> 
> This also initializes the last cpupid and KASAN tag for shared tail
> struct pages consistently with regular struct pages. Since
> memmap_init_page() marks ZONE_DEVICE pages reserved, remove the redundant
> update from the memory hotplug path.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v3:
> - Rename memmap_init_page_common() to memmap_init_page() (suggested by
>    Mike Rapoport)
> - Remove redundant ZONE_DEVICE reserved-page initialization (suggested by
>    Mike Rapoport)
> 
> v2:
> - Remove __meminit from memmap_init_page_common() so HVO shared tail
>    pages can call it after init text is freed (reported by Sashiko).
> ---
>   include/linux/mm.h  |  8 --------
>   mm/mm_init.c        | 37 +++++++++++++++++++++----------------
>   mm/mm_init.h        |  1 +
>   mm/sparse-vmemmap.c |  7 +------
>   4 files changed, 23 insertions(+), 30 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

One nit below.

> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8883b780b76d..d8bafcd92791 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3096,14 +3096,6 @@ static inline void set_page_node(struct page *page, unsigned long node)
>   	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
>   }
>   
> -static inline void set_page_links(struct page *page, enum zone_type zone,
> -	unsigned long node, unsigned long pfn)
> -{
> -	set_page_zone(page, zone);
> -	set_page_node(page, node);
> -	set_page_section_from_pfn(page, pfn);
> -}
> -
>   /**
>    * folio_nr_pages - The number of pages in the folio.
>    * @folio: The folio.
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 0129152b74d8..08d6e47bde22 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -602,15 +602,27 @@ static inline void vmemmap_optimization_verify_zone(struct page *page)
>   			page_zone_id(page));
>   }
>   
> -void __meminit __init_single_page(struct page *page, unsigned long pfn,
> -				unsigned long zone, int nid)
> +/* Initialize PFN-independent fields common to pages in the same zone. */
> +void memmap_init_page(struct page *page, enum zone_type zone, int nid)
>   {
>   	mm_zero_struct_page(page);
> -	set_page_links(page, zone, nid, pfn);
> -	init_page_count(page);
> -	atomic_set(&page->_mapcount, -1);
> +	set_page_zone(page, zone);
> +	set_page_node(page, nid);
>   	page_cpupid_reset_last(page);
>   	page_kasan_tag_reset(page);
> +	atomic_set(&page->_mapcount, -1);
> +#ifdef CONFIG_ZONE_DEVICE
> +	if (zone == ZONE_DEVICE)
> +		__SetPageReserved(page);
> +#endif
> +}
> +
> +void __meminit __init_single_page(struct page *page, unsigned long pfn,
> +		unsigned long zone, int nid)

                 ^ enum zone_type zone?


Thanks,
Qi

