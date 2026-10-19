Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A7ACCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2C56B0207; Mon, 19 Oct 2026 08:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AC76B0208; Mon, 19 Oct 2026 08:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C907A6B0209; Mon, 19 Oct 2026 08:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A243E6B0207
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:29:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 493471C3F8D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:29:01 +0000 (UTC)
X-FDA: 85339305282.02.AFD7553
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 83A0320006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:28:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sl1gAzkP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792412939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azUhovewsmaHkZfdUWAJXYS0yUQMWLtB51CRPqpcM+4=;
	b=hEpggxT5TqH8JPn0DS/PXVgAPJAwyCiHbAIGAo9Bt/SCviHGysnm/Zi0u7N7pHsCpo1aHD
	TR6nZhEn6hRZhre2vG6ZyyvZRpauAhtDLdQzF8qRGAbD+RuY3vW5KvmKHPp4TBqA3tSEUy
	1kMCib/4RtesmHsy3SWXuyNbZQi7fws=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sl1gAzkP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792412939;
	b=Xm5lA1dtLFMcUyveJCXkS1xU0mC3sS81FcNMcdUvvSQ+GuwlzhIj3OchoVxycOp1Uoef/C
	MiDKWY3IvkyU6bHKCophtDkK2ZUjUTao+hXAF8a8/SLmDnzKRCoTQUIMNgkpvdZfLrOuRg
	aVM8a46HM9kh7JpMcvPotXYa5uSKSHo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 035AD601F9;
	Mon, 19 Oct 2026 12:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A2C1F000C6;
	Mon, 19 Oct 2026 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792412938;
	bh=azUhovewsmaHkZfdUWAJXYS0yUQMWLtB51CRPqpcM+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Sl1gAzkPIb1EntnvpPx43UiBqyTreS0syUnRUugG0FQas16qP/eY5Ra2FFvums2Vs
	 VPNi+2dxsrrb4HuP9wwv5zawauhmu+pioQKlviZFHwmpB3sNfuVKOM7BU9r/BVMytY
	 iir0vQnc94LK1BYxA9VdDwvhYzOWMaq40KQEAwSHtcvyvxOiIlE/RkHTSU78JG8Qm3
	 4iK6liascc/n/eVnLbFRLOxRyFJhlLHDeu8MiMml3m1sH1qbXcdoz4X8pyShtDxy0d
	 KyH5XIro+Zm9XYCegZ8RJTqOYTpPE/6P+yQGEZ4/Q7ST3Hh//jZ8H/6VZ4oYUoQkQX
	 7HEUsMExODZbQ==
Message-ID: <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
Date: Mon, 19 Oct 2026 14:28:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>,
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
 Joshua Hahn <joshua.hahnjy@gmail.com>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
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
In-Reply-To: <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83A0320006
X-Stat-Signature: rycszg7ztr1dz7a69ntoz6c5urghmzqp
X-Rspam-User: 
X-HE-Tag: 1792412939-4899
X-HE-Meta: U2FsdGVkX1+//TRMLx4ztPJYqGEpFiQzfp+jiIWAL3st4o/6COVoNVGKQAKmaruseSKbVl/cfxvnGiAn/HZnLeBMj5AwA7H8uXtft4EA+e7JPDBNBUpLJdBBuraQ5584pEFtEXFRJw7Jr1DR7f3DbOzOsEBnCOmzQR8k3GTAGTZg2l42OngzmZGK0kaw5S0Muz34qceL0vBxi+iSgScgXEaPnGfzxgXJapyF1lWwKoHsSFB/NgY+AVGbK556baXwc46UDEZ+1rDiE3EyTH4IsgIS2pI1Wj3Ls9P24xtTqBt8+5HYry9QI/cuv89SKxyslx7zhRfBH+N8yhhFOXsYjH1/H/U2Bgn0lcE851OM41ThdWXb3m1KufBcFOvRbtN3N9vT+wpStKl3CP4n5Dsimghllm235mUOAw6W93LD2Hxpy87gwSzZoVrqXkozwlby8G1quAv8ylBvEKS9ZmFjM6pc6gXoC2BIlR2sefVCXsE4Zyr3KfV9y1JXXKIjBdSxRmkRYZ09LejvKmwGa0Y5yKFX2gBXKgfstwIA42726ZEdLAeqWvbTKti2Y2jVGpXJAlGtrZYr49AWtNJ+4lO18HRptQo7vuXJYebladQzwqIvG+8KuiqI+1hZiguMhoMBQcKeaEllAOPcxBn34duCwn1sCxTJr7dTbIrIReVmbIK2f/KIrCfETqjehnEn5Rouu74DksIymsw1ZJY0bRO38CAS6q7zymJ2sYxMAn1hzwb9VWHB1w8Rr1OoQdOiaCvC0Uhwo1xa/Iwb7vi2kO4gNfYUiHXPWI1Vjsre5mKEEPvveov+BtSAUt8EJ3j/IVI5nykYcXPi4caPILixQeiPTw/XcYDpO0JwMApabAlZSGRpjuC2HmIR/FtOgKIQxHNZY7e8mHsgPzwK0al1CcoGhhahRW8zKVYAy5vVmhrBoZOWqSCWCEMVvQFX9xk50XgN9/zRZBV8DgJx0abUdkF
 DuFciBAJ
 Q4HuTnJQtJpwZQAk2+4+QgIUtJ4E9w8KC+WcuZ9kZvCLLVATNCKsXHmPYNGfYT/QrcmgsvLNr2HbnPGmjrINk8x4BascgAt5kRVSfvS7EeaKB9gKuF9WtWI0UPOTE5j9M2o5+PkGCtTGcydfjWgBotb9ZxlMq6+e1KiihSHwKa89/yOKz9sdaSgHD7syG/96pli701QdxToHAV/muJHTGkcvF7tr5jR1m8oLQ1sUHJK6R4xOhMv137YKNx8Ii4XkBIdCpf3X9zAdm1x4RwECphToydc8B7zKhzNYEXJS5rdu0vRevvIRpZRn3nvs45UcaR/QE4V+44hZhuH2cvbP0DAZgIYYuLDgR4k4dWahGRZBQV/VBXDrdB0LLRgOo8iA7WoN96ATzwTAc5WQJO5vgNF7QRnLfnTTriS67pyn9tjOA/lVqnElNXa0RZa2ehh+bRJHj29ZPQNZCAYSju64XWBXvUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/19/26 14:24, Nhat Pham wrote:
> On Wed, Oct 14, 2026 at 12:53 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>> On Mon, Oct 05, 2026 at 01:06:28PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Looking at the mailing list, that approach doesn't seem to work.
>>>
>>> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
>>>
>>> 1 AM is certainly unpleasant.
>>>
>>> US vs. Asia is also tricky, but doable.
>>>
>>> China 8AM vs. US West Coast 5PM?
>>>
>>> China 9AM vs. US West Coast 6PM?
>>>
>>> (Europe is 2AM vs. 3AM, who besides me from Europe would join?)
>>
>> Either slot works for me. 8pm/9pm on US Eastern.
>>
>> Apologize as well for the late response. Travel week followed by
>> post-travel sick week...
> 
> I hope you're feeling better, Johannes!
> 
> Folks, I just realized we never really clarified the exact date, and
> since we are in different timezones it can be ambiguous. How about
> this:
> 
> PDT: Wed Oct 21, 5:00 PM
> EDT: Wed Oct 21, 8:00 PM
> Europe: Thu Oct 22, 2:00 AM
> China: Thu Oct 22, 2:00 AM

I'm traveling this week, so it's a bit tricky. I cannot make Thursday morning.

On Thursday I'll be traveling back from Cambridge. But hang on.

My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30am - 2am.

I could just naturally join that day.

So one day later would work for me.

-- 
Cheers,

David

