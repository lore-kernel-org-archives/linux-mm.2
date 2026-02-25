Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD3D0FD3775
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BBDB6B00D1; Wed, 25 Feb 2026 11:34:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975946B00D2; Wed, 25 Feb 2026 11:34:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3316B00D3; Wed, 25 Feb 2026 11:34:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8496B00D1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C46E1B718E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:57 +0000 (UTC)
X-FDA: 84483528234.04.4A596E8
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id A9ABF1A0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Cr2735LR;
	spf=pass (imf19.hostedemail.com: domain of 3riSfaQgKCMcwnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3riSfaQgKCMcwnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TMbZ0g7Oj0OTJpFiuJio0PTSnHyS2DbyRdcs0PvRcU=;
	b=SDLPhtTFMiYnu+3M8s0E/pPxbBxfvPRZQQ4QMK/Eo1grNSV2bmI4JTeKZM5R3nSNp8uVJ1
	3Ipb39Iz3fUxTrItPTiRGnX6Z9mUdIP7D+IPeV2M5rN1lim8RW56d9iK1QgOfWNt9XEWzR
	cfA8QtjpkRNspAlEtLaD2fNhNMBQRGY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Cr2735LR;
	spf=pass (imf19.hostedemail.com: domain of 3riSfaQgKCMcwnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3riSfaQgKCMcwnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037295; a=rsa-sha256;
	cv=none;
	b=I7BG85YcG8g6BJWRvODas1Hsq5vM2jt4vRX31u8zUVkA0VN8A//7usyhMIiEsPi70WXomk
	FY9hRz0mr3Z38WgANZ0VVVJcscOZzRB2BlDuuXhO/pYgqXxSwqhJRmyvuhemGS/ZEedubc
	z8LEmSwy4XuVBuomyfNRpSmDGmqpPy4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836bf1a920so72599035e9.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037294; x=1772642094; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3TMbZ0g7Oj0OTJpFiuJio0PTSnHyS2DbyRdcs0PvRcU=;
        b=Cr2735LR+kp0nhCCfn0u/XKtKL+e+jpPSkH0SKJXMOlbPnFJ9x4lyotZ28IXY7Ni3g
         3FoUd948FaYrVHPshDiC2LRw7Jo/zR7J8eoe4ZGTup0kcppFoozLiIeajJ7mGU8/ZQ3b
         wanLii1/PVi2M4lGtoN3HyhEagzF6OGoCIKKGSAVjCJ4Rlxn1nVg2hHSuw0HNee4M+Pm
         Z4kXUE+sSMgM1CetXkwKqsdCnEBPKaADrqoYCwXZZLhi6W6E5kJrW//+tri+U6vyDCV5
         EJauwZ8tx2PB9U7MFU9S8ZnmuX+yomvsLmJwJgsq0MfYIqFMT0abIM/LgpcQOTUYA0DH
         /Fqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037294; x=1772642094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3TMbZ0g7Oj0OTJpFiuJio0PTSnHyS2DbyRdcs0PvRcU=;
        b=kD/R9puHd3VcEqIenDJpAGQOkBb8IwdVr14OBMfYX5x3dDccg83+GlPCL3zCMTAakJ
         96yvN9lPf6hLuCZFeeOCkGb4bfPWbCYUbV3FP7RyupqmyoSE1W0nN4GmTVvFrECO8Z9+
         5kzN+uAP2M5EcfDE+jQjGw5DCN8puuS8OI/Xgc9PBJGv7JAt6PmbQGPV+re+hEvyKaeW
         uJcfB7aMrgKjZj0FNB9yiojavJycu6ev/F7/Px5c3lqroIWA4t7EHj7ZFPacekpV60K6
         PD+AfNQfYKyY8w6qeoO4NRMGhxWT2ocADKenXrlYx3CLHY/do/CbAaz59h1i3hCX/lVg
         LNaQ==
X-Gm-Message-State: AOJu0YzJ+wGZ9qrZPrAti5qY0YRvrnzkag9u8+ZC4wkYBi4ZOqb+YYRF
	R2qvGi7DOb1I3/cImm2JxxT7UoD8qVl5IRjk6QlLA4T9sa+n2azb3wyizvNuAFdWAdQhT3hcBZS
	aPdF16V1mE9UqWg==
X-Received: from wmbjj16.prod.google.com ([2002:a05:600c:6a10:b0:483:702a:341c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d12:b0:483:5310:dc67 with SMTP id 5b1f17b1804b1-483c219b626mr16094975e9.20.1772037294131;
 Wed, 25 Feb 2026 08:34:54 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:38 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-13-e8808a03cd66@google.com>
Subject: [PATCH RFC 13/19] mm/page_alloc: remove ifdefs from pindex helpers
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: A9ABF1A0004
X-Stat-Signature: qxsm6ezt4ekcorq7txas9zea97kuc9t3
X-HE-Tag: 1772037295-656179
X-HE-Meta: U2FsdGVkX19T5nIAvanAIWNMz2+PU4rlp9yQCw9hSLSbhLXwx+KTknEhYX7Vz0GHlxLYkea79qegE8wpn1VctKXbOisNr8MhRMdTgTiN1rghvmmGT4Id5luJ7hGCjzqy7G7/51GJEngw7zgj6OMMnjmylSv05k+P+XksxOa9o1VyOySrlTG7EDIrTBzVd7we5XGCTUNIb/qO2cXHfr3TpXafA+xkhhZ0S1JyJmZ0lTe5xPx3aQpePeynFm7yZcX6issozGip52hwjMipant5OAPRTk1MWxDYxNTBJT9kmqdZwzur3Ku8Rcsz3uhwkkOXNnyLI824D6zq1heZNn+4/26nivMJgaSa0OxY05uTDiT3DUY8KQ9CNLoPKaNH+Eoa1op1AMaOZXBdtCshdiJBdkoDMP1tL/vQ/YtRgxVULst99C2oioAibh+FhAN5E9UHJvvRfEQdNxJ+m4HuftdvoBUevF9Af1qvUoiZR9TniOga4L9d2FbiRZI8uvJRaN6+XwSrDjuWgryyFAe+DF91CRpaaTCLj28BUyEjC9XmbG7dD863xh+HshDT6fF5+k8hCJzJIQ9B+ANyUHDphziXS/115OPRyIKwAKuZ0zCIdKsqZg0GSvpxE7hbKoSEtW/ie4xheSuF7n40mOn0oPZEqyL1FxcT9aZUvoyX0W4/4QuSpeF7vV9HII51Qo88VADLHy7i4CFFKAJyb+4hv30Iiz1yv4cWS3/d2g6ZkDiDt2H1YgYp9eTj4hKgegEaVl6mwfXGPZmIL408PoaXImMmEP/iKX5+X5RLszTBNcZroleL+Zn8VL36PzlJTaA51vAb9VMQWYL3yJVpwT0cdvkrUiwW67BtJnV3PVAQAoqgUQKmpSLDsr07YR/wmRfEuCO/HbsApcVl0xFgAHT0BUUKfA9SQATb4gw7FzpH2CsTKgLz67nmf2eynGfxsz/l5RaSjfVmDWwaJo7tbYkUb5T
 yMNYquyz
 NTU/gpu8cHFDDbBClo8N23Xd3Xuk+k42flqQmFIVcxJCrAt2/vErEmjczi9Ela8Gf2o57VMgG9i2LQ+k3oP5dh97evbgu4SUzopUx1tYhP5+vgFq0uN5eNHlLRk8wd9pmqQuRXgFXOn7WQJRdezFWk+D0n2NMBJhQlAX7MGu735CflhAsVZvpRVPIobQ/GufjUzK/sxfXTO/1bg7zCf03K4CQReU6b6UjmZL05I4bFiWodUFaJP3XoQ/YShQsM9DHjzU9QOhvMb0R+1ISpdNNw3xEVfEpVsEOs16D0FIyVAitcCENOFkLBr2568bPplZyGq9PssXB8c7ZF6ro5IzFIXizG7uLIrdOfmHo9MmjGvUYoOKsX7yQPzAZ/onI7P1ztWl+goIlOWTxEYvhHcJwHYfxng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ifdefs are not technically needed here, everything used here is
always defined.

They aren't doing much harm right now but a following patch will
complicate these functions. Switching to IS_ENABLED() makes the code a
bit less tiresome to read.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b79f81b64d9d7..fa12fff2182c7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -731,19 +731,17 @@ static void bad_page(struct page *page, const char *reason)
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		bool movable = migratetype == MIGRATE_MOVABLE;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(order != HPAGE_PMD_ORDER);
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			VM_BUG_ON(order != HPAGE_PMD_ORDER);
 
-		movable = migratetype == MIGRATE_MOVABLE;
-
-		return NR_LOWORDER_PCP_LISTS + movable;
+			return NR_LOWORDER_PCP_LISTS + movable;
+		}
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
@@ -752,12 +750,12 @@ static inline int pindex_to_order(unsigned int pindex)
 {
 	int order = pindex / MIGRATE_PCPTYPES;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex >= NR_LOWORDER_PCP_LISTS)
-		order = HPAGE_PMD_ORDER;
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (pindex >= NR_LOWORDER_PCP_LISTS)
+			order = HPAGE_PMD_ORDER;
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+	}
 
 	return order;
 }

-- 
2.51.2


