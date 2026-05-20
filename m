Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19288CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575B56B009B; Wed, 20 May 2026 10:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54CCA6B009E; Wed, 20 May 2026 10:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463366B009D; Wed, 20 May 2026 10:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 383F86B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:43:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A7B51C102C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:57 +0000 (UTC)
X-FDA: 84788067714.04.244387B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 539FB2001B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INmfzZV5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288235; a=rsa-sha256;
	cv=none;
	b=8ThRAa7BRvB/uJjf3KgtHLsIs+7v8je94iC9L0CwYuYzwF/gxTgOF30Idk1jeT8s45gCLm
	v3bkrHesqvxUdMXetTmEA6mc9gzm4b+eTVkqJb9lcthqjd5gxQu6PZy6M37ub34/9z9wNQ
	K1wRvCBLdr7VPo3bLSmMAUBS8uY7D/o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INmfzZV5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUdrQAQB/HJsFGfTI2dZPJKRAnf4ht+xn2s1cwE2tHg=;
	b=4YIWFwnqfhBT+kG73pb50iYZYUA8o5i/5vQOL1QTwFJLAi5l2rMCN9LLu1HSwwFBCL8RA8
	R0wvAxpF9jZuu4u8j/Bl7Z4O+9cTbbYL9fyK51LYbyjaXXvokkLikfmwHmqNWaROzxPy4E
	BPQj1O+uO2W0zNRqZb3SqW0ywdocDnY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D62C760120;
	Wed, 20 May 2026 14:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D501F00893;
	Wed, 20 May 2026 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779288234;
	bh=SUdrQAQB/HJsFGfTI2dZPJKRAnf4ht+xn2s1cwE2tHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=INmfzZV5B/9xxwtwuI12p7ftifSJzOrQdBy13Ng0dxg63l/UZ4p6efZxsbCmDgM49
	 pBqCiKn1eaY9Rg1ZeAbNHw/YBFMXxhc8PT3W7YcsUlJfQJVu4m4JM5gQ6i4nNVtaE4
	 jR5/V8sKqt7HxCJ1nrKX7ci9grwpxwSDcyTopbZeAq63YfVoC0Fk2vYf3Buhlhs7qn
	 Hfs77CREe4zG26rz0Q1vJVKqPXntUWA6CH1eXVXcECirqkL/J4cVrniI7HtaRAiJJ2
	 HuQhXLCdyXcKq8oTSq2fVutHE58vrWPRvk2hTuMEF+m2B1UWOKEIxKRoTuUqolzRAM
	 sGVfGx826Rm3Q==
Message-ID: <a339422f-af4b-4dbc-aaa5-0a152c20d64b@kernel.org>
Date: Wed, 20 May 2026 16:43:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v17 03/14] mm/khugepaged: rework max_ptes_*
 handling with helper functions
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-4-npache@redhat.com>
 <4566170a-7e3d-49e4-baab-ba2790c198db@kernel.org>
 <CAA1CXcCD5ooRJonAVp2LvnoCrQwcs1-NsAYomXbHTVNSe5X0cw@mail.gmail.com>
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
In-Reply-To: <CAA1CXcCD5ooRJonAVp2LvnoCrQwcs1-NsAYomXbHTVNSe5X0cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gcp8o1u1pspmtx9t5t8sipxhynwd46a8
X-Rspam-User: 
X-Rspamd-Queue-Id: 539FB2001B
X-Rspamd-Server: rspam07
X-HE-Tag: 1779288235-792945
X-HE-Meta: U2FsdGVkX191o8njpSE9lTRWVHWOBw+PN0UEu9iHeqjklF9iYPpAYYJYL1hz0pbE3iAnobYGt6UQBz9H32O6FTuRwlVRfRykbJSYrQD0yTr1ZhjRbRR8l+OYDXTlLWFUf+6nrnmyWkLieamB1XOVsgBmOSZqRhjAMvuPJxP/FeGGsGPxp5my4e62gGRr1yPpC3PvBonWklTv4Acr0hEetUlz1iJtQiCuCEvQ+WULvw6SkiS5iS1GD5moqbkpRtubLE8gn3HEY/ejH20P8Y0bG7gIvqWbk8YA7nM5wT/oOIN2ZAq1lbTHK/YS8XVwZj6dUvEdZNYdEVq2BoqpittAZWfnnufj/a5HUU+/2WH+i/O4Ukw4EFlARznrp2T+qHPhlra5h3bQrLoENY1jeOK7VrFWHOfqofmFdRJxC+Rtch2y88632u9NnEqXfRociVkUAeiFCsHd5i6JIkmtN0zTEY3PLq4ye6C/KhO4mEDmzpd7vCZKG77QkF8IJSYNzSp6w17hY/1UPtwf5CQmLg7U5ft/fV8zmUTeDoo4UQN2nJzeKWNBxrYnu7rBGLwq/tr6yhxwLhBaevbvdibZ0qqtqisbBO3z3fF1nwBdCjQgczEy9Ty7XFKJ358fao21SAXpfZYtjGhTjOf+EQfGFIEdWUtx8toAjGJ4Mq7O7QcVQiumS7+q7EGbYYQB0Pp+v1cDnWMtfnXl3OksckMqG2RXNS5TKT67USF0BguX615TOCZB5J7KqixcJYWhCxlJapla3npZjxYQPlDjkfbkGoQHr/a3lZV88xjJ0AYs1BgUGJG5ylV6UNeH1vJAr6/fWvFuYhSi9QXw1ygflXz5yQk7Ujqa/Pq4pbvRjNuMltWOS1XIBrbLtBY+vauwJHElLF6EVtELwukqogVMgmdZPJZeHz0IH5VR/Bod2YQiLsper76RX+yDBE+s00ocF1J/sPwPDj7GMOfRN4rGlX/T8ml
 Z9eLU35B
 R9CmDuRTUX/qHaDYH6BtBGiwgnWw4R7MPYXPYQy2Zc52QYS4uZXJQrevoGpkQBnJGpjIePByWxRQQlY+FSuQsATBpDDkeefWkINdZK//spqF7O7mMK7TvEQoyWCNdO/pNv1nCesi5PeSBR5sNRM4UIwDEgWkZl543JOGTsgWKpl0Z/9vTu1nsj/qfaUI+jsoRMuUBJyd+GDUbE+QjtAkCavLbGTFkRQLCZz6OyRl2sFFgODThr/8m99Axr45JPbeFi31hHTussdP1oLeyThpEKKN6bm1mmelal+qw62m6hlObRt+yXRxx3qXiKDWF03Q01ocB/jAt0Op9qn2wqq8C1Rfb+DURTgNmHZssG0NUoVbLVxfk2NcAwGi++Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Calculate maximum allowed empty PTEs or PTEs mapping the shared zeropage ... ?
>>
>>> + * PTEs for the given collapse operation.
>>
>> We usually indent here (second line of subject), I think. Same applies to the
>> other doc below.
> 
> Hmm tbh I couldn't find a example of what you meant here. There are
> some that put a space between the first sentence and the @ list.

Yeah, we usually try to make it fit in a single line.

But nevermind, leave it as is.

-- 
Cheers,

David

