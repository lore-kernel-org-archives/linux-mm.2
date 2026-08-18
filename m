Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A96C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D215B6B08C7; Tue, 18 Aug 2026 00:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8F46B08CA; Tue, 18 Aug 2026 00:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C351B6B08CB; Tue, 18 Aug 2026 00:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9993E6B08C7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:01:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E7B5C09EB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:01:10 +0000 (UTC)
X-FDA: 85113039900.23.229E4D2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7A0D040005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:01:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Mayvk+7Y;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omDZX1bufOD81zOaJjwGdpJ6E7g6fPFvf2RST58oZaE=;
	b=lUrln5ykh1W0GDQu2guYActyODp6HbqNMjv7Lx6CdTRbSU54AEgkOfSmmV7Pw+WyrTtjUa
	UNcdThb0PzVwCswB303xo3xGaxXumNB6LQX4vdB2rk1HtwjWvAKezp4AWmERyD2LLOW9pr
	qITPff/jBUVssG20uIaAp8LcoH0ICw0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025668;
	b=dO3XZdCHVyIGTE3vTouOGtdSx3uGk/vReHztx8MnVmOL6bA/aydo3FU/GA/qWduV89i2II
	4dzYcxWJF26iLf0HSR4TFtHEwW1Cinc4vv7B+sLbfPhPdWQddVpdlJ+dUBXJhWA5sWnycI
	bDaKqX1zk519QbwHDNV7NUDxg7aL/zw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Mayvk+7Y;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFC681A00;
	Mon, 17 Aug 2026 21:01:03 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3D303F66F;
	Mon, 17 Aug 2026 21:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787025667; bh=fvWsPm2RhovRhyeQja3vObvDm/dQnZu4xzhWldyViFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mayvk+7YyBI2v2eqdqjZoS2Z0dSe2CBNgITCjGmuVovDxkhyBaxSP1dLk5kNH1nez
	 idT86Nq/jZBkUaXw0freV4r8tdOSXnkHA9v9bqHpKf4rUtAsLWC+ksnp8Cx/gdMRyF
	 17IZ3guv1INHQU+zfmWJE2RLFpqbe6NzJqmu5VKg=
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
Subject: [RFC V3 6/8] sh/mm: Stop using [p4d|pud|pmd]_ERROR()
Date: Tue, 18 Aug 2026 09:30:39 +0530
Message-ID: <20260818040041.1891769-7-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818040041.1891769-1-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: y6yx6z34tfu6ot81jtjpe7jiuke7sphm
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A0D040005
X-HE-Tag: 1787025668-640745
X-HE-Meta: U2FsdGVkX181kn/all4w3K1SHwgxQri06jWj6SS/3oA24XQ9QYoiZi0H5qyOkmCa/DfRTiq8ee9eKgt92Y0S+7D68NsGNpaE+3wLKWmj02abMFJisfdRQtpLu1FmcYWVLbAnRYexM+quCMC8LhqwCVW+02XO6cqHhqSO+QjH4NTpIhGzdTKx88dPyiaLiABTxi3/p0n3Pw9PH/c3/YvMbjx3SKzXlyCNU04BOJlTY15fFHzb5htlptJrVyKArmmlOp+GsFTIodfzDdO1TFZE7p8RW1FbYsti/F6g2PB5e2c+UrDN95yOdBcR/fPhhmzMmuBCMhooCqNyv9CTqpys4XqUA7/YkEAD8U8lUhEmrolwAUBK4fWnTw9gq2Wlpg/WoK0buUQ0SnDblh3jn6sv93HetVfw5gtzOxdMzB+OI5D+r1vqGkb6Xs+ffV25UXfp5qmBOUFTh66emr7ASZp4PAMjxHvpAirlUwU0DBvBEZraW3R87zS5KYUvHZLTIIUWM7GtpoU0s+CvFNKl2gKwWk5/CPkhz1Rqjecy6ILsyYgnmC2fI4oXBD9qjPcTp1FJqnhc2LvXTNJZ86n8m/ncXqeQSwTxAveAP23CUdJPrBl5Jw+detGtcCAVtV2O3dl27gWqXYikjsY7oZglqeFV43pmXwBrmiatJbhB4elB0P1l6yf4Gdz7bP8Sg8QDa/vTsz2BAvCPG3upNU4AhdRJhD06dV5P0TkDF0NVKauI9pNzPp87oCCLkTCdEdmgFYy5iWRCz8LD1Ai4GUfCK7wBxIpXhR64VPgiEJgInA9pxisWD2/qSVhWxfhrzdqxew1mCo+4R1o01EJh0izW+MMwOPTI9qgo+ShjgiKrMSquSogyun53VwaQC/WK7Qvt41bSvJ6IdK/YKoSqzKNDCrwybAf2keLvthCzmK44E470EUJwghWZEJl+WHP9Receh9c7gMx4xdXhGfAs0nrkhC2
 pV7zQjbI
 14hUvKyGlTiCp2CZrAe1UBANfWbpFqSyOz3cPn1AMl4em30nDzKHaRi2coUOFhQ1WIHmjz054P2kcj7f+mJKRt79orSKQE56ELocvMjioxg1E7nzYOXCStIvvAiCCTvjIvJgV0nxO97GaR+LXKu8hvABQv6QWxsKRzlvOOkZPYNLFtrnT3RPnajXx3RZ5j4EaDOnH20ILhznlOwL/NBk4++jHtnfdQtzC5SEBsGfg/4YHuCbe6I5jEdqzKjnVxC3k6+BQWzC8lhTHjJSoc41OGhkLbpxAGGQAdXXqJZWamtgzGcwt2Dz2SAyPznMoO2MAtpqJloZDkP9BKE7Dp33pIj1iqcjiRoRG5peyaHyd0xtnvq8JTgbxsp4Za/6EpaxWQcPEMIwTl354DltzE/YGvaIAtdJ0DuNNMtsHYfHTrIDLCbFi+YSYvJrmbVvb9j/p3QKwry+uL1xQxe6ix/2e0BGQW7JxGdm8ljAr29HIIFSKRlsi/UcrSV0uyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using [p4d|pud|pmd]_ERROR() in __get_pte_phys() as the pgtable entries
are known to be NULL and hence could not really be accessed.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in RFC V3

- Added some pr_error() messages in __get_pte_phys()

 arch/sh/mm/init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 9466ae6f9f16..8d65e60688dc 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -59,19 +59,19 @@ static pte_t *__get_pte_phys(unsigned long addr)
 
 	p4d = p4d_alloc(NULL, pgd, addr);
 	if (unlikely(!p4d)) {
-		p4d_ERROR(*p4d);
+		pr_err("allocating p4d table failed\n");
 		return NULL;
 	}
 
 	pud = pud_alloc(NULL, p4d, addr);
 	if (unlikely(!pud)) {
-		pud_ERROR(*pud);
+		pr_err("allocating pud table failed\n");
 		return NULL;
 	}
 
 	pmd = pmd_alloc(NULL, pud, addr);
 	if (unlikely(!pmd)) {
-		pmd_ERROR(*pmd);
+		pr_err("allocating pmd table failed\n");
 		return NULL;
 	}
 
-- 
2.43.0


