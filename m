Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC8BCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 21:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19EB6B0095; Thu, 14 May 2026 17:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA1D6B0096; Thu, 14 May 2026 17:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8956B0098; Thu, 14 May 2026 17:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB84B6B0095
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 556D112072F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:57 +0000 (UTC)
X-FDA: 84767373474.17.57A2461
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0F7318000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="eZyHj6/o";
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778795515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Hr8xytd8pzj0HErDwC1OWfZgJX2Msw8AYmLwQIxWTo=;
	b=12NaDU/TAXqFvy2eSYhhvmicJ0vj7RtxH8MXrOuplb1BaNn5qUsKH3OaNWblwwLiWcmqVy
	9LUFgqgyD8BpT+uILUxeaFrnEYoRP9Nouj4uae+lb5YgW6YM9eJjwCfJD3l2GxgvlqilCj
	IORlGENh6QD0rM12fw397/YG8BsPC38=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="eZyHj6/o";
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778795515; a=rsa-sha256;
	cv=none;
	b=hWEPZZ14EeSVFUobbeTxuLRno0MpgoZWPoH8RNurtQncWBiIK2yoI5BgdRsx66QZE0Wgvg
	8afBl6ybK/7BEq5rTUGkpoocd29FS+kAiGONfzh3cVsXPmJTWSjMhLxiubt27XGcSLwU6k
	Q5YC2kcv18LhRlOD05nWPaPCuNgbPgw=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ELgpCj789429
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3Hr8
	xytd8pzj0HErDwC1OWfZgJX2Msw8AYmLwQIxWTo=; b=eZyHj6/o229FuGb6obFP
	y01//iQN2R10GEr4qVdWRAcKfbBn39iOW7pDeiamYsItYvBz9nE/Pon62/FrHbRT
	ca25JObOyp6I0YgF1LVja0LAoUrXTH8PN4c9FaJLVX4cocBvkgvr8P1/bXRUtYEU
	ezdeGP/xD8FpSO71pFPt2m+7sM8WNaM3qd7Ykfu81marJvVKRJ43F9LEndWsCW/H
	RNqSJjAMDbssaOoJUGGgGwOzvmON7E+wXPvY9wvASbmqJ2uqaCGwOtc7KTVgCX9l
	VxxXI7XPNFK0AnLfKFz1TVkvCMAgh/s6LpNCtKUT3llAjiwNjZdOQCTCQf/Jzy6W
	FA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e5m299h8c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:53 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-91207972031so26390685a.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 14:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778795513; x=1779400313;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3Hr8xytd8pzj0HErDwC1OWfZgJX2Msw8AYmLwQIxWTo=;
        b=HWYzM9H4CaMcHb7dAeLAO3/S4cNlFdujkVjmQEVC+42b3BdhL8zAmMOoeJl7QgsXOl
         CY6rI4qqOCDNnyEc9UgEOSkVKIrZoMFYzD0DZcSCDaBUEc5oM/JUeUd7K/Zcd561lIOE
         RqmLScxDV8wfeNqZPyysmvyM1XSkVujZLqwkp7d56h0gPEF0xZMj4WW2yCT3OQnC5OSQ
         6GsN30GeZp7SjOPP7Q/rTWcD6K801wuSbCcWB1sHOhcKNqn05xGgo8oBBEDZZIPWZJYg
         ohdL+aCnUoh57mMzcvxjQHc0sQzWgEiC+g3iB9VfNdgwBiWs0LDaSnoyQpM15IDrVi/m
         1yeQ==
X-Forwarded-Encrypted: i=1; AFNElJ9HpwWf39jlDwBgtsL8AMivVeeOcfGf3XWFho1q1/bxF0ASzBkJCSQkqAKAYUWQqlfYlICUvks9Iw==@kvack.org
X-Gm-Message-State: AOJu0YyauhxQYOrEfMB8Kt4NWUdTnT5jP4QGHy7xG2wvrhGv2DdLdrhz
	g1Q+cku6k3IeMXWEyc/f5mm+kRI9ExggnO7ftXy5wK1R1osTZysLmkAr0wsWA3jRJxa2cHkLIY+
	4ekSh9aFAaRGU9dnilRledHV5kTujbdjgkAcOLve17qlvl6Mm
X-Gm-Gg: Acq92OErNwtQBcesYvBaxozl+x882TBz+q5e+NxLY/FweQ/cWYXkmfJVRwtQUyjdWii
	OUBmBR1x+6rkbF3or7g7eUdCmJoZbpiGfUK6FvdXlYysS0Ysv3pSqD/fLPzJDEc5+4R3meeM9hY
	O8k2YIhRNrAp3WTWtda+DkuzrmGPzdgKH6W0D24zoubQiRkKUl5XfiGPcJuiI6CrylnAaQx8lNv
	bVXQRleZY1NqXxZFjDLQ+GItDRVqZqQFkWLGHtO9mHoup6dhCtaz/aKP1N6/vAU4QVTUOg593t+
	kEq2fkh1LCINFmT1Xl5RNMnrgJNQe93pr6ItwPjKueTt8dqotj9Z0lLwgajvzyTTvrmL793MzKe
	5fOlyLgd4Y8hKo89+c6r3gap8M9xTRvOk
X-Received: by 2002:a05:620a:2987:b0:8eb:605f:6cd6 with SMTP id af79cd13be357-911d0c5d023mr239922985a.60.1778795513385;
        Thu, 14 May 2026 14:51:53 -0700 (PDT)
X-Received: by 2002:a05:620a:2987:b0:8eb:605f:6cd6 with SMTP id af79cd13be357-911d0c5d023mr239919185a.60.1778795512909;
        Thu, 14 May 2026 14:51:52 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba18132fsm354966085a.6.2026.05.14.14.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 14:51:52 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 14 May 2026 17:51:17 -0400
Subject: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778795507; l=1606;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=4kYnZvc+owx18DdRK+b0WjIntKdQQVbjejy+2ia87ck=;
 b=h/wC1HCfLFItwTEGisusw9jduZm6p1jTrRpV6ed4zqtg5o3ocYnG/8kC6WqedCRsxxH5uzIMI
 xkDRAyq8KAYA0Vpg3tuCs1ya2+fmJNNoRSOmfuMYQk5UpCQHPwkaVV6
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: RGttcEl4SbOSXe2UXrGuh5dAzEDuJMPJ
X-Proofpoint-GUID: RGttcEl4SbOSXe2UXrGuh5dAzEDuJMPJ
X-Authority-Analysis: v=2.4 cv=Wuob99fv c=1 sm=1 tr=0 ts=6a0643f9 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=hW3giJO2Q2g30DqAd_4A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIxNiBTYWx0ZWRfX2Hr3oFv8yxty
 LhjFDVv0V3F0TBrKrSqIQM95Pra3FojnK83z9FTfYHgJIhar2pz5DjJqnB33LCyO5qMvXe31fwo
 teXlgVDCd1M7Gfwv2d6oZ93zzlf3LzcbsQlB/2U4f4LSfTm4m4NqFHrr3Tits7/YQJ1tZHSYYc9
 wo3IVTBnwOKWBjCCT3WcpnvIrPTa6xzjFSno/OkVDQvAcDk/s+rynMd0GXvNZ1RlUp9Z3A//MvX
 GVjmZip3Oiljo1aMcKcHYpRppvsYGzDAs9qrW1BPitiH7RadweW5n7I8vmsos0690y8M8SixE9O
 fpM7bvRzUPRyDdNvvN2gFqvAVjAI3TU40+SNIF6p1h+Q2uw/lrreFlKGJ8HNYR6WyjtL22UoMkn
 tQ4ldL4ajYvRKs0vxIwA1dXr7h4aa6P4zq8QpqUItMb0NWsIWvNH4L8Hzmj/Mq7tinnsC9BNaAc
 XGAeoqzKNW376L54xxQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 adultscore=0 impostorscore=10
 phishscore=0 lowpriorityscore=10 priorityscore=1501 bulkscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140216
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0F7318000D
X-Rspam-User: 
X-Stat-Signature: pohh3ajkmw5d3guwkw4gggctuptauhyr
X-HE-Tag: 1778795514-18777
X-HE-Meta: U2FsdGVkX18a5jNhFNnJY8u+m5izfht9amXWVU5l9fVpj2nSQIuEQ6XBsWuPO65ivhQ/0VmjgiCJFYZYlEgNhkTPNtHvCc/gMVhO+P21p8MgwjLMcsP81o15t4NG1TFFQBAN/XWfVMxqQQlsDSvfnPZWefYVpkYHmm1yopRHJbH5Al2LFAlIZqudZD8IRMAeKlRVvqODXpOFuxSZhvahmP19loma7WSMqlCKmCjN+6WHsshDETCf7bE+P/GCW15IHRaOsQwjvlXh38xilslJ2tqEaELjMFWdeEYExJ/TXzrBin0DBOxEL8NmK3BZYEGJvh8kHUalwittyqPjOiScnukwaISWlw1zFU1QCH2BxgWG+CP54Ymvci7qxORhkYBnzI2XKXzohLGo0eV6EvHabggIPh1YZ6sdGF3zPTdTxM5zW5MFdvtAZRCLEJyW1GkJMNiFMuCFc1sO/AcvLpUVi5hJ95jGB1YbhJf7lL4C5i33MkCwWkO/+a7Jf/H6v6lAtLk4LU1GsSiPsp71KJvsZa5Ph1+Ytr4dZN9/MrsJWncgTFk/xq5/r0aS6fyNiSaH3x4m0wCktFSvnRUH8QZ07AznEVYUbyi5qXjNT9vhaPSruzqhEJB3JMuy4nYYfu+zdi6t3bi8l/19vKBQsi8QXD5bWjD+NdYfONEg4pyxgFTkIiO6aWeIYseufgJ5G3yAuJA1tdkxTkj9K+P+biM51snktsA8FOJStpWwoSOvXqHXpc8lAudPBg+g1uVDbsExsX9DaczcplUU8AfiRG1IVAH4+voaHj2hD8WGwdzCDKDHq27Atq3v9LdbpuhNA1uvZCEQ4ib4CnnS0IkF+909aWCfyuL4QCHlxgqDisLYlbORYerQfn5tc3oVgG21fF+fhZLvsFblfuOv5ZvJ5yy2JrG1/fJ1pAt3QRP2Cjx40pfxmTNXtJqBgsh7BLcsjX6QmCkbMqsGSv+RVHki5NJ
 A6hcZKZn
 5RefQS3iWauWiA71NMow9nS9EhMV3jGmb0LSxn5ZTEDT7IYYNRjE73HTTSHPyaCZOHpnUjc5aQ1+hWeX58OyUKU9lU9RCaXvkDniYMPA74TkDadmF7ubiFHxUPe5YLpGGcMiqKNlVjHqzlO93ywjd5WmMS2eXqq+9rRC3HtOygdy0L9hHrlRD5sMWQGsICXvwY1Zu3abCp65zVgSxB7YBjXUS22q8SJsoQ3bGREnFqaux5uxREgyASoVSBIkBN0TX5bVtdfRayMiTXlb6MwqEoWpkOZE5os99iv4Ln+k+D612xsUCVInCFuiR+zGZVzVQ80zL/vTzDEmgvBasGB8CdLFReTPNvsHb2pGIhQ6isETW5LBDfN0iFkCBRhsHDdau/kaJyqQIyfIxmUQzcEvBWN+6y8DuLZh9/ySQJ4EwAQwGQSDftyOHCvb80g8oI91b98H4EEKWdiVyeJjTiI47sOQoox3aQt6GpElWuIwtC2ZxTJg=
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

For CONFIG_BUFFER_HEAD=y paths, use block_write_begin_iocb() in
blkdev_write_begin() to thread the kiocb through so that buffer_head
writeback gets dropbehind support.

CONFIG_BUFFER_HEAD=n paths are handled by the previously added iomap
BIO_COMPLETE_IN_TASK support.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index bb6642b45937..31b073181d87 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -504,7 +504,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
 			      unsigned len, struct folio **foliop,
 			      void **fsdata)
 {
-	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     blkdev_get_block);
 }
 
 static int blkdev_write_end(const struct kiocb *iocb,
@@ -966,7 +967,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)

-- 
2.39.5


