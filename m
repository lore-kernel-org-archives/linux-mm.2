Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B7EC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FBA6B0099; Thu, 10 Sep 2026 19:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1696B009B; Thu, 10 Sep 2026 19:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A956B009D; Thu, 10 Sep 2026 19:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE8E6B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:47:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFE44A5354
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:54 +0000 (UTC)
X-FDA: 85199492868.25.EDC5681
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0EB081C0008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VmKPuofU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3p0GjagYKCBQCEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3p0GjagYKCBQCEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084073;
	b=xfpnct2rT9AUxqtJlzpkM2wwWqVLvZ57HzaHsJC0V+T8B9ppQbkvONrZ90mDTt5PTRGN+d
	N1nsefOy5HZCA+ZLFYJQYIMAll8O0iYuXaT9SyxiVSyxu2um1CVhN09kWMU/JopYzcHE6J
	lKV4VtfbjeBoqNjPkhM65vEIqYmxxm8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VmKPuofU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3p0GjagYKCBQCEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3p0GjagYKCBQCEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qU0KV0gIPZqolm93iR//P4qXqNLqAOfvp4joEi9Yvyk=;
	b=KtFIUm4wClA6hU3xVV+0pKX4qCyZo5dk5l1PhhyFrZVsd8lBWFAv9C/9FKs86T1p9NEODh
	ENXoJEJiR/crxLTwMXW0iBxHzbAHgzklJhfheeYw93LmVQapponBHGJohSWN5n1UFMTYoP
	L14AhXsJDUP887dhRcjV4AGNP9Rr/CA=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-385d2703b64so1684390a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084072; x=1789688872; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qU0KV0gIPZqolm93iR//P4qXqNLqAOfvp4joEi9Yvyk=;
        b=VmKPuofURc8LYC5injdiPysNQN0BW3gVaSYOXfbsUi4yQ5YpgG7xSO5KOMnHHgbXEW
         ixY5gmSvyh4AlRtaucQ8d4QTy2z4DK7uQP3Yi86nOByPxgrXoP7MxyOLECilw4K7rAr+
         UVkVCm259cms7T8t6PUmCnkSP6Vtayy25y+8J366FSPbGmTN6Dnh3X+pXehkd961Ljgs
         h/nAYnqyys2Q/wodGUzi3TbU5oR9LR+ukWY36NE/kAhqfCeLq78/M9Scg8qqMUlgVzVJ
         TBo/WznhOkwBb8luMq65j61x9NykDZKwz0v6U2NI7GFTIu6rYXtqFAm58Lu3KhQ3Izwy
         rs6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084072; x=1789688872;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qU0KV0gIPZqolm93iR//P4qXqNLqAOfvp4joEi9Yvyk=;
        b=JvThLBZjZWX0YIH3Kuqgv8TcxfnBm/LUqePCYrTFpCEH5n3qdyd8NsCwDu//GKmeSY
         NsfOLkRM38abaHT15hzg6VRgMnVQBbQe5D3orL4vNubjSJj9zewWxQppka5jIz88UH6y
         etjh+Km/NHvxYoYudigHPTI7/1Vb3jsABo90c149pB9rDqJEJn9LbUh9TpvioQd2jPu+
         ZHDQhaZCS9+O/fz4noJWULVUK3U48BbFnCUgReeTjKKhMKKnIhRK8Q1DZvKdkhsJfkVU
         XLkwtnZBfSJHvRPZa6JPcpazHcZwsurs4+FtHPrtR7rO//rGjHCd+cJzKQ2QqFXMgWGp
         CAcQ==
X-Forwarded-Encrypted: i=1; AKwUvBwUCqGHdrF3Sata2xGJfJYlhTESfa32rUHrZ/v4YIMl9MrFJTfMwvnOCfS80LVcd1xh0td3nlm5Vg==@kvack.org
X-Gm-Message-State: AFuF++n9hMkj8VUoJWNF83Zl/8vSjaUqevAtyUmMXh27y7tNjj4x1l6y
	u+1mjbKGuMgVFFFHCT6n2/AuIr9Ej2F6CivW6aDJtTGTbgZNhnFeAw330F5KnoUuldz1UCarcDz
	MzIPuFw==
X-Received: from dlbbq8.prod.google.com ([2002:a05:7022:6708:b0:143:6807:5e3b])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c85:b0:38f:cfe2:fd3a
 with SMTP id 98e67ed59e1d1-39d77b1c383mr8988591a91.15.1789084071601; Thu, 10
 Sep 2026 16:47:51 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:47:34 -0700
In-Reply-To: <20260910234737.1340642-1-surenb@google.com>
Mime-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910234737.1340642-5-surenb@google.com>
Subject: [PATCH v3 4/7] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0EB081C0008
X-Stat-Signature: 3p7ihi5f9uttoz3msnfomnuyrcg8mi6z
X-HE-Tag: 1789084072-908130
X-HE-Meta: U2FsdGVkX1+PKztJ3LdXo3q947ot64AgdToiR+gpMEsWeiAxuxj3hIWrKOBQMh6sb0M+6CFfF7ctFPn31i9y3l+C+UMC74SEVQ6FTTXQXvMgnGEKCIuaRZi7klESU30K40QhQ8wBkLWbyGWO1cFYFdcPisMxJP7kgAOWkI6+Ooh/GOnW2UoMlAyXpPIcjQKWksDY5TCp87bEn79fPmaDn1+LtNzdEt1rIpfsKUmtj97jukqOzt8/bWxHH5ImmgJ+09Hz/ImLZQ+pgdLqpF2MR/AE0HBSTb2gBF9qxSsItlGZlQbOGIyR50BWMo3Ks9gh8P0exrZt5mV+Sl2JwrQ6qscZpg5G/b+rn5FQAKYbnG5D7NouBv7FIsRUHIu6w/u8fG6eHYC29Qj+irlKdySWJrPmMHc5Nfl5H3Uid2kl4C0bmV8sSK7sAncZLNIZnLkyQwS2i9uNvge4UDR1EXvQydjtrIsDBZPqhug4oLXzqqVYwdRBD/qlQ6hp9YHW6PB/Lk42LvNZWVvmlTmGRLSf7z/Yf0IM+kivM/kHqzbpMIdkqaydl8jaIxCw1lT0HHfc8AuYb2vDaGP5x9YrM4As5Bfnj+Ba08b3Cx/IEO3YF83zv0qJOH6sy9RgDb4f33vmLDcFWRBCNJe4IsB2HsDhrS/boZj7t2lMu2RMbWCEjIMfb/wVJ1T1T8AgkyQ5X2WmkMO6pjtQJT6J8jluTyPIKmYcADYTUVUBCyiMvKqgfHgAlZ4iE2IfnP5KSFFIy2HXJmLCE0ylwpzyZgnMHbEeU6IcwGqyFMQsgRXU9Wi5xn3S7nJwXhYzQ/UFtWRKu2IRKqP6JZBw0c4tUXroKmLV0gdr5cbBQJdjVYnhmcuNFAmuDN29sJoV/WeV/GxlIQaQNwKycOFYdh3QpCnuIxUaPkNuWE+vdjmJgTcR6Pb1CDoleKE4ESLjonZjwbrVQjK5ml7v892LH0j7vDmwr3W
 en9XAfNW
 lGBvesfyAt4mLM+lXw2AYzusET5Mx7knRhswa82D2bjgXXo8yFjnsTaqN6wLYZgV1inwQ8ZIWcIezlTe5AhPpjI/WsPx2R1qDAJZJWyzqs9ekgsCfur8VwsNEzXnvKT1GK+iKI9jI+BUzWTFhtjURwfQfD26NcnstENaMmkeRtCNYb7MVTAZkzVDRXfl+wjDBMCiss7b3XJ7ZB0mDXXDCXSspGvmhm6sSc1uofSo1WyQGjV4jnd38PQwYpu4vHrIlMuQMGz1eh+6sZ0u4s+7pJnPoEgOWtCFwM1fwloVCvvEPcy0eZxi4OUN2FSaFDmTik2z2M1XFOiy+J7vHFXe0to5k48tMvcotgNup1RuOS9KGZqicRa2Ugg2wSkyey+AHtDuyoPsQRkSE+H7Mo7N9DQ4QdGTVfINOBZAXnpKfUNfyXPRDgPR2VC3CxVMdbFg+38vjnlXP454Z7XjlALDlVsqRbebH1KY20z8ehAwTF2x06qafelDXmSCl7jMFjwarz+esuITZd4LNfKUMfWSlj8MM1pp3ODwgkSD1HqLtS+poAbrNGCyRiJThydpCVo8chQCQPuhLv0onQ8J/Lb2G4TuAJX6GrJRVPH6eOQ8eCZYnrPEF9XsvKPGZjRNzsiDVypHD3kQ5JWhFO3c0kfqIO53x8VYIKbIDROH/Jlkt8Fik6ZOKQujPtpncuIUsf9AICxScRHXNtKiQ54FnJzBtALT6WQVdw154lwJ3M6QsDvPwLFMvpzzO/uumRA==
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
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 fs/proc/task_mmu.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3c40c9cbb9c9..ecce7ce116cb 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1246,21 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
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
 	const bool is_partial = start > vma->vm_start;
 
 	/* Invalid start */
-	if (start >= vma->vm_end)
+	if (start < vma->vm_start || start >= vma->vm_end)
 		return;
 
 	if (vma == get_gate_vma(priv->lock_ctx.mm))
@@ -1285,10 +1291,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
 			mss->swap += shmem_swapped;
 	}
 
-	if (!start)
-		walk_page_vma(vma, ops, mss);
-	else
-		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
+	walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
 
 	reacquire_rcu(priv);
 }
@@ -1343,7 +1346,7 @@ static int show_smap(struct seq_file *m, void *v)
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
 
-	smap_gather_stats(priv, vma, &mss, 0);
+	smap_gather_stats(priv, vma, &mss, vma->vm_start);
 
 	show_map_vma(m, vma);
 
@@ -1396,7 +1399,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 	vma_start = vma->vm_start;
 	do {
-		smap_gather_stats(priv, vma, &mss, 0);
+		smap_gather_stats(priv, vma, &mss, vma->vm_start);
 		last_vma_end = vma->vm_end;
 
 		/*
@@ -1455,7 +1458,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 
 			/* Case 1 and 2 above */
 			if (vma->vm_start >= last_vma_end) {
-				smap_gather_stats(priv, vma, &mss, 0);
+				smap_gather_stats(priv, vma, &mss, vma->vm_start);
 				last_vma_end = vma->vm_end;
 				continue;
 			}
-- 
2.55.0.1007.g17ff1f9808-goog


