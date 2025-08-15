Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282EDCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC9E900201; Thu, 14 Aug 2025 22:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4B28E0002; Thu, 14 Aug 2025 22:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1A0900201; Thu, 14 Aug 2025 22:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACA98E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:35:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09C51140823
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:35:16 +0000 (UTC)
X-FDA: 83777425032.17.2DA407E
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0D80116000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:35:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mYJHcHKS;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I3OfKRQ9kR8yywxEX4JYhqedZi/JoNJ9IgE4wWghJgI=;
	b=5Dz0wrdpKndxoSX2GX253NmQ+P4NiKbyuWJnSGp73hoY+u9OGsb/C/6rGOD1pZGIhlzP9F
	5WxwAtvN45oVYcEg100K/6avPsa3pyMbHpWrIJzmQfftlE2CFQUSNL8elul0i2LKGsp4tX
	m/YN0ho1fcAj8DuXcsieFst9DqcICpk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mYJHcHKS;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755225314; a=rsa-sha256;
	cv=none;
	b=fizpjpjrXfwsYLmuO7gP72NYZX1p8Pru0VdUPDwj4w8NSjQaxiNRa4n+ls56ZefmVIPGDy
	kQG8RJcU7TLwC13imq+uYIdDe+R3GdwIaqpQ3KAN9ZTq1A0Xm8V42vlPLgLVPusgPkK/eA
	id2gCsXqABxwQ0lRiRi9XNZGw3RBnj0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755225311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I3OfKRQ9kR8yywxEX4JYhqedZi/JoNJ9IgE4wWghJgI=;
	b=mYJHcHKSACHhcXhwvjCuKD4K746qCqm1M/+qN0J263/FLzzf4yzl4OWbgaO9H/W9LtjXRS
	JGIkZLQrAN9jVqgN/TGJw4yi4MkCTTyPDYvYwW1dopDmqRMyk8PoAqLbZO5ZohAgs947RC
	3QvJhPq1fq/wpFQsroWdJFo01HEkz1s=
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
Subject: [PATCH v2] mm/page_alloc: simplify lowmem_reserve max calculation
Date: Fri, 15 Aug 2025 10:34:59 +0800
Message-ID: <20250815023500.36893-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0D80116000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ikf8ombrecjmjfcz4749kaiizi693o3z
X-HE-Tag: 1755225313-363010
X-HE-Meta: U2FsdGVkX1/7dru3Ux+waN1spCnGo2xwnzH12vcitE8HC1GvmYtUphxuka02oKqFtQtQ6ib+vi8cIhPDy3Imlgb2j5L0gfLT4KgtSLE9ZloWnp10xNYpAQGQhhSPMb9hnugiOOBTGIEOVe/JALeDj8tQLOYMKuTsjKyw51eYaH7mlsD2VKBdpaYu12B9Ay6EjDzJON7ykHxPZU0f0zFL3vXp04e6dXFYkDCPu24HeyrrkWO4CmcgYEAPKvHs68BNBZ+PstUAVruMU54YPYjcv2ODr4jR3Lln1Jk/9JkGIII1JFblpDiGQ2oukQE3raLBEnetbMO7EZqEez64SW5mRqPtCx26pH9q2QjxjUy5PrzqmIw7j/5yTFWOQI+UDw7Sd8HKZ1MVuZVOYSUwv/qOcnfZDvhm3NYdkZ7BLszV5lzAFBMpVX9/k8/X0EjldYvqqQEjtwTyDoM9+uxesVqzysh3leIAZPnCbeiTEMiffeXUsIjnCRVptCg/OkRrhUWM9cJ8I3yOThMrdxKK/YtHRJOrWlDQEFyH7BFSmRIa+WCfeTGN+1Lbf17e6HqVuF+9GcVEACLFvTCqtpLE+z8ikdfFz3VRPCXzm3OG5XPwfPEq6Q/6zUM+B2rygy/T+cnMOkwNu1fuuzrAmrEUG7S2CjrU/W1k5Ri04AXcu5b05vkxpAL8xq4oqkvxkCHNjU17b2hRP/DtlGwALE3JTGNlGo9lRoD/DtJMkDC33acy3pOePtCx92RCRNek4ttVvyRNYbVBLqrQMxw5I6kFWteSnyrOeK/szPvjTWCCnge/CITcz9WfwFqD3KbM4xhQt0TZoTg8fknPg4AKscTKxwLU/H88uahRsjbvec5emKaxDiirzzaYI+u91X+r+8G7tYh+aCR7BxefT2A4AftJHprjCdDKBeMxh4zQ5UF1xtLT0tPtm4r50atp1nyt2W/bkM+45mXvSzrQHx/udsmjCiV
 GdbUshmE
 eSonlSzoj2Gm43LjJZ24sZCEgSQlfxZHUmGAwKWPEZD1WIK4xn2rylREfJcdYScY+0YCBdOFgozRES9dC4bNKzcxG1MqmTqo9mUCqwbkP864ZT3DMd+RkNsCTdwrjtZ550bLQz61wrehtYmKIJRL9AHdmayUVtUpPdD/lZtadAa3LiUftx4Df6kbesREJ6WN4Z+0QvMzFud4AKEzdw23iwDb9QM0ayLEYRKjKnx3bPZSlUNWyQ24beS2y2cnEfr/XJxNRZonEpwgawUCFsO/ISHdRhfCVNCeJyizhevnHyoARMDH8cSC06cJi2VT1Vmw0aFqq7v0TUn5FI6es/E490IW8gJLDspCEwBEU
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

Changes in v2:
- Drop unnecessary braces
- Replace "if (max > managed_pages)" with min_t()
- Link to v1:https://lore.kernel.org/all/20250814090053.22241-1-ye.liu@linux.dev/
---
 mm/page_alloc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 64872214bc7d..2617fd2f4b73 100644
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
+			min_t(unsigned long, max, managed_pages);
 
 			pgdat->totalreserve_pages += max;
 
-- 
2.43.0


