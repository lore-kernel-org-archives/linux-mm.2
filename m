Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B01C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1576B00D0; Thu,  3 Sep 2026 05:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8D46B00D1; Thu,  3 Sep 2026 05:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8316B00D2; Thu,  3 Sep 2026 05:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D86826B00D0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:29:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67887404A6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:30 +0000 (UTC)
X-FDA: 85171928100.04.4A136DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 99C4616000F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:29:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VrdwkTOy;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788427768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9taLyiYqD93JJjaXvNS2H0Tq/XxgRc4w/Y2D/omzLAc=;
	b=DtTIkE8XJlaYAI0H6nlK+5Affn3mlJkgwdlUSC6aadusHomfgwCKxmmsTLrsHHQYIXj1WV
	ut265s84+C+8iFyoctCiPjK9c+JQ8sMYcx+w3DotVgLHKkQLxwfltPz7WmeaOMvJ3dAI4s
	osgXwrgV2U9KfUoVjEFjHU55lyZEP1g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788427768;
	b=aQoVQlwZ2WMSWtJ8Kf/KHvqdLkRlcUzIKVv+KxnAdcLhRNRjyTOlXgPxPkmHfqjqQ2O/nw
	1AsE5jk3uF8NR4pd0Mdq9LRgnFqzNQNkNzeYXuxu6VVggjM07YzfDbWZmYYsz9nUuZbpYX
	Hiq1FXwUwpMEijkITQnu0SEOpVlT0pw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VrdwkTOy;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB8D6414B1;
	Thu,  3 Sep 2026 09:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD30A1F00A3D;
	Thu,  3 Sep 2026 09:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788427767;
	bh=9taLyiYqD93JJjaXvNS2H0Tq/XxgRc4w/Y2D/omzLAc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VrdwkTOyGAsb/ezHXc+RSd05q9lbZbkXr7tUSHsqn9+YHwi+EFYdLGxBjm5CEXVMa
	 5auPqef474FyEjKgj8ThRoUCvfHGgYnQrQthDskjPXuoECP/k/VPsudCaoY75xMYPe
	 xtW1Ik2FAt0F+TbQfVXOeFkTvnDfu7oeMBf1BzIBXeP6yqK6YCQrNsfEBrCap0Tjnd
	 AEHtUNOOUJvwzM8VRrjFghlSTKBiJJS98np8SWdOVL7n9OzZ0N5F+VXzsoYuEgNsT0
	 CrJbqG/BJ0ZyOoKN5/1tIx4deMMBTz6zHMCQzDcQyqbkmPUr9RlGTsoj/fbb33i1/Z
	 M4WhiG9yMbmJw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 12:28:31 +0300
Subject: [PATCH v3 5/6] mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache
 allocations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-set-vm-perms-v0-2-v3-5-949b64a9f755@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99C4616000F
X-Stat-Signature: 3fqc3xyxa68q1cg9tdbcawp4rm88jbic
X-HE-Tag: 1788427768-968083
X-HE-Meta: U2FsdGVkX19r/rXgvPrWsUWitBKVttos3t/Mgzhkmy14M/AYdreoWAdN2U+nL4fSZKykLaGe9dIQeVUc6ApP3t8hzt77S9tZZrK7Eq/nejEC825ze0tQ1RID1SB/ujeyA8+lSNaICCNMwdajTsUPWEZN5t4177upHJpAkMRvRPrypheuucvr0iIvG0yF/ad8lELfV7IrRjWEsXsVmg/kN4RVnKLp0hACb2JjWbhNslWuiUHpsgEUVw3BpnX8EXwgMbfJxlaMaPeplEs5GtIjVEwTpcpwCRuStvFi8TpYaxl75KGP51DlM0pxHuLAbu0yDz0MWgmcrOdxCwYX2ccU0rcjs9dd8gRXrJcgDjMAhpRikh8Cq+p/K/oxggwZhUFUeA3bC4OAJdR46Yai86TtzripTsE/B+ZrqkaoTowIH/t2f+u8NgK47rAwCz3qveQI3bmXv4yKqgIDVhV91PwwyL7apUXc1nBszE/3nN2WZ+EfJTqmmFUwqdMRWzdhB6VyVAX6PdYe8xWeLFVhkDok2pLXc21mVKZm1jPCVKxJ1qjERr3iSTHd7c7aYNLoux9ekr8ZN19Vg+d/tkNpfP/9VJjMt2WH9jrQID4wX4xzuKpl7Va6cP+JyYoKMT56CGXwuECQIsI452vNtbp03dN3xX4ZnII1xEY0731b7SqYB2e9wBDZwNDoILVVxmDRQb/g10ZtuZPzJCBdH9oJAHb5HjAVR14PNbf2Xa0JUskcxhzlkzbyHE8ywSDi0f7eZJZoPaHRGcb3up6AmCj5DKEboWlUJZt+kAumHZmkHqspybzVUxxrHUpbRrOQa6QnSbPXHP3mtVBtpnQEwgbFTt7SsjvJjN1K5mAoUXbpfp173HMQWSeFlQl2/PEK3tAGiXWK14kdDChcrFlKTcd79mpZpPjA433JlKzpRO46rNJppudZACxIwq9RKzhSHDkABVxSW6RtpT4XVw9ZFN29YK4
 E9LxaKKf
 3I8E5GeAWNqsq0wvWm5Y8PH10yzB1auCSholErER9Ai8KRhHSL6XQe1zbc3B7BrcgP8m+InwuFzIcDDdmJmSFlevK3omm5dg9Bxh3T1kCTy3GOtbc8/IiM5mBHXwlxIhQzBUPosaXLAcoQCaUEpgkjcR+2UA9q0HnklWPxvwSDlq/fIpkJmsj+6/yqX3G8xfYEGjuP0iORNAi2ce7P9mvASWXt5B2s094Liu6ebHBAdiB0Dv0Zwuquka0hVvODlf5ltNvOzjOnFQzn42KvR5IKi3tE2P0qXq8y853
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initially execmem completely removed direct map alias for the memory
allocated for the ROX cache in PMD_SIZE chunks. When that memory was
freed, its direct map was restored also in PMD_SIZE chunks to avoid
fragmentation of the direct map caused by vmalloc::vm_reset_perms().

This required execmem to implement the wrappers for set_direct_map APIs for
proper sequencing of removal and restoration of the direct map aliases.

Since then x86's CPA gained support for collapsing the direct map page
tables for ROX pages and execmem switched from removing ROX caches from the
direct map to making them ROX there, so execmem only needs to update direct
map alias permissions when freeing the ROX cache memory.

vmalloc already handles those updates for areas with VM_FLUSH_RESET_PERMS
set and vmalloc::vm_reset_perms() does not force split of the direct map
for PMD_SIZE chunks.

Set the area permissions with set_vm_flush_reset_perms() when populating
the execmem cache just before flipping the area to ROX.

This way freeing an allocated area on an error path won't incur two
updates of the direct map alias of that area and TLB flushing in
vm_reset_perms().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/execmem.c | 40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 74a178a87e758..ad07cae9ed585 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -113,28 +113,6 @@ static inline unsigned long mas_range_len(struct ma_state *mas)
 	return mas->last - mas->index + 1;
 }
 
-static int execmem_set_direct_map_valid(struct vm_struct *vm, bool valid)
-{
-	unsigned int nr = (1 << get_vm_area_page_order(vm));
-	unsigned int updated = 0;
-	int err = 0;
-
-	for (int i = 0; i < vm->nr_pages; i += nr) {
-		err = set_direct_map_valid_noflush(vm->pages[i], nr, valid);
-		if (err)
-			goto err_restore;
-		updated += nr;
-	}
-
-	return 0;
-
-err_restore:
-	for (int i = 0; i < updated; i += nr)
-		set_direct_map_valid_noflush(vm->pages[i], nr, !valid);
-
-	return err;
-}
-
 static int execmem_force_rw(void *ptr, size_t size)
 {
 	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
@@ -169,9 +147,6 @@ static void execmem_cache_clean(struct work_struct *work)
 
 		if (IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
-			struct vm_struct *vm = find_vm_area(area);
-
-			execmem_set_direct_map_valid(vm, true);
 			mas_store_gfp(&mas, NULL, GFP_KERNEL);
 			vfree(area);
 		}
@@ -301,6 +276,8 @@ static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t si
 	/* fill memory with instructions that will trap */
 	execmem_fill_trapping_insns(p, alloc_size);
 
+	set_vm_flush_reset_perms(p);
+
 	err = set_memory_rox((unsigned long)p, vm->nr_pages);
 	if (err)
 		goto err_free_mem;
@@ -312,18 +289,15 @@ static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t si
 	 */
 	mutex_lock(mutex);
 	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
-	if (err)
-		goto err_reset_direct_map;
-
-	p = execmem_cache_alloc_locked(range, size);
-
+	if (!err)
+		p = execmem_cache_alloc_locked(range, size);
 	mutex_unlock(mutex);
 
+	if (err)
+		goto err_free_mem;
+
 	return p;
 
-err_reset_direct_map:
-	mutex_unlock(mutex);
-	execmem_set_direct_map_valid(vm, true);
 err_free_mem:
 	vfree(p);
 	return NULL;

-- 
2.53.0


