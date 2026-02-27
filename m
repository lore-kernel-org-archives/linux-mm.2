Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9749FEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652896B008A; Fri, 27 Feb 2026 11:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633696B008C; Fri, 27 Feb 2026 11:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A03A6B0092; Fri, 27 Feb 2026 11:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 367CF6B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00CE61B80DC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:41:32 +0000 (UTC)
X-FDA: 84490802466.21.DB661E0
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7E5591A0012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:41:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="FM/S0CDV";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772210490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlmOHeLoSvLjpCm3jD8iWkNqxE6EJRsgaFZ0qUuQgW8=;
	b=rYRz9lpFx68gzxbI1wA2XjUESl3cyz3Xhlm7tl1/bHMPtkHN7S6YpyEM9SOZ+0R27c7ie+
	9B/L0UYEIwSWqDW8mNfJ/0Gzi055ViNHvWW9DWC+/HWh0vjRjnG9atejpC8Iv/8+ERxO3U
	DPknaVdcKwQQeaPUIKUkAsfTk38pAE8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="FM/S0CDV";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772210490; a=rsa-sha256;
	cv=none;
	b=ZSSxPkDulfqf72vyz2C1nmnKfQxVo1Fl4+SuhcZv8QEQ9YM6YpYcYUioKHYAFKBzb1HnjL
	y3+O1EuN/YGrWYpmXwoKcosDq2gffTSPZQMFeTMxrQdBGiv04G/f/2wAi7lJUZQcfi2HNB
	YkUHdm2zRe1VvhKGBVqQVZXdVQJ4AJ0=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RGNDYp1145803
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=jlmO
	HeLoSvLjpCm3jD8iWkNqxE6EJRsgaFZ0qUuQgW8=; b=FM/S0CDVVFMCT2m5AUDa
	OOFumevWors0oqq7hz6NDLRqsjZtbb+w5BQ34v8yQEwnu2n3lFDEfSqldvNdyEVy
	0ssJO1dDpY8qCk/RgAEmRv9cXwhX56TmsPpwK4nbJYDN4nSff3IfDhbhsLYAclna
	Wa9ga6InnhSRmJ6NqTfz3rMX4dn8n10S/ZiNAU2oPM03q6z+vwwi3+12ndvaO2UI
	lNMKkL7HOaAdQ4Dy6/B9jZlMgvijA8cLlRF0LBz7KRFliypGcf/fvzkS4yCu58IS
	MFNX6vcHiPcShCQ1tg+ZVgP13MMzx1HoK5G9VTgkW41t9/55kWsNz8lehhk04iJY
	BA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4cjst98cn8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:29 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c70fadd9a3so2077934185a.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:41:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772210489; x=1772815289;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jlmOHeLoSvLjpCm3jD8iWkNqxE6EJRsgaFZ0qUuQgW8=;
        b=onC6daWDSi/uykRn84hgLZFCqqTVBNW1pHTtQZkzCC2W+HDTKzq+Sc1NmiHzt0o+Us
         mB3X74mO/vMkgfeDuYUWFpw5zKfQQBuP/cPOPcIJCGlDUJyT+ZEj8os/qebfsd8i+j9i
         R5m2B5x/p5OOt9qk9J6If6577PuwiWv6xEdMvFjy0Fgq52Vnj5VNgKjEuPnyb8nPAfp+
         dzl4X9NhSoOe/MxxxF5l4w+yJ22umtkose5UESKtHAgvRaPC4Ycr7p879Iyo7s9YT47w
         vsFkVmSDfEbyvyIrZq2GNIj1d49tg12Z7pcW8eEum9kfXmjs23BNYfmRiK2CEDJ6ACwK
         9cFg==
X-Forwarded-Encrypted: i=1; AJvYcCUwWLQcDaPh2Nt0+S+zB91b/hIDi44E+dJSKWpwVubHL8VkcoNMpUrzNpCKFdzxZCLyoGxBbhC7BA==@kvack.org
X-Gm-Message-State: AOJu0YwYkNTmjWNSFAoVk09SSjHqkoCwINUWAcIXALK62uZ1KG3IiOeR
	JVPXPUrSZGt/0aUTwLSf5wPpODrKl5qAgsb8aAM4h1vqgvnz+Eibm8wtfEjCaFqbSip6h/VQYtr
	BqhkKLQsVZj4Y2NzWbiAaqRtWgc0oiQAv472KdtxrAno8Xs17
X-Gm-Gg: ATEYQzyL3TNMmjrcge7EUXA0raXJKNCbT2NvwG5DC/u8k6VUj9gcUSNmm5Ql7Rt5X1D
	9mHhjJR4MbGW1PIJN+BzkmkZon8QpBSiKUet043IXNI4aY1zuSK55bIVwiauvsktp0JaWgecuMl
	n0mXxKLveHKPBrFEmvmrR9ownBE4d00x7IjEvf2fWe7MNoBj9uKiz5MTV/6ztF6rebUMX0SSGCt
	fcZPIQa3XxQ4xYeNMR9tDEI2lqIkWzjaMmxZcuwpyqavKLEEMwaVenw6vNMqCBxfcAV/ooNBmcH
	TSGCxMeXIae7kPqduVPbvJopofv+KX8r4v5lQwqpOvHpZuHSUs2xIeQk2ihqnHJpJjTfXYbh1BL
	VXvlH/TPEylb6QTrNCPI32dY9e/UM1kxwLGgSwWSgY+NE8xJg2jH+ZK16azVt7jBh1Dk=
X-Received: by 2002:a05:620a:454e:b0:8c6:e11c:5ec4 with SMTP id af79cd13be357-8cbc8df8884mr430464585a.35.1772210488659;
        Fri, 27 Feb 2026 08:41:28 -0800 (PST)
X-Received: by 2002:a05:620a:454e:b0:8c6:e11c:5ec4 with SMTP id af79cd13be357-8cbc8df8884mr430460585a.35.1772210488048;
        Fri, 27 Feb 2026 08:41:28 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c716caebsm46535886d6.15.2026.02.27.08.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 08:41:27 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 27 Feb 2026 11:41:08 -0500
Subject: [PATCH RFC v3 2/2] block: enable RWF_DONTCACHE for block devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-blk-dontcache-v3-2-cd309ccd5868@columbia.edu>
References: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
In-Reply-To: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772210483; l=4224;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=8jgmldQQbiZzzlvIZlNR4V+9tVlk4w4gZb+9NNCt4y8=;
 b=vm0JkGcE+Uz0XFcsWwyvUOREbVMTCc75ksaV58G85KW5Z1ue6w4/8TqYICgOvWLed9AR0ZKdg
 MXRWrkfiaqjDOu1E1bJGDUJ5l8zmf/6G8O+4wBj6LctSBz2MF/pSI8J
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0OCBTYWx0ZWRfX7UCq/CD+M9Ip
 kdC9jdm7xZsygUA+5Zxzhm7K8EEUy9Lu0IV+7+asT7RMeWsuFKHFP6rby3ri0ClpgwQD4zxVJum
 M5DZOUH8gG9o0og3O6SJ8szKe1xrSa+Tfg3hepOuximyZUrU46M8QhsWqLxvt4rxrsE4Wx1ehB7
 Qi4CK8/o0fP2DjYj1oSIl0H/RqvheY4uY4MoCmh8XmyM1wXZ0/UP7xCp5pT+DMwiNkvhw8VXlNv
 7BaDrbBJU/63QBBppG+I5xto+Ltkjfkcu5RPvGpLf6frA0j9MBoEDFb3skQrHrTrqGcQuihLrHb
 NzyB0ZrQctlfhPQFIurbEO12tkd+IOfGgLk8w5qm8pSf2k5eLFtOFJVq1auvrluvXBqfE6GSAsk
 J8R8OFyOjpPn4PMFrdGIq/igJom/S0onviLTieCnXHDByL3ZNqXM/YV1AxmOYt3sl7NHP0M30cG
 CtkNNw8e3Dj5YQNyFhA==
X-Authority-Analysis: v=2.4 cv=ebMwvrEH c=1 sm=1 tr=0 ts=69a1c939 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=Kw1KkKa2aV08GXngiw4A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: eYXOilpJOt_yfdL8oNSaK8eVFszPYjB8
X-Proofpoint-GUID: eYXOilpJOt_yfdL8oNSaK8eVFszPYjB8
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11714
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 phishscore=0 lowpriorityscore=10 suspectscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 impostorscore=10 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270148
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E5591A0012
X-Stat-Signature: h6hf4mpjuax7e4xyxmynnpw3itat833q
X-Rspam-User: 
X-HE-Tag: 1772210490-974199
X-HE-Meta: U2FsdGVkX1+csNaAaygq1/cL7c3vZAvNGoNhL+id88GysRJVOEnBpbPzOg3gx5iTZmfYkppFj9I02wvkzSydmYB2g48DZO4o7WXkgctl2q6Emypf3S5zpS6HOsCaKVV2Q6gegHDOGMgAg+6/5IewCXfi9PBg2Xg/+01ciSCsoNKaCsSpB7tj7uVB0q8HNNAtpYSS9BSrPAm9yzd9Eybxll7XDtK2jWLIB5iSBUOktB5yrROdOIgXy/FVZvBqrkUmq2rA+oramx4bO91qBiLjydeQ2JZa6pecNCesFh8Gi1Glspp1gtgoDE3yQPYPlMbRL9ml5KrQum2TlAoRGy4wCtoC30WrLSTyY6GsNYvXQpcLFjZ2/1BR4Tp3mV5yCMq8FqJ4wzGJF6R+M1JEISJI4f57m9Cj17R+XG6QWkJTSHa8cr7KWtCK1J4VaIrgkZdo3xnRtxJdz8xLk9RRcvNw0ZEFkbXjBlSGc6UVrFUU98nrcgnTTN29jVkwshkumAs6FJe0JrOraz/tDBhv3YvUcxXgSlmzzJwfKvR67spAZCbHgOJjSizjENUyry20+3V1T0q/RkadWVqYbH4mL9sxfoa+m7r/r/tCaPcns+pyiBY+SeNmfmrbwCRad3IiEC91j/N71u5Sx2BZV1N8zlxP5wXMjYO4w0EUEcihH86cAdfcICxLaAkD9X+Gb+5wd9FRUIR1qi2Twdum5QfR5Zg9wI4YT7wGql/SLadz0vTkt87fxKBXeDhWWtOrt12G+1qG2JUgH7A1AfKRboz3x7i3O+DpY3ABlso1A7BZS/ZRJ+ufiogtqg/CmnT0vzKvXiKruhC5NbletYOuxcYVP/q7viSPnOEOBCZN4jq4rCPGFSqVPnqniJvuTKNesA4UCOiR/zJutNLZB0pbqRT5Xw9CUUAme1OGFm3gRQiSZjnzE7dLrtov5SGZCBVYPlQTJcLuJwxjLOCGdeDr3/bIarQ
 DxGDzdi0
 1fdo0rXllTFH4OWHqcB4RNTnmGAjdCZtDukEafrCANswBQasG7m8UFEdIZ8h1E15/7DBGgu2E/cTNSdnFLz5RdE89V4USQrhBZprID31ebmBAPl/Dyq2jV+6yyDyhAfVtjHO9WPVMkERHPwUpQRLRhKyYutnLvXWZiZreS9vY5OXYLRqjuTP5GlV3qgk+coHTd7iBzXqCSQcCfBPQhVTyMvx6zWdgZuRBAZXgZjUh4BILRN4I1O3Cc/NGHRd+yy0KmynkG7yP/crCoWV1UjEl1a2ZjCMKLnaqdtxDY50TMGmGTcqeY49W8BpQ4xC8ap/HbYR8DaDnc/ZmrEM97Og2vLW7C5/dY8U2lKaP0OhmAHbAYawzzyY5vC+RDMb9UxJKDiJotIkSSsgNV1j16VVOmxrphguFnAVLyL73XeXeXKbHQp8O/NzUOpAYpSPtzf63B4S1jOYvIsnbB11gGuF3MqGW9jCRuvN6KyKL4GGOBZiMPOk=
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

For CONFIG_BUFFER_HEAD paths, add block_write_begin_iocb() which threads
the kiocb through so that buffer_head-based I/O can use DONTCACHE
behavior. The existing block_write_begin() is preserved as a wrapper
that passes a NULL iocb.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c                |  5 +++--
 fs/buffer.c                 | 19 ++++++++++++++++---
 include/linux/buffer_head.h |  3 +++
 3 files changed, 22 insertions(+), 5 deletions(-)

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
index 838c0c571022..18f1d128bb19 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2241,14 +2241,19 @@ EXPORT_SYMBOL(block_commit_write);
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
@@ -2263,6 +2268,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
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
@@ -2591,7 +2603,8 @@ int cont_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 		(*bytes)++;
 	}
 
-	return block_write_begin(mapping, pos, len, foliop, get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     get_block);
 }
 EXPORT_SYMBOL(cont_write_begin);
 
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


