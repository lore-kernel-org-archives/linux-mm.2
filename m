Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C8CCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 03:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20966B00DC; Thu,  7 May 2026 23:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD13C6B00DE; Thu,  7 May 2026 23:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7106B00E0; Thu,  7 May 2026 23:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCD646B00DC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:36:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A3731406C0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 03:36:40 +0000 (UTC)
X-FDA: 84742840560.14.E7204E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0091D14000A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 03:36:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jwX37HAx;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778211398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eo4LakyV0Nn1IZ/s/US9gdZyvf8efV7TWtETIX/GEos=;
	b=rKrjK4HUm2acG6z/uIXlCKZSxsKlzXHnjVPrHtX8LAfVgik/wr+OUpkIrvApcqZZXqRCg9
	ysOvhvVGeWTkqPAJBQpFBIr9OIMsN5KXqlPXhilOqZisoNWvq3T9VWOxwa1p36SkzbF2kU
	UbYJycfzcIRybl+Eab07vgTOIJ1sYMU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jwX37HAx;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778211398; a=rsa-sha256;
	cv=none;
	b=I2OeW8vt/KVMDCQYuUFnbSGRoM8WjpwkVfb+PCM2BAeucsvi9o+n2cEcAYJXrvFCjKVFI9
	Eid2BqPcAwbL9CholM6aQ48HHwCFWUnWQ9gWQvrJiK4B1+5u4RABnGbEm57Q2XLqoKOvGa
	kxH+i39+Lw23w8sq/piBKYKEZX6l7Dk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E8AE3583;
	Thu,  7 May 2026 20:36:31 -0700 (PDT)
Received: from [10.164.148.34] (MacBook-Pro.blr.arm.com [10.164.148.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 705BB3F7B4;
	Thu,  7 May 2026 20:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778211396; bh=mk4Lt8wh0ylDn1xADLunA5G8XPgmpv6UrFPataLZ3NE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jwX37HAxvI7KY4wcwGMXkIN55CFUD0B+yZyN3ei7dQdjOQy6VaibWx9PFMaet/dcL
	 jyXnoanUT4poVTeg+lsPbZc1qFrqaTjePr6pVzyYovnTusPpYQVMxqmhuS9uv77FQk
	 z/MwQqR8VREONf37XuxV//3Q6kDgERBb3J8loFWo=
Message-ID: <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
Date: Fri, 8 May 2026 09:06:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org
References: <cover.1778192416.git.mst@redhat.com>
 <96a2f5a938bf65315ac95e75b4e7741bae018cdd.1778192416.git.mst@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <96a2f5a938bf65315ac95e75b4e7741bae018cdd.1778192416.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6mysxzsz5rt94togfadquictshp3fs46
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0091D14000A
X-Rspam-User: 
X-HE-Tag: 1778211397-13503
X-HE-Meta: U2FsdGVkX19MQmxugg/k/4Sih8V/Txca2zmYdiLTY3UCclod267diagLK6f1FRtwqXIiaHbzZzB8w91vks9eaFr+KMaGhvhMmbwGBRHm2S7rGkj15FuCLADtBXhP4GZNCe+mNAAlBiqZCe3GCGgbil0GXZCf73asDp2YLIuYC+3Obq46XYmcM1jlQX/lUeb4T6mNQ4ot99JT8GHKBRRodHgYRNAqdIJIh4uvjA21IgPEKKfMcHgJ7IXaEhsjxvoFSSXm/gqOFCb6HKF2EtdKdoN1AiO3LZJWo0kltVC/RmA7PevP4i0LWF4X/ugSyfNw8GTCs2U1U+hgWSclAR6AKyb8qxtUdIQ3JobkkHFr00t935RSmCG6ukJbEoQAgBn8LEEKVqqPPKQSvbGMIZ9T20b7V2Q9FW5yR+i4HODQoPojpqZpQWDo03b4ZYpx7moyN9EdYCDWnLJtUhQbHBQ1fijKaX8kQlx0uhEeODE3NGf6lDxwM39w0guffj3EfXuOo6HhaCN/vh5og5U/DRaWirCMgRKVSkHezjyN9dB2MkD4QJ6/V3aGljCX/4sYA1JTOl/ug6MElXHx/EMegI0ZdnEGUZ2ubX281F1yRrkKzgZGd8Y+jro8qYW72O/9YiFpkMeApheP8VB0LSKIDbrzseN+EGLJaw7xDG3HqKNLSgDPTwQQzCU/r0cLkj6B/k/Z9aDzBKZjnUi2k/hn5y9kUHq8YOhrCfQisQMqfY++MGRla4rFAgh6bPGjQDvoHttAra6uruBETDvVPzcWpG8m+R5NgXt/f6uzwPsF2L+gD1sMAWtZECH0cQqz0+RGg9zpRDlbZ9RP58fAvjWnJQFmXs9jzvyacMvsVVFBlIM3G5nDG2G5zhhmgkpsjWt6aQ/NdPa/H7OGFB9iXo6oX9emuuFpga8naU2WDNUP6ebT2SQ2VximSPAV2viBuYADpLCkVn4UGr8orkmNzjtG92q
 eM3OmZJz
 Edgd8a+/HE8DSW9ZXMyKDBOrCR5I36of46+InTZwg+8UOMd2gk1fv8CrjaXx45oSJP4AJHf4DXS9yIaKpfcZQKiMtzKvpOGjS4Ej6uS64sAqnVzDBZ2I8ihcdAKni/GI3YLoRDKkssdqoKqUYbHGEBjxXetjmqiq/Ow4UDonJnEe23sMqFToLJ0mka57OWM6Inpe9eLv9P2dl3rN8G6/SBEudPK8Z2TQMkH9yC6ALgN8+AUqfQLkR58BA/rYchRDak6rQ5om0qxTv+eaj5GkKEZVgmlAMtSRxR+TqRRyVws4LGoAMGNbFr0tYjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/05/26 3:52 am, Michael S. Tsirkin wrote:
> Now that vma_alloc_folio aligns the address internally, drop the
> redundant HPAGE_PMD_MASK alignment at the callsite.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Hello Michael,

Could you please send the whole patchset or at least the cover letter
too, to everyone CCed on at least one patch? I only got two patches
from the patchset in my inbox so I have no context :)

>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e2746ea74ad..f51c0841ce91 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1260,7 +1260,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>  	const int order = HPAGE_PMD_ORDER;
>  	struct folio *folio;
>  
> -	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
> +	folio = vma_alloc_folio(gfp, order, vma, addr);
>  
>  	if (unlikely(!folio)) {
>  		count_vm_event(THP_FAULT_FALLBACK);


