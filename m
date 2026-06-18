Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5511CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5873F6B00A0; Thu, 18 Jun 2026 04:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537D66B00A1; Thu, 18 Jun 2026 04:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476D06B00A2; Thu, 18 Jun 2026 04:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 191D16B00A0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:21:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9229A1A06EC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:15:33 +0000 (UTC)
X-FDA: 84892324146.08.58B3ADC
Received: from mail-m82143.xmail.ntesmail.com (mail-m82143.xmail.ntesmail.com [156.224.82.143])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79FBF1A0009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:15:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.143 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DcURhIpi8rfjEV1hhbDPfgjfTHFjrhYTEx5KBRr8im4=;
	b=gxYp23x0ECdXgHyBj7XnFOZ5MTUeQf/gMaoZrO+MoUc8EspdKKwi9AAEVQp6v/cyB0TsKu
	MhN9tAb5oDEL8jZnwb01iJQVsm2xu+NrgqtsvyCdhhiOGS3adEYU0FGw8t7/DLsFnWCEYg
	IqGVcf4KmOVaHXpqQv3WlS5VKbqby7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770531;
	b=Wq+j6OQ0x+bWlqhBBV6OjXs3AgaT2YsfZkOIPRX7fdPQa30Lgg2uF+DgLoRZMQTj9Q7kcf
	w1STETx85pGWhZIpcD7IwchLvbc/sLjkTilKq3KjBMG32An6QlcfxPd4QAAMKEd5041WkX
	NnnaRx6L3zNPwq6CjjAYoQs4uVbUxpc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.143 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b9c16d16;
	Thu, 18 Jun 2026 16:15:24 +0800 (GMT+08:00)
Message-ID: <444a6fd9-26dd-4d33-b836-987ef220b5f2@easystack.cn>
Date: Thu, 18 Jun 2026 16:15:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
 <20260525125819.1857f215bc56b26a0727bedc@linux-foundation.org>
 <5ef656db-c6b6-4a2c-b6be-628e5214952f@easystack.cn>
 <7b2125bb-c2d6-4678-9ae3-6f4e93034391@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <7b2125bb-c2d6-4678-9ae3-6f4e93034391@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed9cc95400229kunmf11eec17f1bec
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZT0wYVktLGUgdGk4fSkgZTlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Queue-Id: 79FBF1A0009
X-Rspam-User: 
X-Stat-Signature: tzspzwpr39fwma7dj7qrdk7w5k5bi63o
X-Rspamd-Server: rspam08
X-HE-Tag: 1781770529-472317
X-HE-Meta: U2FsdGVkX185FWhFJIg0r/goZKUUYVVKnTcA6gygkjlZvm+Tk6fXAuXykIYH21NETRIY8kdpNutUbVw7xey1uz6wqHkFRA0/iSgxIYQdHvlrVpPSBk1G7HPuZoKwGj7PU/cgOqTfOif5GfR5VIDdykAI4rhgn6AuyEz6+mV3XoWuY7TZmb31jbK7FT5xJbGSJOgzHdUI5Ycfkmny3pINPFvF4NbgZ4qssIrKgcBnwchS2Cofr3TTgT0un5dkP/fZPGsCmOdCNEVHgYMSTC+wSrfqLXmxaXD/7GGMyNdc4MHdmbd8iVtu9+V5qlyj8APmvSiXGkLAy+ZwC/3EddJINHV9cGhsC8RdFUJpq+zGfo0a97I1mWjJjHYyf1q2D44H/Qdm5tSo9EL8SSMbGq/7E5P2fIYvbEnslayMeY2Kr3zPJxk6TgB0/pkjQ5AxdQA5isZrfLH/ekfE0Il2K1ZbsIZR/TqeiEmfEToOmGeJgCZTkb4eV3r2YJvMmpI88yKVVCW4QW2FxOfBSSgcdQfAIk0aWcZHVfwoU0tPqGCK/csNv5FZXpz2Ii2NNzqZTJ3gpggFBFqM4Je1d4hFog2GOF4/Roc8s4PjE8M+kql6ZdCzC/d+4hlRRGIgT2agKJ/aqkqSgPbZb/HHvBzS4j+a5ztNWxdNS0xAVCvAP87HuRxeZoaounBkndVUdze5gB4AFwIA80tA1qwDw3VAvgr3e7CHZyIYYvqv40aZikkJPcn0CBjIubG3RI8GFeBx2eWo1+zuSPFrF65mFpIsF+9FI9I/M3IR8objqG9sCwZeJvrBx8XSH08cnBHQhAlbyRTH7z9k8SzsCDrgq0XHw60QfRg9aDsGnu0SrsMQXOe1c9IlVtCkrFNRYIOHDlGQ4L9FWsX3qhOB0cjBIR+jFa3zgC+e0aXnKdAO1Msem//9RjzCPpa5RpHNu8mtRPTfgnI1jzxeAYNXYd/Lj+UeddO
 p0gwupP4
 vFZEUsg3Q6n/PJmNGMEyKFej5dAzT5D1R8ekTDIyIwv7bL4HAWuMNYvmrNlf9gZ1gQrm/qb8db7hkf1x1xq1FgSts7asgT758YfGmLdDMB845AK/ngWwMT0jvxIRkKgn+KpwuoH8lCp/TemlezcsRx6loCQ/L9dK1M6EKYqPC0T+ComFQi2o9hGFa8V4qXEccmfwAcNMWov2Ac/t2AKXH0zLo2MMOWw+q0ttkgEagriJAHI+tFFsikFGwiPIApxVcC4gRs685OgEqj+taIEKL5Zp1QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/18 15:27, Vlastimil Babka (SUSE) 写道:
> On 6/17/26 10:52, zhen.ni wrote:
>> 在 2026/5/26 03:58, Andrew Morton 写道:
>>> On Mon, 25 May 2026 16:16:48 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
>>>
>>>> This patch series introduces per-file-descriptor filtering capabilities to the
>>>> page_owner feature.
>>>
>>> Thanks again.  AI review has found a bunch of new things to get worried
>>> about:
>>> 	https://sashiko.dev/#/patchset/20260525081652.2210206-1-zhen.ni@easystack.cn
>>>
>>>
>> Hi,
>>
>> Can this lead to an out-of-bounds memory read?
>>
>> The NUMA filter in page_owner (mm/page_owner.c:790-798) bypasses
>> PF_POISONED_CHECK() to avoid triggering VM_BUG_ON during concurrent page
>> allocation/free:
>>
>>       int page_nid = memdesc_nid(page->flags);
>>
>> When NODE_NOT_IN_PAGE_FLAGS is defined, memdesc_nid() performs unchecked
>> array access:
>>
>>       int memdesc_nid(memdesc_flags_t mdf)
>>       {
>>           return section_to_node_table[memdesc_section(mdf)];
>>       }
>>
>> If page->flags is poisoned, memdesc_section() can return a garbage
>> section_nr that causes out-of-bounds access.
>>
>> ## Lockless Access Safety Principle
>>
>> The page_owner iterator runs without locks, meaning pages can be
>> allocated or freed concurrently. The fundamental design principle should be:
>>
>> "It's acceptable to skip a small number of abnormal pages, but panics
>> must be prevented."
>>
>> In lockless iteration, TOCTOU is unavoidable - even with reference
>> counting or RCU, page->flags can still be modified concurrently during
>> access. Zone locks prevent this but are prohibitively expensive.
>>
>> ## Proposed Solution: Add nid to struct page_owner
>>
>> Record nid at allocation time when page state is stable, eliminating the
>> need to extract it from page->flags during iteration:
>>
>> ### 1. Modify struct page_owner
>>
>>       struct page_owner {
>>           unsigned short order;
>>           short last_migrate_reason;
>>           ...
>>           pid_t tgid;
>>           pid_t free_pid;
>>           pid_t free_tgid;
>>           int nid;  // NEW
>>       };
>>
>> ### 2. Record nid during allocation
>>
>>       static inline void __update_page_owner_handle(struct page *page, ...)
>>       {
>>           int nid = page_to_nid(page);  // Safe in allocation context
>>
>>           for_each_page_ext(page, 1 << order, page_ext, iter) {
>>               page_owner = get_page_owner(page_ext);
>>               page_owner->nid = nid;
>>               // ... other fields ...
>>           }
>>       }
>>
>> ### 3. Use saved nid in NUMA filter
>>
>>       if (state->nid_filter_enabled) {
>>           int page_nid = page_owner->nid;  // Direct read, safe
>>
>>           if (!node_isset(page_nid, state->nid_filter)) {
>>               spin_unlock_irqrestore(&state->lock, flags);
>>               goto ext_put_continue;
>>           }
>>       }
>>
>> ### 4. Update nid on page migration
>>
>>       // In split_page_owner() when page migrates
>>       page_owner->nid = page_to_nid(&newfolio->page);
>>
> 
> This (presumably LLM) suggestion is a, let's say "lazy" solution to the
> problem, leading to more memory usage. I'd be surprised if it's not possible
> to read the nid in a way that avoids the hazards. If page_to_nid() can
> trigger a VM_BUG_ON(), then I'd add a version without that VM_BUG_ON(),
> handling the poisoned state gracefully - if it's poisoned, return e.g.
> NUMA_NO_NODE and skip the page, or something.
> 
>> The remaining two issues can also be improved. If there are no
>> additional comments, I will proceed with sending v10.
>>
>>
>> Thanks,
>> Zhen
> 
> 
> 

Thank you for the review.

I'd like to clarify that the "nid" member approach was my own design
after careful consideration of alternatives, not a suggestion from
automated tools.:)

In fact, LLMs suggested approaches like "check then access" which I had
already implemented and rejected in earlier versions due to TOCTOU
issues. The key insight is that page_owner serves as a buffering layer
for struct page,  eliminating lockless access inconsistency entirely.

Think about it this way:
Even with extensive checks, page_owner->handle cannot guarantee the page
won't be freed when printed. The time window between checking
page->flags and accessing page->flags is unavoidable in lockless
iteration.

By recording nid at allocation time (when page->flags is stable),
page_owner becomes a "consistent snapshot" that can be safely accessed
without locks. This is the same principle that makes page_owner work as
a debug feature in the first place - it accepts a small inconsistency
window in exchange for lockless access.

Alternative approaches (adding poison checks, bounds checking) cannot
fully eliminate TOCTOU in lockless code - they just reduce the
probability. The buffering approach is the way to provide both
safety and lockless performance.

Thanks,
Zhen

