Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C803D4661B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911B06B00DE; Thu, 15 Jan 2026 14:48:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F37B6B00F0; Thu, 15 Jan 2026 14:48:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E83D6B0101; Thu, 15 Jan 2026 14:48:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3866B00DE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:48:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D12AB98D4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:48:56 +0000 (UTC)
X-FDA: 84335236272.21.1401693
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 772AE40005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:48:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T7OehicB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=manish1588@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768506534; a=rsa-sha256;
	cv=none;
	b=WGeMWd+6Up8BkzCOWiJwF9oa29mPSLiaVqljXsaeBxlphB2hPokICKnnA/dhIV+4NQuW4E
	1KhZZ6DR0QbKjqPotsMAWQKJWCG8SYbc51qjwUwSGa/KPXEkmcra0+CfOCi6aeHgEA7iap
	ah1IDAUoS3IoQfHtXCCQrmcH1LxDSJ8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T7OehicB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=manish1588@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768506534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6KECmSSyqeP+9oOOU34D5Is6abuUI0ETbkep74dmHDo=;
	b=AguoB7Y2x479buRfqG2OTFKIN36CnOBnBgYhMuw9KM4oxPb4hofRrucBAHSevFOaCF3R98
	5kXk+qoLnbAxa974fboqWvJtG8S7vY07CmQenw++AGr74dJwiJhQP08+lq+0d47erOgi20
	9CZmPvzKriZNNIwqfYfPt83Jmqx3FKU=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-81e821c3d4eso1099702b3a.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768506533; x=1769111333; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6KECmSSyqeP+9oOOU34D5Is6abuUI0ETbkep74dmHDo=;
        b=T7OehicBG+UriqExm2QLFVOxfpJed5G+bEhnqGdVEBFMyNzH6A5k6nw8YxsQ8mu6D8
         Tik3RpBL4pjJRZDg91GJR8FcjaDd3TYu8vrItwkJhDbgkXOjRHZdgCc1rKuprkgvOOSQ
         bTta6fYqIIaLZnIHlPkg5igooHYZq5FUxbJqp1g/9TKIlzbTHHgo5zdLb4ifPLatVWA5
         mKpVk5Ps4iRWUqREX3knKyyrfT155UYdLPdEP2/juubqeHThuIvoCBCBYZJs2244xyFz
         PRyVDhuOrYlGPv6Dm4/sf6jEr0qcrLAuQL5iQx7jv3EpwLuz3EkPn0Bwgz3GZY7ntYdZ
         lNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768506533; x=1769111333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6KECmSSyqeP+9oOOU34D5Is6abuUI0ETbkep74dmHDo=;
        b=cS5ElTq//1Ukz36f0d7xdrhOPF4Vt6HA+s5DrUFgLD0Da27T8HkTuwO3MRMk7EZGdK
         ScSB4hg/1fdIO6xQ3PaeDW7MsNreLdS4eHxPhXdO4SgQBUNtkBTQbzfHxjA6TQeGXzie
         s+/ff4p1nyfFIyaPb+R6s0apcQlgO8RUC2WUcr+0CB3wJlmhS+DyI4x2qPZP3A7V19Bm
         7pDuDxpddBZwLOd+4wtelajjFfFo9UKKjsZ6a+is2FGe5kkOcrMLJ2lBr5l2dR5nEIyS
         S2h8l1QJIcsdqHmObxYCp+g3q0VEPVvP5sg7EcIkfm/hcdWUFAwC514mcEGluN6ejAui
         itgA==
X-Gm-Message-State: AOJu0YwRSyRxcJcogjEAikEts0KbxMXeePejRdXSSYoGAMj8D/IIv7/K
	54YfXiSPB9HC0zQBE0zi0CcGEmJNO0O3IF31alhIwxtYMnEOQK/XFo4x
X-Gm-Gg: AY/fxX6rc2gHg0JUylsKAJEWuqozpA8SUad1NG5QUaH5Czke2OnbeaBhUxVrhn8KQp2
	vb5xHkPaPF+CZuKxVycj94TYrQkjosb+kI+rpJBxD4Bru98yQxBY1tTL+8rnXJgkTc79Wcy0bWI
	XmQNchVnFUXaOXD1NM40/1JZgNVCTx5MIwmryWCxux10DLhAL6djFRgIr0p73EIyJuWMeKZpqZ1
	ABM6aNzmafj2HTmH3df9cINckNg7uMdY+SpV21biTWlyEAwngYipkTwdWCW9XKV/zCaVHTD/Bao
	47IUOd2mVs9bOIE//Wsbn+W0cdJw5Nfn+whuMxMgV6e8pigbU/kPNUZPPBAY7rUZtRNVNnvTUiN
	Ao3BQtIqyhs3wC03dCQXTQB82dpwjpw/3YVlFtEMJ+/CD2oO6uOjgmbVhr7miS2kn+2BgniGcWw
	GpBArO3vc=
X-Received: by 2002:a05:6a00:2d07:b0:81e:591c:e7b9 with SMTP id d2e1a72fcca58-81f9f7f61aemr569702b3a.2.1768506533388;
        Thu, 15 Jan 2026 11:48:53 -0800 (PST)
Received: from muxbit.. ([122.171.16.181])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa12b49ebsm162593b3a.62.2026.01.15.11.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 11:48:53 -0800 (PST)
From: Manish Kumar <manish1588@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Manish Kumar <manish1588@gmail.com>
Subject: [PATCH] mm: prefer 'unsigned int' over bare 'unsigned' in page_alloc.c
Date: Fri, 16 Jan 2026 01:18:45 +0530
Message-ID: <20260115194845.118064-1-manish1588@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 772AE40005
X-Rspamd-Server: rspam06
X-Stat-Signature: 7fenoeqo93m4tjwtwftkrgj1ym86g3t8
X-Rspam-User: 
X-HE-Tag: 1768506534-360399
X-HE-Meta: U2FsdGVkX1+rjdDzy6DMu4fE9IzIJ6paLydKJXyz8Cjrbg3My8KFs7zhqG3hwkzcfByhegvDeVBIPHPU5TRshJZJoUI0zPZvNWv4du+/tFVznvUjZbvL+AdN2Vom0hGy0zLG8eyzqFHJaGzS+YCBIVULhR16f92Nvm13eCALq9m6bYN9AGH7h7BspzryCyY4z/x/XKuInuo4N8DR7tar4Bk9rwxxXhb2hatxdZ04BQ1rrnOlxoZk397EKlvk1LzFVeWWSU6USAZ92z0JQs5Q4rT26X7exXeSoa17CtjZyyjqvqER7XG3kiMXrLI8q/GNdqd6XUhbuxZWlmebh9iZEsilnbRUEHfF2MmX0ZtSge6RuAftCEeXg+vKthZ1Gdg7MwtzKKPCsysHUArYP+Oji23ZxjRixhgrgUru8dacUpRQVjPzPqCniw0icCDIrPzcBAV2zQzBK1iMdt6FsDnGvJ5Dj8zLZ082PkTPnLkhWquhlx89Q1GFzAgKLL9j8/89SL2eojcPsr3JP7lKJO8J+VQPTQ+sYEO1ZNloi2aCxcAN4O+Pk/z9mTS4AM7IHz623EJo2ltObfc9xUhkq62eVFQecKsh4vdUrNX/l+SbuP4E05x5e4+tP42+sQ5eoCI/GGb/dWLkmLV269/0cGmVlc9O5o7noIy5/e7ODmcdJl11XZT0DTOGtxCWVVVvERphqMA1Z1+exJXyUcPttwA4LIdY8PY6ueXCR/AMyNSkTbNiS+brKN1X1R+gxiPfj71JB1pvrZXZcnc9+gNlby5lhZe4ajXzfcC7rTM9y2ZOhn/uAC9V+Su9YfMmkVaTPa6Obpw7S09cBHFH8k1IdnaeozvNIpI8OrjYqDlx9aaB3R9dZlWU3s6v2Ln1DeiZVSEgxgR3iq5Twqk4RdDVoPoDhmb8Zi5pv5Fwn0kna99oB4zuqwXffFvuYf5gi5b+XWSuJ/6w/x9ziLN7sRpH9ij
 2SePRrF6
 MjwR8fVpMs72Zl9EptrDMpuIS5hqSEwefaR1ZXSY1PD0eH661oMM8Nbc2ZqXsEqHZDNAjONGuRgXzfCpl7rbPieEsZLIC6hPHHiJpGa29SEtldcBPQgclbiN11Qjrq0Y5WppObfLVO/qI1L6ex8QRFe2sltJFwHw64VdoZA82R9vkUGeGn8ytb0mthjhHshJjmV2DlS97wpEWlul1cfQiv6V+w44Ue2NYmdI7GQR9wS07+aBdIdGgtbLzzlIK9fMkugv3r1CTWfGgCrB9lSlM4bMxLPfUnMVwFuTcSKoeGpiaDgKLFC4+nSNQTce8UHDQ8TQoZatEI/a/R93hjgfC9CavPmSViup8CQcYuwa9Rgry2ItAWz4BRhZfp2/8HoQ5HI7gM+RUqw9o5vqWzcAroh6kfesXx8vkozVGI6fRw2tXdkoO4MMc47x7480fIfLEg/5HukDf3at94hKLKDIhifo2CmVJ3sP3a4q+u8v9zlYu1VbRSshPvPwNyUEam8T4BJ3ySxveKL2o0zP1LFijuSZHJqTVAIvEr/t2ZdYnearyle0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.005866, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the declaration of 'seq' from 'unsigned' to 'unsigned int'
to follow kernel coding style. No functional change.

Signed-off-by: Manish Kumar <manish1588@gmail.com>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 231950d9d5c0..5e132ead5ea0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -577,7 +577,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
 	int ret;
-	unsigned seq;
+	unsigned int seq;
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long sp, start_pfn;
 
@@ -659,7 +659,7 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool movable;
-	
+
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
 		VM_BUG_ON(order != HPAGE_PMD_ORDER);
 
-- 
2.43.0


