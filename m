Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D370CA0EDC
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91DF900209; Thu, 14 Aug 2025 22:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB998E0002; Thu, 14 Aug 2025 22:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993D0900209; Thu, 14 Aug 2025 22:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87F898E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:45:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 325B21A0852
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:45:26 +0000 (UTC)
X-FDA: 83777450652.02.2C6F2C5
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89C9C100003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:45:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sXcGpxlG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755225924; a=rsa-sha256;
	cv=none;
	b=d0HR3EWsFTWf42coNTCML3H7lXUCv2bYdpUWYtLetj0IcxjfJqldiimD3j+wfXigLOCFJy
	PW/2o0lTPq1/W6Ob8TGQOgWiNtF34qGzRN3wHAPKUdt7P7N1iWiRP2LLnfT6Yyn/7yCeb+
	cNLwAU/OUSJEWo8U8lmhHKkQz/s2RGM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sXcGpxlG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ied7X9jQgR3h26+VkaXChRgVV0OEH9AE3P2+5XZf8hg=;
	b=mxnojsqR32MLEKaLZEKcpqmebMySPcKnyuMTpks1MFzDFplISCbdDbORwbIisWf64gF8w1
	DXnbo2zGM7YnAHSGfki74GuxfY5RknzsOcddtcsyKWVF+oLJscXpFi6XcQf1wv4WX110YZ
	vR45dcWTxW/5KX7RE6EgsulBg7PIF3A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755225923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ied7X9jQgR3h26+VkaXChRgVV0OEH9AE3P2+5XZf8hg=;
	b=sXcGpxlGLJlXlGMqaGdOaOw37qJdpzNs2klMzvD3Lg2noAzkvPpfC87kjEHPgG9ynR8rGy
	YUD+zNGUbmZZj/dzvZ2fvCpymFoYONIvIiTkPdK12DLRa8FsJA5Hm0fKB82xu/gF74MqKJ
	ZFioUKEWLNxNYjOXPp3e0uSYYNz2eW4=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Liu <liuye@kylinos.cn>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/page_alloc: simplify lowmem_reserve max calculation
Date: Fri, 15 Aug 2025 10:45:09 +0800
Message-ID: <20250815024509.37900-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 89C9C100003
X-Stat-Signature: jjac88w47q7dp4brpngobao8kju51toj
X-HE-Tag: 1755225924-507141
X-HE-Meta: U2FsdGVkX183BCSSWUeZw/+k+jF5X11gxbfeGy63YpDZVy3k2Sdd4VpSq9yAnO78H5XzII2anQSlYJXM0Pq+yYjxOWrN5H87TxzNINn4J+rvPAgDmV2G/qOXgk7mAqNG7IkZbA6Q8K8IJqzynEzohLrXQybAlzUErWcig3wEfsrajsf1r5Sfc/SNgVjyhyXifwcPssonhi72bT2yv06gaajWXT83sOucZhFGgIRAwiWEeSVfO+R4eG7g2Qc5grnSLqgE1N77E/edYRfLFODEPYQnVaWFd7aQKigZtn+o/RvMBOV1vi1LC8sT0dmcxLXjw/OCSNfi4dyRahif2Y4jU2P19HJk4iTcfNvfZw855YJ/Nwd4ksRXRlqjTfpkqPKwJEZBZaGB3XLodCwv0Mx/ksCc61D1nzirYue9iV8zvgan4TrwCAyYuhhVsxUl5huOAMJ/Gay4MVQGihLnky7vywajoMRQj4yrQzIUqL4GTDb9fpUTf3A50CshEgC3pHJ/ygNXTiPgTgz1FwUpjfFw/2No8kQDfx7BbByny0CzzqzpCrvle6oY45KHXujUJaM1rte+adHtinUeu2KW2Url62N36lr02l9MUEXHVL7rxf/p2b0YXbVSqZLoy4NhZ5u+vivp/8LPF8/Z/pLSbIh0LiFyT9CcMPX9iclS8Fo4BIl9OuTBbo0h8wMuDv2aIK3rznuuHISoLdaqUC7+RBIDKs9CnTN2Z9VHW7CzKDa9whHgIKPzxRwltk0VK0Z9npu/b5GPV8la5jKAMAJ19M18ay7ncLTC275dXhOBjTJ/fzTp+XAYoor+Lj+qPzpumJkCd2UR8oUNTqbLdnqE2IMpB3nRFdeqw1a8Pg+BjhaLSPRyFyiwKE1RXq3vjHtMcTRX6u2+d34dfaJld9VDjPQAPeWHIdmwG5BjOBVAcoTE2cs0V4VDPsYgmw2rGxEb3LGn3HMHQMKxqkyIQKfzAQv
 iQbfjefw
 nLphTqb3+tVDk8lKHZOdq75QQiFfXmCf38VC2bVFi0WZWkipD8TDb07x2jyBhUSpfJxy9j2Ds3hBSeQtv9WIzZTFl4DCFHSxHz8C5K50LC1piwgArCdnAzU0QHiTzhwuGo9Ayz4GlNbTM2ac5LEVaG4M0hFm5UNkXb8TQOlJLR6BQ76xoImq/1gX0CSOD54vaJMK61tNvzFZrqQKUpdN6dIAoLKUVbe873MOsVl0IHY9neynJ7hxY9gcF/oGFXtOmDaluwZcJhe4dtwZJXZCl1rtrDJS2hrN69SU8s5d1x7If8/lfKp5ndZgF8qjAVNCerjfw2PUuK2TdTj/w43oppHMLa9VF77adybmX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Use max() to find the maximum lowmem_reserve value and min_t() to
cap it to managed_pages in calculate_totalreserve_pages(), instead
of open-coding the comparisons. No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>

Changes in v3:
- max = min_t(unsigned long, max, managed_pages);
- Link to v2:https://lore.kernel.org/all/20250815023500.36893-1-ye.liu@linux.dev/

Changes in v2:
- Drop unnecessary braces
- Replace "if (max > managed_pages)" with min_t()
- Link to v1:https://lore.kernel.org/all/20250814090053.22241-1-ye.liu@linux.dev/
---
 mm/page_alloc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 64872214bc7d..eff07323987c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6235,16 +6235,13 @@ static void calculate_totalreserve_pages(void)
 			unsigned long managed_pages = zone_managed_pages(zone);
 
 			/* Find valid and maximum lowmem_reserve in the zone */
-			for (j = i; j < MAX_NR_ZONES; j++) {
-				if (zone->lowmem_reserve[j] > max)
-					max = zone->lowmem_reserve[j];
-			}
+			for (j = i; j < MAX_NR_ZONES; j++)
+				max = max(max, zone->lowmem_reserve[j]);
 
 			/* we treat the high watermark as reserved pages. */
 			max += high_wmark_pages(zone);
 
-			if (max > managed_pages)
-				max = managed_pages;
+			max = min_t(unsigned long, max, managed_pages);
 
 			pgdat->totalreserve_pages += max;
 
-- 
2.43.0


