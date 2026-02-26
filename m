Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8667DFD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF4C6B019F; Thu, 26 Feb 2026 16:01:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6736B01A8; Thu, 26 Feb 2026 16:01:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5DA6B020D; Thu, 26 Feb 2026 16:01:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 789C06B019F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:01:38 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB9AA1B6D94
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:01:37 +0000 (UTC)
X-FDA: 84487829034.23.194F71D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 24B4840016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:01:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dW46b5y9;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772139695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmxX/qYJNas+Kj/SszP9KMGgHjwU+T3IF8YxcVK/CRk=;
	b=XqJePfPXXTsF9Hyn8tS/AamMq9sQFDDrub2y0AFidl+4ljZb+k6JCN3ikw3Hfzpmco0Y8a
	zWXzEGB0em54kho5aCJknOQ47Avfcfp6gUpSki3tiZDIxDxDb9VQ/Sg1HZqu88JB2r6Ibx
	BdKPcqol8vaw5VmEIvImRtnEOeqyZNE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dW46b5y9;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772139695; a=rsa-sha256;
	cv=none;
	b=0dLtfG+If54G3q13MKuYYG2gRQ4NqJ/t1Bj/U0vU9DnCrqLGheTkD6BJwStm7J6lHlq+Op
	wUcS8OEOzRjGdP0e2UyzcT8r5LCPwrQcWPcZyH1vPZDIo7+Zs3YG9LPsbMWQiUJrYh9eVR
	FypnbNLRBJ/EKp2TMo3nxWnYfOX1so8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772139693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmxX/qYJNas+Kj/SszP9KMGgHjwU+T3IF8YxcVK/CRk=;
	b=dW46b5y9Zh6JRARSRmzDoCZenWOXUpOYGYQCTEsrtaLdJjFc4g1vGh146ousg+exwMmM0w
	78yke2E/+8DCuKcjjdeYSi+KCjoLAcxwuAh3y7kmZJqRdTm2H++dJdj2hobncAVCa7Q9FM
	HXWYXi0uJ25jjdlj8RpgsCnC9mZQh8w=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-9KoVBBsRNbaLJ3QMul-BRg-1; Thu, 26 Feb 2026 16:01:31 -0500
X-MC-Unique: 9KoVBBsRNbaLJ3QMul-BRg-1
X-Mimecast-MFC-AGG-ID: 9KoVBBsRNbaLJ3QMul-BRg_1772139691
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-64cad8f8d03so2434218d50.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:01:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772139691; x=1772744491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bmxX/qYJNas+Kj/SszP9KMGgHjwU+T3IF8YxcVK/CRk=;
        b=os/RldRyRcfbF5tBYyzwX6NorYCPxBiGHb4FCDubBW2k1ebe6QS6QGhHpJD9Prjdym
         xAPD9ttMcoWlJnVbVacpILNdda4Za2048Puiskl8sNyUxUHmxX5yQcyzkzrrIeYh3V/S
         hWVwzFADuVDidFLHYmX2PVjpd6xmmbC5joWHt4ZvjPYif7VO6WYB+ikdHTWEdsHLaBUy
         vWFkbuqUiXGadpseTjb8NrB4OLoi7fu8bWeGS7H0hcepE8cPOWNdydGAzBqg4ap7NyGU
         Sbg2deoNgL2Pl6NL1F2twTlGl0E8zfgp6sV/77mjwK2E4mhFgHizybjKd75S5Z/C2MsP
         I3uw==
X-Forwarded-Encrypted: i=1; AJvYcCUeBJNBJ+ph2yVjO2vwGXr+Lg7vA4W1Ls4btZ1zt3g44tU/GQdcyUIXXR2XPRsBb1JKXUcSHXvF1A==@kvack.org
X-Gm-Message-State: AOJu0YxVkx6e5Llqb+To8hTQ21kEEPWjFXtJXbcXHlXNETlL6S+omTQb
	qzpNG5WI6+Jq9FbFIZpAvrGlhRssfKySa8eG0OtvIFcBdSnffS0Cb3dzgsAB1e+hNCZKyQ7cKWH
	QUFfrQnlfc15+t1f64X7spy320OU3s2paS6Aujh8ltiGQnpbv7sBPvO9NYyHfp8XBzWIb3Lw9EQ
	D+3Ch5SF+nR622OfJ3/j41OmYi3Lw=
X-Gm-Gg: ATEYQzytxQPw+LdUOmjqxQWRkxsnR2w2APxD6tbOHA/lKd/nTmkcrM7gLAZlNpVPNof
	SbKwAzmmccdsKgl5MImI5zdoIT8GjNJCiM5oroI8ek6ZFBDexkWpIx2NRtECSR10owT7OVCXhFo
	Gr5CSII0qLl+9In2GD20N4OpCjLE/Ic+1ucqZ1MJ4uQO3Xm4F5h3kpTMtEaH7WLvK9oCf44WDsB
	1Ja
X-Received: by 2002:a05:690e:bc6:b0:649:4f58:5cd2 with SMTP id 956f58d0204a3-64cb6e0c928mr3154531d50.0.1772139691060;
        Thu, 26 Feb 2026 13:01:31 -0800 (PST)
X-Received: by 2002:a05:690e:bc6:b0:649:4f58:5cd2 with SMTP id
 956f58d0204a3-64cb6e0c928mr3154488d50.0.1772139690404; Thu, 26 Feb 2026
 13:01:30 -0800 (PST)
MIME-Version: 1.0
References: <20260226113233.3987674-1-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Thu, 26 Feb 2026 14:01:04 -0700
X-Gm-Features: AaiRm5209LV06f3Unt5ipFy-rNSZmlqNghFDY0XoCRoPEuuBfLMWoAzmF-tTAXE
Message-ID: <CAA1CXcAYt3OfW_uBTYZgr-dBhg99x=5pUs5uvqtpg+PNJ1KxGQ@mail.gmail.com>
Subject: Re: [RFC v2 00/21] mm: thp: lazy PTE page table allocation at PMD split
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, lorenzo.stoakes@oracle.com, 
	willy@infradead.org, linux-mm@kvack.org, fvdl@google.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, linux-s390@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d7EfJO1oMt0B_ipaXyytEBbqSvyQP1P89T5xhBuI05k_1772139691
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 24B4840016
X-Stat-Signature: 74sapbip4k5npsw9edg4toxpyn1tsb9c
X-HE-Tag: 1772139693-728530
X-HE-Meta: U2FsdGVkX195P/nwrrVjhUYbiG/7zUQxIWOYI4kRJygC4UA3im6+KePGw1GbwsDRQ8p2v25UeqF6avFtgnkiyksW/ahc9VYJweMfgF45vhz8SB2IXJya1HIHQa7eMPTSk+Jisa3jl24fzHyVzwSgjPkpnjtnnGJiYhv1K/dqkVCDpdj4ZrAKY2BKnujUFF+EZlrbxcwSyTTjV6yYhWBiHTFTzuEvcRcBHGJ+rVJDzUjlF9ZIzYWQyrGFIzZu77Ei0of79WmVNEcbFFdGZiBnDnoESTp0X664ONTSv1t7C3wlFdcuA35ULhzgH3sTAUdZ14u+lGWSbWPhzPKgMKcCYP8rMYMgzb8HeSh+TiB4P7zlIW9pYSqlQbcFCBogsCieoKlIeiPArcgSH+LMn4RZH5OuqjWHP+JCC4cQBn4WeAOFa3SgXBITUMJo528nGcA6mY0o1vnMQgpP0zgo5eJ7+0AKUuhTt8IeEG1cxrAo3kJXuhPAReJIBVNkdY8fpqsOnQHNMg6YLbA2Z//iOX5xLx2kvfKHy0fIZR0R+lqFNvulw7szi0Xk3rzFU/ZULTx2i1S+wRgcu1An3AUG6pb3ozAEY03IBmnzvTTHC4dTCsC5y5jPXNzUeOeELN0GaYkWoA8F4ae2bkV1pqnzGHunEcW+BHYZJMvu+YQ2vuTmDzHKPpMZjdPYVtaZpUkc2PO9eD7nYZFXnUHv72xySPVvf/HBBILze9boaHFJnpypku6vRow5XNfqK7zn5zTIQx4TPtBFN0ea2ciAkqEY4YqGh9iYvkJ7RaxbBeI8R/iQ2ARmf2/Xr1EIS21oP9qNweRYquQIZvkDLhDMHn1LS3hwKm2EptyYSeWT+MUi27NY3q82C3DZsCSJMCuQfQwCvVpAKfLI3GOrlS/z0nbHnvlwlvF/fZ2Pq6UVU+jlz66aVeIAzfKb7feXfMtEGrX1e8ReS182ibHc5lSOWcUxpDB
 s6ExRjnD
 3regLz8Uc+JxB93EI3UN1RJPC48X4LLFQz3kZuiYO4/FOJqhkw2jzQnYpC2iqQ/VupMtUTKTCqJTfKsXn0Fppg//74lHndMLLv3Mkr22TUaFsTD/e9+Vp9VRJMefNgkJJCq80yWWhY3Ve6vrFGbpW6L+b2TZXOJr0U/CKw5WxYHs5pojCgbsNtm2WJ8H5aDpPwSQV2sdWN8+OCMcPuiGXbDCwx+YwjHj+qX/X0CpChrjutCd7RP8U6n74XYdmoepaiMcMV/qc4XkrSWR+DzR/5cGfCRwPOn6kIi7h9VkV8FGPZJDdSkOMQkVqeGN2j/dRIVgSG0N5DRSWjOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 4:33=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> When the kernel creates a PMD-level THP mapping for anonymous pages, it
> pre-allocates a PTE page table via pgtable_trans_huge_deposit(). This
> page table sits unused in a deposit list for the lifetime of the THP
> mapping, only to be withdrawn when the PMD is split or zapped. Every
> anonymous THP therefore wastes 4KB of memory unconditionally. On large
> servers where hundreds of gigabytes of memory are mapped as THPs, this
> adds up: roughly 200MB wasted per 100GB of THP memory. This memory
> could otherwise satisfy other allocations, including the very PTE page
> table allocations needed when splits eventually occur.
>
> This series removes the pre-deposit and allocates the PTE page table
> lazily =E2=80=94 only when a PMD split actually happens. Since a large nu=
mber
> of THPs are never split (they are zapped wholesale when processes exit or
> munmap the full range), the allocation is avoided entirely in the common
> case.
>
> The pre-deposit pattern exists because split_huge_pmd was designed as an
> operation that must never fail: if the kernel decides to split, it needs
> a PTE page table, so one is deposited in advance. But "must never fail"
> is an unnecessarily strong requirement. A PMD split is typically triggere=
d
> by a partial operation on a sub-PMD range =E2=80=94 partial munmap, parti=
al
> mprotect, partial mremap and so on.
> Most of these operations already have well-defined error handling for
> allocation failures (e.g., -ENOMEM, VM_FAULT_OOM). Allowing split to
> fail and propagating the error through these existing paths is the natura=
l
> thing to do. Furthermore, split failing requires an order-0 allocation fo=
r
> a page table to fail, which is extremely unlikely.
>
> Designing functions like split_huge_pmd as operations that cannot fail
> has a subtle but real cost to code quality. It forces a pre-allocation
> pattern - every THP creation path must deposit a page table, and every
> split or zap path must withdraw one, creating a hidden coupling between
> widely separated code paths.
>
> This also serves as a code cleanup. On every architecture except powerpc
> with hash MMU, the deposit/withdraw machinery becomes dead code. The
> series removes the generic implementations in pgtable-generic.c and the
> s390/sparc overrides, replacing them with no-op stubs guarded by
> arch_needs_pgtable_deposit(), which evaluates to false at compile time
> on all non-powerpc architectures.

Hi Usama,

Thanks for tackling this, it seems like an interesting problem. Im
trying to get more into reviewing, so bare with me I may have some
stupid comments or questions. Where I can really help out is with
testing. I will build this for all RH-supported architectures and run
some automated test suites and performance metrics. I'll report back
if I spot anything.

Cheers!
-- Nico

>
> The series is structured as follows:
>
> Patches 1-2:    Error infrastructure =E2=80=94 make split functions retur=
n int
>                 and propagate errors from vma_adjust_trans_huge()
>                 through __split_vma, vma_shrink, and commit_merge.
>
> Patches 3-12:   Handle split failure at every call site =E2=80=94 copy_hu=
ge_pmd,
>                 do_huge_pmd_wp_page, zap_pmd_range, wp_huge_pmd,
>                 change_pmd_range (mprotect), follow_pmd_mask (GUP),
>                 walk_pmd_range (pagewalk), move_page_tables (mremap),
>                 move_pages (userfaultfd), and device migration.
>                 The code will become affective in Patch 14 when split
>                 functions start returning -ENOMEM.
>
> Patch 13:       Add __must_check to __split_huge_pmd(), split_huge_pmd()
>                 and split_huge_pmd_address() so the compiler warns on
>                 unchecked return values.
>
> Patch 14:       The actual change =E2=80=94 allocate PTE page tables lazi=
ly at
>                 split time instead of pre-depositing at THP creation.
>                 This is when split functions will actually start returnin=
g
>                 -ENOMEM.
>
> Patch 15:       Remove the now-dead deposit/withdraw code on
>                 non-powerpc architectures.
>
> Patch 16:       Add THP_SPLIT_PMD_FAILED vmstat counter for monitoring
>                 split failures.
>
> Patches 17-21:  Selftests covering partial munmap, mprotect, mlock,
>                 mremap, and MADV_DONTNEED on THPs to exercise the
>                 split paths.
>
> The error handling patches are placed before the lazy allocation patch so
> that every call site is already prepared to handle split failures before
> the failure mode is introduced. This makes each patch independently safe
> to apply and bisect through.
>
> The patches were tested with CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_DEBUG_V=
M
> enabled. The test results are below:
>
> TAP version 13
> 1..5
> # Starting 5 tests from 1 test cases.
> #  RUN           thp_pmd_split.partial_munmap ...
> # thp_pmd_split_test.c:60:partial_munmap:thp_split_pmd: 0 -> 1
> # thp_pmd_split_test.c:62:partial_munmap:thp_split_pmd_failed: 0 -> 0
> #            OK  thp_pmd_split.partial_munmap
> ok 1 thp_pmd_split.partial_munmap
> #  RUN           thp_pmd_split.partial_mprotect ...
> # thp_pmd_split_test.c:60:partial_mprotect:thp_split_pmd: 1 -> 2
> # thp_pmd_split_test.c:62:partial_mprotect:thp_split_pmd_failed: 0 -> 0
> #            OK  thp_pmd_split.partial_mprotect
> ok 2 thp_pmd_split.partial_mprotect
> #  RUN           thp_pmd_split.partial_mlock ...
> # thp_pmd_split_test.c:60:partial_mlock:thp_split_pmd: 2 -> 3
> # thp_pmd_split_test.c:62:partial_mlock:thp_split_pmd_failed: 0 -> 0
> #            OK  thp_pmd_split.partial_mlock
> ok 3 thp_pmd_split.partial_mlock
> #  RUN           thp_pmd_split.partial_mremap ...
> # thp_pmd_split_test.c:60:partial_mremap:thp_split_pmd: 3 -> 4
> # thp_pmd_split_test.c:62:partial_mremap:thp_split_pmd_failed: 0 -> 0
> #            OK  thp_pmd_split.partial_mremap
> ok 4 thp_pmd_split.partial_mremap
> #  RUN           thp_pmd_split.partial_madv_dontneed ...
> # thp_pmd_split_test.c:60:partial_madv_dontneed:thp_split_pmd: 4 -> 5
> # thp_pmd_split_test.c:62:partial_madv_dontneed:thp_split_pmd_failed: 0 -=
> 0
> #            OK  thp_pmd_split.partial_madv_dontneed
> ok 5 thp_pmd_split.partial_madv_dontneed
> # PASSED: 5 / 5 tests passed.
> # Totals: pass:5 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> The patches are based off of 957a3fab8811b455420128ea5f41c51fd23eb6c7 fro=
m
> mm-unstable as of 25 Feb (7.0.0-rc1).
>
>
> RFC v1 -> v2: https://lore.kernel.org/all/20260211125507.4175026-1-usama.=
arif@linux.dev/
> - Change counter name to THP_SPLIT_PMD_FAILED (David)
> - remove pgtable_trans_huge_{deposit/withdraw} when not needed and
>   make them arch specific (David)
> - make split functions return error code and have callers handle them
>   (David and Kiryl)
> - Add test cases for splitting
>
> Usama Arif (21):
>   mm: thp: make split_huge_pmd functions return int for error
>     propagation
>   mm: thp: propagate split failure from vma_adjust_trans_huge()
>   mm: thp: handle split failure in copy_huge_pmd()
>   mm: thp: handle split failure in do_huge_pmd_wp_page()
>   mm: thp: handle split failure in zap_pmd_range()
>   mm: thp: handle split failure in wp_huge_pmd()
>   mm: thp: retry on split failure in change_pmd_range()
>   mm: thp: handle split failure in follow_pmd_mask()
>   mm: handle walk_page_range() failure from THP split
>   mm: thp: handle split failure in mremap move_page_tables()
>   mm: thp: handle split failure in userfaultfd move_pages()
>   mm: thp: handle split failure in device migration
>   mm: huge_mm: Make sure all split_huge_pmd calls are checked
>   mm: thp: allocate PTE page tables lazily at split time
>   mm: thp: remove pgtable_trans_huge_{deposit/withdraw} when not needed
>   mm: thp: add THP_SPLIT_PMD_FAILED counter
>   selftests/mm: add THP PMD split test infrastructure
>   selftests/mm: add partial_mprotect test for change_pmd_range
>   selftests/mm: add partial_mlock test
>   selftests/mm: add partial_mremap test for move_page_tables
>   selftests/mm: add madv_dontneed_partial test
>
>  arch/powerpc/include/asm/book3s/64/pgtable.h  |  12 +-
>  arch/s390/include/asm/pgtable.h               |   6 -
>  arch/s390/mm/pgtable.c                        |  41 ---
>  arch/sparc/include/asm/pgtable_64.h           |   6 -
>  arch/sparc/mm/tlb.c                           |  36 ---
>  include/linux/huge_mm.h                       |  51 +--
>  include/linux/pgtable.h                       |  16 +-
>  include/linux/vm_event_item.h                 |   1 +
>  mm/debug_vm_pgtable.c                         |   4 +-
>  mm/gup.c                                      |  10 +-
>  mm/huge_memory.c                              | 208 +++++++++----
>  mm/khugepaged.c                               |   7 +-
>  mm/memory.c                                   |  26 +-
>  mm/migrate_device.c                           |  33 +-
>  mm/mprotect.c                                 |  11 +-
>  mm/mremap.c                                   |   8 +-
>  mm/pagewalk.c                                 |   8 +-
>  mm/pgtable-generic.c                          |  32 --
>  mm/rmap.c                                     |  42 ++-
>  mm/userfaultfd.c                              |   8 +-
>  mm/vma.c                                      |  37 ++-
>  mm/vmstat.c                                   |   1 +
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../testing/selftests/mm/thp_pmd_split_test.c | 290 ++++++++++++++++++
>  tools/testing/vma/include/stubs.h             |   9 +-
>  25 files changed, 645 insertions(+), 259 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/thp_pmd_split_test.c
>
> --
> 2.47.3
>


