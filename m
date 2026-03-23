Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F936F483FC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8614E6B0088; Mon, 23 Mar 2026 16:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811C86B008A; Mon, 23 Mar 2026 16:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9EB6B008C; Mon, 23 Mar 2026 16:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C58C6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:31:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 111ABC3D89
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:31:51 +0000 (UTC)
X-FDA: 84578474022.26.09727E7
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 43C0F40008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:31:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Eo+f4iOr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774297909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mp+NroOy4/hHawAvVZuOZcBwNbvsjzSVce/sSOrDnHI=;
	b=or5eum6m2CZsOh1WpNHQBfiXYNyhgrZc52dbw/IfOz3OfSxy6MAJCGMxpbCCx8KxTFqrtm
	XsRmFJscLv6BrmfBE5bmxIgNY2XEMkfDTwCqPCGTPZq9rUyElSabWmuV64Pk+pMNhVpUVi
	IdK5X4TD+f9jX9Rqt4IHe5eFr21mKlE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774297909; a=rsa-sha256;
	cv=none;
	b=MPhCRETnQzpaF/abZrku6kZszqjLnvhONKLVO5gMWvqYHgcA167A+MEyNaHOGItoI6Hh/4
	1MKlVifv1MgQOb6BHVJ7/gQERwKpkUqpjdf2oaV5QwUlbFc9TdWJyzVBPkglE7Tf4NFpPb
	VHkC032wo/IWpe/Snbx34uNN0JZnANo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Eo+f4iOr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd8dbf4f2eso51568185a.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774297908; x=1774902708; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mp+NroOy4/hHawAvVZuOZcBwNbvsjzSVce/sSOrDnHI=;
        b=Eo+f4iOrrBK/vSH3SS9jQpHtWo17uPWI2czuwZliXMUAJQ+m1PGx3ypi+Rlb/49HRz
         F9k44quGRgoHVHeKZPr4A7qJFI0mJtC/lHYHtKgAFtpbUAtzEcoAnwiKF2E6jB/zqbes
         R3PxUCb9p6j4alAbinaYRAKvjPL+jJTvwbpz9FCjMvf/68cQww+3BrCJEqwSKOu5U5vw
         fwsgKAGdyegY1lEJiZfLONnaaIx03g59V28w0xvtcgHnOVTZ5paSHs97HKYFGxcS4Jlv
         rKXt2MMEN831paUA1CubiyX6i2Rga/fEhIQ+xaO7UpxRe4gTRfAhf5z8wnKqgatk7CSE
         9JTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774297908; x=1774902708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mp+NroOy4/hHawAvVZuOZcBwNbvsjzSVce/sSOrDnHI=;
        b=XUAXQPcwW1m/nHkgOsGfI2Oc5dH+yy9Rqxd1T1h8KwT5wYhoTgDKJz9Zwr314vmHIO
         /fWvU4gcuCO2uDlD+LaC8OPNGHyFrmZOeiiaQH/b7skn7jtEpOhBjW2PF5A3Dj3OTacg
         +cgxG2lFN+WeDIa4njdOCxCtY0RKVvifYQg9KSqfvS0LDfzB86Ep7JVwEvaIXzy/kPm8
         wpWnwX7uDDLGfXEKNtBOkBNusZPk9XCumdMlCfVWfy/pv6u6grs9kXDRv6CKCozF93Xz
         Uei7hobZjBkfn04Nnl9++tT96R4La1nMc4mTUOr1YQ1QDMMLrIrN/D3bSWS/XnuVg7VG
         GwLw==
X-Forwarded-Encrypted: i=1; AJvYcCWZ+j3twyIqrJxcSzjtBscVyL77hjyray56GjhMzg8yO015Td4QHkXHaVR3bwTKieHlQ3PBCAwweg==@kvack.org
X-Gm-Message-State: AOJu0YzMi4qMNxYtops22Tg03agmiSp6JETUbbiUXxo6FHUKOie8r8od
	xes84pvijtTMO76xn+tEZWfRCoywfZGm1R6xkXZs5powndrGRnjGGmqJc4nC8mPbO8I=
X-Gm-Gg: ATEYQzxyvxIyGbTeTXq24Up+j40IA7WoEWZPfvcMAJrdraGT7Q00Lv9msMEY0VU/c4H
	dTlNDo7c/uEHl5iivoOLKKntW3Wrp7L2kUMPaHLhvJT3UC6uEaUisF+0JvE90kBd9fkmRvPUbdx
	9pdclPAVKTuXs1i8kkbjsa92UOwhCrQGmPKWKzRvfVYTAHYb6cOAKsE5pAMrPcKW1kOsnUNOmom
	ghMOVewSKbWsvzu1opCFvVxyyOeyXSIFFhJnfgsy0OnMC4xwmtaniYlqZu8dUeh/sexyVZzA1Tz
	Qz0V+eq+2xi4jmr+gzBPJxHSgeYVtbBP+jH+ErncPVOoaFNWbl0SdeKLH6b9jzpRePUButlN9zy
	tIZf7Ub0fXfTD/ZLmqLs4t4woXOoSgPrAliUJoHr0RqGWU9PlntCJ1iErfNqfcf4JpOFzgH9ocB
	gLZVGG1XEii4pPW32GGR0rW1aaNN6K/ArkHOmeGCGvNRX9YgkDLLzsajm4oLq4ZSP0Ug==
X-Received: by 2002:a05:620a:2802:b0:8cd:80f1:f468 with SMTP id af79cd13be357-8cfc7f49c3dmr2025158685a.41.1774297908246;
        Mon, 23 Mar 2026 13:31:48 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc8fb9c10sm1014271785a.19.2026.03.23.13.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 13:31:47 -0700 (PDT)
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
Subject: [PATCH v2 1/2] liveupdate: prevent double management of files
Date: Mon, 23 Mar 2026 20:31:44 +0000
Message-ID: <20260323203145.148057-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323203145.148057-1-pasha.tatashin@soleen.com>
References: <20260323203145.148057-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43C0F40008
X-Stat-Signature: bsi8nc9oj97xh84zhhrdeco78oum68dk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774297909-453279
X-HE-Meta: U2FsdGVkX19Y09VzDbfAnaq0rnc7or38Y37UuColGVETDYyMapDEbnKYbyS6ZLP4mM+RAQ3Lt++RKBXddxMQot711zL3TnRRXd4dg5EgwuzKOOy498JEie+eblL21hztfCqPB8yaP2HhqoeDPk3orIji2VR+x4hoRr7dyKqeWSqmsdiWxbIAe5OO6EHfAHRNrKLVP0q65kNWiiDWNr9WMOQobAPVhsmrjrzyfEVNP746kRL+z806p0I9nCL4sTLbR6QzjeCqnoLLK3UUrpgWcUyp8hKsogF4KucVdyHUkSXL4h7G8MjH54y4GRGUxuuAtQQqxE1ZeeZVQZmr+XxNryjs0LIP7zVYAS0s7Q1+UR9gGN9ZSBBwcaK9Hl68205F4Nn+vFKDZs/8ENdskDoa8/UQ4tYk78id8H3YJzeJJJlo0EHJrLrY/xMvD0MX8ucUf9JrXF7y2oyaZf21JsUuzmx706y//HdAcpLcvbYDovc6G4YRPA95+nK+OBtFomwMwqJ/Em8l60u0qI6dPzP6zdvSG/WCvT1w0E/V3vNKjE6Q1sQglrVMu6G16b1fTNFpbu1BEgn2idReikcEiFp96eSt3MFKfzbomJ4gOk416aS4Fn87RIPdk0Y1nHWYSXwha02YotKu76rMpvdaQ8g+I8Bz8J0tyXc796whGN3IsW/iQgoBj8o6UpDkKx/20eWKl/osQ+5Aq+MhBV37PoUz/6uFqBE7B2wxzfknutU7EFQEdPuoecX0W3cSl+vrNih1n0N3yvx9eyX1IEWd/kgv0ng/Y9JdF70qE4KioeOb/lZm4fFZXDbIk58vP9kHaKhGhw+4gmcPY6Aj5Riy9CY89uBrrWgVKYBLQ6sKK9Rv9dByqnkSr/7nDkqPQIF/wvhHC93JDKhijDXokbUb/fAHZEuvkd9bQE0wQeYNpW8XUCPidP8y5Mfn7ls8Y3KTCNMT9GtoM+O6mkPS/l4ayOg
 Im6QHJFV
 dY+EAFi+yd/iueOI22rHLPkHko2MF38BfRFBeLaCjkr8IpjvhT95uv01iUx+pPPgVbmwxRKyKfolQOUhImjHZtgBystIDVRvFrF60jgF1atbRQPmGGByNyGWn2dy2GLlmLmZAh9OvmcEJlD65g2oSSzxfe9i9AWIu0yQ8Y3vMeHelW4Xp+bh/dwmP1UAHct8w1FTUKzmwFNjlpso5TRabh+sOwg/1Fcm3e7MAmko948Ou29mkd3LksN+3EWSD3Dz/6bUMyX6l9skUyuof1zReXKsPuSy8qUfJESI1eQwjl4Od2LWGsnc2jkKSKu23a5hzQ1G67t1lwELUGX+8b0uYV6DZY8AjAoIZQIeHoiWJEqavt8MJjlZZfm5SDkX4eZxQAvaBdxHGbaZPLNNu+oGYD5KOWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, LUO does not prevent the same file from being managed twice
across different active sessions.

Use a global xarray `luo_preserved_files_xa` to keep track of file
pointers being preserved by LUO. Update luo_preserve_file() to check and
insert the file pointer into this xarray when it is preserved, and
erase it in luo_file_unpreserve_files() when it is released.

This ensures that the same file (struct file) cannot be managed by
multiple sessions. If another session attempts to preserve an already
managed file, it will now fail with -EBUSY.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a38ea4975824..5f48c3c8c561 100644
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
+static DEFINE_XARRAY(luo_preserved_files_xa);
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
 
+	err = xa_insert(&luo_preserved_files_xa, (unsigned long)file,
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
+	xa_erase(&luo_preserved_files_xa, (unsigned long)file);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -366,6 +378,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
+		xa_erase(&luo_preserved_files_xa, (unsigned long)luo_file->file);
 		list_del(&luo_file->list);
 		file_set->count--;
 
-- 
2.43.0


