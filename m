Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C29EEF94CC1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 03:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFDC6B0088; Tue, 21 Apr 2026 23:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021E56B008A; Tue, 21 Apr 2026 23:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53156B008C; Tue, 21 Apr 2026 23:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D06856B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:36:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79B3E160A4B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:36:20 +0000 (UTC)
X-FDA: 84684778920.23.DAD405A
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf04.hostedemail.com (Postfix) with ESMTP id 606E240002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:36:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QXbWGHXJ;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776828978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6ErxBpv7j41lD24Px4I6ELysKNDAglB1vPay9pX7i4=;
	b=AgSQtTXbSS2BcydRa0DOAcwXuUTMYAI8WXBUtTsYeCZRqpzkbb/ckd0x/df3gAxEPT9jyX
	mVU5jzZVHmXV4DlZqbxVQXqUAAq/wXZJ+6/TkTrOTF8fSxjPeGyTqHK0TA+ugBpbN9WfN0
	wp1Vimmo5NUFHMY+fp5tiOPKfUfaSiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776828978; a=rsa-sha256;
	cv=none;
	b=G02OYHVhuUTBKu9KWNoz98DyhDphEj+dGGIC0tBhUqa1EtoaV1JTJtxkOk6vlzm9A9uds0
	8tULbzd8bCEHOM09920/Bbs0HFjBPhJV4wZpEZh5jEPi/bBgYDgDuOEZQyA8N9VzfovAdw
	y+Yn+MU0lQsNtfaTxgaFhJyiONVVkxM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QXbWGHXJ;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=F6ErxBpv7j41lD24Px4I6ELysKNDAglB1vPay9pX7i4=;
	b=QXbWGHXJFdl+95v48M6njnIQGNRjE1rTdBFreeoS8EQesHBy/WRPOCTucvX+BxC/9gzmv6JsX
	hc7JsxNChu6DhxmBt7XhmBc+mt366898D9XTGiDzR20QOzxyqQt38mV5rqjIT6+Si2gSJ41NGDk
	rPaMRQO6a30Djdx8JUVLaaM=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4g0l8X5DSNzpStt;
	Wed, 22 Apr 2026 11:29:48 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F37F940537;
	Wed, 22 Apr 2026 11:36:12 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 11:36:12 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 11:36:11 +0800
Subject: Re: [PATCH v4 2/3] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-2-2d0277f8f601@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6b505601-747a-0812-7544-63a8ab3cffce@huawei.com>
Date: Wed, 22 Apr 2026 11:36:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260415-ecc_panic-v4-2-2d0277f8f601@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: f3npny1eirzfyticpzg14i16386fedhh
X-Rspam-User: 
X-Rspamd-Queue-Id: 606E240002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776828977-745641
X-HE-Meta: U2FsdGVkX19cLwwPimiUUx2neN9wwYAjMJ31yQ0+gYIXN2tVZC/fJrUQFIKnaf7Ep1J6VbjhdY9n7rzfVvmlJYWFtASfuj3tdHNgBAvnIt769/q5UlILqOc0BFIqetNJhXWn0SiJFwZIUGmAh21pGl0f+9ID1wQNB5RtnaHF9PtJgPkFzP+9EBKHJTuLLfpXDLKtQC6vsgUqmYT+GJUmRuZKkcRnAAfD4tu8DiFbpjDCCn48rlOqN/gdiXA5cqyTu+pqeVuwqAseJ6LFlGhdiMHOhLmHdO+XFV0ZrzcYJZ2ra8LL+w0wXdx93cjwBf49MVd45A1DseArw3faWbYmMKjbGccs+7y5myej8R+Z1uhSmexQv/pgfHgZ7xO9ozCEZgVedEVZoAzBS2VLRcdBCawKeG69lWsnYECgxU2evtRBDx91w/JsZoCaPZZwHPeH3MLnonFxLv7tPsAo3cks8HCUqnt6r/oYv2aUfm7neDQJOxM3hKXDBYI4z+CwCoyHdbR7Gk8UEMcPB6KOKvRX5ni4QyRFWokvJDXHjrqAEjz26Sjl32vShwbRCnABWz+ZZNUvEdtwR54nA4HYkmq21wOzexkt4oiIG/EgMsPA1id53eHzDzrOtYK8wsH8ymlPPqZt1m9VeRMDYDQyJ8OVKT0FvZT5QFvbuByzd4+KBlOqrxNY+KjueuX6XvTFb3JvCRovct2OgKGz7fcLxstaRnqAXFowVkN7RMIuteeWADp3YX1mpm4JezcH5+nlsT2Md5W4QqNMGgOaxdenhtyAJI5tTYh7P07+irZ6d0YA6TzARD6ETMf2j6gBfVT9lwz13OkurK42a2odHiYiWqZ9tqLtVtqrmal4NHiokB3Xag6RjOkP+2obNDcS3w4W/XfGy7l+VF5HqJV9/HR+mauDMuPH29VfjdBsWkmg7OlsEZWjtkCeG+1zg1h/oDIX7s9JpqwOSF2/8bU9t9sb+vi
 eo5XnPBK
 lHRybsml3rfMek2ftBC2rCucjjI4P3xb0VBHYgs9P/JHtdQMUBZAbEvGyXHQPpzu0vTqg2vBylUrssPzTPU/Nk4LCR2u+ySnnF3cRGSdRL3nAOEn/Bhj/S8gEZ02dCzhF9rgWrP3T0v+mes52xQXViBQWEW3qCBmSOx9js/NUtcoxBFKaa8coFYwhSeJUlrv4/ckTc7NodN3Wy+O4IL39ExgVX5GxMe/aV0ePfRmcehZuUeC5ZF2CriP+HEpJTZ4R2tJ20dc8XmW0MhIhP/OE2dZ8ZOC2S3DThCTJMN9fVErzr6/GTe/KpnUjnooDPyFb1+jq3ifepdXnxYHUOimPCCzL0nxajW2wsYJBZ679q6k7+FJjdJK3QnVBbbuL263LiEhJfqgPKy/uPODOsKr0Mb2TSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/15 20:55, Breno Leitao wrote:
> Add a sysctl panic_on_unrecoverable_memory_failure that triggers a
> kernel panic when memory_failure() encounters pages that cannot be
> recovered. This provides a clean crash with useful debug information
> rather than allowing silent data corruption.
> 
> The panic is triggered for three categories of unrecoverable failures,
> all requiring result == MF_IGNORED:
> 
> - MF_MSG_KERNEL: reserved pages identified via PageReserved.
> 
> - MF_MSG_KERNEL_HIGH_ORDER: pages with refcount 0 that are not in the
>   buddy allocator (e.g., tail pages of high-order kernel allocations).
>   A TOCTOU race between get_hwpoison_page() and is_free_buddy_page()
>   is possible when CONFIG_DEBUG_VM is disabled, since check_new_pages()
>   is gated by is_check_pages_enabled() and becomes a no-op. Panicking
>   is still correct: the physical memory has a hardware error regardless
>   of who allocated the page.

What if the page is used by userspace? We can recover from later accessing.
Would panic here be overkill?

Thanks.
.

> 
> - MF_MSG_UNKNOWN: pages that do not match any known recoverable state
>   in error_states[]. A theoretical false positive from concurrent LRU
>   isolation is mitigated by identify_page_state()'s two-pass design
>   which rechecks using saved page_flags.
> 
> MF_MSG_GET_HWPOISON is intentionally excluded: it covers both
> non-reserved kernel memory (SLAB/SLUB, vmalloc, kernel stacks, page
> tables) and transient refcount races, so panicking would risk false
> positives.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 7b67e43dafbd1..311344f332449 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
>  
>  static int sysctl_enable_soft_offline __read_mostly = 1;
>  
> +static int sysctl_panic_on_unrecoverable_mf __read_mostly;
> +
>  atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
>  
>  static bool hw_memory_failure __read_mostly = false;
> @@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_ONE,
> +	},
> +	{
> +		.procname	= "panic_on_unrecoverable_memory_failure",
> +		.data		= &sysctl_panic_on_unrecoverable_mf,
> +		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_ONE,
>  	}
>  };
>  
> @@ -1281,6 +1292,59 @@ static void update_per_node_mf_stats(unsigned long pfn,
>  	++mf_stats->total;
>  }
>  
> +/*
> + * Determine whether to panic on an unrecoverable memory failure.
> + *
> + * Design rationale: This design opts for immediate panic on kernel memory
> + * failures, capturing clean crashes rather than random crashes on MF_IGNORED
> + * pages.
> + *
> + * This panics on three categories of failures (all requiring result ==
> + * MF_IGNORED, meaning the page was not recovered):
> + *
> + * - MF_MSG_KERNEL: Reserved pages (identified via PageReserved) that belong
> + *   to the kernel and cannot be recovered.
> + *
> + * - MF_MSG_KERNEL_HIGH_ORDER: Pages that get_hwpoison_page() observed as free
> + *   (refcount 0) but are not in the buddy allocator. These are kernel pages
> + *   in a transient state between allocation and freeing. A TOCTOU race
> + *   (page allocated between get_hwpoison_page() and is_free_buddy_page())
> + *   is possible when CONFIG_DEBUG_VM is disabled, since check_new_pages()
> + *   is gated by is_check_pages_enabled() and becomes a no-op. However,
> + *   panicking is still correct in this case: the physical memory has a
> + *   hardware error, so an allocated hwpoisoned page is unrecoverable.
> + *
> + * - MF_MSG_UNKNOWN: Pages that reached identify_page_state() but did not
> + *   match any known recoverable state in error_states[]. This is the
> + *   catch-all for pages whose flags do not indicate a recoverable user or
> + *   cache page (no LRU, no swapcache, no mlock, etc). A theoretical false
> + *   positive exists if concurrent LRU isolation clears PG_lru between
> + *   folio_lock() and saving page_flags, but this window is very narrow and
> + *   mitigated by identify_page_state()'s two-pass design which rechecks
> + *   using saved page_flags.
> + *
> + * Pages intentionally NOT included:
> + * - MF_MSG_GET_HWPOISON: get_hwpoison_page() failure on non-reserved pages.
> + *   This includes dynamically allocated kernel memory (SLAB/SLUB, vmalloc,
> + *   kernel stacks, page tables) which are not PageReserved and fail
> + *   get_hwpoison_page() with -EBUSY/-EIO. These share the return path with
> + *   transient refcount races, so panicking here would risk false positives.
> + *
> + * Note: Some transient races in the buddy allocator path are mitigated by
> + * memory_failure()'s retry mechanism. When take_page_off_buddy() fails,
> + * the code clears PageHWPoison and retries the entire memory_failure()
> + * flow, allowing pages to be properly reclassified with updated flags.
> + */
> +static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
> +				      enum mf_result result)
> +{
> +	return sysctl_panic_on_unrecoverable_mf &&
> +	       result == MF_IGNORED &&
> +	       (type == MF_MSG_KERNEL ||
> +		type == MF_MSG_KERNEL_HIGH_ORDER ||
> +		type == MF_MSG_UNKNOWN);
> +}
> +
>  /*
>   * "Dirty/Clean" indication is not 100% accurate due to the possibility of
>   * setting PG_dirty outside page lock. See also comment above set_page_dirty().
> @@ -1298,6 +1362,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>  	pr_err("%#lx: recovery action for %s: %s\n",
>  		pfn, action_page_types[type], action_name[result]);
>  
> +	if (panic_on_unrecoverable_mf(type, result))
> +		panic("Memory failure: %#lx: unrecoverable page", pfn);
> +
>  	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
>  }
>  
> @@ -2428,6 +2495,20 @@ int memory_failure(unsigned long pfn, int flags)
>  			}
>  			res = action_result(pfn, MF_MSG_BUDDY, res);
>  		} else {
> +			/*
> +			 * The page has refcount 0 but is not in the buddy
> +			 * allocator — it is a non-compound high-order kernel
> +			 * page (e.g., a tail page of a high-order allocation).
> +			 *
> +			 * A TOCTOU race where the page transitions from
> +			 * free-buddy to allocated between get_hwpoison_page()
> +			 * and is_free_buddy_page() is possible when
> +			 * CONFIG_DEBUG_VM is disabled (check_new_pages() is
> +			 * gated by is_check_pages_enabled() and becomes a
> +			 * no-op). Panicking is still correct: the physical
> +			 * memory has a hardware error regardless of who
> +			 * allocated the page.
> +			 */
>  			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
>  		}
>  		goto unlock_mutex;
> 


