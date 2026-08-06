Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C623C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E086B0093; Thu,  6 Aug 2026 12:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B553F6B0095; Thu,  6 Aug 2026 12:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B186B0096; Thu,  6 Aug 2026 12:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7554D6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:21:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 003B0C0144
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:26 +0000 (UTC)
X-FDA: 85071359772.07.556C90F
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4106C40006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KJKNF/qo";
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOsPNiSoAq7GDP6w7OV2SllTzHTsJDcUCUwEW3O7ycA=;
	b=tNNWB3PDqlP0VZfgulpLONPYxaJ351F9WCdVVLX8iMwlsXaT//tGu4Mr3KRphA+qjVIhMk
	886Beto8WvvKtzG7pQhPIoqVTlGsLzkbVwoJP3hyKVAP8hcJlz3Aln8iI0XRO5cl/8PBVL
	QGIj5bfEYIGcnc4N739Qddm0QrkfDe4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033285;
	b=8cnkF+sRtt28yOGLgZEoA3vciZSqxfeuRBcgRoGmZ6Thsuk/s3Bcd0H3IVkFvn2MTm11O2
	7fEZuUwGG2hxOr2nspsgFsBJmJYCe3hUjZjmpNCoSmNRq8fsz8vD5E/zs72EzYJftNqS2M
	0Sprk4w56eRjzmp9RWsKavYDi8hcmuo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KJKNF/qo";
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8485bd28dd0so2829053b3a.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 09:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786033284; x=1786638084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OOsPNiSoAq7GDP6w7OV2SllTzHTsJDcUCUwEW3O7ycA=;
        b=KJKNF/qoRcp/TZdvny5g6mIc9EPp8uluEMcVP8lPhd4Uf+frzugyLvY+Mg5iOSL9Rj
         R5ZQSvJQAoPnD3sQLgot4q6WFMcC3pBhwdGP/KvF3qvho5hOdBG97hJh1bmOaYhisYxD
         /C0Xh/PHzXLEaYdaM+HW0RNs4wRqxSLmvbEqiv8TyqH4zxN5aHm8ftCPpTuVbH8LKxAF
         N+x502K8cNdxuguMN6K/BMVpMwF1HNkcyIknLcRdek0CVlwKEsov5JRJdEw/9B07iZpg
         nx3CpFIXw1rNqDYrYGbZ5uJ5cA2/gBLU7aS6uzp5dAJnnvCI9X1aEN3GS2HBcjUeApai
         CDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786033284; x=1786638084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OOsPNiSoAq7GDP6w7OV2SllTzHTsJDcUCUwEW3O7ycA=;
        b=WY6GzMI6Y0gOMRCa3tuKN3CLbMkj5bJQjjEIhWr2ZETKI7ovgZjUby2s6tKFjMsSn2
         gieURTAQpwgcIP2STw5S+nzZ2NMgLkjKJwws/IFyrcBGPMuAxV3U9cRNd4AK9dUzm53X
         tK3mjttdgzBatJHasynrb2pT/yU9cMkkJbDSIJil7I6YG3JMT7Cc+tGoenXxOfPOy8ze
         pJ4mcxHvqXwGGdjuFN1IneJVHBxI7pevH6aIbHCr3B2wBx3GbsdKMMG7i++l5ZTzr0/m
         XshQZlTgFyXW2weV45LyyUsMujgy2IVufyVhgbNV/4nH/4pQVjvqRig+ROZoqVMISUE5
         1WKA==
X-Forwarded-Encrypted: i=1; AHgh+RqpqRNHV6cfbz3omFd3ZbISttgOo9iU6DDb+2iwwV2DiN5/TDHRCWSbnwUCKxRam++c9nzX4kr7AQ==@kvack.org
X-Gm-Message-State: AOJu0YzlYwqGOgDl4SOB3DemLJzFZuMCfvcmi3Euxu7VfuBMW9L4O7fc
	alG91D6flNxPIBql7S/0Vzu33tY3qglHfBFgjt+pcIObcTlJR8sLz8B+
X-Gm-Gg: AR+sD12uZj2Vu3nMUWmiNM0NvAZ1UiY5JmFgBHBEwQfPZa/pST8dghDkzsbGlWqv/4r
	Mi0W1MlSD38Loge+PZ+NKGbdq2KKyVX5Y9YPmIeI5UiwI/F9pjTzg7Feo2f6btn5ud91PGwOG61
	2If1yJasGU2Qb23Or7KWFp/FZhhq6OtKo3QOQQH9R7tQyFelmM2/z1aJY5vsKw7I1Em5sJu1Hwo
	r8L5FZytdLiueNaoLiJ5M5PqSBq2sU0/bqLWURGic5/nvFmBPaRNcS1aIbAGNMP9qTrI4o/y1Hp
	9X0w1KqFBcQrZ0deSrtvI9PPavCghCEleCXnv5qzIz60g21k72uXcTRp8FCWpx2TRom+dYVf5+/
	TPz3VEMpkbJyqPo3LZS5C+9JAlaKGWkEDbNgth4AnA48YvS8BtoPQVMOtOU4raqCnUJtZcoEQVm
	1qakNLUcEn1dUmIiI4/K5EVwvxoxh/HrrXd5c6RAeCPO6OMpGx8UwKIuA=
X-Received: by 2002:a05:6a00:bd02:b0:848:8619:c149 with SMTP id d2e1a72fcca58-84f2dff7881mr17875881b3a.2.1786033283870;
        Thu, 06 Aug 2026 09:21:23 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f459b66e6sm1662739b3a.40.2026.08.06.09.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:21:23 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/5] mm/mm_init: remove redundant clamping in zone_spanned_pages_in_node()
Date: Fri,  7 Aug 2026 01:20:53 +0900
Message-ID: <20260806162100.313965-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806162100.313965-1-ekffu200098@gmail.com>
References: <20260806162100.313965-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4106C40006
X-Stat-Signature: qa1shi8uju6rfo1tzaj9xeqochsqsobe
X-Rspam-User: 
X-HE-Tag: 1786033285-911936
X-HE-Meta: U2FsdGVkX190/b5VnrWy/dONjzlJu8TXTPf+70XEnEoi097vJADVfWB+XFA4S+E4NcZQHs+1nt72j92XjuQY9C14eGAmf+3t8eSIv3YmR3yBx1D2lD59RN3HtopAg8KUyb9QSiwJJqcuDUn70FSO3kkw7Tbah642kpRLOmjTMJt7eRJSoGXDzfjZJj/O4Y/s3vqrKVYjWCnbg38V3MEaG7KV6iiqPRCgJceih0jFvZKW6LJoliZoxC9nB0wIIf1J2EK+LoRdfb7CuyhWWD385DnHkN7usjbYyPCTt459PPb6qxVUv+5uoji1wVDLZ/taRwXZBJaGCjKD+p8H/izxjIKIEmufTegFuoyFleKN4bb6JIwZaA+zU8ZMIKWQn9aQOYSL4Qrffz/VUleDWGXGyBPTTL+NUOw2jSySELUHrLhJKnbVSB0z3plMAaVKRpsaE9gH7eUgfRDWMctotf5TokkiizbFPvFmEK9RhGYu2tL/sUtZKrv3pFTPvWAk7n0p7OuY0oOK8pOMVdjiK5kypaapBvRNGqtdgP/UncPMBI7sGFZ39XKrpEDB3nK1DNwzP8BpGVLew1as4LRsps7sQL7OcRCo8n3LHb79HQexBMAvLFS2aG8UsWPDNbes2YlETEngTjzju/3DTyyiCMilQidTIXKJ+yMh6aV20vPe0yiKlhJ880Y1/MouHznkR6DTH855p2OhVW9jTRSQUSu5e68kg8UN4PVeSMLWJXIkgUZLLW+b56A+d04XAvVH3gLDnna1A1trb70aRClhx0+ku210zPRTzhXeS5kanQFCufArJS6pxKCyDODgmcWsx9um7/yH6mxoqAmy7fiVyX6M0r5evDwDwN+Y9DTFhsEYxcAwXRBV/rnLOYVbx+6wUrWa8uSmhCR56kij+WsjA8QjOdSsZC+nmjHNXyg5wMqiJJQTdIJb6CyfHGvIbpN00DO0MsoHdOkQTjcHF0Do/v7
 pfeMykfR
 6wv6qoaf7LeXkFNEZC7ournJlcHeoEaft4XsPNIeo3+wVt+R4xTtOimeZmAVdcbprizTuNN4H8oq0LAlM7azNhisQYu8PF6oFmBouet7FnPe7EPGmLIwyR0NRY2qAE0k3tcXvuJGjJvfmgZjLq8qhp6nfRdr1nrj8VdQFxf9ZL4lrMIfct1LnekumMpSkNjr1FlN/LiVLX5LpRfVwPJVHBL2E6G/wCNX+2ByuiU7hDwzgFAxyQeVV9gAdG5mv92gezz3L/85k1a7v0RYTLVj5QOH8tV/EkZ3WSXXBt1u/7qomubzVjMEpEwfZOiCNzFt3BzEWTBIOsSnzsQ1gmNxfrFtlI6SiZHTzgFhZLQwozyTjEBEaPAYvGdQTKSGdRN2Getbm8+8rkq++b4vvRALYYolbvjsGIvhsMYyPw6x6zZ9tal/pKLdIvws4tyuKXdCHLXWdeZjs2oaM33U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clamping *zone_end_pfn to node_end_pfn has no effect, because
*zone_end_pfn <= node_end_pfn is guaranteed at that point.

1. If zone_movable_pfn[nid] != 0 && zone_type == ZONE_MOVABLE,
   *zone_end_pfn = min(node_end_pfn, ...) <= node_end_pfn.

2. Else If zone_movable_pfn[nid] != 0 &&
   *zone_start_pfn < zone_movable_pfn[nid] < *zone_end_pfn,
   *zone_end_pfn = zone_movable_pfn[nid].

   The condition requires the clamped *zone_start_pfn and
   *zone_end_pfn to differ, which cannot happen when node_end_pfn <
   zone_low.

   So zone_movable_pfn[nid] < clamped *zone_end_pfn =
   min(node_end_pfn, zone_high) <= node_end_pfn.

3. Else *zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high)

   a. If node_end_pfn >= zone_low, *zone_end_pfn =
      min(node_end_pfn, zone_high) <= node_end_pfn.

   b. If node_end_pfn < zone_low, *zone_start_pfn = zone_low >
      node_end_pfn, so the function returns 0 before the clamping is
      executed.

So remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 30d3125951f0..bdc15de0a62a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1219,8 +1219,7 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
 		return 0;
 
-	/* Move the zone boundaries inside the node if necessary */
-	*zone_end_pfn = min(*zone_end_pfn, node_end_pfn);
+	/* Move the zone start inside the node if necessary */
 	*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
 
 	/* Return the spanned pages */
-- 
2.43.0


