Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAEFFC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87BE6B0096; Tue, 15 Sep 2026 11:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39406B0098; Tue, 15 Sep 2026 11:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FFF6B0099; Tue, 15 Sep 2026 11:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC126B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:02:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81563A5694
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:02:31 +0000 (UTC)
X-FDA: 85216312902.29.638C85B
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3280C0014
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:02:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+FpntkJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+FpntkJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484549;
	b=R22nz9r516RZj3G3cmI7Tm0QWfTEJqS0ZEe1pqdYO53hF4clDQws01ipzMq4YZSJ8VjKM1
	yAu/pXaUmTLxGWgQeuPHs49NpAWB8oSHu/NaIzYpPxx23M95Axj9eNd2da3/fcpTczq1eT
	irIZ55666gDudJy8DO0M0qe2i3WjHMg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C/28T5laAAyTxLf1Yirs20VIa2oTd4s5Q0872s7X3RU=;
	b=Y0aZVAyHB5FaTVBCiroXC7d3O24/vDE5Z2XgVQ6/ua4crFG71l89sKKGc476yweOKfK7dB
	GL9NKw7f/vUlOzmNka+qO9d/9baDQa7FxHrRE0jnOhukDE19MrO3R6MDAIHDk34NVaGmTI
	UF/WF0pAZoXKnaQoeAf/892t+pzmlAw=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469e211a0so3116022b3a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789484548; x=1790089348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C/28T5laAAyTxLf1Yirs20VIa2oTd4s5Q0872s7X3RU=;
        b=J+FpntkJPCGbeiedFXDRnizi2PAZG7V0ROF/kj8P5SaNJjAeR4TJjegcV4NfX90qVG
         fux+dWUWd/ON8LByj+c4c9R+3e6MpRta2ECXQj1dPEmj03vDRhl+AdTEVHwtra//KQib
         zwJVxLPMQm8Z6JV5wzAZK3GTEIpPX3xKvpnSAA0u7weScXsIi9QEiVN3XJxjHEovZuA7
         QdT6aJdtawsOOkRmJZ2DXPUU27nobXl8rzViXCH9QfvCyQJYuvUValmlvMyy3wtwQ8ZM
         SfzfMVMnQitEqd/Kh0+uLyBtiGe9sxgTahgRz6k8bEvmCgU63xL8z+t0VseXL8QX/GAR
         gg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789484548; x=1790089348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C/28T5laAAyTxLf1Yirs20VIa2oTd4s5Q0872s7X3RU=;
        b=jmxmqvFYuUWjVEq5csZd245AXPVZC0iPWSLM1AMqE1LpGmqfOB8JcQSPZB4K0//AGz
         1rcJNOgwPePpFTS2y3j4e/JwgGHOZm0ARfHo287+wIRwu/oLN+J/88RyvfINWxhI6Ub6
         ZbJtiDx89u5zoRcTCz0OrTnPjgneNuZwGys3m4htP0e88bGjL40UQ0ZSw9I2SMjm3C2m
         /yA1a587uW4fvsKdXqRFCwOb1ubG721qSFrIPamGmZatluW7aLYclwlkRndtYOdPPo4O
         vWTkftOAna+mYpSCCD/iCQjfcvWQF4a4wElxqhD9KBXFYi146QV84O6MFoU1QpjX2zOg
         jXOw==
X-Gm-Message-State: AFuF++kZYrwGPSsFpAh0F9/gtZLyuoIYWKgWcqY3z2phGEBM+TJotn+n
	jS6beTkgvNHxdvIxd1RCnmXLAmlqy3je1T+H7/mKAInIgyTnmbhgGORC
X-Gm-Gg: AYBFou2rzVTIOyCDRXtn8DVYbaI76jOWjEdfQIiWalb0+9WBRAu+OoJXAUfI5jWuu+p
	PU3YkWXQ+HAiJLaCY1PHiF22OtiyB1rplzB8MFoElAj8Vxylgyuru/hxK2nXJlkXmKbBmegQEKg
	aEVRE/LtuWzyfB8GwPPliuWu6HUV9geLMB7jcSAEwAeI+l0d49m1NbtC48U6FgZ1K5H4wozCDbB
	z871ZYwTqcr0E56pXpMj7/w8mzAj/VXwInzcdADWyaqYrE96GOEmY0i9mArX+AaQdK03XYDR+lz
	WX3UofxxwRcotN0ov00tw45UE8sdJ0apt9KinHxrB0EkSwaaEvx9gPQlEWofovv1vcnSgCho50t
	Kkx50awzQFJzA3YOzg1AfdV28p/eekfDcumo9zUouXfvONDEUwX/jPJRe9Soncv3he1jSE+IfN1
	yu60dvtTbGmgpvNPTch41zbnsjEagIbtpHiOppKRJ/5T+eIGAUKT7tbIlbdivb20QcI0JiEvxlk
	wev
X-Received: by 2002:a05:6a00:1c89:b0:84a:60a4:2651 with SMTP id d2e1a72fcca58-86f83947aabmr15469596b3a.6.1789484548262;
        Tue, 15 Sep 2026 08:02:28 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29bb9ecesm6422654b3a.43.2026.09.15.08.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 08:02:27 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH v2] memblock: use for_each_zone() in reset_all_zones_managed_pages()
Date: Wed, 16 Sep 2026 00:02:21 +0900
Message-ID: <20260915150222.390819-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D3280C0014
X-Stat-Signature: 5qdy351enebjk13q7p9eqoz498umshzn
X-Rspamd-Server: rspam01
X-HE-Tag: 1789484549-533481
X-HE-Meta: U2FsdGVkX1+KDia0vF9CkRW4CGNwW00KJmcdiDDRasKMGdleULFlfIs086/ipMCYYaF3Y7EoOdzT5gXqhbhgt7VDj6wZWY7M9mRQTl6qYZKlBeBlGOsEpZ4YoWHYn+Eo8MrHsBQT+oSh1bHOd0ZNTO8G8Y94e7uOSqP4xbWyzS5VqeonBjp6tBNVd6HU67cTXR2ccCuvxF/hYx9cB9MyKLEVD7PnVzfCg2YA7hcKhEWgQKynuAUZ1RJmWLmVNFYmUju5i36pDpmXonLOXyekUoZJQvZZGjWem2GXBNOD2J0J4akcyF6MndCr0OlIQI86rjNwei43q+LQloh3LstSQlj219i9nUb5o/1Uo8canm3/sbTppDGYLHc3Ip1g62JMkKbkEmlBIscmv3j9/yusBjsP1vEPyQFqhvYwmj9atvAJ1uarKKKskeTiJj+nWcq0be8koeGIKDRNG+B+r8g3aYe6Uwrl6utxYmUvwNy0DuRVbQSoT9LjTN9RnCNA/5beeyBxe3M8w4OuPkTw6ReJE46BiMTpG5PNd1FgUT5kEyeUoBfrf7YhrqCT1OI6n/K1VJ5RwYJNvMcke6uUd5CNvAd71Rgzuw++qnbMHi8qt6NUv06FCpoB3mwcjTdamgHOJV0OpYtb8oADn4ZtrqSqMNWSS2f+TfcL/ebu0NOKo1GSsOAtdedp+2S+DEulaHNKk9YPea7jqsjWaCAewsJCpSHeXnV7tTlEjv7IwmB3Whmi8C0OToGdyoJJS5Mxuo8MTy6TlmRjPGTz8uicilJXJy3BR/SPzCPRZG/bJV6x/sIKayr52ceKj1syRt8nrbr+R+rImoE1NP9qL+5Mk4syAWwyuHUzDO5j2oUWxOVMtLpS4OQ2rU+PxHjBWQnn8exTZdz2TEbukUuyD1FWzd6oXesT9nZ9uNscSauP++XUnZc9qlloLJnuN8DFh1F4WjBhz0SQT6AaakiFQHP6AHS
 TVZFoafN
 9g8p7WANc7AvpMqFnwDGnLQZmF87ylmvQJuaeNKZ2lU35g6k015P1Xgr3KEalXW6RZuE3bX1M+Fhr7Da3rEiOI2xHgiTDhPq3QHJnDShL/3qqiYesl343RMkrO/wgYbLOQtZfLDInqboqVCD0aiE1u3iaGKzW1O/OKVLMm49oG24VgTJAgCTxutam9GiKVqU/C6Qz85iqXD+U/z6vq1Z7+IYXVPCDaXMWx73ypD3rlVdElN5hBSDVdjPvwFDsVZTLdDyBGRaeqaaIDmJe6SGy6zouu2jpml+HSsS3TVPmDMXthOhIYV9u1jStJRFEJMuHAbSlctLDDpEZH5PHRv6e0JJW9tcsGO43m77+PbrJ8BzXBgMjm1qLVOXGdh98Oe0i4xwpSQepCdmz0Ay/7xwb5TyLW29IUwR7A8bP20z979vieVfzd2mp3vwAz5gmoUSMZVGnWbEfVZq/k416nDI22/Ur49MY0b9CNYiS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

reset_all_zones_managed_pages() iterates over the zones of every
online node with a nested loop. for_each_zone() iterates over the same
zones in the same order.

So use for_each_zone() instead and remove reset_node_managed_pages().

Also add a for_each_zone() no-op stub to avoid breaking the memblock
tests.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]
- Add for_each_zone() no-op stub for memblock tests

[1] https://lore.kernel.org/all/20260908165733.1703766-1-ekffu200098@gmail.com/
---
 mm/memblock.c                         | 12 ++----------
 tools/testing/memblock/linux/mmzone.h |  2 ++
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 31961ed628b0..6a03dc58cf2e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2465,22 +2465,14 @@ static unsigned long __init free_low_memory_core_early(void)
 	return count;
 }
 
-static void __init reset_node_managed_pages(pg_data_t *pgdat)
+static void __init reset_all_zones_managed_pages(void)
 {
 	struct zone *z;
 
-	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+	for_each_zone(z)
 		atomic_long_set(&z->managed_pages, 0);
 }
 
-static void __init reset_all_zones_managed_pages(void)
-{
-	struct pglist_data *pgdat;
-
-	for_each_online_pgdat(pgdat)
-		reset_node_managed_pages(pgdat);
-}
-
 /**
  * memblock_free_all - release free pages to the buddy allocator
  */
diff --git a/tools/testing/memblock/linux/mmzone.h b/tools/testing/memblock/linux/mmzone.h
index 8d934ff5b080..24c149bb708d 100644
--- a/tools/testing/memblock/linux/mmzone.h
+++ b/tools/testing/memblock/linux/mmzone.h
@@ -13,6 +13,8 @@ struct pglist_data *next_online_pgdat(struct pglist_data *pgdat);
 	     pgdat;					\
 	     pgdat = next_online_pgdat(pgdat))
 
+#define for_each_zone(zone)		for (zone = NULL; zone; )
+
 enum zone_type {
 	__MAX_NR_ZONES
 };
-- 
2.43.0


