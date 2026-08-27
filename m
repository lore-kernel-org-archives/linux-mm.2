Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38362C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3BB6B0095; Thu, 27 Aug 2026 10:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154696B0096; Thu, 27 Aug 2026 10:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A8D6B0098; Thu, 27 Aug 2026 10:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5A3A6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:45:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6153C80477
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:45:14 +0000 (UTC)
X-FDA: 85147322148.13.61CB9D6
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id A936F1C0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:45:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y7zaXiHO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787841912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KczeZElwfYPxEPlG/rv8QuvplNP93y5shDnpCmj/Kkk=;
	b=BOZyVtrZe9g4Zteo2nORw4x0GoNRB2a399CoC7zeUJ+LYaC3V6XxjpsgqYM9uc02FgJQRO
	TzXWhr874lukNheRaPE5bezMrH7PogC0PXtKRUBwFlkTVRJFMkRr7A4gFFteq52S6fuB9g
	EQlhfg1WA2N/b02ldnOPkm6I8xobQug=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y7zaXiHO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787841912;
	b=6hFnvcHdgE1zy5sf9Kx0dtcz8GLHrVJpQGSrefeML9HDtf/ZrBsJqs9CPAQ7CTxfR/orYH
	GaB6hQurNY9Q2dwLZXuPxb4BLp2ekUb4D4XPk+789gsSqJ2uAkqE/xYOc+KrD3KgQRy/v/
	EoOqQhxLs/S1lIXTvnmo8V+kNjve/fk=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc1c9879395so1906571a12.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787841911; x=1788446711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KczeZElwfYPxEPlG/rv8QuvplNP93y5shDnpCmj/Kkk=;
        b=Y7zaXiHOwlHO0mMwC5roPlpdRGOfx5ThqVdQ8ao1pMjRdz2Eo5YizYChVlEfQeUhAp
         UiL1uFsXHcPT358JS4hvjoKPnlTxz5DxW6hUQmlfKexliiIavrajJIza99ez9/fnO8xd
         hSLQYjfSL5/oX3DvTTZ/Eb6ncF6bRKjkFby01iJSUAaLqX5WVLfRVx3OzvMZGmIWfl3T
         KXo+5cjhZtuK4GpL/tDZpxTNTPYouVxm91ls/3PisFpd5SSWxhzzw/RqSOuq7TI6zFSQ
         7pDO92naulMnd1SFBJfiiiZNMBbUZBgDuRv4JNNwV8XoMvO5+p7uLzJ7k1uvvEXLz0Ot
         lBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787841911; x=1788446711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KczeZElwfYPxEPlG/rv8QuvplNP93y5shDnpCmj/Kkk=;
        b=opd1Uh15NO/+jsRpNqT/cAqwnNHEuTmTHV9vq8R2hxIcGdLcdMPxXCkZHKA4lHSzhX
         CKTMS54Y0c1llLjhyUzw5La011ABpqZHyb6/N27HheGZ8t+QC//x2sdOI1MJRc2ZA+R4
         dOf5kYowN/XCUIr91RilbNbGeN1QjAjNJ0HLwFV9IxWOXxLUV9MkN7pZ2PLcSj99a6Cl
         3a5XdPJWHEbp4RbLDtC1yL1S5WUNlYHigRU86yL0yWNh7sNgJMxviRxMpA4sZEBoMn8u
         1REKrcHeSs5529nCfcvMar3JA3s5Mlo/Fu2uOM4JLKK802w/nMkW4PEhQ8sbCVVCBUEh
         XXOA==
X-Forwarded-Encrypted: i=1; AHgh+Rqd4dClIxrRc+ZA6lHMWWVGuHAEWInyIAFv8vtTz/UssFIwcN4bhtADBz2Pq29AQoZyl36MfpVZ/A==@kvack.org
X-Gm-Message-State: AFuF++nRpBt+CeqJMvSapXrdoA+CsgJkeIwwq11tYCgLY/TFys581tco
	Y4xsNQWDgF//1z++smxH02xchnkOPsco8PR2oOpzNVc4ssCfNHI0gpO2
X-Gm-Gg: AR+sD130qZJQvkAtMD1BkdOwYtnUYbDOXeesWCKFNCkW+zrjHinbNDnwGiAqAnpiarw
	NWZL4zleH5eu1t0VFuLyn9sheJleZR5tIweBEZP5Z0LTmBApr92/RBI/xauyiDE/rMGUozU3E4f
	joCgFSeeXUohXUDwSbihlJfXw54P+EVbuJ/aJ2s3+CzGPeOnC7aH6y6yv9OslI5YEJczmXPZz/M
	g1VeeMsCn6yGKorvmNffML6xuEGi7Hj+JESmvWLBAkqyVJ9bDXS51ggqDoOUsMdbnVBtKHSDRzT
	qF5PXKL4j1VF4aMwgu1909pj2MuO9emENJjf04IWcDtVVA+FKEoo/RHvbK2QRs5A75Z0RS9CLo8
	wG2jSafqcbKcMevKo7eTgZcATb71kOADb7bB5ddC2j7S5SledUiqbNEhs7gZSJlNYjJbsMWLEJH
	KWXNSIXfWYi1YYGxUAJUdp28gzf16Yq3we6eH1PnvJt/5AAP8RXNOL9nPS7YrNjdDwmEA=
X-Received: by 2002:a05:6a00:3926:b0:848:46a0:3d74 with SMTP id d2e1a72fcca58-8537499bb90mr26971410b3a.9.1787841911006;
        Thu, 27 Aug 2026 07:45:11 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-855a2118b01sm518684b3a.41.2026.08.27.07.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:45:08 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/mm_init: remove zone_absent_pages_in_node()
Date: Thu, 27 Aug 2026 23:41:46 +0900
Message-ID: <20260827144151.486192-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mfgm1jht73g45rmrbn8c85p37qfipfxd
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A936F1C0002
X-Rspam-User: 
X-HE-Tag: 1787841912-826315
X-HE-Meta: U2FsdGVkX1/YDuVrTFX1BuyqoICjFmv0SWTDj8y0jr4Q7wNoNugqSVV+hV5tbVXma1cF0izAvZ1EYEIAafsNLvtOG76SndCPFah8ixsqINDK/c1sdggAcoocMAYxHN72aL5lYRLDN5UWiWv/vhydcdFSAjURWyUwJvHqPA55UCuEWcgV5dGYveKH5ZOLvIkiqTZfzCQPmGQYSEbrpN+WDgjuzZG2jik/J6Qa8dhqvq7tke2GTGQ81h2ESdkjjAYDKR2odmzd3My5LuOwEH6qQpnbjxhStGzBTwHiGlO22e3QpyS5UktWJcp2F2Iq7LmI8vZzf4ikqzMBjTxwuzcYm/qbWYzw9QZ5NzHMuqt7PDZzv5Yd6u3hv6YGF8LOhwMtOqg9zTsUPE7RUP5Tw0GN2UcrKxWbhnYHFzwsrBQ1xVIIyBLSTS/BgzSWJV9rC2GHgr9Wi82u5YRB4AeKydBIOspHx6cQuJaTl5NARwQz8YHc0CvNd64RiM67DocnIIGerWMPGiFPNveNwvnFOAByauLcegQIlWLWWMDlFwjWqNu4Qm73qj+PYRUVv4z8o/o5ygnqYSZ6cxsbXFQ1bhj578RTJq0q87kHqAyTYmK3Mj0aSJb7m7SOr7X0pc70lAik1eMI/vUhssGVKRx7NRH/RFxC4mOALqiFvOnhghyO8vnKX6smbIFwedFXG5U/3aPrkQIOxTqIIRxdaKvDT8j5Bjhvjf9spL22HsMlGntMH85lQFp0CSGbGWr1QexdxTcjbLEXzi7tcROZRS0BpehCUIF7RYpe/0QT4lnNSjc/ZnlGF2azpem//6VjZNHBmZL8vvkccPrMhGygoj4JQBBxueT7ZDbcZ+bMbcW4T6m7UfcQT8BbJFiDbEAtHSPXLxguof+mM0cpW62WVidXWTMHzIgnFFnc7xIC3tAZfeJjXFO8l47OuD7laRlqO7B2a3nanEC1sWB1vtZxodplN4q
 o9v0nInC
 mJOeeOJAHObb6jjxiGgO6XKdfozQgnhNAxvCcu1j8YadGC841/mme1NDNgvSrXXStB8BgmGDDQia4vxU9ghJhSeklFeG2U9OouD4ig2KMNxj6TBVjY9OmBtzJqTUSOBQhNBUyZtfEOqz09mV+gk1vSCw+YZXCxHJCRlUBwf46Dfc8445toR7sgH8Y6XihBCFYRfY7WCK+2KjmyrX5u1VlwCIvib8iSh9+Fj0sm9RMsFKrllcs575zgkxj1WePUOTvFOfKzlYPrYDt5PFvNf/oLihzi1GNEHortD1PcdrKz3BiBFcZ3xttYZqHmSgM75SlFJZoGS2bX5zAYbg+IOBQVZKp1qYfnYc+65+Mtc1B/Hxvy+xolbwB/n/kLDUrnE+PtdwZl5/NiwqQfbnLBqn6CKd6wKPWT/b3/cafbBrTqigZI/e4cGowRKq8PxnpMywpR0u74ubfmIKMs1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zone_absent_pages_in_node() returns 0 when the zone is empty and
otherwise calls __absent_pages_in_range(), which already returns 0 for
an empty range.

So remove it and call __absent_pages_in_range() directly.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index d87166a36ee8..1ead4d694099 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1192,22 +1192,9 @@ unsigned long __init absent_pages_in_range(unsigned long start_pfn,
 	return __absent_pages_in_range(MAX_NUMNODES, start_pfn, end_pfn);
 }
 
-/* Return the number of page frames in holes in a zone on a node */
-static unsigned long __init zone_absent_pages_in_node(int nid,
-					unsigned long zone_type,
-					unsigned long zone_start_pfn,
-					unsigned long zone_end_pfn)
-{
-	/* zone is empty, we don't have any absent pages */
-	if (zone_start_pfn == zone_end_pfn)
-		return 0;
-
-	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
-}
-
 /*
  * Return the number of pages a zone spans in a node, including holes
- * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
+ * present_pages = zone_spanned_pages_in_node() - __absent_pages_in_range()
  */
 static unsigned long __init zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -1297,9 +1284,8 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						     node_end_pfn,
 						     &zone_start_pfn,
 						     &zone_end_pfn);
-		absent = zone_absent_pages_in_node(pgdat->node_id, i,
-						   zone_start_pfn,
-						   zone_end_pfn);
+		absent = __absent_pages_in_range(pgdat->node_id, zone_start_pfn,
+						 zone_end_pfn);
 
 		real_size = spanned - absent;
 
-- 
2.43.0


