Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 320E4CD6E5D
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 13:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0056B013F; Sun, 31 May 2026 09:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C79E6B0140; Sun, 31 May 2026 09:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 304646B0141; Sun, 31 May 2026 09:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF866B013F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:21:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B41B1A0423
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:21:16 +0000 (UTC)
X-FDA: 84827776152.24.4654A31
Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0E27640007
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:21:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=sgczBqkd;
	spf=pass (imf17.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.191 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780233674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efWFEnx7JHA1iJHj3hsJgYHoiM9riuCLtXcPELWGRgI=;
	b=An4dAX6g7STGpGayErbFAu8jLED5SnSsMti7Ct3XyXtsTK2ck1SGAS38SBsHu4N62xXxXf
	MMf+CB30JpoVGi4gB3CWX93yEMMTdgaViUQRR3g8jWAiwW3uEVe17t9Omnf3IYgQK+V139
	DBil/NNi+OYUpMmGIKl12SdFti17oEQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=sgczBqkd;
	spf=pass (imf17.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.191 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780233674; a=rsa-sha256;
	cv=none;
	b=npzl17Hae6hT/TSQrNYU7aCwEMwiDSuD6yqSxsaABOCY6z8zMP4ls6NDyFlFJyBlnsSqeV
	7hq9Yu6mRzwhEAGIEkoFpk1fqgb889Nzq9Lxs5zIwrese9ndzPAx0tvufE49Jk6femXbeq
	6uU9WEcn3RL8jW/oBE+qTAYJw9PQhrQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780233669; bh=efWFEnx7JHA1iJHj3hsJgYHoiM9riuCLtXcPELWGRgI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=sgczBqkdr3QIheLi1hWDVXZQDPpnacUxk9PExrnbL73WyOlu31ZrRRAS60ojrXyrz
	 0HakI3VAwFLAFyW9hojSi47VfDw3VGnWwPotztFBQyh+9zkawI5T2kyIdgpMYRRJ+z
	 9eF4hgbkYlF18wha3h9bxJVv/Qki+ZNmI4yBKwI8=
Received: from [10.24.9.42] ([123.112.11.230])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 545B08F2; Sun, 31 May 2026 21:21:05 +0800
X-QQ-mid: xmsmtpt1780233665tekiqghxd
Message-ID: <tencent_2C7744E4A6CB428C4BEA795851797EC38305@qq.com>
X-QQ-XMAILINFO: MTEKjEyAppcsB61xgzFKItQrQiTS8NoRA7KAQHHenjoWVIV1MGPmpeZrAbqeqW
	 7cvHDOx6eM/Ju24trFSDlWAZWvkGkeYC5p+qSjUFt0iNKZrG15pM61nRvh9+64Tp/LcFY95qmXVb
	 uDs9dRGyMdcWh/Q3OCyLiBbkXEpsqXdwwF1blDxNXBqZdt3mX38jLrH5avRc6Vafcnrmf3QyNGFn
	 AV1rjZqOTXD9aH9fPsTAtp0m53IP3+JRRZYI1mkd65PeVnW7zALRmZDvhAH27D87EZIPPcL0kDMY
	 bYkA5TDIvPApx6eRHRRZZoMDrrg/JP3ldBld/WOl8z3SF+mmjTPXNBDmUhzIrkF/peLwJMzXhHK1
	 eciPQ4ptjrk2RtZ+7ntyAAoNonr35NDDHI29c5JExB1WBIqgQs3BvW83rHZEK6HTuhMVadGfWI7x
	 l+ovaPfd9Za6EWKr9UgU5Zk905b3B7VjRqwNMteo/JOhymgAbENT858ml6g+xvGLfH1UeSuqhZdN
	 1GkzHl58H2er7/IjMzXU3UOkEsXVjDuEWpb3vj7VvXv7PCp7oHIJsrKuGJ2qC4SrrolZijWJdqwY
	 YOuPYqmX2keVDIeU00LjYFMTDs+HgobhTyJHy55oj7QKtFO66EQl4aUdCwKySa/sufXQzQXlORrN
	 cHO1mYeYOYcz28IsWaWY+M7Oxs5bCkMHyGmMPZeighr466YbhguwOiF6rdMBg+W+45Bf5YUulVIf
	 fPH/aHSvq4/op2Sfu4nzEDh8Amj5u+EhZKzqD9UXYNVBBv2pIrLfkX9SljZvCnRauooWjtzvcuiO
	 PD0Mqeha1S9NVXM/AVsqJmR5Bjqpk9CUbcJ4JOBhACaFdjEI2ihKR70wZQSDKpuxO3xI1ygH7Xz6
	 rCKeNjpQdF2KyZlHG0gm8pKD5z7BJHg38to6PNOnodzbDKh7ya1oulzivAboeW4PGY6iqa7zeBRN
	 SWTcuoz5jZTPVn7Sj2VqCcSnDMSc2qna9cazJOwwdOgyYVZcbHCctcD5BnkV+hn1NG5DEc52u7bU
	 EW2EEN9mlatNYtX7BwkrMXcKVYQjKCIzlg1I90Ip6cTEf3xyvCTEWML0pRSXscMW8xSHi24PGtbD
	 XE7/ZDlt4qhceHqMzRYhhRCrCTlTONRlqZl7gm
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-OQ-MSGID: <7fd6bf26-5c45-456c-b6d5-b5e8e1a15fea@qq.com>
Date: Sun, 31 May 2026 21:21:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 9/9] docs: mm: update THP swapin counter
 descriptions
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>,
 Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
 <tencent_0F6F682C60B99E9E0F1553E6BF3D86468409@qq.com>
 <CAKEwX=NDfJud3FM4Y+Ek3RtTtwi2aXWeDCujNxh2ReUEq-m4oA@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAKEwX=NDfJud3FM4Y+Ek3RtTtwi2aXWeDCujNxh2ReUEq-m4oA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: nd68puizrn9q7efzg53kxro6zqudg44p
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E27640007
X-HE-Tag: 1780233673-987389
X-HE-Meta: U2FsdGVkX1/uRvlDbeZbOMM3XiPFX2I9Zwn8kkKtMkMIdYQnLqS+BKX01cQV8DJWm3DUOqApVgLg+Ni7LogIrNlm5JvpXcb9S7qHTy/mJ4BScQGuyYFWMRWnWgqGp6rX90gfKPyIYOCeiU03FFh6k0tKN6ndz/sNSbiAwwj+WpDZ8V6Oqkk9ZMasTDtKpGx6CBtPsvOoW3Eu4ZdRsCs/FUF4paZp8ruQ0o2d6GFzYD6S97S0x4Rbq9iV7vdNdTDzN+SFfdsq25n55CcXy6IfO0IumWBvSnDhrv5w5fjL0hEkx3diVcV6xyb4E6sXyZR9IR3dyilsQPhipQhs+DUWeEeCIV16qOoIby16PJ5UQn0EvJTbSuvhiMhNB5/ooBlPtO5u0VfDZJwWF/IH4B6XUzXJmkQ2817hkKezjRmrdX2tRj/6NyBQYW6inctxGMXmwNixcwhp8l9qRPrOpY6dJRjjTIGFz+T7VgoDGIE5dCnHKryNpB5Zz2J6bfeuNfNP01VL0Xnqa6aYLnJ9DwDFRjplOFjRnJ0Ed8JA8//ObJ1n4cslNW1xQvh8pmSx8Ktori8ycQad7j5JWKaQPfPrt3+cO9fWtjc1dSChUBnaeZ0roJfsOmao/fAYsHJ++aPqtmgLIKQgWcHLDUSuPGvvvzke0p/uLcL2/f0KX8EuYqYTPPuXa9HZrVOJoDYKK0tE6d61Prr3w4ymHBNaKDk66/2+0IRWuQw+6S1WkRRbtUIz3HnBosFZtXgkQCb6NjgOUlMpT4FGkUNXsRHhiuG0egHKmpen8hhDQ3IV4n5wSJDIPNRvClUw3ZVoh0ihppfztkBVnn/8YBKsl/37+2LP2MBkZbk6kf77F3aBSYGtOJep/E4o/TUWM21I+BKCUjTYeunjGVC1bd0Qlocoup982uOySIYCgaz3xQU7wmGoXrf7OkfTnTW3TktbtZtDfQu+8ZicnsPeuQNMN21dC+s
 tmPUgl2o
 cNfGmYeu0UJvM19CA7oU+BhsrMmraJH/mM4ly0Z5zhjvbkGqLQWnck5g0X+Op82wUkLkzhnkMFJWunRKJ54e1K+wrHJ7PGCAW9dSeEZlrkS4mUFk+R0BgxhnxRaJ0Pb0VcZaO1xjoeyho9tGs3hh8DG/ENFUaQ+ilwzd9Bo+4KHR57e0zPG5cw5ARpyOVZzYO2cVm4oNbkPb32UhjBN12d87T/eEUeGrETc+hTpZ1rxTdxHGDOlfI8nOj5TMYAi8MDFIRPrmRU6vM3gIa13A/rCUuyvF+6dPj1Q50lfGy2bkSpupO2aR3vhb6qPTWieXWXYietp6MThqumn1udHg83ly+bmMp/m2xvPEOSYW4LyGQ31eLg8yDfgsBltVcwBiTuCRRleAj60InVe/BIYzxIYF68NXuNElArN8/403LuBy6llPijsmD9RRGqw90l2mXhgw5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/30/2026 2:37 AM, Nhat Pham wrote:
> On Fri, May 29, 2026 at 5:19 AM fujunjie <fujunjie1@qq.com> wrote:
>>
>> The THP swapin counter descriptions still describe large swapin as
>> coming only from non-zswap swap devices. Update them now that
>> zswap-backed large folio swapin can also increment swpin.
>>
>> Also describe policy and backend rejection as swpin_fallback cases,
>> since speculative zswap large swapin can intentionally fall back before
>> doing large IO.
>>
>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>> ---
>>  Documentation/admin-guide/mm/transhuge.rst | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>> index 23f8d13c2629..59b7a0d09243 100644
>> --- a/Documentation/admin-guide/mm/transhuge.rst
>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>> @@ -667,13 +667,14 @@ zswpout
>>         piece without splitting.
>>
>>  swpin
>> -       is incremented every time a huge page is swapped in from a non-zswap
>> -       swap device in one piece.
>> +       is incremented every time a huge page is swapped in from swap or
>> +       zswap in one piece.
>>
>>  swpin_fallback
>> -       is incremented if swapin fails to allocate or charge a huge page
>> -       and instead falls back to using huge pages with lower orders or
>> -       small pages.
>> +       is incremented if swapin cannot use a huge page and instead falls
>> +       back to using huge pages with lower orders or small pages. This can
>> +       happen because allocation or charging fails, or because policy or
>> +       backend state rejects a speculative large swapin.
> 
> I think we should add separate zswpin and zswpin fallback counter for
> THP rather than overloading swpin. We already do that for zswpout vs
> swpout.

that makes sense.


