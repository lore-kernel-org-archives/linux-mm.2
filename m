Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB562CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86AA8E012D; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00508E0135; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F758E012B; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4C818E012E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1C891A106B
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.06.F58C0C0
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 56F58140007
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bXRYLiL+J/C50hvqfGfXaF7z3ezvO2V4w3Ql90u6DSU=;
	b=WDIzfaU+z13ExPfVhyx5junFeDjfCdIlq/Nx+isXWMyr+w6QxystjyPUqsJomh9c4VFVDL
	Q4/IUMOjAj5DDDO+fBCPulf0BGCFse5LpdTpEgY18eNeZfAq7z5lMC6rAplm5kDRBGKgYL
	06D+inTO/pRjxYp2IYMkneNf7k7F92Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363015; a=rsa-sha256;
	cv=none;
	b=6eaeMtOO5smSUxZggRr57t7AxdxlBN9wQa0afwL05i1wqlWI2Q6rAIMSJaKWbC1JOLBXC8
	2u4TgH1xX4CvIiQfQrlb8haA96xYbt7Zif1cSCzV26ZU8dQzlQ8Ys/UKRaFaa+CV7Cbosx
	0W1b0UykQcYviKNEwVvG69lIuJcx794=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcK6KRczYQtpP
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 859D41A0E55
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S19;
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
Subject: [PATCH 15/25] ext4: rename 'page' references to 'folio' in multi-block allocator
Date: Sat, 25 Oct 2025 11:22:11 +0800
Message-Id: <20251025032221.2905818-16-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S19
X-Coremail-Antispam: 1UD129KBjvJXoWxCFy7GF15AF45JF1rXFy8AFb_yoWrGryDpF
	sxCw15Cr1kWrn8u3Zruayj9w1Sy3yv9FWkCrWxWr18Zr9xXryIgFnrtF1UtFy0gFZ7AFn5
	ZF4avF13ur17J3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJHgABso
X-Rspamd-Server: rspam05
X-Stat-Signature: nc33u1tp6bnwrgq4xqgthziybacoudmt
X-Rspam-User: 
X-Rspamd-Queue-Id: 56F58140007
X-HE-Tag: 1761363013-262399
X-HE-Meta: U2FsdGVkX1+sJqfmg1uhNR5gIyW2w1L3/nRJIBzjfqYdMKrdrE9fvYiKNEiGTyf1Pra4tlVIA1wrSJcPIvgjO9Ptg2TxWFrjjceBkp0VsRh22hEZQaBPiB6Yw+yr0iwRaPGIRk+zv7afAPdyEoUrrPmU54u/QbZq7C3ucqofgUfbB5pVU8vA/4Aosq7uVq32qRqoRO0QJvkiRTfzE7OOJnI6TSHHs65U/47q8EXOiN2F8fhuwLYuPbpqsmOINN4GGkAvBxMrO87X+CSg+CaOqEzpdTAueLZGgXCVtyaknz+uPoBQcvABSbYViiucVKrErTloDgB/nsCAGACXkTOfU5MZ1KVjEyp0Ia/BFZjvuNMR+sHx1Ploh0/eR/rWQo6AzGY7JrI4eTtGdHz2se9bFxpG8ODWiBOvyzuSALooDyEQ70acfU34FQ6Xk1K5gsFpcr9SHUPPcry+XKDu+VDcfG47k5OOFibTx2tOCa6i+fPZUTj+LXDGEyMtn5/ga4EYoVuneAx2o6g3Zw7rXr+6rHtB8BN5HzMWZUeJvMYBwRDldbLYTSuXQ2BzcQ5dPXcHmYjBXcJIiWiXjY6qjnBQb8EM96gev/QVC45LEiFUhhNPiB3vNPKMSa0RYW4Xx2gkfdAr/A+Kl5dxJwRLyyLnbdtGcpQ8ZKBO3yUu3v/DN9EZzgFj9tdfYcOe1rZkyuEf1Y1hI+/9huMZm0D9Q/WeFmD6V//xOaWc281vByphB/ToZBXnLXgHkCbsk2kZwu38duiBWnSJvlKpxTFkbNnTWPJnRSk0VQVjICNsaxXjbZaO/KHzNYaEn63ShH5Fana9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhihao Cheng <chengzhihao1@huawei.com>

The ext4 multi-block allocator now fully supports folio objects. Update
all variable names, function names, and comments to replace legacy 'page'
terminology with 'folio', improving clarity and consistency.

No functional changes.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/mballoc.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 155c43ff2bc2..cf07d1067f5f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -98,14 +98,14 @@
  * block bitmap and buddy information. The information are stored in the
  * inode as:
  *
- *  {                        page                        }
+ *  {                        folio                        }
  *  [ group 0 bitmap][ group 0 buddy] [group 1][ group 1]...
  *
  *
  * one block each for bitmap and buddy information.  So for each group we
- * take up 2 blocks. A page can contain blocks_per_page (PAGE_SIZE /
- * blocksize) blocks.  So it can have information regarding groups_per_page
- * which is blocks_per_page/2
+ * take up 2 blocks. A folio can contain blocks_per_folio (folio_size /
+ * blocksize) blocks.  So it can have information regarding groups_per_folio
+ * which is blocks_per_folio/2
  *
  * The buddy cache inode is not stored on disk. The inode is thrown
  * away when the filesystem is unmounted.
@@ -1556,7 +1556,7 @@ static int ext4_mb_get_buddy_folio_lock(struct super_block *sb,
 	return 0;
 }
 
-static void ext4_mb_put_buddy_page_lock(struct ext4_buddy *e4b)
+static void ext4_mb_put_buddy_folio_lock(struct ext4_buddy *e4b)
 {
 	if (e4b->bd_bitmap_folio) {
 		folio_unlock(e4b->bd_bitmap_folio);
@@ -1570,7 +1570,7 @@ static void ext4_mb_put_buddy_page_lock(struct ext4_buddy *e4b)
 
 /*
  * Locking note:  This routine calls ext4_mb_init_cache(), which takes the
- * block group lock of all groups for this page; do not hold the BG lock when
+ * block group lock of all groups for this folio; do not hold the BG lock when
  * calling this routine!
  */
 static noinline_for_stack
@@ -1618,7 +1618,7 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
 	if (e4b.bd_buddy_folio == NULL) {
 		/*
 		 * If both the bitmap and buddy are in
-		 * the same page we don't need to force
+		 * the same folio we don't need to force
 		 * init the buddy
 		 */
 		ret = 0;
@@ -1634,7 +1634,7 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
 		goto err;
 	}
 err:
-	ext4_mb_put_buddy_page_lock(&e4b);
+	ext4_mb_put_buddy_folio_lock(&e4b);
 	return ret;
 }
 
@@ -2227,7 +2227,7 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 	ac->ac_buddy = ret >> 16;
 
 	/*
-	 * take the page reference. We want the page to be pinned
+	 * take the folio reference. We want the folio to be pinned
 	 * so that we don't get a ext4_mb_init_cache_call for this
 	 * group until we update the bitmap. That would mean we
 	 * double allocate blocks. The reference is dropped
@@ -2933,7 +2933,7 @@ static int ext4_mb_scan_group(struct ext4_allocation_context *ac,
 	if (cr < CR_ANY_FREE && spin_is_locked(ext4_group_lock_ptr(sb, group)))
 		return 0;
 
-	/* This now checks without needing the buddy page */
+	/* This now checks without needing the buddy folio */
 	ret = ext4_mb_good_group_nolock(ac, group, cr);
 	if (ret <= 0) {
 		if (!ac->ac_first_err)
@@ -4725,7 +4725,7 @@ static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
 				   "ext4: mb_load_buddy failed (%d)", err))
 			/*
 			 * This should never happen since we pin the
-			 * pages in the ext4_allocation_context so
+			 * folios in the ext4_allocation_context so
 			 * ext4_mb_load_buddy() should never fail.
 			 */
 			return;
-- 
2.46.1


