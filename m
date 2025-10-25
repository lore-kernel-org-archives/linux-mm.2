Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89733CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C5E8E012F; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6B78E0135; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DC18E0136; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C74158E0131
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89A5F141009
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.12.F3C1980
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10559A0008
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=q+ombZ5pJ1sNro2Ca/kbZTmnSGvlL4qQspJGW/J0Wi7dIkGk2wapxRUIckRFl+ylmPg8+3
	Hiji8BDQ145bD6Ci+n8/OP4dpSBdf10oHsrhGRrbmu94hfW8PJ3bx6lUoeY5cBCsfW5uWc
	9hqG6+1Tt7TSRljseXFwM14fzgau3b4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Ka6gGeQI5oPPiXEubhEDfwSvzppyDrejPx8pztDpQE=;
	b=3+Olte087ZNeOkNN7nG+LrQ0mvrULCC748uAT/RcCw2+lIvLKlg8e3ZLv3bDHWqvUlvANi
	kx5EEOWC99hILSXYmBSWAkxmtX9jGdz/qwh4xEj5+Tkuxukm80+YlF0yY/lhuAYK/YjrKA
	5bj+ob9VIiZv/Alqt2fltafzz9qVJLA=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcT3jJMzKHMQB
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 3A3431A1B5C
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S28;
	Sat, 25 Oct 2025 11:30:05 +0800 (CST)
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
Subject: [PATCH 24/25] ext4: add checks for large folio incompatibilities when BS > PS
Date: Sat, 25 Oct 2025 11:22:20 +0800
Message-Id: <20251025032221.2905818-25-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S28
X-Coremail-Antispam: 1UD129KBjvJXoWxZryUAr4kKFWDJF1rXr4fKrg_yoW5KFWxpF
	Z5CryrAr48uF1Duan7KF4kWr1Y93WFkayUJ3ySg34UJ3srG340qFWftF1rtF12qrW8W34f
	XF4rtryxCw43CaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	x2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I8AABsf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10559A0008
X-Stat-Signature: dzq79bymkx14sbyseiogmjzj1qkredhh
X-HE-Tag: 1761363013-903506
X-HE-Meta: U2FsdGVkX1+d2wVBKVOBh+aBtXxf/ZuS4gwab163lD8R4BUfYQ7v+yhMYXDCeGXGpqUWwK0+oqLNDKt/Wi6ZUwxR8bwx6w/cSONp4gWAKhcYpnW6/ZmEJvjtI3DXwytUGAWWL7tzPcmfqt1jCodVEZqDJDO8bu235pVACrEkAZmT4gLLq0smURg9stLHSRJUMM4ZQqFkA37jYKOzDIciLZqmbnDTC8ULpYvUEv/KMp4RiZwWtVSIXBkauRx3KFx0QTWCNR6FxHF8EyesS5FNjPCJ6Qhq95wpn3et6vU8kWRraOwnF+XTin5mI36VwQJW+ds5vMawPn2g/Ur1IUjgZUUdTkv3Oa+8Hk4are1HYn+HE7h6fFYrKfLE0sJDYdlF4GMD8MTxGO62j4zXaYU6Nc5qWI73Yb/kHz32E655KRnMertN9mnv3ujsHFkietZ0JZqa1U57jqxM7LrhokQM5l9tJovglbaFfjQEZW9ceH/gmBLrr1S3A2XtC0xnh+PyCAsLs8P+4iMT+P0DRXroIqiGbZKjA+gFUW7HJmKb3ZqgQGe8iZXr/WYN+ESrnscb9RX3veoMnCAh4bEr1vm0fXWucKMXvELIJI8X3IAX8MhgA4XbqGhOoo5UV12nvWxJp1uxfXvrqskJJOLBMeYNi2Ikc/1Q7fmnnMQba1t6gns//wyNv9R53v7nwUnZkdhp9xUy6aayPBYc/Q5TGPi40rj4GgqKkPjYnoGHujGr9U/F75/HUcR3Tdgyd3V9pnRstggBdk3yXDmZ5eRFYTvga3MEhCkiwT35FwW1067zoWFSbnJw0iXZumZQ8WEDQ1khxO2mC/4e9e4ETkBFv1JZ10WHvENi++Cj1z/rN+f7ZJ1V43UexWnwpP1sdmNBeMpzivX0JUgvqxiQQN3SucgOQl/hwwSGlpLPXpAbyjR33FG35owvlrpetCQGljLklJrDz81j01xL+Q3dlNDL4gF
 d7NHP3NN
 4TCTKVrwsOtDJEQdOhfjlgMfXoZWztEoiQsgysZwCL8wTu5YtI8Gei/ihw9OTanewYDlrx8Uf2GDZkTE5v5OMZWQLDoYotdZ1eGsl3HQFRNQogufOq++2/GkQDqiIck99lYfc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Supporting a block size greater than the page size (BS > PS) requires
support for large folios. However, several features (e.g., verity, encrypt)
and mount options (e.g., data=journal) do not yet support large folios.

To prevent conflicts, this patch adds checks at mount time to prohibit
these features and options from being used when BS > PS. Since the data
mode cannot be changed on remount, there is no need to check on remount.

A new mount flag, EXT4_MF_LARGE_FOLIO, is introduced. This flag is set
after the checks pass, indicating that the filesystem has no features or
mount options incompatible with large folios. Subsequent checks can simply
test for this flag to avoid redundant verifications.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h  |  3 ++-
 fs/ext4/inode.c | 10 ++++------
 fs/ext4/super.c | 26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8223ed29b343..f1163deb0812 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1859,7 +1859,8 @@ static inline int ext4_get_resgid(struct ext4_super_block *es)
 enum {
 	EXT4_MF_MNTDIR_SAMPLED,
 	EXT4_MF_FC_INELIGIBLE,	/* Fast commit ineligible */
-	EXT4_MF_JOURNAL_DESTROY	/* Journal is in process of destroying */
+	EXT4_MF_JOURNAL_DESTROY,/* Journal is in process of destroying */
+	EXT4_MF_LARGE_FOLIO,	/* large folio is support */
 };
 
 static inline void ext4_set_mount_flag(struct super_block *sb, int bit)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b3fa29923a1d..04f9380d4211 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5143,14 +5143,12 @@ static bool ext4_should_enable_large_folio(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
-	if (!S_ISREG(inode->i_mode))
-		return false;
-	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
-	    ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
+	if (!ext4_test_mount_flag(sb, EXT4_MF_LARGE_FOLIO))
 		return false;
-	if (ext4_has_feature_verity(sb))
+
+	if (!S_ISREG(inode->i_mode))
 		return false;
-	if (ext4_has_feature_encrypt(sb))
+	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return false;
 
 	return true;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7338c708ea1d..fdc006a973aa 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5034,6 +5034,28 @@ static const char *ext4_has_journal_option(struct super_block *sb)
 	return NULL;
 }
 
+static int ext4_check_large_folio(struct super_block *sb)
+{
+	const char *err_str = NULL;
+
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
+		err_str = "data=journal";
+	else if (ext4_has_feature_verity(sb))
+		err_str = "verity";
+	else if (ext4_has_feature_encrypt(sb))
+		err_str = "encrypt";
+
+	if (!err_str) {
+		ext4_set_mount_flag(sb, EXT4_MF_LARGE_FOLIO);
+	} else if (sb->s_blocksize > PAGE_SIZE) {
+		ext4_msg(sb, KERN_ERR, "bs(%lu) > ps(%lu) unsupported for %s",
+			 sb->s_blocksize, PAGE_SIZE, err_str);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
 			   int silent)
 {
@@ -5310,6 +5332,10 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 
 	ext4_apply_options(fc, sb);
 
+	err = ext4_check_large_folio(sb);
+	if (err < 0)
+		goto failed_mount;
+
 	err = ext4_encoding_init(sb, es);
 	if (err)
 		goto failed_mount;
-- 
2.46.1


