Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E6BEB3631
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB406B0096; Mon,  2 Mar 2026 14:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6003D6B0098; Mon,  2 Mar 2026 14:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD806B0099; Mon,  2 Mar 2026 14:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0CD6B0096
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CD918A168
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:21 +0000 (UTC)
X-FDA: 84502172202.26.B293C3D
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32FBDA000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uEMuPTW+;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772481199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IA4kjBdpYkYKS/nfolmQRGvXpsjWiFeExJHfqapx5Xg=;
	b=t0UISHVFT5enM3W2WP3u5k16OcjIculLOtGQJWtcULuOl6jlOiQ+bD4RkF2XyMMmwLRUVy
	Dy79DM/Iwmf6Wo+8vXa/OompnavTownB5eCIX5GZbHUyff3FMo1Qf10JE+3t879ZID+Vbw
	UbsMKMfM/OwbZka0/apJptgIoIkT85I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772481199; a=rsa-sha256;
	cv=none;
	b=II5A4eq9N7uw3Gbl2E6bRcSG/dNZUmmoyFfUQYPMuo8T4I8JGQ/jVyrWTeuW6vbILenqEP
	5eZH2MjE3RaogaU+45rqW3HiNUPXfnA3tHwqs3wdFLtqxdshf/FhSc7ez8rNeIs++0dOYD
	rlOEDK6rByLk/l7OymvyioqPPmAzoU0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uEMuPTW+;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899d6b7b073so42643016d6.2
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772481198; x=1773085998; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IA4kjBdpYkYKS/nfolmQRGvXpsjWiFeExJHfqapx5Xg=;
        b=uEMuPTW+35bo4ezYYvqRfpN8fn1aEwhroeRM/zau10M0Are6mxicqyF/aIynv3t5bu
         VffQAtD7mK/uj46Tc1JRJxYy1LCbGuk5l2dsapOtqNacJSL2TehXJ/bOVtydzP0gyOoo
         55Gu3hjwsUMki8hwxw3TFJQjSwM94KVrhGtNSyOegPTDCG6tQ3SX9ViHmuF2X3bVWF9j
         /7asjrmifcfAF/SoGGiGSoEp0pJmhEP1wzBmvWYf7tixnAY29dLclmAz1GL0kn3BFMBe
         hhuW2KJh+TODGEVP+yJZYAxhZ/Pns88YjmIo/5JhX7msMBoZjHZ7lBfqop3Kg9XlWDuX
         A1lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481198; x=1773085998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IA4kjBdpYkYKS/nfolmQRGvXpsjWiFeExJHfqapx5Xg=;
        b=i8gGC/pU7gvY8udrmbGrzV+QlwcRnaSwOIu4cttRqB0POnC1JDnbKeo0Cli8xDcxed
         TqNIekh/aUPlKT3+A2Wzahv6XfMmX/8Kv9lWIOUqPy1zAQfoe6NFCgcc8bqH5yCFzm0D
         2PqZfxiWB9bT6+FrL63AhZtWA25l8n84y3vPjjuAA6v0XktjfdmRxq3K9UwWKHOHjnRS
         AT/uV2QHVam/hK+3iv9v8V3w7Qe8sPAWS9Rp/0Dxv1NKMrCNhBJ+HoPSkHMyslOCbi/p
         tzpE1xm1L4aI6k0yKwykAsK3IWHcyqRL3PNOdPoy38OEV4oWYqolzMu78NB3l3lD63LQ
         FWkg==
X-Forwarded-Encrypted: i=1; AJvYcCUyTHS2+rNIEJ1nLH5cATg83P9qOwwMMW/mJYy8WNskx8rpyWazwlquqsMbyh0xdAqnkN4HttSoSw==@kvack.org
X-Gm-Message-State: AOJu0YwuNrGuq+Hdm5QhBnnU5aGvUUkExjm2hgDQzKhd4vZUgdvlhxW4
	5I44dHEhFqvNX+ovHxd82axCKUBf8IpnVXLeMv1Sru4uRCO8eeGb39jlmn5oRS/rbbk=
X-Gm-Gg: ATEYQzxHNSndecTg0zGmoJONpN8eqXmC5GFsCiMpyILRe2ViacukmJ7QvMqTVIRCivS
	7GHQ6CT1JDbw6IGSXjiN1nKS4PJUbWla6qzCi/6osnTmMZ/TccctCgKgoy+xCng5sYOsPcKFjDI
	JxXLwBIAZNLecf43OrtSLEvUctscK09fRuO9DD6AsVMilmWlRyDAE96eakBH12xS09xcU9JCzR3
	EpRM/JZ9UyE8DmqgF2AdqG9Oy+CgM1iOzOm7bd1812o7nsjGFX44rx8SJykKuXDzghWN3CE8Yym
	oF5lX7BbBKsz8LwtK8MAN/UyOlRE4oyD8ZXSMnf0HikC7Q8LxbOqBZ3hXhoxP43tjUCZEm9kVZP
	obBjHl1X9PmFWZYpNp7bjHnO8HGr7Qpxg4hptJN6wxSAu2hqGd8JtSLOysamZx7wWpyovDzYyiT
	UZMCIoH0cTPV3w+CRLLk+ThvKa4m4P5M+5
X-Received: by 2002:ad4:5ded:0:b0:89a:4f:1172 with SMTP id 6a1803df08f44-89a004f1317mr42550936d6.50.1772481198200;
        Mon, 02 Mar 2026 11:53:18 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899f4fb208dsm44178686d6.28.2026.03.02.11.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:53:17 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] mm: memcontrol: use __account_obj_stock() in the !locked path
Date: Mon,  2 Mar 2026 14:50:17 -0500
Message-ID: <20260302195305.620713-5-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302195305.620713-1-hannes@cmpxchg.org>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 32FBDA000E
X-Stat-Signature: o79d5o55ty1caetfszc913ykeukjcdh9
X-Rspam-User: 
X-HE-Tag: 1772481199-611611
X-HE-Meta: U2FsdGVkX1/QrsctCRXeQY3Ox+zPCUtjAfwGok+W5ZwlpQRUI1E5/uyAzQd2LHSAIDAlQSDYTnTrNlXH4OcphHhVLnVYXn0aNFyWP5UF39sAm/NbRkQPJ+Jzevi+yQ9k1bUSCR29SQjIoGgWkB8PQfGaxXFfyzI9qZ37nx1SqYekHxeNd3n4C35UsR8RhTGC0zkyO9UpL/2Ds2I52neLzYHQyoiDz+hERA0y9RJo2Y5VzNXLApQ45FcozXzNOxxFBDEApU5kyDIrStVHXaJ/VZl0mO5jRVZcrMNeEUNYheTuB68HUl/vi/yz++1Ylnrq3OMgivRSla5aV1EBlqEIDFk8csLGec/3Vk68KHjsAiYAwW5vl8EHhlbT2MvApcpsrl/O7GzSYO3jIds0oF4+NSdhqj1YEi6hUXEsm/OprOi0aIkVv0HnYnkgWymeffj+D7I3fr/Oo5tCxWD99Hqn5N5WxnC2S9LxdYTgc2/Og2URBt+FIymHVgOBO9IyWyIns4dRlGlSWIPHKIbPwnliSfq5SI4KxJI4qZdYQpdWxeITQuPdYRvrr5/BWiDN890a/HuZy+Gf+k1egbYalB8IIv3vca6yOkPnmQtYv3G1RF9QblRMpqR0Mdk/2OaT+YgTfBY3CR6VaFphbYpUzGx8uQq3GBLb7GBnbI8bQt4VklfnF96zkNprdM+/0EYCYLdGaXB26V+co+fIfxJ6wWa053Zo001zCDtqil4b3uvJ5Ld54zIV8jgUlyqCtCtPQ7SsTF/sdGwUMwA/Ht6RSEFvz9SMCjGunMnIJRmn7qcWD7xvDXJi7B3EuKIfoqK8eKwI7URSY1Ik7yz31B2BvCeQbJpXOImjRmi2qE8kd+TMez93cV5pzQuyilLLz/zeVeE9h62pj5MTF91D1RKIhK0Za1F+t19OR552SaO1I3+X6UcHuCKL30utW3J1OXV9fAZwBWs+UXYsUlKMvwQQ+g7
 7duQmb1H
 sR9r0XFUFliLAL1MG2MQzN1m4q/BV+Hw/buwQLjMsHEjRDS7KcjKVPfqjPy288KpZDQ44qDftqi1e50bHUp2t7kadO252GfKIksor8WKPUD6yfP9XVOo4OwrzpsaluIhZsGpplwNvMn3LIXWBCHdZb1pxdSP88E9xlEduArjw3vCfW1wPR4h74Qk7GmXK4BuvS4JeAOUYcErjQ+fRCU7Ge8sg/Rk77+5TCCmwi/MtoHXKXamJbrn8kHGMCBbfdSpyf5EL4S90GAp8wvGrfvasMG+CLph7X13elt2JBlGJ0c+lmhfoM+W9Su2UP0EOLvN285OcjtYCfeaeoC1W+ktSf97hmsB/gITc7SX9Hgxmb6s4j4gZ/nIdjhmQFPfI9vNBa5B8rSxS+ABnD3TGTvi8ASnbGUxtCgVm1c54dWNFDKjwwZ5O4/VnvQueSCtpFA2TOejTAKxtM/C3RKYDjbdyzy1Hojzhs884vT2T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make __account_obj_stock() usable for the case where the local trylock
failed. Then switch refill_obj_stock() over to it.

This consolidates the mod_objcg_mlstate() call into one place and will
make the next patch easier to follow.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 32c09b4d520f..4f12b75743d4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3227,6 +3227,9 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 {
 	int *bytes;
 
+	if (!stock)
+		goto direct;
+
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
 	 * accumulating over a page of vmstat data or when pgdat changes.
@@ -3266,6 +3269,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
 			nr = 0;
 		}
 	}
+direct:
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 }
@@ -3382,7 +3386,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 	stock = trylock_stock();
 	if (!stock) {
 		if (pgdat)
-			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
+			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
-- 
2.53.0


