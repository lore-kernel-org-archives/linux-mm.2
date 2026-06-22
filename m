Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07562CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E418A6B0096; Mon, 22 Jun 2026 04:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC4C6B0098; Mon, 22 Jun 2026 04:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DEB6B0099; Mon, 22 Jun 2026 04:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96FE66B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:18:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24977166F36
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:18:06 +0000 (UTC)
X-FDA: 84906845772.29.4CDFC5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 50E74C0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:18:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qj3Pjhen;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782116284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7FY/n6BfGkQmovoPL/bYOjU9mfVXkPNdqUJ0uKKED4=;
	b=DE9dKsCvM1cPSk/xnG4o1xWckaqBAimI27S6i2Qoca57zFt4HDvhr9S3lNQf7MoUzVhigh
	vblM586WMlQAqbTy/8rReD+6W5v8gP1ZfJBu+yOyf0JbgRFA9kxb3kWPDLGkoXEiliUgvv
	4/o23jtM29mUyRFFT9JoHSpulcqCDKE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qj3Pjhen;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782116284;
	b=CNeq6pQDJmNSDlOw2or/uPql7VmMEeXfp0oQhdZ0HawsJ1UDAn7yOnzek4qIFK3QUghcly
	33BAgTAb0j5Vwc58ETW9HDIgP2wCavbSdCgHPLL/KjKjfaypBsMPJJOUr1E+kcGiE0rmB5
	5fNThYSiMsyE09QMeORu71PSKk6aiEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49FDB43B43;
	Mon, 22 Jun 2026 08:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BFD1F000E9;
	Mon, 22 Jun 2026 08:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782116283;
	bh=G7FY/n6BfGkQmovoPL/bYOjU9mfVXkPNdqUJ0uKKED4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qj3PjhendpcKgOV5uS+8poO34V6NEWEyMlhurbT28lGH/h4ev2j2wVek1/4As/CL7
	 TjwepK4CJyD/Fv4/CmNXYgx2D+PnYLdQedhG7dbX48q+cAVqBJKxGJZrgW7dp1V92P
	 Ur5BnGxMmSsA4lAxCnKVjkuRYiufbKPVQDY4Q0wji10mszxofOcRe3tz+0AwrOV6aI
	 e9E+344c4sZ+rgI0ua7Pak0gVN3l6o9rTfYH3YQ/IXAtCQSDC5IPwhiXDZYqMh6jHh
	 6YHe1x6Hnp96+a64KHS1BznK8ytrq1jw6DvW/0lJfrn0K/RTWmxjDuyjz1UHYv1dJv
	 SBrR1/l0+2SRA==
Message-ID: <0368128c-664a-40aa-9b37-27768d403795@kernel.org>
Date: Mon, 22 Jun 2026 10:17:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ljs@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, hughd@google.com, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <20260618074449.24974-1-lance.yang@linux.dev>
 <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
 <0fe2a584-c633-4f82-8c47-d204e3b39a57@linux.dev>
 <e64fc2f2-c4a0-434a-8d60-dcb28b99b8c6@kernel.org>
 <22613c23-612b-4de0-8731-00ad2da63eae@linux.dev>
 <dcfba95b-8cb0-4fa7-a21f-49b595eb92dd@arm.com>
 <ae987527-7ab1-4905-b7f4-8fcc3bebdd52@arm.com>
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
In-Reply-To: <ae987527-7ab1-4905-b7f4-8fcc3bebdd52@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50E74C0003
X-Stat-Signature: k9ehzx9tfb745ay6kjkg57r3xjezd6er
X-Rspam-User: 
X-HE-Tag: 1782116284-107190
X-HE-Meta: U2FsdGVkX1+qZPSQDLnOZSDVV5oES+FCuJynM8Dr7Uh7Wn+cg0/xwvE286EkkDzAXr1dKOlB4aBqqGTPOYOBLAMZYdoo42+rAOJdZ64+SFwVrOdtRpYbtO9pPcvq7h1wtPYgxmj+JofUq+p4PbtiV2VWJZuS/wRGfgNBA9Fv8y2NIHcRxrsDe+HRDJqhcRRBX+IAu+RaVO1kxVBa4fsV2T/JgWSA2bQ5Hy0iJppyjSthdc1V/KeC9llO+FEmlVXtHnAzoFoODcZLFjn2QyfdNBrfvi6RJndBD4/dGUgUwwVCT5b87Oea9Nlkhn52JvzxHHf4wTO01GN6cYyBisziJmGHtnqtjcy127sxKiBZuqUaOynzTs/8F4pWWpfYxovFIgXDmKOvBXQ5wPVSy+MguVTODCX2VDf4dCSu7TIXr/Yvnqomnbr/NBBakAWQMir/1gYVfu30CZsigtfOZrjvw4z96zv/6ew2kWg6u5BUaadC2NqwpHGZg2K3KwpWS1+2B8bjXi2SQDnN3IUP8JeBKMWUL8o1sT//IdD+z2lqnqZGNw660vLJP3KmcTWIfXx4dO4jyb/ytLtGWabn04aX02MCnXXPGGyJ8z+HpxYw2b5ltqH4zRJ+3wqrpBwlKBgU/pikRNfjdPIM2sAqPB69vd15tkI7Y3lCE2Kpaahneuv6Eobh6IWK3ytgY9rXVkcy8c6doxDOSWhDaXNtP6Fv5WtEVD0pwlXgGDPzpQpnZzBGqvW6oLEEZY58N7GdgNr5bH/H9LYRWPZPdpkBN/QqAwQUcdiLLIHBDde19nhmFYhc4A68pXizSiKAy7YdrOfvRrXXv449HvLvY7BrpaEHh19IvWYscRaq4d7BJFcXGrS90p+MKZlnjH5L1vEw4VRe3wsrZtglYnKy7IA8ilVEsFDUOR891SwlnVqZUGSC/eat8XduEDAHWgcJN9kGeAM1hV6FG5xJygBDbfZoeSi
 tcx2wj0e
 xjHodOwqsRC/reE81SyNCblxyRaQtdUZpzZ1gan1Zd/RhYrjOG31o3XtjD2feZd7vLy8OwRjekTAvx/QrIIZsOt8X5kWaLB2iurTv3K1urGJ1Lsk63u+v+pIQiqzAPr52hAQpKSVriwwiMkRAMBGPHAeU4nFoUkRrXcm7ur++c+0k+43SNWs8PGFuIZuz+hkwcS+I+cfro9CdznNDkpqG4NJuXlcNHJVC8xK87mE6dhSXWCi/sOyCD81JhQEEOj48ARLVR79rIRqxM9dK0YoOSDVJOEa9aYPf1wCP0cS25vZdtD2pKLnqJ6RfPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 10:14, Dev Jain wrote:
> 
> 
> On 22/06/26 1:43 pm, Dev Jain wrote:
>>
>>
>> On 18/06/26 3:31 pm, Lance Yang wrote:
>>>
>>>
>>>
>>> Yeah, looks like this was already there before the split. Should this
>>> be fixed separately?
>>
>> Same bug is there in try_to_migrate_one(), check_pte(), remove_migration_pte()
>> and prot_none_hugetlb_entry() :)
>>
> 
> Lemme send a series for them. Main thing is identifying the fixes tag really.

Thanks!

-- 
Cheers,

David

