Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01811CD3444
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AAA8E000A; Wed, 12 Nov 2025 14:31:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B7A8E0002; Wed, 12 Nov 2025 14:31:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413398E000A; Wed, 12 Nov 2025 14:31:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2548E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:31:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1857140699
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:31:28 +0000 (UTC)
X-FDA: 84102949056.15.D6AEFA7
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id F02064000F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:31:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FZHfVSPW;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbWXdGium5WT582WXTIZPEFMTUPHcX5qp0Lk00cNrKA=;
	b=nKs2PGmTGDRK2SD7EpRIzB6BXYhZz9PbKoI6/nY6w017oVfCulmkMZtY4RBPO8GmBB4qj9
	QTHvrJy/4N5INAiWDl6WzAN+qTS9VClI+/nxgD6iTTv/0XIsj3HY192pyyZS/aixwT2Ugf
	uRFB+lmS4XB/Acep6drNiZPseXszSj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975887; a=rsa-sha256;
	cv=none;
	b=D9HuCSQsyIPBIYu8xZxQBxAro5Na/PxtaOpr7XdExujhUHfNrfZSlkyiTv1Id5VDBZoe88
	zGtUAU36xS1MOMWVRtsEGW61+ZYOUFT/wlstSCSK7R+rtm8mCv8Ue/8ZYLlU0H3WWxVW/J
	BC0Cn+ejtLDeYhMXPx5rF9sP/tY8EzM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FZHfVSPW;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so1079149b3a.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762975886; x=1763580686; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xbWXdGium5WT582WXTIZPEFMTUPHcX5qp0Lk00cNrKA=;
        b=FZHfVSPWPHT3J9t/FWVEtlgE9Q2dVQ/fhKz6CxQZ5fXNnS7JF4lVyaH/3gfy3/mqTs
         0DeczVMZNCrFxhuT1y2uR5ZgKCWP3U3axmjS6fh9+GSW57wXxKFLbWMuepMAz5+tIa6d
         +kwCdrN+utZ6iJrnYsEPFjG2F8BHh+ez7kXlEhSoIO31m7V6fJRpFdNicoHWVxZ3G7Ui
         KdHJj/Dm1ilKnhATSDEdh43gynF+fx9qxi8Avdg0AKnNsok0wqFMyZOBjov9QwPfbNdK
         wPVGshoMFZryCDImMxZSSI3NykS6TTql/lG+GoHf1d3yf3+FTLRpUjzQ1vEfeodJj+36
         rsUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975886; x=1763580686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xbWXdGium5WT582WXTIZPEFMTUPHcX5qp0Lk00cNrKA=;
        b=lz1TBy+tGBTh7EqZ/PngT0pKTuwgIsCfhPJTCp/Yy+cOet7a3Bk8QwxKoyahv0ShJP
         c3sWQTT4rzZY5eMz6jJVZn8fVeKFUzbPKffJryalzVEOsUHP/j93IF2Er4/D42jHlQjs
         oidWjcVzLdqZ4iMcSMdUsXwMAvdGWeJQ/DdnMoyzFr0uj6N25xxpK/R2PbHmsSqxOuby
         d/1hk/Ppm7/GCuGndsf53BeWdbEZFGxVg/opgMNn+rqZO/UQXy52J9gJbvJt99c93Xj7
         qPzmazgGvnpTYb2LtbUO22k0RmOrmtKFyeVWtiZlev1tBcbRkzx1IKNL5HYuL87VLbr/
         vT2w==
X-Forwarded-Encrypted: i=1; AJvYcCUZ3fFJPYjIRwJSW48KT64ipxqhLlXv4Bsi4aRO8zZglPh5n9hD+UXHtTuIRAnaRejtCpjWRmey0g==@kvack.org
X-Gm-Message-State: AOJu0Yx+nNIhXjHq6Gc7veS67M14s5yWRvH6iFunxgL1p+k+QI2J6ccu
	zmEKgtW8YbgyCUQcRybykBkFLra0PQITl5WCO8h+Kn5ZDw64sg7NZG4/
X-Gm-Gg: ASbGncvLK9MVC3UVs/WCxDEgWtEdulRP8KLcj+Q6vGU0cgMbJeivRv4NXOxPVRSW8uy
	38e2Z96yhY4H/vVSMQwbmKKk2DtWbY+bxjUfzKrEUSRgJExR/tXPY8+KyvLoAww16rzcL2jsgDt
	u/mcowM1rqBDGDdZn6z8Y/zVHwfq6/KdV6opjuFz5swvadn1K3akC1i6dI59K4+PJI2q2WPAs3I
	z0IlLRvrg91VrK/A0EeIrGaYbHaVnWGKxxyLsEwA5mWCL9E23fGzDyUyAxsay7XVrArP2HdxNUI
	2Tewe1KIwwwqRTkeQGCNvLOM2KRpib0n7L2eupIS3H/+3WJpDwx3AM5hnW8PnltSTsfB4Mu6lfZ
	vWXYEWKA7prrHCIIWVJsOuqwNmOHF/jKigQA9ag6oON+bGNIFh0oGMY5FSWSyVUITgQR2IjHf86
	ELaATAqTSCQSIKMkjnqIUC3OnqgW8ZMup4
X-Google-Smtp-Source: AGHT+IHRljw9kbmjLSJU1F5Kw04BLaWKwpQ+xn7u6+wy8m2YVbrYDQAktVvbX2jC5qH3OoDLduOfmg==
X-Received: by 2002:a05:6a21:998e:b0:341:2fea:6b5 with SMTP id adf61e73a8af0-3590998a27cmr5464017637.20.1762975885633;
        Wed, 12 Nov 2025 11:31:25 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc208695cf1sm1014625a12.7.2025.11.12.11.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:31:25 -0800 (PST)
Date: Wed, 12 Nov 2025 11:31:23 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 5/7] x86: Call preallocate_vmalloc_pages() later
Message-ID: <aRTgi5uk1taUB1fe@fedora>
References: <20251020001652.2116669-1-willy@infradead.org>
 <20251020001652.2116669-6-willy@infradead.org>
 <29319ba1-9093-4ec4-b84a-3c60d2b00264@arm.com>
 <aRTTtHQwfOm-loMb@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRTTtHQwfOm-loMb@fedora>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F02064000F
X-Stat-Signature: qk8wgzeap8zreg1rster59p8ktahanqr
X-Rspam-User: 
X-HE-Tag: 1762975886-105975
X-HE-Meta: U2FsdGVkX1+Gs/LypVgnT5NT0nUC3Rfz52tz4YOKdF+W/Jc4pCL6cVrW8y9zIboU2Wvu2NtrhQUBvh2StfXkGpmHlOE/ODZFQPLJwK510hKDBu7aqdR3c/wD5AwjejJ+BDoANlj3q/FzBeA+TNG7FHx6v5H+ibHjpNEBk3nFDIQyq5xgOuAXcHR37ei5GFfQwissRc8cof9kyE+rk6RO5K4kI5GC4ofli87j/JhHLDUor/HVf0p3cvkxagIT/bZF0hv/K31FS0/8lRVaRY7MABro0b5NnuEPks1kvv3RmXR+oguQG75R03oLvyripwRVB+V9YWXGmwrlC8W2z0Pgp4HzqyqR8j+KoCUVY4QSve84oufBCXgJoWdjg9pXivsNq38Oc758KDBpfR/PEUxRcgq6msmdrkLHH0jSDsmTDc1JqsYO0Pidjw6qd580OAXMWz7L261kD73nDQVFXtBaEmQW7GmuE0fLkbez5PeGi+E12Ms8EAmhrW5Mq7/+TKGjUKlVDSPHWTy5syeKbyCDRVj19TvVXtwoMVRejlkpswrN4E11t02CWoTnP/eVFy+m0dkhPISbV0uDSBQUP8dHiR0jlO2MX3zjeWq+iGScXodYv7EXen+xxJL5OgDjj2FCCcmkqlEUFEM0TBuViuiz6LI57IioYkKu7JHS9fC1/mLBgSF63aAJ9bxHePo76xLNBBZYrXC6XSz/Ha5OKHPJEVIum9cHnO14t9Tf6lgtK/LAH0FKT4FIbuj/L/lQaAIxvznSB502052+Dzx+hYk249KMVi6FO1ZSZQz9bCox2uZS/pVOjzsUlven2Xmysj46SXG5Tzw2kbuZht7nedW1DFTQdVvxe/F8SKxkojKa527Afx0liVdD6Vip6CXph3lHgaWkzDygMbVWwiAvNmVBgeDscY068EH+7NIEyelVeuC+C9YkYJy2Dfa0MXxutntVrtd+ui/QikbrTewztgZ
 8gJyTLRa
 w4JCfpZCOErtVZTxP1VWdTB3TPJqWeLkTyx7MiUSoF9b4sBffLGmAHZ2YXGFSrasEagQnfnPuMpt/21/oqFwlT/IcYa/u6m/nvVMuDkbf0C8zIL5+4DXI/PHDA4NI6wNUp7eSivoGSwjP8Dt3qRM5pE/2Vr9foxWvFKs8hCxTO/lr/Yl75OsS3E8Zmh669ZrPtS3Io90sWmxqyzcpMnv+5GLYIfR7HvpwxiI1BI69LZm4EprspIj8k87HlSX8aFZV7w50Tg4Dq7u2Q/ExhQJ20JnMZPKiDcbPCayhK6/yaqQyXyUfrUG138W7AXllqPqSRZHkoIk1QEy4kNuX2f9PVcZZsljXLowoA3BCRtmUCVmemq1idbOcEDZKIsGOX9k5Yfax8mxZRTpJN1Y6brYX2rnjjO++YCqHdrPVt/N4DYgbLi+f14/OpmzgEH1FHjj09C1gMo+Lb4JNbkQIqXe5DCQBilN/dCwPX2XbHPt6GwBDQ+CxYCi1QqpOyDGzAecJT5nS7odSiflTsEmUp7WcJRKeaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 10:36:36AM -0800, Vishal Moola (Oracle) wrote:
> On Tue, Nov 11, 2025 at 02:29:44PM +0530, Anshuman Khandual wrote:
> > On 20/10/25 5:46 AM, Matthew Wilcox (Oracle) wrote:
> > > When separately allocating ptdesc from struct page, calling
> > > preallocate_vmalloc_pages() from mem_init() is too early as the slab
> > > allocator hasn't been set up yet.  Move preallocate_vmalloc_pages() to
> > > vmalloc_init() which is called after the slab allocator has been set up.
> > > 
> > > Honestly, this patch is a bit bobbins and I'm sure it'll be reworked
> > > before it goes upstream.
> > > 
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > ---
> > >  arch/x86/mm/init_64.c |  4 +---
> > >  include/linux/mm.h    | 33 +++++++++++++++++++++++++++++++--
> > >  mm/vmalloc.c          |  2 ++
> > >  3 files changed, 34 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > > index 0e4270e20fad..5270fc24f6f6 100644
> > > --- a/arch/x86/mm/init_64.c
> > > +++ b/arch/x86/mm/init_64.c
> > > @@ -1322,7 +1322,7 @@ static void __init register_page_bootmem_info(void)
> > >   * Only the level which needs to be synchronized between all page-tables is
> > >   * allocated because the synchronization can be expensive.
> > >   */
> > > -static void __init preallocate_vmalloc_pages(void)
> > > +void __init preallocate_vmalloc_pages(void)
> > >  {
> > >  	unsigned long addr;
> > >  	const char *lvl;
> > > @@ -1390,8 +1390,6 @@ void __init mem_init(void)
> > >  	/* Register memory areas for /proc/kcore */
> > >  	if (get_gate_vma(&init_mm))
> > >  		kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR, PAGE_SIZE, KCORE_USER);
> > > -
> > > -	preallocate_vmalloc_pages();
> > >  }
> > >  
> > >  int kernel_set_to_readonly;
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index edcb7d75542f..e60b181da3df 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -1160,6 +1160,12 @@ static inline int is_vmalloc_or_module_addr(const void *x)
> > >  }
> > >  #endif
> > >  
> > > +#ifdef CONFIG_X86
> > > +void __init preallocate_vmalloc_pages(void);
> > > +#else
> > > +static inline void preallocate_vmalloc_pages(void) { }
> > > +#endif
> > > +
> > >  /*
> > >   * How many times the entire folio is mapped as a single unit (eg by a
> > >   * PMD or PUD entry).  This is probably not what you want, except for
> > > @@ -2939,9 +2945,32 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
> > >  }
> > >  #endif /* CONFIG_MMU */
> > >  
> > > +static inline struct page *ptdesc_page(const struct ptdesc *pt)
> > > +{
> > > +	return pt->pt_page;
> > > +}
> > 
> > pt_page has not been added as an element into ptdesc and hence
> > the build fails upto this patch.
> 
> Which commit are you basing this on? It builds and boots fine for me on
> 6.18-rc5. The commits don't apply to mm-new anymore but that sounds
> different...

Ah nevermind, I see what your saying. This and patch 6 don't compile.

> > > +
> > > +static inline struct ptdesc *page_ptdesc(const struct page *page)
> > > +{
> > > +	memdesc_t memdesc = READ_ONCE(page->memdesc);
> > > +
> > > +	if (memdesc_type(memdesc) != MEMDESC_TYPE_PAGE_TABLE) {
> > > +		printk(KERN_EMERG "memdesc %lx index %lx\n", memdesc.v, page->__folio_index);
> > > +		VM_BUG_ON_PAGE(1, page);
> > > +		return NULL;
> > > +	}
> > > +	return (void *)(memdesc.v - MEMDESC_TYPE_PAGE_TABLE);
> > > +}
> > 
> > Ditto - these elements have not been introduced. 

