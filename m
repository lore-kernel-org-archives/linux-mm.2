Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7882ACD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5B46B0088; Wed,  3 Jun 2026 05:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56A26B008A; Wed,  3 Jun 2026 05:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C9D6B008C; Wed,  3 Jun 2026 05:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5FB16B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:44:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B0021402CB
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:44:36 +0000 (UTC)
X-FDA: 84838116552.09.75F7A8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D155A120009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:44:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y/D6RtCN";
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780479874;
	b=ySGjsjBWmsCohdes0YLBMgNbuJOnaBD1k4Hq07bObMD6zId6xq4fn5hQs24ehFmJZCcbpJ
	Ly7Y7Oc2XCSrV0m3+UoZ+E8G0vTqZYm7jhyMa7/BAk8hmW+bA8rUhDpZujPAfV3Hc/XZcw
	F5k2h/H1kpQgJ8a09O/Q6/qHiLIECYE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y/D6RtCN";
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780479874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpJeKk9lW29/IyZp1Ki8rVBSZO0YGcY1DZO51pxg2rs=;
	b=FXc3jJVRKiFMVQmiivb5HCkk/2uDsHVmPEA9VXTKD0tFv11rQv4Ae6+QwIna2K32tBrp9v
	HzDiWRwYI/tKRl3SIk4gRRavnhaWlweiGhUK3wv5R0dJGBGquC32RviFCM2k0JOSZF8rIQ
	tzQMFuIBM6GUu91g9XIfQB3zalmOdWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB99D4061E;
	Wed,  3 Jun 2026 09:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D521F00893;
	Wed,  3 Jun 2026 09:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780479873;
	bh=mpJeKk9lW29/IyZp1Ki8rVBSZO0YGcY1DZO51pxg2rs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Y/D6RtCNAjdz39r7jaLowrxfi2HQQ3KQ38le3EyL+0WtbqPeghH97gJ+CSbc9vp+R
	 Zel4nYP/Nc0xzRLj8kVuAeXvOxrEdeCd6WLzmpCq9ZOlbhpa1AqD6Qhj5ZVMEMpizD
	 /q2uDvTzA0sAQyrlNmNI15QT2BE1cbf0K7EonIBxe8ottQNOfMoofCDsmIn+YBNH+N
	 narLE2TYJR35kjSqv4n7osaQrTGaOvmCwdogFbKRd/rpXldw2CsKztJEYYIvSgywi2
	 yfS2mOEuKSIgHSUzqngSflMMXx0Fr/kcWYumsaTZvqmHCyntR0PvUKfJH8NjZdwDXz
	 UE5BdWHxyURhg==
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
Subject: Re: [PATCH 28/79] block: rnull: add partial I/O support for bad blocks
In-Reply-To: <abf0FHWkQzbnOtqD@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-28-de9a7af4b469@kernel.org>
 <abf0FHWkQzbnOtqD@google.com>
Date: Wed, 03 Jun 2026 11:44:19 +0200
Message-ID: <87zf1cj6vg.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D155A120009
X-Rspam-User: 
X-Stat-Signature: 7i11da8ordccauyssmanm3rk9c4otnsi
X-HE-Tag: 1780479874-710233
X-HE-Meta: U2FsdGVkX1+MH8sENLqjGEAYlRVNWAb07XJqVwCXH25nIOkSIvUm9ioEBThaaVn+rCfEkiAUmLSffTbpdimThyuWcS+vypHlN3qzhCA2hY+AlIAW01KqCgE3et+cz/j7bkn1zslPLLHHZ9WUAO8mZ0Y9WIUrJ9c2iNnL+oacn85uo7AxwLZ1hMcmCUgjnqI3QURH2LWEVnf0myK91R5bVGoJziRPQtR7LCtnOE8RrXHeJH85xmkUH4uYx5RjtcazH3kd6AJjvm555yYlRJFED0hCcbgHo2Lko7csSPF4ZQ3QXm+WoX+K6W4ahhSs+M02rMIgJz+uBNcMwgJItlN4b1MvdP/EL1D9jIikMuPGvrM6XyFjebJ93JDqaWPJhtP3wfH8ow7E4JDze9PgMw3SKasrOd80yWr+K5YDok+INBpnxPQIH5X5gfAONYgJRWaHVr6jN6D1cdUAgW8GYC6KMyszrrRNU87aWUsbr01XuIAHAS2FQKu3DPD+DaJIMxOfhm9Kp8kvFrXtEhm9EY/NAhKr6hEZJV7vm1pTINf97pWl9sBulCrWFN1YK7Ct1IosmQ3EfsmVQ5k5/2czNrNeBzg/1+crHf2M9LEjby2rnMLSyduPHQ2ShoIQHSf9gK2BlkLTMQkz3DhjqYe/CIa4H08ZCvFPgqE8SPrlgIg1oaBx12CJu8C2bFsQClqyOz/4A0MeqKhF3nWSuWa10ZSh1UnBKCvhx0M78+z85/zAFZONhEYf3CBhACqC/N0mBgQ+Ei2cL4cxg7/h2RT3qpBY4WDfijrcLCMVyBErfutRzlLdCiixnhN4CMqMYNLHBMWUIPzbK97xQXRM7OVWZU7tGTR8O4fTzKsJhqE6L1XnB91VV5oLTwXUvLHTdz37BP4gmbyAxcbKcXf4KhuLj7R9CZDk3EBBNmI8dYmwkkgAHUtHGloZm9HK8INuYj7nMUni5w5uWqaKQ6YEE+yzVAF
 rscTS3j+
 8psdglzvORVLKy6z06VfZSyvyZyhZxaPCV3Vlak3J8WRhOxs8Q2Lz2NbIpL6b5n1XauRWd67jeGgHPwvqnpV64uiHAdYzIaHKe9JO8qxzlL2j1CY+XZyGchD/u8HyXTPrQDzOJMetJqHo3YCh4XXk81D1sLhVyAGNy21K5t4MBEmjOaSeGQxI3HadpAyx6zu9r2d+hD7jGYjx/g18SVtpZuUwEoDuvaunbFNyvk/yafatS/5pSE34W7I3YghqtO/WrXIcaJWocpxQmeak+DMft9UIy/Ypx83jtLxQiAkcEbRL2O4XpbTuLjsnXqPWZXyd8leqS83484Vx2GE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:35:15AM +0100, Andreas Hindborg wrote:

<cut>

>> +fn is_power_of_two<T>(value: T) -> bool
>> +where
>> +    T: core::ops::Sub<T, Output = T>,
>> +    T: core::ops::BitAnd<Output = T>,
>> +    T: core::cmp::PartialOrd<T>,
>> +    T: Copy,
>> +    T: From<u8>,
>> +{
>> +    (value > 0u8.into()) && (value & (value - 1u8.into())) == 0u8.into()
>> +}
>
> This is in the standard library.

But there is no trait for this, the method is defined for concrete
integer types. I would still need to define a trait and macro implement
it for all integers.

We could do this in `kernel::num`?


Best regards,
Andreas Hindborg



