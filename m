Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21851C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CC66B0099; Thu,  6 Aug 2026 12:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8BE6B009B; Thu,  6 Aug 2026 12:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5586B009D; Thu,  6 Aug 2026 12:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9D846B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:21:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61E84C0136
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:34 +0000 (UTC)
X-FDA: 85071360108.13.76FDCB1
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B5A11C0007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qCWUcmc9;
	spf=pass (imf21.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nnHRaA/5R5s9aZOS569tdN3FNz3hlxbEkvfjm317fS4=;
	b=yHd9uABgn9zo5KZT4M12htVSFQgjAi/hmKlG6dKIAsdHNFhqQaGwfRwxIXsK+W0Sc/Fgza
	Vosj1/rSvOPqAdl+rtMfnfl7Lc5LGJQf/pvLE2VpfHX/Pw8qhb68PlLv+B2hzvuwZZ7P2v
	jWI7C0WxFxOIvL0iN6X3jrEVyQCdapw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qCWUcmc9;
	spf=pass (imf21.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033292;
	b=o4I2kVHi1YMFi/1JeS/Z+Le1D83oJTuSxGNG182IOJZ38fkJDE1N404Cdda0mHC1lxj08J
	6S3PldPQ5BA5uUNZNnT7joV19RXn8yD3UvLG6ZOCGsNjDjqrmW2yhQcurONQz3JJlP5lYn
	CR9t8tg+CQ1sHw8X59IKbyEeI0QMzFY=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84874b52eabso3356979b3a.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 09:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786033291; x=1786638091; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nnHRaA/5R5s9aZOS569tdN3FNz3hlxbEkvfjm317fS4=;
        b=qCWUcmc9RGHyf3AwxIXxKYn37do5m3lgyGsxmCUv7hs73dH7awsiZcAypCU/WSneC3
         wt7jnumI0A2VeNK7wm31x6psbE3CacWtGGkiUQR+XWGmTpoyeekVqV1rCD1Dr/zMcXJW
         Y75YUQhY6PZY8ddUWLXsK8AEzHcQ84uuLrHbd6M35N44iG1oX316imHCUjpIOU7x2XKS
         g6BSk3fPANfbjQTgBJ66TjK1LGMz9esBL+PYjjCPes8/D3QUuenmowbLX551GKEtghX5
         LcWEfvqx/LZeakoIrzMojudVsIC0fjOK0bWQfImRLvTZeXGXU94vzaB/NvX8SMzpFaFf
         zGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786033291; x=1786638091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nnHRaA/5R5s9aZOS569tdN3FNz3hlxbEkvfjm317fS4=;
        b=MTtJBh1JJn4GRVjbfuXJ16/atm2BLepEaKdKlwuT9/to0NZn6cYCdn+1HtoHa/inuE
         pNKSnxZDpJ+LIVzGkp4r8s3Qb6VgHX+t5NcglP8t0YxKJup9dUUrAgguspL2U5M+nbKI
         jUhyyhpy3JUPAccIW5JcFyK30CKobo6idUS0gUa9nqwipWD06n1UskfwWX2f4XA7HViQ
         VxdWEWBFS2O5duc9bfAV3hOQiAUdMEGGm/hLLzyxEtb+4xeXXAGQLB36mdR4+FMit3Zb
         fkUu0Nr/oRTqOVnc3UiblzW8BfcD1CFyC5rRF80mTfRtndJTHYCX2TZRPgf0Vy5crPS5
         nVxA==
X-Forwarded-Encrypted: i=1; AHgh+RqLBbxSwNqnUKL68pLoJ0G94PocUMqlyO7iBlI7rO+s9iFwb74uXfyfFw1Sw6ZvWmiLhKqENumr4g==@kvack.org
X-Gm-Message-State: AOJu0YxQ4XghiPukKM2t+zMFLP5QGgdIJgWvPyD139XKV1J5p0/nBAaw
	7CYQvk5thXZSsIECYGnTSbvKHKVgp2Z+Mz5TzCyUQtitc5ocrJ8otxEEGLu59deq
X-Gm-Gg: AR+sD13gi0v3QNps8J6IBK/NRhIzn8PH1djQWffbHdU5tNRzivXzWpzQk469vtv3Jk4
	ytUs+yErIf8HO+GQCBHOotCVerdgGxEdp65Bm7Fc4IRy9ceiGdU2QDyUvrCEEYsl4vBTKX07hPK
	kIp6nAuBLRTUNC8WU+X4dKe+4YZ2Dg5kpOUqS4tuMRrBEQivcnUD8s+3ScnpBXKBX68QVfjiHxZ
	b4NzXv+VddFOwHyojk30W/mOV7reKoPBMM01Q3WcIQ1mv62AbnOGq8fi3WHWMUUuL/eyPTl8qG8
	xqlr1BFRItFUxk+GEAo7+Rb5b/esIZSER3BP1u5ZflkWMC8g2L6VOuw0COpStG3BTe18/yzamEO
	6NkaDrcGwxM97i3lpk8CuvJjDGwTYgjtmL9VuD0CmhTxraE5QTdev6qHMbTCFFjww/QlCw6vVzm
	9hwLiggpxQA4fgvbJ4AlGOPn8oS84+Tv+I2a/YV8ebmjWesVecZVv46Xw=
X-Received: by 2002:aa7:88d2:0:b0:847:8650:69cd with SMTP id d2e1a72fcca58-84f2e0eda51mr16720422b3a.33.1786033291353;
        Thu, 06 Aug 2026 09:21:31 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f459b66e6sm1662739b3a.40.2026.08.06.09.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:21:30 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 5/5] mm/mm_init: clean up zone_spanned_pages_in_node()
Date: Fri,  7 Aug 2026 01:20:56 +0900
Message-ID: <20260806162100.313965-6-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806162100.313965-1-ekffu200098@gmail.com>
References: <20260806162100.313965-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B5A11C0007
X-Stat-Signature: k67eahuss3fma8zw47muofugchy9ozee
X-HE-Tag: 1786033292-123062
X-HE-Meta: U2FsdGVkX19zKHuwU/cn0f7kMscmpl6Pj37Z9+Ghu7DX0YpouvQjS5a1PzGAg+c/YmZ4uUrRedMCvPMor/XyfvuE0KX3zLgLwtT9UcJ2J36H0sYAuHqn3aT9VUveBse8UHx6vyfzLMaMnTbjiPqjXwZJT7pksF+6vg9+7e7wblflIAsjrM64Pf2OXsbgNu6lfLwpRow9vPsm5/8lK+3BBBYEewRSZT4k5b5+Lfp7KFIov/TMG4rXa5TNzUGLSJYWCKAKK4aBdkPFf8q3GLvPnTRl9zThEUW7shHw6SGSs0qYvCjJgzXjtkg6HHTbHUIXuiRue+kVHNiSig7IVDhRZVG6DyqJmZkaIz5EZp1DWACCoK/rwKwWkHAAJYcd9FKuqZGSCAW3nQAVrETH4nSr9oMiN8a4rtFUn99e17uQxv6QERG/jZ7yiZVg1f9D8jkujj/gpjUMW3jaJXezXX+sNuJ6ryZjoCZnNkTxIR0+lfyqI9Fr10JJu9IvWaOxEOR/jGjmB2FQdYbQxnptsGgM6i2vVAgY3KSIpfnJ9ka4pDR4oxFG2UxJK9FiiuWPNSFflOCssjNYbVmyCWBBvQraZCP5RGxDObYiEoAFIWHJuVMZ2VbavIz8sI2OK4ud9/4wthLs7J3KkXfRiLEqJlcSIKEBz4dF3cehYvSeBNgpJhEf9IK2i0ipiQf4N4q5hfURuw+csQC80cTBQfkVmwEq3xup7zfOWVya3e70fcUNwpNR3kPCDvkedtyRuNq4mJUUGqgLTYRDkHvEBB9IwW/GeI4/5BnAM3sLpXyCWvpwWXwtz5zCTm8QUG/Sv6u4RdU6il0OEaPyvohnE4QCwv4ziZhvkx68Zu9ItGnphldl1Ie4sRHDyX1sV/rEbkiXVUZ0H85/XkYnlfJg3SSTJ1tcSziF4ZuXqh0UrI/CbSLomAV7/XvQMv46bIsIaV8tacl77Jca43MC86Xcm8XgBK3
 YMhr21b3
 PA+tKqHTvQGFwo5Mv730Xg25tkpL9efSFqHPZPln+ru5+8OT96ORzZ/hmgXsF8I59T4WOsZJl3mrDgditEYAMHqt+yCRbc9O33hdLimjjWw0X+MqumqobP2/913/8DH2IJQ/fWjzPC8IjBxz5XRSns0Fl49sP2Sf9RRliHILbVW+joN7rNZcEu+2bmwxKNpa2dTB74XN+Unh2v28mz3584CgxpgVrPxNA3v2+w48rurYWFVHqUgKhhMKM8/VwWkPfbVv1h+E9BQ9X2patwD1FVv9QHlqrNHqVOgTRcWIyyCCNItEk9JRs8Uajtj8ZifTGH252Z4W/kJ5NS45i5mzQRxYVBAE2I8yqplfP6n2nZP+j3O7vIz8e0t33JFNCU660UsWq/MHVmp3CO0Jf+7pxJDmjJeSPxPTWKf7O2jLTYJ6+4/1ifQ0x0SB9HnzZN4p0O8o+4Z+qaWePmIg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract zone_movable_pfn[nid], which is used four times, into a local
variable, and return early to reduce the indentation level.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 27f454edbebb..ab445111a846 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1192,37 +1192,40 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
+	unsigned long movable_pfn = zone_movable_pfn[nid];
 
 	/* Get the start and end of the zone */
 	*zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	*zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
-	/* Only adjust if ZONE_MOVABLE is on this node */
-	if (zone_movable_pfn[nid]) {
-		/* Size ZONE_MOVABLE */
-		if (zone_type == ZONE_MOVABLE) {
-			*zone_start_pfn = zone_movable_pfn[nid];
-			*zone_end_pfn = min(node_end_pfn,
-				arch_zone_highest_possible_pfn[movable_zone]);
+	/* Nothing to adjust if ZONE_MOVABLE is not on this node */
+	if (!movable_pfn)
+		goto out;
 
-			/* Check that this node has pages within the zone's required range */
-			if (*zone_end_pfn < node_start_pfn ||
-			    *zone_start_pfn > node_end_pfn)
-				return 0;
+	/* Size ZONE_MOVABLE */
+	if (zone_type == ZONE_MOVABLE) {
+		*zone_start_pfn = movable_pfn;
+		*zone_end_pfn = min(node_end_pfn,
+			arch_zone_highest_possible_pfn[movable_zone]);
 
-			/* Move the zone start inside the node if necessary */
-			*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
+		/* Check that this node has pages within the zone's required range */
+		if (*zone_end_pfn < node_start_pfn ||
+		    *zone_start_pfn > node_end_pfn)
+			return 0;
 
-		/* This range starts below ZONE_MOVABLE */
-		} else if (*zone_start_pfn < zone_movable_pfn[nid]) {
-			*zone_end_pfn = min(*zone_end_pfn, zone_movable_pfn[nid]);
+		/* Move the zone start inside the node if necessary */
+		*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
 
-		/* This whole range is within ZONE_MOVABLE */
-		} else {
-			*zone_start_pfn = *zone_end_pfn;
-		}
+	/* This range starts below ZONE_MOVABLE */
+	} else if (*zone_start_pfn < movable_pfn) {
+		*zone_end_pfn = min(*zone_end_pfn, movable_pfn);
+
+	/* This whole range is within ZONE_MOVABLE */
+	} else {
+		*zone_start_pfn = *zone_end_pfn;
 	}
 
+out:
 	/* Return the spanned pages */
 	return *zone_end_pfn - *zone_start_pfn;
 }
-- 
2.43.0


