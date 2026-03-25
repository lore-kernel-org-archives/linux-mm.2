Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E35E109C05D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B60C6B008C; Wed, 25 Mar 2026 15:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865826B0092; Wed, 25 Mar 2026 15:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7077E6B0093; Wed, 25 Mar 2026 15:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2686B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 280BD1A08C9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:30:47 +0000 (UTC)
X-FDA: 84585577734.17.5524C0B
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF0FFC0011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:30:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="ea/7FaAK";
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774467044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7NOoLpQC1gt8jjGEOFARMhStqFULmtQPTxyzd8Tw9E=;
	b=lVZkEtxbke96REVYqsoW/gmywOroIzETedCloSMnsTreCTLQFBpzmLnh1lDeoW4e76QVXh
	ip0WR7nNkGcwy39MMCsVjBo7uJnO8cx6m4NEzanK2+SdgUlkq7DUbHcYqg1OESyPNS9wgz
	KpV1nTuC9/CMq9S5rTemyLHQnsrYA7g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="ea/7FaAK";
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774467044; a=rsa-sha256;
	cv=none;
	b=rCRMD34HDJqTL0BRL5fc5AY5AcUAbajGucxH2P31oaZrofxVa+tib7saVmTGDfH5p4270L
	G69CYhUYTxW6sZrSmY+ptKFBY2zIendfVUcZtpzAEOVw/YYU/Wku+emyTm/WVFKDpZtHbT
	HmePiUFob7E40JUD7Pe7L8t4X+nT/uU=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PJSkHJ477838
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=S7NO
	oLpQC1gt8jjGEOFARMhStqFULmtQPTxyzd8Tw9E=; b=ea/7FaAK8Ey0iHDLieZh
	JaXjXfGGE2bKSByCc9yYFObbNVPoP9alZW0vtMBixLqg5f32Dju0WDS6uTXT3eXy
	qvYw4/FrDejFY13IpjVYI3moVgbwSjYbbxC5UOLGkUlH2FoRntN4o/kTvxSGxFp9
	DE9S+soik1w0p5Wq4ot6+xmq0LkOsfACEmrT6/HIlrPe9nRH+wPx8PC53LpHHlDV
	vvUbRI3Z6LpVVzSc5+/kTomyKfTNMxPZnUoywlz8boe8S/yS7/b1g/+omNpa2ILc
	4BOgd3nQElfvurH4Eh1YjcEnvJl8NRR6ahsvFYdr3OJY6rSSBvWWoPSRyUx9wQhl
	Iw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d42nnq9st-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:43 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5091782ab06so12829861cf.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:30:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774467043; x=1775071843;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S7NOoLpQC1gt8jjGEOFARMhStqFULmtQPTxyzd8Tw9E=;
        b=feeEiAMhPCjDlnQopyGhbp3yNjHBrvf/NN9Tqb4bfMnSIj6EXlIMMz0ucJTsu1RV7s
         bHiVXq8cOQi9uexFo37qv1g8ADi6I6mg9oOuGsQA+kgRHN4keck+7cx6I2tF3x4rypfh
         0qZvW3mQ3zAiRGrrqn76WoWqCq3r/5/+mw9Je9bfEWX5qhwxNat5LeFxsGIPo9HrkyJO
         ewMuXxl7u/AiADHC4xJwPJXBEWPVUhx2uD8uU/svbMg3tUH0yrJqbGfCqlfOjQc4COCN
         ktG8Dq/gc3lk8R0ZhrOropHh6BaI0JzwU6bcO773RP17aBgliotcrAJ97gNrPY5gUptj
         37jw==
X-Forwarded-Encrypted: i=1; AJvYcCXyedMmRvBYSx1BtRdqnPgxXKjz3UdeOVNvjWt+puUYwDofXF7xnJ1O2hG5mGgWUMutV8VIlVtCog==@kvack.org
X-Gm-Message-State: AOJu0YwHaLegezahRKs0Lm0BCGSF7ulegcGLpnRLSqrTtn27cvNu0z0e
	OO8sv7TdvgKkDk+1Re8KxyuwrDNds+TP/d90iqeLmIHiwbvs1pPjHQM+an+zsTYp098h9KLlaXo
	gKOmRt6FexFSLIt+/rlwtlDS/e0vefpv7+Qnlu9s2x1hh3O9Y
X-Gm-Gg: ATEYQzwyQ6ZBq+2Tb5mYgclmhLTb9uVWBxQpHIx/Lkd5ojMQuY6pQiF7GuCqR1L69bJ
	uWk5WaW4WHf6z3IqXlur4sRu1MSrYlbD6j0pFZIdC5xrIU0YZUbBKPDunBcZsxkapcxhPsmh98m
	/KpXA9VQ4fLWZoCkBUw+vvlpVh6j0uaZUReEFIKXPnggL84wHd56qQb5o/6ic0mTvvXr/b6YPKX
	eXg6mdmtgaaDbOnapMZdWdCDO2BVDNiVA0AFXeNV2MiW9XTRSFJNhYSxYvPt4C2OJJaejhiLjON
	9GHffLfrvhxwzDzCCflHClL9DbAO/poGnNcbeXygPxrVS5idDwM/z+WViKv6zhT9f5XSEJ+Ksjm
	FfxUwJu/NY1QEFUpX9vekSw5sgpN8S2D//FTOZQ==
X-Received: by 2002:a05:622a:4d4d:b0:509:23c5:328f with SMTP id d75a77b69052e-50b80e66e14mr71159871cf.54.1774467042894;
        Wed, 25 Mar 2026 12:30:42 -0700 (PDT)
X-Received: by 2002:a05:622a:4d4d:b0:509:23c5:328f with SMTP id d75a77b69052e-50b80e66e14mr71159101cf.54.1774467042206;
        Wed, 25 Mar 2026 12:30:42 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.226.199])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9234e3a3sm5534221cf.19.2026.03.25.12.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 12:30:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Mar 2026 14:43:02 -0400
Subject: [PATCH RFC v4 3/3] block: enable RWF_DONTCACHE for block devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-blk-dontcache-v4-3-c4b56db43f64@columbia.edu>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
In-Reply-To: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774464193; l=4833;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=vqYjVe4t0i/AiFArpSZ9mEXLlU4rnE2ZRBBMSnozEZ0=;
 b=gpmN0bZuDH/LOZGTVX2LWTAbwaNFAVtx+0hCaa/06cmF7hrJjYYHDM3SkZtVNTBPzJKHCu1Ro
 uxYVg0q9qKMB8UfKgMIhJOiUIQQkEPxysztQm+QmC6XaBib3Uj2eKTq
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 7sYZl1J7XwvtrMWTgtXWi1tK-NqqqOot
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MiBTYWx0ZWRfX7QW5NSGluev7
 mvHcLGtLOhudy+xtvzYJ+staI9BSoNrTep+fgReyDIc2rRLupb9TjEanTxBJVPlnIVf4vbVrQ0Z
 je1RMOYCKYhenRfyqdc/66cONm1jvswcDmuZq1Ng1WNQGxD2qnfwvpS3rJQtnULcNV0QOMFVv/W
 gxBx8MNrz1YFK8QC55btQuAjte8/iAdqokL67xEbslMl2TSruNlE9M8Xrjc7xv74C6ISlKiBJlE
 GFTkhJNFAVlspTaIOu8BlJzMIL+eHAbJ8l3Itmywi+qsqL2xD9x0IkPmSuCwQmd8VIvHMY/H+fp
 /W3Yu7ILlTLJBKiqtMA4wCVEIe94plmX51MCq3Pp4XVwSbvaESkUD++H5VsB98+QmaebHrcf1mR
 eg9QqLmZTM1zHYCetV+FhG2zrog4Jqui3OC70auaK/m5z6q4/gb4oszJPQlODF7wnsgAYAJuZpO
 kqm7/TLfcmz6Tr+tFWA==
X-Authority-Analysis: v=2.4 cv=A/th/qWG c=1 sm=1 tr=0 ts=69c437e3 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=QOUmeeuX5y9IvSxXHa6D2A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=KmSSIXLuV57r0wwE8Y4A:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: 7sYZl1J7XwvtrMWTgtXWi1tK-NqqqOot
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11740
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 impostorscore=10 bulkscore=10 adultscore=0 phishscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250142
X-Rspam-User: 
X-Rspamd-Queue-Id: AF0FFC0011
X-Stat-Signature: ceik4b9edx97xn5r1nk7xjr49xnffg91
X-Rspamd-Server: rspam06
X-HE-Tag: 1774467044-913534
X-HE-Meta: U2FsdGVkX18u/M6j+hKDkrPVNZQgydjPKrdm7LRrB+PsB5uYdljqye7bz8gZZwKQ6ZMK8TKeP12vcZmrYjScH+7NFQ0vDbm7+GJyGg4rn30ezsPRrbrgv0M/c4j7+O6iszNDjtHBjxmp2gxpkOk3Ut31tfv5YDIBDrfaJnjOf1NV/PYUgKp4gyvQh/TuApP6w1Jk2WcXxM98S24m0s4YamRX97aZbLFM12v5OafCv29Ihif3UcHsh1CTpWokhjmYe4QEZoFzWG2ren2iXyHAZ3EScbrLR5fuiJNihxYiStfltK2PQdIH1VyNGE7lwhnt7+FpKDljTfUW3FqrWnR6kPBuY/znPUgjBM1m56E6Kd8QMWIazMUqzX/GcSVVAyGvKfJE+F/Y2CoGhc9EjgWTMeL+2/8qkdwkm+dV26wZqESNmbiqPx96aHmTblehVI8HkxqPpfGBPIZCRosNR2zmyOoVMEFtPSKJOoecwVxhANGy85lyTvDemWv7DSEzdOYCqaFMlQ9eWxFTSp2/AcpqIe1nvkCoXTgJbRE6AddtqyAEMV5FCyPjSGN7PCXZCR6zTIb1AzbDZifh4a5rZy8Tdc0sf4g9A/NOBaNkI0w1vNmn0L2tVrOxC3m8SL8A2UFbddUMwqVO2mj8wk/P7FZ7KW1xkKFBICcl1Bt4d1xdfOxgdA2qTeHYgtrvhjJXM1uA85i3OJHE7wEeMRG2B8/nF0g+OcA3XIYAdqRXBiUMhdTZR3HOUzkDGYPc574YAXvCs9LgtLOLCzMK+wnTI9/4grqimXls6sp9r2xby8zViGxd6BC5M0TNNF/ZwT208PY0JaEXyQtTPT5pGd2bARy71MCRG5HMlDiQ2V+NNbdeimlZyx9uDXJomgqzT/aRnSJBDdec6Td4ct9SBBrRiqx7tcwi6Ss1cQREctXthtTpj8s/pf83WzkEOoV2cITqY/Ujf+5gFqncqbiA/F5tebX
 JgQMRnYH
 IdDOgJpsuS7Yiu1W2hYb5g+379bTDOLZ+EGrCbx79mSEa5TssUltCFqHMDsZE49DB0bi97v3BpfnfmAAcVl93EXdQ+ljQ047Z74pqLOfIfI1zIJjfq6EXB+LZhZeRPo/jVRASQCRPOIjkj2BSzb2gDPu59jXw2QJUf+WReW1gA2skwI2PnJAYNGyMqYBezRosIHXCdERd8niLWf2xMGwts8evvqm0OCIM5Iphkd32PTt2fyKywnVrh3ZEh4IOlGRBqudZvNMrR9skRRnR2sLxymh5OAUrer+ISTSOqWONBUe/XzYnkfz6ZrBcHjfhCc9S0w/bEjU3FFtWdeFDfCyTFD+BIQ1qF8kiTNb8WREHDTE9RHR3eQPQuTsWxbl4nz8EXmK42ZAyu/AlwbvRSWyZ1wkvL76P2bL64+enEovZt28bLHlIOQ+DshAtFxT0R2XBbg5Q0/xGpwW5dxYPV7qydwE58QsIJ6mfxCC4E3rNUyy1yyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Block device buffered reads and writes already pass through
filemap_read() and iomap_file_buffered_write() respectively, both of
which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
by setting FOP_DONTCACHE in def_blk_fops.

For CONFIG_BUFFER_HEAD=y paths, add block_write_begin_iocb() which
threads the kiocb through so that buffer_head-based I/O can use
DONTCACHE behavior. The existing block_write_begin() is preserved as a
wrapper that passes a NULL iocb. Set BIO_COMPLETE_IN_TASK in
submit_bh_wbc() when the folio has dropbehind so that buffer_head
writeback completions get deferred to task context.

CONFIG_BUFFER_HEAD=n paths are handled by the previously added iomap
BIO_COMPLETE_IN_TASK support.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c                |  5 +++--
 fs/buffer.c                 | 22 +++++++++++++++++++---
 include/linux/buffer_head.h |  3 +++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 4d32785b31d9..d8165f6ba71c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -505,7 +505,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
 			      unsigned len, struct folio **foliop,
 			      void **fsdata)
 {
-	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     blkdev_get_block);
 }
 
 static int blkdev_write_end(const struct kiocb *iocb,
@@ -967,7 +968,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)
diff --git a/fs/buffer.c b/fs/buffer.c
index ed724a902657..c60c0ad6cc35 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2239,14 +2239,19 @@ EXPORT_SYMBOL(block_commit_write);
  *
  * The filesystem needs to handle block truncation upon failure.
  */
-int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
+int block_write_begin_iocb(const struct kiocb *iocb,
+		struct address_space *mapping, loff_t pos, unsigned len,
 		struct folio **foliop, get_block_t *get_block)
 {
 	pgoff_t index = pos >> PAGE_SHIFT;
+	fgf_t fgp_flags = FGP_WRITEBEGIN;
 	struct folio *folio;
 	int status;
 
-	folio = __filemap_get_folio(mapping, index, FGP_WRITEBEGIN,
+	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
+		fgp_flags |= FGP_DONTCACHE;
+
+	folio = __filemap_get_folio(mapping, index, fgp_flags,
 			mapping_gfp_mask(mapping));
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
@@ -2261,6 +2266,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 	*foliop = folio;
 	return status;
 }
+
+int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
+		struct folio **foliop, get_block_t *get_block)
+{
+	return block_write_begin_iocb(NULL, mapping, pos, len, foliop,
+				      get_block);
+}
 EXPORT_SYMBOL(block_write_begin);
 
 int block_write_end(loff_t pos, unsigned len, unsigned copied,
@@ -2589,7 +2601,8 @@ int cont_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 		(*bytes)++;
 	}
 
-	return block_write_begin(mapping, pos, len, foliop, get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     get_block);
 }
 EXPORT_SYMBOL(cont_write_begin);
 
@@ -2801,6 +2814,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	fscrypt_set_bio_crypt_ctx_bh(bio, bh, GFP_NOIO);
 
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index b16b88bfbc3e..ddf88ce290f2 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -260,6 +260,9 @@ int block_read_full_folio(struct folio *, get_block_t *);
 bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
 int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 		struct folio **foliop, get_block_t *get_block);
+int block_write_begin_iocb(const struct kiocb *iocb,
+		struct address_space *mapping, loff_t pos, unsigned len,
+		struct folio **foliop, get_block_t *get_block);
 int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
 		get_block_t *get_block);
 int block_write_end(loff_t pos, unsigned len, unsigned copied, struct folio *);

-- 
2.39.5


