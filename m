Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA37CD8CA7
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBB26B0088; Tue,  9 Jun 2026 04:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B416B008A; Tue,  9 Jun 2026 04:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FBB66B0095; Tue,  9 Jun 2026 04:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A35C6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:51:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D57A94041A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:51:18 +0000 (UTC)
X-FDA: 84859755036.18.0E91CC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 05DB94000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:51:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OlpdyG3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780995077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nDVPgpp1Ly0QDUYr7vUHvL0g/QTd0ZvsPif4iWADII=;
	b=oB5opyDmo/HahWBrNJTpX+JyY+YV6zSkIWLA3f7KnP01zdlM+SHppQjCwoGWq0TsHgmywM
	99bG2uRZoNEzazyFLVvNT9izzQ5/6zvpRkJ7rpeQaqXr0KDUw9POOWh5uGn/pDB0PdLxq/
	2U0z3Re8o2hxPL8oSkBPjCZqqOnjcU0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OlpdyG3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780995077;
	b=XBxWrKULcA/xsPUe0o8HLQahF6LxKYL6bJymVuO40lBodsWBSm+8O1FGaAROjiHKEgh4o8
	Sy1uwkIHUBloBvXQwfKVKFUkpyknuLo7g0qNScr0q0D+GOp1L0DAVe2d2iQR2lhRlrGUur
	wMhGWrTL0EnR37crF15GqIP6hjKUPSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C456419FC;
	Tue,  9 Jun 2026 08:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFD51F00893;
	Tue,  9 Jun 2026 08:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780995076;
	bh=+nDVPgpp1Ly0QDUYr7vUHvL0g/QTd0ZvsPif4iWADII=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OlpdyG3UWPhN1uXUi98IS74Ht7BSPhiSYXnOsvq3E9qRV36IJ1OihYJtlMI+FIDb2
	 BjaN0cFx5TeAcuSB2Y01mncxs1/23kq5jocXpuToxCv3ylCnu5nrYfa69QY2zOjSg8
	 KyuAK/rDFdlzRoFajLcIr2NF0UBmFlzkuppUGyXxPcYKrX5Dwv+/Gs65j5koj99G6j
	 zeoX2ruCuxcLz0jWqz6Ug9q6Q6qjd+vUNEpSO9mIqOKk82ggH0V7vXHlNgqBcHsO1J
	 prkdKVrcewMaXpQJzozyHqLV7he3TIuGYrbQk1sqldsf/DCdswgif01DNxmqVvkJiv
	 +KNuzkHNMeoSw==
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
Subject: Re: [PATCH v4 05/11] rust: xarray: simplify `Guard::load`
In-Reply-To: <178067251349.96312.11784247103754750756.b4-review@b4>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-5-965f6028790e@kernel.org>
 <178067251349.96312.11784247103754750756.b4-review@b4>
Date: Tue, 09 Jun 2026 10:39:21 +0200
Message-ID: <87ik7sglae.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 05DB94000B
X-Rspam-User: 
X-Stat-Signature: rpj65zfabiad1fhomrdp4cbuzoetuozn
X-Rspamd-Server: rspam09
X-HE-Tag: 1780995076-817903
X-HE-Meta: U2FsdGVkX19is0uDmlGeQj6WhBveVl2TiKdUduSdQ0hDJB/LSAkrp+J+u4i2ruqpmnoza6/ikIDZyndylQhLR0n9vYXYzh+RszRf4+4iueHrxBCTR8n5lsNrAsOecMnGkQtBDomXr7teWtka8p+0prV7LtA2KhTjhUbtqK3FWIw5rudIbCegAVjQehAhpPPtoYXukojIHSvNSOLZei6iii3Ww6+F4Ybyipk/TiDqB81PE4zahIlxmmbkc65UI69xr2p9wmL8MCcvs9j0CiIZn1HEsvTo18HpQHMAtqKhxoB+hUwm06BfylKYvJKmtlyuJOxAji47KvZamWlW+ZyxJiAFgqXrSvowCV1Sh2rvvjsb2RTfQtu6gb/fOoHnfQ86PvINUPCB7eN6pehJUo+3XOBtoo6xP8ie1J4ZkpO2dSMT/a6SQY0adNoi256PQcTNyTFeZl6vbNXQg5VptIQb7nD8wdKBLpndpbcVD/GsTG4fjhaAwipu5jHw/nxa6+ANFjQ2WOg4vxQBRU+kiuAG0dBsIhXm7D0wceb80PWzTgIK2LBj/qwupoW3OzP2mxGPlRTGkztcr2OXmUuNnYbLcm3AKlIRmSdasLw4h3Pq+cJZmCkL+Bl1D8wsbPXFDaYi73ZwSS+3MgAAA3Lmz2dMmRGrbu9vLPKybx9CMoF3++2ucNAM+ck7Aw33wCH2fVjEqjdzCMzUDR/JWe6q6Md5fDbuSDSz0fyVsbkp38GNAjSZupaUszSqxmCaaZCqFXXtNrR4ijJAWs3iNXipu+PB/Ic5OH4V0owtDE57K9TekI/5NDl3Y6rqOhYapDMqrgxoKWi7isKiH6i32690qDNE2+H5V4CDYp1TkmP7BefgoQj8e3xZkGzEb0cLhDUDqfHhtPCVBPx2Q8pNqpnJ7dAYsYZdPVs/nYTyUXZUwmsFI6F5Is7QuM3onxRLgqAH6MxJDJXQPstPQsR0JVK0pVU
 hKx928Fy
 wicHpIsNhAXBFg5n2GdXnuyAxDICvQYDcflO2ujAV/cKStUa6XRrXQ7NQlcMO7gfgif7nCaFl4PFD6mKNKOqEQYc+lYVv+8yCP7tNiIRGdax0n7/Vf92tox/qVMbvk4ewXhzNl0rHaLZGU41uf6jYkcUYDn8uzZIeJd/EGG2/SijMOIf/hgwlA2y/yoa23DR5ed6XOWOadU4lqMhZxqqbZsElah/+ZujytfZ54r/hlMX2gw+yFFEU+OzPsksvNGRwuoEUUfRI+mQwIOA7n/sFyR3kLMjQaRdwhn1nEoMcoRjS+HPZh7d9p0nCw3+xq7njXfVqqexMvTWBww4YqnZmY5kbg02dOq2M9pQ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tamir Duberstein <tamird@kernel.org> writes:

> On Thu, 04 Jun 2026 21:58:11 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
>> Simplify the implementation by removing the closure-based API from
>> `Guard::load` in favor of returning `Option<NonNull<c_void>>` directly.
>
> This is simpler, but the closure-based API was here for a reason (to
> avoid passing around untyped pointers). This patch is estabilishing the
> style for subsequent patches, but doesn't honestly describe that it is
> doing so.

I'll be sure to mention this in the commit message for next spin.

>
>>
>>
>> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
>> index 05e6dc1ffe69..7da57c778669 100644
>> --- a/rust/kernel/xarray.rs
>> +++ b/rust/kernel/xarray.rs
>> @@ -212,28 +212,23 @@ fn from(value: StoreError<T>) -> Self {
>> [ ... skip 26 lines ... ]
>> -        self.load(index, |ptr| {
>> -            // SAFETY: `ptr` came from `T::into_foreign`.
>> -            unsafe { T::borrow_mut(ptr.as_ptr()) }
>> -        })
>> +        let ptr = self.load(index)?;
>> +
>
> Inconsistent whitespace.

Thanks!

Best regards,
Andreas Hindborg




