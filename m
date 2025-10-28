Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60C3CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 07:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19968012B; Tue, 28 Oct 2025 03:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC994800E4; Tue, 28 Oct 2025 03:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB85A8012B; Tue, 28 Oct 2025 03:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B11D2800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:55:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 402DD16032A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:55:02 +0000 (UTC)
X-FDA: 84046762044.15.CBCD00C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B46140002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:54:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FG4TqO9O;
	spf=pass (imf04.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761638100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvDfdfVwPI3rmFbI6RAyNTD6PKhxg4VhIHjaKX4vR7o=;
	b=8OYMeW4JN3wY9QCDITyN6WZPSMdqsVVeF5i4uYY2/8t1XnyzE67lE7Qja4fOEIa9+pjOZE
	iXyVHTQ5vZziSQ7bKlajsHmRGjWum2qhX35piQ/1kvLVMGlefdQYT0jNofMgQtQWlvmAI5
	xFikSdH0vKjv/TgjLyszh8d1zHEJcK8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FG4TqO9O;
	spf=pass (imf04.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761638100; a=rsa-sha256;
	cv=none;
	b=THiEvVKoxKSED8qjI9SVKEYP1tBG7/q1dawJNv+yF+gxKHxlpP6h6Y8BO2Jkv5WtC9Sy5B
	j12vzt04Hptt4W8PNqnM7BEni6glhurv5xYzmqxJA46Xz2qqI23FQ7mqDR9ofEvMy2dTjh
	L93SD7Izu6CX+xWUUFHWKvLP/h+UAy4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=RvDfdfVwPI3rmFbI6RAyNTD6PKhxg4VhIHjaKX4vR7o=;
	b=FG4TqO9Oza6WsPF/ug+8/UY2MoPvbGBiHUI0uyaYLAI7wscqwecL153tU0uiI/
	Qsd+6oOjZLuyN/vI6T9/2zcEXP3mZY667kvlPgDhajq7ya2vEGVYbWW7TjCUHwso
	3vqF//xiTYzgGDUv2Im0SogKIcKZg8toLJ5Ml0SIk40/c=
Received: from [IPV6:240e:46d:1600:3a33:4534:428:f0d0:76ae] (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wCXHfXGdgBpUeIwDQ--.19073S2;
	Tue, 28 Oct 2025 15:54:48 +0800 (CST)
Message-ID: <7c069611-21e1-40df-bdb1-a3144c54507e@163.com>
Date: Tue, 28 Oct 2025 15:54:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: markus.elfring@web.de, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, qiuxu.zhuo@intel.com,
 xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, david@redhat.com, lance.yang@linux.dev
References: <20251016101813.484565-1-xialonglong2025@163.com>
 <20251016101813.484565-2-xialonglong2025@163.com>
 <af769443-e855-81d0-a44a-d5890f5d1d2f@huawei.com>
From: Long long Xia <xialonglong2025@163.com>
In-Reply-To: <af769443-e855-81d0-a44a-d5890f5d1d2f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXHfXGdgBpUeIwDQ--.19073S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GFy8uw1kXF4ftry3uF47CFg_yoW3KF45pF
	y0krZ0krW8Jry8Wr1Iqw409rySqw4ktr4UtFyfCa1Ik3Z0vrZ2gFW8W3y7GFyrAF4UGa1F
	vF4jqrnxGws5trDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jxl1kUUUUU=
X-Originating-IP: [240e:46d:1600:3a33:4534:428:f0d0:76ae]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbBgBn0+GkAdUIh0gAAs4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B46140002
X-Stat-Signature: jeaw1kjoi7rpuzzdb7mm3zbinepsuhto
X-Rspam-User: 
X-HE-Tag: 1761638099-306258
X-HE-Meta: U2FsdGVkX1/BUtgCvlpibnnaKjGTeW+2NQhx4YokZtN4NaWHV9sO1psxls+btpnJ+GUwj3JD6kBeNSHTDRlADS1AsplLjYorhBm9L4xqeomVhXMDSJvVL6UmQFOQkwD3nyRHDzm6GesNzrAnJx1W3PAZAvUCjAVmPRm+lVGPEr68HdYsKyPYszWG2qSFwGtvrkb9+QcYf6fBs1w/IuD+VBe1/zsWpcNZE1sxlIXmZPu9tSxe3Da1GtFcUotRzbz6avBiOJaenGs7Hn2LNgwMFXK87dt8i1GDosDXK6Dun9Xbqrp62hCq+SInpdSkX4PLD7z27/6ZCjokOWWJ/yEPPyCmBHsAtsWaCjR+lRbRU8jBizXBnw5lHwh/kWwgnx71bqbYGNWKVlzW4o3+iU1W1iPj++8PoB8f/9ZgE2pc4QS/cUJ6D+gqZZsY6rTlznH6ybqq5x/94gvb4GorKzNsvJ8jruzpD50JdTj5Kut2ttMtDnhjcQjSaMBieuCoaEhXKcQV2lckQ50B+y58cbLZBHWLbuFsisHgLkID+GtWd4NcyQ/ZDxLJp3GKmxW0ZB9AWDinwNyF30hMQ+UqH9LuzKt9mjlc5fMzPjAs9p7f5ZQo6YCCkq8ZzyAqEzMfq1QD2PtCrPX6tm5sVNimEgRzb7/9PvQihXERhQqOUgOSpiMPhip1BsMs1iwvGrEIzNqdf77WgNF52wxp4Yt/CKW83Om6/XTGsG2OD5KrVqyWsYc/Oux14989T6X2vNcEeW2W0lnwKt8Cw6qBZMfs7sDQ+PWrGSVW+bLrcRGNQVVpXu9yw/6fRgDesUQ3mF60iTJCDObs5WjMPFoCIyZxdvRU+NrAH/mzGQ4uzrHJw3wPnvhFfwektO3Q9+zKaY64nCGSlrN1DgwZzszj7KEMdsoNBKg92gJoBm8slDp3zHeJKqSR/mTc53xV9bZzSsgMOVqsJTaYkfpaF7norBdKNGy
 TgdrdrdP
 j7YOb8NbKCndXzXdocURXbwq7puCp2vxF3B/ZCQwn0mQm5mxKMGuC3dpyurXEywGImfjA5MMnvd5shEEvH8TdvNdO2q/G0rT7UQh4l7X1CYKG+q27pzBv5SG7LN9cAbB9h1xZ6mOlLzpJ2QUMKPeJt4qeHFDEj/OjxdZpiHfs9e54CpVXrHa4cniamQHEu0Yiuh8z1sW96F6OsXSx11zrlEDuM2QYPPy7z8OUBa/TFPxUjyKnABmQdHrKcIlUyb9T2pk8dZMw/du6fYfXgskPcU+AREAo3V3BV7MSfkFCOk8E00O1E7TkgNj70/964SzQ72xVS3i/woe3dYbJnSO6oWKuG/4r3Si+6ebb7hUzF8HiG9pVtPUFVhSJsTxtBcnDeUtJdQIBbJwSnQKhyE9hQplRlKTs7zob10IDPnV05nktI/9A+Qlh2Bfi2REch2YhxUFhb3h0VsqK6IzaWW9crQqc1icS5/16MknMZPyYbK4n78ieWOQUIaN+ZCtp5kQUllgkC2ykeVABjWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the reply.

在 2025/10/23 19:54, Miaohe Lin 写道:
> On 2025/10/16 18:18, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> When a hardware memory error occurs on a KSM page, the current
>> behavior is to kill all processes mapping that page. This can
>> be overly aggressive when KSM has multiple duplicate pages in
>> a chain where other duplicates are still healthy.
>>
>> This patch introduces a recovery mechanism that attempts to
>> migrate mappings from the failing KSM page to a newly
>> allocated KSM page or another healthy duplicate already
>> present in the same chain, before falling back to the
>> process-killing procedure.
>>
>> The recovery process works as follows:
>> 1. Identify if the failing KSM page belongs to a stable node chain.
>> 2. Locate a healthy duplicate KSM page within the same chain.
>> 3. For each process mapping the failing page:
>>     a. Attempt to allocate a new KSM page copy from healthy duplicate
>>        KSM page. If successful, migrate the mapping to this new KSM page.
>>     b. If allocation fails, migrate the mapping to the existing healthy
>>        duplicate KSM page.
>> 4. If all migrations succeed, remove the failing KSM page from the chain.
>> 5. Only if recovery fails (e.g., no healthy duplicate found or migration
>>     error) does the kernel fall back to killing the affected processes.
>>
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> Thanks for your patch. Some comments below.
>
>> ---
>>   mm/ksm.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 246 insertions(+)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 160787bb121c..9099bad1ab35 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -3084,6 +3084,246 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>>   }
>>   
>>   #ifdef CONFIG_MEMORY_FAILURE
>> +static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *dup_node)
>> +{
>> +	struct ksm_stable_node *stable_node, *dup;
>> +	struct rb_node *node;
>> +	int nid;
>> +
>> +	if (!is_stable_node_dup(dup_node))
>> +		return NULL;
>> +
>> +	for (nid = 0; nid < ksm_nr_node_ids; nid++) {
>> +		node = rb_first(root_stable_tree + nid);
>> +		for (; node; node = rb_next(node)) {
>> +			stable_node = rb_entry(node,
>> +					struct ksm_stable_node,
>> +					node);
>> +
>> +			if (!is_stable_node_chain(stable_node))
>> +				continue;
>> +
>> +			hlist_for_each_entry(dup, &stable_node->hlist,
>> +					hlist_dup) {
>> +				if (dup == dup_node)
>> +					return stable_node;
>> +			}
>> +		}
>> +	}
> Would above multiple loops take a long time in some corner cases?

Thanks for the concern.

I do some simple test。

Test 1: 10 Virtual Machines (Real-world Scenario)
Environment: 10 VMs (256MB each) with KSM enabled

KSM State:
pages_sharing: 262,802 (≈1GB)
pages_shared: 17,374 （≈68MB）
pages_unshared = 124,057 (≈485MB)
total ≈1.5GB
chain_count = 9, not_chain_count = 17152
Red-black tree nodes to traverse:
17,161 (9 chains + 17,152 non-chains)

Performance:
find_chain: 898 μs (0.9 ms)
collect_procs_ksm: 4,409 μs (4.4 ms)
Total memory failure handling: 6,135 μs (6.1 ms)


Test 2: 10GB Single Process (Extreme Case)
Environment: Single process with 10GB memory,
1,310,720 page pairs (each pair identical, different from others)

KSM State:
pages_sharing: 1,311,740 （≈5GB)
pages_shared: 1,310,724 （≈5GB)
pages_unshared = 0
total ≈10GB
Red-black tree nodes to traverse:
1,310,721 (1 chain + 1,310,720 non-chains)

Performance:
find_chain: 28,822 μs (28.8 ms)
collect_procs_ksm: 45,944 μs (45.9 ms)
Total memory failure handling: 46,594 μs (46.6 ms)

Summary:
The find_chain function shows approximately linear scaling with the 
number of red-black tree nodes.
With a 76x increase in nodes (17,161 → 1,310,721), latency increased by 
32x (898 μs → 28,822 μs).
representing 62% of total memory failure handling time (46.6ms).
However, since memory failures are rare events, this latency may be 
acceptable
as it does not impact normal system performance and only affects error 
recovery paths.


>> +
>> +	return NULL;
>> +}
>> +
>> +static struct folio *find_healthy_folio(struct ksm_stable_node *chain_head,
>> +		struct ksm_stable_node *failing_node,
>> +		struct ksm_stable_node **healthy_dupdup)
>> +{
>> +	struct ksm_stable_node *dup;
>> +	struct hlist_node *hlist_safe;
>> +	struct folio *healthy_folio;
>> +
>> +	if (!is_stable_node_chain(chain_head) || !is_stable_node_dup(failing_node))
>> +		return NULL;
>> +
>> +	hlist_for_each_entry_safe(dup, hlist_safe, &chain_head->hlist, hlist_dup) {
>> +		if (dup == failing_node)
>> +			continue;
>> +
>> +		healthy_folio = ksm_get_folio(dup, KSM_GET_FOLIO_TRYLOCK);
>> +		if (healthy_folio) {
>> +			*healthy_dupdup = dup;
>> +			return healthy_folio;
>> +		}
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static struct page *create_new_stable_node_dup(struct ksm_stable_node *chain_head,
>> +		struct folio *healthy_folio,
>> +		struct ksm_stable_node **new_stable_node)
>> +{
>> +	int nid;
>> +	unsigned long kpfn;
>> +	struct page *new_page = NULL;
>> +
>> +	if (!is_stable_node_chain(chain_head))
>> +		return NULL;
>> +
>> +	new_page = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_ZERO);
> Why __GFP_ZERO is needed?
Thanks for pointing this out. I'll remove it.

>> +	if (!new_page)
>> +		return NULL;
>> +
>> +	copy_highpage(new_page, folio_page(healthy_folio, 0));
>> +
>> +	*new_stable_node = alloc_stable_node();
>> +	if (!*new_stable_node) {
>> +		__free_page(new_page);
>> +		return NULL;
>> +	}
>> +
>> +	INIT_HLIST_HEAD(&(*new_stable_node)->hlist);
>> +	kpfn = page_to_pfn(new_page);
>> +	(*new_stable_node)->kpfn = kpfn;
>> +	nid = get_kpfn_nid(kpfn);
>> +	DO_NUMA((*new_stable_node)->nid = nid);
>> +	(*new_stable_node)->rmap_hlist_len = 0;
>> +
>> +	(*new_stable_node)->head = STABLE_NODE_DUP_HEAD;
>> +	hlist_add_head(&(*new_stable_node)->hlist_dup, &chain_head->hlist);
>> +	ksm_stable_node_dups++;
>> +	folio_set_stable_node(page_folio(new_page), *new_stable_node);
>> +	folio_add_lru(page_folio(new_page));
>> +
>> +	return new_page;
>> +}
>> +
> ...
>
>> +
>> +static void migrate_to_target_dup(struct ksm_stable_node *failing_node,
>> +		struct folio *failing_folio,
>> +		struct folio *target_folio,
>> +		struct ksm_stable_node *target_dup)
>> +{
>> +	struct ksm_rmap_item *rmap_item;
>> +	struct hlist_node *hlist_safe;
>> +	int err;
>> +
>> +	hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_node->hlist, hlist) {
>> +		struct mm_struct *mm = rmap_item->mm;
>> +		unsigned long addr = rmap_item->address & PAGE_MASK;
>> +		struct vm_area_struct *vma;
>> +
>> +		if (!mmap_read_trylock(mm))
>> +			continue;
>> +
>> +		if (ksm_test_exit(mm)) {
>> +			mmap_read_unlock(mm);
>> +			continue;
>> +		}
>> +
>> +		vma = vma_lookup(mm, addr);
>> +		if (!vma) {
>> +			mmap_read_unlock(mm);
>> +			continue;
>> +		}
>> +
>> +		if (!folio_trylock(target_folio)) {
> Should we try to get the folio refcnt first?

Thanks for pointing this out. I'll fix it.

>> +			mmap_read_unlock(mm);
>> +			continue;
>> +		}
>> +
>> +		err = replace_failing_page(vma, &failing_folio->page,
>> +				folio_page(target_folio, 0), addr);
>> +		if (!err) {
>> +			hlist_del(&rmap_item->hlist);
>> +			rmap_item->head = target_dup;
>> +			hlist_add_head(&rmap_item->hlist, &target_dup->hlist);
>> +			target_dup->rmap_hlist_len++;
>> +			failing_node->rmap_hlist_len--;
>> +		}
>> +
>> +		folio_unlock(target_folio);
>> +		mmap_read_unlock(mm);
>> +	}
>> +
>> +}
>> +
>> +static bool ksm_recover_within_chain(struct ksm_stable_node *failing_node)
>> +{
>> +	struct folio *failing_folio = NULL;
>> +	struct ksm_stable_node *healthy_dupdup = NULL;
>> +	struct folio *healthy_folio = NULL;
>> +	struct ksm_stable_node *chain_head = NULL;
>> +	struct page *new_page = NULL;
>> +	struct ksm_stable_node *new_stable_node = NULL;
>> +
>> +	if (!is_stable_node_dup(failing_node))
>> +		return false;
>> +
>> +	guard(mutex)(&ksm_thread_mutex);
>> +	failing_folio = ksm_get_folio(failing_node, KSM_GET_FOLIO_NOLOCK);
>> +	if (!failing_folio)
>> +		return false;
>> +
>> +	chain_head = find_chain_head(failing_node);
>> +	if (!chain_head)
>> +		return NULL;
> Should we folio_put(failing_folio) before return?

Thanks for pointing this out. I'll fix it.

> Thanks.
> .
Best regards,
Longlong Xia




