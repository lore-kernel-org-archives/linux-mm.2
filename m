Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C56F531C4
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EAF96B00A4; Mon, 13 Apr 2026 14:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF996B00A5; Mon, 13 Apr 2026 14:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E00B6B00A6; Mon, 13 Apr 2026 14:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 301A16B00A4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 033FA1A02DD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:44 +0000 (UTC)
X-FDA: 84654426570.13.632AB8F
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3A19940005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="jj74/7+A";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106303; a=rsa-sha256;
	cv=none;
	b=fRWQ+gh7WKy68Bd19SQ/FWRGok/E1bL2lTsW1+nelDe/n98Odqhp7Z2vnkfFZ040LVC216
	E4HKf/kS/1qddr3DexWk9ksJex1yxNlTLZrTpgh4J8qDh7U12P1wESGkjyevjft3nN8MZv
	Yznd0RYF7Wdlu6mVYJeZaWR4NfuhO+Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="jj74/7+A";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJeEvj0LNhhqC5xfWKhLkcBWLJMMBqsm/C4oZoQsE5I=;
	b=VzSEvWkFWrLjoLGv+45UkM1kZ9UMS0TxtThchYV7bVUwdJBKogunOIoqHSS9cOttzdBApI
	XHrbybn6QACbC4n0oI0lOcic2B641B9ho0Y7uH4WbXxexI7uLMz8P3xkddCnnnMWMOveRF
	I1cz6SJ6CRNHGN2mSwvHgTMorqk5cc8=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8d6d5e45c43so570410785a.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106302; x=1776711102; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KJeEvj0LNhhqC5xfWKhLkcBWLJMMBqsm/C4oZoQsE5I=;
        b=jj74/7+AVd5R6TA+7/qYx4XqXM6XwL+4IYK367T3YBMntIaDdxmRrRCs9urGthWA5h
         sXYBjMg1OQFfrSe4etSNyePGhycSXFOk36nPIxf+vPFvJVBesSRro1oO1MUR8g3nu8Hs
         MYECuMnMsVLpJ8M3o2QXPR2vOoGl+u3mMm8Hxrws/ijTmLD00p/z2Tr+QPH+2o55FBvF
         lURlupkvOwH1C/1Iyollpmr2nbtbrfPX5aT9MxGtGZhZz+vQP2RqeLabTl4829N7lFXa
         VRTj9la0Cai2ll/aNi4h1HvREOKkarzUB9FjG3VonrZcMXlI6BLooDtg6pu1JGsh6MiR
         J+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106302; x=1776711102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KJeEvj0LNhhqC5xfWKhLkcBWLJMMBqsm/C4oZoQsE5I=;
        b=Rbbu8Zgls8NvWcTwk91Gszf6AwJFh7Gorn2bhB6UxxRHtaX9yHIaarFS4PJqdecRvk
         N7WkinV2B427VEUGUupCBuWvocszNBuvUXfx0LA0jqRaGYroSFrI5/qPcx8bviOnJlnU
         AhRcuX3IuLj0H25rSdf385T/7coJTStu/OzvOOyHQbg2JxcRoDmNRRl4alAGTWsUWMLP
         6+dspl78ZQLwQNGw86EhEpIQrA9Fwmjh0p49M4edhDnCfZZqTIzQbDqPv4VLZHPJ1CWP
         hflM/gXO+4/8Gpe9DJEQoHOb/qwdQ+I2hVis4cfOxeCIOftHC3rL/BrJOMHr9BBu5M0L
         rY5A==
X-Forwarded-Encrypted: i=1; AFNElJ8MWan20zcUcgcfTm3SMDHH30Ug8UVner4p9V1ayT4ILp4gJUaUFbVlEQoxLqBGBghqkT8MM3sxmg==@kvack.org
X-Gm-Message-State: AOJu0YzVA4FLrC7PTGMH61aCWNOVk7ijkcE8YP+sil8MnD9DTydAmp+A
	P3tKnNkrhTmzVIifbe0J9134JcOB9jcG/CO/rCO6IXq5KFkORMEhwHPWOMKlzqMKYqs=
X-Gm-Gg: AeBDieuHvty1OM/WsRVQTvPBOQqtF+iz06e9vkmfiXnmccaAazpkp3v+Ads3yW81sLM
	o/XiffbrScwtS9+jrX0LATaGkDBs8SfS2F8Yy0NFzpMKEFQGNN09tISNevQVMFKqIIk1hmJJt7W
	yW13OoPBywfK64tJDy9xOcRMTWH0JcRQMEncayB7gW7ae2/956UxWttKiIHNSpyXwMpgPkJYM/p
	iBMi/3uUxrh3cCnTS/3ZqGU0Zv/pv6CasN7RtZDiI3OSlWBgZxn8lhJ4QJx3KkeEG3AoArZg3Ok
	mTq9zJ2kNMo0vKvsXnKNO+gOB9i9h24K4C0NSQHVOVHWUlH60VpFSu/ZVMeKm/jhvXA4LUIGZnP
	7nPr7HV7qwQKbg8Jk0zTt+72Y1RgYzCOCCPEskFtGvaxUHKF3R/eSR4QDgzZFgK1zzKof+JHvkN
	fdR2ZQl3Xw9QDoSRRnhXiY3kakZD06OaE8jYuv8V+2FvO+cod+74l8vdlqxq6f02gX7A==
X-Received: by 2002:a05:620a:2901:b0:8d6:39c0:e6b6 with SMTP id af79cd13be357-8ddd078bea4mr1995823285a.64.1776106302276;
        Mon, 13 Apr 2026 11:51:42 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:41 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 10/11] liveupdate: Defer file handler module refcounting to active sessions
Date: Mon, 13 Apr 2026 18:51:26 +0000
Message-ID: <20260413185127.128180-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9gqomzj3kbkbzzpyz1rjb8nmjme8r8pr
X-Rspamd-Queue-Id: 3A19940005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776106303-165053
X-HE-Meta: U2FsdGVkX1879tdg0/jxG/0P3WrNHW4nGjfrhIQ0Ef5DInDpOogyy2twIa/vW9HVJpQdQDLfYdDmK5FAXTbnmSvRlhYCquzzz+eEPglad3QGmbSkomclLxy2qwGOaDa0KZ24a5NYYcPXSHi1A5Ic8O5U2A+4CLOCLXZ7RNhl+c7GkW/9lwDO9PCUzw4dUgDZ1IYzogoNHiVn92+J7zbAljY1X3axrq7NOM5cBWHWCKShHalNpoQkl4WHEXOxQtwuqyXKprG55dwk6xJ4UNthVQlt5NOQ2kKyA//gxQL9shLVX4npSfIQ20KD0k9NzJICatEZcqKfJrGY0DJNfyr4yng6HSjIJ7CGJdzuA6cOehSIdo7YeYLboQ3a7orOA47S1J/KjImqG32Pej5U+z94k/wTWtT/O5xBE7MpoMNfWJDWqjVksMMhkDB9jB0D9g9qBr8Dzj+TbJH1DuiplU94AX0DA/d+ojvOlklLP4MzzPmqxUPJ2iWRZwCHOuKi4Z/qYE9KT6YmqR3w46LIxXcc/MZaugufNKDN93F4ODQm6SJdTwvyTOfFznHYm4Zx7vgXA5qrbB0u9x2GMTEjr9dk2cp9Pfj6CKXGpKuU8kORLAPWKDe0J5bbbWywWKlMU5e8/yaTJnSIgRZ5rQ7QSOxsIPs3A8KD4rj1b6qu9Fq3++nRCx3x/EiNZXUeZ+hgFYclNMmDJTup0fGc0qUuRd+mpH545iDYFQ+3nRkA5s4mZ8M/xb15ort/wPg9u9EQ6X5KcUKQBSiZtCXn9r5QHhrKSLhdL4e7p4AhHcKsmHRbNE6Ew5WZ53y8wdp397f/a5fEAN1MAYzuveWTkI25ePKGFROsctI9u9PNfgg7Utnm99fWfCgTZJfAFJBA+Ik9e3bv+fszo76R30D2iRMgK3iN5i4ANait1EmGpuLuSSp9rNX778Fh20r0bFI6fe04bgUY6FxRHtCP/68BTA6dAcM
 foiXN5Wa
 BqGEOuR56/R+k2O8to78vZSkzsobzuca1blChp3ydPGUh3xlv/VNr/jM3+QTYUcZMwBElvpoc0G5oIzys0Yti56FlIWaroeJO+Sa7mVNrl2Ou+OzOkzREkwO1JB3uCPtaw3K0nb/b1CjJiZ9Lzjqkx92RGl8MRU2WeJSUqnx/vzxQ37/cvexmBbdOrYWGsojiOkF/leFpV9IioTjpNMShzQ0N07u3wpScy+zrhENw7XGa6A9Shru6+4uAJT2KyxRi/MvdHVN3yYUckaRjuD851Jggz3G+POshfgfjt3vrVivPSpUy367J14kc+soj24MBm+lj6jFg91Rj/YlHyqidlmm1a9pvTVJCYrdY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop pinning modules indefinitely upon file handler registration.
Instead, dynamically increment the module reference count only when a
live update session actively uses the file handler (e.g., during
preservation or deserialization), and release it when the session ends.

This allows modules providing live update handlers to be gracefully
unloaded when no live update is in progress.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index f8e098858c62..dedbb8d02e6a 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -292,7 +292,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
-			err = 0;
+			if (try_module_get(fh->ops->owner))
+				err = 0;
 			break;
 		}
 	}
@@ -306,7 +307,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
 			file, GFP_KERNEL);
 	if (err)
-		goto err_free_files_mem;
+		goto err_module_put;
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
@@ -342,6 +343,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	luo_flb_file_unpreserve(fh);
 err_erase_xa:
 	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
+err_module_put:
+	module_put(fh->ops->owner);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -384,6 +387,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
+		module_put(luo_file->fh->ops->owner);
 
 		xa_erase(&luo_preserved_files,
 			 luo_get_id(luo_file->fh, luo_file->file));
@@ -675,6 +679,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 
 	luo_file->fh->ops->finish(&args);
 	luo_flb_file_finish(luo_file->fh);
+	module_put(luo_file->fh->ops->owner);
 }
 
 /**
@@ -812,7 +817,8 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		down_read(&luo_register_rwlock);
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				handler_found = true;
+				if (try_module_get(fh->ops->owner))
+					handler_found = true;
 				break;
 			}
 		}
@@ -826,8 +832,10 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		}
 
 		luo_file = kzalloc_obj(*luo_file);
-		if (!luo_file)
+		if (!luo_file) {
+			module_put(fh->ops->owner);
 			return -ENOMEM;
+		}
 
 		/* safe to use fh because its module is pinned */
 		luo_file->fh = fh;
@@ -889,12 +897,6 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 		}
 	}
 
-	/* Pin the module implementing the handler */
-	if (!try_module_get(fh->ops->owner)) {
-		err = -EAGAIN;
-		goto err_unlock;
-	}
-
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
@@ -924,6 +926,4 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
-
-	module_put(fh->ops->owner);
 }
-- 
2.43.0


