Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5DCCCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 18:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38988E000D; Thu, 16 Oct 2025 14:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10BF8E0002; Thu, 16 Oct 2025 14:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25CD8E000D; Thu, 16 Oct 2025 14:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0A4D8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:45:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 367F6119E2F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:45:38 +0000 (UTC)
X-FDA: 84004855956.23.EC16055
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 37D5620003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:45:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mq2aRMWt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760640336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKAdvV4xTE9n5qoKZxok1YZP3tAtC9BHXBT0bF0XgI4=;
	b=IwTy60goAYDiqR5WpAiTu5K9G4HwzjllWKxAOV92wptVkLrOwi+f95QsYZG72GLX+U0Ara
	kC+9dxRsVjx05b7PUYOpbk0QBdsHpwBvIOhqz1UbzCEJpLzJb3r12qlbRjpzHNOwPGzk1Y
	F1KNGglX8ObgqnWNAvuZGjgSAvhgkNk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760640336; a=rsa-sha256;
	cv=none;
	b=MpD3MNeXa5Is1RF2AVd75eo1Ys28TG3TzDoVqFvdecV82rgCBySWg2hEfKjSg9oEhDsNs+
	M2HU6H7lBl5g6fLjqIXoOXIbK21HxXklsPdjlx85oDKdPzikEyIDtaTjdmgbE5Pxi4sYx3
	H1lf3V2xWk/11ONhl9wvEBdJltg+6iU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mq2aRMWt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-63c167b70f9so1880a12.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760640335; x=1761245135; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eKAdvV4xTE9n5qoKZxok1YZP3tAtC9BHXBT0bF0XgI4=;
        b=mq2aRMWtc0Q0pkWFCgG2/tZ6GK7DvBdZlOeuRZHMDfEllg9UoKOle0gQ2mTtedw6QZ
         IWjJsIoSDEqKrr+SVi9/qO29MDTeDAOBYLaZePJY/WrP9BFyq8cFaxCchVrCcrsDGdep
         fVqzMa9PUfSVpDhqviYIiD86vLyaF2GeHpGSSFQXYmzuAPDSkmVWmlOWsXW/2ULkw4Bp
         bSKSPQgjNMaQZSjzwOT0kLMU8RVUqRGKuEbLbtKLbFN8cQCfDMlZPpPvBG5P9sMIE0dx
         2AexTgQ9hil55x4GRoBWYb6MXBP4+/H8rIdPfDg0IzYNWy+yBPl59oAjz07G2UsF82Z2
         FdYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760640335; x=1761245135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKAdvV4xTE9n5qoKZxok1YZP3tAtC9BHXBT0bF0XgI4=;
        b=bV8b2L5/rZcOsBbgBEE6vAfCiOqbX3SK35BjbSnwLZDju/Cs8h+gUoERAh98y4oJfZ
         j8USsHX83Q9sCn5nXxshDw2YnvJ+PEQvVxPwaNB5k2L7ljD4SaPk99I1kvmhcbdnmSxf
         Wfaf2ZUEhhT1G8YmX8P8kgIbPRfEIzppsGghjP9oiXL6c97u6BHAmyQLBeUaoNsALcFg
         2mrYgXIx1ocq5HLTeiHPXASA2XrEy3pfvwtmjft+iDDpcg/Ylqd0vnDaQRuwwzKLFjhh
         EsGlNxOGraW+B9Aa+aCkHDYrtyXwoOS3OCS3I3rbFJIrUPMBDOCTV61DUgGvsxTpj53s
         kodQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHenr6jK1aerDLyh8vVoY9X63QLfOfbt9DjoVGIyxD4gJ8Py3+uDy+GIOHL1cJsMTS88b6enJGSw==@kvack.org
X-Gm-Message-State: AOJu0Yzzi0G+f9dKy5DbVBkbr3vh289133lHCwcBDgczat8X8HEvsqiM
	pXaV9h7TcdsWoZ9KtuUOE8Jqd+MKPh1MpMfelgrUruHEg+eMN8H1nAnVJyMVV7crRtMWXlEsk5R
	l0m2m2kHM0IeQDBIY0XwtbioHXN7FsOZIseSUo2aG
X-Gm-Gg: ASbGncvo0B/bMmkQOK4wR0CaHyFUgepZlec+XrgbZidDuHGfvdZRa0jZ3sbjVySUsEC
	8RTGFClsKxm7kdSHe2N8mTS5rcBTq4qb5Zb/qVZniTrPElvJZ797FMBCqV2+jVWYj7cOG7qWJAZ
	fYLEinmGKowOPIF/f5h1GYsn/dDi7a07Kz8mN7QEiMlyyjqnUijAwuE0eryh+wLHCJ7sci7r3BO
	2CPkXJyQJhF+NnMsLLNF0YaWGzVJjmRn+ajj+X4rBb94fhFd3gqZaR0H1+gt/2w3McnkfaCoejN
	KUj5mnwJ+/+rfAi1BXGEZjW95Q==
X-Google-Smtp-Source: AGHT+IHMU7eVzIIxanU4159bOcDF3YZy3khy4dytu3X9pooQwOC3RvBQR6FnIdRDKA1rp6F4oJCjxXDvC7z56ZeUki0=
X-Received: by 2002:a50:ed13:0:b0:62f:c78f:d0d4 with SMTP id
 4fb4d7f45d1cf-63bebfe1112mr244762a12.6.1760640334407; Thu, 16 Oct 2025
 11:45:34 -0700 (PDT)
MIME-Version: 1.0
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de> <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
In-Reply-To: <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 16 Oct 2025 20:44:57 +0200
X-Gm-Features: AS18NWAPtIHsIZ0KkjzqmIc9gow3CG1PS8LMsfQSH4RUrDyio7sggwn916JOBbk
Message-ID: <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: David Hildenbrand <david@redhat.com>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"trix@redhat.com" <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>, 
	"nathan@kernel.org" <nathan@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "osalvador@suse.de" <osalvador@suse.de>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: uyietgetiagoodwoakem1shuhug81but
X-Rspam-User: 
X-Rspamd-Queue-Id: 37D5620003
X-HE-Tag: 1760640335-722776
X-HE-Meta: U2FsdGVkX195QBrieINTdqTjc5KjectvQ/eBRznu5fIWG8m+eyG2Ngjuzx9/ajni25lkgniQZFafp/KGZJV58fMx0LEuSNE99nrsPe2Y2wA4jHRxVGskQ/ibSImmIR+Ll1d/+mGNyO/gyvkQUj0Uqht7yYZynT3QFFZouF/uzUAgHfgpYaOa0SWxdKr5zc34+17uCG3e3v/TcNK4OxRbLGv2AH7w/Vsm0xrnBeGJqCV+xhCFsQcTCDg4UmW7tNL7BWXi8JTtI9DNQ6XPcSrlq0+MXMwIOI4bO75uzmfttkGB+PxEyfzhN3rOqq4qJp8QfZvtZeoDkaRXY3dqY1tgQI+KeO1a9xD7xHrXPHOxfCXe7nKxmHf3bd2BWA8dfbOEgTjo9O9NMBnswkS80S8QSai25XWHvLdpIbpEWQ4645IhtOBYByZLPxrhDB3/+Qo1e1AimN8yhwN7wvQuxO62bl+hG/gscPXBfpZju12UZh12fxqL/h9f3/Fu35dFNpKVqqP7IGF9zALsYsOGQTOYc3i/M7APmg7Zw/2ela9nha98hom3aaB/aIGy+6xJFO8Kerdy9Wyy8uWh9JC/H9e2S7p5xj1CnpoRyaBnqHVM/UTIa2rgB+x39vPeqvZXnbqJ/6MbeLuASiF0UgKUs7+E5pzU2MiUiDNKYTO3QcH3c77IhHTr8lts6iHWfAPlULqx6p/OgXbDkdNdhkfuqRquRVrKt9EZgFGuLTSauSymih7Ju90x+5KrmDuRH6zICmu+7rh0RetIVbp4ep8t9MbhNtfF76R6bQfOk+yPABj3mvife+/gcrsH8qG3eLwgH6+nchtCcHj5sRCBdYOrOl+/tFqPNxnGvhfHIE+V+nPy0n9BJ3ENziczGW3pgXIkI6mpgjk0Mj061s9LT27CFisEUUgzif591uBl4Bzrq6yhT8EEGkQppyO2IBDtJnOMVTd2s5WYy37vPQb09jsPsYE
 JDtMQulb
 EFUVhj8wxgg2LF9rrNhprWgD20lBolSLQmbBK1nX0MPe4t4Ex7HIepjJFKblnMKfGHFnXSdoGeK/A4FnuA5aHK8gkREikBIkLdxRtAatttETz9ZFzjyezGxlkMyIvLxzrcjr24mI740btTAAXytg39BO75s+CkHXm8j3PslIEElz9sAw0JY8VlBJP5iDWqaQRCR+TyfgyHByVwmfiDd82AMXC1ghm0EJJtfRKaJASeTyZRZbZHot+S6SW4J2/bm2zGPs7lMR+woVYU8sdfwpQRZ1Esc9WNSmhJfzXZQqG/CE+rAXY2m0Qfd/G5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 9:40=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
> On 01.09.25 12:58, Jann Horn wrote:
> > Hi!
> >
> > On Fri, Aug 29, 2025 at 4:30=E2=80=AFPM Uschakow, Stanislav <suschako@a=
mazon.de> wrote:
> >> We have observed a huge latency increase using `fork()` after ingestin=
g the CVE-2025-38085 fix which leads to the commit `1013af4f585f: mm/hugetl=
b: fix huge_pmd_unshare() vs GUP-fast race`. On large machines with 1.5TB o=
f memory with 196 cores, we identified mmapping of 1.2TB of shared memory a=
nd forking itself dozens or hundreds of times we see a increase of executio=
n times of a factor of 4. The reproducer is at the end of the email.
> >
> > Yeah, every 1G virtual address range you unshare on unmap will do an
> > extra synchronous IPI broadcast to all CPU cores, so it's not very
> > surprising that doing this would be a bit slow on a machine with 196
> > cores.
> >
> >> My observation/assumption is:
> >>
> >> each child touches 100 random pages and despawns
> >> on each despawn `huge_pmd_unshare()` is called
> >> each call to `huge_pmd_unshare()` syncrhonizes all threads using `tlb_=
remove_table_sync_one()` leading to the regression
> >
> > Yeah, makes sense that that'd be slow.
> >
> > There are probably several ways this could be optimized - like maybe
> > changing tlb_remove_table_sync_one() to rely on the MM's cpumask
> > (though that would require thinking about whether this interacts with
> > remote MM access somehow), or batching the refcount drops for hugetlb
> > shared page tables through something like struct mmu_gather, or doing
> > something special for the unmap path, or changing the semantics of
> > hugetlb page tables such that they can never turn into normal page
> > tables again. However, I'm not planning to work on optimizing this.
>
> I'm currently looking at the fix and what sticks out is "Fix it with an
> explicit broadcast IPI through tlb_remove_table_sync_one()".
>
> (I don't understand how the page table can be used for "normal,
> non-hugetlb". I could only see how it is used for the remaining user for
> hugetlb stuff, but that's different question)

If I remember correctly:
When a hugetlb shared page table drops to refcount 1, it turns into a
normal page table. If you then afterwards split the hugetlb VMA, unmap
one half of it, and place a new unrelated VMA in its place, the same
page table will be reused for PTEs of this new unrelated VMA.

So the scenario would be:

1. Initially, we have a hugetlb shared page table covering 1G of
address space which maps hugetlb 2M pages, which is used by two
hugetlb VMAs in different processes (processes P1 and P2).
2. A thread in P2 begins a gup_fast() walk in the hugetlb region, and
walks down through the PUD entry that points to the shared page table,
then when it reaches the loop in gup_fast_pmd_range() gets interrupted
for a while by an NMI or preempted by the hypervisor or something.
3. P2 removes its VMA, and the hugetlb shared page table effectively
becomes a normal page table in P1.
4. Then P1 splits the hugetlb VMA in the middle (at a 2M boundary),
leaving two VMAs VMA1 and VMA2.
5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, for
example an anonymous private VMA.
6. P1 populates VMA3 with page table entries.
7. The gup_fast() walk in P2 continues, and gup_fast_pmd_range() now
uses the new PMD/PTE entries created for VMA3.

> How does the fix work when an architecture does not issue IPIs for TLB
> shootdown? To handle gup-fast on these architectures, we use RCU.

gup-fast disables interrupts, which synchronizes against both RCU and IPI.

> So I'm wondering whether we use RCU somehow.
>
> But note that in gup_fast_pte_range(), we are validating whether the PMD
> changed:
>
> if (unlikely(pmd_val(pmd) !=3D pmd_val(*pmdp)) ||
>      unlikely(pte_val(pte) !=3D pte_val(ptep_get(ptep)))) {
>         gup_put_folio(folio, 1, flags);
>         goto pte_unmap;
> }
>
>
> So in case the page table got reused in the meantime, we should just
> back off and be fine, right?

The shared page table is mapped with a PUD entry, and we don't check
whether the PUD entry changed here.

