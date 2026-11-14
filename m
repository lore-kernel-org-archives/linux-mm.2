Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD64606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 23:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fqorLJi2
Received: by kanga.kvack.org (Postfix)
	id D10D86B05B1; Sat, 14 Nov 2026 18:54:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1BE6B05B2; Sat, 14 Nov 2026 18:54:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7C96B05B3; Sat, 14 Nov 2026 18:54:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8719E6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:54:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7A98404C9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:54:44 +0000 (UTC)
X-FDA: 85435382088.15.6817C2F
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1FFC540002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:54:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fqorLJi2;
	spf=pass (imf01.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794700483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvGNkEQXxpCGRnxugPg2OroUq4ixAzACPllCORFjj2w=;
	b=HI7uMnWXvF6fzed1X+aXowdm9uKAt2SKfEbIy/WZ6NfU7R+3JSdCBgE7wxyEt/0swf5vOW
	M6kWIdINB20U8AgvMFDo79caT9KSYfFOPcw4F5U3qvhSQV3qLTuqZw3DPIQprwrKtDgzrR
	IoCMCCPaX8w7KjPI0Zc28hzh6U3xeUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794700483;
	b=KZdcHJeS4QlFVx0NyOKsjECRweaNFqAuaTB3QLDxLVhYr+788WFq6xZzSpnKZAdUUtqyBR
	JQbwfvgL+fCOuoJ52mIwExCaXwC0fTH6Ycl2NEknyLUZpEF4SptU1OtmMM8Rw42G+Ai44p
	fLdrEZPTxx9jiz2Wr9uW+VS0zztLyyI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fqorLJi2;
	spf=pass (imf01.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-491971ac844so2125430f8f.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794700481; x=1795305281; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvGNkEQXxpCGRnxugPg2OroUq4ixAzACPllCORFjj2w=;
        b=fqorLJi2Tu1WSHmvLc03PWsmW+RT0V87S/RqoJD5jNn/opS0Vh83jaij2OHM/4nw7s
         KhcFERaRZ2FNVJRqkYgrOhCh5gonNPby+5QhbPuLvuWBllmV0uxYGySdjqhFQbEaIy05
         HEjH5nRjrnW132hvuXYPdr3mLVZg+l1TVXjZEmpLrdqot6IRttRWRD4Ahy97vtgz6xlz
         Bd2e1SRSYBmyDmUKPP16+fpHGky0tjT+lTC6XAiSe4N9iCwJixY5vr2CHuwMgZvQ7Fvr
         XK0D7MEsL7+EHRa88huuzLdPxdliv3+Jq0EcMIARyqETr73xreHxZCGu8PqS0ghZ06W2
         ziiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794700481; x=1795305281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvGNkEQXxpCGRnxugPg2OroUq4ixAzACPllCORFjj2w=;
        b=QYV5n3zWk/3HqHyHFmXo16vbVjmPFytFy+bwKgqZei9Zg6Flib+UO0GlMaxvvu3reH
         q41QGA0ln7nnYpVIcgGSGEzFegIFYTDOzgrW8bmn34j949xBk/cxBo8i/fs7j8kIFli7
         VXPrXNnPa6Nnzq/LWWVwEOLf/i9R7Z2bj3M45+/iyWepMmKiFNulv3PPbM7OdSYjYJ7E
         cQr8pfR7YoyAAOxrUm4rSQzu1Me4yo81dcpkdWSqqbT0iDt8B/0r4QDUmUpkgKDHrlSe
         +EKWInFfocVL8GEBmeQU5piO2mAbRj7GSBYvFKOeeR9olesYO9AlJ/1BRghoRuO1CudS
         0pkw==
X-Forwarded-Encrypted: i=1; AL+hErHS+y4rC0+jiENVfUOzSg6CHF2Ec74p6DDYLUd1TLJcsPPLjV7BxGVPBpVfkh2plqBJ6ms9pR7nMw==@kvack.org
X-Gm-Message-State: APuU4Z9z82ehgO8RwMeR5kPNvR5VHw5+hOmUuOy7Ntpb3+itaS7a3TVq
	sV7t9E8fgycE58bzv2+ND3tm4/TytixFi6gjwljqj/a8wXJFli2SrRv6
X-Gm-Gg: AYBFou07lAj1Sd1GDAEr9V/oKL2izeJs/reClQ7skv5vUojQfLhsbI9CTrRx3P7gtgc
	Egvunr+WSykmwnxuzWNVTbS9m0ULQgn74wkXwkvjmegtSbTMcFi0ChQMz0l5iozaDpuDK52Sz8l
	UYNqTFisMnBew7E7DuCXZ5uFaC97WOFS+FM4veyzX5fIhsgzz4b0pZqVL3F+zdpbA77IWBmqgIf
	hWHYZyPGDYjWSeL8sY1MxnKLLUTgcd38O2MtOGPKFInxkH7mAouywVRAP5wRCN60Tg0vcI4DzyD
	ifri6re0AlIaQCG61WTDC5vKAsYh/VTLP0FDxBjBklVRFPdXO/MHFUQiAzY5XlJzEyyFaU29YOh
	i3IO0DmEbS3tXqujb+xyQ5Tmlczp8jOUM/9B0tRF2s1DXGW1VfXWgJhWH87WjZj9RlFXl3CBLHO
	rvsNmzdDh2HvNeJnvFuARGSwr4AmJn7EXQKjwATxm8YcR+zyOPMNqaYC89oGtUyMDSbeusLUZHu
	Xpkl5y4RTQT7Y7uBDe+sCYKKfayj72BQ6tnK1UwAR9ZqkOqen3kptHbP2O0jB3oyPCxIsjinB1K
	SpMoqCyihAGiPBMoO7hb/i2NhB6+wwWmsWlVgKGCtjGDmgyX15ouaOJXyNvLrUe83bebhS5AQ5u
	YTw8U4q0P+SwzIjYF2mhxhfd6vz1uQgSY
X-Received: by 2002:a05:6000:4201:b0:48e:870:7791 with SMTP id ffacd0b85a97d-49c71e3d623mr16407297f8f.26.1794700481355;
        Sat, 14 Nov 2026 15:54:41 -0800 (PST)
Received: from mohamedali-HP-EliteBook-840-G8-Notebook-PC.. ([197.18.115.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608d10b2sm23069680f8f.44.2026.11.14.15.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 15:54:40 -0800 (PST)
From: mohamedalibouhaouala@gmail.com
To: willy@infradead.org,
	jack@suse.cz,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
Subject: [PATCH v2] docs: filesystems: update VFS locking documentation
Date: Sun, 15 Nov 2026 00:54:26 +0100
Message-ID: <20261114235426.20408-1-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3aaboixwh6lpo4s67dv7lssqj2vwlp4qp5cq2ysimqi36r3bm2@fb5lmoo33ktf>
References: <3aaboixwh6lpo4s67dv7lssqj2vwlp4qp5cq2ysimqi36r3bm2@fb5lmoo33ktf>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1FFC540002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: pyoaphwfs9tpd44u6xioxskizo93jxjn
X-Rspam-User: 
X-HE-Tag: 1794700482-239829
X-HE-Meta: U2FsdGVkX18KrxtmSg1ZlpQLQVdfR2cF1rX9elWvi2MmFTlL18eCbNLkPdv8OkT+SiU2N7vHp2QHOdO44SNXUbSb2RqL3hg6htaNSXKw7Thn/eCKIAu5ZugP4TbShEV5RY+PgS625q08bltt0gCrFzdENQ3eWwYoAJVCTTyxC0138anyTDGEi7mRvJzzkmjMrijCOtO3QW06rf7fpL/9EW/HFmUas+l5vhVYta+lFP1RZysGd7G00IuI4ULVo5GjL4kQM+lkHGn0tUkwrDWPFoieRrwwqsDFzXXuxhDxlJqPziVEKABtZFrrYWCXO0Ttnsu+G36JeGWEZ0T0HwR8tawCz5Y3y+GaCvSJmJNHitw+B80EKuKBdlN68HxkYv5kA/uX5qox/M/XGe3KO24eSqsIfHIeQLKlHXi164vh/Z8jtH3FP3LkeWKy9A2mSfvgvCtnUwGqOYhg2sAUtoDUw7YftT20I6QVOaoNoL/sUKd0W3YZnKUFqH3y1miPN5wiLPCDre1STOnLRTWzw5iqwzBDRWr9PR/5uNsqy1GtqcOpQ8PbNOX2HUgEvKAnptWi6tSwuCol7N1B9LcNSNOo3S7i2yvGr4Q1TWNQF+gdcifGfaazkovWR4rywiF8wbIol0wbAjncdzqwZztPaaGvD008uLN9Q3jqrk64Gn3xuvEXMzdJi1dsrbhYRSYlJiX+DScGJQm5s8XcZkoyGKMDaWWH8Szjvz6apKKCKHC4k8+e0KnS57389Co5PI74bHGIuTbuoreJVThQr/p2qrhXQp+AZqyy0ysywas9M8WZIubyxeWOaWwcq9G5+eH4AblQWO/wXcRpGEKldMpAqX2JeROJHMcRetAq/cPFqtTGRjxBYDrUwDuWEOlsQdWlC3qYuLP1U83d4oJPU3B36w+PlBOeW4lcmSi9setTr/gixbmQ1jeWfEG/l0MJ3n3QZGNeVs0Eq9W38C+OWpOm1pW
 UqM2DduD
 bVvAcr6nYADnsAHZz6NBpvKnsRuJhyXs8qcgVXwTDGbliJU7efL3XXd4Xr8bZOUqQJUv7wFrUJrrMMhTdA09eCk3vaFFNp0lhsYc1Ah+dK6PgGjvbAImtnTiuSxWVFWinXRGxeZhyiPayyyguuZfXeLhTmyUdAmanaydIuRCcU3Piq1lfp8VWuZ3Z4TsT5SHXbxNsTEN0s177/WCojUrG+Vt/0KD0C7fYcjjOzMZCjxuqLqKVlnFdCvlofwIr8hDYTg1BQCTZC/unaRn9FfmxTPqafY30I5/F/RQWq0LlLDiAYh2LS5v7YQXf4TSR9VZBsaSnKqZ7V4xAoTl2TEwmAC9Rt+zLWKJ6KOH9vJ+yhf4RXBK1FLwdFUAA0XtFadqKl3B/R6A43UUz6Xa+DAZ+S7WyYk57u7I2YvTo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

Update outdated VFS operation prototypes in locking.rst to
match their current definitions.

Add the missing d_prune and sync_inode_metadata callbacks,
and correct the signatures of existing operations.

Update the locking table to include sync_inode_metadata.

Signed-off-by: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
---
v2:
- Use the contributor's full name in the author and sign-off fields.
 Documentation/filesystems/locking.rst | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index f7363ad770c7..a6a011858ada 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -26,6 +26,7 @@ prototypes::
 	int (*d_delete)(struct dentry *);
 	int (*d_init)(struct dentry *);
 	void (*d_release)(struct dentry *);
+	void (*d_prune)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *dentry, char *buffer, int buflen);
 	struct vfsmount *(*d_automount)(struct path *path);
@@ -80,8 +81,8 @@ prototypes::
 	int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
-	void (*update_time)(struct inode *inode, enum fs_update_time type,
-			    int flags);
+	int (*update_time)(struct inode *inode, enum fs_update_time type,
+			    unsigned int flags);
 	void (*sync_lazytime)(struct inode *inode);
 	int (*atomic_open)(struct inode *, struct dentry *,
 				struct file *, unsigned open_flag,
@@ -173,6 +174,7 @@ prototypes::
 	void (*destroy_inode)(struct inode *);
 	void (*dirty_inode) (struct inode *, int flags);
 	int (*write_inode) (struct inode *, struct writeback_control *wbc);
+	int (*sync_inode_metadata)(struct inode *inode, struct writeback_control *wbc);
 	int (*drop_inode) (struct inode *);
 	void (*evict_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
@@ -196,6 +198,7 @@ free_inode:				called from RCU callback
 destroy_inode:
 dirty_inode:
 write_inode:
+sync_inode_metadata:
 drop_inode:				!!!inode->i_lock!!!
 evict_inode:
 put_super:		write
@@ -255,7 +258,7 @@ prototypes::
 				loff_t pos, unsigned len, unsigned copied,
 				struct folio *folio, void *fsdata);
 	sector_t (*bmap)(struct address_space *, sector_t);
-	void (*invalidate_folio) (struct folio *, size_t start, size_t len);
+	void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
 	bool (*release_folio)(struct folio *, gfp_t);
 	void (*free_folio)(struct folio *);
 	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
@@ -265,7 +268,7 @@ prototypes::
 	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
 	int (*error_remove_folio)(struct address_space *, struct folio *);
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
-	int (*swap_deactivate)(struct file *);
+	void (*swap_deactivate)(struct file *);
 
 locking rules:
 	All except dirty_folio and free_folio may block
@@ -455,14 +458,15 @@ prototypes::
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
 	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
-	int (*iopoll) (struct kiocb *kiocb, bool spin);
+	int (*iopoll)(struct kiocb *kiocb, struct io_comp_batch *,
+			unsigned int flags);
 	int (*iterate_shared) (struct file *, struct dir_context *);
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
-	int (*flush) (struct file *);
+	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
 	int (*fsync) (struct file *, loff_t start, loff_t end, int datasync);
 	int (*fasync) (int, struct file *, int);
@@ -475,7 +479,7 @@ prototypes::
 			size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *,
 			size_t, unsigned int);
-	int (*setlease)(struct file *, long, struct file_lock **, void **);
+	int (*setlease)(struct file *, int, struct file_lease **, void **);
 	long (*fallocate)(struct file *, int, loff_t, loff_t);
 	void (*show_fdinfo)(struct seq_file *m, struct file *f);
 	unsigned (*mmap_capabilities)(struct file *);
-- 
2.43.0


