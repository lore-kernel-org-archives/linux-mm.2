Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899F6CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF856B00A7; Fri, 22 May 2026 13:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5426B6B00AF; Fri, 22 May 2026 13:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456CD6B00B0; Fri, 22 May 2026 13:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 335586B00A7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:22:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E135B9225E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:23 +0000 (UTC)
X-FDA: 84795724566.01.19D3CA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 511591C000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=koyRjviy;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779470542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Myvcdmsl6/fVRzdXvlKB28a4tjZpVUNPg3c8cwRTRc4=;
	b=KA8HsvZpMJxrpDYL6S5RwXwEr3QVcRhnv1NOHi5er5ZV1n2RY22017SWXxKrlve9rbTcKf
	+Zur8U6Ai3/F4T0bANWyE4Glns7x9VM1dcvmx9nYjggYlJ0a9DJqu6KwLNcEGVehTHqN2K
	I+sX3Cue5cZuLlrP86qS32jDJ5mm3lc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=koyRjviy;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779470542; a=rsa-sha256;
	cv=none;
	b=z1wN0NATMU/yN63Cz8KxTZtZ/OOAgHh2rMmTDfZVoxWtQDRYsjDZr6YqAaBRGD2VYQ5dvf
	+PeoN3MOv+O9YAG6cH2YVlwsT+o2gPSNfcCkYTME7hJo0/e4gM/woRtFicJEcF5TNqUGBg
	AgaNsE1ZFF3BAyoGLpxfVbvUGNvSPVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ACD6F60218;
	Fri, 22 May 2026 17:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB681F00A3D;
	Fri, 22 May 2026 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779470541;
	bh=Myvcdmsl6/fVRzdXvlKB28a4tjZpVUNPg3c8cwRTRc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koyRjviy4q6sfifYODHDnPc65g8b+eojaCyZHhTg5Ealb/7ff1Zc/oU4ADJH398VU
	 4TKBt6TDzByn8jMibaau/poX7yGuTwHpL9zjQSGXHiDb9X8+PZUxGbZoGWA8MrvJml
	 MlGFKtmw8/TP0Fywdg0cb4oGppiZKrbXtufXBaFd6zOSQqDra52zbQHDUDIgsFq4Ls
	 t/6cpQAfOEOQCAYNuERyJPpiR/AUaatocDVr94Nw9/k7ISDd/7i4xLW24YIEI7BOKH
	 oL9pavpNyjmXnvIJ7BXg3psUbFkFFsdvbn/+StHApkXcCwKgxxtj5I1yZRb8v9sGka
	 q2y8MQd2JUZRg==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] mm: Add ptep_try_set() for lockless empty-slot installs
Date: Fri, 22 May 2026 07:22:12 -1000
Message-ID: <20260522172219.1423324-2-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522172219.1423324-1-tj@kernel.org>
References: <20260522172219.1423324-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 511591C000E
X-Stat-Signature: iptaqwrskt61kgrpn338j7kehssyzuuo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779470542-436680
X-HE-Meta: U2FsdGVkX1/ugeccNrMlF7e440hJanPqKlmzaZaCYozlhIMimQm8nl90BxADs74sUkS/dgWYgO8XSNvxLqjB6Br45PWUFvZY9gftie5hbebylddS3euXSibfQBMm7qbxfQ4hKzu+XK3NJOTmzMghGR4ZUDaEak2016tIZ+BIgaNhFhqgtFrXFg+vc9HDYtDxhMbB+YFSraENrjKNQg3PnHtDEI1oJep1/6O2SqQhfxak81imBoN1mDO/HEozKWh1wG0NlYbrxNqJfHVMBPK0jOtP+iRJ/tZOxrsrF/95asBdfn5RD+wf9swV8nuQVkGddGC2k3vxJQOxhdeDtanZPUJimk2TL/eDdZEKbB9s/g/mtQEd4aWGdltVddYuVI0Xdpyob2fGPC9g5eImKPainaI72gEv2Hqdirh5SWFYi0d5179IwgJAQosPzRd+t3IJZTiSP3cTyjIOznVjiEuNxEos4ON8VyV/6JWRMh3BNd9BFnhFP5PE+3QD++Z3+LD3SzsAd9K5zAoQI67GhmDFHqq1musz5U6TQPUfUQsNkj8al1FVvxJSYifWt0zsm6cPic6S1iezlJX1/q1K/To7rlav/84AUywj4cKNNoAocSbuhGTq04TPYrvHj8xrDCT828V7dTCJ9BlY7gymZbpcmlG1gHIzRLvC2WXNtUiDy/XQD4H/7NSRCIP9/NK+U4lmM5Yrolv9kpbo9yYerB3zO8oyEf0kD00WL6XZ8l5H+2OYCBAt9B0mDuSbfj/iEk2HoHBD7tNcYyd+6+7XBurF7v/jAg3GCrulicR5HGYK+1KcK/NGrFJ5uN9Gsd7t4kT2ifGPE8UDSGAPDeAgx+paOt4F7BgKxGffn/LyQv9Y4QZbF01WbQvDxdO1ks3neZdmIO0f4EKjWxrXomuoMIK/FwkTBEIW9DRmjKIqyaieWYxuwpEINdpmBtvQ8dMbafp6NOOKCWIW5xzMmTh2lAl
 7+5WQc+c
 QAcGPZZapdoPZC2HuUPeKMs+D1V5ekmZl0+q6XBvGcKGGyKgaTN6Ey84M8j5hy9YU3rtXt7ekRZbyocf1qIUZe/jEM8r12nL2GUbCF9KheZzPygFBuwNiXYCBWHkBeq+WMggT8kfMKkBn6bTI1sCDTmuYtMH9sEehlonkkv5S1Yk+IxYvqKgCGx8eNbDLjkAQNnsaAqAgYUT/7B1Mk+zTz2LfqGXQlp6yBw+21IwXsMSDcEE3/BtGkBbkUT1etrEKL62dDh86mVgqvle8Vo1hh4WN88eoDKS9Iqye0efgrlRGJqN4Me/v7DP3SfoHJLefbatVksiMyNo1AUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ptep_try_set(ptep, new_pte): atomically set *ptep to new_pte iff it is
currently pte_none(). Returns true on success, false if the slot was already
populated or the arch has no implementation.

The intended caller is the upcoming bpf_arena kernel-side fault recovery
path. The install runs from a page fault that can be nested under locks
held by the faulting kernel caller (e.g. a BPF program holding
raw_res_spin_lock_irqsave on its arena's spinlock), so trylock-and-retry
would A-A deadlock. Lock-free cmpxchg is the only viable option, which
constrains this helper to special kernel page tables where concurrent
writers cooperate via atomic accessors.

The generic version in <linux/pgtable.h> returns false. x86 and arm64
override with try_cmpxchg-based implementations on the underlying pteval.
Other architectures get the false stub - the callers there already fall
through to oops.

v2: Rename to ptep_try_set(). Tighten kerneldoc. (David, Alexei)
v3: Note that strict-zero cmpxchg is narrower than pte_none(). (Andrea)

Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
 arch/x86/include/asm/pgtable.h   | 12 ++++++++++++
 include/linux/pgtable.h          | 25 +++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 9029b81ccbe8..28bada97d443 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1830,6 +1830,18 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	return __ptep_get_and_clear(mm, addr, ptep);
 }
 
+/*
+ * Note: strictly-zero compare is narrower than pte_none(), but the gap is
+ * harmless: a fresh kernel PTE has no software bits set.
+ */
+static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
+{
+	pteval_t old = 0;
+
+	return try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte));
+}
+#define ptep_try_set ptep_try_set
+
 #define test_and_clear_young_ptes test_and_clear_young_ptes
 static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 13e3e9a054cb..15a5da68f180 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1284,6 +1284,18 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	} while (!try_cmpxchg((long *)&ptep->pte, (long *)&old_pte, *(long *)&new_pte));
 }
 
+/*
+ * Note: strictly-zero compare is narrower than pte_none(), but the gap is
+ * harmless: _PAGE_DIRTY and _PAGE_ACCESSED aren't set on untouched kernel PTEs.
+ */
+static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
+{
+	pte_t old_pte = __pte(0);
+
+	return try_cmpxchg((long *)&ptep->pte, (long *)&old_pte, *(long *)&new_pte);
+}
+#define ptep_try_set ptep_try_set
+
 #define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
 
 #define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..b5739bb99fc1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1036,6 +1036,31 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 }
 #endif
 
+#ifndef ptep_try_set
+/**
+ * ptep_try_set - atomically set an empty kernel PTE
+ * @ptep: page table entry
+ * @new_pte: value to install
+ *
+ * Atomically set *@ptep to @new_pte iff *@ptep is pte_none(). Return true on
+ * success, false if the slot was already populated or the arch has no
+ * implementation.
+ *
+ * For special kernel page tables only - never user page tables. The caller must
+ * prevent concurrent teardown of @ptep and must accept that other writers may
+ * race. Concurrent clearers must use ptep_get_and_clear() so racing accesses
+ * agree on the outcome.
+ *
+ * Architectures opt in by providing a cmpxchg-based override and defining
+ * ptep_try_set as an identity macro. The generic stub returns false, which is
+ * correct for callers that fall through to oops on failure.
+ */
+static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
+{
+	return false;
+}
+#endif
+
 #ifndef wrprotect_ptes
 /**
  * wrprotect_ptes - Write-protect PTEs that map consecutive pages of the same
-- 
2.54.0


