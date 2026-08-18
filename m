Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC50C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B856B0178; Tue, 18 Aug 2026 06:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3BFD6B0179; Tue, 18 Aug 2026 06:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51FD6B017A; Tue, 18 Aug 2026 06:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85F126B0178
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:29:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84291A262A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:29:52 +0000 (UTC)
X-FDA: 85114019424.08.05F1835
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9D25C0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:29:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QqauSKQ0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787048990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5uPn/aNxaggwKLcm1ypjdrg/Nu/GJZLii6douxX+c8=;
	b=bZcpEBAkA728OhFArHahUrNuqGx9Tn7UEv9y7yR0lDxbaCHxMUnXD63K6E57UEiptQ4tCZ
	CgSizRw7paO/SjHJc3rk+PSRC0Qe9YHSuqQzf1k5f3zKWKQTynA0ycz7TCYZcN/nv5OLYK
	Wni/4V2VMsO0TtEoNwnACBMjvL9Y+cQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QqauSKQ0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787048990;
	b=XxpcJ/CvqUO9Uyw3T+ZhmB3Eeijc9puHe1GoBhtfhO7dc9wjDfGRTcvABwmI8VBcpXsrGc
	kFgDUho/gzfwhnJc3+yNFzITqKqRyDvgOsRr0Lkm7jcC3zNBJjvMUrGr+7LKerYxlgS1As
	XbKs+T2akpuHPkhUKiSGEyZgk1V6iRI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EE5460A59;
	Tue, 18 Aug 2026 10:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADEC1F00A3A;
	Tue, 18 Aug 2026 10:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048990;
	bh=A5uPn/aNxaggwKLcm1ypjdrg/Nu/GJZLii6douxX+c8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QqauSKQ0GXzyMDD4lZDP5b0eCGig9L7ovZxo46V8STWM6/YqHy6Qz/ZTG5zKq+KfQ
	 Q1ouXdfFEc1DmV/KL52o8mCCUmHrXB4Dfl5q4tcg+ATdCw3IHhglGMlMryYdkygWPS
	 K7bYmdIW0t+nHL1Us7BXnFCUSrCDYjjrGXcQN6q/Gb8VkEOh5XnFvO1sUdg+yyirBL
	 83EBw1oUCUctGTz3+1GcRv91jo1XZcd7A32I/vLn63EmkNfDAo6xULPd6ttQJelanY
	 vLTHIjMAgaZFGEKLB3NRYPLIMRybByrBlzHzCIYdtm94Z2Ygg3UBQtCjinTnEz3r5R
	 47I9voNDEgtJQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 18 Aug 2026 12:29:36 +0200
Subject: [PATCH 1/4] signal: allow taks to temporarily block
 TIF_NOTIFY_SIGNAL
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-work-tif_notify_signal-v1-1-1ee1fcc5b3ff@kernel.org>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
In-Reply-To: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2967; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GPNbpnB0jcJa4smLJiVmwCjZkDxhRfuvI09qEeH/sQI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1mEhMmtW6JHi34afW+Y4Xd9+seZh6RISx1cdEKOGKY
 EnJUbmJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5EMnwPy8y6+uZ9jMZM9t4
 fWwsyg5ctN34SCH2zaaLSSdffNLt9GT4w7NLPbl5YWnU+X6JffsmPo2ZJ53ntdfNeqN4qcCiGVK
 TGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: q4fnxqshxhry1tbbuirs9eikzx9dmmte
X-Rspamd-Queue-Id: C9D25C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787048990-666184
X-HE-Meta: U2FsdGVkX1+EEnyg2S1TsBl71ZXJuBKXFb5phV1VO0pQ6e9rI4J/pGgJgGVQOvTzPX0lDJIyoYcv7+3Hl12ja2JlJ/E0QRZBFMIyoW8aK+Qof4zn0ueokBYPxEy6t83/oe9UE6Mj6OTfWWHL6G1iRzp/9F4uq47gP5/pVDni+m7213hyb0irpmMvsDhzdkIPrgAoCGp2XDT38JFRGqxJFCz/udSILtsVwu7Oe8I+10m9WbzrjgJjClbKfHRpdMuJbO5kNjp1bUDh6jsbvXKMxItqnjefCrquEWNEc4NaKs2TF3FdXoA0cO/UfA/dpuf0qIZLV8rl6vwUckEmmF11XLO9X3r4vFrAmcZYQ5vKmYmoTIPOJWADMyY880y7s6VGT9m/UxY8ZoLh7SbAFSwWUtZSvPeEE9osR17MEsB7x38Dv8263c6hxStUfyc7WIFL5LGFUdk0qVhqiiPihjEPDRUICB2+gdY9yRNehiL8yd9ffIXyMWikSXbbOVD76NkqPUhVVHFv4oQ6/vAlW/3Tiu8wgp27WIZ/50eFl3J9AhSe2t6qq39KQRpLLEzl2HxhDjvySFvK1OYSXj2MVM7vhdSBf0GeDW3zHYPWoC8KYhYFIq7BITIwg76Uhx4EMGfMpp97cl0ktTf2UcKxRpeQK4HnFcfImlAf5b1ttZyo0ZdLVOe3uIYCXeoOfzjiFFsL6LBHUMjPADvNlvYY62lvVIHMfFCK/LMziFoPB2k+JD2GRHZW2BexSWBwZN65oAPtdIeMzmU2gQ214mcHWAi88pMUFDSawiNnQWglZcbQ2yx1O0ThN67Hu2dVqMnyiOClFfDILE5Q8XzUnYUao4/bjm1cASQvwYZRrzkHgxn2haEjm0yGXcFPdRQbd7uN61Tz00iJEW0VpMF5TlWYVuHSdmQwovBKrojQpKuXG1QyxQ/f7D1FTlEJk279BiyCljaYqJgnrBxkDZIrSQq4T6p
 mB74PpqA
 fzgsuO39RM8itH4wfGzIxiS8FBOVyWNPVHqZzVJqEnvXTjYKWK5IAEk751/m4WtPwORHzE36yPQ4FhR2jniCC7b3zY4nOpLLDMgx2qf7VgZJJxWvKqru3GgYZv2gItOg2tMQSTnWeW2VTZ/48mFRby91eb0H5qMZY6FgXF77jbmDep/bGeZl30RmGvaxdHRXKSJvwzEbeYOVhBUcwCZXIHRxEH74sOA8pwlfhNyUufmXElLPuAZsL1T739SWW6JlrNzKjy8NrbF+kvLfQkBQyrToIeljrdqueo9jF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TIF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks e.g., coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

Add PF_NO_NOTIFY_SIGNAL and helpers to raise and restore it. This is the
same approach as memalloc_nofs_save(). signal_pending() will not report
a fake pending signal via TIF_NOTIFY_SIGNAL if inside a
PF_NO_NOTIFY_SIGNAL section.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/sched.h        |  2 +-
 include/linux/sched/signal.h | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 373bcc0598d1..fd72ca4ee92f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1796,7 +1796,7 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF__HOLE__00800000	0x00800000
+#define PF_NO_NOTIFY_SIGNAL	0x00800000	/* see no_notify_signal_save() */
 #define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 584ae88b435e..3182de4ff948 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -384,14 +384,31 @@ static inline int task_sigpending(struct task_struct *p)
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+/* Prevent TIF_NOTIFY_SIGNAL from interrupting this task. */
+static inline unsigned int no_notify_signal_save(void)
+{
+	unsigned int flags = current->flags & PF_NO_NOTIFY_SIGNAL;
+
+	current->flags |= PF_NO_NOTIFY_SIGNAL;
+	return flags;
+}
+
+/* Restore TIF_NOTIFY_SIGNAL. */
+static inline void no_notify_signal_restore(unsigned int flags)
+{
+	current_restore_flags(flags, PF_NO_NOTIFY_SIGNAL);
+}
+
 static inline int signal_pending(struct task_struct *p)
 {
 	/*
 	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
 	 * behavior in terms of ensuring that we break out of wait loops
-	 * so that notify signal callbacks can be processed.
+	 * so that notify signal callbacks can be processed. Not for a task
+	 * that asked not to be interrupted by it, see no_notify_signal_save().
 	 */
-	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
+	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)) &&
+	    likely(!(READ_ONCE(p->flags) & PF_NO_NOTIFY_SIGNAL)))
 		return 1;
 	return task_sigpending(p);
 }

-- 
2.53.0


