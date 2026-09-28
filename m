Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6FDCA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4166B00A4; Mon, 28 Sep 2026 08:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB036B00A6; Mon, 28 Sep 2026 08:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4446B00A4; Mon, 28 Sep 2026 08:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4756B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A137A5052
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:39 +0000 (UTC)
X-FDA: 85263039078.07.C54E7F1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id AE4EA140002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LXyvN8Es;
	spf=pass (imf26.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVyWmwVlpvaOrGAyGs2urlT4o0bYqqCn1lBB3S2/vtA=;
	b=GWQqtH6q0CjATRyYUinMB0W1I1EOgXE8nbbF/LFWiI5saTn+eCJzCXPoUvrNm92Eo7PWVa
	pca7D1UabzK1kksQoCg/HSSDebyu/cj38UU9bv4m9Iz6pGzfLZmAp6NQY7uvyyR+rxu+Q5
	S7P8Lx1Pwn0jNzcRN6sJig0HPSnOe0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597076;
	b=j53hpZ4RINr9olTnSpWoDJFhUW3Yro3YG3hzEtEqNw09F5T/5hCQJic/eT332h9QMLMRM8
	gxuj3YLJ2gv5y1cCQZ08mOtcA9Sz9n0QtERIQ4NZLoOYNhGZ6IK+/y5E7OSj41HMiDGd2l
	O++Tj+flxh34/woSUzba53lv/od3VBA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LXyvN8Es;
	spf=pass (imf26.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZWSC3375009;
	Mon, 28 Sep 2026 12:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CVyWmwVlpvaOrGAyG
	s2urlT4o0bYqqCn1lBB3S2/vtA=; b=LXyvN8EsrFateR/Ny0TptTOi9NEIciJtm
	sjU1PFIGyAnQV+c9IRtl0+i9pjH+Sv1yOtgRup/uh+d26bye/Ons8tuOkJSZOrk4
	dGfWA8G/OASFJ1gTUTZ23zM8bwZpPOBMKJsUSJiwMQsNezblSkxadFFi6RFxf/aI
	C3fA2NUSpPC3WIapxXBmYt4QqPLctcy3Wo06cj+1WTuX5yIAMvA+hQFImpHTgdnj
	8t6D4hOuYXsBevEuBprF98v3q1Pwb60cb4kIyYJ39ev66uXKhdu7pBGLAV8Kjour
	tAfm/rX1ktOxzXgrrOsT5Xs+3zt4ARGyNN5V+Qiv5tLZi84BIEC4g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qr13qf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHV5h017596;
	Mon, 28 Sep 2026 12:04:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsck53bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC4LFY25428690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:04:21 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 735E92004B;
	Mon, 28 Sep 2026 12:04:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AECA020040;
	Mon, 28 Sep 2026 12:04:16 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:04:16 +0000 (GMT)
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
Subject: [RFC PATCH v4 11/12] iomap: Avoid folio dirtying in case of RWF_WRITETHROUGH
Date: Mon, 28 Sep 2026 17:33:12 +0530
Message-ID: <fef1d0bed959b49ad0a4b5b34dfeb0c5be9040b3.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX8NC2pKScIkaQ
 Q5YiHjjehrowPlzxrm7vHMrdw2muokuuWGBJHNnSZO9ik6w5f6sBzdm0P9k2GjRFPnKhCukB3D6
 HU4kEkZiroGiDx+E2R814vyASuL1qh2voJHa5m7IIq2lhm/botqjpDURCsQWcGC/kC57h2zMjAB
 S9NziybRI0tR8Pq4PPKm6Hn0ntLslBgyuE+eAhRASFOB/aFlDEqTH6fNcwbwNaY2TAz0sq4y9nJ
 K8HVl9krlv0BVvsJLfFmDWF+bMdj5XrgjfAsq5S3+s4PxyymtNjZ+xBRr6n5+feNDS6ZjZprzi+
 iztuE2+iydGLggmrejguLro2B7d5IHquGL5b7Y+mhYHhnExATSmhWSSR1pDixfJ1GYgC2UtDosm
 VkRimXmirDkqM+iWGVuBCB2+DHuIA2lexmY+IXzrbiYZa4+f4YbQa8t4yZ68JAIZ03kPHlp41uV
 qAmuGHq6aoyytPRd7eQ==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6aba57c9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=0PHH8OhPgAe37TY-rOQA:9
X-Proofpoint-ORIG-GUID: WkZDsv69czc19LhsLDPSjbmLysW3h9eZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX7qzqaA6mMOCd
 kBNDfQClSlWRM56FPDqKyLRw0BgykPeKfF7ZyDVkl6NHU8xSV9zXQu+roP4dx7bpL8omhp4TG6N
 v76ZOn5LA7Fkp3a5WeBuR1LuDw/svkE=
X-Proofpoint-GUID: YDVoEUWdHxuMNytDUE75ZTESkgoNZXOK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046
X-Rspam-User: 
X-Stat-Signature: y9ud5nh3hk96cxdfztgt7giefe3myawj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AE4EA140002
X-HE-Tag: 1790597076-246587
X-HE-Meta: U2FsdGVkX1+odZtE5SQLisqUq5KCPQZX+DW5agTh890uIji7R8lnghl7H2LT0w0nYtPrEKSU6UN8nxAhnDd4JqGHeMOtNhMHbPmCmbG4EWD74nj/u67ynhQSPVRCJ2kH6zV0EvSgw6xpeQwDrQZvNs68XzMESUzv1E7Gji1BlBbFXWysAgfuebrMdL4Q2Yj8sEe0Bg9tJM2MSfXQpdlGVmSBVYMbAqNrWE+VJujwSx3N6BmIBH1OlPKzlNvNiGCc04DMNNOug4CE3wQEkt5qW8RHX0jGnvQGTEdqxU8my+sMidSdLfxWiW5lbD4vSx/CgPxGQxmU8J5dI3rX5WUOSI07uFXRkWHa+PhLt6n58YIZYEmFtCtjHCnvPK+mAttOXA+34J0X1jeRSqcFi3pJ5tdeKhFeKVrG1MD/xKftOi0J1fgsWaGkcBqK91VZXeAwzxRTiBve1vH+jY08lARmkPIgtRy5VP2CYJ/2nS/tM1nPNYs6M179sJnwl5eqVxTMf6aeUdXniZSsOX02rzhXDCtzG+vl9yRPe7SYaY/xdHm/4PB01GiS+8s65hih4tiSbtJFibWZJ+Rdc8b4Z8it0NGRDRRdvgEpSr8GkkvqParxlyx2htTWCQQcDc4zs/5j5ViPPzGcfbc4RLimlGqTdte83FIn0MZPbEdbARdNTPbhF+ZejevQyoolvwZMtVxJdx1bkGtba6Lzi36sPmBvM72Tp6jDc8yI1Hsnu/ThBlItfcf/F4ajrDyrE9PPgHlwfPypWwklj+ipvtfgV4dyrK/sYyWqX1KUyqynjkstfQi5XDd8te5zyggoALB36AFHITZzadkjdSdQyMSu67K3x0Ds7oSZWS1oxKnnk7/662Aln/X2AJyBmnqNrpsNLB/0bU4t+SmAEIEGtSeWhWiV/nW6i2Qkaigzq4ImCpJtY3c0u1ENslaqvc7W9m0Ry2BojiHI2vkvzFoLyjDNz0V
 mUZcR93G
 X8RtmMGuMOWzatYMl5U00ZDSsUJqNbp1fNmAGUkLDCWOzinAjm6RYqddD9oL6td9GIIIq533vkGs4nftssf9+PtN41kIxVPGgRQ5u/NQKn0a2crgqBZhIHTGH43UFw5KloMGe9czCLEKWK36jknKgNTMVdx6WTWBaYp/Tt+IN8oc25L96T81zs3ybTJ9xRTyJP49tSQlODWMC4G2vndnoXVjv17ps9dICoXhZ/t5BXKKbssrwi23gtEKofx87S0/niXlFwtHdUaMt8+IxW3o5dPSsXugTMGbwEmJOk9LPSJmunZzZk3TwU8SWABiJxpNzRIhBprR1cek5s0eJ+Pe0rgCBoEJS5Z7D+UsX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RWF_WRITETHROUGH dirties the folio only to send it for IO immediately,
in the same context. Due to this, we can optimize away the folio
dirtying and clearing step usually seen in buffered IO. Althrough we can
do away with most of the accounting there are a couple of counters we
need to take care of which we do during IO submission/completion.

Further, now folio_start/end_writeback() can find an inode with no wb
attached and hence ensure its not null before using it.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c | 75 ++++++++++++++++++++++++++++++++++++------
 mm/page-writeback.c    | 24 +++++++++++---
 2 files changed, 84 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 91dad3550398..84310c786abf 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -11,6 +11,7 @@
 #include <linux/fserror.h>
 #include <linux/fsverity.h>
 #include <linux/rmap.h>
+#include <linux/task_io_accounting_ops.h>
 #include "internal.h"
 #include "trace.h"
 
@@ -1162,6 +1163,34 @@ static bool iomap_write_end_inline(const struct iomap_iter *iter,
 	return true;
 }
 
+/*
+ * __iomap_writethrough_end() is almost same as __iomap_write_end() but with the difference
+ * that we don't mark folio dirty since we are about to issue it for IO anyways.
+ * Consequently, most of the accounting is skipped.
+ */
+static bool __iomap_writethrough_end(struct inode *inode, loff_t pos, size_t len,
+		size_t copied, struct folio *folio)
+{
+	flush_dcache_folio(folio);
+
+	/*
+	 * The blocks that were entirely written will now be up-to-date, so we
+	 * don't have to worry about a read_folio reading them and overwriting a
+	 * partial write.  However, if we've encountered a short write and only
+	 * partially written into a block, it will not be marked up-to-date, so a
+	 * read_folio might come in and destroy our partial write.
+	 *
+	 * Do the simplest thing and just treat any short write to a
+	 * non-uptodate page as a zero-length write, and force the caller to
+	 * redo the whole thing.
+	 */
+	if (unlikely(copied < len && !folio_test_uptodate(folio)))
+		return false;
+	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
+	return true;
+}
+
+
 /*
  * Returns true if all copied bytes have been written to the pagecache,
  * otherwise return false.
@@ -1183,7 +1212,10 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 		return bh_written == copied;
 	}
 
-	return __iomap_write_end(iter->inode, pos, len, copied, folio);
+	if (iter->flags & IOMAP_WRITETHROUGH)
+		return __iomap_writethrough_end(iter->inode, pos, len, copied, folio);
+	else
+		return __iomap_write_end(iter->inode, pos, len, copied, folio);
 }
 
 static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
@@ -1302,9 +1334,11 @@ iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
 
 	/*
 	 * In case of error we still need the I/O completion to run so we can
-	 * release references and end writeback on the folios.
+	 * release references, handle accounting and end writeback on the
+	 * folios.
 	 */
 	if (error) {
+		task_io_account_cancelled_write(len);
 		bio->bi_status = errno_to_blk_status(error);
 		bio_endio(bio);
 		return error;
@@ -1352,8 +1386,10 @@ iomap_writethrough_try_submit(struct iomap_writethrough_ctx *wt_ctx,
 static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
 					     size_t len)
 {
-	bool fully_written;
+	bool needs_cleardirty = false, fully_written = false;
 	u64 zero = 0;
+	u64 tmp_off = off;
+	struct iomap_folio_state *ifs = folio->private;
 
 	if (folio_test_writeback(folio))
 		folio_wait_writeback(folio);
@@ -1362,16 +1398,35 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
 		folio_mark_dirty(folio);
 
 	/*
-	 * We might either write through the complete folio or a partial folio
-	 * writethrough might result in all blocks becoming non-dirty, so we need to
-	 * check and mark the folio clean if that is the case.
+	 * For writethrough, we don't mark the write range dirty but we still
+	 * need clear the dirty range if someone else has dirtied it before.
+	 * Further, if the clearing results in folio becoming completely clean,
+	 * then we need to take care of accounting. If we have ifs, we can
+	 * simply use that to ensure this. If we don't have ifs, that implies we
+	 * did a complete overwrite of the folio, in which case we can just
+	 * check if the folio was dirty earlier
 	 */
 	fully_written = (off == 0 && len == folio_size(folio));
-	iomap_clear_range_dirty(folio, off, len);
-	if (fully_written ||
-	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
-		folio_clear_dirty_for_writethrough(folio);
+	if (ifs) {
+		if (iomap_find_dirty_range(folio, &tmp_off, tmp_off + len)) {
+			iomap_clear_range_dirty(folio, off, len);
+
+			/*
+			 * iomap_find_dirty_range() only works for folios with ifs
+			 */
+			if (!iomap_find_dirty_range(folio, &zero,
+						    folio_size(folio)))
+				needs_cleardirty = true;
+		}
+	} else {
+		WARN_ON(!fully_written);
+		if (folio_test_dirty(folio))
+			needs_cleardirty = true;
+	}
 
+	if (needs_cleardirty)
+		folio_clear_dirty_for_writethrough(folio);
+	task_io_account_write(len);
 	folio_start_writeback(folio);
 }
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 098aa472d368..3ca54716d08e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2986,11 +2986,18 @@ bool __folio_end_writeback(struct folio *folio)
 		__xa_clear_mark(&mapping->i_pages, folio->index,
 					PAGECACHE_TAG_WRITEBACK);
 
+		/*
+		 * With RWF_WRITETHROUGH, we might not have a writeback
+		 * associated with the inode
+		 */
 		wb = inode_to_wb(inode);
-		wb_stat_mod(wb, WB_WRITEBACK, -nr);
-		__wb_writeout_add(wb, nr);
+		if (wb) {
+			wb_stat_mod(wb, WB_WRITEBACK, -nr);
+			__wb_writeout_add(wb, nr);
+		}
 		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
-			wb_inode_writeback_end(wb);
+			if (wb)
+				wb_inode_writeback_end(wb);
 			if (mapping->host)
 				sb_clear_inode_writeback(mapping->host);
 		}
@@ -3030,10 +3037,17 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 		on_wblist = mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
 
 		xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
+
+		/*
+		 * With RWF_WRITETHROUGH, we might not have a writeback
+		 * associated with the inode
+		 */
 		wb = inode_to_wb(inode);
-		wb_stat_mod(wb, WB_WRITEBACK, nr);
+		if (wb)
+			wb_stat_mod(wb, WB_WRITEBACK, nr);
 		if (!on_wblist) {
-			wb_inode_writeback_start(wb);
+			if (wb)
+				wb_inode_writeback_start(wb);
 			/*
 			 * We can come through here when swapping anonymous
 			 * folios, so we don't necessarily have an inode to
-- 
2.55.0


