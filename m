Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 547CDCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590F76B0005; Wed, 20 May 2026 04:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568896B0088; Wed, 20 May 2026 04:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E406B008A; Wed, 20 May 2026 04:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39F186B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:05:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CD2D1A01E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:05:52 +0000 (UTC)
X-FDA: 84787064544.29.12375FF
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	by imf29.hostedemail.com (Postfix) with ESMTP id 39D2E120003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:05:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="YpsM5/Qj";
	spf=pass (imf29.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779264350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZsvl46qWQHigxum3FRtg7Qi/0P+9ZbmcLxGnn2DTnE=;
	b=SOUz5FiXK0zw5+djpBnRWdlhdJfURnNtLvYrU80IGj9BEQUrOFysqA0l9oa7RqqRCyJaAY
	4et0Y/L6WsuLstkYkOa1GLlCby5D8DipjqZEf6i+AX08blP1Tp1t78JuZYkgdHkJ3ZtsMV
	z7XKsszpTUywopQtkUZApH3ARXWrkWk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="YpsM5/Qj";
	spf=pass (imf29.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779264350; a=rsa-sha256;
	cv=none;
	b=NVOiAKrjrIBveVSjYOIdAb0J8Ui9irhImJlk3jcGkhUcSlaop1s3vOnM/yqBeAIWdeZv6Z
	2rU8297CiVvq1TceVRbnxtHM1CwGqHon+e+0TGFPwOMrbzABmQpDJO4K3FuBZ8J3ocVHEp
	CmEZdORJLywrS2J6CxlYRDiMnwB9FFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1779264344; bh=HZsvl46qWQHigxum3FRtg7Qi/0P+9ZbmcLxGnn2DTnE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YpsM5/Qj1KURlIBKXLJLEH+lwLnh88W1EEgBZLjhrAelBCsljXVjJJxjryt8i9wQ0
	 vjmllYVYxP0SnVFg/nHCbxoshrpQ2OQ0kEfi8P12VeplLEx29Fwq4T+9/IbWOoh9yc
	 yzQK+SsclykiiRNEVLAq70fiOdbo09A4VZ9etRi4=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 16885226; Wed, 20 May 2026 16:05:40 +0800
X-QQ-mid: xmsmtpt1779264340t8p8jvwdc
Message-ID: <tencent_A8707EC14361A4E2A6C762850BE5994F7105@qq.com>
X-QQ-XMAILINFO: M+sNXJc2Y9oMgafrCSjOBLoEkBVammffmwkVL4pQz/KyGooagbxo2UFNtXEbLh
	 rDi3OJerN0VkNlalFAXGmVO8SqJsbrApke7cZTPXErJbye8yUYiyjtnXucuGGKdnPS4ZWkMjORLL
	 E/S7d3vE/rBeteK1ca9TKRKKT1uFOqYG3/ez+2SyeelQ9WzoKiruO2ndJy9pJJqUvwcpYWBXuXgU
	 SB1OUOa5/s09GsqQiEboiOv8DeyUHSmVFNaaPqW9NSM9UaOhyVDpfUdTkkLc8JvwGcqZyjfzcdGH
	 CrPm/FnQvtCHqRF9zAhBXkef+5KK/XcI6I/tN9Gi3O+UVe1V3BQsZ3DHbfBWHMo+uRffnsz/ouXA
	 9eGT+k46yxGZnzw0ETTaaRUieH4azQ02o8fccCNc1OB/uY4pUdwnVfX1A/s86AXHGfWrFgMLSUKi
	 1UuF6L0327zC412Cmf9QHLZpqfBv9xkf3fnMQBDvkKMlF6beR6gntKXcPzwehCZcy5k3FwisK/qd
	 8vgbcbJf7FusMgZ+/BiHj4OC125YJ6G7g05kz6065sJ30fSX/qNfvihpEFwpmWW+Z4ZdwdUPYybT
	 QqBxihj3O1JSe71SMHPcdUGT/vBLD1AqFlfuoDCZi53GIk3JyPCEG0RKNZm2nn0l9tKw9DyASRfQ
	 FdiAv3btEKFA4HQFa710G0GRp9THDoMAtwtcsfZNWXSaEhtz90Mk53ELMfpxDyXeWiDwWen8IHUl
	 MR6OaNi19UkF7jYkhWRHkjQvi6UfxueW/oMAnbS78suVnTK/5deKb09RXJ+yB9sbU6ZK0eJTF8Y8
	 3AslxoulvrFgJRYmNRkZn+NRYA2KKGZztDz7NpU/gEHwPzOeK/Pus1H/KN8/9+0M0AwbVAGxtb7G
	 D35TFXXX4USBwqFerf3vi6rCrIwWsw1dxWF8dvGsxUgpZ/adCtbCJvLk5JstUfWNEnSQY/vBgNk3
	 1fnbPSpVkcsTQ/b7F6LuDA+PyEyGLta+dSQpURXB/nZNf9vYZZK9xXuA7nRQ77T1dMFpz/eWSe6c
	 bZYMqPCSMIhm1JxME0UXWO5XEZAOZMWC5WhpFbEJ6SvNZFk27zSEyQcSCRqqZl+pfhHXmfFi5hKf
	 Ib3Xw2hnwwXOjgp8Iv6sQoa8RJKgKrYNLlcEtw
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-OQ-MSGID: <ff735130-77be-4c2f-99a6-aff64d95457d@qq.com>
Date: Wed, 20 May 2026 16:05:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio
 swapin
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <CAEmasaV7ejxqb9-wTT=7xdt+icxj-ZvdSLkSoC6X5i6NMfsKPQ@mail.gmail.com>
 <tencent_BE4D8C052157D1B38BA2F9FCA287D4C8E606@qq.com>
 <CAEmasaV=L8w4dF7ja7GkDu_7U5i+aVVH1a1qsXgtFr3wuWNOPA@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAEmasaV=L8w4dF7ja7GkDu_7U5i+aVVH1a1qsXgtFr3wuWNOPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yz1bx77w8mk8mhizgmzqkpm575ykbfpu
X-Rspamd-Queue-Id: 39D2E120003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779264348-524983
X-HE-Meta: U2FsdGVkX19uLGxQpOqbMQdQHED94lWrQEI6+GV1ktkwi60b+ff/iQncmGpjX5F7V1sAq4RxAvjKQ0ur0FTCimgXiHOTlCUH68y7Rq5ZlgX6WnCg1twa2smAsySJjTrwnfGYyFNaRjPTkqQY8ATauGmkE5r8E+x321c79DSatlUtu2cavoWNPdtZqBlHfhsTXYC4nWesxrMA7GJRj8rycJrN1GRuZSHMQs3HEQfyTsJ1RgRHtiKncTxBA0job2bBeD6VtZdTv4rWHuZkcqwuPtIewg9AWm+8l5CZ8YP0jIVPhGf/bhse2MWYipClAQhsyJPQh8xsTHXMu1TVjxY7Wl5ZSsVmESDtj5jkvo9oIcegW1sFBCIX8ru2Mc/rfIPupq5x4y/qCqt5QMb9X9yoCHhMK8WCi/Bemkztam0zTfda5XlRPLA65956SZBk8cXw9DRzi5gw/Qq9wqX3doSw66bZltDckwTSLSVQFO6eKmSL2hEOAIw0mP6ETaDJjvXfbdKVNCkZ+Dhao0SKPvm/DWIPT1cpB2UL1nqCLwmSS7AxiSsFIg/VViP06ScZ6SjO2QW58Svutf4fby99hYVXXHg3rrpRSa0k1gQIFYTVPEB0k2ZDclfSG3H2srbAEaHBqIT8xUyvIToauWtf0LWuAGTmrXxX2QXHR7BYSxIYm+oQDgQwQSF7obJVfDlD3x7qgzMnX2CFLEg2prRQdz7fZUoYhffF0X3QJDTKwHK+rh9XwnSNJ7V3GRXbltB4TR43JVElNGtAjI389MvMTOU3T8lx1aKcuisyBQKSrqtNHzyFljCIsQISS/cRAfCBAYj5RuXfmlOMdT1RbEzihi8EWIJRetMcOrpSXA4qI1ICBRGzfJqog1en+Lz9JZxyXeUCjTnU7quWr9iqD/TcmqnazdKrwnrPA5vIK2QAGRS06mGOj9KJZFT0XDrpkUHhi4vu5gn4rNIru3YoGGostF0
 P4T1ju9I
 IRqx2WPdsj5mjFXHT2JZemtra8JkQ3eIofTZOd/PcIE/iE1ga16T4MwSrS/m9rKz0Eck9sve3Hh3dIiNO1+s/ke+6Abt/LEGVI63DJa6vkAAmQeBdzXSyaiu/LNQMTc3MRcGBtTvwhptWHDo4DTIDHDAGGc+D3XwErurKeF4/LS2HKN/fKr42EI8TGUlLwyRXVc1PFMnZ9UmodWR0aNmnjofk8LMN74v9fElngWfaA2w1wd+PBsCr6SEMs01lPOm1z1zq4GZekLgqHPRJTnv1+Km1tHj/2lzm1m4p5Ygf0auXDKnbInG+2+QY5C5VldHLgyXVUyKTc7nZyXdJr4ZF4a5IjbvFUTDmAl/h7FYxvYsmLdUzw2fQugEhg2wu3LO5lbnfSr+N4FmY7aGNckZat8b722ec48KdZKNawap5QEIA7PT14M9lOij8mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/19/2026 10:49 PM, Alexandre Ghiti wrote:
> Hi,
> 
> On Tue, May 12, 2026 at 9:46 AM Fujunjie <fujunjie1@qq.com> wrote:
>>
>>>
>>
>>
>> On 5/12/2026 12:20 PM, Alexandre Ghiti wrote:
>>> So I have been working on the exact same thing for some weeks now. My work is based on Usama's series [1].
>>>
>>> The problem with large folio swapin is that it can create swap thrashing: to swap in a large folio, swap out may be necessary, as reported in [2].
>>>
>>> I implemented quite a few throttling algorithms on top to try to avoid this issue and so far, I have had mixed/inconsistent results.
>>>
>>> How did you test this series? Did you encounter thrashing? Do you have performance numbers?
>>>
>>> Happy to talk more about this, thanks for your series!
>>>
>>> Alex
>>>
>>> [1] https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif642@gmail.com/  <https://lore.kernel.org/all/20241018105026.2521366-1-usamaarif642@gmail.com/ >
>>> [2] https://lore.kernel.org/all/SJ0PR11MB5678A864244B09FDE4D914EEC9402@SJ0PR11MB5678.namprd11.prod.outlook.com/  <https://lore.kernel.org/all/SJ0PR11MB5678A864244B09FDE4D914EEC9402@SJ0PR11MB5678.namprd11.prod.outlook.com/ >
>>
>> Thanks Alexandre.
>>
>> My RFC only had correctness testing so far. I tested the all-zswap path
>> and fallback cases under QEMU, but I don't have bare-metal
>> performance numbers yet.
>>
>> If you are already actively working on this, I don't want to duplicate the
>> same effort. I will pause this RFC for now and wait for your series.
>>
>> After your series is posted, I will take another look and see if there is
>> anything that still needs follow-up work.
>>
>> Thanks for letting me know.
> 
> Sorry for the late answer. I took a break because of the inconsistent
> results that I had, perhaps a fresh look could help so no worries if
> you give it a try on your end.
> 
> Happy to discuss further results if you continue.
> 
> Alex


Thanks Alexandre.

That sounds good. I will take a fresh look on my side.
If I find something useful, I will discuss with you.

Best regards,
fujunjie


