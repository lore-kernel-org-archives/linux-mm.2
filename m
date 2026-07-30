Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A3DC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B346B0099; Thu, 30 Jul 2026 02:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017716B009B; Thu, 30 Jul 2026 02:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABC06B009D; Thu, 30 Jul 2026 02:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2ECB6B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A3E5806F1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:12 +0000 (UTC)
X-FDA: 85044541344.28.09EAECE
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id C382D40002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=MpKYlVJw;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785394749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlLomZ2ihL9HFxlrx7gRVvKB0MpDdFuMFLp7qf/zQYY=;
	b=D2Ny2DpjQgBTE5LT6h/CkkpBS3NLN6N59lHLA8l4lo5PFVst05JWJ5+GKCBnPICA3giR6a
	1EwqQPX1SAUNp1CigaVmQN92JF0ccGApfkBWeTbHicaPeR64mMjjnuifg/DoXTdJRGE6Xa
	1SazSBONSv2+OFL1xJZj5b2xlecAZC8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=MpKYlVJw;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785394749;
	b=cvyPtnn1zG9urursLvcRE5jqjSDr0uSsZK9+rMcRKLl94zpw9CCaFGIZO6azPxm6b3ozvm
	JI691GtU/D10UIAe2IUoAwryL8FIltujdcHvlassE2DhjdPpahH5/TOwmK1dXx9e57oxHZ
	rRmMENTueVAQ6t/NTeS7rG20A5gLJ28=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6ZLHO1889456
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=VlLo
	mZ2ihL9HFxlrx7gRVvKB0MpDdFuMFLp7qf/zQYY=; b=MpKYlVJwcHKHdws+WTax
	xNY1KC8xJ5UwioqCDfrXm10hsZ38GifYdzzDgdp5k3EXoevWleyY1dFEYtamvhpJ
	nWsGgJa6p/YoSuJF4WIywki9iMXIn1c5Wn4DkpQGgbayfJ6qYYenwE7IR3x6i5za
	dwukXaXhPCmDnx00K9b63BM+126tHcyEXiVmjVGTroLxLwgeaoTkFFz5LrgjZQxx
	gCxc77WryoG5AoO8xqG+CIpVGqcvPcJy1Hre/qmfzNh4Lg+NyHId2TO5o74a17H5
	PMqGOiw2sWKl/vs2sNdLr6yI8HY3DLjU7PD9m6sqBVNHZv4IJI6fROiKcTd5+32Y
	+Q==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqud416ps-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:08 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-930f5da3467so211794685a.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394742; x=1785999542;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VlLomZ2ihL9HFxlrx7gRVvKB0MpDdFuMFLp7qf/zQYY=;
        b=kvOw3JjxDKWpCs3XSEaj4O6Ut2t5wNsfNc8f+rzjuqzkszxRwIdxT653OGBI9VelTr
         +hH8qAf8amAQBYTPUXhGLzAvu5BO97DbcoCfQac3Vjd8gTTByyxxMmNO350iKSsJR/oQ
         RUTQxscIU2v8/cqNhfCFrdlS/cMn2ZHHyPxMJCGTJcJfFjNGGLkUpdeaiLCVqOOV+Vtp
         20oUbrZ5QxAxvNMggbZSLubI1158tLkRdtS7Cf4BQlpWokaM+z07T5elOmzNl//JPXu4
         grfb4D4CoMpo09D4XJyCvrFLxq8iuKYJr44IZnNchEhIjkpolnYAvcVMh2X7guEOUM3g
         kA4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr6HZIB53eT4V5bePt+4qXadeskDWqx4Nihby/h922gbb2fKEt/henQl99HTjWTc+YAabkVAjWgVw==@kvack.org
X-Gm-Message-State: AOJu0Yx0Z7/BNtyUzQpJgpf/wHzYSPpAFAxrIp2dsqW9SZa6GY2eki9Q
	qVFFgLwA6x6NS8P0huhPErXC9b7CKSiUIzVb/ljV8OxC9tB9M1q5yo7B5c9AElSpZOi6z1ofEqv
	wGvPx+/vy1kgRBlu63wHHgzF6VpoWVSpw9FAntvqBpD3LuyGr
X-Gm-Gg: AR+sD105SPL6Sm3jJKm+TrcS9Vmx+FFe5lGfowyVaibpPUIlY6GJQutbmWv8HN6ncTX
	zymI+UB5PZZSrFkNxdkNbJkfwDJQEeg8Z76nCEzcJxo4Uh74m/Sm64yM3WCWmrJaF2F7I7CumI2
	AGPZufi9FjYhoRZA0JgVGnlqNy+tpYs9Z3fZZxTh7KxJhbDad44vZLxGfr6721kzR720H5HwtnV
	ntGEW8JsfRGL23Lc1QLqGWTWcW243hEJIziiexU+39cKjbi7zXMBRyRA1h1qWRIyWtCHlw2idu4
	ONz2OVoUzw9iwjx8cHKLSYfR91YE1ztnezRXexqlNviBJoQsZFOOktqasI+Y8NqzN8N79R3FDeA
	psZrC9dHX5tAakNj9oZx4hJnbW78YDPQGBuazSZEbtrASjQ==
X-Received: by 2002:a05:620a:4728:b0:92e:94a7:16e8 with SMTP id af79cd13be357-93485f9eb93mr142632285a.15.1785394742150;
        Wed, 29 Jul 2026 23:59:02 -0700 (PDT)
X-Received: by 2002:a05:620a:4728:b0:92e:94a7:16e8 with SMTP id af79cd13be357-93485f9eb93mr142629985a.15.1785394741655;
        Wed, 29 Jul 2026 23:59:01 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:59:00 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:53 -0400
Subject: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=3060;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=VqAWR9drHd5aaagFAxsb9cXKpB8GAafaVAD01CXD178=;
 b=vBSV9PuGaob7EwfUbiGv6fypiN4LKkZCFKVdXD+PIQv8LCcBMfs8U5vzkhknkhDiwC6C0Zrx+
 5R4OEUS3RiTCHa0v/202zDRtO2dKByH8pttxUhsn6U5qKVyhcv1ODCk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: P7cgg1C6JfhfSpbwL-scZeAXBUdjZ0HP
X-Proofpoint-ORIG-GUID: P7cgg1C6JfhfSpbwL-scZeAXBUdjZ0HP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX1XtdJpW5/nn+
 UDljpQRQLk6K5T3lfFTkLdemyPDMXok4VMChtvGG/dTnL3qvIN/GwBBeAX6vYr9cNT4lK88ps8r
 l/PQOTONy7B/4jX4MgC9QYkPxvwKsbLKpMRfDGw1HCHDnk6O1iZc
X-Authority-Analysis: v=2.4 cv=b4KCJNGx c=1 sm=1 tr=0 ts=6a6af63c cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=aYi4XJYX91a15INjywwA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX/UCntimHOX0o
 9caKYl5LGmlj0O32uQpf2hGXTUciMF7GRbFNpfq8txcvnkr7k0BYw4IKAaZJmeOhcsXKMCUA7XZ
 qmaklptMnKqmU0NNtO8yBnBXdwhz2Md9O3PjKIcVN2XZOhXArG2s9oC1CLufxJ7slVHYGvrETyX
 mkNWSNsuAFAoUKl9B1J23plDjysYgQbQ5zZ5m+IE5GwahSAeKGjC1gq6s81lYWIAIifz479p+Tc
 zVQ4kBD4Gbo0llAUJ84KLstYoYhpawP+lJSlJj0yCxKUsKpRbTCkQrOON7ymxD1+HCqRhWhgab3
 FzTty+cgQgci/hQJoSS38D1CiMPErUl+NPiWu3QX8GoPDODul9KvPmkjBYgA9hiEgfA5JItzRgI
 G4l1NM/egMVY/TJ4yNdIwmC1MQya0OsIGMUQHxPlKHHHGAzsoS4uHJTHx8UCnyLnKDlg4egHP9s
 2nht8dfLRyOZvCd6djw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=10 suspectscore=0 spamscore=0
 lowpriorityscore=10 adultscore=0 bulkscore=10 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C382D40002
X-Rspam-User: 
X-Stat-Signature: swp8m8cb3aezquz57xo6eshpsby9588t
X-HE-Tag: 1785394749-569177
X-HE-Meta: U2FsdGVkX18MUUvtyAkU/skbIpN0cw/ZLhrR7zCfkfGNO7TItBdtJLrRNJWJKwiqMUNyEnyIzwJxtWkSDFR/uB2mpX60TPERJf8WErtVDM/NjtXiL0Qjw3k6ntdiwAXqXf+lx8TejFZgscEibdxwG/1tUzI3ZA0U11h68xC7QEYrwOmrU3NO3M9PsSP+LqM68sfJh0FXERhHMR83a3ap37cYtr8EcwJ/6CJG6f4Q113esTNeENbQKNEYcU2rKc/rXXO5DOPIcpVTgfQ03tymCMOrgLYXLrhgrabAKZQsTdULnuQ6ZQa1gm8xL6teHj1iAi/6z/dcOVTusCG0GSrtlOboj/YUHo/QvgXujDvmx1n3OgK0To3fAdOPCqYroQB3PiuElDyW1Lo5zrZ7bTt3iSg5iFQ1v37YH0mNSggkD5GZjwUMFAMvAtXNXM/0Y21IQh5+iXnu97JXzZVdTG+YDyC8KFRO5/0w37PyCEv/GW7urdrW9+mIj4e128efUmBK2KpuRYdX8NF9J5lJ1dfP2v7pUdu7lfH49BdCJQzJ7C0iIOxVnYRZKaXUNWxkGNE+whJrXo647k1u21d9rQmT/wgcIxW6TTUuQQoYmDFon0mc37xzX1oBrEpChGMSBeSGXj4f4K7Os9UbfG1iZay9aVzj17G/ucXyV/HwenLDUj4hehaeRYex8DxTTduEJ9U5LD68uwJjWuIm8KTaRZL72KxWyj3hv4NVGwjDgr9VrnADAtXI5gyVpMMph/hPWokFuLamhsJk2ZianCRWiHCIfdxfaAg5vGuqm+a97dR4lGh5n8Y5jX42zxa7PTWRfufZpwrdAlznJwToSbTDrv1gYTsYx6geFVaMzerluESal1RQZQ9yHlRpV87wETJJr7HGNTBBkfjnLlZHN9YDDyc/7k8cMWkH91fZrknnjtxuvB+N0qRXEcMktnuvzSFHh3G70r4nOF0AJ1vaDhwoYPI
 cK26Z5CX
 gW4xZlHJLMil7KHpmbtzztVe4ozqiJzODDVQGPotExn3nWf6ajZsBQBfs5mziP4t14e6Ukj2c9KcsW09veSgTh9aI9k67Y6duWjbmRmmKqNPq4cH/Q7i6JLuSBEvlWC3Kf20mosfjM+F52PLGRw4jCWImKhu3cnPUSzAPpC+8x4Ravav1jqqrkWPsOQQD3PI59VclnClsKx0HRrg9aY2WKfmsGN/6mRTuY4tV4gLQjzJbLisknRCmK+ns20IWaK/YACRX6OpxhAKMxX9k9S3p4zrBTj2+/0aey74YnkHO3n5PEtnTQXNHC9K2s2IHbKFr1q8eT941xUm2Hv/njEl2+RsxxeariNy07vIxgM3HtS9d5Ypo3ZydUaTuYDxd0yfAYsjPF7r6hsA6l1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
is added. This ensures that bi_end_io runs in task context, where
folio_end_dropbehind() can safely invalidate folios.

With the bio layer now handling task-context deferral generically,
IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
route DONTCACHE ioends through its completion workqueue. Remove the flag
and its NOMERGE entry.

Without the NOMERGE, regular I/Os that get merged with a dropbehind
folio will also have their completion deferred to task context.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/ioend.c      | 5 +++--
 fs/xfs/xfs_aops.c     | 4 ----
 include/linux/iomap.h | 5 +----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 30468d51b5ad..1ae8a8fb8503 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -238,8 +238,6 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
-	if (folio_test_dropbehind(folio))
-		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
@@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
 		goto new_ioend;
 
+	if (folio_test_dropbehind(folio))
+		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	/*
 	 * Clamp io_offset and io_size to the incore EOF so that ondisk
 	 * file size updates in the ioend completion are byte-accurate.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 51293b6f331f..cd8de8c82d78 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -522,10 +522,6 @@ xfs_ioend_needs_wq_completion(
 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
 		return true;
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
-		return true;
-
 	return false;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 56b43d594e6e..68af4935a107 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -404,16 +404,13 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
-/* is DONTCACHE I/O */
-#define IOMAP_IOEND_DONTCACHE		(1U << 4)
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
-	 IOMAP_IOEND_DONTCACHE)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
 
 /*
  * Structure for writeback I/O completions.

-- 
2.39.5


