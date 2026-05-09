Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E584CD343F
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 07:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1726B02FD; Sat,  9 May 2026 03:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9B76B02FF; Sat,  9 May 2026 03:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07706B0300; Sat,  9 May 2026 03:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B28116B02FD
	for <linux-mm@kvack.org>; Sat,  9 May 2026 03:27:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 880061A0554
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:27:31 +0000 (UTC)
X-FDA: 84747051102.12.B0284AB
Received: from mail-m2458.xmail.ntesmail.com (mail-m2458.xmail.ntesmail.com [45.195.24.58])
	by imf14.hostedemail.com (Postfix) with ESMTP id 13E4110000D
	for <linux-mm@kvack.org>; Sat,  9 May 2026 07:27:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.58 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778311649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKwmBTnyARzXuYntrmY2Hf6m+tfhP4YoB3PRFM02C6s=;
	b=g1l9Vpv/virSbtjKKy1QMKDgkntaI+hNCeqcLGr64/B9mIAH6n22iihaZtenjy2dnWeEu0
	i85KpYYOtgGhLLT60vEFexFmeMuj5soNbOrygkz0tjVMnwkF2GfB7WArGY1u4Qj4BbdDky
	RB7DAqeG4PIAPtg/RwaJDUlkyaCdm/Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778311649; a=rsa-sha256;
	cv=none;
	b=WHuH5lACqtsFwBeaHr0LgJbvSTkDiBfme+xrdvVTpt++nNWDtkgHCiCGJoz/HmLuWpgww0
	vqtWD/j+2HjuWi8vFcN8X2wClDyDXQ40zizf5uBkscf0ltZmVpkrGQWi0dygLAalqr8zbv
	BcxTuezzek4IAWQVagYQQ9YvvmtV3y0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.58 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19e7d9eab;
	Sat, 9 May 2026 15:27:22 +0800 (GMT+08:00)
Message-ID: <9ebddab1-b7b4-462e-a920-f850cc5c55c5@easystack.cn>
Date: Sat, 9 May 2026 15:27:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] mm/page_owner: add NUMA node filter with nodelist
 support
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260509004417.84229-1-sj@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260509004417.84229-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e0ba23dfb0229kunm3dc358b4264912
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZQxhLVk1IGBhIGEtLQx1KH1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 13E4110000D
X-Stat-Signature: unqofdtfg71yf5ehcfu6k1tgmw44bu7d
X-Rspam-User: 
X-HE-Tag: 1778311647-882997
X-HE-Meta: U2FsdGVkX19annUMeBYRyRZm3A9Ug+EMUYHrjOB5kY4zTJlRuqJl666w2RvicxMoq4DgBo1QTJAinYBYovWMbfim3SWudtOFUlBIDA7U01ThfgJs2OwJxXc34IGEoVRRpwbaKQgElTbr5Qu6rcWnUePXZa3qqTFkWESDFOCTrPMSTQI4UZUa/RKlEqRkNBB3gFMAH+81BNofhzkT62qCm//72vt03xtkLOsqbDuYAkGs/bt64yP9GnxMVyiiMCxrkVf2Gdl+l9EkqwxNUE67z48nLbZw7NkHk4gOdShiBRDsrtyPsDYLfRij5+l4j6XR97Tmgj34HZEG1qRDvuk5iikuU3/Lm2uWACqvtjyZG1B49VbqRlpEXi0+Lc2D8/aGxpeGdvh6DnzQHvKrvJirdzzlxcsI6YAiTviRHeyXYzPE76ohs+GPEc5IEZiv0r/3FgVEBmJJy5RO1EpWbE2kZuTVzl8rxcB4ath1vEAmabu+x9XhpJ2fcVVJEklgn5tNxxcnKlM8IrXo07X+XElgCQBzHMGw3oOVzlOTw8Wgm5FbGraiG9ra/hJOALWSiGOLufxU4uAU7lwoMN1JUyuXdbP+jHrweEyauHLTNnkf9zCGZ3SfmjnW6CiRRR8wB68NViqCRf+1v+tqVF3QVZRHHR7JUCoiGdQgWoAwnZLpcetrDfN8KLRF9Ki2KdfePG/8WGv3UJqasSYKkTS+dBeX4pYF/LGEtp6B7qmVIA4wASBhhjA+OxVgBIoaQRSEAH+WjD0F+/haka8evYTOjOHm9kmjsVLeasaQdTnHwiols1x6jYq/JU3ddwbpkxMV17IwV0ZlnXbC7R51JIL1n0hrUPXVq/vcK0ppoCr1N13CzrUCqiWelEg+vw/USoQ8NrPimC7V5/9vbRCQRUKmn5uRCLkj/mylDJT/86+ZQrjkqk+jjO0I9YIxZYhpx1azrNoP1DCkvfEgZvrxRH3ee/S
 0pIk04dO
 fKjNGgi8S9/jO2udLVbiWdtqFASdEOj8q0IXjYAZVVxCTzSB08xdWr/ZrD3Ir0AKeEVkSoAiD8ECjivQJh+UwZbhLtsurNzmK4JliFvNr6F7LXnV0RWBA3usbsufV8IhlbrT/TDvQeJsEb4LnV4ZMhur0Yc02zUoO75lPPjvHf1sE96c2Ok6Et3WmLjhNiADWVPzjw20LE7tJBKqawuTNeaB+NLsr/YRtkOhjhtpF/uRAtQMjO5YBElAtAO4TG2IZV36P3syYxS1m4BE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/9 08:44, SeongJae Park 写道:
> On Thu,  7 May 2026 14:46:42 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
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
>>
>> Changes in v5:
>> - Optimize nodes_empty() check in page iteration loop
>> - Add __data_racy qualifier to nid_mask field
> 
> Adding links to previous revisions [1] would be helpful.

Will add lore links.

> 
>> ---
>>   mm/page_owner.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 86 insertions(+)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
> [...]
>> @@ -700,6 +707,9 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>   	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
>>   		pfn++;
>>   
>> +	mask = owner_filter.nid_mask;
>> +	bool filter_by_nid = !nodes_empty(mask);
>> +
> 
> Shouldn't we separate variable declarations and statements inside a same block?
> 

I will fix this in v6 by declaring all variables at the beginning of the 
block:

     nodemask_t mask;
     bool filter_by_nid;

     mask = owner_filter.nid_mask;
     filter_by_nid = !nodes_empty(mask);
> [...]
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
>> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
> 
> What is the 100 bytes overhead?

The 100 bytes is intended as a safety margin, but it's not strictly 
necessary.
Maybe I should simplify it to just 6 * MAX_NUMNODES?
> 
>> +	 */
>> +	if (count > (100 + 6 * MAX_NUMNODES))
>> +		return -EINVAL;
>> +
>> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
>> +	if (!kbuf)
>> +		return -ENOMEM;
> 
> Would it make sense to use kmalloc_objs()?

I'll update the code to use
kmalloc_objs(char, count + 1, GFP_KERNEL)

Thanks for the review!
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> 
> 
> Thanks,
> SJ
> 
> [...]
> 
> 
Best regards,
Zhen

