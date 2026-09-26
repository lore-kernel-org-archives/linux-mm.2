Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918A1C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9956B0092; Sat, 26 Sep 2026 05:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10ECB6B0093; Sat, 26 Sep 2026 05:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1B26B0095; Sat, 26 Sep 2026 05:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBA976B0092
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:24:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2570640648
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:24:56 +0000 (UTC)
X-FDA: 85255378992.25.88580C3
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6FC60C0002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:24:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wYOspMX7;
	spf=pass (imf28.hostedemail.com: domain of 3ZI-3agkKCL0wduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3ZI-3agkKCL0wduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTQndXxkIuwWKoVUm7RH0Lfp0eOzvHI6CoK2okedbuw=;
	b=HB9IRfYsdKwtuSJ7FWuBB00c4AbG72x6OHd7lS4J0Ogz4S9S30upYOYqxhhMWEnF+L36ZH
	nDmQeSK0gS88NU6rBhUo2A0mU2t5ltNsV41SLiDWj7Y+fMYeKofgBVFfZs962G8VkfkcH0
	mplCEjMK2ee6lPX2PGr+09kzKiaTPo8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wYOspMX7;
	spf=pass (imf28.hostedemail.com: domain of 3ZI-3agkKCL0wduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3ZI-3agkKCL0wduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414694;
	b=m3Lnuw83H49IEdXh8VeoQfz+D24oDTuyimR8t0pdTL8QPHsLKWSPr42EnMKni/IUr1/cfq
	WmmcONEFDjdaZy0KPv8nNryVtbE9bu+hOp3j7ZvzMouHM2VezojxEEramAjtdWmVNIUE73
	jA6Crv7VjxGFy5CIH6MBQlCV21NOiPo=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a22bf0so2022561a12.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790414693; x=1791019493; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sTQndXxkIuwWKoVUm7RH0Lfp0eOzvHI6CoK2okedbuw=;
        b=wYOspMX7VYw4KNMuArTNvjwMXmej2+Dxabzyjrlk/nE6ERyilI/H6AfzSnns6cskL3
         XZ1VemGhI9mpAJcPC/aaOhOGOw+E09RSBeh4+NMpXbPFP25O2aiP1bMfL5LVpTc8GhAo
         RUai0aZ+gKXIAY3pB4UugcmjIdz7USYbvJOgZcnooUKpQdJWITut1u1jcRruxQQMyQaM
         Z02tyx6tBN2BKSkdCxmsQWCWpOC4M2zFDXUQnKp3rscE1izbmbl8OCmmHCTi/Uckmw90
         PD4lVnIRtcNATtCkIQl1TVXKSGFO38Yp0vPzfafujd+t6oV2LeJxAo00e70YmVb/aq1X
         KDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790414693; x=1791019493;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sTQndXxkIuwWKoVUm7RH0Lfp0eOzvHI6CoK2okedbuw=;
        b=oXln6WbdNu5WeEwCKEC6w2k5yOpV3tuMexwOln3xR7BHdUQUuTsa+/hUPh1FezJeJP
         oobyCISBC1DDRNo3TS0dZAfBVZnHbd9fVRwjl7i7XYBBg3HbYymcJJzLDGsW9NdgCiAH
         rrLtg74MnQMvcq5uep/XlM1Sw3pOo+e81dM7m+SZc1MyQVJbUsG/X6SPmKzojFz4I8tT
         h9GwBOMF4TZCS+u0rc36QSt7aiNa9NANFV3McBz1E31RgBpkKV3xJF4GC9YogFPRkILy
         tbr0br1DGVpkjWM6ItbCgLDWPkU44LcQr4t/I3BODvDm7KK8bpwQrPqSbgbCqlrDnuMY
         EpRg==
X-Forwarded-Encrypted: i=1; AKwUvBwRMzEqxCAxOj+MqbSKTdYuaxM04RGCbuGGmLI5sE7dIEC/sm3LSxdoIIsIq8ljZn2gDHvvbIxGPA==@kvack.org
X-Gm-Message-State: AFuF++nZoA/EX9CwMhQ8alNcnXpMQU1NaSqWzmrFNQeR1TtwENCbvdcA
	eRPfLTpYga/U+pbKp0lzu6vng7jZha8Ld9hM20akle5TM3FXAChaq5glX277JLJ/ubMG1qruXcO
	ZRIBV3B72BOKiEjCF2A==
X-Received: from edbet5.prod.google.com ([2002:a05:6402:3785:b0:6ab:222:1e7f])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:23c7:b0:6a9:e7eb:f52f with SMTP id 4fb4d7f45d1cf-6aac90a9049mr5754388a12.28.1790414692533;
 Sat, 26 Sep 2026 02:24:52 -0700 (PDT)
Date: Sat, 26 Sep 2026 09:24:48 +0000
In-Reply-To: <20260926092448.4090401-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260926092448.4090401-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260926092448.4090401-2-tarunsahu@google.com>
Subject: [PATCH v3 2/2] memblock: use binary search to locate candidate regions
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	dmatlack@google.com, Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dev.jain@arm.com, 
	Pratyush Yadav <pratyush@kernel.org>, linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: e7tkbmk99ipdtbsn5yr6rj4qzg9sth4o
X-Rspamd-Queue-Id: 6FC60C0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790414694-34258
X-HE-Meta: U2FsdGVkX18Liz4CxmQ6G0BtBLBWKTbzPcMOoM1z4gqGfaOBK3vSRynKrnwB0mq6CaMMk7O+9FVmjR+Ktli8ySxTZei9gVa+umOTFEHhDWr1QFCkA+tg/dofIc6fH0v0+RDyJbfoti9VTsmQTxUN6O+wnafg63ZN8GwDaNJup0YHgG/zy/ifDZ3eApM63bCD5+sb9wm4lVaMZ6v3UzWUp1VADOEmaHnHphBR3MtN9fTxBoI5cFvEUWw6RkcLfN08Oe2TiEFG2KqbLv5MXJze3iwaMw0Anxhy/lgVcQu/gm37S0nKkyffPVsM/qpKVwa/GMLVXJNKnatbXf8xOWcXgI6kS6Hr7Ut1jYyf18P7s1JPRzamNbFG5jp70eAi1hapU+LHlra4QVn86wpHLmAyAD1FUX5UbMsl3468LMXQOuvxSsuz0RD5uWSGwdi1jsLhtq+6nPyCEFan3JQpw72FEAHyP33k/G0bf6hFGF6SGwky0BNt/wKKI91zweqb+anY3ep7zJ2tcW1NLvsMc0UvLBMeOEPuu/OHUbufk9gYJUPM7XjvgF2vmSAwGQ/nyup2vZPDodYNfvutVlsguAyRUHB/UnuBLD9Bfsw3PyVkOKrH746rXjqIaQd55pNky70WtnYTILW22nEQuiKS7XL0S33+T7Eyf8/F7kIPc/RL5PMHWlgRFdrKum+eWtSMtKuJnPPjfWTB8pmdYT3mFOR3LITyUO/2Z4klStP9oAveF/O9jjN8BRICy1TV+tJjjnzdb529j9cALDz0rJOSG4uUxX/Mh3okrZydG1itFwyRMI+k9Q+9YIXUpUCXV0pNHI3ol/xZH2LQXJRBU3iOWqCwYe+jEFGn77e2u5WrabDTGdMu8sAHk0dXj1UdA3O4jbx4jiEDpKkJ912jlk0sVF+6aRYdKeyvk/vdqAk2Itd0bbazAOi5ZfyFrEyG3NDQFPjGdFn5gwegZ4m3LlpJ1c3
 6UOf7Hh0
 1aP9fB0yzmGhVkeCS//3ma+N6EvhbfiZCTSG26yBaACV09JzzDJ/mKKGQg5SF7npM73WIueyp8aPxwAeOw8CusUx0RsOPtm0IU7i/nqoYjssDs8+xJTa2pp25to2H9tUZR3FiVoaX+lpNPr8HhqJILkRpinGWTT3JzrTVeaHLnQehk3VPTy6TLgg8ydrpEHuGsABPeoIqc3zDxjjT3PnzZIopbEnuKmjym3TMQZxrYxD09/ZHIBSw5sqEFhi1KUVwSgVf7I5p1RWa0BLxCyBCXynHmbVxlI2zWEu9REttXv/Nu8lxPF6s4Us223zannclpKBRncXrc4mfTH/dR9a9rfh/LkiFTfY9HJo2DJMuonwX2VvqOGm7quHX2JjHF+2lqLadjO26sSMacGScEY0nbeep0jAI4rC2ODahWFfUXEIj5nCMJcmrgnLiqDxBBih03PFPwu+8Mm/39JMpni50IBw02lhc+G9XAblcj+ca/MzThdnAzOS+NzGXddDqP6geBEGgiq6r/H1eyTrk8YZIhbKv71+/uEA1rfLdocIjlEUdlRMWoHdsA/n3giqNeQbcyZH+d1Y23cH4BJNAjqtjAR4de50pz1S3EVEG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use binary search (memblock_bsearch_start) in memblock_add_range() and
memblock_isolate_range() to locate candidate regions instead of linearly
scanning from index 0.

Under heavy memory fragmentation (such as KHO page preservation registering
hundreds of thousands of disjoint folios), scanning from index 0 on every
insertion and isolation results in O(N^2) complexity, causing boot-time
memory retrieval to take several minutes (~268s for 393k pages).

Using binary search reduces the worst-case complexity to O(N log N)
(and O(N) for sequential appends), cutting KHO memory retrieval time
from ~268s to ~50ms.

memblock_search() open codes the same binary search, so reimplement it on
top of the new helper.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>

 mm/memblock.c | 53 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 59dda7d085f3..87c71435c80c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -586,6 +586,33 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
 	type->total_size += size;
 }
 
+/**
+ * memblock_bsearch_start - Find the first region index where rend > base
+ * @type: memblock type to search
+ * @base: base physical address of the candidate range
+ *
+ * Returns the first region index that could potentially overlap @base.
+ */
+static int __init_memblock memblock_bsearch_start(struct memblock_type *type,
+						  phys_addr_t base)
+{
+	int mid, low = 0;
+	int high = type->cnt;
+
+	if (type->cnt && base >= type->regions[type->cnt - 1].base +
+				 type->regions[type->cnt - 1].size)
+		return type->cnt;
+
+	while (low < high) {
+		mid = (low + high) / 2;
+		if (type->regions[mid].base + type->regions[mid].size <= base)
+			low = mid + 1;
+		else
+			high = mid;
+	}
+	return low;
+}
+
 /**
  * memblock_add_range - add new memblock region
  * @type: memblock type to add new region into
@@ -609,7 +636,7 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	bool insert = false;
 	phys_addr_t obase = base;
 	phys_addr_t end = base + memblock_cap_size(base, &size);
-	int idx, nr_new, start_rgn = -1, end_rgn;
+	int idx, start_idx, nr_new, start_rgn = -1, end_rgn;
 
 	if (!size)
 		return 0;
@@ -644,8 +671,9 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	 */
 	base = obase;
 	nr_new = 0;
+	start_idx = memblock_bsearch_start(type, base);
 
-	for (idx = 0; idx < type->cnt; idx++) {
+	for (idx = start_idx; idx < type->cnt; idx++) {
 		struct memblock_region *rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
@@ -809,7 +837,7 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 					int *start_rgn, int *end_rgn)
 {
 	phys_addr_t end = base + memblock_cap_size(base, &size);
-	int idx;
+	int idx, start_idx;
 
 	*start_rgn = *end_rgn = 0;
 
@@ -821,7 +849,9 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for (idx = 0; idx < type->cnt; idx++) {
+	start_idx = memblock_bsearch_start(type, base);
+
+	for (idx = start_idx; idx < type->cnt; idx++) {
 		struct memblock_region *rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
@@ -2062,19 +2092,10 @@ void __init memblock_mem_limit_remove_map(phys_addr_t limit)
 
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
 {
-	unsigned int left = 0, right = type->cnt;
+	int idx = memblock_bsearch_start(type, addr);
 
-	do {
-		unsigned int mid = (right + left) / 2;
-
-		if (addr < type->regions[mid].base)
-			right = mid;
-		else if (addr >= (type->regions[mid].base +
-				  type->regions[mid].size))
-			left = mid + 1;
-		else
-			return mid;
-	} while (left < right);
+	if (idx < type->cnt && addr >= type->regions[idx].base)
+		return idx;
 	return -1;
 }
 
base-commit: 1f18d740165163910df64d3063e1ad31648bc5e0
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


