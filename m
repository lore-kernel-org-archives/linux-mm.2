Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 795DACCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 21:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915258E0008; Tue, 11 Nov 2025 16:30:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEB18E0002; Tue, 11 Nov 2025 16:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829A58E0008; Tue, 11 Nov 2025 16:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73BFD8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:30:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 193E5B700E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:30:02 +0000 (UTC)
X-FDA: 84099619044.30.CBD0B3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4AE794000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:30:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uGKgOZih;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762896600; a=rsa-sha256;
	cv=none;
	b=ry3jinx0PxQV2dFpGVfcFRju2iwGFyAEX6g2rImcTOG9jzP2E7vpKa10kRY8PzK26jbxS8
	QZ2EIiDHind8jtHIVOp/lWe1zfBvFSl9j8deQglfUj/vLlTET3XNxQZxz4o0OLsE5h63+W
	ix0rE3UMY6frzTpLPPiQnuTGT6FaYuo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uGKgOZih;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762896600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcvbtbrD2+CAqo+91Fr52LwiFBypQ2qDEhuvk+86pXg=;
	b=RWzFEmZKM3VkfyG0V66hBM+CazlaMYy1IvTOBZ6aBRzN91tQ9FpiMYAYJO3Y1mqXNlbg06
	0M35ojvqsux0rYoWuqs5tbHFtIiXhXta9VZR+FZDnNgvm2DaiOynz/GZkraXvUpaBpPFcQ
	ndlcgNMIzAeHMdNOtiVQ9LD78j5QUB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE35C43E81;
	Tue, 11 Nov 2025 21:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBE2C116D0;
	Tue, 11 Nov 2025 21:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762896598;
	bh=/bC50lhCtcx6OG7oIZHLvFZOizTdGgNdqLCTc3tazgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGKgOZihX6WkxOXaYaMp7Ce45mAoZy1EdfFSGzxey8lL8ehrEFIL28KuIarmg/MNN
	 q3HW4jyWthAJ8uUu/tNQsUJIcWjqrwAyZYS2WAzJFEVqjfCokNpJ+pA5pdwBRqWMey
	 bPGuKEJQFW0OLIvy59Fzs8zpgRKcZmZjpPqjwd1hcYyG4KMM7du5CZ+tP62TLx16s2
	 vDik8OOPhpjo+w0OVb0HfR9Y1msHmcC+CUnE13AHRG//Nak7D47T7MeOw4cM6XUuLE
	 SN+jmchssstwp47zqOcbrNN6mzaZpHQXpJoluWRAwVhesyL1Yvf7L+IGOI9KCkFGB8
	 ZB7mc1l3UU0Dw==
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	akpm@linux-foundation.org,
	bpf@vger.kernel.org,
	bsegall@google.com,
	david@redhat.com,
	dietmar.eggemann@arm.com,
	jack@suse.cz,
	jsavitz@redhat.com,
	juri.lelli@redhat.com,
	kartikey406@gmail.com,
	kees@kernel.org,
	liam.howlett@oracle.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@redhat.com,
	mjguzik@gmail.com,
	oleg@redhat.com,
	paul@paul-moore.com,
	peterz@infradead.org,
	rostedt@goodmis.org,
	rppt@kernel.org,
	sergeh@kernel.org,
	surenb@google.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	viro@zeniv.linux.org.uk,
	vschneid@redhat.com,
	syzbot+0a8655a80e189278487e@syzkaller.appspotmail.com
Subject: [PATCH] nsproxy: fix free_nsproxy() and simplify create_new_namespaces()
Date: Tue, 11 Nov 2025 22:29:44 +0100
Message-ID: <20251111-sakralbau-guthaben-7dcc277d337f@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <691360cc.a70a0220.22f260.013e.GAE@google.com>
References: 
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6748; i=brauner@kernel.org; h=from:subject:message-id; bh=/bC50lhCtcx6OG7oIZHLvFZOizTdGgNdqLCTc3tazgg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQKrzr99kkW6wzH6+UP/PreNc3KE2rfU+NbHrZ+xbWOF t7s6PTXHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPRDmVkuJPxT1/H9VJg0TpP bYu9tkz6hpfdpUT+6F3i3+xsae+1ieGv0BItmR8v/+iyT+J6VCyx5du09JVfWi1ua75+sX5Kp8w rHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4AE794000E
X-Stat-Signature: 8uj771tnue9sugg8g7j8jmmkbnqwfdnm
X-HE-Tag: 1762896600-389581
X-HE-Meta: U2FsdGVkX199F2Gk0zJr2LE+j6+8KdLTOqs748rOnx3NWysi7I7nS/Pa14nFBGXSUXe5y/a2R0vJJm67ShlsmW3KVmodtyxF0yJyiUhKfteQ5SlSCfJIzRgMjU/MWmBD8X89PiQYHDHRzZNYHNEraCQhWsp2t147wSyFO7XpLDvvbJyZabRlh7g+IHZ5Ap8QVE4MRpNyK0w2iSCfxFxvJXtb6aEBIHtTDtKBgjKq0d+SmGjT3NKEVRCKRRczlFRspNSWHPPErckL/E1qDA5hlEDPtA7MkAMQboZhlKedxx08Cf6Ou9LwUqUF9pKhAt/5X5CJ0mokPoqRNDGzxDRYwLCFpN4MKRoIk9s4iUTHjdq3uv2ira+jqoL6w8+AckfcBtm2yNWE/ESc/GLIhXDFCmc7WQDeUsUDsBhZrHJ/kaowDZrj1dANzk1SYEkVU/poYSOp0kyY+gn+XTHkuxmdsdlYySZMJnQ2CM6GPlNgSKG8ShIa2NFTbwWqzVrPBuHxxfVeOoGLwxVfmCOFe8+ygUb7ziZ+IJQ1EYcoE4o5AcOM9V1OtxXOjtswZbYULgYtsBKUJZIBRyMYCpTYperZBoZ3cxVu1044vNl3zzB3SH2Hc0FheQRwV97qZVYTP+//YTSjqCzRIdPmz46/vQN1kHzVaMjxmWI/S6FxGu7/qCgW/MMHewddE3AUvGZ5J50idxR3Bcz3/WGPJ+PpY4BhC4X7hqrjx7p0VI7H4wuGf3wlnBvD3Nub8pW5Tv1bo9ymM/gJxSpjva6BSQdOQNSXLoaBQQlSp1BMt1oyiw6vlzLUg/ITIaEZB0P2zYVLQ7uUHsQgoxmR3OCuwrM0eFWm/11n6fH2UypvgUgM83xihH7Giqvr+lj9CFbq9WBQXp3oHdtYCafE8J25GD/uMEuE7w90GHtZkgQGrdiuZy5Jm4ysxms2kYgUfrRwrZ4emCa/5nsNrhlgGu/QkHlqJQa
 yZWLBqfK
 JT2In6qASo5/BAeHAwJLS9hc/vyFdKIBnpyN8UaFN2sRpQDOXZV+9wHX/82QXi2NmlZw2qYExzxYW43leBpXPzKuTDywssmh6/8XHqgLLrH96tg0kCJYXLTyxEuCCtzNLTjba1XVlNq+4vyGLybW8T/HL2SLMfJDzPQOZQcUFQAl5GvxMgbPdRNkADZce6p941mZSY93W5UGaOPJAzetnwjzcIxXYYZa8fI3iN3aHkLxMJCr8GGR3O/WaQoJIWSmsbtV+0EGQkXuicpSyUugTpYH/BUcNFIubeQ000o9PZYFZkf1vd2tIF/aJQYs5gNU4YoriED9+jmCxlcei/qb6o52O4RMaASSjd1UBwkUQL04xETuO7MQ6363YpdUxvNSsxyCJmD4sou7VVebFE8EKTo4YAHn77EFS2cyQEEwMWqi9GJh7ColnsnoMxBhaYa5C5xUFDiLc0dXDGDGwXS993upTEheKrnPhSXQd8EZ1a1uaAbc9ri4lXuwtoffaS0/9ZSK9mW1eEu8H1cvkFQYmr5hCdyxKmZHfOPocrHDTdvXGCwWAeQygnF5mQfxewVzv3VLc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it possible to handle NULL being passed to the reference count
helpers instead of forcing the caller to handle this. Afterwards we can
nicely allow a cleanup guard to handle nsproxy freeing.

Active reference count handling is not done in nsproxy_free() but rather
in free_nsproxy() as nsproxy_free() is also called from setns() failure
paths where a new nsproxy has been prepared but has not been marked as
active via switch_task_namespaces().

Fixes: 3c9820d5c64a ("ns: add active reference count")
Reported-by: syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com
Reported-by: syzbot+0a8655a80e189278487e@syzkaller.appspotmail.com
Link: https://lore.kernel.org/690bfb9e.050a0220.2e3c35.0013.GAE@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/linux/ns_common.h |  11 ++--
 kernel/nsproxy.c          | 107 +++++++++++++++-----------------------
 2 files changed, 48 insertions(+), 70 deletions(-)

diff --git a/include/linux/ns_common.h b/include/linux/ns_common.h
index 136f6a322e53..825f5865bfc5 100644
--- a/include/linux/ns_common.h
+++ b/include/linux/ns_common.h
@@ -114,11 +114,14 @@ static __always_inline __must_check bool __ns_ref_dec_and_lock(struct ns_common
 }
 
 #define ns_ref_read(__ns) __ns_ref_read(to_ns_common((__ns)))
-#define ns_ref_inc(__ns) __ns_ref_inc(to_ns_common((__ns)))
-#define ns_ref_get(__ns) __ns_ref_get(to_ns_common((__ns)))
-#define ns_ref_put(__ns) __ns_ref_put(to_ns_common((__ns)))
+#define ns_ref_inc(__ns) \
+	do { if (__ns) __ns_ref_inc(to_ns_common((__ns))); } while (0)
+#define ns_ref_get(__ns) \
+	((__ns) ? __ns_ref_get(to_ns_common((__ns))) : false)
+#define ns_ref_put(__ns) \
+	((__ns) ? __ns_ref_put(to_ns_common((__ns))) : false)
 #define ns_ref_put_and_lock(__ns, __ns_lock) \
-	__ns_ref_dec_and_lock(to_ns_common((__ns)), __ns_lock)
+	((__ns) ? __ns_ref_dec_and_lock(to_ns_common((__ns)), __ns_lock) : false)
 
 #define ns_ref_active_read(__ns) \
 	((__ns) ? __ns_ref_active_read(to_ns_common(__ns)) : 0)
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 94c2cfe0afa1..2c94452dc793 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -60,6 +60,27 @@ static inline struct nsproxy *create_nsproxy(void)
 	return nsproxy;
 }
 
+static inline void nsproxy_free(struct nsproxy *ns)
+{
+	put_mnt_ns(ns->mnt_ns);
+	put_uts_ns(ns->uts_ns);
+	put_ipc_ns(ns->ipc_ns);
+	put_pid_ns(ns->pid_ns_for_children);
+	put_time_ns(ns->time_ns);
+	put_time_ns(ns->time_ns_for_children);
+	put_cgroup_ns(ns->cgroup_ns);
+	put_net(ns->net_ns);
+	kmem_cache_free(nsproxy_cachep, ns);
+}
+
+DEFINE_FREE(nsproxy_free, struct nsproxy *, if (_T) nsproxy_free(_T))
+
+void free_nsproxy(struct nsproxy *ns)
+{
+	nsproxy_ns_active_put(ns);
+	nsproxy_free(ns);
+}
+
 /*
  * Create new nsproxy and all of its the associated namespaces.
  * Return the newly created nsproxy.  Do not attach this to the task,
@@ -69,76 +90,45 @@ static struct nsproxy *create_new_namespaces(u64 flags,
 	struct task_struct *tsk, struct user_namespace *user_ns,
 	struct fs_struct *new_fs)
 {
-	struct nsproxy *new_nsp;
-	int err;
+	struct nsproxy *new_nsp __free(nsproxy_free) = NULL;
 
 	new_nsp = create_nsproxy();
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
 	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, user_ns, new_fs);
-	if (IS_ERR(new_nsp->mnt_ns)) {
-		err = PTR_ERR(new_nsp->mnt_ns);
-		goto out_ns;
-	}
+	if (IS_ERR(new_nsp->mnt_ns))
+		return ERR_CAST(new_nsp->mnt_ns);
 
 	new_nsp->uts_ns = copy_utsname(flags, user_ns, tsk->nsproxy->uts_ns);
-	if (IS_ERR(new_nsp->uts_ns)) {
-		err = PTR_ERR(new_nsp->uts_ns);
-		goto out_uts;
-	}
+	if (IS_ERR(new_nsp->uts_ns))
+		return ERR_CAST(new_nsp->uts_ns);
 
 	new_nsp->ipc_ns = copy_ipcs(flags, user_ns, tsk->nsproxy->ipc_ns);
-	if (IS_ERR(new_nsp->ipc_ns)) {
-		err = PTR_ERR(new_nsp->ipc_ns);
-		goto out_ipc;
-	}
+	if (IS_ERR(new_nsp->ipc_ns))
+		return ERR_CAST(new_nsp->ipc_ns);
 
-	new_nsp->pid_ns_for_children =
-		copy_pid_ns(flags, user_ns, tsk->nsproxy->pid_ns_for_children);
-	if (IS_ERR(new_nsp->pid_ns_for_children)) {
-		err = PTR_ERR(new_nsp->pid_ns_for_children);
-		goto out_pid;
-	}
+	new_nsp->pid_ns_for_children = copy_pid_ns(flags, user_ns,
+						   tsk->nsproxy->pid_ns_for_children);
+	if (IS_ERR(new_nsp->pid_ns_for_children))
+		return ERR_CAST(new_nsp->pid_ns_for_children);
 
 	new_nsp->cgroup_ns = copy_cgroup_ns(flags, user_ns,
 					    tsk->nsproxy->cgroup_ns);
-	if (IS_ERR(new_nsp->cgroup_ns)) {
-		err = PTR_ERR(new_nsp->cgroup_ns);
-		goto out_cgroup;
-	}
+	if (IS_ERR(new_nsp->cgroup_ns))
+		return ERR_CAST(new_nsp->cgroup_ns);
 
 	new_nsp->net_ns = copy_net_ns(flags, user_ns, tsk->nsproxy->net_ns);
-	if (IS_ERR(new_nsp->net_ns)) {
-		err = PTR_ERR(new_nsp->net_ns);
-		goto out_net;
-	}
+	if (IS_ERR(new_nsp->net_ns))
+		return ERR_CAST(new_nsp->net_ns);
 
 	new_nsp->time_ns_for_children = copy_time_ns(flags, user_ns,
-					tsk->nsproxy->time_ns_for_children);
-	if (IS_ERR(new_nsp->time_ns_for_children)) {
-		err = PTR_ERR(new_nsp->time_ns_for_children);
-		goto out_time;
-	}
+						     tsk->nsproxy->time_ns_for_children);
+	if (IS_ERR(new_nsp->time_ns_for_children))
+		return ERR_CAST(new_nsp->time_ns_for_children);
 	new_nsp->time_ns = get_time_ns(tsk->nsproxy->time_ns);
 
-	return new_nsp;
-
-out_time:
-	put_net(new_nsp->net_ns);
-out_net:
-	put_cgroup_ns(new_nsp->cgroup_ns);
-out_cgroup:
-	put_pid_ns(new_nsp->pid_ns_for_children);
-out_pid:
-	put_ipc_ns(new_nsp->ipc_ns);
-out_ipc:
-	put_uts_ns(new_nsp->uts_ns);
-out_uts:
-	put_mnt_ns(new_nsp->mnt_ns);
-out_ns:
-	kmem_cache_free(nsproxy_cachep, new_nsp);
-	return ERR_PTR(err);
+	return no_free_ptr(new_nsp);
 }
 
 /*
@@ -185,21 +175,6 @@ int copy_namespaces(u64 flags, struct task_struct *tsk)
 	return 0;
 }
 
-void free_nsproxy(struct nsproxy *ns)
-{
-	nsproxy_ns_active_put(ns);
-
-	put_mnt_ns(ns->mnt_ns);
-	put_uts_ns(ns->uts_ns);
-	put_ipc_ns(ns->ipc_ns);
-	put_pid_ns(ns->pid_ns_for_children);
-	put_time_ns(ns->time_ns);
-	put_time_ns(ns->time_ns_for_children);
-	put_cgroup_ns(ns->cgroup_ns);
-	put_net(ns->net_ns);
-	kmem_cache_free(nsproxy_cachep, ns);
-}
-
 /*
  * Called from unshare. Unshare all the namespaces part of nsproxy.
  * On success, returns the new nsproxy.
@@ -338,7 +313,7 @@ static void put_nsset(struct nsset *nsset)
 	if (nsset->fs && (flags & CLONE_NEWNS) && (flags & ~CLONE_NEWNS))
 		free_fs_struct(nsset->fs);
 	if (nsset->nsproxy)
-		free_nsproxy(nsset->nsproxy);
+		nsproxy_free(nsset->nsproxy);
 }
 
 static int prepare_nsset(unsigned flags, struct nsset *nsset)
-- 
2.47.3


