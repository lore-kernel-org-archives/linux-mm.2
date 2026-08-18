Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C741C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93926B0197; Tue, 18 Aug 2026 09:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D236B0199; Tue, 18 Aug 2026 09:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C2E6B019A; Tue, 18 Aug 2026 09:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB7F6B0197
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BE451A0134
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:17 +0000 (UTC)
X-FDA: 85114428714.01.FCA5D31
Received: from mta1.migadu.com (out-134.mta1.migadu.com [95.215.58.134])
	by imf26.hostedemail.com (Postfix) with ESMTP id 857A0140010
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HYI6/7d6";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MB35eBheaTUqVS6YgX3GCA8MRmyWh2rgbgzqOkfLyPY=;
	b=2NTSFFQV1UYBL1AnjWBwWuN6ycb6fgAVHPP3uvQoYKp/zjnSbn7ZeVwd/zLHlWHxwhTk2P
	H/csKeQC9czaSs1Etyyg8uoEYoZ27TNUo5XxsY2iJiduYtmjeFFL78mhjpu1if/5ITMmDS
	6M8Cu1bzNmxaRCnoD2gWeLePsSzQS38=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HYI6/7d6";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058735;
	b=tb3ree/E9tpu0ZNEfyDV9navrlnC5tmn+mdMe/JSaqlXHbpkyCjGuU0dvD+CiisxEGXQ5n
	Z83QBXc5aiFx/p/Jt8HYDyscs0QUEkFZhriY/RJNS4QzzBcv/YYAziUkoMXgjMnyte1IGM
	1I5EepXj9QZMyYizpFPwNo6x/WT6cuk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z3Nuo7rdKfAlilt7Qu0TMklie3/gOO8sgolPIL27pOs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058732; v=1; x=1787663532;
 b=HYI6/7d6EpLYxKclLS+H5Xt/tyveWCDu23Dnyhbeuirc5agUAcLK5qtPsUhccfoyfSjrWPJX
 kb/0zULZa5i/XGdQhHWIdk7y12pchtRUDkWrsHzR4AvA/rx300/oi/69pNeQYOx7Sv3Sf2IYLly
 XeEvGVCuDqpYKT1u/9vA8Af0=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:c::)
	by mta10.migadu.com with ESMTPS id 0ff7917604fd4d10;
	Tue, 18 Aug 2026 13:12:12 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 01/12] mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
Date: Tue, 18 Aug 2026 06:09:42 -0700
Message-ID: <20260818131202.494754-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 857A0140010
X-Rspamd-Server: rspam07
X-Stat-Signature: 65381jcndi8ax6ye57gas6gju6ebrrqq
X-HE-Tag: 1787058733-762084
X-HE-Meta: U2FsdGVkX1/XLi160KLPDaOfMp7ThPRAW5oki3mNi0bOci9SA/eusV1HIL4DyIF6hfFqWrvMUbfXv53UBt7KvYVWwbsEAYgn+uDAA6zQGWgo5g5w+5vPLkiuJE9GUz/vTCh4i27X+Z+hOxgQcWI2Ih0xIiaxhwTtWJicYZqZ0hj1zzuFc7Y1y50/b9mflbZUT+gym/2/9KJt10smdiKmcWWYsuPrULsDdnoByAwzoW3xYduG8iUr/V978MGVh8bsxIwzwVhUIcmphxcgm0q+3nnIbCoYzf/NOl71waIXsUD/kQwCbCrSXgG8aaC8Jxg6+i1MW/zOm2fU0DXYXT+wssxnPL1l+hf8dPEWGPnjPlgCeAKmNzb5dYgE9VtSTh2tWGU82yA5mH02+ue/BQOi5j6XxCP92V/cE4lFQ288VaylLMVNZDJMFbIsJ2lhEn5rjNQtqg4touyKkmcoB5CEjlMYKWHWBHofnqxaMnZ/HZnxyTNqgR4YOKPSfiXOEO2N8ei+cKOGGwvw5l5ngf0WwIXf9ZM3UKKeQGWaX2znKEXhL9leb/V1gCrd3uxjlofybysvnjCdZCSRHMkv1XFvhMfEQLRMj9AgDAuCWV0RqlLfg5qRR+leeuYW3tUm5hOGi9el7qVpe7ish+CGX2xtCU1oa8RGayN1pR0E8eIdMCywIYJ9AbyHD+gwkuCUyCxcnyWDu10Cu2IGaMq1nq/+LhSEy1EJ8ALqFKfpmtQUvDIb8Zaw/VcUrxPLHFa6sp1GQYCHu88qIx+0uGuN6bUY4lRKvlal2vvZ+q3smThT7lhVo1c5Dfj6QoYwIIJPH3D1ppTmNr5vNPqBq7V3FeTjZllIxVTpyMH5/Wz06Ps8PywVoIMzx0rLMPQ/vCFpjM2IlGuz/wgENtCxxuQ2pxQKxB5fyPpRaDi+8aQG/tDN3KDcxqomCMlbA3n2Qc+AEIUCaX/b8/dLyJyGLPvfvtf
 WfsoyZw5
 gXl9yxP6qcQBlmiP8YbcADEj5WDPK0syxFoKm0TPKCzOhgYDHEYujpoggtjbwOo2Sr6bUXT++pzpkergjolIvAkeTk5t1KGaJTtNPX8gcFbBXYtHvdI80xRT4Jkth/wfAZOl/oDitVzJLbC53OivT+ebKAWsU5OOJySHOTmCx5+X267zFgR/Yc5l9cvAi+PdZk5q7nGS73ESPrr/wsZH83MpfCiMF+aJeCiYJYHhxRi1GCjWQHqPFz9heTszEAiVwiLJg8sdhSXySeYpLFh6qh78dYo6lRWUnXVj/6DJgIIQjiSsUVL7fZtuCJooePjOZLfJhrdP8g9FJoy3FgWE9R3Vd/WeXw6B/LVTk5T6Ho1Ke2hgbIAtkjC1hpEr0cXsCrL/b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pmd_to_softleaf_folio() converts the softleaf entry encoded by a PMD
to a folio. Rename it to pmd_softleaf_to_folio() to make the conversion
direction explicit and align it with softleaf_to_folio().

No functional change.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/leafops.h | 4 ++--
 mm/huge_memory.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 4c1476ae32343..7c13c58a5e218 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -657,7 +657,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
 }
 
 /**
- * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
+ * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
  * @pmd: PMD entry.
  *
  * The PMD entry is expected to be a valid PMD softleaf entry.
@@ -665,7 +665,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
  * Returns: the folio the softleaf entry references if this is a valid softleaf
  * entry, otherwise NULL.
  */
-static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
+static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 {
 	const softleaf_t entry = softleaf_from_pmd(pmd);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43a..1b6b0aa2baa3b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2467,7 +2467,7 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
 
 	if (!thp_migration_supported())
 		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-	return pmd_to_softleaf_folio(pmdval);
+	return pmd_softleaf_to_folio(pmdval);
 }
 
 static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
-- 
2.53.0-Meta


