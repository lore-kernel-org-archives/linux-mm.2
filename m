Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF10DCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8433D8E0034; Wed, 20 Aug 2025 18:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A368E0031; Wed, 20 Aug 2025 18:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756C38E0034; Wed, 20 Aug 2025 18:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 643AB8E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:39:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03A8F140184
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:39:06 +0000 (UTC)
X-FDA: 83798602734.23.E19670D
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1BBD120002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:39:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=afC4ARnZ;
	spf=pass (imf13.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755729545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJAUp0f86jBeS4uWt/dNu5JNfGORO8BSJEV2L8Fn0fw=;
	b=i4tobEow4K1IAMCOO9tyJNlMEqayiOggCutHQ8e+1DUhX6b4avHZ1ugITOTD404mjOhTgb
	hghFT+KfRhyqGFQ7r0HvA2UbQcKgpJljQU+HF6HVQcmyVGeP57mWEtMsP0HjmTYY9MbNRd
	g5DulcUjM+pRbg+ullm6db+24R2RWVg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=afC4ARnZ;
	spf=pass (imf13.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755729545; a=rsa-sha256;
	cv=none;
	b=ybaWNA6wwUhoF75giQ5fo3qzCsdmRyUwmm55P1rFAAc2S2dxw3eriUpE/JM1RN+KQTJAxM
	XVxpEibwtqUq3JWjLA78wb1ioYr/LrHOh0X+/DwdtgbkO6DA1342PJ68sh0/eXqxCR+x8c
	X0iO/2DV3UW5IqlYW+oW8smL22JvW4g=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24456ce0b96so4570515ad.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755729544; x=1756334344; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJAUp0f86jBeS4uWt/dNu5JNfGORO8BSJEV2L8Fn0fw=;
        b=afC4ARnZfFP3QSDpRR21GIPGVsnaOtcEQWINbvOLYttdOYKQG0OnDd2zihstUsOu/y
         rTCkUb0QoIFBH/uZ2st5VcVZmWhvhULgKKSRhxCEcnCDlkeWNctYf4toj5ZWoDC5HLJM
         J03jGKACU9CxmYBNQn5nFSxhDDJnFDr4+vNmE/VfvuNM32oqlHCykpFinh72TMpM8+Dj
         xAXiBYPxLiXGRbtfqwbh/Z2MlCIhqEufNv0JTA8u58D3WTNfA1Y6GSXjAvJa9Kwl8Qdg
         Y8XNkXghbmK4L1G1VBhOXWfQ8kIdDDMudb/JtwDCbACb3hFQ95Xu4fS52FdNkHyq6bMR
         7u5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755729544; x=1756334344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJAUp0f86jBeS4uWt/dNu5JNfGORO8BSJEV2L8Fn0fw=;
        b=gUzUH7WPDMb3D63ZcD0Rm51IAMxREjxIcWe4f1qyonR8/6wfOqoSUN86lqvkTfk0cw
         qLxbrB+DVo4Q5s6fGTRwmU1a1JdzUlIWRNxnyTcs0mvk1afwq2mu5VbSUCr1jJCWkx2p
         GEedSX6UTF7aDrUzeAvRnPM8IUn879+X8Z1dG+hrVRcPNIt1OhayygG0PYjTHvL6m0Qp
         3ezHPnesokP/OzhJ4BeMhAHvOUGLOrWhszSy1JPv1RZSHKBFRPx4935rarnjzBib9Zm/
         54Ap6y5KMAQRrpkvBHJUy0oyL9lWgFytti4btl5uQ8ZmtLsRqHu7BgBxFE8BLI+oFd5h
         1QxA==
X-Forwarded-Encrypted: i=1; AJvYcCXkZV205j+9CZGmf1HLYNkrLu4AQBRX/llTN+jMBWnGec9L0w/b8R6qCN1wU+9KhhdPAs2SY4xt4g==@kvack.org
X-Gm-Message-State: AOJu0YxfjwmuiejDiT6n/MBw7EVDBpIYbQHfz4ZVWzgZE19+01TCmV4K
	jTuSdCXcNYdLls88/Uzlulb5efq972fm1vfx87kHtVDsTwVH9RKEdmnW
X-Gm-Gg: ASbGncstA9cYIuxlg03/rvx74Y2iTdDMQ+7w7ngqXZZDohdasT0oE9GEITvKM8Cf78c
	Ti4YbaB0MhQNaGxdBTtDCxMRBgQ3LNJiQ27vEHrIZQrf3kDHv4dm+JNLpqX26y+i0dKESmXxKqO
	fAglXkEBaTbUBk54oSJETx8bCm4Ghl2JQYahYdC3MlszdAFZmQnuhAE+8pmd40QWwN0n90NZKnB
	h5d9MDX3UoStAVYFgdJygj4fpA7wMiEved4lpHMNvHT0WQxsIxJsNvXhk/c6WFQRiRGQorcB7qi
	xl/xAMOinRWwZ+CCA/k6Il8O2XzZAeAEBuYnCSETGuxKXh41XnBUpmmvdh0X6xqcAmSHimsmUNg
	beCBhbTHsI4UdbyUdtomzlYrByxUg7kk7Kh00VEgqZhg=
X-Google-Smtp-Source: AGHT+IHpteoZV/YEAVlSStTaxwqQKN/L3bbOeivrQziXxVnHiek/V0RyadSpB97WmgxYnLZEVc2G4w==
X-Received: by 2002:a17:903:1a8b:b0:243:a32:1f0d with SMTP id d9443c01a7336-24602e40e54mr2053785ad.18.1755729543830;
        Wed, 20 Aug 2025 15:39:03 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245f6f982f3sm19739555ad.23.2025.08.20.15.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 15:39:03 -0700 (PDT)
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
Subject: [PATCH v3 1/1] mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start
Date: Thu, 21 Aug 2025 06:38:55 +0800
Message-Id: <8a79284879c529f467478552825154b018076e95.1755729178.git.gaoxiang17@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755729178.git.gaoxiang17@xiaomi.com>
References: <cover.1755729178.git.gaoxiang17@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1BBD120002
X-Rspam-User: 
X-Stat-Signature: bdznq7xpftrg5sxzeerz8zq9qam5ss7p
X-Rspamd-Server: rspam09
X-HE-Tag: 1755729544-956054
X-HE-Meta: U2FsdGVkX1+w8Si3NbaXPX7b8L7Z2+UUrY0IQWkf2bN6HGwNnay6nN0Cv1pOHK2nItVIzcGAjCwzZBG0fcolaPvf0VCupd/N1E8PKjlAkC2f6CUQBeRDhueSsrEKyDPlnYwLI2PYyB+HcGsaaiKJC+FfB0phurpIYlFuZMm1BBhlSYnXtqc/K0rrbu2IU/mKxP1ur6tc67eHoQ65Qpfnm9LW8vThcD9BKmkLRGe4+OD9Cx39OfzXeReQ/osLov19SBZhZ56lsc/85Ok67xLWQ2tgkt1Xyvq/MsAr3kADuMFPH7qXMw1IKoG9bMHLf7tdDQ4UeL971q/sobCh3Lj72uvSKuOZou3jZFxS85wHAkcEZJ8e5TrE6p/0Fz3PyVQJ9/LOYl6h9rJ9cqxzNbvJ4QDYWn0AFQlJ0pO0cpX0wcX92m3rI3GZmcVFSvW69mrGvHqHpqCSjMzxUa7VtrhHhgAoPiWYsMSL67MgZZGt5fLEsaF/cVEU94Ka4hLzJAGITEeCobmsxqKySrudKteQ6htnD2bFi3zmr7kfBrf2BXvB3OQPM/qoWa+/xNv0mjaMQ9iaVNeJPiT1JaFJ06GF8rHKg/zGFm4Q3zQDm+Mame5h6C9jss1r3Hs2etfL1HbmaiqTQYdPiNLahJ1bnDy4ip4h+TF0f7J+oTmg7Kipwqoc5MM1xcnrqc9qdYdSUftKUk+JOBiV90r9S0RLuhkYrfXKg+u8GbgI9IdWfUOatf3/mJYDKJsihuiGpYOMIGNGs+1QPQVe3xFlqjKioZhPKUbszXdJST1apDzXa9zi6rshUOR6kZByZqcFayw8/2MU4qFLoBNsAEoPNvwMwYtD476srNoQCvvfnuLWmZtfBl23YqBJh+laS6NaSsIz36y4TsA5pszmn8nYYxribFELatD5GVw9GR6m7V9cHk5EPk0QP2Cn7sM0jbTHwI+IGk1m3LxGrMXh3uzf/UE895M
 I55EVIKs
 bZBA5/Wc6f8CTd6YcjtyEWTo7oZHaoGb3Imx4113tNAxPoYfIviWD7+lOIMDZFUAyKXVWxbnYZtSGPLiVyM9CcbYZnt1dJQCTOPUqs8o/mAH6GHXBJyiqQdFtEqMyJMJkIHimvFdTDjW8i/ARcY46iYfH7NdNagt4rkRr7PNsOLtR/SHGn9v6EKMzrRlitprFzn+YC4lq+x0CSrv6ta+KiPhVRGNi/ohI1f96Cdd2cskJNsx54upiwq/BHh1+L3Nq4HUBUEyXznYZfiuNG7SkR1W8th1GrbBdnb5t/y5M7C2Y65oCDv85rdVIyP3sou8FKihnu6Qv3sWj4jBvYSQ9qbAEb+Q4XVeVQC+GelIW9ggZT5Rg78uzD/VxYqrpK9JAIR4vD2To3gYLGnaELZ3slPCBnKu57Eu3juSg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: gaoxiang17 <gaoxiang17@xiaomi.com>

This makes cma info more intuitive during debugging.

Show up in the trace as:

	279.814717: cma_alloc_start: name=reserved request_count=4 available_count=8096 total_count=8192 align=0
	309.790580: cma_alloc_start: name=reserved request_count=4 available_count=8092 total_count=8192 align=0
	317.046609: cma_alloc_start: name=reserved request_count=4 available_count=8088 total_count=8192 align=0

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
---
 include/trace/events/cma.h | 19 +++++++++++++------
 mm/cma.c                   |  2 +-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/cma.h b/include/trace/events/cma.h
index 383c09f583ac..37195edf2498 100644
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
+		__entry->request_count = request_count;
+		__entry->available_count = available_count;
+		__entry->total_count = total_count;
 		__entry->align = align;
 	),
 
-	TP_printk("name=%s count=%lu align=%u",
+	TP_printk("name=%s request_count=%lu available_count=%lu total_count=%lu align=%u",
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


