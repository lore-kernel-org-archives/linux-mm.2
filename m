Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EABC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A913D6B008A; Thu,  9 Jul 2026 23:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A696E6B0093; Thu,  9 Jul 2026 23:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9813B6B0095; Thu,  9 Jul 2026 23:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67FD36B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:52:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E40738D5D4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:52:43 +0000 (UTC)
X-FDA: 84971495406.19.E36E7FC
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf05.hostedemail.com (Postfix) with ESMTP id 01195100006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:52:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tddhjLFi;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tddhjLFi;
	spf=pass (imf05.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783655562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4u6DLQWLrUTU+mHJc70g4XfhHLkKKKIN1zZTYL9fAs=;
	b=PsWAnSXdGifoxvs0n7MbsApcW4+Fon+aIlawAd+uRsi9NeQS/AaQN8QHDO1ajCI9DJsoHX
	7FGvMKWyTX5BMIoAQmx8LTSHdqKcRGagDkns1jyrRg/INt2PH30NZMUlTocgC6g9cQF26X
	SXcCSlnktP0vIEVD9F2lMGKhWevnusA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tddhjLFi;
	dkim=pass header.d=huawei.com header.s=dkim header.b=tddhjLFi;
	spf=pass (imf05.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783655562;
	b=iLaqbca7UgnXtzFYWW6n7EnmIv+OHZJExtz/9/DNTd8cwCaA6Hytyj3rtaVfiiyRMaXCBr
	OvQmLNWKPrcqzDBcn984Ll97H3T525J/TgD8U91FK7A6K5Wzv4sElM12AAA69IPzS4mZNt
	PwMq5Wwm/lvZeUmdszdTdca25CbhOIw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N4u6DLQWLrUTU+mHJc70g4XfhHLkKKKIN1zZTYL9fAs=;
	b=tddhjLFi0tBot70VP4PxC2av0u+r5s0HN/N2sEAtpcjOUfS88uS+2iWd2A2LBG5kI3r6W4iym
	3ot3EtEV5BmR6zN6673PrBtw/W5t/L4HOdJ16gNbc2+qpAOfyNMSdZAwsE3KjxHlwJn5qGIPudz
	KBYHC5Ki/fYjhfXZrgmF3ek=
Received: from canpmsgout08.his.huawei.com (unknown [172.19.92.156])
	by szxga04-in.huawei.com (SkyGuard) with ESMTPS id 4gxHvv16Vjz126M3j
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:52:11 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N4u6DLQWLrUTU+mHJc70g4XfhHLkKKKIN1zZTYL9fAs=;
	b=tddhjLFi0tBot70VP4PxC2av0u+r5s0HN/N2sEAtpcjOUfS88uS+2iWd2A2LBG5kI3r6W4iym
	3ot3EtEV5BmR6zN6673PrBtw/W5t/L4HOdJ16gNbc2+qpAOfyNMSdZAwsE3KjxHlwJn5qGIPudz
	KBYHC5Ki/fYjhfXZrgmF3ek=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gxHjQ12cZzmV7Y;
	Fri, 10 Jul 2026 11:43:06 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C3B240565;
	Fri, 10 Jul 2026 11:52:21 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jul
 2026 11:52:20 +0800
Message-ID: <67066146-e371-46cd-bcbe-9c28ba8e890b@huawei.com>
Date: Fri, 10 Jul 2026 11:52:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fs: stable_page_flags(): use folio_test_*() helpers
To: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260702110614.2176986-1-tujinjiang@huawei.com>
 <20260702110614.2176986-3-tujinjiang@huawei.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260702110614.2176986-3-tujinjiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: ez8nw19z7a3gbbxdfe33a59d4rdukypp
X-Rspamd-Queue-Id: 01195100006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783655560-885433
X-HE-Meta: U2FsdGVkX183ijhIxl8TXQt//eP2REWw4pHktTvcUndkTor53LopccLM/vwb5HvYdVbg7KFwHr/k5ae4GHcbZ52rt0aHkjHFntkhsEaoWmnskDe7mgFaDWvPzb8Uz6y7Ikphxwapa9t3YJ2yd7gxq3HuRHXH/UGbSLBnWVw66sKL+WC5mYGFZQvPA9JGQ8mQovN+cHWWLd9DMJTNGEb2+94xmVXPRODksKSpsLqCyzGxzbd79Hal37FbZBw0PHbpNJHFjXaFcaB29y4wwrfvbqKCHHbIaB8YU9FVOwDZsCh1KSzUAAcmdQq/+A57NOGx7NqoqmaW4ET7tiVtkQ1dfKbmU//FRKT3JKVZFOmNntEDvIfnoX5q8dDCZNYXu+fGjzxOQCrCKy6qchM+ZmS+sW2uX5kQoipswW3j/Upkf8A+EAwHEoJXl47pUxl45SKNj2F/EqKAmdrzU0KOpNYnxzktQ4ZBNnfRv/QprWVkwj7jpVdjPyY0m2UlFuxCFN0bUQ9Dh/7UkI6mZ3dWcMGKRYj4nGGbQDtTi3IJq+E2D0QcSdrdxAC6Rt0i7ul3xdsyIhWHKE2Ivlm+dcyz2xSQNOId1cHrzxc1Jn5rtPXnX6hWnOPgp9zwN9C44NQ8nOwBnZ+8+o928ynKpZO3HivGMPCv0Z7aNj8HpOzOiOSxxBR/GuTe8+AAv/xIYwBVlZxSoqfBjxmoHP9YBFo1DE+Yzuoz7jlYYHuuFz0Jm3f50v+82zCSL43tLFtHCYtM1EgmfdzNzWh7HsL3d6ZLZMcMAO54yBOmQg4oUJ6dfBRERsR+gMHKEkMbvUWMkU+LJb4rzXrjLn/T6g3F84KRXpMnFKi0aBxqOl1s4uRtTAUTXUZPd5IN3OkUxr2mMdoPGXhxh7C8sdbiciQwVvfUYb3r7gmrl2op1wPHmh9YD7NCRfCrXUeyQWPOMvg20xk1q2I2B9Lf7xArfyDgRz3i69j
 A7iMx832
 x2VhtacKUFW4bC9OCtYw3Mb6/hWqiUnpmok4JX7rj8CljGJI8Kl8yaOmajJYNa0KfhEu2TDJ0+fhyslFFEu3LSdqX77hXsYQYl5c0UXm5jDQ+z/h/sTwO7nTM+17yr6ycGD3U5PwekoS7m4+s0T6Kn37ITeYoYjO/0mwx7L13mb63GzemVBcPJpo4oTQXTuv2frmQ+0l2+dhqvzMooaTVArPvKo9kVFqH/3qM5A62T4zE+XHw+xtDtN7e80gQDUtqxdNLTvzhp0ofOmjSy9WMYGKiWbUM7DcflqasJ7haQSGfJXxnbJwZQvuBdyPWKVWobTwgTck6R3qcxbvGTR8DJrgJLITqgeNRFNtlRDnC4GCsDeLJcB6KiRtGjxhSgoTlY4ad3MrSJ7BQtJBL3/46nwAVG24vqwk7v3QjoHbmFSgpY4MHbW4SlF8wYf5SSaDn+7AQct0HKeN04diIx+BAgeArnR2ROT9z9Jo2wdlsvw9xyuZhCSnMULh8bSf4OANJo5K/aZ5dxEj++6xVnnftzpfjnm1nx2lPZ07d1qY5OX+biUd4w42dQLFjxjnU2M3TL1aI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/2 19:06, Jinjiang Tu 写道:
> stable_page_flags() currently accesses folio->flags.f directly. Since
> commit 476d87d6a061 ("fs: stable_page_flags(): use snapshot_page()"), we
> can replace these raw flag accesses with the existing folio_test_*()
> helpers, thereby cleaning up the open‑coded flag handling.
>
> For KPF_IDLE, set_ps_flags() already handles both 64‑bit and 32‑bit
> cases, so the duplicate code in stable_page_flags() that deals with
> CONFIG_PAGE_IDLE_FLAG for the 64‑bit case is removed.
>
> The flag bits that has no folio_test_*() helpers are left unchanged,
> including PG_owner_priv_1, PG_arch_*.
>
> No functional change is intended.

I update commit message to explain the history and motivation. The updated
commit message is as follows:

Since commit 304daa8132a9 ("maps4: add /proc/kpageflags interface"),
/proc/kpageflags directly operates on page->flags to determine page status.
Later, commit 177975495914 ("proc: export more page flags in
/proc/kpageflags") started using page helper functions when exposing new
flags, leading to a mix of both approaches.
                                                                                                                                                                                                                                       
For tail pages, the original code did not return corresponding status.
commit 0a71649cb724 ("/proc/kpageflags: return KPF_SLAB for slab tail
pages") and commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for
"tail" buddy pages") made tail slab/buddy pages also return corresponding
status. Then commit dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
made all tail pages return the same status as their head page, except for
hwpoison and mapped flags. It also cached the folio's flags and operate on
the flags directly to avoid concurrency issues if using folio_test_*()
helpers. At this point, folio helpers and direct flag operations are mixed
together in stable_page_flags().
                                                                                                                                                                                                                                       
Since commit 476d87d6a061 ("fs: stable_page_flags(): use snapshot_page()"),
the folio has already been snapshotted, we can now safely switch to
folio_test_*() helpers instead of directly operating on flags, which is
more readable and consistent with the rest of the kernel.
                                                                                                                                                                                                                                       
For KPF_IDLE, set_ps_flags() already handles both 64-bit and 32-bit cases,
so the duplicate code in stable_page_flags() that deals with
CONFIG_PAGE_IDLE_FLAG for the 64-bit case is removed.
                                                                                                                                                                                                                                       
The flag bits that have no folio_test_*() helpers are left unchanged,
including PG_owner_priv_1, PG_arch_*.
                                                                                                                                                                                                                                       
No functional change is intended.

> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>   fs/proc/page.c | 94 ++++++++++++++++++++++++++------------------------
>   1 file changed, 49 insertions(+), 45 deletions(-)
>
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 2717dbb0431b..0dbd46fa84ea 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -148,8 +148,6 @@ u64 stable_page_flags(const struct page *page)
>   	const struct folio *folio;
>   	struct page_snapshot ps;
>   	unsigned long k;
> -	unsigned long mapping;
> -	bool is_anon;
>   	u64 u = 0;
>   
>   	/*
> @@ -163,17 +161,14 @@ u64 stable_page_flags(const struct page *page)
>   	folio = &ps.folio_snapshot;
>   
>   	k = folio->flags.f;
> -	mapping = (unsigned long)folio->mapping;
> -	is_anon = mapping & FOLIO_MAPPING_ANON;
> -
>   	/*
>   	 * pseudo flags for the well known (anonymous) memory mapped pages
>   	 */
>   	if (folio_mapped(folio))
>   		u |= BIT_ULL(KPF_MMAP);
> -	if (is_anon) {
> +	if (folio_test_anon(folio)) {
>   		u |= BIT_ULL(KPF_ANON);
> -		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
> +		if (folio_test_ksm(folio))
>   			u |= BIT_ULL(KPF_KSM);
>   	}
>   
> @@ -181,10 +176,12 @@ u64 stable_page_flags(const struct page *page)
>   	 * compound pages: export both head/tail info
>   	 * they together define a compound page's start/end pos and order
>   	 */
> -	if (ps.idx == 0)
> -		u |= kpf_copy_bit(k, KPF_COMPOUND_HEAD, PG_head);
> -	else
> +	if (ps.idx == 0) {
> +		if (folio_test_head(folio))
> +			u |= BIT_ULL(KPF_COMPOUND_HEAD);
> +	} else {
>   		u |= BIT_ULL(KPF_COMPOUND_TAIL);
> +	}
>   	if (folio_test_hugetlb(folio))
>   		u |= BIT_ULL(KPF_HUGE);
>   	else if (folio_test_large(folio) &&
> @@ -201,6 +198,9 @@ u64 stable_page_flags(const struct page *page)
>   	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
>   		u |= BIT_ULL(KPF_BUDDY);
>   
> +	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
> +		u |= BIT_ULL(KPF_IDLE);
> +
>   	if (folio_test_offline(folio))
>   		u |= BIT_ULL(KPF_OFFLINE);
>   	if (folio_test_pgtable(folio))
> @@ -208,42 +208,46 @@ u64 stable_page_flags(const struct page *page)
>   	if (folio_test_slab(folio))
>   		u |= BIT_ULL(KPF_SLAB);
>   
> -#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
> -	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
> -#else
> -	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
> -		u |= BIT_ULL(KPF_IDLE);
> -#endif
> -
> -	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
> -	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
> -	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
> -	u |= kpf_copy_bit(k, KPF_WRITEBACK,	PG_writeback);
> -
> -	u |= kpf_copy_bit(k, KPF_LRU,		PG_lru);
> -	u |= kpf_copy_bit(k, KPF_REFERENCED,	PG_referenced);
> -	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
> -	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
> -
> -#define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
> -	if ((k & SWAPCACHE) == SWAPCACHE)
> -		u |= 1 << KPF_SWAPCACHE;
> -	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
> -
> -	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
> -	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
> -
> -#ifdef CONFIG_MEMORY_FAILURE
> -	if (u & (1 << KPF_HUGE))
> -		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
> -	else
> -		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
> -#endif
> +	if (folio_test_locked(folio))
> +		u |= BIT_ULL(KPF_LOCKED);
> +	if (folio_test_dirty(folio))
> +		u |= BIT_ULL(KPF_DIRTY);
> +	if (folio_test_uptodate(folio))
> +		u |= BIT_ULL(KPF_UPTODATE);
> +	if (folio_test_writeback(folio))
> +		u |= BIT_ULL(KPF_WRITEBACK);
> +
> +	if (folio_test_lru(folio))
> +		u |= BIT_ULL(KPF_LRU);
> +	if (folio_test_referenced(folio))
> +		u |= BIT_ULL(KPF_REFERENCED);
> +	if (folio_test_active(folio))
> +		u |= BIT_ULL(KPF_ACTIVE);
> +	if (folio_test_reclaim(folio))
> +		u |= BIT_ULL(KPF_RECLAIM);
> +
> +	if (folio_test_swapcache(folio))
> +		u |= BIT_ULL(KPF_SWAPCACHE);
> +	if (folio_test_swapbacked(folio))
> +		u |= BIT_ULL(KPF_SWAPBACKED);
> +	if (folio_test_unevictable(folio))
> +		u |= BIT_ULL(KPF_UNEVICTABLE);
> +	if (folio_test_mlocked(folio))
> +		u |= BIT_ULL(KPF_MLOCKED);
> +
> +	if ((folio_test_hugetlb(folio) && folio_test_hwpoison(folio))
> +		|| PageHWPoison(&ps.page_snapshot))
> +		u |= BIT_ULL(KPF_HWPOISON);
> +
> +	if (folio_test_reserved(folio))
> +		u |= BIT_ULL(KPF_RESERVED);
> +	if (folio_test_owner_2(folio))
> +		u |= BIT_ULL(KPF_OWNER_2);
> +	if (folio_test_private(folio))
> +		u |= BIT_ULL(KPF_PRIVATE);
> +	if (folio_test_private_2(folio))
> +		u |= BIT_ULL(KPF_PRIVATE_2);
>   
> -	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
> -	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
> -	u |= kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
> -	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
>   	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
>   	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
>   #ifdef CONFIG_ARCH_USES_PG_ARCH_2

