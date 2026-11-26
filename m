Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A32D6606A331
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 07:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Li4i6wBE
Received: by kanga.kvack.org (Postfix)
	id 7A9816B05B0; Thu, 26 Nov 2026 02:16:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781666B05B1; Thu, 26 Nov 2026 02:16:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698096B05B2; Thu, 26 Nov 2026 02:16:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3526B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:16:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB5E2140309
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:16:20 +0000 (UTC)
X-FDA: 85476411720.29.AE6CBCC
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9DE5F140007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:16:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Li4i6wBE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795677379;
	b=JZ6Ut2G7ngUZgZLgWv8/sKo1BZsn/lnN8yXZjgys5aGi+c/7M7wTqAO1ZIkC1rQX/CvZzX
	SaZ9VpDWy3c0fVG7BSq6H2MXvZSRSUO/9U4m+1KvWt9oE7xU8wZ4rVthNnd1+pcEAOs/OL
	jubRPF7HBj+B/mD4hUcPlu4nBJSA+tM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795677378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQ9pC12UgeQHKo4v2+Isp6+X8dmisuGtcTzdtq5XM1w=;
	b=ApSr2nyjV+96WwSlJ7X86S8qS9/4GXF76qA2cASgK/+bnlsr4BJGz7qGm3/dVev/oq66lu
	SrV9etkQTF3Jz5zoEtaqbEWLIjNfBJuQyszyPgvw99J9jhLbzdacQjiS+LYKrgBopN5e++
	4PNapMsbGlMCds2yO/1EAXcUEUpryVw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Li4i6wBE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fQ9pC12UgeQHKo4v2+Isp6+X8dmisuGtcTzdtq5XM1w=;
	b=Li4i6wBET6MlGF7NQok3MceD0g0Osz25ZYuKOUjgYHLzLsW8jFkameq1ks9DZ0LaL4THMRIDP
	ozCtCGUiiFuG0FcfH9SMTbs2AXlhBOUNvpvWl8NFTjElEePpD85+HCMyjDOQr8MKJgVFkHeM/Pl
	6kbZr/N6s4b6jujuSQ7LL0k=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jZnrV0L7Kz1cyRy;
	Thu, 26 Nov 2026 15:15:38 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id BBBDD4057C;
	Thu, 26 Nov 2026 15:16:02 +0800 (CST)
Received: from [10.173.98.163] (10.173.98.163) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 26 Nov 2026 15:15:59 +0800
Subject: Re: [PATCH v7 2/3] mm/page_alloc: only free healthy pages in
 high-order folio
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@kernel.org>, <ljs@kernel.org>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>, <osalvador@suse.de>,
	<jackmanb@google.com>, <hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>,
	<david@kernel.org>, <william.roche@oracle.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <boudewijn@delta-utec.com>, Vlastimil Babka
	<vbabka@kernel.org>
References: <20261110053331.2708996-1-jiaqiyan@google.com>
 <20261110053331.2708996-3-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ac843d8d-4415-85f3-6832-e3faf5cfd04f@huawei.com>
Date: Thu, 26 Nov 2026 15:15:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261110053331.2708996-3-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: n15sue4jewz7xk55nh5ieu8ma6knrzn4
X-Rspamd-Queue-Id: 9DE5F140007
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795677376-265339
X-HE-Meta: U2FsdGVkX1+ggL5N/t5Wei2nUyU4A9L5z7Trzg/fDk/LwFrIWsPGkyy/vUySviC2crnFvdQENnFNcCAKCzxwHP9OYjq2kfulvHKH+jVKnX5/bY/DvnuKg4ioC/9ywqAv15PJP7za+dq6SGPLp280Hvc5OBBjAtaQJvv+St/8P8xQL/VW/soTuBWPGCnbk2halqsh+tExhnMqC4jaNbpzr+7h2s/L6E6wZppcOOBClbZ+cjpq92MQJuqlmbg/OZ/yGa6cC3L9zwX0OP9la+ddgwo9W7zM2zjbVkkG/cL1qZZzzFZU+2bvZeez6xPLf6MT2n8BcBtQArwGH2pblQdCALTnhe8BnkSxi6TQlpXi/AdOXf8Tq9thaYnt95TbLPMpoAZqQnwpxOxJyEyM24293JUG0/J+jiYC+Tzbi0IPRj0RBwr9lCFYpZ/Aurynpe8eyPEImUAkNUfopARn26lHRB7KXHBabka6r5+re/vBPNI8/rtAb2sTb5fqqwYvjieLq70LLYRNXPDuexHkZmg36tTZNUI2FurBUgsIbp2clSRGY4pbi+Cb7wKeKa+IaPLSq+dBD6GQCKX5hwR+q749LhkB9siUphBKg929ZrMy6qRg5MOOuOfE52somLHouJVw2pAVqY20dwkllZkY8IuXxNguwL7Bnpy9/2k99P+DO59x9SCyDdPofO8H/iRdMsutwuA/giVuhAv5/pZcWBIO8U6szSPdu1Q5arSdGhWc8rZ2dKzVPUrcBXuTeWN+V0h4QNFloRyME7mxgjhym/wyco3cYVipwD4psk4W47OkygCvosu+ou+DNkmepATkkP4M/94BppVRPaRakVEdCJcCAhnuG6abuaIWAnBkljiTfNxCs2v5AHCPX448y1+pdhkrhl6/XH9U3WNIrijxQ/c3vMi02m6EStn05XoKZ1J4aZEkl20DvLtr4BQ6FDdlIYJmtYI7sSvb5VEHBQyUUCH
 zCl8tE8Q
 0szld5vIJWT2HHkvLcC7G9EOYLZwctwFXHNB4vYcucOF6MvXnRJrBL1433WVEQlti3zS8gbEVlOKqDQeBB6q61t5zoFmTbiCeRv/A1YtGB8OOLZc5bOSu/I+OMgdhERk/fdaBDkLDrx08hfgt5wdJAqmihB2yFKX0NZkn5ZDBFS3/zpp6yFIIjvQvZzNszRmb5WL7f/EAe5Jo1aCNrgutdTSjMDhiJZl/Z6b9DdF3XmAtnpjOtsPdBAsy/ncl8q2cr/0Ka3Voqoa204of4aj7U75K4wIAENNfOH/YLV1j13kKEsPPytMRZM9VAHQln7NEDuCpoFdyseI6NeqsUvLTsR15Pc2lqANChFuwt5kENShqbCt9o8aKcUkQG2hkSRfVA6fg2ABrwDeJ5Rws1XmPoHmtwk5hlYYwahj5LWFag5gh6T5sdSmZN+TwE/EcHKag2yL2kS6mLSrKdWY8+m2Tdw3+qhM5tqO0tagsleWrA1I+cfn+h8TOQwhDbK9eKu6pOgR6A5Qgdbp2POLckcuneYRC2cBq0tNQEL8gL/N1x04xhKTMH5Sr80pXmaUXG7r1XNEpL6tWZI/IuLKthJ9bMyVClrf2PxqIZvAlhnYmWg0a9e4ZankSJRt0Ew+D5Hhl7U/Dq2gO2S5/WQoq92di2adlO1Pwz/1SNqvzJBT4+vzNP3LXJyj6tZlLXvvFizuPQE+uSE/HG4hBQhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/10 13:33, Jiaqi Yan wrote:
> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> becomes non-HugeTLB, and it is released to buddy allocator as a
> high-order folio, e.g. a folio that contains 262144 pages if the
> folio was a 1G HugeTLB hugepage.
> 
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can be
> given out with its buddy page and be re-used by either kernel or
> userspace.
> 
> Memory failure recovery (MFR) in kernel does attempt to take raw
> HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio(). However, there is always a time
> window between dissolve_free_hugetlb_folio() frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison raw page
> off buddy allocator. Worse, a free HWPoison HugeTLB folio can also
> be dissolved outside of MFR, e.g. when shrinking the HugeTLB pool,
> and then nobody takes its HWPoison pages off buddy allocator.
> 
> Another similar situation is when a transparent huge page (THP)
> runs into memory failure but splitting failed. Such THP will
> eventually be released to buddy allocator when owning userspace
> processes are gone, but with certain subpages having HWPoison.
> 
> One obvious way to avoid these problems is to always check
> PageHWPoison() when allocating pages, which check_new_pages() only
> does if page sanity checks are enabled. However, it is against the
> past efforts to reduce sanity check overhead [1,2,3].
> 
> Instead, keep HWPoison pages out of buddy allocator when freeing a
> high-order folio. __free_pages_prepare() already walks through all
> tail pages of a high-order folio to check and clear their flags, so
> counting PageHWPoison() pages in that loop is cheap, as pointed out
> by David Hildenbrand [4]. Unlike PG_has_hwpoisoned, which is only
> maintained for THP, this catches HWPoison pages in any high-order
> folio, including dissolved HugeTLB folios.
> 
> If any HWPoison page is found, then after all checks and
> preparations in __free_pages_prepare() succeed, take a shortcut to
> the newly introduced free_has_hwpoisoned(), which only frees the
> healthy pages and excludes the HWPoison ones. __free_pages_prepare()
> then returns false so that its callers don't free the folio again.
> 
> free_has_hwpoisoned() iterates through the pages of the folio to
> identify contiguous ranges of healthy pages. It uses
> free_prepared_contig_range() to decompose each healthy range into
> the largest possible chunks of different orders, which are then
> freed via __free_frozen_pages(). Knowing the number of HWPoison
> pages from __free_pages_prepare(), it stops scanning once all of
> them are found, and frees the remaining pages without scanning them.
> 
> Sanitizing pages at free time (e.g. page poisoning and init_on_free)
> may write to page contents, which must be avoided for HWPoison
> pages. So factor it out of __free_pages_prepare() into
> free_pages_sanitize(), and skip it for a folio that has HWPoison
> pages. Instead, free_has_hwpoisoned() passes the new FPI_SANITIZE
> flag to free_prepared_contig_range(), which then sanitizes each
> healthy chunk right before freeing it.
> 
> Each excluded HWPoison page is treated like a page that
> memory_failure() takes off buddy allocator: it is marked
> PageHWPoisonTakenOff and holds a refcount of 1. Its alloc tag
> reference is also cleared, as is done for an order-0 HWPoison page
> in __free_pages_prepare(). This allows unpoison_memory() to put it
> back to buddy allocator via put_page_back_buddy() instead of leaking
> it.
> 
> As a result, memory_failure() no longer needs to take HWPoison pages
> off buddy allocator after dissolving a HugeTLB folio. For a free
> HugeTLB folio, or an anonymous one that becomes free after being
> unmapped, try_memory_failure_hugetlb() and me_huge_page() call
> __page_handle_poison(), which disables pcplists, dissolves the folio
> and then calls take_page_off_buddy(). Since the raw HWPoison page
> never reaches buddy allocator now, take_page_off_buddy() would fail,
> and memory_failure() would report MF_FAILED.
> 
> So add __hugepage_handle_poison() for these two callers. It dissolves
> the folio and then checks whether the raw HWPoison page has been
> isolated, i.e. is HWPoisonTakenOff. It doesn't test any HugeTLB
> flags, because the folio may have already been freed, e.g. by
> folio_put() in me_huge_page() if it was a surplus folio, or by a
> concurrent dissolve. If the folio's raw_hwp_list is unreliable,
> __update_and_free_hugetlb_folio() leaks the folio and the raw
> HWPoison page is not isolated, so memory_failure() still reports
> MF_FAILED. As free_has_hwpoisoned() already holds a refcount on
> each isolated page, the callers no longer page_ref_inc() it. Soft
> offline keeps using __page_handle_poison(), because it marks a page
> HWPoison only after taking it off buddy allocator.
> 
> free_has_hwpoisoned() has linear time complexity wrt the number of
> pages in the folio; the worst case is when the last page of the
> folio is HWPoison. While the power-of-two decomposition keeps the
> number of calls to buddy allocator small, the linear scan of pages
> to identify PageHWPoison() defines the overall time complexity. For
> a 1G hugepage having 8 HWPoison pages and if the last page is HWPoison,
> free_has_hwpoisoned() takes in worst case 15x the time free_one_page()
> takes for a healthy 1G hugepage, measured on a system having 56 Intel
> Skylake physical cores. The cost is nontrivial but far from triggering
> soft lockup, and fair for handling exceptional hardware memory errors.
> 
> This commit message text was reworded with an AI assistant, then
> reviewed and edited by me. The code changes are my own, but they
> are reviewed by the AI assistant.
> 
> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> [4] https://lore.kernel.org/linux-mm/8e48c288-2183-4d58-b69d-5f78344b5da5@kernel.org
> 
> Assisted-by: Antigravity:claude-opus-5-5
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

Thanks for update. Some questions below.

> ---
>  mm/internal.h       |   3 +
>  mm/memory-failure.c |  52 +++++++++-----
>  mm/page_alloc.c     | 170 +++++++++++++++++++++++++++++++++++++-------
>  3 files changed, 183 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 9b8864a8540a..3ccbf7e4439a 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1195,6 +1195,9 @@ static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, b
>  {
>  	return -EBUSY;
>  }
> +
> +static inline void SetPageHWPoisonTakenOff(struct page *page)
> +{
> +}
>  #endif
>  
>  extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b215312f261b..b456e0996ecd 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -214,7 +214,40 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
>  
>  static DEFINE_MUTEX(pfn_space_lock);
>  
> +static inline bool PageHWPoisonTakenOff(struct page *page)
> +{
> +	return PageHWPoison(page) && page_private(page) == MAGIC_HWPOISON;
> +}
> +
> +/*
> + * Only for a HugeTLB page being handled by memory_failure().
> + * Unlike soft_offline_page(), no HWPoison subpage makes it into
> + * buddy allocator when the folio is freed, so take_page_off_buddy()
> + * is unnecessary.
> + *
> + * Return values:
> + *   1:   the folio is dissolved and the page is isolated with
> + *        HWPoisonTakenOff and refcount=1. Caller must not take
> + *        another refcount.
> + *   0:   the folio is dissolved but the page is not isolated,
> + *        e.g. the folio's raw_hwp_list is unreliable.

If folio's raw_hwp_list is unreliable, I think it cannot be dissolved. So
above comment confused me.

> + *   < 0: failed to dissolve folio.
> + */
> +static int __hugepage_handle_poison(struct page *page)

...

> +/*
> + * Returns
> + * - true: checks and preparations all good, caller can proceed freeing.
> + * - false: do not proceed freeing for one of the following reasons:
> + *   1. Some check failed so it is not safe to proceed freeing.
> + *   2. A compound page has some HWPoison pages. The healthy pages
> + *      are already safely freed, and the HWPoison ones isolated.
> + */
>  static __always_inline bool __free_pages_prepare(struct page *page,
>  		unsigned int order, fpi_t fpi_flags)
>  {
>  	int bad = 0;
> -	bool skip_kasan_poison = should_skip_kasan_poison(page);
> -	bool init = want_init_on_free();
>  	bool compound = PageCompound(page);
>  	struct folio *folio = page_folio(page);
> +	unsigned int num_hwpoisoned = 0;
>  
>  	if (fpi_flags & FPI_PREPARED)
>  		return true;
> @@ -1376,6 +1437,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  			folio->_nr_pages = 0;
>  #endif
>  		}
> +		num_hwpoisoned += PageHWPoison(page);
>  		for (i = 1; i < (1 << order); i++) {
>  			struct page *tail_page = page + i;
>  
> @@ -1394,6 +1456,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  				}
>  			}
>  			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +			num_hwpoisoned += PageHWPoison(tail_page);
>  		}
>  	}
>  	if (folio_test_anon(folio)) {
> @@ -1425,34 +1488,20 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  					   PAGE_SIZE << order);
>  	}
>  
> -	kernel_poison_pages(page, 1 << order);
> -
>  	/*
> -	 * As memory initialization might be integrated into KASAN,
> -	 * KASAN poisoning and memory initialization code must be
> -	 * kept together to avoid discrepancies in behavior.
> +	 * After breaking down compound page and dealing with page metadata
> +	 * (e.g. page owner and page alloc tags), take a shortcut if this
> +	 * was a compound page containing certain HWPoison subpages.
>  	 *
> -	 * With hardware tag-based KASAN, memory tags must be set before the
> -	 * page becomes unavailable via debug_pagealloc or arch_free_page.
> +	 * Pass FPI_SANITIZE to only free_pages_sanitize() healthy pages.
>  	 */
> -	if (!skip_kasan_poison) {
> -		kasan_poison_pages(page, order, init);
> -
> -		/* Memory is already initialized if KASAN did it internally. */
> -		if (kasan_has_integrated_init())
> -			init = false;
> +	if (unlikely(num_hwpoisoned)) {
> +		free_has_hwpoisoned(page, order, num_hwpoisoned,
> +				    fpi_flags | FPI_SANITIZE);
> +		return false;

There is free_page_is_bad check above this:
	if (is_check_pages_enabled()) {
		if (free_page_is_bad(page))
			bad++;
		if (bad)
			return false;
	}

It can return early if bad is true. In this case, free_has_hwpoisoned cannot handle
the hwpoisoned subpages. Is this expected behavior?

>  	}
> -	if (init)
> -		clear_highpages_kasan_tagged(page, 1 << order);
> -
> -	/*
> -	 * arch_free_page() can make the page's contents inaccessible.  s390
> -	 * does this.  So nothing which can access the page's contents should
> -	 * happen after this.
> -	 */
> -	arch_free_page(page, order);
>  
> -	debug_pagealloc_unmap_pages(page, 1 << order);
> +	free_pages_sanitize(page, order);
>  
>  	return true;
>  }
> @@ -7059,7 +7108,14 @@ static void free_prepared_contig_range(struct page *page,
>  		/*
>  		 * Free the chunk as a single block. Our caller has already
>  		 * called free_pages_prepare() for each order-0 page.
> +		 *
> +		 * If the original compound page has HWPoison page,
> +		 * free_pages_prepare() has to skip sanitize at that time,
> +		 * but now it is good time to do that.
>  		 */
> +		if (fpi_flags & FPI_SANITIZE)
> +			free_pages_sanitize(page, order);
> +
>  		__free_frozen_pages(page, order, fpi_flags | FPI_PREPARED);
>  
>  		pfn += 1UL << order;
> @@ -7141,6 +7197,69 @@ void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>  	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
>  }
>  
> +/*
> + * Given some contiguous pages that have num_hwpoisoned HWPoison page(s),
> + * free only the healthy ones.
> + *
> + * Used at the end of __free_pages_prepare(). Even if having HWPoison pages,
> + * breaking down compound page and clearing metadata (e.g. page owner, alloc
> + * tag) can be done together during __free_pages_prepare(), which simplifies
> + * the splitting here: unlike __split_unmapped_folio(), there is no need to
> + * turn split pages into a compound page or to carry metadata.
> + *
> + * It scans every raw page of the compound page and causes nontrivial overhead.
> + * So only use this when the compound page contains HWPoison page(s).
> + *
> + * This implementation needs rework in memdesc world.
> + */
> +static void free_has_hwpoisoned(struct page *page, unsigned int order,
> +				unsigned int num_hwpoisoned,
> +				fpi_t fpi_flags)

There are codes for order = 0 in __free_pages_prepare:

	if (unlikely(PageHWPoison(page)) && !order) {
		/* Do not let hwpoison pages hit pcplists/buddy */
		reset_page_owner(page, order);
		page_table_check_free(page, order);
		pgalloc_tag_sub(page, 1 << order);

		/*
		 * The page is isolated and accounted for.
		 * Mark the codetag as empty to avoid accounting error
		 * when the page is freed by unpoison_memory().
		 */
		clear_page_tag_ref(page);
		return false;
	}

Can free_has_hwpoisoned also handle order=0 pages? This way, the hwpoison-related handling code
can be centralized here.

> +{
> +	unsigned long curr = page_to_pfn(page);
> +	unsigned long end_pfn = curr + (1UL << order);
> +	unsigned long next;
> +	struct page *hwpoisoned;
> +
> +	while (curr < end_pfn) {
> +		if (!num_hwpoisoned) {
> +			/* No more HWPoison page in [curr, end_pfn) */
> +			free_prepared_contig_range(pfn_to_page(curr),
> +						   end_pfn - curr, fpi_flags);
> +			break;
> +		}
> +
> +		next = curr;
> +		while (next < end_pfn && !PageHWPoison(pfn_to_page(next)))
> +			++next;
> +
> +		if (next != end_pfn) {

We reach here with num_hwpoisoned != 0. So next can not be equal to end_pfn?

> +			hwpoisoned = pfn_to_page(next);
> +			/*
> +			 * Avoid accounting error when the page is freed
> +			 * by unpoison_memory().
> +			 */
> +			clear_page_tag_ref(hwpoisoned);
> +			/*
> +			 * unpoison_memory() will put_page_back_buddy()
> +			 * for HWPoisonTakenOff pages. Increment refcount
> +			 * to avoid VM_BUG() from put_page_testzero().
> +			 */
> +			page_ref_inc(hwpoisoned);
> +			SetPageHWPoisonTakenOff(hwpoisoned);
> +			--num_hwpoisoned;
> +		}
> +
> +		free_prepared_contig_range(pfn_to_page(curr), next - curr,
> +					   fpi_flags);
> +
> +		if (next == end_pfn)

Ditto.

Thanks.
.

