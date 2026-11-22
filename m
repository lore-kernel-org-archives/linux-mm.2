Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4392606A696
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OKCYL9/h
Received: by kanga.kvack.org (Postfix)
	id F29506B05C4; Sat, 21 Nov 2026 20:19:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDA086B05C5; Sat, 21 Nov 2026 20:19:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF826B05C6; Sat, 21 Nov 2026 20:19:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA5B56B05C4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36C3E1604A8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:16 +0000 (UTC)
X-FDA: 85460996712.09.5938482
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8E0A440009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OKCYL9/h";
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310354;
	b=QxfgMdDZUOqDd68w61KQwgl0EWMWfrekhyaIUtHzuEHI1/OaWufPKV1yV5RghlwTIswjD1
	qupoBTqMTsqdJbaue9xEh7DSH695d4enVOb5OU99c5vGc4BxGmgNNZd3rUkVmUgYFtgSmi
	92iRYg8CKiNrnqMG/dthwTjHGOuJnzI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsah9M7foXNK9QvRUXT+CrvXBmg+yydBay4Gf38+YR0=;
	b=ADBXmCcryR+oioRojCz/lVHqpoJlrrDhcvlacqAy6em5X1KkQhL+F8+L8C1LLwtstoPJkD
	GFCMgl3vjVyMECrP9VoT4jyFvTg13S1lLZ94Lg7YTDsSKT1tlG9HGp6QilmjUWu72OGh1F
	xPx0+d5J9PRhhspnRiHUJGOmrzBpZLE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OKCYL9/h";
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E389F45992;
	Sun, 22 Nov 2026 01:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 207481F000C4;
	Sun, 22 Nov 2026 01:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310353;
	bh=qsah9M7foXNK9QvRUXT+CrvXBmg+yydBay4Gf38+YR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKCYL9/hTzizf7XZIcDjFqE8r5O8mbskYQYtjjuu5GOLp14M71COOK3RHwALYj0zC
	 2RcfvSObeAms8ncoscoqC2z3l/cX6+XCThwhswtfIakGCjHB9B/l4tOAbOJVSd/9Wy
	 GmWvSV+SBiY2b0lnG/GquMH+L79c2Ix9ouvmPuWjh82MtuPSI5HuI79hiWAlfFS5aa
	 YkPBvWYNwDT3bVKWsdM/Ne051P4jMdIUmIHa8yYxCP8FW6+KH9yHXwlOg9nnCJvuUo
	 rMKtkpeWfKdn+0VoaIgnRNPBBMnZz9OkDB9y5s62sj29tnDZHgFB1XPzM8LWaEmcRu
	 oChN4176hN/8Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 14/26] userland: Add USERLAND_SHARE_NSFD ioctl
Date: Sun, 22 Nov 2026 03:17:57 +0200
Message-ID: <20261122011809.2667684-15-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8E0A440009
X-Stat-Signature: erq53p6ceeu9h5cb9kb13krjfqzpi4y3
X-Rspam-User:
X-HE-Tag: 1795310354-405079
X-HE-Meta: U2FsdGVkX1+Ka+FhFkaxm8y6sKQcTfOVGaN5IBDKRJvcGGFdypTdCOPSYQfhGnZa+v/Yles9OJkjRsfN3W+qrJk8E0/e4uV5dtnM2GzqCTfspC42w0ue2KII0IPYYSzy23cb4L68K5qr9WcAU0jpnGKUbTCCoAwFVvdVDlQwIz9xBXL7tddAUArxxGtii7PrVf+ndXkfZKfYm7ZLDE/3abszBnIWGWYrEoAj93ojek9NU1t+s9EaPuC/NDtLM3vlV3Md3cRVjPTCw8wmFPoONZOeuM6LInmVbQ4Ng0Wdqub4UnAJMbz0a6iX7AifSKs+y5BAfgKmp5glfu18XQkI6z1SexsA6kwYT8MzbpPBOCagkYYtz1E0J1batCsW8VX9je9f0bVo1sb2K6gJA0uQVy/0rAV3OLznBOh64f7LG9hnW+bQvaE9HumRDxETgn8PGPHuhDR9wBqsDTrS23k7KGaKo7T1385V+SorLlM9gHYs3fuGBxBxkzGXBXdUcC/Q5CUO6CQ12sAy72Sf4j5qD9jMuceNgD8hXqXYDOTW5ZvvTTHC+WS5MFnFLvqudiGx78cYGeJpyPEwTkcdialC1w5sbnLIFmlEP3ptfCFrUVPvz7UnvNBU4eZtCys7vgxYFUszqXxOcR1ULGxTJaKBN5gHggfthsVr0DFme8S29mrbJbPGc5Z108WsrCY2a0hNX1TlKlZpPX4LKVujGRsNQ9feYaB0cGvYn9A7UV+6Twl+91Cp+/szwzqN7s00JtJqirNNdptCmwIJa8tRkkxU5y/5VWwJC6cfdlXhSuZgyX28On7s2mZn+bpgOC1ltCCc9X4RFnhaVx/mwisINWBROEWZIlH8zCqckkJqmSX9jvlP4JGK1Uk4GooZ4TyTaJVNA3YQjU2ME+t6XKGMiAsO2JccNCGK6RpOTX+UPj7XKEyLpyA+iaoHpBrcBp8UqqVqaeSJ3EyAYOI5aIpLFG9
 FiPFNRl0
 Dl1worIuSySP7gX7LguQD3U6BFHxd2HRFJz97nb+W9jlOJRQgbd7WiAzNc4oguQDbGDAVJr58eLhTmK9UaxMmjwOWi7sXYetn6U1TwqkRYAwel8xjSg5aw1USjXhe9+Idl7VNW7WELk9DL8kOO1DcbbyUAHbSxaJpLxGlzO3LXDh6e1/VC4FtqUQbN5Uw0onFILrhw4HfmqgQTnFG9e3b8NqMbR1NVqJiKHMcGj1vY/rEkTdaqiSjsZMRb1HKRmffdahbc2y/59t5g/KXLy1NMKkLVD+fPx4spZ7PjPHKPrmMQaARJStOk1lwPNGGtKCbARVzFe7jCcriiUH8M13z/gFr4y9ZsxWR/Uec4DM8jzGy9UPJQhMWmKy44A70YSMjVAeVjE0JrDUEOgssOAzNeoNUmxIpNoCTkh2PrgvTIM/fADyfrheVO/43J0C6ngblDEZKKXOqr/RW3JsJsC+FvRM1DRIIF4HNjcMsI+nXj/0dp1PmFkG2qvM1sLO+rwkV0FXU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

userland_open() isolates every namespace by default rather than relying
on unshare() deny-listing, which prevents workloads such as
host-networked sandboxes or sidecars sharing a network or IPC namespace
from opting into specific existing namespaces.

Add the build-phase USERLAND_SHARE_NSFD ioctl to replace the userland's
cgroup, IPC, UTS, network, or time namespace with a supplied nsfs file
descriptor in-place under userland->lock while the userland is still in
USERLAND_INIT, rejecting calls with -EBUSY once CLONE_INTO_USERLAND
begins. Require CAP_SYS_ADMIN in the userland's user namespace, and
require CAP_SYS_ADMIN in the target namespace's owning user namespace
when the caller is not already a member of that namespace.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/uapi/linux/userland.h | 14 ++++++
 kernel/userland.c             | 92 +++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/include/uapi/linux/userland.h b/include/uapi/linux/userland.h
index e81a06d6e9eb..addb84e996f5 100644
--- a/include/uapi/linux/userland.h
+++ b/include/uapi/linux/userland.h
@@ -41,4 +41,18 @@ enum userland_flags {
  */
 #define USERLAND_GET_NSFD	_IO(USERLAND_IOCTL_MAGIC, 0x01)
 
+/**
+ * DOC: USERLAND_SHARE_NSFD
+ *
+ * ``ioctl(userland_fd, USERLAND_SHARE_NSFD, ns_fd)`` replaces the corresponding
+ * member namespace of ``userland_fd`` with ``ns_fd`` (``CLONE_NEWCGROUP``,
+ * ``CLONE_NEWIPC``, ``CLONE_NEWUTS``, ``CLONE_NEWNET``, or ``CLONE_NEWTIME``)
+ * while ``userland_fd`` is in ``USERLAND_INIT``.
+ *
+ * Requires ``CAP_SYS_ADMIN`` in the userland's user namespace, plus
+ * ``CAP_SYS_ADMIN`` in ``ns_fd``'s owning user namespace when the caller is
+ * not already a member of ``ns_fd``.
+ */
+#define USERLAND_SHARE_NSFD	_IO(USERLAND_IOCTL_MAGIC, 0x02)
+
 #endif /* _UAPI_LINUX_USERLAND_H */
diff --git a/kernel/userland.c b/kernel/userland.c
index 7b44f400dc23..efac9e4f2fa5 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -24,6 +24,8 @@
 #include <linux/nsfs.h>
 #include <linux/pid.h>
 #include <linux/pid_namespace.h>
+#include <linux/proc_fs.h>
+#include <linux/proc_ns.h>
 #include <linux/time_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/uts_namespace.h>
@@ -118,6 +120,94 @@ static long userland_get_nsfd(struct userland *userland, unsigned long nstype)
 	return open_namespace(ns);
 }
 
+static long userland_share_nsfd(struct userland *c, unsigned long arg)
+{
+	struct ns_common *old_time_children = NULL;
+	struct ns_common *old_ns = NULL;
+	struct ns_common *ns;
+
+	if (arg > INT_MAX)
+		return -EBADF;
+
+	CLASS(fd, f)((int)arg);
+	if (fd_empty(f))
+		return -EBADF;
+	if (!proc_ns_file(fd_file(f)))
+		return -EINVAL;
+	if (unlikely(!current->nsproxy))
+		return -EOPNOTSUPP;
+
+	ns = get_proc_ns(file_inode(fd_file(f)));
+	switch (ns->ns_type) {
+	case CLONE_NEWCGROUP:
+	case CLONE_NEWIPC:
+	case CLONE_NEWUTS:
+	case CLONE_NEWNET:
+		break;
+	case CLONE_NEWTIME:
+		if (!IS_ENABLED(CONFIG_TIME_NS))
+			return -EOPNOTSUPP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!ns_capable(c->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+	if (!is_current_namespace(ns) &&
+	    !ns_capable(ns->ops->owner(ns), CAP_SYS_ADMIN))
+		return -EPERM;
+
+	scoped_guard(spinlock, &c->lock) {
+		if (c->state != USERLAND_INIT)
+			return -EBUSY;
+
+		__ns_ref_inc(ns);
+		__ns_ref_active_get(ns);
+
+		switch (ns->ns_type) {
+		case CLONE_NEWCGROUP:
+			old_ns = to_ns_common(c->ns->cgroup_ns);
+			c->ns->cgroup_ns = to_cg_ns(ns);
+			break;
+		case CLONE_NEWIPC:
+			old_ns = to_ns_common(c->ns->ipc_ns);
+			c->ns->ipc_ns = to_ipc_ns(ns);
+			break;
+		case CLONE_NEWUTS:
+			old_ns = to_ns_common(c->ns->uts_ns);
+			c->ns->uts_ns = to_uts_ns(ns);
+			break;
+		case CLONE_NEWNET:
+			old_ns = to_ns_common(c->ns->net_ns);
+			c->ns->net_ns = to_net_ns(ns);
+			break;
+#ifdef CONFIG_TIME_NS
+		case CLONE_NEWTIME:
+			__ns_ref_inc(ns);
+			__ns_ref_active_get(ns);
+			old_ns = to_ns_common(c->ns->time_ns);
+			old_time_children =
+				to_ns_common(c->ns->time_ns_for_children);
+			c->ns->time_ns = to_time_ns(ns);
+			c->ns->time_ns_for_children = to_time_ns(ns);
+			break;
+#endif
+		default:
+			WARN_ON_ONCE(1);
+			break;
+		}
+	}
+
+	__ns_ref_active_put(old_ns);
+	old_ns->ops->put(old_ns);
+	if (old_time_children) {
+		__ns_ref_active_put(old_time_children);
+		old_time_children->ops->put(old_time_children);
+	}
+	return 0;
+}
+
 static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct userland *userland = file->private_data;
@@ -125,6 +215,8 @@ static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	switch (cmd) {
 	case USERLAND_GET_NSFD:
 		return userland_get_nsfd(userland, arg);
+	case USERLAND_SHARE_NSFD:
+		return userland_share_nsfd(userland, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.47.3


