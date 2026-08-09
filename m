Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1693DC5AD2C
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 04:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FED66B010A; Sun,  9 Aug 2026 00:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0146B010B; Sun,  9 Aug 2026 00:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4775C6B010C; Sun,  9 Aug 2026 00:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9F626B010A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:32:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EF0D1C100F
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:32:55 +0000 (UTC)
X-FDA: 85080460710.09.664EE83
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf23.hostedemail.com (Postfix) with ESMTP id 786FB140011
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:32:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M8QHrCsa;
	spf=pass (imf23.hostedemail.com: domain of 39AJ4agsKCDUjfliRmgReURXffXcV.TfdcZelo-ddbmRTb.fiX@flex--souravpanda.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=39AJ4agsKCDUjfliRmgReURXffXcV.TfdcZelo-ddbmRTb.fiX@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786249973;
	b=tXSzkfGjuKUN5U7+Fd3ksS4eo9T9CbrtbJAUN3lpeongRsNojjkgESPON/gn7fXl6eokCC
	p1XamzU1QpAJEM6gEPdarOz2M221naTka6BGLI9Igncg0U0kQbtahoNQ++U07r6Y5CJ9zl
	9Ndknq49mjtmukxKvoGL03jkN07IiH0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M8QHrCsa;
	spf=pass (imf23.hostedemail.com: domain of 39AJ4agsKCDUjfliRmgReURXffXcV.TfdcZelo-ddbmRTb.fiX@flex--souravpanda.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=39AJ4agsKCDUjfliRmgReURXffXcV.TfdcZelo-ddbmRTb.fiX@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786249973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SFcfVMlaONyojBIsJ/DA4x9Y5kX85WT5BYOtPk8UXQs=;
	b=AQLBJFqK6cDo7QGy7PoJ6KeKN/kTWXjZkHRm4hIud2SmYUAshj5rA0dTZG5B9kubN9f6V2
	oMMYG54Kv07Kvbm84GLdL1zyeFAS10kytJOs1y1h9ol5L0rzN5EUxj9vVvjbZP/FKUqDPP
	276Y+8E7pckC5vzC6eh+CW47yXby1mk=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so1495455a91.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 21:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786249972; x=1786854772; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SFcfVMlaONyojBIsJ/DA4x9Y5kX85WT5BYOtPk8UXQs=;
        b=M8QHrCsaBb/2Z+U+D1V0uEo+NVxsUVNpuy79VcynEO/siI3vcCD3ptrF3XsZ6plDpv
         QdGUIQhf9WtDIz3quithyJ3COW4IlntIqniIolkneL+RovJxeq258NwHKjyY9+sm3ODO
         gyIChGSdxiNRISPUZ11Pli+A/5IxiRqWscIDaSeErS08JD36vKtf2HntPcY7KYXxxJAj
         zHjLpLwFWXj/aC5wAUV8d6ywsqa86LEfAQFw+llxF3MobZnK5K3tRJD/JvmZ3z/5+rcK
         /z4Q28VxypyMR5B0m0YV4YeojpgF1NgnkWls/7WpHOf9I7YF8aak/TR5Th4TlJnc7YhX
         L7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786249972; x=1786854772;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SFcfVMlaONyojBIsJ/DA4x9Y5kX85WT5BYOtPk8UXQs=;
        b=ONB8uhawx7Hw3XRdrLoDerjCCvmuaQ6Y0Ag2dHVUtc9Wu+qR28M+HeFxbYQL2+88Hh
         v39LktW4Q+PdYhuvbPtLbQXI5e4l+vA8YJ9lgTMUlPBYWfRuFTKeWNW5LzLTJWo8idnM
         qeHHOgeVKk60uV1fUoJKNIUJsVCZFsDbSHbTAmz62IlpXVyuFjUb6YNnsHKduDK3NQAa
         kQ45ydFez/qoDObtKxut/KVa+Ud6AlbrkHc6i41HWezhGOvM+deMUc1B4WLpy8cXROud
         f2L8ugxNPRV+e4NpYjCmfaYHihp9yQRc/ROhYJM5avtrUzY3VkcTa6om/rRiwMw4Ms4g
         9h8g==
X-Forwarded-Encrypted: i=1; AHgh+RqbLyoY5FYKL6vtFq4RQJj6HnMz/frs/xgJAo2xNTcOjfICCl2ZzqGBQfTlrmvVdWehZMd8tE8SXA==@kvack.org
X-Gm-Message-State: AOJu0YzfvnfWGDScerqvDHD+gGreoPBz+pteD39z/oCNi0ojcC2q3mVf
	Zfj7yOvpjkvjxGPcU/h6XevK8+/Eu4/bMG+HAmh0Q79gkdqbjHXDM8Prj6z53I0DZ4FaCqeFTCL
	KL1uEZ0xpoCXl8dstsU6sb79vHw==
X-Received: from pjwo24.prod.google.com ([2002:a17:90a:d258:b0:384:f6e1:ff87])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2249:b0:36b:bec8:94c5 with SMTP id 98e67ed59e1d1-3928242ffc4mr9674877a91.10.1786249972002;
 Sat, 08 Aug 2026 21:32:52 -0700 (PDT)
Date: Sun,  9 Aug 2026 04:32:50 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260809043250.2917406-1-souravpanda@google.com>
Subject: [PATCH v5] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: usama.arif@linux.dev, shakeel.butt@linux.dev, wangkefeng.wang@huawei.com, 
	anshuman.khandual@arm.com, david@kernel.org, surenb@google.com, 
	fvdl@google.com, gthelen@google.com, hannes@cmpxchg.org, riel@surriel.com, 
	sj@kernel.org, vbabka@suse.cz, mhocko@suse.com, bjackman@google.com, 
	zi.yan@sent.com, souravpanda@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 786FB140011
X-Stat-Signature: rg3j6u717j6g9afjx7rqc3wsweirpjif
X-Rspam-User: 
X-HE-Tag: 1786249973-981728
X-HE-Meta: U2FsdGVkX1/wNtnmCmB3bvUTdvBWB3o1DRccqgWL590glzgy2VTFDNS7OKnWYklkM3Vd7OC3waP0yz8TWc53eXUet8qCY+ihex1qjfQOf5Q+IZtVuyz0/GmiuEJbK1uYznyv6QtnDki3s4xqxNgrTp7BvFErcJcPrVXgiFjSG0Eep92fY2vA0qnIr9NvLyO1+PD4G9sL1+S8vXk2MHgOHcMAeozZWnT0nXEDa1izbvzAzAxs7NQxoUchQsnPBUupPc3s1GdaTB6jGSU28RTK6PjNf9SBboO+q5x5biSuMAdoqbg/5FCv3CfyvYhhzrfU+sALBCTPpDYokbwyddMdLm2ADG422Sno69c8NILb55mUvnJ9lFyBePwzaU4gPlA9Gtc+MWpGQbTaLiJHoYL6iI/lfud4uVMrWaSyZ/204eFtF2BxQBAM+UweKBajEghJyHs9npV9/4qkme6Vt+x9ycMrUPznsIo6i/hvGqlzrHwCkDK8N1CSPYoXK3s9soTRdw6xboa7hMfMeLz1pLoME/OrBa+8tnmpRoAz8tx/+wqUvHvNBVcUe63w7FFLDZ2TvHBU91a2QTh7j4fgY/dduAfsaglY84zowuND92YXuOdQujuf0RuIJt2nCBddzZ7oGke69aAYswnkfcQ689PV+LK+Uz1k81hK8hENjrbpXL6O0U3MKGwBK/91roDYA+kmNHpaE4IJ6IQejAFI/JPCOCOouqhwjwRgFuKYehj3m7M06UwCwpsBnxndvRdUQ79KC0xOiXaxSasganoY8Jm9LgVshL7E9skh+c/njzkQNrPii6NjQZLY6x3rDD0d9uu6clpkKs1jeut5/B1Bk08EM+gdOt+/zgt0h1+hDXbniL+VUo81Pt2KRMYV2WidrJTuaDPm27bonutltufj/yELCkFYe13x77+Eo25KMqQh+cTLc0nvVS3R0FjJN2Ax9LlBcBwL8tM8mWPpD22jUJc
 5C0ADn2k
 kGzGM7ctdQEPI8A2sYekk8PhfBbN6B6wzqBf/0jSxKpLrNCqSe3mrBrMFE7BIkZuymSLdG3AGdVEA4T54bnBQ4fIrEYI/Uak6LvTPMIVVtXletbBRMqaeiipEtLYkhHrjVxphpCw53UOkK1ZGkgEV+GX8FoPfJGBlOOhaywi17cXAFN1vaZat0+raf6ursZpPsjdNOaPdYu6Rq4vSg9EBizMG1r5r5iD2QAQZgrgIAVdCT/91509LoJTLDXJ0PzmAHi43P3mHq/m/Os4HFZYO0YqYnbg3bdnA8JY1EXrPELfNtMkQjOLkqvfv+520a3uQj9fKdhtj7/1+w+PRzw8PauW2HMY5BunikyFpfAjB28ob0FuKUWMRnqt9naXVMoe3nmucdJ2RXV10oMmv5yHzrG9CSEMwEE/WS2ut4/QpMAvngE5u51HgC7Bm17KGt2+2Yb4leoiAPr5fy9zh1oMr48RXwdm7XML5bb5pa8pRlX/uKQC9IS2uJht6OFuz5P1Mz86S/qwGUp/uomCX04Cmrl+5pm/kL326YfDONIeAO9K0VDy1A/649eYYn2AApKIDcswMHnddW3KptQBormboVQFobBQXWyx0kIpWWU9kXBsUpmVKoFLcstpQgdTe4ZPpV1gJlGxBUFYq2c+xv8diB9h7DdS8Ibu12Kq6dl2fBJAAIEE1H4GgsYijtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
alloc_fresh_hugetlb_folio() as a fallback to allocate from all
nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
alloc_gigantic_frozen_folio().

Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
allocation on hugetlb_cma[nid] without verifying if nid is included in
the caller's nodemask. Adding a node_isset(nid, *nodemask) check ensures
the initial preferred node allocation honors the memory policy / nodemask.

However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
leading to a null pointer dereference kernel panic when nodemask is NULL.

Fix this by checking if nodemask is NULL in
hugetlb_cma_alloc_frozen_folio() and defaulting it to
cpuset_current_mems_allowed (safely read using a seqcount retry loop).
This ensures that the initial node check and fallback loop safely honor
the task's cpuset without violating cpuset constraints or causing NULL
pointer dereferences.

From a userspace perspective, this bug allows an unprivileged user to
crash the kernel (trigger a panic) by requesting a gigantic hugepage
allocation with MPOL_PREFERRED_MANY on a system where CMA is only
configured on a subset of NUMA nodes.

This can be reproduced by booting a VM with two NUMA nodes, restricting
CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G
hugepagesz=1G hugepages=0), and running a program that allocates a
1GB hugepage area without reserving, restricts allocation to Node 0
using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:

  void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
  unsigned long nodemask = 1; /* Node 0 */
  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
        sizeof(nodemask) * 8, 0);
  memset(ptr, 0, 1UL << 30); /* Trigger fault */

This results in a NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP NOPTI
  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
  Call Trace:
   <TASK>
   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
   alloc_surplus_hugetlb_folio+0x6d/0x100
   alloc_hugetlb_folio+0x3c5/0x660
   hugetlb_no_page+0x3d9/0x650

Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Cc: stable@vger.kernel.org
Signed-off-by: Sourav Panda <souravpanda@google.com>
---
Changes in v5:
- Replaced defaulting nodemask to &node_states[N_MEMORY] with safely reading
  cpuset_current_mems_allowed using a seqcount retry loop, ensuring fallback
  allocations comply with task hardwall cpusets as suggested by Usama Arif.
- v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@google.com/
- v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
- v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
- v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/

 mm/hugetlb_cma.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 39344d6c78d8..3ae9347078e9 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,11 +31,23 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	nodemask_t local_node_mask;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+	if (!nodemask) {
+		unsigned int cpuset_mems_cookie;
+
+		do {
+			cpuset_mems_cookie = read_mems_allowed_begin();
+			local_node_mask = cpuset_current_mems_allowed;
+		} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+		nodemask = &local_node_mask;
+	}
+
+	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
-- 
2.55.0

