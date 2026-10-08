Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63DDCA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 19:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38ED66B008A; Thu,  8 Oct 2026 15:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366106B008C; Thu,  8 Oct 2026 15:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255A86B0093; Thu,  8 Oct 2026 15:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0259B6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:08:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AEE41C33A9
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:08:35 +0000 (UTC)
X-FDA: 85300395390.12.A24BF0B
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id E113B4000C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:08:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SaY3GHOj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3MOrHagkKCIEyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3MOrHagkKCIEyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791486513;
	b=uWkAtbv6Pqknlw9Ls6/xEQRlEDMvmXyJ+EIXMXO/LBOOubgLz2lh1Mr95JJlbzAHMcjXD6
	bk544KJntvPJPYkIbk9foSgzOdDuQygVzvWwW2DvskJJV19F5Gu0lcG3bap+qdF1L09aVc
	aKdkRgySDAQJdRmZmMQeLknebX/Rfzo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SaY3GHOj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3MOrHagkKCIEyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3MOrHagkKCIEyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791486513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7HbPFLbPRXHp9XhuAZ/3vm7gntFtncf0PzNuO46BI0=;
	b=gvxcNnKqn2RQysB+GYxRJCXarIXdmyj4v79HYQPGB9Gg2HX5yMBIV3WG40qJYPVbTGarHS
	jco2ymuDp7Hxy0nAGcRP3SC7qvxEG6E13OofFvAEn/RhYp9l7Qp0Sue/jwZwkPyaWn/jts
	Uhu5Bt0NdE7J+9P5ExLjVbdqhUYnWoo=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a99c6e4d78so1358094a12.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 12:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791486512; x=1792091312; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p7HbPFLbPRXHp9XhuAZ/3vm7gntFtncf0PzNuO46BI0=;
        b=SaY3GHOjDSuSS+koKeR3iR+QdswAWutXrelJBneCduGp46HV3jnY9tPzdh6DCgv7Sl
         E6baP/SRE/DEIn24uiLioPGIYAinuKVxPh57Ks/fELGot+tdMK3bfF82i9+v9sUM7ezh
         /rwa3egI5AyAGLzcl1v24e/a/ErgpSm7rM32ZXtsqzabaIJ0mA+UOQq78mZLCljR+TgB
         dPgwS+1NrtJh/UYPR12Klt2nMQw3cGgoRelFHLZinD53EMVj2tNz/scnoYAgNoV3qoF7
         Vb/SPuZ5V+PmRrucwCkdVfk3Z8EPU30PsLhyInRxFckAzWhopQt0ODWLyRRqgyZ1YC/n
         VCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791486512; x=1792091312;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p7HbPFLbPRXHp9XhuAZ/3vm7gntFtncf0PzNuO46BI0=;
        b=dLEH8/pJvtRaNS236qKOUxk3Z0wr/ZIhNF8ao+93din10ws27wLQ8IKeSaTARi3zln
         r3IB3gdvY3afr5wQEbEelcihwivt0TYsDU0XfltOHRFKwD2CuYbT8ezli3vR3HA8euK1
         aZRAz8kdlv3NTT0qjoqlBizj5Pw1yhtgypN2UIryvPkzk5rS8HPoKo0O8cM3GzP6MQvc
         ZdfF3ERWzVhyiBj2Z3rUTGA+zPhEzktLMdHxhUic7VqRZkpC4eB9fSw8wsaNUqrpS+9l
         FBBuURkfUyQryuSxDgUAnmJa6lgjjW2JE8v5dORub+GkUMn9uJBI4pnvCBi7xaZZ7J/4
         Y6lw==
X-Forwarded-Encrypted: i=1; AKwUvBy6WqakXAGFIS5/MU4xY39rVJn5UohkfQ8v/VsdXuy7y51B0VNR417Qzm74KVtL0y3uLKEuHn7AKg==@kvack.org
X-Gm-Message-State: AFq9FYJi0vYY9BD36fEMQwYs8X/bk9pzzuO0qmAfRXlO+YT4jdSWdAkY
	XJv6gaP49JntDZq+sxcOggfiHE74x5JZrUwZg3E0hilqQgOYTqGhFQjzp0xc1uGxMvehYMLdcJ6
	xGNE7NkAexM4WfVPo+w==
X-Received: from edbgy14.prod.google.com ([2002:a05:6402:5bce:b0:6ac:b91c:a379])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:50c9:b0:6af:a270:b2a7 with SMTP id 4fb4d7f45d1cf-6b0118ea2damr3315575a12.0.1791486512418;
 Thu, 08 Oct 2026 12:08:32 -0700 (PDT)
Date: Thu,  8 Oct 2026 19:08:28 +0000
In-Reply-To: <20261008190828.3221718-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20261008190828.3221718-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261008190828.3221718-2-tarunsahu@google.com>
Subject: [PATCH v4 2/2] memblock: use binary search to locate candidate regions
From: Tarun Sahu <tarunsahu@google.com>
To: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ni9f4dcno7tqurqhj1egwdpfap478et6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E113B4000C
X-HE-Tag: 1791486513-51123
X-HE-Meta: U2FsdGVkX19nRDuu3mmqarTFbFXsQOfQMM1I6TA6Y6BrgUkoEj1DnQJXhTv+LUbTjZ3Xq0AfrjXF7yJS0e4StFxvojXil7oi2fptXaVPgc//y/ys5oo9Q4D/Tle8aW3sYUaJ5u0ePiVGQkNaenSEo4p0EJPmqdZgrJQcQ8/bXJ6hZtNpouaULRSfdJ7ose5D/lgNQHbNRApAk1QLM8wXFC6gCid5VvC0HTB1vzH5nkd9Hr1Yg+WdEF/U9MBxolDtS0p3rs0cLEW08mT2aGA5VaB0DhokMIua073OKMxDKw6zwIgV1sfRK0KhihdkZa0sMUrGTx8sxLqXF7Y/irpCxHXKp9X0kB9HVhyVar4w37K967Scsxs8n2spdlDrEQeTOes3jSQfydTa3G6mT+AAoZv1ESpBq2grp/woPe/lA0mLIl6eOt1vxuVsdm6tiUvTdjyfntf/w9ET7AuGv3dEggHlEC/yCXw8jh/gPauFEyUOwQbzlNSqJU5741Yzv0dhD5CiPOh8YaWOnBTTA85uVAMctXtXaFXFklSsjui0UjATns8U/YdLy5OgEfeFpi98pWnz64JdKC+CkACfl4O8g4XdFuzt99je0evSTGLUtnlLmA01RgSVq1TMv9WekxcTH1RLbtbWqmrLYZa+rNsFz+jhDef8xiHT1mSNOy4b4tim5Z3kSxisIxOO9/zZC3bHwyMF0TgQtVn3W76HvYzTeyRXZemeH+x6g5BDCsIz4JIPYT6F/Eind7fLuYvYx56mLf0AYwbMYvU1GjGmo3K/w09kqk5GlfZjpH06VWK5jfo6leJSszVrPSq5bNOxOHNkjoDoMf14DAYfndso821QnhAbt3iNaXQi4eUsizT/n80CrYlIwFoafxH5K9jm2A5XCvX3yyUnA4CICqXVNmQCdPxlTDczrYgB8qfFSCrx2/2jagz1YjkpVz8i3b9coFXLTwn4nBdoJWTjMEhtrMm
 lEg2gHt7
 JiojAqX0dCBNsg1gM2385K28pawsCUX5aaCDZ0wBVQiRhiYnkWGoR/mrFA5q49DBAl2CBOII4IlxMsUp3UzO/l5sI4V5SShNYSTqxTrnwhMnnOfDgrNSRQowG1LnjNbAoGM2H9rY+Liv0qXcMxUf+e+5f145CyHlgGgGMyf6/gHuHJ/xqGeGXjChdYlac1BS8F2OvkwLzGCZnjbIXPjru4AO3lX245ffrXNniBc+hJcDbo1G3dO+YrWpcmrVPQ7QGrT4ruwBttS7Rtjovqtus2zIQWQz/EYTfxK01lPMRnzLRH14uGIhydC9rrSHvWmQsuPe30zXA8XSR/ALyIY7sKl5PkJKbqICUAhvZ1zG1F3v2H5ZWYaOzbVFOyrVdLV/X9yRiXLrAccbkyePqqhPvBHmW5k/WHnV0g3m9RQQGAzd5E8Gc7OVZkN6EGf5C3S19GUU9DUVQfHCXaSg3rF75WULeHJ07YYt4EeqSd8iudGYLL4R+C5iVcswWnLHrrnRvXZkFIrJwvhzHvb3RVesFuoetRC+lkEpTvPBz8p5h3lABRGsZeiEZgZyeWe1VxERsSprmr4e0QPrSvkZ56ftbfhQkx+8QK4UVcNZpX+XCPPHdHnO95Ac7W/sI5w==
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

Using binary search reduces the candidate search complexity to O(log N)
(from O(N)), cutting KHO memory retrieval time from ~268s to ~50ms.

memblock_search() open codes the same binary search, so reimplement it on
top of the new helper.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 mm/memblock.c | 45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 59dda7d085f3..614d0a55dd70 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -586,6 +586,29 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
 	type->total_size += size;
 }
 
+/**
+ * __memblock_search - Find the first region index where rend > base
+ * @type: memblock type to search
+ * @base: base physical address of the candidate range
+ *
+ * Returns the first region index that could potentially overlap @base.
+ */
+static int __init_memblock __memblock_search(struct memblock_type *type,
+						  phys_addr_t base)
+{
+	int mid, low = 0;
+	int high = type->cnt;
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
@@ -644,8 +667,9 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	 */
 	base = obase;
 	nr_new = 0;
+	idx = __memblock_search(type, base);
 
-	for (idx = 0; idx < type->cnt; idx++) {
+	for (; idx < type->cnt; idx++) {
 		struct memblock_region *rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
@@ -821,7 +845,9 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for (idx = 0; idx < type->cnt; idx++) {
+	idx = __memblock_search(type, base);
+
+	for (; idx < type->cnt; idx++) {
 		struct memblock_region *rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
@@ -2062,19 +2088,10 @@ void __init memblock_mem_limit_remove_map(phys_addr_t limit)
 
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
 {
-	unsigned int left = 0, right = type->cnt;
-
-	do {
-		unsigned int mid = (right + left) / 2;
+	int idx = __memblock_search(type, addr);
 
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
2.56.0.385.gd3acb90ef8-goog


