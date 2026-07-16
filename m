Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBEE2C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B8A6B009B; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3C26B0092; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73CB6B0092; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8416B0093
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:47:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 919AD1201CD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:39:48 +0000 (UTC)
X-FDA: 84994898856.02.D3E90D1
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf18.hostedemail.com (Postfix) with ESMTP id B664C1C0004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:39:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=lUOjiNEA;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf18.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=arLEymkUVoitQLqfzvX2ap3GpzLfAGuJIPCpZdsJGXY=;
	b=lJByco1x1YGhb0pLYRKVnA+X9jBGntjsNrY0oBzNCbS+6/b7v3O/45HEZMzXnB/m99OAnU
	S5uW2ty9pOtxBogEK7RsCApU/mTmN+Hs1sAG/GLb3DunWZBjZuFIp6DsNqpashjezG7NkP
	hbwbyyzSa+Xz2NqN0Z6IlunfZuBUZAY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=lUOjiNEA;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf18.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212786;
	b=5bl+DiUPPABBRZbMCfHB2T/ygCtwBUvOPkvHBlY6oS/Vg+oormAyfbJ0nM9e1z5sl6LH/U
	4JdM5jRb2ZME7A4PrvDw2lxt+YAUuKsflGltzS1k3sxG3RZl85G97mty90KCpOc6tKFpvL
	rHWqioxra42YDhXmD0OvvnR9JCug6vc=
ARC-Seal: i=1; a=rsa-sha256; t=1784212462; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NL5sCBLc0dzSrKk0ctGJxf6xVg7GcEWBWgOTLSiTytPv37cluDJagT9/MuM7186bcBLQyxsMrZpgqVPNe4mklAJqFEnAdRUUFcpSdIUGii0q0NYX5EMysk44mKrtPcpV6J5v5bOOKb3lt5R5j6tE3j8XuGgy9EQ0NRN8NH0536U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212462; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=arLEymkUVoitQLqfzvX2ap3GpzLfAGuJIPCpZdsJGXY=; 
	b=KUm1VnpBfYK9SXe+mGXg+Qn3vvLnCACE1XIX1crfmJzmqMUW3W3kke8dmBu/5FgSSNZGJ+nnJeQGSvPpeGrbYMcfStJDCn8NpVIvbrf/PjixfByOh6h3ALtCxOttShGaOfhKoLRNQR/rjCBu2u3xguFN0yW2+Yd+D2LbnbxboN8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212462;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=arLEymkUVoitQLqfzvX2ap3GpzLfAGuJIPCpZdsJGXY=;
	b=lUOjiNEAs6gVFsKJ7ywvKHQj6bgQShhP9SBhiAd2VMu3l7Ql7s3RfxW1DptBI0CP
	49ibTx/3SwuBWhvFvcqhWYc+mdU7WGi1PfJOzrBX8g9dP1KfROPORzf+n0VoF5T/xAB
	ZXtnxpMJqC6Zlzdxg3QescLRlZH2IuiCV70W7H3E=
Received: by mx.zohomail.com with SMTPS id 17842124595011012.3223632220755;
	Thu, 16 Jul 2026 07:34:19 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 13/24] fork: let new tasks start with task work
Date: Thu, 16 Jul 2026 22:31:39 +0800
Message-ID: <6a841a3d1ca2e4c5dfeccf1863d4e07290d33351.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: B664C1C0004
X-Stat-Signature: regw1h9ckscpraj8868hozt6utje93rg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784212786-102890
X-HE-Meta: U2FsdGVkX1+Bb3WkvVHrgs13B1v1PehG835ESMAcSUAW/VyJ+iWX8bUdpJPsoUbuHOkbKX1Zn2jv+o+Tmn1NMpm2nXil2XtfAyKDY8ILiJvo0WTlzLR3AYnGmlngFsjwb20zJIgGqe/OEpuYX4uJUFG7dfBq4WHC6QI5fdAFOXZabxRKX3Cm9923oH9aKaNZ73BTvijZ2gQl3l8svS0OQdrOiE5HXSELu8mHgG3QklYs43Xu1ppQjNobTxFIBOKPt0OFPbW1KeYxkw0iskv5RAx/swVjcLe8/6OrPvBmKNWCUtIFGdPYu52aQ/KrNjAZr4yUI8w+k7Z12fFQxwLxiEu8lGINeWKX+uEAFaIk73sc1U01TwuNwYu1BvadLj2c5Ex8CtUTPiqOoNI/aZEHiCD7xG6JR/ou9D6WaiIFZINbjbuQnN8M1Tp71u0rDQIWkfHQN6LcbCnQ2FJ6NwyYk4W5dK+QqrAZ8StoHHhYBTi8HIB6uL0fJoAXFdZ9cMS5zAUCZVhAaTqOZN8biwu5hdZozWDUvY14CdWyilTOO8Z8wm3SLMXgNMqzt0zdSZjZ2m1xREy/M/GhD/MHrwb+Sn2bnzGf+y+6md1X/qGRVH4LKoFHDZaZ9lfeo+FEUsIns7drRQd0wzzxEnQWM4+caCW5J29tgHRjG4sQ1zG5Ugk0ntGewRA4U5Z6+9qjMbRTqUtWtSZ0BMKCAQTwoUf23za1HehR/fRmRp8aAORuvxwvakFbchNgwB1kR2Q5SbHEdNlPUhjc+mYzrc5Y3cg/GLZ9nT7NV5mTzh1KYeJlHJqtD12ZHP4MxHypuQRCIr+BSYoAZAXPKgoXWujn7p8BgAa3+VTL61ySSwMRsFO1bMbBufRuhF1rxxLT4dvuiRS7Lc+NtbnRykLXktRSRzb8XpKYYp25gbm4QFDflEVgUAMYZkKP2ui7LxeZA1S0g/A/8gu7G8QGW3nbBia6oJc
 xldRcUuu
 1TVE4zKmtOWCBsf2aUiCR4z7t1Pu1gPrLF9LTGNmOIM4dWFtPp5NWDW7BiwFy94QKJQlel0yBTdObaWDQVP6uLxWLPGFAWlOaoY5oDSJOKMHuobp11DPS9P+hyiCC8yp8IxWI4Irr4aCEBFSGSBEDgfBAsFxmKqrzXdXu44FiRpT1hJ7QEkLNOZOkM5F4r5kTAMJMvWI2Vx+JI/zvFcGKGTdCoFdITyzlpiTjVr09zYOIldybTirXhxvYgfBzLBYgQHK6rGHIH+voHnsMX6G+ht9RpYIV9826d//GSiZ8uvM/t0Nsn3VidWKTnWUYNEAneydfoAkpTmNq1fkAqjT3RiBuVzujmkjJNmdw2rEqBzhCmn7nxQB5RCpPttuLpmIEau+3+lyvDBPeb+DLTvPoCf9BSZA182rfQ4mImt/sHyany6YLqw3f6li00vwwggIR1Ozx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Process builders need to run setup in the child before its first return
to userspace without storing a kernel callback in architecture-specific
saved registers.

Allow an internal clone caller to supply task work. Queue it after the
last ordinary fork failure check, while the child is still TASK_NEW. A
NULL work pointer leaves existing clone callers unchanged.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/sched/task.h | 2 ++
 kernel/fork.c              | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 5b7facf12b33b..830de99aabaed 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -43,6 +43,8 @@ struct kernel_clone_args {
 	int idle;
 	int (*fn)(void *);
 	void *fn_arg;
+	/* Run before the new task first returns to userspace. */
+	struct callback_head *task_work;
 	struct cgroup *cgrp;
 	struct css_set *cset;
 	bool embryonic_exec;
diff --git a/kernel/fork.c b/kernel/fork.c
index e3ade83b2d4e2..c0584eaa74711 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -109,6 +109,7 @@
 #include <uapi/linux/pidfd.h>
 #include <linux/pidfs.h>
 #include <linux/tick.h>
+#include <linux/task_work.h>
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
@@ -2504,6 +2505,11 @@ __latent_entropy struct task_struct *copy_process(
 		retval = -EINTR;
 		goto bad_fork_core_free;
 	}
+	if (args->task_work) {
+		retval = task_work_add(p, args->task_work, TWA_RESUME);
+		if (WARN_ON_ONCE(retval))
+			goto bad_fork_core_free;
+	}
 
 	/* No more failure paths after this point. */
 
-- 
2.52.0


