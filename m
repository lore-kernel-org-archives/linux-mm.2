Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F79DC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 17:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39AC6B00B5; Sat,  4 Jul 2026 13:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F120A6B00B6; Sat,  4 Jul 2026 13:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27E46B00B7; Sat,  4 Jul 2026 13:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF9216B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 13:49:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13C44140547
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 17:49:35 +0000 (UTC)
X-FDA: 84951831510.06.E3BF5DF
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 759AA1C0003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 17:49:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=luaN5odf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3q0dJagsKCLgqmspYtnYlbYemmejc.amkjglsv-kkitYai.mpe@flex--souravpanda.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3q0dJagsKCLgqmspYtnYlbYemmejc.amkjglsv-kkitYai.mpe@flex--souravpanda.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783187373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vk4Q1IL+H0DJ+/uFKCde3qqkuwUWo/vem0qrwOJHzYI=;
	b=Gmd1FO5lxdUI4tsZC4IvM3U2rKIlEZh3sG7JnxF9q0qPohtszTwb+pmS6cbHCWdZL5XCHy
	y2m5ccgJUdAaudfMt3rCSCcWPBZW+1+AR+kS/QXFFT6JJnKdk5nE1OUGTizu7y3KxSQqu6
	Lzz8VVcG+ZEW4WGswpbfiDEl+ZhzYDc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=luaN5odf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3q0dJagsKCLgqmspYtnYlbYemmejc.amkjglsv-kkitYai.mpe@flex--souravpanda.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3q0dJagsKCLgqmspYtnYlbYemmejc.amkjglsv-kkitYai.mpe@flex--souravpanda.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783187373;
	b=xQnmcwKmvVSMsJPiLDa88RIoQkvylMtxb34bUICMPGmW/noh7O3pMAjfsbEYRQMyYHVIIs
	UGahP/9Q61UWDGsWZeKqW4V0I04FDte2fd8w4qXdaOAzw5WjAYDwG+9pAM3puYXTaXiAE8
	rJzodP1I/m+ZzfhQmGc35Eei9XWCups=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-384048e7e14so740777a91.1
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 10:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783187372; x=1783792172; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vk4Q1IL+H0DJ+/uFKCde3qqkuwUWo/vem0qrwOJHzYI=;
        b=luaN5odf4YIhAWqTpvXmjcnaUHI7aTQqc/QxUnT1r6/fFFIUQ+jZmryhvdgWkpzMCj
         McYq32h1s4KSDe6DDKLo2IYVLnf+SPoQBHT5TW2OeTotSPFDXzDAT4pW3KJ3PWXOp5TY
         1nNoNfPaX391/gEs81WYdusO4gJVx0ft75GcnEquRgI7FbRTE8HFiTuO0KgqSbNdZW4N
         nTQofsuIIBnb18ImpGsEHraPL8lBD9deR28J9Uh2oix+BXA9RF3jE4mTN7GEFm2sDX7N
         kTaaiWNnxfKefDqcka9/JiJd6KmEWfvc5/U1h5SoWvxQcQyY6hjoiC7NslyCol5TVoTP
         EQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783187372; x=1783792172;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vk4Q1IL+H0DJ+/uFKCde3qqkuwUWo/vem0qrwOJHzYI=;
        b=VK2+ReNRPDCZtWcfkbbWmla5QDU2wjUeD6yL+yTYY9Zt3mKccpNHeJqVdAW4gLf0zW
         uUnv+38ZEegWj6LT1YvEh4Bn/SBVWHeqmU7s8FvZqtosIUcnQF5nZqrDVrfe+xzrxxzh
         H5tg3YlWeKYn7aC4WhFR9NDumUREdyDWEXxQBIjjrCyc44W5+dkKwL2ddKFjyyieIX51
         8cSi+QJvoMdoAvPtKUUefY9GyMiGiMFOevWd6cPkhoZfwpsmXWfc3nF/31nwwDDfK5ws
         SpVHcHG/RYPHl3BYYCpf5XJ2pvbxRaNNM14xv04u/HdGIlbdWBjEZqN0qDYlic5y1Il8
         xjSA==
X-Forwarded-Encrypted: i=1; AHgh+RrYojwcD7p5HxQkMMu9KS42Vrs8WUNfIz1uw6ggz/dzy7Y+G7TLP/bjxzN+n+vv16c4E2kpozflXA==@kvack.org
X-Gm-Message-State: AOJu0Yw9D3txmAWWBVbihMBc+Lv7CmbsQEe19xQZNx8TMvPyy7oATWfP
	G1/GSwdP7ndfIr0rIDT5DrhbSMA2wyPssKh3/NugMakNhiEfyzi1Wx9596hsLws6yRHMt023495
	5nv0U9T7J4QqHN9lp3sGTiOcVMQ==
X-Received: from pjp15.prod.google.com ([2002:a17:90b:55cf:b0:37d:a52a:ff00])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c3:b0:37d:ee77:78ac with SMTP id 98e67ed59e1d1-3829f00771cmr3866565a91.19.1783187371917;
 Sat, 04 Jul 2026 10:49:31 -0700 (PDT)
Date: Sat,  4 Jul 2026 17:49:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260704174930.2885785-1-souravpanda@google.com>
Subject: [PATCH v2] mm/hugetlb: Fix null nodemask in alloc_fresh_hugetlb_folio
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 759AA1C0003
X-Stat-Signature: t71kudps6hfys63tuhfbom1814ugbrgm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783187373-779979
X-HE-Meta: U2FsdGVkX19+EycsjhM2NKEiDZiZ/4+8VCPwm/yBcUsHjpPe+Mc1UJoEwvAxdXfpkqDZu1f1Jf+vsKj6mfV2ISVh0V7UEvlj3qCSQUz1hXsVj4i5+5frCgYdzHbgl8mOACJubfoT9p7iuAvMgaw3HH4TfNSVSOuq9M4RhgFreYBxIXJEjZPuYLjYtEIes0WIfyuVAqg1amMkA9pMDj1UwNObNHuqun1AYaSUs5qVnAmDBQaaIIdGA5eKyon7DLpTBqL1H1QINW7trxjs6g1TlUAbyR41emn4uFr6eqCGM0/XXKNP/JsS9OEJ08EYq4sUUaXx2CQcuED3jEw3QD1ZToQR9NxyDisp3sqAgtqLHQglyH5JHrSfmQ45Ujhjl/SPxfDZ6EwY5dwxZmw3jXIZbHNVBM87KzB6haexA4MrB4eGozjpSCUOiwznLf4fgaIj48OO0rtmyP+wKnZ8owyPcG8CJpCBy/HDhj+piqiAKSSNekVeHS4oACjDOtrqREbEROlL5KYcQVL2RBndZWR9LP0he3HhISmWfLP12Dl/68rHIGiTAIQnT9yXAMf/FW8kvB1pPo1PBelFguZF1/JlagaIHTKNaQEfMKD2rANT6jXyXBmqWiBMMkUMW6QDEr5uS9E4RgHSpUQ6H4Jm0K7YWMP/LisIEC99mll8DmHhbozijQgnpV1Dm8BqEPthnOipt2Z8xt5rvAIAsMjfZGwA4ZM9G7qkgwCWX4cmVoX1x+qBZy05eETHHkwPXzHf6TyrY5RlWWSkZJ4FAUAAFRaM3QKXzpzVu+pgkTwK4Qs5XLtRtpr8DHFA6Qxk+w3v7GpAaeNKU8AH87AbwJYql/6NRCXk8eCWuXGP0EpaHPpJ76g8FgHuXuJsR0spvM8nabVCEvwZnhHgS9qXHGyj4aXY509Fs5qgX9SOuyPd0Ch6psOgS6H+7DAkTU2bmFJ10TjAseCOLlMwRAXEYU92B+0
 qA9YegdB
 Ujf4soIy7dSjk3TCWg7t4Qm9jaV8/JSKwj72eyqJnK/jA7qBPT73akXHkpu0Lw1mKv3gAcEJ9r2JogYtOrJZzEO2jFNPRN8l++CREfgPYYyRQh2OjahZOGlC44MTQF69pd1GPJhXtDqpfJuLzPknG/hbnT/tQwC9u7cAwdf2syilpkVRfYArJLORtOVKBMiUpdgpaK60FTyBlLZtWBUSp4Fy9taKKzXHtm/Qe7XUBWtGUR0dWYN5C+lfwGjR6VRgwezVXK/kB6MQ8tyENAKrkAGE/ua/ozYteDP2n0TtMEovDjJJXCLLchwAU71LWcDOgDac8BOmeb6B7feU4aLf2R9zuFKBIJIIWVnXHWoo4+sDTxJdav/d7bmkWQqjpf0xSQVEhU4Wyss58jkMLKR3jW1OQz5ly2Cg5cwUpiXX7WR3kHyOWHxGl4ZGftsoQ9pwF4AW7I1+EvvIAW+0C8mWj+t6cnGki7pzrEq7Ge/DrGpK6u7KxB8gFGQ+NtkI0AV/ppvorg/UqheuNzR+3xauDSTvpwfpP+KMDdh+qjqI3kNzxQVsBBawoetgXhq+XhVpikjvRPgN6Nh/nS7Gz6HPyYg52w6tIhdzrNCfCNxU53+v48gXiMqse9ohFOgLb58gMHJxwApIilQkw56Ymazh5gc/h+ZOlbxCpCsgpW8lJBRL/hYPaHWmnor5M6g==
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
contiguous allocators receive a valid nodemask.

Additionally, this patch adds a missing node_isset(nid, *nodemask) check
in hugetlb_cma_alloc_frozen_folio() to ensure the initial node allocation
attempt respects the memory policy.

Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Cc: stable@vger.kernel.org
Signed-off-by: Sourav Panda <souravpanda@google.com>
---
Changes in v2:
- Fixed in alloc_fresh_hugetlb_folio(), because we also need a right node_mask for alloc_contig_frozen_pages() as suggested by Muchun.
- Added node_isset() check to the initial preferred node allocation in hugetlb_cma_alloc_frozen_folio() to respect memory policy, as suggested by Sashiko.
- Added Cc stable as suggested by Andrew Morton.
- v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@google.com/

 mm/hugetlb.c     | 3 +++
 mm/hugetlb_cma.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..ab5deba4f7a1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1865,6 +1865,9 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 {
 	struct folio *folio;
 
+	if (!nmask)
+		nmask = &cpuset_current_mems_allowed;
+
 	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
 	if (folio)
 		hugetlb_vmemmap_optimize_folio(h, folio);
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


