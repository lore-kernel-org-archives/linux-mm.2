Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89AB1094471
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 12:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44BA6B00AD; Sat, 21 Mar 2026 08:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCEA86B00AE; Sat, 21 Mar 2026 08:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95FC6B00AF; Sat, 21 Mar 2026 08:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A38686B00AD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:08:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3389959263
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 12:08:58 +0000 (UTC)
X-FDA: 84569949156.11.3872F0C
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5EF531C000C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 12:08:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dkrQQNlG;
	spf=pass (imf20.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774094936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vnmXpXBvPtbLW7f0UQotHOToV939tRBOb6Q+9LiT46w=;
	b=oB7hWAIY6zpOvPEwypxXIJr376MQI04kr0UjxGJyklAGTJQckRRtV0PRjUN7CAcdamcTvm
	WBkFgLPy942gSMKwo1575RTlU4+0Yvt7AcLURI9o9//RfAZ5nZUGgPP/uv+pRXl5QgU7DN
	1QtZR1H+7jQK+jNJAa8p3S4/hhnDDOU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dkrQQNlG;
	spf=pass (imf20.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774094936; a=rsa-sha256;
	cv=none;
	b=I8ZVHlWl+E8qpVVgGh8i3K4rwgUonA/1CYcqEX2bhpTcIPi9b9qeYgVyQZybnBVZVCjyzZ
	Sq+SmCBJ8nT0XOlBcI/8tsSYSUEjLjfFmtGIbu4UirD5Fot5ERV57byG4Z1rmEbmdppu4q
	8QTMAyPJ9qBWivBLtgMqAcRdPPwUt5Y=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35bb7afdc38so1727844a91.1
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774094935; x=1774699735; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vnmXpXBvPtbLW7f0UQotHOToV939tRBOb6Q+9LiT46w=;
        b=dkrQQNlG8ZvqzVdtNf+HRSI4cwhhjFAEMAj6sd453ru+folaxl6JWfHEPJDNROPLjo
         TBpONuut8mto3sFWbVdbRThE3obQYD/v1wyr1jL4aMF/MMi1AMX/L4TvjGPucUyTkvAf
         VyqAhlaF/6ZGqbeZsOUUd+Co5zRPsBk1LM9AUqT00qpStJzmyhXiIuYNIC2jQj7lEpDW
         tURgQNsZtA7JayR5eLqsTWh1gGxbGMemUmYHPQe43VcO2y0ZFK5FQIOKoV0rbyMxeTyn
         hc7TtnRikDLoX/IVqg0MyvVuCtN8p1ZiX5+jeouIopymBgAINhbdhNgo9eg0FRDfz3Fb
         r/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774094935; x=1774699735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnmXpXBvPtbLW7f0UQotHOToV939tRBOb6Q+9LiT46w=;
        b=V9gCNLlZG0af+iGjMrTqkD/Xrx84Jaiuy24BwzC1nvgh8RuM0hVTKL5pAOL1XYn83r
         hGxwRnFnq9dFsOIZzL5VNMOw/zunajL63/gFRUsh9ACevaXAYHnRB6/C12SFEPMoksJq
         7kzZapgDfQOOMI+3WaLliSkOXVFmP8ZOpKI4WeBAhMHm0se5Yq8kZVnIuzXwTZgn3EaL
         y61TlrDnhpYYXSE1274H3l4xNlccW91N5TdTIP+23OApgQBJMvDwEJbozMcjMNA4U8lO
         TDVQ55gMVeOS9fBTg7PDzL7klX0MjohYa0XTW4wyUFKVC+clc9ViDRU7nTyKBZ/c+XI0
         prbw==
X-Gm-Message-State: AOJu0YyozfKD9/HWMnFEBVhqETFco43h9DCHmJPe8m+ZpJHg2XPKBoYb
	JAnWAtMiISm8hKhWVL7R1jhdiSR9Ls+zzI1R/48SwWUPcMNobhs7D5VKwLL5EQ==
X-Gm-Gg: ATEYQzxiCWf5BOuZ1o7FysOOcrKvfErDbPYhRJhkxu5+50Ct+K0jaoTjVOIMsyjP+px
	YV8E5W7kZZY4u1D6xN6SC6dXLLzNAEDILzowaJmDh/N6hSScUMLB93IPmjUH0n68bVf5WwxGm7G
	v/dq7C+ZklsZwdJILYrP4VKthFOWSvyQevK0qDH8lVDCh16SuG+zYoXIqTy5PntvbjWhch/CtTW
	vvLsBQf2Kq3dgkIrk2zF0STsGMBI4nRDfwXy4+d/fA4n2UwZDy8+F/Zf/I9zr07tmSniOp20FS4
	c7MPBwpUx9eQCvEWrG6a3iFAKGNvJc3lzvj4s7kS47s1h3ZuX6vJN+Q6g5sVETFuBiobf2xdSZU
	QQp+u1VvTARotoN7h2KbFWJ2/W1OHLHXWPSVuUCWtb5nW2BdKFrTy3PwRoGK60NNUNJUD/mFAM+
	ygCFfy0muU8y83n1yNlqtNAjkL6TGzEj0UvMRTMormgv5hRwkr7mWG
X-Received: by 2002:a17:902:d60f:b0:2b0:6b98:59ec with SMTP id d9443c01a7336-2b08276ecb6mr57447595ad.34.1774094935161;
        Sat, 21 Mar 2026 05:08:55 -0700 (PDT)
Received: from localhost.localdomain ([113.218.252.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366b9aesm66243445ad.58.2026.03.21.05.08.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Mar 2026 05:08:54 -0700 (PDT)
From: Chengkaitao <pilgrimtao@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm: Mark early-init static variables with __meminitdata
Date: Sat, 21 Mar 2026 20:08:47 +0800
Message-ID: <20260321120847.8159-1-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5EF531C000C
X-Stat-Signature: ykagc3k4efbcnu6ibiha3sbom9ccbfe7
X-Rspam-User: 
X-HE-Tag: 1774094936-74857
X-HE-Meta: U2FsdGVkX1//fGlrA5ilRJiniy1GZnng3bGHBfhsYcEnnc4bJYXz2ZuYxkNwtPImnHWAMvLAf7cQh2pyoAO3fNH42Z1PpgLY/eSX/84x/yLoWoa9l63sl5RT/x8KDC1mGJAo9rmljtMsK0CUa+3BVx0Tq4qZKmCKGVvzzXXC5suf00HE2MorE8Ai5YhhkwzyUgXdndLRRQh889j/OTOV6OcDyuTz3m0vmk5DGfjK4IOvjNfsY+BsDAQPprOBQBCbYtRP5hRC3M1OivAjbJpDJNSBRzQgfyZYkK2ji/PVFkgzC5O959A4rwekaS8JGPo8eywSsLxl7zoAS2TlWa/5rP8URFwp/rZTTyjtzyR6vJ8x5sh5QTy0kPHHc/G1+WhkDqg0/mrEO5Wp1lo0w9OnlIwfibzH5Gs3M11XtuOyIYsqwsLixIhL/hVvVPOmewpe3j8D5SgRgOzB1J2uVWYDoClyr5+jVxd2mob1x3atz6tvNBZYE8NLLXUG4NDuCB44j4uOupWmDCow4yvUx30TEoDdIoCzebppuOYKyfyUUGfBSPOfq27BdK5VQL8ByLa9U7C/En3Q2GiPI9Ow8CBoi3bOCpH7nCAZVb0Dpp4r8qOG/AJ9fQVCXJJglxnER4ms2alU7XV/Hc29vD4n36xkUaLeoKHMUd8vDeVLKXgMMOO07/P8mHzidm/4dtHUPGO1NRBxWCyhV73JS4MD2UzIefDp2ll7JXWGzs8yW16sqK2YLcMZkpRyQCskTEOq8PF6pBlIlIzKYJx82JQjGwNR92iWjBCgF2joZPR8nlELbCZRmTFN4gdvJRCMDkX+NtbxN+8DAxX375/moppmnrQw/JIVSEIujolmgC7nHHDOeveoVCYzVZW2U7pQ34QhuGiNqImTOVXqUq0ZLbcv0pC/w0qyE6YWLi9m9ilOrBnAU6l21BV/UezxroAcqWX8zHkhWlYkD4FFlbfechHDieB
 ZTMc582v
 ADBmjIvDEEqAlNQjKZCRKekLiAimznSeCiV08WuSC3fu3H5QsN6IZPqsikrFJaAoUeBYBJDG71kQLHHrM5OF/sWWr0WjAmT8Rc62IfU0NUTWnXiBW9tAIhJxbPsA1eZLlv5SMJFb3wmHJJq00rJIfwgoAegJpY24za8f/CJi/4fzefsKDte2CJ8ys9tUBRnMxfgw/RxY1EaavMkQAqZZFDu1MDx2w3aDaJfMsw8Huf91r062ONScZr/XL8HYzcQVXMF4lmsQLhaK2rksPi74kuwL7WAQ0lFQlpDxeMAc5Od8puqJqNfKVvAExhFDCYgDQkxQZaQNm61KkPeurRJNwZpLRQQIg07BVmn6BpcDYSuJZKwNeg7OhgQAhAEUM2GuLHgw6tFgepCQ1zfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Static variables defined inside __meminit functions should also be
marked with __meminitdata, so that their storage is placed in the
.init.data section and reclaimed with free_initmem(), thereby
reducing permanent .bss memory usage when CONFIG_MEMORY_HOTPLUG is
disabled.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/mm_init.c        | 2 +-
 mm/sparse-vmemmap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index df34797691bd..24420217522f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -801,7 +801,7 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
 static bool __meminit
 overlap_memmap_init(unsigned long zone, unsigned long *pfn)
 {
-	static struct memblock_region *r;
+	static struct memblock_region *r __meminitdata;
 
 	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
 		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 37522d6cb398..ca05941463f4 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -62,7 +62,7 @@ void * __meminit vmemmap_alloc_block(unsigned long size, int node)
 	if (slab_is_available()) {
 		gfp_t gfp_mask = GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
 		int order = get_order(size);
-		static bool warned;
+		static bool warned __meminitdata;
 		struct page *page;
 
 		page = alloc_pages_node(node, gfp_mask, order);
-- 
2.50.1 (Apple Git-155)


