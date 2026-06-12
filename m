Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F53CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565BD6B00A3; Fri, 12 Jun 2026 00:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DDF6B00A5; Fri, 12 Jun 2026 00:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A7C6B00A6; Fri, 12 Jun 2026 00:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6C76B00A3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:38:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF6B91C3816
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:38:35 +0000 (UTC)
X-FDA: 84870004590.29.5410B90
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14531140004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:38:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TO6LA5x/";
	spf=pass (imf23.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781239114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+eyDzmzMv9cOLRXZ9xP5Hgn20feunlwWlNf7aiJTcsI=;
	b=vHvYlFcB/YpQFm+BT835fnkLIgsLi5xl47HGdfLekVROOwV+u/PqKrGdZxtXbDcLNG/+PP
	vHKmDtVKqWaWVgvP2jvLVdYRTDzihqBfvNGhEngRTY1ZFRfvQpTia0lCSICPbDsefYCg2T
	Wys9RsX/gFbBrrcEw1tJmTV5u4C31u0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781239114;
	b=Fav4uQtYr6e6/dPMGHM9phkbB+d6sIjspNi5lAeSCX5Jwxyrwnc7kX0BRzGHVEc5zwuAsA
	MI0tIM5ChR6yiEozsqSUlr5cxiL0a5RRUl2o7eQqUU0P+idB2dl59tWu4S9HYH/OWN6Csd
	L5/AfGnr/Yc6lfc8Ok0tAWHfS3T5y3o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TO6LA5x/";
	spf=pass (imf23.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so14949395e9.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781239112; x=1781843912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+eyDzmzMv9cOLRXZ9xP5Hgn20feunlwWlNf7aiJTcsI=;
        b=TO6LA5x/VFdE9YDM3bOZAIuhsP4CRkSuXSlNnjE23nENOuUkCeVchEGwp3bVcIoFDf
         5dRNjFE4sXtAR7TW4uPWIsMADP+SQdHpNXF4bOo5G1SrDYsnToHk+c+Ve3vumEwDPJzy
         I3h1VVUDXrQjS/dwWKkZpwwWXa+WK7SwsVH/h36JlACtOSgZ5c0HWVKI/cUS24bFLzrH
         ckgnh0JfSV4PG7sJBdLLyuHpQ7Y5kefHWzsdYpwCALNNTDb/B/lXXHCrcjEshRG+arv7
         RGxipf26WKOktGswEBd+Z8N4uN9CgJML30Ly5sj1WsTG6oV7uV3NMGDhismSRJRkew5Q
         e/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781239112; x=1781843912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+eyDzmzMv9cOLRXZ9xP5Hgn20feunlwWlNf7aiJTcsI=;
        b=okqhZgqle83aWGI2/o2gbUCjXDW+It+OcDsRPA653Bn9bxfDaowUcjfu1H1ywh3LPQ
         AgT+oDGGB9NLFpFQQmFl3358ISnBQRgKsNcYisBLc46D506uDaNTe4qCr5RcnJz/SyMc
         4O+Xvfvu42YWnWpTayGBv23XIMbZELBX/5EGnpVtPE5dPjgEEHdPjz4oLlC1AJJXb9aO
         doQvxNsFxdYoxpRhSxZOb7A8MmIR9GtGk8IixAydPIwmy2mtL4w0KGBuMjIfT1sAAOMk
         fezQoouxsmKyu4OdqnS9HIiWJ+xZEJKRxPqV8Rsic86lghNIRvlonMgBjxX3Ow5gorH/
         YVUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/cos4nDhPMidKhOQxwCGvYldjBPCnTcDlRfFJpks8Jhe9VBkHhxGeeDrhl7j9qBrCpQ7h8NozLsg==@kvack.org
X-Gm-Message-State: AOJu0Yz7RXrk51AQskbzgodN7UaulK6Hut3ossbFKrBm2Tm5CHN07qaw
	2CzxssThaxOovEDj1DKLepRRIw0iU5qJrWeBOSVr6nFrBlcSZTd16J9Y
X-Gm-Gg: Acq92OGV2t1F9MZ+yfYPDoNJKtune5J2nJ8j4YTjVdOjEDLBI4ridmjEwyuRiVKBfwQ
	CeF0sp8PF6iJ+csKGPmgDTpvAW7DM+9NkrskByrfEc+WnlP/IEgjyEKCzEmcLjsF/eNGzFTvZ20
	k7V6IEueZT9shjj+d1LMLPLTahAOe4T88lkkTFrqNIFp4B64YLkysJzH/6wIgtTtlxBGji7Nt96
	jqxTmONuXTHD9EpbbKhVVgYPJd9BD0kUEftk6yvp75HGp11NTtYKHijw3xuxI2WKcwtta21ORq8
	Y1Y9OVVkhNW4h0HCU7MPQRBIbvQ8XjBnSNMGwrTuuWdjaF/7bZlmPHkYOdpqSOkUWM2fYYg+Mpt
	Wn6B0p1KSiMRM5g5bTV1Q4LZZWCyVyWakIRUK8NdTuPnWIvU9SitkjKvogolBxAgT+Q1P1TTFyl
	HN8dUCD1g2g5LuoCZWhOuxqxh+CI75LTNf19doE6oxd24g6F7ZDc1MCHqS+yXeOYGJwaDtPHTVT
	dHDxiIaNac=
X-Received: by 2002:a05:6000:460f:b0:44f:69f4:39b5 with SMTP id ffacd0b85a97d-4606d137b1emr1501403f8f.29.1781239112192;
        Thu, 11 Jun 2026 21:38:32 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c4240sm2299857f8f.27.2026.06.11.21.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:38:31 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org
Cc: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: pgtable: protect lockless kernel page table walks with RCU
Date: Fri, 12 Jun 2026 05:38:27 +0100
Message-ID: <20260612043828.23558-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 14531140004
X-Rspam-User: 
X-Stat-Signature: ke6ua8oofbm3kjtp9j9y6uiq6m3is4qr
X-Rspamd-Server: rspam08
X-HE-Tag: 1781239113-910446
X-HE-Meta: U2FsdGVkX19qTDFFt3c2l9yL50Lno7TtKle9ziAThVhiHJpHbMvrEHIq2S/XbUXEVxM2R8xMmcZKUKGstZnMAv5VAUf2FbIoTAn114pC336vQuskGRy2iLAJvZyBF+i9sYZQ4uMenb7klUQi1aLwDlUnr4UOggaMxQQ5SrbJmB5+XHo87V3pjGXRXHQuL8IakZxgdHws8k9xk3h7OxpVwrHZRK/HNKHba2qWjzV2GP7E6yoW1nDGhVKjoy7BGQ6rCLpPmJJqOSp/TUW7qQ3AYvykN4KJRk52jStHDlhVz02LhezgUolUByPLDv/dh0r+tTSYVQKp8FWhzJonG+DXonnS6lBPnZj4k9ticIl0H1OcippJddB9Z4u4+3DyGfOwogzUM6l9I9Z6gQiioNQHlXhIxAcHreTBKFm0BjGKWhr7pd6ba8CY47GtbeZTQNFDOfNDx2shYdOxFh3U1F+LIt3ht1uh7aA90NEef9rWbwyujlrs2Cu5XxJKl0gbWc9jZNOQFmfqaCKjPEjZxZwSOEV4s8Iwljr3f8QE7LqI6JwfecWmkEBT8+DdluiMPQYKXXimPOfWl5t4T9HRh2p582w3QjCfER0R9ZwNHB2p4qJn4+KML5sefnm9SE4tQhX/ZM7v1y7XItpw3cCZS641wt0+I5dyCJMnxU5x7TMzTEWY9a/DSRJ4d4c1NV06Ez+tikRBYF55Z+hDrplQ5Qw4GysqBwxFjFk3t/8iEe3x10ghBUA8j9sGFwJHylYBZqnvkrh5D9N+YPJ9IqltdUN6Kjji8eo4chZ15PJ6tkCO1GL1Cs2IaRqFWrXhGWcMYLSkxvRpMahHZlXfIb6IYFos87Iutuym4WB/2I6UGydhjyybq1iP/Y1IV+S4SiNli/pDBkqDgKx3Z582F17DnF9U9yiiDIu+pcgLSMe0lp+x6mqn/FzJQ1yrMBzRwBfNRTFah6oDu+H0oApDIKmAtji
 OEtHPlpr
 WhroQ8a1sdnL+KlHuvjHWiNHg3YeoLZSmkgVHH1IcZ97QrDNM9TJaN138YxTR9iaWW6Y6Q/dOQdBMyYYu7hjxh8qDwB9XZHFgBKR1vAPUS1Eqqtjk4qigsY7h43w/D0FbLvvC6hgaNJ8ELkQQmaoFkwRCQ3quAiy2hzAAv9QX/pggIirZIv67dU/ILTaoiYMr4ExineLdlUk2MZ5SSzKHn/JTyBEiIhPm5k9NLzTlVeS965biAnyDlCarofaXw3pMgwPrgeRDLgIZKchTxydD3bRCSFbQG4QPf+7dnQfxZqByUwCxfwl7cPozVZYycVSBYiAlWTf0B5jlUT92Hi7bZuM2C8txop2xMs/K3gMSwXvQT3ChnZ/SDo12/6fHmZyo53fQANlMNM+kmMiDeENX8Ez3QSk287h91xSYTtJf3x65RwxPJJsNJ8NWf8KA4QTZKTfD9fLrYbkdJ6um9UMJD/EiXf+phE9HEh3vTmWx87oGlvzzEGRmWK1N7bm09u7rF9VwNnXX2KfB7EpKw68f/yDZNec+ELKLyFeAZDzmRd5aertockInUqtPX6MrqFHrdmwDA/IY3PcPig9UdqFic4x+aKIgizW99OTWWjhocKdiDPeeFy7UBaHPVyis+qlPYyozb0uW0yvA5IH/F9+BBPRO1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptdump walks the kernel page tables locklessly through
walk_kernel_page_table_range_lockless().  It only holds the init_mm
mmap lock and the memory hotplug lock, and neither excludes
vmalloc/ioremap teardown from freeing kernel PTE pages via
pmd_free_pte_page() -> pagetable_free_kernel().  syzbot hit a
use-after-free in ptdump_pte_entry() reading a PTE page that was freed
underneath the walk.

Deferring the kernel page table free only batches the TLB flush; it does
not wait for lockless walkers.  Mirror the user page table walk, where
pte_offset_map() already takes the RCU read lock: hold rcu_read_lock()
across the lockless kernel walk and wait for a grace period in the kernel
page table free worker before releasing the pages.  A walker then either
observes the cleared PMD and skips the page, or keeps it alive until it
drops the RCU read lock.

Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/pagewalk.c        | 15 ++++++++++++++-
 mm/pgtable-generic.c |  8 ++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..6d9f14f86784 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -655,13 +655,26 @@ int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end
 		.private	= private,
 		.no_vma		= true
 	};
+	int err;
 
 	if (start >= end)
 		return -EINVAL;
 	if (!check_ops_safe(ops))
 		return -EINVAL;
 
-	return walk_pgd_range(start, end, &walk);
+	/*
+	 * Kernel intermediate page tables can be freed concurrently by
+	 * vmalloc/ioremap teardown (e.g. pmd_free_pte_page()), which routes
+	 * the freed pages through pagetable_free_kernel(). That path defers
+	 * the free past an RCU grace period, so hold the RCU read lock across
+	 * the lockless walk to prevent a page table from being freed while we
+	 * are still dereferencing it.
+	 */
+	rcu_read_lock();
+	err = walk_pgd_range(start, end, &walk);
+	rcu_read_unlock();
+
+	return err;
 }
 
 /**
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..59e1315185b4 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -434,6 +434,14 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 	spin_unlock(&kernel_pgtable_work.lock);
 
 	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
+
+	/*
+	 * Lockless kernel page table walkers (ptdump, and any other user of
+	 * walk_kernel_page_table_range_lockless()) dereference these pages
+	 * under rcu_read_lock(). Wait for a grace period so no walker can
+	 * still be reading a page we are about to free.
+	 */
+	synchronize_rcu();
 	list_for_each_entry_safe(pt, next, &page_list, pt_list)
 		__pagetable_free(pt);
 }
-- 
2.53.0


