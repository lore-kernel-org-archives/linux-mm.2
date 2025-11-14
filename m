Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88230CE7AB9
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4EE58E000A; Fri, 14 Nov 2025 06:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFFAA8E0002; Fri, 14 Nov 2025 06:13:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3CE38E000A; Fri, 14 Nov 2025 06:13:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3E3D8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:13:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B5C212DE47
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:47 +0000 (UTC)
X-FDA: 84108952494.19.A8F7A4A
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7D7E140003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vExdq/0Q";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6T+2Lant3MYurrTyX3sjQxVkxrSJ5NC17wEIBzsAD8=;
	b=H5QgU5E2NS0tnjRru/txF3NH3INiTQYtzLzZ7ZvMcCLc42V/mcnTZegp4XkF8ZQ9pVvQc1
	x/RaGyggJjodi7kvkI/YDsnDFKzG0sIbGipU9SUtfcs71/oGRH7roWDETs4+bs7pzH4ikN
	R3xh4WQ9ZpB+4TzRWNUM/0YInBqene4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118826; a=rsa-sha256;
	cv=none;
	b=MdeShp5qvX2o9sNgMMn3fRy10BqlmihUUTev8Ov/2AynhwvtT/W38AFPCWgh5ToLBOJ07g
	Tp/8E/7C3kqyN31m52XV5y49vZvL9VsUz1BNKEpccEBzcZ+/P48KzepJdaZWDXqyH2uEnT
	c3rCbp1TL8cnrP3vvc7fmglYpkzJfg8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vExdq/0Q";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763118824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P6T+2Lant3MYurrTyX3sjQxVkxrSJ5NC17wEIBzsAD8=;
	b=vExdq/0QIbNXwYGHrXQqTUESTgynxZF1NJ0xtYYbpdRrZ58EdRub+KFh9R2nimgCQ5fatR
	4xLlVhyB6VQJZcD/sz1r9N+vzLfWl9ZUNEJ579ag0IteNR33li8sNEYMRTdhUYVjBH+SAv
	KC18Vm38wa/0lScGVl1ZIZrfKVIfEok=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Vineet Gupta <vgupta@kernel.org>
Subject: [PATCH 2/7] arc: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Fri, 14 Nov 2025 19:11:16 +0800
Message-ID: <6a4192f5cef3049f123f08cb04ef5cd0179c3281.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763117269.git.zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sfhdjmfktdtd43oedjwpmnjyff9nt455
X-Rspam-User: 
X-Rspamd-Queue-Id: C7D7E140003
X-Rspamd-Server: rspam10
X-HE-Tag: 1763118825-76995
X-HE-Meta: U2FsdGVkX1/LW0dwdJwAKj2KShfwHr9SUgOxaO2G+5xA1Evz5mp8KhYIRzPJ+W85s2zG34ApV2UGleuCXZ1h9QEFTHdjhV9uCcnfAzilGQafSoxnq3hNN975V5dlolYFaEnwycd+438g1KN9zqu0EpvTXWSTVdvcfsKiacK0ijKK+nNspUpgT815WYz6scy+VddMxRSwBUTZnilRUwC3/mu7pZ+dXz7EtpCUHKCmn9zJ8GTt19wJX7oAr95raWv3gHUDFlIS7ZT5lSmMLAPIxmjv6JfO0K2Ymciuj0jfxmNrUOev4YBX5hFnPgZIQ7t76PplF8y7CulxNUbP37EaPVbwPnErGJJAyi6hpgIwF3IojIqIbDQk2USikMRGfaTmJ35tJmWK1TOuYgds2im3xdwzf9O3Q/EU6OpNtWqwR8o6tKZxkgLlLvDAgp7eEmq6WjAMGxQVE6x3oeGXxL3fMSZXKVNl3As8u2bXKXIZpx1X0H1mJEnz6hgWZOYoHx7mJJejk5f2pqT7g5uGQlOgcZSsdjWmHA8c3uWDgpN7Qphoah155jyGwlDDtsPexBLUVs7IrUUSCm7ZTNuGKNZUMij5D225VBKL3nnASzjBtAWFg2Ccq3+nWrtfaYT2z+48dtYN2ZFegX2mWMczUL0wqNPsjlYqvh9KLk7EeG5YZ55cjfUaQVa1iR5wed73vYiudXi4PCfX3PLx7pyouNK4AqP/jqUvDPdAjC02he+RjIp8GGENMGah0p2pcODaPRDxLj5PgT0fhOLjUgQ9zE9UC/f4XFnwfZi1rOCxpnMyMvMd1fM2vGxALNX2kryPa1kBxijQ+wlyYIsLb8mYkZMucILn/7kfiIN0LiUE0LMpCHAH+XRAhU0+cqQcFBXcmxQcBpWzecm+kZLc4loNN7Bx9IY8bYfWnZZeS7QfE3CPfwfgcIFO4B+OBiim/JyfI9Zs/6xP+9F6nUKdVdE3Iz0
 igo/LVy8
 xRW0UJ6Xs2VaZajqOLuLDVw1ozFpfIvi/K55Tkd6MXj+/c4/0GBX0QEPJvOu+jssQono8ahM97WhLlEh+b56wtLNWKW/Xu1C3AGLZwxBLYukZhX7bh54V7642Q7mZFnFX/VWcjdyDkr4e07zB2CmpY2GuQVmGjvokY8nbUGF6B4RZ8GUfOUrJSa/k2pwPjFwGcT7gLFJ0AmxHY3X8TPvdoInp91CDp9q/FGQVZNsEtbzmSXvDysAsASp+5HT0uJNB7znx1uqzOKKhL+nqNC4bPFACptdwLTVzc/1a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Vineet Gupta <vgupta@kernel.org>
---
 arch/arc/Kconfig               | 1 +
 arch/arc/include/asm/pgalloc.h | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index f27e6b90428e4..47db93952386d 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -54,6 +54,7 @@ config ARC
 	select HAVE_ARCH_JUMP_LABEL if ISA_ARCV2 && !CPU_ENDIAN_BE32
 	select TRACE_IRQFLAGS_SUPPORT
 	select HAVE_EBPF_JIT if ISA_ARCV2
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config LOCKDEP_SUPPORT
 	def_bool y
diff --git a/arch/arc/include/asm/pgalloc.h b/arch/arc/include/asm/pgalloc.h
index dfae070fe8d55..b1c6619435613 100644
--- a/arch/arc/include/asm/pgalloc.h
+++ b/arch/arc/include/asm/pgalloc.h
@@ -72,7 +72,8 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4dp, pud_t *pudp)
 	set_p4d(p4dp, __p4d((unsigned long)pudp));
 }
 
-#define __pud_free_tlb(tlb, pmd, addr)  pud_free((tlb)->mm, pmd)
+#define __pud_free_tlb(tlb, pud, addr)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pud))
 
 #endif
 
@@ -83,10 +84,12 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
 	set_pud(pudp, __pud((unsigned long)pmdp));
 }
 
-#define __pmd_free_tlb(tlb, pmd, addr)  pmd_free((tlb)->mm, pmd)
+#define __pmd_free_tlb(tlb, pmd, addr)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 
 #endif
 
-#define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif /* _ASM_ARC_PGALLOC_H */
-- 
2.20.1


