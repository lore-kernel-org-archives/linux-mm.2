Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 677A8C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148176B00A9; Thu, 23 Jul 2026 11:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1204F6B00AD; Thu, 23 Jul 2026 11:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C306B00A9; Thu, 23 Jul 2026 11:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA5CE6B00A9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:17:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1161A1A0554
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:21 +0000 (UTC)
X-FDA: 85020395082.14.2B853D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5CA3F12000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OEW0t8w/";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGfvVz5phYfszb4vs/wrQwKbo5YfQ9htQgjlD4h0uzo=;
	b=BFiIz5G14XREaZ0t+4ERMStPRanQmZs4BLc1ksEfQt3S+yiUJLzCfSIpB/rlp1TnqkC4mr
	RgXJix/eG3DhIDzbF6h2QWpc20dUJqtq5OSkcJZQK2AEqdCwPtOfvotbGzyuHnbSjb+Yir
	K2ZnAR/sLfoqciMmhvsjvuQ56UQPbao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819839;
	b=O6swoyQZsMqFOiFMcXZPRsc8ehpwOP+C6dIHMw70Ln1pAr37jZsmJcVyQpbsd8kgSPgoKr
	6tYQGSUt6VX1zamKI/ZqX+zPAkim8f5nJ0CKCSnEmcH4QI3AsnkDzuk8SKfmLPeJJ7q4Qg
	UOLWeUfxN+E2OoZrbwgCIjPPxOR1y58=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OEW0t8w/";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E110B60A85;
	Thu, 23 Jul 2026 15:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448C61F000E9;
	Thu, 23 Jul 2026 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819838;
	bh=jGfvVz5phYfszb4vs/wrQwKbo5YfQ9htQgjlD4h0uzo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OEW0t8w/ZdlXeERCjc75StArDzDUqbCfBmj/Evab41GuYCBr4ySbLeSLVRFCMGDv+
	 l/ctMnIh60mbWkTdAktAFmL9qN05WJa8i0aOq5ilbl+d8NsWSz3RRjVbBSouVtRrVM
	 iIkARpos/gy9E6Y6xap1sb5R8kGxxStmgv2YxQD92ZPMdQzDm71GyCKg7SOaoHWpSk
	 msBqA3iq8JznuaUxh2t5IkX+7Si6Kyh0nWI4L6NqqzbExl7eiMUQCzwJtzlqMH+b9D
	 MSEzlmyzhr+pkSk+W/MEA/VPlHCL+klN7I9sn8F3dEM8FlMuu2UxEFYJRfR5FBnSQn
	 jDYMIua2YFiTA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 23 Jul 2026 16:16:32 +0100
Subject: [PATCH mm-hotfixes v6 2/5] x86/mm/pat: acquire init_mm write lock
 on collapse to avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-series-vmap-race-fix-v6-2-8cc77dcc0018@kernel.org>
References: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
In-Reply-To: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
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
 "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4047; i=ljs@kernel.org;
 h=from:subject:message-id; bh=3isjtK28wb1BiLlMBIpy71VvY1jYYrdz7YUUYuIwCk8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKSDGJ/vL0Rc3P9G8usFe9mixwynvfEO80n4NQqqbCXw
 cfUbMpaO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRG7sY/ufu5Fgs37pTbkL8
 3TldD9vP771waZK/w1Pec69qPkXfyX3LyLB0xzdr+6U3D30QfFtaOetH0DOr+mDn5iN5szhtf4p
 uecAAAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CA3F12000D
X-Stat-Signature: t79hwo1uzr4754rcai7z1jugjjxt95zx
X-HE-Tag: 1784819839-802553
X-HE-Meta: U2FsdGVkX18I+GdxD+mhR1Cu4t4azPATOw32B45OeG4CNn8g7Z9lQp8bZc0mOGDVcm53T8UKHaEGgqR0F6KQQUoqcEtQE7Vd49uu6ymhfjrDbrqEUA22+FKZtXJPihxlM9X3/oXBTlLPKI1JaHD6MVMs4ncG9sIc3cF4xr4PB8TcuCUbzDn9TaCmFm61ha61oGN+XF1l+PlRc8DlimKz9Kxnidg8NWOye38BHeE+N5UwUM6Efw89HwMkEccicQWWXUD9zapYAS4y1e+zKveZ7WiphFuFf8+pK6/m0RWvsWO1yFUonAQ8+bkXpN7fq8ZMRPrGdkfg23Pi1WOirz/HsQwJsh1N3DpBaaIfjZSIc0zteJjLjrOgmP7haIKOu252yZroNzHaEnnoktp5lSMdbJ/kH7+ixLu9Z1qpBTmG5UwGKsnopKGvq3oMA7/buQGOm1ChQb3ckW0/Ss8DfKDhmVfx5nJ0pzkT6tI0Q0x7iOiAI0Ge+CQLW0ERZk4tqlUEjJq/4T8zPlZFHt4lDRStes0J0j0DnNMqoLxwubUhiApH04xFzk+O+igE2BYkUh1z4GuYlgqWRvIixO0/nWsFHD2H/eFjMGmkDE2TTMDH6uwnhB3V/sLuJqmjyvij0nUgLTvFxVeZrEM58jU1Y+Bde4hKyMOxK9N1722fcqhlxWln92nbrpsoiLKgc/Lxo09mbulMw4fiJUJiCFNK0TDrQsHZXbFbDNw7wWsao0g2vl7mzVj0Ff8Ir/3snaA/hs45x0tz4b2ScGANB/U2bS4mc0+yHJ9XNPQxQ9IMfhrL0HQBt0pMVb/nIS8+0X0htIfK5VXs5FsLq4T0maMfwn8D+EKki72gwRG4uWsJrvdUoWgqOfOt9OL4VwlroRRs3d0S7Njgt400yHif7h0u/W97MarjuY+YKrZryJZwPV6xjP3d/aKYrKPSzflcO1grR0Od+88/3+L5P8PulYlqnFL
 50r/iIe0
 4KencMZpkC/y+BnmxBw0zxUTMNOxcESb8kJwT755tkvkpZ5bHf/zO4vj85U66x4nr1G+u7ZotF9VHYpL9pYyrcVnpkt1ukGORudj0xycOheoDpcutAJ7SDiBPcui6WgtW935Hvbj6tOb6PStF5OQ+hlr8CvTnkV5P9lsEy/2GEMhhDbc65hktwVJUCPKmOw3QZA5zyw6a5pWfpVu5Rhhza1cYcxPBqX5VYFJaa8Ii0nd6EHjJDP4y3aXpkGXpQcQBttxuFOubKL8Ny7E9ESdUzqEYwnw6Gv9B0acALGPAHpOjfnJIEW/XLir04d9WLoiWzy4u/EK53sKbZ8sk8UGd6yKLOQ==
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
Reviewed-by: Will Deacon <will@kernel.org>
Reviewed-by: David Carlier <devnexen@gmail.com>
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


