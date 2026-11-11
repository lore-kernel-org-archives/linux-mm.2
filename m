Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58EF606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nZ/85UWg
Received: by kanga.kvack.org (Postfix)
	id 0B49F6B05B1; Wed, 11 Nov 2026 11:05:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C326B05B2; Wed, 11 Nov 2026 11:05:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3A46B05B3; Wed, 11 Nov 2026 11:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB30F6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:05:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68701A7AD9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:05:37 +0000 (UTC)
X-FDA: 85423313514.15.A8FF848
Received: from mail-wr2-f7.google.com (mail-wr2-f7.google.com [74.125.225.71])
	by imf16.hostedemail.com (Postfix) with ESMTP id 887C718000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:05:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="nZ/85UWg";
	spf=pass (imf16.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 74.125.225.71 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794413135;
	b=I2qp4VzWWKb5awtI6QR9FGlnG4jaT8YNe3gdSM1feB9/GMx8h0jev2I6gOXgpAz19Lgy9t
	Q1eg4Z5OwSqgreRf1Wse88tIMiWEHPJaa3vKhA4NCpeXsly8nXp6xrqBHNfxaRh1L+hbtq
	U3IlUTnOGcKzph7qu7bDirYC4hO3fU8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="nZ/85UWg";
	spf=pass (imf16.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 74.125.225.71 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794413135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lRiUlywrwld98ENTQ9ryYYw6DTlHnImGRe3UChrbN5g=;
	b=Wyw7Tuz2NxO3xxuyBxSU+WM3HIKABbI0YDJpCxOwjvM4LOBdGWidC2uBF7UBpoC0g+NZ3i
	cJChavUOwAU8WP3M63bjMpDDUJfoFtCeE2Z5v2zbjaKnIJMnN++qG1cNpe2XF07FD1D1kk
	A6/caMYvMhIFPJKu/mBRCQT/sITksKQ=
Received: by mail-wr2-f7.google.com with SMTP id ffacd0b85a97d-48e0c9bc8f9so1495309f8f.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794413134; x=1795017934; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lRiUlywrwld98ENTQ9ryYYw6DTlHnImGRe3UChrbN5g=;
        b=nZ/85UWgcYCPY92yHZYy6fo5lhqF/l8eCH6TIoZtQWzlrUGCtmMIgbKuY83Zod4NpP
         27e1gLA+bNR3T307P9a0PukXZEyGkFf1m/MLS9bFNrF8PuhSe5TNVhZc82Oa4/vggP+h
         rG9F9LAKJvT2DniuBTwNZqCAYBBHq0t9kPehL2h9kaynE3WngBpY+ODPK3ofueuYV7oB
         6zUbl5afg6u/zLcOciiOcbuVWlum6dsE8Qb8FPyyk19r+79eGx4dWglkvuWpQiub9HdF
         KV9ZgnWg1xfqnEJ/8/lqaL0NmZcrp894ohpGPlxQgTkdGtitFE0xee6+ryrxAAaEyn51
         elMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794413134; x=1795017934;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lRiUlywrwld98ENTQ9ryYYw6DTlHnImGRe3UChrbN5g=;
        b=lWoQ1ypXdHmfqjuKQ1IVdVvIVP4tOiBzvQL/ClizxllZ5l60B8CbV3WEwjiCV+8NDz
         r/xZpx0ze2Gv8gcyl1sK6cR02If5NOLvm8kgBirwY1nuSfQHTqGcPmf+aQCjsmJ9ZZ8E
         gkL4gV7f/TYgTyi5Ioq5ZT9/aS5rNxQN7UekgC8iZFDVGanjcOm8to2sk7anv1s/hCi6
         mWaI2yhEj9jyfZIxv0bUHp/ydYWRaH1TrpH0UMxBSyfb6L4cj1CrUrFp+KVM+fh1z9Wp
         7zDbQxy4nPd5CBPcWwEmpzcDGiq5zoNGsr2CLjNQG3wwDY4I2EJDUumGalnvNVKUIk9g
         CGhA==
X-Forwarded-Encrypted: i=1; AL+hErGjexpcWam8KQHlSI1w8Yzk5EHxIITlpdRmKso0yMFjVik5wmuQ7RABLJB2FJMuzxlwgXazfV5DfA==@kvack.org
X-Gm-Message-State: APuU4Z8N5dr2IuLdIwvukDcWeJQJKJXJBaK9F99+jAYYq3nOD4/G9OuC
	pAWbn7adCO9fTptHpR0yzp7DQ6Idbe3wZNqrllPAHR9vBNNJLkmhC2Sl
X-Gm-Gg: AYBFou0FERlcIo9odFQqefXXDlpm5Sd4iWXw4draMHGf53pX2C68gjxcz/huUPbQOyn
	Ip11OsidbFgUpWBwD+DsXdxuL7D+SAhP97t5w8RhANo1pmNN2aeCSe4kamfc+tDernyRSEP09vf
	IHLD9ZGpbvqgg3qZABdTusQolMkfgfnBfvpLMLU+JQLcYPvW3IVrJmNaskyZ388Uh6Dt5le5Tzy
	vMseNEd0wGvNn3asn0HiNywWv3UgGcRBYRv3fVBMU87sZGTCdxG/QoIHSxaffUb7j37ysqSlgIm
	AtyVa2yUvQ+I7PJWmrTKjaf1vRefXDl0TCv7QxRgsEO8FcHjhU+TqiBFAZaqDuVYk0I3WMFO4Fa
	BImidF1sPX1VtoQm7sM4Y1Ut9w4UM+vRJHiJpS4KWvKaBFxPUs26HPIUH4MexhL9lDWZyJI4vDX
	V2YHL5Rb3e3z1rURwww/srhWke0z78dOqeC3zTWEfAwcqBnL5h3UbqcmR0zVZJl7PrK3PWbuKih
	2KfKcBSLLsHHHSX6UqqmbaGVAOQS6sDiM+IIVWlwS6VQ5PLMGLRT4hCH8mUje8X8QibbqP8h83q
	2S2srxMXLLzTG3y0zc20lfGTi2facNeROcaGkw+sKgYa25inl2mxOH+erbj+8TnH9OecQwNxmjd
	g4P4tmHKKgO8KwAdsPXQeiSlgDQ==
X-Received: by 2002:a05:600c:46d2:b0:4ba:73f:ef5 with SMTP id 5b1f17b1804b1-4ba093b1bcfmr49437235e9.34.1794413133588;
        Wed, 11 Nov 2026 08:05:33 -0800 (PST)
Received: from mohamedali-HP-EliteBook-840-G8-Notebook-PC.mshome.net ([196.203.210.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4c55f667sm4955755e9.15.2026.11.11.08.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 08:05:32 -0800 (PST)
From: mohamedalibouhaouala@gmail.com
To: willy@infradead.org,
	jack@suse.cz,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	MohamedAliBouhaouala <mohamedalibouhaouala@gmail.com>
Subject: [PATCH] docs: filesystems: update VFS locking documentation
Date: Wed, 11 Nov 2026 17:05:15 +0100
Message-ID: <20261111160516.30458-1-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 76w7t1gijwotu1ibmy4me3fadw16so3b
X-Rspamd-Queue-Id: 887C718000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794413135-956099
X-HE-Meta: U2FsdGVkX1/UbeoTnZ+moR0FoTKE9bG2ygs/GhxN7cpFP0PBdVHMvnmHUPTUqzJJiQERu8G2IU0QQduiFAHilugzlIaZy1nb/L5NCf2xF0vTR6JzcheSeClm4ZG3sCKe4n0rRzVjw1B2F+D9RtIyV5umEc5VSD7hasIi1UZkq2t09LyVFKAMa6E5JFb6XXHXUE8WFJHvmnAVpqtw46ffHZ80hAZ7ivdqBX0kl++MUY2AutHw1wCQb2FJxoutgvHxtmgdfzolTU8LVOHImnzvymhdL8J8UmJ7ZhmQiRPhFDP9HJ51iZCUHbN4crVphMBZYVq/EP79IUOQ1Bj3PAja9tuV9DN8PYFfkTx/cUmY2s1HTUmuFB8IUiUG6oRuyveVdtxMJw9ZaoIUoQj/cdjbqpmPK8+n1yNKCqRVW5pGJ677UKCo9k2Aj+3mLa3Q3ZCXZwpAhJO83OyvgbVoIASZZJMOkqhEszvA1C6giBRzfpDnc143WSor8ImUzgRUIZydwNZloqwXd9EpOiHYoboLOTl3fhBCAPxVqprcT9woDG5sJu5Rw74bvEBbv9m78IZW3Xhf/+S2dFNtzczy+rluvCm7kGmpXdkuFUpzojhM7jrhA+dIOcK1RVPWbihIaGgU3v7eAfRa479a0yPOsHtzGByz+Rv5KuTEYsFhrVvqETJ1q+JWzgXAr/b3ehuSYv1eGd93Jm6RMteK98QCx8TdVSYJB7J5+hgY92QIlU/TVQ1LGwlbL5qxWft85UI0BLetSceWAgYwDDUpQj5agQDIi2x9UgjPqhw4Z4zpJKELn8GLmFax0PPa+FYpXwm089pKNDTv3gf1sPfDi8dhl+6LF92XoJKRwTtB6nREokFzwDMgOHMDJz/fsAGed5qljp1xYZH8O1bbrasZcWDT1iUxziscfkylfRQG1nQ7Lpz1yFArAL+JX/0aP2Cd0XEbKJeXaeuz//Xpa6agpx4le0k
 CA3qk2yB
 DMTksh8w4LjEV/WVC7Q321zU3WzG3Z8nZEUwaGVGoPwaue3EnX/WGWJy+b+eWAMkX2yaQ7BmnMk3M6hMdMoNmKs2cmdvKB1chOuRbmiYVzujr5JZ4AjrKA5F+lIN/yynSoDQyJXuL+t+U2FEQgPk74b/FRaY2ONrkj5Kc3ZCzgsJUDQYP+A5r1sYsdhJmf7LuIy4PKlGQQa4sv/5Zr3pinx9RG/eE36c6zaG7J1a5Sz4HP0Sli4SP4TBYypnMAoTglGlvYynNp9eooWwsDwESkLZOwOoPxkDdirS/rgLJKiDI3hscTa+bUb9jwBN7Qdo55w+b1dVdNyJPF90W5KYpL0D9VXQjABfQT4W8kP8rcZGXTrYsCO0FnNZWWkdBGOpPV5FMKk2vorDZQXgu8z5uEQtLNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: MohamedAliBouhaouala <mohamedalibouhaouala@gmail.com>

Update outdated VFS operation prototypes in locking.rst to
match their current definitions.

Add the missing d_prune and sync_inode_metadata callbacks,
and correct the signatures of existing operations.

Update the locking table to include sync_inode_metadata.

Signed-off-by: MohamedAliBouhaouala <mohamedalibouhaouala@gmail.com>
---
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


