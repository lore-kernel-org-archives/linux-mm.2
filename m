Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473FBCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53526B009E; Thu, 11 Jun 2026 07:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B716B009F; Thu, 11 Jun 2026 07:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9684C6B00A1; Thu, 11 Jun 2026 07:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87FD36B009E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:51:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AFF2C1E45
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:51:07 +0000 (UTC)
X-FDA: 84867465774.05.A933CC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 51E2C1C0008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:51:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HkSTzLLK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781178665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtJFXmmapZ+SVQ7jqSbbDH4KUUFmDq6LRQqzvI2w5vA=;
	b=LaA7qp/P/CPdnSyeByZTfBO+PcRpu0Lfk27oHCjunIr2mgPspr3EBcMvxpBpp6+RdsWBgj
	r3gv5VO1YQE1L5QKRHiklNmZ9g8LyHj85bPTYbciB3v/TixUVPFa7zuiAoBBwHcgPbeyxj
	t9j2d2647hi7P0b/zH4bWZxVY0ZyplU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HkSTzLLK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781178665;
	b=xGebrqZoaK0gTPfu2sQs0hOliCv2gUr/z+Kergr8/682KWQD6Ib1k0xd47wuDPzdn8qJXb
	2zjaWUbE0uEM1XNMZv4EuCwUhLAUOSC/immnIoorDIicCK4SvtjaoOh6ScNhA7X3dCUDzK
	jIqSRYbe8hQqRtwqeOwFCQtLzE2jttU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 512A14376F;
	Thu, 11 Jun 2026 11:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C351F00893;
	Thu, 11 Jun 2026 11:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781178664;
	bh=MtJFXmmapZ+SVQ7jqSbbDH4KUUFmDq6LRQqzvI2w5vA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HkSTzLLK2j0OdL+U0vq+q46ivBKJymR1NSUBYntk2QPWjBZaz2WMihOeeYuHWgbd7
	 iPrR2cVJEMpcL0QfVE/2t+nIZB9zpocQvFF1u1ihuiCncwyeLs2jyWcEYExUHtarDZ
	 jZow1Y75zPoS/kAZjZ9xrwzgfAl5XXqxpxp3PI8It7Fl5bCTOIEMVPIZP8cMBdkzgB
	 ac0iTJ7t1c6CITZn97AhViBGLbv1OswAKx8BSu/m46QkFlA+xR3NCsbXxyB2hvd53e
	 XP+4e2VQ+wZ4Q7K/C6YibH2hPskIlKp5/w79fNxZWZJASUOo5fKZURM6jJBSBFNfmX
	 6vJBtYsSKX8dQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 11 Jun 2026 13:50:47 +0200
Subject: [PATCH 1/3] sparc/mm: drop custom pte_clear_not_present_full()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-clear_not_present_full_ptes-v1-1-49865fc82629@kernel.org>
References: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
In-Reply-To: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Peter Zijlstra <peterz@infradead.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51E2C1C0008
X-Stat-Signature: dxsg1mxugriwh1qfnkhwp8wsu4o764i6
X-HE-Tag: 1781178665-39755
X-HE-Meta: U2FsdGVkX19J5XxP9yEHzfRJOP0aWn1uUDCiSL/NFyX4KzaAPbJ8fBr4Z79z9nOdAXaP23B4K/Q1VvFLCbCheSTY9x1T6B7yD75b1BWVWv0wU1TT+KThzYgJ6PCbCk/pMmClJOhbrREmZW+3fxOQDNO6Z8POCnXFZMjocevcQo46xslQ9foaPhLzA3b9Pg29EV0tYghtsi9Zak6TreCj4uU5+K/FqFEvs4WUSa9Chgn+Y0BWVUKKZG1NmQMO+JQ6X18iZJaJTQXk/WZh2EZIis3t97wKnIvcNu/EqAsnEbh31p15KBc/AnQPaMoiOwxIUQiLb2PQDxiI29xglnWW+xrHg1Ld1vzPKsBUKNzz1G008nKcl6vHmQANFA55SGJp4f7mgUm0MWICdhQ906TmKRo6xgOSqqlYzFIX/9e+48oO0SgbYLyqonDrK98U0oH7DZC6MgKRM/C44Q4uuxjsy9Syt2JTxDZsfh7l54FGCqLmrENEOmIH2Ybk5j2VPnTp7H9ZH8GNwysORGWhEmHMoiLAe1FF3CmRUrK5HyMarhKK0/MKUcwxpeGG3tEjfCEbyIPB7SNJPyb15m+gbskgwe8H4rO+wiqU1grkx9qFtcWLVuNJrZmKWr0B9xK12Ya3Swn63bIY3dFryQnn80qcC/6gjkQIpIXH0RC7/7P8g/t3JCSbpoWjrIIwMjWu1BTgF9st/WbRZQvaVLQsIe7ytoz2cV+KrdSUNgUIcWMtfHB3CHSVAKD1LNM95oq2CFDehNrKWUBIh1cGHKhqfouOF4G5+GWqWWF2EnOquadOPN7Bs5VWy+46DFlpj6bL8f03oAu3LgGQbDDIMiy5dXz5X+tVKvll/9OFoyn+slM8RDhCdv7NCUcHfYeCO1uiMi3TDGqIGVDyB4esmsI/DQNTOVPR4DNEbZGXYjfy0gYU5uCR66Uk5RL2nEIUs5Hpgrn0Qdi58RC08ot7FZBXb1g
 ytK/wE3X
 Itr+1SAqOvsFkKAbtuNd4yiuNYrGwY8Ws6B3rEA7HHsOJDQU26FlU69miswFKNMkGle87TQPcfVWCzGoI8H1/rtWV0SQ6ygjw3DyFUo2jc8JJV8zs15w8Re1ikTxO87x47F6hRFx5rlmtgHrNmDj6IVFwWOHThaGGjpaiQKvgCX6XDtMRTcKMEe+iQ5Fw5ASPPl0P0i20pwd+uG7xnBVa+ULixWEUHair1hst5Exsr5vb4VCcL84YaIPccMoiBPUMpxWyHxpCA7lsgB0ttDyceP8X6MIU4bY0PsYWkDAyIh6AVRE7SfQKUznaUoDllMGHxdW9fUnq0RFR/O9qOWXn6oOK5xdOJn0tvOAe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On sparc64, pte_clear_not_present_full() nowadays does a simple
__set_pte_at(). In __set_pte_at() -> maybe_tlb_batch_add(), we check
pte_accessible() to see whether to call tlb_batch_add().

However, non-present PTEs are surely not accessible, so tlb_batch_add()
is never called and the "full" parameter is irrelevant.

Let's drop the helper and just let common code do a pte_clear().

pte_clear() on sparc64 maps to set_pte_at()->set_ptes()->__set_pte_at()
... so it ends up calling the same function, just with "full=0".

Given that "full" is irrelevant, there is no change.

We added pte_clear_not_present_full() for sparc64 in commit 90f08e399d05
("sparc: mmu_gather rework"), and I suspect that it was already not
required back then.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/sparc/include/asm/pgtable_64.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 74ede706fb32..0837ebbc5dce 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -945,10 +945,6 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 #define pte_clear(mm,addr,ptep)		\
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
-#define __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-#define pte_clear_not_present_full(mm,addr,ptep,fullmm)	\
-	__set_pte_at((mm), (addr), (ptep), __pte(0UL), (fullmm))
-
 #ifdef DCACHE_ALIASING_POSSIBLE
 #define __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, old_addr, new_addr)				\

-- 
2.43.0


