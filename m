Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971F0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B9C6B0121; Fri, 26 Jun 2026 14:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653C66B0122; Fri, 26 Jun 2026 14:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B0F6B0123; Fri, 26 Jun 2026 14:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27B4E6B0121
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:22:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84A9F164E65
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:37 +0000 (UTC)
X-FDA: 84922884354.05.F1BF8C6
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 54B441C0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="cKN/iAfc";
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782498155;
	b=WxEywDBjRV7mLB2UcnnXKUWbXB+wtQnMXHyRlBxkKP+MZvLZ4ID6y6sthfKDZ66wRM7A9v
	UsKP4ngwxPM7nXK8aoMBbjjOgantM2X9Utav5h1N/30dQrdZwEWqf18IKpSODR358UWep3
	9uGqUhQiKZaOrB7RD+YNr66d/7fLClY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782498155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcsui4ccGNEMg6euNBSFI6gmklxyb2LXsMBiP6Of6n4=;
	b=iAzOLjEh6UVNYE8vOyGsgsQH8PkLbxUZalnHUI0ab1X/rYAnPMx/ITVstEDC9lpW87L5WS
	8hY0dkIL4Tx2BJBW2eQkhKX4xdsvPmpJx9btFdWWQZfK02ruukY4jeCNb4JG/k37Y9mVjs
	IMWp3REuNqBOV0e6roHTIdpUsJ3p8Bs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="cKN/iAfc";
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92213351918so163030485a.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782498154; x=1783102954; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vcsui4ccGNEMg6euNBSFI6gmklxyb2LXsMBiP6Of6n4=;
        b=cKN/iAfcpqV2EkwvzdpbwYkl6Sw/cwSDD0aWbRkuWgd6ZRq2jg+EWFNLwPyshSAA0Y
         RMhB0YVQ41kV6+B1YNBmaAjNmE3gPwY2TajyxiXCbha/+751yVm2aGb46mZlPUNcCPNU
         1x8Hs+YMjnxIOKYewvNmNP68haMgACE5w/AaybYQeInWaXM+5OYw4ceJMCBVBiy3FhV4
         WVxZJJKNLXSBr9FH8micqXo+XrD0IMiUUKI2LNC/vPxO6d2fiVpYp0f9TSotzxpIaGpA
         GNTw1jw1UkRdxuif0zqas+pIS3p3QHXWP5cFr3HQXmqMYhgjzO/QftUdWIAsm3Z9OIhp
         P6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782498154; x=1783102954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vcsui4ccGNEMg6euNBSFI6gmklxyb2LXsMBiP6Of6n4=;
        b=h0tSsCpgye/s+CpC4MGsVxMa9+dMN1ymKwexZQjzNgKVpd+mn/en7npIU2z1qxAXg/
         Lne6Xhv8rFaO1RWuehimXNBLZ/CJz0wGalTw8xiy/cfG4GElN2qpeB5UU+Egy+o/hVIw
         DZTuuzj0HkC+dYEceiOyN7f0rHsSNuZZfhr5/ulyoDefzQjubrQz9gZKKDx6q3ovH//N
         JNojWR50pnIIOYNxSMRJ0L7X8QxbUVSZSdPyL2KMJE/UVfyfEdc/Zvw/euQbhdD8qOIX
         wUpRB1NGu7rNNqB7Q/4nYWecWNUpUzIaLqawK9ZVs5SE+VcnIt9V1MCUnlvo6e9lsvvy
         6VvQ==
X-Forwarded-Encrypted: i=1; AFNElJ/tDYrt9wWew6mu4HcdPDMF9IktblvCVu65bb6+MuvIEjn5uo6NvKo1/hxrSIp2B4i7fsuiva2+KA==@kvack.org
X-Gm-Message-State: AOJu0Yw709yLS83YGyNk1Rg0lPN0d9AqCsb1zXyoEFs3pFplaYhQ66h9
	mOL9DjNWIMWKAFt9r9syWfIECjrLVr2CeFlIQEXf9elmSCF92ECAftzo2Z7VcsNTIfw=
X-Gm-Gg: AfdE7ckxon7ce4qBbH86IAqGZ7IMhYp59zmQZF6KNO37vnXJk6kZIvTk2nOrPFmE2+Q
	HY64E7n+GXZ9BP1z+uwcqt6bfihDhsggRAIcgr3SCjUXht4AzGxt6hHslSOfAlYnUabgklTGaez
	U84vx+AxPi5qo+jOWCH4Ky7cCqlMs8ukuCDnktrmYwa2DH330NP40yVfC1FWADLu9tiQIvbhvBO
	ADEcZibBkbxOoDbOMkrP2Z72cyN2mgDdghgkSxQJNZXybpFmm66MZmDuzVE82aT3/EstzQcK0cH
	bU66cXKt9dTzz1vSTnXGG7TDBDANZp/dLzBrEdl6oXlxhvJM8/mOe5m23rO0gTd9miie8Apem3d
	6ZUXjIvnu8LzRuZwWGH7xxam17/9GbRH32c8VyynS5p45eOKyfTrMGjmDzJRLd6C/c2EaoalcIl
	1ZnlRHGiomoJg=
X-Received: by 2002:a05:620a:370b:b0:918:4137:6be with SMTP id af79cd13be357-9293d0b9ef3mr1327199985a.53.1782498154411;
        Fri, 26 Jun 2026 11:22:34 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92600c7aae6sm1227611085a.44.2026.06.26.11.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 11:22:33 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mm: compaction: support non-movable compaction for pageblock requests
Date: Fri, 26 Jun 2026 14:21:18 -0400
Message-ID: <20260626182215.1107966-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626182215.1107966-1-hannes@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: epz1hknm1n85cryyz5oe96zg5f8tcu19
X-Rspam-User: 
X-Rspamd-Queue-Id: 54B441C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782498155-835594
X-HE-Meta: U2FsdGVkX1+1h0jmtNQw8qp57KrrOf1/ieQSH74RpCRpBQNtDIrxM3EECHsJJGeUTQKB7dLJpXJAx6qPTZr2RKroNHcbDjAjQhCv9lCBEtZ5szNSQjrbbty3lL+jASqLrrL12dRPdDsJX6/NdbZEZVv1qod+CFZa+s+l/5KsSmr0EXRvNvv/u6gilVkiuORIMLPw4sPnQH+McBJbVUXA3oO9MYxAMLhXrjxjavzTenRxctIIRSDZuHmNb/z7oOUIEI5fk+0O8540KSDJcCTwgMcqZbExui9BdDsxzcElpuPzjMGP5b2Eh6FrK1EKnaPHT8b+DYZskNUsbhjES8wXD7pqXHMdry93l5Po26MypVF/o1XnPPelstjOUolyLn4U3pggmw3U0qySO2n1iPEsAe8ORGv9/qZmvddt3Vk8/4ugj2yxPO/BE+mqw38/D/Wkr0OomMaU5/wW0qaCD1n8kXSttEClwMKEzPSqV/lhGZ7olMtOhFu8K+IZ9RaM5rEqTtQphoia5RghiJMfkuEeccG0hXD0umiZIN8rHAKY2HUmotmVpPDoTWPuatTm/6+5doX+UoQLsd67rqame562r6ah9i2cC5QiDn6G2/U995GhDCikO6P1I9X5SViCw2oie1hUUt5k8su2EGl9rKlU+tZ+uW9eZbJGcwkYjkWJxOnKd0MRJcCe3JpWeExXtHiDh6/eqkuz9aRfnDB+wnP2hvFGslax2g6/5PigZA3unUcRuy3Zp4x52wT9Id5fc3fDVQLcdEr0bYuVivOBKBSG7ZeAQQjQQQSRf6focbX/WSiDF7/pZJHJsciR4Fk39EXQ3/AcymdVcb4V3IYlCkvS2G9yDyFVrigIBc4FTOGBdnQrbcvkxUMIZWpuvdd5eUEieBJ4hSXbb81X9mTVRnHQdi+Fq1axkr5okaZ4ZzoeYidcwdPsV9RUCtbg3f9FCpW6WJRd7/PrmNVe63HOqUX
 dJOL2OF+
 u/xztuQfS+drC4ACZE6wmWvEMAnUoInHj3k0uObIjfKv0uiDmcQj3JjlZSwP83sy4QbCXEdxGmcpUI6DSVeSWPqlUybMSW6HvcOrNaKLc0nE46DLdEpKgDLA7ybvgpJvLPWoRYRgNouEInBODaynUl85DGV+FL7CAjJgOMR+yOT+F8JazWvtAnA3NjkbDMWBcmviLI1okXXM92krAPQYhG7GjO3NgChW5tLRhTRzBOCjlMr0QcCNu2p/Se0SU1w+Nj8FAY2XTg9eVQCTc7r+Ks3/QCZYdF1SauWvg0HRyRsOk5gZ7Hd8R8qHDYXHKOJQvC3aQJuZJ5DxLV10LwA+ufCg3e7KfBkwsWLuRwiOf6Zl6IlsNfs4/pKYDCYNyxe74WvGt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While trying to fix a reclaim storm in defrag_mode, I noticed that
non-movable direct compaction is extremely inefficient.

When searching for space to evacuate, compaction only allows blocks of
the same type as the incoming request. This is to prevent migratetype
pollution, where a small non-movable request frees space in a movable
block and provokes the allocator to fall back and pollute it.

This protection is reasonable on one hand, but the downside is that it
makes non-movable direct compaction nearly useless: if we get the type
annotations right, by definition there aren't any movable pages inside
the non-movable blocks it is allowed to scan.

With defrag_mode, the goal is the production of whole blocks, which
are essentially type neutral: __rmqueue_claim() will convert them
wholesale on alloc. This makes type mixing and pollution a non-issue.

Fix the pollution gates to take the requested order into account, and
allow whole-block requests to scan blocks of other types.

The only exception is CMA blocks. That type is sticky and these blocks
cannot be claimed to other types. Continue to be strict with them, and
allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/compaction.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f08765ade014..7df3a85d43af 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1381,12 +1381,33 @@ static bool suitable_migration_source(struct compact_control *cc,
 	if (pageblock_skip_persistent(page))
 		return false;
 
-	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
+	/*
+	 * Background compaction produces blocks for the zone at
+	 * large, with no particular allocation context. Allow all
+	 * block types, including CMA.
+	 */
+	if (!cc->direct_compaction)
 		return true;
 
 	block_mt = get_pageblock_migratetype(page);
 
-	if (cc->migratetype == MIGRATE_MOVABLE)
+	/*
+	 * CMA pages can only be taken by ALLOC_CMA requests. For anybody
+	 * else, vacating a CMA block consumes free pages the caller
+	 * could have used, and produces free pages it cannot.
+	 */
+	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
+		return false;
+
+	if (cc->mode != MIGRATE_ASYNC)
+		return true;
+
+	/*
+	 * Prevent small unmovable/reclaimable requests from polluting
+	 * movable blocks through fallbacks. Whole-block production is
+	 * exempt as the allocator claims and converts these.
+	 */
+	if (cc->migratetype == MIGRATE_MOVABLE || cc->order >= pageblock_order)
 		return is_migrate_movable(block_mt);
 	else
 		return block_mt == cc->migratetype;
@@ -1974,12 +1995,12 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		return pfn;
 
 	/*
-	 * Only allow kcompactd and direct requests for movable pages to
-	 * quickly clear out a MOVABLE pageblock for allocation. This
-	 * reduces the risk that a large movable pageblock is freed for
-	 * an unmovable/reclaimable small allocation.
+	 * Prevent small unmovable/reclaimable requests from polluting
+	 * movable blocks through fallbacks. Whole-block production is
+	 * exempt as the allocator claims and converts these.
 	 */
-	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE)
+	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE &&
+	    cc->order < pageblock_order)
 		return pfn;
 
 	/*
-- 
2.54.0


