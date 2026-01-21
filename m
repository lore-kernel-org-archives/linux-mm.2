Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB7AC44524
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7A86B0092; Wed, 21 Jan 2026 07:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E946B0096; Wed, 21 Jan 2026 07:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CE26B0098; Wed, 21 Jan 2026 07:41:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E94C86B0092
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:41:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACC24140150
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:41:43 +0000 (UTC)
X-FDA: 84355932486.04.67A56FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D09B9180006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:41:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gLIaRQRb;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768999302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQwIUX57PWa5tqxAanQlxhNLVOxtFyBJLEJJJp/j06A=;
	b=4SmtB/eAKWrC9SK4zmwy94TXBvKVJ7ngeSrGIvCtU4NzoG/gDwx1wPSg/Bq9JMNHXI90qG
	6MO2xqVG8SPH9EOIFAwYX4CCVx0Edj3aA270B8aleWhT1umRcOL3CZTnDDMMHE2OnXfb4s
	Vyi0yC0MXtNJz18Byhit7srqUjeoAzo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gLIaRQRb;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768999302; a=rsa-sha256;
	cv=none;
	b=eFh/iHUzPUHvBE7GN0xQk460hTntqOQUs6z2W7QJr21KjE3rirA+xsHXmNCdPzAqnsC2At
	suJCo37wAXWSxfVh+j8V9tHJb4fGzScyEWglzmVRkcYQ8pC1qHsQZOWDqiJxiwTCkL/6+4
	gFRrLgnig7JE7GqNWkSIv8TOGJ2O508=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3CEB4030C;
	Wed, 21 Jan 2026 12:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00C8C116D0;
	Wed, 21 Jan 2026 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768999300;
	bh=Ot3wmRSgdlWXr/1d0aAM7xF9/+7KOTMVUro5hxmpKgM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gLIaRQRbO6LryUYKvEmAUETKOf0vwtVnf0ldAn+WKo4GaSz1NR17nXwyJy3XnYd+p
	 jRUUeCx1mrGMBIPWBfGIMI7QrhbLOkOmODLW+AcD2vo12V4D6fKU3kQ+g7x0tr6jtq
	 IoAaXYSE/Sfmp3l4NoseWo1dZRt8egy6wrB9jAtmQyVb5OcChkKxCxnD21CGx1nYrB
	 GTv5aN2AaMsHb3YnfahXNoQeTkd6KbdndK4baa352eAsfPlaK73XVwluA0NJAQ00EP
	 4R9WGvGtEb6vC3qn9LHhxhiKb/FtQDO+5rON3uxQFZFZzjS3ip+c5AkR/sfgmyu+jT
	 Jav6nRjgFfIcg==
Message-ID: <871f2a76-8ccb-4870-8a87-417371feb0b0@kernel.org>
Date: Wed, 21 Jan 2026 13:41:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: Gregory Price <gourry@gourry.net>, Li Zhe <lizhe.67@bytedance.com>
Cc: david.laight.linux@gmail.com, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, dan.j.williams@intel.com, dave@stgolabs.net,
 fvdl@google.com, joao.m.martins@oracle.com, jonathan.cameron@huawei.com,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@suse.com, mjguzik@gmail.com, muchun.song@linux.dev,
 osalvador@suse.de, raghavendra.kt@amd.com, wangzhou1@hisilicon.com,
 zhanjie9@hisilicon.com
References: <20260120094744.5d92e34a@pumpkin>
 <20260120103949.7673-1-lizhe.67@bytedance.com>
 <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
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
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz7CwY0EEwEIADcWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaKYhwAIbAwUJJlgIpAILCQQVCgkIAhYCAh4FAheAAAoJEE3eEPcA/4Naa5EP/3a1
 9sgS9m7oiR0uenlj+C6kkIKlpWKRfGH/WvtFaHr/y06TKnWn6cMOZzJQ+8S39GOteyCCGADh
 6ceBx1KPf6/AvMktnGETDTqZ0N9roR4/aEPSMt8kHu/GKR3gtPwzfosX2NgqXNmA7ErU4puf
 zica1DAmTvx44LOYjvBV24JQG99bZ5Bm2gTDjGXV15/X159CpS6Tc2e3KvYfnfRvezD+alhF
 XIym8OvvGMeo97BCHpX88pHVIfBg2g2JogR6f0PAJtHGYz6M/9YMxyUShJfo0Df1SOMAbU1Q
 Op0Ij4PlFCC64rovjH38ly0xfRZH37DZs6kP0jOj4QdExdaXcTILKJFIB3wWXWsqLbtJVgjR
 YhOrPokd6mDA3gAque7481KkpKM4JraOEELg8pF6eRb3KcAwPRekvf/nYVIbOVyT9lXD5mJn
 IZUY0LwZsFN0YhGhQJ8xronZy0A59faGBMuVnVb3oy2S0fO1y/r53IeUDTF1wCYF+fM5zo14
 5L8mE1GsDJ7FNLj5eSDu/qdZIKqzfY0/l0SAUAAt5yYYejKuii4kfTyLDF/j4LyYZD1QzxLC
 MjQl36IEcmDTMznLf0/JvCHlxTYZsF0OjWWj1ATRMk41/Q+PX07XQlRCRcE13a8neEz3F6we
 08oWh2DnC4AXKbP+kuD9ZP6+5+x1H1zEzsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCgh
 Cj/CA/lc/LMthqQ773gauB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseB
 fDXHA6m4B3mUTWo13nid0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts
 6TZ+IrPOwT1hfB4WNC+X2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiu
 Qmt3yqrmN63V9wzaPhC+xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKB
 Tccu2AXJXWAE1Xjh6GOC8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvF
 FFyAS0Nk1q/7EChPcbRbhJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh
 2YmnmLRTro6eZ/qYwWkCu8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRk
 F3TwgucpyPtcpmQtTkWSgDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0L
 LH63+BrrHasfJzxKXzqgrW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4v
 q7oFCPsOgwARAQABwsF8BBgBCAAmAhsMFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmic2qsF
 CSZYCKEACgkQTd4Q9wD/g1oq0xAAsAnw/OmsERdtdwRfAMpC74/++2wh9RvVQ0x8xXvoGJwZ
 rk0Jmck1ABIM//5sWDo7eDHk1uEcc95pbP9XGU6ZgeiQeh06+0vRYILwDk8Q/y06TrTb1n4n
 7FRwyskKU1UWnNW86lvWUJuGPABXjrkfL41RJttSJHF3M1C0u2BnM5VnDuPFQKzhRRktBMK4
 GkWBvXlsHFhn8Ev0xvPE/G99RAg9ufNAxyq2lSzbUIwrY918KHlziBKwNyLoPn9kgHD3hRBa
 Yakz87WKUZd17ZnPMZiXriCWZxwPx7zs6cSAqcfcVucmdPiIlyG1K/HIk2LX63T6oO2Libzz
 7/0i4+oIpvpK2X6zZ2cu0k2uNcEYm2xAb+xGmqwnPnHX/ac8lJEyzH3lh+pt2slI4VcPNnz+
 vzYeBAS1S+VJc1pcJr3l7PRSQ4bv5sObZvezRdqEFB4tUIfSbDdEBCCvvEMBgoisDB8ceYxO
 cFAM8nBWrEmNU2vvIGJzjJ/NVYYIY0TgOc5bS9wh6jKHL2+chrfDW5neLJjY2x3snF8q7U9G
 EIbBfNHDlOV8SyhEjtX0DyKxQKioTYPOHcW9gdV5fhSz5tEv+ipqt4kIgWqBgzK8ePtDTqRM
 qZq457g1/SXSoSQi4jN+gsneqvlTJdzaEu1bJP0iv6ViVf15+qHuY5iojCz8fa0=
In-Reply-To: <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D09B9180006
X-Stat-Signature: sjxuqwsxxq6t1npk4ykpfwo6jfhk8r78
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag: 1768999301-583567
X-HE-Meta: U2FsdGVkX1+SjQApPOpDeSPmN5p+vtPMUfO+QV7QcLXVb3sxg7DCxKbPVHt0Pufk55gneX4vB/eBTeSbfbMppvB0P1wUZ7htE8j2oTcXsXDMmZlHGvrWhLjPy/YwRY4gCJsju7pQESDwL0gAxaUXCjxzd6PpWzxrrcJvxKs9cmWghEgESkPRMN+YMewY/xlI58GIjwlFJ/EC124iaFZsi4OUm88Y3tNRThcnwMog012BYIxafiqFEPqMlpA93LP18ghaHepbzS3HfNau1yLpfSNKap3xropyqfL5mmaSPtT6yyyY2++VekO5zJV4zwTssR/FvOL/h/llGVX+1dBUo8P7qGMSqHxUrg5SaYv8WwTtaZ9NTb+2o1eExloEAFUdLseYXFUrO2YhaN3PxvW4TqjjUIvna8mJlKbY6tBL8zR5MNYcE+UV0TzNG3boOIkAINWv6KLmyyKUui2NTAG8Lwt5hEi2+uNrSPCP+T60a0T7wxs0JuZp5XHsRPHSUj+CLpKdvxRj1yF6lKLgdocoJE/BtOKRUcTODyEJ0bigu5iRaJzR2vVeqgSSCsVGL71BPNt78PbK8z6JUSxl6KzQ5UqDcfRU15B5d/SoKdw6ZbPFO81sZCHbVPwQQEoGLZCp8B+VV44+tCPpoa+6bkSqm30CIgUehPP5Mtct39398t7718by/+SRlGUCDrIKE37YKgrMdHecagzv2HArykRkVtabqIZTeT0+m3DsuvDGeb4avSLVDIixab0oIxGrR4csn21Udi8Skf3BB5iosPADlapggZj60BbADJR0gZW6jh4VaEIqe0pmcOhrmaXt/6mQYVEnn7fCjb7BVzMiXaxhNWh46yLgv5Inj3cYp8V6h03VcHTT/HtXjKV0jTmEG07j7dW4JUA9i3pDGBHz9xufwCOD9vpGZb30XFXSKNXkqE2faSP3IrFIEXCtoUln00qV8VJORtZEacCDSlI43kx
 ASeVcv9r
 j9iZO0NxoulkEpixatEM6jZ2htJtnZmFTp99fPRUjotr4gDcYksFyKiwqzIp89iBvsnZFoKgDSPv8B2MVKhAcBQHTp0vEqBXhDM2pdmAT8ZPusCgUAWmQNRm32M2MvalFko+xP9dRyDtI5g3/uEwkrLAuNDkTvkwfmShDI9K3yVIaeJejpBPClwlysr0hfgtPOMaj1nZ/g9RgTkmI5cWszzuWsxOQk0CAOWQJDRJN8MryFD3Qk5+yfsa2M8XXrhpWbtx7nZwbuXZWCdWx1Q7RRUXygr625R52J+elQvSpqgwq3oS4fLRRnTVidfz6S12t0JXQiABXSJPqH/KziwwkAQhdafPGa2tzlR81P1KXglrmvTaoWy7d2DNTrCP7PX09bNd5+ednmDnGcUKdSwziJDGh5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 19:18, Gregory Price wrote:
> On Tue, Jan 20, 2026 at 06:39:48PM +0800, Li Zhe wrote:
>> On Tue, 20 Jan 2026 09:47:44 +0000, david.laight.linux@gmail.com wrote:
>>
>>> On Tue, 20 Jan 2026 14:27:06 +0800
>>> "Li Zhe" <lizhe.67@bytedance.com> wrote:
>>>
>>>
>>> Am I missing something?
>>> If userspace does:
>>> $ program_a; program_b
>>> and pages used by program_a are zeroed when it exits you get the delay
>>> for zeroing all the pages it used before program_b starts.
>>> OTOH if the zeroing is deferred program_b only needs to zero the pages
>>> it needs to start (and there may be some lurking).
>>
>> Under the init_on-free approach, improving the speed of zeroing may
>> indeed prove necessary.
>>
>> However, I believe we should first reach consensus on adopting
>> “init_on_free” as the solution to slow application startup before
>> turning to performance tuning.
>>
> 
> His point was init_on_free may not actually reduce any delays on serial
> applications, and can actually introduce additional delays.
> 
> Example
> -------
> program_a:  alloc_hugepages(10);
>              exit();
> 
> program b:  alloc_hugepages(5);
> 	    exit();
> 
> /* Run programs in serial */
> sh:  program_a && program_b
> 
> in zero_on_alloc():
> 	program_a eats zero(10) cost on startup
> 	program_b eats zero(5) cost on startup
> 	Overall zero(15) cost to start program_b
> 
> in zero_on_free()
> 	program_a eats zero(10) cost on startup
> 	program_a eats zero(10) cost on exit
> 	program_b eats zero(0) cost on startup
> 	Overall zero(20) cost to start program_b
> 
> zero_on_free is worse by zero(5)
> -------
> 
> This is a trivial example, but it's unclear zero_on_free actually
> provides a benefit.  You have to know ahead of time what the runtime
> behavior, pre-zeroed count, and allocation pattern (0->10->5->...) would
> be to determine whether there's an actual reduction in startup time.

For VMs with hugetlb people usually have some spare pages lying around. 
VM startup time is more important for cloud providers than VM shutdown time.

I'm sure there are examples where it is the other way around, but having 
mixed workloads on the system is likely not the highest priority right now.

> 
> But just trivially, starting from the base case of no pages being
> zeroed, you're just injecting an additional zero(X) cost if program_a()
> consumes more hugepages than program_b().


And whatever you do,

program_a()
program_b()

will have to zero the pages.

No asynchronous mechanism will really help.

> 
> Long way of saying the shift from alloc to free seems heuristic-y and
> you need stronger analysis / better data to show this change is actually
> beneficial in the general case.

I think the principle of "the allocator already contains zeroed pages" 
is quite universal and simple.

Whether you want to zero the pages actually when the last reference is 
gone (like we do in the buddy), or have that happen from some 
asynchonrous context is an rather an internal optimization.

-- 
Cheers

David

