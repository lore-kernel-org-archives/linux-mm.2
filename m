Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D4DB10A88E5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CFB6B008C; Thu, 26 Mar 2026 12:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247696B0092; Thu, 26 Mar 2026 12:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1368F6B0093; Thu, 26 Mar 2026 12:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 075B06B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:39:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3F205D671
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:39:48 +0000 (UTC)
X-FDA: 84588775656.07.9D2BB7C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 17A54140004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:39:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IEfYTWxB;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774543187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIdUnvgvoju2sn6Qx2mGLJNfJ9th4UndCcaJvlrJfI0=;
	b=ZHyqQYjOx+MweYlj6Xc2rHF70iU/iDasNUsvsz5ylRCOOjKev5BBxOg/zDrqnUlthl57c0
	mh5Lx1jRxZ/eOfiPD3uHgRgOKmCk+q3Z1x9K0e7dTr5LenyrdKEcX6yiXCu12DYzkAqQFG
	7VFMg7Wkm8lZDz9FATksP86HR1DMbsA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IEfYTWxB;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774543187; a=rsa-sha256;
	cv=none;
	b=2kvrllPLDdQw/YXA7V8VvzN6+iJSu7/f6qHTCrX46pXu2n9lbKNN2/dlpUJKr5p5O5A0JK
	93ZXGPBx4ktktxM302H0HX+IjfTLw3yn+t2qKxgEmJWEjkboMFFF/A/PEaZgGV3tllRztL
	Z9fY3mm4wzhBxsogaYhSWTVGmvuzZUc=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50b35f3e489so21252161cf.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774543186; x=1775147986; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hIdUnvgvoju2sn6Qx2mGLJNfJ9th4UndCcaJvlrJfI0=;
        b=IEfYTWxBCir5LgI5css9zVY5q3vzQRvnza069dmeNIjql5U4o4Do1hXxF3H2zG08Og
         HG382jKrZSZfRzyce+XRnyeoVwfLwyVirph/kWk7UfQ9zISfO+ObWV2WZhFb0PkNPezn
         /ZQ1jPbo4UzvFAW2/D6t77tD5VZLgVDGfMyAjk2xD2+oitqrZjr6PAgwdHvAmpU6f3l9
         dcUzpgauJc/RC+6563I+o2wDyBJ2tCM8W/CKvd5ESdi+ZGXpa4dg8pO53QABUSr+QhN7
         DrZD/+St12nJ2H0C3vkJxyrlKeV8UEyW2rzkckLFHEy5LuQDAJW3XSgkSl3cHLGWwJco
         FLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774543186; x=1775147986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hIdUnvgvoju2sn6Qx2mGLJNfJ9th4UndCcaJvlrJfI0=;
        b=IOoxmwEdtlQLL6SKkQCRMTAqD6fpUwGleU0vuq4uQyiLxWfMhMLqP+iJSEYsUMxTua
         Q44JhXEHvp92bbcfzcFgXZBmJgUzfqqn2T3p8rMOt+bNVu6oHJ6eCw7OmLKKEIDw+eC4
         hDhCNynhXeL3sTpE55HeruHHCtUEZgq4GaY3hcxX5vuWxpnRERwGRygVxPI5L2xmLz6W
         xaTCMMWLJrWdr7dSwwMm51LNu5K0VI5D6dWLIL1zVhB8B3DdHp1w6JBxyFIQbVonFSGM
         GerjGkhEhtGvJN3lm2Y/bL30Czji8ElbrviDTpz+Gk4LcD1HbahC0hOvHHaN7UtaWUyf
         N6Wg==
X-Forwarded-Encrypted: i=1; AJvYcCUckn9mSijAB5tCyrTAEhzDAyfp7J0GGdFpAnh1ipmhnoyfce64GVtRdlbWLD/qpH67UsVh7siKtw==@kvack.org
X-Gm-Message-State: AOJu0YyDrGSdMWxL63u58CKd7FcKBdldhxnL801ErpKl/boALLjSU5zw
	xbxcxEiqzdqd1Zp93jwZShR/42cJB2LRX57jDBhQ/hoT0iNu7D4iPhlI33IJE1ZLAnI=
X-Gm-Gg: ATEYQzyKUaMSmnbq9mK+lXda+cI7ZT8ljSyEm4OKv7Lj3muGJ7mJO64J/jpzugswvPt
	+4xwxzu55ux7VFyYxMKutEIIrLHnH3RDYYSll5SggpMQJq8diWcCWxSHSw5Qxvdwsr2JdVirZQe
	aKg+S9l3mKnZ20WI4PMGKQjcyhOaTDDQ/fYhqUdhA3sJiWGb5N51FPhhKlkItpQXXAY04aLyydp
	c1fOrH2Xff+8aLlbRGE4qE387D0O/HxsTti0w+L41jzpZtDfI8xCkySuvk+QUu67Ft2SX12CdAr
	90U+99klY+e3tymD9EPhtCsQ65H6Wou/bTpz7rLFeYU5a91SnPnBrHoTc9gBB0d0jj4s6NYQww+
	xuhCKNQORyw6rGmFl8qODEHbwbEK68rS/vE7DkyxB/jlY4zDVe+HipSeOKc6TmeJVR0cKmKHQHo
	UfMRFInVRnLu8fB7HWra4vWZIkgTyFHrT2w8QRFMqR+PlOCV9spOOHd3YZjvtwFtyopSSslyl8+
	1T9
X-Received: by 2002:a05:622a:8d17:b0:50b:4a3c:8917 with SMTP id d75a77b69052e-50b994a6c29mr24101061cf.24.1774543186042;
        Thu, 26 Mar 2026 09:39:46 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b920f77cfsm28238251cf.6.2026.03.26.09.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 09:39:45 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 1/3] liveupdate: prevent double management of files
Date: Thu, 26 Mar 2026 16:39:41 +0000
Message-ID: <20260326163943.574070-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260326163943.574070-1-pasha.tatashin@soleen.com>
References: <20260326163943.574070-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17A54140004
X-Stat-Signature: cbre866qpoa53ppyditq4f638bj86oek
X-Rspam-User: 
X-HE-Tag: 1774543186-103514
X-HE-Meta: U2FsdGVkX1+Oko9KfST75OsBqrPAMYCc+VmIbm8Ad/oyaZ0FDmGYOXPXZp1SH14iJblRHG8GEIwhuWstq5Y4Oru+D+ElXBJ2Y1mIU6GOmCXDG4kae6oBmC8Wpb1P1mUACDoLA98CrlbmYdyUUfnPJH4GVT0mTvCjfixO0XnLh1K8K5hdyFuLFqwRZ9CjHWGlWlQWy1aWTf2db69wMIhpaDAFs7mhehap7SNADXdzIOgB8iREg33fxZtrcWvTmLjohQI9X+QA8C1aW82Gc0anuW9D5UPP+Fxq9mOSqUfZpOgHoN5B1r+j9gvmJRL0lQzxjZDNEDxsanHKkxKF+DcRtGGHHNqDcCMfhuLWVB6bwp4ZDeELkBVFwdPAB2d75OBGrntm63osJ3DiqUYHq/MH57cltrCi4I9kIXFW+KgsaElOhzThUwNwY+VM1TaZ3JFkPufyTS27CtZtj4doVR9CXpd9hNwUkroC2KSU5mlbPodveZK82nENY1KiKFgsY9Qd1v4XjFBrNAPqbRYuJYv7czW8xj1f2BCIcDh7OUKmuQlcUxMrOQstZbuELYWOov38/b+L8JDmOrGpaalcazu2fZUO8sYwulzVUsFOMtlahutP/H70XqLcCNJwn98I41gdjHI2WkHM6wkEjrLL4uE3ubrTgUJL+n+Fue0clA/GB7+Y41Elh6vKPZkih8iK9f/YwWoBDT9SnhuGY1r96Ye+bvVU4euBq4e1Qjq4fMOaS+6AvqFLB+TRoALw+GI66uxM1b1SG05CJlXNSfKjlmRYRvxJYgIRK1lItLFpbkaQbc3N8rhQXZBFaaWtzU6rhwpu8ce9hrB26MeM5uySr06sDuwX6N0VaDLc2O/CbJQ3cb7H2bqm8Q7YvBQTsgYu9NE8xlTGWSRUOOia5QmlkfzwOqHYog4fCOY5TVqsDs9expOfdMkoaKNyTEMU3iIRst3thMUsGIkLfOBkeu9UIvK
 +kb+oydl
 weEoWeigeYtSIFRtf/W/YNly2/ASPmtFwpBbgTEIpjqAvhUAGnjxjqbktDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, LUO does not prevent the same file from being managed twice
across different active sessions.

Use a global xarray luo_preserved_files to keep track of file
identifiers being preserved by LUO. Update luo_preserve_file() to
check and insert the file identifier into this xarray when it is
preserved, and erase it in luo_file_unpreserve_files() when it is
released.

To allow handlers to define what constitutes a "unique" file (e.g.,
different struct file objects pointing to the same hardware resource),
add a get_id() callback to struct liveupdate_file_ops. If not
provided, the default identifier is the struct file pointer itself.

This ensures that the same file (or resource) cannot be managed by
multiple sessions. If another session attempts to preserve an already
managed file, it will now fail with -EBUSY.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h   |  2 ++
 kernel/liveupdate/luo_file.c | 32 ++++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index dd11fdc76a5f..61325ad26526 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -63,6 +63,7 @@ struct liveupdate_file_op_args {
  *                finish, in order to do successful finish calls for all
  *                resources in the session.
  * @finish:       Required. Final cleanup in the new kernel.
+ * @get_id:       Optional. Returns a unique identifier for the file.
  * @owner:        Module reference
  *
  * All operations (except can_preserve) receive a pointer to a
@@ -78,6 +79,7 @@ struct liveupdate_file_ops {
 	int (*retrieve)(struct liveupdate_file_op_args *args);
 	bool (*can_finish)(struct liveupdate_file_op_args *args);
 	void (*finish)(struct liveupdate_file_op_args *args);
+	unsigned long (*get_id)(struct file *file);
 	struct module *owner;
 };
 
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5acee4174bf0..b02e2891cdb8 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -110,10 +110,14 @@
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/xarray.h>
 #include "luo_internal.h"
 
 static LIST_HEAD(luo_file_handler_list);
 
+/* Keep track of files being preserved by LUO */
+static DEFINE_XARRAY(luo_preserved_files);
+
 /* 2 4K pages, give space for 128 files per file_set */
 #define LUO_FILE_PGCNT		2ul
 #define LUO_FILE_MAX							\
@@ -203,6 +207,12 @@ static void luo_free_files_mem(struct luo_file_set *file_set)
 	file_set->files = NULL;
 }
 
+static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
+				struct file *file)
+{
+	return fh->ops->get_id ? fh->ops->get_id(file) : (unsigned long)file;
+}
+
 static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
 {
 	struct luo_file *iter;
@@ -248,6 +258,7 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  * Context: Can be called from an ioctl handler during normal system operation.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -EEXIST if the token is already used.
+ *         -EBUSY if the file descriptor is already preserved by another session.
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
@@ -288,10 +299,15 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto err_free_files_mem;
 
-	err = luo_flb_file_preserve(fh);
+	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
+			file, GFP_KERNEL);
 	if (err)
 		goto err_free_files_mem;
 
+	err = luo_flb_file_preserve(fh);
+	if (err)
+		goto err_erase_xa;
+
 	luo_file = kzalloc_obj(*luo_file);
 	if (!luo_file) {
 		err = -ENOMEM;
@@ -320,6 +336,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
+err_erase_xa:
+	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -363,6 +381,8 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
+		xa_erase(&luo_preserved_files,
+			 luo_get_id(luo_file->fh, luo_file->file));
 		list_del(&luo_file->list);
 		file_set->count--;
 
@@ -606,6 +626,11 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	luo_file->file = args.file;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
+
+	WARN_ON(xa_insert(&luo_preserved_files,
+			  luo_get_id(luo_file->fh, luo_file->file),
+			  luo_file->file, GFP_KERNEL));
+
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
 
@@ -701,8 +726,11 @@ int luo_file_finish(struct luo_file_set *file_set)
 
 		luo_file_finish_one(file_set, luo_file);
 
-		if (luo_file->file)
+		if (luo_file->file) {
+			xa_erase(&luo_preserved_files,
+				 luo_get_id(luo_file->fh, luo_file->file));
 			fput(luo_file->file);
+		}
 		list_del(&luo_file->list);
 		file_set->count--;
 		mutex_destroy(&luo_file->mutex);
-- 
2.43.0


