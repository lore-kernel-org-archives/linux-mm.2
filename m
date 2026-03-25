Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB6E109C040
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DDA6B0089; Wed, 25 Mar 2026 14:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F876B008A; Wed, 25 Mar 2026 14:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6A36B008C; Wed, 25 Mar 2026 14:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 983136B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:20:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 561DDE0F0C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:20:33 +0000 (UTC)
X-FDA: 84585400746.22.5E0A9DA
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7C1D7160006
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:20:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AMGq8Gfo;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774462831; a=rsa-sha256;
	cv=none;
	b=FFvqOX9zQU71wyLAQSqfHjftbpZeDFwbEyasD9QRngsc8ux77LxvSNxkz6VXQsa7/143s1
	foqgtu1sdsBq4aWplpqNOkZb2h1oDyh4ipITWT7UI6FbjMZKImQ1MfAqQ9Vq2bbU7lRHaQ
	x4yOmVMsK0rgL3xs3QXo6j5yR1UyQuw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AMGq8Gfo;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774462831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLqludGATIl3hRiyxTIx0CjPLFsz0CkRWvUmhsLy2/k=;
	b=ySDVDUtvk3EpzROZt+eNbLC/M6kNUiaxTB68jqW6hDPd03TFJY1IAiaDSDUgEpa3FFUI9M
	SZFlIcQN22EXOHNSKmMODvrP99KyPoq/OXKWfX6CkDv6qMpNXfDS6s4pFxQ/Ls3DzDur0v
	dEbSzm753JCIgC3/g8a0L/SbC7HDE6c=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cfbfdabf3fso22559585a.3
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774462830; x=1775067630; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zLqludGATIl3hRiyxTIx0CjPLFsz0CkRWvUmhsLy2/k=;
        b=AMGq8GfooNTDq3LVy4YPBibG5w2cNy1bYDNVb6Fdp+9s4SM0pK/C5ybvFXyv4m/cJF
         KTBSsZzfl/YmA39kGkYxpO8RE6RP4SWvYo5AeGVElQ4Mp0uVRPT6GXwZ/Na7+z7gLL2+
         FbqyvhTbY9pPeIA+Ukcsfei66beCXyeV5mogasYaCCn5NLwf7eYJZYRvqxqdxfzKEerl
         2W2mGl1+vcQ5gYKQeQyw9xLCZerA5yKp28ukrQWKra6vJupe5Y4Y7s5j6ag592/ylE7b
         o05VAFiwaQoz0BSIR6IMZcEM+aSsrEB2BWRxF5Djh2j6sPfHncA4fhIrYvBGQKJ44z6A
         SbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774462831; x=1775067631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zLqludGATIl3hRiyxTIx0CjPLFsz0CkRWvUmhsLy2/k=;
        b=OMHdcidaiTMHPROWfrKRNs6IjaMD70rgShkVYDDZEkp59Qecfp5VhKnkNgYjQDW8kk
         VhybAL33gRXg6x0MiOibuQQG8X/VXDOSrM6WMaRD21ZweY6IbMHeJKyBDlv8qYxn8MGe
         EsZfBPWFM6+NQxfYEnkwKGngaW1BTw2bdSv4fG9q/xGEu7XKOuNx/mumscy8nNo2ok0T
         736/rsovxOgAe3cR1dN/CO4IZ3nUKciJtrudO3Ngfuv1hbsQHU/VDmQS5tmC1J1DLSyy
         g0aCtEX/DBsON/y+mGtd6fJHDoQyWD3rRtGzznL3MkEp3fGNggl28siERHrVV9n+E/ki
         y25w==
X-Forwarded-Encrypted: i=1; AJvYcCXPnE6KpAsoJcme4aer9YHTSHNgkZSC00PABzap1SOKVPb/qBsWyX0RnVr7/dplovgNMtefaWsaXA==@kvack.org
X-Gm-Message-State: AOJu0Yx1uS3S0VPci3cbh7rdHtD0u1Y+Pw6q8F/Axl2JK9R39exHs/eR
	J2CelWcn4DRjwDmPA2teCRJf2XsX8P9wbk2qbQKcoiDbi1N3qxmitujoVIQTC3Lam8I=
X-Gm-Gg: ATEYQzwKCqm85U2/ULxnd036ceQXadtvq4CP8fkFgoqqdh2G1/Ct8lZsvBPtywTtD4R
	MCk+kJL7NVc97h34waDhQ0w8/VsBhl7fVQz3VGskIFhityUHuAPQxMbl74o+0LkQNdCyF1gXnZc
	1/6u4iOGrzZVhtkY546qLPwO745b1HUprRHqj6LdZyHpA5iTRfIi06SqslPErMk2PKQKfpJgF8M
	Cge1Ty9JGw2YjCJD8A4EUJlrJvTAmbOvrkz14RMuIJ64Ng8WVEFgGyreJflhX0cK1vACm21YOPV
	v6nEHOTmd33T0slc4JCL51zR1pZdg4F6GH2g3GP70D2BI8XEVd6uaeRK4ZHfmNcOiy4jPIp83Tx
	YzNQ1xFMdgYcoEzpmjQI9W1NcfGA4wSnpTN0bRYRl2deDNFWPtMUwH9dpqPrZSIZOmMDfaeFyWC
	1farsE0QSp76rH1Dczujw1JHXjWD4vHpMLl8H6cM6h23cXh+JEEd4qM0wL4S0dFZ2lLg==
X-Received: by 2002:a05:620a:4627:b0:8cd:7811:941c with SMTP id af79cd13be357-8d00103931amr629323885a.54.1774462830472;
        Wed, 25 Mar 2026 11:20:30 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e250556sm64225385a.0.2026.03.25.11.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 11:20:30 -0700 (PDT)
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
Subject: [PATCH v3 1/2] liveupdate: prevent double management of files
Date: Wed, 25 Mar 2026 18:20:25 +0000
Message-ID: <20260325182026.467307-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325182026.467307-1-pasha.tatashin@soleen.com>
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C1D7160006
X-Stat-Signature: xjmk3xggftcs1cs4qdwxz93ceizbkox5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774462831-637460
X-HE-Meta: U2FsdGVkX19nsN2qlmj5c4riN526yraeIlqnuzT4PjhTtNduOFDVtNUcsEx2aFH1u+wt0YnyAJin4MaYjHaYYq7y1odklBEy1LyJ9Ks5BU2CYrkeTS4xIlMstTu6N4MDa7pkNnjgMDYr+0LPXWreHCR4QLeMxvreYOHJMiALrcubsKTvPNic8UV2Y36Ms85cUfcO3Hi5zCugH/YiK7Xwg0OD97AJjatDYl1whSpw/6MEE0fwl2mTkRv5NEJ9OKmWZjhKUxaI0BrGnPHlR4Xryq+HDyVOg2AIWelbvFn9HDD9+8t72phGcRIu3fG1Ma5w9pU32KTfELXKN8xs0GY1/86StnqOywXi/C9u72TdnkER5eZI/Ua4dOqcfDuFoUwuNqTmzC8HhqPhBaRbzed5O8gvAHulTXyRwBSJ3AknMbPEUjLYadXnfujLrnaJVCNP0T4+Q5noZJHhW/IvJ4+lwcrAAwAEKuDXkM3MosmHczKa0COs93I3IwPpa2gkQB4q+Je0WnYPt60LkMQcTjlytfE5OAKv/0SQJOvtmYzws3yTNpVM3+zabjHmW/y2R69/WZTjy3bR40PnBzWClZbrE6P6EwtiQbZA6iX74bczA88A2BHbU6soazhh/JI2nRWmr3mfHy74G/popr/wed7NE4Kx6+Z5gSyyVBOdDiuxUjVjc1hs/6QQRNj3qeqeKO9pYixMRi0CaARYitNd7eE9x3NULlAGcr0TBRCDoHE2J/Uhdqs5fdA7GT4meUTGORxij3GCXVzHxSoLKOiSNyGjYkACsO+wsGdMZkuzp7ro15aH2Ym9fiwvv2gEmPZbXVD911lCfWTlN+akO8fV761530hsMg6Zp3GXO9RIYgPf0WKBMS8QoeS92+/fx5UsuifWvTKtW5rW6eFAuHGZ/M725AaAl/F2pa2HEVqD/JqQjkZZbm6fMnLL6zP7PBpTiaYUTXmZiSuQwBH02Z5vv3r
 JMtohRq5
 DgLR8zforoSjkW38IAZul1pYSZb0UIhZXQFTdA9Romhakgk60IIYOd8+Px15r+WDDlzE1zooH2K0QsdADIebdR2ynZnD1DMQl8vOWn6nqLOluWvVFYngYFZ+WkjTyad6DhB6M0vZlyQAheSazTZR5WcSnmsFK30Ro0KRs8xjyOIhSbRA4UGxqVOrZRfI44Edc5VHULhWzF0k9BcA6SqAsNtm9qUS7FTHBVB/pD+V+at2Q3ouPWZcuoZ+EVRpdlG7t/iIUZNuv8rq4wNLKgyB7W9xSV9EL+fVjyvXAofdNHpyGi9ZIoLg87OnjJ11gJzQIG5KzEf+yZ7Z2Md9I8ccc5NRgi9NdCsVFXNxmMECAUUU0O4EAvEMcPqv7wtFl0fYiirIG3gumQpwwTK3RqFMHlLwfng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, LUO does not prevent the same file from being managed twice
across different active sessions.

Use a global xarray luo_preserved_files to keep track of file
pointers being preserved by LUO. Update luo_preserve_file() to check and
insert the file pointer into this xarray when it is preserved, and
erase it in luo_file_unpreserve_files() when it is released.

This ensures that the same file (struct file) cannot be managed by
multiple sessions. If another session attempts to preserve an already
managed file, it will now fail with -EBUSY.

Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a38ea4975824..d1bb4213fd14 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -110,11 +110,15 @@
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/xarray.h>
 #include "luo_internal.h"
 
 static DECLARE_RWSEM(luo_file_handler_lock);
 static LIST_HEAD(luo_file_handler_list);
 
+/* Keep track of files being preserved by LUO */
+static DEFINE_XARRAY(luo_preserved_files);
+
 /* 2 4K pages, give space for 128 files per file_set */
 #define LUO_FILE_PGCNT		2ul
 #define LUO_FILE_MAX							\
@@ -249,6 +253,7 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  * Context: Can be called from an ioctl handler during normal system operation.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -EEXIST if the token is already used.
+ *         -EBUSY if the file descriptor is already preserved by another session.
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
@@ -277,6 +282,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	if (err)
 		goto  err_fput;
 
+	err = xa_insert(&luo_preserved_files, (unsigned long)file,
+			file, GFP_KERNEL);
+	if (err)
+		goto err_free_files_mem;
+
 	err = -ENOENT;
 	scoped_guard(rwsem_read, &luo_file_handler_lock) {
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
@@ -289,11 +299,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 
 	/* err is still -ENOENT if no handler was found */
 	if (err)
-		goto err_free_files_mem;
+		goto err_erase_xa;
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
-		goto err_free_files_mem;
+		goto err_erase_xa;
 
 	luo_file = kzalloc_obj(*luo_file);
 	if (!luo_file) {
@@ -323,6 +333,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
+err_erase_xa:
+	xa_erase(&luo_preserved_files, (unsigned long)file);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -366,6 +378,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
+		xa_erase(&luo_preserved_files, (unsigned long)luo_file->file);
 		list_del(&luo_file->list);
 		file_set->count--;
 
@@ -609,6 +622,10 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	luo_file->file = args.file;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
+
+	WARN_ON(xa_insert(&luo_preserved_files, (unsigned long)luo_file->file,
+			  luo_file->file, GFP_KERNEL));
+
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
 
@@ -704,8 +721,11 @@ int luo_file_finish(struct luo_file_set *file_set)
 
 		luo_file_finish_one(file_set, luo_file);
 
-		if (luo_file->file)
+		if (luo_file->file) {
+			xa_erase(&luo_preserved_files,
+				 (unsigned long)luo_file->file);
 			fput(luo_file->file);
+		}
 		list_del(&luo_file->list);
 		file_set->count--;
 		mutex_destroy(&luo_file->mutex);
-- 
2.43.0


