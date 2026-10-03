Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D462CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5186B00AC; Fri,  2 Oct 2026 20:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D555B6B00AD; Fri,  2 Oct 2026 20:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D616B00AE; Fri,  2 Oct 2026 20:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98B076B00AC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A4B0A78CB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:48 +0000 (UTC)
X-FDA: 85279411896.16.B712C84
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 804B9140004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hedYy8DE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3mUrAagoKCIwz9x4Awx943w44w1u.s421y3AD-220Bqs0.47w@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3mUrAagoKCIwz9x4Awx943w44w1u.s421y3AD-220Bqs0.47w@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VjIDdEMsxckzeTQAC8VMO9zeN/fS3+8A2YCNQtbhGo=;
	b=fOakmWgvE6kaKvlUDgaBaj9J0esLzb9hG2fTSgjGY4VAKvopeprZnVwjvrvRwbB8flzMYx
	pLdnwHZtB/ZNIXh7TIGwqmtHWcdYz1th3Zwq9jnYP+CEMjEGHLGIqeKVrqsJDWNccJYJyM
	0MXe+Zh0ffiBJy8u9tOP2wCZrSJ2XIM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hedYy8DE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3mUrAagoKCIwz9x4Awx943w44w1u.s421y3AD-220Bqs0.47w@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3mUrAagoKCIwz9x4Awx943w44w1u.s421y3AD-220Bqs0.47w@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986906;
	b=B1G65tZx1p24LHMd0tHQW09xUNx+alupvlL4UQgVBlmTdzbEU5oAto2e3awmRgSplRbHY6
	x0EKkXtrHzN+WEX+ytgtiF0sQuOyDGoBAFkSTu03L2lpdVfN4kvrJ2waQw315vy//d/9bX
	N5O77cxysrp6d+ev1ZWTYYLH6LT0z6I=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-88a1de72cf7so98b3a.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986905; x=1791591705; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4VjIDdEMsxckzeTQAC8VMO9zeN/fS3+8A2YCNQtbhGo=;
        b=hedYy8DE65G9pp5oFBLJUe2sFeQ3jAYO51mlivAJhoNh2rGFOjyq1jh9/Vo1eMRSyb
         Ks7noxRm+RXJWD4ZdpQCqWeKq1UsF1DZicTZsg9QVhCLncozichYo5ISNjy+dAJsHIys
         lyMbiIfsx/dN9bKUwhmEc4rl+9EPd0Oc/Tia9qf/jyawll23O5hnympFlGXTOkinANal
         350Ox/dHhGgDLoUiLXj5x9QqtDk76s1QNyxKU+IYuy6hELZ5zupXdNzxZxFxz45jSZly
         mxunXcJK6EQ/Pf2G439C+yclbetUu0VC8IQH6b4YyX7YKJFaEGPiElKZTpfvxN4d/8gj
         fmoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986905; x=1791591705;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4VjIDdEMsxckzeTQAC8VMO9zeN/fS3+8A2YCNQtbhGo=;
        b=nDqO9YMkmwIkhs7e29oItU5giKUW6QfzMCL7MVi/pVZV6DbpGID34/4oYNyB1V9wfc
         9NTp/GKR+jKpaw5EGPn2Iv5y7/aBhFGJQAAVZ+dFsc2PTmEIbanufvvLF2nXLX7Hgd6K
         WdrdMfTg7oZaQY4Oc2paluMPqQ5VPkNrRsTSJWKiA58W4mDj9aiaTLo1nRD7u82faAjC
         AE9p5En2X17IFMmHdNu6m/BjG4SPCwoPiwReiE3Bx8Tzqf7BM8cfe8c2mAyhnFzu53/B
         Cz/UVgvrgVJx+o7dibm855Nt9kVujS54yqf07jOJ5yjedUOj9LsrhhpAVOupaDjP1GHz
         sjyw==
X-Forwarded-Encrypted: i=1; AKwUvBx5AZCCUBUgQNNtJQN2CL0rKaWqphNYT/Szp8GZ6kfZnTBdpjjQZyoEC+EBLiiQwv2+FYESNLiG6g==@kvack.org
X-Gm-Message-State: AFuF++l70/xzbOg1MAguk5qjyLixxUe5zFV6bMripMddqoz/y8P8t0ZJ
	VmPhHiQhpHBCrLJ3MLMpxD2LgAm3V2pV86FucYnd7+qjIf493de2sHEGqkkPEgeuY15wSUjl+CW
	rCPkeb67fMquB32UcN6gPag==
X-Received: from pflr17.prod.google.com ([2002:aa7:9891:0:b0:87c:d84f:5ff5])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a245:b0:878:3704:e0ed with SMTP id d2e1a72fcca58-88af5f9362bmr3106493b3a.19.1790986905085;
 Fri, 02 Oct 2026 17:21:45 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:15 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-13-jthoughton@google.com>
Subject: [PATCH v2 12/20] arm64: Implement try_update_vmemmap_pte using the AF trick
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9mgo55hwuhdz955p9jacjh1rmrjn5n96
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 804B9140004
X-HE-Tag: 1790986906-927684
X-HE-Meta: U2FsdGVkX1+qMFHqkhCnnpKxRnCIKOvqCL2NcJKUpomJ4OYZfLau181YIsu7IaSBe0nkt0u0U3jzt6hILie4o+JEzzm4Ts6bVjNJq0BMFqnHiEhN3WHz8tq3Tu9SMt/p08FjvgLEmlBRRi6FqzDyRCClA1m3jVjFNZ9NJkt3Uvk4Qvu0TNRrYiEBJtCO42CI2ec/7PetoR/3DVmHLWk90sbwSHWRxtXBlxXQYC4UcaWZNYm8r5X+RkzbWwtm1CYUNlUpIe8y8qOQ9DF0XGkPmFA00Hb1bdGXJJPtZjtQMsa4ZXuraG44UCItQDFTODaRqD0FpQyzySH2v06BLg3rl3dK16nLjsBDpBq5DnkV8KK7947pnjyNxx/5fYNyl6FH7fGkzjhaCg0LGwoc+wHQFVfj9ZIz+ki0Bsr2JYpAGu55ClrATiCMXgWjffX+QVOeYC6m+8mB7F/pZUKRkodfBnqoHEXee1QqQYOdLf8X8RmS4KP/B+JOpxk0/CpT0WzrIsj+4FeYFmvJ4LWO74j/VMmP/fQRE+4mUct/w+1Solu1lc0sCI6NilQ7k8Joc+iHcmr9EwzwpxxCkoWRpB7rHQMKIvTIaGoh6GW6fti/Q6lOJdNuuJDW/8wxI7fnjfDjcH+zW2d5B8V5KbrPGOKAtqTAYSPR8wt51jjSpX7BHFweeXpHgFqhDBSXHptaxyEMtTQSlvVgGFFQBMyfIcJBqnI9zgDpHBAeOydNIWYrFOmee3Pt3siGHRRvXMPWtF7TNl8biHTiKVqo8saOxjZPlzAhKxQ7r2N77ncHQ/QoAy90SpaiqdhkSxNe06gTIwG1WjdImmrUnl5mDP4ZuTGa1xy6F21O6iT0hXpbwo+o+QsQoCUt2B42HfDQ+51mq6Z8XO3mhEhvV2By8TMedr4om/CryUroCvTt+csLZmOKoAAnzEA+TtZrBv6ciDriym+Wr7KQMv+9A1ebmZxnqDI
 KPb9uZfd
 F/HD4p4H+Xx0fha8Fgzn5pGIXf/Ei10UrcWMPJWlnurPJMhunGU0pN68z6bVI0crA6/3hzKfaJn2iw6i3ossnx04+xRdJ7+2CP014zz1n6fW7W1Hs+AE7Ifs2KRxjDlbhzp6RmNPcLxF9lBMjdTBa6AuZIaKS3nuMw7+CY8dv1/l1SCoYhCL3w6NzgQQb/IZo8e6GufeN4znDjzTRd6bXETw1cdSjzcXV8IctiFPgtBnD9cto7vBQvlyUlfw0RTXtmvkg3LOwF+iFhloUnaudKNwi9+8bUEhqbuWL1W9eIrRCkraJinGp81LEgzXeV0b3b12m2teJbsln2XY5YtIT0DWWPdQg1kZSKc2f8pJGKQF8epnmrarhvAmaq4wxNZ0So8Yjo3hlcTZFSCeWDuOqq+Pl2/WxciZ86NmLHyl1kjXVsGvMYfYnO+c7FGHTTT8sCsKyyMOuJFzUMHR+KjLj7Kvq94ujMwUWArEtdYFZYuobH3O4JC8iMh8MTSv8Y6+U3xhz1THnva2rGAiHjKT3e/yjMbQUxlKcr/5tcb2pxy/rCNSu4/VwTddey48rwdJrvpZJcAPQh9FjhUourDxnFVg1lSUXEL7Q03tFjIXoq44KbwvYJL5n9Ls+4K0OQnrO8t1F7FM25mcuTE+zAqVojHFEHDIUm8mXqoEs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 arch/arm64/include/asm/pgtable.h | 60 +++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e47c3d010715..f8e66bb22c0c 100644
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
@@ -1734,6 +1744,48 @@ static inline void pte_clear(struct mm_struct *mm,
 	__pte_clear(mm, addr, ptep);
 }
 
+#define __HAVE_ARCH_TRY_UPDATE_VMEMMAP_PTE
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
 #define clear_full_ptes clear_full_ptes
 static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr, int full)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


