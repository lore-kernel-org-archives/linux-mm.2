Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD844C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D456B011C; Tue,  4 Aug 2026 10:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B752D6B011E; Tue,  4 Aug 2026 10:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1BD6B011F; Tue,  4 Aug 2026 10:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6A16B011C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:48:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88EA1801F3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:30 +0000 (UTC)
X-FDA: 85063867980.17.D867CAE
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id B5B7D20008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lJlu9kVj;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3Ke7fxV17DzCzcHb24D2luZMqAekIqqLL/76GU6lPQ=;
	b=aUm4wwCnN88sfoLxY1mH0GEEK66HixAwVQE80ATvJ24VNkrfP+C44Ngw8sa1vFlH+rqBJg
	YEWnA3KZTaI76LhqlyJp40kTKYh+YyVLdvTOa7KjUTXZSjU0V8mlkdyhJNlexlSSFPclFg
	R7WKztPrcpg0Utwj4z3bASmggP4QHiQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lJlu9kVj;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854908;
	b=jRgicknmEVLPBD+Nsr/n276aA/4z0mfSVx0ICAroboytMcJvo1s3R3Um0yrX6SU8BBQ+ZS
	IurN8mkKp+I2l3PQa+qvNpMf2p2AO9sDesPBH8hEnphQ511eOLsKmtQ6KOSRjd6Mwq1OYP
	JqJOBBTg7QelZkfKryb7ssiadBSvTn8=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cbb973e6749so5279897a12.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785854908; x=1786459708; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y3Ke7fxV17DzCzcHb24D2luZMqAekIqqLL/76GU6lPQ=;
        b=lJlu9kVjMjPqz2a0zIGs0KL18MUD4DHvQViTi1JIZszvhODfr2qhQyevkFFZyt/sZB
         x4gXI1CTZf8WeIgRm3H5MLiI7d64Z9D+gd0Gy32e+JpEG0Yn8lKDsaHONQ7hCVHY5Inw
         ny0/MaWuthurdviy8nlzu27F1pPAAgDi2I4x1jP/arBgwZKzoJb5qY0CFPe1mjtfmlfI
         9i7/TDw/wvsNvKl79gH04fRbNKQbW4NYSf7nlX+J7oBQ5xAWpPLSIekuK+2/XYoIP2ke
         JEsMxij9jgGgI3h1ih4OQMWDgQNz8fkbfW76gmMDTNDM9MSIdgu+i1YxDRzA9fllvhVe
         ZMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785854908; x=1786459708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y3Ke7fxV17DzCzcHb24D2luZMqAekIqqLL/76GU6lPQ=;
        b=QIq5jEZH1EQWYDij9sJIRljZgF0m7OuO27BtGlHJbzmdc5sOYPQvdL8MmJq6/ghoKu
         GccXbAyXaPkBv/zRrxUwgGxrfCMGAcJItpAc1GYb9rshq0f+s4zCbzfxSBDvmh6gBCCN
         qa2sfYe12KP8Qbuzy8t3unnZehSKaXw7QhNtLaebmKtaUSPmLxh9w8eRd3BLgLpWZ4sO
         +qNqOg9StqaGmWJAiSrkatKUAUN7Sx726G4nuqlQnfXDKuQ4DQ2ysmYt87dEtoiIatVH
         KuMSU1kWdmplhsACXCxGNqNLOXqb5J29pt3SWHBn8tlsrcA3S3G2GcPXgJ6gX0TzxI8q
         fAeg==
X-Forwarded-Encrypted: i=1; AHgh+RqDaHF9IImitleQtNAsYrRcoqssnYgZWLlNJl2h/2MYI6g6eFU2l3PLdSXkRwXvqPLpzNcRSLnFfg==@kvack.org
X-Gm-Message-State: AOJu0YwcTbrKQZncmfU7i/d6Ne3fyOr/OKf4enj+AiUB0BXObMUrIPrb
	MnU4uPc67OFDclyVVjVlGUKq9ISEtsN94D9Ec6UvT/li+qWSLw7OdTGH
X-Gm-Gg: AR+sD13QeOKw6lyxFiSY9/rBaQc489aMT8djXWfaqUNTcBaW+zEyfixUX0tr0zTemX+
	OLKhEgybpEW1B3Lmp/9ZIjruCJFDSEFjr0D6LeM3o8MZBFPH2RqisCZPLUosVKoPiyLfnAmrbcr
	BohLLnmG7eyMZntCDzgMBgkzR7mgfawH4ZSj7IiurGx+pqwSE/bDaJFM2jvwVdXiGVzLUCXNIIx
	lrM5lKE2FpZTxVKWnG57kxSin5iAH3EJE/ONYxeRyyiqLuLzCUgRHhrjveNkZmWKDiGwwK7oR9L
	7lC502bhtGObyiTO1lCTFs9uQR8HBQ6rq5Vvw+IM7GE5aIIs6vicR1MWAbWZdx39oH5Spv1eNY0
	4vcqCPmGo0d6EwaK8UJzAY9Q7u0avplHfniSmBciHWtP8h6XgUoGNdlZkOcVTiAp/JXLUNGMAzv
	BskS838s1kAguWNtwXg0t7dtSC6AYmn4N/iZ5/s83f9rpHdoQ9dV+cCG0=
X-Received: by 2002:a17:903:4b30:b0:2c9:e9c4:82c1 with SMTP id d9443c01a7336-2d0523b7cfdmr156995145ad.26.1785854907551;
        Tue, 04 Aug 2026 07:48:27 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4930e1sm8784175ad.41.2026.08.04.07.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:48:27 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] mm/mm_init: move the range check and clamping inside ZONE_MOVABLE branch
Date: Tue,  4 Aug 2026 23:48:00 +0900
Message-ID: <20260804144803.3290255-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804144803.3290255-1-ekffu200098@gmail.com>
References: <20260804144803.3290255-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5B7D20008
X-Stat-Signature: rau7ab3nunq5p54fdydnypg4ixqxpaxg
X-HE-Tag: 1785854908-509352
X-HE-Meta: U2FsdGVkX18KXmy/McAwFwnLhxjYm6fp62cNk714vInvPOApqL52pgc7Y8D9WlH8THcX741Ys0d/psJsgkm6GHugYX3e2MemBHNEoKvPtl7S1nixkLqYGmftJV5KtxkA4H+8eeXjiL7n758itPnWdksq2sMWQx3JtM1Jo9mPhk2/Btb+V1+I1jlwMKqBrCwSwaFxRWnsn7cMUyT/baY+KdfoXlbHYv7t/SnBihR38RZgUtp2EGViz0FzZ2gZeVdSLL+62ghYNfdIjO/UlVbojAVEmFp8X+L45B7JWYRdYSTFRBU6BJ73WfU0D2/0EW+A/IVyN9xOjTku3sEC8bBeSA0fhzFYiufeJO/BPMrpq0sLxzAktzkvcSf6zD/fDh8ci1PLF/KkssmA1GxCyCtI/REsA0d+ao+/aMy6Cqdv9AA44MddqD2FzrBTS0bahOl3/F32Wqwz1TmRlUNF3IzmftUPb+0tVj86C1+JmDJ8G5SeouW6dPyXxA3gUJ0XXFObIEczT6ssqW5bsuzXor+sSNN7g7Gi9vnn1kTt3YUBVVXaAWvAQn+f2rxsBRhYFoaHI+GKWTbHvXsBU7fXFVJLRDpSQJ1hpmjjDRDknUFtEKVqh7S0gKy4dfk4/geF1Olw8CjzP6UJKDEuQKQQll5VppmB6dxAZpCHR5pNwMgMK05Gw94T7eDrBw2M8pQwTEnKbC4kE0b/nJ+etHuzOLLMs2G19OTA0TNYbszzxxTw7b1XCLID/yW2PVt9n+O/rremvY0/cTfr93sEu+UiCpsbp6b0Ytwgj8kSdq4EYPpQQcEzPQI+MEBZJF04z5UXC4QtQxHGbSmCbjwkY9uUn2HHJWRNlwsZCwP6VcZImBCtKKuhcAc3wYQyExfkim/qTuZEDSZUSpeklMFvo4Vqg/wLDeZVjOtIk8504z0nCynNliCaxLEpOuuVWzPiaNH1gqwSHWQ9trK02gMWuOc7M+t
 P1owpiF7
 bHaI+kSSFSr9zm12XGsylpYr/9ZZniuLr7lTZ6OWWkPGFSq3/+LwkzuFxAiPw2HZImP2wfq50dylivWKwSdW03Dw9/264UjVuJbTReC6qLOPQhfHmYEmcXVguLiyh1o9V/1WzcD7nNr8n/DmxP7LxmNpm2p7UUuLFoK/1XQKwLOihP9H5ObcckZW1tqPLcIH4XyGyendGlukSNxYCdZCKkXV5pcziml8l8ZxcZVQYuF5350MZcSz5JBi/TRLRors/fg9VrhbuXM7sr9fG0qZ1E1MyKgbkJXtyfXbda+AMyQvJuKM7gk4cgttQPdkIHLg98V8XcEpchVh+RCAm4KEb1bicTUVpwNvN6hpI1oTCuN3jHKGIUIc1Lv2LuI/iD0Oj54PunN1BdEsQFEGXuVy67etJ2dOBOuq2rmE8PKLoFyRNg/lH5VvSv5Ygt/1jEwFd3pGpo8XuNVmBkJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Outside the ZONE_MOVABLE branch the check and the clamping have no
effect, because every branch ends with one of the following.

 - *zone_start_pfn == *zone_end_pfn, so the function returns 0 anyway.

 - node_start_pfn <= *zone_start_pfn <= *zone_end_pfn <= node_end_pfn,
   so the check does not return 0 and max(*zone_start_pfn,
   node_start_pfn) is always *zone_start_pfn.

The branches set *zone_start_pfn and *zone_end_pfn as follows.

1. If zone_movable_pfn[nid] != 0 && zone_type == ZONE_MOVABLE,
   *zone_start_pfn = zone_movable_pfn[nid] and *zone_end_pfn =
   min(node_end_pfn, ...).

2. Else If zone_movable_pfn[nid] != 0 && !mirrored_kernelcore &&
   *zone_start_pfn < zone_movable_pfn[nid] < *zone_end_pfn,
   *zone_end_pfn = zone_movable_pfn[nid].

   The condition requires the clamped *zone_start_pfn and
   *zone_end_pfn to differ, which cannot happen when node_end_pfn <
   zone_low or node_start_pfn > zone_high.

   So *zone_start_pfn = max(node_start_pfn, zone_low) >=
   node_start_pfn, and zone_movable_pfn[nid] < clamped *zone_end_pfn =
   min(node_end_pfn, zone_high) <= node_end_pfn.

   So node_start_pfn <= *zone_start_pfn < *zone_end_pfn <=
   node_end_pfn.

3. Else If zone_movable_pfn[nid] != 0 && *zone_start_pfn >=
   zone_movable_pfn[nid], *zone_start_pfn = *zone_end_pfn.

4. Else *zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high)
   and *zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high)

   a. If node_end_pfn < zone_low, *zone_start_pfn = *zone_end_pfn =
      zone_low.

   b. If node_start_pfn > zone_high, *zone_start_pfn = *zone_end_pfn =
      zone_high.

   c. If node_end_pfn >= zone_low && node_start_pfn <= zone_high,
      node_start_pfn <= *zone_start_pfn <= *zone_end_pfn <=
      node_end_pfn.

So move both inside the ZONE_MOVABLE branch.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 75fe1918d4d4..1190a27ed0fb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1253,6 +1253,17 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 			*zone_end_pfn = min(node_end_pfn,
 				arch_zone_highest_possible_pfn[movable_zone]);
 
+			/*
+			 * Check that this node has pages within the
+			 * zone's required range
+			 */
+			if (*zone_end_pfn < node_start_pfn ||
+			    *zone_start_pfn > node_end_pfn)
+				return 0;
+
+			/* Move the zone start inside the node if necessary */
+			*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
+
 		/* Adjust for ZONE_MOVABLE starting within this range */
 		} else if (!mirrored_kernelcore &&
 			*zone_start_pfn < zone_movable_pfn[nid] &&
@@ -1264,13 +1275,6 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 			*zone_start_pfn = *zone_end_pfn;
 	}
 
-	/* Check that this node has pages within the zone's required range */
-	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
-		return 0;
-
-	/* Move the zone boundaries inside the node if necessary */
-	*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
-
 	/* Return the spanned pages */
 	return *zone_end_pfn - *zone_start_pfn;
 }
-- 
2.43.0


