Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B7CCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962786B0006; Tue, 19 Aug 2025 21:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A248E0019; Tue, 19 Aug 2025 21:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876C68E0011; Tue, 19 Aug 2025 21:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76EB96B0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:53:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAA4813777E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:53:36 +0000 (UTC)
X-FDA: 83795464032.08.FA893AE
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1E8C8160004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:53:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jLbVmE9X;
	spf=pass (imf08.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755654815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4c1D99Xbmak+B110RHN1ZX6H5hATGTeflPPiUc4DEOQ=;
	b=gjiW2klKf6e5S7JaxWCtLqz+MYPHc+VeXwo03rxpSLSbBj8XAAA052mfP/L0tz6/dkkk1C
	yrn+pUSMUpvVJrqbQk0GkohoP2iAa70n16QxnDRv9M5sM+bMSFFrAhsKMriGvV/fZ4kTNJ
	5UGCdOnjFbx0pcO/2l91GWVTgadxgok=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jLbVmE9X;
	spf=pass (imf08.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755654815; a=rsa-sha256;
	cv=none;
	b=bIJbph74xYKHA3gLOGFdzokgrkTuYxX55HgYKpY/kXapCTgCAfj2LNHNit4N+RXTKe8wLs
	yI9LHr5KTsp+nExolVFqWwb4GD6YLSqeHGVKaRs4K2driRqAcCBMb0x/G4Uxfm+Ry0fmfJ
	ZQ6spepuumFyt0UlXm4dgPoAjWM/m/I=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e2eb49b83so3893946b3a.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755654814; x=1756259614; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4c1D99Xbmak+B110RHN1ZX6H5hATGTeflPPiUc4DEOQ=;
        b=jLbVmE9XVyoWvd8BcV/yN2+QoG+cxi+EYL0nKjnZT3QBdNQtQtMKg8g6Gu5puD8P38
         hsdDslFR0S1rrFlDnkDQm9Q45+CB7nFuIV100VQ3WX42D4N+5zCUpnJ5pTc0wHyDjPcF
         1sl46fkCa08T7OoMrw8xQFYW9ViPdWgrekRvnvwOO5kYMm6nGkRNE8nCFum3wgebnL8Q
         /bkUxYRKPt/d5nlow84jSzmHMEBLPzOrxa14z3WS3sQSHsKLteTvY1PbNkzvsYjiAZNy
         yOGQxv3RoMmfFwBJDeS5TjbKE6L8qV2QxgSw09AYplA6Dl4WPZMI9XuN6PTHLwIyVjMV
         c7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755654814; x=1756259614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4c1D99Xbmak+B110RHN1ZX6H5hATGTeflPPiUc4DEOQ=;
        b=QHiaihamdbyEDo1Jb+fDYdLn3dmN0R7FM03F5Pynd2bJVU74CmhHzujyTLoskvQRll
         aF3FC+Q5Jkaxxdz9gliJT+NtwPYUQyiRLdS/hHNL9CkaLf0uOuAtoL3H38YQiz4efFcc
         I8l5WrmVpWED+nHc4CrbTjyxVDSFPbiDnpywPNYmqg8zghM5WMJSwMuS2U6RQVTrb0M6
         1dtO0uBoEWywgBun6Rw39NxxGuRc6RNPFj1wW7wL/iTuO2No8CMc362/X5UOnkyh9N8G
         VMeniBSssqUDCkkAsRu+JnPSxscdLGVV8R22PQbwgyaDpextbMg74emQnDxT1vqcZvny
         Ce7w==
X-Forwarded-Encrypted: i=1; AJvYcCVnZGyqbIp6GHHakr7f4+9giM0z4FP5sdS1N3k3WRQSQ7N7EyC7TKjn4Xw/BJQ0KRG+zJ3LUnGbeg==@kvack.org
X-Gm-Message-State: AOJu0YytvYS6hyLM/l2iDKr7FFQqCvpV8if8V71sOA6/DiRE5BYV+RNH
	TnBpoAhWDA/OOi6d0BmPhGgkxmhZFZvXO25Uo5FVaFN0flPjztD3j8Xa
X-Gm-Gg: ASbGncsf7sD6tL1DBoI2sH6b2zO7inPUuPqEtxRjfA9sTK8+LdIpZ/seYIDAHW3dT0A
	MMcem7dmbu/KBpz9gn8U+siay9gvhZVxQWWjoZPCRfPqr1f6/Hz6MrhxcovBAPGCYzn3tl9UJFe
	h4uWQIr91JgCKWNKlqPkLk47TbH+XHW7cZ8f4jORNq0kwCXma/jb8OZEbzWGPan25IA4yQKqq4j
	uh5gmRuluRIloleK8HmXHxO4qNL0cGf0iyayuG29YaRa4Rj7tk7QBFrK3bF2J7IIJ/UNmX1fS7f
	gMjQniAF/8w1uqTTppzHQ3iOtzHOJ7QoSp2SrJmxwK9fULJelxvT0jDuZT2DILASfEO0eM1EVZs
	3oN80yZ555fomLieZgeie1yyKSW4VuzaW
X-Google-Smtp-Source: AGHT+IGq2iFdP7a8AR7YmJmB0ZO+5+HaC+y6WtFG4B6TW1nA4UBSlu7RjV3jcs06N4nOxPKn3zzXNw==
X-Received: by 2002:a05:6a00:22d1:b0:76e:885a:c32b with SMTP id d2e1a72fcca58-76e8ddf4504mr1560582b3a.25.1755654813778;
        Tue, 19 Aug 2025 18:53:33 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d541c68sm3784244b3a.93.2025.08.19.18.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 18:53:33 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: [PATCH v2 1/1] mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start
Date: Wed, 20 Aug 2025 09:53:26 +0800
Message-Id: <d30f91137e3a296152463ea65474e1ca56f4eda3.1755654367.git.gaoxiang17@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755654367.git.gaoxiang17@xiaomi.com>
References: <cover.1755654367.git.gaoxiang17@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gkgib8gczo6z4s6wrxyqearzh5sptemx
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E8C8160004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755654814-161771
X-HE-Meta: U2FsdGVkX19WthgU9FPlCdeqY0FqZNmFRWJUiS4KG+XAxEX6niS3OVGRR/VUSqAlnR5Cz+GmMNJu2qIuH0DX3CgoTxZ63TuN8yyF7nGD0Fg56CQDAuvOJF9hkyydV/UKGuhTXWG54PxuRED0N8Pbid7U/D4SktcMT7LqMz4BylJ9vfGHqRCEBgVKsBw8goslSanUrXab1O4v+eYvrVjB1/fH5nn8nIPW1u3GOJIU+KoM9Gf1jLUQ7zamvmEwPOP3kjMC0F8nI5/hJJHLS019ZCzlf+oy++ofp/hBIxWi36QrGdngnI+wNPMJS+I5FC9qQkUqTH0lprOZSEVHBMlSUHZK1guGJQSobLqqdFuivrxfvzZHDNCZhKGvmXLNrrLQlhcZ1L5WPSM7BADDgrN2ffcWkr5q5g/XbTPkdWSDO3WqmTjEGFW+/uGdS2Zt6V9SssatgYjDERkIb+uaqiwAeU4eeSWiR/t0Xk1ge/R+rtKvw/eIf5MYm3zzPUH7qVpBej1R8phYwmI7X6gsjcjMJbNe5DEpy8tRUNazN3WYcMNEnNuFl33LH/4XNA1GH5e76cP2b+bdpmf+YPvBtP/2UsojItJDsF9dTHmOKHM9pV+z3wo+ltgbkcbEI6y+UCYGdx3BLOqtUr31CBjlhGi0UtmJgJUO5R+HYeOkH/qEbU08jXCsIrigmUbit3Tv7a1aDC3HSufGsc+rNuV3R3wFdYTzM2CQzcz9CfRTPZmvq8Pk1n8UbwoNMFK9M6of3tr5nKM1Tx22X+O0QbVwB5F0HzWDcMb8iUq5KeRTo7zHWjxE8zxVTCPT1PZ8BlIYNaqHdcBLvPWO0qOqSwDhhBD1YoetJvtwRk0X29Z+M8uYhB6HEMs8CtL5f2i6KOv2MpQ8F1F1a6/zi3pgZ10uzRLy8qJZLrb0JmqgdLv/tMsfvtLtaPpRdeAfcZez/wed44FM5eYxjHKwl3NMi7GhrC8
 334tzJPP
 pLCD120kbGxMmHmyYpLXeFKu0cQi/p1y0otOcutao3zUaoWJGL7bmceOgNGQSvJOJnz3FdbPHVtqvq0ewhcaQAZ1FRXa8QtTq8rqNfQki6xP7j5ILf+AT2rLTYZyQ/cx/88APzFJFVywrOkA5I6C4+Z3+sGIpIWCyIqC7/xvVaKY6glaePqn3zlGD6fqUEbatH0/BiyxeANcovrvSEi8ZXcv2+dNvFL298ysbMYPg36QSbjx+bZpw03+pBLzQXjmgJFBEJpI6LD3/TsMjxcEyzc+pGayTSvgqAuYxQoKY/L4osnJmkws2N+PmKhdBnU5E5knwodb35uQxAybTOJe4Ei058s1JgboW+TRACeDMODRZWwzTbACbbIL9mZ7tHf4VpHig7TYekQm2UTcqW5qHyh69kCDs+WFNrJMU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: gaoxiang17 <gaoxiang17@xiaomi.com>

This makes cma info more intuitive during debugging.

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
---
 include/trace/events/cma.h | 19 +++++++++++++------
 mm/cma.c                   |  2 +-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/cma.h b/include/trace/events/cma.h
index 383c09f583ac..5655ac521fb5 100644
--- a/include/trace/events/cma.h
+++ b/include/trace/events/cma.h
@@ -38,25 +38,32 @@ TRACE_EVENT(cma_release,
 
 TRACE_EVENT(cma_alloc_start,
 
-	TP_PROTO(const char *name, unsigned long count, unsigned int align),
+	TP_PROTO(const char *name, unsigned long request_count, unsigned long available_count,
+		unsigned long total_count, unsigned int align),
 
-	TP_ARGS(name, count, align),
+	TP_ARGS(name, request_count, available_count, total_count, align),
 
 	TP_STRUCT__entry(
 		__string(name, name)
-		__field(unsigned long, count)
+		__field(unsigned long, request_count)
+		__field(unsigned long, available_count)
+		__field(unsigned long, total_count)
 		__field(unsigned int, align)
 	),
 
 	TP_fast_assign(
 		__assign_str(name);
-		__entry->count = count;
+		__entry->count = request_count;
+		__entry->available_count = available_count;
+		__entry->total_count = total_count;
 		__entry->align = align;
 	),
 
-	TP_printk("name=%s count=%lu align=%u",
+	TP_printk("name=%s count=%lu request_count=%lu total_count=%lu align=%u",
 		  __get_str(name),
-		  __entry->count,
+		  __entry->request_count,
+		  __entry->available_count,
+		  __entry->total_count,
 		  __entry->align)
 );
 
diff --git a/mm/cma.c b/mm/cma.c
index 2ffa4befb99a..e56ec64d0567 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -864,7 +864,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	if (!count)
 		return page;
 
-	trace_cma_alloc_start(name, count, align);
+	trace_cma_alloc_start(name, count, cma->available_count, cma->count, align);
 
 	for (r = 0; r < cma->nranges; r++) {
 		page = NULL;
-- 
2.34.1


