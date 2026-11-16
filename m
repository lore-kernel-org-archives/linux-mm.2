Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB18606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LS+w2cy0
Received: by kanga.kvack.org (Postfix)
	id 2ADE06B05B8; Mon, 16 Nov 2026 05:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E896B05B9; Mon, 16 Nov 2026 05:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19BB16B05BA; Mon, 16 Nov 2026 05:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAE9B6B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:43:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7625F1C42E2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:43:07 +0000 (UTC)
X-FDA: 85440644814.28.2F3C11F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA3DC140009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:43:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LS+w2cy0;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794825785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6AXf0siXdDWvTk64l5wL4TOepYq/+Ur1vzvg0dCyJA=;
	b=mIxuZOdElPx0C2uLgHbSPU4nbtdfeCyljNr+gqWjUUfJZdP9H0tnkyPcWdOV1R0ETE/dlV
	kjDEVprc/2fhJX7SWxYtOEPwtncllaihC0OVvglyLaPHaklAQ+67fjrAPkkiVHe46Y8EW9
	qaHVt471WfEJR8yGeDNq7B31ARV5pw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794825785;
	b=8HeSkDJGTVNpHLsIbCSaJtOzcX2dvsXTVQfLwIN72dImwN5+PtQz1IuoACfym0czCMcFYo
	zm5e9+0u1UL0Sbi362O41bCj/VCh0C4USdx7+/agVexZjStxCdbGM4MLxHwc6ldaphZ97J
	BiTOcHDxRk3wWu0hFGT7mP7toeJSUSU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LS+w2cy0;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04D394622E;
	Mon, 16 Nov 2026 10:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4961F000D0;
	Mon, 16 Nov 2026 10:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794825784;
	bh=z6AXf0siXdDWvTk64l5wL4TOepYq/+Ur1vzvg0dCyJA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=LS+w2cy0vGEr9WdSp4cnovx0NKyZkKklwL9lzx14eRcHKdgIyBEl+AiKIkLSU2CpL
	 RXopJ7DfT3NDkhWV+PauZ7u6ernGjkM1cE7NVC8Fsli0N72mfUiDjn/5QGn2NEwWCB
	 +c45IvJBwSeJgD63I+T7kepVMH0WK+22zq/Wv1XRZ+1obkD37/K0ARf2ncY4EilRLF
	 hKcEFXo9ZQI/uAA760lHOzJC3eAokAL2CdH0ahIEs2MY3rXJOvkmORu2sOsEZ8qgkz
	 Zymg9q8dUiiub+Mjt169OOmqlPLaQCFnH+ws877YImPJkiTuWa+Dx5h3jwj+7frNTm
	 6GDWQHreFp3bw==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 04/14] mm/mm_init: factor out common struct page
 initialization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261113033442.62970-5-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-5-songmuchun@bytedance.com>
Date: Mon, 16 Nov 2026 12:42:48 +0200
Message-Id: <179482576829.2379196.2091312590305150578.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA3DC140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xx87wqkoe7uiq5inpomdcomg3dug9fxn
X-Rspam-User: 
X-HE-Tag: 1794825785-613590
X-HE-Meta: U2FsdGVkX1/HoiEGoOrSH9TGA7w5/1m/kWxXEFFFTwEtiGQXgS9uO8390EBjVBQ8hvmxMLwABMcl7JukcRjeOXFbf6Q7y+cImBAUIWI1QuPxcPow8FnmLuMfzg1yYQB6JJwYCT1tI/9tMJx+llyjRnCCX14+7socTvQET0ZEHDDqUiLRFIwDUTkKmtDP2XLgILIsJE3TSeMqievzwpnIUwU1ai+P0sNbC6mStgeKYYK4rT1HNjKclGYifnH1POghdmKB29cwXOLmA8xG0PRV/gKzl0F2vGLkMl369W4dZYD9efKz2eVWSZpD+wbmMD0tLp/7nK7syfVmiX3Fk9T1WOXAlvOtNIwreuZ86EC1LvldbqUWYeAd2ChPpHaMH1TY0RNti29P4935qNXO+J1I6lm3nueJiZxkrZjiBEbAls5JPDhEesXK1JWsp/7RHPh5B7pgUB3Rtcy7MXtcJL1jpVgLwzn330oXx6Bq01YK2j+LnaUaj5zX4pO5kMg2IrZuiHL/d2WLkwlsHg6At6k1SbrI081oHcOkucUM9ZpRQTgsqUfRzlZuCYMzqSmY/s8S2fA8NLDQeQJcuI6ioIWsgsTm+WHFOSaFaIDTyFhPoOL7RQ8gGVSYrpWIpsvpoZPbNz9dOri/8YmUSaGerPeMSO/GIP4K8Mq79MHmVZC59CKwo1UKo+j5uSWH+zykDjxLgMafhYn8BNxhw7ewu0V60WuQiSVCajHqLOBFq25hZHyUJ9B0O6iRuxNcxHFwj7afEpcMmcwS3qZ+6Apj/BIGYTmeyuZikiBUQFmYs5RfubBkcM76FKgnBHE+a/VnptpqU+CYS8SmUI0u6wVIZJs/u42h5uYTgtU/+2G5eRr/hckak8pZLv9fMJVld7/+ztlsuziI5bItZBX5ywrYEgZW0MN2tweca+VaUK3EgOa+tCQ1eu1ooOnFlhxQ3uL8wZaW3leWPn5nlngwySOiaBn
 0sVRHPBJ
 loccEMTFA1rTrAwkudYsaA4d9j9x+A6N1zCp+bGLalFhP6gwEDLQve+Zd6TrSiE8XIZWjlfBGOzwE33v4rMsQUAzZES6KZjS+mcrE6UF94UQYgKV+LKj+DybKKCvsaF0C+4/Ui8JYYr0KwX9n+PVgclXAiFyyn4t4rLAZz96DxInKi5zFpuqj3HWZkyH8YWPI7SHwNlnDks2aiyN520tx8f8P1hOdwSVKSKE/AEffsuAK7grzKrX75ymYpGIR1VIG2WZB6MjpjJIt8vkY8WmEVNMxF3TGnXOSlb6mU+HT7EgXSw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> Several struct page fields have the same initial values for every page in
> a zone. __init_single_page() initializes this state as part of its
> per-page setup, while the shared vmemmap tail path open-codes only a
> subset.
> 
> Factor the PFN-independent state into memmap_init_page_common() and use
> it for both regular and shared tail struct pages. Keep section-, PFN-
> and instance-specific initialization in __init_single_page().
> 
> This also initializes the last cpupid and KASAN tag for shared tail
> struct pages consistently with regular struct pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Remove __meminit from memmap_init_page_common() so HVO shared tail
>   pages can call it after init text is freed (reported by Sashiko).
> ---
>  include/linux/mm.h  |  8 --------
>  mm/mm_init.c        | 22 +++++++++++++++++-----
>  mm/mm_init.h        |  1 +
>  mm/sparse-vmemmap.c |  7 +------
>  4 files changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 77b5d450fe45b..2e182498898ec 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3022,14 +3022,6 @@ static inline void set_page_node(struct page *page, unsigned long node)
>  	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
>  }
>  
> -static inline void set_page_links(struct page *page, enum zone_type zone,
> -	unsigned long node, unsigned long pfn)
> -{
> -	set_page_zone(page, zone);
> -	set_page_node(page, node);
> -	set_page_section_from_pfn(page, pfn);
> -}
> -
>  /**
>   * folio_nr_pages - The number of pages in the folio.
>   * @folio: The folio.
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index af3b81733193b..d0a11989bd249 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -602,15 +602,27 @@ static inline void vmemmap_optimization_verify_zone(struct page *page)
>  			page_zone_id(page));
>  }
>  
> -void __meminit __init_single_page(struct page *page, unsigned long pfn,
> -				unsigned long zone, int nid)
> +/* Initialize PFN-independent fields common to pages in the same zone. */
> +void memmap_init_page_common(struct page *page, enum zone_type zone, int nid)

I don't think _common adds much here, memmap_init_page() would do.

>  {
>  	mm_zero_struct_page(page);
> -	set_page_links(page, zone, nid, pfn);
> -	init_page_count(page);
> -	atomic_set(&page->_mapcount, -1);
> +	set_page_zone(page, zone);
> +	set_page_node(page, nid);
>  	page_cpupid_reset_last(page);
>  	page_kasan_tag_reset(page);
> +	atomic_set(&page->_mapcount, -1);
> +#ifdef CONFIG_ZONE_DEVICE
> +	if (zone == ZONE_DEVICE)
> +		__SetPageReserved(page);
> +#endif

Can't we keep this in ZONE_DEVICE part?

If we can't, __init_single_page() sets PG_reserved for ZONE_DEVICE pages
and the

if (zone == ZONE_DEVICE)
	__SetPageReserved(page);

in the MEMINIT_HOTPLUG part of memmap_init_range() becomes redundant.

-- 
Sincerely yours,
Mike.


