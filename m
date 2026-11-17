Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C0D60A5BDF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=YosMGajV
Received: by kanga.kvack.org (Postfix)
	id EC23A6B05B0; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD06E6B05BB; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71426B05BA; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C46B6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A40B404CA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
X-FDA: 85445116008.17.C1B27B0
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 68166140002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=YosMGajV;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNeXdPblFT6nrj2baxWLtBPVceCtM0s58uH/6Q+lFQs=;
	b=sFgeCWuayvQsKxbzWlJbaHn4brqzeMuLFPtk4gLAo39VEEiaif5dRim1F9ugSOdROahga5
	xd6fg3lXPUUb0IkCZYtGi3RdKL60Q/1xXqACTD6Qnp5Kuil5RhQq4ZoAkYvs69dGaVEWb6
	7ogTeiBjGaS/u4DUZWP/i6DIIq4rdgA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=YosMGajV;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932242;
	b=FgTWrQvyU4GdMwT/mxUzyWK10Zlg1n0WN8IQtA9FHTgAguau3MKc4OxGBnkeTlJxnvfMP1
	HVA9MEAdleiy+mjbM1c4xIT5rzQ7UXe6WDQ74dun7ruqcrbN77l2QpMUe5/YUmvMD0qdzt
	hHDosOalJCeoHT86SmjgaOSprekMf5E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932241;
	bh=BNeXdPblFT6nrj2baxWLtBPVceCtM0s58uH/6Q+lFQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YosMGajVdr8bTyARSt14kbBXxvqSLwIkBzVVm2iFc2dB8LzONr4+DOO6kMyHMraZM
	 HLKsDFwyYbKp1xFvRvE1bkMBPGBH+BLhOmAtqk/XLaenm0e5siruQORsZ3FVHPgQX8
	 o0zmCt1KnhHrXRuGIQJHjydUj7lpQdmvQ+IMBt9XhF3Fl2sYHs/eXvC1fdtq36jUqM
	 fertguGTxjKDGkk8w+3AgKjWiK51C4xlXqCXHrI5Y2Bvyl6PShOM2rwQX6gPcNECAX
	 iHvJ3bdS7vc3BXbU9V6OjzmbnWsX7xUeRlEzgk0D/CYqsV7Z4J1GC0TUgkD9ONx8JG
	 vO1OFuFnKMkTg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHj55RDzRKW;
	Tue, 17 Nov 2026 11:17:21 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: tglx@kernel.org,
	peterz@infradead.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	paulmck@kernel.org,
	boqun@kernel.org,
	shuah@kernel.org,
	kees@kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	oleg@redhat.com,
	bestswngs@gmail.com,
	xmei5@asu.edu,
	xujiakai24@mails.ucas.ac.cn,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 02/17] sched/mmcid: Give no concurrency ID to user workers
Date: Tue, 17 Nov 2026 11:17:02 -0500
Message-Id: <11039c504295ef6ee0eef55981993d8f5d1f40ce.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 99ii67tto35rs7xat1kdqkdt4miq93pt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68166140002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794932242-744674
X-HE-Meta: U2FsdGVkX1+jpRUNw5luNtbkg8uY4jtlzoJkxNmXtew0lHg7093cTSjErISgdSY0DmK0T1ojbqxZnYrFuh8+8rtzR2X0X88eBVsH7ARS+ZsgIqCgZ1HSWY2xT9QKNWs5bgxNaU85q+rbd4e1BukztTij0drfKUVMSiCxLXuUlql6PlqyuJz2CKkWlhz8bgY7iotgAftLaSKLi27z1q55ZJK65KRZz4JXJv2Gs50Mjd/dnx9+ROWQn48J8S0v8e0f1QIulIa6QubpCbCpgSdWtIu+2o3v/99UGFbGEHMILU8+U4gZlcZeFuC8Us3R0sdyMIU8Fi/cYQY2Cabmc62yIO0k2aU6pzsmFtTHiLoBbpY5lxB+vMqCmK1173VVikx/Bp13994w1u0KRn8T9YpAUbQ0CdiYnIHGg/u/fRp3jNzdsHVIfY1I/g1Gen12M3yXBhWrOQ06AfVFuLxUtoHzvVfqmg955DNuSPKsTAYACz7YiGf/1Fbvwq+aZJdY8a864SUmClzmzrJKmimdIaKM/cNCQgh2zTNC8V0IcltbP7YGe7a33Z7tBtlSLX5Z3DLmFsO4cBkshDaTszoGPsXHWwctUsWiSX0QXSUnzsPnt4HiLPsIguVzCl+enrgKCVwn9P50HXl/QQxYjPsQzbgmcPDdS2uyy5Ttk8Zl79BKg/0OfqCupOagzZxAYYvzVuVoEP3H5GGA7E1UeOCVN8/1/X55vvhZhOr3WuNksLu2qbxItDZnZ5aYAQp5u08Im/Gtx7iWyUkBQ+GbbUWGx63sp39qakd8ijjtOJZxNeMbSpEYNXLFNWAV0gFhI5niRLk7lc4+glZX3gNUaPbleutfLlKU9qj97OPbMCmCBxGOQpLN17eaEqqspfgtMt0+XzV048/5k8sdRidgsEvRbOEWsTAi6YpSPtNqsmfpVU0OtMeAF5Zyg9LDOmbLZ7dm43Suu6xqqvn1tI77QUJSD4a
 y0xcsHr/
 E1hQDrZatmnBBj60FWj+caTYtu2COkNbkBENz5nzLg/dlvqypJf+xdCNhDQMcca4NIKCBoGLnmZzwuqyxr8DpfoOuUwk9FOiuQuJOptasYPNeEy5Ot79u4pLq9EEupUuNTeECTCjlx4FCQm/gAtVk9UDo8OhtSi0Af5KSgNX4wCzNpw14Ail1szR4f/nd1Y1utbKSV/yu0zwrwdRrxpY1x/LehhrGPsi9UoZx/HQ2Tv+h13UWY97B47ggLGJ+IZIyhy7KUewQMlcL8m6p28w3KuGAl0ete6hqj0LQF/RRi5/b5O2dmcijWBVb8x1v27B5xPo/G9E3DD/hmCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The workers of io_uring and vhost are PF_USER_WORKER tasks. They are
threads of the process they work for, created with CLONE_VM. They only
run kernel code: copy_process() gives them a kernel function that ends
in do_exit(). They never return to user space and have no rseq area.

sched_mm_cid_fork() still makes them users of the CIDs of the mm, like
every task with an mm. A worker takes a CID whenever it runs. It also
counts as a user for max_cids and for the switch to per CPU mode.

Nothing reports the CID of a worker. But it is one CID fewer for the
threads of the process, which then get larger ones. The added users can
also switch the mm to per CPU mode. A process with io_uring workers
would then read mm_cid values at or above its number of threads. This
was found by reading the code, and has no test.

Fix this by not making a user worker a user of the CIDs. Kernel threads
are already left out, as they have no mm.

Fixes: af7f588d8f73 ("sched: Introduce per-memory-map concurrency ID")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f2a981d418eb..7e213e88ac28 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11000,7 +11000,11 @@ static void sched_mm_cid_fork(struct task_struct *t)
 	struct mm_struct *mm = t->mm;
 	bool percpu = false, flip = false;
 
-	if (!mm)
+	/*
+	 * A user worker (io_uring, vhost) never returns to user space and
+	 * has no rseq area. It needs no CID.
+	 */
+	if (!mm || (t->flags & PF_USER_WORKER))
 		return;
 
 	WARN_ON_ONCE(t->mm_cid.cid != MM_CID_UNSET);
-- 
2.47.3


