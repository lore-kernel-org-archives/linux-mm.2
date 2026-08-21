Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18208C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4DB6B00A3; Fri, 21 Aug 2026 15:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86526B00A4; Fri, 21 Aug 2026 15:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9BC26B00A5; Fri, 21 Aug 2026 15:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0FF56B00A3
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B118140258
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:52 +0000 (UTC)
X-FDA: 85126259064.17.941165D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id A67F514000E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rhhf1W07;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340410;
	b=tt1qjrdMdxPhhGKOWMj4TC6Vwxux7LKotIVRtnW3/9yPTKeei2l7aE6e4ePPCH12aykLrP
	2soZP+Cpg71pRSNqQ5OzDtWOhli2WFt9rPMLOWYZ3Yc4dwigRdRlF80arEjwzLmtuhgkah
	iIbr4q8iYMjIuOjTpQrMd9HXqlckd2s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rhhf1W07;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPfPuTck0yc0sCY/+xYg9mTu/vOl9PIPQA/wAMsFBps=;
	b=rdyFStViE/n/GpKRAsgZ5cWAcqYiwSs8l4Llg1MqZjSFUOksbie6kDNrOxXkQ7DxR+ph4I
	ixdv2fe3Exi7pR4Prjq2gJCctcaB7q4toa/KX2CNlsKQexLGjdu8yEClpI49PSVr1ggXsZ
	Y78DBfq0MjGE3Nq1HRIxgsqNHpolkFg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hPfPuTck0yc0sCY/+xYg9mTu/vOl9PIPQA/wAMsFBps=; b=rhhf1W071Rr2NkkyrSQzYJw0HA
	JTRL7EPwtrSs11Ff+RqwJd+SsfIdB8fNa6uZ6jCKEPsEQcELxmyYWKd9PXIQ9bCtz1eqtaGsdp/UZ
	idh9vSbga4Rbqfb8c2TjmNjEZJ6MGbpXuOAWBFS/VSmw/x9va6CgByfUhAtwYeMKy8j69NoPDX3Yx
	W7+kpt3gqug17Yu9a8xO6nSqsCxu+P8QK9MNnMAkRMdl5grvVuiawxn1pgToeazEOgKYy537flLgu
	HdevUMjnUvDnzfd2sm8e4G6EuorprhHOyfB9IsmbAbYiVO3GcNtA7e0cq7Nt/BC0PqL/+ZT71WVYV
	dFCn0HXg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUt7-0000000E0j6-2HAk;
	Fri, 21 Aug 2026 19:26:49 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 06/19] maple_tree: Drop MAPLE_ALLOC_SLOTS
Date: Fri, 21 Aug 2026 15:26:14 -0400
Message-ID: <20260821192627.4085470-7-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A67F514000E
X-Stat-Signature: fus4xz88fwqbectx56aemi3m71nd8agn
X-HE-Tag: 1787340410-902816
X-HE-Meta: U2FsdGVkX1/dDjT97JalNUIctI91DwFrMXKRjmlrNxlX3NL0JSSU/SoUUQAj4f5Oh4EDhQVvDI4QjVaN+rHewM9r526AjytDplar10ufhYEROqWI7/5JeyQPxZcmJpEf1ZyTDcFeFmkKfG2emz3Tan2BiJQ8XM/9TgKrJgL3b/EFtYCfjAiYcLzP/OZjAUfRy5QJQRDnYpbDahGQrMfWLlE+KxQtUf0SLdEm/Z+j2VtbklZN6EwfJ29fT1lpvxNgJcT0R4kW+IJouuCJedOArL8tlb9IuXG8UUbrOnOUO3koE8mn4boRbGUwqpD9T4oXwy1Iohbd5sXr3okOCIr7tUhJU8vUF0xubk4sClppHwucq9doh29uC2n7RzNGCrcGZL2NaER0OQk+iuypsTkdY2SZlM4ndugXjbtL0bRcwNGXS1zHeHAELXYgVIjBwNNkHKW6QKQz9b8AbBNK95Fx7HjR3IHRUzElRi97Fs/4w8th79JR5rM5XL7yGoW+6z7AUSAAz58N98pvXamQrhXvktjPEydVR0ZT9pdJB6slGDw4SIM/FG3OLAq1IC8FCwO+bGa930SC8yPlwWhREvh5u7c4e5kBovGCiUb1HPVKfr+wBFS0krxPmlnit8zB2lqmXEYA5/x/SjG6Iv6KZUfSycdBjOfQ9syU7JiPDcYCJVUSwA0kFlhGRqq93XCIv0inGktgNSSEzySBvnyTze+nn7oUHUzKevQJ4G9P4fsQ0xzgBZIiTXB7TwuP8AlGzy688VzN6HZ5arr1RtUAb511ifKJjrGX4snfwjAymjkKVQ/0mhaLrQTyXt83QcSY1kljSN/E/KltdaKO/3DNFpZ5SoHuJCX4dWykB8PUIP9mcOpwP1thUzOPHi/+/Gtq/t7pUmszjT+NCPXXEQhVAc7I607YE8mpPwxTPxo5fzVvMxJsYNhyCLMLqjCnvJ+brPHjy4g5WIC+0zm0JUPS9u6
 z8/amVbh
 c2FPjpM14bTRMhagpzjFxPkMobIf3ZIjql21r/bGQ1QFCBemmo+jLAqa81b8skxjKwDkq9tjZFD9cQcFerpo5oQCtlq7su8uBfpIFvRgVu++sqIbLZn8l8HLBlJM8/Nfa8wNvXlIk8y6xj2IaOQ8KUlMkRAj5jGEKqOjtNlHfQny8h1lc7CBdk90m1G1BvT20OnoBf85zkKi0oiomsZ3lW8EQJNhP+r6+HzBfpzN1wI7TuIiPvQzDgLJNdg6yKrKTcLHG0UHhl55A6O3ZnEwrbfEYjYJpVfeTEsx34pyLNpFHbTV48LycVCcr6VxGNzlVdQq8zCZ5mwjy0Qj8Dabjpzp/9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MAPLE_ALLOC_SLOTS is no longer used, so remove it.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index d63ac92208d02..14ca9ac775d99 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -28,13 +28,11 @@
 #define MAPLE_NODE_SLOTS	31	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	16	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	10	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 1)
 #else
 /* 32bit sizes */
 #define MAPLE_NODE_SLOTS	63	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	32	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	21	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 2)
 #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
 
 #define MAPLE_NODE_MASK		255UL
-- 
2.47.3


