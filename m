Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEDADCD37B2
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 18:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3C0E6B0088; Sun, 10 May 2026 14:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AECEE6B008A; Sun, 10 May 2026 14:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB756B008C; Sun, 10 May 2026 14:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8980B6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 14:37:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A965140408
	for <linux-mm@kvack.org>; Sun, 10 May 2026 18:37:10 +0000 (UTC)
X-FDA: 84752367420.07.591C649
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 57A91100011
	for <linux-mm@kvack.org>; Sun, 10 May 2026 18:37:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cPXvKti2;
	spf=pass (imf14.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778438228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xnzymcOPEl+yMW64Cbp/7wdlyZ5NynKvSomh5XJYSbU=;
	b=6WxMK7Q50GX0gJ7ULC4eOslnG90fLC8MnTgyg8t7aTCE+ZpjZLH3VZwD5zlVgLRcPmxUam
	mKnnShGKiEWQnnD0wJUjnG1ry/WHKSSY8Tt1nl49Y8gm9S/7uE9TkRB1W/BQO1GwDMSxwv
	LAhiNjfM6q+pivQl1OCjnFQrDbghUME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778438228; a=rsa-sha256;
	cv=none;
	b=w/AfX3Gx+98bDoGHxV2kmHlgvX1TdNypfLH6tptWPmib01KF7ZnHZde9HhPUoE9jqOnyGq
	p1yRyU6PJamnyAh0Vpgg7hvnJLwdNmbGviNG7miy/jPBDqgFo0kcT1/rQkHQzZeMpkp/od
	XfeQtfIV3eAQr1b1uayBtrSell+kCdE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cPXvKti2;
	spf=pass (imf14.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso24163465e9.0
        for <linux-mm@kvack.org>; Sun, 10 May 2026 11:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778438227; x=1779043027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xnzymcOPEl+yMW64Cbp/7wdlyZ5NynKvSomh5XJYSbU=;
        b=cPXvKti2DX4tXszVMvo2Y9Hy/hEOxMwlG80nZ71NZH1/YXdeG8BUOxN9Ei/eQmpF6C
         //A9kcu/Lcpcw45ssLTfDknCvSCrxkoMgkhW/RE4NX0pM1pn01Rb8OMRKvZlEBvCY+Y2
         iYzlBADqdWpBhdKfryPLnVoS0INzDmx1o45Kbxr3UGPqszssWHUhcvd5IUx51EfFBkcm
         1GpQ5sDenfUaVy990csxUssEtKX0KgkhKdkQ/awe/yMSK3BFyB64T5PDeXhYz+mCSumJ
         0pUPh/xjEetdYEEhW9VTUcC6z4pd7vHKj/PDIo8zFurEAnxG30IH4ZujWrCu3r4iLX5k
         zp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778438227; x=1779043027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnzymcOPEl+yMW64Cbp/7wdlyZ5NynKvSomh5XJYSbU=;
        b=Yp0+XoOY5E1tEsfMYVSziSJ+3muZoaBwhb4Fx6i9e68KAEy88AwavPyNt37DzwNCkA
         9bvlEpS8Iw3uiFbQlGilgJKz/84bCzdyzEMrIPZV4xSb9Ago9fkUrypXoEdmChDLCKgn
         hcxLByNa3U0adFVfdAvE6OlRcV6lsIXj0gPIuB4bgDmtxY6mcS7jCppEruvEaN50apXR
         DrodbuuA5cg7c/9sT/2ydR7z4cxmq++/AlE9xnM3ef6DvTVwnMtQdG4MSGlxCUivJJHN
         J5PuAlUZRCSaFiMTRKWpARFD9P4H4ddKrere6THM2hBgckAu4ms4B1HOMuyZngGHL30z
         xw1g==
X-Forwarded-Encrypted: i=1; AFNElJ/Qr0Bz9riLxRRIvtt9zU7wk2AQAhJ6dgPKttX6On5H/cfrv+N0oyMD3tjDLFAzMOVY8WSyTww4HA==@kvack.org
X-Gm-Message-State: AOJu0YyFYW6M6p+ur0FJITumfMVJsJaIPwfr56QtAFsa7P3Z3QRfSNXQ
	qcV01/ir4+i6mB0UpfTg9+d3FspaLLXKiKrAvrHyqvIKe/HsKO7lbz9G
X-Gm-Gg: Acq92OG6LSCE1KBLAqdgzNMLPJTbchYoCK2dghj/+G13JFKRoY/k1ELv1LxGYIg06UP
	VHX6ofTN1rMWaCPpJ4sZbUEELuSTsL6Skx7RoAcVZP+qvHsbF+SbiIFlriZDFUV1G8zKQqRmTn+
	31VB2VJW1bFeariq7SSnnqoALaxmyhiBMhfvHOuDtMRuACQ9L2ju5hZkUUfyreuM0t4Mkq4T7d3
	pWvxy1CdKIJcguoC3kHjkTUBlRtaiqn6IEknRSprDXTSrYrARebjz5cgGMSRZdXAoMdP4eItKm7
	BVv4UT6XuFsV++0ENUNG/flcZzAH3RutzZqsyIhS/Mb1QwXdHBnzX+7VcMKsmsFMpB/mv5/pNkR
	bE9FJstLIh7RtKrkm55wFBEwXuU9awMYEtXSL3tZao0Qcf38LzvPrMx/zfTL5Lv3uYlbEcX2dpk
	zHe1ZLxC302tlGqZt7yiAPCWVtT0D4JU2zXUwuoa57D/ymPdqAmQkPf9f+qnZICU7Ef7lqYq2Ba
	buxETe+Z5s=
X-Received: by 2002:a05:600c:8b62:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-48e6748afe8mr168307845e9.5.1778438226440;
        Sun, 10 May 2026 11:37:06 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e701e957asm132611975e9.6.2026.05.10.11.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 11:37:05 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: David Carlier <devnexen@gmail.com>
Subject: [PATCH] mm/shrinker: avoid out-of-bounds read in set_shrinker_bit()
Date: Sun, 10 May 2026 19:37:00 +0100
Message-ID: <20260510183700.102475-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 57A91100011
X-Rspam-User: 
X-Stat-Signature: g7dois9tgkrz5fhp8qfncnwubk36mojp
X-HE-Tag: 1778438228-982397
X-HE-Meta: U2FsdGVkX1+P6TaYKC5Fn/fVP3ohLxZDJDXDuu0COVpHjByGfA6JpHUNQktkRXDt8L5fJHEzKSUpSF2E315ERk6Z+pH4gkoyF3vuWdso8KZ601Ce5sp0kh0nLPho9G5/vvJ+LhPEdpU0ilR9UOB8E4lVS/ZPtkbdQqLfFYSToEUxrO5T57m0oHlGjYow36aIcP3bQWz2zvtIk6YqJQQE5qbi/z0Too1jycepFB9LbUzvhbeEqP51CcxzLu+b63eARfBYarCqKfoQo+2OJ8OYy28/eHtVZTXCx3ZDxwPTjIcqgvRzBtlUfVwomc5uZwhHfM4w7uiUX3CPFDtc0ZgdUJNN/k1eQZ7Mpwnjiat8E1FwtZukRdaq/9LIxZFNzzHLpp1Rooeirj8lid7F/YenKg2KJPQXz7CGN/o0vcl7fW5rdoeuwdplBEsvm8SmS4gHxcpGdZfsQjaMXxQq027bV9uW/QIHpAiPmtQ+jqxu4OGa7Vx1RVfJ0VZxSEmZ2CXRS24K+3qbYT/pYHzP68sZr1HSxvSOEAGzibBcFIvsDVx0iwZ1E/8ZOTsu4LsKQ7bLRMUjcvD0eKyKdoMCtR9Ip1pVTI5qjl/6N/kuqEP0ifwcw8492hffutlj6CajDXaU8ch02UhwtgpXU0n0ig38byZv7GITT+fqCYl9RQU1VIUN9Ttb9o8VoYiL/R8um+z8VyhGuSLEegagqXIB/wuxOAd2a/okGDgI1eX1M8TIdVfNUyDiBoQGjOMhmSp7wLxPFMLvTr1G3erAFyBZGXfl4kEnB1iUTos3Z2Rhe7CD357uhEa8JkdVu3wp8r3rmXCI4eUJfuLskLG33Bva6ByzvJ8Q03zDJssSRIJqJqAvHke+adoAKGp+y/jg+TwB7tKKEqANjxD03n1eIvBe6OsUWvxCUltELItT21/2kBTmPhaickulmsYxVLbbbYczjdw6eV7Al4ApiUrEKbJHHkt
 wTZejQXr
 IO1ylZAY76kx2zhUtFDuSpO+Cq2pHD+nc8u326AbAQDo5B7fSUM4t8a5ogcnWQqWPogBqX+Mot+c5j2W4cFqhOxSfExhPOM5NUAUB9NPxso2MpC0p90UnIjmt449cyiXcDl7S1gKrvIq65Khdgs04dLEGm3YXw9BI/iws2qfiMBumy/huRiq9ua0J6uKzy8KJqse+jmhpXPwSRx+EznIUREgk+ooquOEVBigagLm0ClcpAyko6nzijlnBRo2EE4/NphTbI95gmUKJ6dpcMO3+e6wzZwbtwsSuApIj5QRWq1D80n5bFwk2lkZGJrIIlF47snndp5SrX6N9t6GMInBf2+qxjfm//XRpr/8oQ/iHOjwupNezL4pdjf8h70jmNChdXZwac8OmrjP1pzxxPlrj3zoHloE7PqWw4Rab0oeQTpeSOE0e7/Zj80Fp3ARCQ2wJ2tTkT4mEiPz52BE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

set_shrinker_bit() reads info->unit[shrinker_id_to_index(shrinker_id)]
before checking shrinker_id against info->map_nr_max, so an id past the
currently visible map_nr_max reads past the unit[] array before the
WARN_ON_ONCE() catches it.

Move the load into the bounded branch.

Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/shrinker.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 76b3f750cf65..49256f81199f 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -197,12 +197,13 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 {
 	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
 		struct shrinker_info *info;
-		struct shrinker_info_unit *unit;
 
 		rcu_read_lock();
 		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-		unit = info->unit[shrinker_id_to_index(shrinker_id)];
 		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
+			struct shrinker_info_unit *unit;
+
+			unit = info->unit[shrinker_id_to_index(shrinker_id)];
 			/* Pairs with smp mb in shrink_slab() */
 			smp_mb__before_atomic();
 			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
-- 
2.53.0


