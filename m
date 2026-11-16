Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB211606BE09
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kXBXegK7
Received: by kanga.kvack.org (Postfix)
	id 12BDE6B05D1; Mon, 16 Nov 2026 06:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104096B05D2; Mon, 16 Nov 2026 06:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F348C6B05D3; Mon, 16 Nov 2026 06:06:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D88ED6B05D1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 778631C3F1A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:23 +0000 (UTC)
X-FDA: 85440703446.08.EE10EB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0ACA21C0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:13 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827174;
	b=2krRNnujCYi5gil2y5Hvjh/J4dd/fbyiWwBVmT3IGegxgsk2VYr+N21x5e2ybJ6CHFAxx2
	aS/q36Hr/blrQWLPkof3lJ1RafAi1Qna+d+A5XmamgEKl3Wah/Q/QH4+hhbZZjxuxv8M+V
	KbaKNa9CjULA87+lsCFwAXCEYyZtDmA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9E1u11sECBJWFTmloDJmZ13PYN0Kwn0d7kmiA3OBRM=;
	b=uYRZTxRWzXyykCyV2gXE3PLxuxiVRSvkjYpOwHhAjPAYmHLrJq3Yqg2pUtD76zLF/FuGLq
	wiVOs/a1ylPh3c+AwMWicSI1/MgtKzcFEduaAbhOg3IyGtF0DmGfys5PXZasddU9plIchA
	S74BMCTT6BqDhgdyrxHrbFgO9yPJIpI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kXBXegK7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5719846263;
	Mon, 16 Nov 2026 11:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E916E1F000C5;
	Mon, 16 Nov 2026 11:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827173;
	bh=H9E1u11sECBJWFTmloDJmZ13PYN0Kwn0d7kmiA3OBRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kXBXegK7dC1dL/bZ9+nDwuLsEdWqEdkGm3v8QYa4xbauZMWbuGG7TJof+GlVspgc6
	 FrsnozDmBgYNMx5PleVEdEj2kZOxs0GZRkgg5V0hZc5AB3JrL5tiIO0h1vvhhokZG0
	 r5PLjrDcCnZ3+X5jM6ZwF5fzae5BhkGDz/vxX/H+//UMQhBi+YsjA2sgBohg411S3f
	 RN15M3gCu2W0VEVkAPsWZOa8JJoL2By17j+phnGfheP6VMWIuS9AUGqX9gr9kFKR/l
	 67+V1J8Lq73Ymyu3xj3kOn/Rf1GEfYGbirIZghea1NE/yTr0T0Dq2uoKqDapAJl18F
	 AxXY+14O7YRpA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:34 +0100
Subject: [PATCH RFC v3 01/44] loop: refuse backing files that aren't open
 for reading
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-1-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1877; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VBI+uMCHtIBDpXye3IfyuEMYz0sbcx7ROCm69jjOsKw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ehy/1dSsii0m7V7enfhfyQ9t559yePWxhStUzHL59
 E16H/9XdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkexojw+QQwXjlawZzkoPn
 qlueuOPxgnWa9MKE0D0SQYo37ztI+TH8j9bMlUzVqnrt+1BljeVHrpWttpeFOvw6ujdOmSEYuUC
 KAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-HE-Tag: 1794827173-153275
X-HE-Meta: U2FsdGVkX19VwrQBCnbQzGLUNfiG0iH+28F1xsk4Jrxo8HNdCltiudoapQz593Ax4Wfh4qAkcrDZsIzZDfg0niCeb2SQMuyBoQBPO9jYtcY2o1kXtYyzJ9ewCeDyjKZx9fWGpVvEKxTmMAYgrQMTEeog1lUKjJXvuAxHjGHnV8yJXbtvZ0+zy71VbUpkuE9EGWmfA4DcQVp1emIDEGT/g+eAv7WOlwkC0a5gOLEuahjxRUAEKpHFqTCNGdBsDXx9z+nPNyzJX9Em8JFv2pK0pIf1zCShwOrhA3hRrxtOrMIi6Q38hGFLVIktWfGhRCiXcYCNDyooHt+mGEbz6DSWwZW0UDbzraDTOy9rwrIUXG2DrVj4I4NmK60hZgkkv4OTI5JqodCgVywD0wclJLAQ/04Z57meYlvz+XIm7xzcwI4OGQ2Rlk5SAJwG0uAHl7QNYArES1SXtSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

loop_configure() takes any file as long as it implements ->read_iter().
Loop itself never checked whether the file was actually opened for
reading. Buffered I/O went through vfs_iter_read() which refuses files
without FMODE_READ. Direct I/O has called ->read_iter() of the backing
file directly ever since loop grew support for it.

Since commit f2fed441c69b ("loop: stop using vfs_iter_{read,write} for
buffered I/O") buffered I/O calls ->read_iter() directly as well. That
commit was about O_DIRECT handling and the FMODE_READ check went away
as a side effect.

So whoever can set up a loop device can read a file it was only allowed
to open for writing. Open the file O_WRONLY, configure a loop device
with it and read the contents through the loop device.

Refuse backing files that aren't open for reading. Loop always reads
from its backing file so a write-only backing file never made sense in
the first place.

Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for buffered I/O")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/block/loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a3325ceab484a..c96e35c3ef423 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -528,6 +528,9 @@ static void loop_assign_backing_file(struct loop_device *lo, struct file *file)
 
 static int loop_check_backing_file(struct file *file)
 {
+	if (!(file->f_mode & FMODE_READ))
+		return -EBADF;
+
 	if (!file->f_op->read_iter)
 		return -EINVAL;
 

-- 
2.53.0


