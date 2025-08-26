Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 689A8CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AECCB8E0104; Tue, 26 Aug 2025 15:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4766B01A9; Tue, 26 Aug 2025 15:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01578E0104; Tue, 26 Aug 2025 15:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7796B0185
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:39:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BC981A02C4
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:39:01 +0000 (UTC)
X-FDA: 83819921682.29.2EB46FB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D01C140002
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:38:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mmHOxM9s
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756237139; a=rsa-sha256;
	cv=none;
	b=Q7Njv2xDB8jAVbkqCkhd+L0mmMYYH/3iqesqrUIvnBLtVUeOF3O/DPxuDXCOmnNM4qdsQK
	6nLM0Hu/gUAG35ZiRyoldq5hvD+6qDy+LOil5QSKV6zotFc/M0QJmzvawZ6KerY/vlOiXw
	LNyT57iInZcCrGtlWvDi9yB6qTDZa+Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mmHOxM9s;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756237139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/kAsqmVBMedESn3J7MpJfJZf2HruICLXcPBtaj0vl4=;
	b=pkrOih3Vz/6oXLQfb5IQokAtiA22QPyNgKD6PVRQrwnkGxv0NXQRMWLSY3dHVYQghdkml+
	zTfvS0aUhf1DkRmLShOZZk1ARDd4coZzch3oWWsNfbCKmhY50JeT2umG7+KAzFyKEu+9Sx
	rDDjG25m+Q6iysnxj7pfAzB+/DjFKGU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n/kAsqmVBMedESn3J7MpJfJZf2HruICLXcPBtaj0vl4=; b=mmHOxM9sNOo2+Re3oykQKDtWdz
	rhODXDKvhq9IIubRcJJ6HjnjRESu+lBbbiXNc1hqKRiL9ZTTO3i5pbycRBIyTu6Ini0ItyzRHtdhW
	h9UIqwZ5TM5qtW6KBwGgCqeQdG+iruICoxDMdr4QK22jBABrtH8kv8wMlfC+RzNifIyZ+sfotOsSf
	Hka3lJ7MDatWwg0P79CMhyruu4iVZEUeWRixr24aUK99TvBAJeh7g6K0aHkEYy+JtcdZBSovAfMqB
	/2fb41aEV3rH2/F4+s1uZjv778mRsFGf7OyTZILlBDJJJ4fvzna1UpZclOt7cj7WBLdps5XrDS5tx
	3GVJQETA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqzVR-00000008dUK-1CXL;
	Tue, 26 Aug 2025 19:38:57 +0000
Date: Tue, 26 Aug 2025 20:38:57 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] mm/page_alloc: Add kernel-docs for free_pages()
Message-ID: <aK4NUS5N9TiX5hk0@casper.infradead.org>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
 <20250826193258.902608-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826193258.902608-2-vishal.moola@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D01C140002
X-Stat-Signature: iikb4touux1usaxeqhun7z4s8nzbxhu4
X-Rspam-User: 
X-HE-Tag: 1756237139-750502
X-HE-Meta: U2FsdGVkX1/4TzD4qETU1TKVpAzJEI3xnDMbq1YmWYZ/T7v3LKYvkyyT7NDnkJd8SlscxdR/dtuDLfUYEm1LSDmw7NEZ9AdEgLK59JmEFGRVMIVeGj4hbUvA/8BnUSkUZwl1+DdZ6NFDiIVI8X5UzaKo7t1IoY90vCGxMABERH2li6EWSFH2u6VqQwo2UY426X6YyI9rNaiBEwA17iWHiu6xJ6OPXiWrs7wW5NWEFHqLDmCwwZJsfY4IGa000r/IImTwrMECnoV4sDgeqn8f2GK70EVQ47PWV/prFBn0cp8lzrWUi4Y7IUtcNiv1P7Jd762BbrtFgggtE4+SDZmBXcuOfwTrHc856m7LWmspPXGoNGSkhkcGVBAVU5tIXtXI/E1hJgknenBv2JuN4oDM4M6Wr/Vt5D3uJoEY0FUOAFyWrJKcGEfDCbML6k8ae9AgVqUh+twOetPoRQg+n6JZgKKDFYw0BccqEu4KW0s/M/02I9YvJalmmMdSljltgzmkIfkBRXnaaHWlZTSyzYT4n1E36tCdU/6DT2o/b2weKhRM8CVX3JTa60X0D92Q3e9mZ0idxESIHJ4L0BRLXSX8yALn0xs+1soVSwtUY9VtnwOKpI+Utp8mUGO+bV/gF+2j20xUU8yMVS14ceAfvt3WDYBtsX5U1xBmaYNbPn68ov+pbAShFYFO/3VKzGHEiObO6Ik2QdIbJg2m8ObNPkeWbPiVulplg9spHScO2LX5WDnFe/sCE8lOHv6VvicioEXlAnxFhBoi27YpcXH2gMVgidqI9yqhEkacw8KGvQLEkDML0T67B3ZoVYrvYqG9TR61yn6XVconDVnNYhaOElkGJnJibuiJ8NsLloTFU/P+WEGiuScSNTg8PY7J8EAnCY6NNHW53qCs+DUvDhnjE/v9TItXheU5I/psv6osSrtQ9qRA0BcFvRINew6ctF2o2fQVddkRfGZehDI8/+qjULf
 LYIRFMYJ
 +Ohk/ONU1pUgkq6wHekeOsKME6X3bNkh7bINlQYYxpv3yxEG3WEKQcH9cbrctonN8BfmpAT9LfGwpIe4HeQxvv0p5f9DPmk1qNCW2+JmhASF5VzWn4URKSUmxYxSzmgz9mdSOiBSug1qJxegQO6QTBFJ9as4iIY1LCculC1a8+cQZzoixGWd4XvwzKRQQUranW1oqrmW/erjCWtGa+V8WU+986WE3JLnJ/7V8uNVl0OZMn/DieAo6yJ/oF/sQviGjzb7oCQw8F+mtgicq8zHHavXQ/zO9kNCVk/gr1pfF15K1WTBXgpyCajLkxlkAnsam/+CLc8K9IFBId+5naWJMA9jcjDW08jUr+yqMJoxpp5qffvYN/ykOWuHJGYntdF2OB5lo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 12:32:52PM -0700, Vishal Moola (Oracle) wrote:
> +/**
> + * free_pages - Free pages allocated with alloc_pages().

I might reference get_free_pages() here instead of alloc_pages().
We used to have a wonderful document that explained that there was one
allocator with two namespaces to access it; alloc_pages()/__free_pages()
and get_free_pages()/free_pages().  I don't know what happened to it.

Other than that,

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

