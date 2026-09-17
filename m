Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE36C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910136B009E; Thu, 17 Sep 2026 05:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5BE6B009F; Thu, 17 Sep 2026 05:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823EC6B00A0; Thu, 17 Sep 2026 05:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFD36B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:17:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 729FAA44F3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:58 +0000 (UTC)
X-FDA: 85222702236.27.1386045
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9822210000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="muIuPy/X";
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZzG23Z9jsbUsdj9Q4HKJb5huOde2KckS383807O8Cw=;
	b=GFlkSZjRISa6NIi2Zx1JV2kVGDddAIpM9nKyfVJ6LmI6JhAPbnWNUk1+KCeUdpaGl443ew
	QgkoDsDbfeUB7zmFRoo/ttGrvWDijSnLUIZGeeViKqVC8iXc48h/r54BkJqczBiBWm4mnd
	zhtc+g2zpMcMyta+zDR1EwmtrkYdek4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="muIuPy/X";
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636676;
	b=79sB0dWjuk+ksnsa+k9NXgwfhCXH0ZKN7N9E9KPasj25nXLLQZkqf8VCDlY9XF8tEIAOz5
	BWjtFhxfPZleQDswr4dmqlGAphOh348pLFmcjVOlmKxju7f1AIqIynUgoNXIxxDJuMqVUP
	oaq5PKfF2D3jmNjsKg1nmOiYBPdqYQ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB60A42A95;
	Thu, 17 Sep 2026 09:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FE11F00893;
	Thu, 17 Sep 2026 09:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636675;
	bh=FZzG23Z9jsbUsdj9Q4HKJb5huOde2KckS383807O8Cw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=muIuPy/X8b1hv6tuR6wKpRBv3mNUXIgnYuxkoVIPHfg4/uXkbLVKkMOwfOfcY2Ik+
	 144LLPAOPMKRwX+qSHibq8ceIa6/sAUmi9h3H4d8STr38B9c12z40moBLITjqiFrJ0
	 nr8GdCc3TdAvi8mfaPSBOCYvtdMbA8rFS5wCOD1skzkXzurF+IFW8qGXf8J63SG4iG
	 PyMEAbAEk1hQLPdrTPNRznC0ChgDu97EDjGM7DfTGulgV55upWBR0vGSqa1ugnA91o
	 5csEE3YVYgdWzbjro8m/mNj7qUIhH2bfLTNPQ8AOLCU8f3o+OmO68meKLLsa+0VeRG
	 kqry8IqXSX7fA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:17:30 +0200
Subject: [PATCH v2 3/7] signal: only SIGKILL and the freezers interrupt a
 coredumping task
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-coredump-fixes-v2-3-f3787fcda051@kernel.org>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
In-Reply-To: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=4764; i=brauner@kernel.org;
 h=from:subject:message-id; bh=avsSVGCfff5TAS7jXkNbzu9FlVjzXgm1AAGkdUYcuj4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3mDicv7HyTveL9iF/6z1nf+pcvHUTcwlPy7Epmy/b
 u/5ib1xU0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEmE8zMvw49NuTy1Ni4c5f
 vO9r5txIFRb7G7n7GpNfyaPn3G/5b7sx/E/eMn9NkJzqunvh15rcdK6VRM7KmHqgaBNDUP29B5/
 y/dkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9822210000C
X-Stat-Signature: jrbfp8ajj9cj16x7n8q5xftjrsp4jmik
X-Rspam-User: 
X-HE-Tag: 1789636676-347433
X-HE-Meta: U2FsdGVkX19APcwVdORmcBjAzj1xnkY6UdnIYM005bScUHLYK26wLIhyexyf2w3U76NwjAyMLykSgs1Vr0e8Hl0WGN3CplT/++umKeOeNOOhc8O0tlijTdVmTYgJSRdg1M/t7gJV97+KissnE28wVYaAap0nOzFiM1tgCPOSmMPcPUU9CQo1zTBhObzeJJucP2hreRX4cBsx6zEDnqVWTCg5lWD66xWl9H92AC8sDkcykr1UZI06am1dlLZtdkKJJjps7nf2q44Hl2opYf5cv+pEA516pJrxB7Px6kuAqm08AmrzGLwoaKQbSJqny98t93ZgRTC5sJ61ML/kFMXnhtVnpDbzCoNNgUtRTekQfDgJIEd9UkaGUzlHP9hRbfqzZkrFhpci5AdUCfBjKWkW2t+NjPWm5orR1TKhfMbyF1eNfTp64969TwVS/qCGa2K0eSUN3S8tseQuefG5Fr4CTTdDa9Ku5AaKylETQLoiyYGv0mAN/ZML3xneCKSiN3oH/xIYrJDtBSHagupvDDykhbKI3OH1cZk4iASeHgGZQbPMuZljG11iM69p2/qCzNKljmg8EVch2LNn7z4RPv/4GpwI3y4CfmYyakoMNbbv+AdIJpZ8sOF+4H4re6TYqfW3YOHA6UA6VWUcjqcgG1p0kCWiTEDyHZ+tpKbCaDf3h/k8PnkKXk6zDt6FjdrUOkKMQtO5CrmvZS0ax5ihFbqM8GWSVvztM6fjgYk5LmmhGPF/8I5+3XkQJ6nc2btQu7epMT7eqhxn9f3hWHI2ouSioPtGJ0AKMShj9jbiAkOpRMB4WSSdENbrBF8f0wuHgjVzXTzktEGtX7CrhehnJSSgW2prcp2e4Za2II+252v1hDuHMXR9wJDsnXiwzt2JA8+r3JwcVe+9mRg4QhlWkPZjsP0rnBy0cFfm4UphbGjV4K1QsAGy6P4AOt5iv7wndtoScrd06qg+gRLZiP+1a0G
 f+5covmx
 uQNPKteWQCgRQK4qyLZ6yQ7y6EQwaQDK+G34sVG3lsm04c1gDBbYhEbzGptaE3XLDkLUpGR0PRexTvW7s7hU3pE3BMXXIwZMQS9NhQ0ztLFucElKwUM52CbwcxMtMQaGhpJDD5rBL+MyZs/wmacmvBtqTmx7Ot/Yak9hHlpkqVjxlTJgkxqvALf0ol4sjhCUvfZamjqRBZIRgwGbwEZfNLMXuJmxN3mM10EgDIuIlrNJb23tihwoKmrXRHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For quite a while now coredump has allowed either SIGKILL or freezing to
interrupt an ongoing coredump. Since we seem to like it complicated
"freezing" can mean a lot of things:

(1) Power Management induced freezing
(2) cgroup v1 freezer controller induced freezing
(3) cgroup v2 freezer controller induced freezing

So (1) and (2) are handled by checking freezing() but (3) isn't.
(3) uses cgroup_freeze_task() which sets JOBCTL_TRAP_FREEZE and calls
signal_wake_up() on every task in the cgroup. The trap isn't handled by
the coredump code.

Which means the current logic is inconsistent. Power and cgroup v1
freeze and abort the coredump. With cgroup v2 it depends on where the
core goes. A dump to a file completes and the cgroup v2 freeze has to
wait for it to finish. When dumping to a pipe or socket the dump is
interrupted at the next write because of trap's TIF_SIGPENDING. Which is
it? Let's be consistent and align (1)-(3): freezing interrupts an
ongoing coredump and doesn't make it wait until the dump is done.

So make signal_pending() report only SIGKILL, freezing() and the cgroup
v2 freezer trap for a task that has PF_DUMPCORE set. freezing() lives in
linux/freezer.h and is a static branch. So keep that check a separate
helper instead of in signal_pending() itself.

Make dump_interrupted() check for JOBCTL_TRAP_FREEZE as well so a cgroup
v2 freeze keeps aborting the dump like PM and cgroup v1 do.

Fixes: 403bad72b67d ("coredump: only SIGKILL should interrupt the coredumping task")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c                | 11 ++++++-----
 include/linux/sched/signal.h | 19 +++++++++++++------
 kernel/signal.c              |  8 ++++++++
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 5b3f3a1090d7..e0ade16c2f99 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -617,12 +617,13 @@ static void coredump_finish(enum coredump_state state)
 static bool dump_interrupted(void)
 {
 	/*
-	 * SIGKILL or freezing() interrupt the coredumping. Perhaps we
-	 * can do try_to_freeze() and check __fatal_signal_pending(),
-	 * but then we need to teach dump_write() to restart and clear
-	 * TIF_SIGPENDING.
+	 * SIGKILL, freezing() or the cgroup v2 freezer trap interrupt the
+	 * coredumping. Perhaps we can do try_to_freeze() and check
+	 * __fatal_signal_pending(), but then we need to teach dump_write()
+	 * to restart and clear TIF_SIGPENDING.
 	 */
-	return fatal_signal_pending(current) || freezing(current);
+	return fatal_signal_pending(current) || freezing(current) ||
+	       (READ_ONCE(current->jobctl) & JOBCTL_TRAP_FREEZE);
 }
 
 static void wait_for_dump_helpers(struct file *file)
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 70067ccfe2ba..12df33db1d9d 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -386,6 +386,13 @@ static inline int task_sigpending(struct task_struct *p)
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+static inline int __fatal_signal_pending(struct task_struct *p)
+{
+	return unlikely(sigismember(&p->pending.signal, SIGKILL));
+}
+
+bool coredump_signal_pending(struct task_struct *p);
+
 static inline int signal_pending(struct task_struct *p)
 {
 	/*
@@ -395,12 +402,12 @@ static inline int signal_pending(struct task_struct *p)
 	 */
 	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
 		return 1;
-	return task_sigpending(p);
-}
-
-static inline int __fatal_signal_pending(struct task_struct *p)
-{
-	return unlikely(sigismember(&p->pending.signal, SIGKILL));
+	if (!task_sigpending(p))
+		return 0;
+	/* A coredumping task only stops for SIGKILL or the freezer. */
+	if (unlikely(READ_ONCE(p->flags) & PF_DUMPCORE))
+		return coredump_signal_pending(p);
+	return 1;
 }
 
 static inline int fatal_signal_pending(struct task_struct *p)
diff --git a/kernel/signal.c b/kernel/signal.c
index ec30550951ec..d8bb1f168055 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -717,6 +717,14 @@ void signal_wake_up_state(struct task_struct *t, unsigned int state)
 		kick_process(t);
 }
 
+/* Only SIGKILL or a freezer interrupt a coredump, see dump_interrupted(). */
+bool coredump_signal_pending(struct task_struct *p)
+{
+	return __fatal_signal_pending(p) || freezing(p) ||
+	       (READ_ONCE(p->jobctl) & JOBCTL_TRAP_FREEZE);
+}
+EXPORT_SYMBOL(coredump_signal_pending);
+
 static inline void posixtimer_sig_ignore(struct task_struct *tsk, struct sigqueue *q);
 
 static void sigqueue_free_ignored(struct task_struct *tsk, struct sigqueue *q)

-- 
2.53.0


