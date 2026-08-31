Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C763FC61DE8
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F516B009E; Mon, 31 Aug 2026 01:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9A26B009F; Mon, 31 Aug 2026 01:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B7E6B00A0; Mon, 31 Aug 2026 01:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFFE6B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:43:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05E251403EF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:59 +0000 (UTC)
X-FDA: 85160473398.26.CDDC7CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5583C14000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mexQGEwh;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788155037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Na0nWqicnS2MtEk2/ZmNefkrvxhUMME7xzBfJeHlXfE=;
	b=6IDRZyIDs9IUNPQ6A+LbfGboMWiCDAILX8brGu9ruPdNe+KIeuN5SI5N/qXDAAzeA7Dcuj
	0Ztd2l4QPNmr7cGa1pklVdkc84vPJ+PP/kzqdnh/HjRy0WBY/7oX1fKyJ7CNOMJ4Z5hf64
	VgFJgmOiS4JNKExNeiItOOlAyH8cME8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788155037;
	b=ExN1dFPcgMXcZuoQjmr7NQEqbz/PuEhV+xJk5cJ3B2rPvuGvNOS1OXz4bU5EjClvAtoF9z
	7V2tWHqKR5rDd4L1WAi0wF9ajQv+VR3+xG5suT0Gckkl6jR4g6zWrD8+62UXun/yzwUHtA
	/Eg2d/1zTwW4z4EvhlzCVGCJgZ9vYgI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mexQGEwh;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE4A51A2D;
	Sun, 30 Aug 2026 22:43:52 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE08E3F85F;
	Sun, 30 Aug 2026 22:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788155036; bh=tv5DjbtfmXjBBuL3EGYgZEMiDxUCxKafhP8IwXphMBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mexQGEwhHQAlOrXrZQ25kdw0Ek/wBEDGfOAXtdmcIVany4CjdRHDvTRCAQnRszXkF
	 brFCVNYJ3wXIMOzy/m82CHQbQfsZL/9752QXUP8CK+p/FFq6WUSn/ton2ZHgaAcI4A
	 mipdr60mJO12jxZ7sxfPTPRFfT7MvotJi5x09tSk=
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
Subject: [PATCH 6/8] sh/mm: Stop using [p4d|pud|pmd]_ERROR()
Date: Mon, 31 Aug 2026 11:13:28 +0530
Message-ID: <20260831054331.625505-7-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5583C14000A
X-Stat-Signature: u4b9xxokm7t6mabnp7ho7jmwfnwbgj6h
X-HE-Tag: 1788155037-226037
X-HE-Meta: U2FsdGVkX18FgNU5JTcEoZ+nuan5uGMAEOZz7nIm0Type8fTr29ncgSyFyrrO78hXkZ9x1tExmmIzWefY8cXGCGN7m8F0VG4glWAwzljn70IB4epgNZ/IypC+I1WYsVs3xDzs9skr3dPpVA05HgY+EhIzx/b9S1FRemAVBzH6kSXAABTw+DCqx+HidpNlp5pWCbyFdmypgCxTBJslz8ZXlBzUqg7mu3evj44IFMNndCZ6L5PFUDOGIgYhYC0Y8hJjLXeyLo3cQMve4td3H9++eQVGe6YJ0FT9hWOpCdxBaOJ/ztBAPYSHPPw0fI9zsCm0eEaE+byHa5MSp+AV9dX22B+7CRAH8hC1qW+Jimox18KjCDVwlmc52A/fQd8Siy4iCG5qZh1VG3iqlOCYUvVZXjlkx6yq+7FNZLQx0zRpPHtlZXhEkBgeCOnTXe/e0CeYgXlQP4x55WycER6mnFG5UdElroWdlqn3YmAbF4mOZjR6Xuwk6aZFJvLEsPF2D9s6jkRuVzaHNX8ZluMMsLg07XRANRkFEcx6bzJmbKD49eZnwBSwXlN/YhSbvso/e7Q1q6//KABf4WWxHEzh9Y+zOBepyxXDVKsXH1DqGYxqJQI5tJr6LZbnVW0r3dLqi0Zu3sVMNHc897Rd/sbM4e9ngf4gwZVaWeDYH5QITjZAZcZ8Ck8pf3jDl2Mc7F2exp+/Uf/qO5UaP2H/Q1JUCyXs23uo1SxT/r+DTR3ksseEpFzulUZZcECemJ8CKImrPELplsYWFTgifxJs3wJEosvgEYSDlFjiqryMq4fetduoCOXaG0SubiGPCxk+61q5vlt+DV6fzBbizccaiyLkbAr06jRrr9ghGpChP/MkYj2gW5DDRtzXeTd7yuHoxQKIhdOnlvTYLgenWNNogED3cX8rFeAx+DhL+Vp+GTDgiUwrxgZBZ9hXbYhCZgS7+rW6nR4gJeUdzRqerYZ2rEg82t
 8H7w5e24
 2JzsjxKp7/s8KHlB3TgoV/eTDBH8oXVOXKVy+xwM86WJ4Lqil/k3ugRaspOq+lZfC+Ru7AZ8bBSp9oO1CcCRfH8RR0KABXs9pgxRuHlWWBiqGlbEP5sstGjkfL1pk9DI61ETKxSlfXqKc8i7XE9wM/nXpp6uBxXCLyIDu5r2cUzQD1zf6EK7vJtj60aLtalpQmp+xWSPamt/SmjBNHTXGsrB5hgNUoQZyT53/QbHAo24Lxhcz9TzcYZKOl3HHrh/ieUJBEzEAlSYL9R5S+uuGzuYe98O53yKfxEhgUu63edLF80Fv96/h4OClc1Nll4B/XLsERCdZI9UmdHFAc4om3WjBw5wU+OzZgH12VIs6nB6uoAnvfGoqC1I6yY7ISPci+izKp5j4gr789B6lvdYH/5+izIFxQoonG7pGNaA/VOW8pWqDUzb9WwSpMwQzTU8n7KDISEpROD1cSGfmHP646Ee0QbJfrXSq6cA5K43+gRRcsPOETxT8+GP2aA==
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
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


