Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296B9CD5BAB
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5E56B00A0; Wed, 20 May 2026 16:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C566A6B00A1; Wed, 20 May 2026 16:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81AD6B00A2; Wed, 20 May 2026 16:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 954EB6B00A0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D46C140427
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:48 +0000 (UTC)
X-FDA: 84788992176.15.BF9F218
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02AC7120002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eki62Gi6;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DYCzqTKbvdRmrDK6yQ7IbYekrJTixKptsXZVS++o38=;
	b=h4yMJlLysvNe6sCSadpj41FTbOQJosQRwBt0yh9Rywy/QHGnFbsNAoJY9IixkgSICsahrc
	GdryIhWt2vV3cSuDxA1FvOkGSTwyczu4x/quUEfw2zCfKavu4HgZfMhdWkANZ6J5PKvumK
	oOE8+qBb4LeL31QZVvLl3TzEJVcwzwY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eki62Gi6;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310246; a=rsa-sha256;
	cv=none;
	b=44WpvWE8c0JjezUZHkBAgNq3qba9Vp7alHxEthbVXbkQayxUMORSyhR0JUNRh93p3Kgxnc
	/1CsJ3Nb0Sq0d0Yyn18MBtqF6pQIVDIf5rjAxCGa4/0uPhDpbF1nwhGCTNDvzfbzxffAwS
	DHpsmf5dpTXd+6DaFkGpz29dXDEc1D4=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO0Bt506321
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5DYC
	zqTKbvdRmrDK6yQ7IbYekrJTixKptsXZVS++o38=; b=eki62Gi6Oexp6jbg0mKB
	+gAM4I9jH4VaSKpxJCUTq5VOpozJJuJEmsBIs1ldLyi+yLxf5Hej4VGO/Rm79ogi
	+lGM7nZwTZcEhSVlPH2b4j3DW2XQtVlZfxaTMqHe6HX0R9B33UVKI6Ch9WH/aaUQ
	/Nd3NrjeKxAgNv3LXFUeLq0RsN+M892JUxkAFcLGaekU5fNmOrLgfABzJSJayjI2
	8vIGmYeIiKBMNyBP4XlLsOzqAS8j5rDWnVmWRqLyThLZQfOzij6SEXn8H7XtLOvL
	g8s4FquNdM6Pizj4XVpgHW8jUFG0aEz+cTOq8E2xflA4i5agkq7SX0iQbwF0R+pi
	Mw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e9a0bd1tx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:44 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9112b2756fbso1258691685a.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310244; x=1779915044;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5DYCzqTKbvdRmrDK6yQ7IbYekrJTixKptsXZVS++o38=;
        b=hL7DdFPMbZd1muAHlgvBkCeb8tGK+/bTneMlXEae3OqRp4uksrAxq8eJKHIBWg++Gh
         3+2r8zwDbMAzyT9xV6mD9hByQCxjEMrYzQSO9pMKaHVPbbTOBA3hTW1ffAjBRKH0sJ0J
         qIr1iPLiFLxMWaUjhggLGMAH7A+mYNn+EY3l5QFrGQGehawuKuJ8DZH96hLO9aPJSgGd
         iPSMEIj9tSY+aAMQPyqg2pUh7Xk3AszR8vkP4+D/R83aNURQpqdtV/LcI0CiDzpPJ3u8
         bs0qqfWyvlSeQz6bR7J3aSkizEjDIRPk0kpqNHyYMWkCZwA6twFWyKqraM7HKG51WzSD
         KKNQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Oj3rLCbMK4cTMnPfDH4ePUV37ntx3G1CTbBGyP7JqiCM8gOjZkhMFwa/gJWQQNKkUMcvco7jMzw==@kvack.org
X-Gm-Message-State: AOJu0Yxd+qA0kzo02eVYc873B6A5sYkB+V1RdNieYQyIihu19IHsvGvD
	eeuVFm5FDJCaxd91681xE1zlhJOBoQtUw88SBsPRe5q9z+HMXEbqpT+Kc/2XJQQzrXt8KRScNEJ
	5tljJAi0D/QeVLIuTh6dmmN4JpdXEEO1e/jbfqoH26cdmEdNz
X-Gm-Gg: Acq92OHCYmRs8AFRYQdnfrtGjTF2BoZwgPc199maZNT7J5y1lqy6Y2+5D+EtFFprCcu
	+WJ4je166ubgoI86TgDmPWykSFvP9mtVsapzUX5TCG93cx+3VLyEUNNFi999EP2VxyxGb4XGH5E
	yKEkuPHjT8H19XJLhqHCqHf2cEL3Vsl4HlsivaPwh1588Cq6f68UfQ0jUVnawST2UtaEa5+bEUY
	2lmInOVvGb/hBmPDLExXEqW859r8PsGIvtlhXB69fn7gKXbnyjsH92WLMbDRk6xU3KPhKEfjxYL
	KI16m61mDFeOFq7AtLA6xV8Jp4RqRWHRSAKlj500vb5p1hRLB1MX86rnYmHODoWLCGGVYOFPWmd
	4KaDoD73JbBwVbaq1qr9zX3zY1b92v2wMXuPajj3EFPqxRMsXigTcHmVNqBnWvlxeKFp0TyzqjE
	A4/w==
X-Received: by 2002:a05:620a:468f:b0:8cd:b70b:fd00 with SMTP id af79cd13be357-911ce330dd6mr4090124685a.16.1779310243986;
        Wed, 20 May 2026 13:50:43 -0700 (PDT)
X-Received: by 2002:a05:620a:468f:b0:8cd:b70b:fd00 with SMTP id af79cd13be357-911ce330dd6mr4090119085a.16.1779310243267;
        Wed, 20 May 2026 13:50:43 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:42 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:49:02 -0400
Subject: [PATCH RFC 11/11] fs: move generic_file_write_iter() family to
 fs/read_write.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-11-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=21055;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yTsT4MTanmPV7BjuSqLOqTfpIoxcx3ADCk+oaTv3+ZQ=;
 b=pnZtz23UD0UmzGK1JF55M8gJyFr39Fbr88g9tveN1RrBZttxjf03za+ECw+z8h1q8W3XU4Gc6
 mLEEtbgMzn2CtlWhj/fgZUlRAzRNrQvC3nKL7GTyYq12T29/MeCqrNo
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: MijLp2Q9Pzv5Y6yGHZHO5w9uPmW4jwpZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX3hqV0JzHvKDr
 qk8oXWsiiAVPh/GRefkM8nhl2iYetHj0CqV7d5A32R04KtrBVNEKZpNTJ3yzGgvLcIqkZpt4PI1
 X8FrTdVzwRU2M4Gn0SSz1uWPFGLoSwjmu4DsAeDIZpgGes6gsuiFYWmF2I9WIXlFeEqqHHHSn5N
 kD75gOI/YPYwnYobOmv2BJbyeSf3q1qzOe8Y+vN7v/Uu1VKHQgaN8pr3lv+DmK+cDHSNRPGxExj
 pRPj6Jpvkr7okL3Hh1jdLOxRmm6pu1pACYa+8CLJtPUImoOXb4UYhYmHHPexf2ddE13fQ6ZklzL
 DQFeJxedmrs67msZmIgHztE6l27DFWQSRkr0vlvlj/46GQXscGq8JqZtpGxPISRfzSjI9kL1t2S
 /N2kQfevwsP8SQc1rBq8qlvEyuTdaegCW5rRCvPJrND3wD0WOZ4/PpseVeMk8h3Ia4i/raCnSAd
 Jjsl9hoxL3+pEL6ZAlg==
X-Proofpoint-ORIG-GUID: MijLp2Q9Pzv5Y6yGHZHO5w9uPmW4jwpZ
X-Authority-Analysis: v=2.4 cv=KLJqylFo c=1 sm=1 tr=0 ts=6a0e1ea4 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=t4iOdaPQC35MTOVVYvEA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 priorityscore=1501 malwarescore=0 adultscore=0 clxscore=1015
 bulkscore=10 phishscore=0 suspectscore=0 lowpriorityscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200203
X-Stat-Signature: odh5j86kxb7i5qmss3gog74a5f7dmcmg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02AC7120002
X-HE-Tag: 1779310245-31302
X-HE-Meta: U2FsdGVkX1/bkkoTKNZZePDXDf5ttXGH582qoxaTuYqIeN/CKtmSkOiv8T/1vAiq25FYuthXYuxe8RsmMQzAev36NUpW/GCQRY5gm4V5nmUJa2s7AvYc4fDVlIj5CixyRN0TGywkPTBNSHUolRgMIn3km+fBJ4y0R++DTnaQCyL7uV/OhoPh1NxuVyC32vdEe6B9xTL1/KoFsgvhLs4M2hj6IjvIkJheVGmPoyS157iEDszFPQ2KVqy6qyxBbahIA9cul+iYmD+/Lj7yAEoWtkIE7YcaXE7SCIasQSGXPstpwV+jR5qbzHPAjgfwOloCgDQKIT1vM5tJdnZ8KtPjmFP9AVhLis1AYrNUcrE3l/rK5PcwdKLLZy1QnxmryYStC1h5SDxpvhYt9DGQqIPwhC39DdSkJw9yxRNIUfYXxXICW8jLvoX1u22MBEP4D4LfsRkJuIPNmzxLDDsZAezlKlooj4IhBxmCwVu5FH/rfk0QYKJyleRVix3O5RIkzMnbQdIYJbEPUdIOJyCXAk/OT+UNWNXH8mP2JI+3jMfDgC4ouk3Cu3r2pbToVhJJpte0uMzDA2HBMDKSYvbMPaS8Rtk8jDOOiXr/+aH7YTDcJtRyfyoVbDQjMqQ8JZc8Dya3pW+ccDITy9g7NSM+g9IFBMAsQ4zVHoAeRbQwDD5HzQTZG7moQUHQSOC6AIV8cWlxxRs7HUpxZ/tSMabwWR2+7vCnsA7jAhszbk+TbOGfp3uoGP+eptLiE9JCy41h45BV5Gc1v4Nci9dTqvG8L5tl/8oijz9R/PINixBiDqf9s9CILfZRZQ/Pr+g6vuXhYVH6accQ1XJr8QTtsZsBKRbtd6/y7OGEg/dhBp8CyCwQCcmg5MqVKS1gKYUvjUkYpLQ1XSSTMTvWZKZlnTOlx0Oppxg6CKdULaqDh5AtyY10gtdPhfLBeRMLQbw3/25VbEBocB3Z7qPI6SSF/GDQFQw
 L4Mh5RhX
 cZJRVHSfSoyPVC7bOpt/JgnxtFV9EZ//FoGzexpyjQxd9MEGbHafdzR8GjMkQONlOnqDrbuTwky1Xy9Za55bknIzdnWVUVnY0GDVM02/goa7Sgk9G6C30g7djuDnaeukdWHsqsx+uJmRg07Kn37UzznHEDssQMmkzjd6mB35HV5QeIdYsG1aEumPxFl3LSk66N75CbvV4kaDIb8DlzvTbiiUxtVo6Vub9JIJHpy4i+ctT3aQ21HU7jt+oXKN3odz0cu7IhIFbWI7mwjvcK6ZY0fVmeW8dB4EQOeTSFjDmZB0WbYvNiAUfP61LOVhJvfSlM7kAaHbOr67czKRj6GpsTI0nGhtwu++B8vKkyOfSQQ2jThLms2ZZFgMQs5yUvNwTWXtPgf3hzGEADDcyAtlIJSGqQq0JdCMowugpI9buvypkGvnGNLAqoNtMsBbWml3bYLxVddsPLN+pfKHgvga9uNeqg0lnPI0V3z8Iz4slMZVwvEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the VFS-level generic write path out of mm/filemap.c into
fs/read_write.c next to the just-relocated read path:

  - generic_file_write_iter()
  - __generic_file_write_iter()
  - generic_file_direct_write()
  - generic_perform_write()
  - kiocb_invalidate_pages()
  - kiocb_invalidate_post_direct_write()
  - dio_warn_stale_pagecache()

The kiocb_invalidate_* prototypes move from <linux/pagemap.h> to
<linux/fs.h>, joining kiocb_write_and_wait() and the other generic
read/write declarations. Drop extern from the prototypes of all
five generic_file_* declarations in <linux/fs.h>. Reflow the
generic_file_direct_write() definition to fit on one line.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/read_write.c         | 276 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |   8 +-
 include/linux/pagemap.h |   2 -
 mm/filemap.c            | 277 ------------------------------------------------
 4 files changed, 281 insertions(+), 282 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 59ceea85c163..cea5f79fdacf 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1071,6 +1071,282 @@ ssize_t generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 }
 EXPORT_SYMBOL(generic_file_read_iter);
 
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+	return filemap_invalidate_pages(mapping, iocb->ki_pos,
+					iocb->ki_pos + count - 1,
+					iocb->ki_flags & IOCB_NOWAIT);
+}
+EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
+
+/*
+ * Warn about a page cache invalidation failure during a direct I/O write.
+ */
+static void dio_warn_stale_pagecache(struct file *filp)
+{
+	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, DEFAULT_RATELIMIT_BURST);
+	char pathname[128];
+	char *path;
+
+	errseq_set(&filp->f_mapping->wb_err, -EIO);
+	if (__ratelimit(&_rs)) {
+		path = file_path(filp, pathname, sizeof(pathname));
+		if (IS_ERR(path))
+			path = "(unknown)";
+		pr_crit("Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!\n");
+		pr_crit("File: %s PID: %d Comm: %.20s\n", path, current->pid,
+			current->comm);
+	}
+}
+
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+	if (mapping->nrpages &&
+	    invalidate_inode_pages2_range(mapping,
+			iocb->ki_pos >> PAGE_SHIFT,
+			(iocb->ki_pos + count - 1) >> PAGE_SHIFT))
+		dio_warn_stale_pagecache(iocb->ki_filp);
+}
+
+ssize_t generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	size_t write_len = iov_iter_count(from);
+	ssize_t written;
+
+	/*
+	 * If a page can not be invalidated, return 0 to fall back
+	 * to buffered write.
+	 */
+	written = kiocb_invalidate_pages(iocb, write_len);
+	if (written) {
+		if (written == -EBUSY)
+			return 0;
+		return written;
+	}
+
+	written = mapping->a_ops->direct_IO(iocb, from);
+
+	/*
+	 * Finally, try again to invalidate clean pages which might have been
+	 * cached by non-direct readahead, or faulted in by get_user_pages()
+	 * if the source of the write was an mmap'ed region of the file
+	 * we're writing.  Either one is a pretty crazy thing to do,
+	 * so we don't support it 100%.  If this invalidation
+	 * fails, tough, the write still worked...
+	 *
+	 * Most of the time we do not need this since dio_complete() will do
+	 * the invalidation for us. However there are some file systems that
+	 * do not end up with dio_complete() being called, so let's not break
+	 * them by removing it completely.
+	 *
+	 * Noticeable example is a blkdev_direct_IO().
+	 *
+	 * Skip invalidation for async writes or if mapping has no pages.
+	 */
+	if (written > 0) {
+		struct inode *inode = mapping->host;
+		loff_t pos = iocb->ki_pos;
+
+		kiocb_invalidate_post_direct_write(iocb, written);
+		pos += written;
+		write_len -= written;
+		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
+			i_size_write(inode, pos);
+			mark_inode_dirty(inode);
+		}
+		iocb->ki_pos = pos;
+	}
+	if (written != -EIOCBQUEUED)
+		iov_iter_revert(from, write_len - iov_iter_count(from));
+	return written;
+}
+EXPORT_SYMBOL(generic_file_direct_write);
+
+ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
+{
+	struct file *file = iocb->ki_filp;
+	loff_t pos = iocb->ki_pos;
+	struct address_space *mapping = file->f_mapping;
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	size_t chunk = mapping_max_folio_size(mapping);
+	long status = 0;
+	ssize_t written = 0;
+
+	do {
+		struct folio *folio;
+		size_t offset;		/* Offset into folio */
+		size_t bytes;		/* Bytes to write to folio */
+		size_t copied;		/* Bytes copied from user */
+		void *fsdata = NULL;
+
+		bytes = iov_iter_count(i);
+retry:
+		offset = pos & (chunk - 1);
+		bytes = min(chunk - offset, bytes);
+		balance_dirty_pages_ratelimited(mapping);
+
+		if (fatal_signal_pending(current)) {
+			status = -EINTR;
+			break;
+		}
+
+		status = a_ops->write_begin(iocb, mapping, pos, bytes,
+						&folio, &fsdata);
+		if (unlikely(status < 0))
+			break;
+
+		offset = offset_in_folio(folio, pos);
+		if (bytes > folio_size(folio) - offset)
+			bytes = folio_size(folio) - offset;
+
+		if (mapping_writably_mapped(mapping))
+			flush_dcache_folio(folio);
+
+		/*
+		 * Faults here on mmap()s can recurse into arbitrary
+		 * filesystem code. Lots of locks are held that can
+		 * deadlock. Use an atomic copy to avoid deadlocking
+		 * in page fault handling.
+		 */
+		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
+		flush_dcache_folio(folio);
+
+		status = a_ops->write_end(iocb, mapping, pos, bytes, copied,
+						folio, fsdata);
+		if (unlikely(status != copied)) {
+			iov_iter_revert(i, copied - max(status, 0L));
+			if (unlikely(status < 0))
+				break;
+		}
+		cond_resched();
+
+		if (unlikely(status == 0)) {
+			/*
+			 * A short copy made ->write_end() reject the
+			 * thing entirely.  Might be memory poisoning
+			 * halfway through, might be a race with munmap,
+			 * might be severe memory pressure.
+			 */
+			if (chunk > PAGE_SIZE)
+				chunk /= 2;
+			if (copied) {
+				bytes = copied;
+				goto retry;
+			}
+
+			/*
+			 * 'folio' is now unlocked and faults on it can be
+			 * handled. Ensure forward progress by trying to
+			 * fault it in now.
+			 */
+			if (fault_in_iov_iter_readable(i, bytes) == bytes) {
+				status = -EFAULT;
+				break;
+			}
+		} else {
+			pos += status;
+			written += status;
+		}
+	} while (iov_iter_count(i));
+
+	if (!written)
+		return status;
+	iocb->ki_pos += written;
+	return written;
+}
+EXPORT_SYMBOL(generic_perform_write);
+
+/**
+ * __generic_file_write_iter - write data to a file
+ * @iocb:	IO state structure (file, offset, etc.)
+ * @from:	iov_iter with data to write
+ *
+ * This function does all the work needed for actually writing data to a
+ * file. It does all basic checks, removes SUID from the file, updates
+ * modification times and calls proper subroutines depending on whether we
+ * do direct IO or a standard buffered write.
+ *
+ * It expects i_rwsem to be grabbed unless we work on a block device or similar
+ * object which does not need locking at all.
+ *
+ * This function does *not* take care of syncing data in case of O_SYNC write.
+ * A caller has to handle it. This is mainly due to the fact that we want to
+ * avoid syncing under i_rwsem.
+ *
+ * Return:
+ * * number of bytes written, even for truncated writes
+ * * negative error code if no data has been written at all
+ */
+ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	ssize_t ret;
+
+	ret = file_remove_privs(file);
+	if (ret)
+		return ret;
+
+	ret = file_update_time(file);
+	if (ret)
+		return ret;
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		ret = generic_file_direct_write(iocb, from);
+		/*
+		 * If the write stopped short of completing, fall back to
+		 * buffered writes.  Some filesystems do this for writes to
+		 * holes, for example.  For DAX files, a buffered write will
+		 * not succeed (even if it did, DAX does not handle dirty
+		 * page-cache pages correctly).
+		 */
+		if (ret < 0 || !iov_iter_count(from) || IS_DAX(inode))
+			return ret;
+		return direct_write_fallback(iocb, from, ret,
+				generic_perform_write(iocb, from));
+	}
+
+	return generic_perform_write(iocb, from);
+}
+EXPORT_SYMBOL(__generic_file_write_iter);
+
+/**
+ * generic_file_write_iter - write data to a file
+ * @iocb:	IO state structure
+ * @from:	iov_iter with data to write
+ *
+ * This is a wrapper around __generic_file_write_iter() to be used by most
+ * filesystems. It takes care of syncing the file in case of O_SYNC file
+ * and acquires i_rwsem as needed.
+ * Return:
+ * * negative error code if no data has been written at all of
+ *   vfs_fsync_range() failed for a synchronous write
+ * * number of bytes written, even for truncated writes
+ */
+ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+
+	inode_lock(inode);
+	ret = generic_write_checks(iocb, from);
+	if (ret > 0)
+		ret = __generic_file_write_iter(iocb, from);
+	inode_unlock(inode);
+
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+	return ret;
+}
+EXPORT_SYMBOL(generic_file_write_iter);
+
 static ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 			 unsigned long vlen, loff_t *pos, rwf_t flags)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c0151ced8e7a..6cfb9e46bc37 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3057,9 +3057,11 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *to,
 		ssize_t already_read);
 ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
-extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
+ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
+ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
+ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
 ssize_t generic_perform_write(struct kiocb *, struct iov_iter *);
 ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
 		ssize_t direct_written, ssize_t buffered_written);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 46cefd552a51..b7c2dc8076ab 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -31,8 +31,6 @@ static inline void invalidate_remote_inode(struct inode *inode)
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
-int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
-void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
 int filemap_invalidate_pages(struct address_space *mapping,
 			     loff_t pos, loff_t end, bool nowait);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index db7c53cd681b..284c0296a011 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2276,17 +2276,6 @@ int filemap_invalidate_pages(struct address_space *mapping,
 					     end >> PAGE_SHIFT);
 }
 
-int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-
-	return filemap_invalidate_pages(mapping, iocb->ki_pos,
-					iocb->ki_pos + count - 1,
-					iocb->ki_flags & IOCB_NOWAIT);
-}
-EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
-
-
 /*
  * Splice subpages from a folio into a pipe.
  */
@@ -3500,272 +3489,6 @@ struct page *read_cache_page_gfp(struct address_space *mapping,
 }
 EXPORT_SYMBOL(read_cache_page_gfp);
 
-/*
- * Warn about a page cache invalidation failure during a direct I/O write.
- */
-static void dio_warn_stale_pagecache(struct file *filp)
-{
-	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, DEFAULT_RATELIMIT_BURST);
-	char pathname[128];
-	char *path;
-
-	errseq_set(&filp->f_mapping->wb_err, -EIO);
-	if (__ratelimit(&_rs)) {
-		path = file_path(filp, pathname, sizeof(pathname));
-		if (IS_ERR(path))
-			path = "(unknown)";
-		pr_crit("Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!\n");
-		pr_crit("File: %s PID: %d Comm: %.20s\n", path, current->pid,
-			current->comm);
-	}
-}
-
-void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-
-	if (mapping->nrpages &&
-	    invalidate_inode_pages2_range(mapping,
-			iocb->ki_pos >> PAGE_SHIFT,
-			(iocb->ki_pos + count - 1) >> PAGE_SHIFT))
-		dio_warn_stale_pagecache(iocb->ki_filp);
-}
-
-ssize_t
-generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-	size_t write_len = iov_iter_count(from);
-	ssize_t written;
-
-	/*
-	 * If a page can not be invalidated, return 0 to fall back
-	 * to buffered write.
-	 */
-	written = kiocb_invalidate_pages(iocb, write_len);
-	if (written) {
-		if (written == -EBUSY)
-			return 0;
-		return written;
-	}
-
-	written = mapping->a_ops->direct_IO(iocb, from);
-
-	/*
-	 * Finally, try again to invalidate clean pages which might have been
-	 * cached by non-direct readahead, or faulted in by get_user_pages()
-	 * if the source of the write was an mmap'ed region of the file
-	 * we're writing.  Either one is a pretty crazy thing to do,
-	 * so we don't support it 100%.  If this invalidation
-	 * fails, tough, the write still worked...
-	 *
-	 * Most of the time we do not need this since dio_complete() will do
-	 * the invalidation for us. However there are some file systems that
-	 * do not end up with dio_complete() being called, so let's not break
-	 * them by removing it completely.
-	 *
-	 * Noticeable example is a blkdev_direct_IO().
-	 *
-	 * Skip invalidation for async writes or if mapping has no pages.
-	 */
-	if (written > 0) {
-		struct inode *inode = mapping->host;
-		loff_t pos = iocb->ki_pos;
-
-		kiocb_invalidate_post_direct_write(iocb, written);
-		pos += written;
-		write_len -= written;
-		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
-			i_size_write(inode, pos);
-			mark_inode_dirty(inode);
-		}
-		iocb->ki_pos = pos;
-	}
-	if (written != -EIOCBQUEUED)
-		iov_iter_revert(from, write_len - iov_iter_count(from));
-	return written;
-}
-EXPORT_SYMBOL(generic_file_direct_write);
-
-ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
-{
-	struct file *file = iocb->ki_filp;
-	loff_t pos = iocb->ki_pos;
-	struct address_space *mapping = file->f_mapping;
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	size_t chunk = mapping_max_folio_size(mapping);
-	long status = 0;
-	ssize_t written = 0;
-
-	do {
-		struct folio *folio;
-		size_t offset;		/* Offset into folio */
-		size_t bytes;		/* Bytes to write to folio */
-		size_t copied;		/* Bytes copied from user */
-		void *fsdata = NULL;
-
-		bytes = iov_iter_count(i);
-retry:
-		offset = pos & (chunk - 1);
-		bytes = min(chunk - offset, bytes);
-		balance_dirty_pages_ratelimited(mapping);
-
-		if (fatal_signal_pending(current)) {
-			status = -EINTR;
-			break;
-		}
-
-		status = a_ops->write_begin(iocb, mapping, pos, bytes,
-						&folio, &fsdata);
-		if (unlikely(status < 0))
-			break;
-
-		offset = offset_in_folio(folio, pos);
-		if (bytes > folio_size(folio) - offset)
-			bytes = folio_size(folio) - offset;
-
-		if (mapping_writably_mapped(mapping))
-			flush_dcache_folio(folio);
-
-		/*
-		 * Faults here on mmap()s can recurse into arbitrary
-		 * filesystem code. Lots of locks are held that can
-		 * deadlock. Use an atomic copy to avoid deadlocking
-		 * in page fault handling.
-		 */
-		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
-		flush_dcache_folio(folio);
-
-		status = a_ops->write_end(iocb, mapping, pos, bytes, copied,
-						folio, fsdata);
-		if (unlikely(status != copied)) {
-			iov_iter_revert(i, copied - max(status, 0L));
-			if (unlikely(status < 0))
-				break;
-		}
-		cond_resched();
-
-		if (unlikely(status == 0)) {
-			/*
-			 * A short copy made ->write_end() reject the
-			 * thing entirely.  Might be memory poisoning
-			 * halfway through, might be a race with munmap,
-			 * might be severe memory pressure.
-			 */
-			if (chunk > PAGE_SIZE)
-				chunk /= 2;
-			if (copied) {
-				bytes = copied;
-				goto retry;
-			}
-
-			/*
-			 * 'folio' is now unlocked and faults on it can be
-			 * handled. Ensure forward progress by trying to
-			 * fault it in now.
-			 */
-			if (fault_in_iov_iter_readable(i, bytes) == bytes) {
-				status = -EFAULT;
-				break;
-			}
-		} else {
-			pos += status;
-			written += status;
-		}
-	} while (iov_iter_count(i));
-
-	if (!written)
-		return status;
-	iocb->ki_pos += written;
-	return written;
-}
-EXPORT_SYMBOL(generic_perform_write);
-
-/**
- * __generic_file_write_iter - write data to a file
- * @iocb:	IO state structure (file, offset, etc.)
- * @from:	iov_iter with data to write
- *
- * This function does all the work needed for actually writing data to a
- * file. It does all basic checks, removes SUID from the file, updates
- * modification times and calls proper subroutines depending on whether we
- * do direct IO or a standard buffered write.
- *
- * It expects i_rwsem to be grabbed unless we work on a block device or similar
- * object which does not need locking at all.
- *
- * This function does *not* take care of syncing data in case of O_SYNC write.
- * A caller has to handle it. This is mainly due to the fact that we want to
- * avoid syncing under i_rwsem.
- *
- * Return:
- * * number of bytes written, even for truncated writes
- * * negative error code if no data has been written at all
- */
-ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
-{
-	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	ssize_t ret;
-
-	ret = file_remove_privs(file);
-	if (ret)
-		return ret;
-
-	ret = file_update_time(file);
-	if (ret)
-		return ret;
-
-	if (iocb->ki_flags & IOCB_DIRECT) {
-		ret = generic_file_direct_write(iocb, from);
-		/*
-		 * If the write stopped short of completing, fall back to
-		 * buffered writes.  Some filesystems do this for writes to
-		 * holes, for example.  For DAX files, a buffered write will
-		 * not succeed (even if it did, DAX does not handle dirty
-		 * page-cache pages correctly).
-		 */
-		if (ret < 0 || !iov_iter_count(from) || IS_DAX(inode))
-			return ret;
-		return direct_write_fallback(iocb, from, ret,
-				generic_perform_write(iocb, from));
-	}
-
-	return generic_perform_write(iocb, from);
-}
-EXPORT_SYMBOL(__generic_file_write_iter);
-
-/**
- * generic_file_write_iter - write data to a file
- * @iocb:	IO state structure
- * @from:	iov_iter with data to write
- *
- * This is a wrapper around __generic_file_write_iter() to be used by most
- * filesystems. It takes care of syncing the file in case of O_SYNC file
- * and acquires i_rwsem as needed.
- * Return:
- * * negative error code if no data has been written at all of
- *   vfs_fsync_range() failed for a synchronous write
- * * number of bytes written, even for truncated writes
- */
-ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
-	ssize_t ret;
-
-	inode_lock(inode);
-	ret = generic_write_checks(iocb, from);
-	if (ret > 0)
-		ret = __generic_file_write_iter(iocb, from);
-	inode_unlock(inode);
-
-	if (ret > 0)
-		ret = generic_write_sync(iocb, ret);
-	return ret;
-}
-EXPORT_SYMBOL(generic_file_write_iter);
 
 /**
  * filemap_release_folio() - Release fs-specific metadata on a folio.

-- 
2.39.5


