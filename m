Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7363D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4586B00C4; Sun, 28 Dec 2025 07:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374D36B00C5; Sun, 28 Dec 2025 07:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280FB6B00C6; Sun, 28 Dec 2025 07:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17EFB6B00C4
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:46:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2C311A0B81
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:46:58 +0000 (UTC)
X-FDA: 84268854516.19.0FBB7AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25310A000A
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:46:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUM35TWv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766926017; a=rsa-sha256;
	cv=none;
	b=rm9t5LB3XEZ2XdpbjmTzRJnGOeKtNxfvGCJR4fPXLnNp8QUsBq7jso+lDhD5EZW0rUouDU
	a70FvNAk5P+Qw2/ADxNuzu+Q4YHltVR8xmV92zoWtlJuG4EEhFb1cY7gdvqnU2BLchjGk9
	Tg+3JUx5mDEFRg7euyUeWPS6N0oNLX0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUM35TWv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766926017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OA0kYSCHWPTEWVF3qtan8c1YW24ugV0bVMLBsJ5bJns=;
	b=LM/z+fEgAXXK+B1Tc1RNGRuXRDBCXwlFEiFXfNC8sF/S4j6eGDnoJHRdrd7qSRhBx5aIbv
	7byEhGiy9LHBO1+RcilB75wJiAgS+sQSgWiQHSGGUXHLcheehpw5T6WBrsSCURgVzyJWwG
	U8jD6Rvh1Iknr5BpOJvQW4CFTHC/KaI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 77B79600AA;
	Sun, 28 Dec 2025 12:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9132C4CEFB;
	Sun, 28 Dec 2025 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766926016;
	bh=zJEIy7O/CTkdhQmMkACZcULIRougkhyexygWc4ZDAXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUM35TWv/cMbcrOeR73n+XHNIa0BmyPC6QF36LaL20Yna6xWY0BSLgjEuB9NNQVFs
	 xNgPahJssiqOsbE9daKLMR7RnvAjtHzSJrJwXaBKr1VZ2hmtoHuKqqj/Ei3WWyVnyR
	 Wh9FJBMTwNv7vmoGVNVBHufARIfuWEgzOKFYbpxpdKPvSpUfd7Cv9IO1T53Wmkuk0g
	 eTkgXuXNAJmvtbrLMYLsdFLyK5kO0YcuaWIYnLXROnMlWOeCSui3e7muw2Lh0uwkGX
	 kMLPW+nF7Pn138We0BaiaTiOz67ixNks7n7EVEQ8aFn6s9NF7PTZZssQ5hCt3c+BXR
	 5rgqGKWhVXizA==
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
Subject: [PATCH 28/28] Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"
Date: Sun, 28 Dec 2025 14:39:58 +0200
Message-ID: <20251228124001.3624742-29-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25310A000A
X-Stat-Signature: 84xw4b6bnfhkux46a5qyc1jsra3htdox
X-HE-Tag: 1766926017-362619
X-HE-Meta: U2FsdGVkX18klO0r4PAwgYR+JgI891RPGX9Fbz9vbpdGz86UsgjnJVfbIov9N3b3DqrnuS7XNprp8IUDrO7y3bMhjiFt2U4KSa+JSV1EcFbc/79gIFKHUAmscxo0QPT0+PCxVxXN4+CJ5wSbhGzm2YaNwgcw1gvn4Yj/Z7We/9MAncUW8lYvq7ZSudJZCf87t0YLvDUjOdIQKrPTjxVou4R4kINJbViH5soab+/vqfHqYuYdUW/wAZZolr5jxiLqyj78ATjQUHSb2tRTfK4acsUbCVw4rR0YxwbZJa4FyNeJ0E9SByEKc0zIjYQSDP7UEwj86Y2Lc+mZ7LmHU58W93zx6l2vxJilVWyn2h6RwnCNWKO1Ffx+QRLmBSnCoeIuW3rT+niefbBzS7vY86aj6xeaOzshk5BwishdMiwQcattO2MfmM2IpLcOL09mZqhUxNNFFB9c+5dcGF0fBLoqK2Tgy/hsfT/+8O7gwh/CquG1bZdRqW7F8xJxNHzyG3Y13PcMcM00XcE3P1rzthBznHpXDhe6ggWc+icbT5WPfaM/4aWpizRFS4aY9V4myqfi3bqEb1tbGPFG3fEl/EAvdpgR/W2BivD4hqU3E0eF/P5mMKVzHrnvrWetegdbDQc7uu1Cg0ApAsnCI2cRyr02BaSah2JKMgxjj9HbO+k+fBagoeZvO7KdT7RRaX/hwLnTFgYMl1QzIsWlhZWjQgI4Fif7PaVDPpF2KaLbEvBYSNn84BySgTKrMJeLhwXUFAvzuQoXqMkpfQQIDkhniZnbsjB0M0OwR/vajeo2EZbdQ/sEirv+G/vbdIc8AJ3AniopRWVAGE6lBqPEukzid/pOiarJL7x24ca+NI81m4d9J7/kIMuWveLu/NLsEe1tFHggW7YVyh6n9rld+yved51SFHBPpx2IPzinrgb4nMGl4IIFLZDXquV/7lnCYO65gelndq9C7TI3+7Xex9Y8tRJ
 GE85uCKY
 fPIEG33Ajl5CYsIhK/jq+vls6BpUSWhs+Dcr7Gw90wO2YRdvAh0kJIE/YEdpgKt6u6UKoPzSBsZNwKhMt1/QyyNekObRDGzjZ1m91UowxkN3m+foEvaw0ZiKTAm/U2wkCG+oGlshq5egbGy+YC4TKNALGwj42rWqaug6HQeFafEu3JJd2gh+HoKi1YeaEXtcOpUfG+qOjIiLNI7NTMM7eOgdMv/rJz75jA/EK9sksKACl/GmCa3IW+kLnwWah7pMGGFFkD3tKLQhgp0KjSRthf7Qmxq4x9W3VGF8ifEwqHio8rPL/sSykAKq0WeF1C5+MF44+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb_bootmem_alloc() is called only once, no need to check if it was
called aready at its entry.

Other checks performed during HVO initialization are also no longer
necessary because sparse_init() that calls hugetlb_vmemmap_init_early()
and hugetlb_vmemmap_init_late() is alaways called after
hugetlb_bootmem_alloc().

This reverts commit d58b2498200724e4f8c12d71a5953da03c8c8bdf.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


