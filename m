Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7ED6EA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 14:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4916B030F; Sun, 19 Apr 2026 10:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E986B0310; Sun, 19 Apr 2026 10:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26436B0311; Sun, 19 Apr 2026 10:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD6BB6B030F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 10:42:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48A4E140794
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:42:39 +0000 (UTC)
X-FDA: 84675571638.24.5D9300D
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F7F714000E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:42:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H1Q8uWCi;
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776609757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gvwSIdjzLn08bf0cdv04r+WmM6FAXZRg8ULoiDHaA5g=;
	b=ntHFmuvivCiCkm5NwZ/3XVcVj08hmx/uDRhitYK8G+ke5LLKmU7dQlmjYs5wmk/BizWUFu
	JlKwzt6Oa/MxF4DddiLgoNk0ZDLjA0qcsXtpnX8FKqzGSMpGRJNlH/p+1yBDgKmnWeRZfE
	CER8QAP1stVfvuGVV8FJ40uhO6xIMf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776609757; a=rsa-sha256;
	cv=none;
	b=CP80TG7xS49NVtxqtHzOs33Gph7F9wUv2Q8O3fk65je4eN6orrOxrw68Ag8XiGsMy6K3W4
	clqYX1ws1CLNxmAwIMU7BrMHeT8hkorVistsmbUzOXKTiTjSwrqCP4oqMGrJiORPC9hZNj
	f02lh07NTmUBuMZG5LZUTzRObDkAuyY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H1Q8uWCi;
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b24fdac394so20849095ad.3
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 07:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776609756; x=1777214556; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gvwSIdjzLn08bf0cdv04r+WmM6FAXZRg8ULoiDHaA5g=;
        b=H1Q8uWCivDKGMDlA87MvjAQ7t7kQVtXqnRkye479ZE5ef2c+rOwzTVa0s7mM16ovAK
         C+Lg21IzWAdt6DTjXBDANXvyiP97VkojqyHh9uSlF4T2N3FwLqYdtYLOzHZqFc/xZx8l
         gXy7MaU9nzuhCSE0t1HUKVketmYSs5FNHHLza+Xa60nolCQNOJ0S/83jyi5LSOHdIWlq
         hxv6Gu+cXBSx0gbPLLdaZyFXaXN3rC0byVLO6Ko3C0BXAYEBuc4gnPrKEpr1q63ZiNWl
         rMIbR0nxmwPo3JRJBBG201nqN/e2EeVOESqlJcRxvlJCKNKyWaNxFlp4ES9EyQ4L3xlN
         EhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776609756; x=1777214556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvwSIdjzLn08bf0cdv04r+WmM6FAXZRg8ULoiDHaA5g=;
        b=ELji+mzifEF43Ij39ccwYyTRsEEqcSfsfcZUNdMKdvkMwe/Yhk0slQy+wwonAH/kX9
         0wSzF35tzl2VtX7MkdDdbLTrmLCJrl9+T2y28gzEa/Y5KVvE2Qhug6fU5dxWewir6WhX
         bF8rYWUDqt9NGpY4dwMXDAntWKzwLM8dmbinwGSSkolP+bku2oj9ncNUknOC4ZcKoN7Z
         JAOY7opi8YbQHgDhYssEx221+Q6i0ATLy8L0kAQveR3pxXVar4i2IVHIybsA2dXdE/pE
         JIuSnHTnRr9QqLBwDwsm/A8P0qAX7vyXyXYhnMeNRGG3S5NuHABzpaS+HCywdfYeXG67
         qw9w==
X-Gm-Message-State: AOJu0YxEys+xD5j6Ns7rLRg9UhNpvSlCtR1/2EEYLfr2t3RXdrufNl59
	4aUdd7wZfcPgp3rNqxffY3hp6mO5MpoVgv8KSV+iw5uvrSH31TMwszfv
X-Gm-Gg: AeBDietOfmKrNtmeWvB7CeBctKIjzZdZYLoWVPzKCR1uhvjdXgRxgC8zHWqz8EX2Ijq
	jU8NH4A1gltLt6iy4L8aY3NtEyS6znn7xh179lkEaWvdklKb9HB+q3dfaRg9wyHpTVFNZWQUV4E
	sXuNuKY/Iyr2zoRKk0T0pRTfWt2OKbT8yaOvfwYwG/6BvXlpglwObE+S6Je/Gnz8cmmYR3n2tkX
	YopGhC+wwvgRlBG1xHmJx9DQgs07rpiPcL5Lg6a3MYkrE9zHoLkpvhP5e6+V4bH8DvxfvpKKHAd
	1m4bbakJRb1auZrBoBLooVX1b9YZ1K0Ap5leuBYuJAABOH/SvBrK5Q4/3MHb7+JK6CsVKfyai4H
	12EItY1BpDaHAP+AWADM3HsUNFh39FSXBR4A5Uimglg+EhVbyGLV/Its551BNiQvMj1E90czRLp
	vkDIe4PLZBjoG6fRFhswogKgl45Bmc
X-Received: by 2002:a17:902:e746:b0:2b2:42da:25c4 with SMTP id d9443c01a7336-2b5f9ef6877mr121363365ad.14.1776609756235;
        Sun, 19 Apr 2026 07:42:36 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa17632sm77625145ad.24.2026.04.19.07.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 07:42:35 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] mm/sparse: remove unnecessary NULL check before allocating mem_section
Date: Sun, 19 Apr 2026 23:42:25 +0900
Message-ID: <20260419144225.2875654-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F7F714000E
X-Rspamd-Server: rspam07
X-Stat-Signature: np6deypg1urxphr8d4nuw4tteqipud8w
X-Rspam-User: 
X-HE-Tag: 1776609757-159097
X-HE-Meta: U2FsdGVkX1+NfKRL7E37SS4HNKfpxh/yqo0GqzPQVI4jksDrT58Fhvp5pZKz6PX2Lna5vHx3iJVNeRoU2nhOBYaJLilEi/FYJdyGCg8BhP9Yuw9XAHHtDainDtpgR64ymzCgnaODHJN75zoRGf4TNnJMhIZb31Y0z/YSw29NliayPCyqDMGcZ3MrJGh07xeqYcU+RwEZolIXP0IzKAa+SLYeL5p1wOtp8HhcCB2UYJe9QngsY1dPGyZLoAxEVVUsPYxDYeJgXn2f9UTFXQhnqilbwxT8ez1uEt8kAzJIP66rkpgP1JVd2eja0oO23PcO+Kpt2ubpvHLVb7xpoEW4E+FVGSgYcGiiRRSPduRfNWj0EqpSkVs7X39BD6AM/9fMSDzeCnQY0OylJogk/GxchbgJfkhzneAkS+BkRZd2c2HqpDzON8Ro109QojYvUPnFHzeRv1a+4Pit5t/M5n4NsawFWPWqPaKfSoVssWzizW/aKIqRbTfqw1ZnteuWzaoR0EsoNkF6ku5YzsHU/hVcBd3LzqdoP9Q37r2U2US1ZNyuh1tuLX/rOvmvtxZtyyhLVhz2egxc7Rx0tPByg38HUqX3VQTak1xdddd/scufnIgty+Yjnv4goLtodG7gavU1XZdQ+I1oWKxv53rPNcOLN7LrpwWfYr94oJb5WeifrpG/JPj5zZm4ietgAi8f/AZwrbcFs2P93TMr1UVYPjQyNO3DOcOURGhbBXxDk8BntwaNlfgdgkNG6TJJkboMRMc3/ueqtrLGWr5l/E2LWpl+u+6YmF9EuybYlHPblDCjEJ5V3FX3Zdls4R4HNXhdXHpGW9+0lAHtm5LqebpZ9gCFMHSs9GbIRdoduPQBFfzx9oEdQG0rlFo/ta6Rj68d87vpLc94FmDdwtByfRQ1rGq4lQl8aea+4OrqRHvCqd76gWLQ8XWDRio/DLl3BCiMy3qJ8pNLIkxLay9/DCDESsW
 KZIvgOoo
 1oVvYcrlcvJxlLgKTW8vZcXD8WrTEZRnVLQHuiHoIREE96RilUA13+W0D5Th4Qtq+VMC0jLXbbVtwuGO1aZgrU7Q6K7GFSGyNlHRU9fVNfj9Ycbss7TVWHQUlZ2HizX5NWRWNpwYUUjAC1Du/pDKjcpa5QeyuvKF4TDTMzOPv1SENVDGuBUCH2VTC/b2UCGUc5e4Qhxyur/xrsaTjYgUPZ0gTLsKPYSFCbKilMoVMoXnH7jxtf+PCsXuWz+DknnBYO6PHlbKTKa7b0th7iiOEDIn0PXgHqS8LQPdB944HXSu6C6o7lgJPQgOfw8OjoytM9etWlkR7RxlURlIuZZBr4To28BArseW85+f6/lxxUA+NHYbkKH0PhAkni0hMDLn9vgFRCHUWefX6DfvNcz/dvC2OV1qKH280EX58JkNRyB9wAew94ZO5dpKMaZDt99URhf8OAe6KmkDiElQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 850ed20539a4 ("mm: move array mem_section init code out
of memory_present()") moved mem_section allocation logic
into memblocks_present().

Before that move, memory_present() could be called multiple times, so
unlikely() matched the common case, where most calls found mem_section
already allocated.

After that move, memblocks_present() is called exactly once from
sparse_init(). Under CONFIG_SPARSEMEM_EXTREME, mem_section is always
NULL when it is called.

So remove unnecessary NULL check before allocating mem_section. No
functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Hello, 

While looking into boot information, I found a minor enhancement point.
If I misunderstood anything, please feel free to let me know.

Thank you for taking valuable time to review this work.

Best Regards,
Sang-Heon Jeon
---
 mm/sparse.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index effdac6b0ab1..e13f9f5fa090 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -201,13 +201,11 @@ static void __init memblocks_present(void)
 	int i, nid;
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (unlikely(!mem_section)) {
-		unsigned long size, align;
+	unsigned long size, align;
 
-		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
-		align = 1 << (INTERNODE_CACHE_SHIFT);
-		mem_section = memblock_alloc_or_panic(size, align);
-	}
+	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
+	align = 1 << (INTERNODE_CACHE_SHIFT);
+	mem_section = memblock_alloc_or_panic(size, align);
 #endif
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
-- 
2.43.0


