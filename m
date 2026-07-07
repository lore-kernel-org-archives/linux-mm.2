Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23657C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5E16B00B0; Tue,  7 Jul 2026 08:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E1B6B00B1; Tue,  7 Jul 2026 08:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6306B00B2; Tue,  7 Jul 2026 08:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AED4D6B00B0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:16:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36C96A03FC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:16:10 +0000 (UTC)
X-FDA: 84961877700.09.DEEB9A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD8E816000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:16:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VkNEMYlT;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=n4sdMnJR41YXbGd+HYc7S2MYj2TSWOvClmJSzjoaf1Q=;
	b=oBge7XBKBhgnN8e2UvVM+hb5K6T72BXQDnnbcHqKFYPOXeEd/qXoqihmDWY6cn0PK8O5zS
	5+bLODguZLT5xahxl+gxkuGT/VFdGRl4F+ZYhiog3k6s2tE+R4JVgeAfn2zAgMTfo/To1i
	Cb45yA7p7e8X81LYeBpoJyzqmDJzDC4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426567;
	b=WNM9F0ivl6g8shHNtt0a1tSmfw2sXgMubZzq+CQieFsLpoX2ePW1xel7MbxWDICS8iYTjl
	Dsoxk4ycj56FbNzmrdZrA54wrqxGPR0K63tZqtrFmfAoulytyuU9cPTolwPlV9YgqD89mj
	did+yEv7bQZKKU6w8rsuhgXykFdCDvU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VkNEMYlT;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 434D7618AC;
	Tue,  7 Jul 2026 12:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAD21F000E9;
	Tue,  7 Jul 2026 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783426567;
	bh=n4sdMnJR41YXbGd+HYc7S2MYj2TSWOvClmJSzjoaf1Q=;
	h=From:Date:Subject:To:Cc;
	b=VkNEMYlTzNDX0oRswH6ukx9qm2Cg3vUZCE1y0XEdAqEuPRJkWMD0c7F/qmLvQFJL5
	 HQtz6tG3jF8x6jQfScgACnd03nxq2ApQ1W4npyfDgbe6APpJtRj2b2lZhLBRZ0+HJc
	 VlCowYKGW9b4QTaMEr4bvbkoQe7rKLhk1C1n4EfEvNOy8c7DYSXbUdgVqvRoEI4SuH
	 mPmwUg1SU3ek1rvRD4kbhoeuHxL5XJ593VBqCgEzqKMSJt3D7YP4YGGCQuZnF91xIX
	 Q+FdfEzT97jbzxpqRS1pZapYosKbEhfsA+hpdf+g17f27YvSLIYtxRnxjxi8hZxLBz
	 /JKTtsTuB56sQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 07 Jul 2026 14:16:00 +0200
Subject: [PATCH] mm/slab: extract __free_to_pcs_batch() from
 free_to_pcs_bulk()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org>
X-B4-Tracking: v=1; b=H4sIAP/tTGoC/yXMQQqDMBBA0avIrDsQRYz0KtJFEid22lRDphZFv
 LvRLt/i/w2EEpPAvdgg0Y+FpzGjvBXgnmYcCLnPhkpVjdJKowRjUfgTA/sV7RzeGJ2gaXtV69Y
 T+QZyHBN5Xq5x9/hbZvsi9z1vsO8HG0lownoAAAA=
X-Change-ID: 20260707-slab-simplify-bulk-pcs-a8d0478feef6
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Shengming Hu <hu.shengming@zte.com.cn>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4953; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=1Ct2VqkmkFG/EMqePDVoh4JMU9Gpsxh8xQ3nBhR8dKE=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWT5vGPad95ix6HD1z36NxwzL5efn+Nj4FGjJDhlzdVm7
 pPiEif/djL6szAwcjBYiimyVO8+4Sg6U9ljmofvR5hBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 zxDI0DFi4OIUgKle8If9f0najHf5X8+5ZPXuDNjpOlFxkoii+EXrrGBNrqaju0wv3FaW25fjm5L
 +xnbCoUNlXEt2/9RWXTdPpvrWtgXrFBjaujcyid0Vat/cZCfPxB0jKCdwmVfgxXTBHDfO5SKPt1
 y/UHZvH8u3U0dvcvPy1K8/oPyuKDHd+EN21wOeSOdVPvIHlp5fVXkzfKvVJ7XmnT7V16/wXOBW9
 c40ePlyQc+qwJdXrwrPnGi/t9wseuL5pW9mv5+5c33bioruPRFSK9/xTHr4ajZvavBh62PzxaP3
 5KmZ106QPvFUPrCQTX+roUm2/859VvcNY6cFpO7RLXSYN8WEw00uOeLVxqtNoSXC/L+FZIoZp9j
 /Xmf1HgA=
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CD8E816000C
X-Stat-Signature: edm66kjj3488o9dykhbc9ooiaz48pgta
X-HE-Tag: 1783426567-286022
X-HE-Meta: U2FsdGVkX19fB8+abVx7R7WWoCsFLlKO4rPq+yCT6BoYS7jfQ4ANQ9l2jMAyx5ADM66V2uqfV7LEIv4m/Ho+IxZk9euh6rw8uKZmUysf1eV/UpP1XAyAyFTYLc6a5MNgwq1QFWyPMYc+S0ykGmcojealyDT88ue7GwsKNop1qYGlHi60wZJ0ZFiy9uXSOois1ywnR07FqLO5nq77AXtsXGmocYg1XUvFE9Nv1Zgd4o52/htbcQTPrmidgP6Ws5DL6McCDhlQCs3lBZeniIc1aepbrF6Zx9+W2YHpBXNVQ75cGapmrrhgKxFg42QoEYj4h9p4heqQfF3i8kL4ny+TYBETM+2kZBz9v+Q3C7WA8d+TeU5e+SNsF3tGlH4fcEiUX8FYIwzzPycGorNr48tDLza71t6yUQGxvDeK6PfH0M2CG2ozvYGFTI4nXqo7DcEwyw0jAISR5D9AHYnuWLcQY3dXkHYxfgW/tApKP567ZYFePAiNEZogisIBYXLfMnr4bwy7SeSeMwYS8rQYHUSSeRjzwfy5jNvVT5Zx5bgLuImhdm7F6hujgnoEjwHhiXQtL5+tVUqZ0C4zAvjIdh8RMUbxCW5yrum0n8Z5/1NPADN6ycDWU3NDG3tZgOtcSsKWcXpXvajkn13Iuiffuru5Lin61JgaAtHJv5+Iw/eS3XAT1xJEQTYgxg+GNBo2e3TwN4mifwwxiF+v0UADSGRBMa4p8kvCEnhY2lrEU2jfzalQxJnvEpadLz4E5kYOS9P/+EUUjpOjyWLi1qTOEHhJV+2j4vsH79zdhINN8e9b6R1AB9z/FZ90DSqBfiPaHZoV1ZFtpn1AKkfyaJsykinB/6ZmLyC19xGVo601S+0H6oRqwFSIljdafAceaIFO6fL3NtBD1zvYjNHxspXnY0PBpoxiJ1mlmWVYWka0pgcc6Ak3on/2+MHpsWqZaoinvGR5lr0mmK/kb55sp2LxN3z
 khi10TLM
 K0iIM8QlgJYMvQe4pLnw5PDt8b/t1aftCByzasXbI4o8H24dkHFWEYkl97Ct8iGcNFj/NNToKQek6c1TWv1rOJyNwYpa/E39tKQK9kZpqImDTzKyF1zTqUeIK7QnAh0lJoJj+MBO1JqCHRMX0eWEDKk/Uf4lhQixEgabbiUz2tXtCVhLiass/l5fzQ41jAS696HNk47EsO5HvLNjXcZ3Hf0BHD2FyClkvkYNqXeuDQND99po1O52Qet1P6sHjm8UEhvrSPzGzAZQB07S396KAio9FAbPW+5piJqXp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It has been noted that free_to_pcs_bulk() is difficult to follow, with a
number of goto labels, and this has contributed to two memory leak bugs
in there.

Extract part of the code to __free_to_pcs_batch(), which focuses only on
freeing free-hook-processed local objects to a percpu sheaf, and
returning how many were freed. Zero means a trylock failure or no empty
sheaf available, and thus the caller should fallback to
__kmem_cache_free_bulk().

Make free_to_pcs_bulk() call this in a while loop, removing all goto
labels from the function. __free_to_pcs_batch() retains two rather
straightforward ones.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
A followup refactoring to Shengming's fix.
---
 mm/slub.c | 116 +++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 61 insertions(+), 55 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 65febe957886..3f13f497aab4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6203,51 +6203,21 @@ static __always_inline bool can_free_to_pcs(struct slab *slab)
 }
 
 /*
- * Bulk free objects to the percpu sheaves.
- * Unlike free_to_pcs() this includes the calls to all necessary hooks
- * and the fallback to freeing to slab pages.
+ * Try to free as many objects (already processed by free hooks) as possible to
+ * a single per-cpu sheaf.
+ *
+ * Returns how many objects were freed. Zero means failure and the caller should
+ * fall back to __kmem_cache_free_bulk().
  */
-static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
+static unsigned int __free_to_pcs_batch(struct kmem_cache *s, size_t size, void **p)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *main, *empty;
-	bool init = slab_want_init_on_free(s);
-	unsigned int batch, i = 0;
 	struct node_barn *barn;
-	void *remote_objects[PCS_BATCH_MAX];
-	unsigned int remote_nr = 0;
-
-	while (i < size) {
-		struct slab *slab = virt_to_slab(p[i]);
-
-		memcg_slab_free_hook(s, slab, p + i, 1);
-		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
-
-		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
-			p[i] = p[--size];
-			continue;
-		}
-
-		if (unlikely(!can_free_to_pcs(slab))) {
-			remote_objects[remote_nr] = p[i];
-			p[i] = p[--size];
-			if (++remote_nr >= PCS_BATCH_MAX) {
-				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
-				stat_add(s, FREE_SLOWPATH, remote_nr);
-				remote_nr = 0;
-			}
-			continue;
-		}
-
-		i++;
-	}
-
-	if (!size)
-		goto flush_remote;
+	unsigned int batch;
 
-next_batch:
 	if (!local_trylock(&s->cpu_sheaves->lock))
-		goto fallback;
+		return 0;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
@@ -6293,29 +6263,65 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 	stat_add(s, FREE_FASTPATH, batch);
 
-	if (batch < size) {
-		p += batch;
-		size -= batch;
-		goto next_batch;
+	return batch;
+
+no_empty:
+	local_unlock(&s->cpu_sheaves->lock);
+
+	return 0;
+}
+
+/*
+ * Bulk free objects to the percpu sheaves.
+ * Unlike free_to_pcs() this includes the calls to all necessary hooks
+ * and the fallback to freeing to slab pages.
+ */
+static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
+{
+	bool init = slab_want_init_on_free(s);
+	void *remote_objects[PCS_BATCH_MAX];
+	unsigned int remote_nr = 0;
+
+	for (unsigned int i = 0; i < size;) {
+		struct slab *slab = virt_to_slab(p[i]);
+
+		memcg_slab_free_hook(s, slab, p + i, 1);
+		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
+
+		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
+			p[i] = p[--size];
+			continue;
+		}
+
+		if (unlikely(!can_free_to_pcs(slab))) {
+			remote_objects[remote_nr] = p[i];
+			p[i] = p[--size];
+			if (++remote_nr >= PCS_BATCH_MAX) {
+				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
+				stat_add(s, FREE_SLOWPATH, remote_nr);
+				remote_nr = 0;
+			}
+			continue;
+		}
+
+		i++;
 	}
 
-	if (remote_nr)
-		goto flush_remote;
+	while (size) {
+		unsigned int batch_freed = __free_to_pcs_batch(s, size, p);
 
-	return;
+		if (!batch_freed)
+			break;
 
-no_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+		p += batch_freed;
+		size -= batch_freed;
+	}
 
-	/*
-	 * if we depleted all empty sheaves in the barn or there are too
-	 * many full sheaves, free the rest to slab pages
-	 */
-fallback:
-	__kmem_cache_free_bulk(s, size, p);
-	stat_add(s, FREE_SLOWPATH, size);
+	if (size) {
+		__kmem_cache_free_bulk(s, size, p);
+		stat_add(s, FREE_SLOWPATH, size);
+	}
 
-flush_remote:
 	if (remote_nr) {
 		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
 		stat_add(s, FREE_SLOWPATH, remote_nr);

---
base-commit: 72bb229f9161a1efcd5df32141b69fcc6ae81a13
change-id: 20260707-slab-simplify-bulk-pcs-a8d0478feef6

Best regards,
--  
Vlastimil Babka (SUSE) <vbabka@kernel.org>


