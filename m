Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D040C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F80C6B00B3; Mon, 21 Sep 2026 09:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9486B00CD; Mon, 21 Sep 2026 09:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E57D6B00E7; Mon, 21 Sep 2026 09:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0CA6B00B3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30FFF1201AD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:52 +0000 (UTC)
X-FDA: 85237892544.21.41CA733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6A9741A000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgZHKp3f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7befY0H1lv8bz0CNNtoWy7rE2i+jj9bv4BeRmq6iXmU=;
	b=IDT52qZVnqn3jfUan9poa2nx+7bfqRHLcLkFkMEIJr4WsXLF6xu/sQa+qAHHlninHgz/0A
	2kvMlrrWonQ6/NUkQouzbLwP6QjeyIJc92W/VVAYICy8Fncu1Vhvi6+9pCDf0UnbEVhRbe
	oAxQwNimTaucKQXkYmyYWJmu7qRl0po=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998350;
	b=rCBiO25uKIbj98MFyKKmIteAwqtinmFRRcm6FF6Ti0O3ErhLBUF4WXMyr+XXx43avfANFy
	Qq5m+7dO+B8H5pVaPzZ0kyhygjMEY2HBCJ699IX1oZNqXGpO9LyYu57p2GEAiQIUqjzVnq
	gVMTZG5bPBS0ixRiUinxqD0ijNr7zt4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgZHKp3f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F726600C8;
	Mon, 21 Sep 2026 13:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44CE1F000FF;
	Mon, 21 Sep 2026 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998349;
	bh=7befY0H1lv8bz0CNNtoWy7rE2i+jj9bv4BeRmq6iXmU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CgZHKp3fFsHD6pZE97W2eHD0S/3+v5Jskr/Gt2dFx6r/HuEBeQMiDXtAjxQWCqXp4
	 cLwxQU3j9NQXW9pDWvSy8koH7wakDDu7qYjJRgKoVlB8esyac5o2s5Qy/byRZTJDyH
	 8zj5PYZDq+yROLWGS5JwiupukUpGrmt6rWYhMmss5MbzhuxwrYb4YqlO6xmHL8yy0u
	 ZMauVv2gS/wowDY2H6lJUXx+uMf76vsUV9dCsxzN/2XocDAdmaIlq2XQU1jyOXzyOW
	 7oLI/s4Tn0cGNXGkAMqODU9/zcSlSF8i/XxDig3vKaHrGIaci6i1+TQj+O1XyHkNBW
	 7Og2PBwKLddRg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:45:01 +0200
Subject: [PATCH v3 12/17] exec: cancel io_uring requests before de_thread()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-12-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2082; i=brauner@kernel.org;
 h=from:subject:message-id; bh=E2TTe46dbf8f5z7wtULy+9nnGSgHQ2lB5ZQgulfnziY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLlTFOJ1IImRndEjO6tTMrTxl7/dfrfjKxhZvNn9+
 I+xJ37tKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmEhiIyPDDMF5X7h1WBpmPs5M
 a7yy/qhty+TYX6K3bVenhD1XbZ8GVHFO1VFadPY/X8YfQVEL2nIkrD5emJcf7N3La+vy3ak1jx8 A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6A9741A000A
X-Stat-Signature: nzw6sgswct4onw6c8efw9wprc85eukbu
X-HE-Tag: 1789998350-480246
X-HE-Meta: U2FsdGVkX193DtRHJcBnFVtE0pCvwLiPliZFoibVE+9zqrBE7yqYWFAPu1CFlZOxdE4zFNYEsKeGEIOj50/IW7LPeLysO4ZeOvoc2+zqCbXmKfXKUDek9Ib/X3Nq47pKog2joxaQgaBsluJxovC6mrcKXOSDNkhn8ycaQw5gtxusLyGQaMex1b2bsAIq/OZejQ2WbT/ieQLFRPvO5tY75/o/Gk61+uattpUmVoJGetMUC5BGAP1LoSDh08i+3eMU48DChNsYVnZ8V/E58EoZVOy/Y2ENIFKV61Cjo4cQ6WKSibiHPzHU4aAXChWymv+zXGRlXt/ZQqloJnTZ6dwucEwcjeU7QtvR6HXiqMBqC1lGPxkv6Frm+ogh9ZHDKeCVef5RlYKnaTj6PfMQWUOMxoYvkkiFDIs8sEpyM4OU4+W1Sk5OMFnZ8bWA6ZWPe5S9XhfcWTJTQ8V3t7n03qINe7x7j3EeqAcTTi2rszTNcEAgAIgDXGSZxnr+Zyt4c3JiOGzaKTW5Qz1tyEWJ/SULIceuRBQ1dIMSkzr/CwloHme0pOx5enY94oEDr6AE8ckpyfbhgvcnp4P1ySsCI6ve1ZX/2jKHHb/SCEjTXD2m3RMwgE4V1am36Qa4cvkv/Mr0lKDXyqjL8hSssEivzCYLt+Oe7g4eacKo4ZPOkO8W5jwqYW0fkfxZFtiUy+6GTBXBDYonP1VMQ6qbz93XgjpP6bqlCYAJMp3fohriiR5wk9wCcR7vRxWq2poPHdL3/DhnZ/q8PhvJd46DbqsqLOiRCRIaPHDUpfSicj6AmPYTFRwXDECqbjlHp4HoxXVCMdRerdoZj2se54GctH+Z656klPjdty0pVWIR3O27nDD/bWtFZA+XGUQxKGW52IcOvQLwtgx2U0OLH5tnu6sBSBTDESVxpF2Sam1zgGmIeJEWPRSgN+op9AACNS1lLJF0QKgUFZkg/+DSPAlOcLtzK95
 6AAdANmu
 YzRg52UoscHHy5ZmrjJ6GOgmaXqhc5VXhOJ8GFk2BFnA8O/Q+7gwXXSoGBV1EJzvPNWjTpxUh3sGlWfgjrKHsoYuO95nhJ66RCcSxP1MhP9oFatEjGd2GGXCoUANlyOdvZwpZ2ERM29W4sB+i96IWC+GFDfzQPsvRbGMZjCcR/DxxElMoe5Ap/7ybXnEB6LSrcle4JtFISZQ4solNGw0siQfHslYxgipqGqcx710sQXLqLqzPsnvZY+VVUIxd979JESfT1jSWsfuLvOFrU2lczzTHAgrh9UVCrkCrIWEIRxSjMoh/j99PXzgMvou26+IwT69lF4da0kls+NWFFfWXa888wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

begin_new_exec() cancels the exec'ing thread's io_uring requests after
de_thread() made it the only thread in the thread-group. Now
io_uring_task_cancel() runs task work after. If it runs a
create_worker_cb() item then a io-wq queued on the thread before the
exec creates a new io-wq worker thread.

Said thread joins the thread-group which de_thread() just took down. The
io-iwq sticks around until it notices that its workqueue is dying. But
code after de_thread() relies on being single-threaded.

Move io_uring_task_cancel() before de_thread() but behind the point of
no return. Any worker created during task work run from
io_uring_task_cancel() is just a sibling thread that de_thread() will
take down and reap.

Once io_uring_task_cancel() returned the thread has neither a task
context nor a workqueue left so nothing can add a thread behind
de_thread()'s back anymore.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/aq0_lvHDViIpX_Mu@redhat.com
Fixes: 3bfe6106693b ("io-wq: fork worker threads from original task")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 075a744421e1..334e6d358c56 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1149,16 +1149,19 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 */
 	bprm->point_of_no_return = true;
 
+	/*
+	 * Cancel any io_uring activity across execve. This runs task work
+	 * that may still create an io-wq worker, so do it while de_thread()
+	 * can still zap it.
+	 */
+	io_uring_task_cancel();
+
 	/* Make this the only thread in the thread group */
 	retval = de_thread(me);
 	if (retval)
 		goto out;
 	/* see the comment in check_unsafe_exec() */
 	current->fs->in_exec = 0;
-	/*
-	 * Cancel any io_uring activity across execve
-	 */
-	io_uring_task_cancel();
 
 	/* Ensure the files table is not shared. */
 	retval = unshare_fd(CLONE_FILES, &files);

-- 
2.53.0


