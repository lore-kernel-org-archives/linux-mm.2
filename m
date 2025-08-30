Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E99CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 02:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB196B0026; Fri, 29 Aug 2025 22:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46BFE6B0029; Fri, 29 Aug 2025 22:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8E56B002A; Fri, 29 Aug 2025 22:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 276656B0026
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:31:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6816119C7B
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:31:41 +0000 (UTC)
X-FDA: 83831848002.09.EBC3250
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0DF8740002
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:31:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i8FUGNnZ;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756521100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=8aGXXFM8I2ro06weOG3Bjb7Vl3YlyKeRZk613DsglMg=;
	b=53RB3imLBynoq3GhcycVSQ1Q9UJM/1lt6p1aH9oD3x4INiwQo2XAQcjMSa6Gs7BbfZntau
	eSJBT0tQHa55Mvh4H+g1b9JlGYzAaM4jhRnQL39Xl8ubqB8m2GcO1EsU/xL23O8QSWAzPJ
	8qTdCYbpVYUrz3j20JuMuj2NgdlPGh0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i8FUGNnZ;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756521100; a=rsa-sha256;
	cv=none;
	b=qy8PW+wZ0zGnhdzhkHcCzI7p0j9bdffwS/z0XqXBz8fTuVuKhEOhWaz1kuU/uLELnnJcRP
	WXzQOxtrnmcFcYUw9gv6Ry7B7R+PiCxDRGg1b8zUd+r2fyEY+GD+RdbRdV2FVU0EDq/R4D
	1vtkjQF8Y9EiCLhOqdi2t0kkvaNtl+E=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afcb72d51dcso398596666b.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756521098; x=1757125898; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aGXXFM8I2ro06weOG3Bjb7Vl3YlyKeRZk613DsglMg=;
        b=i8FUGNnZbG5BhLRuWKkP0n6i2LIh493fRadNVzJr3DLVH7SRYhRJdYTD5zow/o+vT2
         OwyKEQjzOctxikmc6aRmBFZy/35O2ZjQfU1Za3q9E+ONlXNGpzePcttPsQoQmLrVOCPC
         fKFtuYC14rO4QsgQiA6JK89C6iM5Hquw5HLf23MrEDWuk+Nj6Ct0+fE174IqJtODKD0c
         xJB+8bTb98siV3yhRjZKMrbF+XElp+q2vfR8Dt0O4cPiBflN9lZLXEev3+eCKnJ80yvb
         JWczD+ymNAB4v5/IGElYFMrZHUE6MHevWqNKQVRwRsW6rFsC8Y+LR/1RkvV2uRMX/QyD
         i2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756521098; x=1757125898;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aGXXFM8I2ro06weOG3Bjb7Vl3YlyKeRZk613DsglMg=;
        b=AqXAyZKd90BSD4zlciynjgHyxE0E/ZDnEphvTcEFUbx/Wu+r8Wdvf/mli3HC6C6iGw
         /cxYQQNtGTcQcDkhIo6lwfVjdGtANrtuNg8PdsS2iUThYVVDIbc0lHeB7Up6Tfho5GuJ
         bhTe32OgX2uVVQ+EkzKs0s2ho4Us8M3lWt04OjFxKRRK9AFFyXVwUld0xos/LGatgtP9
         Xr/7C5lwYMWu/FT07NQMfEyGE13QIAbPnDuUnr5pKlSt7lE5n3jD9k+dB8AKHHVrmvRi
         AkNPnyTsI9pHEL4nZ7YP55XWiMHhsIsT+JBD483kgUYGRI/c7cTL/K5n49lmmPYS6qS7
         vJXQ==
X-Gm-Message-State: AOJu0YxePnqTWtxgZ9wos84ghOA5NCTc7sQtdVrcOvUlVQOssyWxvbxb
	GcLPvA46mCQb2DMjqKp3DNQM/ROwIhhNRQ3m/PjmfhUVQF7a7dL9TzYf
X-Gm-Gg: ASbGncsw0QbaqS4u9r5qMjcrljeAwAFWF2gN91IMiInYeCgDhy/ZraPfXFD/R/Nngeu
	cTvSp8LdIo9GlNwFbdHqIxAYHxxhgrq9Kz2fCZVpHXlJu1QQ1xWBVPhTywbCsI+o1ODP8cUWwHe
	pd3d4peecHuEft0W82TkyS91RprqER/HcTGeSmi4P1yYZhtN2uEKkMJWacpYGj0Gm8r8QTY2ViL
	FM8jmKtk3VpjBHfl8yw8wI1zYPXkWX1ErOwdznigMgLt335o7n0Le/bGmW/XWKfxdWjTb//TY8c
	OXo0gQi6HC+sP7wxkLynlBCyeCbwZfpi2InT9WnYWa4FqdDGr5UOg7rWSbehftcqJxxjV5e2gEI
	CH5ix3e7+OPUaKStCnwiAplfYIw==
X-Google-Smtp-Source: AGHT+IEcG/Nz2DmWzxZFbED+CA68DsmCKn2JGjG4o8z1waVfBDDUrhiW98uMhJp3Uel99HOsAPYJwQ==
X-Received: by 2002:a17:907:1c01:b0:adb:45eb:7d0b with SMTP id a640c23a62f3a-b01d8a73360mr67095866b.15.1756521098386;
        Fri, 29 Aug 2025 19:31:38 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcc2bd8esm321428466b.85.2025.08.29.19.31.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Aug 2025 19:31:38 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] selftests/mm: directly add pagesize instead of increase until page size
Date: Sat, 30 Aug 2025 02:31:02 +0000
Message-Id: <20250830023102.14981-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0DF8740002
X-Stat-Signature: rn4ksqq3t7jten1ix4m5mjrf1bus1xkc
X-Rspam-User: 
X-HE-Tag: 1756521099-522766
X-HE-Meta: U2FsdGVkX1/S+O1fvipWspFKPTILjerGh/aG+IaW3F3kTpwtsqfbNRIuLaHIRcof4Uc5YoePYbghv5MeIX/ixwrH0Q+wjXz0W7f9/E4NKJUth+u3dqMIOMMpXXHbYezPvBWpANjPCcwL7bmgWUln7BfwjL4hLmcn/leBksAEvZUYysTEbEE8FjPk807FatGM+Q7hWsl82wvZTLX0DYUen4khLxlD3xxFyL/GNjzJcnaRg99nNTC++IFBixHJ1WdHd/nSR/k64a5MTqbX/s0CwwHzo2cJDDuMvtW7B6Z4LqWoClqDJy7E/KjlMX4tzL48YecdZksXEaaW7ikFLGFYkjDAjoopzV2ZBGZKKwzRHU2cJlL3DaLsaxrS8/kcHryzgsQxHQFYBWtDKfpizP7JmUt/ua8D+TD6dDvTsfsRvYApIwX791HRTM1aK2hr8rgpyEg4eSBskrinEHNjRQwy6wQmZb+9eA9D8/T0FqoWDUBSsU1e2n7OmwtyHpaY7T80/9+hOAsIjIo3e5AHN+Yul2IeHrDXo9KymFxb9wq9vrgPGkY+BVc/k5KtqsmkWpENVbHL2faI6GSCs425Q5No1wQmJ2/C5mzbGoWgbJEzkSsJdClfbAJOtYbl6l7/Z8zGkjrP56nX3EE1JscLOuDnEKxZgs8F7XkyYApBC6+SjdwUdfMmu5ZnHvVN9TEyI/vy/H+Y8u/Fku8G1wee+by/YL3kHlVntIpygpBiXDeKdo5zHHedOJ050E4+q5oVdJMDkz5CsJMFNJTsKANZrL9tzI6BtMzm9dU0juvDKNhyHyizCbEXefjuiW+RFXUq2AjQWdMPTGEdRZkDTIA0MO4WqMe4Mf1+1juWDmFeazJSx7WWQMGVpSyiu6t8T9ax5hMdHGNrg+XbIGETCe/UKTTyRJXR4V9AsWf5D3AO7QUsnoaY7BN/6o5uiBqNK/IN8/N9w9oZAJx+YVwutoLpqqN
 z/oL4Oun
 +6RTjeuTJEg6fC/8rR7jJTV0v8xmoJkCrfIo3Rn2Ao06GdpbY2JqrwkbfzAJH11+ObTFWTVZu/++LrwTgE9HSXmvn2DsHe/yRhGyzZ06goLejcWZ1j9ZUEExzQu4IQYpFTOOckhKo7LJoPGrjRuy8hYvKIE+m74lCSkll67m3Wy+w2dPypqCmzD5UTMCEjXJBb9CvZWK7kZMvk95KSDEI9G7506QQGtDxiibXGN0QFSLYbEH147Ltb0qtMGbXghZf69/Hk1qXbt+ER9fZqOnZvubI9b4QbO+KQSZv7uDxpeWfHR175fpvb9kBqQd04qIEPYNjcRZQVmRT1WOEMI2hyOLfUT1WGhMavYW765VQ9FyXin3EzX7QWeC4J8lm43vQgwn3FcahGd9yl+FrThw9phDU0Mcp6izl6HSF3A7ZpWEepS9NUzQt5UYNqiaL92mfsZ1RRdpcbbhhUDsfVPEKd5RwyLuqaT1tnvN+jYlalFx4vvbNGE8bdE10ykEMqL/vwDRgAcEqsxRTIeY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The check of is_backed_by_folio() is done on each page.

Directly move pointer to next page instead of increase one and check if
it is page size aligned.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 10ae65ea032f..7f7016ba4054 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -423,9 +423,8 @@ static void split_pte_mapped_thp(void)
 
 	/* smap does not show THPs after mremap, use kpageflags instead */
 	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++)
-		if (i % pagesize == 0 &&
-		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
+	for (i = 0; i < pagesize * 4; i += pagesize)
+		if (is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
 			thp_size++;
 
 	if (thp_size != 4)
-- 
2.34.1


