Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65138F531C4
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567866B00A2; Mon, 13 Apr 2026 14:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540696B00A3; Mon, 13 Apr 2026 14:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7D86B00A4; Mon, 13 Apr 2026 14:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15E4A6B00A2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5C5057CFA
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:42 +0000 (UTC)
X-FDA: 84654426444.09.0005EE7
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1591118000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eTGvyAYj;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+KnbIibxWtOmzdJbC+Su2tcke2GFWOiVDDgNx6VRj8=;
	b=faniaLRSnFi3XC/BMKtNLz8wD09RIArkvbL1pC/JCOJHI8CHAO+9T0qp1oAo5jR1MMR5e+
	walDCArt5ZLeh9vXpgA1ZTNebYvH3/jSXeScFpiwKOSAlwd7c8qgzypS9oqp+1BiuQSJqF
	dgyTzKBQMZ8+jAJGpl7b7F4sSzBnPrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106301; a=rsa-sha256;
	cv=none;
	b=XMJf0w6rczC3E+Ayb5ZjbdWu1MNEKf4oYodttSNQ7wxaIZOoDXO3l19LLLxueriyPzLs2H
	yYbqGYdyzHpcdsX5qjZEWBvHoALKtq7/gFxnxeW4Un9IxeFc2A2UIciRS8XSb17Ce/BD7t
	AoA8uL6UCTwz1zZGtRYI6KSSSp7DbFs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eTGvyAYj;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8dfb9139008so160987885a.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106300; x=1776711100; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H+KnbIibxWtOmzdJbC+Su2tcke2GFWOiVDDgNx6VRj8=;
        b=eTGvyAYjTYYiQCoqIn1ofAFxgeGZiL2P4XB5PORVNhDTBwY9sn8dWUJmuo/hYYQtBv
         zVoirC/d3d7dD1ErejBMvQFmgZQq1ucCM+2uu3IgTuQQrzFyznCT1Q0aojcRIFqZTxeN
         5dBrGAnEGhd4z4sQRapt3XrYSVq4h+A2FQFnV5iSk6vze74s8XVLfm7d/DpN+WsW3oGg
         kFLrXfEaqzuoPM07oD52aLYxln8k0NBL7Gp9fdhaIwpFRqD1uLsShuSwQzW9OySIs5ie
         cBYIWGooJGbn+ImjSKx2rdWNOM9x49n3e8vFhgRTyZRKhmUP6/Ll18JkY7dwffVrYPSl
         NHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106300; x=1776711100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H+KnbIibxWtOmzdJbC+Su2tcke2GFWOiVDDgNx6VRj8=;
        b=eXmlnFysZL5mcqReHOM/DrRdQh1XVKkcrdXaqWyOdoYYoY4RhbH0VPtqqup3qMkePH
         BM7Nl0+GAueabrilQN21maX7yeYSs0QgNdCrvs56aDbfMBP4BNKqGAV1qfPuPY+5LHJK
         41/2Y0CiHtRjDsMHL8Q6bTDYDM1/pH58sMgGtHvdLOczJo6DQNKMyurMX7uG+LpwmcQF
         dcwbkQA9jI81qHkmtRQRTddIdpeVfaaO1mp8ctEk5/KK4n0u0Lx9p3bX4MPRekOMHS03
         jk9NzBmx0DqqxauIxouBAkmSI3Wbo4H2Nl9l6Odpkpy6jetkcYXbbyZfiIQix2F3RCJe
         qvfg==
X-Forwarded-Encrypted: i=1; AFNElJ9ERH0uje+KXdK9bbDGek65R0wMUersf57X2ZQrgCNa3KYv/gDmJJv4t1WvRFO4dbCb/2XXI3CljQ==@kvack.org
X-Gm-Message-State: AOJu0YzOKBnnFFXbiQuRWkcThgEjBn20R/sDZxSoZkw3xluaCG9v4OgT
	/BERpKh6Zuty36DNBv0pertK+RTCquw5El2Cu8i8UITx8hAz9Z/e1e9vWeoyGj4o20c=
X-Gm-Gg: AeBDiev/MogsV937maHiLJwmM6hYWnnFVJ3pIlIImwhx5uX4DEakVj8ns0oGfKFW1gB
	+HgvAMuog7V2UueT4k6OFjy05vPYRUAMHTcUF7cJFURrG3xjOEdNe7uB+W7GUxqxQTBJCVUtpXf
	3sASldXCqcb6F1UmM7/GIkDevSUAewAzs8lY9edt2c4/qkOjzIWQAcv5qWOZSNz8vwdgnJg4BP3
	ojfyA87cYb5ay5YTUBceHdIb2nNMKT5RKQmLmTwZyvlqIX+kZ+h2A45lStGE1EgZJqhKfurdyXa
	RLL5+FPr4Lj8lhpfWQwiPxk0yCSCy48bxoOyqVbwKOwqLMBuUUCi40TQ2QkEwjNTHJnbFXuqFGO
	Qj+e2YraOo6XWU/tn82yvx5yIm+jdayq1qg4FgbGVtPUemTSeXc/d12zlvPXE24yaIqYs2UhcE7
	ELS71zja8gqwdOph0BDEWIETpCIDPZfcWmeqL3I4rmfRDTLKUH61iHBnuKpvRxN/TgCgFul7ob/
	I0W
X-Received: by 2002:a05:620a:450b:b0:8da:d152:b7ba with SMTP id af79cd13be357-8ddcf7b20b9mr1954895385a.30.1776106300047;
        Mon, 13 Apr 2026 11:51:40 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:39 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 08/11] liveupdate: Remove liveupdate_test_unregister()
Date: Mon, 13 Apr 2026 18:51:24 +0000
Message-ID: <20260413185127.128180-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1591118000D
X-Stat-Signature: qgkikdur7mexee4s9msuex4dkdtxxe9y
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776106300-904981
X-HE-Meta: U2FsdGVkX19tCGkOpfX0jAu/Jr8Y5RNgEy4C3fdo7b8b9lO4z3r1/wrPolM1bpkE7b9tapWHl3NCdvjPmwnP3JchIpgXugcVRdkBFcZLkyS+/qluSKdTGL/Xs+GoxHYkSidH/DMAUAHuSdQW1WMTb/ZQvpPdYQ7uCIpcKnZpxN5OMVMONey8CxhKZPlM7ybvXBj3pXH4cT4T5Sm6AnLtZI5dq+xS4KsGeYGAfBI64FRFd7CIj2RX95aaG/p08+pgpAzrX8Te2zYTWnJ3DEziuEHHuRXdELtfF85Ewzh4az+VhN2lDDpmOoiV26To0k/ZfwGXbLiRDgyNictF7YwuwW1dVRKCpJKrErvmXbrVWlJKvIoToMpMd9+J4PZE4V2+gi7UZqk1HCO0bXEvHwOXvpkAiXSsjvzyt5XrbDC+1+Qqka+uFT/KJ0BJS/5lxXxVPQWkqrAjRcnZTZOOjNn/NkJMxLCvwNaq/VX57MfXI+AimNlRCowJVgLJbYCUmHYTkFo0uckxmcEelmZINC8+8DRyGRjbsVH6O5GEXguFJ7rYPIpxilrHdDgmlTjudOrJvp6qyTXHaqcQn9MW6WHAtXoam2lBdZE39H7sehEHofYu6FW2X12e/z4I8wIX8kCeemi77QwHuHbSnBVAgX9vSeQld9l7kniKAy7LDj84lA0azEQxSbcN0a0faw8iyv9/Jxixeyygl6ULq8b3MX6x+gv6nY1S1En6Hxvh2ZbU2BQpQsfwIlx7DQQZ0J4bTvNpVNAI4NIMGwb4I+V6/0jGbqX/Ebnxvo7VauYfjgmzZKHm9ItUmanAwYSZ6aXIIzjzowwgpu7LW6cGILhar4G3LUAH0XZqrOckVM6+qkF3choBGjbnmIsN09pUJ2pO+ZTqw+w2R3E+tvTibVbwCJu+szHQregtGHUV2ccQVd0b+igpRYC/YGHDJ1Aj/skMGYlS75NQGP2B8T7YnOiY/wh
 uo/hqy9Y
 7Fs2x2u0dvuX8Z7xeu5Q3Zz3ZMRUfJuxoVtBk8nnrsmjJqqqB4zLqiwtEewYwkhagzEtzCN1ZL0MEb6ts9dQhEIdZlWQGf4zVd+wE91oeiI640q7BZ9MqtpivtnZ8fl3xcxgFEjkmekWt5WZwA6kRtfn6jEQsHkIV3mTw/1fQRT3VdWmlOTxh0wRJ5AfRizAVgPizTmnrcrR40tAYFmsZ0jU8mQBsnHUU2mSd2RVfxQJvGkCGaxYeeWsQYJcA9yj764dOr5//XVC2zJ362vLo0YTL7faUtFaqV2OF11hVEBQNDgfgsnFi0OY21DjpH52n8gM1VPu9PEUZsdf4acY+v1TUTJ8yLkFtIGpc/c7Rml0q0a7nsE5GQSjPHSxUJRPXZZhshDNdB2yRJ/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that file handler unregistration automatically unregisters all
associated file handlers (FLBs), the liveupdate_test_unregister()
function is no longer needed. Remove it along with its usages
and declarations.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_file.c     |  2 --
 kernel/liveupdate/luo_internal.h |  2 --
 lib/tests/liveupdate.c           | 18 ------------------
 3 files changed, 22 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index b37bd79974ce..f3b7bb698d3b 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -929,8 +929,6 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	liveupdate_test_unregister(fh);
-
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 22f6901f89ed..875844d7a41d 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -110,10 +110,8 @@ void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
 void liveupdate_test_register(struct liveupdate_file_handler *fh);
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
 #else
 static inline void liveupdate_test_register(struct liveupdate_file_handler *fh) { }
-static inline void liveupdate_test_unregister(struct liveupdate_file_handler *fh) { }
 #endif
 
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
index 496d6ef91a30..e4b0ecbee32f 100644
--- a/lib/tests/liveupdate.c
+++ b/lib/tests/liveupdate.c
@@ -135,24 +135,6 @@ void liveupdate_test_register(struct liveupdate_file_handler *fh)
 		TEST_NFLBS, fh->compatible);
 }
 
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
-{
-	int err, i;
-
-	for (i = 0; i < TEST_NFLBS; i++) {
-		struct liveupdate_flb *flb = &test_flbs[i];
-
-		err = liveupdate_unregister_flb(fh, flb);
-		if (err) {
-			pr_err("Failed to unregister %s %pe\n",
-			       flb->compatible, ERR_PTR(err));
-		}
-	}
-
-	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
-		TEST_NFLBS, fh->compatible);
-}
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
 MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
-- 
2.43.0


