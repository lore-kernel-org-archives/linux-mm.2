Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7A0606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P2VyHUmX
Received: by kanga.kvack.org (Postfix)
	id 29C966B05B6; Wed,  4 Nov 2026 04:15:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274B76B05B7; Wed,  4 Nov 2026 04:15:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3A26B05B8; Wed,  4 Nov 2026 04:15:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8E426B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:15:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89DB216066B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:06 +0000 (UTC)
X-FDA: 85396877412.08.D2ACD3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DF302180010
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2VyHUmX;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCFfm843u8/elBaIEdb8AzgdS0+hlymbLUHyiHn895g=;
	b=fJpRLHR0VBTCamfDMX1uRyswfyhpl/ncUDbluhTv9voODaBR7O+XvWMMYvMgJqhmVSzVyS
	i/2j93wsvINjCFGKNMnAVevjXOjg6gvI9RQ1zC94zSdRv57rQHsNw0XtTiJ9mzYqcy2kGs
	uXHO03ehc2ZAFACE3WZKvI5lM6ud+wg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783704;
	b=g8VyaOya80bFGLoDXbugZKmWehyFH1hxdHhEtQWgcidQBV7DOEBElzdnMisYtLb45HHbC+
	Og+g8n6XGYvH6mggn3vmtWxnxRbZB6t4rKoHGNsrxrxzpvqNlK2ldEnPcapYylbwdSdsz6
	VJxvVtmiDcFFYalnOF/TDqkgCPefJ14=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2VyHUmX;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FE65602BE;
	Wed,  4 Nov 2026 09:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072401F0093A;
	Wed,  4 Nov 2026 09:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783704;
	bh=zCFfm843u8/elBaIEdb8AzgdS0+hlymbLUHyiHn895g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P2VyHUmXOTKNccAWnsWQzGG4kjE2tHG11Fb3k5VTve3RIeyUyrwUL6y/DUqe2KhQ/
	 qrdaEjdMIbUev3XrFs+Ls+dcv7bDqqET0CWUGdq/PmXijGJQq5eGEBsqUFp7f4O3FF
	 zkyaL6jGtaLRL1x1xmXnnAxmpV30wJdXL4j2Wf6q6nw3Y6o5RWboW6zeaQVeNsJpnE
	 Au61t1i1IcpHhkQnpCSZ7l++U97L6h/DZiEvqExZdwhTGZk5z6xJoYaMNmSXL0FeUK
	 QxXsgpg9iBETtbilcbZd5els7i48g2auyc00OUb6m5WFc0k0/IJbg2ClCjAlasEjB+
	 jMKZz7T9gjomA==
Date: Wed, 4 Nov 2026 10:14:57 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Sashiko <sashiko-bot@kernel.org>,
	linux-mm@kvack.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix validation of unsupported HugeTLB
 orders
Message-ID: <aur3kWpnFAOaX8nE@localhost.localdomain>
References: <20261104071858.757793-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104071858.757793-1-songmuchun@bytedance.com>
X-Stat-Signature: w73qteyjhwnf1gtbrnb54wtcm1g76bt1
X-Rspamd-Queue-Id: DF302180010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793783704-195737
X-HE-Meta: U2FsdGVkX1/9UEl30hXwcMCr74yRNaWbxpvaRrrWCoVYzRpP42Nxl8EGT4Ms8dWCI2tEmk2+cwX0DYpExVNQ3RINh/QNAlwyuIxYWEKkp2oJCwm9UPRnKmbHtPaskGrXag0CKe0ymWtALWBvUCEZJSI8+kn0TelDCALcsYKVJxp096Wh/m21EKMGPub04FIerkFyy329OwzYl0gtkl1rrNB97RZ62hEwRb7sgmYmlO8MNY8vlfcg2Tjq80ysaDHl3JhiT/ZaeCfPrGqCrBH3abpmMmx+vuI6GsxS3nGjrnsbG8Th+nH9z3kll069u/8J5+r6GcTn1GTEXXr1M8YbWt9re28OqCOA8Q2PN9qWOxvqj5QwwGyUX+RsTvv65Yr5N4BFQLettvVQPzPCkKLsYgm0YxWh/XknwrbqmXR9eBNLu9w4wlR+oABx7Ji1JIihDGWrlvvkmvNKgYegepAHXvlAis9Xt2tDGicTrYQFDlNbDDxp2q1zoHHebFYavGBFO/6IFFe5OQSf2axAlbzAuQ3VVPAo06uVNvEEAL8Qu1wZxKIVu7HnOmuM5/+p0cjjlMYSw1ShS2jI1nAfMnigH+9DU8GIhWcOlSrXF0dEHZEhfOWOUy9p4MpL1l4RYzc81fSG4OQm2tc376dxkmk5W0g0+J6grpTHwJSJznGy3Bb/JnD0vQRoALze5tKc7XYKnVibvdTjUPTRBMWFRn0nG1zIRNBdf0zO2LGUz5YHt5rNnv7x+lYSE3gaAd4bujslprSlH6UwTGEfarghy8GVgZR/73b4xfpVHzE47B0HlMQFCm2RxdYJpcF1VAbOKv/neUGiZkc0IGaZrC1IkJiEpyXaGT4n9vXK3RFwVOtU1F6sOSnNFRtGD4lyxWkJsKdK75aoa0vs8vL2WOGYQLHlI7YIW9ixv/lXHue4zn9LgC8iECDNKTmm5UiDHubADdsYNkhENb/yKmFeR9hxjy8
 NaERD2SN
 qlWOhA3p7wQf92ObJC4otnRFJVqNp7bFJNKsXzdXnxoBoFVhp0FMxsN1OduByM8adsPKkJUoI1V1siHlcdgecioQNhU4v0oqqLP8Kc+YJxm40wU+z5KhiTmRXM3YXpjDuB7IJrMePLqdrjdvEXRS+es6AIJTHRBS40QzMr1Ymif2SS7ZaA5pdJRXr4sXZd4foOBVhuzZT93fZousBjRkdRpzeKWSZG4xADapvHcBtaZfQUpJEkuicjQwZhvGFtuuzhnqU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 03:18:57PM +0800, Muchun Song wrote:
> Commit 7ce6048d3a7d ("loongarch: drop ranges for definition of
> ARCH_FORCE_MAX_ORDER") removed the ARCH_FORCE_MAX_ORDER ranges for
> LoongArch. Besides dropping unreasonable upper limits, this allowed
> values below the architecture defaults.
> 
> With 16KB pages, LoongArch defaults ARCH_FORCE_MAX_ORDER to 11,
> matching HUGETLB_PAGE_ORDER. Forcing it to 10 while enabling HugeTLB
> permits order-11 HugeTLB folios even though MAX_FOLIO_ORDER is 10.
> LoongArch does not select ARCH_HAS_GIGANTIC_PAGE, so this violates the
> generic MM assumption that folios cannot exceed MAX_PAGE_ORDER.
> 
> This invalid configuration is accepted by Kconfig.
> BUILD_BUG_ON_INVALID() does not reject it either because it only checks
> whether the expression is valid and never evaluates the comparison.
> Detection is left to the runtime warning in hugetlb_add_hstate(), after
> earlier boot paths may already have used the invalid configuration.
> 
> When an invalid HugeTLB order can be identified at build time, reject it
> there. Otherwise, reject it at runtime before the mismatch propagates
> further. Use MAYBE_BUILD_BUG_ON() so constant violations fail the build
> while dynamically determined orders are checked at runtime.
> 
> Fixes: 7ce6048d3a7d ("loongarch: drop ranges for definition of ARCH_FORCE_MAX_ORDER")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-192874@kernel.org/
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Suggested-by: Huacai Chen <chenhuacai@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

> ---
> v2:
> - Move the order check after hugepages_supported() to avoid a false
>   PowerPC BUG_ON() (suggested by Sashiko)
> ---
>  mm/hugetlb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 779b1de33c78..b49130eb7ad8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4197,7 +4197,6 @@ static int __init hugetlb_init(void)
>  
>  	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>  			__NR_HPAGEFLAGS);
> -	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>  
>  	if (!hugepages_supported()) {
>  		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
> @@ -4205,6 +4204,8 @@ static int __init hugetlb_init(void)
>  		return 0;
>  	}
>  
> +	MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
> +
>  	/*
>  	 * Make sure HPAGE_SIZE (HUGETLB_PAGE_ORDER) hstate exists.  Some
>  	 * architectures depend on setup being done here.
> 
> base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
> -- 
> 2.54.0
> 

-- 
Oscar Salvador
SUSE Labs

