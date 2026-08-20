Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D49C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 05:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81FFF6B0095; Thu, 20 Aug 2026 01:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7576B0098; Thu, 20 Aug 2026 01:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6D36B009B; Thu, 20 Aug 2026 01:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 457DB6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:45:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5403120551
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:45:52 +0000 (UTC)
X-FDA: 85120561344.22.5ADD5EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A115F80002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:45:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qmiqXE62;
	spf=pass (imf02.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787204750;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRQMhgQZ0uB1KcnqgUZVzvnLylqWy/vNI4GUNycz2X0=;
	b=UhfOuDwxC+jo+rovRatGc1xYlC1hAj47c8mOoNwYhVORH/ovck31T1PDut6a+rH6rG9gtY
	VjjK9D0ED7PtQLKsF7P9EhAYKl8DNSQlAPRIWRTeJpymEFZfyxtFmYrLGttU1Pu6i9mrAb
	NVB3xl2UDh4E/hrdHItTR68MGtB4Gaw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qmiqXE62;
	spf=pass (imf02.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787204750;
	b=WGpN/mZQfhs+TRDTLuf68z1H9T2fc53wTGSI+Kqji+K34VqKxGxH7n4FerszFlwXSaFYRU
	+V5rmwwlwky4jq8/1xPwaGaUQK7AychssNrPrDWjSbxcpMbCHTIUCymIWbn2TttB7A9glN
	7ZljHM0tiGfB1yQI1dfU8mYBicmnHtU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 428DE44F1C;
	Thu, 20 Aug 2026 05:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F940C2BD01;
	Thu, 20 Aug 2026 05:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787204748;
	bh=iT2d8jNSntdRNkVd6yfoX9tHjD9vzNf6W9HD4FkXCKE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qmiqXE625IAdmNF9AP5fl4tXPxubPLKzHJGtH0PCX+eLx3lwT51miQZuRl3o3e080
	 j8+VN64CuGjPKQey3LP7c/my/rC4dM9FyOTAFkyMdxlXuy+G0JIA8TWsGbw1tTZrc2
	 +4TX8q73m0/xNYUML0TnMyUXpNPAG/vgYuVI5r+W8I3cOY/EG2gjBaxTW2ZH/16d9g
	 f/YUc6P1mFn2b2EqYOsaSv8ULhRRGF1zXhckcWVDUZ38XJ1pYahnchuD+aFU9YYLTw
	 Lt7eeQ5GzM7x0D4EXWhSGMnnHpx2VokDNi+xn5KzER26ifyC77qWbjscb/xsnsrLlc
	 yZLC2ZGetCCqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2A1C5DF81;
	Thu, 20 Aug 2026 05:45:47 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Thu, 20 Aug 2026 13:45:41 +0800
Subject: [PATCH RFC 3/3] pidfd: Add task path ioctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-pidfd-get-paths-v1-3-ac3eee4003d5@black-desk.cn>
References: <20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn>
In-Reply-To: <20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3688; i=me@black-desk.cn;
 h=from:subject:message-id;
 bh=SyCJ8ZXQnkLR08IG8rcsufXrwQOP/Lvf27zOyLS7qI4=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqhpSJDhbniXO7VTnsBnYigbwYSqL0ydwoM9Upl
 DHXQvTB+v2JAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaoaUiQAKCRB2HuYUOZmu
 i4uqD/44j22S8gnOub6Zv/RbvFFh+uGAZv+rI+zrZnRo0odFcT7RMRBXrmCjhgzjHaCfSGEh3go
 mKUGkE2toky5oYmwVGdcLNETa6r8Fkw8ejN2u4djgO+k1WnqZ85vWLv4dw6ztS/tvP3UYr2ZzyW
 oXz7bbJi2+QWDj5dJibicHISv2mJzbin7aoW81vuYpFbXKQDlQ3UfeweBr6KqOC+z2qAh+BzQy9
 fLpiupREES4xfVqGiNsx0ZdUNNuBvyopwM/y+MzSw2y06+yNVoALSW0wbLAb1q8ixeyb1Wm4l20
 Mn65ZwUpyoVIyFZ6eYmiI6QyNFQ0SIjBg0Tjs/1FBWh4+70HRdr6ozRgAd0ebsXnUc1B82Qyb6u
 c8D+jhn1Q74lzZis9aBVXdVk1HG4dx2qeWS4uRGyHEFQSNaymcwQLVZRHu+jDL+2A8yqmQozWgQ
 k3LlT8i6AXHTO9pM5L+8Nqt5DrL1jixakTMoy0+thK3k6hGAt6vLgRQ41W0nP3qABxzeR86v0hX
 daVgR6Jia3Lbl08T0/Y15G3+fYNwOyrt923CwlW+KUEzTUbqaPbdQx7nq+ppTkW71oAyeOBqtOT
 7NVEMgwxydtPT1Xwk5+b/ORdVJmf+emeBIERqfcH2Or+zLQr5iT94ebNJjbUITowzwY/iWNFCpV
 QISSKSU3JhyWBjQ==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/default with
 auth_id=573
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A115F80002
X-Stat-Signature: dwtqiztsc1eizcq3t886yeps9qq9dpdc
X-Rspam-User: 
X-HE-Tag: 1787204750-452290
X-HE-Meta: U2FsdGVkX19n5XPCj/eDO0uxB91vpNZ2YwyEmk6ajLV4SWLWLxxMyxT0Wy5Pfnz0bjKLghErcSpBsNEuAIkHDY7ebkdBiyaa7kl+2V8qDwy96lz/N3rl1VxlQCl4KzNABg/nKkMp82MP1nQuJ2B5rwbP88TWmFXBeJBqXaMtMPyebPgAedRO9vhjKNE5PHNRDP6E30NEg1ZWOxmmSB+oD2mrmI7IP4W305DnT2dpdyyJVSaldooEVFwrEaalxHTvtlLGClvR2vyc3097y/OrEE2BQfkkRy2E+9S0KLovfuyDvCc5b0ISQJWk9MY+axJde5sOwnmhzmSl5+N5hVA9wADz0D7FuCnSL4Yl9iefIZkt5Un20KLDgWkyGilKGr3EKYQ399/YGfTCX97hLUa4HqCKyA1QYnNaF4IoPUo2pudtzAxVO1yO/vBo6BGamXkCxNue99La0R358ufrdgT5fWdRHEDzPL4rdlx0kvbWRp8EjCXIYpuOeziPYv7uACDxQIVlxQMVFggTJsDe/K/NwQkszylSp6bRdg8Hbm41ROmSwAWRmMSOVj43jXqR+iVHeE1wgLwNUUihe4H7lpnRE4h/GjrXx+suCczB7RysUdLhhbZfSibvV6m6uQruXv8swvn5XNW86ibdFzkxbZN8P/UjJpQiE+A2Kwi0cC7etfBGvpFbUx48LCsW9Pweoy4iSWZ3YsO1xwznzHqqJEZtONFwE5Mcyj3ZCJ1dmnod9DFOxPkDq1RsmpkFQwdt6LLH81PQD9nd3qvTG2FFn7zderdTDMr9ys0Di/jypB5Sipn3LqCp/+R9mBbtV0H/oBYzGfX8Vjk9cKfrQyC5qagLZf4zGcexpBuQ2MD87TKs131jP/7MaB+xbjd52KWslUN5lZ+O2NTmXfAT/FyOZEU4M1OYnpoLBxZZZS0MO3h2XIdrrxT/Q3GBxpULSEc9MPf9n7oQdToD4SHqIKKxDpY
 souDh58X
 K4xb7YEhL618YGFE5MUOjmAZ8tHVJ+rK5+Butp93Jp4gZVxgD5a/0iaowDy6F5QFoa8eR/+fowo+QEKHN31jEnfWg7sS0fBegvdYJNNIwTKwmqGrCOXONMOFltDxFDOAlAmKhcqNQizC8S1u/8oMk2STj2/toRT6KwKbFd/pvHIXjVgtFQ60p9RmdwAcJLcx5YGmoYqxicQldNX0yj7JvEmZi9jBSGCTY+JIZ+KIkEM57odOPlQ+Mb0CFrNr3r7D/IevRI0GxrrxIlrRL6GZ2gYZZ0G1vZawr7Ru+mN+P0gyi55K/FLdr/hYG/HCuFMCau/09iRUWnBQeDiU3Sa2+WXpj58v/DxxD1kR5T9YhCT7Ry/Wr3iRIVyGA4UZOqClucT70
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Linxuan <me@black-desk.cn>

Add PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT to return
close-on-exec O_PATH file descriptors referencing the target task's
executable, working directory, and root directory.

The new ioctls use the same PTRACE_MODE_READ_FSCREDS permission check
and nonzero-argument rejection as the existing namespace ioctls.  The
target is sampled while holding exec_update_lock so that the access
check and path read cannot race with execve().

This allows userspace to obtain stable path references from a pidfd
without requiring procfs.

Assisted-by: codex:glm-5.3
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/pidfs.c                 | 38 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/pidfd.h |  7 +++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 39e1e7ad9b2b..95b079d0de0d 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -4,6 +4,7 @@
 #include <linux/exportfs.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 #include <linux/cgroup.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
@@ -510,6 +511,9 @@ static bool pidfs_ioctl_valid(unsigned int cmd)
 	case PIDFD_GET_UTS_NAMESPACE:
 	case PIDFD_GET_USER_NAMESPACE:
 	case PIDFD_GET_PID_NAMESPACE:
+	case PIDFD_GET_EXE:
+	case PIDFD_GET_CWD:
+	case PIDFD_GET_ROOT:
 		return true;
 	}
 
@@ -682,9 +686,31 @@ static struct ns_common *pidfd_get_namespace(struct pid *pid,
 	return ns_common;
 }
 
+static int pidfd_get_task_path(struct pid *pid, unsigned int cmd,
+			       unsigned long arg, struct path *path)
+{
+	CLASS(pidfd_task_locked, task)(pid, arg);
+
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+
+	switch (cmd) {
+	case PIDFD_GET_EXE:
+		return get_task_exe_path(task, path);
+	case PIDFD_GET_CWD:
+		return get_task_pwd(task, path);
+	case PIDFD_GET_ROOT:
+		return get_task_root(task, path);
+	}
+
+	return -EINVAL;
+}
+
 static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ns_common *ns_common = NULL;
+	struct path path __free(path_put) = {};
+	int error;
 
 	if (!pidfs_ioctl_valid(cmd))
 		return -ENOIOCTLCMD;
@@ -702,6 +728,18 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (_IOC_NR(cmd) == _IOC_NR(PIDFD_GET_INFO))
 		return pidfd_info(file, cmd, arg);
 
+	switch (cmd) {
+	case PIDFD_GET_EXE:
+	case PIDFD_GET_CWD:
+	case PIDFD_GET_ROOT:
+		error = pidfd_get_task_path(pidfd_pid(file), cmd, arg, &path);
+		if (error)
+			return error;
+
+		return FD_ADD(O_CLOEXEC,
+			      dentry_open(&path, O_PATH, current_cred()));
+	}
+
 	ns_common = pidfd_get_namespace(pidfd_pid(file), cmd, arg);
 	if (IS_ERR(ns_common))
 		return PTR_ERR(ns_common);
diff --git a/include/uapi/linux/pidfd.h b/include/uapi/linux/pidfd.h
index 0919246a1611..95ce1819f423 100644
--- a/include/uapi/linux/pidfd.h
+++ b/include/uapi/linux/pidfd.h
@@ -121,4 +121,11 @@ struct pidfd_info {
 #define PIDFD_GET_UTS_NAMESPACE               _IO(PIDFS_IOCTL_MAGIC, 10)
 #define PIDFD_GET_INFO                        _IOWR(PIDFS_IOCTL_MAGIC, 11, struct pidfd_info)
 
+/* Return an O_PATH file descriptor for the target task's executable. */
+#define PIDFD_GET_EXE                         _IO(PIDFS_IOCTL_MAGIC, 12)
+/* Return an O_PATH file descriptor for the target task's working directory. */
+#define PIDFD_GET_CWD                         _IO(PIDFS_IOCTL_MAGIC, 13)
+/* Return an O_PATH file descriptor for the target task's root directory. */
+#define PIDFD_GET_ROOT                        _IO(PIDFS_IOCTL_MAGIC, 14)
+
 #endif /* _UAPI_LINUX_PIDFD_H */

-- 
2.53.0



