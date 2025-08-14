Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F86CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192219001B2; Thu, 14 Aug 2025 13:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143C2900172; Thu, 14 Aug 2025 13:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F251C9001B2; Thu, 14 Aug 2025 13:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAFE3900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:23:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89873C0264
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:23:23 +0000 (UTC)
X-FDA: 83776034286.09.BF88AB3
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9B75A120010
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:23:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=bxxGfpy5;
	spf=pass (imf29.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755192202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GTyMLaYR+1uOWFwYD45tbkK9cNmLVTJpFPWAovysPBI=;
	b=B0ESi2tuGX9eoly3zrWCsb4Efejf4Uz9CoylxyHWtFx7Ehkpwp415A00ClHEIyOEX//Eda
	p1YhDFc5mVelV1ODClu9w1EGpEASGtMncrf/tdU1e03eeN8DfxnfHt3H2/cIq2dWESiL4O
	hHNFC8TpNgP4nuyurmPbip95xC7qDL8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=bxxGfpy5;
	spf=pass (imf29.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755192202; a=rsa-sha256;
	cv=none;
	b=pRAgrmfxptl+mJyMz6x3ci5JWPkibaXe6UNS7ooH6zMZZAtqj8ZO3ri9XbdgJK3EDGq+RP
	zv85pfID+12twXgqAG1Ex2jtGuibIke8ksm6r+6rInH+tOy4zIJz3odROFOcBUx+/tjP6d
	f7X39Q5xfTo5+dHctqWFTvWM4frR28A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GTyMLaYR+1uOWFwYD45tbkK9cNmLVTJpFPWAovysPBI=; b=bxxGfpy5yUVHVOGHsBhdmDXF5M
	/68DnQJcyvDIVWMp+e5nqsmrvpjwGAI/EUV9iVSnmSm5FrJkzySp3A6PshoRn9UszLRaFhq1ApDbi
	jUHMMARVNVj2qTtG1N0W3uXYXp8nbJVqJtU1pLLQNrjwtMxh0olKZhB0HHEDbtbozrbb9QiFQiPA+
	PWd3w7Bj+p+3OBi5D4V0DiMVXUetu5kbSrZAyfwoPfFD/V6wLVjNf3j664fw6HbDiICeDxbuIbCU0
	cUzh8e7sY9SPltcgGco5m051KsbseA5m721ObLzx2UfRtIqBylXWI0Ukyx5fmhWKYRc45vc4NqOEB
	wZwel/kg==;
Received: from 179-125-71-254-dinamico.pombonet.net.br ([179.125.71.254] helo=quatroqueijos.lan)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1umbfU-00EE1W-3Q; Thu, 14 Aug 2025 19:23:12 +0200
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	kernel-dev@igalia.com,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Helen Koike <koike@igalia.com>,
	Matthew Wilcox <willy@infradead.org>,
	NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH allocations
Date: Thu, 14 Aug 2025 14:22:45 -0300
Message-ID: <20250814172245.1259625-1-cascardo@igalia.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 35s15dtb3irit81mhkdjh7t9o9aak1mb
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B75A120010
X-Rspamd-Server: rspam05
X-HE-Tag: 1755192201-273548
X-HE-Meta: U2FsdGVkX18DUvf8p0ynOuPz9OkjhePwGPGsk4vgOQo+Bk9vnhqWYXGdO3+bGzbHgPf7JYFaRQX7R0o/DABXXB2CNJFicGiTn/zSh/Wyq3MYpj5KYfLkulaVbPgJya9tHSpzuq5sOc9Q6/ws4EhxJg93tlIiF8wv/w9+Tt0GYyIX7XjHmnewcbjKwv2+8v/PWx66vwLKNaDgj9Jvq3LiIRs/0vwUPQtK6uBbJlEOG2xeBH2G1aZXiZJ6GbzFVhCJ7Y6BCWgd5Gr4A4vrdp8gt6Irvgf5hqsSkygDHHXZsBxYi4NNfbnaxSX4LhoKjHBMTuEonoNm2kTKPFeESq8mO2/wPfFJ0tyN7Y8Xw5f4nSkaVTpyU2iFX9CF/zPVtlK232gAe/nis9oN30eoFhrNyCo+i1hYmG8jUYhMrxdGndEr9peqNQ65o1P1FcCsUapsSgu5A5kwWaQz4Xjhv+sHwQP5HqdFZazC86T4E5LM2G22sQLgDa4d5dE8JE4X983/8VGqIeA49mZMxyKjnt8N5ce8f0mthS7zps94tVZIR81AFDm/WH60sKtX6YQ5W0nR+P4Z9m8IXEs4txx6352CbiKOhcyttD5mAM+TvPBegbZ8MaG8xgM5Xgps4oTxxceY06rOH+SrBYuH+zetRfK+cUkWjomWW3n9q3UirsBOl9dp1EerkbrWN31amVPbwQRFMLEAo4T/87udS7tzpHi+dPmcJG0jn4niWaG6MIkwthCG2LpbNZLNbMzVY49MIfgJ+GMyttZMeAHUebOhCvrUqNRKBj5UDfqhjlLbUiwmM2T+s8B0ZfYPbDFQfFHe9R8qtEyVcHsRSs+fixkpnW7q6qUMP70nvSWQZXDO8csLbULqVKypK0UwqrY3orTErlSQzK1eMx5yAH1xWsnN/NY93lpyvAcui4oMvuF4cY6Sm/OY9sFlPKb6i+2+vQj8s7iTm/4JnaSoi1Ea1jaO49j
 GyhHKxyg
 vXChqk0x3BhI4HRN0nV+woSiYUbQipUJqcwwvdiZ4GEobGM9KsTN9H/yyptlI3GtB0XHm6jpnUfOpeLs8Y80J3PV45RbzeFG/ebQF42qsfkU0Gnm5v12jNLoktARPzC3hmzrhEJXAqTYqx2+eA+Y+RvTZcqQREznqDQjupPjm2TKX8zB+Ypo7+Ulnftm2hQqAPs5LlcxioEFuG9F3TTCiV1ZwSlZXeGZACSWnQcvpD043C/XbkZuWCL8/F7QxdF8phSdTsawcLx8hAXGcUll2F1HA0xpjfwbwqz53sIct4FjBCXtpwyMk593TV48oGWNKlWMegllt10xtw/WsHAeeRL8auULGwNXFpCL/j+rC7yRsBHjLF4W27kvrCIKvXleW77BWr3awz8hkCwzMiVBjNSRW1CGN9fLRRFEs1WypheBgKU+fVZb4PFsANoetpBDFAu+fFFHDQcaIrSBXq70cANFJofHcHbLNlK2Afz0vszIUKlqe+SdgfCSOtc1K5WQxN3kEGGyplM9OsatMUs58kstKRVvJvYWfEQbxOwiqgRcWabNABgJOh2+dBTjT4iU5UjTaIYod8ytkxinThLpahgXlI4ReX7lr+pUxbeyfKTPNkXVmHJg+ASMrfbAHMNl6sv2HxG5wkoz6eOjB94w1gT9/IHinPLAOj35V6cFaVb7o7I/1RaLv7xZ7ETqztqKMV4laFjcZ0RdD989Iu0Wsqrex2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 524c48072e56 ("mm/page_alloc: rename ALLOC_HIGH to
ALLOC_MIN_RESERVE") is the start of a series that explains how __GFP_HIGH,
which implies ALLOC_MIN_RESERVE, is going to be used instead of
__GFP_ATOMIC for high atomic reserves.

Commit eb2e2b425c69 ("mm/page_alloc: explicitly record high-order atomic
allocations in alloc_flags") introduced ALLOC_HIGHATOMIC for such
allocations of order higher than 0. It still used __GFP_ATOMIC, though.

Then, commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") just turned that check for
!__GFP_DIRECT_RECLAIM, ignoring that high atomic reserves were expected to
test for __GFP_HIGH.

This leads to high atomic reserves being added for high-order GFP_NOWAIT
allocations and others that clear __GFP_DIRECT_RECLAIM, which is
unexpected. Later, those reserves lead to 0-order allocations going to the
slow path and starting reclaim.

From /proc/pagetypeinfo, without the patch:

Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone    DMA32, type   HighAtomic      1      8     10      9      7      3      0      0      0      0      0
Node    0, zone   Normal, type   HighAtomic     64     20     12      5      0      0      0      0      0      0      0

With the patch:

Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone    DMA32, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
Node    0, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0

Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Tested-by: Helen Koike <koike@igalia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2ef3c07266b3..bf52e3bef626 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4219,7 +4219,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 			alloc_flags |= ALLOC_NON_BLOCK;
 
-			if (order > 0)
+			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
 				alloc_flags |= ALLOC_HIGHATOMIC;
 		}
 
-- 
2.47.2


