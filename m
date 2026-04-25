Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FF4FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 05:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8326B0005; Sat, 25 Apr 2026 01:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78E36B008A; Sat, 25 Apr 2026 01:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B679A6B008C; Sat, 25 Apr 2026 01:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A29766B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:51:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 616BD88BB2
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:51:21 +0000 (UTC)
X-FDA: 84696005562.09.5D7CFFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6923A1A0011
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:51:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4kzHdFk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777096279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVNv3MXfWzGqAivxHzwdF5oBfIuVHOtLtp36DQh8Y5s=;
	b=7a9Fy9x8+IWnF/HzPdveMW3H9v0of06g7pSSUkg8n9hJg69wrnplTTZl4f9giE10t/l9uq
	TNDZlgGRB/3UhuvMvcffp6YRorQVhWS3RUXzNjedVFGVzM0oC4iAHkuQzXpyw6sgXTAZzD
	5vXK2085ECSEHHs5h/3tPb3Q0Mq7sgA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777096279; a=rsa-sha256;
	cv=none;
	b=gFAASCp098Lqicog6rG/+43GMars4tU/yYXJ+nKXOQcQIZdjXqi8Ie6KAzPHZ9ZIfkpvW1
	LdUXkT/D/XfvECsP9UbU3yOnulsKHC9Skw7W1uh+uT1vU4qcCoEN5sF9iHjMK7hupmQ8jp
	JcitwZrzUat4dQ8xtJu08sfeLkLegC8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4kzHdFk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39E6043976;
	Sat, 25 Apr 2026 05:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43358C2BCB0;
	Sat, 25 Apr 2026 05:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777096278;
	bh=1TX6ihQk3kucuVDvqFiea8KYgGnEz+xLRlMxsOzGOA4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n4kzHdFkS93dzBf/0sB8LNKsZ13c/FMalJ7qio3iOrsEsZ7KoSTLEFgzargeBcq+d
	 91GPSZFDSYKszIoGvVWUcz4DBGBcNf/fGVAheD01TE6yF3/oM/FF2HA4YprwGHF8YC
	 HmX2P/Ex08ZqCO8bd/tQoXuXA6iN8Z2uBkWM69wbTQhDPR3Q0Nmfh4pfyzsuEO9W1f
	 Lp/Fnq+oVLRj8WQ1OBEpzbF5vmN6zREJhq3cBavYShrRFJiYGAYG+hxtZAiRVGG9dA
	 Za/4kBiS4LglmJRU758hdOa5ybFwfbSnO3RsKBwcDgP/VN9eQX/4DO3RF9ii8tmYSd
	 2szB50df5VyvQ==
Message-ID: <b2a15eea-6ed9-4b35-af68-4586554ad2a3@kernel.org>
Date: Sat, 25 Apr 2026 07:51:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/7] mm: dual-bitmap page allocator consistency checker
To: Sasha Levin <sashal@kernel.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: akpm@linux-foundation.org, corbet@lwn.net, ljs@kernel.org,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, skhan@linuxfoundation.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260424140056.2094777-1-sashal@kernel.org>
 <b001932c-e376-462e-895a-5e4a9c7c0dc5@kernel.org> <aeuZcY0u_7PIQb6R@laps>
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
In-Reply-To: <aeuZcY0u_7PIQb6R@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6923A1A0011
X-Stat-Signature: kitdupunpjphk8abdd7fcu55ybeyqweq
X-Rspam-User: 
X-HE-Tag: 1777096279-266459
X-HE-Meta: U2FsdGVkX189rMQAWrsSnrSIGPETJhnY05qtLwZ970GGdBAMKtVrsOVxncdxyIPjkRtxWcECUGNgbzfsiSQaHt7mt3jZObTTKyrK2CfAMz5Kr0w9sUocfExNZQY/5zpXtuSn8B8hoMeV8tnAIpBQQdpdfgSlO3tgn1iUUso5/o8ZvlM/Nw/oj2jXayRRDBQUp5pucbZGWea1mLudQH+QJtSk22esY/afFbo/O+ZngvS4JgDmdit904iWJoEGBAwc4kB0vqeYRyOTSkjTmRcj4sPpruWdFuWcNYiQ5xCswX3x9kwehM8vbmQpgOqfGft1CT5bppx2CRdOS3N9TktrlyPY1X+vzrq9HqfedKGGD/Nc1fLPRaxz7MRYwOb0c4BungIXWwEY7aDRLoaTYhZ89hfxWCly8+LfgjEcvvmuRXMDa+TxXRosYbBwqKfXFpUJxLm5QRmdesDjuJH8dbCLzVY9r0E/9yZls/N7JmDjrq5YL+YhkQ1sg33ZMouMAKjoWLBWsyMFx2DyTpzHDAo5g35IbR72htTWPjYMB8SMn0r9cAvfz24TeswniNo8BzBHVfJayRxc7tgWYAXvy68F0y0hYOMsF7Eh9NNY3lGxOV+6nHdUHkOrcpCE8vBCTWwYK5NB9+JXndgCbbMPmbrhT8zT60UcgcFAnRfvnFzcKzqbHt/xSk/BlvlofXDFJNxIw0siElxpXQZiUtU0pCVKXcTcBiFMPG+Vud//6qfTjD8O0c7FeVHGr1AMYF8353LLbTwi/SwAZEbVmWtwwFw0Jr8iEH2JNWNNAoqJl38X0FqQTRTpfnEjvAIFNi8w4Hnscm24DeraBAloj148SwL9xuGY6K1TVss2y8s1geCNYDZrbmFTFBAtTZ+sx9ZVVXprLv5uiXJpltz8SX2JB3z0+ure+hWqjUF8NRsluZ8JIc6mv274HpQ759dRhxnoy7v35WiGyXgIovjmvfmqQw+
 HiGfx+lo
 K6Uzh1beM5GioRf2Ou7IZzGbQ7TWIw/iKzSCVibPLZCx/5qXgh3LC9P/aHXecrpNO4z3XSPWaS+TCOYoQCUTKgeQWoA2qIpAn7qMeEPuhqhSz6QxfAhUqUuSnuE2EqBFsAlV83QrDotnADmDRaK/0Fz0hrTWUU5PEE5GXeaVe14lYhfmSshEIZmNJ0lJ5lSpTzK/OHq7mT8JJ8ROJlALnxdb2ijYJ1XMZoZKcAIShGKmxf9T9WywJK4t1b4m9bya+gEuwYSTZfRpz61TL5s9vAbZou68TOzJSQJnz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 18:25, Sasha Levin wrote:
> On Fri, Apr 24, 2026 at 05:42:53PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 4/24/26 16:00, Sasha Levin wrote:
>>> Existing memory debugging tools - KASAN, KFENCE, page_poisoning - detect
>>> access violations and content corruption, but none of them can detect
>>> silent corruption in the page allocator's own metadata. If a hardware
>>> bit flip corrupts an allocation bitmap, the allocator hands out a page
>>
>> An allocation what? The page allocator is a buddy allocator, it has no
>> bitmap to track free/allocated state of pages?
> 
> You're right, the cover letter is misleading there. Buddy doesn't use a bitmap:
> PageBuddy lives in page_type, the free list is a list, and page->private holds
> the order. The dual-bitmap is new metadata the feature adds, maintained from
> the alloc/free hooks.

Given that you have PageBuddy (first "bit"), could we use a second bit in page_ext?

-- 
Cheers,

David

