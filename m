Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184C6E8305B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F83D6B0092; Tue,  3 Feb 2026 02:38:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A58A6B0099; Tue,  3 Feb 2026 02:38:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A46E6B009B; Tue,  3 Feb 2026 02:38:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26B3F6B0092
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:38:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAD921B1A00
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:38:07 +0000 (UTC)
X-FDA: 84402341814.16.E0670B6
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E38F40006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:38:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SFndRfY4;
	spf=pass (imf01.hostedemail.com: domain of ahacigu.linux@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770104286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZW3zcDXO/m+PtgSZ/2Ye1ofyHulmsOvZBMcJZnJpLrE=;
	b=bsRMfPsfhTrYmzFkNLmylUb8W3vWbiS9KuvsaCHq1+7mk442sjhqzMItNpqg42Fv0wP9nF
	rKYnt9N3+CykKe7f2ablCm4AHpYIAqWF9f2SR+78uq1R5KTFjZqk6EXh6X5crGP6Ml9GTr
	Q0+8UfWUQbGkmF+r4uUIm+Y1LJxxUW4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SFndRfY4;
	spf=pass (imf01.hostedemail.com: domain of ahacigu.linux@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770104286; a=rsa-sha256;
	cv=none;
	b=xLIX+GI/sELMDMpMceqtQgUZXAf+DHcrI8l1XOdnMGdAvB5EXtYazf21wISG7RSFveeI8s
	ntLbCU0dUtzVDaUF1BFJe9xU0LH5BQHELc5une2e93HMIkUA+UNG90D8yJoAgkLrEcGmpl
	lf6dU9N7Ey9mk+/be9n6ZDh7NkkOi9I=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-649ba412cd4so2283768d50.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 23:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770104285; x=1770709085; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW3zcDXO/m+PtgSZ/2Ye1ofyHulmsOvZBMcJZnJpLrE=;
        b=SFndRfY4E5b93gQmW9ZkRjhsv91F+tvC96y1el/qo4P4gRHCFYqptumpAmSiTCzQWJ
         iI8ATc07338hSwJw6MHFyItnhFvv6uNLAI2/+GppWSFnVIcIIcJJeoOVASHOwwuPJX/T
         r06H6lgxwp0amzAOD/nhVReWYWAtV9l6VJyCcr0RqpIIS5UBmlBdbJDOzhUof+NetSO/
         GAkMeSeSkUtbHOuHDacSAIosdMH8xUxplCYnCyzdtii05JMGUhXBIJmMRRRjZS+H/Yoh
         yZJ8OFoIBM3Hx45D52zWjRHPR1yCkoHhEiIFL97U/CYFpcRscnjjLMb8ydprBynXHysQ
         aoog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770104285; x=1770709085;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZW3zcDXO/m+PtgSZ/2Ye1ofyHulmsOvZBMcJZnJpLrE=;
        b=Ja+A/Xc3TfDZWi0MzwgxqkjByi/gX6dJqGdlGtua749XGI18QWB18Q31lmJr2E0tiY
         c/e+Q7PwDZYFo95T4goYlcZYDmhhbQfE+pCQjJlXRu0A1RNG9D/lbJG4NHFEpWn7+YiO
         MnFcntXcWbxjS2Ip8Yb2ZRqi2gl5TUN0142CgzJosYPLepvMISyBdSZbL4k8cYsJYuVr
         TEcrSja9knoluvXAy8Cq6i0Wd6b8px5sRhNUwrK5lhuyLe5kLJfpVWqOWJ+F5g1SYkyS
         o/xtdf6ZxyKVdCyIEiGqCD1De/nagEWBrzB0f8fig6e8aby0VlqUGVsGp5u84FOw1uc3
         shfA==
X-Forwarded-Encrypted: i=1; AJvYcCXGW/T3oh3ftT2JUou/SrautkEy5J/f2T+UNsKvomzQHCZn1PGRiGwSKhNSWqUv/KcCRwb6/M3BCQ==@kvack.org
X-Gm-Message-State: AOJu0YwlZ6SOGQH7rwJ+2XD+KNWZug77nc1BxBjS3VOUWteRw9injf7c
	rzBh4txdfnwUxqB0cw2NgtgVDAQfIdNLTL7k1DzEiJ8F1Bp/fr6WQbCo
X-Gm-Gg: AZuq6aJhyuw3nmSRecPZYfu4H2Xx/KPDf+bGdnSs23mWXPzkZcCMGxBjzeHm1dR+gpw
	7ev/cqgdFj+2DI3edBXKC360nDJ2qnkswfes+ZxV2FC4obhO9j7Dkbd+iAggJkOdAphZ6xECWDL
	YuJXM4V4W5FMyimIIH6L6YjAucTF04T9++CKCBGz7F7b6JwOaEZToSDGhJllxi6AaY9PwpNq+1A
	mKgJIBVt176dKYkfu2jCiTOKvTaYv8Apa5f40pUtO5btAH7yvH947IdSk0We+64WT0845Lr4fVd
	MPFZLYNcpyxOyDkx1g5xZ7DCHcNJtX9D4piEwQ6PkpngjyU/UJsa2o2TJNtYhkp//LdqYkutwlX
	of+ntaLP248Duo31f3ZdnK/gFNDLiCaI7IBbP8NXJP6DRSFJ/+uQelx0cGCkVayjPNCxO2tzUV1
	mNwdqoxkXY7Vn7SVwn/Pj8ef3g1p7gJTMqU1+TwU4=
X-Received: by 2002:a05:690e:1288:b0:649:d502:3bf3 with SMTP id 956f58d0204a3-649d5024d72mr617069d50.67.1770104285030;
        Mon, 02 Feb 2026 23:38:05 -0800 (PST)
Received: from host.td.teradata.com ([2600:1700:7c:96e0:f36c:cc80:2358:72ca])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-649c195cd7fsm5570268d50.15.2026.02.02.23.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 23:38:04 -0800 (PST)
From: Altan Hacigumus <ahacigu.linux@gmail.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com
Cc: ahacigu.linux@gmail.com,
	zhengqi.arch@bytedance.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
Date: Mon,  2 Feb 2026 23:37:57 -0800
Message-ID: <20260203073757.135088-1-ahacigu.linux@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E38F40006
X-Stat-Signature: 7zugfbkcd7uqzxp1t51tseui34ujhix6
X-Rspam-User: 
X-HE-Tag: 1770104285-505477
X-HE-Meta: U2FsdGVkX1/xYb96MeE5QtZ9/PeaNboT8dQumD3ePiGKtZqmypSlrJrzY+2FMPegI4/KjUYPdLnRVfJosXqLv5CJx2a5wGqmI81FrJVK9jKom7ZyqNWmVWYVoNtam0dDerZAl2qZLjQHnCbgtBts06AxwUpj6j/fduyLAZ+P3RAupW9M+GO26g9MLfrMNC9sEFsk5whsGDCNJcMsojhfBrLyxH2LxqBdBtGAI8OEFOg7ERJF7V3havlKvH9AKviMHD04bbaSgpHEskXuRmZCj6bmNhwCxP/t+VVB1ofE8NMbEWeRBXUkhefhEMNO+bpbd1mQmepVzvnx4zoN/oP+wQoKswotw4G06epcj0UN2nWF2HvwOurAdecesUJdSV75AXc+4Um0QEzgMWVsfkX8ukAg8mpbWbmTCRtkZLVc4Po6ShQTZ51if+u3IMR9zjt32XZV3T5JqTJXfoi+vurxUVDFRWMHUlDUgjL/edwjlCmhh4gzTfftVWKkf7D5vRcVrRkDUdntxwd9qVDKWngoQ9c1Yy08ote8huftDhELU1bByTO7MuI28JjO22doBVa6KML+J6eaWLQlVhGp5Bfj9QBH2hBbnedg4zxYYesjU9AMJsBGKjn4xsgcLhAbRikTA5A4XijtG1Wq8dOWHmYMUzRa/YBRXCkjJpR8bRfgqIoe6u8zjqJDe1y3Zlpz4Gvi/5z79xJqDLBNOd2z3NyhiCGy7NB/GTUKRwSDdkMzCAFqzKypDWH9gqsRFBgcd/iwvjg8B2E3KE3+gF1XH9/aoNMaVK0rwVmkCfaVXHThvrfjw7iWWbUhVVQmNRUGZa5gV5bMD2H+emCT2RTEBvApN+A0MKqldTkx4+NO22o0nGs41mglJL++kVBuBRyHd5Ky+HQnJMlDSejgoQ8KR6esgRYq7nvGzeyxL44KHj7zkh4rVObLol/yy16etzDO1c/QAKRWbfpnqzA/JH/tMxC
 Wp18hEuy
 NjQE+nIJzThg0W1UIf11OzdR9XM1ScviepCa7Vp21MGz01i+Vj5o71C41gIiRXNcjU3QBgCCU4+8kDI+/PnfySvcQ0Dpxrg9jiZeYiyiQGmCDc28ziaD4I+cpuesYskVdhxrmLrXAhtL/OHBrFBcRMl6Iefg+JsTURLYx4yGTAu+swCVz9g4vjZL9LUYCgjNHKVn9775YeIk+o1rrBDBZqn65gAk6SKOrxzy9zxWsRw7CKAV1KcN4uE9Xs/crk+kYbgRdkgvBuLWKWcOiXRl8fwSWz8zhsWgoLr/7X1OQAd3RQY3itJahVGKnQuwOn2kESs3EVyqyGusQaj1aWWRF19Uw7QJLzr12qyaXMCr2HdK+cbEMpk2iPHXBhOTSRRifOfXGA7b7Bfpgmf8uQvcFcz3CHyjnJE/040q5LmA6S9phIKiGkl4m8QWFN5O8y3g81GyMt0MpAQtAbS2yM0wfBwYCFe8H9Nisar+VTZP+V2rnVmdNFL9hPNqhMvdxW/f6BZAOBjO0BZvCeLKcEp7yZca45BoXeJeOHeNjBYPB7X2iuashb7QmePHgrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000003, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kmem is disabled for memcg, slab-backed shrinkers are skipped.
However, shrink_slab_memcg() doesn't drop the reference acquired via
shrinker_try_get() before continuing.

Add the missing shrinker_put().

Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")

Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
---
 mm/shrinker.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4a93fd433689..d0be120488b4 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -544,8 +544,10 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 
 			/* Call non-slab shrinkers even though kmem is disabled */
 			if (!memcg_kmem_online() &&
-			    !(shrinker->flags & SHRINKER_NONSLAB))
+			    !(shrinker->flags & SHRINKER_NONSLAB)) {
+				shrinker_put(shrinker);
 				continue;
+			}
 
 			ret = do_shrink_slab(&sc, shrinker, priority);
 			if (ret == SHRINK_EMPTY) {
-- 
2.43.0


