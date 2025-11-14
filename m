Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB686CE7A8E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 09:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E238E0007; Fri, 14 Nov 2025 04:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206648E0002; Fri, 14 Nov 2025 04:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143528E0007; Fri, 14 Nov 2025 04:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F382B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:23:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B53CC1A02F8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:23:12 +0000 (UTC)
X-FDA: 84108673824.11.96E727F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2104D4000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:23:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5lG5vZm;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763112191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y054mCCQ/pYiXow8IGqMRGCUxvxMhxPHj/jCxz235YY=;
	b=ad+ZnYed0dtI4yVylxgl4VkJlz1EW/v9h5GzW6o7Sq04zBcZ7tx/4VDPdEP2uGSxVUtSvv
	w9yinCDn6UqcRwsao2Xkp3YC6rsxyWm70IK/BSnULrTiWyzjgTkh9AR+Wa4pwqbDRDMngb
	qfJTExO8hbGjj74Nw0s72XOAN+I+TZw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5lG5vZm;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763112191; a=rsa-sha256;
	cv=none;
	b=W4B+ifATBZ9fJ6B83iTQBdbDtF2Xy07Xxabx/h/VEcGLKTNMQe3p4f431drBaujgrDVY6R
	cBUDle3+8iqEa1z5gRlhAabIDzyf20o4gJM8/roEByQqQQcip9pPqmfCpBt7ONVL3lb5jw
	HTMXXYjgdAiaPo64Nnq3cAlFYesXf6k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 953C960169;
	Fri, 14 Nov 2025 09:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2788FC113D0;
	Fri, 14 Nov 2025 09:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763112190;
	bh=IZsYdb3J2TG0ZqDwkKnSD/BUdINuFPFPuUpaAFMOshA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U5lG5vZmHFU/SbhlnwtaE/Ua/9v1Q1x9IrvpCzLqE1tFTPWc7qeQ+xIEFlXGBgeH6
	 7JFdiPfTuDWiz+ixIzfbZHJV0PKCqYR1FT5u0wd5j/DGwSaSLfFjCQugAfx+sgRNv0
	 zl5tVidOG5e4HexSNVSr8BkCGwXLUUPOR5dStA3h7nMRpwYbqX/QQBYY3vlPMeYN06
	 KNNS9XXVy1TbWE4adKaPa6oC3hgRQOoBRjip3v9FIYr9DpmhIjIFJPaP6dGUyez+p7
	 Yhd9W6x7bEAU7pJqATie25fEJ72RDmfKYUNqIJ021w2MG+HdMg1MT1q04paY9ebJAo
	 0b/B4YnIY1YLg==
Message-ID: <e8f4546a-5c48-4488-a115-5af65c06f1dc@kernel.org>
Date: Fri, 14 Nov 2025 10:23:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix override of entry in
 remove_migration_pmd
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
References: <20251114012153.2634497-1-balbirs@nvidia.com>
 <20251114012153.2634497-2-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114012153.2634497-2-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2104D4000D
X-Stat-Signature: hbb8p1ro9z9np5uh4udou1dir48sqg9r
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763112190-363215
X-HE-Meta: U2FsdGVkX1/ytNgovSEdu026RPlvrCglmX8DsaPpIQtzSwzXMfx4wWki9qnU56eYl0ya3FQTBNEbyu7kjryA+f/ap2RIZXC3G26T8JYnM8FbUPrbEG/KmAt8a4K7TnqRDN5DwwW2h9Iw8NEzkcHgoMRK527+rWmTC7MfKCpC58hR8BGeUtGj0bKIZfrZ6Pw0Oprck+N7L5SI6YVU8iXTqU59n0tihQHZ2/t1tqoVJeRREgjmmVmOb+zQNODfYfCD13Rh8NnAxD0Lj0kkwqFO8zSPbx93sgVH3u2BubHM8wAqcY2/qdf9H53r0qQNRrAFrwvjzK9EETvDeTZH3xxrPljGvzuAGn39wbUCJ4oMcgf6bQFTsisdNajEwC+hMIshBD8hzMQWOdResdC+/tKXsexvs0RD6ChS8SmBqGFCixPNXrVd+J486PrI0XpUphhVmKACeIK7WlSUbXNhSXvI3NLiNYnkhQexlVr9HWdl7JVbfUp+3BJh1nLHJ/U1eb/Kcchwii/5GM8hLVqqJR1wYOE3FjlWTBCDQTsItU0JIThM6Ls/f2CmjEMWQg1YfcFXv/DAdIohg6amZXXtQFhIzpFBn1ETqrHjhcOI7E7wGsmPPhYEZfu3rae1Kps6TFy8M667SMAbgUmOwlU0ND4NOB9ARhQgdVxUasG2yUjaFXAZeyow2eIE26Pk1wCdLcI2uhpMv98B7VK/85vENanTBbmkE0DFHlFpfcQBt+0ociqNOEuq7akoOUtT3k+nyzW9hEjWsUKQbWRl9pYDAjJWJagYYg2EbzN1hDkKwnX77kR7mK0HLgdLuMMbysIXJZ3zAYeimnWbuW7JWl1ZWIT5Y6JeGAr7oS9r48fjKxLOhdLDNQ/8daLXJh/ZPX9YubvhphPqj9k23zZml6MeANATAjJzgxTVLzUwneBffhNfN5qN3YYM4PIcxgpaw1ea2s9bWSYr8mayPHVECNGN0YC
 oRFGnAiE
 pmumG45X7+khAaV+VSrkt2y7wsXQpNd8OnfK9p8rYL80BuLhFPVmfFkjD46Nf4AeAiNA4ptDVTj9hbMZd3emr2wH3+qmcE+Yy7wcPFkEkG8EgRmsRJbxOVGz9KBJSyCGS6FJUTVmfQbrYLCoIQk+IPVOnCdZgJCaUm/IQS2oCQuAf2oUqtTVUlGAVx4TfHEyyad3oxr874TM2uyLlo8YZ4OGqShATy3lvvUhQonHJ1dtvuEqQ1d8Lkf9NrEErg+6Ka2Kcq8fc9W6l8HOyr7rp2buT+AR8dnrmuGPW55xDdoDoTufZEDvZxU53eTMEIzTaPB2pO2A9vvX67bE2P+j9y4WfjIWWsiAdbGJ3kaXjmm9cbL6UyTG3AawqcUgem/DtT7+dFl1xXirzmSlmD6rM5RMMXYKQkHOO0xIFp8KzsSjV2xPZ0iHa9VUuPBPyKAj0li5NRciqNqeuOHKqAHwMJrhWxJc2QxmCAZaaNNXo5EvKF3Um+USyJcamyKPBbUHD4rQyOTk3pSSMLebDLPuz9k+dnWlyFH1Wb0zmU012qtjpy8pd9C/dGzAerelWWppVCIeCdaZD6K2uKAtrc+VL/KuuviS0GE2sDnsRzVSPG4BEUvI2SyYVd6jrBc5IZ1hWkCyAS9canXyOjPOtQRdij7ZDPxMFibOkViQyN8QjfBZEQ5vTGxkc5rJlSOIOCscaM8V49UfpyaknLTPASlWdDBJooW/ygH3I9+SqdmPaak8bhubqBwGPMxDu+Km4E6AzXLsksTvPzc+KX5rOwB3uZGyUlRL69V9pcxYgzWLojEm5kg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 02:21, Balbir Singh wrote:
> Recent changes exposed a BUG in remove_migration_pmd() where the
> migration entry was being overridden when the folio is device private.
> 
> Use scope local entry for creating the device private pmde. Make the
> pmde writable if the migration entry is writable by moving the check
> is_migration_write() prior to creating the device private entry.
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
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   mm/huge_memory.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9dda8c48daca..df93768a6e15 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4698,7 +4698,12 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>   	folio_get(folio);
>   	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
>   
> +	if (is_writable_migration_entry(entry))
> +		pmde = pmd_mkwrite(pmde, vma);
> +
>   	if (folio_is_device_private(folio)) {
> +		swp_entry_t entry;
> +
>   		if (pmd_write(pmde))
>   			entry = make_writable_device_private_entry(
>   							page_to_pfn(new));
> @@ -4710,8 +4715,6 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>   
>   	if (pmd_swp_soft_dirty(*pvmw->pmd))
>   		pmde = pmd_mksoft_dirty(pmde);
> -	if (is_writable_migration_entry(entry))
> -		pmde = pmd_mkwrite(pmde, vma);
>   	if (pmd_swp_uffd_wp(*pvmw->pmd))
>   		pmde = pmd_mkuffd_wp(pmde);
>   	if (!is_migration_entry_young(entry))

There are more problems here: you cannot call pmd_mksoft_dirty() etc on 
something that is not a present pmd! We have pmd_swp_mksoft_dirty() and 
friends for that.

So you'll have to completely split both paths.

-- 
Cheers

David

