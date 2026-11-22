Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CADB606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mS0RAK2i
Received: by kanga.kvack.org (Postfix)
	id 52C3F6B05BD; Sun, 22 Nov 2026 13:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5346B05BE; Sun, 22 Nov 2026 13:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5606B05BF; Sun, 22 Nov 2026 13:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 125B76B05BD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E90C120713
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:12 +0000 (UTC)
X-FDA: 85463632464.23.35EF364
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id B09EB2000F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mS0RAK2i;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3NTgDawoKCBI1Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3NTgDawoKCBI1Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373110;
	b=eg50eerD7MRjzy6g7zw7qCx8l3rX2GWZmmwftQSQ/+UiYN0TdEW058NYKKCgCsmVecAsui
	lt1ES+3erz/K27Chzh76mIh5AlXNGoaHib51jh6+0S3CtiTtp/j+5WK/JVySfC8yIPZ/cZ
	XuOvxCs+/xGHz7roIxlKKzgdMAhmmzQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjhtu2IQKTqTGBX17Faec5as53bYJgHEh739WAlPWGk=;
	b=cYgfm0RE/+pmfi00Eud14VrxGh/RFoUPjkqPsHs8YR3g87JOU3Hs4Gs1N8aohNWyOSj7qe
	eY9SR9+fSCMbm97H477OnUntxAmcKo0qwjb3u7R6WJSOQmad/9e5+hxlrBYL/V0smAotmm
	YKqm4K2/zisAFgqqUUSGw3f48gsYrgQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mS0RAK2i;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3NTgDawoKCBI1Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3NTgDawoKCBI1Bz6CyzB65y66y3w.u64305CF-442Dsu2.69y@flex--jthoughton.bounces.google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2f040c6e0ceso25115985ad.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373109; x=1795977909; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tjhtu2IQKTqTGBX17Faec5as53bYJgHEh739WAlPWGk=;
        b=mS0RAK2igqAugRIqoJlCoYXV89Smnem5HQSyuSKJHUIOmNY2O6bLxzk7DfKhcH6lls
         5b6JDGUfJJzCCYR7g+LOLhjhA3XZnqvjM00OhZo9rQPvgc+peuXIvM8VZGUlimR7UEln
         VWMFi3boVCpHMZskquzdYLw4Y5ofBpELEVPPxOiGOyP/GW9vKkCx/oEXgTnxEU5UThYy
         4uUJJkj2vaZOq20+QvhJlyiVrx9U+aay53l1uE7pJju+TQ2xjDjLAFQ1kKTLLsov5fJ8
         nvNOJNEcGQf509d1rdaVLhaONYmfgJo6O5KhOY70jCXgWTbm+Yx4qFTECMhm5YOAyvAC
         UYQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373109; x=1795977909;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tjhtu2IQKTqTGBX17Faec5as53bYJgHEh739WAlPWGk=;
        b=THmweO7iUAnl0O/RtI3Ng8R0nj0exvCC2I+FjnnmmBoVI0IMFIhbE7MphGi7Uy+Enj
         nXy7RUtoy2fkm7WRpF7mTekIugXoqE+rzfATGJce7C1fhuEiAiEdQAWjKEO3iq0Akok+
         irBMWMqKVRD9yOFEXjM0bk+1IN2cELewYgJ5tTI30aEmmbIkw7BmCZOseFCrUtHgM0YW
         //70YOhVBmwQIWoopKw4hZSk6aN05ngmufcL+tN5K3qZs3Ah5orIWUmM4j99zgfsz+DE
         oyDK7ZU1JnX2sSkxSz2KG2wjkApNi8Xxi9W6pJvfXaMg1AgVjjF0LUpNfrvK6T8riz8O
         eaAA==
X-Forwarded-Encrypted: i=1; AL+hErFen8njwumRpMEI6RlDVdLgaXpXNrOXwHLC/xF7syPlC7y/1A+Lu0Kbo/t0islUmGvM8PE54zfCcw==@kvack.org
X-Gm-Message-State: APuU4Z876e0mD6ltBlMYHdvBDrbBEbnjT+TO/WqX6B2aM9Xy6ND1Hu6K
	6mhdia32CZ/oHSxUmJ2TenI+cd5n013UbnMEINiFBAW7f5g7nQKCZMlf9hS2H2L9xRztqPmJeYR
	hqOPOvOCCzrtx8tY7uQ7gpg==
X-Received: from pjbmy10.prod.google.com ([2002:a17:90b:4c8a:b0:3b3:79f6:3f84])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2f8f:b0:3b3:ba43:54c3 with SMTP id 98e67ed59e1d1-3b41c942998mr7718358a91.33.1795373109239;
 Sun, 22 Nov 2026 10:45:09 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:44 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-11-jthoughton@google.com>
Subject: [PATCH v3 10/19] arm64: Implement try_update_vmemmap_pte using the AF trick
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B09EB2000F
X-Rspam-User:
X-Stat-Signature: jeefxdx7bhj19orz3mukhdaax4bumkyu
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795373110-169910
X-HE-Meta: U2FsdGVkX19brs/5JjeUoSSk5yk89uCtCqF4NnXRM75RJM37uFI+WJOxXLIk59cp3nFXqZc68bBpbaTnZmsztiYeFyZNEEF+Nw181k0NEujlFDJPKn2gQk4lxT9cc6YnKwL8G/uH5A6YBzd+Y3DljuiGb+iFWktO/xyDSPC6TJ+5lxX1puumACeppg97K+CrHIoujT07dKUF9Cxao5LkU2IXTEjvlQh2bMIRus33voDaxtjE9krfWM+3oPvORZXZdUc78lU27ozDhhcG0UNFyfllQgGSzWfYVa4UUjjQbMsqIJdhR5/lFloQ52fuOA25WR1xOHl8ToAUg8PCPIWQ71QjVrNyOMjthirtGR/uH6ssESY/Y7/3wl35HyNrSDYbQeYmaOMOhlUaRQAs5slPX+3yBah+IIX8eq2IAt6BvAo9ZVtiU5s9VTwV5OfgK4SJtyQRHkBPLoeOXpOwAIdLHsJDkghXoLTdaXGPbwOQD+HsM0k5VllLWo2h/xU6e8h09eIt/bJEZiFWfIR0MISOJGuOb0Ce91V9fyCkyBmvCo19bOhClVKyCOtZSRMJzF+fSmRouMcyXxirq5oTPdl0KYsbCWttPEcbfQJYqjVsp2d7jW3naOd1nerhzF9QrmkFdAyPMC1jIapUoLi4o0j3SCSQBhgQ2gXhaA4JMMGY5idt8oU9/qIBE+KtdZdEQ55L8mzWYkZUGs7ZkeO3carwfIdtoEirqFBB1+YQuJ4d3kB7kyejB65wFPc2eIULjVQ7ExuTlzK1fZd97w6fAu+5B6PXAViqA4mRkKvxeI4SWxz9fjZrMZM+pvEVatC1hH8WhAyrzhPIQTujq9JB+1PAKs0U+p49C0ZCUxTFkTyBPiZzqYCffzPMi33bsyk/MAFl12AiucQASCTRUoDMy6UefBUemQy6hk22FEqMitSTAandtWr5aMhvjCYP/cRze1Pec3+0QtNI8fRNACiKoQ2
 MD+b6ROa
 sFUOK8PJzNAZ4spdkkT/Lf3hKa2xUGO8Qxl//meWU0kUbfvSvdnxzy1fx4hqe0GNwOCsZNrhY4+7CuxRe6MGtITBXAWe7xzioDozwsn4l1KzQpxKmAtNL6uMq0MTBCsB1mVIQghhZViSpAC0spIO2bE3BrgEICfZ9pkbIdxwjXSINXgwumVe+ImOo04Hr6hgMB7jnBaKVZKlsDV5DcY/yCVDm1/KNGjkhie0OrxeXA/6XaIfz6527utLdMxM3SlNrag+18xSSHHEqbZswu5nMfSX1TZ8cAPwuoMlmYaTOVYVgjiPVsapxPo8V5XAW/zTaGv3bcBtJG/j+dWfO/tpHnUeLpJAP9CFZLaSeVu8XobFvHPoPTngT41TU5DV/csTaNywh1R0//yIKROrBcvyhkm7ypBlvi1xT9PwIkI31r94irgu/VrBIqkvPOpU47X/Lf4MqyNCZTrmKrN1Vry4LriDIX5v3j81HTblAxEd5NmuCgE7cmkAtrrZlQXAs7ppiYtfrTFvvM9qcPEGCncUvbqlpK1QHlZBpUERYL3gwRLtPmwtn5wUlfzwBnjGBsZyvq8Mpu65CFDx+VmBItOT+cosIwizcsxoqtSRUh7Q94XoCwlJP/4g8jeLQBLG4M9dIIOZXBHpnZ+NDCH9l4bX53TfB2Xg811d4SAKFFf795tCZzpWO5gp/oIBtqh83uDisqZ6d8gN/SAnKGfe/zuFfQji32XANjD05pPwcZwcc1EEnrHKkuoeh+K8xhfij8R4aGNa728JhhZHzWsESCFoLVbcftq0iFBX4KEMTXtvDOi50z0lD3XbisUQv6V10+6qk0uXj8KyB/j3kGiUl4khHJ7ZXhnRAumyxvr3P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_update_vmemmap_pte() must modify vmemmap PTEs without introducing a
time window where other CPUs on the system might fault.

Normally a break-before-make sequence is required to avoid conflicts
with cached translations. However, if we can guarantee that the existing
translation cannot be cached, a BBM sequence is not needed.

Translations with the AF unset may not be cached (see Arm ARM Rule
DWZCQ); the implementation of try_update_vmemmap_pte() on arm64 takes
advantage of this fact to replace a PTE without BBM and therefore
without leaving a window open where PE might fault on this translation.

Of course, if some CPUs on the system do not support HW AF management,
clearing the AF will introduce potential faults.
system_supports_bbm_through_af() will return false if any CPUs on the
system do not support HW AF.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/pgtable.h | 59 +++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4285b7e7a6a7..7421c0a048ff 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1249,14 +1249,24 @@ static inline void __pte_clear(struct mm_struct *mm,
 	__set_pte(ptep, __pte(0));
 }
 
-static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+/*
+ * Atomically clear the Accessed flag. Return the old value of the PTE.
+ */
+static inline pte_t __ptep_clear_young(pte_t *ptep)
 {
 	atomic64_t *pteval = (atomic64_t *)&pte_val(*ptep);
 	s64 af_mask = PTE_AF;
 
-	/* Atomically clear PTE_AF, checking that it was set before. */
-	return af_mask & atomic64_fetch_andnot_relaxed(af_mask, pteval);
+	/* Atomically clear PTE_AF. */
+	u64 oldval = atomic64_fetch_andnot_relaxed(af_mask, pteval);
+
+	return __pte(oldval);
+}
+
+static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
+{
+	return pte_young(__ptep_clear_young(ptep));
 }
 
 static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
@@ -1921,6 +1931,47 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
+static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
+					 const pte_t pte)
+{
+	const int max_attempts = 16;
+	int attempts = 0;
+	pte_t old_pte;
+
+	if (!system_supports_bbm_through_af())
+		return -EOPNOTSUPP;
+
+	/* This routine is only to be used for valid-to-valid transitions. */
+	if (WARN_ON_ONCE(!pte_valid(pte)))
+		return -EINVAL;
+
+	old_pte = __ptep_get(ptep);
+
+	do {
+		if (WARN_ON_ONCE(!pte_valid(old_pte)))
+			return -EINVAL;
+
+		/* We should never get a contiguous PTE here. */
+		if (WARN_ON_ONCE(pte_valid_cont(old_pte)))
+			return -EINVAL;
+
+		if (pte_young(old_pte)) {
+			/* __ptep_clear_young() returns the overwritten PTE */
+			old_pte = pte_mkold(__ptep_clear_young(ptep));
+
+			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+		}
+	/*
+	 * Translations without AF cannot be cached, so we can replace
+	 * them without BBM.
+	 */
+	} while (!try_cmpxchg_relaxed(&pte_val(*ptep), &pte_val(old_pte),
+				      pte_val(pte)) &&
+		 ++attempts < max_attempts);
+
+	return attempts == max_attempts ? -EAGAIN : 0;
+}
+
 #define __HAVE_ARCH_VMAP_PTE_SET_HUGE
 void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
 		       pgprot_t prot, unsigned long size);
-- 
2.56.1.809.ga0b61035b5-goog


