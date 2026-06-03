Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2B2CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ADF96B0088; Wed,  3 Jun 2026 07:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F4B6B008A; Wed,  3 Jun 2026 07:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474A76B008C; Wed,  3 Jun 2026 07:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 363E36B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:50:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0297C1786
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:50:15 +0000 (UTC)
X-FDA: 84838433190.11.C6BE4E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 45CDF4000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:50:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhNJgko2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780487414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4Ne4AcnEVQJPDihAVbQKtYCONwWtwV6iW3rmzq4/l4=;
	b=P9vaCaR/cgL/XK3z8kh+WJuqb3z9TZJtQXv+JZu0/7O4l2DC6c387O7ZAfshoU0M+c/Q+9
	9kP9bnFrT/BKmbYZ8sdEMOJfmXdAywHNwbhbdq625MsoJ86pIF5kjMNbvdzmJi35/Ttz4h
	C3VtM8WZi58IYcM7nT+sgYQEbF0sK4Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhNJgko2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780487414;
	b=tVOXKjkQrN1ro1/8WCuUNQ6cf7AiHP6td3Us0JnwLip2BPtLfphiVfhcmMzG8JDSuTJFwH
	INb6RcUQ+mEDL3I/KN38JrpNgeyzWQSYuduRe6tV0xL+3SJxAZ5QzWjG3QEZUT2vl7FUWk
	GjUP130LoUdK5TzmkDCopVA8HYtMqfQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAC5E6022B;
	Wed,  3 Jun 2026 11:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF871F00893;
	Wed,  3 Jun 2026 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780487413;
	bh=g4Ne4AcnEVQJPDihAVbQKtYCONwWtwV6iW3rmzq4/l4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mhNJgko2iFrHnbrI9QLu/kPDYQAZDmWDKHZRVl3SPfbMAk1ZB4tR5upjdM8eH8wZU
	 caoE4IfkoWclszuykFOh61zvf/+Y7hCWEMJF10hzwrey3DSRb/i3rMFVWow8mqfC2a
	 ULL/udCkGCSKRA1ELKoWAjlNDsyrna8gbDBhwLxvcAgrZAR4TrigM8brab6sWPw4a8
	 m9KLsEjmeZzuSE9Pat6lW2Mow0flA/pAIhrhhDAAnG7TUUSHxJIV0x2q0UfkU1YBb9
	 ADXYoRF1UfFbWFlPcELNtmMYBGemS7ymRWCgoMUT0U4rrpdCj+1VMJCjoEBmUdFWy2
	 NlTHDJ8yC6HXw==
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
Subject: Re: [PATCH 10/79] block: rust: add `command` getter to `Request`
In-Reply-To: <abfbuJVbPtIEyweC@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-10-de9a7af4b469@kernel.org>
 <abfbuJVbPtIEyweC@google.com>
Date: Wed, 03 Jun 2026 13:50:01 +0200
Message-ID: <87mrxbkfme.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: kowsw5f9npz637n19r4yrf749fu4ptnf
X-Rspamd-Queue-Id: 45CDF4000F
X-HE-Tag: 1780487414-901489
X-HE-Meta: U2FsdGVkX198i2cLe1tNYnyXc05tP6Cgri8ew6/ciQC5mOBINX60MVBlEFSW0BySCD9+YUAIkUqdRqLa0RvEtIi3nOSZI5gHEQ3K/OivGiAHebjzOvZF6khHbQKRrpFmQftitenLxgMICCMl0TscP18vzdF8dtnRF0Fs51IpHRe8PiRCykK4SurwmJPV9lZdh1Rq7O8FIYXfXRvzpRGkAtPYPId1ZtGJl+iTI6XbmJOsPsbeoOX9AcV1VInrjFRPertL500meNQUfvJndvHf9I9nC/CQnkshSdRRFJpnwP+KRLcLHFfDqcMYcqyF8mMCe95H/um12ln2XIZrFP2o3k0VvvPju3/HLFlU39zscD3BAtRD6cz48KUTtIg/w+k7NFPypOzvTevWePxxss1b8VlnLQ99AMURmml3zU44I14r2k0m+DcSfQhymVl/+Vcjt+Ne1AcoeN0UOY6kkhDStNs9WtdkHjJ5PD8STLhzE8LXqEi6+JqJN9rzyHHKBC79P45EerUEQxL47r1DGolJYjIfhme+vQh6EAd7CWwwavbUX3iDtnFhJZP94OIzT5Ou1tQEdBwu4Yv+kAmMmwKl/h09Cb55CGmZPon2IGXJ25uXfv+XnlS52eeN6ty/fH3PchocjXWUsSHlcBGzDs8Gs1pmRZcn5LL6gljbP8A8H6nmDqGT3JUbYtrhHk5bAUTvZEPm9/442VKQzGK1x2TW5RfvfZTLMx72x7JlqztDC7wdUhBgoUte3MqeHlXUjm8SrLGdc7vLMRv8LKy0O9SkEt6bNs1PphXeSAYFiw2TRD/1ZIIFwI6qlpjkipqftoVN7Cv6Ck8d+3rXvbz8X6YyehkkypumLixgo9vP6yLvx+Y4xnWZExedIE5R7t80seAXzx1wBP9Gf+WliCS0MH9zuCMe1Pj48jxhwB1hUbT6u/CH6Tz1MiNyFvPNvIuP/d8MBfnoZoly/hKN1CrKUOr
 a+wqUowz
 iEkIoYM+1lzNd8OiWApMO1UuTFzdDAZzPKj8Ra9WBTvs0G/oR4AQJC4hC2AICZ6v3gNrbl3uT4aC7jjeDIYI0cJavOks4kpPZ9SCfLu2Yddi/5KIibyACS01BERFncyGm1GFHeA/LG2lJCQEiMRNlgMYI4TAy0vf2xAk+PwBrWtah98IP7UyjkJL2/clvTCsOHzEaFaDGdgqlQvNP9Jf9n5b+ih76U3HkoOn7poiMFRVQ5HbL2nGP83ncxCMp8jcK6TY8PAi1fPKBEVY1Dlh6ajKVVwDDPI7cc5J6daQfX5VKFl9qLBD/+gJNJbePRT2zrryj+b6yCtReMjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:34:57AM +0100, Andreas Hindborg wrote:
>> Add a method to extract the command operation code from a request. The
>> command is obtained by masking the lower bits of `cmd_flags` as defined by
>> `REQ_OP_BITS`. This allows Rust block drivers to determine the type of
>> operation being requested.
>> 
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> With the nit below fixed:
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>
>>  rust/kernel/block/mq/request.rs | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
>> index b49197a0c66d7..0dd329ae93dfc 100644
>> --- a/rust/kernel/block/mq/request.rs
>> +++ b/rust/kernel/block/mq/request.rs
>> @@ -78,6 +78,12 @@ pub(crate) unsafe fn aref_from_raw(ptr: *mut bindings::request) -> ARef<Self> {
>>          unsafe { ARef::from_raw(NonNull::new_unchecked(ptr.cast())) }
>>      }
>>  
>> +    /// Get the command identifier for the request
>> +    pub fn command(&self) -> u32 {
>> +        // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
>> +        unsafe { (*self.0.get()).cmd_flags & ((1 << bindings::REQ_OP_BITS) - 1) }
>
> Nit: scope of unsafe
>
> 	unsafe { (*self.0.get()).cmd_flags } & ((1 << bindings::REQ_OP_BITS) - 1)

The `&` is parsed as reference operator with this change. But we can do
this:

        use core::ops::BitAnd;
        // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
        unsafe { (*self.0.get()).cmd_flags }.bitand((1u32 << bindings::REQ_OP_BITS) - 1)

Best regards,
Andreas Hindborg



