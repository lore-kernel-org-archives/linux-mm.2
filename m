Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF84C61DE8
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9B66B00A0; Mon, 31 Aug 2026 01:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58996B00A1; Mon, 31 Aug 2026 01:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F80C6B00A2; Mon, 31 Aug 2026 01:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4236B00A0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:44:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C267B803FE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:44:02 +0000 (UTC)
X-FDA: 85160473524.26.A7A2274
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26865C0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:44:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=U0L19rtb;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788155041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8tEaJoybxgEHiydhpmRrd0zyZxOUOa5tuSqtahiLM8=;
	b=wAcoUE01WOcNl80yA/5kDK++SBdLAYyDPf0BryqTNyaQE5RkeMWjjdluWHIVLchs2g8kE/
	O3Dml7KFTXFAKoMzByfquXyUBTweAEs41wMx9Xy50N6KHSd0eKt1S3kejoizEBmHguXgUo
	P5kbnjeQBL4h5JAYyz9KbGtCBAg/6fw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=U0L19rtb;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788155041;
	b=hNfyM7U6k5nw+1ekK6bczCtuBxoxNPwKd4BcPMaoQ8jiqy1pMVeaypzYjYFGEr7cUdU9Ke
	gXlsoHvyC82DesL3eFocOgDiRL6pGRDB9PSv9gdR4S+dOEQUteOMpQs4bMESzYZg65BcNY
	i+VVFINC9EM1dyCGZ/mTIGAWuLB8LhE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CF061A32;
	Sun, 30 Aug 2026 22:43:56 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6785C3F85F;
	Sun, 30 Aug 2026 22:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788155040; bh=19JNL2aQ1m2bgjsQFbzvNHwUtw8tQlkca/Xxp7GPwo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0L19rtbEHy9Bp2X2iUVLKKtbExFWVCCT5piVe9NpoUB1AFhA8YHZQbH1wlPAPfX4
	 Ay2S64IR505XEPoJ0IN4Oh6nslmTu7PwulMz8Lw7NqgU8iCXl/uxnUPMxcESRtkCpw
	 mWcDca7zBkcW4qfWA9izm/4P351I4KVkwzyARqd8=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: samuel.holland@sifive.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH 7/8] sh/mm: Stop using pgd_ERROR()
Date: Mon, 31 Aug 2026 11:13:29 +0530
Message-ID: <20260831054331.625505-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3gesx7cq6aidwgt11wiacd8t9fzw15hf
X-Rspamd-Queue-Id: 26865C0007
X-HE-Tag: 1788155041-33176
X-HE-Meta: U2FsdGVkX1/uEGtefK5cIiPvqU5QKZ5i+BJfJx6Eh364FAD0cPP7PsDfKpDbWrjNZp1I97dlC+ZVNOeLaO4hA/acIkXjV6XnwS1Bfkfdi25ya4zjauaP6g5OZ1B+QqW7kfB0B/KUAO7xsU+XnpX1JUU2IR6pNLOyY244gwO+RiSuCxRqaGYsK70OfJU75BJa5baCZJA/xgMxrVVt4Hvp8nrHyvM8R+g4QIJbfkkPldJMVSMqKcjIK3ElqGgrqszGZT9jUGVWd90wza1ay4p9L46iKMtOPWSzU4Rqa0HcSGYkLhN5J70Sgki3mxI6SQKays7sMi0LnvKC9MFS9Zv9XVObESjNfxVyovunXEYzq1Ka7hlJlLJb3O9xFm8zo3jKwKDCbjSldsi65dBVtYX+LlQoTRgAl3haBkkOnmMAo4U3wRAv1Ydnz0pbsOh32JnWFhnJ5nyzJ66ENTwivie116f8g0O3SGdpC28rDSqWTl4ki47pZrW0XXXJkBEKDKxHvk+FeHoiSggMXxiFD46RZ4wOvA7KNaM+Zna+HR3csxUzUvtnhJbXJz7qYQ7DRcXstPaNipplk/ePr1k/XCxZIIIEwTD+Ef9UAepbX09kKYgTzBXWHWdN9/s7tgT21A+Z5ZgBUAOekkQID02DFor8/upb9Dcr51R6wefGHwgQRPEK0U1j8a57Xc63/5y2iOwXBYkQZocyjuG+XPDq7hSrpgA9HlN9//gm1lETovi4PkskmvzXuDnA93LYNn6RUO8qI84xsj00IMGy/eC45Q7ZAtkxKR59UFZbAayv+mt4CgzomsBchbsiW6a/ezJ51DM3k9fAX+myRtxBXj1PxhcM1UMskM82y7krj65EQy8duZXbzj1VKyct/zpQ7bX6jlTV8tYBjVqfZVO78AleBJjpjtsaeEAGc05CYgJmn1YB3XTYdlVx4NMcQru9hKFD0XhdwYZUpyKpSFfa4yvdKSr
 5rA2KtPz
 cFwKri26wqE6HSzXbCAI5wf4aGFQRmneKRgNUVGI8qoQFQYrwldv5kumES8xHrasm8h2nYSyIfgn7YfEeKxVvqHi0vImQ24SjTFxEuvxzeIzRz42ID6FSJ7Yg82gWydNPQu4J2CQUXFyvOpoo91j0/2lV2Z+PXuAIl+igzIKPQPcFCr2S1kF9DbNP7jNS9Ex3ECgvFj02OPjnQCO7XzJhlklQXb6DIzIgxQUgIUjRse7ELuNBXg++DEGOnAlZY8oAa589AcnQwUByoSfpJp5ThIOK78LNh40qgOeBiZVE11UFSjQRZzxZ5z6oP5h0eq67NqRLttwKXG031S+g9u+GlMnvgQiHeVGCb+0VDBTHwA0GR/4RaHEJyY1p/WryFYLsLrxmKrIqb7hjhbZjhoAwJJqF4jolAGRpLrwSHlU0hvQA8phAhbCBLKPVheWIJvpFrOtdIrvPnXlNMoFOH7VeEbQHoLrUxT4QEy3M6kbQl8JIKs35LOy/lScOAQ==
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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/sh/mm/init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 8d65e60688dc..93921109f4e6 100644
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
 	if (unlikely(!p4d)) {
-- 
2.43.0


