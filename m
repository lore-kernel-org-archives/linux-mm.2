Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E0DC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E948E000C; Thu,  7 Aug 2025 08:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75E78E0001; Thu,  7 Aug 2025 08:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69F98E000C; Thu,  7 Aug 2025 08:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 964948E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:15:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DCEA16071E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:25 +0000 (UTC)
X-FDA: 83749856610.13.1BCF0A1
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 797FFC0011
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568923; a=rsa-sha256;
	cv=none;
	b=GdZ0OtTYZ1YxwVtpwnzJcvlwewErwMORJHUoN/34uJ9WECJwEFC3bBIE00X2gnHFZ9GmDh
	VE7jaDnFQO7yG5WEM+faSQiufVNVJ3XFVExmss8LDVtyYJ3A9Q6t3SRQIgeKqBVoG1asRc
	ceV+/JeJz8ibDCgrkwpsEadHS9Nbj64=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Or3w4D6rXYHVhch1V7pTwUYddAAer7OgPyQwnULbc1M=;
	b=UnO3bAg0I04fq0uhRGS1AIs2vC4FS6lVTVObwda3e7eFO3XXJ2iQ6PeqdaLJTOmt9vANjH
	UnsZoxm4/iAAAGAdKzLYpbBV/2DyFizHZwdTP6t5XKDgJxCHIew06BIl0TBL9hHymHp/No
	s5yK1rL+ToPiUkJbJAkZspk88kRfOYM=
X-UUID: 2dda5884738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:c9f6a6e8-399a-490e-8347-7d1f4825cb24,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:6169b3659762d4f1f45ccf9d34c3b578,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 2dda5884738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1235472273; Thu, 07 Aug 2025 20:15:17 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 93F64E01A758;
	Thu,  7 Aug 2025 20:15:16 +0800 (CST)
X-ns-mid: postfix-689498D4-37051772
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 07760E0000B0;
	Thu,  7 Aug 2025 20:15:12 +0800 (CST)
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
To: "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>,
	pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>,
	xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [RFC PATCH v1 9/9] proc: Add /proc/<pid>/freeze_priority interface
Date: Thu,  7 Aug 2025 20:14:18 +0800
Message-Id: <20250807121418.139765-10-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 797FFC0011
X-Stat-Signature: w1w7osjmm34wrukkaqdzrtg74x8kbc7m
X-Rspam-User: 
X-HE-Tag: 1754568922-836858
X-HE-Meta: U2FsdGVkX1/bOVB83j+sCzV3I26AZfwaxBBOz7/2brb5DeLUVcmy8UwtNP/MpObu+nXrWPzm0ugPcmKZSVu1HLdiv6XgYUxSOIp1UX4VhgrXgdq9CesqG5QptVjreuainOEtUQAFFqxAJbLlEN4eMdv/iwYDxkUjo2fW9l7L245eEAEUUKpVdVdBl3P211vqsHwBkosLzXEk81jU+b0/0GM48fSW4TweMfHzxZUNwaFq8I+VWh3JPfxMcHMygvguOYvIekTbvYfwts96MZUYFJiwCpUy0NbraKLX55BvB1Aq75F4vgwz9CVurOY2XrnozpLL5otk5n31fTkqXYRq22qJftPD2QQxIoSepdf3CuXDUG2u/qGGV1iLsdpzlaE+fGNcp7upVtQUnn4FEqHOcMSdCYzE8Ep5r+uusE7SaqE5E3zInUvXMKRIayp2Zs6b72l5hYCAyI9/U79lTxYq3W3tIF5Iqc0OVFU8Fbjgus23fQhJUCk1HLdrgivVrfCvK2fEBGdi4tVHYuKhl0cb2y8bOb+mLcL9Xc9GnKqFyrNEWVQqZvpQS2i1JjfTLEc5uSeRpCo3/Ib6szUFH07eElVtvFv64kccVHRUG1S3OEj3A0RZEn2eLh2kXlChMMQVnE3NiYligOZjEOvTp6B3WcXHow9TjZwWhFrum3Mkpx5IjA9tpbIzjsNE9kpRXIFrhaD3OHx3R7PVDwsFxyNNGT4Fz4zZ9uhMV2PXyO1Vh7l1qTTmeQswoEC+kK4v5zYLDgzdAdHEf6hC66wVYlYRCWj7NZsdLGGMA4LQiCCni2frgarOEEWIj5AcVb7HXPaxIAnO7r+e6ZQZBBoel9nKdn7YvIUXS1UNdb2+x3OOjFTw9E5Tnh/NzvR5N1fItCTVeoftl6HpCKrMYecRVmiKhFFXFNnu/k7fqALyIXPdLlqg1dnqP6ZLyVguUxLk4yvGc2pVLfc2NutbCXYFOy4
 3942mJ4t
 jl/469nqgpwemsLeCELzWeyz9DxiR7KKAtKB35Z36UHeI/nnOWvDLtMLGis/BIcPQNtdQoh5mEDUgErhtkH47wiVpRhAjkZMnvJMRrs1B9eOHWQaUk69c/HACq3FFQ00Dd3RilWsylpQURDSUb1HdwJUXzvWinD3NX7kd02Ix60YhFqn7KgJffNME3G2PmDxJgJtB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces a new proc file `/proc/[pid]/freeze_priority`
that allows reading and writing the freeze priority of a task.

This is useful for  process freezing mechanisms that wish to prioritize
which tasks to freeze first during suspend or hibernation.

To avoid misuse and for system integrity, userspace is not permitted to
assign the `FREEZE_PRIORITY_NEVER` level to any task.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 Documentation/filesystems/proc.rst | 14 ++++++-
 fs/proc/base.c                     | 64 ++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesyste=
ms/proc.rst
index 2971551b7235..4b7bc695b249 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -48,7 +48,8 @@ fixes/update part 1.1  Stefani Seibold <stefani@seibold=
.net>    June 9 2009
   3.11	/proc/<pid>/patch_state - Livepatch patch operation state
   3.12	/proc/<pid>/arch_status - Task architecture specific information
   3.13  /proc/<pid>/fd - List of symlinks to open files
-  3.14  /proc/<pid/ksm_stat - Information about the process's ksm status=
.
+  3.14  /proc/<pid>/ksm_stat - Information about the process's ksm statu=
s
+  3.15  /proc/<pid>/freeze_priority - Information about freeze_priority.
=20
   4	Configuring procfs
   4.1	Mount options
@@ -2349,6 +2350,17 @@ applicable to KSM.
 More information about KSM can be found in
 Documentation/admin-guide/mm/ksm.rst.
=20
+3.15	/proc/<pid>/freeze_priority - Information about freeze_priority
+-----------------------------------------------------------------------
+This file exposes the `freeze_priority` value of a given task.
+
+The freezer subsystem uses `freeze_priority` to determine the order
+in which tasks are frozen during suspend/hibernate. Tasks with
+lower values are frozen earlier. Higher values defer the task to
+later freeze rounds.
+
+Writing a value to this file allows user space to adjust the
+priority of the task in the freezer traversal.
=20
 Chapter 4: Configuring procfs
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 62d35631ba8c..724145356128 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -86,6 +86,7 @@
 #include <linux/user_namespace.h>
 #include <linux/fs_parser.h>
 #include <linux/fs_struct.h>
+#include <linux/freezer.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
@@ -3290,6 +3291,66 @@ static int proc_pid_ksm_stat(struct seq_file *m, s=
truct pid_namespace *ns,
 }
 #endif /* CONFIG_KSM */
=20
+#ifdef CONFIG_FREEZER
+static int freeze_priority_show(struct seq_file *m, void *v)
+{
+	struct inode *inode =3D m->private;
+	struct task_struct *p;
+
+	p =3D get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	task_lock(p);
+	seq_printf(m, "%u\n", p->freeze_priority);
+	task_unlock(p);
+
+	put_task_struct(p);
+
+	return 0;
+}
+
+static ssize_t freeze_priority_write(struct file *file, const char __use=
r *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct inode *inode =3D file_inode(file);
+	struct task_struct *p;
+	u64 freeze_priority;
+	int err;
+
+	err =3D kstrtoull_from_user(buf, count, 10, &freeze_priority);
+	if (err < 0)
+		return err;
+
+	if (freeze_priority >=3D FREEZE_PRIORITY_NEVER)
+		return -EINVAL;
+
+	p =3D get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	task_lock(p);
+	p->freeze_priority =3D freeze_priority;
+	task_unlock(p);
+
+	put_task_struct(p);
+	return count;
+}
+
+static int freeze_priority_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, freeze_priority_show, inode);
+}
+
+static const struct file_operations proc_pid_freeze_priority =3D {
+	.open		=3D freeze_priority_open,
+	.read		=3D seq_read,
+	.write		=3D freeze_priority_write,
+	.llseek		=3D seq_lseek,
+	.release	=3D single_release,
+};
+#endif /* CONFIG_FREEZER */
+
 #ifdef CONFIG_KSTACK_ERASE_METRICS
 static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns=
,
 				struct pid *pid, struct task_struct *task)
@@ -3407,6 +3468,9 @@ static const struct pid_entry tgid_base_stuff[] =3D=
 {
 	REG("timers",	  S_IRUGO, proc_timers_operations),
 #endif
 	REG("timerslack_ns", S_IRUGO|S_IWUGO, proc_pid_set_timerslack_ns_operat=
ions),
+#ifdef CONFIG_FREEZER
+	REG("freeze_priority",  S_IRUGO|S_IWUSR, proc_pid_freeze_priority),
+#endif
 #ifdef CONFIG_LIVEPATCH
 	ONE("patch_state",  S_IRUSR, proc_pid_patch_state),
 #endif
--=20
2.25.1


