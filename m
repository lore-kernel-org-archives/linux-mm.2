Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF201C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF02A6B0088; Mon, 31 Aug 2026 09:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC82C6B008A; Mon, 31 Aug 2026 09:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98FC36B008C; Mon, 31 Aug 2026 09:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 642656B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:30:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0EE680148
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:30:41 +0000 (UTC)
X-FDA: 85161649482.26.5979ED6
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id B069D180011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:30:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=K+XDkQxZ;
	spf=pass (imf06.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788183039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bclo5dNXV+6Jy1wwsMfxD1j5QCeC9PLq5D/ZXM1ZV+o=;
	b=ZLg1XZh6Sza2+gUzV+LGjRlvlvvcJ3qrrtdUdsckzZ4tMH5X9ptVm0VSp7ob71Ax3OD35b
	5KjP6x+rvZbhFHgpGFfdjXS5qNDDA0Sztp7ALqItf9aNMuLkOy6OmDnNOaml6It8XAE6+y
	2ZZxPrISlpPbPGnYqzLdaCJVTLg4hbI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788183039;
	b=WZZYFfwCmuJRB0PDIOQQ2LMqSDDqOUrJKpDl4IrXnia1J70AMYTMYvOoczn9foKNEd/LsK
	Iy4nvb+OMYCqeyWUdIxeikIcMioiJfxpyEpwqL3hAVo08fom3bDVFewTaKwlGVkGPeuD7H
	H1Dmc9aGN+dUlSOpMaTnH5gv3X/4ye8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=K+XDkQxZ;
	spf=pass (imf06.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2055573c8cso445362966b.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788183038; x=1788787838; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bclo5dNXV+6Jy1wwsMfxD1j5QCeC9PLq5D/ZXM1ZV+o=;
        b=K+XDkQxZuq8tj95uxlArO00YBEhbILXmJHWxoXrLwW8F2KJGOQTrcYdFfokS7OYf9B
         2TS9mfF90aRk7StZW2lFGme+z6wLQrtNc2nPA8Ptp20PjW/Zn5UaoE+kDmOTybVe/ZgG
         90SoZvd97qzCrJqAgn+a6M4Nb4/ELg6/6Yg7EuX/pfnA3JP8moIuSyiVSNiUGz2i8O3S
         6BA85Ig60BHeZrOkzkuQO9L0i+si+dYpmNMZuaken40nrViAy3pnQYeALClN3l8L+rX+
         9bQGqNGy3SbiYWXhOwy76fCqja3tFWlgK1MjmvmNTWN6GrdtLl67TUIrSpaNpgK6ie+/
         r5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788183038; x=1788787838;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bclo5dNXV+6Jy1wwsMfxD1j5QCeC9PLq5D/ZXM1ZV+o=;
        b=OoxzXeX0Y/YdBeiTLjgpnyJYZPoC8x014I7xyIUXUykCBqnQ5CJJYMCTFNU554VSMV
         xxYEGm26k85xy0YI2G3uBSS0k0F0nL1h7/K0xlHaVXWjsqgwMsHPUsIksKpLO1L0xyWr
         8VbxbdwxKVQBOPokh8J54jvKeJqpq4c5om4bKC4cVNJTh7z+AIg++8N8bXcbVNGhnRtv
         Ej3gn26q2lcdaeoz9B5oLnom7Td9+uEoeO30w2SVam8WAcIEP/fwScC77jwe/uFXhB21
         GwZ2QZswiaOxc0hc7eg5R/cPnrw8aWL97KcuLfhYkB0RwkNPygFwUOFvCSzAezJEKsMy
         qbXw==
X-Forwarded-Encrypted: i=1; AHgh+Rrquzo28anEgwWqsryFr5OngmXXlEg/aanES0vgZShmNQIhpZ1ykb629ZCQkkj4Vsz9Dfucs9LIqA==@kvack.org
X-Gm-Message-State: AFuF++lmRiOSxQlwff2eP2WZriKeKncgsKEOV520Y5U712FTULIYPgut
	S6B++wJ1al2ofr+jTEQ5A8c2wubrw6nq29/aPZ5yaRwLjC6ZLBTV51tStmmj16vOpts=
X-Gm-Gg: AR+sD11tIe5wsFyzpybHzPF78VN5atua/z1HN+AgDMQU58Pjgkp0bWJNbKxwVe79npx
	Eh85ylX1qb5HDELAXD5ASuqCXgkuSNabSA1UTlr8zvY2yc9vRL857h0XAae9kJTZt42xdrNFphk
	29yzM9lWCf03SFK5Nk06FK6FXRxyCTU9x4tiNA//ZhLpNhAH4fCWJdtb+DGQhyTqYjPNjBzBiTC
	h87WvDFMY/6YXuLzikHgb3ey1z1q+Rra1qdozh2VXbIOm5dxJNyIPnkAPWIcpDETwWDyHDtoq/Y
	ZyZXyKrOuUdJuy0YC8DiiRy4qU4ceVLOs3wR3BfIK43FBtrnSoIB6TP6apS1JgUZ0GYACsezCqC
	JZ0WTcb1fqN50o5D7pSvAfok8iCx6NvqzDh62/QGIKBC+5q7wVTa2LHjoZF/xXmAfhYgufjIXl4
	HMtGC5zAFAsOHy8SFac13JWCF4yNy99F+NpemhfcbliJz59tZY+Qsb4/nrIhhat1ofZ8AEPIaTh
	Uu6iRi5r0BIRX+uEsZZ4quS
X-Received: by 2002:a17:907:3cc2:b0:c1c:5aa1:de57 with SMTP id a640c23a62f3a-c2557030696mr1575327866b.13.1788183038289;
        Mon, 31 Aug 2026 06:30:38 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:fc6c:f9a2:4a0a:6354? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255ee0b233sm435317266b.11.2026.08.31.06.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 06:30:37 -0700 (PDT)
Message-ID: <5e6231aa-10b9-4c41-b7ab-dee5e8f64bec@suse.com>
Date: Mon, 31 Aug 2026 15:30:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] arm64: Allocate .text and .init.text together
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org
References: <20260822135323.795946-11-ardb+git@google.com>
 <524b5817-c097-47cb-b301-4a9c0f1d2947@suse.com>
 <cee89666-9de0-4012-b665-69da3846c5ef@app.fastmail.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <cee89666-9de0-4012-b665-69da3846c5ef@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B069D180011
X-Stat-Signature: izd5iwscg5oj346dfmp364fmn76ckdwp
X-HE-Tag: 1788183039-690524
X-HE-Meta: U2FsdGVkX19w9+by3lmIQO5jdZqArMsh/pBIGUGnIG1RTqC2pc0goEjCHfngA1n1U56Pyk/BMWXBrwB1pKU0NZsVeYrtz97BpSYkh0ew+3I283EL+ksQt8OLXvcpqkr9vJ2SKMu9f6/v2+OeH2fSQZ4ZIYZutl4Zc+7z5JB8RrHb/oiGmoT6GIUYUHHbO8h2RuYJAknc9A9tBdPf6hn4eYIQo7vuijjZfCchI+tR3pI/MtjYEFa8PXWyKzR0NVY1LlRaTndFXRWMhBBZuqGaaPq8jAAPSm+ihkrzs1Cn13pDYr5EVgESkLVAW7z+fL0UKG8fFSlxo8X2TAqBEExhJ5HubRks7xJA0i80BlYNTIQk9aH9c/AzmeYZgMHn0QxYnk38pY3tnzZ9EipQxtt/iHlLcUHSzzw4iNIKdVSq71rs0kIwibAl4cRGxEV1kg3P6LezWNrPoVxudj43k5mZUG0eQalPCHf5lKjSmIovstgeky6dIDuQvU6VG2Lvhe/Svku6uxRNT5qCfri19NH3wA11mQOoLuF1+CqBHHNq70WclqTPGr+RpmQKfT+NKLl2m102WeNCZr7UZkgy04y3k1I97CjEB5yp0849HrsbSvuVeA4sIkiKjXoAlcwOcKU3DU8Fzt1qYtCop+DLhjaLi73Z6+A9vbAJc9tW9volHYt+WVvC5aeS9pL7QtzXRYwAydVQL/M/ygKcZKgZ7d3lzvbUumNcPO6dcSBWqQotjsa67gpFH2hdTpKh6coMezJq8wFjQulwzpvE98N1NWBMY+dOv5OhcdheNkUrTSCn3RvJjzznan1Fg1ACZdVqRenjlledjZpKBcDyZiHWPft7YRz0GntQNA4qYi1WSAbyOWj7hD2q/eETD9KKs9MUp8ktQ0muDLnrwyqpfEI/wOEtQD3sfC1iUqfvZT4JVCcIpOCfGtLbiqKEIPok0qdZW4ZDjSzunq64n6fEO8/452x
 xyOo33Xa
 k8GCcUGLjg6uuqSB5Q0LIjMM4i/u0A/SIepHnXl9lkUIRjRIhHR/uZV7pI8AQ6YVMnGxoug5+PTKpgt2NoJhHfEB6kEOQdSEwplw+kQ0t6XPHPVqkWghFOVImJo+turW59XhEJ5daygKRbdxJNj5AS8LrYeyiHZDz26hMUibWgU5/nOHsBE1PtaNNRPVnCVk3429BnWZHWEQctb8ExJgw62bT/VVzdWV3CVN0/eiwbP3gjkXnJ6ayoyvBpeu+/kw3qA41mgbJOY4sXN+U4rpZCJJbJfiWX54TDtyRH4FK+WU6P+Nl1uFfy+tSjfvSwzmV1FufWKfQV1JNNa/Wh4RKX/LkU7xDdhheWEX8nXYREDFROgxUA2omlA4ynnx7CnKGOtmBMzGqyHfAJUbudq5oHGNp3ka5g0posPhGYzSrGCbAvBkPgaxZuagG60f8vocOIEalkXrwRlU+TNAzhp6XIe/2gnCQ6cXCfzKpkiuRUXIhqObZqu7bbAXPmuhBZf5EMtK630xoYAfN4/KYbQS71vEX1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/26 3:45 PM, Ard Biesheuvel wrote:
> On Fri, 28 Aug 2026, at 15:07, Petr Pavlu wrote:
>> On 8/22/26 3:53 PM, Ard Biesheuvel wrote:
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> The arm64 module loader has to deal with a couple of corner cases that
>>> may occur when .init.text is placed out of direct branch range of .text:
>>>
>>> - ordinary direct branches from .init.text into .text may require the
>>>   use of a PLT entry (i.e., a trampoline aka veneer), which means not
>>>   only that additional PLT entries need to be allocated for
>>>   cross-section calls, but also that .init.text needs its own PLT
>>>   reservation, as the one in .text will be out of range as well;
>>>
>>> - dynamic patching of the ftrace handler into .init.text code needs its
>>>   own dedicated trampoline as the one in .text may be too far away.
>>>
>>> - recent compilers may omit BTI veneers for static functions that never
>>>   have their address taken, and so additional veneers will need to be
>>>   added to .text in case cross-section direct branches from .init.text 
>>>   require a PLT entry (and therefore a landing pad at the target end).
>>>
>>> This is unfortunate, because it is actually somewhat unusual for .text
>>> and .init.text to be so far away from each other: only when allocating
>>> either of them (but not both) exhausts the 'near' (PLT-less) module
>>> region, the other will be allocated from the spillover region, which is
>>> not in direct branching range, and therefore requires PLT entries for
>>> cross-section calls.
>>>
>>> This series addresses this wart by allocating both of them as a single
>>> chunk, and freeing the .init.text part along with the other init
>>> sections at the appropriate time. This ensures that the two regions will
>>> never require veneers for cross-section calls, allowing the arm64 module
>>> loader to be simplified.
>>
>> It looks like this should also be useful for ppc64, which currently
>> merges .init.text and .text because keeping them separate would require
>> stubs between the two, and consequently .init.text is never released in
>> modules on this architecture.
>>
> 
> Thanks for the data point - are those stubs needed when there is some
> distance between the placements of .text and .init.text?

Yes, my understanding is that these stubs are primarily needed because
the BL instruction on ppc64 can only reach a range of +-32 MB.

Another aspect on ppc64 is the use of the Table of Contents (TOC). In
theory, when splitting .text and .init.text, one would also want
separate TOCs, along with stubs to support switching between them.
However, I don't think this is particularly feasible. As far as I can
see, the ABI and GCC don't allow separate TOCs within a single
relocatable object file. In practice, it shouldn't be a large problem to
keep a single TOC, even if some data related only to .init.text remains
present after the module is loaded. Being able to free .init.text is the
important part. On newer Power10 with PCREL, the TOC is not used, so
this issue goes away.

-- 
Cheers,
Petr

