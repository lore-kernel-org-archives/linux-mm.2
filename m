Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE076CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 03:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E041D6B0088; Mon, 11 May 2026 23:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4D86B008A; Mon, 11 May 2026 23:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB5A6B008C; Mon, 11 May 2026 23:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BABCE6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 23:11:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E1C7160343
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:11:56 +0000 (UTC)
X-FDA: 84757293432.25.83E559F
Received: from mail-m823.xmail.ntesmail.com (mail-m823.xmail.ntesmail.com [156.224.82.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E063180005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:11:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf24.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.3 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778555514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7BKXux8owAFx12ihe2oC1OFI90m3jZ+a3m844z78Cc=;
	b=8YTmW++WwfB/ed2WvpPrETqo2+Iq9Hrud1Lp+GXkrXB9k5mHcGRzdrWJCFfLEcqzKRDSkq
	KZg6hVxR22lPkEo4C9dAgsLMnzss7bv8f4H0YhnrhLaFpk9Tq9dMDOEh2WDyLX+dV57cRD
	5BDC6QioFrMaG0apszAcczB8CNWnCZM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf24.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.3 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778555514; a=rsa-sha256;
	cv=none;
	b=jSrn1sjmRqrssBfc3CxfWtvC7rIDdElLMBdN82wm17JOJFtHn15Jz7Uxtbv1sWNfjj/8sD
	1x+wmXP2jTwMSoOGe7QzdKCUf5y+bOkhQLo3WtsrIdV2SLa8pxC085jEEHQbimXO9Cxi6e
	U5EWp5a876sjq4IfkZO1ctg/W6n+mNg=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a00190df;
	Tue, 12 May 2026 11:11:47 +0800 (GMT+08:00)
Message-ID: <4a06f50f-fb7a-4b5a-a9d7-664407f83472@easystack.cn>
Date: Tue, 12 May 2026 11:11:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <agHKWCw3CFO0CZ_E@tiehlicka>
 <d19c927c-4af7-4c2d-8c62-82b8fc841089@easystack.cn>
 <agHRhlfIYbaqHHMK@tiehlicka>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <agHRhlfIYbaqHHMK@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e1a2b54b70229kunm95556d052beb2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGE8dVk9OHUhJTh5PH0NDSVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Stat-Signature: 87bgngenfsiwd9u476qgnyedzg16mbmi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E063180005
X-Rspam-User: 
X-HE-Tag: 1778555513-580906
X-HE-Meta: U2FsdGVkX1/EDprk4aavCEcU0mAYci3nNQ44LldCMyzoL/JK54NYPobzJsVL8YbS0nYlTKksMaY/42aWid+nX4+zSGtu+ijcJDpTBaNHAw7b7l5/ZJdFFwOR451oK6SOJm3pinrIS0/0p89WsJK/tFQEYyj+1inCbfVSnIudUfd/RjTug+xmpMV9zfeXhwGruk+m3FM/tgM4mz+Tz4t5LrDWUZNYXNtD3gGcSGNeG48N2IvDAHtLckPNZ0/YZ8xt5Fw3NSUihbC87daDG4DAyv5y3a78VCwjEA1GONeN+eATF23GODCysf420ZuYhp2nHP5Qsj2M68dKJXrVxqxJdrj3jIE2sKvKSs+B1S+Z9yG88EQaSMeDLFTdlvoFM8Y9JPow7hnwE2O9au9AQtKX+63AJERD6OFUdbfgR+fwRnCSpu4+YMxD9HPxGxuTfGpA8ol+1nVn8ILpplgeSnQmDva+rt/wbopYEFhW8iEvvdusookvkgsGuyUQATwv/ewFJWyjl6GlvA+0HoBra2adrflPzXgTfbRmgfleHn7KZTclpVwy70GrHgvN1tgzQ9F2e9CyPAYg3v855xlz6q1PDzPda9e5mK2/tEDTUKcfewAE0g2i4T0JmFYRV7CeLOo+cmchzG39mRDIBiyNRlOahp3jZcSjhr0rwGlTtNc1VW6+dTTSu/HnRFm8ResJydHHhaig224QHF3mnJu29DOTUm1HGnVurA5wWoiQvrbcF4VOD8zm1pUPfkNZ1DKQOHENfEveRJfWH09hqCE+euYJCof47JXnb+qlu8Ig35ecenQglwrZ7EnFHD69FZtEJdd7uNDpNuwHlEDJ3RXni9NOP/B4ewxwGPAJsDO819j8icJH4D3I6jEjHDRzPyKHYjb/ScFI4EqkkmF18NBdOf8wtIzbU7bKH98NTNJBaKEzqoESE7dY0H33N0EDAlTupucHq02DXiSOuXFxxHdiHMr
 V8WC0MgT
 zTyKH2BFUF5nINqwWmfQZRiKNcSRmbLSnIHJonfOTLV9mhslsBKeTLavknlHk8A99OIxZypWWVVYpaa3cp/961jEddzEToEc5YVucPQsiC0COn4/+U3PiYSR0KLYEIbshXq7qyv90GRPxCqVllJL36IGEAWtbfjQKf6LnLNzD4zaIKcveOeaDcWZWJywNrOegvUfi7bBUBO1GcjepcsWma0oRfAdtDp6oFEhO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/11 20:54, Michal Hocko 写道:
> On Mon 11-05-26 20:40:07, zhen.ni wrote:
>>
>>
>> 在 2026/5/11 20:23, Michal Hocko 写道:
>>> On Mon 11-05-26 11:30:14, Zhen Ni wrote:
>>>> Solution
>>>> ========
>>>>
>>>> This patch series introduces a flexible filter infrastructure with
>>>> two initial filters:
>>>>
>>>> 1. **Print Mode Filter**: Outputs only stack handles instead of
>>>>      full stack traces. The handle-to-stack mapping can be retrieved
>>>>      from the existing show_stacks_handles interface. This dramatically
>>>>      reduces output size while preserving all allocation metadata.
>>>>
>>>> 2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
>>>>      using flexible nodelist format, enabling targeted analysis of memory
>>>>      issues in NUMA-aware deployments.
>>>
>>> How does this work when there are multiple consumers of the interface?
>>> E.g per numa tool to watch node lock page_owner information?
>>>
>> I understand your concern about concurrent access. Are you asking
>> about this scenario?
>>
>> Scenario: Multiple tools monitoring different NUMA nodes
>>    Tool 1: echo "0" > nid && cat page_owner > node0.log
>>    Tool 2: echo "1" > nid && cat page_owner > node1.log
>>
>> The current global filter implementation would have race conditions
>> in this case.
> 
> That makes the interface rather broken in my eyes TBH. Is there any way
> to make the filter local to the fd?

I agree that the global filter state creates race conditions for
concurrent consumers.

Regarding per-fd filters, I've looked into this approach. The main
challenge is that per-fd filter state would require changing the current
simple usage model:
﻿
Current usage:
echo "0" > /sys/kernel/debug/page_owner_filter/nid
cat /sys/kernel/debug/page_owner
﻿
Per-fd implementation would require:
- Add ioctl interface and allocate filter state in file->private_data
- Change page_owner_fops to add .open/.unlocked_ioctl callbacks
- Provide user-space tool (e.g., ./page_owner_tool --node 0)
- New UAPI header with ioctl definitions
﻿
This would replace the current "echo + cat" interface with a
tool-based approach.
﻿
Alternative: Simple mutex protection to serialize
concurrent filter modifications. Though this doesn't fully address
concurrent reads, it could mitigate the most obvious race conditions.

I'm wondering if you have any thoughts on the trade-off here. Since
page_owner is mainly used for debugging (typically not in concurrent
scenarios), would a simpler approach like mutex protection or 
documenting this limitation be sufficient?

Thanks,
Zhen

