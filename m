Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A096C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC216B009D; Mon, 13 Jul 2026 21:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436E56B009E; Mon, 13 Jul 2026 21:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3261A6B009F; Mon, 13 Jul 2026 21:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD1B6B009D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:52:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93B71160237
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:03 +0000 (UTC)
X-FDA: 84985706526.22.14479C7
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A83AA000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NDmwAxeg;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMPk4xo0goYwl32b+O7Fi24CGRO5SYSFgHPQLi10p/I=;
	b=k89t1+dCnwSJGpTY6vWgsXCOJnYcSGbl533i7Lq8YLdvtjeDCKPmwQmlloYszqRHmn/11I
	7DIkwkYpvC9pAH+XvF2g4xs/ea5BaPwWg2PjGo0kfQmtXj4fpqVE2iwQRtMhU9OOcZn0ru
	KgLpiGYohc09mosmvrTio0oaMS9IjH4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NDmwAxeg;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993922;
	b=0XKPgGWKmQ9x+GJW8kzT/KWjFt2qadNP7Wf8xPsqsZnWay7/L1gHq+0QnQOHPQ9aJreYmB
	XUYPd21w2I6VfMN11seL/KcEoc0npJO8J3uRfJ28ylIu9AaTs7qYi9pZlPFaPCOyOST+WP
	CQUMvE+n2fNzAs0AugwCmUaByMlemmc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hMPk4xo0goYwl32b+O7Fi24CGRO5SYSFgHPQLi10p/I=;
	b=NDmwAxegFBJvW/6KgfXr4KpsbluuEfl37QztIvImDOCXBwM6S92epmL0lEqi23eWeuKpVD
	LgcTfRq5yd/8NVj/p4r1y6TMB7m/4DCbMstBe8+Ad2cLvNmRkvkAi8LVmX47LD78QOAjN3
	yB0Wv6BkCFxgHguaP9h+rP9wiPsKaog=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 5/9] mm/page_owner: add missing newline to count_threshold format string
Date: Tue, 14 Jul 2026 09:51:04 +0800
Message-ID: <20260714015117.78351-6-ye.liu@linux.dev>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A83AA000B
X-Stat-Signature: 4zui57cz69as19yacx684g4s4nhgagjn
X-HE-Tag: 1783993921-145838
X-HE-Meta: U2FsdGVkX1+jHmOipNmoRInKHiTLKDq0RAgnTwM+LwZzwoD916DWPXm1vfAAR3TgdDiatONSF6KcHvp6nQHn5aHR8hrU1Gfu4fCPO/fAqEaGRNzxLY9WYmY2gPtXMSu4U4JQ28C7WzCP4RDmhF2ELBOEutlcePaJXTAUlpvVN9zS3Q5ZuEl4ssY9AlhV0FfFQdosX8A0iJ1YoMVewsb9mWTVOJYbYSQqOQMpr8vEBALmAdvA0noNIHdMfuHLMp/a01ulWV9jbWWUMR+28GQy6WRpaMEafsYE0txDIVWCOEsSnX4RY60XLSrXp8U+E4dJm7yxO6LNp6mjiW/Hyz2leWB1s6Z/aeUGJ+qhbNYWHFm7HIMTD8fkAjEzZ2lFxcw9d2fSiQBpsZl4POSteYK4d2wyzKFW147CUn3GQfTliimFRpMp60GKXVxTaNPLtD6dJaQjgp0Cgtil6JWE8E5X+nmngVh8a1XtJWl51GfL8OgYVY0mEEWyDPhMKG87pdGEbi80WMMUfEIumFcAD3yAx+oq/kdwDdqfsv1HKnV8jrOkzmGjoHPoiz/ZCdXBnNhhxwAZ4ykAoxodLW82lyNGtdLq5uz4ls5HPwfVAFHKo4CamhTuF2vJ4nHuo+8oHC//kWDDAvkTIINAxZPSNAwkZWZnXuT1w4BWosyKP6+DzpIBVwBtSlf6G+SprVLJwjnJuIr53ddatoRxQItleh61yQWOyO/nVKNCumFYy5LiFrnuW54aDkI1mRMFVXDUgPbgkce8jx3sq4ILibYfJilhBx24CcFw9BjfX8v755AHdCKhsKapmlChkwRbEIg4h5T97FfQrNLdCwt3W9kk47NRSEEBHv6rtkQP21uEZAKV1ckq1WFdqRpWIlcW3p5u2fkvg3LD/PpT1BTfyPbHzVcN8zWDZU2SgEQEZwE3KEav8ethHW7aZXruF76kmcTsdWWawsDSXFrzq5L/rXdg869
 UeSAIiX6
 9OxXCzcj5dhzowf9hCwW9fHg1NjHeXG+pSaHNo4hX1CCQsy/dtPSGZgQP2Eh9vsxCrMEtmrDRDLazYbGXhN5c9oOMoV85v8/ZzZ2iOos4MiPCNOU8Q77zhvNAKzwjYwLw7CvQmD1yjCtncAY+++hWTJKp4xr38Kkf4u43t8lIQEGB8lMV7hVGFPpXiIu19S7P87Zs6WnsFlf6ePPFjXgl//SdJg4V1fuZWd3TlRE/pddqabD4R+d47iZXTf2HWd2/n8KeFEgMm4YwO8l1hCsLf0P2SGtrfkUKwEeiiL5i6SiZGoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops
is missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the
standard debugfs attribute convention.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fe2bf2274d8a..7520718f63f1 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void *data, u64 val)
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
-- 
2.43.0


