Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DE9CA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 17:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F68E8E0005; Mon, 22 Sep 2025 13:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7428E0001; Mon, 22 Sep 2025 13:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD0E8E0005; Mon, 22 Sep 2025 13:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5726E8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:24:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF85184BB4
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:24:45 +0000 (UTC)
X-FDA: 83917560930.06.CFB4C77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 28CE31C0006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:24:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758561884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KjlkSDWeLfgzt2hJTSF/yA75QuafGIPlx3UP9Kck4kU=;
	b=nzv7gnTt1dmUt81N9DfXTgovgdgyp59r8OyE0mqcXqdXT45jbEaxr0cYsn6+rxVR7ZSS0Q
	Jbg/zP4H0O7taATMermLaRS8wSzzb6Z4h7/xvl3GSG981PD7pvmh9YVDMA/RwqkBFzd6IN
	3Dx3VKzNq1to1Ymh95G1EFoIu3Jc2Sc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758561884; a=rsa-sha256;
	cv=none;
	b=D7C1ulRq+FFv0mAQr9GBDH9yHZtm1dqfU1xD+AwJYiodvvr7mcTBL4te1+DSD/a3gG1mpN
	P3c51mu9ZMMljSN1cWaUlbVYU/Njsi01LsqNPXdwgfQaI6N2EZvyU+UguZxORv4d2gHo/w
	T1BGQy7Kch1B1W9Sy42WAfHrZSMPr9o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52522601AA;
	Mon, 22 Sep 2025 17:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AACC4CEF0;
	Mon, 22 Sep 2025 17:24:36 +0000 (UTC)
Date: Mon, 22 Sep 2025 18:24:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	usamaarif642@gmail.com, yuzhao@google.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, baohua@kernel.org, voidice@gmail.com,
	Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com,
	hannes@cmpxchg.org, kaleshsingh@google.com, npache@redhat.com,
	riel@surriel.com, roman.gushchin@linux.dev, rppt@kernel.org,
	ryan.roberts@arm.com, dev.jain@arm.com, ryncsn@gmail.com,
	shakeel.butt@linux.dev, surenb@google.com, hughd@google.com,
	willy@infradead.org, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	qun-wei.lin@mediatek.com, Andrew.Yang@mediatek.com,
	casper.li@mediatek.com, chinwen.chang@mediatek.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org, linux-mm@kvack.org,
	ioworker0@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Message-ID: <aNGGUXLCn_bWlne5@arm.com>
References: <20250922021458.68123-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922021458.68123-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28CE31C0006
X-Stat-Signature: hhsumioz5w9nx4i4pz44wmy4rh3pxxbn
X-HE-Tag: 1758561883-317800
X-HE-Meta: U2FsdGVkX1+v73bRjc7EWd/nmUOsZISCrNPPpHvpJUVeZ4JYIsc7NM7GKQ+3L3ddAbxx+B6plD7a72VIYQh3UJtsmSU3vBHMc1E6RR+C4vreJvE/u8tWPMHrxtRpPH3O5Y8MU5pZX86494gdOFMx0dY5Kn9xfZGZ04LZGqXtRAZTPM2OQ9W43xxCvDFa6x4XdXpUX4MosTuQb6u5+PuDGiEj1wNIKzQ3mccLWmGUn2hjDQx4EfKxyEsXU2nkWPRn3e1yt50dH0NE3kfEDOP0azayKld5dfEAIG2thSeEPUqNxYMyQnHSMasAZIq0Lix8+tNZ1tr1Rpn1IneM4jLFRu9y7Oy6RQEZQdvyHN3enUzuuGtYfB6At3w/P6EV/xueleMOe550duhX52pd08jvh3xesRPzafGW+xi6kfx1xDp6FePofeDbDqdgxP7RWtV6WACNvm4MoM/CTeRmfydz7XjFD3pIkmxSimnhuyA4rOFHu0PMHhMqsj68v27kPi1PnOJPwp17s8zriLSzYXP7XonSgPMI2Gkr94hc9kmWGcnOBIis4k5dmz4/pT5KV2xxKDjoDQ4vkJw42tSSBNVEyTS7BCj5bZVUn7Vu65jsoxkC4cbFVdzUNo2ovWV636rAWq7+MadkOOAF/Dj4FbADiC7DhmEN3Tvw4oc5zMwC75TZAc28jUpWpaUlTTQbG0qEao6xve1qiYuLe7hC7bS/0Vx5fuOOBq9FlilORMh2zMIuO/eQFYEIMx0KH2lMmRTS2lgZL5eCcRWJxyBI+h4seY9vHMUgXkSFjiSjIkrPXBd4clgG/ACANUn6HPJ9iELOT1otz/2SLB22mEzmYh2IWZFqO7qbWkmrb9EE8mL4fmxyXdD6ArwjbCOUqUUiDIeH3Iu04LSWeNBeTNyMdhzH/v/pnPXnjLYsAtkV/VJyhiJ6qb8hF8Tkn5gOu6fnmJZ2GCnCmVjLCdp/CGKMSAb
 iYUg4Z+Z
 rhSsJci/TiizGaE3j1GJfs3kizXNMHdYp7KU9drP6XaR06WQlBPE1t8bBWD8I8x5AzO5SslxinTX9JkcILelcJChNMrCXMxZF+KxYXcmd3QzfCERn+DNg2+AAomD6u/Dg0u/Kt4JEjANGyU6CeP6DE20/tHRPDPXigWwhbofkN32xwLm1+0fnNEM5cVcKm7epl9TOIa2W2nccpCOFLocoFFJcqM73Zb8Uoh6pQcIMQabUM1PdjIuf2LIgP2ZE36IpQm9CLfxb2WPyaYK6+Ma+Udql1Ux0KndtYdItpt1eabX2JRsO1oukDIrYR8DKqTdosgbiPkbvwr24HjOUMLRDdmuxnWOF/FDQ9ek69vjeR8plzOVpQ/ew/cUtq+2HJwNbX8QCcjHyte/yOJTOOr0WoYWldP28UEmIWf/y71h1CRrzAQaaebRsPlCCAyuflOB24rh5gqwu/SMd+TPzYn/3uspx38AOS+ChWvvvsS6GjHJziSG9Kc3JQO420LHEQoiD0G+7sFEjq5MFKYzDe5OGWVif7nqzBFgeWDs6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 10:14:58AM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When both THP and MTE are enabled, splitting a THP and replacing its
> zero-filled subpages with the shared zeropage can cause MTE tag mismatch
> faults in userspace.
> 
> Remapping zero-filled subpages to the shared zeropage is unsafe, as the
> zeropage has a fixed tag of zero, which may not match the tag expected by
> the userspace pointer.
> 
> KSM already avoids this problem by using memcmp_pages(), which on arm64
> intentionally reports MTE-tagged pages as non-identical to prevent unsafe
> merging.
> 
> As suggested by David[1], this patch adopts the same pattern, replacing the
> memchr_inv() byte-level check with a call to pages_identical(). This
> leverages existing architecture-specific logic to determine if a page is
> truly identical to the shared zeropage.
> 
> Having both the THP shrinker and KSM rely on pages_identical() makes the
> design more future-proof, IMO. Instead of handling quirks in generic code,
> we just let the architecture decide what makes two pages identical.
> 
> [1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
> Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Functionally, the patch looks fine, both with and without MTE.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 32e0ec2dde36..28d4b02a1aa5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4104,29 +4104,20 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>  static bool thp_underused(struct folio *folio)
>  {
>  	int num_zero_pages = 0, num_filled_pages = 0;
> -	void *kaddr;
>  	int i;
>  
>  	for (i = 0; i < folio_nr_pages(folio); i++) {
> -		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
> -		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
> -			num_zero_pages++;
> -			if (num_zero_pages > khugepaged_max_ptes_none) {
> -				kunmap_local(kaddr);
> +		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
> +			if (++num_zero_pages > khugepaged_max_ptes_none)
>  				return true;

I wonder what the overhead of doing a memcmp() vs memchr_inv() is. The
former will need to read from two places. If it's noticeable, it would
affect architectures that don't have an MTE equivalent.

Alternatively we could introduce something like folio_has_metadata()
which on arm64 simply checks PG_mte_tagged.

-- 
Catalin

