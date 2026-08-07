Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F3AC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 04:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BEB6B007B; Fri,  7 Aug 2026 00:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE4D6B0092; Fri,  7 Aug 2026 00:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C58B6B0093; Fri,  7 Aug 2026 00:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4718F6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:02:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBF561602D1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:02:20 +0000 (UTC)
X-FDA: 85073126040.16.5D8579F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E6C04000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:02:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=oaznZLub;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786075339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PVnjRD7StArmNZCJz/ovC5T3H+x2rUiTPvE7OuI7tZw=;
	b=hiuJH1a4mQCibNJiM84KK1UpgFS1x+X5k+yoQ/A7u2r1uWOGAYUujsibRFo7dzVUsmPKlu
	jv4PajaeDtkB85u8+0O5tLio/iMn01h0/3bwXhF1PBn7bx/cnT10AnlXSSjt0Levx2J33U
	tYY67S+rgG7Pu00BFGJH3mWmE7VsiHw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=oaznZLub;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786075339;
	b=f2teSnp8xq/xYfOxAkEBKcO6aoYq5b1G/yg1RnUqrJ9vXF3NeLFbSUbxA7sxJYXXxxc3QK
	0u1FbOpxc9PtF2ch3L/tUovVbXlk4zL/3Dhzz5+ooAei7sqRz3V41PlTdukrDwaCSzrbR2
	uReRT6XxdT8Z2kc1wgyCKmIzW3Ezr5A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=PV
	njRD7StArmNZCJz/ovC5T3H+x2rUiTPvE7OuI7tZw=; b=oaznZLubF/vpHKc8Ip
	7m7rvN3wYF2Y+AZhC1I/EfGuiO5IDqiBearkPZgGbPi/SYkVrKxiJt+rV/l2C/3i
	hkyO8hXrAawjnB5yO6ZQPXh7Znzssr6QYFqrN9s7UBbnVCgtMn5Kzj61B/67imdU
	Rqhq+yaTeNTY217rXJF9iPHSI=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3F3KWWHVqYovENw--.12045S2;
	Fri, 07 Aug 2026 12:01:28 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: david@kernel.org,
	brauner@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org,
	pfalcato@suse.de,
	viro@zeniv.linux.org.uk,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	mjguzik@gmail.com,
	ebiederm@xmission.com,
	jack@suse.cz,
	jlayton@kernel.org,
	chuck.lever@oracle.com,
	alex.aring@gmail.com,
	arnd@arndb.de,
	keescook@chromium.org,
	mcgrof@kernel.org,
	j.granados@samsung.com,
	allen.lkml@gmail.com
Cc: kuba@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Xin Zhao <jackzxcui1989@163.com>
Subject: [PATCH v7] coredump: Add bit 9 of coredump_filter for pre-exit files before dumping
Date: Fri,  7 Aug 2026 12:01:24 +0800
Message-Id: <20260807040124.1706927-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3F3KWWHVqYovENw--.12045S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3JF4fKw18Xw1UZrWDGr4DArb_yoWDGF43pF
	WrKay3KF48KF47tFZ7Ja17Xa4rJw4vgrWa9ry2gw43Ca15Aryxur4ft3W3XwnrAr9aka18
	XF4jqr9ru34qqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_byCDUUUUU=
X-Originating-IP: [124.77.128.89]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbCwBo0Pmp1WJr7LQAA3b
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0E6C04000B
X-Stat-Signature: fthor56gh1iydqya17i59ujnu57ut7ta
X-Rspam-User: 
X-HE-Tag: 1786075337-474868
X-HE-Meta: U2FsdGVkX1/euxeCs8QJfUDhL+DrJOnleoaRhryUwNQE7ltLuFWiQPQ0hVU/ZiMKagVg0BHs3Rl1hiUVk7mqZcTfDtGF5EwdAzCb0AiM2LnPFnQi4ALNZTZf63a4og5NgJpzbFoUsYWaxPfZlQvpA9xnMC7ywzcJ+o6FaqYdXeuWtYcrvixIe5YXFK6fP/zONfOVRUoUT9oh85kw4NjMt6eEZATHglJ7I/OayV4Uow3Stm1tmZ759/cWm6Q5NTLLLUbGkkGXhOad3X+Hf/Uvf8xbSrhLcl0vgu6ACptGNyJNOAcAdTvHO/zXnPTL1U/1KUeq3mhUTEQU8uhOCdS121o9wY7z+ITbmpNRir4Vv3ErqA5siVTLK7SGkdoX2mcfOSLE1BeK4nbownTUc3ObXsC3ezw8Y2NC5/accW5olrZox0FTGmDd6LaTUl1VSHJpZRjj+nnt2wjl/YfpyeVkSyDPItCWTG1cq5oic4IKYf1OWVBv1l7SBBF39J6vXi/uxusSrAvW+D3Udozp3+iULn/mU1DG987QXZ7gwkiZhH9EqOQgt8KP0twoxz7d1VYT6Cx//eJtfLoWGdzmj8G6gqj5SCMy5FDeAPjpNYOuap6xeaoWZ2WVqjGkON5uCBTDXnkA6gNtAOctMYp9aHtGdq/pst1Hkb6s4Gthx8mHFGVTKDtGOkdy9LIKapBlYY4NUCLMTNhujUTswz7yPFWSKNjNP2k3ELIJYAms+hTzDqdSzU3coEdtEc2j6vHUCyhGhvWxzc4BOxF1y9j6hlnuTt7yqpvWxz8taptX/9ACivsLfrlGtNKbEnRZgndYJne2K4KVWNJIDvIt/V+Qc7aFtPorwgRlpcRCWYBZasAuX750EyJk55xSAq44nPa6oQBnEcie/KATstXHMwWr8bjOdWDJO+GaD0q9u+ok1GXq6Z6wnuhzfj5bEyI1fmVe37/DFqhnZkN84eFlww6Clyo
 YG/MjRiy
 jZP47Bn/wk3lL751aWNBrx2PRYuW2S8bw4lMDY2/b3FM5sQsTKaAFM2khWdSzSAMGmAtP4yBut3ErO6HuVExJ3lRqcAzQ7/zTJM317/qsgBjva+O+8oq4UPnGMSEvLLIpTdR6HPX09kYvgHp9SaQB3X5eAiwfL0aO6R+1stC5vQdzoOWAtFHhHgapoaTSsP0HluHOGZgElba0uNU7ew5WUwChNpkkRcQd1wZakNVtBQfnW6G3JvBMsqqs1qk4TfHxzWV7ZvxtK4IFWCE4rThI96VKWyXROrkj43dh4NmFUQYTcynPjoY/Svl6hDTUE5Xh3UMCB0f43TVVHFtOC/towNquGsZ9EexqftZozo45+jbeDjnpTnIamWVxUymurQ6BUEUit1Yivz+EAP3eI9Pin45cbcwGILcap2JHBEfuzOgXpvbFFWH8lYGUYdifXZvBJyGQGzvCmUzNX4Sw2v5Tz7SZemc1+p5QmAor8U5auF1eUepfVB6vInx+nvIa22KTToxdgnDvfB958ziPnfrvcKrVPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A coredump typically takes seconds or even longer to complete. If we
happen to hold a write lock with flock just before triggering the
coredump, that write lock will not be released during the entire coredump
process. As a result, other processes attempting to acquire the same write
lock may experience significant delays. Another typical scenario is that
some custom management modules for shared memory also need to release the
reference counts of the related buffers as soon as possible, rather than
waiting until the coredump is complete.

Add a new bit(9) of coredump_filter to tag whether need to dump fd list.
We set it by default because tools like systemd-coredump go through the
fds. Some other coredump pipe programs like minicoredump do not use fds by
default. If you are sure that your coredump backend does not use the fds,
you can clear bit 9, which will allow some file resources without VMA
references to be released earlier.

In fput(), check FP_DUMPCORE task flags to NOT release file by task work,
otherwise file put operation will NOT execute util coredump finish.

Test Case One - flock
Test program send signal SIGABRT to the program which owns the flock,
output the wait time(unit ms) to successfully attach the flock.
Test program malloc 500MB heap and memset it.
If NOT set bit9 of coredump_filter, waitms is 11280.
If set bit9 of coredump_filter, waitms is 0.

Test Case Two - ion buffer
Test programs include ion buffer publisher and ion buffer subscriber.
Ion buffer publisher output the ion buffer hold_time if the subscriber
NOT send ack to publisher and NOT release it. The subscriber will trig
coredump by itself in some time.
If NOT set bit9 of subscriber coredump_filter, max hold_time is 19591ms.
If set bit9 of subscriber coredump_filter, max hold_time is 320ms.

Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
---

Change in v7:
- Fix description error in proc.rst. Since bit9 has been added, the
  supported memory types should now be 10,
  as suggested by David Hildenbrand (Arm).

Change in v6:
- Fix operator precedence in PF_KTHREAD/PF_DUMPCORE check.
- Link to v6: https://lore.kernel.org/all/20260804001703.1340667-1-jackzxcui1989@163.com/

Change in v5:
- Not add another bootargs for the feature,
  as suggested by Christian Brauner and Lorenzo Stoakes.
  Add bit9 of coredump_filter to tag whether need to dump fd list.
  Set bit9 to 1 as default.
- Al Viro, Christian Brauner and Lorenzo Stoakes point out so many
  problems of the code related to umap that was added in v4, delete all of
  it which is unnecessary. The management of reference counting for shared
  memory generally does not need to be released through the release
  operation of files that have VMA references. Traversing all the threads
  within the process and executing exit_files() is sufficient.
- Fulfill comments and commit log,
  as suggested by Pedro Falcato and Lorenzo Stoakes.
- Link to v5: https://lore.kernel.org/all/20260630075604.52533-1-jackzxcui1989@163.com/

Change in v4:
- Christian pointed out that the coredump process will traverse file
  descriptors (fd), so certain fds should not be closed by default.
  Rework the whole feature, add /proc/<pid>/coredump_pre_exit for user
  pre-exit resources selection, default is NOT pre-exit anything.
- Mateusz suggested that walking the fd table and release the file-lock is
  reasonable. No longer release all the fd(s). Based on user config, only
  the flock fd(s) and the fd(s) correspondent to file-backed shared memory
  will be released at most.
- Link to v4: https://lore.kernel.org/all/20260624145552.70143-1-jackzxcui1989@163.com/

Change in v3:
- Add comment and commit-log to explain why do the MMF_DUMP_MAPPED_SHARED
  mm_flags_test() check, note that memory mapped files keep their own
  separate references to the files. The case to work around is that early
  unlocking a flock on a file allows other processes to lock and modify
  the mapped data protected by the flock,
  as suggested by Pedro Falcato.
- Link to v3: https://lore.kernel.org/all/20260619122419.3954581-1-jackzxcui1989@163.com/

Change in v2:
- Get rid of the implement of adding new fcntl API, the issue does not
  worth inflicting the cost on everyone,
  as suggested by Al Viro.
- Call exit_files() in coredump_wait(),
  as suggested by Eric W. Biederman.
  Add MMF_DUMP_MAPPED_SHARED mm_flags_test() check to filter cases that
  need to dump file-backed shared memory.
- Link to v2: https://lore.kernel.org/lkml/20260618150301.3226517-1-jackzxcui1989@163.com/

v1:
- Link to v1: https://lore.kernel.org/all/20260618030700.2511668-1-jackzxcui1989@163.com/
---
 Documentation/filesystems/proc.rst | 16 +++++++++++++---
 fs/coredump.c                      | 21 +++++++++++++++++++++
 fs/file_table.c                    |  7 ++++++-
 include/linux/mm_types.h           |  6 ++++--
 4 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index db6167bef..0728ebd73 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1927,7 +1927,7 @@ will be dumped when the <pid> process is dumped. coredump_filter is a bitmask
 of memory types. If a bit of the bitmask is set, memory segments of the
 corresponding memory type are dumped, otherwise they are not dumped.
 
-The following 9 memory types are supported:
+The following 10 memory types are supported:
 
   - (bit 0) anonymous private memory
   - (bit 1) anonymous shared memory
@@ -1939,6 +1939,7 @@ The following 9 memory types are supported:
   - (bit 6) hugetlb shared memory
   - (bit 7) DAX private memory
   - (bit 8) DAX shared memory
+  - (bit 9) fd list
 
   Note that MMIO pages such as frame buffer are never dumped and vDSO pages
   are always dumped regardless of the bitmask status.
@@ -1946,13 +1947,22 @@ The following 9 memory types are supported:
   Note that bits 0-4 don't affect hugetlb or DAX memory. hugetlb memory is
   only affected by bit 5-6, and DAX is only affected by bits 7-8.
 
+  Note that bit 9 is set by default because tools like systemd-coredump go
+  through the fds. If you do not set bit 9, files that are not referenced by
+  any VMA are released before dumping core. Some file release logic, such as
+  exiting flock or releasing references to shared buffers is executed much
+  earlier.
+
+The default value of coredump_filter is 0x233; this means all anonymous memory
+segments, ELF header pages, hugetlb private memory and fd list are dumped.
+
 The default value of coredump_filter is 0x33; this means all anonymous memory
 segments, ELF header pages and hugetlb private memory are dumped.
 
 If you don't want to dump all shared memory segments attached to pid 1234,
-write 0x31 to the process's proc file::
+write 0x231 to the process's proc file::
 
-  $ echo 0x31 > /proc/1234/coredump_filter
+  $ echo 0x231 > /proc/1234/coredump_filter
 
 When a new process is created, the process inherits the bitmask status from its
 parent. It is useful to set up coredump_filter before the program runs.
diff --git a/fs/coredump.c b/fs/coredump.c
index bb6fdb1f4..ed4d30916 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -521,6 +521,25 @@ static int zap_threads(struct task_struct *tsk,
 	return nr;
 }
 
+/*
+ * If do not dump fd list, files that are not referenced by any VMA
+ * can be released before dumping core. Therefore, some file release
+ * logic, such as exiting flock or releasing references to shared
+ * buffers is executed much earlier. Note that do_coredump() often
+ * takes several seconds or even longer to execute.
+ */
+static void coredump_pre_exit(void)
+{
+	struct task_struct *tsk = current, *t;
+
+	if (mm_flags_test(MMF_DUMP_FD_LIST, tsk->mm))
+		return;
+
+	for_each_thread(tsk, t) {
+		exit_files(t);
+	}
+}
+
 static int coredump_wait(int exit_code, struct core_state *core_state)
 {
 	struct task_struct *tsk = current;
@@ -1124,6 +1143,8 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
 	if (cn->mask & COREDUMP_REJECT)
 		return;
 
+	coredump_pre_exit();
+
 	/* get us an unshared descriptor table; almost always a no-op */
 	/* The cell spufs coredump code reads the file descriptor tables */
 	if (unshare_files())
diff --git a/fs/file_table.c b/fs/file_table.c
index 16e52e7fc..6ed8ace8c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -566,7 +566,12 @@ static void __fput_deferred(struct file *file)
 		return;
 	}
 
-	if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
+	/*
+	 * coredump_pre_exit() may release files before dumping core.
+	 * Cannot use task_work in the case, needs to release files
+	 * earlier.
+	 */
+	if (likely(!in_interrupt() && !(task->flags & (PF_KTHREAD | PF_DUMPCORE)))) {
 		init_task_work(&file->f_task_work, ____fput);
 		if (!task_work_add(task, &file->f_task_work, TWA_RESUME))
 			return;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index c7db35be6..e865edb04 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1954,14 +1954,16 @@ enum {
 #define MMF_DUMP_HUGETLB_SHARED  8
 #define MMF_DUMP_DAX_PRIVATE	9
 #define MMF_DUMP_DAX_SHARED	10
+#define MMF_DUMP_FD_LIST	11
 
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	9
+#define MMF_DUMP_FILTER_BITS	10
 #define MMF_DUMP_FILTER_MASK \
 	((BIT(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
 	(BIT(MMF_DUMP_ANON_PRIVATE) | BIT(MMF_DUMP_ANON_SHARED) | \
-	 BIT(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
+	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF |\
+	 (1 << MMF_DUMP_FD_LIST))
 
 #ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
 # define MMF_DUMP_MASK_DEFAULT_ELF	BIT(MMF_DUMP_ELF_HEADERS)
-- 
2.34.1


