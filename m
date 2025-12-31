Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0384EEE57D1
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 07:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B046B0088; Wed, 31 Dec 2025 02:46:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5229B6B0089; Wed, 31 Dec 2025 02:46:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422926B008A; Wed, 31 Dec 2025 02:46:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3334A6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:46:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0282CBA81
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:46:45 +0000 (UTC)
X-FDA: 84278984370.10.8A3BA1F
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9F14180004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:46:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cloudlinux.com header.s=google header.b=GWRguMOk;
	dmarc=pass (policy=quarantine) header.from=cloudlinux.com;
	spf=pass (imf24.hostedemail.com: domain of pbutsykin@cloudlinux.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=pbutsykin@cloudlinux.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767167204; a=rsa-sha256;
	cv=none;
	b=Wod5Agf87I+ip+V0fGQFa/ilxk+6L2TfpgfCjXwiE+xxQbfjEsz7HLhHakubQYO5cYE1Lt
	MsudOwkNzxafBHwmAeeYC7Q/c6CnLC2V9hTRfExdOLxhYwz3QB2MSns8oslqx+n5qGGrzt
	+fpUYJZu7Fmj4UVa3SVMxAytOX0e21I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cloudlinux.com header.s=google header.b=GWRguMOk;
	dmarc=pass (policy=quarantine) header.from=cloudlinux.com;
	spf=pass (imf24.hostedemail.com: domain of pbutsykin@cloudlinux.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=pbutsykin@cloudlinux.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767167204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rcK5OWb8lQWwyYY1U8hmUdtzkD50MwR2w8DVGyTAGVA=;
	b=nxVZ2drRC/62Q/uBBcIlqL5cB/O1tFpItnA9r2tZgZG/9lj1f1zQXO0rafXH/5dPcRZQOK
	Aa0qjneJP5YFavBH1jh8S3BZGuYM77cJVuQjEz8pGhlyz7UPQtWh2fa6FRlRVA/hL6Nf2O
	iglCd95f3bd9YkfuxVgkSW+Aq/bP5fM=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42e2e3c0dccso6348273f8f.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google; t=1767167202; x=1767772002; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rcK5OWb8lQWwyYY1U8hmUdtzkD50MwR2w8DVGyTAGVA=;
        b=GWRguMOkyMdpXIbUh97PwJt+01Cv+VZqnDt09D4xesQRHHGphDkbPJbooe4moyayov
         V7qyUOpuz209P6ti6FQJ/D9TnIIRs2lzuUDH8OZ0eL/jozEMiVMpgSp6x1cMVs2bTMwu
         +k0i1TvaK/wHaJ5ZD7uN8keqa0HOPD1k3MQeo6ocwe2q+Fg2+sY+8X3Q65Y48rTMpFiR
         bQ4e3rfX6ulleirynh4q0DfaE2yQv0Awmd/kOUfX2FfcBaP0vTI1AU8UPIQCNfp9bqY9
         D4AhlGoubph2dGLMN+9IG8Rg0pBEeqvUNtelVae4K9L/U+mcqdUiu2iH0EVqSyi8GU2H
         5rsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767167202; x=1767772002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcK5OWb8lQWwyYY1U8hmUdtzkD50MwR2w8DVGyTAGVA=;
        b=vhQ7mFubZLLfMWTVikBh5YqAUbI/HrQ7Um5+l1gluDkUazg98GBlox+fDidEYEh6AZ
         +ra2BndncDm7Ke6TbjNGb/ffU/ncgx5wPwpOSCTSgMu6kpR6sbllDS6zmH6Qase5zB7S
         j8gRsaKj4AGieDdVaOUcPCBsfuIQIA/7TWKLG3fHVbh2f3Ob3X2en5P8Sedy7tkjF4Fa
         otpEuzZifoUBhUnzX3sSbNMlXzA8Pm7CC9hcf367RrBK8ieTQBSJVhrVU7LmG5CjkPqM
         JkqANaO616jS+qoNFF3FhRpnnNc0AO7nbGH8HciwZYGbNDmnKQbFAtXfijOzBwieW9L2
         /cTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzbubbc//uWIIixwcXkJmA50kTFBO/gWh7gFVBmYLa28G3PGjEBuud9B2j0BbaTpXOBrBd5LIlUA==@kvack.org
X-Gm-Message-State: AOJu0YzsCmZqu0b2cWnOoOjJY1UW9WwhP+II+jaz/8Brd9RDrLYt4TgG
	D2rQC0c8mNQeaMUCEachzNeZOJvbeQLke586ra0oF5b/HVm0nzF4Glu7DVWCoOaRiMg=
X-Gm-Gg: AY/fxX5GeLhnL1VMOWBtOiZWR6Cm/DWDo6UKpFMnW9f/fU0z24xxqzsOfW935XnggyT
	Ck+xlZcwi6yBsKGcQo/1x1KpqIuQ4/B+Bsrndkclzmh/RZrTebz/dFIjQK2H1P3BzzDyeo7u/c4
	xt3e5T//fjQaoFI/YAX4o+nfixwS00P8gsNUsm89cA+nRf0q6ZAPjr4M9qxA/iCssXY883iryFj
	EZSlPwxl8ReJ8XJ2YJ50kZ6BpSXN1npfn+5V+Nk61Uoz4LmQ7I/aOZIx+BolORnfigPBA1E/dAB
	LUSlOPZ1UvnX6UF7c2/uVfjKxYCSbKjP777qmW/mY0otMVjeksyFbJ3F0/A/GQYbQ3YN1rzIak/
	1Vj1wvSZ0HfghfSH3uIjSra7Mm7kOhNC22SpamwUziDC52oZFoTa6e3L0ggsOL+yJ6aeAuFQTd6
	G+/QXx3Fx/X+PyGVMkYfxKy1dhM8Paeno=
X-Google-Smtp-Source: AGHT+IHgPCTbrZ8SuyzVrzffH6KxGgE30rE6DKiN8ff7CAf5R8oHwTDdgYTozgvOKrd776lNlz+n6g==
X-Received: by 2002:a05:6000:2c06:b0:431:864:d48f with SMTP id ffacd0b85a97d-4324e4d5029mr46915304f8f.27.1767167202241;
        Tue, 30 Dec 2025 23:46:42 -0800 (PST)
Received: from fedora.cloudlinux.com ([94.204.137.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1b36fsm72315953f8f.5.2025.12.30.23.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 23:46:41 -0800 (PST)
From: Pavel Butsykin <pbutsykin@cloudlinux.com>
To: hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
Date: Wed, 31 Dec 2025 11:46:38 +0400
Message-ID: <20251231074638.2564302-1-pbutsykin@cloudlinux.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D9F14180004
X-Stat-Signature: 3oqzm51nabbzq7jz9e8xgkw3p87fr7fw
X-Rspam-User: 
X-HE-Tag: 1767167203-273154
X-HE-Meta: U2FsdGVkX19NRyKxTu0nkqObIVRoMFGpEstDAw7t7n5CC/Elg1MBWqCCAqwDlcX5OUESIsaXCM6F4ZfXWdFLOfmB8KcZ3/mJR4Uk8ln4oIgzBEKC82QjjiDypTdfnzPbMo2hdv6hhlndtJWy8pB0FfdBHGV37hDJIrDsg5nmC8JdWuzspHPr4+FGd/quNiiOgDoaxQU14ycFoBu9VI8uIXc5GC5l4p2wopiQmG1tnjODL7qL69hJNSW0H/rc0jJ650Vlpu4QGG3iD8t2Y+gPr1prkf7oQFdzSkkltSXz+LKHdV7I4eXikRv50j1SDwgajEMyvUe4OaA8xSzhQrvdYwROKbyyl0z++dilmpsvff1kuzRZW8ho7qQjp5G6DVCanjNfRcPtwWL9dL8KYfuAAJkZZINElm4Rbqik7hLXAY2uSsjXbgUO5uZC79dghGvyvt3E33sC7/TCZ3hZMQHY2ZCQNxIZ4BH1Js3Ltm4/SMwxzH5mvwK1nMEOZ/wf3cS/h1c7l8r0Zzp7P/iPP0myn3gjrXliC+5bj0itkriL5h3PWLnfe3VdmNqQKQrInQXeb77I7IkSLRvLgMcBp9ML2umdH++3Dvajgflu/gG9fQKJ130vFjPmudldTov8kIi7ICxz8quskxbbb1WHbv1avnA62CYcvvwKqArajZVw5iC1OFX+vOlzci1dU77UGtO79q4pYUAtz4TSw7D6IHHPGbZ1dkq8t5lYFqY1aAI6jKcYvVvyf83kiLqo+0rFno2Lnn/GAC52sQhwLEzD1gfHF0Z7e8Gcky+NeAP3icFws9PVLdAiSgUmdkR4g5cR8x+8BlZ/wTnf8O08Tigcl+jk71yjG/kJPRrz4IUyK8scnWMHPvV6bJVIqJPBIxwV2rmsb+wCSTud23PBo7kzxETzXk3pnxXNNOLnaTBMBCBjgFchZJsgF83sZ7csGo62LrAzSoSJNcdeKDkKLudNQEZ
 LJ9bNZ3s
 oJAIKOIb1hGqS6A0ki83qhKTYHYuOqRWjLlSfuCwU9qSsTTZvBAECvir6UmSJFJyV453bk5BEbuqOGcljv8YBO0ClEZevWJXH9DpNpnofAsAWB48RMKFKZft9O38SwildiTadaUFpjBIoxomKNkaxmyaBUr9T8xNy/Ms3N9q/M1BfIvd9mJNwiqv3e4YHsCHxBeimbS4/MSmiX3oXFIXlzkvsG067nYPGby9WSS3trYcrW3s0JsEmTokii6ORUC+DeQX29gtTsU12iI5iSYFt/sxlK7gCLUV4VvxlMX/SJc/rT9XOW6cxIZWtiGf1jBFymjCmFmwU130jf0+kYYca2uPSlS+w+eIsU2Sz9vVg9/rnOP12jbqDCcQcEmq/03v5AGhD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
only for NULL and can pass an error pointer to crypto_free_acomp().
Use IS_ERR_OR_NULL() to only free valid acomp instances.

Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside the lock")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..ac9b7a60736b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -787,7 +787,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return 0;
 
 fail:
-	if (acomp)
+	if (!IS_ERR_OR_NULL(acomp))
 		crypto_free_acomp(acomp);
 	kfree(buffer);
 	return ret;
-- 
2.52.0


