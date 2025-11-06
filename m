Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F26ECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 20:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59DBC8E0002; Thu,  6 Nov 2025 15:35:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574CA8E0006; Thu,  6 Nov 2025 15:35:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491048E0002; Thu,  6 Nov 2025 15:35:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39FE38E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:35:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA512B729B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:35:31 +0000 (UTC)
X-FDA: 84081337662.14.D17B38C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 601781A0009
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:35:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VvYEZtik;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762461330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pMEHDSqG6YTOF4nETNKg8FSwCns4sylVGUUaZqvgdAQ=;
	b=ND1wccspxN6xJgGeks+VYqLmNY/+5/PmdwPLCYWTQLl6YhkN5sGZKBBm7P63X+glqbHx7e
	qlHGzZ5vmj3C1+4MGqxcOYtewLP1Nf30G43/QBDr1yC5wdaKGFxX7sNPZJ6rznsEpY2gr8
	M+yJuBaCwMjnkchIzOr4VW5RxDcyhmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762461330; a=rsa-sha256;
	cv=none;
	b=FQ1YKvfi04N/5wOJL/8f1nKr8Yc8Iwp145G2TVSB4GVXNix+j6EpQDvxKXjvr+oDPEmqzY
	mzE6IO70YNzr0gox8oFCmd4llvbPDw0QeRpViLvlMzNjXxkq4Hm31t1d+UKRW8p5chI6G/
	Pd0F+4ksNEpRVoMliiTSpCRmDfntDPk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VvYEZtik;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pMEHDSqG6YTOF4nETNKg8FSwCns4sylVGUUaZqvgdAQ=; b=VvYEZtike2u3Q6qSE3t4GjFk4K
	MsHakc/LWS9WZVIaR7/hsw7P+CP/kIPnX017eG0a8SsBMZPRVIL2KFLX4iPcZjcWcmqQa7p0OhUCM
	KcL+ao0EDd7JZUZcYwC8cB/IJJWEU6glpFBEm1jWspEnxgMj0YmOT/udic4CiVMHYk6pOTIh5bCGO
	fIvLRYAOSvqnIIz/IAqlgQMB6cxMLACyga3EThSOMa75E851fnvYqrWe1jXRxEhpYIk8GxJWD2IXf
	nzVmsPAM7qh81SeySYwdq8PMft90p3mf5+Icv8Cyg/PUlg3+I5UgVDCKTLgFtWiF9U4pwKXK9s21b
	aC/8cOYw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vH6hc-00000009w9Q-2SNc;
	Thu, 06 Nov 2025 20:35:29 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH v2] mm: Constify __dump_folio() arguments
Date: Thu,  6 Nov 2025 20:35:25 +0000
Message-ID: <20251106203526.2368275-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 601781A0009
X-Stat-Signature: kcx9143643thjzmgk6fagk1bb8et8wjm
X-Rspam-User: 
X-HE-Tag: 1762461330-130480
X-HE-Meta: U2FsdGVkX1/eyH7vxP7u1h1Jp8zDASkK+yHAhb85GGkwHa8Dgs+pLKeGmXJKEATjfZVKLeNpRa6AdRhMqvRVBHOd2uBs4ioBMyDYtDVUE/NvraZsrtPwrT0L+mWsdc3+4V8IalrFZWLiJFVvZXaFgZCi8zpNJ2qfnHyUJ2wNk4jqtWIh6mcRzMA6qgKBzAGaEpk8PMZVCrH5ozEVzSJ5Jarz7XA0HzRwCogEcUgoijsVPlxbk13zwZvPkSQBnZaMbwF+mdQb0gXLyUJBLfrDfd5JYGkmLd54XSJY3NEimfd3RvHXzTioya2yb7xfIwHWfHEXspgQcr01Z+WU3kWgz6YHUjkpQ9ZW+j5VUunAoTe0pLCU8Ei7SQkLXaNnxPqW7NsZXxHFyjytdqIYHSaND6Iovxp6CJxWo24Vqo9oXNHWK21spioFkH7CDqPEsfZLxyjFwMTUbDGkF4bhTyRs/M3pR5HT/nIUm7e0sVKkK8klkAVd9+woOKVmZ6FR/GIVn8GavxqB5H7tRbO9PLmMsVv9x8BbdrV5k17fSYW2y+ixPQ29rW6Jk0wec/gARq8JX2AV880uyvWjr3EtKVMEKUyyS4M0CTvAG8ISg+xh/kwyUq9xwoI5inWEogW5hsqOh9qktLdZ87t+2quq/Phb/BIjfd/PAb3ZvfGKqNhHHqpda+PkD7183F65Wn2hgFxIEpfAXUSQrOLXeK4P4+PX5/3jz+qm1Fs2K6MCvyUDUE2iK5SwqRdEl2f7BybtnheAyv8FsMPS9eFDAnJH0654IshciihN7TZOk3wX91VU/dA7+Xf9Qyy3TXAZcUrYkCYy64T0SA+xsJZ9qJpQc1v50bEpYbIukU7mK3TofXrXDw/cSa+q20UTRk6jnnAp9oCCsTGV2o5JQJJRL35SC38Wfp/O/Gr4AVI+pVTWxeqYS1BLIFOCMSOUL/Xw2+WBNkpqQp5Z1YNQU7MTEdoMgh7
 ml6wOhml
 OlvkMset9+Z8IjPv9Bfsq2JjtMEkvpiA9b6Lkk4oeMu5FTmJcPGzgj8BRUfdI9D7UhgEMZWZvQamNjUhuw4qofR1QEOek4uydImwmMQqzWj+cWvDqUkbFCkTOTrrdgDcjE02p8rWW0ZLS6rZs4TZIp9KomvRCzHgk6JJT2ZZxM8pNHv05/2OVKZ24r7ypqNG4RodXJXer0l4Ot28XSLwMrccpgfgKZvU5v+9+YxWlL2YVk7+mw72DWMKjdzVZqCH0zF7jLyTlmSRI4ZYfOUIL/xc0xcDTPqZfh8lM0iH5u6ITidGxykXT2c5MMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These arguments aren't modified by the function; mark them as const to
help the compiler.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/debug.c b/mm/debug.c
index 64ddb0c4b4be..6513c858fe50 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -67,7 +67,7 @@ static const char *page_type_name(unsigned int page_type)
 	return page_type_names[i];
 }
 
-static void __dump_folio(struct folio *folio, struct page *page,
+static void __dump_folio(const struct folio *folio, const struct page *page,
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
-- 
2.47.2


