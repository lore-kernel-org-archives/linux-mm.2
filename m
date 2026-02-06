Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C8BEB28F8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2625E6B0088; Fri,  6 Feb 2026 04:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222B36B0092; Fri,  6 Feb 2026 04:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132786B0093; Fri,  6 Feb 2026 04:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03A3A6B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:03:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3479160867
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:03:55 +0000 (UTC)
X-FDA: 84413444430.26.6D0025A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F0C251A000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:03:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GPSSFMUe;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770368634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwmArf2i4vlgKd8l9Rj6k8S8tm/HHr43mIL/JbfZilI=;
	b=fN8TLJuKnlC8dGvnjMNs7UoivN5Ibcxp33jVeZTIVh8fSzMxlD0BI06VABljddSWQ8fIJE
	C8TrJZ7SX+gIotxSIk7tgsm1FI0+bKfB1WwhImKVO4p7VEg/3R1r97he5Lnl6FznKlhE8E
	bBJeOEiPJVl2B/ItPQWVeR00lVLt6mc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770368634; a=rsa-sha256;
	cv=none;
	b=nEpPAmqVsYtkxFeYAMoIG11+J1rjUGF/uLss8MPnjv2SVg/2sgh07IXG/TSB79b1Mn89oQ
	o+7408HtxtGPtvO4TjnFRdybby03pBnU+yvxWRyDgC+UQBEJZ6m5R0yzIUdyOEyIpiDBrc
	Z3uGa4CjymjIQw3v9x4gL0wZPTEayMY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GPSSFMUe;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7042460010;
	Fri,  6 Feb 2026 09:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5334C116C6;
	Fri,  6 Feb 2026 09:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770368633;
	bh=yf3Ne5tIqz4PkENt5jTwf4zm9Qit2vY31bwJBriY4Pk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GPSSFMUeMfvyY0v6aStotudcJqKTHE6fhDx5P7P4axot0d6U9xsHIxl2p+VvfPAYV
	 rgdZfM7oxVDJ8jFFaz5RymK7gAWktpBIlA/ryEeTgmkZ+aIbCDjcAFMFbnSrmgXBL3
	 7VdyzRmoA53G7vQ+hqm07gyCnfSTWeoIKbS05aSXf8UNpEFereA3z7VAWI9LhbNdZq
	 E+hwO7jVtW+7RhbO0238gEXvEeYlB1eO3mScREpT1L/5VXHkKRPV/Ep5N12UVY89Xd
	 9Ic0ESy7ea+iLNQNLjs1SopSp8TYUr7d916+wba1LPR+iOLtmhc9XYduSzF/Bit38Z
	 bjGYcaIepbWUQ==
Message-ID: <11a4ca6a-9534-4f3d-bda6-4caf460c6854@kernel.org>
Date: Fri, 6 Feb 2026 10:03:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Dev Jain <dev.jain@arm.com>, Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
 <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
 <acb25f5d-b099-42a8-be26-c60b79502e3a@arm.com>
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
In-Reply-To: <acb25f5d-b099-42a8-be26-c60b79502e3a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F0C251A000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8w1qigtnofa1w97q4fr671fctapac6qp
X-HE-Tag: 1770368633-29339
X-HE-Meta: U2FsdGVkX18Y4gpDkBdwvok4SS/xjoK5EUKVqaMgYYBfv7yWyD/14pjyeJP6kMe/I/wHaWMIvJuGXq5Z2pLLAEif/JRIMfiB1J35PeSm7ctq7bbFW528evl5xhbQCXCkNvJ6UKcYYhqfZmll7tAVsr88SkValsAV//mUT97t9eILaay1SkLDWirkEXQ3O3xSagseVS5FdyutU21BPPIKEU63Ktn+AgBmEINbdnFaaH3BX4M2k+TmzLMwOPBBCrFZ1KZ6fD6PnJzczGZ7wh1uPPhN9V99pK2VomwEqiljceNimj4QtpZ6UgISP+hgrtILsA2oVACGOlRkpaBAvTni4bHdNFkMcRnP7OqTlefvi8psKDKyWR/aomJqTZI62gBxRph1T1faYxlHLuuz8/L9YGE3cap3yLJndYFtBQD/u7IQDXj/FIaTjLMSOuPdHuY+UfzU2h2iWi1ioIkN1XWrV5EqiSLE86pKyfc+F83srd4VRe9fpnj75R9TDg8hrJfiuTwg3KiNrO+8UsJPsEpTEvBC2BX21xUp4HIU0qGyb5QC85P7dH31GzIHewNAitFDrvEoRSmgj8i16KTD6wfnH6hy0eEZhFZZ55LoCSMN4E48EJu3XUx/8oayludLzWZkSNq/+xuV4uKUpcynRq3bPWn/7o56fXoczgSasc4Yz9O8upg35prPbkKp2R/bvhK37Xi52QI7kvX/KwHUyDH4pV2AU9sdnCdRTbznNnTuUBA1Pou/H17Iq7SmR3yUetXdy9+YaCGI7TqFdZzhWPvFm4k6Bu2qwHYvFSJoaD7D5Qv96PR3ILWisZvKU0v60zcb0q0ZYvp4V+14By2Z9jjCGRbj3x3ZcXLFHyiZTjtEdTiH3KQS8kPZAndxUYrl1IHE4S5mIlPCYmuSk+lwIDdi5GT5Ap6A8lWe9ZySCMc/j+Bvm8x2A0Ql6wRhHosiVdIMAn7d6FAL59Iu1hTCNug
 nS8jat3Y
 BD/3SFfJpOdpBBHPu8rYUj4oXqp1bW2LZk584wqa+8Vc4op0+vO7lTbH8Nq9UoY/9M4a9ZN2ZraBR7Wr0t8nU1metLRuDvyvdvYcc6oYL8D0esicnrI+hud7KLHS1KD+xMuTs6X83klSIhHq75iyJqlQUJvQnQJZ76wDYELCuRHIpS2y8IwYkND7Cx+WMQfJptEZrxbqEpK9XZ8ciX8GNla74TUOJGYwHQFMqXjD687J/TYhYIES9bwdNlR5428Vi91rj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 15:30, Dev Jain wrote:
> 
> On 05/02/26 7:55 pm, Dev Jain wrote:
>> On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
>>> Yes!
>>>
>>> Why do we even have to optimize this? :)
>>>
>>> Premature ... ? :)
>>
>> I mean .... we don't, but the alternate is a one liner using max().
>>
>> The objective is to compute the number of iterations of the for-loop.
>>
>> It just seems weird to me to track that in the loop, when we have the
>>
>> loop iterator, which *literally* does that only.
> 
> I realize I shouldn't have bolded out the "literally" - below I wrote that
> I won't shout, but the bold seems like shouting :)

Heh.

The thing is that the loop iterator does not quite what we want, 
otherwise we wouldn't have to mess with max() etc.

-- 
Cheers,

David

