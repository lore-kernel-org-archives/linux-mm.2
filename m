Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683B3606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 12:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pPQocFcI
Received: by kanga.kvack.org (Postfix)
	id 9909E6B0704; Wed, 21 Oct 2026 08:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968206B0705; Wed, 21 Oct 2026 08:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830216B0706; Wed, 21 Oct 2026 08:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 586C86B0704
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:52:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFACD404E0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:52:04 +0000 (UTC)
X-FDA: 85346620968.25.0B33CB1
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 10D16C0008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:52:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pPQocFcI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792587123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqgNTIU8DzhUyVmfZ9IEslpzXfUEbYHbQzea+4YWsnA=;
	b=JRDJZI2u6Z2QHyf/IbP4Cfg0Rr61yT65XQjyDdZnCe5+xPYptDxIzB0rMP3y+UuOy88wO0
	M0NlsAYhJz98lt89itmE1vdgD1a9iPI1S0Ia1TTe8gi/siVTZK0vs+WuQ7pHJSUCTyO0+o
	fHZ3AGYjweFH65S2mdBWueYVXWMuI0w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pPQocFcI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792587123;
	b=qb6pGjjrsIWVWrvDiUZY6LJocdCpENBMOv2dmR9SHgrxUdOegBJ20EtCXKnyiSY4XG6Q+p
	hubG2PGALG2oBcqykFZzmhpPPDqopK6+uTW5xyq6WV1ZrAi7vKWMqoyGU3Jkq8NE6IOG0N
	Exz2Qz+uHXyhjkWjFE8Or1Ygs9CtUBw=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso984576a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792587122; x=1793191922; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NqgNTIU8DzhUyVmfZ9IEslpzXfUEbYHbQzea+4YWsnA=;
        b=pPQocFcIj0J+1rJLdPkBTZ6pm7YEWpEiYjH3mluPNoHluuVCZ8AdC72zwo02WyD0w3
         cNYfQ3fNZ/NhSGY4gDqUoQSOYn/JjAZcF2jXHGSUthk3rfOxw/6F3ij3tndqUK1BT9rL
         O7pyGumnR19wrigI6VZ3fYGJdYcaQViCWdAvi7AmTIGedIW2rEN0tJnorCQEDtbzLuZV
         I0shhdmyZhUGBoXsgxI9ZyKMcWRGfMD6zw4bJbmtNlmICwR5wQzPFCGoI1PPW5g4E1J8
         XEFsCBAFXzYli4fuH8BJebz1rstaTErDAT/Iccm1uk4M59Hn6YQ2DCa0X6KVuSNXMF+V
         WalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792587122; x=1793191922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NqgNTIU8DzhUyVmfZ9IEslpzXfUEbYHbQzea+4YWsnA=;
        b=VpsLYKhPWebiRRp2HdGlJAWwrQu50gHC2qYLwS+RItt2s+JwwmQ02R08Iaw52I2/Y+
         kNm7dm03qvF6yTbRF2RaPiIYGB/0Hwc8J/m9tNPSWDKfwvFnoNLaVoydHTDumLbyq0BO
         jKHsRimaQySNouMOpVlyBOuoZww91DbXerCeJJpoPDl6NGbzSJMhVr435KQo284HmcWZ
         XsW/lZhHVLfXPo/ydbptQqi/LF7RW91uW1I1GtuuvL/2JPcKkqE3/s5bfE1j6dFJSnHK
         FKUJKVIt04VRpugY0S9FdthJjOG9PdtWn/li2g9gOZCSwld6eXGGnq0T5JChSSVmHo/z
         ww9w==
X-Forwarded-Encrypted: i=1; AKwUvBzVKn2z5FPwk1EvCSK9VVqk5t9fU6fd24fO+4CPtMd5Ptw+SYCS2Ade5VqjWYkjt8ynyORuFrYeKQ==@kvack.org
X-Gm-Message-State: AFq9FYIuWix3MaGEs/kY8ZyPqgeK2i9BV+V8h54F/BoEDltjEBLQT3gk
	1YlqLDskGiDoN4zPRmMXgrESqX4FgT81w5eEeOay8zObuIb2S6SYPNJi
X-Gm-Gg: AYBFou2RerNhIdA2ydfHbrnJyVrT6H87gWtGiBnF1ipsUtITy0siOX0ULwWcptpuSSX
	a2rFeUt0l7bjuasu61H/79oT5uNpSDeJHDYWxpo+lknhOEOxfu/z63KfOy2dHeqiNCZqgYztZ5S
	c82P0KK+wSlloL1wegRmJ7/IQnMTIXtO1VG4QIIYJvqFSag+zuGyBy7fU2htuD9K6AQe1XYwVB1
	Nxdsp1zL90scLOKJGrbytYJpDNPWYRgt6RRv+X7YDIhHs5KXXEvSb9vCG32aCG7oYZWW3uRC+XQ
	6YkBSN3fldFGOt4fph6CLXP9BgDCq/18oabN4isRmsMjiF2gTvygkYMeUTdQKIWf5QF1LVya/8d
	0fnxn+Marz0ldzWArPdDqLLa2Q0CEf/2w2rLqHtyfsGVX56y/uijvklNYu4mr3RwZpSm+lc+y0E
	IkeB1dfrTC3SwSOp7XZNq/MqjGS81ziU7415RK1AJklUTVO316/vrAgNqWfBh3Qfhua2wkyfFoA
	uwZTmlDab865yw5DRpUDCSLDtfGQ5o1BaXlmQQVbOpDT2lzD+nWsaoM069Z5AI/rYtaUROmyCAi
	YlUa0y6R+1O4o2NePSPBfSJOhIYGeEUe0W9lDzo1RXyTA9oNjeVBkTPb2kN+PxdUsr/kr1YLz3N
	lxApWhJaTxnT/7/LvOha2EaGznM/NBht1iH7qk6ht2FzBEzAUqK2lJzg/K6XiJYQgO0sonWnKkG
	aE+sqe0o99x6l73VS4wrY5VqyD
X-Received: by 2002:a17:907:9d1a:b0:c46:7462:6332 with SMTP id a640c23a62f3a-c46797a6203mr156125566b.37.1792587121409;
        Wed, 21 Oct 2026 05:52:01 -0700 (PDT)
Received: from Ubuntu.tail0f733b.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4679004464sm73128366b.67.2026.10.21.05.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 05:52:00 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Kent <raven@themaw.net>
Cc: Tejun Heo <tj@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	driver-core@lists.linux.dev,
	autofs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Subject: [PATCH 2/2] autofs: do not wait for the daemon while splice holds a pipe
Date: Wed, 21 Oct 2026 14:51:50 +0200
Message-ID: <fec81a3d24a29d4db2b165e95425330e41a68d98.1792577179.git.krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1792577179.git.krystianmkaniewski@gmail.com>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com> <cover.1792577179.git.krystianmkaniewski@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 10D16C0008
X-Stat-Signature: zdq3ba3hr5r6sb91em7crkoeqa98sxdy
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792587122-159656
X-HE-Meta: U2FsdGVkX1+uTlT4R0tslm3mzdeXTYJI++HIg9RH/xgkMF3GOLWc7n2UrtNVgD5FSxG2ak0cziPxyypmrC96YYz7u5tXn7ba/G9SHlEZCYjdHSpTks51MrLCRl3NLsZQOfkuovQILmsdNtqKS/w0KoHqdSSxTvPGZ6WpG0mtYFXU+ujDKzqJ/0D153DWhnKY4/C42DBN+Pg7on4kgBSgfbSJtdYxGFLYPKo2C/p+mTf9fKKRkHvLs+pZTT3WTteoMt/IA/VB8JzqSIzVpef3X5BXxy5euPlvQsb7IeLIW24yL1kbeU1vuYwcRPNgQ+KSkPT/cG+IC13C/HZiDBhHC4WUUiF8YzNSzpeAt+UqoJqlghnb8vD6tFOQ7O+FTvbqe+iIspVwI28DuHQlheqreoLWl3imNr4EYIbyZtY68PL1Ysp3OI/7RoJBat6cZ7VXkVa7TTj6sbp8Rn04EK9KbCIQvtiQ4dUttVbhGRXAvxZ1Mk56nRYsgYUqjv0XnvA3e66hAeqqfyN2GklmsX4w9tNGIfckTpoJq8UkRSObiEL5ukPfzb8s0j0zArIKP6RP8XpKpzZdb9Llr0FAmpTQPBsnQamBlwngvAtsaKZ8hVSv8Te/KlmMDpvTmVBfYKhXsoxWXE2lMiHny/UGpZy9axrIoY3rcaTJJ01C9UY0oosnud4mt7Xt3LIad0eUoc8yjtqU0YpvgxO37YSSBoxVZHP0yvu1RmUJkzSq+L5h43JLuyi1iKKHm7P9OdkYEwsgMSKxZdaHsH0CUaKvp6yVQjjBqkrPcVMg7SGG/wT8XnqOF4ScTA8Umkgm0+bYBBSKAtbtBmzb9m/m+gTK8GK/+wM9WdRvgw8+yqVzRz28BwqkKVD1I7n/6L3fvS7Jy361COXWKpM0OnMiG4TQWqhI9F2dvnt6jtzpx2ljnQYKZTgbn2YfaOQY+vTpTy3KHGUVqsmVTFvwduwqRZ8rOvq
 WV0SqZSm
 7qQ7ddzUdGLDfdlHT04xz1+TXHoaagRv9rgYFEd8IlyztyQ9bsPwFbd4tSHVn3G8yCQZtngUuQdVJbEOpUgaLPet0dOR+Ur1T7nlJN8rZaiS30qQm3LLx7GVXS9+jLqiE9YPsYVB3pyAtaXMA3GKtz26OV9mfNUEaYgZbW2W7P0c9vngxnpNsqyl+UcMzrxaa9OrUcB62olQMfER/zEr5oBxqqFQcUgWQuH0Ctn5/8X4LsNJBoze3CCGeK7k2jIqUXFXan8ryOfQvTLwkba0fODbMKMtzkbyuT2/ayAyB8Bha4jCcM5CgEdwEZD684ifYXjcZmpkphwcwJWJLOFgZnA22xzB9z8sfGknpTnulnqjTkGNoMmfUXWVpGU9z0mfNv6zWkd7IJGpPTr4T22RqI7tKdztZrJJhGL8VMKzba4RzwSJzXpgKvFUNiFQ0Gx7A5JpYgaezL856z6wPa/aCWmQFgNN1I0i1hfeWCRZIIle6gk2/mCVeR2iNfbMJao3qP0TVyDj+omWVwOitCYScvhHm08Vw5Qd6/EvSAQPNhYy6jA7Og8AfINESoFb88iTCeWy4oUWfUXDtnBUsVPNsmC+pkEpFq7m82wFvctcpJRAGemPXJA2OOYcoiqr4kp31lJ3JDMWuzKGNtG6wxTbmCRum65XfqQQ8GrWllhlrrLnpOOql1Atezw3pvFe6ea+JAduF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

splice holds the mutex of a pipe while it calls ->write_iter() of the
target file in iter_file_splice_write() or ->splice_read() of the source
file in splice_file_to_pipe(). When such a callback looks up a path in an
autofs mount, autofs sends a request through its daemon pipe and waits
for the daemon. A write to /sys/power/resume that comes from splice() does
this, so lockdep still reports &pipe->mutex --> &sbi->pipe_mutex -->
&pipe->mutex after of->mutex is gone from the sysfs store path. When the
spliced pipe is the daemon pipe itself, the task can wait for the mutex
that it already holds, which SIGKILL does not end, or wait for a daemon
that cannot read its pipe.

Mark the task while splice runs such a callback with a pipe really locked
(pipe->files set, as in pipe_lock()), and make autofs return -EAGAIN in
that context instead of sending a mount request or waiting for a pending
mount or expire. A new mount is refused before AUTOFS_INF_PENDING is set,
because another lookup that sees the flag would send the request instead.
The short wait for expire selection does not depend on the daemon and is
kept. RCU walks, lookups that need no request and all other callers keep
their behavior, and a child does not inherit the mark.

A lookup from such a callback that needs an automount now fails with
-EAGAIN instead of waiting for the daemon. This affects splice() from a
pipe into a file whose write handler looks up a path under an autofs
mount that is not mounted yet, for example /sys/power/resume. sendfile()
into a file goes through the private pipe of the task, which is never
locked, and keeps its behavior.

Fixes: 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev in resume_store")
Reported-by: syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=002fb7b2d0bc53bf7e75
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
 fs/autofs/expire.c    |  6 ++++++
 fs/autofs/root.c      | 28 ++++++++++++++++++++++++++--
 fs/splice.c           | 13 ++++++++++++-
 include/linux/sched.h |  2 ++
 kernel/fork.c         |  1 +
 5 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/autofs/expire.c b/fs/autofs/expire.c
index 5c2d459e1e484..9f3bf1473acd4 100644
--- a/fs/autofs/expire.c
+++ b/fs/autofs/expire.c
@@ -514,6 +514,12 @@ int autofs_expire_wait(const struct path *path, int rcu_walk)
 	}
 	if (state & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
+		/*
+		 * The expire waits for the daemon, which may need a pipe that
+		 * the splice of this task holds. Refuse instead of waiting.
+		 */
+		if (unlikely(current->in_splice_pipe_callback))
+			return -EAGAIN;
 
 		pr_debug("waiting for expire %p name=%pd\n", dentry, dentry);
 
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index b36439f4521eb..c4e04998a2345 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -252,6 +252,8 @@ static int autofs_mount_wait(const struct path *path, bool rcu_walk)
 	if (ino->flags & AUTOFS_INF_PENDING) {
 		if (rcu_walk)
 			return -ECHILD;
+		if (unlikely(current->in_splice_pipe_callback))
+			return -EAGAIN;
 		pr_debug("waiting for mount name=%pd\n", path->dentry);
 		status = autofs_wait(sbi, path, NFY_MOUNT);
 		pr_debug("mount wait done status=%d\n", status);
@@ -263,10 +265,18 @@ static int autofs_mount_wait(const struct path *path, bool rcu_walk)
 	return status;
 }
 
+static bool autofs_expire_wait_blocked(int status)
+{
+	/* A marked caller is refused before a daemon can return a status. */
+	return status == -EAGAIN &&
+	       unlikely(current->in_splice_pipe_callback);
+}
+
 static int do_expire_wait(const struct path *path, bool rcu_walk)
 {
 	struct dentry *dentry = path->dentry;
 	struct dentry *expiring;
+	int status;
 
 	expiring = autofs_lookup_expiring(dentry, rcu_walk);
 	if (IS_ERR(expiring))
@@ -280,7 +290,11 @@ static int do_expire_wait(const struct path *path, bool rcu_walk)
 		 * be quite complete, but the directory has been removed
 		 * so it must have been successful, just wait for it.
 		 */
-		autofs_expire_wait(&this, 0);
+		status = autofs_expire_wait(&this, 0);
+		if (autofs_expire_wait_blocked(status)) {
+			dput(expiring);
+			return status;
+		}
 		autofs_del_expiring(expiring);
 		dput(expiring);
 	}
@@ -359,6 +373,8 @@ static struct vfsmount *autofs_d_automount(struct path *path)
 	 * the mount.
 	 */
 	status = do_expire_wait(path, 0);
+	if (autofs_expire_wait_blocked(status))
+		return ERR_PTR(-EAGAIN);
 	if (status && status != -EAGAIN)
 		return NULL;
 
@@ -405,6 +421,11 @@ static struct vfsmount *autofs_d_automount(struct path *path)
 				goto done;
 			}
 		}
+		/* Do not publish PENDING without issuing its mount request. */
+		if (unlikely(current->in_splice_pipe_callback)) {
+			spin_unlock(&sbi->fs_lock);
+			return ERR_PTR(-EAGAIN);
+		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
 		status = autofs_mount_wait(path, 0);
@@ -442,8 +463,11 @@ static int autofs_d_manage(const struct path *path, bool rcu_walk)
 	}
 
 	/* Wait for pending expires */
-	if (do_expire_wait(path, rcu_walk) == -ECHILD)
+	status = do_expire_wait(path, rcu_walk);
+	if (status == -ECHILD)
 		return -ECHILD;
+	if (autofs_expire_wait_blocked(status))
+		return -EAGAIN;
 
 	/*
 	 * This dentry may be under construction so wait on mount
diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1ab..1756a8579776f 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -686,6 +686,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		struct kiocb kiocb;
 		struct iov_iter from;
 		unsigned int head, tail;
+		bool was_in_splice_pipe_callback;
 		size_t left;
 		int n;
 
@@ -733,7 +734,11 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		iov_iter_bvec(&from, ITER_SOURCE, array, n, sd.total_len - left);
 		init_sync_kiocb(&kiocb, out);
 		kiocb.ki_pos = sd.pos;
+		was_in_splice_pipe_callback = current->in_splice_pipe_callback;
+		if (pipe->files)
+			current->in_splice_pipe_callback = true;
 		ret = out->f_op->write_iter(&kiocb, &from);
+		current->in_splice_pipe_callback = was_in_splice_pipe_callback;
 		sd.pos = kiocb.ki_pos;
 		if (ret <= 0)
 			break;
@@ -1282,12 +1287,18 @@ ssize_t splice_file_to_pipe(struct file *in,
 			    loff_t *offset,
 			    size_t len, unsigned int flags)
 {
+	bool was_in_splice_pipe_callback;
 	ssize_t ret;
 
 	pipe_lock(opipe);
 	ret = wait_for_space(opipe, flags);
-	if (!ret)
+	if (!ret) {
+		was_in_splice_pipe_callback = current->in_splice_pipe_callback;
+		if (opipe->files)
+			current->in_splice_pipe_callback = true;
 		ret = do_splice_read(in, offset, opipe, len, flags);
+		current->in_splice_pipe_callback = was_in_splice_pipe_callback;
+	}
 	pipe_unlock(opipe);
 	if (ret > 0)
 		wakeup_pipe_readers(opipe);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 705970d07614f..3ffa284976cc6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1025,6 +1025,8 @@ struct task_struct {
 	/* Bit to tell TOMOYO we're in execve(): */
 	unsigned			in_execve:1;
 	unsigned			in_iowait:1;
+	/* A file callback is running while splice holds a pipe mutex. */
+	unsigned			in_splice_pipe_callback:1;
 #ifndef TIF_RESTORE_SIGMASK
 	unsigned			restore_sigmask:1;
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 5ef413368912e..d774e5092766c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2133,6 +2133,7 @@ __latent_entropy struct task_struct *copy_process(
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
+	p->in_splice_pipe_callback = 0;
 	/*
 	 * Must run before the first fallible op, so error paths never
 	 * free the parent's ret_stack.
-- 
2.53.0


