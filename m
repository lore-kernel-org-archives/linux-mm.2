Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8725AC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475656B008A; Wed, 23 Sep 2026 18:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4269D6B008C; Wed, 23 Sep 2026 18:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315C36B0092; Wed, 23 Sep 2026 18:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07E346B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:31:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 000CA4015C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:31:23 +0000 (UTC)
X-FDA: 85246474446.24.2BB2F72
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3EE8914000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:31:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HUXmlT3T;
	spf=pass (imf26.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790202682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hA4prx5+Mh90St+jFwZr6K2H8VkXOm57pDkWzDzmfUA=;
	b=1kPloJqhlvTHTtOQ5dvmoPHfSjMykbq8B6JC3dIxnjPxWVUIYCLCmVWA92dVimkwMrypKD
	33z7YEw9fP+5cgXhQtdct4UaxE9/hdD92wIuTKCE0G+O/LLfCGkNCA2s2Gut6NgOo0kdnU
	sz4n1Wajb7hgSpX2AW5E45MscurHSY4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HUXmlT3T;
	spf=pass (imf26.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790202682;
	b=RjAbtCqXj18yXwhlexz5dQNYrb0rABZarTGmBuQHkuQk/NCBUmeJkZGp3B/8XfJml2JIkD
	2xlasc/58Ea6AcsFIdoTejA2BtB0NgLZ50s2nqrfdyqZpAJaHDraS6EeuRJK/qQQcr6EsM
	Zd3Pm7aXz4cPfmc+a1Hjq1rEkdETUiE=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485ac898fa4so1348739f8f.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790202681; x=1790807481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hA4prx5+Mh90St+jFwZr6K2H8VkXOm57pDkWzDzmfUA=;
        b=HUXmlT3THJx3MpMPBA1c7GUmPLFjuZZLKIhKj7MFat4YS9YKeQ6ROsy4Cig/1Ev6Ak
         NduUcF6pyYjmb0IVBqrkdP/R+L2HabboDl5pqHoZGnQGlX9GvFtGGtsLOiFBz6ZGUMCX
         F2kJ1VZ2T2F7e5Nav/dyK7RYyaitnkJtqbho9DGHRAaX8EiRMeAMTi/VYWapwXLk5TdS
         gAi58eoGaRxBb/B5suuhy0DHcoLTkEqBzgX1GuhqaZY/IFDbHE5SEwT+W+dmBvnlLQZg
         ELzWJbl3rh69U8TZxcCqaUA7rfpvhMwEtsP6agJOmLNfngDi73sSoIVwQNi/1QFodoCk
         x/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790202681; x=1790807481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hA4prx5+Mh90St+jFwZr6K2H8VkXOm57pDkWzDzmfUA=;
        b=oqsJLvPZJIu3+84yaw6W+O63AGN09yxy6AlxhJPv2t6BMjMHfy5hbp04HK2konUOdA
         IXhN3V/cLdUVXskem5t5naylzJvGKOS1s/0b7uSq3Q6661GOXANtq1WB1EiKRhvIs7pu
         bzVBtdufgpCpGk4JRD4JZvXN9siIrl6TKKxZhEjx9aURPC0bU37wo3jn2pKljV7Bv+6M
         fjQdDIc4FeHFHMY0u7BE9+UoosToDiPuz3q4wpBbnLh4ri0vMJgea6l8WlmOpVN1ill9
         zBtGNE1V89D/LPmLwDQmKfhjzkHj2EMu+Pdott/f6ZnMFA6dJERSovlxH9TijvUef5jT
         jR3w==
X-Forwarded-Encrypted: i=1; AKwUvBx3+dL/T6VoCCHF7pDmQR14lZPKzCjqS4T+sxscQVpDOh9jlwNkana0kmM+yHEf/4lEf4k+E682kA==@kvack.org
X-Gm-Message-State: AFuF++k0on423sPo217nXPYwGLuVL+uYQT5BTw76tPtjZw/YVTR8sKM+
	a+vOb2C/VepsiwbJfjoSdyFhuoOFrFqH+3BU41K3QQmtNN4EGhldYfo/
X-Gm-Gg: AYBFou0bLNIMN08ELTrh+KnDTeEEfXjksDKzHZSRUggfbhLfaveLBvGRIyOyaRMX8Ca
	7HgSh1pynyWoHyW/2cB2QHWUgVS5eJVmonuxBsHAVyB4N03fOF9Pla74QLNZ1VVhw0nzGskBQvy
	4GR6KwOetSgTzQxHu0uKlbe3SHeTHve1hlO/SCZMteYQYFe8iDxAGmlKnh8/sjjvE6NBxWvNyQC
	3HZokullnJFYzpbHVoqmTn8DoXs5cGM3Z9oNLzDVECi/Kb/H0UX7QqDpq+c+blIxiiga4eUPfC+
	IZIYThfdBrdTW6xZif8dyspnDPC/LdM4Xzmkv5KYpf6dDJ7qH5KN5gHCVE/6cjyK7xwVVeFsaf1
	YbMbfpbDBiFxoqUkopKo7xIxkJAvOLvS4wy0zacJCP4MZrrs4s2O+kNDtoRfh/81Cr/48ugKjrq
	sm0r1R74A7RLfGPNSNG+JqR3/f5W1BatiQd+TV0IME3mdSlcWHLAhD7ZQskivQn0CXixSS3wbW3
	7AXvc02mXP2OenJrQvojyCcAF/iHeCGnqZWwr8H4xwNkEhE7DBaQ24xlCHuaq4UaPl4ovg=
X-Received: by 2002:a05:6000:1a8c:b0:487:b32:9d6f with SMTP id ffacd0b85a97d-488717328e9mr817751f8f.22.1790202680711;
        Wed, 23 Sep 2026 15:31:20 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886877a2a5sm10613192f8f.26.2026.09.23.15.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 15:31:19 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Toshi Kani <toshi.kani@hpe.com>,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH v2] x86/mm: Drop the page allocation from pud_free_pmd_page()
Date: Thu, 24 Sep 2026 03:31:16 +0500
Message-ID: <20260923223116.20090-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3EE8914000E
X-Rspam-User: 
X-Stat-Signature: eqqs1nbuh1dxm9ebgs3at1p6ssp1gmn8
X-HE-Tag: 1790202682-135730
X-HE-Meta: U2FsdGVkX19aWS31F/7U/i5yMJ5PjyP+BjCQqvALrjF1kkbNmuic8qg1dz8ZWeQinXVJMGMZmrswcVA+3BaAuspXFqXnJRV+MLDmMJnOWDK6xDn9lBrpeto0JZI3T0lQGmf/MPe70ZZI+8S+SXtZwYhbfRB/0XK6w3yrE2PsAgIiWTz+M8TMZ0ek1VvkDOqZ1XaalasouyxEogNjVgnXXL8pERNHiSIwlHAOyVysTnDtdVQLcvW9/7XtGJvvRwBnKOxDkj0q8BJyqemOtdCQc/zxKrCgF/0UeXiIfyzoz/+Nenp36fGLHAsZ9dc+DxjSmKXCVGIkzS9Cb+z26mmpftEesx5M7Jf6Y43j/LrsbfuLnE1aopBuHF8UgVvP3gV/vUVEOMi4idbzt5zPPjMVtyjGjduk7GdSTH9StF7uo937qrIvtymKn8oDoIhAg5rqxngqXiutdgGsxpxNyEPibueKo3+/oYe3NImFgl81uIWXhURFCg+U/GJ3O6Ova+eQVcLl8GBrr9/2pK7VcMt7E3RGwL1rax6EwRIDDUMMq7kfD9ijohriQUQSootDUAo4naQ2bjDJ4fLJBP2OuNy4deFhDXfqmoKj+e3y2yK0SP66m8UkOpKwvIePQPOEnaM4KPKLApGkyBjRR08bNdzFkzEuJ5Y1dpGiOAfHaMp1AJiquKU+tp/omIyfaiLHDQspkxG5F8Ots9fUxm9R2ScUgqcEow2tiM5LbbK1TeN/Qj6GjVY3Hz6KFyDLrTZx3H1TzcVLqQdY7+EMZnoiuwrcFd1qFEzjMvi8MQKiZAVSTqJb07go2GaYFfUjWUqySNEdXXyPmemtvrNuM2sYd4D9gmAQDck2SSNZFI8XC7y346IOszlwFaRYcPZn4wrKABf2fBDkXCO8X47ITpocP8mA+gz5/q+EOnrQxZ0ea0XDZut3rz8bdvl+/xLouiAMeHtBya/s3y22v4uqWNqIZHB
 rEQLUnz2
 I3B2QYpIpKJj1YAdmcZyTY8PwBex1H1V5F+UUNm8kpXYf1iOMpfwotoelOq9/bPijWwAIVClapoagLP+frhX40XtJ81wWdYD/mQbtZczLKYGIc0opqaQy5Gni3LAdPcbAKVwFzCniIKjT23UkOAW1Wj4fRDAmOoK1g8hMjpCWiI3k0A28jR5f8seSxAKWkG0m7ECaCr2M/TrZcV3P6cLXMrCfte8ww7q5hw/ypobep/lxVfYm4g1Fy9zLTCnlXN0wCebUB82PQ5CWdP1JTLHIkg+LoaFEw5JUcqqotRV6GWnoavvQtTITbPN8y1xIvasumznVzZTDqqzBtHEB8wE4dl9hx79hIoCLueagoX2Vxv3ePrRP1g/3o/I+mOynygOqDg2QZKvOohRrHoo4udnnrHl5ctj6qNTWxU88XLfH8GF86Yf/nknJ3tXj1olyGmLbi8YVq1O9n6pS62f/SlN5Ddl6ZOyaZmoZL8jQVb7+STytX7LEqPa2wsEwZvNX/uO7LbYvjDErmYJQO4ZQUx8mwhrIAVFC2zsUzVOlQjQH8TqiXhU2jbyYcLPjqjV9QlorNBCmvcvz8Xs+6alchD3GwOwMZcUdq1T2k5FW+HgLdsuzwO7rWNQbFVuv5p95LWNjyR+sOPff7LYz04FSmOqeRpbanbfIhcen7cE1JB5UtzQjNHN91/NQBGe/vi0Ufz5RD/mjxO7qMw/eXHe/3409bKGNHLSv89U+CqUlvoZYt/Y4tPcr1qpTWE5tsw0uRFpRmai0nTpcVhZm35XX/IsAd5tpWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On a box with a discrete GPU, lockdep reports a possible deadlock as soon
as kswapd shrinks the TTM page pool:

  WARNING: possible circular locking dependency detected
  7.3.0-rc3-f6e7b42bf05b+ #183 Tainted: G     U
  ------------------------------------------------------
  kswapd0/269 is trying to acquire lock:
  ((init_mm).mmap_lock){++++}-{4:4}, at: change_page_attr_set_clr+0x29a/0x4a0
  but task is already holding lock:
  (pool_shrink_rwsem){.+.+}-{4:4}, at: ttm_pool_shrink+0xb2/0x330 [ttm]
  Chain exists of:
    (init_mm).mmap_lock --> fs_reclaim --> pool_shrink_rwsem

The cycle is built from three edges:

  1) pool_shrink_rwsem -> (init_mm).mmap_lock

     The TTM shrinker restores the caching attribute of every page it
     frees, while holding pool_shrink_rwsem:

       ttm_pool_shrink()
       -> ttm_pool_dispose_list()
       -> ttm_pool_free_page()
       -> set_pages_wb()
       -> change_page_attr_set_clr()   [ init_mm mmap read lock ]

  2) fs_reclaim -> pool_shrink_rwsem

     The same shrinker, called from reclaim.

  3) (init_mm).mmap_lock -> fs_reclaim

     ioremap() installing a huge PUD mapping over an existing PMD table:

       ioremap_page_range()
       -> vmap_range_noflush()
       -> vmap_try_huge_pud()          [ init_mm mmap read lock ]
       -> pud_free_pmd_page()
       -> __get_free_page(GFP_KERNEL)  [ enters reclaim ]

Edge 3 is the one that should not exist.  Now that the attribute-change
path takes the init_mm mmap lock, reclaim can acquire it, so the lock
must not be held over an allocation which can enter reclaim.  CPA itself
follows this rule: split_large_page() drops the lock around
pagetable_alloc().  The huge vmap path, which has held the same lock
since commit 26444eb71465
("mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF"),
does not: pud_free_pmd_page() allocates a scratch page underneath it.

That page does not need to exist.  It only holds a copy of the PMD
entries, so that they can be cleared before the PUD is.  But the PMD
table itself is freed after pud_clear() and the flush, so the code
already relies on the table being out of reach of the page walker at
that point - and if it is safe to free it then, it is safe to read it
then.  Nobody else writes to it either: vmap_try_huge_pud() only gets
here for a range covering the whole PUD, and ptdump is kept out by the
init_mm lock the caller holds.

So clear the PUD, flush, and free the PTE tables straight from the
detached PMD table - the same order pmd_free_pte_page() uses one level
down.  With no allocation left the cycle is gone, and so is the only way
this function could fail.

The copy came with commit 5e0fb5df2ee8
("x86/mm: Add TLB purge to free pmd/pte page interfaces"), whose
changelog explains the flush but not the copy; the allocation itself was
already questioned in review back then [1].  The same lock cycle was
also reported from the i915 shrinker, with &vm->mutex in place of
pool_shrink_rwsem [2].

Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
Suggested-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20180529144438.GM18595@8bytes.org # [1]
Link: https://lore.kernel.org/80993b70-352f-4069-84c7-39a04c061e98@intel.com # [2]
Link: https://lore.kernel.org/20260916062222.27347-1-mikhail.v.gavrilov@gmail.com
---

v2:
 - Drop the scratch page instead of allocating it with GFP_NOWAIT: the
   PMD table can be read after pud_clear() and the flush (Pedro Falcato)
 - Capitalise the subject per tip conventions
v1: https://lore.kernel.org/20260916062222.27347-1-mikhail.v.gavrilov@gmail.com

Tested on a Ryzen 9 7950X with a Radeon RX 7900 XTX (Navi 31), lockdep
and KASAN enabled.  Reproducer, on a lockdep kernel with a TTM driver
bound and non-zero wc/uc rows in /sys/kernel/debug/ttm/page_pool:

  # cat /sys/kernel/debug/ttm/page_pool_shrink

This runs the TTM shrinker with fs_reclaim held.  Unpatched
(7.3-rc3, f6e7b42bf05b) it produces the report above on demand.

With this patch (7.3-rc4, fe2ec83746e5): a boot-time kprobe on
pud_free_pmd_page() recorded one call from a udev worker during boot -
in the unpatched kernel's lockdep reports the same function is entered
from amdgpu_ttm_init() -> ioremap_page_range(), so this box reaches the
changed path without instrumentation.  In that same boot the reproducer
freed 354 write-combined pages through set_pages_wb(), with no report
and debug_locks still 1 afterwards.

 arch/x86/mm/pgtable.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index cb03f5a2b243..6a338d6e80e9 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -712,40 +712,31 @@ int pmd_clear_huge(pmd_t *pmd)
  *
  * Context: The PUD range has been unmapped and TLB purged.
  * Return: 1 if clearing the entry succeeded. 0 otherwise.
- *
- * NOTE: Callers must allow a single page allocation.
  */
 int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 {
-	pmd_t *pmd, *pmd_sv;
+	pmd_t *pmd;
 	struct ptdesc *pt;
 	int i;
 
 	pmd = pud_pgtable(*pud);
-	pmd_sv = (pmd_t *)__get_free_page(GFP_KERNEL);
-	if (!pmd_sv)
-		return 0;
-
-	for (i = 0; i < PTRS_PER_PMD; i++) {
-		pmd_sv[i] = pmd[i];
-		if (!pmd_none(pmd[i]))
-			pmd_clear(&pmd[i]);
-	}
 
 	pud_clear(pud);
 
 	/* INVLPG to clear all paging-structure caches */
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
 
+	/*
+	 * The PMD table can no longer be walked, but it is still allocated:
+	 * free the PTE tables straight from it, then the table itself.
+	 */
 	for (i = 0; i < PTRS_PER_PMD; i++) {
-		if (!pmd_none(pmd_sv[i])) {
-			pt = page_ptdesc(pmd_page(pmd_sv[i]));
+		if (!pmd_none(pmd[i])) {
+			pt = page_ptdesc(pmd_page(pmd[i]));
 			pagetable_dtor_free(pt);
 		}
 	}
 
-	free_page((unsigned long)pmd_sv);
-
 	pmd_free(&init_mm, pmd);
 
 	return 1;
-- 
2.55.0


