Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42646CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59396B0005; Tue, 19 May 2026 16:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31236B0088; Tue, 19 May 2026 16:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945AD6B008A; Tue, 19 May 2026 16:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 833536B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:58:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E79340A13
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:58:00 +0000 (UTC)
X-FDA: 84785381520.06.6BC5535
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60A57180006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:57:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RCz389n6;
	spf=pass (imf06.hostedemail.com: domain of djakov@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djakov@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779224278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0F029817nyKUr7CFBi5Vq/YSZmB8vzA5KAIFJjfUk/A=;
	b=deM+qaPLJCbk+ChyfVh2NmzNvxRwaI6bfv8Exg/Kq1XYoiyWZGJ7Ki8/C+lBioNyqvNBC2
	iMjeqzTGNBLWT8mendesSvWLrvQaG6FXZFfzLQsD0Tp/0kg/rJZUYDg1P2jokkyg95ttvL
	asAqH2J/jxdcW778BPLGgkavMjTkMJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779224278; a=rsa-sha256;
	cv=none;
	b=hlrHyps4Jb8l4PRT7shiN8RH1RId/Hb2V//1rN50k0pmqzt/MKqFsy4us6HAvx8ujalk6R
	AqcZXadQKr7kYFfKu/RR/BRUip6OcIRYYhOG5untGvItFtJ0LH7KHRo2LCoxcUidsrFo8p
	4R1rbqUEQ1shR4x4QW8X5iMVf2aiu1U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RCz389n6;
	spf=pass (imf06.hostedemail.com: domain of djakov@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djakov@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BF4D41566;
	Tue, 19 May 2026 20:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2481F000E9;
	Tue, 19 May 2026 20:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779224277;
	bh=0F029817nyKUr7CFBi5Vq/YSZmB8vzA5KAIFJjfUk/A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RCz389n6oWy12KGSz/J55rCFtQ2TUbSNK4pcRKpdT+0SvwDpxmaP9S7uzxckDGSq5
	 bqeW3B4bF8f/IOb0bcMN2ZJ/4UwUrEF2chFyLDUY9ZedyZb7RQgMciAaQtJ5mQUW8k
	 46X4YCg108Ii+MxwoTedQ6qdJ3mUrm+A33USa9ZDmQwGOoWqL1TJr+ffMiB+ZkmbpG
	 u2XR/0Z/22FecJ+vjj9tyd9hu6Ax0IRb1PWO7T8tjxoYhdjDgCwSISMN3/QLzXHiPc
	 kDMN8JqErH+Hpd8gTQf49jVnhEpKUWJm69SYjJhSFLNRHD7SJeLlhi3BTTnMd+wWXp
	 +C1UQFm3HeHXw==
Message-ID: <90c0af4b-f608-42e5-9f61-222d943bcebc@kernel.org>
Date: Tue, 19 May 2026 23:57:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drivers/base/memory: set mem->altmap after successful
 device registration
To: Andrew Morton <akpm@linux-foundation.org>,
 Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Cc: david@kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 Mike Rapoport <rppt@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>
References: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
 <20260519132522.421c018b39328ebc4767dd8e@linux-foundation.org>
Content-Language: en-US
From: Georgi Djakov <djakov@kernel.org>
In-Reply-To: <20260519132522.421c018b39328ebc4767dd8e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 60A57180006
X-Rspam-User: 
X-Stat-Signature: jou3i6t5kqdt3bpuuwsra4q3tkoohjwa
X-HE-Tag: 1779224278-150687
X-HE-Meta: U2FsdGVkX19YOjHqwTe7rNvoZW/W/RqEwUwi8YR6wETzmS6Qf93O2HAnjaOcw5b+okuiqp5uYycYHGCPxprMHdGXNvdlXWsUGbxrRVFlQyyCkm0+oR7n2qKX7JXaDJBZCkpBRByz0qCGvAQ9R0sZjgAowCUMVMYqjDORF7UgUlf/5Sx1P0bHZ2CaOAgoxJ81cqDJX2eWIpqpzck7I6/oaUS4moK6nIydybxYojbuOa3kRBnQe9Gry3lXReF4qsS7Bx3ij/ji/PyqbapsJO8D5uhAYR8euf3laKdlr/CzuprUv167VIIrEcf+Sh2wI9/4V787o/Q34FkB1w8Q4D1Rgj3WpKMUSgT0nzERulDpp0dn36OmwjRVLCnBesi/qr/QnXtsco2LC25qoZCchGPmCUiNhaESbXhQBIbwoHPinZ0wDhm36zX8vHX/4l5UOgp5ojVtc8xgpvY8WQ2UJiD6rNJsZ0qeVq1bOhdwWnUqHMKF1kfRggJBkbMkFzvHZb+fG2pVVD5wcT/FW51wc8J0snz6vI6YTAIcz5q37H1Llc/gRMKABt3+r552tKnOddYujmdiIMbDr3/rCZxAJVBjekqieGNmmKpE6JWoaIxehuSA+z5m6C2TOLnnETr/kgLbEBhuDgwoxJ4OyHSbmlmLlIFBHbOt0hs5QJUOb2kRpcbkNoU5fBRTzyEO35x6utu/HinDYglLJtWHQDDopZvD0dSg3YR9Gak16vkDiaPKq1zicxwQ8uftM9VEo2vut07HIfdQaAuxyusgkUc8urzeAFgEyLy0eih4RlxjGzgyuJT96cZZfraUxDWTJ+GFdFE07eBJdjEm6wlDmrdNWJm8zQOi2ZClorB5PuN3bdAJek9KNvQZD2T8OqEI2FKuo0CEKTj41emfgsKM8S7r0RRqUu44Miq75TsUuB3AplDpvPUzsNF9p9H6uP5L4MxArbHaUQjsJNyOV1jQV8PhOuJ
 OZIOyqtq
 /3G3MqOylFHCWCxMtWZx/5EeqGHDo4rhMmleoZt2CFT1xtJ9S+yKeOlENj1STAHB7GX6rYQ6Pbx1zMSvxGsJDDJ6yxOKrXcJ3K/jGRlP7TRqFwDsVjtuDt6FVFotcf7ZbKf8LyjL7+Z/kzGgWPva4UkTroc0pYG2JDiZZCg3dMmZ2BKeh1hUR1R5NgaY61/zJ8QABRgCF019P4vXdGhXisTI7GGfNDlJZN3W610CLW4162p4ZAPUP6/84cNtrqnpZxIvcAMcJMSUJQPfsWuiHv7EtpLoQmTVN5iuIj+xwC0u5ii3tknyGBMTP9UT19Y3LhOyOpVrcU9s3vbTPgjcmj5LA3I0oY9z3NaRYUkUmN8m9JSxI28AHNnSvWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 11:25 PM, Andrew Morton wrote:
> On Thu, 14 May 2026 02:26:57 -0700 Georgi Djakov <georgi.djakov@oss.qualcomm.com> wrote:
> 
>> If __add_memory_block() fails at xa_store() (under memory pressure
>> for example), device_unregister() is called, which eventually
>> triggers memory_block_release() with mem->altmap still set, causing
>> a WARN_ON(mem->altmap).
> 
> That isn't good.
> 
>> This was triggered by modifying virtio-mem
>> driver.
>>
>> Fix this by delaying the assignment of mem->altmap until after
>> __add_memory_block() has succeeded.
>>
>> Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
> 
> Patch is nice and simple so I'll add a cc:stable to this, even though
> the issue seems rather minor.
> 
> btw, AI review had no issue with your change but might have found a bug
> in create_altmaps_and_memory_blocks():
> 
> 	https://sashiko.dev/#/patchset/20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com

Yes, i have hit exactly this bug actually (shortly after this WARN_ON, we crash)
and was going to send a fix, but noticed that someone already did:
https://lore.kernel.org/lkml/20260428081855.1249045-3-songmuchun@bytedance.com/

I can respond with my RB on that one if you haven't applied it yet.

BR,
Georgi

