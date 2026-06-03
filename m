Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3344ACD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F92F6B008A; Wed,  3 Jun 2026 08:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9EC6B008C; Wed,  3 Jun 2026 08:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0236B0092; Wed,  3 Jun 2026 08:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8D86B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:43:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CB76140363
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:43:51 +0000 (UTC)
X-FDA: 84838568262.21.B20E993
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 78D13140015
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:43:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMr2uM+H;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780490629;
	b=vw9Bzsr6u/F4lUM/BOE/RyKYjpPg6+MQoBhJ5JlhWztkWbwjeKpkcCsp9Z06GjMyeMzCNr
	lqr+CRYlLsGg9keoLn7mStqG0A0PQjE3bMOFTntCnZ3CA6y/SpUNUey7I/Xl3c1krnBwT6
	PS/s8RFypnS219OjIv0k0Y0AbHyKN0s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMr2uM+H;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780490629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSlKPq/EwdliQicBG142n4MIcXe9Hvj+qJ5zrzWkG8w=;
	b=Ju0NpaeDwdVMNQVZ3c68stzInA2p2KiijV1r8xOKlSa/opAbGEXHzgo5UfImToxla1lr6U
	6sL+BMzPSqDdwUUD52UKDVsAgIOlcCMoaNUF1g6BXKpu+eaJ9f3JnKNcAAzvTnw3humv+R
	eV1ffgJHMiVqCCho270RPdKQzXeX9G4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0F9E60221;
	Wed,  3 Jun 2026 12:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571ED1F00893;
	Wed,  3 Jun 2026 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780490628;
	bh=hSlKPq/EwdliQicBG142n4MIcXe9Hvj+qJ5zrzWkG8w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dMr2uM+HMXmTM8LDb3J+bX3sfxt4mX1Xkqpn7J8iBGmN+/7xnPHt2aDWxBnSpSTpp
	 +D8heQVrPl+rEhsni0T568ZZvyGIQeapGfjTlhY6O3s+9e1tIxi9w53o/v0ic5rjKH
	 uNNTcVOAVPfiP9krvWIXGhsFrhISzcWvijeqPpHPv1yu3VKvGeNreGNQqo/7n+/jF4
	 Q0m71pq+Mozsv2jHy0gGQEVI2p1H+/dAQiAhDg2d2gpH1KqdULYU5r60t6lhTsDvCU
	 lPbQ11nd76hapbeuTcRhHvRWNsW/cXbPR1P9+x/dYyHTIQILVOGRXOOBtvAchPV3gt
	 8o9sBOG9jsE/w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, Miguel
 Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
 Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 26/79] block: rnull: add badblocks support
In-Reply-To: <abfxSTL2qTMtpnY7@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-26-de9a7af4b469@kernel.org>
 <abfxSTL2qTMtpnY7@google.com>
Date: Wed, 03 Jun 2026 14:43:39 +0200
Message-ID: <87ecinkd50.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 78D13140015
X-Stat-Signature: hm1pfyckzkws4rk8pms5j5ukr41ytawj
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780490629-452153
X-HE-Meta: U2FsdGVkX1/frOfpMorKEMMJCQHA6uXZamX6YNK6ZDiGpF40u2O0HMR2ju51q2hNUBzvV6k5iJnvyDtTuBnxRKAbfZFq6jIUoiQ7KNaTWJtqCTe/4mimoCMzXLurL3nVkj69Ek0G9Q/W7nc4aGnxigCLjuH7PoDEpU4OW2QUdft9eVSmnqGlBVhEfNCdOlxLw0V+mmEB01WDO//9yLZFwr6vK+6Kh/z5J6D6MlJlG6Ke/iU2oT7iBk6DR0DHQInLxXgzzTrnlJnbzfmKEajwKjpBPjQJ0HKD8G93yIozcSJrPWhZxNYNxCUCLHhlkjuGb/uI/WmcXqws73FVz/JhyeKmf/pX64oT4zs4wxbz0hiCjz9mP17r30TfXF8OROtwOyYjJeB95KEtNLhNbwYMqSCSbqfh8vQko98SY7beDAlY773pGaDsfbSFkPu956IJuQwfiJXwmZw6HKYXQ8VCXxCX9zgzsVuDdgUzlBWm+EkK7ud7Ri9QB2mKGTn5yf35nZq9CUMayUvMD5QsRV6Ig9KzZv22pkdIL+3JultomWkJS/d5aSFlMzXrWT0Ks1OJ2y6T13kfpNflsqiROCiy5QvZK8igLNxuZmRrPFdoXOj5CbkDqvTVRN/FeiZq0kiwcVXs+lbEJqd01HQelt4MrZD0iYQNxTzQFLttDXBlVbdEWLP6xRwJirTqpkgZCGDqpaDYcbH4DDE87TRf1rNkY3JsP24NsZBHwO0P/bT2dRoTIxG8nmBRz0eqPBQ5jRXkQ3T3+lYOWQB3XR/bG2Q8FKMV0vw8y2j3beQsyKQJlB+K1b/2AKqmeK7ArNet7q5TWJ73weV528050iUzhevFn01eBPog+Mm1mzb9Q4ncFwmzp2v3EctqtdAN4E2sC//mt5YrJHtBsy5qM+ZhInfUYktrsQ1diVHKeZm9IQhTN3pqizQ+m+xacV8lYz0Ev8O6bNl2/RHi9Tz3w6cOgqE
 1vy4pxIN
 B6Tt3xIeCO5aLr0IC+LrslqIOq4Gybhlc2MUT/tQfxsPhFBq87DED7yJIftDg0vIQPVuL4JsLatRjj9NLq6/WNz7VBLt4Z3xQK6zr9gpuV+2eZ/9wD2VaT+MjoVeFztSvzPIWKkdq6EUGBf9VAdygq/Lst7zcrP/c9i25K0RVuiOpSXNrL7RgBT7XeOpQiFcZQExh4BVlEimxUNQ/3u8f3sRKy05o9gfl487dPvLZcvvWAP1DotwIr4Ulw/bS/whVpaBfB8M16AmYXAA9JmoC71w5wOQWtVC883wjDUK2CDxfYKB/lakCWPaZ8N6Y3EwWREhuRPSscLEdwDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:35:13AM +0100, Andreas Hindborg wrote:
>> Add badblocks support to the rnull driver with a configfs interface for
>> managing bad sectors.
>> 
>> - Configfs attribute for adding/removing bad blocks via "+start-end" and
>>   "-start-end" syntax.
>> - Request handling that checks for bad blocks and returns IO errors.
>> - Updated request completion to handle error status properly.
>> 
>> The badblocks functionality is disabled by default and is enabled when
>> first bad block is added.
>> 
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
>> +    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
>> +        // This attribute can be set while device is powered.
>> +
>> +        for line in core::str::from_utf8(page)?.lines() {
>> +            let mut chars = line.chars();
>> +            match chars.next() {
>> +                Some(sign @ '+' | sign @ '-') => {
>> +                    if let Some((start, end)) = chars.as_str().split_once('-') {
>> +                        let start: u64 = start.parse().map_err(|_| EINVAL)?;
>> +                        let end: u64 = end.parse().map_err(|_| EINVAL)?;
>> +
>> +                        if start > end {
>> +                            return Err(EINVAL);
>> +                        }
>> +
>> +                        this.data.lock().bad_blocks.enable();
>> +
>> +                        if sign == '+' {
>> +                            this.data.lock().bad_blocks.set_bad(start..=end, true)?;
>> +                        } else {
>> +                            this.data.lock().bad_blocks.set_good(start..=end)?;
>
> Taking lock twice: TOCTOU.

I fixed all of these, thanks for reporting.

>
>> @@ -118,6 +125,7 @@ fn make_group(
>>                      home_node: bindings::NUMA_NO_NODE,
>>                      discard: false,
>>                      no_sched: false,
>> +                    bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
>>                  }),
>>              }),
>>              core::iter::empty(),
>
> [..]
>
>> @@ -155,6 +160,7 @@ fn init(_module: &'static ThisModule) -> impl PinInit<Self, Error> {
>>                      home_node: *module_parameters::home_node.value(),
>>                      discard: *module_parameters::discard.value() != 0,
>>                      no_sched: *module_parameters::no_sched.value() != 0,
>> +                    bad_blocks: Arc::pin_init(BadBlocks::new(false), GFP_KERNEL)?,
>
> It seems weird to construct this Arc in two places. Is it shared or not?

In the case where the device is created via configfs, the `BadBlocks`
instance is shared. When the device is constructed via module
parameters, the `BadBlocks` instance is not shared. In this case it is
actually not used, as there is no way to enable the code path. But we
need to provide an instance anyway.

I did not want to use an Option, because I did not want the checks on
access.


Best regards,
Andreas Hindborg




