Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2373FC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302B36B0098; Mon, 28 Sep 2026 04:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB176B0099; Mon, 28 Sep 2026 04:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0586B009B; Mon, 28 Sep 2026 04:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8FF16B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:16:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F33716011A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:16:19 +0000 (UTC)
X-FDA: 85262463678.19.01D1ECE
Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	by imf01.hostedemail.com (Postfix) with ESMTP id 696AF40006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:16:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pDamGCxk;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790583377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVf1K+OodsGw2IagwVmR/pQfDUE65PGs3da7DlWeLBU=;
	b=htTwULbpmUjwYEDRuZfjHffjdbDUbMDPnL0TjZ2wv460jlUU6f4aRa8cgrgIUSf86TH8cQ
	5e3W7C47BEvwxH8dAvHTtFhdzT1jt7cH9JMYscqH+CcPWznnPnDpYCJs49+dgTz8VZogKV
	fh9dUTVjAbM61Qs3XAPzM8dL6PIwLrU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790583377;
	b=llltQzqite8ktHkifneHASzWSKOAsSFPcO8NzKqWH1bNPqzVavr+NeNiGzTifuO7a+NUtz
	dkhOAoOWdfDTsENbKBzs1diTk9A683/X37otKeV76CrE9Jx1El4JbVrMIhm3beaxO25Xzn
	UOe+OJyvJSdLBVW8onyv62lbY2aQpZ0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pDamGCxk;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=K5Q3pCElJ1kYWoQWSMWmJuaeilGdZ97iIqv2nF2D+kg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790583376; v=1; x=1791188176;
 b=pDamGCxk5Ut/v2RRK9TMQllPrxJPqXYPyKesBGjPrlyOF7wT/tFvfgdTy27R2Qfx24TyfVrk
 ulGkkHhMk8J4fT41QFhPUjM1o2sVuRCI/MdLLOhOH/zzioiEY+KN9pfvc1L1G6WG2e+T3zoy24I
 8s79t0dZiwRQWs8jmHvJayQ4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ef3d12d70e3ed8e3;
	Mon, 28 Sep 2026 08:16:15 +0000
X-Mizu-Trace-ID: ef3d12d70e3ed8e3
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 28 Sep 2026 16:15:55 +0800
Subject: [PATCH v4 2/2] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA
 lookup
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-vmalloc_dump_obj-v4-2-6f288a431edc@linux.dev>
References: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
In-Reply-To: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 696AF40006
X-Stat-Signature: xpas8q6hporg1tb9saeyzgw8w7z9j4ex
X-HE-Tag: 1790583377-347735
X-HE-Meta: U2FsdGVkX1+3wUVdE3qnP55t04BZa0TOyuup9lbkuqHnqgW1SP8q6bQmupIrRxF5tscubDGY3PiiNAjRkcvj3D8pQgw3xG7ShYm5bYKLMIqIgz3by1HkS0eoULk3Z01o9phLu2CBnezlkIEgxES6BlQV7U6fP1IFym1iRNhOsrJe9FlJR3DLEv/pit3+7kxbXyroKpDWuG9CtFziOjhHMRr5eRg6Vg90vyiZ9jM8fg2yGrnKG54lKz8XhUDeRrRy0skXHzcMQ38p2uVmmIIF/sHztgQc3K7OpwZ3mZz0UgdciPLcLimiPEHCJ6x7gdqTXL+YmZN3Ojs7DVxcygRxwgZ+fSLR7mpw/AxHhhXhPzcjLPiICH0sEie/AOIU9AjjXrNgYiPnTQITGHAKQ0Og4zCYeVJp2KmItUad6pB/IsPZlJchZKi6t13C/eMjjKF/3frEGl0x3eivwmUfvqoEXPhQjVdJFh5HzZmpMpXn66QMEUOg34dwq3Ol6c5cyua38bhAyG8E+iRtWsGTdvnEOZ2qS3FZ5AvItsQ3X6P+Bl1AkYR6HH57S4it5WuWPou1dV7QonsATMXx6jiZh4oVbOJIehzf2cVztIrKOwz4gSRB0s0LyIe6MmxFhkPvZZd3RP13xB9ZxljMuBoyys+qebanKa40GvAUVlxrF9aTK838iuzSQKZqSXUMtH/2t9skMGoct5FwOa6JUGeKaHBV8mZjf03GLdPrS6skl6gO2SAfm3Coy1qz4ovxHPreM3QKXWNoI1ywKq5Vx4EEFKIpmeq3MzJrrXX38+Cc8d3gLPMCq9qpxaIkrp8h3iWQr0QbjHnUmHnSBhWfrJAN6WZTml6kSR3ki9mbBAqEVh2Xms2pEunV+I4pKkVaOeFHfVYLUf10vkfsHqfa8njgWBuPGVHfIUalFeEJSv13Q3x/3VnBDuJTf+C18nhABcAe7oX8GxKVqzbe6ZHWglfZnMT
 Y9tP6bIt
 h1fG02WA1pXVPxI20vjsYLHXM1gVNPfEFTUs7RD8mMS0Oh9C7ri7s0OqZ6UbEl1lO/IppaBtCrDopIGdtCyk1wZ+n5bBwElJTQrt440U7eOLuyzbf1ZhnDPqm4grnKVwP2jxLjeDALl/OC9DSFo4RZ8L84vCxqNoOLpQ3aLwpskqHHpSym40N5otZo4dMMfSC1rd7VRKeFFn20D/AcnnLTiPuMhAK2OrDih7PD1dZPfVyP9FTSQR2cwIH/WAOISpW2E/0HmlUIJqrKK2jJWjDMCdzRIgrh4prpFl0
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
 mm/vmalloc.c | 108 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 42 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index df42d8a6f058..4f4d7453962f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2517,67 +2517,94 @@ static void free_unmap_vmap_area(struct vmap_area *va)
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
 
+	*locked_vn = NULL;
+
 	if (unlikely(!vmap_initialized))
 		return NULL;
 
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
-		va = __find_vmap_area(addr, &vn->busy.root);
-		spin_unlock(&vn->busy.lock);
+		if (mode == VMAP_LOCK) {
+			spin_lock(&vn->busy.lock);
+		} else {
+			if (!spin_trylock(&vn->busy.lock))
+				continue;
+		}
 
-		if (va)
+		va = __find_vmap_area(addr, &vn->busy.root);
+		if (va) {
+			*locked_vn = vn;
 			return va;
-	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
+		}
+
+		spin_unlock(&vn->busy.lock);
+	} while ((i = next_vmap_node_id(i)) != j);
 
 	return NULL;
 }
 
-static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
+struct vmap_area *find_vmap_area(unsigned long addr)
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
+	if (va)
 		spin_unlock(&vn->busy.lock);
 
-		if (va)
-			return va;
-	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
+	return va;
+}
 
-	return NULL;
+static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
+{
+	struct vmap_node *vn;
+	struct vmap_area *va;
+
+	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
+	if (va) {
+		unlink_va(va, &vn->busy.root);
+		spin_unlock(&vn->busy.lock);
+	}
+
+	return va;
 }
 
 /*** Per cpu kva allocator ***/
@@ -5278,14 +5305,11 @@ bool vmalloc_dump_obj(void *object)
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


