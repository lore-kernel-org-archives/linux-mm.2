Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A4CC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B566B042C; Thu, 13 Aug 2026 05:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2C06B042D; Thu, 13 Aug 2026 05:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1307E6B042E; Thu, 13 Aug 2026 05:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E75C56B042C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:01:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DAA1160526
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:01:51 +0000 (UTC)
X-FDA: 85095653622.09.3A614D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6819616000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:01:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PH2JAqBI;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611709;
	b=hORIfBVWTMTsvOFwU16FubYzwaEkCeqtbcsHR+wbODIIK9iC4BqjAkUi+SfEXYffnWE3SE
	7BkaZz+QeYI9H8GaWyUbXkvIRsRv8ZjrqBzdX/48F+5XOLsqzB7f35ujzVH6LO9my64UuH
	9k81jQ6byX5vzBbdu9I40jUBRpqBSBA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PH2JAqBI;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRSJV6+wHMCp/NANau/roLEK+lDHPucZMiMPxBMKL5U=;
	b=GIOwwvMn5DePKDtFfWPTfKvw7joz4H8MPOsQNWkZfAtrzR3tSWYDOIfVXu9HwfdWvNsVfH
	ixuqfNZqMehyFoRblHZ7gZ28IxPPC/fl6XRWJYKKSJjVKWNATWOxuIDnGkO7qXxok56GkY
	4HtyiXh0viE1iZQ5UlSOZgOzHdqMPJ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F07AC600E2;
	Thu, 13 Aug 2026 09:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6581F00A3D;
	Thu, 13 Aug 2026 09:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611708;
	bh=CRSJV6+wHMCp/NANau/roLEK+lDHPucZMiMPxBMKL5U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PH2JAqBIaEBKerWzSh1Dt4eMzbUkBQlgGpe8Iwq8jlPTpKtSGwCa7MMcudT4pyKdb
	 m2SP9Zyw4VfKA2fYBdSvAE8xpn1sJ7+yjEOUVNRh+M8FA5uUlX19MD5iPybqbOygZH
	 pHzw9NcRz7HVK43LC/p6b71fHO2zdidVMPtdlpZfvlT5T+26dEYfe3iH1OHBYxC8Ic
	 FIuwIqjq4lWbS3HVvSm+cDUjGKf/1scH974kVr0txKC9FAa8ZL1Nz7WJPHwaTHp1KN
	 eC0V9tjfcJpKdwj6famWSz4jdYfd2EuxwkAcCVF8nhMInbu/gdamdyYhdpBBB1mM2P
	 3gjX+Vb6NoUeQ==
From: Mike Rapoport <rppt@kernel.org>
Date: Thu, 13 Aug 2026 12:01:24 +0300
Subject: [PATCH v2 1/5] x86/mm/pat: acquire init_mm write lock on collapse
 to avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-cpa-fixes-v2-1-39b4ff90f91d@kernel.org>
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
In-Reply-To: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, 
 Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Lu Baolu <baolu.lu@linux.intel.com>, Mike Rapoport <rppt@kernel.org>, 
 Nikunj A Dadhania <nikunj@amd.com>, Pedro Falcato <pfalcato@suse.de>, 
 "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Steffen Dirkwinkel <lists@steffen.cc>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, syzbot@syzkaller.appspotmail.com, x86@kernel.org
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 6819616000A
X-Rspam-User: 
X-Stat-Signature: ogntnk31zkfg9qwr3nipyg9q75c3qnoz
X-Rspamd-Server: rspam06
X-HE-Tag: 1786611709-202314
X-HE-Meta: U2FsdGVkX1989w0vLRuzw7HPoyQmOQ7CK0kK4Ewr2l8O/YcADyRBnUQHHxJ1ZZxPAiGnkW9dQW6SnjJycUDH7eh+q0+2UCAhq0WlXcrhcv2pCg9U4s03nMwICBlCZvtb1ba3GtHxUtYe+P4W/okKHHG3uzdHMnDP7V6nbBoG5FQT/DoXFnE0NLIL0EmKb7lKtx0tf1jGcr8Ch+nwAeuZezwwdjFOxi4Q+xNtv+UxAGwVGOo7qiJcg3BSvOuiFp4R7No4NVIg8rz+euEHcbyFB8BPyo/bLCeYgjeO/0m31XBaUykbnbdS2X67TRIxNJC4jQo/L67Q5NMR4nz/oOFW2Gfy5ym+5QAMWirCr1uPn0OaIOKYXhO5teuhZq3zVJj6lvkB5r1boiAtRzmoNOIk9a4EYfU43KSTBu09D1grgrGlyKWUdu/T/qvaJpGlmhOkP4zGcWiLfsP76r+uCcXSfJKXzaxxFxy45MV0Bdi4v4Kh6cRSCkxa/L0yGqalBmM6OUTdvSWm+Du9+OypUA9wHVj4c10xfVCuDQ1xoQT5id2DddtuD80Uvx6AqvOLhrnU0YgCIIhvyNCq4M9DXVy9DWrVcQtr5fwD/+OpONe6s7cIWqAfbiWqt2dfLOIfBCLd0y2gQmbkG/bEd741LQxTKIgO5IztA0c1Iire+ieHpj+mxc7u3xfMX7oVInoCCimEp0ac4rM12EKdTzgOZlhH6uG5Ht2e/NvFSp4M41SVyyCDui5+LkVVKPhyTkdg0lxkQd+AJEJaHbhHnm7Ozn+tMNxFW+9ZeeysSHanUPnJO69RuD+/urhQjE+NRIatgbcDf/phKFyAzLOExmSgprvigwdUAzyRdt2a1NW/CtX7jQhMVzS/8oz5Ai+01bybPWM/lqfjjh4ZEK+kPdCgnl4SCOEXDNRSHphu/WToRgMcRq8xLWx9/2gFNSRTWkgdWXDoXQAL49liBA/iCkqmADQ
 mHWY2vod
 3GioFDgSvf7v5aAGOsNngiHXwcNdwmk6t8HOVhynwLNDYP70v3aG5TgZeGSI8GloX2RpkQ8GHcKG1Rx/1SKBLmGUb9vGHL6sVk12yUy72yLVq9/4U+THX51reZQZnI8yrIjrX2J6L2/sLFXS3Wtda72ZUz/m+R6gb1llU30co1CCtXLAvaSJ4CbsntZA2QAApRyBMFipArIsNZ3opTZ6v1sr5qaw3LnhtNEhEatN9kKS1sG1tHngLVG1CHUj6Uw8rQ21s26qiow7H3vn8RLf3qj3F6o/qeYx0UFhyR4RRSrzZKuXGvWhp3r+Cjg+Oil15FkbUuFmAtG4sQMiZTK1TFhEaXhl3D5aK9YR09vr6tgmduEQFmxZRcdI+h2PPU0pzw6fGDiZa/Kjjznw2rxZERtkBUtQuDdLrJndb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

x86 implements page attribute modification using its Change Page
Attributes (CPA) mechanism.

This tracks properties of ranges such as cache mode through x86 page
attributes, and as part of that logic manipulates kernel page tables.

Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
fragmentation") ranges of kernel page table entries can be collapsed into
huge page table entries as part of this logic.

As part of this collapse, it frees the page tables which the collapsed
entries previously pointed to, and it does so without any relevant locks
being held to preclude concurrent kernel page table walkers.

The only way this code can be reached is if CPA_COLLAPSE is specified, and
this is only set in set_memory_rox() via:

set_memory_rox()
-> change_page_attr_set_clr()
-> cpa_flush()
-> cpa_collapse_large_pages()

Notable users of this are execmem and bpf when manipulating executable
mappings.

However, this is problematic for ptdump as it walks ranges it does not own
and thus runs the risk of a use-after-free on page tables freed underneath
it.

In addition, concurrent CPA collapse operations are possible which can also
cause races.

Resolve the issue by acquiring the mmap write lock on init_mm across the
whole operation.

It is safe to acquire a sleeping lock as all the callers invoke
set_memory_rox() from process context and in any case,
change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
mutex, disallowing atomic context here.

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Will Deacon <will@kernel.org>
Reviewed-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 ++++++++++++++-
 include/linux/mmap_lock.h    |  2 ++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d8d057f44417..c18b887ee4c2 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -409,7 +410,7 @@ static void __cpa_flush_tlb(void *data)
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
 
-static void cpa_collapse_large_pages(struct cpa_data *cpa)
+static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 {
 	unsigned long start, addr, end;
 	struct ptdesc *ptdesc, *tmp;
@@ -443,6 +444,18 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 	}
 }
 
+static void cpa_collapse_large_pages(struct cpa_data *cpa)
+{
+	/*
+	 * Take the mmap write lock on init_mm to:
+	 * - Avoid a use-after-free if raced by ptdump (which takes its own
+	 *   write lock on init_mm).
+	 * - Serialise concurrent CPA walkers.
+	 */
+	scoped_guard(mmap_write_lock, &init_mm)
+		__cpa_collapse_large_pages(cpa);
+}
+
 static void cpa_flush(struct cpa_data *cpa, int cache)
 {
 	unsigned int i;
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 04b8f61ece5d..f4ceb968aeb3 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -621,6 +621,8 @@ static inline void mmap_read_unlock(struct mm_struct *mm)
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD(mmap_write_lock, struct mm_struct *,
+	     mmap_write_lock(_T), mmap_write_unlock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {

-- 
2.53.0


