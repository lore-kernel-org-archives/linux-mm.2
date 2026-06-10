Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB499CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100246B0005; Wed, 10 Jun 2026 08:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088C36B0088; Wed, 10 Jun 2026 08:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92B76B008A; Wed, 10 Jun 2026 08:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D59336B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:21:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 811881A097A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:21:13 +0000 (UTC)
X-FDA: 84863912826.30.44FB414
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BE7C080018
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:21:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=akMPVhfx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781094071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a50tMtdpQDTnzTpaK5Q8i3OL0e4khg4RGHRIQxs1leQ=;
	b=ar20EA6EgKvzxiFSfLKeopwrxHKNPrbcYgkRwKK8sMUeV2YwFb9k/q3Cz3WvhlyGVNKNdq
	ktyVI+aFX92ctpaiCJkbGGomViXe8AC/lk1gXFUYX+FpcIqOSPN7YcPbUND7dzBsZzUhog
	b4N+5KKFfBUHGWZ4XQIpFGlCGiZ72Kg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=akMPVhfx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781094071;
	b=bX6QujMjFddjrs69n0I0a86rwHOB8ST4AdcF3/sjT3yUzBDPO+yhVhgd9/GZg9iSIQz9BL
	MJ8cVClX7U2wDt4fd/kNKkG8mtzcSghZnY5OsDM0L/f2Z8YAEubn5swBv1gM8Nv7k4fo7q
	wSd2L8gXhmvPpzUfR4uzJa6F737y1ro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 390426001D;
	Wed, 10 Jun 2026 12:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0F61F00893;
	Wed, 10 Jun 2026 12:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781094070;
	bh=a50tMtdpQDTnzTpaK5Q8i3OL0e4khg4RGHRIQxs1leQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=akMPVhfxGvtalWUO0OgRsv68Go+o+3t7MAmYT0dp6OsxlUC1e6AyfVLF/sabFbfnm
	 TYXTpQFdV+014B6UOGjc3ykeBPuOXoGqhyV/uYSgobvajXDcfWOgjHEuEKVgennMnd
	 m+3FU4t6Ek223HZamneqahsgsrdoj9VAs15OkTL/cScrnK+YyCVzv70h+1bcx9recK
	 fvG5Rb1K0B/iXM+9VtOS0wpaMe6sI+zLjHtAt3dQPGZ5GJa+JmK4LV+b7lPv0H1R0f
	 Kc7+K0TM7HnZmB8+jOOJVMV6GSxQ10HDMoDy91dVFaJ73aeHm5Oxr5LuJb7+cG52UQ
	 s307kLXL6ywhQ==
Message-ID: <33003570-fe67-4c08-ab7c-fdc9f85e2147@kernel.org>
Date: Wed, 10 Jun 2026 14:21:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup_test: reject wrapped user ranges
To: Andrew Morton <akpm@linux-foundation.org>,
 Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>,
 "open list:MEMORY MANAGEMENT - GUP (GET USER PAGES)" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com>
 <20260609182705.7b3a46e7c4661bd55f8561eb@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609182705.7b3a46e7c4661bd55f8561eb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE7C080018
X-Stat-Signature: gxfo7bpx8m3h8xdnrnckkmr6e3116j61
X-Rspam-User: 
X-HE-Tag: 1781094071-663330
X-HE-Meta: U2FsdGVkX1+9RUHWPIaBIMeiXIuJTIoOTOGnlhqGciHxkalJ4sYfUrWuIQ2dsjZ1eW99qhkf8DwNDuyjRj+8zjRvifxwbIC+bR2rWRP5ylXYxgwJCb8jhFttABNWnt1yzwrWnBavUBQ6QxOQzjuX3xZ5uFSe+LbinPNFhjXYiaW3VEcLn99JCEZ9olXg55/csztK/kZ3T/y9P8QDgiKeUrwOG2dORfaZ1+M7nFvuK/inshw5Kew8DrYkqOTIXIDAzNo1oLAkwJaFX/pOqSU8tWxTTMrxZeT3YROKv9LtfkrEnGEnKe8cJ1nuOgF0xIckK72yW9pP7/CqoV6a7OSMVZkjaolu94fIQ72pOZ4jeyJisKOvqlVO9c6m7CdWdGdlejzA+dCVCIIdlgHBcXAsh5oa3JeSb4mINlGx5RkJEqVUhsQQ0ERdO9TwhIA0+BQtgggjZoPzV0G9JIxrfx7dWTJN7Ige2+f6VBJW8mBq54aXGUrECZBaBVbqywyh/y7lDwzYUUD+Y8D7yy1QCnId3N8pJjtDpD0fZNOYJKZnS0/0SMF9iejpOD0ixr6zCI4s7dYbD30EApzqPKtJOgPOiKhdiP5rYWk+e40qwmqEMbSzpCjNuTT42r/2jcg7Mt+iLCEl0FzXHfiRM7wL7BHA6oJ6+TbWk87HlQgfY/Kv5/fs7MDsFU62SYaX4LwzIzE8d98K7c7LKbqGG8fU/A57Lnc9JmqGCHYMsi90muHA7fd2hEaYTkr37riR8VZhrUtEvv7idPsqt2zJYETgcKle63DdjjfRLYMRdiUCDqRXX7LGGuZ8CGRv8PKZOWC8FU+swqJ4vI+qpFyXPp9z8BNc8+jd85SoFCA8Xh60xxDtXc9mdVZS9yqadSf3yW4q9lLf+ZKoiuzg3HuxEIzKXDCOiCxamO8MSY6lKQLAyC4fBdFK169UOvvhHWEj+WmlP4Qr2SnHaEbQ7WDaPBPJD22
 I4vjubnX
 M8OisazvWpmGCKULUDoA5mqbtprLFExiL9weWCCLyOSjjma+C5bfM7ylhSi97rVnrmL9vzqv8teX3tEE3LrGAennG954QjCfTTcefOiDME6R2zSm9iqi8Y7iixf/SQwqzkiemF0PrDuQBlx5lJLbx1KHu8WtgmdTr8ZUktMCT3brV+a3U1TsSmDPdoQ1tOcH2ZShPBuitcT1Vj75xx1SRWaD1qUqDBAMg+lZjlhwGRtX6DDvi8EdxAI0TU84/FRyYBj/ArXm02B7Ec/nrYIGay+b5fjofyqHIX5p9R3B8XA0KMuDyvWxMYRDhwbjwPJ7RCY77JNO+miCX98bIMtCRe0WjAnpzJ6MzIsRC9orLtobb5ACIK7viPJrno/KMnFwkSm2/BfakQ45qNVs9QonXJr48tKZQXIj5IEgKzk7dcHQ9n/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 03:27, Andrew Morton wrote:
> On Tue,  9 Jun 2026 00:48:15 +0000 Samuel Moelius <sam.moelius@trailofbits.com> wrote:
> 
>> gup_test accepts an address and size from the debugfs ioctl and
>> repeatedly compares against addr + size. If that addition wraps, the
>> loop can be skipped and the ioctl returns success with size rewritten to
>> zero.
>>
>> Compute the end address once with overflow checking and use that checked
>> end for the loop bounds.
>>
> 
> Looks sane, thanks.
> 
>> --- a/mm/gup_test.c
>> +++ b/mm/gup_test.c
>> @@ -105,11 +105,15 @@ static int __gup_test_ioctl(unsigned int cmd,
>>  	unsigned long i, nr_pages, addr, next;
>>  	long nr;
>>  	struct page **pages;
>> +	unsigned long end;
>>  	int ret = 0;
>>  	bool needs_mmap_lock =
>>  		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
>>  
>> -	if (gup->size > ULONG_MAX)
>> +	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
>> +		return -EINVAL;
>> +	if (check_add_overflow((unsigned long)gup->addr,
>> +			       (unsigned long)gup->size, &end))
> 
> I wonder why those fields were made __u64 instead of ulong.
> 
>>  		return -EINVAL;
>>  
>>  	nr_pages = gup->size / PAGE_SIZE;
>> @@ -125,13 +129,13 @@ static int __gup_test_ioctl(unsigned int cmd,
>>  	i = 0;
>>  	nr = gup->nr_pages_per_call;
>>  	start_time = ktime_get();
>> -	for (addr = gup->addr; addr < gup->addr + gup->size; addr = next) {
>> +	for (addr = gup->addr; addr < end; addr = next) {
>>  		if (nr != gup->nr_pages_per_call)
>>  			break;
>>  
>>  		next = addr + nr * PAGE_SIZE;
> 
> Sashiko AI review identified a pre-existing possible overflow here on
> 32-bit machines.
> 
> https://sashiko.dev/#/patchset/20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com

I mean, we don't really care for gup_test.c about any of that. The patch here
looks like a decent cleanup, so I think we should take it.

Fixing odd things on 32bit that will never happen? Not so sure.

-- 
Cheers,

David

