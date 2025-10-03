Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F665CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A544F8E001D; Fri,  3 Oct 2025 09:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDC88E001C; Fri,  3 Oct 2025 09:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC118E001D; Fri,  3 Oct 2025 09:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75C848E001C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:42:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3335C87E82
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:48 +0000 (UTC)
X-FDA: 83956918416.19.440573D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 646E380019
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="By8sAts/";
	spf=pass (imf30.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759498966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDrKAA2ZD/x3/1/bEfyvAedG8tOXZaxk1l6cH5OtHxo=;
	b=YJyMxoriu94zi90pc/EwtTuRl3MHzAr4uwDaqfeJw8VIhI/T3NEmP+Jt53Thv5VjRHEVdS
	iqYQpEUIzQzH+nyohBzvcharH3kmBvpFq8Ia5UunIoyxla6CFPz1ItSlK2wjXAiQ30H77f
	GFeeA14usLdBBJNwNh+vvAKMEAmazxU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="By8sAts/";
	spf=pass (imf30.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759498966; a=rsa-sha256;
	cv=none;
	b=xKKHba8XnWmmUSONC/vtdS2L83bJH091p7H1xQCMd5A4Ga9R8lbpPJjK50tHJaYZpIefyn
	6jrQNxmUQKQryeBZU+cXZrnyUG1GjvLus6CrbZGcxF7kMj2dAE1p/DIbGB7tnAr622kZDY
	a7GBAbdkfEIRNt4EY8RtUfM/WLVJqQc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zDrKAA2ZD/x3/1/bEfyvAedG8tOXZaxk1l6cH5OtHxo=;
	b=By8sAts/jzQ/PbNxcAHBZGxfZO6WWBpb5o6IUjrb0XhMlz4pqR9usdKS9TXb4iYjsxPR02
	wc/ubAeJYiYz24suAnhx1/BJupwxrUYSx9w/xfW90xTsbycaVYAYCVE9Z14bvH4wPMZ3/3
	Z1yeWOrl3MHy7GXZ5RVlKKx+/CSGyFo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-vaP1Z3sdN3-svEXP8nVo4g-1; Fri,
 03 Oct 2025 09:42:42 -0400
X-MC-Unique: vaP1Z3sdN3-svEXP8nVo4g-1
X-Mimecast-MFC-AGG-ID: vaP1Z3sdN3-svEXP8nVo4g_1759498961
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C2EC1956053;
	Fri,  3 Oct 2025 13:42:41 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C116419560B1;
	Fri,  3 Oct 2025 13:42:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 5/7] xfs: fill dirty folios on zero range of unwritten mappings
Date: Fri,  3 Oct 2025 09:46:39 -0400
Message-ID: <20251003134642.604736-6-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: jpst3gso31cg86qekk9j8kjpsj8t36d7
X-Rspam-User: 
X-Rspamd-Queue-Id: 646E380019
X-Rspamd-Server: rspam04
X-HE-Tag: 1759498966-146141
X-HE-Meta: U2FsdGVkX18b016IyqbR7jzkrXnZdOaLr8LFSKkQ2awmsG0Td0FlwQi/5H9QPZFgItFmWjxqrruFcrgzPGFV2HmuRbBkUkoHZXUomHMHMsn59RkRscg/kItwaBlMx2W/nB/lHedSy8gMQTdJ3S/piOzf4yZr8gIfDuXfi3uaHezyAthrODmLcu6ERQH/ra0Q9cdrkMQgy7L8zOrHRdTKPJmDLhKAeLXiYl8TLjrrKniOeRi0H0fbgFxbY4zbCUCIxD11G32yXi4W8c5qvKwfjPq7SSTn3OeRKHYF2NlbPa6Bc17YSs85nHgKLz3AkQ2WT8JufCbvE99lz5/jWjCTAyf0yFF8YsTNZVZ7Ws9pIMz26BGXmRN3fg03UgRsR4jFnS31H5bKMstyvWI5vSt+fb+bbfrBEmbvIbhFGco/0/kM7I0HYSe0+1VDCG+2rrd4oC+e5/i+e+MVZAiPOwU7/kGefnkbICnKYGo8JjoDzO8uN6jIYsrDmsOC5VLgqx93ciQMHmTM6y0MHuN6ExOB/kJY55mEfZDdkcLGzRCYSebeJjNoE9xzzqVYeSWjZWOhxIAsh7PRrhqhyRf3rfwN75A6dEtG19s2U1xPZE/ernF666YmGFKdM13zas5jT6ncakCAbMs4B0IWU8Bmh734og3HNCD9nT/5KUAwaKwC4zc5xKo3I8uvtpv6EsFmnhlnjsRcWHFN0ayja9YmX0FRiDbuVlpJxjOTdSNl1qVMqKL8rwxqOyt0OofieGYISaLSXVmycJm2E0fRW2pjT/v4ApEvjCf6FodeOyqUaHBfa7/m2sJlcf5uU42aqeIYBDkjO5gSbr8a7yyaLrAJuVs7YDkUeISavwSRAtK8pbHxPkpgJMgtLOeVfo7d6KStXZdIUdkc1HJFBW/i/X54MBdMnwiAKk/bg4aDT4Gd2WzJMCqtjTC4uzYFGtcBaKp8QdCC58wKD2LgkBwRQD0kPK1
 0qHrWPgy
 +/gJi19bQipRk48V7jpf8vAmgF1urhPtNMdCDsOySgGJZ7oR1eRQCdvvi6f5ONDoUfgEq+URCRxQwICq5gTQVNvq8NcLrF6pTqI8sww2GTu/vT4HvnKtHiDqgLLgfESxLalxsrge9ABrEDUO4g+YMVrNFyGybchtAvlG81Ku+4lXNE+O6Mx4z9hySWJvu+BBE/7QS6GNK2XysokogUArXAzN6xYJud/cyS3E8Bl+Ws8ZF3j6OjcipOhAGgwnWGfL03FiHRyidGRsGD27a4c+hBnkMF42bwni/zi2HPQxBdN56enSlebvb5ERU3k3moK2wYHoq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the iomap folio batch mechanism to select folios to zero on zero
range of unwritten mappings. Trim the resulting mapping if the batch
is filled (unlikely for current use cases) to distinguish between a
range to skip and one that requires another iteration due to a full
batch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6a05e04ad5ba..535bf3b8705d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1702,6 +1702,8 @@ xfs_buffered_write_iomap_begin(
 	struct iomap		*iomap,
 	struct iomap		*srcmap)
 {
+	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
+						     iomap);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -1773,6 +1775,7 @@ xfs_buffered_write_iomap_begin(
 	 */
 	if (flags & IOMAP_ZERO) {
 		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
+		u64 end;
 
 		if (isnullstartblock(imap.br_startblock) &&
 		    offset_fsb >= eof_fsb)
@@ -1780,6 +1783,26 @@ xfs_buffered_write_iomap_begin(
 		if (offset_fsb < eof_fsb && end_fsb > eof_fsb)
 			end_fsb = eof_fsb;
 
+		/*
+		 * Look up dirty folios for unwritten mappings within EOF.
+		 * Providing this bypasses the flush iomap uses to trigger
+		 * extent conversion when unwritten mappings have dirty
+		 * pagecache in need of zeroing.
+		 *
+		 * Trim the mapping to the end pos of the lookup, which in turn
+		 * was trimmed to the end of the batch if it became full before
+		 * the end of the mapping.
+		 */
+		if (imap.br_state == XFS_EXT_UNWRITTEN &&
+		    offset_fsb < eof_fsb) {
+			loff_t len = min(count,
+					 XFS_FSB_TO_B(mp, imap.br_blockcount));
+
+			end = iomap_fill_dirty_folios(iter, offset, len);
+			end_fsb = min_t(xfs_fileoff_t, end_fsb,
+					XFS_B_TO_FSB(mp, end));
+		}
+
 		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 	}
 
-- 
2.51.0


