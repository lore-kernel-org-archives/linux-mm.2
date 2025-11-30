Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E320BCFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 12:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C36D6B0005; Sun, 30 Nov 2025 07:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CEC6B0012; Sun, 30 Nov 2025 07:00:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5AF6B0024; Sun, 30 Nov 2025 07:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6C0A6B0011
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 07:00:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ED8012D1C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 12:00:13 +0000 (UTC)
X-FDA: 84167130306.12.E54E6E9
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9149118001D
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 12:00:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YScU32MD;
	spf=pass (imf06.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764504011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aQd35PH24a+FaKSHTZdH0PU1afDBrWjh77AhHAe0IZ0=;
	b=mrjV+CMfFkt/WcYnKRHKotryUHJztip/FZ2ErdMc+CW0GxWPGr7GGmxDdOvFVV6/FgY0ss
	vSCH0QU/iMVgPmgSKN/JvXkEel7xKbEsuw78BYDE/lcQEnKkPUj8q6i1Evt8e0M2NTdveY
	bWKn03kTQKlYY00XkQLsDSry+aBCsVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764504011; a=rsa-sha256;
	cv=none;
	b=eLJmT2Phj6ZuxqYfIno/qJKgB5Z/19KxMiIDr8nqDIzTqAU7rrDVLdNUBvLRAoukWRQfZh
	f/xa5EE4dNtP+lErc7fbq5/11CM4ofYpZj/2ub358vZC9970ZDwwl7FoDJdFKk8pnD5W/l
	TXdRRvKe2xLzgAIaHSua33bUDJv0ay8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YScU32MD;
	spf=pass (imf06.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29853ec5b8cso39762545ad.3
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 04:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764504010; x=1765108810; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aQd35PH24a+FaKSHTZdH0PU1afDBrWjh77AhHAe0IZ0=;
        b=YScU32MD4dlUMegE+Hvhw7+4ZPadu5b9eTgrm1c5SCIqmwB+8zjxJqBbAwQy5LUMLj
         dD/QLcHIBchM5XboNyec0V6B1a93ym6S0BqfZ5hmwpSztrv6IMsQXRh/k5fg2lgWqNo6
         YJkGyC40SSMCzWude4zLDrBlM8FKuJxOujXmHxPwduZYyyQvjMkSF1eq6YfiN/Zj+Y0D
         DDsTcfOiCWss+bSNNNuA87eDqZxziKKr08AUFjLQCa8AMKB/AClvDoHfwAC6T3BnydFO
         LKfT5OsH2wuGb8TkYsyIMV3pTjspU9ksN77p72z+6X7X/V9iAA++vM0Q5lmUdQq+feu4
         IMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764504010; x=1765108810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQd35PH24a+FaKSHTZdH0PU1afDBrWjh77AhHAe0IZ0=;
        b=YT8QypWli7NkcOUdnn9eTB50IKS+FTWCyF/ZFCQTsXU6RPyBvCPkOxKPxlTp5FB1IM
         YgUEjMTfEGT9G6vURypaQdZOFbqb3tAHKpiJQcfWKYjC2iNYo9rHp1E4paKZenEOOJyr
         XBQeq2yUaV70sqUeOe9IYmLMV/Xb99jeJO6z86oWUf/vrGk9C2DWGfCYopRN10/za2Pk
         npxVbL0D5AuDGNhPWutQwgG/5Pl16Cn0meeJZmVDm3NYGAXqa3aIgiHZhonmoakVieCe
         jaPdEk8/LyX4qOSjgJaZzEqKp/z2KgihInRBYIYovnuydM46br+q6AR2tQDfxh907whC
         RiPA==
X-Forwarded-Encrypted: i=1; AJvYcCUSOVMg669NLOgBHSFsfEYWdDI9vNuj2Oq6Jc0N5ekWPIvJdcTOQceRQgftjUy0GFe9SMj5Mna2Dw==@kvack.org
X-Gm-Message-State: AOJu0YzOiRWcgg01EvFSVFmHnkCcI6a4jaH7B4mi1NLHbxRQAcaqx+Yz
	gZIkSJMB/S/O3pIQSBKiPb91cMhZ6obrDEmjCXTOqkUW5gBdCM8tWiRe
X-Gm-Gg: ASbGncuiOzWHb3ubGKOKRQ4dwC6iojqOZymQ4qLTdPpdX98UqQ/KHcHVISvP8j1pIGI
	WqOVtdNK6tf7D+UB+DmluukfoQx2dGRybp98dY/rTzzlOtw6tPmvwErpFjaOLVFS8LiNJzL/1hY
	GL2ZwdTcSjGnNXGLEif+hlWfB7qKEQ4gbY+9hBuDcbb3QVy8yZfJRlKlvkZqKa4KI6U+ib5nBJI
	H820g0KN+c2GJ52uJfVXAGWrTZNPsgn6YlSYCE6zzo9/Nzgyf+pPZ7jjytBCHiiygAXWvZRJT8D
	ad3MhAAT/m7O2u91vOHtWLK1E+wGA4/9gfUbpjnDwX4WMMgiZQxAJwJDH4OEGkWetcsS49etC5x
	bL/7tCTUlOc7j/c+IGV0Exeajej18/C+SaOc+IzHZfCUNSDyBBAokS6Ykws+l3JP6x148s4hDD2
	M29E2NT8PIpJN6qNIydCQR0lMARZM7mA==
X-Google-Smtp-Source: AGHT+IEk5MXOYDcGHxwwdm3YRUkUxYKO1VcgJ2C5YDWX7CP15PKJG4iQUJiQj0Nn0ZXG2Nhli1PWtg==
X-Received: by 2002:a17:903:2c0d:b0:295:39d9:8971 with SMTP id d9443c01a7336-29b6c3db364mr409791765ad.1.1764504010168;
        Sun, 30 Nov 2025 04:00:10 -0800 (PST)
Received: from LilGuy ([2409:40c2:1165:4907:48d2:1e37:4c68:acd9])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29bceb40ac4sm93762855ad.77.2025.11.30.04.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 04:00:09 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org (open list:MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION),
	linux-kernel@vger.kernel.org (open list)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [PATCH RFC] mm/memblock: Fix reserve_mem allocation overlapping KHO scratch regions
Date: Sun, 30 Nov 2025 17:29:39 +0000
Message-ID: <20251130172939.574999-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9149118001D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: f9jiejwhawd4584iru695br3ug4knmgg
X-HE-Tag: 1764504011-268429
X-HE-Meta: U2FsdGVkX1/m2ZTpePgZhbWw2medzd2/uEaTMMV7nxsbgUCPxt+VY0HH+PQc/Pqw/RsU3BmyskogTS70j1Kc752XT6mqSxDyZqp625sW3zk+q1u+lTk4I9jouHudO8URGQJ6IFy8ly63HAgW5uPsaVwQWSJN+BA1cPL6Y53v3ak3bzw/CBeojYkiMh/jgZdCJi3fRUhDLGJMaVcTftPqncSDxnkWwv/tM4nbNcNl1S6sJtlU/4AcINR4cksrE3xMKDbA4we1HnWOiAWCpPAY3JOc1r5hWp7LnIf8FTqLYzcOSZWvHFXy2C2OplX7hLy1+lTREz6j7YNckR/OznNYQ8jycgnFinsc9FEuvMtT9QhuDsxnsmtTPX3TuRH0CoksUmqLlZIkMfXs2hHizv1SzC6XMwtAVs0nzFAPsu4l74iTQH+QlgTO+HdFdajTwr91ku4QsJj367H64ntzGyRP95uXb1eS1sVEqfgVC6oC8K3RcSANjTGD1cVwey1b+gFtbF85xE/7hLD7/hepz0pu1e7hGHPKTu19Wi6gUiw9f+3m0A6Df8ChU/GELH+JfPcXHsQaI2Wng9HDeb7kqhjUPsc3qQ1x30xNenpP1+6YbLDoazv7GHx5yfNvwWc8iMGdU5Z/RM0xEIijBxC2ZEPwQBd9/quEM5swzPCwb2Uqo1ysMS7bqjYQmGMAoqdRYswhV0VUUb4iE26vIlTRltaP4IygSoMA/ZQv77Nmz0epkKb/s8FkMkXkm0Mvydy0gXdJSnKJNNs1eZJsCx7c/Ep8KeLGRtTlFqRaUMiGn6NaIdPT+BNyQ65LPbPb8LzueFK9p8sHh6GSZ/qEsfZCtHgL0BtaUWZsSjSiXMaKn8NCG0Mo3FE0kEZA9ILhuCC821BcsnDRaWJLoPNxUQtOvgyCMrECVqZp0oQb8s9G0JLmveqINidHOireotbSlU7Uo78kEaRH9XJu3Dwa7ORhiKs
 n5mR1WWJ
 m4kXaJTNwS/jRsn7pwcwVrLYfhs9l0/C9MH/kCu3JVr9GwLuhF8w58XumD6Q2NZp9hfXi199AOuofdIzSkgAtRnUlMfuAzsPeg6Q2FPvSnyKDzcBuAhk5mg2t8mccgwJ6txthv5LIkvKIq8Nn82nhfKUmydDh68yXhKIa9gR0o4UTasQuyBLSPaztvVIrF1b53PFT3HNDgJXnEU4vIi4fqX/zKxk/3SAy942D4StwxwN4L7STVXP/m1ew6EfO4+ZLR3Ge+WD6W9olzQkdOmFeeM1D/604tL3UK2LWP4Cx0mHjhmzBTfRPGX9xZ88V8LoYwHfDfgLBHN+zDNYNc0qYx12Jc9T9RfOtK0ax7roGuRETskywPxh386yTY4wjhbF69lo/LQGbcblg+s5kjaJbzgVgW44EUNgixo/Wk7URNQ3RmxyYHmrQW7EUcwlVv7s7WTt0BsOchuYbLcqHQFi/szwT8LYFZmqZ/nbayl+iW1Yqbf1ZLSxiCcdNfmg7x1Ihik58bMVR328kiv+eFeiaS4B6A9s35V7gQqXwfJmZOz25FYeAMRsdbu4QGfSI1gZlU0BJWbYUnS82zX8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, `reserve_mem=` does not check for overlap with these KHO
scratch areas. As a result, a memblock allocation may land inside a
KHO-provided scratch region, leading to corruption or loss of the data.
Noted by the following TODO:
  /* TODO: Allocation must be outside of scratch region */
This RFC proposes extending `reserve_mem()` to allocate memory *only* in
gaps outside the KHO scratch intervals. The logic is:

  1. Walk through all KHO scratch ranges (kho_scratch[]).
  2. Attempt allocation in each safe gap:
        [curr_start_addr, scratch_start)
  3. If not found, attempt to allocate after the last scratch block.
  4. If all attempts fail, return -ENOMEM.

The allocation is done via `memblock_phys_alloc_range()`, which already
supports constrained range allocation and preserves alignment guarantees.

This is posted as an RFC because I would like feedback on:

  - Whether the allocation-gap scanning approach is acceptable.
  - Whether this logic belongs in reserve_mem() or should be abstracted
    into a helper for reuse.
  - I would appreciate guidance on testing this change.


Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
 mm/memblock.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b..7605a0b2b64e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2684,8 +2684,22 @@ static int __init reserve_mem(char *p)
 	if (reserve_mem_kho_revive(name, size, align))
 		return 1;

-	/* TODO: Allocation must be outside of scratch region */
-	start = memblock_phys_alloc(size, align);
+	phys_addr_t scratch_start, scratch_end;
+	phys_addr_t curr_start_addr = 0;
+	phys_addr_t alloc_end_addr = MEMBLOCK_ALLOC_ACCESSIBLE;
+	unsigned int i;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+		alloc_end_addr = scratch_start;
+		if (alloc_end_addr > curr_start_addr) {
+			start = memblock_phys_alloc_range(size, align, curr_start_addr, alloc_end_addr);
+			if (start)
+				break;
+		}
+   curr_start_addr = scratch_end;
+	}
 	if (!start)
 		return -ENOMEM;


base-commit: 2178727587e1eaa930b8266377119ed6043067df
--
2.52.0


