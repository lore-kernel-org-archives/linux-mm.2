Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4760A10FC45F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B170D6B008A; Wed,  8 Apr 2026 19:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A798B6B0092; Wed,  8 Apr 2026 19:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769A46B008A; Wed,  8 Apr 2026 19:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6FC6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:09:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDF9CC17C2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:13 +0000 (UTC)
X-FDA: 84636931386.06.FA5E600
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8A84220008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="sX/DybFo";
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775689751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7NOoLpQC1gt8jjGEOFARMhStqFULmtQPTxyzd8Tw9E=;
	b=3yf3oy18l1a2QkV5OwB0YAvsBmE5JSYw45BjtNnTcbnAC24e8ZZX7q2bDXKTQ//xbyYjV7
	HKTZ9f57GIuwumkEEf09R+oFr1ww5ZovtVCggsjeQCWkiGE5cFBXm/7pDtGi1Ggocmm4TT
	cUmLxOLJlLd+uu60QxsVl0B123owac4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775689751; a=rsa-sha256;
	cv=none;
	b=F890G7Z7aum2+59dvVxaDs0LlXzLKcrwL8zV6yMNhs7UxNzCFp36EVoKDwukfMRCF1Qm3Q
	8kLxfjnw30r4NlRRnAktbbggm4QU8kdDdVLcJvdwBxNk0QEbH0kFah1clE1sqTV8D1WLIV
	jLNGtlGJ3yvApH8o8ugo146CXBBwWMs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="sX/DybFo";
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638MtsVv3761657
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 19:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=S7NO
	oLpQC1gt8jjGEOFARMhStqFULmtQPTxyzd8Tw9E=; b=sX/DybFoA6nPq2/fiQXH
	P1m4akAquZ6v2+LHTPlMLkgavf+yG/DxaGshLuCrqSsAX1UsI7rsFWWkC8zKyt6R
	o1zyLIdzrtyjaUXfI/1+JiOR3R5ucwVnwPjynyuQRSoQwEj65c1m2riCbuU9eaVi
	EDGmL0+83ljeQ52xYm3+wL9pa6Pera34PDJQGRduG35WlqlTGSk2lJmjjpiHpzmk
	inX4NVoEK2SBuy2TVftA54Yy+kkL09FQ4K1GH0WO50Ld1C0sRhaPuvjbAYxv144V
	+0qQTlQqhrroAD0eG8b9WPI88SLci48x/PbC/hNlpBaytb43vk9WRZs4dD0UUI5K
	Gg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3mgtxr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 19:09:10 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cb706313beso22000385a.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 16:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775689750; x=1776294550;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S7NOoLpQC1gt8jjGEOFARMhStqFULmtQPTxyzd8Tw9E=;
        b=DVtPF/7NKmy13Z9TDVL6siY5q3Hl4Bu/NIHxDxMTJ76+4EOrbztQf8Yj21BJAQeJ+J
         ucAUSIb4R2F1N/ewGpB0lg6iJIuvvZzhH0QiZPi86nk4uoHTKlCe8oXIa4SeOqb2aPYd
         ++CekCo4n0+zRFNDuFMd3C5bmPKR9EkAFNxGMVQbNVUPe2jSUcr0z7Ew0q3arBS0QyYh
         uTgG/6TOJmhS1X6EDYiXDA2H2gesOybZtU5UNxcvEo644o/GbjWThTHUlSgFAEmXbN5Q
         /fWmpmAHBgXZY5RlUgV0G7llUH8+eMWLoxQSvgZVE6jPvJEbwP22p9z9Vzb183qciI2L
         yPeg==
X-Forwarded-Encrypted: i=1; AJvYcCVEeE7AllU5xpJEnnxiwXFmnKsyKiGq1KPkT3LV8ABnY0t9hE7EW1g1KlTGMrHXsn4klLu5zX9veQ==@kvack.org
X-Gm-Message-State: AOJu0YxO8Z0I2pdNTygPQC7S+KMPd8pWJxcUWTPiws+XP6nUox6GAgK+
	AoXApEAXaFQkYsl0SJK/+jTI8UU+GvQd+/R3v/rZXkY0EujQa84vRYG4r9iIu06YihzJ55F+JiQ
	aKCz6qnBHO+dgTu1AGjX9J90D/NPuP5A5oRHNtWN6gMhmfqVk
X-Gm-Gg: AeBDies1ZOXp3s+N9esc18Zix2TT3nnY05Iq1zOFRCJXoFkn0JnHkM9xp4D74pjhf9Y
	3j1nBCjHx6qq9dHvWE+nwJhy5jcQ638VvzfrtqNclgQtyePe+yExYN0JyprODf/FQPmxn2N2PEf
	Apps3+MErv5yyzjZgrjVOIjqsaibLnJ24E97LFCGrVyQG5ezWPBcfR6p6xt90S3HHaJ7uJwnu5j
	Dle9F5uMV0EWLzl+Ouoqj8v1UhOfPKmz7NkvhDdHntJbB7zIrlV8v8XVr8c8nSTBBmgaR3BBT0E
	Bx6siYV177Pko8L6TrEww+HJK8Lpos2IhRou1iCgTp3ymZtFOhJ+7yKnuHDxI1NpiwqGkluUG4h
	7vyXwiYAooQhoajjgyvd/0kXTqZEIIpg4
X-Received: by 2002:a05:620a:2848:b0:8cf:df8b:1e5e with SMTP id af79cd13be357-8d4185c9512mr3194927585a.5.1775689749870;
        Wed, 08 Apr 2026 16:09:09 -0700 (PDT)
X-Received: by 2002:a05:620a:2848:b0:8cf:df8b:1e5e with SMTP id af79cd13be357-8d4185c9512mr3194922385a.5.1775689749261;
        Wed, 08 Apr 2026 16:09:09 -0700 (PDT)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8dc1514d382sm125665485a.4.2026.04.08.16.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 16:09:08 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 08 Apr 2026 19:08:51 -0400
Subject: [PATCH RFC v5 3/3] block: enable RWF_DONTCACHE for block devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-blk-dontcache-v5-3-0f080c20a96f@columbia.edu>
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
In-Reply-To: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775689745; l=4833;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=vqYjVe4t0i/AiFArpSZ9mEXLlU4rnE2ZRBBMSnozEZ0=;
 b=TkXe1cDpr+0h2BcgYcYMwDXJ9OzGkB0Fsjl6RdOUbuhHuLsFpdpyPcESqIE4200vy+eNNs/A+
 038SUVLSqekBHFqdXjGfViao6J1wkhHyywZ87y01bw5yaC4bwnIIKLF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=OdWoyBTY c=1 sm=1 tr=0 ts=69d6e016 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=KmSSIXLuV57r0wwE8Y4A:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: Qj_Md21WNIFv-hoIu6ByN5ydykx5vc_K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDIxNCBTYWx0ZWRfXywg0VS3j5KG0
 rDhZGk+QwOj0+Qs92DkpMfX8wPa+hO47syzNunEyXGKN05tkmTfqu/pkJSOLR2Gbwy0Ch1U1/pk
 3E/h4EWSESizroTmb7X3ztEF+COx0/CUQSRln88S86jAU7vrtXh1KYDmIaC1smClIQ0GNIPZ0q1
 +Wj0dJqJoReHxjN5IBI+2QL9dIa14pr5ouhuMqNFJCNlrnGNIuyj+PG/TIjvYcCCnIvBaMsMWA4
 p01Usus6e7GcRGEELDagOljpQiWH53bUkuAv7sDHX6JIFLNUG8YbAlh0v84N1SGdUz9dkMvr0uN
 pPgl6HO6ulwqd1nWvOevWsbiI6zrx98l5Iol5d1om81PqTQ7ARYl+LsiOldhI/p2hcu0uUiUTTk
 Ub0pWxjGnx9L7EtvK0G7HjLYLYxItw562uCxzxej3JYst0ReEM6homWeqY1uJDG/4Nd37MCNrIH
 Fn8rIdayWKGl38dWPBQ==
X-Proofpoint-GUID: Qj_Md21WNIFv-hoIu6ByN5ydykx5vc_K
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=10
 impostorscore=10 lowpriorityscore=10 adultscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080214
X-Rspamd-Server: rspam12
X-Stat-Signature: do73ib1nmxr1qas8frakgaszy8hoyptg
X-Rspamd-Queue-Id: 8A84220008
X-Rspam-User: 
X-HE-Tag: 1775689751-547879
X-HE-Meta: U2FsdGVkX18tcfdkitYEiX0P4ih/4bbI7xC3T8VStV0czhbcuDLmAyL31Xvzhtfx7n6j16a4jLigrqI/DhuPKHumLYPo+R4ERwthRnsMcyR6eGQt6nFZRKilrtXWIgJZaKqWe2pvdTVhFVnjwj4oqz2GKHmGhIfOz8UNp3FsCO72VpfHdqtG47C7gEMEoEQz12RIhA8lJddPc+nDet4dwAw/2SI3tOqwmMdGTa9EXCqAwejICmnA9v0qeZQHTbaGLJQe9pT4xUmEnhHyOwaMU+6WFzjFpe6pZfccHszg1EjfBCL9S//2BPEO4O/ZU85XVL4WEqMOz8NE+zftn6DEoZBnCHPV1B9NJJMSeXPYpEr2TqS4Yt9GqiTSVubX48RHOdC/UNFrTOc1uW7vKSo41PX/hBVcbEGhaR5viW3t4S11qCa9aUp9SuLRY9kaDBrzRr53yDBNHqtUxg2P0ybFl1sJSNENX0FSonaRVXWlk31pgg1wh3ypRsr1Bd69qeWb6JEUqJRZld5XPnxKeVV5D9oSqj+p/Oh5e3ssJBJB8bq+046ZjgM5ZV3f6CEIdVha9VM1sQfs/tesCgVjPCaOuWJMReu5Se3vN807Jt7HulZLazoDkvLcZ417KInDiSboFiuAcQbTo3M26b15QYFGQms3/XzoEvxUnEKVIbpXXK3arCryiyLX+iT8SqY/eMv26PU6EWm8Pjhs7zW6daTM0TIUwgtWg98d9LYJJgV2DKeS8u6TmB77xOoU3TMF4qGMgKsrP4eztcH90W/5KRkAxNBa/mUefP9W8wEG2guoiijJHHjsoGQSUMP6S9AyVjjy27lQ7w8++FQsq5/IFAi/x5Yee3imjtrZm5Rdu2++GGorBmowY7nwFQTQsJnGFqh8rQ6Kgwxt7HtO1M/p7OBiNGCpY7Ik5QmkngJuMZ0ruygMFiJEOnaRNrZhWdss8bMtTo3zVXCqf6XnVAaIxwF
 FT4Ix1Vs
 Bl/3Az6wHsxJCUoNk9l1mx3Iaw3me5czeMfJ7NIMSbg60wvoDCslH5/T+tx6GDbpQ/9PCRyWWTN7PnRM+8B/dBTYGfNEyi6v3wFCJuEcEGffetJvmB0kjRnnWTMk20J9Nkq1RJYTUmqkhx//06ywwML9zujT+nxKPU0+zbyWBGa7e//l/EBNQgzQaBOUyUoqtnqZCIR3PJ/HlqbuP3yO0jd+gTyxKhkBwnVyLv054zONAhIFsOOr4PnFcled6krh/NgAncPf5HAZviGkitKM9fYANMZgATPWEuKRw+WHlXZSgO1jIYgAaSH8KMYem3JVmD4/WSNr0v0hdZFri2os31/vPfTx9Ttwov5qqikDZ9OodHgLdl7iQGxdqe0mdaACPOFYz4q3Gd5EBr5zCgobf4+R+qd/r8SCJbyYd4viUHt5KjfkTEoP7PRB3Pxn8wRgJ8vTeoYPH0RVr+ECxZEM/p2rCZVlvzlfCVrxEZMUu1AzOz5E=
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


