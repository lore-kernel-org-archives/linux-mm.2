Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4755DFF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 17:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8526B008A; Sun, 26 Apr 2026 13:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D05A6B008C; Sun, 26 Apr 2026 13:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEE76B0092; Sun, 26 Apr 2026 13:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 788156B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:34:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8A94405A7
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:34:25 +0000 (UTC)
X-FDA: 84701406090.20.F91C725
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02792100003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:34:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JKZWQLt7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777224864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyGD/jXsZR2JkMBX6t9t85Fm770UU4EyuOCFTF+xktc=;
	b=Co4Tu/KHiLY863ontNZYF9bmH7DKSxzRxTzrWAPNjBRnlMSDf8Kf7/P/+X+1/PJnEp2fL2
	ljmTQVNZi7X5Tnk59X0O0S3wJqLS6ZLCUYLwFEzQo1YRho0t9OGttWQgVd5laoxWD/KgI8
	b2XJph8ovwvRIGJL0WrSIIwMyx0+pN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777224864; a=rsa-sha256;
	cv=none;
	b=647A0tDJOxPtZZFLlFMHN3XNSsoRO/63LSJ/9QY85/M38S0a9zVUTimt/rNgv+Lb8+dsk7
	xOI3pAjyIDs0oG+QnoEUyvl5rOA+txzkJO04h9VyT2XRyQZN7/2CvbT+jqBy8JKthCv8D0
	TPYR4aCx/qsxySIk5xz7l8SddeDoBcY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JKZWQLt7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43fe8bda8e9so5199773f8f.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777224862; x=1777829662; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QyGD/jXsZR2JkMBX6t9t85Fm770UU4EyuOCFTF+xktc=;
        b=JKZWQLt7iyaHBhpDaZheLS7pB80Gecyi0RnCwBD8nzKAokBqbaWRmKB8yl4Sim4f0b
         EjuNrNeifT1aLA0wSf+tbz74xI6z+ekaYtJbFpPuMEqr3Ts25uzUvvfXNIg29hjvyuWs
         McVhegI8ugsHqHZN10vsHYh4SjikL0OLEM/P1belG7230UYGVqynieC4XGjfR0Hn38Pp
         OA7PPxmfw3LtSQ2O0AaIMDMyq7PxrlvD34UxzbBm56x0AgeonBgcycoLC1ExKBdN7io9
         QdsReHaxXE0JfszobURhOxN/HRSiDGa1HqAlvLhudDlIH3xZJjCRbH2KiRGNJ7I4ekyG
         PE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777224862; x=1777829662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QyGD/jXsZR2JkMBX6t9t85Fm770UU4EyuOCFTF+xktc=;
        b=nkmiDay22r8xNgOiWAJVgDYjFL0v934VkL7Y0d1K7Lhqj+USRfwkmjWBOFHi0giJcg
         Hko6vRkFQL+Ay/YKt5hmEkP/ccgf1+YQQQzHih5Q8eiDIg10eFW+baGc4gDCyEZLl7Kk
         q/vxmocoNejijFdC1W6CLnm7e5wKqdrOg7BzMDNCUHWSib8nRFOThzU++7RylMvrTwty
         AP1EHjjdxz2RCuaSkV3ZoKP3uTJ/UXoIn4RxN25CjO+pmbIq6kZMOSfjN4woA/S0+5hm
         D/S9luL1E8a2+Ms437k6w4XTYLCLhkC3JzQJmurvIuJgqtfNHnC4vYRTf2rPPhrAt9Jf
         puHg==
X-Forwarded-Encrypted: i=1; AFNElJ+LoF4wHIzEhh/KTTy4h2o1rXFHJC4MswM3c/UJNEv+Typ3TLONJ+vR0GYzi/tmfmimzrwgJWPlUg==@kvack.org
X-Gm-Message-State: AOJu0YyU6iw4K0aevLBSe+nID5ehByfrkIyQy6KZC7rPV5eObJ+VrZon
	CtBNmtxfKPMNibBefakPcHN2majTpmKuXWkNR/oiLoM2AtQFDhzenqyj
X-Gm-Gg: AeBDiet/MAq/x5O7S9zSAUTP9GwQrIPlO9zjz54onZm0gCM7gZEsrzb48+DLlgq00cG
	XC3W3pmkUnSuwxtWbDevl1WCSZmrl6Vv7JODbsXJcnhHDXPcWTAWOOl6cA3SDCV2WlHBrT+OFgT
	VBf2p9ojYLowttjNdysFuy4FH4uzrYGjU13XT0LUgR9SVZwSVZ6A71GeGw6yNKOlfsEk+ZxiNIS
	8p6KO1Tjl10khdVGz81tZpDeQLFy+TmIisXaWndaaBNRwnXrB/0wRh8YleuESS/aFoe71LVtk/J
	ckGbzMrLbMTTvMVUgTyRDsboO48TTCHqozQ+eek+XaTWuUGwhW7xAlRSHjmExmDw7wB/P+cUS8q
	fkUluaj7fidKjVOiAgdqJAAsjuAP55049f/OHdazQPUg6Cr6zUQUWlX/E83ysFJsHmeT22dRgPE
	CtSr/hHynffeFFmGb2NHOSRVBY+9t7q58KpE1B+n+0ArR64CUJoobxSTer5ASPYHqxfO//u0LzE
	Wk=
X-Received: by 2002:a05:6000:186c:b0:43d:7946:badd with SMTP id ffacd0b85a97d-43fe3e0be7bmr61587116f8f.35.1777224862017;
        Sun, 26 Apr 2026 10:34:22 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4411c9f4f03sm44639379f8f.1.2026.04.26.10.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 10:34:21 -0700 (PDT)
Date: Sun, 26 Apr 2026 18:34:20 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Min-Hsun Chang <chmh0624@gmail.com>, arnd@arndb.de, msalter@redhat.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-ID: <20260426183420.2216d187@pumpkin>
In-Reply-To: <20260426040925.b25cb2a32680bfe884431abf@linux-foundation.org>
References: <20260307092119.20733-1-chmh0624@gmail.com>
	<20260322144032.7353997c@pumpkin>
	<20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
	<20260425230134.5449498a@pumpkin>
	<20260425151240.2a46e3a8640fde3902461d41@linux-foundation.org>
	<20260426114938.4dff28c8@pumpkin>
	<20260426040925.b25cb2a32680bfe884431abf@linux-foundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02792100003
X-Stat-Signature: snf4foc3wg6rhaex1m6jzhzde4eqn4g3
X-Rspam-User: 
X-HE-Tag: 1777224863-443687
X-HE-Meta: U2FsdGVkX1+1kXFxMI4+iQYtshnpC64ItLHxnY+MWD9T9SjVhNSFRzxwEqjUoX63I7gdwxurXv3Xa77dUg4zO/ELQuXL9Xm4Y6ZTasCcxHRW+Glas+oc0Jl2RHT6BsY2yYEdshPU0g/C7NbUWkJIHsNhLQmsx2klJCl5sxAOmqw6o6hFXKPCX8+gb+Bl5ZnauIMyFsJxRH0QTgmx0VfvXiNXiBcd6wov9KtRFydB4Njz2JONYBwbpt8eEz5MV1YpPfjTPncDzygf2aPevbzlKDFrKuvS6Ql6wQ2wG7T88YpQK1HOco+l0MsQCGG8jKeqkX0VuJ+hhja7mYrLUNKta6VHvCzJ+lIEODRXJlvHBXEvdX3TkTDjYQH8j1oVfdnbDbhKbafak9aZdqb9QadW4SmRHmuJOvlcLnHcUyRNvHp5B3pcwafv39HxSflhSCVcjNq5kiW+hwkdRZglt/zY2o/rilc91xzPQMgaBnXo38r/tG24w3p9AbCF5ayZEOnz+FFbxNeiRQJyk3AfOMwcOWhX5iknJCadnmhl7G9UVBGRB+B/pvMsuDrq1KiXwHtvfF5NiNyVt9YtDn0yFawcvuG1ZdUc9pMXDwEwrH+Lo5C/A3xLi+/Z4VMBt+wiUJU7MQnV+2mNy03mjw4uPwjvIhT6oF+dDzDj9ZDxeCiPl+H1FhGm/C0fZbV6wzwcln3oJUKUVFKoZlsIqXrmD4ZBy5VLRMkUjD7GqNDWBghXVxul1c1f/LIBn0oxvUEVa2176V6LIQEO7jKV3LHsM9H8BbWpVAOBrAmKY9xh84IjpJKdlEHrtIX6/5R5MBQlKq5VY8CQuMBl6j5X0188U3Kxi4a3ncPc5nMXhJBf+UUI3zNz3sr+aul+kOo0rk/c0waD1YrVR5aNjdoJfBOP1eo991pzmQI43ChtXGbHaUMtZoubnaeF0AMJ4ITlI7ITcrLc2r+m5wSsdN/LIhWev6O
 Dr9b8Z/5
 c1lmwcA4BpEH4n7ExnN1QS14ysWph1wjG/w93ifcEKkmNVwqQlz3OEERoZFJYWsKqmN5st5mhsUvmbAjCkZJnAInMYqRqY2HKpBARxelxAE/xNRWmkKJbxOpiUHUGS5je2IX5vKW/y66w1sEkFCH5yUcChECGGpuYvFUnLOy5x3rShKmo1BypzVaTHj5WaciAnAPrdUKGhFaGuqXJuUKHS4iuIJ1T/Nl7zhziUeFiU6aQa+ckkDtWP3Gjv0fhK9XyZ7xT3YHPImo//c313QDQpg156erKlqGImyTJoM4ZYiQWCdF8jWxC3hH+2AYukwZgfE2zEL2EOlEQccLhZzo1L837i/K4x6wUwTSUrZvQT29ejxiB70ZShRmz7E3X+C3afeQNiTsBOXdpHPi/TJYbrVAXpzej7NwhRx3amlflbCPQVvM+qZQ6ulW6UsN2VWtQUCkuxPYOcQ9U6qxQy/7PMh07ebd/2AKg/pkwVwX6U061vkCBVRxccS9nR3pz3JFdYq7sIGFmHe5dEaZhuGFVfI3qy8V/JzUYDaTMToRzDAIUq9FXsBVXE7JfTvRxQ4do9wIDGdG56vFYFQHigty9ZarztveC0CQbHtCJLBe/dyXXK4en9kYqOQaxDjnxQP/PPcXTWvPBqAXZS0H3WjvhfiqXks6aQuWl7jyRZq1uTt3jU9Hwue2gOaB1lkKFNj1i6gwk4WDmoAfb510=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 04:09:25 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 26 Apr 2026 11:49:38 +0100 David Laight <david.laight.linux@gmail.com> wrote:
> 
> > On Sat, 25 Apr 2026 15:12:40 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >   
> > > On Sat, 25 Apr 2026 23:01:34 +0100 David Laight <david.laight.linux@gmail.com> wrote:
> > >   
> > > > > > The real problem with this define is that both idx and phys are
> > > > > > expanded twice.      
> > > > > 
> > > > > The real problem with this define is that it's a define.  Why oh why do
> > > > > we keep doing this to ourselves?    
> > > > 
> > > > Sometimes #defines generate better code because they are expanded earlier,
> > > > and sometimes you want type-agnostic 'functions'.
> > > > But neither is true here.
> > > > 
> > > > But I think I'd go for 'always_inline'.
> > > > Sometimes the compilers make silly decisions.    
> > > 
> > > Gee, if `static inline' misbehaves then we have big problems!
> > > 
> > > What's special about the fixmap code anyway?  It's not exactly
> > > fastpath.  Perhaps this stuff can simply be uninlined.  
> > 
> > Some of the inlines are trivial - just adding an extra parameter.
> > But this set would be simpler if the last function
> > (__native_set_fixmap() for x86) returned (address & ~PAGE_MASK)  
> 
> I don't understand this?

I found the following:

#define set_fixmap_offset(idx, phys) \
	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL)

#define __set_fixmap_offset(idx, phys, flags)				\
({									\
	unsigned long ________addr;					\
	__set_fixmap(idx, phys, flags);					\
	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
	________addr;							\
})

static inline void __set_fixmap(enum fixed_addresses idx,
				phys_addr_t phys, pgprot_t flags)
{
	native_set_fixmap(idx, phys, flags);
}

void native_set_fixmap(unsigned /* enum fixed_addresses */ idx,
		       phys_addr_t phys, pgprot_t flags)
{
	/* Sanitize 'prot' against any unsupported bits: */
	pgprot_val(flags) &= __default_kernel_pte_mask;

	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
}

void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
{
	unsigned long address = __fix_to_virt(idx);

#ifdef CONFIG_X86_64
       /*
	* Ensure that the static initial page tables are covering the
	* fixmap completely.
	*/
	BUILD_BUG_ON(__end_of_permanent_fixed_addresses >
		     (FIXMAP_PMD_NUM * PTRS_PER_PTE));
#endif

	if (idx >= __end_of_fixed_addresses) {
		BUG();
		return;
	}
	set_pte_vaddr(address, pte);
	fixmaps_set++;
}

Doesn't seem to hard to arrange to return 'address + (phys & ~PAGE_SHIFT)'
from __set_fixmap().
(Other architectures will vary, but I suspect they are similar.)


...  
> > > We inline too much stuff.  
> > 
> > True - don't look at what strlcpy() can generate.
> > The inline code should just get the constants from the compiler and
> > then call the appropriate function.  
> 
> I can't actually find an in-kernel strlcpy()?

That is because I meant strscpy() :-)

In particular https://elixir.bootlin.com/linux/v7.0/source/include/linux/fortify-string.h#L275
Particularly once it gets as far as calling strnlen().

> 
> > As does the compiler.
> > pixpaper_panel_hw_init() repeatedly calls two static functions that
> > contain sleeps. They all get inlined bloating the code size and
> > exploding the stack when clang separately allocates all the buffers
> > in the called functions.  
> 
> Poor thing.  I guess compiler developers are more focused on userspace
> code and aren't especially concerned about kernel's particular
> requirements.  And that's understandable - it's down to us to persuade
> them to add options to permit us to tune the compiler behavior.

That would be wrong for for userspace as well.
Inlining and loop unrolling decisions don't seem to allow
for the cost of reading code from memory into the I-cache.
(Loop unrolling is so 1980s)

My suspicion is that very few writes of user code ever look at
the generated code.
So the compiler developers go their own way optimising things
that improve some benchmarks but make more normal programs
run a bit slower.
Of course, modern cpu are fast enough that it doesn't matter
what is generated for most code.
(end rant)

	David



