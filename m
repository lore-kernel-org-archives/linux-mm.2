Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4726CF43697
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC08F6B00F3; Fri, 17 Apr 2026 08:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70F46B00F5; Fri, 17 Apr 2026 08:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9865B6B00F6; Fri, 17 Apr 2026 08:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82BBD6B00F3
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:44:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4591C062B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:44:12 +0000 (UTC)
X-FDA: 84668015544.10.72F969A
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0DAF71A0003
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:44:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ufHQfFOb;
	spf=pass (imf19.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776429851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iDkpP2npHGZPhERTsC5e/97KQirTNrGZ+oon7DqZfI=;
	b=Csm42NWdSaBAM9F7VcZhZW8vqUSyk+ZHd6a9IDdHkoQbX00zY1/G45F5XBpE5pYKwmLgzc
	+BVnQJeoXlkeYRPACGnxjtQe2CNU08ZJx6OUXPDPNJpi6dM9oLxKnV1mpjfwBPpfhKzSYg
	iXDFT3MAl1uJPC/9MyDO+N4PEY6aMdA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ufHQfFOb;
	spf=pass (imf19.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776429851; a=rsa-sha256;
	cv=none;
	b=CPHcyHLfYLqWY8BXSU+T/5UnPdjRKXmbyYeMr5y2aqzIsUHi1DVA98elJxiXc9IRHUgdAa
	Khq8fSAwSvk+s2nxJkUV/a3AjvQsL3lqI9BCZdt3R/iJc8Tp6rQhNqbHVbLJcJreP+2ql/
	EyoMMZOsdjMl5JRqXv8PoCnO8a1Tcwg=
Message-ID: <771ad315-0149-4de8-a39c-1c4bcaab2241@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776429848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0iDkpP2npHGZPhERTsC5e/97KQirTNrGZ+oon7DqZfI=;
	b=ufHQfFObPz9RENL8GIF/JjYnJsa0TQPCxInnGcH9njjEhmpd32Zbzi6XxxX0rL8wd3XwKL
	SwQZAlcLpzJxv8MeHOpWtxGWNkr3y+bhTkHbSxJOfHL0zz/tYJpWjzcBPq0Og7e4Yc1AK4
	TE2ueXDyVD/hKGW526eOG70u0s3hD1Y=
Date: Fri, 17 Apr 2026 20:43:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] rust: xarray: Add Guard::find() helper
To: =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
 <20260417082836.29530-1-work@onurozkan.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <20260417082836.29530-1-work@onurozkan.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0DAF71A0003
X-Stat-Signature: 6sd8db9kqsgzuyrdanppof5hridpjsc5
X-Rspam-User: 
X-HE-Tag: 1776429850-13494
X-HE-Meta: U2FsdGVkX1+EcOOej0GZet0VccfaxRWyq5Muu9pkckBYPPMQRYQ6VRDY4S6LF7gS1fzHsbg1wmx8uRawpsWHBSsyBU8HH6c0ntFW9J5zTOe72GFNXFbiC70vr92/MgthKriVTVtPgycQEhKOiK/OEF0KNI6zGNMm+F2vL3Xsy8MwztZkRfKJOUY6jAYZ61sEsd+3mZ/k+vTkUOxhBAkZbfzDuIcxif07S13NtWvlUUo2TpjZVOJYP5ST+ZtrTWSGTuv+vUZp2k7hTMQb/YJkk5wWSrmAuuz0mXadUoLfenl45e95Smgjz/zolqKk3YUJg/u6OgriVxQcArPpps8+CnL0Vvn893YXuOYjAqCpnZMI0es/9QNPJf8XnNjxRy2aBHqDj6NNXOihMRrn1tobuPbOUCI/OuNEMG5Im2Jicycn6+IgZ2UarzGe1SkoQD3f2ouWct+f3Mcg1BRHpsMWMBBRx8WxI1UyzkpOZ3qqV96xLYvX6dTmK3n5VwGnPLgLc+GX+zxgxl86bXXl/IYjMCm72EjJLH1vrJF7PfYA5v5zYhChjE/0QO03P8g5+O0DXSZnkMaJMXyeDdnmwCvZl3vnIfX0tw3EYsNGYe3rKn2X72G7vpFQFgTm1+lzyFUiM1gSkA+YZZ6ACbzSVffpV4ONUhGHBZuQllLETqzjGYALFlpEYTkLPVXYeusxe8mOpjybXslTgVA0zM9b0s0iSKKSHAPUDxD/gHKreAMb3BM+3WHEO/9V+NDik7+/O5DpsZX5YsGlNFNfDaQpCo4NJ3qy/zCy4ykFOSq5KdrDvohP2dAhCYfSr7W/X+1Q431SnI79uoGOOdglITNLz1PtO0N62eNR7/P5FqcreQ+ESDS4aBQ74jhxgYFxILxOGf4IcoHeaIBsqy/CF/dqVhWmWnxgyE7/g/ZVEUvxm3kDFEv64jbZ1aIVxCtH8nD1AloMCuJ7o8WVVVlSCsapygw
 9a5SEY3V
 9DF89KoK9lWbVhIKVzTMacPsLR79V46aEqYZF8CAfIuswdhnHiwOlvcjosMQtUyBUUZZnPK29PnxoqgMLkM1nvkpOGCn2LXLYQY6UnlH4F9ZKwSf3sndAIT3oC/D93um4xsbIXnDCVqv99blYaMS4Bi+Teq5uTROIqiVYOt//3DM2UEsmWSVB6vWg8YqYHBTQS3SLo7Y1C2EBS0dNFzLK75SUa5AS329OYV/1heEb/ZPtjRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Onur,

On 4/17/26 16:28, Onur Özkan wrote:
> On Fri, 17 Apr 2026 09:05:54 +0800
> Alvin Sun <alvin.sun@linux.dev> wrote:
>
>> Add a helper to find the first present entry in the XArray.
>>
>> Returns the index of the first present entry, or None if the array
>> is empty.
>>
>> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
>> ---
>>   rust/kernel/xarray.rs | 22 ++++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>>
>> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
>> index 235fda0e394ba..e43129d032d9d 100644
>> --- a/rust/kernel/xarray.rs
>> +++ b/rust/kernel/xarray.rs
>> @@ -217,6 +217,28 @@ pub fn remove(&mut self, index: usize) -> Option<T> {
>>           unsafe { T::try_from_foreign(ptr) }
>>       }
>>   
>> +    /// Finds the first present entry.
>> +    ///
>> +    /// Returns the index of the first present entry, or `None` if the array is empty.
>> +    pub fn find(&mut self) -> Option<usize> {
>> +        let mut index = 0usize;
> Nit: I don't know if this verbosity can ever be useful, it can simply be `= 0`;

Yeah, you're right - we can let the compiler infer the type automatically.
I haven't gotten used to that convenience yet :P

>
>> +        // SAFETY: `self.xa.xa` is always valid by the type invariant, and we hold the lock.
>> +        let ptr = unsafe {
>> +            bindings::xa_find(
>> +                self.xa.xa.get(),
>> +                &mut index,
>> +                usize::MAX,
>> +                bindings::XA_PRESENT,
>> +            )
>> +        };
>> +
>> +        if ptr.is_null() {
>> +            None
>> +        } else {
>> +            Some(index)
>> +        }
> This can be written with the `then_some` chain e.g., !ptr.is_null().then_some(..
> .) but I don't know if it ever makes it more readable or simpler. I guess it's
> up to preference.

I'm still not very used to the chained syntax style. For me, the if/else
approach is quite intuitive.

Best regards,
Alvin

>
> -Onur
>
>> +    }
>> +
>>       /// Stores an element at the given index.
>>       ///
>>       /// May drop the lock if needed to allocate memory, and then reacquire it afterwards.
>>
>> -- 
>> 2.43.0
>>

