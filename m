Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E3EC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632066B009D; Tue, 15 Sep 2026 06:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BACF6B009F; Tue, 15 Sep 2026 06:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6776B009D; Tue, 15 Sep 2026 06:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 060786B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:22:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21364A038A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:52 +0000 (UTC)
X-FDA: 85215608184.03.9FB2928
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 45E79C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OQTXkm7P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467770;
	b=qKW00L566HitvFVED0aVJo7BDVBtnXaCpFjETPBRq8/EnVX0uR+f4b6WzowLYre+kOJvRL
	m9iEQjqu/PC6xqK2YuGOTHMehhd15gsJz9D7uXLWLOqLMdTCbSmzfToU25k0Jb/urrEokv
	je+SkgFmEzcfMA44I9RdcUtJ3/aJZdo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OQTXkm7P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Lfwr6DOZEL712P9mk5S4cinKmJtaSPg9LGMOLkoIvI=;
	b=1Ng6S/M/hSMc8cASeT0R5JycHPlHd/4ogPW5ReiQgiVqzJwM2iBPvlIEFtHRx0/rPPJTJ5
	/wXCzi8Gq2SUoS/gEapwk7BIVoo0U+cI7qM0gQVDDDzyrFejt1ygI39w6zNnxnXaOD1/dl
	xwznx8GMMLImPkwbYfNeSckjxFNbVOU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98B1C42E0C;
	Tue, 15 Sep 2026 10:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D131F000FF;
	Tue, 15 Sep 2026 10:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467769;
	bh=+Lfwr6DOZEL712P9mk5S4cinKmJtaSPg9LGMOLkoIvI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OQTXkm7POpmghchxaNkGvtcXtdXm76bpQ8ZxWm+B3QBzgU0ST2VFq5KqUnO4hhQRP
	 fFLpGL+t4GwnL4u8J1dRV1HsADNpYBrxbaQn5O6lg4LR4v6IZSM6C5eT89XNZsCk07
	 5H7bvxmABJ1ue7nBzDILxz3qRtSYNktF5IKea38meFXGwe9alGZgZj7Ii0DGfjg0Xf
	 lQrUu+J2PjKq+nNoM9m3AT2y+B2+Mgh3zMLmIs6imZ6P11jUEgQRbGHH96OmszAQhL
	 8oPNePv7lrOfCTeUVKYMkx15tkzRwhxQmeeLu/hdOMPpQqPX4gWIBxdIlauIHKSorL
	 Q1uFe/Ekp4dbQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 12:22:19 +0200
Subject: [PATCH 4/6] signal: only SIGKILL interrupts a coredumping task
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-coredump-fixes-v1-4-f354ca41780c@kernel.org>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
In-Reply-To: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2928; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wEE0usJXExKGpjCvpVt43sCmGWJShblWOIA/77PWrYg=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGqpHGijRDk4mk14U0sKIqMGh9oPZ352zjxnb7ninkYbALDDp
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmqpHGgACgkQkcYbwGV43KJNmgD/VSH8
 FkLiZlfi+FXpjhT54oVKKQ1kqWXsAMvoIboEKrcA/RXFD5+8zc9AFxnf6PL1yZXmcQkyhk3fWXs
 2ENjyxkYO
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 45E79C0003
X-Stat-Signature: s8eourgn587fi8b8r5ubq9tud3wf67ar
X-HE-Tag: 1789467770-904463
X-HE-Meta: U2FsdGVkX1+y7TnwrrMyzJK0o4ZSgHEIC5rERO3+WqKxaSDf/C0Y0v2Se022AcAnO0a6UJeOTl2st0fxPrrUZVIB1Oab2D6WGA1fN+7/ziLhLBHMczPRx85nxILZEBJH/YeETjE4L0BMv5mWsrykO2KFrC/qKdQhyCQj3sKBtNwvNk/7eJemcFYseal1wo1LcBHx7TPTj61gbERRk29mpk6HVbkxIkrpMlriUVyS9g5HpVIRLs8gaGc2xaozPEnkJYYVMvNah1hoBjJQn2RikltC3HzAf47M4uKjIeMQZYVKRD1EwfObegpcH+m9BupxpXdeg9MChTttoQncMN6HQTsn0PsXlOmSfK3VikWts6DgvZS/EVmPoSJUDzlaktenCLVlyokPfbtHgvlrtFAGcPOAd2N285/bnyAygKKSV/DAjN2OKvioMV4695hxhkHfwNjOu4Zn5n5J/GH7LgdRmOxs0JSxIu+t9Mjabu5LJPDer6zRNzFRqLgisKaaVjvWGIS1XjPf1ZNxfvBHawQUM2NXz+EZ5+XQg69ebCtccz2Z0sGmqiBZA+qt+afECtuuJc/xeVumXCp3JKvPy2EspyO4abGnrYSah+x4KJSNyyda7oPI2OQ14MGNor4/OPnUOdJcUlonLgMsViUOHclM80hvbwbk25QTrJpMx4cWslH1es4v1f01KAHYd/JnrZiTF8zQn3oXgf0bCX2Kkk9a1QYQbEtT1ruhjstzGPvBYCPSyDRopvFtfIRlftD7CRBIFKZ4TOB/Uec67PWRcWd4gZrn3Rnnp1uToSq84EydEZJ6QBxZxNDc8OMZtabzki2tF0AKDKsf44lpTtCqGPOWPak2wFZ0jjqJi/qVC31v9Qfx3DCPzzX0/bGvEBbjogjA9qZ5xgrFOoK4tiePdZzB5gDLOXUdatomz+UxUSaEFe3pMdYRSiFEBq5Xio/+QcGTYcx32An0ZuoF6h8t1hr
 qIxgpCIL
 spNmNZzEid38Qj1grJBYbE+F/4FsCsvCj70dxlJlyafNzeQshTBPh3cqnqr13kA9CNZKs48+q86Z6XtMB9qfBQ9/PrEyNhxiSEbmHhthOgjdLEmwkU46C8RdXj72MEh5Cwl7iO/DHoxcw7dt/+7rBrzUjHQIniHWJXtVqM0LqwwrSmS/QuvUdzhrj5e5kRexwDTT9UdoRNcknRxbAjGQFH4MU23c3MF7Abu90/ESgfhj0htm322zAy6ss5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The coredump client only accepts SIGKILL. I've massaged away
TIF_NOTIFY_SIGNAL in another patch series but it seems that
TIF_SIGPENDING also has some warts and causes truncated coredumps:

(1) cgroup v2 freezer isn't built on freezing. Instead,
    cgroup_freeze_task() sets JOBCTL_TRAP_FREEZE and calls
    signal_wake_up() on every task in the cgroup. That includes the
    coredump client. The coredump client isn't able to act on the trap.

    So a freeze that lands in while a coredump is written will block.
    Moving a coredumping client into a frozen cgroup has the same
    problem.

(2) retarget_shared_pending() doesn't take a coredump into account too.
    So if a sibling thread is in the middle of changing the signal mask
    or it exists with a pending signal that helpers points the signals
    to other threads.

    While it skips exiting threads it will target it at the coredump
    client as the coredump client isn't yet exiting.

So it's related to PF_NO_NOTIFY_SIGNAL which I have sitting in
kernel-7.4.signal. We should be able to fix it this time by making
signal_pending() report only SIGKILL for a task
that has PF_DUMPCORE set.

A cgroup v2 freeze now waits for the dump to finish. The PM and cgroup
v1 freezers keep aborting it through dump_interrupted().

Basically, PM should be able to interrupt the dump. cgroup v1 freezers
are legacy crap we don't care about and cgroup 2 should wait(?).

Fixes: 403bad72b67d ("coredump: only SIGKILL should interrupt the coredumping task")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/sched/signal.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 70067ccfe2ba..3a7ff3416e57 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -386,6 +386,11 @@ static inline int task_sigpending(struct task_struct *p)
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+static inline int __fatal_signal_pending(struct task_struct *p)
+{
+	return unlikely(sigismember(&p->pending.signal, SIGKILL));
+}
+
 static inline int signal_pending(struct task_struct *p)
 {
 	/*
@@ -395,12 +400,12 @@ static inline int signal_pending(struct task_struct *p)
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
+	/* A coredumping task only stops for SIGKILL, see dump_interrupted(). */
+	if (unlikely(READ_ONCE(p->flags) & PF_DUMPCORE))
+		return __fatal_signal_pending(p);
+	return 1;
 }
 
 static inline int fatal_signal_pending(struct task_struct *p)

-- 
2.53.0


