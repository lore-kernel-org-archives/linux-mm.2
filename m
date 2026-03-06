Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604B0F01804
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 07:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F326B008C; Fri,  6 Mar 2026 02:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B299C6B0092; Fri,  6 Mar 2026 02:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BF06B0093; Fri,  6 Mar 2026 02:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92CB16B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:59:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5610E14043A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:59:41 +0000 (UTC)
X-FDA: 84514888962.16.131016A
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7F3E014000A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:59:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=XnoWgUuV;
	spf=pass (imf26.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772783979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPUcTtKDdmEGo0dCBXR6iAhs14HBU2LRhPqQ4/x+vks=;
	b=4+pYUPfankTrhFzWkkLU420MdCylyrmyRPuA4a1gVZy5aNgnR5wHvCCgMgdSu8BTO0+nel
	yL+BN9o9LOy9NPO2HsXviQG2WbZonhyKw5kC0fFrephw732nuyv9i8UOt1s6GnDdWSyNKa
	MwZ3Pbbgh97Acd+N3dLGv0Q88iS7kJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772783979; a=rsa-sha256;
	cv=none;
	b=gL3vvzGQwYy/+fPBvkfcuBV1hvpbqZeHaQafNoYqi5AfjV2LBO7HXsQhftSvf+8sNNz8uD
	vSkkLBxdwAmbohydk8w4eeoFNX7uceyZw+KzM0+f8wCClTRz/w7ZqNnLhlLI/z9D3KNjjJ
	4YQ8sZtOL8i1HolIFaaOoWSPzsJagF4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=XnoWgUuV;
	spf=pass (imf26.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3597b474cbdso3290781a91.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 23:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1772783978; x=1773388778; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPUcTtKDdmEGo0dCBXR6iAhs14HBU2LRhPqQ4/x+vks=;
        b=XnoWgUuVeBsA1cBO1Cs4nMPcwmKMMUKYw2Q0L3dW4YNoeF7Yz3TzHIt3fxn8GNmUOH
         lsT3rUaYxwgMaNMHhSUvxLlxpBLNElElb0DWj+ANiv5s67KqEyn/SkM3BTAIKB/rebi3
         oGDkh67mb0tPX/CWkgkowcMf82bySi0iOvzBYN/kdemWlPgjtxgCwEPFu78oQpejWkXs
         /tPYfHFJ/XILy8oM8PPz8qVlbNVqvZMzC+6fzqdezi2S1VMFaGoQUBuFLzytbzFUDE78
         fcUI6DgVUbKrFDKpiR+DhxwuXuLyN760fkKJs6jCRJHj6xkTmY5NPHvsXApw6LoF3iWX
         /c+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772783978; x=1773388778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VPUcTtKDdmEGo0dCBXR6iAhs14HBU2LRhPqQ4/x+vks=;
        b=T1R+ZlQ0OVXggJjwV8VETxqaUp+Dp5aM/YKPASwtNe0C4yKbFBv23au7sXTAeS+rxu
         uen6bHtSVWRvwNU0sJERB+q0UtrG7pcYLqowT1I2knI/EdhkxgmMm9BE+I/wO+p/iwAz
         kvJgNHKE7AUg7BJ+sqcvjaoDz1vewpwEAYyHjxsPX0WfJMNcj2bWfb7rcLkHYykXLsO2
         D+DtonRmIh5tJBUUUv/Mqwj+acf46g8xvIzcIHnJp4ouOx6ZiLkh9CMAAaWUK9ts0P6Q
         H2uovF0AoMGxOhwQXBUd1+BPhk7LcCtayfoO83tgRzgJhax7osWa4VTUwwK5VAJwSnBm
         zqOg==
X-Forwarded-Encrypted: i=1; AJvYcCXRXM0zZ8a9ysDRFR1gfgi+mtrivXro81TQ9hQ/F3axzsBgUwNQ+w2NAn85GClKgybFMmSefkI94g==@kvack.org
X-Gm-Message-State: AOJu0Yzv4quKHwBpT7tfbUg9PCe1TzqwBdU3ga6gpuByB7h3ds7PzHyK
	sQCWoNpdmT2txv+A7VhoEX3DHJptEgWEM3caz9Lv+HVuIYtDUEclLJtxq88YRG5V1f8=
X-Gm-Gg: ATEYQzzt4Mb7poHneRrL++TW387/Ge2YBqtFbWs6eODryre2nsb9ngLjDfYO4cyrNdv
	LpM9jFy4Yr1QNcFO9DjFCjqiKGP14uFLkDa+DlxYzXeVw/NG7uVrt91q4Muvrbkn9KLomJYhz0p
	Za0CBihGCSaNTuX6JfZpSnYDP1OhRvfwStQkCxn0Yzg3ng7DEz5C55QlX/9NQMO7drwYXdJ0B8e
	VWC/mSvwe3vBhqhcm76yrR7DVZkj5LQLuxahHsLJIarFikTRm+hd+UqQKsySH8CvMSV2WznEcUb
	wYebv3FpDipWSn1wDb25GmCxZXYpJxu5mq47o2btSKrj/ZQIC/0XsBwaOLzzkkK8VqNP6kZ5BoB
	3qetaRGs0X3o3kRsqBMiDogXkZ8xk+VeK7yNZYbFIljIkpfFUFl3zLGLCMFJdROiiK5W2so8084
	MA41351QqrAXt/Vj/h4jM4Lmf9N5vfAZW0mAyPXw==
X-Received: by 2002:a17:90b:3c90:b0:32e:1b1c:f8b8 with SMTP id 98e67ed59e1d1-359be375c6dmr1246016a91.26.1772783978384;
        Thu, 05 Mar 2026 23:59:38 -0800 (PST)
Received: from localhost.localdomain ([147.136.157.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bbaa0d83sm804787a91.0.2026.03.05.23.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 23:59:38 -0800 (PST)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH 3/3] mm: shrinker: remove unnecessary check in shrink_slab_memcg()
Date: Fri,  6 Mar 2026 15:57:56 +0800
Message-ID: <20260306075757.198887-4-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306075757.198887-1-haifeng.xu@shopee.com>
References: <20260306075757.198887-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ygmcsmb6u8qfkjb7a4h7a6zd78fhuxyg
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F3E014000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1772783979-614030
X-HE-Meta: U2FsdGVkX18uoMeZN+GhM/NGgl3YOxscJcG7LXfYOiYzphK6LdQFN5stMTLjnZ5tBI+h87ZUpdi0gDKCBRYg/fjhmedcjf8fK6ByxZZc89VBcikdfLFS6u9gMIZjDFrJ6byWq/cpGJqFzvoMofHtVA91RnSFaWSmaeHpRUmmDLboIe72z9LM9l3z6srEHSe5i6P9I8CWMzMSg0GTrwEV0fuH9ifsFxd/2FVi1puBm6uw/xEYzLCfj+6kssP4zzc15O8TokeMHqe3OHacd6vaF8hIn9geCP20Yo6OlqjJxILIPp6ZpuIDI5LpVZf+eW2Ijm/BEybURUSnYpMsgZkHshhkENItqx8Un1XwTC1ltQi2c4LNiwTijrxZ1B/NTAJPlxyqYutMi7dhAI7AF613ccHL2hWWEPTIGMZHsbUmsliwpff9nNCdKA/JtIhi1Ujb28ESzzhZGS2mMYff1q9cRf3hcL/JW6RPS9IK9hG4aM6egrkIZ4NTAio2wP4JJ7Kfuy7ndv3o5JwumfAvUeWYxCz92Q+H/IX5QUoqpqf7juOymw7gNZDLtRXSSvUssVKBNIa7LLySK0+pQy09MqCcXhf5U7mb+89O026KgNXBlhqKSQZpY8Do2fzK8g7rgq48v6vgzXUbJGPr8qOw7Rc2f+8a0pshWzzvcygaFCJed6loBUm0snn4ah8XqZFyNrt14IZJdI34QjYubxiVo2QTkG6b3zxHLghebDiEmZGDWp1tHZp4t09r6y14RFkHcAeUe/7rLsAkTBYPszdPEJyb7ipnZ7620MloARtiE9iPqv3eUzgagjU0S6wY1Jdc0mCdR/f2XoDl+PODHHuin0KfFn4sE0bG16J0yyhInIy1pmxMs4XqWL+I0uPGTHSblalSqJK43kgdjRvvzWttBmPsBIMT3ati9CbwKjU4KLhAbupVBPP4p3jmKUlpDqEzUP1UXGRQMBfpD5GNYSBEIvT
 nHBi7Zgf
 HYp+AS0djoRiFK7+vq/iCpfU0VhESSkMItxEV3oloE2Vq+2BmEJeIpytftrbZ7cfaHsQ1pkAIeSZB5QoXt/WyN+mQ8FFbj+dUdaMdbnYMpy9ZxzdK+0qSvhZzLM9qGc3vHOselorxz7x+t+P+/gSt5MFTSstxHTE3TPxPxc7gyx7pEVmBwTti2SXXFAd/F+Gx59VNWTSLaXSgy1okGwbfu/oqVUq6WYEQTetsn9Ywbb9dsDsQ1TT3WkX6JF+OYQbuwPGrr6XT9KXJdYOqpmlxFhr7OfMGBp3gWRkFg6wGLo6Sui+r3FGvtYBmFBUKl6wt8PwjAZAzqPu7tK0fDOmx3vTtmWMFN2ae2nsgtohINPefyJFpsn8JrQQGLoMsAeJTL51V
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
index 52ea0e6391af..c8b090e8a972 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -654,11 +654,6 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
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


