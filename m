Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942BED116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5BC6B0026; Fri, 28 Nov 2025 02:02:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E960D6B0027; Fri, 28 Nov 2025 02:02:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D851B6B0029; Fri, 28 Nov 2025 02:02:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C29026B0026
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:02:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DE70160447
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:02:41 +0000 (UTC)
X-FDA: 84159122922.17.B263450
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F45D40004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:02:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KuJRfDZI;
	spf=pass (imf04.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764313359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbEr4NFSSDU2oD1Km1Gnmw0U8TstbeWoaIABiLKZRgU=;
	b=lQly1yL6bm/d2Q+jZjTtGJULCzhcCCX1FOGicknL1rUiN/y0VY4PsGGtRZgi7gjc5I3Ijx
	So8hiKMdHvLV7e+ViYwC6YzgYtbxDIIf5rNeDRkCGeoXGx1C8iN/aevE5w1rfzA8PVcPYE
	GgLE1X7Or03ZFODwhLwrF4JJtH5Cv0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764313359; a=rsa-sha256;
	cv=none;
	b=J5fNiCD0XB/VoKsD+7p4E5unCOdp/pyQRt7MK5jx13Wm/nzafAf/hIlXacFbPpQ0Qdv37I
	uH+qlDykbXCjaIQSXtPuO3eI1FZM80MLvEl0m0SDHI+ECLXtdumSvdyxFtOMC85esjRPPS
	F8VuUQyewSztBQa0N4Xp8MeDg2enlmk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KuJRfDZI;
	spf=pass (imf04.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso1755324b3a.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764313358; x=1764918158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbEr4NFSSDU2oD1Km1Gnmw0U8TstbeWoaIABiLKZRgU=;
        b=KuJRfDZI9P5CuowDAXTLMUQ7tZZdVqkS37ORzxRH13jCUmVRn5Okai/afie5Fq9u/A
         8wyuCf13iQ1WpvuOnha4kSaD4B+swUu98LhK6lKhBJr8cOPf7s03uxXoyKUuHTAh3F72
         pP6yfLKsmf3YkvAvV7wpuSgETkTwy0m8/UDHQ1AmZaKS34ZTPFaTzWeTizFAHIIKWW5f
         csEcRKYU5vE7wbuv4UOfGOwnrVzau8zceuMmhTwtoHReQHXV0a2eBhp01pL810R9EBDI
         6RQH6JKo8szb5uMdfTgwiW9FgNMx+sI0uym1WYevyy0d9fK5hGeepe3rAdGHLeElEZOS
         AgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764313358; x=1764918158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VbEr4NFSSDU2oD1Km1Gnmw0U8TstbeWoaIABiLKZRgU=;
        b=FejEo6F/GVPHqryPYkQRoEtS95lAyLuPRw53qaURNK34dMkmPpyUe6TtA9Hit+xKRe
         K749KBMtRBV20KAeD1gK+RJi3hR+BvsGigff6B52Dfle4HH8KQXuRs6M0vLB4p2e0LGP
         9MZOFAliUwikaiNSh7FWcUIe+rKSvQT2K32PRzxezFh9zJ9xBwVW6uOVjIN6/nbJGwJQ
         /6IP+yoFv2tzBt/lX1yQugfsatYBfC5fq5qyurObD5BTzxMmBcfEZOYdY2Rr0+cNIzyo
         BY/6mYdqC97EkcsbnyJXK+AJ7iigCZi6ljKQOL+Tu1yIOxaJngU8qG78Top/P5nuXYUf
         KNsw==
X-Forwarded-Encrypted: i=1; AJvYcCW0IDfr0iF5Rx7q5BTDVONeTyw2xHXNxffXIcYxyb++23SkJnX/euMm1idV8SlSxFQsM1ct2I7QFQ==@kvack.org
X-Gm-Message-State: AOJu0Yzbj5UpUtX0oWA35iXaHflgOx30Qk40cXGL5Io2CAP8wt3TI7J0
	Ytbf4yixY2Mj0Y8Ehhp8/bpc7JXqpbJj/IHwn0+NAGjyydx20RyQ7nzi
X-Gm-Gg: ASbGncsia/JXGPie7XdkQ959UJjPHXthPZY1kB4JXmiHVjJFOKciuAcsz8qldY+ne9G
	I/MW9zaZkmBXv9Ye8MEexrGVtGJiSg6ZnMyJDqaaG9nndB7FxRMICPvytDJCL3svI0BxlxWFPVo
	JGhiPygSm+VJ3T+CN90BvyZGf1g4xj5m7lhodz+AzhO7CBCAoFym44+zgAtMSkbTNJK0uYBCaeO
	pjvKdKVArzNvUy53jipGQC8AUhthHqdZqpVsOBpehYysUPTjKenjCpaCbRqU5w2BbXEmgjftxPx
	gRQrqfC9THdG4LXBN7bHhS6IV+9mdYCd9NRDrXBfdOyBcHVNowZXLO2Xksv8A4eSgH5qmhG3u/x
	inYGVe/462hS4Q7hfEl8Z7E92fNtpfMgBI5jXq+uLMqErvGQTVrae5CwGOvztEh22VTpdgYp4kC
	OzRzDGvm1DSwiCaigt0u8ZmpxLvw==
X-Google-Smtp-Source: AGHT+IG+jfPwGFuSGbc9384hQI66aYvYFTJMQRPbCEt7+8Y+u9MqQRIRwN5jEtL8xJ0nDPWRmCqMzA==
X-Received: by 2002:a05:6a00:3e29:b0:783:c2c4:9aa5 with SMTP id d2e1a72fcca58-7c58effc088mr27998083b3a.32.1764313357839;
        Thu, 27 Nov 2025 23:02:37 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.43])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6970sm3864693b3a.17.2025.11.27.23.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 23:02:37 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 3/3] mm/zswap: use %pe to print error pointers
Date: Fri, 28 Nov 2025 12:31:44 +0530
Message-ID: <6d729a60eb71baade3670e5bb609a068683af3eb.1764312627.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1764312627.git.chandna.sahil@gmail.com>
References: <cover.1764312627.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F45D40004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: tcfntatdd1uooqqp774m5pssw6puuiex
X-HE-Tag: 1764313358-480408
X-HE-Meta: U2FsdGVkX1/Eyb7sjyZChTbB7T3+NKqAijJRu3QkqAcs3UhSElruZD+OXoa23ZeBo9OxQkxScbyCk5JcrWEWa+gtstj+RbTd6eSD7U4V0KfUO5IweUQfsVpL3/32pgeGNulpPuB+QzoeKJRLqVKORoVnETwApKnoGCHoJte0dcufWblgAqv7bQXYMQ0FCy+UzFvJMA3I0CwGRsiRsjbyP4c4jFbRo37RAAg56IzjlD6Ok1aNqJQw2GHocdlZMYTcng4FYdpzbnqtxAP5CgNTAbHW2RfIosNwNPGpNuDweIdnTtiQXDk5bnevCqyEK8s1szUn3OPmHl0h/NQPY3naczXg3WYwpyNW+mxK9YFvZanmUVifxYVy2WSNmSrzIF+flkR8ZFaeap5u5VRvrrUExo6hv7OA736bLxQ8CDnknBqzWbGuz9TeCKfHyeDMSQ56UScnmhXbH2S67/OrBVhvG3XNyxWsLJL9RKLfYKYj9H7IDFIL0k/UBJ/iD0JLDjAdZpBRVteYeppRk9hQakSSSfO4AL+3zxCHDrMUF3tfBOuRb6QG1otvLWylGiYX+rp8RX6odkd3XhBhjUP1PClI2xD2Iw6M5c2RkCC+7nbNt4us8vU6nShr2S9jZYa0Nw5NZoqSJML79AK2e0N08RVbDC0UxI5686x+kk6PzFR/Y2I56DzPwrNtJvTby1KYd27DeXFyJxrCYLfSV3Q61x2Sgrn0xTRFK4SycCt3ddES6UBG5AHYm2js0Erd6K/lNOEkTKC7Ye/s8nmwrLrgHC+JKNtMEjcivrfUThpdVz7xYdi8MhtNVBpkpdDx7/paypTrNFao5UrPjmKzvPYa0uqgRKpkKFRdXHN+wufg7OMfR4j9qXVKEOH69wI1P1q4fxR090Sk79vZbdC6QoEkCo48wujcTi4iNza38zeDrJxlDRsvLQG2CkRcsIgxhQyDEiZAmp2nKlegftglnYVABoS
 HaaIsK4R
 QNIjJ37FCB1At1Hs+X37oM+55g2HAgkOz/YEeS8qDl1rh8RTYS6p7wR+QQfE302lS3baF47jM/g31fTnjt2RPIMlKmRkQyV3x70pEgnMn5m3/fWiEgDKA/AnC9KXvyVnGYtGAs/fbFOI3SquOnpxHgBTg8+Ye93YSS6LcOzeS7UtXBMKYyzvsi2IyblhrzYo7SadHvj7/0dYg/cgXFf3fKxhsQL7s3AkR/I6i4/Rphv8jO7clmQFSLgsMpCFPC1xbxIDxjlDBfqnPO3j21armDJUJOk22DbYB3RDyM1mSc3B1jmdselK4o3/escCJ5PDeK6+Pl69tqJv8Jat2x46lxJmddI2+lfo7R25LhO9l7VPGmqMP7GwbXcdQ50LXPWQeMniX+mM7blGHqfYccpLGsgyOGaX5KBZb7jsZ7FWrulXlK2EgONSlvOznGiufg248KH/jMa8kfoAgnUIXgMwvDcsFazi9j1BchTpVbSpv1zMbTvLHq2HyFR4L2Hs6tqC+sQH2U2bgebGcp1/nC7bYd+sOwS+H+TnUXjFb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
Changes since v2:
- Add Acked-by tag.
link to v2: https://lore.kernel.org/all/0c00ceedce6e0d9aed35cee5faf15fd9126a1f70.1763796152.git.chandna.sahil@gmail.com/
link to v3: https://lore.kernel.org/all/57b7205813aa87c8f5c8bf765e5a8d88daeba68f.1764177933.git.chandna.sahil@gmail.com/
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..c35604db32ad 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
-- 
2.50.1


