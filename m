Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82C9F9EDE8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D0B6B008C; Wed, 22 Apr 2026 10:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E4D6B0092; Wed, 22 Apr 2026 10:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164326B0093; Wed, 22 Apr 2026 10:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 087296B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:34:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF55E138C11
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:34:01 +0000 (UTC)
X-FDA: 84686436282.24.0D8556B
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B41540012
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:33:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q2zrwb6Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N4yIt8RCBj5FwRKwlPkkY/fC9xE/AMrCTI7LW9npa5s=;
	b=gK3z+5oM6tocMeku7nRjKpF3W87UeFjWVd5V3A/sFwzDgVGsj1EUWWfSB3s1aCAA72N4Bs
	gZgDVUbLRtctWftTt1J/sjMyyFEp0f7qEOtFr4OohJI+/IV+yJhIzmtHTMqpMwkMZT4xm0
	kiWemHvazGGf6XvMF3LQy+EELOpVjU8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q2zrwb6Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868440; a=rsa-sha256;
	cv=none;
	b=8FIDNTvlba8KQyVoU5k18nkdSG3drjwjPD8HW3mMLUQtbP/3YaNiFC6KWNF3IipVtLQ3eN
	6mlHLF6VfS3q8y16lcw5lS2NfjftZEbrMwARub+FEayJkxamXvLTvnBSfHB2j2jtCTWfz9
	h+XQiFEIMa5K4xW88dUucZsGUrqPqQ8=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so3657736a91.2
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776868439; x=1777473239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N4yIt8RCBj5FwRKwlPkkY/fC9xE/AMrCTI7LW9npa5s=;
        b=Q2zrwb6Y/NYTqzhUQswm0kjUxCwGqJNpASd9Mv2L7JHQdVKBURJF66ewE6tXjflItS
         cRTht5BZMobmdjsqkLrmiHbKXpTPZXv8okqfZ6k23TDRAvmYbIQMYZod9wuPoUpOUxGx
         sftNA/+Hg/2t9bCWdLm77P3ysFcGVJHEGHq+BGl5qTrb1znol1BYYHWx+hlPD8j/wb1k
         ycx8MuyJXfqfZBzVpCl/UZEA8SFU0ydeWoFZ3+aThuHLIs8MOV4/lraWDGwBxIBHje4L
         N8dwQvgmzObYVltt0uXYfPsldBOOdJaL9U2pTV9Q19PnMWp+JOByYj0nkNAp7Iq1rx4w
         No9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776868439; x=1777473239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4yIt8RCBj5FwRKwlPkkY/fC9xE/AMrCTI7LW9npa5s=;
        b=a0Bksnfm+u3WSRPwmTgclgO/AZv7zWpwMJbWlot8slo/w8tM2BnKMPH9J2b5NuoUG6
         WX7t2E6IVyejTfazQtSyMcNKaOYdPBDVyXMg+2SgxHorblnimgQJyedBZn6OXv86G6AF
         d6527BZ7flLTITQQ5Ra4CziWljCEfRNKbHUn+Pm7MSgKnIh1UfdwU1HIIl61Fn46cJWj
         1fF8UMIFJkc8XzeGFJQJC863zdMpQ136grcUOaAsa5m9PKskSUN1sarkqygLqgqt8Bv9
         z23RJC5rG7rMAVoGsT3EoiuACd4RhEmIbA85bdOzikTo7v3Z9Wip5YJn09tWKLLObyaw
         0OSg==
X-Gm-Message-State: AOJu0YymrapzZR771SGCHJUOaklCmH85GIr4e5S7JLy6dnx414XxW83+
	bWEr9pIV2wFv64BH3cM+wzWBtGdp26b6KGRtPQaZ8S+OzwT2twfZF/DG
X-Gm-Gg: AeBDieviubK+IZWbjKaqlPgcu9AeumDcxM8OcQZIuY9yNpJf5z4FprnE1mS8vBGADGf
	SSUEGMqL38/LyV67cFw0v5tY35fq3wzHhx0cYDk+QiDZMTEZo0/zX84TVcuUzDlZJJwk+WLcP/c
	hJJP5wJOj8XwbEgnDlyjqFBP6ykSOys8/CW83+f6wzH4t99iAZP2RiY+ZkG4KYpyS0VqfY9S7Pw
	jfn1ZS3l4Zh4t/M3brALt/6pPon4BcBNfckhyUAscyf0UB4f4SCRGZrpMQov1xELI523JuLhaHh
	OLAljobMspcaanEEQoQtn8dgEnKGo8efFNu8HnyHbbq2BWI1rRxmXrJGKILplfK7SAisYfoy+ks
	klavZEz9Ag5D9UBo09P6Z7vQtlFtC7GYa2iGWCsJpWfxccfCyFyGjYQvige6ljCTCTuFTqLqAb6
	d5RlbpGCYroIFQaQjYjPH3cmYE3Jf1JMYbe9ShkRA=
X-Received: by 2002:a17:90b:5383:b0:35f:b7c1:faad with SMTP id 98e67ed59e1d1-361404a727fmr22527873a91.25.1776868438587;
        Wed, 22 Apr 2026 07:33:58 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-362c69b8257sm2569913a91.7.2026.04.22.07.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 07:33:57 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] mm/hugetlb_cma: round up per_node before logging it
Date: Wed, 22 Apr 2026 23:33:53 +0900
Message-ID: <20260422143353.852257-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0B41540012
X-Stat-Signature: 588sh6pm5bi3qmiex1thngf6a653pd3g
X-Rspam-User: 
X-HE-Tag: 1776868439-693496
X-HE-Meta: U2FsdGVkX1/EfBEoW8zJI3RvIRibqxJbxVXFcycvejCXNnshhg+cbCumjv9T1vqUThDBD1lb3NX4fDPkaC10sNR4qWRxztgteNQPtaTfuJ59vBLpFC/fBrGDtb4THHJiAmWLb+YHK5Lie6PgxrQRTzhxkD2ZOXGM3xRkR5aIWKlWsI/IDoV3cf1fw91NptwDDIUS68OGobCVSujTUeG/zafjb74dm99G9X36PaAP8Dz8CdtIzo1VLnwTZzs1cuIcCVNUmwabynBU6rRv0o7fEhVqdeTouCfHadOBCB1Bt1htdBLnlAMjxPTzB4Nna5I4J2LGzYEk543EeJ3TEHl63zpCDZ/WLPlbkr/FlWKShd4Sgoa5jdnJvcNOCe2xxDvpZcrOYbm2yTF2WUCQfjC5dbh6ADpGXCouS8ohfVit0eHYM55o4MliWj399gUZSPFkWMtkc+j+JSf0qTBedsv10WuOLE8RbCU8kjuaRKmB52xzASjZO8eRgmRHg3YmQ8/VGhpb5pTapknoTIGyku3LIRRgb0uEQvQ1MbJXPlWzhT4tAMTrVVsS7tdUxjjuf6XJgac2gPClSTA4G4fZ6kss5yNX0EbRrk+AbvAXXbw6YcSA+qfFSS+lyMb0ImGZnPEGiB4DmzL3XG9wix6LzvLLUFH3UqQq8KvrhaBqd/OIQx62wx1VrTfkgJuNW8HbReGlGbcBQjT1jXXpcizRSRJboNf058v12t6oSSwfWlami4DtP/wt3r4slLz7sGyLhML8sYKu2/d52DPlKqLrlE32+zyvrdev9BP28NBnBXpiM52ZhkhlB0q5w9CeZuikoEBwXP2qDsHp+MUzs83WDvPh+D3Szh2TST47f5mi8ykZK1K0g1Q5F6ORFeRdbdui0V0eSPpeeAoJXw+ZdFcIiPmLyEnUiYtW5z5kzEnos2ALfTJkhhqtH/MFc1Fv3/aNe5tWHZgsqk344gEA1hL5//w
 GJlTa99x
 /HxCH5F68Zd3wjsxc6SMtXZx7wPoTgNu5JEuVwMokjd53zRXI4Qq30vIjGvmR3ZDYnmJEnYF4ZR0AdWK95P8a09Lcr7SH/EJtXtrrkIuyiYPj494ZXOu3k3M8ITAq3bXDefhy6vtnV20ocpRW7CPssOr9OoKVxXvx1xQMzsM6nsPWbfkV7sObcDgbwtz5QakpxAbDAIbVwP4Jm515xT2nRRW3pw04ACUslUZAgO65B9xPuDY5wLnN0fqjUkSiH3sMbEKFOhGkhXk7T6uC9B7dUe+JSDxUg7SxyqETjMTanSHYcfiU0aHIgPVfN6LCCZoJQLxUqq6pO/kmOFn+lg1LW3HHzh62tG7W9tN1cE7pQhUDpPq+kxLA6zxxk0tctQbqd9BlCeqK/8cMbZSDSP7dQgXrBlmZ49aFQqvZAvX6o/+rKlVMVu0go04D3Nr2acWRo4BzFGhLKOQk35jfSbdD4bjCTPZhkjBPdrCt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the user requests a total hugetlb CMA size without per-node
specification, hugetlb_cma_reserve() computes per_node from
hugetlb_cma_size and the number of nodes that have memory

        per_node = DIV_ROUND_UP(hugetlb_cma_size,
                                nodes_weight(hugetlb_bootmem_nodes));

The reservation loop later computes

        size = round_up(min(per_node, hugetlb_cma_size - reserved),
                          PAGE_SIZE << order);

So the actually reserved per_node size is multiple of (PAGE_SIZE <<
order), but the logged per_node is not rounded up, so it may be smaller
than the actual reserved size.

For example, as the existing comment describes, if a 3 GB area is
requested on a machine with 4 NUMA nodes that have memory, 1 GB is
allocated on the first three nodes, but the printed log is

        hugetlb_cma: reserve 3072 MiB, up to 768 MiB per node

Round per_node up to (PAGE_SIZE << order) before logging so that the
printed log always matches the actual reserved size. No functional change
to the actual reservation size, as the following case analysis shows

1. remaining (hugetlb_cma_size - reserved) >= rounded per_node
 - AS-IS: min() picks unrounded per_node;
    round_up() returns rounded per_node
 - TO-BE: min() picks rounded per_node;
    round_up() returns rounded per_node (no-op)
2. remaining < unrounded per_node
 - AS-IS: min() picks remaining;
    round_up() returns round_up(remaining)
 - TO-BE: min() picks remaining;
    round_up() returns round_up(remaining)
3. unrounded per_node <= remaining < rounded per_node
 - AS-IS: min() picks unrounded per_node;
    round_up() returns rounded per_node
 - TO-BE: min() picks remaining;
    round_up() returns round_up(remaining) equals rounded per_node

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma") # 5.7
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from RFC v1 [1]

- Fix missing semicolon
- Add Fixes tag
- Remove RFC tag 

[1] https://lore.kernel.org/all/20260421230220.4122996-1-ekffu200098@gmail.com/
---
QEMU-based test results

- arm64, 4GB per 4 NUMA nodes
- cmdline: hugetlb_cma=3G

1) AS-IS (beforce fix)
[    0.000000] psci: SMC Calling Convention v1.0
[    0.000000] hugetlb_cma: reserve 3072 MiB, up to 768 MiB per node
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 0
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 1
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 2
[    0.000000] Zone ranges:

2) TO-BE (after fix)
[    0.000000] psci: SMC Calling Convention v1.0
[    0.000000] hugetlb_cma: reserve 3072 MiB, up to 1024 MiB per node
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 0
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 1
[    0.000000] cma: Reserved 1024 MiB in 1 range
[    0.000000] hugetlb_cma: reserved 1024 MiB on node 2
[    0.000000] Zone ranges:

---
 mm/hugetlb_cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index f83ae4998990..7693ccefd0c6 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -204,6 +204,7 @@ void __init hugetlb_cma_reserve(void)
 		 */
 		per_node = DIV_ROUND_UP(hugetlb_cma_size,
 					nodes_weight(hugetlb_bootmem_nodes));
+		per_node = round_up(per_node, PAGE_SIZE << order);
 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}
-- 
2.43.0


