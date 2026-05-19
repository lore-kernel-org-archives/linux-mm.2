Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B20CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 17:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179D06B0005; Tue, 19 May 2026 13:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A9E6B0088; Tue, 19 May 2026 13:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019596B008A; Tue, 19 May 2026 13:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E14CF6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:00:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 963FB4074E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:00:05 +0000 (UTC)
X-FDA: 84784781970.05.B409986
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 65AFC40012
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:00:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jW734tWP;
	spf=pass (imf12.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779210003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyhG4QIZqICKavDwcU8OoLlp4cF7iJkoZFMHnoscP14=;
	b=uZiedILFoJIBW2CAOag1PUSe94t0eEAKNYXB7wTrqm2AJ0Hh89vp+PQGsMUfANyrBaH8sb
	M4hK4YNfClzA4K+3rZ3kQatchQ40/efqSaZrD1E0xoIYNVgl7T8csrh+Gczq2nY+soYgj6
	KW5bYdYJba69SOjG0v7prZCq2WHYmvM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jW734tWP;
	spf=pass (imf12.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779210003; a=rsa-sha256;
	cv=pass;
	b=UaJXkABXyaNw7ZJWI0MwN5myv26JRfh+cVCnrIhDb2ZhDtl/v4TkJMRTWC+yQHzbGiwjsl
	WzkKg1y9/RM/xti2jhrNlnFYp+vE3QuzIueJ/ktU5oZ7MdzOMOyieCydZoyciRNT9xd6ET
	8UpDk1GOQbGjbBMCbimitQlK8QPmxgE=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bd11a3729e8so641639966b.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 10:00:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779210002; cv=none;
        d=google.com; s=arc-20240605;
        b=UoV1SK5Z3nnxOv1m6xd5ZF02gupO5dBFIWE/9bvcxw1MlnMteaBrElSbPTRBhu6l9I
         KqvYMmv0/1FFTFob77G2uHLi7J5gRD8Fmo6nb/8jMt415vBP3teFQ0JCGby47F7A43HP
         bxA/ebv7NDe02bHeOHHvlqilZQMc/9Qgs87CraUoWLwz1rAN6v8F/k5eSppH797EssrF
         jNQvWTFXPBZfnTH4skGU39TUJ1aCrUJZHo0IMNq0tOpVc5j+ozEDM1f6RJcxFidWub9y
         lQPbjlaltkbE4jR9ze8kkCgsN9cRzArTjAvgIM2GvSHOgkLODtqRvd2Om3bMeQyl76iT
         rASw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pyhG4QIZqICKavDwcU8OoLlp4cF7iJkoZFMHnoscP14=;
        fh=Nv8y/c9hD/gGFZmfmXabg70HsjUsPqun5M7XOf9ZWog=;
        b=OSuYrai0crRSDv6ypoBoynmvf1hfpyN7C68GM3Z/NBrmxNJA9PaXIAxnUgUY1bDToE
         jjQZpKHl2nGOkK8WYR0KDSwOlGx1s/xerNUvVsYQB7UuG6ubUgy0zZFW8TP0YoRlRxUf
         ksZ6yszAohI42KmfA+/aFyKIwroGoqtRJvLFq+x6eu9HF4L6GDdyrDPu7nHTNncvl5Ss
         qXWCO6WfPwUPj6IGvt6g/8pYNBxDK2ROg3AJxmngLP4P8LS874HB5yiy7Ximk3DUL8+J
         jqmtuuIXY6jfFUsGR/tZDICciJN5Bg1IXhIlGfMI/HxhF4t2zs/kqSEhkRri3ebERTbk
         WOEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779210002; x=1779814802; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pyhG4QIZqICKavDwcU8OoLlp4cF7iJkoZFMHnoscP14=;
        b=jW734tWPkZjT819A05UMxE6bsW881EtJBfRRuTOxNTD21GcNnZAKoSXhzEBbyW9MXz
         mEPkegzOKp6vAGnUwCefjEXFMFv4Zh9SlG2Z+ulZCWG6Hiq1sEkpCiKvvdQBW4cwH+u3
         3gc6DZnleqZNKyEw3zDQ4HOZtSYPx5bjo+mfvKuxHdzoc4gYuz8ozQGG9kI515vS6PBM
         Gj933pLWp0zaOCoFDRG83ER/jFuhZpl2rSsdU7Na+IoAEatjQADIft9z5B4DN8pjEcP0
         /hEBmRYgX3Dv6KoS3y37qRrfP7JCZ0jgIisn1aXUgoLSscEk7muToBdQP6gKcmj79nHR
         KauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779210002; x=1779814802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pyhG4QIZqICKavDwcU8OoLlp4cF7iJkoZFMHnoscP14=;
        b=TRpCVVxEM90sT+9u+gJjhTyGlhOAL4wKYeiRP5Ax+5cjVvdhgE0nkbF/ps0iRv6zyN
         tKa/iNU7tqb0S4peI6jzZ8GNQvz76KpJ6Zb5thBJoaPOy4ZvorI7jPknVnNUoJX2TVGd
         S5G+Ew+lbDFYIDCVGEdSTI2SYLgGiHOP73stHTl0y4GPcJDUq2j20cM1Ue38/bntI11A
         VZFWaSHKruFg++nlgU6cNwp13lQj9iR5kEwXQjCS1PAMF9nFQdGY3IV2gl1cA6DQfNPh
         h6POJTNqhMhgbYpBNzPbPx041xNRL7T5d85Bv2Z7N0HFJwaJ9mJCUBfH9YbPDc5NqpN4
         aOlA==
X-Gm-Message-State: AOJu0YwxtWGwnPyQM1WjX4+9IACHJ2CICEUBcCcIiS5e1kkaortX6/fB
	xiDnyeHJA2V0zf49xY6Yhg9aWirGGV094nJ93Kf0u1BevbHvCsuJ+hKexqRISoH2ifmGmMYgWct
	Woo7S4JXEpc8XgV0qcdEvjIy5fByLXIfa+oQ4tn8STA==
X-Gm-Gg: Acq92OHzjV+ZNMhsOWLw+meIJ9Em1KzQinra7BEfvvEBlIeI48c+aKkMmc2BoPlUMJr
	oFfo5cf7HKCI3dfUC43PCXs5lLSUbvTZOLqo8/u+tSIVhggSnOOJm8ugduiFoZe0Rb66YFhkk+y
	ucmA+czVMFLrYat3L/RxGv4JL25FArG/+0nhEWoWWiH10XRB+m+HEW2q3/UZXS3JfEFy1h65XWM
	pl6Wd6F0YHo5TFryajtLB8WQB7+R3kSW/fIpP7Sn8602ZWZfC9an1/4n9aIObikIRRqkzWjsBjE
	dQEzZIA3QkMGLiWKiOxrdeamp9bzKiacZaI4NbRVPmvTAw333Yc=
X-Received: by 2002:a17:906:f59b:b0:bd6:4d6d:e02c with SMTP id
 a640c23a62f3a-bd64d6de820mr859954566b.2.1779210001640; Tue, 19 May 2026
 10:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
 <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com> <CAD14+f2p7D6eco+-O0X6zWwi-XaxGLs0nQKDAC8eVWhQmB1VhA@mail.gmail.com>
 <e38e5fd0-db57-417b-a2d1-0521333ae7cb@intel.com>
In-Reply-To: <e38e5fd0-db57-417b-a2d1-0521333ae7cb@intel.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Wed, 20 May 2026 01:59:49 +0900
X-Gm-Features: AVHnY4K5SYQOv34TwiBv3zKFQF1M6Tyl-TeVLU2eS0aTWiFY5udiXMkdBY5RsDs
Message-ID: <CAD14+f3sohXj9SKEkRXGK_Mpbp73R5az-tsiHnHkj0poBHwpvw@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 65AFC40012
X-Rspamd-Server: rspam06
X-Stat-Signature: y11syc618ygktbcdwkojuhyj4uu5dhpw
X-HE-Tag: 1779210003-824834
X-HE-Meta: U2FsdGVkX18/T1h5lEG2paHd/Sz5/1XToewyPgjkrx8ejRemiW46u4pRtwikmy+UG5m8xxjKUaEDtT0WKPtGUT53kO3P4FKMdAVdg2DRdUxDYBN2zDmCtnL9qZw8sBSSv2sLFhALoXUbVERfcKVemBsSIWdqnmtvZEiTdDe5Fiz+Biv62uCxO13sqfSS8znckZ2tMq8bcqCqVIF6w7VlXrMeDyC270XUtnLrSw/dtpySGwnS6p50mS+9SYcK9ZtdIH4JMQ8vR09WnNjT9hMlPtnbjaDmo543/af6hmDNghK2bZlHXJjG4qScNAzvphleGr+IZJiMYWnl+7K9WDijijiX5eAqdJatyk1qA0Wd6YPghj0Xwc/QUYhxV1mhQL9+W641uN1BVSksiD9726MotD9RpHdqkAiHSygrw5Z9cHRzTdegeixlgQsZ6mR4lY9e5v91lGmA8jZSLT2YFfP3GfP5jl0NcNjpGcJ6ZtkIMbNzKyvaP7BUPnM/1eZWAQmls3oPeLv29mDKZC4Ji1XTFIu5ZwAeAVAONilKFDfzQzY/zEtofJqg7S6Fg9pjJ7CgxmChopbNoMsTE+KMly6LzCXwYLD/z+WXVnltMq5i2For9htZF9e3oteyO0ZugKRmU6PNHfZqB8NpayRNrc7dqwJlh5Fiy2lVllGmfAQbdNhLDxK+qNYuE2JD47U5QDNC/qtdCyXqSITf+mNSTCygozvqMO9MnU34ySelvUly40KAh2N+G4pUOgAJ5Y5qtP3DZD05gFNvobClu3HPbwICAL7Cjle6UVCPBM/ariTj1S/PyYA9YEZK4czkHnTwf44yqm4yEjAEhy2ji67KyqGdlXUlPtjEbhYLabElBMxrBmOY+lXCgdSxPzSoHTkqaLlsktF541xNvTEiDlBUDLwZC2b4buqCyQo0UtbJXWyLlClfuMK2yGyie/2IIDqFj1lSUmJ1Cj9/9JCfdnH63Fm
 D32oQt2A
 F0cn2LfWrGmavB5xjU9x46bxEw6OeFYJKvpR5EswW6GghSdBNa2N+UBppOm6/qkqG53dGPz6qaQaTHHr0Jr37adCclp9sp0U449Zr1pw+4yQV0AbEPNja3cHfLTG1jHYxN3Hx4ytUZT+4r9yYQVc5evPiM8BbZ09Pm94EsrEYeJdRFWkMXE2HR1rbnENmMcLZgo6caxvnxxCMkxfgtMTibtcv/PWGuEKU6ZBnh6o18f6/ouq9g+m8TNd6ZY91tPYkUSyCVYxH+lxWqG0tLQEBlh6GmKFiDD5EMbiwxFl/gtsAVQSdepdSIj872TNXSPXOWrczTTr9+vbj4iM/oPWEYlToGdjhxVYTOILDhHzJvwfqLpBxTElBxhLJatoJrsU7B30Qp3rLPEopmgAb49/lsM0UQMkGsbMBqW25prueR9froisn76D87EDRV8dckgHzqtpPltmThizN04BEoL62XD8Ya0lUysVfZx1d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 1:41=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 5/19/26 09:27, Juhyung Park wrote:
> > Hi Dave,
> >
> > On Wed, May 20, 2026 at 1:02=E2=80=AFAM Dave Hansen <dave.hansen@intel.=
com> wrote:
> >>
> >> On 5/19/26 08:10, Juhyung Park wrote:
> >>>  #endif
> >>>       } else {
> >>> -             pagetable_free(page_ptdesc(page));
> >>> +             /*
> >>> +              * Use __free_pages() to honor @order: vmemmap PMD leav=
es
> >>> +              * freed here are not compound pages, so pagetable_free=
()
> >>> +              * would lose leak 511 of 512 pages per 2 MB chunk.
> >>> +              */
> >>> +             __free_pages(page, order);
> >>>       }
> >>>  }
> >>
> >> I find myself really wondering how much of this came from a human and
> >> how much from the LLM. Could you share that with us?
> >
> > Not my first kernel contribution, just so you know. (first in mm tho)
> >
> > I asked Claude to write both the commit body and comment and it was
> > too verbose. I manually trimmed it down.
> > Sorry if it still sounds too LLM-ish.
>
> Yeah, it still sounded really LLM-ish to me. Still rather chatty.
>
> > This was tested on a VM with virtualized CXL device and toggling it
> > back and forth was visibly causing leaks. kmemleak was unable to catch
> > this (rightfully so), so I skeptically asked Claude to see if it can
> > figure it out while pwd was the kernel source the VM was running.
> > "Access the VM at "ssh -p2223 root@192.168.0.185". There's a memory
> > leak whenever CXL memory switches modes via: daxctl reconfigure-device
> > --mode=3Dsystem-ram dax0.0 --force, daxctl reconfigure-device
> > --mode=3Ddevdax dax0.0 --force. Figure out why. If you need to reboot
> > the VM, do not do it yourself and ask me."
> >
> > It did in 6 minutes and it basically told me to revert bf9e4e30f353. I
> > was very skeptical and reviewed manually (with my short knowledge of
> > mm) why this would be a correct fix.
>
> Neato.
>
> >> We're trying to get _away_ from using the 'struct page' APIs on page
> >> tables. This goes backwards. Worst case, do:
> >>
> >>         /* vmemmap PMD leaves are not compound pages */
> >>         for (i =3D 0; i < 1<<order; i++)
> >>                 pagetable_free(page_ptdesc(&page[i]));
> >>
> >> Right?
> >
> > Shouldn't I worry about the loop overhead? With order =3D=3D 9, that's =
512
> > iterations. That's compounded to O(N) when the entire memory size is
> > in consideration.
>
> Is it optimal? No.
>
> Will anybody ever notice? Also no.
>
> Will anybody ever care? No sir.

Just spun a test with that loop. It doesn't fix the leak.

I hate to be the guy that copy-pastas LLM but this is outside my
knowledge of mm. Claude suggests:
"Each pagetable_free() on the tails is a no-op: When
alloc_pages_node(node, gfp, order=3D9) returns without __GFP_COMP, the
buddy allocator only sets _refcount =3D 1 on the head page. The other
511 pages (page[1] =E2=80=A6 page[511]) have _refcount =3D 0. There's no
compound metadata, so they aren't "tails" in the folio sense either =E2=80=
=94
they're just contiguous pages whose refcounts the allocator never
touched."

Any ideas?

Thanks.

>
> Can you measure the difference? I'd wager a beer: No again.
>
> Even if someone manages to notice, then you have a clear path to fix it
> *right*: fix the ptdesc data structure to represent high-order allocation=
s.

