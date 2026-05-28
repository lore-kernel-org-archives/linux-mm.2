Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACFBFCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66FB6B0092; Thu, 28 May 2026 03:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17C96B0093; Thu, 28 May 2026 03:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D532D6B0096; Thu, 28 May 2026 03:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3F926B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:28:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80E4F14073D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:28:11 +0000 (UTC)
X-FDA: 84815999982.24.ADD010B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D9D912000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:28:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgJkJFPY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779953289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEeN37H8h/7BFZlOijbo/XwxvG5JbF06mBE8+arc+so=;
	b=1KS+cNRhaOSQFrjLPSpuTlPC6lAmaH23PLvs8FkxmPDm2gUmqHHSsbOKaekYHCq5l6/v/y
	QoF8k5GiYGNi0Ybnq21ZHELGxnuMpxzcH+J3RQYhaWQNK3F56urUuwITKI37avuihYj2rM
	Q7Sl1dewkU8/WHilFOJZWyOvUjkDZ5Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgJkJFPY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779953289; a=rsa-sha256;
	cv=none;
	b=yQSp6mRugRA1BPaiTGRfZ/rhF2KXwVSF2uRVieecsVu1pcuwtMp13ZvgRzojnZMvfu0S9S
	2eYT7mHFhhaPKnsToGeOy2YuLdNohf84dz6Xo0EUTtx7Isp0YP+uwcD91FywC69oSOed6C
	zpgpwJVQVqEqu7yexrDDPncXAKF0I1c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78192605DC;
	Thu, 28 May 2026 07:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B714E1F000E9;
	Thu, 28 May 2026 07:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953289;
	bh=XEeN37H8h/7BFZlOijbo/XwxvG5JbF06mBE8+arc+so=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kgJkJFPYhHjM8mv5iClIhg36up2oojmFtfnY1wVYRTJ7/24fTpLlPxNEvEAw2+Yhd
	 iAe/SQOAecbd6x3iEdLDZvS2Pc4lkTxiGn/D/ZjU5qg28/N02o01ou1wPK2BF2pwBL
	 HsnywiEzFWCAL7TQpPPCyHE5H+ArLHrVXrEd3W7mziDAXwhg+36pdITWg8amMaEpz2
	 kYS/x8midsVs+mPfdFZg/NKhhtUlsTgrL5HtNZC+emHlaWvK8g3ZopY0A3i/ernUkr
	 TvEyA6prgpTW+YFYTApj3ZT43BgMWtJxcmBeczun9u1jEjfTO7rHLM6UvTt+oQamRJ
	 cxGp/OeDwhIvg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 10:27:56 +0300
Subject: [PATCH v3 2/2] raid6: use kmalloc() in raid6_select_algo()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-lib-v3-2-feccddf1cb6d@kernel.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
In-Reply-To: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: j7sote4i38hzrsjjczhbeigj76bw3h4r
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D9D912000B
X-Rspam-User: 
X-HE-Tag: 1779953289-408935
X-HE-Meta: U2FsdGVkX1+6pffd1SwCjIIBqmrn64EE2xxclzOt/t6nWGaVKI3zLowCPqVnXt3ZLwRHlppBBdCpzJnMq21xyBuxLKLAHRE1lQXPw07DDIlp39IGrpMmBEu4e82WNdgVNJGtoJrGTym9HvrXxJvUqgO5ht4W3YJd6t+DXYwMjEKsvSv68dXv62vaqJqHx1b7QuPCAPmyGvlgchO5YviC5l718l3vRvztXpsemQEgFERR9UP+0V66KAJcuOM7XVo1sfbE3Al+YUPMlbIg9I6oJlOof83qvCqN2gaidnO55aG+wB9gZ5EWfOcqfQ9CKje/T9d5WxuGgqpa+Nszta5cXS9H8cU+UPuXuBDBLZGtbf4nr28wFYxpMetBw10RZb+Sreb0EYjBuwm5xNgHEuvMa/4zb3+sKi5wnPVaiJtJtUhDg51BzUNeYDqI7nwOU2ZFtJsoX03Uls+lgcNb78P4Oui20xMnc6tzkTiD+C3HjfDrMmn+5ecbh5J2KGCFF45tzyYR8gs1E6YbzwcTmFsuH8NqQO4sbgPsQ3lkSv9en+zKpBBVjddak1Nw5pAocMEJsnE0YELXyVOd5MV2m+2fjK5cR2LGsGSFf4g9q3N8mUXnHW0wkyOJy7zHRDOCe+d1Y3zmNAhcL6NKTNNfFaW7Kd/SCbnlmBcK27f/xOZ3Ott6iFOmTNlnQBTzzAC42sTmIlGnnv6S7pFKNu0Dmhi7bh9aXlq3Kg7QX1+Ev3fO8cG58vFdFkVEKUi1k35V4p88zmOlmgsh9ds5ZQyxouB8F6+Kun1uoPbA3koAyRN0VJMLJ+XNScSH8Lraf/s8Ijd++H7XHZ9u1ZEARD1Dc24Flg+XiHbR8VtyZcCiJK81N513g8s+p9kNrN/hcuecc6nnwqQ240DBtloJmx5/BAKX7i8N5AsxMH1kz4CE5HgSBlzpf4+FoTilh5mP51ZaEab597+9IScLHx9/L9/lno1
 rtWJKTBn
 ColJDBCEaEpgRU45gg28UBuzep9vf2RJzT359ILVQA4UV6LMFign7F+AO0eZhcidmqSNjHmmey5LyJd01JuhTem3mQHGcoDuaLIJrJaA+pyynrFXXut2hj4onbJEsLduAKc620RCe0KmoYUMlcMGabIBdNYNw99n4tvQinKlxbh3osqNTLkiB5mns1P2GELLrOQa9l0/wq1KruzwYUXVXCiIsUifqK2EcqWXe88r7El+j6b66xGdFF4uw4yYQqUdD+ikIHbP4y/3yjwKtKe7WHU9SDfkpceDJdDmfIjWPUaPru8D+uhclVgJnSs8NEhiQGfpTjh6ueyHOlgWQKNb7nY0iuZz9FJe0vphEaByiYsYdPJUJhRolCQBXtAoZPGWKP4I6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

raid6_select_algo() allocates 8 pages for buffer that is used
as a scratch area for selection of the best algorithm.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API than ancient __get_free_pages().
kmalloc() does not require ugly casts and kfree() does not need to know the
size of the freed object.

There is no performance difference because kmalloc() redirects allocations
of such size to the page allocator.

Replace __get_free_pages() call with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid6/algos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..89e627c62e30 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/raid/pq.h>
+#include <linux/slab.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
@@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #endif
 
 #define RAID6_TEST_DISKS	8
-#define RAID6_TEST_DISKS_ORDER	3
 
 static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 {
@@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
 	int i, cycle;
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
+	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	kfree(disk_ptr);
 
 	return gen_best && rec_best ? 0 : -EINVAL;
 }

-- 
2.53.0


