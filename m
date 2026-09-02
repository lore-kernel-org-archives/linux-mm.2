Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB93C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAAA6B00CC; Wed,  2 Sep 2026 07:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2636B00CF; Wed,  2 Sep 2026 07:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8536B00D0; Wed,  2 Sep 2026 07:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 931E96B00CC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:58:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28DE8401AA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:24 +0000 (UTC)
X-FDA: 85168674528.02.21F797D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56BA6100003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Rc4U+AYr;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350302;
	b=1NzRh1WzgwVSzy+PfrUkVojg+0V7o9WkzxQhP4am70ouF24GJ6R5ZYkCzvI4U7LdUtFOuh
	Ql3OFLX2wTKEtLIXXvxVn3ekFz7aQeonKemXZCXPWkQlIwK6GI3WCcnLw7PeWMIM1feYcR
	wwvFftC9+HG42Ppa15hQeSbeP39A9lo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGvSCK+CNBsx4onQ6S+NtN+vZQEZVfftkEbqHu/xveI=;
	b=TdS/IoZ9BQgzWN7vCACl4yd5pWnptxkraMsD+sB9DUHPzBIWMaZxyDfgACQrQ47nbRK9vO
	b2XTgs2WBFagE6ztu+pu12/6nln239jR4aa8oTviwYxDsBO2cz7T2+/KRYuA6ATYAkURek
	C6tOp0hA+DZRXslq69Vim7A8RnMJERo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Rc4U+AYr;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE9F21682;
	Wed,  2 Sep 2026 04:58:17 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36C953F85F;
	Wed,  2 Sep 2026 04:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350301; bh=Cb50W6OPktHsm99acng2bApoCrgxkxuR2uk46zCbRyQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Rc4U+AYr91IKzHdGrEAPsLYegtTUEga1U3eutHDciAy900B6qzrYM3rlNvw3RNJEl
	 b2U92FsRk4XYI3PExcwjmh0Y8XuoN5b7K9lRoBpN+Quf+pBm+ytHOePFqY/paQ+YV8
	 bw8lajkm7Bm2daM2ku2OYMZ5yrNTbwT1GZahWWQc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:16 +0100
Subject: [PATCH RFC v3 14/21] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-14-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4736; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=Cb50W6OPktHsm99acng2bApoCrgxkxuR2uk46zCbRyQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7oY0yxeEDzKGg9VZOQDuZoC6+iNuEJp05Dg
 0y3Q58nLraJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6AAKCRBt1cPRWsUx
 M373DAChvGuZ3AJk9EZ3+vHnShE9zNfMzgsSN3jDlyLc46ndxwuyvxED1y5m4/ZBi9RHYT2nEZF
 qggz+o8ZraqrJ525PcbUUGlyq0lfVULWvGia9jcblHKUSuqv6F/mRdMXfn5v9LxlP4Nzo/i16sY
 raH3qKhA3C6aV8pa4mMr+KcdtijnyAt+y/ZNg1BIuR7lW5o7FshCVnLRMz2nEvVGWhL0ejnUHhR
 YLs/wQlG+MTzQLJ1zAtjFN7xyjaKSp4aBrod1/uVxg1wSJktl+e+Qd1Kc7vQN43pS8bTwQ7W7lO
 Z+dpWlfGAldxA+kTXWNGmPfwZm7sVjDdQInJk4xJvf9FNZc+hAM5a/zAGReZdNiuPs0PlIoyw9B
 b5yL9mrlXF0uF9vW7q+V/nqXlBm0ggAJuWPu6G4/luO+gCm3+QGvmGUWYvVAbbu2Bgwj5oYsA00
 7rg7R9wTgQ6ttclGmljukgx6LaC2Ijj/JNHnzqK22lRdOoavZMBjCinZK6X/LioZRu7uo=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56BA6100003
X-Stat-Signature: gid19auwnphd8tz9xuxe9uyu8kea8ntz
X-HE-Tag: 1788350302-867341
X-HE-Meta: U2FsdGVkX1+pADA983L6A+OnDTRVGOjsUWx6AS/eO7LbsvaCWbsdW8Xn/UAcd4y947YuK8e+UNEcFZhTzLkP+FpxPE++Z7gFMA1qzFS4EHTZoJ00+FuVI0k7Zt+V+++2sMTBsNNJIZeLxbm3uxKFRbXzPj2jbx5KFBLaY6hGTXxa51l5yJDM9ODeJ5x7cIzubHJ0NY4rPM4GcSp2kDegvXM1N1aEM2rLXY2c7ZPfmm0pKLx/T31EWDq07AJDJiIG/dsF5r86pKL7b0L05XjIr2CSK5Tw1fDfzhSp5CgnJFmgArJlaG8nkwvdf6rVhyarTsbNP0NLziks9Fp5i2614oWZsF0deKjGKNjs8zMv8oEn9DvIJkL3wqLVB4t0kNY2ZK+Oi8xwcl6H+F1vQAlm5fVwxZOCMOIY06GxH5fNMhmzoSl68WzjR6tTdCb+SafTnM92v9csBNAIvxOsXJBH/WrGzIqdDpyfBeE7Tlr09KZ/8u/ztPIHI988Zo3TU8kTfgPakVwOSTdMY4Pna1Fgii+pQKMODqqvkQUvsnUhPGxrff5OcPCrW+vHr0xtPrwpzVFG8Y0yqu33cpYk4EbQ5aoQxaGXfzwTxWWSFs46P3yIh5auhVKpaCgL0bR534dQ/fU1y+RYd5x819i42zGudUP2Z7g8tarKK/41xNS3vYQHBAz1j0g1L69HZ5pbxXYFrnp05ahg6TefhKqnX9Gk5+HJM17f50nqNewo19RQhTbyvVilT5n/YjeJ4OkkrEk8TMSDVIXVWufg/g4AnWJRRf3KMlhSr4mVxXKRO1KGcYKQj4FllaBqH/c3p9tLDvn5doMrVMwHq4/wVtGO20HL05ldw7ohuwNuAc03KZqY7CNBl7qfHPX9feUXRL/lgbjdziq6dqt5M7PSfM9sQllCK+Nwiq2reyw2yuHNpZJNNIDVpIQ1Wu6FHxTi7l0xhLG56X5nbBXaOsDcvDD5Zg/
 DLiSoqXX
 AspGu67+5kHvexNNXdnElSyPVkIevl8ETrFdNYz2uIu66Y4h/0y0CycjJnGyZ1LSlZnHUxuyKR4QlHQUf9VmsYg0oxER8qnuG0V3q8N6LjkmdMYXAwy1aW5q17kvYjlonj1p3Nlk0vtoZbQEM3I7LbSgSJFdvDzCWvsW13zRAAwOtox4t4xi2AUNv7z64YqjQ5UImbX7pGvVXWXoUwqIbZCbvmoLXL2VZPZVSEXBHirhgWvLqDJjJ1e9oAQbUF+v9VWER5pVp+4VenAGJBRNyyOyHEAdkJnDle0aoY9Vwsbkr1ZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, rework effective_prot() to ignore any
folded page tables entries, as it will unconditionally get called by
ptdump core with pXd_val(pXdp_get()), and the value for folded entries
really should be ignored.

For this, introduce mm_first_pgtable_level() to identify the first real
page-table level, move mm_pXd_folded() in !__ASSEMBLER__ and
update effective_prot with higher_prot only when the current entry is not
folded nor the first level.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/dump_pagetables.c |  6 +++--
 include/linux/pgtable.h       | 61 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index a18a61e732c3..2acbe41eb58f 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -38,6 +38,7 @@ struct pg_state {
 	bool check_wx;
 	unsigned long wx_pages;
 	struct seq_file *seq;
+	struct mm_struct *mm;
 };
 
 struct addr_marker {
@@ -254,7 +255,7 @@ static void effective_prot(struct ptdump_state *pt_st, enum pgtable_level level,
 	pgprotval_t prot = val & PTE_FLAGS_MASK;
 	pgprotval_t effective;
 
-	if (level > PGTABLE_LEVEL_PGD) {
+	if (level > mm_first_pgtable_level(st->mm)) {
 		pgprotval_t higher_prot = st->prot_levels[level - 1];
 
 		effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
@@ -452,7 +453,8 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
 		.level = -1,
 		.to_dmesg	= dmesg,
 		.check_wx	= checkwx,
-		.seq		= m
+		.seq		= m,
+		.mm		= mm,
 	};
 
 	ptdump_walk_pgd(&st.ptdump, mm, pgd);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 3186096a6e13..ed7101a13ce9 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -392,6 +392,22 @@ static inline void lazy_mmu_mode_pause(void) {}
 static inline void lazy_mmu_mode_resume(void) {}
 #endif
 
+/*
+ * On some architectures it depends on the mm if the p4d/pud or pmd
+ * layer of the page table hierarchy is folded or not.
+ */
+#ifndef mm_p4d_folded
+#define mm_p4d_folded(mm)	__is_defined(__PAGETABLE_P4D_FOLDED)
+#endif
+
+#ifndef mm_pud_folded
+#define mm_pud_folded(mm)	__is_defined(__PAGETABLE_PUD_FOLDED)
+#endif
+
+#ifndef mm_pmd_folded
+#define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
+#endif
+
 #ifndef pte_batch_hint
 /**
  * pte_batch_hint - Number of pages that can be added to batch without scanning.
@@ -2313,6 +2329,36 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+#ifdef CONFIG_MMU
+/**
+ * mm_first_pgtable_level - return the first non-folded page-table level
+ * @mm: The mm structure.
+ *
+ * With runtime- or compile-time folded page tables, page-table walkers
+ * effectively skip the folded top-level page tables, treating them as
+ * always-present entries pointing to the next lower-level page table.
+ *
+ * Return the first page-table level in @mm that is not folded.
+ *
+ * Return: the first non-folded page-table level.
+ */
+static inline enum pgtable_level mm_first_pgtable_level(struct mm_struct *mm)
+{
+	/*
+	 * "PMD folded" actually means "PMD is folded into PUD", and
+	 * pud_present() etc. are hard-coded to look like present page table
+	 * levels, whereby pmd_present() etc. contain real logic.
+	 */
+	if (mm_pmd_folded(mm))
+		return PGTABLE_LEVEL_PMD;
+	if (mm_pud_folded(mm))
+		return PGTABLE_LEVEL_PUD;
+	if (mm_p4d_folded(mm))
+		return PGTABLE_LEVEL_P4D;
+	return PGTABLE_LEVEL_PGD;
+}
+#endif /* CONFIG_MMU */
+
 void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size);
 
 #define ptval_to_str(buf, val)								\
@@ -2349,21 +2395,6 @@ void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_
 #ifndef has_transparent_pud_hugepage
 #define has_transparent_pud_hugepage() IS_BUILTIN(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 #endif
-/*
- * On some architectures it depends on the mm if the p4d/pud or pmd
- * layer of the page table hierarchy is folded or not.
- */
-#ifndef mm_p4d_folded
-#define mm_p4d_folded(mm)	__is_defined(__PAGETABLE_P4D_FOLDED)
-#endif
-
-#ifndef mm_pud_folded
-#define mm_pud_folded(mm)	__is_defined(__PAGETABLE_PUD_FOLDED)
-#endif
-
-#ifndef mm_pmd_folded
-#define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
-#endif
 
 #ifndef p4d_offset_lockless
 #define p4d_offset_lockless(pgdp, pgd, address) p4d_offset(&(pgd), address)

-- 
2.43.0


