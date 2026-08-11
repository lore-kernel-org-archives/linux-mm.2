Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD2BC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125EA6B0098; Tue, 11 Aug 2026 00:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE846B0099; Tue, 11 Aug 2026 00:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B136B009B; Tue, 11 Aug 2026 00:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C75236B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:21:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43478120364
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:42 +0000 (UTC)
X-FDA: 85087690044.19.23CE641
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5E92B20009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NDnTBVj2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=poodNdxA7WPULNKhYdttvzFWmhwiFf+VlcVKFtQPX94=;
	b=UjrKgIr5jgjEjkYgx6D7W6KRNEPkw+djSMkbQ7gCy0j1dswAcXnYu6okNZM9ZzYjSWsk0R
	8ZZ6OPjVM7SOlVmx0XWrrcZP24LY7C/bWr53CLCqZ/La1oO7O2YfS8vgr6/22yXYxQBMzv
	RetwsgGLDOgI9WqjdjF/bfpPjmKQ444=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NDnTBVj2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422100;
	b=bST8laaYHFyonVq7dMH1J2jVDNinmKrlJ+8M/U2KqHiZBOhFFSRr7ODSLJ9V/s8n35Gno4
	yv4OdL/tuNfo/sQZjGZ7Xu+TSUDbRqJpYp9UWxjJuG4ZWG5GDBmhoPTq01XdTXIVJ87g8e
	vQ60twxkJNCPOlyPOmGGOuyCLf6n7e0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 977B6168F;
	Mon, 10 Aug 2026 21:21:35 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD6F33F673;
	Mon, 10 Aug 2026 21:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786422099; bh=OKKk+J7eMHIWw8QjhuEJW1LEtsSDjKpxvNzpv83/ug8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDnTBVj22FStQ+XK0HLwvJKJro3KeX1TWQm5rzPJ0S7csuqOhawi++Hc637b87GPD
	 Hvinpr7iTMbSodkYtTOTqdZ/yXYwlvbKLRTdNZffXQArm0ptKBDdXtxSDLXybURVE7
	 0SmAxajLRK1u+03/uA3LFe6J/WvE1OGUYKFOsK0Q=
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
Subject: [RFC V2 4/6] sh/mm: Stop using [p4d|pud|pmd]_ERROR()
Date: Tue, 11 Aug 2026 09:51:17 +0530
Message-ID: <20260811042119.3652929-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811042119.3652929-1-anshuman.khandual@arm.com>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E92B20009
X-Stat-Signature: hd3w76udnfnbu4q8mce9np6oyritxhbu
X-Rspam-User: 
X-HE-Tag: 1786422100-399941
X-HE-Meta: U2FsdGVkX1+icRJL4MdLHRf+oCyA8qEu5YkbQT/kNTZ0j1HbN9RYKj0wcEAZYZHxWZ9kDH17TlnCFygEQbLc+D7DHMzkx3y84tYYTcWdgGUJWrXIbwoeKBSkgWB10157ijZ3x7qAliXiWcYkotK8dZXYfFGJ/FVVHE2vAYPv215dXcPqV9pWh7VfVLtQZ0XKtUda8DwGvqqUMXGMLJtcGVkEFhlAlhEQ6nO9duixvm3lb7H9AJadhXLHblgKN9Yt/DtMqlRKA9m7G64dq7jj9tiWXryA5DoYcQ5KaUSk2Pyt3tAKMmhVBT85pyuELo0Vfu222Vzen7llLh01FAz3dLgTvEiJTrX3vAe57NVAM9FKd8oiyRmojlATtLHhzaSV4RsjFM+cfIkamuMtm9BwXnxNo59qsXdadTsGXxIXgmB/2ZvQGldHgj7qjzyqHDVSuU18yLboBcrQNF0Br85KPgPx5pxu3j/hbzv+TJdgmZp55KqKOWIoBSrYJtnFz+UHs+BsNLmDiPyKGeqM0BE4QkNGoY3doftg2vNuo6dD2aT32cg2LI9vIbYhYo3Gfxlv+q6NtWZE58C9iUKTp2U9TIsYe8J3I74ubwY6AAnH8aSp8317IPkyTOK90+rYjyfTLWr7As1h04BRJQsqNgnfpq6/FsrN3FiuRr9ebA0XhBozejM3nt1JWSgt99OypjAkkXx6zoFLUbWm7Y2aI82jJmCVSw0fhyUjPKtqmaXJ/ea1OImccILimcgHk8RX2d4+CNSShRooQySSIzj9ExmHZSl64PHElTGaptmuKrTreWmNn+qd+10DwO7rQO2g6VNcBQqTHZBBBYhsZXE3v/xDBrdMXIO9aff79CK+pNlv9mEcNmkV60hK/deRCHV57V4VXQsb3unf+5sI9Lleaoxx6fAbe9KjPGEmBU1rIDjhAxa8Y55p03787bmtROlS7doXNYWaXZ9aaV9NUM1ZDlC
 AcHDJADx
 gkAofLqONs+Y3P4GPejKRQSMvEbk4TbDTZBykofiYlTqudjyR/oP2oXWoUKzoGcsQVOZCrUdmd/kL5/p//qnV7pHc2Hd+wePcajXALBpngv1rdEYPZaelBDgDapxVrRzITC4sqPVfIAAW1AVPLumQBZ7Ykjx2fKLx0KNqZQ2PmxRzWXJ8tx408sCIelOhYFm7/e/yggr76KrDU+Mr2ff6xevRHffvlg7FkCNpkOPbSh9pLH5Pa09PUjlclyRXXreQzWQlwZaEvhFFxdPYFkLKpbThCSLg8PPNzo+iXPBAfw5KWf63+qVEzB17HjoTIErelr2J3X3mje4TH+UV+stiy5w236+S5Tvn6p5SERG0fDqkd5JSPoN5y7wINdOKB67h93ATi49fJ8W3sQTpeMBJZLHtqukpr/GY5RJ1mmZGp7AeXJxaDWw3DyYGN4O1QnXoNVtAFuegx+c95x2Os/S+4hC2ArRlHaOD3l0LA//ty0xUqNbAMrOg7Yjs/g==
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
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/sh/mm/init.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index b3c7fd84ceb4..0bb8555568a4 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -58,22 +58,16 @@ static pte_t *__get_pte_phys(unsigned long addr)
 	}
 
 	p4d = p4d_alloc(NULL, pgd, addr);
-	if (unlikely(!p4d)) {
-		p4d_ERROR(*p4d);
+	if (unlikely(!p4d))
 		return NULL;
-	}
 
 	pud = pud_alloc(NULL, p4d, addr);
-	if (unlikely(!pud)) {
-		pud_ERROR(*pud);
+	if (unlikely(!pud))
 		return NULL;
-	}
 
 	pmd = pmd_alloc(NULL, pud, addr);
-	if (unlikely(!pmd)) {
-		pmd_ERROR(*pmd);
+	if (unlikely(!pmd))
 		return NULL;
-	}
 
 	return pte_offset_kernel(pmd, addr);
 }
-- 
2.43.0


