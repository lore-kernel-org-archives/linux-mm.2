Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 894A6EE20A0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1DD96B0092; Fri,  6 Feb 2026 08:33:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5B06B0093; Fri,  6 Feb 2026 08:33:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E546B0096; Fri,  6 Feb 2026 08:33:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF3676B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:33:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B06156902
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:33:30 +0000 (UTC)
X-FDA: 84414123780.22.21E6421
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf05.hostedemail.com (Postfix) with ESMTP id 389D810000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:33:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=Z9Z88ceb;
	spf=pass (imf05.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770384808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vb13Vwh1fPqNxRNlEIYNEmJHIJtcIK4aczKvaS88OeA=;
	b=BUCZHt+NfMsjyi+kFrJfUi/Gpi2dXY0NUnlIyoeGijJ9QTuNAEMR0LTareXrQUkXdumpnU
	zFHz112YJ4uvdtQ7WrwmHCTyqB1R23UCUJOwqztpS1B4m5c/tVbEEd9iMipP0LXOHcBqyO
	IWugKD8FBH7Re0XOQ+CTF5Q3FjRdDLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770384808; a=rsa-sha256;
	cv=none;
	b=d3V9lwk+iqfXf21ZLhldbcnk+5OvBGVqoaKmRL88I5YXwHkG+85oGRtQGMZJK1yjKV/Nop
	NoHK2dRbACOxqkZ53e3bLoJZHl8rbdwR7qLfkDe7boyljA7UnID5kotnHRpgn6hAk1YDDR
	xJgR80uF9aga/IWQeo7vMsJNe80L59Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=Z9Z88ceb;
	spf=pass (imf05.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4f6w5f1jGqz1FDXx;
	Fri,  6 Feb 2026 14:33:26 +0100 (CET)
Received: from [10.10.15.18] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4f6w5d3Z4Lz1FQVL;
	Fri,  6 Feb 2026 14:33:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1770384806;
	bh=vb13Vwh1fPqNxRNlEIYNEmJHIJtcIK4aczKvaS88OeA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z9Z88cebMu7Ddw1jVWtT448QIvjHL3GiCwWDGvsQ01Wxtyv3l79H+bPYslc1UOB9Y
	 BdTB81cJcyiWlbAk4Xtv+cSCwqG0dm8ZtfsJ0+1NUs0nMYD/nsZAWUQ7EG3GW5LUcx
	 0wBqY7vrdo20aOPF/76QbRmshC7PSNXwuN38zJAxeBlYBIzyXSflwMh2TZ4DIboOxw
	 vVux+ighrR6Q5uNjNY7Izr87aZexRGjwxcfGrRU9WPwEYfMjDFCgLUCpuncK1iWdjy
	 /ZR4ft/NA5cLVxWSHqdmyJ6d7uUMeuP1zpoKteadSBJ5gNGxos6/Pw/tMDP1Ddpwbt
	 dhqXYTI9hYY9A==
Message-ID: <847afd79-e8f8-4547-8167-0125809de055@gaisler.com>
Date: Fri, 6 Feb 2026 14:33:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/8] mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to
 CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, richard.weiyang@gmail.com, will@kernel.org,
 peterz@infradead.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 dev.jain@arm.com, ioworker0@gmail.com, linmag7@gmail.com,
 akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, sparclinux@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
 <5ebfa3d4b56e63c6906bda5eccaa9f7194d3a86b.1769515122.git.zhengqi.arch@bytedance.com>
 <a404e9ec-35ff-44b1-b321-9cc4fbf72060@kernel.org>
 <1663ae90-3247-4e12-a25a-049fc3281e19@linux.dev>
 <538fef61-3903-407e-8486-538a28b99e9d@kernel.org>
 <53a1bbdd-26d1-454d-af06-169172278718@linux.dev>
 <c24c32bd-085d-460a-833a-a982eb5becaa@kernel.org>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <c24c32bd-085d-460a-833a-a982eb5becaa@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 389D810000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: t8wuxra34h35r3egiixf495mau3gpxgg
X-HE-Tag: 1770384807-606206
X-HE-Meta: U2FsdGVkX1+HefTr54ydDvJcjJOPWSurAkS+16FTTykIHRWqu4QRT531n0L3hAtHitAboOUsxza/BLrHmCTy1KxNoTqUWmMvulaxFdGFMjfKG0mBIsBix7O+aa1xoGWhdVCHj5dFznGSJCgDG2L1opxuz83Uc+n7eYScjtOnBcDXbavsPfqOC8SidCjc3IQZ1phTJ4C9mMEvUSRK3PwJZhJiNpJV6K1a8X7njryzLn4NYj2xhSMnAjYCDKRqiVUHMt+hJY3qh/+ydK0pmhkUIxYFSOX610EJjuQBkIoENT/j2SEyyPanQEDRL88MNc6fUOj0S0/BzB6SSPZSc9lN4O/8nEaQGqu8h5rOSduZGc1Cb78pVjWGiUlmz4L6HzxDosP3napYAp/PmoO72o9kPlV7LnMN9vErXIAwS3zMJqMS9FPffsgOIxQh4zbiFRXfoSd1qzmcJNbC2hFRByZzWnD787Ed+EiBh9JO8cOrhH6N6mkBtgK+OGMP+/E/o7SXJDajVV5MFFEnV/MMEDAn3Z4t2FqGGZ0q1b4HVVgSs9gxBCExUtB4nvrvF9phhf5D9F7LrEbTeHVpLQYMgddnq2G1z51wVHzF8sFKpe8nyZf7hr+hQSDmgJoSEzMlOVwT2MbFB5183TJdcM8g0L6yEnh9H8Hj9ejV8AntgOQp0luvwhtGm1OejfUjyOhSnHAaJAOR1E64Uvv//fbjYxvkyiXvd57xe54dI72F7pyU6Ham4idcY1xqaDKSylKOp1/6nHUw939wF+6IwkaiiDxr2bl9HXTDG7oYkaYnR/xAAxk6KjAjlQSUzToVOGn8mUF21MxYMeSgSQ/LrVDIQnCg62mqQ/wQrmhITjmCxssUgEu0h3ka7trj7jdT5bMTDwG1MOy6ayG2r/dOmmU1iSXMOSdyhjgDoo8BFVz80rLCRY+z4ZdDHQXgetccMt/ePnLI3+SuIPq/MJKdcbW3iou
 e9xAbRDC
 w9Z0UimVr0rnU88gDQ7MjSejzvikR5YEd1fYvKGwa445EGvkh/85IL2qOU8AfVTsjl2cZAYQKYpNAX4A4xg3I0qVhQwfvVIrQmlAcTXI5BHX4ClaUFOVfVboMmULdokFuo/0yJd1l8ySWWofC7BCVaG4Z51rqM1O2v/rS2DMRArggWx/pYA92+sRloXN9BeokzRC8on8+L3w8Wmofb5QE31b7C+QxjgQq6F2fM5darlbdTxf84Z7pHtINBQcAjRtxkGlTx1pwhVIKNHhXvCELYfHvohnQ1ZMzPJYr+xJ5qLK8fYGq8Z4LRAJlW5wwi4q/1uey5bXyl1sbpXjx29DArxrojPc/pVSFi6bnTbYieei063oP1enctuhfcfh7snb31LoRcX99CAda5SZYFHA5NvjbakBoVokZC6MXKrwJcAaXDnINUHcQgP9pJKMYIXgSBaVwQq689PSNmRYoIl6hg042PqiHw/jmQ0RJt5EqC1pJPVBT2JrojW7Man10w1L0VJ7TM49DBoQNXwnKpZRTDWqISQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-06 13:59, David Hildenbrand (Arm) wrote:
> On 2/6/26 12:58, Qi Zheng wrote:
>>
>>
>> On 2/6/26 7:45 PM, David Hildenbrand (Arm) wrote:
>>> On 2/6/26 12:13, Qi Zheng wrote:
>>>>
>>>>
>>>>
>>>> Ah, It's just simply aligned with the MMU_GATHER_RCU_TABLE_FREE above.
>>>
>>> But does that work as expected for !SMP?
>>
>> In the case of !SMP, tlb_remove_table() will not be called:
>>
>> static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
>> {
>>      pgtable_free(table, is_page);
>> }
> 
> Ah, okay. Confusing stuff. Would have been nice to document/mention that in the patch description.
> 
> So if it compiles, all good
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

It looks a bit weird, but it is actually more logically correct than
before the patch. Before this in the !SMP sparc64 case
__HAVE_ARCH_TLB_REMOVE_TABLE was defined even with no actual
__tlb_remove_table() present. But it did not matter in practice.
But I agree that a mention would not hurt.

Tested both with SMP and !SMP

Tested-by: Andreas Larsson <andreas@gaisler.com> #sparc
Acked-by: Andreas Larsson <andreas@gaisler.com> #sparc

Cheers,
Andreas


