Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39887C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 08:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD14A8E0009; Thu,  7 Aug 2025 04:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60788E0005; Thu,  7 Aug 2025 04:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA928E0009; Thu,  7 Aug 2025 04:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAF28E0005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 04:27:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23B2A81E09
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:27:28 +0000 (UTC)
X-FDA: 83749282176.14.A993301
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7169540006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:27:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I7Sv57ur;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754555246; a=rsa-sha256;
	cv=none;
	b=u6xsA8SZAY4ecVeyMYHf7CAJHGleIjokmAAEeP4gMek6q5yyd8fbGkt1Nrvnd66Y5Y3GuM
	ay8/bJISy6WnHJ08hCOOyUxai+sPBFesgNUXzTD06146vboZOIkPmBrweN48nE0puOAOLP
	PR4g1Vd5lN6dOI/q5b/P/7MXhQr4A9Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I7Sv57ur;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754555246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=MB5v8JGVoli5uQj8yN6hfSf205U6hZvlHyAPh/SZM5g=;
	b=2dBrRQbZrNqSrEJ2dugfBYFuEMBVgn2TDcGkH5Xnmxb2Cc2La8hvcYbKKouNMv4r8SSQ2x
	Z88jtuOgyqMmWAwLIOObwVsH4xhAmxmVbk3G+vsNZ+L+8nADykRrL4brZZgFxiDz4kwT4e
	K8WPPjKKJroda3fsRff26r2zb/h+sZQ=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-615d1865b2dso1119730a12.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 01:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754555245; x=1755160045; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MB5v8JGVoli5uQj8yN6hfSf205U6hZvlHyAPh/SZM5g=;
        b=I7Sv57urPlY0ts5rwLcFgTD/1iV3S44nQ3w8LSBupx3iB74j6bNshFIPz5tjHYcMmu
         WXJ3mXBvaesHqFWlWZVPU1H7hnexLJodn8ja9cObto+j92zgarvfneo73iTN1UmUD4oS
         onwbjuymB9Tgcef4omg+cID2f6UHHgqvpalAvWotJdd8soGVGsIizHzMdj2BkuPzHiaE
         6nBNUvWifuHhGAtUNqSg/kfjnipGgRVq+fp5V1bL5AGvM/pMQD8qnDkbi5MsIn0T6NkA
         zzh2QNIT9z/IwmdZB/OneFGSIumGmkSNNNCxvPwmVfWiGeiuBG3mb7Mvj2ROPOtsC7D9
         7+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754555245; x=1755160045;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MB5v8JGVoli5uQj8yN6hfSf205U6hZvlHyAPh/SZM5g=;
        b=vEUlBhkv1/gaxLq3Aw1KdOCmKFbyXKu811eUiR3sVS2QYZl+BUyhx93kI9Kd2YzfQd
         r+5H0pJ0LOT7teNH7HhaPNfukwpsO3cInB86E3lSKBeIDUh7jjbWBT8DiPtcPGOnp8d6
         On3EUef2qhql37BbRcaXf02Ot5iidyEoqtLKGWWUTvuQEjcJtSbSv/qVoIExX/IE95yQ
         o5gMvLbjpoU9FjVncaNbJJgpc+rKgj9xksq2tSWIlTKULOeKWv6bzyv+aZDU0xLw8SWM
         DBRaoGdazEYQ0VlRIg0gebROn3JsmptiEntN9jTbEMA5737fPVAeyOTey2gs/DBPSFc6
         2apg==
X-Gm-Message-State: AOJu0YxLvPS0du/jJC4llrETsez3BeTJmXdL4UfEpvkqWHrRi35LGrMU
	udnY0l5OyF+2Nbpof/X3/8y0jR7HlTXGX0e7ue/Lc578HkYyheedJIko
X-Gm-Gg: ASbGncubpxjaRLluLDHQuagC1Vvn86HlvCHTPVZd8LC4ol1ljXiDgTTMHzGKD3mSCPZ
	1j3/aPVykz4XvIPPw1XbkMDyQ8c205Q1+A0krj6Pp++yYbMd7kXQIMeuZHmGz3ti7PZfQS94QES
	40mIHPuBYoc9Hg33KQevTKrbXN53cBJvsy9uOwDksAdGf0inV0LLYeYfYdq9JXbTjhsjl5os35v
	EeaoHw6q/a5zbIms/nJ6VE6XsiC1UevJNRzAcqSUjwnMIDKEa2sg3PuxMi5HensYVRlCL9rCBuX
	w5VNYSAvY7b7gTIe/ZYEiEH0n/IbFI3viMcOXeCAwC5CV8eFUvzJzwcaPynmzZAFHM5H5QswsP0
	WWE2QQDPuXPby7xWVTzpEzw==
X-Google-Smtp-Source: AGHT+IF25yLQAf7eBFUkgjncLAroRpjuNfiRZpFZE+k97LTJ+wCTe/63+BHhnOb7vJno150/ttzAGA==
X-Received: by 2002:a50:c003:0:b0:615:d633:9ffc with SMTP id 4fb4d7f45d1cf-617960d5358mr3434967a12.11.1754555244428;
        Thu, 07 Aug 2025 01:27:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8ff9fd1sm11299450a12.44.2025.08.07.01.27.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Aug 2025 01:27:23 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] selftests/mm: do check_huge_anon() with a number been passed in
Date: Thu,  7 Aug 2025 08:27:07 +0000
Message-Id: <20250807082707.30647-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7169540006
X-Stat-Signature: 685in5tbhryiq6hz6jksabdnz559wq6b
X-HE-Tag: 1754555246-832704
X-HE-Meta: U2FsdGVkX1/z3/LBY7A4URwOx0ImqV9T+KLo0iz/Ca/QHys1SoV1v7tYPqfhMpey0iUeFuKag4cf9eIzwr6YFEXH+cqBkYXq7sMtfD4lXBp6Nk054RErbI89V/5sLErM1TQ7uWmzYtdaVI83IlfKq13HebGVyUPcUkV3fZWH/lN2edPJ3HCB3Hi4IDdM8ngK8kePYXLIXnTVV649zjpCfRDY1QNv8EKb9nFad0Ja6bu7/mL09U98zvxK082mLqBeA5yuD6FGF1iKxpN8101ikROtweXV8dKefuTDPq6tYLaI7pvl2TupgFFKT6MeP6tGlaL6bQBq86+1LqcGuhYPZWFo7ArCgAiqG8yuhISdWTEnRJUEON59Y1d56WCcXz25zWDkMXK/jaodNK47gYPMSgNt/0o4kSkWGSFQifaQp6N7Mh1dDkUd6J1aAOhp6Lwe4wA+lTB9XiisEhECmVfPVdgXOpQT/AcmE7bJz5ySmliQf/HYvRnWvhP+kwjWQ0jLWQz2BOtmM2CC/DfzS6w74/3yBUd2f6E2xDzhAdYKYvOUO7tBKYimYlkJh+TaqG2+MBeZ1KM9HTntvsQe0zmderDB6/SrW6Jkbco2MZlibIPBrNYlO7vdx99RRAKwPUAbmiqr0r443LauwJse6VEeLPwdklIUbu0AyH+OXQW3WpNQpXRWGXXkhULf8fE80c4awT+tBfeJ2CIaSFqlJCamSc85KQh8rmYg5z6niJdPRb52W9J6Xsn17ULRTVLCY/Y8lHGZehIh6c9C7qfUYD6P4J9piC3IykSSxPPHkpOLGHldGBeYcB1JpD8P7oRsN9WSx/5Vy6AliYn0lGWSwrFtSeLYXLoKkGbVe7zMELKcweJ4p1S8mbaUX6UiX3nenMlDGtUyatKX4uXr1EEsrC1j+6z28CsPjqW60ZhCJ888cXLtBUlU5yzPrRxxdE93RwfCB9WI9083FqgantskREg
 kwXs4iEu
 l1+yxd2QyYU+/1SNXMr7rwjG99AUqSKdYKS7UXLjx3HoVvBgXfz0U9NKwuUdqCbAzB5nqDGeQB5tg/CgwDko1+weG0sR1RqqMbqMUx2z7Uf0/hdba9Ar/zKnlr8HrVL8ahY7JlqEcMBlE+bM2qP3qHyYrrnnnCBYriM63BndnE8y+JovALxqIQhKCqm7Bget2QN74fBrsc/Yj/8fvBCs4jpGG4opBuMHe0YEzBktiM4roH1fPZQuWV2+E2QkOEtEn4emN7qu49HG7FVVanEfrtXTgHRsSPrmWIuNWfJ0yUF9F5Qqr9Kzp8ABjFNajGdJqtm+mtiyNWGwtdm6VbPDr2cgE4DoTOoklewT+N7oeXVRfq0hVOSr/Ma+DUPq5lGlkPnCdBE1hqIOpA7F+vCLU73uqHkETiJwSmgXzTxTgsEkuIDayK31kNJYIOULhZkXfiC037JnbkF5fSxCaBo0nk7EGKDZrM7l2jcjted8t3QCjzT9IpdOcGhWGKueuXz015hMX6dkrO8+PjoyEwjrlRjBm0o7heDdqF+cLJ0bXmsnOBjtI3EvPahQ415OIaD8vkTau
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently it hard coded the number of hugepage to check for
check_huge_anon(), but we already have the number passed in.

Do the check based on the number of hugepage passed in is more
reasonable.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 44a3f8a58806..bf40e6b121ab 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -111,7 +111,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
 	unsigned long rss_anon_before, rss_anon_after;
 	size_t i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
+	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
 	rss_anon_before = rss_anon();
-- 
2.34.1


