Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D24606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xaHe5i6U
Received: by kanga.kvack.org (Postfix)
	id 6F8E06B05BC; Thu,  5 Nov 2026 02:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D17A6B05BD; Thu,  5 Nov 2026 02:00:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D8D6B05BE; Thu,  5 Nov 2026 02:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D59D6B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:00:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53FDA1A0990
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:00:44 +0000 (UTC)
X-FDA: 85400167608.28.5F0CC21
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4E48440003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:00:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xaHe5i6U;
	spf=pass (imf12.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793862042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xg8nXZtLp4oyb17OmIrfnuQowTn1P59jW3Dg4lobw/A=;
	b=cMXO2KS9dlslOPTQJvmS9hullffA2AMY5ABw6utXUKaqENBZbO/BqHVJMtNq5A46HqaBJb
	OIASYrzYe1XcQlZ0MwCzIo9GFK2auuvOv5hR1BynWR7kVv+iearvCMrLvWgq4gkTipNLZj
	R6IIV6GSfkFliBrB1Cq2XNVtiaVl6eI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793862042;
	b=u9Z/+g5mmO0olLVurtjPUxEo1z6Ymi0IpVv/T8jux7Jz0CsrZGdwpgx/+tcKcxUOnDOk/W
	8Rf0C0AgrM3lgBVFb7wFMqfRW+2ai7vfhh30AgjVlsx9iHac8hCumlXyzatpGkkeuWBKbp
	TY+sF4NCDIfxevTTnmjLVpzmyrF44/A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xaHe5i6U;
	spf=pass (imf12.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wHNd6ESNgC5Ksw+CY79MAj+VAYD20bCYtUJOCQAgBeE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793862041; v=1; x=1794466841;
 b=xaHe5i6UXbtxRwCasYswzhPLBQLZ5W4lIVATGkE0TIswWciARSwNJeWuf/VH93db1zyVszIB
 bxvQtWGvNvqeguGYiL9u8cuaAqJV6/3Lr5wnUs1jcK8i3hHsa3tHXbQQUyNfIfgMQ2CIo2EBgtx
 uFX34IQK/jV5r/UTICDfBhkY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7a0aea14e9d952c6;
	Thu, 05 Nov 2026 07:00:36 +0000
X-Mizu-Trace-ID: 7a0aea14e9d952c6
X-Migadu-Flow: FLOW_OUT
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	asml.silence@gmail.com,
	hch@lst.de,
	Anuj Gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Li Wang <liwang@kylinos.cn>
Subject: [RFC 6/6] ext4: support dma-buf registered buffers for direct I/O
Date: Thu,  5 Nov 2026 14:58:47 +0800
Message-ID: <20261105065847.196540-7-mengmeng.zhao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 6moam1rwpirkqxph66iwcii8qxh9nzjp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4E48440003
X-Rspam-User: 
X-HE-Tag: 1793862042-284461
X-HE-Meta: U2FsdGVkX19Qxj76TcDSgkqgpu0NiAOPjYMYvZOX6xQwfQc2EyFHHFdVC1W8OfVA21EVMDZOdMdYAIdWU7L1s3+81gVcR6MH30fPvjMKYmt16/Q9rGGPTS2TWbr1ThLS0cS9H7j7yosItvqJT6bm0KmrRTzE7FODGuvLrpIKsCvkgzkCX6d22uExoBFX8BMAw1vJTuNVD+o+yCdVX3zRSZwg8nKNJfpdJzc1S7PmfVkVZAoy2PX6yferhxb8qb2egbMpXffmBDfpyn5S0aVaHMSe/2rttZIwC3oW/IcelUNH9Pf2mO1jAlE4cCSR/etsuffaeHaoHh8cfYqSLO3maryfZFTLjJuj8Pi7+TfR2j0HWNnQI6PYCLM/y7z6m45eGNORKYmpFel0cfO+8chc/acqqi00ULtDZYeMw/wYn6rdX9yB8bfJ/3jF7Zdw4kGf546427N3GayoufsyOUEEsPmaHPwhYVlFWjc+7+mV3/b5bL+cYkZjZ5LOEwbZdK/DcWqqUn4fXrYIIsoy9yc+602jFIo/FDM2rXxH1cHMc8/0N7IUJl4nDWj+714MaUIM+he+JdxW0nHoZLjH6x8A/b5FRGJ4Mdj/M7VA3Y6YVazzPCiyD6x93IwUEnryYyELG2ztxuQBfF9/DYzB8XyzDbwmJkFR+HGbPM3ZuAWWyWy/vQI5Q4p9bQfYUPghaNTSRvG2zsudjzyYJ6fIfe8+HECuqcAGVO9foWTDh8ZFAdaYdjmIaRVO8TNA44lHgBTzMKMYTO95yk5nTuxj6pCedOdgA1N7su68505n3oCRctg7ZQSr76YABLqwYCnuhkOAvFQqOoxiVUAl6xDnyDmrrcItD2x431lVtCw07u2PnXz2fIKb5Ele+GDW0dYHocqbraCsDvK+TpTd6v1Y9kda6+Sqh6edwuG6wMyGUFHU22Pm0ImzakeahYsTNPS2OMG3i1YRpB1RIM+JCs0kXHR
 NxNs9kQH
 R+4Y6/c54FUfCZK+WX9r5k26Zmd3TULORxf5MD6JXh9F/lMkmVMLfOb6ayhLyKyJlPwgW0K2tydQtLJi9AFlabvWSiwKbbmkZw8N3n8yNOiSMxsvQM+6Q8gbZtRA7fFiu14VOVAv50PsjNzYIZN9uUAzX553IwEiuLwOrHgJ7wwlGE4is/xGgGLHJQWAISYR+8vQBflBwLa8DfFcPEq73Ay2xD+Ovd51zy997K7Pu8afElW+RTbJs4r5wDyvCZDCV/d7Qnpbs3ZgxsAJfBo5R9WxEZ27AaZIcEHu6Q2J8mcRSoiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>

Add the init_dma_buf_io_ctx fop for ext4 files.  The data of every
regular file lives on the block device of the mount, so the buffer is
registered for that device and an ext4 file cannot move to another disk
after the registration.

A device mapping can only be read or written by a direct I/O bio.
Add a fast check at ext4_file_read_iter/ext4_file_write_iter entry.
Refuse the iterator for buffered I/O in the two dispatchers; the DAX
methods are covered by dax_iomap_rw() and direct I/O by the iomap and
block layer guards.

A direct I/O write whose tail still needs the page cache reports the
bytes the block layer already submitted instead of the error, as that
part cannot be undone and the remainder can never be copied.

Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/ext4/file.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 374b4bc25bd5..46629915fa84 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -139,6 +139,12 @@ static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
+	/* a device mapping can only be read by a direct I/O bio */
+	if (iov_iter_is_dmabuf_map(to) &&
+	    (!(iocb->ki_flags & IOCB_DIRECT) ||
+	     !ext4_should_use_dio(iocb, to)))
+		return -EOPNOTSUPP;
+
 #ifdef CONFIG_FS_DAX
 	if (IS_DAX(inode))
 		return ext4_dax_read_iter(iocb, to);
@@ -670,6 +676,13 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		ssize_t err;
 		loff_t endbyte;
 
+		/*
+		 * The page cache cannot copy from a device mapping.  What
+		 * direct I/O already submitted stands on its own.
+		 */
+		if (iov_iter_is_dmabuf_map(from))
+			return ret > 0 ? ret : -EAGAIN;
+
 		/*
 		 * There is no support for atomic writes on buffered-io yet,
 		 * we should never fallback to buffered-io for DIO atomic
@@ -773,6 +786,12 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (unlikely(ret))
 		return ret;
 
+	/* a device mapping can only be written by a direct I/O bio */
+	if (iov_iter_is_dmabuf_map(from) &&
+	    (!(iocb->ki_flags & IOCB_DIRECT) ||
+	     !ext4_should_use_dio(iocb, from)))
+		return -EOPNOTSUPP;
+
 #ifdef CONFIG_FS_DAX
 	if (IS_DAX(inode))
 		return ext4_dax_write_iter(iocb, from);
@@ -1032,10 +1051,24 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	return vfs_setpos(file, offset, maxbytes);
 }
 
+/*
+ * The data of every regular file lives on the block device of the
+ * filesystem, so an ext4 file cannot move to another disk after the
+ * buffer has been registered.
+ */
+static int ext4_file_init_dma_buf_io_ctx(struct file *file,
+					 struct dma_buf_io_ctx *ctx)
+{
+	return iomap_file_init_dma_buf_io_ctx(file,
+					      file_inode(file)->i_sb->s_bdev,
+					      ctx);
+}
+
 const struct file_operations ext4_file_operations = {
 	.llseek		= ext4_llseek,
 	.read_iter	= ext4_file_read_iter,
 	.write_iter	= ext4_file_write_iter,
+	.init_dma_buf_io_ctx = ext4_file_init_dma_buf_io_ctx,
 	.iopoll		= iocb_bio_iopoll,
 	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
-- 
2.43.0


