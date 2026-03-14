Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 364DD107BCEF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 05:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C5B6B0089; Sat, 14 Mar 2026 01:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4A06B008C; Sat, 14 Mar 2026 01:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99FBF6B0092; Sat, 14 Mar 2026 01:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0746B0089
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 01:17:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A54C1C827
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:17:16 +0000 (UTC)
X-FDA: 84543510072.26.54F3BE1
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6252580003
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:17:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d0H8Re09;
	spf=pass (imf30.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773465434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivWWjclT+Ru0LypYqCaQdIn8J9FFGj3uiMsBTd19u2U=;
	b=2rP/iS+QJqbPwa4sA9+ajXqkdyHi+74sI1Ec5JIKf+6IcjWSGZYLN9FAwhxUrcr72VpeMe
	l7HRIM9IO4IRdErkw7VdJXMVBqF/c3yz2MJKOXHdMaYw1zEEEyhdXLc0Ls3nwnFMvV9fn7
	pcSkvDMe4EnKAnBzWRa/gE51XcTPYVc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d0H8Re09;
	spf=pass (imf30.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773465434; a=rsa-sha256;
	cv=none;
	b=jzzKS11Ibv4soZQe0wYCBKRjfPX5keC4VQDA3impz5TXpdWvH3AeYnu0p5tmeL4qsdhN/X
	xPZ3HER5xuhq+IuFEJh4nwI1K1Zo5Gqvc0066wLNdg2f085WjrDKW5dRooB+S9pXVsJWHj
	iBTzZU7thptQnXlDBAgisIwoW4BjvmY=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-128ef4dddbfso981344c88.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773465433; x=1774070233; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivWWjclT+Ru0LypYqCaQdIn8J9FFGj3uiMsBTd19u2U=;
        b=d0H8Re09VcOQlwNESNw/QTTWjffy16aKpdecrtg2TopHGXGuIMe9lQUnD/E7O9Tm7n
         N64L8enP6Bl+ri6g+tkVN5Y/m1L4M5eGTf+8HW/UXd8NnP5mMEmMek2bFnDxUFgaSBHm
         ADWRDMJ7kxqmMa7zEevPMuCc4U6dYlJP0Nx6H5Z/zco04mXSq/unJMyDTKVHmA0cH7Zy
         hR/hIFG1UOYeghlECRF0TRwexJ1H3u4ViOmnsrnEBAtVq3W4nNZn5dTXb+Y28XBLG3xJ
         hazWzmCao0d6q4XM+o3FR8Ktvd82sKdIQM8nkEMvZDd9LTSi3J56J+vJtq63reFp2hn1
         CIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773465433; x=1774070233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ivWWjclT+Ru0LypYqCaQdIn8J9FFGj3uiMsBTd19u2U=;
        b=p8An/rP2S/lzW1giUWpeZ2CsBrSQ6koxXR7jnQ5aRhR4SxY/ggm/uDx+p0/Eji0OI4
         PsLK+X1tZlOKlVENkMPx2m9jmF992q6cfA18P2aZtvnU3xPQgq/Mtl3YQgy52vX1AIil
         qQdOX+LAOkdgPrMA/RhmoR6kAOxO4T6qVPsuOyyLXCkPHeKXohjUKA9k+2iK6KScIR0H
         y6lJ5TsrUJLF/vzP6aiaZazKqA/BXDoUE+fq/2F0MEvaC9ctQx0vX/RwJLj7vWg6Kuie
         kPdGNbls2Af/V686OPVFGGoUR+cxIY/qV7onT7IDJQc0xGq5u0ewNPQ8TzLtXMLBbuJT
         uPLw==
X-Forwarded-Encrypted: i=1; AJvYcCVtLIVEtQvm4dmNV/eYlL7H83RzuyPaQ1WBKovZks/Kt89DwfxrG4KcVtH8zhpuRnYj1UpCVhp5rQ==@kvack.org
X-Gm-Message-State: AOJu0YwEntg71W/KG5O5z+NpxFWlsLNXfFqPF+MKvB5fZwQyHquRZwF1
	GmGKJjPEgK03u//t7wrqEdhhvdHzl3I16F2QZAh2aI1vVfozg4o+DAYF
X-Gm-Gg: ATEYQzzFEtPOqNP1BaPwYv2LbE1w4zozT2oCrZz2Re6bkcxB40V+f9TGiRpEzGlWjv9
	NLvjrmF7vPNDJ4GXPYhG1WFKZo59P5gyOOsTQXkUhX8zzZ3NDNah0SLGqyPTOJfAR0RKxt0F3lI
	jTpma0GAgGcqz9JkS4Akc+/RAKq79GIQAX9xidO7Drn5jtz9UzrWpAnNDOveT+aMv6fgG5fksVf
	G8hazyDGV+DEzi9m3kMwLmXRI+oC4XRShh3PDVStLO8UCJjoSp/hbhzODt12tsdD6JR1j/EYUxm
	+a+cKZ1z9yxa4lIRkUQaBf9aRLm8AJdQPZxkTM8YmkjCBaB9r0vD03LsROsXrznaZs2hXdIMQfJ
	SXzsnHadeaxn93mTn5iMKqLKUt02a4jaueZvIjU4vbav/2MwItwRlA/dadFyz1gWCV0akHSz4nP
	sY0rliMpjrHCWqTzTESNECVb8=
X-Received: by 2002:a05:7022:41f:b0:11b:f271:835a with SMTP id a92af1059eb24-128ecb72641mr4293252c88.3.1773465433110;
        Fri, 13 Mar 2026 22:17:13 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128f639a160sm4856196c88.12.2026.03.13.22.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 22:17:12 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	kanchanapsridhar2026@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	senozhatsky@chromium.org
Subject: [PATCH 2/2] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Fri, 13 Mar 2026 22:16:32 -0700
Message-Id: <20260314051632.17931-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6252580003
X-Stat-Signature: pqud7inbn9eg8ii94bypgfuwuodydi4k
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773465434-433754
X-HE-Meta: U2FsdGVkX1/G8druFZSdGZGli8inNu1YzPy1FYGma+vClYLJaHGzInKxqpIN8oycFXJMOIBOZsQPFGQA9Z9iuZRck6dHpQwuVUHPdZfuFRKGRCK5jmI+P9Jj0ahnaY93IctzohAytEywguGmT1aHyNp3ce6D6yrIobXXNT4E5Ta1dlDFQ9E9g2VQyfI850sCNMCOZNsqI9LF4EQFW66tRBkA4hJe/tlzvHeQ7gfA9FZZxzTmMG6REcK8LbZR+NDu+RFmenUql0vhn+6NijsCoXV3Na/3INKUIwoDdjDTdIiXOmjeSiMGoJXHXnqSebLc/O9ff6U8Rz3PBwPvLOnjVOHGUWp0Vayn1Cw8dE7N90iuDzQLbgLJvY86FW8h2Z0ugqrdSsPUUwkoDGlVbfzHb/jMqIhdW3jt8TweTEozxzKzEZidavTBWKF873Az6gxatqAfH39CGH2d7GHxzRt5jdj8bBW0Jsp/ZvSY3D+1dHKKLXOKoOxScYd5A2Xt6sZhKh9yxnWcH6EyN+pbmUTXGK7ctuAdtzZFC3RonEq3h+uK0s9m1DZvZ2mJHcYdWVCgiOiOzlG/twpFj2QwKDLza+8W+hlWnGvnVUB0JCxpDrf7sg6wIC3ggNfP4S13OaAyUyhNqbUe1jARIZ1N0fKhIv5W2l/hETzXukqHmRAbtyd2iaeOt8LlNtSrjhqphhWJLYW8V02heueqDjpaSPtMQZlGSkw+xH/6yDKPVZcyUSr9fKqssZXseM7d6WxKgluzifgI7aMxpLreurUVUj9UJSnNtLRL6mre3NG5fXFpucOFBrbQyzktENXwbVUQKxU9qwtCXGV0o8uD8PIZAgzw8HYJ14igCC70/hdq7KHhX2iJN7ZKp63KoQ1AEP9jrK/z/26Qa8zSmDp8z0zzqu+sxzlH/5bg3gT1xzTaYsR72XEN9DgevkV4cfKiasyYzu5tXtR+msqAetDeMKyvLI9
 DxbiEfqQ
 o/iuksUL7MX3hvR7uUogdtzjEekqGf590XgWKzK5grD67bsXLmzHkHWRhOzECBhv9LPacDrLI0y8Ftg+HC11hvngVDozlKm7HLH9G2p0Cngjlbazh6Lg0XOXuW0et4+i+coeCRR0WhhuA/yqrnhCIaAphZj7U4F1jkp7JMqaiFzVYEMNT3LPyrr15R4SqizUBU9h7yZrmjTMfHYDMOeOLlyBMVhinRDuFOEP5oWCh/CKUlFxJhWUGZmFNvfk5fUPixdVYIeJLScmE5o+7Hyk4r5m1Y7pB1YJUzEkfYbKCCyVPXU7dS0rMHRr4nCiy16GYP0qdG66eziVSgwTxfPjHSUNwFZJ9615z+7ZYj1EtSNzZsVZ7pxUzYeWM1edhB8n7rrRLNqVvyjMLo4O3PvlyXrftyMR6mS/pBTWpKAov6gmpJE+mLVHBBJT8fAgrEXT90i69I0aqeXma05GyB2h40z/JbG5LpXQb073KWWFJz2Y9zsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
acomp/req, making it consistent with acomp_ctx_dealloc().

Co-developed-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 26de0468e33b..6c6c14433556 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -786,7 +786,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
 				pool->tfm_name, acomp_ctx->acomp);
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -794,7 +794,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	}
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.39.5


