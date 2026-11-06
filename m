Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FD9606A33B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAXqAJKX
Received: by kanga.kvack.org (Postfix)
	id 5168F6B05BA; Fri,  6 Nov 2026 02:12:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4DB6B05B6; Fri,  6 Nov 2026 02:12:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365226B05B6; Fri,  6 Nov 2026 02:12:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED7226B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:12:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3816AA0CA6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:12:53 +0000 (UTC)
X-FDA: 85403827026.15.9AE7686
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 069A31C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:12:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAXqAJKX;
	spf=pass (imf18.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949171;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zuRl5RHmEg83bozZHf9kT8CvGlqa2N5kn1FPibO0sBQ=;
	b=UH/zFLhzXp0ETUHXmHtigQDzHDxCigPLxH3loOue1tPIgX9wdOFOB25QID0Vw+WH0UDYHh
	FXmuvgLcWUrnPtdYo3Anzxj62IwSxBfMMnJB7fuZfLAP8ZhdjGFKCXATVna/ArTAnZ718F
	ncP+awB4DHdUI8jDErMPljpQIccNOS0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793949171;
	b=sbSHvrUTlOeom9QZ8IrffO8kQunim7uCHI0nqmQMqtaYDJmb6o4EKeu2D5okbrdQbI2paz
	JRBW6he/6wU+O2Cqtd4vtw8DTUtnh3s6QmgwoD9RafRbXFGGuZS8cGJGflEDowzvZFosPu
	bLsCtPxMYmhbFEyP0UKwtJ5CiRn5wKQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAXqAJKX;
	spf=pass (imf18.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFEF24429B;
	Fri,  6 Nov 2026 07:12:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793949169;
	b=T85lMe9BH4O5NL3II+RDfOeA8LJAW4qzu2TfXx2liX2Oq2iCRgWMeN5MhF+sMZ7Wl1V8
	 5xlpfa2jwh+rb7fjkg5RxYGk1nNG8F8sgPYNc2rG4GmK5ioVU5GirI3eL6uVAWkiWbmn5
	 MZS2BGDF29cTYCMNYslg/gGKEqaTSu9+llsNhQXLmmT5XTu8jPpqf9heLMbRlYjT/eARc
	 Ym+iQWZQAV4WrsyIsj2FcflUACWT2ua/s/Ic4beoRXbsiqlFnff4UH9J94+/oyPndXgYr
	 1/Hu/wnEJnuDMQgPwWSmqseFxpvpwqEJEzV6dCkxG1dBtBOYgbw696HF4ysOYJTtgLg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793949169;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zuRl5RHmEg83bozZHf9kT8CvGlqa2N5kn1FPibO0sBQ=;
	b=1DyMODn5ZxEv5iEPr2GDZvTUVNDAMSp5CTd0fyidZ3gUl5mD6eTcyY8loHCpC1DAVtq4
	 OYlE1jYF2OmAESye4pya8LTgswk0ljOLJhCktRPzzB8xkcobwSLOEIVoqrt4au99D+DTJ
	 paR6dINQ38waq6uV7h7JkO5r8HGaY1mFqRuBervfJ7DJW4BC6CIGSjZqdjyRwyFZPX77y
	 oNjOZGmsa/R/dmQZGi0FHyUWGtiXvmj/NpUOWhcqIQ9StZze32OUy8Pp3rAlR1AG9VBc7
	 w7CGUT3VSox75f3ByTKOiQhQEw9z6yqxclpOnlo9bWB3GKOV9WSJXUBsAXJKVV2xTfg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 287F41F008A3;
	Fri,  6 Nov 2026 07:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793949169;
	bh=zuRl5RHmEg83bozZHf9kT8CvGlqa2N5kn1FPibO0sBQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aAXqAJKX5PfWgFu37pm6eJS3jK/sAhr5IlOuRJ/Se1gTHoqt4UUUtPyI3DCt8/ydU
	 7ZH6b96Q6SnLsEB+TUoEOXZ+4MWlY0GyFvHxm7nbO+JT4SknZp38SSXq4SdkrCXn1D
	 117zZZLV6fnK5tBUU4qOqJdAUHmQZoA828lZVzd+VhJnggkfW2ECcCdzakZfFmnvVA
	 zRxJHAdAYSKG+KLdqybx08Xap2pJvNMsvlanie4yLx3Q+7kilLWoCdUgRrQbAQM8Ed
	 WVTjxrrHLsxk7A/lq9Tqb+l0ApirLDqzkIlByChmkGSJqpmVM/+hq2eP6miwBtq+FS
	 IiTCM1yIGE0PQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9F6CD45C3B;
	Fri,  6 Nov 2026 07:12:46 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Fri, 06 Nov 2026 15:12:23 +0800
Subject: [PATCH v5 3/3] pidfd: Add task path ioctls
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-pidfd-get-paths-v5-3-3147ce6571cb@black-desk.cn>
References: <20261106-pidfd-get-paths-v5-0-3147ce6571cb@black-desk.cn>
In-Reply-To: <20261106-pidfd-get-paths-v5-0-3147ce6571cb@black-desk.cn>
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
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6126; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=8/4Y51OBEYzNS6FVvsAEjYBKd/ZHA5peUeskEw5337k=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBq7X3u1WnSUNq0WXH8R+Y9EmYhPf33sjCeRtisV
 ZlXZZtijM2JAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCau197gAKCRB2HuYUOZmu
 iz1lEADXkuPv6sF03vbyj+DqwSykq+Gnjlo3ud5LlHRMKcxnAF2WTi5WvaI2KDN1wUfYpCsi/Hg
 SDIin/97wXLOxvrnJK3u/D+IapIgPJIMttsypIrxAY7JSRLSx+X5EpGBKrHTou+RZ3nOzSwsnm9
 O9QLYyX00rJQE/N7OLfRAVR5v9VEkAYex8hsBWptEDIvgUmmLA6U2T7IxJeDYnYDQ/57AnZ+9eD
 0Pl5WoUELb5TIZ3YxZXIWyx/iEzD9yUyKtczWPpul8mVL92aL1mQHrqLC3dk6kwijoWLCl3Nf3R
 1PENdoUmUrvHgaO6XhR6DVuFtqcvA4vD2EsIKyhOrScbNyPNDi/aPE6xWd2Fsqv0dr1EvLTvMtE
 06q8vS1mjdcwG6KvjTqswTX0sNB8w3JmLl4i3jPKTYo4yDHQT2mpveI68i3teVcluNe37X0Awsp
 KDVFc4KLHIfZU2b/d3sIrdf8J2h8aKvlSPZ9kW0yd2VgOcpeUUtDjn6ggliSWaapCHtgs58li4W
 XI2zWuQFUZJQehRQsWJplR4Ns/jsNt+4pX5Se9GSIREUt/qJX27Qz97+ULE8NXnACnh2WNqLp4a
 015O8Q2+6Ras2yQMm7HA53VOQgB/B0Lo91DyWOv4BRb0xdr5Da5YVbjiNbEIVofjHBOBBdR6xgQ
 fhQUoDo6IsEkfSQ==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 069A31C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9htkuxmnyc48w951s1a5uhwxogep6ktc
X-Rspam-User: 
X-HE-Tag: 1793949170-104852
X-HE-Meta: U2FsdGVkX18vtycH+9AgBqugjdsdQZApnXLFX7xucR8VJ2manF8CmZnZpneApEyn33jqBkKv6zJ3NXVIV6W19zdu3//UHtjtHQ7xGnNPPwZdxiH1oAbb6aGVvmT7FQZI0OUUWot306roRO+NbXLAducLxz/yUGZeG8DuqkpfSp11eQNBwEPeZasnonPovNXJmDuDaV8AY3bcjpzjjdiIsSoNVhRWXwn68lR6z/V5GGxZ2rDT5HRvRrhbr8uAZlheOUV64SlU3h1sI/vuWuIZQ4Ie49QotQi0uE+wgZE8AR8M4q8pPR3xoso+gnZrMX8CyTFUtkdmwCtiy/7p1T+DwlVxquLKSCvH1WLPg1t4JPsfmar2jFT0jOKfJUdFuxBFORdPUjzzt1tQIrok+G7gtzpCXZDZ+CHfPo6aLfyV1Mc1CbO/k2UfzG4OLinrLm44z+xfpoG0H9Y7Vv6rTo/bOOFNlUJwcyoBw4lewuThHFP5zUhlTtDsccX/XMI9VsOm4TBLHHSMByYfSzSIK8eanyCii+5h+BAVG1pEfF4NWavR2iG7Gp/5wdEO6HUcWEsvUPB05+8e8gf4m5YiVLi1fxRUo/tsgGqOOjIuHwSiNqH6SgZ2ldl05pZLrnhUF/vlKVgLuICeoUO66KuS64P1ZDaHJVN4Uuxrrogwqo/icOp3h040Y4scDEKWE7gWmf4JepsmmblaqG56D//zxWovHYiEwt5hNW558oDVHkSlyL+calrnBK+uxaG/3ETV7GyUg7wmdTTDTfOMbrR6JSijbP5xj096q7QKhKqxT7Uppjhjdme8cbOG2KbM12VCXidvmtSwW38IoYO57cOsXgbfMYmDJX4msCF7y/v+g0tuVhmhvRfTL1H925ZWUTwoLCaZWz22fmObzLANbFZ7tnqsZ24xEJc+pEw5hwjpbOJ7bx+bh62LzZ4Ibk9+XQSFvskiMSdztxzi9iIb2mHEEgV
 1QW+CyAd
 uC/Vej08KCWFIT4nawuq8kzS6tiKWH74ZbYVDgmI3hD6ivOmiu0D8mJJ3CjZ0QM4dcLLEqJUv2muBdqvqe/4H013ywF7L/1H+ZGPvzKTqcnmTiodkVlginkMtv+w5HL5sfi9+RekJnv/Rv+BD6uDALBrG24OfnSN6amcqlkqnD4nWxO/GsC4qrvcEcSkYRCOCqpn07qTKwrOKTYr5RQsDFRfWvhYyHJWMuoY/3VCLFaOdWho7YB4KiDB58SnuOYksTmP1js3wWdVVcUacSv2bB4ZegSWGGmuKiGT+9KskBmWQlnLGSRSxD1B9/dB7r0GJXFwmJpLJfE52Nxz3gonlIXCDj2WgVradwpaTCI4XJq9KB+fqekY/z4VLy5D0wq5Zis8UJQkr+hbAndKG585vTjzimqUTEBM75ZepXduE6K3A7IYFL3Garf2YFIKxcBn2PW+wMe/OVRWH6mfbxhvgEtp39A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chen Linxuan <me@black-desk.cn>

Add PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT so callers holding
a pidfd can obtain close-on-exec O_PATH file descriptors for the
target's executable, working directory, and root without requiring
procfs.

Use the task acquisition helper shared with the namespace ioctls to
check PID namespace visibility and ptrace access. Hold exec_update_lock
across the access check and path acquisition to prevent a concurrent
execve() from changing the target's credentials between them.

Add task_path_open() to perform weak revalidation before opening the
selected path. This gives the filesystem the opportunity to reject a
path handed out directly by a task, as it can when following a procfs
magic link. Pass flags zero because no pathname lookup is performed,
propagate negative errors, and return ESTALE for a zero result.

Release exec_update_lock before calling task_path_open() so filesystem
revalidation runs outside the target's exec critical section.

Suggested-by: Christian Brauner <brauner@kernel.org>
Link: https://lore.kernel.org/all/20261105-gefolge-rosten-neueinstellung-6223a18aae90@brauner/
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/internal.h              |  1 +
 fs/open.c                  | 30 ++++++++++++++++++++++++++++++
 fs/pidfs.c                 | 37 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/pidfd.h |  7 +++++++
 4 files changed, 75 insertions(+)

diff --git a/fs/internal.h b/fs/internal.h
index e833c7e6e14f..799495ce3d98 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -207,6 +207,7 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 int chown_common(const struct path *path, uid_t user, gid_t group);
 extern int vfs_open(const struct path *, struct file *);
 int vfs_open_consume(struct path *, struct file *);
+struct file *task_path_open(const struct path *path);
 
 /*
  * inode.c
diff --git a/fs/open.c b/fs/open.c
index e43f02ff64ac..55441ff0525c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1156,6 +1156,36 @@ struct file *dentry_open(const struct path *path, int flags,
 }
 EXPORT_SYMBOL(dentry_open);
 
+/**
+ * task_path_open - open a path handed out by a task
+ * @path: the task's path
+ *
+ * Open a task's exe, cwd or root for the caller. The path wasn't found by
+ * a lookup, it's handed out directly, the same way a /proc/<pid>/{exe,cwd,root}
+ * jump lands on it. So give the filesystem the chance to refuse it that
+ * complete_walk() gives it for a jumped dentry.
+ *
+ * Only O_PATH opens are supported. Anything else would need the permission
+ * checks a lookup performs before the open.
+ *
+ * Return: An O_PATH file on success, an error pointer on failure.
+ */
+struct file *task_path_open(const struct path *path)
+{
+	struct dentry *dentry = path->dentry;
+
+	if (unlikely(dentry->d_flags & DCACHE_OP_WEAK_REVALIDATE)) {
+		int status = dentry->d_op->d_weak_revalidate(dentry, 0);
+
+		if (status < 0)
+			return ERR_PTR(status);
+		if (!status)
+			return ERR_PTR(-ESTALE);
+	}
+
+	return dentry_open(path, O_PATH, current_cred());
+}
+
 struct file *dentry_open_nonotify(const struct path *path, int flags,
 				  const struct cred *cred)
 {
diff --git a/fs/pidfs.c b/fs/pidfs.c
index b70ec50f64da..6eeaad3135de 100644
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
 
@@ -687,9 +691,31 @@ static struct ns_common *pidfd_get_namespace(struct pid *pid,
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
@@ -707,6 +733,17 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
+		return FD_ADD(O_CLOEXEC, task_path_open(&path));
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
2.56.0



