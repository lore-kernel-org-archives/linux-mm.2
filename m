Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF9AC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7718E0022; Mon, 11 Aug 2025 05:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CEDF8E000A; Mon, 11 Aug 2025 05:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5278E0022; Mon, 11 Aug 2025 05:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE8D8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:20:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D023117339
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:20:06 +0000 (UTC)
X-FDA: 83763930012.19.B219900
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 06B521C0007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:20:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cbOULOXI;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754904004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLY040Of3yhdDWokuw+L+nE0pmeX/ImH14JZx346nu0=;
	b=5hFtQNi0+6F+f9XNtjbMdYp7GaeXxqcgA/w67h78RUw4Hu/uYkM34nkZDbqoC3Z4UO1d4l
	5b3MS7d9riodCKBo905geOUVagabk+kVPrjne0ms/QeoLoKYyeDDcHo0JVeLuZNDVIvqdz
	xvz3qvq1L8B4LXr43TEmEKJYDUTwUAY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cbOULOXI;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754904004; a=rsa-sha256;
	cv=none;
	b=zuH0zC03ZkKnmjq+AVX/qSU+N+0XunKnqQAxDEQGae/fnk34ObK2v1n/icJXvBu3/I3W4y
	FtvdaXFBoF50N9WXnQZefW5C8cvCnNpS8DjGRLQzMxK5YSYMJvezXaCtqNaxwIxnDPl/Zu
	6R2/ahMcZAMc3QSpjFmYyTtfCbmm+Us=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55b8a7a505cso4844537e87.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754904002; x=1755508802; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fLY040Of3yhdDWokuw+L+nE0pmeX/ImH14JZx346nu0=;
        b=cbOULOXIK1+BBn5teMx0bWtbgrLFVN+0jaZiv09hanynsXRizFoCn5gz8HoOTjUzs7
         +uHOeDSi6eZAIjfU8PbxtE0qLBZaCPgNWqxFDS9I4O93BiL2b7aiRYvb0Xi9eeDiMYDg
         774hl4/lT/h3rQt3T/Tn7kUWqOzLNAaX4JjAvXr76+8HZzHEeKpQWm0W67FV08Wa4yU2
         /uEuBVsSlxvPKkF+h9FMgKdKdAtJ1MneUmbfnHp0C72sNiZEtJa43NHVJyjJJ6Hn7wMw
         t+wTgOaEgpu0Qhi3x/up9DSrjEVcspfE0wEyl3vu51J9E1FgBaQTZhjSDLFJacr0YggS
         K2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754904002; x=1755508802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fLY040Of3yhdDWokuw+L+nE0pmeX/ImH14JZx346nu0=;
        b=uTYRfDVzD8yd90toBcBGameNzUo5MWjOE3P+l7Ydyr+Pz/H6BZGOQ6cK/dDBkI+qK2
         zyaNevZK4ffhpGU/VHLfm2oKzCA5BGtVGsGFHtGvq7sz11PDnwzREtYXbOplP73dwhOb
         kLG61gB7m9DQoj01MZtinRXAGvJlIsZyOHh21rIglsQkyjqCAwKSbqqlFlDP41WjsGXX
         MHjbR6KXZHmmdY225ZrUzOYIVrIDdhpSRoWcfFXjxEFS9tIJkQznhqnWBcW8h3P6467m
         xbDo1/LM9Q0UjkJ5AIYmtrFh4e/SgCecZZFRwpHcpEnIpdqlWieyvgB3YyOMhFjSydf9
         amhw==
X-Forwarded-Encrypted: i=1; AJvYcCUEdMpO+bTXLvaWkmyIe89qM9hkJMw8tr4JKptGBU6/d7xiU/pQGG97Wg1fgWECa5FZSbugVFq4SQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2dj70TCBXCHtsxni2fXEBuOd1pCBA8CFt+3d0eZRwlzqXMfv3
	BFnL7JSc/24FeujadeL37iIZb3HkPhan5k/cwWE+M+Rg80VRWDoWbKgW
X-Gm-Gg: ASbGncscb/ShJh88hGikjXV2csPfhVQpfpgP5rEIO1J0NfpzuDVHVqM/i+e5jRZtetM
	zdJDkXRYTGiquR127XaAWwFuEbFrHwwl9LSn51VXlefVAmi3enVa5bMc0KoEFl6fTBrpa6aPMzy
	nNeMXRAQ1Md/bFvqUp1Le9Xjw7MpWc8Rvo7vb/YcRUt67weHoTYY83TdUmg/dDn64C0bwzh/Kxm
	1D0GlnpRTzbwZuev/26uoL8JIeU85H9xzUukVIxBmAZy35VenLezus+AK+wV1cJZzwpIAyyKkuV
	TRFPyiunFQQMvP0MHGsnSoWfLCmUFVZT1XA8YOSgmKEFM4mvLHYjUjBis6rkXnXPDR+tQ2BRbmk
	wVMYN9g/R1Sdwd9+9z6ArHGNLxO/iNfg9KLh+ifujtiEgYIHoIQ==
X-Google-Smtp-Source: AGHT+IGpCY6KOvg3QSYUnRILfbfaaXOePg+07gXfRkMy51cNJOdQvFG2SnzuWEcAl0oD7au0pSO4/A==
X-Received: by 2002:a05:6512:10d6:b0:55c:ad2a:aa7c with SMTP id 2adb3069b0e04-55cc0094c9cmr3053586e87.22.1754904001692;
        Mon, 11 Aug 2025 02:20:01 -0700 (PDT)
Received: from pc636 (host-95-203-26-173.mobileonline.telia.com. [95.203.26.173])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cce15c650sm806954e87.103.2025.08.11.02.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 02:20:01 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 11 Aug 2025 11:19:57 +0200
To: Mike Rapoport <rppt@kernel.org>, Harry Yoo <harry.yoo@oracle.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Dennis Zhou <dennis@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@redhat.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Huth <thuth@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Alistair Popple <apopple@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	linux-arch@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 1/3] mm: move page table sync declarations
 to linux/pgtable.h
Message-ID: <aJm1vQ2D1YOhipos@pc636>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-2-harry.yoo@oracle.com>
 <aJmkX3JBhH3F0PEC@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJmkX3JBhH3F0PEC@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 06B521C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: nco96e3iyibwt8axrx976asf3jcsqtdd
X-HE-Tag: 1754904003-873296
X-HE-Meta: U2FsdGVkX19vODG246/m7br6sUFGoiFF9r3ViiEES9MGyNpE93RCEpMpjEm5mmaqSB2PwRT+JSQgbbFNSW6gc6MXuzLibSY9UxajDmdrJoUVPObkikN/AWqYpPZX1LLupeIqqJhAWFphtU5sUQRhERE/dDcZm5SM/hvFc0gGFpRZCZ2A4Rr2mIMaMHGVB8AUAwqzYPEy+rLYgeKY2S/gAm+jY5toiveLTYcWDqeyU52WATwxwfy4LeZM3dI//9eVujDn5EIt27imMDcBn6LYEIXqDQ1vrjJpUMK4iTVZ4sSeyTKw0E8LvVCbYQNHUUrlT7kBGDRGbg7hNWCw4dStLx6rdPRqzjfsMaEpu8QwlDIzVd/Dy7ZR5VqfTXRouXTbF+26d8fFTSDTxqEYqAR8vB+Kt/9AvR/sHzPg7tBrIKKXe94XmF/sSxWe3T6LbBVLi/wYiC4DcLWfA4MLHlgbQ2GHcdEQroQEGpQi+CWlSnY4LI9FTsyVBxtAkfQ9vBMszOkxJdmjSrmEWdrQgUpTONrBw4WyYuXssB+jK7lkyjMYlDcXyOiJB/ns4LJKQhqknTT1/T/2LIo9NZyJymc1GRY5f0rcmU+ZKkXcSq7ShUvqoFvDH9RLEwKf5FayKZE7pVS7jvRnphGIf2ul2H+C5/xrtxenaISffkwzJxtzRQ4uWusM8zoMKGqSSmB5nqzFP4my/ghCPcrrrV4cakzgzkWBknFs49RJ61HNzFB+xSXwj0Fhfnv8NdXTJospVw+YzdOKr/06NTGCDKGDvRtA2LeSTb1WT7ML7icF2wsvaxNBOxw9lgvo9G0PGcPDSJi0rEedAh7MfXgvoNDZBczULLCYO0g2Us65vstKDTb9ChKlBhZzGa9DpXfvY+3IZ+Qe8JAREtxF8e9ZImK4rcDLSyVls/Bgq/8Y1dwKqy6h51ZyxU1HdNnI0ubayCq57wbeMPwTawYHB72FfPZyX37
 wHNwLW/z
 gkdHFXIl2dNUtUswqhg3T4+1a0LRXm6E4t5mEWo3D07oxA1n/K1qz4SXup/As0WAuQuZjGR4mqspH9CC5wkAZCPwoEgsXB0a3DBKlnU1Gk+yhnVULTyATazbfWSODTDwDeCri5C5AHL0FMnpuuisneJWzoot8vTXU+m2m256oYmfDPzTx7lBjxZOihUnXgE+3LrKDsl3QxEp+ihZAjfyRJzgTLe6JHh6JhJYk9DdkYy/uT8ICLAh/2DjgPGrZhh6nP/CPXKY3lhE0m4PvXNkkpJcZdKP2mJC3YPquRT6d/gK74a56yJf8KU67hKqB7ZbxClU8ZCg/hW9SGhP6yTBFPg6UbP1uK7aTjp51FK6iaoaK5K8kp48qCulxpxEfnKAeN0dU4m4XrOwzBSSRT0DwyvkohUO50eGakv7N4sHBaOnEqG3yGGonUCLyJLayg5S08DTbuqu/U9Ykypagowa20+UEqVgIMtFF0T/1G9pfBQ2M23CERz2O2wf2RxV/SrqTb/67NY5apHh/PT1fUgDc3HjW/odsz9W94WCbJyQu5aSepUDpK47CRtpf1ZHDnU3EJy2DDSR/HcubwfVodhzUXnxUfRNKhOaNMF3i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 11:05:51AM +0300, Mike Rapoport wrote:
> On Mon, Aug 11, 2025 at 02:34:18PM +0900, Harry Yoo wrote:
> > Move ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to
> > linux/pgtable.h so that they can be used outside of vmalloc and ioremap.
> > 
> > Cc: <stable@vger.kernel.org>
> > Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  include/linux/pgtable.h | 16 ++++++++++++++++
> >  include/linux/vmalloc.h | 16 ----------------
> >  2 files changed, 16 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index 4c035637eeb7..ba699df6ef69 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -1467,6 +1467,22 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned
> >  }
> >  #endif
> >  
> > +/*
> > + * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
> > + * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
> 
> If ARCH_PAGE_TABLE_SYNC_MASK can be used outside vmalloc(), the comment
> needs an update, maybe
> 
> ... and let the generic code that modifies kernel page tables
> 
> Other than that
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> > + * needs to be called.
> > + */
> > +#ifndef ARCH_PAGE_TABLE_SYNC_MASK
> > +#define ARCH_PAGE_TABLE_SYNC_MASK 0
> > +#endif
> > +
> > +/*
> > + * There is no default implementation for arch_sync_kernel_mappings(). It is
> > + * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
> > + * is 0.
> > + */
> > +void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
> > +
> >  #endif /* CONFIG_MMU */
> >  
> >  /*
> > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > index fdc9aeb74a44..2759dac6be44 100644
> > --- a/include/linux/vmalloc.h
> > +++ b/include/linux/vmalloc.h
> > @@ -219,22 +219,6 @@ extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
> >  int vmap_pages_range(unsigned long addr, unsigned long end, pgprot_t prot,
> >  		     struct page **pages, unsigned int page_shift);
> >  
> > -/*
> > - * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
> > - * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
> > - * needs to be called.
> > - */
> > -#ifndef ARCH_PAGE_TABLE_SYNC_MASK
> > -#define ARCH_PAGE_TABLE_SYNC_MASK 0
> > -#endif
> > -
> > -/*
> > - * There is no default implementation for arch_sync_kernel_mappings(). It is
> > - * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
> > - * is 0.
> > - */
> > -void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
> > -
> >  /*
> >   *	Lowlevel-APIs (not for driver use!)
> >   */
> > -- 
> > 2.43.0
> > 
> 
LGTM,

Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

--
Uladzislau Rezki

