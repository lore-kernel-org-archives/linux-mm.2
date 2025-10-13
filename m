Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B16CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40AE8E0089; Mon, 13 Oct 2025 16:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0D08E0036; Mon, 13 Oct 2025 16:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8508E0089; Mon, 13 Oct 2025 16:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 863758E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:35:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54358BA663
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:52 +0000 (UTC)
X-FDA: 83994247344.14.F0B2F4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 824D240008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qGk5nfr+;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZojQTew++BfAEii+rnYjOoU9yY6iAsIlazqCQw8DR8=;
	b=MhaJWxMjn/+28/+pP0iYT4/MEL2RkrlKFDAN7Qr2PhyNHMI+U+0mxP+/pereIsklHG9UQq
	wI2PPqGJzSQIoJcZKH4sWCV6HXwFIANeuN+8lP/08sbvcDbIFYiYK+SA9K0uGMP0m9AITm
	7nKW0ibwcsPVzzgnlyGLWTfMbogjV0w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qGk5nfr+;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387750; a=rsa-sha256;
	cv=none;
	b=uP/aBoYlgily5ZckPFmhENrqPT3VGBvvy4epX332eg3KqdzHtV8qCzwbnAqmU3vokR9uwh
	CgeFT9z83DPL01y4keqtUGUWfMAyEDunXy9jfJqQm4vDtAYmLr+UW+oWScwhWGZ8uO7lQO
	T70AeZO4i40VtoINPMueYv7ZNUOJwMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A068A40748;
	Mon, 13 Oct 2025 20:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39411C4CEF8;
	Mon, 13 Oct 2025 20:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387749;
	bh=tmme1GHCRZttEH0fzbesyJQ/RQ0GFTr99io8B0/CrOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGk5nfr+6FsZ+NjmwnCpmAIaenxkl60KAACf6wbri2p0S9pMENlqql05tS3cfeHFe
	 uKiGz3Z1CNQF9dQ5na0Eo9YKToVMYig8jRDhXl6mjij12opct/nqMuc04zcTbWIkUp
	 Pv4FcATUmHuTXDyFfwmtBXSk+cueqvuhxXcz79ZHZkNl/G05hC4WAIWCUq6mXj3vlC
	 8GL1Mo9r7l5G3jIvY1YprkTxP7uSL9d4kbRQllwCO4VpCnFsXjxKKnDv13lxqm/xOg
	 uIG/Hsns7R68qcZY9rnBMiW6uZGF0Fd9OINAd0lw3yS0nEqn0SX9YPNmoF+o7eFaGf
	 O1f7778QWb7+g==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 30/33] kthread: Add API to update preferred affinity on kthread runtime
Date: Mon, 13 Oct 2025 22:31:43 +0200
Message-ID: <20251013203146.10162-31-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: he6u494mcoi4kw3aeazmojcc16z7416y
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 824D240008
X-HE-Tag: 1760387750-294274
X-HE-Meta: U2FsdGVkX18Cx9nEpRj9ZHqOxwQUJh6RRhUD2nT0ppwvGy0hf+pMxds5WIqbH+n3yT4UgkE7qgt3jHzQqbxf5OZBRmm1NGwLP7+o/zuMtB4ukimL/zZPRAPIul6fJkRP1PxFXWiWoGYy2Ez6z+QEvtJ2c5i2nG5J67J1jZrrt6rOz5erWGknMFN3YNcP9ykd/iTwDnvngia9TW14iA6+nQYBOoTUXh0xcPAi2dVtSqyfLXmi+RtyRz3E8Neqisp9vtW5qMA4Q2Asuu1moHpurBGVsyj84z5443P6jKxNeKc8rW2JLKS4Y/mML+KwyhWasap6SNp6/48xLsJMP2562rgDrFdYfOAy0AuDxEzx8eELBC13vC2EpjY+E+mHn9hzvh+XfdfOkyukFF3bcPVRsLMgYwCszh9tGlXVL79qAxg6+9NFsikp2J6i4aCGxX3+6LL75uhK2UPn17RaRY2DGQeIFTsOuWwCHSxNvalwGwkAeExHiGO7Tbzv6T3In0Hvy7zU5ssvYP35mBX1Z7E/hBgcmeedmWBKx5c/zRMKBaw2bpDbcYSkglvs30u5JPJNGetczB8hKah39Am/kDbx5RHhhe2VyV0MyC7NYkhS3LS8gMzb/eRoicRVOBjljqF5f9+Mm+Yw3ci/zdZMU5s1v8/NYYrVXP8eon1EAnwj33rb2ExXJQCsBAKAAtSRVumAcRs+5YjpUZ4btkAnkuxgyxAgr60IrOvPgcYNFO44eyQh3z7IIm+Ny1Juf7Q3W6/9YGDbJQLeJfXz7NpvUjFpU6hL3ALqh6UHWtJshxjWtMq+7O/DEqqkFImCd/lBlDl+LV42vALVdg1M3gNYnj866EDzBVGEoisIXDlVtbZuX9s3+/vlQMLlZHp0fsEyqIJ3YqiD2vR4jXdblkxXuqcxRO04CMkDdjyWgppQXG5tB5KeQzdNUB0svH0wp1mgVOi1V0lC+CA2KVEXa1cTuFA
 YY8Ts1Lv
 4dbDzj1E++nLYeG6aX/PLMxoW6Hfw7byus6xuACJ45k98M4QkqGdVzuP+rWsDNtrFndRjgpIMwCaqC6IqFQyLUmNhgPAFCxqCmawHiH3Y2X5WqB2okqR4MDOJ353ECvlwnoeKWDJ+Pv9pJ8AS9NqoFqBEiP3kJJGLtghFFgGm8LlTO6DOaCx01xJbxWrFLa+UYsa8bFt6Jf++EL0NLTGYSQKEqTixSh0dzz3unULVbbd7mVnHOqtDHW/5ybh4e+o9EmKARWlNiQ4aK2A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kthreads can apply for a preferred affinity upon creation but they have
no means to update that preferred affinity after the first wake up.
kthread_affine_preferred() is optimized by assuming the kthread
is sleeping while applying the allowed cpumask.

Therefore introduce a new API to further update the preferred affinity.

It will be used by IRQ kthreads.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/kthread.h |  1 +
 kernel/kthread.c        | 55 +++++++++++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index c92c1149ee6e..a06cae7f2c55 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -86,6 +86,7 @@ void free_kthread_struct(struct task_struct *k);
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 void kthread_bind_mask(struct task_struct *k, const struct cpumask *mask);
 int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask);
+int kthread_affine_preferred_update(struct task_struct *p, const struct cpumask *mask);
 int kthread_stop(struct task_struct *k);
 int kthread_stop_put(struct task_struct *k);
 bool kthread_should_stop(void);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index d36bdfbd004e..f3397cf7542a 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -322,17 +322,16 @@ EXPORT_SYMBOL_GPL(kthread_parkme);
 void __noreturn kthread_exit(long result)
 {
 	struct kthread *kthread = to_kthread(current);
+	struct cpumask *to_free = NULL;
 	kthread->result = result;
-	if (!list_empty(&kthread->affinity_node)) {
-		mutex_lock(&kthread_affinity_lock);
-		list_del(&kthread->affinity_node);
-		mutex_unlock(&kthread_affinity_lock);
 
-		if (kthread->preferred_affinity) {
-			kfree(kthread->preferred_affinity);
-			kthread->preferred_affinity = NULL;
-		}
+	scoped_guard(mutex, &kthread_affinity_lock) {
+		if (!list_empty(&kthread->affinity_node))
+			list_del_init(&kthread->affinity_node);
+		to_free = kthread->preferred_affinity;
+		kthread->preferred_affinity = NULL;
 	}
+	kfree(to_free);
 	do_exit(0);
 }
 EXPORT_SYMBOL(kthread_exit);
@@ -900,6 +899,46 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 }
 EXPORT_SYMBOL_GPL(kthread_affine_preferred);
 
+/**
+ * kthread_affine_preferred_update - update a kthread's preferred affinity
+ * @p: thread created by kthread_create().
+ * @cpumask: new mask of CPUs (might not be online, must be possible) for @k
+ *           to run on.
+ *
+ * Update the cpumask of the desired kthread's affinity that was passed by
+ * a previous call to kthread_affine_preferred(). This can be called either
+ * before or after the first wakeup of the kthread.
+ *
+ * Returns 0 if the affinity has been applied.
+ */
+int kthread_affine_preferred_update(struct task_struct *p,
+				    const struct cpumask *mask)
+{
+	struct kthread *kthread = to_kthread(p);
+	cpumask_var_t affinity;
+	int ret = 0;
+
+	if (!zalloc_cpumask_var(&affinity, GFP_KERNEL))
+		return -ENOMEM;
+
+	scoped_guard(mutex, &kthread_affinity_lock) {
+		if (WARN_ON_ONCE(!kthread->preferred_affinity ||
+				 list_empty(&kthread->affinity_node))) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		cpumask_copy(kthread->preferred_affinity, mask);
+		kthread_fetch_affinity(kthread, affinity);
+		set_cpus_allowed_ptr(p, affinity);
+	}
+out:
+	free_cpumask_var(affinity);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kthread_affine_preferred_update);
+
 static int kthreads_update_affinity(bool force)
 {
 	cpumask_var_t affinity;
-- 
2.51.0


