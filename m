Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EAA606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=DG1fP3Sw
Received: by kanga.kvack.org (Postfix)
	id 91B206B05B7; Sun,  8 Nov 2026 22:17:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2D06B05B9; Sun,  8 Nov 2026 22:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830026B05BA; Sun,  8 Nov 2026 22:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 598AC6B05B7
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:17:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C982E805CF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:17:52 +0000 (UTC)
X-FDA: 85414121184.10.B352669
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf06.hostedemail.com (Postfix) with ESMTP id B99F7180004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:17:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DG1fP3Sw;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794194271;
	b=cNUwHiWGJTwsajWvGXhk80eNiZDL7bpXLdM1FJ0chVQzf3fuYi6GTh8aWsj5FHFigxah6k
	Vwwx6YbpyoE8mh2lX5RVbU4aJaOzFj/mPOAQzFUE8J3jSuctDo0mQeeDjkpNQDnGDDd6Rn
	MO9sgX86wlnl5iSxXHjaH2r9a5HIt64=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DG1fP3Sw;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794194271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzsuXTqF9zD2JLji8BIZvKOPqzfj2Y3osUqEyjxdHoQ=;
	b=4FtcN+FGC/QIP/UlQJU3JNMy2zS8zffA3vrnsfkD44l6Yb3jjdKosiF/B2LmEqn2JObZkV
	8jg4KlVXteWDPDH8yNb/hBNw7rkD9ePybh9cR3J6mr7yIMJPliJSXxRpkXZ7/tVA/NmPms
	iKq0UNy7r+fT/zb6vdCgDENrbnw5XTk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PzsuXTqF9zD2JLji8BIZvKOPqzfj2Y3osUqEyjxdHoQ=;
	b=DG1fP3SwmNAWraQi7SjTvv66f/6vmSd3MIVZcQ4zECV5kUXvHbZzpJ4Fj/4RDhVbpQm8adI0N
	cYT8rox++UfbHMTH0nE+Sunfxy28J37f2PTiQPED/aEsks3bj199xkV903E6yXBunHzJk3ChKUw
	VqnblsCkrf407mmZ0sZIefY=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jNFMh0BFRz1prPn;
	Mon,  9 Nov 2026 11:17:36 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 714714056E;
	Mon,  9 Nov 2026 11:17:43 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 11:17:42 +0800
Message-ID: <da8b84ee-e66f-4dcd-aeb6-4ab850e5adce@huawei.com>
Date: Mon, 9 Nov 2026 11:17:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only empty
 anonymous pages
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Chengming Zhou
	<chengming.zhou@linux.dev>, Lorenzo Stoakes <lstoakes@gmail.com>, "Liam R .
 Howlett" <liam.howlett@oracle.com>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, Huan Yang <link@vivo.com>, Wang Xiao
	<xiao.wang@vivo.com>
References: <20261106034841.233085-1-xu.xin@linux.dev>
 <2a642af6-b97a-4f24-9889-1844812de4cc@huawei.com>
 <avEpskVC/NRPFt4d@dgvxl46587.localhost.localdomain>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <avEpskVC/NRPFt4d@dgvxl46587.localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: zrprbxzfxyt5mug5gigsfjjt3i5ibfgy
X-Rspamd-Queue-Id: B99F7180004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794194269-822044
X-HE-Meta: U2FsdGVkX1//7Ss47dFha/djJCkURpahqYdk3r/4+P11o26cR8w8SWi9e9wtTA2OwtYprz6mVJVSROs8WSq0L4Vz4JfsGBliTwSqN0LSvF5LPU6b26hcBd0OckbYinf1UsST44jZJV/EEJ6JC81gDsLyN3xEYcT9ORZwNBB9NKdkhGwjai3aroNIEkkszWdOqWB8JEcuMvbmVjtVwfpYqeTVwskJcSalmSik05LhlVPaLV9i/dbYH5O8zfVdCQCye+pHPytNhlCwlHREebhazCKP3juxzJcwcMJM00g5E6d0yW97F3aMwyJpVOldVDp3KzGe5q2opZtPO3KaTD+S9oOs56ajfCVKg7oBPC96h8gVm3NvFAb6ipdfAWqs1HXmPdohxmSutkDbaJENPNvn2Y4cagDtdpxNTM0yYgYNz+Isb8mq3V1YNBfhvkY+xFLYykD5wmFowaroqaEmWF455uFhF5d5/YvF0jsdrUr8H/Q2Lszx+qsFhR3kG4ybrBlijdrUkS+Rrl0FZS/yvob6ufcLlEhpVSY/SPugMUcUj5RlFrmZcOxMDJb0k72BiWpRxbdn+J3q0QJQGY0LPOjc3BG710RNinBTkghsOSf1EDmQysl/e/AzGx4+tIoEwOywm1vXH+ul54z0kQI0/mvS4xsjEyGg1vGhXMGoMLPlfWF1mBNOmuJLisPMuVtXqmOhyye3uxlsli5zoNmD3/JPL0PC+xul4w/vAZu+eAg8tEFoMgEomqJy2tYqCYEdgQN/AJgDTkTVY+VsGDUF/ABoagCNsfLwrFF/MCeKC6jz6WykN3lNCLuP+nKsAGHPWRhL1vuFxGd9EZyzdbkCk54Wg8NXHchxUe3MqFnhkD6nI8RCFIVrrsAHz+0YjXBWcu07tn56YGzMahk2bb/Z+q5xkzvKowGEYA8XPBmeE2b3Xem/6mufxIKutsGwXqiKGhaqjBr4fT4SHjza6u/TtfO
 3DJj7VNY
 rL7gpLfNyqlbydoBYPSu72Q76Qos1jallqVAWaoBK3Jkh+NbOuuYmMpuEb4QBCXdvk4ED9M3nomkk6YALnN2pbcL/i0FqXom5Opmp3yBy7/OZxURx22/QzfFIsTAz0i2ZlGUcjfTwWtd1eLJRrxkTdEJZMoR2JIGU4XetYJB0iiQYNUrx/9p0dfUvLoeQPrfo7K9HaArb3qpF2t09HBd7giI67kB2fGC2BcPWOoacjqL98lBNi+rfcFPC4bjep7B54rif3wh3mJOU1mxKJsj2tNvnJuVKYCeI1fzrpaSI/08UDucJTbJ2RMf0UAJxTo9VUF5fRmmO0bNao0am4e+oQBheI0tnWYIWS/8iaPfZq/UDUJRnv9zVz3HKt4/i6OoCBfhlaieADcGVXTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/9 10:02, Xu Xin (vivo) 写道:
> On Sat, Nov 07, 2026 at 04:13:40PM +0800, Jinjiang Tu wrote:
>> 在 2026/11/6 11:48, xu.xin@linux.dev 写道:
>>> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
>>>
>>>     KSM side-channel exposure is desired. Many handset vendors may prefer
>>>     this knob, which can be used as a default fallback policy.
>>>
>>> - Not suitable for server and virtualization workloads containing many
>>>     non-zero duplicate pages, where vanilla KSM provides better memory
>>>     savings.
>> It’s a coincidence that I’m also working on similar optimizations.
>> In our scenario, we have a MySQL instance with over 700 GB of anonymous
>> memory. Most of this memory belongs to the buffer pool, which caches
>> data from storage; these pages cannot be merged. Of the remaining memory,
>> around 15 GB is consumed by hashtables, which contain many zero-filled
>> pages that are eligible for merging to reduce memory footprint.
>>
>> When we enabled KSM for the entire MySQL instance, ksmd created rmap_item
>> metadata for each candidate page.The massive metadata overhead wiped out
>> any gains from page merging, and even resulted in a negative benefit.
>>
>> For this reason, I’m trying to make ksmd merge only zero pages. The goal
>> is to have ksmd skip scanning non-zero pages entirely, thereby avoiding
>> the rmap_item metadata cost introduced by scanning non-mergeable pages.
> Skip generating ksm_rmap_item for non-zero pages ? That dose make sense to me.

Yes.

>
>> 1) Before get_next_rmap_item(), check whether the page is all zeros.
>> If not, skip it directly to avoid allocating an rmap_item.
>>
>> 2) When walking page tables to find candidate pages in ksm_next_page_pmd_entry(),
>> check whether the first and last contents are zero as a quick filter.
>> This is intended to speed up page-table traversal.
>>
>> Would you mind to collaborate? For example, by including my optimization
>> as the second patch in your patch series?
> Happy to do it.

Thanks.

>
>> Here is the diff. Basic functionality has been tested.
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index dbfb8f98b189..8a02976b0aba 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -296,6 +296,9 @@ static unsigned int zero_checksum __read_mostly;
>>   /* Whether to merge empty (zeroed) pages with actual zero pages */
>>   static bool ksm_use_zero_pages __read_mostly;
>> +/* Whether to merge empty (zeroed) pages only */
>> +static bool ksm_only_merge_zero_pages __read_mostly;
>> +
>>   /* Skip pages that couldn't be de-duplicated previously */
>>   /* Default to true at least temporarily, for testing */
>>   static bool ksm_smart_scan = true;
>> @@ -2524,8 +2527,42 @@ struct ksm_next_page_arg {
>>   	struct folio *folio;
>>   	struct page *page;
>>   	unsigned long addr;
>> +	unsigned int nr_to_skip;
>>   };
>> +static inline bool page_maybe_zero(struct page *page)
>> +{
>> +	unsigned long *p;
>> +	bool ret = true;
>> +	unsigned int last_pos = PAGE_SIZE / sizeof(*p) - 1;
>> +
>> +	p = kmap_local_page(page);
>> +	if (p[0] || p[last_pos])
>> +		ret = false;
>> +	kunmap_local(p);
>> +	return ret;
>> +}
>> +
>> +static struct page *ksm_skip_nonzero_pages(struct page *page,
>> +					   unsigned long *addr,
>> +					   unsigned long nr,
>> +					   unsigned int *nr_to_skip)
>> +{
>> +	unsigned long i;
>> +
>> +	for (i = 0; i < nr; i++) {
>> +		if (!*nr_to_skip)
>> +			break;
>> +		(*nr_to_skip)--;
>> +		if (page_maybe_zero(page + i))
>> +			break;
>> +	}
>> +	if (i == nr)
>> +		return NULL;
>> +	*addr += i << PAGE_SHIFT;
>> +	return page + i;
>> +}
>> +
>>   static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
>>   		struct mm_walk *walk)
>>   {
>> @@ -2563,6 +2600,13 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
>>   				goto not_found_unlock;
>>   			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
>> +			if (ksm_only_merge_zero_pages) {
>> +				page = ksm_skip_nonzero_pages(page, &addr,
>> +					(end - addr) >> PAGE_SHIFT,
>> +					&private->nr_to_skip);
>> +				if (!page)
>> +					goto not_found_unlock;
>> +			}
>>   			goto found_unlock;
>>   		}
>>   		spin_unlock(ptl);
>> @@ -2585,6 +2629,14 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
>>   		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
>>   			continue;
>> +
>> +		if (ksm_only_merge_zero_pages && !folio_test_ksm(folio)) {
>> +			page = ksm_skip_nonzero_pages(page, &addr, 1,
>> +						      &private->nr_to_skip);
>> +			if (!page)
>> +				continue;
>> +		}
>> +
>>   		goto found_unlock;
>>   	}
>> @@ -2609,6 +2661,33 @@ static struct mm_walk_ops ksm_next_page_ops = {
>>   	.walk_lock = PGWALK_RDLOCK,
>>   };
>> +static bool should_skip_page(struct ksm_rmap_item **rmap_list,
>> +				  unsigned long addr, struct folio *folio,
>> +				  struct page *page)
>> +{
>> +	struct ksm_rmap_item *rmap_item;
>> +
>> +	if (!ksm_only_merge_zero_pages)
>> +		return false;
>> +
>> +	if (folio_test_ksm(folio))
>> +		return false;
>> +
>> +	if (pages_identical(page, ZERO_PAGE(0)))
>> +		return false;
>> +
>> +	while (*rmap_list) {
>> +		rmap_item = *rmap_list;
>> +		if ((rmap_item->address & PAGE_MASK) > addr)
>> +			break;
>> +		*rmap_list = rmap_item->rmap_list;
>> +		remove_rmap_item_from_tree(rmap_item);
>> +		free_rmap_item(rmap_item);
>> +	}
>> +	return true;
>> +}
>> +
>> +
>>   static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>>   {
>>   	struct mm_struct *mm;
>> @@ -2705,6 +2784,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>>   			int found;
>> +			ksm_next_page_arg.nr_to_skip = 1024;
>>   			found = walk_page_range_vma(vma, ksm_scan.address,
>>   						    vma->vm_end,
>>   						    &ksm_next_page_ops,
>> @@ -2722,6 +2802,14 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>>   			if (tmp_page) {
>>   				flush_anon_page(vma, tmp_page, ksm_scan.address);
>>   				flush_dcache_page(tmp_page);
>> +
>> +				if (should_skip_page(ksm_scan.rmap_list, ksm_scan.address, folio, tmp_page)) {
>> +					folio_put(folio);
>> +					ksm_scan.address += PAGE_SIZE;
>> +					mmap_read_unlock(mm);
>> +					return ERR_PTR(-EAGAIN);
>> +				}
>> +
>>   				rmap_item = get_next_rmap_item(mm_slot,
>>   					ksm_scan.rmap_list, ksm_scan.address);
>>   				if (rmap_item) {
>> @@ -2824,6 +2912,10 @@ static void ksm_do_scan(unsigned int scan_npages)
>>   		rmap_item = scan_get_next_rmap_item(&page);
>>   		if (!rmap_item)
>>   			return;
>> +		if (rmap_item == ERR_PTR(-EAGAIN)) {
>> +			ksm_pages_scanned++;
>> +			continue;
>> +		}
>>   		cmp_and_merge_page(page, rmap_item);
>>   		put_page(page);
>>   		ksm_pages_scanned++;
>> @@ -3674,6 +3766,28 @@ static ssize_t use_zero_pages_store(struct kobject *kobj,
>>   }
>>   KSM_ATTR(use_zero_pages);
>>

