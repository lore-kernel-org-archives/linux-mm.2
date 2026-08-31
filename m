Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11FCC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B836B009B; Mon, 31 Aug 2026 01:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AECE6B009D; Mon, 31 Aug 2026 01:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5767A6B009E; Mon, 31 Aug 2026 01:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 295B36B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:43:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFFF11C1CD4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:55 +0000 (UTC)
X-FDA: 85160473230.15.C1C0842
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E2CCF1A0005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jTd9KjtS;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788155034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KntaQece5KLPwg54O9DJOAVj9nRdl5PrfkBK4M6L750=;
	b=uY+WtRU7d87uI1b2Zgaq7GsgfVbkS5vb6YX7M2WuvXrx0kp1+D9m8ubCv1j0Eqp+DwFnxz
	y/A+HEg6Y+VF2fj5MrSR+wpL91UO7iSzaDyktBBNzttK/zHJ72mNnUXIpurKv6DPvQstJ1
	bcDG7GzJKEMZhwQS+MSBuqWUTfAEffo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jTd9KjtS;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788155034;
	b=7D/ak+tZsAXjMF1fPh30T3kNwv0n3NP60s2xZa1HbTbTWqPZAGuSohvmkT443l4ropTNMz
	7ymVe6rJ7ult+YGwZaNZMkkyp1DsDtTYmiLn3i6gfjRvHQ33r3hCkq6S8L4WMzOqeeoGYq
	dahaCrNslIGOTvsd2cfKBLgftSzdsV8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 394E31A00;
	Sun, 30 Aug 2026 22:43:49 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4094F3F85F;
	Sun, 30 Aug 2026 22:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788155033; bh=bACj7yeD3kQHNtaEo3qPM/7pYVMQxld/GWsQ0raGU14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTd9KjtSO47ZSa6Eegu9Jg3Egpfu6bTxJIeCEbbBs9lqVrJh/QwBdWqQGOEmVP0OA
	 hcTTxkZT6fAeEx8haq4FYbspEuUlfOA+P6q6eaBD4749BBYDUsR3ASLkC8OBZT5DoQ
	 0XYYCcDmZkZUnHFkXTJfrC1qadu+n2mdWf7vuxCU=
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
Subject: [PATCH 5/8] sh/mm: Stop using pte_ERROR()
Date: Mon, 31 Aug 2026 11:13:27 +0530
Message-ID: <20260831054331.625505-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: opz4burjx95ptgf3ns8atkp9dyhemigb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E2CCF1A0005
X-Rspam-User: 
X-HE-Tag: 1788155033-426595
X-HE-Meta: U2FsdGVkX1+eNtcx+pd99Sf8O0v4TLNDCKw0A08kkH3rGfLRTLJHdkNj8WKVXFp7WQk5XPxYIF4s00vX+Ndw78QWeIOpKuBZ8G3cj6RPia2gihj4zLqbnyEYdlJwUdrEhUjVjOmkf54WS8n3YTHBID5zh7TPZPwWR18rjzdYySAnhok+Rw1XNVOGkWW6bwyJqO3tvfrLWOjdD7e2bLJGpYsNziM9EyDR8q8LRMolKZbYakdBeAR7QBl5v9cW4kSHIjMlati6tClXZrMNPRpWym6plMdRQkYO9lqvB0lrD8cGZRqtVB59AqM7mnnFkenVGGUpWxCOVLR0TU3ITO2EfkQvvrd+6nM5uhc/0uwgHCHahp9A1664RLcq/Z3MI0SdwTlgNw39yhpIz1SfUFhbIZgLgUNOMWU2NnlnSntvy7ssUusZdqe//RFvmx0BpdIAJrH8VWAYhDS360Fzsb5PFtI6PedUiGPTiAT2FWyiGZqM5JyBeNvBlwoaT+AhGBTTPt6/eQk8HQy80VVGvG5g25eB1OCmSabiRetasgDLkqM5448Z67IlOEPImC06sWSZDkspHkt6PQScjK+fb1E9dMCQXju+A5qcDbLRBpoyKy0hQY6/YHQCA/uV4i8d5nTVtG4e/BrXRMLnUI+B2ne3cLpxyYaW90SVzO2KOTccE1glqGiljZVUlqq957rhQWcJMK5uU8uVRtmWWPxrYM8ZD11NgDSmXFVzrU6pXw7fuvgHp6n6WTRNx1KLq5TF0fvXsDORJkrAoXIQnQXOQOqbwhbDURrH3JPOkROjJSZudhU7rfc9b6B4XZbkPtnAFfxbp6HuSQ8wN9/woXL7UAtv1j3hSSdhdgAl7KBXHIOrXuFrWCzo+ehzuu5QcGPuSIuhwvIm7Y+ePO++UhS7rLYYSmEAN4XIkutxDUDE7NvHvM+WAJ35rvmCXBuaXOMHRT8iSDVN+lQ9cWNHQg8CqQQ
 V5pyyVQ9
 6FphS0psa5IBTeZwGKasFMdn0cWqkmce2zDtgEw2E+u49vagXUzHjQeKUpeuebQMKsCqFRBzRi1DzjwlOwFsD70xJLkJSPIjCTCoi7cwwc5eFx+BKdYaOIFxrFubsJfYliNcAo3aS6aSpuwKPTEj4F1j1nMaVMckCITHRbTD/thfN1oKRCDyqPFlXQmis1Kh43FJOuCbzfKs8/JPH0VACO7zu50ZoTFv3Bfv03SXGjUJpojxeNUZsrpNdGCov3kmQKEbPgKD716s46xhteFF8QsV844cHzj/+2Eu44VfTYO09uCI56fmLNjnuHxcG2DTZOw0E+QtBNDMI70SwRyGyB3Wa5+ap8uV7sFJjbB4VXZyuAQVTiGjfwgAdjthrha1Ku3a8O/SUr2X5xONsE5KysJeYFOTmL+bPesY41sHGtKC9TthibVUX5ldRqfhLWs41yinBY2zjxdlAKl9PrEWHxhTQV8n87JbKC2S6JJ4K5TJoy7kHTZNK4pnIXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Directly use pr_err() in set_pte_phys() and drop pte_ERROR() which helps in
eventually dropping pte_ERROR() macro across the tree. In this new printing
__FILE__ and __LINE__ has been dropped because they are always the same and
don't really add any value. Besides ptrval_to_str() has been able to handle
different PTE representation with and without CONFIG_X2TLB, which helped in
unifying error message printing.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/sh/include/asm/pgtable_32.h | 5 -----
 arch/sh/mm/init.c                | 6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/sh/include/asm/pgtable_32.h b/arch/sh/include/asm/pgtable_32.h
index 5f51af18997b..c8eb9a7a4c4c 100644
--- a/arch/sh/include/asm/pgtable_32.h
+++ b/arch/sh/include/asm/pgtable_32.h
@@ -401,14 +401,9 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
 #ifdef CONFIG_X2TLB
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
-	       &(e), (e).pte_high, (e).pte_low)
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
 #else
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
 #endif
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 110308bdef01..9466ae6f9f16 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -84,7 +84,11 @@ static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
 
 	pte = __get_pte_phys(addr);
 	if (!pte_none(*pte)) {
-		pte_ERROR(*pte);
+		char str[PTVAL_STR_MAX];
+
+		ptval_to_str(str, pte_val(*pte));
+		pr_err("unexpected set PTE at %lx in %s: bad pte %p(%s).\n",
+			addr, __func__, pte, str);
 		return;
 	}
 
-- 
2.43.0


