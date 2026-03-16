Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6AFF506D5
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486E06B00C2; Mon, 16 Mar 2026 09:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434606B00C7; Mon, 16 Mar 2026 09:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A496B00C9; Mon, 16 Mar 2026 09:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5896B00C2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:58:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6B9A13948C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:58:01 +0000 (UTC)
X-FDA: 84552079962.27.24D80BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3BAAA4000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:58:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=odexS+4X;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773669480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNLvhX4ALbl3UHGBSZN0lioDZZ5bzaKqv8iN/0Qutow=;
	b=18Ktvl+DCzIpcQD9B2UAANv2q0bJu3NBu8lZ8d2KCdlvZmtKk+7whIIUHipKKwGs/FtBYP
	f90e5mqADPj5C0BZ16bHFg9rEDhVqusSwESg7O5WQZXklhRyK05ghuP5bVgdjtov/98Ddc
	5krlhFb139AOvmFSCEAwuImW+FDyc9s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=odexS+4X;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773669480; a=rsa-sha256;
	cv=none;
	b=YaPwsqgaJCbDfhogrqDxoJyN57w1RWw7FQhaSpf2OwajGWcT/c5VttNOGs7IFlyX+12xjj
	keIBb3iz1e+SptBKQ7+7phRJIW9qIubjSJLB8otptZg+E731HBlRBIOufKWW/Yl05G7imn
	OjJjOFaFGuhq0SjIvCOq2SnTNHM956w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 91CAE60097;
	Mon, 16 Mar 2026 13:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14F3C2BCB5;
	Mon, 16 Mar 2026 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773669479;
	bh=VDUeCgFqwp2e6JJJ7s6KUkN8gmIfp/ny7OylspMs4H8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=odexS+4XwBT5gxh2uEzcH7csdkjlHlHyrsjmyW/FmIbbGuIjt3WP1zKzkTbsAGld1
	 SuCGvAC75w+LV9KezFY8t2eWd+icKSifHjeSfYHqY/B2ZkBXLLa/wN3/ReuaYdJ0j8
	 V9Q0q5FN40LVhtZmtInZDKJN/vnCZhDVZRxBcY8I9bSIVjDqQd9tNos7baTGObfQSy
	 A1t+LSEG2SkRW4agZr+LELx0uZDJrLPPNZMBQgDEufK/FursgY1qRzSb82KqP6k5UD
	 B4P4ejcd9Inp/o+lnUzEIZwCh7vvg0bo4zopiUwFSzFNFIJMewLxuq7NFsjJ3GjGpy
	 6ikzWa04rEH3g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, Miguel
 Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Frederic
 Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, Thomas
 Gleixner <tglx@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>,
 John Stultz <jstultz@google.com>, Stephen
 Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 15/79] block: rnull: add `use_per_node_hctx` config option
In-Reply-To: <abfe2LbhLzXiGCkA@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-15-de9a7af4b469@kernel.org>
 <Y7WTRL6v0WsR-DWju2vumM1EBu4KZgQzE0VJul7mK3pUwD6ba0UuQO8sclDzOaeLGGh9u3WG5iSKq9T3kQqH-Q==@protonmail.internalid>
 <abfe2LbhLzXiGCkA@google.com>
Date: Mon, 16 Mar 2026 14:57:47 +0100
Message-ID: <87cy13swpw.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3BAAA4000A
X-Stat-Signature: wmc47s9xmmgxccswdeda348md6mg63c3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773669480-931421
X-HE-Meta: U2FsdGVkX182YbY49JPKczhIL5EUpWPNMwk2wHuU8+syQwBscpK+vpC5zMi616RkQVZrUlC3A06T1gwACScLNHY/hsc4VisJbCh2sBw7uCWTRI746y3S+jtecpsfzdEWAeDOC/fbJEK3miN/IXU0LjwHb+Ns93OEkWkq7H+ft0YmSi8d+BjTTx2R3KoOqigsTpZcZ8bo6YnCR/1pCRDqeXb0VYlSxpEYxeU/zLEcFGfjxvIcA6nPoHjDiI2X0TLs+EK1W0YlTDE9c+bJgvyvfQeMYYAGnsPL6IH2yq1oO812C7Rs007dQ52KMluAD2k+36aBSZpD3lzlVK1hy0bPBwEjzZd6NM4YTl2y2KV3r523+lM2ddU/2iURF8j07REbvn/F/qUBON9KKFww22lyhvDnxViqySSiVrWX6cs/XtGHunM3YqAeUt+Ap5tJuB4qUksYIWmSiclGbqMCp81EopoZKgAw0pj53kgnv2uK8ZaHFKKzssF2eD/f4P32L7kaE1H7kVm+w1DA5COAaHOilTHCmnErHjXZHesvNcq1NcLJkHXWJWLhtRc5f7I497U/7CazxI6LverbrXJh3D8nY00vhLWvu7Q92K6PCOZ5vzgxNiNAgmJNmmi519FLSff5cNdHPpUAiqkP8u9Wh90ByDQZf0klorQHvlx2fILlsADUDm6Wi0zOIzd+8SXjq1mZ48fFv4ug2bwv2Xg1Xor+GtfFhTN7TqSRvcwfN2Xv17m2DeKXnOgJZKIJMiMUPkQdY8MdktBj68+dQGqI8y42S+YXpkbPSylwWkuY+Rq7u/yyPZi+2DjGGYEz57IZ4GlpS/27QcFF8nRzTznvt6MkbAfEr4RJT+GmsRqpSoDsTnZ8e9/9JPPZjE+Bu6n5o5v4J6l4djrcpioqHeVWTMiJS1onzyJ+8gXDKa/ewQ0pCZERSE3VhreT0OzDDKVvt920Q/pQtXZxjGqerkdBpdb
 FJ1FNG+1
 A14fUhd4xBMi+amFE16Ov1uQH3pMqtG1O/DxuWCm4lMT97vrTviBVE+Fy+qZKTYE1pIFftsl1L07f7i90dQx3LPSnE3PLD4Mbni25GryjwvOKMG84AZVOwPBJwVFXcVzg7gZl8YyLT3QHgWjCnG2avlDHpBLsIqTCTR1WPPiVO+/0EQX3ojL44pAPm8ZVAHYxKkaSHAEUXpAaozchmjbQ/x0rdXOppxIvFLCYCToyFkGSwvSxj/px32DniBd/JpgxsNgPq3A275NiVil3cBvag3hJtzN1T0KQ4QpZjNAk+riaEUOUMuxCeyv7+G+aIN3bOMI0UwGUV9Y8xV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:35:02AM +0100, Andreas Hindborg wrote:
>> Add a configfs attribute to enable per-NUMA-node hardware contexts.
>> When enabled, the driver creates one hardware queue per NUMA node
>> instead of the default configuration.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> This and other patches make me think that module parameters should have
> value() return a copy of the value (and require Copy). For non-copy
> types, there can be a separate value_ref() method. You would avoid *so*
> many asterisks by doing that.

Makes sense, I'll send a patch.

>
>> +configfs_attribute!(DeviceConfig, 8,
>> +    show: |this, page| show_field(
>> +        this.data.lock().submit_queues == kernel::num_online_nodes(), page
>> +    ),
>> +    store: |this, page| store_with_power_check(this, page, |this, page| {
>> +        let value = core::str::from_utf8(page)?
>> +            .trim()
>> +            .parse::<u8>()
>> +            .map_err(|_| kernel::error::code::EINVAL)?
>> +            != 0;
>> +
>> +        if value {
>> +            this.data.lock().submit_queues *= kernel::num_online_nodes();
>> +        }
>
> kstrtobool again. Also, this is *multiplying* the existing submit_queues
> value by the number of NUMA nodes?

Yea, that is not right. Astrisk should be deref on the other side of the
left hand expression.

>
>> +        use_per_node_hctx: u8 {
>> +            default: 0,
>> +            description:
>> +        "Use per-node allocation for hardware context queues, 0-false, 1-true. Default: 0-false",
>> +        },
>
> formatting (rustfmt ignores macros)

This is intentional. The line gets too long if I pull it up, and I don't
think I can break the string in any way. I think it would require
changes to the module parameter macro.


Best regards,
Andreas Hindborg



