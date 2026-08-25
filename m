Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0539AC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1706B00DE; Tue, 25 Aug 2026 08:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AEDE6B00E0; Tue, 25 Aug 2026 08:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098BF6B00E1; Tue, 25 Aug 2026 08:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE7A86B00DE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9B5B8033D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:49:37 +0000 (UTC)
X-FDA: 85139773194.20.F36ECE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 22BC0A0006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:49:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HikYPoa7;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9842YOfkl7jVdgu9xM+nFnlV2QSjnl2wpfKIXF58SQ=;
	b=5Vh6juKhhpBTkaqn1WfQIhwu7L4sNiKbiH3romOUFaJpferesrdI1ZC13nAKQc73HlTBwg
	Eq5c73toP/CaLNLuZMLIcrcV80yLMXAuY9IZLg0n7Lpa5hSYtIyNMUyCZLV+wdq8kRlfgD
	TBBFyXua89FWrfc2Mi1brIAqginlxS4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HikYPoa7;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662176;
	b=hD+7TQLM41XZ7zeD4IR894rGRXUrqWzaFizI/5DdIoSiI1EVCtP/WbiI0vYBOuHv+sVEzU
	LK+NPAz0m9OnycHC0h3RT63fWtc5yZ+VC2YSJV+q1ZknIhfkm1r+fvCizNfRXn4xyNOapd
	XJR4mU9kX2rGIzcgoKq0dCGdxPeAcKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EE1D4036C;
	Tue, 25 Aug 2026 12:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309411F000E9;
	Tue, 25 Aug 2026 12:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662175;
	bh=O9842YOfkl7jVdgu9xM+nFnlV2QSjnl2wpfKIXF58SQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HikYPoa7HAyv4D4viLvGDUQp0DqjWqnU/qBxADx0dT+UzZrgbp6vXmYYiDV/ckMTT
	 LhrS1mMqFtbW8DDIWXsrb0goXkeqFzY2Pr7bcvr4BZl6o+pt9tW4D9whpK3ODHcEB/
	 qqi7gKgguthkZdaePHabzv5eLRMml/KS7w9P/GN0udmW6+hJfHhBFUurspzh5cN5yI
	 T9LhfoFMxqEHohpsy7fKnKgQuLX1yhghZE+4svDYwYeQ+w/WvaFP2/ldI9EFO1eTFF
	 LvP7bwfh3/p1U3QWXKdpUUPQVAMlOc8+7nPM6StpHxlKYPh651eMNvLzkvpH3OUx+g
	 Kur+47/aLKQZA==
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
Subject: Re: [PATCH v4 07/11] rust: xarray: add entry API
In-Reply-To: <178067251358.96312.14084909265600226392.b4-review@b4>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-7-965f6028790e@kernel.org>
 <178067251358.96312.14084909265600226392.b4-review@b4>
Date: Tue, 25 Aug 2026 14:49:13 +0200
Message-ID: <87mrua74c6.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 22BC0A0006
X-Stat-Signature: opjzxrz6fhko8ddzojbm5xq4poir4hk5
X-Rspam-User: 
X-HE-Tag: 1787662175-692577
X-HE-Meta: U2FsdGVkX18mqoW5qs9PSWkSGo750NsPTiJO4xjzlnwUdPXbRssfzUTu8MUAxGxYc8nJGQU81bqbB8a9ezNPvgrI0OQjr89wzAemYjCNv+FQW4JQPe0wNo7f53cIKtAs9tNCHSl2WgY1XWNL2Nt6yDHOlLsZHERk2UFz2n7aJ5reSGzbfchM+oRW7Vz6/VQrZ3kIe/5YGyYqlB/c3jaD2xQKui1O6+w271holNlYlONERvHAl8L3xz0bV2kiHoFtTzCgyISDTE14w8dlRTkyKeot77dlKqxvAOzfh3aJc9C+S4vyAk8mwidfawC/yjmpBjwh3ia6/6I5TojNBGaUQ4UwCKgwEFp5riuwhPtFN5vFESjYKXXFpeV3q46ntRPmppxi5Ig4Nc9SyjKudMVX4acGsrk7BDZgyyl0Fwwe+GcS/+FO0TAJx8pe58nbtjGcxrcCupq9jL6D8aKWb+F7TyrivG9xKaSaaBgLH/JSOjA5vPEkOwpsmvLvO0sAcFQNuFnJGQepvguSDNfsMZkoXQzJaVKcxB4lNvas1BZ6HtktHMxOhjHCysEyhVhLSn9e+fLHbfmZGTIeEIl00nNrRmfBn6JksqMhPRqoXYAGJWbdRvRryHEFMl1QVp8UPQOOjUyP4o1p34H71w5iMl8N7SqKhGpM3nDMRFICWk7PPa5oFNHqneVZpoPerc4/1fihyH5wWm3nDBM7t7nXmCuHMVvU8+4xhAuhiD4Rvxz6cLDlkpfahPBck0PGBOuGTpRxkizQ3VCiMzftyXNQGBA2yaD3wQk6j6QwdfdVW+3iKKMT8C59lxnyOqZcP8fHJN3x4faI3HUYWrpXy18w3rscFUHzRQFEVQHkmzLYziNDNyfSeBivsOFtCMXCliHrCVkeHpyM48Gx85s+7l3z0snKyf8nzrNufWPqQPkQut60phbGRbjWPod5OZCouGSrfUM3DrbqH7aZk1hkkQlAr7w
 cutJ/Y7b
 EnX7ntvji2kOS2PLUZZ1MyamiJK2TmjoyBmgYf/rlpCXdjnsm0v6u9hcL3eXKih5+AO2mba6oESwa8lHFDWs+RXjy3VuCrf9cmutXhfTcaGtpTOzJX686ttUICJ0yv4w8rDjvnbLJh7b3CCXHLDeP2DkgSQkmNeQzZtI+6GG/L8Xgn6McRpeXlGjbXlSe57d9Ie4IWTEuTHUBXGUFQMURxNHBPXSO4NPhlS0KP1XdbFKK0P/ySls1Kv8oBNhxXyQ8300XX5bOjGbcKjILNOMsyqevkQde0e4t0XEGk+Dx+UoV7X40pSf/aNw/2JWuTfOqDKfKrEPZBgecULzQ3lQYnNm/wceN7bcsQVEU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tamir Duberstein <tamird@kernel.org> writes:

> On Thu, 04 Jun 2026 21:58:13 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
>> Add an Entry API for XArray that provides ergonomic access to array
>> slots that may be vacant or occupied. The API follows the pattern of
>> Rust's standard library HashMap entry API, allowing efficient
>> conditional insertion and modification of entries.
>
> There's a lot more API here than this lets on.
> `find_next_entry{,_circular}`, `Entry::is_occupied`, `into_guard`,
> `insert{,_entry}` (do we need both?), `index`, `OccupiedEntry::swap`,
> `Deref{,Mut}`.

I can amend the commit message to enumerate the added methods.

> It's not clear that all this API is needed, and this message does not
> attempt to justify it. It is also inconsistent with the split in patches
> 3 and 4.

What do you mean when you say that it is not clear that the API is
needed? Are you referring to callers of this code? This is initially for
the rust null block driver, as expressed in the cover letter.

I'm not sure why you think this is inconsistent with patch 3 and 4?


>
>>
>>
>> diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
>> index 08979b304341..19fce6862c78 100644
>> --- a/rust/helpers/xarray.c
>> +++ b/rust/helpers/xarray.c
>> @@ -26,3 +26,20 @@ __rust_helper void rust_helper_xa_unlock(struct xarray *xa)
>>  {
>>  	return xa_unlock(xa);
>>  }
>> +
>> +void *rust_helper_xas_result(struct xa_state *xas, void *curr)
>> +{
>> +	if (xa_err(xas->xa_node))
>> +		curr = xas->xa_node;
>> +	return curr;
>> +}
>> +
>> +void *rust_helper_xa_zero_to_null(void *entry)
>> +{
>> +	return xa_is_zero(entry) ? NULL : entry;
>> +}
>
> These functions already exist in C, but are `static inline` in xarray.c.
> Can we move them to the header instead of duplicating them here please?
> That is what I did in 79ada2ae ("xarray: extract helper from
> __xa_{insert,cmpxchg}").

This is a great idea. I will follow up with a cleanup once this stuff is
in. Getting changes in the xarray C code has a rather high latency. I
would rather not be blocked by that at the moment.


Best regards,
Andreas Hindborg



