Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17440CD5BB4
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 22:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFC46B0099; Sun, 24 May 2026 18:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5396B009B; Sun, 24 May 2026 18:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CCB6B009D; Sun, 24 May 2026 18:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4A36B0099
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:40:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABFA3161F33
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:14 +0000 (UTC)
X-FDA: 84803783148.16.874C2A2
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A620140005
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=AeqWbKCO;
	spf=pass (imf23.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779662413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTm1itVUL5+eVJJJDMx7jNDUCkEzXL7A51fiJoig9I0=;
	b=cQimcyDjykZvS60SUT/HyG/fV9nGMJnkQ0ZSOqDjQsOJyChVbbTlIn2c5PsIhQdvNeeBZT
	EdRSZ3fa38WuDO1W1gLXmadWMmbu2JPTtTFamS9++ZmopY9eUSUNJ2S3vuCRBOBt3/g6mH
	Ez27hHgxNrGcwvlgas6u7yTG06cLKl8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=AeqWbKCO;
	spf=pass (imf23.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779662413; a=rsa-sha256;
	cv=none;
	b=J6rPaqOD65dwYnmnW5gZkptzR8gSG1t0wJOy0rivUe6JFYKYN9P4XPzUPsdMarghXp700o
	mZnzBahhcUOa07pU+EGFQQRFc0Vy2fYzCQb2oiNuXPr6MUVTDRMQ9DCqm6QJhgJLhY9hAQ
	ODyclmL+oBM59PfY2j/TsBIy8nOreDc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mTm1itVUL5+eVJJJDMx7jNDUCkEzXL7A51fiJoig9I0=; b=AeqWbKCOVKwmpj04OGqNk+lIse
	OPKs6G1dYVi8+O/iEBzMglZKx/8fvypNTZV+7oqLD1EdlGxOl4VNLAuUvJOLUL7C73cetV7xgTRke
	yphjQ0hZ9a/e79OWUa2X6Uz679aHPykck+EJdTzN7JkCQ54WpntvzPO8OQXy0Vnk/SQzl4lafJqqB
	fCUzxlP/hxCP7PiMI+UMtiMMRT0eS8q/8PuFgpnZV5hcbp+Vw/QvHJkxO55AujpaL8RNHyCZ6DC+l
	AdHQEboVBf7oWmbL3U2cLkLllFjoTAXQFA5Dd6zuSaSPMSJ/dNAvHY8jm9dk5P4rnNHPM9UyjPUqo
	bB8/wc/Q==;
Received: from [179.118.191.12] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wRHUI-007fJn-7A; Mon, 25 May 2026 00:40:02 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 24 May 2026 19:38:54 -0300
Subject: [PATCH v2 4/6] sched: Extend task command name to 64 bytes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260524-tonyk-long_name-v2-4-332f6bd041c4@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
In-Reply-To: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
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
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A620140005
X-Stat-Signature: t4i39i6i5zqz5z6ngcm4zujwk3xosjej
X-HE-Tag: 1779662413-468412
X-HE-Meta: U2FsdGVkX1/9U7fF1FijwcUpn4NnaiHHIzwbp+JbEtzca74svHPL4NxDBe5INpBA9vBSh4agi4XXDSO3LLZZ1DKYnEUXlOOuYhXS3sFBrANT3RGaJ1L19NY2pP3mXTen0KitCXo9Y0AhhQoyKj8ElfqUFTZbpnenQ7WVBtENAj7OpNjvqxZjM4jucKUVX3Unr2iK5muYTxBCYBvWXbd1vkkxL32QZ07GFg/tCbNBkng8UVYAYgKTDJgVkoEdGF9qkGyzQpZMJPTa52cyoZH1Ua1YZXT4j6iOZbncWcHRAmVnmhwHB19zFPAQwcgRCXEIN/NznOHmQSVWFr6grl4Xm0+q7xdduMu2ECLUGze/c2/v9AsdP81UcTY5/2V/C20CO05x2aPIxcP1FlCR2fX3T7wYzVBTKnGB0GjPUtfIg9QKKRwDfPMxj0mAIiXtftCj3tMWTogv0BHs+i5SRNPdCGqJPFan/co1S7IhbblQqwyRYS4WiEa4OC/VQPMLhu4WkNQirWs/zUSkKKNNTFR11mBtPtVWsj4zuuO5t3Czkhte4fq+PEfO5Lxx8WTlPRyhFsflEgatbTwyyqlShWCDvQWI+TXXvHbS7zHFCWTnaaZqQk9c6bjklmulFJVKuzroeMTFK2PGCXPn48TcPBBc3+A8D0MneqQeDZeRWBU0NYDwpksFArGtZAh/WR/UBFp/6+5avTAonqaDV57sDr6fV+pMjEbuYV5QTVsKRvKtp02zWbx4dCbyUAwMWfN91Xvwr2j6hwQ+0Myi/JjAvotcD2ABvO3cFgOI5eyR0vNUQDLbe2tbUn7NKUlF57ljT9yGSZzXm2DqY6drwvxSoddMbpPT/ClmkolUQupJ22oBti/TbI9OnILKr5kTYNncAnE2pKesCLY/0W0jtkzwPZ6QVC5hPZMV0SPqrl/BV9J9IXh8PjEw0rF4Scssp7a9hmWmXT1I2Je4DHWTRg6i4cj
 jZi82MFa
 mZ2xlmnPViNKT0VuAiyfXKEbV95NC6FY7Yp/Vq9J8gTBMMjsG0Vs5BfQe3g6UeBH5U6o+U4UZP8oxgBB2pj67hAlz8XzhFDXU2Q4q+wYwTi5js0rdfFzBAHobNQTvsQNih1/AscceX6nXZtaxcjk5kmGbYRMwG+cg9N9YdeKcrgfr9PSl7yonq3lyNzbHP1PWe/oJxIhgJXeyeI1BpWe7rJVB1ful312UZqfRBiYMEMYLg/VI/UjjTm1hdFDvh7oebPIcRzKuZkutP8L7Low+ehkdzd7CkOSkRxZe9i8DhtM0YU3lL+2CPMX4rsHTdCp59SqfE2gMcnsOITpBSB9kyXfjOiH0q43XCDSkTUCYgXAAzYOlVAErKWZW/sMmbLKuKb2GcDGL+hJVDn0/ZKD153B78bk2GF9VEyDyCh6Z5rUm4Jf4FyR1zhXwe7mjD6Ptjwo4
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

Co-developed-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 fs/proc/array.c       |  2 +-
 include/linux/sched.h |  3 ++-
 kernel/sys.c          | 10 +++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c8c3fbd9bfa9..312371eddc7f 100644
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
index b6de742b1155..f7fd2b7d131d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1167,7 +1168,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 1d5152d2395e..76d77218ab19 100644
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
2.54.0


