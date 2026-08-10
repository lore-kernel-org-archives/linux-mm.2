Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B02C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 23:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C3C6B0092; Mon, 10 Aug 2026 19:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0CF16B0093; Mon, 10 Aug 2026 19:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FAF16B0095; Mon, 10 Aug 2026 19:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 61FC36B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:08:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3D79C02CB
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:08:48 +0000 (UTC)
X-FDA: 85086901536.18.FDD8A6A
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf14.hostedemail.com (Postfix) with ESMTP id 27167100002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:08:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AD1G5Q0E;
	spf=pass (imf14.hostedemail.com: domain of 3_Vl6agsKCPQokqnWrlWjZWckkcha.Ykihejqt-iigrWYg.knc@flex--souravpanda.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3_Vl6agsKCPQokqnWrlWjZWckkcha.Ykihejqt-iigrWYg.knc@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786403327;
	b=8JpuzNN8gOrmofKCyNGeKkGCyTfllLKV2TxTo+taR2FzyNa6kv3vgNaRSNStWeccfgZqzJ
	InCGMYshz3T5joR7WqGpga8S1joihnhTV7GgjSPnyMCsJSqHGnN6kt5t9nhf8WoX9Y23bo
	LiZ3F7YO0DHMrli9ZYDDg5+tuU3JEHk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AD1G5Q0E;
	spf=pass (imf14.hostedemail.com: domain of 3_Vl6agsKCPQokqnWrlWjZWckkcha.Ykihejqt-iigrWYg.knc@flex--souravpanda.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3_Vl6agsKCPQokqnWrlWjZWckkcha.Ykihejqt-iigrWYg.knc@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786403327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ItB67UhN5xHbGpjuS6XYU+rFxP6+nTJipcuCpIdU/ZU=;
	b=zfsrjJTWX5vrAzKfKpdk4fVOrU06MoZmLKEaVIVAl3FefjoMh4tzxHJ9xouKI0wWFn+kFT
	WDmqTLSUzXGXSm4Eq2waD0+3L3s8qUWxt+kDdJkeQmUgqx6S58XBn2GB8u2d8jLHD2wzaT
	xugVtK/6UgXko/KN946A1rX7xyRa8W8=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84c4cd31b51so442797b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786403326; x=1787008126; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ItB67UhN5xHbGpjuS6XYU+rFxP6+nTJipcuCpIdU/ZU=;
        b=AD1G5Q0ENu1QVNN07SKInTSrmL/3pdkoarmkiHE+LhmIkvm5M085Gz0oH/T5DH+B8M
         +hjv4f3q2/thtzCwFeOv7lVLfdI6pUe+ayvaIdpHTdkK6vcLkeZwM/p4XGNigLXuef9S
         7M7Ffj+KlBQaRLxezyVSt4jgAtdPE9/mnr+Olr/xxiLlnod8zpIJvFqwb+lCFiFK+s7V
         X83d0iXcYg87L4S4tMAWfeLE0XpI2i/pFBc1GZQmmgeDfaypjC9Q2KCI3qkhsmCcd8oD
         EAza6eElPTSOE8LapwbXakusi2tCQz3CjtmefU9GxPtfnMBAcJZMxDRUqaEBhWYtFqJh
         Fcfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403326; x=1787008126;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ItB67UhN5xHbGpjuS6XYU+rFxP6+nTJipcuCpIdU/ZU=;
        b=jixPDkI9c6y1Z9cYbw/Fhl/YAincYExAvtupVuEzvY9Q7SetM8RJbnjpzFqGBqfhxh
         CwoFXngu7xIWg8781Sbe94d0zX+oV23nBSsje7KZOuSdU/RtblSe4XyDpV6SuMwp66B5
         LhaV5n55DQl6gsNAkn/xStHfce++TFPTwiuJZ8jaUZrgaR3R42kpsXgJ/kOeYBKNiPdJ
         Nk2qXeX3kgU3M+fuogYff9QHeZFcmNbYc/tC1WchvnWx3vLdH+65CTBzDyBTjUOVkoC8
         9sllfLdi87Afyx7DdPQSJ6CrjxQwu3y+LkGh0J/nTiiQ4qzZNbU8W4DQ4TQw/pNTcDj/
         22Fw==
X-Forwarded-Encrypted: i=1; AHgh+RrEpRaRuNWUWeLjgKXVh2zPSMzxhjSQXWFtLMTr/RRuxI0CH2RLwN/4F8JE0i9fxulvAO3JORDZnw==@kvack.org
X-Gm-Message-State: AOJu0YzYnHgYpdOjkErpkhDYW2M+ea7dujLTvr35IdD47hgjk1vrPzT8
	JMA49yj1clwp0KyK8/rZt1kbnhtwemsXu0foRouNLK+35ZMZJWwr/Lmn1RhGllpviffvxedLTNT
	cIvbKZBOm/sspNaQQyx4nb4Dkeg==
X-Received: from pgng7.prod.google.com ([2002:a63:3747:0:b0:cbe:afd1:613e])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1485:b0:847:9dd7:2683 with SMTP id d2e1a72fcca58-84fa1851e75mr1737003b3a.9.1786403325561;
 Mon, 10 Aug 2026 16:08:45 -0700 (PDT)
Date: Mon, 10 Aug 2026 23:08:44 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260810230844.3778931-1-souravpanda@google.com>
Subject: [PATCH v6] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
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
X-Rspamd-Queue-Id: 27167100002
X-Stat-Signature: 44tenqcpc6i18cb37jh1jkkuzrjujxhy
X-Rspam-User: 
X-HE-Tag: 1786403326-268567
X-HE-Meta: U2FsdGVkX1/0070nUE/wpGXjFjSgdcKvZjVME5YMC8M1a0ygzRWCZHhuiE3Dnaa4GYIzoFF1F+7HDSIpDn4d2bGIMmv8YriuoC5xsr9siWkCGbONv00JdE6w8HJtJMo5uDLXgoDTJuvLH+6MBb9VbdOksSqvuwSbGedumAf0aGFwzfX+1aMk7W0dmtzoD4txXRO+WugSQowkF5Pgpqk4Oya2AaI1XO9EUNH5RJbGG73htoVmhpwKBwDL6VQRzYr/59pZ3kcl7aaHJxGImzz0c6e0AUCfHC0hTbx97cSwQwXWPJx6RDtLpDj/TJ+VYfQ8ZnkRizA/f5f3pfzuauszzt8wXBZQ1Tc3MViaf66Fjjy+TND2b5ksnsmiqxywM2xEWTsumkqXSu06F19lC1IErG39SQq9Izir4U/t6V2lufNChAYKGqi1qzFEpyIPHUJTNQPxsOA3ADfDgrPvbtC/9MHEmSTzc5coNBPbbhlDXKDbRmfT46F8MvX0+Xm9jjpq7E0vCLNP5RDacG+JaEsGEARbE3VLqZx8crjUidxZKs6k4B4PnaFF4LWwa67nuhv7GFikcdt2flK9s+rxqHCDoTYhqD1a0+J2ukBa0P/XPpqe6VNzEfbEY6CIx4vsn7igU+6MIoLYcncPV+OGDCfspbvzVbGSnY0ph+gkRJXafxABHgL8r03kx59mTDxpoiks0qaosm3xEoB6oIxhtSU2gWO/sFORMmKqFG8aeJXoSBjTNoeF8ujhz901VV1NCd5vp5fC7aa8n1BMoT5P9vWXCuS3vgSVmt0991hmptoF7mMfLzftNRcsGSrg2WMoxOEGkrVL7vZnx5znegM11bB2TLtp6cBd0xfqZ/kwEjiPBIykplJ2nvVxVwitfKVQYCKAaLmu6hGAGeJxDAH+OTumPHKKLMTihemtpJofby86QVbMoEhxJqyqPyuHZPZbxCeCPh7D06zIyvokiBklIMw
 0mCMHp+Z
 /P7Ld/M+WbnyMUnKZ6Y0j/A1ZBj/2n97upI0IyUedEYPMt99VQn3FsZTbxprfW7s9FyrpanULhK0Wc9D1QepL0W9dKqSQZ1E41pfnbe4Jc5NmdDGt0J0Z8opo3ygkGyrOZi94Ns0QY+ns2g8OLXU5y1rW07eCaLgBKodrz8iCv3TSEI4qEfeZwBoVOv2Chb9DFlPt+7OYAMA+oo57zXCm6J7e9qiEMcEqMx+ZalprNxG0Otl4bA0vqPfJDmKWbmQmuiXdrBZ/ml/h5AEPQLBSS0VzmKVA7rWVG3qjKPzwARCASFW2m0P9oKADlDEWg64FBDBiFkeBHetA55/JvxsRppDLvLoJkXup/EhoSBUuM51aRGg6enzfSCYyxwNefvG9UVh9/QEg94wkqlOWQ1wQY+3wvIi1UJ0SkKaXs1pa74D8GR70BmJ7jW1o9nV2idhPsreUZwpiWZmIYB4r2CCBxXokH3DvEqraUUYCSHfK3tEfcJ5qaGxC2yicwRhbWbPXGgT8jgEFkpJ8qwk46DW23C3AfFJq9pe6wF7DZMhk2vYgZEla7WQgsZ52CE4KHa1ROqUGgSJO7WeT0/BBX4NR6o5mAKmICacrE0qPsWdiWsfFMOhke9jctrJD3ZOpbS+vAv4NdylrrCsQGgX7T42vl96zgcly8ooLgtOlctDYv2mXO67qSJEE9v7QZQ==
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
Changes in v6:
- Enclosed the CMA allocation attempts within the cpuset seqcount retry loop,
  retrying allocation upon cpuset mems_allowed updates to prevent unexpected
  allocation failures as suggested by Muchun Song.
- v5: https://lore.kernel.org/linux-mm/20260809043250.2917406-1-souravpanda@google.com/
- v4: https://lore.kernel.org/linux-mm/20260726072935.3513996-1-souravpanda@google.com/
- v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@google.com/
- v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda@google.com/
- v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/

 mm/hugetlb_cma.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 39344d6c78d8..9debf033d4fd 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,15 +31,27 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	const nodemask_t *nmask;
+	nodemask_t local_node_mask;
+	unsigned int cpuset_mems_cookie;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+retry_cpuset:
+	if (!nodemask) {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		local_node_mask = cpuset_current_mems_allowed;
+		nmask = &local_node_mask;
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
 
@@ -48,8 +61,12 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
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

