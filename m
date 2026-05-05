Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2DBECD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655796B00E6; Tue,  5 May 2026 12:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605EC6B00E7; Tue,  5 May 2026 12:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4B26B00E8; Tue,  5 May 2026 12:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2F36B00E6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8CE31A03BD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:36 +0000 (UTC)
X-FDA: 84733849032.18.1F8CF5F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id E40CD40010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SF6Ni3DH;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vd4ZUQgM8P2GyadStQQNoCo66Qnx/0mJN0Vgcwg0f0s=;
	b=vH7ja7GWfF/QIoa9UlmcuUcYJg6HHCHFDWwGYKFWP1wS9bKzz1LPZqGvjx6Cuac5WfCgxI
	BZ7nmDe+0NMA1RG8tNUR7m2THrbV1QP7okX+EunRvBHghlOF5fBJwSaE0YBIpX4KQ/d3bW
	pJ8xWgMIz5/JnJLRyZYucZlnLi4Pcbc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SF6Ni3DH;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997315; a=rsa-sha256;
	cv=none;
	b=f1nKWxeFce3FLoiJouylk9GMg/J4Y7oEjzUGQS+mGSHKq7zZBPXtvA8GZck2l327ZYl95x
	G2AKgZTCUkhG4R+9bwFMG6WRNfN1HY6kiJrKbdIE0yteT8WykvbO/SaxK5QcJDA2+PePpQ
	Jmo0mt2cgOU+BcSt5Yqh3Nn5mSU0LIk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9588814BF;
	Tue,  5 May 2026 09:08:28 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF7AF3F763;
	Tue,  5 May 2026 09:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997313; bh=0t/i/af7XbPJAM8LRw7f7gNVe6Lqn8pDjULpf1JYXBk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SF6Ni3DHfg3cr3g1wGonGVfVeGZWjyIIj12L52MNiRx7v3ly3BLW5woW8lEXXJrEB
	 Dg3rAyjjcetccCXjgz9E4QIJYNmvaXRK+YXjWoHRtd+5kSyH9d5NFlgf3kj7tXVSfU
	 mw2oS1KMTotj0U/1TXo+uCvRLQibhnRnRdiOE5To=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:09 +0100
Subject: [PATCH RFC v7 20/24] arm64: kpkeys: Protect init_pg_dir
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-20-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1970;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=0t/i/af7XbPJAM8LRw7f7gNVe6Lqn8pDjULpf1JYXBk=;
 b=8O9rU2WpeFiig0WwB/55Pw3dRg5PB0MCy4d/wM+xL2uu2T2n6EVglq54KE7Cu8c6GFeCbvk4c
 2rsHMMhC1tOBX3m4pUGvVy/6bqpBhQunPbd4GPrmI/Jt1MJl9FO4Or+
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: syc6fzfkukc9b75f3enuk6hy6hucjppu
X-Rspamd-Queue-Id: E40CD40010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777997314-215948
X-HE-Meta: U2FsdGVkX19tu5L2FdlvTJIG5mIeXf8kfrgBMVVxVP2nN5rbmyQsEPFi3eNtNF8+NKjKAFrMLVMlu87IMzWCUMXXTJCOP60cv4taRmJzTW0PXuTxVAp9517kNDKYAPuhns13y5l8Lyzm84lVW26sKqK7GrhHTVRuAMZ5TQlOY+3UfcQS4C7YFEQAtYldeYyHWX1L/ndR1VzoKVCmlWOfoyORm6NYtP6boVgMHxwdMNwmtRr+8VYBrnuqK6stygEg4pag24h5plUzlmS/yoQKBGfEbkU4bVsqZPzWTTuATov2mTLQonBDgj0lq6ZmKNo3OPzYqmM8nhR2Te1zJUl92/sFO7Bu7P/zqB40eFeVzqfdawarKGpaUTbOwjMlhbP9Nf1dxFeEEg/+MRALTwAvK50JFZrJleE0u2j0OpSYYPDyoRIedIKCZOmw+7PNJaIpAsaWFFmfIysHh8A02xx0BXk5c7VFOYpUToDYBCjNM22F9IcMSNZubpylbaygXXnKyTXOIZ2GCx/9VEYKenF5zj2JfyZd+c9blqn0BTFnXnJFg7GNo2n35TFor0qYz/vAO8KKFT8rtSKLBHmjfwTCOWj5lwtSJdpSTkZx6QJ2ymOyxihqGDhxgmSWZVw7io9kGsQPpc8T5A472GCexOuHZDtp52vBMYg5W/kxKNojtcAenCQprcyzExnDqFa0CPQmsskegJmlf7adzc0BjC07MUYdLr4kHskaNN7thh8OBZwrSRr3JB26ATa37PALvwD+Vt4dXtIKaFQLJ4oQPQAQASTRBNPiq21qS3UaEy/lf7mNESTn7qt3+fFXN8ehvau7QhuhHqbUOk7BD7fFvmDm8dpNWGExZ2zWnfi+Jtf8H867MVrZ7urNH8DbTa5YER+9OfJMtKfVacvAVDP+GXtMagr1EOadJQlUOHrvn6NZUbaA6Xkuv1cIWug4JGx/2XWLtQX+Okv9IVaw++9NKEE
 mKpxcvo2
 8SuMTDovJPgAJiS8iLfTvKotN8KbMKRNR2WBrP0w7u96+pQXUFXDQDHL1J0rWZ5/sTZrC9q4s48CZxcXnEcvtXjWb6RDmwrkDmUF0mnoFpUFCgql+7U89wMrhsdqbIjFP7+Z2FGC09fBIde3AVDw0jX9MDqrnMTP9lLd3dNSsYuvUUq64w2f4nyoxE289SpfDA33zypQEb29JFWD1o1NElM7bOvAmMXgxElvhYyMxdxjiGMIax+Ui/J9KFcW5SC6hnH7GS2eja5jyfXrka1tOLIT/tvjM44qyWr4iaR4zF+tVfvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kpkeys_hardened_pgtables is enabled, protect the page tables
that map the kernel image by setting the appropriate pkey for the
linear mapping of those pages.

Most other static page tables (e.g. swapper_pg_dir) should be
read-only both in the kernel image mapping and the linear mapping,
so there is no need to change their pkey.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h |  7 +++++++
 arch/arm64/mm/mmu.c             | 13 +++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 0c155b970582..71e2035566f4 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -64,6 +64,13 @@ static __always_inline void arch_kpkeys_restore_pkey_reg(u64 pkey_reg)
 
 #endif /* CONFIG_ARM64_POE */
 
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+
+#define arch_kpkeys_protect_static_pgtables arch_kpkeys_protect_static_pgtables
+void arch_kpkeys_protect_static_pgtables(void);
+
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __ASM_KPKEYS_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 4b9218483dd2..28100ad547e9 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1055,6 +1055,19 @@ void __init mark_linear_text_alias_ro(void)
 			    PAGE_KERNEL_RO);
 }
 
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+void __init arch_kpkeys_protect_static_pgtables(void)
+{
+	extern char __pi_init_pg_dir[], __pi_init_pg_end[];
+	unsigned long addr = (unsigned long)lm_alias(__pi_init_pg_dir);
+	unsigned long size = __pi_init_pg_end - __pi_init_pg_dir;
+	int ret;
+
+	ret = set_memory_pkey(addr, size / PAGE_SIZE, KPKEYS_PKEY_PGTABLES);
+	WARN_ON(ret);
+}
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #ifdef CONFIG_KFENCE
 
 bool __ro_after_init kfence_early_init = !!CONFIG_KFENCE_SAMPLE_INTERVAL;

-- 
2.51.2


