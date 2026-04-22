Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C6FFA1FDC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD136B0088; Wed, 22 Apr 2026 14:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D662D6B008A; Wed, 22 Apr 2026 14:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57016B008C; Wed, 22 Apr 2026 14:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5E956B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:44:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CCF31B4BBC
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:44:39 +0000 (UTC)
X-FDA: 84687067878.30.69DC64E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5A75140002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:44:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ar6Ailr8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776883477; a=rsa-sha256;
	cv=none;
	b=2GpQl/rO4/BcSxumz+5bI7MTsI4mzDn/9uie1gD14nSDVmN02uRZRUF7hXJLaS71NhC0M0
	eJGpt3xoQnMHXDo0LMCJyOMpl1vw6Hi+g5w0Fa8GorZ7TZn8WNRzoIFhrnYB4LtE9K5L2s
	e4YXELELhMOJLjkA+zj5iJamvsqpgtM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ar6Ailr8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776883477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXoa1yT+Xm89idsZPywbPpKovf6f7o0WX+l9mxMBlgU=;
	b=3rKJ/CRnLCxaZj146Mu7eIJJS74ewKTH0aXDEkLTu/gVOABP7JXP7Gkx4mPoAjRZmpLETY
	zeYuK8T0FoOW5we2/RDamsbmOk77s6wPyvpKTikzvNoYRxpwgmhglECcK9DwKpb9Z0fMtI
	gpfZrnnRy1nOBlJXBQ+AeW5dJkTcugs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C9C8261863;
	Wed, 22 Apr 2026 18:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71552C19425;
	Wed, 22 Apr 2026 18:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776883476;
	bh=ilvEI0BHiHULZNA/B/A6EMF3FKVbTqFyj5373kbg55o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ar6Ailr87SdHCHN8e8GxfW+Kgft7xe1ggPO8FtJoXckyDsBamaSPPbS4AET5bkMtn
	 4mxPwFV5UghvM0N6HhoNl15HBjmD+8trUz+001B2MS4ZmSwNNY1ejqMDzideNp5XL6
	 MyZc+bdPzl4xMeIvrAXJucrYNtsAZy85WUKQLFXds3veo0lqq19dpqjFvdHFYcFThw
	 agGYZjIwxIcieZiq5BhmsCgOqNiV3tDFwr4xJcO1wtMQPtNKA8UCEdNnuflLyt6rkK
	 76f2abbcU7nq/qaDunmjb4g5rWQjD0AEJKnSewhumLCPOeCUnlj3CsOzWAU8Ylydh4
	 Y3dF56GALuC1A==
Message-ID: <dd27fb14-38f4-439a-b5f8-59149e6fc6e4@kernel.org>
Date: Wed, 22 Apr 2026 20:44:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
To: Josh Law <joshlaw48@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org
References: <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com>
 <92c3d650-be80-4a64-a962-3586ba753316@kernel.org>
 <B2261993-3CF8-47EF-9F76-FABA6BB4A50C@gmail.com>
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
In-Reply-To: <B2261993-3CF8-47EF-9F76-FABA6BB4A50C@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: fifdihaqqonsjyaq4sg1menx1ws7dmzo
X-Rspam-User: 
X-Rspamd-Queue-Id: A5A75140002
X-HE-Tag: 1776883477-950797
X-HE-Meta: U2FsdGVkX1/v0XET0n5jZyy3eNxz5COrUkKPrzPQEqnl3nk0Sy6Fd/42CuddI7xz7EKuH+8zjpz5RI9ypbIJ54jLtQpxSkW0B3vwO/u1oc4u+M7cLMnD1NABNrRxMRb/LfM9OFXE02oXlfLO2xaBxAiyFo9LOSEeluLlHGktCNUmjaY1HfDZHCzjYuP0n7piY2+xJl+LxcVxHRY4vu1DYGAUULm4yiiyNNgO/c11FlssYoi063b3yTn0SLzo/nTSGuIJ3GhfSrpWKoUWZXYCSqG/avip7dQUzzzMLElbl6hUxeicNZQvXGASIKNV5SKD9r8ouysDld4z83SWhQdl5eEvtgcbG8NH9TaHxk8ub+Ql4VqYpQ+5pvGjR8tHSv8P9wU4ZgHDZaMaA4U9pVxQKfzGNcDBhKt3zz1CggO+19OOsJcGP7yJHGUP/SppruuiT+P2zUNsLjjHYMU2+5ti4hGqyY2RafX4hno4nqsOyARQKLtU/FhOpzn0NzmSYP/0h2hoKm0H9TW+/sRSCJXCyyZky1StHtj45JrCSHRcW8Sfds34LmkCkEDSLNh9ynuRsHzhsdaiOEER/ivravingzNNFqH3uBg0Yv0exJx3/CTFSs2//1puvGYXsni0dTG34B6olGzo864CUCw4ULSNBL5MeZn9wtrfJuXghwHzmTewYb03uk26SmlYO+KL4x6ahVp4scv6bfMzOD6P9M/L8YQbShWusIpSq4mk0QICKzdKxFnr69dggh38Gh8oCtpMC5czL60vsKP+0rATpuRBZDwpBLjWXjVUvu2zcVjd82+rfxWwDdOgPxcFWj2mibqfnKnGcjLVoymNSEKtOuvuy+UtbMVtx8exb2Mrz19O8qj2DSpljFrIMqfXVz9w1ht7JXyDUjEf2h9Lg4Z97pWISdEn5wURb537xjex0Bj7SwwlIWWZkj7Jncco9zcMs8DiLFh5C/nJeVmRhqdn0QF
 pU+zRllW
 EqHJhtNYULY0n+hPbHSfpH4jfUg/vYCoiCNJyvzKuCFxLKF9WWVcEk8AYtU1nLcdWmS3vw8dnhKfeT3KpalwLc/RVw21rwkb0Kq+o3cNvhSP1Lre4h5Y+XvBAPMWFLJogvXKxmPrD5CimppbFBBbYowzwHPkTVNpAFoZqxvK3zfgPVQjKwNA0VvYl8V2rlNkR16HEEbktxlaoLs8F79FHb9z/ns5JjX8rL7aCCYWbiHTWdmeZU3sfByhw9FWiXIId+X7V2qsAsPXxagfLuHg7shl0Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 20:22, Josh Law wrote:
> On 22 April 2026 19:18:25 BST, "David Hildenbrand (Arm)" <david@kernel.org>
> wrote:
>> On 4/21/26 21:25, Josh Law wrote:
>>> Hello, since I'm not coming to LSF/BPF because of my age (aw)
>>>
>>> (And I'm more than aware this post is more mm focused, but I'm
>>> representing lib :))
>>>
>>> I'm "virtually" putting my hand up
>>>
>>>
>>> Whats going to happen to lib/?
>>>
>>> I'm aware there are submaintainers for some files
>>>
>>> E.G: Steven (and Petr) for vsprintf
>>> Masami for bootconfig
>>> Willy for idr 
>>> Liam for maple tree
>>> Etc
>>>
>>> But let's say, lib/glob.c, or lib/bug.c, even lib/inflate.c! (And/or 
>>> all files which only has you set as primary maintainer)
>>
>> I'd assume that (excluding MM bits, for example) falls in the foreseeable
>> future
>> under the "I plan to keep running the mm-nonmm branches.".
>>
>> What happens when Andrew fully retires is a probably a good question for
>> the
>> future :)
>>
>>
> 
> Yeah David. True, but nobody lasts forever. Andrew is "stupidly busy" (his
> words ;D), 

Yes, but he also writes (nonmm) "it's pretty quiet" ;)

So, MM is the real struggle.

> so the (basically) orphaned files like glob, or smth like that,
> could go to someone who understands the code better and more likely than
> not, has time to review.
> 
> We may have to have a think about this.

I'm sure

(a) Andrew will enjoy being around and we will enjoy having Andrew around.
(b) If Andrews workload is still too high, even after MM is handled differently,
    or when he wants to completely retire, I'm sure he will speak up.

One step at a time.

-- 
Cheers,

David

