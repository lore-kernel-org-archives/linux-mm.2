Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2745EE9B262
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877B86B0088; Tue, 24 Feb 2026 08:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FAF16B0089; Tue, 24 Feb 2026 08:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707306B008A; Tue, 24 Feb 2026 08:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE3B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:45:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16395B4CC2
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:45:52 +0000 (UTC)
X-FDA: 84479473344.19.1C603E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 656A4140004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:45:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3PWQj5X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771940750; a=rsa-sha256;
	cv=none;
	b=wywohREmTx5WtHOr7wCT2M5D14xDtpB+AMFT5xwK4ldtCP8diZHlvQ+aGYB0mSt996K3iL
	3v9FiDrwBm31SPNIYEn3ovO6Ov/DAxBCjZSUY8Zw0cGr63uoom2Q/Aq+5S9gCe2pSUeGKZ
	UN+alGnVDY9b6BBFcq3Z1Tmwg6oJy+Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3PWQj5X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771940750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSnlCyH4rTNrPJxlNYcPb4w/qdzhR5A8COqBFwcBV2g=;
	b=gyNQUSGX8YpJ+exNc2RkGPWrTHXFuzt0KxE0w/7/YOgBb6bWY3tEtuFvoKOuE/8FIQZ8eV
	dLEBSRZz82WLBoVLqFBCG5W1d3iH1ARFnufDCwytrgnJYqVeYDtWvPjpudq9fOsaK4RZQh
	uiV8s9wA+r+Xy+2pMU8y/gecqcl8GtA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35EBD400A8;
	Tue, 24 Feb 2026 13:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2B2C116D0;
	Tue, 24 Feb 2026 13:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771940749;
	bh=ftgYAotQSHbWTiHfbL9ahOild9zaBZJQ665pJX8FUag=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=E3PWQj5Xg0ZKXjljQSo9YxUra2ZFOKsb95geu8r6aMG2SCYcVsH5bcakASrtcOVnQ
	 5lY9rS6Vqd4awKWgBIejvLJn1u0Q0AU3M7YkfbS/Io2PGuh33Cv7ZtQFxoAxfOCqi2
	 k0XU81DOOcJ7SsuROqtJ5OipdFZyqUIHVozEwi5hn/cLBkHu1gmSVXFdytLaanaXVx
	 +fq+3ImTGCBCX1MpAN8Vizkg1ZK0J2E9SE7PKkWNIZ2tN4zJVB/CrRfQ9CnFfgwfiq
	 HCmyEd+q1O4ETUJX+btFWe4ZC0C0KFEzL15bGvyHle0IbiTCI0IId4n0pTJ2KrTFnG
	 2u9xwhRCvyceQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
In-Reply-To: <aYtW-Hg-ItQI7v9-@macos>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <aYtW-Hg-ItQI7v9-@macos>
Date: Tue, 24 Feb 2026 14:45:37 +0100
Message-ID: <87seaq1chq.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: dkbnq1483ybstnwf51aw1ammicrgibs6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 656A4140004
X-HE-Tag: 1771940750-317247
X-HE-Meta: U2FsdGVkX1/d7TwrYIhCxiI5oyFKLZhTzpqTw5jnVNJ00nCR31uqvYdbNOGSvy79viuvJnUmDvRD9rHCJV7hbuBKVETmkRZF6ciQzTSTXCx1yHHPvYCL9n3DKQL7wt0xJXeYUIXpU1z819G2kOIBFvn0NhBfIQeblAEqkn8cCSTbnXqA3xEbftfcuHoo4oloay52B7miuvZaWEqtDNKccDTBYzI+4R9j2y4NXBU6LyAiZXGGQDz6fYhcM2b6409iENxSD3vl99P22diNGWbZVCc2BZD6WcLHFpJiO4g5UcU/ZOP5I/vK6HbfmdYM/xafWANeCUXWjErgrpoQbccMpLJngJRyqJvf6nsDodBqadqxJVGhHbTE4FhEOtUHz8LLS13UXl5uGqm9I6zj2Ge/9ofLTCv2e285tomlg1hbuILVMmwr+8wFN3KPZZ2hkzSxY05b15VLE/BhjQ6xV3AUbHlvDlvr/kuyEQUkQTILeMsKQ40liTWAmJB8rKIQ1ywzgWGOB4qzgR699IbEz8b6RQxE+bNU4QAcdQsQANNRgov98zwJndIbr20nLrPIyqeEopIrUMvamuLHcuTKbVehHdoRkfhxjwcBIg2599I3eivKWKMLED2+7o3ZqG+BF9xRvEGFPfbYfb6babzyHC4GC475N5gw6iFxYdGaMfRmSM2tBJ014fGr4wzMIz0kgyqEgCpK5Xq33Sxc7no4GA1x5ihAIxEdrykwGUdztSYZlCvyFKFso9NVi/vsY6euN9giXeEBG9VYnlByFTKq3Cqat2tjBkm21PFbYLCKlnEdMOU2Wgm755Shp205Jhgz3QImdo3NSn6HObnRZ4tM+1icPjAxoKuvFtq3aeUfgQltfqkdQ27xVKX5bAs/4cg+0RbzQs1tMEyHFvOT5EQ9Ztn4btmioyg1cwAFrx+S61AydEaoY/2fiB/pGDUmYG9lu5Wl9BU0dtS8b+0bgsgt6iY
 umXNUWJt
 Roa6h9AENAjf9kbqH9Dqij3XzRRUS36ycASQeZl3cD22XNEL4M8tpw/IJ/E6Ml00jYD+qpS0VCDg94vTQMEAQcDozW/ilwHvPpCIflLX1vZXNbxEP2KKPRFzJpHwDv7ezvWftkVZ6FNlnCO9r+LtJ/PhYOjKYmUAwRDsRRNKahXzPlkkuqIEUkSNj/1M5t4SwcvvHto7jrqzBTswY/NOu9AThR5CBJr2C/kCuarYkWND59xYwP8zyCKjV9AmKT9vnWoVOwIEyIuIoctvnIge16wDp88VaETGj0uI3USIvSjyMy2ZYtskZCZDqUmHy7jgkB7tBX/RgDvNEyxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Gomez <da.gomez@kernel.org> writes:

> On 2026-02-09 15:38, Andreas Hindborg wrote:
>> Add a convenience method `contains_index` to check whether an element
>> exists at a given index in the XArray. This method provides a more
>> ergonomic API compared to calling `get` and checking for `Some`.
>> 
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/xarray.rs | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>> 
>> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
>> index d9762c6bef19c..ede48b5e1dba3 100644
>> --- a/rust/kernel/xarray.rs
>> +++ b/rust/kernel/xarray.rs
>> @@ -218,6 +218,27 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
>>          Some(f(ptr))
>>      }
>>  
>> +    /// Checks if the XArray contains an element at the specified index.
>> +    ///
>> +    /// # Examples
>> +    ///
>> +    /// ```
>> +    /// # use kernel::{alloc::{flags::GFP_KERNEL, kbox::KBox}, xarray::{AllocKind, XArray}};
>> +    /// let xa = KBox::pin_init(XArray::new(AllocKind::Alloc), GFP_KERNEL)?;
>
> Side comment: I'd also update the examples to the new coding style. And it'd
> probably be cleaner in the first commit.

I'll switch to the vertical import style.

>
>> +    ///
>> +    /// let mut guard = xa.lock();
>> +    /// assert_eq!(guard.contains_index(42), false);
>> +    ///
>> +    /// guard.store(42, KBox::new(0u32, GFP_KERNEL)?, GFP_KERNEL)?;
>> +    ///
>> +    /// assert_eq!(guard.contains_index(42), true);
>> +    ///
>> +    /// # Ok::<(), kernel::error::Error>(())
>> +    /// ```
>> +    pub fn contains_index(&self, index: usize) -> bool {
>
> Nit. The method name may imply there's a contains_*() variant. I'd rename it to
> contains() so we are consistent with the rest of the API.

I disagree with this one. `contains` might cheat the reader as it is not
obvious whether we are querying for a key or value.

>
> Reviewed-by: Daniel Gomez <da.gomez@samsung.com>

Thanks!

Best regards,
Andreas Hindborg



