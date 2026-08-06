Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF5DC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7742A6B00B5; Thu,  6 Aug 2026 05:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B576B00B8; Thu,  6 Aug 2026 05:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661776B00B9; Thu,  6 Aug 2026 05:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 415196B00B5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:37:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C676D1606EC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:37:11 +0000 (UTC)
X-FDA: 85070341062.01.57372CA
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 01E0F40003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:37:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F52JlNwG;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786009030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uyTtFjVVo4Ow+xxdf9JzDuHeX18HS+OnizMa+EN8GU=;
	b=YsX2Ct+6k9sNGWSi5hBB/2QvHW/CaLhFZ3Vlhb72phmfu0L+GkDPPDDNBZ2ILATwbLL4Zj
	+mBbkGrmUEMMP9qLPIStxPnoLX81ZIGerY3Mrur1RaZDz5a3KxlYDfd2paFViG5SuSe0YD
	UtDmyas5kymUGPm16ZvyrhkBhvEf7Kk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F52JlNwG;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786009030;
	b=WEiyZNWgkyMKH3h2kMgQLrq08a5iCiYN7mb2ihY8UgbAYKjJj231b8bWEBljVBzWO2YjIx
	UuTvLp938cqx2LxVk2Eb1EjYjC/D2eWmlFJtxDbvjoqZVIMa6g+oRbiE+3Fw3+YizjSdMY
	rtYQ2VGxBsvgNc9JcpDD9lucbQEVxg4=
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ca4f02483cso1898165ad.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786009029; x=1786613829; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6uyTtFjVVo4Ow+xxdf9JzDuHeX18HS+OnizMa+EN8GU=;
        b=F52JlNwGS4KOFVlTFfJ8I4L9MMk9gNl1q128X3Qs8JllXC4UfoLxfJRSCvqK0Kn4lc
         jIWmPCTHjgZa5LxUaQvpwxQ4ZXpsxUOo+iePO6QRVwCAAnpAp42brH0LmdsHXqqTvD76
         kZlU585YAzTy9QXcDKBP/lp+akeF3OOAusA2TtqmbD3qgUSxEQxI6ASsamdfSmD+O84c
         MdyPlDywKvGcM0DSTtHZRYKKQcS3X+vkNauMTPy0WmMQ8NsA/wgLhX9k3aV4YWMADdy6
         syPRrynzwADjjRG1JsqCdWMtW5o0XBuFiwwoPQWFOkEp5RszceBC/qyPEPyLeI0I0HA7
         y4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786009029; x=1786613829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6uyTtFjVVo4Ow+xxdf9JzDuHeX18HS+OnizMa+EN8GU=;
        b=JIWmEQeF1Cn0AfGDKOPvhxM1aDf3fW286O8CdtmTAdXLbM875CRK/BHH4L8EM+uWP9
         uuLTz37nllHdKQdWCnPR2XB3mIya51tDUpo34tMCPVnrsDWJK5ovq+MCjSL+2sTGulcI
         f7f+QvBR/WnGc3nfKMzfpSQ/vklsoJQhcruNoNZY9uMaJCvSeF1MT/1IorI0z9F+0iFK
         SKO7crROunhRNl/Mbv648p30Axi/10axI4fPMo8k3zEJ0vre/cWU60i7Emez4jc8a+y/
         k205aoqNUao+3088MNG3yJ419iTNwyFCGdzaHtI/TqZhlNEF6zv4h/tiuimKHecVXxlx
         SAug==
X-Forwarded-Encrypted: i=1; AHgh+RqWGN36lVSewoohFtSuA+7iaQZCiqQSfQO+lhC7DPudztaX02dxhVOo4ZDzFmAULDQf0neu7qG4iQ==@kvack.org
X-Gm-Message-State: AOJu0YwSY7wOu3oJyb5BaQd8Szs+JaZLTmBSDgxX6JySNoGcHCsO9p6Q
	aonuH7NEQfaYYz92cB4mp+A1mXIlH2lwG6oaXgS2ojmyU1xYLueLRn67xydIdLLvexPvVw==
X-Gm-Gg: AR+sD10PxaKvR2KjqfuYTCgAIY/RzTGVE0mUwVpkobbKzhkmbAXvYO4NOoC5YjwNGgM
	V03uNIkEJNMf81HsbW1UiUyK4x/JFzqsQsnj5F/WK/yBzjhfwFE0roZPNKLvQM8TC3UhjDnGx1h
	mSjQOgU0q+udeld7wXK/Qoqg+w3bLBsSGN1qVBSCGwOG0+vZaaFOQWu/dkfAIiGLqt4KYPQ6V+P
	niZEf0yrXZKa7XoPW20zldimO7QVlTncBYSe39MeWpshqqYtLnrra9+rd5vlO0re4Yxq4zw3P5G
	MGnSTNooAvNx5NHyySql9LiWxXpRJzKjt4iMLY9RtdfRWwaHRpVFGxRvNVAvSP03JUYpaqMtnaV
	QN4754QJ7WmVOmIpCA4CxG8VTp6rJMDvnBOXBDS/XMJ1JH5dpv7A1WXslCrfcLXvconskj/3ObR
	k71IaHmcI46slJ5ksYOZ1fO2Uax9/5gTfdVCKboiWFLkql7fcB7HHt8fmnbERg1qMerlqqLKVVO
	g==
X-Received: by 2002:a05:6a00:464f:b0:846:5d1f:56d4 with SMTP id d2e1a72fcca58-84f47dd0b44mr3119262b3a.14.1786009028817;
        Thu, 06 Aug 2026 02:37:08 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:37:08 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	iommu@lists.linux.dev
Cc: kernel@xen0n.name,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com
Subject: [PATCH v5 8/8] crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF header
Date: Thu,  6 Aug 2026 17:35:19 +0800
Message-ID: <20260806093519.2907771-9-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
References: <20260806093519.2907771-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 01E0F40003
X-Stat-Signature: c6mhxuot1qfjw5hi79mx1a1njqezpuez
X-HE-Tag: 1786009029-599064
X-HE-Meta: U2FsdGVkX18ER3UPwfBlftPsYAwj4kzUn7E5r1OO/eF7bmQGVXu6raD2x75WB4uP371teGFujsOqhriJN7cIrPEHEdJC+SKNGhVnU3kX1+K5cvyZR6tHdDXX60BBCdnpkNJPz27HzWVbl28HfkFFHcNK1gAWY/TzdX1T6HiG+f7kcQu0RdDrZFBzFC8Uoid1cf0XuOhOgfwjKDo9vzDKT/M2QPFgWBaoDzFXEzD4RElrcBIRlVWQ87WuH0MePkfLIt1hDv89rGGO/iDGTt+3i4/Aj4Tyf5z/B3woZXyciXLQ/iZ2WpUNVGAtUsU0tfPmy5Z9906PMKi+XEtbqRQ3L5eoe1LZDFQR48S1DGh22MxhCqBMOKqNvOoqSAHwomAKB+Yy04AogQMYkzX4K8uU62WGbP/+M3wKlJ8zVadhR+MlCWfnNOmxBm2DwpVaXlMNQMjNlNFgNenpvX5K+LLzew4w/PmP+h3483xQzbd6AH3C5g3cWitb284fZs5AJmBf7njGYbM2ZcfABFoN0C1Jnq/axcoPaal/3PbVLg5pgisEsbHTbFEtscz9XjZmHT//bcc0t+A2ONKE44aMO9hNQQwqtzVntpkG0fvQUr00Nnp26jJFmZLyIinlRbf8SOTYErmA8uanvo5UhhpRF/hC7J/qYiO8elYHdN2q2sWwJiLAZfUE6v0xJhuqeFj9nPENv9Siaitcl6mH+kgJmppqwf/1ddDW7tg3tmYvxhn6WXai3MA86/sKrAu6Xx9adbKYmem/1e8FLoEyGv84Yy4RUxV34r3kQf4gM9FWwQDk4ASGRRyKixtweHD+s7RQpGEuJPsOPcA1SN1JW5go4Uu4wcGQDYbW53o9VLIJ8CRFHE0h5Z7wPa3xzpfjr9jgX/eEih3c8L3nC00OU7Ft93uRYalBLOEXVjncMvZ9waiMfhwc717WsRvD3qEchLn4BHRdHf6oZEKUY44xCYqLozA
 UI7Rf132
 MJjb+X02PwditBHrMxn16KGm5eugC86Na6OFmUi3w3b43KJWluqY1BRWwt8PGw0lmdIV9XyAWtz7l4dipPVhpiJzm+dPPY/G0V9EaECh9UmhbucKRmdTwQWpz56PG0/1XWcd94KMbYoYYvK6gS8M9oMbOC53coKBlffr5E2iKKvjayXoP3OEbZDAgw0Cv6c0agbUNSjqpao0INb0IOiMU8/nB17w0xBHTs2CPzH4stBR90ZieChwneM5S8oeSQNgMNPymqNQ1tS9vK5fPQM9xqili+ZW8J9CdFlthq+DwK9ao9GZbxTGUpskBANwaX0NtYnSSI02Rhp3BMCkh7I4bDFHfL4sadtXH9TTJDw3BIYP1Iv2DS4fynzkFDbhxSUWrPIttzgHVlvcXXM1QFEjR7jaLLrnHsu13+ZB671g15/ipDvdfLdbR1YyuIUt1KAFQGk2E9wngWodnAkaJQJyYfP92ir6JyKvsiILYd0jGWKrmRXhb48mdBXO3towsMKPkIxbp/+4U6DqFq6dkzcd43Q2gUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Reserve regions (for GPU, DSP, ...) carry no data useful for crash
analysis. Exclude MEMBLOCK_NODUMP regions from the vmcore ELF header to
reduce vmcore size and capture time. crash_should_skip_region() now also
returns true for MEMBLOCK_NODUMP.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 kernel/crash_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index fb78b7814f18..8cc9d666bc54 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -269,10 +269,10 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	return 0;
 }
 
-/* Exclude NOMAP regions from the vmcore. */
+/* Exclude NOMAP and NODUMP regions from the vmcore. */
 static bool crash_should_skip_region(struct memblock_region *reg)
 {
-	return memblock_is_nomap(reg);
+	return memblock_is_nomap(reg) || memblock_is_nodump(reg);
 }
 
 static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
-- 
2.43.0


