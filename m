Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F59EFD88E2
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54ECD6B0089; Tue, 10 Mar 2026 23:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF116B0095; Tue, 10 Mar 2026 23:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE566B0096; Tue, 10 Mar 2026 23:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17BEE6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:03:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A287F14046D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:03:03 +0000 (UTC)
X-FDA: 84532285446.03.A5676EF
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id D46C41A0011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:03:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="d8w/gPxB";
	spf=pass (imf19.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ly1IRsMskN9R+65s2IxLzpzlj0ryymd9c9VwDaOci84=;
	b=hxkrv0QUNfP3tTOeMHCytfpsVSwopZ9DFe365Nx5t5GHpdcH6okZHECdCxwRqJ3UXNEH9E
	9w9p1ignj6NUJYsukQf261xHIeooViSxb5Ehm7Ysuf33Ths499NXc7xRJjNQ2oZO83nwql
	abKmjCm/SvNpYzGnxgw+abJHsVUhmTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198181; a=rsa-sha256;
	cv=none;
	b=npaGT4obDli/uUfgBuz8NnHaLaNNy9NcyjcSKBRmAHtgqSTbjdosISANfd+j7sqIPNUN3D
	dkF4FT8bSl8DFjoaNzxuKs3ob9SC3ASrkl1SiFPiu24KkqUSzYQBkCsrxZIFcSpT1cf1f+
	ZV9eve+8O31ToTCI+37nOlzhqFnY1g0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="d8w/gPxB";
	spf=pass (imf19.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ad21f437eeso4192765ad.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773198181; x=1773802981; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ly1IRsMskN9R+65s2IxLzpzlj0ryymd9c9VwDaOci84=;
        b=d8w/gPxBozdkzqYlYP4xYAREkXd4xWlec/TEGQ7mGfxpkfjcBS6+U3Z+Dm3qMkidQr
         G0QPTBTixnZeS15x0uuIngZ0Xq6DvdtVdOJ2LgmX12L53Dan5WDZQb3YSMKdgZy/i8w+
         1jsWoBDfs4go661fNdoqdLHqqPQyMyEK3ZEdllWa2Nmkx2dcG7o9+7X8wa6kLIDCH6Cj
         N8NgaU8K5o95nXeHExbRS1mKYvm58lClDcOuvjkAuvlWS6kkLDyt5sm2AokVd8O7u4wo
         fMcblf4+T53xgqEJWcRJchMeCdlcrguvLTPtbYPtgH4JSdMqoV+ni5ytvOAVzlmqvorw
         rD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773198181; x=1773802981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ly1IRsMskN9R+65s2IxLzpzlj0ryymd9c9VwDaOci84=;
        b=xFZh62n7hG1Lx09Y0ces78PtwmTXYa9ITm9PYx7xkSOYl4Xi2/4Yxd3I1TBCM1uJJ9
         e+0AiehqZaSQT8zXpRwpmxN7lQdkWz2WjRUUELpNE4RXNGVFcoqjIc3E9pyNnuO2b3hS
         g3zqwup0J6QvgGpoiaBc1H0hqXhoBvvtr1LlGt73mD5RPY4qNOj1gXg765m9eE/aBvjQ
         1o2JYs21TvO6JtO5US6vbQpVbf7ECbs8enewkYbJHhAZ8ek9EnJgj9QJw+s/4WqYIsP6
         A2B4UTUD7pB5Lqhm8riqWpV+dp75wBGxg3BsjaMMXMgsTxfQtjwul8Hp/xHgdayjy0rM
         u6Ig==
X-Forwarded-Encrypted: i=1; AJvYcCWpHFXePnFgS6Bft8SqphPWDavnAqsyivmUpO5vU5bD5l++o0foSWaJnWasNdIoasEheq2p7O7Plg==@kvack.org
X-Gm-Message-State: AOJu0Yz+fBKTGU9cC8WrgJDSWuWxM9DWmiphKLUurp+0HDqwzX6ysOCe
	vlh+ARnRh50G/JWvzYrvGb8aJe6Mwt4086kdzrogQJ1sHqMvRo2QkdR/Herbv3oIcXU=
X-Gm-Gg: ATEYQzzWA4wZUpsem1BQpe+TYyTPAzVSvMvc5ei3jBcPgry4sKa0ji//9zr1Ghk2KfM
	m+zQzkvAUfqeuSvhTx6VHiVdO0Pp6UAVm+3u4ZYVWNiMB5Yo4oX3K+k2h9h/KI60p9UoGpfSKgW
	OVcXynJeVB8Z5/puFHh+lIfpa9uOtEnCJwsjCD1DquHq1yF+evZHXk9ix2i864MM50DI3riJOam
	eCq2ahtHKPKfeWhO5Guq22ROwGH5wbWpqUXfn5UyU7qRdcAH0qqDGuAu7kXF4cBafFB5YZhE61E
	wGOvIZ3pYmKtuVZF5B52myC1shg3nKWiPjnwnuIHxf5ONHJUEYfU3MnTiDseoYgxMGvxD87UC6H
	QOHWiNU8WIrqRDMvSQst4/vWvZ2+lucfO8w60nZq2+xbI8Y72dV25bDFOcqhxqH169WA/KC7hJI
	E7DDn3b8Z0yg9nYS/8Foh86nGxUGc3725qfWh5ag==
X-Received: by 2002:a17:903:41cb:b0:2aa:dad4:dfa2 with SMTP id d9443c01a7336-2aea1de84ccmr61348405ad.18.1773198180714;
        Tue, 10 Mar 2026 20:03:00 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae378974sm6251555ad.82.2026.03.10.20.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 20:03:00 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	shakeel.butt@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V3 4/4] mm: shrinker: remove unnecessary check in shrink_slab_memcg()
Date: Wed, 11 Mar 2026 11:02:35 +0800
Message-ID: <20260311030235.240953-5-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260311030235.240953-1-haifeng.xu@shopee.com>
References: <20260311030235.240953-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q8kaasrr5cd8u4ia1jtdfxtjgtbg7k7a
X-Rspam-User: 
X-Rspamd-Queue-Id: D46C41A0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773198181-610779
X-HE-Meta: U2FsdGVkX19Sp9HRxBMaFBG9AuPafFN8dVlxT7wprPS0WjA5QHbesdM034YC/OgAeWn8zmhg20wTyv5H/9ITd/96Hn9TYYu8vONGOiVPkq3Y2u9I3reS08gMeh4A8Fs1/VccjvUhIX+OyBumPZLcTYypJgzonCCgTDRsNn0LIak1KH2Oqmzwaqne0YZFSE1JsRZkv8kQuKIW0+n963HGKrlQimimWkLKMzVqyuY+7zLiYeOBYU8hQSdrhCfqEPOtTUTbAjSziYiUguAAkVMmmRqA33KcnfliUkyMD1UbRmIZTGom44fbrYGEHiflHk0F6aHzga2EkOexhMVdTfcedCjTSG1MJ9hSkd5KL5U801CUOTkn6ZWjWc5/dVcaCVlUEU/29x3IkS7EtWHKMEDNle4BIHfd73mldFJjKwFmG9tcPJ0VbdbNbPQcIw0vDnERV/MM9QsWA7tlrCd2feTv4UbAfyo3TcnJmzeLv3AMULb19CoNB7BiM9Z5erOZ/fZ2Hr6GQNYQPbS+p0FgOG1EIrsOPMcgSzX1PwmCbhQlFyxORtW4QVsVO57QEz8DLmBnyZO/bfBVv3uM5x+NuYCCuLYSNkJmRhzuu0ne0DBTzbsy+wF6savZYbyLQPxEwJWf6vXbYWSvLeIIFPmdD278ztB3Hf0XLVrxfJKmjFmpv3lKZ5bYGk23/1Xyd8xdixQv8f7+YWcy0PTqBwwukmWxHf9wZgYF8yIbpU/yckYJLqBvbV1MS+pSaSYgI89mhMst16GjAQ30iEuUcivTRDRxlbGv1jVkka+IDuENR8EMplQGu+DALl+CRiAUexBc+++5y+w+5GT4kkBScAMHNh9RqdIwhh3/Flz3JX/dQsAJD015LgWfjGxexO0y57/Ns+HdsUS1jJg0b9yyVkWHqCLZAay+Q+uOROdaDXey6CMDRPsX500Mjf/7w8o6+/VLe9McW25hQYMCViXnh//rWo+
 +DQAcufd
 DdIpKBlvjyMo7aQ9f+ln2H+Sjo4SAhRbljdPsbzVNhasdzIL3/lRUleiDJPrzCh6uQsV8lCaCKJbTR0jT8ZgT7OumAkv6x9bXIXF7cPloF35ZbjAp4kBFryfK+kMZMtWRVslXo0MsJoj+uIhNon32W08aZu/weA+4Vh3NXbm1TIJH1/n0dAcwrc8+rniDoprntES6QHGLFRPhZxG6L06nV0zR6ztR9RgQLLf4MSVftm0bKJXju/9IxMngj8o+8CjV8eVJEardTHRv0N0UVDTQmr00UviCORHxnzhFP/nxkBlj8WaZ8fQqMSbDY+itWuT0G46DY7Yt1OaH/wPAdUXIimlzBJdcX0ieUFeFf9dcx+S4N5lZr+why+9M+ZqOlBxT49QL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If memcg_kmem_online() is false, only non-slab shrinkers are recorded
in the map, so remove the check.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 mm/shrinker.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 3137518bc746..98307a9bd00e 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -639,11 +639,6 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			}
 			rcu_read_unlock();
 
-			/* Call non-slab shrinkers even though kmem is disabled */
-			if (!memcg_kmem_online() &&
-			    !(shrinker->flags & SHRINKER_NONSLAB))
-				continue;
-
 			ret = do_shrink_slab(&sc, shrinker, priority);
 			if (ret == SHRINK_EMPTY) {
 				clear_bit(offset, unit->map);
-- 
2.43.0


