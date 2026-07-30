Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB2DC55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39C9A6B0098; Thu, 30 Jul 2026 02:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6C46B0099; Thu, 30 Jul 2026 02:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AC66B009B; Thu, 30 Jul 2026 02:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E56E06B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A3A61408EE
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:10 +0000 (UTC)
X-FDA: 85044541260.05.3D294F0
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 814DB1C000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=i0qRx6nS;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785394748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wwzdh+lefzQ3Mewr3ag7PKLqaiugNuHuZ6D8zRZNNZY=;
	b=2mMG5M8gi19zOg9eacM8RUpMkxfbaVhvsS0T5ln+cTlPGHLzeLoAvs8snJ9QtqcGqTipeL
	RPGeZWUrXSiPKYMpCbJEWSwQ4EUKvkNZGT9v1r/X43vw8PxeA7gkaIOP6oiHjU3I/Ev15n
	0pGLKgv7q3oIqnjLofaUWDfp78HDARM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785394748;
	b=D77Rz7fcp8zLDGbKsofUdACTQx0ChvGcHQke6sXYfkzwrHBU1kh9QTr5Kt+L5aNYkzq1NS
	tZXzpe7WdC1onr3r/jsAzApWsvHiwN15wURVpd7MdMj2CknooTq9p7H3NtCkp8ni07w8q6
	XxH5WhcVwlx901CHOGINwsr+khFvezM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=i0qRx6nS;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6ZPMH1775538
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Wwzd
	h+lefzQ3Mewr3ag7PKLqaiugNuHuZ6D8zRZNNZY=; b=i0qRx6nSvdRp35M11yLi
	zCDL5833R4xWz9ehYcDjCN+iJy81EVfUbRN08bHwKN4Sv0jCdbucXr7pPAXPrQxg
	1n32YTlFzi84Wr18ittxMIrJzVdRnkygO8LEM7xlODihfBD+KKpFhVBicsOyZBR4
	JD+7PIf6HomtCv8bssHFR2jU/sxf0CVVHqPgBDVeubE9hqpuQG2Q/5k475unjLYu
	leSSOvM4xxdsLdk3pxUwcrvIJrrT21ENuMSN5TaP/FL7OVtRqYOQU+/M1DKF509J
	66cfLiS/MOEbOYUmN638Fpjn7j7NmlsYIk9r74XBJWePIIUuy2ZYsp95KPo8t/ry
	nw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqrjxt510-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:06 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e55721a8cso206359385a.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394745; x=1785999545;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wwzdh+lefzQ3Mewr3ag7PKLqaiugNuHuZ6D8zRZNNZY=;
        b=lOQnMx0xvHDsBex/mnRymmu0eeybG1NfI9LQt5AGGuAYoPamOf/03trdmeOAcARvCw
         ZPsCEKn+UU1/bsnq4O63J1tLNDOWz+6Blgx5TSngRcwzuMCea4555M/jGCpyzXRcqWAK
         FgIUl6T1OPDeMKRlcVFG2sfoVzTfyo3bMtM4wRul+Ev5gD4wRg2lMp4bbKoNTPe++h9N
         q9DBVlzthhTTLmdzhZiMPjm956bLPkSTBDzYGYrkn77A9YP1cKMlowEKd+Bkv3a8AvFw
         2oO05ETdLXho8dbGLRjgEkLRSfqBk2k9pIz03fyIM7PGl1Dno+81IjMzwlGsEP1WwF5F
         2aTg==
X-Forwarded-Encrypted: i=1; AHgh+RrXbI1rav9+foc7D3rweUTCvB/sp0Q/8ihSEYEz/sAwdLWrY5dIwCO7f0+cC0Z+dpWNLVTQDXb5CA==@kvack.org
X-Gm-Message-State: AOJu0YwcBYXrj7GwDs7sxQnt9fFJsee8mvZYm+/pVhTvwnPhZ7BGmmPd
	WgUGh2WvK+ToAI0citCba1WNTko9ZaRVd3KGdaKwytOi3qs8JNyJnxb5yRStjUSn/b/f73MxY75
	w8Ua2LRZ0v3LIz0q9paFaWYfucuUNSRwtxuMqIGS8HeascTva
X-Gm-Gg: AR+sD11lqwCM0vVwYfVNYjgnyVKDyoNaUtYpgKc5Fpuz5tQlQZoNlJqjJZYdJirvy3D
	H289jhqtwdnbg1G71wrPLMabit/ByjggvL7Nu7x3cWkINHIxJ8v8WrUhxU1ep6CKSgArhjWQXvj
	03fLf5Qd+lycjOEbV3JGQtzdwr0PASuyZ4e9iauaFXHRHTbeJRsGQyFNFB0jUrlySD0oZA+lhaK
	UbhCksLAYj8HxHzUxgUnydfoGSr8KgCYo2gNrcIC/FnTnnKCDDmKZjlSmxwJZu/mChT2ZpmNcS0
	jHa4OWG+fGCv6IvtIAieZ38BNimDaDPxZK7xHstyeZqPSKPjbROvOm9CHdWeddrcoZ7UefMY75K
	XOKDbgmsQ7J8VR8j0xGkWiOwFGd1kOU4wO0XhYCxcmBMoSQ==
X-Received: by 2002:a05:620a:2886:b0:8cf:c106:faca with SMTP id af79cd13be357-93485fe35d1mr140938185a.36.1785394745168;
        Wed, 29 Jul 2026 23:59:05 -0700 (PDT)
X-Received: by 2002:a05:620a:2886:b0:8cf:c106:faca with SMTP id af79cd13be357-93485fe35d1mr140935685a.36.1785394744677;
        Wed, 29 Jul 2026 23:59:04 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:03 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:55 -0400
Subject: [PATCH v7 5/5] block: enable RWF_DONTCACHE for block devices
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=1234;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Tk8jUyrOqQ7WXa1eqV1nq7SPxnPRM7zEp3j/WZJSWC8=;
 b=os6OKouVgqku2jRKGVaPk1noDMT3+eXOUJzWQsRazIMJ1bPae/JGJpIYkqGCxir04AYNo7/bT
 w+Brhzebg6AAvdsxWkzbY3bN7osSNAQdnJPqVkijmqj/2VMhvYhfElf
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX4er/+OmiIGPx
 Sntt5oHn+Fuycx7iuhwcYUrHeoL6xVUsH/gGFp8QnULXpkW1IZAi4lXwvdjFVc6IeRALwyxHUxQ
 1Wyo2LLY3w5tbxisrRy5L22E5KgOGzUYwaANtHqaRDi6TdnV7g5G
X-Proofpoint-ORIG-GUID: ejLwzEc0PIKjt-SeWgMDi3eqhS4eYmem
X-Proofpoint-GUID: ejLwzEc0PIKjt-SeWgMDi3eqhS4eYmem
X-Authority-Analysis: v=2.4 cv=ObCoyBTY c=1 sm=1 tr=0 ts=6a6af63a cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=J9_MS8zF8NN3zyd_QTgA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfXyxoJaoVAY6DY
 HNIK8a3/xg/NGLaO605CmL5SAnQgz8QQieKNLq5DBSCTpD9eIFLQMyJaYOLpdGr4XwcDEGAMsKB
 nEpgRkvaz1PhcOVJ6N7NnxRwAYPqPbqXsgzOAE3KJan38EIDYfQYfErOlGsq5tzyrdwtfQOjVHb
 Av+1cDNqmWm6bFm0byW+gtvx7InF8VQnnPmnLd7PsWlLAYiBUK29EeXZjZ4SPp0KsbVVXP9gNPP
 XBpXVeX4N5Lq1tEYbH69KT4+uJJ5mg/rRZWkvUAULIFeoYdjjFZcfZKUZMP+IfvpyGDtcUq4FFE
 9k/Un/sFT1EPtbbRNci3ulDrmq8i8aa45bP4zfXbuB7eWuZ74966AyRXsG9TJOYgLa1sFH5x30X
 Q7IIHMdBowWU2cA8We2Rv22nzl7yIVeK17Ked+Q5cEFQ1ABhcKFMPZyBAinH4d2qL7gfaewEnUc
 GUje/S6XIqKYHD2A4yA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 bulkscore=10 malwarescore=0 impostorscore=10
 adultscore=0 priorityscore=1501 lowpriorityscore=10 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300048
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 814DB1C000C
X-Stat-Signature: hmyi36eszt1gzmu6adiapztoekixg3zz
X-HE-Tag: 1785394747-385835
X-HE-Meta: U2FsdGVkX1+cUXdOquKquLapfFMVGERvLiUG2t9TaZz7gPlRdRv8HTWnt4LfuggWObRCZvJ74zuBi62ZUFF8VkABEBEslp3oTi3bEklv1IaA8YSmF1HGT6aZP1UrKhkHY+EGkU7n8vLCpNLkRtIvI9FIhbTNJn4r9Xh8tEuO0b+dNUK6KO41uR/Ur2HjXgmaaUoGU2f6lEXbl7Lxkf1L363woZ8dioJripxy0qyzNdbzCnGkwNHR52yytEPJ9W8cJX7ipCbWy8Zy8oguGyQseOzV4o3bP1PVbH28tnulYXltvWUrvWifoASUVH8IzNzoNx7MS+drGAqvyfjYM/Xc2ls4oNJt02ezQpPYHojWZCTO74FdF0f1dtVSSKeXZDZrPhQroEBBliMbKjE/jibpPLlDZ6WmZPSuZPDDPiQLDTu9fDsfjjsNaeM3PPoCOGxIdNncPNUAp64a9LFRUgMYXOH80FEATlg0KUUzySSndPYwO111NpXRwTvpJR2s1a2YPu8UqnhcEIn7bvyYdgsRqVMcZEVUbQeyX6mq6JR2MlMEoYtQfeVU4N5soDI0L5vsPC0oFkHakWJnj+HXFO/kZschc37yR6uD+H8Cpqx68n/LmzXEcX8WIlbjyJ5thUCOv57LoQEFMHwcJ/YmDviSlbSiUm2S8Ai29YTn+NCl8lhg/1dEuVUQ0bjMac1vSl15rErWLV8oAL2gDSZoJOiJTwxcetyi5jLISq5IL56tQ1HXGu7n4vNao7FhpOgnfOvbf3oQBQv6qnDXNLwlWxBECuFwgjQ7DTUkvS8nxcTUscYYcrjMwNGJjt3uB7sBzYEXeTQaY+MwLok2U5ktfqmClPP+Nowl6TXwToOI/3Jov3HR2N/QihWVIDDajzPIzwmmJ35KyLNEUqfcbbKzaxm5KVA42oT0yrCZijhPM9cg+BkfPs5wajAde9P7kQMdpmCOPlXubSPx2ZF/2mfXaB/
 kfjJvbxT
 2DUlPSvH1J3lNteY4KicNrxmJWJz8OpUt0hKOImQvrSVHHBPjyThtALZybj+bA+yfl5qBj18CUPQWqG98BtZby85mS3DqYuDbwt7iV3XvYgaHVUj6yxqfZ5LNQsH3ismm6f7aDl4mQPJf94LheXwcjitxM9EyNereua/Tpiwwjm4Depzi0qlFS9MJZE+Ec+K4+0auVrlGqaF2ZZUGg8wDUIPPwn0rxAqIj/W2YsmTe/+zGJ0wNUUGhVsNBcpQXdBe+RQ4QUvH6UKooeI01B1C97kp1pzHe4c4rNBek7/KAPOML+nAtzKM0+YUXfJ0YzGVxATf2z18Z1AMkssVWylH+3PQXC7vXTnv8DgvEmZkUVkHZZfCRo1cHc0PBKHYoOxsF1/gURWlc+IrGHE=
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

For CONFIG_BUFFER_HEAD=y, writeback goes through buffer_head's
__bh_submit() which sets BIO_COMPLETE_IN_TASK on dropbehind folios. For
CONFIG_BUFFER_HEAD=n, writeback goes through iomap which handles it via
BIO_COMPLETE_IN_TASK on the ioend bio.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 15783a6180de..8b39c53b6393 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -941,7 +941,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)

-- 
2.39.5


