Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB22FD45FA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3EF6B0099; Wed, 25 Feb 2026 17:41:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE586B009B; Wed, 25 Feb 2026 17:41:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651316B009D; Wed, 25 Feb 2026 17:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA856B0099
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E33D5BACB1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:41:44 +0000 (UTC)
X-FDA: 84484452528.08.56A7BEC
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 716311C0009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:41:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ZQwNYgHV;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059302; a=rsa-sha256;
	cv=none;
	b=RLApM+0NQluQ6TH3PfUaKocjLb31Q2udESZBrmRCXspYOlN3qa7Vhx6Xh/fmYm6HLloCOZ
	xnZkGGFFp96ZRXuOjALwiTYyZ744cA6vuEmw9G6sdG+cXvI4dvQbm6ycJnhnNrjRwApDNI
	8DgS97X6rKweOGLUsSBwftez6M1Q4xs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ZQwNYgHV;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCadQArHxHi9ThZ1jAIvSvngqH0LQPrZ8HK0cEt3m1g=;
	b=I112iz/Qahie5KFIpajQwR9c0yiAhVcxKk9UHDeC/2cSCOKeoKS7ODwZu8sMlSp3SE6Pln
	noQa+6cVTsaZRfObzUSyG4xT74728QRVCFTIMbxZB1LVWHKWSo+g8vUVizdabF+aJqfBb7
	Oezk7tIR+CNXpc9hYeWAamuWwLR+VO4=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PMC1hj3216210
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=UCad
	QArHxHi9ThZ1jAIvSvngqH0LQPrZ8HK0cEt3m1g=; b=ZQwNYgHVk1e7AonBp1GN
	AHhms9mVIbxtdg9djgycPaIK5SH2e7LZ9supw+fWQxOsuxDxLdWYTg29qYdOZWOY
	Yoxind27Lp1LnTlBB+iocGqkBeujZgdoOx0KTpb3+L2flDUaQvgq7QGL0FSOMsZb
	aePYzQ46aAH5yfuxGueCd2PW8+BtSYb/6riEK9KE4UlCVlV4OAKU7LPjPny0bZRa
	r/F5oQMKeYFunqtUXZRY4gcq/FG3n9onHe0PD5YjSbIvEHhHmA/12/mqQIcDCB0E
	/BIYyBF4K6XcVWBm+onb/+8xjo0VkdTKX9hjL7/Xe7D735HMn5X1aR3McboDQo3F
	fQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4chs0qevfq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:41:41 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-506b4005ab7so29854901cf.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:41:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059300; x=1772664100;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UCadQArHxHi9ThZ1jAIvSvngqH0LQPrZ8HK0cEt3m1g=;
        b=Tiaqk815+U4nMWs772k0xjX0W0/TU6BoUplr16rm526owtFrBUK65/W/ax+GZEHf9A
         sBwV4p3FBDlk87ZFzalJ7Cp7VPpCJeC881KZQfaY3zfPZvGK7TN7jlLTHwDY5lcLxw4X
         VuRCTK6gP0aR2HY74C4EfpwGEJkBiiNX76LI/k1acLVCugLzF+jrZIKFDoP858pUiT0C
         1lN2+RJC++pjg3edZrEuvaYPDLGFc8Gdf9O7KkMn6LZEhsaU7sZ5aP7AVCGl4nMiXiFu
         PhfN1rIvJBQIY8/gtPfTaxrC1WtMOA/WGB9UKejRYZOkJl6IVToo+W/BcIKe2BFjB2sp
         sMTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGm2i0gbxM3P7Y5atGNinCS4KGK73nFwfQQMyT12tp8J1naA2AgIByvq7Lu0P25QLHvZWETaWm9Q==@kvack.org
X-Gm-Message-State: AOJu0Yzjp/dWLwXD2oqsZmiJ1eBM5cV80E+SuMowFdU7LvH5z+rvYd2h
	UpwkbBgXBRneaKZwoYLVnVu91S7ITQgCeddig+N/cemmCy71BGuOjJM5gGAN3FjzUWHBoB+IX6b
	b6OxBMR0t5Epvru+iTsC9cU58BfG9wvedQnxCZWMLkv4pKZey
X-Gm-Gg: ATEYQzw6w0htU5+9+Meylq5r3vwweMtcmWjb73aQvLcPAYq54SmyC9yRKmPVpiGAebJ
	2gMBfxtWM6XHsUyYhsKC4r13AUY1/NL/XK73G0Byr+K3a6OMTlL92K2H8/aY1oqwKUAesX41yF4
	H3qpJ4oF4Xv/yAnhdi4hh4iLd8+90cSu7hrj/ohL5XGWctRvTKt91wtx306J/YnZ8sgW23Mz5L5
	7KspIvUFORQDEaNVPAln/42ph0smmnDN09wBZew6pjYwFUOiPjTLDVgZ5Wa00MjXTlZnewnXYM/
	ceg2Ux+9vlO2LdtfGAAi9tZ/ut6c6R6wTSxilfSfyHzdxaD+ncoSaIn9Fd5+b7N9HDXn0zLf4+5
	M84Em1z51DsxlMcDvMSz/9Ht2zh5sxGVO
X-Received: by 2002:ac8:5850:0:b0:4ec:a568:7b1c with SMTP id d75a77b69052e-50745effd87mr1368611cf.21.1772059300013;
        Wed, 25 Feb 2026 14:41:40 -0800 (PST)
X-Received: by 2002:ac8:5850:0:b0:4ec:a568:7b1c with SMTP id d75a77b69052e-50745effd87mr1368101cf.21.1772059299490;
        Wed, 25 Feb 2026 14:41:39 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-507449be47dsm4196231cf.15.2026.02.25.14.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:41:38 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 17:40:57 -0500
Subject: [PATCH RFC v2 2/2] block: enable RWF_DONTCACHE for block devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-blk-dontcache-v2-2-70e7ac4f7108@columbia.edu>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
In-Reply-To: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Bob Copeland <me@bobcopeland.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
        ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
        linux-mm@kvack.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772059296; l=9465;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Ut4irJAP91Ja56kFfECaXVcCmgWiTiooWThaHJixb4A=;
 b=Nv2Kk4KuLTpGQX84Y042xeZddog0F8f7rPDUzrUKUw+0BVDRxxIPtrNiY2iL73Q/t4raHOUQx
 MqYl+nhxhJlBePWXMDkS88wNw/JvTeg7ErN4IzVAeE9mMzN1BIIMHzs
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=ZbYQ98VA c=1 sm=1 tr=0 ts=699f7aa5 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=Omgu3vtQbb9kFtOpCJYA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: 2ue5Gdu9UG-_DVrZRSHphWNX7qdOW-6R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIxNiBTYWx0ZWRfX45tZMeSgLfUL
 rwyyb5oCMbHad3xXTyUwvP8RzXERG9BSrqfDxSj/L3XA0cmht+UIqtV1/HGSPCetRhpxW37sLRu
 06e27siwMQxpyofRFjyFAGieN8/WjvjjiX57HCTXzJJH47WDKMKRo+nEk/e6DUIh3MOXv/Cbqod
 GZ40yYKdHK2a2qAUp+d+y38ZQpmvQUvo40M8hJBiEFyDAYvB3n/5BurZ9406xw8Q2NmnPTxAimI
 RG83H5Xp4hKLI7pDOcjFaVFno2v2oK9Py7H7bFxTjG9iriVcQ5rsh/EbfaeU+B27zJfm6dUdTSE
 Wv5wUPfnjtQ1PbO2PQcMv3LUHncUqfGjjGSxBh70mDR7iBIW7oOaT+gaBvleW6H5cXixZaUJied
 WMURMNJS6dhiA7Gl3MgXuNrys0qA1P7uDZ6AbtyR0ZhP7PRR0qg7upKaEIS2HB+iswM3XABPINg
 HjGccG/uU0/nXOlcTyQ==
X-Proofpoint-ORIG-GUID: 2ue5Gdu9UG-_DVrZRSHphWNX7qdOW-6R
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 malwarescore=0 suspectscore=0 impostorscore=10
 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=10 adultscore=0
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602250216
X-Rspamd-Queue-Id: 716311C0009
X-Stat-Signature: 7a8y7ywhh7teundjuqc9skjbnh4jybou
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772059302-231820
X-HE-Meta: U2FsdGVkX19Npqh1zoAVsK7DteC2GvAUFz0GlacisULfac8Besp5GJLmhUjaEZjJtDzPOOUwkKokFULM9FccUPUx6akiQJXPtQQBvIFY8uAcs9i/97j40/kCD54x+x6307M1T9BqIPVd17hneox+6VE8G+NWDGYaCZpDi4JlHcCxaOYs81N//Uur0+OTW0i/QA/FSskVcymQExqX809vbt4JHj0rxC/8vgwm9GWXy7p+aPmCGvXr4uF9RN38ns/EHN6RyNQZUClYt0FmmO7FYocv1+vKrnspUYk11t5KEcuhWTn3isVa8exYr9s6vEGDDBh3/NNzwnPDQI7B7qJko++3D+qite5fOAXFLLR1KJnfdumCRxDrO2v2P/G5GGKmvCOUj0YI/fANyqNkZWDgEnxqK30ottg85EGeVC62d0SBmN/KuKUEGPdlOXGAVVMxhCgB7qYUOFROCh0OcElfgXN9FOoWlfVK2T0fQcQ0oRX419xcuwTUb53r+5x1O3Vk/xRQ7YZTR55ejrpFCYlJ0BsZq7w0TD9c9/SOqbTFiDENimKIOibGHuJVDqLLdiaXZbN6viBoLY/MCNKsq2Kr5qwKhO4rAwK0lmf19VpEXQchgKHKaN0LJlXLwFo09HW+Lx+ktX/u7iWMwOR5coyyF15fueavufJM5hJr7P+YRa9YMRtor+LtR3kP6uN/SIaNI7ZbXkSPwyrxYIuH0iVlcLzKFnnFcHgIS/uJ+VQSTf3aFkAAUDkVma6+CN6GjVGnt1P33CAv9SliDhwIDa9Lfx9bLdrS/fDQ2u0ki/q/X4DT9zsLc4J74xevN6KbKnmVThFX87pUIyhw5ToK8KY5k83+h43VsyfTiP9V1pMgMk3Lmm9yvLmA+sCdUMi78m2uiQA6PBej4kUkld2SLuxHn5+1rEW0N9ma+dJyLAiKKf3Dr1jSVyK/wwPW6CRrIuxRC/RzzyWLbTjOfMlrZQc
 J2/O0ppA
 +JeNUYA/TJG7JHHswqFg9z9LKGIFaSYSUK2VCXmuH96f9uKnMNAcvVgIfGkKZbLhRswJCRFhG5n2p81tFDpb3DAauf01Kwj3DYtaEwVA0+I2EyON3ISAhEOjMK3bYObmzEbfuiwdxCethUnA53TgvJjrOT4mNjIEJCxlVIItdN9TxB/nEsk8UGH4+2+yaN95IlOfN1B615t3vBBJfDZR0meBZoguaAFYeFBibkIs7Yk1HYcOCDOdZ3DG9V7nQTquarro0crWmOhwKuAJyDI9hqqiatNI6agt6Nt922rFRQqbTOB2NnpUZx4//iBwjUL1vqfg8TQNWxpuCzZFGAhtwAXjeI4bo4zAdj22kuPQU1Sl40NU0BKvwX+fFQzkaIe3NzWW3S1ChpX48jjPAfw6/30V1kX74QlhM0CcTwpl4/r3eU2ng9DcwvOrz+ydYzMo9REC25WtJBv6ELpEizfIiqAkU33rZkMKhANzaGHxJZ6WVE6sJP7y888nWR35wzecGgs7BdOvqhvaD0EsnRHCuwn2TsNvLpz9JpX++Mb+928gNTgY=
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

For CONFIG_BUFFER_HEAD paths, thread the kiocb through
block_write_begin() so that buffer_head-based I/O can use DONTCACHE
behavior as well. Callers without a kiocb context (e.g. nilfs2 recovery)
pass NULL, which preserves the existing behavior.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c                |  4 ++--
 fs/bfs/file.c               |  2 +-
 fs/buffer.c                 | 12 ++++++++----
 fs/exfat/inode.c            |  2 +-
 fs/ext2/inode.c             |  2 +-
 fs/jfs/inode.c              |  2 +-
 fs/minix/inode.c            |  2 +-
 fs/nilfs2/inode.c           |  2 +-
 fs/nilfs2/recovery.c        |  2 +-
 fs/ntfs3/inode.c            |  2 +-
 fs/omfs/file.c              |  2 +-
 fs/udf/inode.c              |  2 +-
 fs/ufs/inode.c              |  2 +-
 include/linux/buffer_head.h |  5 +++--
 14 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 4d32785b31d9..6bc727f8b252 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -505,7 +505,7 @@ static int blkdev_write_begin(const struct kiocb *iocb,
 			      unsigned len, struct folio **foliop,
 			      void **fsdata)
 {
-	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
+	return block_write_begin(iocb, mapping, pos, len, foliop, blkdev_get_block);
 }
 
 static int blkdev_write_end(const struct kiocb *iocb,
@@ -967,7 +967,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)
diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index d33d6bde992b..f2804e38b8a7 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -177,7 +177,7 @@ static int bfs_write_begin(const struct kiocb *iocb,
 {
 	int ret;
 
-	ret = block_write_begin(mapping, pos, len, foliop, bfs_get_block);
+	ret = block_write_begin(iocb, mapping, pos, len, foliop, bfs_get_block);
 	if (unlikely(ret))
 		bfs_write_failed(mapping, pos + len);
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 838c0c571022..33c3580b85d8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2241,14 +2241,18 @@ EXPORT_SYMBOL(block_commit_write);
  *
  * The filesystem needs to handle block truncation upon failure.
  */
-int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
-		struct folio **foliop, get_block_t *get_block)
+int block_write_begin(const struct kiocb *iocb, struct address_space *mapping,
+		loff_t pos, unsigned len, struct folio **foliop, get_block_t *get_block)
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
@@ -2591,7 +2595,7 @@ int cont_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 		(*bytes)++;
 	}
 
-	return block_write_begin(mapping, pos, len, foliop, get_block);
+	return block_write_begin(iocb, mapping, pos, len, foliop, get_block);
 }
 EXPORT_SYMBOL(cont_write_begin);
 
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index f9501c3a3666..39d36e8fdfd6 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -456,7 +456,7 @@ static int exfat_write_begin(const struct kiocb *iocb,
 	if (unlikely(exfat_forced_shutdown(mapping->host->i_sb)))
 		return -EIO;
 
-	ret = block_write_begin(mapping, pos, len, foliop, exfat_get_block);
+	ret = block_write_begin(iocb, mapping, pos, len, foliop, exfat_get_block);
 
 	if (ret < 0)
 		exfat_write_failed(mapping, pos+len);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index dbfe9098a124..11aab03de752 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -930,7 +930,7 @@ ext2_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 {
 	int ret;
 
-	ret = block_write_begin(mapping, pos, len, foliop, ext2_get_block);
+	ret = block_write_begin(iocb, mapping, pos, len, foliop, ext2_get_block);
 	if (ret < 0)
 		ext2_write_failed(mapping, pos + len);
 	return ret;
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4709762713ef..ae52db437771 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -303,7 +303,7 @@ static int jfs_write_begin(const struct kiocb *iocb,
 {
 	int ret;
 
-	ret = block_write_begin(mapping, pos, len, foliop, jfs_get_block);
+	ret = block_write_begin(iocb, mapping, pos, len, foliop, jfs_get_block);
 	if (unlikely(ret))
 		jfs_write_failed(mapping, pos + len);
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 51ea9bdc813f..9075c0ba2f20 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -465,7 +465,7 @@ static int minix_write_begin(const struct kiocb *iocb,
 {
 	int ret;
 
-	ret = block_write_begin(mapping, pos, len, foliop, minix_get_block);
+	ret = block_write_begin(iocb, mapping, pos, len, foliop, minix_get_block);
 	if (unlikely(ret))
 		minix_write_failed(mapping, pos + len);
 
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 51bde45d5865..d9d57eeecc5d 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -230,7 +230,7 @@ static int nilfs_write_begin(const struct kiocb *iocb,
 	if (unlikely(err))
 		return err;
 
-	err = block_write_begin(mapping, pos, len, foliop, nilfs_get_block);
+	err = block_write_begin(iocb, mapping, pos, len, foliop, nilfs_get_block);
 	if (unlikely(err)) {
 		nilfs_write_failed(mapping, pos + len);
 		nilfs_transaction_abort(inode->i_sb);
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index a9c61d0492cb..2f5fe44bf736 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -541,7 +541,7 @@ static int nilfs_recover_dsync_blocks(struct the_nilfs *nilfs,
 		}
 
 		pos = rb->blkoff << inode->i_blkbits;
-		err = block_write_begin(inode->i_mapping, pos, blocksize,
+		err = block_write_begin(NULL, inode->i_mapping, pos, blocksize,
 					&folio, nilfs_get_block);
 		if (unlikely(err)) {
 			loff_t isize = inode->i_size;
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0a9ac5efeb67..8c788feb319e 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -966,7 +966,7 @@ int ntfs_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 			goto out;
 	}
 
-	err = block_write_begin(mapping, pos, len, foliop,
+	err = block_write_begin(iocb, mapping, pos, len, foliop,
 				ntfs_get_block_write_begin);
 
 out:
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 49a1de5a827f..3bade632e36e 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -317,7 +317,7 @@ static int omfs_write_begin(const struct kiocb *iocb,
 {
 	int ret;
 
-	ret = block_write_begin(mapping, pos, len, foliop, omfs_get_block);
+	ret = block_write_begin(iocb, mapping, pos, len, foliop, omfs_get_block);
 	if (unlikely(ret))
 		omfs_write_failed(mapping, pos + len);
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7fae8002344a..aec9cdc938be 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -259,7 +259,7 @@ static int udf_write_begin(const struct kiocb *iocb,
 	int ret;
 
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
-		ret = block_write_begin(mapping, pos, len, foliop,
+		ret = block_write_begin(iocb, mapping, pos, len, foliop,
 					udf_get_block);
 		if (unlikely(ret))
 			udf_write_failed(mapping, pos + len);
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index e2b0a35de2a7..dfba985265a8 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -481,7 +481,7 @@ static int ufs_write_begin(const struct kiocb *iocb,
 {
 	int ret;
 
-	ret = block_write_begin(mapping, pos, len, foliop, ufs_getfrag_block);
+	ret = block_write_begin(iocb, mapping, pos, len, foliop, ufs_getfrag_block);
 	if (unlikely(ret))
 		ufs_write_failed(mapping, pos + len);
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index b16b88bfbc3e..4b07dec5f8eb 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -258,8 +258,9 @@ int __block_write_full_folio(struct inode *inode, struct folio *folio,
 		get_block_t *get_block, struct writeback_control *wbc);
 int block_read_full_folio(struct folio *, get_block_t *);
 bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
-int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
-		struct folio **foliop, get_block_t *get_block);
+int block_write_begin(const struct kiocb *iocb, struct address_space *mapping,
+		loff_t pos, unsigned len, struct folio **foliop,
+		get_block_t *get_block);
 int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
 		get_block_t *get_block);
 int block_write_end(loff_t pos, unsigned len, unsigned copied, struct folio *);

-- 
2.39.5


