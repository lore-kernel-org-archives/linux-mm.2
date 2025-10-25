Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB1CCCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F41F8E0120; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3B88E012A; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458D58E0128; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9E1E8E0123
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FF18C1077
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.19.4282EAC
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80E06A000A
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0j2nzPMbhku9w2OrDeMoRD9nisiNFU8pNRZMTG7zhug=;
	b=sO5P+hOMGj9KYwea7syUhTnLu5caroX3chtXS7rekHrGt7r+E+TJwNeKcjaEaW5tTwFyO0
	o+90gcS87HPpo/d7WuvFbe/yH+8lbYKLzaNpyKUoACmXcZLwdbzV8k0vzDz2SDABftJIjH
	YpPefL6g3a8CO9fppbrlVDyBbJucyuE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=Dzg4bNE7Tc6jnrMpEdyrHkxcWIDmO2W+IxXDsiMMgFs6mVbAFjur4dkbftDEaD1UyAYNhj
	7m4LcHtbK3tXmpFu6zXI3YHWbHpgHBZPbLJgjg8lz43QGNbAPnoSIf19iH/Uu5Yy7CRyce
	VjveUZsAi+Cd3P7SHXpittmToLdxVy0=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcS0XGczKHMK2
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id BF34D1A101E
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S8;
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
Subject: [PATCH 04/25] ext4: make ext4_punch_hole() support large block size
Date: Sat, 25 Oct 2025 11:22:00 +0800
Message-Id: <20251025032221.2905818-5-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S8
X-Coremail-Antispam: 1UD129KBjvdXoW7XrWDZr1kXFy8AF1UGw17Wrg_yoWDCrXEya
	48ur4xuw4rJr1v9rZYyr1YqFsFk348Crn8u3y3Gry5X3W0van3J3WDWF4S9a1UWF48WrZx
	Aw1DXFWxtF1xWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbm8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I6gAAsE
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 80E06A000A
X-Stat-Signature: 1qtt7776am6zhpg6xt1kqfu7co5f91sq
X-Rspam-User: 
X-HE-Tag: 1761363008-813124
X-HE-Meta: U2FsdGVkX1/lQMm4MzGpTM7hJEfJSQFDt5U+Ld3ztJnNJ/L07u6ugNaaIDHdqF09uvqwUiwxVMNUKP9U3NYnuj7WImXx3nbDbcaaY9/PPR+0CZs/DEAceaJOZKcFboSnAkmyR/FteKpjltICanDrSDUQg/rfIPxdpF/6FlhgK/XrG7uHzZFZ3pQ75D0tHDRjBkcX1jFP1Yft3ux7acmG8y3WndDz6U1M4s9j9Qs99Wd5QLlz1phnP7VcIoA/FphQf3hT9tZSGjf9dFHdMPD4uEOFuV0tGRt8Qks84de0N0iFVHEsEhbG6MDOQBj4mOUuprg85ajN8G6BYfc84hrq7+wJXG/9xQu8qN3hcIVsqKaksHcJCJgS3yDx8nr4K1Wwh4Ef0NwCF1rs//a2NxddYRQbZbjdgABqlMAwWuwdPcWSvU1y/9agN4ym/QmVFfXkosypAmR/DDMnrMx/sCkoncAYBI/Ghp1vVYnbb9t8Zj+K+mDqo+PG/Bpu/gp6f/bu2VOsEooKOooqOaLPt6efJ1UFUcgT7YMLu+Y9nXX14bgiq4s7RoSBJkczMeSmGQ1X10FyTjv5F8qvsmPX8BwWIvIU+Hm1F3rS8w74oFRYN2wCw6DijxKi8ruqvdR8CEthsxIE24rWE9e6BDAe1dwetAnjsK+s0t+NnZcR/kZhvEUK/JCg3TP+35X0Bit8dU04pQbkobv+w3eCModEpmydW+pC4P819j+JpjbZj/8X3d7YD1+L4tlaGAqpRge3Ypql9baPjCqIH8jv50yZgqufuyB6+LyGyATzpbAsaeHi+to+lxnR0MhUzYs2HeOG2F/lmdQhjrdY8luSVGO7aOvaLR/rFT5HHZmb6YlM+NPjAiR4CtmuU8jiY8gjCFbAuYiC94s+X5zngB17l33tHoEDzx6vwUFjeGwYKxH1CJ+HSMyM/UcFC4coXn//Q77SKqRJY0vzXQAK9Os8ZFoERTT
 Ej3eRzz/
 tThj9adqE3Xb4YhN4HBufcb4PJ4M46P6ivSMJ/dVIygCKNg0eTrL6EBkORjhN2MT2rapCBeGHPo/zckFlwhDZ4qzgNtNaO9mmhZPR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Since the block size may be greater than the page size, when a hole
extends beyond i_size, we need to align the hole's end upwards to the
larger of PAGE_SIZE and blocksize.

This is to prevent the issues seen in commit 2be4751b21ae ("ext4: fix
2nd xfstests 127 punch hole failure") from reappearing after BS > PS
is supported.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4c04af7e51c9..a63513a3db53 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4401,7 +4401,8 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	 * the page that contains i_size.
 	 */
 	if (end > inode->i_size)
-		end = round_up(inode->i_size, PAGE_SIZE);
+		end = round_up(inode->i_size,
+			       umax(PAGE_SIZE, sb->s_blocksize));
 	if (end > max_end)
 		end = max_end;
 	length = end - offset;
-- 
2.46.1


