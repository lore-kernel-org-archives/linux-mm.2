Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4CA606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Qv9lI8SG
Received: by kanga.kvack.org (Postfix)
	id 5D8D46B05B2; Mon, 23 Nov 2026 07:30:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1016B05B4; Mon, 23 Nov 2026 07:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6896B05B5; Mon, 23 Nov 2026 07:30:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14FAA6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:30:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 970041C2F6C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:30:04 +0000 (UTC)
X-FDA: 85466315928.20.61C0530
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf14.hostedemail.com (Postfix) with ESMTP id EAB0E100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:29:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Qv9lI8SG;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795437002;
	b=DnVakzhmPd60SoKnyrPKP5z7V7rl+lB+5eSzol2voINuwXUeY9oBoGhw189spUIFTpkY67
	uKM6RRTb7rYp8I3xUfqze1ge2zJwjXD7lqQ1X4Dt1+G5MjDT9Sq211pew0HQN9tF622KA5
	RlQ5MKVVk402pW/YydNYCwuAoPDWL5g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795437002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEnsmGCryXnOeH+9qoc2fAxJs1iEo3LTRsGgU6sdHgI=;
	b=Kx8TB51B5ix1sNH5cWwAxoKGHRSDyn1O/u24INRttxH0Paq6JVObMZfeqWlrBKPIEgdjtt
	585mvJTXjilzMbZx020w4/HiYZuUHXSxlah2GJaRsB0tBSw8CLpQ3H7ChUqtp9IB+p7uwV
	ej0GfyZtBG8LdJt266R7/nJbKq6bEV8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Qv9lI8SG;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zEnsmGCryXnOeH+9qoc2fAxJs1iEo3LTRsGgU6sdHgI=;
	b=Qv9lI8SGarj7tyxX2ZTUa5kwvdsgQWW+LWBM7cKDNkVy527R3LeocZcROxI6Uh75mblaGSOmY
	/V+qHOIUJA2g6fMtIRC4yUVtCgB6WwORCc3vrQof6ycRPQp4sf5XzQGWxaFV7wIU4wfOiv9Y+7K
	/CX0stmKvqXhi73s6/AfHvk=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jY4y36vhpzKm4D;
	Mon, 23 Nov 2026 20:29:31 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E6D140563;
	Mon, 23 Nov 2026 20:29:49 +0800 (CST)
Received: from [10.173.98.163] (10.173.98.163) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 23 Nov 2026 20:29:47 +0800
Subject: Re: [PATCH v2] mm/memory_hotplug: don't offline a hwpoisoned page
 still in the page cache
To: <mt4022@columbia.edu>
CC: Naoya Horiguchi <nao.horiguchi@gmail.com>, Vlastimil Babka
	<vbabka@kernel.org>, Gregory Price <gourry@gourry.net>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tz2294@columbia.edu>, <stable@vger.kernel.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20261105-memhp-hwpoison-pagecache-v2-1-029d35634d42@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <cec355cc-46ba-9190-b0fb-efd634498581@huawei.com>
Date: Mon, 23 Nov 2026 20:29:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261105-memhp-hwpoison-pagecache-v2-1-029d35634d42@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-24.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EAB0E100007
X-Stat-Signature: tpum3jf9qtcype8p5ath8ypunkug6ht6
X-Rspam-User:
X-HE-Tag: 1795436999-362140
X-HE-Meta: U2FsdGVkX19UXeJzKrA2+nYRyUz1s117conJCGMF6zrPt/OEOcQj5Mwox1we3Ll/egVsf6wLa/TRijt6VDPlC4YqHRC5H2fEFQQ9mW0dHBIGTNCGdDGQohrrPw1PMG6XopjN2FQWNwCRC+xn6SSMVi7HsTZ5H6N2pZXveMIw0PH6LO89tRdbUF01bewOyyXpIP5oc4UGecwsPE7ujDLLFPoTERtX3dEOOoKmsQpdQ+SjGPwPUqby7Yuq0a2Moj+zgkmb8F9r0ULMpL3ZkWzKqQwLKV3VT5SXEXfVZIsDYqaaz9p/+h9IjIhCxJEznYAAbfUCrGHP1C+HW28lKkJr3M3c44Y8m7+ySn4VijhOX0pMux4QphLmNNRx8X3GiwICj7FD3wJN0ASgy6rxila6MnpZS50Jy769nFyEy+Cbi0RUfwBDyyWBvRw/lZBDOvTfd5Iyq/bjFrM/U+Wf1zUNGWogo63TpZ94i0OkglPj9zPz9eQ3M40oXaWIXdpFlErqeNFlfCUZqi21DMASjqKzapzRzlzJRXAnOhf63cRCj9XB/VKef9ME8zN2+EiP8F6GojxlouMO/1ptAkOlqRoYAhPEEPuJQheuV/sWHWOoXm3o1bUiCeA9CCFzTtgcz0H9u4/quVhUj212UU66nytH/ZsgnK4ZysyX75ve8h1YYdgUITwD+LhPpoTuBBQQSFflYf59S+9K7bgwxgeAU+/aoSPsQW8nCQ2Ch1+I3OYEVOcoNXsUj3GcTv1E7oo7HzehCtyvgm7MHDYqVmpfJe7llp5OST3AAs7GUUR/AHZmzescmQGFte1ec+QWJm2dod8vh4GhS9V1T9+K0p+vuyurH92Wx3EjPSaLN+WeAzMY6oOwgImvrTQUI2De1x3/fyLOjWq4Sz+Bc2AXhKA94uk3md3IcBMpMfzT255BCXBWFzPDcblBEBX+MwBzR4OdXk6LLKM7KpWzR2yq4gIanaA
 1VZHTIhu
 /S+JjLym0QM2oneRp9IKg8dcsaw5Nz/gSAr9W1qjkKAQqFeCSO7XkfiT++FGzS5WoR5k2imTFqE6k/hTwchVUVJXwTTUQNuHU4CAEfo+z51LEawvdjC/V6ySPbr/bVAdYqTedpmyBHMWIhj0CdczQllew9ZfLCBroKcm5+QR3FAsuuflQEBJ6D+3G58K1SfcjR4SaXmXnWKHOOugsyeEuLERp1PmbjVu4TyJCf81gOCjnPHeHWcLUO8u9T2ND9R5/uLVwsgkYuWIY+sr5J5ymNu27daIDMrFe7FjaKk4H0nIHouoEKgqk8jabycQ/y9EqVY9wwRpjXk59lKnC7x6JrJGgFhrPLDztUg9HU2Xf1DQRDXKyr7wEWchaHY0Gm/FNvsK8v2MQBiDIxUeLNupTeNnzyzARmCOJH1wsdOif4XK5OJXPH20xDofP9iwBe3NzFSL4KyTcLPfbttREbggfzkAxE6NG2XRwSiVU7c/Ff2nAsTi0MkyD1qRlNfIb9X8ssXjJiVNdtnaSXc/EwWiHFw80AOGjy0jz3ATflvdltoSi62IxLDSJ5ZUWA1q8NgRXloa05vX0v0Po8JoMVpzqfFlPk1MbXGCc2rNu0jhv+6YSgjsd2DVKZjnibGDA5gkGhqPCZkYf312XF2V43BTXV6NEWIS6GdBzS54JztdXMiYjygW8otX/qhxpy4oNS6lbGhiG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/6 4:50, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> Memory offline skips hwpoisoned pages, assuming nobody uses them
> anymore.  memory_failure() however sets PG_hwpoison before it takes the
> page, and taking it waits on pcp_batch_high_lock, which offline_pages()
> holds for the whole offline.  A memory error during the offline thus
> marks the page and then waits while the offline skips it:
> 
>   Task A (offline_pages)               Task B (memory_failure)
>   zone_pcp_disable()
>                                        TestSetPageHWPoison(P)
>                                        get_hwpoison_page()
>                                          /* waits for Task A */
>   do_migrate_range()
>     /* P is poisoned (not migrated) */
>   test_pages_isolated()
>     /* P is poisoned (accepted) */
>   zone_pcp_enable()
>                                        /* P is off the LRU (Ignored) */
> 
> The block goes offline while the file still points to P, and the next
> walk of the file's pages (here drop_caches on ext4) crashes on a struct
> page of offlined memory:
> 
>   [   11.710348] Memory failure: 0x24224: unhandlable page.
>   [   11.710372] Memory failure: 0x24224: recovery action for get hwpoison page: Ignored
>   [   11.765371] page:000000008c304eee is uninitialized and poisoned
>   [   11.765389] page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
>   [   11.765440] kernel BUG at include/linux/mm.h:1990!
>   [   11.765458] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   [   11.772284] CPU: 3 UID: 0 PID: 85 Comm: mfoffline Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
>   [   11.777970] RIP: 0010:find_lock_entries+0x8ee/0xad0
>   [   11.798761] Call Trace:
>   [   11.799297]  <TASK>
>   [   11.803284]  mapping_try_invalidate+0xfd/0x2c0
>   [   11.810571]  drop_pagecache_sb+0x111/0x330
>   [   11.811572]  __iterate_supers+0x2e2/0x370
>   [   11.815863]  drop_caches_sysctl_handler+0x74/0xb0
>   [   11.816994]  proc_sys_call_handler+0x2ec/0x440
>   [   11.821360]  vfs_write+0x545/0x1250
>   [   11.825220]  ksys_write+0xfa/0x200
>   [   11.830202]  do_syscall_64+0xfb/0x590
>   [   11.832084]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [   11.848423]  </TASK>
> 
> Once the memory is also removed it's a use-after-free of the memory map.
> tmpfs and the swap cache can end up the same way without the race.
> Since commit a76054266661 ("mm: shmem: don't truncate page if memory
> failure happens"), memory_failure() leaves a poisoned tmpfs folio in the
> page cache on purpose, and it does the same for a dirty folio in the
> swap cache.
> 
> Treat a hwpoisoned page whose folio is still in a page cache or swap
> cache as busy in scan_movable_pages() and
> __test_page_isolated_in_pageblock() so that the offline fails and a
> waiting memory_failure() can go on.  Also have do_migrate_range() leave
> such a folio alone instead of taking it off the LRU, so that
> memory_failure() can still remove it from the cache.  A later offline
> succeeds once the page is out of the cache.  With the fix, the offline
> fails with -EBUSY and the file doesn't point to offlined memory anymore.
> 
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within about 10s.
> 
> Fixes: b023f46813cd ("memory-hotplug: skip HWPoisoned page when offlining pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Changes in v2:
> - Leave a hwpoisoned folio that is still in a page cache or swap cache
>   alone in do_migrate_range(), so that a waiting memory_failure() can
>   still remove it from the cache (Sashiko)
> - Rebase onto current mm-new
> - Link to v1: https://lore.kernel.org/all/20261101-memhp-hwpoison-pagecache-v1-1-ed8785ca44eb@columbia.edu/
> 
> A pinned hwpoisoned page still isn't covered.  I'll send the refcount
> check David suggested as a follow-up.
> 
> Taking get_online_mems() in memory_failure(), as in Gregory's series
> [1], would close only the race and not the tmpfs or swap cache case.
> 
> [1] https://lore.kernel.org/all/20261027042204.3741307-4-gourry@gourry.net/
> 
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/mfoffline.c
> ---
>  mm/internal.h       | 9 +++++++++
>  mm/memory_hotplug.c | 5 +++++
>  mm/page_isolation.c | 2 +-
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 78a7f17b9934..35c6d30537f0 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1168,6 +1168,15 @@ static inline bool node_reclaim_enabled(void)
>  	return node_reclaim_mode & (RECLAIM_ZONE|RECLAIM_WRITE|RECLAIM_UNMAP);
>  }
>  
> +/*
> + * A hwpoisoned page can be skipped by memory offline only once no page
> + * cache or swap cache can find it anymore.
> + */
> +static inline bool hwpoison_page_offlineable(const struct page *page)

Would it be better to pass in folio?

> +{
> +	return !folio_mapping(page_folio(page));
> +}
> +
>  extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
>          unsigned long, unsigned long,
>          unsigned long, unsigned long);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 1bfd1f4daeb2..c5cfaa24b41b 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1821,6 +1821,8 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
>  		struct folio *folio;
>  
>  		page = pfn_to_page(pfn);
> +		if (PageHWPoison(page) && !hwpoison_page_offlineable(page))

Should we use folio_contain_hwpoisoned_page here?

> +			return -EBUSY;
>  		if (PageLRU(page) || page_has_movable_ops(page))
>  			goto found;
>  
> @@ -1887,6 +1889,9 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
>  			 */
>  			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
>  				goto put_folio;
> +			/* The offline fails on it anyway, leave it to memory_failure() */
> +			if (!hwpoison_page_offlineable(page))
> +				goto put_folio;
>  			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
>  				goto put_folio;
>  			if (folio_mapped(folio)) {
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 5aaad037384e..beb09ef345ee 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -593,7 +593,7 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
>  			 */
>  			pfn += 1 << buddy_order(page);
>  		else if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) &&
> -			 PageHWPoison(page))
> +			 PageHWPoison(page) && hwpoison_page_offlineable(page))

Again, should we use folio_contain_hwpoisoned_page here?

Thanks.
.


