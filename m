Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09132606A881
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=He/O1Yy/
Received: by kanga.kvack.org (Postfix)
	id C739C6B05B8; Tue, 17 Nov 2026 00:08:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24166B05B9; Tue, 17 Nov 2026 00:08:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC356B05BA; Tue, 17 Nov 2026 00:08:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD1F6B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:08:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D87E11202C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:08:56 +0000 (UTC)
X-FDA: 85443431472.22.AC93C4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3F55540003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:08:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="He/O1Yy/";
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glmqSz2x+APivEM/vonQfanbbokAEU7WMuncz0VaekQ=;
	b=o9Yewk11fF23BeTYpqDxjrXGhmGdsOaQVzyBpYrYvdNKAOLilWP4dEGQVWl3MmJNt+sm+/
	sxaMyClwf4Ie3oAZh8OKydHBT+EoSxIZvcVV6+1gENqtBaPYVXp1q51rYSNl93WZOj37w2
	Gb8vcGTz0ZVw42thRZ32AJXXJsDVObo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892134;
	b=XII5gLjdD+E3eqdWMYca5XI9Enrprc4XBpGOiFiN/6oMyQrriluanl/6Bus6GMnj/qQOkN
	cqRbzhp73cwWaIrgZaUyxVFKIAjYMGfvtSRq2bF1JM4vIw3yKJZcL2OvOBFY6i4ur2IswF
	YbYIWkPUvN/mSccJxJ7OZkWyAZb0ASM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="He/O1Yy/";
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 7EC3B60148;
	Tue, 17 Nov 2026 05:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 805E41F000D0;
	Tue, 17 Nov 2026 05:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892133;
	bh=glmqSz2x+APivEM/vonQfanbbokAEU7WMuncz0VaekQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=He/O1Yy/L1j4ZozAOzPbkeszipcs7RRuCmyVSYaTq1BV8Vc4qKurtvkhGG1pB/OlG
	 mLeqBxCxgNnmeuDokGWvChBtutsb91igoC8oLr9iLqqT/dJd04LRFqoLY8w+cyu8UA
	 eAmMHro8YjtWx+oxikakHiHu5BTsPyM4LEE5/rhTqB8ZWmorfH1b1NDRdwkhc6ErHM
	 zB0SW7daDGcT4TAv4MrjBiu+fV5epwkyhapDN/tIkFi4FLBSgnxlmHWkE9sSzIdHb2
	 ASadzctJObrLmyKpZo7ANrbXur2n+ApSLe5h9eMVHrMcXamrWisU+qB4q40/TcjWqn
	 iw2iC7INnWbVg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 01/13] nsproxy: Pass nsproxy to create_new_namespaces()
Date: Tue, 17 Nov 2026 07:08:29 +0200
Message-ID: <20261117050841.3289652-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r8ch5u5ok5sgaytrhthu1kqkkwbwhoyt
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F55540003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794892134-247807
X-HE-Meta: U2FsdGVkX18qMdhb31TNU3uGgMcAXvPH+XcXJrFKEh9kAJRxDjfFyKyuQr+QGbfKPqZOYkmIJBWRTCo0B4d1wIqUJMGbzM13phw+gFDzRl4x5T5CEkVX4Y4ynnfFtcsED4xc+OZzEpMLWdvRhhaAFndK1+02qiywtd8IrBC6osF1Rl2bvtnGNajsmNzUtcEZtf/9kUXofptSp8XBPLZwFD9ZXcFImrgA0Keb/IVmyRMICB23XIs2ntZGt9qT/TKIgk7ZjqhCrN/QDyZMMvDAqzdBvEskP6jQ/fasogQJO44dxq1LR3wpI49i/PC1fLWVWxvYyQr7aDtwXdme6RoqNLjmhGB8fg/evTKPAKPLOh7A34Twbk8AaFwAM5BsohHPXNyrFbrtIb2JNhXTlUmUGlAIcWMlbCZk1qOwFh1UWm/ETN4vjnHAqUxsYPp22+zcoNYz7nkWQkdce02QoOoz+OhBelXZTbSdPJpxWrq9m+o1CEXsRG64IFvZsh1GONpn1A5q1Bdy1G5pQgo1SnylXbkRnPFp7OsygGJcfk+4cxsdEA9d2Shihr+X5CdUrUXRRz/OaxGmy/Kn0+5jLX1ZKY0a1uEFzHXAbsOL+lqCsvRdmRy0FRfX8Amm4z5Mk4eB1wz9I0OpFmsBrNBckqZK7piu+HaQ1dzK8pjo5PQ47wzMpYRg6dbrlzYZ0xv6RU3QE1qwQ0CLV8C3KsKuJAV2fpae9Kpn2TiKNsNfyGRjmCQE2MsZFuvNtiQIV0IZFKLv9u7UxmeDpLU58aQUnUkuoPkkdNX6o8aVTRZpjVrPpT9dphmiCLoNsyMU1PiQw/fr4jxApmBsgg7L8+ugUrV0lokJE8UZgofAfOkT2k899sp+najZP4iqb6FtWV4PQegzB/ezpBJFO4hp2r0rRvNpx33fL9ehyl8bx9+zcl0sS8d4R5F3nou/xD6cQGrnofISCdHg4eErR5ardgFchPo
 73GwGuO5
 bsBWY31wT+4H+ylcwzipr/OR18g0635b1MWnVqkC034ZaeK8KPmcywaAmc+cZS6+mpaRlflqEo1Q9f7NZL2t5cAtIA+etpzmE6JMOY2kC1UfKVv0uMy1DyMQ+HcVK1RQSHxkNhPg0y0IawnSdQc6iGXmFTKHdmiEkepUzcWjN476lvHnQd7tpVMN9DfRZm7BLm8U58AshiD9Za3noaA0zepAUp+qDMkbMUmkzR35xkjfB9EF7ADUrNQWDUtJnNzVjFM7hNq07zW7gKfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

create_new_namespaces() takes a struct task_struct pointer even though
it only reads tsk->nsproxy, preventing callers outside kernel/nsproxy.c
from constructing a child nsproxy without mutating a task.

Expose create_new_namespaces() and pass the source struct nsproxy
pointer directly so root namespace creation can allocate a detached
namespace set from current->nsproxy.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/nsproxy.h |  5 +++++
 kernel/nsproxy.c        | 32 ++++++++++++++++----------------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index dc2447f5f092..cacbbbe3f1ce 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -12,6 +12,7 @@ struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
 struct fs_struct;
+struct user_namespace;
 
 /*
  * A structure to contain pointers to all per-process
@@ -92,6 +93,10 @@ static inline struct cred *nsset_cred(struct nsset *set)
  *
  */
 
+struct nsproxy *create_new_namespaces(u64 flags,
+				      struct nsproxy *ns,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs);
 int copy_namespaces(u64 flags, struct task_struct *tsk);
 void switch_cred_namespaces(const struct cred *old, const struct cred *new);
 void exit_nsproxy_namespaces(struct task_struct *tsk);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 2dcf105e8ee2..8a3c6d4e94e2 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -85,9 +85,10 @@ void deactivate_nsproxy(struct nsproxy *ns)
  * Return the newly created nsproxy.  Do not attach this to the task,
  * leave it to the caller to do proper locking and attach it to task.
  */
-static struct nsproxy *create_new_namespaces(u64 flags,
-	struct task_struct *tsk, struct user_namespace *user_ns,
-	struct fs_struct *new_fs)
+struct nsproxy *create_new_namespaces(u64 flags,
+				      struct nsproxy *ns,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs)
 {
 	struct nsproxy *new_nsp;
 	int err;
@@ -96,52 +97,51 @@ static struct nsproxy *create_new_namespaces(u64 flags,
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
-	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns,
-				      user_ns, new_fs);
+	new_nsp->mnt_ns = copy_mnt_ns(flags, ns->mnt_ns, user_ns, new_fs);
 	if (IS_ERR(new_nsp->mnt_ns)) {
 		err = PTR_ERR(new_nsp->mnt_ns);
 		goto out_ns;
 	}
 
-	new_nsp->uts_ns = copy_utsname(flags, user_ns, tsk->nsproxy->uts_ns);
+	new_nsp->uts_ns = copy_utsname(flags, user_ns, ns->uts_ns);
 	if (IS_ERR(new_nsp->uts_ns)) {
 		err = PTR_ERR(new_nsp->uts_ns);
 		goto out_uts;
 	}
 
-	new_nsp->ipc_ns = copy_ipcs(flags, user_ns, tsk->nsproxy->ipc_ns);
+	new_nsp->ipc_ns = copy_ipcs(flags, user_ns, ns->ipc_ns);
 	if (IS_ERR(new_nsp->ipc_ns)) {
 		err = PTR_ERR(new_nsp->ipc_ns);
 		goto out_ipc;
 	}
 
 	new_nsp->pid_ns_for_children =
-		copy_pid_ns(flags, user_ns, tsk->nsproxy->pid_ns_for_children);
+		copy_pid_ns(flags, user_ns, ns->pid_ns_for_children);
 	if (IS_ERR(new_nsp->pid_ns_for_children)) {
 		err = PTR_ERR(new_nsp->pid_ns_for_children);
 		goto out_pid;
 	}
 
 	new_nsp->cgroup_ns = copy_cgroup_ns(flags, user_ns,
-					    tsk->nsproxy->cgroup_ns);
+					    ns->cgroup_ns);
 	if (IS_ERR(new_nsp->cgroup_ns)) {
 		err = PTR_ERR(new_nsp->cgroup_ns);
 		goto out_cgroup;
 	}
 
-	new_nsp->net_ns = copy_net_ns(flags, user_ns, tsk->nsproxy->net_ns);
+	new_nsp->net_ns = copy_net_ns(flags, user_ns, ns->net_ns);
 	if (IS_ERR(new_nsp->net_ns)) {
 		err = PTR_ERR(new_nsp->net_ns);
 		goto out_net;
 	}
 
 	new_nsp->time_ns_for_children = copy_time_ns(flags, user_ns,
-					tsk->nsproxy->time_ns_for_children);
+					ns->time_ns_for_children);
 	if (IS_ERR(new_nsp->time_ns_for_children)) {
 		err = PTR_ERR(new_nsp->time_ns_for_children);
 		goto out_time;
 	}
-	new_nsp->time_ns = get_time_ns(tsk->nsproxy->time_ns);
+	new_nsp->time_ns = get_time_ns(ns->time_ns);
 
 	return new_nsp;
 
@@ -192,7 +192,7 @@ int copy_namespaces(u64 flags, struct task_struct *tsk)
 		(CLONE_NEWIPC | CLONE_SYSVSEM))
 		return -EINVAL;
 
-	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
+	new_ns = create_new_namespaces(flags, tsk->nsproxy, user_ns, tsk->fs);
 	if (IS_ERR(new_ns))
 		return  PTR_ERR(new_ns);
 
@@ -231,7 +231,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 		flags |= CLONE_EMPTY_MNTNS;
 	}
 
-	*new_nsp = create_new_namespaces(flags, current, user_ns,
+	*new_nsp = create_new_namespaces(flags, current->nsproxy, user_ns,
 					 new_fs ? new_fs : current->fs);
 	if (IS_ERR(*new_nsp)) {
 		err = PTR_ERR(*new_nsp);
@@ -289,7 +289,7 @@ int exec_task_namespaces(void)
 	if (tsk->nsproxy->time_ns_for_children == tsk->nsproxy->time_ns)
 		return 0;
 
-	new = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
+	new = create_new_namespaces(0, tsk->nsproxy, current_user_ns(), tsk->fs);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
@@ -356,7 +356,7 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 	struct task_struct *me = current;
 
 	nsset->flags = flags;
-	nsset->nsproxy = create_new_namespaces(0, me, current_user_ns(), me->fs);
+	nsset->nsproxy = create_new_namespaces(0, me->nsproxy, current_user_ns(), me->fs);
 	if (IS_ERR(nsset->nsproxy))
 		return PTR_ERR(nsset->nsproxy);
 
-- 
2.47.3


