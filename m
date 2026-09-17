Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF42C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D3E6B0093; Thu, 17 Sep 2026 05:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E152C6B009E; Thu, 17 Sep 2026 05:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04216B009F; Thu, 17 Sep 2026 05:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1056B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:17:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1470C0288
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:54 +0000 (UTC)
X-FDA: 85222702068.14.544F533
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C5FC180003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KYJTc/1t";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmePqtdvMZ97XNvmYZYeJrcxanSNhpLDtQMBoLeGYMQ=;
	b=vRgzeXETLoyGna7cwDJMgpBRjE73Fvx1EQON5DqK4P497pJMBLD5k8yJd/smocfn3W60Hd
	XWoQ54JMHFsdk99vb5q3aNv/1x6+lAzG0jZmJdzGeLgQA0mlk+mnAPM/HoOUdjg5Zb0DKA
	FnisqGHWmIOZld0649fhe27BAV+6H+A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636673;
	b=JktxgO/fbcLBjQ1Iy6of7BjXWmWjOeJHNwRzoaUPS0KxK5WmZDF+CeAVlaIPvtopByfwTF
	Engr+JDw20c8Re5yql0yC85vkwbxh6BalIVowK2JeF20zjtmRAMYlKi7i5PTxML0SvEKW3
	VXSuDUg1Dv7fUmjb/32JDHUBZjQHuA4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KYJTc/1t";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A379C60210;
	Thu, 17 Sep 2026 09:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BDD1F00898;
	Thu, 17 Sep 2026 09:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636672;
	bh=VmePqtdvMZ97XNvmYZYeJrcxanSNhpLDtQMBoLeGYMQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KYJTc/1taPUsJNANXqvWRASFBKCIwEZrq9dNkVvLRpOzazYulS1jug1h5fejg4D1s
	 25YsW3t8rSLK14fJvO5r6q1bkza9ImBoIyaLrnelvKCC3M2P1f/2MPR+0RZ7VfU06K
	 IghjF9lvlykiSzmZ6SbYSsq2bEOdXS5Eu0d3xQSsCStHeN/tTPumHRA1cPsdCxmGph
	 EFFTKTYMGGlB9KgXttFIhj25DQR0XLZxXk2RHNthO05Z8rc4jUeRijYVQIH6VYbNId
	 9dAHizb4ejr4zoHcKVI8pZhoLUc0s7naT5mb1FGATjEmawJveeTqYuz9wpzJ6gAr33
	 5Mlt6pdCD4teQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:17:29 +0200
Subject: [PATCH v2 2/7] coredump: hold RCU while releasing parked threads
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-coredump-fixes-v2-2-f3787fcda051@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1642; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nEYFwInjRPuYzhOfHREsUwY1LGlm++L9mB9utqpJfG4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3mAy88s7p6wAmXU5O7Y/8FQQaXnp+FZZrO7EW9tui
 12c12Vvd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkW52R4Wvny01GC5TWOuzS
 3PxqZoXPk8tfgrdP23YjyVLU0tDn3C5GhrmVhqtiE//bJ8Xdc5/+Qyvw5P/zFyR/3v2b97daND+
 7mRsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tsgw1f469tjo8n1pctfnw8xnbi4jobyx
X-Rspamd-Queue-Id: 0C5FC180003
X-HE-Tag: 1789636672-337741
X-HE-Meta: U2FsdGVkX1/L2dG90PC4Kkd58vQgnfhroVQkuxICNWDnzsBvuApGa9csHBEAjr+iRuViGhm1gYgzGJSzLsjwCwnqdApXbvBtLOYF32rIckA9xLG0ZCGY7E9akjhrj54dDSA8OSEtQico9ZN1x69MQFfCHcdQluAflRZTDPnUOoZk5qqZf5z9w4SRdO4Dm421Pm54YLbWakDSGhvZciQ1YS1udtrsxBxf+HBOwgg4Ohu+qV3yv8nQ+QkJPFXD8M/tUMRJvmZtdpKvHEaFn1M4Hgxywfwwbjlv3A54MlkEeioA9vj7cShX1hMmOATR23QekqYWeNm/awaoRFeG972+DY6l4N7w0jgOZoaxEWa+2nH8vgFzmqxDzpsbQQKuSK0BzieyNiEeRNabbWo72WToBn6uc9/pCyVQfmY/BwmMGFk/pCe32HR77JwzMNJkBCflGsYJ9s2/HiW1QqR1upooP2/CSIgv8xcAFuo7R7zk0YexmAXWsUg5vMg7TQbt3zgjc9PtD5hTwfUJK3uUGXu+ck0ENvHmm0f+bkZIf3ljfOThdznkSSlVi5D08GDmM73B2/LdCz8u70dCxtyAdyQDhEbYPd5hyupMey69XOpyOTAHPZmX92IvnScx8XKG69xQJ7r4CJ28o5RQp6KyLqgBObv4Bt/a+bMNZNT4PsMt/IPRucRDCJgg2PCH57D7AbTBD3fLPu7psJnhkXHjTupYuSDKGpHb0sgWZH/1By/fY5PihPkTt9gU9SW4D/u0vjY6FSk8Ar457/zzUUhuWj2h/0U1ztgO4jAwunAU9hrmJuE5SyUfD4GMgGgT2CCP7B5AIqAdpYS1KVEdRYquN7I9rFh6bN78GgPIVqYOTZ9G1Z/AScKWciF7SMRkw6w8NfZE+fKAFPwBMRjvVMy7XCgtIjbZ4L+k3ZwxSmaC9M6uqv6sX8ruoJmwO2bODMH/htPi5lyQ/Dd85cRRKvbmBND
 vt6iaY9G
 mCbt4nR/LJyPm3ElH9MLjPHsCnexZxmicWJUupaUY1pvagT9S3Nk0nrxOr6QbCNcXRUlyHDZARsDykmMZjq7uq46nhdfTg69AFI3eXZY9jd0AFoOwXlz1U1+LVSIVwVu9p6PzN18naFZT9O6yzVYJ7hyD2kdfUpMChI7PW2CgqGK8/LjLkvwPX5pIVxTNeZXEoFDWd5n085F8tuevFDO5cvUerKE/rx6sX29oBr/NemKD2Www989QqafTwGq4kBX+3DRLtjxtagc2aH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

coredump_finish() releases the parked threads by clearing ->task in
their core_thread entry and calling wake_up_process() on each of them.
It does that without holding a reference on the task and without being
inside rcu.

But calling wake_up_process(task) without rcu here isn't safe. A parked
thread doesn't need that wakeup to leave. A spurious wakeup or a
preemption after the store is enough for the task to go away.

So if the coredump client is preempted between the store and
wake_up_process() the thread can exit and be freed in the meantime and
try_to_wake_up() takes pi_lock in freed memory.

Hold rcu across the loop.

Fixes: a94e2d408eae ("coredump: kill mm->core_done")
Cc: stable@vger.kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 1fba3fed1a07..5b3f3a1090d7 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -598,6 +598,8 @@ static void coredump_finish(enum coredump_state state)
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* A released thread may exit and be freed before it is woken. */
+	guard(rcu)();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -606,6 +608,7 @@ static void coredump_finish(enum coredump_state state)
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
+		/* Any wakeup now lets the thread exit, rcu keeps it alive. */
 		curr->task = NULL;
 		wake_up_process(task);
 	}

-- 
2.53.0


