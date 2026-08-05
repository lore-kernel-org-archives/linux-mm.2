Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE65C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78496B009E; Wed,  5 Aug 2026 02:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50096B009F; Wed,  5 Aug 2026 02:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17B86B00A0; Wed,  5 Aug 2026 02:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 865606B009E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:29:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19FF4403E5
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:29:15 +0000 (UTC)
X-FDA: 85066238670.10.5ABE436
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id B1EC540005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:29:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=trn3GdC7;
	spf=pass (imf27.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785911352;
	b=l6Vg4mnONrIGzfMnxZJKbnKYXRNU0VGj63ecQVXm07pLIXlHGkhp6vBxux68g/OkfB3ykN
	bOsNWNr1B6gADb9h4nTz9xRsCxbvsEAQBeBgrzzxvcoTzCwA85vA4huf9IzmYYFXUhOSTZ
	64OXmiFpLTKsom4/MNUAzstNH0ONjZ8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=trn3GdC7;
	spf=pass (imf27.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785911352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdKhp705dEcznPJBniSr00N+kfQqAjZ7LiUlc9r+98w=;
	b=eVBLgz+qyx+LpYq3zsbOGUWpHwEMDu3oOBs3XmpyWz8y2ant+quWGSFvSYC2V72e6NYyMk
	833BXGK1owdzX8nHonR/G55r7ASLbfl6k+zw8xZ5T7LLYpJvpe6ytTzIY12fQJ33G+Qk4L
	WKBFopB3TbNU0/i7EZfU4Dsz1fsYAcg=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755li2v1121515;
	Wed, 5 Aug 2026 06:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NdKhp705dEcznPJBn
	iSr00N+kfQqAjZ7LiUlc9r+98w=; b=trn3GdC7qC0zMJlKNJL6+VcCZ58D84lUd
	kYaxVtn3sjkvFM3d7K90kCC7eYxjMIuUaxh7deNL8PDSCJKF/WiNQofAzJAjBYdz
	jH72FXGhdhe4WQfFHGso+xdipUQtkxcj2t6ac4+U491riKR/54KRLCq8PYpfMgk7
	YGxz6Eaa8lJj9VP5uOvZvRDSOvbsyMyVK0iEYnxduvcOBrcytwFZIRDmr3o5zdGO
	Wg5zjbpu1PuD/e/RwH6nVPjFCQW4Gp7trhoY4VJrKhCj2p68UpOlzZEQWRuRjQya
	WuspRSDwczIEonXZ3TL138if0CvAwMff1g4dmQcHBYQuKez+06OIA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8fqsjc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QF6C028117;
	Wed, 5 Aug 2026 06:29:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fsu4qnffh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756SxEi49545516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 703552004D;
	Wed,  5 Aug 2026 06:28:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6E2620040;
	Wed,  5 Aug 2026 06:28:54 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:54 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <dgc@kernel.org>
Subject: [RFC PATCH v3 07/11] iomap: Add DSYNC support to RWF_WRITETHROUGH
Date: Wed,  5 Aug 2026 11:58:13 +0530
Message-ID: <a679d79b676d3a43332aba54ba25660c9ea9e1dd.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Cv0jrwULaJcF3eYfANKQUI1WYQv-IJQm
X-Proofpoint-ORIG-GUID: jiTnd4ONBctT5UEZ0brA3-HUtetCYSMT
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfXx9sw/ipQ/+3n
 vgCCYpEdXwZZlBX3Pwxquf91APDEKm1mPnWP4lkKo3sWrIrWrBrdSxG4/jIU8hiLHEntEGDIw+y
 bV5KTXQayb4dBXoPqcqcBB94RlbwGlU=
X-Authority-Analysis: v=2.4 cv=K8cS2SWI c=1 sm=1 tr=0 ts=6a72d82e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=nOap7FSNCsi5F2RPnIcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX7MZYEjYorxrY
 gNi/Nl3hUJmyFEbf2QQ7PFnpXhMG9GBEoGUQ5jC31MEYJsW+Yswmi+1cUb8nzXNSxc7MHR27VOl
 4s3+jCXA7zuMnlzdeUdeJdJhx4bqkWJb8wXWTeWnmZUwr5cM7sOGZrUITap76WTh6Q53lHoiZkk
 4IbZ23SPgjMteo64RvdZl9Vate0PEreMOfWDZ85SabrsUWc+aqFgM/o86GPCJY0ZR9XorZdhFwS
 etSLqOQIi93+DOB1reQnVjVdDJTxjsH5PzSI03iCaSnnHTGAN5EMr3KlIyNxTfvHFU+BYB4UDlS
 AvhTm4f+e143eSCNSCf00hZEfJPXGHsXYMjQvrEqxVqDKLMrO5bdEtYU/sMUJx9Zi6mHFp9u2dp
 gqct9koOCpfJQuTXu6DUCGUmCovegNWhIVzynFFLeTgZEH7XR5T9HMRrCTNALq4hc/00PmAKvfs
 JtvoyCgTymDZAasyOXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B1EC540005
X-Stat-Signature: qxu5ie47omtwcm5qix99rqok4ztshpu9
X-Rspam-User: 
X-HE-Tag: 1785911352-954377
X-HE-Meta: U2FsdGVkX1+3TvRVCJ4zO4dzqFLtkSFlky7/1WAIwvgIMAabe6PdAeN5Io3VT2iJ0pNAdaGIBCVRTvb/xuM56wIDsA33KmU8ClvR100ftZkLYu4/jMotW01faBkkXJV0PSamrC2gICm4jE/kalSKWOC8CAK0sVP8hPnP+nSgg+RRzL9eeK5p4ioTaFV0CARGkaUkou4KbaNRZy7JmfJ6vx0tB7PqXQAXgv0VJBmWDuYbEs00eZhiBI9BOBCF3xHGp4z2qDKuaItdE4LdWy01w2P+i6cayer2SXYVAXn2xk+xrRjxNHq5LTcTFx+StR38B1wwEu7BCwssnRXaIqRWMtUjxwgxPcL2LEoskaDoam4ys1uqYl5tguQTh6bOLZYhrCHonmc3OyDhnzlGTn6pEu9xExaeK0+gczmkZ3XSNfOXAt5lbP75n5pCzbzkknvOECkrDNhBmU6bVrHIaTzrYItwXw6DhqVFXcFTbuucHSRhHSzDjLZqKy9GlmAtAEBG0PfpQ+OiJSo+lPjNm64Icra8iTDYQ8N1GEsnzE2TcnyqiKj0vF8jkaJRuAYUL4t8tMdBkaSnn62RFp8VIImuxGYGAJApa3mxGH0ZBYGsVPLEmv79lQCtFzUvelU/CU0JLwm+u1Z22GQwNa0WSmOWlOedEPOUhn2e08SGhH8bibaYX0LAEv/sdmxSJuIzYGRUWf3wrbwHlKiT5RHmQeXTOoDqxh85aaSajv2Sso/tBh+29SxiTzYIVnEnJxLu5CvRP63IpJScLHGyjgTjRlqLh7Bnugx/WrJpiqDsapgnChu1U/s8ng0JImjm6sM77pk74Xc6x9fbyrNfTPRhFfoHaX6IYkb72mJRcm6tTtIeCO5HiGj+0CCNLyX5COBhh2cc/R5Kymaq4u5YslCtgAePKO+/DuinmmSRA1XcnCn7YsdxWlbmpHAH/UsiJ2HZ5gPOBoQUjNhvan+xPKdfGP0
 XqJiDvYm
 sy1YrzrGQEVVRT80HsfCg/MwWT2SiyIbBE/rfXc2wH7CL1wDQk5Z9ywlyILzqYMzGS0jM50/ePiAasTYuoIYvvOnwnPJkGmUqyGwH0CI6Q20IzKkHbS5losAfqc84+UcnbJgMSvCRZ8FtZEUNp+FNAw2RmJzRlK/8L1ptq9CnjXq+T8NOR2cPNpPSx9I8suglDNBdCfPnlr1M6xLQvo3b1tYdTCRbLKCGKLtFJuaHgR+D4DRdjSCKY1pzVwQiVWWkb4VjFclVkLttnHfcbTma5RyTIJHeZWgxtr107D1urhasWQ6riVGZ2/x2aw3RZiG068XfNxI7drwNiFDGqwf9pOy0HL6oItKn2tWkqYizofFXpq8aJ/N/peDYrlJhE4XZEuCaphk6cuBydW25jsVfSjvJiWkcbkJYqq2SkVAWFDkhFPzuvqSPoNb/RB9o5ns/ogvRPNTwRKZdfOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add DSYNC support to writethrough buffered writes. Unlike the usual
buffered writes where we call generic_write_sync() inline during the
syscall path, for writethrough we instead sync the data during IO
completion path, just like dio.

This allows aio writethrough to be truly async where the syscall can
return after IO submission and the sync can then be done asynchronously
during IO completion time.

Further, just like dio, we utilize the FUA optimization, if available,
to avoid syncing the data for DSYNC operations.

Suggested-by: Dave Chinner <dgc@kernel.org>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c | 34 +++++++++++++++++++++++++++++++---
 include/linux/iomap.h  |  1 +
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 22e4252dff4d..d16694dd9995 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1208,6 +1208,14 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
 	if (!ret) {
 		ret = wt_ctx->written;
 		iocb->ki_pos += ret;
+
+		/*
+		 * If this is a DSYNC write and we couldn't optimize it, make
+		 * sure we push it to stable storage now that we've written
+		 * data.
+		 */
+		if (iocb_is_dsync(wt_ctx->iocb) && !wt_ctx->use_fua)
+			ret = generic_write_sync(iocb, ret);
 	}
 
 	kfree(wt_ctx);
@@ -1269,6 +1277,9 @@ iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
 	for (i = 0; i < wt_ctx->nr_bvecs; i++)
 		len += wt_ctx->bvec[i].bv_len;
 
+	if (wt_ctx->use_fua)
+		opf |= REQ_FUA;
+
 	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, opf, GFP_NOFS);
 	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
 	bio->bi_end_io		= iomap_writethrough_bio_end_io;
@@ -1405,6 +1416,19 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 	if (iter->iomap.type == IOMAP_INLINE)
 		return -EINVAL;
 
+	/*
+	 * If we realise that cache flush is necessary (eg FUA is not present
+	 * or we need metadata updates) then we turn off the optimization.
+	 */
+	if (wt_ctx->use_fua) {
+		if (iter->iomap.type != IOMAP_MAPPED ||
+		    (iter->iomap.flags &
+		     (IOMAP_F_NEW | IOMAP_F_SHARED | IOMAP_F_DIRTY)) ||
+		    (bdev_write_cache(iter->iomap.bdev) &&
+		     !bdev_fua(iter->iomap.bdev)))
+			wt_ctx->use_fua = false;
+	}
+
 	do {
 		struct folio *folio;
 		size_t offset;		/* Offset into folio */
@@ -1744,9 +1768,6 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 		return -EINVAL;
 	if (iocb->ki_flags & (IOCB_DONTCACHE))
 		return -EINVAL;
-	if (iocb_is_dsync(iocb))
-		/* D_SYNC support not implemented yet */
-		return -EOPNOTSUPP;
 
 	/*
 	 * +1 to max bvecs to account for unaligned write spanning multiple
@@ -1768,6 +1789,13 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	wt_ctx->is_aio = !is_sync_kiocb(iocb);
 	atomic_set(&wt_ctx->ref, 1);
 
+	/*
+	 * Similar to dio, we optimistically set use_fua=true to avoid explicit
+	 * sync. In case we later realise cache flush is needed we set it back
+	 * to false.
+	 */
+	wt_ctx->use_fua = iocb_is_dsync(iocb) && !(iocb->ki_flags & IOCB_SYNC);
+
 	if (!wt_ctx->is_aio)
 		wt_ctx->waiter = current;
 	else
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 7203c4d92170..ba510d02c508 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -573,6 +573,7 @@ struct iomap_writethrough_ctx {
 	unsigned int		flags;
 	int			error;
 	bool			is_aio;
+	bool			use_fua;
 
 	union {
 		/* used during submission and for non-aio completion */
-- 
2.55.0


