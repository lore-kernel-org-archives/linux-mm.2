Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64107C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728436B00E0; Tue, 25 Aug 2026 08:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFFD6B00E1; Tue, 25 Aug 2026 08:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615F36B00E2; Tue, 25 Aug 2026 08:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41EDB6B00E0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF5C4A3367
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:49:42 +0000 (UTC)
X-FDA: 85139773404.13.802EACD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2BFA940003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:49:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZP+pEiR8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5S0tmCZF1FGYSoh1dt8V0x40wzyFaRUchPJ+JMtP8Sg=;
	b=QCkvS+hFhWwAwu3OriteqIO1M6lGyasXaw3Xr1RK7w8r+cxVozpT24tu/uaZAS59hQpDsJ
	NXePsH5JRgBNyfuQeOuKkeTlwpVwyZa0L6zvD11nekZURZNyZyLEY1CoZz6C3z6CGEj3b7
	kvJK05eGfZ3J6x8bd++9jl7fyvmVgtU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZP+pEiR8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662181;
	b=ZtjMR48RkgrarC2PpkQ0NmAZwnGPx5imbayCqYlU0bfz5TGFMGn7WpoQ1d1GZ7Ll4eFxXq
	G1awIjhzcV9gHmVyiGYhtTQpXvvB4TiX9ewd1+CL/cJe1aF5UsxWII20ONtFemcjfzC6EM
	M0Esn48EKGiO8TtjFLXzapx66q6p3HI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C7F543BCA;
	Tue, 25 Aug 2026 12:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04EA1F00A3D;
	Tue, 25 Aug 2026 12:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662180;
	bh=5S0tmCZF1FGYSoh1dt8V0x40wzyFaRUchPJ+JMtP8Sg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZP+pEiR8OlpKovfu85qnWPif9OXHg4xV9AUFozytZ4uR+UGOrXPRb0R9LeM5+dKcU
	 Q43sf25wxZqp1ORokWwH5JedtYwTFpSQae5NAodPmo4aVh3VE573imqsrHepTx703z
	 NIqqCNHzHVOaI801S/rUKf9oXxok08itqtgwdlx0xmwEYbvjD17xJELc4+Z/tj27zR
	 xcszg+nZKq8uEzXncMsnpRwOyIHDU8pEEiJfakf09oGNRJ8yimfp7CpWuTUKE9VCyU
	 HOh5BkwNqD6jrgGXWwbi9mnXgpkWwpWIb3jDBnR6/6N4c8M1AeeCzwy5otJ2MV+qV2
	 oXZu1HUcQz5+Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Tamir Duberstein <tamird@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry
 Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Daniel Gomez
 <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 06/11] rust: xarray: add `find_next` and `find_next_mut`
In-Reply-To: <178067251353.96312.9527123475656114033.b4-review@b4>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-6-965f6028790e@kernel.org>
 <178067251353.96312.9527123475656114033.b4-review@b4>
Date: Tue, 25 Aug 2026 14:43:38 +0200
Message-ID: <87pkz674lh.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BFA940003
X-Rspamd-Server: rspam07
X-Stat-Signature: 6t8staj6eq767943g3ydx3ee1rqarxef
X-HE-Tag: 1787662181-427928
X-HE-Meta: U2FsdGVkX1+iTYY4KI1jTH1LBvYmQsl+KlXukxGrENK1MKatKCwOXfVMhzx8xYfXWwMf1nbqjjZ0k864vM8NakzyYEfcpyIaj92dDjPqMfJzuU5AhqJ9KNTdBoN7+ybku3RLORF+HBIeDQs5F046BXBKGmkxPrGwNFEkuplDh9tIVcIZxZ3xSp8eX0BGaFjnomwKOVF5cGgkEUigX1OvqU22/jLvxWtRGxA7M7ziDJPEOidkGLixM9CAAyRo/UzsmlgOssN+MFgolsdTCO/aRc3Jvcw2+ybH2dgGZfjtFOtqfInPDdo4nTrGKrpb3BWkweSnYUzFjlozs35Wkb27CG71a5bcS3jTFNgwMA8cHv/4A1LPN19tj6heTp3ifKFL8UZUShKZDMzXwmoJuEqaiYGjwW31Eh9PYyRFxOAD7dSnIBKHnq064RF0lToBS9Y6gOgjmc93/v7+dHvsPmMECZLGqkgHmP43bBA37pINz860wLnEm3Tkq31V2NEDovlcQoIrHp7VLoTIC1MuIHI0AR/9cdVxEC/ky7yUfdZohOpILvOGwm2QRYcqgPILY+W1BFG8xnrCVcgJ8PR+lkFt598ZIYKHF96AFgxYlX3NI7x4+8BbuTVJa7bXYaaKM2XeqVkvx9UohjXOa7yHeEph1U17Igp/G/87Fh3W23fJQ940NSv5caZDzsxM+g5hwRqj6e19n30Fx5cV+zj2Fzftuhn2eWBd9iMpGrtZ1BkM3INFFWPYxKSSbim/da1M/GK/jPOJ9bqtGibWVjs6vt+DXCbd44ilQCNL7iXhBJNhiVLKnDY911BQ/YQRhkmlQ8qlyuTPsIquAS7I1zpsAlB5F1R7z6RbiCo/gvvGGQ7N2w1n2102tS5EV6yvDcd2blldnq1WKT++D085IZNYbgfhReofhRv7Dt+k2ePNMrwdSGqvP5gtcAiQ49M5Ck3f6TAoPS7sNAiBjnU8H7vFQVd
 SlcxBNCq
 SaeNisY19e6NOfKQcIfeI6obW8D1/IA9gx5co8tUspzSPHW2UsURUpWaO13T895dnleiNVv6wtTN+shCsqlsFz4D6WgTPjBL2ViHjo5MBELdqFZZRwhKhDDFOCjPbwpo8+PdI5xmFwhLhcg4V63TzRrm3c0eSarbTCuW4rbbLqwC28YpCbmX0i+XcYXPDIkz4qvCD8qXZrSOXhg9LJQ0hENgvwCyk91QYkjtSn32Bl9CTB6yPFBc4TR5YKQ/wPCBPW70kxeCFFOL7xSa9D4MsefzuaqHiKNmFxEWX0SZDH9EhDNDXNaQappyAEYaVpVEHQlDDz5Vtu2Dy2O9QWqcFcaMjErcsNfwB6PnGA06jlsNhDtMP4tm5hdr0HxnG6+aLsNvdl8wcX4cfXcWIg0SAb5IJhCuYCTxSGj9g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tamir Duberstein <tamird@kernel.org> writes:

> On Thu, 04 Jun 2026 21:58:12 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
>> Add methods to find the next element in an XArray starting from a
>> given index. The methods return a tuple containing the index where the
>> element was found and a reference to the element.
>> 
>> The implementation uses the XArray state API via `xas_find` to avoid taking
>> the rcu lock as an exclusive lock is already held by `Guard`.
>
> The previous patch re-hosts existing XArray methods on XArrayState, but
> this patch and subsequent ones are choosing to grow the XArray API
> rather than promote XArrayState to a proper abstraction that users
> should prefer. Are you sure that's the right choice?

We have the `Entry` API (introduced in patch 7) for users to interact
with the XArray in a stateful manner. I think adding these public
methods on `Guard` makes sense.

Best regards,
Andreas Hindborg




