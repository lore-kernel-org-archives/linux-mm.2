Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB73C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595AB6B0106; Tue,  4 Aug 2026 11:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56DA36B0107; Tue,  4 Aug 2026 11:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA686B0108; Tue,  4 Aug 2026 11:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 273186B0106
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:12:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08B1DA0214
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:12:34 +0000 (UTC)
X-FDA: 85063928628.21.6811877
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 51CCF40004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:12:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kskfDgkl;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785856352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NndyXklxS7W4h5DCgCy33b3712+WNFD+HzxBt9t0wQM=;
	b=N4B0ZaPw60lOUbGRt0LCAwNQ7lJ4Tos65cFAgHPTPjo4dey8FeTs1IQkit6LZiTEKEkXFL
	NkQ0/cJoKwkzH4yQpOPWXVQSlvU1Y00Ak4BsHNAnhsoGgF5jNto/SdpDdy+pdWQFjR2k93
	3wLQHN+TU2rErb919YsPKhJzkjGylDg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kskfDgkl;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785856352;
	b=Gdbdrf0Ae2m6DW85I9kzRkdyTUeNYnedz39M3QyGJEGnzOsE6MXygqxajOFwNLavGs++qf
	1tKazza+XrO6MkzuHgtUZZMvQ4yZs2PycD3Jn+iG4aumqGPRQg/ViYLfq9weM5H3iC/45p
	CTrpV8O2cIvl6I7qYa8xZ8juLwJrlX0=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ce7d2adef4so74069035ad.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785856351; x=1786461151; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NndyXklxS7W4h5DCgCy33b3712+WNFD+HzxBt9t0wQM=;
        b=kskfDgklQijZ+NqucMLZbLrBxWVHsgoqDoWIJWdZXpdmtXTlqY5v+Q4LLWfFPYEkFi
         8lbnwOHUf8xx7zxT+6rb9WVYgfqOtCkMoiypwKBZ2t6kXbGh6+iETDbyYCqwZq8bs7b5
         74mOKaKdvWKqe4RqbcVElcUG3Ij5w/LWZYD1Xjw4e9cQyufff7u039YnXjka8BfS4i5m
         SLcXo7MlDuH1+VJ9qrqwMqjQQl9xHqX3gDrKjE1Urr+IiuLRS/Os3+GEItp/0KwyFQDb
         1/IAZq6xzetMCN73rzqZ72q/Q3elNx4I9YJKsvyr7IrWh0KOntydy0v3H65uA1LZw+ov
         c/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785856351; x=1786461151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NndyXklxS7W4h5DCgCy33b3712+WNFD+HzxBt9t0wQM=;
        b=CbK0Gvb1ZbzorFIDvi9nay7dVE+T0poeH8xUN4g2TPUADamFGefxvjzBsrS9s7IUeB
         k1EvNDvZ22jDEOc2C6BrHLc2R4O05+iDBUonz70wJnZQ2j7BBuervTW5SbhiA4X5Scm0
         IYkBN5xECE5YMXpciScD+RbcBrjtmpszrPuRV5VKORx4ZiDxrIVglsrWAP2btFmrk+2L
         FWFCpn2FQl6choI1LRHFDp8wd5a1cu/o8iTd2rlMJfuNul8xoE0xSdwmYPUmu6nbeXod
         eDHrjih25JPSQ40tkqi5HOBU5ZZtXQ/uEDBT5Wsc2ZJGhAGoe3NMrpQilxC6Kloe8X9v
         DY2Q==
X-Forwarded-Encrypted: i=1; AHgh+RpF98O3lex4jMGZHCf4ZhOD7MJ5rTyahikCJ7nxw2jO0fw7BZquDpdtE6rLKT5PxHOqE+y0yTncvg==@kvack.org
X-Gm-Message-State: AOJu0Yyl3k05VNfFCh3tIAg1tnvc02oVUge8v74//KYfmi8dVXIdMC6K
	trqMnTyo+sXUOP3gUvYQgI0xsuvaFqmrOz+ZCQoVRCl5gB1EVNE/xyD0
X-Gm-Gg: AR+sD11Of3QDVCGF3AY1sl1C7PlISh82GW1uVU6wADAtXcHkxyU7znV46sn1Qf5TYJ9
	MiB2ulfHiRG+zfSnKBvKUfTil9BN46i7qgY9/7y17GdalqLw6+e18D6GmgNSTYl0Hm6egB5hB+P
	7UZPCSID44tG4mfLHQkjix03JKx7b5lduIM6cvQykXNqC8FUYqy3nNDOA7FkZZRo9CQJlLIyai4
	O5wnxyhEJ/YO4wR0PjrUk4y0T0rH1z8OL5gBxpzq4BbiyodX7rGDX+7e5BbE6MYL/Ea7Vf2gOBx
	hsxMXUQ9JzgnWJ/gpW6UposlzpBSNRGP03qzIVAvkcuU4E5WpfTCI3YKo9NdW/qRbGO4w4UzSaf
	vxPdYaAKMOZFo6lHqEKo22E65QGnAkncjJ444h651yAP7XJK5Fzodx/vnu2NSY4Z/7ixth/nqLg
	b47EtXoW9BjwTOjS9fHd/1kxCewYNsgSoT9Dd8lmuJHJbYdoWXudQFBmo=
X-Received: by 2002:a17:903:f8b:b0:2ca:b8fd:1a8f with SMTP id d9443c01a7336-2d05240892emr153289395ad.39.1785856351073;
        Tue, 04 Aug 2026 08:12:31 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4d67dcsm9219905ad.70.2026.08.04.08.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 08:12:30 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 0/2] mm/page_ext: remove pgdat_page_ext_init()
Date: Wed,  5 Aug 2026 00:11:40 +0900
Message-ID: <20260804151145.3419768-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51CCF40004
X-Stat-Signature: iqwa6adomk9a79xmbpcf45m7nwww37ao
X-HE-Tag: 1785856352-791463
X-HE-Meta: U2FsdGVkX1+XxJ5Z7RZO+pbpldvzRZxZhJtIrCpEr2eOKp/RYfg9O5iiBsBdHGfKYLz6N6lcH9AJXsX6xkI7dYd85PQ9Y7qZDt+rb0pr9oqAfLO/jduNWgoaEsLshS7f7Wsp6e8RUFM48y3n+UQAcd+w1VBA5HItSG8v/90UTwhO1HhGbO/PbQ01fAE5F7byAlgo9kzg2WsIdCEb7ZB8XAE3uzVc1OiO8hAPBfNgfQi6kPHsfV5uGJwCGRbNOvhiaoBa/Rp5Df9oyV6iFL/urzClHWtx0BdkRb3GT+IVJJunpbU5yy36yU3bWxzc/cqWTiuF1s3tvJJr91hAg+TRlxjErAspxuCygteePJkK/4pHo0v+GH27uUrsOmXFJCwK+m/kq/0NbjD27gfb2fvbG8dbTp3bLJPBnfd3RANFOYMLZHtkGEeEXYDrKQ6Y8bCXLHjKZeLVAE/wlbAOABDVTaNIE5w855ftqQVTYOFAzQm9RzIb7+3ansDKtpIULiwF5cnPp+T6Jy/nCglPTIVBrYmYGHTsXBlqCkWLJT14DuW2lgCuan4ADIq5tsnJVTsK0I7jkcIqxXnRn5q310LtXUKNUBktxYwwwAesYypEsltY4J88FtPRFufC/KnrYghvEfzrfk0gz3ilbBlp/vqH5M4mLFre9mPrZ3bGF/V9YqXWW2bnJIYCeTUG+CjCBNyZ/uHm0US5l/0I3/afB9WtSmcZ9TYiy5njnAbmvFtcxZ+qcvvZPgE0ntlnQWLkzcPX2XiV6RlcDT7QiEvrnkRZrkL7sz1e0TOVHqKccrZX1mgFILf9GOzkTUT71qZOFskw1ccpOPhOPa31CqGIqLg615PtjqTz5dpQFFQc3QDfUVOlhxZeXwWmFwVfvLI2NkSBjgK98Dwj5hiq0LS5TjqKAPu3GTDC1RUM33Zz9lzG9DOmvuKg+vXfts5MapzI/1LI/XuTnReokgbTP2sGrwA
 tUXQxx8V
 oYEM53tb1vv0HZFwA1pCdwhlIcyUi/QkcTuEMs9sbTZq5+8QETey0zksXs6KT7CpOtMWy802+uxsoJDoOWJoOJ9L8My0yhpwHjD1ZJI4+GJmvwdm6adRn8jffFzjO3YmZySHDvtVdDfbPl5h1eOX1l0mloBtvTFDTMMy3PwqUW93jq3r+l4Ig+yZNv+YT8ITNgkaQDlwGiWlV1N0Qf2lh7xvU3CmIBB/QlE5V7IdBGZKloanR8z/gXnTuxEDwcAJbWIcjLmI0KIx0mfZS/joCeY2a4hhbHXQxIpK5z98BURC20hXAFYF5IjCRkRjV9kEcUk2YJp8RSs73X45S37H//GOswrkP3ChWUKnGWVNWfzoI2m2XdkvO5736F7nG0FPfEItj7lkiFWSaMRqnNt5Kt1eMULpmZlA8GlFU0fTh2VA3FJrcquN/AAcwdG0cR8RERNF+Kdcoaozn5K6doJ3i7+123LmRgvYSrYJc7ZHujJAXXFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

pgdat_page_ext_init() has no effect on FLATMEM. The pgdat is always
the zero-initialized contig_page_data, because no architecture
supports FLATMEM + NUMA.

That constraint is only implicit in the arch Kconfig files. So patch 1
makes it explicit in mm/Kconfig, and patch 2 removes pgdat_page_ext_init().

No functional change.

---
Changes from v1 [1]
- Add patch 1 to make FLATMEM depend on !NUMA

[1] https://lore.kernel.org/all/20260803134822.2568766-1-ekffu200098@gmail.com/ 
---

Sang-Heon Jeon (2):
  mm/Kconfig: make FLATMEM depend on !NUMA
  mm/page_ext: remove pgdat_page_ext_init()

 include/linux/page_ext.h | 5 -----
 mm/Kconfig               | 2 ++
 mm/mm_init.c             | 1 -
 mm/page_ext.c            | 9 ---------
 4 files changed, 2 insertions(+), 15 deletions(-)

-- 
2.43.0


