Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FC6C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD546B008C; Tue, 11 Aug 2026 01:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E706B0092; Tue, 11 Aug 2026 01:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45CEE6B0093; Tue, 11 Aug 2026 01:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4B16B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:29:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83731A0379
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:29:13 +0000 (UTC)
X-FDA: 85087860186.13.ACAAC67
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id D8DEA120004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:29:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="MAyV6nj/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3JrN6agsKCNEFBHExICxA0x3BB381.zB985AHK-997Ixz7.BE3@flex--souravpanda.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3JrN6agsKCNEFBHExICxA0x3BB381.zB985AHK-997Ixz7.BE3@flex--souravpanda.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786426151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MNQl2P6LXAgXNrrea3Lx9Pop4FTZLY7ulqZAcPycpvg=;
	b=V94CUYF8tap4ZsjPJx6gv6JbH6s1mo7OT7w2Sgoml48KundH03WYs8OFYxD77T7xpeKJHw
	XjKVfoAVH2NrjbOdE+KC5jjaPV6Zm3PRcEQvL83n5ofsDhUAECzJJVqpyltkoJap9v/CkL
	UxBvKDHOt5O6QsP3bYyXZKy5p2jIecs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="MAyV6nj/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3JrN6agsKCNEFBHExICxA0x3BB381.zB985AHK-997Ixz7.BE3@flex--souravpanda.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3JrN6agsKCNEFBHExICxA0x3BB381.zB985AHK-997Ixz7.BE3@flex--souravpanda.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786426151;
	b=ZshJtrpd8/GqVHZb42xl43BdM78aj5CZTkhk7r69M0BRzV0TD+mCHO68DoUk+f8DZkhC47
	SQBSkf2q6kLln5tT84wVfEzdE+s4WCfSn8ak1mxJuB/8863yI/VN8t1aeOtq/+xovhwSWl
	I5MieWkY92OjoA2JdahuLVGrqgPnTvQ=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f5ac7354dso5116497a91.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786426151; x=1787030951; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MNQl2P6LXAgXNrrea3Lx9Pop4FTZLY7ulqZAcPycpvg=;
        b=MAyV6nj/XFwMrKeikd1m4GSYnxV1JbzDSy2xby1unnz4+uHsjz8yJuehMvYGGMNJxQ
         3MB347JcBTPnecxzGuWVb1lXZvlToxZZLKlYmTC0mihv/dn6uCw1DDAsJWHWOiTy4Hwd
         HuCn2ftlT3a0y8YkmRE2T7UoKUow9Fob4JuPY1Ss7D6D82phTPzGItUovW64Pk52xcdG
         oK6l6niZoqwXvpsYoitOSBpaTknDLxlVnI/crmT82UMfvL+S757BEnQTX2YgrPscydgu
         XbNTYhL9ToUIt7ZCtY3BhJl3vfMMGiErZEobei5EFPXigR0TvDG2GudiQ7d3sK++353g
         Ug9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786426151; x=1787030951;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MNQl2P6LXAgXNrrea3Lx9Pop4FTZLY7ulqZAcPycpvg=;
        b=of0k7QWu8I6CA5PY8OLh0p8bSPteS9L4+Ju9WVIoJE2AeKgyNYSu5N0oYi70li0rE/
         cyqeIawsL+hlghtKgPjA2wTRG9uMajnu1FVXqPQyjqwh+Ug1vc8EnoKxrvBOWT3ftFSd
         bnbsIYT+DuhQQyC+qpeXrcWaaQWtEfeJHQM5HkUKft0mkuOUxawqmihpDErlI7H921cX
         nhuswVRtl0M03kkFnX3dVDlSoQgYEuVcluHz+YuJf+a7HwafBj/45EgoSdlgFR7fqd2r
         2+PzdcsJhuGRfMeQgQGwpmnP2gmsUhVdZVwSH0cD9g7ZNdl1m3AAmxlkDrKen+FBst9v
         GHPw==
X-Forwarded-Encrypted: i=1; AHgh+Ro+NfBl1D9qHhx6qSU59W9JQs/Y+OXeYZzYF49SjPnATe3Bb+BJ+SQdkAmfRscraZzwJENK6M/Ktw==@kvack.org
X-Gm-Message-State: AOJu0YxQvhLf2P+IWHnUB/cgV6Bo6AKqRfH8NfseyC02EYoSOtI9bTLZ
	9ymtDPkzbB0UJpRp9fBu/qtdc1QQ77WwJ7h7IEJMEW0+Ew6Kh2qBZZKKjOuXQJ6BIjQVVNwN8wR
	gyM3W33s2iVY2Py9GlFPVml6jFA==
X-Received: from pjva15.prod.google.com ([2002:a17:90a:d80f:b0:38f:19c9:2dad])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b03:b0:381:11eb:d78e with SMTP id 98e67ed59e1d1-392ec5dc6d9mr755643a91.14.1786426150282;
 Mon, 10 Aug 2026 22:29:10 -0700 (PDT)
Date: Tue, 11 Aug 2026 05:29:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260811052909.475635-1-souravpanda@google.com>
Subject: [PATCH v7] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: usama.arif@linux.dev, shakeel.butt@linux.dev, wangkefeng.wang@huawei.com, 
	anshuman.khandual@arm.com, david@kernel.org, surenb@google.com, 
	fvdl@google.com, gthelen@google.com, hannes@cmpxchg.org, riel@surriel.com, 
	sj@kernel.org, vbabka@suse.cz, mhocko@suse.com, bjackman@google.com, 
	zi.yan@sent.com, souravpanda@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8DEA120004
X-Stat-Signature: 7hz9emrdhgzbpiatdmzip8oh56jgnq9z
X-Rspam-User: 
X-HE-Tag: 1786426151-927804
X-HE-Meta: U2FsdGVkX1+I4YoaNbqiW93Bcm9emLD6A5EXSneMNimb9JHXE8kjFBPK/w4z1+vEBz503+kR3mV8gjr7yPu0nVFqT8GJ4egUlGEpvQm9Gjuem1AGJIAJ1989ZvOu+7bWKTh2xJIhy1CZnwqEdJ3gF05B+lcWbRJ4+Xc+mREnIuronk0j0ISjWykyQDfHH7AfkQfgRGL4f1XIWsxcjXo6zQ9uaXTX4nUVUDduh6Ps/lYB7YoFGWtmzP226l8p4o8JLX60A+9GC21uxR8cctuBcO6+7nf6QNpyM3aVj/MA7FPLhJI7jbv1XkPqWlHr/YMLYdSl9qS2ZWMR3tPrEM6D9qk/cpvCI9/WetSzFUG/HELi5AEKerKKhmLCn/Awes8Mb3Hz1lEzQlVTIH/OK3z3bcO5+4WYSrW6tTXFbOISLkHGDM/YyC1yrR67Cmawbc6Kd/d6lMb9z/aSVv2DUorBaWMRpjFxIApnWpQloAgNn2x4JCX8rTOqGqQCJoFGMQszaMGt3vZYLPiBTYJSUbmZZLN+tk5sElRSKYmupC7P82WEZLyvTgyAGH+hqhpuq0cJPEOlMMxHlPibPjmKjjJh9KyoIfgrgsg9MfjDgQETRVTgLN/TEMNO6qJkgmo04CH8eYulftDYDNAjf4oXQpQwLv4PgdzvsA5j9LkoPme8xXx8+2il4eiuVjz7y50/d5AGHkJsJhmj0jfunqQBmoBTxjqb/rsAIKxPn0Ja+0jQ8+7ksv/LYKY5/VPxzwRo2kiDfRCusU8K3YDN2HX+7ll4IKKRhglFcXAxnQXthh5kExllSDnUTm8tTYncQSI2R2VmTpXXEW2TZiKNGEINQgehpkVKPwAcGKl9bVQwrDhojPMnXfDJ5/NzNL4QWoXDCWxhGiNq8hzIVn0uqTpasrMm0nP50nJISzS657MrGHVliSlWw7AhqMbpNU/yXME+sn7KpCJnGYKcgJDpHVgjEqZ
 UsMWekag
 ZJTGDxHnJRmM69QoumujvdCV/Sb+HAIq1gq/gFqwNosqzktVmod8zcODYdprJPqKe0KBN9xKGNqLS1GqVgMleKKZHAS6weoli3Nx7j/P/bYgsKtenx9Op7K1QgP1iBIn8WDPncHHp11JZhytZJ++fEOU8lls4p5Q6qPvz/+5lVwdwksMuTEHDbMtP9Pd29/y1oyUncNQJlqLm30cEUQCYDu9udWuqgtZPAyEqZ7VhZhkAPNlYR12BcPXSXNwHVTvs+RsUztsCk1QS7xg8JyTRQGElcnhkdSKhKwrqW9BVDA+HXOcSAsda9T8eK1xED/bZgnF1b/MWvXFZba6TEEosbGLGq4hg4+iKK6xYv0hnPWW3b8pfUgRn1/atqTTtckprXlPrcgRjTP5C18Y2JMiIltLOqcDUhpIQbiVj3tynh6rJbADymqQw0SE/Is7Xm8i8Yd5CKWL+nyYpYmun6ChXyyVLuUPsgimsA1CmC7E+H/S8xcAvlJMVKbcsjvXFNYKmvqvgSENQDc7ODdlPZAwVCcQkT5dc0xMK2HniFkFaAZPWwzKX0gZ/UjTkJCjGjXmdtMXlR+kPUG1CPWuI1ETeU9PdHQ+S8wc+53Hpx6V5c0qov9/vfXg5WlEGDRLk9SNIofrHdsbtxRk1uVnWW9CzhNjzYXsPvQaeF9ZEvp3QnOKCed38183oKGOGiw==
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
cpuset_current_mems_allowed. Enclose the allocation attempts within
the cpuset seqcount retry loop so that if the cpuset changes concurrently
during allocation, the attempts are retried using the updated nodemask.
This ensures that the initial node check and fallback loop safely honor
the task's cpuset without violating cpuset constraints or causing NULL
pointer dereferences or unexpected allocation failures.

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
Changes in v7:
- Removed local_node_mask stack variable as suggested by Muchun Song, setting
  nmask = &cpuset_current_mems_allowed directly to conserve stack space.
- v6: https://lore.kernel.org/linux-mm/20260810230844.3778931-1-souravpanda@google.com/
- v5: https://lore.kernel.org/linux-mm/20260809043250.2917406-1-souravpanda@google.com/
- v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@google.com/
- v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
- v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
- v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/

 mm/hugetlb_cma.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 39344d6c78d8..3e22161686d2 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,15 +31,25 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	const nodemask_t *nmask;
+	unsigned int cpuset_mems_cookie;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+retry_cpuset:
+	if (!nodemask) {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		nmask = &cpuset_current_mems_allowed;
+	} else {
+		nmask = nodemask;
+	}
+
+	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
-		for_each_node_mask(node, *nodemask) {
+		for_each_node_mask(node, *nmask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
@@ -48,8 +59,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 		}
 	}
 
-	if (!page)
+	if (!page) {
+		if (!nodemask &&
+		    unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+			goto retry_cpuset;
 		return NULL;
+	}
 
 	folio = page_folio(page);
 	folio_set_hugetlb_cma(folio);
-- 
2.55.0

