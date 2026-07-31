Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89A8AC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 14:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6E66B008A; Fri, 31 Jul 2026 10:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E376B008C; Fri, 31 Jul 2026 10:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B49C6B0092; Fri, 31 Jul 2026 10:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 599326B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:09:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E603BC0448
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:09:37 +0000 (UTC)
X-FDA: 85049254794.23.1FE77FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 120B480010
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:09:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sma4NySL;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785506976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ru6sr9Ag52v+hywgrI7YJPD9LSqOe1cCd8UnQArdNRU=;
	b=RD6vijLM6X9BVzNOt1NTEaZPWBPCbU8Vpbh+DHBbrfGoLsnzgfpGv7Qn1tskStB1kixR73
	yKHOiwkk9zgMdGUyXOkw7BrwG/wRfV606o5uaVJlgFwVi6Chzn+KSv/TGr2uJ+tOCq4+80
	Ja3qesaZvx/0XSdS8fI6CWu/Yy3F0lE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785506976;
	b=Q6sHYHE6SAPCe20UByhLoVgeZcPgEQEYd9ft9OJDu1o0XhEwTH+xv4CDdUi9xqBPqu1uGu
	QoQV7LQ/1iKCBd8aosVzrOvbQvQlb9s7lZ6hAmUueNMWTgB6SGKB9Hj1wKzBBFvIEohmb4
	zUk86Inf4s18YIXVK+bfXbnmTdIqO/4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sma4NySL;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23C704358E;
	Fri, 31 Jul 2026 14:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540F41F000E9;
	Fri, 31 Jul 2026 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785506975;
	bh=ru6sr9Ag52v+hywgrI7YJPD9LSqOe1cCd8UnQArdNRU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Sma4NySLrk2LpeqI8MxMincsPL/fzm3kYiTO8kNADhS+us0NITNzTIGxCmkU+N4sQ
	 YrbO9rn6nonWncSBSuz8cZR3dPHFpnyzkvmco3JxwQW2dl09xKaLBWwPEO/xqwTsp7
	 cMmYUDQVEW7nIrE3SpG3hLyTnQsDi2FiGXtTMWq9CmNJ+h3d4jNRE9aLZ+zSecSh5r
	 59wJgcyU5VeQbgnXgpoIbDpDlz23/l3BY+n4nDS/AoDeUFtcRayGoy6Zk5xSgxszco
	 YtenKl9VnwSJTtmREWhip2wdMkHfAoitI2bjdG69H3tTF1LOHjU11I+Ned9jZPvoth
	 fEIHze/FxQPsw==
Message-ID: <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org>
Date: Fri, 31 Jul 2026 16:09:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 "hughd@google.com" <hughd@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
 <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
 <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org>
 <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
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
In-Reply-To: <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 120B480010
X-Stat-Signature: p7yr5f6q19au8gnznfd88wqc3wdx9ngr
X-HE-Tag: 1785506975-427264
X-HE-Meta: U2FsdGVkX18NF3VmQfdtZXnVG0UbK5rygEAf4aYMMapOtFJPN7TcWyfvGyCJMtreqJyCzISdFofSFDOzN7rD+us0Gjb0xhp6yA9GiNDvklsBJILSRtZvoqOAFG30U5Uo2Ak4/THG17FOFM51rX12lobnvY6pHfRa1fgcArOt5NkVSBr8UvUpNmZ6r2zAHXRK0DNj8Md7eBIIp0Kcce/5HCcL0Fe3TO4gT7y97gua2pY+FXnQdA+s5lcKKc7RSRkEMdjYkDvfZ37APTO550envoOmtSaBxtwdiUSG7YPu/lJUkwjFcqB60N+fLOy6eYjTBGExkHSyaa8tqKuNgm6U/iSauLNFs5zhvsWjPwOH+Jz3Sog5QkxC3RcvntKLz0dNrMMRLdJsGIhqpNYV1fvuzEfzMIzb/ENVqS0RTj8ZBrX2dqTKPsIMTuqPRmftBTgD/P5wKWjw13dS5op3q4/oOB2elIJFBEvQ9vl4DcNvQ2MBPSZGoszP2au7D5+JsHE3AxDBDnC3cy6TLPr6PPxDRPpQaWg17AJ69BGZ6Ij/yLMPMvUPGD9Njq4B7RTK8fNNX+j61Yg2TBLwdO4PT5FpwotJkfttRstRXdNtTOKydU7e8s/4oQL3riSrs9Oti1ef17jIrIjQQRVBZXS/MNZ2uL1UKzV6uyQrRTMikqRDuyBPkhN8tmjGImtYzR0SOuEDtVG60WJ8KzzG3msWWL6rm0VuzR6NLhWGS7KbDRslh9P/jwy1P2swNe+n3rDeP54sIK0W/5P19P/b4S3am98b1lekT/fGcrWE434pK85OWI1WtgXFBfiRPjiBqLiO5WbPKwY4TJi4RTgogbQMTw6dWCr1YXtpuNoNrYX42lcWlrna0TFo3EjLEs6f+/L0gNfCObcCzaGY24vQNpnQqWCPHx92ZIvaKIK5RxTvoRG8XkI8YSqSDHkLpl8f8k/oDItpgODY/RBao7DDVG1JOhk
 WGm41BQx
 82v0+NQHclVQ7mOsgLrCblpDfWjOo1M1eZpvdmqlcqBRqxn7DDQIqdtEUFfFq4Cki53I9DxHVfEmO7ZltFql1g4TvX9+wOOYM+DZwzGqgaHC6qLnLNLqrmTzywFqkzvhIKF/Pi3ufKTe5OYDiKinoISwPQl6bM9dx8KgUwiEhtBUL0gfkoNGo/jrFjDoTNGTdAcnl3sIXaDNvUnebsIh+DBeV4qnuuMyglPIihlaPiiwP6KrTfuZuBmN8qMuNTAGpLZtCzkPhGl9BU7kpkxy1GW4DJc/QnzY89hdE3FtjK/l53tspfzCS0NmLbXhfMOae4aV19KqYXZP5zofi0ncMlYLnkL0Q937EQK7iy9sOv5+QQLPwwVVFyZhKgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 15:03, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 7/31/26 12:22, David Hildenbrand (Arm) wrote:
>>>
>>> Just nasty :)
>>>
>>>
>>> mlocked folios in the mlock cache hold a reference as well.
>>>
>>>
>>> I was trying to avoid messing with the refcount for ordinary LRU cache pages.
>>> mlock() should be a corner case for guest_memfd.
>>>
>>> Relying on the refcount just means that one unconditionally performs a lot of LRU
>>> cache draining even though it doesn't make any sense.
>>>
>>>
>>> Again, the problem is that on *any* raised reference you would drain. I
>>> was trying to limit the harm.
>>>
>>> [...]
>>>
>>>
>>> Why?
>>>
>>>
>>> Why?
>>>
>>> That's literally what the existing refcount check tries to do: figure out if
>>> there are LRU caches.
>>>
>>>
>>> I really don't understand what you are trying to say.
>>>
>>> Draining only makes sense if something is on the LRU cache. And there are
>>> better ways of checking that than relying only on even less precise refcounts.
>>>
>>> If someone wants to do an early refcount check to abort the overall
>>> operation, that's fine.
>>>
>>>
>>> ?!
>>>
>>> That's why we have the universal definition of expected references and the
>>> common helper.
>>>
>>> Because pagecache pages commonly don't support the swapcache.
>>>
>>>
>>> It must, because that is used all over the place. The only thing it
>>> cannot deal with is references held by the caller (which could be supplied
>>> through and "additional references" parameter like we do elsewhere).
>>>
>>>
>>> You're not seriously proposing such an abomination I hope?
>>>
>>>
>>> You can just check early for mappings.
>>>
>>> Remember: this is about LRU draining, *not* about your final
>>> "unexpected references" check.
>>>
>>>
>>> Who cares if we end up with a common usable helper? We have usless
>>> checks *all over the place* in common helpers.
>>>
>>>
>>> Yuk.
>>>
>>>
>>> Putting an enum into a header is a problem in which universe? :)
>>>
>>> Ackerley, please stop making up stuff. Having generic helper is not a problem. Doing
>>> checks in common helpers is not a problem. Putting enums in headers is not a problem.
>>>
>>> Your version is just bad.
>>>
>>> I can later try something that keeps the questionable refcount checks in place,
>>> maybe that could do as a temporary solution until Hugh possibly finds a way to
>>> remove the need for draining entirely.
>>>
>>
>> And looking at it, the current folio_ref_count() in GUP is entirely wrong
>> and always makes us drain local+all.
>>
>> Let me fix that first, which will also modify this code.
>>
>> I'd say, to unblock gmem we could have something minimal that I would clean
>> up later, but I think the problem is that lru_add_drain() / lru_add_drain_all()
>> is not exported, right?
>>
> 
> My bad, I totally mixed up refcounting to drain with refcounting for the
> safe conversion and didn't have a complete understanding of mlock().
> 
> The problem for gmem was that if there was an elevated refcount on some
> folio in the range, it might be because the folio was in the lru_add
> fbatch.

Right.

> 
> If it were in the lru_add fbatch, it would be fine to just drain the
> lru_add fbatch and proceed with the conversion.
> 
> lru_add_drain() isn't sufficient since the conversion might be handled
> on one CPU when the folio is on another CPU's fbatch, so I had to do
> lru_add_drain_all(), but lru_add_drain_all() causes IPIs which are
> expensive.

Yes.

You should probably do an early

folio_maybe_dma_pinned() || folio_mapped() check and just return -- don't drain.

> 
> In an earlier revision I exported lru_add_drain_all(). My understanding
> of the discussion at guest_memfd biweekly was that Sean didn't want us
> to export lru_add_drain_all() now, and then end up exporting some other
> function and unexporting lru_add_drain_all(). To avoid exporting and
> unexporting, we then said we should refactor now.
> 
> Happy to go with your proposal too.
Yeah, I have to look into this more closely. I'm now convinced that we really
have to use the refcount for now, but hopefully we can limit it on
folio_expected_refcount() internally + additional references
from the caller.

I'm quite busy today, but let me flesh something out that actually works.

-- 
Cheers,

David

