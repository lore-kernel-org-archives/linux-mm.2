Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B58FD5323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 12:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4D16B0005; Fri, 27 Feb 2026 07:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F446B0088; Fri, 27 Feb 2026 07:04:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A16B6B0089; Fri, 27 Feb 2026 07:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0697E6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:04:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AABEE1C7F9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:04:00 +0000 (UTC)
X-FDA: 84490103040.21.887A980
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9DBEF4000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:03:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gQA4E8Vp;
	spf=pass (imf17.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772193838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzJWcWsW4AQY0Ow0DI3RPlgohp0HYyfHWeugLHPcRG8=;
	b=WeWSXbSQGhO1T/LMOELoYi5YHIwKSE2E/qcDB1JGmGdPbi5ZTN1U5e7jhzMG/1sheH5aqQ
	v0L8Y0euxobsdT4FEE81YvPfSayl23kN2li1UINJD2lO9kEcfda21KEvmjYoQmCKUluO8n
	PeEDmqYy8nT/vaSTxydqKNF1QIUwMbg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772193838; a=rsa-sha256;
	cv=none;
	b=F/UyBX4X9xYgYMmkN8YxRBAN4x8eoKZ4wO4QaAxJG43MpzsKztUbJPHxeLOk6+DaQQSQJD
	HUIxr3KmlwZ4VNpL5ZjcgSsNECbLZTRL2mZ1xuIHwJJJRhM4z/ykFMnwFKzbqwVSAFPitZ
	/FiR6BqKAyVQZd7rmn+kSaxpORnd1Jg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gQA4E8Vp;
	spf=pass (imf17.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772193838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SzJWcWsW4AQY0Ow0DI3RPlgohp0HYyfHWeugLHPcRG8=;
	b=gQA4E8Vp++EL6hPPmfX5dG9/LiYeNyYLIxOInxS2qKGkng7XdAkrAD60e80xDLhLxudUf7
	QFbzX9pBwI4DQ4IuDdn2M8LLzw8bGDqxFIA9Rm8EdRzzg4qf2Ja+aFJ9/ZjCEbNfpXvFOT
	V87bfdfi5+8ZoLSfF2vwcd6LIrAzJkg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-DPs_LF9INQm7yzIXJqq6_A-1; Fri,
 27 Feb 2026 07:03:54 -0500
X-MC-Unique: DPs_LF9INQm7yzIXJqq6_A-1
X-Mimecast-MFC-AGG-ID: DPs_LF9INQm7yzIXJqq6_A_1772193831
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AA1A180034D;
	Fri, 27 Feb 2026 12:03:51 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6CEDE1956053;
	Fri, 27 Feb 2026 12:03:43 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 27 Feb 2026 13:03:50 +0100 (CET)
Date: Fri, 27 Feb 2026 13:03:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH 1/2] pid: make sub-init creation retryable
Message-ID: <aaGIHa7vGdwhEc_D@redhat.com>
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
 <aaGHu3ixbw9Y7kFj@redhat.com>
MIME-Version: 1.0
In-Reply-To: <aaGHu3ixbw9Y7kFj@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: sLO1btBoX9ZI7Dgp5EYyDc-AhF394vR5WNEaGKADWiM_1772193831
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9DBEF4000E
X-Stat-Signature: 1xxz9x36s84npj15anzi6ip3e5xzfz86
X-Rspam-User: 
X-HE-Tag: 1772193838-40368
X-HE-Meta: U2FsdGVkX1+V65Bf8K4CHYSv39mBb3KXyi9syWDIozOvlDyvakurV7MfPFLuxaCBTXSduvoiKR2c4oFyXCh+LbgUkDlTqUf0dGZ3ZXZGlElU+wsJfOX0woNr7yseLcGHLtMPC0oASpBxi70w3ipev7Xd5uYStVmdj9Xlx+eRTFtocVJpyBwfC/1/5yS1jha/4x2GBDbvCZu+cl5y6dGPesClWppeaYK78/akoNpKsaLAsb/jx5EgSC5/SAp5mDywx++OZX9CVPnEzXpWlq3EOfDEElc7uLUG+l5XzcBULhB7Gx1RhdIFf56SXXL0/nqyCSw/s9ATv1eWD1L/4p3u4vZig6Ilb/2Bu/Bs2m/2nANjVK8s4dsXagToW/pLbtJ63KFmSbFw8tnYIVcF+6M/EJjv/nX4WPnc+sjbKuEtiOxqG9LQ0zOOel7fgda/UMo3Afvc9QS59F1y/2eR7IalPVAPpQm0mIlNNkMLqMG6+BXYnREYzyouepx4gqVDAa2/VpgTX738h8hBO3prZ8nRd1mORgY1AA7MdTdIEfB3sCE+ZnWxZLCP8B9WYwbM7PkPz0RVvyl96NjP6yFcsyvHosTFSc5OSiNQf4vfqXhQqM4Vl55MSDkBSp+eM443Tbsty53o4T15OaMYl/kLibeTjpQvI7dmayHLlmCeq8u2H+VIy4I1T+p4ZPF/K8z0r5oMY2e/Xaa2GDsnwDrIZYkhjAKKaqc0El1dYxNTMfwBPnKeEXbQpeEb8hGm82/Vb8t01xDYK5ZYRbmWLeuk0i+wtDJau+Kvd2uAPaqAx620Ba32mLRkMZ0NRsINL0JOxBJnT4xXJ5CNPVKDanO/b3AvzitOb8XV73DJQ7rWjEgSj3PPv4RSy3yuNVbqGTbt9z0YEiJu7rNakOwakcHVqsUS5VUZ2mcvsle5mSaLQu+ynZIJ5d7LlddNxoNIgmWE/3CMFGMKubPt7IkEnbC7G6m
 FdztL1vT
 cUizkeu4XbKlY9E87Bf/d+XGI2ZWE56la16jxycWOo0u7vIdOinwG4cS5T3vb1gXjavkNcMRU3jWuYAQiJTwM+87dida8ir+5jYCdce4T5b2SNSE/Ey/MMFxapqYH+exPo4DExaE3EzzFLMpJxOTXLRy47rxadcv3Oa8wGS4I3JaWHE1qysvkGz0vncNk3+wN7z8V9DzumoFycMKVp5MrXOQybVXgrnKAnsVoJUGculuwYOIAOvCJApUBiN/1Zy6gV4Ga6oob3cVJsoxTOR5Z/4F3skOOYEmdtJSi0uZoWlB1pCa/sSko0U3VnOoAYjscoEGDNbVdsMhqgN7vUZAqS5SQgx50fXqTcMlRP8WSuPOjiU6KJYGaVJVqFEt7EzcrYGcP1rJV/DWY/OluJQzCqHYXe6nlV0nFJiZfbMAa8cekAiY+M+hF7PqU0KWQDDlDjbBZNX3EbVvlE94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we allow only one attempt to create init in a new namespace.
If the first fork() fails after alloc_pid() succeeds, free_pid() clears
PIDNS_ADDING and thus disables further PID allocations.

Nowadays this looks like an unnecessary limitation. The original reason
to handle "case PIDNS_ADDING" in free_pid() is gone, most probably after
commit 69879c01a0c3 ("proc: Remove the now unnecessary internal mount of
proc").

Change free_pid() to keep ns->pid_allocated == PIDNS_ADDING, and change
alloc_pid() to reset the cursor early, right after taking pidmap_lock.

Test-case:

	#define _GNU_SOURCE
	#include <linux/sched.h>
	#include <sys/syscall.h>
	#include <sys/wait.h>
	#include <assert.h>
	#include <sched.h>
	#include <errno.h>

	int main(void)
	{
		struct clone_args args = {
			.exit_signal = SIGCHLD,
			.flags	= CLONE_PIDFD,
			.pidfd	= 0,
		};
		unsigned long pidfd;
		int pid;

		assert(unshare(CLONE_NEWPID) == 0);

		pid = syscall(__NR_clone3, &args, sizeof(args));
		assert(pid == -1 && errno == EFAULT);

		args.pidfd = (unsigned long)&pidfd;
		pid = syscall(__NR_clone3, &args, sizeof(args));
		if (pid)
			assert(pid > 0 && wait(NULL) == pid);
		else
			assert(getpid() == 1);

		return 0;
	}

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/pid.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index ebf013f35cb3..1a0d2ac1f4a9 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -131,9 +131,8 @@ void free_pid(struct pid *pid)
 			wake_up_process(ns->child_reaper);
 			break;
 		case PIDNS_ADDING:
-			/* Handle a fork failure of the first process */
-			WARN_ON(ns->child_reaper);
-			ns->pid_allocated = 0;
+			/* Only possible if the 1st fork fails */
+			WARN_ON(READ_ONCE(ns->child_reaper));
 			break;
 		}
 
@@ -230,6 +229,10 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 	retried_preload = false;
 	idr_preload(GFP_KERNEL);
 	spin_lock(&pidmap_lock);
+	/* For the case when the previous attempt to create init failed */
+	if (ns->pid_allocated == PIDNS_ADDING)
+		idr_set_cursor(&ns->idr, 0);
+
 	for (tmp = ns, i = ns->level; i >= 0;) {
 		int tid = set_tid[ns->level - i];
 
@@ -341,10 +344,6 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 		idr_remove(&upid->ns->idr, upid->nr);
 	}
 
-	/* On failure to allocate the first pid, reset the state */
-	if (ns->pid_allocated == PIDNS_ADDING)
-		idr_set_cursor(&ns->idr, 0);
-
 	spin_unlock(&pidmap_lock);
 	idr_preload_end();
 
-- 
2.52.0



