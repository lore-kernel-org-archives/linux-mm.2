Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016D2606A33F
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QVSQsGrN
Received: by kanga.kvack.org (Postfix)
	id E90FF6B05B4; Sun,  1 Nov 2026 12:04:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E411B6B05B5; Sun,  1 Nov 2026 12:04:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09486B05B6; Sun,  1 Nov 2026 12:04:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9584B6B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:04:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F505C0AC0
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:04:57 +0000 (UTC)
X-FDA: 85387175034.18.74236D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0F1D3A0003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:04:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVSQsGrN;
	spf=pass (imf15.hostedemail.com: domain of devnull+vrilutza.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+vrilutza.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793552695;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6ZhjtEGoIXYajBUtxBWTOChkOo/ZSi2InW/pWlQIKSo=;
	b=mn3OI+7FnkcbK8kSHOEdtpHWOE4mjJGbmEeoF0Q6QOtM0LWHNHj3BkFB7G8Y0CCDjRs/L5
	vEll6GRoNNbAWZDvcz1vVZaBXxALt5vlwdouTLpHHvFAFVhdGd+SQacT0PVfH9haHT55Kk
	VHEPymCQbA3O09tW421tjrb3Q+JFeZM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793552695;
	b=jNqO2ZLSN+RaRHxBKNLrK4un1BooHZNHA1jSsa+zmi7qZXlLYNs99EMZKQMaYfIhjEI/+a
	2qZL5Nr/3jTt/AzyKbK0hrGeKBA76nDkmfoUxmPyiNeCughHTJiB6VuWLowMktEPvhjDtK
	WS/m/DDjxApvDnYnKJj/aSRxSwH9wug=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVSQsGrN;
	spf=pass (imf15.hostedemail.com: domain of devnull+vrilutza.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+vrilutza.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9325960052;
	Sun,  1 Nov 2026 17:04:54 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793552694;
	b=rVfBmOhOupH6jF2EvJZWbDIs237Ru4q7O0UDATYK+t9EGk9n9tKmV3KtRZlNFyjQ1cbj
	 15VLd9c2mmEZrOs4ociSU89cG/6iLCQ7ty2oyYs8mNBOExgvlVgoI1kmVX+FuXv3yYzln
	 KBHjgc3enqJnIRNGwndv1q2VxTZvJBkYJlZ//RBXXbbpt4gmALnwjA6EfpN0znoDADT9v
	 PbZL1rEVSHNsaCUwKWAc+zZeKt0Ckv0SuTBrTBy/p/vTnrRyD+hZEln/gkmVlNoqeSJNI
	 5tXGLvC2uIVf60gaJP4bs/wL2u/FfkwQkMuk/9iyrIWhrFDGsBz/qmi+cN6hg6+ypnA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793552694;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=6ZhjtEGoIXYajBUtxBWTOChkOo/ZSi2InW/pWlQIKSo=;
	b=BzhdjxU2JsMC5nYhku9+3u6jOa8u0EP5NlsTtXuZ22VndSDDMD4vMzy/HNeoHEOmC7Sf
	 N4Ty7a+gYVAYatLqOFV12/PXWIrAMcpnGh7+OKKl2zTsUkAlfwWP5O6ihpK3wKzvWDXUM
	 qIRmScJ6W/xnxnLxDkICihTWKatRynGSAB01JaNbaNnlQZJ6ZoddlAngbt8HtPKnSfWK1
	 lSwKxgvrKMfD0gkRDy/XXIo3hrz+nW7bm9TowA7w7W3lT2GQfJO9mJePMyG2aDjCRnjyc
	 e2mXb6SBS1qLeH/2DBSJ135aexexcQ3czza8T/y3JpmpIf0KyaZM9jZjepLLECgSCHw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9CF031F000C1;
	Sun,  1 Nov 2026 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793552694;
	bh=6ZhjtEGoIXYajBUtxBWTOChkOo/ZSi2InW/pWlQIKSo=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=QVSQsGrNCtJXqcbIhhCWw6UEOCLVTwgs9/s0cslmMr8i5e6dMZhci/aXJHcWYi15P
	 GnLO8fQi/qvc5Ox/Lb73WXPS1d0hFbX73vCFzBTuj9zyIBR4Bm4NJlm/R9F2Ib16Pr
	 LkzGqtLTzgAiXYlyraOsMC70xCbXVkTfZjqQ8ZHroHQO+XiamzZ3x38ZEeZ0xKKKY4
	 f5xwqqv0M3IYLtdRAHytNgEPjWWMwf59Ju3fTna9NkLlLpuP2I4Dxhxqmg4kobOfLj
	 33diIx+T3VoMu+zCbSamo7PuX7M4J2fIpZ4tiLAhwllAm0ebKUDxo368AUTwH51wAo
	 Ren/Lp8Dwn2rg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id ECC1846203;
	Sun,  1 Nov 2026 17:04:52 +0000 (UTC)
From: Viorel Cernateanu via B4 Relay <devnull+vrilutza.gmail.com@kernel.org>
Subject: [PATCH v2 0/4] x86/kmsan: Fix two bugs in the metadata lookup
Date: Sun, 01 Nov 2026 19:04:35 +0200
Message-Id: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22OwQ6CMAyGX4XsbE03EhRPvofh0I0CUxlkw0Ulv
 LsMrh6/9v+/dhaBveUgLtksPEcb7OBWUIdMmI5cy2DrlYVCVUjEAh59IAdbCzjPEVHLsjQs1sb
 oubHvzXardg4vfWczJUVKaAoM2pMzXRrtGk1fgqjSvrNhGvxneyfK5Pl/OUpAwFND5wK5yWu+t
 j3Z59EMvaiWZfkBwydlCdgAAAA=
X-Change-ID: 20261006-kmsan-serie-e33000b199ce
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Alexander Potapenko <glider@google.com>, 
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Ilya Leoshkevich <iii@linux.ibm.com>, 
 Viorel Cernateanu <vrilutza@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793552692; l=3024;
 i=vrilutza@gmail.com; s=lenovo-20261005; h=from:subject:message-id;
 bh=70IlPx1AKJ8+cqwvWRwobdqND9Oht8b+HJuyYoNKqmg=;
 b=FdDO8TSJQ+sj2UKnZMnNeYqMDmWCZVcKj/oNKlP7ur1VuKC10ya7OWVdZ7KEcPuzmH5QOLV9D
 REcYDbXZA/nDm+/qM0rMMa8PViACooI+H01bEDMiM1InW/oheZrWwAo
X-Developer-Key: i=vrilutza@gmail.com; a=ed25519;
 pk=HttZd2ffphVYTK/pvlflateaij8E4SdPd6Y+xDQMqDU=
X-Endpoint-Received: by B4 Relay for vrilutza@gmail.com/lenovo-20261005
 with auth_id=1115
X-Original-From: Viorel Cernateanu <vrilutza@gmail.com>
Reply-To: vrilutza@gmail.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F1D3A0003
X-Stat-Signature: jmz8osfukz8cw9aur9c59wznfnfndaux
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793552694-267208
X-HE-Meta: U2FsdGVkX1+IK5Usv0hOFryV8alwysZP9fWSNU5Gg/jtpNCJqr2Dp5jzWw+HT9tof3cDo/D/7Xz+0nYiwirlyGnogxINdy6dIH3qASAwCM7MTdhCaZvaYiZ+wsjAFu8skkN/1OnyGxEJtFbqWAqllUDZK27hMr33GhMGBST8lXd2J7aUfmhfz/E95SIgkJF3LWtvfNWRHJMzMq+Bf6X4aA3jNyE9KTydf5mcKPJKTrSUYDur1rL166pRq/2FXgeeubtDdCgz+9pBVbQZycFoPU9zjavDU4A4Jvzm79VQKONXMwdFgHHcm8X2oINPbpA57gliWJVK85Hu6U1kKvpP4tP9dPE1fv4fdX021vxgU9NRcfCPMVJdXR4YzIjT37lyOo/kthfbcye78JwcYjNZPiK+w3p4eDUTl+Fx9SJd1xW1p66h6D1bNckycVTRc4uJKS07sWOYstGkmb15s/sxZYXheu9iiQ7NhNO+BgeUJ+63sQARHm/ASIPP1mTidPKk7C4XLXFBYXD23bYm9DQap9WCqanwWyPoBPpfKkD4nkyeXGi8Y0Cuh5J9jdvD/jKpDXLtZRhItjETAJ38VW2LBc9ikDGewvkAur4CnSoaW2Pm7teoN77ILGKcdDwxdaYev+UWL7/WvcfmoPO3um9lOFQjfmDvivFs/EZCZhLMcQ9CVyi0eAw7BuRbl36pjp5RnhOcxjvyRQ/FhKYLEmU+qg101Qf+A/fpiwHDhC0hPt0a+8UBYDijn8uiBrWHDnxCYsfEUJbV0Cr6ov2aH+4Pg1UccRVgGFFl6CWKyA55ch6yQ3NF2ZZCha+9Ur2gxR/hh/DBcrZFIGilGwDM163yFI00XBEtj4y2ZsADcq6xkFTG5YQRfsJhVc+H1WgFzCNo5aqlFE5Z5dPVfYLwONF825HhlCC9QaFN2ZiwtdsDdtuWxehe+UxApOlwykKXHL1YeZBQHVEHOyvZ3OEiD66
 psqbJhfT
 Ak/vl2+whN2PwEgdAHkiQ0L/GePI5SmQy01xFeT0FvBxigEMbNL5YKdDrUlC/TaVLw+wNP7sMepLc2Am8O6TEEOcUz2SKND+NSosvSWpS1MzbZTv4uiQdeUmVAECJ7IwYa7pLEUC0Gg2iAy95JxKGF4uQ2Aa3kozgPNBY46ss0E7c3a10qtCFBJ7hEfJwIO4GBepyVS/qWYZZzq5LIxs0zKG8RvCeN0jcemqOC3DE0XSCUEtWk7ghw00mebBKL1+yVk7NiCQeWIbveiApuPoSf+2I6xvQ5cGJkBbEuFkJvbMM81A6is5UdKLVtPw1P2mH8Mg9Ru+/utLDEm57KGAQeaySRP/Gd0hn1SXVb47MgM0/z+LFsQdkBZ9PcYvXhVnqRc/nLU1KGpBUBOiqyJnXwQMMa050IBGsPshcXCO6s4ngRLllLdxolIVrJcy1+Q6Yi46TzT8L8vRfJ61MBq2ii3sDXSZAnoc8PgQVxQc3T6dNBWbT/NdnvtHgtTYA58z0Bcti8gTwviie0Ov+pua4iIpbC2k3fKOimlOt16Z+ZuZNoOCtBosOL4I8hbqzYFyb9B7RKbSLqnXUH0OXYdAea/Bpjr1BUFbK+O62XJsW+FevtZjzd2uE6KAduIHXXrA6xeCci7Tn6btf8Yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Two fixes for the KMSAN metadata lookup on x86, found while running
KMSAN kernels with KASLR and with CONFIG_DEBUG_PREEMPT.

Patches 1 and 2 fix the CPU lookup for addresses in the CPU entry area.
With KASLR, the lookup treats a randomized slot as a CPU number. With
the areas in CPU order, it still attributes the last page of each CPU's
area to the next CPU.

Patches 3 and 4 fix a recursion with CONFIG_DEBUG_PREEMPT: the metadata
lookup ends up in the instrumented preempt_count_add(), and the kernel
hangs right after KMSAN is enabled. Patch 3 factors __pfn_valid() out
of pfn_valid() so that patch 4 can use it.

I tested the cumulative series with the v1 configurations, against the
same unpatched base:

- QEMU reproduces the GDT lookup failure and the metadata boundary
  failures on the base. The corresponding tests pass with v2, including
  the metadata tests with and without KASLR.
- With CONFIG_DEBUG_PREEMPT, the base hangs immediately after KMSAN
  starts. The candidate completes all six boots, three with KASLR and
  three without.
- On an Ivy Bridge laptop, the candidate boots with KASLR using a
  minimal init, and the GDT and metadata tests pass on all four CPUs.
- An x86_64_defconfig build without KMSAN boots to init.

I have not tested CONFIG_DEBUG_LOCK_ALLOC or measured the performance
difference.

s390's kmsan_virt_addr_valid() also calls preempt_disable() and reaches
pfn_valid() through virt_addr_valid(). This series does not change the
s390 code, but patch 3 refactors the generic pfn_valid() used on that
path. With an s390 defconfig plus KMSAN and CONFIG_DEBUG_PREEMPT, I
only compiled mm/kmsan/, arch/s390/mm/ and a few mm objects that use
pfn_valid(), with no warnings before or after the series. With
CONFIG_DEBUG_PREEMPT, the s390 metadata lookup still calls
preempt_count_add(). I have not built a full s390 kernel or run it.

---
Changes in v2:
- Keep the CPU entry areas in CPU order with KMSAN instead of searching
  all possible CPUs on each lookup (Alexander, Peter).
- Move the one-page offset fix into its own patch.
- Factor __pfn_valid() out of pfn_valid() instead of adding a KMSAN
  copy of it (Alexander).
- Rebase onto current mainline.
- Link to v1: https://patch.msgid.link/20261006-kmsan-serie-v1-0-07fa860ef3de@gmail.com

---
Viorel Cernateanu (4):
      x86/mm: Don't randomize the CPU entry area with KMSAN
      x86/kmsan: Use the per-CPU area base for metadata lookup
      mm: Factor __pfn_valid() out of pfn_valid()
      x86/kmsan: Don't call instrumented code from kmsan_virt_addr_valid()

 arch/x86/include/asm/kmsan.h | 31 +++++++++++++++++++------------
 arch/x86/mm/cpu_entry_area.c |  6 +++++-
 include/linux/mmzone.h       | 42 +++++++++++++++++++++++++-----------------
 3 files changed, 49 insertions(+), 30 deletions(-)
---
base-commit: cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a
change-id: 20261006-kmsan-serie-e33000b199ce

Best regards,
--  
Viorel Cernateanu <vrilutza@gmail.com>



