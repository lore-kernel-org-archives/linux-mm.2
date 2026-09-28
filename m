Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD357C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B206B00A6; Mon, 28 Sep 2026 08:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33636B00A7; Mon, 28 Sep 2026 08:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21596B00A9; Mon, 28 Sep 2026 08:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94D206B00A6
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 804E3801AA
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:44 +0000 (UTC)
X-FDA: 85263039288.03.4C7E182
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E3D11A0006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gmimemSg;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyqRC5kNYPHLFH0XB9ILyvhfxANaac/7S+L5g37NXRs=;
	b=Ga26PuaEsf0PViHspSIv52sU4r/nyuM1I0J4aQtzWA4cllTq5/+SyZOqq8hOhPAUzWL1yC
	vXhPlji92UXvUiywqIc1S9WsITubQFCzYNKOpoJ5hSF5w2OyNtOi2b6nrSrCq6cisk16o1
	MGPJFiqjqKBu6PnB55kP44YRA1ZESFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597082;
	b=jz2JPiByX3BfKGfIFDUEXiJ1e7XnCqXQ1k9M5j34gwlREL6U3bf7QRZQTkhE6Ek5zQavu9
	L7fU9Rq2T+A/vUUJeVFCuWz+E2lSaHaU750bbgviuis4n7Xr1+uXioaPjaioVEoyyMAOLs
	cFtQN6QR66zm7kL1HVYKyvMbGbJQnB0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gmimemSg;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZUMD3374975;
	Mon, 28 Sep 2026 12:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HyqRC5kNYPHLFH0XB
	9ILyvhfxANaac/7S+L5g37NXRs=; b=gmimemSgi6izGKsEGhuRZuFhMoZpFU8Y1
	cz7FTIrJ1axei6FHj7vS1lAHNJb9ARiFBZ+iKNWhHHu8OWk56f83suRHNj4m8Et4
	zp8b2FSNlojW/hdUNRoS++PGVXNwskukavGy+I/DObsCTgTA2eAJH8uzLhNLBF++
	Nb/Wj/mLlOEs8hqN57QbH7pHtnyUPgfTb3XzgPcNRt0gbrhK0HTgKoYtsjVNQFWG
	2nf8CugCKc4MetC5CjWpf3PHzldoD4I0sSNfIvPQxAgwpAiKwOi8sDLF24JJivBM
	xe16KKCGPJ6EYuHSB/jBVxful92O/wUjBn57KtLSTaIUKvbdRRTiw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qr13qv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHZ7v017859;
	Mon, 28 Sep 2026 12:04:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsck53ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC4R3048497076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:04:27 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAB9E20040;
	Mon, 28 Sep 2026 12:04:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1064B2004B;
	Mon, 28 Sep 2026 12:04:22 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:04:21 +0000 (GMT)
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
Subject: [RFC PATCH v4 12/12] iomap: Handle deadlock due to repeating folios in RWF_WRITETHROUGH
Date: Mon, 28 Sep 2026 17:33:13 +0530
Message-ID: <5159efdec832e8179e9f689a9292f9bf47d9a0fa.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX7Hcy8199FWcD
 0qaEI4Pt0WKqZGNR4/xT9/mooZCocDeTVa5b7ALw9ZXL2Tchp3aIXoJqDxsPAGnVxeh+NEH8h/D
 tayLkfAH4CHYZH7rj3NPyxUAMtdTnxrcTHFnDTgz52KIkaJFr4IPKef72qMfeNZd6CSBrb4tfQI
 C9NuPWMRRezuRxGadgnjBI+a1oMVwqmNHY3ads/6XLpLQXmPTdkoDRsSnmtyRukeX6QnkS1Dn4m
 MGB+Sf+WOyR2v46vh24Zb3OdIaQoj7u/n5Prxe7MY+q3Tt1XNDLOs2batgDuTPoOGPajHE5WUPO
 AOF4KfXzzN4U6ivoC38YjtFBsQhegkHTFEDXJjjxrPyVhzr8x4dDpussSmfXiJ0STbjA8FDPrQ5
 tnHauyo4QitRr3l5OQnAefV8UnEfi7hd3JEE5hWRjm+kT+JzAhoS3Uv18l1vmcNCY5A17NK7Ydv
 uweOQ++qTPz6oBRJ+yQ==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6aba57ce cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=2R8uCszOOhyw9zs8MNsA:9
X-Proofpoint-ORIG-GUID: v_Yf_jfO8hs8Ihbv_vveFTT_qaKOJQzh
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX/e92be43pWDg
 pKwrP9OSbecgL3vUWLIwzUPXqXs4TnTtuOmuXIEZbU9rcEx7QpRKoJUUxq51R4VatcCIhTd/q8J
 qprxXlT9VxMWZCvkdIsbdhkwJgQ3YW8=
X-Proofpoint-GUID: M937-kT0jqlXg7gmv9modnbyxNGxqvUV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E3D11A0006
X-Stat-Signature: f7nak6t377jhuezfqtywhe4sjjf97cd8
X-Rspam-User: 
X-HE-Tag: 1790597081-780048
X-HE-Meta: U2FsdGVkX1/9vMeMUNQec2tiNnued+QJ4sTTQL1dXaUovL4et7D2M659M3F9B2sk7NOAr3CpyxYt95T9iebsV2MmYl3uyJ+OztlY7PKSnNY7YV5rnJhQ30QtFZlBTjeD2p1+KZT7NGCyUt9CJqFwlFpd4AmCC2lLZYOn28t1C/qu8Jl9M8M2TJgLUxNJUGuZxfE2TypSWLewr1bZ3NsMettDEPFBlRQahVNztpoGULFMkhWvz++SPO8M/KKoF6MRjpmloKWPJ8UXNaLtb6TV7JmzbhPlOKgWSSdcCyQYEuhIgYCGMNoxZ1v/vRXotKV2mT8SFr+GzE4xjexH9u4Sp8LGeMIeF/firIB/7D50t+NNr7IX3EdeXq28ZjdrbYLhpuLiDCcoth43kFD3fynSAwTuQm2hL8hVkAb9TKC5k1lGt5bMeXBlYrZarO/9ksucoKJjdv8J4x6XEH6yemyxNBdApJWiPZ1bqr8+g78ys/LvA3LnymLQOnJpxenQx6Bcf1Yk8fsVaaxJ08UBx2+NMbGJWwFhCbBRvh7qnsUKMDjGptm1eKgJE7FBiAnrmMYkJPtg0Kp2IqI4j8AdAiWg7kDO0LG+SZQJwGcAXjoZAJAUiR+pIrqa1T9aiva+cD7QlmxYeI8K7RjjNJ9G7HZ8X5mFHrYNODgPhj5Kg91SPPgZUGatA2JDKBclsolvMgFMpa0FVglNQ1aUVAsCIW9GJZGDUu4yiO0w1hoK47jDTw4BIdMaadaGw58ashjN1kmeJ1I9kBfpkFRc5pFNkQYWQUqu/mZHv3MniLwXa5m2kMoI7i9AMNbfAvGOK38ojDo1nvSjf1hKXj2LF1zgasiLitUr/re8vfxaXFN/aXYRft6mARmJ2LvncYfnPwrjqyH9I0tfmSlrlIgRd+Cp1Ze3W2sY0Bn7oGZPbD/VIYai7JOVuKzw7XZWuukz13/kbBHpbCiM1jN0LbQB3/0SANE
 3HRori5e
 kupuVMhSEjzXAurQa6uZJXdGPegG64nhqyCzI7FAfYc6lf+7NBCWHQXQK6AmHvYz3TOrQsXMxXsieMN9O0Wz7qT3k7t78VleQQOT+d8m0SIk7fu5xZZVU/5rKXybIgOIHobI/SCmyxvep3RxHSgpiWg8laKo+9MiXaFuJN/B7Vb9KW+f9pmbcxbb7lu7DB+nxUgywt/E5Igh+m4wW7aUt3ACYrmLV7nHw2auUcGP9gdBZ3ld+i09s2hXja+qwW1j12rzBFwzHX1GnNHPhIKGqQLKreY4vSgJXETRw297HKfBXfRQ0hsu+bOZGJerO7MtPpJWqydRboACWxNy06mmg3sZMDO3lwq/R6ljh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In iomap_writethrough_iter() we might encounter repeating folios across
multiple iterations. Repeating folios can occur if, example,
copy_folio_from_iter_atomic() does a short copy due to userspace pages
not faulted in. This is an issue because a previous loop might have
started writeback on them but not yet issued the IO. In the next
iteration trying to get the same folio with FGP_STABLE will result in a
deadlock. Since repeating folios will always be encountered back to
back, we can just use a simple cur != prev check to detect them.

Use this to avoid waiting for writeback or starting writeback on folios
we have already processed. Note that in ->endio() we might end up
calling folio_end_writethrough() twice on the same folio which can cause
issues with folio_xor_flags_has_waiters(). For simplicity, just change
the folio_xor_flags_has_waiters() call to an idempotent variant.

Reported-by: Pankaj Raghav <pankaj.raghav@linux.dev>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c | 46 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 84310c786abf..69a2eccff26a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -802,6 +802,13 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 {
 	fgf_t fgp = FGP_WRITEBEGIN;
 
+	/*
+	 * For writethrough, we open code the FGP_STABLE logic directly in
+	 * iomap_writhrethrough_iter() so disable it here.. See
+	 * iomap_writethrough_iter() for details.
+	 */
+	if (iter->flags & IOMAP_WRITETHROUGH)
+		fgp &= ~FGP_STABLE;
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
 	if (iter->flags & IOMAP_DONTCACHE)
@@ -1284,12 +1291,16 @@ static void iomap_writethrough_bio_end_io(struct bio *bio)
 {
 	struct iomap_writethrough_ctx *wt_ctx = bio->bi_private;
 	struct folio_iter fi;
+	struct folio *prev_folio = NULL;
 
 	if (bio->bi_status)
 		cmpxchg(&wt_ctx->error, 0,
 			blk_status_to_errno(bio->bi_status));
-	bio_for_each_folio_all(fi, bio)
-		folio_end_writeback(fi.folio);
+	bio_for_each_folio_all(fi, bio) {
+		if (fi.folio != prev_folio)
+			folio_end_writeback(fi.folio);
+		prev_folio = fi.folio;
+	}
 
 	bio_put(bio);
 	if (atomic_dec_and_test(&wt_ctx->ref))
@@ -1384,16 +1395,13 @@ iomap_writethrough_try_submit(struct iomap_writethrough_ctx *wt_ctx,
  * need to clear the master dirty bit.
  */
 static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
-					     size_t len)
+					     size_t len, bool already_prepared)
 {
 	bool needs_cleardirty = false, fully_written = false;
 	u64 zero = 0;
 	u64 tmp_off = off;
 	struct iomap_folio_state *ifs = folio->private;
 
-	if (folio_test_writeback(folio))
-		folio_wait_writeback(folio);
-
 	if (folio_mkclean(folio))
 		folio_mark_dirty(folio);
 
@@ -1427,7 +1435,8 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
 	if (needs_cleardirty)
 		folio_clear_dirty_for_writethrough(folio);
 	task_io_account_write(len);
-	folio_start_writeback(folio);
+	if (!already_prepared)
+		folio_start_writeback(folio);
 }
 
 /**
@@ -1444,6 +1453,17 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
  * Folio handling note: We might be writing through a partial folio so we need
  * to be careful to not clear the folio dirty bit unless there are no dirty blocks
  * in the folio after the writethrough.
+ *
+ * **A corner case to be careful about**
+ *
+ * For writethrough, we open code the stable write behavior to handle the case
+ * where we encounter a folio that we already started writeback on but have not
+ * yet submitted. In that case we must not wait for writeback again to avoid
+ * deadlocking. Repeating folios can occur if, example,
+ * copy_folio_from_iter_atomic() does a short copy due to userspace pages not
+ * faulted in. Also, repeating folios will always be encountered back to back so
+ * we can just use a simple cur != prev check to detect them.
+
  */
 static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 				   struct iomap_iter *iter, struct iov_iter *i,
@@ -1457,6 +1477,7 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 	size_t chunk = mapping_max_folio_size(mapping);
 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
 	unsigned int bs = i_blocksize(iter->inode);
+	struct folio *prev_folio = NULL;
 
 	/* copied over based on how DIO handles these flags */
 	if (iter->iomap.type == IOMAP_UNWRITTEN)
@@ -1547,6 +1568,10 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_folio(folio);
 
+		 /* Open coding stable write behavior, see comment on top. */
+		if (prev_folio != folio)
+			folio_wait_writeback(folio);
+
 		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
 		written = iomap_write_end(iter, bytes, copied, folio) ?
 			  copied : 0;
@@ -1584,7 +1609,10 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 		prev_len = len_aligned;
 
 		iomap_folio_prepare_writethrough(folio, off_aligned,
-						 len_aligned);
+						 len_aligned,
+						 prev_folio == folio);
+
+		prev_folio = folio;
 
 		if (!wt_ctx->nr_bvecs) {
 			wt_ctx->bio_pos = round_down(pos, bs);
@@ -1629,6 +1657,8 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 					&iter->iomap, wt_ops, &pending);
 			if (status)
 				goto submit_failed;
+
+			prev_folio = NULL;
 		}
 
 	} while (iov_iter_count(i) && iomap_length(iter));
-- 
2.55.0


