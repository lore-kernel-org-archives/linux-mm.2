Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A59C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE6F6B009E; Thu, 24 Sep 2026 04:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67F36B00A0; Thu, 24 Sep 2026 04:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930F96B00A1; Thu, 24 Sep 2026 04:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EBE76B009E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:52:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF00CA02AD
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:52:02 +0000 (UTC)
X-FDA: 85248038484.15.65223A7
Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3ADBFA0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:51:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BhFgSU6x;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAI8SybEfXeShLfAowqsqXI375ce/B9OJKBkJkJLtqs=;
	b=RRbATZo9jD+RX/NU3yMcLHg/fsP9HzEaXHwdNsb6arztwRKzFQz1BLo1K8vlFgmhi4pX9e
	VhCg2mUf7MLVaLZ/HGM6l1CKhCglQf0X2W0yl+cMksnS3BM4SLpmfyrEnVgG0saRfoOAFk
	cBtlX5eP6/2zl8YmS7R4QYYmX/Sc/+g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239921;
	b=QgQw6Oug3WtIbslfpHkziMDRk7DHGodkY4pzsREkD2SKvjS8N2Z1lTc9FT5V3zJrSPFKcC
	UshxI0jBHqRF+gEDxOsIF5+NDXlttNiZTUJvbokx+f3ZdQu0B1VoWaxbTIygdVwCQaviU1
	HK3uEaTrmMEjcsufd10MiS+elYGwVU8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BhFgSU6x;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SSX9xIAupprnWjWqUwH2oYEZRlvMUWqzHUN8lhagogw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790239918; v=1; x=1790844718;
 b=BhFgSU6x72wnDos1k2qf6Fd9lM1UlkPIf4CIWWmHLJt7j/fJqj6dWrgEuE72JmEnf9OHrR+F
 kEukD5SkxDpC607CU2XjUQygInZipl9G3Gbx5Zo3kT7RiwH0sI79Z++bonMUUDKAiDkyUmMbN31
 VCGxdOzEQoiTuFnDpxkCzjco=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bf2fbf69d3d2174c;
	Thu, 24 Sep 2026 08:51:57 +0000
X-Mizu-Trace-ID: bf2fbf69d3d2174c
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Thu, 24 Sep 2026 16:51:40 +0800
Subject: [PATCH v3 2/2] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA
 lookup
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-vmalloc_dump_obj-v3-2-5bdee3da37b3@linux.dev>
References: <20260924-vmalloc_dump_obj-v3-0-5bdee3da37b3@linux.dev>
In-Reply-To: <20260924-vmalloc_dump_obj-v3-0-5bdee3da37b3@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3ADBFA0005
X-Stat-Signature: snaxui4os8yqwp5fe5jymex46kyzs9aw
X-HE-Tag: 1790239918-399064
X-HE-Meta: U2FsdGVkX19D9fnWhVkA3RLp+K0IoGa37K+tn8sj9nryyKC7AYpQAqoHFU3B/prk7rxJKAqkAlXceXlWijPTkTnVFazYFeiDfg+S/Ce2/UGGrY55AWUi67LS8yB3fZ67N9KTMzXiWZ4xZ9WY0mLN3qq1dNlZoOg/6e30X1Pbt67hQwkiR5WXMqGZbuCiVTP2CCeiYBKhiFsAyeDoD7FUQXaseggIvW27Qh8gPVViVc7pgGzqFf3bFjLeKCB8K/6Piadcub5zIy9lvE7HXCJdufDzIPeqw4G7PrpxsReMNEur+iKD3WRVvU+FJvARtafT+pb9onExbQgQ9sQNqGJWC9RVZXrTrUg4d/lzqxFK1wBjUf7xlSsACKKdzQRT+JaS+uNC/U+kN9ngyZX7igrwZFeCxskqqNJNhwRHsEn+Mb6rXFU+jZMTzWo66/qAmy1fRUwhcru2aWdcxSHEwhHtG9/ziYmIOMdBCINVpJYS4O0K7nthCjxDv/EuKfsLlUYNEy2pSgGpBYEW0PksiflvNjz/U1fUVt69A7Kdan8Y5UYBk4v1FPxs7d4QASFI+I3HcGRuX70OBGnW1/Q04tCPV4ofiZURsNPtrjE5KeeQaydR50xpDXWxChj2WpqGZUZ2e+bnnGkQr5bFrt7eV8OTPH2pNSIjEs0DbMhdcIYLlWTy0R+C2vwzK4j8WtTlh+TKxPyUJ7CdJUObRnrVzM9BtDDdGGUMBE2GefiXUJk7KU+kU7lMeN4964RG4tFm3MnsqYXJABSl5RyUBV+FY/xlvXdbaGpJolquUBksd4J83X3oY3qKwgyP9FhJS2YnVd411Z2WZZj3LpThBri4avZnbOxD5WZ3dumgXG0Vqg0TeXwdYKT2iM4/jDlkSesXArLWDZ2VUeGGclA1en/KwH+K89WE7BbzYKrWOUj8y6U/fiEeupd3F6MLHJAA09K9fxYQiVL/Ay6TIhMppzKoMac
 4AyUxpUc
 faMQbrwPIpXjbCoJKG3qeXdZPS8yXLMOsyMzt/LL4Y7aInxKKqNjtXjGEJ6FRfNg8ja6q+O1mV+VuL43E76yrV2fkMtKMm8pyRqlOmDMuZW8Z4KGtTmUWIeAqCeBs8vBq9fr8qywTZeRV7ppbAtldb3cab2NJ5mGgywT4UePHL0u6IsbiNlgrPJe4dHYJegYFqdDJl/8KYnMhVnJaOyTKOvtGbi9/r+6zwGFuPsUJhvuXieJeuHZZBMsmr24fv7K/Xe3MZaHcU3jIge/3K4fPd/bwbEfBPhtMI1Qt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

vmalloc_dump_obj() searches only one vmap node (addr_to_node(addr)),
but a vmalloc allocation may span multiple vmap zones.  The VA is
stored in only one node's rb-tree (addr_to_node(va_start)), so an
object pointer in a different zone than va_start maps to a different
node and the search misses.  This affects any allocation larger than
vmap_zone_size (64 KiB) on multi-CPU systems.

Extract find_vmap_area_lock() from find_vmap_area() to share the
cross-node iteration logic.  The helper supports both spin_lock and
spin_trylock, the latter for atomic dump contexts (OOM, KASAN, RCU).

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 111 +++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 42 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index df42d8a6f058..e5b465de1559 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2517,39 +2517,81 @@ static void free_unmap_vmap_area(struct vmap_area *va)
 	free_vmap_area_noflush(va);
 }
 
-struct vmap_area *find_vmap_area(unsigned long addr)
+static inline int next_vmap_node_id(int i)
+{
+	return (i + nr_vmap_nodes - 1) % nr_vmap_nodes;
+}
+
+enum vmap_lock_mode {
+	VMAP_LOCK,
+	VMAP_TRYLOCK,
+};
+
+/*
+ * Search for a vmap_area at @addr across all vmap nodes.  An
+ * addr_to_node_id(addr) converts an address to a node index where
+ * a VA is located. If VA spans several zones and passed addr is not
+ * the same as va->va_start, what is not common, we may need to scan
+ * extra nodes. See an example:
+ *
+ *      <----va---->
+ * -|-----|-----|-----|-----|-
+ *     1     2     0     1
+ *
+ * VA resides in node 1 whereas it spans 1, 2 an 0. If passed addr
+ * is within 2 or 0 nodes we should do extra work.
+ *
+ * Returns the VA with @locked_vn->busy.lock held; the caller must
+ * release it. If @mode is VMAP_TRYLOCK, nodes that cannot be locked
+ * are skipped.
+ */
+static struct vmap_area *
+find_vmap_area_lock(unsigned long addr, struct vmap_node **locked_vn,
+		enum vmap_lock_mode mode)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	int i, j;
 
-	if (unlikely(!vmap_initialized))
+	if (unlikely(!vmap_initialized)) {
+		*locked_vn = NULL;
 		return NULL;
+	}
 
-	/*
-	 * An addr_to_node_id(addr) converts an address to a node index
-	 * where a VA is located. If VA spans several zones and passed
-	 * addr is not the same as va->va_start, what is not common, we
-	 * may need to scan extra nodes. See an example:
-	 *
-	 *      <----va---->
-	 * -|-----|-----|-----|-----|-
-	 *     1     2     0     1
-	 *
-	 * VA resides in node 1 whereas it spans 1, 2 an 0. If passed
-	 * addr is within 2 or 0 nodes we should do extra work.
-	 */
 	i = j = addr_to_node_id(addr);
 	do {
 		vn = &vmap_nodes[i];
 
-		spin_lock(&vn->busy.lock);
+		if (mode == VMAP_LOCK) {
+			spin_lock(&vn->busy.lock);
+		} else {
+			if (!spin_trylock(&vn->busy.lock))
+				continue;
+		}
+
 		va = __find_vmap_area(addr, &vn->busy.root);
+		if (va) {
+			*locked_vn = vn;
+			return va;
+		}
+
 		spin_unlock(&vn->busy.lock);
+	} while ((i = next_vmap_node_id(i)) != j);
 
-		if (va)
-			return va;
-	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
+	*locked_vn = NULL;
+	return NULL;
+}
+
+struct vmap_area *find_vmap_area(unsigned long addr)
+{
+	struct vmap_node *vn;
+	struct vmap_area *va;
+
+	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
+	if (va) {
+		spin_unlock(&vn->busy.lock);
+		return va;
+	}
 
 	return NULL;
 }
@@ -2558,26 +2600,14 @@ static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
-	int i, j;
-
-	/*
-	 * Check the comment in the find_vmap_area() about the loop.
-	 */
-	i = j = addr_to_node_id(addr);
-	do {
-		vn = &vmap_nodes[i];
 
-		spin_lock(&vn->busy.lock);
-		va = __find_vmap_area(addr, &vn->busy.root);
-		if (va)
-			unlink_va(va, &vn->busy.root);
+	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
+	if (va) {
+		unlink_va(va, &vn->busy.root);
 		spin_unlock(&vn->busy.lock);
+	}
 
-		if (va)
-			return va;
-	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
-
-	return NULL;
+	return va;
 }
 
 /*** Per cpu kva allocator ***/
@@ -5278,14 +5308,11 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long nr_pages;
 
 	addr = PAGE_ALIGN_DOWN((unsigned long) object);
-	vn = addr_to_node(addr);
-
-	if (!spin_trylock(&vn->busy.lock))
-		return false;
 
-	va = __find_vmap_area(addr, &vn->busy.root);
+	va = find_vmap_area_lock(addr, &vn, VMAP_TRYLOCK);
 	if (!va || !va->vm) {
-		spin_unlock(&vn->busy.lock);
+		if (va)
+			spin_unlock(&vn->busy.lock);
 		return false;
 	}
 

-- 
2.25.1


