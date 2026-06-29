Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D602C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129426B009D; Sun, 28 Jun 2026 22:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3EC6B009E; Sun, 28 Jun 2026 22:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD3F6B009F; Sun, 28 Jun 2026 22:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0B3B6B009D
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:59:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DE3DA0559
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:59:16 +0000 (UTC)
X-FDA: 84931443912.15.F08B8EF
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A1EF1C0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:59:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EX7FemEc;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782701954;
	b=UdY7HJBmTsN7Iiwm/GhIJvRMqNsCOHXkkkL8raMa53QNevFULCkFE6bPJucNJ1ybyyZKwy
	iNcIrCsTqy4jK9Y4/qMK3KJOPodHuJNA767SbLc8JjUYWYKxf2/avX4zGMHSrjEaWlbwIS
	MQE2Y78CS8XqW+Doiy3Vi9bnXJKPo5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782701954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCOhey7T8ci2xHicQXyA6UyiZigih/2qAxtqg0WDv2U=;
	b=4n3RH9lZC2afYqnByCRM973jMwnAEIESu6UEMy8OOsSW8emi/tNTNoITey9zzJHTnV5tO7
	F+fjxCd4SrTwlBYgj0McnC/iweOi6yu/BezE8WtVuwj10w7UXTzdh5rY+/lCt43h8niAL1
	OjakemAzBuHZHQZfv70lb7qgPkAfS3Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EX7FemEc;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d86d309d-9f5a-4d63-afb0-dc4016fe1ded@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782701949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bCOhey7T8ci2xHicQXyA6UyiZigih/2qAxtqg0WDv2U=;
	b=EX7FemEcR0IQbJGZYcZ04ee4Nycq0W7Q3gvHsDiLzvAeQ3vUgmDajtidRJHIACaCO38ikE
	ouyLl2Ntyy2i+DuZKoZ/85AsM6A7wspa+e/WFjCWNaDmHyoOo50uVY4u56tTkWiO/rG6JH
	eAKQtHBrCrp86N6nLQIvWdrOyVZWElc=
Date: Mon, 29 Jun 2026 10:59:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v11 1/4] mm/page_owner: add print_mode filter
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org,
 vbabka@kernel.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-2-zhen.ni@easystack.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260625043101.338794-2-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A1EF1C0004
X-Stat-Signature: gcbu1xw6c57rk9x5w4t6eo3jot36ubu8
X-HE-Tag: 1782701954-766888
X-HE-Meta: U2FsdGVkX185Pfc/Sh+cZP5vH9OnxWS+i6BLTbYqh4YGVyadhT2lt31nmJcLajQK6+McIfzwuhYRbN0xIJaNrb4goD//SgNV4RTjuaEerQd6uAbLJBN3smxbbzqBu6KZUdj2Ehf7Fda2avoHNPzqGD7d+mT2tyVgWJ03QCGbA4Z4MJWYks9pTerHdTOB5BnFUfZyn/WKFRKcT3UEx9qfcMaStxXA8oaoe2kOM3U3vaUBNBx415qdynuYczt2sDiBPaD3JH7C/tAFMTA7c4QqoXPv4EnOwOxNiipt9RqxWg/qupJsSpwwZKvtWxIxbjD6BQ3Z+qrscsxtH7Q+cmiyCg4gmeDoxvk2uyR//Oc52QkDvPZ3IgB2qaQPu710s1VYmQBl7xCpNLMo4bHDZfAxktUxAPZtYd7iK1C82IpCJSOSYIdU62sDrX0rqHB7K4mxSED8dBfwuaAvXh0ZiUPrJuBhE0aix4yM2H5UYOGBGvXjjOAaNzmA2SRABlFIh96npl8gi7AArwmYUlsdRZSVZ9KJGwyNnt7TWxVxh6j1xBqqzdbgo3Ik1XVeuqeknA+C5it8FiMCcBPBOskR+trO9EVszHWR53lcCSpyqomH87UJAbNNG0Xi6FtWargC8BDeEf/gcmmz/n2twCX72ObwBNM5+4qc5VltzljOJsmbvV+4uGWlDbgNPbWVd9B4tAJ/n4DxNQ4FQc9wd/84Y/HpMEZ9obKYMQiTNTckQc4cXXATNzDZB0pLWO0kMN7Gd6fpgZlkUoj8xfRx8yWEt9ShXI8u+z1k1PsEdMxQIIeJyoWAQ06D9pPag8Stta5+HxPpf7CStk5LcQBIgm1XK7voK0g0kK8pwDFsAr//SLE2rtWvR427B4VHZU833w01DGFFliN11i2kAv/MDHZlteFCbREgbhRu6AqdYspm54MQoGImoOy0n3/T26EqToWeQiWiKespJgC9r/Qk6cXCe25
 EDaLBgyj
 NEtUaARgzLOASJ5Mt+0MZRnV8vDqbwEDvrVoIv0qLaDVqUV9bQ4Fh0tSbRY10yXpnSN3jsJuafL6Ju6VGXmKiNmvRZJTXtUps/IRyTsfrVKfuBe20h2PQxlWEZGK4MpLXnp6JsdcgiRY6OVAqJV/IWrX9zB1sZ3/mABCG/LAvsUyarErKdu2fzwI92qlXI9A5tYE3BjJ2UBRiV5025ruaUvGcMDETX8M8TA6jWUA4NDPIhvtPf7s0EAgJt6vMvYk4t71k6+FwM0mowZ3YvSoRPuvuEebTfoDT8NAXC/f5PRV1Cmq5DQm6NOBp2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/25 12:30, Zhen Ni 写道:
> Add a print_mode filter to page_owner that allows users to choose between
> printing stack traces, stack handles, or both, providing flexibility for
> different debugging and analysis scenarios.
>
> The filter provides three modes via page_owner:
> - Writing "mode=stack" prints stack traces for each page (default)
> - Writing "mode=handle" prints only the handle number
> - Writing "mode=stack_handle" prints both stack traces and handles
>
> The default stack mode maintains backward compatibility with existing
> usage, displaying complete stack traces for each page allocation.
>
> The handle mode dramatically reduces log size and improves performance by
> showing only the handle number instead of the full stack trace. Testing
> shows handle mode reduces output size by ~66% (84MB vs 244MB) and
> improves read performance by ~4.4x compared to full stack output. The
> mapping from handles to actual stack traces can be obtained via the
> show_stacks_handles interface.
>
> The stack_handle mode prints both stack traces and handles, making it
> easier to identify pages with the same allocation pattern by comparing
> handle numbers instead of comparing large stack traces.
>
> Example usage:
>   # Using the page_owner_filter tool (recommended)
>   ./page_owner_filter -m stack          # Print only stack traces (default)
>   ./page_owner_filter -m handle         # Print only handles
>   ./page_owner_filter -m stack_handle   # Print both stack and handles
>
> Sample output (handle mode):
>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>   pid 1, tgid 1 (systemd), ts 123456789 ns
>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>   Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>   handle: 17432583
>   ...
>
> This implementation uses per-file-descriptor filter state stored in
> file->private_data, allowing each opener to have independent filter
> configuration.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
> Changes in v11:
> - No changes
>
> Changes in v10:
> - No changes
>
> Changes in v9:
> - Add spinlock_t lock to struct page_owner_filter_state for concurrent access protection
>
> Changes in v8:
> - Fix buffer overflow by adding bounds check between stack_depot_snprint() and scnprintf()
> - Fix unsafe string handling: use memdup_user_nul() instead of kmalloc_objs + strncpy_from_user()
> - Fix strsep() memory corruption by saving original pointer before strsep() call
> - Change format specifier from %d to %u for depot_stack_handle_t
>
> Changes in v7:
> - per-file-descriptor implementation
>
> Changes in v6:
> - Remove unnecessary braces in if/else statement (coding style)
> - Use stack array (char kbuf[33]) instead of kmalloc for input buffer
>
> Changes in v5:
> - No code changes
>
> Changes in v4:
> - Change from numeric (0/1) to string-based interface ("full_stack"/"stack_handle")
> - Merge infrastructure patch into this patch
>
> Changes in v3:
> - No code changes
>
> Changes in v2:
> - Renamed from 'compact mode' to 'print_mode' for better clarity
> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
> - Update debugfs filename from 'compact' to 'print_mode'
>
> v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-2-zhen.ni@easystack.cn/
> v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-2-zhen.ni@easystack.cn/
> v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-2-zhen.ni@easystack.cn/
> v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-2-zhen.ni@easystack.cn/
> v6: https://lore.kernel.org/linux-mm/20260511033017.747781-2-zhen.ni@easystack.cn/
> v5: https://lore.kernel.org/linux-mm/20260507064643.179187-2-zhen.ni@easystack.cn/
> v4: https://lore.kernel.org/linux-mm/20260430163247.13628-2-zhen.ni@easystack.cn/
> v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-2-zhen.ni@easystack.cn/
>     https://lore.kernel.org/linux-mm/20260428071112.1420380-3-zhen.ni@easystack.cn/
> v2: https://lore.kernel.org/linux-mm/20260419155540.376847-2-zhen.ni@easystack.cn/
>     https://lore.kernel.org/linux-mm/20260419155540.376847-3-zhen.ni@easystack.cn/
> v1: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
>     https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
> ---
>  mm/page_owner.c | 129 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 123 insertions(+), 6 deletions(-)
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 8178e0be557f..7595735979bf 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -54,6 +54,23 @@ struct stack_print_ctx {
>  	u8 flags;
>  };
>  
> +enum page_owner_print_mode {
> +	PAGE_OWNER_PRINT_STACK,
> +	PAGE_OWNER_PRINT_HANDLE,
> +	PAGE_OWNER_PRINT_STACK_HANDLE,
> +};
> +
> +static const char * const page_owner_print_mode_strings[] = {
> +	[PAGE_OWNER_PRINT_STACK]	= "stack",
> +	[PAGE_OWNER_PRINT_HANDLE]	= "handle",
> +	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
> +};
> +
> +struct page_owner_filter_state {
> +	enum page_owner_print_mode print_mode;
> +	spinlock_t lock;
Hi , Zhen
The spinlock in struct page_owner_filter_state is unnecessary and adds significant overhead in the read path.
                                                                                                    
1. Per-fd isolation: the state is allocated per open() and stored in file->private_data.
There is no cross-fd contention possible.
2. Hot path cost: the lock is taken for every single page in read_page_owner() and
print_page_owner(). A single read can traverse millions of pages, each paying
spin_lock_irqsave/irqrestore — including interrupt disable — just to read a mode
enum or check a nodemask. This is measurable overhead for no real benefit.
3. No practical race: nobody writes filter config to an fd while simultaneously reading from it. 
                                                                                                    
Suggest dropping the lock entirely. 
                                                                                                    
Just my take though — happy to follow whatever the other reviewers prefer here.

> +};
> +
>  static bool page_owner_enabled __initdata;
>  DEFINE_STATIC_KEY_FALSE(page_owner_inited);
>  
> @@ -547,16 +564,23 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>  static ssize_t
>  print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  		struct page *page, struct page_owner *page_owner,
> -		depot_stack_handle_t handle)
> +		depot_stack_handle_t handle,
> +		struct page_owner_filter_state *state)
>  {
>  	int ret, pageblock_mt, page_mt;
>  	char *kbuf;
> +	enum page_owner_print_mode print_mode;
> +	unsigned long flags;
>  
>  	count = min_t(size_t, count, PAGE_SIZE);
>  	kbuf = kmalloc(count, GFP_KERNEL);
>  	if (!kbuf)
>  		return -ENOMEM;
>  
> +	spin_lock_irqsave(&state->lock, flags);
> +	print_mode = state->print_mode;
> +	spin_unlock_irqrestore(&state->lock, flags);
> +
>  	ret = scnprintf(kbuf, count,
>  			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns\n",
>  			page_owner->order, page_owner->gfp_mask,
> @@ -575,9 +599,18 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  			migratetype_names[pageblock_mt],
>  			&page->flags);
>  
> -	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> -	if (ret >= count)
> -		goto err;
> +	if (print_mode != PAGE_OWNER_PRINT_HANDLE) {
> +		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> +		if (ret >= count)
> +			goto err;
> +	}
> +
> +	if (print_mode != PAGE_OWNER_PRINT_STACK) {
> +		ret += scnprintf(kbuf + ret, count - ret, "handle: %u\n",
> +				 handle);
> +		if (ret >= count)
> +			goto err;
> +	}
>  
>  	if (page_owner->last_migrate_reason != -1) {
>  		ret += scnprintf(kbuf + ret, count - ret,
> @@ -664,6 +697,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  	struct page_ext *page_ext;
>  	struct page_owner *page_owner;
>  	depot_stack_handle_t handle;
> +	struct page_owner_filter_state *state = file->private_data;
>  
>  	if (!static_branch_unlikely(&page_owner_inited))
>  		return -EINVAL;
> @@ -746,7 +780,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  		page_owner_tmp = *page_owner;
>  		page_ext_put(page_ext);
>  		return print_page_owner(buf, count, pfn, page,
> -				&page_owner_tmp, handle);
> +				&page_owner_tmp, handle, state);
>  ext_put_continue:
>  		page_ext_put(page_ext);
>  	}
> @@ -847,7 +881,90 @@ static void init_early_allocated_pages(void)
>  		init_pages_in_zone(zone);
>  }
>  
> +static int page_owner_open(struct inode *inode, struct file *file)
> +{
> +	struct page_owner_filter_state *state;
> +
> +	state = kzalloc_obj(*state);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&state->lock);
> +	state->print_mode = PAGE_OWNER_PRINT_STACK;
> +	file->private_data = state;
> +	return 0;
> +}
> +
> +static int page_owner_release(struct inode *inode, struct file *file)
> +{
> +	kfree(file->private_data);
> +	return 0;
> +}
> +
> +static ssize_t page_owner_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	char *orig;
> +	char *token;
> +	int ret;
> +	size_t max_input_len;
> +	struct page_owner_filter_state *state = file->private_data;
> +	enum page_owner_print_mode new_print_mode;
> +	unsigned long flags;
> +
> +	/*
> +	 * Maximum input length for filter commands:
> +	 * 32: print_mode command max length is 17 ("mode=stack_handle").
> +	 */
> +	max_input_len = 32;
> +
> +	if (count > max_input_len)
> +		return -EINVAL;
> +
> +	kbuf = memdup_user_nul(buf, count);
> +	if (IS_ERR(kbuf))
> +		return PTR_ERR(kbuf);
> +
> +	orig = kbuf;
> +
> +	spin_lock_irqsave(&state->lock, flags);
> +	new_print_mode = state->print_mode;
> +	spin_unlock_irqrestore(&state->lock, flags);
> +
> +	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
> +		if (*token == '\0')
> +			continue;
> +
> +		if (!strncmp(token, "mode=", 5)) {
> +			ret = sysfs_match_string(page_owner_print_mode_strings,
> +						token + 5);
> +			if (ret < 0)
> +				goto out_free;
> +			new_print_mode = ret;
> +		} else {
> +			ret = -EINVAL;
> +			goto out_free;
> +		}
> +	}
> +
> +	spin_lock_irqsave(&state->lock, flags);
> +	state->print_mode = new_print_mode;
> +	spin_unlock_irqrestore(&state->lock, flags);
> +
> +	ret = count;
> +
> +out_free:
> +	kfree(orig);
> +	return ret;
> +}
> +
>  static const struct file_operations page_owner_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= page_owner_open,
> +	.release	= page_owner_release,
> +	.write		= page_owner_write,
>  	.read		= read_page_owner,
>  	.llseek		= lseek_page_owner,
>  };
> @@ -980,7 +1097,7 @@ static int __init pageowner_init(void)
>  		return 0;
>  	}
>  
> -	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
> +	debugfs_create_file("page_owner", 0600, NULL, NULL, &page_owner_fops);
>  	dir = debugfs_create_dir("page_owner_stacks", NULL);
>  	debugfs_create_file("show_stacks", 0400, dir,
>  			    (void *)(STACK_PRINT_FLAG_STACK |

-- 
Thanks,
Ye Liu


