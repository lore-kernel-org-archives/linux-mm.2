Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4069C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2138F6B009D; Fri, 18 Sep 2026 11:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4956B009E; Fri, 18 Sep 2026 11:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DAC86B009F; Fri, 18 Sep 2026 11:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5B386B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:33:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5ECE640725
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:32 +0000 (UTC)
X-FDA: 85227277464.25.E549BC5
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9F4A180003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JpM63KQR;
	spf=pass (imf30.hostedemail.com: domain of 3yVmtagYKCI4AC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3yVmtagYKCI4AC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c64grHEqWwUtUzGGsYu1Ih95rNaNVw7BlsDsBBQp/Gk=;
	b=uSYmj2vKgs1yD7CSDJ9aYkEz0qk7doioJz6VN0nu0k9W7vXrJA6T/HdkHBT103keKTOuGi
	aT53qHK1fOLpLbBVezPh2fxRF7FLiIPC8ZcIlYzW9F3PlQ550MU7+mQhDVZqESUkSIptBa
	rsKbat4gjB+G06e1xL2dZcusYS9sqk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745610;
	b=Cw/prK9f602WSGaac1bSwTZlcoRl1i9gec6UdKyXUE6dOQs29tlCx/vua6Gh9Xokx87WaT
	z8vRyFi9FwINblD2bGBFkGY9egLfNiHVY8GSsruT+CzZOsPJlk8lIm3UaDx9I8O+AQzsXy
	dRB2yMQm4luDYBc71O+7PuZI7THYsIM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JpM63KQR;
	spf=pass (imf30.hostedemail.com: domain of 3yVmtagYKCI4AC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3yVmtagYKCI4AC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39e18af9f48so1364108a91.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745609; x=1790350409; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c64grHEqWwUtUzGGsYu1Ih95rNaNVw7BlsDsBBQp/Gk=;
        b=JpM63KQRBXDCuvw6F8mOqV1TrgUrT3Nmqhe/r0alnkiJYHQ2ICpXCn36uSC+q366t6
         3zzUSKBad9lF8n+/FT2MUEYSRGaDRUmGROQ+fnhkOdXyQbAzUjKM7cUB7M3Alf2az7Zh
         wkr4DxyiTzcEoMKWJKmjeR0UOHV65lIjupqMMznt5JWrar0XkoL+3wbAzf03RRCO6U+1
         5c5P+2raQcDZGLqTEao8mFJ+InVWlxSQJA0+YQjLZnZbfQAljRTo92TL7R8T8k/P1CYr
         etp/PVh6z7omzyb0qX0gs111FiCCnFLRL3lZammrrmutCbS4McYSu+1Lj3Qez6diylQf
         WW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745609; x=1790350409;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c64grHEqWwUtUzGGsYu1Ih95rNaNVw7BlsDsBBQp/Gk=;
        b=HbEWwK+watC/B3NsUhMrdkXunaa3fM5g7Dsp1O7MxhB0TqxnPf/0zraKruxQRiWmSG
         lG9TkXdgz6/sEM6NvveTQuueEo9eTt3x64yPHf209w/WYTpsNURDgwkgRCHpgoOmtwYx
         Q6wXxChAiyusekeVCXHJPAEZ6cYZDlJeyhdW3I4E+Ahz/kSInUf3pKX12ST87I6LD4oP
         3HHZyX4322knqAWgv3oEZEpAsIcg4FzOD2nuiknRFgPjSbnpmi3mb4Uhik+eMGBC2sB7
         LUWgrSJy9klsEvmw4iBWWaFKY7kV1oeEN102w595QOQMKvRWnD8KdHw7H1mPe9yunomP
         5pWg==
X-Forwarded-Encrypted: i=1; AKwUvBwjzZv53tefGn0KNshc7R5h+brgKRBXOLcqNU0ILlaYzwBv6mCUn7fIQW2vxdaOt7sI2B6+qB9wVg==@kvack.org
X-Gm-Message-State: AFuF++nSpuoY2WY1BXR/VB8CSibsDzb6U4jY1XZX6kr1H6o9w2iwBycO
	V5Qz2C5PXuobVDb3IQ8Z/QkFxp6cWIreXwhkDFhqlAY8QRy3MUQpccqluQl94WPjfuyXs4iXRui
	PaP/7iw==
X-Received: from dlbvp1.prod.google.com ([2002:a05:7022:ff41:b0:144:d125:b235])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1fce:b0:39e:402e:accb
 with SMTP id 98e67ed59e1d1-39e402eaed7mr7921534a91.18.1789745609213; Fri, 18
 Sep 2026 08:33:29 -0700 (PDT)
Date: Fri, 18 Sep 2026 08:33:15 -0700
In-Reply-To: <20260918153318.758387-1-surenb@google.com>
Mime-Version: 1.0
References: <20260918153318.758387-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918153318.758387-5-surenb@google.com>
Subject: [PATCH v5 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rrsyjw4qqhwzg9h56naxr6fqa33xa43d
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F4A180003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789745610-57577
X-HE-Meta: U2FsdGVkX190JNzT7tzXurii0Fth7VoNUVM/nWCkn9XQ2exbaUGVeExBp06grgJECyb9zcl8FGkySQjFbJbY3XTpxWT8TnKGhZZrnEdQQEM7qmrPNtBQ7aZG2YCKCLMx8ywF/+VLor0R/xxe8MDUn3/tEbB8kxbnfCFfqHVfNYfDF+luECna0KhmuvuUxuihYgUFXcRA0Bscwq0zQ87Ry5NRl4gONXKOdBJPKU+nSckGeoRYKYouG68QARMpeW94ZJEyXBcGtZ9pK1GeoEyoIBNCcZF76lw1XIbgempEYz1gxGJjE7gF1DaYI3jVtaMoQI71U0mrta57NIxWvLpZSXERgTSTEX7CJzZTm/vImdvuTUxs8oY4YlW2gHtIA+yhYV4ieXJ3l0DB9X3M3DITfOac/1f5NvtQ9AFaDDfvEIS10BZABzHeg+XJ9iGdgBFUfd4njqCWnw8k2Ae+yrxH96ssni/UzPcobN3yWmZsbNiq8bpXscqEp3vzXXpCaJlQcUjZMdXOJnoOVR2W4gmTdZGj6LiUQY02a/Fb0fn9sFsLj7dcRu2/nNO6FMt+bhJ9jgdO7I678XWvCS2lmw+oNXPCjeNuP7J7Z+g95KZPOOIGxPq5UgtZfsWlus/5+S55jWrHtzFocjTfzbp8zTksL13+0lzICglEy+6FoHG0IbV6so0veAWHy0Bn786oDIrRVzC+Goq9S8RJnAwq8nEtR2/PvxwmQESpdDqzyZmvr49f6oHIGhavXBdTbvuxU5x7T6c8C5Uf5uHNfWoOaU1XMmHmdjxWNR3SSTgkahBceC9B1uZ1stEAjvW3uVCgqZvL8xCHUuaqmwYe68BxptXWZmWIK5MoNEN93j3/k+edeJJtTKV7PuXmL1QzBHdqo6UWHVxUsW3tA2xxBs8XMTLAVCBvqao323vhu0pjxDVTHUQaPOdY9aLxDJuD2TnA2lldXy8C//D1nbHAX4J2Khx
 SWWq6lRk
 mokAETaldshWE3n9GwXh9EcaM++slZRWzLwavKHUBZoXyY6RmXDn6HlaAWdU0sD0DBHqNXpczVp0DyMDi+/6sbe+R8BjuZ+0KFAvldY8Vaj/nvUtOJwDlgVgrJ6j+djhqgdLvdCy9hxk/6i1R7pc6txDT4GbhMMUmC9Gh4sN2KifSA+wHwVy1U1TDe3+pkK+pwPfaYlvM2RqdD3vovYl4WRWVJH/911qOmO6Hjmx4GMzrkxMkbhJluACu4W832dKPk6SXBfyreOntgpXngglg5DgiVf6WEnIyL/z5gvQXPJAjyleGP41IPEZLmTEbn8W0oJGjrg3WdL2kikEkjMico4KEzUmKUZM67+jFXaoKDX01DHFqbY2x40A52Xw1F8wBGDB/WWRrckSA/Qs3KYaJioLSBgIvZRwDvzJeXvK93MZw0DX+2j35fH0j124OzQFtbEIKtC9AyZdQtoXE0Hdm+rWj8UCa+VTU12P6PPsOMgJXqy7barhLDHLaAh8fBfZ535qSHtaJBe+KIjDWuB6yBYD8Tv5jYcdTEBUxOtG90FmPb9NsPiDKUcca92jnvF39m5sJWUANRCHoARzstQRfgUu/6VCWT9gFOi04e0tX7elvPb3leWjSxRfymkn0JAtQvmesyOQaQSp9HGI4z7rXPbO2qKW3d1OrujiuQosxnEcGMn3+7Ug1roNQ8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smap_gather_stats() interprets its start parameter to mean vma->vm_start
when it's set to 0. Eliminate this special interpretation and provide two
separate functions for a partial and complete VMA walk.

Since smap_gather_stats() operates within a single VMA, we can replace
walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
which is simpler and also can be called while holding per-VMA lock.

No functional change intended.

Suggested by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 52 +++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index f1ce15981253..8f2f302d4563 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1250,20 +1250,26 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
 	return &smaps_shmem_walk_vma_lock_ops;
 }
 
-/*
- * Gather mem stats from @vma with the indicated beginning
- * address @start, and keep them in @mss.
+/**
+ * smap_gather_stats_range() - Gather mem stats from a portion of the @vma.
+ * @priv: proc maps private state.
+ * @vma: The VMA to gather stats for.
+ * @mss: The accumulated stats.
+ * @start: The address from which to start.
  *
- * Use vm_start of @vma as the beginning address if @start is 0.
+ * This gathers stats for the portion of the VMA starting at the @start
+ * address.
  */
-static void smap_gather_stats(struct proc_maps_private *priv,
-			      struct vm_area_struct *vma,
-			      struct mem_size_stats *mss, unsigned long start)
+static void smap_gather_stats_range(struct proc_maps_private *priv,
+		struct vm_area_struct *vma,
+		struct mem_size_stats *mss,
+		unsigned long start)
 {
 	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
+	const bool is_partial = start > vma->vm_start;
 
 	/* Invalid start */
-	if (start >= vma->vm_end)
+	if (start < vma->vm_start || start >= vma->vm_end)
 		return;
 
 	if (vma == get_gate_vma(priv->lock_ctx.mm))
@@ -1282,20 +1288,31 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 		const unsigned long shmem_swapped = shmem_swap_usage(vma);
 		const bool is_cow = vma_is_cow_mapping(vma);
 
-		if (start || (shmem_swapped && is_cow))
+		if (is_partial || (shmem_swapped && is_cow))
 			ops = get_smaps_shmem_walk_ops(priv);
 		else
 			mss->swap += shmem_swapped;
 	}
 
-	if (!start)
-		walk_page_vma(vma, ops, mss);
-	else
-		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+	walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
 
 	reacquire_rcu(priv);
 }
 
+/**
+ * smap_gather_stats() - Gather mem stats from the entire @vma.
+ * @priv: proc maps private state.
+ * @vma: The VMA to gather stats for.
+ * @mss: The accumulated stats.
+ *
+ * This gathers stats for the whole of the VMA.
+ */
+static void smap_gather_stats(struct proc_maps_private *priv,
+		struct vm_area_struct *vma, struct mem_size_stats *mss)
+{
+	smap_gather_stats_range(priv, vma, mss, vma->vm_start);
+}
+
 #define SEQ_PUT_DEC(str, val) \
 		seq_put_decimal_ull_width(m, str, (val) >> 10, 8)
 
@@ -1346,7 +1363,7 @@ static int show_smap(struct seq_file *m, void *v)
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
 
-	smap_gather_stats(priv, vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss);
 
 	show_map_vma(m, vma);
 
@@ -1399,7 +1416,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 	vma_start = vma->vm_start;
 	do {
-		smap_gather_stats(priv, vma, &mss, 0);
+		smap_gather_stats(priv, vma, &mss);
 		last_vma_end = vma->vm_end;
 
 		/*
@@ -1458,14 +1475,15 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 			/* Case 1 and 2 above */
 			if (vma->vm_start >= last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, 0);
+				smap_gather_stats(priv, vma, &mss);
 				last_vma_end = vma->vm_end;
 				continue;
 			}
 
 			/* Case 4 above */
 			if (vma->vm_end > last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, last_vma_end);
+				smap_gather_stats_range(priv, vma, &mss,
+							last_vma_end);
 				last_vma_end = vma->vm_end;
 			}
 		}
-- 
2.55.0.1082.g2b9226bbc0-goog


