Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86B1606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z9jcdZOG
Received: by kanga.kvack.org (Postfix)
	id 0E2A96B05BE; Mon, 23 Nov 2026 11:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA9F6B05C5; Mon, 23 Nov 2026 11:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12FF6B05CC; Mon, 23 Nov 2026 11:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA2486B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:34:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 570ED120914
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:34:05 +0000 (UTC)
X-FDA: 85466930850.02.65F32A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79D26A000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:34:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9jcdZOG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451643;
	b=3mwxOmE2wZ1v1xaLUPl9D5am9W/vYhdeyFh9oKgj8AVIMXoF17bk9GK3QtqVZL6pCrrziX
	8+nT5RgITHrpjHDxUdSZ/J51KdrxCnwHAJ1NMCThoG+XvIzkAlNJiCpo+Qd6/GZtlpGSb5
	uDOUteawXPF3lfrUjcgppZwinwSw25U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XcUIc/Z2IDBd5zkYKP4F1aNbn+BFCP/Skc2wY3aN9mA=;
	b=4MYk3XgyRxtTBrZ0RlZsmBJs1fnu+YNm14btZyFHBWgl3JEoJof/xlrwrliOEmSwMSH3IX
	vOt2SYuYLtI7TE0jTrV0rz8fOhYtfAx5R6l/Y2sq0TDqrNcr+Ii0u7PxXMR9p7nhMKNrTg
	rVGZ1UgLQHgCQp/JaF28vJ60DmP6uFM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9jcdZOG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D0C161B20;
	Mon, 23 Nov 2026 16:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA571F000D2;
	Mon, 23 Nov 2026 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451641;
	bh=XcUIc/Z2IDBd5zkYKP4F1aNbn+BFCP/Skc2wY3aN9mA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z9jcdZOG0X8oS8S0q2V8LXzfYrqMDbKLNthqaEGxvKHxIrfzxpGvTBNeQEQwCIzMs
	 /FQmmKmv4se+QU3ueoSiOfyhjHxy0MMoxKHnkb9k43NlDzhuf5DPX8ZmjHUOWf26X0
	 4CiKU3rWbh0cnbnDJ7qCVKiRvIKfzjiZIZQEgNZsaTsR9kRzjLlr8x2WtPOGkXfDTz
	 3snWz4a1JN86WzuaVTadKwBSaQTT/T1hSuU1Us0bLRRzhPIIgxJNuEt4fjVQ2REUo+
	 /qG+mQjt4snrBOofs92ogQzCJto95dW7IGIDIuBJNlA9r7nqgGNedlm77e5AlRaQPB
	 IoSqNQa4REaxg==
Message-ID: <27c7a176-cd38-4e2c-b2e6-ad63b79ffc07@kernel.org>
Date: Mon, 23 Nov 2026 17:33:51 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261122-b4-ksm_fixv2-v3-1-f78ea7779746@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261122-b4-ksm_fixv2-v3-1-f78ea7779746@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79D26A000A
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: s5rx1ttnyt669yhwru96n7yo179zrs58
X-HE-Tag: 1795451643-571373
X-HE-Meta: U2FsdGVkX1/UqW8V2Brfz6EKIFNCcyMvc/sEw0AOxQ2nFdw+zT28X/x7Xj1FJw6BLTeo+m02JoRbxwLriP4IRVhs4MfqBIpXqyZCF+0eJsmVnSY1YH1KC80hlP2BWnKwGBcfxDFd5QAoXEym0fH1qKQog22OGn/B300q2dnSO4rvifj5Dua0IyTTym67/popGi5fy6fnD1pP0ohp3z4dKArw3QZuY0IQZ31MQDtC8Xna6dTBrxjEgJMuPuC8wEuOp9Yw6vVTdfSI7L2HGdondOfXzOXERCa2UdZd0GX9shuimcnaYCZFARrNCdlj8T0D04VFqsbXXB77u4tkuOAMdQcQqHEDrZXubKiC/k2Qfo2xs9eAriJP+LuGszRhK82D+kma24kzl44X5GuY4mHTlt2cbET2prRh3g6c4yrNeWPqqAuQMyQ1BSFrlW0eAPbzBIoLJ+DKF/FrMaaFQonoBhgPA5E1fPNB84Gv2H01XPUPqHdeDX75/0OiP1lxFnaZ5mQIrJcDwQsw1OSV9Sxa3oT+JPvO8LjYGDdKPQ0kJlmFHfbVkeA2vcQWRdv31zSuZpx8IGbYv4nHg9NLV9/1VAWI/Wi3jFV0sxJQxBKvDAcDUE2T+t60e6hoxZY/HtkvxoTPSfSXK5Y+rFHsNWhu8qnnb+V559RHKkld6eB04AiVi6aa2R4GWE4GWtpLhCQHrA20rGKCfDZetTQ6fN0lSqzMm5RYUd+Mtz7hWkAR1R2Qt7qk/4MhqoPYEHoIRjbFkFuAJc1fZPRcBrDdJFRwV+g1OynkZnliREdOWgaGSZpXGepjmgUfVS5/lq+7X3JL7kbkby4fFRyNGz/d8Y8MION0PJzb220J5TVysSdMN03NRVIsoGH63F4IcWqzI0oInFCg8l+5/qBAdq2iFUU2kAxsXyiYgtxInkdSWyOLHBGTYyIKanCZ/CZgUOrH/VewIzniLWifI5gEPZdYvuR
 4xAIf+01
 Aq+p+lgfIwKuRk4RNK/s2w3bUMpEbo3BwMmz+mwlhrxi1DGd7bkEhbqFvkbbjGtG2v/ul7hrnyEHYF+vgK7BeaEwentauHn2VDWcmelWD99pm3IlTO+PXN625fVl22fpQubhQv8Kz8LSp3+3nL8Ek/U6gY/NZkjYxJAw4GK4f3bPNWGZ2F945Sur1U7836sNWT3CyXmZ8RaYGSm545zOGy/6cJnnq690aLQA7pol4lxgPcIn+iK5JE58HiWNc7l/w8oKKurBm8Fu44tFzX5sD5gtXDGSp/1Elf7F12kq8JUfRO6XOpzVnqRM2Vs6MrLcvyeJhkRw5UvIKz0QTuZInRwgppEoSrF6qExoY8iq98TrAYWQ6qB05gnTnT8zHlhqdI/56JibkimP2mDzpAQb/iYnLre87hpEQKrPBMSx9Fs8mBvZ5oc746UrApIQ4mZ0qWK7iM/lMaSRl+aA7RqIxkBWF0DrNhdidKI8oQOujorwb0aDE2dWafW087AT0mKpuRtQNL8xyznhTDEHbkzP0vKFWXaHpnXdBmXEGVsMGH7kdUHMHx+PKat68TPYyj6n0EXJGWb50BwHae4YjTSAKmdU6PJREpI2xe+u9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 23:20, Nico Pache (Red Hat) wrote:
> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> when splitting isolated thp"), splitting an anonymous THP remaps all
> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> This flag is set unconditionally for every anonymous folio split,
> including splits triggered by KSM.
> 
> When KSM is enabled with THP=always, this causes two regressions:
> 
> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>    split_huge_page(). The split remaps all 512 zero-filled subpages to
>    the shared zeropage at once, freeing the entire 2MB THP when KSM only
>    intended to process a single 4KB page. This bypasses KSM's
>    pages_to_scan rate limiting, causing ~1GB to be freed almost
>    instantly.
> 
> 2. use_zero_pages=0: The same split side-effect occurs through the
>    stable/unstable tree merge paths. Each pages_to_scan iteration
>    triggers an expensive split_huge_page() that silently frees 2MB,
>    while the scanner wastes cycles on tree searches for zero-filled
>    pages that were already freed as a side-effect.
> 
> Introduce current_is_ksmd(), to check if the current task is the KSM
> thread. Use it in try_to_map_unused_to_zeropage() to skip zero-page
> remapping when the split is triggered by ksmd. Allow remapping during
> reclaim running in ksmd's context.
> 
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
> This patch fixes a bug in KSM where the pages_to_scan limit is
> bypassed and the policy (use_zero_pages) is ignored.
> 
> Commit b1f202060afe ("mm: remap unused subpages to shared zeropage when
> splitting isolated thp") added zero-page remapping when an anonymous
> folio is split, including splits triggered by KSM.
> 
> Skip zero-page remapping when ksmd triggers the split, while allowing
> remapping during reclaim running in ksmd's context.
> 
> Changes in v3:
> - Drop the patch gating zero-page remapping on shrink_underused.
> - Allow zero-page remapping during reclaim running in ksmd's context
> - Add a comment explaining the ksmd check (David Hildenbrand).
> 
> V2: https://lore.kernel.org/all/20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev
> V1: https://lore.kernel.org/all/20260609114619.144416-1-npache@redhat.com/
> RFC: https://lore.kernel.org/all/20260508170509.640851-1-npache@redhat.com/
> ---

[...]


> +
>  static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
>  		struct page *page, struct vm_area_struct *vma, unsigned long addr)
>  {
> diff --git a/mm/ksm.c b/mm/ksm.c
> index d24b129932bf..60656b05419a 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2873,6 +2873,11 @@ static int ksm_scan_thread(void *nothing)
>  	return 0;
>  }
>  
> +bool current_is_ksmd(void)
> +{
> +	return kthread_func(current) == ksm_scan_thread;
> +}

I do wonder if we wan to make this an inline function to not require a function
call just to check this.

Thoughts?

> +
>  static bool __ksm_should_add_vma(const struct file *file, vma_flags_t vma_flags)
>  {
>  	if (vma_flags_test(&vma_flags, VMA_MERGEABLE_BIT))
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 65869b8acec5..b0949f43ed5c 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -305,6 +305,14 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>  	if (PageCompound(page) || PageHWPoison(page))
>  		return false;
>  
> +	/*
> +	 * When a split is triggered by KSM, let KSM take care of scanning for
> +	 * and deduplicating the shared zeropage. Reclaim in the ksmd context
> +	 * should still be able to reclaim zero-filled pages.
> +	 */
> +	if (current_is_ksmd() && !current->reclaim_state)
> +		return false;

Probably helpful to throw in an unlikely() and to to reverse the checks
(checking the latter is cheaper than the former).

In general LGTM.

-- 
Cheers,

David

