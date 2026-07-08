Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78361C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B6F6B00AC; Tue,  7 Jul 2026 23:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4216B00AE; Tue,  7 Jul 2026 23:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D4A6B00AF; Tue,  7 Jul 2026 23:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70A556B00AC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D42E01405E2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:37 +0000 (UTC)
X-FDA: 84964134234.06.03EA130
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2F2E71C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eSQR6MjI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 35r9NagoKCPUgqelrdeqlkdlldib.Zljifkru-jjhsXZh.lod@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=35r9NagoKCPUgqelrdeqlkdlldib.Zljifkru-jjhsXZh.lod@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g97KZ8DCuIS+c0VePT80lsI4HYIhSP/AZ9opA2fRq10=;
	b=62BG5gW0tBqFPnntm3cuMEKNZ/RqO77XrrSTDiSK8K+s+4wMsiZPpzerfvML5myWE/vC/Y
	I7XPfoy+e1+BoqkXBMiYJhzbmuW4YT2ugaRil7X1uIy7DxCu2ToJu0Jy5HkF+fFRXP4/NR
	uy0DItmSCw9i3sXld56WHdXvsWiW4Gk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eSQR6MjI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 35r9NagoKCPUgqelrdeqlkdlldib.Zljifkru-jjhsXZh.lod@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=35r9NagoKCPUgqelrdeqlkdlldib.Zljifkru-jjhsXZh.lod@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480296;
	b=2x9rqEALVgtB03tU7vbBh9slvR0kFKgYLZUfQnbKUzQeiWqPiaFbNvE9dGGEN5YaIuXPZ3
	gUrR4khIhuCmW3eVmr0NotTmfHpAMgIb7bgjAe648oBG+6d4QL9vTaEY7xIVDZL5HWfrF/
	ejXy1RrrluZ3Z7pIjfcM9a1OvPfKjLA=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2cc88e22f92so7909115ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480295; x=1784085095; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g97KZ8DCuIS+c0VePT80lsI4HYIhSP/AZ9opA2fRq10=;
        b=eSQR6MjIhrHcg5LHtJ97YJzck6xXKLe+jHM2cJ1CPZep9kfcZ+U32DBtzzaiTQuJ+P
         vwxUi8az4W4nIZRTkDfDp12RAvBUZ2gA+6S0ptAg41g4EOPNJaVVjHlnP13e+hE2+X9Q
         YYZh474Pk1GrecIJNo7awZa7hs70S8L+daG7WTWtD7wzjboFfvBe8jU3aPkW6fdUcCHO
         s91j8dZFoKu4Cc4uMouqLHf+cT+HwHJ7h2YFofW/uUHDu0a9oGrSWgqMjHiml/mfKwwS
         rk3RoM5RqkFsp7KC0Dx9zQRQHRMI0vtdLBBkeIXEQ8zXOyS6q6mmTPToPUFLejAGZrUy
         +jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480295; x=1784085095;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g97KZ8DCuIS+c0VePT80lsI4HYIhSP/AZ9opA2fRq10=;
        b=aR3idJgdI+D5aCcJMcGcYu1iFRgRkggEbkz9QYJRj1j80LNvcL+QN5pZlf0lvW20Hb
         DX24GS+xfO2y9eAdYU2ibXxemlBH7hFbgnZ20TGFSt06FsK0b36X+F+cutu6/wqdIoUw
         XrwxGubOjOlmatv6SaSrsl4j0djzKIWjeN3A7dx6RKWKjB9wtza79wDZh3QjwT4gQ8u6
         WvhZ2oPVL8Mm3FxMbsvh+9ol29DPNToUFfh9wATrx3QwujhrEKCE3TytiYjTdkVgdEtR
         6vwYKDCmI5g+sWFQo5FZ8ZGMG/G6iteA+4ZiP+WP0+jCN6idPmqLKpTx1SNgz49aNgcY
         ZTug==
X-Forwarded-Encrypted: i=1; AHgh+RpqEGkOCk9HbbJtvzhyAGkxKjlJ7XGRNFU2WQ+jkOZDYSlGGYm6VOyQM0oG13YQ1mSmKYUE5z34Xg==@kvack.org
X-Gm-Message-State: AOJu0YwjyQNLeFBtHiUULmSy6/We+Qt7Kdt0VveP6lmuds9BiC5KmdmB
	HWT86wIubRriFCum3E4xEYHBgD18xYVuiF+XLQrju47mBP915fbxbk/+8pJwlEXAnv4lLPnuwjP
	OwpwBmhmAC/rGI05z/V3ObA==
X-Received: from plcd11.prod.google.com ([2002:a17:903:208b:b0:2ca:e02e:5b86])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b4c:b0:2ca:6c8:abd8 with SMTP id d9443c01a7336-2ccea2f919dmr7181815ad.12.1783480294770;
 Tue, 07 Jul 2026 20:11:34 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:11 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-2-jthoughton@google.com>
Subject: [PATCH 01/18] hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2F2E71C0003
X-Stat-Signature: 9hogide3ci7776jtmnymocxiia4rwwsz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783480296-897461
X-HE-Meta: U2FsdGVkX18BNBGsvKj93/PU6sCep/3yK7Crj53F6/KBWWXMAkK2DE7ChswOuVX64QYsMzPulpQugm5LvBXszYQd+IX3EF407NBGJJmSUbhY6KFSB1g1LmuGc/x97kJ40QOmyEfcZAE4oDwKN7Ow+KlbOWCs7PGm0cnMNxprEqujWhijkTdYyXZhMPv/GQjIFHZ/UbkgH4mDd/ZXDI1hyAKYeBjMau2JDL2D9ccl8pYOvwBCAXPHyZ+itJf++CbojMDpg/f0iai4PcQy6brTCwIShM0pg0oYUhMMIpDkCjNrgPjEI1luprASQmUm8ZccZnMvbep2ZWh3/oR1qyKViW0lAqYXCpMOpSfiXIi7reWaAH358bqiGRiiuWAQYEajQ4Bs3xF+3XTReUxa01jHqpIpQ4xXNIXIDhOUdlDH3WfXI/aub6ku+esikYa+Q0JIza7PVq9rrni/kli/iimv49WfzajHZIFTzEZFQyUVfu5tSpI8DoPL1hGLkWaXbk3sjXmNwFL/hfa1HizlpU9VtG0ByPQ52VXuLnzwY5FY7bQ1jTnTo7YukSDrp8uA7KDS+j2eYzTxcy0LXDjZiFwcjZ/9wREVsvVp2RjklQlHJInGX6acu3ZKrYhvrUIr3h+y8HsASCL+losADtw+rwHWao9G4ISUxtOQAvD60XmIjdBsyx33vHovBLliNiHT8THJcfzDfngxOUFE+guTvng8XpLFw1IoP9gEfZkk7Xmd9POdSt6PEJefEnWwcS54SPoWY3UZmQS2fghhfsq1hhpx1FzzDSy4eOh0naXL0CeKRbkLfNgSVwOt1tC19mfDvhL+ku+AVEo8iHI3gBBM3/XWiHNRGBQKiBm3EI5qGDXf1OFbM6C9jIuuRTgIau/8w1Brkry10sDbZgfGlliE5RdhLsh6jhDtWpHkwaE2BrlhLDn5lV6Ar+x0aRVZ6L02BnWYYKmJVcVehWNUDQK9ZVC
 fLvSw59V
 ojJ8ytTtcsjwuPt5YV9SDKrqElnQLQsdSfOa3Z1PDN/TGquBHTvjvC/tRnSUQrgn7uxryJ79uYCMdRs4DThcMiCOIzTnFvVCWhRod7h3UFfLjdO7PPL9WXwBGIqW4RuzYHeSkDoazlIL8AuxCwRl+g1DNQe3h86+mkw+Wfwh03rrDKgQJ0DHITxMSMCHQKqItGVVKiXzBap4ttQZ+za8yqveWZK95EYV9LbNbw3xZotvbjgsnv3s3cFMEY285Favsl44NeKlLuQ7c7bjyrITHBoxp/jkDDbKFsucXBwsOMCXv5PYIhA/YKYaWCq/qaoKCllNcIEQt28Awj5+2xpB0dsyb5gGalQAA5/0dOpmNgTZH+X3tVHVnaDgeMdxrRiCHCWoGhMKGkr0HkwvgPBMidPUBkzY7DP8dsg0+/aFBJYR/kEd+P38F13pMRggmv0DuKDY5IaUJibRtbn+m6RdmSG76T2KqILInM6e1jLquiqVQuIk/PDAZltWFqiPMUWKGsm80eevXLzAk+Mb+MxDIslJf1eDevMjXtvhlVbP9hRrCNexdx1yx6jHMrgjpHLhYk2ybyyPlfJE3GR7QA25lWj48WbVQFtfguMYCbeeVHWXC0DAyutXoeHdMjH1cX6ayIg+L9EehJ71aQKpbLZ6LOwDzzODgoXETyooO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_remap_range() can potentially leave the vmemmap in a partially
optimized state. In this case, a TLB flush should be done if the walk
caller asked for it, even if the optimization was not fully applied.

A follow-up patch will more completely deal with partially-optimized
folios.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb_vmemmap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 133b46dfb09f..da29954e9533 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -164,13 +164,11 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 	ret = walk_kernel_page_table_range(start, end, &vmemmap_remap_ops,
 				    NULL, walk);
 	mmap_read_unlock(&init_mm);
-	if (ret)
-		return ret;
 
 	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.55.0.795.g602f6c329a-goog


