Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16675C982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58126B00B2; Tue, 15 Sep 2026 07:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31146B00B3; Tue, 15 Sep 2026 07:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47F56B00B4; Tue, 15 Sep 2026 07:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8E4A6B00B2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:34:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A0601403DD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:04 +0000 (UTC)
X-FDA: 85215787608.24.291D26B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 57D4240005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HDJzJEmZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlmLF2ZRuO4m6DET1Els3sWhQ4ZO5mVaz+8mBj4sJho=;
	b=XKdFhJsOuwENTSzQveJrax0HozoLy/x1nJ0hTvSsuOP5XH6n8Lyxo9RuFi4Z+sxG3WFNym
	xd9zTqvkSUk3w1Cb+9kuGqopl6anHiakdjxInHYi9Yej2OP4sPJhZV9TE3EgUQTdAB+tJd
	m6zfY193/gS1GRSZ5HE+CET5eoeF6tA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472042;
	b=ypJp94z0CNjFQdTpfuBGOIW4ojlFPx6YEvmRZk/j5cXXYRlIygR18y9fPhS7Qa6amtnnTd
	Uq6hbcPdkQM++sVCMuqYjtPM+/IaaJo1mg4otVatgiJeOfYFN0Ga5jZRPOr+YCAR7RYMsj
	sc1Gra6LuK8Q7nOG7lnblM5LrpAwD2Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HDJzJEmZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA20F4107A;
	Tue, 15 Sep 2026 11:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EE21F00893;
	Tue, 15 Sep 2026 11:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472041;
	bh=BlmLF2ZRuO4m6DET1Els3sWhQ4ZO5mVaz+8mBj4sJho=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HDJzJEmZuDBgwF9IoA1Gz5NMYoTn4k/FP/na2RbYBjlg+3haxijrVwaRwE0Fk3p/9
	 dduNx9tHaAq4bWftWkcBXXJDENOHlSBITqm85+0ggCH0eKZJQhv+2GyhMpTAh1HcUR
	 IL/u5wuIBV0Fmym48qvS4CzG79Z/i2ze2wETt3aTQHxG8Pc4zYvnCFHSol5RylYeL5
	 DeDCULcNPO4YRlsI5/YH4QJacsVnzDFRpn5P7cN7AYDgGAvw47wCQNw4EF+oXq9GE2
	 w8PkFwpysAj7eqpZOt80WGtmVyxOR6Gc7F8TSGsm/1z0bKOSwas/7HiHKc9gSYqyRW
	 lGTIAw/PIljeg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:07 +0200
Subject: [PATCH RFC POC 21/50] io_uring: commit fds per request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-21-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3015; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NBYSDOnHnxDSrh96OHkyXsU+HJM0P1Ng/z5/cryhZ/8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KltzMxmiIv1c7m3TjNg8QPLz5dX3E/8KWd5+/mTi
 Ij+kFazjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn8LmZkWGmezx6orRi24Mvy
 //nTSwst3kwr9/rdzhrL4arHrG0lxvDPsq5m2fGL6znYz2+zqF2Vtq5LpSio+++Ecq9zHIpvP/E
 xAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 57D4240005
X-Stat-Signature: 61r46rtiw8f8o7kq3d3as6i3u4wh66qb
X-HE-Tag: 1789472042-257880
X-HE-Meta: U2FsdGVkX1+6zfnwr6kqBlLtSga6pBWFWTFFvZ0BxNYxPoqc8RzByUTfHHKhXYVvymRw9HdfLbDxo2yr0GW6+GoJ15Edqqx3cU5N1Z9H36NkS7CkmZPslDpzmpU6TETdpgoM9JEtuvIonwcUtXX3K+w0Ig634gtTry9vcWmj0i4z+sDvlqZYxsgBXUZvJCHE1T8TDk+BrhAyhY4YIUsLpym3x/EIMr54aPo1lWgr0sOo6mKEP2w8C6yw/msbW3oxvh8yOi9OWg1pvba9pfAdfzqZZrXcsbdtMzaZzNTzOendbekpQZ26XhD3BTL0Hee3QcvMHt3UJbaoNy9Nm0iI8Se9QP/pps4OqM3DICWLyh0WOrlmzyQpGArYJhGWb6IgOH8eRx0B8OYZlESx+6NxmMlsit27ailg4tO7jqBkNX90BYqLqAiHh0pBvQAUtVvpAJKwOdnW1l/gLUQ5BIiTHIwTVnGfdxqTH11MjW1wK2kK8JYAfQIa7WC5uY6tZkrwjZrcxp6jJSr2Fuz0mwSxk5my2i+HOdRjMdujG1qqmiE7E+usrFKuwOy6tNFhpzTvzteC5lUpSDT9BfYfk6WjXo2kaxMiywFJuqyOW3iAoXB9A25zMiHemK97cHnz5pVHHIh5v9mukVz4kD0GJgyX5A2t08RGSwjCgTOyNwRZAJor0aDv+M6b3zrC99rim5tVKkpt5ooKhEcmEJv04TIukac7hgYaWgK2Oc98q8ZSXjQmWkSyzrbEUv8QdvgZVBpclA+WFZa8qv2qkWOjsiPIN5P3sN8vsTqjE1k4nGB9tn9coaW4G3VuA1tOr6HAVWTsJCBCec8XAaG31nftH2eItwgTzQOJgClSnbBK34vNRxe3YopWXdKmzv/tg/Zu0FYJ7n1ct9Mrnfo/pi6EDJula+Ybvp+RWHNqEunqZhxTWDSWd7xVGYFCVoSbGktlqdaeq/0HIHWPwJPGpJvlYEo
 UH2jcIZO
 CbX+I/SrRtNDi2b3v6jcJbWj9blrIcuhTdLxZj4D7tSm255Hf4spJq99CcpLOlYVVxj++cJCBPv6j56hrFOym9qMSl2sOTAaRYKbd5KRFhxgMBahilg5x62B4Vdh5jvZ53Hv9w1vBsyB8jbfwNAXsePBiGf6aR3zfa8AnDAzJet9pyyYWE9PmUWHXWPCjJ/KneBbbHDKmntH/wPGJIbosiH4hIbqaRWCwihPvs58yl7h1nKHbMnpiLOutav1dhbbPuyXLNMM6xLWn8O+eRTK+C0wPMC8uoTxq+nST
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

io_uring requests don't complete on syscall exit of the task that
submitted them. They complete:

- inline from io_uring_enter()
- from task_work on any return to userspace
- from io-wq workers and from the SQPOLL thread

The CQEs are visible to other threads before any syscall returns. So
commit the reserved descriptors before the completion is posted. Commit
them after ->issue() based on the request's result and before every CQE
they post.

Nothing reachable from io_uring reserves yet. Once SCM_RIGHTS is
converted this keeps IORING_OP_RECVMSG working from io-wq workers and
the SQPOLL thread.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 io_uring/io_uring.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 61053421d809..001c3683bf00 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -870,6 +870,10 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
+	/* Descriptors this CQE reports must be installed before it is visible. */
+	if (unlikely(current->fd_slots.nr))
+		__fd_slots_commit(res);
+
 	if (!(ctx->int_flags & IO_RING_F_LOCKLESS_CQ)) {
 		spin_lock(&ctx->completion_lock);
 		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
@@ -895,6 +899,8 @@ bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe cqe[2])
 	lockdep_assert_held(&ctx->uring_lock);
 
 	cqe[0].user_data = req->cqe.user_data;
+	if (unlikely(current->fd_slots.nr))
+		__fd_slots_commit(cqe[0].res);
 	if (!(ctx->int_flags & IO_RING_F_LOCKLESS_CQ)) {
 		spin_lock(&ctx->completion_lock);
 		posted = io_fill_cqe_aux32(ctx, cqe);
@@ -1365,6 +1371,24 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 
 #define REQ_ISSUE_SLOW_FLAGS	(REQ_F_CREDS | REQ_F_ARM_LTIMEOUT)
 
+/*
+ * Requests complete from io_uring_enter(), task_work, io-wq workers and the
+ * SQPOLL thread, and their CQEs are visible before any syscall returns. So
+ * the descriptors a request reserved are committed per request, before its
+ * completion is posted.
+ */
+static void io_req_fd_reservations(struct io_kiocb *req, int ret)
+{
+	long res = ret;
+
+	/* A request holding reservations must not go async or be reissued. */
+	WARN_ON_ONCE(ret == IOU_ISSUE_SKIP_COMPLETE || ret == IOU_RETRY ||
+		     ret == IOU_REQUEUE);
+	if (ret == IOU_COMPLETE)
+		res = req->cqe.res;
+	__fd_slots_commit(res);
+}
+
 static inline int __io_issue_sqe(struct io_kiocb *req,
 				 unsigned int issue_flags,
 				 const struct io_issue_def *def)
@@ -1385,6 +1409,9 @@ static inline int __io_issue_sqe(struct io_kiocb *req,
 
 	ret = def->issue(req, issue_flags);
 
+	if (unlikely(current->fd_slots.nr))
+		io_req_fd_reservations(req, ret);
+
 	if (!def->audit_skip)
 		audit_uring_exit(!ret, ret);
 

-- 
2.53.0


