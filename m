Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A02CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 12:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBD48E0003; Mon, 17 Nov 2025 07:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD32E8E0002; Mon, 17 Nov 2025 07:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE91B8E0003; Mon, 17 Nov 2025 07:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B42C38E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:58:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8882A160D78
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:58:31 +0000 (UTC)
X-FDA: 84120102822.22.5C35B6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DB07A140002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:58:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uhgn3cJv;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763384309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTf00NtXPTgdUR75VjNcB/kwxu/aT+/ACzK+N1iM/9c=;
	b=vUAZJsHEtYbPqrEFWIxMiclBz1aNBh1nY56FG30md/KRn2u6hpMzXOD4IDolTshTQD73xM
	B+fK3yUDBNpmSRxWolqZFh6rTkIfD4thtj20B9hxnmpnOFWGC+KHZ/eAW5qqQQ4heP7nOc
	GGRkB0NRe06fHlas1dGZfm+lZ58Eyz8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763384309; a=rsa-sha256;
	cv=none;
	b=MeaD6osMLt/niuqI58ayJUhVrzmSOU0ZaTVSBa91IGkI5McZgn5EMfwfP3NkQTWaFGeF9M
	EHN1S9E7u8Wlybd5j9ZfR1a3QfHT1lBgCupHLsBuSgVD8v4+yONYG9/aUcAjmzUf7eNGtv
	nMmmc49rvk+fd6IWx8PO/iHN6i76ANk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uhgn3cJv;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36C0A601FE;
	Mon, 17 Nov 2025 12:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCDFC116B1;
	Mon, 17 Nov 2025 12:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763384308;
	bh=OLr27sQ+JriRX4/NEDgdTqE74P+APe5Bc1JBLjDHgq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Uhgn3cJv5PiL0Ru44n2U1aAWvA4gQuK/A4zSlD33Ju9WdIDaoc4NQCi9BKrydme5U
	 0YQBymY5uU72yIUqIBCKC9O0IAOn16lO+ukjanViFoKEcpRGZ5DGGV/SECz0RDBUjT
	 rEePn1ib158MU2B6hox8YN6Z8CnVFAAf8bezetMjZXueWirN4xVewvtZ+kdgV6ddMx
	 uIoJDwlqHCfLvfu0d9jdPXE2270dPM93g75FBKwB/rO/CP0Htlee1sS5JKudJbH7wT
	 JgsPZF2O2DkT1Ds6IAJR6fZ2bFZn6G3we5pytq8XbrqcFpBImUoIntYOUfVxzmLaao
	 euff+N0en5yAw==
Message-ID: <6020005e-8b62-415f-993e-b1d99e0c5158@kernel.org>
Date: Mon, 17 Nov 2025 13:58:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fixup: mm/rmap: extend rmap and migration support
 device-private entries
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251115002835.3515194-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251115002835.3515194-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DB07A140002
X-Stat-Signature: i4a87y4nd3wacpsk7jwjiidoqxk63cx1
X-Rspam-User: 
X-HE-Tag: 1763384309-440567
X-HE-Meta: U2FsdGVkX19mUw/duwssBZvSM4WqgWSR4DZhlCssU9CsvZ3BIkbPBzl5CtygEwtGMunen25K5AWmjblmiBRlHPVHLtbJokOuRHAjAhVmV+G0tv0QWP8izu5XNMe0g217LyhFJ2K2gM1oqA/2PD95lstsExLQ4iIa8/dQyYap6y0ccbdmWqxo5neDSIqKAd56zcYbRWym0CXkAxam/4BThJZFb66De9cesDAgxAhBCl4R0au+iG2apcgth4cUuyevBBMAyR9y5H72I4PM5KXjvQxlhPDJpkd2bZi0D8Ix337tovEnrIAGfSOSM9HJv8jjcs6VekQJj5Wn114kySwuRZu1gDVqX8ZYjUrpMwBAXK+kJjbNI63akBm0bnglz9QRqBS42BjSnxT/HyayONaWqyBTDB4a+tdaJw4+Dw4p0mgwSx2y2/Kx1s1DNH0+lNPp9NRiWir50cATuPQry1xaENsEd2EAQT5CrfytYm+I1a3DKhci5lZNgPSARe9nCmQvtHXPWsn6kl06iROaL9V7lRyxRRjFns1z5Fn5ZcLSmXpcEO5FiwLvTdQSUcbWxlkZTi4CqHUA/6MnKh2woutjTDoOrb6S9blFhTuZFohrDMFqxIFEQWUbTSfa5TDvldqWGOnH4xSKkZA4PSusd++GcjNvsGXRieDQr09fpch/MNG8K0tXXfmxjxp4A3QvJ7vfaVJh8bc4JL0otEGydhKrDuZDZHvyiUan5ZYTs00ehM+Z50McvEgAhMKML1zkQavhhdBCJOY54vzn2W8y76Vne3bGu3flsQc0o3A3aSFtM1y2wMHsr0YStHzWrH2Dgav9v/AcXStaeuAnXrhU4pzTnvRBOU1rjfL5Ht6hQ6kCFe3/m+CQxkIGvABUB16EJMLxdIWoskwKXX5pRalPfmCmcxZbCwuvrt6nlMPsuorKS7oKz9mc3OZG9bwOttZKqdDjDzSrdMK7CFNZOmyiRNV
 kjr/DiNt
 /WdBFbBfOfrPX+dmS+SO2jP3DU8oZwWSQ6WqAu94co6+JwH4mMk/JCN++iyziVODTR/1J5HHrwkaErAXLtG7DBnTbjiRnbIwOXrCYOo0XxINeyINn5sLIkayYu/KKi0LrXBeiWwH9LHnjugb7JuiqM7WSjk1nSQmFjvrH761RRy8euINmHiEyw37heIQtCOcxYAOj+jQlzd19MZZovHYuote2u8dozhI3yxyGQBV4OP6RO3Rvr6H+KktrMCZdtcZTB29gASBMP8NNg/J1W+G246cyp420TTX1cG7hL/Iad1SR8i/PeeNl64TDXho6UkIYXKwv9QUmFRgxqYKQzyTaKm4BUclt8awLqcmmaibMG8eTBi5Ut/y8IKu9zNWsQ1QXIqNXYh5+0ekrJ9Ao6Q4codZ0vA8TM5t9GeYTO26TsXXTWI+/uV9C74OWIuvwOruJj/qk+TY1+PIsNXC5NmpYNndxIh08nI46hXxFkxvc2IxpxarukyBQYwsNPdp2EtMOhCb6k3ahsV8xthv0tOWhkv8FP+Ym1cqvF7MipW5Tju+oVvVNTMChG3o5tYHrOrH0UiVxsPaAKmQHflsWBz7ulE68hpsWwC1gLlnfsin/r2gSs+Ei+9XUSfNhU/DWMvXJ9yfpSWlZHSUJXt5PhOnKQEESS/9fQSvCUw+uBEkcSwMZPdjzK9Lnk3jcuTr9qO6h0Hgz8ClJlKQMq5IjO220Bh73JO49vKvgNhCLbBbUNCIiqCg65TAYrZxbm4CPhFA9B8yQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.11.25 01:28, Balbir Singh wrote:
> Follow the pattern used in remove_migration_pte() in
> remove_migration_pmd(). Process the migration entries and if the entry
> type is device private, override the pmde with a device private entry
> and set the soft dirty and uffd_wp bits with the pmd_swp_mksoft_dirty
> and pmd_swp_mkuffd_wp
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
> This fixup should be squashed into the patch "mm/rmap: extend rmap and
> migration support" of mm/mm-unstable
> 
>   mm/huge_memory.c | 27 +++++++++++++++++----------
>   1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9dda8c48daca..50ba458efcab 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4698,16 +4698,6 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>   	folio_get(folio);
>   	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
>   
> -	if (folio_is_device_private(folio)) {
> -		if (pmd_write(pmde))
> -			entry = make_writable_device_private_entry(
> -							page_to_pfn(new));
> -		else
> -			entry = make_readable_device_private_entry(
> -							page_to_pfn(new));
> -		pmde = swp_entry_to_pmd(entry);
> -	}
> -
>   	if (pmd_swp_soft_dirty(*pvmw->pmd))
>   		pmde = pmd_mksoft_dirty(pmde);
>   	if (is_writable_migration_entry(entry))
> @@ -4720,6 +4710,23 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>   	if (folio_test_dirty(folio) && is_migration_entry_dirty(entry))
>   		pmde = pmd_mkdirty(pmde);
>   
> +	if (folio_is_device_private(folio)) {
> +		swp_entry_t entry;

It's a bit nasty to have the same variable shadowed here.

We could reuse the existing entry by handling the code more similar to 
remove_migration_pte(): determine RMAP_EXCLUSIVE earlier.

> +
> +		if (pmd_write(pmde))
> +			entry = make_writable_device_private_entry(
> +							page_to_pfn(new));
> +		else
> +			entry = make_readable_device_private_entry(
> +							page_to_pfn(new));
> +		pmde = swp_entry_to_pmd(entry);
> +
> +		if (pmd_swp_soft_dirty(*pvmw->pmd))
> +			pmde = pmd_swp_mksoft_dirty(pmde);
> +		if (pmd_swp_uffd_wp(*pvmw->pmd))
> +			pmde = pmd_swp_mkuffd_wp(pmde);
> +	}
> +
>   	if (folio_test_anon(folio)) {
>   		rmap_t rmap_flags = RMAP_NONE;
>   

I guess at some point we could separate both parts completely (no need 
to do all this work on pmdb before the folio_is_device_private(folio) 
check, so this could be

if (folio_is_device_private(folio)) {
	...
} else {
	entry = pmd_to_swp_entry(*pvmw->pmd);
	folio_get(folio);
	...
}

That is something for another day though, and remove_migration_pte() 
should be cleaned up then as well.

-- 
Cheers

David

