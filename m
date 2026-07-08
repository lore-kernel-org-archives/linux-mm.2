Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44355C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1826B00A6; Wed,  8 Jul 2026 04:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382146B00A7; Wed,  8 Jul 2026 04:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223486B00AA; Wed,  8 Jul 2026 04:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF6B26B00A6
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:43:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 764B4406DA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:43:38 +0000 (UTC)
X-FDA: 84964970916.09.1446A6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC7C680004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:43:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JooeV2Ah;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783500216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iylKqZxKYvA+a+i91mDQinLsIvH7MQriBJaD7bqvwKk=;
	b=ci13e7X1gmDzCsajBQEo4WW+4j70Hp2N5poMMNH8j1RTRgINLbDWVjgFO4UVyYTR0CkPit
	JTMaxfaH21+09hkVbD4STh4r5eCR54xaxe1Z/loVgZmXFHWJhluXMLnaCbakdGJM2AAMHW
	y8RhOIvrX+ZAztruIdvwqBJJKJZPQUQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JooeV2Ah;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783500216;
	b=0P7gcUmeMpiMSxH086uBr2vEzsAu9bA3W27y1yX2DqjBePgEIJCSHcqmWZfa1BrHq690We
	ZcBdelBc65GKf/Ued4nEgOybS0C+vH1a/yq+UR+qz4wxpFnXgX+/6mDFu1c9hBvRcVEhJD
	wbupTb1e4/+h/VFWBAxq6u3SFovQIPs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3570160008;
	Wed,  8 Jul 2026 08:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4B31F000E9;
	Wed,  8 Jul 2026 08:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783500215;
	bh=iylKqZxKYvA+a+i91mDQinLsIvH7MQriBJaD7bqvwKk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JooeV2AhyukQcKllXv3qlcIRIL/p8bVgh/uB0cuwFguDijyU3xwg6iKIygYOTss3a
	 XjQbTLK5F3zbOFSiUEZ4L/9KpJWI380qKf5HL3Le4VEwxBsvNDyk3UQzx043e8JnLW
	 WRrNmP6Y5sRm0d13vAt60HR3WHZODKU4pBzGmxrk9wvAzpOLmhA9hnwXUExJ38eIjK
	 vCjk0qnuH0xJXnQqsTcF5+uxWOaX2bRO63+GkV7xTE5DC67XOgr42T67fg8cEsQ8yw
	 PsATXEjzNxR51yYUsGzaK6nl8C4ntRTKH5NBFCjUbSU7EzGkU7gKDkdoBy9vEEenos
	 R4kaN5fSKKRrQ==
Message-ID: <b806c878-e1e6-4af9-8816-678955288d82@kernel.org>
Date: Wed, 8 Jul 2026 10:43:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707-fix-array-overflow-in-migrate_vma_collect_pmd-v1-1-ce3ff4627653@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC7C680004
X-Stat-Signature: zx4ge3gj9u7qxero5k9bhjkd9uua5ggd
X-HE-Tag: 1783500216-34767
X-HE-Meta: U2FsdGVkX18XVoA+WK73/Qh+9bUrtLemfH2A4WdiGy7VSL5oQkjeKQ+G8FYZjJFYGt05bMQXslOk5PnDBFSJdtp4HXQcb6TChPBviGtJzdD3u+FwCKjkF0hr6P1F9+h6a30jEgpl4pY/jJeGUPZANIJTkRaG+Xxm8pMvZQ9MvJ9kJn6nWAFV8owdw4qn8tCgjdDry499g12j0Is1cB5knwipwJ0sUMxBprySXWSUbB8Q0ToKIA+VpkcjS1Vc/VKSSk71wf5KqT5rl4XYsa4DBvsAW119Uh1mwps3cxNA0Py3CMWAgfl0C6NsCM3cUryUuIdsh3QV7/agwP0WSuQOGqC1u/cP2kyTUHM9xuj6I6Tx1fCNyWfHoWRQWoRUeDnXbgfnXRSau0n6Rn7uc0XS8kz3LWTZAInSwCgdhD5cMKgWX3RjHb+mVpZFobFG21P2BMlgBMnR3ykxoZCpNbfcuGgsBI4bC3iU/UPB41oa7mknzL2z7YyduXrBST0mDLTFkcPGE8Jqja96CfdBrwXM4JoIF2G3B9pz4VlmXxUAragp6f37QAycNHz7yaidvYEVHfegAoEoIvclc5h5rhuMl1JzD+B3aUdhPW5z5Q4vMfLS5wFXp6qmUe+ChMMbEGZ4ViY4ymG3d/4F7Kr6558vc6729O5rR44uZsNKjMPRQgt/yiK/CtSVexs/EIqZ1M03iOdAaw8UuGGTSkLz70FFNQNXpIvISTu8SqZwwNzNY1hDpJb/2A26PD71fDmx4FerlX0pMQtoo3EPhhDs9DbQHhxcnFQyaT4V6JHyfDzYO3GX/VFmI9ntvuZ4Tql94m7zZlCxxCB2Y4XtwT5PFs1syb5ijxMOuyr4GPCNOkJ2Jk6w7Vu9Gy4bsBxPQPKxqGR3yaAzGL2fZxp1SI5Y/5UuhuxlpYeUIb0mhPvQhGfGcCze+GkevAXHj0yqeVzrovPT3j+iPh0y9oVP0JrCb45
 Iq+A8Imq
 1nZybxF5VRJSa8HnFp/6ADGRZkOE7FU/Z5GCQfbxP0G+I1iWSEfFSp8phvWilhUQ3n716kR4zHwGboXpc7BOmRbzdrzMHjxqQUNBbHR2/WYnSetM9FIhu4S4Pj8cV+yqdrzQbzYlrLmaQ3ZVRVrtkzq/ky4W9TK54PUV23TTA6I49Qx/zdu5qE7sglVwfAH3o4YHdePO3uFbsS9cA5Spc5HF7GTsorJBNVEwjse0SrIEk78GyAyj+3o2qWc2bOeLiLocf4+RkKax0rQmd5v5rT6qSwi9a0/L5JYpTjtIbS5kEhjUgRb4TfYVUnizSaYR6R1EdUROl4BdWrk7JfRgpqUl+s98KG/EYMme3VvWWKBE5BiegnHEyPeKTFKX8+rlp8ymuSvL5ZL5apGYy7xPBbO7mr/iJfe35Tk4e9DJ2Crrky40R2Ak/96CVSPYyElQXaRrKLhJhDHhyQzW6n7DTgnWWlDXetCHRf41B1UFTDnvR6bkpGkpBappurfaaJ+CZgnsS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 03:50, Zi Yan wrote:
> migrate_vma_collect_pmd() can drop pte lock to split a large folio and
> restart. But the code does not handle restart properly when pmd becomes
> huge or cleared. It can overflow migrate->dst and migrate->src arrays
> during the hole or skip collection. Fix it by:
> 1. avoiding migrate_vma_collect_huge_pmd() if some collection is done,
> 2. skipping the rest of the range if pmd no longer points to a pte page
>    table.
> 
> Fixes: a30b48bf1b244 ("mm/migrate_device: implement THP migration of zone device pages")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.wang@huawei.com
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> The issue is spot by Sashiko during a patch[1] review as a pre-existing one.
> This patch has the minimal change. An alternative is to reset
> migrate->cpages and migrate->npages and restart the whole range from the
> beginning, but that also requires a restoration of no-longer-present PTEs.
> 
> Link: https://lore.kernel.org/all/20260706111958.3649651-1-wangkefeng.wang@huawei.com/ [1]
> ---
>  mm/migrate_device.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 2fffeb1f99694..6ceb47ec1da24 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -257,7 +257,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	pte_t *ptep;
>  
>  again:
> -	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> +	/*
> +	 * Only check pmd when addr is at start, namely no pte is collected.
> +	 * It avoids collecting the same address range [start, addr) twice
> +	 * and overflowing the collection arrays.
> +	 */
> +	if (addr == start && (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp))) {
>  		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
>  
>  		if (ret == -EAGAIN)
> @@ -267,8 +272,18 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	}
>  
>  	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
> -	if (!ptep)
> +	if (!ptep) {
> +		/*
> +		 * Skip the rest if pmd becomes huge or cleared. Flush if any
> +		 * pte is modified
> +		 */
> +		if (addr != start) {
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, end);
> +			return migrate_vma_collect_skip(addr, end, walk);
> +		}
>  		goto again;
> +	}
>  	lazy_mmu_mode_enable();
>  	ptep += (addr - start) / PAGE_SIZE;

It's hard to express which feelings reading migrate_vma_collect_pmd() gives me,
haha :)


In case we split ... couldn't we just undo what we already did, before doing the
"goto again" ?

-- 
Cheers,

David

