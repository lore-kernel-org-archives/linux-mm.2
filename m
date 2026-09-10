Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50FCBC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE356B0096; Thu, 10 Sep 2026 06:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36EBF6B0098; Thu, 10 Sep 2026 06:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DB86B0099; Thu, 10 Sep 2026 06:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF6BF6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:57:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61E701404A5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:57:12 +0000 (UTC)
X-FDA: 85197550704.18.9319A42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F00840003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:57:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eK8zViyI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eK8zViyI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789037830;
	b=5IvTwNC2Ga+cTXhF+drr2mtTnoPRAu3AXNVsnWdadTaWVQMq+MPQ7se+qUzlNwi1Bgcnay
	q+3WnF2JXfOCgOuz5s+jPrUi7yChsDdoVaIS9cHx/HvLeYK23WkaBWFyqZ/O6ziNzu53z1
	Es/0imghDMSQ88D8gH5SEslWx9/u1tw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789037830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxlyEAD3OjzkL84LXM7QY5JNpJtiOF5Zyguxd2EmB9s=;
	b=PoAx6qVW5sg0eZAk2NWxYRke9ya/p7eg2kYwXj/rNzz+VL622QZ0VmsMKFEYdSWgCjeMDJ
	ChuRY4dprzHDhN9WwWO/sEApBlqz40WDEfa0ZoNG/XFCWPv1WHPrkomH1DgjiKTIUGsPhT
	WYgM4KGfrL3RiHS0qQubnf72w5jb/QY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82B6043E23;
	Thu, 10 Sep 2026 10:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBD11F00893;
	Thu, 10 Sep 2026 10:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037829;
	bh=GxlyEAD3OjzkL84LXM7QY5JNpJtiOF5Zyguxd2EmB9s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eK8zViyIm/bW0+IG/megvvXAxtIOAaGbbA0fXts46bTz2Ah3auqf2tX9g6vhwKlQG
	 oK7093vyOD0v6JMIWihPbQAbYKJX4WDIBaErdJiA7WGxfdwj4YLTMKLWylzHSskruX
	 IPNal/2lHXurLSF3Z+IWE0cQk3o2xs4Bi5jUSG7ufNcw8EmGp4dCFLaWv28ZF965vu
	 JNP7Q5hdqlha0dYFpTJv5w6D5RvvMoaWQduNtQP7puWp0H1By3u/FOFSKzeYxeEL2h
	 48EdKDIn+oz9XUmzGq7/S/AQlqJOqbyqxqY9ezMkf3BCL6yzH+frRR/qE1dwI6gMe5
	 njJFo5DYT61nA==
Message-ID: <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
Date: Thu, 10 Sep 2026 12:56:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 YoungJun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, =?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?=
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>,
 Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-doc@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
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
In-Reply-To: <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F00840003
X-Stat-Signature: akgg7huf85xhc63hcipatrahatheky3u
X-Rspamd-Server: rspam01
X-HE-Tag: 1789037830-383414
X-HE-Meta: U2FsdGVkX1+nGDqWmkuUw050s2lRIpzGo+im/1L7PiZvg3d9PX95FwFgA3VlbwLxz1uxx4Rr9gk72/vE2n7O4cR3ogyX0YitO6wGKL3JYpgqISk0x11v7QFywQ+SCv0KjVXvA5sj/ry6ML1F0+bnwQ8sD4PXwcAvVTn0agtlkNIbjurmSj91v8PgpK/EeK/oh5iWO5Db7PsVm+necdScU+JBmnvoz5DY3UB/VvDEoXPf99f2WfHCh7oEw1sGShIVnk1bTDmCG2nVbFB+J/SIQ14R+kEO5ccUveFbSUFJWULOwTIkCqHmt7iTOrQ/b9BSzvdXYWmytWScHEoP+SDSfNyINGu7roojp5CkXt34yeFQnv2itZ/Hx21ZVQT+ELxe9S+B+WkDmvtQ60xZtiFduPW0RjhMIfuZwPlhNv2h9lLUwoff24fIXJCZmSqL7kOSeoMuOaFq1X3jbICK1pEnXvV1QNV12mdR/w9raurylhpViRMLkfD+94WukgryY6/pk+cm9Q6L4e6neanb5T0q7HEdsIkePhOFCSLY9w2Y0EBAWVHxifS5dEGCuJcvq5FzeFtiIQmfsy+3ewywadoneYEcxwJxnMebkXZxBRBZlQ1/Az1kjDKyXLa7KQdpPVECuY99UWVv0iN2M7qWb/MUAQ1rW36mb/VC41fdNzUxL0KR41d+UROA4nlbDkkI4v2SzvD3hyuL/9kOcxAbIiCjulUKlFbBBKlOLV3YC03TEwGcsJZRYgdTvpHGHWMe9feqkbs/WM/tbXC/PYRft7FBsdddjwZ0dmq/F/T1+kHa+uDXiD9GM15HJ7q+lfWFy5iJtemhMxIkKDHeuGAB9UpY7Xg5563PBWl2i0gxt7a0c3HaLvS4UxDX1lDwhJBeu/ALHSWuV4aUU0TD907W6A7Zm8Kha3ZsrQJYOO2v1yoWhBjkm3AX2P0SFgmJkspxrYhWJL7s3QXyUh2BGKPGxep
 tQAqPefw
 4aoWywDtawSBV/SXlXBgpWUa/K0HnjT1vMnsSCsfBuNDV/RlxQ70bgCqIeKPhtrsoN3E/9EmSt+JsCpZqcy6ANouvlSpGOBfHfFDD162j5zhR7GBhTqgHbXtrHq/Wu8xQuMFQIsgJv4RLtx1kwMaXgzLsh+yNoLuw8sz4kVbDYq8exNUFpy6ist7SAOkiGuWOvtU6nQMdE7t3iBa5/4vEFcdyz7BYlj2fldFdXVioK78XhkKE8SELoOXp6N2yqvCdLO9yICiK6W5TS315urPsGOgWW64pYKi59ZwZ500erQxEnA1LLR4sPlFquUfyyORVLkOHbmd/nKudwWOIegWGFZxKdg84l5kaLOhMR6ChMzqL6diB8BO1Avz8sw3ZDAnH0bVSWWzao5vjjDHqjcxZrOOp+qBWT3DZn8TW628sPBgGqAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 18:45, Nhat Pham wrote:
> On Mon, Sep 7, 2026 at 4:30 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 9/4/26 23:14, Nhat Pham wrote:
>>
>> Hi,
>>
>>> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap folks -
>>> I need some help here.
>>
>> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we have quite
>> some swap experts around :)
>>
>> Reading below, I do wonder if the swap subsystem needs some more coordination
>> and collaboration?
>>
>> For example, maybe having bi-weekly/monthly meetings to get everybody aligned
>> and uptodate could be something reasonable?
>>
>> This approach has proven fairly helpful in areas where (1) multiple companies
>> are involved (2) many concurrent development is happening, and (3) people have
>> different priorities and requirements.
>>
>> Is there already something like that to organize development? Should we get
>> started with that?
> 
> Hi David!

Hi!

> 
> Thank you for your suggestions :) More collaboration and communication
> is definitely needed here. Conference is a good place for this, but
> it's not something we can do very frequently, and many folks could not
> attend (visa issues, etc.).

Right, and conferences usually don't have the capacity to squeeze too many
swap-related topics in, so it would have to be side discussions or BOFs.

> 
> A bi-weekly/monthly series of meetings sound very appealing. Swap
> contributors are very spread out (China, NorAm, Europe, etc.), so
> coordination will be tricky, but let us figure out something.

Yes, that's an issue. I'd suggest swap maintainers take care of that if they
agree. I could try as well, but it's rather tricky right now on my end ...

As an alternative, we could also use on/two/ ... slots in the bi-weekly MM
alignment session to talk about swap. (I'd be happy to learn more about all this
as well)

-- 
Cheers,

David

