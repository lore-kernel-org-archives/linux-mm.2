Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCF4C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E83B6B008C; Wed, 22 Jul 2026 05:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298EE6B0093; Wed, 22 Jul 2026 05:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160D26B0099; Wed, 22 Jul 2026 05:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D09F36B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:40:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42E9AA03FF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:40:39 +0000 (UTC)
X-FDA: 85015917798.09.0A5F5D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 81E5C40009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:40:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fjMLOuBg;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784713237;
	b=zIeBylrGhoo17+dcyLg9ZjNwYG1+WPmDiHmi/Ko3vZQAxLojli9mZFPn17YRmUbW0W+Hig
	gayyenPTbYqA5rtG2rJRJM6MmFGbcmmlyjBbvaT6cgXA5Jr0m48oVWL4G+Ki4pGfh9/gJT
	vdI3WD98pS7QZDl3Y1jGow+pC29Duz8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fjMLOuBg;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784713237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4UMvly8imvHxcIAI3YLVRZx2HuJe9s4Vcuhvbq1FbU=;
	b=5hRGOlKGjxpRlMvzLBUFA6mmjE2rOuTnO8cTQSaB7W5SwZ2Yxt4+1zLyEN9bBYc4tq69C6
	lDziu+GQWjw6VxvxsvCfWTyGDnsV/oPorWpmkVTjv062KTjJyo2KKt+XSolaqujeK7EAan
	wcPe7AWGzPUi8lnVkAUI563vYbQqOqs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEC3C60A7A;
	Wed, 22 Jul 2026 09:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220381F00A3A;
	Wed, 22 Jul 2026 09:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784713236;
	bh=m4UMvly8imvHxcIAI3YLVRZx2HuJe9s4Vcuhvbq1FbU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fjMLOuBghmOwfyIusYkgjFTMJs3mvTCjCzYEVPr8hvgrRkPYRi3oDdnctkdKj1K3O
	 IyuSaIOydqAodZokUTwyCB05hz9dotCMieLgz9kJJ+UNUT7RrUbNsDpQjXpAfKO9M0
	 2Ja04BrfO2ZUFY10AoDe8p5L/kGUr7X+DcDHTQhjXBSaf2HG4fvv2gGQ/O9Upazc4X
	 Us/5tC3Tf9ShV/xxK6ENmcqxdiLVNYws4AJMXu9huRRsEOc5cHuDxUixx9/3WSE8HZ
	 8ZS/wy+kC4JeAYuYzfUbypWIcueESs5N3yCq1X7malNbAetuqUxjY7F581RwC45wTA
	 Bs1tS7nY15WwA==
Message-ID: <a77cde29-20e5-415f-be47-7c1009db4f67@kernel.org>
Date: Wed, 22 Jul 2026 11:40:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/5] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Content-Language: en-US
To: Jiaqi Yan <jiaqiyan@google.com>, linmiaohe@huawei.com, ljs@kernel.org,
 ziy@nvidia.com
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com,
 tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
 akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org,
 rientjes@google.com, duenwen@google.com, jthoughton@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <20260705180714.3708947-3-jiaqiyan@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260705180714.3708947-3-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kzczirkzfgrpkb7p9kagmqfphwa7xbka
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 81E5C40009
X-Rspam-User: 
X-HE-Tag: 1784713237-478542
X-HE-Meta: U2FsdGVkX1/x7HGa95uinaErHz+AL/v/CsnoC+I6q+Oy5IKLyQfGp2hWbymmEffpUvIru7kHKtmS3xfHrCECDgXID+0DJr0egCndXL1PBlpiFkyT8sO+nigJX+S+kX0ZFumr4tTKV0TFEfb25AK+b2cFp+lKJynyHfc5OchyMYfIc8yUSpkgJ+Vky34PUcVBz3snNXND8j1jFap47OjstAvxYMrXSGgSUU+8lbTaXiML6PWPjnF9ORfdLF92m/PJogwyo2CL38K+EJmSzBbtYR15+6+JJEUGPF/6fgABgZUe0BVtyXytKJb70RG4gnUQtKtyJvOgfI4Z701CgsehBQaqJOf6KD/6n264gVL6+TBdZ8X1V9gUgOr3m8qzKNjjndkhBxPXWY4soOxwG0MIAKH6YqEOy7oUyYkhyTA4B87ozYWMnF8gYkPc7VogdSzj6x10Kk4RPTwcJebmMGkgTgrVB5Y7Ml7m5NrgmK5S2s3fsncGGdpEiaWsYZGterIMaYlquQDGV0egTgPF1bou2vrt6KC1LuabRBJ3XNfNo/FtgOeZDTM/9+hjlASWgTVzH23KnPpA/pYK7H8zBcQEHTo10Y52Mv4+TO8haMogY6eC+EkWwk2+iBVn95c28xntHd4dTxzBj0FKwUFtEIXE+cz03THspDWb2BEw9ZSt8uSbHaB8eGFE4WqK0WZbwMnlYUNectjv0reFz2iF3GFpjCbptjWUUeKqsj8Np4tTT0g74x60jkmZWH4gJGt+LUA2R208OgO1XOZ+MQgU8lhZ5t8KdyrahFD5+cfCemX62U7uGctDC0OLEAkVwSOchgh6VTY5mRJuCL977/m9XBcBdPyWhDL2lFYRpHnybhlexeeLg1ZuNCFsv0j6Cfr3ab18ZUQ6c1650gYQGAX4QSvICcBCX66j1UphFit7CqsHa/fd9zirl08tCdcTqZlKFr1IxPNR8qm+PzJu+/5BzmT
 JagAzE3C
 nNmBLP45AmxaCEU/nbWmy0JtwF3lcXdahH/KEoX/33I0K4AA9landoipo0tLi7ezIxBsRtLaw2/F0y+FzwIZyVIFMSKzeHWoTaIZtQ8/DY8QCydlir2zRi+rPAeyjc5Yu53yzP4W1lrbWJMvx3Og6zgwriCsaYFxJW42a8r4gqJi9EL1oAc2COslVT2LUnDkbR9o8d5XnbKvG1oIcsNtNh3d1NmPh0Rkg8FJL33SatUqrcjUxGCJvcPRs6C3sZ8xGG3Una/jttFcY2XsPvNWuSE1vo+oBRafQIv7jMXHP8vOV91r/5N9SI7p7Jfmtk1fdjE6UAZVx5+aVp3qvsehv34rGEG+OAwtek2exX6tkv7RwV4ullyYNVE2X3Ik4AOD6t9y/goRFvUHXQrNVMWOyUz+gti0NWHFtJakdo0GyAtPmOqdvKOH76aH52gwGn+Uv1AXUlN9vBVP7H8eY3VqtipMAW95sHvIuIXLaa4MdCeBqbEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 20:07, Jiaqi Yan wrote:
> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> becomes non-HugeTLB, and it is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
> 
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can
> be given out with its buddy page and be re-used by either
> kernel or userspace.
> 
> Memory failure recovery (MFR) in kernel does attempt to take
> raw HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio(). However, there is always a time
> window between dissolve_free_hugetlb_folio() frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison
> raw page off buddy allocator.
> 
> Another similar situation is when a transparent huge page (THP)
> runs into memory failure but splitting failed. Such THP will
> eventually be released to buddy allocator when owning userspace
> processes are gone, but with certain subpages having HWPoison.
> 
> One obvious way to avoid both problems is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
> 
> Introduce free_has_hwpoisoned() to only free the healthy pages
> and to exclude the HWPoison ones in the high-order folio.
> The idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages.
> 
> free_has_hwpoisoned() is added at the end of __free_pages_prepare()
> as a shortcut and only if PG_has_hwpoisoned indicates HWPoison page
> exists and after checks and preparations in __free_pages_prepare()
> all succeeded. It then use __free_prepared_contig_range() to
> decompose healthy range into the largest possible chunks of
> different orders, then freed via __free_frozen_pages().
> 
> free_has_hwpoisoned() has linear time complexity wrt the number
> of pages in the folio. While the power-of-two decomposition
> ensures that the number of calls to the buddy allocator is
> logarithmic for each contiguous healthy range, the mandatory
> linear scan of pages to identify PageHWPoison() defines the
> overall time complexity. For a 1G hugepage having 8 HWPoison
> pages, free_has_hwpoisoned() takes around 1ms on average on
> a system having 56 Intel Skylake physical cores. This is
> 15x to the case of freeing no HWPoison page. The cost is far
> from triggering soft lockup, and fair for handling exceptional
> hardware memory errors.
> 
> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

One thing below:

> @@ -6956,6 +7016,61 @@ void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>  	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
>  }
>  
> +/*
> + * Given some contiguous pages that have certain number of HWPoison page(s),
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
> + * It also works when order == 0, regardless of PageHWPoison() or not.
> + *
> + * This implementation needs rework in memdesc world.
> + */
> +static void free_has_hwpoisoned(struct page *page, unsigned int order,
> +				fpi_t fpi_flags)
> +{
> +	unsigned long curr = page_to_pfn(page);
> +	unsigned long end_pfn = curr + (1 << order);
> +	unsigned long next;
> +	unsigned long total_freed = 0;
> +	unsigned long total_hwp = 0;
> +
> +	while (curr < end_pfn) {
> +		next = curr;
> +
> +		while (next < end_pfn && !PageHWPoison(pfn_to_page(next)))
> +			++next;
> +
> +		if (next != end_pfn) {
> +			/*
> +			 * Avoid accounting error when the page is freed
> +			 * by unpoison_memory().
> +			 */
> +			clear_page_tag_ref(pfn_to_page(next));
> +			++total_hwp;
> +		}
> +
> +		__free_prepared_contig_range(pfn_to_page(curr), next - curr,
> +					     fpi_flags);
> +		total_freed += next - curr;
> +
> +		if (next == end_pfn)
> +			break;
> +
> +		curr = next + 1;
> +	}
> +
> +	pr_info("Freed %#lx pages, excluded %#lx HWPoison pages\n",
> +		total_freed, total_hwp);

Should we really print this? Maybe just pr_debug() or not at all?

> +}
> +
>  #ifdef CONFIG_CONTIG_ALLOC
>  /* Usage: See admin-guide/dynamic-debug-howto.rst */
>  static void alloc_contig_dump_pages(struct list_head *page_list)


