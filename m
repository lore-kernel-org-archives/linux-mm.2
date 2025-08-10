Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A93CC87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 21:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DA26B00CB; Sun, 10 Aug 2025 17:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE556B00CC; Sun, 10 Aug 2025 17:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B6F6B00CD; Sun, 10 Aug 2025 17:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85E846B00CB
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 17:48:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CAC4E596FC
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 21:48:27 +0000 (UTC)
X-FDA: 83762187054.10.F2916BE
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2912FC0002
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 21:48:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lfsd4V2S;
	spf=pass (imf10.hostedemail.com: domain of thorsten.blum@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754862506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DsRVIjvDJuLJuwcP7K5TKBV9TNHb6qj3xLt5+6zs3GM=;
	b=jq6WSM9GTispFsOP52OHyLsvUHJBywcD1OK86+ieC8rEzCDReN1lBCKuQ57wEQI0ENe+py
	mUu18BgPW9a767YfbBd0l/s+yRQuQmnKBbhfyU7TLmZdNX2eZHKxn6vt+VhSb/pRKPz29c
	ndk98Xsc70hdRyWekpol2V4aGdPjuLc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754862506; a=rsa-sha256;
	cv=none;
	b=q9Fmrz43WvQDzDGcEqnCeMuTd7HRf6LWWbgEah/iQj+9tkzQuGGNR6aNoIzK9+wBPBqRg/
	XH5vsr7fXiNe0Hnd7Hybm7mCmTtxjWXH6abh+y2k3x2t06A3P7ICDDyxIJf1arBsAORc85
	tMQctFjk6vOmPqi3RiGLDmoLmeyDWEk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lfsd4V2S;
	spf=pass (imf10.hostedemail.com: domain of thorsten.blum@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754862504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DsRVIjvDJuLJuwcP7K5TKBV9TNHb6qj3xLt5+6zs3GM=;
	b=lfsd4V2SOoMxEgiM0wJIKj0X+EcFtGa0V6VxZQV0ByYt9LYlK7rK7pgLUviBqrIMP/4JV7
	78QxrhLiu2Ue059XakSSOWpwlmELJ4VJge6d/5OF9z8JQx8wSrLgTGQ+RlcqkSmFvO0lHQ
	iR2VCimTkLCY5s8TeK0sRwcmHUghw8s=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/hugetlb: Use max() to simplify hugetlb_vmemmap_optimizable_size()
Date: Sun, 10 Aug 2025 23:47:45 +0200
Message-ID: <20250810214745.2368-2-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2912FC0002
X-Stat-Signature: qt3bod8ckiyof7ub3ywa5ib5euer4zu8
X-Rspam-User: 
X-HE-Tag: 1754862505-912260
X-HE-Meta: U2FsdGVkX18UAxJ0Sd+6dp1YN03QHykIYkN9Ammlfahdf+xFX4fOgWE/9cHZdc3iaQqgpinQZD4DrVlmDXltm8tFs0b3tcAmSlORQ2J7pAdJHrYSD2n5Z0fAz93KFEuDxLd1yOvXW1HhABYrE60K75siFLTUseQ7NSdwsy/H9UHWFXAs8/rH7B96gESOzyDa4k+CKgDqQ7ufNQfErIpCTyewk9xNftlO51eoETYCv8H7HcmSsjn3bwl7pTFn6lSvpLazoKgE+Y3kEUGH6ZAKpbjZJFvB4t7rmfGtbOZjQd7X0Sfss6vKYxu+USaTGM8KkbcvIZ6lXGpkUSiGukxZpRXtARY8/5VqbTA3RkLnfsrKuHSC+zx8Xv6waSXusNGN/f9IcyWMa0AU+z8yQ9LCGvJgWzTeynZEc4f7ZoGQUFerCF73AJ76IHv+zC7+PYeRGQ3nb7JAL9/008ws7oKvOvqLCel1YMZcH3+nFHqqhCXpo2K8y+R/sUOS7RNP0noQ68Iot2hqrcuXMVT8ZZRMB8kpC6kU6Aal9ip2HbJa2y1lQPvBtSiCixGAWzzNjD7rzCdW/Updb8YxLxsPpBJV7UndzR/hZUii87Ao09Y2wqQ+GECah3H7v/nWtMptIRt/HfQvHkUUtfl9RKV0eQFcovY+J8lEgkTJ6yQD6tB8kcEDt8oYqxF3apIszLHMvSbtGhimdlm0LlrSNlqN+LwPt/KFHFxP21JL08vwHTHmskXocUIp8upe7PLO3QVYpqpE/aJ67bdirbR1x01yw3tb4rxuq2gvollfCf3KHWKC3ZN3zRsuDa173WD+9tgPVKMDOVrJ0bAHCwuUXBfAgsrWVTU+5nLlsc6wzaxwZWpIyLqhw2+0idxQCH8jpknaxWjG0DdnTyT4e0tCnyBlrakI97+PIEp5NBC7HD7uId6xFfJtmgLttANUvRj1Lb3ULlG70qcFQT60j4/wPEFEKse
 wXkdeetC
 u/zLT71Wwk9epjjWEIRs7Sms6CzuokY9raGBRBnxTgZVNZIm6ILeBprcXy2AtZD4QTautIV3chsCMirErJXlwqiA249Tl/3T0yg2WB7e8t5QMu8PW0Z1CakkKkrPpzhU/GmWDlqB2QhWWC+FHDxtfuARhRj5br4yagG29I94FsTdkfhPVlLSWI3JZTSG+cXkrQ2d9sdAvtNZ7SyY98LlGqyE1qZqt/wA3NnPbfGqGM1CBGMiQgUlFaJQFBrD47Hky0s8cXLq+M3U/SOJpEGiPKve1EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use max() to simplify hugetlb_vmemmap_optimizable_size() and improve its
readability.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 mm/hugetlb_vmemmap.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 18b490825215..4da44b1e8e1a 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -11,6 +11,7 @@
 #include <linux/hugetlb.h>
 #include <linux/io.h>
 #include <linux/memblock.h>
+#include <linux/minmax.h>
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -44,11 +45,10 @@ static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
-
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
-	return size > 0 ? size : 0;
+
+	return max(0, hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE);
 }
 #else
 static inline int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
-- 
2.50.1


