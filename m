Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 874A0C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CE46B00BE; Tue, 15 Sep 2026 07:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755356B00BF; Tue, 15 Sep 2026 07:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F516B00C0; Tue, 15 Sep 2026 07:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 409E26B00BE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:35:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD3C6403DB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:05 +0000 (UTC)
X-FDA: 85215790170.06.573636A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 053BA10000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KA44M0cm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KA44M0cm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472104;
	b=pgYyBirmAVA1zH5a/1MEYiYjJmm5jNz0S/avbjt7sOh0flemxJW2vNFOIazB6KEs4v+tvp
	eMGTLPbbCmBPIfmXJjjMm/OGzBtCZuQnuv81LMCUvwJVbmy9mZedR1fL+/NpOBuD851/lB
	+cbrcAU/S5WTSeVWj3tqvdlJvhvwM+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Z7YvZoUhgCp4iTA46gJpRmnztUthrtoZVj66HfgwUY=;
	b=C8V41YSQkUuQ1BjVLT6hoqEmm7WCRUOL6Ii5Zj3/smOhJCp67PT24wr3xxR8aJNWOwhpwu
	z78cNVnvy5I2Jq9mbnadVZMX60VlRjzbVRVX9BwzDnXiGg+dEX6Z/Mf3gYIX/MzqZxbxLv
	/C3F/qa5+rKpFVIf2qewq9aM5Wtj9oc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59D75415D0;
	Tue, 15 Sep 2026 11:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C030B1F00898;
	Tue, 15 Sep 2026 11:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472103;
	bh=+Z7YvZoUhgCp4iTA46gJpRmnztUthrtoZVj66HfgwUY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KA44M0cmNF2mMlF/NDPOuyRWz4vVkHxzKiMxMZ4ISNNfo7H9BTar51IZgT37QoJX1
	 6srepTnNRPf2DDq8k0Xr2lGax/zEGP29xcg5Q8NVjuDbwOO/px017DffFztmjp8Ha+
	 BN9rxQ+ckzz66olSbf9AzLwaWhDMxhbiTnSee7sd06Ig+WHUQKBNw53tm8cd+iRMgv
	 H7ptnEs+6ym+zmmY2nGMKn3UT9nTIljKiF99YIGQvS2ezwjHF2FGWp1leEB/9nrbJj
	 zA9+UppFgEv9UDF+Tete4exU2H8M/NSppcn+lHJLgDsGhlGujiOkLCF8yydq5B/Mxi
	 RYtXu9Hi+fWsg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:15 +0200
Subject: [PATCH RFC POC 29/50] drm/virtio: install the out-fence descriptor
 when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-29-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3421; i=brauner@kernel.org;
 h=from:subject:message-id; bh=p0ASybizHVeWg3+K+2/U4eYr0FkEait3G8m6yrPnxug=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KlTnNOyTUQz0y+rQub5bi2Wdr3pRa+cWq6FHSt8z
 FPyLjOgo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLPhRgZzpcEpJcv22rRdtX7
 cKbUFkn/pfMZNuqxXquY3F4nrdInx/CH946PZqsxs8HCIweudkmFfO3eM+HpqaU/s9ffmbhJTXk
 XOwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 053BA10000B
X-Stat-Signature: 1t9znuqj8c8k9h7zuqrfeyye85abmn9g
X-Rspamd-Server: rspam01
X-HE-Tag: 1789472103-651185
X-HE-Meta: U2FsdGVkX1++nPl7SUVEoc6PAbDx+CSduOElgtuRns4yyoLInTRMCJd2Ne3D2PJnwtAbx+GHqWVkvspR8pxp4W+uj/BKn2QylL4WOMqOYfJMK6s6vxQEHhcPa5eKeoc+vagdCXJHvYhbrANJ+Ii0zCB+QjxlL/fZQ7EPlOQoR8VBHVu6pTOoi81Cff3Xub7+1eDZY+eQA0INYio/A6gLwAkarUdVcvzXmmzfYqNCxzpZOqKrC7ZgyevVVCWTmACWA1D6UntwUOc20qcq2y0mbkiUH5qmi39VRBKIlkaQFTksVLupt9iaODEjkpVPzjDepgnxJ4lUoaZOjQBXFiJtXpT1xorr67GENK8FO/Z17QIDdXKxnnuQWV+HXiiEE9dOXm9CIi2kuA/IFbTWNNEUU1PxiZNBW5toI42NT0P53mrvqJzuOyc4El2iwe1exRsQ+d8thYD40wgrpmQr7+O/Jk4+sgzLOlQLkTf9xELRQhC75s3qtTOuJ2yg+ovicPXlRC7HTcXm+D9W6Ay4J7uFv7cwbwsYcjAJ3JR1a+53ZCyIMo8GzyCOQ2m+8XJXPHUNHQURhB5rbe8lFE2a0FeglhFeb8ClvjwIszOjIxayGEZJAHkcpl2DfccTOo6wej8m9nG7bWbXMCg0yk12Ak9iNgo4FPdB1/Yek11yp3oRqIdzkmqtyaGphSprrhjJg77lDzZpjdVcVux0iDH9Byl7IfevIjd4LYjkL0hq/jqEuMUxXIkJlS5BZkGl6wnyji63k2WKYygLDgVmSbHxKmnfEW9Xf33J55M++1+VI5tObBH887RkkOSb+MyVIdr8wBk4aOeFe2/LInnYQPIQcXbbfc29qpcBOXyFSWLAJGEH6Oy7JuLNlkpPkCjXMeih3dZNZIbJfPOZSIRDh3K/SzALA7bfKgm+eYpAVHZgTlYiarxX3/s6X9G3SSuBCQo58KsFPmbmBmDdlYeI3t5uEjg
 74SpcW/0
 QMnndoGnP+qxj+SU4KHGxH8gJb7rB0Ow8Z6ICtKfyh4B8CRjScaxiDGFzeZpdlu7exudcKGpQsJPV+gdMtOEmOrB3resT99RhdnhZ7CBXvm1VZcqDBSZKCKTO3PRtn+Esng2U0thEF+ALL1ACyDaaVBF43hpjnR9Y+VuyUNrCfKjod009dHh8Ab0yiCDzSCJAEz8zVDxIiV00psz02UEqV5KilbPPSxP0ng6uYo6XF1e32LIejaLzb/UcNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_submit.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_submit.c b/drivers/gpu/drm/virtio/virtgpu_submit.c
index 32cb1e4aa425..51b224acb72b 100644
--- a/drivers/gpu/drm/virtio/virtgpu_submit.c
+++ b/drivers/gpu/drm/virtio/virtgpu_submit.c
@@ -39,7 +39,7 @@ struct virtio_gpu_submit {
 	struct virtio_gpu_device *vgdev;
 	struct sync_file *sync_file;
 	struct drm_file *file;
-	int out_fence_fd;
+	const struct fd_slot *out_fence_fd;
 	u64 fence_ctx;
 	u32 ring_idx;
 	void *buf;
@@ -340,14 +340,8 @@ static void virtio_gpu_cleanup_submit(struct virtio_gpu_submit *submit)
 	if (submit->buflist)
 		virtio_gpu_array_put_free(submit->buflist);
 
-	if (submit->out_fence_fd >= 0)
-		put_unused_fd(submit->out_fence_fd);
-
 	if (submit->out_fence)
 		dma_fence_put(&submit->out_fence->f);
-
-	if (submit->sync_file)
-		fput(submit->sync_file->file);
 }
 
 static void virtio_gpu_submit(struct virtio_gpu_submit *submit)
@@ -363,7 +357,7 @@ static void virtio_gpu_complete_submit(struct virtio_gpu_submit *submit)
 	submit->buf = NULL;
 	submit->buflist = NULL;
 	submit->sync_file = NULL;
-	submit->out_fence_fd = -1;
+	submit->out_fence_fd = NULL;
 }
 
 static int virtio_gpu_init_submit(struct virtio_gpu_submit *submit,
@@ -405,7 +399,7 @@ static int virtio_gpu_init_submit(struct virtio_gpu_submit *submit,
 	submit->out_fence = out_fence;
 	submit->fence_ctx = fence_ctx;
 	submit->ring_idx = ring_idx;
-	submit->out_fence_fd = -1;
+	submit->out_fence_fd = NULL;
 	submit->vfpriv = vfpriv;
 	submit->vgdev = vgdev;
 	submit->exbuf = exbuf;
@@ -420,15 +414,15 @@ static int virtio_gpu_init_submit(struct virtio_gpu_submit *submit,
 		return PTR_ERR(submit->buf);
 
 	if (exbuf->flags & VIRTGPU_EXECBUF_FENCE_FD_OUT) {
-		err = get_unused_fd_flags(O_CLOEXEC);
-		if (err < 0)
-			return err;
-
-		submit->out_fence_fd = err;
+		submit->out_fence_fd = fd_prepare(O_CLOEXEC);
+		if (IS_ERR(submit->out_fence_fd))
+			return PTR_ERR(submit->out_fence_fd);
 
 		submit->sync_file = sync_file_create(&out_fence->f);
 		if (!submit->sync_file)
 			return -ENOMEM;
+
+		fd_stage(submit->out_fence_fd, submit->sync_file->file);
 	}
 
 	return 0;
@@ -456,12 +450,10 @@ static int virtio_gpu_wait_in_fence(struct virtio_gpu_submit *submit)
 	return ret;
 }
 
-static void virtio_gpu_install_out_fence_fd(struct virtio_gpu_submit *submit)
+static void virtio_gpu_report_out_fence_fd(struct virtio_gpu_submit *submit)
 {
-	if (submit->sync_file) {
-		submit->exbuf->fence_fd = submit->out_fence_fd;
-		fd_install(submit->out_fence_fd, submit->sync_file->file);
-	}
+	if (submit->sync_file)
+		submit->exbuf->fence_fd = fd_prepare_fd(submit->out_fence_fd);
 }
 
 static int virtio_gpu_lock_buflist(struct virtio_gpu_submit *submit)
@@ -534,7 +526,7 @@ int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
 	 * Set up user-out data after submitting the job to optimize
 	 * the job submission path.
 	 */
-	virtio_gpu_install_out_fence_fd(&submit);
+	virtio_gpu_report_out_fence_fd(&submit);
 	virtio_gpu_process_post_deps(&submit);
 	virtio_gpu_complete_submit(&submit);
 cleanup:

-- 
2.53.0


