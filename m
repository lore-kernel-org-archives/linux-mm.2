Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1100FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 09:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B2B6B0088; Wed, 29 Apr 2026 05:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBBF06B008A; Wed, 29 Apr 2026 05:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2106B008C; Wed, 29 Apr 2026 05:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA6CE6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:05:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACE428CAE0
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:04:07 +0000 (UTC)
X-FDA: 84711006576.25.1A4974A
Received: from mail-m828.xmail.ntesmail.com (mail-m828.xmail.ntesmail.com [156.224.82.8])
	by imf10.hostedemail.com (Postfix) with ESMTP id 695A2C000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:04:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.8 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777453445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k71ioF0EsRTSkmC8/TkVCNAe2R/7N3/S5vbYdgQZ6Fs=;
	b=xASNJJYu1h+6UO1TeCPBl8AposPkEyAJ/Zz26TEnqSB/NBN6Q6KcjeVO/GmstZgfOlqgq4
	qnPWtidXjLUb0y7VVzO5RoQvsLE+iQoGjhnICUrEtsEZBlT191nBwE+j0swhP+nU6PvOBU
	Vf50ni/4qXzXSzvlmOuewJN4GQzM9Pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777453445; a=rsa-sha256;
	cv=none;
	b=CjxQjBsuValCNgMELCx0xZqXi8T9HJbIgO4f9xTyUX4sqMhjLBW7Y8O7+1FCz1HzIz4mGO
	hiZNJBPU9uf6Y+/sPi+r5oqQ2S3Pd25j2ZzRqN+D0ONzah13GerWpVz9YLvaP/PH6AUAJc
	0d4L14XC1Wr6j2nrF2jpP4tAyxa91TQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.8 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 198a1e11c;
	Wed, 29 Apr 2026 17:03:56 +0800 (GMT+08:00)
Message-ID: <f09a287b-87e9-4701-afe0-929363937fd8@easystack.cn>
Date: Wed, 29 Apr 2026 17:03:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] mm/page_owner: add NUMA node filter with nodelist
 support
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260429012808.88831-1-sj@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260429012808.88831-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd87b0d620229kunm1b6ddb561b1ead
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTksdVh8ZTk5DTU4fGh9DSlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 695A2C000E
X-Stat-Signature: 3dci516ande8c6474ktz3nx1ioam9nb5
X-Rspam-User: 
X-HE-Tag: 1777453442-988880
X-HE-Meta: U2FsdGVkX193kXPukhNw0JRySakoyJgUyDs6c79LWg2rcVXUl+rCbxNLjU81gj3pNwy86HmuIotNQwv8QAow960QXJo+uXm9Z3azQsl0sp9ZxUIgIqA+1gVHJWvW4F5LF3YhZHq7Yh4fLOb0gKRey8yABYgRnzEecMaGOrbGhAbvSYhHlQMjvhIUy5Hc/6JYxzw/4VOORNI0TQqea5WwRVqExXY+oHCGZnOW9kL4saWYTnuqQD6IyT1onVL1pteP+HUfuNGmwuz01/I5PLsmYiQZT82JpIZe0EyXWHZqoI6+K3R8aVpZJwb88x7ENVjCbXcwDS0axfMlHiAuCPKfU5RGdEeZAFvuI3t600gq9H30CqwiJnJeoY0mvWJf2/MPUeZsjZs8yspix18+0UaX4tqEZ4Dr5O4iQoQtdgylhiPD58BrmtTg85C7xFnDSZOKh2LToh+FNYnDBtTB6znwjRwnifmpEY7457hfLj57LidjPFZz8LGLwktbwJskY4kdj0b6UqomtE9cC08pK7eMGR3y/wFRYP40NHE175lc+Ta83fRK/d/ZrRr3O4reDK7t3ft6XUFKijCy3hLCX4giI4lGRUpdB3TdvKE9IXnIVKVSVFzbauqlh6AcJ/2hW3U+d5b9cnKdkqVtBH03EMJAElFNxq3/MQM0CXQjij5R4zENKDlxFd20dyTPvvg4pyMPoZmuiqiAOyHwnXEYw1Wz3C+K2PQOonC7zH1NpS93x9NbBj1n8dknXOw1goNofDjqLrmT4s9KMqAFma+3r+N5uXD3MWs/wTc7CkbBQ1GAC06OeK+KUtShCS5y+j0fMTye9GFwVkcvaRwO56D0rim+8FiKMoivZXHkCeThTH8poS+dzrpOvKCI1ZrBrFt8B4TJG18ceBDT1dxnmUyTItM77jrNHw65vLbQq0b/euL0DKMW/Shvw243ZUEwSBLTy76gcgFn/6zr2c6lhoDmAro
 ROXzZDyA
 Rhx4MTT5xy2GnKMZcwRYjqu4GkP5H0RQTckfhdOP6EoNIzPnM4Ps1xqxr22swvB1n3bhchnEWwWjMDoxbhQCFr4VUVOG8GIWgglAlBWbSruP0weeR/eG7UChP25dkJ60oGeaZElBoWSaK23Ajs6MF6i43G7vyWhwFOnb+JyTj2Zxwe1BKueH8d4DhVML38v85qdpQ7GBUY2ZtE8MDmPs9oaIeTyfkBpDadHyFSHb4fzOsZcw1z+2GZsv/Fpq1dUnf7hFlLTV3olwZPE0lnCT32HX/BsAB9M12mLDUKtzt/VdEmuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/29 09:28, SeongJae Park 写道:
> On Tue, 28 Apr 2026 15:11:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> Add NUMA node filtering functionality to page_owner to allow
>> filtering pages by specific NUMA node(s) using nodelist format.
>>
>> The filter allows users to focus on pages from specific NUMA nodes,
>> which is useful for NUMA-aware memory allocation analysis and debugging.
>>
>> Supported input formats:
>> - Single node: echo "2" > nid
>> - Multiple nodes: echo "0,2,3" > nid
>> - Node range: echo "0-3" > nid
>> - Mixed format: echo "0,2-4,7" > nid
>> - Disable filter: echo "-1" > nid
>>
>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
>> Link: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
> 
> Seems the above two links are for v1 and v2 of this patch.  I think putting
> those with the context at commentary area [1] could be useful.
> 
Good suggestion.
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>> ---
> [...]
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 6d87b6948cfa..e674a374669a 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -685,6 +685,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>   	struct page_ext *page_ext;
>>   	struct page_owner *page_owner;
>>   	depot_stack_handle_t handle;
>> +	nodemask_t mask;
>>   
>>   	if (!static_branch_unlikely(&page_owner_inited))
>>   		return -EINVAL;
>> @@ -698,6 +699,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>   	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
>>   		pfn++;
>>   
>> +	mask = owner_filter.nid_mask;
>> +
> 
> READ_ONCE() was used for owner_filter.print_mode.  Should nid_mask also read
> using READ_ONCE()?
> 
The reason is that `owner_filter.nid_mask` is a nodemask_t, which is a
128-byte structure. READ_ONCE() only supports types up to 8 bytes and 
will trigger a compile-time assertion failure for larger structures.

This was actually an issue in v2 - the AI review tool (sashiko.dev) and
Andrew both caught the compilation error with READ_ONCE/WRITE_ONCE on
nodemask_t, so v3 removed them.
>>   	/* Find an allocated page */
>>   	for (; pfn < max_pfn; pfn++) {
>>   		/*
>> @@ -730,6 +733,14 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>   		if (unlikely(!page_ext))
>>   			continue;
>>   
>> +		/* NUMA node filter using bitmask */
>> +		if (!nodes_empty(mask)) {
>> +			int nid = page_to_nid(page);
>> +
>> +			if (!node_isset(nid, mask))
>> +				goto ext_put_continue;
>> +		}
>> +
>>   		/*
>>   		 * Some pages could be missed by concurrent allocation or free,
>>   		 * because we don't hold the zone lock.
>> @@ -1009,6 +1020,75 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
>>   			&page_owner_print_mode_get,
>>   			&page_owner_print_mode_set, "%lld");
>>   
>> +static ssize_t nid_filter_write(struct file *file,
>> +				 const char __user *buf,
>> +				 size_t count, loff_t *ppos)
>> +{
>> +	char *kbuf;
>> +	nodemask_t mask;
>> +	int ret;
>> +	int val;
>> +
>> +	/*
>> +	 * Limit input size to handle worst-case nodelist (all nodes).
>> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
>> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
>> +	 */
>> +	if (count > (100 + 6 * MAX_NUMNODES))
>> +		return -EINVAL;
>> +
>> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
>> +	if (!kbuf)
>> +		return -ENOMEM;
>> +
>> +	if (copy_from_user(kbuf, buf, count)) {
>> +		ret = -EFAULT;
>> +		goto out_free;
>> +	}
>> +	kbuf[count] = '\0';
>> +
>> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
>> +	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
>> +		nodes_clear(mask);
>> +	else if (nodelist_parse(kbuf, mask)) {
>> +		ret = -EINVAL;
>> +		goto out_free;
>> +	}
> 
> Doesn't empty string input to nodelist_parse() clears the mask?  Can't it be
> reused?
> 
Yes, empty input (echo > nid) works because nodelist_parse() handles it
correctly. However, nodelist_parse() - which is implemented via
bitmap_parselist() - cannot handle "-1" as it's not a valid range format
and would return an error. The explicit "-1" check is necessary to 
support `echo "-1" > nid` without returning an error.

So the "-1" check handles a case that nodelist_parse() cannot handle.
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
>> +		seq_puts(m, "-1\n");
>> +	else
>> +		seq_printf(m, "%*pbl\n", nodemask_pr_args(&mask));
>> +
>> +	return 0;
>> +}
>> +
>> +static int nid_filter_open(struct inode *inode, struct file *file)
>> +{
>> +	return single_open(file, nid_filter_show, NULL);
>> +}
>> +
>> +static const struct file_operations nid_filter_fops = {
>> +	.owner		= THIS_MODULE,
>> +	.open		= nid_filter_open,
>> +	.read		= seq_read,
>> +	.llseek		= seq_lseek,
>> +	.write		= nid_filter_write,
>> +	.release	= single_release,
>> +};
>> +
>>   
>>   static int __init pageowner_init(void)
>>   {
>> @@ -1024,6 +1104,8 @@ static int __init pageowner_init(void)
>>   	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
>>   	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
>>   			    &page_owner_print_mode_fops);
>> +	debugfs_create_file("nid", 0600, filter_dir, NULL,
>> +			    &nid_filter_fops);
> 
> Why don't you use 'page_owner_' prefix like other fops, for consistency?
> 
For consistency with the other file_operations
in this module (page_owner_fops, page_owner_threshold_fops,
page_owner_print_mode_fops), I'll rename nid_filter_fops to
page_owner_nid_filter_fops.

I'll incorporate these improvements in the next version.

Thanks for the detailed review!
>>   
>>   	dir = debugfs_create_dir("page_owner_stacks", NULL);
>>   	debugfs_create_file("show_stacks", 0400, dir,
>> -- 
>> 2.20.1
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> 
> 
> Thanks,
> SJ
> 
> 
Best regards,
Zhen Ni

