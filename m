Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1749AF531C6
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCAF6B009E; Mon, 13 Apr 2026 14:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5B66B009F; Mon, 13 Apr 2026 14:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDFDA6B00A1; Mon, 13 Apr 2026 14:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD02F6B009E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DFD11401F1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:36 +0000 (UTC)
X-FDA: 84654426192.18.2B809F0
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5A3D140008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=j7lOwTdC;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waUYooNMPBQNAZcuPuj3TkxfF0rm3JDxq1HAEw9JCDI=;
	b=3Fp5F9BM6xLWS1OUmtp8WLIPZwwEAD/rmaBwdR9JgnKTxYwNOgc2lRmrf2F5dsm7M+z4aI
	BR4NM2kCaaw3DHp4vXiDkRPivyNUvxHATnDimw6h3omPqYKHTKZ/I3TwnLzJoEZhSNwlwF
	t3Vr+seDzqpHNGpuFqjP14DmmNCZ3B0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106294; a=rsa-sha256;
	cv=none;
	b=AAxt0z/e/AArq0gU852V2mYOCHCJWqxYOY6tf+iKcH5Sc117pSMC1wiFOMS4p6qfKlVdyN
	YoMLxOZ1V925BZoUkux3Af3trM6pCWgcXiOXQcEY9GofzZln/ysAjxbVlT+gnoc37/lMI2
	21O6KTI8UvnRtu6NZndqkKEpPSrOOQs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=j7lOwTdC;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8d00cf835b7so570909785a.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106294; x=1776711094; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=waUYooNMPBQNAZcuPuj3TkxfF0rm3JDxq1HAEw9JCDI=;
        b=j7lOwTdCbrKDvNsfF508SbCdk4e2cdGQJzvv4n4fGn6hu89CE3mdthZ9mnH0tgq3Qc
         BYBaeT5Mhg9MphNhgRUZCJXJyj193l4eeULXDZyBIQ0uhqQxvX5RfTyvNoxNx/sS9ivL
         v6nQUdNHPCkehSMTniDH9YRjv3ZdksEN6d8B8os/t/oru9UFctLFXJc1P5dvm58hw0DO
         S04i27y1qcyiD8uNt67+TNXhnYDmrdii39QEmNq8M21f5IwEDkLN/Ax1DhuhCO98Jkci
         REsI1uES4UuzLwUQ576jOxTgnhJXTwMUStHo0ntsKkIeEiZV5lDXnMAJnLxewVlIFfSo
         5izw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106294; x=1776711094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=waUYooNMPBQNAZcuPuj3TkxfF0rm3JDxq1HAEw9JCDI=;
        b=gAPbbL2tnV1OP0yFrMD1Ez2uT9+lNZHY2Ye1/lrgfTeyl4z/6zPdxyheXdXvOS2x+Q
         CXHqVR6D+AusXz9kwBXtzhpT232ZVK1XrsBrWjhFoYcQ8xiED/elEhIhxwYYpLCJ93c2
         bo+9xPW11Sy58V55It5Yr3y2/mQhhA/OtCJFObM1KKdAgDFS4JooCz40rwer4NomZt1z
         Ie0xteCJ0mh4GxuUDvq3PmYuV767bW3oh5/CAcA1sTpXkXUiQGrBhuJ6YF6G9k7pKPNS
         Pr/+noXIVGRuY99OsdAnZCdSTsU2bh+yebjh0EUc6eid56USAyVrtGq7Y0rwEcOljrrZ
         wsJg==
X-Forwarded-Encrypted: i=1; AFNElJ8jJ4CIkVD+BedB0bC2rPtr5A/NhFQZgs2FqXWpb6k5bqQZ8+1HT37CodAndgZB7hR3O7augwnkTQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8LdayWV2ZQas4y+PodAIFG6Jw4W/hvJt1ALcNRD+kV0qA9/DT
	WNLvTcTVaHyldj6h61+8ktlUc6YfhqX1wjktnE0pZ41BxDH7RvSCwdhtcr6ZLUYJmEQ=
X-Gm-Gg: AeBDievrHlpM2Hf2vNxWh/HA+QMcSlouUkMjjqPmuVFM7qO1ScNKD44fS9r71ZwT12q
	ltI04EusakxnDhWavaKyIEy2lOILKVgXw4uuJyzelSPyFQMczsSuotDw+94k25wybArnRy6pL2+
	gq3G7eF8VFKURyMc7ahOTRUb/CTfg+pH/DyjRqz7+Agjy0bv3fh1KE1vQ6mSp6lQ9+qoQ/PgMxv
	XhOUxVVLkQW0b7bKVlgbqzyFam5+FuGpLt/I3vc/pDV4jIiEcgTkPlXB+ygcKL2t8CZkeEtA7xy
	HgYkwIe80HyOo7a5fAevIep9Dm1cd5/idZyifpBPl9jpihFtUbi6nlz5bazof/QKNxJapj4RZVs
	WuMI3D6WRaca7pBD8DFmAMuzBNSWlsAqKrCKTyeOyW9IkMEmZ/S5dIltRl6VnEvjrRheu5azimP
	vl1CxSXI0TLq6rNxEuOVTy3/BheLBuAjH/paRXW5V0lK6zTpeutYvWG5N4lKhAZr0dqg==
X-Received: by 2002:a05:620a:468b:b0:8cf:da2d:d6d6 with SMTP id af79cd13be357-8ddcecbd97bmr2034499385a.36.1776106293502;
        Mon, 13 Apr 2026 11:51:33 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:32 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 03/11] liveupdate: Protect file handler list with rwsem
Date: Mon, 13 Apr 2026 18:51:19 +0000
Message-ID: <20260413185127.128180-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A5A3D140008
X-Stat-Signature: qewf1jwqq1b1fu86uzro6iokhzt53apt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776106294-924154
X-HE-Meta: U2FsdGVkX18BVu5GhnjDek5KU9jx+hcolKjX1irteM4NVcD5c8UF7eFZL0jLn2xWYAVWvXGx/VQTwgZQggX6DrnC5ZPUmjiqEKJ//UwZK3lTIDnF+cxv+apx4DEYCFrM5PIuTchh1r6e5xPHUduvOi170y+JTgf0mvQJszGPR1ZtdfXdhcTqD+NogEHYUkyGeiQKyDehW4APlD/KcXxBNYVtzEWE9Ypk7vhONE5IopTNfqj8pnu9OD6bTxzxdkrVMan0pEfnrCd4uBKRTUukXKMqjeM83IfQRlQnY687uvXTD0LFJOF/eVG+rewSAcqjoBdXxVDnocME2d79l40ZjJe+P0Ygf+KqfbXtgZn0weMWRMilT1q5xb/e4U6BukgHICdmnjRg8rJfkh3U9x0VHxdRy5VSBtn2JsPgPcoY+kOl5644UWJqhlibeH2+vUoUG4/zh0YfP08p6lZdRY9s1qGToHclRPXPGafDQuuVE0rU+41Q34kNy8qaEAuaaOLLL5cY7DUtkcv7Js+A7XUWlSAovmMG9T5EpirQTHcgHHR0ljLuarVzSqwJMulKc3ykd5YUfOEzEI7Ajtejv6tgCpb2hoPs6nGcMv6p8YYPJvtVovEsySL5ftZaUDtbuASiJ8advzCQbNBSbSFMnXBr+KFvj+WogHI7NelYffy9LQJOmy/o7jyVqoMZ1LD+DzcnU3SxWqjYkvqCvwMu7AJqMHEVt1zc7c89UPsqxEQO2id9La3TLGtYbRLx7xPARbQoNynf6dezdeIEGEfauGJZdXgwG5PoiKNSHxAbFa80cl5PmYbcDk5XD9EpN4lf5t8wW2Ih3DlcJq3T7gHbcVu4ouo3fyJ2/MMQe15kuiWKn+nIU13UNCAhol8qamyYifniXmq/UzEj7YwytmDOEQX9PIL7jhP8UpXThflDvHYGJTiYWDLCxtyg2soNyzd2fmZTFOkvC4GoiRaSKwLhgB9
 RY0hEmV3
 M63HpaodeaZ6Cwi/AiPSzlii4932W45rU9ItWkmzlW3hiva4Nk28SPS7iqYYhqAZFhvk2vCfKBl+Tz0ZyzdlDXT1jUdY6jTrsGMgJAFOcQ9kP1yvoeAResocoQ+MPUKmlLeNiVVKBY9FjdF8ws5I6VnoXp+QJrU4JIs0ccx7q565VOcuuXwQgv9sKEQ0i0b/rZ8nCKIhrMz5/wmMa8XgkSMutZ3Gs1AbEB/iZjo6ySMY8oof20wlAhod2wubDkL5TJEeu0cids8YPEGEGveM6i3jXyAu0GVtHk5L9sabGI/aFKSlDarHEwCP0i2GWIC8mU+QhC5VZZqyvlabI2nmtNknyGuxE3+NYOxt8XDaWk+MMVMerrDhPSfkA1z24ulTCyAYG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because liveupdate file handlers will no longer hold a module reference
when registered, we must ensure that the access to the handler list is
protected against concurrent module unloading.

Utilize the global luo_register_rwlock to protect the global registry of
file handlers. Read locks are taken during list traversals in
luo_preserve_file() and luo_file_deserialize(). Write locks are taken
during registration and unregistration.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_core.c     |  6 ++++++
 kernel/liveupdate/luo_file.c     | 31 +++++++++++++++++++++++--------
 kernel/liveupdate/luo_internal.h |  2 ++
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 48b25c9abeda..803f51c84275 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -54,6 +54,7 @@
 #include <linux/liveupdate.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
+#include <linux/rwsem.h>
 #include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
@@ -68,6 +69,11 @@ static struct {
 	u64 liveupdate_num;
 } luo_global;
 
+/*
+ * luo_register_rwlock - Protects registration of file handlers and FLBs.
+ */
+DECLARE_RWSEM(luo_register_rwlock);
+
 static int __init early_liveupdate_param(char *buf)
 {
 	return kstrtobool(buf, &luo_global.enabled);
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 8fcf302c73b6..ecf780d74d80 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -18,9 +18,10 @@
  *
  * Handler Registration:
  * Kernel modules responsible for a specific file type (e.g., memfd, vfio)
- * register a &struct liveupdate_file_handler. This handler provides a set of
- * callbacks that LUO invokes at different stages of the update process, most
- * notably:
+ * register a &struct liveupdate_file_handler. The lifecycle of the registered
+ * handler is expected to be bound to the lifecycle of the kernel module that
+ * implements it. This handler provides a set of callbacks that LUO invokes at
+ * different stages of the update process, most notably:
  *
  *   - can_preserve(): A lightweight check to determine if the handler is
  *     compatible with a given 'struct file'.
@@ -288,17 +289,20 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 		goto  err_fput;
 
 	err = -ENOENT;
+	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
 			err = 0;
 			break;
 		}
 	}
+	up_read(&luo_register_rwlock);
 
 	/* err is still -ENOENT if no handler was found */
 	if (err)
 		goto err_free_files_mem;
 
+	/* safe to use fh because its module is pinned */
 	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
 			file, GFP_KERNEL);
 	if (err)
@@ -805,12 +809,14 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
+		down_read(&luo_register_rwlock);
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
 				handler_found = true;
 				break;
 			}
 		}
+		up_read(&luo_register_rwlock);
 
 		if (!handler_found) {
 			pr_warn("No registered handler for compatible '%.*s'\n",
@@ -823,6 +829,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		if (!luo_file)
 			return -ENOMEM;
 
+		/* safe to use fh because its module is pinned */
 		luo_file->fh = fh;
 		luo_file->file = NULL;
 		luo_file->serialized_data = file_ser[i].data;
@@ -879,32 +886,36 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
 	/* Check for duplicate compatible strings */
 	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
 		if (!strcmp(fh_iter->compatible, fh->compatible)) {
 			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 			       fh->compatible);
 			err = -EEXIST;
-			goto err_resume;
+			goto err_unlock;
 		}
 	}
 
 	/* Pin the module implementing the handler */
 	if (!try_module_get(fh->ops->owner)) {
 		err = -EAGAIN;
-		goto err_resume;
+		goto err_unlock;
 	}
 
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
+	up_write(&luo_register_rwlock);
+
 	luo_session_resume();
 
 	liveupdate_test_register(fh);
 
 	return 0;
 
-err_resume:
+err_unlock:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -938,16 +949,20 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!luo_session_quiesce())
 		goto err_register;
 
+	down_write(&luo_register_rwlock);
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_resume;
+		goto err_unlock;
 
 	list_del(&ACCESS_PRIVATE(fh, list));
+	up_write(&luo_register_rwlock);
+
 	module_put(fh->ops->owner);
 	luo_session_resume();
 
 	return 0;
 
-err_resume:
+err_unlock:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 err_register:
 	liveupdate_test_register(fh);
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8083d8739b09..4bfe00ac8866 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -77,6 +77,8 @@ struct luo_session {
 	struct mutex mutex;
 };
 
+extern struct rw_semaphore luo_register_rwlock;
+
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
-- 
2.43.0


