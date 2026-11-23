Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256A9606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o4SwRy01
Received: by kanga.kvack.org (Postfix)
	id 436C76B05B1; Sun, 22 Nov 2026 22:25:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0406B05B2; Sun, 22 Nov 2026 22:25:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5E16B05B3; Sun, 22 Nov 2026 22:25:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1011C6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:25:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 962031C41C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:25:23 +0000 (UTC)
X-FDA: 85464943326.23.94B2789
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id E1A03C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:25:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=o4SwRy01;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of raizudeen.kerneldev@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=raizudeen.kerneldev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795404322;
	b=6PVXh0SIIkmLvjE1Dcs1727dZac4udyQ/nJkJHikdqce3nFaiziAxW4P/UvG3w0SBNsF+3
	CKCWJc0/XXwM6E/uehMS0dnXBO7Moj9aYEBUmuK6N4RGdsknm2bbftHc82+yR5+xw7ryB0
	hxiaonSaIBmJxXfpoPmGQR+u8gLhnRU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795404322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Hjsx441+A3L3gxU883GSqRGMok4wbhrMVBrQT8f02Ug=;
	b=8P+0yMNKnQ2tfdlxAOHvXs24kH6mEBD9wVdX0z0JKlbA1dWPanufEEjZVjE3Fq8ArxL9ij
	D7xAEa/S/k0GgAYSbrlwujR1QOcN95TXhFnfSFbV/3BOi5LA859G/tP1zuofO8DI42NBwY
	dn8+SezaLjBMTyXggIqAR0sW87uPaS4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=o4SwRy01;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of raizudeen.kerneldev@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=raizudeen.kerneldev@gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-38431138772so3624258eec.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795404321; x=1796009121; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hjsx441+A3L3gxU883GSqRGMok4wbhrMVBrQT8f02Ug=;
        b=o4SwRy01c8awoSnjgOqRELZBe9aYICfKpFijVElfb8KKWOEvKvkRt365/oBWEeFUBx
         pNiKe5RZ0EhPXF/gOTlbv8yoq8Reb3GfddpWHJgyXx3jOMSzCtuAsxxY5rlhlfgkftOa
         R5HtCJ7Qgta5n6pDdQS2Y0+3jNMh/1AqKtlFKPBQFhIDDekHmwIklKqf3UEl7P/wCdYj
         mj9PLKRveMrMwUQ1QJkXiavlfFp+8OMA5tfZQqwT/eHgSU2tlwzZ5y51bvJ0raznkjCd
         WqdTuFwkGIyu9H0wxsmoMjD8QKjCaZ00z3wKv3T1gI/Xyr97597fu63l/HwvVIH3ueBq
         zuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795404321; x=1796009121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hjsx441+A3L3gxU883GSqRGMok4wbhrMVBrQT8f02Ug=;
        b=aYHTt3jf9EYtIc8pEAKF44vW8HAyKCJMD6GU1Ss4WLdvIgExSXeYC0z35F0xellvGc
         z6qaFaEsnZL/+15BwPINWKwtQbWXWbzaqbhe/Vu1/PkjqKZc/OUPGqRjur8KKg1jvAoh
         wL7w8bVsXr7IONgxHtCKZrg+QGrlW3vsYB92MpqamFOJHJa+8U5M/4rLn6sWz+VV5Zqs
         s8KJtXiPASj69q3oCy8/t8c69OI+SewE14sKG/zznYGf+8TfVppgsEEtiCrhAB1UOGzE
         tXEtjDOup7uFSAVDieczkVqbpLDAOHipJOoO5yrR/jEVica42ADfm8VfkTK76nG8nhV+
         yjGw==
X-Forwarded-Encrypted: i=1; AL+hErEGsKOvkvMFEscV6PFNYg4h4B2CFsaQj+X/dyP8OiliA/AX8CwKXid2nl9mjsU0WstOzK7jKyYrcA==@kvack.org
X-Gm-Message-State: APuU4Z89LsXY/WuPu5s284gKRKVp9AwpV46hfEL7SJja+mwYxWvuzlRr
	2cRNBjH9mNnnaOiYT9kV5cydNYkvETtODgwGEK2M8OcE96/vp1sNpgDl
X-Gm-Gg: AZFdTZePQ0Curjhc/g/SwfjR4FJIT32+8lFzQedmsvGMkWsJ+E9vX9cMNJiVzFX1i3Q
	d1NrtfPV2SoiMYsA0tl9CHcbwnorrxrqhDB2lLpIZYp9aV8mOI6tuRocbecGduzqSUVFrjKrvhb
	vVoGG1uRbL1NuYLtC8fb4GN9zr0d8FTaWZhmSS6c6h3c0BQGdiZIPrOMVCxjN+pgqe+F7cuOoAx
	PDxti75z7oI5RrXsAXSAY3lH7trj3TqCWPhLHhjmVLd0Q4pb33cgbtvmg/QMPFR7a3z5Kj4o0qa
	kdWgtjqDpyPcN5Ygpw5YHtvVOU5tm+Hp/ABC3WlQb1hbHbocINgP8RML9+yFJZy2aUlJTuyCerD
	yktdPc8GEAzS0LqP27n4QXS5654pECHwrYiwSwE/8fAobmLUhmVPK93GjNcqInROT+ToJviBxdf
	uT5Oi04oIAllIXuyQ3R7dKuBYTrjQP3x2MdL+G9rGByppj3jZ8GgjpDMyId3T4ZxRgKgbdqUlf7
	LVzWYXZbU913wbDZdBdEw+HdVFSdnBdlfh5rSkpJpdDH2eoDNOCE4qIJ+OPDjwWexritqtjuKDA
	ezJ0JUxdSpd44Ee34MXseHlEWLaenIoC+njZhoP5hPO38KQm
X-Received: by 2002:a05:7301:1a02:b0:376:b957:c08 with SMTP id 5a478bee46e88-3856fe5acd0mr10396229eec.9.1795404320560;
        Sun, 22 Nov 2026 19:25:20 -0800 (PST)
Received: from kernel ([103.219.206.95])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385646633d0sm52822820eec.3.2026.11.22.19.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 19:25:20 -0800 (PST)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: chengming.zhou@linux.dev,
	yosry@kernel.org
Cc: hannes@cmpxchg.org,
	nphamcs@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH] mm: zswap: remove dead length check in zswap_store_page()
Date: Mon, 23 Nov 2026 08:55:12 +0530
Message-ID: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 88nnpk5fais6jzh9sx1bupy8ux15fnwx
X-Rspam-User:
X-Rspamd-Queue-Id: E1A03C0005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795404321-901738
X-HE-Meta: U2FsdGVkX19lAH+mcF73RNJRjFde94cEd3zzLhg/gyeZ4wjZA8OK1t+BUernUFjP/qVBGglY6xgtHzcn7nHD8mbYj+iS6KQhVmCisIRWpcBy9Ur2e0LLEQot47dY+DiPWHQ8A64x77l4DUPV/m4ipewgQgGRp35qRO9uUnPHv/41/ZioPEOnWDzZkNo7dutOIUceJwfRYbNXRZahhxze/5KIVB7q4/aumGsLvSr3Bf7y1nCBC3gfOpXMwMtExQ2S0bdYacBgS/N+1JkyLS+OACmFY8aW25uXi/omvS7zLc8vwTUMp4sBuICmMF76XC0hjU5dvUtGtbKtfFosnsPUXfTQX0JreodaMy8Z8PlAuA9ZbUlp6O/sVyvspfFMTiCOWKsWeBmvYP8JUGhNfoc2ijICVB/edsM5uMfVW7NqGxZe3kTfWTJT84jnk+3GHaqWxOeD6eLhJEvNWdSiGIq6BDxC23McX3RgOSAf5DQoZeZz4/BDOTXUYEU7xkUIvjydpRA6ZvUGyDq+TzYewfBZavPgP54Z1vZLGaf8CWWO26oVZmhoMX2lNOie+hHFO8asasRMmyFGsAaFm3kFmQ8yTpqsVudjfdhHbzHWppY9JwIFz28UFzWIBFXS9bZZWIPSxhWzVaBYzVF3CwokfA1xcpFRPU0wFh5PhyA9CjAQX2TuorM1Ps032JLvyfGx6flNX9fWM1Q79e5pt27MO/xeM7vUztLkBXN0+R6zvF/QqBIdfvQ8+KVAiYBTNc7pO1Zliz7ZEY2Y65lo/j+fkB8dtAdjdOfOqztLABrRGErbZV1IUu1oK2G/Itd7Woxz+AONCRNVb3/i4nQFOGTdv+UPD4EdOf1pLTqm6S4FxzWl12o9hhKFD3UgXm8Y9dICeWT66LkwnHT90aTWh8Js/fLMHW1WKYMkrL/aLUyR+OuP0xijUd4EyL0QYS/07meR98Iwlx9ChA9s5XwKRLf1ge8
 Xo8UIfkm
 xoRHyCIEkMNRsJndf5yAlXjgN06EedHnrw+pFGwJBOLH0rK59rj98sFZvu6au81bR+FiC5i3LI2B7ptVcUChU/ejI0bEt52EOURSU5Wkw3g9Of86uEKOhmETOq0poUV1kgcCNcXBtdRDW7P6JNLuM7khGEUaoi0mOlHGXusnqDIylebSCD7F3IuIU1xGIQLmQCRGQN1/squkmQfZhowfTAcXEaJOWAvf4uKW4Pypaiotx0yJYBkBtBq9tXUlDIh/9AkR0fh1s+CIDDzHuACYP8CVFxmuqLqoFc/lU2BUeGXLRNvLZSEivJTP0mHi9XGfEaSjpvhuAW8tfGArKSorf8zZXU3Q1+coobFIOAgCm6oNu69xoVkWeuB+YYgL0WxyXsRhAlo/8V1HoYSNXTtrq5XdV063DEyC/QAaK/EvDRl8kwa10Y9QCn8k/UEr94u/XUlvm7k4aiZTBv4uU4iaJhv+N/1cvIBQ091u47c2AMcYKwANkUGVKfI2QF3GHPmnjauocF1r6oSbAh+3Q4RjXW7uVKtWQM0cGFrwzuF79/cGBXWCTWNF7hxFCSD5tw1wcdak+FGj+FMq79m+59MfQX3SWE3vMXDA6rVvTqdpNAfSgAhpNGufZAR2V5SnXRED+7xDgQtxTiTeVG+ogBmsK+dgQpR2bHUnzFmZ0YhrTnlgNw79qGSdtvOAHzfINQ19uWdxpEfTYOzvEbEpuv+NZBpRwEefBc8PuE250nxnzs0aF8f7cEg0aBRiKYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zswap_compress() never succeeds with entry->length == 0, so the
condition is always true. Remove it.

Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 mm/zswap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced..9590f333d83f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1509,10 +1509,8 @@ static bool zswap_store_page(struct folio *folio, long index,
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;
-	if (entry->length) {
-		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(entry);
-	}
+	INIT_LIST_HEAD(&entry->lru);
+	zswap_lru_add(entry);
 
 	return true;
 
-- 
2.53.0


