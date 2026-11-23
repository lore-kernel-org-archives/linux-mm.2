Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544A4606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EhQuDqUF
Received: by kanga.kvack.org (Postfix)
	id 6A2536B05B0; Mon, 23 Nov 2026 09:40:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653556B05B1; Mon, 23 Nov 2026 09:40:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5698B6B05B2; Mon, 23 Nov 2026 09:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A38C6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:40:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF4FC1A08DA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:40:54 +0000 (UTC)
X-FDA: 85466645628.15.ADD06A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 373CD20007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:40:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EhQuDqUF;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795444853;
	b=cXUXM5/Vfz3W51IEJK/03uczD/hZ4MlHBDmTcazweyAG120S2Fv03SkknAiX8e3DtLc9fR
	qgXhjbIR8j9nvcGoFVoxCzcDtUuKKRaqW3um7XY1YrfR4rC8qNiWGXsa8jDwndk8mFiCrN
	nzoj5zkmvlX6w8cCdtn2v0psO7xi/NM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795444853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOsTEFHih5VGh65hIOhMdFK7B8YNvZl3Iglz0jpWLso=;
	b=aFeMx+EIDUV8k/73eUuxUhHMxLBtuhckq5HrZqKv1gc9xEmauDSLYLO9UWswh8AqG9Pegg
	Gh5P4bAykVxehnu4bJuxeR9EDPxiROhNNIRF5pAbszy02XXtWBXu5bA6q1EgF3MP/Cvh3q
	l2XtbUaakz+SgeTKgnrxn77VahKGBdw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EhQuDqUF;
	spf=pass (imf31.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B49941E8D;
	Mon, 23 Nov 2026 14:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD2E1F000C0;
	Mon, 23 Nov 2026 14:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795444852;
	bh=VOsTEFHih5VGh65hIOhMdFK7B8YNvZl3Iglz0jpWLso=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=EhQuDqUF7DT4TxtUVj9OVj3hTI5W7/nX+vJBMGjIrlutfWt0271APj+JosrDBV2AM
	 uut6trIXiw9gA5t4IwPJueJwzj9HFtdUmkBzMc25B+WVSM98Cm2yI8DhpgxTSr78Fs
	 0vCN7pHkECxedbb55AQsjW+X27PRzf58UPb+Tqg+TSlPv/o1rl0l2NzYCEWJL+4g5/
	 Hw3Auknd7cZH4CLJjUs29SlW4cydIVH/NtK193SF09uzDfVCpDWaX2qCVqmz1rChCw
	 MLo2KazaBsVn6lCDr4eLo6ojuIsBh555XaGs58UHfZp30JcithhFCYfDtzruEDI36+
	 FuL+NMy8p6Rsw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Daniel
 Almeida <daniel.almeida@collabora.com>, Alexandre Courbot
 <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>,
 Matthew Wilcox
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry
 Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph
 Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v6 08/12] rust: mm: add abstractions for allocating from
 a `sheaf`
In-Reply-To: <DN0YBZJNQVW4.2RY9NCR5T33HZ@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
 <20261120-xarray-entry-send-v6-8-1f69d7385f70@kernel.org>
 <DN0YBZJNQVW4.2RY9NCR5T33HZ@kernel.org>
Date: Mon, 23 Nov 2026 15:40:36 +0100
Message-ID: <87mrqztxuj.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 373CD20007
X-Stat-Signature: jgqcbrb7grpdsh6s15m8n6mhrak8ez3j
X-Rspam-User:
X-HE-Tag: 1795444853-329866
X-HE-Meta: U2FsdGVkX18MTv6xmu654PvEM4s1LRM4NnkkV2NQZrV2Z4hcO79hYTkxsNA0nhgLsJBhhg20JYxvFVCXYwn9xeSfAkBJUWNJzgyC5xjJPmaQNA3jvoedSGE6XecIMlXg2D9GQYRO1j313aCQzYErAdz2qiIo1NG25MHPRMaBcEohAMiO1FRYk8amXxvleNJA4RD5PTGAs6a+iMlISSXOHuw4ztTlmU6g9MwDH7NkeEKxvbMb2knoW+fQ/1lOkSWJZaOAwkPpTW+HXIalp1Vq+o/9Bb35MipGfSXuvnL3ogyTmvT8rSD6pcPmnVob8VorNoV9n733ShTbjPJmKqn1Hsm5w13KDcoa/DjZu34u/q78+fgrnrBpQgYXw5TqOYUBIGi8mivwC2+cp3aub2f+8AK157I0ewHulTPgxG5kvpFQjHFdl8tSzDjvFPwSpl3WbFO8pkhCpugQ1/sBPy42tkaA4QdbUkLzrSgInIeEyTQUwrqDX8N7ZnFMjfs9mppTRwPJogmTMuFuFH+OfjCJYlMPw94nAv4YA1eZaEriZsZoc/rktE+zJa+u9Iw2bLxsfrk6n8o3T6VPmnWTVvhbDIY3+Ft1RW8VbPd6XicKJvv9u7WRFhfUBbT19+e4BvmCMMIxPH3l1QCGvIbE2WPfs1gn7wGHoTx8nkTHjyHkmeb7GAZMwvyPmSvgEKoefunYOCl4S0OpQJLOVnySJv2sBbG7fiFAGbE7hwDllxqOkYWBZfd+SLnfRrzmmcvFKmw1wAUbSAAbANXjLj+97futCHBHuRFybKCK9Cf34dK2r5ynydtEarfiP+74KeqyHPr4o6sog8ayXAEDE4DodZREp25btKfFIi9uEmHQz8bqQ2O9xF4L9KcQ2WecQMidsAJv6LWO+/BtPaMkqq4eo0QnrTVSdDSHBmCj2bZDKA2DjKSz25sB/U9dJj9rL+vO9skuVTlTsPugZaE4qF7u3mo
 aUK4cxiJ
 fhbcpiUKEQchHWPbjYqiehUymFME9aS27pWAaHcM4V3nlaIqC2D7jb0lATvof5nJ6dQR1M1exnJX7cFtyHNWRq0rRrZ7qufhq/TQzN9lPzBX6WURxpBScZ7qLVr2wT0ZePv5IeG83TiRLDK1Q1IgaGK1y0OFn4kRonWUxHQvTF+IvByE3pm4x+gMNnbiZGZiUPg1aYu6P6EKEeQcvYLZnJAI0f3Uuq90I1Ozd4hSKuA56lo+wc1Um+2emNdFwORgSF3qtr3tpKYzuTlZzMOZ1kxCbLR6Ju/HUkgWNR5aJA8fcEwoO+ZW8vYjgxtZhJy4WTZd4I5kFxsNowM0W3A9SgqkA7wVnijZTrd6U9LC0+UqNYdZwpKYs7TGwCHFeOLZiVhMVv1U2UbzpnWNzRmmIDtUQFyB53S8qBiD9iu2vLDrvK7fwXSiI224G8CWAOuFzBbvcPLmt/Qi1AQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Danilo Krummrich" <dakr@kernel.org> writes:

> On Fri Nov 20, 2026 at 2:10 PM CET, Andreas Hindborg wrote:
>> +/// An owned allocation from a cache sheaf.
>> +///
>> +/// `SBox` is similar to `Box` but is backed by a slab cache allocation obtained
>> +/// through a [`Sheaf`]. It provides owned access to an initialized object and
>> +/// ensures the object is properly freed back to the cache when dropped.
>> +///
>> +/// The contained `T` is initialized when the `SBox` is returned from alloc and
>> +/// dropped when the `SBox` is dropped.
>> +///
>> +/// An `SBox` holds a reference to the [`KMemCache`] it was allocated from.
>> +/// Dropping the `SBox` may thus drop the last reference to the cache and
>> +/// destroy the cache, which may sleep. See the `# Context` section of
>> +/// [`KMemCache`].
>> +///
>> +/// # Invariants
>> +///
>> +/// - `ptr` points to a valid, initialized object of type `T`.
>> +/// - `cache` is the cache from which this object was allocated.
>> +/// - The object remains valid for the lifetime of the `SBox`.
>> +pub struct SBox<T: KMemCacheInit<T>> {
>> +    ptr: NonNull<T>,
>> +    cache: Arc<KMemCache<T>>,
>> +}
>
> I did only notice this patch just now, will take a closer look later on. But
> this all looks like it belongs into the alloc module.

Yea, could be we should move it to `alloc`.

Best regards,
Andreas Hindborg



