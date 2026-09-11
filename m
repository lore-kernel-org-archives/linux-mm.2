Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F44C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00806B008C; Fri, 11 Sep 2026 07:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89586B0092; Fri, 11 Sep 2026 07:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A476B0093; Fri, 11 Sep 2026 07:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B23036B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:06:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52178A2DB0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:06:57 +0000 (UTC)
X-FDA: 85201204074.10.0BDBAD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 88BCC2000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:06:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M/9x1C4q";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789124815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyAG1Oc8nhlMnt8PiMcuXVr+yTw6Fyl3B/k/KO2RT4w=;
	b=q7roVimVMinvOIU9y/+oMUR0Vsl9WjS7Co6+4IwHRSntXaa3aoVOAnXcmXqDrDJqAxhbx1
	byPqqY9TO20hmJJtTwdx+jFbk8v5mD35MH2oLDiGrWyDIv//WKuI4jHQ7FqlEUcXMtsRGE
	cpnh9tndEtgAfyO9ZSXMJiYhh1bVfjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789124815;
	b=fyxplHuijfDIr3lz3ptcwXjtkglmQa0Q6G/Jvwy6YT2inw1Hgx6nODY4SfnH+VskJXOxcO
	howNRu/kKlVG6Q3ggXgwvR20UqYfv30vNzajwTVNo9UecKud+zFwZQRgZlhXuJlkc35xKo
	QiCuDqvj2kN2BGkAJi2ndYnVUD9+CtA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M/9x1C4q";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62A2741847;
	Fri, 11 Sep 2026 11:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C547F1F000FF;
	Fri, 11 Sep 2026 11:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789124814;
	bh=wyAG1Oc8nhlMnt8PiMcuXVr+yTw6Fyl3B/k/KO2RT4w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M/9x1C4qxDvpxoHiv7cEj8LQlUukVYDeRNTLsbbXNFOtrbTn+yTojyHWXbq6WzZ6B
	 bU6nmscrsmoCKxa4FmC/vYIyG2DLQXY9tY7hf7ORDZK08UiTakX1B2z2QDh1CRtKG/
	 ZBbYAaGUBwUibxquZGOshfnA30JdvF1XWyItQ/od8o7GnUHCF5Ae19awg4+hDmIdHN
	 f33YPHgTVvIKEoPqJzAeEnqO1Y1OeRUXvXhXvHCBBHebAz3wYKMjiwpDEwK9Kg11W1
	 eFyPB5Z6kWaXxxTgUyLmL6oQ14ejY4i0dbW3N8iEmfDVvJLeMEGN8o5RBJYcm7lTwe
	 ahJ/1EkTHZwqw==
Message-ID: <98ca914b-4722-448d-b5a4-7f095d0ca433@kernel.org>
Date: Fri, 11 Sep 2026 13:06:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: "zhen.ni" <zhen.ni@easystack.cn>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
 <79548641-25f3-4ec3-a549-782fad168962@kernel.org>
 <6e8bfb0d-d595-4e6b-9536-0323ada57e25@easystack.cn>
 <b8e23456-00af-4097-a769-210a087d2b90@kernel.org>
 <22D1EC4B-FBCB-421E-B8DA-345B5F3505FB@nvidia.com>
 <d8d34e16-57fa-48b7-93a9-afbf4b950ce6@easystack.cn>
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
In-Reply-To: <d8d34e16-57fa-48b7-93a9-afbf4b950ce6@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88BCC2000A
X-Stat-Signature: rfgcfbzhgngzb1eixj4tnh41fjizmg49
X-Rspam-User: 
X-HE-Tag: 1789124815-234916
X-HE-Meta: U2FsdGVkX18P9L37v+x8J/yX6r+adHSWO4jQKojK5K+D/D9TGGowF4DBl/7CJk9da3RHuFST+0hISbIZSmwxm0OpyQpphiU8UmpxuyE8+1YaEZJxHD1Fv1+mxVKpKeDXY1PFMe7r954SO1NJe+ZUZOT8ytYBMCdnN3Sso97IZaQv5uBidP++gNRMAduJOKinGrJZ2Y/6VTII19FYGmpWGBbHl8x89HiPdyrkSO/kDo0651DmhmMpBCGsFK8YdxuQ+kiMUaiUjP5jprp+Bt/TtHAPz4wLJ7vv1ykPIGx4PHeV9uWmrfOmboYGYeLBqf+ABasVkdiwKmwavxQwTm+nvSoqRuV5veBmZTfPyNoNahZYxr2csLeAakWNn4YKq0TouwsWW5msrSGrIv8qKYXouRnEUS1QCKhMN3PX9kT2ard/xRkgO5nzASItmE25/4sAx7HJBLDauhKdcL/u4tEOTXkw3vDISELDDqd3Zj8MJ0RG6dFW/dhyWZWimqWlEu9hLx2eGd5jyvQNlYvAXgnWrXKP/5JCHwwt1X+9ukvQBW7Mhah6h6UqC3K8ADWJjJuv/BqPMsWyzHLutTWCMyxoX11atD9H6WhuHjPgxNuodWjnnGK9CnkMm8gMp1HeLgihi6o3S7qzCZQWZWnf91vhDp388cU+Uz5PDkzWz6Qy6LQddeckG424emzbBBRiVNp6x15vMcuDsBpOWZQ+Ru2xeQtps9Dv1WFca0B4wgCL8OO0XCelWVSBfSS6h0OmQexfHWl9zCXsC25ho/ej5ZUdDcCNXIT07WyfKt5JzcnN6DsidxaWqvOJPnovbNEeyd9NBoF1sH/59s7fPyu8gT6oAoUxQgDay6g1PR0CfEd9+P2csaXQnJwxzQhBqr2wVfkI91Dd8p5By+hfQIVWTxQHyhchdr4yk0QIkF7l8fv0ecDy70jknIRts1utBcmR1jg1+70Q7el5Fiv3GZ++zcb
 LlXr6h6E
 2vCfVyd/06NsScsmsP9dfdnUzvHmyjej2dHNdYk0W6GuxwFv1T0PjQmu+qBIla8aBlnN760B0teo0TY/dDLU4acIat2B/j9zNOO+D1ChVpfW5YEIfszDN4sPvn//IZLs+FFeSGx/O+EZuvNQKYDho8RPR/CaQTcmEuGHxqvHFW1OfFHHLvBx5pzj5zTwkhHd+1tY7+fUlG5kEdtKH5x+07GjPAXEp59eEfAxv760nBJuGS1wvwiA+hpATmQ8JiPXpjgSnbwrAdlLCUQgico28s70TbJhkRBI0tOhh9ct7MXMUJSa6S1xXz8tyyxkknInMb7izp3vbxlFSruM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 09:58, zhen.ni wrote:
> 
> 
> 在 2026/9/9 23:54, Zi Yan 写道:
>> On 9 Sep 2026, at 6:28, David Hildenbrand (Arm) wrote:
>>
>>>
>>> Because it results in less kernel code  :)
>>>
>>> And less kernel code is good. Unless unavoidable.
>>
>> An alternative is to add BPF hooks like bpf_iter to do the filtering
>> and by default, when no BPF program is attached, everything is printed.
>>
>>
> 
> I’ve also thought about a similar approach—perhaps a new bpf_iter type
> that could iterate over all pages by PFN. The advantage would be that
> you can fully customize what you want to print and what you want to
> filter. However, doing so would require refactoring the entire
> page_owner, and I’m not sure whether it’s worth pursuing in this
> direction.I’d also like to hear everyone’s thoughts on this.

Certainly better than having more and more manual filters added to the code base.

-- 
Cheers,

David

