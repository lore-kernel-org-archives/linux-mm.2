Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C96ECD993
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 18:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41A06B0088; Thu,  5 Feb 2026 13:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5916B0089; Thu,  5 Feb 2026 13:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D0D6B008A; Thu,  5 Feb 2026 13:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8630A6B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:05:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33A4359CF9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:05:09 +0000 (UTC)
X-FDA: 84411179538.04.E623024
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1B81240018
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:05:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ShlaPuF8;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770314707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytoSDeYyAfCO9B2aKhAb1H1lLRk7qH++Px7RKlZ8JF0=;
	b=T34oNCROYWf+9Ftv7Krzo0aYlXgHGWVm6yXhEp/cSXXfjaHMsBrF3bOc7bzGhIuJeyUoTH
	9Ui2VSKJq0mBOCzNQpyW71Uyh2V6L6sefdoxQpp9ZkqvDvQulWTCGbl1lRM2LtSC+a7+qD
	QonT7CPlabGQBqAx+/PLcABrnIJkKwk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ShlaPuF8;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770314707; a=rsa-sha256;
	cv=none;
	b=WFI/exxpldz9CriRpngDvNeGGUVDDRp4g5JF/qwoJOYmPzgVmKTxZu+eh0blz9oepPs463
	OkcTiGd7kHpUV5Z1V3i3o7EywSJDCZhMU1y1xen48RyNngm4PzRvYaR2mOEXAGy5ZuixEu
	0KCHh8ig3mquGbuC55Wz57enH9t+cHQ=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1249b9f5703so1987606c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 10:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770314706; x=1770919506; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ytoSDeYyAfCO9B2aKhAb1H1lLRk7qH++Px7RKlZ8JF0=;
        b=ShlaPuF8jJ3xQzKD0+2h3TnLW5AbTkyhIlARE+niOFgV9dAwWw0GHIJ6IArpAzoR6I
         TCst3M/+nKtoG1wVH0vO6stifBJojmPNeKB85Ec7bDdt/b7euuaQkGc9BMdtYW+DlsS+
         yQTvNgybQdJu07cvUtbIe0FIMXLS6AqNeezSQxjIBdsfX0o6X166TK+HnChIwQ3Qppjo
         okJh6UK2PppKhrITI5TpXLI+iRvz33WuO2P+df6x4D28Ha8r9Qg1ImdlECp8uiImYT9Z
         KLfPw9i+FCmFvtE8NbWjGN7CdzVtQYS76DhquOBmV4dHu1SoT+y1tEC2exQQSicWlaoA
         XjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770314706; x=1770919506;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytoSDeYyAfCO9B2aKhAb1H1lLRk7qH++Px7RKlZ8JF0=;
        b=i2dbeCBDSK8JXihKM0LmGL0HzL/ICw1tLU0hq5aAJVvIMUtwTO1lAfu+22em+k8+8r
         bGGkcLII2hwMMGQFQ9ukTXimwF0sP5x+60uOwUHdHkkZfYywoycbLq4wluMvaK72gFr3
         NgXSM/Z8IHHwBZI6yJMRNU1NoCWVifX+vkwgsPqKkvjTlQLEDTQnpIVtjTm5B257t2+w
         6zWXoIRXkQkqkpZoKbObob3e0iE+A7Z2BKWWBJDjvD1zFMJWlGvpKmsSPYL4r85UQE54
         PQWbgiOwgkdL2rJl5DbM+w3a32PTeoWunBKPLtXoRgAWDzYpMEya2M6zeJnB5mmH7N9S
         26xA==
X-Forwarded-Encrypted: i=1; AJvYcCWrxdotuvHbznW4782klZ1JLk8HB04Wl4dQL1SwUAKPaCGufKo/VMF2QAe7YHM6+/ovwyy4+eD60g==@kvack.org
X-Gm-Message-State: AOJu0YzJsqYuwasH9cpcWF+ScCuOipcW10SPHuGetjwRjxRW92uY84/m
	BY+KLbt8DsDTWIlyEBdjfyo4r9foRMuGGz+lCTxWxB07E6WrMQNAVSt+
X-Gm-Gg: AZuq6aLDTMQ06u7h8ubOqZ4NTzU/RxadJ8PJFFz3nmkd1sH5+1qGaurjHZERZmgjncw
	Ve5xs8oiiDaCEGFURNLkl4BBbvfxupjJt3Reu5B7vsOehXhLTVKNL3LmxwiakXVFJQkFahfX3RL
	F1bJNaRwSIzpsQEbjVKEHiY8P7JpcsOyM1NbkZtdAoSJqFmiyeSQ2xqwUFmlY1TcXw26nUOZHYO
	kd/gwX9MFYh0Nc6bxfgPx7ZyauUSVkUCj6+5M/I64iVeIUce7RGG1++t7CILE7sHC2hA/nFJp5D
	NFz+nrSfvqmAx4erjDukhmaq/d17zvP5O3WNuosiGEft8nfM7ZJ8IXnSLPlkm1jIrfDsv/2eqCT
	1k2VGl9VEvC00Ld0wH1G5k4eC0z7rxXUkRUlg3aNcg76jWHNYOl/pZDt/Y+tJKILJtu4Hddin3j
	Z9jdCWEoEp3onnong1Ji++cwsOpY3Q/oi942K+rnpcXEPXur7ZjrNzlkfa5/A931bexg==
X-Received: by 2002:a05:7022:61b:b0:11a:c387:1357 with SMTP id a92af1059eb24-12703f51563mr51355c88.16.1770314705552;
        Thu, 05 Feb 2026 10:05:05 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:1cc5:26fe:6b00:bcef? ([2620:10d:c090:500::3:b30e])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f5030df4sm4783574c88.9.2026.02.05.10.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 10:05:04 -0800 (PST)
Message-ID: <b2947260-becd-4f17-8822-b4c7325a176d@gmail.com>
Date: Thu, 5 Feb 2026 10:05:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 lorenzo.stoakes@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <aYB75cWO2nnTx2ch@thinkstation>
 <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
 <05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com>
 <aYQZzw8kJFsy1mMW@casper.infradead.org>
 <aYQar8YiejRNCqE4@casper.infradead.org>
 <945064a3-b6ae-4257-afd7-5229cf8267a9@gmail.com>
 <ee5bd77f-87ad-4640-a974-304b488e4c64@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <ee5bd77f-87ad-4640-a974-304b488e4c64@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yjfwn8fkfifqyoz7kquxf9nw7sniewco
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B81240018
X-HE-Tag: 1770314706-309187
X-HE-Meta: U2FsdGVkX18mgsnhK72T4F3YsoXwmKnGDog3MxcP/sxtm/HCw6o/at4gwTrnx17ZZdygnQ/ZT4Z0Ep/HAPV63OCqkxJpM6ZQxloh8BDGvXp9Mfx8Y168CLoHnEEXvxfcHo+pDF00xCu2i1dXmpUihj5zCnNm7olFYnptFwe9acjJWo4FdG3lVpqgfpryKo+Lu6wH5kSzE6qEjQsy1cEWaJGBqyajKbc1LAuu3/fsFl3CovO9SUHzodd3bhtlYVxx4lOaYXlfCWQG4AusnIQYjveGuw8/05WCoEaH8xi+aXPb3iUFnzDzovBy6/97w05tgA0TUF213NCRxvLMq5nbArWuQeXF7wpPcHQkSZQnjEFwD7CA3uYnR2pTlAZLV+ou+uLYHFqBgU+HAOIXiwO9D4r1SWILPdfW8E4KZnJaJ7hvWcx/98IOho7hsWVm/eNOFuWboHoKvZ/4ERoDiwTiukZNfrF9M+UUSn/8i2AAhby+MV/yYZGm3TmNtXC0VV+TlZwuskZqzTn7XZW9ToxtgFKg5Wbq5tk8NmHUAF1PaJMXzAz9BRnjAKpyVwEsa1B3u1dZi/hlk1Xuxel+PcJjrWM9JeTgzSVwT7Kgy5cOXaGkB1tjXMsP0Kfja6WIM7iKfI4EaZyFOssmwGoB4GWmwewH9kF6VREg9Ujt697j2ZqjbDWzqWhf8NV5pXyK4Sxaiac4/JCHilZC0ngEKlZXWvGLD4Lhcxm5kFmIOz8VdLNhF+fI9HHZcpvdOvtiPH/tZQZl6MJ3ohcG3QCmMqJb9QqShwzgk1gBQidR/F6DzasSdCLLdEkHv1BLH8HoX5Z3lxT1WYAavSr36nIXM8rLpjNiJXMAAj1xUB8eY2+lc3Y4tOcgK5Zv4qpMegRMv41TTyZLg4fzxK4WqIJwNcULPRHtYFrCZ7Qjq0cSS5hewZL60N0BpEn/InQ4q9/udx7d+vuFRDmsGjj9DwxqLc7
 aas1vHIB
 3JlGWWu3fYRN8AA+R895Stp+FtYN6ozJMTmvJEt5Kd4F9f20Ys9bHtKhLFke/DbKOeOGLiwmrtIj2Cyu/xAFt82beYJ6zbYpWCnjSbQdHGhJH7gowAP0/yHLP7WtApAIP9omVl/IbEYAUeZ/Tq99mYGTVr04XsMb7GaeZo79L4wi/6P87bmAR5Jshdn/4yQZ+wPXvMycCG86l8PyIT7q7PC62HJgPdqS+XwOgMlZAQErLp75xQQyXiArk29/vec3h5rDEBdXwG7f9Vb/o7sbJdQRqzCeMv7vtEBIVQZNQyJt3vtIJgy5zy4aY/glh7iWSDZAbELKR8+/z1crHvx+EiQ6i3hxEbZoqepQJKhEuQVW0El19K4Cw1ZK0z9iawUW2NbEzQ44/sH0IM+9RbEhGM8jFmHwIvuhgz4G+vDU8FZnl2mylyXufCGU4hGu6OGK1mqkEaF4UsMeSIHbjQy/azjO6rFn5xMPqYr0nQWkhmm8U/Hk5MASwFbsUsOhlBf9QTQBIzHNOlLOAvkDH85VLhwKO8bUMv2FrZRX1r0lkOiAfoG4lFAsD2JHobUeKi0yIiXRguD2uQwdXXVytA2HiWPkVpfsLE1gGppjujPiJ5DG3NuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/02/2026 09:40, David Hildenbrand (Arm) wrote:
> On 2/5/26 06:13, Usama Arif wrote:
>>
>>
>> On 04/02/2026 20:21, Matthew Wilcox wrote:
>>> On Thu, Feb 05, 2026 at 04:17:19AM +0000, Matthew Wilcox wrote:
>>>> Why are you even talking about "the next series"?  The approach is
>>>> wrong.  You need to put this POC aside and solve the problems that
>>>> you've bypassed to create this POC.
>>
>>
>> Ah is the issue the code duplication that Lorenzo has raised (ofcourse
>> completely agree that there is quite a bit), the lru.next patch I did
>> which hopefully [1] makes better, or investigating if it might be
>> interferring with DAX/VFIO that Lorenzo pointed out (will ofcourse
>> investigate before sending the next revision)? The mapcount work
>> (I think David is working on this?) that is needed to allow splitting
>> PUDs to PMD is completely a separate issue and can be tackled in parallel
>> to this.
> 
> I would enjoy seeing an investigation where we see what might have to be done to avoid preallocating page tables for anonymous memory THPs, and instead, try allocating them on demand when remapping. If allocation fails, it's just another -ENOMEM or -EAGAIN.
> 
> That would not only reduce the page table overhead when using THPs, it would also avoid the preallocation of two levels like you need here.
> 
> Maybe it's doable, maybe not.
> 
> Last time I looked into it I was like "there must be a better way to achieve that" :)
> 
> Spinlocks might require preallocating etc.


Thanks for this! I am going to try and implement this now and stress test this as well for 2M THPs.
I have access to some production workloads that use a lot of THPs as well and I can put
counters to see how often this even happens in prod workloads. i.e. how often page table
allocation even fails in 2M THPs if its done on demand instead of preallocating this.

> 
> (as raised elsewhere, staring with shmem support avoid the page table problem)
> 






