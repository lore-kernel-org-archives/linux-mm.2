Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C7FECD6E0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1124E6B0092; Wed, 11 Feb 2026 14:52:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A6B6B0093; Wed, 11 Feb 2026 14:52:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E476B0095; Wed, 11 Feb 2026 14:52:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D29166B0092
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:52:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A338AD6D9C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:54 +0000 (UTC)
X-FDA: 84433223868.27.0A8F56E
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id C25C520010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YvYUuLI3;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770839572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ga0aGdYXFgX1ter7TBdhMViz8gXJdTbwK+zBh1REc8s=;
	b=sjn36LkIwGTjtx4Pr168sVW8aWscifqcej8XmMLJJsKUj1vw7ZgkB66XjrLIdGg+URBQY1
	22TmY+h/zMfKltuxrEO25+RRZjJdL1bR1aAJi/kpUF+n8La3dt2SPgHMZaTBOQyaird2HA
	t5LOS7X7sx39Kz9285ntNe6jrr8+GbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770839572; a=rsa-sha256;
	cv=none;
	b=jiD4k2DXGMT2Ter/aQkvwi5Xtzjyv3CtFbQdkFB1WWq6EgGyK7heBBb2RWOgmTIi9QU90Y
	WIYH5KY3anKKwqeEhx4PE8B5PGIQiaZrdWMSlpDSNL+HCQu6vstxkBI+GFYe8ZXh57Q4En
	YUoMTFn+JnAeDNfwM15vRfxqLDYZtCE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YvYUuLI3;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-12336c0a8b6so2484774c88.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770839571; x=1771444371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ga0aGdYXFgX1ter7TBdhMViz8gXJdTbwK+zBh1REc8s=;
        b=YvYUuLI3pmKd3+Km1mwS9YTMw7xi07ZII/+tzbbEbVyETYxGz50glpjYHk4nmF9zRJ
         4uXZ8540gQIfnwXF+aCid6Uv5/QE2YnvMBGAzGrXteOCAa26iAIMi5hV+Fh9ipDV1vrH
         h9ZaScMKTWaK4wHxktywePVzp2N5eYEzSE9PkT/Rs/BFOGINtBkIXMF5yoPAll/dVT2r
         4Wxnwy/9AeP3Q2qEalLj18de99KdY1GHwTb71t6YBp9SmF1xvonNXWAuvrpqUEr689Tc
         ClfoeP/B4f4GSMds24z4DHkrB0EDfzQIqYvf/M30ULo16EkW5wyngHG1NW/z664yyHVB
         E/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770839571; x=1771444371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ga0aGdYXFgX1ter7TBdhMViz8gXJdTbwK+zBh1REc8s=;
        b=TO57ImG+2aY3zJNUVUV420yl62J9u/yP8CBm7Y8kRUtT12u8Baf5SBCLQtWvSnncfU
         ozwPO+qmVe2xccECfGg5aQQdwbjum3kslCVmCPibNdFww3x867yPRel1rF1It4kZU7yv
         4iuka1TVgg9RuWys9cFjaOC/h0Xbq2XMn6og+Aj5iuAmOxrGDaOpBqMaRlm/5KYaipYO
         vmwcdUNN5vYAQnTo7oRM8saB+S2ghuPoLKgLZ/FJD9G0HOWzlBacSjhWZqWUVy1OKNZ7
         5Yaq6y7A1lRueQ2GrksgTmSZ6Yb7qVl9LvLcqh4RP1J2rT60UJKj20HTGXVrBq+g5IhN
         FYdA==
X-Forwarded-Encrypted: i=1; AJvYcCVTcDtgoLORzajccxq/UwrpMr8l88mA7rJCR7ydL3vBjXPHnBzVUE4K8WuW3c8xMPLpjjQPM3DnRg==@kvack.org
X-Gm-Message-State: AOJu0YxEC7obPGlXYPHWias+Cnu+n5KFfQy2VfSFaa9VeBA0ke4YhPeJ
	yzhBD21xRYAckFEjGwB0PvTPXA2FcwM9bCRSf7mcVpdijvd+yHCo3IPo
X-Gm-Gg: AZuq6aKKBGuqGdMLeGwWCoBfo1lpQy4++awO+a5Uh/x2ocNEYqU+3QlyV+4sRuLPH6L
	oR+qJwqThpiIYsfN8D8OaxLZizLZBu1zrXPfxDP7PRBQVI+yt5v7ZrcrTMgktAZ2pq8vm/jyQ3b
	rKRMfRVHjwKKSIoZRSzv4v20TU/me9c0exh3C/csJhWXIvL2fujrAphU1YYaUC8eo14gI6IkZHf
	ni3j0uRj8BA8VJsSzfsvwOW1HyN46uTFoXmvB/EKOFFfZWOTXyemF57+lS4x98YmtTJiMFI9zku
	6WoQ7Z04h4jsPxoNBsWYXSosAfEjd+DhoqSeoFrjGkV5hxBa21Ut0dc6vJrIsmaQL27hSm9bSFb
	3K0BCDU1VdoOsRmvgeDHXc26tx90k4wTM56rf17N1zrci330vnxXbGI/cPwN1g18m5vxGe5DTB5
	yFvFGudX/ex2sHJGL4Mzn7GLlesX8W9w+N6vmyWIh1OjxOjSnEjXcgQSk=
X-Received: by 2002:a05:7300:7b92:b0:2ba:9b30:37f3 with SMTP id 5a478bee46e88-2baa7f7e7f5mr213179eec.6.1770839571412;
        Wed, 11 Feb 2026 11:52:51 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2ba9dcfe6b7sm2426463eec.29.2026.02.11.11.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:52:50 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 4/4] x86/mm/pat: Convert split_large_page() to use ptdescs
Date: Wed, 11 Feb 2026 11:52:33 -0800
Message-ID: <20260211195233.368497-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260211195233.368497-1-vishal.moola@gmail.com>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C25C520010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: r8fe7kr9cqbgitbjapx4gixt6hasf3bb
X-HE-Tag: 1770839572-43879
X-HE-Meta: U2FsdGVkX1+H3LNiXPrUOb0GMYEpmNX3BbWlZ9BclGyJyq/HR2RSFMB+p07QxDBLvDN22gfh8AbPxv6xzJ/etn3YWD6P5W+3XRWTkLoVKf4srWoEw2vrN1e6QqQOZiKg1w+nLRElXQ2/4VUOk9zKA3VwKD599I1Tb1Ly/wtKRf2ohn5W5nuVOolfPe2RW1L2dw75Uu/XuhOaHGF78VBzXdIWrpkULjjals84kWq1c+ieG46aq8ZBvL5H8YAECeeNjusfGtQ42JGrj9wmeZRUubC9T6pQItXj/qg7lN1jz4kdmZm1zcqlDYoJIZpeGeyuWCz66RvLXZxqbVEn9L+2jX9l55mgFCZPwfmHJqk4fWr2ICKjxCXFrEHa1FU7chBvxfaTmGeRpbAIKHGVy09K/eMCKU1X6KuPWcTIbPXzdpgRzcFiUNSToEuspNDQC+qmHnXWx4X++ksRSG5U2bnaXPagAdyuOKQvxtO2JuBc8GDK6IBxmFP8osMk4013jgzmMCcFhFGKSh+2hnS1LtYH4HuV7QuulCiFwHbLVysKKApGgOv2KOaLwfO744wItK4fUyVGKojMR7L5iepY7/cdQCpzUlKnW89b3KncrgefNbaGP39NMsacDxGizEnlC36SOcwPy8tD3JwtQfw8pM19eI2/QDEuTRVzWGrU9EIyqJmLgG9GPF29juQLQZGPjYCxzxNCN5t1YnIzZvidMTQVj0InMrEzpkSdhh/LuFDtR6sQLkp0aKFFxoXu6h2c1T7sSbU5GyutskTW4VjHSDZvz30I0RUq07OQWvvx9tnZZc1SV5yCXcc3CG9pcmSmfLjdJVJoxw1RIvE64vt5bc7SFCBOMnpcHhm+32LHgRzFDoprxi+vN15qq71CWgdI6HaOOcGQBLpCqDR92rB2BYhj/L09OiwcrHJSTfFpS023AJ+2iRqeMMyYNjiPG7D/lK+9K6l/uXOIYJ+Kf5sOGe1
 MwJdhsei
 rp3q9JKuS1DkmYrTUylMxaQf1uIsG/Yv/Zu/LwmpYWhMTIsu3h/vX/9xaBKqMmfdNvc+kaC9Dl7RSpYvnO2iMliDUzGlxVkQXZ71FJuaP8Ih5vyASidhPEscGyxv3Ux4+5G0s4j0Lx8BMfwJJB0a/GclLSJwdcL1YYdUJnJ1VeMftC002jKuVWFkRcaUwycBq5TMfxpPZ3oTp94eADssQmqcRBN+5Kr0t7UPPpp7vyTMjkTQrzP6QtsE99TCEuAPp8gjo4sgfRtyT4nZVDr4N8muuiWe9BLZOnUZpJGnvioKX/rTIvY18uNMTIXYC4kOcLPQZCuVi/omo01Ou8GoGljPaA3wtFNeNfODHfSti1u5M3aWnkO5XaAgpmKpw9mv3Vdh8e1z+3L62P9dhk3IVukBQ/ZEg76IH+z3L2ucK8sjgbstwIfjpmF/cErkukJAMErjWkFSuB1aj8a+9lXpQRWHXCQoDM8VoNKzpeH8YbkjQ86ZNdwgFPvzqtbnVBxiZ+7jHpLus7xc75UWLAHmz1kr8cAwMeWztT///NWeDa/puRmCZCwJpIBbp1bbRUB1Z8cVvVII09nT7k34=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions.

split_large_page() allocates a page to be used as a page table. This
should be allocating a ptdesc, so convert it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 9d6681443e54..dfaec7b16ac4 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1119,9 +1119,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct page *base)
+		   struct ptdesc *ptdesc)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned int i, level;
 	pgprot_t ref_prot;
@@ -1226,18 +1227,18 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct page *base;
+	struct ptdesc *ptdesc;
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
-	if (!base)
+	if (!ptdesc)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, base))
-		__free_page(base);
+	if (__split_large_page(cpa, kpte, address, ptdesc))
+		pagetable_free(ptdesc);
 
 	return 0;
 }
-- 
2.52.0


