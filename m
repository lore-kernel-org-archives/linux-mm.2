Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95401E8784C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8746B0099; Tue,  3 Feb 2026 12:45:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75E16B00B0; Tue,  3 Feb 2026 12:45:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74756B00B5; Tue,  3 Feb 2026 12:45:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEBD96B0099
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:45:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A2541A057B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:45:10 +0000 (UTC)
X-FDA: 84403871580.04.1ED37AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3668EC0004
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:45:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FY9s5nF7;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770140708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlFrmjhVpayg8OBXKv6tROkmIHF/xjSd9Muscu3Dpsk=;
	b=udR8NaKjvgHL/zCtLRWE+Yj3br2atESzYKVyHKdQHXt/g3kcuHOOgDzKGpaPdZC0Yjh7y4
	QubLb1D7XSDz3uw3SVtui7Hb/ptggiUX0MSQ6uwC8yMKN+F0GXfuyHwAcWhiquZRPgQdfs
	gFhMLk7e5CvsaGBc88PTWRY4I7+dH7U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FY9s5nF7;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770140708; a=rsa-sha256;
	cv=none;
	b=FCrilJEpcPqICDDboGD34mvEjvTXcXSIPwUsah26pUzLrITCTUC80TILZpy5FSI+edyXb5
	ZkN/87bIdKiGggHsUtW8sU6YC4TdfaIJZqMh0lozt+IwtOaH9Vm104yqa0fJpPMEWDrjZt
	ExVVq5PzogrYFOqFAEii3TuBMGCygQw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770140707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tlFrmjhVpayg8OBXKv6tROkmIHF/xjSd9Muscu3Dpsk=;
	b=FY9s5nF7qrQQ/SpoSiAXwucg4M13UD90jHocFZj5mswY4pGFRBXGrg1GnAO2GSRLsuyqkJ
	kTtEmHKd8u0aiiN8c/g9KoTNpoz/YQ4rCkLbgVgzFsxNIoG+DnfLZGOdDi3Sz0T00h9S7i
	3IPoeAJKD4e/hqVqsYBMWnBLLiCrhV4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-AA2LEEOKNOCkE3bQteGFzg-1; Tue, 03 Feb 2026 12:45:06 -0500
X-MC-Unique: AA2LEEOKNOCkE3bQteGFzg-1
X-Mimecast-MFC-AGG-ID: AA2LEEOKNOCkE3bQteGFzg_1770140706
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5032e68560dso59848621cf.3
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 09:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770140706; x=1770745506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlFrmjhVpayg8OBXKv6tROkmIHF/xjSd9Muscu3Dpsk=;
        b=NyxFaoIMYzJHB0KWiHO3MuBHlhjtTZ/Oc+tqemO0pNPx1XTkF7hnHijNBYJ+tTrulS
         ed0NRN0Kk9Ha85kLhNOVS+tF4P9/fFNSd/rYG+myrcU0/lRrB4FFIQsjC7hs2sfzlzaS
         UZGDJGFocP6feeXNU4n+8ytuvrE85lwf4ZrRkNufFT/nF+t0kbO/LJwdG3AVwFfEbLrL
         75vqw1y0Nw8brQ4VEy71ZwbydGBJ9qh4BoXQqdd4NtXe7xMi60I4+ZxbEKywCFpN4Ca4
         Pwq0YRRkNAHCrfygtedz6d2cRLFwIV/iWurcJkiIzTeDxAtgdY1Pk4v3a+qw9qI1fGjP
         NvRA==
X-Gm-Message-State: AOJu0YxKCgpQ2ZJ4YAQZmqpYwItVss9F7JEiiC8/TurF3vaVimBCy8kL
	ORqfw5nd/ZL5Tv5OfbnpAzGQUab9H3l45Vh9baRc7rRmVWBp7QvSXdhgJ8onibRLft0BXwSMtmy
	iHWXQYQVjoUf6YVWFw7Ohp/HW+W/6KOg9Od1gs6Z06WRemze7RBA9
X-Gm-Gg: AZuq6aLhCvrXRR6gjdRE8WbisBsvcPCyexULZR0z3FjEtaNVbtazN4OSuFWALX5Rkc1
	r9K2X658OQCkfBMmhIXcI2/vZ3jI0hlrWOhI3VFJNMHJSAOhXPMb/f7Nm1MCKwnml2/vtOZlpE2
	T/MXbUMVtzYXMrPtYWprymClbcz59u3urpTAtIzLo505flcVFJVkXsmWKgsfxlbmp3mFAG/FeRk
	wtyha/aOkvkPg7/c5Btm2QkEydlG+cccpd93oNu4h8SWznyd2g1ONgLnH6mihOk0ewLeZ+QRAzT
	zW1M5TUlsNK1XzSMIVg9rWjRvipk1Phh1PQ7tRt8ooN5rgjgLzbMhHTJ8ojZKguiteX5kDdPu/V
	+fYw=
X-Received: by 2002:a05:622a:1ba3:b0:501:181d:f71e with SMTP id d75a77b69052e-5061c18ec18mr1176611cf.38.1770140705462;
        Tue, 03 Feb 2026 09:45:05 -0800 (PST)
X-Received: by 2002:a05:622a:1ba3:b0:501:181d:f71e with SMTP id d75a77b69052e-5061c18ec18mr1175931cf.38.1770140704851;
        Tue, 03 Feb 2026 09:45:04 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5061c1f7764sm401081cf.23.2026.02.03.09.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 09:45:04 -0800 (PST)
Date: Tue, 3 Feb 2026 12:45:02 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 01/17] userfaultfd: introduce
 mfill_copy_folio_locked() helper
Message-ID: <aYI0HmP-XZNBI-gb@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-2-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260127192936.1250096-2-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rY2JfqdhIBaUJSmazaJ2osniGwBp6j8jRDVkkzC3GsE_1770140706
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3668EC0004
X-Stat-Signature: gus6x63m9wzcq6ot65mq7q9jhxcep463
X-Rspam-User: 
X-HE-Tag: 1770140708-998848
X-HE-Meta: U2FsdGVkX1/3l7K90BML7otv6AAKEAvnFkS3+ETXvdmt8mkrINYfGMHcKHGnWKimmRKnOHLORXnAPQaFvah9mDL4FhvD6oPh78i2Y6CdYR31NV3BIiZQRREuXV3Hqjgozr6kXj0Of6XLNX2KJiGz85QgigAf27fxqdsPQAZtjHZZMuv8FNNOaz79qN0dMKRzkZgFpQQu84FFSDK0uYdCY6USPQFc0yp2NFLCw329CnkcSYBGfSHnZAg+2p1ekGshDvu7jVI7c8/IfTPDgOVUcEtZbL8QXEQMnO6Ji65PuyuSri1LCAEZEsJFVV0LV09NkxJjfuVe2QnHUttT1+/dWrc+8M+CGUMBVh/NVL3xH3H8ORmTXmFkIaOmJ8E/rpiRULLnP0OmdEakwE4Zd5HHeC4jD4Fq+BnlKQeXBcWLs3Gfmz2QUES6S9J2feuL7j9si8aO7+s8wwO3JRi95AZaMSpGbtsktFOZBUcFcxOo8sW07ZamBCxzt4n7V8eN5zPQ4HxiXEVMcgYMaC+b68EJY/RMzZd6HS7hCneXUMfJhNt8uCMo2DVrHTxPkFPNmG1lbgW1+ke0hlFR5fgYw0ZlyB83/2fHMdLrzsQC6FBDeP0qa7q5jwbZFtsise+LZXcXnr4QLRDvH+9jq4+/iDx/I6XPZmWZLA+uZSYPOaX62OgXG0fls7tjzX3JHG3pJPOOnF7WM0extWiej6sIOdoEaOFNjV1W+zIqKpA2Z54G6SpIaFNATd8+MTfHGpIsUDGZjX2KXD5ktk5aTmqEL8o2PtNASbdIjsoanjqjAYvj9MNMiNV0FCIxx+0n0e4bWAGwZzXVY/34d3f8ZS0KvBfZK7ClF57N/wF8Rry/D9A5QLLMoBBB6AOFB33mBNaQXVnJjP4LTUnfz/nmhS20EMFdSiUbHuw9prKo0R/nkgBIo+5lXLs9t9w091QEBZ/02UdhY6y1vDE1Ln3ns41arQ4
 3z99kuBz
 CyVjSRn/QdA4NA/jhz15+iVPpDf9YWOGoVJjq9Q+7ojpM/HZe+qv10nAupfEzVnJ8GadXd+xSALgP0UypaVhyCevbq1yNr6SkRWx4a9kZw6gBB68WvZ3DS6lpu3VzJ+Oe97V22dmYeEO72hK5vJvm2kNDLYpS5LzU4rT8ltYf03JOvJhGJ1YyFjyi1BgZBS37f6PdkYdlC1u5Y724X0BlQAThstV0jALuqGVYJ9Yy7X6jk7zpk14D4OkDGrosSTLvjVVlElJkJN3B3plnyHsC35tGByq54xsiwfOPtcFAENAOOXvzKxxmG/gV9wMA7Oxj9c+z0XFXXsRQ6HMpf3J7VwoP26HRJrsaJzdTPEetmetqtCdjm+qR8xJDoruV3y7uJoc/ric9N7VEGs55WuUsAQHjQqDwDE8q25H4Q73TOJfMR0d+/NabGS9UyaCQVrkEfxlmz1tmLvdWFFV970GBPdzE8Bt0xGh5C+r2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 09:29:20PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Split copying of data when locks held from mfill_atomic_pte_copy() into
> a helper function mfill_copy_folio_locked().
> 
> This makes improves code readability and makes complex
> mfill_atomic_pte_copy() function easier to comprehend.
> 
> No functional change.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

The movement looks all fine,

Acked-by: Peter Xu <peterx@redhat.com>

Just one pure question to ask.

> ---
>  mm/userfaultfd.c | 59 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index e6dfd5f28acd..a0885d543f22 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -238,6 +238,40 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>  	return ret;
>  }
>  
> +static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> +{
> +	void *kaddr;
> +	int ret;
> +
> +	kaddr = kmap_local_folio(folio, 0);
> +	/*
> +	 * The read mmap_lock is held here.  Despite the
> +	 * mmap_lock being read recursive a deadlock is still
> +	 * possible if a writer has taken a lock.  For example:
> +	 *
> +	 * process A thread 1 takes read lock on own mmap_lock
> +	 * process A thread 2 calls mmap, blocks taking write lock
> +	 * process B thread 1 takes page fault, read lock on own mmap lock
> +	 * process B thread 2 calls mmap, blocks taking write lock
> +	 * process A thread 1 blocks taking read lock on process B
> +	 * process B thread 1 blocks taking read lock on process A

While moving, I wonder if we need this complex use case to describe the
deadlock.  Shouldn't this already happen with 1 process only?

  process A thread 1 takes read lock (e.g. reaching here but
                     before copy_from_user)
  process A thread 2 calls mmap, blocks taking write lock
  process A thread 1 goes on copy_from_user(), trigger page fault,
                     then tries to re-take the read lock

IIUC above should already cause deadlock when rwsem prioritize the write
lock here.

> +	 *
> +	 * Disable page faults to prevent potential deadlock
> +	 * and retry the copy outside the mmap_lock.
> +	 */
> +	pagefault_disable();
> +	ret = copy_from_user(kaddr, (const void __user *) src_addr,
> +			     PAGE_SIZE);
> +	pagefault_enable();
> +	kunmap_local(kaddr);
> +
> +	if (ret)
> +		return -EFAULT;
> +
> +	flush_dcache_folio(folio);
> +	return ret;
> +}
> +
>  static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  				 struct vm_area_struct *dst_vma,
>  				 unsigned long dst_addr,
> @@ -245,7 +279,6 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  				 uffd_flags_t flags,
>  				 struct folio **foliop)
>  {
> -	void *kaddr;
>  	int ret;
>  	struct folio *folio;
>  
> @@ -256,27 +289,7 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  		if (!folio)
>  			goto out;
>  
> -		kaddr = kmap_local_folio(folio, 0);
> -		/*
> -		 * The read mmap_lock is held here.  Despite the
> -		 * mmap_lock being read recursive a deadlock is still
> -		 * possible if a writer has taken a lock.  For example:
> -		 *
> -		 * process A thread 1 takes read lock on own mmap_lock
> -		 * process A thread 2 calls mmap, blocks taking write lock
> -		 * process B thread 1 takes page fault, read lock on own mmap lock
> -		 * process B thread 2 calls mmap, blocks taking write lock
> -		 * process A thread 1 blocks taking read lock on process B
> -		 * process B thread 1 blocks taking read lock on process A
> -		 *
> -		 * Disable page faults to prevent potential deadlock
> -		 * and retry the copy outside the mmap_lock.
> -		 */
> -		pagefault_disable();
> -		ret = copy_from_user(kaddr, (const void __user *) src_addr,
> -				     PAGE_SIZE);
> -		pagefault_enable();
> -		kunmap_local(kaddr);
> +		ret = mfill_copy_folio_locked(folio, src_addr);
>  
>  		/* fallback to copy_from_user outside mmap_lock */
>  		if (unlikely(ret)) {
> @@ -285,8 +298,6 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  			/* don't free the page */
>  			goto out;
>  		}
> -
> -		flush_dcache_folio(folio);
>  	} else {
>  		folio = *foliop;
>  		*foliop = NULL;
> -- 
> 2.51.0
> 

-- 
Peter Xu


