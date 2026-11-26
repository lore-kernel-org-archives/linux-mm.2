Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE93606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MdONGc5D
Received: by kanga.kvack.org (Postfix)
	id 5C0366B0608; Thu, 26 Nov 2026 06:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597126B0609; Thu, 26 Nov 2026 06:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4875A6B060A; Thu, 26 Nov 2026 06:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1046B0608
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:21:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F13E1403F3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:26 +0000 (UTC)
X-FDA: 85477029372.24.8E66EF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B336618000F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdONGc5D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692084;
	b=aF5zx8qVz0zOYOhlPM4FoK527PZyLamcxj7TIQPIONz7fTbw9HROyg27QdeyDiDB31WGbh
	snhrc6zN+1eINLoHf6YS55xnXsLwj81/5Ov9sm0TN6Gtthyvojz88z/uGzZw2qEIX+vOjl
	RCR8J/s0wLTepOt7fe04Coo2HapEDYc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oczPXoX6LmrOL71NJs0ylkVxm4d3C/x+BrDR38WYHaE=;
	b=cDsT0rNiuxFyjQBzDm5r6QPLrCE+x1TEi+OY4FEmHLYltbmijq6qupisfzYET6svHhvJWu
	VlzIUZ6vqDmvPybUbdawWzxkAcMUlur3DwZ9SosG4Y/PizAJXOIFXsRt/24JdcQgmkYQWj
	1h32YySbKq55AfzyZ7xIB4BudFUsuv8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdONGc5D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1184943D04;
	Thu, 26 Nov 2026 11:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1641F000C0;
	Thu, 26 Nov 2026 11:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692083;
	bh=oczPXoX6LmrOL71NJs0ylkVxm4d3C/x+BrDR38WYHaE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MdONGc5D6rm4fAIyBNnofa7zpl+ADVHNhC4NDJwfkNfn8091gbfJmZAzoRVlM/UAl
	 38krRg5mk0qAmdNSn25jievEXiTiFYMnALk5q/eCta1QCgZ9gXPatAvYcRG58uVVBE
	 3wm4HYstziFwb74euNhfATKEVwYpu+Z970spJ7A+TWt8ilM4sCBjHWuMBCVIPGSzRx
	 /6zudqAJDsL4am9+DVg43+2gXxLgl6UsPiaIN70VlmvNQeb+uYNXnrQTMkVGavd135
	 nxFSo02+WGH/4IoofGf/gRphDaH3v6Nduf1B5F3XSAOCSmOauduVMTOdJZelQ13K7m
	 +/5p7bR7Qt+Hg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:56 +0200
Subject: [PATCH RFC v2 43/54] mm/pageattr: let an architecture allocate the
 page tables for a split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-43-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: xfyjfy3583fdyowbpijihcr31we45too
X-Rspamd-Queue-Id: B336618000F
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795692084-694332
X-HE-Meta: U2FsdGVkX18z4gDf6IKCY4WZP2R1+Zyl98ZaU3aJMCjAw1GZ2M+tOIuXpJPq/Q6LlyL4CbY8xlIXvd640/YGLtZwr6d0Dr5xlOqlMJv031NW/FU7XPd9VKHGMdDvrKaNfW8jmOpfMdbIzlK+phVdSHMiSUDPo3Jpz6IMe72mtAWOpdC53DvtMcI+hyAgRYaTljRg7zVXPUY3FIn+OlttAjPCCtJGI6ieNNsLIXOalRvmysAcAcWek3m6xGm8uZ9PdC4VcZlVDgYSuMMmXtZiYDeoiBF+f9ofQrm8A6L/WrNODz8EjB3sR5cnTrZGz+A0xoRK+LuiRx4TkqFThxb0GB2pVLoKCZ4VDwDS+Y4mXZ6Jl2RK3WOjDTqJUByQQyIc9cJK66p2GTsnidxMlTwtBRb2D4/y46z56ktQuNUWrfmez1YjSciGygr3ONg5XuxJ3IJ3iOdh4JS1UggylHafeefMGY//EhaueB2tzR446Uv1wEoeF7V24HtPdJw02fFnxJlhswvVBE477QzmW3hWsyKmC74LxT8mMTwar3FR5Rol+C+X2RIUumCavKgmfMbznGMjzq/2ZlYDDdcBob9GPSLP4LPCOZdpWzppTasIzqAUJGmS/inHV8HWzKr0P1eR3bbdAD0EWunaUYIG5cJUrrGewVcAneBtUWtcoqtuP++pz7j7+AK+YxQ3auT4FxUTVG80HX+hgP8XIFZlD07XRY+0FtpJUQrbTSbQ4gARqPt1+PoVCkfZFDShbUyWTPHds3+ilSg3QdXrSLBY2XO9IZxZ/VfoFXqvpytgIgXYR/a5XQmGJtkfYtmMlNLhfyPzwX6iKHmIqX2xJprSImyjG/NAdpj8edaE7k6lntBt1abz1bv3W7/ZS92VAvLnekOKd5SY/4/r12TFiF4auC3Hiuxk5NqVU91oT7dRc+2QGqoBZo1E2W2lYHYzFRiznpOfAyNUXWIaZMRq6uT0VSB
 AY6n81Zb
 DH5MvWD4gosHJmP7sXleZIpg0WOfwFj6cwf0WkusBbukZJJXLgmeomw8ZEeYIeU6TO24huTwadFhH3awm+acCf7iOTCzWP4a0IzxApivBKW1kusf4qOpcXcOeZf+K8nCj4rVb42VGNacaa2xBSD4pFFgLOw9ONc0gN8UYFh8N8cFwhMGRdzmTXrmxYrRJ30CHHcea2aSc0Le+eh8wtBxrv8YxrsY6YsJCyD1Ut05A8LYDP9HHqWNbiAy68Wm/2lYcmOU6/v+4YgOJLpv3oINJqV9lExE9i9TxU2TeIrY/6HdfkESt4SwKVNn8HQIjKWgmRBJChUO7UsLt8YhLS4YASOYCz/L7QhngPyNUwa7VVsItowpeYcWM85E8mt4QulFbnGFf797rhXu48JYOx1vPvzYvwTdr3EW8xTbr4Y+PhE2QDs890pyIa8XN2vV+oxxA5DIT8z7SFWytjGmWMQ8GbnVACRm90+8mC6Si
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The core allocates the page table for a split with pte_alloc_one_kernel()
and pmd_alloc_one(). s390 cannot use them.

vmem_map_init() write protects the kernel image before the page allocator
is up, so a split at that time has to allocate from memblock.

A fallback to memblock in the core would not be enough. With CMMA, the
decompressor marks all memory as no-DAT, and a page has to be switched back
to DAT before it is used as a page table.

vmem_pte_alloc() and vmem_crst_alloc() do both: they fall back to memblock
and initialize the page.

Memory hot-remove frees the tables of the identity map with
vmem_free_pages(), so a segment table in the identity map has to come from
vmem_crst_alloc() rather than from pmd_alloc_one().

Let an architecture provide arch_cpa_alloc_pgtable() and
arch_cpa_free_pgtable().

There are no users yet. s390 will use them when it switches to the core.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/pageattr.h | 6 ++++++
 mm/pageattr.c            | 6 ++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/pageattr.h b/include/linux/pageattr.h
index 091408ad328f..1a4e7c5dca98 100644
--- a/include/linux/pageattr.h
+++ b/include/linux/pageattr.h
@@ -111,6 +111,12 @@ static inline int arch_cpa_split_leaf(struct cpa_data *cpa,
 }
 #endif
 
+#ifndef arch_cpa_alloc_pgtable
+void *arch_cpa_alloc_pgtable(struct cpa_leaf *leaf);
+
+void arch_cpa_free_pgtable(struct cpa_leaf *leaf, void *table);
+#endif
+
 #ifndef cpa_is_direct_map
 static inline bool cpa_is_direct_map(unsigned long addr)
 {
diff --git a/mm/pageattr.c b/mm/pageattr.c
index 2f357a8c24d2..e05281a2b169 100644
--- a/mm/pageattr.c
+++ b/mm/pageattr.c
@@ -249,7 +249,8 @@ static pte_t *cpa_lookup(struct cpa_data *cpa, unsigned long address,
 	return leaf->kpte;
 }
 
-static void *arch_cpa_alloc_pgtable(struct cpa_leaf *leaf)
+#ifndef arch_cpa_alloc_pgtable
+void *arch_cpa_alloc_pgtable(struct cpa_leaf *leaf)
 {
 	if (leaf->level == PGTABLE_LEVEL_PMD)
 		return pte_alloc_one_kernel(&init_mm);
@@ -257,13 +258,14 @@ static void *arch_cpa_alloc_pgtable(struct cpa_leaf *leaf)
 	return pmd_alloc_one(&init_mm, leaf->addr);
 }
 
-static void arch_cpa_free_pgtable(struct cpa_leaf *leaf, void *table)
+void arch_cpa_free_pgtable(struct cpa_leaf *leaf, void *table)
 {
 	if (leaf->level == PGTABLE_LEVEL_PMD)
 		pte_free_kernel(&init_mm, table);
 	else
 		pmd_free(&init_mm, table);
 }
+#endif
 
 static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 {

-- 
2.53.0


