Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49EA9CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823996B0093; Tue, 12 May 2026 02:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4316B0096; Tue, 12 May 2026 02:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3696B009D; Tue, 12 May 2026 02:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59EB26B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:25:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20F70140389
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:25:41 +0000 (UTC)
X-FDA: 84757781682.13.4C4BC80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 72D931C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:25:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPJcQ42l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778567139; a=rsa-sha256;
	cv=none;
	b=29UNyODxrng5Uq+yDK+i5axbrqV9jPxIOYSBx4VopIljhJhbOn7PadCHelm6OIkzR+CN97
	yM7sfjy2gmQQx6lA5vFIY/UDcKFIDtyRLNDfIUJJbQj/eq4Nlf3rhMP1zokbZNgvvHtnlu
	Yc4GeKiii50z/46pnVNfTjLaRluph+o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPJcQ42l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778567139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1acAZ/Sh8ScpKdVt9NyUqWQyZ/FLoN5Ha7ECc0GdNA=;
	b=sHt+invU1BCY1KjDD6kpDkbPehlPY8FGpLtlOyedRS/WaPhQY6pL1u0uX2bIggybwiP1OP
	kV855bAgnDuTK9pR1DycIJTeDCRgF2hg3WM56Z5U5Q6JBD51iGOPIPANiHCSktKvjbtxvV
	CB/GULCP3NkuGYLt2vDTJkQMAfs7jEA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C55D060123;
	Tue, 12 May 2026 06:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390C1C2BCF7;
	Tue, 12 May 2026 06:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778567138;
	bh=bvbc8NXu/FH7JnxQJ63NcUmUspxbFGn5COPiYbadr3A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KPJcQ42lqoBcaETRv9s+IzNGz//Ivc3JXk62CLGniVddCcT7ZanylFrpu5HvNcC72
	 8YEE0SbmT1B3xZ4lA1+2Qsjkh1eXEslJ/tY8CMEED1WfQJQ14v9wTsLocbwC9h3gCL
	 jccrj5ez6EJPBy2q3LVN/R1TErMfH+SvCgv2cpqkH611/p+ILQTxG6cVhb0ucvazyI
	 F90DLpobyL8sA1ptsK1UAA3yb7vOWSkrGWgpanWP2o/5xSobicfFs8pvRks7wYEXMK
	 5dQVpp0DW6QfrHV0VstIURYs3Hxu6a8pKNDYl/Wc2Wo+kLpw1dZZjii2Jp2ju/Itia
	 HTqfliANKU/Zg==
Message-ID: <9171623c-4775-49e9-bc05-3ecf1a81c7bb@kernel.org>
Date: Tue, 12 May 2026 08:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/memory: make memory block get/put explicit
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-mm@kvack.org,
 driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
References: <2841f424-580c-48c6-bb26-de30e4397b7f@kernel.org>
 <3234B4D3-8202-4E79-B85B-8B6373BB76F6@linux.dev>
 <E9BB5FC5-0785-4162-8D1A-2A51C7250B34@linux.dev>
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
In-Reply-To: <E9BB5FC5-0785-4162-8D1A-2A51C7250B34@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbm9wepjo1xyaz5mx5edmg7w7i1gxcjb
X-Rspam-User: 
X-Rspamd-Queue-Id: 72D931C000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778567139-783680
X-HE-Meta: U2FsdGVkX197y4cpBdp8ZVdFy5Sxq6MZ3LmkwccsxPmcIafSCg59dn6e7xYENbkjvV3WdnAuNjdCQKrCkelTHJBEKC5OEecVyJPlZfv/CcJPdfLqWtoq+WcdWoKW/8DJxt65NzxTRRyyOtUJt/Qmb3cENuq/vwc9JSyJB8phvtPW0FxlhyASRerdM1G2QSSr00aaBvgpM/7hCbpmGDAKU9B/uV/yiEN4p+tw5a6QK5Tf1oqPEcZRQh3n9C8pweJn2ATAkBEJtt9JT3aNBNU6ShYOp744XSpBQMQwymfFfduLB1bVGlb1vWe5zTJcUp6ugkj6t2KFmAWkVOmf1oprHxLCzhjP8Hz0yrED8Uozy5+qdzNFc/hRU1EV/lmhc5BOFjRO74F7nmYQHKoSuFpll/dXJDapahYIHQEEH59xzrZXmZLheMgbYKUDARAcjSZ1X/5XsOSHVn2PN5O8UiJUaYAv3cPv5Wi9uBKSgnegb8Tiact8DIpnhClxqfLq3Z8LPm48jL1vicbgBo8WNZn+Cx/IVdSJTCn3osgExWTZGlLKPc+2iRxibWzZBF197ERBKgLvSqb6vwkAp9VTv4iK5L4yojf6A/3Cz6bIPgq+H0Xluoh/gtpT2NB1Ay902dWl/qfwnrrZv6yW4wtZe8dvrIz1flgj3xz6S5TlrQ8ckOTgLY/U/eUQ7bRUUWCeIVT1+UqzpQb22u10brnhVnyHHjciDmSbD0ToulMvJ96yow0rt8eFCzQsgua/a+mcY7lNEjqoccIfbn5P9GeY7AD7Pon/wrgcE+ZAWCmC5/GGhajxeKC0bBYlXvKWOFvnBeIVXT+chb6ibEMV//juAYhwn1agS56Mo0jMD3+HpnXhaakq0q6MdCtPIVJMwMRLSiBCCn2VfHfdlA2GTCC2AQ9LoWuCcJLxbe8YQj0PPyeFkxTOSqs9qPkZhwpKqhW+hP49LY0FmOFAz1MsYUwV4ZL
 iKX4kIOd
 lL0mUZjM6EYuERHZ53rNzQWyiBGL9iyJN6R/wzFdCeKZiSFFaHQfamGTbIwO0OD2AORp/0llby6/noQtfqF60cnwahmEOlaSVO2Rsq87JQLo6eeN73fmDHXB/RJCblzeRh9vPlFDvT/4+oA5b7rORlSwgs8MXviGbaQRIEJ8rWhxYmJORYEVWCuz9DAyRlTi4UQBL6b/6q+MNmi0655AQh0m347w9DN5s/K/HZrO60UPzaadZ2x3H80d80vgStG4PZCw2Z778s4GyFmA8uyyhBBidXFul7wqdbjNf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 05:11, Muchun Song wrote:
> 
> 
>> On May 11, 2026, at 21:23, Muchun Song <muchun.song@linux.dev> wrote:
>>
>>
>>
>>>
>>> ﻿On 5/11/26 13:18, Muchun Song wrote:
>>>
>>> Better mention some of the other changes here, like removing find_memory_block().
>>
>> Will do.
>>
>>>
>>> [...]
>>>
>>>
>>> While at it, please drop the "extern".
>>
>> OK.
>>
>>>
>>>
>>> Would guards come in handy here?
>>
>> You mean to introduce something like:
>>
>> scoped_guard(memory_block, id) {
>> }
>>
>> Right? If yes, I will give it a try.
> 
> Hi David,

Hi,

> 
> Did I get that right?

I assume so, but it's indeed rather ugly. ... in particular the CLASS and
scoped_class() thingies are pretty intuitive.

I thought we could use guard()/scoped_guard(), but reading the details, it's
mostly for locks only.

There is only one users of scoped_class in the tree (overlayfs).

Maybe, if we would do this properly, we would actually provide our own wrappers,
like

	MEMORY_BLOCK
	scoped_memory_block

not even providing "memory_block_get", as that would be implicit.

Like

	MEMORY_BLOCK(mem)(block_id); // the second () is confusing
	scoped_memory_block(mem, block_id) {

	}


But that requires more thought, and I don't really know what the best practice
is there ...

So thanks for trying, but let's leave it as is for now.

-- 
Cheers,

David

