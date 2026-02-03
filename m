Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7119EE8B363
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 21:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A406B0005; Tue,  3 Feb 2026 16:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C78F6B0088; Tue,  3 Feb 2026 16:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6576B0089; Tue,  3 Feb 2026 16:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 642116B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:07:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 056B58B5B3
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:07:49 +0000 (UTC)
X-FDA: 84404382258.08.7F0B7AC
Received: from mail-dy1-f196.google.com (mail-dy1-f196.google.com [74.125.82.196])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0C78AA000D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:07:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g0mugnxq;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.196 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770152867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kanz66SrGPI1ONI9MQZAri2Pq2vYCluJgte+kOMKGfQ=;
	b=pyiUJ5SwuaMgLc61g/5UEMdYWwzarUTKq0sHa+K/MKJwjycuzCc8ZqIHZeW61y4PQtEQ4K
	+7JWgWcHV6zRDUSdw6S9Po2F0lHfEi0Wa7YtdtFDW9XKe8nNhXjb0ObDVgLB4qoF9f2D9t
	X+dBELMwlD19poI82YyeUFVjgwSgB6s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g0mugnxq;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.196 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770152867; a=rsa-sha256;
	cv=none;
	b=s2UDJiOWOBe0bCUJEgn7OcxBxv8MxMq4FX1AN51wvfiPUpMond2N+4tm6iHaReP4KNeOUC
	Hb4ZyYjQbmc6SS3AaM5S597pMX0CIuxZ7cVp5LcfxNy4TnB8T68JYrQTniLNtPbOCDo9qd
	Yo1Mn0PDCq2gnNYg+5JRdmR5D5eJvI4=
Received: by mail-dy1-f196.google.com with SMTP id 5a478bee46e88-2b720e4dcb4so7115561eec.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 13:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770152866; x=1770757666; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kanz66SrGPI1ONI9MQZAri2Pq2vYCluJgte+kOMKGfQ=;
        b=g0mugnxq+EGbpOn331+e/u9kp2qjV6zszmnLtH2g2H/2+M5pNyj6gRAgr4cswsxlbq
         zfpP9/W4K6lN8q4/7zZVEBabzQyNWPRIaTd66P9ocY/jhVMGlFx9WRXTYhdZ/LswC9Q3
         fKQrmNxA50ATTeIubTAyub4TgXjrmeUXHy2DGNrBF6rtX1hjxANMtV/tbGbKR2cwUr0y
         9x/CNXDNTBRioYMrcm9oczug9IXbr2dZykRtsIdCT9RjAYIEodZGc/NBqGvfaiZfVwBs
         xCK/xyhtBP0Lyh4ee+320XFgJCgvWFOQ1IkNHMP+Ahi+jK250GcPmP0UESBinP4hNV/l
         vD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770152866; x=1770757666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kanz66SrGPI1ONI9MQZAri2Pq2vYCluJgte+kOMKGfQ=;
        b=u3u///VTBMW9k/J2RLLUty+KoL0xvnYLIkR5V43PChRUoTzp2hrrJxxgIYLf8OYCER
         e5HyBZxjHWLEXi2P/VDtz2F8BJzjtdnhFWbAP9mwaRatwgeBrEoTM8JQTgx69WzVilKT
         z4tsLqKuphS4jAV+9drMJwDg2mkvVcnOnSd0eiSndUEjwVYEGwzUSA8MKYMOkxI/x7ZN
         BjRy9VRcg6obh3H9xZaLjRhfzzgo0PFb25fkuU++osZGif9CFigtckOT5Rj/w1Y0A96P
         eDR2bVwG06JbMBoofcchQaKmHDiKzwT47SUbkkfjnTcVEWNQLctQTxN2w9lrx9IIsMwI
         rB5w==
X-Forwarded-Encrypted: i=1; AJvYcCUFOqDDA2QB6XA0KlY/cq5aPITTs4deAwTTGeLv0+96x0SlgPDluXPxv/lFhCYeua4A9VFSbk6T5A==@kvack.org
X-Gm-Message-State: AOJu0Yx0DAX6N+j021IdBsQPThrPrE/e2QwbXLmGjln1qQzDxSLHp3Nq
	dzoSAfxHrIibIOVO3o3Gxrl6OvwJ4BlmTMyZ1rRwpBhxy3dA3s9YJqiG
X-Gm-Gg: AZuq6aL3csqB/HQ1e3YEKrJELit14bv6NcPuvW/NpiPrekIt7mVBCuDLjBmjCnCiFKK
	h2kF9bQV1vjjr3mMK8lu8+4rYPNYkCZ9pGymXrslCEApzhcLD1MBVS9GWP7vZ9tVKte4mPNTRyV
	nAJxR+9oFzyn6E16b4tAwPbSgn/uM30AEm+TGwdHIGek7faKQ3Whh0EEUpQRKrv5SMcqQZlYclq
	K6FNdfL+gj/Olvuc0BZlqu47BxL2r+H/7Kh8EPeBFi0EygMWUKt6AUofTvT9fqp6qOvfdU1TNwn
	xgFUuUkJeFbWfHIyg1dIBMsiz1w95P5DSi0UjhisnqNa+jqhQEr7jyNycsw9mFsF5iDsrLubRpb
	5R+GonoUuHwwIIYZuBa3UUckK73Jq0lU90ePJE0D/W3F6RvQipARHVuEguvee1byMwjU0yI8Twj
	zKmZeXD+UmnjudtMVxhgKimZh+DPp3MT+SUuA2R+SPVf62r5wRiFGKww==
X-Received: by 2002:a05:7300:fb8b:b0:2b7:fdb6:ccfe with SMTP id 5a478bee46e88-2b83294ac2dmr373048eec.19.1770152865502;
        Tue, 03 Feb 2026 13:07:45 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832f8e987sm373629eec.18.2026.02.03.13.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 13:07:44 -0800 (PST)
Date: Tue, 3 Feb 2026 13:07:42 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 1/3] x86/mm/pat: Convert pte code to use ptdescs
Message-ID: <aYJjnh6qI_bzfAo_@fedora>
References: <20260202172005.683870-1-vishal.moola@gmail.com>
 <20260202172005.683870-2-vishal.moola@gmail.com>
 <e029f69b-6d99-4029-94f5-caafb5eb767c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e029f69b-6d99-4029-94f5-caafb5eb767c@intel.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: qyexwp7ibt8k5zyyx4t6nqpndrokixyg
X-Rspamd-Queue-Id: 0C78AA000D
X-Rspam-User: 
X-HE-Tag: 1770152866-848358
X-HE-Meta: U2FsdGVkX19owH26DlVTfzRKe7E9nUI0+w4ma56kOlzV6GXei7c4Ah2WinFeQFk0YRgcfS8lg6P+mEmvSkTajeYa+2f84fk7kKFp9Q7F4+idHIR8WO77KP+QQy6xsqhxa+dML0VHJ+cIfrWxGP05n5Ag0BgQyCw3+pMkDyEaKvTHIK5tDWlLxSqH+4PpHdfRecg1w+ydVUM/Zb23vlt8i/qSrvGdji9guYM/pGZrw7s8bVCj5IiZfbQgriWlouzfP8uacCJSR4fOqR6OOw0FkQZ8GgpHU7nPOLW5od9ppyIkADP215XwVdMmYJcabfvUMMG4NlYU9PCGXdaSwhXz+43IeHsjPNlhlnfHKebFjlw6w+tA9Rka08ZdP3QEy1YS2MapAjqG5DV8h9Sb6NldgyByFloHFk17+cRNij6V1RpwgOL0qZKpF9ZXTWmwsj610z1LP9iH2p387t8HzOXVtzh5jtweu5zSM50AEct7SsS61BOUH48WxRX6CnEZUkctQsB4guY/JYlGBHxqYSt0bJvaE1uPYaBR/AMUjpGOLIxxspJyUGGeGWBSleeBjhcSCX3nbvnOd2yIZiJ5gOjPpJNfhZvmm/1zXIeIpLDL/Iu4DAzxkw8G0QK5TIypTg4P7SbKDhRVVFUKHny0w4JEQGWlOEeNBvi2ZIAu353Itrbmqg2o+HCQtf2xL6wVIOXk/qcUZVahFnV4Hq6wk7rf4pbzX4Leu+seIH8UdL1RbJrKVUWLoL+/jLDLnD96vRo4gvN46xXmcmJ0MKnT5rxcuXBmgmzUU0qUeQCUrBq7hLvdYNqDiLt1fA1qZGm91PlqVSHtgQS+eyBnqC050CEEE3Xi9fe5/T6X2njZi96rEfltd3hgmnS7v+6I42Ao17+Wf8eD/GGWwGehl79wzgcI0MwEanz5kNaLxIKgK1kcDbZoXabQ1c/LljH9v8iRRNimEqU0TipPf7FVFUHZYu5
 kVx1g+3v
 +NGg5o5CzcS/I4qPM01jAXpnsE62tQo010yVSlIKOYlEqMG9DrtTYwJfk1KxurQp+wQY6Vw4cLCl4o9M1+lOtkzGFxpw23RXNcWDLsejBppgJU4KaiGC/MBSLTUoR3ce7+jfYpdkV5FlZiMa1h9k2zyHnuLaVKtmZ3WSpTXOxb8fjZfbUAvhI47I2SMU6ul4+iJ3pe2200apGs/w1wJUSocczi2wmMoJ/PvCp+cyUdwAEi0mEaUhU59/QCkcE3WfYPAE0LOJEZK4SrJLImCMXFD9oFKOkfhdGXtqeh/jZ3/eDmkZnGk3pbFewjCDeETGlX1LsCreLYP+GQ5CG/dGVjzzfKoMpbATLrbFnFrluu7B+U+mmgasoufV1+B0YQM1KVWggRGDXzVNOOLkMk8JukPOXxHziMkXEqBN4X6PK7VnuqmtG4i0m/0ASfgFhvpDI2N6Y7MwN9QAOWY704UKwK8UXnU89Ag1SWlqoFGdmR4hKPjeoWasK9AxzyTdRVwuXw5qmDSfSd6DGohxZZBqI5aVktr/8XXWLb9deKv1cv/bdfI8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 09:23:47AM -0800, Dave Hansen wrote:
> On 2/2/26 09:20, Vishal Moola (Oracle) wrote:
> > In order to separately allocate ptdescs from pages, we need all allocation
> > and free sites to use the appropriate functions. Convert these pte
> > allocation/free sites to use ptdescs.
> 
> Imperative voice, please.

I'll fix it.

> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index 6c6eb486f7a6..f9f9d4ca8e71 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
> >  		if (!pte_none(pte[i]))
> >  			return false;
> >  
> > -	free_page((unsigned long)pte);
> > +	pagetable_free(virt_to_ptdesc((void *)pte));
> >  	return true;
> >  }
> 
> This looks wrong to me, or at least that the API needs improvement. Most
> callers are going to have a pointer that they've been modifying. They're
> not going to have a ptdesc handy.

Yeah the API needs improvement. The initial API I wrote was very
barebones back when I didn't understand enough about arch differences
and similarities in page table implementation.

> So I think this needs to look like:
> 
> 	pagetable_free(pte);
> 
> You can convert to ptdescs internally or do whatever you want with
> ptdesc sanity checks, but the API needs to be on writeable pointers. If
> the API takes a const pointer that requires callers to cast it, I think
> the API is broken.

Your logic makes sense to me. I can add ptdesc-using-address apis.

> > @@ -1537,12 +1537,15 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
> >  	 */
> >  }
> >  
> > -static int alloc_pte_page(pmd_t *pmd)
> > +static int alloc_pte_ptdesc(pmd_t *pmd)
> 
> Why change the name? Nobody cares what this is doing internally.
> 
> >  {
> > -	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > -	if (!pte)
> > +	pte_t *pte;
> > +	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
> > +
> > +	if (!ptdesc)
> >  		return -1;
> 
> This also looks wrong.
> 
> What kind of maniac is ever going to allocate page tables without
> __GFP_ZERO? __GFP_ZERO really should be a part of pagetable_alloc(),
> don't you think?

I thought the same thing... Turns out some architectures do. I didn't
question it, they might not even have good reason to do so.

Regardless, I do agree with you. I'm tempted to include
__GFP_ZERO as part of the ptdesc-using-address apis.

> > +	pte = (pte_t *) ptdesc_address(ptdesc);
> >  	set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
> >  	return 0;
> >  }
> 
> Why is there a cast here? ptdesc_address() returns void*, no?

Yes it does.

Personally, I view casts as human hints to make implicit conversions
obvious. I didn't think it hurt readability so I left it in.

I don't have strong feelings either way, I can remove the casts. The
type is obvious enough here anyway.

> Also, if there a ptdesc_pa(), this could be:
> 
> static int alloc_pte_ptdesc(pmd_t *pmd)
> {
> 	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
> 
> 	if (!ptdesc)
>  		return -1;
> 
>  	set_pmd(pmd, __pmd(ptdesc_pa(ptdesc) | _KERNPG_TABLE));
>  	return 0;
> }
> 
> This *should* be a very common pattern. After you allocate a page table
> page, you almost always need its physical address because it's going to
> get pointed to by other page table or hardware register.

I don't recall running into this pattern much, but I'll take a look.
It sounds sensible. If this happens far from the allocation sites, I
definitely would've missed them.

> To me, it doesn't look like the ptdesc API is very mature yet, or at
> least hasn't been expanded for ease for actual users. I don't want to
> grow its use in arch/x86 until it's a wee bit more mature.

I truly appreciate the review and comments :).

The use of struct ptdesc in cpa_collapse_large_pages() gets in the way
of short-term (stop refcounting page tables) and long term (shrinking
struct page) goals. Particularly the pagetable_free() call.

Would you be ok with taking these patches if I add these relevant apis:
1) A function that returns and address (like get_zeroed_page())
2) A function that frees by address (like free_page())

