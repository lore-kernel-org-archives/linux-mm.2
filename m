Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F179E68158
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B857E6B0005; Tue, 17 Feb 2026 04:54:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32DF6B0089; Tue, 17 Feb 2026 04:54:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14CC6B008A; Tue, 17 Feb 2026 04:54:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D35B6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:54:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10658141105
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:54:46 +0000 (UTC)
X-FDA: 84453489372.30.CDA874F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4DB4E4000B
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:54:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/yigSBh";
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771322084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+iPKMT77rP94wwzRo3rtNsWTDBNMuqI0kwsF7y5nQI=;
	b=bIoy6SeUxFU3C1BuiYqrCPJTLdqVX1nDRaQUtbExUxUvBIrI86LGvp7ttRI83UEvhXC8Ip
	AHejf/gGF4D57+77AKPOiqRq59vm/vusVTnInNJ4Rkw9ydAOMMzrWLHToKiUXyquGisxAq
	3eexc9m0uHpwhClIM/llrmcEJVxIWuc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/yigSBh";
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771322084; a=rsa-sha256;
	cv=none;
	b=XB/TVZyy14I2NodXnfqnKtp0UatbwDH1/CFi0vDKUg4F7nQ4UxivsM1vitVigiMAz9kacH
	c//DWymhDt2msgCIkftY+p43wWaLtTDw632Ze0VnFW/2gYfSaGmfoXZjlGcox3rkTrZtl3
	4a16cJDYQ3UTrQyBhjeEUkrz4v1PO5c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16AC343FD0;
	Tue, 17 Feb 2026 09:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E98C4CEF7;
	Tue, 17 Feb 2026 09:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771322083;
	bh=OvhRtzauUYE1vtiYM7Ck4byDcsw4wUNWtgU3sMsXlvo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=e/yigSBhw5HsG6R95eIIT87pjgr6Q12VzafeNce1IeQ3E0SxOAZ6GtUNpjXzmeZNl
	 mjr+WkX1Zu5qrOg0llSZa8uupppQw8nO0ddWc4CgVhZrhzo3rAtQPOKeqDXqNHw06l
	 mhW7Ht+9FtfsnFWmtp3+U4tasPucTG/Qql+0Of+QzY7lv88ZWR7Mr563HC/XcuFYgR
	 TZAILEzOpUcWJHN7t1If1tB18PZTVODae7G+wN5/xmICPuiOOIOQ9c91q4CKeBi2bW
	 URhQMuesFJfkU19AlWcaiMX1pP7PR77p8xHDsH24C91g2EVWlrg5SEL7hNzUAznvi/
	 Xynrlrb8dHlPA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Ken Kurematsu <k.kurematsu@nskint.co.jp>, Boqun Feng
 <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, Miguel Ojeda
 <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, FUJITA
 Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker
 <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, Thomas Gleixner
 <tglx@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, John
 Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, Ken Kurematsu
 <k.kurematsu@nskint.co.jp>
Subject: RE: [PATCH 62/79] block: rust: add `TagSet::update_hw_queue_count`
In-Reply-To: <TYRP286MB59951867FB2026AAB52DA80FDB6CA@TYRP286MB5995.JPNP286.PROD.OUTLOOK.COM>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-62-de9a7af4b469@kernel.org>
 <DlelngRf2sXB2dUQOltrLhHN_bPwumkBYEef-iGa_6HSHxyilar1tt87eOVUD7v667_I--EPwiAeRc2-rA1jZA==@protonmail.internalid>
 <TYRP286MB59951867FB2026AAB52DA80FDB6CA@TYRP286MB5995.JPNP286.PROD.OUTLOOK.COM>
Date: Tue, 17 Feb 2026 10:54:30 +0100
Message-ID: <87seazd7ah.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4DB4E4000B
X-Stat-Signature: 5gge8e1nomecjkpusjrrf1hhahdmz57i
X-Rspam-User: 
X-HE-Tag: 1771322084-325887
X-HE-Meta: U2FsdGVkX19GEQH6q1GdkBoKGKYf/ogKPnCWNwyq671YbJJnuyc+pW3jIzVbmHgrawjGR/jpYJ021t0FdM+mc5KnVKvmBKceAwPRAuGisQqP3MzKpWov7g8AGXFiPN2IUhcjjXHHa4XIua30xY7jQlPnH9MJvt2xYHFYdf0WOK9k7WR+d4gDaMweKywFpuIhADwDDOf2moRoCwMYnI7ltAG8VTDVCemDmU7+ApnwteGmQqKfktOKQZm8Knc/V8Q8YiATtfYLu3b+fYFpWv/ItnteV4NgtV5kF7yfytuu+xA/l+kCVA11H1TUzsZWmJ8MIww6z0rvXnHGg/JAahwAcjQMVvqpSI6zpMNvIgXcLaoo5iu4xNUP6RyM3kvVFwRQJ2W7zURe3K43LZLcS/2DdDK1mBNPBO0ZUwCDvEm5rPu2Ch+4sXHX/9+vUuZtibq89cNBeZhs30sMeXwT6IxiNqLRTY8+82TkXkFKJNR2NP2wde3jmhoHBXbXkqBGhft2V9Irw/UxGG1evzQ4lEMX+YLl4dEz678vhadgd+rmM3oHaykQquiJlhAfGCSo6tZ7O9EafvZRU/U89ZAajdtXViyq3ktUqDqYxyFJHSUzdgInuYnPIN2tKa6zRE0/nMyjNK4+nXA15e4FkOY7wDgPzdG4mqUKOZd9Zy9pSTyfy1o8kmjS2dvVoqirMNRrcxcHCINnyl7q2GDlyLo3fE7flHDNyF2HqWexjLYJnDq1xFKJjh5zj3v6UnNnHrzPh9lCvnnwVXvaR4qU75/EEK8zKu3LVf8hUaPenBId2luyxYAgTjlQIkkXQyqpfjeuBTLUEJ/RPoUD+ykLthPu5IzLXLdfrY+nP04HNoSKk6jInxh3UYitbWZMMlDSJPEU6IW/Z7EEfrl8/AlrZsU3IBSUuQhn0nA+EYp8wo+dgZy4sO5humUYV5vxHvmBW/HDb9lQmRta3/r/YvPSKi4shZH
 AXNEz87k
 ODow0rb9c01VHDiY8VoIqy6yKGIhDC84KbpmI1RSX7VnNQ4QWDrYW/Ra0b2qkdPD0fS54REctGfbORBxmNMcNtVAWJoUoL4YKMolibvKwGbblolTgj3zv9h50ZOYuKhaR2E8MPyLdmhpLlCpqujkuDPXopomyFjLE+dvx8Q9RdZrrS5jM5i5W3HRfbckbd/liAg4qB3oXpgn9gA5Ivgf56oELBa0RLkGYql1mYS56OzX8KkQTyeWeUp740rhvyPX42xdQGmUzvzVhawtMtzYlZsJ7dbeLdNUGL29jfcMKsR8WPOkNfVsLt6PTv7h9bhq3kr+/MKmvnvfpsRAwDs6CdakVoylqtYPvu7925+epZPtne9udoW3J/zP80GbX7umAzWsW+Cp7KuRRpRyaTp4keSaS39NDjV9OUBgL+fCMxEw01nKjYsCoaBXEQGppSXUrU3McVT5gUFECU/sYaJsKoIS0nNGK0zuLtFJZn4tBFcfc4uLiyL46jBW8Lzp0WR8qxBW9wDb63lApeppjrSbIRG3B56VOPmd9S3it0QegbzYFTm1EMZQGPDaPb3pHtfyWSqlI9M0I2PkZc60y1T/Us9GxG+DIaqaVr4IUbuXMgQyO4iRNizSw+NgYA36p+lslcM6D2gNbsO/mFqrWyArAEDy10vQW3Q8YvLJ/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Ken Kurematsu" <k.kurematsu@nskint.co.jp> writes:

> Hi Andreas,
>
>> -----Original Message-----
>> From: Andreas Hindborg <a.hindborg@kernel.org>
>> Sent: Monday, February 16, 2026 8:36 AM
>> To: Boqun Feng <boqun.feng@gmail.com>; Jens Axboe <axboe@kernel.dk>;
>> Miguel Ojeda <ojeda@kernel.org>; Gary Guo <gary@garyguo.net>; Bj=C3=B6rn=
 Roy
>> Baron <bjorn3_gh@protonmail.com>; Benno Lossin <lossin@kernel.org>;
>> Alice Ryhl <aliceryhl@google.com>; Trevor Gross <tmgross@umich.edu>;
>> Danilo Krummrich <dakr@kernel.org>; FUJITA Tomonori
>> <fujita.tomonori@gmail.com>; Frederic Weisbecker <frederic@kernel.org>;
>> Lyude Paul <lyude@redhat.com>; Thomas Gleixner <tglx@kernel.org>;
>> Anna-Maria Behnsen <anna-maria@linutronix.de>; John Stultz
>> <jstultz@google.com>; Stephen Boyd <sboyd@kernel.org>; Lorenzo Stoakes
>> <lorenzo.stoakes@oracle.com>; Liam R. Howlett
>> <Liam.Howlett@oracle.com>
>> Cc: linux-block@vger.kernel.org; rust-for-linux@vger.kernel.org;
>> linux-kernel@vger.kernel.org; linux-mm@kvack.org; Andreas Hindborg
>> <a.hindborg@kernel.org>
>> Subject: [PATCH 62/79] block: rust: add `TagSet::update_hw_queue_count`
>>
>> Add a method to `TagSet` that allows changing the number of hardware
>> queues
>> dynamically.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/block/mq/tag_set.rs | 17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/rust/kernel/block/mq/tag_set.rs
>> b/rust/kernel/block/mq/tag_set.rs
>> index 4d00979a83dbd..47a162360e628 100644
>> --- a/rust/kernel/block/mq/tag_set.rs
>> +++ b/rust/kernel/block/mq/tag_set.rs
>> @@ -8,6 +8,7 @@
>>      bindings,
>>      block::mq::{operations::OperationsVTable, request::RequestDataWrapp=
er,
>> Operations},
>>      error::{self, Result},
>> +    prelude::*,
>>      try_pin_init,
>>      types::{ForeignOwnable, Opaque},
>>  };
>> @@ -34,7 +35,7 @@ pub struct TagSet<T: Operations> {
>>  }
>>
>>  impl<T: Operations> TagSet<T> {
>> -    /// Try to create a new tag set
>> +    /// Try to create a new tag se }t
>
> Is this a typo?
> It looks like an unnecessary ' }'.

Yes, that is a mistake. Thanks!


Best regards,
Andreas Hindborg




