Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B54CC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C05E6B0095; Mon, 31 Aug 2026 12:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4978A6B0096; Mon, 31 Aug 2026 12:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3872B6B0098; Mon, 31 Aug 2026 12:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 066C16B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:02:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8190AA011F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:02:52 +0000 (UTC)
X-FDA: 85162032984.17.D277627
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C7F2140015
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:02:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KLLq/DkE";
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788192170;
	b=61lIttDoCnbOPat8S/IqNXleh4u7RzqNEtECrPofqK6gIMgMtONrq51ejrPR2+wLuNufvd
	QUfd665pvUpFj7Y244UbgNjvjQq5optQqVGc50Qtsh2+/GdEEvnZhzYhqpKGnIWCNbmoxc
	K5VfKcMeg8I+Hv9Pz3iH6HNoJCJbQG4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KLLq/DkE";
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788192170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NLZIuZwyQ1fPBezPmB2ZdhRAqwPCI47TD8fU8pt0GCA=;
	b=p0VtiLQySG09Htf3lUtqFprpKqBsvmfjHWAstqrdyIKwLb7NzpNgsZY3XsRkrFZ1cutOCP
	eIQPr2MjT2zQvStqeiNViyb71MYimZdB9yraj0xvED3iSrAY4YOchVxRLBZ5AQb1MGkomI
	smLJ/bn636cQZwaWvkhXGkbqTIJQ0p0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5CC44166D;
	Mon, 31 Aug 2026 16:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECCD1F000E9;
	Mon, 31 Aug 2026 16:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788192169;
	bh=NLZIuZwyQ1fPBezPmB2ZdhRAqwPCI47TD8fU8pt0GCA=;
	h=From:Date:Subject:To:Cc;
	b=KLLq/DkENe5czcupFR05JthrwbrMSnV0jBK5gyFHWeXYiZnI1Q6Vstbuv9cCZ2pbs
	 A5von/JkglphxxzTC49/MuVpJToDw8RkEufMdSw8cPtpcEEETFGOBOGTVf28DJWyuX
	 kFKmZmmxpIYM50LPWTcKcXAFvttaLA4jiL50bO5PPri65fqFt7Bds2jP8U9n/xHewA
	 i7+KM+S+hL+jPs/4trrW3TOLaQDZ8/KArl8q4GG7cfJusW0AjZMocm64jf8JA6+D/6
	 wTHyvgFm7gLe8OD3JzSRLVqDLhk3JbIEhuVDPKFGwe01ZDV55xZDSzdWAY1HKDEeB4
	 0qIphpytdDWLw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 31 Aug 2026 18:02:38 +0200
Subject: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJ2llWoC/yXMUQrCMBBF0a2U+TaQNFXErYgUk5mYUUhk0hahZ
 O9N7ed58O4KhYSpwK1bQWjhwjk1mFMHPj7TixRjM/S6v+irNcoN6hOEaBQ/jzFPgX/KoEW05ux
 C0NCeX6E2/6v3x+Eyuzf5aU9BrRsxn7/FdwAAAA==
X-Change-ID: 20260831-b4-kfree_rcu_hotfix-1d3dd315bff0
To: Harry Yoo <harry@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 syzbot+acf142088e0182172e58@syzkaller.appspotmail.com, 
 ThangNN99 <ngocthang2710.1999@gmail.com>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3872; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=t7YpXBwWo44Ao0hPSQc0ibgDI7jn9UtsrsCMut8SxHE=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWRNXbrgZpbVhA0/KjWid80qv/teud9v/dV9GdICO0+/S
 GDayaJ5tpPRn4WBkYPBUkyRpXr3CUfRmcoe0zx8P8IMYmUCmSIt0sAABCwMfLmJeaVGOkZ6ptqG
 eoZAho4RAxenAEy1sRL7Px2xw0XuzdwTxJy0Xu+Y6/J4hrXJGf+Hvwo3qjo7bzU2P6UVOO/a3hy
 vgsVWE+4pnDtsaa6kcENozYTHIq9zZ0zelDp/ntOJ0rnRj1TvpkiLq2+VajGN3Rd3Z5Vu3RNx6x
 0tew+a7hZcnObIVfxH5/LJJRPCZG7wSxytTC2t//r+Rvrffjlhwa6Tk9RMfgV8ZlSUDClb/etQn
 4bIxMW8PUycJ7gO8++Z6Dz1QZJSwWSz8F1b5fYZnwgWnMRvdnl7UME5IxvVPUedlR8qnlR+yjo7
 mOe/QtSue3Gr4q8azay8czvO8/2Pa3uuX/FL3dV73uDnicTXHww3+L3OZ+l8+7nlnF+ftGNswBm
 hGTJ2TQA=
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9C7F2140015
X-Stat-Signature: 3iawaprabcznddmq5e6w7byz3j4kqhbx
X-Rspam-User: 
X-HE-Tag: 1788192170-24090
X-HE-Meta: U2FsdGVkX1/kaQKpgU2y+FpK7F4mbjLITnuBZ4rnIQdiaKUROR2+sPqwJDMuyYWEnzo8foGl0Ih/8/1Zp1cEv30rYCOMSuyI5fDUTEPaWsJn4Jpr5502Z6foyb319zgulqM5TiF/jkoxbH5H7mzB87If+Y37H8h+GoTOxgTZ47MWV49Gx46rOkZFAStlws4kYP09p+QY0YVj2lAR+NoTddPBRnE5nODK1scvqsBdlnLZTkx8FMCdNOfhqYIwWnNh+KJEAolvA1Ye+8h9JBxgvAatAsfIxmoIvorPZ4UuSczyeT8MoXHVa3acYwwaPe1IORjoFIBmFVuPyhK7mkC0Nm/NX9yfuue41rPr5RDfmHDA1HybdYmEVTEIrCDVMiGHo5szOff9YjY2bd0MERy8qsGORMRqLQ0Pe2fzL4/oJwjxzpSk5BIViZd/LxkP+0nAMry8fuausj3LAn9ZGzR81rzaKE99tWzCyv6r97fI8TxaFtb8/0WzlB0+bN7mVZdfFKreBOxTCxNpqkqyfxpURVC+W60maySi0OeMMLaHB0pC30Cy4N/VfJ0Gi4iXMJYD4HjHXrufXRyHDW8/F4WH6cX5X12eIuTsHirOqL4F5jgSB1dinumb5wmBFAF5Mvpj84Y02kVPUDvn0F5KRXaQ6qX1N0i0WU95j8G4mM5kNE4YgTzBlnUqfbqqC2HL+IbI+L+8C+sq3UbOu+kGPjtXiWPclqAGRnroYi0wJJxgCgzyBcL7Q08fJTEBbCjMRzvfUmY+BF7j9GeHJX6juUBqcW4orZLkU2Hn1KJjbs2O7p8vBAJyW17aQiO0/XgYLaT5AUEG8ILfSxQ++zKcsvn/Met7NTlW1kzgZ1ilhgfh/Uoa5kHfXbykM1bng8wyjmYaJt37li6xDql8TNftigPTyr++wRPNano1wnLO5vL6nC4s/rOX5giorunM4OrYPU8SalwOp7EG/vSyAv7kBk8
 L7xgMBOm
 YJkwDPqltDTqIcIarBzUHJwfJmxu/FZUvDzv6drSU4t6b1y5H5dGjjkFvLhT2SBYul4KBzsJmRBhvQVAmic6L5nhLSCMR9+X4eYuEUFmeSx9DPiIF+ZiFDpmwTbKixdpzHipSZ5hbh0XhaPFP9R+N+qUtdrLMzrW3/hq+9l+8CLsgDAxVLt5OI1iHYKoRBKuW5afynT884kwRwHcu5RAoCRgCHzcOmnoGMIxX6MKX7g3Sy3VVZdYBQLbCHPjNDwyd7+80tV++ggteFVOfyHlIFEo7Do2Ok7mC+6aaTU6Ncr16gbshydpqorzi2J16ugBCxNVCO7IJEo0zI87GpfxHaQhmxY1q4CvqWs6m4xEvPST+bKoqh6YMsDAH756OHMpd5wH6hU0Jy+eQgZSHsy9DVZ2Wso5/YbuQIi5U3+vexf2TrbIddEG93WehJyIPbSMkp4HrjpvsL6Jo+IEv8ee/yCSRAWc7PK3Y9O13rHrQ5ehB9M6gSswV6TBqdw4GZWVBSuWV9qWl/2gWpgXG2b17YgnIDt26/B+SqL6e6hVZJS4btT75h8EWuWTiIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This partially reverts commit 2a8bb29ec9b2 ("mm/slab: allow
kfree_rcu_sheaf() on PREEMPT_RT"). It was based on an assumption that
local_trylock() is safe on PREEMPT_RT from any context.

However kvfree_rcu() is also called by set_cpus_allowed_force() with
task_struct::pi_lock acquired and there it's not safe, as syzbot
has reported.

For the immediate fix, skip kfree_rcu_sheaf() on PREEMPT_RT again from
kvfree_call_rcu(). In theory, kfree_rcu_nolock() would have the same
problem when called from under pi_lock on PREEMPT_RT but that can
be addressed if such a caller is proposed.

Add an explanation comment, courtesy of Sebastian.

Reported-by: syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=acf142088e0182172e58
Reported-by: ThangNN99 <ngocthang2710.1999@gmail.com>
Fixes: 2a8bb29ec9b2 ("mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT")
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Incidentally I have posted a RFC [1] that leads to replacing that
kfree_rcu() from set_cpus_allowed_force() but now after back from
vacation I need to check the feedback and based on this bug report I can
already see it makes the same bad assumption that trylock is fine.

[1] https://lore.kernel.org/all/20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org/
---
 mm/slab_common.c | 18 ++++++++----------
 mm/slub.c        |  5 +++--
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index b19ba1b31484..7223a7596dab 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1667,14 +1667,6 @@ static bool kfree_rcu_sheaf(void *obj)
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
 
 	if (is_vmalloc_addr(obj))
 		return false;
@@ -1685,7 +1677,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj, free_flags);
+		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
 
 	return false;
 }
@@ -2034,7 +2026,13 @@ void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (kfree_rcu_sheaf(ptr))
+	/*
+	 * kvfree_rcu() is called by set_cpus_allowed_force() with
+	 * task_struct::pi_lock acquired. On PREEMPT_RT the local_trylock()
+	 * usage below will acquire the waitlock which must be avoided.
+	 * Therefore avoid it on PREEMPT_RT.
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e7..7a7e906a0e44 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6088,8 +6088,9 @@ static void rcu_free_sheaf(struct rcu_head *head)
 /*
  * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
  * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
- * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
- * this problem by passing SLAB_FREE_NOLOCK on PREEMPT_RT.
+ * this would violate lock nesting rules. Therefore, kfree_call_rcu_nolock()
+ * avoids this problem by passing SLAB_FREE_NOLOCK. kvfree_call_rcu() is
+ * bypassing the sheaves layer completely on PREEMPT_RT.
  *
  * However, lockdep still complains that it is invalid to acquire spinlock_t
  * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260831-b4-kfree_rcu_hotfix-1d3dd315bff0


