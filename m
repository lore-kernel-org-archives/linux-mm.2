Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C843ECCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95C48E0133; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD04B8E0132; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE7B8E012A; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F16C8E0126
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 581E416032E
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.22.81BE6DC
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id F223B40010
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdNbp7mtwYMwafD79sSb/Xjr7JW5xqgppcDMFg/WSJk=;
	b=s6NmTEVpEdjSywOQ4vo9Qvs/kJibhSKwjtscf/tXAg3ojJBqd9Byx7nQQio11fTHO/MP4B
	8t0OvcOn0tuBzyGv/2zQ2Hnsvbp6OtwV4DHjQ7BpJKIPqp8z281zqvj+xJ6FGGBMkld5uE
	ng9RZkhllW9H9Vrx8BjJHMRqeYth5vM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=6V8HI8phjZNm5Hfa5FaBFtM/6vCVKMlYCR9ZbiepyEOGWrSRAEWBA22sV7egToUO5tTgj6
	hNyXVVrPrT+NM/oPWiQSgbd5byHT+j8bmkXssiwtgcrz6r2LYsDlxRlTdYs3mNhSSC6MSs
	dGfz65I+RK0RGGftUawutJjI98MLTVw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcL12JHzYQtq0
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C3BC41A0E6B
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S23;
	Sat, 25 Oct 2025 11:30:04 +0800 (CST)
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
Subject: [PATCH 19/25] ext4: support large block size in mpage_prepare_extent_to_map()
Date: Sat, 25 Oct 2025 11:22:15 +0800
Message-Id: <20251025032221.2905818-20-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S23
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw48Wr18Ww47WF43Ar1DWrg_yoW8Wr1UpF
	WrWrWkCr4fX34agFWSgF1qvwnrtas3GFWUJFW5tFyYqa45Kr95urWUtFn5ZF4vqFWxAryr
	XF4Skry3Wa1xJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I7gACsC
X-Rspamd-Server: rspam05
X-Stat-Signature: jnkzsoccgirikcaa5nb7x85h6zhjdwij
X-Rspam-User: 
X-Rspamd-Queue-Id: F223B40010
X-HE-Tag: 1761363013-739812
X-HE-Meta: U2FsdGVkX19TMyWuXTzWbuA63uih/3QyAszJNzwb7SRgjhKD0CcpgJDc4afctzO09n0t6N7EmytcvglCyNuScLF6ugMdCKNoH/ZN5gmWxfCOHmReNDIBdS9C7EUcmmMOzDmscG5vJQI4yA+is6cqo8gods+qS3/67w2Q6sNfbKjfnHM+2NoVUCvKAc5VQ6umZg4gn8ecozcxoWQFFRw6YZW0Fw2JexANyAUYM+q+NAmrYGpBUx8r97ZJ2k4Lt8kYxEt3U45BQLufnv/k9gP+Iv1R1STbXSFs41IJrUtTSUVXaPl5PsRFr5yoip+HFAFAlO8jqpg5vUM56KHgA9nigI24vqgiKkOTDIhbXYoBcC0z4Ouv5XybcIBp/v9k61InWekOl4M/73WtmmtCIgVBartcG/5Fpjp+pD/iuaws+JEAch08fG1yahZ/QKggXIQeKkRRbHYiEmJ6XzTJfK1PHwk2DZjm8icRLVSfRawtpeO3J9vliOceHXg49HM4y/NAx2u1L/JQh2o68a2ZIektWMEjPcVg8+aVeu4YdUKJozbWbpiwrM/y//kWPkNTqTmN4hg/GWzM5BHF3BKuidzhq17YxjEe9T0G3CrgKN8r0jhu6xCnqC2Z92BStrt++8/v7FmJBwWXE3zJ3NV7pk2K6oeJWD101MMFAuxiGV6CjN5JDN2Q5hM4WZmKjZ9NlYUwWRZBZAL3MjLMNfLYdehQ+rbfKAfSeNBEDVvhXzx+ppUaOc1SQ6DAFa55d+Fio6g5MskXOlrJDoK1e12sL7nzF0+b/rZwZccasRaxbTs2xocnZUrLn/cDLGRdBSzmYUtKg9cIVQFZXMx6MpbDhmEKM1YBojOceZ2PCS4CYDJodTLqoIM/0nFbUbOP1mwcg1TPVnXNRCRGxNo19bHynKQPBzFKj+xUppcV4xCN9SSwMV+kPdu+cjxitsfjcRD1+dK23srGchjUMZ9E5gUSthK
 eM/WacNN
 SUTjNEKNrBwWr95vDATR5p9aTjZgiLW9O90AFSv4RoVyH38iEZJOtF6nfQ3BKnsFTPMBYo+/T56nTIi1fD/sKjQJkL4h2rx+GyPxCVE4uTl2Ef99+m2WAVuvV1lhIh2mtPU7lT0Wv5WwWet8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Use the EXT4_P_TO_LBLK/EXT4_LBLK_TO_P macros to complete the conversion
between folio indexes and blocks to avoid negative left/right shifts after
supporting blocksize greater than PAGE_SIZE.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbf04b473ae7..ce48cc6780a3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2610,7 +2610,6 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 	pgoff_t end = mpd->end_pos >> PAGE_SHIFT;
 	xa_mark_t tag;
 	int i, err = 0;
-	int blkbits = mpd->inode->i_blkbits;
 	ext4_lblk_t lblk;
 	struct buffer_head *head;
 	handle_t *handle = NULL;
@@ -2649,7 +2648,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 */
 			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
 			    mpd->wbc->nr_to_write <=
-			    mpd->map.m_len >> (PAGE_SHIFT - blkbits))
+			    EXT4_LBLK_TO_P(mpd->inode, mpd->map.m_len))
 				goto out;
 
 			/* If we can't merge this page, we are done. */
@@ -2727,8 +2726,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 				mpage_folio_done(mpd, folio);
 			} else {
 				/* Add all dirty buffers to mpd */
-				lblk = ((ext4_lblk_t)folio->index) <<
-					(PAGE_SHIFT - blkbits);
+				lblk = EXT4_P_TO_LBLK(mpd->inode, folio->index);
 				head = folio_buffers(folio);
 				err = mpage_process_page_bufs(mpd, head, head,
 						lblk);
-- 
2.46.1


