Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FEE9E6B274
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 12:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69566B0005; Tue, 23 Dec 2025 07:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17986B0089; Tue, 23 Dec 2025 07:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE776B008A; Tue, 23 Dec 2025 07:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACF776B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:25:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58B3D13767E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:25:52 +0000 (UTC)
X-FDA: 84250657344.14.ADFC552
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id A66B68000F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:25:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gazoi9Ix;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766492750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=BGRw4C90s0m2SOEMgTOU12TAYFZwOSr323PPukFYiy8=;
	b=mapV2BD7ujwI2uZYH33iSJ45zWFVv9XRDcN9WrO+fKwnEVjfJEObV9t4JkHspSf7U+21ph
	nHWew2eULJU1wiE0C1i9KF4cml0UqAkuDMcpRJi9HhvDfEer17vSjS5XiltotqrOqBveJd
	GlPB1RSZ9HdirSjsL0orGatlvJ9yUzY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gazoi9Ix;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766492750; a=rsa-sha256;
	cv=none;
	b=lJ3ONoy33bHnaCSuI+DIr2ACHxCzCtR1XfH9VYWBak625AfM5s+RTpN0fu6bnLgbJN4a3s
	wlHitZg8X6mh9F1GfaKS21JSXBDFi/dfrHQ6hdoMyQSiERlyHOQpiMUjLHu/vdOG7OxJrR
	9ahDhr1SL1YGZEhNivmMGKiw0U7Px4o=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b8b5410a1so5468189a12.2
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766492749; x=1767097549; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGRw4C90s0m2SOEMgTOU12TAYFZwOSr323PPukFYiy8=;
        b=gazoi9IxxP0+fBzEikigtKZjngUoKrE/zPq+HX4TXTZTKNIsWg+4btQfTuT/qx5L0T
         IPZhdmRaObyZ+3gGizmSWsmtqpTDAs+3eLU1m6Al9cA0eobNH5RYdfWy8DSG4nfsc5mf
         kpUQY+H2V1Sqn1okzlZztwKkPijhUK15bI3YHAzJyT8sDfEVDFDXOuKvjCvZeeGKrtpL
         U2P0vNkNasBphBU3ApPJw8I0ZHl/kJ7mbjUMWLAwO6pu2zIZw/yxvaL05UpVqVjgh0W5
         X7dUvPZ6m3d5V9v+l1Pq6nTPsYpSGz02dhy75ihotw1xkKs5HVf3Z3oXEDhpESlGNCTX
         XbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766492749; x=1767097549;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BGRw4C90s0m2SOEMgTOU12TAYFZwOSr323PPukFYiy8=;
        b=QG1R1OinPBfJbHFMHALfB8V55P9KeMFRCKwuC071iKU77GU29mwXjMDdTmnOP9X5Re
         WL1ZuIqMEDF7NBy6fZ3RhBNiFcQQrbxAIKuwKaZuwTYa/YGKlsMh4Z83g7vlxLE2JtMo
         MjQZh+ZOIChpFBztHwW1QyObVnBUdXLXSaHPaAUtal4OKnKUsiIMGRY9OFhdX5NBgGiR
         e1qaKMhHnQaEuLbc/X/FD6frwSRN81blvLaDnaSd3LBaxlie8DqFte/we/uoM6icn+Mk
         jrsdmy+q2V7TnHWqDwx+Hcd7sFprQ7Ql+iqkowH/Xx1MTVrNYlclfr6PmkFKDSqRthE1
         Iplw==
X-Gm-Message-State: AOJu0Yzy28ofxgQEeo52mx6hHkot3xVwlrmDsLu8YZEz3O1yM4XcACMf
	wlec0I4w9KJyjAAmlzvhMEQzr+kDuJxbc0S3X7fvTlJJ2KLp8N+z7qhx
X-Gm-Gg: AY/fxX5udu/YOGGpbaM0rpPJ2DKjb4/doM+QW13lA6OI185fEOP0FUMeNKsVDvIpT31
	Fii6XxJTHmfIkZb/gbO3c5l1RKJXCrxmqvs+BGIl52y6T7yO50fXMDNGLhjZoc9/wOKeURJMeV6
	m2zYoUMukfGE7svFjXKQbYOHGD+2BiPPe+9fxPAadmG4UGJnJ24h4STyF0CDkvUwwgCTzm44iDY
	oo7a57bt9i/WfLzMJTThEbKD5sUSuNFTrSRXTS421NTH8gEhak7t79iXXaG5BqUTOXfnR1snx5B
	n+Pr6c5FDrIMENOLkqVLEkGOyVHBMwgeK1aeE6bwlLjBPtk+9YPpJpCv3XmYqEr+R6Zb20Q1+F/
	a+19IfLxiptoqWWwi6S1CaY5c54jOf8vCK0/Xk5cKhksVawWKCwHb0EJKpX/FXUxvba3cgQ1IQn
	x92SJdfsqOzw==
X-Google-Smtp-Source: AGHT+IEVtWM7siqyoaHdpIx67nMl6vkTmLCe4SLFz8Fu7b4CRZ5iAg/W+lBnlqzRYo097GkwslddYQ==
X-Received: by 2002:a05:6402:35c7:b0:64d:264e:71f with SMTP id 4fb4d7f45d1cf-64d264e0afemr7171671a12.24.1766492748824;
        Tue, 23 Dec 2025 04:25:48 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64cfebea196sm11247030a12.7.2025.12.23.04.25.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Dec 2025 04:25:48 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2] mm/huge_memory: consolidate order-related checks into folio_check_splittable()
Date: Tue, 23 Dec 2025 12:25:39 +0000
Message-Id: <20251223122539.10726-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A66B68000F
X-Stat-Signature: br974ai144fj5bdk7amoejmpqchohe17
X-HE-Tag: 1766492750-766825
X-HE-Meta: U2FsdGVkX18pmZQsXEBoyJfO5G2ZpxMU3z8dPCy9fNad9Zc9TZ7CwGMH/0FK2VV0SyD5FA+8zb7YfUHHm76EPLvp3JEbEfyAyFVnAsxql7DTRf0n8aSsYscSbtD9ciGjpXwvZbETGaCHkXvWYMJLQRhIRCfx4mDfaX9z0Ipkyv+9egH5tmaOZ8zFd5sC7q6N3mURBdIe63NiiZ1AVhSkC+fnP9oO5G9dkefLg/nlvgl7PG5DWAC0bWDKeM0MON+14T170Ot79XXWsN8ljVp7hDPdgol47dmrhpnKoeCvonfQOv0x6sbNcbLo9QDgz01cu04ndveQXrlySOq2ZSGPSODd7B1UWpybjqpN6Iv3OmQ+AxaNE0/NU/UmZBCPmHVKJM8ihBQEPzIHVNNWnLgVoBPUvBZJUh0Db64ooHD/XzWxg56BZ9j89mi2MqXcPEFPgQnsqB3ZO9etUiqkipH0GIe3rC1xmHn1fPJIuXo+A6x8K7IbalDJD00ilvg6FA6sE0TGJob9Ts3VB/cZVJP22/WEod0OV7SzHoBUWeI7TDynvEk3U6iEzTCK/eclS6RQEGnFjzYQX9obuB0lkJsc9ZtuTSujHbffVOnUZVo7TR9jSj53VDfOvQiP/UAoSg5sQKlI3gsJ28IBCYOJWYTaoG7W6l/dhUW4mYbhgoMfHacWuuDTAr8YsRWzEe3AoKTRDX7goXgYEzANPSkBSh3aHLSNMT5UAMBtJibgo6+QtlU5LjUBm8CorlnHp3a0+AHak3ZeT20spPEUX/geS5mZRw7Ak6YowEzxKxXMYO6R0HK//PNxkeKbc512felW82PZ3ND7tuZnlAvDkkNWHMInaDDjJXFcflHtyPnfD6E0e2AZ6OjCXi8olPj4/+e8D6Q5oSixPCOlgWjTX2g9+8XpdZKQZddrh1QwEPJKC8FD5px7q2us2I0SzOsPBVy9xPnYEEF+dAQZ6toITwnyY39
 /H+2mLhN
 FEuEEpQVsLbb8Nzkp2CjCZccQAwsjKEgp432bcnmZxysJzQionY6KOTy+SXos9+0PTk30lpdRbU+LAd4WZzkp7kub4unvL7De/iaoukIOleIELLkMzkzJ30YzGUx53nLftmKbBJySZJiOJgB5HrJ2W/Z05qUvj/ZxmbB4mUFgkR2rWq+Rl/aRV+DnjAhS9y9zCiYzGz66U5PQQF+pXe207RtoiCuAgZ6HefindqXH48jsNVVjDwKMFuZ+ks73issT/2XtMFi1gI4YIQsCNzuoJcMamIU4bdSH6e1FKCIzEalwZ0u+5D0txIdsiWlxbxBEjS3hzyuPgwKxfPJGFth1ClqsJiPNrvHyHkujdxcuYmrGBoCGEgvb/PuRyaEWhHkR/nQwaWhWxElasrIIVlEmhqzIZ7amutWPOtS92+8XYehU9fHI6ZqFlD9dk2LPOrzKQRujQj9X5dkFYvh94oV9yT+eBhjiOIYNDRe5xGoCObCWijiTvFT3twolj4Qim1e+lRsNsNrIcXlL1q8b0GEjs1GaKYf6L0jVUPFSma09MXBlhSQURR55QxenQzDxU3JQslrFrDxruVdGfdlLbq7JivT2Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The primary goal of the folio_check_splittable() function is to validate
whether a folio is suitable for splitting and to bail out early if it is
not.

Currently, some order-related checks are scattered throughout the
calling code rather than being centralized in folio_check_splittable().

This commit moves all remaining order-related validation logic into
folio_check_splittable(). This consolidation ensures that the function
serves its intended purpose as a single point of failure and improves
the clarity and maintainability of the surrounding code.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>

---
v2: just move current logic here
---
 mm/huge_memory.c | 63 +++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b8ee33318a60..59d72522399f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3705,6 +3705,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	if (new_order >= folio_order(folio))
+		return -EINVAL;
+
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
 	 * caller that there was a race.
@@ -3719,28 +3723,33 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 		/* order-1 is not supported for anonymous THP. */
 		if (new_order == 1)
 			return -EINVAL;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
-			return -EINVAL;
+	} else {
+		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
+			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+			    !mapping_large_folio_support(folio->mapping)) {
+				/*
+				 * We can always split a folio down to a
+				 * single page (new_order == 0) uniformly.
+				 *
+				 * For any other scenario
+				 *   a) uniform split targeting a large folio
+				 *      (new_order > 0)
+				 *   b) any non-uniform split
+				 * we must confirm that the file system
+				 * supports large folios.
+				 *
+				 * Note that we might still have THPs in such
+				 * mappings, which is created from khugepaged
+				 * when CONFIG_READ_ONLY_THP_FOR_FS is
+				 * enabled. But in that case, the mapping does
+				 * not actually support large folios properly.
+				 */
+				return -EINVAL;
+			}
 		}
+
+		if (new_order < mapping_min_folio_order(folio->mapping))
+			return -EINVAL;
 	}
 
 	/*
@@ -4008,11 +4017,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out;
 	}
 
-	if (new_order >= old_order) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
@@ -4036,16 +4040,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		anon_vma_lock_write(anon_vma);
 		mapping = NULL;
 	} else {
-		unsigned int min_order;
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(folio->mapping);
-		if (new_order < min_order) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
 							GFP_RECLAIM_MASK);
 
-- 
2.34.1


