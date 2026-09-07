Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAF8C79FAA
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556626B00A5; Mon,  7 Sep 2026 02:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507B56B00A6; Mon,  7 Sep 2026 02:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E4F6B00A7; Mon,  7 Sep 2026 02:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07FE76B00A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:39:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 682C4C066C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:31 +0000 (UTC)
X-FDA: 85186014942.25.875067A
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf17.hostedemail.com (Postfix) with ESMTP id A37EC40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:39:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KWaf66Jv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3IFyeagYKCK0fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3IFyeagYKCK0fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788763169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l82YwPFJoqBct/wpgBVxgb9B5/Qm0auI8Z1CtPsM/dw=;
	b=dLudYTJPnK68BpIao54nVpGcBw7ZSKxcTMWvvfT7iNFimVQf+y32OzbTcSkHvNEMQS2czb
	WQXi6gimD5iiLkIh0TWKPctagax049Db+PhPOPj+FEHMplRGWcw+WDxg4VwNPBUzKG2EbH
	/J/3OgMU/NxFoi4xZfLzuKrVrpxkI+U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KWaf66Jv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3IFyeagYKCK0fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3IFyeagYKCK0fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788763169;
	b=eKWNXoHs0CJcSvZ2WuC9C7113/OmNlvh7J7UHdqdFUt+mWxGTsoJJS8ZQgXJV5h7U6BdP/
	tYrOxPkDPGZwn17qSOPAoTGoKvVjYVxbTQvNKJ387lUrog+COSwSnqL0pkSQ7GB5KcYBmR
	8W9SXJ31QrHdQt4Sks/5CmEX8bt11o4=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-398fe469aa0so5291543a91.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 23:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788763168; x=1789367968; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l82YwPFJoqBct/wpgBVxgb9B5/Qm0auI8Z1CtPsM/dw=;
        b=KWaf66JvmTbbTFbFrx8Zhe/wtBsEF56Q9Qu4qsp6dS25NgmNYswOUc0pI0kNycphtN
         fOxZGhyb++gEeg5r7/srXRyoMgT/bq5vL7s40462C1Z2X2KnrkaX25GryhlLI4OX+HHZ
         P/SXfjwIDAHK1E8YDa6uOLaEBzOyLR/zWxV2O6haxSkmuTS9P3GHukMgHpr+cwBDVPnT
         fpudsxuqQO8FNL9zXk3x+krDof2tSeqvU9+mgGdHOL3AvdX6nzRxEA5qh/0UyXEGF2yl
         qJT/Ya7sX3vzgN9+iJDQAhlrCcw9pos3KF4fiNQ/0wKnFzwZ2ytVXyR4Vx84bDdDCVlb
         LHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763168; x=1789367968;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l82YwPFJoqBct/wpgBVxgb9B5/Qm0auI8Z1CtPsM/dw=;
        b=GjMKmcJc1t/KaQVr3O1V1RvwNHYH0sxLk7S59b07S/LhiH/YpKo6ySNIjFSwpcj5c2
         GD1RsxBiQHKMrpnRfZHCYSFyDxC1lil/tadd87fdN3TKQ/c6qMM2cRcmBNM3gKHMDxFL
         JrHJZvllTpOs4p64QAPsGkglGe3VA1YZKM17gpDQ6x+GceEfq+9KagQdIqqbeCum7giT
         0PpWPx/94o0ICwlt8HwPWFC90VD6malWBDWhYJvofj2pCLL+DTv5toP4xovjVgmzsG/i
         LENPZyrKbTitWwqHYCk2NguNxA4ffPGS/Gq8e1AtHab/LTXxvv8e1PZbrVHiLKL+1uGB
         PlYQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjeAoHsqouxHeZ0zqFml/1MQojQcjbbteZNwm1/oFk6dFBUkNzZXpWbF4cO7nmrJSxKusG5aok0g==@kvack.org
X-Gm-Message-State: AFuF++mrhos5N5rVHC99MNe+Ok3TCT34pCrqrlgRH/x1JDaPME7SJ4wK
	IvADzNvvnjjyWBFCYyNblSl2LvGwm2pHoCh30R0JvXQCeuzBp0K4BvahxU0qIz2qzmJC6F8mK6w
	ZdUobwg==
X-Received: from dyjo27.prod.google.com ([2002:a05:7300:339b:b0:327:c2c1:f06f])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5866:b0:398:e73e:5a13
 with SMTP id 98e67ed59e1d1-39b2613272amr31362696a91.9.1788763168352; Sun, 06
 Sep 2026 23:39:28 -0700 (PDT)
Date: Sun,  6 Sep 2026 23:39:16 -0700
In-Reply-To: <20260907063918.3432401-1-surenb@google.com>
Mime-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260907063918.3432401-4-surenb@google.com>
Subject: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mygzgk711oa3tdhfhbxukt83b7g19iko
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A37EC40002
X-Rspam-User: 
X-HE-Tag: 1788763169-915709
X-HE-Meta: U2FsdGVkX1/eYLepyBaCUb9mVe4jq8c4EZEBjKz+/IUDNiLsMa0SRwUlOXJeXnqW9Ps/N8e5T9vNwtLbQTMOiZQbPqkHXMggpPlwsGpN0h12pN5poqFd+PerHW8MHc6HoQTy+j8osN7w7Z5onz5oGI5oEtIKqXwfR1flhPd3qi9BRFZHlY7QVtuLxlNn32gTHPbrznebkF9F9F31W7cvrO+Z8Uu0ji7W/XDFA12QTdwSBgYDCSGrLwpHyVQz4eo32OV4S6qwvchYbTiuc7sm6hfd3hYZzhtPIGeFYam4aRZsk9fAk6TYyPUTU+WOyGKIdYLLXkkPjTKIB/lFRo0RtLS6sVXObBW0b1wAWE3p2MDirobyF1Wt5+QjXEOXL2341yn59iQO5Y1ho0CmhgIJq2R0hQpNgolv6RW2ymdK1n13QQK4ekX1fZ+9rpaGnFvVQ/OOeSMEDtQlu8qEa7jTijSlKZCrTdTlgTUuTqLBBiZ7E3nO9wzEweLDuE3sn2cT24M8zhyC8FR/VbL5lUBA5ySfKx2F7begCmE/x0VwTVnsIdXumBfeUOUj6UVXkq1JWoBirkgNGCd4aTb0wK3pnIQXHNyS7hJlEHdWRl8DVgmhSHouRX2BvYzjaJGdW7FND6qMVH5K7xPghTjiEmp5+1byS4UiQtW4RgVQ5wuX1KXhGP50Opp97IHm1tkJhUVpC4sm98nO3bEQdo15l7MFNdWJygvBYvlvneAldYeBBzIJhT83W5QFhyOjnZqmngk2dGiWeA9VgibubQDDwxr9Jqj1oA4AzZD2GG5lLwYhSVI6wcfJfGFG7xWwdOKZIl8O4VJDQF+m12refvYyM873zr5KQNaQ917EsfClVi7GTuhgb6vmUWYEQKzBB2CjKElnuxDt5tbnJEoxdq9ceR8qtEH5Bl1+GpXPQq5BT/XT0jJkQ/elJ0X1eOfPcum9Gxdc0EfbkKe3Y4hy7ibjI//
 zkHWFfRZ
 kEApPTN8+qGfdf2F4jsCbVuUhffEnMGXb3WYbpNWGjbh+cTtVIYx37br4F4Jo8vmV0jKZ3Dn0Hyuigz99HTBhJ3DX7FH367ZAU2XyGQo84JkQPZg1uk3NTOlX5Ob386Iq7dAXSLbqHKtES2HugxU6SiEyI1MICkk1h3MxXOGkvud7QtUpbdvsvYXMXTKXByHExfqZRrU87mgFdi2eigY25HnpQOivb+wiGuQra4Y02oaktQoBS1c9n4sQccRxo+zAd6tBUNovdCs4yfmLU0b45pKyn45m1ZFgO+DOgx9gpSQXAbxvCsJ8fIutmwsIzHoD7dP+XFBDqa9nlFhKwdqxuCaHo27N1sdjAc3ZwtT3Z+S1e5NGhwpiyRvdVMhPX8pgQke617IqolRUQB68zJQC+LkqaYiNKtLdR8oQdRk4q9w624OeYFY6gpCLunsT1JB0d8h0cehwe4vzB2SSthG6DhRxm+Enon7kt8WEv8sDWylhjhrpw2+w7D6JYBLgTbW40ejaXwoqfq5X32STYvoDlxi6iO0cHkJy4Pzn6iREq8QvEbOc745VAJm/pia2F6DrkGUcz9o1eGgOtoE9K7DOjNEbJw/ihRUgIeuuAmQPSEHNW36lZNc+GW9yb+qTEmuXH5RU56fFEj0BTiI0Yn3KA4CDFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smap_gather_stats() interprets its start parameter to mean vma->vm_start
when it's set to 0. Eliminate this special interpretation and pass
vma->vm_start explicitly when needed.

Since smap_gather_stats() operates within a single VMA, we can replace
walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
which is simpler and also can be called while holding per-VMA lock.

No functional change intended.

Suggested by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 9908ba32f180..3351decd1172 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1246,20 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
 	return &smaps_shmem_walk_vma_lock_ops;
 }
 
-/*
- * Gather mem stats from @vma with the indicated beginning
- * address @start, and keep them in @mss.
+/**
+ * smap_gather_stats() - Gather mem stats from @vma.
+ * @priv: proc maps private state.
+ * @vma: The VMA to gather stats for.
+ * @mss: The accumulated stats.
+ * @start: The address from which to start.
  *
- * Use vm_start of @vma as the beginning address if @start is 0.
+ * This gathers stats for the whole of the VMA unless the lock was dropped
+ * and VMA grew or got merged and we found it again, in which case we only
+ * gather stats for the remainder of the VMA range.
  */
 static void smap_gather_stats(struct proc_maps_private *priv,
 			      struct vm_area_struct *vma,
-			      struct mem_size_stats *mss, unsigned long start)
+			      struct mem_size_stats *mss,
+			      unsigned long start)
 {
 	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
+	const bool is_partial = start > vma->vm_start;
 
 	/* Invalid start */
-	if (start >= vma->vm_end)
+	if (start < vma->vm_start || start >= vma->vm_end)
 		return;
 
 	if (vma == get_gate_vma(priv->lock_ctx.mm))
@@ -1279,20 +1286,17 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 		 * Unless we know that the shmem object (or the part mapped by
 		 * our VMA) has no swapped out pages at all.
 		 */
-		unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const bool shared_or_ro = vma_test(vma, VMA_SHARED_BIT) ||
+					  !vma_test(vma, VMA_WRITE_BIT);
 
-		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
+		if (!is_partial && (!shmem_swapped || shared_or_ro))
 			mss->swap += shmem_swapped;
-		} else {
+		else
 			ops = get_smaps_shmem_walk_ops(priv);
-		}
 	}
 
-	if (!start)
-		walk_page_vma(vma, ops, mss);
-	else
-		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+	walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
 
 	reacquire_rcu(priv);
 }
@@ -1347,7 +1351,7 @@ static int show_smap(struct seq_file *m, void *v)
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
 
-	smap_gather_stats(priv, vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss, vma->vm_start);
 
 	show_map_vma(m, vma);
 
@@ -1400,7 +1404,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 	vma_start = vma->vm_start;
 	do {
-		smap_gather_stats(priv, vma, &mss, 0);
+		smap_gather_stats(priv, vma, &mss, vma->vm_start);
 		last_vma_end = vma->vm_end;
 
 		/*
@@ -1459,7 +1463,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 			/* Case 1 and 2 above */
 			if (vma->vm_start >= last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, 0);
+				smap_gather_stats(priv, vma, &mss, vma->vm_start);
 				last_vma_end = vma->vm_end;
 				continue;
 			}
-- 
2.55.0.979.g7e5102b832-goog


