Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 476C6C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E656C6B00A4; Thu, 17 Sep 2026 05:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DCD6B00A5; Thu, 17 Sep 2026 05:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07BD6B00A6; Thu, 17 Sep 2026 05:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A61586B00A4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:18:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 009541C1C7D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:18:08 +0000 (UTC)
X-FDA: 85222702656.14.A8E07D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 550732000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:18:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GUrqL/gE";
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Rhxw036vxujupFof0/OPSjDt69n/+Ot/zuxSne0Eqw=;
	b=zwAl2lOzxhSzkgKWdBUD0cu+0ypFvMt+NEItf5ewK+PGw9gf9m5aXRRrOP1v1uzUgi9pqB
	+NtXJPES9ty1ikN7TlHGqYZ1AjkcGmNKTSUGQuNgC0l2/jiwJwBUyORWmgxoruakZwNEJG
	yH8cU4mqNqCBShcPZx08TcGU7osFR4M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636686;
	b=3RaRqXROznqOXK/us7xcIkvURb7Yet1libepD1VPkTJDV10da2kaO1bIOv3zEPkHdghJjO
	B/1WucPYmAKm7zfNeBa4wacHxJbz+mf0j8gUc8euw/Ty0W796Kx0AKJZG10iuz05AnFgj2
	npSp08sQFH4535Pjffx/u1og/yhoDe4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GUrqL/gE";
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBE936022E;
	Thu, 17 Sep 2026 09:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FFE1F000FF;
	Thu, 17 Sep 2026 09:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636685;
	bh=/Rhxw036vxujupFof0/OPSjDt69n/+Ot/zuxSne0Eqw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GUrqL/gEKSnTVaqEMvtTMGAJIeAc3r1NHdhkY/bcVnaqjDYy7u/nc9nEWQUY+dn8F
	 XoCdbwTsnfZI8ojF1nF7YW4wAzKsG/p6LxqFNL0layDchsrDMBrwZqFZKqpUDmgC82
	 AAgiW7w74PRJm3hJ93xqiliY6Jn+nlnyhTRWnKnAP4ZLLnfMMGc8VagCQuSIIy5zqj
	 1r4lbKsNjJwkuUD40b9C1AROzPPdszzmoZNLncBcTqOgeSlgbdKtnuzSy2ivEkkYCE
	 l0KXXuVRnw83JH7voMkIy6gHPECHSHHq25H36zaZiEwF/fBflCbjLSzYIn82/fQuUA
	 vJgUsyHK8UIPg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:17:33 +0200
Subject: [PATCH v2 6/7] signal: don't retarget shared signals in a dying
 thread group
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-coredump-fixes-v2-6-f3787fcda051@kernel.org>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
In-Reply-To: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1800; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QFgjXXUybA8CBQDzo0leFmaEK+XgKvIPes+QPTJhl4U=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3mBSyypWda//OuPjubFXtBm/HNH9kSkm5b5ScNmR0
 2m3X6cZdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkrw8jw4mVW053OxmfeSC4
 o/1cFGP1m6bT/5ce4inKTqzcKJ2j8JeR4b+D9D2R2y1XvJcfks+YNGHNmdVTT9hce3JUVTb20pI
 /c5gA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: bpkaki8dyhkbgz4hqikc66k5kdog5jsz
X-Rspam-User: 
X-Rspamd-Queue-Id: 550732000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789636686-456821
X-HE-Meta: U2FsdGVkX1/DZGyLV4SUkjw1G7WRVmW7hL06GoXhL0PeGXmHPaAkKDrj5cSFBn/hANcuxgI4SvdhpDKFuY2TnvE5dL1+HB0EJR6phNW2x4Az/cPXwiCUfEmOEN0V5VAG+15bIELsnLNJPgFha+Eq+NeP5wPkNqRYMVOd9/KwCJA/Dy8z6GkP22dyxpgysZuwivqWeeLhlExl305eJ+prnhRf6KuS7as3K7H2xpZSbitRqERYTH2foXxea3QKoWFM+NNuPyzQh0vDTmdJp6Hx6u+59VnkSItv6zFDHjsR4LZBLvlL7Mba0+cVEFnb7LIn4r9ALUcaLJF941F3gmh9rm627co2EeEAuVjL4z2jn4nU8nc+H1RyTu7SVp9iwT+VASU4YniKMEGabKPX4/pv1J/gn3YauCDtaw+4gc4piUy22ebzEIdXOINl/9EdRZHqEoa28M/Q3fkOi1hMIYVkLaq3lVlP8bTV59J6ZoKISlmlr2j/+So5ejNvommCWID6I69Luh3Osq/vlD5zmJsGa8LW6vvLCEx24K65OKog/RcEhxY96NybowaxFbYKghiCXEbeLaDNGvyMW+5LsD4Jc6HwSo4qjy2M5Nt3UTl+mlYQclQrjnWFYo/WmEaCPNWV660CV1xElgvuTKWccih3qEcFgdQwL3VjVEdPSG1HXzlXLIPxfCiznwQYXBloOKgx5dvV9jivpiQ+Syyv9qmknUTJ8E41KcABInx33cCavTCLFLtcQ3xdVO1VXKA0U71UKgwFqqq5mxMt3/sm/yCAqCHz/qDV4jymCcaUOS0OFVMpsYUoDyo/8ztETwm7VdysaDQvavkG/4vXsSOwNMUw0spx2BRxKjJfluqienGtFkzmzJp/+9HlgWjs1Qk8leAjD2qNmBmR8nxtfkeA8NjYwjR8ZI4QCXpPH5BmEBplo4fTj/lZIIctslNK8m0Y2ebKvzMKDQAHvXNr3gNr59q
 IjoigsX0
 ZdkZ7jx3Ddg11351gkFOfV6sz9KRcMu2hbipTRmklGImeugM9S07xpP5MorPkxvm1tI7H/Of+YZJYWhTuSYg9Mn3C5y/9KGY8cO7JSDISPeURxwg3Z/iaCnfvcaXePwfkZQvY7twH5U2wzWrtOVd9S/IA9S8zZp+HSza1LG5i55zjR1qPpbpvmBOuaL4TcZ1xillzql/YYzDNYp7HUBa3Cek8+YjCKH1vqf/Smva2psUwKDm7+Nod3xIazA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the calling thread has blocked a signal then
retarget_shared_pending() slingshots a shared pending signal to a
sibling thread. Today it only skips PF_EXITING threads but not a
coredumping thread.

But if SIGNAL_GROUP_EXIT is set no thread in the thread-group can
dequeue such signals anymore as get_signal() sends SIGKILL to every
thread and prepare_signal() drops any other signal.

exit_signals() also returns early on SIGNAL_GROUP_EXIT. But neither
sigprocmask() nor the mask restore in sigtimedwait() do.

Say a thread sleeps in sigtimedwait() and a sibling thread crashes. The
sleeping thread gets woken by the zap call. It restores its mask on the
way out and retargets a signal that was queued for the coredumping
process. That means TIF_SIGPENDING is set on the coredumping task which
zap_threads() had cleared. So a blocking write sees TIF_SIGPENDING and
truncates the dump.

Stop retargeting signals when SIGNAL_GROUP_EXIT is set and avoid
needlessly truncating coredumps.

Fixes: e6fa16ab9c1e ("signal: sigprocmask() should do retarget_shared_pending()")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index d8bb1f168055..c3bad983dd37 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3117,6 +3117,10 @@ static void retarget_shared_pending(struct task_struct *tsk, sigset_t *which)
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;

-- 
2.53.0


