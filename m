Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5ADC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F916B008A; Mon, 31 Aug 2026 09:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F70C6B008C; Mon, 31 Aug 2026 09:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D3A6B0092; Mon, 31 Aug 2026 09:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 545AB6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:32:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B71B4A1F92
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:32:33 +0000 (UTC)
X-FDA: 85161654186.14.59A3DCD
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id D9C9C40010
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:32:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qq2kltg2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788183151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iyuCMhGUpDra9S+DkJdLTa8SNwQ+om0mNosv5O74qg=;
	b=aCmklLSNvCt+jlWhefpXrjAeY4ZjBJMdsUlVMPqBmvvrN/7EyxutjIDfWhOrDBGodfM7Jr
	N2neFF0hNpdKt+usDpK42Cb7f/gphB8ojM1pPux+cuzdPyAZQrDidVWwMqWIZXGYE5/Rzq
	iUB+8tVxj0CTNJllU0sfH1qBvDM6BZk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788183151;
	b=7TzCWniBZastINK3xPThcoTeqDsF4/R3M3gckhw+r9iZW6ef7P5yLDH629l4QqurF5boY6
	87r6EN5RdKPFELXLOtVzLbHcCurvI9Gs1Udwf4UTi6cpe8Fe4D+prNALWxPZhDhLGWa2rg
	Z6z/pAJXfjwARbnX5sZwxHGUNnD+LFA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qq2kltg2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d71a50caa9so43367885ad.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788183150; x=1788787950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8iyuCMhGUpDra9S+DkJdLTa8SNwQ+om0mNosv5O74qg=;
        b=qq2kltg2Hi7lM+XYnPWiKEyYG7KINqBISj9a83zRdPTZnZk06UmrmC4jGogOiY68U/
         duJrF9K2+WLpF3WlefHCeMEK4AIR+m4n83WKxGlPuk4wHEDshY6ijY3qs/r+iOGdtsCL
         aVO3qMTZUG3t1mFq4ENVzeH2PsZkoVka2dQf1VhNHMK5M8OSjBrZ7NJ4f90EDZZcTJOQ
         vb1IWEDAGFTg+Hob6q6TZ07h/yHo0rY5qXPCX1gTj5hfweQ9VRPck1IvdKWAPM68Hscp
         WclZh7b0Cx5z3r75BNU8N66k3U0HqaIFhHU0hxMVBMGEKYXx1wYxksBMgOa51wAWhzcZ
         PV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788183150; x=1788787950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8iyuCMhGUpDra9S+DkJdLTa8SNwQ+om0mNosv5O74qg=;
        b=OgyiCzX4M10O4uiP1rXsI+HF5dvrFuF8p67Lhi5UfgTiW2E4MvElRQEF2LrmsCEch1
         O88Hb61PR29xERjPgezEh2ZJVIbVycAeoI8M3K4ovJzZ+R7kFBkAO/LYbwZNKpeMfIN0
         nnakdwCDBHLnb5k6gpWTPElzYj2f1+GtqYvIIBirCt9aIdRxQEgfXcVcJzozIiRAlhbu
         d3tCQcv/mzPqy8bX2oBabXWG2/0RUA9pB10tQpBoW5ra0YY9QY7hGG9n4ARl2sTwkkkh
         sBgaY1QTIR6D7PjaY/bau7SRAepoYeUywO8QG00h/Dhi5RdDE106YUnEUtr64CpWjDpx
         BlMQ==
X-Forwarded-Encrypted: i=1; AKwUvByEmLkmX933vRE7ElxhiyvwZ9XlWajhe3pkJkbOKZbIMDFbBtCxMvVjXA4GVBVbVkWZ/gOb9oH4Qw==@kvack.org
X-Gm-Message-State: AFuF++nym1DrpAm7UMapp6WXwwNvqRjwTRqBeQRU/tpTj5H/qEnhiU5o
	PzzW1QGv/V5GkGIwKPPVqT23+qdWgwjUpW3K3UtkKunzDccoz+oxtHlR
X-Gm-Gg: AYBFou2iDRFJTI8uutu7E3cKDiiq9w0pvSTlsesFLyoGjCMa/+l+eyHzjRGy7dGYVWR
	T+nQGxQ0PzAlraW56/H8CpsPYBBgl+TzrQ9kYAgLoPhFII4jE1dSS6HT/2nTj7HE0Eew/8kqnuJ
	aLBryB6+CmPC74tjr9TtyzjPDTRTrV3yTeWQOjSCbckA1rYIiKKWHchJNIIMQcnSVMX5COEUzhI
	JFwWFn7qvv2zSarVlxoEpvGA/zIaXxomEZLuVKuduWeh/xWHGfXIIUVxchHJ9pLrMB67a1RC9Hf
	cyTszi9qkaKSPqU44l28IKymjr2WioJrj0XQrmrkinnM3HF90QL7YcogkhZOypWMq8C35qcQ+F5
	WbM9neBgiZbHJu8C7WkJV4dtzqjg8NFadrKV0vZ/2z3LSIXK5Ql0G1af7Qk3XwdBhIz2rS8yHbw
	9QRq+ZJv0OsEViIT/TzXh5KZkndVsJ6dQrhZfNO6VoZwXxsLnuS6iME4CYloT9/UO9NqFuX1ViF
	FcBd3M=
X-Received: by 2002:a17:903:2a8b:b0:2d7:1cee:3682 with SMTP id d9443c01a7336-2d74dc21e53mr406131505ad.5.1788183150392;
        Mon, 31 Aug 2026 06:32:30 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:21dc:72d0:50b1:2f22:32bb:703])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598b8829sm36684125ad.73.2026.08.31.06.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 06:32:29 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	ThangNN99 <ngocthang2710.1999@gmail.com>,
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Subject: [PATCH v3] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in kvfree_call_rcu()
Date: Mon, 31 Aug 2026 20:32:22 +0700
Message-ID: <20260831133222.8637-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831130057.HLukQ-zm@linutronix.de>
References: <20260831130057.HLukQ-zm@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9C9C40010
X-Stat-Signature: fkd8ntuedx816g7oohdfgygff5saegko
X-Rspam-User: 
X-HE-Tag: 1788183151-988963
X-HE-Meta: U2FsdGVkX18Y8CcQO6O0Uch/d8Oc/HWCJ6dKq8eBXnN4D/WdM1JeivbEXw2zDAGkEgpYldcjTNDVtVppS5sb5Gdnpx5kpn0JNRq44F2O4UYBhA/BWdqwyoHhOYBliqan9oCCr5UbWA6uouzkyD61ynJI1GKWm2Rx6S7w79E9uECniERxnru5K5csLJtOgLWntk18TKM6REq4X0gkx57RCx4sLGjqAJnGgGZhDMkr8dGQ/nC/7dpFqWA/8SrvIus/6wfDpXirOfAGFecQUYzBge9VYbWNcAT2jvpFVLaH32BKejLtB2T6hjIPDuOLZzn86uQ3/BYATjVApfUcJgPOGURdx6XbANgxzypNHFuaE4MFwBA5/ka7PXjH9LlIUa4rqe5dAzGhol5wwZF1vcYqEO+t6CaJZUTl5ifs06NxMCw9Bz4qGmQptBbfE4Rs/ZnOXtg7BSPSebjXXR+OYrklTZtzD5VsZcM5PSvOSIWIPlkMAW1adLqpNxOzfHAfHAU9m9Mmx6i94VPCjzcIo2+0onSvwI0Wx9U06ujLQbGZ4tYLP1+9hZCLftIaJb0Sz8F3T4e12AENjk84SElOPmfvpG21NUH5gtxwtntz1dT/KolMljdYb85f8okCyUYp6sPChJ3pmMgbzX20UpX1GJKYxnKrq7CCzBVsYDNMhg2E5IA2/e6E626mASyxXIP58HvEhxF/Dfshq0gyTEkwEMVgPJlcx9QFNH3Y1Njvx5FwPiV2RnpgUErTFqWuPHaoPZM5vVx6yyxdtmXw2lnlq4V4MjTuGEEJq5lP67dHWh2UnnE5OUd6P964LKAJQ5IMj4zhxS+wRyQDdPEyxi15znBwOtSjblmtFCViWiiCVgKnk3XWDpkS+ktE+s0IQU7muiZ14B3JqRT/m/fxMpMSY6x4l/TXIeSHPAiXSdP6+umLsuWLsAnIsm8yoiNbp4imOB5cbrYZvN1i9bSh5VfKVkN
 lxa4V4hL
 O3td6ftbhyl431IrVz94dDLxs79dxiBnfbBfjD2ykV858xtqSe4Ujdn8tWERqK/3q8oGO5cWg44J9Ff1I8K16TFjK4hoqVPI4HJuvZhv7tk+SoQ9Wau6oxpmp+dY7gvnG3FrH7BkfzVb0rSwMPW9x8GkjkKL+dhpjrUIFI3I4qXXSBdN+fq460bycdD0DOpoTKfSKvhDRw/GNWmDkORGFyLW3hGgepbSvZbyu15ZDUvpiitviCzLLy1K8idSTHkBLzyYYJZwtU+ouC3/cBfoO8/lULro6zWAVUahoe8eN42NhYb3v1O9Dj7y40E8u797KAZP7k+sbOh7XQQSs/xDaQrSJcqd6++MkhXX1HEQ/F6N9HZKRxNMQJJzD8c39MPP8i7URYl7/UKSulE/UsCXLoLm5yFK+U/0nj1IzZj+C7pdp7rvrCpLs6R4T9y2FX96tEsgTDQRkByG77UN8BBFfzjLHzbNk/8Qn0xKKwl6cmuc7meD3xB7JBkRt9WEfmRz+Z81B1nOPOxFFxmzi+rGS7jT01AWTMT8u9CBvVGuKbfYId1UwjrSLul1Yxi74ZO/fJU3IHFfQuGAQOSk6CMJ+mQlZdNWd5qjgYfsfpIFYsuuWSlNVM2TLA02T8pRAWWUYqE9mDu4hSK6MJxRl0wyjWp96zRzTcDvRu8/BvhtU7orPRivJxs6s64dKq02/Xc4H/u47OQxnp0W/jTgWZfFSk0O/FA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reports a possible circular locking dependency between
&p->pi_lock and the per-CPU kfree_rcu sheaf lock (_T->lock) on
PREEMPT_RT:

  __balance_push_cpu_stop()               [holds p->pi_lock]
    select_fallback_rq()
      cpuset_cpus_allowed_fallback()
        set_cpus_allowed_force()
          kfree_rcu(ac.user_mask)
            kvfree_call_rcu()
              kfree_rcu_sheaf()
                __kfree_rcu_sheaf()
                  local_trylock(&s->cpu_sheaves->lock)   <- _T->lock

set_cpus_allowed_force() uses kfree_rcu() instead of kfree() here
because all of its callers hold task_struct::pi_lock (a
raw_spinlock_t), and plain kfree() may sleep under PREEMPT_RT.

Commit 2a8bb29ec9b2 ("mm/slab: allow kfree_rcu_sheaf() on
PREEMPT_RT") made kvfree_call_rcu() try the sheaves fast path on
PREEMPT_RT too, since __kfree_rcu_sheaf() only trylocks there and
so cannot itself block. True, but the sheaf/barn locks it trylocks
are also taken as regular, blocking locks elsewhere, so lockdep
still records a lock-class ordering cycle against any raw_spinlock_t
already held by the caller, which is what syzbot caught.

The plain kfree_rcu()/kvfree_rcu() API gives kvfree_call_rcu() no
way to know the caller is in such a context, so keep it
conservative on PREEMPT_RT and skip the sheaves layer there,
falling back to the existing raw_spinlock_t-protected krcp list,
which is always safe to nest under another raw_spinlock_t. This
restores the pre-2a8bb29ec9b2 behavior of kvfree_call_rcu().

kfree_call_rcu_nolock(), added later in commit 3bc999d944b3
("mm/slab: introduce kfree_rcu_nolock()"), is untouched by this
patch. Note it would not be a safe substitute here either: it still
reaches __kfree_rcu_sheaf()'s local_trylock() on &s->cpu_sheaves->lock
unconditionally, so a caller already holding a raw_spinlock_t would
hit the same lockdep ordering cycle through that path too.

Reported-by: syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=acf142088e0182172e58
Fixes: 2a8bb29ec9b2 ("mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT")
Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>
---
v3 (per Sebastian Andrzej Siewior's review on v2):
 - Say "raw_spinlock_t" instead of the vague "a raw spinlock"
   throughout the commit message and comment.
 - State plainly that *all* callers of set_cpus_allowed_force() hold
   task_struct::pi_lock, not just that it "can be called" with it
   held.

v2 (per automated review on v1):
 - Corrected commit message / comments: kfree_call_rcu_nolock() is not
   a safe alternative here either, since it still trylocks the same
   &s->cpu_sheaves->lock unconditionally.
 - Removed the now-unreachable CONFIG_PREEMPT_RT branch inside
   kfree_rcu_sheaf() left over by this fix (it can no longer run,
   since kvfree_call_rcu() already skips calling it on PREEMPT_RT).

 mm/slab_common.c | 20 ++++++++++----------
 mm/slub.c        |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index b19ba1b31484..015380ba8bcc 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1667,15 +1667,8 @@ static bool kfree_rcu_sheaf(void *obj)
 {
 	struct kmem_cache *s;
 	struct slab *slab;
-	unsigned int free_flags = SLAB_FREE_DEFAULT;
-
-	/*
-	 * It is not safe to spin on PREEMPT_RT because the kernel might be
-	 * holding a raw spinlock and slab acquires sleeping locks.
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		free_flags = SLAB_FREE_NOLOCK;
 
+	/* Callers on PREEMPT_RT never reach here, see kvfree_call_rcu(). */
 	if (is_vmalloc_addr(obj))
 		return false;
 
@@ -1685,7 +1678,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj, free_flags);
+		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
 
 	return false;
 }
@@ -2034,7 +2027,14 @@ void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (kfree_rcu_sheaf(ptr))
+	/*
+	 * Callers may hold a raw_spinlock_t here on PREEMPT_RT (e.g.
+	 * set_cpus_allowed_force(), whose callers all hold
+	 * task_struct::pi_lock), and the sheaf/barn locks are also taken
+	 * as blocking locks elsewhere, so trying them here creates a
+	 * lockdep-visible ordering conflict. Skip sheaves on PREEMPT_RT.
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e7..1e8bad7a018e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6088,10 +6088,10 @@ static void rcu_free_sheaf(struct rcu_head *head)
 /*
  * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
  * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
- * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
- * this problem by passing SLAB_FREE_NOLOCK on PREEMPT_RT.
+ * this would violate lock nesting rules. kvfree_call_rcu() avoids this by
+ * bypassing the sheaves layer on PREEMPT_RT.
  *
- * However, lockdep still complains that it is invalid to acquire spinlock_t
+ * lockdep still complains that it is invalid to acquire spinlock_t
  * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
  * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
  * by temporarily raising the wait-type to LD_WAIT_CONFIG. Skip the lockdep map
-- 
2.43.0


