Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D33606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsixuUjz
Received: by kanga.kvack.org (Postfix)
	id C1CAD6B05C8; Thu, 26 Nov 2026 06:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5256B05C9; Thu, 26 Nov 2026 06:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2B16B05CA; Thu, 26 Nov 2026 06:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 864806B05C8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:16:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 723C91203CA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:21 +0000 (UTC)
X-FDA: 85477016562.18.C4E8D4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C76521C0008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jsixuUjz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691779;
	b=vwUCvo6TjA7D/WCXTwICT3Ld1fu+qlAAYYcDpxJeLv5IgrhQ6kkecXrPVF++K2NmSC4lfD
	CiGR6pZNWWNBVa313CBkPBhEt6j3mk84DOZVrSwyXDi5plu+t0NLQH51U5gRxH0sIgknEu
	g6nMmDop057DsLnGFkSEeCbyePMPLxk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCQBCDXpqdYanypT2YtxcGDNibGU62xDqSTU0b0C9A0=;
	b=5AOCTusF7zyTQ7/7HKxdh31yCwLc78O/XUEE0/zEqBeHS5+MJYt6P6avThZb0E/nIJvv+U
	SeiyJnSc/vWvEFGcFjkghL3GLmJIr7Uc38ocXKXEQ+6OO8myhzr30YNc58S00pPQCOSqSf
	m+aOf/HGoSuY5ggdrIzQiuBpnqf9uwM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jsixuUjz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E34B61E12;
	Thu, 26 Nov 2026 11:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E67C1F000CA;
	Thu, 26 Nov 2026 11:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691778;
	bh=BCQBCDXpqdYanypT2YtxcGDNibGU62xDqSTU0b0C9A0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jsixuUjzPcdBYEMxRDCOOb4MWFDZOSZu3LunR9YGzkmsdmtoC4JNE2Nzl7MiPl479
	 h/Ssi0m6nbfaQkZG7ARE/Sg/GV155f3Gr/QpUYyWC+SKFd215tncf/YeaPE2rO/CFB
	 E8aT8bUhn3tNrPe1JQadaznrSOTvvA8X7vbZ+RnHQs1l22+QRRO+V9C+/Erc+YCwRD
	 Kris64innIDAw3YgXAgPQZV8KQhnkPeuyeVXpTjrDC1d9ZFrOXf61LHh3EoEg5m7da
	 +OWThIPiWSYLii/UzW4ZLpV2NlAHrQ4Nu7GY9DZOLGb7FgK1vdTPT45o81+fISEFoq
	 M3X9Md68fnF1w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:24 +0200
Subject: [PATCH RFC v2 11/54] x86/mm/pat: drop the init_mm read lock from
 change_page_attr_set_clr()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-11-723f1e33c3d8@kernel.org>
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
X-Rspamd-Queue-Id: C76521C0008
X-Stat-Signature: h3wc36t6ytyumyr7mqa6bap4x1bagazq
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795691779-153859
X-HE-Meta: U2FsdGVkX1+wU7AX75y9U3g9lDHBIOu+DQgHHcL09AcYWHfSW2jz0lcLCan9WJT9RrnbwWrh1m/eHZDx8dE2J2kJkwb0WWB/2ckXLPc7Phy00JPP/iZPS7EHFkzAjoDxiPD/XB+369i2HcQUJ5gPLX7I/yU/3Uriw7IrBpomLIhhUHIkgLc73+OIpQu+zkNZC51jvSU7ykhEfOTEB00FTuQGFUf6jsybwxbMmPLo2w5DdJ1AXHvavGWJ4NuuStq8n9zfEIlx9Si+E0OgXY7TBUObxXQGUuFkuZeg4FYYSPz6r4nkDLbszCOiF4uO9n2Ybf8ft0rd+AHOdjddE5flM6nw3kCLFNn0WUat6Z8puJx2XSebxF3ETOaHBkC0zdfJ/Qy2Wa7MT0wB6DyhZQpPaOTa1HiPvxZYaoWhjhRZYgIP57kjnmuas+Zhhe6Zek0VTyOVKaNqQgrZgjogara86Xfyt5pK1IewPEu9bJCR4FXC3fy90b/ZtSZdXz1WQxrgmEB+h2fpp0dNJ1dqorMUVtRgd9+uZIIg8ZyMim2S1Ufb+Ppo4EB1mKp6t8e+Kzo3PCetK4XfalOA0FREvAwT3iyILgT7lMESx5Ve0sn6SdCsUFIg0lbUO/jWEx1t2uWIyCcAKG0kNLP7GwAE29mWVpcyYSnn1QysyW012smXM+Ky66ajyYZTBIBx/5+A79oXqvoh3XeyUljbuoKiYyzlQGL8VRRXaTAH1eH5Y1kbOTIuD4BY62wQT4b6RN3IoZLzZIBwagLAiRALbrDQgOkpPtK+APSf7HmquzE6hLmk6RWq9ITgEC8daeCCQkac0PoPY6KXmLonp+OdYiCD17HAmVCZtM07RCtqRAcPgKtHyxRuVVkHtnguPvZ3u4tatRYmu/6Had5EyEYxYeZrTPr+cVcXhHRqVb3hLp09DCgFBkLJzgTAfBYVeUXstq2H8nBJPtuHzmGDVk/TJCf/j1N
 jSergYLN
 2n7igO8w5kPvkqaKeEuGVo+u0QQ/xz+pgWKKiK7fL3rFdDn2FZCtiv6aly8MbP1TeRi4fEGPfI0+y2htS2ILg/4k5Rq+kwfI2PZVK2yVRdCY0thZxjUWGxWogF+HaidMHHaYdoURsxLL57Ik41Bq6jWblxnAZhhKTTGLe3pIx8JUSjmB+Vzs6sYXC1VVRCfVD2UD0+T0PTziAVMnzHaNhLN0K6Ds5B6HYSYmKxCN3w/Jt/Em8WX1QeXddd/QA20zyGqz4ny4b8b2BsA0BejfC+PL5JJtxXF7PA0XgmL+6Mzv0n4IzeonLpCWS1xDUvpF1r+AFTpv4SY7SsWamXdWLBU2xt02eZfkyzbjzj7ed+5k981+91jm8LYwofGrRat1JmM6wiesNAVdDhKkEdgm3HPN7cxvI1Tn3zOGiKeeSUNn7DfywlDmV8XCnA1wooUfaTBMBB1jKcxTvDW3bcplGFAJMuFmNhQGZwGZ5vG2TharpZL2cnIyjEEQBUaSLcR48tdhULAusqLBTPss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

change_page_attr_set_clr() holds the init_mm read lock so that a collapse
of large pages, which holds the write lock, cannot free a page table under
a CPA lookup.

Since commit 1aac65f3e651 ("x86/mm/pat: Take cpa_lock around large-page
collapse") the collapse holds cpa_lock as well, and with debug_pagealloc no
longer using CPA, cpa_lock is enough to synchronize all CPA operations.

The only thing mmap_read_lock() adds is keeping out a concurrent ptdump.

A ptdump racing with any CPA operation except collapse is safe: only a
collapse frees page tables, and a split replaces a leaf with a complete
page table. The only difference without mmap_read_lock() in CPA is that
ptdump may show some entries before and some after the change.

Collapse, though, must keep the mmap_write_lock() to ensure ptdump and text
poking are not accessing page tables the collapse frees.

Remove mmap_read_lock() and CPA_ST_INIT_MM_LOCKED from CPA operations to
simplify its locking model.

Update the comments of cpa_lock and of the mmap_write_lock() around the
collapse to clearly state what they serialize.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index c3af82788879..e1abc0d1d143 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -61,9 +61,10 @@ enum cpa_warn {
 static const int cpa_warn_level = CPA_PROTECT;
 
 /*
- * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
- * stale large tlb entries, to change the page attribute in parallel to some
- * other cpu splitting a large page entry along with changing the attribute.
+ * Serialize CPA using cpa_lock so that:
+ * - concurrent requests don't split or change the same large mapping at the
+ *   same time
+ * - collapses of large mappings don't free page tables under a CPA lookup
  */
 static DEFINE_SPINLOCK(cpa_lock);
 
@@ -78,7 +79,6 @@ static DEFINE_SPINLOCK(cpa_lock);
 #define CPA_ST_FLUSH_ALL	0x02 /* flush the entire TLB */
 #define CPA_ST_ALIAS		0x04 /* the request is for an alias */
 #define CPA_ST_STATIC_PROT	0x08 /* enforce static protections in a split */
-#define CPA_ST_INIT_MM_LOCKED	0x10 /* init_mm's mmap lock is held */
 
 static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 {
@@ -1238,11 +1238,7 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 	int ret;
 
 	spin_unlock(&cpa_lock);
-	if (cpa->state & CPA_ST_INIT_MM_LOCKED)
-		mmap_read_unlock(&init_mm);
 	pte = pte_alloc_one_kernel(&init_mm);
-	if (cpa->state & CPA_ST_INIT_MM_LOCKED)
-		mmap_read_lock(&init_mm);
 	spin_lock(&cpa_lock);
 	if (!pte)
 		return -ENOMEM;
@@ -2110,11 +2106,7 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	cpa.flags = in_flag;
 	cpa.curpage = 0;
 
-	/* Avoid race with concurrent CPA collapse. */
-	cpa.state = CPA_ST_INIT_MM_LOCKED;
-	scoped_guard(mmap_read_lock, &init_mm)
-		ret = __change_page_attr_set_clr(&cpa);
-	cpa.state &= ~CPA_ST_INIT_MM_LOCKED;
+	ret = __change_page_attr_set_clr(&cpa);
 
 	/*
 	 * Check whether we really changed something:
@@ -2143,10 +2135,10 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 		goto out;
 
 	/*
-	 * Take the mmap write lock on init_mm to:
-	 * - Avoid a use-after-free if raced by ptdump (which takes its own
-	 *   write lock on init_mm).
-	 * - Serialise concurrent CPA walkers.
+	 * Take the mmap write lock on init_mm to avoid a use-after-free if
+	 * there is a race with
+	 * - ptdump (which takes its own write lock on init_mm)
+	 * - text poking (which takes the read lock around vmalloc_to_page())
 	 */
 	scoped_guard(mmap_write_lock, &init_mm) {
 		guard(spinlock)(&cpa_lock);

-- 
2.53.0


