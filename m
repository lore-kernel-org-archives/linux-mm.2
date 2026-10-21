Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C93606A337
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 12:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Hp9ANzXU
Received: by kanga.kvack.org (Postfix)
	id 01B446B0703; Wed, 21 Oct 2026 08:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34E26B0704; Wed, 21 Oct 2026 08:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A486B0705; Wed, 21 Oct 2026 08:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B34EF6B0703
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:52:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E83E1404EF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:52:03 +0000 (UTC)
X-FDA: 85346620926.14.02719C5
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5A2EFC0002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:52:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hp9ANzXU;
	spf=pass (imf10.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792587121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpfC3ycXKcDQY4YCk1HOWqaHxlwyq5m57lBpzL91NVs=;
	b=Eqd73QbXRtP4x8Z+s/myjKxIWejk9DADU4G91mzQ9wC3tr1ALIT2L/hJgUiDL3SSZld37v
	wYQUdIoA7PBIy2xip0D3/wC+ZIp0WP7g7Uv74w4uWckaWsUaVdXyIxXZFL0voqxYAOX/te
	52YzDkmH6kCry8gHSa4CwlNYX6vE2sg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792587121;
	b=47qQ71FSbt6Wb5ZjPyZG378xqGJR8bNgWQYXGHjjiGygUGfN3t56Cu2kdpkHAnTDcBoWBf
	ju0RJrruuvG1Ey558VcKBlhQYh0Krfnnb3FD4+wHQyNof2PdDTXLR25PIMyepSlEbdH+fw
	SxQRuMQDqzg3BeTBQWj4Cu+z8Un+eoY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hp9ANzXU;
	spf=pass (imf10.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c169ae1cb26so285591566b.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792587120; x=1793191920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KpfC3ycXKcDQY4YCk1HOWqaHxlwyq5m57lBpzL91NVs=;
        b=Hp9ANzXUOG0VURdrDH5Xs/B0LIKvW9GNXeMvwQ/PqfEdguMAdg/jNggMD88Gwy5S9H
         NLRP7M18vqig/AREus+rNhOPdjtmEFdkNa0Esugxfvw7MnGeIiQpds3R813OqzEmm1m9
         8ynhqKf3F6qIMbtBhO1hSWvrMqAz5+i62RESmfggN+F5EIgP75lRg1kEgXHZ3pRfkgJ0
         lab5K6LQg179zeCSbtohF8wGMBHg4j0drQRUy6I2jfv+rFyJIwjeZFkk1f2F14noQaKF
         idPCQP/IhAVZZ5lKVHxuOsDs49+uuDObz2OH4i3sR4QBRqp8K0W2NgFX6zORXrmliS4A
         OtSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792587120; x=1793191920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KpfC3ycXKcDQY4YCk1HOWqaHxlwyq5m57lBpzL91NVs=;
        b=AwiYo8fXFpteo/r5RS9macsttjoMVRjxaKpNNeO2y7s6gZoudhMZG7efIbvFEhEqOD
         NuJ/4T8hxPfyThLhrcPVodqetQ4kOVL7hOBnRx/Nv3Z8K7rvhUYmWJplgzwla+lOoN5K
         aRJYcwn5gBnfLCX4KUOwE5w646FR6HXuAWj+eFT5CmKSVg3JuN6ia2UFXjpZ7vdP6CZu
         L+HnRUJBYXLqu1GXPAmvedioqqqCXGYRxnedrVbgsKUno+UmeP8JCng80JSYaWVqGpDv
         kh18i9cib+B6eyxK7O09RTrLyvuxVxMC8CoYL4SjDtXndn4auZy4UIeEhZrkPOWRCIES
         Vl+A==
X-Forwarded-Encrypted: i=1; AKwUvBz5awIuW3gQoenKEyLbZQB53JMbUBF4v9gveDH4NFGaKevCOF0Ur7bKwUjhiKHNPuVo+I4CGpfX+w==@kvack.org
X-Gm-Message-State: AFq9FYK8ubKouSNmsv5ajcOT9s+Zq+ZB44O2UZpcMpygndKHyIiGSCy3
	UE/o7R8r+B+xe2/FnzMv6+Y3UqZEwJ5HIeXKnCW2QECjPrXYzDNU2cYc
X-Gm-Gg: AYBFou1DZDd8adaZwd4hIfmf7klNgpQGubZy6+hutlRfceA3phHWsIFPIGwsQGgmM/X
	SszGSMV5R1p52bIGpACn+S1OBTnWlWwLTGiVqHgLvxouwsxzYfn7d7YB6k3/fBLTwd6BiJevB10
	E8itencrcTwx/vvkKGmA8sgJJ0LNuS3P+u7kQVj+CCAlnyv7Qfazjsc8eA+oIVYWd7AHfjqEbFh
	VTJegW/9RcVOjOwnFBlkYfr1NbEIVOmWezYi4aUIEMsVmtn1cCR6txqnMFRD2Af+6RWwo26FuDt
	d/mW7vak14P63yOTR7j9E1Cnd5anvWT5Wq7g8vj2aNErScW+o/bJySoh3gQTGOSCebMgP6DS2Om
	TA9W2LA+jeXtsnUyAvsPsvZehRfGE32yCrAjXqaMz1gskfwUJSPTesyknDNMMWQJ8cKweDk5MY/
	W/ESiZYgXXxLjO5Obn5faLb+meYAcdSYBVE2tg31aUffvF7TjpCagK5Ar1zlm85bUd63+IpkaPm
	4P2bDOH49GX2gdoMhYTEAg5CtaM/g4RuJVpKxb6QpYh9N821G/ETlYl5Yg81OGChzztJODML0Np
	PxTiVHXC608ArUOmbPhgTVoiShT4fvyy+pI/iFP7Vks8lMh2prphLSvvmvB1i91/Kr1i92UKBLh
	jtvMDGLOqx4psNntC3RhcKpD4CPXuDeaPhkvUeIkypbtMvCXpvoTl7JSRcS8qBk+hEqx2OQqHMa
	DK1OjpqlyVU18+oui+Uc9outEQ
X-Received: by 2002:a17:907:97c9:b0:c42:4557:452c with SMTP id a640c23a62f3a-c460370cce2mr427858366b.8.1792587119735;
        Wed, 21 Oct 2026 05:51:59 -0700 (PDT)
Received: from Ubuntu.tail0f733b.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4679004464sm73128366b.67.2026.10.21.05.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 05:51:59 -0700 (PDT)
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
Subject: [PATCH 1/2] kernfs: do not hold of->mutex across sysfs ->store()
Date: Wed, 21 Oct 2026 14:51:49 +0200
Message-ID: <cd417f2b7f3a978603853d5b0b85439fbbba4c15.1792577179.git.krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1792577179.git.krystianmkaniewski@gmail.com>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com> <cover.1792577179.git.krystianmkaniewski@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A2EFC0002
X-Stat-Signature: kctzne7tngobam3pymugnk7mn6pdwymq
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792587121-558102
X-HE-Meta: U2FsdGVkX19lNx8UH7sLuwze2Ncb1uhMySqDwk5zp1daAsNXZ5fl3EuVUVBN541QcZf1/HCFU4ax9lLBM816OSNVp5grY8im1g/822J/VrKL9qtxkgZnTqZFeQ/5L30Tk5zcn4qjANlfHMKWu/2zUpHowOjlTs1kI6hnEgWxvS07mZ0WjApEcEB+iOUb2Flmr6vc65WL+Fb3beVOKd1RqDQtdZArG2HTcb0FYbdWK99FfRzhBlSUDlVItole9JGb2Tc5GMDXCXlNrIHlNACsMhkQndjEHEicxpqrr9yXcQQp7VHJTAOfy3tlrY5WY8lFDZW9sEUodMmIDhLHH4vzy8clFwolsBt0NF8s4zSaA47FuiCo4Ew1HEL6fy/xj/jNtwyx9HvCAxiENR8p4P8s33Sm+mYgGpERpxPS32103xlAIhZ3d48X8vFlx2w3iel0lNenR4DN50GOpqvbVX7asUugHo7L0cv0okATOa26UK4fQXsN+0F3gWGVk6yLYPFB2CvVgteuH6Ovlu0g4/SbTEd7LRaYLEBGSjOwDQ5LdJJJZxUzrbuxYeJ9Bah9ssCN06y/dBoVtDJPphHorYNT4MSKuuFqCS02OWc1d7Dgt8RfKDFiTNYBCSEJ9i38lu1RMSbHL5LyawWRP6DI4wYJGFOxVoRz1NGDze6viFpbusBQFWXicvWXbo5RIjxn4nHRHPNv4cn8CwUOuBKt8WdkiLkMyzstThdN1dvGVZ6yoftshgxxSZaNcC2CHTSWqgHt9fUoW2jYnUsz96LnK1v3V9RuUX5xlBI5pYE0XDf13URzMYb5QCVUwUgPM6eWsCGILXtmWmNALopO+rCwLqeX3mJirVLh+n+O4jKYlZM0LRi9IxY6VY7gJqaD3tIU0gNL+qMVnze+5wvU1tGInE+JXdxYd4lKkgVuTqrlytwPOynsmAMfx6/fSBqpx3999kUyN9nWKvOfx1p9rB0ptQc
 /GB2AqlK
 Xw0msezntkp4vcrLZqCWJfGVBiJzrpPgD7JFoaggkNdg7sBuXZW4BeCsauxUHw1wiAJ9LiZdwGkkGxOv6Y2khW1A73hku2vK0TI152OI9kYNGyjfD7XHsX2BdWgZsP1k1gZ5h7cu9l2UyYFRAKZCcRNXtz9QF9XXHxzUgViid10vxK0+f/M8K3Z7xMJUrZJfzIITB2aKhnO/SmiXiR9TBJKEINaRZ7tr6AB9r0+mmuyUtA4SkNVFWhQk7XrPu76+DTKHab4bg6Yg4JFEg7Q9j5NcchQ9btZMbyg32WonqdHPIZ5ie3jeJmjz0rvotWdWYOV14X3gMDaRjfTaMycciZNmCRmv+S8CZyr7JniHdSS5IrH6RhxN/770rDNH/MQVooDKyAjNTzeVlAN3OH3LJXVxbzS4o++Onw9lqIOYFmsK67fFti5soC+/XSAINBLtWZrnHCTRgf/9RtZPZlvREL5yMs3l22XJ79MA/Y+3n52Bgl7qck3MCof8XxuEDJOv2TIuYnyCRDJnydQ9qSfxboNsjTeKSrO+kNpH7gzAmo6cDcrcu0GH+vwvdWSqcUA18v/VfdlMM8MRtSf98faTztElmUuYKURepNnYVGtP1Q5H3oYqDzhg/xE5DZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Lockdep reports a circular dependency &pipe->mutex --> &of->mutex -->
&sbi->pipe_mutex. A splice between a pipe and a kernfs file calls
->write_iter() or ->read_iter() of the file with the pipe locked, and
kernfs takes of->mutex there. A write to /sys/power/resume runs
resume_store() under of->mutex, and its lookup_bdev() can trigger an
autofs mount request, whose autofs_write() takes sbi->pipe_mutex and then
the mutex of the daemon pipe.

of->mutex only has to keep the callbacks of one open file apart.
sysfs_kf_write() does not pass the open file to ->store(), and two opens
of the same attribute already run ->store() concurrently. Add a
write_unlocked flag to struct kernfs_ops, cache it in struct
kernfs_open_file next to atomic_write_len, and take of->mutex around
->write() only when the flag is clear. Set it for the regular sysfs
attributes. The preallocated buffer stays protected by
of->prealloc_mutex, and the other kernfs users keep of->mutex.

This does not remove every report through the autofs daemon pipe. A pipe
spliced straight into such an attribute stays locked while ->store()
looks up the path, and a ->store() that takes its own lock around a
lookup keeps that dependency.

Fixes: 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev in resume_store")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=002fb7b2d0bc53bf7e75
Link: https://syzkaller.appspot.com/ai_job?id=74fbf9ab-54e4-46c2-b9e9-7867573ff823
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
 fs/kernfs/file.c       | 52 +++++++++++++++++++++++++++---------------
 fs/sysfs/file.c        | 18 ++++++++++++++-
 include/linux/kernfs.h | 11 +++++++++
 3 files changed, 62 insertions(+), 19 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8e0e90c933720..c954543c1a583 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -291,6 +291,26 @@ static ssize_t kernfs_fop_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return kernfs_file_read_iter(iocb, iter);
 }
 
+/* Call the ->write() operation of @of under an active reference. */
+static ssize_t kernfs_write_active(struct kernfs_open_file *of, char *buf,
+				   size_t len, loff_t pos)
+{
+	const struct kernfs_ops *ops;
+	ssize_t ret;
+
+	if (!kernfs_get_active_of(of))
+		return -ENODEV;
+
+	ops = kernfs_ops(of->kn);
+	if (ops->write)
+		ret = ops->write(of, buf, len, pos);
+	else
+		ret = -EINVAL;
+
+	kernfs_put_active_of(of);
+	return ret;
+}
+
 /*
  * Copy data in from userland and pass it to the matching kernfs write
  * operation.
@@ -305,7 +325,6 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct kernfs_open_file *of = kernfs_of(iocb->ki_filp);
 	ssize_t len = iov_iter_count(iter);
-	const struct kernfs_ops *ops;
 	char *buf;
 
 	if (of->atomic_write_len) {
@@ -330,25 +349,18 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	buf[len] = '\0';	/* guarantee string termination */
 
 	/*
-	 * @of->mutex nests outside active ref and is used both to ensure that
-	 * the ops aren't called concurrently for the same open file.
+	 * @of->mutex nests outside active ref and keeps the ops of one open
+	 * file from running concurrently.  ->write() of files with
+	 * ->write_unlocked set does not need that and runs without it.
 	 */
-	mutex_lock(&of->mutex);
-	if (!kernfs_get_active_of(of)) {
+	if (of->write_unlocked) {
+		len = kernfs_write_active(of, buf, len, iocb->ki_pos);
+	} else {
+		mutex_lock(&of->mutex);
+		len = kernfs_write_active(of, buf, len, iocb->ki_pos);
 		mutex_unlock(&of->mutex);
-		len = -ENODEV;
-		goto out_free;
 	}
 
-	ops = kernfs_ops(of->kn);
-	if (ops->write)
-		len = ops->write(of, buf, len, iocb->ki_pos);
-	else
-		len = -EINVAL;
-
-	kernfs_put_active_of(of);
-	mutex_unlock(&of->mutex);
-
 	if (len > 0)
 		iocb->ki_pos += len;
 
@@ -651,6 +663,8 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	 * lockdep key, because the writable file /sys/power/resume may call vfs
 	 * lookup helpers for arbitrary paths and readonly files can be read by
 	 * overlayfs from vfs helpers when sysfs is a lower layer of overalyfs.
+	 * (Note that regular sysfs attributes no longer run ->store() under
+	 * @of->mutex, but other kernfs users still do.)
 	 *
 	 * All three cases look the same.  They're supposed to
 	 * look that way and give @of->mutex different static lockdep keys.
@@ -666,10 +680,12 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 	of->file = file;
 
 	/*
-	 * Write path needs to atomic_write_len outside active reference.
-	 * Cache it in open_file.  See kernfs_fop_write_iter() for details.
+	 * Write path needs atomic_write_len and write_unlocked outside
+	 * active reference.  Cache them in open_file.  See
+	 * kernfs_fop_write_iter() for details.
 	 */
 	of->atomic_write_len = ops->atomic_write_len;
+	of->write_unlocked = ops->write_unlocked;
 
 	error = -EINVAL;
 	/*
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index cd5bb0f9fee6d..71a7faf434073 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -132,7 +132,19 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
 	return min_t(ssize_t, count, len);
 }
 
-/* kernfs write callback for regular sysfs files */
+/*
+ * kernfs write callback for regular sysfs files.
+ *
+ * Regular sysfs files set .write_unlocked = true and are called without
+ * holding of->mutex. Sysfs ->store() maintains no per-open-file state, and
+ * concurrent opens already execute ->store() concurrently without
+ * serialization. Calling ->store() without of->mutex avoids circular
+ * locking dependencies when ->store() performs operations like path
+ * lookups or automounts while a generic VFS lock is held (such as a pipe
+ * lock during splice). Preallocated attributes still serialize buffer
+ * access via of->prealloc_mutex. Existing autofs and callback-owned lock
+ * dependencies remain outside this narrow change.
+ */
 static ssize_t sysfs_kf_write(struct kernfs_open_file *of, char *buf,
 			      size_t count, loff_t pos)
 {
@@ -229,11 +241,13 @@ static const struct kernfs_ops sysfs_file_kfops_ro = {
 
 static const struct kernfs_ops sysfs_file_kfops_wo = {
 	.write		= sysfs_kf_write,
+	.write_unlocked	= true,
 };
 
 static const struct kernfs_ops sysfs_file_kfops_rw = {
 	.seq_show	= sysfs_kf_seq_show,
 	.write		= sysfs_kf_write,
+	.write_unlocked	= true,
 };
 
 static const struct kernfs_ops sysfs_prealloc_kfops_ro = {
@@ -244,12 +258,14 @@ static const struct kernfs_ops sysfs_prealloc_kfops_ro = {
 static const struct kernfs_ops sysfs_prealloc_kfops_wo = {
 	.write		= sysfs_kf_write,
 	.prealloc	= true,
+	.write_unlocked	= true,
 };
 
 static const struct kernfs_ops sysfs_prealloc_kfops_rw = {
 	.read		= sysfs_kf_read,
 	.write		= sysfs_kf_write,
 	.prealloc	= true,
+	.write_unlocked	= true,
 };
 
 static const struct kernfs_ops sysfs_bin_kfops_ro = {
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 351a5101c8628..cbb09f9533e72 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -272,6 +272,7 @@ struct kernfs_open_file {
 	char			*prealloc_buf;
 
 	size_t			atomic_write_len;
+	bool			write_unlocked;
 	bool			mmapped:1;
 	bool			released:1;
 	const struct vm_operations_struct *vm_ops;
@@ -320,6 +321,16 @@ struct kernfs_ops {
 	 * ->prealloc.  Provide ->read and ->write with ->prealloc.
 	 */
 	bool prealloc;
+	/*
+	 * "write_unlocked" indicates that ->write() does not require
+	 * per-open-file serialization with of->mutex and can be called
+	 * concurrently for the same open file. Callbacks must handle
+	 * concurrent execution. Buffer access for preallocated attributes
+	 * is still protected by of->prealloc_mutex. Lock dependencies from
+	 * callers (such as pipe locks during splice) or within callbacks
+	 * remain outside this scope.
+	 */
+	bool write_unlocked;
 	ssize_t (*write)(struct kernfs_open_file *of, char *buf, size_t bytes,
 			 loff_t off);
 
-- 
2.53.0


