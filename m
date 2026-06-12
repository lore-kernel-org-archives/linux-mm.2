Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCCDCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2D26B0092; Fri, 12 Jun 2026 13:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3786B0095; Fri, 12 Jun 2026 13:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792A86B0096; Fri, 12 Jun 2026 13:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 657A36B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:24:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21EE6401BE
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:24:03 +0000 (UTC)
X-FDA: 84871933566.21.AEFA90E
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2DA4F100002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:24:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X+PyVo3d;
	spf=pass (imf05.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781285041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMGHII74ZTHreA8zFAF4aBq+kvKQYj6uXVGGtKbtko4=;
	b=F1YaJHedB9a02oryQqtNBt30VzcDWBpPn5pZ9uJoi73aBcgb8ymCUOm2VXcicT5SC4g65A
	M+0NRofBp2he4sNr4ontfKlhjPZbgLiBaIkCwkfE7fzwNWkkHR3ael9xyp4Wg/GWnPROCP
	zBDOtR1E8SJTjJK8jv14oLhcGYq5RFQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X+PyVo3d;
	spf=pass (imf05.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781285041;
	b=KX6M7XYciOqDiPmLrCMJttqiT/7nMylWrCF96pd3loLu1JzhbmHwkCOJWi525tFCPtHLi6
	riUaPfHk8dlhm7YQIVr5MIEaL/B1vm6P0Do9Vfk5pQ3xmJnfqUpsCjikKmOBMSnJC0/jwb
	1TtjoXAEzTjWvA7U+4hBl5rPdRwjRUo=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b4a8e28bso9741515e9.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781285039; x=1781889839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMGHII74ZTHreA8zFAF4aBq+kvKQYj6uXVGGtKbtko4=;
        b=X+PyVo3dn2IIsG+4JKAOwoYAWzfiEUy/43fw+DzxoW9W12PQL0YtC/QsxSLkjovI8v
         3CU8BK6xvmBCiMd2ar7GVyMWIUPGefaEjq2jFfi1CzpU2ONU9OqTGyKaGJZhKPGljUKu
         S1YGIVVMDo0p4kIIrOCQOkfCPHYy6zfXs4F1F/XwS1AdYLxA8g0I1DSUisBSqopa8+V9
         5LbzURZZEUIHbvV0GgHLJR1GGsgSub8MnaQ573i2BOV6QqKb1ygF6BUsjKaQjW0dKnQY
         TlZetQYCv3Fe09iLrxGWL4okeyEK+RqUZbk6EVxcM5ifRJT4pBCUpj5iLiUa67RyRr5J
         MYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781285039; x=1781889839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KMGHII74ZTHreA8zFAF4aBq+kvKQYj6uXVGGtKbtko4=;
        b=kHL85j3gItmD83SuBPDWpxSBX4i8YTDtUjsxrwUlsymCLlLUzhlMHiDYJnOTIIC1yT
         lGPccEh2CqB3RkoONOGRpSlZxEyxGvj6ms69fzo0UHWwRvbLFsT52lwlcGybRQb5pSF+
         WSX3vc/PdRRrg+21l95qAkhOE6NRCLX1s3zsO7SMC8/akDicXeyoKsMeLvU26HWPNogx
         MwQZaWLSsg0ZL1MyneyccwDAX1SKM/5ZjUXp0DyZaddl23v/GCQQ+TGp1apTSJps3Rj6
         FUJX8e+z0De0fSMmbHJd/41vAOgCxH0DztgT4lRuOXn7gjeOLe7v3enRY1JJHpzCP+sV
         9/og==
X-Forwarded-Encrypted: i=1; AFNElJ/cbJaPrAiYXbZVHxJmYub8eCH2cpeongDpwtoPU9mnU1jlssCARmJ6QeNRleBhIlitrOmPpqVt4w==@kvack.org
X-Gm-Message-State: AOJu0YwjjT2NOnAFylRE66xsGW/IzWTaMEGo96yFbmwKIlmpil212h63
	4Nbnfv/MzYef4fe2DDtZn97VR/zF8kQnAd32SQs5tMYBaYP31pWrcY9W
X-Gm-Gg: Acq92OFViwATOyq0VV14jFZHcM4jjlKirAcsJuz3tTko1Oy41bGfXU2FI5bZ6iPLiYK
	U1atv0y0jxQXz5CIWe8m2jkCEJejRoPkosp+260PtehmbFJ9dV9OzXZzPHcaPZ3wkodsSpP3/rn
	2OJVf9heGrUrzEu03hWa3Ws6gcTjT6Yy0OcwfXeVzcRTjhEqoFZh5KC3Kyhwh1gyb453u9RkQ4+
	UBZwROJCy/JS2YWVTG5R2S+TFSDMEf3WMhhv5aBIBNBL2V34i5YbeOU3x0NfSO1NBY9j5GJIv9c
	GKio4NAqDHrGQb6Yg8QieySv/bF/G3WywqInBT+nWSV3+aiNdwMAwfFmwdcbyQw/DQV2Ue5DfBN
	yBMI59wRT+eLILRzXrROB+FLilMG+Bz42RsZIvu1/WvZFm19jnGGoaKNO8FWXoV1j4smsiiLu5z
	VwGnmP2+MeAwunEhNG/noHcyEzQ9thxVth6zg19A1nGf0w/qxd+NRc9033n5xpBV5p4aDcXNj+C
	lhwPQ3euss=
X-Received: by 2002:a05:600d:15a:20b0:490:bbc4:76a6 with SMTP id 5b1f17b1804b1-490ec4fb51fmr38439775e9.21.1781285039252;
        Fri, 12 Jun 2026 10:23:59 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2ce361sm7009190f8f.31.2026.06.12.10.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 10:23:58 -0700 (PDT)
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
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm: pgtable: protect lockless kernel page table walks with RCU
Date: Fri, 12 Jun 2026 18:23:55 +0100
Message-ID: <20260612172356.356894-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
References: <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2DA4F100002
X-Stat-Signature: wxoffht4ihmu981cre4ii9anz3xwnrm4
X-Rspam-User: 
X-HE-Tag: 1781285040-866754
X-HE-Meta: U2FsdGVkX1/rySLzDr1Xen0IbYx+465oNAWqXGOPN7Aq64cJ6nU93fcPU/Bm8M2c3iXkYto1nJkfDI3LGgG03PWV7qiUg1/xsZJ0ld98gfWV8Lc35LT8PVfs8qOinLCKnibbHLe25Gbg5Dw6bfKBPsU9G7V8PVQn4LAep8ac5ow9PGu0Kqe+tkU6ID1SSXU6FQMykLZ6//b3FLP3RGZqxlsRUKV7XSu3QleDZKG4qOcZpSmNQMDWMLDgfb/iYR9C/0zxuG5foTVYzcvFCtbbOUskkIHijxe5N22cRxVK1ATg/G6xyc5EVwNdy515Lw0iX3gFcWBiiYVbHzCpxuiFQdANLZdSH1fFj+Oq7qPKNoLZaHdAYwKsdzjJUO7tl2NxltyS6gr/meShxs00yCw4OcyasjPzrMD3xoeQw7qzu+6bLq1KdGvrn73nxyZa7eN2jsA1ONQ+2Puk8ZaxbOHBG+V0rtDYrkhyNcYjm33R+UdPnb9H/RVwh6KqT9xut34sVmvB9dS0tvrhoxj080yaEH3kLb+dLWe1oC4hFlmUZ4WdvSv31+nyblAkFi2h0kBe2l3jYkjo27Qd2Tz5dNETMwV4S2/9j9N9aBI30vt/vWDkMLu+3P+XFhFtlAF1ooMsAeiX9z4n4GMIzIYZkQZiIvNqnLNWSM9CHK36ytfDLTkHgMlxql1cUZRkgQUKHKHWx3yPaP8/gmMJ2/6PZAsvvtd79cAT/B8jFgG/lK0czyoTK2DwVPvaGApRKzcPqLoMp2MB8rXwlWzZEF+czB2fk8I2gF7/10MX/aNDQ+ftrHh4PwyieaGU8AUjxXPyoYOm/2AJYxECd9KbnpnVDHCSfrRBjxJRCx4OU132KzjuCKzUjtwQdMNWSlhHwPDYVoFl6LGTIbALpFLN49uBe0gDjahCiadwjrbyQ6mVA+jmMXEAnzXOAiN7flP+bTsdSEsi4DJYVgvk58vVt6HEmKa
 X054p2Lt
 wiyATEtKPQSZOXmPCT1buirKnQBq6RO2nFf14AoqgZ4a6i+WB0qAPtL6LNDCAev4fTR6qHIImI73Zn8U2g9uzN8ZD6ELaXYRKBxYRFXRTHU0K+yHCFRspDnrImb2uSWpXegsQN7+OZA6JKc1XlqSnyyPWlhEh7xO23GNPjxmcwBU3caRqgyF2V5UzY7JXzW9DBGHMq+obGN4Yj0IRki66JHUdCM22d+FUewWkixE81AqvG+skvJhnztHVsduItGY9CfyhnjeJ+EC8ilECPB8LRk1IgK25+RsAx0/wI75FoMK/LEzydGUp576FQsGcp3y/8KB9hbG+nHBRsDjOtVzEEE8Zmu1V/ncHlVA9eL5ZJ39vtRjBF8X2tHMeoyOIY4Z3fX7EPRCfH++HimMpL2ROISezubbddd4dhK+WQh8b82B+NzmYlXAQyieTeAXmvNF8F7qdrrsyafaDt3MRumUkfpa4MnJdYDGfMiO0MNc9gwogHn8axAgAI60McqvfKnOsRcwwbCUrXZj4vhKDJirwTmS1abWeNshdDBKKVX89kNEf3eU5LxKdoxTn+HuCpgsRrsUw4WHj/BzevRjZ1ezi5O+kSuXQZOWDKC/b7ZSyB3/1yCxEA9sF3qrySKDCjngosmyb+pD+8hmu+d/nrQi/nFPs4g==
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
across the kernel walk in the init_mm branch of walk_page_range_debug()
and rcu-free the page tables in the kernel page table free worker, after
the batched TLB flush.  ptdump is the only walker that races with these
frees and its callbacks do not sleep, so the lockless walker itself stays
lockless for its other, exclusive-access callers (e.g. the arm64 page
table split paths, which allocate with GFP_PGTABLE_KERNEL and may sleep).
A walker then either observes the cleared PMD and skips the page, or
keeps it alive until it drops the RCU read lock.

Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: David Carlier <devnexen@gmail.com>
---
v3: take rcu_read_lock() only in the init_mm branch of
    walk_page_range_debug() instead of inside
    walk_kernel_page_table_range_lockless().  The lockless helper is also
    reached by the arm64 split paths, which allocate page tables with
    GFP_PGTABLE_KERNEL and can sleep, so it must stay lockless (Andrew,
    Sashiko).
v2: rcu-free the page tables with call_rcu() instead of synchronize_rcu()
    (Matthew Wilcox).
---
 mm/pagewalk.c        | 21 ++++++++++++++++++---
 mm/pgtable-generic.c | 16 +++++++++++++++-
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..dbb443c72353 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -692,9 +692,24 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 	};
 
 	/* For convenience, we allow traversal of kernel mappings. */
-	if (mm == &init_mm)
-		return walk_kernel_page_table_range(start, end, ops,
-						    pgd, private);
+	if (mm == &init_mm) {
+		int err;
+
+		/*
+		 * Kernel intermediate page tables can be freed concurrently by
+		 * vmalloc/ioremap teardown (e.g. pmd_free_pte_page()), which
+		 * routes the freed pages through pagetable_free_kernel(). That
+		 * path defers the free past an RCU grace period, so hold the RCU
+		 * read lock across the walk to prevent a page table from being
+		 * freed while we are still dereferencing it. ptdump is the only
+		 * caller here and its callbacks do not sleep, so this is safe.
+		 */
+		rcu_read_lock();
+		err = walk_kernel_page_table_range(start, end, ops, pgd, private);
+		rcu_read_unlock();
+		return err;
+	}
+
 	if (start >= end || !walk.mm)
 		return -EINVAL;
 	if (!check_ops_safe(ops))
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


