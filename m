Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F58C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2AB6B0170; Tue, 18 Aug 2026 05:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99466B0171; Tue, 18 Aug 2026 05:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F31D6B0172; Tue, 18 Aug 2026 05:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60E786B0170
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:24:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4A53C0B29
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:49 +0000 (UTC)
X-FDA: 85113855498.29.D68771D
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id E952B20009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jNVTUvKZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787045087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXih3fn/TdgHOmckkY8kxI7AN967ZoqRDpC349A4Z68=;
	b=LQKJSu6zz1puR9EG/c+04znwt84mUDyBW/70NUX9le/xIx5bZYEfqibGK5u70PL874puLO
	2budpxHUGHOqWcEWIZ3LEYJ9qR38pygaPHobRMqTGlCzf1CcDok8dyTClR61zI0NBRAVzA
	36u6uwUfJUXpSFw9OT+0nrqIism3Elc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jNVTUvKZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787045087;
	b=rwHV3lmeYwOWYKEQ/O7fvupxIvcY72f3LvVD5Pm7MT87uLUU0HwUq5LkpawDs38/ICRPWb
	Avy0naUqI2NTbZdp38hUyQVfqL/UOCAEgKrBf5kTXNaVTvGUBT7TkQrFFQ1ybOXseJYGXx
	HBuTSH3jl7f7Vic3wjMnrNDP5Pu9+l4=
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ccbff2e6a7so25493865ad.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787045087; x=1787649887; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vXih3fn/TdgHOmckkY8kxI7AN967ZoqRDpC349A4Z68=;
        b=jNVTUvKZyJayxiF5k8f37vWAagH3XV99v8aXha3BTzQLLVoL2Y11y0NePCx0fNBCF+
         rPlOEPw9msRFOYVhKy0FB6l7M5TKnN0KQmd85qHTcb2R54tuZzskJ03/GltzALsKfSBa
         YJFHYmIGQPjJp3FYuKXNPc5mWvZhLAugV3e4mPYY/sSKJ6JnHy6l22iCAv2sdWaeBZb6
         faZUKsWcLCaxPpkFomKa8PvzLR8TWmKqEwis6yD3zh6RqoyNRw77e4ypX1jGDA3bBYhI
         2LKIaMrGuXOCF7NMqHbXRcoH3J73LbcukjxcDhV8yh1kg3ZbssDIxmjjN5sN210fiAzx
         Lp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787045087; x=1787649887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vXih3fn/TdgHOmckkY8kxI7AN967ZoqRDpC349A4Z68=;
        b=ZHpmssISiy6KmbDshXn1srFiWn5TBIi/ScHTphbIBfXmzrt4JvKxIVBZygb+YlpCb5
         uV/wWaO5rkpjhCQb/v/+ion7aIhfgUVJGrNLxXABVWpGnepCydAik2mxl2Zvn16/LEks
         VVGZvyDYFQOoYZaH61C3eVIwQencxYYyay4rCtUAswf5aSSEq3bkaum6/n7EB+sqT+ZJ
         ZgmU29px938kOBsBxkBoFp5FGJlzToKgcBmtSD970DLqbQmjFL94n61+vV9RGV5oFGvv
         vyl9BH0qIg5SfL9D7nkqUbRYjsNjOs644G2kQ407pmUrRUO/LamOQyo6WsIWbt4/jKea
         jdjg==
X-Forwarded-Encrypted: i=1; AHgh+Ro9Jbt1eXdM6VWpDMbFR/mL7UoV4Mupv0JWxiwri7e/WvsT3hOe9+EcMqta3r70xQoe139MjPaCAA==@kvack.org
X-Gm-Message-State: AOJu0YxOAIjhmQUxIaBHIQvivRkPVBQ4NcJBjHkGXtV5jSi5FCoNc5fO
	kJVzUqr1/vb5vaGqwPtRhauWiAxap5IsWEl9IwEa+ofvkRlQN6YwMRnJ
X-Gm-Gg: AR+sD12oEPMEDpCJAgNutupq2/Uq2DL3u6s7H/aFe4pItefxsRF47jjRFFu83Ww4IN1
	TdGXF3ddK22D/hnSNOJkNmsKUEmPqTmwCrY7yfmhfpy4gz6plD1PKIXJImKSVP6CO2ceVC8Axjz
	Ji9fwL93AlKQ9mczzjVY5bi9zQzR1HVtM19FhaNFl5xP2xsCac6vN/I06+tGyp2gaaLWODgdcfe
	9KHJzTFFV7UncTZjPHYJERpEekho78Fp/am0O/Kb0cr7zHfVMGX1/YygILuRm34xG+xu/2BAw5s
	GD3EEmwGtUbXMAOmCbnXOzunt/kqzI3IZe53iSuO6gHjzNXyVWqDXxWiTro/OPMJoDLQVBR/7Qk
	S1CvDzxG5LVvguSzTglV5BvyMiDQKNsmwoTTorDJgThL7JwWrTLffkpKF9ZpHDVrYu0HPJccFhQ
	V375S8uz+PO6vaFoPIEycf19XOmmrvNDI8Aa4bHEl/0GEP64t5ttw3rbfl5wnA+1ptbIFNg2ik
X-Received: by 2002:a05:6a21:4685:b0:3c3:875d:705e with SMTP id adf61e73a8af0-3ccda96659cmr10292610637.19.1787045086651;
        Tue, 18 Aug 2026 02:24:46 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13c036c50sm1855975a12.26.2026.08.18.02.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 02:24:46 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v2 4/5] of: reserved_mem: release dynamically allocated no-map region on init failure
Date: Tue, 18 Aug 2026 17:24:19 +0800
Message-ID: <20260818092420.2859026-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818092420.2859026-1-chenwandun1@gmail.com>
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7fcqfxaphdu8k5u1ymz8i893xx6b6sz9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E952B20009
X-HE-Tag: 1787045087-763337
X-HE-Meta: U2FsdGVkX1/uUhPN63XOqHj4+1ctVJvjaXrTEd7Kfg8ll7rvGJg0KeL9JfCWiTJXt7Rm4eW7SnimrGMA0k74iPeXdlaZIKqpLzOHpkiDBTOlh3tLGYI3OFkUasbEB2b3ZbqzAXfPfgd84Q7gC3SpREAoPETZ2nwhUSYyRERloT87iA+okDCQLXOTkokAWP7c+o0WCBkiNMucDEBdKjVudZX9iPsDjCR5TsVfTfeDcJieCtqnopmEoA3bKrmUlMJZ+hSPv7x8GAB7LIT2Hy8DF05EeJTtDxm3bpLVDy8oyT4yjGUtvQWQathAq8hYwV/qlbdlJkhOZZQDC4oZNF2tN0eJy+Yss83pK7cI190ViJAZOrUOKopuIkxqJltp3BsEainNz6AbD7z1fBOSGCSqxuEzA8venkgVGCZNf1CE0olJpDe9iX6iTcIz55lBu+mCy+UxpV3W6X7O8oDFVpI+M9ICLlXNL8RbcujiCAdGLF09yu7YgSyLDSsBv6+hyCco/b2qpk5TkhfX76f6XuaWfRyoXO1KQjXL63IqosAE48vCJ8eHKjSVUkge8zf2lmBEFamME/6U5DIaiWCTZGKk5bhfJzSK6CIAdMLmq4Rasg/86KV3wqNh/0Z7nu1D9ZuNB87pQJPttTSmjKiw1gVNn9j1VBVhOVqv9qh200yZu7mGHqdSg/GLKynRJF3IMThyKGge6tnjTxTDCPI+gifjRPDGfLXFK+Byi+bfv92GLUVcPJwvNNSI0Ws0gzTj1dm8Rfh6zTR1HKnlV78QA0SrSY5FxDAYLrKA7O/+Gx/M/TLGgg2UlT0cQDUoeD9MYryJJIB5+/WN0HNMnBnsufU8Pn/4HcrLmDvH2agFOiVHjZfYj0lCrvXp2at4VZOrTQKGkQabsWSEvUIDyY4lvTx3aCoan7PF9Y+Hpjg4Oz0Ff7XyU1UOKdTGPTfemT1GhOzfzLZ075nHxYcQMGOMP0s
 xubfX5wW
 oto1hSZPGKoVdnC/qy7fKUVUQpzMNZi7j4YbCQnqZK3PrsTX0U8MiDT9hRNwzqVjMYwPMel5W3qSPR99RSCTj4VY2r5RDdjVH9D20ZgxL0pb2nvuIwUHafuxCZpgNAK4IP2LyyQ/zMS3kHMrv9XYEiZx6o6OLHobCPaVNLHZItiGEfd84+xEYiTwieGoY7SbhfRw6h03z3CL7V4uUwl5nI9CfKbw7ENmnqWQx1fznMt8Pb8sTEbYm+UnTEb4hYiGMb62jbuV2ZJfQYKjFNeZduYT1zm2rmmjMS4GgYUNN6l0IrxXduf6j3WwmdKobAz01UHtIGYQb2XDRB7d1Eac7oM6knTXAgnM36Y7xKxR61lQ0x5fK334xMtBVdr9TAqJudruCNWcnFIi/9tlWBCRvyWQwbAtVtsjbi2AXgSTH0jHkHyUGjybK48v5RxabosJbvlWmz34IryQm8MT4AUjsuU5jg8q6zCPZ6bwLPCvFB76m6j8mLPz7Qq+oQgcMeccfp5YfT4ruyzfYlsIYOYPJuC8wHVjtEIBD5Bi7EmuZKLi7sjm+C9/Xx+24Jkl46IaeuOFP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Dynamically reserved-memory regions are added to memblock.reserved by
memblock_phys_alloc_range() during __reserved_mem_alloc_size(). When a
reserved-memory region's driver initialization fails,
fdt_init_reserved_mem_node() cleans up the reservation. For no-map
regions it only calls memblock_clear_nomap(), leaving the range in
memblock.reserved and unavailable for normal memory use.

Fix it by freeing the region on init failure when it was dynamically
allocated.

Sashiko found this issue in [1].

Fixes: 7b25995f5319 ("of: of_reserved_mem: mark nomap memory instead of removing")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org [1]
---
 drivers/of/of_reserved_mem.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 767ef702392e..ac5db19dcc93 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -136,7 +136,8 @@ static int __init alloc_reserved_mem_array(void)
 }
 
 static void fdt_init_reserved_mem_node(unsigned long node, const char *uname,
-				       phys_addr_t base, phys_addr_t size);
+				       phys_addr_t base, phys_addr_t size,
+				       bool dynamic);
 static int fdt_validate_reserved_mem_node(unsigned long node,
 					  phys_addr_t *align);
 static int fdt_fixup_reserved_mem_node(unsigned long node,
@@ -352,7 +353,7 @@ void __init fdt_scan_reserved_mem_late(void)
 			continue;
 
 		uname = fdt_get_name(fdt, child, NULL);
-		fdt_init_reserved_mem_node(child, uname, base, size);
+		fdt_init_reserved_mem_node(child, uname, base, size, false);
 	}
 
 	/* check for overlapping reserved regions */
@@ -567,7 +568,7 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 	}
 
 	fdt_fixup_reserved_mem_node(node, base, size);
-	fdt_init_reserved_mem_node(node, uname, base, size);
+	fdt_init_reserved_mem_node(node, uname, base, size, true);
 
 	return 0;
 }
@@ -676,13 +677,15 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
  * @uname: name of the reserved memory node
  * @base: base address of the reserved memory region
  * @size: size of the reserved memory region
+ * @dynamic: whether the region was dynamically allocated
  *
  * This function calls the region-specific initialization function for a
  * reserved memory region and saves all region-specific data to the
  * reserved_mem array to allow of_reserved_mem_lookup() to find it.
  */
 static void __init fdt_init_reserved_mem_node(unsigned long node, const char *uname,
-					      phys_addr_t base, phys_addr_t size)
+					      phys_addr_t base, phys_addr_t size,
+					      bool dynamic)
 {
 	int err = 0;
 	bool nomap;
@@ -708,7 +711,8 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 
 		if (nomap)
 			memblock_clear_nomap(rmem->base, rmem->size);
-		else
+
+		if (dynamic || !nomap)
 			memblock_phys_free(rmem->base, rmem->size);
 		return;
 	} else {
-- 
2.43.0


