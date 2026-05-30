Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3303CD6E56
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FCE6B00B6; Sat, 30 May 2026 18:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7526B00B4; Sat, 30 May 2026 18:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363CF6B00B5; Sat, 30 May 2026 18:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2409B6B00B3
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:19:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E158B8DB53
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:55 +0000 (UTC)
X-FDA: 84825504750.06.E67EB11
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0F5A58000B
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cqoynPLB;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
	b=71oewuAJY6RYQf+al0x64GX6CxT81PeNndiFyPaBv0G8Kc43eCQ/h9kJd8MP0ifnuAoPuz
	GQwQ3A/9F/q93HDRVddWEGBjWqrEQ4awDM2VaxoStP3wrqO1wPsJ+xFVGEHviOeXp8aPuO
	INvXkhTa0Hqr9S/v/R9QBqZwf+vs4b0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cqoynPLB;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179594; a=rsa-sha256;
	cv=none;
	b=LpXLSDVdor61xbowe+aBM1FYUN82orP1wn5dCLlFiuykYR6MEf7t0qhSLFZlXouphVkYxU
	URC+L0ozam4pDrqU8JZcteVPLqzFEvfVdrDZteDYpcIcoDOecvON6u9SWr30DHXbJzWNgD
	dtNy62LQtd012N7cZAvmhJ4t1GuVCtI=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9154ca1aa1dso53041785a.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179593; x=1780784393; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=cqoynPLBExtP271NLNmOcLTmIqX6/iR0l7Hp9+/2omehjKFFVJDpwJhNwweZ/YoASV
         8JGONqZ6h3okPGvcUqC+QW3X6W1dh5QEHQ4M0qyd3zLr08GCtcb9KBC9xAWRWbI9+1Vc
         zK6kPnaGSECNt4ZWZvF9+ypqZe1WlWQ50leZ1hptTAGt2EMqm6TuxHMea7aXsft6nvE4
         ziu8FiwSgT+AudZwnV8+BRgufqIn41QOsLyf3CqSnU3KYRrG6Ht53nx6LMQWlCfmSUnA
         riufUTNj3yD3wIPuBG7Yf18Gs9DLNBMo+pTrTwUxM1E72bBgf9UiTkcdLmhueCxyMZYj
         uNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179593; x=1780784393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=YWI8qvBveF008dSWKcXl/pZ4hqKCk8gyADkfBGW+XULcYT02wiPGmbRdDTF3vrZKhk
         L5E+hSfBZJzOeQjIyNtAj1W3UhhfZw1FmL8tjvZ6x615nqvTskkpDIC9Yqqr4nPoPfg9
         QLcMj7i8xKnsaxf7p1238tdwcMsEHPX0G+kGIk4tJpl6hUTnU8N5k/le77pFnmwJDP2E
         2jAEr1YnnyDOnMQYkO0DmGol0eev7Muza4PS9hq2zfQta0d1WIjtQHc9+YWZdmPNPiqx
         b+s0y4+xGaqyTqUDetY1v0f5yO5gySQZTiyTvi2ELNfDW6UJ/9ebmebjXRQ4EHNreK9q
         7jwA==
X-Forwarded-Encrypted: i=1; AFNElJ8ooE5JPCu/9ThVtEKtYklIaYBCgREN+AqoY45KxVoK7o0eHEDaFo2zd/AC1ZSNPuEqWFRwEWwz6Q==@kvack.org
X-Gm-Message-State: AOJu0YxN3nlYFhKPVxEU1NqZV1dOFmkvBrpZGBTX+WOss17m95q3jtGM
	pLUicm29V+im2N48cE8PyCJ3dmJ99hqZ6qf6tppfuu54SIgjbTlOfcVY/tyKapn2BFA=
X-Gm-Gg: Acq92OHR+S34x2AkP43/Y/s3oa5iVabGIhM8chyIUO4T/TdW8Hl3zGVj8jK7RQlA6v8
	1GIvwV33mdbX7ToKOqfLjB8HQoe6InSCUO03vGDizNOrwDBhdcr7DoIuA9bCnhETIy9/l4Yt3En
	h+JV22brNKTNn1tj9FbduA+r8rvQG/lUlNlAbWwZW8pzurnIEK8yLBXT3WbIT9ARZKDLv60HNWw
	q4DfZhnYRnlvZ+uPOf2QPIrUAUFj4+hXAcOkxNt/+w4EIKfp/qJ2L5Uc92ykv0r0RdkZ6mHh/iX
	6fFHylIhDpcrs9GZJbrSbAfMXYj3Ewp8AtHiTMJRbzpNxPXZJa76/WDlyFXQKShV83fxUf7Qyyf
	kpdaCybGUrUrwJ7OI4469zJbVi7FCysYEihR1TM8c+QyTLW0+Y33BqkKwYxCb5i2lbFv9QEWJAx
	2xBWB2puv/r/jG/J4Zyn0v8cJ6uhRXLFAMkixz+NQNcvp6sNUZeRzCM4I7k1Ve6SC27+SnYMk3
X-Received: by 2002:a05:620a:2697:b0:914:b4c3:997b with SMTP id af79cd13be357-9153decd84bmr587250885a.1.1780179593182;
        Sat, 30 May 2026 15:19:53 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:19:52 -0700 (PDT)
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
Subject: [PATCH v4 05/13] liveupdate: Extract luo_file_deserialize_one helper
Date: Sat, 30 May 2026 22:19:30 +0000
Message-ID: <20260530221938.115978-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: nc311484n4nks8fpzumkkjsm881jih7r
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F5A58000B
X-HE-Tag: 1780179593-435006
X-HE-Meta: U2FsdGVkX19RqCCbY1nuHTcBPk79INYRiB4ESb2+pjTI/0w8pRsXanpS3s2AUv46ZBqU3RvE9Wsu813uH/MEGT/4352ktAZxT66lQE9LrYtXCsyYqh6Fw7BxMPzJiJGaZ8azbbHUbKimrKd5OUxXzSimVhB90WWgmtX/JtHZwwPiNf5KGlwcr6t4Ar2Mm7nTc0cIhhoF2W2p1XbcLFxy2v1DqRPFBl0PEBb9IqlcZHU+o1tzkFwHNx0jjulOq2+q/Nu9mxh64m5BRBAVbS6p8YhHo7Ml4C4l/Prhxu3YZEeVfW93jPhJil03emx3wakt87vp6RSh9sqDcgqgF7PrsNBPIw1EKeNas7c2Z/X7z/CGbPCBdeBpAZewcfTTXRwkwRjitKXfp1bRmgdgL0UdBRTm8CKBbE+GtUswz8VBfFERKGcguFE+FUYgHBPhVRCttL3+1aTN/agPi6hixMHFLTuuyyy6GKZP+optC+LwcuPyD3teZ0wWVL7qaW6XFK3DRU9LR34PMQYCHwuS41t3bel3nHj9wTJj7omiSQ3lYiuR1dAOjuOVycEPbPRl4Pl4EDz77qBH3LsgcnebwLX3YeGk3rF9dXb0peAkslf0FFeqU/zSw6hmIPXhdSUPhLa/SXVJu1QhqECvB3dXCn+QKEBYwj1zib4kkoBwEG6/h+Uob0J+/KBvVfEaxDu2q/GgxOVE92CM7HhtXb4/wDPANhDbcCp/GgATQS3FBz8nw310b53Hquj3KIk5Lddzes7Z4fAK9AcJyyTGPFN9qpxv490bB+sb9NTcHoTfvx3+zGqsRmr/5F2oxaRoc/hO79d6vdDZDzD2G92BoTXpnQfk6bc+umK74wd5nibrIwPuf/V+U8TAIwZVscwoyLt1UfXpltF2ngKhGy7AeMeWzaw02hm0RDPYrW7XDZhhWR9zU2X2B+DIuu9JTeDgc9h75ZkNHUSH+NQgQCuTsDAc2cx
 1BzvW7xu
 70GmYgCRxyoovuFsFYtsQn3xGvEHGf+XZqNYl2HDBcNJz5ZF6fx0T8TucabduUf9cehmRlF0KZ+L7mY95ZXhH7qQcoEuJgRNNIyfjQEpp/ZK04qdCw4GDi3eR6ET1pF8Z9l55RWqASqFjs40wUrMjao9o4ggNIiaqfL69ZGz9pnswz/EGqD8uS9fVYac1+RpFH8hz2EOxi4nluPtwLIJqFdS8yGLPRafmXW+MijZif/MVuLNxKAz5beAWCbNZHY6iHfcTbdoye2DLY5lL+/mW6PVOkQvP2LgGIX4ShSgTutHpbAXAkL/ZWqBCHUjYV9TU0YL1HjkxgoS/l7HTLG/2I50Iz2zSb08WsaWAnF9HuTLbB/sHUnYn1HxsoXEd7eOaUjtFiPcRmNMbl1q/C9kM1Ck3DH6yANhQ/lhXjxqawn/MSUE6EdmePGA4lD1zManysfmxMYT8ybtPtptUlAD62Bu0peIzncEYE2puo4M23hc0ioQZm4of2LQPeUxGPenADln5
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


