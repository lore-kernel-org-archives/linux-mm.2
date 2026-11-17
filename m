Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B35606A889
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QtAAKAKJ
Received: by kanga.kvack.org (Postfix)
	id 539256B05B7; Tue, 17 Nov 2026 02:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA606B05B8; Tue, 17 Nov 2026 02:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1566B05B9; Tue, 17 Nov 2026 02:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 063B56B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 595038037E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:37 +0000 (UTC)
X-FDA: 85443728034.23.DE79C9F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6661DC0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QtAAKAKJ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RImp/fV3D3InxuUTVuaSs0rWb42FA9SO6Wnjy1jVERc=;
	b=B/q5FXeaM146Wew827sSUyIKjwOzTQwhkUxHWo0ekh5gWrSjJNJDZRX3YFjbI6KTRj+2PI
	qAXFenjHDFIse+YLV2dHMDXKozJtS6hJG0wUksRprZtqEYhnV9XMPLj5zZqBrY/3TJ+Y0U
	R8CMBePpZ4QZNL66C0huDnsIphpnfAk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QtAAKAKJ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899195;
	b=OCEVNCUGaL3AOwz4SXaLgQ2yk2U8SoItMMvPG31w7OQFR2zTFMysdIHMOqdCkeB5JSD2Cm
	ZghiMxUDj5GR4fJ3Nxl+ATL2d/uk2MqpEPUKk50UNuiB6N4l3rpyLL17OvoZ0otH30zjHN
	B/0TkLVwEQXAdCRjlHbpReYkv8O5Nkc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68A041476;
	Mon, 16 Nov 2026 23:06:31 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F28E3F763;
	Mon, 16 Nov 2026 23:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899194; bh=DlYI5zPVBJe6EC0DN2RG1Fj9YuDqCOwNKOBIujdfKiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtAAKAKJrk1BBv8Kv36+Hc9xlP7OjDbU9LJUZh89SIlom0HQ7BYjyTQUeHt2gOV6d
	 Pj3X+i8Bqc/q6SAE5tdkM+ASpfQxoMNDcPUktMfey+zOgzlDgF/4C/GkC3WO0l99y/
	 VcdEv3jZhSZIMTXJ6U3iaWhtZvXqNLZZ8E+gWvb8=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 03/14] arm64/mm: Route all pgtable writes via ptval_set()
Date: Tue, 17 Nov 2026 12:36:02 +0530
Message-ID: <20261117070613.1183243-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ttrcepwwua7mtgnff4rrjphtjjozans
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6661DC0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794899195-980984
X-HE-Meta: U2FsdGVkX19o8lG5yp61j39cLL/Otfmk9PSb9p+yDJCb6LUJyoYyefDroGLXT24OO0NG/O2TMHyCsvgAhQGvqLW5Kcrp7+WkSUtac6FsWnwJ9aZY5bDAfW7ohs+l3k/jmMiXzk9HKDsN5O55Escv/hFOK8udZdfcpFARHlVa+IHQsT21D+oTbny0W5JqPf6PzHzznif97Xs2h1TXDIQ0g0OWfb3SvHdRna3ELgMnk2WbPDE404rKwuZbcFCVwlDwnWWpIlSu5nOS5kbrdhX45h464quVWaKzbsamuo9YjX210OnbDHUVnWYnrXO2vDbC8RvVnxow+6D4HeYOeZbZMjUrprAP0+1vjgsZrrqOAaqV2N3aZLzwTAmsr59d+5Vp/SVzcH4ZIQ5qHJ5WXiq1Xxw7TRJpmNAC0qnhVBvZBOllEWlgfFDC7lB2m+lPHFEHOoudE4tsq9HO6fSShKzrIZ5hWP2tDX+0mW50e6pKMK6ws/ot1xkGu3cuzhTKDj0LYqYC1Vwc2DhVSO/w7uidG4ZVltiLQGLbVcxrZ1nj2b6xo9FZIokBQ2nvZDjxOhmWmDXD3MmrN8MBR0DZsNL+TcHYO5VW+P7TGrsWzvL0DYT77JK4TvY1dWjpAZWZ2vwdYyfnEYiW0lakcDfRjitOXAWcCZqEUFDppBkO2u5mrBUXaFUD7CpaqosUhgkvINnE8XdJBNXh9Rdn79VPcoMXoPZQ+ZT44EgGdzwsvXvJhkMJs3o+aTjZ2JOqdmPyRDY2SNqOcBn/kg+pHSDVJSb+HK/lccR8O7ltTaFc+W5B0NZ62Db9zhDK/PbKhn8mAcCHEsABj2nEfCWu5kAdjifcMGLQhnuu7fo31PM4NhGW0Tttf0jw/3BMW0UqNVaraK7o0Apu0Qf9dJW0jRIuBQacFPVvWm7d4q+QmGqPzcfh51qREmNUA8TDpNrPi+G3hfHobb6KOOLcAykacVHsg3q
 yPNJGLdY
 Y6rqmXWpb6lFLABk/zWvfo5SSd7q55eZbg2pidSgyBxludbGL+eO4EACr2FQaF45amCGWXqHtXTGvVaIJDYeTFj/Nd83yfqnzolsCCwlZ7mrW4b4N7tlGA1jV+1Lt+8TW06cFMriTW1avCKA/fkdQvasVO/N5sswSdEwfhwQW/5KwbANRfgcrnM9Gfot+pY+HLFvdRKX/m7HQmm0EU57NVInQYwQ/pYX3d8Q3eys5L52EmoSWVlIDBhqST7V8CGz0qMVLgZaJ94bwpBkCLbxXngGFex3sjEBcgBVfqpQoA0hvf4Jnzb7vEIaEd7j60UwdndGUKWy22551UC+L7Hk4SWs5Prv15JhT+sK/AIJoAnZbkJEMXF/9xmdT66JyXIeYj1B9oQhIU1MBzMQ0jLzgJNksF0myKUci1CIj9/6CeJtGu9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently ptval_set() is defined as WRITE_ONCE() but this will change for
D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
copy atomicity.

In future this infrastructure can be used for D128 to maintain single copy
atomicity semantics with inline asm blocks.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 11 ++++++-----
 arch/arm64/mm/mmu.c              |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 1c982ccc1e5e3..0ce2e59e09198 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 }
 
 #define ptval_get(x)		READ_ONCE(x)
+#define ptval_set(x, val)	WRITE_ONCE(x, val)
 
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(const pmd_t *pmdp)
@@ -386,7 +387,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
 
 static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	ptval_set(*ptep, pte);
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -815,7 +816,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-	WRITE_ONCE(*pmdp, pmd);
+	ptval_set(*pmdp, pmd);
 
 	if (pmd_valid(pmd))
 		queue_pte_barriers();
@@ -877,7 +878,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
-	WRITE_ONCE(*pudp, pud);
+	ptval_set(*pudp, pud);
 
 	if (pud_valid(pud))
 		queue_pte_barriers();
@@ -956,7 +957,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
-	WRITE_ONCE(*p4dp, p4d);
+	ptval_set(*p4dp, p4d);
 	queue_pte_barriers();
 }
 
@@ -1081,7 +1082,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
-	WRITE_ONCE(*pgdp, pgd);
+	ptval_set(*pgdp, pgd);
 	queue_pte_barriers();
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d0a4b8961c7d1..b5bff68dff764 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -75,7 +75,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 	 * writable in the kernel mapping.
 	 */
 	if (rodata_is_rw) {
-		WRITE_ONCE(*pgdp, pgd);
+		ptval_set(*pgdp, pgd);
 		dsb(ishst);
 		isb();
 		return;
@@ -83,7 +83,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 
 	spin_lock(&swapper_pgdir_lock);
 	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
-	WRITE_ONCE(*fixmap_pgdp, pgd);
+	ptval_set(*fixmap_pgdp, pgd);
 	/*
 	 * We need dsb(ishst) here to ensure the page-table-walker sees
 	 * our new entry before set_p?d() returns. The fixmap's
-- 
2.43.0


