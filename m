Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A83AC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F4D6B08CA; Tue, 18 Aug 2026 00:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF88E6B08CC; Tue, 18 Aug 2026 00:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7416B08CD; Tue, 18 Aug 2026 00:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99C736B08CA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:01:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2D92120A6B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:01:13 +0000 (UTC)
X-FDA: 85113040026.16.CC65C75
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5DE50C0008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:01:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tc5newTU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAaSq06o5eLcDNJ2uS+etL1R98Fm8iCuW38Uswmm3gk=;
	b=BbxIQRPuGpcsVbY/VHSco3VBNJ6xx6xsRHrjr98touF4LhPO3gmxh2WbJzbzezqz78r0IS
	lPk7/KiQ7TJvhcs8MlYm7LV7Zao/UpH5mKqVj1gGFjT5moyzbip+73zhXUuGHgS3D8dFPO
	sNwZUztc5uj3mBak03GfBWZaSsmJUyI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tc5newTU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025672;
	b=Vy3t3w/lrn1hBEZyHv9UBZJ3GRRncW9ggvhmVzeWuLRQWR1x0nbmFM/yt+nyiF9CbSFbsM
	cclLbZ4+mut5iwpjqfvCZ0+QY2s71pm+UIgr+inNnSJ5QnJTJx7uFm4fA8mSzmBX9xEadj
	DHT2I0iB9z/DIuTgS7ozVPQVMVAjxQU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FB111A25;
	Mon, 17 Aug 2026 21:01:07 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 808DB3F66F;
	Mon, 17 Aug 2026 21:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787025671; bh=bPcYhQD4bzcwPSxJ8xkr0nWAdwCuI4IUaFLUJoGzm0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tc5newTUC09VdGP5B76jtkjpI9sci0rMLtuInHFPNr66B6IGS4L8Sm6tk4cwRiJ/b
	 5h9Qek1XhXsg75s765gvhzEXLlsEvx2RUEZ09z5Yy66pdJ94V8xeAxBFwA0Aq2SxNr
	 PoXj1cVq1/8qvOSP1sQSfrCVEOq/UFl8/jpp1jbo=
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
Subject: [RFC V3 7/8] sh/mm: Stop using pgd_ERROR()
Date: Tue, 18 Aug 2026 09:30:40 +0530
Message-ID: <20260818040041.1891769-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818040041.1891769-1-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wqcsbqgxnhc1a9sgouedjkqiz49kttpm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DE50C0008
X-HE-Tag: 1787025672-599335
X-HE-Meta: U2FsdGVkX19aEcIMdti0yebj0drYnoREhNIVnEUD+l/m2h0qaYwMNMS+ZZQ/y/4uW7CYixM8t9EkXgq2pwMO0+CPLGi2xU4JL/b3s4J/2prQB0f3qXrptGObk8l1WRc4vJWn3AdZAfP9b7uhjnqfCbsNx8aKjKreniWO+Aww0VSp0ZfQdCqm2xjn7AEkqQptj3mNYq7938I0y67vT14ZnGhbMGPRrxHaEwnMhsvsZepksi8wBVPvm1XGXSnMi2rO68swkrgXJqadHhVDHauu63wm92gxCWeQ9fFRoSXfA1ma1RJWYuPAMSWvM/xcKI5zemuxVkG9cq6vxOdLzlP2DkHjzDcEQiG0wWL6atUq4R0UzyHJZ/fb9yY9gb0mzNZEYs0+3EwGmVn4JE3bBmLZ+ggnPJq9lDYdIEzDfjYlvK2x07u5TxJ0u2tual1/pMRX/RQ6JryrBBq6mP8EDJBb1vFUvFH58cQsmraVNhMNCN5cILBCG1NUNoli57vpQK4n5T7WA0Z5p9l5xkPUfTRMUwSjo1zHXOaDhD8NT0hPnPSbzxF5vauj78TQ8jAcbYaLSE/Xd27W+MZvzgIM/lsKgOAsyYY3b0uQ9Srmh6UoDpaYj1EAaaOnelT53pxGekUZ1ZXTjSBpdd4OW6WLZL1MBVloRWN/hlWhMe3M1baI8A+gXFNhZWFwyoMOVf9WA++PZ5fDrTkiOJ1BNEMwrXRcQFXmsISbnthGdLFEeShx+Ps7QGYDHSmOTZgB1hnR4UrXS9aFZQLgDoaRpcseXakBA8JmJlsmkRHr7x5QEo95iu+LcmhBXLsAdIpXLa9FPEruezQFMqrLOovQ4Z1qrORPzPRwmBIFDKq2kuUeo7t8CeZHB8xCMzW2ZoKf2zkV8R3bPsqD8+zcKDXvVdXO/akK1LX7J1Vh5zL0/Cza6G1tWCVLqGdg2ayodwn7zIDYPDjm+06/KY4EO9Ao88K3Fiv
 zbIS9Oyj
 2sXPXM8gHfGEZBO2MUo+j2NI1SpB9mMddv9xHPlhfUDz8i1dQ+ZASlsr1XisrX63xJpT7t1bJLFFCB08fEr3BI7VR5dpoJcbIqo8ydpyE5Xoff/wkWrFHiLZ4Rwqg3mr+/cFSbE5wSao9oeAtjSulaSpHmvrplq2fIjTAUlsNL15tROQyhonoKH07XoE31+S5dcGKlrR2m39KNfNb652tsGjKZAbMjoGFL2rnXk+KoSfqkrJbU5vH4qR89mxgyzFd+ZsjWjMbNxSgE9+W6UHyN+wlIJZUzLQJk2ihoGQLN0IkjkhM5+YkWOUo/Y1kfKcDKImkFy6N6p6Nhz0N2lA8V0SRVkOWj38wzSE9WKRrZcdeH+NbUfJ2mpELUxSTtxzu0hOZ/n/EG8+fpiLCVLNy7Mo6XNgXq7y1y7OBjuhvwR4q/guxthfV/4rO0vrVJGt6kea4o24tAKjeUEQi9+5eDak9Vim/haEFDtJQuJ/clWPYxfqvB2KqHND3hg==
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


