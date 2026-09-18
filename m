Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B7DCC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F496B0093; Thu, 17 Sep 2026 20:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6C86B0095; Thu, 17 Sep 2026 20:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BD86B0096; Thu, 17 Sep 2026 20:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7716B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:22:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB88AA4D3F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:22:45 +0000 (UTC)
X-FDA: 85224982290.03.DC2705A
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4114AC0008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:22:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZQzq9Trx;
	spf=pass (imf10.hostedemail.com: domain of 3UoSsagkKCGkaHYbUZHObNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3UoSsagkKCGkaHYbUZHObNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789690964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2457T8NXpe+VYhyIx4NQQZX9J7v7gQmMrsUW0L2lVQ0=;
	b=bSXdKjKBTUp7NBg3DYBIqz+rjQ/I1B+6gsMYw77aAKX+7C4Jufvl6ZohKrxaF6PtSg2Qa0
	YPjjN7Y35JdnTMZJHpMhWMuboyCOk4JcqkGbYOoJkBHaltXk8BINheBPnwQrws4RH/JZ4a
	/Q/jOcOFdvJ5S0BfCswYNfuCsq0laYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789690964;
	b=OMy7ASEHyQ9gL4qqCJwC+WGbZYdSPDvcfLkeFRl2hHQ0/+OPYIovDMz9oYvFuTBmaui/sB
	6/DWK8Ir+P04KnJsc11QcKhteuG34bXu63lSLA9O3qKMcpSashsMbLy/kyZIY2z0dKJ4pq
	8YmWLa9M7Soe0X+Bjqu7TLuYRWNvSSQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZQzq9Trx;
	spf=pass (imf10.hostedemail.com: domain of 3UoSsagkKCGkaHYbUZHObNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3UoSsagkKCGkaHYbUZHObNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2939e341f7so19599666b.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789690963; x=1790295763; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2457T8NXpe+VYhyIx4NQQZX9J7v7gQmMrsUW0L2lVQ0=;
        b=ZQzq9Trx9WhyGTbl7aCg3mvmkoSgewsauInZhnBzBF9vWWfCiwAn/aVzO3om/ShKMm
         Alq+Wi/wtu+cQd7IkgAlEh65abHQ2on4JNx57WyL2eBdX+DMypdTRZTnBxMe8M2HfvQd
         66QrpNGznRfgtOxLSKNQ8EjRfSDuuJ6VzIt7KdwhrXTuqWl0MNXnFDv4srbT8k+YS3/9
         lT3uPZBXAudTesiKccq98xgKlblI1P9dynHWBjmQA1Y4F3Cn1sE47pqNibjTRY9YR/W6
         0dRgqT9JiLlsI3a/+/QTfn+iXoQM8aTwJhdwJx68/pVWGg7Jb+PA7K7earzW4HaAoWzh
         Nbfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789690963; x=1790295763;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2457T8NXpe+VYhyIx4NQQZX9J7v7gQmMrsUW0L2lVQ0=;
        b=ggafKdVQqNZwnQWQGy1FMyucKSrmElHp7VwuLYNUPTMpVTzy+pIUNCoEQXYB6iJtAI
         yI4qCEdqeVWlRRRicIo6mHkCDUIqjDaRZDn9FoFn8cqkgGFXQ2yo8zGepnwOgvW5SvDT
         GBQAfXeahupXNrqzX8Nq/C2Ut1wVd4GHiVIlFV8vctRgVyiOC+EFTUY7x378gY0KeDcE
         MvzgQ+xrYZ/i5q32vSwL8iG5zuYW8ajMGxeIC5Y48/6LZFlenyxzrHeQ1PYk6Y2XFdTV
         r7i8AnY/LW5/VzhZYahFZEhvIdxow8gq45rG5zOmUdvTf7PidSgQ8YD3WupgkazW55nA
         o2Jw==
X-Forwarded-Encrypted: i=1; AKwUvBxhxMkjsBClH5y4OWWgAwzHxqsa0cqXWIsFFiBIr5tKlPxNHx69axLRQVORZspI1CWPFKHDt+Ph7w==@kvack.org
X-Gm-Message-State: AFuF++kxlyeVjydKBlWXESKGcspYqiMuKw40b+Iz7JUEZAEaMMTS8Y7c
	/eEZdf2t+w+f0JOBdjiHTMuNwwa9Uj26tIfkdDBT3zH0/hbAU0GQ6fGyX2ipjvmcgOP6FE9FXnD
	y1Fhe+EJVRhx70z0JFg==
X-Received: from ejcgo34.prod.google.com ([2002:a17:907:da2:b0:c29:de6c:6ff9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3c96:b0:c26:30fa:7cf2 with SMTP id a640c23a62f3a-c2a157fbe2fmr84040766b.13.1789690962738;
 Thu, 17 Sep 2026 17:22:42 -0700 (PDT)
Date: Fri, 18 Sep 2026 00:22:39 +0000
In-Reply-To: <20260918002239.4024231-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260918002239.4024231-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918002239.4024231-2-tarunsahu@google.com>
Subject: [PATCH v2 2/2] memblock: use binary search to locate candidate regions
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	dmatlack@google.com, Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dev.jain@arm.com, 
	Pratyush Yadav <pratyush@kernel.org>, linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bdw7e7dnutko647kxdx94cf4epj965gy
X-Rspam-User: 
X-Rspamd-Queue-Id: 4114AC0008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789690964-377488
X-HE-Meta: U2FsdGVkX18+xyQNI+PKEJZTe98aLw1aW3PcPM6UXE0TpRwgAvnE0TxtbBoQK3MFScJhnbqk2A5zNOwc6VponzXfwI8z2rto2zvh9hnVePqUsYbor9ejR23eSEeQ9uzAW7NhZ8v90BGGNRnBbU0X2I/ewUJAdwwkn4lgG36XoeT5DPp0X3tJCSEhcokA9CZdRuK/sitPDHloMznK8jW98V93Ka7K8w3ylRpYXvEmw4yUbuwsdZI2l/hfpe4ozu6YJUs/yU3/NlO0aTlcCc2qx/ivctQodI9QMNtfEfvO1cSoIcYwd0JXdX1SaapVT4rvxAThEaR2kAntH2GcbnCvth+P3Mj/IVZOKIyekPW59nLk35PFNx9yCvCMFzazNZ8SE5IVRZvn2JKWf86dCgLqoiqzvK0vuNDyVeZDTFDoGhVf7x1XwmBkXrS+S9yG1er0a8Q44pdOLvXx6OF8/VnZV5+OLU2++XEqhH54zs3LfQEq4gOBdq3W7sTK1AIbGg40UZekW9c/scslGuesWLcd8r17NL7436HyMklGzWBRTDg3zWJiqt+9bWTyd2QRaziMycyKfDvB/Jclh+fAWOwEtijKq2zltgmxL85m+EQC43y8zTMmzsSHwrnWzufH2F/9BSnMLDizBqfKRnG8kPkcyy0yozS5nkbJU0X/DAU6CwG0TOldvHySLS+FPLTR8cTvSrBVrLUfy+1evMLhGxB6ZLfpcjkZ6XfbPN++qgyBTpTNxXnds0xzkyn89dMU2m7BZ3yZt3goouzcKafp01Pf7UGCIhrlw9oPAkLLuwM1xD8nMxuQibahJ0NNfdwTk8LTAdPDuB5F45B5um0NTexpTJceWIxnilr6+L3M0rMfhw5GdW79WCuhn/a7H8XPJI5vyZUHUcT2rK1iaHkwPL6I919AYpZyMF+GEEEZYLfHfmxbSaWbBeHVRVz8qu1jr6nSNMPggvTY476oco35v+z
 D9fc7nRc
 CS4ubM8yWfZTllVwz5TkvYBA15bYAMkt9rtPzEC4oM5Imsp88RekRD88NTFhy6aQcBgR1KwGf/w2ofZJ6/dlSmZ7YJl6xzqT6a2TVXVk2UPYMwgKTLsjp1IrQSTGVYIryFlW4FqRM8bnrn2NEEfVdckjZVZL/3M2QhjX7Bd96j013vwWgh2g6/EX1HKU79WZMe6R3VmQgvNqsLv2FDKDuvNtfKflw22wpj1NwMkkDa3JXoZQdSVhzFbRxTEQ4W6t4EzBuLQMJiOSSXF1/YKzGpI0ckQb2op0mF6I8Ni9qAw0YWUdXMu9rlBF77SEbd1swGIROwnVBvOXsvLtZ4swhgbowqbW2oQx/U3PIx47euLM7TG+0TsqSPSCIlgdGtLuaBxuf+Qd7fqBDQZKFrQi/Ce3UGo2kqPfD17yh2K8oO4CF46IPf0Jxmnw2f7DgTqrXt08duvUz47HnAJ5gc6Ia3qtiPrptUQxuh3t13u0xhY6YEFw1zFMChSZr6ihp1pG8RJadHexsASrM4YOfSzZW7/k4KzddRUKXGIDZVUm07aFZShhghfr0SZWPSNJKzSTylx5tihtzhs9EiDlW0y9lJSmKza9rl5wXKdR6
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
---
 mm/memblock.c | 53 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 5aae75d34dec..00a8768de988 100644
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
 	struct memblock_region *rgn;
 
 	if (!size)
@@ -645,8 +672,9 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	 */
 	base = obase;
 	nr_new = 0;
+	start_idx = memblock_bsearch_start(type, base);
 
-	for (idx = 0; idx < type->cnt; idx++) {
+	for (idx = start_idx; idx < type->cnt; idx++) {
 		rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
@@ -810,7 +838,7 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 					int *start_rgn, int *end_rgn)
 {
 	phys_addr_t end = base + memblock_cap_size(base, &size);
-	int idx;
+	int idx, start_idx;
 	struct memblock_region *rgn;
 
 	*start_rgn = *end_rgn = 0;
@@ -823,7 +851,9 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for (idx = 0; idx < type->cnt; idx++) {
+	start_idx = memblock_bsearch_start(type, base);
+
+	for (idx = start_idx; idx < type->cnt; idx++) {
 		rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
@@ -2064,19 +2094,10 @@ void __init memblock_mem_limit_remove_map(phys_addr_t limit)
 
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
 
-- 
2.55.0.1082.g2b9226bbc0-goog


