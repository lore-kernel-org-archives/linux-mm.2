Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3CAC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3168B6B0095; Wed, 16 Sep 2026 02:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFAA6B0096; Wed, 16 Sep 2026 02:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DE5C6B0098; Wed, 16 Sep 2026 02:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E72A06B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:22:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD0FA40604
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:22:30 +0000 (UTC)
X-FDA: 85218631260.28.256603F
Received: from mail-wr2-f32.google.com (mail-wr2-f32.google.com [74.125.225.96])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2857C80006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:22:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eOp2pPW8;
	spf=pass (imf30.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.96 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789539749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0WHX+dp2Boxju7SrcSzARyHP/hpDCqm9COAQ0KdyjLM=;
	b=Y5w0GGg4fe0clocSn0WAbkhTFL//utp9LVOWV+m8+hQsoO5oJQFurLc/eo+F5gxFXFdtLd
	QBpaP6bgXf052OZWS+4YgEiufLrxMU3SfoLH9uOCED8qYD7SRhm9H4ZwkJ1ZBKgYD7fnqk
	elWWA1V/H5sn7Jt5rXtlPasNee6jQz0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eOp2pPW8;
	spf=pass (imf30.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.96 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789539749;
	b=DZvzCya2aKeMLTeKmSSIkh67IVGqug+Di6zIVitcd1zQYkLDWvfylLblUWmnMpc9ECyzk7
	AdmoLmJWHIPZfO+y3sO8niduGH8QyJnsZUnSrrR+dnLN2PxCEKeH8jIxKkChJuUYihIytn
	VpBN0oDvZxnIgMi4k+XepwK/Ag9WHBs=
Received: by mail-wr2-f32.google.com with SMTP id ffacd0b85a97d-482f6350f91so247896f8f.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789539747; x=1790144547; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0WHX+dp2Boxju7SrcSzARyHP/hpDCqm9COAQ0KdyjLM=;
        b=eOp2pPW8lJR/IqymXyStbtVQF+RlImfuDABE5J9DFGSU0Fv2GrjsjRYiBD2DFrAjrC
         LT0t6XUU15h2T884tQm6GTp0uNx47bu9xeya9SNGTN9dTdXWTJLoJA8rkbFV3G7jmJyS
         oUXvZGsFtjED1JSenyL2VO0lMB0UXdYB83IT0Vbf9WOEPzdMic+MIGeLzZB0ZKBmgazO
         IPD+9lfpsLEACIeO37o2t8NKeqIBt5DeCpTATLL8X//7g1zWolyjU7bxO5RT1ToHkidL
         hm+aJCSV6lICQVWspkExDwyp56n3c/mR3yVXucBgypfnRjlaNj2k6sihBUhD0xWpl/vF
         zuiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789539747; x=1790144547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0WHX+dp2Boxju7SrcSzARyHP/hpDCqm9COAQ0KdyjLM=;
        b=c9KjG7141TP7kDtN2e/L8SLGvRDBA1if2nsv1kl9qUtuWRvXP5qaio6D0STYw+vyqL
         PCtmXEbhwICLJCVZH7ug/W0rdSkwC1VJJHNWidImfxn115i+yWQxbQOi/SWj9vLj0yCG
         5iwmFksNc/xCPFloCIiQzUWHdommZki87BlyOje2BPlF4seTCERQt1161aISTEJMoiyf
         TzheuU0Y5J7MUlxgRGqDT4fJTs4VFxFCOFzt0v+wkSjilMgzIIQBHZlUB9jt6GpfhKvW
         ftujEXNwh7IdnvHAE9F0yyb7qNcnkL4+wmOBdy3KJXVosLw475HcfadVt/1bPcolhM22
         tVRQ==
X-Forwarded-Encrypted: i=1; AKwUvBzxCJXW2nEkrtsmk64kIm1Hgg1utLBshy12xXBWM7zBGHzOWncjyzGpOggIzPwbsY7HBI1vuOX5BQ==@kvack.org
X-Gm-Message-State: AFuF++myMHKwXkKG0oq2l5NLfXAn9AMY0EY9yhlCGf9zhRHMfq5um3ZW
	vnZDBJ+/8xQB6BTlgIcmI9mNUiKhvNuXaVkbUTPuByreA1arl8O9nc5wYA0fAc5cgbMWtwnL
X-Gm-Gg: AYBFou11446V8DOZvaMMsdNicWhwaNkXepk5KgtSdst6VlVMcnUNJaxCOmB6iWOEkw3
	WHSrGSn2d5yZ0MJDI9BjOP0i3E9PwgnSAQkpsaCKVRoTdzM4Rx6l7vJFyE6gvL63/1ZsogAnISZ
	ONDM8a9T2KtDIC7aJHw2jKGOttgT411k18r9o0Mz6075w/7YshRE1ivIyJGFQ06w9mO+NyOQoM/
	hSJXHVcaw18LSjZ6e7Akm8gKn5/SjpLTcLBkci1XoLZC/IJy+RwtvkC15Ew0N+efe0misBCZCeN
	cXwKP7I6FkWCsHkpXqkWPahRL6vnF6k3imnggZ/dvTeBQw0iNTtF+XXZmRk9UWYqoHkSJ0mXHPf
	8/PRDJ00cvL9LBSx8luMxBA0LhUeJ1/O0MdnP+7lMdAtkZwzLD19oSPD8vU4zsbz3MDg1R9AJX/
	T0E1t5U7w/uXW+XfXIpbpkI46Bi2HcVHjaWB+8HLmHiAGNSrQdqw6+I6yyXxvGumzGZKDyGZtdw
	m1XGtvjn0zZqGK0q/iqxjVgdNcr4vMYtcc7SI6v1HIlcluwniICO447SFJyfkMrY6s29rc=
X-Received: by 2002:a5d:64ef:0:b0:487:765:46bf with SMTP id ffacd0b85a97d-4870cf2080amr1418487f8f.19.1789539747371;
        Tue, 15 Sep 2026 23:22:27 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1fe7esm4336679f8f.6.2026.09.15.23.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:22:25 -0700 (PDT)
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
	Toshi Kani <toshi.kani@hpe.com>,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH] x86/mm: avoid a reclaiming allocation in pud_free_pmd_page()
Date: Wed, 16 Sep 2026 11:22:22 +0500
Message-ID: <20260916062222.27347-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2857C80006
X-Stat-Signature: gkx5rrq9ggj3qpaowu5z8gzo8go144nu
X-Rspam-User: 
X-HE-Tag: 1789539749-865053
X-HE-Meta: U2FsdGVkX1/BZYp5AwqzVjnp2eTeLAULh1/2P8QBL2HyEzRIJYwmGZMbV5pCHdH5XPwHANEw4uTKdY77HzxYUfP15jmC4Ys1yhvZdBIOBlStX3i4VsgWKJ6p8LCWaFnQYueIpN5t0lEYCdmnRRex+f5tV7FdtD6GTqPdKVYZz9JEtE3EAPpjVEpOWHsRwg/KiYNv21EqBY30nBarZ8I+oAvw/kMrozyMJYDBXI1WMLMufgofNGWq7QRKRd5EVWfk4zt8L5xZ3t/C3iAVCt6sBa5YU1m2VEWzs/GY44Cpq50gr3igt2mqtbCaFKAMZg3y5WuMSLEPFLZCyRi4goCdo850IuK0tiAzZuWxHRC9nCvSjBXQUqEBCq7nQJCZZrx5Hs/BMhd+qky0GlOGM6wd1k6owAKq5/m5uZYJo9m3F0VK4k1yxW1yxcfQyvFKJ8fGhKFQgU7aI9EYvOvQ6zypJh7OQju8c3xK+48ey2tdYylaLvjVCSSF0FJ/awqx8N0gy/KHSF2BBcHzZYLMuMVdj78dOHYJl3iTyyFYlfIxNOPE9r9kY9Yemv7jZU0cgPW/EH8PErpvNWzc/LNqPm53On4xfOcoUjXUZwWYYhWdrRIGnVWlIAyVllDNR/k37X6a8aWSiq+zwoBm4m1ozLVXuGKao9wL+IIBISqysHEb9Xm6346FnWpebvDdKeXNs0UGwiB7GhAt2BsGs3utxw5GfS5Cv+BXMxJ3SOaDAnKpOXEbtFERXNB4LYQ++ICPVNpCrj4C9/wTM1iPuTojibD79FhSrhKE3L1Oia5TJM6c/h7sN1dHxCrta7P1a4KRx17W0atT/zqb4SmL3wLZzU8jy+M4L0H8SE2RhyPLlTXBZSJ5BHNP0u027xjqmVkwYZaPUb7JFX6c4YBlXJWN6X9po/BT3skRSOIX87illIoThxy+H9Krh0GX0VD8oyv5ebG1/2OtBg1TuPg6GL0NYIb
 Q4RuwT0a
 nmfcA+VEFATeRhQ5t7OTzuVlpb8uY4Cf91qKCaGOHZDnurw37Nrh+jtHSU2qIPhTqvAJ5Hejt7WpNGHkMSxjcQlYNVatBOSdVeXkrGsp8PhwUnI6E5iqQTHQ4PwYGS4a6dVJLHeJdYtPkRqDS2dctkJvnzmOpQ7zcysQSNIVYHcCiVWk/68ANi4wpcJtMOocwESANCWt5LYXDoGBEiypR1ZToMfHTtwDRfjxnyuIwTh+uTnodJ7kqlBUQzzRCee8fcjtcWWYvmBpJAI5ohlcdzbtmSuYuawpZVbBpmjpIOV0mGQtyomGgrjIPeaKOs0EIVlwKpLgAMqSFGGvSfgs/P3xDlfzZ+wVGfZ/Xe+iHSuHGJ8dQK/D/pX+0MmJOdE/obLftQUZXjYVI/dp85kI4mjfEskfakONTtgAnvSSH4GMBG+uK4Lsu1SFxj8R31aXnupHbQk4fPDiOQVoA1hbNb45OEoleaeJG0qaD9SpV3hy0yOg1N80q/1t23a59b5m7FOdAkl84VNX3cqMkH8lyTLTOalhJFiPb1Iausyvw20Zo64pvgYa+kMnUqeRGF2z5Apgc34MHsBs3hsFBEcU/GGa6u9ZAZSnuSpeRXZsgCCwWj1aL2Jk0KD+nwBMGNHAGO4OoCUACKvnVCbX3i+zBpOsdgWDXMQ/iNgbc0wPKjAdIP8nidNQlqPjNed5XpOSWrMDjWXBnbvuWcIya0doY07NRqCkdhkD+KEZk
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

Edge 3 is the one that should not exist.  Now that reclaim can acquire the
init_mm mmap lock, that lock must not be held over an allocation which can
enter reclaim.  This rule is stated by commit d5d8b8662e6e
("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
and honoured inside CPA itself, where split_large_page() drops the lock
around pagetable_alloc().  The vmap path took the same lock earlier, in
commit 26444eb71465
("mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF"),
and pud_free_pmd_page() still allocates its scratch page with GFP_KERNEL
underneath it.  Neither commit deadlocks on its own; together they close
the cycle.

Use GFP_NOWAIT for that page.  pud_free_pmd_page() already returns 0 when
the allocation fails, and its only caller, vmap_try_huge_pud(), then maps
at PMD granularity through the existing page table - exactly what it does
when its own mmap trylock fails.  So the failure path is not new, and a
failed allocation costs nothing but a smaller mapping.

This breaks the cycle at its source: no code holds the init_mm mmap lock
across a reclaiming allocation any more, so no shrinker-held lock can be
ordered against it.  The same cycle was reported from the i915 shrinker
with &vm->mutex in place of pool_shrink_rwsem.

Link: https://lore.kernel.org/all/80993b70-352f-4069-84c7-39a04c061e98@intel.com/
Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---

#regzbot introduced: d5d8b8662e6e

Reproduced and verified on a Ryzen 9 7950X with a Radeon RX 7900 XTX
(Navi 31, 0000:03:00.0), lockdep and KASAN enabled.

On a kernel with a TTM driver bound the report above reproduces on
demand, no memory pressure needed:

  # cat /sys/kernel/debug/ttm/page_pool         # wc/uc rows non-zero
  # cat /sys/kernel/debug/ttm/page_pool_shrink

The second read runs the TTM shrinker with fs_reclaim held, so the
same cycle is reported from the reading task instead of kswapd.

Before (7.3-rc3-f6e7b42bf05b, #183): report within 105 s of boot,
2048 pool pages scanned.

After (same base plus this patch, #185): 1536 write-combined pages
scanned - the order-9 row of the pool went from 3 to 0 and total
node0 from 27650 to 26114 - no report, and /proc/lockdep_stats still
showed debug_locks: 1 afterwards.

 arch/x86/mm/pgtable.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index cb03f5a2b243..c79587962526 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -713,7 +713,7 @@ int pmd_clear_huge(pmd_t *pmd)
  * Context: The PUD range has been unmapped and TLB purged.
  * Return: 1 if clearing the entry succeeded. 0 otherwise.
  *
- * NOTE: Callers must allow a single page allocation.
+ * NOTE: Callers must allow a single non-blocking page allocation.
  */
 int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 {
@@ -722,7 +722,13 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 	int i;
 
 	pmd = pud_pgtable(*pud);
-	pmd_sv = (pmd_t *)__get_free_page(GFP_KERNEL);
+	/*
+	 * The only caller, vmap_try_huge_pud(), holds the init_mm mmap read
+	 * lock, which reclaim can take via set_memory_*().  Do not enter
+	 * reclaim from here.  Failing is fine: the caller then keeps the
+	 * existing PMD table instead of installing a huge PUD mapping.
+	 */
+	pmd_sv = (pmd_t *)__get_free_page(GFP_NOWAIT);
 	if (!pmd_sv)
 		return 0;
 
-- 
2.55.0


