Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A3ACAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD05F8E002A; Mon, 29 Sep 2025 16:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7C58E0002; Mon, 29 Sep 2025 16:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996B88E002A; Mon, 29 Sep 2025 16:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8754C8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:19:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A1C811A390
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:19:45 +0000 (UTC)
X-FDA: 83943403530.19.CB9F056
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 148664000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:19:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cOIs/uRp";
	spf=pass (imf27.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759177183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8ywJFugGxnr1LmswaQ85vv4q8MLDZAIEAlvTcaswu4=;
	b=z9NbW0ThQHp5iRUxCuFAXi/tewNo6mtu3iUIBCJWqZ5ktiVXBMM/ZjI1aNhW8ZdO6+ATtZ
	Q5pcfUnMhB0+VMRjCXLsWScsblSPXXdQSqpRCCI2ER9pgjdu26D9eDS80RqNT/CiezWouu
	rFMEjKZHrFIssl/PChYewufo+4WeILc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cOIs/uRp";
	spf=pass (imf27.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759177183; a=rsa-sha256;
	cv=none;
	b=FbcK8ys85LwxnNHUtEfbSjSLamoB5HHpFW1ZJLUnZ6n+DzMWYYMGDVM3wPu5M8vaMfMidA
	bBRNY3MsA+idsG5/uA2nK2zhnW9BzD0ePuy//WGQgWRRTClassB5EGh5JlHQE14yPBNLfI
	UqLQpqeZ44gWxyZbmCq7uJxJ1lf5l4s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759177182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8ywJFugGxnr1LmswaQ85vv4q8MLDZAIEAlvTcaswu4=;
	b=cOIs/uRpREpug68CLzeebPV0O8RD3c91WhT1hIxGxgRTS3276Qd8/fO4PnjhMDre0+sfh3
	A+O6STm1Xn1nc+W17pre5VNR+moPzNy7/R2sC6X5tqSnFKeMPf8D9by1MYL/klg5BzGJB2
	shaXpsacYjCWydGaa2z8Uv1flWX8V9o=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-TZdTbbrPOoyOacxGCeJzvg-1; Mon, 29 Sep 2025 16:19:38 -0400
X-MC-Unique: TZdTbbrPOoyOacxGCeJzvg-1
X-Mimecast-MFC-AGG-ID: TZdTbbrPOoyOacxGCeJzvg_1759177178
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7b591a3e6deso828402a34.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759177178; x=1759781978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X8ywJFugGxnr1LmswaQ85vv4q8MLDZAIEAlvTcaswu4=;
        b=fDJ/SKXC4yQ/NU+mEwvoTjrKgs1H2KOmxjaCqyuiNsjR1bvSlRTFk/IhNf7UjQtmmJ
         j2R2MX0cN9ru2vHTNipITZ1uleDSC3BxP6Zi6CXa6knLyGsAiTuZ6fZvOAwIHeCESS5g
         UPJxBFJjuynYN6x7NGMcqRRRuMCEyHA64eBlhh2yoof06t/KmHbrsXKakUJnGS0UGAd+
         eTWGihoOe1E5lmBElt79DY5jX0sGT0tmpMPqkRRpuRvm0vQ6B6ZQiEpHTikD0eurJ1zB
         XIABbaY5/J0fPF1vn/Bj/SpveL1XEt9ONCZjIOoJA9IZ+8/qBtWmGDGe1vd3wiTaUOLt
         /stA==
X-Forwarded-Encrypted: i=1; AJvYcCVW4DVlAuAXWap01YZAQguD34rsQVPvEyxqLi79Ymwv2uI87pN0dhBM43ZBCo/knrhq2Rm/JtiBZA==@kvack.org
X-Gm-Message-State: AOJu0Yyeka5iWLhMX1IYjLPetPmEGp0xBDvSqYVJYz66zpKVHakcB7KR
	hd0m0X4Tzl25WeMPOZn88oI4BVL7PgF4f6vgfO8Dps9z0xh0tN3GAxHiVWYChRN4UwmU3eujVmC
	dlWEcZFMY4REJBCLTiv1phUPaO8Rw0k0Vb9d81UuC6FYsMEuegrRh
X-Gm-Gg: ASbGnctT9YxJWEWlBsXlzbhDLKroFL7lXoT/R/skt+wZtWZPQtwhJJc7X6jbtlrVDRk
	wVCPfnGvzg8tATaIuV6ZKkCDM6+TW+Tv/L8IDSOhqypo72sS+DPRb1Y9rlmdcSaqDi3bEHAA40c
	aecNZJMXkbW8aUSgD3aFeuS2s9kSZt7zzNiQZPRVYI6g0GDixIL+jYKBuhGQwSUgyAnrYscjfn4
	cOMawagd2YLw02msYZ4BayDDw9zR9XPTcqfzcP070cKRhMkLXq/EysoDtENq9fp+CcRSC+DP9kl
	MpasY5bD6j3zEQxg6uQPohHC9Ja4pi7XnFOEZWA5cFM=
X-Received: by 2002:a05:6830:4492:b0:782:169e:f46f with SMTP id 46e09a7af769-7a02bc53852mr4848800a34.0.1759177178071;
        Mon, 29 Sep 2025 13:19:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCdfxCEo9JDyJ4uNvftVSj1cdS1vG2p2nUgTKSU7nTCB1I+48ULTqz0ZC9Fep708GzDwXwMA==
X-Received: by 2002:a05:6830:4492:b0:782:169e:f46f with SMTP id 46e09a7af769-7a02bc53852mr4848785a34.0.1759177177587;
        Mon, 29 Sep 2025 13:19:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7b5b3b3649esm1213289a34.11.2025.09.29.13.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 13:19:35 -0700 (PDT)
Date: Mon, 29 Sep 2025 14:19:33 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, david@redhat.com, farman@linux.ibm.com,
 jgg@nvidia.com, jgg@ziepe.ca, kvm@vger.kernel.org, linux-mm@kvack.org,
 torvalds@linux-foundation.org, willy@infradead.org
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Message-ID: <20250929141933.2c9c78fc.alex.williamson@redhat.com>
In-Reply-To: <20250929032107.7512-1-lizhe.67@bytedance.com>
References: <20250901032532.67154-1-lizhe.67@bytedance.com>
	<20250929032107.7512-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8myB-Mr7XWnwyDNPt_Wb-cOGopQPgH5ibSSJ4SQDEAo_1759177178
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 148664000C
X-Stat-Signature: figsaz6hro9kgig5qs9561eot9d7cdbm
X-HE-Tag: 1759177182-927012
X-HE-Meta: U2FsdGVkX18mwZEtt5LmVDL4X9010viOyuIGruogfNU+5vIks/WyuM/h7LYF6hCMg/QadSnyEcrOu2q6vNAomhE3th4ghm2NAzlp35fif8nq2JhLnd1osjYh46suZey31fV1KQaMCPGkROhBDsBA8lIh6GICudxwWEkwxGbqWHflr1lTL9av9xL4vF4LokaaLWjVKpoNq3hXhY5vgMKFSdgvN2JSG3gw7kz4bpaFRx/iC2tlZMNcAUSQrwLKoxMFbuOjw2eD4rxfcskME6J1J+EYD/n2Vj/+bg5UvuRE353+R3sASMqWyYUyS/VQhqEOJDnb1dyogZSiVfzO5HWgepH0s7uaPVvsUadnZL4sRrYrMgjBpaDB/sjGDM64BVuFQ9XuoJLIkhgu28VZMHo4gBcqPod2Ci1PdiYv+oFWQSYwTuSCm94rW4gb/rUGnuOSlufE+hJtk8/utNmAuGP0MZp+FvTqdKPE7aC+zVaKSeNQuB8LN520VpqF5QFGv3rvL58Tn5nrLEOZTymRE6RZpgRDp9K0805ZPuY77TUhhrJJjcQ4kejxh0WhRb6ck3qJJCZFvgpX/7kq0b4Bfxb6jMoT0LXMYJEImO4q0X14Db9zuA5jS2tX2KQ8zbO7OywsOl8fSNr/ZOvwFV2TQ/95F4ga9Rr4QY/I5w7Yav5fKrXMu1x1EpBNLw6rHlHFLuXu1rjMGqB6xJFAugA3UysBfwcsTZVDJslMOPjH6gRqsZFi3IeW/2ul2DRX7krCk9oxBNIX9AOLGKpzHcRCpILpyR9lR/VMFIQqpHYzF5ZbdB7aGBAxq2+DHQx0uWmQkY6AEETR4nbAH5gL0BZEyeYA8qIEVFFQxFqWXBQK0BWu7CKg1NT9YsvRJ/oDRh4iEqdI2tvBdVyYOarhy4l4e30WCZK1xreTyXw3iW/1Euq6wjN9b6OvMYalPrARhbC192KwhwqugSYFA3kCTjtldaY
 T7tsbZUf
 JF3O/rWW3ZUOtkgRKv8azc5ImA5ZoJGOT4AUkTUw9RefZdGW9OOACVVMfr0e2v/m4/5n4NieMsvwA2ZpwiwpPZgDXwf/UQ8O0Wc9aLsrg1ikoiB4ernTzN1rw//JUSgHxDNbI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Sep 2025 11:21:07 +0800
lizhe.67@bytedance.com wrote:

> On Mon, 1 Sep 2025 11:25:32 +0800, lizhe.67@bytedance.com wrote:
> 
> > On Wed, 27 Aug 2025 12:10:55 -0600, alex.williamson@redhat.com wrote:
> >   
> > > On Thu, 14 Aug 2025 14:47:10 +0800
> > > lizhe.67@bytedance.com wrote:
> > >   
> > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > > 
> > > > Let's add a simple helper for determining the number of contiguous pages
> > > > that represent contiguous PFNs.
> > > > 
> > > > In an ideal world, this helper would be simpler or not even required.
> > > > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > > > without VMEMMAP), the memmap is allocated per memory section, and we might
> > > > run into weird corner cases of false positives when blindly testing for
> > > > contiguous pages only.
> > > > 
> > > > One example of such false positives would be a memory section-sized hole
> > > > that does not have a memmap. The surrounding memory sections might get
> > > > "struct pages" that are contiguous, but the PFNs are actually not.
> > > > 
> > > > This helper will, for example, be useful for determining contiguous PFNs
> > > > in a GUP result, to batch further operations across returned "struct
> > > > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > > > process.
> > > > 
> > > > Implementation based on Linus' suggestions to avoid new usage of
> > > > nth_page() where avoidable.
> > > > 
> > > > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > Co-developed-by: David Hildenbrand <david@redhat.com>
> > > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > > ---
> > > >  include/linux/mm.h        |  7 ++++++-
> > > >  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 41 insertions(+), 1 deletion(-)  
> > > 
> > > 
> > > Does this need any re-evaluation after Willy's series?[1]  Patch 2/
> > > changes page_to_section() to memdesc_section() which takes a new
> > > memdesc_flags_t, ie. page->flags.  The conversion appears trivial, but
> > > mm has many subtleties.
> > > 
> > > Ideally we could also avoid merge-time fixups for linux-next and
> > > mainline.  
> > 
> > Thank you for your reminder.
> > 
> > In my view, if Willy's series is integrated, this patch will need to
> > be revised as follows. Please correct me if I'm wrong.
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ab4d979f4eec..bad0373099ad 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1763,7 +1763,12 @@ static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> >  {
> >  	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> >  }
> > -#endif
> > +#else /* !SECTION_IN_PAGE_FLAGS */
> > +static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> > +{
> > +	return 0;
> > +}
> > +#endif /* SECTION_IN_PAGE_FLAGS */
> >  
> >  /**
> >   * folio_pfn - Return the Page Frame Number of a folio.
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 150302b4a905..bb23496d465b 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -616,4 +616,40 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
> >  	return true;
> >  }
> >  
> > +/**
> > + * num_pages_contiguous() - determine the number of contiguous pages
> > + *			    that represent contiguous PFNs
> > + * @pages: an array of page pointers
> > + * @nr_pages: length of the array, at least 1
> > + *
> > + * Determine the number of contiguous pages that represent contiguous PFNs
> > + * in @pages, starting from the first page.
> > + *
> > + * In some kernel configs contiguous PFNs will not have contiguous struct
> > + * pages. In these configurations num_pages_contiguous() will return a num
> > + * smaller than ideal number. The caller should continue to check for pfn
> > + * contiguity after each call to num_pages_contiguous().
> > + *
> > + * Returns the number of contiguous pages.
> > + */
> > +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> > +{
> > +	struct page *cur_page = pages[0];
> > +	unsigned long section = memdesc_section(cur_page->flags);
> > +	size_t i;
> > +
> > +	for (i = 1; i < nr_pages; i++) {
> > +		if (++cur_page != pages[i])
> > +			break;
> > +		/*
> > +		 * In unproblematic kernel configs, page_to_section() == 0 and
> > +		 * the whole check will get optimized out.
> > +		 */
> > +		if (memdesc_section(cur_page->flags) != section)
> > +			break;
> > +	}
> > +
> > +	return i;
> > +}
> > +
> >  #endif  
> 
> Hi Alex,
> 
> I noticed that Willy's series has been merged into the mm-stable
> branch. Could you please let me know if this vfio optimization
> series is also ready to be merged?

I was hoping for a shared branch here, it doesn't seem like a good idea
to merge mm-stable into my next branch.  My current plan is to send a
pull request without this series.  If there are no objections we
could try for a second pull request once mm-stable is merged that would
include just this series.  Otherwise it would need to wait one more
cycle, which I know would be frustrating for something we tried to
include in the previous merge window.  Thanks,

Alex


