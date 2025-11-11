Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E16CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691048E000C; Tue, 11 Nov 2025 02:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641328E0002; Tue, 11 Nov 2025 02:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E2E8E000C; Tue, 11 Nov 2025 02:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46D6E8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:09:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B33E013AE83
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:09:27 +0000 (UTC)
X-FDA: 84097450374.18.66FFBEE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 91F451A0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:09:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sht04/nw5Htj22jyDmz1ouYpQyOEI+d1DpwQBfF0RNs=;
	b=LXo6/GP44F9DeJF6fPi0ZrKR1dIAQSm2KWZYPZ9Y5/o3/XrHXj7cBPkPlfj1CPZTebvKZm
	cDguBiBZY5PE+qT+6bOErWxCtUUmuLmNSF6HQHxs8z58IpxUNhuoqYMvoqzzpqZHxvL/rF
	FebVe6SJKcvj/GoepMqRY4grvnDkN2c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844966; a=rsa-sha256;
	cv=none;
	b=EZy3f/GcV3Fg+hsNlEZVUD1NEUEZonER8lIc0L85ciS09jP1yilTZUJqoelbUr+t/ldf0D
	xtzzUSB7d//tSpeqLEsKocUqCDqR3lx6uNvPOZYOhwclHbg7ggYSr+D/3XDWckOEiw/Uph
	ngWjSOPbO3Ad3DaWA7hbA5zfvoQRdBU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6AD12B;
	Mon, 10 Nov 2025 23:09:16 -0800 (PST)
Received: from [10.163.74.35] (unknown [10.163.74.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D86853F66E;
	Mon, 10 Nov 2025 23:09:22 -0800 (PST)
Message-ID: <d71ad346-e88b-45a8-b873-c7a3def197a1@arm.com>
Date: Tue, 11 Nov 2025 12:39:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/7] mm: Account pagetable memory when allocated
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org
Cc: Vishal Moola <vishal.moola@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20251020001652.2116669-1-willy@infradead.org>
 <20251020001652.2116669-3-willy@infradead.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251020001652.2116669-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91F451A0002
X-Stat-Signature: yegzcoqk7ctbhrangy3kmscseux65xfy
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762844965-564864
X-HE-Meta: U2FsdGVkX1+n8cyWtWSq7RbvIdotDTpW2iQb8qZjzEnwQIr4uZIgwcD64/+rITDTVT8ShRF38vSYLsNN/HzG4AgugLs0FKnC6W4GHcINmy6+Lv5NoQKqsXZnaDrDWL3/FSO0e0YmMieWVo6U2hT31CRM0CabKGqmN94MGqfp3MWv6wnrKiWXCD6LXh+Bgge65yi7MyNtn17lGscsbuJ3xx7cNbjCkkJk3RG5eko3cTcnDaMSr9XW7RdxVu0Pg47MHtQFnC7qyN1AKfRyImr7Z7e+Qj9A1SX+dpqnsJd47UUUdT8aTM8Ob3LWe+8xOgN6ETzCKwhsU7Gv1Oi4fAn77kN9cp0CHcmAidwB/a5krBoPm6JPIe791B/VjBr+G8dbd+a1jl7b0NavLnUAoBds3pw3vVikJWlAnceBqMyfUSwFR+IjwLJXGAs/1g4B0yZnZjhfbFIlVD2oJxKjLhdhesXJ44+1H1PqHhBhCOFAPcfzg1bzpM2A6tx4DKEndXjrOMSqV6ApOARPg19ydMY9uag6SAkHstAMHT+3oi9mXth8D8alJhaExUU1wWStHl1AH1vr64HA2c1UOqX1vsgwVQHrH7zF1Jxaa4BTSPNVLvQOwjl+Ax/WR15QlWu9wTAITdli6pkd3qO/72IUyl2x2UKACxgw5DIGfsCawQdfNQwtQ0c6aod9LCsBOah5EAdF6Wm70EKp1AYQA9sCbpG3BDqc+RpAi0bEtQzzlmQ9ndKCqgqQNTBpjy5Y7p9mWmYhbnwAEj6yQkr+q7jdkAqWm7T4fpxGti5DxZO5xCI/gCXWERF3KF3GCAutzzHNw83KxHdNrlHS+Zuwk/JD2lxBWCQ3WXDNys5dzF/OWW5HxZCDXjDXquOiRO7VQyMV5C+WAwGSy2smpUycrK9ft9RtGSecz1NK57SQdhvci0U0pl03y0/N2EZAzypkqFGO5e8A86hEwpPhyjWBC4V6Yvv
 ZBbo0zEw
 yop1XiSHgxHdRWbcgyUVWin+BcownKXuXIL2qoE4H6w4rckL2HT/T0gV0IwdFjTXwYm0UZwQ7pE4Lbw4Szh7JRLUhBty8XHf1g/89udyMllSVJ/BxRulcb1Q6THkb/I92OCsvvM9HHRRCuZLqikGAHgr1uKkyS9toxJEo2Hn1PFw34UmRyIbk6aayyAPEnhRP62BZA30t2RSehCV9LsHpjYJXWyEP9+B/BnmasJ4P5lgSyKgreyVQxD763Cq3nZBxGETFVuptwICs0lMPDEhDVS2FyqjxMYijPiQjMl/UfH7SfNhtsLK7yb+1NA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/10/25 5:46 AM, Matthew Wilcox (Oracle) wrote:
> Move the accounting from the constructor to the allocation site.
> Some of the architecture code is a little complex to reason about,
> but I think this is all correct (and slightly more efficient due
> to having 'order' as an argument instead of having to retrieve it
> from struct page again).

Agreed.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h | 11 -----------
>  mm/memory.c        | 11 ++++++++++-
>  2 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ec9365375d9c..ade37df5ea2b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3044,26 +3044,15 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
>  static inline void ptlock_free(struct ptdesc *ptdesc) {}
>  #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
>  
> -static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
> -{
> -	return compound_nr(ptdesc_page(ptdesc));
> -}

Right - ptdesc_nr_pages() will no longer be required.
> -
>  static inline void __pagetable_ctor(struct ptdesc *ptdesc)
>  {
> -	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
> -
>  	__SetPageTable(ptdesc_page(ptdesc));
> -	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
>  }
>  
>  static inline void pagetable_dtor(struct ptdesc *ptdesc)
>  {
> -	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
> -
>  	ptlock_free(ptdesc);
>  	__ClearPageTable(ptdesc_page(ptdesc));
> -	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
>  }
>  
>  static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
> diff --git a/mm/memory.c b/mm/memory.c
> index de9f999ffcf6..033fc4e29232 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7280,7 +7280,13 @@ long copy_folio_from_user(struct folio *dst_folio,
>  struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
>  {
>  	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
> +	pg_data_t *pgdat;
>  
> +	if (!page)
> +		return NULL;

Should not this check be moved to the earlier patch instead during
the page allocation ?
> +
> +	pgdat = NODE_DATA(page_to_nid(page));
> +	mod_node_page_state(pgdat, NR_PAGETABLE, 1 << order);
>  	return page_ptdesc(page);
>  }
>  
> @@ -7293,9 +7299,12 @@ struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
>   */
>  void pagetable_free(struct ptdesc *pt)
>  {
> +	pg_data_t *pgdat = NODE_DATA(memdesc_nid(pt->pt_flags));
>  	struct page *page = ptdesc_page(pt);
> +	unsigned int order = compound_order(page);
>  
> -	free_frozen_pages(page, compound_order(page));
> +	mod_node_page_state(pgdat, NR_PAGETABLE, -(1L << order));
> +	free_frozen_pages(page, order);
>  }
>  
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS

Otherwise LGTM.

