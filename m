Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2329FC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 23:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975A36B00A3; Thu, 16 Jul 2026 19:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926896B00A4; Thu, 16 Jul 2026 19:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8185B6B00A5; Thu, 16 Jul 2026 19:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BFE46B00A3
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 19:41:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF4B3A047D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 23:41:44 +0000 (UTC)
X-FDA: 84996264528.14.2DB2416
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 768B3C0009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 23:41:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GWrE81Xl;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784245303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/howEIvgndH8o3pTfe48AeTP4vfYaSSQLtkWDw5tX8=;
	b=6qC4sbvDPFvaqe2Zrroqo4JP61LRuB3sXojh3weHPSPDQd+0peIHlgb5dVZKdqZFh+hnXW
	g0H6VMHaL6TmvBzBpXNR61swoCgQvLhD07m+AHmQvUhEu65joXeVbUrtUGV5udtPqkf6Hr
	3FkqgEk91E4UYtY9Vi6gbacJKNgeiZE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GWrE81Xl;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784245303;
	b=7fBZF5PDfqnRhnpv53oesyeiB93Aa7Cu5Vg8ZgfB9QnBU95JrgIBt9y/vNC/7EHONFYGHE
	Z9Dwd3nXE+39MJHR2jOb3IKE7RuQexxrV2CHZiJ0uKUJhP8nYm/wODWCJ8tLgq+gPPEyma
	ty2IB0ahWMXHLB+wJsJTJedl4k1w2po=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2478740A64;
	Thu, 16 Jul 2026 23:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ED01F000E9;
	Thu, 16 Jul 2026 23:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784245300;
	bh=S/howEIvgndH8o3pTfe48AeTP4vfYaSSQLtkWDw5tX8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GWrE81XllWQl5SeoAjAivl6b6wYYesCrb3N/mzexAllJ4UnlAwuaaRX7GYBfNhYIr
	 rUzjVX8SFgudmVpquJg4CpGAaGpYbm4V4SpJVtnrB0p3D/HJCveyAZSGNKLNPTz3Qn
	 +RaTiHE7dRlrCVuMrmUyMzGB6SBYcoddUR9tNrCE=
Date: Thu, 16 Jul 2026 16:41:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Uladzislau
 Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, David Carlier
 <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Denis V. Lunev"
 <den@virtuozzo.com>, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v4 0/4] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-Id: <20260716164139.0b447152db49db857cc73037@linux-foundation.org>
In-Reply-To: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org>
References: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3111dkqbhu6iqt8zjh4d3ood8zxrs9tk
X-Rspamd-Queue-Id: 768B3C0009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784245302-391021
X-HE-Meta: U2FsdGVkX1/5iwbpvnR55u7XC7QGyWk+CAwYZtklSgiTtD05NXsjlO/Ux7s+6n8h3hXJXF5Xm8VwTa4BY27wCdM1BHHSTpUo7vLGFBZoVyw8c4hHXn+GSUhP6OI8qqOuvzcuXHl7bhKiaXOgA9RYkg4FDeFylPtkYoCqCytPh0ge2M7P4n3wLR8HAw8Tjn47e1zK4OS07SxViRL4ETrCcAFgy79ysATNA7T13dQKhzsu7RFuSRvSO/534MEkgWWER4aXiLn3KXaqKtwD2yJu9RiHll2mF6IDVCRT/GMHy1XL1xRs3VkIdqGOxIvtcwdHY/AoeacBnd3CmMYCtFz2TtgRNwlhU6HL2pqj2ibeeQGdfW+NqSSagfLSQFBmbaJaikvtwD91EEAotvhpL8J5ZLAwD9qAV1aKCA5RT5xhXvTzyRCzvrtKfa/p3HiVPs9UutNeb8VuxaS3WG0i9U10b9k8Awqt8rMrAsjIjI7yJlMwovJhSY5XSXA/BtQwHg8Ib9M3n4PapuAe8Ksz9KIfvPimIMrOmi0hocjUwuucK2Ad0OqZwzPnjomO0Fom9RebElAxSeukvYG+DsCwXjwyhDBDR7yK8NSmk9+tJ5pIOE3uif+MKeD0dhwKYDB75VLyVMthCgVWqYhcyqgDgsg6Eu+SJXOS2l4PeBA9B2G58l3E30WxBQHbua4L7CEdk7tgURBKT8W6UwfPtq5lwusPraxeGkT6zzP+A533RAqGM9pkPiKW5fsg1GQOvMZZfyf4V82WPQaCh0MUDfEEALiNe+dqiOXH9eug59WooIBN5xyaRvIM/vQYm2bLfd5VP8VTA6njg0Dbv1AmQc5vlfzw1NSFqHiUZzxG1+Wj82H6Gzwd6VLBg3MG43BVTkKAlMZToJf8j96Lroolbf4a+8zDk1lTsSzfK95f8gb79G6jlu6X41vqIUUQD7cD/+XsyvIgI8iYJRdAtHlfWMOLhSZ
 zI58Xrt8
 oNVQgWtO3H7lHtTj690cRpdWYEnzB51Tqy3hRE5/2yE3eTQ1el4viFhTV8d6g0YQ7HO1aPZ61nZjtMvIvrQVGBidtlrVkvJiiUFKo7RDSDTS8wpzVfgJPO3kF1EVG+C8w2Fezhhrahi2HdvzDXpYk0QMKtqYdSehMSWfg3aMBJYbGIQAFqURjgPFVXhTm+itj2c+oep7HGc79q8MIxvpU8jhCmVCY+cqHUlQXQfUEedpAFvVf/eDNXLnUU6zp0wD9KkByc56lajahbkdtHAR4YOdi1P400bjPabWf5JcYkN0sv5TbYk6r1ECuYNVOjZEm2v+F283dkcj4CxCTCB9A4gTCvPoRwGmfFjpFiL4od0KjlclG0tyw1ez7v+fji6N6ow81weADI8h6PqQlzDmBdVeJf1ztXAB4V+OQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 22:31:11 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Kernel page table walkers fall into two broad categories - those ranges
> where no exclusion is required via walk_kernel_page_table_range_lockless()
> and those where exclusion is required via walk_kernel_page_table_range()
> or walk_page_range_debug().
> 
> ...
> 
> This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
> lock in vmap logic, then partially reverting commit fa93b45fd397 ("arm64:
> Enable vmalloc-huge with ptdump"), keeping the enablement of huge vmap
> support, and removing the ifdeffery with the partial revert patch.

Thanks, I've updated mm.git's mm-hotfixes-unstable branch to this
version.

> v4:
> * Rebased on latest master of Linus's tree.
> * Accumulated tags, thanks everybody!
> * Updated commit messages further as per Kiryl.
> * Took the mmap write lock across the whole CPA operation as per Will.

Here's how v4 altered mm.git:


 arch/x86/mm/pat/set_memory.c |   25 +++++++++++++++----------
 include/linux/mmap_lock.h    |    2 ++
 mm/vmalloc.c                 |    8 ++++----
 3 files changed, 21 insertions(+), 14 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c~b
+++ a/arch/x86/mm/pat/set_memory.c
@@ -411,7 +411,7 @@ static void __cpa_flush_tlb(void *data)
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
 
-static void cpa_collapse_large_pages(struct cpa_data *cpa)
+static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 {
 	unsigned long start, addr, end;
 	struct ptdesc *ptdesc, *tmp;
@@ -437,17 +437,22 @@ static void cpa_collapse_large_pages(str
 
 	flush_tlb_all();
 
+	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
+		list_del(&ptdesc->pt_list);
+		pagetable_free(ptdesc);
+	}
+}
+
+static void cpa_collapse_large_pages(struct cpa_data *cpa)
+{
 	/*
-	 * ptdump might read these page tables, so avoid a use-after-free by
-	 * acquiring the mmap read lock on init_mm (ptdump acquires the mmap
-	 * write lock).
+	 * Take the mmap write lock on init_mm to:
+	 * - Avoid a use-after-free if raced by ptdump (which takes its own
+	 *   write lock on init_mm).
+	 * - Serialise concurrent CPA walkers.
 	 */
-	scoped_guard(mmap_read_lock, &init_mm) {
-		list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
-			list_del(&ptdesc->pt_list);
-			pagetable_free(ptdesc);
-		}
-	}
+	scoped_guard(mmap_write_lock, &init_mm)
+		__cpa_collapse_large_pages(cpa);
 }
 
 static void cpa_flush(struct cpa_data *cpa, int cache)
--- a/include/linux/mmap_lock.h~b
+++ a/include/linux/mmap_lock.h
@@ -621,6 +621,8 @@ static inline void mmap_read_unlock(stru
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD(mmap_write_lock, struct mm_struct *,
+	     mmap_write_lock(_T), mmap_write_unlock(_T))
 DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
--- a/mm/vmalloc.c~b
+++ a/mm/vmalloc.c
@@ -163,11 +163,11 @@ static int vmap_try_huge_pmd(pmd_t *pmd,
 		return pmd_set_huge(pmd, phys_addr, prot);
 
 	/*
-	 * Acquire the mmap read lock to exclude ptdump, which walks kernel
-	 * page tables it does not own under the mmap write lock.
+	 * Acquire the mmap read lock to exclude ptdump, which walks
+	 * kernel page tables it does not own under the mmap write lock.
 	 *
-	 * Concurrent read lock holders are safe: each exclusively owns the
-	 * range it operates on and cannot reach this page table.
+	 * Concurrent read lock holders are safe: each exclusively owns
+	 * the range it operates on and cannot reach this page table.
 	 */
 	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
 		if (!pmd_free_pte_page(pmd, addr))
_


