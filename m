Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66101606A88B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kto53+qT
Received: by kanga.kvack.org (Postfix)
	id 36C7D6B05B3; Tue, 17 Nov 2026 18:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3450D6B05B4; Tue, 17 Nov 2026 18:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7116B05B5; Tue, 17 Nov 2026 18:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E65566B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:17 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73FEA1A05FB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:17 +0000 (UTC)
X-FDA: 85446166554.07.D98965A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C2240A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kto53+qT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glmqSz2x+APivEM/vonQfanbbokAEU7WMuncz0VaekQ=;
	b=30HQVdgfFxviMr18vg/PGqP4JaaamdSPRES7wGSvy7IZ2pl/lTRyN6Ahxfqnb2LtoCgb5D
	olAiSxr/+/Eu8pdwQpixrAlz7fpaYpVglLBPSFDyNs1k9Ir/3kbCjoXFOjlGsvwwSjK5D+
	47PjD3nHj+XbkpP1LtkJLEqjK6UxdcQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kto53+qT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957256;
	b=oH6B7qqaV4byl/rx0Df8XI+QLeJjfez6ABP+2TvWAZWgR1E475m/l3sV2gyLZWsLLO8tza
	lT7p4XQSZDd+hzG3KrgCsNhdDF+P4R0ubeI2p3i2sz77NTEZm12l2ZkRfkp+RlgbQV4Gn/
	ZWld1eB5Q25zGs72/EsfrvMyr/aWigc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id C210445CBB;
	Tue, 17 Nov 2026 23:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E2B181F000D3;
	Tue, 17 Nov 2026 23:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957254;
	bh=glmqSz2x+APivEM/vonQfanbbokAEU7WMuncz0VaekQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kto53+qTnBAKnFPsy5JwbXgmhc5KJr9UL15WYU3xzZ5hIeTw/Sojeke6K36zlgu/F
	 1ax5wJ/4wsgrTgw4L1T+iYcEQcKbDXTzIh1k//Fn5RAKm3JLVoC9NpYqhjptnfCAig
	 Kil1tifkJah5twsNLBirwqOhWEe4t7gELdAYAlGELZ2noiQXOrKfoMaUJMzkilUxZ5
	 /ruyx+ZazlXKW7WJJYOzpztwl/aVDW9EU+7libJ4fgpk/SZ8TueUDFso273DhYdLyf
	 ppbhSMf6JRX8xxzKR45wg7WYD0GCLpq1xVwXblTeg1cKhKphAB50QoHwjhF8MmK+4U
	 KMCRSapIhV40Q==
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
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 01/13] nsproxy: Pass nsproxy to create_new_namespaces()
Date: Wed, 18 Nov 2026 01:13:40 +0200
Message-ID: <20261117231352.3816603-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2240A0004
X-Stat-Signature: ayur9hyabde46q9rn83x788zncc15qct
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794957255-582142
X-HE-Meta: U2FsdGVkX18kNrtYqPpCG/eH4hX8Z0Uq/EGl5MGLW9WBGQF+3JDc+VXVhcJa4AMeyoXkrAZhpmmgKzme/w4h9E4J0lxd5JNGBsgSCmtdeAwH2qQWcHMWjYgQEk45sWfad0O9mzUC4p0ynjPBL2fD0LoeOfAJqsmOda+nug2/ewG4U4fh5LuzAsVKUq5+PGanpn0pnS/eRjf5VZDHRe/PkuqO70OcywUifhEYJunHGcP272gs07C/yq69GOjwC5g3Y+mOGhvL7Ii9Fuif0autOAEFyf20TgX1oc/hvUQFW8QtLIJzqTzmH0ZuqpInK7Hlmct1zCo68F8YuGd/42q0Bodku/nR+LdKrj8ZbdCprUslLkPzpjrwSWpq2iH1lbUHVKelqq0WTkHpOX2hdT/dX6ZIb4WJa6HcOjEvfEpSGv4f/xZTxhPzexqyjl9+YYPvOMG8fmPTSnhTnGo8hZSLKezrFdF6qNoaIFwYGQ1U7tlTK5aEONkRunlctIIcJXvajoh2bFqOkbNti9g1Y5J3EpHtKeIYZZQe2USu1GYLyMD4AvD92QxMifF3SJtihE1OZIzurZGtyeZRZjdcjTDUAlY4AIh+deDembHzY3Qg7h8ivT72GDVdBokyOksV75t/kxMdbm+k5xmln4AKnKiQf5kAnxpYw7I1nCXYLMSWiqA/JZUc57+wEI6s4itH4MrFx4YeEgHBh8HshNbZmgIW5Uw0bgkRS9DjtwsP7PXz1ULI3s+LyryLTTDxA7IoFXSoP9JDiQcpdR89ACSUp72zOUZxtdQX7AcyYt7boCeeHcEclZJxtj/1+U/KLd61C2EIBbpX3ZpJHoA3c5e06aGXGYqyo4A/o+6gBtk8IvcLpjSP6R+nwCyV2IFPGTM6OnTQOVZm38XGYSqn7bpGUFQPiMfScvZGlpAhsCckmVqTNfKYiAjjkVFHutzDuuFW2tijQPgwmfmlOe4dweHDDna
 EgZ4B2Ut
 VMWxuiZ5uamBSxT1deAptSXP7l+6vLQKLsF1/gPXWBzx7UZ4I+EoeY27bzN8nGwBUjMyutfUY7Ao5d5AAm6YowqjFYDDtoMAUwV3U2mXkx+fQgyVcYP31fZGFg3zwwRmd04j9ph2Ls7L67iiEgxxrDhJSwHpc3brceTXK6HdbLi2ChXHsnxCdThNyfqR6S/FkFjQR99GhFx7HH2axWYodD3NbIXsG3+dOq5T0Zop+TAusd9gZnM6K15NX7xIBpAQ2jhaB5yzkX064uz4=
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


