Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A41DEDEBEC
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03DF6B009D; Tue,  3 Mar 2026 14:41:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE526B00A0; Tue,  3 Mar 2026 14:41:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFAFF6B00A1; Tue,  3 Mar 2026 14:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A15796B009D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:41:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C5688ACE1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:41:45 +0000 (UTC)
X-FDA: 84505771770.20.241F63C
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9D4D940003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:41:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L41bNl9X;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772566903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/QjuD5lsXBFogYM+Oz5d5pzv8eE9aoRfo6lRKwq3BoA=;
	b=0O0O93ibtjiDW3J7tzdoMOVWYYc0AetQDo9HwgzRnePfPZE+Hnw9ssyfUoBP7Mea70svP5
	qyfcrPdMHbEnujwwkHz8/jv3BFe0mdqlspHTD2RmTD7SopjPeL5scHsXOns+Ot0qA05HWI
	rM3FHnD+nPzt3MV/m22PxvYxzt9e39A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772566903; a=rsa-sha256;
	cv=none;
	b=qX/3RFelv9n9gzjAvlI18CKvz+sa3YfyFmVdVKYeeWX80n2kgrkar4gf2qgPh6ikWJF3v4
	gQeRa8S5MuKTDmx95zoLSPO0iNh+V2tqPmEMsxox0zV2GKcbJUg07Ok8+SToJJmyi++G9T
	E7H4j3Neoa81Wa8Fu7eYaQgnuzGGgjQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L41bNl9X;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2be06c02f66so36055eec.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772566902; x=1773171702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/QjuD5lsXBFogYM+Oz5d5pzv8eE9aoRfo6lRKwq3BoA=;
        b=L41bNl9XUrl6O9v1Vb87wHjWfLNtcCVMKmlA9uAMYDrQg3GcrBjuypgqKx0hr1KRtw
         q05Xq/62GaZYINmTX4HIzQJLQLU6jgO90aIaKNmJ/NEzQwUIR+ZRYyB5+xO30VAhfoCc
         GZngGkT4ka9pIvNJp7pfTVul+/eF1DrSufP6dLLSuJkM6BlJAo5pI0Cu0QQXXbEegAQL
         LA6AqBbVoDjAH1kYC22o9J8kHRnbzo3CK3tUt6FnbQs6p7ZC2+XPL4fFRvidf8hSrrag
         XuoYb4pLrt8w3dENE/MPcfsFEGoLQf3iIpzv4sW7xFehiqRCJNahLiPgTRzfjxjbTMPr
         lUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566902; x=1773171702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/QjuD5lsXBFogYM+Oz5d5pzv8eE9aoRfo6lRKwq3BoA=;
        b=f14k+qdkYePOM7CNUihz8lb+ZI9225K5Zm6wKfr0o6GvDkUUCn+pzcMQIrtnQ13JfA
         rVsoFM2YfHTWw5Bka0P0BceUJEhkfpFfUB0Ma1Tx2Dbho0ux0V3HaTWCkos8lCpAEuk2
         xAbORoI8PQ2OJ6r5uWIY2Bm+gTCRMm9gwQDTc4WdPwGVxe6wb1XYdLImes4y8urv+hbh
         LSeEcdOcpHce5TrcgZnbtmOYAYV2DF9Ic/lSq+5Y8C2o1GAs6xU+rP2Y60z7oMTyVw5C
         BRa26HN5wNSEX1C5KQ5cycGjal6zAsh+RYlimZUx5HSB9xMrTu8EZyqPoFdcuUiG78vy
         XTVg==
X-Forwarded-Encrypted: i=1; AJvYcCVThswkQ67yKN0dNXonrqpLg1poFWo/XVW4UBqAjsY2JXxHNOexjrxDSr1b4Vco/tHbExv7tlZKLQ==@kvack.org
X-Gm-Message-State: AOJu0Yzsk4NH8IEM5aMP/AGPh2M/Se4SuMg7pXk44btNOgb0hxk4n0jd
	M0CNesMOztvyJSfHrZhHWTW54aj6+2B8rtViRGumnl6N09BcGOIWuHA0
X-Gm-Gg: ATEYQzz7Xw8scfdmhz6OR6qvIUXpcwrcvsgpZZBKvyRMJotN9VHYtYb9DeLFBf91igW
	UrTx+jkUWLwKLjlSFk9hL6eOI3AomqJdt7FC5cJmd7xl2UlZ9R47UM1y2H7u0/bfzx2UcrH9X7w
	d8KQ5FIAhmKX3XWmAPGdwG6OmsAyJNr6q52lrbf/MYCIjjq8L1+ajB4ka2ygV6m86S50hNPvKVo
	OZS49wL5mNQWXrnhfFQ5P7x1UjkxeSG1xlYP1dGOiaot6xe8hJAbH8Rn5/d4wilVm1aXB7AAn3T
	+CPaY/ANobPDeJziXqmPqBr2mAxH9CBVDYUjIRdpBeSnq41tLa26lPJbhag+nsZHLAgeJHFpMeh
	NV/ZlkkEhp83TYNyFPzgcLM8XXbM3Mj18SZ1X5ty5f0d/zO5qLL1SnqQaV0iariQkZMlEGlJliD
	L75iJsfcxexOitFEpyr0pcSE4HuX7VWxFtm8/MjmwCFbQJX9LllMkHnsBCfeBY8/P15IA3S69KN
	NgFELALYieaHNmF9VGx/IBFtw==
X-Received: by 2002:a05:7300:2325:b0:2b8:66f3:2502 with SMTP id 5a478bee46e88-2bde1c0e786mr7686471eec.1.1772566902277;
        Tue, 03 Mar 2026 11:41:42 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2be0d7e0d40sm6496719eec.12.2026.03.03.11.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:41:41 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v7 2/4] x86/mm/pat: Convert pmd code to use page table apis
Date: Tue,  3 Mar 2026 11:41:15 -0800
Message-ID: <20260303194115.1406340-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D4D940003
X-Stat-Signature: 44h3od9jgthrxgkj8hb7nbmhockreh8o
X-Rspam-User: 
X-HE-Tag: 1772566903-351819
X-HE-Meta: U2FsdGVkX18zN5lLVr7tFVh3svb8k3zjnHHCx9x73G0L+ht5TNQgBvdVuyB2v4fzwQ+XzCoeJVd0etC0XS9cuxEl4AwioTcYXnHf3NzhRDAqILkxw7JzUY8aBNNvQangHGDeaOBECy1B32dqLeBGhGdzOif27JOGjfzeFFP0k0EKTyUloQmP2hcWapx+oW5bcGN+t+lS6NiYcTQQa81/9fTsfA7N1sRxSSzoD3p+CS8xXjyqoKkXI0pT37i42KZPMep3grURwl5qzSrwK/qnQfKo80/ke00n4s5hAq8RJacuMqOCLWVyfNUiUCgREaAyAmB6ZoJ2vKwh/Yeu7U85wYUGGT+LOFevxbk7EinJFlWBCKM7zcD37/0aPrvHFqTh3jBpYNoSiJMVu6jGdlp78v8+7cuhPf/HDKluJQiYSoOcgY/jxex8ynHhx+5HaWoeP1OadjRcxY/VRx4S4EIwNN70jp6454hs+fBUDsHvmCrxG4aJSl01gLQDPo9BxCfTY81u8F27FoqRhATlQo5ZufTwSjWtWq2jMmHz0FjVE8dEeom4/2Xyo9nF3nn8wDnFIh/Q9p1lcGsvm9a6Gos7ZVygam3puCr9Iwq66SjPg9Ji0llOFVgOGD9gIOQyHyPGhWkzdCnGfRoH5F+UF2icgehuC3w9FBrzF4wQQrouXNCUHlBfjQwHgKRcD8/N7B+K+Nn+61t0eCel3LXYQNPzoZ22aj2grBahf3PDsZXHEhgTgULwP2W/268mm8E5aIlON2t6bnroD+FyVg1k6doZq0XSN0zMrv+khIsas2b+pI3+3lsDbJcZADycczrzoGX+60fnxJvo4nJD6+AFNm2IRd1oWHmOnFceog4TH6IKOG0MwEIOpv0jnSXHbsKW0+x1SiemWdBSRasYfER+cvtVSJ4sBdV4pWoW1+QoVOaThECxalReHY2XOzcpcyQ15GgIqiUzv+a5yvacfzLWRj3
 /f7xCR2y
 YU/p2umHQiN4WogDuUnnuoseH9fz4cZY6eGozq5AMZgUyw9aiNY1XdSZ5AsGCOh+tW2CoyG0AuHLkrPsH94+NyLauRPre5U/Hx1YCRDbqDdDlZpn22nKSgofV2XElk5z1hCUnbHp9uDLoeDzwFxtNL2lr2ssokwN/OWERnA2c6fdWa9RWCZj4mvqvqMDjBNk6u2zt0Xeq01dKYVzV2lAe+ijge+SsjorhMMRAb1R7Xrez8RBFym+nYy4k9kKncfsZhKKfOzKQI7TPBCPsCtuuoaz6On3rF8HgfSGdSIh7SVcAxPPGkELHm0jJdgBdNdZY2qKIXUAZ8ph7Z5+vZAU9c0cHWRerrmim1dubdTgRhI/g/kkharb+XAHC7j+jIOXhQGSeIPGVloBTAUnDtX0p4piu0CIgbvHjcoGERId8JwNx9sPRZSSePnHSqD4oRW8v3KrBgXkeMUtpzfu19DqTYByyUXdgJBzu5jtmEDk7+nZhz2DAo9sCYq0KXdI7PdEvL9cSB4fuzFkPbrmL9V0t+cabzpr7qOuHymzEc+DFacbK1MmVDBZBdQe2dWSr9O3zwic4nYQCtKt8TPXoG2ehGPjqN17jGjXjLRoyWZZxO1SF1b6p15UVYdFolA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the ptdesc APIs for all page table allocation and free sites to allow
their separate allocation from struct page in the future. Convert the PMD
allocation and free sites to use the generic page table APIs, as they
already use ptdescs.

Pass through init_mm since these are kernel page tables, as
pmd_alloc_one() requires it to identify kernel page tables. Because the
generic implementation does not use the second argument, pass a
placeholder to avoid reimplementing it or risking breakage on other
architectures.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index a4b1b329c23d..72a260007996 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1420,7 +1420,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	pmd_free(&init_mm, pmd);
 	return true;
 }
 
@@ -1549,7 +1549,11 @@ static int alloc_pte_page(pmd_t *pmd)
 
 static int alloc_pmd_page(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	/*
+	 * Pass 0 as a placeholder for the second argument, since the
+	 * generic implementation of pmd_alloc_one() does not use it.
+	 */
+	pmd_t *pmd = pmd_alloc_one(&init_mm, 0);
 	if (!pmd)
 		return -1;
 
-- 
2.53.0


