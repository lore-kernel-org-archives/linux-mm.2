Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F866FF512F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 00:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC85A6B0088; Tue,  7 Apr 2026 20:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EE26B0089; Tue,  7 Apr 2026 20:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC776B008A; Tue,  7 Apr 2026 20:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B10C36B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:35:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5359E8C8F6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:35:24 +0000 (UTC)
X-FDA: 84633519768.11.201C15B
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9468780002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:35:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OSkWP4eR;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775608522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55E878MxgP72O9eei0qCPXOsBTcpsSSj+qhDc+Y73Ic=;
	b=lR/3V8hhliZglmNmsG7THSriItTKONJ2n8+5OQweZlK/ae+YVhUm9o3K/LeaYgG92hVUX+
	u09ZDwgg2ujY/UbI0wyPILU0tdIjJ2sIiov8D0iSghQlvWNaJtDShBJqhVr6MBlxYw3LFX
	fnOlb2D9VC5vX6XJA0x9tJSiKtzzLYE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OSkWP4eR;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775608522; a=rsa-sha256;
	cv=none;
	b=YwOkCqwEUreBnWmwfoVzFSk119qDEc2/MS4dJ0F2oIOUORBATSRtrx3xxfOaNH01aCv2V5
	Dpbtg35VDGRKjx2Sq1U7nQTCl2EgqbEoyHVrvo9FIHfqYcQuyl56rmBHFS1d8iklfU08KM
	cE6T3cRz/wW0X7uEHSD3cPaIVMJj1AI=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64f48a5c3d8so5896099d50.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 17:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775608522; x=1776213322; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=55E878MxgP72O9eei0qCPXOsBTcpsSSj+qhDc+Y73Ic=;
        b=OSkWP4eRPTJSTdi5WNJpmJVg0SppckdHWH1BWgDyiXgQpL24dBVqk8+7dKWzAI/lFg
         ba1ias8VPixSGyBeK8wky2idZ/ZDCJzqeSyRvUVzFOgMc/LqvYNo8exj/lU7e7vbkeJo
         BIrFMH5nTmChuosW3ppxfW8RMonRUEVWjeZ+Bu2tBg7sRgikmCbwbjxvi5TXPZk29+Go
         7yrSABvOBKz3+7ApPwAM4FCtpCVeCzugRiELV5RxV7r8fp5N9kDWmYnOo55/UugY9rIs
         XYq4/X+6lh2hya22VRzmLjv0imkPZjn8cM1RA/Ubl1l3omx7U9kb9b7J8zOI+H44UTuD
         Ex9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775608522; x=1776213322;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55E878MxgP72O9eei0qCPXOsBTcpsSSj+qhDc+Y73Ic=;
        b=oq3OwmJM1uNVBzFMUpoIabls2mEgwSmHvfr79sY5MuDvWenlG8VZfTia8ksKWV3lKe
         yrFrIpUyA0dz6Bbw2uo4SaXmvxYyuTRouliMd06H2hmZeuRyPMFxNqQCrlmvxDVbmxu6
         +jQsogVn/81v4Koqs1hJVMtMfdNsDJw5DoIoxQWttuAmcm0sLByvI9GENIPplemdtQu+
         kavhXhBRrXEAOY+kbGlZnVfv+bGHGQ+XiZuAMWJv8m4RmK5TVMGp3vuSH2JsU4v5SnPT
         0wRfYlu52mmOPItlGG//PAPBH43/cAQWNM/UGU9Gh1wMKNgGTCcsg76XCMAmzLT6ezjK
         1Jew==
X-Forwarded-Encrypted: i=1; AJvYcCXheTbcUh29V86X4wAuQXT4hwP1ZKr1M8Cn4/97Fd0nGNBZHYN/JJ9fQ/AyEE+qe9KakGqGmeu6Qg==@kvack.org
X-Gm-Message-State: AOJu0YyHl5ubQZ8p7V27zzxNu2F//VubNKi8QIQr8J3BtpksLv/CgauT
	h4XG05CzDm2F97nx8Plo/HIji7pwD7MsgAZoz3yL0d0vVuxndnD+qMwhrVNp5f0PHA==
X-Gm-Gg: AeBDies+ne1TsHZSB9fzID0zhY1glmZsL78G6/9zLZeNJIBpamZrUVhRZmVhRyQUEsi
	Tup8IhhRTPkHZujBk6YyHb6iVV4rXwrRLBMoBCheAT2LYOit+XXwP1in5oZaWTnnFAqnXmt58BD
	eH6uQHNidaRI0oqxDR6e6iLSemKhJnyvURRCOAW1vxNt/JD6pRQmZBHe6dpQjOPqioAQZEmBnGt
	Tb1AuyRjwXSxFynNXbFQVzEz7hFYmF6RWzQWlE6GKgZsOlU0kmBmhN/K3ebNuDwT7vZtC4nC1Z2
	2FOvqf0vk6qQWsn5hCvwdqqp5pX9B7UprGGG13c4318kPtOK3IzFaoNSD3DqBapg3qmxM1GoSwA
	S0uH2AtO9WSz/UOi1jRXN0EHwMi7VRu1EHd96fPRkDxSbpwCjvjOvuCM6ypaZZGOC6Psc2gNibm
	2qwT3z/z0pj/be2S1i0vqIG78Zehj/NK9adUuQcwd8W/P7p59X6p/+WNc6iUjYwBp/BRBvWr4Wd
	rr7X//ovNE=
X-Received: by 2002:a05:690e:418c:b0:650:72b8:e7b6 with SMTP id 956f58d0204a3-65072b8e8b1mr7721195d50.0.1775608521304;
        Tue, 07 Apr 2026 17:35:21 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6503a9a9271sm8607789d50.15.2026.04.07.17.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 17:35:20 -0700 (PDT)
Date: Tue, 7 Apr 2026 17:35:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: John Hubbard <jhubbard@nvidia.com>
cc: Joseph Salisbury <joseph.salisbury@oracle.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
    Kairui Song <kasong@tencent.com>, Hugh Dickins <hughd@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, 
    Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
    Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
    linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock contention
 in populate/unmap paths
In-Reply-To: <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
Message-ID: <982e5964-5ea6-eaf7-a11a-0692f14a6943@google.com>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com> <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 9468780002
X-Stat-Signature: sbc8q6z6y84n3d7umwphoj54xum36es3
X-Rspamd-Server: rspam06
X-HE-Tag: 1775608522-158274
X-HE-Meta: U2FsdGVkX18cm1+gfZnydtw+iHAqWZ3L2QgEUhSA3vnQMnVatOXBfds1ZNnpSvhWdvaGFyrypLyhi5jfEfQjg7YOcjUqsuy5Bfv1D/Cs4WNjEMsweHWZF3EXL7qiwsIQSFJ57rUZB69FXxTj5jvJkF97wkDT2IBokX7HDSmd8WLG8U9sa7EPdOjnJiRhJ/nHAt5C4jGWnwAw+Xw4+csO8WY0NTpwCkj4HE3SM9xHIFa+Y/Vy89Orbrwt5tICjZ0rFV3zmpiCud++hIu23EKkrd+WeU6ZU2g7mZ3qSKWFajJGO0OTYDbOubueZhnXrdB91lDfo+sBb38DiveFIff/DDiDmY+KnceP5Z3UnLRha93/x/ykgHsudojRK2XqCiiTGFEWWJuW95M3ywk4QfcfsdkoroVjzX1HI8qn1qKNN0uNMMtFpD3+m+S6Zp2l4RVSGZi5mFO/pHUTsmgVIUHNCdk/+YgEcxZYVWnUbqtVofHv33BCAlEO1zurGVklJm0y2VFc+aWdrDQatsoLqMCpvL46YRFiIiCCSQ3K0akjLRADUEhlgxFpktvSePwL7s4Ab+MFWVf4yM3b0er1b1z1q3dCjOAj3rgcZXMXyILnYM5EvUNugs0yerGb01Gx6Sr+ElMuUVA5P/jEW4qauhKZthDZzyfwl736C807igWt3l71lMy919fYVGFmZI9dlXycJd5T7t/3qbYWjcX53biR3Fm3AYcAcqjTKZlbVOlYDtCgmBXvtgfXkPemz6WcVT/fAzIRO5k7GaKyqvLnJ4iA8hoLQ+S77bLck4xCX2kj4u3pFm56og57CbLuAKOtm6VnGN7MRCwSdrB7/4sqF25cayyx2c+YLayYQQdUmt8dCgiPf2/Wcj5VVT+UUMP3VVImayMU7mOG+kF7YFKsNgj5uaWE+NSqZUVvD2HXb7GLHlfbsqqiYUtK2P/A14A5yEXkuWT/Ki0aJwX4dZYPaZv
 LH/WbVe7
 zuo0cauWAlGDERH7DWhATvci3Pk5hPvM7Nnux8DVMGZNUFdVRqdvDe5g2UGDwjdSj0PAlPbLwy7D1ilZvVh3M/spIYW/WIz2CjPp0/nm4ukysDBj2qaMvY9j+iGBgrCyAx/tRtMMOKyGsaEGk3ZhJcHmeBP1RQJ+Sx2lbFt9mkgylBmvG+sxOy1RZHhtJ0T+HjqmiVGiPGQYbPzJZAtBtUovZfkMhv+Wo/g8ft7kOLaYdlsmEWwDHKAbziq2lND7MGMjbdA1h87G5nmiuIgTgS0DvTgbFxVSoCKqav3CgWZx1Yx3DsWNPw4/IXF0I4W5s2cjWtqYR9VkNSRU79Yh9iEyJsHjls6Nj+I1xv9GaMZAjVM6f/sXhx3PRJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Apr 2026, John Hubbard wrote:
> On 4/7/26 1:09 PM, Joseph Salisbury wrote:
> > Hello,
> > 
> > I would like to ask for feedback on an MM performance issue triggered by 
> > stress-ng's mremap stressor:
> > 
> > stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --metrics-brief
> > 
> > This was first investigated as a possible regression from 0ca0c24e3211 
> > ("mm: store zero pages to be swapped out in a bitmap"), but the current 
> > evidence suggests that commit is mostly exposing an older problem for 
> > this workload rather than directly causing it.
> > 
> 
> Can you try this out? (Adding Hugh to Cc.)
> 
> From: John Hubbard <jhubbard@nvidia.com>
> Date: Tue, 7 Apr 2026 15:33:47 -0700
> Subject: [PATCH] mm/gup: skip lru_add_drain() for non-locked populate
> X-NVConfidentiality: public
> Cc: John Hubbard <jhubbard@nvidia.com>
> 
> populate_vma_page_range() calls lru_add_drain() unconditionally after
> __get_user_pages(). With high-frequency single-page MAP_POPULATE/munmap
> cycles at high thread counts, this forces a lruvec->lru_lock acquire
> per page, defeating per-CPU folio_batch batching.
> 
> The drain was added by commit ece369c7e104 ("mm/munlock: add
> lru_add_drain() to fix memcg_stat_test") for VM_LOCKED populate, where
> unevictable page stats must be accurate after faulting. Non-locked VMAs
> have no such requirement. Skip the drain for them.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Thanks for the Cc.  I'm not convinced that we should be making such a
change, just to avoid the stress that an avowed stresstest is showing;
but can let others debate that - and, need it be said, I have no
problem with Joseph trying your patch.

I tend to stand by my comment in that commit, that it's not just for
VM_LOCKED: I believe it's in everyone's interest that a bulk faulting
interface like populate_vma_page_range() or faultin_vma_page_range()
should drain its local pagevecs at the end, to save others sometimes
needing the much more expensive lru_add_drain_all().

But lru_add_drain() and lru_add_drain_all(): there's so much to be
said and agonized over there  They've distressed me for years, and
are a hot topic for us at present.  But I won't be able to contribute
more on that subject, not this week.

Hugh

> ---
>  mm/gup.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 8e7dc2c6ee73..2dd5de1cb5b9 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1816,6 +1816,7 @@ long populate_vma_page_range(struct vm_area_struct *vma,
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long nr_pages = (end - start) / PAGE_SIZE;
>  	int local_locked = 1;
> +	bool need_drain;
>  	int gup_flags;
>  	long ret;
>  
> @@ -1857,9 +1858,19 @@ long populate_vma_page_range(struct vm_area_struct *vma,
>  	 * We made sure addr is within a VMA, so the following will
>  	 * not result in a stack expansion that recurses back here.
>  	 */
> +	/*
> +	 * Read VM_LOCKED before __get_user_pages(), which may drop
> +	 * mmap_lock when FOLL_UNLOCKABLE is set, after which the vma
> +	 * must not be accessed. The read is stable: mmap_lock is held
> +	 * for read here, so mlock() (which needs the write lock)
> +	 * cannot change VM_LOCKED concurrently.
> +	 */
> +	need_drain = vma->vm_flags & VM_LOCKED;
> +
>  	ret = __get_user_pages(mm, start, nr_pages, gup_flags,
>  			       NULL, locked ? locked : &local_locked);
> -	lru_add_drain();
> +	if (need_drain)
> +		lru_add_drain();
>  	return ret;
>  }
>  
> 
> base-commit: 3036cd0d3328220a1858b1ab390be8b562774e8a
> -- 
> 2.53.0
> 
> 
> thanks,
> -- 
> John Hubbard

