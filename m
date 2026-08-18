Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F126BC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016406B0197; Tue, 18 Aug 2026 10:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08CC6B0506; Tue, 18 Aug 2026 10:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6F36B0507; Tue, 18 Aug 2026 10:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B079B6B0197
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:18:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 467FA1C0B34
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:18:56 +0000 (UTC)
X-FDA: 85114596672.19.316D413
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 826908000E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:18:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0ZFoKv3;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMSn+1Ss3wYwa1vpnK5ccBPCbTknsr5E2QPTcFjkQgA=;
	b=uiVpBr5GVEXNyit5PDDRMjfKOjgZrCwAtOMsDXoajU2pnVYnjYUqqu4URADVpzBqBBcxz2
	cSkEpJSswnbsvsDU5HRIxuyKnfqrZ9v5Xdq4uUrHJnekcvJt2w/aIUt7t1jv+4Xy7eX2aN
	74DmfnZKvRMI3dBJ4Fb3aT57dMOxWI0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062734;
	b=Ilz0lKM4H11uC4P/04SIz6+XBOg0PUoJY6MIOi6QZp5LK0SZCmAXZD3e9KOvsAy7sQANGZ
	2uvX/cqp11GpR270Jx0h1e0CF1wc9adn4IQRTSDKikuoYLoQpSWZEC8yfXcbwSi7XvvWY3
	S5reMXiGBWUSzHCk+JGSWcu1cc40FXs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0ZFoKv3;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1732F601DE;
	Tue, 18 Aug 2026 14:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A4C1F00A3A;
	Tue, 18 Aug 2026 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787062733;
	bh=IMSn+1Ss3wYwa1vpnK5ccBPCbTknsr5E2QPTcFjkQgA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f0ZFoKv3lUbiUUvWCcOSwjCL+h0rt0aw3qn1y+vs0ZbVZDVeGKbVsrZ3CRA4C7qey
	 15UtPE6qsUYPZLPf5k1D8H39BgRZTtcIPgLYJDsCuh8OtrGkQeHIRavF1m/qiflsAX
	 5x9aOOVLZvnQGqs4VqnrYKMNg+cIGQvcPodbBcy6hQqO9AO7V2lgq8yrk74bFOflc/
	 5xjyLZz4CfHLgCYHyBJZOriGC7YoPS4qtAttPLu8NVsRPsdAPVc26xgqUSass3dvWM
	 sxfg2uxL1/7gqDORl6ppI/qpavwYw2JshwoGojib4GrOtNC6yOv+IMLDXezu0ECo0m
	 I98yuNWNl+UOg==
Message-ID: <277db0f6-6161-4ff1-9540-7b1eb5f7924b@kernel.org>
Date: Tue, 18 Aug 2026 16:18:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hemanth Selam <hemanth.selam@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 Yury Khrustalev <yury.khrustalev@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260818114945.1312987-1-hemanth.selam@gmail.com>
 <9e533fcd-c80f-42df-847c-c15c4e3a1a70@kernel.org> <aoRcdLGWaNhUFIPU@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoRcdLGWaNhUFIPU@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 73uwnjwy4tsa1wukuuhhk7d9xd7dsecq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 826908000E
X-HE-Tag: 1787062734-352081
X-HE-Meta: U2FsdGVkX18z9Z2CEzZyh+rh5byuYZsmpK8FP4y4SC3FZV8IBRQNLqJyS8NnKIpyukKZqE1kwVfN8rBuRq8RtlYAPXwhoSZ5W/KIUP3qSgF3gGnf+2U9DDOpd8qTWMyJv1ejzMhRBE6XFTvYrylg0ujSm8zUClwaIRBgf4qa3bNvJ/iSz1hO1umzBz2dsXVPIpNBUMkwzyFVTjLMf2GGBwKkS+Z2xZMzxgIQdy3eUU8q6LH7qvqM/UHJsKuekd48uXX9IE8DyDmyUsVYCe8v2VGDHUpJWlBjkBh5Q/X+hqDCl9JZ8mNQcfV9DHenOzkicFKLa1tZRU5fcKvPvdD7tYMmIJUYxlpuNEE0rAdskHrvMfA/5gYOFHaFDTsbySzayzD7OG+wtgwaHUvrTa+oUSqpvXb4ZrwPrni1rN45/QTfjCGz7MqyZEOGKUUZSuzzNtUzIg5MXs/9cCXYCQg81xeesKXd5KaDyvdQbzqHFsVy8DS+kLBBHEkxDKQ1KFaOwAQdt6FxDutPSgFCn9jyG7kLm2GEFM9cEeLV3Cq/zeGxPQHn0p6YDDH3QCQgYSiAEQrC1+eTZztRNu2MR5sVBbPRXD+MNiTm7Nncnt0oi9CDW4BRdw5coGSFfJwN7cZ+ycCx5Im7KInok+dHfAFu0MotH61eUY663+IJVM5dMJE+nZViI0UIMEKKVPm55Rx4ucAENW+N54eTjZ/IRSAU1Nz2p+qJwN2E0BZfSDiMFVYL+aPw2jQgEy259NFBV/IMf6pwjImEDYKP5FaH4V+Ok0gMiSLN8m7fyTFUbLH9eDL0USDP/at2e8cctz93q31ogO6mOsj3UurXk56Eik1Mz1c4V+eMujMlmUBd1beEgL33CdSOxF7G/fSJj8KIBxyuQ16v/DqmZBFvroRfq+7GOV1i3GBU3oJfTaHpep13sBpMX3gGSHbAK/YTXln/UGekoJpB4MzcxvOo8MnZrWL
 LG2VpsbM
 NpzgfDcM99PpGhR9TQkVL73BMj4LwMxQnCYE7U6U0JPNi7o1kk7WE+mHykzK9gEDOCrEvNprRFonjP6KvpymkrpkKbLB10tQ0lKqeyFtxOCm0vJxiB1P8E6VpkASuWUKr6Bznbll6EFwqWRvqexo/83ipFC3tbf9NYf4LeaHHVa4xPGBBkkmLaS88BcCT9ARj+5L/YRM5PHW9CrlQXKfd5t3KwDT3CFkK3bw/p42ee/2TjCgFBdbCipqVWsmFBDlAbLZP8ZiXz8iF+bNuSP61KclnhWEnLtchdTt4dF0Zxpp4f8+1Dg2e/7ZR83nwLp2aiV76ldCS0xKQXRGmuL6gTbK+bwP/1qzqWjbr27rZPVelEPvsqBvyjCoZz4jxkt65FugDIjw1BPIvebWXOeJCm4EkrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 15:29, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 18, 2026 at 03:11:50PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/18/26 13:49, Hemanth Selam wrote:
>>> pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
>>> already known, a stopgap from when the generic definition was still
>>> under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
>>> Add PKEY_UNRESTRICTED macro"), and pkey-helpers.h already includes
>>> <linux/mman.h>, so the guard is never taken.  Honour the FIXME and drop
>>> it.
>>>
>>> The mm selftests build against the headers of the kernel source, see
>>> Documentation/dev-tools/kselftest.rst.  Building them without "make
> 
> This is incorrect. We explicitly do not have this requirement in mm selftests,
> and they're often built without having to do this step and tooling has been
> provided _explicitly_ to allow for that, which is why this kind of thing exists
> right now.
> 
>>> headers", against system headers predating the macro, now fails to
>>> compile instead of quietly falling back.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
>>> ---
>>>  tools/testing/selftests/mm/pkey-helpers.h | 7 -------
>>>  1 file changed, 7 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
>>> index 2c377f4e9df1..626c2e1655dc 100644
>>> --- a/tools/testing/selftests/mm/pkey-helpers.h
>>> +++ b/tools/testing/selftests/mm/pkey-helpers.h
>>> @@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
>>>  #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
>>>  #endif
>>>
>>> -/*
>>> - * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
>>> - */
>>> -#ifndef PKEY_UNRESTRICTED
>>> -#define PKEY_UNRESTRICTED 0x0
>>> -#endif
>>> -
>>>  #ifndef set_pkey_bits
>>>  static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
>>>  {
>>
>> tools/include/uapi/asm-generic/mman-common.h:#define PKEY_UNRESTRICTED  0x0
>>
>> So that looks good.
>>
>> But we seem to have the same ifdef also in
>> tools/testing/selftests/powerpc/include/pkeys.h.
>>
>> So likely that should be removed as well (after making sure that it compiles?)
> 
> It will break people right now :) it might compile on one system but not
> another.

I thought once we have stuff in tools/include/uapi/asm-generic/ headers that it
should work?

The dependency on "make headers" was the problematic bit IIUC.

But this stuff is always confusing me ...

-- 
Cheers,

David

