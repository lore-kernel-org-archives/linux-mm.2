Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE828C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 12:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9EB8E007A; Thu, 24 Jul 2025 08:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B09D8E0074; Thu, 24 Jul 2025 08:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0548E007A; Thu, 24 Jul 2025 08:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35F5A8E0074
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:36:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E13371DA6F0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:46 +0000 (UTC)
X-FDA: 83699107212.27.87D6F4F
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3E8E518000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=GT053E1g;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf06.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753360605; a=rsa-sha256;
	cv=none;
	b=aOwGLbOThXa0zARxmww79vxiEco1rOW9RtdhLuiCd35+PsmA/lDePl4siWgAbhgh/KyVui
	6Q+skjk7jDXBlV3aunsj6rDQn7d0KofjW4YtbyRwqq5+uv91W3xYX4sl1ew2yToAl06wKO
	21Ee4XltFEGEpaiPebowjh6AOqFKbYY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=GT053E1g;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf06.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753360605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxJuMzxUwX/3/4eueFKaBfV57kSJFTkqTcDBwOHRShE=;
	b=2lQUep/Aag7UzNWTTJktpGS9AzpzqebjthOIXbbT5MXnsF/gb98hCqdsN9bJ2By8FSO/Le
	P4lIqX19Ce7lUG4KAFNb/8ohsX1nriYXMlwisrudM9FOF1H3/s582djA8UsGQitqTDdioH
	sMD+xJDGj50xXONqOxDWQcFHjYBk3L4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xxJuMzxUwX/3/4eueFKaBfV57kSJFTkqTcDBwOHRShE=; b=GT053E1gz6CXBmsRuLUeeUOtpZ
	6eA3D/mixw8gzo+maEv5+OIfU9l6l1zpm7hNcECcQc97Y2Uo6qNtBbI9bu7B2qeu4nP2+DbqCect7
	+zjIq1AQLb+dEZgY7qaQ2t2VyspHqmP2HsMoVM5BdOlERpTPwBCWEBlgc3/qNCUZ8n9qCihzT9LOi
	lksslbdaMs5Jqe0IdN1K2iRcqgnMKEunvX7/isGlu7tuUm64o3scA1BrNZUnEgAT3Tdz0XxirNtel
	jMh2a+QbAIEaP9yGzd0xamYvUdg2OP7Rsa5ZEk4cuNdocvwP1xQ9FqXMie0rBszM3c5oXfuc2GzRD
	biNb+Xcw==;
Received: from [223.233.78.24] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1uevBf-003BPU-Qi; Thu, 24 Jul 2025 14:36:40 +0200
From: Bhupesh <bhupesh@igalia.com>
To: akpm@linux-foundation.org
Cc: bhupesh@igalia.com,
	kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	oliver.sang@intel.com,
	lkp@intel.com,
	laoar.shao@gmail.com,
	pmladek@suse.com,
	rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl,
	peterz@infradead.org,
	willy@infradead.org,
	david@redhat.com,
	viro@zeniv.linux.org.uk,
	keescook@chromium.org,
	ebiederm@xmission.com,
	brauner@kernel.org,
	jack@suse.cz,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	linux-trace-kernel@vger.kernel.org,
	kees@kernel.org,
	torvalds@linux-foundation.org
Subject: [PATCH v6 2/3] treewide: Switch memcpy() users of 'task->comm' to a more safer implementation
Date: Thu, 24 Jul 2025 18:06:11 +0530
Message-Id: <20250724123612.206110-3-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250724123612.206110-1-bhupesh@igalia.com>
References: <20250724123612.206110-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E8E518000E
X-Stat-Signature: atma7esu6cenw66kq84rstkakdagos89
X-HE-Tag: 1753360604-285668
X-HE-Meta: U2FsdGVkX19sJ2Db2m+0Khk63Wbwq6lbIAI09lI3qgrJuIj/thggpnJXR7u+QIbL9HNOtso7KmIEjQeqoSVi2r6Ev14xDSYGNmGgstp3HdpU8+sZSWXq0rQT1tbLeqyspOXjP7+KwAuWT0wrFC0mOBpY+MScbK/Ps+sseRF38p0BFG29pLlrFiegMc7FCtTg+CC99ldtBB4VPfWb2KnhIo8P7YQef6T5FkIp0cHzCLHBDi3/6hC3RVZTujSnzesALObhUrMRVRAhkRwZr8fafeqd/I+oVlCy5AbglpBO2HPLXgRfqlKctXh+ux+tSjUS+9zhbd6qPFybICkjL3Oc6HgmDwBlqPntRJr31ZHPX4YtcCd8fdKshwSywtO/hXYk4Mr9jweV5ITxzAWu1O+0RXoLrUUHZ+e+TlyNEcqGzM10pGekjNkfkxDfiO7Qix379LNNyF1z8ljfPA1VEdfeJ7aW19Xg9FOm0P+Nnuhe6Ew1dVhWswU1YSB5QqutyZOXOV9uwilIviwLgfzB0/bWBDMJlehdHTg1PMgVbPnun++CXPizunR5KnC1U9jjNmd/vp2sq7dL+SdHG+63mAqtD+ni9X9OwmDt3teLcg/RnuIiK9vgGXxH/StzgVEXDaSZVyoEU0O1BxIOp+TTkpoQaqhe8HjjUAk5VLSuOWN9jOJMap6nI/QHWogFjPssBvEPLH/NaFb4foPCKGrdpMgyeHBZHgC9POSQOkJdSSmiD6Sj1+Lq3zyMlPEPRtRHlbpdsSFWo7aKKy7u5KRRl1x0auJKXuz1M1eHYulEqj4k/AOKJrjK5BcK+H1dAlmBuoA/BUOPk8UBBz3NMn4rqkroEav+m0i/QnEjUJckwbRSieYKu09IzMnwTDxmmtnnGoZNqSQpQlYz8Oq9ZD1oQsf8d+pWKJ7TBkCj/uY1LJqDNyNGaU8vGEsjQ3jwW5g54jxzav18yEdzNu5DffIfUHg
 Cek9sEBC
 tMxfNFeoKLWaywFbnu5BH//1WOTRmAbH6XMEZKqf6aOvOF/3kBxUiTxg7Qe7PzwAOwjMZ3GGZR50rexCuUn0IQQZpre9MQ6Vwxjb1/P9XuT18PfXwgoR03LO9/WM7+ZuT4uAX9j2Olx6W8r2LhjMX8plTvO9UpIGMSYgd/dAmOo6bSyPkpypnl3bgusw5Lkq6SE1AUgEdgEEKyIIKX7UGFhmvlHxvI0K/+JhmTdhX13B3tz9zAjU2T3eWk5cqO+EVhM69iWo6cVugWpcNc+R4QqZxyaMaNBDrgQ+WoxbdHAITh1uk3OrfUGHazfeQeqHllQ6JPE7DJWZqTr1sCzpGj6yyo1nYeDymcn7flXu/46a8wBz2Tg0SiPh/S+3hOM/cWAsm9kZzWWndvPa9i6EP7DfJXIDEFUZpVkI5CEvUprtB/hA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As Linus mentioned in [1], currently we have several memcpy() use-cases
which use 'current->comm' to copy the task name over to local copies.
For an example:

 ...
 char comm[TASK_COMM_LEN];
 memcpy(comm, current->comm, TASK_COMM_LEN);
 ...

These should be modified so that we can later implement approaches
to handle the task->comm's 16-byte length limitation (TASK_COMM_LEN)
in a more modular way (follow-up patch does the same):

 ...
 char comm[TASK_COMM_LEN];
 memcpy(comm, current->comm, TASK_COMM_LEN);
 comm[TASK_COMM_LEN - 1] = '\0';
 ...

The relevant 'memcpy()' users were identified using the following search
pattern:
 $ git grep 'memcpy.*->comm\>'

[1]. https://lore.kernel.org/all/CAHk-=wjAmmHUg6vho1KjzQi2=psR30+CogFd4aXrThr2gsiS4g@mail.gmail.com/

Signed-off-by: Bhupesh <bhupesh@igalia.com>
---
 include/linux/coredump.h       | 3 ++-
 include/trace/events/block.h   | 5 +++++
 include/trace/events/oom.h     | 1 +
 include/trace/events/osnoise.h | 1 +
 include/trace/events/signal.h  | 1 +
 include/trace/events/task.h    | 2 ++
 6 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 68861da4cf7c..988b233dcc09 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -54,7 +54,8 @@ extern void vfs_coredump(const kernel_siginfo_t *siginfo);
 	do {	\
 		char comm[TASK_COMM_LEN];	\
 		/* This will always be NUL terminated. */ \
-		memcpy(comm, current->comm, sizeof(comm)); \
+		memcpy(comm, current->comm, TASK_COMM_LEN); \
+		comm[TASK_COMM_LEN - 1] = '\0'; \
 		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
 			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
 	} while (0)	\
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 6aa79e2d799c..dfc20fbe389c 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -214,6 +214,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 	),
 
 	TP_printk("%d,%d %s %u (%s) %llu + %u %s,%u,%u [%s]",
@@ -352,6 +353,7 @@ DECLARE_EVENT_CLASS(block_bio,
 		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
@@ -435,6 +437,7 @@ TRACE_EVENT(block_plug,
 
 	TP_fast_assign(
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 	),
 
 	TP_printk("[%s]", __entry->comm)
@@ -454,6 +457,7 @@ DECLARE_EVENT_CLASS(block_unplug,
 	TP_fast_assign(
 		__entry->nr_rq = depth;
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 	),
 
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
@@ -505,6 +509,7 @@ TRACE_EVENT(block_split,
 		__entry->new_sector	= new_sector;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 	),
 
 	TP_printk("%d,%d %s %llu / %llu [%s]",
diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index 9f0a5d1482c4..a5641ed4285f 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -24,6 +24,7 @@ TRACE_EVENT(oom_score_adj_update,
 	TP_fast_assign(
 		__entry->pid = task->pid;
 		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
diff --git a/include/trace/events/osnoise.h b/include/trace/events/osnoise.h
index 3f4273623801..0321b3f8d532 100644
--- a/include/trace/events/osnoise.h
+++ b/include/trace/events/osnoise.h
@@ -117,6 +117,7 @@ TRACE_EVENT(thread_noise,
 
 	TP_fast_assign(
 		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 		__entry->pid = t->pid;
 		__entry->start = start;
 		__entry->duration = duration;
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 1db7e4b07c01..7f490e553db5 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -68,6 +68,7 @@ TRACE_EVENT(signal_generate,
 		__entry->sig	= sig;
 		TP_STORE_SIGINFO(__entry, info);
 		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 		__entry->pid	= task->pid;
 		__entry->group	= group;
 		__entry->result	= result;
diff --git a/include/trace/events/task.h b/include/trace/events/task.h
index af535b053033..4ddf21b69372 100644
--- a/include/trace/events/task.h
+++ b/include/trace/events/task.h
@@ -22,6 +22,7 @@ TRACE_EVENT(task_newtask,
 	TP_fast_assign(
 		__entry->pid = task->pid;
 		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+		__entry->comm[TASK_COMM_LEN - 1] = '\0';
 		__entry->clone_flags = clone_flags;
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
@@ -45,6 +46,7 @@ TRACE_EVENT(task_rename,
 
 	TP_fast_assign(
 		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
+		entry->oldcomm[TASK_COMM_LEN - 1] = '\0';
 		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
-- 
2.38.1


