Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 919D3C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 05:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259BA6B009D; Sat,  8 Aug 2026 01:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3B66B009E; Sat,  8 Aug 2026 01:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ACE86B009F; Sat,  8 Aug 2026 01:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C92EB6B009D
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:29:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB4E2402A3
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:29:20 +0000 (UTC)
X-FDA: 85076974080.25.688B56C
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf07.hostedemail.com (Postfix) with ESMTP id E2AC840004
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:29:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=K1xFQ53c;
	spf=pass (imf07.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786166959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MVWyRhCAo897v8yroJFlAwEgt8VNOn3IAKiyIXp1hM0=;
	b=MpqQiDGKDalPvF/y14qScXHatDI2VZK9XzX6A5GIs2U6KwZ8T43pJCVmIcyTD781NFrhGQ
	Y2CF/wB6OelH9ahsbYXTq7TRrUBft8xuwBaq332Q5hKcVh/CnA85tcjVbHFgd+kJmMuv2s
	gtml4GGIPHTv03HipeFBPKYSUh1y9hs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786166959;
	b=trJdWfV5ukVKP5acJotPi1VMoalsbTSOZqzkRMPeKWiWoTiQ+dGZPnBG1Ho8VaBeL5nFgR
	3jT1jMcj9vx3COxYrJpN9MV3iM2oNVj/9/mlL3gUERkX2dUIRKl+6roAsA6y2vMSyus67X
	OIjlepcFOUdpYCf0pXdcf4aJ83VQOmk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=K1xFQ53c;
	spf=pass (imf07.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=MV
	WyRhCAo897v8yroJFlAwEgt8VNOn3IAKiyIXp1hM0=; b=K1xFQ53cbPvPZB2EWP
	I8k8nUAPNisLbyh3tgwi8DRojxxGqG27Fl312b+LhH9YvhL3zL+IZ+cz9TKZ0L+k
	tnCpDp1DIRU4CsU2AdBFtxppXjpGDbghhRcOgOD2eiqLC7Cz9rMuzU7MscLXWiie
	1iOHf6+hi7S+dtZE/FLjwuzpY=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDn30JGvnZqhCwgNw--.871S2;
	Sat, 08 Aug 2026 13:27:36 +0800 (CST)
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
	allen.lkml@gmail.com,
	rdunlap@infradead.org
Cc: kuba@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Xin Zhao <jackzxcui1989@163.com>
Subject: [PATCH v8] coredump: Add bit 9 of coredump_filter for pre-exit files before dumping
Date: Sat,  8 Aug 2026 13:27:32 +0800
Message-Id: <20260808052732.2589657-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn30JGvnZqhCwgNw--.871S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Kw4rCFyxZw1fXry5Kw1Dtrb_yoWDWF48pF
	WrKay3KF48KF47tFZ7Ja17X3WrJwsYgrWa9ry2gw43Aa15Aryxur4ft3W3W3WDAr9aka18
	XF4jqr9ru34qqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEa9akUUUUU=
X-Originating-IP: [124.77.128.89]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbCvwr5BGp2vkrAYgAA3C
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2AC840004
X-Stat-Signature: bowscixqy7crwguqg3rif4wuswftw53x
X-Rspam-User: 
X-HE-Tag: 1786166955-11033
X-HE-Meta: U2FsdGVkX18Y4CwaFqOCVl6CrI67+FNtUu214FQdByx935MD2carOQAd8J7MQRw0Ia5SN/t6MUEMEswPdn13rcY10OemJ4MfFmpOLoi9U8hVNSiA5xnzGOVEue8yGY+4i/VJlsgJ9/sbk1oEEgukCi36inzBgQw2xglvjFSpyuAolYG/7bncj5Ngf+1KpZKG/AP2ZPIc0CJZQ9u2h00MTGtXxGOERkPFA1Nxn/ZNmBfc9+ZPrk0kWfqQ2qbdf1/ii7Oho43iWMWDrn0XMLyf9K3sJVD7ML1tGsCDL6pmtcNMZg7c8lXwJ9OyGHFhIKNyQCFczGGabGcIz/xo3MZgcE70LvZT1q5DMpnCL1tr3QpYCCjv9SyxaUSl9k2zBLS7H/H3M6n7sGVU34aGrSP5lLDgGN9wGv5GO3GE1TTHAQp1VQeAxkm1wzMQNxYEmEqAvYSRdR2Wtufe7ZuqNYbP0sHQhhahSEZTwdQd6DO0LMFyLGrSn6o2VRLD5Um5riH8R99V5uEUIwodMHVWG2QHXZ5SxjEs43W/D/0cEOT7XhHTFNFpHd0/hsmlHu07yvJB6w+l2saNBRQIuLjdvnkdsh0Sldspe10rRL4F0cxN3QxEeauKH+VHa2C5gXSTTTR9kNfktnoYnyrnDdBTh9ofwp8xqgsBQqYD++YrqjlDUTOkuHacQoOzDxm36RYMWIjnmq3comy+fmpD/zMnwNkZLUn5a7jA4vFNK2hKzm3bHsV628zgJLPk6UNucI2x2Ccz4FEF/PZ1RDAU/LZByyyNhWAYmXjTfYUZUP1kOdVpgcrUYk6KYY/lJRmPgdOF4QZcvIUaTcR03hDdmbgFVhpd24HGPkGMh7gd+OntLUM7ss1oizSK/KeTmYwltj/5hNUESF6IOUoqcWWd71JxvXewQpKkvdJ2uItDNkGVYhU4Rg3LFMYt6Y3cHi7M3mX/ZJ9AiOUCmlprhjzLTnb7X8w
 urErOWSS
 96WqJdQ93hHm0TD3GDuaEscMS5fhJTBkuq4xjGpjtK1ZPIdZeLwX+TEgKMvmQQHROk7RbpcqIFGWi+Qz2NULeRy/54qo+Ce4cqQ6vQmbz9antGA5xB/kFVp600Dih5P1mmlYBAwo4UZ4zuhkpy9LgwNArAriU9CWgZfzSM020InxmJyTP8NdpIEsiRe4tGLnlHBo1hYXIQY+8Jq3tZobDSBe0YHOBW1yaU9Xr/dSxLCy8GzGU20zoYkRhBLCpqqC/ipmiQFUYdQFdHDRqrte5gEXyn15pyApi1wcj44577FggYUdlVNzI3EjUN3DXoHZm+86VBEmKMz5D4NE0b2XzWHn6axZhX5enVC/AFy1EsNNpVRb5NzzBZF5tTly7S9UNS6q2JEQH/QNrpfXvlTLYCKQPHylOjaGI/GXxLBghQbAytC0SpfkRdLetdmoSMO102dCUvtaTywrgwtvGYIbn84fDNMQ3giSDR7m1yByROgfmsu5TRKIvnV6yR7AtFj+xfcfoaxOS0AaaxWAMkpatBIKrbA==
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

Change in v8:
- Delete the duplicate description of default value of coredump_filter in
  proc.rst, as suggested by Randy Dunlap.

Change in v7:
- Fix description error in proc.rst. Since bit9 has been added, the
  supported memory types should now be 10,
  as suggested by David Hildenbrand (Arm).
- Link to v7: https://lore.kernel.org/all/20260807040124.1706927-1-jackzxcui1989@163.com/

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
 Documentation/filesystems/proc.rst | 17 ++++++++++++-----
 fs/coredump.c                      | 21 +++++++++++++++++++++
 fs/file_table.c                    |  7 ++++++-
 include/linux/mm_types.h           |  6 ++++--
 4 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index db6167bef..aee03858b 100644
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
@@ -1946,13 +1947,19 @@ The following 9 memory types are supported:
   Note that bits 0-4 don't affect hugetlb or DAX memory. hugetlb memory is
   only affected by bit 5-6, and DAX is only affected by bits 7-8.
 
-The default value of coredump_filter is 0x33; this means all anonymous memory
-segments, ELF header pages and hugetlb private memory are dumped.
+  Note that bit 9 is set by default because tools like systemd-coredump go
+  through the fds. If you do not set bit 9, files that are not referenced by
+  any VMA are released before dumping core. Some file release logic, such as
+  exiting flock or releasing references to shared buffers is executed much
+  earlier.
+
+The default value of coredump_filter is 0x233; this means all anonymous memory
+segments, ELF header pages, hugetlb private memory and fd list are dumped.
 
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


