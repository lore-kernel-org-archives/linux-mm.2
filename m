Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D096FC8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66446B00C3; Wed, 27 Aug 2025 03:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17086B00C5; Wed, 27 Aug 2025 03:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C050D6B00C6; Wed, 27 Aug 2025 03:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3F06B00C3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:01:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 301CF139A9E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:01:28 +0000 (UTC)
X-FDA: 83821641456.30.85CC651
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 749098000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:01:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e52rSckk;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756278086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=i9yGig0Idr2fpe7UYWg3D0zUqXiTMpFVh0D7qgxLxlQ=;
	b=gwhjL9JD588BCJmGxKx/CLSDTX9IGw1QJTol51QnS1RopPkLQZ0HS7nHfZ5RkLclz3WlWN
	mKrKbqd+ISVxtgFtL7z52EdzPfkoLDr/dDSJQqt+mStbfUvdK9lzdw4qYz4IicFl21lJX9
	cIynVM5LcbG8ERdwHzza4c69IJwOZLM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e52rSckk;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756278086; a=rsa-sha256;
	cv=none;
	b=T59+M4JH7SmrXeCWZ/YCFoATTgSNuvdQt/hU3D4CuzgmzH90NJnGHS2qUQ7Pckx7k+Hpa/
	lf2Iv2WBv/5Fw0zwP1j5ODveIOk8OflMF6adWO51N3+s7aKaVUjtApY6hkzsMQL4Zk7Bi1
	4dBgSLQeJEuoaD5FBDSdFVRsKiPdAzU=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb7a3a085so1022593366b.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756278085; x=1756882885; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i9yGig0Idr2fpe7UYWg3D0zUqXiTMpFVh0D7qgxLxlQ=;
        b=e52rSckkNmx8ZPdrLdpZYweF+XwfyEqsN9sh5vohO9ime+8SUEQmMYKMNmc9IAjj8q
         1mRSaenQlGxw5YWzPK/i4cQZfEHNtO1uBZBgRUAVFJIcvU+s+kHInppGPQYPkwVo5Hi/
         SJ9WQqzOo2HP5aCG4Gbfi3jr0rshQfL0Qm481PbyIwxN2L7pVAUDscQlNuUzz7x7F63I
         IQyhfILwgXhFlaO8MGKja2qBgCsLzEFdEyKXyFPpOr6cXZnoiUQ8VDIBX+B8I1Qhu0Tj
         qTghqOQml2h5j2Sl10WHlQz/5Tcxk1wxf0i8WKYIqs1VeA1bfTNJO8YWQXAsnHZLJKWH
         UlDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756278085; x=1756882885;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i9yGig0Idr2fpe7UYWg3D0zUqXiTMpFVh0D7qgxLxlQ=;
        b=qWEOU/qrus3qw/sf+o1tkO5S0bPjGpH6REQ0Qz8d4/GH8NJUnWnqOEgcZe4RaQAhLV
         YxPs5xOppmrDnihrXrrtUi2EX6F0LpnbNBa7uVWNRsRZGObSOjM0brrH035w8UrVp1KK
         7ylfwiGvZlUP1VCg0rEaI4FGO/T96RABpVkdmf6/VLdll5wIxZiRjo1Rd1wokbLU5b0N
         0b5R8oJOpe8i6h+6nX4j/K6UlCs/RKh+JVGDz2VQ7INUg4RZY/hKTTkcKq8JuM1ZJa8Z
         zVJLOY+gzKXuUeXSokZTar/UEd8bk1CgkARvnWuvo1kFazuUWGg6bulNUJHMB55JEX7w
         Qqfw==
X-Gm-Message-State: AOJu0YzKvpxJqKRRWjcUgU5mBhH05203vXaveWI30M4UNcFYO/RwkzcG
	VJwIBIdBVTTJWmG/hlHgWIkxCnrCfGbNfJz65+PJbju8G5Cmq5nbwTmq
X-Gm-Gg: ASbGncvNzC3kZ52eEXuYePTXPiJXq7h5NkEchHqZ0KmSjGV0s/CPVm08LgHrjJnmt7o
	A91jkVPmb6L9ItUdQRa+k/n+PtbatTmwT2ifyko3q73OSTGOTbs+874AYf8qX0QuHyBL/TAu95v
	QGxz4fyDmIxQnf3ygY3fGWQeX2HfJ05DXfGHJx5tJcklwltueulkVG1v8EJOuXjaTqE6BuvFDrh
	MQTtCBFfX8QMX2I5u7yudgq+92m2HtQ1hrWHMHI5KasassCgnI6Y5Zw04VjxImaO+59cwUteXw5
	jrrgEgVp/WMMMUoURgpeK99EnQZaJihqIoWcYczLOxJqg74lldz2zyik62k0lrfek6COITu4LEH
	ONKk+pnmtDT+yLalEnugzQagqny7Q8VB3sO9T
X-Google-Smtp-Source: AGHT+IH+8M74NCGak2BJ2lD6VQ1F89grPrAoBVlJ4mlDAnzBl5XVB8aB1tvQwPDV6gMSIMkpd/P9pQ==
X-Received: by 2002:a17:906:730a:b0:afe:cbfc:377a with SMTP id a640c23a62f3a-afecbfc4431mr19162566b.27.1756278084961;
        Wed, 27 Aug 2025 00:01:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe6edd3414sm737514566b.65.2025.08.27.00.01.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Aug 2025 00:01:24 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [Patch v3 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better reading
Date: Wed, 27 Aug 2025 07:01:04 +0000
Message-Id: <20250827070105.16864-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250827070105.16864-1-richard.weiyang@gmail.com>
References: <20250827070105.16864-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 749098000E
X-Stat-Signature: ic4u5qiazz8dixqw1dcbttux7mxth6ar
X-Rspam-User: 
X-HE-Tag: 1756278086-388900
X-HE-Meta: U2FsdGVkX1+MqVaLyzkZEwl2hfX3nzg/8ECB2monRx+JaRqMgpMwQMw4SG+qV8jFjSOd9llhuw4uvKUbxA4hLgS+dA0IwnRaVAoJ6KqzMixMEwBsWk36maLmvJUOiJmhS75hAUZ2RwFerOHe7ZCkgIRJR5UISr72iVeJBkfc6JBEZLYmx5U4y7xdZJyizKViBwjp3OlgZ1yZGnVqwU2X0sl5asdK4BE69MEd5HGVD2irQCdsoE58NGhtNvW7v/leFc1fYVwe9PVAP47hHCzHmVG5qxOwHrCCFAputd8bzVKV5YB9jH/DgzMW3mx/HNk1+OdJ2pPYq1cT7EflWh1bYR0lGNgloBmglsao0Xf4g7l4+zy6QP9uVGXnWThclNtceYOc1qTeRwWaz7SDTIA8ZbaNof8RldBFG7lw+93oMKICAe6MrbZzKFPR56sWMIEUakZZHioncVhsG+cGw1N2VVmdo7k+JJwHfvxDfrWoZPA4B0F2ynQ0OGMBHPeCV3JGRWqJYzogOVTQ1LoBd07OBvp/yxxVcF4Zz53KqZi6yOEqSr+n3ZAtKTGHnyzV7g5e4v2+t423bqfWjPmL/nl0a/09NblJTsSo2fh9XWpowHECCCIviiVRBKZQR3ZpVPeUaM+nEV8FC5cD3pxyEJi5nDph66ub+WCLxyl6mBgGvMSdQeutHzawW1sdtjugWeMvimRlNRpoRjpdPHuFVzUjfFrSP5wLTonn3m8poxob1/TXYcb+7TL9CsS/8O2vo09o/7FISz6o54FCILG+qHQVsn/rBtSjmKdTdODCABozJ7658HuvXTVWcev9lEwbPrrQ00oaVN2F+tcUgiwKpku+BMEtshKaMHOc22JMreZIKl2Ck3adbcR4liWP3gOYut1i52idREyKVmDva2ot58Kh0ZLkQzuja3l+hR4JxBceY5jS6Yu6hCVVYLI0PCvj/rAoIgHED2uTTWSL4z5DNvg
 1kprhPcT
 gtop2ukeJv4RG3yWBt0SzI1pyMa3lLbQ4qWuH2Bgbz01pMdmTsSqza2PfKD9aR1E2DbQAbLJiobwcUaKgL8jwl1/YwwuShmswgvDgNY997zvok5dfeslF2y0mvbm4NOGNEZqWPSLUdTMZeF2pe3AJZXPJMLGDasdUhNGWcO6CK83NpjwSX3rXJc7vgWBcL+9dbmr/gmRt3a5TQDVYmGAjnFwZdfGLfW5FR7T8jSJWH5KqEIg/IyKKVUbk/a7V+t28wz78j9S3F5H86vmv2/NhHSiO3Umz11GTGn2SzYlLRdhcdXH4hCP8P2luSQoCJhKP3INkoMksy/MA1/6coGb8j5RLn9qXxslf419vOotDskb8FPaMJGbN/WoSIbZCXwlQan65LkHNBCLpk0q8DLaCGWJGkm9JXGpL36N8tZFyFlbvkdavutQ9oZJlgiNu90l8GoKhB7yn2F6EmSu7eUMdd82swZJF/drzM2fAB/cifHjwGXyZugNtktwjXN7SRUx17dnTUXWV5fyZKch3fc5KD4LlOMF+DIh4BV3Yo1TU8HBiHSwBM3QqHa3ay7ZbZf/qphFNKNvhb172OjjVOyyBY6vURGqPeFnuS8FOi4ZwOhazJPAtfrx5yMJXZE9ZGEp9OvDnc/seYUS5fB74CziGPEidpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit e904bce2d9d4 ("mm/page_isolation: make page isolation a
standalone bit"), it provides dedicated helper to handle isolation.

Change to use these helpers to be better reading.

No functional change intended.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/page_alloc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index baead29b3e67..e534f31a6b39 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -538,8 +538,7 @@ static void set_pageblock_migratetype(struct page *page,
 			"Use set_pageblock_isolate() for pageblock isolation");
 		return;
 	}
-	VM_WARN_ONCE(get_pfnblock_bit(page, page_to_pfn(page),
-				      PB_migrate_isolate),
+	VM_WARN_ONCE(get_pageblock_isolate(page),
 		     "Use clear_pageblock_isolate() to unisolate pageblock");
 	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
@@ -2058,9 +2057,9 @@ static unsigned long find_large_buddy(unsigned long start_pfn)
 static inline void toggle_pageblock_isolate(struct page *page, bool isolate)
 {
 	if (isolate)
-		set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		set_pageblock_isolate(page);
 	else
-		clear_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		clear_pageblock_isolate(page);
 }
 
 /**
-- 
2.34.1


