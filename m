Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C4FCA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 13:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3666B0088; Sat, 10 Oct 2026 09:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0269D6B008A; Sat, 10 Oct 2026 09:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BC66B008C; Sat, 10 Oct 2026 09:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B46986B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:22:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3AB2A8386
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 13:22:21 +0000 (UTC)
X-FDA: 85306780482.09.C9A4A17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0255320007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 13:22:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MQj5ABtR;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791638540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdlOeBzyuzL+cZQfBPFE/L33JfcDEYwdnatQB2L4s2Q=;
	b=cmRm+ubykbNTaUUZbLhVwhdBxAAwi0OaGA6l21Zb2LziwpVSlS3TkDVaxHgcJHOT1v+YXE
	+sV4a/7yo4xugZtBITBerm5TM/54iRTYEUjs/5i0B9lo1ECkjoYNwiv4wIJ/k60rcR7aep
	C/KsrWI0qdqJzbgN+xtQ1NLvxXs6ldU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791638540;
	b=EMvUaV4yWjOBAf4Vlz5m1NULjT7b5CIIUKnRGTbcLRdlDBaSfzj7S0v8LdbXSzK+CiHw11
	BIzJ6jNB69zYlHIDh4TG0YHKLyzhivEVkLHb1e8Y5uYwA15p8HlDsTosN8V2RLd8GntrZW
	4lSBTTGHI/UB4ah8wBGSMUch4xPWzow=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MQj5ABtR;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A51DD600D4;
	Sat, 10 Oct 2026 13:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411E41F000FF;
	Sat, 10 Oct 2026 13:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791638538;
	bh=XdlOeBzyuzL+cZQfBPFE/L33JfcDEYwdnatQB2L4s2Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MQj5ABtRRkRCBwUU24t/deVILPIJDNLcFf6yVEQQrVCzquJCgzHGFb8kez8EYGzHK
	 fNGk8fT79Wo4U11UdmF7pYk8BLZwIHh9hYQdbQqb/+wHKSgdoEfM8DftQIIvHDaBs7
	 4p+wNxwXBBzc7TsNSdPKBV7RaUqn9Uo0WyOeYlV18jmS+IUIonc/pxhK/LllTckl66
	 MDRJbHA4yVBsgm1KOuVeIo8yl06wr6AQRQMBOfXxrvIoXspMXYu70a6gNocjpwq4Q6
	 U0ZTUfWqrtolEfbT8DB6we3tyfaiXY2QYHM/A718Ff4xLMceOO3tA/DwxZxc2YKiaV
	 dMNbpnGALRq1Q==
Message-ID: <ba74de67-a687-4ccb-830a-ed018d4f66ee@kernel.org>
Date: Sat, 10 Oct 2026 15:18:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
To: Li Zhe <lizhe.67@bytedance.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 akpm@linux-foundation.org, muchun.song@linux.dev, osalvador@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260930064308.58159-1-lizhe.67@bytedance.com>
 <arzVaC2IYkqSb0_U@gmail.com>
 <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com>
 <2b4571c5-8e51-4c91-9d88-11929f200875@kernel.org> <asjVUa6XBZ8ti-0_@gremlin>
 <70ea8ee6-6fc5-4209-8cee-362da37f5035@kernel.org>
 <ab1577d2-a9ce-41db-a632-8e25652dab31@bytedance.com>
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
In-Reply-To: <ab1577d2-a9ce-41db-a632-8e25652dab31@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0255320007
X-Rspam-User: 
X-Stat-Signature: nup56rkuc864ua9jw88iyq5sw8yj53fc
X-HE-Tag: 1791638539-457050
X-HE-Meta: U2FsdGVkX18rBVzgWWU4sWEsUyMlix3wgn/CtDLaobN0mIGXIZrImZZrwfz9NItYeV8Ora0al3ddeLi4zpfHb+JpNPLIdUrRfeOFvk9TdfJRcp/zfPKElUzWefslasjkP0V3oEcyVfAbplyMsOQusiYGHQzQrt3NOSPSXkqTC0U7RS4JdFZyDgA6qaLhbM3G5rAtmBvrk13sjCuh0qUCDZr2g1LnL4HaOiRofdJpKlDMCnuXG4oDm+VRhuRSFZWwCcjlV00OLio5A/yBNTfCP5RuToW9REHFS1QLACNy3iloGBVJJzzxi/1AGBL1jRUi8UOk3TU83evEwhQmLqnMsDwCU/wz9TohSyesbDjwTp/5MnRHWeewZEEBaoOXc1yMcbDcRe9O1PS92k9vFs82tYDoOCJGP18XFIdS9IMevSelpleI02lld/qlEb2X8F/gvaO4HpPj6LGenGQYF25CfOc+GXZDURVD/krd8SsPhmyhP9BKV1AKk6P05QuBIot9sB6t0r7xBLv3Sms5B4whbJAbIFqQJskis60jxsRxWDono6W+EgHERP64eA2eN96W3NliRQPZzlpqdvtjo6+CIUxRNlMZr3mJUcNXXXms0WZgnMmiAIYhnLStn/Z5hMshDxBvjfX9Ockg8H9jOoftQ5Gus+VQRtP7GvRfqzeTfk6j3QsdRBHxnJ3IiSQ+sbxcfM2K5E4ebrlpEZxuOrA6GoGw4b1VdyHlAEvYDjRSmPnoPKkcDmkyWNRVVZQ27SPiLKbZ5MSEx5PcZr6ocnn1J/s0hHU/S8HiEo4+sZCayVENzTiLXyENxOr+oLXt2jqAx77DRIBpfIzsggKYjEgB3fd6Xb5QtVXLbxdV6cFriF6SkZuH2ScNgvSvWFd+u9ATn4IAyHbIRTFNe4fgvb/uZFAwpaDGgC+NUNuhjVHbEcTBFWnNlfqn7QyNL6d9ktF/niUMUciTI9orQANde3S
 7lChMqC/
 goIgvIpcA+7BcycmqAG+NrOolFMJ7IyVCsfWirwTugFwBIL+lXfsl7fZKhNcuMWPONHT6vbI/fY/RZ3shDxTzwWr9EULI4RA7+5CYQVDIhEXypeJWjW0eQwKASZMEBQmvner6oHddtv3v20h+ItTqyQubFwjcYSEdql8O5KcB4HZkq1mLnJ+KqTfTM7df7FPS/5aWOukQuoLU/55j15X4UVBaDw7EmbRbRc5Ga8JeR3XbIzrcNU0+34bcudRuGaPV0GF5AmrkrPHCCxaRpyOlIibEyxcw+6oWDsrtiv63N88YrLE3i8io7YHmlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 08:37, Li Zhe wrote:
> On 10/10/26 2:05 AM, David Hildenbrand (Arm) wrote:
>> On 10/9/26 13:52, Lorenzo Stoakes (ARM) wrote:
>>> Yeah I don't see why not! I don't think there's anything that needs to be
>>> private here.
>> Li, see below, can you work with the below?
> 
> 
> Thanks for the patch. I tested it with my original mremap reproducer, and
> I can no longer reproduce the hung task.
> 
> I also checked the hugetlb_change_protection() / uffd-wp path Jose
> mentioned. That path can reach hugetlb_change_protection() and
> huge_pte_alloc(), but it does not enter huge_pmd_share(), because
> VM_UFFD_WP makes want_pmd_share() return false via
> uffd_disable_huge_pmd_share().
> 
> My understanding of your patch is that we preallocate the destination
> hugetlb page tables before taking the mapping's i_mmap_rwsem in write
> mode. Then, while holding i_mmap_rwsem, we only walk the preallocated
> destination PTEs and move the source huge PTEs over. This avoids calling
> huge_pte_alloc(), and therefore huge_pmd_share(), while already holding
> i_mmap_rwsem for write.
> 
> Does that match your intended direction? If so, I will go through the
> details and make sure there are no issues, then send a v2 based on this
> approach.

Yes, please. make sure to keep Lorenzo's SOB/authorship. If you perform
modifications (patch/commit message) add your co-developed-by + SOB when sending
it out.

-- 
Cheers,

David

