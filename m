Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B21CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 13:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F3F6B008C; Fri, 19 Jun 2026 09:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46456B0092; Fri, 19 Jun 2026 09:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C354D6B0093; Fri, 19 Jun 2026 09:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 994EE6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:18:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18CB71C1DB3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:18:48 +0000 (UTC)
X-FDA: 84896717136.29.0B89FA8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0480CC0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:18:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dbcn5VPY;
	spf=pass (imf10.hostedemail.com: domain of thuth@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=thuth@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781875126;
	b=NGA1UaaU9Lh5kd9YBBfZTx5rm4QFr5wg7W1tHEDtC2jfumShhqwYMTtAet4OWYuNvGuBNq
	IhZ0MnePw0KLjVgxPVSgaSbb7Senr8htVAmldKCbQhrDhT0JZrv1LnsqMeVb8UTFnzxQvD
	btIO242HjWMropcschOOrV2W3wIe4VE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dbcn5VPY;
	spf=pass (imf10.hostedemail.com: domain of thuth@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=thuth@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781875126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7ZOAURrVgzN4GYE60PJpH05TuPRu7UAg7NhtgxSvWXw=;
	b=RFTVP0JqFr/yXs/kZ2nXjbvA13HRWhTwpp2n8LI7+7P978inafQ/6xmYis8PiUMAQurESz
	U0AsibyGRheseHyaQJaF/LC/LrOIdMBWuZLWVCA6UFrBXoE0P4nIt82MCgcp+2S+rHuocT
	dsKFvlCHm7cDLx2dJIRmMpZc64GkFDA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781875125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7ZOAURrVgzN4GYE60PJpH05TuPRu7UAg7NhtgxSvWXw=;
	b=Dbcn5VPYVKPezxwtJunfFhD3kwvSoP45F55YIAeZKd5X61fPI3uYJUoloIcS6yqkSELg4r
	4hITZzPbsXvACQKsTciaBuxmLunDDHGSRmNw6qlQxecODIVTHPsSZZQ0kwmqjIfWOTT4Zj
	S8MRhxPY9L20aOUX8zJYzEditr3fqfQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-TcR5sl3SO3Cs4Oz-SAz1Kg-1; Fri,
 19 Jun 2026 09:18:41 -0400
X-MC-Unique: TcR5sl3SO3Cs4Oz-SAz1Kg-1
X-Mimecast-MFC-AGG-ID: TcR5sl3SO3Cs4Oz-SAz1Kg_1781875119
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 878031806D37;
	Fri, 19 Jun 2026 13:18:38 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 762F71800599;
	Fri, 19 Jun 2026 13:18:32 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm: Replace __ASSEMBLY__ with __ASSEMBLER__ in memory management header files
Date: Fri, 19 Jun 2026 15:18:30 +0200
Message-ID: <20260619131830.229804-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Z2mkuW1aCbz-Nos01x2WLhaP-biJt30Vs53k7LJyMUA_1781875119
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: beg78dp6b8zm4c31gj1r68q4s4g9mnir
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0480CC0005
X-Rspam-User: 
X-HE-Tag: 1781875125-335879
X-HE-Meta: U2FsdGVkX19Cu7iRV3FvJun6Hgm3Iex+ueFZHhWerE+/SdveR+TrMkx3xIvu2c0ES8JyTSnfwWuDQX8aQK5u2PbKiX4MZ4ZldHJL7y/PmaXa+ErMHogmK18XPD40xsWPQ6rHSZyCbKAKMhimOVCidP68rP2JRr1uq7e4jDiPfJrOpY8WoL/lthQC0Ps5sbyvuVv96OIfsdMENXpp4l71QyfZ8/xUKdcUxg8Qi4EHAv3M5j+b2fzDUtkcgle3RZSyhyRMfJxIJVjpjdK9HvqbfVmliO5b3VJSyv8qB7qRFsRXL+j1vlhvvCV6iwkuTqeZlRTUSE+AJYT9k1cp7dZ3QUiL6zV/2IsTIj8IUttdCqaVyMP47safQkUDmyIZdiC4I6H+tnn8ttdjVZHAwvPToYOus/YxVtukDKI3LuD17XaJtLhBdxQf1gsy9acSWBA8Jf4yxI+9Qq1Kf6R1aHfEDpyfvpIV0ZZIbE4DN/QC6Q0EI/pVAnMfIh7tYSX5kjUEYgARQPg0wW2eCAJ5yoQGUNLkpIB27m0OOTEq1iSlFNXduYnZs77jYmMDhS8T/2v9yD2rZfgHFVj/CvICUDsLW5XcDaJ4Hvq1d8jyv6OFantfgtrlW/kDNLIblCc/yzR+14g8Gn7iH5su5bnGsYb5z2tHir3DgYEih/IuRw+5P6imyKyvAGWgxIn7WZYfyoAiThadT33OfY427MV0AFZbhRC/eZfYa6TX2i/NM+cMNBP5dbDvAikCiVShzKPiYiPfA0dQwP6wb4VEfQKo0p/DfZT310/hE/iVcRDvT0uLdZVHsMpxSbVWtoW+MeXPBVbQmD5dQD6V4AzehmmAZJ+Vx5OGLAX1+pVzOG0zgwTDo8REyQ7c3yYvlWZYAIKWRAo9HDN1o+ReWC+Sl/EoWlCeZOP1E9yVv71XT+Id2yI0Ce+5HcYuFwmh7C/AQLL/gClNLARJLgNsd8nMagl05tW
 wwm1iR7i
 fuJceiTlCJ+DS9OPVJfGCIkFHo4+OSKgxpXEYg6GRxxRv6aKik4os+wj7nc9kB2n/YHppyb2+1XwdCdqO5qr7RTpGx7L3dOPjDLUB+OhmienpshoCeQgnPVAeiKF6VLpzAP3dshSaonfJAz2oSD8pxU0YVeoUqWkq9JWY6iukox4gwy1TTQgcerkfI9fvWg0xh9tPOjUIhLjMvhNYQPqOr8iyXtQN0cYy9M/8nSK/CkUAwoh5+2unyTV0KsyJD/hhYR+7nLfwM94LMpn883/37JoMWl6Ssffq/5y62snJp4DoE6e3fvn+BzttZfC93M4VEzmPCQCNFaFA9xZalYoSJkGqmKCsjgFeceTu3LgJd7L5i5HxXGrSNk0mo8GNzSNybnDJVWVZGmczW+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thomas Huth <thuth@redhat.com>

While the GCC and Clang compilers already define __ASSEMBLER__
automatically when compiling assembly code, __ASSEMBLY__ is a
macro that only gets defined by the Makefiles in the kernel.
This can be very confusing when switching between userspace
and kernelspace coding, or when dealing with uapi headers that
rather should use __ASSEMBLER__ instead. So let's standardize now
on the __ASSEMBLER__ macro that is provided by the compilers.

This is a completely mechanical patch (done with a simple "sed -i"
statement).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Note: This patch has been split from an earlier patch of mine
 to ease reviewing.

 include/asm-generic/fixmap.h        | 4 ++--
 include/asm-generic/getorder.h      | 4 ++--
 include/asm-generic/memory_model.h  | 4 ++--
 include/asm-generic/mmu.h           | 2 +-
 include/asm-generic/pgtable-nop4d.h | 4 ++--
 include/asm-generic/pgtable-nopmd.h | 4 ++--
 include/asm-generic/pgtable-nopud.h | 4 ++--
 include/linux/mmzone.h              | 4 ++--
 include/linux/pfn.h                 | 2 +-
 include/linux/pgtable.h             | 4 ++--
 10 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/asm-generic/fixmap.h b/include/asm-generic/fixmap.h
index 29cab7947980a..3ff832ebcea50 100644
--- a/include/asm-generic/fixmap.h
+++ b/include/asm-generic/fixmap.h
@@ -21,7 +21,7 @@
 #define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
 #define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 /*
  * 'index to address' translation. If anyone tries to use the idx
  * directly without translation, we catch the bug with a NULL-deference
@@ -97,5 +97,5 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
 #define set_fixmap_io(idx, phys) \
 	__set_fixmap(idx, phys, FIXMAP_PAGE_IO)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* __ASM_GENERIC_FIXMAP_H */
diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
index f2979e3a96b60..875ccae196832 100644
--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_GENERIC_GETORDER_H
 #define __ASM_GENERIC_GETORDER_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/compiler.h>
 #include <linux/log2.h>
@@ -47,6 +47,6 @@ static __always_inline __attribute_const__ int get_order(unsigned long size)
 #endif
 }
 
-#endif	/* __ASSEMBLY__ */
+#endif	/* __ASSEMBLER__ */
 
 #endif	/* __ASM_GENERIC_GETORDER_H */
diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
index efa6610acbc79..fd74de50b0540 100644
--- a/include/asm-generic/memory_model.h
+++ b/include/asm-generic/memory_model.h
@@ -4,7 +4,7 @@
 
 #include <linux/pfn.h>
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 /*
  * supports 3 memory models.
@@ -86,6 +86,6 @@ static inline int pfn_valid(unsigned long pfn)
 #endif /* CONFIG_DEBUG_VIRTUAL */
 #define phys_to_page(phys)	pfn_to_page(PHYS_PFN(phys))
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/include/asm-generic/mmu.h b/include/asm-generic/mmu.h
index 0618380375429..5f78971e3ac2c 100644
--- a/include/asm-generic/mmu.h
+++ b/include/asm-generic/mmu.h
@@ -6,7 +6,7 @@
  * This is the mmu.h header for nommu implementations.
  * Architectures with an MMU need something more complex.
  */
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 typedef struct {
 	unsigned long		end_brk;
 
diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 03b7dae47dd43..89c21f84cffbe 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -2,7 +2,7 @@
 #ifndef _PGTABLE_NOP4D_H
 #define _PGTABLE_NOP4D_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #define __PAGETABLE_P4D_FOLDED 1
 
@@ -54,5 +54,5 @@ static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 #undef  p4d_addr_end
 #define p4d_addr_end(addr, end)			(end)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* _PGTABLE_NOP4D_H */
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 8ffd64e7a24cb..36b6490ed1808 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -2,7 +2,7 @@
 #ifndef _PGTABLE_NOPMD_H
 #define _PGTABLE_NOPMD_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm-generic/pgtable-nopud.h>
 
@@ -68,6 +68,6 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 #undef  pmd_addr_end
 #define pmd_addr_end(addr, end)			(end)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* _PGTABLE_NOPMD_H */
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index eb70c6d7ceff2..356cbfbaab247 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -2,7 +2,7 @@
 #ifndef _PGTABLE_NOPUD_H
 #define _PGTABLE_NOPUD_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <asm-generic/pgtable-nop4d.h>
 
@@ -62,5 +62,5 @@ static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 #undef  pud_addr_end
 #define pud_addr_end(addr, end)			(end)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* _PGTABLE_NOPUD_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da59..d0cf5c697548d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_MMZONE_H
 #define _LINUX_MMZONE_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #ifndef __GENERATING_BOUNDS_H
 
 #include <linux/spinlock.h>
@@ -2400,5 +2400,5 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #endif /* !__GENERATING_BOUNDS.H */
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 #endif /* _LINUX_MMZONE_H */
diff --git a/include/linux/pfn.h b/include/linux/pfn.h
index b90ca0b6c331e..cfedf0f61bb3c 100644
--- a/include/linux/pfn.h
+++ b/include/linux/pfn.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_PFN_H_
 #define _LINUX_PFN_H_
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/types.h>
 #endif
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2981e386da7b3..dc804296d78f7 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -8,7 +8,7 @@
 #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #define PUD_ORDER	(PUD_SHIFT - PAGE_SHIFT)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #ifdef CONFIG_MMU
 
 #include <linux/mm_types.h>
@@ -2320,7 +2320,7 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
-#endif /* !__ASSEMBLY__ */
+#endif /* !__ASSEMBLER__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
-- 
2.54.0


