Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DF16CD4F21
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 16:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B866B0005; Sat, 16 May 2026 12:41:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C476B008A; Sat, 16 May 2026 12:41:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362406B008C; Sat, 16 May 2026 12:41:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28BD96B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 12:41:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC1CF4038D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 16:41:37 +0000 (UTC)
X-FDA: 84773849034.02.9126ED4
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA71D140009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 16:41:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M2BJsXVD;
	spf=pass (imf26.hostedemail.com: domain of cheng20011202@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=cheng20011202@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778949695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9+xFprD7w2qlB10dfbzMYi0/RXvlF3FFBRqATJgs2QY=;
	b=PF/viFd7SbfuUzWtfF1rbENVCIamGCwfnvWKR+SK3SJZtIIi3dlVS4KOmhDLSNgB8Ig4f5
	rjESxWE03gybjExadnbLHiAdFtFLjHUtLNEUNtT9LhEOMgY0tAiXjuKXIKzSQj6u0CGYGP
	1dKGMyM9aNhiHxh25eu6P+Um3XzMuLk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M2BJsXVD;
	spf=pass (imf26.hostedemail.com: domain of cheng20011202@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=cheng20011202@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778949695; a=rsa-sha256;
	cv=none;
	b=5Ye5orVT3OKThZLfLX7UYoM7yT98dA09DAwj55bwMqXeFtDJDA5bKqkEDcUIWiNrkdDwkb
	0/PzQihr+4SOMrIHuBjnmKbJVEBCwlxGdu4i5CrWqym77zdIXtNMO1rO7JOkJdOmlVpaxe
	Wol5VWeDeaDanryAmTTkNqVVbKESS38=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-83ef1d17904so903208b3a.1
        for <linux-mm@kvack.org>; Sat, 16 May 2026 09:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778949694; x=1779554494; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9+xFprD7w2qlB10dfbzMYi0/RXvlF3FFBRqATJgs2QY=;
        b=M2BJsXVDHmWE+0IGTysVX1aMlVFgm87cnPspO7mQ7atPdZmuBOEKmXT4CPC0Unnain
         48vgTJhHvWuF/GWQirIDhl7fJgc4hz3GPLGDwEZRkY9WMXfb/DLgvm0RpcDaP95/XTxf
         UxxkGN8pqXMp/aJonN5+YuMr97XPerwe97684VNqR7AselEBFcyrcEN4GyPiBI9L3r9S
         rSouK9iuTrFF8jrrMU2X74aDEcllWO8RnJFVjtJz3mC6tFZXz9uapGDaAHw52hRsf44V
         TEpsUeZbHnTPsNOO8gcW80XOX12lYSr5OfGmc3mn3yXK31YgdxiiZOue1cRBuyEVHO/P
         w3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778949694; x=1779554494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+xFprD7w2qlB10dfbzMYi0/RXvlF3FFBRqATJgs2QY=;
        b=DvCAydZAUwQjdaTgItkGMQb3fVN6gXudIARbLqTIrsj6aToqZQHinOe1lYqV8j8NmN
         PGCYyVTYoXrH8jgyMDNHCBlZII4lM4vCD6pie+0U7RDOlW7OGvvOSTo7onJOfOLwkvoK
         +JVnZb8X3Wwa+7vWsvErIdnS1zNdt3UP1VfhSZFMD2KqFgNQ6xXDEHid4a4T92FYH40M
         LAFf3Ue2ryoP++3Qs61mYQn0KCBe3W+hi+F/J5v1r2DDelhYz/SspRGY7Z+1hMk6OG6i
         fP28qMOUoZ2cEmK0oEkvUr874IjpDh7ijNK/EO9rCIH25nd2KV6OvH6ZAJzIzSSb9ifP
         mxGQ==
X-Forwarded-Encrypted: i=1; AFNElJ/d9CW2ZKcVEDML1123ufPZBEOtnWm/wwOs6lS5rTDU7/XwqZp446trbImBhgx9jo6FbQEV5DRpWQ==@kvack.org
X-Gm-Message-State: AOJu0Yxv5pKad6OUL5ZxD6oQUk22ZnVposukSGilO6Hs8pDBxZjIQD1o
	2hgrMHl1QTIBfUGhh9wLEhoNjk7Jaxo/Vuh8/QFOFNUDFG4xcr8y6ArT
X-Gm-Gg: Acq92OEuFzrPv57w7FS+IeF3gg+g0REI+QmWq/mbgsjssRrDbGnh+u0sNPQQwbAbaBf
	3f5hBiIfWLAgzQeUO4MZzYsh3IVrcZrcJCaCBKZ8WFbpKpZnqbeJsuniKNY0pmIIe6g96G1LB+Z
	ZkjdIvM+/gLdi8HXKPLgFNm3O6P1+xRZHyfwdA25wvb/WHqe87W670U+K69KINKWVpQ9er5aC3w
	QOMQtlfiYBgrVbtOh9pWn5fBYLYoou+GsZ7MDL6v9j47P4hYxSepTpLBMdRSMsqGgsxX+SWruKK
	UBMcVo5ChAyII9JAjfvHME+bymITQCgzGySMzIplauLL5H0h7S3GArjYAJvhmcNXcncyUqO3UhB
	8OtHJydd7dsRi6pWNj6w4nJ0aHIITNoE9bdpNgQeap+nwlipBgpJdtMHrWDWcA5gwRlCMdrMxwn
	6J/35tVn2Rs9kYQN/jMmkoAarbRZBM5Y8TnxSGWyPrpKRaYV1h28QHGYk=
X-Received: by 2002:a05:6a00:2908:b0:82a:6461:6d15 with SMTP id d2e1a72fcca58-83f33f166f9mr9356468b3a.46.1778949694571;
        Sat, 16 May 2026 09:41:34 -0700 (PDT)
Received: from fedora.tail046eca.ts.net ([140.123.97.72])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f1966471dsm9590250b3a.6.2026.05.16.09.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 09:41:34 -0700 (PDT)
From: Wilson Zeng <cheng20011202@gmail.com>
To: harry@kernel.org
Cc: vbabka@kernel.org,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wilson Zeng <cheng20011202@gmail.com>
Subject: [PATCH] mm/slub: fix typo in sheaves comment
Date: Sun, 17 May 2026 00:40:33 +0800
Message-ID: <20260516164033.1566208-1-cheng20011202@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA71D140009
X-Rspam-User: 
X-Stat-Signature: a1psfkkzirqszmbxauqbftddb5fkynuq
X-HE-Tag: 1778949695-154081
X-HE-Meta: U2FsdGVkX1/QiGmgWHZSIxCuzDULYXZ4Vl7py0OPx3jGbE4zn9I4f5j+jqsip1NmolxBxVI3j24Br8DCH+TF5pHG0xa4ouLVgNVOMrBQed6CeULw3RP9ZTMeswMaTq+a1do1GgWaA7hlw2pKtRKSFJImG3VJiTGTKNtQfJm8N2p1vmL709jvriQ+PTiDwZgdLxtOQvvwUCo4Ym4MpfZPuemXvhh4py12nFqKG/25KVH3jJoYXTTqJLVqFSEJImasn50CdamwZ0t+ig/IGzG/LcSm2IxUSITwWflQqK/0v5vYOH1ZGvoZ6Pp93xkHR6l7a893Ya6688uCBBl+SZ67DkO8/T3/5s67fL5PNvDKd4buw81bl88dWck6OhgFM+kg+9Gm7nawv1MQGeujAqcTRLRRnbZdJVwCtUBfemnOwFMA16qlVgF3fBLwvZOEgMPN+SlcRB2FUhdDcAUODd+YBoYSI8X4gyTu38AcPfVeJeA/QeEfGpflCCciE77J8WdH69A8krDwA8sHxymobNyjPLqkf8INvR1hIJv/x8Rgr/suf0LYkJAW6wAt4b50ueObhzYg0wPYi2C1t3tTDxKw7egUL7omK5+NdETiQ6ospG8PG3GY8fskcKbYx5TbdL4r60GPPgKJKQBNlvyubaYrpTI8pS+H7Q+sjOiOZOSug76m2sUZ2QZnfEWseBA7bTS97OPTMQAynrrDu8jOW6rT7WaiKtCgLRuC7W68ZxoCAVEsJVFG4nVdfuGn7CZj6vSJxwWz4gwMbbQDLDBARCbRcqFO8uJj1PwmPfTz+Ls4QKCp5VbBsup2lnY/xo7fEAryDNvuzINpcTpCB0quDOtjSLnUrnxa+bTyGCeAsjdOh5CjiV6Pk4KIaOPYbyeWdgdHWg0crqKvsBKIe/uWB0bYDtRwSnhGHyMp8QThrDx/+pFZV24gOMYtxLC2fQtLCeSqmEebxVvmXw6QHT1KoCw
 kvukLPDx
 Byh+giaaSQoys33uF8qyRx4CPSZaSmASEi+ZYx5sKcUDGcm1IPjwBj6W1l6kmSSpERcuTUjFZlHx3sONZnsGSBBXYrmx5hF+WkS7nRJQyQcs4e92U6UOjwNlNv712BbV2CEbY4ORqUdoUwZa3+lzURIJr10EhyTTfP2a0rhMqmUlbr6BOP0WDTylWhvrHwzerdgFgIRbVd4i7BbdaJlFxD/R8ApfoY3ooQlzUwkgiM7b4mPuUcrX53wyruZSz29sUGVQd7XT1/LOjEfPVyeam1ypbDPUZDajszLBiVC/wjMO3qmbx7rk+6cV08Zn3M0g/fM2eL/acJV8ZAM8m4c5SyrW1gqbiBzg9MaWXiJrjCBnB4JGoJ7F4w8eLElUYWDAJSiEtbO6ZEfJAmtRs7RZtHuJ9fJNMvdIRMHwL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a typo in the comment describing oversize sheaves handling:
"area" should be "are".

Signed-off-by: Wilson Zeng <cheng20011202@gmail.com>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8f9004536729..686559479273 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5011,7 +5011,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 		/*
 		 * we do not need to care about pfmemalloc here because oversize
-		 * sheaves area always flushed and freed when returned
+		 * sheaves are always flushed and freed when returned
 		 */
 		if (!__kmem_cache_alloc_bulk(s, gfp, size,
 					     &sheaf->objects[0])) {
-- 
2.53.0


