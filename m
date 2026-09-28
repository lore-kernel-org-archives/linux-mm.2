Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4434C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E7E6B009E; Mon, 28 Sep 2026 08:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEED6B00A0; Mon, 28 Sep 2026 08:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80546B00A1; Mon, 28 Sep 2026 08:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD5B26B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CEB8801C1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:20 +0000 (UTC)
X-FDA: 85263038280.02.F93F920
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 06C5916000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JyIXxxMK;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4jCTLZ6VfPkrLngc36gISvPdgc2ww479ZZDxZWHsTE=;
	b=qnNCw0DbJiiYJbkBFGHVIMPi+o387TIBiWoJAnfZORFT2rArMsFgD+paIyN5hWLCE/6e8t
	uITbXUyCXGEqNb5vZ3PWpkLrBb1aVeqprrRCZHZyEvmJyj9Yfxad/k32zuK9xmaiNulri0
	4ENAqrNHV8Bfsq/o9P6azHRJ0BaM8Cs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JyIXxxMK;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597058;
	b=co7pX2rRHSnLymQhtUhrpns3x05YQpDv6VMl9jtS+OGnofAEdEuJUeAbwRqGceSiEZEepS
	nq3ofxhx4oPOSJckuCWVu5wEGqdGDg6nXfUJr/2xDeHKtIMl285HU9lojk/9zQzpOaTH2V
	o6MVCeTF9NZBQ5wf9clJ/Kv5KUxWxwk=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZi8J3971380;
	Mon, 28 Sep 2026 12:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=q4jCTLZ6VfPkrLngc
	36gISvPdgc2ww479ZZDxZWHsTE=; b=JyIXxxMKKpaq76cLqxCvzedrxFMQjsDOl
	9maWDObSmKqi1OkiEfZWRiYqLTOQBrZgGtXSLKJGfvDgTr30gFVkg/9JdqY4zKPL
	8GY2AU2BQ4WaOeN0oUVM8fUi/PE8sKb5+HdVtw0q4Yz//+OxqPJsqEpAGGwN7nDG
	VUJxlJ+D0bAZK+y4aWuGmed2AdqtRRuFkQ43CS6qGDd5ALHdGpgpdHsMso3x5g/p
	EebjpZjkpdIlYIp7voGIGeCPl5IVwXB7oxFO6+LS32g8vCKFSuH0hKpXJN5CexJB
	cicMQfNCOLIuLfQjMsgffSoBWAtIo05pUHRQJOs1+2PZ8Tt4eA0sw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4fe0v5p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:02 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHVms057236;
	Mon, 28 Sep 2026 12:04:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxu2y4ugw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC402025428676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:04:00 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E268B20040;
	Mon, 28 Sep 2026 12:03:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0392820043;
	Mon, 28 Sep 2026 12:03:55 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:54 +0000 (GMT)
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: [RFC PATCH v4 07/12] iomap: Add aio support to RWF_WRITETHROUGH
Date: Mon, 28 Sep 2026 17:33:08 +0530
Message-ID: <d0779ef35a8666bf096f083e0174453f0aea4685.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6aba57b3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=NGqb3fQY2RvKY4TqIeQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX7pASHr2MH61s
 0L7BBaMqqUNdn2jFC4u4UQRli78c+wgKiL6y7IaDgmpvYECS/UNmgm/ARhxO/bx+YT/SKDSouon
 0+ofzmytI7eWSwO16Xwm9C//ljXHM9g=
X-Proofpoint-ORIG-GUID: 5Gw7g037G9i6OhuCnAFY0oZkzSFI6_V0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX2BLV2bypH0PB
 N9l4o9SxjBUg+EJ30Vb1i1hwSvVhoO8tSPIYSm0SpLyqz2Iyj9DRr0DsIJbQdnqGDZN8A52xMrI
 RGLgcy1I4GTEJGVfvHjVw29PFgJR1/x3u+2qRh5S9hXr6BqIB3EZa9+JtgKsTWpgH0N0ss0Z4P6
 bXtFZzD6bNefdQfoyzTH/jBcX+TxSkTnLffd2jINMTDOdTqaYAOEyyLRWlRxDLl28uHR0BN4uYi
 X5W+WPTfpGdtWj/1PorMEWM5/ZqDN5fxG4YFsRHWyjZg9CZ9bzl/8gjDMqpm4J/QZTNdop4In28
 VJ+TJxz/Htv5kpwi2Kum+5eYo1/H7DcOOaVE2iwuWc9ILfbcDQTYYxUylDWanT7LNgXkDHSuJxE
 LmxRlHbkXgAfWTRNVRVMETtTCqtkbUNkISU/GA7+0GtdSK//2YjktmoFpVVjbaSoGJrEoOFfwUZ
 gkWwL5/dELiSp8eX8Zw==
X-Proofpoint-GUID: ECExiIgtMJPxJhkdJhJSTZPLd0TOKuSu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046
X-Rspamd-Queue-Id: 06C5916000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: h69e3fy3mm8yhsjmc5egqz4trz6efet9
X-HE-Tag: 1790597057-762436
X-HE-Meta: U2FsdGVkX1/jL9+K/2Of95BJZrTakG6vwYumk4V/l/HhOHFde40VRvzSi9WrWVGg/6QM8D6jGwVU2+FRoJhZqHkcnFp19DPu8kdRpyMW4L893LfOYdn/4O5pH+RlYP0Unk/nwYxN8ElecqVoAYua7fNBtAxOB2kyGGp8TdAHJCO3SNURBAFOhS4GmRbdQCxpSlrXAnaeF4we2IAUcq8CVnKLZO7zcgl/i4zU71qQGqMijDsYOr5ekFkeeHE0reIzeTZCjEcNLL2kYqSiae25CarjMSit4LU1PXfC3AwPXT+WffNJ/M67itOxZYkKUYzyxk6mPB8GI4WaKU3qrBYBXCFhwfuk6W2uiECHJAvw4YTCc7A7AnYhVkuNAYQnsliS4zGubdjMhuKk0z4KhBIjibtZEU5p21f/vM6OpdxOhABexolnhHzyoI49MfH4dcuZBPlEJhCTp7Ke6UYdTYZ90+1lD2lcj0fTG+x/0UG+esFaYiqhL1ya/cn6CuP/lRbn06NAIKTv0TL78OhUPw6j3M5xtmBOB3Hn36BeTYNdKq/UFZ+7OKfXP1008d8ONCSG1pMDGfItpsmeV2bcePJzxsFIx+gL9VkUVJwb9v4gAydDvxn4PhOdjsmk6eC6tKGyL8q0IPf39Hu4NmUsy/EO9QCLsCUFUgEqTw8URUtW2QShfvP5X/nr+YAhdd/0ZUrl7EvpPCM3wUuYItIestfOlsAdGCz5GM6A9f8yDqHoJo6b65VV931NulufswbwCmzheq5JbMqe7YITDxdd+a2dYxkTZ8EKkazdo6ZMf2hrgoy7tm6GxLRWkNFLgdHEigTJwERynoq5rdMD+Vco/Lnu/H/CaW8epodlURB3rjbtPzQSUSZoFL+I+QSZiO2u8fOAXG3s6prQ+PufKBUAp4SVVX5WxnbCO+CSYHZ5L29Q9meaZSuHq7ZehhAhAPkI7gPJ1CK+TzsPXwXpqbxCFnq
 t2QOMnpT
 A1hhp2C/TbxFylWIf8Aj0ALb+oUzqIiP8L0TvJtA0eY3wAjNY5uE1F/9W3ZOwtFXOcySREG2oJCbXik/GAME5lk9OH7C/XJmTHN1id6AtKHmUBovnFgjL9Shj88Pb0xzunHgE32MUeclzsKvFGPViYNRAjRO6bXeURLJbzkPTsQR1o5BRXDiLZxN+Zv2vljK8+1h/XVrTM9JSaz87DFvMUob/igCnrIrU43bhXM5euE1NuyN6mIujLlFu9DbEfARbGPl5fN5Xh1OqGNDt9LPgJoPoSpJQxr6DCB6D/Tt2HoAlo9wF3GtiHdqtzDEdWevONz3MZJR6I6IIBzsUXevMXZVvbqJkB8Uedou2aGkF0ehm2QEZXvOScehsZU3GPP6NGcF7Tybo8aTl0FjyDiwGShpwlTA6P52A/Jh8lOnyh+FbY0AKdxb1Emd6Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With aio the only thing we need to be careful off is that writethrough
can be in progress even after dropping inode and folio lock. Due to
this, we need a way to synchronise with other paths where stable write
is not enough, example:

1. Truncate to 0 in xfs sets i_size = 0 before waiting for writeback to
   complete. In case of writethrough, the end io completion can again
   push the i_size to a non-zero value.
2. Dio reads might race with aio writethrough ->end_io() and read 0s if
   unwritten conversion is yet to happen.

Hence use the dio begin/end as it gives us the required guarantees.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c | 57 ++++++++++++++++++++++++++++++++++++------
 include/linux/iomap.h  | 11 ++++++--
 2 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 68b93d96faa3..2ea45ab67bd9 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1202,6 +1202,9 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
 
 	mapping_dec_inflight_stable_writes(inode->i_mapping);
 
+	if (wt_ctx->is_aio)
+		inode_dio_end(inode);
+
 	if (!ret) {
 		ret = wt_ctx->written;
 		iocb->ki_pos += ret;
@@ -1212,12 +1215,27 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
 	return ret;
 }
 
+static void iomap_writethrough_complete_work(struct work_struct *work)
+{
+	struct iomap_writethrough_ctx *wt_ctx =
+		container_of(work, struct iomap_writethrough_ctx, aio_work);
+	struct kiocb *iocb = wt_ctx->iocb;
+
+	iocb->ki_complete(iocb, iomap_writethrough_complete(wt_ctx));
+}
+
 static void iomap_writethrough_done(struct iomap_writethrough_ctx *wt_ctx)
 {
-	struct task_struct *waiter = wt_ctx->waiter;
+	if (!wt_ctx->is_aio) {
+		struct task_struct *waiter = wt_ctx->waiter;
 
-	WRITE_ONCE(wt_ctx->waiter, NULL);
-	blk_wake_io_task(waiter);
+		WRITE_ONCE(wt_ctx->waiter, NULL);
+		blk_wake_io_task(waiter);
+		return;
+	}
+
+	INIT_WORK(&wt_ctx->aio_work, iomap_writethrough_complete_work);
+	queue_work(wt_ctx->inode->i_sb->s_dio_done_wq, &wt_ctx->aio_work);
 }
 
 static void iomap_writethrough_bio_end_io(struct bio *bio)
@@ -1783,9 +1801,9 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	if (iocb_is_dsync(iocb))
 		/* D_SYNC support not implemented yet */
 		return -EOPNOTSUPP;
-	if (!is_sync_kiocb(iocb))
-		/* aio support not implemented yet */
-		return -EOPNOTSUPP;
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		iter.flags |= IOMAP_NOWAIT;
 
 	/*
 	 * +1 to max bvecs to account for unaligned write spanning multiple
@@ -1804,11 +1822,33 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	wt_ctx->end_io = wt_ops->end_io;
 	wt_ctx->old_i_size = i_size_read(inode);
 	wt_ctx->max_bvecs = max_bvecs;
+	wt_ctx->is_aio = !is_sync_kiocb(iocb);
 	atomic_set(&wt_ctx->ref, 1);
-	wt_ctx->waiter = current;
+
+	if (!wt_ctx->is_aio)
+		wt_ctx->waiter = current;
+	else
+		/*
+		 * With aio, writethrough can be in progress even after dropping
+		 * inode and folio lock. Due to this, we need a way to
+		 * synchronise with other paths where stable write is not enough
+		 * (example truncate). Hence use the dio begin/end as it gives
+		 * us the required guarantees.
+		 */
+		inode_dio_begin(inode);
 
 	mapping_inc_inflight_stable_writes(inode->i_mapping);
 
+	if (wt_ctx->is_aio && !inode->i_sb->s_dio_done_wq) {
+		ret = sb_init_dio_done_wq(inode->i_sb);
+		if (ret < 0) {
+			mapping_dec_inflight_stable_writes(inode->i_mapping);
+			inode_dio_end(inode);
+			kfree(wt_ctx);
+			return ret;
+		}
+	}
+
 	blk_start_plug(&plug);
 
 	while ((ret = iomap_iter(&iter, wt_ops->ops)) > 0) {
@@ -1820,6 +1860,9 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	blk_finish_plug(&plug);
 
 	if (!atomic_dec_and_test(&wt_ctx->ref)) {
+		if (wt_ctx->is_aio)
+			return -EIOCBQUEUED;
+
 		for (;;) {
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			if (!READ_ONCE(wt_ctx->waiter))
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 5a9223856015..691f48bc8afa 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -569,9 +569,16 @@ struct iomap_writethrough_ctx {
 	atomic_t		ref;
 	unsigned int		flags;
 	int			error;
+	bool			is_aio;
+
+	union {
+		/* used during submission and for non-aio completion */
+		struct task_struct	*waiter;
+
+		/* used during aio completion */
+		struct work_struct	aio_work;
+	};
 
-	/* used during submission and for non-aio completion */
-	struct task_struct	*waiter;
 	int (*end_io)(struct iomap_writethrough_ctx *wt_ctx, ssize_t size,
 		      int error, unsigned int flags);
 
-- 
2.55.0


