Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF9CC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FDE16B008A; Thu, 27 Aug 2026 19:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AED76B008C; Thu, 27 Aug 2026 19:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4DB6B0092; Thu, 27 Aug 2026 19:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 550E16B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FA42A023B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:21 +0000 (UTC)
X-FDA: 85148647962.06.9C34600
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id EEE5B14000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Al+z7w88;
	spf=pass (imf09.hostedemail.com: domain of 3xsiQaggKCPUpqbsbkpadlldib.Zljifkru-jjhsXZh.lod@flex--stevensd.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3xsiQaggKCPUpqbsbkpadlldib.Zljifkru-jjhsXZh.lod@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brDKxupp32vlfYsuON/JY3iAK7z2zOrfUeaeP3zp25g=;
	b=koWq4mSG+KsiRFEhpgTbnnEXbq7Io9+H5jEuRIGVQV/Pa4mAXhXGt1kOFZUsbNun9rsPgj
	e9Wv9QVfGV/aZxs+0PuFlXcpNspQvAXmextUZYRjr3pKNSxURYx3JC95VFSKrxx6ZqKOl4
	+W6Wzx5tYrgzUGj8iBljdmY4Tuv/89g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873480;
	b=UKacfF3i4efmYsggQBiBED6WXQRYtARwMnQLXIVgZNAQwV+rF6BRciIKUet1oZSx9SBbaP
	+iNGnKKVRHhQdPtMCpXyyjCtyqm7qr+C4Zk9HqXZ+7Z2hOoMdRLQH6iCS0MplJA0vtwqS3
	iJGfbN2M64zSz1nxzhrEcyxZtMnrit8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Al+z7w88;
	spf=pass (imf09.hostedemail.com: domain of 3xsiQaggKCPUpqbsbkpadlldib.Zljifkru-jjhsXZh.lod@flex--stevensd.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3xsiQaggKCPUpqbsbkpadlldib.Zljifkru-jjhsXZh.lod@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb835525b10so360610a12.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873478; x=1788478278; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=brDKxupp32vlfYsuON/JY3iAK7z2zOrfUeaeP3zp25g=;
        b=Al+z7w88bNpK9VI5q3lccAOMc8u37cdvSNM0qeYtIBEitUjtLYytvOK06z1xTwVv6T
         4sboV2nNk34XJzBsZaEwpe3ul0o/NG47az3tIKDVkoOVZVTMgeAqfW0omwGR/uuWi509
         wDWD2TkevFjeijIWy1nOdkyBwIKvk68iHSJOg6Fd+cq8oBDnBOzlb13bE0ZMOs8UQU87
         DI2zsBwgX2euXPZk7BO72GmqLtp3QoMwSuLICK++r2Dn2CM+H4GBNLblJdza8dEqtlm+
         qMVlfSqqzag4msfxWt/DqhDz58wNYxELJQsD+TwWhq0iwBSEnxkCgXt6OwmFR2C56HXf
         38Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873479; x=1788478279;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=brDKxupp32vlfYsuON/JY3iAK7z2zOrfUeaeP3zp25g=;
        b=qgLLja4cV0Rrlq89KehbVuCskgVXsU/lNngIroZvngYSqel7FvtFfrMdRu4F2Tyg9Y
         VM0dPWvEOM8fHED/x3HxCXq8VOVUVtkxFa0Y4zvesLmrxV2PTBiZoaR2X7qo6Mmgzfqr
         MJccSTMO/U2fI8sh5tyrV+UyDrPnDeAtu5oCBsaeOG9KS882GQsyvXAx6/GYO7tIzHaF
         qQyQXs1ijM9jjJtbdnrD4ApcbS4UEpQOejgs9ykOIWvww5jrQR18IW/iT3tKmSA0RyZ6
         5CD3adDEMbQR1q8NnZhcCV4+s7/seuDw9tpS9BcLCdxY9RtzuAtOAyhhux6r0bLpGR/H
         U3hA==
X-Forwarded-Encrypted: i=1; AHgh+RopDZc1xIA8DIlkiqdD2i6ebzGKTy31d2zOmwh+EnCdLKcCUiDU8hdwPtwZh/Fp7E6xTwf9QOT8Uw==@kvack.org
X-Gm-Message-State: AFuF++m8lRKWoqBXfgabfw3/+cucC0vOAA7ogUtb5xQ/9vIxRQw5lEjb
	zQ/lvNhxMiUtwB0I8fZOQCruoiIeMFu9C1VNc0TVfF3BelBMrEtiWVHVIdnkVgpofkacKhu0gWO
	8rkgN5XCsO6/vVA==
X-Received: from dybeb10.prod.google.com ([2002:a05:7300:a2ca:b0:328:4d52:8cd0])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:458b:b0:2d6:f3f0:3e7a with SMTP id d9443c01a7336-2d74dc2ade3mr36333205ad.3.1787873478170;
 Thu, 27 Aug 2026 16:31:18 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:39 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-2-stevensd@google.com>
Subject: [RFC 01/10] Add !MEMCG memcg_list_lru_alloc implementation
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: n6ki6wxegd9fa9jqf3gdgsy4iahnw4rz
X-Rspamd-Queue-Id: EEE5B14000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787873479-73999
X-HE-Meta: U2FsdGVkX19XsdKOee+rYgSJjlaWTkWiXT9mEIXw9tYFmI2TpHccXAJ0NwSet+u3k8fPWJ61n+U7fDgN8wWx+mKku5z+zIMDwl4OPWhK8yDS0cbws846XvkIQrC1LIlhMHcyQUANS9IFw2mD9oxOR6EuQhoj3OlG7eqtq2jrwzm8JsAnpU5MvOs3zgYcm/SVxyKVv5sxqmHANYpPTMCuAc6NgBjBbDo/r9jwFfjFa0gOsTxE7tStNKp8V9RVxlmglaWcB5ifbFMWYkVGHbGtP3/OiF5kFfQY8pjZvMWHgwXDh3E0gGC72ZNOgVaf7MnAdPNzJb6wFHJO1/vFYst9zfYDxNAK0SHbVCyn0h5jt7MXDTJPEFeteVvDwsTOWy+LR19y3BYT5pExHtneq7GB2QmTSW8tQjaiYfhYrUgQXNu5uz5QEUQZ3cBkffWsjJ4shWlyftboAHyOJPyWPKR5yc44oqAzvRi/KW0dRSm6LBPSjC2U06PQX8Oq1n2s+dZNpAaUc7TGdpGPQ2Y7XFg7I9eROlRv3/XeFrKKk9HEPH8QIfAhLVLiHuLda1XZQRcBu29YSg5P+tz8BCXRz8PdKS0u487WAZXermQo0cKiGVtkTPHot2myYqA4S3bAIROMoPX9Fnr4aifLyY9l63w0+BdQP25Z2EK3XKT/thqGEmLcN8mczdLuAwDimff3ScA0SCpC8ObV7wg6OZOvSHFNsy6uOAMFcMf+h+Ecec1vAvXOgSd+lkVonl3vwGF6NU98DHFXnoW05DveyZZEiQQFFnfdZHwNzvytXkpPbY4J3GGQJypJKAl9ivhdj/fGfPR3WZW/azb0HeRtHolN3EvMpF2EqvRKAb2nlxOPcOYqFizuQ7WrDhr+Btok2Ay7gaoamSgLKf+JWTKG17YA1CQwPg3WKhwoIMZHSnl9rLflUMZym89WVjS2wxd4LrTL+JJBprKMr1asDLEp2xcjfC6
 XCwKkk0+
 /EmsaeCIEz4DU/yUAvw9pkkVg8FY9oQw5D3+ms4bcAwqnbRAeYufAhc8TS2f8zWzB88hRBLi5zICqDTdmaBtSvYylvKZcjhyhVnPtXn8ICWaIrbMeABCUBtlIcAB6c74wn/PZa4RcCD+UJW4FlSF2LCDw3QR2ahFkqgH30z4vxnKwrx2SyKhqJ0KbAkPuEa9BdyNRBOzA4fkgEvrdQRXMontQnS62QT+ef0fB1Kujb1iq0yolM1hZinoad/ksCuTbBooPVfuVj+x/HhUlmy56Vjo9+ss+0mSUvQn/q6Ys1fNJiSnv+h8K6g2Vo7CVRcjBlrsm0+Il1dYNok5jeWcG5vpZtBVO8bdv7Y9HomOUypmz1sPI++epdBC1WRwFQFD51LZhvkObK5sD7sfl8ZN4WEFk4MVP3YVdILHiJylo8F7aJ6T9vbxo+yw71f5e0VtXSkUZiE+mu8WZw1E5M1PeJJQbgApFDOIXFLnd4+DR33WGwS7C1Jou7tOKHcx+xwwat+LyJwY6N/qPCK2XQkecx/S5fDDCfl6JmSZ5L0cfCTOWg4IJhr0R/zmaQENcT8Q5Yb0vdtAi56TuFe9yrX1tPLcwUCQNuLccEmFgXmNbj0f8FzNzD+f+HvSXvfMeyoDIa8vl2j2zYwoODwMLYvKDsfTG3s/fdCTClT9p8VDr/AfSm6HIwgMIUkeodA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a stub implementation of memcg_list_lru_alloc() when CONFIG_MEMCG
isn't enabled.

Signed-off-by: David Stevens <stevensd@google.com>
---
 include/linux/list_lru.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index a450fffe1550..40eaeaa3424c 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -79,10 +79,10 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
 	return list_lru_init_memcg(lru, shrinker);
 }
 
+#ifdef CONFIG_MEMCG
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
 
-#ifdef CONFIG_MEMCG
 /**
  * folio_memcg_list_lru_alloc - allocate list_lru heads for shrinkable folio
  * @folio: the newly allocated & charged folio
@@ -106,6 +106,11 @@ static inline int folio_memcg_list_lru_alloc(struct folio *folio,
 {
 	return 0;
 }
+
+static inline int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru, gfp_t gfp)
+{
+	return 0;
+}
 #endif
 
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
-- 
2.55.0.897.gb25b4bd76c-goog


