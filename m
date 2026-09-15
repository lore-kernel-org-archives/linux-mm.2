Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB45FC982CD
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63B86B00D2; Tue, 15 Sep 2026 07:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C0D6B00D3; Tue, 15 Sep 2026 07:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AE96B00D4; Tue, 15 Sep 2026 07:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB756B00D2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:37:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 326821403DE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:20 +0000 (UTC)
X-FDA: 85215795840.14.CA74E79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5F6C6180002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6dDn4u7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472238;
	b=oz2jO4YnzX2l0i/cJHvkiOw5JXOohJ+XL9Nzf1xCvxiH/UeluALW2Zi9CBE1k/DAzDBNYQ
	2mdbejB62EdPK5Eaf0UYcFm0akqRnpOXRTy1iUlH6FDOysi5vV+Mss8vWTUZwSf7XO9jkP
	BBBRdpgOna+G0z1M6KEZG7inq7PhuD4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6dDn4u7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqXm1gwNkPuV8t/s5aBHvxXoZQi1gmoyMrWOmcTh+e0=;
	b=SzUV/lWWmayI3cRMXpo5ipjc/rFAidgB/GVL/94PuBc0h86TkWyrXw9StERfMKh0zyNVyL
	Lzcnih4/bjB9jXONUwWxExrDPD6rvgZID+73C3PcaebfEDc5IxlRqIm6cCZUR6iFMthnTY
	N4KdbtZNQvz6S2ziRFUGklHdGgIdCAo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABFD44184D;
	Tue, 15 Sep 2026 11:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A48B1F0089B;
	Tue, 15 Sep 2026 11:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472237;
	bh=BqXm1gwNkPuV8t/s5aBHvxXoZQi1gmoyMrWOmcTh+e0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a6dDn4u7UHWeS4oTPwJxZY/4MEQxfhe+w1dKAeLobwNA3kw8GA3R9jRM2UR2mitay
	 53rP31LX9IqiX4KyqJPeG5/A7Wk+vS/URJ+UIVi9s1V2CPS0HR+hZ4KD6LOwLi84oS
	 QHwPtObpcQ5V14Eq0QEfaz7SuQthG9rIDnYNoZNXfjPTl3loRHMdpOz24R20W3G90W
	 UlZUihfBsJUGHcwdaoYH/9Wk5PPbgvkC3G4N/+PjxTb+vMzH1dM6mnf2s5E522jH4C
	 ipwBTphCPJfK0gAPAR1mBJJ0lQjIBDvfQG7LHcMtNeNhxBkuWpXGTndvfVHeezP+yl
	 SKtsU9/kk2SGQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:32 +0200
Subject: [PATCH RFC POC 46/50] xen/gntdev-dmabuf: stop putting the
 descriptor back on failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-46-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1632; i=brauner@kernel.org;
 h=from:subject:message-id; bh=njDuxDGw0hmgU8wKPypyXyk5GfJpiYpSpC9eP8wkYpU=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGqpLH/I6D6Uv1WDf9ilssavQSoU/hfbYczV5DbAAkrVEcQbC
 Yh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmqpLH8ACgkQkcYbwGV43KLDpAD/YSHF
 Q2prY93oobCwIjSF/SfO7Zal68tdHzxKNHmWJJEA/R/JD6+ZeSXqBuxwWtOWojlugYUiab/9tAe
 INmLXFesK
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5F6C6180002
X-Stat-Signature: n7ooyszfj1b3mqcayf39kqwon7zntpuh
X-HE-Tag: 1789472238-407478
X-HE-Meta: U2FsdGVkX18ou7kjlPNPu2JQUBCqjTToR93lrnJpU4TFHURbDz3ArZVFjv5cUxqOpcxWpY1kM58DkWk6e/LySMhi5BwKJcva7aLl335d0/gjWq5vaCxDXxfwJlVunBlykzBVYToANtnssQj1Rvysv/00AvKhVRegfWLU20FeNc9SRyE86bnVBeJ+6AEWzdcF53AL8n/zZ3DnxO+2ZMzN805npx8Pm5YMV3GiBcxQd+EiZF00rMXerSxotEgoLPQEDflxEmmBFsZQrml15U/vpgDbU0bwC9W9s+v/DnRqcdfi1ymEvevEyEiufTdjIXvOOKbFMHgzoeAxTFKlCYP3cf3VDinBcmzWJFZ55lKMW1b3tLwTGOpvwG76ADrekX7cGZr1x4pJe+5OGvyZT4mIsI3ctmgGPX7A+NtshIhPqvD95NzlX8xOHaIJ2ByYxV/jKOt6APcHb+fGbdO3kLxZVJVd3lTvePkGAYN6CEKV85frWIYB4DZkgrmJvwb6O8H+tXAMsb7dR3TYhO0zQV7YYOscA4WkELhd56yj9WrvH5p80Bf/MpL4RtQuNjB9/Qb0b3Fv/rOSShf6kiBiuUaO6oNxeZ3LXA8DnMJ5lUwiNJ08T1JEb+pA4UHLCUqIeLEv0DcU79J+fiGl/izwPax4jpfnaonbEJgOgkChfvuvym5FQfSb5DYlEnMzruN/LV3na9NmqDjnQh7uH/9lXIzb28L62PF/FV094WG67mXaxABRuVQyhV5aeRJmjabc3FM6yUHImdSsCov1tV8Mr486Iz5O6/jfmIZbuzbWJXLyjMfGLCU8DzwpdupiHmXw8ELysUyWduqVcvYTveSLUjbK8IsdqWZLtLabN9KEgGmLjAHew6JsYepuiagVzuBYOkVil2/ASX5JF1nKUv19g4FQbsT4uPA/L4/Y9Hy2cogI9JJ5IvAMFDjd2BDeHB0+yB+f2UniFwZ1FJq5xZGP5H9
 mK9DmF3n
 CWLWTmmhbgcDRtaRd7g7sPpJP7ATKNL1vzxpFNi+aFicxRnboF5RShwjfpR2UQznhlmJ+3S8VpQFykIS67zkVUNqTr1jzcJrJP5AzdAjvw6qY5GtXk/atlm02N5sBsnecKE2stGe7DupgLVL5hmpHPFT5zO8IUgekhNQuvLe4xrDyygZxOdhXsqiKSG3fP3rZTwHM+Q/8RUcWmpSjRRZ4V+uwNbjQ7NA+0NqAegq846c9jOaPV5YuLOPA3WNChkD1Pvyo/1Bc5s0RhAdcmQPqErHwrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 83b0df460894..a3ecc7c83974 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -357,10 +357,10 @@ static int dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct gntdev_dmabuf *gntdev_dmabuf __free(kfree) = NULL;
-	CLASS(get_unused_fd, ret)(O_CLOEXEC);
+	const struct fd_slot *fd = fd_prepare(O_CLOEXEC);
 
-	if (ret < 0)
-		return ret;
+	if (IS_ERR(fd))
+		return PTR_ERR(fd);
 
 	gntdev_dmabuf = kzalloc_obj(*gntdev_dmabuf);
 	if (!gntdev_dmabuf)
@@ -388,17 +388,17 @@ static int dmabuf_exp_from_pages(struct gntdev_dmabuf_export_args *args)
 	if (IS_ERR(gntdev_dmabuf->dmabuf))
 		return PTR_ERR(gntdev_dmabuf->dmabuf);
 
-	gntdev_dmabuf->fd = ret;
-	args->fd = ret;
+	gntdev_dmabuf->fd = fd_prepare_fd(fd);
+	args->fd = fd_prepare_fd(fd);
 
-	pr_debug("Exporting DMA buffer with fd %d\n", ret);
+	pr_debug("Exporting DMA buffer with fd %d\n", fd_prepare_fd(fd));
 
 	get_file(gntdev_dmabuf->priv->filp);
 	mutex_lock(&args->dmabuf_priv->lock);
 	list_add(&gntdev_dmabuf->next, &args->dmabuf_priv->exp_list);
 	mutex_unlock(&args->dmabuf_priv->lock);
 
-	fd_install(take_fd(ret), no_free_ptr(gntdev_dmabuf)->dmabuf->file);
+	fd_stage(fd, no_free_ptr(gntdev_dmabuf)->dmabuf->file);
 	return 0;
 }
 

-- 
2.53.0


