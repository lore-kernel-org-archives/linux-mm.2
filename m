Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE220C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B3B6B00BB; Tue, 30 Jun 2026 06:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB1C6B00BD; Tue, 30 Jun 2026 06:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABF26B00BE; Tue, 30 Jun 2026 06:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 840286B00BB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:54:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09E9640469
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:31 +0000 (UTC)
X-FDA: 84936270342.22.BF3BAE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4A8DE1A0006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJE2rCy7;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816869;
	b=nADECx6oQ/JySJuvBtnahO2qbFfNQs5vnRfQYU7pMg3uNRWOw51yz8n/LW+taxzDSjHGZT
	vlrMFBhj4wj/5mWN7rKwXT7qzGnHG2/VVQ5+GLt6HthRvAA3yiFcK4F9p4s1WRsOgQ8w7H
	tnL0qajumv5Tj9EqJ3P4ZYVPQ7PX7iw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=305VH6OUix40v7/Cr6ljvxi18Oyq/nvdnChwFnVwVXk=;
	b=t+T+snf0h1cuxWdQ+Zwt/CrqhAp5/eAJgKWTuijAPYswvhFYM7kqIHNkXcWPuT66mD8w4C
	QseBStaG8C/Vs2o12HZLVc42ZTfNj7UwCB0yuj2cU2LvbAd9qYs/lbtLAjoyvZLu0TNJA5
	JicCQ5mYn8Ygb7f3Kaau4Tfs2yqv2/w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJE2rCy7;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F44443CCE;
	Tue, 30 Jun 2026 10:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BB21F000E9;
	Tue, 30 Jun 2026 10:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816868;
	bh=305VH6OUix40v7/Cr6ljvxi18Oyq/nvdnChwFnVwVXk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RJE2rCy7Arqo6bbDH+p8izGeNvi9sDYWDv3cAyD5NIV2YpMNtN63lEN+vEGc2Nw87
	 yi59zz6dEg25JB7hHQsk3lzyiblRdvvgKrwW/b6iekZzAN7iQ96q459V59kHvDgUhy
	 9J+YJ1bPTvRzZvdMlNscfSc+kP8CM1037BvOuhifT7phPEJtVJ4xRCOtjMT0Sq/ydP
	 22nv23K4tfPr4FUFhV14ETFspsKhAvt3gIPHn4s95pA9VIwJBacdP2l90xcmdJ3je4
	 1EtrHZo9bUd3kV9VHGWHSIqF8aznRprqA1Gnl6b+oqiD1hXHcEHI8FNV2Zxi/qL8ba
	 d843Q/TXn1+3Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:54:19 +0300
Subject: [PATCH 2/4] scsi: proc: use kmalloc() in proc writers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
In-Reply-To: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: ibup5fz3o5d16awhsxp4mrkoqygi3uwq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A8DE1A0006
X-HE-Tag: 1782816869-194591
X-HE-Meta: U2FsdGVkX19E60bd1/JUW+3Z2CW/6vqHIalRng3k/SEQR2p4QUnbu9t83nMXlzB22t2JFqL2q7wyC3y7WQa8FWzWu/GXla2te3JZmOTGXm//OSwZmWGUTgYfw6QaXJicBXs5B0QLKMTpVo9kvjL93C43zDIeRN6hbc46TtC2grBlQvzK3RJ10Nsgbthm2a6BMRChIffYXXqid7B01JBarlRgMAGL8pwpTA+ENyOGjxh1nXWQoC1jzrNa4tHsSgbxCF8NlOBx5pEToKeVHXY05ja/bkkUBPrq0C2i1BqSUTWiZZqKc5I+jPiEWiwpMBHqqbRy86sPTmUd+8YxIhINkiFSDItBoeKudhX2woggh2dXcaHTLJMSa82tUFPuEA/tF+GrFLf9qM3MpCxIu2eNrHNBqlb5V7aJ3niS4KAwWBcWs0f3jl3Vei11+q+RjR6XbzjNqSt0XmbPbPyEjamIw/LyxbG8ybXo7rBXKijTJhwj6mMkrV8AJMU0jcHcGNPpN1CfyKYDgkEoNGNH5dHJFuXoBg0hMttmKorhVcEA6YcwRlsyDK8ESc0chOgqSCQNl71ZF0JAHSZfWV2ozdjmUiX92QWpmx4Ot8XJ1N+s3jHiEb0yU1umrrzud0bg+m44/rdhJTHYzIOjuq+gnduGruR6oNaSvwgLwU+P7y7w/jqoMyhMB5ASfJTgr7q0eN0lEfkfEGdQ8wqHwhOZyJGAhIDRRi79/F6j9CWmAmFNGELPIxL7uErqWhC6yyLAmTSFo3eQbJDyjh8S1H14ofyU1I3rjuM5AIGoHhHY8Plm+aNuIR8TKwTYVnWkh+1GfpuDQPXeAER6KZRNsVQAr06JaAZMmGa9z0E/gjb0o4XeNgEAWNbV30qgYmUFPyYrHVwL0x1Brp6ESYty2/2n1Exd0kgEWF9hLtg3d8BjMkaRMlyWTP6pghwmBNSkKOzH56i2Z+rkCRbVoWliomoB+1B
 e8nB8jmG
 18SsyDHBRiMySvn+Hu+ytGmGuk5e3BEX4+c09GiHLbQ427Yety6lIlHEdij+YWMVpM+F3VRVUPBqTtoI1rOQ50Srk9owhq/YtS1Jh0rUWBA6U5HrD+0wvCdY8mkesXWkjvrJkx09/+LBMS6DC4AGwAHBG1XRGlAQrrfZhNb5egXpZDJfyGPLHqcTp6nqhzTTwTRCY2IBnO5XE8B4fG558wJ7ixYvcUomOL4e+n9zLrzQw/A81QWbTavz983Sf1LFbbmbSB2FikIPqZYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc_scsi_host_write(), proc_scsi_write() and proc_scsi_devinfo_write()
allocate temporary buffers for /proc writes using __get_free_page().

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 4 ++--
 drivers/scsi/scsi_proc.c    | 9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 15ffbe93ac72..6dd342fe9a69 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -691,7 +691,7 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 
 	if (!buf || length>PAGE_SIZE)
 		return -EINVAL;
-	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
+	if (!(buffer = kmalloc(PAGE_SIZE, GFP_KERNEL)))
 		return -ENOMEM;
 	if (copy_from_user(buffer, buf, length)) {
 		err =-EFAULT;
@@ -708,7 +708,7 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 	scsi_dev_info_list_add_str(buffer);
 
 out:
-	free_page((unsigned long)buffer);
+	kfree(buffer);
 	return err;
 }
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 1799dcae775c..fdc355d783da 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -74,7 +75,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 	if (!shost->hostt->write_info)
 		return -EINVAL;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (page) {
 		ret = -EFAULT;
 		if (copy_from_user(page, buf, count))
@@ -82,7 +83,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 		ret = shost->hostt->write_info(shost, page, count);
 	}
 out:
-	free_page((unsigned long)page);
+	kfree(page);
 	return ret;
 }
 
@@ -412,7 +413,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	if (!buf || length > PAGE_SIZE)
 		return -EINVAL;
 
-	buffer = (char *)__get_free_page(GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -467,7 +468,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 		err = length;
 
  out:
-	free_page((unsigned long)buffer);
+	kfree(buffer);
 	return err;
 }
 

-- 
2.53.0


