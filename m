Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E42C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351788E0001; Thu,  7 Aug 2025 10:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264EF8E000A; Thu,  7 Aug 2025 10:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CBD8E0001; Thu,  7 Aug 2025 10:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD5EB8E0007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:43:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 714F45D730
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:36 +0000 (UTC)
X-FDA: 83750230032.13.4B56B02
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9CC7840010
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MZ3Nk5ja;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577814; a=rsa-sha256;
	cv=none;
	b=ty+b0lbZAIIZfG2nA4/SHXllLCbohU655L5/4NL8b4gcJQ3L2gCZjq5t9eCvxeR90HGTJB
	qHWiXlX7G8rIEuCkzuSLFfOFVGCrpH8xroedbGEUnuGgsL3WHRs7OIg0U4N6gXzukACtb9
	ibBJaGTsFzrdxSzcyzYAdlGl2clwcNI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MZ3Nk5ja;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5071NuG2BrmI3mAFOA+wKHQ0oJZoTKExAqwlt/m4okE=;
	b=gT6iTkMKn+se1h+YFYhBpYrbV4fcPzs1lmwtZmXingGAEU26qmg512z94eCzFiWpjzg79/
	Wk05ARY3d2/6PSVtyvADD5A7VjUbgc9qi6lKKv+KYv3knIVs+B55N96tnrMeAmhhhTXzVW
	hKeJZ5H2S/TXqFLghzRgmNGPgbZCcCI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5071NuG2BrmI3mAFOA+wKHQ0oJZoTKExAqwlt/m4okE=;
	b=MZ3Nk5jacwwKurIcOtc6aJYca0z3MvC9YkjmjHxUnxl+OK6x5hUCOnFhvlrd9sab51LxYo
	tF1Ok9mWSORC+xHOrd0XYB4z0DgLsNe8LZ64xZGwPeVYynujaMSvyWFf4ZQrMAWcQzPXsg
	Z845F8S+OD2G1nE+evRFzA61ut5fHXw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-Cly95HXiNuu3v78G0SRJYg-1; Thu,
 07 Aug 2025 10:43:30 -0400
X-MC-Unique: Cly95HXiNuu3v78G0SRJYg-1
X-Mimecast-MFC-AGG-ID: Cly95HXiNuu3v78G0SRJYg_1754577809
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DFC71800EF2;
	Thu,  7 Aug 2025 14:43:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6BEC61800292;
	Thu,  7 Aug 2025 14:43:27 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 4/7] xfs: always trim mapping to requested range for zero range
Date: Thu,  7 Aug 2025 10:47:07 -0400
Message-ID: <20250807144711.564137-5-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 9CC7840010
X-Stat-Signature: 4gikxrrag9x4z1qnmbudjf85fbpr1kgz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754577814-823611
X-HE-Meta: U2FsdGVkX19yv5/KqVDwdX+OEHisbx3oYtcbNPuotbcM282AJNGCML7ugxbudK+GLEYb+TT2Zhl2zRTilsgibovlMS0JEyEhEruwWpG+osoOKy8gERYuiH2qMfuiZE3W0fOR2Y8OtGKKDXVaixzNbqA/XXdl9sr+6dTB1zLakvGpNy3sF75EAJ8d7opvH5flA/dhce4KoDzTdTQDdMOO/EDsdrg2L25R0Eqb4oZrgr4JeZJEw+QpwKsgWsfKzbqfl0wM9NSJObw5MNUJ4iug2hOOm2I1UdkBibE1lSDJtWNhXS54B4e9a/lXXoEmeHR4Xp0l1PWaLOl1SC6JnEl9SPkycjZTkOMpBijXRHJ5Mks0dahIwnzDoiCMK4lERLRGsx1QsyGAsJr3YIOjyYx6S5qN1kqloYSquJ4tgbrQQHEpEn63QDwEOS+qrrghYR3uvDoOXvEHpw7fqCYs2tgyzJRduzH550B+ps57smeO84cQHXwDXKpdillV3+adn04VdPvvW/fIuHmf4nU8qaCokJlAoaree8yHmZtxdhbxmLsevbQ88n0FH7SByMfSe1BEinzo0W0Vd1aP3t9VT69LNtCGUrtCL5v1xvTrxGp4Aa3fNhifWDoYHZv6K469V9+gHt7Kxu2IRO7jkfHUCJiz2BND0uhgPUtUeufEjB/6X+waC60L98oMH+iyZ1OwD4lUldKyfaVp/Oxy+wmpuYJvYJLj00MI208KYR0JHXsLTGMTo/cpwDB/eXomEjecrO4ZVPGhCDFIHXbkqXMgdtUEcY/bSxR20DPZzqxgaXCWU8FdMvdT0w5eH0BCJ8Ksa3Vn0Eak0AMjS3CKG4ir24dYoz+RoPZ22/ueYLnd7NMBpXJpQUN4t2VrxJxpHgGPMB1pudud8SfVVp1stgaB97+lg74BhMXztiPAXgHCYd3W9iKUKYygQWBXpSdOco5+go/DT5emzqVfzBuTEL1rVkH
 ar/Lh1TT
 KoQx3g/SY1XTmErvU2psYeLN5P7Z8jMnjOO61XgjXi62PM7l3vOEEKSGDKWywv+f5Z9bXrj/blKZYGUauegtxMJnC8658nZXx1jw56kcRKSJdvVBMWS5A3eQlY32IMYJnz56ywAoFH/SgMrRiwtXMsbIwyXBIr8DlWB+1ynk87InitjU/s0/GT9gUlvdjdzUqpBW7FMQ++flrabRgPw9pg5AqXQLakyg1v+jFfrlFA4zsm1T6Lojbg4IQbLPF41lJ6JS5O2YwVC1b3GIRUyTBn/NqNytD38b8ZI9WbjT47kuGcl1YSKdKgnEw+/GNFxyhVikQ8CLvstWS0+p+oMtncYI7+vYhEXI6zDfm
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
index 2a74f2957341..25058004de91 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1758,21 +1758,20 @@ xfs_buffered_write_iomap_begin(
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
2.50.1


