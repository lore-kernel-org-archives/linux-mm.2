Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B7FC5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4276B0313; Fri, 14 Aug 2026 09:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174596B0315; Fri, 14 Aug 2026 09:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94436B0317; Fri, 14 Aug 2026 09:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B55AA6B0313
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:38:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 333DDC0112
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:38:05 +0000 (UTC)
X-FDA: 85099978530.25.3F01AAC
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BD53A0004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:38:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VeXiGjVP;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786714683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JI2/0itjYyHQxm0VbGunPbHPq2EnTmm4Qfz9jXF5j54=;
	b=KM6Xdxs7IwK3fCMk8ddglBC1WCSP2r+eyjPzMKfvX1+fy/3TQS12/Mbt6880dCRBJawvj3
	WGO4D9oK60MrwIR5hdXcus+apb1PHiVY8tY8/fepz6KYdB23fmU8RlmJvufBBwE+nbo6ev
	VR0enA8sVunbloqd3VNFs6hk1i4MnyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786714683;
	b=fWNfiHKp2YT+IPxOq5RJWM/LMhDfecA55xX2LLc0PdfcRgG/dMwDouHkkKMdX1pAKk3Pnm
	qLa2P4KJLUdzhDUMvVZTvI/epHgSgKF2XZQ75ZI/7pmZ+ax3jCDVLO9PmyDKwlNOVnmhGN
	m40e769PBjvh007u2RIHoFjHHqUTMUs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VeXiGjVP;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d02b4c3601so12136525ad.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786714682; x=1787319482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JI2/0itjYyHQxm0VbGunPbHPq2EnTmm4Qfz9jXF5j54=;
        b=VeXiGjVP8nfebayh5GTMI5J4s8AA5ndg/M/bXlXsV1nGkuIBFstWS2di85dRNDIc7N
         nvra0a3HLrvB+1WKvRr4hzup6qRkJO7a9YojK4vVk1O3y7Fo4NZqcXBu/WIZ/1POF0eW
         SemKpOX4rgaPVBnuGt2VgXfZ6eWfLKjysrvnuNvbSahtzjkK5AC1c3aHV4tTeG06zacV
         3e/d2w9A6vvuB8ERtDcuI6IjlCRnj67GO5G7p8S37ibl9zLybe13LE2u+TEX7ebDH+yr
         hdE69GVxE3RMSEoZgGfs0Ib4GrSX6vVl05Ze3FIQg+ovOWZU4ZWCs93gnUgwA8R/lxYa
         mE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714682; x=1787319482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JI2/0itjYyHQxm0VbGunPbHPq2EnTmm4Qfz9jXF5j54=;
        b=HdKck0TYMllk8w14u3xHanakz3W636ciPBY3LUA9MQB2Y6oQnlNht0ZlZy52Bl7lxt
         NY3/AvNsjtM9nZHLZOv4Ndpz11UpmJlP6437YOOuekzcUCXa/UvP8VQCnW/qQ4yvpUk7
         U/1HOUsIYifBtJmpcjOE0Mya1EJzyXUCkNMhSyDuzQOBkqEgITRxyC9NE1qTVAjYTIZ7
         F+yVpyYnqw+0tgR0aTMtD0lKOpDdIDLLK/4gmxHC7lLmT79Yl9gzzem/8TDyMr3WAqZL
         ps6WFuSFAXF+vhOC9Zr2FnWnrgdPXaLKRWnIGyUDgacOXCydfyyEOX5lVsrceo+TJhtM
         ETSw==
X-Forwarded-Encrypted: i=1; AHgh+RozB0weUl/8+2n4wT6s/dQbh79SDYZY6yL0yqUAkVygRbq9DUwHZ448ntHz/E80HzO1RDtgUqhzpg==@kvack.org
X-Gm-Message-State: AOJu0YzGnCmnmXVlF6dKQBmwwU+Sdnec8XErw4ncOTBgGLRlax2Ns6gb
	EabAwkn/Q9zc5aPmHwOfC1xB97eENl8flx9lHr1x0KjNxoRSjx0HL3uw
X-Gm-Gg: AR+sD10zn/zDm4D+5f8cCG7aDYlzrvKbFsUbaZtoaSXlYgqkZRgCGiPDjYYuFWi+6xw
	aHwB+NYdpu2qzhAtqT5CmKmVBZWB/O0H00WTyPq6DlJZsR5jakJSGU1f8DpzySZUC3EY6lxpdXP
	pwfP2QEfeGpYvzEeLfLZDixRIB8D/QLviNaZFszjGrErCSA+Ap42MXBmsN2RDTdK9u6yEbac0/z
	7eJR4yMSzh9MbFrUgZ7vlKFNo/uhY6vviaTVt7QFLtTj3B/kSV1JFLiH0bEqAGwvgYVNdp0WZej
	tuq39y82Dr52/fG0P2ShhJBH2beW20/3p954ElMkyxC8PA5xhvI8d2Ml0n6eVBX9XnLTm8JOAQt
	Ne+c6fUSuxiNyw/gCeoTHZtNbBkV70xjTCzmr5/DkYG0sIqjfDodlk+UdUXs2gwvtCFebHBjRSf
	3pLyq3hBdbPDNe/e4bRb9vA2LukKATGrtKt5UgHjZkRoaAIwiHUPVe+KbFxKPs
X-Received: by 2002:a17:902:da92:b0:2cf:9f0b:b562 with SMTP id d9443c01a7336-2d3b0cf922amr67460265ad.22.1786714682061;
        Fri, 14 Aug 2026 06:38:02 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3ae79f0cesm10029415ad.18.2026.08.14.06.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:38:01 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/2] mm/mm_init: simplify ZONE_MOVABLE branch in zone_spanned_pages_in_node()
Date: Fri, 14 Aug 2026 22:37:39 +0900
Message-ID: <20260814133744.2746782-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814133744.2746782-1-ekffu200098@gmail.com>
References: <20260814133744.2746782-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: su69d91jjh9rxcnw6qynmkimz6n7pimb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4BD53A0004
X-HE-Tag: 1786714683-338024
X-HE-Meta: U2FsdGVkX18mI1cVVnYQGgs131QTGP8PW2ej3teIeCjBdUEsyYG2CF0zquZbkVqcqMmbyTTy1lXO0u06bIpncqrfYb9XPNOMYtVK4Yq5Z8qQwQuXuGY2H1y4cgaPZVIfUh6PNoZNOCTlJGMSX8yFzCbUI7NRKkgpijm6AVyLtC96lsmg9vGFL58sveUUxYURRRasWhSejUYYDkoWcaU5c3eWhGlb6DjN9ZB7+qhAzTL1OwG7AUZz+3dT/OK+yCVbPEnLDJ21Ik3+GN3EOyuqruu1XICMEY0c2+Muj26LE/n6VsEZGs8ktCwIBak+kr6is3piQ5HzZx9bmojE0d4RVxkTPKzxh4cjEfbKNljMBVaK8XGXDrQW2MH3HQa1lYpPBCsqs2eNoeszbT/gG/HC9VIUOQhYmgUYONCLoGOjCvae49+UMq1dSw9Jg1oev2YyiEZW9wH12T4vyTc/Q0RA2jMSe5CH7XtyV1MH4EpF6dvc99QHfHMxtSZrBZyFLE1tLuYBrMHVov/oKiwoj7kw0AzwrDDLI5LvTNszryWC0nZ6XH5CZQ8asBfKQ/koIYV5ZhW5Tl//5blymDeNakj5BhZLWKgS9tD+JIL3IJLAb7rwY+a8i/wWW16QNIZDGj3kv0O4LpEiNN5X4lc5lOZrcTl5G+en00YoUtMlTAyBfrv8bER2n2hDEfJ5Opmx6Bc0vsNpBI/gCNPFsR0TTv0qrAryaSoRbJ6Nb5RmMNr/mBNNah1GgHvcPW2MiHbaPp9mwI0JaXkwLiR8qnjPRzBm9xFw4KNZyZ6LGEkXUcwQDO6s/bA3y9MjY3oD9/qdWSk93/BsXBlU2/2ZAvh8SRt+GTWJO04r8jlNdkWLljNR5GDA2ARBwU7I6+HHQ86Jpf7Dgn4m2U0peQOAUgqIW6ZbyIsvcpL6uEWZKSYxSHn96oUwxoAhMSJjCuB+qXpGMlfa8nMNp2LdU2hhzLcelEV
 VdxoLVgp
 nfkOGPnOUaVGwcMBF5/OJR76e9jz7GHpamuLd2v5/iKWi9srt1f+3wYxlBLRJMh3HtltMxq0v58yWGwalswGnbwkHYIh2Yfy7PMFKIS98mFep+aRcat6eTUA6sXAM4XOzRf29DQQpXgBEwUnRd+OxEtsMCzlql9zV8pOQDSS+vt0PKTB6i1b5vYcpV+qWFri2OMbeFDz0PYoYguyZC/xxiUEEOmYdyyWi7sz5JH7Kz1F3XUc0b3MBwrQa3eBbjdbQJnnvsQh2EEDi/e8yMhWDok+iD6xeNLNhV0DClRu7jJVomOKpjN73E6X1m98xzsJMaup3Dp7gNJtodp6vvnsgHJvQQwEotZ9cYjttmOVeOPXgokQwSu60LwsKYTJQmeSyIPmNHaFkWVLi8rARc56alAWRP0oAp1D4wjK5XiLroD7Hurcm61B4gC94tLx8vnB18godB9N+obxZU+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

*zone_start_pfn and *zone_end_pfn are first assigned
clamp(node_start_pfn, zone_low, zone_high) and clamp(node_end_pfn,
zone_low, zone_high).

If movable_pfn != 0, the branches adjust them as follows.

1. If zone_type == ZONE_MOVABLE, *zone_start_pfn = movable_pfn, which
   can be outside the node, and *zone_end_pfn =
   min(node_end_pfn, ...), which is at most node_end_pfn.

2. Else If *zone_start_pfn < movable_pfn < *zone_end_pfn,
   *zone_end_pfn = movable_pfn.

3. Else If *zone_start_pfn >= movable_pfn, *zone_start_pfn =
   *zone_end_pfn.

4. Else *zone_start_pfn < movable_pfn && *zone_end_pfn <= movable_pfn,
   and nothing is assigned.

If node_end_pfn < zone_low or node_start_pfn > zone_high,
*zone_start_pfn and *zone_end_pfn are both zone_low or both
zone_high, outside the node.

Then case 2 cannot apply, in case 3 *zone_start_pfn = *zone_end_pfn,
which is that same pfn, and in case 4 nothing is assigned. So the
check against node_start_pfn and node_end_pfn returns 0 early.

Otherwise node_start_pfn <= *zone_start_pfn <= *zone_end_pfn <=
node_end_pfn.

Then in case 2 *zone_end_pfn = movable_pfn, in case 3
*zone_start_pfn = *zone_end_pfn, and in case 4 nothing is assigned.
So *zone_start_pfn and *zone_end_pfn stay within the node, the check
does not return 0, and min(*zone_end_pfn, node_end_pfn) and
max(*zone_start_pfn, node_start_pfn) change nothing.

So the check, min(*zone_end_pfn, node_end_pfn), and
max(*zone_start_pfn, node_start_pfn) only have an effect in case 1.

Also, cases 2 and 4 both have *zone_start_pfn < movable_pfn, and
min(*zone_end_pfn, movable_pfn) is movable_pfn in case 2 and
*zone_end_pfn in case 4. So the two cases can be merged into one
branch and case 3 becomes its else.

So remove *zone_end_pfn = min(*zone_end_pfn, node_end_pfn), move the
check and *zone_start_pfn = max(*zone_start_pfn, node_start_pfn)
inside the ZONE_MOVABLE branch, and merge cases 2 and 4 with
*zone_end_pfn = min(*zone_end_pfn, movable_pfn).

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index df67d4e6f646..ab445111a846 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1208,25 +1208,24 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 		*zone_end_pfn = min(node_end_pfn,
 			arch_zone_highest_possible_pfn[movable_zone]);
 
-	/* Adjust for ZONE_MOVABLE starting within this range */
-	} else if (*zone_start_pfn < movable_pfn &&
-		   *zone_end_pfn > movable_pfn) {
-		*zone_end_pfn = movable_pfn;
+		/* Check that this node has pages within the zone's required range */
+		if (*zone_end_pfn < node_start_pfn ||
+		    *zone_start_pfn > node_end_pfn)
+			return 0;
 
-	/* Check if this whole range is within ZONE_MOVABLE */
-	} else if (*zone_start_pfn >= movable_pfn) {
+		/* Move the zone start inside the node if necessary */
+		*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
+
+	/* This range starts below ZONE_MOVABLE */
+	} else if (*zone_start_pfn < movable_pfn) {
+		*zone_end_pfn = min(*zone_end_pfn, movable_pfn);
+
+	/* This whole range is within ZONE_MOVABLE */
+	} else {
 		*zone_start_pfn = *zone_end_pfn;
 	}
 
 out:
-	/* Check that this node has pages within the zone's required range */
-	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
-		return 0;
-
-	/* Move the zone boundaries inside the node if necessary */
-	*zone_end_pfn = min(*zone_end_pfn, node_end_pfn);
-	*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
-
 	/* Return the spanned pages */
 	return *zone_end_pfn - *zone_start_pfn;
 }
-- 
2.43.0


