Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7FC7C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC576B009F; Mon, 24 Aug 2026 08:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7954A6B00A0; Mon, 24 Aug 2026 08:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA4F6B00A1; Mon, 24 Aug 2026 08:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7876B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:08:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A433912010F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:08:42 +0000 (UTC)
X-FDA: 85136041284.07.3C3EFBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id EEAE980006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:08:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwYNaCQ0;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787573320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/BRx6M0sWOF5lRkxvQBnf742kB/koawcH9FfpZ801w=;
	b=4iUsRZRiprY6m2NivJHs7wpIBXOUiyuAOtSBbZr724WQ7XYJWTFl0CxY9MhebP+t60hpw6
	VD4A+UJQZKJoLF+1NSFUGsf4h4IMYEWvD3dsswJrX1mQgdIbNMwWOAz/WU8nfyN7cEHVmT
	gEJbgJHeIdsEwelww/HkUli9D5DYMqI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwYNaCQ0;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787573320;
	b=0VE+OpDEah7eOv099xVAtAk/p1wI8IoEkri7xhkYY5ffGL3hqPLtzL8k3/kBF4jPX1wQgf
	QQOWwA1E/c+fKb+nFZcwxbTuiQEfuDoP0chegAd9EfigSDE4AOwQfN8Kp3rMCrOM1zcp7M
	gtmmX2WPX6e/lEExJxz+TGLYb64/Q4k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C9DE600E2;
	Mon, 24 Aug 2026 12:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB23A1F000E9;
	Mon, 24 Aug 2026 12:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573320;
	bh=X/BRx6M0sWOF5lRkxvQBnf742kB/koawcH9FfpZ801w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lwYNaCQ08Sh6l7XGgwRZlDDmSSKrXqYwm396gFjuimZaVsGZytvx+p7297a3dagpi
	 YpWIXwnkPt3mAI1yUptAYf7Qn2PyKlP3Db5dDCZ5mqpsKJxfLojXKz3UozogGoGPPn
	 1XBsfiTvtxe2Tz2Va/ntmvrjrrRR7rWhAm3rzGa3kn7wpEplgEr4GYCEg1f09PyrhY
	 zy2Zyq1wMjn7aXPCbxKkDWRCgd47EGvF//6Qe3llqXdUYmjPx03lToU8YftAJDgWtO
	 IxpuSfIY0hNZTiYFal2u9395hoIKrXyECPdNlGqfatI1yXaDjABt/lLnC34accHbIu
	 0pO6cqfWmQYgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 24 Aug 2026 14:08:19 +0200
Subject: [PATCH v2 4/5] smb: prevent TIF_NOTIFY_SIGNAL from interrupting
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-work-tif_notify_signal-v2-4-6609e42b3157@kernel.org>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Paulo Alcantara <pc@manguebit.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2185; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DegYEG6tpjLPd6zIyd0uvEZQ+CG03dLYC5VoDZmbB70=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFg6rpr9/KnJblcjBY2oGa/3Tnoe9H/NLofT+5YsD
 r662Hr/9I5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJLDvHyHDilY5tlM6jJRu1
 0k8xFa1M+GWvUb/SfuU36yfbfUpaT4YzMkyKr+KfFrleNnTzleSyhg+SVjHGzTmm0sr3e5vPMMT
 nMwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ub3833xin4yx1h5n4hur9mf4c1wtqc3u
X-Rspamd-Queue-Id: EEAE980006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787573320-539273
X-HE-Meta: U2FsdGVkX18BWmRSFf8ZknDMAP4GqfvUqOd0PA+qb1vGIE2NoKQVR3i2ZsFMiv1oBNdMGVLLsO8CCfD7+xAMbPU7MlviOnDXwVWLgbUoDodF8BW+gybATO8kBvrwMfpN2Wlq8/x2mmYhhabSrwRK1GEg81PJ81DY6fA6ETm53Zq3+ioQcpoRy1cbhe02tV/SyxY20VVU4U60pjfpa3Hs0B5n068pYnIMsSGhkSfMD8VG3HtITQMnPJuB9PPMqK0WDAuy4iXBKOl2PIdyc9xJ4lRWak7Mo9TRgSDNN0DF/pqzTmwHV43fUug9mvcP0dnFHOq1XE3Hy8U58f/N6urQMBsrDR/2WcIsEVEXeN1nLNlMbEcBWgIvKfSYzLcI8aXecqmXtfMF3v5mtUltyCp8q2tWJymjMTuqI0QE3ZMdrbVjrK/6BMVeJjDeaMnJkVQV9A7eookoxLs3Cs3w0b9+4F26oENgfbA3z30awY5t7l2IQCbBSsHPIs5x8GrplYmzkknotKGQAtz0sDxL0+VmkIwQHPjdzIiELODHrP55uQpAyva26s8QKL0QXxYZN+DuyWzZ9Cb+3ubROMUcwY62cY+TAmQ9ej/txeukrZ1LOggkkRr1NUG7Q5krFQo1lCtm+/JSBBhd4PrxJhLwycE7Khk6r7L1fLARP/U7AG2BRa0cxCjQ+02bemTbPdLISWdW+d6CKnZlPvyP0gm0oeNIXnuE48PVKkOD0y/lOQTLpMVAOIZWsOQglrMmvtq5FFfscnOciWq8HNJ/Rp4vSIJb1AbZGXRcVsrjLkxvc3NSPYo3oYblcjNadOTzxmrqMNesOkQzV+f4cAYbgM8F1kR4VN4uC3WTllI2uVilMOnaUpz3ZhHctfmBG7+PCJwZ7bgI8ytH4Ulwl29b5WTulPiKkk2iwbBE/C3Kb+azoJFJUOh8vncLa1ZT/wT+DUdcEI80pvUZqO/EF5JSwNmNf3c
 NZQTejAO
 +18xG2NPsrLAaw5tiiQ2gBs1DGF6MCeTnY3DyJZffqyUiual9+g/6jqBWl61OS/pprnK8/5pyAKVlmxgVw0fL+9jPxCMFUVxVZAe/r+h7C2rK0R4HwAMo4oG7iFKGxH8OSY25OQ+miZmbTivznX7wEL4V4oDRk7ePrt5OpJpe7YjfXrR7jNaEoYPJr7MBpsIIMBJ3ZFEga3NIKvSOpCziWVr4efgLuy0VN17JPULYvpnCdRyGNI+1b4GVXcGfVM48ucoSrly7knOOlVcnHPrIdibpQgpMD6CQIB8lN4Y5Q/3gZlso4C4YuK202gAZ0qB4YE7kPpSykkAxogzy7aCgNEj4r4CFElI5YiEU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smb blocks every signal during some sends:

	sigfillset(&mask);
	sigprocmask(SIG_BLOCK, &mask, &oldmask);

An incomplete or partial send would cause the connection to become out
of sync. That in turn would cause the session to be torn down and
reconnected.

In commit 00be6f26a2a7 ("smb: client: transport: avoid reconnects
triggered by pending task work") smb hand-rolled its own solution. Have
it use the new no_notify_signal_save() critical section instead.

This stops io_uring from cancelling a send in flight but that's just
like it is today and it is bounded by sk_sndtimeo at around 15s.

Acked-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/smb/client/transport.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c27ce..35fa699569e9 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -22,7 +22,6 @@
 #include <linux/mempool.h>
 #include <linux/sched/signal.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/task_work.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
@@ -172,15 +171,11 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 		 * after the retries we will kill the socket and
 		 * reconnect which may clear the network problem.
 		 *
-		 * Even if regular signals are masked, EINTR might be
-		 * propagated from sk_stream_wait_memory() to here when
-		 * TIF_NOTIFY_SIGNAL is used for task work. For example,
-		 * certain io_uring completions will use that. Treat
-		 * having EINTR with pending task work the same as EAGAIN
-		 * to avoid unnecessary reconnects.
+		 * Task work must not abort the send, see signal_pending().
 		 */
-		rc = sock_sendmsg(ssocket, smb_msg);
-		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
+		scoped_guard(no_notify_signal)
+			rc = sock_sendmsg(ssocket, smb_msg);
+		if (rc == -EAGAIN) {
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {

-- 
2.53.0


