Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19667606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VIwVVeNh
Received: by kanga.kvack.org (Postfix)
	id 332B16B05B7; Mon, 23 Nov 2026 12:19:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E45A6B05B8; Mon, 23 Nov 2026 12:19:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9896B05B9; Mon, 23 Nov 2026 12:19:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFD316B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:19:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FEF4A09C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:19:45 +0000 (UTC)
X-FDA: 85467045930.23.29A9FD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C80EF40010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:19:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIwVVeNh;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795454384;
	b=ACXgv8ZP9jWiSAevAbR45Z0tyjVPFVT0xWGo/udBVceVopuvgrhEk4WWQ591V8+XKcP+b7
	a8EET4+xXcI5UCk2YHQvro/co0SEwG3EeujjdbKL2kry/oOExZYsfO2qw+8ucQJGTTUooy
	AXDQTqkznSfevuXKVqdnFKoZHAf0GnM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795454384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FrBWwyWG2ofrr4+eX/hR4EQoleVZwLseOTkT4V6vlI=;
	b=lv/udiAUxyhzmnWZ34xsK8/XogpoGRs4n3aeX6qYUqg7Pvx47aClGX4YYSihKw9g75Jo5E
	eLSrHnUJw1T17Ry/g/++vAi7+Pjk7KnPxOufEu6hmuTPgAe3YcE0TJ108hmSBAeMnD6Ul1
	6mmLWJCx2qezuq8JXwPDjeWPxNlryp0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIwVVeNh;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC0F241465;
	Mon, 23 Nov 2026 17:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288E81F000ED;
	Mon, 23 Nov 2026 17:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795454382;
	bh=+FrBWwyWG2ofrr4+eX/hR4EQoleVZwLseOTkT4V6vlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VIwVVeNhymyUQbQGqVW+YvmnbRNxn3o3mDgtXy2kVL1odzz+6vHr3rCL+goN9oazP
	 xs4kvt2oTdgnqOqWqY2FkW723eDXl7qikinE6Guq8722FcmwaCF694l4SS7R8+2noh
	 q+/8zFyWiI2pvGhVQgvCkQbVkvchKaeDHtHSIDkHR1oJoamLhwGxZrgnkHc7gN1h+s
	 Uf5LnSW5vBIv369w4YmF2j1ZX139ZyOivzs34UdGX/m2OgpEVzFjG1CtHzEmx0/jk/
	 FtuVbXaTY9r4923X4trQ7gXKaLBoalcTruyuAbtUUJZ7nyBctAuwnWwx14gN37jWiC
	 A47d6bJ5Vs09Q==
Date: Mon, 23 Nov 2026 17:19:30 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm/migrate_device: avoid leaking folio references
 during THP splitting
Message-ID: <awR1nOpAuZ48BXFk@gremlin>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
 <20261123163301.1568240-2-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123163301.1568240-2-usama.arif@linux.dev>
X-Stat-Signature: f8zgw3n41abcikbyyym4nygcui87xdod
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C80EF40010
X-HE-Tag: 1795454383-200342
X-HE-Meta: U2FsdGVkX1+fhVCkhdR1YTuFG53VFljx/S6LVYgu1IV/C/k1cmjw8hMw4nmlOCEdwmZ88oHkPb6CreeLY3D2M95ujEvoktV0v7bve1eHcrBwTdeWJZVLjWSdBuxBw/jWr1YHse5Yl1gUahJYo2nq/Et60grfb9hbe9VkjxctxpiN7mjiPcz7SaYmqGVYkumLsRwTl1XGfoqXp+cdXWIwwUFciqma8muvhNEj0FKZQ0n1v0crk2Bbx0Qtdaz8WdjpR3T73I0CTmRDAjIXXgeFMA06Y+Rwm0zPNjNS9X19LmGodHIdvIMGTqHzX7hePqnPMffbeUZkhlQ5u101vvmkTIgM39zwRLx7dxtTqMgsqb467eztv5HXn1smMI1TSl1YVFkV6IMRFYXoHJWxwYHfDCd47TSDqiv5YDhluSRc8Di1fKW26SJYJuy5qFHF2jiH6xE971DVp4cmQcyZWcMM4c13quaTKUDW906J6zCq3xww14o7DQDvZmqcxAkSy2a6qp5tgDtVt86YWhYzSJPIIVtB28gKHrAoFJIpRjIoPTrbhrshliaC97thp9JU1ZQtZl+3Rf033UBvKPJMO9d3KxiuLsrZPVxIBinNx9KIDuU+Bei/95ez3QoWPMhvKNa5Ba4DWdtkcFAo2zO/84DIQhpiXbQO6HZ0zYj84LIFVF7uBgf1aCLaztsYIwGWu35sOwG01mdPop2z/iMBieiitCYXlyuvl07QQMV1NY0+OjFaGpnTzXcLPBXFBlJFcU+4vVP7L0yioIhU6pcQIcQn7Se+dyEY137lWQcXb9CrlfU5FndU21zldg/2RNdejgtKqvGzMOX34Z23N2kWL+NMQ0N0jaXrAVQj2DTY4fgZ3I5gRQkQM0gaFpLA06OVzW4smojyJkhJ/qDnBEFKVz4HjKkRxNEBZu86WJEhbBPZIaVRdERQXteZf/f6rINHhoM5y+uei+wCefDzNqojwkk
 zkXfEQcR
 8aCwPZJxTojsioBOf8F1BqWsJE1/UXzsrdCQ/rGs+exA4yOfQQdDm26qw55SgSq1cTeZwv425KlbRyMjRrVLmuJDJZsoh3+1nl6yDlpQXdF2JYxKLocs6yH1VoystyWDsX4tzvNrNPwqhWbzFQFMCebavQ7sNDw0z8FIXkQpBmjkKWvVVeHiEvbvv08u7RWDfPMSMwQrulGMfXh8/B3yzRM9ST3a0E1wiClRHJsA0FXvJPiqgKgygvCNei9/lnSBc1Ucxcr6PSsCytOv6YfF7AlmCDwyyF1/CmEOESUNUMdL8w3OgV6O+Miih5wkF7eW+e/yv8SsY2p3Pg6VOHBVaS3gaVWj6M8TIUjVrHauCgi6/q/P707W6NC5NmjfzFJEqy2YzUxL6pbKb/I8BE2/XiCTRLANWbXAcIX8KPl8xeZShvjqpT005jvSz3RBsNAtSafuDnupXmD2ppIHdXJN1ZqSm6tvBLcFZdKcC8GlN0t0ixrnhyzAvc3QpYNaxjKHfJcm0PmzieiaFYc79CzoscZqgKwHpZQQnfzwjYxpo4k+3f2sDWSkUiskSTKDaMIWj/OUbGzX+qqDxk3PknN4/0RWSDv32GJRjcMCxK7nFCoJeu4e+hcMSdUpo8SqWfusfyfJCwURwzrmItTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 08:32:07AM -0800, Usama Arif wrote:
> migrate_vma_split_unmapped_folio() takes an extra folio reference because
> split_huge_pmd_address(..., true) drops one when it splits a PMD.
>
> However, migrate_vma only holds mmap_lock for reading. A concurrent
> MADV_DONTNEED can clear the migration PMD, or split it into PTE migration
> entries, before the split helper takes the PMD lock. The helper then does
> nothing and leaves the extra reference behind. folio_split_unmapped()
> fails with -EAGAIN due to the unexpected reference, and the reference is
> never dropped, so the source THP is leaked.
>
> If a THP is faulted in at the same address inside that window it is
> worse: freeze = true replaces the new folio's mappings with migration
> entries that nothing will ever remove, and drops a reference the caller
> never took.
>
> An existing migration PMD is expanded into PTE migration entries even
> with freeze = false. Use that mode and remove the extra folio_get(). The
> reference already held by migration keeps the source folio alive whether
> or not its PMD migration entry still exists.
>
> Reported-by: Zi Yan <ziy@nvidia.com>
> Closes: https://lore.kernel.org/all/DLZ48KMS7YG8.3BTM0UUU8CTU2@nvidia.com/
> Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/migrate_device.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 9e19fadfa65c67..3286bb8a4b73ee 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -920,12 +920,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  	unsigned long flags;
>  	int ret = 0;
>
> -	/*
> -	 * take a reference, since split_huge_pmd_address() with freeze = true
> -	 * drops a reference at the end.
> -	 */
> -	folio_get(folio);
> -	split_huge_pmd_address(migrate->vma, addr, true);
> +	split_huge_pmd_address(migrate->vma, addr, false);
>  	ret = folio_split_unmapped(folio, 0);
>  	if (ret)
>  		return ret;
> --
> 2.53.1-Meta
>

--
Cheers, Lorenzo

