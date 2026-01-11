Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30018D25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B67F6B00C3; Sun, 11 Jan 2026 03:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A736B00C5; Sun, 11 Jan 2026 03:28:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88DA46B00C6; Sun, 11 Jan 2026 03:28:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76E596B00C3
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:28:45 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 336B413A3EB
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:28:45 +0000 (UTC)
X-FDA: 84319007010.14.DAD37AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3D2A140002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:28:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ec2bGwWO;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768120123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mw+h00YB7RAVdP7poV7dkiSai2G6Gsw/ByEs2J3Zae8=;
	b=FDTxfCdWb00FLST+rOr/ip/SWCyWOsUEde3vZqkXQmIPAzcZ8ig3++0aNFAgAjOHP0EKNe
	6sFG0pBw2Xb8T4nofY2Mjc1JEG1AyeroLXRAI4S13jzGV1qSbtYna76BNmiYmxs2RiOnli
	d+n4vFCjtEMhuIFy2XVOspunG3YFtyw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ec2bGwWO;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768120123; a=rsa-sha256;
	cv=none;
	b=JUkm+FbWYbzN+AZCvVR1U/jd02OhoLjVTeLkBcBF1qdvsV2s9LtC5dRHl2RXpNlJFqT3Z8
	2i5t1sr0AhDarzvIwU76aJYlWj6RtBAV2nKvYsW5xQzPv1G4UROQgWrgg2JVT5etBndnEg
	oDpxUqPp3f8Pztu3YBvjsAG5PIv+1dU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 12DF960142;
	Sun, 11 Jan 2026 08:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274D1C16AAE;
	Sun, 11 Jan 2026 08:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768120122;
	bh=HRLMNbJfcIyzccjy/sfTD1k/8iARayV6dPdQfJTMnWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ec2bGwWOeOjXW+ySUXXKPm6eayFRFkSmbxQ0Yi2N08exR6X1pcnRzRL1jFrEN60gu
	 EjR2EbdukWQDt0gz83zhTod3BcTK9hToNe52kcKWqr9xEFUT69+VRURPQ8b21IwNRd
	 rp3gC/u2WEVHsJheESwI5qHhh9E4BZZ1xav9luUXT439xB/CPrZE8H4fLmmGL8QILy
	 9Yfb6Y/uPZ+yYjsvo1Q90O2WW22H/avuDFr8cB76tUKXJ5Wsc0cale2xr++cTaYOu9
	 eji+2hoq7YT65edlzcRMhkEPeXUV9Ua93DTgqCtd5AaZJXvzgL4tJVCdJGBVI9moFu
	 uPmsuMV4ggZaw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Klara Modin <klarasmodin@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: [PATCH v3 29/29] Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"
Date: Sun, 11 Jan 2026 10:21:03 +0200
Message-ID: <20260111082105.290734-30-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3D2A140002
X-Stat-Signature: c3tms9mjpcq5shd7axbh78e8jcpwxhow
X-HE-Tag: 1768120123-947018
X-HE-Meta: U2FsdGVkX1+jfCFwuDN3QfP6MFYzhzR7+mRSOZNgAKIz8yXqp8eGGCbESOVrEDuv3O5+kCbBrKSZmE8xdvJLwLdIPy6qBXREUau4xyrE7ensg4SzomHXHc8TiNjzA2oGVQrY3g2n4YN27Cil4XLNFSHIj+chFf8LFQ471kXBbb54LkP4YqAXeW3Ai8NAnPmV5d0h1N0RJFoLds+QUIIiRxVk3CfCbe730lf9Cr/50BhvwCYR53Emc0xxv+a8VusKT+CcnjyoOJIvu/9+zr8LuFwLd+xZt4JQ8QNpAfjBia3D55YnkCxCJuvu0Z3d9aSVmNUc1kVNqEXgvmVptXLM8barBmELzZhi3whVA8eV07oxoWWbfTRhXsDxPug+LBJ3iWv0zhr/GHCsK2ZqI8ZFCHUx7TyV3WSvokOqEtsJkRjPhvQC50zVq8euXNvk7pskhu4FoROwmL6Av6mu9SlRLh7CbwsNZLD/DJqK57FEajm0m4Pcxpnacfj7zlSRRUqOdyWPViL1xgWKMBO/XwpyOep3fREKG9YF8GqK32gY8kCu4VaQLy9KuoBY07F2c+1QLp0awnXGqHWn3WgtrlI80CKSCteVm9A+RHYaSd6Gt9XMoVUoRZ07vkxmHrbbDW9ErjwCpfgvE32wfzcD1RL0YC5cWSBc0k7Q1x7Wh/0LOHvgHPfC6KLqnTksD1pbFy/dguPXAqZmOFo7xQGD6zBK+i+jEOnzx0uT9AYlXBF6984jRBtCIxzZenXh0AjThEUK8cmEznXuOfwtus4ZviQRj6h+bzsLf6mIGnRH8k5Kg2lTH5aGF4p+y9+pTa/3fZ5iPbv/ZNwIUE2vE1yB9z2ocFIDsdFxrZzMI4XZcnT0gUCO4JKhQSPSyb/Sh8HU7mh7Ij1gsYYNTHTs08OJ34vTQ1+wMtAgvNJq7GApxPrqtxFaK1mH6OyUFSxvTJE1KjvE8LB+N6uFaetr5s3ht5N
 X1wNYL7k
 scNh9okNYMvSuORvxPOlvLpZgB+zJ92hROKPCQmI9bEUztheZFSh8XRE1eV6d+l/3ZO6B/tvtrn9+HYjNIh6p/FVk/Gpttqku34YVrc7488ZWplOavuku/7Rg3C6n9MbkZ/fGa4M4tcDe2XGOTiGE2G+9kITfgBHAU8Cl1tPLwo8bVYK/DVj0j6av/57BSPSsyW9F9HvPl7ssumuoM/jTddbXKynQEPsH7Bm86u5VtbQODzjASvp4Nn+EJ/IMROVMl6YIamRNUT6V/aw7AuEUNDxAJIivmdDlvPhDSHoiC5/SkgcHRvZvezAJv8VDoG5Uygw0cxlDwriogMeBzGnz11Ol1tfqUS2IHbbFgn6JAxKIlTLC38TIkDpQYmy8qJnPqJxs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

This reverts commit d58b2498200724e4f8c12d71a5953da03c8c8bdf.

hugetlb_bootmem_alloc() is called only once, no need to check if it was
called already at its entry.

Other checks performed during HVO initialization are also no longer
necessary because sparse_init() that calls hugetlb_vmemmap_init_early()
and hugetlb_vmemmap_init_late() is always called after
hugetlb_bootmem_alloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/hugetlb.h |  6 ------
 mm/hugetlb.c            | 12 ------------
 mm/hugetlb_vmemmap.c    | 11 -----------
 3 files changed, 29 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 08fc332e88a7..c8b1a6dd2d46 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -175,7 +175,6 @@ extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_alloc(void);
-bool hugetlb_bootmem_allocated(void);
 extern nodemask_t hugetlb_bootmem_nodes;
 void hugetlb_bootmem_set_nodes(void);
 
@@ -1300,11 +1299,6 @@ static inline bool hugetlbfs_pagecache_present(
 static inline void hugetlb_bootmem_alloc(void)
 {
 }
-
-static inline bool hugetlb_bootmem_allocated(void)
-{
-	return false;
-}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 82b322ae3fdc..e5a350c83d75 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4470,21 +4470,11 @@ void __init hugetlb_bootmem_set_nodes(void)
 	}
 }
 
-static bool __hugetlb_bootmem_allocated __initdata;
-
-bool __init hugetlb_bootmem_allocated(void)
-{
-	return __hugetlb_bootmem_allocated;
-}
-
 void __init hugetlb_bootmem_alloc(void)
 {
 	struct hstate *h;
 	int i;
 
-	if (__hugetlb_bootmem_allocated)
-		return;
-
 	hugetlb_bootmem_set_nodes();
 
 	for (i = 0; i < MAX_NUMNODES; i++)
@@ -4498,8 +4488,6 @@ void __init hugetlb_bootmem_alloc(void)
 		if (hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
-
-	__hugetlb_bootmem_allocated = true;
 }
 
 /*
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 9d01f883fd71..a9280259e12a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -794,14 +794,6 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
-	/*
-	 * Noting to do if bootmem pages were not allocated
-	 * early in boot, or if HVO wasn't enabled in the
-	 * first place.
-	 */
-	if (!hugetlb_bootmem_allocated())
-		return;
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
@@ -847,9 +839,6 @@ void __init hugetlb_vmemmap_init_late(int nid)
 	struct hstate *h;
 	void *map;
 
-	if (!hugetlb_bootmem_allocated())
-		return;
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-- 
2.51.0


