Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4796C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37C56B0095; Sat,  5 Sep 2026 10:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE79E6B0096; Sat,  5 Sep 2026 10:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D63B6B0098; Sat,  5 Sep 2026 10:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 754316B0096
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:15:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 046F78036F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:15:52 +0000 (UTC)
X-FDA: 85179907386.27.F7B917C
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 470C6160011
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:15:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=acImnKEh;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788617751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oaI6KBzK7sPihmaSK/ByLcvQMgIofAT0nTkMKRAmXRI=;
	b=mpIDhrwksbtzwkf8c4HlSVvcDFau/2WMSBwFHV6Fb7K7hYFTHmJcLWVW02xwNPu/Mysrgo
	js73sSbVEp2nZnFt5xGiVRPQReFAla3Qzm5MRywcMTlwuE2aTRGPq8K5fDPDh+EFNBR2H4
	caUDgyIj2OjDVYXE1cm+SI/Yd4uRp1E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=acImnKEh;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788617751;
	b=nbtJ3qOal2kDAWzu+1UbMua75VBUp57ZIwvPLW0k7w0Ls5MqiYG0L4iw5LJcFL704/9xtV
	mXrxUpXkRhWQiJi9COu1MIGvFHNQFJscerzcm5PpV2j/Kl+fo5JwVd8AAUcwLRK+fMBMRO
	u0jMGW1oxg+90FExXZTk6qnWF9rEw08=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cbb8b54fcf8so2385242a12.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788617750; x=1789222550; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oaI6KBzK7sPihmaSK/ByLcvQMgIofAT0nTkMKRAmXRI=;
        b=acImnKEh/1QFtkRgZopU4scidzCif/ifwpamBRbjZc/6b2RwH90/NPYsIwyvbAm/zD
         vCSK8PYTO6mgxAgMnzJ7zgbzAacb6ufoZIGB2PzhBbE7SctyAS7P1VoUmdiSEoX8HTFL
         6c3ymW9UXyL54elfLQyegdn6U9to08zZnMumVOhmLpfTARDCRJI3pDR7t8uqrs+HLRjV
         vurcum8ifCgvPH2bZUQ+/Ge1Ofu4w0caL+PPWhr4KyyE5oLLAWUKkVucYgoyjgOxXsa8
         ScVSAWlCSemlZLwAFwyscRB+tzcd/r7tfPX6j/uxhYxLjuAAxuAIKg2KQKGHRKeEoIpa
         beWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788617750; x=1789222550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oaI6KBzK7sPihmaSK/ByLcvQMgIofAT0nTkMKRAmXRI=;
        b=clPj/RlfaWlKe90vXwwUvTdA2Nbv7dgwLditd+hTonn8gnNfWrVO5W1LgtTAKYmqtG
         ixcatXRoQXRZb5kzeuHjnOzpijp+9iyrQflkDeF0z8P0r86+Ig1b+ygG8jCmPQPnOpFq
         dA4ojWVFAXV1vbQZg/f6o8TmKzFkWD1eWuqBO0y22jb9R0Kr3oNuWpXb0jh7hgKiiUSp
         Y6VVgL0g3sY0WkVVsykeyZwEa9VVEHgbVhQcbaZijUR0h6DubKVTvjjl+2+oxpuJPABe
         R/RGlzZkNb9l4osLjclHJ90E7gYqe7l2W9zWoV/12Om0RFA1X+Qglf/Lyhb64yey71Qt
         hhEQ==
X-Forwarded-Encrypted: i=1; AKwUvBylYMxrKQGnQVCSvBZ5NeiW1eqDp+K/CscXoAcI/toG01cmz2S4XKlSaQNFkYsvzPjKD2m788mFRQ==@kvack.org
X-Gm-Message-State: AFuF++nYV/OtNRhqdBvBgTExT/oWjujfhuQf3ajZpD2kwHfQG0qATrZT
	YM2TTHL1i1q/aeZDqXmEPXSSyZd00aviTwqQ4QnnHAboxjkKEzrcXJp2
X-Gm-Gg: AYBFou39gaLUyJawjyt7cTaYZPqNn+olujPaIwPDd+/lQa05eB74cVUuclnvmYaQQH9
	g4aNQYGrJDdeQFFHuEmlQv0SegVBe7lj8C6eK14m5A6rm3J6vUJbfZyFbRycHBBTdhLBs3Fcxtl
	ptaGbV2Q3y3/pjDB7McamVaAJMzDwLcON5pT00V0m5JSKqTCQTE/LZenggd5n0xPpQH0zDTTr0+
	FBExMy1zLjmAv31/WXsF/PmiPrBw17QbomeQ6GfiSDem548truLCXtGzK0JuuFRZ/fzwMhIESpl
	Lp3LJnCqdIMmLIr8SLPXKf8jDHRrVSyft+DB4RqowqoCzwmJjvFWxsUVv4XFqYBPbQ8WsAJiwJ5
	esq5PKU/QAQvRvf6xRr7AhiUd6/SF4e4em89L4RcE0uxROdysxOD9KkBx+1u5UI2RaN0yxf5V45
	VqZzkFS9GHztrMkDQ6gcOF5DWpMbib2CrNCXPCsjPcaQQ2dxdtG0Zd0XA=
X-Received: by 2002:a17:90b:2ccb:b0:398:9be8:ea64 with SMTP id 98e67ed59e1d1-39b261d8533mr23136808a91.17.1788617749977;
        Sat, 05 Sep 2026 07:15:49 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d845sm16940726a91.17.2026.09.05.07.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 07:15:49 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2] memblock: reject non-page-aligned reserve_mem regions
Date: Sat,  5 Sep 2026 23:15:24 +0900
Message-ID: <20260905141526.1546478-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6fmrfmrzd5sc94qkfxhktro3rfi3xj7t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 470C6160011
X-Rspam-User: 
X-HE-Tag: 1788617751-486221
X-HE-Meta: U2FsdGVkX19+BxxnxjpgfCNs5b1b7UfqQJSVSPmwhnnXi4OG2cMF0v31DMjMalmGZnwErKnQklNlQ801kyaYK8CAObz4DR2XD8wW/LhTrMVZNaPJEGdf2Rd7MJH90d/oOTT/6uj/YWPmJBIlFriD4LHi8DzZzv/j/7GNE+ApTuFdLWgfuE6wmxdXHNjC+fahId3DaASwkQw1tPWpa62fxbS/oHdMyfji64FX5IMNBamDQnTLOwenVhfvUXk/p5AYg1MWXv/KL4k6lQT7vLoJj30KijS85TmziWa1PccVKYGeZrazEPiJw5JsKkX2GlJy8bZi9CgJjG23E9V9b1DBbaf4B7pEaxnluuXdDebj9cgerNMujEn0SmiQHSHX/DoUPxboIAAHDicShoAUCJ4YE8Fz7k9TFY6Mo9q2kbSrPslh6eOxLtFfpVWEszqq6F9C6UC7KUEXACHhML1c+0Jy/ZXCA2TcnqP8R9IFWXVSSm8nFO3qVGUiuiTVnyzU/26W/lOjOH8/ELrXDZp/D0oCEpR4BV2YRGB7b4BnJt934xkM6TC8Tz0CFQXN5dety22vKG/YoMsRaigCRsIkKq/dUjqrsOc3vg3Ez45RIkCGTK3FBB5fZyqUKITCZRkOGtcoh2VZ1i7Ulu8ephGBHgGILrokvSWO9vSyhQ0K9TOUvRONuB4dntHsBhj8HyssQGLerdLO+Ww0qdty1QqAz3EGHAWcBAWM4qrIra0Yglu/8l38eL+ZX5if/TcnVt7RGFvJO2xC9ftE5ppe+FPYIkEJe9Ahy7Omf/URogs8gQbpu7dr/+KvQ4U8N3CNqRk2U0QO2rwiG/mYD58dnApTSekUXiq8626Pczg1eH25aKGKUfmWLyttjObOstNMcuSbGNkSRfdgj+dAKUp9s+KZ30kxDt92mTzuP0wJ7KR8yEdONM/lOYPg7NSfyWNyxob5qT/I+tE20hGx2RXAFjH3XJB
 GVTZy4B4
 ouA5xiCFNT9aVh7aNMK5OJhm1JTyv70RMy8zUR9ramg653oadkZsyD9TupVZ9wX7LLHeWGkQ9fAMw5eDSYTbTOAvzv4/pC1CVsnAjXQ0M11qP04LCs541gqCwS7Y/MUtDe43fYH9kLNlyYyZLmqcygNraJHHcsZp67I97Uk2E1Kc5eR6oi0k7GdF2nqnqFcDal1blETR8+hkEll4/PNi0zRvMc1mCQXaG6amoaJ2mNflWXmU1Dcmv/qMI2AoDXvgD6FoKBTGxCFSsdRQF2YDY47hxXSfwOb8SsiqWAckonL3kcQfwRs+LmdSW7wRc98X3nHx5MRl9sOWnc9SNy69Zr3sQnE+K0/abGEXLSk63soa4tglyVmLosKtYIcir9ocwcCQ2klx0RU8zGe5NMIEr4EeXrh0wyfSXaLOaLRe2e/myw1ganFf7cSwYOpkJKgiQahEFLCJf/K0FlTp8sO8fC0+MXlojhGAesll7zK1aPFMYPkY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When map->start or map->size is not page aligned,
reserved_mem_preserve() does not preserve the last one or two pages of
the region from map->start to map->start + map->size.

After kexec the new kernel reserves only the preserved pages, so those
pages are released to the buddy allocator. But
reserve_mem_find_by_name() still returns the whole region including
them, so they can be allocated while the subsystem is still using them.

So reject a reserve_mem= size or alignment that is not a multiple of
PAGE_SIZE to keep both map->start and map->size page aligned.

Fixes: 8375b76517cb ("kho: replace kho_preserve_phys() with kho_preserve_pages()")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]
- reject non-page-aligned size and align instead of fix page count when
  preserving reserve_mem regions

[1] https://lore.kernel.org/all/20260901165237.1025973-1-ekffu200098@gmail.com/
---
 Documentation/admin-guide/kernel-parameters.txt | 3 +++
 mm/memblock.c                                   | 9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..f969085fffb7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6648,6 +6648,9 @@ Kernel parameters
 
 			reserve_mem=12M:4096:oops ramoops.mem_name=oops
 
+			Both the size and the alignment must be multiples of
+			the page size.
+
 	reservetop=	[X86-32,EARLY]
 			Format: nn[KMG]
 			Reserves a hole at the top of the kernel virtual
diff --git a/mm/memblock.c b/mm/memblock.c
index 4302fb4ab85c..5e93b6da53e3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2816,12 +2816,17 @@ static int __init reserve_mem(char *p)
 	if (*p != ':')
 		goto err_param;
 
+	if (!IS_ALIGNED(size, PAGE_SIZE) || !IS_ALIGNED(align, PAGE_SIZE)) {
+		pr_err("reserve_mem: size and align must be multiples of the page size\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * memblock_phys_alloc() doesn't like a zero size align,
 	 * but it is OK for this command to have it.
 	 */
-	if (align < SMP_CACHE_BYTES)
-		align = SMP_CACHE_BYTES;
+	if (!align)
+		align = PAGE_SIZE;
 
 	name = p + 1;
 	len = strlen(name);

base-commit: dbffc67777cd752ef3f77818109e1d2ef13e2949
-- 
2.43.0


