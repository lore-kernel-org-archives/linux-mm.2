Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB16CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91ACE6B008C; Tue, 12 May 2026 04:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F26E6B0092; Tue, 12 May 2026 04:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8308E6B0093; Tue, 12 May 2026 04:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7761B6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:16:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F7B0C1ABD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:16:47 +0000 (UTC)
X-FDA: 84758061654.23.1BB6092
Received: from mail-m827.xmail.ntesmail.com (mail-m827.xmail.ntesmail.com [156.224.82.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id 11579C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:16:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.7 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778573805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/s7JToIEM1lk9n9xit6JfYgrDXHLsVhXbFD4cNbBEM8=;
	b=ocr3Ar5RKgrRjQLhmAK3cj7tsmpF1JY36kruvMZuv7RtO44IQDC3nL3bHsyqTJgGneVG7y
	emQI5mjEx9tl/HML/u3CDAef4zAZUFR/F//70tKzMdDxcX7juNXzFe3bXm854E8RNiYfTt
	KVygW7ZhxEWWfrlE4IiUxukgUmZuL48=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.7 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778573805; a=rsa-sha256;
	cv=none;
	b=kLPeOThkRG3kzCbpzxSiMKEGzd3Gs7s6u0rHJOUAFgdYHTjfrlFF/IbaXqOAF678IzXMZe
	9J3/LcsOUbdu/Tbf94dNAVOXvjlc33XemaNUbQdbVdN1ZWYfjUrwjH5YQnYrvsiMvs9U5O
	AhlT4umZisC2vjleBdFiLkEL/wxyOH4=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a0401d4f;
	Tue, 12 May 2026 16:16:37 +0800 (GMT+08:00)
Message-ID: <d5bd3927-3f80-4ed7-a8d2-0b7d58139286@easystack.cn>
Date: Tue, 12 May 2026 16:16:36 +0800
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
 <4a06f50f-fb7a-4b5a-a9d7-664407f83472@easystack.cn>
 <agLWHkhlkBotiLYM@tiehlicka>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <agLWHkhlkBotiLYM@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e1b4266d90229kunme41633f242f17
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSRpOVh5NT00dSRpKGU0ZHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11579C0007
X-Stat-Signature: hpqg6w3abs4md8x8o1zp3ddg8dsem688
X-HE-Tag: 1778573802-249038
X-HE-Meta: U2FsdGVkX19Fb4hdSH/5fVHhVWwAlmHLfnr6uYszLHtY7Ai8G0bDkzUBRq0VIqnUq0GZDvWmIy35HbebkqNAqDSugfbkk3hgmnLERH4aC6QOcYew7IM8DXvaF+F7eRkw0tUu5CKFRVy7b89h1y82zJsqWQwp9wsoP6eJNp0jaJW2+L+j+brIFQYHiL9C61KPrBgpjo4bcz8cmWHBwxiqDx7qecJEIPRpvfV62kHiWZyXL/9t60gSkaw9hIAyxrls6ttJdh+keJCNPt8c9bakwvIWOKjYHxQRJ92pJrxRAn/sa0Mtmf++hKzLQDRjE/cywhmtS8TUt76N/UnXCtHhXmS0pYLbE9+YOWSgY9dkRlrV+QBvNy4udvhUTDG3oxS8Sg8r3VKQcD5o4IyN7sdw2IM+uifevidm+tyIp6GsBsPQ/DHYPzmrn54YMeAa9Zv+a/xfFvyrPxq2yHazXf8mBYiLBzZmWoBJRXh2ocsR8uVaXM4Y1mda4buPq7srwNXCnZPs0XWQ/SYe6tDka96BI3LzRPKkkCx6uz5H4abVtZCeNYMvvkrzc16y7cER4XqWG+ZdLmt+uRLCjvucvMmu+m5SshFRVaN3aS+RdTGvYiJjHOC8Eb/l82hHVFCwflLxnMyNEMnyRdX9PMiiAEVBI48tWGsL0oHTi8lRDYqwzfO9WfE+U5Lw9JcDfaVa9Q0F+TV/7gw27++qg69KPiAG35b2bljQ2LMCwLKYc74aigZ5EaCA8EYhQ0qp1vJ/tIzWq12CGTaOQBAx5e5W9cNBbd0RJMzd3Q+YPRkEGBVgaWtw2hf/i6ln+YO20vWsXWPl9X6Je84Y/NfoiP7dOGPZVmxzbtDe4D3IXqI0Zh/rwytP4XgN1OYOxTlQJjNKQDHyWag+9bP8QZmxvsHNUjadlo8za6rYHfrh8yFcdSqAnGy5hSM2q04PLi3RqlNCPk1XsR2iyZXMvswuN3lqZXu
 oS+TKSwy
 PDR+mNTRm7+2wz7s3daCU6zRgwzCROzCyQXeEffB8AS67gZBC6bRTluN0pwMS7IfUl1aYd1B1cIEItsT1z3AiVp1aXpExMXjXgKfZusaTkRPdjrcvXqojLDCOhuPcTisHXk9m/WvKSCa47W6HcyWxwwJIiRHUh57T5rR1SEvaCJHoi0nDkBM55rvYtt1AKya11MT8lZrczk8U5mDjER1o9Cip2Gh4IM8/2kRW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/12 15:26, Michal Hocko 写道:
> On Tue 12-05-26 11:11:47, zhen.ni wrote:
>>
>>
>> 在 2026/5/11 20:54, Michal Hocko 写道:
>>> On Mon 11-05-26 20:40:07, zhen.ni wrote:
>>>>
>>>>
>>>> 在 2026/5/11 20:23, Michal Hocko 写道:
>>>>> On Mon 11-05-26 11:30:14, Zhen Ni wrote:
>>>>>> Solution
>>>>>> ========
>>>>>>
>>>>>> This patch series introduces a flexible filter infrastructure with
>>>>>> two initial filters:
>>>>>>
>>>>>> 1. **Print Mode Filter**: Outputs only stack handles instead of
>>>>>>       full stack traces. The handle-to-stack mapping can be retrieved
>>>>>>       from the existing show_stacks_handles interface. This dramatically
>>>>>>       reduces output size while preserving all allocation metadata.
>>>>>>
>>>>>> 2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
>>>>>>       using flexible nodelist format, enabling targeted analysis of memory
>>>>>>       issues in NUMA-aware deployments.
>>>>>
>>>>> How does this work when there are multiple consumers of the interface?
>>>>> E.g per numa tool to watch node lock page_owner information?
>>>>>
>>>> I understand your concern about concurrent access. Are you asking
>>>> about this scenario?
>>>>
>>>> Scenario: Multiple tools monitoring different NUMA nodes
>>>>     Tool 1: echo "0" > nid && cat page_owner > node0.log
>>>>     Tool 2: echo "1" > nid && cat page_owner > node1.log
>>>>
>>>> The current global filter implementation would have race conditions
>>>> in this case.
>>>
>>> That makes the interface rather broken in my eyes TBH. Is there any way
>>> to make the filter local to the fd?
>>
>> I agree that the global filter state creates race conditions for
>> concurrent consumers.
>>
>> Regarding per-fd filters, I've looked into this approach. The main
>> challenge is that per-fd filter state would require changing the current
>> simple usage model:
> 
>> Current usage:
>> echo "0" > /sys/kernel/debug/page_owner_filter/nid
>> cat /sys/kernel/debug/page_owner
> 
>> Per-fd implementation would require:
>> - Add ioctl interface and allocate filter state in file->private_data
>> - Change page_owner_fops to add .open/.unlocked_ioctl callbacks
>> - Provide user-space tool (e.g., ./page_owner_tool --node 0)
>> - New UAPI header with ioctl definitions
> 
> ioctl is one option. Have you considered to write the filter state to
> the page_owner fd to create a local state?
> 
>> This would replace the current "echo + cat" interface with a
>> tool-based approach.
> 
> Which doesn't sound all that terrible comparing to a non-deterministic
> behavior of this proposal
> 
>> Alternative: Simple mutex protection to serialize
>> concurrent filter modifications. Though this doesn't fully address
>> concurrent reads, it could mitigate the most obvious race conditions.
>>
>> I'm wondering if you have any thoughts on the trade-off here. Since
>> page_owner is mainly used for debugging (typically not in concurrent
>> scenarios), would a simpler approach like mutex protection or documenting
>> this limitation be sufficient?
> 
> The thing is that unless you own the whole machine you never know who
> might consider information from page_owner interesting to filter and
> read. So you might easily get garbage. Not completely terrible
> considering this is debugging interface but I believe we can do better
> than that.

Thank you for the feedback.

I've been thinking about the per-fd filtering approach you suggested:

## Implementation Plan

1. Add per-fd filtering to page_owner file
    - Add .open/.release/.write callbacks
    - Each file descriptor has its own filter state
    - Write filter commands: "nid=0", "mode=stack_handle"

2. Provide user-space tool
    - Simple CLI: ./page_owner_tool --nid=0
    - Handle fd management internally

## User Experience

Direct access (default: no filter):
   cat /sys/kernel/debug/page_owner

With filtering:
   ./page_owner_tool --nid=0
   ./page_owner_tool --nid=0,2-3
   ./page_owner_tool --nid=0 --mode=stack_handle

## Benefits

- Completely eliminates race condition
- Per-fd isolation for concurrent access
- Correct design for multi-consumer scenarios

Does this approach look good to you?

Please let me know if you have any suggestions or concerns.

Thanks,
Zhen

