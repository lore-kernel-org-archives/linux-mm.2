Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976A5C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 12:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7A26B0351; Sun, 16 Aug 2026 08:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32206B0354; Sun, 16 Aug 2026 08:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948376B0355; Sun, 16 Aug 2026 08:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 609F76B0351
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 08:04:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D70ACC0379
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:04:50 +0000 (UTC)
X-FDA: 85107001140.17.F01F00F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A2774000C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:04:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S33O3F6C;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786881889;
	b=br5/e7mMVtn1dZxIhlHRdVhbpYwgGjXsBTtSc4TKUlJWJSt7hMdSdQHVLEVK8huWynk8zn
	A8R0US7D8l3JC/8MZ7ccbh5l656EA6C46KrPhWmIomvydRKEdOZRvTVJqg1r/3XeYaHCgV
	Ca3gpp+qhapjCmU3POfjn+mCPLhr/k8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S33O3F6C;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786881889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4ZIOaLur887dM5jmXZRYkMwRSiTmSfc8GojodwOQiY=;
	b=sRVpF/vOP965b3CObYwi2ASUHAaWG4iPlR5hNQWhWGtpg4eTOgDt8Zai+sPrmMPkQnXG6F
	gcCLJIlUoR5txoqMdRU1GVdjEK3cgGIKljqPfD4rX3bVpoFhOrN3yhDj6Drs0ct+IeeHeT
	2Ngp1w9GFbDsTeEXBWTA7VoB2lQbhzw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01F9E60055;
	Sun, 16 Aug 2026 12:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBBD1F000E9;
	Sun, 16 Aug 2026 12:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786881887;
	bh=z4ZIOaLur887dM5jmXZRYkMwRSiTmSfc8GojodwOQiY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=S33O3F6C5AUGl7vDtjdDX9lH/3T2taigTF+oc3i6gT1k8x45J6NKpx0Vs8H5Magkj
	 K3Rb9+AbInZ3sTS2QuFFNziA+5jrU+QiwlQ4dhSn3N0rszSwhcT7PgUU/au8tGJ1ep
	 Qb8/VHWq13vnhIIpexi7/pZAEv+cNVOQmj9NEUus7QKBRmd4uxgv8QnCe3ZJFYhhgy
	 8Mv2l2yzHg4j3K+anvdzlEJOcJbcjNEn6IONYyTlT3F6A9YLVw/mz3EbQXJsVvkAyW
	 EWpKtlg83ZquFVHuae/I1e+NTnVNg8AH6c8MlMP0xODBb6upaDlnJ0e6LdLAaB5ZMi
	 JrBiYGkWSoimA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v10 4/8] mm: add a template-based fast path for
 zone-device page init
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de, 
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com, 
 david@kernel.org, kees@kernel.org, mingo@redhat.com, muchun.song@linux.dev, 
 rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20260810122057.30447-5-lizhe.67@bytedance.com>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
 <20260810122057.30447-5-lizhe.67@bytedance.com>
Date: Sun, 16 Aug 2026 15:04:30 +0300
Message-Id: <178688187038.2799959.7142225711373927632.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A2774000C
X-Stat-Signature: wxizrespwbjkcihsyb5w9do3w7mwk8y9
X-HE-Tag: 1786881889-873987
X-HE-Meta: U2FsdGVkX19skeiFBzVlOkmLrQxjMRu6KI6YGhSfj0enQkfU6MVBA3UN03sfQEtcSNqii4Syfzl6fSTIR6zGb4nHIwQJDlsMh2HjEsdGGXeUqjJTzMejQAVAHnxc0rjRx/g5Db8hS3N+3UE8scafIfMVOLxME/QS0oLAYZtXOzaInkrhYybVnurYIta8VjjvjcVhMdxtM6j70X4GAX149uNZXNx+pEVkwzGURZq3wkTF7lSUzmOt8geawiL9c33cSr3tTUjTFtmpP54syuJaEmcp7nDvpj5GGs79izORAUoqwtXN+e1PDmT5CE02DdnAu/iPJ+VrBfbRYE5go2+i0EpwKU+k98SUNXJu0MmCpQLUzRU36XIqLjG4wy2/s+tqiyHsQLqrLk7xRBujFsdiyL/raLR94QMJ/9Ioa/70T6CHUD2A4BzH9cdXYXklBSlg7AK7O/az6UAP1zFNMfhFKzxfq7tTIghRcCktRUcT9kKtCSenqm0snSShX3VlAxmrcWcuPEGH5hrScbTyZc+cuiGD804XOJTTgTFhorMIZoMXHPGEY844Zcb5Xl/Ub7lWTtvFK8Wh1MSD2UyJDWFd859kXzjdYBIfJvfXk5/qNl4kzS+soww9DFIngYpml0AqOcaWBBcfXL4yx5qNfB8B1BE5JriVo7v1e+ruc+tXJtmlO8AsajVUMMdOflXajGbHF+fJqChodLoRfg2ZbgcDaI9w5B0OqI4hS8Ir4ILtp6530Czgv+UPNKvTtUil5MIS916XwauxN7K43nDFcqXrCbIUhvifoXPKPN1s/GDmayi6ehks4sjxKxPwe9H8zmc9XejiTtLVjVY8nfFbp7P/THgsgBo5l/qXXibz5z/zLkdgr/Q8r783zkkpkrT8MVy+xonwE6Wrw+IxIO28ZoZF6yLqF4pvJ3RZEddBPlaL3zmdhcTU0pGF7oEj/eJegmgSLrt2w66lrdwXPr1zSVg
 rOMzq13f
 6xoffTsE9BEu70Nbr4pCWvaGirDpMr2wPFlxGFnw+tlV3KtG45HUfbmpPe7JQtK2ALzMwUiMvC49A7WwX5TCXfxMU/lvTFtJEeAx6lcca9k1Xrz+VmUiw0IzNQFBOf8o1lpLYmo1zNQWGkhabzLTPpEgxncLcuwLpGbIse+Vq3jAfmAZhngxO2BxsM0lhJFu3y0bFpvLHa714ElB1zuIT4zZvdDwX/4va+/uPjmtSXuk4PIJ3JyMp3aYeYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> memmap_init_zone_device() repeats nearly identical head-page
> initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
> template through the existing slow path, refresh the PFN-dependent
> fields in that template before each copy, and memcpy it into each
> destination page.
> 
> Use the template path unconditionally. The page_ref_set tracepoint is
> primarily a debugging aid, while this code is still initializing struct
> pages before they are handed out. From the perspective of users of those
> pages, the initialization-time refcount transitions are not part of the
> observable page lifetime.
> 
> This means page_ref_set will no longer observe every initialization-time
> refcount assignment for copied ZONE_DEVICE head pages. The impact is
> controlled because the final initialized struct page state is unchanged,
> and keeping a separate non-template path only for this local tracepoint
> observability would add complexity to the common path.
> 
> This patch accelerates head-page initialization. The pfns_per_compound
> == 1 case gets the full benefit here, compound tails are handled in the
> next patch.
> 
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
> path (pfns_per_compound == 1).
> 
> Test procedure:
> Rebind the nd_pmem driver 30 times and collect the memmap initialization
> time from the pr_debug() output of memmap_init_zone_device().
> 
> Base(v7.2-rc1):
>   Average of rebinds for nd_pmem driver: 244.28 ms
> 
> With this patch and its prerequisites applied:
>   Average of rebinds for nd_pmem driver: 215.55 ms
> 
> This reduces the average memmap initialization time measured during rebind
> from 244.28 ms to 215.55 ms, or about 11%.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index a70acb7431a6..56a36a71ba89 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1065,6 +1065,35 @@ static void __ref zone_device_page_init_slow(struct page *page,
>  		set_page_count(page, 0);
>  }
>  
> +/*
> + * 'template' is a reusable page prototype rather than a strictly immutable
> + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> + * the current template, but section bits and page->virtual may still depend
> + * on the PFN. Refresh those PFN-dependent fields in the template before
> + * copying it into @page.
> + */
> +static inline void zone_device_page_update_template(struct page *template,
> +		unsigned long pfn)
> +{
> +	set_page_section_from_pfn(template, pfn);
> +#ifdef WANT_PAGE_VIRTUAL
> +	if (!is_highmem_idx(ZONE_DEVICE))
> +		set_page_address(template, __va(pfn << PAGE_SHIFT));
> +#endif
> +}
> +
> +static void zone_device_page_init_from_template(struct page *page,
> +		unsigned long pfn, struct page *template)
> +{
> +	/*
> +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
> +	 * page. Update the PFN-dependent fields in place before copying it
> +	 * to the destination page.
> +	 */
> +	zone_device_page_update_template(template, pfn);

Looks like it's the only user of zone_device_page_update_template().
I'd just fold it here and drop the comment.

> +	memcpy(page, template, sizeof(*page));
> +}
> +
>  /*
>   * With compound page geometry and when struct pages are stored in ram most
>   * tail pages are reused. Consequently, the amount of unique struct pages to
> @@ -1127,6 +1156,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	unsigned long zone_idx = zone_idx(zone);
>  	unsigned long start = jiffies;
>  	int nid = pgdat->node_id;
> +	struct page template;
>  
>  	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
>  		return;
> @@ -1144,7 +1174,22 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> +		if (pfn == start_pfn) {
> +			/*
> +			 * Seed the reusable head-page template from the
> +			 * first real struct page. This initializes the
> +			 * first page through the existing slow path and
> +			 * then reuses that final state as the template
> +			 * for subsequent pages.
> +			 */
> +			zone_device_page_init_slow(page, pfn, zone_idx,
> +						   nid, pgmap);
> +			/* init template page */
> +			memcpy(&template, page, sizeof(*page));
> +		} else {
> +			zone_device_page_init_from_template(page, pfn,
> +							    &template);
> +		}

Why can't we init the template for the first page being initialized and
then call zone_device_page_init_from_template() unconditionally?

The same applies to the tail pages initialization.

-- 
Sincerely yours,
Mike.


