Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BDBCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A27A6B0099; Sat, 23 May 2026 13:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779DF6B009B; Sat, 23 May 2026 13:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7BB6B009D; Sat, 23 May 2026 13:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 594FD6B0099
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:55:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09AD6A0A6F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:05 +0000 (UTC)
X-FDA: 84799435770.20.5075225
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 505E610000E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7p9Lyua;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITTiAQYd8mEQisPL9MCYMPbpKSqI/TuCeLpOsMIzCQI=;
	b=wRoDqfzONCSeTgU/ZLknTrfH1ACcQGz5UyGycOjjZbkfdkztKnUaF2QFlTCXeZvRawtNpn
	vzZkgry3crgPAbRvrKni7+zW3fBxT9S33OvENtQLVMTScAsuYtwsW9S6xo2hiDJvNU3wen
	+7M4D7OynqTTA6ttPHmFPha2udQ4HQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558903; a=rsa-sha256;
	cv=none;
	b=1xc/6HZWYCAvNVUrCdNZKe4g5/PvWmnqm6eB7gfdUm45DSZU0HwXDgmzzQ7h5ku+IdvMqc
	+vfoaPrg0AZuDhHZFYI6WYKuf03woRm5Ul37wlXY62kCm8nhucLqnGwcjsbMaGJVXqJ1sJ
	AwS8/Aep5PUWtHT6aMoGaDVAOyvNzOo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7p9Lyua;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78A1A416AD;
	Sat, 23 May 2026 17:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0E71F00A3A;
	Sat, 23 May 2026 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558902;
	bh=ITTiAQYd8mEQisPL9MCYMPbpKSqI/TuCeLpOsMIzCQI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I7p9LyuaY2ah6+I6CPot4PjChnihlTibi2SZ7+Ut7FOot90SlZtu+2clc390PgyyZ
	 9agzHx48psjaHZps3KSB/WOFgnxbJlsqb6/JLVfZdNfGceJ2Y9XcD86fjETSGQdG3g
	 tKxIwd0x8Muwi4LWLDAtmpaPdQEJwZOXx6WyPNSbmE+u5QAgYaH89YA3aDsPYLEc0F
	 PjqkH50UzUw1A3SKAhs1BhctyTes5QQ7FF41TMFoGMlhxOlWaVHTLMocXy3NuVP8dg
	 4SHkhHKEWrGrwrUVSXBb1eQNbTsp+le/+0d8UdKFZomhr8PP97eaoRyEAUgjIKv34e
	 F2p7cOefs7OLQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:15 +0300
Subject: [PATCH 03/17] ocfs2/dlm: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-3-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Stat-Signature: 6fxknsgkgo3nxz8uyteosw5gb19fx37r
X-Rspamd-Queue-Id: 505E610000E
X-Rspam-User: 
X-HE-Tag: 1779558903-832919
X-HE-Meta: U2FsdGVkX18h5CKXy/ziwx36xSk1N7/fFf5PlG6ZPz/lfgvNwTd1AwiwfLIy5B5fjDxrmNIPNsqmXcgEa+Jic+v6AIh0bCGQ4uurBphwfbijfWWsobMP/aLLmXuljKBAI5GAnytRi9Zzp/hO5CbeMlUb+Npc5fm7kmAsLZUSu8ymJM0M0fuiDeBtE3cIdDJAPB50dYnPf1OZsCrB8xGCs66jg8V9Ec3SGYX5v+fqtnx/y5CaQ9NOeDSXBolHOZHI018w/RgU0SjIwCk4QG2N67EziDxy8MMwyPw911pC87DiMP0Rr/zawWVW04sI/gQ5RbsR4w6LxkZqQMFP9guE0aJVSmyws2A4f+sMkTyw061i4aKO88aBZKYfIxY67q3ZIv1/vmN1jbITaxqTvPkoa/XKfvmYOHiLyOnXSUQs7Kc5iSFEn1EA1y7DAbMZRyOoJj47wvlmkCtqPn/ktXZ++Nnk4ONcHlMUof/DsvAApbuhJX3yfz9gIsS+h83flbEPVzJFJu8K0v0a/Q2DWwohA1DbMk7xEA68hmJlAkWcm0ytRwIq1lh161jK45HKh6QKMDt/mRx8P9UFFYEgxEAF2ujdACFlPtLW/6VQYQa7bX50ML30n51k6pukyYGF7jjL8mlVGnpyvtjJFV5yGVGSZb1ZO+sWP1P0jWGUqgB0swjyclUqWG8Cmc9L7UYJSbH1fnOD7rTjS3AdtEya32MLU5T9Y7J0WTWPTUztkRiUmCi28W8gPV7ca5e7eZLfTLfHUY0AM89tp/Y4Y5OdcWTR0qCEYMy1jLItMCjvJCuSfY3oUIDHnP7sHvKXv3+MK57r5uj4/2XPSUYzI3Y6peDcvw+Rek1AJwD+QLSgIlusETuWqxDjN36vd/Lz1EmUd3LT6KWVs7swcsDvmVLWFmOI+lx2pyuQI6RZhgKrzfLXzFKFtEphCH+eOWIl6gSgKNn6hCcoMz4xD+PGIP2XBIO
 nFsJAOuG
 +LIkuCiSsUTIyzTB1TUukq+27s5S9UZTDWUAeAYjNDQYJhV7zu5hfTe+ZTGoOwuiY8FJ9YQrCVrbmQ8OTyiCSVbwFmhQ2DGKXCjI7US2nrD6+5ZYrrmM1QNoqUJhB960qYGReCRfM1NG2nmIxZ0KFv9doQqCE+ZKfBWiZUI6ORu06/qhFYUI4nVYSFkWQPCHJCuz5OJrPT7W1mo6eJXKOyZyUmz2z3MY4dpiJ1KERBxM/aO5oVDcBjjSCHCcEOniJ4HInLD6v3mu1iz3qbAZa6nlsAyA9YnmoGKmGcuYzpg11YsCC6CcZkptmEsz1JA2JfEQjT8qXDaUZBaKReo2464hTR4ItfjfTzFRFjE8f+JRoHxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few places in ocsfs2 allocate temporary buffers with __get_free_page() or
get_zeroed_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() and get_zeroed_page() with kmalloc() and
kzalloc() respectively.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/ocfs2/dlm/dlmdebug.c    | 24 +++++++++---------------
 fs/ocfs2/dlm/dlmdomain.c   |  8 +++++---
 fs/ocfs2/dlm/dlmmaster.c   |  5 ++---
 fs/ocfs2/dlm/dlmrecovery.c |  4 ++--
 4 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index fe4fdd09bae3..6ca8b3b68eef 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -260,10 +260,10 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle)
 {
 	char *buf;
 
-	buf = (char *) get_zeroed_page(GFP_ATOMIC);
+	buf = kzalloc(PAGE_SIZE, GFP_ATOMIC);
 	if (buf) {
 		dump_mle(mle, buf, PAGE_SIZE - 1);
-		free_page((unsigned long)buf);
+		kfree(buf);
 	}
 }
 
@@ -280,7 +280,7 @@ static struct dentry *dlm_debugfs_root;
 /* begin - utils funcs */
 static int debug_release(struct inode *inode, struct file *file)
 {
-	free_page((unsigned long)file->private_data);
+	kfree(file->private_data);
 	return 0;
 }
 
@@ -327,17 +327,15 @@ static int debug_purgelist_open(struct inode *inode, struct file *file)
 	struct dlm_ctxt *dlm = inode->i_private;
 	char *buf = NULL;
 
-	buf = (char *) get_zeroed_page(GFP_NOFS);
+	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
 	if (!buf)
-		goto bail;
+		return -ENOMEM;
 
 	i_size_write(inode, debug_purgelist_print(dlm, buf, PAGE_SIZE - 1));
 
 	file->private_data = buf;
 
 	return 0;
-bail:
-	return -ENOMEM;
 }
 
 static const struct file_operations debug_purgelist_fops = {
@@ -384,17 +382,15 @@ static int debug_mle_open(struct inode *inode, struct file *file)
 	struct dlm_ctxt *dlm = inode->i_private;
 	char *buf = NULL;
 
-	buf = (char *) get_zeroed_page(GFP_NOFS);
+	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
 	if (!buf)
-		goto bail;
+		return -ENOMEM;
 
 	i_size_write(inode, debug_mle_print(dlm, buf, PAGE_SIZE - 1));
 
 	file->private_data = buf;
 
 	return 0;
-bail:
-	return -ENOMEM;
 }
 
 static const struct file_operations debug_mle_fops = {
@@ -775,17 +771,15 @@ static int debug_state_open(struct inode *inode, struct file *file)
 	struct dlm_ctxt *dlm = inode->i_private;
 	char *buf = NULL;
 
-	buf = (char *) get_zeroed_page(GFP_NOFS);
+	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
 	if (!buf)
-		goto bail;
+		return -ENOMEM;
 
 	i_size_write(inode, debug_state_print(dlm, buf, PAGE_SIZE - 1));
 
 	file->private_data = buf;
 
 	return 0;
-bail:
-	return -ENOMEM;
 }
 
 static const struct file_operations debug_state_fops = {
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index dc9da9133c8e..97bb9400e24b 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -63,7 +63,7 @@ static inline void byte_copymap(u8 dmap[], unsigned long smap[],
 static void dlm_free_pagevec(void **vec, int pages)
 {
 	while (pages--)
-		free_page((unsigned long)vec[pages]);
+		kfree(vec[pages]);
 	kfree(vec);
 }
 
@@ -75,9 +75,11 @@ static void **dlm_alloc_pagevec(int pages)
 	if (!vec)
 		return NULL;
 
-	for (i = 0; i < pages; i++)
-		if (!(vec[i] = (void *)__get_free_page(GFP_KERNEL)))
+	for (i = 0; i < pages; i++) {
+		vec[i] = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!vec[i])
 			goto out_free;
+	}
 
 	mlog(0, "Allocated DLM hash pagevec; %d pages (%lu expected), %lu buckets per page\n",
 	     pages, (unsigned long)DLM_HASH_PAGES,
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 93eff38fdadd..aee3b4c56dcc 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2548,7 +2548,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 
 	/* preallocate up front. if this fails, abort */
 	ret = -ENOMEM;
-	mres = (struct dlm_migratable_lockres *) __get_free_page(GFP_NOFS);
+	mres = kmalloc(PAGE_SIZE, GFP_NOFS);
 	if (!mres) {
 		mlog_errno(ret);
 		goto leave;
@@ -2725,8 +2725,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 	if (wake)
 		wake_up(&res->wq);
 
-	if (mres)
-		free_page((unsigned long)mres);
+	kfree(mres);
 
 	dlm_put(dlm);
 
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 128872bd945d..9b97bf73df22 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -837,7 +837,7 @@ int dlm_request_all_locks_handler(struct o2net_msg *msg, u32 len, void *data,
 	}
 
 	/* this will get freed by dlm_request_all_locks_worker */
-	buf = (char *) __get_free_page(GFP_NOFS);
+	buf = kmalloc(PAGE_SIZE, GFP_NOFS);
 	if (!buf) {
 		kfree(item);
 		dlm_put(dlm);
@@ -933,7 +933,7 @@ static void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
 		}
 	}
 leave:
-	free_page((unsigned long)data);
+	kfree(data);
 }
 
 

-- 
2.53.0


