Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B67F589D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4806B0005; Thu, 23 Apr 2026 09:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E726B008A; Thu, 23 Apr 2026 09:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836496B008C; Thu, 23 Apr 2026 09:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD036B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:28:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 452D11B6E31
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:28:12 +0000 (UTC)
X-FDA: 84689899224.29.CD8FB03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 608D340002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:28:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGgrrB0I;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776950890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/IZAKE/51Z5Z0tjt7HEHobBy9Qxebs9hgP6VWc7v/M=;
	b=rWolwyayrU9Zd6XLiF8/hheFvNjHD9oLjEqJiaaTQRgrpTHTD3MjBdw7cZVWaIJq31DGr2
	C44DoKZLrL7uQt2vLw0QHZo/b0Nkizj+7LRzyfpaqc5IH8B9kYMOlnig56Wy9MhJFvbfDC
	qoPQIiQ97K86GKSCpGkmQuLed4Irn0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776950890; a=rsa-sha256;
	cv=none;
	b=QFScAOKw0ugkfjot5mE0ZzB7xRYto0/CnXjlyV9Ankxq60/wVtbBNL6KL+SuxYKyxVtUxc
	5eS4julaLnFLJHNo4lR427/iJdZWiRIAresz2KhN4bnzm6zLK6mEE3mK6wg1bs9hzP5erj
	YYY/ZQUsz7vNts6+2UKT0dDsky6SqdQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGgrrB0I;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62ECC4450E;
	Thu, 23 Apr 2026 13:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D0EC2BCAF;
	Thu, 23 Apr 2026 13:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776950889;
	bh=UdQJdVZKPGon/fRA+Ymep9Kcr+GFrjgmKm4qj3xWeYY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DGgrrB0I2oqVS+p8oatAec00Eyrzsv3qWmTOMyFJ9AjOOrxeDn/YwNdYZ0mUlEW0o
	 SkOBQ0RHlMd5wTxJY1b8AzovMzbflW6nOMSTPVjA/4wk1+4rOw0z6Kih8RPlkau8BM
	 mb0wjE3pf5R8Nnn/0quxlIrcohgrucbnWISAXhyE9cDUA1rpoTiV2kJJ8iE81K2NDd
	 Ol+he5di/FMJSMlBV9/JMlKs+g397OwEYSm2egp2vgSHemIv6zA7cPU0VS4Q50c1Bi
	 WfLODRTeuC6Xjf/GVQkqh6y9pfc1WJrjBGmBhH1G3916dDnFjS6ybUZQ3rYp3lq/s0
	 QolPJ6q9bXNfg==
Message-ID: <da96efa9-401d-4d11-90cc-00ebff340921@kernel.org>
Date: Thu, 23 Apr 2026 15:28:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] selftests/mm: use pattern matching in .gitignore
To: pratmal@google.com
Cc: akpm@linux-foundation.org, shuah@kernel.org, yosryahmed@google.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <03a23a7a-58fe-42f4-a294-9d688ce33e2d@kernel.org>
 <20260422190847.216343-1-pratmal@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260422190847.216343-1-pratmal@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k9jq35wqqf5que8j98bx9ywwm6gbfpzj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 608D340002
X-Rspam-User: 
X-HE-Tag: 1776950890-848636
X-HE-Meta: U2FsdGVkX1/LTYQK13FphNphuSPR///tvHWvhU8o98IHWMqyx0RxtCU+PYU7Z4d6m8hXUkgyWdpmhL7RaN5U9XoBZNnBtKyOm+OqIUUxtUZ//s3Cv6eKJCdPnLMn/ZNVLAFsPbtC49o7xa7PjS318GGfT6zMQSb73EY7+GXzpTDqbO0iwU5RtjGRCaHUWvqRjCR7hnt2D2a75IIpCa21HPv8ZLSvvuKyOSE6HihLC5QvsQnPBiZG1e7881rEnmzM/J3iwjvqO9FkYYtvJ1wQPjDDaXapWKO/rMv7qOYYzXHRGomoDgelFhhNsvxzUay7dRHZ6JuFWQir6hjOBam5OCECdFcs/PlNgrz74iORuiFwjFwzqm2h5ekK9XC/5Klg1l4v/RDHLTz4FylFjtAhait7QQZrxdNGxFavHghPzfwFAoHKMuSui8pYvSfTgnyhKmSBaIyE05pW1hRmqOH+vSPIYW0ydElZnk8AoYjjdCQCXRvVX/z1QrFwMjuJm52tAd7nijEHm50bCsovAqBJK4f0GsbOImzhcc67G+Xbe+2xuxD+fqAh969z+PNUQKU3FlAzOHDEheJrpFIAqpdbbOHLx4S8nPjmokBJloFECqjOPZ7hiTBnaXEni8/aFiJ6K7JoX6ntpB2K45yrQVabw72zwg6uZqNDdrsS+qu+y7OceCRCPo/JclUgMrWLqKZ50Fu1ZU4iYmUs5aNlVqOHqDvzaIg2Ln4cAhDp4+shxITYy7iR/RqWtdrEkdaO2T0gprhPMzWoKqv8nyTC0/wbJvcbsFQ5K+/4L+tYFOti1/tSAdkGarExO2tgMpld4d7cAZnrflYSIu6cXnPlehxqiEiAX9xV1vINiYMve6YdPGV65mR2P0zgX5P2DGKp/FPIaOOlL/dWLKkVf6vM+npFjSlDxWUIE6ERMsOGYAXgFyIG0aab1imQHs0D6Vj7PHh4SHwOEE8suKvQP7+1xDw
 0mWnh/ze
 abTLMzh8u9hJF8IywXhAHnYOrhSjD5Uk7RWThy9cnfGoVJh1iwa0np5OTctViEUpPU3G4jFlyq+f48DqOVDeKXkQ0cyKIYuL6dLWKkeplk6cpZVFVl8uPf4vwTaVF/HraJMDVShoiq5OplYlqH55tqf5i6CuAQfXDzdD4BjrvoTMY759+YJql1V0inpjS31La+vUfoWr+NHqWovR2Oy0neuxOWxfw0bd17hrv+78uZ8IvHc8fFMwVOdl1r5XqlLTDABntM/6T+pl743Hpz9BI2avADZR6XCC0H+R2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 21:08, pratmal@google.com wrote:
> (Resending to correct David's email address. Apologies for the noise!)
> 

Heh, no worries, I didn't even notice.

As long as you CC one of the mailing lists I'm subscribed to, even mails to my
old RH address will still hit my inbox.

> On 4/22/26 18:04, David Hildenbrand (Arm) wrote:
>> On 4/21/26 20:30, pratmal@google.com wrote:
>>> From: Pratyush Mallick <pratmal@google.com>
>>>
>>> The current .gitignore hardcodes each generated test binary by name,
>>> requiring updates every time a new test is added.
>>>
>>> Switch to the patten-matching approach similar to KVM:selftests.
>>> Ignore everything by default and then allow source extensions (.c, .h, .sh)
>>> and tracked non-source files.
>> That looks pretty nice. Any reason for the RFC? (iow, are you unsure about some
>> side-effects?)
> 
> Exactly that. I verified that the build works fine, however I sent it 
> as an RFC just to be cautious. I wanted to get some feedback in case this 
> might introduce some unwanted behavior that I'm not aware of. :)

After taking a peek at the KVM one, I think what you propose makes perfect sense.

I do wonder, whether we want to make our lives easier and rename
"local_config.h" to something like "local_config.h_gen", so we don't need the
"re-ignore" part.

-- 
Cheers,

David

