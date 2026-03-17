Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AEBFFED9F6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CF96B00A2; Tue, 17 Mar 2026 13:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CBB6B00A3; Tue, 17 Mar 2026 13:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4B86B00A4; Tue, 17 Mar 2026 13:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA436B00A2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:49:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D45FA1C4E0
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:49:51 +0000 (UTC)
X-FDA: 84556292982.10.7022BCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1C04E100005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:49:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DgYf2ED6;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773769790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgcwuq7yJOBZLL22aLhDLV7sk1P74dqMGRnES9qXgEk=;
	b=W2IrVn2tSzudNfbedVn0NduJTN1GgI5LmbLZthIOweY0Ld4NRwngfpoWpqPLjhyFA9ItQI
	pSOg44uL6juh7JZ6quZ6NiKp4iWWWAIE+rcU4orUk739Ag9unSZQzBF7asAtIXIlnB9p/0
	MuC74AhzH0YZ+U8UGFbvG+4LuwjJVE8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DgYf2ED6;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773769790; a=rsa-sha256;
	cv=none;
	b=CJZQGQSz7HEIDyqd80BW6rD0lGJCxaD1tE/ORQkHCWMoPNu1rFvZ6x4WgNF0OCAayaRoF5
	wN4ietLviAwxyzzr0RpQOllGqSxYYYDI3vFi8aPr0Jjgh8REkxMkvBecsYyV8Yu57x7VOp
	7QATM5tV1TUj+2Mkw99ICx54p2beblU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9D414326B;
	Tue, 17 Mar 2026 17:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FF5C4CEF7;
	Tue, 17 Mar 2026 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773769788;
	bh=9raS/7flhBB8OwQhQ4gASkXcC/85pn+Jci4JhvWANfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DgYf2ED6QD1WJ+wF8r91rGazHA0yK1ttXIt6EgYz/ua6lP49TQKs9tNT3lc66Z8pO
	 45gKll3wHvsc6O9VqDVQa9uZqKq4w5aUHQDbesOjd6jP09d7ogziHFouxypjZSpo0o
	 2wZpBvDckbvCLNZg7aVWL341chOXXdpGcYr4vmJRT2RKDUhU5+zbBzIPq1n3mVuluo
	 AeDMkpCFpKCaBFdpD+3b1x3W52Gjl0rWrzcCOjlux8F14oXL1DHBZK6u/ykghz1pYp
	 gRnffeSK5tTS+NsmIGd5fMIpUv7siOEr8D8bYSu2ymCA21XTVCYzAv77I2Iv+6Si2B
	 sTvLY98exQj1w==
Date: Tue, 17 Mar 2026 17:49:44 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 06/14] mm/bootmem_info: remove handling for
 !CONFIG_SPARSEMEM_VMEMMAP
Message-ID: <e0e1ad60-5901-44cd-b077-a0aa6924ebf4@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-7-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-7-david@kernel.org>
X-Stat-Signature: 73qtxdahssrjdqbnf1fjn6xz879z8bhh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C04E100005
X-HE-Tag: 1773769789-873011
X-HE-Meta: U2FsdGVkX18Wi4xQI61u+kMQU9y/2ygfUxE+XXlwFFvzcu4fLUt+y4030UKMPkq67FWDYIQ2VGqHmio53Md1NmuSmimTNRLrTplxIWhNniJbQLKB29r+prtD3ryKdHvzc37R24fpTQaUERUGxcEBgtMdYqBXQZqhz8Xi3P/Sfh/9M9ARopREcyNkKOju0FxhsMRPJMvQR8+0Y9XhWzgFcjD0AHM6MXLNEPNHxJUSx0z4NBST/PKkvOa6ki74LAlpYNTmPa1QVJKl6MrRamLZtpHPExl+8hp74r4k+7GwJtcxVTUeOMSyf2M9xTMj19JvL3oUkMLDM39PA+DXmQ4rYFp+u2sypbehEHloJ81pqAmTVcnpIF5X2+SEQ6Y6LwfIPdeXvUtmjJDGecHNBKO32TZ2+AG0qOhS3381tTggXh5ZbRrEjfVi22EfjQ2yCG/OXfGTP/MO+9/5DYCRm1LJIjSG+jKXg6Hm7+UoYtH7LKh32vpYQW02mzhytP6vl/MmlfAhTWHlWZazFjzyY6Uy4MVMBMFo7X7i6IwmTGHynVVYv4xw3HhwFYvII19XVd+act449Ht88BFMF5ecrFs0QoazjjEq/FzBoSsQqCJFGFYwcoAcpiGDU2yMgvX2MvW2FIAlxOFWBnOx6q5q6WCN40K8TrvPP2Jef7fnVSzA6mMp1+lIaHJFrBoycpqDMhUfXtubI2Ve+fi8t32JYMmC35ZCglmg8HLwZ5e3hMmsxY6lVVfM72iO0tFiHnayW/eAUp5aRMuFkJhl6uLo64Jj5LBzSuJrFmVDlPH7s6srdmgVLdrtip8S48pphN0fjrYJIGeKXq52NbCPMbbVJn3O60kzUF1t8+cYIqK3/eVO/3sPQwm2FmbFvd/tkwSFCeomNiVEpf0cuLw/zJeIK2LERF/aGWh0vZHpjRRRM0wVgkWkeyvDZje9rEaLoFPJ6xt//mLAss1oBzGHspfBzYd
 1xxLoZIF
 JpJgDj8KsuHa8enU7TfwQFEC1Y+28XdSmd7TufeSiVDS2xW2mL4gry5t5thWXEv37iOSKx/iPGP+VcvAsfRachwf5kUM8wG+ELG6XqzFJTRSY7HNJ7suZB6JqCAAM382Riyvo2JClEQeRYvYoyr+SCkUc0hReHpDb3+MSWa9Iy4M24dYFOGz4a5tLGMXCNPIb4kvaktJH/tTVkqOyFPPDXYMhgqgleIude7eIbGVYUvT/505VrRUEvuHMPD8I4sbX5Pd0JSl5CGS8h0Qg6O4DaJmfon9FUcebqAXzjXrcIp6JNGtK+3cxqkL6bwqLIJGMo4SCXfpHJj1zXBW5yYK7MeOtaN8elZHCGOj0CmakJhLQTbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:44PM +0100, David Hildenbrand (Arm) wrote:
> It is not immediately obvious that CONFIG_HAVE_BOOTMEM_INFO_NODE is
> only selected from CONFIG_MEMORY_HOTREMOVE, which itself depends on
> CONFIG_MEMORY_HOTPLUG that ... depends on CONFIG_SPARSEMEM_VMEMMAP.

Ugh god.

>
> Let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers.

Maybe worth explicitly saying 'dead code' here just to underline how stupid this
was...

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

This might be dead code, but this is a dead on patch, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/bootmem_info.c | 37 -------------------------------------
>  1 file changed, 37 deletions(-)
>
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index b0e2a9fa641f..e61e08e24924 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -40,42 +40,6 @@ void put_page_bootmem(struct page *page)
>  	}
>  }
>
> -#ifndef CONFIG_SPARSEMEM_VMEMMAP
> -static void __init register_page_bootmem_info_section(unsigned long start_pfn)
> -{
> -	unsigned long mapsize, section_nr, i;
> -	struct mem_section *ms;
> -	struct page *page, *memmap;
> -	struct mem_section_usage *usage;
> -
> -	section_nr = pfn_to_section_nr(start_pfn);
> -	ms = __nr_to_section(section_nr);
> -
> -	/* Get section's memmap address */
> -	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> -
> -	/*
> -	 * Get page for the memmap's phys address
> -	 * XXX: need more consideration for sparse_vmemmap...
> -	 */
> -	page = virt_to_page(memmap);
> -	mapsize = sizeof(struct page) * PAGES_PER_SECTION;
> -	mapsize = PAGE_ALIGN(mapsize) >> PAGE_SHIFT;
> -
> -	/* remember memmap's page */
> -	for (i = 0; i < mapsize; i++, page++)
> -		get_page_bootmem(section_nr, page, SECTION_INFO);
> -
> -	usage = ms->usage;
> -	page = virt_to_page(usage);
> -
> -	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
> -
> -	for (i = 0; i < mapsize; i++, page++)
> -		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
> -
> -}

So this was just dead code before? That's gross.

> -#else /* CONFIG_SPARSEMEM_VMEMMAP */
>  static void __init register_page_bootmem_info_section(unsigned long start_pfn)
>  {
>  	unsigned long mapsize, section_nr, i;
> @@ -100,7 +64,6 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
>  	for (i = 0; i < mapsize; i++, page++)
>  		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
>  }
> -#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
>
>  void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
>  {
> --
> 2.43.0
>

