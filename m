Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65804CD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6628E0011; Thu, 13 Nov 2025 14:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7098E0007; Thu, 13 Nov 2025 14:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3C58E0011; Thu, 13 Nov 2025 14:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1B28E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:39:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F4E9C0121
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:39:57 +0000 (UTC)
X-FDA: 84106599234.21.DD4E2FD
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 66AEB4000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:39:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VZL20QsH;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763062795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FffN7zEr7VpJ+2JoHAoCigjhXI7wqrK/ybSZLdiIYO8=;
	b=CjAOCnYA5hvHWzcr7gWGwpOCTnqeKqh2PoiCZvfkiQr61dagSez+W4egqHngmpHavc+3Mr
	JD+sE40caHZRHdqQqmmRLNPyL8X6E3+YhJ7FZm/BgSGYzNxuyn92OX1TLyl51g5hdGUjf4
	TiPJUcOfXeR8v20AGp4aITRvQhVquGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763062795; a=rsa-sha256;
	cv=none;
	b=sfHdHQ9dHHcUHburXCvfV2QmPirDYZhezJjnpE//5o8XZc0hFhDaaz8zqpLhb3uA1IuZmA
	p2lHcnpDHOPRkSeg9+h6NvWvXYP6ir+kgc3pChPwD4d1A6EkgcBeJn4YKYEmDJdzaXZ3GU
	IOMMbWNZUsUdCpoGoFdW6QTTHFiRl0w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VZL20QsH;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ba488b064cbso939153a12.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763062794; x=1763667594; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FffN7zEr7VpJ+2JoHAoCigjhXI7wqrK/ybSZLdiIYO8=;
        b=VZL20QsHlTqCBONWwrtEJUEbA0ie7n2/ALQkZ6OjkUY01MuMFRU/F6p9PY0Y1TyCZ+
         4eqTQU0oWacgo3pPo4dJLP8oU8bs//C/e3OFLOMjRgqPJJ/50sRRS+Az8lcspFYYWgS7
         1myqgrVuk/YxiDdZNe+pbHUdGQKK7Om6Guuhk+cKNvIImdHzL3+bYjDSnWP6YMP3wemk
         YYTyDebGwWor26VfTVYs7KC/aUa4z6iEjur6T85waGC7omsddnPLtjV2HD+9Y12CirT9
         NJP65V1kh4dRbpaZTcyRDA6XiZt5XXZZ65yr+q1TVHDwa4jBK+8I5e9s+40gDPPzmPGH
         HAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763062794; x=1763667594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FffN7zEr7VpJ+2JoHAoCigjhXI7wqrK/ybSZLdiIYO8=;
        b=geffJ36yCfq0LMC1yD96Fn2bA/hKNYx3um0qgAgK2xbbI9R9THYSHy3f9CYB1oXlgB
         6MLcitt5Pz7k5LVe6kQoofE/gQiyF6tHcO7A5wpUwxkRjOQZfU5Go9KcdbkItVx9+B6C
         BPIOyG7RyDmSqm/o0wEcXVtGALM6F2t7Q+FHKV/8I8lKJzolQtcZMINCSf9blKMqLUQU
         tkkiElJXqXAJXdtHwydMWqqPY4b/c8GmP+xLSlSnDSeZv+d4OzZ6LvL3RYJ3x0Z2RKn5
         Qr3uWN6NiVhhXvSQwOoWPr7saCbZl8+8zOcivtxkB77NQCJCsDd1KAETsoSj9KLvbAoS
         mypw==
X-Forwarded-Encrypted: i=1; AJvYcCWP8D/jfyuX+CfU+2T9lLCZMCO6Y4VvQIQD4AhwaPHuaAp/oRaDvkoj/c0RCXodlbJmZ+pUZgVMRA==@kvack.org
X-Gm-Message-State: AOJu0YydimSvsNfM0POHI9fZUxJ7cIWO01drpB5Uk6Sv2WkazUXV88Fz
	M0R7BxiXiUScgck24Q5s+Y8iUHtoor3ngpk69G0Kw51z3mBdppmkb8bd
X-Gm-Gg: ASbGnctMa0eNO4kEGl5I7LRhDsEBt5tkFtOC6HM6fwPmpk1Go+jkYIAXNxsNTlka39s
	ySv1snN5e/bD3n6PyrL+iZzJhWyo+HZuEwCINBHdoa4ZsC2CRHDp2u6bza9U6b786VHrdoNM9Gv
	PhSwJNzYYdYaGq7ljdK4XHEgrO8GFFKtxKMqEJZY14Redaw2ULNRv9CL9QEUUKzpkCxPJb2CF/T
	BURP2L5GI7G6ZT1ZQEn0gKMSK58WwThHgycNKDYYfNEWcl3gIerlTEHU4QWG2+la0q9rFE7suTi
	hTkvPcBqT+u4yw+WxksG0PJuJtelCcmA+qhcurfk7cRYoP8wlQEecdN2kHBwB5yGXnTV+BpMSjG
	pldxQuvJu0uvxl75vesvER8uoxuJeDm0oSMsS1cjBH2Kv9Y5xdCvNMRfiPnUbD3NgDP6V6ZT4oE
	YXUzXH5TyaFleNrR9whDp6tMl05UIienvoHlmd4+L3a2c=
X-Google-Smtp-Source: AGHT+IFVurH0gpbBqQKfv3USlZxh2mlNsqOoitjPChzn16RCIOHtnoQ642edQsTnR0yLON67ctrV8w==
X-Received: by 2002:a05:7022:3883:b0:119:e569:f60c with SMTP id a92af1059eb24-11b40f9af3cmr231606c88.5.1763062794016;
        Thu, 13 Nov 2025 11:39:54 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11b0608860fsm751098c88.5.2025.11.13.11.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 11:39:53 -0800 (PST)
Date: Thu, 13 Nov 2025 11:39:51 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Will Deacon <will@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 2/4] mm: Account pagetable memory when allocated
Message-ID: <aRY0BwgjVM2xrBnD@fedora>
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113140448.1814860-3-willy@infradead.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66AEB4000F
X-Stat-Signature: rtgp1y9mxqgo1w4jggfde6junhuft5es
X-Rspam-User: 
X-HE-Tag: 1763062795-439986
X-HE-Meta: U2FsdGVkX19fdJM4Eum5KIl4eeLqTVlBQkU9I0fZDMfh9cqX7QWiUjiQTtg5lQoxLp33Z3zF40IZUdXnhCIuaFArW+2ZnpbV5+pc+cuLZi7AiiYdzXMYLENkAN+/mn3vIgRnLz0I58I14ZIsyCeNL/IPposfG7CQzuFuFcYAAs+ft3zKqBOQZ81M5VkVEtBhpvYw4FbnvB1JSnNXDjBpSa1qrhMLXXi16+XGL2BnxLTbLS6/XxioGMMAXhfaVJuzzAwmi9sFVeVrVxBJ8cM9fSJMUiNJWMsJAZy8GkTraU990LMiASEP4SqaWFs2X6Ol6XrWR82XIrYepR6xJnyJWsuwCp6vmTTcYh/D2WDG37sGhLJMK8VH+9ZAeXOoy5u8+KPfUw6uBgiyZyDKKqDeOqQ3kHa1wrgftcE7jp1tGHrW1q/khLrCIMH3/k86ECIyZQH2v4Lh8afjKhXHde1zS5eO7Vl4zZ1NpZpcj/H5c703SuFQ64ikZcM5QN6FYv4VWo5gn/XvjN/zyfgtRNaA5tsSuiro64zArQCdpebjTwh2dhU2AaSmSiVKdNK3M5bziPtp2SMbNIY5AIqb4u1ePgqhfwGkvIqDUXpuQWcLdFG5thCWNR9fz8uViaBpu7X7XFVLem9NuJ7ZS0R3yn/iWmpP9bvCUpeJ7L2YbRHY7fU9jRNUkdAmdqZlP6FNvUNAw3Vz3IVyb/nAvBuNOigKOJVpwXz1/eXB6Mn0JkvmOD2Ql8LA1HE/3rp+aKKSsVdDKX6KF/rYcnybHfVb7rYoYnHSyvtUWrfv4QWk/L6HSRDz1DLDUVpjaXBKH5h9nGCeo8ArbY+BLuMrCXEANviHWD4e+U1lrVqoa9wZGB+2DGmqAreEZaP7TNA/KQWxi702w8SQ35J3aic7QTAPT5FF+GjfmUObARAH6RPAo2PRZBHKlBdUDrLuWcAVo0m3W/3/GBNO+UU8Kploqksd1eZ
 6fBbFrJG
 5PeGd4iHG6P+P5AIMwv/0K2Z0VaN5vtgITiXZWoXORvdeiNgAseaE2Z+TZGWXN9/LuI4jYUu7TTNvVqYnIu4Ya0VVEmscrGrBHx62D9Rin3lqdy2NwIbiW2no7azbqkNevOAnL63RME0sVRAr7Ij5Djhi2rwj3CyEwTQxyUTySOBYMDxUSFHe1qHktTQ3cJb8lRX43Q3BDk5vFMEqrbg97cw6audwmHLPTRl3cTHod4VsV4jdODq0Z6JQjmKJ3v1SEhMv3pdcU2X73vX3mY2Vy4eO3DPb6w5KgxNN5waLuXjdj1bURAmTrJ/1aZogpV5yWK3hvFwKDBEJy+qMYF7z+K+a4LGyZtrlv3vejfRuBoQtEhFnuqeS2zU4a3x/9F2ptCosvSlzwj5EVla58qNNmaGikVRMxWcVPO5NGLMEDGBVXHFZC+3ptFHUGh/XQzDsHFAay+XgSJQtGsHrKTB0VtEMTZr5iMC1pPN6bnVWF+GcP+8fLTB9SizuOiz+YHi9kjbfeOhP0DKGsjDqWx24VLXBCosB9Resk4OtUcw04AbPfCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 02:04:44PM +0000, Matthew Wilcox (Oracle) wrote:
> Move the accounting from the constructor to the allocation site.
> Some of the architecture code is a little complex to reason about,

I think the patch is correct. After taking a look at all the paths, I
noticed 2 cases that I'm uncertain about:

1) Commit 454b0289c6b5 ("sparc32: mm: Don't try to free page-table pages
if ctor() fails") implies that sparc32 uses memblock pages, so we never
actually free them with pagetable_free(). I'm not sure how the
allocation path looks. Would this break the accounting? +Cc-ing Will.

2) In !CONFIG_MMU_GATHER_TABLE_FREE, tlb_remove_table() calls
pagetable_dtor() -> tlb_remove_page(). I'm wondering if this may run into
accounting issues?
Commit f21bb37afbba0 ("mm: pgtable: make generic tlb_remove_table() use
struct ptdesc") says it's only an arm thing that needs to be fixed
anyway. +Cc-ing Qi.

> but I think this is all correct (and slightly more efficient due
> to having 'order' as an argument instead of having to retrieve it
> from struct page again).
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h | 11 -----------
>  mm/memory.c        | 16 +++++++++++++---
>  2 files changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e168ee23091e..17f783c04c87 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3082,26 +3082,15 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
>  static inline void ptlock_free(struct ptdesc *ptdesc) {}
>  #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
>  
> -static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
> -{
> -	return compound_nr(ptdesc_page(ptdesc));
> -}
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
> index 781cd7f607f7..35886fde189c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7351,7 +7351,13 @@ long copy_folio_from_user(struct folio *dst_folio,
>  struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
>  {
>  	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
> +	pg_data_t *pgdat;
>  
> +	if (!page)
> +		return NULL;
> +
> +	pgdat = NODE_DATA(page_to_nid(page));
> +	mod_node_page_state(pgdat, NR_PAGETABLE, 1 << order);
>  	return page_ptdesc(page);
>  }
>  
> @@ -7364,12 +7370,16 @@ struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
>   */
>  void pagetable_free(struct ptdesc *pt)
>  {
> +	pg_data_t *pgdat = NODE_DATA(memdesc_nid(pt->pt_flags));
>  	struct page *page = ptdesc_page(pt);
> +	unsigned int order = compound_order(page);
>  
> -	if (ptdesc_test_kernel(pt))
> +	if (ptdesc_test_kernel(pt)) {
>  		pagetable_free_kernel(pt);
> -	else
> -		free_frozen_pages(page, compound_order(page));
> +		return;
> +	}
> +	mod_node_page_state(pgdat, NR_PAGETABLE, -(1L << order));
> +	free_frozen_pages(page, order);
>  }
>  
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
> -- 
> 2.47.2
> 

