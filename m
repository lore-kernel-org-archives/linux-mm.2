Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 778D8CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 09:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAEB6B0088; Wed, 10 Jun 2026 05:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2816B008A; Wed, 10 Jun 2026 05:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0756B008C; Wed, 10 Jun 2026 05:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBAAD6B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:00:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44164C2869
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:00:57 +0000 (UTC)
X-FDA: 84863408154.23.F13A532
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E32E1C0009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:00:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SuW3SZpe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781082055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMsVQi3orljSEvhMyPLIhta0ehH4Ys7jFOHwtglZDGE=;
	b=P4NY+U3c6l3DrHM7dPOI06Qyp+4Nx0K9SP37cgl5DmqhHMH5WHWFEs0U5iBS5Ak5TbX4cM
	Ot+Ri2M6zmvNMS7fEmmJO7Vmlym3b0+2ePgN9NDh3stLzG2kllecOghqlaJF3vopWoLz+r
	6FU75w2Aj1L40QIePkBng0Cpk72Gr/s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SuW3SZpe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781082055;
	b=guhqefibJHUPQ4MVBpwye8kd3eYBI+mgrGvg6rXxGibfCZdczFIlHjViVjV3tKBtli2llP
	ldikMr9Im1JiqZlYQ1wdcGehNIHh36MjH3ZFSSIAa0dwpVjjRuMMAB7f+vVc5DDBoH2Xj9
	mhJidTOjlaGhj+yZ3tSU1eVOYwveTMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32156602C4;
	Wed, 10 Jun 2026 09:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24291F00899;
	Wed, 10 Jun 2026 09:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781082054;
	bh=kMsVQi3orljSEvhMyPLIhta0ehH4Ys7jFOHwtglZDGE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=SuW3SZpeXtKywlRGQRqMf83GIMeoG+6cVyHrFeSymZAyFIDD0DsP9Tt660M7uk0X1
	 eL6m/dpEGUaGSftJAx0Bh8I5enp+po3UrTt7xLoN6651ub22mu0WyYWkQOjnGlZ7Vf
	 Pf+mJXDxqWpqnS2T3A4Zl4uxHaGFHiLDcPgfilY/EOddg7gDe068WdKfp4YdrrH+OR
	 7yOPcTybmCdrEZufDNJM0FyyvjGhONtVwoJcm/FkAZklOo/WgD+7OkcYAOytRJ4yFH
	 vRPrRIdiheiE1/7uGZgaldTvVh/EWjdnYbalQ+5b0h2Qcq8oBjdHfxharAcIyGu0u1
	 f5bRctCuLIaWw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Boqun
 Feng <boqun@kernel.org>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rust: page: add `SafePage` for race-free page
 access
In-Reply-To: <CANiq72kZQxLEXnz1U7K82TZJWYUF=8f=wC=RtTL26ADfr9RQJw@mail.gmail.com>
References: <20260605-page-additions-v2-0-03f04c8fdbbf@kernel.org>
 <20260605-page-additions-v2-1-03f04c8fdbbf@kernel.org>
 <HZuOc2PUMh5R8h7yC69l4I384agFUrcfrJrk7o9X2jR6aNPt9nrMOHWkc2G2ULw5H3iIbh6XL6ypXY4fmaqNDQ==@protonmail.internalid>
 <CANiq72kZQxLEXnz1U7K82TZJWYUF=8f=wC=RtTL26ADfr9RQJw@mail.gmail.com>
Date: Wed, 10 Jun 2026 10:46:53 +0200
Message-ID: <87cxxyhjeq.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E32E1C0009
X-Stat-Signature: a6zg4ckb9c8ky86kwusyzeizymsebjoj
X-HE-Tag: 1781082055-687406
X-HE-Meta: U2FsdGVkX18/Oy+QK6stkkNpi71jC7nxC4zZ/lUtsr9hBq8jPGFtzpx1P0BWOQXGsZPLpLECwCV/ek0T0IgHVVO09esi1P0p/hA39wibT+qT845WN/HMU9cDxsAciZy9o3jE8LuB6xdc4S0n2et94Y/HxHoJPcwsuX+icNImNQIyRcV1qpBtgl/ujWIUv6qMyUAEOQNPGZDe4RvAJsCtDVB47mArv/7tdo+BAgrt7FKGIRdvunM0i2g8Rnq/O8Z5C2ICUGejsVojK/muQnGL9EejTf49vAEHH5r3Cs3j8wOtmzTgX+yCVaZEoY5hNrZupz+0BIEYinhDicjmhVIP3ycB4o1O8pZyQ26rChnmMVfVus4pVt4Mk16kzT4DboJ90Hg2U96oroZwePHeAZzfEXjbeVV1yv+iSQ4NBJUjNihVl9OCrz42PoBnHyOXsarCV0OR+TgV4MNJGwDFGQCqV9HEYsKbmA9BVyNfDXZbAiwnKOUM8nqE066U3m+7BuoJpot6G7n/W/qK4oDwBqDTT6/iy/1ulx7zPV2d7AJ5Y9AMhyg+7BMZa8WMCnUCLSYHXjLuUfMILBTGlMKOnCCfAS6kZ0SFILjTXvjgfX/Cknz3l3gG/NqgVaU3IPVkDoo+x6v/32VZE99kiSO08kDoyFysBgxC4LvjMoXI0c6Ld8M8zrS5oYBG2vmvKVsm+p7CXVh1SYpsA5ObB5dTAZJpezuVFvrzvWlL09XkspA19AUwFHPDm8v4aaxGjYA8uE9cuXg0fDgOZjw5yYmOFE7o5GNLRE5z7H8uKIsHfCcAJ4isI8lUqUCaR7zSubWhH6w5iAJScm5ES9gAa0AA/KGhMkezlfEQHHeZ6Tqbpp3P0Wnyx1f1yBcghHRhBaHrrvGlkZ/476P/myX2UmedQ9xmx979LVzX9mteW59tW7IWa+GFhXvR71QyHFHTN19PxQWc/lfh1Sg09isN4oTUumM
 UrECD4R0
 naUQmCFsMsrNyxmgPheUhB67SrfYwOdcQTOFYnFBQu5GandrHUx5BHX+zo+iU+KLhyqwhob/3DbbG9bzPa+ZGJU+cUB+fdWl6vEkrKZPrx+mPXY5QoxIST6DddI9pkoVXbx8ZHXWC4C48MBwaS3ZuUezb28aFxQvRqs5Rqq/VHIJRehwTdODP91t6r4yv8N528946Z+RuSA12j2lk0qXlFaY+RC9L+v+cFYq83YL0pCMhYxVqE5C63t7m4S2+/kjuYX2j1yvBiDQf6AYN1Y6UHLL2xidzoKPPagDTpqqGpUH3JfyoucrkTiWOs1oPKXcVzr6ZJ5MEYfNtOxfANULuZ4Z80jhtgzfxz2W4XlP19tBJSzXsmefc0hRhVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com> writes:

> On Fri, Jun 5, 2026 at 2:49=E2=80=AFPM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>>
>>      bindings,
>> -    error::code::*,
>> -    error::Result,
>> +    error::{
>> +        code::*,
>> +        Result, //
>> +    },
>>      types::{
>>          Opaque,
>>          Ownable,
>
>>  use core::{
>>      marker::PhantomData,
>>      mem::ManuallyDrop,
>> -    ops::Deref,
>> +    ops::{Deref, DerefMut},
>>      ptr::{
>>          self,
>>          NonNull, //
>
> The first hunk fixes the imports, but the second introduces an import
> in the wrong style.
>
> I think the first part should be in its own commit, and the second
> should be here but with the correct style.

This was sitting in my tree on top of already fixed imports. I probably
made a mistake when I separated it for submission.

I am looking forward to the day where rustfmt will be able to handle
this for us without the added slashes.

> But I just noticed the first part should also have been done as part
> of your other patch I applied yesterday, so I just rebased to fix
> that:
>
>   dea66841b9f8 ("rust: page: use the "kernel vertical" imports style").
>

Great, just the second part left then!

Best regards,
Andreas Hindborg



