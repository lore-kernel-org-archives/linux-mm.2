Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E3DC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 17:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A606B009E; Sun,  5 Jul 2026 13:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B086B00A0; Sun,  5 Jul 2026 13:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1219C6B00A1; Sun,  5 Jul 2026 13:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D85486B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 13:51:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A6E1167989
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:51:23 +0000 (UTC)
X-FDA: 84955464846.18.A1C4368
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id BDB4920002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:51:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KDAWwGaJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3mJlKagsKCE895B8rC6r4urx55x2v.t532z4BE-331Crt1.58x@flex--souravpanda.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3mJlKagsKCE895B8rC6r4urx55x2v.t532z4BE-331Crt1.58x@flex--souravpanda.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783273881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hU/ax1hlB16SHvksohVR+E9FqY3jSZbakNJJzt+UJ7s=;
	b=rw14kPzdtL2FhAkK1nJsKg+m6tZ3wzBgOHIArtLGbRbsYc1qNTKpGhIT+NGjtBQzBJdojf
	CjKDigv2n1oQDsALN/fx99VCB1EK/lSnw5Ylk1c4CkwMdOjGcOTQdFePCsZ4EHRjrXAnNM
	aQdkmHnLU5I4eN8kkAg02UzaMnEMH4s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KDAWwGaJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3mJlKagsKCE895B8rC6r4urx55x2v.t532z4BE-331Crt1.58x@flex--souravpanda.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3mJlKagsKCE895B8rC6r4urx55x2v.t532z4BE-331Crt1.58x@flex--souravpanda.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783273881;
	b=tNvHYyg7lSGAMVbPgwyW2EoR6mkrDdJfL3c6SEVNo1JGb+mOjK6Ynz0FK9ukz2gwvNVseH
	miViMPBkaA1BPckLxWWhB1Hu0Y8HNbil/Qj7vUzrK40BS+B/DI8q9nyaeUjasHd5kuWb7f
	R1xMUwxNaIGLoyL49o4+fNq79sfopG8=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2cac01e89e3so26864595ad.0
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 10:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783273881; x=1783878681; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hU/ax1hlB16SHvksohVR+E9FqY3jSZbakNJJzt+UJ7s=;
        b=KDAWwGaJ5QCubgHaGkY3M7ciGgppwlU/9y1SxPuNV1L2c7wrDJFAUCCHa6ia8QC8LW
         Dg535yl6pJ1UEyVpWTBwFmAvGZjWjBK5CUZlFZbA7ahR8HCSj3fA8aqrhusmTVWtSwmj
         +bunZWQ8k82Bbby1F93US53esKAW8Y8cOIUvpx+XdvNyH9JVt+TF8E+NdwQTW/dPgraS
         VI30dJh5l6WuF+Xa6/3rwbGOe27RksH+Sb0M4cAJYmuJ59Y4lDNos0NPjKkfQSp0DL2S
         jUnB2ykqeXAQWUG3OIeSfMwQ6pVUE4zUlVQoDPcFj+H2LZ1qpYDncoAihfPMnXu5lMas
         bjgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783273881; x=1783878681;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hU/ax1hlB16SHvksohVR+E9FqY3jSZbakNJJzt+UJ7s=;
        b=jDTZvQINf32nZ1Q5Pvh8AXbBtVdlkh5+D6d2gfgsidWuX8bmYDAHl66TOHGqitx8g+
         kcA/F2gJ9fV+4rFdzhMt4rEfoVs3gWdrw4tIR1FXbQ1ghBYLDmOez+oXmvuqeV3hU2/l
         xq8u1N0hOmH6oaGlAa1hFXSg//YatQ3N6Uaob9xLywbvsvggy8QwapsIRJn2xkaH3z7c
         t6hmbbw7QiNCElo0oQ7pWnQ2HhNZPc5PaYtUtm7StCD9EYOwNL4j0nQ/2tyr5aGOUVxQ
         3lUgpi9izb9NxHtGKuJenrG+EQLBlLRnAU8OQGPP+ni3Rovc3E45cT+3lmK374IoIznB
         dxpQ==
X-Forwarded-Encrypted: i=1; AHgh+RoiPuZR37/bEaKdXI5S6My54+MQYErkszWymwcd0lYIxh0+FDPjy4B43fTHrY2J95VMO1esOb8Ocg==@kvack.org
X-Gm-Message-State: AOJu0YxGxJOV1udlRDYGym+q63w9YzBSHRu8AnR+KygG17B/0SmTYFKt
	9tJvmDHFOT552kagpmj86ArPHdxrAjNeNp6Vv7PJyftQPgBTnyJSFLL0Ec6yUKQyR9ervUyv84O
	QGd4JGF/S6dFh60Fr5mHjgThdTg==
X-Received: from plrf4.prod.google.com ([2002:a17:902:ab84:b0:2c7:f2de:fc0c])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1746:b0:2c9:ece2:822b with SMTP id d9443c01a7336-2cbea1a2b16mr46713705ad.3.1783273880227;
 Sun, 05 Jul 2026 10:51:20 -0700 (PDT)
Date: Sun,  5 Jul 2026 17:51:19 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260705175119.440599-1-souravpanda@google.com>
Subject: [PATCH v3] mm/hugetlb: Fix null nodemask in alloc_fresh_hugetlb_folio
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BDB4920002
X-Stat-Signature: d8opnft9ki3f9ot11piomoonrqc718a7
X-Rspam-User: 
X-HE-Tag: 1783273881-871445
X-HE-Meta: U2FsdGVkX18gTrB2FxAJIBGOMCXRBJIo/jTtv38SU+p+pTpKD0CegOmuHSFN/dfyxDmP/Kq5zDt1tLZBAMTzTNu+24Ezl2X0HEiwPquoWS8F+Y7NfOoHaHgzd16QDOMa+cs1w5nzxSnz5kMaU9mlJ//BLSRkE5xHFKxP3Hhl4fi2aNbuFzoutldIbZx927xVlLOfOGtfs5Skr5JyzwIT8knV1CaJBHhl6CpbvvUINEW0BGE9Getns/xRJH59FpZ7OyoKi3BlkmNOUWD5nFppuWBtPim4S+YlhAa+SdXRm6culSM1DfnQvUsJOO3gVBd2H8kaKhpl23ukQJqe1B/btC5MNirOy9qA4UPiawCMt81oVbmSELl1ugrKJ5JdKgzmhr3ONjSzaj7q5wUNU77j2SL+MCxq1geRthNAe4pKT5E4iIJjv9uhg6TeBDM+Khg5Zvu00NZa71OavGi9vp0KlwYz1BadR1TRMrEdj9fq02Z9jKIVKFq7O3b3eFtysKwD3ryq5dFVR9D58o29b83ckjTuSqoETyLiq0wg2UMbdGktobTPyHoimolt25N65EucBYJA0IinjmIRZukxn4zpWEsIEZR3TOYNVoliPvFLgaWAoSNbIqlaO/xyeyxQGtZ812kvMKIy3IaawjlZcKAkpeqbXZYSKe1AIxd9JJX/lmQchIQBf4iurWXUdW/iAawHgbIuM+Fxwb4QVEWxMuv73grGljY2YMEzcfKcw35pg0mnYQSM5yIZfqRss3tAo6JCql2Epcd0uovoRti2GYp2u2xL0zJwPzaBQ2v3JTWrefQXD1z0R/0JYc94gMe7JfRjiAfQLpt3RITQwtCGyXfriaihS1F8ztgfdG2c82oyEnLEq66mCw7W/p/BnJrZQfW8ymbCNgDYUIG7NW8jfv/d5VnkYOTv/UiX4W9f2Go7AYr1rjU5f0fbr4WDty70Y4jEXjeIqape98PwyO1CYVA
 oxk4jvSG
 03AItYd+M6cK65uG2/OocMqPPDk3XtFurOxKrKYKgyKZ+ED14yjMa6cHPAoxlNmBvn3+pv/Aop6E/9HeW640h+5tAHobVJdDwG78F/K5JvAiBOCemdvhg9BSIfTuc6NC7ewrX9JPom8plL4edHZbVOW1akiYDhMOpZwBN59N3DQjlBidps94M2H5fr3iBenDRFr/sCUSTjCH2eeo40JbpSGvSq8Eq8tzJYYDez3U0qzW2JRMGr67wt1XGpCqdMqhge9emsa5WocbYOki/QkZXIYmxQBpeBa+gsSsAek3+Yf6nud2RCY9oqovtAABO/Sg8vHmm2danBVGQlZ7maJVZM9Cv95AL5HB3fkyqlCXanaOv1osH3DVHJMq8HuN+nXJa1gyIOrKAUvorpF8o94yuWCkHHeiMKUMH5u3TB54OhdCKgZCQzaThzfoDSmXs66KHDThp3EK/r+cpQo3Q6PNlbZhsWQZydpKP4bMMi8i49Lr1gaV7R7k1Yt7EpApa19fiHgwfebi5hGCBCYAzVjXtRWjUr3ZqvhqP/qiDqFPowv36Q8vl7sgB3mNtUCmo5arvsfo3WQ3QkzOh+aMqUTYla70h05gpMi0XdlamH/L/hPIavGESwhrVXqCjrqNvsJsUa6TwAHb+3VzbLvPX0eBoc1DyqLKQxSRqh29yGMHg6L4LqbeXEd+vDbBEXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
alloc_fresh_hugetlb_folio() as a fallback to allocate from all
nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() which blindly
dereferences it in for_each_node_mask(), leading to a null pointer
dereference.

Similarly, if the CMA allocation fails, the fallback
alloc_contig_frozen_pages() is also called with a NULL nodemask,
which may cause issues.

Fix this by explicitly checking if nodemask is NULL in
alloc_fresh_hugetlb_folio() and defaulting to
cpuset_current_mems_allowed. This ensures that both the CMA and
contiguous allocators receive a valid nodemask safely using a seqcount
loop to prevent torn reads.

From a userspace perspective, this bug allows an unprivileged user to
crash the kernel (trigger a panic) by requesting a gigantic hugepage
allocation with MPOL_PREFERRED_MANY on a system where CMA is only
configured on a subset of NUMA nodes.

This can be reproduced by booting a VM with two NUMA nodes, restricting
CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G hugepagesz=1G
hugepages=0), and running a program that allocates a 1GB hugepage area
without reserving, restricts allocation to Node 0 using mbind() with
MPOL_PREFERRED_MANY, and triggers a page fault:

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

Additionally, this patch adds a missing node_isset(nid, *nodemask) check
in hugetlb_cma_alloc_frozen_folio() to ensure the initial node allocation
attempt respects the memory policy.

Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Cc: stable@vger.kernel.org
Signed-off-by: Sourav Panda <souravpanda@google.com>
---
Changes in v3:
- Condensed the reproducer and QEMU setup from v1 discussion into a readable summary per Andrew Morton.
- Safely read cpuset_current_mems_allowed using a seqcount loop to prevent torn reads.
- v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
- v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/
 mm/hugetlb.c     | 12 ++++++++++++
 mm/hugetlb_cma.c |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..ee67ea29c003 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1864,6 +1864,18 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask)
 {
 	struct folio *folio;
+	nodemask_t local_node_mask;
+
+	if (!nmask) {
+		unsigned int cpuset_mems_cookie;
+
+		do {
+			cpuset_mems_cookie = read_mems_allowed_begin();
+			local_node_mask = cpuset_current_mems_allowed;
+		} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+		nmask = &local_node_mask;
+	}
 
 	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
 	if (folio)
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 39344d6c78d8..79dbd0baafa3 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -34,7 +34,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
-- 
2.55.0.rc0.799.gd6f94ed593-goog


