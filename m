Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17EBB606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Z1mjNykn
Received: by kanga.kvack.org (Postfix)
	id 3496A6B05BA; Mon, 16 Nov 2026 02:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FE56B05BB; Mon, 16 Nov 2026 02:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CC46B05BC; Mon, 16 Nov 2026 02:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2F046B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:14:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EE13C08F8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:17 +0000 (UTC)
X-FDA: 85440118554.02.1F20931
Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	by imf07.hostedemail.com (Postfix) with ESMTP id 755A840003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z1mjNykn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBfGRIbJnN+qNQ3rPfXmwqxNtkbzv2IUhJ3GYvE0c6Q=;
	b=uXL43zlG12AQwcY3oKHbslkuFVqjnUl8ajZP4sXJS58wWyiqudM5Ipqsb7dapT/y5JDq2z
	DmEPzYMR3Pe7mGPVJrilkYIDM4OTgNdZLFVGWs3o0hIbGh7x2nzV3q8cYBm2QT3Ju/z1iF
	DjYH8BJrP9OV4B0vOIVSZJd4zXDt8po=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z1mjNykn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813255;
	b=tKzD+9AXXe/0nlxCVgPQyBPFCtRWcwlCK3NGL3Fr0rowif3OD8tue8Vjd8hhQWU5XZl2vs
	6L9mWXrhcv6Z8Zn5/GbGtIiTVB5dx9YxcINMgyPKIb9G099qWLBylvcOjIPyhXvii1EAk3
	9CrDGadZFrzpiWDWn0TWzBgKZZit7TE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7IZMUSgTM4Km0OlppI5vIjCEjnCgOgbFSMjmVmeVMCE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813254; v=1; x=1795418054;
 b=Z1mjNyknmiSR9Cgi+Xmcso28T5prx1Y9RX3Ryn8z6FlJaK5z+s3vAxS6QT2yuzm5fXcuDhE+
 rtDFLaOSCYtEloVXMZvfFE2S9g6nUkPaTZiSiElj1TWU6pN+DL7E9EzimidIY/mXQYH1NCDjqYH
 bJYHRKsFHyDkrKH5fF+FYUzg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3ab19dba70fd5e75;
	Mon, 16 Nov 2026 07:14:13 +0000
X-Mizu-Trace-ID: 3ab19dba70fd5e75
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v5 06/11] mm/vmalloc: undo what vmap_page_range() mapped on failure
Date: Mon, 16 Nov 2026 15:13:20 +0800
Message-Id: <20261116071325.263682-7-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 755A840003
X-Stat-Signature: zqmn1od3e69q9e4d1zj6ucktc9c4c5yy
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794813255-983339
X-HE-Meta: U2FsdGVkX1/QG0sXi8MWE/zQWN2o+TyI4prACpyO5eFG9x4PbRPUq1KvlED0iOpjPqbWQndVZSAVNJIOF5N8tmnkV/MlLczUpBp1DrJlFCpCMh2rfrorQ1A29iWcVAQRslpvsiSWTBBqJdGM13YpvUYCUoYhLH2T4uT6gLmPJIJu6SwYSbqGa1U6e+jpIZj2vrJcSv2Ld2RG0McL+JrhifdAW61p8SlI5gssK1+JvP509HOoEEac3A8ieqGvrNgTmsG6SZRpatSNvEsTaysAIkuOWI8GoIyrpqbnt8Ic/HxHiyLrJGEBrGdpUhQGQfrtQzw1jVKCUmHtDrMgni6zLOj0n2me3w7bVp2Fe0WYNab04MapoaObkNldxkpy3qHy5mDAnBh8pEa+0TXWNuxefSK2C6xZyGBm1FVZjaZr5TLKIgL2rEwoUrn3quaPpBLCASSSlXnrGsPRd8p3RuWA8syOo4m20jY+dj0OhoeVqAk1fMsJtRWgeDWRpififruIhgN5BuwFWFGTrgZF+hQVwWZDnDDbH/SRQVp46+9FvuabMQCt0/7+j3iyc1amKv3c36X4ZspqxXiVVrKO7tIXBuL6c70sKov/FWy6TI7WgaRnemty3m/QNT9z3ylKno5PUyuco3VsThMx6Vxar7EBPoZRhcEuMVG8Mt9tqWUsR/W4opeRGveIsuUfHf482Tyd/ElPmCQQCY1TT1rjbXZEhUAQrjL/K7Re2KweIh8I3iSkPjnaienhPom2UV37G6IiVNhmifpsN+8uF/t/1Aki6Oute4Z6ciLqLjiwWOaiJCrjIxPYfJleSiipTmwcyGjDHETzgYYRhSSeic8FuMBOqoeP5HoTYEUzHGcAUJpQDdjGz1u08g6tzIm3xZKNRHrciM7Yi481Py53eCxIQpr6WCRHL1iKMBmBMaNpKYWCO9qGUWgJl7Q9Iw3rfTMPsCnF50RlYoQ1UyOhA3GzFzT
 XEYbYkk0
 R5tsRQ1XUbAsEXkbrXd6h7UOmPX8W2xVBe5j7Klj19SmakadhOUA+PiqvGFh9DlNU4eeuisZHgv64zzW5sVukKjmIh7As4fR8BuBK1aO7u/zJ3xBrXBsrVJOsXOXTLVSsMiTPdUgLXwU5ZnJOZ7l/o6jliB3LimXDg06afmDxRdRACR4cHDo0Jmw1nde2jYBykixeKcX2lIEMWae0krc5OX6J9OejE7sptO6EaTF/zvyDydIG6XUnEkGH693fi2m8Hm2OS6xae8Li4Nj0m3+HXft2yGOL6QL+ICsw1ugQKn6luPQZiMEw+iAbSKLRici6B5Kq4TqPXpQKB3TXEPNTVOByiR9IYbks6djZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ioremap and arch setup code map their ranges with vmap_page_range().
When the walk fails half way, or the KMSAN metadata fails after the
walk, the ptes installed so far stay behind. The caller frees the
vm_area on the error path, so the next mapping that lands on the same
range trips the BUG() in vmap_pte_range().

vmap_range_noflush() now takes a mapped_end argument that the walk
levels advance as they install, and vmap_pte_range() BUG()s before
it installs over a pte that is already set. The ptes below mapped_end
are therefore all ours, while a pte above it can only have been put
there by somebody else, for example when the caller's range overlaps
an existing mapping. On a walk failure the undo is limited to
[addr, mapped_end), going further would clear ptes that are not
ours. If the walk completed and only the KMSAN metadata failed, the
whole range was installed by this call and all of it is undone.

All callers are sleepable, the teardown passes can_resched = true.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d99d7710e1ba..5c1eacc2a0ac 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -117,7 +117,8 @@ static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
 
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
-			unsigned int max_page_shift, pgtbl_mod_mask *mask)
+			unsigned int max_page_shift, pgtbl_mod_mask *mask,
+			unsigned long *mapped_end)
 {
 	pte_t *pte;
 	u64 pfn;
@@ -143,6 +144,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
 		nr_pages = PFN_DOWN(size);
+		*mapped_end = addr + size;
 	} while (pte += nr_pages, pfn += nr_pages, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
@@ -188,7 +190,8 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
-			unsigned int max_page_shift, pgtbl_mod_mask *mask)
+			unsigned int max_page_shift, pgtbl_mod_mask *mask,
+			unsigned long *mapped_end)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -203,10 +206,12 @@ static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 		if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
 					max_page_shift)) {
 			*mask |= PGTBL_PMD_MODIFIED;
+			*mapped_end = next;
 			continue;
 		}
 
-		err = vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, mask);
+		err = vmap_pte_range(pmd, addr, next, phys_addr, prot,
+				     max_page_shift, mask, mapped_end);
 		if (err)
 			break;
 	} while (pmd++, phys_addr += (next - addr), addr = next, addr != end);
@@ -245,7 +250,8 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
 
 static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
-			unsigned int max_page_shift, pgtbl_mod_mask *mask)
+			unsigned int max_page_shift, pgtbl_mod_mask *mask,
+			unsigned long *mapped_end)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -260,10 +266,12 @@ static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 		if (vmap_try_huge_pud(pud, addr, next, phys_addr, prot,
 					max_page_shift)) {
 			*mask |= PGTBL_PUD_MODIFIED;
+			*mapped_end = next;
 			continue;
 		}
 
-		err = vmap_pmd_range(pud, addr, next, phys_addr, prot, max_page_shift, mask);
+		err = vmap_pmd_range(pud, addr, next, phys_addr, prot,
+				     max_page_shift, mask, mapped_end);
 		if (err)
 			break;
 	} while (pud++, phys_addr += (next - addr), addr = next, addr != end);
@@ -302,7 +310,8 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
 
 static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
-			unsigned int max_page_shift, pgtbl_mod_mask *mask)
+			unsigned int max_page_shift, pgtbl_mod_mask *mask,
+			unsigned long *mapped_end)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -317,10 +326,12 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 		if (vmap_try_huge_p4d(p4d, addr, next, phys_addr, prot,
 					max_page_shift)) {
 			*mask |= PGTBL_P4D_MODIFIED;
+			*mapped_end = next;
 			continue;
 		}
 
-		err = vmap_pud_range(p4d, addr, next, phys_addr, prot, max_page_shift, mask);
+		err = vmap_pud_range(p4d, addr, next, phys_addr, prot,
+				     max_page_shift, mask, mapped_end);
 		if (err)
 			break;
 	} while (p4d++, phys_addr += (next - addr), addr = next, addr != end);
@@ -329,7 +340,7 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 
 static int vmap_range_noflush(unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
-			unsigned int max_page_shift)
+			unsigned int max_page_shift, unsigned long *mapped_end)
 {
 	pgd_t *pgd;
 	unsigned long start;
@@ -346,11 +357,12 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	BUG_ON(addr >= end);
 
 	start = addr;
+	*mapped_end = addr;
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		err = vmap_p4d_range(pgd, addr, next, phys_addr, prot,
-					max_page_shift, &mask);
+					max_page_shift, &mask, mapped_end);
 		if (err)
 			break;
 	} while (pgd++, phys_addr += (next - addr), addr = next, addr != end);
@@ -364,18 +376,32 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 int vmap_page_range(unsigned long addr, unsigned long end,
 		    phys_addr_t phys_addr, pgprot_t prot)
 {
+	unsigned long mapped_end = addr;
 	int err;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
 		return -EINVAL;
 
 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
-				 ioremap_max_page_shift);
-	if (!err)
+				 ioremap_max_page_shift, &mapped_end);
+	if (err) {
+		/* Undo the part the walk installed before it failed. */
+		if (mapped_end > addr)
+			__vunmap_range_noflush(addr, mapped_end, true);
+	} else {
 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					       ioremap_max_page_shift);
-	if (!err)
-		flush_cache_vmap(addr, end);
+		if (err) {
+			/*
+			 * Only the KMSAN metadata failed, the walk mapped
+			 * the whole range. Undo it all. The callers are
+			 * ioremap and arch setup code, always sleepable.
+			 */
+			__vunmap_range_noflush(addr, end, true);
+		} else {
+			flush_cache_vmap(addr, end);
+		}
+	}
 
 	return err;
 }
-- 
2.25.1


