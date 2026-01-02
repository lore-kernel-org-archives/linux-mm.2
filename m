Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A5FEEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE326B00C3; Fri,  2 Jan 2026 02:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598906B00C5; Fri,  2 Jan 2026 02:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AAA86B00C6; Fri,  2 Jan 2026 02:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 383026B00C3
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:07:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE8348B605
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:07:09 +0000 (UTC)
X-FDA: 84286142178.16.4DFFB65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 629431C0002
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:07:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxvPssLF;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mw+h00YB7RAVdP7poV7dkiSai2G6Gsw/ByEs2J3Zae8=;
	b=weuf3BVK/Z+yCxGBa9+Kelp68TeDnp7ftF8EBW/t04TLfPgySHfVgeGtjL2o1crNIfqqxi
	3h0ciCqMw7WFwfcfA6E+S8OyK4dBA/2HpWszsbayF6nB6MxukGCRCT8g8iyj2sCJPe0JLA
	3mPuA5BP+KACzPtWVg20qvm2441qIUw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxvPssLF;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337628; a=rsa-sha256;
	cv=none;
	b=fraiQWpnGrbXClTu5LTlkmXsYILxUYKyRLs060WOR/O4Jg/qmjDjHQmvS5F3t4UaiyfeM+
	Zzk0B9NfLjCnxA7EoBECOyTFbrYYeLUbe8OZkOeAItWuU4Xr/24Xo/dPS1jL47So/jewtL
	MwHJvHxtTv5Slr1WmKGzpq2HGrPnZF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCDAB6012A;
	Fri,  2 Jan 2026 07:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E504C116B1;
	Fri,  2 Jan 2026 07:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337627;
	bh=HRLMNbJfcIyzccjy/sfTD1k/8iARayV6dPdQfJTMnWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxvPssLFALKnAzAlXBll5rTphhZU7lG8jhoItNzn1fDH5h3/PSapvXks4U3zBNKEd
	 Gjt8HaJNmGMQm+aKOWUJhnKIeCQ7VO+u8fAo/doIZz/Il+9XwBm8RvGrlfHBY4wksj
	 Cq6GIEs4nXBSlEFiuN6ruwU2ocb72rmtMW/CPlqo0QaPKgGKxexcSr/e058WN5u+vt
	 lU7HuQVp28/ddYn1T2PDlLul6PCmb+/cdQqpBV+UeDT6K9x9v670twTwtzSruR1eek
	 5EbuXWwPo0AdoPZsDEj9liyOPfYpCx9mEEd3RXrrfPHn5OQecwQijHHNqnHYPLSYBm
	 a5OWg4z3pZQcw==
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
Subject: [PATCH v2 28/28] Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"
Date: Fri,  2 Jan 2026 09:00:04 +0200
Message-ID: <20260102070005.65328-29-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 629431C0002
X-Stat-Signature: 5xpes3gcg4piz1gggp7fjaos5ucpyn74
X-HE-Tag: 1767337628-245938
X-HE-Meta: U2FsdGVkX18YZL2aooXQUaWZNGVQIWDt7oG0DcIC5CO+/N5qXLBEJStDoFh+BGQmengvg/DcfedH9kAjHSfYfeeg24Tz8fQNSVDkYqPeeCd9q5HEB7y4sJfhazGbzVuQENUQzMSGUgJEPOz92x9GLVYp66MfX1jpc8Cic7sW86IAUJEZ7PnTcxr4xalYfez24zHg88CcRqK0a28grescwd+72Np2nscf4ltxvfXAFSNhVMZSrA3sFgqLJO2ARepxcwVNPLCUgCmvusKnMOk0Tk1Uasr5jc8euouer0PKYAdR5wslcW3OXxDEWLdaOCWtNTqUb57KAcXSll0TGSuiWkogC8qE3Sa68vD6HQF8t8XkwkmM3beTodiO2sfK8L3QzbHyXwUJrZRkzx0xZk2YoLTLEay4SnP349cHslbYlKGU3wdX2hKLHbBu7QWVSXsCICQgbhSNWdbjiS9/ZCvQpNlPqSkfrbN66sks+8RnbGbLWh6Tlh0t6Nk9Mc6AgdROLle7gYbOcoYZWrM6Kh7BFFIy5eHf7BXHVR0/z6oHBLWAjTfzw5u1WXquFfUCIDLbf/fVH+bpIJDveJ2WGeiUlCzMsu8NAbI1Rb4bX9UnoTD0HaIaLAzHRv7nIbAPCixIz2Bjc+2nfBgjN6TWuUX7PSaw7paXG7hDBvlv/K4Po13VDHRNYBNhQYFXwM8N2Dm4WjOkyDPpxGsRX7Exmfp2gUxBTE7niJCwcu+B8/OL8b0GfX9gB7vVEOjexyA5xTSJoPnWyuMcQBDtddp+2wA716AykI1DhWuTmBCo4BAbbRfxr2QT2zxHV2m4DeBB6ZbHHy/WQKE6EkKK8dE50FLnvSdWNLVT+FmntitUO7qPXh5sJ38xRwWfcEduLCWsvSBEea7DdzjZBV0mxOVYi60AexTGfGza66X4SKJD3whZeGOqWC7Y4o1SC+1OFDGCWA3aR4itXmuwCbSN07a/Rv1
 UAc9h+wn
 xEHVWCZObSO9dNLsOd5SleAwsMTq/9ukVEIL7U4En5tFbk3OJMTEpbQEbOW9BXiJjhak+/BxldD+T9IHcApCv+CIbqCZ0yz3JAIx/BWUnmOxV3Ef68XInLPqrXgmPX1R0IKAmalVtCCezU4EtuKsBNeG9lEP/COxKUhLvloeurpCdYPw+jEpB6F0nADXLilVtMXUe/0AIX3z9K/XyUDnmGZAcxyVaEA45DcRA0hgQhTOewY4AA9+RzzYyT2auTOXH4fkwfXABrJAu8k3MktTaUGGgDqgbXOTGdaYVyV6Y51IuMpwH6/1XSz3R5g==
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


