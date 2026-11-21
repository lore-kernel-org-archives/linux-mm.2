Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E7660A6F66
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZ7QEq8W
Received: by kanga.kvack.org (Postfix)
	id 288AA6B05C6; Fri, 20 Nov 2026 19:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2119A6B05C7; Fri, 20 Nov 2026 19:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CDD6B05C8; Fri, 20 Nov 2026 19:09:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC9E46B05C6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A7C78020E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:58 +0000 (UTC)
X-FDA: 85457193276.17.2B99D5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7D14D40008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZ7QEq8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219796;
	b=n/9tDZfj0xRTx3Nw5TlwRHjG6xMyxVMMtmwpQKN8mQ6T7SWgTF6NC5ZT9w7iNdSAjWJRGW
	r1MOWyiUay6vhjZW5UVUh4EzUTK30S2YVbs852/xPlF5RjPr/cJ/KIJy+IOgDFMeBIh+Lo
	fKvR5CMqN5BO3s2zz4JFhs7hYfbcau8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUPm8hcXsD5eOEjWcMgviJk+m28ETz0ZEKJMYNL1zxw=;
	b=ajibeFQi31ibhXlqDERiimkIQRq6aUe0bCbXYDbynra6XYJ/gM47h7xz0Ft6wa/Y/KVshE
	0WnEL3UHbvxfhowcIlAdwLew/FrRx7zEqCn0Niey5JT9m4X+un0kD9jwE1ozw98S0NZHYB
	Ou7+g+0Nr/J/XiOYKAtVxh9dxUWDtrM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZ7QEq8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id CF60944061;
	Sat, 21 Nov 2026 00:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 20BBB1F000EE;
	Sat, 21 Nov 2026 00:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219795;
	bh=hUPm8hcXsD5eOEjWcMgviJk+m28ETz0ZEKJMYNL1zxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZ7QEq8W4PyqW/qT6hinM44l4wrZpmfeOC9JOLKK2k6wKiN0e1qfZqkzP0UeGB91T
	 FjWoocLZlUeY8+VY37AuOxfG4t7/QzYtAmFvcXZ6H2I7b1qkFxUq+87V6A1XX3h3KE
	 fMsWln9AAQyWd2q0sZpQ0IsDZDZTyyWktN4kghO43q10fKlnRXGzJomJbPQg1Rbz7G
	 DP9i0NkXw3jSZUIHsTs0dtNfsJoSgiLX4ERp86rnP5yosVsCesjlJEDyNBTK6xG5b5
	 xS+z19fkG0n0gvRxR2mZxvxqNjkdeF6J8JgbmTA4zN5twSFDiWPGatBmO2Yn4ArTzQ
	 tnyqYo9ce+gvg==
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
Subject: [RFC PATCH v5 14/25] rootns: Add ROOTNS_WAIT ioctl
Date: Sat, 21 Nov 2026 02:08:33 +0200
Message-ID: <20261121000844.1863324-15-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D14D40008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: deongqsy3h3x1ah35cr6ictzk1a7xnxd
X-HE-Tag: 1795219796-457544
X-HE-Meta: U2FsdGVkX19hL8swzcc9nfuKXGR8lz+3ZT5SvZ2QQGJkw4OsMnT55yYtISkS0nk6Ffl542Sv+KIohVQm3QzcO8W04oxnqKtDEvzQKt/THjevjQeMGezcMakOhktgrsw3uvNA7bdSUFCitQPuo2w1mf2YXgI1zTi+lOpKwcRhGDrBCd891L1hSGhR+45ZcStpFb+5sdtM3cZocaHQxDXiKIQUNa0LVLkPE4kzcIislgTJ9GFQtlt97UeBxF/BJlLKauvuhdqWNuwYvp3Kw2H9l6rI5dAKuBSejdEZsZvrv5Tqs0qYCvKwy23S7smgVHw06COv5vbu6zlHskLTZnaOXObdoHfWAXz59+Lp6D5V26/w2ZTNxBcejCkt+u0YFrAawVP+fcGgU81dCUvqnkpwTksREPJgxMBPVnVg+ykt2sv5ea1VEJRL+2XsyZ6aBoWbkEx7lISisgHhkCIBBU2rZvWEzbBPzwuSSA6mk8ZhfUQbiKZ2yYJ2HO1+FEJyxilJynvY92i3UEFwQ+rTIV7ZZt6SR1dvmKT3JpUaY390ufEZvgtRwRa7uCLdqCKN2E2KrVqSZiojG8RZA5Wv1cfBnoje8tDfmf7iZpRtFAZEotsLVGRG2u3yutzR+nBRB6elh07B4Y9/Z5+mPewnLG6cSdZ4p6983lCYeEsa/1XSeYc7wgYAkmjgJU2UhRkVKYecYXm1tudzBGciPL0CBdbpqJqKrnvcoRxst0a/kAb2TfZEX4FTEf6/OCB+NVb6hnUmDpv0w5X5UyYuvWDpvsTBZWAw6gFp1PM1JttTN2xVNDFghVKBUMZQrv4CB85XnMTQqMEI54U80ioUda9S2AVLvSEB/JC/mamVEIAiW/1jfP0R2hiiQ+qVNzKUCyrzDu7KdQiSGv8LXq+A9JSNOrNhyk2SWL2klkfOTxTDW1YhVN0DF/YmTviPfdhkN1YE+kXZ8UNXKa4Msll2JLuLS+l
 SVqDWLS0
 GUxeBS+mpKSimrCwXGdFxy1ar8P/owfwJXB6cEhneHJTjb0Ty9oCsTC+bMmFzvu8nFWu8x/EvwXZ7o19r04OhqyvlquW9Mq7RDmleo8+6OmZY0nXGpNJrHfk7sPvkRlnK0jZMXEs723uIM5AMLC3Z2KUuGHsZe2uSX1ytb3lIMUVWT06jRPgJGtOelUaDQbv1yMvE/i1UaNgmgDd+QeLra5Eh/cZ82rByivfb7G8T3GsnjGJ+Lt6indWhv1w5RtVSFmcpv7W1glI7zktmwoo/B7v1L+FpqfoCTTC2eufaEDyHcCQmYSQkz/Etc9v1dZBkHDUFRPN1xNfeQha/bv7wvsAM9vdw+YvqHhzFDzgioZLvobuTftGhemaS7ZWas5lpcq4Tfp0Ajz4pyugCEajA3ag1t/nfCZGjGpoSZAwHez1C/y/hY51jViYK3IFVJaWtDbZb4Mc19zrBOxIzl3fD3pzB5SCw/+Eb+cdsKB2eeKiTstMMlSyTNXYidA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wait4() and waitid() only allow a parent or subreaper to collect exit
status, so an external manager holding a rootns file descriptor cannot
wait on a rootns init process forked by another process or observe exit
status multiple times across observers.

Add the ROOTNS_WAIT ioctl and struct rootns_wait_args to wait freezably
and interruptibly on a rootns file descriptor until its init thread group
exits and report the recorded wait status. Return the init TGID
translated into the caller's active PID namespace, 0 for WNOHANG while
running, or -ECHILD if init was never started or is not visible to the
caller.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/uapi/linux/rootns.h | 26 +++++++++++++++++++++
 kernel/rootns.c             | 46 +++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
index bd643bdfb43c..3fd215185398 100644
--- a/include/uapi/linux/rootns.h
+++ b/include/uapi/linux/rootns.h
@@ -8,6 +8,7 @@
 #define _UAPI_LINUX_ROOTNS_H
 
 #include <linux/ioctl.h>
+#include <linux/types.h>
 
 /**
  * enum rootns_flags - Flags for rootns()
@@ -24,6 +25,16 @@ enum rootns_flags {
 	ROOTNS_ALL_FLAGS	= 0x00000003,
 };
 
+/**
+ * struct rootns_wait_args - Arguments for %ROOTNS_WAIT
+ * @flags: Wait options (0 or %WNOHANG).
+ * @status: Output wait status of rootns init in waitpid(2) format.
+ */
+struct rootns_wait_args {
+	__u32 flags;
+	__s32 status;
+};
+
 #define ROOTNS_IOCTL_MAGIC	0xB9
 
 /**
@@ -41,4 +52,19 @@ enum rootns_flags {
  */
 #define ROOTNS_GET_NSFD		_IO(ROOTNS_IOCTL_MAGIC, 0x01)
 
+/**
+ * DOC: ROOTNS_WAIT
+ *
+ * ``ioctl(rootnsfd, ROOTNS_WAIT, &args)`` waits interruptibly (unless
+ * ``WNOHANG`` is set in ``args.flags``) until ``rootnsfd`` reaches
+ * ``ROOTNS_DEAD``, then writes the recorded exit status of ``rootns`` init
+ * into ``args.status``.
+ *
+ * Returns the caller-visible TGID of ``rootns`` init on success, ``0`` if
+ * ``WNOHANG`` is set and the ``rootns`` has not terminated, or ``-1`` with
+ * ``errno`` set to ``ECHILD`` if init was never started or is not visible in
+ * the caller's active PID namespace.
+ */
+#define ROOTNS_WAIT		_IOWR(ROOTNS_IOCTL_MAGIC, 0x02, struct rootns_wait_args)
+
 #endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 5d59fc9a591d..cb74ddc8363c 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -117,6 +117,47 @@ static long rootns_get_nsfd(struct rootns *rootns, unsigned long nstype)
 	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, nstype);
 }
 
+static long rootns_wait(struct rootns *rootns, void __user *uarg)
+{
+	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	struct rootns_wait_args args;
+	long ret;
+
+	if (!uarg)
+		return -EINVAL;
+	if (copy_from_user(&args, uarg, sizeof(args)))
+		return -EFAULT;
+	if (args.flags & ~WNOHANG)
+		return -EINVAL;
+	if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children, pid_ns))
+		return -ECHILD;
+	if (READ_ONCE(rootns->state) == ROOTNS_INIT)
+		return -ECHILD;
+
+	if (!(args.flags & WNOHANG)) {
+		ret = wait_event_freezable(rootns->waitq,
+					   READ_ONCE(rootns->state) == ROOTNS_DEAD ||
+					   READ_ONCE(rootns->state) == ROOTNS_INIT);
+		if (ret)
+			return ret;
+	}
+
+	scoped_guard(spinlock, &rootns->lock) {
+		if (rootns->state == ROOTNS_INIT)
+			return -ECHILD;
+		if (rootns->state != ROOTNS_DEAD)
+			return 0;
+		ret = pid_nr_ns(rootns->init_pid, pid_ns);
+		if (ret <= 0)
+			return -ECHILD;
+		args.status = rootns->exit_code;
+	}
+
+	if (copy_to_user(uarg, &args, sizeof(args)))
+		return -EFAULT;
+	return ret;
+}
+
 static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct rootns *rootns = file->private_data;
@@ -124,6 +165,8 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case ROOTNS_GET_NSFD:
 		return rootns_get_nsfd(rootns, arg);
+	case ROOTNS_WAIT:
+		return rootns_wait(rootns, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -134,6 +177,8 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	switch (cmd) {
+	case ROOTNS_WAIT:
+		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 	case ROOTNS_GET_NSFD:
 		return rootns_ioctl(file, cmd, arg);
 	default:
@@ -328,3 +373,4 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
 
 	return fd;
 }
+
-- 
2.47.3


