Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF07E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E6F6B0089; Wed, 18 Feb 2026 21:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0980F6B008A; Wed, 18 Feb 2026 21:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD866B008C; Wed, 18 Feb 2026 21:04:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC7136B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:04:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 910CC1403B9
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:12 +0000 (UTC)
X-FDA: 84459561144.16.290B597
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id BFA6E80008
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bP7VGuIt;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771466650; a=rsa-sha256;
	cv=none;
	b=7EzeUuga5PgcRyo4GpuSoo/w9vmgF8uwRZw5K8C5Bz5q2oeL9UPTlfqDX6veUUCMUY6TsH
	+HAiJ6ISzt7F9gxyJ6bRGbqMosuL2Mqp6WtPDdtD7MnQ8P6Ru5uJ5G9IO0IQER2vcrcgab
	+yCVI6MW6TH4zzIlpk0+vqr/EhlQ06A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bP7VGuIt;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771466650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIP3NJQw0FC1KA2/Vngrp26vHXmL8g0a5C1ifEFmdpI=;
	b=tBqbYyMlXpdLi9JGDH69d6TzdOfwGGktGU+ie8qlLxX56Yj1ijfWHwxcK/zceffVuzkvBq
	Zf3woPomUJc0YE5WecuvBH7BgAXRgKRdHezjc26YZr3c7VExHmjWn0yjUc+W3+sIcEsska
	9rkoNhztYnyboNGl+MBGAhvjlQRdrQ0=
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6786b13984fso314486eaf.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771466650; x=1772071450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIP3NJQw0FC1KA2/Vngrp26vHXmL8g0a5C1ifEFmdpI=;
        b=bP7VGuItjRPfw25+M5pKij3GKQHRn9IcT9EXy0FRsCUiu2BUEO8e2O1vPtVQI9xzhq
         LoZUYCzAcaVOhryhvtfFkmjcV2EBy1dJwQ3lTVudwE03UeKu5fMwxOenXMjn3Utynf5a
         73KDagJkwpZnZv4ULDvMbGO5mrRwq+oj8o4FK5KmI5xbSMY47U86bpO8+8BMeer9f3Wz
         PACQA5JsQI5CNDjUNES2nH2IQq8ozZc8G/S/qtv50dwFdYxgXm3AEgpIhJHvmTzNuNIf
         y02G4b40t6JibAxeSrH///Z8rtc7Uin+bbZkkQCEvheI5umpTWAlADT8ZZmBwwILVXVy
         NwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771466650; x=1772071450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tIP3NJQw0FC1KA2/Vngrp26vHXmL8g0a5C1ifEFmdpI=;
        b=qXFxHqZaJL6N3a5BmGQQrqkr5IPkSzP7yuFtrda852USCUfEaXbpEtHG6rM0yvIbAn
         wt1vLTPjF+OMxzgpsM2Nc9vh8dG+ytADdb7NJ1r1APmy4A+9QvfJKI2ljbxbQd+K8bXV
         PcwPAaTg/ZIfEynj8fSXL7O9t9rcgFQ5itaxrY53k9ZEnfFTwltAHOS/qop4YJlnKKi6
         M129asRwxqxZVePpE9sWPsdRyOgTvcXMSH2ooSlkYDZ6y30t1UF0RRFgJREU8J3VyU/6
         AU5BuGw+F7Tm/sVC/CJ4EElZvaUaH/cO4+KSChyR9zzfMjcwrrEc9xKV4LZ+t+UddA/g
         fU2g==
X-Forwarded-Encrypted: i=1; AJvYcCVyflkW0TOmlMQF94S95U4a3YRc5V9JO3zK6YX6lCA/t+6D4AJSi8svo3h004HkY4Lugw2fHyxZEg==@kvack.org
X-Gm-Message-State: AOJu0YzUp4arBWRuNdsYCs/8nSWQBrqiOm2igAVQMjWeSxkxUgzUgnfF
	oRBzyZL6PcmLX8wktCRIO7cXs3L+qCmLQ3O2OSGzPznol6I4XijIfA7J
X-Gm-Gg: AZuq6aLvaYCU+eE4sj8jDnoWbHzSzdzbU+mfu2KPxb2WSE7IdRUSA5YVmufqUMbuTYw
	BXj9a5svNCGMvsu0zXLnQdE6jy65djHbemiI9a9c036Xwkb0iCzjg3s3WrPq8BHC3c6xhz5pbga
	Vyf7lPHr4Un+YopDkoibd9zWB13AWE759DEsWUBQEORdyiUP/SW0msjwSsiEGCqWI4cZCgDqJe8
	JbFq/+8BXFu5b49T+Pngje1Syq8a+Yen2Vp3Ziew7SUBTVsVmTTa4Z9btZKBs46X7/FgUQcztGG
	92VohH2MLZtL5yJmWzvHve5U12LBOSXvVXwjlRIEZLiRwdaJ2Vcr3s+N112ayIMHdp8/7vWHvxg
	yvzWDnrUSsEewboNjG1bAX4VFj6QxIGOcjwFwJ25KMb5SEwzHGYejRPDgK8IGHBOtCKvSgk/uhX
	EUXcHsEqsOs05Cwf69FV9rJSIPdewGcj8EhyvXFABGkA3bRIxnrzqvGKHW5uN95KugW2KZhrKkx
	nRZ6EsWWFta8ocpwV8itidmPfgI+LQGKM7Cz3o=
X-Received: by 2002:a05:6820:308d:b0:679:95da:9752 with SMTP id 006d021491bc7-67995daa0cemr5527182eaf.11.1771466649788;
        Wed, 18 Feb 2026 18:04:09 -0800 (PST)
Received: from syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com ([2603:8080:10f0:ab80::1382])
        by smtp.googlemail.com with ESMTPSA id 006d021491bc7-676e3b52902sm12187297eaf.11.2026.02.18.18.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 18:04:08 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Dave Hansen" <dave.hansen@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v6 1/4] x86/mm/pat: Convert pte code to use page table apis
Date: Wed, 18 Feb 2026 18:03:51 -0800
Message-ID: <20260219020354.321088-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260219020354.321088-1-vishal.moola@gmail.com>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BFA6E80008
X-Stat-Signature: uo5xghah6hq5sfhhtnyfswukbwujqeg7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771466650-677180
X-HE-Meta: U2FsdGVkX1+z9uNYzitb6YFh6jd7RELNOcWEwGqOVcB5TIqTHJ+dTTIo6UltkZrIaMvqHX04C/i8MT15c3iq2nwps1n7OBDPRZSCJFzYwYtWUZW3TY8KZYjo7R1kS1mr2dcPdWC3uZKK1lkOvyixO5IR2mnf0MTTm/C1zA2A9lRP29H5sZ28HTZys6dYaFGIJrhAl+Xo/SjG4L9xGEXHqg4AfbLfpL47+oisI0Qwub354xSoEt3ho3TBwNbIASdy606U8pLlwNhI92PoJEbOMhRIuWp3qQfBY1APVX6rC08RAIi2VqrA4snHyXqeqe2nB3ZuQvxqALSDXE47IWd9dTjS9cXPb/3bmiPN4MZLaRQtdz3EtAdO2wE7DLinNGXQrBhLrne5wQQftaQV8KCKf6eJRj9iQqHBEV5J4KEY5F4pB6um9BgzGsEJNSjqhV6vJeV0psafWPR2q6Iupn1YX9E54/8Y4OHhGq67F6k+yrS7HTeptxDCV27U5IeF8HpqGESVn4Xh3FFiEhpCDJBbg9aE6oPY57ksTGdNoMaTDRB86sORQbKfnFf0gN+DAkJOuJzlUjLgBtwzszWHVDaVy/wLBy3EwQ4lM0NAMb25qCyjc0labxxQ18ItbIzuMGEtkK9nstBSaPZ6FSM08h7pExlCBh03oFuYqPOEfJ+CiZFIC9HxYzjO5cUsMOb3DtGqPmdG37KOCYa0hkkN6kkgmVwYsXi9TzgzJJYsb+v81TAXwt6aT0jd4Ep2Gpj1bz/Sm2XYegxIPnwkH9MQweLYrxTof6v3zraM7VZXF5ha0mvl5CiNJX63s27Cj1BMXwldJ+MU6tYcjxmr/w5u/N6I3lzbN/dHOPEKcFwgNr/fjuDNk/NRJ8I6w/U5T3XgwmGdHo92FT0znDl0P8HWGSFbafkX/tbVY9QU8jihXX2p870pq2s0QdEd7G19mSdHwlk3/fmB5Q0EjDdMfW27sFi
 tX4H5V5Q
 vCm27QK9dosIH5z6wI0AyvcafX/NAu9/BuLfv3nlaDd2J7m0xew3zwO5ddI3QHWAXRBwmO01afZK46SoSXmvlPAY6PgZPwVSD+iIrCoYl64oAnmz4//jZ1qOfo9F8La3XMqtRFOmFTrdr2xITetNcVRN8Jk/A/6adEZ6Ifi2+rJ1qVc/B2jjvYtdAhlD5t1luSmlxYdPQoPEsTzYRGRHjsmh5lzu1CPvQdyVdZwn6WGTfmIcgVQzvjmLas6bnlNyAOipQ9UyHypyNgcmOwLAqo+X1vYkCadJCLuCsN1h3nVMgSgz6eOZXayWzfoAjsyz4eTbwUODwPBJGIA/JDD4e00vWvqR5omNi2vk7YtfqZhO6I55rpRWbFWH6pCTkbuBWm9gk8seo4H9Kvu8lCtsk2Wt00rXAXzTgkYMCqxdpp3VWZUAdCZOE2sX09nFk3gwVqA0q1ZFrcx/HfQF4BwofRSw2X7DQ6myvPm1mwIKeXFb7LeofUUmPddvkiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need all allocation and free sites to use the ptdesc APIs in order to
allocate them separately from regular pages. Convert the pte
allocation/free sites to use the generic page table apis, since those
use ptdescs already.

Pass through init_mm since these are kernel page tables,
pte_alloc_one_kernel() effectively becomes a no-op otherwise.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6c6eb486f7a6..d52010fd3023 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	pte_free_kernel(&init_mm, pte);
 	return true;
 }
 
@@ -1539,7 +1539,7 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 
 static int alloc_pte_page(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte = pte_alloc_one_kernel(&init_mm);
 	if (!pte)
 		return -1;
 
-- 
2.53.0


