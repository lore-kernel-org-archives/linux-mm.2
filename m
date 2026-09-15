Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D15C982C4
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CAF96B00BF; Tue, 15 Sep 2026 07:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A40F6B00C0; Tue, 15 Sep 2026 07:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695946B00C1; Tue, 15 Sep 2026 07:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D02B6B00BF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:35:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8B40C03BB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:13 +0000 (UTC)
X-FDA: 85215790506.11.CB157F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE9E1C0008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dekb8smf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dekb8smf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472112;
	b=gYy5jiDwv3WBZwXLJuEcmxrEm9sXnZqZx8cWjIHxSztXwRSw96q/FSA4SD3LsBBR4W5lIb
	+/af0A5jJi8J87xixLPkOnyDnBrW3psE7Qo40jitoV9N/Q2dy3H8OznPPWZtjALR1uh4G5
	g4bgx/NYYzeh7Z4pJXKsHPYSMej1iT0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BaiQKOdzM8NM+WnZnsY02ffmMIwkfiUXQItc1CF3f8Q=;
	b=ndjyVaQa6uTK6fU+JgUdhey1KCFl7dt74D6pjZPNBbSGXD1bG+PbcPnWOkwnTe4Rnek7sd
	RJwqWg6guJyE5vaxPYteKhXrGiAVtae8uZGAQRunJKcTTEkRn+hLaQwpqcpNYwPeYsDLad
	SgTa6+Js1DOKHhA/lOLQojB6sTSVeHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39B1A429F8;
	Tue, 15 Sep 2026 11:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11231F00899;
	Tue, 15 Sep 2026 11:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472111;
	bh=BaiQKOdzM8NM+WnZnsY02ffmMIwkfiUXQItc1CF3f8Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Dekb8smfKI2n5yGWIpNEMN0jdgTr4spZdVK3MdD/TCKNKco8XRVA1TQl+GxXP21IR
	 mQ1bfkZDLmhKqxrPetlmFnyIp76FwXgaVFoceDbmku29MuUZSQS/RfIncrnkMTBqkg
	 IsK8+0mFLEiKooNi0Ql2Y8fw+QKMPZyQpJ0DxXA6DHNh5fdea9CSHRxHeWPOu0c9b3
	 eXo0ja9rpUrTYduFglwTe8Jute8IZc768Hl3Jb0QwhrUuoIFCwPR0au4hj53ko0ecq
	 gFl4P7NPfeiu/9IfvP8VqLsljSKHoYKJSA97s2sEcmTCisygMQvKIWdbiZ4j2ejXUG
	 CzttZl/23iXnQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:16 +0200
Subject: [PATCH RFC POC 30/50] drm/vmwgfx: install the out-fence descriptor
 when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-30-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2552; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tFtZ4cL0NphK82dRD7+3sjxv1Q+YPE/6KXVfeTbJao0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KmT96hOWNmU/qLa/h57o09DBu/EH9cY+lcu13eXn
 l+3V9iuo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLKcQz/Mxl6ebeze05NNe4M
 0FAtDVBmvSBeuO2BBu/r/juTJPP5GP7wZvx9JTPBIYjfMCaNkc/2ZcaSF9xnJPsurtiQL5V+QZc
 FAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: DE9E1C0008
X-Stat-Signature: iw6g6hd4bqbszjzjp16fr911fnjywx3s
X-Rspamd-Server: rspam01
X-HE-Tag: 1789472111-485384
X-HE-Meta: U2FsdGVkX1+ujkR0J4PUSUi45uwrwSbMvLyWpmaG/70KpD16FtcRbXeAVC+2oTMgA8VhejBYObgtgrwINIrAnnqtm1yn5/cCThYz6cuZ9KzrDnG1aBUJfiTQiANSSYuG2oois1KIWeJiWOVtXlgUTTRruOHtRSq3H1dWMCyOZKhnWjE9Ktt18VuTzXy+at1oUyUwjETVAiKSxppD/uQw9Gp9USMCwAA8S4XKw04X2b7VMGWWgGsDzMevxS3jOgSPV6495YoXwh/kr4uWeM9h0X+HwBxQXqJVAhooI6s3Ihh5sqt2SU9uNSKav42+K6QMxjzcWgieljqbNFFjmZB/4lzXGKEyOUyPZZI3Nrvi5Y5i2fAmhwV3v5QALfHTovazxSQEKuUpT+nw4kQMIYDpFB+wHtGIsz1rdoxt21GoDhvqczL6fOOBqPe5dHnT9jZev9XBtdrs34JLtRRK/RqhGMqoG3yBYs/wqBJfr2skRnf9QSbKECPS6pU5kTvBhPgVApYwuEmT+N9A9Et8Xsjh6gMfAUNjOjLp3+r7jT+XKr2avUWXkJtfapkMlaznrl5vEj8jJXJJvMCaw1jAmzaq4eaqSHlDhQoYcr+2VTbptdwWqjBPTGKslk51CV1YXAy3EERB71kCjU/tDgvfi8vRHK7NG7qqsA8WdEyOy8Z0bAY1SuOy//AqZTnOlqLUdQuFkAx1iAKVTmcDBt711MM19OmlXWwHEfUq1x0g3Hl6CJCu0LcrXcJIyPlDnHqTLNQv9NXpz72I5xCOW/xkVEn5B/9/KAWPR1UZUr70zM0PmQah55f5hDdvKEibRuIqLBMBYO0dFV+HOREbR6h6RVm+AYBl0OPt6AXcPZ+RrJxbnvW/okF3Nf0+3zLcGZNga7KzyTj46joiN+66GXAeu7NucA8pq4ldmiVS2uhtAEntMmcx+HDiosf9Eyl1VAeh/ue1orZj6MHye030HfgjJ8E
 +P/pN3xM
 ihmH+3wgIedG9y+XU4aZdC3NWBtZcG0cbCFPyEV3FqiFRPupLtnypE9d4TEftjK14O59lgmDpBZbJqXU5WROhU8hSvzLtkyfuG3xare7N5rUr/EynznMZ44LJn6GUyZJCfKxxooYR9TY/uHWbYHw4iRjIKe3Oc0fMLt3pOHegDAnRVpr5ebEyjkrUMNmVB9gNGhUISjgLXcfGHVEsOkIjjJmQlPM2K+QOFv1qE3PMR8eiONBZGHN9dXcQjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index a9136a6523cb..9daa74a13485 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -4109,15 +4109,17 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	uint32_t handle = 0;
 	int ret;
 	int32_t out_fence_fd = -1;
+	const struct fd_slot *out_fd = NULL;
 	struct sync_file *sync_file = NULL;
 	DECLARE_VAL_CONTEXT(val_ctx, sw_context, 1);
 
 	if (flags & DRM_VMW_EXECBUF_FLAG_EXPORT_FENCE_FD) {
-		out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
-		if (out_fence_fd < 0) {
+		out_fd = fd_prepare(O_CLOEXEC);
+		if (IS_ERR(out_fd)) {
 			VMW_DEBUG_USER("Failed to get a fence fd.\n");
-			return out_fence_fd;
+			return PTR_ERR(out_fd);
 		}
+		out_fence_fd = fd_prepare_fd(out_fd);
 	}
 
 	if (throttle_us) {
@@ -4256,28 +4258,21 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 		sync_file = sync_file_create(&fence->base);
 		if (!sync_file) {
 			VMW_DEBUG_USER("Sync file create failed for fence\n");
-			put_unused_fd(out_fence_fd);
+			/* The reserved descriptor is released on return. */
 			out_fence_fd = -1;
 
 			(void) vmw_fence_obj_wait(fence, false, false,
 						  VMW_FENCE_WAIT_TIMEOUT);
+		} else {
+			/* Link the fence with the FD created earlier */
+			fd_stage(out_fd, sync_file->file);
 		}
 	}
 
+	/* A staged sync file is dropped with the ioctl on error. */
 	ret = vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv), ret,
 				    user_fence_rep, fence, handle, out_fence_fd);
 
-	if (sync_file) {
-		if (ret) {
-			/* usercopy of fence failed, put the file object */
-			fput(sync_file->file);
-			put_unused_fd(out_fence_fd);
-		} else {
-			/* Link the fence with the FD created earlier */
-			fd_install(out_fence_fd, sync_file->file);
-		}
-	}
-
 	/* Don't unreference when handing fence out */
 	if (unlikely(out_fence != NULL)) {
 		*out_fence = fence;
@@ -4323,9 +4318,7 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	if (header)
 		vmw_cmdbuf_header_free(header);
 out_free_fence_fd:
-	if (out_fence_fd >= 0)
-		put_unused_fd(out_fence_fd);
-
+	/* A reserved descriptor is released on return. */
 	return ret;
 }
 

-- 
2.53.0


