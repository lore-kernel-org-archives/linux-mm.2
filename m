Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403A7C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C85D6B0179; Tue, 18 Aug 2026 06:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FFE6B017A; Tue, 18 Aug 2026 06:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4686B017B; Tue, 18 Aug 2026 06:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0FF26B0179
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:29:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F5E1A0BCE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:29:55 +0000 (UTC)
X-FDA: 85114019550.28.145E114
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F163140002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:29:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CuE/lrGP";
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787048993;
	b=KMRudvaWK0hov6DCnkxzgSX2MueirGayW2+PPLMSjQYGwqsZ/TAzQD4ccrjYzrIqCLM7g5
	pbtT5Gd88+EMlHnGymtScMhL59p6Ps4poM0A6JdgwRgbVt4pO0V9C22DfwlGtOsnYiM4FM
	CuYizcNcRvod9zYtUitwhLBgvwFZy+g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CuE/lrGP";
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787048993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/3ifLeO/V9zJX3ZBj1vaYITNvgCXsDgv6gphRWwGw0=;
	b=KmOxJ4drhoyzee5JPhTYkdMuezAejadv6jgu6XTKSWNa5LXNUIF8NpO7ofV+Ou0sGezkhj
	EVSq0ucVpmHcHd99gGWuGbnwEBQI1qxtq59cPQTiTfzHszboQr1yBLJKT7OpdtlOAmHWTA
	Z2HzLZMjsk7qOaYP2o6YH6ZxaZ4SS1Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4189B60A5B;
	Tue, 18 Aug 2026 10:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893EC1F00A3E;
	Tue, 18 Aug 2026 10:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048993;
	bh=m/3ifLeO/V9zJX3ZBj1vaYITNvgCXsDgv6gphRWwGw0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CuE/lrGPX6isVHbIQzZA08LMcy27Fmp6ZutGuN35bVmcmUE6T9J6plBWxx+UPoRTK
	 Zkzl16Oup8Ae8THh6W+l3S2iXXd6dZ+J72hRFD00JdsgSLy1XBv0noXcbWI0lQRtum
	 kp0+ZYV58PVcvNhkXpSy2LSayAFbs8tkRA8+lgNrywF5nts3jf/Wcx9hXcQ/RYs12z
	 54qwPf4FJ0rQgfMJUOma6lN+XMxyE+eWMlJkafpdLln0TKidBJpozi+DMMVHMNaGtk
	 JrAC8Ef1Jqy7/iWGYBH3dcE/V75vAm8ADmk61Y+X/VUX9UAqZtm3Nj9Gb6ZZic0tiY
	 1UfitxFOe8m9w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 18 Aug 2026 12:29:37 +0200
Subject: [PATCH 2/4] coredump: prevent TIF_NOTIFY_SIGNAL from interrupting
 coredumps
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-work-tif_notify_signal-v1-2-1ee1fcc5b3ff@kernel.org>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
In-Reply-To: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3118; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5J6LIO7ZuXJfHFopgZ4uyqtR3+Ho4X2+WCmNF1f3Q+M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1mEhkrFpo4VP65tNxmZj9Ag+/njX6vOdz6U3X9TNMv
 lwxKknV6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIayEjwzpmh4fHJM1qey28
 jY5yFW///qv0TtHTgkrzwkk/b2iF/2P4w3Eqb13q8iOTxHM4OZz/PVTWeiex9r/2ZJm+U6wfe6f
 18gEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 9F163140002
X-Rspam-User: 
X-Stat-Signature: u1395kewimwwynmxa3c4rifhy7rgewaw
X-Rspamd-Server: rspam06
X-HE-Tag: 1787048993-603061
X-HE-Meta: U2FsdGVkX1/O1+V8e2/QPCuWE2m44vL1rxRpQbL5sq6pkecRGhj9GkHQyGTEBeSpMeXnW4pjX8V9/U5Xh9ZIslVODL1akzES4N2XA+D13WeelnJGeKuvdLduZlCg2gEIU422N8Z6pmp/n6PgigwbNBn6pR1j9fxVM0drfpmVnxD/ACvGAl3HNqg2Z5ru0h+4QcaC4k/bL12azAyiC327I9LEwhZT7JvXNanM4/mkTdjcAf3UMJUhzZ9Fkn9hhe4CEbMYqeMGJ7nPc9CtPNkwe8zVtojOhoIIqxaz+Wu5pLboFrYyeHsCxOu2AW/TfgBBiQYOTAN6fqOYA7rqVZRDp7c9antXIG8jlTg/54JuHcMGH54uaGr0I1CxF7awpTQolI2oJswSvyHjuPK/Ki49u7QcOfPT33TGPdhS4jpiYrcLe7SkowMqNY28UhTshV2OARSZD7L191pVL2N+ap7A0GTtpB39agONUzvoMIfmB9gi2LfFszKvHwqZ7a8SuCFxAaCWz3wdOUbev6B9GZ3OLGiz8Dj9IH3dZE5TNaxuYTJFzcfyfb9ciPNSiLmG1vyo8Vhp4pJitQCXqEf71Ny9SUrnzSGP0t/80QnrByehRoWbjQAU5Lz/EwAeDbMMRRUvm4rO2e9XzOUZXq2wpXmIwBRhefBtyS3weAP3mGoNttOti8zwsliwtCyZ2DNA1K3ACRBSvM0Pb5rA1HLyYKwg+3saw2o9G4RM1j+udXmnbD4C6zbD/rMOijen2m/YkrYJiHP3gU3w+axCImKaa+JaVriBW7bkL3hk5H/dehJA0zw7HdQ07BEhhGbi/7n6BY7HgRK23kGDbZzPk4hmfLROZZwtJUD+TW6oyqkdoCInhEXApBPnWFw/iXAQbLYUwKLX7iDunDYkwptKValBd8HNRR/nFDPTMXlkairPeKVvw9ys8avDoFwAje+xZwd/GL/8mpcNdenPMP2Tlk9NSrw
 ETZkpT7a
 tZEaNUsFfqh6fc0Vb4JDd+U+zzoCl5flSKpc7j2QNq/btpK2C6d/RCJyhc3pIaDBoQKLV0S2AR04k34UV4EtjJG1yUEw93GBz+ZlXLdOVIIEzuPvIsvptRWWWnG+P0ubtlOeus1KeYw6bJJvk7nwvKI2SU/4ugBwC+ElcryKIZGP4Mxr8mAqdpdwx5WWBB0oCwIRFPsp9u7dwOj9LSI/SF1JELmRVnbNqGI6eHVbHCwlVCsRCztFsU98SZK3GEZf4n1k1o0OxF0CNo2v0BciBo6FB2SoIYkBZ0q4b
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index e68a76ff92a3..edb5a1a61d84 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1165,6 +1165,7 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	struct core_name cn;
 	const struct mm_struct *mm = current->mm;
 	const struct linux_binfmt *binfmt = mm->binfmt;
+	unsigned int notify_flags;
 	int argc = 0;
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
@@ -1196,9 +1197,12 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	if (coredump_wait(siginfo->si_signo, &core_state) < 0)
 		return;
 
+	/* Task work must not cut the dump short, see signal_pending(). */
+	notify_flags = no_notify_signal_save();
 	scoped_with_creds(cred)
 		do_coredump(&cn, &cprm, &argv, &argc, binfmt);
 	coredump_cleanup(&cn, &cprm);
+	no_notify_signal_restore(notify_flags);
 	return;
 }
 

-- 
2.53.0


