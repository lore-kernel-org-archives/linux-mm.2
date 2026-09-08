Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA24CC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11256B00A0; Tue,  8 Sep 2026 08:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8DD6B00A1; Tue,  8 Sep 2026 08:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD80D6B00A2; Tue,  8 Sep 2026 08:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AABD56B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:35:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AECE1A066D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:35:38 +0000 (UTC)
X-FDA: 85190541156.15.95D588A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C4408000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:35:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+cwUMT+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpWdcIey4xCI1AAiZQP3vw2H/6eRNpO9q4dcacOYsLQ=;
	b=Xa07hSagHChiV2ojzGFoy4pgn+oI63cwNjuXzXOtFQtahuRhYTx7RVDRr7pvIBpr0DaJFo
	FMmvJJdenTI5rxuWIjK8BWMYaZLBZV6IGzz2qLr3AR3roNDuMivmh4BSUJjxTuMyeqKs0Y
	VOJ7y7u6dXyLPmKFido2kYRWdNVDRug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870936;
	b=XnqXSvhCAgitxNmGVdoL5gk/+W0YjU6lPE1EtXw3O3f/45eskeQJ322lq8n2wkYrfZKjiL
	T6fd4fkmndSygmkl12VszK7oiVbhTU36TlMZcs+uKgZN/BEAeXyGeH4seCy0WOrgOgnOCM
	Ic2NV77yhS43Vo54avom6rWciZy8foE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+cwUMT+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33EFE601DB;
	Tue,  8 Sep 2026 12:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB33D1F00A3A;
	Tue,  8 Sep 2026 12:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870934;
	bh=NpWdcIey4xCI1AAiZQP3vw2H/6eRNpO9q4dcacOYsLQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K+cwUMT+d+8/P/ENQVo8DJwc6HGv2hQO+Baa0naUwE3kAv1rdlgVz2F0JO2otmqsR
	 5iVklIoB7Ri1NDYRWUl76IL47aSyqJrEU+u2MYBj8KejAvZPwT5M0haV6fwHhu61vX
	 hsKmaC5ibrBpStRjPAB/CeZK6AIWwFpISbtm/LTupqa38eQL+EnkABc8GbZqBsS5dN
	 +zWduJuI52AGrGzXleklgVXoZYAZjiHlT8oOhs7SlWXTdgPIATE7ETJoX8t3oe5ICQ
	 cyDq/JnMwFgjyW+BDQ9vDogwSEYfmD3c4PNUaUr1MGiwFNeGB/WSLVO82a3ha+ANYN
	 B9N9mrikFcAtQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:17 +0100
Subject: [PATCH v2 08/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-8-1f60b64e878e@kernel.org>
References: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
In-Reply-To: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, 
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4126; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wpROf24w3fAQ7cNDxi2SGsbF1TZYrv0Ll+LdZO5C4PE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMMS4lVQbvv+3RX2Wkqdg2b0oK+mVS0I3JzD2PHdKW
 pydFzmlo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABOxX8nIcFK4ov8A47aDvveq
 z5q9aj+5p1/U9/UxxmeffPW4BVWU5Rj+B3L/PBGjOLXqWdbBCq85k42q9/08tXTZszu/eG/F/J1
 exgYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C4408000D
X-Stat-Signature: 9tb18yythoijei8ntstfupj55jwo1m8m
X-HE-Tag: 1788870936-176288
X-HE-Meta: U2FsdGVkX19r6YytwPwt/QeRdureHeqlxgp7n4Ima8AQ+6CapyJnRg8PsVsqddQIh4w2zU4cvDQKB7g5bo3MPn0TrDp29NEbbEt4xImZyAGROdw/5gJgCj3XfxYfjzSWGk+BcQ9U6sGiixqSd8cOH5rTx3HdXzkIX4dbvWSit9OXqGfY7tpZWqyop+5o5tO7y0gTAudWbGZP+Twj0lKYl20RJNbYYcmrB0GK0YxMNeM0Kn3QedO8ju7rkjK+meBAopkL0WERi2MX6zAZlAvlv6hLi/+dAo5maT8YsrUFs2WuTK4MtjjE98ab+uj/MMIBa5zq+eWjZeyHf7GG+cA3YAUttUlb8GeICmdXRF4Iac9JxrHYOLf8485PUivMgVevV7Jh5Cj4kg/BW55PS60Zy2iO5Bs37c1V/rWMHUibGlTz/EqQV7C6enRP2rt07FCN7FmrqCVUpTno7HejtW3LCgilGaVfRMgF5Tp3CjwJd6vX/9WopDbXa97LdZ3qPHdQ8onHJBRLUe+iJp14Z8jxc2HylfBftjkSIuA4kkAoWb2WzLaHCNQJ+po/BLqm0OoUhX2o4AI8bpKQx5ysF6jbZwrWeL5lQK5g7ekrhsDLpYX877MA6ZC7P1UoKysCYpzfj9oLBgLllo1qicGlPzX3VcAdkpHAUKlmzsQmAG9JBb5y5foI5JpyHUCSBXU01qKe+yi0sqK13ITV6WAuOrZvXg1hlV0aibPlnKpT72TEbo9rYn2tEIJNSnZYQiNgAHC+LxdSM9KUTDPDgi+9LdbD9ZfObA5lvRXLH7g3vNU9I6iiyMqNXJKo+YKrg0hbWJcKzs6Z3UmO07BQX+jkqQAPO0j28ZspTY3/uwQiBjmTt1TfG+lXUl5+u2SoXxIU2+WMXFgwAkbdtiov8ifDa2vhu5EF3Ivu27kJ5EWWPJB1pN57NGhBy6ZWG6nM1HyKXoWzKWnK8+zB+QlpVJ08Rlh
 Iad6tbSo
 yOFMJMkYABEHiwOzaw9vmovzVs8eu8YmAYHlSJgCE+Ii5pc+foljptqFoBgy8QNmyV6q28pXEldCVe/+OMoxkgFzNbkWkV5OkHghRpaV+Cxqv4dzsUPJSMoKNSejtCM+50mlwoW/7BT+zUbuK5FvkF6K4MW4A04itaPzkhsMb01trFb9AngSgzBsAtaYwo2HWvGB/vzikCQoCILNUeUVTMrRoWxKBTaduj1vy4XlEfENPpgRGJgKN46WrBLb09zBBQD4MIrjqbu1Svgar0RTg4dLtlM1Nc+CvLk5q/IBrLnQhk2md0YEh4O+dU89caIxjJOvb9ZBAdow9UUtPKIQ0um3TkoW1jW3Q/J5VJvLxpx6wofnJ9vVKiwimOI7lATOcyPZVpY3yZh5RbQuFAep8O/cYJHoc879KJJ5CPYtL8WUJCnXDXVNjUEuZMOjrP+7IvazsUeNIq8Z8lEbO+kGTt1/MOIBWrkbWCj3qW2Ich5nflIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, non-x2 sh specifies CONFIG_MMU_GATHER_RCU_TABLE_FREE allowing
RCU page table freeing.

sh-X2 is problematic because it utilises slab-allocated PMD page tables,
and thus tlb_remove_ptdesc() cannot be used in these cases.

All other sh variants are fine as commit e3ecf7c7d082 ("mm: pgtable:
convert some architectures to use tlb_remove_ptdesc()") already converted
page table freeing to use tlb_remove_ptdesc(), which does so after an RCU
grace period when CONFIG_MMU_GATHER_RCU_TABLE_FREE is specified.

Resolve this issue by firstly specifying CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE
for sh-X2, so the arch can provide its own __tlb_remove_table()
implementation (called after the RCU grace period).

Then, convert __pmd_free_tlb() to tag the pointer to the PMD, and have
__tlb_remove_table() check this tag to determine whether to free via the
slab or to use pagetable_dtor_free().

This follows the pattern used by sparc64 as implemented in commit
4a0100f7546f ("sparc64: use RCU page table freeing").

Previously __pmd_free_tlb() freed PMD page tables immediately, before any
TLB flush IPI. This seems to be a pre-existing bug, which this change also
resolves.

CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is only specified for sh-X2, as setting
it disables CONFIG_PT_RECLAIM and causes __tlb_remove_table_one() to call
tlb_remove_table_sync_rcu() and synchronize_rcu() in turn, and this is not
necessary for other sh variants.

This forms part of an overall effort to switch every architecture to this
mode.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/sh/Kconfig               |  3 ++-
 arch/sh/include/asm/pgalloc.h |  6 +++++-
 arch/sh/mm/pgtable.c          | 20 ++++++++++++++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 204f64912f0e..75236bef6f16 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -33,6 +33,7 @@ config SUPERH
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_TLB_REMOVE_TABLE if X2TLB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
@@ -61,7 +62,7 @@ config SUPERH
 	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_FORCED_THREADING
 	select LOCK_MM_AND_FIND_VMA
-	select MMU_GATHER_RCU_TABLE_FREE if MMU && !X2TLB
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_RELA
 	select NEED_SG_DMA_LENGTH
 	select NO_DMA if !MMU && !DMA_COHERENT
diff --git a/arch/sh/include/asm/pgalloc.h b/arch/sh/include/asm/pgalloc.h
index 6fe7123d38fa..67ce7fa23fa1 100644
--- a/arch/sh/include/asm/pgalloc.h
+++ b/arch/sh/include/asm/pgalloc.h
@@ -17,7 +17,11 @@ extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 extern void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd);
 extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
 extern void pmd_free(struct mm_struct *mm, pmd_t *pmd);
-#define __pmd_free_tlb(tlb, pmdp, addr)		pmd_free((tlb)->mm, (pmdp))
+extern void __tlb_remove_table(void *table);
+
+/* PMDs are slab-allocated, tag so they are freed correctly. */
+#define __pmd_free_tlb(tlb, pmdp, addr)					\
+	tlb_remove_table((tlb), (void *)((unsigned long)(pmdp) | 1))
 #endif
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
diff --git a/arch/sh/mm/pgtable.c b/arch/sh/mm/pgtable.c
index 3a4085ea0161..f6184b86b89c 100644
--- a/arch/sh/mm/pgtable.c
+++ b/arch/sh/mm/pgtable.c
@@ -56,4 +56,24 @@ void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	kmem_cache_free(pmd_cachep, pmd);
 }
+
+static void __tlb_remove_table_slab(void *table)
+{
+	kmem_cache_free(pmd_cachep, table);
+}
+
+static void __tlb_remove_table_pgtable(void *table)
+{
+	pagetable_dtor_free(table);
+}
+
+void __tlb_remove_table(void *table)
+{
+	const unsigned long addr = (unsigned long)table;
+
+	if (addr & 1)
+		__tlb_remove_table_slab((void *)(addr & ~1UL));
+	else
+		__tlb_remove_table_pgtable(table);
+}
 #endif /* PAGETABLE_LEVELS > 2 */

-- 
2.55.0


