Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D176710F9969
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 18:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1856B0092; Wed,  8 Apr 2026 14:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34BBC6B0093; Wed,  8 Apr 2026 14:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213E26B0095; Wed,  8 Apr 2026 14:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9046B0092
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:46:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B147D139FE6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:46:29 +0000 (UTC)
X-FDA: 84636269298.09.3D8AA5C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6AC3040002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:46:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RM4RqVwg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775673987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ei4tbMs16OI1cyCL+XlF1NSRsr+yRMoqkt46it9yX4I=;
	b=Y1vCjbzZhAQijQJRfGGrIwLN9WGgHZ7Ktz4s+VxmpU9Lpd26Z92dFZU3sGo0Ca7OAKHC6f
	7lW0KLdcNytMFOnxaQEM21ON5cQzkm9kCllloJs+C95T0K8UStxZM7hhYwvr57ogmDGRHz
	JruTjDSkTb7L3KZDIZbZojgZCFYzdpo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775673987; a=rsa-sha256;
	cv=none;
	b=DF1+5jy86QGqGrrXhtGpN3L+EG7X52SdMDFyEskM5xbR7aaXhQOuNxJK+lEIrtmQVUp1dA
	MbSRn+iTxCS4mqcDR4cU1T7eP8WOGOXf038ebzwkYErLFvBXUxVX7DTJUpngVpEfA9WqMA
	MB1bapdvhjORQH190UbjiHId/z0/ccg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RM4RqVwg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638Hk23b2210122;
	Wed, 8 Apr 2026 18:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Ei4tbMs16OI1cyCL+
	XlF1NSRsr+yRMoqkt46it9yX4I=; b=RM4RqVwg56Mz+7WWEW1OJDjh/xHOc+5aC
	lUmr5u95L797qxPSU+4jQpeg936luuelseig+LUBCnLE+ILgmbTmaYqnicJ8bEjF
	TT8aVAfM2pjEBARGfwN7hbEf1x1EzAdbLI43IfnzuQwoyX9sEk2iBVKJi9Wi41Cj
	y35gj9X9MzHeddwtgTjJZci+v7V0OkT1DmdUbXZzSjTJ+njKZfA7lZB5UNy4XR6Z
	R0paxsMNlhzy8/5VO5P+wSLGJXRYp/Zsyhr6dPvuApYjY8o28qPGhh8WIkRdg5G7
	s46tmIgvPDpv9fr/X0EyruyS8HxVlVT9BpJdl1IO2Oi6yDUH4dQIA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hguxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638G0HMJ018877;
	Wed, 8 Apr 2026 18:46:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9gm3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638IkEJX44630378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 18:46:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 545842004E;
	Wed,  8 Apr 2026 18:46:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1C742004B;
	Wed,  8 Apr 2026 18:46:10 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.72])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 18:46:10 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH v2 2/5] iomap: Add initial support for buffered RWF_WRITETHROUGH
Date: Thu,  9 Apr 2026 00:15:43 +0530
Message-ID: <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3MCBTYWx0ZWRfX1Bsd1b5k5L0d
 Yw9OV/qNxG6RzoKKI+FijPkzLBjxs8aI9ErSNB8mDcwFlZKZxUxzykCwwEK36/fSu+8/93Mxe+G
 7/X/c+k30z/681d0I7j2KUm8sjfOPAwkyr3LjxK77NY2YPCle9Dz+yBCTrt/Osi+sXSDwVALpxa
 fgfgqE4s2YZYtd11TrrKWUcc1m0rn7Kt1YH9ZUe7mnnv7cvWRxkA+ZnVDvkEWH8r7iobwfU+grU
 rGgWUQWUmbQ5y/U535X81nwhDCeteRcBwIl0oNyTgabpaGWAfvYVoNXpmjdFvE4jmMcH/Slkskj
 dv/UrLVW3CIdA1VrUgG8y8MGxm/7q52qZ2PfSaoBmjValoAIzZkhqiGDDXjOLu/ThJh0OUPfpbS
 5h44W52gh1g6l9T02cY6w8LOhi3k5UOF/exQlVKtAAnbsrPTjfUVeZaPLzRkkBge3QhxaKOYN6D
 rTUbfjO4k5NywnP5ezQ==
X-Proofpoint-GUID: zHkimg8hj8Qqu9DVWsdpzMLgmb5HOA7Q
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d6a279 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=TxIjQczwvY32lihKEpwA:9
X-Proofpoint-ORIG-GUID: iFhz_i9jpoMFnKRaEuk1cUNDiDGJYAxn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080170
X-Rspamd-Queue-Id: 6AC3040002
X-Stat-Signature: uih78trki9isankpfrm4wt3pcfwnwj1x
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775673987-689143
X-HE-Meta: U2FsdGVkX1+YzUN2l+5bjRXicHf0de5l3xTX2UNWM5JcN2T61fthPeilLgFfHgtESIq1vy0hxWag5ssi2i8HFrCT2tNv/MG5C7McSD3YyQ7Mu/cg9N/ANFMbjvoycAIwCYYIvZ7TH6jRMXOgxkV0ij0TZfQpN2oN9znePmn3Bfxp8vJ0vnMM0TYAQwZxX9MFOCY6qiVHV/neYzbGLjDqev8S5Uws13/7u8nR9j2g/EPbTk3G8Co0Magx3Coeu2XTFj08B9YfZtDOWGcZgyxzVCdC+Et3Z1nZMf0oDGC2Ix3x0MY5Nc0jDkXIXZu7WlaNsqQOfQLIgogU4iQJRuQPG2PyodX4jKzRlVsrvC9PVsfqaQ+JTlDqK2J4Q4LKt7Y3eUcVHDse0Bj+6u7AEGVBuqnhtHmu7FDSDeKaAKAcDGQh5GPpj2JzjUOR4gs5xrwmFvu2s4g07tRdvF/GaCihgH3+Bb5p3vZnNgDtom1yuW8P0ZXNMPEAQfU3anbNrEi5mLRu2JsFPsESViaK5sTnYHi8+x80N7Zfa3bNEeKZYQVijLO/14RvZYtMCL8F2adj813PvI7oi2a9IXTZutfn+FqU3YDc7AjQW1GDSv3JUN76kgNSkaEkl3Zn6Schsr04qYLItPLNmNQTgQoTAlnS1PrS40q1oREn2b2B2xLEoqy9DnIUtbM/ptbI+5niBULkOaPjt1rGJFg2ZKwoOliCVtkGmxnJgXBK7EDQ66quHFn5+mTmYDMB8ub1KLLDQYvnTQMrZQE8/p75JT5qUdTtnPc10MUSIZ3CyGokxxA+wTnGSL63KNTUXhAlH+oV8LFllleWqaMngcRUPMdITENdFAi3taLxNuq7ofrXB/sBHMtG+Lwbpdqu939aiWaCdwR6xlozQ0xhl0zywY9tOoFwKyAbc540C3eGopvPuT6RGSkNJJuVbtNVeEGfRQ05lsktXtvVHaVjmE92u2Ob7s9
 hroOD8k2
 WOxZa/VF4m3EZjLWbTWY8ncdp6XDPv8gRdXw/IcXvrgoD31ARJOYardelRM1/+rBOMn6CJAhEWllfrr1ffobMwWsDqyB/sRE2fz0/+US0YUy1tzP52B74xqmXfrt8qpCW3uTGNR7dy1rIMbIkCn+FTOZOcTD6UhIy7uJkX4wQTfwAikEB6AM2IyTWJEwjB1VSPdhzWKNZnRSz4SSBW7i0xKgpWo3XWhk1LwQKuFiaIaqQJzAKR6ASK8l+F2DRcJ4EYzH8XV1gviDeb9xBLCBr1IZVDgOzAhHIfLprFuGDzkqAVjDh9TwZQXbBksrxntekoCflz/yeW7L+extRKrpXXDIEZzBXdTz/9IV6jW3tr35NuEQyE7TQnnHizLeV43Q9HBecBPyZYB4wvWfsCCu4+YnyQ5TvRS21wRoJ2fuDm2MdFkhNYuUuzDzVx23+EGnUdSwvh+qVZP2gDls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This adds initial support for performing buffered non-aio
RWF_WRITETHROUGH write. The rough flow for a writethrough write is as
follows:

1. Acquire inode lock
2. initialize writethrough context (wt_ctx) and mark
   mapping as stable.
3. Start the iomap_iter() loop. For each iomap:
  3.1. Acquire folio and folio_lock.
  3.2. perform memcpy from user buffer to the folio and mark it
       dirty
  3.3. Wait for any current writeback to complete and then call
       folio_mkclean() to prevent mmap writes from changing it.
  3.4. Start writeback on the folio
  3.5. Add the folio range under write to wt_ctx->bvec and folio_unlock()
  3.6. If bvec is full, submit the current bvecs for IO.
  3.7. Repeat 3.2 to 3.6 till the whole iomap is processed. Submit
       the final set of bvecs for IO.
4. Repeat step 3 till we have no more data to write.
5. Finally, sleep in the syscall thread till all the IOs are
   completed (refcount == 0). Once that happens, the end io handler will
   wake us up.
6. Upon waking up, call fs ->end_io() callback (which updates inode
   size), record any errors and return.
7. inode_unlock()

This design gives buffered writethrough the same semantics as dio and
any error in the IO is directly returned to the caller. The design has
delibrately open coded the IO submission and completion flow (inspired
by dio) rather than reusing the dio functions as accomodating buffered
writethrough logic in dio code was polluting it with too many if else
conditionals and special cases.

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Dave Chinner <dgc@kernel.org>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c  | 352 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |   7 +
 include/linux/iomap.h   |  38 +++++
 include/linux/pagemap.h |   1 +
 include/uapi/linux/fs.h |   5 +-
 mm/page-writeback.c     |   6 +
 6 files changed, 408 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e4b6886e5c3c..74e1ab108b0f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -9,6 +9,7 @@
 #include <linux/swap.h>
 #include <linux/migrate.h>
 #include <linux/fserror.h>
+#include <linux/rmap.h>
 #include "internal.h"
 #include "trace.h"
 
@@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 	return __iomap_write_end(iter->inode, pos, len, copied, folio);
 }
 
+static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
+{
+	struct kiocb *iocb	= wt_ctx->iocb;
+	struct inode *inode	= wt_ctx->inode;
+	ssize_t ret		= wt_ctx->error;
+
+	if (wt_ctx->dops && wt_ctx->dops->end_io) {
+		int err = wt_ctx->dops->end_io(iocb, wt_ctx->written,
+						wt_ctx->error,
+						wt_ctx->flags);
+		if (err)
+			ret = err;
+	}
+
+	mapping_clear_stable_writes(inode->i_mapping);
+
+	if (!ret) {
+		ret = wt_ctx->written;
+		iocb->ki_pos = wt_ctx->pos + ret;
+	}
+
+	kfree(wt_ctx);
+	return ret;
+}
+
+static void iomap_writethrough_done(struct iomap_writethrough_ctx *wt_ctx)
+{
+	struct task_struct *waiter = wt_ctx->waiter;
+
+	WRITE_ONCE(wt_ctx->waiter, NULL);
+	blk_wake_io_task(waiter);
+	return;
+}
+
+static void iomap_writethrough_bio_end_io(struct bio *bio)
+{
+	struct iomap_writethrough_ctx *wt_ctx = bio->bi_private;
+	struct folio_iter fi;
+
+	if (bio->bi_status)
+		cmpxchg(&wt_ctx->error, 0,
+			blk_status_to_errno(bio->bi_status));
+	bio_for_each_folio_all(fi, bio)
+		folio_end_writeback(fi.folio);
+
+	bio_put(bio);
+	if (atomic_dec_and_test(&wt_ctx->ref))
+		iomap_writethrough_done(wt_ctx);
+}
+
+static void
+iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
+			      struct iomap *iomap,
+			      const struct iomap_writethrough_ops *wt_ops)
+{
+	struct bio *bio;
+	unsigned int i;
+	u64 len = 0;
+
+	if (!wt_ctx->nr_bvecs)
+		return;
+
+	for (i = 0; i < wt_ctx->nr_bvecs; i++)
+		len += wt_ctx->bvec[i].bv_len;
+
+	if (wt_ops->writethrough_submit)
+		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
+					    len);
+
+	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);
+	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
+	bio->bi_end_io		= iomap_writethrough_bio_end_io;
+	bio->bi_private		= wt_ctx;
+
+	for (i = 0; i < wt_ctx->nr_bvecs; i++)
+		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
+				wt_ctx->bvec[i].bv_len,
+				wt_ctx->bvec[i].bv_offset);
+
+	atomic_inc(&wt_ctx->ref);
+	submit_bio(bio);
+	wt_ctx->nr_bvecs = 0;
+}
+
+/**
+ * iomap_writethrough_begin - prepare the various structures for writethrough
+ * @folio: folio to prepare for writethrough
+ * @off: offset of write within folio
+ * @len: len of write within folio
+ *
+ * This function does the major preparation work needed before starting the
+ * writethrough. The main task is to prepare folio for writeththrough by blocking
+ * mmap writes and setting writeback on it. Further, we must clear the write range
+ * to non-dirty. If this results in the complete folio becoming non-dirty, then we
+ * need to clear the master dirty bit.
+ */
+static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
+					     size_t len)
+{
+	bool fully_written;
+	u64 zero = 0;
+
+	if (folio_test_writeback(folio))
+		folio_wait_writeback(folio);
+
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+
+	/*
+	 * We might either write through the complete folio or a partial folio
+	 * writethrough might result in all blocks becoming non-dirty, so we need to
+	 * check and mark the folio clean if that is the case.
+	 */
+	fully_written = (off == 0 && len == folio_size(folio));
+	iomap_clear_range_dirty(folio, off, len);
+	if (fully_written ||
+	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
+		folio_clear_dirty_for_writethrough(folio);
+
+	folio_start_writeback(folio);
+}
+
+/**
+ * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
+ * @wt_ctx: writethrough context
+ * @iter: iomap iter holding mapping information
+ * @i: iov_iter for write
+ * @wt_ops: the fs callbacks needed for writethrough
+ *
+ * This function copies the user buffer to folio similar to usual buffered
+ * IO path, with the difference that we immediately issue the IO. For this we
+ * utilize IO submission and completion mechanism that is inspired by dio.
+ *
+ * Folio handling note: We might be writing through a partial folio so we need
+ * to be careful to not clear the folio dirty bit unless there are no dirty blocks
+ * in the folio after the writethrough.
+ */
+static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
+				   struct iomap_iter *iter, struct iov_iter *i,
+				   const struct iomap_writethrough_ops *wt_ops)
+
+{
+	ssize_t total_written = 0;
+	int status = 0;
+	struct address_space *mapping = iter->inode->i_mapping;
+	size_t chunk = mapping_max_folio_size(mapping);
+	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
+	unsigned int bs = i_blocksize(iter->inode);
+
+	/* copied over based on DIO handles these flags */
+	if (iter->iomap.type == IOMAP_UNWRITTEN)
+		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
+	if (iter->iomap.flags & IOMAP_F_SHARED)
+		wt_ctx->flags |= IOMAP_DIO_COW;
+
+	if (!(iter->flags & IOMAP_WRITETHROUGH))
+		return -EINVAL;
+
+	do {
+		struct folio *folio;
+		size_t offset;		/* Offset into folio */
+		u64 bytes;		/* Bytes to write to folio */
+		size_t copied;		/* Bytes copied from user */
+		u64 written;		/* Bytes have been written */
+		loff_t pos;
+		size_t off_aligned, len_aligned;
+
+		bytes = iov_iter_count(i);
+retry:
+		offset = iter->pos & (chunk - 1);
+		bytes = min(chunk - offset, bytes);
+		status = balance_dirty_pages_ratelimited_flags(mapping,
+							       bdp_flags);
+		if (unlikely(status))
+			break;
+
+		/*
+		 * If completions already occurred and reported errors, give up
+		 * now and don't bother submitting more bios.
+		 */
+		if (unlikely(data_race(wt_ctx->error))) {
+			wt_ctx->nr_bvecs = 0;
+			break;
+		}
+
+		if (bytes > iomap_length(iter))
+			bytes = iomap_length(iter);
+
+		/*
+		 * Bring in the user page that we'll copy from _first_.
+		 * Otherwise there's a nasty deadlock on copying from the
+		 * same page as we're writing to, without it being marked
+		 * up-to-date.
+		 *
+		 * For async buffered writes the assumption is that the user
+		 * page has already been faulted in. This can be optimized by
+		 * faulting the user page.
+		 */
+		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
+			status = -EFAULT;
+			break;
+		}
+
+		status = iomap_write_begin(iter, wt_ops->write_ops, &folio,
+					   &offset, &bytes);
+		if (unlikely(status)) {
+			iomap_write_failed(iter->inode, iter->pos, bytes);
+			break;
+		}
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
+
+		pos = iter->pos;
+
+		if (mapping_writably_mapped(mapping))
+			flush_dcache_folio(folio);
+
+		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
+		written = iomap_write_end(iter, bytes, copied, folio) ?
+			  copied : 0;
+
+		if (!written)
+			goto put_folio;
+
+		off_aligned = round_down(offset, bs);
+		len_aligned = round_up(offset + written, bs) - off_aligned;
+
+		iomap_folio_prepare_writethrough(folio, off_aligned,
+						 len_aligned);
+
+		if (!wt_ctx->nr_bvecs)
+			wt_ctx->bio_pos = round_down(pos, bs);
+
+		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
+			       len_aligned, off_aligned);
+		wt_ctx->nr_bvecs++;
+		wt_ctx->written += written;
+
+		if (pos + written > wt_ctx->new_i_size)
+			wt_ctx->new_i_size = pos + written;
+
+		if (wt_ctx->nr_bvecs == wt_ctx->max_bvecs)
+			iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops);
+
+put_folio:
+		__iomap_put_folio(iter, wt_ops->write_ops, written, folio);
+
+		cond_resched();
+		if (unlikely(written == 0)) {
+			iomap_write_failed(iter->inode, pos, bytes);
+			iov_iter_revert(i, copied);
+
+			if (chunk > PAGE_SIZE)
+				chunk /= 2;
+			if (copied) {
+				bytes = copied;
+				goto retry;
+			}
+		} else {
+			total_written += written;
+			iomap_iter_advance(iter, written);
+		}
+	} while (iov_iter_count(i) && iomap_length(iter));
+
+	if (wt_ctx->nr_bvecs)
+		iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops);
+
+	return total_written ? 0 : status;
+}
+
 static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		const struct iomap_write_ops *write_ops)
 {
@@ -1232,6 +1503,87 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
+				      const struct iomap_writethrough_ops *wt_ops,
+				      void *private)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= iocb->ki_pos,
+		.len		= iov_iter_count(i),
+		.flags		= IOMAP_WRITE | IOMAP_WRITETHROUGH,
+		.private	= private,
+	};
+	struct iomap_writethrough_ctx *wt_ctx;
+	unsigned int max_bvecs;
+	ssize_t ret;
+
+
+	/*
+	 * For now we don't support any other flag with WRITETHROUGH
+	 */
+	if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
+		return -EINVAL;
+	if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_DONTCACHE))
+		return -EINVAL;
+	if (iocb_is_dsync(iocb))
+		/* D_SYNC support not implemented yet */
+		return -EOPNOTSUPP;
+	if (!is_sync_kiocb(iocb))
+		/* aio support not implemented yet */
+		return -EOPNOTSUPP;
+
+	/*
+	 * +1 to max bvecs to account for unaligned write spanning multiple
+	 * folios
+	 */
+	max_bvecs = DIV_ROUND_UP(
+		iov_iter_count(i),
+		PAGE_SIZE << mapping_min_folio_order(inode->i_mapping)) + 1;
+
+	if (max_bvecs > BIO_MAX_VECS)
+		max_bvecs = BIO_MAX_VECS;
+	if (!max_bvecs)
+		max_bvecs = 1;
+
+	wt_ctx = kzalloc(struct_size(wt_ctx, bvec, max_bvecs), GFP_NOFS);
+	if (!wt_ctx)
+		return -ENOMEM;
+
+	wt_ctx->iocb = iocb;
+	wt_ctx->inode = inode;
+	wt_ctx->dops = wt_ops->dops;
+	wt_ctx->pos = iocb->ki_pos;
+	wt_ctx->new_i_size = i_size_read(inode);
+	wt_ctx->max_bvecs = max_bvecs;
+	atomic_set(&wt_ctx->ref, 1);
+	wt_ctx->waiter = current;
+
+	mapping_set_stable_writes(inode->i_mapping);
+
+	while ((ret = iomap_iter(&iter, wt_ops->ops)) > 0) {
+		WARN_ON(iter.iomap.type != IOMAP_UNWRITTEN &&
+			iter.iomap.type != IOMAP_MAPPED);
+		iter.status = iomap_writethrough_iter(wt_ctx, &iter, i, wt_ops);
+	}
+	if (ret < 0)
+		cmpxchg(&wt_ctx->error, 0, ret);
+
+	if (!atomic_dec_and_test(&wt_ctx->ref)) {
+		for (;;) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (!READ_ONCE(wt_ctx->waiter))
+				break;
+			blk_io_schedule();
+		}
+		__set_current_state(TASK_RUNNING);
+	}
+
+	return iomap_writethrough_complete(wt_ctx);
+}
+EXPORT_SYMBOL_GPL(iomap_file_writethrough_write);
+
 static void iomap_write_delalloc_ifs_punch(struct inode *inode,
 		struct folio *folio, loff_t start_byte, loff_t end_byte,
 		struct iomap *iomap, iomap_punch_t punch)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 547ce27fb741..2f95fd49472a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -344,6 +344,7 @@ struct readahead_control;
 #define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 #define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
 #define IOCB_NOSIGNAL		(__force int) RWF_NOSIGNAL
+#define IOCB_WRITETHROUGH	(__force int) RWF_WRITETHROUGH
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -1985,6 +1986,8 @@ struct file_operations {
 #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
 /* File system supports uncached read/write buffered IO */
 #define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
+/* File system supports write through buffered IO */
+#define FOP_WRITETHROUGH	((__force fop_flags_t)(1 << 8))
 
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
@@ -3434,6 +3437,10 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
 		if (IS_DAX(ki->ki_filp->f_mapping->host))
 			return -EOPNOTSUPP;
 	}
+	if (flags & RWF_WRITETHROUGH)
+		/* file system must support it */
+		if (!(ki->ki_filp->f_op->fop_flags & FOP_WRITETHROUGH))
+			return -EOPNOTSUPP;
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 531f9ebdeeae..661233aa009d 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -209,6 +209,7 @@ struct iomap_write_ops {
 #endif /* CONFIG_FS_DAX */
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
+#define IOMAP_WRITETHROUGH	(1 << 11)
 
 struct iomap_ops {
 	/*
@@ -475,6 +476,27 @@ struct iomap_writepage_ctx {
 	void			*wb_ctx;	/* pending writeback context */
 };
 
+struct iomap_writethrough_ctx {
+	struct kiocb		*iocb;
+	const struct iomap_dio_ops *dops;
+	struct inode		*inode;
+	loff_t			new_i_size;
+	loff_t			pos;
+	size_t			written;
+	atomic_t		ref;
+	unsigned int		flags;
+	int			error;
+
+	/* used during submission and for non-aio completion */
+	struct task_struct	*waiter;
+
+	loff_t			bio_pos;
+	unsigned int		nr_bvecs;
+	unsigned int		max_bvecs;
+	struct bio_vec		bvec[];
+
+};
+
 struct iomap_ioend *iomap_init_ioend(struct inode *inode, struct bio *bio,
 		loff_t file_offset, u16 ioend_flags);
 struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
@@ -599,6 +621,22 @@ struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 ssize_t iomap_dio_complete(struct iomap_dio *dio);
 void iomap_dio_bio_end_io(struct bio *bio);
 
+/*
+ * In writethrough, we copy user data to folio first and then send the folio
+ * to writeback via dio path. To achieve this, we need callbacks from iomap_ops,
+ * iomap_write_ops and iomap_dio_ops. This struct packs them together.
+ */
+struct iomap_writethrough_ops {
+	const struct iomap_ops *ops;
+	const struct iomap_write_ops *write_ops;
+	const struct iomap_dio_ops *dops;
+	int (*writethrough_submit)(struct inode *inode, struct iomap *iomap,
+				   loff_t offset, u64 len);
+};
+ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
+				      const struct iomap_writethrough_ops *wt_ops,
+				      void *private);
+
 #ifdef CONFIG_SWAP
 struct file;
 struct swap_info_struct;
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..192a00422bc8 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1260,6 +1260,7 @@ static inline void folio_cancel_dirty(struct folio *folio)
 		__folio_cancel_dirty(folio);
 }
 bool folio_clear_dirty_for_io(struct folio *folio);
+bool folio_clear_dirty_for_writethrough(struct folio *folio);
 bool clear_page_dirty_for_io(struct page *page);
 void folio_invalidate(struct folio *folio, size_t offset, size_t length);
 bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 70b2b661f42c..dec78041b0cf 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -435,10 +435,13 @@ typedef int __bitwise __kernel_rwf_t;
 /* prevent pipe and socket writes from raising SIGPIPE */
 #define RWF_NOSIGNAL	((__force __kernel_rwf_t)0x00000100)
 
+/* buffered IO that is asynchronously written through to disk after write */
+#define RWF_WRITETHROUGH	((__force __kernel_rwf_t)0x00000200)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
-			 RWF_DONTCACHE | RWF_NOSIGNAL)
+			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_WRITETHROUGH)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2f0c6916213d..20561d3d5eaa 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2918,6 +2918,12 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
+bool folio_clear_dirty_for_writethrough(struct folio *folio)
+{
+	return __folio_clear_dirty_for_io(folio, false);
+}
+EXPORT_SYMBOL(folio_clear_dirty_for_writethrough);
+
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
 {
 	atomic_inc(&wb->writeback_inodes);
-- 
2.53.0


