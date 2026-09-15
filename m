Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7288BC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757266B00BD; Tue, 15 Sep 2026 07:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E016B00BE; Tue, 15 Sep 2026 07:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7836B00BF; Tue, 15 Sep 2026 07:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 282226B00BD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:34:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B45D21403BB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:57 +0000 (UTC)
X-FDA: 85215789834.04.E73A4E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 03BEA40006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:34:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dILdN8rE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472096;
	b=zzljt90umA1TAYwbYSPFrtmwJiRp3jAA6WEDtAZQZOQln7hG+iZishRa+62SQmq9cPj5M1
	2E1U/aRXnGUgCDbV8nyezAhYHuicAY22J/5YWStxPzG2WDoRSRRNT3vu/nLR7lw7mKTkvq
	S1xFhSFH7jDj56HCuL+oZ98JxL1I10M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dILdN8rE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cxkt5ZZmGkjFd539Cl9RA+9e8VT0n+2aqKlnDvtva3g=;
	b=qp4Hz5svWzf307/d3Z3ZB9/kH3gTDuLbE0MhncUhDPG80ikKc7CI9K3ArCNL+9WgGbYaH8
	c2/tiUtD4uwDWP124GZFwO+Fftpp8tzOdg1KrXLO3EzALRuDXmzpdAV0fXmOIIQ3zEnalr
	0seJpTAZsusCwNwBJrXS/RJ9rsEkXVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97AD0600D1;
	Tue, 15 Sep 2026 11:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047041F00893;
	Tue, 15 Sep 2026 11:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472095;
	bh=Cxkt5ZZmGkjFd539Cl9RA+9e8VT0n+2aqKlnDvtva3g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dILdN8rEl6D0AvNs+ADrv4qyz7XFz7x4boFlXmBNHuzp8dsfrNxC3GxAas+GJFMv+
	 KJnK0aX5JPblFXsMNwsHCIlkZII+0cYJLUL4usXBn+tv30sxD+kVeBTY5hcwuU5iTw
	 MXYhBhYyk8HliVAWPS90CFPCshSX6kinnV9G6S3iAxfflAZBj+c9/TE3CiaFW3hDG7
	 dRdxg6OcMTB4GCjwlFFQl9XbyBURQfFnRT9yVIi6yc8yWO4+AzWpSl0LOZwVL0qtIE
	 Rv5L8GTAkHFUQiQIsfVM5d6ZEM2JM2QT8a+Fnw1EggkywbFsnu2tEM8H3ZlrtZibQk
	 qheZhWDLwLoTQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:14 +0200
Subject: [PATCH RFC POC 28/50] drm/msm: install the out-fence descriptor
 when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-28-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3900; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0aF43DhxqkdJzKcsExOwjxx4MBfkynUOKohe+cP6pHo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KkrWhO2ocr+XsOZ92nMd0VvHVZ7Ky7587iN4qmUy
 EPVDqtUOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZixcnwT519/+ba76oz/vy5
 vmjf+l1Wu2z2blt9XNlWNjDylNSVxs0Mf2WKlse//zVlb82qCaECXSHqTPxv9vQ9tHvbvedgQGZ
 ROgcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03BEA40006
X-Stat-Signature: 1b3kn8tqf86gopqj66hwwqacw33qmjhm
X-HE-Tag: 1789472095-497040
X-HE-Meta: U2FsdGVkX182hJMMHP3mgGHw6B/lkCtBPH7PlEQ057U+XJPA5I3iLD7oE17WvjQf2WPFln5NFqYFpjvk2tKA1Uocu9n0lrs3ebazo01q/yG0zvK6MPuTnXdNhmiiS3bdyVSakpRzv4BeEp5bvJO0F+xHKNGd6K4J98bkeb+VFJJm5eKKTbRSxBgUpUVZ80RTxYSCyNjVyrjG6xtBEiiiisFr/3vhtFcRv5PeA8f2Asc/8872Qq1T6CkDSNO3P5hdSkxzSzGy3eUnFskaAAlgElNmJL7LLiedtZc7v1cstwde8td1+C+L4VsjmQDzjf37aoiytiLB24H8Aj62ldLRbze28IzOUkVlssRX7Rgi5uo0PL45J2oqc77hYFBuKD1rmskGfN7B363urFzPQpbGSOYEZE6jaCDtfiWgHvM3GcEJ3pGYXPOBBtbRCYkyehPfsfC1iQ7JXgjyRoh2EYa1kPLpYmYwSU2T8OibXimp6DKRykEGkLzgNblVAoOYdLIrHPZYlq2227awDAnJOeVJuvFCNbBIjYG8wJtG4pkMyk8hmpB0gchFBVu6T+B/9f++0Xk2ytSV21j/6RhcumdK9eL1Iw4hiJbxdm/ysH+kNSyAJtvjpY+9vn+YZ3f2vorT8dq9eZ67PZvtMgHskCIgp/d5LI1eYbek2hhI5mQEl8LU+lVpMwKXPXxzwiNAZ7FcCSLHydETCc4rh7e+71aAZoLQHefcWVql+IoXrcqcSTFPWmeCCT3efZrmuHHVsS6q3biBaU1NpZFkwb9jYjJvIEXMUoIKTAqHbNSTzhyLOtAEFR4vzo7Rp8j8XajwVGmQMjJP9Q6S+HtIcxCgwRUtIxwYMtzh8W4V/wybC+z1vdY16vCZEBFopOkz9fgVFws/6qMZXm/I9V6FObFA2/NGiH32yIB+t4n04Dg9ZZaw9p3w8nkbDsYol/OGoj3/Tz5R2csRLefxlnfFbEJlVa6
 tItvjSbN
 SEsQrZJxJ+8c/cIGNwaQv0h2jlCV6LUsje1JuuQxLDu6pGtQtsgIROfZ98QZBPVgkWNw6hT8J6WeCx2Pykfh+4VcAkDU7jMmm1FVCPfpLfror4D6MNbkJHH5rDFYi7NWog7i8mcjH2Cbnq3VRicjcoaIQ4N8riGQaXPue6zKTS+oNiNyszUC6Op0xFCkGxwYiDjKP6kKVdeCaRF0pB7d+n4AqnJDR9Kl8bRIBjGhHSRgTUqXj0sbh85IVsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 22 +++++++++-------------
 drivers/gpu/drm/msm/msm_gem_vma.c    | 22 +++++++++-------------
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 5862db05297a..4ddfd07c1480 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -558,7 +558,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 	struct drm_syncobj **syncobjs_to_reset = NULL;
 	struct sync_file *sync_file = NULL;
 	unsigned cmds_to_parse;
-	int out_fence_fd = -1;
+	const struct fd_slot *out_fence_fd = NULL;
 	unsigned i;
 	int ret;
 
@@ -601,9 +601,9 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 	ring = gpu->rb[queue->ring_nr];
 
 	if (args->flags & MSM_SUBMIT_FENCE_FD_OUT) {
-		out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
-		if (out_fence_fd < 0) {
-			ret = out_fence_fd;
+		out_fence_fd = fd_prepare(O_CLOEXEC);
+		if (IS_ERR(out_fence_fd)) {
+			ret = PTR_ERR(out_fence_fd);
 			goto out_post_unlock;
 		}
 	}
@@ -777,6 +777,8 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 		sync_file = sync_file_create(submit->user_fence);
 		if (!sync_file)
 			ret = -ENOMEM;
+		else
+			fd_stage(out_fence_fd, sync_file->file);
 	}
 
 	if (ret)
@@ -814,15 +816,9 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 out_unlock:
 	mutex_unlock(&queue->lock);
 out_post_unlock:
-	if (ret) {
-		if (out_fence_fd >= 0)
-			put_unused_fd(out_fence_fd);
-		if (sync_file)
-			fput(sync_file->file);
-	} else if (sync_file) {
-		fd_install(out_fence_fd, sync_file->file);
-		args->fence_fd = out_fence_fd;
-	}
+	/* A staged sync file and its descriptor are dropped on return. */
+	if (!ret && sync_file)
+		args->fence_fd = fd_prepare_fd(out_fence_fd);
 
 	if (!IS_ERR_OR_NULL(submit)) {
 		msm_gem_submit_put(submit);
diff --git a/drivers/gpu/drm/msm/msm_gem_vma.c b/drivers/gpu/drm/msm/msm_gem_vma.c
index c11d021581e0..77d365566732 100644
--- a/drivers/gpu/drm/msm/msm_gem_vma.c
+++ b/drivers/gpu/drm/msm/msm_gem_vma.c
@@ -1441,7 +1441,7 @@ msm_ioctl_vm_bind(struct drm_device *dev, void *data, struct drm_file *file)
 	struct drm_syncobj **syncobjs_to_reset = NULL;
 	struct sync_file *sync_file = NULL;
 	struct dma_fence *fence;
-	int out_fence_fd = -1;
+	const struct fd_slot *out_fence_fd = NULL;
 	int ret, nr_bos = 0;
 	unsigned i;
 
@@ -1479,9 +1479,9 @@ msm_ioctl_vm_bind(struct drm_device *dev, void *data, struct drm_file *file)
 	}
 
 	if (args->flags & MSM_VM_BIND_FENCE_FD_OUT) {
-		out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
-		if (out_fence_fd < 0) {
-			ret = out_fence_fd;
+		out_fence_fd = fd_prepare(O_CLOEXEC);
+		if (IS_ERR(out_fence_fd)) {
+			ret = PTR_ERR(out_fence_fd);
 			goto out_post_unlock;
 		}
 	}
@@ -1565,6 +1565,8 @@ msm_ioctl_vm_bind(struct drm_device *dev, void *data, struct drm_file *file)
 		sync_file = sync_file_create(job->fence);
 		if (!sync_file)
 			ret = -ENOMEM;
+		else
+			fd_stage(out_fence_fd, sync_file->file);
 	}
 
 	if (ret)
@@ -1593,15 +1595,9 @@ msm_ioctl_vm_bind(struct drm_device *dev, void *data, struct drm_file *file)
 out_unlock:
 	mutex_unlock(&queue->lock);
 out_post_unlock:
-	if (ret) {
-		if (out_fence_fd >= 0)
-			put_unused_fd(out_fence_fd);
-		if (sync_file)
-			fput(sync_file->file);
-	} else if (sync_file) {
-		fd_install(out_fence_fd, sync_file->file);
-		args->fence_fd = out_fence_fd;
-	}
+	/* A staged sync file and its descriptor are dropped on return. */
+	if (!ret && sync_file)
+		args->fence_fd = fd_prepare_fd(out_fence_fd);
 
 	if (!IS_ERR_OR_NULL(job)) {
 		if (ret)

-- 
2.53.0


