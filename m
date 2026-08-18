Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBFAC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191F96B07E4; Tue, 18 Aug 2026 10:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169126B07E5; Tue, 18 Aug 2026 10:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7086B07E6; Tue, 18 Aug 2026 10:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E498D6B07E4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 741BEC02B2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:59 +0000 (UTC)
X-FDA: 85114581678.24.455F077
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 713DC40010
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XdjzjYtB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=621MAQ+ob3MA3TvG1kU+UlTNsD085yYkeyKNCZWSHr8=;
	b=4CzJqsgKYYXlx1iy28QhMo+ReukPtsS3AORUmFDkq0RP1gtvUQukHdGWRZqBzCA+Vj3UPr
	+l3QpGcwyAFwo62shNNf2Dpw4OyKu1wFqQ7YrgaQ+eUsE+Z/VZeusuzj+HJt9T/1ZwDEyl
	kpDJt7oIUwPh6rNrWyzt0SXeUkysl3U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XdjzjYtB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062377;
	b=ktiIyg/3Ikcq90TLaWjsMq2PRyLfIJ0YDFMyDjaOK+qE+/Wprn2s948wmGC1/5uQj8bDE/
	T6oNbGQ7Oe2T5+5IHrWl3oK3tWZUitnQMPEJjKig9QiZlAn+wUQDjNtgXNDwmM483uVlil
	jEkfbDPWuN7lJD90XW+Zmz+K+uq6ebM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C804619F0;
	Tue, 18 Aug 2026 07:12:52 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 104BE3F85F;
	Tue, 18 Aug 2026 07:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062376; bh=BZmnoSCbmsCn5A4PrsXmNT+JdAd5eHUywhPTBTB5E1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=XdjzjYtBGjt0RilPor/aXqc/vbZFpEi7wSY0Cyb/Zp5Ve8VEiHhrtinMxmP2oYuKk
	 gTst+6rYttgZt/4kyLHvZU2avvcPdI/ZYxv1WvG6iEIKCeFJGvCaE1Z4buulB32nD4
	 fA+7vmvUB5tV0HMd7Fl2HIrobSZWKjNZQAvoxAUg=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:09:01 +0100
Subject: [PATCH RFC v9 19/25] arm64: kpkeys: Protect early page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-19-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062277; l=1150;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=BZmnoSCbmsCn5A4PrsXmNT+JdAd5eHUywhPTBTB5E1Q=;
 b=gLPl1fxlAX09Iz51qpOThnCWmwd0f0ruWidhABvoDQikYTI3YVwMRCA9uCuQ/osCQlz6cPm2h
 EkkH2utSuDhA5rwT6iqQTe8o+QV0YD5heFgCS2JYVX7Uc/FXe8yTUgG
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Stat-Signature: utgt98zxudbo96bn8u68z3qyx3zrxknn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 713DC40010
X-HE-Tag: 1787062377-715559
X-HE-Meta: U2FsdGVkX198p4unNJuADl0M0lLK4qz4ZlggRzl6qpyP+1U+jR6paTCVPcPVYXu5iqRNIQH2JTfIeNA6/3YxjNVI1X6q9hK0iWjj4sujq+arrbDoeR1B2Pn3up/nKnHuuZHFZ0XyV9RJY0rU6/4HkIDBSZQsjiQEF9hKhAMj6iBmPcR5NL9mumNuVeYjButko/J6CdVCyNKyuTGDTJ4omUGy9kIL8C/smLnP3g+yCGDVXHfnsucj7qG1xoHiWhs1ILjeurqulO7nxh9zgtoc+gvo0LK1RjcJxW3bwPHFH9zslMZ0J/xNhTfM0oSsz5PLF3SlgnBO/6cqgiiQj23D4V11F4YIBs/51xiqZDc3ROLjmhz4tPAbaQhY8DDvSPp5ZashxcqIFmopLZVL7cdmzzzVjaov3XoQsUNVzKTyxuBn4TPph0+DBikryVXttMSYQB600/PV8H9WY2HBPEbVi7VvlHhVlXqMTcp92B3bdGAJii7WI+WxHQDO1fcaqfIhUKwdbgCQ1OVthAnk1Pk60Clh3p74diDu29EvZ03YP3qh/zn9VGDO/T4Bj4bJj/mjBoX8qlkComhj1nrNb1uOX55UWKS9+Ut9SMkdL9a7yUatqmfT6xKKpvYADSdX5vozkDZMp4A8BIJ2Cy7EE20Vqz78NIN1acR1CHQYOB/WUfXRjr1XK+tM+LyZ9qQ7w184ZB3hcHmL5uQJobgAqegetRyWQXiaoQyGGl9yCNmf0S1RadKARIHDxBr+ssXbNiTqTCix8jH2lzVzwqa9fheZ+UBhxAme2vhdS2N4tUhB8Dp8kNLwTejeWdpFIfnMJbiOTmg6mJ93anz1z+sq8vTLuo992rPFWALdQh1NOVklRxIhEuvfxiMblHYGulFggOUdWHH8UhW0iBSjC0w9eaBZx7bK0l4HeLnzrSEn31erAQvOphWuEff/PIExsOI+AjBZq51ra6iKo0i+cEmfDMt
 T6SsU37w
 EhohV+FeL2YtgXyvBudavjF5RAn9KIJfvrF6RQx882FPf97VhPsB/9RrutnJ3n1WWGGYXpUez4IRML6fOGYg2fV+g0oXE9j7ltQk+Z+hVOnmoY32VgtJwmuRgb1Xlk8DYmkh1qvHLYe2gXoY9vZhe+zu8qrrPMU/ncLN3hRu1qRKSv42iPiR+qil8xpz/86uiJL2Um4exmrjloSxafeUW2w0QrD30B4QbpfM2Zz06gAgDe8UXVkK5M9BqitqheaJIkP0g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the dedicated kpkeys allocator for early page tables (used to create
the linear map) when the kpkeys_hardened_pgtables feature is enabled.

CPU features have not been detected at this stage so we use the
early_enabled() helper. This is not a concern as
kpkeys_physmem_pgtable_alloc() does not itself use POE or
set_memory_pkey().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0d7e41d17182..a10e9f9876d0 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -107,8 +107,11 @@ static phys_addr_t __init early_pgtable_alloc(enum pgtable_level pgtable_level)
 {
 	phys_addr_t phys;
 
-	phys = memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
-					 MEMBLOCK_ALLOC_NOLEAKTRACE);
+	if (kpkeys_hardened_pgtables_early_enabled())
+		phys = kpkeys_physmem_pgtable_alloc();
+	else
+		phys = memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
+						 MEMBLOCK_ALLOC_NOLEAKTRACE);
 	if (!phys)
 		panic("Failed to allocate page table page\n");
 

-- 
2.51.2


