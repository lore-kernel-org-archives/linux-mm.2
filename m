Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E27CFCD3438
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA57A8E0005; Wed, 12 Nov 2025 13:36:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55DD8E0002; Wed, 12 Nov 2025 13:36:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BEF8E0005; Wed, 12 Nov 2025 13:36:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 829298E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:36:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBF6D5A06B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:36:42 +0000 (UTC)
X-FDA: 84102811044.16.05716F4
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id EFA52100017
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:36:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L448ludc;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762972601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43sMwmY+x95IIvWlMd42gIbNYo3AjZkoyKhUzYaYDBA=;
	b=kSZAWYbuBFGorind4uRAxETcQS7CWa2/JDV6nPGbGQ6k/rvpk79nI21osS8daV55yA/yW7
	gfy+KKrkykWkIVd1+/BPAWXRkXeF2tDnh2CS8qlPY7DuXKSvI9kQ23QzBeHUOCDWTs0cAk
	j2LRNeA2NAgwsnL7auC2XLLjHTcHuOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762972601; a=rsa-sha256;
	cv=none;
	b=gRSixUYqXaXFJ23WrOWSjvLAfmpIXUQm80KxRSI5LoYy6xJyILAAhYR4kXKFw9gLlznOXL
	un9jW+9hilXq+n46RqZs1CBMdUbblJtUUaS5FvaCI7vCDaEdMsMADje7ATFhSTbOI+nzuh
	WrHSUSPGzQx3IT6o9fw9DdNoV+E+WNU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L448ludc;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-343dfb673a8so1069362a91.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762972600; x=1763577400; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=43sMwmY+x95IIvWlMd42gIbNYo3AjZkoyKhUzYaYDBA=;
        b=L448ludckYRvb91zWK4kG4RfLgf/oOF1aAS3FxLwtIJufPiU39gvwmcaPZ3oOBScj3
         3nGfOMD4nb01B9STVWvdWVpX5orazDBEutnNp5Ia2m2ImeYy5SJ6NYxnFjmdJUSarVNI
         MI/fRk6Hpd9wbRur5E0xehdz3pMjia9ZdEgkT8+9yD/uoZGqNbty4UEqkHEP8ItMg28a
         DBcZTuXFGlrs4V7r0ZDqJk4S6Y65pLzvLmXDYbz9QG1qlNdyvq2mDgkzFGcjrhoTAcgb
         XrMV4YIq21lAI3AqCXIQloF9TNvc5i9KuzGkPBm44+ALMkMhw1k3lKD+Y/NmqlbYfXr9
         B8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762972600; x=1763577400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=43sMwmY+x95IIvWlMd42gIbNYo3AjZkoyKhUzYaYDBA=;
        b=LFURrn9ZSXfXgQ/6OBufwIMdWUH8NYRnRPR45jWpgYe6W48SDSg/g6S7Spo6/Yl4RO
         4OWY+arkrh4CemPt/IUHokVjtMPCeEuYZOOUG3JOFqKKUT6tdqGr52XW9/6JJ66qJWea
         0Tqg4KK1MCsjiQea5cPyK7zu6jKciMtQuxQKqrJNKNExgoPIiFsHWaebRlCV+Nju+rzx
         s1zD2sHyFBVTOYi34wZ3hrCFffjfeUsmDVLcsi0W9nrIbsCiA4EtuX+JXMx3wkdnx1Kg
         InAGddV0ZuFx0sVSCjuKSV5rDLG+nRMcJwrWYqXdfS2yqPXd/AA+V7GCDqbxm/o14/+V
         F0sA==
X-Forwarded-Encrypted: i=1; AJvYcCXxFdWD3sPjI45LZTNidPmNfOLdjAqEJSo+8MOYNPgX2Q1wdDU+LnZMHzyRQL+B49YfwBpifltIUQ==@kvack.org
X-Gm-Message-State: AOJu0Yz240iUuTiCWCokB3ckzsVkJPYYkBYFcH672E5kkLQekLwAtcRE
	sfjfnOlvMXprHbyVp7I4TOFukLJNGJSABQsx+mlngXbSSQuYGgdFovPO
X-Gm-Gg: ASbGnctmry7ugZpo2wPRbqBzfb+avRh4xM1A/1Fghks0anwQjKB+B3ws7xdp77XoccY
	0QvH/Y002aIJakmrP8NJ78Q7kpBtiWxSP6PqAxkJiY2hT+h9oscCP9RJpL7PRfN/pVpKm7TY3IT
	gmPq+fNfcDjUOAw6QBluAL/6tuniSgBt8k8tzmtYe/c1DKpBYRN40yg3wHlFmedMJoLicM0S3Z5
	Jdsz02LAhoKNfyN9Nj/nHzNfIohkHqrIKodnt3idNQCCUurvyn/Fx5oaNchb7aOOv9ZF7YzC6t3
	aFxqKE9PMjST49s0QefKR38qYbojQjMMnEi0UJ2x+fyAnP3GsfV6P4d4Pg/ikhxgy1mgX+dwIoz
	UBogsGSkiLAQftIdSXA7GIQfINX4eUpt+26gOMXNla0QZRqZT9zbd8XjehI6BXWHI8sENSKSgou
	TjStwZgOoevLcc/870+RQ0aFao+XkUWYzs
X-Google-Smtp-Source: AGHT+IFIY7TGBR43iEFVVHQJrGO/oa5jB3/uOicYbRjNImvnXh2o2z3ZQOHvqTAHT5TLw1tO22awJQ==
X-Received: by 2002:a17:90b:384b:b0:343:688e:3252 with SMTP id 98e67ed59e1d1-343dde01c6fmr5655694a91.12.1762972599538;
        Wed, 12 Nov 2025 10:36:39 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e07bbbd2sm3413550a91.16.2025.11.12.10.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:36:38 -0800 (PST)
Date: Wed, 12 Nov 2025 10:36:36 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 5/7] x86: Call preallocate_vmalloc_pages() later
Message-ID: <aRTTtHQwfOm-loMb@fedora>
References: <20251020001652.2116669-1-willy@infradead.org>
 <20251020001652.2116669-6-willy@infradead.org>
 <29319ba1-9093-4ec4-b84a-3c60d2b00264@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29319ba1-9093-4ec4-b84a-3c60d2b00264@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EFA52100017
X-Stat-Signature: n51z4t8dockarymmr6r6t4bk64sc9f1p
X-Rspam-User: 
X-HE-Tag: 1762972600-253577
X-HE-Meta: U2FsdGVkX1/L0sG1dLnyCBS42ZSdd3FPBUxhfx83g924uWY1ytMaOR6rggtnY/Tn/Otvzt9r1c35hacsg6ZuldKLqCd5eBxSckrEUWo+Goh3KXGF1sXoCeqAXlfyc/3rFcPxEPbqQmKvffFZiPbZzc0CeQBnZLhtnYLcgYiQNiyOwrg4PE9YfeozF2urt81jaoMIU8Ig6cv/OHI4AEeafva54i37vY/L7bhK/nXQlT74st6WJM2tQckM/lIS2YisqYS4h6xImcBT7NI+ujy2HkleGADc13GsXh+NqpGK6EakrMjmJPIgjOvyLfHsCxGvzR0V6U/At56fvmBEDilTfb/PwKWMzP9Yd7+WDEFKoUM61JqbszCh3GBd4jmh67qwMHPKV/hFi3pSsyqHM4SDgUfddmAg+CBaTN/q+VcoLJZqka8htlaWEQKQhQZBfn/4OVJGJlJz+No40xityKBnXuqI4exiWUtSPP5AODPZTwfh8KUDyVAtb3eaTYGnrvapP3vpC+vtFLCAYfayYP1Pk92o7OonpbmjkzyY0QzuUhuqm9bgSWuIzWWhD8URparPvc7P33ucPGOSwpKqjZgicCWI2N8wD/0kI7//D5Cc+cq9Gj3zq4Keb96TOG/WVnHDohBsYjB3eQoxMv/hTqday8+HBzFA5OClWK3g97uAlZ2/VcFxRiz0JYq9cDu7MPL6zE7CcghYoVbUJplPN9oBkwJZi6EtearVj6ySgoYgCt/v95bMosdA1vCtQfKYJ82t0XWKBr0XPUHfxEoVV17ydDrcceDOYXVt4njHJqd9NWVSCuhVYtXtHsJLNisakDTUs5fFX/GSy0paWE4aWbQs0QjQLHVlOmRuQ+p+Es3x0iD3ILsztoiIK6cqQViOjZhGKclMHN8xXv8A3t0qGEEN9KOp9rihBPCylqFxPtQluhyA5aSlsuJkJJNKJKag8j7YL/BpUTTZbN9LGR35oLr
 NnwmNEHD
 UsKsUQKMNSAqGKUq6RplXd3Jo/Ya69pbZ+npPwWPnnzfR/vd2U/BYAsgr+EeEE4lYPcT96stgwEk48xWbCUZqEztxkuzeVTsC7Y9ejxyK94v6keeQLSgosuCW4tDVxA2YHIUbATfpkldVkWj/IWBiw47c7YEwWXhu4WESHgP+FX1/YKsP3KbRG0QVWaeFrQlUsh6t9YFeXeaEntGLsCbmo0iVU0zb5rysrXOiAkF/agtKtBkFy+jR6DwZ79+Tjkh6SsI7fsOOwu3vuF1kq89S/8k682qvAO2to80hXxVQVtQVUA3sSBcW5hq2Da8BQmLC01Y8OiXhKKzhNL3jj1n8RYnr2T4UQ3Ln3Mvdr3f4OnGvKrCHpymZEd6YqdgaTsCUaLnd1PcxjDmXHKvSJ2EM+xEw73ZTBYJcXUu4w0QoRQNL4VefZOXI6SNsBSUyQb9+2uNiw7tZC0lEDBovz6cCzx9FfVuYQP389goOGFeYuZfpZ3fTXLTwiUJf/kcXV7YXb0gG0ifnAUnF7+tv1ZhsEtKYIQyQvBnjLuz5+okOjqI8ma6tqbGDHPA1GTT1mMa7w90k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 02:29:44PM +0530, Anshuman Khandual wrote:
> On 20/10/25 5:46 AM, Matthew Wilcox (Oracle) wrote:
> > When separately allocating ptdesc from struct page, calling
> > preallocate_vmalloc_pages() from mem_init() is too early as the slab
> > allocator hasn't been set up yet.  Move preallocate_vmalloc_pages() to
> > vmalloc_init() which is called after the slab allocator has been set up.
> > 
> > Honestly, this patch is a bit bobbins and I'm sure it'll be reworked
> > before it goes upstream.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  arch/x86/mm/init_64.c |  4 +---
> >  include/linux/mm.h    | 33 +++++++++++++++++++++++++++++++--
> >  mm/vmalloc.c          |  2 ++
> >  3 files changed, 34 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index 0e4270e20fad..5270fc24f6f6 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -1322,7 +1322,7 @@ static void __init register_page_bootmem_info(void)
> >   * Only the level which needs to be synchronized between all page-tables is
> >   * allocated because the synchronization can be expensive.
> >   */
> > -static void __init preallocate_vmalloc_pages(void)
> > +void __init preallocate_vmalloc_pages(void)
> >  {
> >  	unsigned long addr;
> >  	const char *lvl;
> > @@ -1390,8 +1390,6 @@ void __init mem_init(void)
> >  	/* Register memory areas for /proc/kcore */
> >  	if (get_gate_vma(&init_mm))
> >  		kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR, PAGE_SIZE, KCORE_USER);
> > -
> > -	preallocate_vmalloc_pages();
> >  }
> >  
> >  int kernel_set_to_readonly;
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index edcb7d75542f..e60b181da3df 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1160,6 +1160,12 @@ static inline int is_vmalloc_or_module_addr(const void *x)
> >  }
> >  #endif
> >  
> > +#ifdef CONFIG_X86
> > +void __init preallocate_vmalloc_pages(void);
> > +#else
> > +static inline void preallocate_vmalloc_pages(void) { }
> > +#endif
> > +
> >  /*
> >   * How many times the entire folio is mapped as a single unit (eg by a
> >   * PMD or PUD entry).  This is probably not what you want, except for
> > @@ -2939,9 +2945,32 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
> >  }
> >  #endif /* CONFIG_MMU */
> >  
> > +static inline struct page *ptdesc_page(const struct ptdesc *pt)
> > +{
> > +	return pt->pt_page;
> > +}
> 
> pt_page has not been added as an element into ptdesc and hence
> the build fails upto this patch.

Which commit are you basing this on? It builds and boots fine for me on
6.18-rc5. The commits don't apply to mm-new anymore but that sounds
different...

> > +
> > +static inline struct ptdesc *page_ptdesc(const struct page *page)
> > +{
> > +	memdesc_t memdesc = READ_ONCE(page->memdesc);
> > +
> > +	if (memdesc_type(memdesc) != MEMDESC_TYPE_PAGE_TABLE) {
> > +		printk(KERN_EMERG "memdesc %lx index %lx\n", memdesc.v, page->__folio_index);
> > +		VM_BUG_ON_PAGE(1, page);
> > +		return NULL;
> > +	}
> > +	return (void *)(memdesc.v - MEMDESC_TYPE_PAGE_TABLE);
> > +}
> 
> Ditto - these elements have not been introduced. 

