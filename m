Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93387CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C478E01C5; Thu, 30 Oct 2025 08:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC948E007D; Thu, 30 Oct 2025 08:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB988E01C5; Thu, 30 Oct 2025 08:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB0578E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:31:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E848450449
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:31:12 +0000 (UTC)
X-FDA: 84054715584.12.8AAA51E
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 002BC80003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:31:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JNzMQw3x;
	spf=pass (imf02.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761827471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUnnnzKNF6jolr4B3pNsI3K3/iZV7NjjIbRTrmi3YPg=;
	b=kyuETpARzjxUuMkELn5LG//mDvwjo7n7UNJEL8DNb/oH7sQuVbFN+lmotL7jhHQvkN2Rxm
	7csK8l/bwktiSTLSeMxv0tPZd5fm0+WEk9Nn2GryQRx3sqZYbb/HbpOXmc9LNeQUEf3KY7
	OEfUV9YrPmXePp7DLHRtggzeyYP6OO0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JNzMQw3x;
	spf=pass (imf02.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761827471; a=rsa-sha256;
	cv=none;
	b=xpQsvm36RxTGzpvITh6nseymO8SbCZEMvwnIpXKTppRppM1lLhYsSGsJT5EzUijKKry0rK
	0Q0TFrK+nc7xyZCgZy0X+85IAyMnFgbnJbuw6uRR0p+KzY6izbLSUNKqCFihFVETFTffXv
	YXrjHX1useyqNfGFYMKqRCJfZC8xQa4=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33be037cf73so1156487a91.2
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761827470; x=1762432270; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QUnnnzKNF6jolr4B3pNsI3K3/iZV7NjjIbRTrmi3YPg=;
        b=JNzMQw3x387a210zNyipI5Gif7Wox9OkRBkXU3omZT8XRbC+O+EwPGs8oLHL6fCqnw
         C0xIfncRZ3wVz9qc8dkl0SSlB0ec/XHKZez4VeiDIgp1rDs110RtMMQ2Kz3WUwPG1uR8
         fSzCn6nKb5bt+VDJhdpBNs8BxUmc7MdauE8Md3TFsL8KL94Y8FU59NBN6gXusaq031f0
         whwi5EEISiZjZNJihqkkl+FWsjoxy+yiOFhbHkjhdN8JgMheJhOq58m6eUGIhrE8G3rq
         IbGBS5R4ScL5Ga5UlQhe7MJQWb02tXjiL6iEyXvtgNzHKEfY/RQOYdQgBNa1SrzCIlSW
         5EdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761827470; x=1762432270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QUnnnzKNF6jolr4B3pNsI3K3/iZV7NjjIbRTrmi3YPg=;
        b=VIqFEEkQKYYcKKMpha3CLkS5Z4XSw3KAvkwmsLTzl8LOTG8uBL2yDMtE7MXoMmCykh
         LWtE4+yGWA3YsDfaoJ2M9hF6puo1AaB3/bUnStG5R5AG4vI9PeiIguTQhC3KeXXNe6Uk
         LuSmMfVS/7KH7digBDzntG7GUZWVPSDM81+Ymgjozblx+KxUTDzREybwIV9XmFk0773I
         qH9KuFsOWvEbcZ1mcIjOvajiG44krXB75ePoHmqzTJ/R2jAHb8e/w2I9O7ZrM9o1bY2x
         WY1Ss2tKjiTOr9y1av0eb8pErq5OfuDrb5Tsgw4k5z+D46cW5Z/cu1dv6dVsr5Vv19dj
         rH7g==
X-Forwarded-Encrypted: i=1; AJvYcCVk+ZsBk47Yy7DOLo5Y/f9kfeBlPo3DNq2mzClH5NM2YbWdO9cFIQxA/EofjFqIL4Ww5Lf9W5+A5w==@kvack.org
X-Gm-Message-State: AOJu0Yy0Gwq34YnEj+JAXD9UjOq3YlKjaFKxqwRRKmhBu+g5yMFXVjNh
	DfgOx3xneWsI7grpgtD2UAi3CYFlShiuGPHIPQ2zONBd9pymqNNTdGfl
X-Gm-Gg: ASbGnctCQhy0GrjZq9vnsE6xP9nZCpNrgxZceVSv3ofEDt5u2N4QUszjrdraxdrAodW
	i396XUBw3BYq1pTXd9KQHlesd5zSiJWAfyLPt4JGZAjP4rIPC0XV6wZ4UNiJ89iAvd6un7AmdNE
	Xdg2DS1cLPZR9pUkXe/V4LDn9j+HhudL7BUqe/k7elF4IwTcIa3sqsv883lR1d76W4fEcxMVVvl
	5rUhr4OHtFCeoJHqZrxr5HwG4gJzmmaL5NOqs74e1qq9yf6CINTQJDrRhg8FEudyDsvVOqowbMh
	UYMaa4zK7kpxhLcQ1RFe7KGB1+f2Z3bBJC0islx3Riah+A4kXkibgjUy8TQ1nhAlpuEQkmrf155
	luX5EFGUHLqIXZUGLhmzphDQ3XUhMTM1apJz3bIRgyr6tXH+piegoEfwx1WCMb0N+QyioPp5FRQ
	Uh9OV0dDHQ8z1MvanejkdACXkhGzbK8sZy25zMFbPwocc=
X-Google-Smtp-Source: AGHT+IFA6icduLZxkWAsDzHrUB6N/1XP3GWDghxWUFnVHotHexY3CKUXxycdYpJBjS+mrF9P+AZFpg==
X-Received: by 2002:a17:90b:380e:b0:330:6d2f:1b5d with SMTP id 98e67ed59e1d1-3403a2f123emr7979152a91.26.1761827469626;
        Thu, 30 Oct 2025 05:31:09 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2 ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-340509c89a9sm2510392a91.9.2025.10.30.05.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 05:31:09 -0700 (PDT)
Date: Thu, 30 Oct 2025 09:29:19 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ksm: perform a range-walk in break_ksm
Message-ID: <lv2c4z5utzr37moyish53pmazcnyprhp7ncnrp3hwxyh2fxcvh@466zyeltaisr>
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
 <20251028131945.26445-3-pedrodemargomes@gmail.com>
 <85604399-40a8-4d13-809d-e5492e74a988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85604399-40a8-4d13-809d-e5492e74a988@redhat.com>
X-Stat-Signature: kwa869uy118figqperzh9j3a4idmssu3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 002BC80003
X-HE-Tag: 1761827470-381055
X-HE-Meta: U2FsdGVkX19yQSdWBOdQtWdNyFkaFHN4BAkY9uVZ1TawdcRIvY5tqXA3pg3eQDLt4q6s2KpPz+Kvi4fLmUNgbDVprrRE3+tiCOpxTIw0ifiLpl8RVhGmhmTgLtS8VwuZXFyyYIB3FUSY81M94Udpi6xw6/6wUR/zOsqzMjbFvoGtZpU4AgDRdqK9rcCHlPsc7PgKokt/8qYNFxJrlDltrQgDYWtGxTC75Y5k+H/gzYEGVraIzW3IM7aDpLQv59JPHucWRQstj34zkXErpI7Z8RTL/AoRSGOzvibRkM6paomMuyZ6T2dOrCWKlU1dkF9L5vVRpNUD1OtU61VKj+VJWFf9Pz7scMhl8OLi+BouFjNbATvx907nCbTUSWPjcuQfo7lX8PtOY+zBG7dnwidt4mRU04yOqsBw+iDL696HxHBIIB3blT95pWpPu/2NfVCSx6EcadTh2WTfLyV1z/T0K0nFZPjwe6R+Fu/sCIhnZUre3caBy4ElkEGJMGb1J9VDYeDoPlnrf4YZFcLFv3HOsvZ5lQ9Jq5B8WTV+UFc9ir2W83bK0j4eXMifaM7O71XT6pCQfh+s/iW4bU1IOgKEfgXC7zWc098W++voenP7RUuI6kkdHcdeikKJhjGWl+6UQBspkolh+tvz5lTobdNKSnttBjhoIepAHLZPHaAotBmgrcSKnWohxFEjoBhDPiCfup1jv03fxoCRG+rD3B8u4cKOS++OVbju7vT5B81NvAucQrwts8Ds/rfv0KmIx4HD6wwkZtyblFt8wJjgATAceScFF4nSldeA7WtLYljJEZTSNM6nVHLq3//IOxdPr3mdKwuCnUJ6yvLqpzfhtVajK/wqNRNJ6wHVf1cS5VMbWq5+3R0UdwoLPbFSVu2U0iNBcs2xktIEUm1VpSMRjbsaz+cpTFZPIJxPhLVD78kJJKmOIVEQxLOTAS24mK4RdeEKAbQtLye4r+YvHfSLu4h
 cNz88dt9
 GuVTjANk6g664Mnsa6/g2wWY5Zrny5jTcsBI2aIT2w3KjRys9WxMSciB5GBctVetx+E0KYiDs+U5SdXwjrkcmCqsACGji5tC3XJXAkmTtaJ4cgc6qFWgLWSeIC8HE75q4ZuLx8X0UjgEMvjknoNgxH6zCQ9HUeu9F9NJ2F6VT6junEi8biKx02r9h7S6/OZV8YSPbZpdyeYxcdudWwfFXzPv5OFMeGI5x8LJVdims22kLNdkK0HdK5mO/B7jPAzNPXtSK5FqXxIw5JxIdAexs8i9n4Gz0WvZIxbhej3DAESg2al0IJZFSRhxLQJh4BRCPqHRbiGeRkbEX3oaa29qVS4kAtz2ebk0Un9wTVTDddwDDjavKyeKfKxTbUcMFevo63LNF/a3l7FWxJhWv1eBhNvW6zjInZ7z2T4LRalfpSxBxV4I3luWXisfrkO2DBoYXL89Mkpti5vONUBVWmd4UbU9Xrn/PDCk+H/7XL94G8yONgxf5qwbiRF3RhfeTdAsUlJgiZHcpxGuYbLU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 03:45:14PM +0100, David Hildenbrand wrote:
> On 28.10.25 14:19, Pedro Demarchi Gomes wrote:
> > Make break_ksm() receive an address range and change
> > break_ksm_pmd_entry() to perform a range-walk and return the address of
> > the first ksm page found.
> > 
> > This change allows break_ksm() to skip unmapped regions instead of
> > iterating every page address. When unmerging large sparse VMAs, this
> > significantly reduces runtime, as confirmed by benchmark test (see
> > cover letter).
> 
> Instead of referencing the cover letter, directly include the data here.
> 

Ok

> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> > ---
> >   mm/ksm.c | 88 +++++++++++++++++++++++++++++++-------------------------
> >   1 file changed, 49 insertions(+), 39 deletions(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 2a9a7fd4c777..1d1ef0554c7c 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -607,34 +607,54 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
> >   	return atomic_read(&mm->mm_users) == 0;
> >   }
> > -static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> > +struct break_ksm_arg {
> > +	unsigned long addr;
> > +};
> 
> You can avoid that by simply passing a pointer to addr.
> 
> > +
> > +static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
> >   			struct mm_walk *walk)
> >   {
> > -	struct page *page = NULL;
> > +	struct page *page;
> >   	spinlock_t *ptl;
> > -	pte_t *pte;
> > -	pte_t ptent;
> > -	int ret;
> > +	pte_t *start_ptep = NULL, *ptep, pte;
> 
> Is there a need to initialize start_ptep?
> 

No, I will fix that.

> > +	int ret = 0;
> > +	struct mm_struct *mm = walk->mm;
> > +	struct break_ksm_arg *private = (struct break_ksm_arg *) walk->private;
> 
> Prefer reverse xmas tree:
> 
> struct break_ksm_arg *private = (struct break_ksm_arg *) walk->private;
> struct mm_struct *mm = walk->mm;
> ...
> 
> With the break_ksm_arg simplification you'd had
> 
> unsigned long *found_addr = (unsigned long *)walk->private;
> 
> 

Ok

> > -	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> > -	if (!pte)
> > +	if (ksm_test_exit(walk->mm))
> >   		return 0;
> > -	ptent = ptep_get(pte);
> > -	if (pte_present(ptent)) {
> > -		page = vm_normal_page(walk->vma, addr, ptent);
> > -	} else if (!pte_none(ptent)) {
> > -		swp_entry_t entry = pte_to_swp_entry(ptent);
> > -		/*
> > -		 * As KSM pages remain KSM pages until freed, no need to wait
> > -		 * here for migration to end.
> > -		 */
> > -		if (is_migration_entry(entry))
> > -			page = pfn_swap_entry_to_page(entry);
> > +	if (signal_pending(current))
> > +		return -ERESTARTSYS;
> 
> I assume that's not a problem for the other callsites that wouldn't check
> this before.
> 

Correct.

> > +
> > +	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> > +	if (!start_ptep)
> > +		return 0;
> > +
> > +	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
> 
> Best to declare pte and folio (see last mail) here in the loop:
> 
> 	pte_t pte = ptep_get(ptep);
> 	struct folio *folio = NULL;
> 

Ok.

> > +		pte = ptep_get(ptep);
> > +		page = NULL;
> > +		if (pte_present(pte)) {
> > +			page = vm_normal_page(walk->vma, addr, pte);
> > +		} else if (!pte_none(pte)) {
> > +			swp_entry_t entry = pte_to_swp_entry(pte);
> > +
> > +			/*
> > +			 * As KSM pages remain KSM pages until freed, no need to wait
> > +			 * here for migration to end.
> > +			 */
> > +			if (is_migration_entry(entry))
> > +				page = pfn_swap_entry_to_page(entry);
> > +		}
> > +		/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> > +		ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(pte);
> > +		if (ret) {
> > +			private->addr = addr;
> > +			goto out_unlock;
> > +		}
> 
> I suggest you call "ret" "found" instead.
> 

Ok.

> >   	}
> > -	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
> > -	ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(ptent);
> > -	pte_unmap_unlock(pte, ptl);
> > +out_unlock:
> > +	pte_unmap_unlock(ptep, ptl);
> >   	return ret;
> >   }
> > @@ -661,9 +681,11 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
> >    * of the process that owns 'vma'.  We also do not want to enforce
> >    * protection keys here anyway.
> >    */
> > -static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
> > +static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
> > +		unsigned long end, bool lock_vma)
> >   {
> >   	vm_fault_t ret = 0;
> > +	struct break_ksm_arg break_ksm_arg;
> >   	const struct mm_walk_ops *ops = lock_vma ?
> >   				&break_ksm_lock_vma_ops : &break_ksm_ops;
> > @@ -671,11 +693,10 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_v
> >   		int ksm_page;
> >   		cond_resched();
> > -		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
> > -		if (WARN_ON_ONCE(ksm_page < 0))
> > +		ksm_page = walk_page_range_vma(vma, addr, end, ops, &break_ksm_arg);
> > +		if (ksm_page <= 0)
> >   			return ksm_page;
> > -		if (!ksm_page)
> > -			return 0;
> > +		addr = break_ksm_arg.addr;
> >   		ret = handle_mm_fault(vma, addr,
> >   				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
> >   				      NULL);
> > @@ -761,7 +782,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
> >   	mmap_read_lock(mm);
> >   	vma = find_mergeable_vma(mm, addr);
> >   	if (vma)
> > -		break_ksm(vma, addr, false);
> > +		break_ksm(vma, addr, addr + 1, false);
> 
> Better to use addr + PAGE_SIZE
> 

OK.

> -- 
> Cheers
> 
> David / dhildenb
> 
> 

