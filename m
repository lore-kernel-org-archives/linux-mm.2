Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D312CCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5B98E011F; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F658E0128; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6546C8E0129; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B88AA8E0120
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FB69161081
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.09.CF2CDD6
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1F36B40004
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=0Gx8bX8fxblBQDY9k4FjgKZpgwo9EWQzTUoM5VdE/e18y803zrvQ9/Tnsv0c443JT9T2dM
	zaC6MXUc1e3RQKu4bpDc2bxlSNxWHMtCK2YVv2bYC/TY1K6cAnvbU/ILKNsN/NhkS3iFOz
	XfNI3XhPopbRLf2S8SY6Y2/D6mG5mFY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtRnmaDaEuMp5IrH8dRZzIO6nyGDs11VeLAw/27mVyg=;
	b=YFwxPDm38uiGa7cTcyuVjJswRgJAdWq3etqOxHEcsIe/tUjeeXgrzho9P4A+/3/yG2tV0C
	AW7etWdqcZ24GSatVB+85wf5Dp8N2t4/QsxOAvTtE2zBfduuL3id50LkTrr4W8NRLmePjW
	KIW8mKPODZ0lt+eIbwdMOnxjMMZyvgE=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcS0xgmzKHMNL
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id CE4FA1A17E9
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S10;
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
Subject: [PATCH 06/25] ext4: introduce s_min_folio_order for future BS > PS support
Date: Sat, 25 Oct 2025 11:22:02 +0800
Message-Id: <20251025032221.2905818-7-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S10
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWfJFyxtr4xKFyrCw13CFg_yoW8Kr4rpF
	nxCFyfGrW8Zry8uFs7WFsrX348Kay8KayUXr4S93W5urWaq3409rZrtF15AFyjqFWxXFWS
	qF1UKry7Cr1akrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQ214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	x2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUo0PSUUUUU
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I6gACsG
X-Stat-Signature: rudgdesjxk7h1s3d41d3ctxwrji91yny
X-Rspamd-Queue-Id: 1F36B40004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761363007-964501
X-HE-Meta: U2FsdGVkX1+bwhm0DGRx9dA+1+85LlAMe+YYXP2CAqCxKksc+OZFRmCv8Lv7zU0dLH8yOppRJQzabrP3p19gPl1Ufn9OiUMPtZnhbVLSWMLsMp1qLsFsywm6+e1vgKJX1DviiJGm5Hnxfw0WR8v2mjR2xpNqBUD3zB71Ekq8gJhzuo8uyeEli+sRB782d33HhtzFGdhOtO12fXPz7IHI51aKaLzTcjyS7/x6AFfcePDbF11K12JekC3Yh7zjvMDTxdW7lhVncXvAdkN2g0ZB1vpiv4+FwBpWBRm/ME1Zs68+D6lw8Zed0trzr2/zqt2TUWZfm8KDOpEfwqIRYjtZnyoiac9y8pIpjFceR8VGWpLbjHLfjLXpHXEVA0SifsT6EKFE6lenbgZY5/YTnzKQF/vAM2x7vMSltUodKHCchLcyE4WYm9k2ynBOAKixGCtk7YJ7gzC6DrcU/mFQ+KAfM0dDsYDUJMe0LQSy2c73ifIKhV+SK9OFKllJ70MU48vRBNdm/yVGrujdRLkCYyjLV+w1xp+3r0IjlPUZlmVKn3rD4VFMiEt6nJZaCgwYd0dD0mibMFX8FKjs1Y+Znm6iQUwRAAE/SO+ZGMFwZgKfXkTgcaH2O1YxjgSeZIzkiixYYCKqrWVL8GyLQ51R2r8AFrFBinvCPbq/X5JHJnWRSul9be7eSi0qs7EHxuAblTAV8QKLKrqmS671dGSA+twQOPvq2/LbKMvqYI4Sb1kYqssMtGqNN0S8KRodkuDiLGq2D9HAOAFgIIb6i06jfBvO0dAKOk+C4wgboUxCHfWj1uPKOY+Aaq1zccEHe/rmYHN3jfYbsHevU8/RFLZl4iOKsW4XfrNkk3J/jG1YYp2axOjSLEMDXdIW71v4cr8NQSW4r50bm+nK25jWwh9O+skB/vKTunAVF2Gy2ecB0KG7O6S4L6wPrqkB4HmZyjiDn+ItoxfYNs+jWhY4oKK03Ye
 r5SRQ8l4
 LX4T7cCpKdlSpQcBQ8S0hau3eTVd0qE2vaAAVE/TDhF5E0QJShh3PZz0SWFC9ajTVLpg7PP7fQcgR0eGP1XNG+YXwlT/xY2EjrY8U1fAEwcBepeeA2Vcbw5f7lNeW4hEKO8RMPJ+xKrVszE8cboqMZXg5jrdkXcBlEqxtRcBANvymS+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

This commit introduces the s_min_folio_order field to the ext4_sb_info
structure. This field will store the minimum folio order required by the
current filesystem, laying groundwork for future support of block sizes
greater than PAGE_SIZE.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h  |  3 +++
 fs/ext4/inode.c |  3 ++-
 fs/ext4/super.c | 10 +++++-----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 93c2bf4d125a..bca6c3709673 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1677,6 +1677,9 @@ struct ext4_sb_info {
 	/* record the last minlen when FITRIM is called. */
 	unsigned long s_last_trim_minblks;
 
+	/* minimum folio order of a page cache allocation */
+	unsigned int s_min_folio_order;
+
 	/* Precomputed FS UUID checksum for seeding other checksums */
 	__u32 s_csum_seed;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a63513a3db53..889761ed51dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5174,7 +5174,8 @@ void ext4_set_inode_mapping_order(struct inode *inode)
 	if (!ext4_should_enable_large_folio(inode))
 		return;
 
-	mapping_set_folio_order_range(inode->i_mapping, 0,
+	mapping_set_folio_order_range(inode->i_mapping,
+				      EXT4_SB(inode->i_sb)->s_min_folio_order,
 				      EXT4_MAX_PAGECACHE_ORDER(inode));
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aa5aee4d1b63..d353e25a5b92 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5100,11 +5100,8 @@ static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
 	 * If the default block size is not the same as the real block size,
 	 * we need to reload it.
 	 */
-	if (sb->s_blocksize == blocksize) {
-		*lsb = logical_sb_block;
-		sbi->s_sbh = bh;
-		return 0;
-	}
+	if (sb->s_blocksize == blocksize)
+		goto success;
 
 	/*
 	 * bh must be released before kill_bdev(), otherwise
@@ -5135,6 +5132,9 @@ static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
 		ext4_msg(sb, KERN_ERR, "Magic mismatch, very weird!");
 		goto out;
 	}
+
+success:
+	sbi->s_min_folio_order = get_order(blocksize);
 	*lsb = logical_sb_block;
 	sbi->s_sbh = bh;
 	return 0;
-- 
2.46.1


