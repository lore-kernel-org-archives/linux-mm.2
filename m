Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F47CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B518E0122; Fri, 24 Oct 2025 23:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F080C8E0129; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EC58E0126; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE0208E0122
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74C5B89667
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.10.CBD526D
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id BAFBCC0006
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dU4BDnqLNuiridBc2n5GQUGyyFkWf3dsN71XRaRHkXI=;
	b=0wddCtM2zc0Gweq/CX4V01wEaD8hlVnEqe4Od1eXnXkuzWgQFJgSJXK8Sk/xJCY425aejW
	DIzRw/ByQwLCrgsqUVY69DakZ2EOqXPVmbzKPbNK5wsyzl9//tdkDtNB7/BzefNJuywlpS
	y8FNBKYrGWrHuhqAg83djHRtQRzJYeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=0XyLYoFWb4RIxPtm0FXufPQPgYmxgHMdWS2h0ca/iy5T8sRVJiRAX6tvuSwiNiR2b/SuAZ
	Vrj9Xx9qn016FEC5lxYmCcyo6F6c1CppdVsq+syAdSIo/nuvMyM4O3o67oy20dWgdx/Wa5
	7a0aHQZVeFlQvC9sgdgd+bMtqQ9HN7U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcS1S2mzKHMNW
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id E2B821A17D5
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S11;
	Sat, 25 Oct 2025 11:30:03 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	kernel@pankajraghav.com,
	mcgrof@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	libaokun1@huawei.com,
	libaokun@huaweicloud.com
Subject: [PATCH 07/25] ext4: support large block size in ext4_calculate_overhead()
Date: Sat, 25 Oct 2025 11:22:03 +0800
Message-Id: <20251025032221.2905818-8-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S11
X-Coremail-Antispam: 1UD129KBjvJXoW7uw4DZw45Zw13CF1kKFy7trb_yoW8WF1xp3
	Z3GryxGrWruFy8uanrWa9rJF15K3yxGFyUKFWa9ry3urW7ta4S9ry3KFy5tr4xXFWxuryS
	v3W5KrWfuF15Gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I6gAEsA
X-Rspamd-Server: rspam01
X-Stat-Signature: 1w1ztfswrzr973x7nur3k3tggdfhu7ws
X-Rspam-User: 
X-Rspamd-Queue-Id: BAFBCC0006
X-HE-Tag: 1761363007-152385
X-HE-Meta: U2FsdGVkX19WWEj11QC8d+EjP/WeO6mIi6vPnSShlHXMrcTXtIxvJ6A7MR5D6H1SQJUyJ2Ww+k29BjHTUzcC6iHX9ZZtX5ZjnUlHLNOOjgm3G8iWBPDeXOhr+bY+BlTaUO5IY0hkCYdlKnX44vQJCtYupv7WQ1dOVNWHrBh5pVsVrOAim47s07uiDXijpRWusuJXriM4k5i4DfHeLXNy91gL1ntA1tZU3aDaKgNoyfr/kjyN+Iv2kPtHTiDZuYzC7L7BGsAax/u30LEdORxgHo22550+eagKj+i9Vj/F3nY8UIZrUy2D8H70r6hP6AGMu5iVPFDZWxZdKZTGZzjkfByELnineYLxosz+uFGcEipQoM0UBBScroymO30fd7QntnB1hjtZKJF+JWKXQeme1bMAiBO5hogTZZZjpN2KifnlmdKv6PQsTz5ZvbTT6wQDTWlyXkI+PiAl44f4W6uEu3IKx8MyJjQLwsGBr2qr73rrx45aL7Isami6jerQgf7kj5KNvACSdfujNVv/UOugNFEx4DvKb8+E2dOsi6a1zfix+EJ7K8Ry+POOC5pf8HoyW2LGL+kK3ObRLfV41q6h+8cZgM1/AkMK6faqRAQJnewd4iMS8zM2QreArUutp0Jmenq/21beRJSZaVvvpRKg754CZwSq665U/YiO4MPX356Q+LH7cgNcTNycmCsFQqtC/Mey22T10SKMYF8lHYn5avFmd1ik2KFdZaclGQlAY3wIjMS0AdCqDmQOuCMl2ZDWVVP0UqC1vVSJesC3tbObkvdmIyy2lMr6nvGogaXeubbWOfsDzLZvBvOiaKXkGM/ex3ChDb4hQbx3iDi0JvMaGLSVNh75BQAEQLVxsOVY4A9AiOKeBxsrP/x4wMJUszEKr7PBUIfNy2CFGlcsMWUWc1GUAV2sJfqGYqmWcf2xMZxOZGDoMgAYMmQlI3JyyMHOxLlm+ywIpXUANJtXKw6
 FyC4h07h
 VlQp3Sg/Zza1ts0ZzboGIFwUBwlGSB7aIutpSPSMclF5IVFd/vPtujiGCA8alxD2la9KxJzMgcWF10c691hBvqMxk3QybAerjrRtghSb5Tx9SDl/zYr44fAeGDXLwKpX2MQNmuGs3Av0Cqx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

ext4_calculate_overhead() used a single page for its bitmap buffer, which
worked fine when PAGE_SIZE >= block size. However, with block size greater
than page size (BS > PS) support, the bitmap can exceed a single page.

To address this, we now use __get_free_pages() to allocate multiple pages,
sized to the block size, to properly support BS > PS.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d353e25a5b92..7338c708ea1d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4182,7 +4182,8 @@ int ext4_calculate_overhead(struct super_block *sb)
 	unsigned int j_blocks, j_inum = le32_to_cpu(es->s_journal_inum);
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 	ext4_fsblk_t overhead = 0;
-	char *buf = (char *) get_zeroed_page(GFP_NOFS);
+	gfp_t gfp = GFP_NOFS | __GFP_ZERO;
+	char *buf = (char *)__get_free_pages(gfp, sbi->s_min_folio_order);
 
 	if (!buf)
 		return -ENOMEM;
@@ -4207,7 +4208,7 @@ int ext4_calculate_overhead(struct super_block *sb)
 		blks = count_overhead(sb, i, buf);
 		overhead += blks;
 		if (blks)
-			memset(buf, 0, PAGE_SIZE);
+			memset(buf, 0, sb->s_blocksize);
 		cond_resched();
 	}
 
@@ -4230,7 +4231,7 @@ int ext4_calculate_overhead(struct super_block *sb)
 	}
 	sbi->s_overhead = overhead;
 	smp_wmb();
-	free_page((unsigned long) buf);
+	free_pages((unsigned long)buf, sbi->s_min_folio_order);
 	return 0;
 }
 
-- 
2.46.1


