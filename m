Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C34D3CCAA
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2436B0088; Wed, 14 Jan 2026 22:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39FEB6B0089; Wed, 14 Jan 2026 22:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2826A6B008A; Wed, 14 Jan 2026 22:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 106CB6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:42:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45BDB1398B3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:42:00 +0000 (UTC)
X-FDA: 84332799600.21.DCB54E7
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf11.hostedemail.com (Postfix) with ESMTP id 522DC40008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:41:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=imeh2gQy;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768448518; a=rsa-sha256;
	cv=none;
	b=RNfmdhrhrEnJiVofI1rRvRLFPqgbJh9ODLDbD304hzZheFZuG/GuADhxhY5E2QpzSRXOfJ
	YtiATgr2p+/jHx6TzKpA1ljPr76D/tvPfonn2Ko6Ar7jO33F86mUIE5LLHaQn1ijWgFvdV
	mhZYzd8Nkm4jMwbeb2QjCWBnkqZPwB8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=imeh2gQy;
	spf=pass (imf11.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768448518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVQCjDWM4p7/HO/QYULMb9geDprLDOiFu5R6foDcOj0=;
	b=exG8yIibTxJDsDVtQPlDR7J4lyw04263+DKo18+Q/jI5ElmVMbcD+H6Sf30ThrIQGx1ghf
	L+lQkFFtFY53zvEw0Q6SwG2kzXPiKzmEgZ0GO8Jk/rmj6joY/YfeRWr0Gv0XYj7r8ExY2P
	L3VIGGPAtu7VJwjBihDu+o8NJJKqUbw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MVQCjDWM4p7/HO/QYULMb9geDprLDOiFu5R6foDcOj0=;
	b=imeh2gQyFkyUWsl5mFaJuNUGqN7XbF0qR8ILODVsp4Lb0q1mS5ISKDudG6BOgs/xEeqIGSDqb
	t42QeVxLA1OtUYhGGmRj29WPtY3i3bJ2Cr1zNNwlp6rrKZJeuZTsckkgqpb3fl3ooAGGSLl0kjy
	MXUdXoxcs/IAeMJhDvOzKFM=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4ds7xL30bfzRhRw;
	Thu, 15 Jan 2026 11:38:30 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id B9AB0201E9;
	Thu, 15 Jan 2026 11:41:50 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 11:41:50 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 11:41:49 +0800
Subject: Re: [PATCH v3 3/3] mm/memory-failure: refactor page_handle_poison()
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <nao.horiguchi@gmail.com>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <william.roche@oracle.com>,
	<tony.luck@intel.com>, <wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <osalvador@suse.de>, <muchun.song@linux.dev>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>, <harry.yoo@oracle.com>,
	<willy@infradead.org>
References: <20260112004923.888429-1-jiaqiyan@google.com>
 <20260112004923.888429-4-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <e996cec7-f2ed-38ae-3f8a-c89ef61ffa49@huawei.com>
Date: Thu, 15 Jan 2026 11:41:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260112004923.888429-4-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: 8nn9rgc4qh39578edhwtn8nqagt56owe
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 522DC40008
X-Rspam-User: 
X-HE-Tag: 1768448516-986006
X-HE-Meta: U2FsdGVkX1+xRT0habAHvYJxLYjSkRW6jlQNJc30TTYokraVDP1JrB7mdz+n6o3ex7VvkLSUTU3zfQ38yF8OXT9E4VAVzJOVLPc2ydV4TUzzV+3HVUZAoXzo23yZ+f7GVaq13YHzWiL0SwB/Aiy/hNmqlccabS3iwlRFckk0PCV0/mdUnLR2x8oaq1WJi0/CfdI7/c/KTLjle2Srov7cjSvoNpLIs8KNnO0k6In8jUpjzlTZlHYGEhSXbWyF8FhJz9F7/tzYKMxUUVU5EbgrHhVTVGZKsaFw6my1HRsqIFifAdt/UeGJJ//tJ9fgpsgflmBfxpx8qMD1AxBgec7zTIyVFFgUvqSYYkuA4CFWfRh+cAOWMNdD27+1XsX4NUfT1hLiL7B4K6+xrdveJQYmc2/Fu1UrVQRwegji/LsqMOtsalEDEavl9soEe3++E0iutUrjOq2wiuNvLU3wX6uwBn3PtSaASdZKAIeRczw6Y+vQw+ATS0MAlgb7idtG45JtEA1db55bsn664hizi3HZ8284KUSCmsUCEFnnmN2ZgPSFozdmRGAGO9GiC4DTfefe53WB9TZiEXsJiim+woyQlgNcjeOnw+mdGqBs4RW+zCHTZxn7om/z23gpn/lSzNzxDAL0L1Y7kXIHpmMwvWCdkk1nA2PTdKVuwdmiMaSPkaJ1krHu7sDlWJ65exRJXCXwgVDcvhuclpCmTw1vp9SshWDpViyOCIY2lFgxbcidDjkjKjiWZ/yqzVVeVRBlmM3m7N67q1GFKvvQ4MquitwT/vYuPlLmSd0Wcm4LGLKNZjVDunXDE/uikcdQFep9rzL+PFYiEQM4vL8gWu+YOolWSpu69N7NjRFVnU7wfHIDXva8Cj5covqO71Y/fIcVUOpK2Cdc7FO9CPzK9QVtpVtpbHwqltJjQBCG7SEZQwM20BNSZLmBpN9L/4kkoAY/sBuhUQdRFmqYSeFJU/yG0kF
 7GWbgysW
 q7p0H6NWui2nVSQBboZEb3Iq97x4k/P29F3rXsem3GWL53VJtdyY8axOt0eyHSQzmsJBnUyWUlVo8yyrweVHWSw/muy78eqEyRC+k8Tki1tAFEP2z/xB0OlHUrwPV5B+yOzriCPLYgMTaaqGEMqGqt4tSBT3dU+2zGFDGjVLzDs4ny91jYVgYIz3mMPOCw8LFB5irSDEhOXmE8QIhziaVYzbEAZ15euCwm7U+LbXinU8Gu65p5HwR3WNyjmnNsq51MsW84XiwNhDy5V8F5NxL6U2vYiV0lxVNyIgHMQWskRVCVTlEWbbgIZhN3iH2q4bLIzOOggoQIInzeZ2VzGSBq5hI9g6z//Qn6FpANdhFfxgKVcjdhe1op8gnJZGYZTpiFKaLKgt4j6EopTdNoxQ5BbNMaUiXhVllHwgNkufDCtgSpb0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/12 8:49, Jiaqi Yan wrote:
> Now that HWPoison page(s) within HugeTLB page will be rejected by
> buddy allocator during dissolve_free_hugetlb_folio(), there is no
> need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
> calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
> succeeded returns false, making caller think page_handl_poion() failed.

s/page_handl_poion/page_handle_poison/

> 
> On the other hand, for hardware corrupted pages in buddy allocator,
> take_page_off_buddy() is still a must-have.
> 
> Given hugepage and free buddy page should be treated differently,
> refactor page_handle_poison() and __page_handle_poison():
> 
> - __page_handle_poison() is unwind into page_handle_poison().
> 
> - Callers of page_handle_poison() also need to explicitly tell if
>   page is HugeTLB hugepage or free buddy page.
> 
> - Add helper hugepage_handle_poison() for several existing HugeTLB
>   specific callsites.
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  mm/memory-failure.c | 84 ++++++++++++++++++++++-----------------------
>  1 file changed, 41 insertions(+), 43 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index d204de6c9792a..1fdaee1e48bb8 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -162,54 +162,48 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
>  
>  static DEFINE_MUTEX(pfn_space_lock);
>  
> -/*
> - * Return values:
> - *   1:   the page is dissolved (if needed) and taken off from buddy,
> - *   0:   the page is dissolved (if needed) and not taken off from buddy,
> - *   < 0: failed to dissolve.
> +/**
> + * Handle the HugeTLB hugepage that @page belongs to. Return values:
> + *   = 0: the hugepage is free hugepage and is dissolved.

In soft offline scene, dissolve_free_hugetlb_folio would return 0 when the page becomes
a normal page due to race.

> + *   < 0: hugepage is in-use or failed to dissolve.
>   */
> -static int __page_handle_poison(struct page *page)
> +static int hugepage_handle_poison(struct page *page)
>  {
> -	int ret;
> +	return dissolve_free_hugetlb_folio(page_folio(page));
> +}
> +
> +/**
> + * Helper at the end of handling @page having hardware errors.
> + * @huge: @page is part of a HugeTLB hugepage.
> + * @free: @page is free buddy page.
> + * @release: memory-failure module should release a pending refcount.
> + */
> +static bool page_handle_poison(struct page *page, bool huge, bool free,
> +			       bool release)
> +{
> +	int ret = 0;
>  
>  	/*
> -	 * zone_pcp_disable() can't be used here. It will
> -	 * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() might hold
> -	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
> -	 * optimization is enabled. This will break current lock dependency
> -	 * chain and leads to deadlock.
> -	 * Disabling pcp before dissolving the page was a deterministic
> -	 * approach because we made sure that those pages cannot end up in any
> -	 * PCP list. Draining PCP lists expels those pages to the buddy system,
> -	 * but nothing guarantees that those pages do not get back to a PCP
> -	 * queue if we need to refill those.
> +	 * Buddy allocator will exclude the HWPoison page after hugepage
> +	 * is successfully dissolved.
>  	 */
> -	ret = dissolve_free_hugetlb_folio(page_folio(page));
> -	if (!ret) {
> +	if (huge)
> +		ret = hugepage_handle_poison(page);
> +
> +	if (free) {

Nit: huge and free won't be both true. So we could write it as:
	if (huge) {
		...
	} else if (free) {

>  		drain_all_pages(page_zone(page));
> -		ret = take_page_off_buddy(page);
> +		ret = take_page_off_buddy(page) ? 0 : -1;
>  	}
>  
> -	return ret;
> -}
> -
> -static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
> -{
> -	if (hugepage_or_freepage) {
> +	if ((huge || free) && ret < 0)

Nit: ret won't be <0 if both huge and free are false. So I think we might simplify it as:

	if (ret < 0)

>  		/*
> -		 * Doing this check for free pages is also fine since
> -		 * dissolve_free_hugetlb_folio() returns 0 for non-hugetlb folios as well.
> +		 * We could fail to take off the target page from buddy
> +		 * for example due to racy page allocation, but that's
> +		 * acceptable because soft-offlined page is not broken
> +		 * and if someone really want to use it, they should
> +		 * take it.
>  		 */
> -		if (__page_handle_poison(page) <= 0)
> -			/*
> -			 * We could fail to take off the target page from buddy
> -			 * for example due to racy page allocation, but that's
> -			 * acceptable because soft-offlined page is not broken
> -			 * and if someone really want to use it, they should
> -			 * take it.
> -			 */
> -			return false;
> -	}
> +		return false;
>  
>  	SetPageHWPoison(page);
>  	if (release)
> @@ -1174,7 +1168,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>  		 * subpages.
>  		 */
>  		folio_put(folio);
> -		if (__page_handle_poison(p) > 0) {
> +		if (!hugepage_handle_poison(p)) {
>  			page_ref_inc(p);
>  			res = MF_RECOVERED;
>  		} else {
> @@ -2067,7 +2061,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>  	 */
>  	if (res == 0) {
>  		folio_unlock(folio);
> -		if (__page_handle_poison(p) > 0) {
> +		if (!hugepage_handle_poison(p)) {
>  			page_ref_inc(p);
>  			res = MF_RECOVERED;
>  		} else {
> @@ -2815,7 +2809,7 @@ static int soft_offline_in_use_page(struct page *page)
>  
>  	if (ret) {
>  		pr_info("%#lx: invalidated\n", pfn);
> -		page_handle_poison(page, false, true);
> +		page_handle_poison(page, false, false, true);
>  		return 0;
>  	}
>  
> @@ -2836,7 +2830,7 @@ static int soft_offline_in_use_page(struct page *page)
>  		if (!ret) {
>  			bool release = !huge;
>  
> -			if (!page_handle_poison(page, huge, release))
> +			if (!page_handle_poison(page, huge, false, release))

This might not work for soft offline. PageHWPoison is not yet set so folio_clear_hugetlb_hwpoison
won't be called when dissolve hugetlb hugepages...

>  				ret = -EBUSY;
>  		} else {
>  			if (!list_empty(&pagelist))
> @@ -2884,6 +2878,8 @@ int soft_offline_page(unsigned long pfn, int flags)
>  {
>  	int ret;
>  	bool try_again = true;
> +	bool huge;
> +	bool free;
>  	struct page *page;
>  
>  	if (!pfn_valid(pfn)) {
> @@ -2929,7 +2925,9 @@ int soft_offline_page(unsigned long pfn, int flags)
>  	if (ret > 0) {
>  		ret = soft_offline_in_use_page(page);
>  	} else if (ret == 0) {
> -		if (!page_handle_poison(page, true, false)) {
> +		huge = folio_test_hugetlb(page_folio(page));

folio_test_hugetlb check is racy because there's no guarantee that hugetlb hugepage won't
be dissolved before calling page_handle_poison. That will lead to problem...

soft_offline_page
  folio_test_hugetlb -- true now
  page_handle_poison
  /* Hugepage is dissolved somewhere. */
    hugepage_handle_poison -- return 0 because page is normal page or free buddy page.
    SetPageHWPoison(page);
    page_ref_inc(page); -- refcnt is increased while page might be on buddy...

> +		free = is_free_buddy_page(page);
> +		if (!page_handle_poison(page, huge, free, false)) {

We assume free is always true due to ret is 0. So we can write it as:
	if (!page_handle_poison(page, huge, true, false)) {

>  			if (try_again) {
>  				try_again = false;
>  				flags &= ~MF_COUNT_INCREASED;
> 

Thanks.
.


