Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CA1606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bFQOQPGo
Received: by kanga.kvack.org (Postfix)
	id 996A36B00EF; Fri, 30 Oct 2026 11:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947E06B05B1; Fri, 30 Oct 2026 11:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EC76B05B2; Fri, 30 Oct 2026 11:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57A4B6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:24:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE5E7120741
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:24:13 +0000 (UTC)
X-FDA: 85379663586.03.A5DDB54
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18010180008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:24:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bFQOQPGo;
	spf=pass (imf16.hostedemail.com: domain of pocj8ur4in@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=pocj8ur4in@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793373852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sOjJ/ipkNri/OvRTz9tJlBAB6d04Pi9M3rBYJKk4hmk=;
	b=HxIo4mqYXS++hbxG3IGm0ElcVC3IDmcBsXiNVFIIYDtEY2hHVdUkQK0lwrhrzAhYxc7PxZ
	PBiQkLVuOJeSyiuDB4rQOlCEI3VuBxIwtL48PJqdurLfYg19vdCjas7zeVlj0FwDgAJSRP
	V/ap2UtK9nsB8fZbNazyfvLvKjEFfsw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bFQOQPGo;
	spf=pass (imf16.hostedemail.com: domain of pocj8ur4in@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=pocj8ur4in@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793373852;
	b=DapQrSWWmVgkHp382GSeOdYC8cpSz49sRxELVwTAl2L9rFxQT57Wqw8IZ45tojDM2D8Tlf
	T1A/em1CNtLxAEN29y8PArwNnvItg+Hrr5VdBg4Yc2m3zZyt8PysuiKqceStdNWBJIbIKg
	sN2srjCmkYV/o051Rp4fRZB3Ll2BBNI=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso432896a91.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793373851; x=1793978651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sOjJ/ipkNri/OvRTz9tJlBAB6d04Pi9M3rBYJKk4hmk=;
        b=bFQOQPGorOJxsZ98jnhe98jHg5Ab/1nzVB225oE/VBhjn0kAHGDAvhJEwJtLdcTbUG
         oc7P6aDPmblZk0vM+vP1OvS8CekOSkcNBvdTlLqJWKqRbIiQlz/CIEjTpOi5jSJt+MsD
         ECnSOYuU+r6XrB0+eqMargzK6brKEGn+2UdzISUuYS53Za4xR+PfIjCzi3yqA4mXCy+8
         TJAqF0sXtu5TwiH+FcGZOKMQ9kCOdn4w0us8+CfRILK8xxH6a6GEwtsgagKMeC+SudIP
         v4eZYiDcznuL6WFsHtHU3s9eJt5NLxyF+3oNH94B89rUEXderoQdWsBU/T2Wcqd/Jmq1
         0tXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793373851; x=1793978651;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sOjJ/ipkNri/OvRTz9tJlBAB6d04Pi9M3rBYJKk4hmk=;
        b=QVREQt6Bkskz68879oHQSkz9iHihBetzGJWBqduuyxx5ckBO2DSohHy43AF4PK3Lj8
         YkGtM8uc+x2ZfxFzMNMvbiDH4cvdqc6edqjrISxJ/5iUedjm2TEdNFgnGWFXBLZNmVY4
         iYekK7yTRRRqvA/zbzEQCzNF5E7qEmealiDlcz66CAnMCMZgSo44tSRA/4fMn7biS/Bd
         KcPP9S2sYFsxENTz27h6j3k/VhBAyDkPoZN4z/UtKytbygafCIlTPhbXY6XgfAHXdlae
         /wekiFySqWx2HdrAW1XQKy4n0TCITrTgshu5yO7gjapkTtGckLdZhPEDBLin2DAub+PW
         aZaw==
X-Forwarded-Encrypted: i=1; AKwUvBz9ycXE0TfmDtR82xWrJBShv2egEpBqn2bmZyC3Aps3MVGgE8SFnGLF4ru9Rv8ZAq8PKbTE6Oy+Ww==@kvack.org
X-Gm-Message-State: AFq9FYIxJndGL1x3CK5V/s3Vo2kdGyZf4cvZZ/Nxq+K9gflQUdiYCSaL
	sLRCUCwJvArpaJqRM/OlPk7DqSGMtqFEgT0oEMBGiBI1GR0WxhRg4shY
X-Gm-Gg: AYBFou3lKEpdVkfk7ru2GgU0tf1N5hRTQAlzGNVyxkUrGjVm4E4rYcX0UQb3LguP23w
	OXlHD/jYTtrFc5UgTrBh+hAFh4NIuVAhXQgbKlXe+IiaOoczoQETIw3ph0P+m5SbNO5h01CpF5A
	DV10JQ99xPnSTWznCyHlDMhGbFfb7nTMR/aF7A2K6wKIhMyuAZiXv5bUKblfivEK+tNDsWw6Rcx
	dtmTeBqpGk5lFgIJRNcIupy4hsVDWNwdlv1IaFoHQ2yt4GF/Sk1PiprZRnrLIG28BcLR+jO8wp0
	vpg8hN0grUFw81ZgNWJ7qCvhLDvQaaQxr1Y5s77lNZgjfj6+Yc+1OjvLXLLKxiDudvU70BbJfv/
	vOwu+xYByg1jG9IdUtaTsPv3WWV6QjKCaP/VXk9lbGAPCjrn+obcPN4xbUAcUopMnB3btWvik48
	QymjQ/gx48VyZYSKBihhPhsYb7qFxQMirHzX84qWYuM+lILfuJyMG8pjMfQG8l1U4jxQrCdDNCB
	7sxzTHlSGVINbiP9kILZs47X/yDjO71ulIdJqqOnVF+xq6H+tT7+9VEkgFqFyWy1WcNnfhOTkWx
	Mimn7co7b3v6V5JLeoCVobfFuzemXfPfxAj2HLbycBTlZ6Y=
X-Received: by 2002:a17:90b:17d2:b0:3a8:699f:959d with SMTP id 98e67ed59e1d1-3ae89812800mr2221914a91.31.1793373850770;
        Fri, 30 Oct 2026 08:24:10 -0700 (PDT)
Received: from asahi.tail4da9e3.ts.net ([218.48.198.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e973ac6sm9561166a91.11.2026.10.30.08.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 08:24:10 -0700 (PDT)
From: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/secretmem: Keep locked memory accounting until inode eviction
Date: Sat, 31 Oct 2026 00:24:06 +0900
Message-ID: <20261030152407.113568-1-pocj8ur4in@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18010180008
X-Stat-Signature: quyuyzf1ka9kinc6ismqbwtxk6h74kk5
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793373851-765314
X-HE-Meta: U2FsdGVkX19LHw35KKNzi5cdJstMGEcBznM3L0tpImaHdstTeWy3PV5qqH4NRRSoNpe2fs+LKjRjmHof+3B78edgJ8gnxd0WvYNPPCDVkldYnVvD+9JgFbICZuT+BgAjmTnA315u72KwHW4o1XA7Y1cSweitZRwFwIS8VYcn5QBxodCPnE4TGhDdD+N7x2WK/pZgQC2uLsU8JorJj7VzuiW10lTFN35/jex5Z4yQZ/ghT9xwGOYtx38mknW1k2AFvqb5PnHcmG9C3oAqHAiPYfzM0iCO97r4AOWiDv5keP0EI9cVdHcXAEyCFotCLCt/J33uig3B0eZFUQPQJyW/qRqyDoTTugBF5at/Q8/J/sG0aPA1yq08B2ZKyCh7EAjWdK3qp6U/ZVBjnJE5dEP/vuGyp2f8mCPVKEwhAj56+uAGy61KY14N8G0MR4w5S1HU76GxvhA/58bLvv49gviX4Bu2+VF8cjZJG9rXdyIDTnjSlacoj/vnowT/MkAEjkHt6HWwE8XJJ13/RCu2hxrr+vBJ8pEv6cKgw9bPa6oGin93vkQ84cn6RpPSgeflZRFWIIBpbv1oxfq+4YSRvxRI9Frpkmq8Nw2XYIvAi0Mdeh5rELXkq4YKIuVIy0Z2/3u2M2rSv6vPl3SXoCN3vmkct859DJSpY6loQZVbeiHWWgHrv1duKrAHUdRqks0unq1K5TgLgA+nxKShoKxLY/6rm3scVVL2hfuwOKDVzdCsf7t06kdXYD5dwYH7PVpolA46TAUOyHtGY4zcqhVPu4fVT/ls9d9TRY4svLguzofwjLWWdMsA9ZheLAzHtXq/53aBAKtlkbR58nxUsa4X8b+hFcDjfqQGSuqmJd8d61xykuxHUuRhkhM0V7uV4uzhRZ7CCBycljWZhGd3J2McgrGkAKDrkcCWVhMcIrSfkBMSrKqTcr5M97sXwlJ7dqRwrPv0y3V8SkPxJ4JPDPNkYVH
 JjGueZB8
 A7lIaNDf9feTmj8/tblK2GPKm4M2F0zN7top7GScR+ky+kNMfT8SYTXaerHH9XqKMGK8dD4BI4DXODvP/5UoYswHyNOxRFRLoD2hoYQJx7CY3/apwvXFq3ON9Pc4oC2ti9yEBlgIhKOi4alu5ulM1u6++e+sCWQun2Du36/Yz7XwLJHWJl0r0ekhJcQg6U3cryQGL+Wxv5X/TR2J+pPYUrlib0T9pcApno/8ij/gtaV+2S+9M60u8RJLsPs5z/3OvFuud6dpjpkjyurjqOuP7jaIMuGtAbf5H5vqpv6mugxP3JdMcxcga2HEtjEyZV1vbj7XJfHTgHqU2jNkgQ7YNUMCxWwcGTxdTqNgS94v4lPa4UK8mamUNBMIA6LPAKblX5Ll5PDxa5LXN3Yh2YNwI/Y9rEg==
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
lifetime so that the hibernation guard covers retained secret pages. Let
iput() handle file-creation failures and tolerate an inode with no private
state.

Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
---
On an arm64 QEMU guest with an 8 KiB RLIMIT_MEMLOCK, an O_PATH reference
retained two secretmem pages. The baseline dropped the charge to zero and
allowed a further one-page fault; the patch kept both pages charged and
rejected that fault until the last path reference closed. The Image
was built with KASAN and lockdep. Hibernation, other architectures,
and long-running concurrency were not tested.

 mm/secretmem.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 384f5cfc457f..fa8be360bd2a 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -185,18 +185,14 @@ static void secretmem_destroy_inode_priv(struct inode *inode)
 {
 	struct secretmem_inode_state *state = inode->i_private;
 
+	if (!state)
+		return;
+
 	secretmem_unaccount_all_folios(state);
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
@@ -216,7 +212,6 @@ bool vma_is_secretmem(struct vm_area_struct *vma)
 }
 
 static const struct file_operations secretmem_fops = {
-	.release	= secretmem_release,
 	.mmap_prepare	= secretmem_mmap_prepare,
 };
 
@@ -274,6 +269,7 @@ static int secretmem_init_inode_priv(struct inode *inode)
 
 	state->user = get_uid(current_user());
 	inode->i_private = state;
+	atomic_inc(&secretmem_users);
 	return 0;
 }
 
@@ -296,7 +292,7 @@ static struct file *secretmem_file_create(unsigned long flags)
 				 O_RDWR | O_LARGEFILE, &secretmem_fops);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
-		goto err_free_priv;
+		goto err_free_inode;
 	}
 
 	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
@@ -309,11 +305,7 @@ static struct file *secretmem_file_create(unsigned long flags)
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
@@ -335,6 +327,18 @@ SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
 	return FD_ADD(flags & O_CLOEXEC, secretmem_file_create(flags));
 }
 
+static void secretmem_evict_inode(struct inode *inode)
+{
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+	secretmem_destroy_inode_priv(inode);
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
@@ -342,6 +346,7 @@ static int secretmem_init_fs_context(struct fs_context *fc)
 	ctx = init_pseudo(fc, SECRETMEM_MAGIC);
 	if (!ctx)
 		return -ENOMEM;
+	ctx->ops = &secretmem_super_ops;
 
 	return 0;
 }
-- 
2.55.0


