Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49BB5CF2566
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECE86B0029; Tue, 18 Nov 2025 20:26:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79D7F6B0092; Tue, 18 Nov 2025 20:26:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0C36B0098; Tue, 18 Nov 2025 20:26:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB306B0029
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:26:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AAE0140293
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:26:39 +0000 (UTC)
X-FDA: 84125616918.05.4A9E87B
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 54BB9C0002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:26:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Km6iIQi9;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763515597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/k7vekq5uifkJbSVciIjngOCcc9K2Bjv96liQeZ5afs=;
	b=WY9xNLZPHU1wp4gJ7LAeE4oS+iQCDcnpYV6S3g5sBM3HF2+KGpZRni3jyUx+xFP6I3xsBU
	h15/+fEz95YqLSIZFWLsEmB12kwkxulnRKFH1YXGlNX3YnXIZI7AQLQ1yUny+kg+Uqo6fj
	l+HK9zLFT5ZmY1fG/3H+aGHrlrXdGqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763515597; a=rsa-sha256;
	cv=none;
	b=y0+sOcddh/SY2xCFeHuWgZWKVImY3n6nWEX4xwGISCEtNLI0kful/V3n8IJ6MAHcyl37nn
	RLlRvQ7unhzCdFR7y42GqTHNgK0UhduxsdRJYxaYUhp1pdkIEevH+4pjYi7EP6wB0f5Wb9
	csTw49XWEN6fivf8l8OT7Xz/ML3vuNM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Km6iIQi9;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7633027cb2so110166666b.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763515596; x=1764120396; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/k7vekq5uifkJbSVciIjngOCcc9K2Bjv96liQeZ5afs=;
        b=Km6iIQi9uxNFeQx9IIJ5t7iFtnZfhNUeV0t5+9hbPiAwXuOMxbAHbsXV/KwEtL11VV
         G+9Qxrlbg9pHs5xycZKocaZpd9CNDjcvZjnJ1I6XczpG0Hq6T8rQtRN7qwq+uUc1ISPY
         uiQ9pGxeREcoQ8MT520rX4tByTAldia4fQFgJ4NbNb0e6nxfsMwQdHDUijKBpH4HXDgH
         GyvoBqjoGHC/HJEdS/g+GyTA50hfNZARmUh3wIP+3xPxSGql1wAE4IRqdUyOszslTMSQ
         0D+SBYrxAl+d8B7YIXEbb7mnTcpY8S6/w4okODfXssQwF5/yzeCDhvFuzUHbUityDnMY
         Azww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763515596; x=1764120396;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/k7vekq5uifkJbSVciIjngOCcc9K2Bjv96liQeZ5afs=;
        b=HVFlYQpbEi3CIld0+es3PKkOFcnd4s1trj4BI34UsmeB+1sm8mFJR5E0syD7OUAqwx
         498eZkwwEcd/VQizog8fn4Dh0yLW1wGKITVaRbmKNJDw2sO1X3xLNaJRHVLmyqi7MgI4
         pvNWk5qYdb6v57x0xfvhKuPcWhqh4jHP6WAVYbmCrym9rHPP0QiltJkl4E24HdgFK2GJ
         Z07Vpz07kGM2/QBoEAZwrNjCqOXdbHz5lOQmIqK/Qqf/7jFtD1kbMZPa5XgadVTacFxZ
         E6ojNBtMACEDiK5PZzsooL1Fr4RxoyzM3Iuamy0E2PBjwN1FqGagdwCDMnSN+DZU15cM
         y7hg==
X-Gm-Message-State: AOJu0YxowEFnFQTu6bF7YlGDuCV8as2DuKym1Zhadg0gXE6rCCakbDXJ
	eIa4JcE6jhrkkO1u8WpwOcSmpGU98/+YzFDb4JbrO59ESxZ2jfnFZ7XY
X-Gm-Gg: ASbGnctKs23PAUZwFIafhyAW9uzh/nIQqCmD2Wrb7uACGVGJAITpso1mTxkc21qmOc3
	ksC9ZIXNDTaNgv208Wst29Nlk6oWIGbXE3tRdooa7QE8m4dkflSR9M7pLZBdjlDT2WNFB2RSckZ
	48J13pX0iMr6tqNMUtXE6pSOTcZGjNt+JrdusoC+au36u0yoCAb1/qVfVuZSWGeuH9+8QjDduqa
	PtkxCZcGeyNtG4j/E6vDN+G7RW4wTFhXeOjhoPp+7QIN00m9DU4vGZx+tZrwR7rULuPtmnNxFY8
	9Pmz5Q2ja1Avj2vPWz+XwVu7zOkgyYKkXKB5Yjpf3AAw77SfDXaOCXuZmzRs9kVYkDnFwilcguw
	tH/dzeQYyIlXwuLT4cCxwDZw0APS4Ki/g3/1HlmCIqvP76FllYdGQpEvGGrEBtVvCqoytoP+7TW
	AxmCzrgSZGxLHRt1s+mYNVPipLaZrTEQCTyrk=
X-Google-Smtp-Source: AGHT+IFnyktwM+fGRh8zm7gxJxVmJhx+iTUvB4u1iys1ibCwKjNj95d1Xy05vA9leU7Z2ItSgFpyOQ==
X-Received: by 2002:a17:907:6d0b:b0:b73:58b4:1247 with SMTP id a640c23a62f3a-b7367926438mr1903786166b.25.1763515595525;
        Tue, 18 Nov 2025 17:26:35 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fedb91bsm1471579766b.70.2025.11.18.17.26.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Nov 2025 17:26:34 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting shmem folio in swap cache
Date: Wed, 19 Nov 2025 01:26:30 +0000
Message-Id: <20251119012630.14701-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: fy8q9km7w8ap6t61r3hc3351i81kcxk9
X-Rspam-User: 
X-Rspamd-Queue-Id: 54BB9C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1763515597-783021
X-HE-Meta: U2FsdGVkX1/QdG6f+GnCFTi4HlyfGuu2H3mGjBtSUDIMsBPiGWPzPpzNNumzQJAKLGTksg4AfoD9b66n7ydF/i1BiYoQvWL/TartlztRPor5Qg3zepPB5cOKuPwC6FzwYXVAZYorX0F9/Il8xAuYGl/Qr2PCYH+R84G5MaEWgktQvhe6iiPXI3N6DVYxjHNIHJtwC082brfu+IMxMCsDXsYY5SOH4XKxlwRBblk3np++DC00D+BqqcoXNgMfinC7orauXtmPaoKlZ+1d0l+0fT2ub9mLBMtoB3FZI/pGe2opzzgj8mriBuxuP5/hCiZgj9Ts3FPxibgkjiIqe1A1dzZfPZdJF7DwBlAGK02rE5H7+8VqLDbii05icS8CJaOyWhwsYggYZb/hoiDJBHs75oFy7Hs365+BXhtO6Uqnxl0Ak9FFwZJkD1lMkzLI2ddAYhpNBVyLKgPAbMOgLziFl5Y7K+jo4/yhwUNhs2iAFYnkrGkKaCuVVGLHcUG80VuqB7wcPjJ6c/ANMl+imT86Mz33oWjMPJWApDe9NOFoHmHFwhwKshwt37W64Phnj8Ub/yEwZYtLLmv2kAsyLfv64B2sP+qBB82aqjhTP7eN1xiBDdd0Y8sdj3d7bGdUiSuk3QxuRVKhyQqiQpzy3B0ottkPAMS3SFL9cEYAI39jTd8wfCiVrQHY1EQQ5WlppBWiMxjAT1VluglO9mjfTNXQujxwS08YuIfQ0I2WqEPXWiB2g0Ye6dciiNCKnrdbuKU2YwjxdEC5h7VkwKGM/TrACx66Ye71PeWNrtoM1C7bf2y/aM1XFXzV2AgFl1wmC4bSGT4EXQcPi5UmWz6HEajc0Qlzg4MreL1T25ueeSv893yUdZ5W2GSfVkv4lW2OzmMgBzOSyJQyX2RpBGMwF6ANdYa8DSy0I+kgZKbw4QGMt6XJrUREI6vQMG7S5mbHlhAx7vlz6CSV3uiR3o0YXoC
 16qAaQVO
 rN0bggKwRIoiSDQlGXzj+oxgPNJTisClhuX/yuB1IBm/mP48RIFD8Gcof5Zq4EKo5LPUa9bcYYHkLshNe1AunI/+9RpuJu8bUimfH8ORuKXhg1IRl65aRMU/Psvdrm38a2E9gimTbHVXswChwNzUlUEam5B512xBEtQ7ZyGPCueYdcQihBLJcxp3NMsiHkmjFBb3cCy5ABv5L6YvUU8l/u5prmSBpJfhrny0kvoGndOHPIEJUd9UTDOO5kqPJUj5xRrXJq3ZWdZA1T8tJp4hLqG+7HDmTSIuPFY92LCEKOndg/g4qaPmF74zwOGln2C/Gl+l/dv6t2hdLYcn3YutGPyu1/pnpHwRgLbAQwFK2afybz7fTHrgd+5LqEz7f9A0Zmy7zB3kDbemVpf8PjvGFA9avq5W8db9tRuj3NJR227zY/Y0hp3OhxwVyDHHlw+l/0VvEf+ZTaDwSisSPykfGJrgwiLDVQLtd9SKTGgGygluEQLEe8LV+APNFmAfvCK40X8vcn5mtyHkku6tolLhWQIJz51GwaJNwpEbYZGUGm528aAha6IZqEFe1KSDknzcl4m9x9ZGiwBebPbwx/vjtuQ7DyXfTbNtkcMsbURbjdOXD5OMVu/voFIVbEEqtRxQ/JSk25VTEEQmTV+m7SSGXcO0/qz10b6Vz0mAC4gIio+G6VZ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit c010d47f107f ("mm: thp: split huge page to any lower order
pages") introduced an early check on the folio's order via
mapping->flags before proceeding with the split work.

This check introduced a bug: for shmem folios in the swap cache, the
mapping pointer can be NULL. Accessing mapping->flags in this state
leads directly to a NULL pointer dereference.

This commit fixes the issue by moving the check for mapping != NULL
before any attempt to access mapping->flags.

This fix necessarily changes the return value from -EBUSY to -EINVAL
when mapping is NULL. After reviewing current callers, they do not
differentiate between these two error codes, making this change safe.

Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>

---

This patch is based on current mm-new, latest commit:

    056b93566a35 mm/vmalloc: warn only once when vmalloc detect invalid gfp flags

Backport note:

Current code evolved from original commit with following four changes.
We should do proper adjustment respectively on backporting.

commit c010d47f107f609b9f4d6a103b6dfc53889049e9
Author: Zi Yan <ziy@nvidia.com>
Date:   Mon Feb 26 15:55:33 2024 -0500

    mm: thp: split huge page to any lower order pages

commit 6a50c9b512f7734bc356f4bd47885a6f7c98491a
Author: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Date:   Fri Jun 7 17:40:48 2024 +0800

    mm: huge_memory: fix misused mapping_large_folio_support() for anon folios

commit 9b2f764933eb5e3ac9ebba26e3341529219c4401
Author: Zi Yan <ziy@nvidia.com>
Date:   Wed Jan 22 11:19:27 2025 -0500

    mm/huge_memory: allow split shmem large folio to any lower order

commit 58729c04cf1092b87aeef0bf0998c9e2e4771133
Author: Zi Yan <ziy@nvidia.com>
Date:   Fri Mar 7 12:39:57 2025 -0500

    mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
---
 mm/huge_memory.c | 68 +++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7c69572b6c3f..8701c3eef05f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3696,29 +3696,42 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 				"Cannot split to order-1 folio");
 		if (new_order == 1)
 			return false;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
-			VM_WARN_ONCE(warns,
-				"Cannot split file folio to non-0 order");
+	} else {
+		const struct address_space *mapping = folio->mapping;
+
+		/* Truncated ? */
+		/*
+		 * TODO: add support for large shmem folio in swap cache.
+		 * When shmem is in swap cache, mapping is NULL and
+		 * folio_test_swapcache() is true.
+		 */
+		if (!mapping)
 			return false;
+
+		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
+			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+			    !mapping_large_folio_support(folio->mapping)) {
+				/*
+				 * We can always split a folio down to a
+				 * single page (new_order == 0) uniformly.
+				 *
+				 * For any other scenario
+				 *   a) uniform split targeting a large folio
+				 *      (new_order > 0)
+				 *   b) any non-uniform split
+				 * we must confirm that the file system
+				 * supports large folios.
+				 *
+				 * Note that we might still have THPs in such
+				 * mappings, which is created from khugepaged
+				 * when CONFIG_READ_ONLY_THP_FOR_FS is
+				 * enabled. But in that case, the mapping does
+				 * not actually support large folios properly.
+				 */
+				VM_WARN_ONCE(warns,
+					"Cannot split file folio to non-0 order");
+				return false;
+			}
 		}
 	}
 
@@ -3965,17 +3978,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		mapping = folio->mapping;
 
-		/* Truncated ? */
-		/*
-		 * TODO: add support for large shmem folio in swap cache.
-		 * When shmem is in swap cache, mapping is NULL and
-		 * folio_test_swapcache() is true.
-		 */
-		if (!mapping) {
-			ret = -EBUSY;
-			goto out;
-		}
-
 		min_order = mapping_min_folio_order(folio->mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
-- 
2.34.1


