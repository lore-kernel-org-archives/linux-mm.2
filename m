Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2965DEF4EC9
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9168B6B0088; Mon,  6 Apr 2026 05:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE136B0089; Mon,  6 Apr 2026 05:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8039F6B00AD; Mon,  6 Apr 2026 05:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 719FD6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:23:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF0198B269
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:23:47 +0000 (UTC)
X-FDA: 84627593694.11.4C6439E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1EA97140003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:23:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zdo4RW2c;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467426; a=rsa-sha256;
	cv=none;
	b=kCT2bk89pl7yIsRxk/Nh2i9VYteZiFEKHmXzrdYEoWR2UCUxYxa6JyJ8AcjcLzpn7LwJsP
	Z8bZhufBgt6m7ZUhyN/EvCAa2h9132to7o2wgaoMH70MpVPi3ijNRBdFqSJZUmGsQDjsoF
	t4jGYFzjZ0E+ACXwY3ZyFcB1MYh8XoM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MH0lPvbEZsjy140y8UojXLZwjcxf985NfuZeqVZ6IZo=;
	b=TFEyIuCELvqcwHcdwEeJ1xZOffaObB2wOzJWfARreo0xJmQtX/lc0mAtkbj6GIN86D64zF
	a0ZRUV7zy3Rb86nsx/LbuK8XToTTJMqTEkhtC5BBI7Xg6++Wa3R2ehNq7ITOGeCXzxq5Jg
	kLUaZ2ugbMX+deaMLmDPg8bKT8dV8iY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zdo4RW2c;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B429436A6;
	Mon,  6 Apr 2026 09:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB71C19425;
	Mon,  6 Apr 2026 09:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775467425;
	bh=SQ0GTh8RyULPElvjMm8BF/sb5+Fdu/zQIOIbg8gaNDc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Zdo4RW2cpgdNvxaWum7O5zJkvuGECCZIWKHhZdwFI9HzfU+RtqKSScx6UAyHEEbMx
	 WVNxy/Q/VaNxgs9EWiOietMidqQHMHfn+dPeBZGfTc2q0o25cH6FCf0l+CbOUkXX7/
	 jLDVRsxbouq2NIm15jUknUQzqxHITEiQkjOFe3A3wfpyx1ALgIQDw6IgVqx4U9PJfO
	 OyLyu7Mnh4knUZEPn94IG7NfWinRZjHWXoE748KbIWDQWA0BAnijl3DbKUQqfldY14
	 KfxXYi/6URjSTJ/+U/KnB4z9jt6CDGU0xjhAhhlWnNZhKVfcN2OqyaJVoue3400W5d
	 zre0IVePpDuOQ==
Message-ID: <bc3920be-6570-4606-9c87-4018f0c7ca9f@kernel.org>
Date: Mon, 6 Apr 2026 11:23:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
From: "David Hildenbrand (arm)" <david@kernel.org>
To: Hugh Dickins <hughd@google.com>, xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn,
 Michel Lespinasse <michel@lespinasse.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
 <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
 <8481d0dd-2471-4acc-a429-cbc02451a812@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <8481d0dd-2471-4acc-a429-cbc02451a812@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1EA97140003
X-Stat-Signature: 7aioja3bew4seubnqi98ef4my89symn4
X-HE-Tag: 1775467425-230267
X-HE-Meta: U2FsdGVkX186+M+fjCxlcnh+nwRPuScl3V+USjwnooJ4RjahWfRCyImJAq1pH1VDT9PxyXKPsRTh/6WbpCnCDCYBu/Cc7dg2NF8KFGUXELFGNjUFTqbYjXtVc3HTRhmcNhE1AdnGIuJnj1UHJnMbV+/o25SMrFZN6E3G3ac14+I902Y4s5MkBXKLZ+QstQ6O5Wu5lGqzbG5V0AvtFhMs98QLcUQN7B2gABdbL8xDkWSCnXUlHqm6+bLjOOn1EZiJU+b3gz+H7qIuQdSf+XOwQBOKDdHQbpvnUM1DVCkFnk+B8vxG3NjM1pPavTOdSmOQwrjo00Jh05rwRb5CDBFJkCNqolK5p53x5wzPT/sdN/zrbnqhZMisQG++eO8Sx/u8D133tVwkw8yAEICv7rWO+KB8fga4h6aQoixdX8H1Pz3jy8XskRl+/n+wqc1ue/qQS5chSji7P+MswjNlsBTC7wtEADwv6R3PPa3d5wzisQG0jC/NwAbaJieojZ7yAko7xpx/00+kXiayChSCzuY4OXe3tVbJLgIGKGtFd5hrqmai0WeWFnZOY3vii88ONVNMd1/HrCrQ3y1cbsJUSUknbGk44NiovvF4y1dBwcVv1U4qgYyERFJBzBBFKbRdOdGABDoUKoypoLQGo2liFP5ZovAzaYmTtJa62s5KlBunSSd+VZNsQaf/JclNyggk6vuCAsLY8QTQf4hc8TXzHR0NHRHXdq/CRxmC8BcIHOoWIFnD0Nm2IMd3hwVEV2FFxR3/opVLixhxD5ulZQwwVW8R5XyleKWmaz03RMiFTf9LVZk0Yxqv45RofzdgAUf40d09+6cDgeNnuz6lZeD758mtGsv/HC1aKmOaGiB98kHfa+ojLu5x2N4E9wZoUJBAo9dYhrBbgPnFZHHyj3vx8HYlLCoFJKd1F7wcbsugrOvnoI340CHs+GYZCHBRcUzowtZ1VD94wL48UEd2TIdbaIm
 ShHthxAX
 8ptXH/4tR9rRBmZZ1K/65wx9V1u5VmjzQPxyBZGK9UvvsBS74EBCM1mFefRrsF7+5N2UPejkRBuiV789uIw2ogHDtGVYlu9jnE7r7XkEMQqwFs7xjqTxjH9inTHhWXfJRRpKkgNC835Mr4DeXN89nsjFhcvO8uuL4aql1n8IL7UWCCTy1fWaZsEIyQMXuvb/FPRFSxJHWSvPk25x3Li9bD0nCtTSf1cBQSHpoueRhq6lQt3nOjErN4/vQ5FoWt7Elkcz6ypNi3EpkBaQxWsPks3a/nKFM2g5Fz2D937IJSb2h6OfTdEIta+w5pOuSN8LylSTBdgX0Ywo7A5g7rsscRuxe+6CPeoi5LdeN9HBwWVqmYWKiRgkJ+jmPcXrfllYmkJes8K/4XR3cC+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/6/26 11:21, David Hildenbrand (arm) wrote:
> On 4/5/26 06:44, Hugh Dickins wrote:
>> On Thu, 12 Feb 2026, xu.xin16@zte.com.cn wrote:
>>
>>> From: xu xin <xu.xin16@zte.com.cn>
>>>
>>> Problem
>>> =======
>>> When available memory is extremely tight, causing KSM pages to be swapped
>>> out, or when there is significant memory fragmentation and THP triggers
>>> memory compaction, the system will invoke the rmap_walk_ksm function to
>>> perform reverse mapping. However, we observed that this function becomes
>>> particularly time-consuming when a large number of VMAs (e.g., 20,000)
>>> share the same anon_vma. Through debug trace analysis, we found that most
>>> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
>>> excessively long hold time on the anon_vma lock (even reaching 500ms or
>>> more), which in turn causes upper-layer applications (waiting for the
>>> anon_vma lock) to be blocked for extended periods.
>>>
>>> Root Cause
>>> ==========
>>> Further investigation revealed that 99.9% of iterations inside the
>>> anon_vma_interval_tree_foreach loop are skipped due to the first check
>>> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
>>> number of loop iterations are ineffective. This inefficiency arises because
>>> the pgoff_start and pgoff_end parameters passed to
>>> anon_vma_interval_tree_foreach span the entire address space from 0 to
>>> ULONG_MAX, resulting in very poor loop efficiency.
>>>
>>> Solution
>>> ========
>>> In fact, we can significantly improve performance by passing a more precise
>>> range based on the given addr. Since the original pages merged by KSM
>>> correspond to anonymous VMAs, the page offset can be calculated as
>>> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
>>> defining:
>>>
>>> 	pgoff = rmap_item->address >> PAGE_SHIFT;
>>>
>>> Performance
>>> ===========
>>> In our real embedded Linux environment, the measured metrcis were as
>>> follows:
>>>
>>> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
>>> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
>>> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>>>               and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
>>> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>>>               in a loop of anon_vma_interval_tree_foreach.
>>>
>>> The result is as follows:
>>>
>>>            Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
>>> Before:  228.65       22169                 22168                    0
>>> After :   0.396        3                     0                       2
>>>
>>> The referenced reproducer of rmap_walk_ksm can be found at:
>>> https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/
>>>
>>> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
>>> Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
>>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
>>
>> This is a very attractive speedup, but I believe it's flawed: in the
>> special case when a range has been mremap-moved, when its anon folio
>> indexes and anon_vma pgoff correspond to the original user address,
>> not to the current user address.
> 
> [as discussed in earlier versions of this patch set]
> 
> mremap() breaks KSM in the range to be moved.
> 
> See prep_move_vma()->ksm_madvise(MADV_UNMERGEABLE)
> 
> So I am not sure what you say can trigger.
> 
> But I'm just scrolling by, as I'm still busy celebrating Easter :)
> 

[realizing threading is somehow messed up and Xu Xin commented that already]

-- 
Cheers,

David

