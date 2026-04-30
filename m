Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8BAFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7176B009B; Wed, 29 Apr 2026 23:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70E16B009F; Wed, 29 Apr 2026 23:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F6F6B00A0; Wed, 29 Apr 2026 23:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9029B6B009B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:56:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CC5E1A0264
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:56:43 +0000 (UTC)
X-FDA: 84713860686.09.AABA56F
Received: from mail-m82107.xmail.ntesmail.com (mail-m82107.xmail.ntesmail.com [156.224.82.107])
	by imf08.hostedemail.com (Postfix) with ESMTP id F046B16000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:56:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.107 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777521401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WJXK7XpNbUd/Wrh8HKhiDkneq1sHed3THuPes2yapcU=;
	b=HZx1Tqw3LqDiWBFRcbCiDUeM0fcibGgqkx+hNyOYL41v/ILTmFHvr8Q++djc+onpn2JJzl
	3RvYdKiY4ckQicgC4dUh34flTlrGWjSCFb0s98tDFLVGkwtPtvm3UKp0Ptuy5/dRuYaxbg
	PJN3LlgiPfxxi0fHql34bLqu3VsaKeY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.107 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777521401; a=rsa-sha256;
	cv=none;
	b=P3V6HbUm2LHnuH3dVsjzAPI19n3ltAhAoTZnwDUapIp2dMXQ8QE5bztt8TX1DxPagZ9rDQ
	Urfxdve9P7sfKbj+48qMz2wGTZS41+1jCNLb6OD5kTm62VZ/UluG1FRMtBZoepu1G4EKcK
	kD4jtX7dZCIrCeiyzAoEi2trsZm2Pk0=
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19931ff17;
	Thu, 30 Apr 2026 11:56:33 +0800 (GMT+08:00)
Message-ID: <f2d8be6b-d19d-402d-ab53-b40639c66146@easystack.cn>
Date: Thu, 30 Apr 2026 11:56:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] mm/page_owner: add NUMA node filter with nodelist
 support
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260429145645.80675-1-sj@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260429145645.80675-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ddc88001b0229kunm611f0e101ee38e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSE5MVkpDT0lKS0wdGEoYTFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F046B16000C
X-Rspam-User: 
X-Stat-Signature: fqzmo6psmt6quf743dpudkjyiwdozbwy
X-HE-Tag: 1777521399-664702
X-HE-Meta: U2FsdGVkX1+HS00A6rusDrw35VCvSIjWd/Fahd3ZQAoI/GlqGwQwSUpxd3T2Pg+4VWdtrjHEuELPxY7BP3G2KGz9yzuWNz9nq6RMn+QumHC8pxX9S1eOshWSvOXwiCYdxn1RCKfo+acxYs1Xee+Rh4Z4jKLhSaOMs4ingUZmO+vZWfplfjj/BFC0deAE4IdWnGeTJvoh4/fJkyx+45o7qRDBCkNSdOXFBXdfLeT51iXl7axAtyi5c4kRHuK7K+uhosg3D9Nzku8k+8/P1aRGBRDOM2ge5+FEw5KL6Rs1XMkYWiWQbnZp3FWivgVE05oNn146olrCrkOIitnGF6DCyC+5weMw+6mtL5ib5yEONYTLF6U0U//JJuxnMyn6iLEx1EEeIYYgNHG1ME7FF/L8sVBpjb8OfByMhoGDAXfWIrWnSgvUOkNvExLpmty5i1KGuf91r4LyWYSqb0Mukf3UEgcZFW4qIt24L/BjYRtoRmbjcM7Z6W1dOig+nV0sJz3bLm8iUb71rUVyGODuWBmwJIVNiGLU8Ovmk03cwdITvAizb5Cp1rCxEq4xMcE/3u4pzVj4dYtxVOxxNcPffSdNFr23VfIJjr/b1lmZj1IOclq7AhIRGPoaefjjYdRJB6CAinq266lDhizsoyGCZ+ihpA4Z2jXcH9qaPelBeAF+gqhq39tCJWu6xlhikzKiCpy1OANDd55ZgTf1JCk9FKsjAp5HPz4f+ta93i2RC0YDYEX1YonCBZiKWh7HGQCN0f1QhtIWqXGg127w9zJ/FOSvZ9o2CCyE3HfnTD5O0sofgHJn0K5C620hX7Sbp2yaVUSyhS/ve65bWcv3xSZuB9+ZevzoRRlPrzenvu0WTiw6D6qfxHhTkKWTu8Ci5pZIoJeq3kqpDSC9Lzxcbh/+EJAsiS/kHlLVVpHFQcn/hlEPIl9C3kor3sLLc6tjXmwa1cAuAzccG3Lixawecf//9g7
 +jHQB/xJ
 S5Y776r9yy9e6/noYBvrWUteptrPOhB7iVR+YI7hqrg/6y7zaKEo/NdDkanmI1x65OGxtG6gjDxRLyMfCP5/qLNcxEcTzYUokduHCtlp/fHq+fsvzN3MUlownVtv+/teF+E5F160gTOw7aj0175BG7rHSEqCW24jatGe7cl/s+A7m126eM7TH2K7RBPeFyseXl37gVD7P1n5Ql5cApebWuIrKMSDtMSeDnpCj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/29 22:56, SeongJae Park 写道:
> On Wed, 29 Apr 2026 17:03:56 +0800 "zhen.ni" <zhen.ni@easystack.cn> wrote:
> 
>>
>>
>> 在 2026/4/29 09:28, SeongJae Park 写道:
>>> On Tue, 28 Apr 2026 15:11:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> [...]
>>>> @@ -685,6 +685,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>>>    	struct page_ext *page_ext;
>>>>    	struct page_owner *page_owner;
>>>>    	depot_stack_handle_t handle;
>>>> +	nodemask_t mask;
>>>>    
>>>>    	if (!static_branch_unlikely(&page_owner_inited))
>>>>    		return -EINVAL;
>>>> @@ -698,6 +699,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>>>    	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
>>>>    		pfn++;
>>>>    
>>>> +	mask = owner_filter.nid_mask;
>>>> +
>>>
>>> READ_ONCE() was used for owner_filter.print_mode.  Should nid_mask also read
>>> using READ_ONCE()?
>>>
>> The reason is that `owner_filter.nid_mask` is a nodemask_t, which is a
>> 128-byte structure. READ_ONCE() only supports types up to 8 bytes and
>> will trigger a compile-time assertion failure for larger structures.
>>
>> This was actually an issue in v2 - the AI review tool (sashiko.dev) and
>> Andrew both caught the compilation error with READ_ONCE/WRITE_ONCE on
>> nodemask_t, so v3 removed them.
> 
> Thank you for kindly sharing the context.  Now I understand why READ_ONCE()
> cannot be used.  But, is plain load/store safe enough for nodemask_t?
> Shouldn't it still be protected against races?
> 
Concurrency Safety:
I considered spinlock and RCU, but decided against them:

- Spinlock: Adds overhead on every read, overkill for a debug facility
- RCU: Requires dynamic allocation of 128-byte nodemask_t, too complex
- READ_ONCE/WRITE_ONCE: Not possible, exceeds 8-byte limit

Plain load/store is safe here because:
1. page_owner is debug code with low-frequency filter changes
2. Worst case of torn read is temporary inconsistency in debug output
3. Similar debugfs interfaces use the same approach

The overhead of locking doesn't justify the benefit for this debug use case.

Do you think this is acceptable, or would you prefer I add locking?
> [...]
>>>> +static ssize_t nid_filter_write(struct file *file,
>>>> +				 const char __user *buf,
>>>> +				 size_t count, loff_t *ppos)
>>>> +{
>>>> +	char *kbuf;
>>>> +	nodemask_t mask;
>>>> +	int ret;
>>>> +	int val;
>>>> +
>>>> +	/*
>>>> +	 * Limit input size to handle worst-case nodelist (all nodes).
>>>> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
>>>> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
>>>> +	 */
>>>> +	if (count > (100 + 6 * MAX_NUMNODES))
>>>> +		return -EINVAL;
>>>> +
>>>> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
>>>> +	if (!kbuf)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	if (copy_from_user(kbuf, buf, count)) {
>>>> +		ret = -EFAULT;
>>>> +		goto out_free;
>>>> +	}
>>>> +	kbuf[count] = '\0';
>>>> +
>>>> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
>>>> +	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
>>>> +		nodes_clear(mask);
>>>> +	else if (nodelist_parse(kbuf, mask)) {
>>>> +		ret = -EINVAL;
>>>> +		goto out_free;
>>>> +	}
>>>
>>> Doesn't empty string input to nodelist_parse() clears the mask?  Can't it be
>>> reused?
>>>
>> Yes, empty input (echo > nid) works because nodelist_parse() handles it
>> correctly. However, nodelist_parse() - which is implemented via
>> bitmap_parselist() - cannot handle "-1" as it's not a valid range format
>> and would return an error. The explicit "-1" check is necessary to
>> support `echo "-1" > nid` without returning an error.
>>
>> So the "-1" check handles a case that nodelist_parse() cannot handle.
> 
> Thank you for kindly explaining the reason.  But, do we really need to support
> "-1" input?  Couldn't we just redefine the interface?
> 
I chose "-1" to clearly differentiate from valid NUMA node IDs (0, 1, 2, 
3...).Since node IDs are non-negative integers, "-1" naturally means 
"invalid" or "no filter", which is an intuitive convention in Linux 
(e.g., pid -1, signal -1).

Do you have a better suggestion for how to represent "clear filter"？
> [...]
>>>> +	debugfs_create_file("nid", 0600, filter_dir, NULL,
>>>> +			    &nid_filter_fops);
>>>
>>> Why don't you use 'page_owner_' prefix like other fops, for consistency?
>>>
>> For consistency with the other file_operations
>> in this module (page_owner_fops, page_owner_threshold_fops,
>> page_owner_print_mode_fops), I'll rename nid_filter_fops to
>> page_owner_nid_filter_fops.
>>
>> I'll incorporate these improvements in the next version.
> 
> Thank you for kindly accepting my humble suggestions.
> 
>>
>> Thanks for the detailed review!
> 
> Thank you for sharing this nice work, too!
> 
> 
> Thanks,
> SJ
> 
> [...]
> 
> 

