Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D50C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460F78E000A; Thu,  7 Aug 2025 10:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3048E0009; Thu,  7 Aug 2025 10:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1588E000A; Thu,  7 Aug 2025 10:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1936A8E0009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:43:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D19FD116D53
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:40 +0000 (UTC)
X-FDA: 83750230200.08.9ECBB85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0E6B218000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=diZ1qHuY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGsnHH/7ANS+cU/5LhZY4MqydsQWx1VmAjvofEAotZs=;
	b=Y7YBGXfuc9ktfZCPmI4qxLfxuBo10vPz6dFeqnFfe5tp7j0Pu2Lb6RCKnxlneQIEBHmr7p
	MxdpRfENSxVD7gDESu21OG/9rUi5TxKjqeRF4nTLsT7ytEtppR4opaX9i0hwT381n7Sgzs
	ralEOQJTpFp/MefKLvesLM+G3Uawz8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577819; a=rsa-sha256;
	cv=none;
	b=wQXoaClzHkI7DiVxKqUpOZ68Py6OEwCYdoprRdsj2lssqnNtAYPrwHvXRuO4qietvaOALx
	GNFiDrW5aiYqsaPk6iS0/UzKG96uxBFvJXAL3VwuLH1C20vVAkJYOII2E2sDuIeB22OVIb
	LUr3sH2nWW2jtajEXx+24rekFErR1z4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=diZ1qHuY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGsnHH/7ANS+cU/5LhZY4MqydsQWx1VmAjvofEAotZs=;
	b=diZ1qHuYnDu111xaCRDnTvGl+MlQi1tCKfJEJNu4V3xWDtINGDlV9M712+NEq0hyT8UWJv
	OgQ3Gbw7iaO2SQ1tWxND9KlO0xg9pPmmOOUWbTKt9lcPrad0heYNTJclq9BkH2l9YIY385
	i6ZOAH/hJuc5i7asagfj8g2FJyAj5Ds=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326-haI_EDJfMNeBWdrXrIQdtQ-1; Thu,
 07 Aug 2025 10:43:35 -0400
X-MC-Unique: haI_EDJfMNeBWdrXrIQdtQ-1
X-Mimecast-MFC-AGG-ID: haI_EDJfMNeBWdrXrIQdtQ_1754577814
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB0851956050;
	Thu,  7 Aug 2025 14:43:33 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB582180035C;
	Thu,  7 Aug 2025 14:43:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 7/7] xfs: error tag to force zeroing on debug kernels
Date: Thu,  7 Aug 2025 10:47:10 -0400
Message-ID: <20250807144711.564137-8-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 0E6B218000D
X-Stat-Signature: abbadhma1mcpi5qxwjuh45c3jem31ddx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754577818-959582
X-HE-Meta: U2FsdGVkX1+ozJ6eRuZXEmBd6YeQ1Dj66CZquMSLcp+RrNyliu47iX2/GXBRK00iOjA6V28GJJJxwyIXG+jKWRBB1gA2KK19wMreuwBUt99f5KvT4DIyeW3CJT25ypueMH5WtWFMxDVyEz9c7lqsuMYXCIPrTn3/S+Y6IRKNZqecsTQ0tN+H/GLsMnn9VTKuiNUiLZWi5GYwk+rkR/MN9LlX7S4N1nZxVU5vR6nNeVqKCbavhf1+ZKhfC/SJPDXVJaOSmH5Y+7aLxcj8vfTAyt6fxSr7U0MOGzwecZ28S5UA/oPoxEzJcXyb/6GtJoyX+FDgDHZw6eUFpm+ktwFHVL2fw+yWJt6BVCtyNA6gAVNK8iRfFM+YDWkNGZadWP3wXStmI0SIrtIBJW4MD7JZisVeBwDGJl+QiqUs3KBcm6HUvBYiLBj6RxhmTQPa53+tI7s1yogqOnIwgwmIKC6ApdZQwCIA9zBYtrOxsjHD4uCN1VX73y0JnyBJydk8GtB1tWCyerlqfLurmIeQyq/CHGrXZpOSwNukaZSzVi0ZSwzo9Y7bmYH+lQdLBHvB1MQjkhQfHtmBiJP0kEVS4uDAkRrbDTcbcnfyC0Xu55UMSAz7INZUy+FADnCNs7G/xdRlmSizIqActERtaOTBdMGRvu6hvOVQfovUytGeUz7baphjK1LraJoSn/SwFZvsYvgbWuYdbncJKOLzue8hBxFAW/ulxI3aG59r4qtTkY3FRxVypYE8f3KLwUNe1Pm8omAKkKPrZDkHULvyH70SCHD6Fn74uHpvY6eNAtKSOcpfu1fP8JU1O5n9ZzFW+CRvcSLV1af/UskCKWBZ4FvPJRM8jZRUq9R6Vbzb4DPJ377j1jPNgpL9JwyDkD7OR7DRcDFexwN+f8m9u1vyYuAYR282URjwlDBZ/XqHJbt9KgLVCYqp2eCp6sWzawF99fn32PNaiwSPGAYavRtARPJUSLn
 bWGXE4hS
 dw2E+rdxtiAxy6HsR6LBT6hIKGUlv11sKx8TPzkNrPqSAl+Ag2BZbL70ota/iQrcaGw8kW9DqIjsy79Zs3k9OcD9GiZYQWoIUrswoNKlKtiESxy72eMzqhvkKb83qJPE1RdxIJBZA8t1PXX/jlrTOculquKYFr5kdBg482MgKH0Qk63lcvPLNztEcbN1vC/8jpL5CFNt3QlwAFtPysey1q7HsA1EU/NJ7ZV9Ox8XrTaK+UsBlkIW/W728BH6fYSMJURwQwDaNlJpuf+KbIRReQC4SMWrGV4m5NsCKV2GL44PjXj6uCWZxiAuV8JFytbYI9Az4MhxqdcDvhLCh6Zo9vIqsL3Y5dik0r2Y9
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
 fs/xfs/libxfs/xfs_errortag.h |  4 +++-
 fs/xfs/xfs_error.c           |  3 +++
 fs/xfs/xfs_file.c            | 26 ++++++++++++++++++++------
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a53c5d40e084..33ca3fc2ca88 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -65,7 +65,8 @@
 #define XFS_ERRTAG_WRITE_DELAY_MS			43
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
-#define XFS_ERRTAG_MAX					46
+#define XFS_ERRTAG_FORCE_ZERO_RANGE			46
+#define XFS_ERRTAG_MAX					47
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -115,5 +116,6 @@
 #define XFS_RANDOM_WRITE_DELAY_MS			3000
 #define XFS_RANDOM_EXCHMAPS_FINISH_ONE			1
 #define XFS_RANDOM_METAFILE_RESV_CRITICAL		4
+#define XFS_RANDOM_FORCE_ZERO_RANGE			4
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index dbd87e137694..00c0c391c329 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -64,6 +64,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_WRITE_DELAY_MS,
 	XFS_RANDOM_EXCHMAPS_FINISH_ONE,
 	XFS_RANDOM_METAFILE_RESV_CRITICAL,
+	XFS_RANDOM_FORCE_ZERO_RANGE,
 };
 
 struct xfs_errortag_attr {
@@ -183,6 +184,7 @@ XFS_ERRORTAG_ATTR_RW(wb_delay_ms,	XFS_ERRTAG_WB_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(write_delay_ms,	XFS_ERRTAG_WRITE_DELAY_MS);
 XFS_ERRORTAG_ATTR_RW(exchmaps_finish_one, XFS_ERRTAG_EXCHMAPS_FINISH_ONE);
 XFS_ERRORTAG_ATTR_RW(metafile_resv_crit, XFS_ERRTAG_METAFILE_RESV_CRITICAL);
+XFS_ERRORTAG_ATTR_RW(force_zero_range, XFS_ERRTAG_FORCE_ZERO_RANGE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -230,6 +232,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(write_delay_ms),
 	XFS_ERRORTAG_ATTR_LIST(exchmaps_finish_one),
 	XFS_ERRORTAG_ATTR_LIST(metafile_resv_crit),
+	XFS_ERRORTAG_ATTR_LIST(force_zero_range),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 55a304cb3aef..7d1dda56ebdf 100644
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
@@ -1271,13 +1273,25 @@ xfs_falloc_zero_range(
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
+	if (XFS_TEST_ERROR(false, XFS_I(inode)->i_mount,
+			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
+		error = xfs_zero_range(XFS_I(inode), offset, len, ac, NULL);
+	} else {
+		error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
+		if (error)
+			return error;
 
-	len = round_up(offset + len, blksize) - round_down(offset, blksize);
-	offset = round_down(offset, blksize);
-	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+		len = round_up(offset + len, blksize) -
+			round_down(offset, blksize);
+		offset = round_down(offset, blksize);
+		error = xfs_alloc_file_space(XFS_I(inode), offset, len);
+	}
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
-- 
2.50.1


