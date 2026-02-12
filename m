Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27805EDF04C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589F56B0005; Thu, 12 Feb 2026 03:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536EE6B0096; Thu, 12 Feb 2026 03:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4142D6B0098; Thu, 12 Feb 2026 03:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F47B6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:30:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0DD9C27D0
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:30:38 +0000 (UTC)
X-FDA: 84435133356.01.C824897
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18FC910000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:30:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UEAhPZML;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770885037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUktSeeLS5btGx99d9uAZcP/e4K7b4IZk1IpREPWIbY=;
	b=XraNjGvMQ7ueiGsUSf/x76UzKRK0wI/GeQDvq+e35onIV0SRYfnG7tg9vqfV3d1u9seaE7
	9pBlyCkv3xzHots14NzaAXS8FNQPZEyzU8ohG6OOZVMJpvgOYh125u5Jvqar6djw0DKJGR
	wC6CsxlBbbWcplAQv7IQ6ApEsOGijE0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UEAhPZML;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770885037; a=rsa-sha256;
	cv=none;
	b=EsP3f+eIyN8ncQjABBG+4Y+P13PxFRYDlo/mvvz9U5aLR9Tp4ITFahQibRYPMbYeARo8rf
	Cj4sgA1mcJOSmrV2am4R47ytAlqJBOWCNi8ylnXC6KfRyVOF68e0pd5b14H2dPvp6cy00a
	ZtaKbNTU4IfhUzDdKoogJ30xxlelApw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 67CCA60146;
	Thu, 12 Feb 2026 08:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45E8C4CEF7;
	Thu, 12 Feb 2026 08:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770885036;
	bh=4zLXuYnKQ5Yz6QAg4xbE5rU++0EKg/JPquSPYj5G0TY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UEAhPZMLtq+uTiqQSYHrGYDULxF09uc8m3LsLkM22kFocGEuIsASqr/I+mjui8W/Q
	 +pdKORcEWcfyWWznojjTavOnE1OF1MeVV4YgB9QFhUDy8rHhW9A0QNF1W9w//XSfMG
	 w5QKczc2WF5mK+Z8R7GW5PMdrYQkUcvW5FDTQEevZJRlJjy7O+CHkLbSGfS12Sk6+3
	 yH595OGQMjltkiRMSivm9rm8AJ+g9jiQNyckfm18i+V4BiLCY/MGpXsiMkkhS8OD6Y
	 EWt2+ezJe/u+kbRBGGD1hcvDV/AcukAjQ6NHPpOhxiqB9PktZX5KXdOFG2zBfug19P
	 Fr0QJHiyCBamg==
Message-ID: <0787227f-c707-42d2-8f57-5795ca19a53d@kernel.org>
Date: Thu, 12 Feb 2026 09:30:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <qk555c45mchdhz2ivjrrva73gja2d7uny4tu7qx2f6c5rhanhu@llk5m5gilog4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <qk555c45mchdhz2ivjrrva73gja2d7uny4tu7qx2f6c5rhanhu@llk5m5gilog4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18FC910000A
X-Stat-Signature: enp67bzy7fx9c5u4ksdebjjtt46jwqad
X-Rspam-User: 
X-HE-Tag: 1770885036-350517
X-HE-Meta: U2FsdGVkX18Wm+9ibb9+UzzJyiy0stCCSktsmBcVxOpJpL/85nIU71Qh5EGp/+a9WPTblb5gEfrBlSaJWP1DEsrXOI6U2K4NVecgny4XwRgcgADbCKcHUmn9TDrLTJ414ieSV+NFIZ93qhiw7bxL6q/U1Rq2jxHqySqoa91UD/cHMXMmLqn82vZBC0JugNzDqC28x8FKtGucywh/jzAbvy/NzZ0wdGz1IM7z0InFWNQwxmLZZ6IhmDYXzjy8NNwU38fl2vS6LVNcN9XgYyClmIJg2zJ7hoxImpsEaySdHNUYODXDZGrLMtYVSzlOVDCwqXUsEMiy+EauRqm6qTDrHz1MbOhSm7e8QbvXYgHcno/KccQaxy8f8SGYKbyqc+pn7zr67qjZ8TmNHv8+Kedx29mRabzhSMHPHf0TuympvN5f9X4+AlBcGUaSSRrnpRMdjrifgw5SAOspGFxPWRgTzKr2Kei9k31MkdI7j4D3/Yu7uHAxYzA+IcKX5BAQu/ZJNGXRVjjdOBxz97DOXkzz62neDWJfmxflNAmmRqhtkoQnjn3RbAFaO3VgHHaSGhUrAQ2OGE7NjutVTOKiiTDugWS7GSbDw0oCw+/6rYwcynXSPtAqhI98nFElCIIoKZZQS2T9hUgKIEHESYZPANRLrline9tdnAO7G8kjdx9zqip69tQ+5UsUh0+nj+YaeFDjUmLrTkOaQyorP2TqNTmU4BaKvQ71PCPel7/8kcQkGkSLVqtgsjSsPkjZdYGD5o3t6uJn17BJh+dqyVLmLck9giFLfswajfNlcxagqz6DAKLxNslFD5yOMoqYIg9Vcz8cgBGmAjIW58sEn2giSdyzBiU2NWMBfX38forgu5szvjzuBNkkz9doTEHw8hqgJlswDLMRyiu0hLfKQflpvHKktae3XIFVHbtWu/y0btzt3Jonoyuydz4DpknBfk8eMtYY0chS4CNcqYIw/PMoQFV
 9Ui26Jj1
 cGSh5OyRJWK+mPeVOFzyes/hjru3zTE8F+5iIeV0lhFTBLpdnT6/vcIp7/eUf3LsMCMyaX0rl4TR/taCSNamXb1oVkNyAOZRZ6fRgrrwnsbzjZiWdodsXhCdZftDXVW2zo1uXV8iZipE4jR518EY0fSZ5LdCYCT9LJAnTv5tnbdEB6c+W9QN2qV5S6NQ8Ts6W8JGqfeBnl2WL8/aVHNvhHKzqd+FenXOg7tVmQgz9wnoRH52lE5sCurrDtbg9ZG5MeZmPj5ZcctsMw/aZEeOvxnSn1wFe2GbaACDO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 02:50, Sergey Senozhatsky wrote:
> On (26/02/11 10:50), David Hildenbrand (Arm) wrote:
>>>
>>> v1->v2: Actually pass "cc" to hpage_collapse_test_exit_or_disable()
>>>
>>>    mm/khugepaged.c | 22 +++++++++++++++-------
>>>    1 file changed, 15 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index eff9e3061925..d32a5ad27097 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -392,10 +392,18 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
>>>    	return atomic_read(&mm->mm_users) == 0;
>>>    }
>>> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
>>> +static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
>>> +						struct collapse_control *cc)
>>
>> Two-tab indent, please.
> 
> I initially had it like
> 
> @@ -393,7 +393,7 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
>   }
>   
>   static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
> -						struct collapse_control *cc)
> +						      struct collapse_control *cc)
>   {
> 
> but wasn't sure about the 80-col breakage.  Is that what you meant by
> two-tab indent?

In MM we prefer

static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
		struct collapse_control *cc)

		^ two tabs

Because it's the least ugly when you have long functions + many parameters, and
renaming the function/changing return type will often not require touching each and
every other parameter line.

-- 
Cheers,

David

