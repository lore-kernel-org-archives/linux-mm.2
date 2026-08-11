Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B08EC5B575
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40C846B0099; Tue, 11 Aug 2026 00:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3ED6B009B; Tue, 11 Aug 2026 00:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB236B009D; Tue, 11 Aug 2026 00:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 031936B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:21:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70EC614030C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:45 +0000 (UTC)
X-FDA: 85087690170.03.BE5F3C8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id E28ADC0008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EP3Dq1aP;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422104;
	b=A/dfA3pb/YcT6/TOyXQ5PPCwctIf5Hg/tiYdvmbj47BbjJezEV27dygpkSaDGF8t38UgOK
	Pf+vYGWjWzsbhY6mgn1hNUS3TMr8mY56R5XY9BLJ4NsyHfj4FMIyYbIQDmeVuXp4yz/7+Y
	D7Fnm9kDLmGGBkoYNCaObRrrfLJTuSI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EP3Dq1aP;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlKIGuOzRqm9JwCQkSKGKTesbX9uK1gMGLKgfgpbsmc=;
	b=AECrufbPFEoQimgVXmhopPfowILMZRW2YSldRuP2RBwfrMlyKBmVm8qDjV1k2Z4f+gHt+v
	45XN8SG48ISQDuJdQCGEjaNEeKNQhmw8rZ6OaBu8ISwL3vD6Y1K9i0coGtAdaWfJf6aTLx
	GFRbOnO6fMSHTHiQB62fkGzuPePc6vI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 346BB1691;
	Mon, 10 Aug 2026 21:21:39 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B11A3F673;
	Mon, 10 Aug 2026 21:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786422103; bh=o/tR0NWvhY3SX4yLhgLdlKztVZ/ZDPp9f0uGwvGj4xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EP3Dq1aP8UBMadr/tul1OY+DRwLecwPVYiwRmMER+BCOGaV30lmk3V/aTuXJJLtmB
	 8PbwdwY+cvaT+ugZq70QKqNBl3AgTAqOTQQ5Kb3naXF5+49iz+XTSHKlHN+Dd0+sIQ
	 52UG0j98GXXDebh0dSdXFEtoYAzAN2jBOkz34COU=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC V2 5/6] sh/mm: Stop using pgd_ERROR()
Date: Tue, 11 Aug 2026 09:51:18 +0530
Message-ID: <20260811042119.3652929-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811042119.3652929-1-anshuman.khandual@arm.com>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E28ADC0008
X-Stat-Signature: qofink6wqygj8k58567gk6mk6ameygqf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786422103-400296
X-HE-Meta: U2FsdGVkX18xJ3zHpJ4/tuK9bQ52xo8WfZvnpBrl/ylQhTLyK2CGqWawvWAkAic9wEK4ISUB3D5q2umlJyIHTRZmhFJGsiP63tvcK+X8LnAUfo1QYii64x2My0TDnX6slAHmwM+smwIIFlflvxjCLz4N2crUQDqjc4yHDISsylwuK+lue/c9YkB/Ajo+4Jw26A4rCweDpmdaSHStzVAHfmxS0yXHIZ8Oyj7n43DsAve/QBisUQSRqw4qaxNQP2RtAYEUtxWMHtehJ7+P8lba8Zwfq6BYfUd+yz5X2OwWel37V/nAwORIFp/KP4qQBebSgIJKisSH934hHLckzliD/aWbwOm/+j+yip2QNEpSikJ27kPDX+12DI8kFiNb396iO7NTJ/7S0H02flTIUUdvRruVgCR7VmoDlbXmyg6w+MCJ7Hb11RuqKf7v+kcWrcufjJaROGS4AwCrc7EzQvnxcL8kJujAudJ7NB9fWaraPkOwmbGo2FLZve1AcVSHwZG/aV1F2UX+5tHAncWYdDvNaG6bDuGYhLVLlT59y7KSE/8ai3tbBvQ3bgkvkqnc8sUbZMqOnx8ld6esDcK53SF+WIDsw6EYBWWi13h0ehXJY+B/1M+MpF/EbncA822KgWuW/kHcVX8+mdfX+CEKlN1/tn+LDX/AyVuiaKlb/kliGxaqkyoublCxDlu8G+HHquUMYm9GG1iE0E455zHmpCsUJbJvB9al3Z0J2YybAcQnVlZ6wqzkMpzUEvaUjGnYLbOqp+WhRqTBq2YG9NHJUxvJGA0Shr2KIqnde6JXbygekEPRedeqtZKSDGXT55YOYHeKHhliq9ev/4tOwzGPxjr9E9neQOaGcPAMLdbnDyr8ckmXUzu+T6nobZezNNtooZpx/F6vkhbKc3XVT6c1TJv9eYKL4o2Y3BaHi/LgFgcuZVO8merZXn92Ux6Sx0Tf9ozgcSupS1LASoi56Y7u3+U
 w59gbNrA
 rzAsQn6DNjxppoO9+DtLop0HKOrp5PZivAyFRFvg2Qz53P658tFs97MS0FpI8tUAp4qr1Qh+CJogTLuBedy5O2vV7qHs/t1ozRRY9PXLdxzGbbw++tw0OiUB689R0Zqyl8nxOImcpEULn2npOl/t+DLPFc7C8/8A4HBegW9jBRT6fsXIfcDAjzgZ6GjYTjA3MoCfgUMh7Owo454TJOZ1NPgltfcqVjR//J86Decqdn8u0bD5F7qCTFPBy47Ihja0QFROOJvUY73+Ybhq+PC5L5x6Zt+WEZUsrFMdOdUFX4YzhXOrKyytY5dI/MRUC9r7Z2XjPNjjBMBNwC3Gb1uFsdc+CAV+Ak9f7Zy697Zpw2QC7EY5GfdtoVnePRA2bqFHj3KD/2N595EuTSX7ng4KfDD+EeBvHaeq/vx6VS086ZL1kcLoIjSb6Sirvlq7WB8J/5/vSZqerY4EPLCYKM6uMApr0LL1GoDH4LDa7EfXFFKtpon5QLCu2K4Vhvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using pgd_ERROR() in __get_pte_phys() when page table entry is already
known to be empty.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/sh/mm/init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 0bb8555568a4..585012293632 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -52,10 +52,8 @@ static pte_t *__get_pte_phys(unsigned long addr)
 	pmd_t *pmd;
 
 	pgd = pgd_offset_k(addr);
-	if (pgd_none(*pgd)) {
-		pgd_ERROR(*pgd);
+	if (pgd_none(*pgd))
 		return NULL;
-	}
 
 	p4d = p4d_alloc(NULL, pgd, addr);
 	if (unlikely(!p4d))
-- 
2.43.0


