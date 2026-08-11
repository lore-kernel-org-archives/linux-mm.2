Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B277C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BDD76B0092; Tue, 11 Aug 2026 00:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394F96B0093; Tue, 11 Aug 2026 00:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2406B0095; Tue, 11 Aug 2026 00:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FAE26B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:21:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D77340333
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:31 +0000 (UTC)
X-FDA: 85087689582.30.9ED8266
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id A638CA0003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KC7mBJJ7;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9156elYbVcgOVBUlBcK8KwHSuT6KmfcOY4PjQv80+WU=;
	b=i6m93ou4RlpzOgnXs5Fd6wGWEEWDYGd67EFKs5JMjkyJYfsVWkTvWs5826wdYugVuM6iFh
	/Th2XVBOGDUagN/Ilq9mr5BvEsdYu0Zc2GhTmGmnSYea3W60NaNkfOqd55XANTUXItykfv
	r5hgwI7eZiyNiwJlgI2w9Ct1pxq84mY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422090;
	b=7Zf59+2LTNm8Ud5Y/Gt+FWaS/2moLboyZwDCEmYa7UCIv8JldfIoiDcqnlSuV1E1cpcIdb
	EsGDJC9etjXXa603vcKCJ4opox9rDnGk7xrkb7LBFOEepn8/5Tju8aDApAHrwMWICwv8fp
	jYEQ96embXVD2rXexZP4d52EGiAwlzk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KC7mBJJ7;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB1921682;
	Mon, 10 Aug 2026 21:21:24 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D93B3F673;
	Mon, 10 Aug 2026 21:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786422088; bh=seDKsmiMOMrdwfylVhhzaffw4o0OcF7YTjTN6FBF/F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KC7mBJJ7KWVH6Grb7zUC3NdpCyV/h1uPp7PTSBIuRmm8PBZZS6xTMV8rQbmBcb0+k
	 CrFwokBxCYlG/gET0eDkNie78MI7Otgx+fDNF63nC3bpTuLMTOYV0FYW/FoKzOsWXt
	 +rPreTXul9plA9OwBjRX3iIHmzyFZ4yyGIp2Yfrw=
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
Subject: [RFC V2 1/6] loongarch/mm: Stop using pte_ERROR()
Date: Tue, 11 Aug 2026 09:51:14 +0530
Message-ID: <20260811042119.3652929-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811042119.3652929-1-anshuman.khandual@arm.com>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: nrqsryo5qdu9hcphyckypd4kzdhonq5j
X-Rspamd-Queue-Id: A638CA0003
X-HE-Tag: 1786422089-433778
X-HE-Meta: U2FsdGVkX19WJlUgm/rimFycjnn9OzoA+WQ1v1ApXvhUlJ52G6flbH4+4b5JJebMplr6wKbztZxQnvYjTxY62ChMtJ9cwJL7kQ8BSJpGKRCGXmdyWWN1AFFcaXKgjwI08iJtN5rfAjGnuxtIZNevWSw5KQ7m2Nt7tmR7uAImteyFc579cfUcWw9Cgu7v/P6NVXawx/SXtOoQN5rH7s+9w5qbEnNTC3PMw0h0SMPVtpQ0MVtnnLgKj5HDqn2IJntlcDQ87kHf+wzGNWk5rtiS8fQZ+byfe3/csiylSLFIN5byy/LVJpjGgzMg+ulfkx27geKMPzFt8srrGO7owtOltPqXIpXbJ62RNmkS/Qh9n/UoPYX2M7n4CoaHthlZUfsuSi5QAzSQx/TjBEZw4wWPcPuef2Rd2cZBZGWOZqShcmqiOm0dQPv5x0B0nGxBsF2kuUkEJjpv2kwh3uuedxBfdKXRCG39U2FDz7Cab1nNyOwSjm9Z3ZxnotK9R50Q/FnKK+ExdxCeKKVV8kge/fKs9H/nV9M5QxQNNpcYnElDIsVqoGhLVmHf6KHrDCkODrWVxclEfOFxLXlEqNba3e4wA4LsVh33GMrd93uDwDdknJPMmJtkLpeyHr1HcKgJCOcrNHjsQ4bk+hWHlYSmZaAtfNPTIC46C8fokbFeRngl0TaFTh52Qb/oMMRV+k0hwXRYkubx7nOuxMF9iDh2Ph7CZO/MLr8Yx+kKe9SkWEMrIS7WceUxQcr+cVBeGq6vHxV3VAIrnhGFpKfGlWWiXzFI9q2EGMykhMAW7eN1EIuTx1t4tF+KxzC6FVRHeXOpqLHnR2z5/xM07tDxk5nuGT1EE3XspDuV4mwBU5QO35ZXSgws19ngEcH4Jy+rcI3BQdCeiatX6uc4COX+asbiWk7yBrRsjfEzFjf95WdfnPw3sqEb4cluK2uTgVuEGLwS+SU3s87OuonxRBovO8idA9q
 VO5aGH+Y
 x4riOVHEpG0LgY5p7TviOWmBro6rkpwZ71Ku3Q37ZHWzr0LnENJn4yRJfesBn0uP+t6uf+2j42WtYpaGxxJDgABJOww81bViaq0JLLuF30AzHabSwNAbceiOljrSk/3eRKs4xXRXVw/yp2o8mMorHMTHnPLAQUa2QXOF29mvqWWmDa1bMeuvrdinEJeLyUSTXvFIIY4ZcdENg4DcrZVDeVuyrK7KC4VK18OgUvHf0PFHWFzEyxxfrlddj7fXAPKWoLoL6kvo/5hKKMTrVW0k8n9toxfKsk7SjTDnMA6len42czjvVT/0VTJ9T5SNO6IOb1Iv02ycHFyTWHBCkpSst57ZYmdWuiPCyRms4OvRWmy45EEtYAx1EJUuxxWWnBnv0bFQ/0acIWZicC8hcg0H6IhHQ3ftYGWXOXkwJiplkz5ONIFWuEuV1n6U/DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Directly use pr_err() in __set_fixmap() and drop pte_ERROR() which helps in
eventually dropping pte_ERROR() macro across the tree. In this new printing
__FILE__ and __LINE__ has been dropped because they are always the same and
don't really add any value.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/loongarch/include/asm/pgtable.h | 2 --
 arch/loongarch/mm/init.c             | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d73..a32a8fff70c1 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -128,8 +128,6 @@ struct vm_area_struct;
 #define ptep_get(ptep) READ_ONCE(*(ptep))
 #define pmdp_get(pmdp) READ_ONCE(*(pmdp))
 
-#define pte_ERROR(e) \
-	pr_err("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
 #ifndef __PAGETABLE_PMD_FOLDED
 #define pmd_ERROR(e) \
 	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 3407030f3e7a..be9b127daef2 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -203,7 +203,7 @@ void __init __set_fixmap(enum fixed_addresses idx,
 
 	ptep = populate_kernel_pte(addr);
 	if (!pte_none(ptep_get(ptep))) {
-		pte_ERROR(*ptep);
+		pr_err("bad pte %016lx\n", pte_val(*ptep));
 		return;
 	}
 
-- 
2.43.0


