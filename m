Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07047CD6E4E
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFD56B008C; Thu, 28 May 2026 23:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D1C6B0092; Thu, 28 May 2026 23:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DBC6B0095; Thu, 28 May 2026 23:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDCF96B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 992CA410E3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:14 +0000 (UTC)
X-FDA: 84819006468.01.C82AFF1
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id DB13780004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RVo3MA6J;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
	b=7SJfTVyFunbxoCejVYdMmzvW/Q7yvxItdmPLcwTh0KaE5MLARhjf/X/F25d8FsikAxOcrV
	YSdb2dlOl6Duf9ZfUVKP2yaKK2R13Mx/hrKvfFnWKfcMlGRARHqPt9b+1zu3KcVO2GQGXQ
	pgLvFAIyohKRiDtmL5Pb7cznK5AUEA8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RVo3MA6J;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024872; a=rsa-sha256;
	cv=none;
	b=3JC8KmMRQ51kb9hA2lRpv62CsyI4sbfelTWvkgdR7UnRcr+ZXfE9ufFQfW+H5C4ryyIqSx
	3ojVkJzKelokJ5LZu5z6auVPX8hvdKxrFeenI6O7sCrO90UuWuryQ3X0I3gFbcQSpoBZ4t
	w1w4RembCcaQZj7vtGJsyRM7q18J8D8=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-516d15ed2bcso69454051cf.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024872; x=1780629672; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=RVo3MA6J92ypC6V8IlrziLe1VaQcJcYaAg7adjMDSrWDjC25wxhYlU3QuIzZMCBCbY
         a5akjEIuZDKAf2uf37+cyOThHp6FbuBNc3WNdNozOTN3BT/Q6x1MlR+gLYCoqbtPkn0e
         PPCzj6bzb+SPtYoXVABUSXRHL4Qpkvt+NpdnMIue3cF6yKpNo0Mv+eyAGSkqJ01S9EWl
         DCVJ5mMhQSDTzYqU8e9yPLIORpTbsLYDbY68w7IvTY8DWLriKw/hQLcTnSieb/01/0an
         Q6b7lgZd5HE4ZGxguikPCne689M0mvNiDhLx4dL/+RHoGqoXDiY8UAanUExKtqquOOgu
         pF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024872; x=1780629672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=MwKpgHq6ITcm099oMdIa3bpeFhz9VFfZLLm34+WWUk+olYPqBZcrREkshZWcvv5+ew
         ORIab+WXLJDIW7+AgzpcYHZhggVX8ij6k5WiT9iQEBUAcT/7DkaLtLeK0TDnK0Y7Pa0v
         tqm2kwIrmUf9pphKPwvPbNgActCoas1fMYv60nSCubNjPbz8Qlu7s4bccyEOeiWah3k7
         ZzrOZdQrqj9dF6jBS/aRusOQdFeRk20US4Y0i0zjl4NMU7KKdG0v9Xk8OHIHOsxgQ+eY
         lQ19oXFjdQYVmXkKccYKzDBnbxcd9W/0YcWKHnPP1pRM+Y1+wpPF/9yEq/biMP8mH2z+
         rBWA==
X-Forwarded-Encrypted: i=1; AFNElJ8xcTuqvdFSerM6v0tueQSPKEL7C4DwyF6YW8GdAOA+Bl+vBK+SJ5aPRgx110Anc4DTKMdVxG0Faw==@kvack.org
X-Gm-Message-State: AOJu0YyJxGeovTrOLdG8CtQgZYI+OXs0zJ79E8MvyIFrAjDP/RkQ6iPp
	xIgOAKbt0umUFsL0iZMn1XKh6hmPMM2CZu2wBv5pRgng3VlqH5w4zG7ZKV5Xfz1GdCQ=
X-Gm-Gg: Acq92OF0m92X+lHSf3tLzbP0UQ7bDGNGRFCANYZ9l3AJ29mBCf6VPQyTYuYGrUvXMat
	kxuUMaYG/NsIVj88IFUX2CHycRsLv4MlwL5wQ73qRCAG1qB0o5yx7G9JQCK7qEfOnnzJ7qj4+4X
	8o81ZIs5fZtQoetYQSxktcDDCFJYPH8udyw1QRAjXaZ1oFPvPc8csh05dVHxx2ecn6sJNZ28EiM
	oWMuQBxWM5AUotNLXL+3L0v/nB6DN91Xpq1e6nMdFg30cJKpLG5gfHKh6A3ooN4dEGwzwC6jgjl
	/j4xlBjCtlItRa9CvC5wxit2S5NLcj5Wwwyu5usIZ3RdoVLhrMseqhXlLG9GUefL+NYw9SV2ZcH
	Etj3aV5hachgvBOXc1Tb5N6eLbP+Pi7II1FQy/ZI9I1vXj5m1FM00lcM/4HJpC3PBrHNdbEaWd4
	d6dzR+aOvGckbuVxbfrafNVH6/aY4Xplvi8Pr5E3on4LqrD/mL2Z3gPPg7na/FzUet47lSW/1H
X-Received: by 2002:a05:622a:1b9f:b0:516:9b30:f025 with SMTP id d75a77b69052e-5172dbbc5e5mr13902181cf.15.1780024871947;
        Thu, 28 May 2026 20:21:11 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:11 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v3 03/11] liveupdate: Extract luo_file_deserialize_one helper
Date: Fri, 29 May 2026 03:20:58 +0000
Message-ID: <20260529032106.1505796-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sooybo6ohuopuquz1auemj6edob7nw19
X-Rspamd-Queue-Id: DB13780004
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780024872-384373
X-HE-Meta: U2FsdGVkX1+fDMyysuSzc6nV4cekYUYme2OcuA+n8qg7NeL6x9WtIxtomMq5aTSjTIgGkVMevYxJX+3WpHxSs/RW5Y99QKS+IGrk0FPZwxLw1CTp8zrzlrx328MzLnmFKcXb+6NhF8v8AypLn3lVBxKqlaKoJzJ3XNbK4xnp9C2cEELT8M5cmoxEZqgWQUPR5vKTNWXWPyp/D2d7k91JiIWFkHrsTu4AmBMUZgF0SntilzEVxRDft4Ql/afcugnPakhe4b6n1p9bPQEY6fLUjQPTNwNXva5bB1LQOy7DvvbtVESYJgeWc3aWdvBHwKNcBDjoE4FO4k3QPiFlNBOytEU30K/7PjLtMJxvGKqhdmnN5nH2s5Uy3G05PXXPrc8UvMgVEW0igPqlekWHtYt8B1qz0osFj8Ou2rEEY2E0fFdSjU+6THFCIlgbJNIYIAJJs40cvMK38Hvx63c1t9gKJugTmqczGgb6lk9ms9AuA+ZFooqGzWMWfzUYsiDYd84supz6fhbFlmcW/E4l0W6TTOVjhiFxB3JxivX6JmreZD703Elk/Rc/NefI5FjqQWY+la5T9LAwlXRnPpTTazL/4owTbB0sqo0EHxtfF+wdl85AfVS8b/dZiEKndoKFP7AzomA53rItkpbFMqrIV/yxGZm8QRjpgNq33lOoIwEBz2re3ullETr3PlV/2RyPHfHBAQWdMZXbcy/4wHpXxe7mDCaItyLf8pLFRD/RmOGuCRUkJK3OiClifjLwSHC/gzFns4OVoO5TBxsGwt4lIIgvkQFuDOo5YXCBe6Mu5KfWz1N5MS86bRmk+8m3Ou2GQTC0+34F2l+Csqpn0nmq9nR+frNbGCRR7mV4IjpOeLSg2HQGdLszwwuxzW1biEbfrvBT1Sa6mqFMzwluGB8Y7oEUWVOs0kCEfobTvBm2S+2VPAID4j5TIr486dwNzuygZOgZpJHFlhikKOXqbS6srTU
 NLl36i5u
 dKM1DmZJ1rfw4zo0werSsc8BygyJoAkkjKBNPmZZg/FS1aq9PQtElupgTw2pKHRe7ysw9WuzvDK8wxrpQwyJlBNE2lagtBc8xM95BHGyE4TgzuBfcv8l87/5IS8N71JXMEBe75of7R3MHG94USnn8G0tVdrY9ui5EDRmmO1x/I4AlXwpSZoha22qkJ5qwoh7PAm+pfRFRlB+nIjvRAusDli+9jh1WIH5HcOYeMgYeH5dSvqtZbqUIC3MZX5BT7k2H9YunyklzL8KvRBH4je4HNnebqe3llsxUwyW1EtWNMpuFBWpgnCd+xX2xwJeAI7U8ldTTIjIMvtM0haHY9bc24MPd813CUA5U46N036kfVoO4aUC6eu/NIKVbKKSexEi5lh2Xq3Rw3TXfRQHSSPKFkJq6rYzN/39K2fEctkQZG/95a4VEoJahwip7gxIVUqSEQz/1g+oZETRg0DFdXOqS2oCHwWgUQAFSlrog6BFtAs+/YRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the logic for deserializing single entries for files into
separate helper functions. In preparation to a linked-block
serialization for files.

This is a pure code movement, no other changes intended.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 77 ++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 208987502f73..9eec07a9e9fc 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -753,6 +753,46 @@ int luo_file_finish(struct luo_file_set *file_set)
 	return 0;
 }
 
+static int luo_file_deserialize_one(struct luo_file_set *file_set,
+				    struct luo_file_ser *ser)
+{
+	struct liveupdate_file_handler *fh;
+	bool handler_found = false;
+	struct luo_file *luo_file;
+
+	down_read(&luo_register_rwlock);
+	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+		if (!strcmp(fh->compatible, ser->compatible)) {
+			if (try_module_get(fh->ops->owner))
+				handler_found = true;
+			break;
+		}
+	}
+	up_read(&luo_register_rwlock);
+
+	if (!handler_found) {
+		pr_warn("No registered handler for compatible '%.*s'\n",
+			(int)sizeof(ser->compatible),
+			ser->compatible);
+		return -ENOENT;
+	}
+
+	luo_file = kzalloc_obj(*luo_file);
+	if (!luo_file) {
+		module_put(fh->ops->owner);
+		return -ENOMEM;
+	}
+
+	luo_file->fh = fh;
+	luo_file->file = NULL;
+	luo_file->serialized_data = ser->data;
+	luo_file->token = ser->token;
+	mutex_init(&luo_file->mutex);
+	list_add_tail(&luo_file->list, &file_set->files_list);
+
+	return 0;
+}
+
 /**
  * luo_file_deserialize - Reconstructs the list of preserved files in the new kernel.
  * @file_set:     The incoming file_set to fill with deserialized data.
@@ -782,6 +822,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser)
 {
 	struct luo_file_ser *file_ser;
+	int err;
 	u64 i;
 
 	if (!file_set_ser->files) {
@@ -809,39 +850,9 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	 */
 	file_ser = file_set->files;
 	for (i = 0; i < file_set->count; i++) {
-		struct liveupdate_file_handler *fh;
-		bool handler_found = false;
-		struct luo_file *luo_file;
-
-		down_read(&luo_register_rwlock);
-		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				if (try_module_get(fh->ops->owner))
-					handler_found = true;
-				break;
-			}
-		}
-		up_read(&luo_register_rwlock);
-
-		if (!handler_found) {
-			pr_warn("No registered handler for compatible '%.*s'\n",
-				(int)sizeof(file_ser[i].compatible),
-				file_ser[i].compatible);
-			return -ENOENT;
-		}
-
-		luo_file = kzalloc_obj(*luo_file);
-		if (!luo_file) {
-			module_put(fh->ops->owner);
-			return -ENOMEM;
-		}
-
-		luo_file->fh = fh;
-		luo_file->file = NULL;
-		luo_file->serialized_data = file_ser[i].data;
-		luo_file->token = file_ser[i].token;
-		mutex_init(&luo_file->mutex);
-		list_add_tail(&luo_file->list, &file_set->files_list);
+		err = luo_file_deserialize_one(file_set, &file_ser[i]);
+		if (err)
+			return err;
 	}
 
 	return 0;
-- 
2.53.0


