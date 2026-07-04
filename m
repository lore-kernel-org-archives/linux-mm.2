Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C755FC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 09:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 149FE6B00B8; Sat,  4 Jul 2026 05:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACF46B00B9; Sat,  4 Jul 2026 05:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD776B00BA; Sat,  4 Jul 2026 05:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C21DE6B00B8
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 05:20:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F1DE1C371B
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 09:20:32 +0000 (UTC)
X-FDA: 84950548704.25.1DD6334
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7BE7440003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 09:20:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="L80m/Bw+";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783156830;
	b=N8BugXZMDKBO3Vv64Ym1UC0oc76CzeMPkvYN4HyMWX2SDlXUL6cHFS1wEgwtttA99uLjq8
	SIXRS5lMwa1pc10ksWXtbI8wKHq7mgOoXJc9J+CXwEAnwDcyKxca68U8Ni2Q7BHXIaxsD4
	pumaAfYzK5TH23GYUh9LernQ6jmmWnE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="L80m/Bw+";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783156830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TN3GdU8ivh0PtNZUyEYEaDaiHRj+c7LhmLP7w8F81o=;
	b=MkAm4/YKl0iBE89cDO6WkyCIddzPf7Vaw8lj6a6cVkDbPozjXqL0UkH2e8BbkkdBR+Lxtp
	I0Xt1GILqJayfZcMZddQSj7KtO1h5pOoPiqkSmAGsmmpTa07LuDDPjWu9MyiJ9x8dLbTYj
	YOKKmML+cuQZh3a/9I3RdHazkvhVzzA=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aeba09900bso1093664e87.2
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 02:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783156829; x=1783761629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4TN3GdU8ivh0PtNZUyEYEaDaiHRj+c7LhmLP7w8F81o=;
        b=L80m/Bw+Km7L+muJ/sHEIHiLyHcWvXye19EHndPR/VlxDfYnup/zbPvP5Q4S1vdaN2
         U+E3iDkJD9Hys0SXvEy3alCe1lY4Xe82JlyXYzYyHxa1pS1xvH+ETt6/7QDfx+NPDQ8Z
         k71ETq8dbzzdnYuD+fuodQHTyxmzmRnj6YDByUrl7AnVqG0Z1H6+NBmVwhDzCzX7NMnO
         s8pWlMnBKf7JWFJZUf5T1arlz0Uhued5TZIJ54YAZjP4tKYl9VimOFyd9eiIQqfy7a4z
         yyPXb6rVl80mFdN0XIoKRzK/JtBJdmSDpw8JNmBlWUuiAx55gBShkzwQL+Be9tz/q4cS
         BFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783156829; x=1783761629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4TN3GdU8ivh0PtNZUyEYEaDaiHRj+c7LhmLP7w8F81o=;
        b=eS6wMATiqTeH1f21UjUmRf7kIoZkek7mi+YzzIDNitqphORDaLMp7EywF4lVOUt1cd
         ZkWusTjQHEmXHB8HB/l+mQcDme7mvlrhWmkB7I1xuf2o4YR7UGoyNvN3ouMYMxNI0sxy
         H/x3Vxlzh1Mrx3RBqHhJcsyZbWC2L4NOy+zV1xQQJGQXQ/WW3EROjAUGumZBhb/kRSYJ
         Nthok0/IUefdPGM7+uMxYh0pvQm3LbkZJveOfw1FtGcINYGrQjFMGdw+9fREfsp7LLKm
         vJ3PUPBB+r/Fx+tltFN1dLEDl0jqYZCaLPi+DeIcyWV7dbgEbocOiApa5AXd7qvV1Exv
         tDNQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr4hHD1/rw6a7DBht/YOz2ypCPAd9qnjrVbFp37mz8VGZl5qeiptobYd0mdrWiOq1tj4y9SK8q1Sw==@kvack.org
X-Gm-Message-State: AOJu0YzhItWkExvEvx9vWuyGZlgbFIzxKCurWzCjtyGL7dLBtXIF0aYx
	wjz9jx+ieEFMkaOl9u5tNPbOEJ0UexUvhpI2rJKTdCgBCqr1Dzyrj12R
X-Gm-Gg: AfdE7ckxn6sprJE5xfsNRPIli9BWfAmghaB+iRWqakyNGfDwoPrfwO+k3fohRNvagH0
	UzSSovYv9VBnwRDrmQi8KXDmC2pUg/oKanIN9xNT96ie2Kmslbxr0zV+pTlI9l98UW42hBxNz70
	oXoxMFfzHk1AmKzgFz7Qd5HlSAV6qifY+yLULUUJUt7xhSD9Kbb6Zk0kUZSZQutLmStjTEsX2yr
	ODT7AgnM4JnlLdcFZOmP529GkxnP4GI1Xno5HSrHuSKoV4+3BK0EidRNXD8ERTlwnsPsG8zORhU
	2MIaMryXFbv01z0/g9e84zCRGyatyL0U25lScHSDiBVE3sKfs1Pn076nCvQCRETY+HdZvtutzgv
	tP2O95BXwabnICF4zIsX+JMAST4NafLw9dMNxiWUwI756WkaPQGE/9s4hpsu/4/vXMc6SsNmocJ
	qG7zvdaxpgwIuVhG+VwMyZACZ1W3VHV+eyjqOJz169c2cXzrHIMpYXpML/fvyb6rR2Pah7W5sLj
	QAgZ7s=
X-Received: by 2002:a05:6512:33c8:b0:5ae:ba28:a56e with SMTP id 2adb3069b0e04-5aed50a6ad6mr442879e87.35.1783156828774;
        Sat, 04 Jul 2026 02:20:28 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aed13770fbsm1149063e87.30.2026.07.04.02.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 02:20:27 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 3/3] kasan: common: replace magic number with KASAN_TAG_KERNEL
Date: Sat,  4 Jul 2026 12:20:07 +0300
Message-ID: <20260704092007.3483-4-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704092007.3483-1-igorpetindev@gmail.com>
References: <20260704092007.3483-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7BE7440003
X-Rspam-User: 
X-Stat-Signature: 6xu6najt4amoqshf5d6n5uncwoexksey
X-Rspamd-Server: rspam03
X-HE-Tag: 1783156830-692743
X-HE-Meta: U2FsdGVkX1+HG81L/y8fO9912Fg8S0ytXEtGiyXpWCFC/uczNxDqUpYuW2EZEWE2sbPU9s3mr50rYDTYv0f0nds2pWBj+VT1cSoN/eFvIF0tcIcvFssT7WAfexy2I38IhEwxnnCf/1cEPtyoOEKqYi2o98Ku8m3o5rSGmJ4uIaFvRKdmET4r3+US9/SGmBesLsjKuEBSEOamDVB96uCCnQxf5zaP194mho6WUsfaKrkm4w5I5k6lTdvWNBLZ8IuHav0Ji+wQBaE5p8Dt7tENjJvNcWj15A8TV9wCUzc1/sW2hEXjWEezMeO8SXRSVuFhwYluJWKYkt8wLKIuDkS8hkhEJDblCizYUmb3npc7m39GzHCqQmXTecAyLcsCzFAQS3KPJMUt8ZB5/FqxezpURG6CDnFoNtQWGGwxAmNLJ9AEqpGfgS5MGj6WuOYveTmmtP9i8h4HK2EuLr/qro1zRN6ZVPcz468P8hHvNljJYdVMsbVC2XuNPo/jNndhMB4tiQZE8V19uj/cfaaKqAZ2a25+3nMwbRz77JJ95HnKPcsW7oC98BVzmWQnGtNeIyuB6c7Nr1mlOXB2aNiRJxXDGzh0IkqTz0TMuI+xNjCSfcft/HhQSYFdaUygqBU3vFWFNHwi+ri6uQGUl14vfVutTgFjYom2D8QNZWRAyh5++CbmZZSmDHj7gYbF5Mq0c43VgF+geKMg2h6ti/0Ad6Y4AtPlTiI41J3zCA+zeqa2yi9F7pyhxagADWPnOhbhmLSQ+bZsdNHJMbpJJJsq7dpVUfMbCludHrP7btDYcin0/tLpyD7r5YihElVRHjnW5W4eeFoJ1EnDcuxR+o+DfYR7Fa7kJqYnEUS7kkmcu62pFLt98gHmhyywUEZWEASA+Hmga6gyDclvbi9BVmvZx0bW5yvC1Lv68+ji1UtzJOLj+wSDYSfgXHS9LsoKjx5AqE0CppekLk6Rv9drkiIfeQz
 E742z3Av
 gt2Zy9M+HrB7B1gF2Hq2V53NYgkLyAxVzoPIySi7GqlTxT6KfXoJVRFHHdAURYqsO01X031OJlQExGn3XPRQFv3L5UCSHqu7a1KQZJMrePVSIe0AgEwi+/70aRndVSjmYBsl7+pYwSeHdUE43eJhWq1IWNEW69ccCtnBjfdVDgFouoDgw/gqPGKpCXIVszhB654JQNVxdfT0iVIWu3S4lDOd1UznvOk23qLHLdDPemGudC8ixJZR523hT9+Qqu0+ltqsQ0PhLNgR+fNlD3TElQCxco6DsRqC2joEl4VflBaEUblxFdVmn/QMEuHVgR+YaZFPAOSkjKWA5RlYFYauR/WxgBW+SHeRK2pX4SKNbx5k/pEFsvLvjJ7w398AlMWECQTFiwOr//t6uNkfWmmB+fd7Dfr3r/FPHoxaWhE/pM+N+0WrJeBztwLC1MED0yu1xPkyOfL9n3E6CcpA9+pS7ebVXDmFgnE5e2pDzSrzsvbC5ojRMnmNkzrHjWyibjkx0Kz9AyHuPLNuNSAMMGteB0nLZcZbZvtWx4hEDVf2Y0nY7mSIBRsxZr+BsAPsWixh7MiUYTxiSTON3uK2suU1fs3+xXq8muYvwxVwXdkPTL9uygnGXtkrSeHeL2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the literal 0xff in assign_tag()
with KASAN_TAG_KERNEL to eliminate the
magic number and improve code clarity.

Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 mm/kasan/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 5faf73c8f..3e9b6b8f5 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -188,7 +188,7 @@ static inline u8 assign_tag(struct kmem_cache *cache,
 					const void *object, bool init)
 {
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
-		return 0xff;
+		return KASAN_TAG_KERNEL;
 
 	/*
 	 * If the cache neither has a constructor nor has SLAB_TYPESAFE_BY_RCU
-- 
2.47.3


