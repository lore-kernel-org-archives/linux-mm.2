Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08180C61DC4
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 04:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C883A6B0096; Sat, 29 Aug 2026 00:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A186B0098; Sat, 29 Aug 2026 00:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8BF66B0099; Sat, 29 Aug 2026 00:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 759306B0096
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:41:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 130D91C20F3
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:41:11 +0000 (UTC)
X-FDA: 85153057542.02.A4C4B1B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf22.hostedemail.com (Postfix) with ESMTP id 988BFC0005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:41:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=netz25qL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of kris.pan@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kris.pan@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787978469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUbSIVPmc1rSs3fkk2FhYbLJadxPtnH4oBc3dFr23A8=;
	b=z8VTh5EQaGjipW9c7fKQPwvlAJBiLV0kxn7SKZ4EVynX2eHeNPxJusiw/h7CroNOf6lu7v
	K2p/mrD5pzyPeK+6ZiX2sRYUUesQhzwL6iEUfpDBgSttllMHWnRVZ/WiKS8ROPJ6g4aukA
	bpJgLmupWo2RZ3PTib4/ltn7AKjM5Lo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=netz25qL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of kris.pan@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kris.pan@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787978469;
	b=slL+ScCX1Z+wlmLIraxEzYEdzwHj59c2ue68KtjLVuXDv3uG1KoTkHaSgqwQOq9NlbPKba
	94Vgff7jtSOHIn/DB6AbVO/anuNSY2xtftCQIOEIuwd5N4CMuOQq/4ail1dDrhmf4qItj0
	3bCQMkz4EudMBoVgguQdi5msXHkOk0M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787978469; x=1819514469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2II95OXJXOkKiEoXYBuOZjT5qcX4TdXv1W0z3wcoh3Y=;
  b=netz25qLQMso1cdssawL2FPzi42pKmXHnOO9mMV/KuaYKQIawOdpv0Gi
   /Yy4D8aehte1sQUuqe2JfOeGV3v3x2C4/fXbvOfT5e8HALht1uD9zDWoo
   hhhpJOwHIHqwXTyr7Dm9JFz2dhfHMSBgDcCEWPmS6j3H/5dOp34smSTCl
   uY9Cwk1aVyT6hmF9SAnb81HMNYM8gOpLO45PMBuccyh1Zk+7XkOz2C1wW
   If2h0tuQsVbz0N9mlISIvhXteZJ+mX8XNZ3CIpxX///mAVAPaDk+aRXEY
   zXxhOZihbLY10v4zkHCzUMEtOqQh4sd0x68mFdvgT26d3Jt63WFQg4IOs
   g==;
X-CSE-ConnectionGUID: uuaUTfO+RfyqcbIGk1OU/w==
X-CSE-MsgGUID: PZznNfqnTEygg1/78eioaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="88683920"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="88683920"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 21:41:08 -0700
X-CSE-ConnectionGUID: cQD99vGjTMO70sDaQBOW0g==
X-CSE-MsgGUID: 46PDy14TRb23Kckm0tcnRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="266533030"
Received: from pankris-x299-ud4-pro.bj.intel.com ([10.238.152.122])
  by orviesa006.jf.intel.com with ESMTP; 28 Aug 2026 21:41:05 -0700
From: Kris Pan <kris.pan@intel.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	hughd@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	arnd@arndb.de,
	max.kellermann@ionos.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kris Pan <kris.pan@intel.com>
Subject: [PATCH v2 1/2] fs: move splice_zeropage_into_pipe() and zero_pipe_buf_ops to fs/splice.c
Date: Sat, 29 Aug 2026 12:37:45 +0800
Message-ID: <20260829043746.2929210-2-kris.pan@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260829043746.2929210-1-kris.pan@intel.com>
References: <20260829043746.2929210-1-kris.pan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 988BFC0005
X-Stat-Signature: ufkt5be851f17dmo8gogkyjdd74pcbg8
X-Rspam-User: 
X-HE-Tag: 1787978468-225625
X-HE-Meta: U2FsdGVkX19YeCgb4H0o8PmzXLJyF29ghLCjLBG+Y7UzG77xwmiwjpDATt/QQW6G213qYovLNYL3LunLGoeaCXye3XW9H+dEsOXNW3l1ebzWaIllyPjQttZw4OBZndWcMVGUz91tWfTLEALCt9ylfAuahjVDYOG9QOj5zSkft/i05eloShCuYBdMClLF6J6Cw/7MCrDVC2xEYlHzjXFaEM11yY4HgjHXO+9NwPOI3EY1p1LFUsXQPT2oagxp+l459/opiXUGyCxjshgt+HAZKtww7PivpRcvgDHU7nKCuBHQPfYieo6/FVfz5nFiYk4A+pRh+W3dKpkxWjTcBlmnEAiwojAO9F2abFc13f7wPjj8yqS3xkK4rT5UtROrYvTEVrm5Iv3yw0Symv9sloBHlXxbQuOgdA86jGgqVjIkrJF5nfYbdEEbD0sSGhW+JlB9sKZN/blBacmAABBABRQV9KNZzvargFXZBIuov9qN6vkrkPG5rs2n22kRfH5f1kMg8ITwC7Zx6irvawSKM9zjjScNDp2qGVXtjCg2CoohFai8Ek8EW2P8tCPUj4JPOscMNPZmoWuA4hPXcPsJwsEQvR6mNOuQlH4ZEyv5VcsVEn4EhpElPmVdNM4htSKozi1ynAIa+9bnZXZVpV/4YlD0QdTZM78tc/qWdX/+vmn8EWuQx4OdbUYgeMi1FFlNiNLUv0fXMEwaetiemiqeyB5FuuF0dBXXKuDfZxUJX4kVZ2JmmuAzYudk9cDONmDm5cT+GTMzsrOY73SnggXxJWfXXvqme2d0dionWYySIHN6PMCjUw/VZazdKr+dz/q4wRxDDINV4iIX1AJJuOtXkQU3uo/+v2okgt9BA9890pJ73m3eqlErIgm86xL09sHkX2Vcumj5OV1U7Z/FAwfr6eIK4v1y+pnkmtWZ2GzYdqsgA7T4Ws0ZbLQ8ljmlz+B9CCSxLEoAQ9W83SdluImk72u
 5KcqIJ/f
 8do/pgauP08zT+SjoFAcbBbIJtch5pg817mI1xO4MtKHtcxp+g7tdsT34uXwCPzmKwlHgij0/i4etZBja49rhJuxTSuW9WsHo8uHsmhj+/z0i9cu8Boqtj4FT0qyhlW/F/ruLUD2NMITX1WtA/s1r1yOTH6uooSYw8gipOwx+SLREmXXGKDEoxX2luv3wI0uunnbyetzyrrSAEr4c+8tFjGixDCBnvVXGyPHa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zero-page splice logic in mm/shmem.c (zero_pipe_buf_ops and
splice_zeropage_into_pipe()) is generally useful for any file that wants
to splice zero pages into a pipe, such as /dev/zero and /dev/full.

Move them to fs/splice.c next to the other pipe buffer operations and
declare them in include/linux/splice.h so they can be shared by other
callers without duplicating the boilerplate.

No functional change.

Signed-off-by: Kris Pan <kris.pan@intel.com>
---
 fs/splice.c            | 62 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/splice.h |  3 ++
 mm/shmem.c             | 45 ------------------------------
 3 files changed, 65 insertions(+), 45 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1ab..b6ea98cc62fd5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -398,6 +398,68 @@ ssize_t copy_splice_read(struct file *in, loff_t *ppos,
 }
 EXPORT_SYMBOL(copy_splice_read);
 
+/*
+ * Pipe buffer operations for splicing zero pages into a pipe, used to
+ * optimize reads from sparse holes in files and from zero devices such as
+ * /dev/zero and /dev/full.
+ */
+static bool zero_pipe_buf_get(struct pipe_inode_info *pipe,
+			      struct pipe_buffer *buf)
+{
+	return true;
+}
+
+static void zero_pipe_buf_release(struct pipe_inode_info *pipe,
+				  struct pipe_buffer *buf)
+{
+}
+
+static bool zero_pipe_buf_try_steal(struct pipe_inode_info *pipe,
+				    struct pipe_buffer *buf)
+{
+	return false;
+}
+
+const struct pipe_buf_operations zero_pipe_buf_ops = {
+	.release	= zero_pipe_buf_release,
+	.try_steal	= zero_pipe_buf_try_steal,
+	.get		= zero_pipe_buf_get,
+};
+
+/**
+ * splice_zeropage_into_pipe - splice a zero page into a pipe
+ * @pipe: pipe to splice into
+ * @fpos: file position
+ * @size: number of bytes to splice
+ *
+ * Splice at most one page of zeroes into the pipe.  The zero page is not
+ * refcounted, so @zero_pipe_buf_ops must be used to avoid taking a
+ * reference on it.
+ *
+ * Return: the number of bytes spliced.
+ */
+size_t splice_zeropage_into_pipe(struct pipe_inode_info *pipe,
+				 loff_t fpos, size_t size)
+{
+	size_t offset = fpos & ~PAGE_MASK;
+
+	size = min_t(size_t, size, PAGE_SIZE - offset);
+
+	if (!pipe_is_full(pipe)) {
+		struct pipe_buffer *buf = pipe_head_buf(pipe);
+
+		*buf = (struct pipe_buffer) {
+			.ops	= &zero_pipe_buf_ops,
+			.page	= ZERO_PAGE(0),
+			.offset	= offset,
+			.len	= size,
+		};
+		pipe->head++;
+	}
+
+	return size;
+}
+
 const struct pipe_buf_operations default_pipe_buf_ops = {
 	.release	= generic_pipe_buf_release,
 	.try_steal	= generic_pipe_buf_try_steal,
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 9dec4861d09f6..f1d4aefa4ec2c 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -108,4 +108,7 @@ extern void splice_shrink_spd(struct splice_pipe_desc *);
 
 extern const struct pipe_buf_operations page_cache_pipe_buf_ops;
 extern const struct pipe_buf_operations default_pipe_buf_ops;
+extern const struct pipe_buf_operations zero_pipe_buf_ops;
+size_t splice_zeropage_into_pipe(struct pipe_inode_info *pipe, loff_t fpos,
+				 size_t size);
 #endif
diff --git a/mm/shmem.c b/mm/shmem.c
index 9001aaf3b7b94..39d8dfefbe9f5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3427,51 +3427,6 @@ static ssize_t shmem_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return ret;
 }
 
-static bool zero_pipe_buf_get(struct pipe_inode_info *pipe,
-			      struct pipe_buffer *buf)
-{
-	return true;
-}
-
-static void zero_pipe_buf_release(struct pipe_inode_info *pipe,
-				  struct pipe_buffer *buf)
-{
-}
-
-static bool zero_pipe_buf_try_steal(struct pipe_inode_info *pipe,
-				    struct pipe_buffer *buf)
-{
-	return false;
-}
-
-static const struct pipe_buf_operations zero_pipe_buf_ops = {
-	.release	= zero_pipe_buf_release,
-	.try_steal	= zero_pipe_buf_try_steal,
-	.get		= zero_pipe_buf_get,
-};
-
-static size_t splice_zeropage_into_pipe(struct pipe_inode_info *pipe,
-					loff_t fpos, size_t size)
-{
-	size_t offset = fpos & ~PAGE_MASK;
-
-	size = min_t(size_t, size, PAGE_SIZE - offset);
-
-	if (!pipe_is_full(pipe)) {
-		struct pipe_buffer *buf = pipe_head_buf(pipe);
-
-		*buf = (struct pipe_buffer) {
-			.ops	= &zero_pipe_buf_ops,
-			.page	= ZERO_PAGE(0),
-			.offset	= offset,
-			.len	= size,
-		};
-		pipe->head++;
-	}
-
-	return size;
-}
-
 static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 				      struct pipe_inode_info *pipe,
 				      size_t len, unsigned int flags)
-- 
2.43.0


