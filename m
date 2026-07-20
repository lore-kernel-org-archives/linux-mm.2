Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7598BC4452D
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4456B00D0; Mon, 20 Jul 2026 15:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B836B00D3; Mon, 20 Jul 2026 15:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967D66B00D4; Mon, 20 Jul 2026 15:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3B76B00D0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:36:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8C471202C1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:02 +0000 (UTC)
X-FDA: 85010160564.30.B95B2D7
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 17CB3140008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UP7p0s8g;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52AwKQKrQ6RLG5kuFGfqaKwjxS+9GOxT3lcLnMmQsKc=;
	b=EY78SgQygi0JNu6rnDdGsTlHDRBQ1CAmBgDHu1ADNELGNX9bR4Q1296XjDY3EYweqaZwbS
	YH0bRxJACJjGMEtseix1A9+sroUxY9boUuE7j1OEidHFxx2GQquO6ARP81Nt6lNI2t1yiC
	YcQTip2fzmq9AkkeAIZMgdMbvQK5eEA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576161;
	b=Gymofa6rPKTdCAN1yoqC1UclnZ5SjPqy782f4WQUIvQXtjfIKWxqhtPlks2MBynsEXUd1U
	XPZ4uVRTJLRAl9Meuds2NrpzwTjcjlcSrECXNVxD94SjrJdDrjrUcJKThTa5+T/7BAsv4i
	5f8wC7amVQ+KVMtZGuwnlQbrZYU0fs0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UP7p0s8g;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e7c6ec9dbso548917185a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576160; x=1785180960; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=52AwKQKrQ6RLG5kuFGfqaKwjxS+9GOxT3lcLnMmQsKc=;
        b=UP7p0s8gJHQdSyQ4K7mts2vYLYbmYPBHgIqJh4Wgwwij4bMuSWtLxw+yP08KGUNtc4
         my1Ma629Lx8RQ11VqBdHkeZHRqUbmM2nTa1OxMgpDyPKie/BtFC+C8yIkIWVxrwHhUUI
         h8jbc9e/D4/gxd0SWv40EDXOROJOuDAt1CW2vkX5lcwbjGLOtZn67UeWeNpmnWbPF1bb
         z1VKqpjbweKW8oix233IRJBzZeHWr/iMsYzccH4QEZ1C05y3Qsh3MCiYxbL/PODdh0OE
         4AUfUjwmT6wEHAE/CFwr/deJmZyN9mYKSnyXOb136vYxZPpQdc6SbJKwvoPQhnI6C5Mz
         O0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576160; x=1785180960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=52AwKQKrQ6RLG5kuFGfqaKwjxS+9GOxT3lcLnMmQsKc=;
        b=tQz3Fb+j+BOdyy6G5r/l91x8OMrU8xvNlbN3vgy95SUmtQpdWYu4tSC1bE/6d+g7QK
         roRhucZVafma/FClLVxlrffqHZYjefc7tfU+wFjr99shR0RJ3HwtqAI0Gfj6cJG3I3//
         FA8/wB4FzI3QKGrAO/VxZi/7SRm2NuaWa8o1+9brypMvod4hae3KnOIzFhqT80oXwsl3
         UHG6+jf1c2Evg8ArJ8uUKkqp0BXXzIPjmGknEqTSU20+3Qc1bId889SB75qfHmAqllF5
         6M1RXf3xxuWsMBFkqYw3xPs5t6TvwCie946oDFj8GSvT5i3g5+U0e2b6Xjt6n1b1RWAR
         T2GA==
X-Gm-Message-State: AOJu0YxEp4Ci+8NI6paeZ6d9JUKqA2bnAd47Y0alvdd2w4cz8IY3aH3Y
	AEkvx3SbOFQLPaL4W/JQQCVvzHFkEUD2SBFsVTY4ufcl1pBH6rBJuztSbjiWUKHNUSkBWZq2lPY
	o8MiR
X-Gm-Gg: AfdE7ckiJH7fFh9xmXu78N4qJth/BCNRN4pJXft8b0MOFm1mrkj05oWVy9Xzf50pVYR
	pBaIwJ5ONMOj/mFzD1t8XtBces4nh+795/sVYxLux8og8ThDOigymdL1BODlA/YhSnBzFeKMdDh
	EnHSVNLjWldYEBKgORHEeG4A6ANRZ1gL2UfQT8QMma3VRJL0HT/ItBaRH2g2B5mdTkiU8qR3uoV
	QP2gBKnRac6AL9Cit+4NKHmbMm3LBr1Q6YTYxuLjVvU2AUg9F/rhQaXUkYzGHIV0bSJWrQrRA1w
	YFrOKhRrtxRG6dO3W7wkurK99cb7jhkZgeOxflinAsqaB3EXP/jZKKG0ecqwn1msjW55lOjhmkw
	nLgM79aZ9jgxpu5aEDexs8GqdZDEyPgll7c3NrWktxyKcGaSapjFgENDDBBz13cj0YOV8cAshcT
	d6v9ipjV0BZ1DeR/NpaNMLjOl376+ZcmHoJ53N4qg05H+PsIo/tz1gKaIKfY3GJr8=
X-Received: by 2002:a05:620a:4095:b0:92e:7467:fea0 with SMTP id af79cd13be357-930b3ed66d5mr1519423785a.34.1784576160054;
        Mon, 20 Jul 2026 12:36:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:59 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 31/36] mm: add NODE_PRIVATE_CAP_LTPIN for private node folio pinning
Date: Mon, 20 Jul 2026 15:34:25 -0400
Message-ID: <20260720193431.3841992-32-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uisjjhraag1iwcg6d6t3abgetjq8gcwp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17CB3140008
X-HE-Tag: 1784576160-82959
X-HE-Meta: U2FsdGVkX1+dHC6UhFd73YlE9LqYUOdqAO1jGahRppKEnMZlO740x+65jY4VFpC4b3afmzxO7ShtE1DVbStVrzucN38+oich3mx1lLekD1KZ0EULd74vDY+DcjJIig1wVOh70PWI7axL+HcZRGHcH9u5kI6SF7jzAFcYRX8Jd3tpqGyk2wc+NoFAgksZy7Dv5L+t0NrK4A2Vk2RikhNeYDZUT6wykUmlfP5GvfsCsRnY27Pvv926+1SmgRJc5nigmAAYKJ8ElEU54u/G+B3PRQxTE6ye5oz+ktm9ppez4yF5Oc/dfQlvI4v0u1HCaR/LJ9MyQPCjQmK0Qoo4zasy+C8BUZlXejAF3A7DA07CyO1qIWnNKJMnz5Iqss13JzOFTMLJ+wU4oR9kj/LdywUra56XbGpu/ICHX8ifBLh9wOj40rSN4T0rdW2N7Owu2hnPe+1KePaX9G79AXHkXqzPt4dU4tmP0dBFs9QHbPfm7dAFExjBmWBvZtAzs+Ha6PPw+ewaqCqdy1eh5wzUSRONubyGVm+MNjmgjJ2HUAFDFnVMBXMzJztJErpuZuQJHd9wjXhcfX2g0K18Brj5gzWyP3RIF8i4W1NYW8d01Zupl9xkSUSad5LfJ0yNH9SZWuh6SqjZ5ghJ9V1/iGOguprjj1QpQ8Uq5FBgDCAkr9uz5MlVJ6LyGAbQQYEA4hmBVVQx8SjeLHIjBBtY5AkctjN5E0TW+xyIUboDx4BtZ1Qekszl72s026nTVaV4wffc5u+WCbOuC4gUm0+O0AHNyWyK9ssxe/jTsuYLOczWA7PQtR4jaqJW93Fzfh/QG2lWtfQf6QSEfyWMacigR8IMdcj9miSpgXzGVCi7yXNVlGik1FwObN9zwXI7ek2KYaEUPgLYurd9aKqlQnOV5xZDaiqK/B11BUwQ4qUVGJ0Xvw/Y5JIU4zp6jJbOqFgVtcQwalb1Vq2nRDbePVWaN1UviR9
 Hs7fhgs8
 vAzSiBjNJeMeD3tjGB/ziwQ76pNXLi0CLE9FCMbM4zvCmBML61FjSQmd1IiRxz4epATeWnkKupvfP1i+u5hVjfb6vjEtYPhgpI0hl5DlMtZRZXPOIgsPkED6qQsANYlAs06INKtHtpINt9j4h/MM8BKividqcc88lk6koGgiVPlvyvPwGT0MKt9NCZtcDV/BeZmKGb7adM5ks7841bvL7NKZKo4DZGFlMQp8UuZ0OD4kXWlxYgswlC/lvFwFah4JMD1tviBzNHGmOcNz/npHevzxfr1OhjmkUxtzr/dF0aiiWif06C4x85qIIaPlO9q5XtkVdQQrcZtNIz84xYN+SR1xV8uc1OSYuPBKay4fmKvWj0TyC52jkMYXNu1OqB0zQskWCwHB9Z+oTwfCejL+OalVFAoXCVmFkl0b7d0K/QPLSs2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add NODE_PRIVATE_CAP_LTPIN so a node can opt back into gup pins.

An opted-in node is then pinned exactly like ordinary memory, or
migrated and pinned if in ZONE_MOVABLE.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 29 +++++++++++++++++++++++++++++
 mm/gup.c                     |  3 ++-
 mm/internal.h                |  9 +++++----
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 5c3e070ed0deb..6f568bc0d46c7 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -17,6 +17,7 @@ struct page;
 #define NODE_PRIVATE_CAP_HOTUNPLUG	(1UL << 2)	/* allow hot-unplug */
 #define NODE_PRIVATE_CAP_DEMOTION	(1UL << 3)	/* allow tiering demotion */
 #define NODE_PRIVATE_CAP_NUMA_BALANCING	(1UL << 4)	/* allow NUMA balancing */
+#define NODE_PRIVATE_CAP_LTPIN		(1UL << 5)	/* allow GUP pins */
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -167,6 +168,29 @@ static inline bool node_allows_numa_balancing(int nid)
 	return ret;
 }
 
+/**
+ * node_allows_ltpin - may a folio on this node be long-term GUP-pinned?
+ * @nid: the node to test
+ *
+ * Opted-out private nodes cause longterm pins to outright fail regardless
+ * of ZONE placement (NORMAL would allow, MOVABLE would migrate first).
+ *
+ * Opted-in private nodes allow longterm pins to operate normally.
+ */
+static inline bool node_allows_ltpin(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_LTPIN);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -209,6 +233,11 @@ static inline bool node_allows_numa_balancing(int nid)
 	return true;
 }
 
+static inline bool node_allows_ltpin(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/gup.c b/mm/gup.c
index a7d4de223785c..1e313aa590bc1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -547,7 +547,8 @@ static struct folio *try_grab_folio_fast(struct page *page, int refs,
 	/*
 	 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
 	 * right zone, so fail and let the caller fall back to the slow
-	 * path.  Fail for private-node folios here so slow path rejects.
+	 * path.  Fail for non-opted-in private node folios here so the
+	 * slow path can reject the pin entirely.
 	 */
 	if (unlikely((flags & FOLL_LONGTERM) &&
 		     !folio_allows_longterm_pin(folio))) {
diff --git a/mm/internal.h b/mm/internal.h
index 01ab8b32b0bd8..9621eb127c28c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -146,19 +146,20 @@ static inline bool folio_allows_numa_balance(struct folio *folio)
 static inline bool folio_allows_longterm_pin(struct folio *folio)
 {
 	return folio_is_longterm_pinnable(folio) &&
-	       !folio_is_private_node(folio);
+	       node_allows_ltpin(folio_nid(folio));
 }
 
 /*
  * folio_longterm_pin_forbidden() - must a longterm pin of this folio fail
  * outright (neither pinned in place nor migrated off the node)?
  *
- * True for any folio on a private node: such memory can be neither pinned
- * nor migrated, so the pin must be rejected with the folio left in place.
+ * True only for a folio on a private node that did not opt into longterm
+ * pinning (NODE_PRIVATE_CAP_LTPIN); node_allows_ltpin() is true for ordinary
+ * nodes and for opted-in private nodes, so this never trips them.
  */
 static inline bool folio_longterm_pin_forbidden(struct folio *folio)
 {
-	return folio_is_private_node(folio);
+	return !node_allows_ltpin(folio_nid(folio));
 }
 
 /*
-- 
2.53.0-Meta


