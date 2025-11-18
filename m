Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF6ACE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8321C6B000A; Mon, 17 Nov 2025 21:14:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3136B000C; Mon, 17 Nov 2025 21:14:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1FB6B000D; Mon, 17 Nov 2025 21:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55FB76B000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:14:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18DDF140354
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:14:29 +0000 (UTC)
X-FDA: 84122108658.17.4825FF7
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 30622C000B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:14:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c351uXE2;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763432067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uG2h5hFbc8f+zsWVWelwgYAnnvEshc/EkCba1TrqhH8=;
	b=UpPckrT9jkzh1btqCNI11BY/p0sgdDpfeYpfDPCRbi+cFfuq3fA8mU1wvdgP3I8cf1/cPW
	okHszNF0OyyylY/QIDgDS7mF2acqwpXI39UH1ice3D762rDL+a9JHgMpJIBho9Sf2irLBe
	xjFsVSmrh0Qqk+QadDaFJHKtGEnFd4w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c351uXE2;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763432067; a=rsa-sha256;
	cv=none;
	b=Jm/sODnqigKTL/FF8KMPvoDO0ol0mw1QNPg+KXj39+Q+9dDN9NE4qPz7DStr6ZgdvR/n+Z
	JzXB9r7wcDEkzwvdvXSLFW8+sUcO2zmnPFwcYNW9/eMUO7N4csPAqgCXpKzlTxDBSYtdI+
	R23VY1z9cNzJfvq7/Yim9dQJgE4CW/M=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2984dfae0acso67239605ad.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763432066; x=1764036866; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uG2h5hFbc8f+zsWVWelwgYAnnvEshc/EkCba1TrqhH8=;
        b=c351uXE2mpD5SrTv16x7gP5bsrYYs7NRYzr7xIPbxAfFZopiKHgpJqP9g6DBL7N+jO
         t94edjHi75k8tLMgJXyBwCoVENYx/Jxv23dSEKzyHOBywZZMBuStozgZD0uHjupNy4Hv
         3GiUmS3i0GHHADfgxayjUPCczdXBJUrgA00Nf0ze/mszfzazxgSOg3L2pAdRrEuyiLrP
         e4E50d2ixzXIwJZvT+wLlb7yQHqe1sfoBIU7swAAmtwc0lDOMa8SvvpVNX/V40xIBPTk
         b+Ez81z7/3HXHJXEZ8JeJFSA++1UHcBq2XCJcdimeB9JJ0qSO900uWDmT8qpHkGpOGTg
         8Sxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763432066; x=1764036866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uG2h5hFbc8f+zsWVWelwgYAnnvEshc/EkCba1TrqhH8=;
        b=gM4Y7S4nvVK4NredXTekf8t6OaFgAL2uCD9/7dTBTqcWS3cLrRBZ7bA4wx1VhPIP+9
         QHKSm9P+Fy15qkq/N2Go6ceLVHOUA9Cce0SX/f+7W6WFfcm57cGERoE9hH/xbDIwgzq0
         AxbCXGCXyKsXYzxrZNr6FMOIWATzYD9qfb0Wvri9aq2lFmilJP9/Dyw+HdsX/oOWqb7V
         W9s8t8bMvQaB9H0yCW+Mk/B5kus+DCmeBE4aV/OTpLvXVQm+T7iB5PmzdiLg3dhhtqGe
         LNsZW2ffLG8DYrBWOHtOh80KBLZx+aTlvjifPJ10r7QmZsXpdeU+bC4y3ErAXDy4cHcg
         396w==
X-Forwarded-Encrypted: i=1; AJvYcCXosTFlPFJAmzOmHEfrZXZxV7q4dTU0RlyWLexexMZFTcDBYexWDRN1Ala3COY0JCcG53uj6/aC9w==@kvack.org
X-Gm-Message-State: AOJu0YyoB/2Z9zfb2T4WcC20yxfzbtqGk+F7BxiVnNOGhTTMDQX7g9bD
	KWx/8bRENCxAM23cLRVyuT8hKBFPIW0xGUD7hWW5vLDUHUF3zjQYvD1G
X-Gm-Gg: ASbGncuqGFFyKXftIGbhbk3ZjA3HPTUYv3HrwRaHOeJqY+e1epgi6gU5iQ2WSbFYd0V
	MScyHqM3Lb7np5mjOpHU0NPbWK4H7qnIME6+FqplcepZoBwhd3TgVdywC0g44gyMTgvb1A0kGfy
	rSUQwmrlUOqEJBxXpueGV05V6etgvT90rIJ4siDl+X2z7+Ey6xeQo18kSb/zYSWfcmLnmCHKKv+
	t3tU1u9c68G2PpaOSow6lLtTc4TgiEeBwpOeraljIQVwvxd9AYPfLodqA2ysQTxJ5P1YS15vpzT
	LvGkBAThKWn5VRAEYJJKc9uSGU4UtVNUnpZtjtXsLQ+OjoIpmETTX0FuzGAWZp2lO4j6gBKrD7p
	QeXliRFdt5fZA84wU9M0/WXTCkm+BiaqbZIBVkKjiqQ9VDJ0H5lMThU7yk/0fFmVwpTBC74l4aN
	XTIV5JdgHh5XfgAMcGUbMHF9jiA9L8YBeqa34enEfheqI=
X-Google-Smtp-Source: AGHT+IFPov549n2LzL2CKQOMPes01IHaPnK+Nr8T6G4o/JsbD9vqU64qA4wEzMsT+osaI0OWReXc8g==
X-Received: by 2002:a05:7022:b902:b0:119:e56b:c74f with SMTP id a92af1059eb24-11b411eda26mr4902917c88.20.1763432065736;
        Mon, 17 Nov 2025 18:14:25 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11b0608861asm36771548c88.9.2025.11.17.18.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 18:14:25 -0800 (PST)
Date: Mon, 17 Nov 2025 18:14:22 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 6/8] x86/mm: Use pagetable_free()
Message-ID: <aRvWfv_fc60zUK1d@fedora>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
 <20251022082635.2462433-7-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022082635.2462433-7-baolu.lu@linux.intel.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 30622C000B
X-Stat-Signature: ko5sgb3zmxfrka1uy7kb1e31q7ee43jp
X-Rspam-User: 
X-HE-Tag: 1763432066-786465
X-HE-Meta: U2FsdGVkX185mZEcZQZwnYmB4054kix+P52dZO6anItE7XHttuwDDuMecP1VP7R6UveD2PB0h7rKDSMSglBxoW/Y+7VwfKzmxRB0WW1pL1Wl0Z3gZl6VcclpLCj5kINEUl4GMeh4JCkKawYC6IvOGYZ3wSfHCqzIY+EhQIjXIOcmoT09s9Y4E6Mt2EX3x7y/fMGJaCxhk3X0+SSoMspg5G/meUs+12nly0UiHiSAFX7/Ofhjjk7j5yweF8rw0yl0liyqd4MoNxYvy1AGdFul9XGShSxCp8ZN3PCpJMUwPcUIirEp32t1rIiOmLZlU8q2A4A3H1t+8l6ejpIlJOKH6H6r7O1ir97ZUHub/gXJ4M2nNkw7xGZWwsnPkfR3vxnbmH2AnexmjwJEG4ODnMjRKnBNy5sS1YjLILQREDMBANVbC4ZQs0hPHEUjHm6zsVlp+95F5LKlfQJ1/EvNpdD7kiN1s9+tob+LU53+FdaZzwgdwHMO/rxvGhek3I6fAYiq8adtt5fQ4n+LHUIyjB3h6VPIZB8JAYPHJE+iQMNhb66Nx+cquRzKZXsakxe1S2jVLD1keFW5hBYxA1Q7RbIx1BgadTWmFXGlA7QvqkH+jtHE27yEtRPvpS4ym9kOJErAs66E0FBZejCPWMvvKmqpV0IJm7TO2KtlFGicm6l+QQTpLs7eFiIWxqFCbA4rX9VnF8ZhS8WV8gLKPCubqTMkpgcOmeYrnXWvUkBNYppAyI2Vb5rmQ7JMS5hw3uQKz9sjFOnzrPn4nDLVv6stRE/03kEers1Onw4r84mqoa+xX1EH1Peq2zkY2/fvGPxVROAi4DBbKjG9fdPxhR9mmH42mNmY/AOvyik6zPeqgcW3cGWXRjEIZsgD16fBEWXtce/QOFzF17f+GRKoSx3k8/7QcVlio9Hilod9CkUu+folXYIb01W7dQcG6SHqzDtcrVCVfvE+0alQK7CPzAm4iwR
 ikQgi8d1
 zl8K88vDm49HJ5ah6zRLoqlsDr33yModvUKRxBdb4+nMDBX4a3vHYk/Zhe87wJWq+tEbvjreO8JmyPXIvQYOQXJ1LiVsIDG6IKPKgYu/FaP7gzZfsP8zXVQxRHirgDvR3afaHqCeghsGS1bJikb6spSNhrZpHSsIUK2jLyiAbE3pYmqUT+5EhU+ee3g+VxJi0zdBy987XOPfJfS80WlXkvjWXxVc12M8IQh/8SxHcWWW0/Y52ertn69cN/vJ4PDrKDMiq5rtyIZpifxHBM7fyd/pJlxy5dWwB546UN5+1fAfd6sh8S+a7MwyWwxCfwKjN8be2w1/aNj23R+CRijFvjom7UtixYrupgS5FfkNENnU1HAdDV/7b8FBGwzut4Hxe7YQ95yp8E0WXgKgptmAGK5K6apujSBR8nvruErmZbLBm++fkEQu4dpIqdVfy7LIsCjewMvGgEzacvtWd8Xn1p0IU5qU9DaG6GLR7Wb4J1KSWOwP6JpU1+lv1RudARsZx1Wb06hr/0FsGJaCzeC0eJTwixKvTVzNC5DAEcIieJOjcWThntWg36t7/H5yUi4GkUYqzUIGeVRVQ3c45PptbuBJl0cHpnXi1sp+p3WaGywFMxVfhxJx8/nPhPo/W5TYP5ZQf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 04:26:32PM +0800, Lu Baolu wrote:
> The kernel's memory management subsystem provides a dedicated interface,
> pagetable_free(), for freeing page table pages. Updates two call sites to
> use pagetable_free() instead of the lower-level __free_page() or
> free_pages(). This improves code consistency and clarity, and ensures the
> correct freeing mechanism is used.

In doing these ptdesc calls here, we're running into issues with the
concurrent work around ptdescs: Allocating frozen page tables[1] and
separately allocating ptdesc[2].

What we're seeing is attempts to cast a page that has still been
allocated by the regular page allocator to a ptdesc - which won't work
anymore.

My hunch is we want alot of the code in pat/set_memory.c to be using ptdescs
aka page table descriptors. At least all the allocations/frees for now.
Does that seem right? I'm not really familiar with this code though...

[1] https://lore.kernel.org/linux-mm/202511172257.ffd96dab-lkp@intel.com/T/#mf68f9c13f4b188eac08ae261c0172afe81a75827
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/T/#md72f66473e017d6f3ce277405ad115e71898f418

> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/x86/mm/init_64.c        | 2 +-
>  arch/x86/mm/pat/set_memory.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 0e4270e20fad..3d9a5e4ccaa4 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
>  		free_reserved_pages(page, nr_pages);
>  #endif
>  	} else {
> -		__free_pages(page, order);
> +		pagetable_free(page_ptdesc(page));
>  	}
>  }
>  
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 970981893c9b..fffb6ef1997d 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -429,7 +429,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
>  
>  	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
>  		list_del(&ptdesc->pt_list);
> -		__free_page(ptdesc_page(ptdesc));
> +		pagetable_free(ptdesc);
>  	}
>  }
>  
> -- 
> 2.43.0
> 

