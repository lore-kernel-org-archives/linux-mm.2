Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD48C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5D96B011A; Tue,  4 Aug 2026 10:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77DCC6B011C; Tue,  4 Aug 2026 10:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BD36B011D; Tue,  4 Aug 2026 10:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38B526B011A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:48:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA4011601BC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:28 +0000 (UTC)
X-FDA: 85063867896.30.9AE80A4
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id E26921C0016
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EoJbiZCo;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854906;
	b=awWMomSlBAPppaRh5xPfdA2VnX9PnC97SUKPf43BEfO2WPbICJ8Kkh3tjivjCHKLgbouFl
	YkZzvcBbkG2RK00PA7c4l6IsXM3JSjMI3+LlJ+NVT/AbXwNKgUzXRVhzi8W8uN11bEl/BO
	uq7gLwerFReynGhcdNOLemh/N9BhwBY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EoJbiZCo;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiCC+s/Zx5WFACy20HptmxuWHsFbxqBWby1onCkyR7M=;
	b=Bl5/MlKD9uc6V90VhxWkYQij5X6yqQX1a070FNwRBmEIOhWI56/iAg5k5dsDH/J+Im5O7D
	qagTXrylv/6ts+jUGKkMXk8VUQEgsBrBC2XIvsTIv+DKAwweDJD1ymFnXpPXMVEoYK9Hww
	QIrOqMKqFDNg5ASVGLaZtrmTbPjDRe0=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cbe3fed2f58so2800157a12.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785854906; x=1786459706; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BiCC+s/Zx5WFACy20HptmxuWHsFbxqBWby1onCkyR7M=;
        b=EoJbiZCovlr/lidHlnXYLyUVQaQVdFHwAK/QdUw/D5wL9Xw/srgz7Me1N3gekkFfdV
         c32AfH38YWGY/XhJEcd14RanMezhEbzdnOyvaOpUnPWc2ifXALmSqnPUDegEemqADdWw
         ahnXsLsc+e0xcgZEJwM40SMJ+X1TCTZ0xxRLPs5zxyHdJFVvDzVeGGaKdWLXVcHRUmlK
         te5OWwjofe0N6vqX45HoJ1+wurdA6NdN40Wsm2AiDeocaP/N7A3mL0GNcIP5e5fPfHDh
         r/s3s4SUBvACW8Kqb6ABNvWf/2dassFZO8t0O+Xm5UQYSLJl71r6hEdRcLY98LK827vi
         XgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785854906; x=1786459706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BiCC+s/Zx5WFACy20HptmxuWHsFbxqBWby1onCkyR7M=;
        b=BqBr+awhoxSEPzj8VcxZSdEMd4DI3C7mg7GssE5c7OrTf23t4jMngkIZF0gcngSwyZ
         UOkOIFl5w2B53upjHu22W0uy5hhksyqDbm3PUH3QnIfR/8IcGbPQY2BLmOOCaeglrTpg
         ZULLmXs8sj21F54NFZQFBjY+U5wnZ+pk2YGWhAPKNGxml7oun6pdYSFzkGoQGZv7gsti
         c5Z7H6Zeu1+RcNlcNanv2drBudCXIwxziHcoggvvGkHcVvD51j0OCBpJsEqNZ3c0/Sh7
         t0x5g4X1eAq4tEaUynBX0QBY2spGJuuG154q5PnWMZFLDLBsb0tYobQfAk/kcLNJVI0s
         Gv3A==
X-Forwarded-Encrypted: i=1; AHgh+RrI0aWq8VCu3hH/KwW2F/6PY74jfI9YKioMy3j+2N734ARcJaugTt+YgAoFc6aGAoUL4TOPjhpXdw==@kvack.org
X-Gm-Message-State: AOJu0YwRF9i4v8ycYSVPBOOlRfREFYK0DXFkof1zlpUNKWTkZNL8frBc
	5Rh/KRpnfiun6zYfgFVjGvu+j38R/xwZ8tyWRjcmF8aPGOah+U9gAWwd
X-Gm-Gg: AR+sD11o/RsO9jH0otsmUK+rLqeLntI3/laeSibHasQBqiK+OdtC29iX1J+9w64ahTJ
	8sfMLoE6AGvJENbA99JJims2EOBj+npoGRVF9+JsuxNTIaSAfPeMKuPOhNGUt68ILHAOUm+2HMw
	2uWpcoEFfG8VI3vLSBWkAg2dByajYBNRTHhqQeVaspB1AdqCTxybYaKnOs2gpf/RHtQHf8mQ+6b
	rbvzpJcvmGnPltj4lwBlJKCtiM7043x4iLQ7Pszebnuw3g/hihFIV7ItIlyX3BGQeltRtl55GdT
	PWlkepBrdWtWmEoeY7domxsN80Nrmyrvyq4ioyCVOon8AFBpNglry1648SOP5UiqvHbzfv6MQPi
	3VKzZ6hSNwjta/UE5EgXhe9xQjQPisJfOdou0fwBeX0oRFMwIwgVcpS9zvKc/UMZ6DeKI3QiqOv
	zsmyhqxp0A5MloZ6lPUZZn+3wkWZHLDj7dSU7ke1oGdthkORzpK3KE28U=
X-Received: by 2002:a17:903:3201:b0:2ce:f9db:a9e0 with SMTP id d9443c01a7336-2d052283697mr156921155ad.16.1785854905679;
        Tue, 04 Aug 2026 07:48:25 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4930e1sm8784175ad.41.2026.08.04.07.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:48:25 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm/mm_init: remove redundant clamping in zone_spanned_pages_in_node()
Date: Tue,  4 Aug 2026 23:47:59 +0900
Message-ID: <20260804144803.3290255-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804144803.3290255-1-ekffu200098@gmail.com>
References: <20260804144803.3290255-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E26921C0016
X-Stat-Signature: kqgds1g1ts763nhr3m4yhz6mw1r4inmk
X-Rspam-User: 
X-HE-Tag: 1785854906-679956
X-HE-Meta: U2FsdGVkX1+mhn57B7TS+dftRtMOmfVirMcjQlwItNAOZ3jH9wV50vEebnOD+0cAULK8w3m8Hc3k3fFsDamVhln+5BDAaNTM/mu0Qv8Q9wETy5/6uJct+jfRbwEuxrMBSKT26iOzPyHUDAxDitIlAbqbQK3Js1SnPDZgv6OHCOIrn/WEIAvO4OD3VsTqTOSJjLaO1fZFnOxSVrUz5Tji+xTP0ZBPwfzi6Dp00lEjxh/PgSnLMrrA2voUGRib4sjRr9AQKeHdnSITknHdZF9a+Ov0skDFNTy10C51eWyvU90BdKs/ZKYKyU8I71sPwp+AGN3iXKbSN9h/VMRP2bRL3tkXPYn/hpCjCWseyipC52sYsP3vQ8t0o2CCJps/g/rbXZqoDjzmL3ZGRM0WaObyo5zRAbXO21warI5LVQpcz3Vk1cp625foZqp+zOdMQIkWmP+kxJtu51jZEJbl8KDjI6CkZ44jiffWFUxm8GwWzb8XCe98v8MTFIwemIoToRZiL4u/SCdxmVlHrLox3+o9vVe++5HH5+RmOkZO5JJEhD/KHRpBSvt5BqS21bYD5GzUDBT0pMCxhOagS2FmGauqEEFlbkiPBGkmdjgomVSrWq+MyjgibNUa2PlTlKP9+4MQzU5iHqCP6uPARyOSxFFoNjRzKLBHUwkqYJNz6J2+LxPlLTu2eKLxPRd2zHMz1ODtM6wrlTHkaagtdeZrAE+bbq2EVZEb3YONdJ6N5drM14Hy5GHW4scZE5k/wx/IBPYhoCY8rn09lrubjVFaR66gpnPAj+mF+F41Kz8VXjEjK9F3M4CBdu5lF4WbYqYcs2SSRS7HNiVoPn5w143EA94pKurypmGGhtPAREoCnVq2nUIB027T9hl3i1LIiZXa7zUBuRg969xbfVyJFTPdTu3hVWthzRftP9kVcms2dI/n3b10hjlzWWjhy1DZJiqYm15N3XdhmoQ6WwNb09vj1Ng
 RU+iX/6+
 6GZAm5VlipMdDzC84P8NDtv9nZMLZW20Si5clvZB/P3+jGXLG/umd+chTMfa786isikxN3m2acnDeIkgpgasmFJD2e17EuDo1NAW+pdN1ykW0mw1KG3MbfLYa5RfeCB5HwIvtXaO/PX7H+WtT4LUZJP3ewbFHOjTwTN1clTvI9S06wGpNoNN+WVi34NMEb7Xbi+1CJPkuf46k/sjCDsRJGr+E/OtciRoNgxzfSGX1OHAtaOBs5UzvLclQZQ9yzX0cAG8Y8mioPyty0MdgeAOfZiyOstPS38/YoUZuAmQLcPLdTLJl2vdOxphQ0WMzQj621XftZ5W+8bzAHC4WNbUe5FDQ6SJoHzjhIsnV4DOKkrfAV1lYk+6/Bsoqn2hr2FIuc8hMSum5nuQnHP7Jx6Ug1QXKz4YCJMIVrgR+nvd6oA7QDo5ZUu217fv9FpcV1Me+UgoW83uUHQLMwIE=
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

2. Else If zone_movable_pfn[nid] != 0 && !mirrored_kernelcore &&
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
 mm/mm_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index ddff06467239..75fe1918d4d4 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1269,7 +1269,6 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 		return 0;
 
 	/* Move the zone boundaries inside the node if necessary */
-	*zone_end_pfn = min(*zone_end_pfn, node_end_pfn);
 	*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
 
 	/* Return the spanned pages */
-- 
2.43.0


