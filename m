Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E42C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129746B00A1; Wed,  2 Sep 2026 07:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA4A6B00A2; Wed,  2 Sep 2026 07:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31B06B00A3; Wed,  2 Sep 2026 07:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D32876B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:57:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C51BC01B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:38 +0000 (UTC)
X-FDA: 85168672596.11.AB2AB99
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id AB36480007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HQPs1WFX;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpN3DBw+JIKgFepuzH7W4+ydHjMz8Cg19R9PLlsPrT8=;
	b=8CBdV7zNh9r3VKJIeYG8tKD2I9X199j4y/+GQeV3mqKYJrtG7Her2j6wAh12ZiuEcAYJz1
	JnJv9recKhX1Vtt2wrdu3oYh4gjxMy3Mwem/y42TCLYPSelhZ/42W6BpjNldbZICmucKZj
	i1TmFiPPWBrZZpUdAr4KuaMaPtiNb5w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HQPs1WFX;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350256;
	b=dQerZweSkA328HTxx2yKq3IZZ6bVtoOrDoWfEJdsDIinCgeFUiMtr2wihJVzXbWlSoduDT
	UzwNEXDji/0gYs6K52BJaAcThz90ckhwWDKSA6j201knAnI+mculBirQ54EnfUHxYNFw+H
	VbHnv7R+CKWGfPCpgCvHKY/Ve/5vQvQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29AAE1684;
	Wed,  2 Sep 2026 04:57:32 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85EC13F85F;
	Wed,  2 Sep 2026 04:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350255; bh=hoNRRxOZ7Q1TQ3tPx9cyjNqGROvazqJ7TpP1oXJkYEo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HQPs1WFXY9CW3alroELpjH318TftojKz/4UscrbJ2jzOFyxx3UatrpJLr33W9KNfE
	 Asl/9rxAlMVPA9iigGjXVyLoAqrTCxfagAzzbKGU1vafeZPpNPJsLqD5plO8kJvIF7
	 CaAYby5EXyJ2Sp3R2RxfIvknlwZ8d+mi2y2qcyb8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:10 +0100
Subject: [PATCH RFC v3 08/21] mm: vmscan: remove stack copy address of
 pud/pmd pass in walk_pud/pmd_range()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-8-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
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
 linux-openrisc@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1414; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=hoNRRxOZ7Q1TQ3tPx9cyjNqGROvazqJ7TpP1oXJkYEo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7lNaVBcsfB9ZliAXNxOQ6b9wJghPjcL8fDa
 uK2aRokBiGJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO5QAKCRBt1cPRWsUx
 M7ySC/4oY0cDV4bfPbL9NxITYd9JIehHPFNxIAbq4GdJg2qXG5UDzoBj4Wg+TBEiBJtleT7fIh7
 V/SUCFBsSIOPfl21gAV4DsJqqIR2BI9tpisGacYX4mBzjdSVensar8f+n2/L+1HDi08QM7Jfab+
 vw/jd4OIcl5haxvZT1/9ckj2vzQjqGUNnVIQtu3cKR/zayGHnPRqXFeLj7Feqw64p3A05OQ2d3j
 z+koBd6eCH3o4f+a6JZkpt4dea7g7soIxmhTudXuzjnFdZ3j247H1g1jWvNpqX7WLUnUqXJes2M
 TgWOc1HdziiVK5q2kLYUiANmR9JGvyRR08qduHULn09JGSR4TYQBM97x7YeDQwLPSQ5wtU1BnNi
 MP/XV2imJviNZrvi/+xofZE/1KHQ6IchyObI70sbt1mEw24q8+T/I1AmCjW4cX/b7p7K6z6WT5c
 q898aoJd2V8gO2BB56t63O0drtKXzGoei518zBzrff8qAZoIk9QbxY+W21MH5ju9gxOd8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: u7fzj3ho97djwu1ptswyar3omkoiao16
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB36480007
X-Rspam-User: 
X-HE-Tag: 1788350256-868416
X-HE-Meta: U2FsdGVkX18Z3nDCXRb7Qdaz4bZWSWDy0wiWX3PjzqcTCwFJSbwKCwM53Jl8MtqhdWwKQc1Z3AFEmZODBhBSvBxyr7umdXVI7qUw3zN2OOw0poBISborIl+bUUSdH++rAX25K5PDGQ45g8Aygt+q+AQOT/MAmRPgjIXD4El/MVxTj7j5ERb7LXvU84CT+Db7xEX/5aHZaviQwfVISKLCVakTOgHiGprwc4NnfdxCcBKbHyWBxYSPIowVf+O5rWggdIX0ur0loKN+qefMhn8fPGzmTJE3icw59/sHH0GqE1juOt44TKYmyDwzDnVpWkO2GQKOis63lXT16YwmgG9h/Q4gIXnP8GkLoxS7+rDA9vjI2CKo8qQ89j9aUxT2JBnYKTDNrcR0MUd22g/vyhIoFM+s1f47I7WFyE3rBvduxrsTgpnF8KoS/88P8LjlofNtSDfUYMWM01K0O/AN4kZCFRYLHqtKt/VowWR/g2zuiCd7qoG7UWNeT4jx18FUamPFZEhhiWpQlUn1hiOIcsNuUFquz1A6peK0oB61TpGlX+FGFrUYn4IRJ2gLFo9jCy0amaxzKKnBOlpiZydeVDjyRHtZK7FEU06LuSX0uES05YQdMjF0i6vpfxFl1nBdG+a4/RY8BqKGNBCyyA+Uyax+oKTH9TSZdbzBNU0ErV4K/CfHuPqT2YFNIohDCPo8YSbvHhqq/Wu8jlPUfAbfKI3hZo6R3r3XEn8PPwEqTprjJlc6C6kImYRu4rwr2Nov6l/horGdG71zSGVPTh71lAzPdZelVplFc808Jmn/wMAd6yIWBVGso1UDaowgUB2iRnADyCOk1FUQRLOS4NAhmRyyiTe4XpKx1jfxpkI1lsi9KKDtYLwwKP4zRnEqWf4PTA4QHmlEy7ndEWHDi4YmX166ov5UjOIcrKLNej1p8edXGScYDY208sN4W5DYu2apVzUo6ieXw6MI/+Q4JlrzNvu
 w4tyK1df
 SRkcc13gFj+wrX0ulDg5rd360Q+CP7vGssggA8ITB/cokM5f6tjhBZ6bJrPV093XgQUGWt4s1jM3hmaQWwOCdU2xDe9H6fWYDG5RLJNIr1Le55hyR3YxvdYlifEzsh0G4OYs5FRLygYAxS1N/zM7xDSq/gJ1qKM9skSwjkBHoaQPNyoa5dpzD2YEacC7VoeeRZec6MdP8n9BfmyQE8bWuh4bgSq7kfN7pj0DbJHpku6GV8BeCIjYhmEPg7miuAA7wYDwE5R7u1q+baqRNw8gMypQVB6jgCTmHI2Ddx+5uS4kpubM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, replace passing the address of a stack
copy of a pud/pmd to walk_pmd/pte_range() with passing the pud/pmd pointer
directly so that  makes allowing folded entries to be ignored and
check the concurrent access proeprly otherwise pXd_same() would return
always true.

There should be no functional change.

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4d51b0d8e287..4e98088becab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3777,7 +3777,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
+		if (!walk_pte_range(pmd + i, addr, next, args))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
@@ -3813,7 +3813,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;

-- 
2.43.0


