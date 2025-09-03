Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD51CA1015
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350028E000E; Wed,  3 Sep 2025 14:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0B68E0001; Wed,  3 Sep 2025 14:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0D88E000E; Wed,  3 Sep 2025 14:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0160F8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:59:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7463C0839
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:42 +0000 (UTC)
X-FDA: 83848853004.24.76E88F7
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 14D754000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fEFtgmDY;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wz/bZSqqVx6pRJeL2TZzvIUdrr6/vXiyt+C/9X3zJM=;
	b=6h8Rc9icYWf16jHy5wXQ2bXITQFAynqPhb1BH6xhnN2NYJOwRE2a+H+ktuL2h+6qKb9Lj2
	Jr6vggZNnnYlpivuKuyp3tb16YvHLcAh3uMp7Q2c4b143xM7yApxRTsKvvJ09aAGDjjD/+
	xIQEAwmvAUZtj6KtKMmzFycZhGOT9+8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fEFtgmDY;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925981; a=rsa-sha256;
	cv=none;
	b=FHQYW59skJd8TNY2k73JgDI2f2r/QNbbuyKBKR3bRkldxUqzPXkLSKatvLLr4/SwO72WRd
	fJTFKuS1SBp9qT3fijMpP0zKS1XIFQr0/hpOHTRQ0kJ6vjn3rwh6K78tgq/ntdwSc2MjdG
	1vyjm88IsIZAItulYW5gMr4FJALawvs=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-248cb0b37dfso2585865ad.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756925979; x=1757530779; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wz/bZSqqVx6pRJeL2TZzvIUdrr6/vXiyt+C/9X3zJM=;
        b=fEFtgmDYwsQ0jzDPLHlO3yux8OIZOG9GFyTLSpQSnOg2sN5juulIreLKPrwfKgyzGC
         ZQIMH7uL+F7+4YBV5UhUpLAY+3ZLgQ77mpwlyWwUO2RLuDAnMHqoYaDVU7j3JHWq8k1t
         zIXaIAot4hsjUb/albICHbjZpksEAHcztBzq/ZVlYk56M6rOXrC1wAm5bgMOWC8Xqpf8
         7CBj02YZSSlHhz3nN9hhFpCGFn5C0v1xsn1CPc8GBEUMDbmb3XL3G1PniXKtqCDwpLZC
         GAIeu58xOz3+HsqsjJkbCjR5kJ+6+7ZZIt8MRcQ85CCfB+z7f/rOAy3d6B4goBhp5pqY
         Gskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925979; x=1757530779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wz/bZSqqVx6pRJeL2TZzvIUdrr6/vXiyt+C/9X3zJM=;
        b=K8+kUcT4qdmMX3topUW7tdvWBXMFvNQao4t+RY+SzKP5RXUcL24e1Fjks1XdT8dFzo
         wZxW/2dDcCmQSQ4Dw1n7gfhSLo3Bvv300WRsWOHC3zORqIF29Xn+a/bJwY0mwv8JX4Qt
         IctCjPmYGZm0jXyfR9IkuBa2e+BeVIUg2aQUJqrUAlN2r14dFAhaq44jLqC4nIkLqYxP
         AiMyZGvgodP3poPourxO5KXZP7HyitBSvKxzbQVD3HFEGq9xfOaPiqmI2qOYuBj9NLse
         raokja/pHFrS02mVw23M5jdZJ39ss49FPx0G7I8u64aGU8lwGEF1I/JSM/CST/y/lr6s
         VrYQ==
X-Gm-Message-State: AOJu0Yz+tHR3OiTdeuv+KfysYff5KPt6uveG9WTuyuC/K2mHz5LR2b1z
	EpTDXdMqY/xBlVyKncytWrHrJXrmQsG1H8EEEppp3RjRmNaPreAnPeR+vWxNhA==
X-Gm-Gg: ASbGncvyVGg+vQWGYpf8BYJX9GixU5H6Lv5Ul2XvrNPafaDgCbVQMd87y0OXtTsFQi/
	iQ2aKSomvnpCDU3g7DsdTEUNUFXwHWwbJs3p7WDqBj5Dd8mP809U/1kUv3vshbsFX1/c2S7Nwbk
	KwtuTL/E39AAhSu/IK4XhXV2YqAVQyQ4VqeyTrsg4rLWa2XBJhnxbjBvvvcJHDpzMtfHVjHXPpY
	KYqPUTVgG+MVSt2nkbzrvw2q1J8/7exF+NdwX805o7f2EK/b99bkVwT0Nl0+NRvKCk1pW1m19WH
	6vll1zJsm41/VBjAhdG8PF4x5iIO73T8G5i/9kB7e7KMtsiRtKbZBwdsDMZ430BZcGEKVUKMlLK
	GYW6b8VAXVcIIxe1EMQvoYa+e+VrqHhxdG+21ehmYpg4esxxc3DW7mA==
X-Google-Smtp-Source: AGHT+IFLYxGq/uXWczWSmoJ4dYmB1R4jOWZAcKlvb1pf3KqvOH6hTCxx8eQlFrsP54M7TPt133nTbQ==
X-Received: by 2002:a17:902:f789:b0:246:d383:3964 with SMTP id d9443c01a7336-249448ac3c8mr239306545ad.18.1756925979423;
        Wed, 03 Sep 2025 11:59:39 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-249065ab343sm169403475ad.126.2025.09.03.11.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:59:38 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	virtualization@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 3/7] x86: Stop calling page_address() in free_pages()
Date: Wed,  3 Sep 2025 11:59:17 -0700
Message-ID: <20250903185921.1785167-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903185921.1785167-1-vishal.moola@gmail.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 14D754000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 57kumjezmwpzcamb4dyy9qksr3rh86by
X-HE-Tag: 1756925980-372652
X-HE-Meta: U2FsdGVkX1+q2ACrITSNByLfCxYcCxWmKBJIQFbW8/O62qemiNAtGGnk/GwedZiyO5LC1iLS7FhSJiQm1n4q/lO9Y87EqIDTEey3Z3sD26iynSc3cEU5NNO41lQ2udkcHy8irypeaJQWjekiNQVSIfxanFwDBG8KfG3+vNP20GcsBUswKoPFI+Aak25kCsMom79esgjxHP7Jf19+cRWHw1K/1Xyv/PItfgmoNHOO685Uc1O3Mqq6lNpJc2w4LBMhvNyeESheSgAWUMME+oNtyr767ZI1g7sb+sdginHhwuG0wjQ5BwaDPcnZj2+Wq1KEkyovktnhnRXYMS51XxJm/BrNxeNUMJts8Ua2uRMyO6LxVJwrDhd6NT4gH8NjJdrQpcC2WN2nFGlUSVIHpqkG7YmbiDKy8oXwCjxov88I4ggT56/fZuh4HYQtN0x/UfdNn0OWiDWBKTpHqXbqq5sjOcbsDVx2VcemU97LIyNDqJuP4GzA3Ippdjw1/ArwR5+yKGNxjMDwnmnCjROZ9kHQ5KWEtfcKmA+0nrfOHBb7H2hQYOhqBQVlolBB1kV15Ccy+kBms8VZ16HSfsEfas4omw3zszn5bsAawvzWOTVaYFOZ9LQKwu4Rr8HPV6VA4N9ugK5cHJtpjKr5nylpqjmIv3wKzGQJnWF9l75tdaQhmLx5xjaSyMxNHk1uc1WP0Qj2+15IadZ/3jZb+916KDFBnGiBJDczM6YleFQRoSUtydf4loB0j+nBjTA/ATi0yCAwTEESXVc/HdpzM2mQo1+yZT16Ic75e0N83/Y9bAaNJx+2bMUwnWMgJ/TOB8fbHRzu3gB+H54jmVVpIXu698r1RVPaEQ0gNE7+NF34YfZ54qUEiZSOiev3lsgoKW5+gyoKjiE3fCloQA/hY8WCV8tX4bUyR7jsOxy+UK2i2wb8GNqE1D3QOdMwCYDq5kkuiisTAMm1IqhOELQjM8H0zAq
 2LCq5a1k
 F3hNaHE2yM0YqLBvaa6yBx7ujwOIBbQ21OLfqHnZN9IVdmntoJYQ1gzi/W2BKBdyXEz3RZPF8qPk3FFaWHbZKSC35k9Xkv9wEN0OJRfWpDRlS6OAECDYtdSwfIs4B3ZxyH3sis43D4O1jXkIauV+T1E5wz/oBjEl1r2fcIBDTJ11S2cwpDy1ZHThxfuniecCDW/D7BasQtloI2kAPTi7DnilWkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---
 arch/x86/mm/init_64.c          | 2 +-
 arch/x86/platform/efi/memmap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b9426fce5f3e..0e4270e20fad 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 	}
 }
 
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
index 061b8ecc71a1..023697c88910 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -42,7 +42,7 @@ void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
 		struct page *p = pfn_to_page(PHYS_PFN(phys));
 		unsigned int order = get_order(size);
 
-		free_pages((unsigned long) page_address(p), order);
+		__free_pages(p, order);
 	}
 }
 
-- 
2.51.0


