Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AFD7C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7476B00A0; Mon, 24 Aug 2026 08:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D646B00A1; Mon, 24 Aug 2026 08:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A532E6B00A2; Mon, 24 Aug 2026 08:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79E456B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:08:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2758A02E3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:08:45 +0000 (UTC)
X-FDA: 85136041410.22.661DE46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0DCB74000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:08:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=auaeZgQ+;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787573324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQui/Mo5x/mE+ZdE3He0UvEKRAK0DKtU9+wg6AGH260=;
	b=DCh5Of//fH7zXBr5Q/4KEu8v7GpyFeGb5k6KG50YJA/hS+eXyh/0z6Jnmx2ST1/NES3ahw
	EdT1pO1f/BKco3hK1uo4CSWzgvcrYBX5Z5sPR1pbK0CyN0Ib7tnEsiPZUbu7nBbah07kOv
	SjqvH3e2atU0JPJYdngMnWb6oTqJFgM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=auaeZgQ+;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787573324;
	b=3xSI/EY6Hyvpc2GumdL4IgC2oOJphe4D+SGITBHySyoXqd1szBrXOO5o9aDH7RK4ATMpxc
	lRdNBLaHdN54uYzJEzOIwj+WgHAMVCcS1M8pAKWbyZ+r89JZo5RLaQ/Tvts2SnFbdWLROc
	S23KiKi72cX0FZLvrFXIMgS65wOFAkM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60AC042DED;
	Mon, 24 Aug 2026 12:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64BA1F00A3A;
	Mon, 24 Aug 2026 12:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573323;
	bh=uQui/Mo5x/mE+ZdE3He0UvEKRAK0DKtU9+wg6AGH260=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=auaeZgQ++dDT6ZiZ6j0vOGeWJbMYu77qkLcsAZ2LPTVROkev5iy5DviBSsIzb2Y6/
	 ZtcONh6wqJlHy5SxWbXTiC8pzO2Yi0YIaBNME3eOzW1iJtF1EBJez+ifmeeXFsLPWP
	 p03vPpvNElYn6yV9r0s7L/StVf289CXsvw40aWG2jiRORRnogxOjWe6qInEB+SPJeh
	 E3c+MsE1MOi87IWGqonmZ5BEFSESrz94UsQsQjqWEZ0pM4Ugy9YsvSyD0bZ02I0qtR
	 yHGM4KizZC0xb9QHNPxhlMSQtUh6aD5/izOnJy93eOjZCxzEHBByLIfEt4wVC7Zao2
	 1nrdZMFEI7O6A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 24 Aug 2026 14:08:20 +0200
Subject: [PATCH v2 5/5] pid_namespace: prevent TIF_NOTIFY_SIGNAL from
 interrupting the reaper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-work-tif_notify_signal-v2-5-6609e42b3157@kernel.org>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1853; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DNuXd0pKQn7U4+pLkpu+uX5FDrR9RBOyfwfmgrAQmaM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFi+/SQbxvzpzDOeWTM1LbY8mlm86STj0xu7n77kv
 T3fTGcmW0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEql4y/OF/4DczK1bwzyTX
 ABtWL3eWI5Gab1ZtKU3/dIz9/iTjcGaGfybL9IRqYoU3fGcv36qcMOWBmmPQ8flmz/ft4/nMdol
 djh0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0DCB74000C
X-Stat-Signature: z5hxzpgooditkgd8c3q5hr1rssmo5uai
X-Rspam-User: 
X-HE-Tag: 1787573323-860737
X-HE-Meta: U2FsdGVkX189OsI1TbAN8eVp4AiNSoOG7ibWwG9leYntK65+WwGhE0haq+1xcR+kqmC0awogaVpccuz3nV4OVt4/EwywW01MvadRxusEh095BdxnGNmVPQDAYD6jND2jVECVzvlqVNnTGHdzKxZL90wRq0Kt2hq7ftlNhBGGiElGcSXeLFWwRnnG9bGBZJTr48IoC4zrxKdoz4OFb9fjY04s7C3jDVA45ePzhp7DLSKYul/6uPT2nj93E6prBsDkyDD79i6a/jKgPBUbt3+PaWNM84ftiSXJ8Dw7dd2pvDxdZ/zYNsJqqPkbJNEc+2ujgCyMT1CS2qstmj9vRNLi0GUt9fgapUi9Kuabw1kP8N7as8cB5sDFtnIxEGcuOITTXDlEGBgADTs8/jcCET3ON5lAqliQ+t66t2TafWQbXRpyKalS6ASnMf2DN7dUgKyKxcv6pmeCE34IHS2kuUViCT/DqO4C0TgXVL8JY/hntbyz27oQ8mSa1/ESFC6KpGh3bcRb0FRyF/FfH3PdBOehM1Scn2YwX+kgpxaN/5MjYVX05hZa7zIv/Yek9mRLw1gNlSZQ5ErzzXOIbhKxbfJHp2OiomEq574UouODn/VmXmyHmpcd8hwH51SFvue8wEDHG3ZNa8nI75FchnQFi6CFHij+yk2WJbGXrJyWK6133/9zD9dblcwggj/Tv0DjYZGwdI1F204V0DK27S7Bjr0gOsE/6PhUChbsKiOo18NsIyG6BuqbBR0kAtrE76ErnuKmgxNCvAuCqS6JUFdHCZ3aM1vQ829lG19Mph2muD2q8YJIlDA+Ge1jznT0OPxAhEsJmWTSNUfYiqNKJ2XpbWS+lGtuLg65gINah6ytDxExd2tcWZg60eOpzOkdw3hsxlWHkhKsnqFgFEpmsFXpMyV9Mhrk24yqAGaKxRP7wY7UntifWjIUtEfJXxJPOoX9aCxGWBUP4CYXb93p7QsNsnr
 tVE2Nicq
 Andl3n9mKJ22A+5ip+C2kW7l6R6AVOWC2HTpM1Ex/sDwZm9gPP6uuXAXPf5oI6EvZwMJuaZOfrXgk37bnSr0BDeo45kcUtSZtnlvlpDp8DmjAKgvXGtGHPhPYDJkFNrLcBaAMEp3P7AlZab3RvAHa8j21uk1SY+lGQTuEzFFyZl+mHDaRUsM9Pi2eQGreW6UPZvcLyWHF2KbZv3rKzK707WRqtJ06myCAplRz2uC6yHWHja8EWmQJ5GuKk9X1S77tBpCu4eIxrfEzVRR2q1DtiOtVO/JZuii0/qsewFAPjUDvZtfhyEBrcG233F7ri7CrupzD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 7fea700e04bd ("zap_pid_ns_processes: clear
TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING") zap_pid_ns_processes()
clears TIF_NOTIFY_SIGNAL before every kernel_wait4() call. Otherwise
kernel_wait4() doesn't sleep and returns -ERESTARTSYS if
signal_pending() is true and the reaper busy-waits.

But clearing TIF_NOTIFY_SIGNAL doesn't fix it. It can get raised again.
For example, klp_send_signals() sets it raw against any task that hasn't
transitioned yet. And it keeps sending it until the livepatch finishes.

The sleep loop waiting for pid_allocated to drop has the same problem
and it doesn't even clear anything. So a schedule() in
TASK_INTERRUPTIBLE returns immediately.

Use a no_notify_signal guard. signal_pending() will ignore
TIF_NOTIFY_SIGNAL and the pid namespace reaper sleeps until a child
exits or free_pid() wakes it.

Fixes: 7fea700e04bd ("zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING")
Cc: stable@vger.kernel.org
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/pid_namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index d36afc58ee1d..8bc9edb40b78 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -238,9 +238,10 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 * kernel_wait4() will also block until our children traced from the
 	 * parent namespace are detached and become EXIT_DEAD.
 	 */
+	/* Task work must not busy-loop the reaper, see signal_pending(). */
+	guard(no_notify_signal)();
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
-		clear_thread_flag(TIF_NOTIFY_SIGNAL);
 		rc = kernel_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 

-- 
2.53.0


