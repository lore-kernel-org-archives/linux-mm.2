Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 530D8CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19D98E0015; Tue, 16 Sep 2025 05:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1538E0001; Tue, 16 Sep 2025 05:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E518E0015; Tue, 16 Sep 2025 05:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92DF48E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:59:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 642CDC0980
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:59:32 +0000 (UTC)
X-FDA: 83894666184.13.E79C39D
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id 614EB40006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:59:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d0dh7ZFQ;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758016770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/74KktArckX7J8R2a2TYA4SkdsC//wm2zUbZ/9vpR8=;
	b=hB/7EHn5vKsfkmaKVPQU+zVgtja2tub8xRAj7sLDweQXl0TuVp8uKxlxz3S9fmb4MX5ktS
	b8rQLi2+cdowBqylZ0s0Gmfh5pTKzcz9i6b6SixfN/3if6DL/vgZi3FIIqlRzqbZMEyBf3
	/xVTc0n8zZmEewPE5hs9cKSdS05nImg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d0dh7ZFQ;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758016770; a=rsa-sha256;
	cv=none;
	b=VnP7jx8UxvxFXYYHMTniLx5ocEc2NhzZ8hdexQ71gf7Yq41di0O+WQ+lxR2hY+TtMItIHm
	bevTQ7VIP/2wo2OgS6fkJLb1bkhDOYxfA0ZcZvhYD3dkGESSHHI+EUegpSGRnibSYwPxsV
	3wIxAIJBCxTpBiZ0IwwIF8JDurHexAA=
Message-ID: <e75ba095-8d46-44ec-81d1-fed682ff9ea3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758016767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M/74KktArckX7J8R2a2TYA4SkdsC//wm2zUbZ/9vpR8=;
	b=d0dh7ZFQbUyeJZdVf7kyPIooDTe6AsbGuxuvJ9FbHYHYw8obeV7cLaNZ3GZIliZoEIU7Iv
	mkf4NPBSbfm2QryTtKxRtgzgcd66QAgfVI9kdyzQic0by6muvFPPA0Yo5QUiaCQMudOQqH
	XLJwkYoNLmzW3UioiLq1mWq3tQb9YIA=
Date: Tue, 16 Sep 2025 17:59:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier in
 khugepaged_scan_mm_slot()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Kiryl Shutsemau <kirill@shutemov.name>, Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
 <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
 <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
 <ol447ofo44vwtyfwg3zrdtcdlkfzzmx4rre6qhyotmwvecnec4@usa3nonuk2sn>
 <2466c068-ccd7-41a1-bef7-6f3fefc6ff55@lucifer.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <2466c068-ccd7-41a1-bef7-6f3fefc6ff55@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 614EB40006
X-Stat-Signature: ji7331p6ccb1b1mm3h88rg7q6h4enb3d
X-HE-Tag: 1758016770-546305
X-HE-Meta: U2FsdGVkX18ktXVqngj1iTjTV1kw/P95qmT9JlClczN7aimovFg8phSzRvXR0UII0GSVRmbLkvQy/VT1RvUjQBRq4uXHo+QrPEoIPeVWwOhBHA/+ATE9rlE1rIg+6kxo2kgvQZTpF3TPQkKS298CqkteQljU8m+GnYgGJmEWJJ1Ri7OB5fVpLzvnrJhsQP8K30mZwhvm4Vh7F5xaMpTPRx5DtOom0d5nb2Qa1krEx+Q6ZlO1Xvy+0IkApf9b9wqkPnRimSg+UA0zOQRWN6/X7y41vcu5oCIieS4YQY2RoX609cxlxAyvenTQBAe5G30Z0yUupVw+nzFbH98jfe/0bdpVIY7s5kp0aqW+FODHktePtP8C0YMSDtpIBRpIah/UnK+LaUx9Xd5AVUMekLGSMgrloanerr/WVPk9Wb6IdkWwzfY5K1vlALR0L7iufBKMCBMqcHywA8YLhSWjMXeBiDepBca7nZiXp1cT9Qg+vQfih0PAhXAwq6XcUY3V1b8KGPNCfLgo9z13jOInR2ZL/smbuqrNStqqfVJs2dv/WGDpzUR15qjCsGoW0XcF1UjEPpW1T/SNFd4OXEU36oe2xqSjYiJhKznrhQzPLWwyIuGnKCxArWpGnOyW6AtrrMibnUyu2smW0tyyU9SweWwqjopFY37CMeo0qurx3EfPtb2pVjwRbOIiUc1eYyQGgBMdL9niPvnU+C3ntFjGy0BHHZovXw3a31OaqX/I6+l5kmz7QdXJw6/ifuuMz8mjYFP7XUxSV8OUZWGfFnNygE9+mif+ksSbvIa7OwZJ8PYaZBqihEmToi4g4lQjLE6qkCg1RFiWbhlKbP++Vnox6AG80NJGnfZX2CY33WZhKN0xAAqHXJDvFq11Kwenc65If7MeNNKhcO1YYFyFALnFoE+xQ6zVSjt16RiS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/16 17:39, Lorenzo Stoakes wrote:
> On Tue, Sep 16, 2025 at 10:29:11AM +0100, Kiryl Shutsemau wrote:
>> On Tue, Sep 16, 2025 at 02:21:26PM +0800, Lance Yang wrote:
>>> Users of mlock() expect low and predictable latency. THP collapse is a
>>> heavy operation that introduces exactly the kind of unpredictable delays
>>> they want to avoid. It has to unmap PTEs, copy data from the small folios
>>> to a new THP, and then remap the THP back to the PMD ;)
>>
>> Generally, we allow minor page faults into mlocked VMAs and avoid major.
>> This is minor page fault territory in my view.

Makes sense to me!

> 
> Hm, but we won't be causing minor faults via reclaim right, since they're
> not on any LRU?
> 
>>
>> Also it is very similar to what compaction does and we allow compaction
>> of mlocked VMA by default, unless sysctl vm.compact_unevictable_allowed
>> is set to zero.
> 
> This is a much stronger point.

Ah, indeed, the compaction analogy is quite strong here, thanks!

> 
> I think we are sometimes too vague as to what mlock() means in

Totally agree on too vague ;)

> totality. But given that we default allow compaction it seems sensible to
> keep this behaviour the same.
> 
> Unless you have a specific situation where this is problematic Lance?

Not a specific situation right now that would clearly make this problematic.

Anyway, I will drop this patch from the series.

Thanks again for all the feedback everyone!
Lance


