Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F6FC982C7
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11AA6B00D5; Tue, 15 Sep 2026 07:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEAD76B00D6; Tue, 15 Sep 2026 07:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D013B6B00D7; Tue, 15 Sep 2026 07:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A83B66B00D5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:37:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED3CF1603A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:35 +0000 (UTC)
X-FDA: 85215796470.06.60A1B16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EA7080008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqnWgCCB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472254;
	b=yilcIhoC0xWo8c7EBqq/Gv2QkE1xhV+/ia3t+dMzwD/ZT5ogEcuwiuR64/o/FAxK2NLpaa
	+BgXCZXlrnyI3Rd5qmZC6nTv7nkZ/4QDgC2KRokqo31IhVSuDVZYNjfvM1ghnM+laxty6L
	MXfxpO08oaa2LkiWSL/t3IBJqI0G4nI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqnWgCCB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43PF/RCUOZQkJsOOgjTj3NZfqo5RZrpEBnO0+rNiFJE=;
	b=OWW/yTXLQAOowjRYT/wKJiQb/sUUc0heQ9kfQU60stzSzhpF8vgLnWHR2+gMEm6FB1PV8G
	ByggIMOlV7JbWUUUGLx/gsdMkMM8Dfwazv1eSrEi9OX5Zv9L5vvcF+MN/znemelijMyYk6
	jmm+t2WXZ57mgV63TS015pRyxEQaGzQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DCDA43410;
	Tue, 15 Sep 2026 11:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022161F000FF;
	Tue, 15 Sep 2026 11:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472253;
	bh=43PF/RCUOZQkJsOOgjTj3NZfqo5RZrpEBnO0+rNiFJE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KqnWgCCBBHbflkUyPO4GlX+NqrkQFoLbpdeV95+70PxGxWdRlCZK2hEFg7AKpGM8d
	 P+sDlo6n6p/oD4DHtw5k4ao1CCny987weMHVwVi57TIzGmedW26EG1RySUo7EUC3wL
	 govHdLEbUVf9mmDt8elYfT7Db4xTVjDVamv4EuP8wsrMfCbgWeOAVYswLv5gav0BOT
	 MlginGpeWoN48Ny0LTtfFlqXOFFO5u4nlES7nGcrAPFHjrQQttsk0uwSQM7UkTulFT
	 MHFUk3iByhyEoh4VP3/GmREzjD3XQ75V+DK8eWFkJXVQmcZAGfPHvBT+mosXjqMwpA
	 YKgxCV7My/uOw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:34 +0200
Subject: [PATCH RFC POC 48/50] misc: fastrpc: install the dma-buf
 descriptor when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-48-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1831; i=brauner@kernel.org;
 h=from:subject:message-id; bh=cqNOp0aS6I05gELpjlHXd0owI5nLbJqswEU8UWMTx0A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KkPYaw+MXnFd73DKesXPFlfMXNFNsPLRZf+RF2XY
 bp6P+0Kb0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBETGQYGSZ8vdT+NFe0bk0l
 +55pTDcfSvjMedPirtK/tvj3rIZKzuUM/8x33i1095DRM+a7Hu9qcGFp07anFQ2bOM4tOR05Zb0
 HOzMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3EA7080008
X-Stat-Signature: 551toqmftncbribnpwjj7rnotjom58jr
X-HE-Tag: 1789472254-742295
X-HE-Meta: U2FsdGVkX1+B9wan8ll1s304oJUHysI0R20nsk1hPxDMPYhVx4n06BEHwPV+hhjn/jtz3MK1TxqX9qDjw3+FXeR7sQMitaAaHwq/PtUmeB/woNSZND3po6cMtUcVNEvnYWHjbmQeGT8xLadGqGpqYl08YzXLumMPdeQ0zyf8TId+Xu6OmGezGvfDH/hwjc6OHIP7aCq9T2cRGQJ/eIx0mKn8/VXGx8uHas9uaViFIDtJBrs2mt1qp2j5iUL+W8oTKOf4XN3C6I9AfmisPK78ai2UCYosYw8F+pmp7wXpFGeUDhtLmYm2HyObzubJ5DohWVGVayo22DAcTYnCPs2dW8pDJxBuLKpH1pJBP8O8oImtBZT8ZTSNLozA3DazT1LcJntP9b2JtbDkKNtsaRdNw5u0hBmu7Kf61Anj5vypDjnMlHntaACZ2OxQ2N/2Yphzx+6vjdIRadOOIWnRJdxOTXEnvPx/0KssFtquIUuHlnZfK5lwWjGBcyI2FBY9kxpbMFh3NDbEuJXANnI83rlI6NvEvry/kn/gLUk+4Yy134Sxgcu95LeQFZn94TaLomhEFL/thUQ/oFnKZy0iLuZpbYL7bEFyDTVbvh2N08ZqoCB3TX5hOCb0YxyRvSSBrBE2SvgAUVZ7D+phEPnyexN6rb5ETvUPJ5H2eeXkLGvecEN29ongprjGSAxGjvOBeEL4BjKq+hI8YpU4eIShONDWEXDhDxrIgBwJjva53V9xjLRx1LOM4EbjWI+YETKW3TjrINWpenzK3tymI151doXTH4h2QBdYetMzvBS9uKigEwReiVs5l3m1JwMVHJ6DtAni6ToGm+iBarOgLyW0X3q0atKur+IpimfAQBzMFoJ6SNy1XNAd3D7XsK759Z9N4oEhFCW0tSosgFgJqvXOUliUwT0eo/j6C3Kxf2T2M5s5iYxSoMREhvCJLZcLxp+I3Oz77WoORvRWVV0rQ+pUmjo
 uix3f9Hq
 OJk/sr6MiRQgy8aF39nujdY17lOVqu1uPbZuNVUGFP/U3JIPfAsH8E3lMD66Nqg4FBIBeImFhze57NziRaRhTjasJyJC7o01Vu/fsgh9tcdYQBXKDAkcgSe2pcHG+5+dXzOq3KtlGkRvrZT07ORA1Sg6WovD/y8WhYNfqtONX0iAkUN6hD6fUCxfuXZseWzJZGnPdzAuh8x59MYFtLvb3Ci7XkcQqoNJ8/GPetYD1FI9YnIRV0JWAlkWiZSfoPinkeTF7146iScgC35pueYu0ZViBVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/misc/fastrpc.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 90fd669636ec..24b84019bbd7 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -7,6 +7,7 @@
 #include <linux/dma-buf.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-resv.h>
+#include <linux/file.h>
 #include <linux/idr.h>
 #include <linux/list.h>
 #include <linux/miscdevice.h>
@@ -1804,6 +1805,7 @@ static int fastrpc_dmabuf_alloc(struct fastrpc_user *fl, char __user *argp)
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct fastrpc_buf *buf = NULL;
 	int err;
+	const struct fd_slot *fd;
 
 	if (copy_from_user(&bp, argp, sizeof(bp)))
 		return -EFAULT;
@@ -1822,23 +1824,16 @@ static int fastrpc_dmabuf_alloc(struct fastrpc_user *fl, char __user *argp)
 		return err;
 	}
 
-	bp.fd = dma_buf_fd(buf->dmabuf, O_ACCMODE);
-	if (bp.fd < 0) {
+	fd = fd_prepare(O_ACCMODE);
+	if (IS_ERR(fd)) {
 		dma_buf_put(buf->dmabuf);
 		return -EINVAL;
 	}
+	bp.fd = fd_stage(fd, buf->dmabuf->file);
 
-	if (copy_to_user(argp, &bp, sizeof(bp))) {
-		/*
-		 * The usercopy failed, but we can't do much about it, as
-		 * dma_buf_fd() already called fd_install() and made the
-		 * file descriptor accessible for the current process. It
-		 * might already be closed and dmabuf no longer valid when
-		 * we reach this point. Therefore "leak" the fd and rely on
-		 * the process exit path to do any required cleanup.
-		 */
+	/* The staged file is dropped with its descriptor if this faults. */
+	if (copy_to_user(argp, &bp, sizeof(bp)))
 		return -EFAULT;
-	}
 
 	return 0;
 }

-- 
2.53.0


