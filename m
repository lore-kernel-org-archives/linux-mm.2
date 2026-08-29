Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43FC5C61DC4
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 04:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954366B0098; Sat, 29 Aug 2026 00:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B146B0099; Sat, 29 Aug 2026 00:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869536B009B; Sat, 29 Aug 2026 00:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9C56B0098
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:41:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 693CDA060D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:41:14 +0000 (UTC)
X-FDA: 85153057668.24.E9BB111
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id 22142160006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:41:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="LZMX4/ra";
	spf=pass (imf08.hostedemail.com: domain of kris.pan@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kris.pan@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787978472;
	b=HnAYe9ilefGIfjhHqzPcbZ8QnFE7kWl2qvmEELR6BfBpNv6vhOO0Q2PHN4jlpBZczu8oIc
	x9D7yV0HLenoeRBnBkQ0u6hQONTW4aaTSdYP3aLFooGpwLgBETS1UFgs8/aoawtz8P3Hfd
	Pm7EXVrdNbReyraZpj3y9jrBCRd4Hbk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="LZMX4/ra";
	spf=pass (imf08.hostedemail.com: domain of kris.pan@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=kris.pan@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787978472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSDDsqMcFQ9tV4f7lYA1keyCPIc/hLgMx2f3S9zO6NM=;
	b=Xj/FOfMb39zk3iqO1BjyF0Q8tUafxx/DW9VDEofw29wAoNF+8ZB6Sm5Q4KOVSxGrcc42GY
	X1wtu9f6Y3TuG++njkiq1iOInEXu6LKuuDsQ6Z2rK/3cN7ggdT2hszyvsDA1OCMzdAD440
	btZXh4zSrq0ONjQoMCsi3jd9Yr/3J+Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787978471; x=1819514471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2JGqXWCbZ5rvViDhEt7kOXZr99HBUzTG6/6Uyla+htg=;
  b=LZMX4/ra7zlIiDTXvUL8EDBB1AIVNmrYjSB4zuupJf1N0cHTv4ueokJ9
   ENKAi10cuNhhgFy1MxxKLQlnx1dry03gQDjrPXwpw3v0OTTufcdAdIUv5
   NsMmbAFo9erEw0sJFBgD7o14YGPMDUBlbDlyrzbG4Rcseq6iW8xAtDs4Z
   WmmIcusmvF9pOvGDorNv9jkQHmm9rn5wy9mKVbyq47eTXTDRprqMbSndX
   eUn31+eUirC4/pRfhmrmWlzf+nGj92z8z+IoOz6RcDMA6fYQmDUk7g3+N
   sq+U6HlKiEF5LJahCfKVaaRtguswYCJOxPRPfwjyvyvO7mZpG7+k/2Tb1
   g==;
X-CSE-ConnectionGUID: c3i1XWInQSauSe2OUghqFw==
X-CSE-MsgGUID: E8Kp85lGSr6B0YK0R1KcAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="88683938"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="88683938"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 21:41:11 -0700
X-CSE-ConnectionGUID: PVdNb1TbTG6lMhgtjoogew==
X-CSE-MsgGUID: MsJFC2WfSh6fGBC2zTN5zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="266533038"
Received: from pankris-x299-ud4-pro.bj.intel.com ([10.238.152.122])
  by orviesa006.jf.intel.com with ESMTP; 28 Aug 2026 21:41:08 -0700
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
Subject: [PATCH v2 2/2] drivers/char/mem: splice the zero page for /dev/zero and /dev/full
Date: Sat, 29 Aug 2026 12:37:46 +0800
Message-ID: <20260829043746.2929210-3-kris.pan@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260829043746.2929210-1-kris.pan@intel.com>
References: <20260829043746.2929210-1-kris.pan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22142160006
X-Stat-Signature: by1rgzrb64fz8rtzsudj5sqkok3cywec
X-HE-Tag: 1787978470-571723
X-HE-Meta: U2FsdGVkX18KLYyXnJzoBIIaXK1z5/k4e3zvIOztM2cugLDNlywJ/uwzTayqMQX3Wc8Lxt84wcnQz5SiYhnS6VWg4UUdc9aWwp0ByQ8ytPh1JoeHzvyPxUM1xUBK2gn3Qtnr1u/n62ii2xq9Qo5rPMsZcuC41tA5/yOb4GTTV/1ZQf7POeUuG9sGVYUuee3ozYuYN4+RMGrOu3gTXVpWt2niE+vfVDtgvKLyo3zYKYpTphIJ8Oo8OzbEWkl+xIqByY9sKVxkNwVcrdt8riWjndHMxz5Gese4xdkLScATjX0I7L+kKVBkr6tjOf7+h/HhnILUlmSx13YzfkCuQ98Qcr4GnmXTRhSEJlqEOpINN0YUmGNsguB+7PcYxxJIRJ5wSbxpHiwfUf3sD5tU3dso2F4uEB8VYw/HN4gtBxAK1XeXQNArCP17VTbEXd9BVpaaV3O1sJLNW2wdCSApjg84MnIjaW0EUxBYJopPpAH376aErweOMvJT03X8MqFV8juTjCVk6dD7QtBkM8jdb38rLlNsEi5Cjm/giP0Md0NhKpBeD4KSsodHHN5x0v4JUc4NXRWTTen820IYzx7J0uTgGmeIijxla7zedYjYWrTid3RonNyqc6pg4+Z73dB3UpYVnSaLNQZt7Nl7IgXpERPUmp1wzhW+U8AWICYUAjaD8uexxJkTGaNmmj5+EUXOEc+6YyttdOAvVZZ5mQEt/B7+SOuuM8YqBMn5ESs1BvteWRX+DzdQ/bCukJAWkQTFzq9kgF0EvsyZFPRytDPMmscUH6dbR8BgrxPAy8C49fns1+FQnqvJ0NiqdZpTIVshaJ9VsIqrrRATbtEdaK2qc+XY7ZmS3aFfERn1NEYN04xD52HyHGKcVSjSaYwwBkcCxgp0a3HLNqJs7D7NV8oKOPkJkOr3OfqaZngmQZ4oW1i4khOR4uVXJ9I9WtyiPPdlYgO5lO2YgXjjkXsYu8k9k/e
 OMB6EytS
 FU8DlrmyYC5e/URAuhUWW2BDyaQj0lWiKKdY4yq9kL8spBsOostFQD0aZUNY+ULSJyUEzOdtNPoe5HAjiR7Rmy2PeaEhIaT3o4XsJrkLv/0ETs/QtCWhEe7QozSAWDm3jXmAvIRVDkxbGJzK6qrj+coKt0o8u+65zX16Z7PjForMEYAJaWTghQgmdGICN60bcl9zb0JmvMsCyCci8PEsGCUog1zcoRRioTFSgIAZ6vHTogcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a splice_read handler for /dev/zero and /dev/full that pushes
references to the global zero page into the pipe, instead of allocating
and zeroing a fresh page for every pipe buffer.

This is much faster than copy_splice_read() for splicing zeroes, since it
avoids the page allocation and zeroing on every pipe buffer.

Use the shared splice_zeropage_into_pipe() helper from fs/splice.c.

Signed-off-by: Kris Pan <kris.pan@intel.com>
Reviewed-by: Max Kellermann <max.kellermann@ionos.com>
---
 drivers/char/mem.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 63253d1de5d70..6d3ef359b2d7b 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -471,6 +471,31 @@ static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
 	return written;
 }
 
+static ssize_t splice_read_zero(struct file *in, loff_t *ppos,
+				struct pipe_inode_info *pipe, size_t len,
+				unsigned int flags)
+{
+	size_t total = 0;
+	loff_t pos = 0;
+	size_t used, npages;
+
+	used = pipe_buf_usage(pipe);
+	if (used >= pipe->max_usage)
+		return -EAGAIN;
+	npages = pipe->max_usage - used;
+	len = min_t(size_t, len, npages * PAGE_SIZE);
+
+	while (len) {
+		size_t n = splice_zeropage_into_pipe(pipe, pos, len);
+
+		pos += n;
+		total += n;
+		len -= n;
+	}
+
+	return total;
+}
+
 static ssize_t read_zero(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -669,7 +694,7 @@ static const struct file_operations zero_fops = {
 	.read_iter	= read_iter_zero,
 	.read		= read_zero,
 	.write_iter	= write_iter_zero,
-	.splice_read	= copy_splice_read,
+	.splice_read	= splice_read_zero,
 	.splice_write	= splice_write_zero,
 	.mmap_prepare	= mmap_zero_prepare,
 	.get_unmapped_area = get_unmapped_area_zero,
@@ -682,7 +707,7 @@ static const struct file_operations full_fops = {
 	.llseek		= full_lseek,
 	.read_iter	= read_iter_zero,
 	.write		= write_full,
-	.splice_read	= copy_splice_read,
+	.splice_read	= splice_read_zero,
 };
 
 static const struct memdev {
-- 
2.43.0


