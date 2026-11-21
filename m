Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0DE606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V+Uo7x9Q
Received: by kanga.kvack.org (Postfix)
	id 6A29B6B00EF; Sat, 21 Nov 2026 11:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6528F6B05B0; Sat, 21 Nov 2026 11:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541916B05B3; Sat, 21 Nov 2026 11:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1713E6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:40:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5660D40557
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:40:27 +0000 (UTC)
X-FDA: 85459689294.22.3616895
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8622D140006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:40:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V+Uo7x9Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of pocj8ur4in@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=pocj8ur4in@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795279225;
	b=f6IAcH6dV76NWll4LmDKm2LX4Zc8DwSAZSClFCJ33ZmQm23VykHflO90ClhhOfGNVWij51
	1rz6ykE+XdC3zGRUc6wnsMBUPuAXoMF0aeXJpHk8tphZ6dW7tHbHoIVTKvBC+G/eG0dXsT
	sm8DMxUk+Zy16e4coFBBRjt6y9M4Vic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795279225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VF70xVoqzD2NvrvaiuYe3HOvhAKV5aI6KvFLBn3iiJM=;
	b=bnclx5spX3qsuCNa67l+6akQH+CBaeGIbhaBe+0sP9j9egyzHvpbra35HfHnHrEp1qLzS2
	ZTiCVMyAMMzls2RBItoN9/yiITeeoepqQaPAdJsFWOJngRwOaIUpXFxMjgAOqka9MUVVuk
	4qvpxqmbpEro5sJfS7E4e/ZASkN8JUU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V+Uo7x9Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of pocj8ur4in@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=pocj8ur4in@gmail.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3866a784546so2108694eec.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795279224; x=1795884024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VF70xVoqzD2NvrvaiuYe3HOvhAKV5aI6KvFLBn3iiJM=;
        b=V+Uo7x9QU5CWGp/NLiQ+/LqNLU26/LJazD0spRayslANf9AHC8ci0y2RbPV51lW3+X
         1kIXQkUaTm/7CpRRWQEIj3NpMyxxaruG897aACoFuW9BWSMopsQl4E2mPWwxTYC+sxFP
         lFzhwR06S41uhTymmdGnyF12U64EVDV0RrEZPRTjQaeuu1fVTejelr8QWFpfgiU1jAab
         yn1DB+bAvc0kSnq0QeLJ4jht/5/+QS9+qgEZQXCvo+8H6kvgn9NiMWNWJLyfSsYYgmNv
         PbisYOT86phfcL8zqzUaXt0O4EWI3VhvnIltETFOD1AsfdZczA4EmKUCDToZ8MXDShUG
         Qebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795279224; x=1795884024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VF70xVoqzD2NvrvaiuYe3HOvhAKV5aI6KvFLBn3iiJM=;
        b=n8jh8t9KZQJCatjXWBIaMH3XmwZGI4PH9ZU+FSPm8l9xk26PeeQpOjFrmY/UWB0GFE
         VttA9+I8dH78Vw9RVKRwNYaLGG3UVd4yqkdLJUpTcEqy+4bESN+it+aU44S/uDK6gz7E
         g9zJbvZP8AD0yYkDJi5XxAkJY2YBmEei2Yh5xrKjxQiO8dU+QRLR2wLsY1cG0AIvrPt7
         SUM28Kb9GunUoW5lMIQV8iB3/gOq6Qvd4TPnF2agRFwP0HdWjMjqbeN9bxPkEeiqVu4n
         F+2gkAQ/aUe8ij/QtwqGtq7mEUSEqbyCTjuKS+KBgtjU+UwZFxA8sFJq17VBXNoldXdz
         d9eA==
X-Forwarded-Encrypted: i=1; AL+hErEnGrR7qU+KAJPnYEmDooKMxJzM2u3PN1kDIGxa1+9ZFJgT/7N3j6POBoWQXP1zI6qx7V+fYozxKQ==@kvack.org
X-Gm-Message-State: APuU4Z8DI/KAO8sNPlSj7u1gNIZBZTvZHjVKcPhngXXtPZvTsf+fsXiC
	Nfu4L32obEBtIBYjYVnAMUDrFLNd9Bl/aGRnO4etJAX2Dnjoo6Id+nUA
X-Gm-Gg: AZFdTZdfXDX+GPb4AS/Ir0U0XCqY9Vw4GxcL/Wca/Zp3b0YA5UxKi7WUosSiywxrCAm
	MLNMfMuRI7UJDFRjstzZRdPQNAoke0h2kGbXmLfdK5uBseeK/Uq486W0Vr084w7k7jyjCz6SY1V
	uui7BJyEAyMO34M3I46OMVbFozpPNK+qYY81eeRdPGyjkXcozeebCBId9Uw8Tyi2vXZ45ko57Iv
	A/fCXkARn8yUCZDMxYE/pq7tv3e12lIC0g+wS/yfs/RTfOtsBpxIlzBBQz7v4/NerCEIRYDMBag
	VY4aEkir2IZaMCn9S+iGrEfMqDg/tcCT0LcKJP6rGg71uVlTYMPV9HZIkjnqruUYuY2aw4DR+bo
	h3L/wb+xGWXADQEwDQQ6IqkClV6Ib0xww8kziJh9SFu1AI4cRnRNvoCqEpxXKWIyQi6uFKiw7YI
	Z1U2lRprZ3xFUQNVzEvw33e5Wjmxog2DzDNT7UusrJUhwwQdCm2f8XgeUY3dGiXBacnjdBUo2Nk
	OQZSABctdaNXDi5lmz7ex/nlvDOJeRMrkXhUHJSV4SgZY6VN0TwPD3BW1lndqMrnbKUiwSd7CMf
	yw9T582nDf7Y+iUoGDApy4e4RNqHx3XA29xb3myCjWg3Ow==
X-Received: by 2002:a05:7301:9a81:b0:384:7a8f:3bc1 with SMTP id 5a478bee46e88-3856fd555eamr7609789eec.17.1795279224072;
        Sat, 21 Nov 2026 08:40:24 -0800 (PST)
Received: from asahi.tail4da9e3.ts.net ([218.48.198.193])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c371esm18710807eec.23.2026.11.21.08.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 08:40:23 -0800 (PST)
From: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/secretmem: Keep locked memory accounting until inode eviction
Date: Sun, 22 Nov 2026 01:40:20 +0900
Message-ID: <20261121164020.1465498-1-pocj8ur4in@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261030152407.113568-1-pocj8ur4in@gmail.com>
References: <20261030152407.113568-1-pocj8ur4in@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8622D140006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: sf1ei94dqx9syrnpbfkggytadphmxe47
X-HE-Tag: 1795279225-548514
X-HE-Meta: U2FsdGVkX19dTEnoy2OoEed9TG0rdTsLEqj1WXpMjlC4hbWFnFpxEPYHIbt5pHIVma0BFmLvKp23VgTTWCt2Fwvih+RQIpVlWPwG7Db4tDXqLZZqi/FXpQ/KzKfDdqfN+XYMDcjGt91jHcn/oiUMAXQg+HuVGqQ3hw8fpogEKY+AzYQc2GDeHT0+N7St8ktUFfay5JB2uC5wMXzN+PUxtMreeMNUaeGx7EkG/oBsXM9uRv9m7WND/DSQXLNF10o4dZZc5ekTMW8u9dr414wn7qKV6oyv5bCSSpl7Yv/rUfZC/TLzrEySyTjihVff/Z/g/Fvs99+7DvTBamGpYjIqWDT1VkwsjnLGxE6SJqvDUgKO2xL8XQmzNWd+ar0vXZfBn2s82USNKy7ThyyD6EFXjmGWBR3zY7+S9gDoqE8iTeu8eXANjfCPYjO71BKdJaV1hKZngIAj6HbCaUW+Pw5YyUY+FaWOplgiWoljf/IpPiyBLPG0o5FXRejnP+7xwfZJNtoda+MX0EbujyMtd+YP9hoZEGbjPg5DPmJVCnAZ4SIjqUlaADykIKgarTOJi8a1+XLdfzCOmZNfUTD0RGwO4cIeh5iskgXNq2Y0YIZU47sEjjeSRkHQA+TU8bl0Adfkq5LZVRtvOW4cjF4sPp3hPTP/WHsPminN2yPg0qZVBp/AtxtJQiI79s9s755SSY6Ydmo1UngCXfW7GX4CjV1StY6BeuRXtotxwDtpF2Aw/OD2SVLkcHTxxVxshcBnjrjptDLBBWEJcFwO6F1llVQnRd6i0roN00wU08AQxMracqmFh7Xlw02xtllWc+q0GHB+BKCboi9YMFxzZb4BKperR8VOVSuUZZrZtocvRkmiCESd00LCHBF93kRmaYoeRn3hVeB4dXRHUZ013+Ooq1rRBHYocwahY9JhuTOJjYLSopG98/nI5NcuJAh4rznovC2qr3CeqVvbxG2FGoHJPeK
 6LZC/hL0
 hztV5pxSGD1nvZ6cIvUFW+6iRMxtId+fL2h5OMqqFaDfpS9TWmCbxlkttB2OjzmwWw+D9Y5qAlmColHG5rFvPTNG5EY4FFAX85+ekH6LNp3gSSaAP+C85ES9nT94/tBupVDkDJ/Lxf4YKUDVlIZGZhIr42NkIOnNW+7Zh+awcW0bxcUP9jcbhw/Cit2YHRuB4FLCn5Pve4fWZyRdOqBDthu+fj769+4XfbkCBoId2zuU2+uO3MxER3+9NXbloEOCF/GrWI12I//e0vvzZkuKCUFRqnPwVn+OQoI8tdDYZYYSv1ktHwdABqx2g/ed5Q73XmTJV6rZogGz2aQx/nrsFiMHNqDkWRGmWjVb6aEMqTPT8E1Leew2eYRaNY4qsLx2UjbC9XweoWTysGpJ8GzouGk7z08sox//Hub4cAPHQelwFdyNVtlJ4p7lhYLIczHNT3suzXG4XBQsECUWONlbMjUb1IJi5Wsm6ALg8t2FZ7BLQvjH3x9AROslOiCZzB8gcj5DRLG593qtwykJO2LErPen+GtyKM3O8ouU4sZEpZV0t8HBRCPMkJDUEku6eetUq7JRcJoNxpC2xms/bICMzYp9Z1Fmt4rtM4jcwSO6Nn1LMBz5wTzgb4AvVuiomig5uid/H9X+LWhQY2RPy3KTbxMtekWStRJQzm9bxmx3NicwCw2yrEnjlUsfO7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A secretmem inode can outlive its original file. An O_PATH descriptor
opened through /proc/self/fd keeps the inode and its unevictable folios
alive after the mapping and original descriptor are closed. The file
release path nevertheless drops the locked-memory charge, allowing the
same user to reuse RLIMIT_MEMLOCK while those folios remain allocated.

Move private-state and locked-memory accounting cleanup to inode eviction,
after truncating the page cache. Keep secretmem_users active over the same
lifetime so that the hibernation guard covers retained secret pages.

Allocate private state before inode creation and release it if the
secure-inode helper fails. Attach it immediately after creation so
later failures can use iput() for cleanup. An LSM denial inside the
helper can call iput() before i_private is set; skip private cleanup
at eviction when i_private is NULL.

On arm64 QEMU with an 8 KiB RLIMIT_MEMLOCK, the original kernel allowed
an additional 4 KiB secretmem fault while O_PATH retained two pages.
v2 rejected that fault with SIGBUS and allowed it after O_PATH closed.
Injected LSM denial and file-allocation failure completed without a
crash; file-allocation cleanup returned secretmem_users to zero.
KASAN, lockdep, hibernation and long-running concurrency were not
tested in this v2 run.

Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
---
Changes in v2:
  - Allocate state before inode creation, as Mike Rapoport suggested,
    and free it if the secure-inode helper fails.
  - Guard private-state cleanup in secretmem_evict_inode() because an
    LSM denial can call iput() before i_private is set.

Link to v1: https://lists.openwall.net/linux-kernel/2026/10/30/1883

 mm/secretmem.c | 58 ++++++++++++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index b3f79ad56790..5a7378b62bb2 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -189,14 +189,7 @@ static void secretmem_destroy_inode_priv(struct inode *inode)
 	free_uid(state->user);
 	kfree(state);
 	inode->i_private = NULL;
-}
-
-static int secretmem_release(struct inode *inode, struct file *file)
-{
 	atomic_dec(&secretmem_users);
-	secretmem_destroy_inode_priv(inode);
-
-	return 0;
 }
 
 static int secretmem_mmap_prepare(struct vm_area_desc *desc)
@@ -216,7 +209,6 @@ bool vma_is_secretmem(struct vm_area_struct *vma)
 }
 
 static const struct file_operations secretmem_fops = {
-	.release	= secretmem_release,
 	.mmap_prepare	= secretmem_mmap_prepare,
 };
 
@@ -264,39 +256,34 @@ static const struct inode_operations secretmem_iops = {
 
 static struct vfsmount *secretmem_mnt;
 
-static int secretmem_init_inode_priv(struct inode *inode)
-{
-	struct secretmem_inode_state *state;
-
-	state = kzalloc_obj(*state);
-	if (!state)
-		return -ENOMEM;
-
-	state->user = get_uid(current_user());
-	inode->i_private = state;
-	return 0;
-}
-
 static struct file *secretmem_file_create(unsigned long flags)
 {
+	struct secretmem_inode_state *state;
 	struct file *file;
 	struct inode *inode;
 	const char *anon_name = "[secretmem]";
 	int err;
 
+	state = kzalloc_obj(*state);
+	if (!state)
+		return ERR_PTR(-ENOMEM);
+	state->user = get_uid(current_user());
+
 	inode = anon_inode_make_secure_inode(secretmem_mnt->mnt_sb, anon_name, NULL);
-	if (IS_ERR(inode))
+	if (IS_ERR(inode)) {
+		free_uid(state->user);
+		kfree(state);
 		return ERR_CAST(inode);
+	}
 
-	err = secretmem_init_inode_priv(inode);
-	if (err)
-		goto err_free_inode;
+	inode->i_private = state;
+	atomic_inc(&secretmem_users);
 
 	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
 				 O_RDWR | O_LARGEFILE, &secretmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
-		goto err_free_priv;
+		goto err_free_inode;
 	}
 
 	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
@@ -309,11 +296,7 @@ static struct file *secretmem_file_create(unsigned long flags)
 	inode->i_mode |= S_IFREG;
 	inode->i_size = 0;
 
-	atomic_inc(&secretmem_users);
-
 	return file;
-err_free_priv:
-	secretmem_destroy_inode_priv(inode);
 err_free_inode:
 	iput(inode);
 	return ERR_PTR(err);
@@ -335,6 +318,20 @@ SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
 	return FD_ADD(flags & O_CLOEXEC, secretmem_file_create(flags));
 }
 
+static void secretmem_evict_inode(struct inode *inode)
+{
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+	/* The filesystem root and failed secure inodes have no private state. */
+	if (inode->i_private)
+		secretmem_destroy_inode_priv(inode);
+}
+
+static const struct super_operations secretmem_super_ops = {
+	.statfs		= simple_statfs,
+	.evict_inode	= secretmem_evict_inode,
+};
+
 static int secretmem_init_fs_context(struct fs_context *fc)
 {
 	struct pseudo_fs_context *ctx;
@@ -342,6 +339,7 @@ static int secretmem_init_fs_context(struct fs_context *fc)
 	ctx = init_pseudo(fc, SECRETMEM_MAGIC);
 	if (!ctx)
 		return -ENOMEM;
+	ctx->ops = &secretmem_super_ops;
 
 	return 0;
 }

