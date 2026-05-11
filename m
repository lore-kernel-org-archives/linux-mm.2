Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22FC6CD4846
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0976B00CD; Mon, 11 May 2026 08:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7719E6B00CF; Mon, 11 May 2026 08:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF386B00D1; Mon, 11 May 2026 08:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF196B00CD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:24:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0828C8D9AC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:24:49 +0000 (UTC)
X-FDA: 84755057898.04.997546A
Received: from mail-m82106.xmail.ntesmail.com (mail-m82106.xmail.ntesmail.com [156.224.82.106])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED3A6C0017
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:24:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.106 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778502287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TxYvaGYD8Z8uK013U/aERGZrUB6bFIqVnMji/8poZPs=;
	b=qDoBVcNYEJjo3gmFkxu1M+wAunBey8fHG7ySTmhmc+5nnG/fGE2RdHDmG2VZEidGyVzp2R
	VFuHmXL16nT3II1hcXYVR/lWn+DWjjH82UH18EAVRMyalQzbeDutpbfsnNFnYdUoi14o1a
	dFDqJNre9eC5OE/1gZ/akQ73BKEh5qk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778502287; a=rsa-sha256;
	cv=none;
	b=u/jd0DehrkQ7U3XrC1HBLbuOaiz7mlIyD7vEbWbXZkDVse4v5FVABcka6aQP0/kWAN2K8J
	tseQG64JLhJV/xVJAKBzBeavBfiZSKMkCDp9FyD5Cvv/noLWGJ8SM9bwskDjDfAgNNbKxM
	D0zzTBM0IlPAEkr2BKrKg30sycP/qI4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.106 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19f9af269;
	Mon, 11 May 2026 20:24:41 +0800 (GMT+08:00)
Message-ID: <2a70be08-ea9c-473b-80f2-9852e2f6fc51@easystack.cn>
Date: Mon, 11 May 2026 20:24:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] mm/page_owner: add NUMA node filter with nodelist
 support
To: Oscar Salvador <osalvador@suse.de>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <20260511033017.747781-3-zhen.ni@easystack.cn>
 <agGZT0bXygoZiif1@localhost.localdomain>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <agGZT0bXygoZiif1@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e16ff27410229kunm419f9bb3303784
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSk4dVkhIGUtNTR0ZTE8ZT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED3A6C0017
X-Stat-Signature: ug5u3hmq6pnrxz6niy1ow6w1s1wruw6b
X-Rspam-User: 
X-HE-Tag: 1778502285-307876
X-HE-Meta: U2FsdGVkX18/rRcwttNwjL/+WfDxtpo2XKPS//u6RDR4KIJcxBXEuawcl27p5z5dYdn2GQp6+pMOHJRsgIMI7dxcMeDkVefsxkfcPhYMQ5loV9mFtP51G0eE9tkdj3ge3zeQVkT8C5YYhqXENrS8iCCMZULxFjvcLRa9xwGohWmCir+hJgfT2r6A9BZlAO9BKsPtEz/m0oMav0w9nytYn8Tk+XL4jEfuXX6itDSQ5g8bS0DwrX22xmRo6wdS074XVeCFKMrRSsoHG3D4CVwD5iXavm4mW2B52V5Wig0OXGrnu+Ch6DwqLFlQOBUUV0oquHvVwCSuAKYLWhysIs49R0+T0m73T1+mJF8u1gApNGa47eGEZmPUrugL3BGkX2iHRtXfaABvHSb7crrMJHeUcVcdLfw9w2A6/depVuOkhCkQt5t1UHF4Bxuc0nknx7Jwyg9P9furTB4Mfc54HyjTAfdOAucRjxZ50+MkItqKaKVSnDnY7Rd6WH8PfOH4CPevP1KsWwJapM8ZJjXR0l1BrJm6DWo48nricMOA2QaKRtD8D9miwQeAm5o6ghNEz9N55AXmYNrIr60GbTJzp8EllWkusyWxP7VP7kRQZ1s0/zY2y3vCrPsiBPzitcAs0nOFDuayTb+k+OaADNDfTrttnoQPiFYfLzdbTpdzWFs9x0KrXogiJ6msirU/sboE7hwKtdeD3ZyMNLHc/IejFkY2afRHXrHeGBipKdnDaZwePeOL9kIG6MrHZl6r8bQjOQlX1exdgM9jRyVBsVgRMAj5U7eozVYn2WwsHZOZPjAzD61Q7bW7stVhoNjhC9DSbdz9MsvX9lFM4ynCeTZIFRO0kbbUYxqNA9ymh94EtkCXB2U9Kl1PTNYw9V2KNIVPX6E2nywo842J5BYXarBhwnrgUfOFvh2PpFQ5wxmyC6Md8g2FGtGPrZnHjE4CCXrR5HGyhd/qWqDd9Lhw0+yycfv
 19sidgmi
 ypJOu3E6xjryq8H4wrxnlK3aFMg7I3JbuH8pkMbHxPelKhKftQetgm8bsrA2YqJ3Mk3qTyddxNhZsE+h5x3QnD/nG7mLuLfFKLavc/0kRhx79VpAnLSr5MHBYxOn9ELLxVTF5bqUDw8P/9/BV2RTWW9TWic8n1UZ/NbuM6Ds7dsXPRXq4kpY044wCrHgMiPb8/t2etFIBCVXYnY4zUbmh94AvfDqvDrCiiY9G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/11 16:54, Oscar Salvador 写道:
> On Mon, May 11, 2026 at 11:30:16AM +0800, Zhen Ni wrote:
>> Add NUMA node filtering functionality to page_owner to allow filtering
>> pages by specific NUMA node(s). This is useful for NUMA-aware memory
>> allocation analysis and debugging.
>>
>> The filter supports flexible nodelist input formats:
>> - Single node: echo "0" > nid
>> - Multiple nodes: echo "0,2,3" > nid
>> - Node range: echo "0-3" > nid
>> - Mixed format: echo "0,2-4,7" > nid
>> - Clear filter: echo > nid (empty string)
>>
>> The implementation uses nodemask_t for efficient multi-node filtering
>> and nodelist_parse() for flexible input parsing. Empty input clears
>> the filter.
>>
>> Note: Access to nid_mask uses plain load/store without locking because
>> nodemask_t is too large (128 bytes) for READ_ONCE/WRITE_ONCE. This is
>> safe for debug use: low-frequency changes and torn reads would only
>> cause temporary inconsistency in debug output.
>>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>> ---
> ...
>> ---
>>   mm/page_owner.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 92 insertions(+)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 27a412c52d41..8a38005539ff 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
> ...
>> @@ -700,6 +708,9 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>   	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
>>   		pfn++;
>>   
>> +	mask = owner_filter.nid_mask;
>> +	filter_by_nid = !nodes_empty(mask);
>> +
>>   	/* Find an allocated page */
>>   	for (; pfn < max_pfn; pfn++) {
>>   		/*
>> @@ -732,6 +743,14 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>   		if (unlikely(!page_ext))
>>   			continue;
>>   
>> +		/* NUMA node filter using bitmask */
>> +		if (filter_by_nid) {
> 
> This comment is kinda pointless because it explains something that the code makes it
> quite clear.
> Either drop it, or just go with "NUMA node filter", but "using bitmask"
> does not really add much.
> 
I'll just remove it entirely.
> 
>> +			int nid = page_to_nid(page);
>> +
>> +			if (!node_isset(nid, mask))
>> +				goto ext_put_continue;
>> +		}
>> +
>>   		/*
>>   		 * Some pages could be missed by concurrent allocation or free,
>>   		 * because we don't hold the zone lock.
>> @@ -1043,6 +1062,77 @@ static const struct file_operations page_owner_print_mode_fops = {
>>   	.llseek = default_llseek,
>>   };
>>   
>> +static ssize_t nid_filter_write(struct file *file,
>> +				 const char __user *buf,
>> +				 size_t count, loff_t *ppos)
>> +{
>> +	char *kbuf;
>> +	nodemask_t mask;
>> +	int ret;
>> +
>> +	/*
>> +	 * Limit input size to handle worst-case nodelist (all nodes).
>> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
>> +	 */
>> +	if (count > (6 * MAX_NUMNODES))
>> +		return -EINVAL;
>> +
>> +	kbuf = kmalloc_objs(*kbuf, count + 1);
>> +	if (!kbuf)
>> +		return -ENOMEM;
>> +
>> +	if (strncpy_from_user(kbuf, buf, count) < 0) {
>> +		ret = -EFAULT;
>> +		goto out_free;
>> +	}
>> +	kbuf[count] = '\0';
>> +
>> +	/* Support nodelist format like "0", "0,2", "0-3", or empty to clear */
>> +	if (nodelist_parse(kbuf, mask)) {
>> +		ret = -EINVAL;
>> +		goto out_free;
>> +	}
> 
> nodelist_parse() can also return other return values besides EINVAL.
> Something like
> 
>   ret = nodelist_parse(...)
>   if (ret < 0)
>      return ret
> 
> might be cleaner.
> 
  I'll change it.
>> +
>> +	/* Validate that all specified nodes actually exist in the system */
>> +	if (!nodes_subset(mask, node_states[N_MEMORY])) {
>> +		ret = -EINVAL;
>> +		goto out_free;
>> +	}
> 
> Ok, I get that since you want to filter allocations by numa nodes, you
> want to make sure that those nodes have memory.
> Although that might change due to concurrent memory-hotplug operations,
> but that is a different story.
> 
> I do not like the comment though, because we can have other nodes
> existing in the system with no memory (e.g: memoryless nodes only having
> cpus, or none of them), so I would make that clearer:
> 
> "
>    /*
>     * We want to filter memory allocations by numa nodes, so make sure
>     * that the specified nodes have memory.
>     */
> "
> 
> or something along those lines.
> 
> 
I'll update the comment to be more precise about filtering nodes with 
memory.
>> +
>> +	owner_filter.nid_mask = mask;
>> +	ret = count;
>> +
>> +out_free:
>> +	kfree(kbuf);
>> +	return ret;
>> +}
>> +
>> +static int nid_filter_show(struct seq_file *m, void *v)
>> +{
>> +	nodemask_t mask = owner_filter.nid_mask;
>> +
>> +	if (nodes_empty(mask))
>> +		seq_puts(m, "\n");
>> +	else
>> +		seq_printf(m, "%*pbl\n", nodemask_pr_args(&mask));
> 
> is not nodemask_pr_args clever enough to not print anything or print "0"
> if the nmask is NODE_MASK_NONE?
> 
> 
Looking at lib/vsprintf.c:bitmap_list_string(), the %*pbl format
doesn't print anything when the bitmap is empty (the 
for_each_set_bitrange loopdoesn't execute). So we can simplify this to 
just remove check nodes_empty().

Thanks for the thorough review!

Best regards,
Zhen

