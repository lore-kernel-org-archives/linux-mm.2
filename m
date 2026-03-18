Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5210FFF6E8C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E3F6B0140; Wed, 18 Mar 2026 05:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DEFB6B0141; Wed, 18 Mar 2026 05:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CDAB6B0142; Wed, 18 Mar 2026 05:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 498DA6B0140
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:03:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C90B859A70
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:03:05 +0000 (UTC)
X-FDA: 84558594330.09.8F4478D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DB8C120004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:03:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V4FsFf3A;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773824584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMi3YAnbwZwkd6syjiYWG7BWuVMjrCosNNqEkO3T21U=;
	b=LK6hp4CusgmB01BlWq+1HIbwqxkenjGLY1s0TtGJyhD7flgUKamOXVmj6gJ0FDOFiUco14
	mYKTfoy7VRoCdrD0CJeD8b4+NwAFcW6fH2EqGjS7uItpNbAOqJffUs9hxQWYcHs9baaeN2
	gOQzK2zRw+9D1QeSw4Z0H6CE8se0p6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773824584; a=rsa-sha256;
	cv=none;
	b=oWWt0tCSLQjYHoQaTA/TcfFMteHR/Y8B0+/l4edIP60fbg8CcXELRg2qxRMCIzGewkFatX
	SmS1gucztAGhDKsghhS8s2p1TLeWZeFbJL7wgyaZcSthBWoKLWL6OZFNbM7RuDgwXBau2h
	5tubm9tXVjhi+k5Dth6spy1THowL/C8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V4FsFf3A;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7FEC442D9;
	Wed, 18 Mar 2026 09:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280D1C19421;
	Wed, 18 Mar 2026 09:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773824582;
	bh=hoaLKmiRcmJU8QeJwEJzanDBeqWJkJ7UWkoWC/oQs+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V4FsFf3AtON/wgsLo5m4+/ZiZPG3wfTMu7h8ZgJgMHhQBildsS+RYKcSF4yapYu7x
	 2fBjExeGFITlfk69dT226peFZQEXUs9Tmch/ktwXz4SS8sVW5rdkfP+5yChyAYbhT1
	 GBFhr0Kwao8weO2Z79MRIGNUkSbRl8uemIyLATdAWnGXs1wKHgrLgmk2JF6gvuRcXj
	 kFwdgtS/GlSCBg5KXTWbDFu7/lymgd8Spk+1VNX7CBEX2qwnmf6QGjeDawt+f753f6
	 Hg/d4rEUIAh06B6x1CIBjXvS9LOkRBI8hgFznJwt3pb+/hm27jUtnkIsBfLNvI/8O1
	 BTb71ECQtqfAQ==
Message-ID: <88f37900-5c8b-4606-9081-e9b72acb0941@kernel.org>
Date: Wed, 18 Mar 2026 10:02:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, fengwei.yin@intel.com,
 baohua@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260318012055.3593216-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260318012055.3593216-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB8C120004
X-Stat-Signature: yjzctjap37s8x9tqfdp986qewx95tio1
X-HE-Tag: 1773824583-755457
X-HE-Meta: U2FsdGVkX1+XtBw8lr7UPhkWbj/E4+VYrgPd6p6L5zlH7YDfMSr+ElkZpJFWXqMiFUTEAOooEGNZc+4aFXdxJIg8s4BcbQyKBFCSkbPybNj29EEI7jbfxV4VLciHgLUh8mJJraEyDmRIEA9+mxMCzkVmha5+E6t3T4MnnmcgOWIXLLSiV6rO4n00ATWVUVa2WiozVAej9ar1LNmBXbVYetMSsOsi31MQsOjwXG8gUYFooDKWBRJO8BSIj7qWtXng3KI7TfV7BExouyVlIUD/af7XI7pDcdVncAgmPmy1wWEABbPl2AtCCBlsXtN8V1JYxHXMCmfjClnq0wsdBaMfsP9/JCwncLErPuCeeivy2QijirPPtAXOjCI0SPPD82Pcip5D/gFB9kSyUZBwqoSdbgAkCr4cIGTgwMPloBVDcLY8SgVyg7SJdF1ZpeoF7BfarGkL4eFq7nymaS9cY+DthzOZ/4UlURMYXu2rbem00/NB4RJeQ50WNeJrz33tdl9+1ro5Bqqw80mRnxLVV8snFJcoojJVV61Ev9gl017u7Fdvudz2VgXcPivjGB70Uvh4Cp3GCfBMCwawELIg+EsP6bEogt+lOU29v0aZUhqWQlwbu8C/EdagQqp6oNuUsidbFVyBsYctiAYDijHaJ4Ve/0krGHoTTVvEwnpyDh08kAny3LRn9TCVTNfl2Nl14yBqT0qCN+DXrEfnNb/TK+20y+GMe8GABohcnrdH9DXxYKZUYizw4AohpRNCFKmJmQPSCnRtusWAXTsMgpmPUV0B6LpfeHs+z+OH0BPrtmeNh0NrD5JWBX2r0d4r2cctJPyq+64501+Haqe149W+SVTocTyND2tM8M9i69YgyLSWzDLigs7Zx4AKMtblmCiN4q8LTOywnP9RVq7r1WFl7Y/dYvp70qPZBpHtZzfJIhNP3pOf4IDG+zohwTzUHG/3n9iJS7UZhKdjOTzdVYjfgVp
 V+46xgdk
 Yvy/IcSw+nyFUcMrenO61/0wgms2JNAF4I4cYQy5wKqxJVUpNfNiq4px8OpGHXUX/X/CF1CeIK4ZU1arQOknkZVt3Yj3UFu2ujhSA7E4Fb3es/+iafoZLzrfaZ/JoL/dqujUrUDjQnBWlMTuI2RR81seynB2+jHcZU2pfQx3NdzJfw/13woVrXefSKz/kxI+vSXHUFotxyWskjxOXTWXx1cC+s08DfyjjNhKLJk6cXqXNoPZYVhAHd9NvqOaawo6QGGP/ltRIFwwWUuRpCQtZlC72NeD13wOEy8F/LuPgic89c+ztqAgngODtrStxj9WZ4K8/FN/dBWpUYaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 02:20, Jinjiang Tu wrote:
> On arm64 server, we found folio that get from migration entry isn't locked
> in softleaf_to_folio(). This issue triggers when mTHP splitting and
> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
> in softleaf_to_folio(). The race is as follows:
> 
> 	CPU0                                             CPU1
> 
> deferred_split_scan()                              zap_nonpresent_ptes()
>   lock folio
>   split_folio()
>     unmap_folio()
>       change ptes to migration entries
>     __split_folio_to_order()                         softleaf_to_folio()
>       set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>       smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>       prep_compound_page() for tail pages
> 
> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
> are visible before the tail page becomes non-compound. smp_wmb() should
> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
> result, if zap_nonpresent_ptes() accesses migration entry that stores
> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
> page before page->flags.
> 
> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
> in softleaf_to_folio() and softleaf_to_page().
> 
> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
> 
> Change since v1:
>  * update fix tag
>  * use helper softleaf_migration_entry_check()
> 
>  include/linux/leafops.h | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index a9ff94b744f2..c7dbc3fb8ab6 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -363,6 +363,22 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>  	return swp_offset(entry) & SWP_PFN_MASK;
>  }
>  
> +static inline void softleaf_migration_entry_check(softleaf_t entry,
> +			struct folio *folio)
> +{
> +	if (!softleaf_is_migration(entry))
> +		return;
> +
> +	/* See __split_folio_to_order() comment */
> +	smp_rmb();
> +
> +	/*
> +	 * Any use of migration entries may only occur while the
> +	 * corresponding page is locked
> +	 */
> +	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +}
> +
>  /**
>   * softleaf_to_page() - Obtains struct page for PFN encoded within leaf entry.
>   * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
> @@ -374,11 +390,7 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
>  	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
>  
>  	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> -	/*
> -	 * Any use of migration entries may only occur while the
> -	 * corresponding page is locked
> -	 */
> -	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
> +	softleaf_migration_entry_check(entry, page_folio(page));

It might be better to do

if (softleaf_is_migration(entry))
	softleaf_migration_entry_check(entry, page_folio(page));

Removing the softleaf_is_migration() check from
softleaf_migration_entry_check(). Then, we don't do the unconditional
page_folio() and don't call the function for non-migration-entries.

With that LGTM.

-- 
Cheers,

David

