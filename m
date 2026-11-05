Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B446606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7E2MjRH
Received: by kanga.kvack.org (Postfix)
	id 830C46B05B0; Thu,  5 Nov 2026 16:42:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807A76B05B4; Thu,  5 Nov 2026 16:42:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720816B05B6; Thu,  5 Nov 2026 16:42:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3906B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:42:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9945B1C46B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:42:56 +0000 (UTC)
X-FDA: 85402390752.21.5D75319
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F20B816000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:42:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7E2MjRH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GA54y8x2BTg+d6MyDylKpNDR5NpP0XULvhnGi2Kmvgk=;
	b=sSGePlUgvkVvubdFjOc4R0y4b1p+/nOiem295tgQa/PacF/Jv/C/Q07CmdQd6zKFFkgfG/
	x72Pq8hM1whGLpiwn+VsJejrVVNdMroS7seWRa7jLQY2s0iPtnAZLPSYNDXWDrunha68+C
	4zAkLrcGsEbR2Y1xxHRBpa+80MRsnbM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7E2MjRH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914975;
	b=I4V4zoltHTZgdKay0hLuivQncK8muxb0mHryAmeQioU3qwmjB69FYXU7JuPruGar8EmSTi
	3wtuJNjkQWM03gOT1Ml9YrXt9Q850W2tEX4KGoFKSUip7wRONA0M9Q8dEXabNghE9TXBUq
	vUH5AUHmrZP78JfiTMBJL4sZDvVhOn0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 773A260147;
	Thu,  5 Nov 2026 21:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37441F0089F;
	Thu,  5 Nov 2026 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914974;
	bh=GA54y8x2BTg+d6MyDylKpNDR5NpP0XULvhnGi2Kmvgk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h7E2MjRHzsJZkvGDDESAY+UXeh0G4esVLHqk/S+8HNlz9r1WdhHmkvveupL4YV5JH
	 aZ8D0zeTyG1GO2et1ZZ6u7fu2qJO4okJQ2QMOVK75OvR9p1BoNEzK8Wmpt/AF0tYmj
	 YK30XZ8ubTL66486WYg/p8UzNANqefwYaeH+iacd/cjTzlXxNtiUR+abV845fCkbAK
	 D0s3JGwezFQH5M7cEetJOMov/9oI8fwAOmqaCsYRcBEYzrj/X+MqJQDbQs3KpiZBMJ
	 5aVlgGWf2oLFChdGfljLcpKvpYfjhMzvJ2Xk7yrtTFqJtynD7VQ+jV6lUfRGqf2KWt
	 GjVHcorcI2aVQ==
Date: Thu, 5 Nov 2026 22:42:45 +0100
From: Christian Brauner <brauner@kernel.org>
To: Chen Linxuan <me@black-desk.cn>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v4 3/3] pidfd: Add task path ioctls
Message-ID: <20261105-gefolge-rosten-neueinstellung-6223a18aae90@brauner>
References: <20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn>
 <20261027-pidfd-get-paths-v4-3-e2a6a47e3c95@black-desk.cn>
 <20261105-fotokopien-essen-inbegriff-be31e4f3c8a6@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261105-fotokopien-essen-inbegriff-be31e4f3c8a6@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F20B816000D
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: adedgbwjuazho9wisbcnanam6r13jo5o
X-HE-Tag: 1793914974-553445
X-HE-Meta: U2FsdGVkX1+7x3S3G6jMI48j1mhGH87HEPqH9nXgs5b0+5TSlRSak8YP41PmJOav07YzBk/ygm7sJ7MhH/g5aXao8wRWiOgBq95RNnOQhJaZcHqdRdrtbjPpVK/sBRTHZjDlhY5kxHM/miPsgUBwvrx2AUPYcqdaq5RT/oLi7s6TE+9R1xrUsffrhfcqDrfJ0o9UprUzeJ+21tuXlY4mdDNGdsax4lGeaaBYUPeYTLu+7LkKyB03nNunNNt+jugeY/aWCBca69818W8mtuugqqHn+XCYVmxLsKmbBUThLVxpM5R8p+qIhMUf+LAQtKmDtcfr0zGbgfZn5zPfj3mzp7Dcf3ZpibVe5AA5hkNMDphWFDCOpDw3yg2zJfBzHkwxS7HkxIrwl5bo+YgmXkEyIPMZmLyaoW8Nnk3rV79ezX2d34ED7p8nP9ABYd6986kwlyAA05DBQAi0gVfcmXuWSHr17lj7j7UV28xN/trJKMlN2cwFLLAFw4Q0YMNL2tUZA4RpO5RrUDXU9L2ygRb/wCK4f0tINzl2XEYi9UYv1sGFj2KEzzRiVu860pkZeL3V363wMG68cKzAvKLMi6dNmB6OA8GTr0zs9RwGIfYAf8Kq6bCAUtZpCmqLZoiOloOm3f1Wc7+A/S+lYr/PNak6Thr5BxwRxadfYz9Vnhqjoc+mIYQ0N/N6BsEofOrTOJvogtA1rDee9rXCPPfrP1C0593JFP9OnRhGldfu9aVfDeH8av4nc1yZGwiXqlMZ5cLj5HSLDlNOMYPjcc/ogOaz3OHIxe3DinMf5sq13UJ5OfZxSv7KjoVuF6tJJKPWWvnbRk8YkUsbzNd6GTeSAljvi/mnt2eJHKj1haBIKMBbBx7TdCPv8isCq0dfyk1EBMqW841AwrwdterHRwrSwzdvJ21g/FuXjBX/Nj41an3hCua2KZp+R2t7S/2KNqc27SOD1/8CtKCFZDRa1hHJfXy
 om0IZkRy
 LvyEpDGOwEtcPBPADZq07MZN4WEoXq2JZyIOMW5+x9VC8FKujAzOkf2ljDpk2Sfbj1PwNabr3ARVXsFRfbbAiP2k2i1RcOnqv7fIjw2nrAB5BErEBw3og+ZhRPq5rR57D/Lqsnx8zLB3EoAeh00AVPRuFbzWHalAVFpiUu8Q8Eu5mAWCtVx0VhpVyL3BQ8WIyiNeCa97pm5X5KG5PXLPrhEa7sC17lRZmNhnpHYaJnQTGWCWgUuVJH3MuWrs5fXk3p5cbWkqSobriKn2N6GSIMVxc6clKAURV178qnhtMs8obkc7dK5hcFSPyDBbi3ZhPIuokTgkBzrQ1AAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 10:16:44PM +0100, Christian Brauner wrote:
> On Tue, Oct 27, 2026 at 04:46:09PM +0800, Chen Linxuan via B4 Relay wrote:
> > +	case PIDFD_GET_EXE:
> > +	case PIDFD_GET_CWD:
> > +	case PIDFD_GET_ROOT:
> > +		error = pidfd_get_task_path(pidfd_pid(file), cmd, arg, &path);
> > +		if (error)
> > +			return error;
> > +
> > +		return FD_ADD(O_CLOEXEC,
> > +			      dentry_open(&path, O_PATH, current_cred()));
> 
> So the path we take from the task is a jump target, just like
> /proc/<pid>/cwd and /proc/<pid>/root are. So complete_walk() runs
> ->d_weak_revalidate() on them. Without that a stale dentry on nfs or
> overlayfs turns into a valid O_PATH fd.
> 
> And failfs relies on ->d_weak_revalidate() to refuse pinning its root. A
> task that fchdir()ed into the failfs root can now hand it out through
> PIDFD_GET_CWD. Which would be breaking a guarantee we give. So we need
> the same check here. I'm just not yet sure how we best do this.

Ok, just saw that Sashiko also reported that. Hm, so I think we need a
dedicated "task open" helper. Something like:

From 59f9a5be6615604ddfbbd6a80f2872ad0c818ae0 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 5 Nov 2026 22:25:55 +0100
Subject: [PATCH] pidfd: revalidate task paths before handing them out

PIDFD_GET_EXE, PIDFD_GET_CWD and PIDFD_GET_ROOT sample the task's path
and open it right away. The path isn't found by a lookup in its parent,
it's jumped to, exactly like /proc/<pid>/{exe,cwd,root} jump to it. But
there complete_walk() runs ->d_weak_revalidate() on the jumped dentry
before the O_PATH open happens and the ioctls don't.

So on nfs, 9p and overlayfs the ioctls hand out a path that
/proc/<pid>/cwd would have refused with ESTALE. And they hand out the
failfs root. The failfs root is only unpinnable because its
->d_weak_revalidate() refuses every jump to it. After
fchdir(FD_FAILFS_ROOT) a task can now simply do

  ioctl(pidfd_open(getpid(), 0), PIDFD_GET_CWD, 0)

and gets an O_PATH file descriptor to it which no path lookup allows,
not even with O_PATH.

So add task_path_open() for opening paths handed out by a task. It
gives the filesystem the same chance to refuse the path that
complete_walk() gives it and then does the O_PATH open. It's called
after the target's exec_update_lock has been dropped so a filesystem
that needs to go on the wire doesn't block the target's exec. There's
no lookup so there are no lookup flags to pass.

Fixes: d53dc95eb961 ("pidfd: Add task path ioctls")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/internal.h |  1 +
 fs/open.c     | 30 ++++++++++++++++++++++++++++++
 fs/pidfs.c    |  3 +--
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 3f2fbac40f8e..e43ebcfd9846 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -205,6 +205,7 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
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
index f2a113006552..a2a0691cf131 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -775,8 +775,7 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (error)
 			return error;
 
-		return FD_ADD(O_CLOEXEC,
-			      dentry_open(&path, O_PATH, current_cred()));
+		return FD_ADD(O_CLOEXEC, task_path_open(&path));
 	}
 
 	ns_common = pidfd_get_namespace(pidfd_pid(file), cmd, arg);
-- 
2.53.0


