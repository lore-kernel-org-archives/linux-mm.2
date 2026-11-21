Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61B060A2620
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H81SHs/v
Received: by kanga.kvack.org (Postfix)
	id 483D76B05C0; Fri, 20 Nov 2026 19:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D986B05C1; Fri, 20 Nov 2026 19:09:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D56A6B05C2; Fri, 20 Nov 2026 19:09:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E47BB6B05C0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 179261A026D
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:40 +0000 (UTC)
X-FDA: 85457192520.21.D2B7ECB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7837540006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H81SHs/v";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219778;
	b=uHB80Bor7pebjPQvXPqVS2dLXhVNifjiHoY7WfZQ4IRbJ0bgbEgX8HwLGOmkDC9nzn85Ic
	O5c8aF0vls6uO0x0aqe9hQ9JRBtW0XG1Td+cCrx2j8yDXW2ixFwhGTwQKHUVw8iwgAU6/+
	Fyhg2MCLVkZp0pYolyc/jyx75AVKmKY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glmqSz2x+APivEM/vonQfanbbokAEU7WMuncz0VaekQ=;
	b=yZqKOGZaz0Qri1dVFy7im+S5Th6Av6kpK5hZ2WhzZ4AyMDKi54ibJkldarxYWYmTizRMc0
	E/j7lIrXVdfG/zhAbLOG09nNfFbnxbO9NC+dJdrsRwcJyFxVNAULwI4EGyzcrXcsggA41n
	Bvg3xrpxEos2iwvHtOSAxk7GDyJSD7s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H81SHs/v";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id D56A46217E;
	Sat, 21 Nov 2026 00:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0B7C31F00A3D;
	Sat, 21 Nov 2026 00:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219777;
	bh=glmqSz2x+APivEM/vonQfanbbokAEU7WMuncz0VaekQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H81SHs/v2K4tqTjGPNdvUf7ZEVvolz24sWuu6uNJWRpVWkSyA5wpH0a7n8m7+1D/k
	 KH/xkMWc4Szns+4CwHQF2zWABJ3KLgjOC59geDEUJFlWf0A+mmqgHUf2MjHdrOh35u
	 6VfGz02YXrt38UmcZqgL9DMsj1MsA4nN9+R8aaT10dyh5v01zkDu98GW+nDJUl/5HN
	 GxYkxxwkymmPLp/v2AIlQTGj69xAHxA0KcsKa5v1DIMTHdXMBWZHE9+PEXiQBAvnHl
	 5TZpRlRYXFMOIiIpD/Bm1ptOcfu2af1j4uIy9BejYAPGkbpnvmL6DlYjkeIomU+N1j
	 xMtI96rJBKeQQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 10/25] nsproxy: Pass nsproxy to create_new_namespaces()
Date: Sat, 21 Nov 2026 02:08:29 +0200
Message-ID: <20261121000844.1863324-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7837540006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qfo4nd9ora4xhgxrauaw6p3oeccdzmf6
X-Rspam-User:
X-HE-Tag: 1795219778-121305
X-HE-Meta: U2FsdGVkX195HV7cGLkBb+CqwiDvkeZL2uO+D5NYSEKko/c3Wywg599tiUBXCnhhMiY9Q26rb9faYCKd6qFMbWes/lHOzyeA3OYBJ+dFi8o5s/RV0Kv92NMwjF0XTj8li405lixT+3w68XWMemjSsZSRJ9XjTgQAWJjWezvGQc506WD97auFCm7LWXwqomI4ng3TvYPWZ4HS0XVTT4BW/ttP21mVpdG+4JeUw+kgHFdyAggp/kGLA8ayCzc176OpdfJvt6eXZO8CjonrMXv3jV1t67xDKMB+5rLEOMGNMlPoxKSJFh3xvep4AIXtLIycKDZ+Z/KHdFIqks42Ehwh5RkJSnItEwvZ45Q1bl84CIb3nqymglL1hlCA5mmRExBXg0B9lBfILq9umOE+bAIOh7owlW8vJBeS4EH9kY/k4a8k5y8EOiS1+JZVFoAR+ul3sMRVP82dB3ZS4+atKQi6/RzA9JLOnQvbRLYHvvGKQCfjoCpB6tg+MbODtFR+MIMLR1kAB6bLF6vyaq1jl/uS4Jq/9IauUCMCJqhscR9PXnc69PWnSmQ7YI0cb/5z3HWsHQ8/wFPi2nMor+kOmZZM8fjbCcj9atn52MVIRv8mZsZWVk7kHDRyQSjscTU39HPTK61WzTTTjnQm9pyJIKyOD2KQeaiuhOKjWagjjZZw1R4gyApLdLzch2nyH9gZKvUobWba2nXobonvQedEjOsBaH2QJHcfzBkLlQ7sfZPkdLW1ZOTmU/XLClcEBoAAHy8uqfG4ZevN6dAzm2VWJEl2tzWb+ZJj49HiXtA6L80MhPR4cRoD9ohVwEux2WgEb409WCbJNalk1Q644BqkJTqwJ5bos4G4HQ6/dR1XnGYwMZFQnNPZ+wFFZOFzL0naMwaGa0qhNyi5IZ8lYBYCo9+vzJ7IeE/K/p7Z0UROttmPuEcF2J925cIKwJAlaVApUEUs+MzCr8zFEpM49DsimY0
 +31podfv
 /4V+8a36X2z3Bk9ueMWePjAVffdZwEDd1fLGZiokeKMRNrhJMdhWibFF0OEsPTz35Rh+OhALDd5Dmm1g6lw924UZHHeKgyzVZMo7QUoPkhrkcKDwV80GRlQE5LC8iBTJ5rK4SZe3OQgyFmzy2atYUKeJ4oLi4H9N0t8nBZ2UFhYknBsyXFBs28dwjLnFVmoLkr2luuNcRmFTzWYnMUL2y6qKOVykrJmXJRCfkEtYpOb59504q63HgPSdqkhmvAO7P8jNF3zi057n2FqmG6aUsBLXMg99zRcQi0crRwG3wFcqgrMquHYBzSoY6R+H5HJAO1/lmlB0nzeyWRfob40nWQpb17SdckHxWW+XcgvPS0/YoU6nbVmvHLBzrHZbXR2ptqYmFIZ86DKrGiEshdmXXRcwGqtcsHYXl6HbrRIDU+Dk4qXFZLmOR2tuXXZCXyiLhVFko/JJPn7VFdg16UqR07WPJ73nq9jSagEIGhcdtHZgbIWQlDz63Y68x9ZMwub6HMtCSWCWrn9lODSjxIA83CmVsxLY5G3O5N2CxdRgtuy5Np37Ze/sxKnDWRhkZMa7M/WFaxFZs934RZPcq5BrmeZb6LUm0h1Qvw99wq5k/8tpjbR1/yXSn0zZSVQ==
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


