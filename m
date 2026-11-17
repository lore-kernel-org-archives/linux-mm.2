Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830A5606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mI+RtFAE
Received: by kanga.kvack.org (Postfix)
	id 9AD016B05B3; Tue, 17 Nov 2026 10:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984426B05B4; Tue, 17 Nov 2026 10:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B2E6B05B5; Tue, 17 Nov 2026 10:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6680F6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:30:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09CAC1604B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:30:38 +0000 (UTC)
X-FDA: 85444998156.03.46C7704
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6682A4000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:30:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mI+RtFAE;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794929436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lOKQnYpBQXP/LqZtNZmh3g/ieWlMy/xv2FIvUgYpFI=;
	b=jCl06kkyWwBMFUgk/N11umzQYq4BuZXsAhKNBUyhN87Lk5U/Uiem2CQ3riyS2UeulMt5/i
	RvNPxgTSXUXOpDiFwklbAAAGfNYufcEEhddeeuB4Lko7XAQa73H0w6oIvoiec7ysIsaX65
	xEOMpO0Muv982mWzOXKZAWzBCE8MUg0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794929436;
	b=TJaDnBO33GPz1aLPvTnXbBsfDjY5Ft0+alqouInBKS14cff2Tfffs7nDlpUDX7aTo3TIF6
	G7gUlTxSuk3yC7urSb01vu2II5KvEfHHTNIoR3X0D8NkOM+MIHwGevpvaqsDM+4pykhYI1
	nNysxr60qnLbZvCmn2pan/i0Jg3JpCY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mI+RtFAE;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99B9E438FA;
	Tue, 17 Nov 2026 15:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990FC1F000C7;
	Tue, 17 Nov 2026 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794929435;
	bh=5lOKQnYpBQXP/LqZtNZmh3g/ieWlMy/xv2FIvUgYpFI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mI+RtFAEcn5Hw4odFPChttgaFUbLfFiiepqhcIBr06gsDMBTbdBynxPb3I8iXZBgx
	 sZxgiqxDSL0Mzj1HbRf6jRrhO4MbbW9cHIccSv6WE7yNQobUCJxwwTmGpSAyj2XyUT
	 d7A1xyt7UPtnKkuKUVN5aQvH5WQjq+umbf5mAxdkiaGiiNOOVafTh0uiDePubNjp/L
	 vzKR6ZI0CUblCj/yx5GF5M5wR6N+KpQsW4skpTahWlgB6MED0JbDdRi8HYlHxucdUn
	 6gQUad3fBIQKidPyNLFQ6q0s5wHrkNbZ0NaI/4R5XoO5fb3ZYoPOKGKDbeWZxy7ICh
	 HMpqNNYoPwYqw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Tamir Duberstein
 <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
 Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>,
 Matthew Wilcox <willy@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Harry Yoo <harry@kernel.org>, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 08/12] rust: mm: add abstractions for allocating from
 a `sheaf`
In-Reply-To: <8a73da1c-0167-4aa5-a62c-4190327685cd@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
 <20260902-xarray-entry-send-v5-8-d18adae40708@kernel.org>
 <8a73da1c-0167-4aa5-a62c-4190327685cd@kernel.org>
Date: Tue, 17 Nov 2026 16:30:20 +0100
Message-ID: <87cxs3v5kj.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6682A4000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ryrf7umfa1f866juemoou6gwem6zinum
X-HE-Tag: 1794929436-228048
X-HE-Meta: U2FsdGVkX18H0GYn3YjTB70p4yiCMNimMK1LTqX/Vefg0GmIfvBBFIiOGHErGYVML3zt7UhrAuruz0M6uVtiypIHLHbW1ZncDT1OmPTb30oZCM5xqHJE9JcnuwMEoYrbJ80nB0NVjHNCNEkBTpOMawNaMZG+aTTUU78w503Js9UqQ+hA5gATDBh/mjyHWgviRyOjNFmWqTTbK7PtgZ8BgLNC1i/CtRob9qzxa+tebu3WUYlh577mx1iaWHDkwhME3ZzrvLLSyyqTPcCO5KXaVlYW8jC/cLSiRzhcrXjILeVdFmxza0ZQ3Pb42cjP2aaDO6ffrS+aabzdJFtr9tm01khOZJo5HvvhJh/n1caxUQFUeASiuc5JSLvMWmcPrnIvsDo0QNHo1lshvkczpSuX1/wmKpOwrQc3/SEvgffkL3dEchmAdV7jCX2ruYRci/eJL4Q9gKwqeVXxguszrjl+kzTeijOVxx//12LNjEAoVjXI2LQYmAj4ywDj5YYG58b1m8HXt/sHzwAbzu92y9vfNI5WYBxhnl4+xkLvm+kazgRcDCp86hMR42LDQ2mpRNUIku/Ne8svQha0nreZNleOkCOdA6gHNyx3GkwhctVYQnu39IAQc7nMSteB2pDM6+6LkvaE96nQ5AFOHEuRfgI0gaCIo4IcJt91DyP6Ag+56Dy3RCQVwnbawj0jdsdlz+eTNS4B9oNySz5lH4dj+ZT92TSYQHss2RneonGAdZYvtTueLd3XIv5mI/Z3QPdohMgYlCq5Nr0d5RM6bBd3sSe0CglB93tyRe5YJrmfcsnBcc5DbeWV9n98wTkYUaapJSMXpJ/Quz9p92TyISVzil/VFBykXD3GkSNdNFwtZd/a8Anf+PfBr8xuvKauloDYJiofVxeoFXNvpU7pbSunhcPT2pTGfnC1K5yp2LWg+Fh1jrbU+zVl80oHwbhFCCIRdRWZtvecd9pqddYM1MlHEtk
 2hRBbzkR
 0UGNnDwAtMMbc728CVCba6a0AtRNnQsIqV/QKvu2XZ//OIJrTVsRM3NH3YkJBbsYhG6v2NPcPb3+bmMR3/7KO9+nTf14bXx3PRDYHg4JEYkz3f5L1QjLllkLFFcXzMfl0SY3aWpRx2ZAu5TXCWGlfjpk2gSCutt5gcAStLxOoIJSxDhas1F/jSWpdaLlXwJTTZGpjV0HN3pvAaSSaHFYFcXVUEqAHN/RpmeMhLzbOKKPIyxsSMEs0bV4rz8Ag2mLc5Jv4yFRLMRAIkyrg3okOE/FArSGj0kbNGrv5ICCGtQhT99eI4kiuL5clWR7P7MP4FTvhxTb8eepnQdBIavBJyXaA/jA3suZwOBZKqivCHGhYFGoiyN95rxd4Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Vlastimil Babka (SUSE)" <vbabka@kernel.org> writes:

> On 9/2/26 15:26, Andreas Hindborg wrote:
>> Add Rust APIs for allocating objects from a `sheaf`.
>> 
>> Introduce a reduced abstraction `KMemCacheInit` for `struct kmem_cache` to
>> support management of the `Sheaf`s.
>> 
>> Initialize objects using in-place initialization when objects are allocated
>> from a `Sheaf`. This is different from C which tends to do some
>> initialization when the cache is filled. This approach is chosen because
>> there is no destructor/drop capability in `struct kmem_cache` that can be
>> invoked when the cache is dropped.
>> 
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: linux-mm@kvack.org
>> Assisted-by: LLM
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Note that currently all caches have sheaves (except CONFIG_SLUB_TINY or
> slab_debug enabled), and sheaf_capacity on creation is treated as a minimum,
> which the automated sizing calculation can make larger - in case you want to
> reflect this detail in some of the description comments.

Thanks, I will update the documentation sections!


Best regards,
Andreas Hindborg



