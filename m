Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72791FF886D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F446B008C; Mon, 27 Apr 2026 16:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C401C6B0092; Mon, 27 Apr 2026 16:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08586B0093; Mon, 27 Apr 2026 16:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5086B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:07:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 344711602CF
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:07:53 +0000 (UTC)
X-FDA: 84705421626.07.F362682
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2932740011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:07:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ljLG6oPR;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777320471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SooxcKCCc0I+ZGHbjetshcBR0BrBTdVdx8U+6jvCs2I=;
	b=TFHTFYdvV6cD72CXmiMIiOeganrUp87eWauglnyGyj175OiR92Qjg7fiM5/m4VyHJYXaiU
	lngSTIaTADpbX/kQ6l8lLeFYVbcSBY7qJFCgWQNBoIgdR/GHZCC60UUpmqnJg423tmu9yK
	SKnXY/hCpYj6jE2sFr7yx7bbQpCSvjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777320471; a=rsa-sha256;
	cv=none;
	b=HLoPHX+Xp3cVL6UBvjOL0VJWlfmJ7ue0fXRHRdz/t+G8RfQKr0tDEEboP1jOxUg72ypgX4
	XYMN80y8GX+UfeBh8nTNLQ3cPW4K2iQGND23kZklVnJGzI4SZoSOiiuruKlRBOotqSrgaQ
	7pxPUi+K5PE6DggoWMuscIJa/4KLRCE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ljLG6oPR;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8DFA40C11;
	Mon, 27 Apr 2026 20:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B801C19425;
	Mon, 27 Apr 2026 20:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777320469;
	bh=3QIV0MJbKDOFI+5S69Yek5xkk5s7Hl4gG821v64OYf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ljLG6oPRLq0PdXDhyYGX4mnzgq/vfkbTe8ja5YEaTR1YGQdu7HWrq3GdboV3MkoFy
	 TVWGPln+urzsJ8nQTcLHZH2c2Yry3UNHM5gzvTM9va55kqMubChxRKYPJgF56Ffjay
	 4KAOm/qNQ0coq7JBJyuzOkaVE2N35QK9WN61o2FgxOup1fGVIwYGX46ysZVQ97Z8qd
	 Wepw5r8J+CFZgE5dLZI+9rRuR+G0G71F9unVdwvf3Jpp02u23YidrEqbnKuvLfK+fO
	 5W94nYWb3bdXESII+T0qLbKY5eS2M3ywfjXlkcnqt8h448MaD1dJlO3lGIdQgQbm3P
	 5CXMouNZEi06A==
Message-ID: <e9dbe863-d125-4fe5-8ecc-91ad7293e5cf@kernel.org>
Date: Mon, 27 Apr 2026 22:07:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v16 04/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
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
 Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260419185750.260784-1-npache@redhat.com>
 <20260419185750.260784-5-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260419185750.260784-5-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2932740011
X-Rspam-User: 
X-Stat-Signature: 6z4m7sknzjtfkh4hs7tdazsocqqwa4b9
X-HE-Tag: 1777320470-876775
X-HE-Meta: U2FsdGVkX1/tafT+boI7K+kJtjr7ILSJKyNfl0SZfbh9B8FqXfEhOQmuHuWZlVDjXhxuUFgeTrBOLtruh0DVTnxOw4oAN+Gb3UBcWDkp/dkESecK2Vvp7pbiN12eu3otSdvkWCXP6DqrnK20LQkda7TAqOzIw9ZOTTkMUdWP9X17CSDOA7qZy27DQAxBjzNOQJU1b7G9LxWlsHySRO6is2ebjBlEW2oGOsqeVDQvv6GfQ1KlvWBlbsGm3CRshQNMf4DCgnKrE72QeRKt6x91E1jZQcKWCblmFL/mZjCbAl4g3l0pGQG9BkDe7jX/cYFyPzHZNnbNVnFN02Fv07mOyjJAfdK4HfWuuJebKSXLd8D26g+2zZ8xE5QM/96F/uNv/KULYULIuoSj9/j6AL5oBJwe0HgAUpsd1N3adzptVWWkYYqYvrSFMEs1tsLxeurMQoF8m9vxyaNvAhUo4VUPO4E+AN/51QjwsVtD+V3Kv/FK/WoYoVfa/w4segegq838kazsDJFTiU/vPgxSCpJZ5wxsSTbfyINhyZPqJQhK8axKi3yZRe6PWaUhawog63tvrMCrbDfTj+b19J7fT41U9IRvpPMUwgMhn1zFQjWq254ysSOA3IVGHpzbvva5bTkmh+RfyrwmGWpUKLmjaMo2Kuxnzijaew4b/1U4PyVSqy7BMdsAnuEE5J3W0va0dk9BNcMHevJsdPdVm8DzS+MeS42BKnmO/s/Wa7ognZ4Peio9trMAmuP6LnlK1IE3Z5+/FRcJ7NToovlDLBKDnmQKUPmnMjpkJa/K39kciY1wnMsPlXpWcIGO5eVB6oV7ges8iHfjlDKZGnm0JSpwnQnr2j/a5NnGzeUovjiCLFvOTH/XhzUrugk5MsNZAQ3Uy2jbHX/t++6cLuj9qh3WQOYAXpiv2ga7SNopIxmEQbVvdqQs3enxM+7eNHPyOzq8PhPRp+b8YhtzJjmjuLy6lJB
 cCgwKR9W
 rg3tJ0/gqRqAQSsHBx3wMkyM5grMJ5uah9z9Ef0Sa+eZL+sDhmPsFUccXBtY5Sa86O9B0kDqTQK4SwWKCVzr0HlLJrwltbBeoLQWd5DpUl5qfXXPJRUB8KnhrD9BiUEh2SiJy8yv50ZoZ9qir9M5rG5KCBo1yvtkQrxxcfF3MJJzreUqPkGwwyr1pX6x26+W69YXXCfRnhrBy5GVkOEA+HiI3vXs2XZ1OT38I/vCT5KquHxTvWJLFA/y9AwfypscLmhff1uNe0tBRltR/lhE8WuUSek8Ntmwl0QMQkfXQVPxXxmNNIGcBZlYhM4OuyU1GGm8jP7EOmeib62wYhhIiZQXyQt3dDKwosRwVPrg1diJNppfHGMCCE3cdrRFWpMUwfiaNvNEv3yte+5X7HhC1H5HXkIaDX1UN6yxa0EI7qFxMxQ0z08+JF5AnY/UV6LhbT1+EnShkehEQIu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/19/26 20:57, Nico Pache wrote:
> generalize the order of the __collapse_huge_page_* and collapse_max_*
> functions to support future mTHP collapse.
> 
> The current mechanism for determining collapse with the
> khugepaged_max_ptes_none value is not designed with mTHP in mind. This
> raises a key design issue: if we support user defined max_pte_none values
> (even those scaled by order), a collapse of a lower order can introduces
> an feedback loop, or "creep", when max_ptes_none is set to a value greater
> than HPAGE_PMD_NR / 2.
> 
> With this configuration, a successful collapse to order N will populate
> enough pages to satisfy the collapse condition on order N+1 on the next
> scan. This leads to unnecessary work and memory churn.

You could add a link here to previous discussions.

> 
> To fix this issue introduce a helper function that will limit mTHP
> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> This effectively supports two modes:
> 
> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.

"introduce" reads wrong in this context. And I don't know what a "none-page" is :)

"never collapses if it encounters an empty PTE or a PTE that maps the shared
zeropage. Consequently, no memory bloat."

> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>   available mTHP order.
> 
> This removes the possiblilty of "creep", while not modifying any uAPI
> expectations. A warning will be emitted if any non-supported
> max_ptes_none value is configured with mTHP enabled.
> 
> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> shared or swapped entry.
> 
> No functional changes in this patch; however it defines future behavior
> for mTHP collapse.
> 
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 124 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 88 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f42b55421191..283bb63854a5 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -352,51 +352,86 @@ static bool pte_none_or_zero(pte_t pte)
>   * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
>   * @cc: The collapse control struct
>   * @vma: The vma to check for userfaultfd
> + * @order: The folio order being collapsed to
>   *
>   * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
> - * empty page.
> + * empty page. For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the
> + * configured khugepaged_max_ptes_none value.
> + *
> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
> + * of 0 or (KHUGEPAGED_MAX_PTES_LIMIT). Any other value will emit a warning and
> + * no mTHP collapse will be attempted

Not sure if we discussed it (and maybe I had a different opinion back then ...),
but could we simply to fallback to max_ptes_none=0, so we can avoid returning
errors here?

max_ptes_none=0 is ok, because we will not waste any memory. The warning clearly
tells the user that this combination is not supported as is.

... and it would make this function a lot easier to handle. In the warning, we
can just state that "falling back to ... "max_ptes_non = 0".


[...]

>  
>  /**
>   * collapse_max_ptes_shared - Calculate maximum allowed shared PTEs for collapse
>   * @cc: The collapse control struct
> + * @order: The folio order being collapsed to
>   *
>   * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>   * shared page.
>   *
> + * For mTHP collapses, we currently dont support collapsing memory with
> + * shared memory.

"do not"

"shared memory" is misleading, as we do support shmem. What you mean is maybe
"collapsing with anonymous memory pages that are shared between processes
through CoW" or soemthing like that?

> + *
>   * Return: Maximum number of shared PTEs allowed for the collapse operation
>   */
> -static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
> +static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
> +		unsigned int order)
>  {
>  	if (!cc->is_khugepaged)
>  		return HPAGE_PMD_NR;
> +	if (!is_pmd_order(order))
> +		return 0;
> +
>  	return khugepaged_max_ptes_shared;
>  }
>  
>  /**
>   * collapse_max_ptes_swap - Calculate maximum allowed swap PTEs for collapse
>   * @cc: The collapse control struct
> + * @order: The folio order being collapsed to
>   *
>   * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>   * swap page.
>   *
> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> + * khugepaged_max_ptes_swap value.
> + *
> + * For mTHP collapses, we currently dont support collapsing memory with
> + * swapped out memory.

"do not". Given that this is also used for the pagecache, can we make this clearer?

> + *
>   * Return: Maximum number of swap PTEs allowed for the collapse operation
>   */
> -static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
> +static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
> +		unsigned int order)
-- 
Cheers,

David

