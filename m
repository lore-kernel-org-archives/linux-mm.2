Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1D3CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937716B009D; Fri, 16 Oct 2026 10:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7136B009E; Fri, 16 Oct 2026 10:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD6E6B009F; Fri, 16 Oct 2026 10:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57BDF6B009D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:36:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E99B2A0455
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:36:05 +0000 (UTC)
X-FDA: 85328739090.11.8045960
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 31A021C0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:36:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NFBr7CAW;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IOU8844GqP3uZYexY7of/ok6QlMe41LHb7kZwENMy4Y=;
	b=W/iUK/5e9O8ByTm9Cnk/BcyeuM56ChMhvAhFpabOlBEBL7z/4SjE4FaKxUby8TiHQVd6yD
	6Hb4c7wQF51sIRNuMaaE0R3NibmIJg2UeXvbJC9Mfq5Bcx8+dz7plMPY7LHzYsTQIxWWnX
	yKD/DmSeihyUUu8vlugwEdfZxluqnaQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161364;
	b=d70DUuTqdtI2y+NriXZs8vf11hIDLKZ0zMKJzKvw9hQfMp6mFTevh34YoS8pK8QkqT8+HI
	bC1DUVW9lE2xj4VZ8RAJBtfRJfcEFz6C7mKsBhZ5kWcSaDhdolC8ePnwMEDGfZQyaQf8vy
	yHAdSalGdoKjhlzO8A6DYtjQGH6ay1g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NFBr7CAW;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e87c66e556so5699825ad.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792161363; x=1792766163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IOU8844GqP3uZYexY7of/ok6QlMe41LHb7kZwENMy4Y=;
        b=NFBr7CAWL/ce9O0X9wj0pZCDXT/xTXYNGolvt4gOKh0juMBX75ZpmOjtISJi3dyw+/
         iJUub90l0Nc2JMZuZ2cuDC015lz02a4OJ3qAXGDDdmDSbWw9cT7SbBZkPqCObE0Zcu3w
         +DAzwrdYXGo+sv9RsZQ4X/fMOw4IIg9AX83baol11zKAWSV0Kwel+dKqNoUX10Rv8LiW
         LrHCHoBPrJwLMwYlVvZgR2+oiX84mSs342g5+t+El4rEhOXgVT6rdUjWKCKVrRpFwcW0
         YS+F/QZqeqJTrxo8ctw6k9vKY3DeW8Y81g8FtGaGlJJI/wj1WW4i8ust4V2rwHclt20b
         ZD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792161363; x=1792766163;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IOU8844GqP3uZYexY7of/ok6QlMe41LHb7kZwENMy4Y=;
        b=gEm5NpolgFmXlFqGdHsbmSfeUb13n97aaOJ4ydyB5xtKTTPKrNVRKG342uFPxnVdk2
         edKlbqmXFonIu7LMSJxySXAZsRhiDP/TzhGIttegz5uaDYxalqpwwtZ2euXaT0d0EFMc
         UweFtO8m2S8HAW44lHig1tHribyh9eDzONrMaccsNnzImq7RhzM1OW497xgArbC3yu0L
         bgma1NQZZQbKV3n8Akbqjdflv96XpMd23fwarlxu4Q9MDSXCdr3XK1SGlXWwTFXcUFLL
         dATnsIvkIZyvKY5H99u84DTYriE9q/K2RiaW01rVLgeQVgT5Te9HomPezXf8h/P4iAxI
         VOFg==
X-Gm-Message-State: AFq9FYIllw5sTp8IVN0h2uEEth/3LfWizuym3YmQZO6lgcAoCSyC6Zvt
	9gnHxnVYRvyvDgC4cepIdTc0yAmFwLC1u3WZ0g188/SqbTnlkQSGdVkI
X-Gm-Gg: AYBFou394mkGhSCl4/hK9I5RSJnpxntEgweB2xLIE09/QZib01qzPeUeoaOW5nqbz7b
	8Nj5F2PE0Wgvum9MOHwjcNj7vvbDOnKJ3bXEZ9/QqmZ25PbnWg9Xnce7/3N10B0boPw7vT6Vmkt
	Gxxw18nF1TeD9mp0DXD81b8OKjxanKTOlhAZ0otaMFUs9TfyrpBQVl1zHc9QJnPpwhfp0toxazC
	l5ITAZCejgjSOE4YlUeO73lRdmZ7S77Uk/WC/Otko++vR83RQE6Ll4VYM9FT9QFRySIJWhyCa4M
	pqjnwUpoFCcPrFtK86xTpvAaQ+7OrJgUXxJzAvOMlu97T776ohzGw0YoS5bUyu9tMrk28Yl2R1G
	foiJZb0JFp/1hJcJSR1zzICLEeDwLR/HTRrI58wEqpP0ryuUc9t98wSB6BTY1eERuEzb4+AaPe5
	lBmuKcWUIOSShVyKxJRfWV1A9duP+P0yRx7TXEMOpbYn4+gPSvUF4s8TZ8xGXRCmv6yld+UW6wx
	zV1wv8XImuG2OnlQA1rgwYJ
X-Received: by 2002:a17:902:d587:b0:2e5:41d6:178c with SMTP id d9443c01a7336-2e9a6d24de5mr1094065ad.33.1792161362826;
        Fri, 16 Oct 2026 07:36:02 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e83498csm11170095ad.35.2026.10.16.07.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:36:02 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH] arch_numa: remove redundant nodes_empty() check in numa_init()
Date: Fri, 16 Oct 2026 23:35:56 +0900
Message-ID: <20261016143557.307080-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 31A021C0004
X-Rspam-User: 
X-Stat-Signature: hpbbd6113zhtt3g5wxbrr79zoyjjet11
X-HE-Tag: 1792161364-559849
X-HE-Meta: U2FsdGVkX1+P4joS7Lvt9c/GKsqH40GRvINCvQK0Fq/IqELfM14qqD4D1YLRhoCnkl/TKuZkfyvd8RtJADYQggvO23UQsASgwRYAM/65UAK0DrU9G59ExQmJIQc9NUCF5utz1Zqx/2etJw6b14Iw5yF6Bwpgo6XT2TWCDoKnKcS7zAAeyx0VmOleW2nl6afgExAuzpi4746z/VKEuNF35Xa6UYMEGdoTKdI+joCLsT8tAHI3jrrAx04epg9nuXHhR0pqf7r6JQ/4kLUNeo/QxTUBz6krOWQs9xLABkzQ0Sluj01ibT11dKzJlFmoIa5MCEj6RSI5cO52N3sYX/SlOCa2CMG+ukwaWvvTusd+8Vlhu1+kgrU+bgJ2uJy9ZckURIb1mE0R3EnMg1ye9JJxXP44t8qdAVRFhMRr3cdRM7PK4+c+tsvnX93CgMStf2CMnMZF16Xb712AKtjQSFHsFuo4Ey4a0lYDnuwM+2T/IIyoxfFRrqmLvBFWxktycpujdXI1mJIzbeWnhCv0cxH9+Zdy6KPsqLnsjK9NgcYgGn7LLUYqjAhSlUocpsJ7LSaq1ywN7Sph0ni0nirSmFtG6QRgJHQuDIS2iXowPtyup+QAiFcY1tjfOcPoA8aqsKbv/4G4P0wWx6tJZJ8n144c1OA+ZASk9YNLDbZLBKin75ySrETQN2iRUY8CAY6y7EhzqSVsSVjZjEcXEGAIy67L7oQbRUljmlt4w8u1FOgEvucAWP6vQYmAMmSuSR+3BY2/0yP4gg4N+jt7kB9WtZpvmFs06xaDPlX5r10D0Qp8Mx2t9gM1TP9Sqz4vghMDX8Rz/NhBi6dUMRywCjo0QOc+9Ph+2u3POgk6eBiRvz1rWU9D5ZWwFsBSMsxN57V5YelrD1YvcTQ2hf3mXfvRrl9nkUOuSOYfXetey9CywJCfuFJYoGYUkUA7x9r/zc6+I/AFCTAEUODkGdSn3LVB8LJ
 KeRTjmZF
 TAEZ2IB1tGMxNO3QXc8Kr5wQa1fwLjOP1kFXolAA64dccdhJnWeMs19aYfZSX6DWvsL3O1EOYouDRj+o+xIHSH9b5irXiHEnxrHEHwe+q3kGheRKfC3ZfH4Y4htCX/mIlZCqhSUbDAQEsCOFn+O4f8pqfoogknqxzqa5eOPlc3zSvC/pmrf0ZzQBL34AtUMNNu+hieEDdYVWdYThOMbrtksvV8eqQpL+75xU8IwJH4/zKU8gvYGGO0qMC7hDkdgYPE/iyWVMOcc1zBv4OuKABRiN77WyVj1QqxQEbuEa1CX48mVdlm+fKW3L/oKEmdTRcyXWZYc68OeURCSlViWa5Ls5KeZE6GcULfSbnpvHV49MXLz7vHalxGYTG2mhVPtokngzKafSVxilm1HLmXZd7ujm2wXJmWyrmdsM51mfrWmpgF9TvI7WY8rRqfnm8vDkJrzQ+Ow9ordaYRyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_memblks_init() returns 0 only if numa_nodes_parsed is not empty,
so the nodes_empty() check after the call in numa_init() is always
false.

So remove the check.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/arch_numa.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/arch_numa.c b/mm/arch_numa.c
index a4b1732274fa..60218d422118 100644
--- a/mm/arch_numa.c
+++ b/mm/arch_numa.c
@@ -244,12 +244,6 @@ static int __init numa_init(int (*init_func)(void))
 	if (ret < 0)
 		goto out_free_distance;
 
-	if (nodes_empty(numa_nodes_parsed)) {
-		pr_info("No NUMA configuration found\n");
-		ret = -EINVAL;
-		goto out_free_distance;
-	}
-
 	ret = numa_register_nodes();
 	if (ret < 0)
 		goto out_free_distance;

base-commit: 5728d3523f12826a2b180c1c5738f74e33197e14
-- 
2.43.0


