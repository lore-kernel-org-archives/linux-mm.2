Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A89CCCD18F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2C18E008B; Mon, 13 Oct 2025 16:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA928E0036; Mon, 13 Oct 2025 16:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0C58E008B; Mon, 13 Oct 2025 16:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 988C28E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:36:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 705581DF953
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:36:07 +0000 (UTC)
X-FDA: 83994247974.08.4D5B1EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD413180005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:36:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d2HsIj0G;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGdj3UhN4DDaR9cP8b0NALwx4FhyUYgq9KowsMDlFqI=;
	b=xEWAZP14u5IDi6tx1YXEa8MtBtZ628XGSZSRmFc6YsHgdJoZOB6wCHGrMN78CHJLqfBkkR
	ImGoYwy8vUjd9ZPWLDUQyP+3wNC63OLK2qGkRC/vqQAAWD0mclvl6OiJHXT02NKLpyZPia
	NVuwdYJRhcgoU/HtPRqR/jjyFuJfVQw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d2HsIj0G;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387765; a=rsa-sha256;
	cv=none;
	b=pctAlQGgbzJSqhbZrtwNbHtqs7OvQUyS36T9++MtStoOC3tlmV89suFYKRi2NHlnTfPUkr
	p/rxNNamRfydPsESyq0pp5/bXuvMjYrjsM8p5mRbt2zbpcxFqoEvO5v2o9sUkOiIWxbDo4
	AYxkSagtAHQrbmD/Hnz+kVCIEsVJtCU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A80D61E71;
	Mon, 13 Oct 2025 20:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2137C4CEE7;
	Mon, 13 Oct 2025 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387764;
	bh=chMAaHPdvZjXfYZQTfmqroMaCahKvWi7hxvycGkBc0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2HsIj0GjEnJTG81nuvxt+rh9V8jVDkwbolK1vZjH/QLdrhSvnA4rL0lejyT03fUk
	 AYQKAmOHXS+cRkZyMi+8eL/fcdpoD5VY6iC9oTM4NqHv00OF3hCY96KH1rhoGQ9WaS
	 FAvGOoJh3cunza7z8okA+g3/wzRnll3xJH1fzYwKHMUEuxT9HranLKJnuHZYIdXZCl
	 DAR47RiTFVA+tE01uD8gMxCMzvEl7IPtksM+od6OjCFZjAEroLlDCHRxcoddmDtTra
	 uUCQU+FtsHyohiTXjUfWqTx58+dKEq/DSkCy0XlqFAOBoVjCCVB/zzVTbAzQ5eAKLi
	 rFUdm4g/rBL6g==
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
Subject: [PATCH 32/33] genirq: Correctly handle preferred kthreads affinity
Date: Mon, 13 Oct 2025 22:31:45 +0200
Message-ID: <20251013203146.10162-33-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD413180005
X-Stat-Signature: kmrsya7azj18oyoi76f1hu3kncoqfb8w
X-Rspam-User: 
X-HE-Tag: 1760387765-269665
X-HE-Meta: U2FsdGVkX1/+MyGziXqknccduurKg8LoKbezBVishz9lYKB+pJeU5GBCZHzikCaxhvXNT42AY04QB5NkhzOpY4i5SRpGoCWeRAehZN5HaKaKHBUcHCjnjnozsV/kCBUnNGmRusZIzwD4BhpRW4zvVIwHZYFA1Sa89hpai6A8LOwxMwQrbzO2h+KQDqotsLGJoLmK5B717ZlFdhs5sHxwukTkxhBxZ53upr+l+KfGsPe5e2gK806H5lKG4Pxwem+n4wSVItPCZay3pxhaLQm47Rze572lqZVPBXxUZ/nvzFSuVboMXub2KBKbC3A7GlRLJ+6G7sA1J3zsObDrfyRFIkh9bs7dyMgGeQmjCPFzu5BBIDMquhfYnCmx7FIoqRodFSbQ4EIBcPUxoj5ynvSKVUmpi7+jdovdouThZu8/N9isJHdfaqhUObKivGbtExfH4kQdTYYc1bzytteyraaeXtpdIsiRbwXM02mMd64tZOGjJVp3HQaqjwkrLmYaC9bx5wnVQHYWsZR4f2jU6AZy4QC8LHvQNvAFcwQ2MucVHl47tWrJyfiG/pMeNiAzu+XraWp/K7hBkt4S4s9mEze+F77z9NijojF7XeCE0K5jEoazQ5xaiZVvaYKI7EcJzL/Rz+RbTVGfPbHsIURZX7N/6RhmU528QzB9aZk/FNXem+CHhheWP54a3EMl9fIk7Mc/8sg500pwNFkLTNeGd2hd6CMgNVvXjwwdQ5ZzBWGE88EpcnQ4uorggYu/lGUHJ+L3wNVjchslwBnHOVlzqm/dvHOXp/IbpIwgxM5k4pfHutAPRDMq2gSJgJcat8dNIqZVWpapZbNBVzT1bwG2bDHxZtv43SMGcEtyE18/g8XKcI9orSlAyc6jlIfP3O3SEH0K9KsdKOssHnH+SnAhu7gqWH1lnOd3tWiPGo5CISjSNg1NgXkVhm4mkchUe1iAi2Vj8pGlkKMQhTiHn8L6FrO
 h206rs4c
 dQcGkVFsRQ1V/AV5NAlM72v+k9puQV4+1o3MyMRLCPYwMNxLjSgHHeTmOY+uDC4UDm8keAkFMG46RjcR+WlKNjWcaHCq6lP5mvn650C/X4XAqajNo234pl1fvTSSw+nU5WPXeCF+PxcdMetXqQFUWmwj142to37roZaiesrPTKBXHw7FQbi+VcvT3SpVYKFib1RkNMh9NV0eSJX73uytO25EjJi/r8si/Bps7ZFA+s3Zz9iKsEecqAhYaCYUrkdjriP+bKcDkmJxoT3U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[CHECKME: Do some IRQ threads have strong affinity requirements? In
which case they should use kthread_bind()...]

The affinity of IRQ threads is applied through a direct call to the
scheduler. As a result this affinity may not be carried correctly across
hotplug events, cpuset isolated partitions updates, or against
housekeeping constraints.

For example a simple creation of cpuset isolated partition will
overwrite all IRQ threads affinity to the non isolated cpusets.

To prevent from that, use the appropriate kthread affinity APIs that
takes care of the preferred affinity during these kinds of events.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/irq/manage.c | 47 +++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c94837382037..d96f6675c888 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -176,15 +176,15 @@ bool irq_can_set_affinity_usr(unsigned int irq)
 }
 
 /**
- * irq_set_thread_affinity - Notify irq threads to adjust affinity
+ * irq_thread_notify_affinity - Notify irq threads to adjust affinity
  * @desc:	irq descriptor which has affinity changed
  *
  * Just set IRQTF_AFFINITY and delegate the affinity setting to the
- * interrupt thread itself. We can not call set_cpus_allowed_ptr() here as
- * we hold desc->lock and this code can be called from hard interrupt
+ * interrupt thread itself. We can not call kthread_affine_preferred_update()
+ * here as we hold desc->lock and this code can be called from hard interrupt
  * context.
  */
-static void irq_set_thread_affinity(struct irq_desc *desc)
+static void irq_thread_notify_affinity(struct irq_desc *desc)
 {
 	struct irqaction *action;
 
@@ -283,7 +283,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		fallthrough;
 	case IRQ_SET_MASK_OK_NOCOPY:
 		irq_validate_effective_affinity(data);
-		irq_set_thread_affinity(desc);
+		irq_thread_notify_affinity(desc);
 		ret = 0;
 	}
 
@@ -1032,11 +1032,26 @@ static void irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *a
 	}
 
 	if (valid)
-		set_cpus_allowed_ptr(current, mask);
+		kthread_affine_preferred_update(current, mask);
 	free_cpumask_var(mask);
 }
+
+static inline void irq_thread_set_affinity(struct task_struct *t,
+					   struct irq_desc *desc)
+{
+	const struct cpumask *mask;
+
+	if (cpumask_available(desc->irq_common_data.affinity))
+		mask = irq_data_get_effective_affinity_mask(&desc->irq_data);
+	else
+		mask = cpu_possible_mask;
+
+	kthread_affine_preferred(t, mask);
+}
 #else
 static inline void irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
+static inline void irq_thread_set_affinity(struct task_struct *t,
+					   struct irq_desc *desc) { }
 #endif
 
 static int irq_wait_for_interrupt(struct irq_desc *desc,
@@ -1384,7 +1399,8 @@ static void irq_nmi_teardown(struct irq_desc *desc)
 }
 
 static int
-setup_irq_thread(struct irqaction *new, unsigned int irq, bool secondary)
+setup_irq_thread(struct irqaction *new, struct irq_desc *desc,
+		 unsigned int irq, bool secondary)
 {
 	struct task_struct *t;
 
@@ -1405,16 +1421,9 @@ setup_irq_thread(struct irqaction *new, unsigned int irq, bool secondary)
 	 * references an already freed task_struct.
 	 */
 	new->thread = get_task_struct(t);
-	/*
-	 * Tell the thread to set its affinity. This is
-	 * important for shared interrupt handlers as we do
-	 * not invoke setup_affinity() for the secondary
-	 * handlers as everything is already set up. Even for
-	 * interrupts marked with IRQF_NO_BALANCE this is
-	 * correct as we want the thread to move to the cpu(s)
-	 * on which the requesting code placed the interrupt.
-	 */
-	set_bit(IRQTF_AFFINITY, &new->thread_flags);
+
+	irq_thread_set_affinity(t, desc);
+
 	return 0;
 }
 
@@ -1486,11 +1495,11 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 * thread.
 	 */
 	if (new->thread_fn && !nested) {
-		ret = setup_irq_thread(new, irq, false);
+		ret = setup_irq_thread(new, desc, irq, false);
 		if (ret)
 			goto out_mput;
 		if (new->secondary) {
-			ret = setup_irq_thread(new->secondary, irq, true);
+			ret = setup_irq_thread(new->secondary, desc, irq, true);
 			if (ret)
 				goto out_thread;
 		}
-- 
2.51.0


