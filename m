Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F101C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3476B0098; Thu, 27 Aug 2026 14:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A942E6B0099; Thu, 27 Aug 2026 14:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B0F6B009B; Thu, 27 Aug 2026 14:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6ECD46B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:23:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05C8940161
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:47 +0000 (UTC)
X-FDA: 85147872894.17.2BD335C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4DEE81C000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=at6oDwZd;
	spf=pass (imf18.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787855025;
	b=oWgH7mxjLcp87w6sjNc4a6sQuZz9kw5xecGPbv76P2AgBfTa3m434DcujSt/2gY9e6JNMs
	YixSxbvNrqGwe1EBVnjQRU7n/dAJ3UsDQLJQO/9yxjF9eePscpQyWcP2Z18Dlslp/0Jtdd
	8GkgWX9r1kAYAxE/CBgDjaeK+BlfsSU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=at6oDwZd;
	spf=pass (imf18.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787855025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwqeHqUYJu3OSjLPCkapAyi6pywTO4QN+uPji9ROHhg=;
	b=zLrKTh2zSzsVBHngp3KH/0TBpePOVTUQLUlL5/iIveNcPF1tePNUh4mkPH5N0Kri1EEfts
	4WzGX+8Jixkz2+/RTsD3bSYS8RKvicDfBIILXAh3TWW0lfildst4QLEqHikp/mSbfM+hNe
	bZlLffBAP4R1d9yFgoYu+y1m3V7Z5iA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=WwqeHqUYJu3OSjLPCkapAyi6pywTO4QN+uPji9ROHhg=; b=at6oDwZdvMMfjaicvNK76Q+xeE
	5U31g6f4iMZLc/xEfMra+AG/eAoO8VVskEbrelaDGXGFsvr6p1x4T6ewcd2h+d05Y0nNHfJdopLku
	LtEk/ct2SKoBaxfYmvErgjv8aSBefcEv+yRU5X7uOc2atI2vDDheZPeK9j9l4LjmR5jslxrnazEyT
	e2Nuc1XoR4bM259i1pQ+Q5/G3gwg6w/WnpIgXjlCZ6zgN1q2SIA0z+znxMTh2L+5QP4BYCEMzxcd9
	NKhwruIamvJzboSZVAkdaZB9NFFuBs0avXqiPxLXjZ8dz/2Hkh1xzGgPmmVI0+McgdS9bB4HzGc1G
	0cqOnV/A==;
Received: from [187.57.78.212] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wzelH-00AOUg-Aq; Thu, 27 Aug 2026 20:23:39 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 27 Aug 2026 15:23:03 -0300
Subject: [PATCH v5 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260827-tonyk-long_name-v5-4-5fa843782a00@igalia.com>
References: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
In-Reply-To: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: m36apq3bxpfsra43f6qdgirxcef7snp5
X-Rspamd-Queue-Id: 4DEE81C000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1787855025-622351
X-HE-Meta: U2FsdGVkX1/cm+NKdyx+K1N7P+3MSV0U9kxX8VR2J70SVaA1fWopFy7z0Z6fQazhxWjTdwCwU/1UvmYdjNYmH4tJYDIP+YDnJ4dDLsDgc/8gMisK+qGkiTv6OUv3BdOa9DrFyTNeYTE95MnG9umInjgFaPHnNS7uRDGx2MLpcdFh/EoQJGWxhENF7GmYyijkxjZSvnkzGY7kfFDbnicltHZLcfv2XIopD/hLscJP2p8SxnJxMl6C8cHRLJ0URcUWPnDPUc8oJYRSe17IvihfdqyvNyRS/23AB8Uevi1l3B2Jk+WEcBPGKaVjA4h6HP7Fx885zY4X2m8hB26JMc9f01KyHiM9d9/4KCnvZKmnvEuyvbbRGl9PMYXbNME4ElERCDmLvYzssOPXhEb0KirdQ1TYcSeIA61mkJagUigLemQtP5wCXVCzFofMUlmYjIA8SoA1V9s6h31G2wGX+v3elpDdqPemS3tALmxP5ODjdziL9OtA11QpHsXooI9GAP7XnNk0e5jqeSZ3ojiJd18z9SNM2TPZUzHofrvk/Khb2AbXwsk9xjE+3CYYVj42PYfXm4z5gSt2Px/ZwxzmXO68S8o3HTX4zdOthExn03BvoZmg9jRhmHJ3Sk1yxbYjizrL+otuxfdHe981S907Wt7MKODXj9vfkcQOXZFa/NMKbxUT9ss0iN2DR0m8mG11BA8hAajGBxXv2n8+nd4NoLCZDbdRLTpyrQZ4dKJ0APGuY3lOo5W4sTAQ6bEqk+v/i5a5JW1T4O6dV5korFtQt/bDKWy/xx/oO3xekxGSOl9Lvw6ndF7zfqrovSnhBoaMSRguc08AQu1kafjkxVO+WbTpNTWL5s3a4SEWPL2u10jVm0yCJBZiEsig2IF28/MsDtqEAEMOEGwNe3+xPVBCqG1a/9xS31y5J/a6Q9kiTRz1kNRUSpWjM1HfN3coIBdkCbsrMD/PsEY7E+fQyIh/tcH
 /NTmJd3D
 FkmwByHj5Wl2XKligb6L1cSG3UfflEy3Mu+Df3nQ2dOsyL0D6fFNkmnR6y70oCBzvZnlONQenCB4Tpph1rkERejkNZsZ0q0NngzZzo1rtUD7S7erA+j7vIdqPzi+/iSSul3q//y6TUZ4/+XRTzbV2tWCqIDv1NVymvG6YJkKIQqUw0P9PebIXHNO5UsLvaQ2Z+mvWXR14NVbuqPCBe3H2CKMQI3ZOMOdo3zMe5szmVq5z5OCIfzd+uSG9QJbOwl6qubXEZ3RQHhQ+0eNjlvEHSTgXDQNX4TR+PPhn6QeZVERY6NgHCnQK+edPhUUQwUCep6OY1HCO9/gzG0qpv7RJ2ossHBdDraYbFMeUJhdkKcbFT+no+bBa007WC6+ndZoDVYrUhOPiD6YqjWkpv2kNpSlsi5QWxGhm7uuM/991cLNChSj5lLNjqgIrHg6cydgQ5c7NEf77Tmfj7kQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Command name has been restrict to only 16 bytes, which is too limiting,
specially when debugging and tracing complex software with thousands of
threads and the need to differentiate them.

Just as it was done with kthreads in commit 6b59808bfe48 ("workqueue:
Show the latest workqueue name in /proc/PID/{comm,stat,status}"), support
long names for userspace threads as well.

To avoid buffer overflows, cap all existing userspace APIs to
TASK_COMM_LEN, and leave the full extended name for a new interface.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 fs/proc/array.c       |  2 +-
 include/linux/sched.h |  5 +++--
 kernel/sys.c          | 10 +++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 8ebb7cf1a7b0..0d70b21c803c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 	else if (p->flags & PF_KTHREAD)
 		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
-		strscpy_pad(tcomm, p->comm);
+		strscpy_pad(tcomm, p->comm, TASK_COMM_LEN);
 
 	if (escape)
 		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8d2355e41619..c41d61e9babf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1187,7 +1188,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
@@ -2041,7 +2042,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
 {
 	const char *_src = tsk->comm;
-	size_t _len = min(len, TASK_COMM_LEN);
+	size_t _len = min(len, TASK_COMM_EXT_LEN);
 
 	if (!_len)
 		return;
diff --git a/kernel/sys.c b/kernel/sys.c
index 97df708c11a0..5ebd3c1dfddf 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[sizeof(me->comm)];
+	unsigned char comm[TASK_COMM_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = -EINVAL;
 		break;
 	case PR_SET_NAME:
-		comm[sizeof(me->comm) - 1] = 0;
+		comm[TASK_COMM_LEN - 1] = 0;
 		if (strncpy_from_user(comm, (char __user *)arg2,
-				      sizeof(me->comm) - 1) < 0)
+				      TASK_COMM_LEN - 1) < 0)
 			return -EFAULT;
 		set_task_comm(me, comm);
 		proc_comm_connector(me);
 		break;
 	case PR_GET_NAME:
-		strscpy_pad(comm, me->comm);
-		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
+		strscpy_pad(comm, me->comm, TASK_COMM_LEN);
+		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))
 			return -EFAULT;
 		break;
 	case PR_GET_ENDIAN:

-- 
2.55.0


