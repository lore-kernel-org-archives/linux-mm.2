Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAE7C5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 02:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBD66B00A0; Thu, 20 Aug 2026 22:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155716B00A1; Thu, 20 Aug 2026 22:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043CC6B00A2; Thu, 20 Aug 2026 22:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D143F6B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:09:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65AEA1A033D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:09:26 +0000 (UTC)
X-FDA: 85123644732.24.D5030E2
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id A8E1620007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:09:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ilorj9X/";
	spf=pass (imf13.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787278164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5VObEqVOp99ppCJ9xRs38fsUMieel2e53/fex25hio=;
	b=Lup2o2/TrJTwAQ5VgJnncfjpHMrvyhX6oUc0K6ujr+R0OCgqrc6+ksg667inzeKbaKEQ+F
	nxwT473aWZKEVXPCYGH04fj0EDI+EETpow7LIpVOcNEc6JW2rpoS5121cn5RLQwugi6ESz
	SkGvajy1dEf8Fs5E68ZLouqGCB+0QK0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ilorj9X/";
	spf=pass (imf13.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787278164;
	b=afx+YDPtqYfE0CJ08CQzs7kdHiiR//uGkR5w3EbbAjngSv4WGcbZ5To2d3xFzSRz1m5DqD
	FCAkdHiT8TRyMxrrQaWb2DiFjck3CggtQi8DcCc1cN2dMcGaxIVoV8gy0kejc/HFcson6K
	6sD6xeRQnn9c7MGbzXiUQsjBe6z7Uss=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ceab75934dso7425095ad.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787278163; x=1787882963; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y5VObEqVOp99ppCJ9xRs38fsUMieel2e53/fex25hio=;
        b=ilorj9X/ZSNJ0QghDbcp2iWft8TXFpw1bMGHyh0hoer3XJ84BwhdRy6xChaRaWqTqx
         BpdbZlbw4KNJivFDDA5hZ4dpoasp6V06Xf77Ll+bnWGHSnv0wl8iHC5LF3euCT6D7Dxx
         JzxHMmQda5Uut8Z09VyNOfBQKNJnYeESfhmIAJSmAI9bcBO+ypfoNNR3PYm60nQpm3bg
         4q3m7uRUS2uNrIyrpe9763In4eKVqUNH7wfFSHG+Q311bo/cG1dmll8vX9kMq+5u3AJB
         Wd7jHa1dDenVCb7ZfWBhuGZJ/WiQYWha1yYZ6seg8ZkCypjQbCqR24MS5mYE55PExFjV
         RtQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787278163; x=1787882963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y5VObEqVOp99ppCJ9xRs38fsUMieel2e53/fex25hio=;
        b=VUYH6KNBmMhAAf7ehXYIqtsxcDfsxnU8WvcfLFZesaMq0ZWjmw53BbDbzk7mfXowN/
         bToY1P2KDVg+ymUQAtQw1uGzlOrTQUTp3Ou7xtCg9p742Dka5bOAw9psctmvko/b92Te
         /KbO3JyzqD/Yb6etyUPAjGcE4CXoLbFFe+klLfwWdffbWRD1XJ/9mDETRuZEJwguNC7e
         Y4gJA0+tDU9jfmf7fQg8FjN80AFxbiZe1bcUm4izFGWZ6XZZ8MS664F1+XfMWyFHbx+G
         sBf8+vGjCYYnm7NU2ZqnHaQf0IgRpj5/LJCQwA6WL/QVKi2Rk8am+/cfQdhIf5E46wrL
         wjog==
X-Gm-Message-State: AFuF++mtvXepX/jDQyTWG4BYB2UYbgvP0n4U8c0jQ+mPkfWO1BXMH4+1
	VaNGO/tNNBx3Ojlo4xdu4eNRUeD8HViLM9IFANPg5QDaMhON2c0wkVLE
X-Gm-Gg: AR+sD12/1u3uXdueMp4ODQBgBtaP6yDtSirwWmz1hG0kLddRMxB8XJFuCDrASpzxGov
	VdWU+tH8o1WUE9EIlr//GLvtPfHCsbFzPld9Hvj7IocDwoMPiBTWGKYmf0J5fBiDQOeAihGDF3u
	5OyElAqVImoOp2gOcQns2lz6nA2GIY6w4dNMrUVfrWvgAATsAzVHc+uBiK5FWVOYgZfctexaBHz
	zelNeIWzL0sxKgDnm7AqAHFUtQdWsbmEJY+9F2MkNmK5B6N41VOQFtnQ8/rGN10/XjdtdM91Bqx
	YGLVxmH8OaefD5qNICOugUu44zV4VoIWKmgJFN82tQUAc8SOKfi0ABy8/V/hgZVr+xuivVkV5ZD
	OvPKlgrvnjU6uOtpRZZEs6t4aK35MnvmszKt0p434P2IsooGtZ/JM85/vX0EkirfqRT1bNlSxQI
	hUGhs4q3e8oYeuXSxcfhGqPxPN+VywzPEN1pC1wXaC3wx2agXAB9l0fSm4CfaPsdjPGRT34F79G
	DMY5DmFd7ifVIjg
X-Received: by 2002:a17:903:354b:b0:2c8:248a:5dbb with SMTP id d9443c01a7336-2d64af45575mr57386055ad.7.1787278163533;
        Thu, 20 Aug 2026 19:09:23 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e3cced8sm12851045ad.75.2026.08.20.19.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 19:09:22 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH v2 RESEND 1/3] mm: memblock: add missing HugeTLB flag name
Date: Fri, 21 Aug 2026 10:09:08 +0800
Message-Id: <20260821020910.3428585-2-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
References: <20260821020910.3428585-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fjxd6i3oae9tdiux8ywpzspe3kaon4th
X-Rspamd-Queue-Id: A8E1620007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787278164-319096
X-HE-Meta: U2FsdGVkX18hw0+glkjgJED/MNFV7IjLFTzzkd2V/DuRJ9cLCCpI/nGgDELxdVPr/rmcuolCDqmAZ2VQsXlD9ANnldWT4zDOmmzkXq2U7QJNEAeDBegM43YDItqBDZWlTDXhSmvlPJ5+LwU92mek4vUwOYMg1hKv/VGVKTojSCVCNmHRKjTuRcCgnx7kQlCFrA0k4yflSnOIs5FihLnqsioRgcb5A1zGD9+6qYCGJVtm55Tm13NUZt0a1qTBkaHu4QBJr4lYoigO0oBU+OQDhqKk4na9fzwK8LpVkyRoucLhuQvPvaSDzWCmm6gIU+TdbDc57uJoXMQj3pMoj2qnRwPnfayUu6MAL2CDq9wUYren7qTXOiBfA2djFfXBH/z65DIaZ93pUCs8QD3QOjYVDE/BlFA9Eh5JGnNpRpEdTTtjvYEKDd9objqeTCGyCaRT4GdwiStx7aOB+Fne/1uQzTiyChCEOyQ5kpPrX2eSbDk636EyqsGfBYOWSBDGZ0BSRhFJMNPeEKdxAh72dXjVlmNiNJugodyQ/LerOh1mISZ6G7B+XYdX4p3yUGDyBoQpOag+4kb26fODeJEvBoLc2KuBK4hWdqfj8f2kxOuiAjMsXMYtd4ZxuPxorPSXGV8NYdQM6Q55U8mCnQgcm3P0+78LeBf5YeCbeMZFO8cpEp6nsBw46CxrjL2tMjZvUBlbFxNtkRC3hAuux8lofxQAk8ujLkfZihojGH/0md+k+7/EEVZHHtEORT07lUjA1UuXmbFd181miVxxKGxKa6lDxMVO1FJWpTfdPPWWs71hbHobrClNUA8gf5OGMCI3Y59fzSVFrhCfXjYJcgp4vyPfgSyx3l/fouvQGHM7aXKbz9oibtmM7TMrcEjE6sN+JpUNMFqTtMTdfKxuXLO6wv7DxuAJkytJFCxVqkx7jWmwg/JRbjpkbhd3N/70sL0wZkv58wb9f7wYnHH7H+FNaGf
 sUe+6j5r
 LR3WalImtZW66ovuHK6Z8MJEJ/NHBEkg3UQsR7eoh/pezQoksRIJcfC7hkkXWFW0OcUGyf968b3UN/xFgCD7062Eb6av1C9ptCLkxVf/6kufSHU/dGl0dzbC/Hlk2nJvlwaBSKq1Eft22PjhG9YuKM0q4cVfI6paGr5uJbUz41bqHgSO5Sfj3okJjWrWPGk4JZlZmMKm0toV3/hZkry/yDyZbxWCUW5X7QXD4AHRG9fpg7n0idbCzwTlRCWkrHduOJck5fF8aCRx9lRp/kdpJ0fQdu9tJUj/Vc4PyJAoiFASrOEZj8evk95t4QC2NzMmIN5yU8Cbo50wd9ydDoHRm0wq6Nc7b9XbEpRi0nnT4ErmBrtPaBUbFvwXWUubD2ZII9Yy0Ly06JvedKuzNxUKU9bWMLdgn0+CadZn1SKTsJpal8tMzgZ+EmRHlmeXT5Y5u9EaJAhG+hft4ID+I1ZH7+8SvmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Commit 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work
with KHO") added MEMBLOCK_RSRV_HUGETLB but did not add the corresponding
entry to flagname[]. As a result, memblock debugfs cannot report the
flag by name.

Add the missing RSV_HUGETLB entry.

Fixes: 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work with KHO")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 mm/memblock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..f2952d725c10 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2886,6 +2886,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.25.1


