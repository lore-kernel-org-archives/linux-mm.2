Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE19CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 06:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5926B0005; Tue, 19 May 2026 02:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6216B0088; Tue, 19 May 2026 02:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E336B008C; Tue, 19 May 2026 02:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 763D76B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:25:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20B511A01F3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:25:23 +0000 (UTC)
X-FDA: 84783182526.17.46E163B
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3AD30180008
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:25:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Bh0ee3r/";
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779171921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqu27ytF92MOWAvtsRZmJQ2pxo1YPz+1gTn7hEWTGH8=;
	b=c1sfZQmYHg+Ui651af5kgqk46IAkpgtdr0YpyVkRH4PkKPRW3SjsbwFR+oblNPO7AQYqJ6
	rx7NIz3L2uwaNOM9zwGScERuVNnRF52elChpH/Zd152bJ5VLi5LzcLtzodvxH7pZZhqLVC
	9kGxBudDSlytZ7gtQE7Y4UdivY/9wvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779171921; a=rsa-sha256;
	cv=none;
	b=g+SYCPsenOt6irP9TQIWeEnTQ4UboEZgU6lL0CZLgCGC03lm5PBKupzKHIM5zVAb2Q/24P
	pIKaDx88raSasTbq6DfmNPuPKCNoQrQdWRGFKG6XhhpweUIGe/KpYMGX9xy9HmO3QemLOm
	oQgSvF57Fecy9wmUKbLfI/4am0I7kts=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Bh0ee3r/";
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=gqu27ytF92MOWAvtsRZmJQ2pxo1YPz+1gTn7hEWTGH8=;
	b=Bh0ee3r/VQfg+Md6DyonduKKtT34/w+u3tVhfThIchxrnTBuLosNX6wCWGfJre
	p4jDQ/oP4PCX6P1bnVlH4yfE4zH+iDa+NoInyMttIN0xs9I6dvDguaqdnt+gHA+z
	g3e+l4BBdpLBbPSdaXJojjgVn1PRSvuWLqaZ64g/7HpaQ=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wC3n7kLAgxqBVn_CA--.32397S2;
	Tue, 19 May 2026 14:24:13 +0800 (CST)
Message-ID: <4744e5ec-f7ba-4107-8d2f-63bfe419632f@163.com>
Date: Tue, 19 May 2026 14:24:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm/shmem: use SGP_GET in read operations
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260515094702.1092355-1-chizhiling@163.com>
 <20260515094702.1092355-3-chizhiling@163.com>
 <c0a6e4ea-3ca5-4efc-af5e-b5abc968308b@linux.alibaba.com>
 <f5cfe918-8bf1-4494-80ea-32863df1d1df@163.com>
 <e63962ad-55a9-4521-9f88-fd6be0c80434@linux.alibaba.com>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <e63962ad-55a9-4521-9f88-fd6be0c80434@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3n7kLAgxqBVn_CA--.32397S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXFW8Ar4kuw1kZFyDKr1fCrg_yoW5KF48pr
	WrK3ZIkr4kJ34UAry2qw4rXF10934xtF18XasxJ34xu3Z0qFyftrWjq3W5uFy5CrZ7C3W0
	q3WUKrWfZw1YyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UcqXQUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9w0hvmoMAg2ckQAA3B
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3AD30180008
X-Stat-Signature: mhyybbjqsj1j1hhdijd8hzgab745qiu6
X-Rspam-User: 
X-HE-Tag: 1779171919-933045
X-HE-Meta: U2FsdGVkX19RsCw72TQyHO5JukgyhwWN1CPNWMACrIZwf0Q98fZqLYJ35crNm56Hg7j2rxtJ1K+i8M0At+R0ZmC2ctct5CuO1xLVMFIufOxo0UwLnQCTZZpQR/DaidvC+uoLEDJHMi5s1NPAyS+Z2Wa+vV23yCTmNyq+mZ/QG24ssAwEGdStxovazMu19+BUfZM3zkW/TQGIhUJEt0r4cs82FqIvdAAQivD6ZSv/o0pe+IHVTEYW60gj2YDYvko1CP3Nb1J30lJlTk45ih3lxk6bW2H+LzXir92AHQFh8kF3MEqs7rf6cIN5RnLQzPI7UtPG7pjP4dTXGMHtV+WjVNwwQ+RQBMK8XmbQ1bv3QIojtXngVIPRabJgjvJDzeHpLqW82CmXX1AVOYT5RGReNFcawBf+4S9K1dI22bYTT+cfdxthUtBpoem/Y0Rvt1XRALN8BfC+1sU3wOm4RpYXLYAeToE1PVQrd/xEjPQmas8t15Zd/IzUOjIWIEloev/xwe8k8pEqJJthDsjtBDbfsqJZrHa6958I0D9S5Khr5c4Gn2PEW5mIZAMJodjO+5cLvWtjeqjnnGXnbEOmCpKB11BjTtIbuugG/xz+qe2JdlYHj4LKqlph7YuSuaGu7lnHs3ueoPR9DSv/6TaCy0xDhpIlOcF0YcfQ2TU7w1U5dxP5NgZHTkz26OqOFg72gEEGF8z3DnNp1sWDPS1ieQj/u46f3Ln8fF0lVcGuZfQYoTiuSa37p2gWagYDcYdy6y0Z+OoJFYH7p5syu+Slhr1kFE/dpW1iLgqXTPkSSTOwCoWP0F/mnjXkd/xzqY2arxXScaCRgkKfbk8S3nQixvndm8fikRLCXYiXyAf5NPRmoSEoayPZQ1qv4tGPMdkvobRWDGx2gWbc31x3wueXjbe9EhLOaQy4hO4YEReu2PSLBT4eW7ZPJ97jG2Hus9ZkQdPrn2tFcuzFgKscXM4AJbb
 WUok5D+N
 L9ALLUc2TYY1tSaMBNrx3RGKnVuJy18bp9Jrl9uY3oH1yGiOP+3Z/ptFFAU6r77gWEY92kmMHTHz9QeUZL8/LwzakCvNsGWLNwnQEQYfBgDaZWkhfzVJ3eHhXCJC0OXZHLN2K5idnpsEb+lUA+KC58czhZQNf49FkMcw05e+Q+uBhc4bcNaTfyoe/8uEO6pboIdvhKXT9iVLGypXlq3n3DksqsS+80ISQcSZiWbopbJqlzXx4tUXGqVmhP0l9qH7h0LJ7DJS3sA797VlYi5Eew8oZCZ1qUVBZiRNbEgmsylyoeimE0vL7RzQT5sa17OrC4B7RT6uXgtZKh/vuQZRUYJyX5u5EI/33UVLtndFe8MT8E6mbaKitMDwkvyx8cCFeWyNhKTzLJvhenGBm46zxDveXQmCqe0jj8U8m+sgrdGMmNgQi35tTEOtKcX3tx7aGaKrnuGQBQRX/l/FCP6WRjjDTmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 11:06, Baolin Wang wrote:
> On 5/18/26 3:42 PM, Chi Zhiling wrote:
>> On 5/18/26 14:39, Baolin Wang wrote:
>>>
>>>
>>> On 5/15/26 5:47 PM, Chi Zhiling wrote:
>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>>
>>>> Replace SGP_READ with SGP_GET in shmem_file_read_iter(),
>>>> shmem_file_splice_read(), and shmem_get_link(). These functions
>>>> immediately unlock the folio after getting it, making the lock
>>>> acquisition redundant.
>>>>
>>>> Even though folio_lock can protect folio data consistency or prevent
>>>> truncate while holding the lock, these can still happen after unlock.
>>>> Since these functions continue reading data after unlocking, the lock
>>>> does not provide effective protection. The folio reference count is
>>>> what actually prevents reclamation during access, making the lock
>>>> unnecessary.
>>>>
>>>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>>>> ---
>>>
>>> Thanks for your patch. It would be better to squash patch 1 and patch 
>>> 2 into a one commit, so that the usage of the newly introduced flag 
>>> can be easily seen.
>>
>> Hi, Baolin
>>
>> Thanks for your review. I will squash patches 1 and 2 in the next 
>> version, unless v2 is unnecessary :D
>>
>>>
>>>>   mm/shmem.c | 12 +++---------
>>>>   1 file changed, 3 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index ef19968cc51c..767610f78d0d 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -3370,15 +3370,13 @@ static ssize_t shmem_file_read_iter(struct 
>>>> kiocb *iocb, struct iov_iter *to)
>>>>               break;
>>>>           index = iocb->ki_pos >> PAGE_SHIFT;
>>>> -        error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
>>>> +        error = shmem_get_folio(inode, index, 0, &folio, SGP_GET);
>>>>           if (error) {
>>>>               if (error == -EINVAL)
>>>>                   error = 0;
>>>>               break;
>>>>           }
>>>>           if (folio) {
>>>> -            folio_unlock(folio);
>>>> -
>>>
>>> This is incorrect. Since a shmem folio can still be locked if it is 
>>> being swapped in from the swap device.
>>
>> I don't know how I missed that, that's truly a serious bug. Thanks for 
>> pointing that out.
>>
>>>
>>> Essentially, you need to show reviewers the benefit of introducing a 
>>> new flag. In what scenario would you see overhead from locking the 
>>> folio in shmem_get_folio()? And how much performance improvement does 
>>> your patch bring? Data is the easiest way to convince people:)
>>
>> Honestly, this may not bring significant performance improvements in 
>> single thread scenarios.
>>
>> I think the main benefit is that during concurrent reads and writes, 
>> especially when large folio is enabled, there are more chances that 
>> reads and writes occur in the same folio. Removing the folio lock can 
>> prevent read operations from being blocked by write operations.
>>
>> If necessary, I will include the test data in v2.
>>
>> A more important reason is that folio batches are not suitable for 
>> storing locked folios, as this could lead to some issues.
> 
> If this new flag is necessary, please add these explanations to the 
> commit message.
> 
> However, if there's no obvious performance improvement, I'd prefer not 
> to add an unnecessary flag. Also, looking at the implementation of 
> shmem_get_folio_from_batch() in patch 3, couldn't we unlock the folio 
> after shmem_get_folio()?

I have tested single-thread and multi-thread read and write. Only 
concurrent read and write shows some improvement, but dropping the lock 
is not the main target in this patch series, so I will remove the change 
in next version.

Thanks,


