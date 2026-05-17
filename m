Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015B8CD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 12:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA1E6B0088; Sun, 17 May 2026 08:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355946B008C; Sun, 17 May 2026 08:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F70B6B0092; Sun, 17 May 2026 08:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF466B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:34:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A152E1204D2
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:34:54 +0000 (UTC)
X-FDA: 84776856108.06.16F8331
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6AA210000B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:34:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D4mCcZrE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779021293; a=rsa-sha256;
	cv=none;
	b=8TU8Zx1se5PK4R5mSe5Izr45NlTZY96GNjZXM3L1try89dtmf4Q44zY3JO//p88S7kWikJ
	WY6TRQuYQMBcMXz3TiuCo0JKbDXaXMR5f2XfFCc5mkLnL0zjPVNG4cd1a7wSXrYHWk1shL
	rG4nredAz6xIpA1VT9IAq5Z/7IjaWe4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D4mCcZrE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779021293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IW9Thd3mJQUBbsTDo9HU+1EAUl3feGX5J6vER8Rm0Ho=;
	b=N6oSujGK2i7mFYSc6dMwdXeKa4cksSZ9w90w6P7UyW3gDjTfiNDSkHCrq/dOXrqv3kz38e
	Db8dXwrtClMrw0yrr5h9HKK+mNJYsfh8aoONohzxjHTFGacXR6YNgTlt8lLk/04ipMNbJD
	dOMajEzwCpkumY6wa3cqNUQeRHIsff4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779021290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IW9Thd3mJQUBbsTDo9HU+1EAUl3feGX5J6vER8Rm0Ho=;
	b=D4mCcZrEqanHckcYWGupS64JxLKoVFGHc7x+B1rtw4KHnaRFAvaFnJmMDFoioAg5A4CGl/
	uwaUL7v0PSokXk6T8RO9Hpx0jnPz9nA+I/WaWSNdH5Kth4dF1mfjHmok+M3tg5avgYaJ05
	Jf20iKvL3hYRbtGlJAinIf4q+F7gGvU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 2/3] mm: add bytes_to_page_end() helper
Date: Sun, 17 May 2026 14:34:30 +0200
Message-ID: <20260517123428.1181981-5-thorsten.blum@linux.dev>
In-Reply-To: <20260517123428.1181981-4-thorsten.blum@linux.dev>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=675; i=thorsten.blum@linux.dev; h=from:subject; bh=wMMu1MoxZqJP7N9AiF97VStohM+BcG77XY+Mb+mr4Ow=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmcW28GFa05q/H//lW7k2dMapocVtqKTLB2WOOTsZhX0 W+n0hXXjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIiwHDP6UzMpO7/m27o+mg dtDvmamCkpuGvUuc0l2pX5VGM873GTL8Zstb97/ulflqmU92HyTf8eRc2bBNbod/cPWc5+/ljx5 4zQoA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 86wpe9dczhra1y54ed5ioo3go77mau93
X-Rspam-User: 
X-Rspamd-Queue-Id: D6AA210000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1779021292-6900
X-HE-Meta: U2FsdGVkX198d8LVu8Cgd81U6ZvgkSygZx0MLM+fCpHh6yOoToExuGqzKuu8kuBNRsoxpP7jC5PDOUr0q60HvkYp75kuI949WNAyn44aFnjfmCafW0XzooJW9pZ6+6AdL6YJwVzjp6bagWGg1bHgOrk6/iLJDQXehKAs1cmJeBFly4/sPY7o58aaIvfpkIUSo0he/4bh7/PmLMI21P1x9E8osqXL90JwUj7KRonNVKEPdUvgipPsUO3MIftJ5vHYivDR5kKbzjSF424o/S+TiWW/VflBRfp4mmh8r7r5L2YsWbJBY4FM7oyXa+ocWhHpcFGeD4jQ0u6bV0Sc/s7uN1FtYU/n2UvnAF/0ex4xfrDJOaRxQOXr5z6Ytzt7K/fuQYHZm66FdRbijjEIdtgjFIhDvf7IvaEyJuUBD/SoXogIU+pt6Sm1Ff1bcYFBkWksPdeXiNhH5PozrMxj1UOOrUzYLEsJ269RwvtWN8Db/E3OOn7f/BsI2NIw53a6vNf2IAWSBWQR4VVstJvxTKUchDXDvBEmJ536WtPYWXF3QQ/8fH8kpgl7wQnsNwyGj+D0lTXjuUkFAJ/AdxyV19NUqMKtmp8/NJ5hRjNZdlHWOfW6Ue8jY2XqHOqBvs4Kqfxucvpwlqs0nYkxsgPAYXSpWxXzKuuH/eCzXbIUYO6FXGaNzheo25nyVgg+41xXpIz2B42WyLcw7CMsH1BKhyMWrrGbQniTqZK+b9WBFXgiTSV4TIdNMigkrPvKKY7qfrhzh9f/mug/q1buFKCD4zBEphtRJCKw81wTihfJrh/T4CDLGFXK3154QIHwVWjn6LNQpWzETta64Mdr6ToAvCfbv1WP1Fo7KNNcLEfgIBu4jxR/yBQvGFMSWu/19Y3kMgUkzb3hUoX2wPf8PxEl+8Fg/vKFhzTiW4QyMBBHqR76BEUawXOaYwx642skppDW5Y3DCTNPJ5q10IzM7yfoqD7
 zCXwXlv8
 uN8HXJq1z1Kd0VATLlkZtfT6ntkbW/PLZ+h+ua412fLEEjC7ZWi8mypHzUu8HAUSzfR/8gMS03o2NMJXr6DBu4aof4cGMdBaRG4eC4/AoAil57lNJqbcBY3JiP8Jk6NruzFBLo7DKd+lubgb6wEkMUvL+DHK6JNPoPUgVAhzbonnwABOxevzJF/HCZZWAjsxIJzkxf9VT3oke5dtKaGttUkTZSd07bOlfSWuhjSNeUFjfNLopVRkNetZmrMBfbuTLUA7iu/F82AxevGdRndEUuuajhsBJYma+vELU2GtTgFIXP9ufKr5sZYpMx3WGMvIoABEpi+DzuQi2VIWPMcvz2SeYERDqM10fs/3VJSD+z5HBEhKEfy3X6WMR3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bytes_to_page_end() for the common PAGE_SIZE - offset_in_page()
calculation.

Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/linux/page_helpers.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/page_helpers.h b/include/linux/page_helpers.h
index 102a4f3c3868..981731faa1fc 100644
--- a/include/linux/page_helpers.h
+++ b/include/linux/page_helpers.h
@@ -6,5 +6,6 @@
 #include <asm/page.h>
 
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
+#define bytes_to_page_end(p)	(PAGE_SIZE - offset_in_page(p))
 
 #endif /* _LINUX_PAGE_HELPERS_H */

