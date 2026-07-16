Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 956CDC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793756B00AE; Thu, 16 Jul 2026 17:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A426B00B0; Thu, 16 Jul 2026 17:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6598D6B00B2; Thu, 16 Jul 2026 17:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36F5D6B00AE
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:31:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A62081A0308
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:31:56 +0000 (UTC)
X-FDA: 84995937432.17.5C5C1AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DA9B5A0003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:31:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVcYQQqp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784237515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Op085aHgq7EGWjw704qIT6T5yZRCkSyhbHQ1mSMEI8s=;
	b=U6kMd4y85Qv6gsP6khWZ0YLM/3uhlbisbAxryFwfn9C+Zz/5shFRabYuUwhHyY8OVKpbfh
	hCD8NzF8aLmBJOHbtlXy1m8HHp0jKFuSBdXpMPLGZSlBebIiktJHusvmUKm/bT0WEuo8Rd
	SihrLpQ8g4V+bo3sVRJzXimJE7lT9bY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVcYQQqp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784237515;
	b=7Nsn1CWZ50cgKxkVccpebGzOY7uDWmHkY497jSf7KpDhsPjx/smMDhFJ2lYLR4Nv9cLKxT
	xMZ19A/WKNq1opyDNKTv3/iEQVbcDFeu971x4cy4OcAb4SMFnCaKeN0blmkjjTqL3AHb8J
	zyn6tBrSsNIfr+rLYaMokVmla+9mSS0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 367B64051C;
	Thu, 16 Jul 2026 21:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E601F000E9;
	Thu, 16 Jul 2026 21:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784237514;
	bh=Op085aHgq7EGWjw704qIT6T5yZRCkSyhbHQ1mSMEI8s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HVcYQQqpLoh6Q92sYkqOm0bXJh+/09opzvs/PvUscy8+isf3kIAL8ZxMw8DPBpRUZ
	 sElAaONNpmvFtREwnkiCc9thHVE3vOzVGkgrqTF4A0CPCLUZSGGqQ/JIlBymedlrth
	 Qabki4DyCOSHdyGgt/kNhbk06oxFYVqN5CslunAP6MEv8eyO5mPTDVbCRuRDINEf93
	 q5tq93tz5Rg6gIrfqN9mCUOqHTDFydtEEEN49/0tCFjZnFebXrQGXpc9PWnem0oe0z
	 P4nn+geMJHZJgprDbxzA+3wgXHpaQi2xvxFL8Ybima+1iG4mArdAkJQ9wRXlPQ3iH5
	 t2o8ckdjevp0Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 16 Jul 2026 22:31:13 +0100
Subject: [PATCH mm-hotfixes v4 2/4] x86/mm/pat: acquire init_mm write lock
 to avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-series-vmap-race-fix-v4-2-8c108c4317df@kernel.org>
References: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org>
In-Reply-To: <20260716-series-vmap-race-fix-v4-0-8c108c4317df@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, "Denis V. Lunev" <den@virtuozzo.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3954; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Tr/TB2AVwbvv7zzaS9pkOVNBodaCW3bWJxJVOhSXA9M=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIifdeu/9y1Rs3Jfe1W7Rldp5bbKgfO8/reO2mZU871y
 nuTn5RpdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiE4sZ/lfu/fMi2iYgTWL3
 lP9NRxWPKwf2N4e7PlYOv9JRLV8oFMzwv0Blc0TXr6sXurTN5dUy+k2SD8lnn55fvj+K+YqCfm8
 KHwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: DA9B5A0003
X-Stat-Signature: xxfafqkf943hmsrh5apeu46aannrxfof
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784237514-220832
X-HE-Meta: U2FsdGVkX18rZEy1HO6Gm2Pj2vU369mnf0KsBfOVBdmkRUM2nkZDriUHIcTSIKq9UT3FeUWP1Yv7wu2eopmlYJSj3RvHXpSRe9soIGL840AZFF6UgsKjSaIB59xMjPKNVzw41V51Vg0LpaTPZ5Ln6uJCLe1AWDLjFE0EOGXftzynmLTlYvT3Q/O/jd7cFTjTI7qYMF0WsR4SwLRAl1fqvL5XQvYfpiExs1nsqvv1sun2lBpERBJGy4bhV1xIMLuuGeLor5ZmB7avVlRWa3YXBMsferY6+0qdWHlPvDQiRMkowsSDTcoiUa3uGORKPuRJ0DjTbPh9wlW3kTC6p1NeZbUoyX60YdXNMtFbnyuU3mX+3gGfIFEqvFBTmcKLv3Opae0hIU+mZxRWQ+NPhsi3U4s/hOayjb94B3RuolWJV3d1J3mlZLvfFbRld2WuLDHuYRXmvixpxtxKHQTmGJeb5Wiht9K81kcuGg+XFhWflsT+VDgt4i6x5lHpSH6hzCQR9XTEQIt/bM7B97pg7RmDLnDxeEtmSrpfYkeEAg9+ugybN3skU1TJ8g5X6gVYPaymD6AALePWywsXFHulSZzdV/EtaAs5oZ5Uh0uMgUKamBFEKittN6EulHblb8i43ATMz8fZzSD2q0pa4NRet+xgsefD90hylEYconcwScFWSoT8j5OV+6XJcRnNP5Wgl6ZfAtAfeMdjIP/oPSqq5vcfNt6zEDLEIsjAN2jIgyKr3Wh+lUfZyaoM8Y/wbTNHzR8kPl0ZeAXWcipFxBufcAWoZCdxABjZx01AeHYZiOKB8LGU5Q1ubI2ntcoB0NwiFYvIB8o3UP7UuhocLms4hy7H/O9Z7izGxOg8LG08W+5J8U8Tdc3PJbKu/bxhxx5cfj2orxRN78ti5GOfjSJWwXNeWE/k2TSHN4uRsGaKr9F5TIIo7IOqNVa2j0g9zoJOaUoUaIII0YelNfXfX1rJejB
 xUGVQFnq
 DcLwgYybP1+v58AjLplkKjIc5kK1qNjG14Gj1TT7dPyayDZUbRzGoFGVDQ4flVYnNwY3fOfhv5vUvPgJO65YnAXbqQr4SSjhTDx17QKftSOAQO/tgo0Tk+X2WGNQayO3JvY8FhTTodMfKUTiGgBhz4U7JKV6W64kvnuXmYaEwxOnfoDY91ZmtpYTh/1DJMrrxRlLAc0U5JW4g7bUoft9wafMbV9mYZMpupCBrfDyZmVQPyxUp72HPZG6V899Ro/8eCMRJuKnzSHMqgD8iXjfGxxmGLuuObgD7SXoyIeHgAuGfje0wIzRJcEw91/hcnjQ8EApP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 ++++++++++++++-
 include/linux/mmap_lock.h    |  2 ++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..d1e63f7d267f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -410,7 +411,7 @@ static void __cpa_flush_tlb(void *data)
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
 
-static void cpa_collapse_large_pages(struct cpa_data *cpa)
+static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 {
 	unsigned long start, addr, end;
 	struct ptdesc *ptdesc, *tmp;
@@ -442,6 +443,18 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
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
index 6b5c2390cc30..047f5f5e2c34 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -621,6 +621,8 @@ static inline void mmap_read_unlock(struct mm_struct *mm)
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD(mmap_write_lock, struct mm_struct *,
+	     mmap_write_lock(_T), mmap_write_unlock(_T))
 DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)

-- 
2.55.0


