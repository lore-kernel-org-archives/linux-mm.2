Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66FC2C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639EC6B0096; Mon, 31 Aug 2026 01:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C34E6B0098; Mon, 31 Aug 2026 01:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4649C6B0099; Mon, 31 Aug 2026 01:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA596B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:43:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8772B1C1E66
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:48 +0000 (UTC)
X-FDA: 85160472936.18.32623AA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB31A180004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AgDK4gG1;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788155027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vC0AdXN9AInSTcYtPsX1sQWcKplWSYNtXUaddP0LnyU=;
	b=gKsFz2qIl2G+pGsNSZfn11L6+RNsMh8tQlAXiLzamEUXriAZB5Q5V/Q7J7RAgeq7M9HMoL
	Zwtuv5YU+X/u4L/0+K0SZ/H2KR4jDFP04xxxKLhFp8+8qsUm8GgcQ9n01vXXmJ5XRRge3n
	Rw6aG9BCU1nWTVZCYenVKMbNODwhBoA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788155027;
	b=P0lbXa8PRBttTEopiOcnUfUrvwfH+U+u/MHF7rYkJhGoHNUZMaUsM2oQyvHV43foLPfVX1
	BvHmIe3RWfI7js9ZrRvJUWGgXaRzB0s4mE+whv4bNuCBZr40i7Nx88JKjDdnbdZrQYyqCZ
	j7Ce4tGopLpic9aOF2E0T1SynAoEtH0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AgDK4gG1;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1783419F0;
	Sun, 30 Aug 2026 22:43:42 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DC573F85F;
	Sun, 30 Aug 2026 22:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788155025; bh=MRpwBQolgZx1ZwHSmSp6+RbqpKwfTCpBNzioH9bhCJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgDK4gG1pVEjHbGnLFstkXRbQkc6tjZ3ZECUEyq/VeI1J9AzoNicjdQZP4HJ8Kvk4
	 3TXh2zhKUhfWWSAzn8A6D9O2YljapP5Yo/mEFuIROb8kjVzJTM112mGGaKINlQH5eH
	 hNcsn1bxAJ0UwDcOKskNwZcyK6BDzUFItaGQvZxA=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: samuel.holland@sifive.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] loongarch/mm: Stop using pte_ERROR()
Date: Mon, 31 Aug 2026 11:13:25 +0530
Message-ID: <20260831054331.625505-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB31A180004
X-Stat-Signature: t6pgbhbuob19m9g9oyxdaa5kqzdhmqxr
X-HE-Tag: 1788155026-708118
X-HE-Meta: U2FsdGVkX19AtQ4NzOSsbI2xxBRcuOwqbthGjzOVlc1dgG9ZddkjhcZG/pKq/OOw//g9N26JU9Hpi4LvnsWlv7lLNEmh6mC1NQnaYqgzSKd8j1L4j1bO16vJmefSdV7GRycFvDRq1JEoRd5h74aHx04oCcdqUMRLh3lbRd3jiL9NUd2rqKQElc9eVQK32qKeuGxFSIMB6qGUks2pcWP0kcg3YVrO8+b/bDmo9xGkCvTAOJUvSZk95N754LpN/YWBsId7f1IFxHTrRTYCClNFx1Q45/BRX+oI4K5cCbnwlY7cvoG0/rWapIA5SzWYk6EcCNPnMOE1kqoJmWVUvJTma+Iy919CujY4XHIclG5W7Ugul2tLut4pDChUfki1xDJn2gAR0KkgbeNJhILlwr3vJc/0cW6g5Rr2meYZn+4puD3L1SrWltp74/oEyAukG2PR1MBoWZ+OZqKHSAvc743I9FDBa3bqWkxOhQPvI5rCM2d/KPeo2S9Pk9LellDWMvGKJA29B+JpVLAb3OHo0iv6VAy9p3q/gA1HYN94jfaAMrX2MX4bdUjcNo5YdshQgVTWIe52PNP5WminhQ2MkfWsdf0QDPKkODhMXA/EvO/ki2Tvb1tkdfuTq7rB3cq9coLIAf+FAm9Ak8gooV1Ym3+owTVuBB0+BSQCzryt++VeiL2aRGkGZEHexd7c1uLF/HdtkrF6be5+hpb6oTrQg4MkP/X6Ci/Nbdd4f8jVuFAhMT6l78nJOv5ARHxPPTBFwRelATT6bH1pf27H+XQs+QKaXgrWj7I0MVL+tQejzJtvRSAxp2yaZ9YC6PyFUQeQMzdFmLARf5Pjv6HCWVPGyZfjTYm1kodeFLTK+L86o15o/s/2/l2w3B6yswpOD+2hoY/ejZ3Qn502iy/wzahdomj4nPqQatERz7b/PzrXN4AZd0pGeFU8bcKbx8yCCwFEji4wF+GEimjprjWy8q7FgQa
 P/UQhXvG
 eJv8LKr5eOfS+TnlmRWwqWU9pKU6ImlpD7sBSCxOTh89AS66ATGredKzXkxU7KXFj7UGRNwgWEJthATHyiKaaJVaDMAJAx97E71NLY0eFVChBLSmkfWzwMv0I9eMlo44vf4EqwKcAPpL3hvwR+FPfE4pYGKTJin3eibMI0NwO+O1jShspwo2AqGARvszOuePZBfPgx4mrZT8kbCXewtoOW1KxokfMcxj15YsYdGCQGxvnLx4siXx4Xhk+OZdN1ST6RhUBdBi3U6h0QbotonSptkBbWrlcJ3h8L0hkb1zR6ldVVwrtR3eHB8viU6+myfF5fhNI5Qr6GBOdbT73zYBhbfrA9sR/8v0Gd0llAzti48Ap8nVjOTBiwL4VfhXCtbGNYn7fkVCajM/7nll7sgR7aRTiiPX/I9mK99mZBnapB/U833AsTv4MWDBUmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Directly use pr_err() in __set_fixmap() and drop pte_ERROR() which helps in
eventually dropping pte_ERROR() macro across the tree. In this new printing
__FILE__ and __LINE__ has been dropped because they are always the same and
don't really add any value. The new ptval_to_str() helper is being used for
converting pgtable entry value into a string. The error message itself has
been cleaned up as well.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/loongarch/include/asm/pgtable.h | 2 --
 arch/loongarch/mm/init.c             | 4 +++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index a05f6a4928dc..eddd8906b77d 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -135,8 +135,6 @@ struct vm_area_struct;
 #define ptep_get(ptep) READ_ONCE(*(ptep))
 #define pmdp_get(pmdp) READ_ONCE(*(pmdp))
 
-#define pte_ERROR(e) \
-	pr_err("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
 #ifndef __PAGETABLE_PMD_FOLDED
 #define pmd_ERROR(e) \
 	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 4b46c5d30708..f801f7097f03 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -197,13 +197,15 @@ void __init __set_fixmap(enum fixed_addresses idx,
 			       phys_addr_t phys, pgprot_t flags)
 {
 	unsigned long addr = __fix_to_virt(idx);
+	char str[PTVAL_STR_MAX];
 	pte_t *ptep;
 
 	BUG_ON(idx <= FIX_HOLE || idx >= __end_of_fixed_addresses);
 
 	ptep = populate_kernel_pte(addr);
 	if (!pte_none(ptep_get(ptep))) {
-		pte_ERROR(*ptep);
+		ptval_to_str(str, pte_val(*ptep));
+		pr_err("unexpected set PTE at %lx in %s: %s\n", addr, __func__, str);
 		return;
 	}
 
-- 
2.43.0


