Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1906EC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9206A6B00EB; Mon, 21 Sep 2026 09:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1476B00EC; Mon, 21 Sep 2026 09:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6306B00ED; Mon, 21 Sep 2026 09:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 523E86B00EB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:46:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8B67C01A7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:46:02 +0000 (UTC)
X-FDA: 85237892964.08.0142D88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 18D5D1C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:46:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Icz+xHLQ;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998361;
	b=FgZJNWZi7zBiK6FMFbfTh24BQGjpIbgL+rSXzQYMMb8zNJcF0+CF5EFmC74jP2m/mPL4rG
	/KRVwhJmIb7xUdZ0fHcfx0VpSil83M74FeT0YMfZBaKcQoW6w09YKkB57xD3AIOpPnD/Qc
	nv0RJ6BwrpRugMsInLxcst4ktxG146g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Icz+xHLQ;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxgAqAUyM3r1AMPXMQ8hoig8LfHIWtySTBDxI0y9Hk8=;
	b=08boR7KCtIgcdCV1uuYhneHhXPNWrD2zMemGlZRs+TslgVRbW9Nd8RbxJpkVzgvqrhtfA6
	kk48Ya6Yv1PWAG9TyfM6ilvICP+HLpk1JcEYv3RmWGO4euXdwaJdMIQ1GFnmqWgdBtv4ha
	fW0mkY9yfZlxzTeMLHoaoXvCql6ykVU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82C70601F0;
	Mon, 21 Sep 2026 13:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610E51F000FF;
	Mon, 21 Sep 2026 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998360;
	bh=XxgAqAUyM3r1AMPXMQ8hoig8LfHIWtySTBDxI0y9Hk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Icz+xHLQDbSSHi+N16YU2y1GynY0LZOE3JZDzMAEEJb1D9m6KWdZXk6U6V/zR4B+b
	 7BQ0M3FukLH+6GiiG/lrkgJnTx7AD7Sb6I6vnfmSz5HLp5Dix+bFsCqut5L3GjA84M
	 H81IAH19uXN6Xpky01tPMlFxnH0Fpg0k8NQlnf0R0XcS9UWA8CYZGJPPB9dFi/5Pmk
	 7xDw0is63fwMPgi2HR6RClWMOqNiQzerzUvn5Zll65iyjGHicysJEoPvNi8FAxlajD
	 iJ+9qqED0JN0fTAPWDJA+iFMly2UY9vjm5b0x3DmUfPelnNqQ6VHRnVMnsqCYGF42n
	 6q6C1ZI5oYsmg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:45:04 +0200
Subject: [PATCH v3 15/17] fork: use SIG_KERNEL_ONLY_MASK for the user
 worker signal mask
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-15-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yCrptVQSCLxgp40maZKNV7rkyMoVZAxnjWKhpjaLvr0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLkbfG+y84Npu9ZWagY+7p2WIyKbz3Sfa/8+x/vSD
 zafPhYr3lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARaRNGhrcXY7ZsTZ6jNNM8
 5+Da9zJOzt/TT616dPpe/LnU5El8RdsZ/grymgnb7Ti1aX/FebM0wdDwrOML/9l++xg9x/7uwxI
 md04A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18D5D1C0002
X-Stat-Signature: o4dsrxxkp6o45iufuwosdzfx7s4ks9of
X-Rspam-User: 
X-HE-Tag: 1789998360-468541
X-HE-Meta: U2FsdGVkX1/3H1qHLX6DYrgXTMAZ0TU7pnfDZWNQJwZs/r0et8MRFqMIlCqLywlyIHS/0TMVQwpTj7e/3f3j4T2PMxoHaqzA0vg8qLMpiY1ItM72NXe9cS8zaaQjEowcoW6BbzfcFqvx0mMhFxrY/UNkDyyfh6/Da/ucXLLNF9YYqMtsB5oU2O6OzE3H7RZyTXTy94X3vpy6tFr0GM+dtK2BcSZmbmfMJoLzIjoJtoO6TiFCj3iYenQejy0+iTIt47BvwDNGhbOglwbhGP3iF099BF345vwQ800S+LFXIfBWScKwp0+/SUtg1iHGKDad6sYBJAcal7Ej8tuUmajfiTIeREfs+Bj9GgLj7FdD8g8NqAED11tWoF9Cm3qXao92Ioukpv+8yBBxSva2ns1/wOYPW+DweovmNDsgJSIA9wc6hp3uEFyPUo7vMiKhemQhdAkgn0uIb6VyDxNOIfLTMxhazD+Bw77vdDISYB5z9mjavCdsm5lQhWNy0WBfy7mNCjgJkJjHsm3HUxIl4TyZtmHTEpfyXaeDhTbgazq7Sbzzqre4/fa2AuGCUen3EoJU0BIzwkWVQ0ufyYCBs1UFy1GZqH77U0tU8agMQipZ3ROIZJhaAQoZsXlA38H+Frm85yX2CTZmaRhnBrSbx/7AuzFfEECeHp2fjhb5y+ymh1U/7kbKQVdVL5OldvqizNCEAJEp53OdC0w2fyi1S0LAAdIRUkdMAsDOmoWYn9GXoAJabueuyxWX6oADngsFqdyEy1hNhMCr7zSYPKsR8Jw6xCMqIdJC189cKDa2P6fqfGu332HOjnf6sRtD0E27AViiPqhOQYuLYz19w4l/cG4yHZiqNRruQ12lwIs+7uVOT6r9S84vOTJnf683LgBTWmXvalzHIZpwQV4TjevkSZi+W3uFJoDMQoEbFjNy8KBNMZXOU8M+Xy4m9/hTyvrFsV5rHdaLW4lLLh2jiBiB4Jy
 TE9bPS6v
 wvOBnwm+6jNS54R1EDs+jG8wokxz09BGdg8pg8Rpk9eq/iMxAk7huESMUfZRQ4zGupJSY27YQLq3oeypY54Ku80KH0JShXR6bSri/1ENKzzIVLy38GCGzygKzA9ZubEoMG057oXuVi715aDV7FntkTiczV1lnfBd8rhYBQQFXIAD2SRMHh71YrXI0Y0sFcZgtLohlrdlr9FTsAUE1fJLB4scKTYIXwqPzHQqhUHqGbJ67EfHxlVyzrZIkZAg9lr+HeW8eRhIzj8c3sh6F+CcIRu3F5QL8g84f4XFYqbQvpscUo0Ft2QfLzSl46KrcDgEUsXxY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For a user worker copy_process() blocks every signal except for SIGKILL
and SIGSTOP. Use SIG_KERNEL_ONLY_MASK instead of open-coding it.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/fork.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index fd2829b0a8b6..be5980d0dd9f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2146,12 +2146,9 @@ __latent_entropy struct task_struct *copy_process(
 	if (args->kthread)
 		p->flags |= PF_KTHREAD;
 	if (args->user_worker) {
-		/*
-		 * Mark us a user worker, and block any signal that isn't
-		 * fatal or STOP
-		 */
+		/* A user worker takes only the signals nobody can block. */
 		p->flags |= PF_USER_WORKER;
-		siginitsetinv(&p->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
+		siginitsetinv(&p->blocked, SIG_KERNEL_ONLY_MASK);
 	}
 	if (args->io_thread)
 		p->flags |= PF_IO_WORKER;

-- 
2.53.0


