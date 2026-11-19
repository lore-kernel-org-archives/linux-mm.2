Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F02606A339
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 10:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kh4fzztJ
Received: by kanga.kvack.org (Postfix)
	id CD8866B05EA; Thu, 19 Nov 2026 05:54:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63716B0605; Thu, 19 Nov 2026 05:54:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2ACF6B0607; Thu, 19 Nov 2026 05:54:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA3F6B05EA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:54:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90BCC160A35
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:54:02 +0000 (UTC)
X-FDA: 85451558724.11.F95C1CE
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id 58DD1180007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:54:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kh4fzztJ;
	spf=pass (imf16.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795085640;
	b=JgWbC6BQHhxMMcio/HyiIowIjbmYjW+bxgWBMS6Y142uLdvhLYCafSHdSyB//+rToJdI3r
	3z9blNffKbM5KT8Y4mwz/gsHYWGUwYMsSOqD5nE9jp0AYKWMx+31a9oabxNlvWaXCjFd8Y
	tTtu9sVJ1PHGVGym+55ke9BbKEiVpDY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kh4fzztJ;
	spf=pass (imf16.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795085640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4DSb8O5B5HDKJHtAiV5LnHaoIIXUo9MJFuaEaQpxIc=;
	b=KJAPOpBNh7iTJrO3/dtmw4IKVhsgiGzfi1d53K5tUOJ7FOOik4oslT8xOE2LlwO4JtPQUk
	K5Whapofah3IjEGCKJeibWM7u62wcMmSYrmhjxQgQRRnJOoi4m8p46uxUA/kwIv0K438QG
	CkRGQrSpzYm89sGBPoHwmVB1UvtDAWg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L7sCtNoyyz4AOhvKZSKvMdeJDCNqtf9hXe6yH6IKk3Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795085638; v=1; x=1795690438;
 b=kh4fzztJIush2phlTFhuk0xD7JfXKks2nDdAMlXUgmGoTrxzgRwgun7sahZtJFoyH3YZXr03
 TfUQ5/w7zHr99j/y0ISIcypW7Bng2+kJeo/vkZPpNs4wTVXMKwlliIYLsfmvTXl3lh7LHhQlcQW
 a3mxLf8e20A25WfiLxqK/1NY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c67fc910d9f71c9e;
	Thu, 19 Nov 2026 10:53:58 +0000
X-Mizu-Trace-ID: c67fc910d9f71c9e
X-Migadu-Flow: FLOW_OUT
Message-ID: <ee77a886-44b8-44b9-b21e-2c03729e9566@linux.dev>
Date: Thu, 19 Nov 2026 18:53:44 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/test_hmm: fix alloc tag leak when splitting
 device-private folios
To: Nilay Vaish <nilayvaish@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Balbir Singh <balbirs@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261118230044.683221-1-nilayvaish@google.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20261118230044.683221-1-nilayvaish@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 58DD1180007
X-Stat-Signature: go8q86dgtfcmyhoygut657po49q5g7bn
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795085640-82552
X-HE-Meta: U2FsdGVkX19J44SPOWYPISdL+zOF/IuVPWeIUEG73HOrkQLfBxIi24scyUgB65PRcW5Fdre6jGQgTJKK1M4HcZi/q7/1ZYlB3i1tB8whsWN2gaE7C4hmqhI8suzAQw1CXzBVQYM+fQ32ZAlfqD5Y65bABLPW/5UmR22dSgefbIyffgGRFhLkgxKXMv6mEnJk6whkSnzfKXkraFAnGvxX4zTrpYYd3ewPqayCufR6nyr2eLMfAbCzvzl23WyKHTHxbrlBrX9At4vwrXvi5Cwhtitq4FdhNYB1OMclTZnAf8O28pvqIwp0rEE8Pu0f6Uq52Ce4cR44kIlvXDnRJEH1ly+6FbdeuGcMOE9p3h5ItjH6RfzknygDeQ2FEDBwMdGgxsjqfFU3MPXSRhz2Kt7o0GBnEyZNGyM8VeYYA/Fk0CvJgX6R0UzzxigNfIvf1iQd4uAcSB0BOAibbMtKgXDRstfirn6LcPnTAIe/uehhdWtHB0hLlJ2DVraW2FFSQcCF0tkKVo0L8pVlDM1Uv8pvL65DVqi9RKCK456xdAIFG+iimFJ+Lfn0iDpQSukSZFMtAUWOdnLg41pXfUDbzMdvkM7b1r1XC0d9EMZNvUqxNUbuAr2lxmizqkC7pWHfQpvZvjztKJuVRmz3XVatJ6ZB0M51puO0f8F1dijbLT+Y8pcWXsCQXNnnwQhG+1JX24CG2qM+nJJVWv9O8Fu1OAdd95vwA5SefLO3a3m6RbOIP3cZHVBOKNwFPx6FFNvKeIho0olj4Z8gi6WPZlsM6x2/38emXetVhoZionB5qrjqmPwXuQ8993UnXsdVTeL1DHtp3jEGGUUl9HmK38ePjlnDV0RiIqWH09UvFRt4rvu0U5dZBrA0GWNoxjJKFRiyDoOHZ8thO+S9iEINCHmW5OTPEkcOzEXapAwaZW8ihfZicU+msQqJIP6+mwxFl81HhcnZUGgUOtA7G7elnyyH5oX
 IGY0Hagr
 lUL2e4o/YlCdWKrxZf/oY15vFcqjC9n0WC2C6dbRIKDA4Dzfiz7cGrTanl1kg+mxCLVs5j+bAtq4Po5DIK1ziy+2VPUWmUiJDdoBNHOG0NdaixF8aGIoTCr54HOsTyMLPKWIc0nMuQkYcE+b+hTOmXmHI5OhAsvSC/GdL2R1mA8/iLh4KwqiNeifRaASzAopSeHK3tCqmnD0Wo6y7UqWnQiwJ0V5cuGG1BHmt2eIei8JT3Ngtxr/4gXW1re3+ME23FGW9qmLBG6zlnbGrQxrxqYKLAJbXUswoeXzGh5DtE5YNO8L+4Kem9l0ctvtH6QmK+pup
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 7:00 AM, Nilay Vaish wrote:
> For device-private memory, test_hmm backs each fake device folio with
> real system RAM of the same order, allocated with folio_alloc() in
> dmirror_devmem_alloc_page().
> 
> When the core MM splits a large device-private folio, the driver's
> ->folio_split() callback, dmirror_devmem_folio_split(), has to split
> the backing memory as well. It does that by hand: clear_compound_head()
> on the tail pages, folio_reset_order() on the head page, and
> folio_set_count() on each of them. dmirror_devmem_free() then frees
> every backing page as an order-0 page.
> 
> This open-coded split does not split the allocator's metadata. The
> allocation tag and the page_owner record still describe one high-order
> allocation, and PG_head stays set on the head page. When the pages are
> freed one by one, the tag is debited for only one page when the head is
> freed, and the tail pages carry no tag at all. With
> CONFIG_MEM_ALLOC_PROFILING, running the HMM selftests and unloading the
> module reports the leak:
> 
>   lib/test_hmm.c:808 module test_hmm func:dmirror_devmem_alloc_page has 16744448 allocated at module unload
> 
> and with CONFIG_MEM_ALLOC_PROFILING_DEBUG freeing a tail page triggers:
> 
>   alloc_tag was not set
>   WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0
> 
> The backing memory is a private buffer of the test driver and nothing
> requires it to be a folio. Allocate it with alloc_pages() instead and
> split it right away with split_page(), which splits the allocation tag,
> page_owner and memcg state and is already exported to modules. It is
> still allocated as one high-order block rather than as individual
> order-0 pages because the driver finds the backing page of the Nth page
> of a device folio by offsetting from the first backing page, so the
> backing pages have to be physically contiguous. Every backing page is
> then an independent order-0 page for its whole lifetime, so
> dmirror_devmem_folio_split() only has to point the new device folio at
> its backing page, and dmirror_devmem_free() frees the backing pages one
> at a time.
> 
> As the backing pages no longer form a folio, take the order from the
> device folio rather than from the backing page, and index and copy the
> backing pages individually instead of using folio_page() and
> folio_copy().
> 
> With this patch the device-private HMM selftests pass and the module
> unloads without the messages above.

I did a quick test and confirmed that the original splat has
disappeared :-)

Thanks,
Zenghui

