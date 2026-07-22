Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0348FC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CEE6B00C1; Wed, 22 Jul 2026 11:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36AB6B00C3; Wed, 22 Jul 2026 11:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26316B00C8; Wed, 22 Jul 2026 11:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AABCC6B00C1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44AEA12020B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:47 +0000 (UTC)
X-FDA: 85016802654.26.6AF2565
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78D4114000A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CGzjPkOm;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734305;
	b=p5XnDqLVL+pz4FyPwyHmW5xGoF401Ulp2Eo7sC+eB2yWjEbtI7fnZcxf3b/8URoSU8MffI
	F81qUGuwqd9PC/jPwMPeRfVPBBst47uPHNMqn0ULiufcs8Ad6Co/jY9VLyzy0kmntuF1hL
	ekRmMcy1Q/4wCMxumQPFBCS2tquBJNg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CGzjPkOm;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzfbvJv+BjdR5R/kArWejuipgFMZZmGlX2iSNa0ho/M=;
	b=OQ4sdizRB9rWCYqq9HzQzMbjHBNKuHTJwGy+Urttesf9r9IB7HkKXDtEZaYiGOBur+Zd0P
	RR5S/ij29+pgKPwnIdOlPuZTPgLjU/QHRw6qQNLKBpwnJV74U1b9VF+Uhgncs3eFmarsDu
	hbrFbwCpcsEbXzjGviPXEGcdb2mqXsI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 854831595;
	Wed, 22 Jul 2026 08:31:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C595E3F66F;
	Wed, 22 Jul 2026 08:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734304; bh=hEzwBV+PsJMZFHQUBE/OtSpPBhTaKSML/8YZA8FQaPc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CGzjPkOmqAddjbsG8ADR28xqNpwQCbCIVZQ28QPxQ470spehbu7sZXGkzEiyKQCoD
	 9tqpzRwhimPeUsyXWspyAEsWw7rw7IWTxF6vIlo+4hPzHZAP1YgBSnkFAgfGE034hI
	 0u2bUvl46g8HFbNHc47KLB4l2WViWfKtN28DE45Y=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:17 +0100
Subject: [PATCH RFC v2 09/20] loongarch: kvm: remove stack copy address of
 pXd in pXd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-9-d9e4bad31e0a@arm.com>
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
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1993; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=hEzwBV+PsJMZFHQUBE/OtSpPBhTaKSML/8YZA8FQaPc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOITNOofyACG8/QiCZei8Ic1hoiiCQXEac7qC
 yPXQ1a1hn+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiEwAKCRBt1cPRWsUx
 M0cgDADIz8U7Oh583pQ27I014VPnh9IxMAk2ecbKuCG9fQ0cfoJXO7FKXClIOvwmJMb+1doNs7y
 pnLXHfrzcROqjlTIY4MzxF97/uzFMjwMVPLeUTg3f9AgeYTtMCTkukqo2k1FOOjd2GMbivyvbmt
 byvNk66OHNYCC7ny4sUIqRzocrl4arOXlfLn9qTAaE7O/D3E+y2c+HgeDcikVt6fmwNuSLQlnsO
 duGz8XaSPaZAiytq7Knyo+dn/smQ5WZ1rt/0C7kENuI/dP88VtKsJUFqVFndL6Eq7ftgSbN/qAS
 pUgbXo6AEn00FnJ1//leWcvPuf3h+Giag5012lyG/teyPR9hv4ksXdc476DwrNshgkhHWkz6wx+
 Jhh+VYegE8+aQQSZqdgh9xIb+Geg5itZ0BaOoPAOlK5iNx5ZW6dfJhud63h1RIhIrdbAqEL3eSk
 n9h+7AYiZRJHvZzaxeJopt3mxwL/gzUQy8f3AzWEO5OSl9XPu4VNsTuHVFzCatpC3pFkY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: wo33ydxhr3fkjaccm3awbjy71wm36bb1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 78D4114000A
X-Rspam-User: 
X-HE-Tag: 1784734305-88082
X-HE-Meta: U2FsdGVkX183ScpSKfAz1RR8eohRzONX8kjsoecM7ceSFnObtyQZVPngyJcveVwHHnw/dFL6te7fHDN+09UwF9ebW7bqOgZhaSe+oXfUgzHAF/Kru7E8UGv/IP+l90UmA1jzAkPYyHWoTBlbFNLFo6JYwmbkltuOho5XuwZFxPXZl98OD0/Iler+dhqaDVX1d92V1vEKQKrM7mcjXKGSFZ36zmZCrTssclquCObiipV2uzjEighXUkhIKEbRuRE++axMhp5L/emvMtfnIHg7BX0RFgP0KE8FJpdXupuggFl/iHAuZdTVrb9oU1WNscaKwJFmy1Wm5vComCQYA2G39GGY+kl6RneWRIMj8s1/nNLLxOmfV69dpzGrLqeZ8/WmDdlL10c0+M+un5/RI018t4SXup554Lt5nAFUUdTCaz2KOgKQl6G5yzzAbVEd7YO5oPTB3KQkq+VAoQICFUcJbUnl0fw8qqBmDKYSu5+JkkX30VAtfoO4s8TTglqFgwp3X3iNfYTchMqybIOvl2i1hArzAX4ykgtxbClG92EcrIKcGnS/Td0ru2Viq2MS7FmUvbGw8jDCaADflY2rMnevhVMUM/bW0B8R9J8VypGNiPPLzahaj6Dh4IEkYF7yNHZPo5en14/yMU2HwJSi5cQw2usP1fg2qBtjIoUnGPIwREtNxvWkTpsV3lNWSc0eKQoFJUDA73c65fygTfFJiXNdPMBOjYGF0L5h9zaqeJaDyqH/8D9Hs/nGAzITnST1D6UGsCJeBRlnQd841ke40S24BWSID/EDg4T5EuxaqG0Fr8jaDR6ObxzGnLlYtQ+PhNKHWTtqlkNVEXjkJwX0uzchmuT1c+4hTTKbC1PVvEz1565Oe2o0RUdfq2/ikyL8yoDmXBwQKsBsmLaHKTHu0aNwrmOGcGpQWybImRXz2i89E77QlYwhYZQ5SMCbwIp5fSnqlXEW+VLqoSltDV49LJh
 CTIxCUrP
 gu6vRKsXDY2CC0ml0783Rmn5B/LrmJGltsNfy2K6IhkEpPjMAkFFfdX1MKMZ6RHjXCiR+jPiSasu+d8f7jvBiwflEI5O8pvDOCBIXJKHFz05rE/6FcILQr3R5vfMV1wc10T7ZmGLCG202zcR8Kp1tMWDDpNHBvmDOb4tlJoONsqmGA8kLdVaurOV3N4juUYyaKUr9NuGg2mSpKp88ckOn65m7EliFH/yqPu5RHEkgLHyk5PZx2mtc6FrTsegFVoKHpHdi55UJ0p+lo9+4qO0HzQu9nRMZur0asSa17NQfNk3HCc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that,  rework host_pfn_mapping_level() to avoid
use of a stack copy of a pXd and pass it as argument to pXd_offset() so that
the folded entries value is ignored.

Replace direct uses of stack-based pXd values with pXd_offset_lockless().
And there should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/loongarch/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index e104897aa532..837b40bb694f 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -669,10 +669,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	int level = 0;
 	unsigned long hva;
 	unsigned long flags;
-	pgd_t pgd;
-	p4d_t p4d;
-	pud_t pud;
-	pmd_t pmd;
+	pgd_t *pgdp, pgd;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
 
 	/*
 	 * Note, using the already-retrieved memslot and __gfn_to_hva_memslot()
@@ -698,19 +698,23 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	 * value) and then p*d_offset() walks into the target huge page instead
 	 * of the old page table (sees the new value).
 	 */
-	pgd = pgdp_get(pgd_offset(kvm->mm, hva));
+	pgdp = pgd_offset(kvm->mm, hva);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		goto out;
 
-	p4d = p4dp_get(p4d_offset(&pgd, hva));
+	p4dp = p4d_offset_lockless(pgdp, pgd, hva);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || !p4d_present(p4d))
 		goto out;
 
-	pud = pudp_get(pud_offset(&p4d, hva));
+	pudp = pud_offset_lockless(p4dp, p4d, hva);
+	pud = pudp_get(pudp);
 	if (pud_none(pud) || !pud_present(pud))
 		goto out;
 
-	pmd = pmdp_get(pmd_offset(&pud, hva));
+	pmdp = pmd_offset_lockless(pudp, pud, hva);
+	pmd = pmdp_get(pmdp);
 	if (pmd_none(pmd) || !pmd_present(pmd))
 		goto out;
 

-- 
2.43.0


