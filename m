Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC5F0CD8C89
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 01:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F012E6B008A; Fri,  5 Jun 2026 21:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB20E6B008C; Fri,  5 Jun 2026 21:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8F76B0092; Fri,  5 Jun 2026 21:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC07F6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:57:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 571F9C18E9
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 01:57:43 +0000 (UTC)
X-FDA: 84847826406.16.CC8D697
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 98D0F40007
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 01:57:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lo4ayJLj;
	spf=pass (imf07.hostedemail.com: domain of 3k34jagYKCHYmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3k34jagYKCHYmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780711061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LskI7o3bjkNbR0+FjqKAOKBLRy4mR1cF+3UOhyNarXg=;
	b=VyzyxOacGcx8vfnHdlRyXx4+KabmvBX427ikVtOMJpiZy/nspE4NX4VZLQEfy6czrWNn56
	ZQMKDzmBSuYEswY50qn2GfGHVA4lK3ecwR/DExj9T+ie6W/9VDaiAHu42oKfYfSapDODAH
	MlB/TkZgZUqs86xNT+3BKvYnHnrDh2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780711061;
	b=7I+KkEOya7gHkFrsXR+nUplDkrPJrMgFIXsa3vbtgkNL7k4XrroPdnNRfPE7fzwKK7pcuP
	OnjkKzIYsZ8qBG8n2dij9GkgWTCfIFA05XNRz69YYUzyrrZ+w6W9P9zlX/UplNL5ZRGixM
	PIzQT5tMAN6xhShKhZi4ogJIct+5YfA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lo4ayJLj;
	spf=pass (imf07.hostedemail.com: domain of 3k34jagYKCHYmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3k34jagYKCHYmolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-304ed777a96so1436424eec.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 18:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780711060; x=1781315860; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LskI7o3bjkNbR0+FjqKAOKBLRy4mR1cF+3UOhyNarXg=;
        b=Lo4ayJLjl69gCFwbjNc9RaiemEmGwtX8CvYwc85fJ/rPtvpgUzIXVgAiVaJADHRh0u
         KXLoJ1crK30vlmzN2Ey6fXlj9frzp0q/V99ciiQlroSoJs6p8SicnrzFRzCysWistJ2N
         y3wtowsIGM5Tm2AJS20M8GkWlqbNBNrWyccUTpPsaY/H4XHPyhS4tQV6C4Xh+h5nHAus
         E3QxtuISAgXSYmhfYfoxBqHNOjlFxBCdKAv0vWe2LYWGMRKL7WTrDrrrJqbpEXK8M3ku
         UoE2octO1sPmbtCc/lhsKAW9hIrvuvG5//hqXfA2MORbHO17KAtuxcVO9pJhVLg2chYu
         TTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780711060; x=1781315860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LskI7o3bjkNbR0+FjqKAOKBLRy4mR1cF+3UOhyNarXg=;
        b=LsJ7VHPte686q7oU2Jyj/4Pve8ukFOLWZ6JgIdifPs6LiEKnicItQDOKXSo0kV0W8s
         r3exwjcv3GZoFbEYpyDFyjG6va7IjpUvBDkefq7PPXROSB3LQerhf0zVzSelGWkyDun/
         CsfdtcNjCfUyKBgimjfXf/96G+xGuuS1R9h0Eust0NA7G+MLjQS5JCPqYy8yBm+F+m3E
         G4rcF9V12Unkn5OG3gNElazMq1FOu2yx2tHdB7x90KVyUMvCVJd8FteW7J2eoo0944zt
         SIDIXOTjrthuxdhjUcB919tMioaxjn9M6Bnm9kbTAOSxteK3KotqddM5PEYdoVixZP7w
         CgCA==
X-Forwarded-Encrypted: i=1; AFNElJ9o8hlD35P4bq0Qh/JhwLVohwUl8XiMnrmXL7ahxuQut1k5ncUli2n3QkqIgN9CAt+OusHS3lRkdQ==@kvack.org
X-Gm-Message-State: AOJu0YxhVKLUrRJwBAJKSgh50wZTW7uY8jZ8qZXGbGKcF3h/YEg8iSq5
	wemXd8pHhyMVahlkXKRkcnZCkImcWV395OWW+Fj7wOkmT3wZRYt/yz0qVauisn91QJgtxZRB4Mr
	AASUfSQ==
X-Received: from dyblc27.prod.google.com ([2002:a05:7301:131b:b0:303:98b0:efec])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:fe04:b0:304:70d0:4f03
 with SMTP id 5a478bee46e88-3077fe1125emr2807002eec.6.1780711059900; Fri, 05
 Jun 2026 18:57:39 -0700 (PDT)
Date: Fri,  5 Jun 2026 18:57:29 -0700
In-Reply-To: <20260606015729.1837935-1-surenb@google.com>
Mime-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <20260606015729.1837935-2-surenb@google.com>
Subject: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 98D0F40007
X-Rspam-User: 
X-Stat-Signature: ecrtxjryn8n4jsgux85qibtxe996u66b
X-Rspamd-Server: rspam08
X-HE-Tag: 1780711061-245744
X-HE-Meta: U2FsdGVkX1+oaOu5zUgOerpldsmHUY82AxJNhfuKRqOog/Spo+fgxyJ1pfEM8gTHrEzFGpQ6V5EclDkUW0JuIiHpCRFMQ6/RM22xIHSLlYrgyGwDnfvxsnIM2sDZU/TwWltrOr44F6MTMjfdwneKJreDXHIgeQysvQ7uqPjlUxjKe6CJZGkcDcZOryTDsV3E1CA8Sux3PQfUVelFJBGWsvFXSyLyjga1DwfL0e14nP7dSndONVnnASl4K/gAWZT53HGxfo6uhyGElY4a9SNGhydIoZ6Mu7m+hZJ4G7SuWQR1dnrJH5y60QyatSqNf1ybNusEmeBHX68Lgwe0/DvDFmkWkiQVo+cygFTLx5MNyH84qle+y7i8z0TbRDxFRHbsIicvF0naVZHj2ALI3PlO1dnZAujjD9KT9gS6sIkZArrMhvKyrKdPPK12BCFJUwhvAKnCH/KURCoUCrA7IhegoG648x4xR84+pDtKWFG5hrujYV0u0KzWv+ftZMmEXIV+mKCYzYEOTsVI/N5E7TWfLk1kfB6btnawKz0Tf9FmsPtZ5R0zvuAlSQnkWN1Om4roNevs+KBbxqNRUhlM2fLvkVuX+pjVVNSnp3J6+cA7IQaKBuwGQXm7jfVhILnCCL2YE7KhPu7VOWVPrQQJInUs/cDkCu/+RKCqJzhHrag0p/HUbabW9MQDlKeI+MY5retqAG9m6DKTuwaRoSndZ0FTu7pNOAvRwDRQejuudqTSG2o6dD78IFk9ya6VkypYFPNj3rnSqDG6WBcUjUip1dE0qrq4woRozWB0JVEQ70n/9euLj2FlViy/HjQ5Y4g4nEfHrDIhbhq5VMhqaLh1fwVf1Emcb0Tr+3fUTEfEe+oyrxBHCj5yTrh4ybH/O6SK3Y9VnhZdBOp0bHL5n+aEuX97vwY6URJTm/mUzoXGzZ3rgwHqs+ewia/Qic/kgzhOQ+dLVNzHoOuWTkLfQIL6OeM
 m6mjjNoa
 q11uCBG1YEaQR3zZ87RGikXRc7ECqQt5oU0ij+P39FGOQpvZvhYt7DkVhzg+yb757BabJBqWToz54vqsrdFvpB4mN+Mj/BYdSyYhhzc4mQymSHwhwVDLq4q3XvzmuWgv6N/OAklbWkAN9ygr1Lp8kxdlZdcg3A32DWabfu8SWznrNwSn1TcygywQut7yLKBvlBW7BMW3cMDUCSBpPEetHTP/x6oexWBsj80yKcmmIztSfFyTQqKDAM4lcskbY5H7Buv20O8n9joNCWkq/XqSmizIbhzyMawl6DLmT1mRVrcwzQoUnOC48Hfba5xhqdESdoWhKiipz3/g0ZADb1ihP2tFDXZsheL33MBHqajArg9+OJzZpfiuOBn1Tj9m1fA847Z17axRu9VgsZ/vwFNyOMh+m6JpGrCm9LNSaJ93YU0OSd519EfYSlgKYtf+Sj2vp/6zP5PQGHSRF0OIoDGjRVwYcm3K9FC6GynZ5oe7492wypVEdnvPoqid0octr9Lgh2M957uAd0WmUe2sJCjgGQg9fS8NGPAfBLoL9hmv38UY0gDYTH88gCsNz+ijmKcOjLEMqsntCbnOIvJQLOr7dYP1b1XykRNepIh122JTovXxhfGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc/pid/smaps_rollup can be read using the combination of RCU and
VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
required to safely traverse the VMA tree and VMA lock stabilizes the
VMA being processed and the pagetable walk.
Note that we have to keep the logic to drop mmap_lock on contention
because even when using per-VMA locks we might have to fall back to
holding the mmap_lock.

Running Paul's contention benchmark [1] shows considerable improvement
both in median and in the worst case latencies:

Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
--busyduration 2 --procfile smaps_rollup

Baseline:

    0.174     0.161     2.553
    0.174     0.164     2.663
    0.174     0.165     2.664
    0.174     0.166     2.679
    0.174     0.167     2.691
    0.174     0.168     2.704
    0.174     0.169     2.729
    0.174     0.172     2.741
    0.174     0.174     2.745
    0.174     0.174     2.755
    0.174     0.175     2.790
    0.174     0.177     2.809
    0.174     0.179     3.096
    0.174     0.183     3.144
    0.174     0.184     3.158
    0.174     0.185     3.175
    0.174     0.185     4.568
    0.174     0.198     4.821
    0.174     0.214     5.143
    0.174     0.251     5.220

Patched:

    0.007     0.007     1.952
    0.007     0.007     1.955
    0.007     0.007     1.955
    0.007     0.007     1.955
    0.007     0.007     1.957
    0.007     0.007     1.969
    0.007     0.007     2.065
    0.007     0.007     2.075
    0.007     0.007     2.146
    0.007     0.007     2.195
    0.007     0.007     2.223
    0.007     0.007     2.259
    0.007     0.007     2.488
    0.007     0.007     2.562
    0.007     0.007     2.599
    0.007     0.007     2.697
    0.007     0.007     3.030
    0.007     0.007     3.075
    0.007     0.007     3.145
    0.007     0.007     3.225

[1] https://github.com/paulmckrcu/proc-mmap_sem-test

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 134 ++++++++++++++++++++-------------------------
 1 file changed, 59 insertions(+), 75 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 023422fcee12..c2bd9f5bbbcd 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -233,6 +233,16 @@ static inline void reacquire_rcu(struct proc_maps_private *priv)
 	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
 }
 
+static inline bool is_mmap_lock_contended(struct proc_maps_private *priv)
+{
+	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
+
+	if (!lock_ctx->mmap_locked)
+		return false;
+
+	return !!mmap_lock_is_contended(lock_ctx->mm);
+}
+
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
@@ -268,6 +278,11 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 	return false;
 }
 
+static inline bool is_mmap_lock_contended(struct proc_maps_private *priv)
+{
+	return !!mmap_lock_is_contended(priv->lock_ctx.mm);
+}
+
 static inline void drop_rcu(struct proc_maps_private *priv) {}
 static inline void reacquire_rcu(struct proc_maps_private *priv) {}
 
@@ -1486,12 +1501,15 @@ static int show_smap(struct seq_file *m, void *v)
 static int show_smaps_rollup(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
+	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
+	struct mm_struct *mm = lock_ctx->mm;
 	struct mem_size_stats mss = {};
-	struct mm_struct *mm = priv->lock_ctx.mm;
 	struct vm_area_struct *vma;
-	unsigned long vma_start = 0, last_vma_end = 0;
+	unsigned long vma_start = 0;
+	unsigned long last_vma_end = 0;
+	loff_t pos = 0;
 	int ret = 0;
-	VMA_ITERATOR(vmi, mm, 0);
+
 
 	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
@@ -1502,89 +1520,55 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		goto out_put_task;
 	}
 
-	ret = lock_ctx_mm(&priv->lock_ctx);
+	hold_task_mempolicy(priv);
+	ret = lock_vma_range(m, lock_ctx);
 	if (ret)
 		goto out_put_mm;
 
-	hold_task_mempolicy(priv);
-	vma = vma_next(&vmi);
-
-	if (unlikely(!vma))
+	vma_iter_init(&priv->iter, mm, 0);
+	vma = proc_get_vma(m, &pos);
+	if (unlikely(!vma) || vma == get_gate_vma(priv->lock_ctx.mm))
 		goto empty_set;
 
+	if (IS_ERR(vma)) {
+		ret = PTR_ERR(vma);
+		goto out_unlock;
+	}
+
 	vma_start = vma->vm_start;
-	do {
-		smap_gather_stats(priv, vma, &mss, 0);
+	while (vma) {
+		if (IS_ERR(vma)) {
+			ret = PTR_ERR(vma);
+			goto out_unlock;
+		}
+
+		if (vma == get_gate_vma(priv->lock_ctx.mm))
+			break;
+
+		/*
+		 * If after retaking mmap_lock, already reported VMA grew or
+		 * merged with the next one, then iterate from last_vma_end.
+		 */
+		smap_gather_stats(priv, vma, &mss,
+				  vma->vm_start < last_vma_end ? last_vma_end : 0);
 		last_vma_end = vma->vm_end;
 
 		/*
 		 * Release mmap_lock temporarily if someone wants to
-		 * access it for write request.
+		 * take it for write request.
 		 */
-		if (mmap_lock_is_contended(mm)) {
-			vma_iter_invalidate(&vmi);
-			unlock_ctx_mm(&priv->lock_ctx);
-			ret = lock_ctx_mm(&priv->lock_ctx);
-			if (ret) {
-				release_task_mempolicy(priv);
+		if (is_mmap_lock_contended(priv)) {
+			unlock_vma_range(&priv->lock_ctx);
+			ret = lock_vma_range(m, lock_ctx);
+			if (ret)
 				goto out_put_mm;
-			}
-
-			/*
-			 * After dropping the lock, there are four cases to
-			 * consider. See the following example for explanation.
-			 *
-			 *   +------+------+-----------+
-			 *   | VMA1 | VMA2 | VMA3      |
-			 *   +------+------+-----------+
-			 *   |      |      |           |
-			 *  4k     8k     16k         400k
-			 *
-			 * Suppose we drop the lock after reading VMA2 due to
-			 * contention, then we get:
-			 *
-			 *	last_vma_end = 16k
-			 *
-			 * 1) VMA2 is freed, but VMA3 exists:
-			 *
-			 *    vma_next(vmi) will return VMA3.
-			 *    In this case, just continue from VMA3.
-			 *
-			 * 2) VMA2 still exists:
-			 *
-			 *    vma_next(vmi) will return VMA3.
-			 *    In this case, just continue from VMA3.
-			 *
-			 * 3) No more VMAs can be found:
-			 *
-			 *    vma_next(vmi) will return NULL.
-			 *    No more things to do, just break.
-			 *
-			 * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
-			 *
-			 *    vma_next(vmi) will return VMA' whose range
-			 *    contains last_vma_end.
-			 *    Iterate VMA' from last_vma_end.
-			 */
-			vma = vma_next(&vmi);
-			/* Case 3 above */
-			if (!vma)
-				break;
-
-			/* Case 1 and 2 above */
-			if (vma->vm_start >= last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, 0);
-				last_vma_end = vma->vm_end;
-				continue;
-			}
 
-			/* Case 4 above */
-			if (vma->vm_end > last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, last_vma_end);
-				last_vma_end = vma->vm_end;
-			}
+			/* Resume from the last position. */
+			pos = last_vma_end;
+			vma_iter_init(&priv->iter, mm, pos);
 		}
-	} for_each_vma(vmi, vma);
+		vma = proc_get_vma(m, &pos);
+	}
 
 empty_set:
 	show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
@@ -1593,10 +1577,10 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 	__show_smap(m, &mss, true);
 
-	release_task_mempolicy(priv);
-	unlock_ctx_mm(&priv->lock_ctx);
-
+out_unlock:
+	unlock_vma_range(&priv->lock_ctx);
 out_put_mm:
+	release_task_mempolicy(priv);
 	mmput(mm);
 out_put_task:
 	put_task_struct(priv->task);
-- 
2.54.0.1032.g2f8565e1d1-goog


