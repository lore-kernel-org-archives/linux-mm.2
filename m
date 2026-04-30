Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44DCFF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 06:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158346B0088; Thu, 30 Apr 2026 02:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109576B008A; Thu, 30 Apr 2026 02:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01EB96B008C; Thu, 30 Apr 2026 02:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1AFD6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:01:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 825214048E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:01:04 +0000 (UTC)
X-FDA: 84714174048.27.388175A
Received: from mail-m82133.xmail.ntesmail.com (mail-m82133.xmail.ntesmail.com [156.224.82.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E805120012
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:01:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf29.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.133 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777528862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e7wZNeIdqdcVXbWA8WjoZbfvaSFmfHvGHbw42MKUXyQ=;
	b=hGVCZAVRflH4zKBl/89miPhDyzgiduRc6sxuyWyalfdIEzMPllBD/yI+RAEdOY171pX1gU
	aBwBFsW51BlBqUXo8mnR0FqQwBIMVQwtvU+w6BcjnquD5LP7z19sJ9hEcyyvflLQLet5Xm
	KriQFkAwGiHOSO1slJfVKKiL51OvoI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777528862; a=rsa-sha256;
	cv=none;
	b=qFEdbSoq47/rbAyGzNUrR5i7hHAq17Q5SzJaaxjVzfBxXTLP6wX58QOP9mgtPaf6uszJIQ
	U8YmRNtzl+7vsfM1Ou98pzpiqmVbkyTWdwIZexnw1iEdZWLe0y2AC7ZjxT2TsNPeuqQjEU
	1dUfKSDOL74jJIUgjXDrL1h8wjNwJSY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf29.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.133 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 199470a92;
	Thu, 30 Apr 2026 14:00:55 +0800 (GMT+08:00)
Message-ID: <984f08b3-e29a-46b4-97c7-a31a7fdb34f4@easystack.cn>
Date: Thu, 30 Apr 2026 14:00:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] mm/page_owner: add NUMA node filter with nodelist
 support
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260430051629.78237-1-sj@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260430051629.78237-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ddcf9da980229kunm439aa7e31f60c2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSU9PVh1DHU1JHkJLTExNTlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5E805120012
X-Rspam-User: 
X-Stat-Signature: 73xqkj4fjx5z1ofcpn7ugrfsi7kd8zfh
X-HE-Tag: 1777528860-389965
X-HE-Meta: U2FsdGVkX1/lPpBSGa5Y2JW6wI9JjSxJoNUO++VtDcfQQoK6pi7uSfZHrbh/CyPvHYuu0sESrUi2OhdqIhhXWB2XSCPTcCZu+8a7qfo5AOFStrFZEHu+/zmLHmWM7FE5zJfVFVuZ6rED8o8QzPx5Lcb1clvH4asuO27FV2oQFeaIQ7Wjve5GIEjdxxiPR3YD/nMTsseIdFJnab2Ehjetqi1bSOwBrRUWFWyc2SszOh6jbzWOGJZpBgJkN2MLkxMFKrW8PIpShTDmgMjw+XeTy/0rnaszRQOwTLeqWl1SoUiyTrCcqkJY9eQ2cj2hB5xd5O38VxpTH5n2uwOoSVU/uGqgeMQ+7VH9l1OHtWeQMe3ram7l0wSFB5fwhztzSnM+fnLyH9QZ1QlGSepNG21qEJxfjfFbZpzrpCaYVX8517JROHBhNejiUPHjitAnLccZkr+uKPnvxlimrkPawTDRJt8sEvhBapanN+7QrEN9ikh7d9aedBA77LITdQpnvUaCSoEAnz3W6pyHpLwPbdR3PN/YAaaWdwmbUTUu2UyQmvQD2vqApsTBXWqL0uK/l9sM4AWCLq1zomq/fHGT8dtO68OGcU0mlvxM65Vwa8+X3iGTM+Qblrk0VX7UD5drc0bA2eNa1gYEB6XkAdfb7KekCOm0ItvJM4zmZn5EYxosTt0lT80eHhbxRVtIhWdBiYwNUrTml0vWZu65VzC8VcrcMqLkkITeVVMnBSZqZA23UcwvmaI+9Q2EgLFCnjBVaKmhA+pNCkooIR2fDOaz7Hw+nnW9PHGaJ3bJJ/YCRJnh9igovPvELD46iC2+PE0+AAlilT5WEFRZ4GXTrL4e+8uBgKqdzqDgO9tNxVVSggC2SsCwOTX9mrChSG22GqYc87EAvl9WvOW+Y9bGeA+wDy9lcH5z71ptjSTJ1JT6QEi7D/louUZFeHRNeweSccYtyIxiGAKhc4ZiAYSUKTEJy2F
 fxF7Kfew
 NyfOxIiEmDuPyr/K8G8HwcGzr30HToN1lXYgWucHtcnnUlDkHTBUQbrg49LaqsdNvCKpUp5S4VP/ZkdLCb7k4Y9Jxe8GSkspDbGtljN8XXe6MJfIV/mW3Vmjv1+9k+GlOBptwBrsy7EBiAwvaxoZyPbLjrM4nUOZSSGOE4WNVlyu8O/SGj+APBZA3if5YcC4X2rOpcQPS5nJiBox+0Qg37ELtcU9Klh1IDqtQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/30 13:16, SeongJae Park 写道:
> On Thu, 30 Apr 2026 11:56:33 +0800 "zhen.ni" <zhen.ni@easystack.cn> wrote:
> 
>>
>>
>> 在 2026/4/29 22:56, SeongJae Park 写道:
>>> On Wed, 29 Apr 2026 17:03:56 +0800 "zhen.ni" <zhen.ni@easystack.cn> wrote:
>>>
>>>>
>>>>
>>>> 在 2026/4/29 09:28, SeongJae Park 写道:
>>>>> On Tue, 28 Apr 2026 15:11:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
>>> [...]
>>>>>> @@ -685,6 +685,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>>>>>     	struct page_ext *page_ext;
>>>>>>     	struct page_owner *page_owner;
>>>>>>     	depot_stack_handle_t handle;
>>>>>> +	nodemask_t mask;
>>>>>>     
>>>>>>     	if (!static_branch_unlikely(&page_owner_inited))
>>>>>>     		return -EINVAL;
>>>>>> @@ -698,6 +699,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>>>>>     	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
>>>>>>     		pfn++;
>>>>>>     
>>>>>> +	mask = owner_filter.nid_mask;
>>>>>> +
>>>>>
>>>>> READ_ONCE() was used for owner_filter.print_mode.  Should nid_mask also read
>>>>> using READ_ONCE()?
>>>>>
>>>> The reason is that `owner_filter.nid_mask` is a nodemask_t, which is a
>>>> 128-byte structure. READ_ONCE() only supports types up to 8 bytes and
>>>> will trigger a compile-time assertion failure for larger structures.
>>>>
>>>> This was actually an issue in v2 - the AI review tool (sashiko.dev) and
>>>> Andrew both caught the compilation error with READ_ONCE/WRITE_ONCE on
>>>> nodemask_t, so v3 removed them.
>>>
>>> Thank you for kindly sharing the context.  Now I understand why READ_ONCE()
>>> cannot be used.  But, is plain load/store safe enough for nodemask_t?
>>> Shouldn't it still be protected against races?
>>>
>> Concurrency Safety:
>> I considered spinlock and RCU, but decided against them:
>>
>> - Spinlock: Adds overhead on every read, overkill for a debug facility
>> - RCU: Requires dynamic allocation of 128-byte nodemask_t, too complex
>> - READ_ONCE/WRITE_ONCE: Not possible, exceeds 8-byte limit
>>
>> Plain load/store is safe here because:
>> 1. page_owner is debug code with low-frequency filter changes
>> 2. Worst case of torn read is temporary inconsistency in debug output
>> 3. Similar debugfs interfaces use the same approach
>>
>> The overhead of locking doesn't justify the benefit for this debug use case.
>>
>> Do you think this is acceptable, or would you prefer I add locking?
> 
> Thank you for kindly explaining this.  Unless others have different opinions, I
> think this is ok.  But, I think this would be good to be clarly documented, on
> the code or the user documentation.
> 

I'll add a comment in the code explaining the concurrency consideration
> [...]
>>>>>> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
>>>>>> +	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
>>>>>> +		nodes_clear(mask);
>>>>>> +	else if (nodelist_parse(kbuf, mask)) {
>>>>>> +		ret = -EINVAL;
>>>>>> +		goto out_free;
>>>>>> +	}
>>>>>
>>>>> Doesn't empty string input to nodelist_parse() clears the mask?  Can't it be
>>>>> reused?
>>>>>
>>>> Yes, empty input (echo > nid) works because nodelist_parse() handles it
>>>> correctly. However, nodelist_parse() - which is implemented via
>>>> bitmap_parselist() - cannot handle "-1" as it's not a valid range format
>>>> and would return an error. The explicit "-1" check is necessary to
>>>> support `echo "-1" > nid` without returning an error.
>>>>
>>>> So the "-1" check handles a case that nodelist_parse() cannot handle.
>>>
>>> Thank you for kindly explaining the reason.  But, do we really need to support
>>> "-1" input?  Couldn't we just redefine the interface?
>>>
>> I chose "-1" to clearly differentiate from valid NUMA node IDs (0, 1, 2,
>> 3...).Since node IDs are non-negative integers, "-1" naturally means
>> "invalid" or "no filter", which is an intuitive convention in Linux
>> (e.g., pid -1, signal -1).
>>
>> Do you have a better suggestion for how to represent "clear filter"？
> 
> Seems my suggestion was too implicit.  I'm suggesting using empty string
> instead of "-1".  I think it is also clarly differentiated from valid NUMA node
> IDs?
> 
I understand your point about simplifying the code by removing the "-1"
special case. I'll remove it and use only empty string for clearing the
filter.

Thank you for the suggestions.
> 
> Thanks,
> SJ
> 
> [...]
> 
> 
Thanks,
Zhen

