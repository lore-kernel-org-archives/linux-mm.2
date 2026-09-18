Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9603C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B691E6B0095; Fri, 18 Sep 2026 17:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B400B6B0096; Fri, 18 Sep 2026 17:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55CE6B0098; Fri, 18 Sep 2026 17:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC1B6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:11:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BB911A06EC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:11:14 +0000 (UTC)
X-FDA: 85228128468.08.BD42100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6EE3018000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:11:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwDa7aHE;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789765872;
	b=PPSdlTD3NxhLeE37mx6DRMRLF/hzEWVitTWFmZ85W8TK1FqXqWG2HZsmwd5pviJ5EhXYLe
	MhFHp7UItEh/9kQ02iuVFpQ91W7Cbfp25F0kW528IvQMZGjBulo6l2SpzucMPwYw4PVwX4
	y8QPUoWuVBC29SsRP1eZmRNR/GRXuDE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwDa7aHE;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789765872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hl6/Iu3OW2v6yotocgDMrPbkoxPNm6VwsCRwbY41jKU=;
	b=E6TntEZCnGVAoq0qsWGXZ6AOlqwxz1GvlbQ3DDLBXXu67bwTOZtBtkrMy45CF+ZJ9VW/ze
	fVahR7POmXHe9LkNGa6AbTUxvgyKFWOxYJfLzOTGm2WOkBAvditoxXoQRkSPTKVCsBQ6eY
	/366LXLaAIx7CjQlexWPS+Gq6X7UbHE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2A2441882;
	Fri, 18 Sep 2026 21:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C73F1F000FF;
	Fri, 18 Sep 2026 21:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765871;
	bh=hl6/Iu3OW2v6yotocgDMrPbkoxPNm6VwsCRwbY41jKU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NwDa7aHE1bUw2QIdwfDp2ZF6+1ffHivMaDWwlaPj1aCAq3DWhVgeBPt6N1Ka5izas
	 VH5sWlYxwxKaNWSXHwPF3bqnwuWCh3jtbPxhXbL7Dkd8p8Kf1NITtqFH6bUD53TwgL
	 iw4WT+wJuhphCWZ22O7MBXfqKUdSX/7tVd5ZnFOJjXpNIS0cNaonNLbqAJwRHLluwT
	 D+2GvMMZ3j+fzwKXQaoDf4dAj5fDcQO8pnxFhOlLHcypZaYvP8via5OqP0c/sjl58Z
	 bpl96dxSNPP2aut/+j+80+4QTKLn9era049sycDEUqzbNYs3TEcSfynwoXeTB3h3OY
	 9jJpmj5un4uYQ==
Message-ID: <35e42ccc-df8f-4703-b10d-f7c96b263e98@kernel.org>
Date: Fri, 18 Sep 2026 23:11:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 02/29] arm64: mm: add PMD swap-exclusive helpers
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-3-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EE3018000D
X-Rspam-User: 
X-Stat-Signature: h94xki58z6cxtzdzoq5ahdhrxpgm5ojo
X-HE-Tag: 1789765872-331736
X-HE-Meta: U2FsdGVkX195fb+vAWm/vnOfQjPcEAcDgohGl5kUzDaX/ke6aSiMElx2KnjGpk8YWj2yRNUqKEHV8tqwvTvayHp4sny6tYGnYvB/gKWsjjMeuaLMzMSAr2OxyuAaOsuaqv7WYzZipwPfi9j2s1W1XaYDVGX/rxzX0TS/kiSylRjFiApJERU6s9k855N7VwjVFkm3iHjraNsj/9izYYu993TwIr8pQhevq9S+SY303wKOtNNlyxsCsXNP92Yr4hP752cnqFxsf4c2PX8Wpw/fIsrJS82BL5I4RLtVznhdE5YR69yXSkz2SchdPd6IrD0qRCG1Gq6hC3OjSmTtbRY4Y/7AaGa5xP4yuBbhZWa9kE/RgblkskQv/KVXSCPS8vj5S/eAyrS0ezYlVWqa/oywTwIFgkDoZNQYQvhcwSnT2I/YJyGWgXvRz9cvKVZCG8SqzIu8ouf7ruPzUapRak7JChCBEMaUEoXX1+mcyPnH1An0OvLrTbezEiRoB+WEs3Gem4IoMwaYG2w6CNd0wAQJG936ZX+XUr6zp0MAqtGqfjLtG9pNrGKObS3curbvC5D7NLn7OyDuV08o/8TFdgXv6iFPQo/CHWj0rjDRM0rFbglDn/nLucXj80e59A1OK/qgVnzGBZwNRCJ+4OEmKt+N7pvBMhhZm0ALheHNONYYNpNgqwitsOYFCeMctvUHXt0VY3Au1WMP8aIryV230qrUJzrADbLiP6kL9Acujwd0OJGITAHVjPfOyd8pVbU6ZorWdshu1Uf8znUU8iZYvOdu4ytTj2hv2xteFwAdZsIU/vCKMs0XRwlmY2/cpG8EiWUomG90mU3Ah4cVRg3/403q/UicAbFHkf4K1GewKu/uc4RfKr1gJ2g/DhCV+oOJzrDN/tIeGFRuUhoaa9AfOGJoeMh+n9maZzqjB3W1nmGDbOdhGjTAhFMrQuGjG2jla7xySBuBCiwU22Y9VXLLdka
 dc1nFO5B
 Zqkf3OJ5XtOwnbdTUC+e38p19Q7saJOSq5cNXXuR/5Y7d7K3gSmKfovCQFf0AVfTCEDzKAQbhv1pvK1iwqzNYh/6v07K8B/CHlGmYqMJ3vCnXS6X7+VhaA+JQ3LeTgmuQW3wGTpFqSD/NYnjvCc1GrHQf/qyus5LcduSHnGhUsfMUP/5RrMpD37n9eBO1C6iWfGlrhonL3HQ1zG6+Om2dqHIbSftlD+4as/jz/kHmuQtA5itj50Y+dV7h5jaS2lfmyQpoNwBRqWmoysRHIJt3/vpOwtbLtLAm6ZTj3hZOFgGH3iYDwrokY73Df7DXNK43GB+Uff2ANQGS/1Kj4jHhRGdkQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:27, Usama Arif wrote:
> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
> not just in a swap PTE.
> 
> arm64 encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
> the PTE ones and reuse PTE_SWP_EXCLUSIVE.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  arch/arm64/include/asm/pgtable.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index e89ec5f4787b4..d3f53a601aed3 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -599,6 +599,12 @@ static inline int pmd_protnone(pmd_t pmd)
>  #define pmd_swp_clear_uffd(pmd) \
>  				pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)))
>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +#define pmd_swp_exclusive(pmd)	pte_swp_exclusive(pmd_pte(pmd))
> +#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
> +#define pmd_swp_clear_exclusive(pmd) \
> +				pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
> +#endif

Why do we #ifdef that here, but not the uffd-wp swp PMD helper?

-- 
Cheers,

David

