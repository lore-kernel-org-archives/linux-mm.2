Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A159D10386
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 07:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC0B6B000E; Wed, 26 Nov 2025 02:20:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4206B0010; Wed, 26 Nov 2025 02:20:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8BE6B0011; Wed, 26 Nov 2025 02:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5666B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:20:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D53D61A0414
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 07:20:58 +0000 (UTC)
X-FDA: 84151911396.03.B9880E2
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0DE59A0006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 07:20:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i0jtEkQH;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764141657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=++OFmITUuVikHMD/+Y8W6iaD/lXTc/c4Osl0cr3LNxU=;
	b=uLhR+pR+lLyNlSMtw2rxhDegWB4t9PyJyzpKxrvq4ryvW0hRqIdDc52CW2NIkUq6EvWLIg
	74cKWoFCkG+6MBy5i3iUcvI1jiyptKvm34kkgEPa7V6dvllNg0I6sJYmPga2+r0qpuHnCN
	5rwhF1r+luep1npPnGLMr8QDqt7Klfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764141657; a=rsa-sha256;
	cv=none;
	b=TSeNkKYCFWH3aiSjquUuZA5Pd7nL9Ak8ivwAQgEZgt1iKH+yGu1y/VtsNYgvu/zlri/1Bw
	m6VrisKOPR8bs1vdQBvp3jJw7dAdgn+/V9NshMnZl9xXRamxNAyXpENtn4By3fiWITvYqo
	+aA0LlOUL7pggICXnuuYRlFPRRTYO3g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i0jtEkQH;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c6cc366884so1738440a34.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 23:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764141656; x=1764746456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=++OFmITUuVikHMD/+Y8W6iaD/lXTc/c4Osl0cr3LNxU=;
        b=i0jtEkQHFqm5kCZuh2Sjp1O83UA3LHBaQpQ8SN0PTuTprLb7q0rF3JIydNZXoGjEsD
         J1cFBcMAQ2BbWlgDwwFGCNhYIM1MESuqPI/5Z5dFsBawwicx3DGg682aJpx9C6D4qZCL
         c/er89w9jQAuu4xPNW+u6ulqunj4R5zsTeH0GAa3oDbKNR0tN1hFFd+Y64pACX72K9p/
         JuT640Sg5Lqkc4INktDJaE72AZYIkeFLaW9EfBRztO+f4lkx2jf8BE0Vuxf2yOW3o5VW
         J7IHdGVFLRQCh6aF4dlk9oawv9Z6VKpqJsudCQ1wEjyrhSHmYRDvEO690+6eOF4pjl/k
         mnzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764141656; x=1764746456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++OFmITUuVikHMD/+Y8W6iaD/lXTc/c4Osl0cr3LNxU=;
        b=JBl7Gqv+5pcFo3qJnOaCJto4v6rZT52xWDk49FGYSwL+8IvfyevR3T6lcc2FrmHHAo
         /axd9M4onDdQjfjND4lpaXWAIXNGeIGoQ98tA/G+4w65tkASgpU/fqSPBifAz42fTJ6o
         A/VCZTB7XcAbg7XzGbxZTVZernQElq3lJPszm1lUwXalRrwelEzpmyKoJ21aQLldqkd+
         u1AH/Jfomlt8qW5qQkoZcjCApKjGZAEO7m2IyAcwh7HF+AQalgWDgDWBpkMRU/jvHcKY
         zNK0/ZaddI7cdAyigewrnknuhsjwkN+LpomqZWcpyQsuXLTOc0bqJNEFJHpsL7rNMxUZ
         EVtw==
X-Forwarded-Encrypted: i=1; AJvYcCVptLKilXPjPn8eSK/VAymnoW2tx7Sss+ide/kryIF356Pd3nqpiFAk3V7He+vmjHWSFa4Q8WeY4A==@kvack.org
X-Gm-Message-State: AOJu0YxJf7eJRiessElFy31/TYW48icoVmL1jhkslPohRQvUMJfmYZDE
	KweNtEKT4+Hy7sJUoeLMg0CI4FO5Ae6O22HiJXmKKlLtKGLVYSN0vhE9
X-Gm-Gg: ASbGnct7iVeq1BNxtpiwHlx+2ftHjoiT2yLhmT1MfqvhpxQuVqeGNFSNmKx18ouAxGy
	oNodSipN8TXfZVtacL5dPL1zSteFpDVfX0/lEqrItGAfEGxLL3rRPnQLyKZyJUY8dipftpcztAJ
	WemCBXAAIcP7bLBfomv2fCypafjtOvTXgsm58pvO0OefuroNNQRUkD+hYuRvYnTX3QZ9t/+bUWO
	APpGuFOxs1vq/+pr8mQjVnr+lXaB7F63f5pcC2i9WXIjQ1EggljtfMHgfZQ7O1lK0rqqZP0lfkX
	YhPLcuu1KJNg1OPujsOlkHOeeJCBWNj05mCoBtjSADQL/wHcPPfhuxU6+XOkewN3aaKdQ0lYBP0
	U/jEU+95CXN530foSOd8kwpncpNOiXBuKT2kOa6nO3oS0zF9nB3uGrOo4jgv0rZhKfxKOrZVVYw
	VSRBnxAz+2SEq4586yQLyU
X-Google-Smtp-Source: AGHT+IGIJrtaoTObKdxSBrYlL8iQdTX44/ZDYlOAVdz1Px/Cv6o+2z2VpTQQiENJFjqEsNpBf99bBw==
X-Received: by 2002:a05:6830:268c:b0:7c7:8922:ef9d with SMTP id 46e09a7af769-7c798f66bc4mr8977273a34.7.1764141655955;
        Tue, 25 Nov 2025 23:20:55 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c78d30618bsm7229780a34.5.2025.11.25.23.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 23:20:55 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: changyuanl@google.com,
	graf@amazon.com,
	leitao@debian.org,
	thevlad@meta.com,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH] mm/memblock: only mark/clear KHO scratch memory when needed
Date: Wed, 26 Nov 2025 07:20:51 +0000
Message-ID: <20251126072051.546700-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0DE59A0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ad8rtuf7aio8qamk3nw8jtr4jow1rr4c
X-HE-Tag: 1764141656-640749
X-HE-Meta: U2FsdGVkX1+2JISIWVpZUUCEQ8hViuWo54coZl856270SJVpRt/wIJq5vwgckzAWTp1z97i4PGhXCHKN3S70kdRn7PH6eUhLT5x3Os083hRl9M0hUGROInjuWxa4SEpANJ+FcJ+zsRcNR9QFqTBj83Q01ugZP38LnSJZLvM1iQNNWl4B2Ya5t3wG1ji1NSS6S7N4cwiGW5g4s4EYFqRukObKpZeihMJOmA4LYZy8iH6UUK8jzN10CmW76BBAYTCmPT4nV/9+o4EYzO99r4nNRnKeOKLMigypQe8zRN5B78FzSYb18yg23RJYJgmPtC2BXbyNS6lkmLicajYkARjCEphQ6tJLINLPBdC2ow6P07ZNvKpjFdmNOhy4BeFr57S/+dxhvV9VjvCrZEXXbSmKsYCyo+X7/6srcjn+KFOYQ2JThDOJSJjTAbGKODparO2MgEw2zdsGxcQhVeTGLUTzjB9HAt8b7CN8X44YbM1hb0bnnN05A7y21M5D3rUX0fHyKCw5YW6v5Ks4AKrUnGdPDJdUMS5AIFlvjEO2cjioX3PIciCrfvd4H6HqM7RHanapPI6hjcoquHep0jbhwlbp/wv9JZltmEbrDrCvJtNNm4PSP10g/PVmWhnoWhCws3MC83ONBg0oJeBQ3MUf952oLR/EdI9p0/el8uNq2hMjkyK3f8ZUDFdkmFvZSHmqAZZK85Q0NzZFmaHLby0IVxmRNmsd4pq5IGjWkDZH664UCK8I7P0f+SshyIhuaYGzIrV908diXwUA789cunzm7TzVc7/rrY+3dPuAZo7mtXwTXzlXQbFMgRuhAw2BGAOoeruAeaQsTdH78Ccpq8We4lFMEKNzll/g3t1rPchpH2qNjIeZ//NzPTtTa0ma/h1muB4QLJ0kpNnzkBe2RRO5F7MWOvRvRhNFtD5gABtPKaMf2TFmhWi/lOvv82IXkpRydWRVPOMoZDLDdmskMHBt04w
 sFmTSIRu
 b5Jmj4NpOc6tH12Z7vVyiz94cx487eVSsY0Rc4eO6XsrMlFLZnn3z+WGFT3QopFiDrf7QttiiMgL6dWTnSEVINYJo1pRDzLCklEndp2xbbsu15vzdvo1fvTtJMfAyQbXYBgcjVv8+2VYhXbv0wkQETUWkD98yPna9ou8ifNlZdnwEXepO6EBV66TcpHTMKv87YfXkp/Zq81NIAyzSqg/c+IP3Bd8f/oE2yNGP18SMqlr92jJPzk6AVPqn37ijg2zW5h4flZsluW0rkn4piG1aBEWgUQRJSsVpddFQlRaXKdkQnY1BGBXoJbbMj/oIUOePlrJLL3WypAR0DiePpxiBLyuM6HIRl9eGFZzIMYgMrz6kqqda4HX48PXFB6QuY+kNNWRE0jWpdNrubCzcbby3JAcXSZCxVoRw1ReTjwQN9jCPJtX6yCEIh3EhHtcifMf1TlXJLJrVYhvDqLVetTWaBY3x6W5F4tzDV8oLoiocXpdKbRqmCSqvkMzS2XjJlBaa1HqGc9HJo4xsOG4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The scratch memory for kexec handover is used to bootstrap the
kexec'ed kernel. It is only needed when CONFIG_MEMBLOCK_KHO_SCRATCH
is enabled (selected by KHO) and if it is a KHO boot. Add checks
to prevent marking a KHO scratch region unless needed.

kexec_handover.h is now unconditionally included for is_kho_boot.

Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
Reported-by: Vlad Poenaru <thevlad@meta.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 mm/memblock.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b3..5c85d575bb61c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -20,8 +20,8 @@
 
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
-#include <linux/kexec_handover.h>
 #endif /* CONFIG_KEXEC_HANDOVER */
+#include <linux/kexec_handover.h>
 
 #include <asm/sections.h>
 #include <linux/io.h>
@@ -1126,8 +1126,11 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
  */
 __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(&memblock.memory, base, size, 1,
-				    MEMBLOCK_KHO_SCRATCH);
+	if (IS_ENABLED(CONFIG_MEMBLOCK_KHO_SCRATCH) && is_kho_boot())
+		return memblock_setclr_flag(&memblock.memory, base, size, 1,
+					    MEMBLOCK_KHO_SCRATCH);
+	else
+		return 0;
 }
 
 /**
@@ -1140,8 +1143,11 @@ __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
  */
 __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(&memblock.memory, base, size, 0,
-				    MEMBLOCK_KHO_SCRATCH);
+	if (IS_ENABLED(CONFIG_MEMBLOCK_KHO_SCRATCH) && is_kho_boot())
+		return memblock_setclr_flag(&memblock.memory, base, size, 0,
+					    MEMBLOCK_KHO_SCRATCH);
+	else
+		return 0;
 }
 
 static bool should_skip_region(struct memblock_type *type,
-- 
2.47.3


