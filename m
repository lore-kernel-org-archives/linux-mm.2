Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F9D910F9969
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 18:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DE36B0096; Wed,  8 Apr 2026 14:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD8B6B0098; Wed,  8 Apr 2026 14:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595F06B0099; Wed,  8 Apr 2026 14:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48A5E6B0096
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:46:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1066057BD1
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:46:42 +0000 (UTC)
X-FDA: 84636269844.13.9AD98D7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9F57E40002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:46:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="b/boA0s1";
	spf=pass (imf04.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775673999; a=rsa-sha256;
	cv=none;
	b=FfORqHEByHeARIrbxzp2XHVln2Ul3o6WsScY3/w1jgAtacfSxL5Uj+SANDhkScRDijo2E7
	nSdYktAOegiJAxMByssnHh3M/tyPC+3fBTLoqmrnATl7FceGRRLXU771zKioClmfslGIv0
	SFng4oXlU4AeFnVbFrxbPubgj8L7L68=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775673999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqhjeDnHacxc+DguGBAg4lyRMb8kf2xKVKHgKUo0dTQ=;
	b=O/TnkKMAAAg4BfkfFfRkDkizChoiggl0T60nh9vPhUrbRSWAV8kpihYDdW5nSaYNxaaeL7
	jp45qRa5rfpiEsM3iU+LQkfJu7M30DLwWRGXvApwgQ02ZKejXI9UG4Bb1kUujgrDyRQs+y
	JctweFVCeGXdFURKhXHODNz0x+uSFhA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="b/boA0s1";
	spf=pass (imf04.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638IUBCd2302408;
	Wed, 8 Apr 2026 18:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UqhjeDnHacxc+DguG
	BAg4lyRMb8kf2xKVKHgKUo0dTQ=; b=b/boA0s1d5bxxGIH292nbEDfFlIzo0vQS
	Lj+GzoqG2ku5LH6RRIGGio4I4hB1EfPsFn/19F92MnqjetYttdgvbGxLfac55t2l
	6kZPSsnPrSH1i21U4nukUNG3awYQJnhnJmQUODCxt4olnyoxHsSpt2tBdLTn13tb
	m9GqV7G8ek2EASKNtLdTBt38qoMeU9qrKBMlVEU6cgcqNkOa/JdP108qL97RrWKG
	tsadwF5g/Fuil8uWNeiYPuCk8ZyXCwaruD3LbXz++OFc4WNLhl3qiKm5KL4pgi9I
	mVcg4e8Mxx6+MOC9c1k4tZ2AEc0pM14sUJgc7QKNKU07XUzE8xtcQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2fhj03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638FpSrP019008;
	Wed, 8 Apr 2026 18:46:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9gm3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:28 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638IkRZf59310524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 18:46:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF2442004B;
	Wed,  8 Apr 2026 18:46:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54F0120040;
	Wed,  8 Apr 2026 18:46:23 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.72])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 18:46:23 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH v2 5/5] iomap: Add DSYNC support to writethrough
Date: Thu,  9 Apr 2026 00:15:46 +0530
Message-ID: <162ff37dec9295bb76ebadba6ea72ac72cc3c3df.1775658795.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3MCBTYWx0ZWRfX87itVyAk2BZw
 5zN6CXNfltPIFFRrEFyk869PVeO3cgxSrbmZlzzYBGnb1mdnjf3zpO8wEziXbIsFmagcLb3SuR4
 T52vGnAn6vvAWG39vJ/eBB2BxTyQVw54CRz3a3tLAUNM+uNYcZeIuvuymRGYGTU+nTa6G8IcVcA
 5KQpuGuuawggPiyDy08JyuhSaEnXGSbc9psXzBKyg9AcrSBirixkttd1S9Jd7SmnYjQ1cUEmu0p
 VKsyhI9AMvepW3hcpinDZYzXRrKUfhGyg//PeDrX/IXryF7XZYRm/XBkcf3LiOp5XiIHtVignxa
 /cY26NUPpYWgQl2R9h5ljUTGL2XTctcHF/8ZPP03g22nWNksmLvBnsQdVeOh95g/PbrEUwZpw2x
 Q5NZa45dMbvltx6Kr34IATMaHn0SRDb/UYKIGJ2KfDL4hNoduv9O6R5WACz/OhzdLq+KGo1sVLE
 ynWayXCnc16PZ48IL3Q==
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=69d6a286 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=qsowkHyYPmhlFs6s4IEA:9
X-Proofpoint-ORIG-GUID: yg4EfJuoyroMIX8kQWusv1PnSFj0EC2h
X-Proofpoint-GUID: 8y3ULG_eg5bbhD938sHwn0yaRqJi3mqR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080170
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F57E40002
X-Stat-Signature: 9s4z7zzxtjbf8uk36ig9dyu9smn59gsj
X-HE-Tag: 1775673999-551358
X-HE-Meta: U2FsdGVkX19xgcC+HRsETArQ2A33/Cnw7bFz51gSt1DY1vjLcReWEOHOhpdy2qWI/sOUZFEN7CnSMWJ0kkmCz2MU4YQCAnDX5zzO1oBdmwEGMP4ThgQemeVN1dQhhH6rofLujbZ+izT8eaxKD1wlMl7iaef2vnUJJj+/OoAWbHouEXALMN7wI/Lx3C7bYDyQ9OOUpr+npEjLE+6OOCL7d2Tmpetuvs5nUA7L+m9TmefqeuQaFNoU+sZ3BY4uYNo7VCeKdDcjCcpqO6FR7wfLAfbTb6Z2nmX7bDmKqx/G5DNN20Ywzg6I6a4VtqYMFevSMXt7K+WYXzGnUr/cSTtVq/5+bM2S2I4GyW5/an21zeWYPqnh2T16cSBV2H38d7mmgcmGxcc2FQrkekt6bHJof+mDa03O64mKLkbuHkRWtqB3C/hyElAfl/pm0FMl7Fbj4i3xfqMOPVzwjZa7Icu404mu2Ps/Yn5yqTrO8AmweS6XZYNylGj5kpYePki8QnduJ3RxMKkes7GdydlUs18zKzWuYBiWlH2e0AKW98dVVg83cmnl/e2d/uwW5/+NyWIsNInGeSxCuGbkay99AbYs9y5IO1x+FZIEuIPSqx7xDv4D53U5BNF/ZXBS0iC7tE656mpjN2EpwlL/NsAAM0bTKrERkbalcRaR0NV6YxATlHxkrRmfVX6vbXDYBy3/p//j58C3PTcs79EIEvr1dkkg2d+J6iCYOPImgrn95INhJqBA6Za/DuD+1iDMSdq0hF9sV2kIty5lxvB5+lhhgialtzlfxpQ68Rr80CU+XSueb7htgkgxUcKmbuN5WkcalkswU1C9NRWa4/muXepXHtVXhInmRY/DCmKHPa2D1t4Zb0dUMDu32QCrJi5iIMbSpphxl8BfDezEWIl3UrgX7ReRJid94/Ls7LK7Txw13zyc3vYaVL+tyl+Q3WjIoHE5RDsvSB4+MmJuVp6x3vdV1pR
 J0dSTcoG
 bNgJz32ivgQjXoclRHqNFSWQIme43Z8P1/OlNr0UO5yZvUMxElhvR/XHVl/s+E703QkotNEVvHeHQIdjqsR5ile1dTYkf+r947oq9JhXsIfX5bbo/52A25B94tyfwdF64Ajw9dHuKL7/L6RBst3yD0IPQPYqE/RzOB8youd8FBGNZ9eQi0v8x0GZxGbcDLlnPsZhOreN5+wSBRyUkP0cmFeQhAFFD+VUAN8w5nPa6tZp1VmHX8u5LRzykMIVO5Y95xFjlc7ycHQwJAi2wFHjA7q9+1QXPh3thfcvrTgesFm4tvUHF8ATjgvalVwh3xeOjW2YPfBKpZbZ5GV2swxIyKYZgWqkNQPzNgWPv3d9n9K7pWyROXiDb44GnfTZmVamiKxXusjPlKuyVjKUH4bXXsC/sdeEX9MNCPRPX
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
 fs/iomap/buffered-io.c | 37 +++++++++++++++++++++++++++++++++----
 include/linux/iomap.h  |  1 +
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6937f10e2782..8965f603f2cf 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1119,6 +1119,14 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
 	if (!ret) {
 		ret = wt_ctx->written;
 		iocb->ki_pos = wt_ctx->pos + ret;
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
@@ -1173,6 +1181,7 @@ iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
 	struct bio *bio;
 	unsigned int i;
 	u64 len = 0;
+	blk_opf_t opf = REQ_OP_WRITE;
 
 	if (!wt_ctx->nr_bvecs)
 		return;
@@ -1184,7 +1193,10 @@ iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
 		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
 					    len);
 
-	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);
+	if (wt_ctx->use_fua)
+		opf |= REQ_FUA;
+
+	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, opf, GFP_NOFS);
 	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
 	bio->bi_end_io		= iomap_writethrough_bio_end_io;
 	bio->bi_private		= wt_ctx;
@@ -1273,6 +1285,19 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 	if (!(iter->flags & IOMAP_WRITETHROUGH))
 		return -EINVAL;
 
+	/*
+	 * If we realise that cache flush is neccessary (eg FUA is not present
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
@@ -1545,9 +1570,6 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 		return -EINVAL;
 	if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_DONTCACHE))
 		return -EINVAL;
-	if (iocb_is_dsync(iocb))
-		/* D_SYNC support not implemented yet */
-		return -EOPNOTSUPP;
 
 	/*
 	 * +1 to max bvecs to account for unaligned write spanning multiple
@@ -1575,6 +1597,13 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
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
index e99f7c279dc6..579bc48ed39c 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -487,6 +487,7 @@ struct iomap_writethrough_ctx {
 	unsigned int		flags;
 	int			error;
 	bool			is_aio;
+	bool			use_fua;
 
 	union {
 		/* used during submission and for non-aio completion */
-- 
2.53.0


