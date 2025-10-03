Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E409CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4738E0015; Fri,  3 Oct 2025 09:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76988E0005; Fri,  3 Oct 2025 09:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D368E0015; Fri,  3 Oct 2025 09:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE3E8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:42:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7143511ADCA
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:46 +0000 (UTC)
X-FDA: 83956918332.26.D3F5CB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id A470B1C0016
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MfjVUL2I;
	spf=pass (imf20.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759498964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmpBbbQW7gYoUE1b9DMpRmZa+uEChxSmPgNPLMFsiBU=;
	b=oJ5bJ/VyVt+52o4BuMdxF4n9NuCiLnE5guk4prgRWYp0IBmUoCgHMMh1udd4eKGtFXU8OQ
	QvYelB8Khn8lz1af2gzW17x9IUI2UcPnA0ioxktagtlJqt2uNQuLueTw4gIsg40AnRgc7j
	Wrr3x1bIX/RekJAtJpPlsRZKvgGrUNk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759498964; a=rsa-sha256;
	cv=none;
	b=NJuS/90ft2eCs/sVDChrHT61pCiJIEeK/00EME1BuTarFrRLuugfbA/8+0LU81h3/Rof7+
	q/PdZUKWAR1Ka4HamEJ8q2LWTG//2BiYquFVdGk9W17ytszJEb3MeiE9XZjkw1xoF6UDm5
	I/us1hoFDDeJisz72TrViBfo5rVtWJw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MfjVUL2I;
	spf=pass (imf20.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmpBbbQW7gYoUE1b9DMpRmZa+uEChxSmPgNPLMFsiBU=;
	b=MfjVUL2ITZQAcPYRU00RmOWT5C5531NWDgjn5WN1EcbAN5kQitQjJ4ERAjij0mnURpmci9
	9lFZjNWZHVN5ITLw2KY1ctePXZaJDDnBelRHpMLnkGK9eCNmdhKudfHDnnurO9iq1D4ukF
	xx3lQGCoDWe6Kag4+X+nOY/4G1Pvt/4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-s8d0fRbjOT-z7dteDH8T5A-1; Fri,
 03 Oct 2025 09:42:40 -0400
X-MC-Unique: s8d0fRbjOT-z7dteDH8T5A-1
X-Mimecast-MFC-AGG-ID: s8d0fRbjOT-z7dteDH8T5A_1759498959
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B32B19560B2;
	Fri,  3 Oct 2025 13:42:39 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 09D6E19560B1;
	Fri,  3 Oct 2025 13:42:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 4/7] xfs: always trim mapping to requested range for zero range
Date: Fri,  3 Oct 2025 09:46:38 -0400
Message-ID: <20251003134642.604736-5-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 1u1kccm91zwrmwcemiz9zyzys8czzddm
X-Rspamd-Queue-Id: A470B1C0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759498964-425578
X-HE-Meta: U2FsdGVkX1+7p5Xv5siactYmjQ8JwDFktzJoNokizcaEPzcyV0gxXT5ilKN+ctTZRWYDsxMcW2qJ/g2ZMbO25TNPVvKiZEnF3DGfoj1HqgsNHn723wPjyiYr9V3KAeVUmStBzouJiMG1RRIAV3M016uCs+iU5sD4TTbYrTVUHdhYHM8njmGbU+eOP2uudYcCaY3b+mfneeoIPbMuAQ7T3Km9iTvnsn0JlfwhYB84XBO5wlwWSlISDJyyTYM2g1aM/TYWeP+ANfL4i36t15BK6nYTJN7rL9mp3IrpkPG0LBwKeoqXWr/sJAH2koLyi7IhWapJaEzKfYBCozX9qvGDsCm5hwYJb6QwJ27u/t0fi0aLfBnxLeRbRqFmKLFlZaLBHOkg58rzB6Nms6fbeQaUsKmo0w6c9Fd2Ydks9U9tdF7PdmgOyXaiuTIWaXErNXQ60VaHXH8kSzg81fy/pCuh6uHtKGcdj6wuydGZ5oz7CN7KZI8Nu6ng3vbgKdB31m2z9Y2mBxPXhiCcJUnVIUCRw74M51RqG+PZwIKjcefdfInsJI7kpj8274FdqEi/JgaK+nWZOr+Uj0oP5IQQX+xACNmYb+t7tRP1X/3UeOYLgSLoWY/z7j790VyjhCvu7CWfQlrVeaZYwopHF2R8J5Nd4onhXowDgTTBzKmdQsdVkXOTaoQoLQVzGZGmTeMpGlRMAi0+yRuCpW2kPHf3quSawXd0meMg9hpqFQNx5ZgGHInylkGE9QUvfq2mV+vkPDBewDCS191oWiCROzGs3SNWTaz/Z63sQBKXYObqxJ7rijm/e+noyk58FalPtpgTn1FFPmggJn/PFGU8kW2E70jwsTzKmzdgQRh5DAEEdeD2sEEkdGOEtEeo8DDYEu5QFvJzneIzvNRa31lx2miWobAQ5CAJClwCviq3TKu0WoaLSykERfAf380OffKriVxj/eqC/9Q3ABCqgkbsaoWb3Jx
 giVHEGtr
 Zij9/pAKODjqcm0+Qja8U9BmYpvIjbWhSfTnIp/XQs1pXuAnm9gHFj/n4e7DvRgo7gPs14yhqvmVCn0TWYfBXMKem2+9peDHirFgF03Pzlrfzic/UZh6PZihIdBhp4x+je98ZqxKTPoIcPt1ydFJfKx8TabSocdeZyOSuGHUv47I+e7YNJfPnVzYpWXC43Qxtz2RnDWdzc/1nQMbryGrXt1lC12GDiv+38hPS9NLv0iqNswn1XFXg1slMQSwuQVip6t0ci7p//Pyiw+T43WLUuq30tscBeV1AakODj6c3m1EUlHgB7n9Z5PVholWhwqlHkaNJ22JA2BbNCRE0gMLo+vrUcP7J4yQazGI7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor and tweak the IOMAP_ZERO logic in preparation to support
filling the folio batch for unwritten mappings. Drop the superfluous
imap offset check since the hole case has already been filtered out.
Split the the delalloc case handling into a sub-branch, and always
trim the imap to the requested offset/count so it can be more easily
used to bound the range to lookup in pagecache.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d3f6e3e42a11..6a05e04ad5ba 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1767,21 +1767,20 @@ xfs_buffered_write_iomap_begin(
 	}
 
 	/*
-	 * For zeroing, trim a delalloc extent that extends beyond the EOF
-	 * block.  If it starts beyond the EOF block, convert it to an
+	 * For zeroing, trim extents that extend beyond the EOF block. If a
+	 * delalloc extent starts beyond the EOF block, convert it to an
 	 * unwritten extent.
 	 */
-	if ((flags & IOMAP_ZERO) && imap.br_startoff <= offset_fsb &&
-	    isnullstartblock(imap.br_startblock)) {
+	if (flags & IOMAP_ZERO) {
 		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
 
-		if (offset_fsb >= eof_fsb)
+		if (isnullstartblock(imap.br_startblock) &&
+		    offset_fsb >= eof_fsb)
 			goto convert_delay;
-		if (end_fsb > eof_fsb) {
+		if (offset_fsb < eof_fsb && end_fsb > eof_fsb)
 			end_fsb = eof_fsb;
-			xfs_trim_extent(&imap, offset_fsb,
-					end_fsb - offset_fsb);
-		}
+
+		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 	}
 
 	/*
-- 
2.51.0


