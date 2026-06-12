Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0394CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCDE6B00A5; Fri, 12 Jun 2026 01:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E686B00A6; Fri, 12 Jun 2026 01:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7CA16B00A9; Fri, 12 Jun 2026 01:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C57766B00A5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:05:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5517CA04C3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:05:47 +0000 (UTC)
X-FDA: 84870073134.26.D2E898F
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 72E318000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:05:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LUlwgmAf;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781240745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvzRkhttZNjitpCo77djJBtuvCtyFBax/t/zfhSNDLo=;
	b=htNUCq5Zn2EJWgefodURGr2pGeDvc+kts8AgCx6jxJ52yiUEugORYOUzalTbIXIha0EKSi
	3WUCNbaUgnn6E+ZjkS0IxOKGIc6As7itmrZYi84IBmShKRiQBhiLzuyTZoeI0xE9UQCj0K
	H0PwaL/Q5O4kiQxLrPpLuP8YoW7QH5U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LUlwgmAf;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781240745;
	b=vhFxBiav/FNqlX7DzMbqf1Aj30cjkEtKtv3YsxXVx8RcXZluDA043e3LlL1VTyemi3OvsU
	QC2CPW9ocnGWd7+jTh4gfWvFllwTUeu/mxWVPE0UIggCZaredrMqflpFcwv8k0uWk5EMPR
	4OGykusO7DzMv9TQbi24VFY7HrLX0Ks=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45e9f4a3510so277301f8f.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781240744; x=1781845544; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvzRkhttZNjitpCo77djJBtuvCtyFBax/t/zfhSNDLo=;
        b=LUlwgmAfLGT31oVXOyBnS2XYppfmsek23HPXTcEq8Hwfduc6pJio3KoNtumYMFp8WG
         pUIq4CR742/Col61lDap2dCkIepIreVHO2sAzRdfY+ZofuXWbAiglNptFFytiW4TSd0x
         n9k8ze45rwyl8M21Hrsg1V6Ry5T0Htqz5A58AKgcVhxWhK/4KGuIJ99923E7q0KUZ41y
         Wy6ZJAzKbx1qwk9kDE9CKXMtF4egPDwq8s7L9KarbeBZTr9gFLJGIgChluIsbB1CgCgg
         JFL0rIDa2lUCXkggZP3tkT0w+kxAeapL9wtk0HsNOaIKntSvDSFduKvnmjq7BX1wKoqu
         YjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781240744; x=1781845544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DvzRkhttZNjitpCo77djJBtuvCtyFBax/t/zfhSNDLo=;
        b=eRNkU1WO2ps1P+J2Q6omaPSnJ1z/y1Etn4r6yQsGvZ7tk6HZhnvljtADltVjZeUBvo
         vCzhHG4gaQpzkHU/0K0p4+i9iM1lBMEgzFir3vAhYLF5dmliMfhn6cC6Of1YHxwtsoL3
         F+nBNSLUQSSrnwWsJ5Lu3JYqrdYEyfqcfN6WAsc+iP1b9RtTUqnJLm9cCpneEcryMg2K
         fLWscKzUnWBILfynO7xnIilGuYNz3VOw284c+VlOT4i7pq2HECotQOEOo8XgEwFsT9UA
         ceKTFwN0V13CVHUhUb8ffplFCFcETGuFKmL42g3dSsCOzvSBd+aac2DBBVoANXtI1IXU
         Zb8g==
X-Forwarded-Encrypted: i=1; AFNElJ+pRZrpxgLPaXqlEoA3aXc65t6kiUiFdyozCxPXga8gkd+3NFpuEG30NfDdJBZuapmQNPvCyamasA==@kvack.org
X-Gm-Message-State: AOJu0Yz4zBzMOfwJzBmjTt8KPyAVJA6zkPJjIF0jwYOJoCEbKrZcKhFQ
	GmaU2gjZc4g8pOzBxy2+9uN+SKz2rFeXyS0i0uFs+mh+uJEfYQYjJ3QH
X-Gm-Gg: Acq92OGHqJpiCVUMKHHq2CfT/PIpcnDfRUgUld1kpYn+X2PBwsoxefQmZewhzMKN7Mc
	DH5I5wij4XcNu9StXoG0TlNN3doZ/0drRlvBgeVnqMC5nOV8KRcU1E+EPKqX1ZFGoq/fZmSoBIK
	MgxT1Qusm4QrvMPVqIw7luzh7paAIwhIolj9AEDZfOhM2Vo8mL36yn4jNRsOMLWHhVn3oeFv7Py
	1DYHYqxg/oNL5S9Alakg3Tgg417IXj0S3OlNSee7LVMjoL6idO0P8bEkK3lg8HgqrRBsJGdp1Wr
	dMMrnAz6c9KowT+zGIgmej0xHH0mpMN0/MaLoj1Ev64m+fzdEO9Ti6rnq/CZD4yj1vHKAC3tV9R
	X8XEheVAklCXgLUg8nEtFLUnq4EtagFOkwzRrikqD2gR2RTLSXIRpZ9AppKOWRIoao2RSCtL89/
	bBDoQkDRAAith1mu6JOhrqWsQ7NyJlOkgOHv1/iojuiSOOHOndaaOmkQg8//uRpDOn8g53fcecz
	xewgABEN2s=
X-Received: by 2002:a05:6000:2002:b0:452:65d:e108 with SMTP id ffacd0b85a97d-4606da5beedmr1558160f8f.3.1781240743610;
        Thu, 11 Jun 2026 22:05:43 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2e6a8fsm2184809f8f.37.2026.06.11.22.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 22:05:43 -0700 (PDT)
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
	Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: pgtable: protect lockless kernel page table walks with RCU
Date: Fri, 12 Jun 2026 06:05:40 +0100
Message-ID: <20260612050540.31594-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aiuQf99mqhQRVzC8@casper.infradead.org>
References: <aiuQf99mqhQRVzC8@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72E318000B
X-Stat-Signature: mikpunrb3dt73srkhd4w91xpkahen16g
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781240745-906381
X-HE-Meta: U2FsdGVkX18845neDWV6TmTMjLudG2wCXdjI6USCO4D8CNndA6Nt+qYl5IUnCmR4RtJ0OtljVu3AvO0r9GQTHz26xl6LKa/ZiIJKsnnmjqajYLXxfu6LkY7C7oZNAVcj5Ywt4zbYDd3PyOoceU3hgp8aP6SbevvUeL4VWX4tAa8HmCrYHKwvDUl0s9BVH8H9uXD7qkzq7XeiFoL76OUmvABNM1JlYvbbucC+X0EItAWCbbH5QODZaLfm0tzvI6yxflXKBHMHQ+RBD/ubZFAJQ1TjuZ9WoGC5MkZzKyi2CEruLA+Qntpnkmr4nXgdSwEORNro3qtOMQ4/yuqalnV1clSNbhKp3Xayk7kekmHW7bE7d2tHCo87lSlYFenpY9xv0YjBs+htU9gYqK60+JsdRmaZYMe+EIYjoTZWb93UJO0cFFW5eX3+BvXwWb+0pwnWvTeG+iQPMH9VZ7a6cVxhQCDqp/k7VgOdUA9rwj3pE3Va22iY5zzg7iMoSHtSsV4+b0SzCiCDHlw9XG+QTBh7lPBhO0stRKOkiDnC9w3igSQteYxqfbJhQD2gxc2s+vnixSqZBUnXKqWQElHOmgbvEcIqVZICcvhpuf1zGy32QEfs3ZQ+8Emosob1/Rgd/NsB0bJ3TwQ/uEo6QvGFxdM2YFdcAzvXFY4mZdCBnJPdUvZ7CbYB0BhTcYQ/g2aQfCk7nLNMfvcn/gB5RBU9Ps1m2NVRHHYlaLp/LboPDkLU1F9T+zJ7bmMTlG05tfbyPZHdr+9aLnNROqVMSXwM0YyszYviPP9M3e3PsPmmfmIPe/c2DcGZP0RXOHghBLXd7a2PU7lPU+lYZDEh8L2FoyU+36+sGrE1ZpBWxgZKWo5p/8yMbYU0RNx8RkXQ9ucQyQYboqOv6jY/Uv8C5NkIIw6NW0YzxrlSMjJ2RNAJBRJJ9BLU63I/X6Hvs82xickXf7VGSMQnH2j2RCwYlZJCmG/
 grH4DZm7
 /f8fY+hiPJuWW6iWnsrVsHZv/7BUkScPnTOJ9kXD+H4wjBEcQRZeyD/AkmnIxYCtcLj46urZND08sQ7VELPDrhq1KIPn63Kar/w5fxHHvic4gyJqjntSCvOUmnLRoUfkuiriHV9/LqguhZdlQEoCP8YXhgugkPX6JIFUWhRf7g2Psyf0szbfZLLawjX4kWOsXB+Fb/l82syNSnSMJwP6fzDdRiZQ0Z8OMmngUgtx5Wws6ajTlGXZ977NcOY+BNb0iEK6G7NPZcDGiOTaHbs1WBF56XsNpUmffDNG/GyE9tIPE6fUnOKKBSJ0t9ZXVC5tYpS2SRKzQjM23dFjASMs8KD2lYoZ0F3nHHbFN2XohXwivGEFPT6BeBOhdQ/6RcmYHWH/tYuWWJq4TEfDihAodv2k2Ahef94wwNJL9z90Zc6X36XcKSoUHmBWWpzsMzndT9OoDz8hF//VtDvbD6l/famQK1up3I3+VBMWmCQuA1HK259l5GJYK/TCR7+9tCeCPPvyGnyrNh95thMOIlNOv1g3ggy3bJpeIbUsgtF1vjwWnQuRHJzg//YAf2lCcoCjw8A4p1HAcJe19yEl8D+/T5vKppjwqxG2bSkTAXf/rRHbc9YbEU6LWIbVD6vdQaB8+r5CIEX2lo/2uzg7kcwblMrpjNA==
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
across the lockless kernel walk and rcu-free the page tables in the
kernel page table free worker, after the batched TLB flush.  A walker
then either observes the cleared PMD and skips the page, or keeps it
alive until it drops the RCU read lock.

Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/pagewalk.c        | 15 ++++++++++++++-
 mm/pgtable-generic.c | 16 +++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

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
index b91b1a98029c..5b53e9a5b7f8 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -424,6 +424,13 @@ static struct {
 	.work = __WORK_INITIALIZER(kernel_pgtable_work.work, kernel_pgtable_work_func),
 };
 
+static void kernel_pgtable_free_rcu(struct rcu_head *head)
+{
+	struct ptdesc *pt = container_of(head, struct ptdesc, pt_rcu_head);
+
+	__pagetable_free(pt);
+}
+
 static void kernel_pgtable_work_func(struct work_struct *work)
 {
 	struct ptdesc *pt, *next;
@@ -434,8 +441,15 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 	spin_unlock(&kernel_pgtable_work.lock);
 
 	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
+
+	/*
+	 * Lockless kernel page table walkers (ptdump, and any other user of
+	 * walk_kernel_page_table_range_lockless()) dereference these pages
+	 * under rcu_read_lock(). Free them after a grace period so a walker
+	 * cannot still be reading a page we release.
+	 */
 	list_for_each_entry_safe(pt, next, &page_list, pt_list)
-		__pagetable_free(pt);
+		call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
 }
 
 void pagetable_free_kernel(struct ptdesc *pt)
-- 
2.53.0


