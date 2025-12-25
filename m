Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1810E7AD41
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 09:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685E76B0088; Thu, 25 Dec 2025 04:32:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634126B0089; Thu, 25 Dec 2025 04:32:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515D36B008A; Thu, 25 Dec 2025 04:32:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 420616B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 04:32:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8D5C138E29
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:32:58 +0000 (UTC)
X-FDA: 84257479236.20.F807EB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F04C31C0005
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:32:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFxu+XO1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766655177; a=rsa-sha256;
	cv=none;
	b=YsFgKyWfgV0UM5BqZ2cHM1ZQr+xqwJ8sk9DQqXHR/tescsXgrbG/AHZrKOeFe7deDmPXes
	EFwS95r0ykMHgwoQ4n1NgJmzVy7ZL0u90g/4QnTSGvczROU4oJxDcBd4UbA4ghfp16eSyo
	D8I9qw2dQ/fxJo0qIzWJzBWiaqVAjVk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFxu+XO1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766655177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykrfyvhCEhxHTWBUlRtdnyaWrNkWSM4wnafQHdv27aw=;
	b=f5MgnNO9dMAzDw9jv7INF5O6lGqQpUiYTbHxwijgtlWuLI7zOY2aSsKq9ZPz4h2NL3I1rh
	GDUULQ+vBysYJ84XukJYuW4IPufakD4stTecWXj8KIG4mLRLJjO+7R+RDR9hz41QXo0L6h
	mp1E0RB5pnWkAc+T3tL4JOZjNXMMMuI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCF5D40C09;
	Thu, 25 Dec 2025 09:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD9CC4CEF1;
	Thu, 25 Dec 2025 09:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766655175;
	bh=crIs7Vpzht/pnJ1aDRt6pQoB0tVv3wmg1UPYo0oHvb8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jFxu+XO1h+7qVufOEkkeqYJ+y8+ggI/EjXBUiY3/m1mhMJxUKl5bfL1k03shi5Yqp
	 E/ms3S/D3iMl+EDwHTlA2nFYMmWIjPZjxq96aUOCbpTwFo4YoOF243vMMb2Fs72paF
	 kHChZbjIfDArAhQx6T3kZ36v5u0TWc3Tv+DAqgS8r9bW0zC/ZfFDyGRHRpuDyFFY+4
	 3oG0azPvSNPLXl1d2FTfy0zC2nRNzfYdMBdfX/7+5/rpfeSwCQfWqoQ+zbvfiWHbA8
	 a1VQXWYR7iLj7KpmMqOy5j0HxAa6841d/+J1EqPkgyePGGd6/Lbias2aaqFYVk92xZ
	 K8dBSkuie0qYQ==
Message-ID: <b65297e0-0ea7-4ac4-88be-fa89d6749d7a@kernel.org>
Date: Thu, 25 Dec 2025 10:32:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary
To: Matthew Wilcox <willy@infradead.org>,
 David Laight <david.laight.linux@gmail.com>
Cc: Lance Yang <ioworker0@gmail.com>, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, chandna.sahil@gmail.com, chengming.zhou@linux.dev,
 hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, nphamcs@gmail.com,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz,
 weixugc@google.com, yosry.ahmed@linux.dev, yuanchu@google.com,
 zhengqi.arch@bytedance.com, Lance Yang <lance.yang@linux.dev>
References: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
 <20251224092332.53214-1-ioworker0@gmail.com>
 <20251224140829.2ec7bbae@pumpkin> <aUwruMji4MCNaOPi@casper.infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUwruMji4MCNaOPi@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F04C31C0005
X-Stat-Signature: jfnsg95rumha9zdd3kswj3rtuso3oc85
X-Rspam-User: 
X-HE-Tag: 1766655176-918246
X-HE-Meta: U2FsdGVkX19NbNoMYnhnDF+w4QCMerqvEzVpA+UPFoepPwu2DSymFXwq1zhB/WIpiOFva0fX86ruvJ0e3ANnt1HCc9u9z5NecCGLb7abzi4Gz7qVan4WP4v6QGPrAgJtEz9bGvgctf3N0MORxJFPkedey62eWZGRRA/5KRZyaVlZbSzR71NMrjGVMQlS0f9pvzLjcwCkgBR3A58IYl8LX04Wcwmz1tbxa9UqoK33/qvMPCzpnNVgzFu616elSCjGOAGaua58FwdI9NL7fQAl4u+yMBK1r91482Wp6DinukGpYF5ZNDBP7AItKgCPeKk7eWQeedMEPGeOr7Bx+B8Cg4sl6JYFDtbGGJNyo9+Mr+eJ7jIwUlMm/FoqbMcDm9Zi2aggdBh0q5chusq0SLAOWa9ZDH164vudLhvrZwyHRB2ptB554vxbo27YKQCDXe7vPPHhJNJTL68zNnWwzozVJI7mAEPzC+sftmQ3ELko5F54x05iCO7eAEKUTocuN0YsHiWpxZtLp69jcRDNo8zHk9Qmcpgn5z0hHqUrDKuapPdg4Q0NME7pEn9N6wgH/NPLDk2V05X/FMTAiS8mDQVWKZAcYVXbQPY/U4GEBR0AWw9YuFDzBlwmM4uwYQCjSQyLPE1ELHnC9LrdsBkOH2ujudnXGYmW6hYIuYbd9iF9cFPkhdIQNQwzyWf+x5aiZBM97Sv6mcG8tdIWe1v1pCItGdQML1IiV+RZYApxHQ0lp3QC5TkSeVEXVrD640KKTlWOPMK+Q7Qmt5CJkL7eY5hOzWSDu65AxV9OTXA1tTg/5hf6eD6jeFfCywEQrl3Z0PYUXCYQkfOvtCJbm1vjm4M/d46ye0DcZM7S8DZEVKLOCuJ5LlQPwQwQH1QBQLayEUc2z/z6zxgQf95dfzz35Fl0cJpa39wLN1EhYeK9g1s2EiADx8RwGXlV1+1YgIgokV/d9V9OP56/MS5V5Xj8rMt
 fqG1McOx
 xebZTLOcx6yiupDffFnlW41zacDXVjYz3veCWLsirq2VrMRbkTvEyrBN4in+s6vQAilxKaFU0l8AMh2VVvqOCXQNs9yuD3VEoYj8aQSyvV31XjzA3ZAm1TIcIQS9dVjldzRs7gcsIG85lTn/4RC/M+3AbtO+ZOXaUQexhcETyCdicchafsj9T2z7D7Rl156WsAi8CMlfxPOuO+hjmci5Utk39lfJXoXUOb7ZgXaNBnPwoTm8u8VGUcPpb9yF/HsfJwqk02nb5Ec/lLRs1NF4Th0oFVPFC/WmnfFJVEFBoabzl7mXf9SEcGVRHpCR7D4+ESPHNWC3NYFSTMQXnN+9JwKOZ7dPb5Q0FuwEWicRUoIwSaL4a0JTu0d6x6jUqG88dPHr5h2CxocgkQIN7KQneZzVc6fNHuDNu3Yg68ePe9muyELR8KfjMJrf7CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 19:06, Matthew Wilcox wrote:
> On Wed, Dec 24, 2025 at 02:08:29PM +0000, David Laight wrote:
>>>>> +++ b/mm/pagewalk.c
>>>>> @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
>>>>>    static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
>>>>>    				       unsigned long end)
>>>>>    {
>>>>> -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
>>>>> -	return boundary < end ? boundary : end;
>>>>> +	return min(ALIGN(addr, huge_page_size(h)), end);
>>>>>    }
>>>>
>>>> Please drop this patch from the mm-new branch, as it causes
>>>> 'run_vmtests.sh' to hang. Specifically, it leads to the system hanging
>>>> when executing hugepage-vmemmap test, because the program falls into an
>>>> infinite loop in walk_hugetlb_range() and cannot break out.
>>>
>>> Good catch! The problem is that ALIGN() returns addr itself when already
>>> aligned, causing the infinite loop ...
>>
>> Using ALIGN(addr + 1, huge_page_size(h)) would work.
>> Although it could be (addr + 1) & ~huge_page_mask(h) which is probably
>> the easiest to understand.
>> Some of the 'helper' macros don't really make the code easier to read.
>> (And that includes a lot of uses of min().)
> 
> Or we could go back to my original suggestion.
> 
> https://lore.kernel.org/linux-mm/aRyOWrARRlUCeEz6@casper.infradead.org/
> 
> which was in v2:
> 
> https://lore.kernel.org/linux-mm/f802959f58865371ba1b10081bced98e3784c5e4.1763796152.git.chandna.sahil@gmail.com/

I'm starting to wonder whether we should just leave that code alone :)

-- 
Cheers

David

