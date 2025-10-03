Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1C8CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61728E001E; Fri,  3 Oct 2025 09:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38B48E001C; Fri,  3 Oct 2025 09:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C277B8E001E; Fri,  3 Oct 2025 09:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB4468E001C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:42:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CB0D1607CB
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:51 +0000 (UTC)
X-FDA: 83956918542.05.CFC79B3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8D67140006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EJEHIsjV;
	spf=pass (imf27.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759498969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waUo9x0FBaqv0KZdVCsd+QvqF9lALbkUVPK8T4Gm5+Q=;
	b=XxzniVJprxCWNRhUYSxvVrgdSXP+rbfq5U1A1M+AGcfvnBHMZWjb/H9tga3uFOfOXKxpM0
	ZTgu76X8CTnSouziW/s2qCc4Q23FTdS5ihxfmUwtbn6wKem+q0W02g8VmZR6258HWQ9A8c
	wXQfR1WvPXtkXbtQ6uhmEmpQlGt0yN4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EJEHIsjV;
	spf=pass (imf27.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759498969; a=rsa-sha256;
	cv=none;
	b=5ry8Py+Mq3UAPjEiJDnxX7zVUW2isbsqOSyaH5gNZckfsdpp5coJDH4uUN+o1rTAaUKKGJ
	zdam0k2X9Szaq70768XONnr4E95S76lCi9hxCw1xY1m80mh7ejmJIILx8gAZ13feUm+juA
	6/2p7k6qdkgtfSdonzb/stRYkFaba7I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=waUo9x0FBaqv0KZdVCsd+QvqF9lALbkUVPK8T4Gm5+Q=;
	b=EJEHIsjVrdSpXCTfDsvokvkRrJyzc3NxC3MDFOtDBCMFuNeTDFYVXqmWebJ7Tw2+uHm2UH
	2u7qYsNPSraYgaC/itWLEQRaQTvbJ3x6X+KqiMRhhAvWdpmSfTEkbi21fpUmgBKvSQKsEw
	hhXjoykv61tszGpCdX5b51hbvQZ/0e4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-531-cZw-hyGiO0ShUs6Erifr8g-1; Fri,
 03 Oct 2025 09:42:45 -0400
X-MC-Unique: cZw-hyGiO0ShUs6Erifr8g-1
X-Mimecast-MFC-AGG-ID: cZw-hyGiO0ShUs6Erifr8g_1759498964
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F1CE19560AE;
	Fri,  3 Oct 2025 13:42:44 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2B23819560B1;
	Fri,  3 Oct 2025 13:42:43 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 7/7] xfs: error tag to force zeroing on debug kernels
Date: Fri,  3 Oct 2025 09:46:41 -0400
Message-ID: <20251003134642.604736-8-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 8D67140006
X-Rspamd-Server: rspam05
X-Stat-Signature: sqbqypnshus83t3b4un9bckxc34jthmt
X-Rspam-User: 
X-HE-Tag: 1759498969-807264
X-HE-Meta: U2FsdGVkX18nRdqS+0r9OeLRu/hFdk4+5EoUWgTE3y2raqgLmZ/XvRAtLG5V7qkp88zjOb1afLq9fGMgbD/8CiKCJIrIK+Y94/jVNUwzYv6U/G1KyGTM4IDmaikdXeD2/36VEYJ2qPVzNIw6xmCvakMzpY2F87sZOzh7M7Qd8uBTEhydYRnkk7+L4I4rpvs7TjxnUd2ZKaeF6sLx1QFj9+oT4TSfvOnOSNfeSGdJzcnfVDwI9O6yvepyRWlrwUy0xjUgvULaf5gzPKIWNdbFQLl6uu3Re88Vhre1QKvUQSf34+HEpVXBkr7NcGV1RG+JWSTNwlMGJyLmozI7OH6sUnrJ51a+7vweoJHLIKM3FQ2wZtZmp+XmottcP5WlMgBqsaKla+JBqZNAUgBPOCeAEZjHgq3KtD1B1lP9LSWyd9heSkElWODcr0rFJ/gQoMUBr8w1YkEjHaMFFz6512B3EbeGcy2ZrK4VBqUyxY/U5eUB7Ht+GMv7fZpWK1TkfZ3Vmif8+nML9Pe1CzcEoWdA6pMwRpTs3XvsDsFcmKHWyrLxY2rUW/S/C91RX/aEolXdwGCf0dbNwUT40psnRmCKAw43dJqs+zd1W+6R5qxzTQAwUs4Ave5Bv5k+Wa3gNwdu5vvmz9JytranUywNNjaLE9g9evtSAklozMtvS7IiAP557VPfAmjQ55yjmU/u1BIHlLkq/xx0kARaV5VryYDslr9vcUgQ2jDKEsHbHAE7MVgQhjH+k6e5oT7UqNWxigNjLOGp+GSyMOk9A6h+5Fk2tcNMHNW4wlkNAsltb7Lj2fPBktLnTol+4M6oBV2haUwnyMCF3vraXtaz7vodi0aFnvIXsxF1pxT4xwGwKWjTx2TvK7/qlXQonjds/JcwIO1TcymqiLTbkklVSNQRA+pWdiiqKKHvDltrXQGKlV71w+7V+aFnb8Lgw2CCFw11XsBdKaVGxzGzyWAbyshluEv
 6QJoYsFg
 YFfe5GZVO8njdpQPrvuW5V7ey4ynBdPj9sxJLUo5FJ4HLBDygqfuR4Ljgk+7pc4uftegN4AzSu2z/JvW4ruLXP+patlTDdN/pxv4pmBj3mN8xH3JxOqQTtD1mOWXQbzpu340Sqfozozo9hbwQwQc6XdGeZh3C4azTOhxYzxwhrjr6e3WClFMkxdcho7qw+oyYNqZrhG0nYbvgCPSCYSGj8hkNA0K+BKcHPVftDg8AVHLCbuMITtNw6QWoasGtZ+uIEqfMQSqTzXSxktzS4H3+kjG2NMlYEJ+5ChZKhMTr2rx9K9Ou7PROJnnWHcOW/QJeiQQh0v/KFasgw2p+l46TjdwuVKoAD2z7vOG6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

iomap_zero_range() has to cover various corner cases that are
difficult to test on production kernels because it is used in fairly
limited use cases. For example, it is currently only used by XFS and
mostly only in partial block zeroing cases.

While it's possible to test most of these functional cases, we can
provide more robust test coverage by co-opting fallocate zero range
to invoke zeroing of the entire range instead of the more efficient
block punch/allocate sequence. Add an errortag to occasionally
invoke forced zeroing.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_errortag.h |  6 ++++--
 fs/xfs/xfs_file.c            | 29 ++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index de840abc0bcd..57e47077c75a 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -73,7 +73,8 @@
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
-#define XFS_ERRTAG_MAX					46
+#define XFS_ERRTAG_FORCE_ZERO_RANGE			46
+#define XFS_ERRTAG_MAX					47
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -133,7 +134,8 @@ XFS_ERRTAG(ATTR_LEAF_TO_NODE,	attr_leaf_to_node,	1) \
 XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
 XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
 XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
-XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4)
+XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
+XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4)
 #endif /* XFS_ERRTAG */
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 2702fef2c90c..5b9864c8582e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -27,6 +27,8 @@
 #include "xfs_file.h"
 #include "xfs_aops.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
@@ -1254,23 +1256,36 @@ xfs_falloc_zero_range(
 	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
 	unsigned int		blksize = i_blocksize(inode);
 	loff_t			new_size = 0;
 	int			error;
 
-	trace_xfs_zero_file_space(XFS_I(inode));
+	trace_xfs_zero_file_space(ip);
 
 	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
 	if (error)
 		return error;
 
-	error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
-	if (error)
-		return error;
+	/*
+	 * Zero range implements a full zeroing mechanism but is only used in
+	 * limited situations. It is more efficient to allocate unwritten
+	 * extents than to perform zeroing here, so use an errortag to randomly
+	 * force zeroing on DEBUG kernels for added test coverage.
+	 */
+	if (XFS_TEST_ERROR(ip->i_mount,
+			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
+		error = xfs_zero_range(ip, offset, len, ac, NULL);
+	} else {
+		error = xfs_free_file_space(ip, offset, len, ac);
+		if (error)
+			return error;
 
-	len = round_up(offset + len, blksize) - round_down(offset, blksize);
-	offset = round_down(offset, blksize);
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+		len = round_up(offset + len, blksize) -
+			round_down(offset, blksize);
+		offset = round_down(offset, blksize);
+		error = xfs_alloc_file_space(ip, offset, len);
+	}
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
-- 
2.51.0


