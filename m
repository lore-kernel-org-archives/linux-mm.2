Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AFCC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35FCE6B00C2; Tue, 15 Sep 2026 07:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339486B00C3; Tue, 15 Sep 2026 07:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24ED46B00C4; Tue, 15 Sep 2026 07:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05A8C6B00C2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:35:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C1BCA03BC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:29 +0000 (UTC)
X-FDA: 85215791178.15.CC1DAD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id CB39B1C0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XqYmNccj;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472127;
	b=oUOCuC5nGcg/UOUfae27TxHzFde8MwBZlEgGSQGzWKa+K1/FqvlGNlPZ4fJF0iDbYdd4VW
	iTEwRWBx9uThqRz3vizRrQVcUKv7qtgM/e1O0O7P6I3czF79p73mlqCyQ2azhZJW+7VMRV
	/qXvfrkhmUthwoUYNgiZ+hZf9Ri8zmc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XqYmNccj;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiDQySP8IWTYUOdB117br7TNLcvsxWg+xpN5r3cQq6M=;
	b=G/u9hGWm7wd+RvAOucy5++qHnEHgBPez4yfvbX4TXftmrHItEEqkjNzrXnQwsCpwaLVQ89
	a4vDPtTdqGFAb0CHSl/ZKceKViazo+foQ+5IzyQqJhY03jD+SehjyrfVslmRnAoqlJ/SYd
	oeQAGL3Fw3+ExK4GquP1YfEpbaDbF10=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2303642E75;
	Tue, 15 Sep 2026 11:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863231F00893;
	Tue, 15 Sep 2026 11:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472127;
	bh=SiDQySP8IWTYUOdB117br7TNLcvsxWg+xpN5r3cQq6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XqYmNccjTCHTgLZfaFkSBqBDFVVBpN4V7uWmro0nlZYhYXdIOR3pUJm31rdV5qmY+
	 IvkQ+yJ07iMIJdVfTfCU/X+J1F85+bUe/IC+GzOLdoIsjHzzI0cRTRkin0A6HJ4e9A
	 wjbY7EF1qh+Lal3EYMMKlHTRwBv+A5nykmakJD+8D67Z72hDwiPvXhqDAFfL92TuNh
	 lR+9tIh+dTMh59L9wRnctKfZHIAF9NgyjZ0E3adVhwso4Hs5jlLy1+Oyk4a8gR0BJY
	 rzlOT3+qL2yuGXywSlb/k0KzE8CbI8Z7lw3SuGIaABfBF2TZ/OabNmu6rvP9iBmcEe
	 3ufAwvnh6Znbw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:18 +0200
Subject: [PATCH RFC POC 32/50] liveupdate: install the session descriptors
 when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-32-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3361; i=brauner@kernel.org;
 h=from:subject:message-id; bh=B2yzY8WVH9I+iLi4OuPEJenUrd90D6GAB5zasGpbfEQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kk7WTbjY/LDc6u2Nl9xvMO+7IG4y7ylT0vafyesW
 7+59X5BSUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEdFwZGQ4ll/MKLt9+yuPv
 Ls73Mh5H/nGs+LpMfK0El6Rj9O4LjyQZGY7rKSdd2rLmmIq27bPU4yUy5+NELr/9Lxu7/vCdBG/
 ZPH4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB39B1C0006
X-Rspam-User: 
X-Stat-Signature: mpeyxgygqa369nk97i8m33nfmkmwex36
X-HE-Tag: 1789472127-709775
X-HE-Meta: U2FsdGVkX19BkDb//EwkOCBqL1xrOVe8OLIcDz3QoW1GUWC6LCreNNtYYt6lzmbOk6yV6y0xNj01tQg8BC9cAmwjZG8GrGgmPMhWGcPnTwRpjSQE+mOL9lYWNg7ue6gzw8Pb91ZkKMovsGx+5n916BGw9rlQMWykMIvXbzQIVgcwIfpom6iE4HuMOMcWfGwSLkzTHFHSvC0O7Zr7WI5tp0jcm/CjOeGVJ50QGTCQCbdHRBSb/3bozJwZyr2qrmX6JU/GPfdgz4F9JyvrZHnsylxs94Hp+H6jc+qljstcOhUyltYpWQfacMYfhjVGuORa/ebQYaYp6dElQVZMVzeLOE4YtVAelnpNBVozw66+rmOsLMawMnY1zQCcogUTHC/WSpk6ZaFbwd5TMJjmVcEyMelFNHR9mgXO8Y5JY+2pdFVhAeRaF7fJzp1VGm2FT6rMc+r38V9f4onrKOhHXkCmjFW97oeC2J6reSWfmh/HbZbjJ0dXZVRTXlH7GyppJIR72W/X3MYHmMjzKS3Cdf9+EIXN/bK4u4HSsEJA4YP67aSU+LP5/AdSc6GiEBCwYi8xTNG2FRGYNofcWCIExdGnRXWnC8J8h/gBc5wPtg3BS3YoX3sxECqTOkd9wrYLx5SXEABuep/EnziOGf5gkqAQZNFPLldCGZQnhkg6PrkZHN4NMZDt7lPISKVWU5qmSrp7LLWwQrwIsG+0E3iXE1DKQ3Tzdwd3ss2Cd6lZmKVLcNN7G50WiVZgfQhcEcSND0KBHws+ybW9B2JJNID7ulYtcnGYPL27yFPJMQ4ME7lDFBU/ENI5ng0vuS17iqM2IT+W7Lb27F8n7V/B+92UPi456xULjn8Vm0XNqZBB/7oQHybPiwbg6MeuPej/qOJrz2HwqrE9pnuQtCeoqMqU8X09RoDzsnuFSaZ0FtYj9kQ+tInUjAVMPW67hjiRCv3GdYpT/+9iZCa/FUdvTfFoJTw
 q1notXM6
 P9bzUKeo/e0iuYfxme1Zxg2sX+3AWqqui1kCy6PVC5IEpmqrserKL0fEXSxnUG8JDaLvELQPjUWetBd4ySNKAqt5iLtirvb0SrXuKlg3xzbvetsiwRpe8SvyUBLcIDhlL6zXcK02VqfzxQYcJrQLRefd1k6j3HI3DluM2VUUk4zlMOsMpuS2jUEHUs5NAxVJcFNcTdCKL+erd9bD4KpB+9bOV8vvkB9iIJ4pHT1xdFRlQonBijFmZ7Kr0JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/liveupdate/luo_core.c    | 48 ++++++++++++-----------------------------
 kernel/liveupdate/luo_session.c | 24 ++++++---------------
 2 files changed, 21 insertions(+), 51 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 1b2bda22902d..3899bbf30b53 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -270,61 +270,41 @@ struct luo_device_state {
 static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
 {
 	struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
+	const struct fd_slot *fd;
 	struct file *file;
 	int err;
 
-	argp->fd = get_unused_fd_flags(O_CLOEXEC);
-	if (argp->fd < 0)
-		return argp->fd;
+	fd = fd_prepare(O_CLOEXEC);
+	if (IS_ERR(fd))
+		return PTR_ERR(fd);
 
 	err = luo_session_create(argp->name, &file);
 	if (err)
-		goto err_put_fd;
-
-	err = luo_ucmd_respond(ucmd, sizeof(*argp));
-	if (err)
-		goto err_put_file;
-
-	fd_install(argp->fd, file);
-
-	return 0;
+		return err;
 
-err_put_file:
-	fput(file);
-err_put_fd:
-	put_unused_fd(argp->fd);
+	argp->fd = fd_stage(fd, file);
 
-	return err;
+	return luo_ucmd_respond(ucmd, sizeof(*argp));
 }
 
 static int luo_ioctl_retrieve_session(struct luo_ucmd *ucmd)
 {
 	struct liveupdate_ioctl_retrieve_session *argp = ucmd->cmd;
+	const struct fd_slot *fd;
 	struct file *file;
 	int err;
 
-	argp->fd = get_unused_fd_flags(O_CLOEXEC);
-	if (argp->fd < 0)
-		return argp->fd;
+	fd = fd_prepare(O_CLOEXEC);
+	if (IS_ERR(fd))
+		return PTR_ERR(fd);
 
 	err = luo_session_retrieve(argp->name, &file);
 	if (err < 0)
-		goto err_put_fd;
-
-	err = luo_ucmd_respond(ucmd, sizeof(*argp));
-	if (err)
-		goto err_put_file;
-
-	fd_install(argp->fd, file);
-
-	return 0;
+		return err;
 
-err_put_file:
-	fput(file);
-err_put_fd:
-	put_unused_fd(argp->fd);
+	argp->fd = fd_stage(fd, file);
 
-	return err;
+	return luo_ucmd_respond(ucmd, sizeof(*argp));
 }
 
 static int luo_open(struct inode *inodep, struct file *filep)
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f48e9a4185f9..7de35bad1ede 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -282,33 +282,23 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 				   struct luo_ucmd *ucmd)
 {
 	struct liveupdate_session_retrieve_fd *argp = ucmd->cmd;
+	const struct fd_slot *fd;
 	struct file *file;
 	int err;
 
-	argp->fd = get_unused_fd_flags(O_CLOEXEC);
-	if (argp->fd < 0)
-		return argp->fd;
+	fd = fd_prepare(O_CLOEXEC);
+	if (IS_ERR(fd))
+		return PTR_ERR(fd);
 
 	mutex_lock(&session->mutex);
 	err = luo_retrieve_file(&session->file_set, argp->token, &file);
 	mutex_unlock(&session->mutex);
 	if (err < 0)
-		goto err_put_fd;
-
-	err = luo_ucmd_respond(ucmd, sizeof(*argp));
-	if (err)
-		goto err_put_file;
-
-	fd_install(argp->fd, file);
-
-	return 0;
+		return err;
 
-err_put_file:
-	fput(file);
-err_put_fd:
-	put_unused_fd(argp->fd);
+	argp->fd = fd_stage(fd, file);
 
-	return err;
+	return luo_ucmd_respond(ucmd, sizeof(*argp));
 }
 
 static int luo_session_finish(struct luo_session *session,

-- 
2.53.0


