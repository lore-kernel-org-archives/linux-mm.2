Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15015C5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB5E6B017D; Tue, 18 Aug 2026 06:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2EC6B017E; Tue, 18 Aug 2026 06:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BCC6B017F; Tue, 18 Aug 2026 06:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91AF86B017D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:30:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FD62120B98
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:30:01 +0000 (UTC)
X-FDA: 85114019802.20.2E70D6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7E6E6C0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:29:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOFcuzXp;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787048999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oA5YhOItUInh8TEcUIpTf7oUnEBcO06MQC7rRQBXdXo=;
	b=kmZKukmF4YInlmsP5T3e++CT+MTCaw5AGpowGu4Ymdr1L4RJDce+UzDQyADuJ9ix2jF3ok
	+6B6GOwooLNP6nQQjGDRwNJyYDDWsV+2+RFc5Sg6YJHhKY99pZEN0TaWvtG3tfspnaXEGr
	c7zXBPyLU1GQa2rWRVHd3HKbcwseWAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787048999;
	b=OZd3DsgHgcnvwaXqc2SjLPFtchi16tW/3P3LDVXqn0zb8WEkbtUD49gm4Mt53R4LgfrGxa
	vpSjbhfFzRQ9dU1PGcv0PgN7Bzjo+MmKUyzoRu1rrI9nCLsSBxk0eejvAUQkfZ0GOFX+2x
	fvIbU5gFL9rOfvFCJhZ/kQUHm6VuRu8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOFcuzXp;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18BC760A7D;
	Tue, 18 Aug 2026 10:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E941F00A3A;
	Tue, 18 Aug 2026 10:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048998;
	bh=oA5YhOItUInh8TEcUIpTf7oUnEBcO06MQC7rRQBXdXo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HOFcuzXpnKI05Fmts6b8sTaR8G+Nie1XPP0qhdWGno/awjz/3qX2CxKOnnKijS7v4
	 BUU30bv01pzSO3PifvCMDfFsmaZpIsGxvWO3CVRkukQlnR1wUCZTnV9HO8s7uo5jrl
	 7aV5vXAViE0JxPFJ691ULt3CDQV3zcrcoY0aIUK+LPaXNh5l7God+ejWTBy+ghkgj2
	 db9PVSLhO8qVjsVpXIsmZQYyDqQWJ5OGIcN7lBHtRQoB2Ez0cF5ozxqOE0UTuSwUAO
	 BdLlSFzn6i0vhUzxnnrmYm2GDEooILujNH/XyIWKnkbazCXB/vKazBiSihh3TbGtx0
	 5yWaQ3KIJkxRw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 18 Aug 2026 12:29:39 +0200
Subject: [PATCH 4/4] smb: prevent TIF_NOTIFY_SIGNAL from interrupting
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-work-tif_notify_signal-v1-4-1ee1fcc5b3ff@kernel.org>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
In-Reply-To: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2385; i=brauner@kernel.org;
 h=from:subject:message-id; bh=PHoG4Al+J6bmlX5hfjF9xp+ZYim9zrGXQmfo1DpuFPY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1mEhwbL+3bJXZT9MfWj4VASUfWCuyT1m+K1j/au6Gq
 TNa+D4ZdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE6wzD/8A5vto3tRx2b9/U
 tee1i+2r2eIrD35on9fYvdakOPB0xQeGf4qToh5Pz8gqCj50ceK5H7GiSxuC+8wemO9VM2U91bz
 anwUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: ud5nepccujbb6kzfwaf6azp66se7s6yq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7E6E6C0007
X-HE-Tag: 1787048999-116646
X-HE-Meta: U2FsdGVkX1+vsF4FGAHNPv7Eri4M9pt+QoLng1MkHLILxEES4lBml2yZtih8UEUO/L8+VRkuooAEYMwQtIklMxQDRQ5UpEVsiNHLcaONqUI/RVrz996lZp/N8VpmmeY/2Wu89RGlnH6EegEh54nuhzHR0NyNHnhHlv7BMTgSEmTXM7K4dSuWvvnMK+OfKWJOOnxfMUWstRe8juqG2NjLa8G4lOcC2wvfRK4EjuOKtZaNs5b7k0qYxRkhyNfgkeXC2rme/Uww+0kbC5uXWxA/2PN2m0DR7jCjGah5xLtfQi+KhmD1Rj2nfBIKkCKM7DxKjKZ2HxpsFAIE7+MQ9KVhbB7SMrrLCtW+xDG3fKW13pzK/y5TzcoDgsqM+gkDQswpqw9lMiOTvBC2PPULCUB2pVfbux4vD/kYX7Ygv2qBDqy2Xw3EUudmfF5bqi6I5rYpw86GuZHUGsZJLdgj3BKZDFsXkcZUPolpB0XjhylWg9HFPdWSRExepIkUvvsMnI9BH0rb//fvf6/YitMAzSfctpVtskhcz8i6dWYga8XZqBVrKcD9Pqb3l2wTwgjIkcZoSPje5T7rF7dd+Ey/9gPqZ7oVh87kUmGPUqiTwl3gaoQuSp3Unb+vXUE9KdqmwEOCljcAppcGpIOT6+WaLJynUWqmm/VyUjK/pfhudj7+lTm6w/PlUL/pbgVJIQS7g6kYBlDOT+1ScIqlSk7kXpK6v6GFpadrqRbWOot0bNeOVIWxWhJChDm6jTIED46pvZAYwnY2CtJPpbjE2sRhF2VCzNvO1CZElzRcCN+m3DBZCwwmM3jxzoT9bI4s16/235DABD1ibuUfqP7CsxNeru8Y2bEn2gdAHTfJHxHHKEZe7SEwcR8i73utzE1RRKYaQS26Modjqzj/fH7hMdHyqZ9REByxBMa54BzexVIMKlXjbYh2Y0TkR3WaDLsycgKCOPPcV/CMgxV4wGqAsXJD8hy
 reEY7WWL
 ZuuxOB/4/9if/MEHmaFQ9SXqx/vzyBwly0OSToRYfOn5N2Vv9fW2Rlb3D0xEKVvIdr9qOA4jcD8TJf50oq+aUHwV3jHl3bzKRvFS1bVUu7JQkZY+44+yr/wVc3MIk7SEIoCWV4zXrxUjUhAUW+vq1QWS3Ij1DjDP3xU8U9fzE/T3MtDbKBRw0vO+jV71gTFENJ4UEHd7Rii/Lez0JIRLR0dfpciKtU+Y3SGAMXP9xzH5d/ZVirz7JVqqjPsmui7cS4nts7nPkQnxVAgjKfYCkGBV8sw0a882hEHwde9uTFCzFGnbH5LKm5n4xz+ULvktqUzqx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smb_send_kvec() blocks every signal during a send:

	sigfillset(&mask);
	sigprocmask(SIG_BLOCK, &mask, &oldmask);

An incomplete or partial sent would cause the connection to become out
of sync. That in turn would cause the session to be torn down and
reconnected.

In 00be6f26a2a7 ("smb: client: transport: avoid reconnects triggered
by pending task work") smb hand-rolled its own solution. Have it use the
new no_notify_signal_save() critical section instead.

This stops io_uring from cancelling a send in flight but that's just
like it is today and it is bounded by sk_sndtimeo at around 15s.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/smb/client/transport.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c27ce..05dc20916c27 100644
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
@@ -142,6 +141,7 @@ int
 smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 	      size_t *sent)
 {
+	unsigned int notify_flags;
 	int rc = 0;
 	int retries = 0;
 	struct socket *ssocket = server->ssocket;
@@ -172,15 +172,12 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
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
+		notify_flags = no_notify_signal_save();
 		rc = sock_sendmsg(ssocket, smb_msg);
-		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
+		no_notify_signal_restore(notify_flags);
+		if (rc == -EAGAIN) {
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {

-- 
2.53.0


