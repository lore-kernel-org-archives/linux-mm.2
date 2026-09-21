Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F5BC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3C4D6B00DF; Mon, 21 Sep 2026 09:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14196B00E1; Mon, 21 Sep 2026 09:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B076B00E2; Mon, 21 Sep 2026 09:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7136B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D6121A01AD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:28 +0000 (UTC)
X-FDA: 85237891536.30.BDCCB7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 606F312000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VXXdeRh3;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b32xekZALDJ73u8pNgOkOniEszxsMWAgHksCs7g4tyE=;
	b=s3DR1R0eXhz5EYO7OaDWHe1Tc95x3hAJWX0cXMKkRX2IXYXDoAD+wCgGTcBaJsDbB8M63o
	KsYOLOBXjktAliZPlyBTTlcr2OSmRmGVRJxmjgo6vm/Z+zCIBGkE1dKozUC+r1Glyq1SC5
	XvnLUj236XkExduHJ9WLy5CzkSYi7ZU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998326;
	b=hQAJcHh9RXdS93IhSpvCzUtrt6OZmc0Xx8K7jIr49stQVotbFsVLonfjgklaT3H2UPJeVu
	T/hvfyx87xj8agUAShkcB8pDDWNAvO7fNTl0LrXHeWma2AXuXSjvnHGoto1w0O7vf1aMcF
	j1a9Mnfd92FpGpWrHPn0FaSrlhORrrg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VXXdeRh3;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7560404FE;
	Mon, 21 Sep 2026 13:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575E61F000FF;
	Mon, 21 Sep 2026 13:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998325;
	bh=b32xekZALDJ73u8pNgOkOniEszxsMWAgHksCs7g4tyE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VXXdeRh35T9i1/ADIdWf8z7aG6ksc04+VkB5STDx4Keu3VjrFeVir8HzGTUPSEFoQ
	 uYpVIZocN+hq6enflkH/uE+gY/AT4JY/eQZj2UobHgbyYaHUB8XEm2eWk16SOkIyjF
	 5GKp/nv7D2Jmbx/Y60Ra/3EjVm8pvfN0btMXoEmAOS84Tfm/EURd3qrwR1iZsXKQ5n
	 5fI07y6F3NyfvrpEWEbI5LkJKA0phbqx29KNvxt65faoYPOLP57nnWrNBmAUV3iZQw
	 iWC6yLOk/1s62qdSCtvpEMUwsUjSc2t+QPKIHEUnYa2Svs3Vm+RJ1f2G3LKcw1+pge
	 gVswbNbkcIy1A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:54 +0200
Subject: [PATCH v3 05/17] signal: don't retarget shared signals in a dying
 thread group
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-5-8e4adb1619e6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1843; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NXtk4J120gvy6duSbM7CGMlQIgVMXPYHLccJxo13+TM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLlzePcG6a9a3w7tc8ydY3Fyl+UFjmkv3qySODjXP
 FdkwvXsNR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATiWVjZNi+pjv63mODniep
 wecDuRav+6uZ9dp1Z6TLAW6hZYHHdj1j+B+tOd0vdlbJ5lZJh9qWhlsKXxiuZsleXvvuzrzv1tc
 PNnADAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 606F312000E
X-Stat-Signature: mcc9d1e3gcgxc59f4ra7jbgfrfp6dk68
X-Rspam-User: 
X-HE-Tag: 1789998326-117974
X-HE-Meta: U2FsdGVkX19bd/nJU71lNYAFjn35EELcqp5g+cIyQoFdNjD2OEcPduenwsesLPEcbQDozEB8VT+krQI0bUBv7PpDQOTv6DZWaxqy0w8NueFsbVmv3y+SVweS6FOaLYwUaaCEfdpVqB4QclsYvZ1iG/s+J41HGAxMV4uIyeQb+shP9IAjdTEQsca26tBc9DXYH2lKoQN7Q9fT8tDgdUvob3r57vMvpdQpWOANsNuoKTDZ7tHgco8kI7n133KYLrZhmZSQu0QkhyUW+Kz/vV6IL1Rtkr5JDlL2QWCNHad3YRrouW1rW4QCX+EPDrfcxDRHGVcuC9XCifmMSzZeybJLxAf9/61QuoEqlHQLVSoxjeKbWV+Jx2DwnejdX95OJN2ZdWNfRu0l7E5xPo8ErR/aPnPkrCOwPby0c/E87emQpuA4TAGy1JSlg2J+IZukLpNpVptKBMczk7JMBPEDXQ51Tf/IRzF+OWNIrA4C1L1IepHlHuH11cb3OsMQrR3Ixb6DjsTehgl9rrj4oCiAUGAiNSsRdG/YofVu6DLJptyBCNzkd42uRtt28irAU/xUGyWNZFrlLkuRXruSrpcEk8woDJalCafPGYdl4DTZtd/uBL6i1GdIZqel1Qqt5CDXOyixZ8Ifrjs+iGRFMDqznAJpSQeb4yWugNlE4cjy/LweMHOo5HRdq7fW9DLKpdtEmwxaJbzQ66EnF/hFaxjxC3Cu6bmExpT3Eh2UpvMmFODY3K3qdEa1AiWacSjPO9nIQQNOE6FrLfiVpbIV8LGpWDBRIx99R4IUaincbck1IydKuOjEZzMlOfypb0dy1NXR6r4B4cv6VnsSiPpAwWJZHzNBjZTL5MlRhq7J7d9Z+cJdFLqauBN+LPHsN24MlZ+iTQccnoVJ9R6RNzltsSb+5a1nRMY7cJU/m77PEG8zhseBbypojcrGx7CweDjHO7sgELuMAglcPPZKHYW2ZyJYtGU
 3t69vXa3
 2qM/aDZ9QOb65iQiLskZoDnTX/HXSuzWsfu9zKLHkMj5+qzZRjNepW1t9bEU2MEu5ES9qSNH4PqKyumnnjkxihaX6NA+C2JCOe2pAjhqJJ3bEOhjyfyCgnm48yj35ITL2EUI5PMK5hVPCVEYabiyDHT+JIWAUAjN9uyt3d8UbLQAxD9OIhpOY0bn0nqLL10Pc6I2nJ/RNGoqvPg5cO3Dbnk3h/TEUovJ77H+A2dEvGIOBTp6cL17OyZ2oHnEhWfdyaBroCSkJsRpkpuA=
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
Acked-by: Oleg Nesterov <oleg@redhat.com>
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


