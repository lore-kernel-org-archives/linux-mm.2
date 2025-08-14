Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6A9CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3E890011A; Thu, 14 Aug 2025 05:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BFC900088; Thu, 14 Aug 2025 05:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8E390011A; Thu, 14 Aug 2025 05:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48CC0900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:01:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64511C05E3
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:01:08 +0000 (UTC)
X-FDA: 83774768616.04.DAAFC51
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F259180003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:01:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BdfHpxoO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755162066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GvViAVeacLDX8WWUbGDCX8LCi1iC8wegTPXSZtNYfrE=;
	b=dR5XckPKvRfm78nCTaHb0CKjvV5TUT7vzNUDRq4qdITQznYmvI+Amaa2hRmFOmdCCEKIFX
	P5GcG822aeBenwonjnap77KCG8twDFsfT0PmTebQ/bBkimh3UEkNYFW0InGUa86EKMVBZ9
	LzTFjT4UJk9H4dv/8z11FUCiP5/te+c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BdfHpxoO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755162066; a=rsa-sha256;
	cv=none;
	b=P8UazqfsstgNKNc04/tsuthciCU8K287I1lC/eY5ws5Vh0ZkYjLgaaPWtdY+Kj1S5f3PZH
	4ZQ2jS8IUYA+82a4dPG7jiikAuOk7CeDdGLVD42qaUOkV0UDFn5UkwCigZqpKtTO6vIYl/
	298Xx9fgig2ASJ0KDwa4DxwFjCtTjXY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755162064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GvViAVeacLDX8WWUbGDCX8LCi1iC8wegTPXSZtNYfrE=;
	b=BdfHpxoOCdyja8JdJtxD32B+sd/Mck3Bz2yfO8RL9lPcby7An7OoztfDK5zfZ7YR+vwVsX
	Q4SQwoHRM7UpXVgPkERTWfIoHCRXBR7svCzoYvwm+Y5ezt8Uq4LXkpXH3opW6EOeb29TP4
	7aEyXx+m4cI+84AtSejfsJ6kMjZDR0A=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page_alloc: simplify lowmem_reserve max calculation
Date: Thu, 14 Aug 2025 17:00:52 +0800
Message-ID: <20250814090053.22241-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F259180003
X-Stat-Signature: hntdrk4xw51ya1558yrf7qpzk31uw546
X-Rspam-User: 
X-HE-Tag: 1755162066-384869
X-HE-Meta: U2FsdGVkX1+u+fVtCb7Bu/aIbrkfBDs08G+U+syTKjRNlm+SQVP8wXh6D/mpR2/ZrIwODu1KqKQ2Xaqf5mJkD1V36YIHIEEFoG2wIRPIWwcTqeAtz8W5tTpZ3or95cLctYc7sOEtHR5Xi4nYwQHJ9wxvWnbBig+hhzziHJKJbpa91ReYMYHqFNTpuxiVK2dyaN4TmCc43mCc7GSPsclrorGyKjoHlnfbX8VxLMBAkqmYPneJE4P/J07TMqfev3BUTQLCnCdeHka691wUp5yF+4tbqEkPusG4MJGIUB6LfgvFfzh+ARyaHmcCLYvkjXeMlQTnV1TzBEbNcr5DDubZbDI0aT7A9Yd56e0wbJwJaEUb/bLU1wA6G+iUIRz0U364ycwTyOVRAlvN0R402dPyLSdHp2n8QpnkZVctUrJhIl9cfSRQ2k1NxufOXekGk/JHr/TE3I82MdDn6oYRsfWFwChU8sLa8roTdLvkV1wz11YabGJDKQD9AnHJSbHMDg8J+uPiKgdUTEK4r1v1Qq4H91wqk1Fcofta44UQrLn4iocGwkDMOOx5jhncL/opaRuCekkHxOGvIm1HmZZeTCPRcK48cgi/mbrsk4HEDxiV/al8Bauh8GE2InnPvntrBmZ5a80d9A0HaHbM6NxcRR6iYWnEx0LGaZ7fY8cD82vX3g/pUgfE3S++YD0Vw2i/NipBm+blURvNjlEAQW/jtzoPk0SmZtqemn6wGyj7QygNuQjzeGGT84fdP7vX+aK0ciFiPNA+YPVyhxz69adF9RHBgACLuaR3t7Q1vNhqRL2+n7n9CScqKqoH1CddYX1Oy8mNhwQoAhMV6AKAYfUg7pEaDpvq8u1sCcWw6hQharm/xPffbf4y+iiJFMlp9gz/qJHYk+PA4ByTR1oQ9nKGSQelw/hw5mJ5sa+T5cLmC6c1MieId9hibE0xGd0wg9oIQPV3F0jSun8I/6d+pn0rhft
 V7bOcM2n
 7PdFpST1vw42Qyv/lb+71Pt3ME636/vn5eCJCRswlDioAHpsBaqrqqZJmVJL4W7fS5bQk5jqkApFbyw4X0XJGn9TF0zCLMDpbk/F/WqBsQT+iVsDnfnHx1SQx5mZi+AQEQvtlIY09+vf0oCK7kQXT6PiSDYKO0QjIZdn90gvh0qIfHxHFNoWqmVbRFfatubqXY0iUPXF/MDMLFmtK4HXhFJGFZ1v/tq7xZOwEdIjMDxaGymrz2tGMBUFhYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Use max() macro to simplify the calculation of maximum lowmem_reserve
value in calculate_totalreserve_pages(), instead of open-coding the
comparison. The functionality remains identical.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/page_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 64872214bc7d..8a55a4951d19 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6236,8 +6236,7 @@ static void calculate_totalreserve_pages(void)
 
 			/* Find valid and maximum lowmem_reserve in the zone */
 			for (j = i; j < MAX_NR_ZONES; j++) {
-				if (zone->lowmem_reserve[j] > max)
-					max = zone->lowmem_reserve[j];
+				max = max(max, zone->lowmem_reserve[j]);
 			}
 
 			/* we treat the high watermark as reserved pages. */
-- 
2.43.0


