Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D26FC624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8806B00AE; Thu,  3 Sep 2026 06:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0436B00B0; Thu,  3 Sep 2026 06:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7FE6B00B2; Thu,  3 Sep 2026 06:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3A96B00AE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:11:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A92980473
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:11:54 +0000 (UTC)
X-FDA: 85172034948.12.A46326E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4434A80002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:11:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBTTOy4Z;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788430312;
	b=6X+fsI93WkrQCPmNMd29bG0yOf48zR8LEUaqbYItl2IcxFl/dp83lsHHnww8zmmgSBfahG
	tj25KKHsRbtXvXIrP1YPdjr6HohbYcOZCnz06bkC6lOiz99+0OXLumRqeh0beBgoAJ4Z1O
	3BYC7sIcqWPPdrbxVLyKrqb1FY8P7Pc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBTTOy4Z;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788430312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATnn0rFlXTYrVtedHEnWgM8vXFFmNhxFeLJmYOeDXBk=;
	b=MEktXjUzi7iOunA0wiqL4bsNppJzmRMgNKsu8YjcJ6hHQQSHeKAgBqNr9vR0LKXkVWuUjw
	JdQyhALlVg5P+jNTvaqR73whHS/zVUQUSE6neDblr5NxVzA26SBxEeKQ/DC8ovOY94TYEH
	XxpamAjVrSrpmoWC8bC4bzpq2D+VKmw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7660241AC1;
	Thu,  3 Sep 2026 10:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E311F000E9;
	Thu,  3 Sep 2026 10:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788430311;
	bh=ATnn0rFlXTYrVtedHEnWgM8vXFFmNhxFeLJmYOeDXBk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VBTTOy4Zghb2X+R2qVo4ULeLYQIJvXRTePh93UEcOu76QCZm+hfproMO+r/Nfbqd5
	 zWGprDLfpTGL9xeX6uOll5EclMwhO2WTri87vDXyT1TFmz6GNgT6oHXr6vevlAgc1s
	 W5qfqa6hdHIW8jGHtMGQuKFLPPA1E8kdQT4W5dri3GC3+S032rNC0D/txLxmRaMn17
	 rUF+tNB1CjWzHug8aRT3aAAxcJxFu5sAcJBTouGc0KX0TBs0OVCLcK3ExZKDlHV68L
	 LE6Qjyj7iTugogz/OPp7Ik18wpw6GlnnV3jDn93TCs+BrUAxb2bG3miEOpzNqG7hVS
	 m+kgfsrPHg8gA==
Message-ID: <0082d06b-381d-4001-9ea6-cd3217e437dd@kernel.org>
Date: Thu, 3 Sep 2026 12:11:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/12] rust: mm: sheaf: allow use of C initialized
 static caches
Content-Language: en-US
To: Andreas Hindborg <a.hindborg@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?=
 <work@onurozkan.dev>, Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
 <20260902-xarray-entry-send-v5-9-d18adae40708@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260902-xarray-entry-send-v5-9-d18adae40708@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fmbepys9zsfwudn9e19mjk3k7rwxqp1p
X-Rspamd-Queue-Id: 4434A80002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788430312-306888
X-HE-Meta: U2FsdGVkX189NcGfMkpTmRclSpAzRyBnVZGMHeZK4TvZ0VgGd67goqdzgT8VILk4z9hnoOPexJchdwdEiloYKVCA/5DSdcovfj4DJVvdingkhlUou2ex87MkDjKgee1unV6IJSd47nrSYzODnOO0jHMdBGm3G7quc6lTDAxY9V6MjluvNypUo67gzlC9hj9hqvbegWjuLvXFXChbCxZMG2nEzy7sRSJRNlpA/nDjRJRFhiilwid4okajWvnuuOj9v6sJTCrjXE78SnHlBAPaYDg9ONZDDp+oja61ZLEpzyAkHL3aMq3+xKoMWVxzui16rv1nuu3HxYi3wRa23/nGbJcb+wX3IcKM0xmEUNKvAXhWtiLrK8P96Fx0/J3dK8m6jDWMAH47vqx0iumE+WGf1mpO0BIWM18q4aZSU2N813lQQC86VZVRC37QUafRvVxb5lqumCLK/5WiIi5JRbG4KOlMmCVGn9jmf6NoWMliPEJGLF126YYIPo3wuXMUhWujNFGTE1J9HosnzcME4xtec3YHRhDg6TgBsoN7jUq6Iwth2Uvq+0MnQOg9+m05XE840dlHRRIH9CuBYkPwqj1OVXI+vN3G4SgdvGfXGWrDtrBynxovKyGScyPsoPeSugzeH/qw/pfqxukZMfvtQzweuvfKzIcszHYMPJ7MRY8gRMpUTfSjZHKU6tsn5YqfQqWTwJvlDNWWDBLb1wC4RLSOjkYvZ0pvYaWMHtC0OWrsLooTk2d/9PxCiprbTL94u2sL1QGyXGUzzw3kCgWNkfGPNAq3kHvprYvDBaN8jKTRzbYPzGfUZ86mjr+BnS+VeNFYrIadQm3h4TJ1LUEtR/ZPJtvJbTby8lhb4XgfKmKOGzXmtSq5Covpxgvhn1YYKT84HJDJ1UoIs5NWRqYDF/8sCguHPn78pnFjY2r2/ltjxlJUvVwrOX4ylQpQVG3p0LwwKh9SEJ6TUj5hUBTBRqi
 KhBac24n
 uwpwYCa5oYvpNipJTBwYlmLL2zGj5XcpEYXlzRgY91lr/6w1UoI12t+NoSn2KAvFGwY38vqpN18R/F1vfbL6OM+QDJlTP6a7gN4FV753hxYWaYyCgujYxQ2ovGxPamL/RTykRt+TXHff2F0pL9tU6K5IFzBFdEvEh/lUxhmHDFkJM9x+uInS376cvYYRIGiBNcBRHLSGiVgCbzxSMKOA5DSZYJek8VNsqKp6EbeDo9BI3nu8/Yt6korDRNRN0VPEGA9DuzQIWGbkFdIr7L8azKIJUbcQxHYe0NlLhWkGn//CX+KmKZ8qdHESPQT5QLQBcLJanhkZjNT1YlegC0W6hfckKka9+WJ5RPh9pXkzTFUZnl0pAWv6BXOdCycRY8ZKqh73NosH71WdIi3K6WimswQQcM1L7gxwODDrErbnCk6zkpp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 15:26, Andreas Hindborg wrote:
> Extend the sheaf abstraction to support caches initialized by C at kernel
> boot time, in addition to dynamically created Rust caches.

Nit: in C code caches can be also dynamically created :)

> Introduce `KMemCache<T>` as a transparent wrapper around `kmem_cache` for
> static caches with `'static` lifetime. Rename the previous `KMemCache<T>`
> to `KMemCacheHandle<T>` to represent dynamically created, reference-counted
> caches.
> 
> Add `Static` and `Dynamic` marker types along with `StaticSheaf` and
> `DynamicSheaf` type aliases to distinguish sheaves from each cache type.
> The `Sheaf` type now carries lifetime and allocation mode type parameters.
> 
> Add `SBox::into_ptr()` and `SBox::static_from_ptr()` methods for passing
> allocations through C code via raw pointers.
> 
> Add `KMemCache::from_raw()` for wrapping C-initialized static caches and
> `Sheaf::refill()` for replenishing a sheaf to a minimum size.
> 
> Export `kmem_cache_prefill_sheaf`, `kmem_cache_return_sheaf`,
> `kmem_cache_refill_sheaf`, and `kmem_cache_alloc_from_sheaf_noprof` to
> allow Rust module code to use the sheaf API.
> 
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: linux-mm@kvack.org
> Assisted-by: LLM
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



