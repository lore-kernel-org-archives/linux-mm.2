Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD9CC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 12:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0B68E0079; Thu, 24 Jul 2025 08:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452138E0074; Thu, 24 Jul 2025 08:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E388E0079; Thu, 24 Jul 2025 08:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 292198E0074
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:36:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F08291A02F9
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:38 +0000 (UTC)
X-FDA: 83699106876.30.B9D4922
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4D6D2100005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=JKghUDp+;
	spf=pass (imf05.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753360597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtmwqIefmP9hgVB4nAr4h+0uRDWTQ0QL2qUbei8qyDk=;
	b=aD1PfCqINHXQ2qo2FNK/W0P/wVQFoBtbuALtYIc/8yJ9UI1pJxbMSocRw6sQbzrFzxGzjV
	bn2qraGpl225wvhixxRHDTca9bcuNlWbDW1Y/0MugyPf62S0zPqgcHkuIfbTVEeJ8DLS3o
	Bft2ACpZ/XAAvaDs7SzbknWo+OJFnRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753360597; a=rsa-sha256;
	cv=none;
	b=hvphQgBSOjQlDh0k7Kcsjd1UYNcUDkdip3L456sEWubuIFz4/kq5RsNgudkoESv0965zCy
	psym1zRZdJs8p3FgDdjpmaRIu61yRRE+n31DUoGcxzuXWZhezUnUjp/EmhZjXVngOaTzV3
	CLU4tJLbnTbihSlEAsvsaKzrFNII0Cg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=JKghUDp+;
	spf=pass (imf05.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rtmwqIefmP9hgVB4nAr4h+0uRDWTQ0QL2qUbei8qyDk=; b=JKghUDp+HlUWPn2vpYAlkohY7x
	BeZtFdce8x1hSGI+f5rk/JAfjYlz/Zaaf87zzqMgTzkL77GgzjkIDUD72+Hp9TkbBz33/9MAAJ6lS
	tCUMtin1AOvtSvtjPo5Mfd9Zpp0Bwj0EMtJHmtnH3D59cwzM3NGX6t3PZiygjazK9841aaG8eKGvP
	uG8A1Ikyt4U1B01846CkucnCUV5t8TiciEYtu8WYp+rV5MtTE4miQZN0uf9wBZ+gJYgqXbkHhThy4
	Ro0wtfX3OimP+UFRKorBabHkzlIDIcejBbqJO3kZisOr3pfcjQUN19WRQaQ+GqtN6Fav5fLCJ4YQ0
	YyxgPeTQ==;
Received: from [223.233.78.24] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1uevBY-003BPU-SL; Thu, 24 Jul 2025 14:36:33 +0200
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
Subject: [PATCH v6 1/3] exec: Remove obsolete comments
Date: Thu, 24 Jul 2025 18:06:10 +0530
Message-Id: <20250724123612.206110-2-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20250724123612.206110-1-bhupesh@igalia.com>
References: <20250724123612.206110-1-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D6D2100005
X-Stat-Signature: b5mpow9ycggboai5wtf4d6i7erkgmx6b
X-Rspam-User: 
X-HE-Tag: 1753360597-168515
X-HE-Meta: U2FsdGVkX1+z+vuR8MEvhxD27rodpuwCbRn/ByEPW6dE5nHd0896yI6eE+VeeBs7l/2IA5pnin83CKmTToDq6uac/0d/HP8d6F2UPLhpb5eauPPDIRlNZRci6XPDPi3UpYoXd0h+F8lrE2mxie7tXNh0hGlBuUR2lNS91kY3HCdsXn40I7hu8zRE/PoTk1D/n9aTLHqEKqUmxUw7qc3ImgaYFdm1IKelpNkF8oM8IGoqeYGurhG2tb4CF6u29DHOMpcF7/UKEXQs5kmxbC4On80re+d+1ZTeoTSse5HX8bLzpNpjkhvgMFETrD2fM6+sWyRB6pj2Z4BYrGxDL1OMAqJFfddzwKKu7etqegSIYMqm93dl1O+DZEmjfsbGvCPecmaWlNx/qbXTpKVFFfCWF6i044w2mkptsd31oEGw7Y/yRs57h1Tr84Zw12q46ANeb27PanTNtGiTlOzC6ki88K7PhuTY4XAe28UaEyeGLCUR76ABpze4gSlG2MtiMm/wIXR6vLEEIJ6rRWWDncgPpHCP570j4vBxcSHW4CXdpa2zKuHMO1cHoOE/x4hdlp9qipQiO0KlwsXLj0v41Erm4mAhSxZNkYgSJOxmJeOrsI6Fz+NopVaQFR1DSU0XleT8pUcoLKa7U63uz25eN6gCRtFlWyDQwjGxpp+E0cZRmQS4x4Ih8p6kLhKq4AvDKnYT06f1COv0Las81QvqJsNSsCU8COcBvvbZQkS7vV2/F4UVmGjsuzVBbuyPQSwpPQb8EyJqUz5lpuiAfV3kNj+x+HYJjq9CKkU5q3OZ5XnMJUFZZRXNSUX9mr7+jlvDd71ffZqPYQ6Lfq645q+VMUr651xiyNSrkYigIrHaJPbhTmzfyfi00W+Pf9e7vafuawnE0RRh5Y/TpVLZhfbefq8axYjH32WIJBi13gygbV7sNiGoGQ5WkFCemJe+rtyL7BY7LRvMVkrxpg9NLL2H/ba
 W/iEvYkS
 tf0/c5T+zrY0EcaIpz7zHCbsPcAqEfgcq9WU0RCpYJGnS9ghOxQkF5Xn9kC5rhL8rfTKLErjTbsRBtXagWHe9m2fCLlQ5ZNuWi3v9BusnQrJoCfq8OFaEXpkXFWCYHfm4Vz3rLWg23PATgDt4QfzI5YbpHBU4F5C3EMLdh4EINstT55OcXZ/FFGC9RPcqMI9ZASkjAyY0m68Eqc3INzM8zl/SyVBWg+GC04TI95loEsfrC+58/En+o1MpcyUW6FFTC3fXETrPSYYu5HZay+2nI6zItok6dKAMkppDlDdTUzjSIbWUBWrYcVHtHcTtJbMaSH7HrOJbpNcP4FYaOIyt3zTDOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 3a3f61ce5e0b ("exec: Make sure task->comm is always NUL-terminated"),
replaced 'strscpy_pad()' with 'memcpy()' implementations inside
'__set_task_comm()'.

However a few left-over comments are still there, which mention
the usage of 'strscpy_pad()' inside '__set_task_comm()'.

Remove those obsolete comments.

While at it, also remove an obsolete comment regarding 'task_lock()'
usage while handing 'task->comm'.

Signed-off-by: Bhupesh <bhupesh@igalia.com>
---
 include/linux/sched.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 84449f847256..8bbd03f1b978 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1156,10 +1156,8 @@ struct task_struct {
 	 *
 	 * - normally initialized begin_new_exec()
 	 * - set it with set_task_comm()
-	 *   - strscpy_pad() to ensure it is always NUL-terminated and
+	 *   - logic inside set_task_comm() will ensure it is always NUL-terminated and
 	 *     zero-padded
-	 *   - task_lock() to ensure the operation is atomic and the name is
-	 *     fully updated.
 	 */
 	char				comm[TASK_COMM_LEN];
 
@@ -1965,7 +1963,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
  *   User space can randomly change their names anyway, so locking for readers
  *   doesn't make sense. For writers, locking is probably necessary, as a race
  *   condition could lead to long-term mixed results.
- *   The strscpy_pad() in __set_task_comm() can ensure that the task comm is
+ *   The logic inside __set_task_comm() should ensure that the task comm is
  *   always NUL-terminated and zero-padded. Therefore the race condition between
  *   reader and writer is not an issue.
  *
-- 
2.38.1


