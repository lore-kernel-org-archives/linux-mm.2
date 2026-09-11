Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98AFCC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF00B6B00AB; Fri, 11 Sep 2026 15:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1846B00AC; Fri, 11 Sep 2026 15:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90FB6B00AD; Fri, 11 Sep 2026 15:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A58C36B00AB
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:42:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20FC4A46F4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:42:02 +0000 (UTC)
X-FDA: 85202502084.14.E5B5B04
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf09.hostedemail.com (Postfix) with ESMTP id 60844140008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:42:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CDBEwZzc;
	spf=pass (imf09.hostedemail.com: domain of 3h1mkagYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3h1mkagYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zej03whk2f8tlO07T6d+N4M+kS17EX2Qpuy0D1YVEz0=;
	b=sPEXjxgGIv21Ihr3qpyGOByPsEU3bZaIOCYxxuZLy97og6JGoG1VKe/mk1XNbiy5JgFMPD
	wKsKrhroFShQJwHCjyMIN7ZoRMsFkMti/vgbitWRK/wHsYosbJO5DpDkIB+7MaXDE5Z5j2
	slQCsFNIJ5dYrDjb2ny6npYe43fpDuw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155720;
	b=WGoe0aUMGJvImMVp9wcGm3vLLCMETajXNGQs1AGbK4yGYG10jDSPv3IKN/R/BrTxIvk3wx
	yMybU5MtffTDNwA+cVSdLIVkGi7Rqooqh8nrlMAe1LKzbzukv9SCVv9hrIcv2D1ofU0f7i
	NyOVV/SsL5gbVjLdTKr/8LmNpeNO3gM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CDBEwZzc;
	spf=pass (imf09.hostedemail.com: domain of 3h1mkagYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3h1mkagYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39512608fb1so2865726a91.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155719; x=1789760519; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zej03whk2f8tlO07T6d+N4M+kS17EX2Qpuy0D1YVEz0=;
        b=CDBEwZzcBww1SRQcE1pyNyyA2/fTY4BjhLqeHFVPGO2cVt07Hz9koMYpODNm2W5+XY
         /KG8J18AJZ0pxAo5Wc0h0CUOup+D8ZrlKI+HtQyrVbmeo2U6MSDCHlnVc5p5W3Yp3F5q
         G50WgOYcX+U0XPpgSbQIgT56K40OzrHqm8dnGk4wCIRtT7mOkTG70FLcd4e6ElNnGBuw
         6Qv7Zwv0tFKFmo1HGNsUnLb31qPyOKb0jpMZXxN3dDJAskHhZ1yvlHFlDcAKtaEJjJ6b
         kSF6JhqCy8rGt7NivAklPJRd81gyUzRd+BiFr4NvF4BdiW9X2EOyCaPJg3myU1ph+I9N
         fhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155719; x=1789760519;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zej03whk2f8tlO07T6d+N4M+kS17EX2Qpuy0D1YVEz0=;
        b=KHICFZPvie5FWlASKff1nnEDBa/sgn056AF6f1vxGzvYaLWwpASTPrVuiLIH1+fTU4
         IPKwPO2HrOOba5GYY4givNGioWWPMKI0ullUlIZ8J7N++a9ugW7UukBTdorJMAg2oTGy
         aLoezulELC0YoGMW367lzQkOJwjxteGNKKfmeze4OrFYFXq+OqAy1+0WCm9eYiJBxGD2
         EPr1ZDFEQ4P+0l765u9KvI73Rhj5GTekbf/O4OLG0o2rfaby7RBa8GB3k16DD554nb6Q
         G++pD3jIN8I42j+vSYdF8sUvu8pKHRwcS5s0UbyLAMH9OWBXLd+vpxOBRdNkj4qnDBXG
         GgIw==
X-Forwarded-Encrypted: i=1; AKwUvBynE7lQO8G0ZC7YeILgwFggnTmNMH2y4YKW3cfJ+LXF2tJ641ycOyfW0reWUEiKsLmunH8GQCihbg==@kvack.org
X-Gm-Message-State: AFuF++kbYu8HCzyELSH843E2GPz8CVZJqIO8UGAGGaMbpZTmAyKGV65g
	sd6XY0I8FL5CRlYvFPT60loEn5Uj80J1ydfyzIVzQPQYtrSW3dAq0wFkRbWOigVviyrYlxe4JTe
	a8l1LaA==
X-Received: from dlzz14.prod.google.com ([2002:a05:7022:48e:b0:143:5477:e9f])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:280e:b0:395:5eec:b932
 with SMTP id 98e67ed59e1d1-39d9beb7248mr9867936a91.11.1789155719169; Fri, 11
 Sep 2026 12:41:59 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:41:43 -0700
In-Reply-To: <20260911194145.1781926-1-surenb@google.com>
Mime-Version: 1.0
References: <20260911194145.1781926-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911194145.1781926-6-surenb@google.com>
Subject: [PATCH v4 5/7] proc/task_mmu: change proc_get_vma() to stop returning
 gate VMA at the end
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pfocei33fhs9zpbhi7oguyom6w6dkxd5
X-Rspam-User: 
X-Rspamd-Queue-Id: 60844140008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789155720-910321
X-HE-Meta: U2FsdGVkX18cW+gkpJbFC5O0q7nF1DkguYLvOScj+lSOksID49xXGPabBUF8thwnAT1eFOHXRq6ZYd759Uua4OlheTMwRdcYi2OiMMGUiqMpJxqzAxL8eoAyEZ8WyXdID6164O35nxlUHzimNpsg0E1yycrXcCGsv9BVil4+646VjXWgysptNaB7A7dhv4WkYJ4MWcB/XnZdh1fQQMWPYuUwdCwL5la97i2EeP8BN5lZDNAmrm23aYuM9GJhvyNP2BLr0sGubigxO2lI8uvozadqGYLgwYNYDR1RcQOJ16FoI06Se17vK00dkvtknDIg5HD0HOlX7fBL5uDTuDq/yzCfiemysWEQS9/Z5A2eNZhK7nfIF2+rMBa0IzF3kWT9+/DSiCJYf8ZqF22hm+avt72A98NgcT/e/ZHLP+Xvdx8smujBQI4DiCVpo08xLNG85rI9mlMarD1A0w3IkBmE4DTbGLMOWmPmrvWMtu20Ci6EljbOT6ki9gac+jYSr9wNvWY6T4R3WEuVKNQNhICdtS1y0jnxhml+z+xAvtMHWoL8729rL0r/OkCJR9O/utwfEbujaT30taxvh0BymWcBSZGbw4dz9Fj0QMEN5A85T12iOT/SJS41CIV9h5hwRHS4xHme1n+Aygwy7aAnHxqQuqOxcYRDl9nKLqSuTRMEZdCSNdNCJhAZK0MAA/XJchH+LEe2N5v76ebZGpWmWyNLBGlPq8/rLTjj8EwJge+YHtEaNx2D58TA/1jE4ansiGW+LVjifhFaJtiIOG2FFdHYLirzLXcIVHjNg5ntTrM81IOKxnaa0ZLO5O/wPL9KK1Bf2mUC8w6eewmIDjNX0glHyh/J3l69S+4trD6/9aRBdQMYk92xGWUL/EkLj2gp2jE5+c2t2noQu34osulRMptqCdTARyRe6bChHjcnE6lOSCkvtAanCcX2DSth6jemh02/DnUPSx7/m0nN7h5GJHr
 UwFQONBH
 P5Xe4Vgas1H522MLl8clX6F06ZnzuohcLCa9ekom2G3k2WbUMxx8Ht0J1ZHSSbWw5jcfJGH0CGHjuFJLlJhCipsGrWs+DD7VM9vaFxjVnYjwxBz/NNRJX5YkZufeQaPDhS50Jduxn7HtJlPPxLKebBmENcmj2BDoEsbajJZlZnEb9masqm/8emGK1Au7flSqm7gsL3TVu0sCsBcQpLnm+yXvTt2GXRu4XZ3wxU6GOxA0TE2GeEORPlMXywwhbvkxjPwSkhDiX0mdRDv2CtGgfeDln3AG3DZ0Xhv5+JaKgIPCPvO04IXg/ewUY0yQajZdMPabpgySwfKUNXQygrtrjJycNVk30+e6r3Csh7JGTSS5kXVBQivFlT4lpwf3NSJisbLdfCveMqcxmDzD+g4sz4HLwRKyXHktSwGes1i0P7kUCKLQeBoq0ODBZvEIwBB66xIC8Ba4uyhjxziPb4wuFAfMot3rm+QmqdapX6983/sjRl64PTGSR3zxMKa7Kf2YLM2LjukYJSR14Ot+aZwfAKaTt2uVyB0zni35SD1CnnPpSuXXcll8IUq0LItws1fFE16beF7SFd7CzfmYUqGz+rae7i6Bs9foaG1E6dNEbKJleBjNOl4Iwmp5QvFnGR4wrdVUyUKrMglV96wbzjGtV0f9Xj0Vg7BDO1b5Dc5Oqx/0HYjYgpz0uJUU8wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc_get_vma() returning gate VMA at the end is desirable for the its
current m_start/m_next callers, as they need to report a gate VMA at the
end of the address space. This behavior is very specific to these callers
and makes proc_get_vma() hard to use for other purposes.

Move this usage-specific behavior into the callers themselves so that
proc_get_vma() returns either a valid VMA, an error or a NULL when no
more VMAs are available. This makes it more generic, simpler and usable
in the later patches.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index a6026ffd07f1..aef7ce659889 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 		 * found the extended vma with the same vm_start.
 		 */
 		*ppos = vma->vm_end;
-	} else {
-		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->lock_ctx.mm);
 	}
 
 	return vma;
@@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
 	struct proc_maps_locking_ctx *lock_ctx;
+	struct vm_area_struct *vma;
 	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
 
@@ -277,19 +275,39 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 		*ppos = last_addr = priv->last_pos;
 	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
+	/*
+	 * If seq_file had to flush its collected data right after m_next() set
+	 * position to SENTINEL_VMA_GATE, m_start() will get that sentinel and
+	 * should return gate_vma without calling proc_get_vma().
+	 */
 	if (last_addr == SENTINEL_VMA_GATE)
 		return get_gate_vma(mm);
 
-	return proc_get_vma(m, ppos);
+	vma = proc_get_vma(m, ppos);
+	if (vma)
+		return vma;
+
+	/* Return gate VMA at the end */
+	*ppos = SENTINEL_VMA_GATE;
+	return get_gate_vma(mm);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma;
+
 	if (*ppos == SENTINEL_VMA_GATE) {
 		*ppos = SENTINEL_VMA_END;
 		return NULL;
 	}
-	return proc_get_vma(m, ppos);
+	vma = proc_get_vma(m, ppos);
+	if (vma)
+		return vma;
+
+	/* Return gate VMA at the end */
+	*ppos = SENTINEL_VMA_GATE;
+	return get_gate_vma(priv->lock_ctx.mm);
 }
 
 static void m_stop(struct seq_file *m, void *v)
-- 
2.55.0.1007.g17ff1f9808-goog


