Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB960C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919126B00B6; Tue,  4 Aug 2026 09:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0466B00C3; Tue,  4 Aug 2026 09:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFAC6B00C5; Tue,  4 Aug 2026 09:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58B5C6B00B6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:42:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 857B11C004D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:25:03 +0000 (UTC)
X-FDA: 85063506486.05.F4EAC5E
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id E43C5A0012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:24:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JWV861Dj;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785846301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYIregcr03N44MbWJoOkT1SXD/oGHjFBDvMTLqTGyZQ=;
	b=CP1h8E5M6cZ3n9zpFtB4qMgobQDQB8Mld7mFUwpLjz9IToeARzQ0FzLfOK5qeO5bFFq4gf
	1n+7DhLmvklqaAq1lLT9eoXrfVCDN1vCa9KwDtLB7zX6Hczlc+TLzRsNHK2Qs2h9lNkdGx
	suzKV0F/aULUK2DgnxiUUjbwzc7RJFY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785846301;
	b=ZXjuovIMLhXA84gjAG7kN/SZh7LukqeMwCvWE4rDma5SX4mfhI1vx0cZDY73Wv99MXnr6+
	QuQ7B0SOXM/YpB1uYa5G5JN1FFySKTRxp3MkjxOKBjVzoZU/3ogk3ZemQs6nR6QZSTBW4n
	EDOTwGhUDk0by2yknUJKtFaXaz6HfyU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JWV861Dj;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-458de93b53fso1920647fac.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 05:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785846297; cv=none;
        d=google.com; s=arc-20260327;
        b=OJ17J+EyQyGcrorjN1nn4yFo154nDwAIBUeweYFOxPNxRAQ71wJUchN1qpSnPQlHkZ
         W6ubRbwEy1io58gfeqjzdvvHZXVIIiWMY1sPWN2A5qAdwrzbVY9NESVHTZaFHh96mXdy
         2Oa5VVgadbeZQNjApSKnYQw6IDnbzoHNomDu6HLNrqMdcLrVqeMjx9zl47pAS25vFjB4
         WEjaT4/yYNpWjT4HOpVkJy819cy452ceIZ78gM+KvnbgysVLT/yqbDRdD/Ml4qgg/ild
         zZ+fOWgFZ90yFE1nnlza3/W6xSQMNoJy8K4uQJUCH4CHdkRJDG4AbygAfaJjZSIjEvTH
         gDEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lYIregcr03N44MbWJoOkT1SXD/oGHjFBDvMTLqTGyZQ=;
        fh=rSjHmOn0dEgRHb0o/GdhkCZnnWDp7G4ikhIE+1ab9Os=;
        b=pzh4ZUUNdJ9EpVNt9fL4fNwmRg1XY6GFAGLUkEYAY8tEwh9cr5BNp6nog9yLSwxG31
         gk16q0yHhAyHOiWOig5Vt4TEUXrzGVaPOb+jTiJjXu90S43UI9NogaIUAd2ODohf75P1
         AyKomwSRHkmOjDPqeincovuTXNyoZRv7/lty3jh5Pbx5oQGJiwO6qNGp2uqtd6I9waF6
         TOlv3ocjzxAyEzQuUGLdjukaBu80YBG5kNgOp84+0vpAGIrjVrGFsP/jiLAlxiBfaGUE
         GX0REnZd6ETdHw+8fthOOlh2RMp66q4pbkslJiWnCCcAOMBSwYzs3PM/YId/c/gsOTlh
         3F/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785846297; x=1786451097; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lYIregcr03N44MbWJoOkT1SXD/oGHjFBDvMTLqTGyZQ=;
        b=JWV861Dj/1vziR4c50RUWtz0MEs0wD7PoQ1Tu0I/ADAgtEIEEfP49g+UsxZCjrmwih
         rAgMRWHEizYXi9BnP0jYwTyvfJs3zKM9XVXxn2TINqFr4qnq+orNWvFICNaawwKNdGip
         kIEbk5ItBXL6TdIn4NvbeCw+Q2nrwM9Y4hVBD5pBHnWokjTmijHAStlRzrhwQvRWl/og
         98+LQZttbb5+2cr4fmnP9YjRe20y0ZRSWqLV98C+TydlDC9xRKgJJQTKWAFrqTe2eJ9e
         pWFVtp6SF6TysGZz6AGQ3fTSjfg4+lqky/lgF5uLMGZiS/wdtGUZfe/PNlgySUSdnQDq
         2NIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785846297; x=1786451097;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lYIregcr03N44MbWJoOkT1SXD/oGHjFBDvMTLqTGyZQ=;
        b=TmEX4hPmzRmOn2P7Pm6LfyEldvmn/MGgE1S5LLHduhfNcIZshTis6eMjbiKQlawmFg
         OSuXsPyOCbZ6UwYRhG8jMv4hfSWEjkyu/t/qq2PCmFUh0deMuWI6CI23KZJBTDIXykQ+
         nLfghyXCWXPO6nuxYhFoZpHT8X8iWWJokd6EW/opLeygsMhFJ7C/YxbMPZTSDniAvyfP
         5TUnhxJswPFjxJ8BnH7PN5GgIp6ccLzqcOjyXH0YPT2TO5znH3wdbw3AX8P7Nl6F47x0
         I9Yb477nYpkrpvQoXO3Ol20i06snk/hrf9moPvGHS/Bx93lNhGIb1EoKv4GBYxrbfqvJ
         RdPg==
X-Forwarded-Encrypted: i=1; AHgh+Rp+qUm/j+1jEUVh4e2Ws1W2LMDdghyZJR/ezflHB89+yxaFvpImF48uXx3IxCHXn+oNxovzNwfSDA==@kvack.org
X-Gm-Message-State: AOJu0YwH/p9Ty7eNCSZMMNxWTp2Sg9VMgOE7ZFPhyYzVbBeQs8BA7E21
	/zGF2g5pdEBQuAUte+3c1CPF/w2X6aOa3HNT85ww2rswqHbonpXS8R9UVnv1Ea8HpEE2ur1Jm+T
	n8JWuAnej3btbONtrJ5KtqERCsAZSesY9pfCYDVK1eg==
X-Gm-Gg: AR+sD13+O/xYgEMp3UrrSzcwscF2pe5NcGkjpf7Y3wbAYOQ9pOPSR9jurHk1rRUlNNy
	NnVxvxQJO3Z0HLWV/70LIwahqdelOliPnuAkE8oFGvFvvmHSoAvSQYy8+HbnodfhQWPRgrGo6v6
	IbecBqkIGATwRpB4EWxb4DKFjExLdqEHHIJIzb1Dpz63+kL/HDF32ZswVLazwE9mR/WbLpFOyKg
	fR9Tx0Y2gfFWYEG27fQ5KtFJlNpwpV5SU+VO8u0k9pk/L4ayLTDPvq+qGUsHzbSpWHN64vFUd7h
	zWt9zVoZmUvTE8yqB7m9MHFah9hPPyxVfShpBl5dd8a/Zl1V30oq2ynYQ6w=
X-Received: by 2002:a05:6870:1767:b0:448:bde8:7ec5 with SMTP id
 586e51a60fabf-459058b6c3fmr21257000fac.4.1785846296097; Tue, 04 Aug 2026
 05:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <aZcmlIF4bmG0twkp@thinkstation> <afTjKnO66Hl-XmfW@thinkstation>
In-Reply-To: <afTjKnO66Hl-XmfW@thinkstation>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Tue, 4 Aug 2026 20:24:44 +0800
X-Gm-Features: AUfX_mwWX86Kwf4cqtMoIk-fk-IbxBfbRKWjpeMPS5Iwwk0cK1Y0I6-9idaHW2U
Message-ID: <CAEEQ3wmam=maXfXL+oyw=h4UsQ4hkd0gG1MytnuG0zV1_LdWcw@mail.gmail.com>
Subject: Re: [External] Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: et9jh337onzot3s7dbpiqrewgazjnz9r
X-Rspamd-Queue-Id: E43C5A0012
X-HE-Tag: 1785846299-674335
X-HE-Meta: U2FsdGVkX18T4HXorkK7xFIafLd/bILLXRbFED2BEY46OKKMZYGNeZR2Tygi57Dv2s2CFWTogSl1TBjDqtlwErj+BWbCjiOGFd17f2Vq3r+nau+W2RIGbzy1pFkTUwKTCzEAzDhkdhhNeUOichAZV+2/dt1wcHRs3qgx7mcWPssG/Gqt3lgsTtWAEhvQc3NzxlIo/YvXjqYruLCSH3LlCB+AI/++4aI854XPKP+OwtkYaMl2Q5qRsDUtY79KO2wDvubi1BrFK4aCYURUZtTZF2dABVmGuCsq0esfi0kc6YGV+UxCO6i2nRDL6uQv8DBIAen+JCFSOVHLHw7xxNLrEIIqq9YaOX/E4rNXW68Fl5YtXSY7VbnSaEIaKlhJNxmRxyby96YbSOHE5ySbc0FqJ/+z3qPa6F2Ib8W28oL1uy28UUPPVABGuFIvJC12MzBrBN3uZty0JOwanogwGF9OnjWw0ijjek42+9GPiiXXNP3GzUdSonpMWCEzNIEI7RddIlGsUisnnKQ9NL0s1qaL0XWFdCbLOnOlqKZAgEFAph12tdbzhNrPBg2iBE2x9XUR58aX/zmhVybnz9qyvle3fNEMLHhLqxSl9S3rno91NZseFATrHyWvkKGQRRjcawxZAtosAKkllGq3FUfEfdwU/XNQ0w12iw5JLm92XwANyT2kQe4t9cerxQ3XeHP7kyhr+PZvZeyKDp4bzGgmaLlBT7gcuKaFZrzLjLE52cNd5SJsWpkQkaqTt+h6ThQIFKMJvdjlVQDEo1t2kMQlPFj9zCmt7rJKKx0l3lBXEATxCz+knGU5/0aT2xJAEEIQna6wm2Eupc0yImmiq4a2BKhWD+R7uEvSrqYn9KKbncNyp8sFAqkoYAz4Lyt4z9MbWto5axZt0uBk15gAxe9JcTSJwP0tmmGNHPEYshXp5eBu6iRLSgofNymHcGe/xFLbqdwdQ5auLX1+SHu9gyBVsOK
 NPQ5+Htg
 cFv/OZc6oe0hS2sjdQ7V287ye7kGTRHw+7QnIqM8ZK4lTkt05aoSkYPoG/Br+ovSLcTUFs9GOzIljtdsxN6AoGREJttW33Obp5WGRAd5JoslxCn2Q3+tP0FL+Zv43zj0qxmT0GCe5eGZHJ6zthL8Wy4/M5oAajRPtxecvF8f6WP0qG0I7Cq7Dj681PiirbJ90ZByH4jJM08oHJgOGPSJLVm4MoErcB0QUlF7RITfEUsxRI4wZTVqMVvrv85bLueLZraHvqZJrkTtAhVQYi7kBvHC1S8deCXFDHWRQkFCjacgOep7GEY0ujZaDsGRzB697c+6fL12Vemyjc1/isb0bHWpidWbLcuVClCLlEp4rTMTd9AdTln8PBd/R1/t1+GyMfUDcYoS0q1iGJYN0HqkRYKFN1zUivDybDi1DtHypN+BR9ra7vmhe0Ab3UOsXoVv4zYUg/2uXcG8jalLQ4TpFuFv2rfYTfLlpZihbJ6tMDpfp5Bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,


On Sat, May 2, 2026 at 2:01=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> wro=
te:
>
> On Thu, Feb 19, 2026 at 03:08:58PM +0000, Kiryl Shutsemau wrote:
> > =3D=3D Status =3D=3D
> >
> > I have a POC implementation on top of v6.17:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git pte_size
>
> Just a heads up.
>
> I've updated the tree. It is on top of v7.0 now.

  Thank you for proposing the PG_SIZE/PTE_SIZE split (PGCL) and for
  sharing the implementation:

    https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/log/?h=3D=
pte_size

  Based on the pte_size branch, I developed a RISC-V PoC and used it for
  this evaluation on a RISC-V server. The branch includes the RISC-V
  adaptation, Svnapot PTE folding, split-PG correctness fixes and
  regression tests:

    https://github.com/cuiyunhui/linux/commits/pgcl_riscv

  The complete benchmark results, methodology, run-to-run variation,
  UnixBench subtests, fio results and investigation details are available
  here:

    https://github.com/cuiyunhui/linux/blob/pgcl_riscv/Documentation/mm/pgc=
l-riscv-evaluation.rst

  The RISC-V Svnapot PTE-folding implementation was also posted separately:

    https://lore.kernel.org/all/cover.1784201104.git.cuiyunhui@bytedance.co=
m/

  For this evaluation, PGCL means:

    PG_SIZE  =3D 64 KiB
    PTE_SIZE =3D 4 KiB

  A 64 KiB allocator page is represented by sixteen 4 KiB PTEs. When the
  virtual address, physical layout and PTE attributes satisfy the folding
  requirements, these PTEs can form a 64 KiB Svnapot translation.

  I compared three configurations on the same RISC-V server:

    A. Conventional 4 KiB kernel
    B. 64 KiB PG_SIZE / 4 KiB PTE_SIZE (PGCL) + Svnapot PTE folding
    C. 4 KiB base pages + 64 KiB anonymous mTHP + the same PTE folding

  Both B and C use the same PTE-folding implementation. The main
  difference is whether 64 KiB is the kernel allocator-page granularity
  or a best-effort anonymous mTHP size.

  The same userspace binaries, CPU placement and datasets were used.
  No cpufreq driver was active during these measurements.

  PTE-folding benefit
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  I first isolated the effect of PTE folding by comparing PGCL with
  Svnapot disabled and enabled.

  For lat_mem_rd, DTLB miss/access decreased from 7.202% to 0.910%, while
  access latency decreased from 35.633 ns to 30.145 ns, a 15.40%
  improvement.

  For SPEC CPU2017 505.mcf_r, DTLB miss/access decreased from 6.062% to
  1.021%, while elapsed time decreased from 282.68 seconds to 273.61
  seconds, a 3.21% improvement.

  In the complete A/B/C comparison, PGCL and 64 KiB mTHP produced nearly
  identical DTLB results. Their lat_mem_rd DTLB miss/access ratios were
  0.9180% and 0.9200%, respectively, compared with 5.6768% for A. Their
  505.mcf_r ratios were 1.0189% and 1.0234%, compared with 6.0635% for A.

  Application benchmarks
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  Most Redis, MariaDB and small-response Nginx results remained within
  approximately 4% of the conventional 4 KiB kernel.

  The largest difference appeared in Nginx with large static responses.
  PGCL improved 64 KiB and 1 MiB response throughput by 18.33% and
  19.26%, while 64 KiB anonymous mTHP improved them by 0.70% and 0.67%.

  The Nginx test used a warmed page cache, sendfile and loopback TCP. Its
  large-response path includes page-cache, sendfile and TCP processing
  that anonymous mTHP does not change.

  A separate physical-NIC iPerf comparison showed a difference of a
  similar magnitude with one unidirectional stream, while the PGCL/mTHP
  difference became small with multiple concurrent streams.

  One possible contributor on a physical NIC path is page_pool allocation
  geometry. With a 64 KiB allocator page, an order-0 page_pool allocation
  naturally obtains one complete 64 KiB page. A 4 KiB kernel would require
  an explicit order-4 allocation to obtain the same physically contiguous
  size, which drivers may avoid because of fragmentation risk. This is an
  allocator and buffer-backing property, not Svnapot folding of the kernel
  linear map.

  UnixBench regression
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  The 16-CPU concurrent UnixBench system index was:

    A: 20265.5
    B: 14513.1 (-28.39%)
    C: 20186.3 (-0.39%)

  The PGCL loss was concentrated in Execl, Process Creation and Shell.
  Arithmetic, pipe throughput and ordinary system-call throughput remained
  close to A.

  One issue found during the investigation was that file-backed
  fault-around had been disabled when PTES_PER_PAGE > 1 as a correctness
  workaround for sub-PG mappings. I implemented PTE-granular file
  fault-around with mapping and file-size bounds.

  After the change, filemap_map_pages() increased from zero to 21.28 calls
  per exec, close to A at 21.66. filemap_fault() decreased from 123.03 to
  4.31 calls per exec, close to A at 3.10.

  The single-CPU UnixBench index improved by 2.38%, and single-CPU Execl
  throughput improved by 16.52%. However, the 16-CPU system index remained
  at 14588.2, compared with 14513.1 before the fix and 20265.5 for A.

  Restoring file-backed fault-around therefore fixes a real single-CPU
  issue but does not recover the 16-CPU regression. The concurrent Execl,
  Process Creation and Shell paths have another remaining bottleneck.

  Direct-I/O results
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  The final fio direct-read comparison used psync, direct=3D1, iodepth=3D1,
  numjobs=3D1 and three measured runs per workload.

  Random-read throughput was close to A. The remaining regression appeared
  in 64 KiB sequential reads:

    A: 3279.804 MiB/s
    B: 3036.649 MiB/s (-7.41%)
    C: 3049.891 MiB/s (-7.01%)

  An A/C kprobe comparison over 20,000 64 KiB I/Os showed that A performed
  20,000 batched fast-GUP operations. The tested C path instead performed
  320,000 PTE-granular page pins and 320,031 VMA lookups, corresponding to
  approximately sixteen operations per I/O.

  The tested code processes one PTE at a time to preserve the correct
  4 KiB sub-page offset. This is an implementation overhead rather than a
  fundamental limit of PGCL or mTHP. Possible optimizations include
  retaining batched fast-GUP when PG_SIZE =3D=3D PTE_SIZE and providing
  batched PTE-granular pinning that preserves sub-page offsets for split-PG
  configurations.

  Userspace ABI, PTE folding and TLB coverage
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  A foldable 64 KiB mapping requires at least:

    - a 64 KiB-aligned virtual address;
    - a 64 KiB-aligned and physically contiguous range;
    - sixteen PTEs with compatible permissions and attributes.

  These requirements apply to both data and instruction mappings and
  therefore affect both DTLB and iTLB coverage.

  Some processors, including AMD implementations with PTE Coalescing, can
  coalesce adjacent 4 KiB translations within the microarchitecture
  without an architectural encoding such as RISC-V Svnapot. Although the
  implementation details are architecture-specific, these mechanisms
  similarly depend on a suitably aligned virtual-address range and
  compatible adjacent translations.

  For instruction translations, the virtual-address layout of executable
  code is especially important because it determines whether code mappings
  can satisfy the alignment requirements and obtain iTLB benefits.

  PGCL currently exposes a 4 KiB userspace page size:

    getpagesize()         =3D 4096
    sysconf(_SC_PAGESIZE) =3D 4096
    AT_PAGESZ             =3D 4096

  This preserves the existing 4 KiB userspace ABI, but applications and
  runtimes using the reported page size for reservation, alignment,
  mapping and permission transitions are not informed that 64 KiB is the
  preferred folding granularity.

  This is relevant to JVM-based workloads such as Flink. The OpenJDK JVM
  uses the operating-system page size when reserving and aligning virtual
  memory, including executable JIT CodeCache mappings. A reported 64 KiB
  page size makes the runtime more likely to preserve 64 KiB alignment and
  obtain better iTLB coverage.

  Another example of userspace behavior that changes according to
  getpagesize() is discussed here:

    https://github.com/intel/lmbench/pull/55

  Should the operating-system ecosystem also provide an optional,
  end-to-end 64 KiB userspace environment?

  Such support would require coordination across the kernel userspace ABI,
  distribution build rules, toolchains, ELF binaries, shared libraries,
  loaders, memory allocators and language runtimes. In such an environment,
  getpagesize() and AT_PAGESZ would report 64 KiB, allowing userspace
  mappings and executable code to preserve the alignment needed for
  large-page mappings, PTE folding and potentially better DTLB and iTLB
  coverage.

  Crash and kdump tooling
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  PGCL may also require changes to crash, makedumpfile and related tooling,
  because allocator pages use a 64 KiB PG_SIZE while page-table translation
  uses a 4 KiB PTE_SIZE, but existing VMCOREINFO and tools may assume a
  single page size.

>
> I can boot my VM fully (not only to shell as before) on all three page
> size 4k, 16k and 64k. And it doesn't crash immediately.
>
> Page fault handler is the most challenging part of the design. I wanted
> to flash it out to RFC quality before the summit, but it is not there
> yet. But it started getting a shape.
>
> Volume of the code changes makes it hard to deal with the patchset:
>
>  1530 files changed, 12675 insertions(+), 8669 deletions(-)
>
> Most of it mechanical, but still.
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov
>

Thanks,
Yunhui

