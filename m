Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A35C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7396B0096; Mon, 24 Aug 2026 08:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60476B0099; Mon, 24 Aug 2026 08:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76AB6B009D; Mon, 24 Aug 2026 08:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3CF86B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:08:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 319AA1C002C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:08:37 +0000 (UTC)
X-FDA: 85136041074.04.EF96FFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6756B140014
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:08:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtVwjkb+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787573315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9DywixF9AvDfrDjTJhpivG128OaV1hgmNtytvsZpw/U=;
	b=IeII5QWUtzhHyE0keGqUukHkSPCD8etnrIWLp2vXlMJA5XYSa/+BV3a19EvEjyLetojeO5
	aQFN1IdIJ168Bu1Ezkh7T7IwmgDkej+qCYC2TFfI7d6SCxE5qurK1Pc4OxzzOzaT+9yrlJ
	CfPY3SaNWz4Ld2aPrxsPIYLB20L/p+s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtVwjkb+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787573315;
	b=JDsVQZWQMFltxlrG5Zg9XelAy3U/Osw71KdoW2RX7A7VqztZ9NcgPoDLypuRrohPwFaInj
	JlaYGvnkT+/slgCAbeG9rrrQVZy1Yet9jqQBmMqXvJ9twUYXuKXoNuqwewwiCHXI+n4Bkr
	LPOdihyrHYshiA+lVVlV5zCLR/hrlkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADF6F600AD;
	Mon, 24 Aug 2026 12:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B711F00A3D;
	Mon, 24 Aug 2026 12:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573314;
	bh=9DywixF9AvDfrDjTJhpivG128OaV1hgmNtytvsZpw/U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HtVwjkb+nDOrvH5qXwXX8MGKNAbdAFVFD8riPDCq7bF1TvOogIiq09EjYNW+dpdxI
	 QqV3KdOWp04ZYrl1bv1cwrEpO6sGdaX2SUUyEIN3luTRIsAnCTnwzRsQJvqE6EF7+Z
	 km4HKvL0CZjnhq9bKs7Hi+qxrdVE23/CSdU5CTpX6fdI/yJuLh6oaXHePwHmAAtClv
	 cSfbqEUjJibUe5ccU5R+qMlLmSBXQAmi/8tcb9I4h5DElwR6tipigesxloKZf+nqpN
	 o8zwnIB3GeRSdpXc/pqdKaIBxn1JNWQf2eSUGA58Obh3X8sQf1fpTUpgjZEJAa+5mu
	 CIsOZrHVIwt4Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 24 Aug 2026 14:08:17 +0200
Subject: [PATCH v2 2/5] coredump: prevent TIF_NOTIFY_SIGNAL from
 interrupting coredumps
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-work-tif_notify_signal-v2-2-6609e42b3157@kernel.org>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2835; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DHJsUzzShnk3N0huGLg1kLKcHTGnYQ2IAgRGy+bA1w0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFjuu39KX6Nz52rGh43NFzMPzn7tfkBok1DwDO0XF
 2I7g0u/d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEqYuRYdYa1cJ3X48XvV7u
 edLy9AvlnNvPP3kk7Jxg8PEfs9zemRwMv1ler38uUVDLu276ih8vPLeeOqQ5g/vjEjOF6quRMxi
 ubWQHAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: uy1mxbhctgkqw1esxi49i5rqdn9tu7w3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6756B140014
X-HE-Tag: 1787573315-389624
X-HE-Meta: U2FsdGVkX1/s/4/nZo/HMB+cwPcEUF3HNEZ5AjJGsPCUfHYg8DtHFMRH6dcCU77f7VyRn4FCsXtj0lMeh8nbuhvX0ET2pQKJNz9JpvuWG7QX4yV1KRn/o6dyyFu6P4HhMWcNeGjJ/Ycs1DFEQDFh1uI6pk3mRdOIG+9UaZvJ+aACMIYEunfBDH2KvJoqRyhwEA7cUPgrf/P54qb0dvyHNkv58P07wJunqFFEpUy7EVNNtYG3UjCiBbXu+L16laIfjFVqVsPNfy1gxhHMfOUF0UoVTo3brSk8iaaQO3e4N2hR/vCd0lZKD69+A/2lqVZ0fJCCmMgmpLhYxvpPT1GsFo0GIUvsj+ioYgsZQqETAtRB/uE3iaovz1N236JaXpGNTqLILgkHZbN2aHzV7XNJz7AKKZMswTMA89eQClmo3QOiDu7Wx8xpkyBJf/ww442xz25sbvWW9FcNQKYXMcqzLh9EP6ZgGwAItJVXnsJIxR1iNNbstcJ65L00R4reraKVOVsaqIEN8SMXAcp6Eg3vAGwoRoHUBe2GvR8OMIIHSuH/hgZ6+GUoHDVvCnoBo3LKGMsC5say+QVhj0M04SNXbqa0cDZKTD+qz/09/sp/4gY5pk1MzHfcgu3G30frfv/JFVSUoTNtCr9whrNAply8Fs/OFHXnkMxc33Me7owXMtRD369sdDQSZG5GvWsCTFlPKA797q4xwxb64Tqs6bwqqZ5SEkO7WnurKNGF5PwvXCduA4CS2LPbfBrzyvEOjyJcI285q0ia+7qBEOAhqPPih4MrNKrTPkiuFiMEnZQb0qaJqis78kM3SGhbKt+vwt40ACXNZP5SJAZzthCTqhz3G9SLW70XkZSNikwWUifxE+MvEeZzeOOgCt8ZiEfA+15VqkZKU1q+3eu8s1uCqg8wqxxCSXmGV4plozjavFNg0oV7oKSsZWVDYNP+9gIl7E8mz1GAOqR+y4gvA453Jds
 bAiKJMmV
 5zjM4I2vtj5Z4xMiQL4ik6TSDlh7r4lrqRh5Of1Q+COUe9b1zz59UBqwpFd32TcDX/zfZFSoWl8Zl0I+kWsV2vNnvT74sLdJWB9Yk/jJg77tOdo0lhtNjlgumMu+3H9FrVXX7U3ViQ2La1cd183Gqkz/4GDTLB5CglVlxv6464l1pt7Z0LQw+Nds04pHKTdaa7c6FzJ5adr2EjVJBdGS0oYAOezC6cC9jwjddl/aFPw5cd1AOf4BbZI8BZaRxiNU9c8meIUBAgJFTYN3PYagcxRfrOnBi058B+zS8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TIF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

However, both the usermodehelper pipe and the coredump socket will bail
early on TIF_NOTIFY_SIGNAL. This affects the following codepaths:

- coredump_sock_recv() -> unix_stream_read_generic()
  The request/ack handshake is abandoned before any coredump data is
  sent.

- anon_pipe_write() returning -ERESTARTSYS
  Once the pipe is full this truncates the coredump.

- unix_stream_sendmsg() returning -ERESTARTSYS
  Once the send buffer is full this truncates the coredump.

- coredump_sock_wait() -> __kernel_read()
  This reports a failure that didn't happen.

- wait_for_dump_helpers() -> wait_event_interruptible()
  This stops waiting for the coredump helpers.

Such truncation is entirely invisible to userspace and all uapi bits
still indicate that a successful coredump happened. A crashing process
with a bunch of file backed mappings and io_uring thrown in loses most
of the coredump data. If the NT_FILE note goes past PAGE_SIZE mappings
it's gonzo.

TIF_NOTIFY_SIGNAL is sent by io_uring for the common case. And it uses
poll without sleeping so a completion callback runs task_work_add() from
interrupt context against the task that submitted the request. This is
the task that is running the coredump. Since that task hasn't set
work_exited (it hasn't exited yet after all) TIF_NOTIFY_SIGNAL keeps
reappearing.

A coredumping task doesn't return to userspace. The task work is run at
exit. So interrupting it doesn't buy anything and just loses the
coredump which is quite valuable.

Note that this isn't specific to io_uring. There's also
klp_send_signals(), bpf_task_work_schedule_signal(), landlock's tsync
and then  technically, kthread_stop() and the printk kunit test set the
bit raw.

Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index ac3cd74808c6..7c0f276c3e0d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1191,6 +1191,8 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	if (coredump_wait(siginfo->si_signo, &core_state) < 0)
 		return;
 
+	/* Task work must not cut the dump short, see signal_pending(). */
+	guard(no_notify_signal)();
 	scoped_with_creds(cred)
 		do_coredump(&cn, &cprm, &argv, &argc, binfmt);
 	coredump_cleanup(&cn, &cprm);

-- 
2.53.0


