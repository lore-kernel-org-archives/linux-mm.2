Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B0DCD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 13:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08506B0088; Sun,  7 Jun 2026 09:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8F86B008A; Sun,  7 Jun 2026 09:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCEB86B008C; Sun,  7 Jun 2026 09:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C05396B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 09:49:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74596A07EA
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:49:00 +0000 (UTC)
X-FDA: 84853247640.25.71B297E
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73A7020008
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:48:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OwMaglQJ;
	spf=pass (imf03.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780840138;
	b=oU0vxixl0ZrVrfz8zgbBbh/pPDPiksw1d6rayrXqNPA+FyqDquzWUzQi//xIVOyFL30mfg
	s/ucG5kq4NlG0/t5dr/YOO9r2RfAmRCBzvOI+8nRysrxRze4J2MejtxiwRIVmiiQwuPjSm
	h2Fk6JVKzpJLxu4QhbsScP1NdPL31bs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OwMaglQJ;
	spf=pass (imf03.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780840138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0CTxO7Hcxcsa+DE7y8PeV+aprK4GKwNhOSFfFn9fnPw=;
	b=F+Gre7PjM+LK9SM9cU2u7TfL/E1KlIuqLR5bSt9esOxb0KHWC9fHqSWYfWnajv+LDEkM2+
	IRSDty3bSRXW5G/0DlBW2IFJ6WxB5qmcfiVUojABWqNVVdH99DhjgBEZc11/wZpbVxlfo+
	b7OU2FvY/T2WC0EDKJMJjtHvVBBqTs8=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8423f52af13so2456357b3a.2
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 06:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780840137; x=1781444937; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0CTxO7Hcxcsa+DE7y8PeV+aprK4GKwNhOSFfFn9fnPw=;
        b=OwMaglQJMfzyhkdRKznTCxxeyagdSVxHhEKAXx+LppSri2j8bRwzcp07iLZwovX6jB
         i7f/ekocpuXFHUDZu8N+I9itPCiQhjKv3WMVJjvnZzCu/aEsnJScS2BLUtoaRt2trNFZ
         Eq1jV15jOCXXHmjnNXVivtTEaHBLAuEtkH+8pJGoj5hoHuXGkI8yDu1zlLsSbFE/n4jh
         VZpreCMpz2FKs/AgsJQol4WpbP9W9iMPtb7oEpabQeN8i52jNe2ocLyQ5snQTivt3wAK
         hqicG2AaIB5FQI/0K9cEJjd0U1HxMLzBg3/6gPjyPsUcNBQxhl4F/ljSEvjcPRuSzXrs
         uGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780840137; x=1781444937;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CTxO7Hcxcsa+DE7y8PeV+aprK4GKwNhOSFfFn9fnPw=;
        b=VZ1eiW9V688ZPcKf7/f/txlETgdEm+5IQoP6y5H3xxLuxm60pJa2DYkN/P5Yu1f4tF
         5QVMwOuCFvv+MWBSY67tu+7pDNBZ4cS3MDB2ZAZkMHdJUk+jMCdcIrxnTlwyInGokm+q
         0u0pfWTHmKupz5gm9xYEo+4gXZNCB9hdj0qnRgKsabzxdwYlH743bhnkMh9F7un7sjhD
         VQVBzMDdidEf5+dqVu1okcX27TiNY2zFfkVDYVwh0d/ESXg3SDKt9lLJ9tTi0hwfBIV1
         1+GgxAeF4bPdtS2CMrtdOtyf2E9hgNvmCxbPyy4tj+915diFMrfZsU5OP/V6odOJ77tl
         NxAA==
X-Forwarded-Encrypted: i=1; AFNElJ+5q3ySIyM1hQdHNPBa8yBUm4qr8xptE567kQxR7AaHaP/fFpnMgiXvawLwe4kgyQFzwo3ykTGOJw==@kvack.org
X-Gm-Message-State: AOJu0YxC7+FU8m0l5/fXkBdObx1zqQSoIlWxxN+ZQv1DzSMCTaQ1cRq6
	jneNi345X/4pGCZt2opHjeU3kvI52/Y9G1a/1omzbbpKKQeWe8qsBAQ6
X-Gm-Gg: Acq92OFhUS1F0UMkF9gX9AxRlDiLba5QoT0HVFT9MXnOZM3zGqRdGMHtKgC3+E89Xwe
	XJ009wOPug1vGWbx8gw2OrBZjeZu8ABD/7Hl1hgTzzbHSWWDA0O8GcwjsliJd3K80pHnB+wMd3u
	0zReg9HLQ5CR9l6IXkNj1igUR0sqRNUNMA4nkT25hXzG6GfNzitk30+T3QUsdz0GOH+jeUoOmdT
	5OTRdhU6oOMX24chp4wxzthqG5KykRHTBI1ZY+nQKNY7/Pw0dmcnM0DxlytxeoDo6vJieV/ZD8f
	aBk0/6g+BenaRn61ha8aBLwJR6a0U14bTqW9RtPS01zgvSH1wnwG1vgOksO9evijAiZ8jS6RJJx
	evhTYeMLFSOf3/iIK7+zNk2OasnWpGMf58K8ImbsbZvomwS35azAxND3wgGwehlNBb2SOFFs+V6
	YQZCjFs0rbL3qkgxqXjFY5fQfa7KUUnFBUWw==
X-Received: by 2002:a05:6a00:234a:b0:842:7221:dbb8 with SMTP id d2e1a72fcca58-842b0e57474mr10850926b3a.15.1780840137253;
        Sun, 07 Jun 2026 06:48:57 -0700 (PDT)
Received: from [127.0.0.1] ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282918b8csm14365235b3a.57.2026.06.07.06.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 06:48:56 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
Date: Sun, 07 Jun 2026 21:48:52 +0800
Subject: [PATCH] mm/damon/vaddr: drop redundant mmap_read_lock from
 damon_va_three_regions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260607-rcu-v1-1-3c9f5995a3a0@gmail.com>
X-B4-Tracking: v=1; b=H4sIAMN2JWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDMwNz3aLkUl0jkyRjI5NUgzQDczMloMqCotS0zAqwKdGxtbUAK8Q7fFU
 AAAA=
X-Change-ID: 20260607-rcu-24b324e0f076
To: SeongJae Park <sj@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cunlong Li <shenxiaogll@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780840135; l=1761;
 i=shenxiaogll@gmail.com; s=20260517; h=from:subject:message-id;
 bh=Cvgq6hNpp3pN4v1ssOQj4C8t60KcXC1VRT5noQtt7FQ=;
 b=PejStRa7IarY8QPXkGy/Nf155AyVFmcMEsGQmhZELK5FxMOFhB4kAhKN2VHYFQy/+DFy14J/h
 Ao3Po6T9PcuAN5TahK0z1kybF+HmDYUawk7HaxWMBHIsKnPC8I8s9P/
X-Developer-Key: i=shenxiaogll@gmail.com; a=ed25519;
 pk=SKFifnqPdsvsjuhUiq+Y9vtCdhyZ/LrRcfYn8eRq6AE=
X-Rspamd-Queue-Id: 73A7020008
X-Stat-Signature: at6u495ryg4xdp1877fd7h1kfbzd88ir
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780840138-744072
X-HE-Meta: U2FsdGVkX18qsJlMjeQXjIYFz1tB8rFKAb422vRDIuEIeYs5/6NPSl2GZp+gWIPxZZ8VrmXlvWSiGz8sqbw34l7DTLHfNqnlQjuCj1x7PE9bPr8PUZVTPzQK2r1cxnwvGZl09Q39NipdL5iAwBxneKXcAogkN8E6HfP57VeasJWI0lQt7/hSpUGkfK4dabTFOfuiN2Lgdg1EecJuwKY8mnTCYQlLQ5Ps5xl2E56BB68QPvuIIRIyFDlCb13QOqlCi8ysIVSWsP2awDiIRf4ED9K4bfeRITgiGwMRU4Rlhl/RCZKWDBTRvcyHBGsZu6tS+rmKEm6a9EHptYu+8R8FyirZjyB5xc7oxIhNWcjqctx18Rzn3AcK5s44d3QF4VgzPm06VPdbxpsxh5zlYrEdCHNWERgTGga5j3/dTQdvSTtzy1b1BOYHFj4TnqM56sTpSCiUdbi8ybr3nKnfn+YKQR8b35tBYq1B8Xx5Rhr+mrR2nvsH+lbRiAxMPxLsKGpGmh3bfbof/UsGuxMNNgKDsVbugjIK8TKlr/nij9WVI8TJadRwMRM0iIl382lj0apw00GuuHQPe5rtXPXDj2VQFjfvYWhZvnFjAeyM/CH1VAPHXje44qnYvjwrcU4hNCGHJLISL2palQ5yVjm3H+hyV3tO7faDS67JByWLQVqDsOn7+fXE/+NSL5ZzCR8JpV0ZwZsT0Dyd4kQ4CjB2lC3LCPcMkwj+KmjDS/aUHLgcdzxArguUx9LUlNjT58T/UvKo1eLmWD+kToqPsYlO94AQIhEiFoJinCl5jlvLOWiQpeFB0kgUqYtTkCt9kRPkP+UA6T3FgmTFAxuef1260p1GKh/nBv4RmjZ4ReX15KITtXu1xghFkneK7MvSnfHIU4Z6jHDiIUQfOZzUpf0Gn2goUv28MOhOT0XTQm4eW/up/iU3iznX4AS1XjOoM6CAowv5DfB6eFbTcstXLB19w0J
 RlPmid8k
 PHGXLRc8pKRJXP8TEzh2MokEgUOdcU1P82VYXreKLhe9JE/5sYU8W/oWtHcOdfJR6N7D/zPgdu6hvF3boMlTZ/M/D/YP8QDMx0VzbiZN+NwlqQw8FXJH30VG7QzAM0Rlv9gI0JPaoA+QoKQf99DSUmVF0USqtI7JhQTQxsw7w8Lr93IllguSHletmP3FFEWPz0F+01vFciIWLuxU6wzfuJO0kS9ipV1oVlOYZPgiV37cKeLTPoD9KoatE48UJdgxGLAtqvRPr1kOHYgIafBDgU/7/pME3c8Eyegdck6H8q2BDEEequ70TUjITX924gEYM7J9X9KJT6Wqd8MOSMDnRO3sjEVWuneQddiqTWk1IFqcpbqLenV0FeWNvFfR2xQqSkq4kvkAenAm+Q/Aidg2CAh9A/dwCVLOPEXPg7ouGicC+g4Q95XO3CA4FAdVVju0T3g6CZaNC3AaR63RWVM4sqdwiW7hgeKuPBJuAcOcfAX2uDDvQDFCncQ1YSRkabNFk1LIkZYYoK5zr3Y4loBX10YEEz9VJ+TaaN09nx5WGbekG0SzAgDVREwcbhcCXhN/IqGXpaNDP7zMf5SFtK33jSgQAJPtY8wsqmScm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__damon_va_three_regions() already walks VMAs under rcu_read_lock(), so
the outer mmap_read_lock() is no longer needed.

---
Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
---
 mm/damon/vaddr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b069dbc7e3d2..27e34596c43b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -77,7 +77,7 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 	struct damon_addr_range first_gap = {0}, second_gap = {0};
 	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *vma, *prev = NULL;
-	unsigned long start;
+	unsigned long start = 0, last_vma_end = 0;
 
 	/*
 	 * Find the two biggest gaps so that first_gap > second_gap > others.
@@ -104,6 +104,7 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 		}
 next:
 		prev = vma;
+		last_vma_end = vma->vm_end;
 	}
 	rcu_read_unlock();
 
@@ -120,7 +121,7 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION_SZ);
 	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION_SZ);
 	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION_SZ);
-	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION_SZ);
+	regions[2].end = ALIGN(last_vma_end, DAMON_MIN_REGION_SZ);
 
 	return 0;
 }
@@ -140,9 +141,7 @@ static int damon_va_three_regions(struct damon_target *t,
 	if (!mm)
 		return -EINVAL;
 
-	mmap_read_lock(mm);
 	rc = __damon_va_three_regions(mm, regions);
-	mmap_read_unlock(mm);
 
 	mmput(mm);
 	return rc;

---
base-commit: 8e65320d91cdc3b241d4b94855c88459b91abf66
change-id: 20260607-rcu-24b324e0f076

Best regards,
-- 
Cunlong Li <shenxiaogll@gmail.com>


