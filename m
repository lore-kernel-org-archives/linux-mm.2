Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B202BC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C609E6B00C6; Tue, 15 Sep 2026 07:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39636B00C7; Tue, 15 Sep 2026 07:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E396B00C8; Tue, 15 Sep 2026 07:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 967B46B00C6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:35:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 443B21203EE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:53 +0000 (UTC)
X-FDA: 85215792186.13.D5114BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7C65FC0009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdYtXPMr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYwvcYgPe7F+yniz25uY8kYzwfi4Dpf3GuV+JDSn+cI=;
	b=UayUfejsbGy6SithxKeg9fhRZj7RXMEiOXEf8JfxYl+3VZH+z7yBgYpdYEZrsYVvrB5nLR
	jvfUireNbtXAMgNNpsABYni6YUPBZOwxvjtbenTBQYmtXPjWo20rt+3a6Yv47t1csbbO3C
	vAjhgZd3Rq3XcqFXH0UQFCR6OCcU9zI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472151;
	b=CEPO9Jo8UY9yvF5HLUYcU82OYzgmX3J8yWo5nblX7gaw10m+mQv/6X4ZvXE0QTSzFRjQu1
	Ek/q7Fd2QbfjLc59eShIvmvF4nuMXu+Qq4vhVYRizaCAgtRKpXcoBFbwDCx8/7tmE0pQf/
	qnB0pqEzFmhR2wOnshUA1291G+15YAg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdYtXPMr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C705841253;
	Tue, 15 Sep 2026 11:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDC21F00898;
	Tue, 15 Sep 2026 11:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472150;
	bh=RYwvcYgPe7F+yniz25uY8kYzwfi4Dpf3GuV+JDSn+cI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MdYtXPMryZ+6SAlSbL19CQpX3Z64/AWWELS/WUVzAp8Xg1GKcwta2ZBYcN6wG36Mt
	 as5Dtg1uHZx0++57+0zFQf62SXXotYbTuzCZx9KtLUQmxwarrRVEc5GHr8NgTGLTnD
	 fm7wTaE+frwG78TGBDzq5+X5mT91CNgxDsAlIIvj/82S1VRyMtU0YNLM25MFctgbyo
	 vTKRbl5GQlZXJ0hhVYRlwEl093ozZ6/IECB99aVD24EC0zmPYaRRHVzNiU6egwU8ae
	 gX3+hqTSVslPaF8dAefZoz9w+FElBtfBAJO7mXAQPx7QPzbOBB9Xhv3/9TzLihtFHy
	 3qlJrcB+1giaw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:21 +0200
Subject: [PATCH RFC POC 35/50] ALSA: compress: install the task descriptors
 when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-35-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2232; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QV1nvuOZOTXbG885TIwwr0E5buagCxFnNDHDpDWzkd0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kk7NZFnW/2OMo2T/F2ffljdXrzpyBybxa2xOhV3m
 5euvTinqKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAidmKMDD3u79olF+/8fDpn
 05GGxJ924Sr7JVZeMFmoxWl14Jl/rCQjQzvbH6/0789fvC17P2P1pnCZsljB76s+Sl9/e0W5ZEW
 eETMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7C65FC0009
X-Stat-Signature: f3djtxar9gaturejc8mhgcqopanm7as7
X-HE-Tag: 1789472151-473142
X-HE-Meta: U2FsdGVkX19SkQycHYyB24f3pSgHRmXmXLeM9VtNlf9Gn3CwCe7QuubbnZsw+jKWDn7kt50hNuXN5WC5IUOcgT/oyBuLQfv/P/2dnAFaKvlfAMwtQtaKb8ET9M5cVQvyk/f/t41cxNocXkdY43JjorXpwhhMz5Xz4Brdb3r2jf7N6Rf8IJK3Eg3/9ylbKDN9W7jgIrTkRihLWSkmMKzmfa4pu+JSidhmiTYw69z68fC66VszOMjSjix68dYBxKZYJtErCpR96lxw5lDpceXE9FzJE0KcOWNkf6+XAP1Pf9lI+XdKVthA9RTzZPziBOCAgISEN3bwHAJc/p3LG+1zvznYVPjBfkyV/QUnetuq77KuhHzNPMWp+1fGIqIIt3PZ3BEVfa3nqnVnY+OReZv2/qDPbBqqihezD64dpvfs7EXZWSotYknrakOWPyXuPHzJTXw8dmB0FdKm1FKrQLnuZU94I7Fws8cDlaQ49v9wJwkxsxWPk2NQU1LikfJnxKOYPBqwSTpQlJhD3nYBRKJIyX33RCR9Ok7b8y9DuTcDVhQUlHqNRjjATa2RqQ8mc+G20XgLDXx2PXibMg1FseNxuDCuQxUFcHB1uYf5MAMSw9lV+AAroVW6uwT1XW4MVv8gtPUpa5RQ6pxoSYdML7Ymr3GYmacRx9NktgdVtraH4HKTuhRvd0VBl6fvCRmRNFAYt9pNTV9+/GDPP2nZmV+x++h3U8GUPIhxI8IA2bpsg4gdcuE9Vl65c4/F6jNzzG0OHjySiAOWDzBem2k5q+y8wrMUPOuME/5SrRX0ewtrYvhBK0ld/PI7pFnl5Cm6w8hpLDM/+54J5FSCzsnZfoS3GExvh0Tml7WI6UpH/Zi/K/XwMiUtK3+1wgFXKU3/1dU+i3uly4HyrD6HXt2E/buIXLAEXSKJ+xcX5/UyZ44sBpOpwYKclNSIG9wdeBdqyC7cekXznC8MWxq0zzumWUR
 fjMvUpm+
 zvBrF9qlcn91L1EU5BfsL8NyXa4vfKS1VNVszCHCzjLtVWTlVXLcdXuV6f8ShhUxkOb16UYpdjCjK4AIeYMpO0ZQHFxrYTZsOjWCggcx2Oku4PBvPB5jQvMGeJOFeTKN4wIPojXf/2QdANvZSskARNhTM8U4+YNBkX6vAhxaNdTsf3Ys9jYWOrTEFnTQ+0xv+Sc0PNcY1Io+7oRErGPe3f2xEjYdHsFy+9JKiMwIOPsbE9HOjxS50dombXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 sound/core/compress_offload.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 23d62fede06e..94bc226f8db9 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -1065,7 +1065,8 @@ static u64 snd_compr_seqno_next(struct snd_compr_stream *stream)
 static int snd_compr_task_new(struct snd_compr_stream *stream, struct snd_compr_task *utask)
 {
 	struct snd_compr_task_runtime *task;
-	int retval, fd_i, fd_o;
+	int retval;
+	const struct fd_slot *fd_i, *fd_o;
 
 	if (stream->runtime->total_tasks >= stream->runtime->fragments)
 		return -EBUSY;
@@ -1080,29 +1081,26 @@ static int snd_compr_task_new(struct snd_compr_stream *stream, struct snd_compr_
 	if (retval < 0)
 		goto cleanup;
 	/* similar functionality as in dma_buf_fd(), but ensure that both
-	   file descriptors are allocated before fd_install() */
+	   file descriptors are reserved before either is staged */
 	if (!task->input || !task->input->file || !task->output || !task->output->file) {
 		retval = -EINVAL;
 		goto free_driver_task;
 	}
-	fd_i = get_unused_fd_flags(O_WRONLY|O_CLOEXEC);
-	if (fd_i < 0) {
-		retval = fd_i;
+	fd_i = fd_prepare(O_WRONLY|O_CLOEXEC);
+	if (IS_ERR(fd_i)) {
+		retval = PTR_ERR(fd_i);
 		goto free_driver_task;
 	}
-	fd_o = get_unused_fd_flags(O_RDONLY|O_CLOEXEC);
-	if (fd_o < 0) {
-		retval = fd_o;
-		put_unused_fd(fd_i);
+	fd_o = fd_prepare(O_RDONLY|O_CLOEXEC);
+	if (IS_ERR(fd_o)) {
+		retval = PTR_ERR(fd_o);
 		goto free_driver_task;
 	}
 	/* keep dmabuf reference until freed with task free ioctl */
 	get_dma_buf(task->input);
 	get_dma_buf(task->output);
-	fd_install(fd_i, task->input->file);
-	fd_install(fd_o, task->output->file);
-	utask->input_fd = fd_i;
-	utask->output_fd = fd_o;
+	utask->input_fd = fd_stage(fd_i, task->input->file);
+	utask->output_fd = fd_stage(fd_o, task->output->file);
 	list_add_tail(&task->list, &stream->runtime->tasks);
 	stream->runtime->total_tasks++;
 	return 0;

-- 
2.53.0


