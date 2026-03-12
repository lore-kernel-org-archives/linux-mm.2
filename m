Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E770106ACEE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC186B0088; Thu, 12 Mar 2026 17:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89FB6B00A0; Thu, 12 Mar 2026 17:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62766B00C0; Thu, 12 Mar 2026 17:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A59116B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:03:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69C971A03B8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:03:37 +0000 (UTC)
X-FDA: 84538637274.20.D4CF223
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C81140006
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:03:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ougADOEQ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773349415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUFpoVB2as5kwsYAmu5fmaCESlAjCJ8PbITONEdlvYc=;
	b=m/s66uE3iFhZuJmAMOVDskBAymieS2ftuHQWfyf98b1tLWEvFaaIstUTVQnFQCwb2KWftW
	AxH78QTgL/82dYuiSRgf2drnXD1EYioJ+pQmcSwj3JkY9MmUDY4mRUv8V93+pHjEzfa0J7
	HPmf3yV7J6aaF8XPlfC5fChT7wga6c8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ougADOEQ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773349415; a=rsa-sha256;
	cv=none;
	b=hG9PjFBDtOBuxHPgiUvW1hUESso4eGtQNSiUsAFjemAOR7aRKc3omIf/EkUg5HepsdYNWl
	hWO3Qak0ixWOE57xaUnEiPprZvrDcQktJgvUuhM/LhuDTM8LGnlb1Kz8uDfTju61OQpYxk
	PJ6qpEiGVjBWcfjt2XJD6zQxlLoUdwg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 889FB406CA;
	Thu, 12 Mar 2026 21:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81553C4CEF7;
	Thu, 12 Mar 2026 21:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349414;
	bh=j67sQrV3ZgFn94Az8KNnZQbIoDiwcjX9ZhxAp6uitSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ougADOEQUaC5Qw7JSDoIRTSR3iRdA62MZrPNp0p4ZNCoGjRn758QQprGJbok31CxP
	 8YYIoffOLiWwOKlezeT/5ikXhTpapW4NjppnXTSCxqhLNSfJFfehX7iMXNTTq/fBQ5
	 X1lS4QfqH50c2JI8Nkn9zpyATVeoa0g9tjRC6HHyLbFX/i66rQsIOA5eeWISKm3Aw6
	 6FX/LSax1ODBp4DIC4yxQLQcwH41gr/vFR9c/qrPsPvyCiLgq9LmBgC0W1QFDaffy0
	 bz3PsJgaapTbI4Q+r+MaGKFl2UDeUcAY36Ppgmlzw344HG6E2rbwH1HfNEJPthptXk
	 eQNTkFJ0zyC6Q==
Message-ID: <01d1a79c-236f-4968-817f-d89c039019b0@kernel.org>
Date: Thu, 12 Mar 2026 22:03:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 07/13] mm/khugepaged: add per-order mTHP
 collapse failure statistics
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032504.233594-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226032504.233594-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8C81140006
X-Rspamd-Server: rspam07
X-Stat-Signature: mmag5uqkxkcwpdjgtutjmtz6odqhp8g4
X-Rspam-User: 
X-HE-Tag: 1773349415-938866
X-HE-Meta: U2FsdGVkX1+7Qwo2gUuABregP84ZMF+MWiRCbf93LPc8ftPzCTwlI8nOnmALcFglSk6cTKgT0KPULMH0zt3oFG4r29C97mv7E42H4uukmFctgAdLvLq1wsXmneAXCQ57ZGsGuybGB/E19WAxUBw43jHwNqYCjgUVqsAT9ehQha8zbe+J80iJ2Or2xUpP7Z2S7SNcmoKyg0sL4ImhIxYFFMBkM0GaXvuBTrmi/XNOdNDCknOuVaQlSVv4YLfJ5vCN/3UWFKUlFYgwPGtnfcH2hvRGsrTmj/nvJipdQUhq/RMuvO99VDlyD9EyUI2lGYGwJzumsAV5+qL/62nWzfhzOvOHk+c++zwI1H/8ivy06Apyj+3MjzUz9rSXVY7YUVvKBVRLlD+6GCDOZddMoy6YAQqF8lrEkK5tAm3erbFrxtJI2TNf4CldMZWXZiVXJ1zDpeodN1u99DmkijxE1d+bc0MQpiRM5jyKX4ud3Rx8eV6UGWo91EQieKsvYtQV7TvDCWoN10uxsrsJdRYo/JWPIxH97GuaDmqkBE0tpkhdeb63vzNeWxvpULC3heymE40o5Dn/TL5xWqllnDdjBs4lrg1bLwmJxa5ofxLKb7n1PTxPEJdwjhZiIP9hdVbMaol4I2fbvnthEC87lhpHu3RI22hv3QP9Jb5K0DvA9VRljPEyYo2zddlv89uu/qYcGVnog7pXDvHlZ7WrkFz0zOwUjUNkBHtFM7W5Nrj819qOSsncUIcVPa9sQH11oRljTwagegJvbIRxl8TQxkTRlkAy2Vnt1ysiOSWnYFdf0hjCALD27jMepua8fvx3YEbSvDaZ+F3svfzK4FkjfLPRKVntSQ1iEc65xUdboCBckiZHQfIj5aHrIbhfCicg7R2mAKnms/vm7j04hU9f7kplAxKw69LjAMxmRSXpTxDl1ttuIxcs3Koq8aUOna4Tltlh7Oceqnd/INVrVpKPU9I47U0
 B3ttRQaT
 nN2XiMYVLnWtM8i9SQKCoUXKRMxI51vYGZhlB6zpjNO51KFv0Swi3mw1K3LIoT6GG9LGqQroEe+Uzl2gOL6xJajsPQswG3PVidUs5tSxUIB4txwIYI29R+gqAydrb5geGcKMBtRUJXKgYSajokaFh9/0Nbr1oc1c6ZR3zmRImraK4jXNE/mM8WLrnbS3hZMyWURZIHhAYkn2N3H8KGuOWiQsHFnthN6d4Vj1b/7uLJsaNGHgYEUV0B/dqaDQQS+L5tGEYhBPhyKkQKhjkg4faz3wup/cZeQlNz0GNKWJ2XF5LDSlGm6p+NDBd732F39h+7NkOU7l+p+qwDgh/WhSVosLf8q1Tps8yijGsw+CMtBxWmJUmHRA5+Qf5bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 04:25, Nico Pache wrote:
> Add three new mTHP statistics to track collapse failures for different
> orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:
> 
> - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
> 	PTEs
> 
> - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
>   	exceeding the none PTE threshold for the given order
> 
> - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
>   	PTEs
> 
> These statistics complement the existing THP_SCAN_EXCEED_* events by
> providing per-order granularity for mTHP collapse attempts. The stats are
> exposed via sysfs under
> `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
> supported hugepage size.
> 
> As we currently dont support collapsing mTHPs that contain a swap or
> shared entry, those statistics keep track of how often we are
> encountering failed mTHP collapses due to these restrictions.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 24 ++++++++++++++++++++++
>  include/linux/huge_mm.h                    |  3 +++
>  mm/huge_memory.c                           |  7 +++++++
>  mm/khugepaged.c                            | 16 ++++++++++++---
>  4 files changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index c51932e6275d..eebb1f6bbc6c 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -714,6 +714,30 @@ nr_anon_partially_mapped
>         an anonymous THP as "partially mapped" and count it here, even though it
>         is not actually partially mapped anymore.
>  
> +collapse_exceed_none_pte
> +       The number of collapse attempts that failed due to exceeding the
> +       max_ptes_none threshold. For mTHP collapse, Currently only max_ptes_none
> +       values of 0 and (HPAGE_PMD_NR - 1) are supported. Any other value will
> +       emit a warning and no mTHP collapse will be attempted. khugepaged will
> +       try to collapse to the largest enabled (m)THP size; if it fails, it will
> +       try the next lower enabled mTHP size. This counter records the number of
> +       times a collapse attempt was skipped for exceeding the max_ptes_none
> +       threshold, and khugepaged will move on to the next available mTHP size.
> +
> +collapse_exceed_swap_pte
> +       The number of anonymous mTHP PTE ranges which were unable to collapse due
> +       to containing at least one swap PTE. Currently khugepaged does not
> +       support collapsing mTHP regions that contain a swap PTE. This counter can
> +       be used to monitor the number of khugepaged mTHP collapses that failed
> +       due to the presence of a swap PTE.
> +
> +collapse_exceed_shared_pte
> +       The number of anonymous mTHP PTE ranges which were unable to collapse due
> +       to containing at least one shared PTE. Currently khugepaged does not
> +       support collapsing mTHP PTE ranges that contain a shared PTE. This
> +       counter can be used to monitor the number of khugepaged mTHP collapses
> +       that failed due to the presence of a shared PTE.
> +
>  As the system ages, allocating huge pages may be expensive as the
>  system uses memory compaction to copy data around memory to free a
>  huge page for use. There are some counters in ``/proc/vmstat`` to help
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 9941fc6d7bd8..e8777bb2347d 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -144,6 +144,9 @@ enum mthp_stat_item {
>  	MTHP_STAT_SPLIT_DEFERRED,
>  	MTHP_STAT_NR_ANON,
>  	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> +	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> +	MTHP_STAT_COLLAPSE_EXCEED_NONE,
> +	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
>  	__MTHP_STAT_COUNT
>  };
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 228f35e962b9..1049a207a257 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -642,6 +642,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
>  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
>  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
>  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +
>  
>  static struct attribute *anon_stats_attrs[] = {
>  	&anon_fault_alloc_attr.attr,
> @@ -658,6 +662,9 @@ static struct attribute *anon_stats_attrs[] = {
>  	&split_deferred_attr.attr,
>  	&nr_anon_attr.attr,
>  	&nr_anon_partially_mapped_attr.attr,
> +	&collapse_exceed_swap_pte_attr.attr,
> +	&collapse_exceed_none_pte_attr.attr,
> +	&collapse_exceed_shared_pte_attr.attr,
>  	NULL,
>  };
>  
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c739f26dd61e..a6cf90e09e4a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -595,7 +595,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				if (is_pmd_order(order))
> +					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
>  				goto out;
>  			}
>  		}
> @@ -631,10 +633,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			 * shared may cause a future higher order collapse on a
>  			 * rescan of the same range.
>  			 */
> -			if (!is_pmd_order(order) || (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared)) {
> +			if (!is_pmd_order(order)) {
> +				result = SCAN_EXCEED_SHARED_PTE;
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +				goto out;
> +			}
> +
> +			if (cc->is_khugepaged &&
> +			    shared > khugepaged_max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out;

With the suggested earlier rework, this should hopefully become simply

if (++shared > max_ptes_shared) {
	result = SCAN_EXCEED_SHARED_PTE;
	if (is_pmd_order(order))
		count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
	count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
}

With that (no code duplication) LGTM.

-- 
Cheers,

David

