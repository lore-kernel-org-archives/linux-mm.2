Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5FCE9D828
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 23:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9756B0088; Sun,  5 Apr 2026 19:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8AE76B0089; Sun,  5 Apr 2026 19:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79376B008A; Sun,  5 Apr 2026 19:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B23406B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:35:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FFE514016F
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 23:35:04 +0000 (UTC)
X-FDA: 84626110128.03.34A385A
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9181A140003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 23:35:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YvYjte0m;
	spf=pass (imf23.hostedemail.com: domain of hughd@google.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775432102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lzm3/9j9sm7zHb61fOGxB4CuuzgAL6dQcGBwWJvxxMk=;
	b=PnLzm7mMHytUSp+by++iFGPtXE2zM1ARhEclvKvXuu8rRKNSL645jbRDYt2SJzIfmzm31B
	PfQ/Ja3mNBmYk/VV3jIFDHx1yPYX58lzitlPmKfcb3AoKo7HXcfTsbAtq7xv791JWwWFzj
	xPKba+koEeMwOPSpfsRIA0CPpUpcPtY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YvYjte0m;
	spf=pass (imf23.hostedemail.com: domain of hughd@google.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775432102; a=rsa-sha256;
	cv=none;
	b=02YipmKbPEFV/aCGycviOUD5CpQSLD7K/Ogw/klmed4JSerHm4VuOIFWeUlTLgtoESzgF+
	CGXb0qTtDr828ZD51344CHp4wahjRsPNiD+n1VSnf8TxjzSceG/gUKcFOOR6fv/VXOIGtv
	8fXYCqOe33L4YEXyq8e1QFWSGBK8Ktw=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6501547d7edso3338142d50.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 16:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775432101; x=1776036901; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lzm3/9j9sm7zHb61fOGxB4CuuzgAL6dQcGBwWJvxxMk=;
        b=YvYjte0mHRoZt4yXUFBIWaFuqRJiLB9qbMa/tiM19By6JLLXHlDOL9Wv4mtlR9s/h2
         l1xi/w2yW6qCvKGwDUImI4DOm7DskiePlni2skUJJ9luGbqC+Fha8baxuqOgBOKjvQMD
         IEWHWRuhjt09Y4tef1ev6JKBScEMJyTPWeWgkH6sWCLQktOuycyHPqjjNfc0PYxkIpzv
         Lar1UfQOFUFk9hYNYVSaz4Nk2fJ3qHyt0I3z6ZAZxt9QCzSmdZTDfllyvDBLWjYPp0O3
         dwcBJWrSZdpA8HTrEOpJgcV6SIS9epuV9RSfbNo68Dn/nlgbX2oHAAy5Eo5KuPouWJtZ
         3/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775432101; x=1776036901;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lzm3/9j9sm7zHb61fOGxB4CuuzgAL6dQcGBwWJvxxMk=;
        b=tZlP7nHox5SSzqzYslOrEmLIZXDuqwZA8dle6Nc+ocHw8duj97LJC8igFT8A4qBela
         23EdTDWOQpv4DKnt4I9T3tOCOt6qQihCcQY6eiAP9T/XFsm636NVkACYFfLvgdl8+NII
         lAk3frwJ7CVl9GoK3cRathslKfLi8KIRIwU/mR3cviV0/lNAZX4cRLo8JFvs0MTV9Lc5
         q+9cbHG+19jLd3Co+UzDs0zhk5ygJ+qO9G1dPC7dA77QWTbsWQzdXfz/Lr/3C+m8Lrbx
         lkEDH+OPk8MEK9b1sJRoYuIOiPK66vS3CPQ1A/UMTT7bFRSrqvizebrWMoFtzID0eo1r
         V4Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWXpDqV/Aq/rm/buk7aggSEJ0ycAXfv19QTZqYZjzXpy5Q/uKII0UYqOm0R9/QNds/8hVgLdl1FKQ==@kvack.org
X-Gm-Message-State: AOJu0YwsoXqBakYXtxoP8RdIC+8vM7tQVi2T/Dd10WrfIgSASJBYdl4b
	hXfUFLFmYw8SiITCfxbW/p7XchZd2U/MIhtQyzHkWv/VjWExLjte7jB7w2+Cm56LAA==
X-Gm-Gg: AeBDieudW5nNjUOfv3+hmxSxpoHz05GqiQhqwPyYXUhLUMhuxRR4Ub/Cy7Zfy+gb+Jg
	VyWdkmNJgTcPXEMk8sP+5fmz7Wxr4/TFx9fqrAhkmQ3y0stPV1jOyDp466dqVwIBXWMM1B4mkOq
	NBJzLP0MiqehZNZkfCBeEmso5sff9579bf/Gr+5j1HKWrk4krvWjh/2TSQy45sw8AixK6aezVBp
	MoHvUhyAUnTHK/o9z/ggdIrGwx0VPrpe3DJAga3eQZkgCzZW6JljNfZlsPuvQAOKanPZ1S+PLZl
	P4W+JOkfpYnJtEEjvzzEQQ3cA+jxIedYLDwNUnGGN9F7q/A1LCaablQV1a5ondqwlm2KfWX3vFA
	S1Wrsrmu9KLAR19fgZjdubt59h0OIJjLNc/RP0R0dSK3pVjZl4HqYjeVHKdj2TCuBSaz4gVdqpJ
	e/qiC8o9dpm+KsUCwtrBsUxmlreGN4y077hohhccmpyzLvlvNYaij62BJ3UCR3+crSvKeWd4fZT
	uKOlRqsD+w=
X-Received: by 2002:a53:b009:0:b0:63e:2715:5ac6 with SMTP id 956f58d0204a3-65048828b7fmr7933343d50.35.1775432101086;
        Sun, 05 Apr 2026 16:35:01 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6503a83adc3sm5317274d50.5.2026.04.05.16.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 16:35:00 -0700 (PDT)
Date: Sun, 5 Apr 2026 16:34:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Usama Arif <usama.arif@linux.dev>
cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
    Lorenzo Stoakes <ljs@kernel.org>, willy@infradead.org, linux-mm@kvack.org, 
    fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com, 
    shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, 
    dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
    Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
    Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, 
    linux-kernel@vger.kernel.org, kernel-team@meta.com, maddy@linux.ibm.com, 
    mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, hca@linux.ibm.com, 
    gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, 
    svens@linux.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [v3 00/24] mm: thp: lazy PTE page table allocation at PMD split
 time
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
Message-ID: <6869b7f0-84e1-fb93-03f1-9442cdfe476b@google.com>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-802286629-1775432100=:17421"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9181A140003
X-Stat-Signature: syj3qdtg5k6dw1zetcjku3hae9jkq8qp
X-Rspamd-Server: rspam06
X-HE-Tag: 1775432102-583275
X-HE-Meta: U2FsdGVkX18udzzhHdWUYoo8d6HtGHfqZ7I1g7rTELjsJNHUYLBYYpOq569xgtVgRqTT0vwl4aq1wRntxUjtjsbBnujxq5+zwzYljZvicWgMSnamlHxwGrDfcUtozd0TqksbRvLh02UirFlroxe7nKvbTX1C3NQvZb9hjbshq4tuo8SrRq5PTW50p3QkTeA1Wo/fmWO3yLpXOLjWB0g6KEmlvPfthZoC68wQ7joxIhGj2LPCgFZHWmYRYnEvveNnE947BXO+7vB+WyFfqiAKhXaJnxN6rxwz9G96fZKMHnKuKFj5uZDbwKheQvYRwMcmvIeQfsNN/cXaGVvWnBdh2aH0oywj/ii/6jdH6bwLNYw4YC+F0LbcQLrYhEaKl7LmZc18c5+dh6eUuGyBO/WM0FWFfR2/5j5aWFMbsGpDjLstgMhS7oBHt+JAeAP+UhFYM6cK4dtsyR3TAFoZxY7TemLV4gLlsSBYbut6SppQm5VveD2eE9nlGijEwsZxBQyCkNeO4l1H6drd7HWDe+hpoKm/fJrzfyFEGKbqPkhqS+G+zHbylQVXHC3VFvAeXVD3eUcx/Nfdzs4+Wogdcr+6eOm0oAxyl9I/HvnxyIxBFv6EbDiM1pilikxZLgEVWKx0oaOrb+l0NNWT0ontAb5k0fVfGqs4gSTF5IWccsEII6WfmrDiAq+ZjMoDlR64N97Lky7oODA6HhDK69i1lod26dq7JSO/OQmHJ3cNE6vhIY7ANv76aI1HQamNGdIRG136jjri7uQ4p1qPUpLOItYTBLJpl0CEuU6VssiRR1gtz6ncdl+PencErpF0sxcdaSRf9t3Z7IfblW/SpI79G2PhzWqeXjbOe4xb5pdwgeS4+nfKQLhizVuWkcVlgqnTakSBHwfvKjNxNkAMRFVwyHnfYoCKyKTlsQzgveaFumq+BNiELyBRF6EzqD7FwGWq65Nj9Fmh99ZWR1FFPoSnKTm
 Qk9cqDHh
 tvbgO+3x7S8MPInZf2Vvwlij0RAQO+8+E45OYZ4kqc6wFG4R9i/Ld7vq70reNJvR/b3opHg3jAiNRV1Uovoa+ttWGdGzL/lMDaJrjP/BkdTdnNtyjf/W9FjNSsLumX6tQSnurT9AIovbSJaQcKMDOz4E9u4lqT0L0zXDRoEbjYQDbc/hPLwtIedArsNJoR0IlYfUGg2W0BoP7XFiG6V5ik+uOtBZndcyi3HoKLLq1uC8vHZ64Z2Eu6xpyVTeQIBsLkdYMhqU7pDx7lM3OwOzkS2HCcyVBf23QXDQw4AkpByqUTfWEH+gLIaHUsgKd3f483UCqflzlo+mTcCjOJyvzrfEoXSFxL1XmFzYAoFOlOcA5jHMRaDoygKkPKokqW0/6osp0z74TCVFIqoUbUjGKY/k9/51cmkEAKHR8Yeb5aZD+aW7ESj8M/vbnuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-802286629-1775432100=:17421
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 26 Mar 2026, Usama Arif wrote:

> When the kernel creates a PMD-level THP mapping for anonymous pages, it
> pre-allocates a PTE page table via pgtable_trans_huge_deposit(). This
> page table sits unused in a deposit list for the lifetime of the THP
> mapping, only to be withdrawn when the PMD is split or zapped. Every
> anonymous THP therefore wastes 4KB of memory unconditionally. On large
> servers where hundreds of gigabytes of memory are mapped as THPs, this
> adds up: roughly 200MB wasted per 100GB of THP memory. This memory
> could otherwise satisfy other allocations, including the very PTE page
> table allocations needed when splits eventually occur.
>=20
> This series removes the pre-deposit and allocates the PTE page table
> lazily =E2=80=94 only when a PMD split actually happens. Since a large nu=
mber
> of THPs are never split (they are zapped wholesale when processes exit or
> munmap the full range), the allocation is avoided entirely in the common
> case.
>=20
> The pre-deposit pattern exists because split_huge_pmd was designed as an
> operation that must never fail: if the kernel decides to split, it needs
> a PTE page table, so one is deposited in advance. But "must never fail"
> is an unnecessarily strong requirement. A PMD split is typically triggere=
d
> by a partial operation on a sub-PMD range =E2=80=94 partial munmap, parti=
al
> mprotect, COW on a pinned folio, GUP with FOLL_SPLIT_PMD, and similar.
> All of these operations already have well-defined error handling for
> allocation failures (e.g., -ENOMEM, VM_FAULT_OOM). Allowing split to
> fail and propagating the error through these existing paths is the natura=
l
> thing to do. Furthermore, if the system cannot satisfy a single order-0
> allocation for a page table, it is under extreme memory pressure and
> failing the operation is the correct response.
>=20
> Designing functions like split_huge_pmd as operations that cannot fail
> has a subtle but real cost to code quality. It forces a pre-allocation
> pattern - every THP creation path must deposit a page table, and every
> split or zap path must withdraw one, creating a hidden coupling between
> widely separated code paths.
>=20
> This also serves as a code cleanup. On every architecture except powerpc
> with hash MMU, the deposit/withdraw machinery becomes dead code. The
> series removes the generic implementations in pgtable-generic.c and the
> s390/sparc overrides, replacing them with no-op stubs guarded by
> arch_needs_pgtable_deposit(), which evaluates to false at compile time
> on all non-powerpc architectures.

I see no mention of the big problem,
which has stopped us all from trying this before.

Reclaim: the split_folio_to_list() in shrink_folio_list().

Imagine a process which has forked a thousand times, containing
anon THPs, which should now be swapped out and reclaimed.

To swap out one of those THPs, it will have to allocate a
thousand page tables, all with PF_MEMALLOC set (to give some
access to reserves, while preventing recursion into reclaim).

Elsewhere, we go to great lengths (e.g. mempools) to give
guaranteed access to the memory needed when freeing memory.
In the case of an anon THP, the guaranteed pool has been the
deposited page table. Now what?

And the worst is that when the 501st attempt to allocate a page
table fails, it has allocated and is using 500 pages from reserve,
without reaching the point of freeing any memory at all.

Maybe watermark boosting (I barely know whereof I speak) can help
a bit nowadays.  Has anything else changed to solve the problem?

What would help a lot would be the implementation of swap entries
at the PMD level.  Whether that would help enough, I'm sceptical:
I do think it's foolish to depend upon the availability of huge
contiguous swap extents, whatever the recent improvements there;
but it would at least be an arguable justification.

Shared page tables?  Generally I run away, but perhaps
manageable in this limited context (a store of not-present
swap entries, to be copied on fault).

Hugh
---1463770367-802286629-1775432100=:17421--

