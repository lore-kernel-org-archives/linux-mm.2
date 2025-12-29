Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67897E8FDBE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 15:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD27E6B009B; Mon, 29 Dec 2025 10:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89CC6B009D; Mon, 29 Dec 2025 10:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7026B009E; Mon, 29 Dec 2025 10:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACA526B009B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:00:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F8D01616D3
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:00:53 +0000 (UTC)
X-FDA: 84272820786.08.C017F2E
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 115CA4001D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:00:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HEt/wjs1";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767020451; a=rsa-sha256;
	cv=none;
	b=7cn5mrR+cMMNdofNjlOC9q1FZN9eHJ1ifVr+CM7xlMZQxgnQCDfcY+rY4TlL66DStuu+XZ
	rw/vvJhD2c7F03aUQh0DDBD3vvrEPNzbyjoasJBE0ifOuGO1nE62NaaDtcr0XajrRLuK6n
	5xs7OXMl6g109JqOd+BryeLfNCB0BUU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HEt/wjs1";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767020451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPBVcYcgdOP0Js4PkjcKCsAb8PlbkiKIG7/mKprLRtI=;
	b=iokdZHOnpgQnUMfNfEk4NALAvGtAJJIQXH0SScv9i4kWoVTVh9ZPdG/VBbi2VJOQEyZ8bT
	GdhtEv+OE3cAQmJ5KtyP4aR2jRPfoX4cVPhUvtE+ueF1xBiXPuPiDnKQPWRDqA9wGPdYdd
	qjyVKZXc7Cr3fxjBi+UGhpsY3km7kbQ=
Message-ID: <17a56acb-4e2c-4b14-bdb7-f64b105a3b4f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767020448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PPBVcYcgdOP0Js4PkjcKCsAb8PlbkiKIG7/mKprLRtI=;
	b=HEt/wjs1YBKqKSus5tbBwvjX5/EHdRZRtrWNmZLJtPQPKYh8VxQxwyZKjxk/IiPk+IiQfR
	0R/8Z0NMLDbV0LUfV73yZjG+6z8CBV/X6O8CLPV1lRHweDi2MpuzlmBauHs738b+JQswrm
	Y0+EAtI1oN6mMB13vLOWvOc1fE7nht8=
Date: Mon, 29 Dec 2025 23:00:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] mm/tlb: allow architectures to skip redundant TLB
 sync IPIs
Content-Language: en-US
To: akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <20251229145245.85452-2-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251229145245.85452-2-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 115CA4001D
X-Stat-Signature: 578mqyqze6rbmk6s8op4wrnpe1uqfqcm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767020450-399992
X-HE-Meta: U2FsdGVkX19h44asguQgN6dNc8pXYOzubM/zi4QZ2tGh+reb1mgWOOwMWn29kgEOk8pT7Zl13/2nJk3qJ9rxJXcNmr8SalhmINfCR69Qsg6fiLYWXzzSghB0zzHRauJxRddapm681qjDAnima2TCTh3ZyzrV6O0Bq0yAG+cG9sisusahHMDt3s7MhSGqA5TS9lGYSWe4KQv4vsBTcxihf4m7dExDIsS/fB8iF114n+PXQQXHDYnHUYcaIiUbBQa3h8Qjq0tV3ChzBb3+yTwolzNVlMztTJM4nq4oUTtyG4E+0V8boJybApkbsCzkiczZAiOkppInP3ITsL5dZIZCOkGQlxpMzJ+imI4Gzub8lMMLsobyIC0xg9A44uhFe5b+XWNnol0qjGq+90IGv00zf0kMy492jZWPRfqlJqULfHu6TyxfQ2bZjJOLsGaWi63+GBkiTUkGSaSy06vWJiuORHr253Q5fVFybwysnV/CyG9+ltY28IKKrTFAZPQeE0KSb629jz8gw55ze4qYIXJ3/wszJz+7Ia7rHdgVItyqrwUCqLSo4e3EymJWSkwCQwKf6UsxHYJS1wq+s+qCWgW7Y97FKm3iH2IY8Nn0lAASxU8fspGFzZwomE6Q3D8Poyw8oOeONfPLLa0NBCQD9nr24oE2NYTZSX29I5fLXVTf+rPBM4L1DbdBRiDPVaRLyEgzk0i9DW8L5W3YMW6s+e3yb/zg4bBx9O6/4ewxnPOEI1BTAcsqvRwGQbvaKfRSEUT+BD/XFHHhgLsFkU8kR2rDmYGgh6M73tCESonBF5hNFRWtBOIWBTW+FeUxR3RvM8j9fMl0/J1JAqGrMiGVJ2wLLMKROY3p1horGGhJmQWLOvKzqVswj4ybMcR9ssgLyf5KzWIJdtVTEsNaE1PewrE4k00z9cPhPWNUZejhdKzNsMZMGexQ+miCHkPR2NSm8gafkFVBl8yf/nRZXDCGeoB
 WZWSI6JN
 yUsX+oHjmikmySgUxcADIA4i/o8gS19KvgN0gXA0LbWCpQmaGUwpnZXpbGm/YS46QWWJtrmo11pCxdCpFUZVa2mkwsHq4ooF+qqmwGMm5oTUVD/mqv6Z8QNTQ4LrBjUGjQSDfhUi839pX3Zhcs0m7v35QU0S2J8EeeQu08hblR8EwfsYbor6SIwNJ+AYY1xuNHe4AQoW8csVE8DTP1S5YNI/f7dyINqA6S+9VzmnggNS7bI4m35whlkiWMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Confusingly, I'm still unable to send the cover letter, but there's no
error message. I'll post it here instead ...

