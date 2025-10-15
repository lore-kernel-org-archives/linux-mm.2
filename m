Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414DBCCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 00:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3368E0041; Tue, 14 Oct 2025 20:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38AFD8E0005; Tue, 14 Oct 2025 20:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7718E0041; Tue, 14 Oct 2025 20:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2C48E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:07:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C28F6BCD66
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:07:05 +0000 (UTC)
X-FDA: 83998408410.20.9BEB6CE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 08B5A1A0012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:07:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ifBkovTH;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760486824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yXPxuwObJkkCRWy8ktvoowrkbeuhTp2+JLZJZCgaOMQ=;
	b=qPuGTQbmFTYtWnn4C8CvLd40KFHVy/bx25+ME/WZb1qSMdZzBJzM/b8Eqt4W4uXdMv6w7W
	oY5QNMNGoIeWLrAiU8fjKiox0YZytWg1791fD315MFu98S+wUMdzXIjUa6wARMEKt//BX3
	GryUu+GCy+9ZWHi/9X1ml7IVV6IiQEo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ifBkovTH;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760486824; a=rsa-sha256;
	cv=none;
	b=LlnuxJj0pJcpAMs4p8xrJ8Mih0ww1TgmNokVcN2sZSQp8yYXIu1z6/FN0wYC/9MjRFik7b
	mA8GOFsUFdiZBC/fyW2cmd9K8c9TpEDnu4Ow0nH/jw9722/ULZpSOpvS6Lgn1VY98/rr8i
	FBUyRNdpNz16ah8D6Q1ZN2RMGZZMdxY=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-781206cce18so405341b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760486823; x=1761091623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yXPxuwObJkkCRWy8ktvoowrkbeuhTp2+JLZJZCgaOMQ=;
        b=ifBkovTH21kT6PtR3UVuMmQExJzn1o9VAaj3jGKZOedTQ38O+tCq+YACaW+tafZE75
         gcyMk1iHOagQSIQ4e6Bw/y+qCRiMnix0r8etKnduKTBQ75ERUI+zRs+2JpyGa9EyZuLt
         559okCSNXhw5dIxhOxO3Iw7I5gt4ZvcsS2KN6t2+3/4cFVOYHqUywzdey7ObD0gHKKxN
         FSqHDPmUbCm/7qB+QUx8H0DB2oK8P7EU6GvzYIBzB6fFGwvQGX9sT+Z7UWp53v8dmUWk
         xFKOsrcunjaZLhMsOlMLibHyBTqMZZw9ESXCKfyWoywPB2o9+i1gtKqh9iWYWJLzAkU1
         ThWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760486823; x=1761091623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yXPxuwObJkkCRWy8ktvoowrkbeuhTp2+JLZJZCgaOMQ=;
        b=YxNMbXaJYzo4sXtWCo/r7tGVFbRULf2wYTFub3nnQR3oWTozU398gZK9YSOaPOf1PA
         Pf61vpdloWEWY+Oj/kzwd88/S2QLh+NSryLVcKMBEmn3gKzCNtJrW5v9U4TWUaKI37Tj
         wnPEXRwk3nlkVv7rI85GR83zl/Kcf5PnDRmyCeSjAkfFDdKDCWvjcGF99oKC6cvtt58v
         9rWFvQddc5qIgZPo7qPRkAeT0An2GOeneWXyFPVr01Y4drNquKXf/s3WHdLHtiYFpJwp
         ZNvb3liZPCcCYCOTSvKSwLjMrUkX60insRF1I9kI42hKlb8DXhAQANnUw6vHxb9axd+K
         uzYA==
X-Forwarded-Encrypted: i=1; AJvYcCVV63waZg+nXHvdjCCHNMY63HXs281okb8KMIEpc7Fd+GPEoPbuqeXnFEG5JfoaJTeck1r6wSqpCQ==@kvack.org
X-Gm-Message-State: AOJu0YxO/0ADvwaTDCQvB2QH50vT7Vl1gGoNF9I/qP4f9FztKcnxRH/1
	K7qjThSslWM8e05KB0jKGQuBUWNRQhHnoroL966iHaAEpCg7uBLMdllA
X-Gm-Gg: ASbGnct0XqQySKiyJchdZb1W2+RV77hveYFl2Y07ATLfNDjR9MUjAtDstGrdlTUs8Np
	lvjx8+8iq8xJ6De8NEcphnN8rEwj1blgG/I2iZJ6+X+Fi2XhbhPqskcMF1Qn1SG05rrbVBSVe8b
	tjY10g/fQ1vOdKBbdBZk84kLf16fieMw32DvUNVguKGVaKxEmKlogsYvmVXm9vppTLqodut3olk
	IJydVjS/zgKuhVvF/6hRSDYqdaQBRwlmUmHJ8Pi3LXr2Yoo1dqgf0TYIpk1suQ0tWFV9Uz75y1X
	OAbO7JHbwxrk+a6kBfn2CAyht0aE8TmznKRzk7PLzvf5U5sLm//dnlw1vJyJl8zwDy5GRjKKZCe
	/uTpND+fxk3AcXfULC/YpktIDgum5MF01qdO3lTxExLLH0hbhf/hF3zTD90FYaexfkNiGg0sTLz
	vsgIjc3C13AbhLFjcOswZI
X-Google-Smtp-Source: AGHT+IHd5BU73GIkW3P76RXF0BBUnl6Dvwja0oj9zpaxg6vbkP5JLSk159tuTRDYwjGLXwYbSXAsPw==
X-Received: by 2002:a05:6a00:1701:b0:78c:a3a6:a1bf with SMTP id d2e1a72fcca58-79397b19445mr30372445b3a.7.1760486822692;
        Tue, 14 Oct 2025 17:07:02 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837e:3c50:1021:a424:7dd1:a498])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d0e3f89sm16117780b3a.66.2025.10.14.17.07.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Oct 2025 17:07:02 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@kernel.org,
	shakeel.butt@linux.dev,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	yepeilin@google.com,
	linux-mm@kvack.org,
	kernel-team@fb.com
Subject: [PATCH v2 bpf] bpf: Replace bpf_map_kmalloc_node() with kmalloc_nolock() to allocate bpf_async_cb structures.
Date: Tue, 14 Oct 2025 17:07:00 -0700
Message-ID: <20251015000700.28988-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08B5A1A0012
X-Stat-Signature: 3ui89qbt8cusxi1z9c7e6tjxmqy4k4qo
X-Rspam-User: 
X-HE-Tag: 1760486823-369665
X-HE-Meta: U2FsdGVkX1+CYMlMeIktIW78cS2yPNHzgWA1adxCFKQhgtNVjQhUNOsuLjuD0EW1Ws8M3dX47w7GMDtQsJ7oUHnIf5yMIF7CQQE9IazQtrsrQjVQThsuksArmIWyaZrTEtQlT8NjLEZEf1vEL7joks44Wu+r1tu82j0SocwjWr1angw8pUvRRo1HniRQvWQvqY8x+DgQzP7/mB2B6XU2PXHheh7gGtmgFJHUhetrZA91FmjexixFrdPqjM12b76HQ7j/lEI0AjtuJuY0ssHrg3w7fZZAcVwGToo9/LHP4JBk5oujyD1zKbwkVgyN00S0g3oYbPZ2vzkwwIa2NCPFeccoDIgDmLRLCr5QNcJneIWWAJzLbBR2uGUBkLAGe5NXe4iVoCoL8Yr7xBowFcNLxv6/+FLHAny7vI8rZjzGQuGh8OkslStQwJ6UPXDNogEGnljOszuqhus81oRh2PhaOPddTNVi3htNEJpMX1xIoj9mEM6M5H4+X55/5gu37jJ7oMki+cxTydpFdmEzbbShTd0HCuPDQTkSgWHyuoJxH/931IKo4HCL8dmak1DmrVqCjpCV6ulCru9wh9D3jBNKTBnVXx6X5mm+WSMBXSLW7fyBe6My+JWOO4YDEF1LIuUPlkAeKPJYl8HIzSrL17gTbrNN0FYwYkuNkQfyS1M6HM/2nHD+b58oIC4FLy/w9SCqN01eEYVZCuBdwjd70N24pO9wcisWZQqxYE9lgObZUstUsCjjvhnCGKlD+AKDMtE1mt8Q/F0EulU3yven1dlgeZ77BGqExvplC9Oq5AAu+yVucjhE0uipI0pQN2JTev/8Q5FGpOBEKP9ufB+6jZO7MBPLz6DfYCbC9gDmgWssPcLMLj0RC8+Li7D/U1hhlemDm5SIvH2onCPndHMozBHqopwhboIgP6uTYfQ+Eb4keZw83jdGNU1XVcYmtcuqwzVzXwiEcYJvSn4cieQ2Iic
 yqkWqO05
 nCAOT9u9blxbmsAA9uYd2cZJm+GiDd7CAbdD0FjjZzo/+fGsSDwmTJvU2Pn+sSTakLoFP4m/AXR99MCR+3EOKBVSX+Cvlb/1Jdi18S/hI7Emo5f2hTzawxirK42u9fAvhjMMcrbjRm4PPA27KQsBNAjvh9HcOlf6oJ6ltzZfX1OkHESrDoK94HMWRkKCJrMOiywQSqvXtXMHOnRHTvNE8Z4h82LBOQnVhIB2Pn05DXM5YRBPA5PUz5NZvh4gkOkcR7eXWTTcg/IyM8QgSiXmvDUt8te4SPfQHltPMrjcBM18DvIrVR4feDBBiFNOCCMDvzgLBS4jZrfZLg003mCyNln8qMZaUIcVIhSNFbNNRWXG6Vh8OfW8GTI2vJAtRRBui/qnPCfR9PXeKmlCEMUrnKkOe7vFFQvyu8CDZR3w0Yq5dFTDVuqlEobcTBk3AxtUEE88jaIZGF/0XyOxuKT9QbbAlmX2l6CZ7W98cIrp1/+KOKro3AtoTB+OiqYae+9In/pvK9z7LASHLhwjl1vOavGjNZnmOzVYDEOaD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

The following kmemleak splat:
[    8.105530] kmemleak: Trying to color unknown object at 0xff11000100e918c0 as Black
[    8.106521] Call Trace:
[    8.106521]  <TASK>
[    8.106521]  dump_stack_lvl+0x4b/0x70
[    8.106521]  kvfree_call_rcu+0xcb/0x3b0
[    8.106521]  ? hrtimer_cancel+0x21/0x40
[    8.106521]  bpf_obj_free_fields+0x193/0x200
[    8.106521]  htab_map_update_elem+0x29c/0x410
[    8.106521]  bpf_prog_cfc8cd0f42c04044_overwrite_cb+0x47/0x4b
[    8.106521]  bpf_prog_8c30cd7c4db2e963_overwrite_timer+0x65/0x86
[    8.106521]  bpf_prog_test_run_syscall+0xe1/0x2a0

happens due to the combination of features and fixes, but mainly due to
commit 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()")
It's using __GFP_HIGH, which instructs slub/kmemleak internals to skip
kmemleak_alloc_recursive() on allocation, so subsequent kfree_rcu()->
kvfree_call_rcu()->kmemleak_ignore() complains with the above splat.

To fix this imbalance, replace bpf_map_kmalloc_node() with
kmalloc_nolock() and kfree_rcu() with call_rcu() + kfree_nolock() to
make sure that the objects allocated with kmalloc_nolock() are freed
with kfree_nolock() rather than the implicit kfree() that kfree_rcu()
uses internally.

Note, the kmalloc_nolock() happens under bpf_spin_lock_irqsave(), so
it will always fail in PREEMPT_RT. This is not an issue at the moment,
since bpf_timers are disabled in PREEMPT_RT. In the future
bpf_spin_lock will be replaced with state machine similar to
bpf_task_work.

Fixes: 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()")
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
v1->v2: Fix one missing kfree->kfree_nolock() conversion (caught by BPF AI bot)

 include/linux/bpf.h  |  4 ++++
 kernel/bpf/helpers.c | 25 ++++++++++++++-----------
 kernel/bpf/syscall.c | 15 +++++++++++++++
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a98c83346134..d808253f2e94 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2499,6 +2499,8 @@ int bpf_map_alloc_pages(const struct bpf_map *map, int nid,
 #ifdef CONFIG_MEMCG
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node);
+void *bpf_map_kmalloc_nolock(const struct bpf_map *map, size_t size, gfp_t flags,
+			     int node);
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags);
 void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
 		       gfp_t flags);
@@ -2511,6 +2513,8 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
  */
 #define bpf_map_kmalloc_node(_map, _size, _flags, _node)	\
 		kmalloc_node(_size, _flags, _node)
+#define bpf_map_kmalloc_nolock(_map, _size, _flags, _node)	\
+		kmalloc_nolock(_size, _flags, _node)
 #define bpf_map_kzalloc(_map, _size, _flags)			\
 		kzalloc(_size, _flags)
 #define bpf_map_kvcalloc(_map, _n, _size, _flags)		\
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index c9fab9a356df..8eb117c52817 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1215,13 +1215,20 @@ static void bpf_wq_work(struct work_struct *work)
 	rcu_read_unlock_trace();
 }
 
+static void bpf_async_cb_rcu_free(struct rcu_head *rcu)
+{
+	struct bpf_async_cb *cb = container_of(rcu, struct bpf_async_cb, rcu);
+
+	kfree_nolock(cb);
+}
+
 static void bpf_wq_delete_work(struct work_struct *work)
 {
 	struct bpf_work *w = container_of(work, struct bpf_work, delete_work);
 
 	cancel_work_sync(&w->work);
 
-	kfree_rcu(w, cb.rcu);
+	call_rcu(&w->cb.rcu, bpf_async_cb_rcu_free);
 }
 
 static void bpf_timer_delete_work(struct work_struct *work)
@@ -1230,13 +1237,13 @@ static void bpf_timer_delete_work(struct work_struct *work)
 
 	/* Cancel the timer and wait for callback to complete if it was running.
 	 * If hrtimer_cancel() can be safely called it's safe to call
-	 * kfree_rcu(t) right after for both preallocated and non-preallocated
+	 * call_rcu() right after for both preallocated and non-preallocated
 	 * maps.  The async->cb = NULL was already done and no code path can see
 	 * address 't' anymore. Timer if armed for existing bpf_hrtimer before
 	 * bpf_timer_cancel_and_free will have been cancelled.
 	 */
 	hrtimer_cancel(&t->timer);
-	kfree_rcu(t, cb.rcu);
+	call_rcu(&t->cb.rcu, bpf_async_cb_rcu_free);
 }
 
 static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u64 flags,
@@ -1270,11 +1277,7 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
 		goto out;
 	}
 
-	/* Allocate via bpf_map_kmalloc_node() for memcg accounting. Until
-	 * kmalloc_nolock() is available, avoid locking issues by using
-	 * __GFP_HIGH (GFP_ATOMIC & ~__GFP_RECLAIM).
-	 */
-	cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);
+	cb = bpf_map_kmalloc_nolock(map, size, 0, map->numa_node);
 	if (!cb) {
 		ret = -ENOMEM;
 		goto out;
@@ -1315,7 +1318,7 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
 		 * or pinned in bpffs.
 		 */
 		WRITE_ONCE(async->cb, NULL);
-		kfree(cb);
+		kfree_nolock(cb);
 		ret = -EPERM;
 	}
 out:
@@ -1580,7 +1583,7 @@ void bpf_timer_cancel_and_free(void *val)
 	 * timer _before_ calling us, such that failing to cancel it here will
 	 * cause it to possibly use struct hrtimer after freeing bpf_hrtimer.
 	 * Therefore, we _need_ to cancel any outstanding timers before we do
-	 * kfree_rcu, even though no more timers can be armed.
+	 * call_rcu, even though no more timers can be armed.
 	 *
 	 * Moreover, we need to schedule work even if timer does not belong to
 	 * the calling callback_fn, as on two different CPUs, we can end up in a
@@ -1607,7 +1610,7 @@ void bpf_timer_cancel_and_free(void *val)
 		 * completion.
 		 */
 		if (hrtimer_try_to_cancel(&t->timer) >= 0)
-			kfree_rcu(t, cb.rcu);
+			call_rcu(&t->cb.rcu, bpf_async_cb_rcu_free);
 		else
 			queue_work(system_dfl_wq, &t->cb.delete_work);
 	} else {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2a9456a3e730..8a129746bd6c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -520,6 +520,21 @@ void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 	return ptr;
 }
 
+void *bpf_map_kmalloc_nolock(const struct bpf_map *map, size_t size, gfp_t flags,
+			     int node)
+{
+	struct mem_cgroup *memcg, *old_memcg;
+	void *ptr;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	ptr = kmalloc_nolock(size, flags | __GFP_ACCOUNT, node);
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
+
+	return ptr;
+}
+
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 {
 	struct mem_cgroup *memcg, *old_memcg;
-- 
2.47.3


