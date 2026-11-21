Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CA9606A6A6
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RA5vIfKQ
Received: by kanga.kvack.org (Postfix)
	id 82BD76B05B5; Fri, 20 Nov 2026 19:09:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5E26B05B6; Fri, 20 Nov 2026 19:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A41D6B05B7; Fri, 20 Nov 2026 19:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 339F16B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A936C14015C
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:14 +0000 (UTC)
X-FDA: 85457191428.03.9BC0CDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id F3B93A000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RA5vIfKQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219753;
	b=vDA1lycP/wexeHYpxrqSvw7k5Xb1q6Ee+40T4cOytgm4FT1Cz86oDhospSHflSMceUwQz9
	9pCjMfcLk+Ed+ZFkcwFcGQWMYXT05fgKfHEE/hTEWPTGp36xiBf0u9i/sIUearpBavO/r4
	c5MWuyXloLgGV75sIDxeDmhPY4WtwV4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	b=ej+Ay7XsDLVhIbPCjhVzeUAId7KTvdVIqttS3eC8HcE896qBqzhk0Gm2/DsPWe3B9cei1U
	bgpqtKgl61NR+TGD5fijViyjyGsyLe8Z/9+5n6O0nbo+pnP9eIGE0PgkP7ivpLkS7Bl7jR
	JTicRDL9fW7venvWVu5PQrJtrHMDCdE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RA5vIfKQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 846FD6204F;
	Sat, 21 Nov 2026 00:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8C46F1F000E0;
	Sat, 21 Nov 2026 00:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219752;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RA5vIfKQzINb0NmwFIcU196DEhLa8CEsZmgc4YEKIRIxvuH8traSIVpbLRoke0UNW
	 tBNIUaVWa2z16E0yzA2TbuKe9Dr99uU2BuJn4+YJeLtNb4ptdsmR8iACUIpzwHGjDw
	 ADc1+fp/GjRTAbjfbbISTHLI5l61tBvyZP8A9kfp5ET4fbDhjzozSllLTyKTx/4/7v
	 4QuxUZb0PVU6bKfBCBVUkxxmtmMFjoXaTWhSCZCcG5U7rMoIIgTx3SKe8ZfZKqD4/p
	 YptaHIjyJBjkxcDxySHp+6pL8eUgvFJlhGP9x2qGBjVazwwRzxsk41CIf4neCjnaIo
	 c1dEweQGzro2w==
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
Subject: [RFC PATCH v5 04/25] mount: Add mnt_ns_get_root()
Date: Sat, 21 Nov 2026 02:08:23 +0200
Message-ID: <20261121000844.1863324-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5k3o3pcq388pj654mogxt683oy4son3a
X-Rspam-User:
X-Rspamd-Queue-Id: F3B93A000B
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795219752-835563
X-HE-Meta: U2FsdGVkX1/Mei0VVSDWiSWffQNIrvzK/pvQNWg4NSX238vTdGnPh22j1YJ56p/fb9gSgwj1Q9JBjAE9KHQKUp5gng/ZTEcZ2wobmZ2UhXprvb8ZZoKGtmdlIL8Lp448+lLNx9LSiwFfQgCg+EBWOQ2keu84uADE2d86C9pU/NEtklxW3aNDVJaQ4xtGIN4knDWCFNikpn3YQ2lRfH0nOx43l4IRjYje2WEI7QjNrjJAnSTJY2fd6pBGx9MX4xs+f7xuJWC2bj5GTMk78CzybDjhMPoT3ycCwLAs+MTUs7IwKSR1mR7zIHfC8wZ7+dmd2QRR5Cvtm+WQO2GPg6wCEv72BiGA0a32Qs24uZ9Krp9cwS1gZcKHnFlpb03wTj6tgn6P+SrZttiOKiTyI7DRPIj8ftq/8biuXAHtlLG7ct+ukG4Uo+K3Vqg6CfsPGSQEe0POTLQ6JBU4p0KQVhqjweI93XhwEPXqLG9Rc4BV5JHI8Rapx8J/PxEWgLeDYUWHVMTq1md3VDe4aqxKtIunu8i1LRliMdutX/m1f4ZMcXp4tFdat+xzyWnBe5IPo0SYtDE21SGOVtKTuy0r8hnMk9kctrMTc/9bEkYY3UnoIKn0vnESnsg1RgyhduvSAjAphUP1IQZ++s3QxgBxarZVELZdGOVNTDuzp7uX7gX6x4nSN3LW5ymUS92xRViLwVPYH5TM1PGMSfy+lMedHZtJ8JFijodlbcnuZJ7dFP7n73yrmlrfkaaZ1U0kdmSWa3QFgdpUo51e/V2qLeLmE9ATdgndvSFe+gQ1wkoIrocfjuTwKb2mWnZPYxn0CQ0BtmW48RuIp2YrTSxeaoX7hbrzJBcnS9zl6JhU6t/JH2vlenbQfj+bjVdwrIANuLplo0riMOkcCdKkMWPvZ9bKRSTk1ifB+7zsxGhTbsTacw/zTdaVGfX5BPwcoit23pM/JrM3EhFsyjEI8h7GTpae6OJ
 cOekkf3m
 /uhr9JQMN6+azteSUCtFETk3QujqJDcxQgYEZTd5fu8sF0hMw3zJdX3E0S8A2h0nY0zh+ejrLNvpjaCech55wCmK8X3JJVRZzhLewyGhhAR1YXH4uV0fApx7bDEI+WlQqujbFsidS+RZAT2wwVEzx1YjNaj/yhemioYwWyzEqLy/wHRpNYvlWJcv1jfjvliRPnZphRH4uGJgJkz/eTh7wyC9FYWq+33RhAqzhJg3b8IAxEQJjY/SDAYlK25Sbd0Iq9cHc95V6v/uaQx8SiYMCXy2U/AFEapgW0pgD9kGtDF6z9HNahzstnudQTm6vzMVGPZXf2/7/mvFg7gKUWaSBuBuuZYBOeWrTjrg950V+NmJ2I1GXdYxKpY3K4pyp9aGMcU6ZTg92lvRji07imckwj2A2JpLJ3dpcUnw1HG7UjaWIy13HsVQLFWyb33UrSdRyydB9MNEJuUuyU2lNJY/JMMZAFs3a+zmQL1lAkCQsqd9FyKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Empty mount namespaces created with CLONE_EMPTY_MNTNS start with only an
internal nullfs root mount until a real root filesystem is mounted over
it, and external callers have no helper to resolve the live root path of
an unentered mount namespace.

Add mnt_ns_get_root() to look up "/" with LOOKUP_DOWN from the mount
namespace's base root mount and return -ENOENT if no filesystem has been
mounted over the initial nullfs root yet.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c                | 16 ++++++++++++++++
 include/linux/mnt_namespace.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index aecd05ac0170..781380945d78 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6708,6 +6708,22 @@ static void mntns_put(struct ns_common *ns)
 	put_mnt_ns(to_mnt_ns(ns));
 }
 
+int mnt_ns_get_root(struct mnt_namespace *mnt_ns, struct path *root)
+{
+	int err;
+
+	err = vfs_path_lookup(mnt_ns->root->mnt.mnt_root, &mnt_ns->root->mnt,
+			      "/", LOOKUP_DOWN, root);
+	if (err)
+		return err;
+	if (root->mnt == &mnt_ns->root->mnt) {
+		path_put(root);
+		*root = (struct path){};
+		return -ENOENT;
+	}
+	return 0;
+}
+
 static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 {
 	struct nsproxy *nsproxy = nsset->nsproxy;
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 0acd1089d149..98188d1f7428 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -8,6 +8,7 @@
 
 struct mnt_namespace;
 struct fs_struct;
+struct path;
 struct user_namespace;
 struct ns_common;
 
@@ -15,6 +16,7 @@ extern struct mnt_namespace init_mnt_ns;
 
 extern struct mnt_namespace *copy_mnt_ns(u64, struct mnt_namespace *,
 		struct user_namespace *, struct fs_struct *);
+int mnt_ns_get_root(struct mnt_namespace *mnt_ns, struct path *root);
 extern void put_mnt_ns(struct mnt_namespace *ns);
 DEFINE_FREE(put_mnt_ns, struct mnt_namespace *, if (!IS_ERR_OR_NULL(_T)) put_mnt_ns(_T))
 extern struct ns_common *from_mnt_ns(struct mnt_namespace *);
-- 
2.47.3


