Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E10C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E608E0008; Thu,  7 Aug 2025 10:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B55F8E0007; Thu,  7 Aug 2025 10:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A098E0008; Thu,  7 Aug 2025 10:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D20788E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:43:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD114160F29
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:36 +0000 (UTC)
X-FDA: 83750230032.17.8B82182
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 12CD04000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mc5Tq5Mt;
	spf=pass (imf12.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577815; a=rsa-sha256;
	cv=none;
	b=0oOASqI6yT5BR8BQm7e3d3948c+2ZRWuME3C+bqnmeTf3yPCbNO2EmBdkXp2RqvCdDo28G
	raApHg2lLC17VcdoFkBGSMb2dRPsbsUGVEDM2Az5zrdNlP+ErcPPnBgmOyqf33pgXoUF45
	mPmoV/KXko3MEUw18GYk5xwt1yhe7HM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mc5Tq5Mt;
	spf=pass (imf12.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSr9N5g89fySVkYw5oAvxYqJ4DTMR7Ste4RyO4OGSWY=;
	b=6KMIAP7Q30ERTRO00LiX7ff6a5646T6BegOY1rEEDp5zjU+N+sEqKX37bcG7nWajQMARen
	DTh+a/yuj9z8luODciRct6SyVN15Cai0wtok0tQi/uT7+gBHPIwycOxND7TQlCey8xWMWk
	WIILTKSuWNspn217cy1WCv0VQbvIB9M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rSr9N5g89fySVkYw5oAvxYqJ4DTMR7Ste4RyO4OGSWY=;
	b=Mc5Tq5MtFs274vBATi+kCJMUbB8r590Q4CRAXYTIT6qCV1geikAIQKd7X1KCXE8E0mMu/D
	6BPcU3pTeBdYpw37qSPK4IBk/XPhEkSxSjHri1UVod3wv3FAGL22QLiNBi8F8qesIbgMqi
	wOtwDDvSCBXBKS0h1fF4xn+INzRBA58=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-jEaw4hmQMVetFCd1PlYCNA-1; Thu,
 07 Aug 2025 10:43:32 -0400
X-MC-Unique: jEaw4hmQMVetFCd1PlYCNA-1
X-Mimecast-MFC-AGG-ID: jEaw4hmQMVetFCd1PlYCNA_1754577811
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7F161956050;
	Thu,  7 Aug 2025 14:43:30 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8E1461800293;
	Thu,  7 Aug 2025 14:43:29 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 5/7] xfs: fill dirty folios on zero range of unwritten mappings
Date: Thu,  7 Aug 2025 10:47:08 -0400
Message-ID: <20250807144711.564137-6-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 12CD04000A
X-Stat-Signature: um9xf6nsojwrke6kc93nnysdy6rb8de6
X-HE-Tag: 1754577814-417914
X-HE-Meta: U2FsdGVkX1/L09PXrj9M4SajJpW4iQs4+ezj5tY7PhR+cU2mWft6Lw8yTaDTzuuOSFR25mjtZ7SoRq9Wm/v82BdNGDijXKx/8aemCiUd62P/l3UBLVYu0nmVYkmouOnK/FGkj7o+7JlsAxkrzJH9gkPSVvjhUDPuIzTHdR2xVUIxFz0vsM1fke6XRqvl6AValrxzOWDO0+Am13g6OO6f7Pti+atnFLYiKEAmwl+qmp7SYItNeWSTkJr39ItDRVTyFe7hlKvUuqFoKBlOVcrXlHTrxLG/CmQ8PDcYeKxqcdDDBY/QmyM2Ea4r7iK4eem5N+8+61t1+y1dzYET3XfjIaOEgB0bbtw03ynBZUxCr/3PW6WTQhPmAimM8MPaYFWWu3eKXwwV/JXPiTxaEhXWWBDQ6ozXQnsry45kzDrx+SFwpptWSfdh0DqOmnHFfw7W2lmDQMXC7B4oK9CN5e0orO/pITkmJb/PqAM+DxdGXhRy2hL8MIY+NVgK5i8wCLeK4ljhpClun7iJoCxQTsgefqXj5DhrPTV3nIp/mNnv2VsjZQURox9Haq/joOljjTygcvF9m2clsdr/TVHWB4AWd9ppW/TygNDphd4fLK/JsZ+DsIrQ/x9uQw7aoNnB8oHdeGvviKyLwZAbQdHphk8y/z1Id0aJjl+gRyBDJRUFkaKz8rSzTYpvOQmAAGHUPzQdeZGmst04UdjniRVL8BQe7sohD7J1ShibN87HkDDG2FoqDTKqduQPHuKUSun2rW0khGQn5F4TEn3hlnEiavvcj39dLcVU/xW1MiMMjb48zxE/+Rrdek7nCDAfKGrnuRE1FRRXPjyg5tIfNRVVsGWK4x/hGhuj3zCOVki4hLOxgs805X1MtQvlctvJGYM/kW5IP5lnE9DWSlzLod4qP44mvQ3JKSNpBz+UImFs+70ayhgDpwFxGjLGxSdc6k3tFv86WdAVhRjz/FV5woz41TD
 UfGmopGd
 P69BqWef1KZU2K18=
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
index 25058004de91..521fef4d04c8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1693,6 +1693,8 @@ xfs_buffered_write_iomap_begin(
 	struct iomap		*iomap,
 	struct iomap		*srcmap)
 {
+	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
+						     iomap);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -1764,6 +1766,7 @@ xfs_buffered_write_iomap_begin(
 	 */
 	if (flags & IOMAP_ZERO) {
 		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
+		u64 end;
 
 		if (isnullstartblock(imap.br_startblock) &&
 		    offset_fsb >= eof_fsb)
@@ -1771,6 +1774,26 @@ xfs_buffered_write_iomap_begin(
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
2.50.1


