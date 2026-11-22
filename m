Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDE360A2618
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLXGB7rR
Received: by kanga.kvack.org (Postfix)
	id D7CE66B05C3; Sun, 22 Nov 2026 14:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53E86B05C4; Sun, 22 Nov 2026 14:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1CF56B05C5; Sun, 22 Nov 2026 14:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7EF6B05C3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FF621C40CC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:59 +0000 (UTC)
X-FDA: 85463762958.28.ED5106B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7193E180004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLXGB7rR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376217;
	b=sm8sjEoukklzfOzl2HN+ul6GpbIFIympXr2PXqD8B4f7rNpy+xh9ooc4mHqhHwan5467qG
	sF1J7NlJ8bPgYtnJEdc8hIRCpfYAeLFgpqMIHIjEkDeDN5q/BdxZ3iBSHHqqd6JQCGoJ+Y
	KYu2jPcOTCmntuoZ7vF5/jnjyjlp+u4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3T9ruqYmyUMm2PturUvOibjyAbGjGhILSaT845gaFc=;
	b=Neyv0if0PueVad/K7QhX+3kCd22lXYe3HWvnjuOqeo/6FZouSeJMLO6OI+0kYYJ9mEB12x
	1qNgi5p7xZxjoG3Q0SioAmwv4vfNW/sLQJU70ZStBEtEZgbaw+27gplg1gdvw5x+58/dj9
	W4nudV98gi2/CeydhX1JNLReDmyV4LE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLXGB7rR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id C2C4E400B7;
	Sun, 22 Nov 2026 19:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C66B41F000D3;
	Sun, 22 Nov 2026 19:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376216;
	bh=M3T9ruqYmyUMm2PturUvOibjyAbGjGhILSaT845gaFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLXGB7rRUoPcsnXokx7eTA9UTxhJink/6OLXJGpNkEFY2vQ5ps/e+pGglAWeRcaZy
	 D69TpTHUFZDEOPfMLaTzDAccup185NJA00nIa8btD/j/K/zihji2qj/Vqjt2BQKDi9
	 FYCn+JcNcPp3veWxbC/LRh3llVICiuCsHqaWjqx19tfPo+rGSqglic/fcJ9MQdqKCF
	 FF4p0vGPssWSmi+bP5G6CU0qfVbppBr8xd1T9UblfWxxS24gRoKkiK1tirJ+HWETmh
	 8sF7LOOQkYd4jwAWNIzSKz7TKlJ+RbYJWtKR2bRLtgyX8zh3eaEwpQx5q0u0aHO/vr
	 FiH7u4+X8bHMw==
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
	Eric Biggers <ebiggers@kernel.org>,
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
Subject: [RFC PATCH v7 14/26] userland: Add USERLAND_SHARE_NSFD ioctl
Date: Sun, 22 Nov 2026 21:35:27 +0200
Message-ID: <20261122193539.3334213-15-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7193E180004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: yt9p9fzauckgpr4if53otsd5b3wks7nr
X-HE-Tag: 1795376217-803554
X-HE-Meta: U2FsdGVkX1+p13NrPUDJTk84PwAiyXzFebuGfeHX0cXUQucZmmOKblYcJ/lxJRlpulqVUQm+yOfLGviEIJosqUNW3JlWl37Wpsnofw6GNI1ykzwKkn/sU3oKNgtJB3Aru2c96Hu8AOkcNGUAfC2aEaZ2zVPRJ8RawJ5/qBDpcj/9x7v2gL/yCRCLDFwmpdv/5t3R8Ca+eUBAOBxECj1WA2HgR89uhGKQc31IxvKPE4xmQJlZig621rql9C72dvHnFHdA77wDOWjsHT8lf4yE27udk+epD/njM5XKtHHXCH+ITt/4ne8DpCyLRY+PscSLAjEnV8QhH/lZmxmSJ7Ol9M/V9UxNrw034CNjZYGN7prGkS2eTsiDnjipilh4/ABTf9vjtt+AhO7TiCQjyOG53/Vrw8cm6a6ZxG5wg65FTurP9LyEARuLQ2fxN4v9UT/iJxUV/EAeDyzgSdiFtl4adtuds65SsWBlI1SfQJ3UAW1eNiIydlo0EOUYAT63T5QfJTeqvndQZd391VHu3h+ZEbaTldyp2e90WYkeqskP8riAq86AMR9tuRsDa7XpftMnrFg6ZaujGuX70GbcUb0Z002d6COU2sfyhAi5ZKjXmpnKo2JmBxil/rlEVj9k5nerNSQIwkqkS71qggj6kPA5bd+a0xJMrsNdRvLM1ZCt9jA/MkmbxvUAHXsZmr8xzdurhg7NSmTvl2JU8RoYtwebw60oFQgf7+OFGynZkC1EmAdRLuP9BPh5I/AHUaR+LlvUeTuejJVy5E8soSBADVU1stpChb6AirBf8qPqps0OBkTqQHEHSPNxHVYRy8MHOPM9mGLgNmtK4kdr3vYIR63D41LVMze0DOBcnfZuWUD63OGSzHVNMnKQcEBXPeIWHoza86fsNXaZ+dVytyaSFrGfvuC7AGo5btABxnXkX5ooRHZ/TZsaCba9Fx5snnypw0vCsLCaF5xWX3M6xEuUgtf
 JaT50nld
 fjec49drYF/XE5MD1qYcNSluIyOtfZNaPFKd3i7tZIKrQF4XS/Ghqzx2inxdxNxxgX9E1zJluNyel3FozTEcg0zMWjEEwpVIRysm2j++jWK/g1d+5CqGLSS4Gs5TZZk5TpPa9nQYmBnVQMgXU62YGbrVNiRa5dOdrO3KGmdjIozZ1oPFJa7Lo8CW3/V9SczCzKNMcyeiEBUvtOA24oDBYjFH6rihFNUxSTThgJee3FIQ0AcKB9/dyWn2TIKoTQVQ7OD9qZXeUGq7A8YdknuLfMaGDCGN+sz0dNTdedCQmy/wEbo9nHCYZ69HT0K2Jq3jIROVeOYqh1GN+CcK6z8rRSaxQfgxVBjkq7dfOnlSFGrvzt2/MselhAD33SHUoTCtmmzQ7CY8hHpzRvB4cPnKIMd2NivU3Q12Ujwc4m1uCOw8RaXmfoUYSxufB7U+UHLFJe8mzvyUY55FVSufquJyLm5BwZw6tyQhV4hg9sVzgudDm/I3TNGgIQ93Lq3MCdqJrGkWQ
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
 kernel/userland.c             | 90 +++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

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
index fd5f67c0245e..279b92e7b7f8 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -31,6 +31,8 @@
 #include <linux/nsfs.h>
 #include <linux/pid.h>
 #include <linux/pid_namespace.h>
+#include <linux/proc_fs.h>
+#include <linux/proc_ns.h>
 #include <linux/time_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/uts_namespace.h>
@@ -125,6 +127,92 @@ static long userland_get_nsfd(struct userland *userland, unsigned long nstype)
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
@@ -132,6 +220,8 @@ static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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


