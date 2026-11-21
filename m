Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF80606A6B5
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JCCENwSk
Received: by kanga.kvack.org (Postfix)
	id 19D086B05BE; Fri, 20 Nov 2026 19:09:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14DBE6B05BF; Fri, 20 Nov 2026 19:09:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30A26B05C0; Fri, 20 Nov 2026 19:09:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC0D96B05BE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1949D12025B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:36 +0000 (UTC)
X-FDA: 85457192352.18.8DC435B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6E22740008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCCENwSk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219774;
	b=xlrWhTLInwtWk/XVZN5q4UbGuVS+W0fPdWrdCxVuLVLgXQKd4bMyhg8JBWajWurXhBQVsr
	q5lOofiXYDxAaTIz+0p3jF6NQXBfrUpm++Pm000nUoPmcdUhNPVZ4ddlfwxqMXHRfxGHIJ
	F9MmU6sN+epNGs/Fuhcwv1wmZroE27s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzREVgEBs+NJFPQiDqKMMmGwcM3JLTD/1v4USFGXPBU=;
	b=EVBxtv5cKshfB+kFL2ts15Zhv4RiPNA7Q+LaewUzovVfrkYr3XLy0EEO9KZH/PkFT5UPLX
	gt3XYkODb3z9D0JuXE2X+MhidHcTA8yacFBssItCf1dmgypYLF22SNLJ4J9t+T2V5t7Y8A
	hQHDmOZnY4dH/e/sGkMwrEHuaAR8XVE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCCENwSk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id B8AE44388B;
	Sat, 21 Nov 2026 00:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9811F1F000D0;
	Sat, 21 Nov 2026 00:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219773;
	bh=HzREVgEBs+NJFPQiDqKMMmGwcM3JLTD/1v4USFGXPBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCCENwSkL59f6V0Kx69Qk+VVb3g8rAVMeE2yN7DMvOVdI3qNLKt/N3cwzDjoZa85w
	 ZHp2z52rZDTrLMuw9QsGYjukfEsZtx2Cum5KZp+IGmhUnnC1eCz3c41IhX8mLg0qAi
	 qsU9OOWGo3atwfdHG4ZJGae0XxAZpZeK7gVXyvhp9ei5148vQtimv5qMkNPuYiOYpK
	 haZKyouOH3HEeqQ6rvijeje88OML2y+Ft/JYMaNBYQ5KivfkjTimg5JaJsrbYr1EjX
	 J4IEIKPHiyaxvHbkByw8//0hOs7KHgQhdOAZV3/AEmRdpIn1VBJKYt80G61U7W6Bcl
	 bFu0u6P9anbrQ==
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
Subject: [RFC PATCH v5 09/25] nsfs: Add nsproxy_open_namespace()
Date: Sat, 21 Nov 2026 02:08:28 +0200
Message-ID: <20261121000844.1863324-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h918ysanrj7ugjb4gb94oc9hnjqiospj
X-Rspam-User:
X-Rspamd-Queue-Id: 6E22740008
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795219774-303307
X-HE-Meta: U2FsdGVkX18QcqzDIbC6kR2W85TKcnbwQvN1344cbVo3dvd8fhwFZEUW52SCcxjApuzUh7GhImUCpMYWBa1VunE1O9IeQwvxmHTL+IFemwqx9GvGHif119BCUTOQbej7IUHKMhB4qQPYx3/xJPxoXYa8E5DlkeDOJq4zOKYq6E2v60RVvp6Pr6Wcb5RxftyBfcH5doNC5IXExAsXCkh+I8O0nLUKTkHqRCeRp22Rx4e14T0R8OD/xg3oR9F40Qt+MtX63YcdEoXpgkrbJvVeb0oJtVWFOdG+2WzdozsTPgbCu1OvbIwsFEUqVCSoaAyf07BwTPqtTTmgx41WAeohKuLsBgL0pq/EEEmrZsQqCBBc8EJoSlmfPIA6FveYndN5iYxRy1t7s8o2AvqhJWRWHHCVACeG4CoTzCwegzN6rxdg8XsckA2Yx4/U0z0R7kLVC49dqtazSRfaBviRy4hKHcGMazybwTSgWD8QyMpQnS60gHH3oiLNVTKDp0ruW0PXL0smvqt2SwQabScb27QA1arjLKmWbz90jNfV545V/ZJeCHt/D3+58n3oMdZnV2ZB7OmcPaK7wacg/C7k8Po/lFir7CHNqZjBGUMpcnysujW4Q9BJ9ruFz2/tdK8v20oc3LOCGTsocjQ40KAto216YGAJX7uuGrgYwMDD+s2h5CTgsOE3QmAzcMotDzFhjIcySWxdkhsXKyB5AjjeQbfwMeizIDS0a03yp28SiUiZvhajmWNDQGZM6o4AbNi4xxyirfPHwQzqwPD20ogpjgaSlh6RbDn/UjdCOMEJkwYE2he6mAj4A57WlVhN9h2/J4voshC3+z3e5V9Tq+3SS6qXoTqfg4OotN9F2CDqMAW1E2stWucLtD9uf6LPQrwc63DUYWFLoFPRUdjGoKpU7FBBNy6nxGP2k90vuad+A2oBoMdlpLwwcGu+dRtVbeI7GJyOjVf4gUOjnaJMAAvyJTY
 Qh+1VrVB
 l7LWb6SoYHjEcuEjYKU3FOLbNL62L8hqpCRsyJpCNBlnDqHJwWlhuf6qD1TJ/lE4D/Dfbw4hd+ESqVy+NQCrNy016I4RLE5LAOAIXr/zDTET+wOWc3gzdiScolLFsj1juzvwyq91R2C3ZdWRx/+DAfmzksYBGPuEZVxKkebeXXqST2JQE0q6JhB5y7NwWi57CpU/AYWkqhttkvgn1rgSAkHjHaJzCxgRxrIq/daC8ZSxaw5YmTO3lz7HSSuMvlRWF5ONH4mLcIpz4tv/YAmQD3NJ8g6ZTGf+2FdPsPKSYeOjv5chtGcyI4XV+nBxrZ7IhDJQ3O+9anVVKjFA4AoM/OCmjcXOuoCLJqZH5phe8CInUulkzqta6nfV0pG9GIExrCtP/LUR9Fstg1E5nKfzAgcgK9374FAyNiUjuYI7K60Vg31jeMSZgP/Hfwn4Gv2CtPrg4TeA+VCXzUNgIdcsDmyS49MbGjY9KlgDEE53wE/8B04MYl28xO2nqJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Opening nsfs file descriptors currently operates on a live task via
procfs or pidfs, preventing callers that own a detached struct nsproxy
and struct user_namespace from opening member namespace file descriptors
directly.

Add nsproxy_open_namespace() to take a passive reference on the
requested namespace type (CLONE_NEWNS, CLONE_NEWCGROUP, CLONE_NEWUTS,
CLONE_NEWIPC, CLONE_NEWUSER, CLONE_NEWPID, CLONE_NEWNET, or
CLONE_NEWTIME) from a supplied nsproxy and user_ns pair and return an
nsfs file descriptor via open_namespace().

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/nsfs.c            | 64 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nsfs.h |  2 ++
 2 files changed, 66 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 8179d69da038..1de51cd47508 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -711,3 +711,67 @@ void nsproxy_ns_active_put(struct nsproxy *ns)
 	ns_ref_active_put(ns->time_ns);
 	ns_ref_active_put(ns->time_ns_for_children);
 }
+
+int nsproxy_open_namespace(struct nsproxy *nsp, struct user_namespace *user_ns,
+			   unsigned long nstype)
+{
+	struct ns_common *ns = NULL;
+
+	switch (nstype) {
+	case CLONE_NEWNS:
+		if (ns_ref_get(nsp->mnt_ns))
+			ns = to_ns_common(nsp->mnt_ns);
+		break;
+#ifdef CONFIG_CGROUPS
+	case CLONE_NEWCGROUP:
+		if (ns_ref_get(nsp->cgroup_ns))
+			ns = to_ns_common(nsp->cgroup_ns);
+		break;
+#endif
+#ifdef CONFIG_UTS_NS
+	case CLONE_NEWUTS:
+		if (ns_ref_get(nsp->uts_ns))
+			ns = to_ns_common(nsp->uts_ns);
+		break;
+#endif
+#ifdef CONFIG_IPC_NS
+	case CLONE_NEWIPC:
+		if (ns_ref_get(nsp->ipc_ns))
+			ns = to_ns_common(nsp->ipc_ns);
+		break;
+#endif
+#ifdef CONFIG_USER_NS
+	case CLONE_NEWUSER:
+		if (ns_ref_get(user_ns))
+			ns = to_ns_common(user_ns);
+		break;
+#endif
+#ifdef CONFIG_PID_NS
+	case CLONE_NEWPID:
+		if (ns_ref_get(nsp->pid_ns_for_children))
+			ns = to_ns_common(nsp->pid_ns_for_children);
+		break;
+#endif
+#ifdef CONFIG_NET_NS
+	case CLONE_NEWNET:
+		if (ns_ref_get(nsp->net_ns))
+			ns = to_ns_common(nsp->net_ns);
+		break;
+#endif
+	case CLONE_NEWTIME:
+#ifdef CONFIG_TIME_NS
+		if (ns_ref_get(nsp->time_ns))
+			ns = to_ns_common(nsp->time_ns);
+		break;
+#else
+		return -EOPNOTSUPP;
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	if (!ns)
+		return -ESRCH;
+
+	return open_namespace(ns);
+}
diff --git a/include/linux/nsfs.h b/include/linux/nsfs.h
index 731b67fc2fec..bfba790ee1a7 100644
--- a/include/linux/nsfs.h
+++ b/include/linux/nsfs.h
@@ -39,5 +39,7 @@ void nsfs_init(void);
 
 void nsproxy_ns_active_get(struct nsproxy *ns);
 void nsproxy_ns_active_put(struct nsproxy *ns);
+int nsproxy_open_namespace(struct nsproxy *nsp, struct user_namespace *user_ns,
+			   unsigned long nstype);
 
 #endif /* _LINUX_NSFS_H */
-- 
2.47.3


