Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37574C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 07:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5BA6B007B; Sun, 26 Jul 2026 03:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56F56B0088; Sun, 26 Jul 2026 03:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F646B008A; Sun, 26 Jul 2026 03:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC7EC6B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:29:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45CBE1A03E8
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:29:39 +0000 (UTC)
X-FDA: 85030102878.02.19AB509
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0D99140005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:29:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oJQdw6Nf;
	spf=pass (imf26.hostedemail.com: domain of 3YLdlagsKCL8xtzwf0ufsiflttlqj.htrqnsz2-rrp0fhp.twl@flex--souravpanda.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3YLdlagsKCL8xtzwf0ufsiflttlqj.htrqnsz2-rrp0fhp.twl@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785050977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SDlUu4mOxq4M4aJlUrvDjlrtRU9+dmLR8ifDAla/1p4=;
	b=NAagWEiq9LlJ1yHZDaC1WoZiEXDoSlV6G2y87X/cgiTirsQ/CajiO5QSW1ZVDSrdH/f585
	PdNruR6wYMBFgU3G0NwIuVSVLrmvm2Ros1Z14GvdtaDoFzCfHey2HsXiJQaeIIvgKJulta
	cI233WdLj47LUZbvIO5RguhXOBQULWc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785050977;
	b=PQs43nsOwbh8ZIipG3KNbldIIXuy2whyFocXDxmoQxw98iXm2Zi5Xm/zsVaXOSkXKe7PoX
	wKWva+HTR9SnypG+Y7u1eOnAT+wbC9a3By2QskuBla/jIQjQIEtV0Jvd+28hlTsJNl5sc3
	JSm9EY1oTGR9C/kW/V5YGRld0FgIMLk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oJQdw6Nf;
	spf=pass (imf26.hostedemail.com: domain of 3YLdlagsKCL8xtzwf0ufsiflttlqj.htrqnsz2-rrp0fhp.twl@flex--souravpanda.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3YLdlagsKCL8xtzwf0ufsiflttlqj.htrqnsz2-rrp0fhp.twl@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cf6acd760cso20187365ad.3
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 00:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785050976; x=1785655776; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SDlUu4mOxq4M4aJlUrvDjlrtRU9+dmLR8ifDAla/1p4=;
        b=oJQdw6NfqhV0sSyMXH8TMfTfSTvY3kT4LzNn1ydEQyxB3yc+NoeO1lYIor1ooqlvj5
         XeRcXTrEiIkj9dZHi379DT24JKC9ImnrYpqDUK21+xcJS7ZqikGbm0oiJ3Ul/voNt/lf
         qR3WW9OVldqjQziABJNXOcjpy4WLLbaJsQhp+UHBQTij2kECnuqfkJVnBapUeYBKGSXt
         M//x4J3ywR3we6pZlg4bgphvLcmbiM2FaQe28aSd9O+QW6gKcBxZFH/F51dvEfgUlBHp
         lYgry+dIpQ5iv+frkgviMCMLGhmaiL7XAE9XzvO3367iYOv5rBptvJf4a+m5ITSSqUjE
         328Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785050976; x=1785655776;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SDlUu4mOxq4M4aJlUrvDjlrtRU9+dmLR8ifDAla/1p4=;
        b=tT8Wf/HW42S1Q53gRVR0Tu1DTSrwOEUqkORbGhDVc28nLhpWciyMhdzyWrONmoHpaX
         BZZjJsGT0kggcTGUJ2BLBp6aP7TRxLNdwxff4bTQA6ez1zdaNNq4kncpYsdK08msPkoY
         xSodc29YoF/GaFCHOgy0ZEq2iyCqC/uWt7iB96s7pum5lqyDlxNgEvP7uBVHnlGozPrx
         WQZaoirFxEuXFUxXc0WU7kmhNpPu9RuFT43SPT7L+5W8e2i84LPl52VJ5O6j1S9gtT30
         KcL2ZFI2K+qkoIodxSlwMxN/YlAbhKJ1sbI5x8J6XxzJLaacRhMQxitpCJFWxlkj9jtf
         1N3g==
X-Forwarded-Encrypted: i=1; AHgh+RrFPhCemuQE50D4uDgw970CmgkIb1MQS4dNSUbY/d8c2eFt6eRZIRrKGwx4NBd1LTpFsE/Ipg5t0Q==@kvack.org
X-Gm-Message-State: AOJu0YzMNpP9XPWTk07dOo1eco+PR14UF6EyY0iWNsHq+2NuNE5yGXGN
	OPDFYx2oPPWJ1gCqJlSFD9+lPiETUaizrgPLQ/W2ayOUwCh2V6GMWvEY6KGv2NaPtjnS3iHl5ki
	H84DuXu8xZ44MOy7T0bpNahBfgw==
X-Received: from plps7.prod.google.com ([2002:a17:902:9887:b0:2c7:f7de:469])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2444:b0:2ca:bf68:2a54 with SMTP id d9443c01a7336-2cfde84e35fmr38208595ad.22.1785050976224;
 Sun, 26 Jul 2026 00:29:36 -0700 (PDT)
Date: Sun, 26 Jul 2026 07:29:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260726072935.3513996-1-souravpanda@google.com>
Subject: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A0D99140005
X-Stat-Signature: n3wntim4g8cct7gxoq5uq9g9cpzbgerg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785050977-172316
X-HE-Meta: U2FsdGVkX184kN34lV+rNJ/9DfLgBRi+j/aAvA8YOjSd4t0oxw0xQLyu/hAkjdFAhmTyaeGckOO2QK64+0wfmcsRHEDsrgzH+COnaAdDG/xV+PciFLJGHR21QH5KBDkZh0BppO9KJt5ZDBEEJQ+gCsXpqiGm295N6/mrMU+eJuFuYwKhrYPRKajMf5gAmPRh1yxwI/U/Iws7Fgl7R2PqTXMdAx/iYJ39HOU1McbLTgnKk3OWBwilYgovz6s6vQZaboQ3sh7HkvxR68+rpFMDpVOrAnLN7OniNPIHm7UA97T8x6Ha2M+2X3DVBcDfEYhCXQ+x9DjZGakXVJuPUYL8JcHfzE5E1vQLObclN4QZLyJb7mGxhuBQTodxciWEcu+dYGAQmNw/5WKuHk3Q9H3O80jzjhu1ydrSevCUceL6rcQvVp14gC9n2RlIQSFC/l1ZsHWqLHFfs4V5d7EbK5PV8x4g94CmPlKZC5MShNsy6myq+tG8QLnvrndpAUN6jsllYJbYsvIuC73EyDSnX/50TSOIrg7FOr6bem55GE0v7O2rlmYkCSz1LAUAURBQvSGfrfkS3tK33Yc5bwlenY0TBtRRA/uxpzq4VoFAxllOvhwkOtSAThEEzD7HljTrjmt+ehqKrNkZ/hDo0gU/dq2YGEHU3v74NOqqErdGW1UojDRnsKJ9GNPjWhd/zrJwKR+tVxEInqmyJHbnkKC4SS0RfVq50N3GnpQs9EJFlpS61sTj4YlyPY51UtzA+fE8knp7aSHZIIxyXf7UbrU3WVjAKtKdtFCwBNWPBRxF3GLe5rrXAcw2KwQdkDBt4OtFi49saf9/x64VIINsjCjBYX1fobckG6tVJdBhb7HE7UyGDShERrJyZgRYcuScP0v2PmeD7NWuJPwnUejDTEu5Y69tsybAXMsoGruXAXj6rWHphVduhvScjt4UseuC1ZUoPeJWXfZe1W3ltpNxMchcZl+
 8vvaa5u+
 M4Zd8GOd77dSCeDZncZCSL0gqhnwraBatBOWdh0bLexHlB5tBcLtjAhYOBPAvPLH6C2Wf3llq1sRmnjJmYrT85dKPlH+rzojSmiel2crzw2Zn/DaAs0CsJBH0ZQzyAFAi2NCccmRdue0SGs5d1SQHsb3qKElSdL7moki1KP3aIq4LZyZzBNdmPAq9ze2z3KNz3BqPmlK3JJbNXDERJOdKhVN8VnhyEOps68ewmS7GxKfwKD2XAbSnLymroaScWBEI8lzywYYyHFO9GRqs9EGsvmHeZvFsgcVRYXIAW5puV0bLqG7EB3TjkHE7BJhIHlxr2Xc094IqEqllDltYKtpgOScSB207I7Q2CXm2xFRdreR9QDT2JRprabvk3fPBDmlnyoCbC+PLhKCCVWlyN07mv9hy5Uo5864MaCdW6yzhoDX4kQOuhbRZmfFx7YTT9ZLwJLnAl28HyL15QCtQrJfurm04Xom5ufWQYVvd5P/hGmJuIfsAtuCw/gUBaGhH0bnvavYQMreVorau1u7qtSt2l0wJLBYSRfwSs3TOFPO3jpt4CLXz2w2s1+fVWjnO4zp47QsZdsZF2tjXmUFwcqmPyRqefcWdgH/I+Xrey1HbwMgCkExPmMlRTbPScQV4BGVsDSjjF8eC1pIUCQwMvD/vREP+6D/xPw6OMG06Q1ylqQzLk8T7apiWclwVJg==
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

hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
leading to a null pointer dereference kernel panic.

Fix this by checking if nodemask is NULL in
hugetlb_cma_alloc_frozen_folio() and defaulting it to
node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
back to any node with memory, keeping behavior consistent with
alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().

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
Changes in v4:
- Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach from v3.
  As Muchun Song pointed out, snapshotting cpuset_current_mems_allowed does
  not prevent false-positive allocation failures without complex retry loops,
  and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() already handle
  NULL nodemasks safely internally.
- Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_folio()
  by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
  HugeTLB allocators clean and consistent.
- v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
- v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
- v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/

 mm/hugetlb_cma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 39344d6c78d8..5744de0ceeb7 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+	if (!nodemask)
+		nodemask = &node_states[N_MEMORY];
+
+	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
-- 
2.55.0

