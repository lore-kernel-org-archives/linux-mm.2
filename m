Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929E8606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Biz/pg0z
Received: by kanga.kvack.org (Postfix)
	id AF53D6B0649; Tue, 24 Nov 2026 03:50:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD526B064B; Tue, 24 Nov 2026 03:50:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09DB6B064C; Tue, 24 Nov 2026 03:50:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7226B0649
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:50:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C00E40B08
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:50:42 +0000 (UTC)
X-FDA: 85469391924.28.09551E0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf31.hostedemail.com (Postfix) with ESMTP id A685120004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:50:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Biz/pg0z";
	spf=pass (imf31.hostedemail.com: domain of xiange.pi@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiange.pi@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795510240;
	b=72zvza3QzpJ03JVSJr2Xks96PPoDHSKQLubNkBvePVrv9Cr6M7ddekVNDdpy8KgcEFevfz
	xd/sDUM6S9vepE9GSpG+mS0HM/oqkXWtKB+e7+lWLz31iFQXUv3y8yt5eEAH5G23IQQUs6
	SMdT9N2beCFD8y4eIG8sulcmYwx1Ncs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795510240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pZxSNV99eQQD7nI0RHK3EiKTCxoH4Q/YUIR/xnmC9yM=;
	b=Rflw3bujCRvJenmbowJfM5et5VDP07YJgI9E7ilLq2XUG8E5WytfrkqZgoi0d3VAyjUydE
	4s2QF3wlCmJUCQXs59kjqsmrlyKpyKsqf80n7O+RcGv6BTu3KAvbNnlz8bC5j3dmUu2pUU
	pcz+qjWJvSt4XzacDe2qaNw52GPHC/w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Biz/pg0z";
	spf=pass (imf31.hostedemail.com: domain of xiange.pi@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiange.pi@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795510239; x=1827046239;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1fRo1a0dLF78exZbhSV0DUhDGiKNw/pnDJfveyQyjwE=;
  b=Biz/pg0zXhr0rqvxPk70aC09U5BQGC2qXZp1SO14lVnJ6JWwgjUHj3dt
   VndP/txLFUfDHYCOU0VcTDW+Ks/wWluW26YilDtMxET6J+W690zTzOdL9
   PcxQCAAIACDt8SXAG9gs9FcpDPxBiRXPNA8/3tvKRKsHX1Swv4UGV1F7V
   IbDvhjNyuEyimt/8BfYEsMLZABALyVrSM+cu+U2/kcLMtkopx1YamNKXa
   qp6ntOyCisUwHgZTXxkgDTLLg8HxVdA42eMGntDlPPPF6HdgpEoEXLAKh
   JtYhApbiG9MhS5yswfR95Vl90BjUCifo1IfYiABG8ff9SqatJU4IouNG0
   Q==;
X-CSE-ConnectionGUID: R3Dmu4vLSVqOfXQbH4lOZw==
X-CSE-MsgGUID: 8bZ0ObsVQmmGdPSMc8xB6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="4377198"
X-IronPort-AV: E=Sophos;i="6.27,230,1787036400"; 
   d="scan'208";a="4377198"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 00:46:36 -0800
X-CSE-ConnectionGUID: Leh/wT4iSS2fbKldD79aCQ==
X-CSE-MsgGUID: qYBeCo/5QjSHPyzSn0XYww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,230,1787036400"; 
   d="scan'208";a="11892453"
Received: from ubu2204-pxg.bj.intel.com ([10.238.152.105])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 00:46:34 -0800
From: Xiange Pi <xiange.pi@intel.com>
To: Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] exec: annotate lockless tsk->comm update with data_race()
Date: Tue, 24 Nov 2026 16:38:48 +0800
Message-Id: <20261124083848.1430527-1-xiange.pi@intel.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ctdbjjsigh5qt3q73mzpo1sfej33e161
X-Rspam-User:
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A685120004
X-HE-Tag: 1795510238-869126
X-HE-Meta: U2FsdGVkX1/3YMsf9bn00kBxUhM1yF3zgkjlK8Ki0J8g+7O3hnhXkSRABfQXjmlvDCzA1kbYUC45UZFxUqHNjTu2PuPGr7s8JcnOSHbI1qH1uXG4gjSNVC5tor+a24xWmp6dCRP8Jsl1NvR2QuayN0rzcvbK02rpJOCXjOOmwabnCWJowjn0ZvbOSI5lLtOxOPi/7B4MzgWx0YIR8n3EFPX+xJEryUVa9VmGEVmBQ9Q/3SpMcxUVfAn+fNA8udReDKJa59yPz4HN2aUyipfXrRWSWdshaw+So4MDT0RojQOEgb5tisL93V17W4hHXDeWYS+WGhtFd0MfFdwGc2khC4uQUwB7eAER+P1CpHKugle5vYhWtB8zhZyDEXBVSBsVCoLZ9tHEtrTWtuJP/hSAb38ZTagWfi2YExYjEDjyaQJZX5sA2vuKYVvecN1Q/C+DxU4q1TDFHlUo2asfddJANLfe4B7TlsKyWCsfiEl+FfI+aZ28lDCc8cUY7j+jUdrwOeSskTjp6OiTY2EsUme+exzLiKn4OwTYuNiuXg+7G7944GkEugN611/SQyjb8ioKMmwG9WKDCGZqwzXciRtCFR9IlkjMHxyeW22e3T5yb8qhJhr2/fLnTkKP1Jvha6HRvTstarFBjwO1w2A8+7YERfDTy86YBY4tz6YaJn8LWytECXE/APtUasXReAwcElDaD7PQ0YG3nmhk7aj5bI0yqmxyb27GB9aYoniTDooyz0MPcOWUUKFXLHPmaO8KLPlUBKg3tJiF9ZPsfNfiKq17KYMz1/ObhFxsgbdNYiogCh7h+Iov7q4sAHuNwo/td3nc8ZRfBbH5VrPbbiCA+pmIoZ9JeDhD0aDGKDSDt0ZyfvDzCekZvJ5rR8/ufeRd0qOO35ICuPsZPF22TfegPrAber8KQzGdDxq4zey8KtGbq9X5ODcSudVwE77+PWzMi665pxR2Mmg2MDi6EYKwaOG
 VLIdxMTr
 Pc4woK506ZjvePfpnXt5y0szGJ5yqZPPLEacqE8PB7C43/oFVAtmiZDqVTPAj8DYldbl7yxsrJf1PaXGVlaBu+pwNF6C9t6ZXw4jO4sXtrqzRHLc0WvYUoHQW3szil4Qm4sogThOvfZ9s2opzT3TyvheASkjozDi62BkvRBvWBbo4+DAZDQhDig9MPY3o+zCVrjeNaDM/pxy4FkASTUu4d0jVDjBH7F4jDoRb9gX5deBeMvtlwPkBpTTU9Il72dxbhlLsJBmA0eb93gvs79U4O4PGc+ptMqjRVFJYvVOShb+0RtITGmJOvGUkoltopHXRDoyJ7kHmzkneBvFbmRbrG0TQ7PJyRr3afonklKB6FhQ/SJkuMeUxtHPrOoT5qZm411a1nWg+VLyjMJeok8TsvEMxnejK/4ZxzTmoPDAkzUwhIG9fWPSx/1Q1fZKzS3rg3vpFt3yIUeVtbyqQ28eSu65JM4abJuJk7IknW/dBuLmSdKAs8mRcMaSDHiw1Ha1RzIwF65LRCHfoxn2a2X54iWbc1lsQyYusCe/4C9QMdOw56qgYgMG8iDyDoDXUDK41/eN9xg7QRC7DaVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KCSAN reports a data race between prctl(PR_SET_NAME) and a lockless
reader of tsk->comm such as the sched_stat_runtime tracepoint:

 BUG: KCSAN: data-race in __set_task_comm / strlen

 read to 0xffff88800d1787d8 of 1 bytes by task 3929 on cpu 1:
  strlen+0x19/0x40
  trace_event_raw_event_sched_stat_runtime+0x5a/0x150
  update_se+0x14f/0x3b0
  ...
 write to 0xffff88800d1787d8 of 10 bytes by task 3417 on cpu 0:
  __set_task_comm+0x78/0x180
  __se_sys_prctl+0xcb3/0x13b0

The race is benign by design: since commit 3a3f61ce5e0b ("exec: Make
sure task->comm is always NUL-terminated") the last byte of comm is
never overwritten with a non-NUL value, so lockless readers see at worst
a mix of old and new name. Annotate the writes in __set_task_comm()
with data_race() to tell KCSAN that the lockless access is intentional.
As nearly all updates of comm go through this function, this covers the
lockless readers without having to annotate each of them.

Reported-by: syzbot+98baf51f5cc36dcbe2f7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=98baf51f5cc36dcbe2f7
Signed-off-by: Xiange Pi <xiange.pi@intel.com>
---
Test environment:
  - Baseline: torvalds/linux.git (git://git.kernel.org/pub/scm/linux/
    kernel/git/torvalds/linux.git) commit fc1c25014ff8, with and
    without this patch
  - Kernel config: the .config provided on the syzbot bug page
    (CONFIG_KCSAN=y)
  - Method: QEMU guest, running syz-execprog and syz-executor with the
    reproducer in the background, plus a script that enables the
    sched_stat_runtime tracepoint
  - Without the patch: "KCSAN: data-race in __set_task_comm / strlen"
    reproduced in every run
  - With the patch: not reproduced in 10 out of 10 runs

 fs/exec.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a5269b5e00df..4b03bb2fcb95 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1100,8 +1100,16 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 	size_t len = strnlen(buf, sizeof(tsk->comm) - 1);
 
 	trace_task_rename(tsk, buf);
-	memcpy(tsk->comm, buf, len);
-	memset(&tsk->comm[len], 0, sizeof(tsk->comm) - len);
+	/*
+	 * tsk->comm is read locklessly by many users (e.g. tracepoints,
+	 * printk). comm[TASK_COMM_LEN - 1] is never written with a non-NUL
+	 * byte, so concurrent readers see a bounded, NUL-terminated string;
+	 * at worst a mix of the old and new name. Mark the update as
+	 * intentionally racy.
+	 */
+	data_race(memcpy(tsk->comm, buf, len));
+	/* Same as above: lockless readers tolerate a partially updated comm. */
+	data_race(memset(&tsk->comm[len], 0, sizeof(tsk->comm) - len));
 	perf_event_comm(tsk, exec);
 }
 
-- 
2.43.0


