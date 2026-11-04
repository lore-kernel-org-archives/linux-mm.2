Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF796098F6B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mJyOhlQt
Received: by kanga.kvack.org (Postfix)
	id 9AE8C6B05C0; Wed,  4 Nov 2026 14:54:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9861A6B05C3; Wed,  4 Nov 2026 14:54:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D886B05C4; Wed,  4 Nov 2026 14:54:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68AC86B05C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:54:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0464612064E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:54:51 +0000 (UTC)
X-FDA: 85398489624.20.8AA005D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3AC3C100004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:54:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJyOhlQt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LwOyQmkvG4TrYSsjhoNvmU1CfgZA+V6RV4LLe+r+cHk=;
	b=xtgKWEtrszOU07gWAjPanCtHJE8BpSvyvp1cLz10MewDVDZ8plLPJGcCL2WBduPxBEnoWd
	Bqwc3GgrjIg5ogS/0RMnVDx8sWYufzy5T4J2edEz9vWieS2vYhiQucxg39W+i51Q+BSKxi
	zGj9brRwe5Rulq/wOuEUfitZ+hq+dR8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJyOhlQt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822090;
	b=SPdsGL7ukKr/36E6MlWq9yUv1k4xidA5euisdGXMf8aSfSywjesltyApu9Fsug5XIdGoCE
	LFf2ISLavwMa0wmv4vterrZrlRYUEVpFgmEe1zM5i+UniNynwS496iBAA1i1E2O5HjT9p7
	mypKK0znHfA6Z+/PKOhlxgqxCnNM780=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8517C447A9;
	Wed,  4 Nov 2026 19:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2B01F0093A;
	Wed,  4 Nov 2026 19:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822089;
	bh=LwOyQmkvG4TrYSsjhoNvmU1CfgZA+V6RV4LLe+r+cHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJyOhlQt7v/yUeJe2KxDzjfIgCPFjEFsKvYVx2A3N/ozpWFiPJU0KUhNdF3Wnx++v
	 sI9BCBWIdMMiP0QcpAXFpZsOn0jW7NrHt4r2cB6NkOMsL6mxo8rFKgvE84hLglCx66
	 OqQujMha7035TQ4ZwwiVUfu7SbYHZU96GqKi/rxAVkSUfLy231e9TMVVFOEYebJCby
	 NOwJ0wLy1EviZyidaxTUbqL58HBSyhB/XKNBxXObC0roAJt5FLGPIUnCJuWzz6FbgG
	 K3Yv0a5upmIEZWtQAvIYMc9ZxBopPWyj6ON1cpCflNYuRijpKAoniKAIZEUIsRrLGe
	 wTSzOu7fuS0uw==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 20/30] sched/psi: let procfs own the wait queue of the pressure files
Date: Wed,  4 Nov 2026 20:54:35 +0100
Message-ID: <20261104-work-procfs-fs-v2-20-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6098; i=brauner@kernel.org; h=from:subject:message-id; bh=CeHhvuLOJ2DxGx1mSjted70KaKApRIjx6GoOIAUH5Kc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97nEOnuN4eKv7y+UynWu9t7p/P/D2dPOuOt7MtW4RY cbN7Z4KHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZtpnhnzqLca7vmStVc8on LzvQtZvr1cV7Wl6vAr9Pan8zzeRX1XOG/zVVv26edFdZ+WTuhnfLRZpsnu+SuzP1+Nxz33L9reT Tf/MDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AC3C100004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 767wz1jof5fwtust1xqrf3g7iqk9hfdr
X-HE-Tag: 1793822090-560995
X-HE-Meta: U2FsdGVkX18spOcJXJKfhGOg7KCS79o2bqNFTreT38PlmscJIwiIQd4rbfqQM4ye02uekY14c6gNfDfAvXJre3nCrL1TzW/B/BKmQei5KQLb8AcnduUVmfkfuEQUuSL7wul5WwocCPOpiU1dwvM6pTPX9Aa/k6sKlD/R1WrZGR52M1GU/eRvMx39lasvsIeT8sBU1jGhb/UT8mqeM6vKwCaz4U0MCP9iWDX+YEgJpHMwl6h2FcckUfzQ4e2NI0ohk6Ot4TOEPRQW2Aa2uOzZLPneRZPgr5DDSCmhcOB7CNWOrMy9T+6IJ0+GKs1AjlS0fMU9/VWBUHeTLVh4QmjkZnnzNk1qJursIS2w3zCr1Owu0JRFDiETfcOOISmx4u4WswGvz+Te3MG4L3EU+qea3w+Y6RVzdnRGNGd4ECjQci83ZfYCSsWGiz2kHuZNIoYx99IwreYRCPRXrmACopgzXtWscaQXxrTsYPPnbWhjXbehd3t4HCjBfywnIbQ28ZV1Ipt61DCkCNB47MoF1Pw/Ve0rNJKKWzj98nh5fo74O7WlS4ISeDaT1X6pbXrOkRMt4iSvrz7XnOMmKcOZHsj10vHIHY0/noZK1wwHkDl/satNY3ktBKRf6+w9ToAN8E8XeEsIzga92MnmisjakG8ITdSMHTia5dkO9t2IAzS/qhytLMkl2TW12iCP7UGpRU+GIlkybTKFiOjg1BZsYUpGe2+f5c/nVml5yNYyt3094xgfOdkoeLfDAs9e2Q/CT3Wh3TMj3whrkRQbZ9+1T6LWoaRG0PhL2xI6A9PgI9uPXvFI8ZAZzhbjfz7Fb73ivQXiTR+M6VYWtXr+qAbvmYLFpQrrItXzwfJCOHgaoWBeHMDEGiLS4Rwig9XjVAm8j9kpp7KRcXPEoBYbWB+eN1m814HMevGRQWFaSDF4jxNLc6WpH9gg8l76jaP7pMVir2LiZug7AbKybDOpeQkW4gK
 8uq+Looo
 8CcvF+ky2VEOXkZiqHVxm+JvICmwcvuTFk/2xXduThVPfM3aiLtgJ1XxJA8HtSisRUrcetwnSCsj1H8enAckLA9fn4x4WjjrSi2uxcOiMruZ8PABRAAdlsv2sJVEUZRlRBiECKmmbfjDCMErWRx6Cfu8i+CfOmqIDPk6EEXPQMe/tp6nQPcTF6BWYs6N/Dnt3lclzbXuuWFFGkD3GzV5kgiK/xHIkReRTYehAMY4eEcv/8bZ/vVWBQF0tOxeUo6n0+G67t3M8Q8eZLyyMpScb5zMpis09l0AH25gy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A trigger on one of the /proc/pressure files has a wait queue of its
own for its poller, the cgroup pressure files use the queue of their
kernfs node through kernfs_generic_poll() and kernfs_notify(). procfs
owns the queue of its pressure files now, so use it the same way: the
poll_wait() is procfs', and a trigger that fires wakes the pollers of
its file with proc_poll_notify(). Like for the cgroup files every
poller of the file is woken when any trigger on it fires, and each
reports the state of its own trigger. psi_trigger_poll() doesn't need
the file anymore.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/psi.h       |  3 +--
 include/linux/psi_types.h |  8 +++++---
 kernel/cgroup/cgroup.c    |  2 +-
 kernel/sched/psi.c        | 30 +++++++++++++++++-------------
 4 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index 7966e3ac03b9..c6f536631411 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -30,8 +30,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 int psi_trigger_create_rtpoll_worker(struct psi_group *group);
 void psi_trigger_destroy(struct psi_trigger *t);
 
-__poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
-			poll_table *wait);
+__poll_t psi_trigger_poll(void **trigger_ptr, poll_table *wait);
 
 #ifdef CONFIG_CGROUPS
 static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index dd10c22299ab..ce772575c5da 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -8,6 +8,8 @@
 #include <linux/kref.h>
 #include <linux/wait.h>
 
+struct proc_dir_entry;
+
 #ifdef CONFIG_PSI
 
 /* Tracked task states */
@@ -132,12 +134,12 @@ struct psi_trigger {
 	/* Backpointer needed during trigger destruction */
 	struct psi_group *group;
 
-	/* Wait queue for polling */
-	wait_queue_head_t event_wait;
-
 	/* Kernfs file for cgroup triggers */
 	struct kernfs_open_file *of;
 
+	/* /proc/pressure file for system triggers, see proc_poll_notify() */
+	struct proc_dir_entry *pde;
+
 	/* Pending event flag */
 	int event;
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a284225f8dc9..c5da33495ae3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4232,7 +4232,7 @@ static __poll_t cgroup_pressure_poll(struct kernfs_open_file *of,
 {
 	struct cgroup_file_ctx *ctx = of->priv;
 
-	return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
+	return psi_trigger_poll(&ctx->psi.trigger, pt);
 }
 
 static void cgroup_pressure_release(struct kernfs_open_file *of)
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index cdb7a832333a..97b5e2488106 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -514,7 +514,7 @@ static void update_triggers(struct psi_group *group, u64 now,
 			if (t->of)
 				kernfs_notify(t->of->kn);
 			else
-				wake_up_interruptible(&t->event_wait);
+				proc_poll_notify(t->pde);
 		}
 		t->last_event_time = now;
 		/* Reset threshold breach flag once event got generated */
@@ -1327,6 +1327,9 @@ int psi_trigger_create_rtpoll_worker(struct psi_group *group)
 	return 0;
 }
 
+/* the /proc/pressure files, see psi_proc_init() */
+static struct proc_dir_entry *psi_proc_entry[NR_PSI_RESOURCES];
+
 struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 				       enum psi_res res, struct file *file,
 				       struct kernfs_open_file *of,
@@ -1392,8 +1395,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 	t->event = 0;
 	t->last_event_time = 0;
 	t->of = of;
-	if (!of)
-		init_waitqueue_head(&t->event_wait);
+	t->pde = of ? NULL : psi_proc_entry[res];
 	t->pending_event = false;
 	t->aggregator = privileged ? PSI_POLL : PSI_AVGS;
 
@@ -1441,7 +1443,7 @@ void psi_trigger_destroy(struct psi_trigger *t)
 	if (t->of)
 		kernfs_notify(t->of->kn);
 	else
-		wake_up_interruptible(&t->event_wait);
+		proc_poll_notify(t->pde);
 
 	if (t->aggregator == PSI_AVGS) {
 		mutex_lock(&group->avgs_lock);
@@ -1495,8 +1497,7 @@ void psi_trigger_destroy(struct psi_trigger *t)
 	kfree(t);
 }
 
-__poll_t psi_trigger_poll(void **trigger_ptr,
-				struct file *file, poll_table *wait)
+__poll_t psi_trigger_poll(void **trigger_ptr, poll_table *wait)
 {
 	__poll_t ret = DEFAULT_POLLMASK;
 	struct psi_trigger *t;
@@ -1508,10 +1509,9 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
 	if (!t)
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
 
+	/* a /proc/pressure file is polled on the queue procfs owns for it */
 	if (t->of)
 		kernfs_generic_poll(t->of, wait);
-	else
-		poll_wait(file, &t->event_wait, wait);
 
 	if (cmpxchg(&t->event, 1, 0) == 1)
 		ret |= EPOLLPRI;
@@ -1610,7 +1610,7 @@ static __poll_t psi_fop_poll(struct file *file, poll_table *wait)
 {
 	struct seq_file *seq = file->private_data;
 
-	return psi_trigger_poll(&seq->private, file, wait);
+	return psi_trigger_poll(&seq->private, wait);
 }
 
 static int psi_fop_release(struct inode *inode, struct file *file)
@@ -1670,11 +1670,15 @@ static int __init psi_proc_init(void)
 {
 	if (psi_enable) {
 		proc_mkdir("pressure", NULL);
-		proc_create("pressure/io", 0666, NULL, &psi_io_proc_ops);
-		proc_create("pressure/memory", 0666, NULL, &psi_memory_proc_ops);
-		proc_create("pressure/cpu", 0666, NULL, &psi_cpu_proc_ops);
+		psi_proc_entry[PSI_IO] = proc_create("pressure/io", 0666, NULL,
+						     &psi_io_proc_ops);
+		psi_proc_entry[PSI_MEM] = proc_create("pressure/memory", 0666,
+						      NULL, &psi_memory_proc_ops);
+		psi_proc_entry[PSI_CPU] = proc_create("pressure/cpu", 0666, NULL,
+						      &psi_cpu_proc_ops);
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-		proc_create("pressure/irq", 0666, NULL, &psi_irq_proc_ops);
+		psi_proc_entry[PSI_IRQ] = proc_create("pressure/irq", 0666, NULL,
+						      &psi_irq_proc_ops);
 #endif
 	}
 	return 0;

-- 
2.53.0


