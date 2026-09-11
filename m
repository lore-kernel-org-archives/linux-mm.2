Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11603C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D6D6B00AA; Fri, 11 Sep 2026 15:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2464E6B00AB; Fri, 11 Sep 2026 15:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1359C6B00AC; Fri, 11 Sep 2026 15:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D34BE6B00AA
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:42:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B9A8A031D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:42:00 +0000 (UTC)
X-FDA: 85202502000.11.8AA4D40
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8611040003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:41:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wSXkOQBO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3hVmkagYKCCYUWTGPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3hVmkagYKCCYUWTGPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oS2GLdH94EngI/E4RH9yM/bXq5HOqmtDA5Og7xd7+N8=;
	b=LUu6+QRZnE4a3WU9i8kjrmAvX0dUQJA4mUhggCcR2GIC+6YQ8SPyRJwJ1XBpobxhLOjYNJ
	vrWTYqkyBk/bdnP9pWE/MG4S6FeHwRFtMojZutbzsdQqHPeUC0FDs4VWFo+oNpGTbfVxj2
	u0/rHWX9FhGTj6MONZM/hXEwDc7+gH0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155718;
	b=8A3WI0bqZZgvb03F/3cn0nN1nw6qVWiqQwbWct+2w7vzo9F4FuXqS3eL7v1IOmxqsr3CKm
	Pp9mOUlhL5HmPR2HPZjZP5hcE1+WjDM6FRy4WOIsd0r+i4qGXtb/q89k4cxrbsloJvridf
	isAaKjYFnNp7os8+eQbBKPX/4NrfANQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wSXkOQBO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3hVmkagYKCCYUWTGPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3hVmkagYKCCYUWTGPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--surenb.bounces.google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc11b5dd54dso2358726a12.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155717; x=1789760517; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oS2GLdH94EngI/E4RH9yM/bXq5HOqmtDA5Og7xd7+N8=;
        b=wSXkOQBOAWuR5J+aTBC5swkj+r6TCeMez3UrbPNM+lgQqOjoJva86+Sk7LC8WestaZ
         XWGpTbq80zGuQEqBseQob8jSjWz5SsSiD38O/izgNMBCGx+8rbS1fh81Ov5usqXxOvnh
         nNthFgXCMGYYqXZ3fJMDHgunJErM9hz6cfpIKvLoY6QrAFaHdMmTneGZyM+4vcpkmmcQ
         Y3+IN9xxVYiO29BP3fXJLdQdFNxxqgjjG5eyz2dgSayomBIKW4YCPlTWhXhVq01L+WqG
         0dwPmBLghvNn1b2nyOQzASi/1K1YWO/iYVcsRrSoUBQF38bnCnD1c3AnD8eKKM/N9ZrG
         gl4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155717; x=1789760517;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oS2GLdH94EngI/E4RH9yM/bXq5HOqmtDA5Og7xd7+N8=;
        b=Ip2tz4+Xsi/9riiV5TycUrzerOFpc56XAJ/qgf+JaVI73HnTvWS5nLAi7awkMzForM
         m2sR7SaOeyvYjp6xyIy/ABwn+iBgGNmCjGCzGWFF7TEw4YmBYKbwCmnSiEiZk8BXm1/t
         LIbUE4aNyzNhQlSobLDh71x/kGNHDSf/cHbnwGwayoba/UT9mMHUuq5C10GrsB02xnSn
         G4e+65IwXcz7r43f9/5EOmK9KaEA7DD7jjDet8DzyDZX48cxeQVrm2l4vxYODqoGGG0q
         yz3y7dDSuDqSdtv25amoD2NnokI+msJqElMWjj5zqfOymrl/FkVEnKYpO1Whdqra/nEn
         sdDg==
X-Forwarded-Encrypted: i=1; AKwUvBxRUK5U/WiYNSweDeNlys66Z/oQkKzpqOdRbZjFo5kZOva7uxfcFcOqz4r5rdxsR/ZZVictNSXw/Q==@kvack.org
X-Gm-Message-State: AFuF++lJtGOHwqh8kHKkBkkwFmSNw+qvrKVLCYMHcGr9ZOJzZCxNRoI+
	lPXMD0Vew2Fig2CT30jzotbOzmu6Rhc7W0a/b+MJ7zDZ6zHDzpYv9dBeVOmBZyKxoJl/6Yg7aD9
	9GX708A==
X-Received: from dyvn14-n2.prod.google.com ([2002:a05:693c:864e:20b0:313:fb09:e2c0])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:be8f:b0:3d1:7238:33d9
 with SMTP id adf61e73a8af0-3daed559065mr10930453637.3.1789155717279; Fri, 11
 Sep 2026 12:41:57 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:41:42 -0700
In-Reply-To: <20260911194145.1781926-1-surenb@google.com>
Mime-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911194145.1781926-5-surenb@google.com>
Subject: [PATCH v4 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8611040003
X-Stat-Signature: ocxhqooip848pkqnx1hh4iwqrtduf9u1
X-HE-Tag: 1789155718-980722
X-HE-Meta: U2FsdGVkX1+a64gmOdhx+o8xNjyVBVOMBOM0k10JQBwKc5sJ87UvUNK9Jss5LYaIRRqG/9bUOpF6tfdgr2NWs3KBZAUZwTmJHfrRImM/n6GkGPFqRacSn4l+LK3zOBvSyRdk2O52YX+Fp5HRlyYMpIYstn0zVuWO4Cn4MXycqcLmvXAGbchV288A2KIs75DtJSJYISmAt7rRgtmIx93uW61N4SU1UroTe616myHV7aCpFS86n3+9u/P2Jw5H5eInl6CkNEnt474RwEeKX3+YEaSywo5s3zSL28b97fmFPymVcMZLHBCil5Gv/wzPycMiu8DZ/8Amv/c0gGAPWISQRlKcFPlOToRVv/IHsgHYIa0ieAG2+3KonY0VPkb4cDABhEVHivCu/jgbYB3bpJGdwGfRGV17IDXHJXZXeFuzMk83rUdlJorR1+Rs4+AJW+v5JHPyGnocE9irqOAbBMG2qfjmBRQnNw+iK5Tl0O2gi9uTzBQvr/KRZ/8ceqbMrCt1iystwnyfvJyQGk4q+wRahgMwOhi9iXq1jAnPQPVq3y4fygiBqT8wjFtjW3GQNNRPlRJcf+fbQfnk3/UVZ/BQkjb/K51tdQDRkUCs1wH18BNuKBQ8btts91R2+4e2HqnNY5ZvIokYpfcxb91yApw7427lQOpKhaXbir42ZNbgqyA4e2U4cUhMOcnDWYm/MQGyqIFSehN3LpINd+7Z2EU4t3EQL9eZckmCirSRIQdlWFbtUL76QQfXa1E2qgwNhYQ853OWbcyjzmzA3INfdVLou+SyYvMHb25gDPyxF04JUA/Vkdf1wMmuA4n18ztbaNmpGhI2TEudL4XbD6PQO10zbCy1aC8UT+6wzn6RccNMaZGalxzdFMSESt8MKl1HI53SM7EvK9SniyDj0+fM88R7Cbmzz5zxZ7Vq/Te6oo1xPO6MUhRWe3vjaundSeIQzz+FXLCqIRWgpt+J/nvUqGG
 P1LFbPit
 Xc/1e3YBFfhQpyDATB2e0g4nOuHvs8jOqXApzQhcRFgdZG6xvglvM1Qw1Tj5nI6+XXpq/3UNSiaqeL3u4hWnq4l91BSxeKFiWkf6U7MSY1SyIcRZD5lirBy5ZYuJglHw2xlhc73hxnS0qNxiMhOicYC4MDOtb9l6mLsfyLccbU7wxIVmXwFEa64g/XV0if+PxLDLawzRANtOWIUJ7WtqfASktYDaqIY3ZJ+SEtdnZGhuynBbh+2QilxBYslqRVK8sqwg1xumzZEyvgYEWdlcQESKso2MEZR6TcFRh5wYpOBs2DqKx9lDSAvDY1lYKwNH12lxGkpPHAD3gfLWbTpw5YuZGV4G2E5aaBEfP5mt6Ej2BZFjY6Qka2QUqiGFjSRxL8lSY4gLYbFST20XwlYEuWAYOTXt3s9zifyYATJAJu8BGnsjRbs85eLatQ1O3IanyNKn7WYkCmd/GZIigHhpRaV1Qm2n9zpAMoLulABxnXWmsXFdmLgBgkpfPgCfwh9GAZjUwcjv8iH8/EGT6lBkLRKdUFALKd8UbcUvsjzkxIf9Kp51VkYG4IgtadApEOdfrxUHn4YWfd6XsqzYqNMJjG+yfpNEWvTkITP9EpDP5tVcT7lEYN2heIlgIDyVEkVc7/YWPdZj5YurUgDFr8mdDhI5Wzs4mMvDRUiJvFaumDqo4Ok/8IZWRU6tE/Q==
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
---
 fs/proc/task_mmu.c | 52 +++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0e53eb065a3e..a6026ffd07f1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1246,20 +1246,26 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
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
@@ -1278,20 +1284,31 @@ static void smap_gather_stats(struct proc_maps_private *priv,
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
 
@@ -1342,7 +1359,7 @@ static int show_smap(struct seq_file *m, void *v)
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
 
-	smap_gather_stats(priv, vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss);
 
 	show_map_vma(m, vma);
 
@@ -1395,7 +1412,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 	vma_start = vma->vm_start;
 	do {
-		smap_gather_stats(priv, vma, &mss, 0);
+		smap_gather_stats(priv, vma, &mss);
 		last_vma_end = vma->vm_end;
 
 		/*
@@ -1454,14 +1471,15 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
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
2.55.0.1007.g17ff1f9808-goog


