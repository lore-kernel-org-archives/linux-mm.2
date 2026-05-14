Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A99BCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 21:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010036B0093; Thu, 14 May 2026 17:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC876B0095; Thu, 14 May 2026 17:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79B86B0096; Thu, 14 May 2026 17:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B59396B0093
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74FDC8B9DE
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:56 +0000 (UTC)
X-FDA: 84767373432.08.64313F1
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC7D6C0003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=tBt53dWq;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778795513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kqw7BAzD2WWgy7QOAIi6FHWqeO1F7nxlJS1uusq/eg=;
	b=JQ2+LeBBmjCObbC4XfGvScy+7nt9LI4z8wNPRiaeFtVSfwMygcRRrz7nlYgi6uzUheIp1r
	deZ4qd7niCGP2wP6mN4U8yt+xXuw/32zOvU72kvQ5HqdhLQJe8g7HV409fDdKwxgtVw98O
	zaFS8EF1l6iO9WVGSKbAQGwkxOqQ5vU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=tBt53dWq;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778795513; a=rsa-sha256;
	cv=none;
	b=RqbU/rYH4o/fOxzz4qdMWRBqpRI2JvsxBQze+RFklOefj7DTSM2qLk8R3uMipJ4il2xlVX
	GdrerneSUlqiGp20WsQ0yyXL7q+kNcUrwhi2dC1p16P9A3lJhuGTIePtq9UPwdQTauwVMh
	K5aAR4+ut2XV3q5OdKOZ4Yl8BTjkgmk=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ELh3gB3841753
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=6kqw
	7BAzD2WWgy7QOAIi6FHWqeO1F7nxlJS1uusq/eg=; b=tBt53dWqDG+4YQvP+yzf
	t08Mdq9u5NAo2gghpSycmflWYst40GFzx5jWQAqvDBXC9c9xly/C3sWSTmVurFWZ
	Vx/VsGGDRmszucNqshm3wKuYSxkPI+S09nfFpFyGxDQmoIdk/ehJcqfaZJa16SKo
	qE7wWfYnudBRXoQ9SXVciqfcnZjxUp8kZW38QhxYqCeyjT3N4YnvgsE/hLQH/PIw
	ADyyyR0CCO781xiYtzXjFkE4qBAWM428/9tks/eHETxMC+c5tnfxoYkysukZ2Cv6
	1ba4WBu8dUZxR5oCYIn6aXy2gCnn0nSX1M45JKGJBApZHLKWxL0oZNlP4l12z1Em
	UA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e5m239nb8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:52 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90cb6202d40so930735585a.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 14:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778795512; x=1779400312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6kqw7BAzD2WWgy7QOAIi6FHWqeO1F7nxlJS1uusq/eg=;
        b=tOLw6r8qCxagg3wq25afebsPyrD31dkHgfILc7qcHSqAyUE8P/VemeyP86FkYwY7Ut
         XhJeV9W/CdA5WU63PwqYN8BioROUd8EoFOLS6nxjE2d4uVk9OFDdv2FVX5nypbgmXYlb
         sgtb4x1rbQCAe9mSWkVQIuJEkTcTxkfRp601xGTyK9Qg/h5+200nGJ4GY/GrfFdolro8
         6CiN6IGpT5jOv0bJN2kDU5UY84jN3EBPW/0nsrpJV3istQB8nPyKFH3EnsL9DWdWCM0C
         t1tHDrkTP/HIh5fp99v9W80wBFwAEh5XI1g7Q4pBcON1qgLMyHfUF/yn1ObdvYhekUuT
         YbLQ==
X-Forwarded-Encrypted: i=1; AFNElJ834rD+G4CRhij08mcY9oIxB1789wQOiL5KgpizOa/tSw+4B8QgUBiG5FmqdGT7yirC5DUydfcjgQ==@kvack.org
X-Gm-Message-State: AOJu0Yyce+GjoUf7mM1/F7H445nezPSOxzKz5tkxJhJU4DmSCSrwH6xl
	WOjLEwogC21fdAA41YIOHhxHU/wgR5eK5xxm67NLefsWyIQ0PTfQ0yi5UYEepm9ynnRZka3m9a5
	RQhyc7a8B0a9ymVcgVIeo/p56hAm1JaZonM47TjJdZmBd3Ups
X-Gm-Gg: Acq92OGEPbVtPjQW/kQzeTfcUvy3B/O/d0vi2wGDIEECw9K3Usbby8WYE2WGD/MP8CE
	VuUGCRHd4ynrfAUhen4g1YFA9iNqbhUDxMvEyB0ITCTySKBofVuJ49pMqdJ11/1hc3sYjJCGgwx
	pvXxoOrIIlABZkYrQJUBH40brveI1hiLgZaVV9R2v3YJvV2Xb2LWY/eg5Q5B9wI/Yu5weIZBDxU
	/bdkTPFfPorVil7P4slEnxuPv5SygQ9Nz8R2s0FmfAbC3PG26GMgXOvJw55m+1+4FcvmCFS6/cT
	viEtnObLNWEFywqvcAHLDAS0ENOBzmI/+Nv1Y4DU2/pwnszmmGJzpgAw0085qHoIA9aoD9grZVn
	O+LU7rBkczt7cmVhhXYRGC6qtu8/r9TtV
X-Received: by 2002:a05:620a:170c:b0:910:5637:4bec with SMTP id af79cd13be357-911cd1752admr254277485a.18.1778795512193;
        Thu, 14 May 2026 14:51:52 -0700 (PDT)
X-Received: by 2002:a05:620a:170c:b0:910:5637:4bec with SMTP id af79cd13be357-911cd1752admr254272685a.18.1778795511761;
        Thu, 14 May 2026 14:51:51 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba18132fsm354966085a.6.2026.05.14.14.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 14:51:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 14 May 2026 17:51:16 -0400
Subject: [PATCH v6 3/4] buffer: add dropbehind writeback support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778795507; l=3250;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=5MBJYs1Ny9I8ogr/547ALSAn0Pj03wWQCXtJIb2TJHQ=;
 b=9bQ2fojDINOqvoN+XUOT5/4ajyDiEcYRuoe/toJiMW2IYEErMQPP4nWP0kyaFXtYEdFs8QavD
 IoIc3c+yGL9AJoDL8xs3GhMcj/KZ4S3T3QanBUhqIizKxZ8785C3SWR
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: tAgbGIvjDCqneYXhxQUW5ifTOSu_wJne
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIxNiBTYWx0ZWRfX4++WgwKX8NYj
 cTwlQWWSzxRS5gBDHuX7vWqA6XbZlf9v7VG5pLj8uFIiqiQnS84zndySon2Pnzt1oqD+CqWDxO2
 gZ1OP5LLv3cBj6R0e6ZPjuzztq/n07cxUPaqPpQMaaGN2EP++wZK7VozDrMCh+c3NyR8AXplsgE
 +BKA/Kn/CljpI8gjR5gHoM4iIZKVmIS3gb0za/m8wJ9niI/q4VxgM/C5DOUvumPnShJ0jf3LmVs
 YiUGGsGQDcSLa3U7Bc6+x5HzRhGLASDAAhPb6Ld3X0Ds28jU1h1448vt1n6OawzUaj2sLxGdN7b
 S+o/A7JafKr3buoQzQo+KY9kjxYk8YWF7MTtENal2loeLv63UTdYRbEfj3p/OPO1DFz/z7mPdbe
 +zDFjL/eKd4lZ0jKylegv+iJtgJs6dbNEpriPcDV+D91A3bv+IoLf8KGxMIGavRPFPtJ1wmkcgG
 5NlJHd02QJiemoppqSg==
X-Authority-Analysis: v=2.4 cv=PLs/P/qC c=1 sm=1 tr=0 ts=6a0643f8 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=H0jnwmGZIJSlLSF8bakA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: tAgbGIvjDCqneYXhxQUW5ifTOSu_wJne
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=10 bulkscore=10 adultscore=0 clxscore=1015 impostorscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140216
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC7D6C0003
X-Stat-Signature: ybyuwj3xyho4c153ppi5mqw995g6sgri
X-HE-Tag: 1778795513-370954
X-HE-Meta: U2FsdGVkX195bw459kGp/Hn+BaFpZS010H/WlmDiAeQiWecdfKBb9y2G2tuk53pdiuFeaYAqCcyv3uEP7ft1+xp4IHUugxcevLh0cy0047jm5kAiS4ri1ULb4+BxSsFSOMrWP9ENI9Aa3vEvr1BzMsn0P3aUDyuwLOdYJnXWCL3dZHKx8uU6NUgFm0dyNzex5ZZ729+A8XNaogEhNAvfq7C6abJen/2b+LHHpWD48irZpBnP1Z+UBRxJFlI8lrS14adrmYi68adTjsqf8GLOqanpDXItsJUwGifbppZ+rl6QsH2LGg/Caaeobdf07XBB3vXoU/qEGoLkVpWCPslHU6+A7DgBftwACzwxTVd1ePheNVMD5Z4XQ2eVNyhp3jIa0z4pNFBmpbZEvy0wMwr0s63oBd76Rn7C4vfhjlwcJn37v68GYnjMR4O0SULQGXFkzRbf+JiEhFmc59vjglFHYra87zLXQoRt+ZJTd3/rMQT5xsEqqPCKOsb9hWVkh9Xxbgr/sxAuFGMhZxMGZKWBtpL8MLpoxb1frhFVUBkVrKuGmykL75xakpLFNuCmDK2e+yB9PkwlAjAzUreNDCYKEBOjYt4idcI3TCX1uqfgbFTb/1ZvFis3OCJ4UKTzpojmyZwvrP7qK5u0ltr2dcQSJsWIr/iPoG3Z7/l549sY1BhqadSlnp/31tAxxx87hARuT08f72A+MSkCzkmpdOk0uiQ7J/aQl5v0ockAI0QYHwZXa8s0T0lPWdxZGnj1N4DJdo3E4hWDDvrHSaYn9gPX9Vpy7+77vUWv9ieAaT6PGEaSA/naUquU7veIzq/SRN4+YsPkEATYskAd/Im9jKdHLPizw5jd0jApHl3hEVzRLdAt/A6UbFCVxnodHQf+9lJ91NMTK3738mzWhupZBqtuJy+w0/H1KRRNBd4D2H77Vgak7zsGvOL731/oq/ITuPyKfVHT6iROSJrt/G2km6r
 nBT5/KPP
 ZKN+e1i8x3lSBWAjdbhwPaT5cLrgvfi4c4A7z6Jk/IkOreQ/JE6we+iuzGgPrvSIoAQ3X1qphPBaPQUyXwizkIH91JDLe6wKk491hsJcguiiDi3DPy2e/Dz8FhSpO1nuTduFf1ZLnLIBQLHxoB9VZx+UyKXrsMbhf97iq8IGRo5GfTYnyAQJA9FSVcgr+IOtbKzviq9Yccfw7SRPN1uqaKImQSvFZsPUzhGmzGY5hldGhlQaCUJO3+yAOnLl47dJ1ukd35TlmPTVTe5CMn3YiAn28SohGbtkIYIixHktoxL2uKa4xMUfDq6vgg9mFBfZGQaM417OGY0vACjBpuo0n3QZr7x4bKqqHkA+Kqc981+A0RNwkoWk22EzM5qXD52PfM2tI4EIHDBJ60hGgC8KvknRIlz5zzCfsN4GbDXbuV6iJBzzvNrcbISf4wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add block_write_begin_iocb() which threads the kiocb through to
__filemap_get_folio() so that buffer_head-based I/O can use DONTCACHE
behavior. When the iocb has IOCB_DONTCACHE set, FGP_DONTCACHE is
passed to mark the folio for dropbehind. The existing
block_write_begin() is preserved as a wrapper that passes a NULL iocb.

Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() when the folio has
dropbehind set, so that buffer_head writeback completions get deferred
to task context.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/buffer.c                 | 19 +++++++++++++++++--
 include/linux/buffer_head.h |  3 +++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496..d0abaf44d782 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2138,14 +2138,19 @@ EXPORT_SYMBOL(block_commit_write);
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
@@ -2160,6 +2165,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
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
@@ -2715,6 +2727,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 
 	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
 		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e4939e33b4b5..4ce50882d621 100644
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


