Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9549560A380A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EVH5lsyK
Received: by kanga.kvack.org (Postfix)
	id 23AFC6B05C8; Fri, 20 Nov 2026 19:10:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4026B05C9; Fri, 20 Nov 2026 19:10:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B8C6B05CA; Fri, 20 Nov 2026 19:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC6F36B05C8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:10:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97478160268
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:02 +0000 (UTC)
X-FDA: 85457193444.28.6DDA7B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E113B180004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVH5lsyK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219801;
	b=NN+NMigr0p0pmP9ugfpA3ym9LjmnO4LkUIqTsGl0U7whekpw1zlLoOd7JBqeVpR/u2ZBDR
	0N03AahlaBz0FIq68D7xp0g1trEARLmsxcNbjaoLI3tB3C6QUyoGdDYw/pmi8RgoPna9DZ
	ObhhtqS+RuozoxDpVLFFj1fD7LIoQCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNImKxX2bLw9d/2f70sP1UeR26evmgWSkqbTpNpXbl0=;
	b=qCzERIvUpcX3EaGmRR7QJhGjxCXwUXUlCbLZHDI/MKbvPV4mef5JpcbAXwQbDyG6M+GXSx
	s545UsXmZp5VrVfswM6w8LLVFAMX5KuYfds8IOx5D+rDM3scwRox6xEikIMLBCAVz87uJH
	7jRcVEKCEwoA+JFjAmUELsPt1ycRUpQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVH5lsyK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 7A95B6234E;
	Sat, 21 Nov 2026 00:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9EDEB1F000C4;
	Sat, 21 Nov 2026 00:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219800;
	bh=SNImKxX2bLw9d/2f70sP1UeR26evmgWSkqbTpNpXbl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVH5lsyKLLdg413PMHFk2R7SN0jI2u3gI5FXbU2jXZ8Kk1zm14WIaDl1QeVkhyKVm
	 WxbQUFopy0FWxT4TgoEoRtnlUAX3TLCu+aFi5on9wm1I3Hcx6dGKwz8Qmggyeai9b6
	 L8MLxik4JpuLPdHm+vMUmd9nkDjp0+P4xVgWsbNewpi9xdTH72gjjHDQLFaaqUyxvF
	 mRwtqmnUtXn+HaIbC55u9AgHhjuzcWI1BE2LMwHQkNkoDSjV/EAaDKbn87+SQ794dJ
	 6QpYOKvthuoKdt8nQP9A5DnfXguVCI6mKaHMeRTIsxecXEDH3yc+UiwObPl3tgSwzE
	 QGg53Xuc81eBA==
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
Subject: [RFC PATCH v5 15/25] rootns: Add ROOTNS_KILL ioctl
Date: Sat, 21 Nov 2026 02:08:34 +0200
Message-ID: <20261121000844.1863324-16-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E113B180004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: fc718dxgq593fdmrn53iazo6hbtr5uu6
X-HE-Tag: 1795219800-137388
X-HE-Meta: U2FsdGVkX19zax7UAZZO/0HenSfaykdqar+X2VhysIuX8vG0xEeTetu1UuiBV5pym6lxOhsV+iEJKrzFA8eVwph+eckBPxlkBRJ0IjDrudZS65E4DL0Rn6ZxF63luaXXT+6n29ri2wXRfIs8uqEbHmrmUBq3gsXPU5Zv2QzRaqk1dltPwKTXw0DbKwxzfAMn2lfYE6tbCLvkbwawdf6a8ZafMB5QaqNLM/pAL6D174JP7CemXaWzIxo1dIl72F81jwZ5THKtUR2fRFw9sKWsau6Fr/LVuo3MUlvjgWyfSlvh4wOcZuWlorvk4swEtlkpi2cUJ2SsKjFloPVjPUoJ4PABsAnRmwPlORfU1bfwBodfD/e5UcOIzHoBG4MkM8HjF+dvgJlZDV+jSYGFjiOWDnDeDdi0lmzgXoTIplfm5JYTYmYpXkcwYTp2CvKCP2JhqMnS1Xgowxq8Hb/3PDfiseh56IIr0P8Ta6bbW0vxkVaqrTYCUa+IM8TWZFTRfpL7UDp6UAv543rmOvcKbivPXUuOH3QrpA3eMK1nWKsfsdcLTMJoQXOvzsFEt40RAum+USjFPFcHCHoXo/gE5ez119VYlvqlqmG1F0Z14h0IFkHz8gl6tkV3ET/fAnokcVNM94qa9LRwwtbegJfAHFqLsSlyHYP/358mkK0P9xU23mbYAvph/c6h15wsiRW6wc/p2/OIBTIGUVXVd9K/j9uyw+Htta7tfuOEh/FB7/BptQ6rV71VRAsgG8r/Yq0lKUKmH8ldQ0zLQrgE8CZckOswz2Ipywr4kybYA1iNQISGFpQf8z8pRZqQpTOd3oHBEryJ/CTsYtEe+xcmeZvhk8i0wzpaxk+E5j4o1hRLN/DWKqYD0jPhrjgSQhUTTazTGTykO2+ZeeM/PhYrs+FDQoA4glPhCZDRcP5b4e5z2JOU9WkaHUxraZebZMuAhv5+Z+Ab0cJFI9mYFWGhA+AP+5M
 0qA152Zj
 wCO16q+hRBUHBI8NIc+vOwWWXKzcwtVfiWmzRBX9Q1yfCORrxBc02TkFmUqtKV4lA4gGwucV6rbuE/V7dBleOFR0s3PM96/l2HQhNcquo1Ig0/5dZQVmGgGi1jXJZfzUpTAoxG8g8NhLoJogj/NAjrNHmD0p5lwITJWjRAaz5QL0Z62BHuJbXyRZPCfax0zdTZgfcpBUy4qaQylLjjF2ZZs/+s9O0kBhHf7qA7MjCgjkMM19qNHVcyO3Eq+/ecMxdLsu7RL3Qbz9rJdlRxZr4jxHjukdZ57L0xQ5qiAvLuoH72HzZXqNyA68jZXd9DVAovg6smz3rNmooTz5h4eGFtN+HW9fV9MGuspjxaJMjK87QhnySZck+0sFeFVxktxiCtt7FnPV7Z4yE6KA4ZT8snOJzOIiKtAcU1GJgC14qFq1iyVQZueqe26qcgY99sYdfgd22E23DEcpEK1a7KD2+w3TEcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signaling every process inside a container from userspace via /proc is
racy against concurrent fork() calls.

Add the ROOTNS_KILL ioctl to require an ancestor active PID namespace,
walk the root namespace's PID namespace IDR under tasklist_lock, and
deliver a validated signal once to each thread group including in-flight
forks, aggregating per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/uapi/linux/rootns.h | 13 ++++++++++
 kernel/rootns.c             | 52 +++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
index 3fd215185398..acd91d895c63 100644
--- a/include/uapi/linux/rootns.h
+++ b/include/uapi/linux/rootns.h
@@ -67,4 +67,17 @@ struct rootns_wait_args {
  */
 #define ROOTNS_WAIT		_IOWR(ROOTNS_IOCTL_MAGIC, 0x02, struct rootns_wait_args)
 
+/**
+ * DOC: ROOTNS_KILL
+ *
+ * ``ioctl(rootnsfd, ROOTNS_KILL, sig)`` walks the target root namespace's PID
+ * namespace IDR under ``tasklist_lock`` and delivers ``sig`` (or ``0`` for a
+ * permission check) once to each member thread group.
+ *
+ * Returns ``0`` if at least one thread group was signaled, or ``-1`` with
+ * ``errno`` set to ``EXDEV`` if the caller's active PID namespace is not an
+ * ancestor or ``ESRCH`` if the ``rootns`` is not running or has no members.
+ */
+#define ROOTNS_KILL		_IO(ROOTNS_IOCTL_MAGIC, 0x03)
+
 #endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/kernel/rootns.c b/kernel/rootns.c
index cb74ddc8363c..5ae975604571 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -158,6 +158,53 @@ static long rootns_wait(struct rootns *rootns, void __user *uarg)
 	return ret;
 }
 
+static int rootns_kill_members(struct rootns *rootns, int sig)
+{
+	struct pid_namespace *pid_ns = rootns->ns->pid_ns_for_children;
+	bool any_success = false;
+	bool any_other = false;
+	bool any_perm = false;
+	int other_err = 0;
+	struct pid *pid;
+	int nr;
+
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+		return -ESRCH;
+
+	scoped_guard(rcu) {
+		read_lock(&tasklist_lock);
+		idr_for_each_entry(&pid_ns->idr, pid, nr) {
+			struct task_struct *task = pid_task(pid, PIDTYPE_TGID);
+			int err;
+
+			if (!task)
+				continue;
+
+			err = group_send_sig_info(sig, SEND_SIG_NOINFO, task,
+						  PIDTYPE_MAX);
+			if (!err) {
+				any_success = true;
+			} else if (err == -EPERM) {
+				any_perm = true;
+			} else if (err != -ESRCH && !any_other) {
+				any_other = true;
+				other_err = err;
+			}
+		}
+		read_unlock(&tasklist_lock);
+	}
+
+	if (any_success)
+		return 0;
+	if (any_other)
+		return other_err;
+	if (any_perm)
+		return -EPERM;
+	return -ESRCH;
+}
+
 static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct rootns *rootns = file->private_data;
@@ -167,6 +214,10 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return rootns_get_nsfd(rootns, arg);
 	case ROOTNS_WAIT:
 		return rootns_wait(rootns, (void __user *)arg);
+	case ROOTNS_KILL:
+		if (arg > INT_MAX || !valid_signal(arg))
+			return -EINVAL;
+		return rootns_kill_members(rootns, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -180,6 +231,7 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
 	case ROOTNS_WAIT:
 		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 	case ROOTNS_GET_NSFD:
+	case ROOTNS_KILL:
 		return rootns_ioctl(file, cmd, arg);
 	default:
 		return -ENOIOCTLCMD;
-- 
2.47.3


