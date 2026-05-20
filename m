Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557DDCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDD866B0095; Wed, 20 May 2026 10:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB54A6B0096; Wed, 20 May 2026 10:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF22A6B0098; Wed, 20 May 2026 10:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7676B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:43:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E53FA0388
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:33 +0000 (UTC)
X-FDA: 84788066706.28.62FFFC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7E1B4C0006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npDbjlIN;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cA8jfZ0PItYW2mi5IdBqTPaBnduDIHyksLZMvz7bUxU=;
	b=HNqNWvC1wpVgbwl8MrZIOAGDYsh183mP8r3QhlzCcV1GfaR8tdabN+DF52ltTvTIuaYgZL
	0kbyHo4FIyhWvqRRWFc6B6uxY1GldqAwroqw2xFo28b463CMsdPA3hAuxPWK3slElOFRjt
	nWc1dGq3m2JUy7UnuFyzYOdODdzMqxU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npDbjlIN;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288211; a=rsa-sha256;
	cv=none;
	b=lgtKczhh1s/NMIBBD0k97GdO+P+J6tcOazg72GJP6i3LKSvDYa8NJ3DmMmJbgMUMTIlqkW
	vsVjx2SUQOGJUud8TN7nmKhtTIHsrphF68dGMjUvb7vWmHNeYF3tAJkcC97GCCJ4/NXzmg
	ZUFyYHfJv55mI7/Zh0sNgcjfQ8P5t4w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CDD560008;
	Wed, 20 May 2026 14:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4990E1F000E9;
	Wed, 20 May 2026 14:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779288210;
	bh=cA8jfZ0PItYW2mi5IdBqTPaBnduDIHyksLZMvz7bUxU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=npDbjlINardW1b+wnW5ioc7Zt7LBZmOXDVkZ9pja5AWP5jb7GT8EH+W85F6sKDodb
	 yu0Nqa8HHfFxNVyy0Wn+JkJANEo0WaqNh6tz1LT6U41utLP3RL8rTVBx1xTd41BmKl
	 aq1GIwVFV4JiGrIyhy719h52S/AZkxmiWdx5le+4GEpH1LTCr3UAB6YzHeruLzBSpN
	 Up8481llqTWA0nz3D4g3BkPL6PW1cefw8/tcT6pEsSJHpNyRFfxBbsoqcFjwduGSmA
	 KNPV27hzkq7sFGi1HpPgf8DvSlFOqYpL7IcRHvzK/SzCSv4g2492leE3Ke9sTxwbq2
	 KKYMGppvTxtPg==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 20 May 2026 16:42:56 +0200
Subject: [PATCH RFC v2 3/5] ptrace: add ptracer_access_allowed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-work-task_exec_state-v2-3-9ea88ceb09e6@kernel.org>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
To: Jann Horn <jannh@google.com>, 
 Linus Torvalds <torvalds@linuxfoundation.org>, 
 Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, 
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2217; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2a/Z2caovtOQVDYSymcMTRrhIMfnAjYOZKY2geq9AOI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTxnmg+rsvy8eT+jkiFrGPLU9V/XvsveKiZ9WbS+2t60
 xXePOWt6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIXk2G/9Xn3/TtejvH41rx
 VpaY74J2txrvRsdP77yRp+xzIUfo7EFGhou8ojt38Cy+4KX7f2n6Wsff/38m3X40tWhR/A5f694
 jc9kB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: d5q1s3aoztogxh7t7y5ekwotmm1yq1un
X-Rspamd-Queue-Id: 7E1B4C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779288211-320780
X-HE-Meta: U2FsdGVkX1+fN61L3Tyf6yKNrf8SBC/pYNR4T0Q0qy+9Ey0B5Gdl1zf5Clmzaxjje0yfCUn9DCofBqvGAzPWI4+UmCAczy9tnNjuiYqoJPxHc9jVQnZrQBvVNaHuDD79ZZMBHBtJxzrB0UbNqvbS0rt0sKG0PrTLAURhdtvdIKvjkHWsJV/Aw8a4krFOFOl0GSzuvbhVaukJBibq9qkvUtISbusd1QfpNYg1juhvzMSw0WGXQOGCrjHC4VbM5221FOhTfJ3KJr0DnQTdMNK1m07pgzQVVMeWMr3RCbE8p2I4IrEglGEvI2C6l4+P0qQl3yVRkLhKvELFi3dABcxTTlKEn/39tiPLQTTcjArxcha9LQYhYGuyksKUPU+GOxXhRZNElpc9RvWxWJhvZeEU0PWprZea5A4abAdJmVxgnoJGXK/X18XMDemNwxxl4AeUJp9Fe2QQBV6tjlhOHDUTv6ie14HWe+/VQy74gzK8Guwv6U+7p/TqAlO9D/rt0UgdSPQynU+n8cmzM+P/eRmr6f8HQSj1yECRniEs2hwrBpJjWLrMbHkD/ojn+bqqfAozsh8qNqKc6XDf2pEsEbas1inb00hBRgydoCkEEpYzJxmcznvQWjX2nKfAgHrROFuh4xGFARCLZa3DqNpIxogCn/p9QX40GyZc3PhFg0+7v0CCqGeWHXBqZW9ZEUY6hVUF5isGGv7dY8fUVCC0ExAojtULGxnhNkRhGr8KO5UkacWsrLPCw3y9vizzkDdrt3w6dO6zCBGOmc0VsGHxyT1epuiUHoulZE6EsBuLYmnkdCJSGO0SIoMUhbZMexUf9UL2UQmLswMRBxJqRGVqJKoB+qU/73bxzShpwc14Zn2DXtl1LN6a4TzH30yAKKnPBBxkG0cJKu6dTr5Dy2NBWhQqxSTPq7WFlpKgcxTqAc34jl1o1iX2n3vq4h6fg5AIlKy/5OVd94w1kO+l718sZrl
 at8vNIJn
 AbOBZl3ZfNF4oa1y1lepibNHKLv9AOlv8JFmzSSo+H2LN8fcgZkQVLg0eyjQdZAEYVnQMIHquamKksnrqyu4OyJJLgfW/1CoU/gTJWznLr35sXGCtdbezUUjWW8oH/tNoJwPm2jrcsLXKzJ/DgNDIGfoxsBljBLxgIzkHBemoNaAL2lNQLRcaZM7JrX8hPFEf0+9C/0Ub9DsYCt12MF1MpGz401+x9WSO/Bj/2KkotLVVxwz/dp5UCi0JoIak9XluVqhNm+YJzJFeIFEiqupWfMp3mAfPYRCsrR4t2lgV2lzzoE/uPJaBjQw68iadxemoQicc9OK5YgjKxnSsUfLaAkFZjiAeJ92KsU0MakyH6JRfWQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper that encapsulates all of the logic for checking ptrace
access and remove open-coded versions in follow-up patches.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/ptrace.h |  1 +
 kernel/ptrace.c        | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 90507d4afcd6..ef314f7a9ecc 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -17,6 +17,7 @@ struct syscall_info {
 	struct seccomp_data	data;
 };
 
+bool ptracer_access_allowed(struct task_struct *tsk);
 extern int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
 			    void *buf, int len, unsigned int gup_flags);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 07398c9c8fe3..2dc7d01baba0 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
+#include <linux/sched/exec_state.h>
 #include <linux/sched/task.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
@@ -36,6 +37,31 @@
 
 #include <asm/syscall.h>	/* for syscall_get_* */
 
+/**
+ * ptracer_access_allowed - may current peek/poke @tsk's address space?
+ * @tsk: tracee
+ *
+ * Per-access check used by ptrace_access_vm() and architecture-specific
+ * tag/register accessors.  Returns true iff current is the registered
+ * ptracer of @tsk and either @tsk is owner-dumpable or current holds
+ * CAP_SYS_PTRACE in @tsk's exec namespace.  Stricter than the up-front
+ * ptrace_may_access() check at attach time; this re-validates on every
+ * memory access so privilege changes are observed promptly.
+ */
+bool ptracer_access_allowed(struct task_struct *tsk)
+{
+	const struct task_exec_state *es;
+
+	if (!tsk->ptrace)
+		return false;
+	if (current != tsk->parent)
+		return false;
+	guard(rcu)();
+	es = task_exec_state_rcu(tsk);
+	return READ_ONCE(es->dumpable) == TASK_DUMPABLE_OWNER ||
+	       ptracer_capable(tsk, es->user_ns);
+}
+
 /*
  * Access another process' address space via ptrace.
  * Source/target buffer must be kernel space,

-- 
2.47.3


