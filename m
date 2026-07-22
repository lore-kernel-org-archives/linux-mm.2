Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402B8C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4BB6B00AB; Wed, 22 Jul 2026 11:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375BF6B00AD; Wed, 22 Jul 2026 11:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2654C6B00AE; Wed, 22 Jul 2026 11:31:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 025386B00AB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D6321A0239
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:04 +0000 (UTC)
X-FDA: 85016800848.18.5DF6903
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id BA3861C000A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Sx7wtw/4";
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2PV6dOok7J5hAXa+xi25iSCLvmWLIuPkyP6cj583aQ=;
	b=wURY5LdLc+Yihb1N3vMZnRnwcZCOEIgwYeRr8Bcd/EYEDadITtN4LRBMmNoL9IESqmJ1LD
	oHU7LvjM+k01/ghy4Z/pp6tv9X7vn2fc4x2y7OD3EZDUz+/dFQrJC7iWjTzPIYLAmyjXLb
	Hk5yrk8Fu+gQJaDz4RuXc0FkIMjBe54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734262;
	b=YW961XwpYnZ08DS1BoSVGgs6YMkCLdhI6qyu/9/wQawiYUP06VtuM12tOHkQodwNadp1p6
	zz4r/vilFeT2wAOQ7pXEW87bdLkl1eqIaSxPVqwizBz9PKKmui41OWnSmqlOTFoUFsRt72
	bPlvrVSWWqV+f/VjAmyP7/ZC3nTzI6k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Sx7wtw/4";
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB4DB168F;
	Wed, 22 Jul 2026 08:30:57 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12DE83F66F;
	Wed, 22 Jul 2026 08:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734261; bh=QrVPpGpdi/eED4dW1HaGgNR2pJxPks6zPqeAqIGp2c0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Sx7wtw/4z23ZqWgZrrke2cLsWwmVryD0piVvxP5yDoWYdAI4LejZxWJjAx7VCXeFj
	 XxlBVB31lMo8WMO0RW7nTFFAbLeq23q0DfH91pTlZcCEROxikJkt9oVDE3Hv9+sPO4
	 MNzvkiIBTNf3FYe9RkItoVkvNmFyJJGAKNecB4sk=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:11 +0100
Subject: [PATCH RFC v2 03/20] ARM: mm: remove custom pgdp_get()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-3-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=imCIbsDy8jWM4y7+JQNzM8t/o1T4VNesyR2iG+vBinE=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIQ7gH2xG3dGNa5zWIxKkCj6heJC6TxnwWDG
 j715ctcwS6JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiEAAKCRBt1cPRWsUx
 M0iEDACSAXRGBpMxC/K5FYE+A8U6TjqE6WPR6uVtpTp4G3Ulkg3GiAy62KmADuZ/1YGRLTqtioB
 SdXgnkpNWIpVmbvcXCxvLM4JngQLqdwGN2Tmkq/E7pjPVfMB2A3IlViVxIOIAIY/hhQzXV+yp0N
 SSIpwtdt3xL3PHaoE7k7j6EXAhTrAXOlpUhi/1YOZ2KR3tA1vDaX+zz5v43oCXPcUwuzPVWiNsR
 gBNzXs5iUtMNDnepvlm1EkCJNglxpEVCKSZXfhItaNffxHBi8qFpApORlfFfgo82PzlaWlOyH0z
 LXiuXGqDG0qTAhzC9PhbfS4Ppx+63phAq5bhkgEQsP9/zsIb5BMpfTw6Q7Ig5V5wGO3YRiCaqpH
 1Hx4bDGaJ6B0NW84rfJG7zCHUg5dv8FqnopAzS/cPUj8wq1UsNKs9Zwiq6SwXB+Ff95tjEG69vu
 ZAASVFVOH8dS3VQRZqe2XcEJyHiu8f0GNrl/Nf9QLzMl3+Q4g/upKuF1Z9aCcoPziBSao=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA3861C000A
X-Stat-Signature: 6aecf9pmwia1pf76eqjuqngudtjc5bjm
X-Rspam-User: 
X-HE-Tag: 1784734262-27576
X-HE-Meta: U2FsdGVkX19I77z6N//FHC10V7EUNd0pBQ4VfgGF7bTBQF4p5A7NvnhicScG/ooh0OpArfMi6OohYTEwKuFN/s1LLMimz4ANmhzrwAFiIHdLdZqrmqPxbKPxCCNF1d7DBxbOYgwuNehndyEwcExQ63Qyuv6hZREkXv3gc8a7scL5XFXwqNKF0RA64z+SSSf0Sb/wm6Rb6mWwO/qclJ4PklWDM4iOOUxshdd7D4cTLzYqg3aUX9j+RUKVhBBucPHk0BMTcrJ5EhxPAPWeximWolQwYDGD3/5A1ofX5/47PODN3JJe8oPGqhRzJ/1dJvllwBlmkN46cWb+MSkywz/0wwtz7wJWayZaNo65HLw3VlfhiPSIB4u0JF8nCwOSRt8A28yLQQVEYuKDxU0SyQQRLZ8mg81wM2Ny7ruCYd2MCl4FEWEWgARNz+omsFSeiGnP61EKI32BFRF2to6uFC5dLWLGThNsejE14EA1psPe5Zhxceoig+qyDkr8V6HdnS8E5fUFdeYjc/MnglO5ofe99c627zqGfd0bfVa2/4Mm4+KOrbHb9H5Twgt92h5YhWDtB94AYesu/vAoTRSJ3pFdkCLRvhiy1YMwME+pUa8LDrEeBaPoVWncAI7BmTn/XQtqPy0V0jM0N2syLMOESB/ksTfadD2NAb+wDPIgk11ph0coeDTcqoRQDnOP7nYkSPLhER/9ivU0maACIxOW5d0bd0FapchhC4xG4kV6NGCjnM/Zi1xFd34Agwk+ItxqEBegQw25//BkvwLk5enYIDjW7VE9d2F001Q+rjpTh6y3b3TSbAfczHWgVHx/T1QSp8T0S/8pwnMkeTK5/qpR6b0LydUJB2FO8d6nUEeQpwBGpXoyeS9Yh8WID8N6A0HJNhd3qrEkl1W+CwMjPjSjg+cVZrvrfSzYYbR2rrsZQS1NETGuBCPNV/nav1GxIrbgHos2HVgZcCvZQWnsavtWUrd
 bOj/WEm2
 kkrgyHK4xmAUdGVfEZVVlY5xshuqH9ghLGIWi04aaCleHyVbCgzdInlBDuZDUL6rccfj4lKHp8sbMZr+oU7OscH8JgXeafeRykYpGlYZkqlOTQUOaUwGGpxayq+hrxBqvyjfo03KFneH9CzG9vAB8/pQiQ90A041lnNhCcqH+ZIGA423gfnL+vXZWTVhLxzLP2bjBFFW91mgAL3mjsIgWcuNA3cYUdNJFZBNwr7tigPRyMBHeFpr45GiDQyKQTGJqiuQ9q4or2nSdZfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Now that pgd_t is no longer an array, we can just rely on the common
code pgdp_get(), which is a static inline function that returns pgd_t.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/pgtable.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 982795cf4563..eadd027fe0ee 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -141,8 +141,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
-#define pgdp_get(pgpd)		READ_ONCE(*pgdp)
-
 #define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
 #define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 

-- 
2.43.0


