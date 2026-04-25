Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0914FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 13:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179E86B008A; Sat, 25 Apr 2026 09:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B406B008C; Sat, 25 Apr 2026 09:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0404F6B0092; Sat, 25 Apr 2026 09:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6F836B008A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:35:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABC521B7694
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:35:49 +0000 (UTC)
X-FDA: 84697176018.18.15A80D8
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id F3768120009
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:35:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SR4F6G7q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777124148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vpwIC0RWNTe0eNIqJqmJM6/NO7cdVeVw+YILoj5Qmpc=;
	b=kjLs6/0akXfZNDCVL54YTtAUxo5CujHOKvHNbZfzPVbfvGFEij2jE/mMOVxd2NX68LfuaL
	IBJRdvFm1BeX+g4u5Ny5tzdz/suZWnx8bdsuPRPN14bwomDWMLo/UpOsvkGLki2qzC3FcW
	54jzFH2u5bpj/DQMFgbDCTatWgfIAcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777124148; a=rsa-sha256;
	cv=none;
	b=5odwufd/faV8D1YNxyXf1ae1TBXC0ApRSjlPvE4s/MRGo0HuV4dcMRo84pU4J2dGAOrHzn
	DMp3xKygKz1xUSK7YBXMPMDt0E/x9GgF1mk/tNuv+iIsrZ9ojh3o2P+/EPTOaL0wYNgnrn
	aAOIQ0dWVuOLADuXi3sEJNHqSkvg3I8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SR4F6G7q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b2d3a9e149so46184565ad.1
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777124147; x=1777728947; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vpwIC0RWNTe0eNIqJqmJM6/NO7cdVeVw+YILoj5Qmpc=;
        b=SR4F6G7qA+FrCQFDl6kSi9slMpn8CexxVWGKIG/OJybcHt7FZyqJVdRkaPtgZSRVFr
         MVv9TKx66KQXNfsHouNkcVc6QbL6Ug1hQWgtj4u5y1dx4DPcN31OWAVZxcJt+sRHS7kt
         e9FfWhs7XOFQfNXCI1YlbW6SvozUsoaFzYL6IDVogjRy2xcgCbvQZW8dIpGvsKPYND32
         yvq4pPiguPQiv9fnpfmxlFisQr/H6rSdH31nMjhfk7GAJoXltiXdzKPmDz4SjVlesDmg
         O0cILGple9iSQm41N/rbLwepxHsDq30sVqIeZpCr45BZWyDu3SQFDB0nf5zKq0VGUhU5
         DMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777124147; x=1777728947;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vpwIC0RWNTe0eNIqJqmJM6/NO7cdVeVw+YILoj5Qmpc=;
        b=pmsPaf+zNfZ5fHSfe+iwBLl6FUUquSWYBdsKd/wK9PvgAhzipqGzD+OFb5vABN4eKH
         20Wd4KucUOaHmJQeAi7iJuDL4MJ3oNV4R1C9DTsTNqnfUWZFOHx9SEnIPJKWmT88yjAs
         LDGzmr2VvupqckdX+Tms48aEyOpOln/1gcuFZDjIKy8PkJSjWvfPCO8KCcgfideFNWgw
         O3kwyqQdbVzUYYZ826Z+gqpFtFEvkwSM8/fiRsFs9bj4apOxUsmWSCcLMq2z3OXjsKHm
         xRIi08jV/Xv/p6PpDaENeb8kJfxY3EbqlpFlVUXfKn+uZ9sod31tRzgZLBco7129Q/+v
         wZNg==
X-Forwarded-Encrypted: i=1; AFNElJ8SsErvvf0XpFBn1FcIwWVPQtO+28CSylKnG0F91D2WILvx2138x2EYREdNHyzD7rs4qFhyISqXAQ==@kvack.org
X-Gm-Message-State: AOJu0YxdeID3EaSC5dYYIshAwwFPtY5UZiri26Sd0CLMCki2VYWV0/uQ
	jJC+xN8oJY53QXIpWRA1+gsYDbLgGhetz9b/PGv82HxKQNvqAjpfld4R
X-Gm-Gg: AeBDiesp2t4sf6tJFGLfNw2tAj2mWBSY87HugMdUs2nPespMbfhmaKfJgnBVJJeR5P4
	aqxzJvPZMhuW3Q2lnp/VsHYNf4qnA+sb+SCefsr7iNIAReHvgezTchWCXn2dfe9ZsYcD8taeY73
	OOB65GAObPPF+GoaNAJcbDjFJtvVHeEWgy2epGY661nQqDUqEMUH4PkL3TjUF4zAPamhIbfadHw
	HChtuc0ZbADdxnND+EjpWZ92NKpa6Teuq6F6vOof5zZhk0QWfqmQAuGrkp2eKWxdlaWwvcU+Zos
	iTw6Mwvh/v9mOSHm8YgwBUK1gwHIQxa99g8pP7t7dbsTZbKuaGI9a98NRYuOWjvwtdr7vdD7X69
	+ZjHiaJjvEbqfNJHVX33AvjP1VaIpMgTq9XZUksJBN1GMOG6Ot8qwVyPUnJZGQfGI/YVSI4BNFW
	VKmWgu8aERp3GLtSkUXVj5wHZRYn5D53GpOe9R43MqCucwiJgumsM8k7Ak
X-Received: by 2002:a17:903:1110:b0:2b4:636b:dc4f with SMTP id d9443c01a7336-2b5f9e950a0mr312507355ad.15.1777124146754;
        Sat, 25 Apr 2026 06:35:46 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.21.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab4cc47sm259868065ad.82.2026.04.25.06.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 06:35:46 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sunny Patel <nueralspacetech@gmail.com>
Subject: [PATCH] mm/migrate_device: fix spinlock leak in migrate_vma_insert_huge_pmd_page
Date: Sat, 25 Apr 2026 19:05:27 +0530
Message-ID: <20260425133537.17463-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F3768120009
X-Rspamd-Server: rspam04
X-Stat-Signature: t47q1d4hhqhkcgf4ocy9who4x9mscss1
X-HE-Tag: 1777124147-972193
X-HE-Meta: U2FsdGVkX19TZ8P9wQUyathY9zsvvoNT1TD+tKwIwMOyuADL/tq/h6Y/CzlY99z1wt1TKwOF1K0VzsrdKLoYNDoni5lDYN6gbhlRGRKISfIP5NQa2emT4Brz8pyQ2ZKeEGV4tcPzh4jxtQJPZvJ1KFyG+Q2qOYvVEnFfi+1DqJmHo6kZTAa/VtJB61K2lkXnwzQmdvCudek5yjFB1FjXU+N4t495A8CPrQTU++u4jr7o4iV0W6j4mHQoPuAF1FIUVBGEJtrwjbaIxuHCX7SMCe0oe3rGQzUr8KoQM6arC8g/Lihc+bhg7RDfIHHTAboCCYXqx9tPKIeMnyQuev3PyYJ74X+jHpv8AxzzUiYTb5q782DAXcDhM85tFjveTP2SyFZty6MeDCTJWM/SXT4r9goXkW3AadjJhc2dY2rhqiIElIsTiOmLfqyzP9iZO81unsmtWk6mWlzxEbGbuW3hGaLa8o7bnqlJb87z8AGprL8tacg9tTQj6cH45MoYu1B0x6u+GZmw+Hu+addmmhg1CBoLSwNuLyw2cbzIrRLDMh5pwBMx+FWEl5JipOZwgfdRb6Dhlc2XvP+2n/eUuHQnW2KC2m2SVs7NYO0wCpr+/GyyInJgd327BwoGE3P8N5RDykv9QRoHuyuGGEWuXomOhXg59bnVVtUIl8uXFlCRqfG64p6KPwBK3d6/noWgS0mMRL6Ue4mBXqP4jMrBcG/YErMNx8r40ts9TtYksRgCWfIG737YJsFdWCnjJON3JIr5H7ZYnMAY+no3J4sMDA37r8B92KJCNHtieelFvEHJ22Z+Ab8aWTFcumEOu5erd3n6QiZOymLMh0Ubao2pSLMWSUCkuh1Bz9994nwhC4dytGiAknj5M+DFIfFtfNzcFUZmcCFoAAB3bSsJ8qLXMS8peQakyzJuUSk0uTYKaBarB437hazdUr4B+RUAfgOywesqpTkcyHyyAl3BdSKCfFl
 vVrdxAje
 M3ktWDoE26iyCaPlu0nH3yUpYeA9ssxwTYbHJD58YlHwoti5o7htKZuLGGd2XqTThlhL+OWbO8yqRa8kQdMPMUSBpLPQPnwRJVfkagUQ/j2DRlYv3z/FXjliu7FI24sfasSQmHSoL5LGNT2oN/AzQgFV8t/D3NO5qRX2Y83OFMKnC1pWgIomHdJ6qltmGEfBoqAB0/sUAqIv4keOM6fQ+iYsw6wj6uhBxB+0qsDIpGKT8abuJnJ0HNeTZwyWzgHVuHja5JsDoDn7K00GiybnCS9q5I/BQLVFc7yxrt8o0UN/H0LFDPqZgZHSiD7AsFiME5YoeM3rOwmx3U5jZni9T8cnCllxA4n30tGTrWmYaAotidbn6sFfWfRUjdYIG7BjOB3UugX+Bb4sCd/XSpLUCj0RjA50plhIzipnRMBKZ3YxZfOlnrXpgJmwE1g8zFZ8pTy0LzyKGtmKvli15BRuZtB1eZPHKJB9MdHOjS92v/kQ0CTOzthLNxOmES3ae9qPi3sXovLa7LaFW9de4i+54g/nw2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When check_stable_address_space() fails after the PMD spinlock has
been acquired via pmd_lock(), the code jumps directly to the abort
label, bypassing the spin_unlock() call in unlock_abort. This causes
the PMD spinlock to be permanently held, leading to a deadlock.

Change the goto target from abort to unlock_abort to ensure the
spinlock is always released on this error path.

Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
---
 mm/migrate_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index fbfe5715f635..ab49d4dcdb60 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -850,7 +850,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	ptl = pmd_lock(vma->vm_mm, pmdp);
 	csa_ret = check_stable_address_space(vma->vm_mm);
 	if (csa_ret)
-		goto abort;
+		goto unlock_abort;
 
 	/*
 	 * Check for userfaultfd but do not deliver the fault. Instead,
-- 
2.43.0


