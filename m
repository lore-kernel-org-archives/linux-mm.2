Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B5FC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D646B00D1; Tue, 15 Sep 2026 07:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5BF6B00D2; Tue, 15 Sep 2026 07:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732D36B00D3; Tue, 15 Sep 2026 07:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 526D96B00D1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:37:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC8531A03BB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:11 +0000 (UTC)
X-FDA: 85215795462.20.9DCEB49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 370E840006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOCbPxoT;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKFkiCa0hlTe3sMnpSzoSnXToiZbVbh61g+KJO9ieuc=;
	b=W+JR1F5YxULqsJR0nzT97rY0CCbKB/xMIW5+y/o8odTM1651ZP3Lfy1IdfFTs+eEm+8mnw
	ACjA+3ic5/R6zuRw5ygV0d0zoaZLQ+1HtXu/giBLO/mMOu3ycipIAfHsZjowRXDU8TtSQJ
	12xLaGzN6ClVWq2KiwyqIiDEhTOr2VA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOCbPxoT;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472230;
	b=DVJUb283cXHb6yZZ8z+lfiA+rYg0sEZnLegV3olJ/5VefWYXzf4DJdrQGbnLals9mdYqng
	DUS8Ebx7eAmztV0twyEr6elsuFOfU+K3IGxLLG/pZMmWWYwKwf+TqII1h+rJ8WTg8+Fk64
	77qMeR+zW3kACAbQmoEDGLVjflxh6Ns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD294602C4;
	Tue, 15 Sep 2026 11:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6561F000FF;
	Tue, 15 Sep 2026 11:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472229;
	bh=xKFkiCa0hlTe3sMnpSzoSnXToiZbVbh61g+KJO9ieuc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oOCbPxoTA5tRVDE1SDW2p9tC0NlFv3Be5GpoNWhYmURnweQxEsEdX5T61GQni5xDr
	 dB8oKq6yW0o0+gkex/ln8ORrTi4m/ksGAeRyzNp36yZlNMlPyIA0cXetpfDQyX5Jlw
	 kUeKik4FTXQWhScuFLMluxrSG6c9A9ZCbrTYp9zYSiEAOHtRRYECmeCyootOfrgsFF
	 4aVzqXKYOQKlcIlDUd5HFPC99RpSLMKbQX+NeTk8Ib6ernTnIZhKKs5s66GAw9HT8a
	 aS1v8S5YrjxrTs7D5UvVddV+Ou7n/rKAkdnUoUpvZBcB6uDYitfeHcIW+Z9u4N80Fg
	 U5N4JdROMjYmQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:31 +0200
Subject: [PATCH RFC POC 45/50] accel/habanalabs: stop putting the dma-buf
 descriptor back on failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-45-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1297; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ydrjF0IvCagPMk+8W3Lo5F+Om/GvHyzFN7KTNwOeZ+c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kn/suYdZ5X5676SLT84zbaJW7EmM036Hiq6ZOOqB
 ZPZLiWKdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEfjfD/8KDx3tMQu5s8Nvq
 pTQrXEN8zcGDu7l3Sq29EHzMOo0/S5yR4VJD+//LnadWytZe1frxs+H8kb1LmHzvH1hrULDM+7H
 3NRYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 370E840006
X-Stat-Signature: myjmsmmf3dxuwr4cz6esgjf59jc7gpw3
X-Rspam-User: 
X-HE-Tag: 1789472230-140829
X-HE-Meta: U2FsdGVkX19vOa4E6sxBkesCUHxF94ldcdZnx9CGUIT1KH0MulXfP3D6V3evgjlAI4A9EitvqEeBnHUxNEoq18H/W2ZkoZxuDO78lNc+tlBx9JnWs3BO8U+aILMlfPPBbGf0Zfr68xt+AIEzypvU0tjw5tCMnLgQqNwFirziH+LNK0+hZ55zVDUn2751HrngjmLoHXv6fH3cd2dtnlnlcU8iQbvCzdwREApKT9xfV3b9fZhSf6ksEK45d3+gxYD8Bt5U6TEYCyjEMmlqG5IjbNlktcufTqGeES2HqCW/Lso3lOksHkXu64sM0b1TplG5sotgMqF57kV+iWc5U1Zz5zOINdG11hrZ1DotlhW+upuoWL3hU+n973gGC95nZYxNBI03i0kKsvwx0WotGS+6wZudXDaxSjJRzaoHdF+M1vyaiXvQiDGRn2BMWEDwqzgNvyPT340YEkl2OW4i2ecsJnniOJOXXzGs65+qAb7ZWNEjgBk/4p3vfxU2RU0qifzNt6P0CnHE1r+FnA8w4cJ5RTo7fgsOSKh57c8a4kEevOIU6mBBVBwBKjlBrdUH4SU+JLaGkqecrkL0AOJmspoJjwOJZVi5bWh33ZHAlAxO5Iz/y1jea3pAVSRaPeR1YLiTQyee57x2WSGYdDLxcv52XzYc1+4dXrrjg8oJ41rGrFxLe7V/OWLVizwK0LjB0Bs3X68azU0q5ujrXLiAjejfdUnL+UYFlGRG0gdDcoa8sGeBxwe4VeyDLpqpSUUspZlM/ulX+LOR7rz3Ay/1nWWM+DJCHj0siq1EudpCQrMVZeFUyQuLhUSYL7KznCh95c3MkOaN1EgUfXydhgp9hRYNbh08Qh8E/RuvNm0XxQllAPlKqiIqXkmTkJvlKtZucBCTcthjKdpegE1FiU1Mu/OW+MKswfet/87dl7nwLQd36Gdjul3GQJzwBWR7V6xaDxk3d1iDnhlNCBM/Y7Uugrb
 rqKerE+o
 he2zesTU1/tye2woU1AIFaV/AMogykBLu64XtB3HT+gkGN2kBIcl36f8BL2tkEvGm7gfTDDg3xaMLKWCzG8xdNrIe6vVcYKebMBcWCpESplQxpAUDGGEIav4JGSr+z5K2OjnaHcN0BxanAAZr612Zs8CFo2qnhXT3m8mhQSColEfD/rFhoR+6POBh7mEZMiMcDLTg9M+PBUysGnmIMPX6LGeADXAhcSEhXSnlfx3EC6jO1LC5T00ViIBMBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/accel/habanalabs/common/memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 361cff577381..1559442cd56f 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -1861,11 +1861,13 @@ static int export_dmabuf(struct hl_ctx *ctx,
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct hl_device *hdev = ctx->hdev;
-	CLASS(get_unused_fd, fd)(flags);
+	const struct fd_slot *fd = fd_prepare(flags);
 
-	if (fd < 0) {
-		dev_err(hdev->dev, "failed to get a file descriptor for a dma-buf, %d\n", fd);
-		return fd;
+	if (IS_ERR(fd)) {
+		int rc = PTR_ERR(fd);
+
+		dev_err(hdev->dev, "failed to get a file descriptor for a dma-buf, %d\n", rc);
+		return rc;
 	}
 
 	exp_info.ops = &habanalabs_dmabuf_ops;
@@ -1889,8 +1891,7 @@ static int export_dmabuf(struct hl_ctx *ctx,
 	 */
 	get_file(ctx->hpriv->file_priv->filp);
 
-	*dmabuf_fd = fd;
-	fd_install(take_fd(fd), hl_dmabuf->dmabuf->file);
+	*dmabuf_fd = fd_stage(fd, hl_dmabuf->dmabuf->file);
 
 	return 0;
 }

-- 
2.53.0


