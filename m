Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1558E606A332
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IT3qkdyO
Received: by kanga.kvack.org (Postfix)
	id 32C0A6B05B6; Fri, 20 Nov 2026 08:42:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B50E6B05B9; Fri, 20 Nov 2026 08:42:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A026B05B6; Fri, 20 Nov 2026 08:42:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA11B6B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:42:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CA1F80F78
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:36 +0000 (UTC)
X-FDA: 85455612312.12.9CFAF0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 78D4A40007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IT3qkdyO;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182154;
	b=sYst8aOOWKkX4fbDaZa19tBn6UXXjls1EwP5a3e1Bb58/YzFgoptMuOmT9q0fFUaDXeYAj
	ZqFewgqVCUez1w/Zfd4MZo9It+MxPsmozYi13aNVoYPnq8v9iLdRhd2D/4FqDace8MTiG3
	i+NVj0RsS12808pQlNbqusGCu+f963Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyU8IUWPHTCgRPl42Jjqqg6MmBy+29h9LlcoVLoowqM=;
	b=s7nie06TdfdbS0q+4dttZRkAE8WUfGG1kVnRX/81dqmjAAwVzEveqeuafLyMsqaUJjtYrQ
	j4h5b9h758ypP5iG5x1rQ6OhzRXm6XmSv14SqnInEu5z8uKBXWcWDiYSr91P3oqsDK2/ua
	ljAbD+itZ7QEK7vhJ/GOk5pRkEFEgoA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IT3qkdyO;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F395341408;
	Fri, 20 Nov 2026 13:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2761F000C0;
	Fri, 20 Nov 2026 13:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182152;
	bh=EyU8IUWPHTCgRPl42Jjqqg6MmBy+29h9LlcoVLoowqM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IT3qkdyOjenbnZjjh6oTAOqIA0GVob6KTnVxDfvTbarYDp5UUhOuUkmXra19JQJ/P
	 /kv85iUdEbJN4QiYgxz+cP9ydLdt23e5X3+rNAllzBmzFd9ZEqjyP6KIy1XUnSmPqq
	 QFGpIH4tRJREJDwwUBtmgetjZCr8TQ6S7uEdAcCMgjx2Rz/L7m6VldAlhj6T61dgQ2
	 v685od1YzezKiNzg0IQTScBdchZw3su/+VD0+dNqPFLDJ7ZyKDYjYa9Gc1Q97WQrNK
	 7kQD/X3soXV84TyuWiMslwM7pXwWg4uxcDl0xQaKXsPrwr1BhWa9ZobjQD1mKDfBC3
	 wmQNka1HpTShg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 20 Nov 2026 14:42:09 +0100
Subject: [PATCH 1/3] pid: move pid_in_current_pidns() into kernel/pid.c
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-work-pidfd-pidns_visible-v1-1-0e82d08469ae@kernel.org>
References: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
In-Reply-To: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jiwoo Kim <arpe1618@gmail.com>, Chen Linxuan <me@black-desk.cn>, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=3561; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AAqjJa+Lt7I0UGE2nk14kuF0ZHp1hs12+suAI1lRIK0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQz+Nle/FntmX/n5pnm3ezOWaevloRbv7bXdGL0EBcJX
 NP3ZDlXRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQUxBkZVn0uPeyvJ3VXgf3H
 m/MxlQ3FinL7389fU+K3/Hroj39TzzH8FQw49fP3S7fLO/8m/wlJjnq2QETAwIL59klX7pfvhXr
 3sQMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 78D4A40007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cjjgbjzwmuunf4gncf7jts8sx1w8hs41
X-HE-Tag: 1795182154-405278
X-HE-Meta: U2FsdGVkX19QXGTz6dFPinSQtSWUZmXK+NXbm322FwDysoVws+IMGquNq9EUARGRdg6bizJcwbpk0mg2eEx3YHuzxaGxkqj5T6oh8rQ4y9ZTcAdqbtGI/qaqLELipFcJfBHjtmqNSlvspV1H+hLIkusNSZk/vPyn3ioS3yN8AOyfoQI5s5mQRP2ra2Xi0+povt+ayA9S9SrmzlvkwWsj6BcLaRqpCaWnhaDYgTkQRtcVouSvX4Z5zxlpGAc0aEJFmkaNrlEMW3X4qfBlgTpboB1B4vZrbImtzJ4M5EmHkxl7yMxlG7g4w3SRwUI2xWZsd15GRfcSL3RaVf3t2qe0FQ5nukEcipfYbUFdhSSUjxxfNQRct4dZQfzL8dS34p8pm0N8QztsAg3KNidTzEJbB03EnAbgFpRCmYkuDRmysPrKZTkRf6mpMQ8pfPFtzjtKl/2MH9wwhEJBjxlg8Gv2cp5tP2S67OpRlVQJuTD1CFG8uZkjU0JpozEVoehCa1mmt+0hWppWhyWv3p0FMZ14wiB8I7SEVlyibhSj079k8ezKPQG7j2lXotrp4/CtkTFk2Ve+P/GTfSZ7fSfiVddiS20QG83e1WQAmTe+saU7KvHySAdcegHsnUhzr/uwhSw0+s4Kq6ZTAniIs6E3Dkx/JB3yjxruzjGzTqDA3JWn26SNDeCMWTXocKSej4Ln1enltHWiQC2X8KsNX2Ncx9JhhMoOL1CIfFDYcR2lp2HIbWwMAYnbTOqH/UwAUf07s5wrAaDh3hMeFSdX5K3GC9kDZG8FK+VFYMmP86jHxz/qt6jrimBBxeNw04SBOF1Y42bsEfDU1t//hdKCpSO0dcZMChRA/qytD9UNNHRSIHh219ExTAeli49At+p/o+x6kwjenBijgu8jZ+LMuMZEFGAn0Qe719FFuxlUKvLtpPvrNXcecuepAKwbtg+R6TBkT079Oa5d0qnWyvIj/U8vIeO
 XkctKkxJ
 /U/wHk0m4MPs66qlswBaowM0C8xS2lLkLqDJwmIMrhL4+PddOxwSo1VqS6C74Ysm6ReId50q+t3xwZTk24HtqoC8zZ/qo2y8g2shj5eNr7y9UuBOw/N4eZzUH3VKJZQq5+gm1nMM+vF6e/WB1vkGkuZqT4ddcPic1ZexHrun3jMQVjDXiogOVKavYBEEvjsCjqLqABaOkVTGReUPq217vBIB0Zez1kcBWXV4LeNVI5ZkCNyj/U6TnLaMbCM4Tt0yuQo59OaUVNBATnPmx62Qt6GmmLqxXlLFAjo81WX5KW6WnRb+CycdV4ZJAFd8dYwx+tzY1SmMAbEHUq+icjigizxIFagk6KgwNylq6XXQuthqcQc6mJ0C2MKGXDlXitYlbMcmirEA/5NWfCwUDD4xM2Wl2ttzkumZjUrOMNwavGBxaHbwOU5z1O/X2ZgG1g82YDcpXL5Ka/ywoiVJE55Kj1G7ahhK8nbBSV1WizFRtHCrBbasLBoUAVYEJ7oAiIXxyvSSsWTj7/ZPPWyY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The pidfd api checks in various places whether the target is visible in
the caller's active pid namespace. pidfs has pid_in_current_pidns() for
PIDFD_GET_INFO and the ioctls that hand out namespaces and task paths,
the pidfs file handle lookup uses pid_vnr() directly, pidfd_getfd()
uses pid_vnr() as well, and pidfd_send_signal() walks the pid namespace
hierarchy in access_pidfd_pidns(). That's all the same check.

Move pid_in_current_pidns() into kernel/pid.c so it can be used outside
of pidfs and convert the pidfs file handle lookup to it while at it.

pid_vnr() returns pid->numbers[ns->level].nr if ns->level <= pid->level
and pid->numbers[ns->level].ns == ns, and 0 otherwise. That's exactly
the condition pid_in_current_pidns() checks. Pid numbers handed out by
alloc_pid() are always >= 1 and only pids allocated by alloc_pid() end
up in the pidfs inode hashtable. So pid_vnr(pid) == 0 is the same as
!pid_in_current_pidns(pid) in the file handle lookup.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/pidfs.c          | 12 +-----------
 include/linux/pid.h |  1 +
 kernel/pid.c        | 21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index a2a0691cf1310..85b160923177c 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -327,16 +327,6 @@ static __poll_t pidfd_poll(struct file *file, struct poll_table_struct *pts)
 	return poll_flags;
 }
 
-static inline bool pid_in_current_pidns(const struct pid *pid)
-{
-	const struct pid_namespace *ns = task_active_pid_ns(current);
-
-	if (ns->level <= pid->level)
-		return pid->numbers[ns->level].ns == ns;
-
-	return false;
-}
-
 static __u32 pidfs_coredump_mask(enum task_dumpable dumpable)
 {
 	switch (dumpable) {
@@ -1028,7 +1018,7 @@ static struct pid *pidfs_ino_get_pid(u64 ino)
 	if (test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask))
 		return NULL;
 	/* Within our pid namespace hierarchy? */
-	if (pid_vnr(pid) == 0)
+	if (!pid_in_current_pidns(pid))
 		return NULL;
 	return get_pid(pid);
 }
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 185bf0cde2d14..1b463921d2ed0 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -239,6 +239,7 @@ static inline pid_t pid_nr(struct pid *pid)
 
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
 pid_t pid_vnr(struct pid *pid);
+bool pid_in_current_pidns(const struct pid *pid);
 
 /*
  * Needs tasklist_lock if type > PIDTYPE_TGID. A lockless reader can:
diff --git a/kernel/pid.c b/kernel/pid.c
index 4f9a29eb29de7..aa3ed6b5d4a9d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -559,6 +559,27 @@ pid_t pid_vnr(struct pid *pid)
 }
 EXPORT_SYMBOL_GPL(pid_vnr);
 
+/**
+ * pid_in_current_pidns - check whether a pid is visible to the caller
+ * @pid: the pid to check
+ *
+ * A pid is visible to the caller if it has a number in the caller's active
+ * pid namespace, i.e., if it was allocated in the caller's active pid
+ * namespace or in one of its descendants.
+ *
+ * Return: true if @pid is visible in the caller's active pid namespace,
+ *         false otherwise.
+ */
+bool pid_in_current_pidns(const struct pid *pid)
+{
+	const struct pid_namespace *ns = task_active_pid_ns(current);
+
+	if (ns->level <= pid->level)
+		return pid->numbers[ns->level].ns == ns;
+
+	return false;
+}
+
 pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
 			struct pid_namespace *ns)
 {

-- 
2.53.0


