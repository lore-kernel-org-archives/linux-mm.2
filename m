Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2862FFCB61B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933686B00A0; Fri,  6 Mar 2026 10:44:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B0C6B00A2; Fri,  6 Mar 2026 10:44:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A4B6B00A3; Fri,  6 Mar 2026 10:44:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B45A6B00A0
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:44:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2413A140614
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:44:20 +0000 (UTC)
X-FDA: 84516059880.25.F07E31B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 62B744000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:44:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPwvk7hY;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772811858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIwxDrFnlcYBpeh8ciPv7iyV+DIVmuhIWfboIKVpOiE=;
	b=WNpb7vGt88Qds256DpSfJGGz733OlltOxELHnPc+DKrGaAzNEbHRA+X+1HzpI5x8gKQbe5
	diQ7MfPLVdI2sG6CHEATtpJkCXZ0Irf5E7uuSmDYp3KshXc9OxghPy3UMrd6qDGCu4bqdJ
	dzZahHqIRSVmi9BlELxIjE0IYrnjZHs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPwvk7hY;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772811858; a=rsa-sha256;
	cv=none;
	b=WMLtZOuyW/aAb2mj2Cckckna1UKoL+Hgq8a4y2dkE1I6qSsRDK7vPVyLUBC+vtOYW2Bb3m
	yiCI6LPkudjykHS98IruPo+YXfkbAILEekZ3VVaBB3WH4sB13713OqYTgSqNg6NgOj4mxa
	ktqEo9kwZL/Fjt5PsTU555shrX4+Lpw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D15A960127;
	Fri,  6 Mar 2026 15:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042BFC2BC86;
	Fri,  6 Mar 2026 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772811857;
	bh=Irog342MSr8k0zPuW6pGzgfpJRPPfcyU46dDqhpUBU8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cPwvk7hYBURwasb7XgxxL1kr9EppTKvwp8HXAgsivHXKjqp75sTPHdGxFMqtH5GoC
	 KWahvwUXupdk0vP9+GXBHipHQQaevBgrSxRfLxtzes8UcuTMob+APPrkVxnMkQ43H4
	 pqYJhYjEEPC6KmAUY+xkMmbNui7Qj/X1BlHXLP7cxJoqraZdVLVMgU71DKUckL8hlD
	 U99gWs8Qztv8u3kD1L8S1yKRUESqYW3qiE3m5QVefWfGRMXRXb2kxyi5TOLk2Jh50O
	 s5ZJkDQL5uz7rygM1S6oeiYTyYKoEc7zKF2NvNddiKTezKxSMgVXGP1dArr2DxQVXv
	 OaWe1NzgWP/6A==
Message-ID: <81e7bd1c-54d5-4f88-969a-685177447c51@kernel.org>
Date: Fri, 6 Mar 2026 16:44:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/13] mm/page_vma_mapped: Add flag to
 page_vma_mapped_walk::flags to track device private pages
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-6-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-6-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 62B744000D
X-Stat-Signature: e9rgow3b3coxt8stn9icutga7ko3sm9t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772811858-196479
X-HE-Meta: U2FsdGVkX1/tpTJ+wE3bVfvfDZWRJhqNlGpoGcQuKoOFGJ5sWmqg/RRb+4kVrYDN70BZFXbVleNbTChZ8M5dEaVfvhGMQotnVYeHNUD32D93sgmWqyjnvj4KpESZS9phS4XjlwzaB6GfiE99jseXZXRSOyGXbqNQ/57mV2hLMmQPk7jZ++VVjfnICu5gyj0/Tr6AKd8YEYEKmDzCt7+/SuJuvKlipwBbP9hcq9vYUIsM3xY/YaPIOAkq0UXFXxK2ba3JXwLIwzGatXv2AlWP6RBDBOXu2avaiyCSdKyz+8wJZO7tdFZgbRDEUjpDcCgvZWrb1GRQ6Yf3QAD50a9uuuVj3L3NDntAGRZL1bmmq+dn5nlbjTFR5SqiYtzN/eFDcaXy/tJ3HOuX4vkjpyyWJUUCtBnjHU0Hcga5vRPPVDsVsPY0ojy29ZSL0eQTVGDvoN9C0VBSbQlKaouWyIRpZJHbpVwczskxgGhex18puFdOnJ2EPtgzaNqCvfjCXO9N0wig3oRBndUwTSC6aS2KemW8hILWeBDNKObRqDDFyo/ZhJ0SuMwvV+dXvEq6vjOhYa4VktZI9X/uoR6gegBonHwVO3G7mJwWJRKFoXEYZNEjshPy/UI0AoLdWW84yNeUEr8DRtdSZMKDK1AE8Ep22zPkOmr+Jj7uC5zy6s0tDc468j0MV2+BO9yQwmvzbks1MkMOy+RgMC+/PAslIBErtRuxIAjEgxq434/thHXlLIP3jFBY6qu4Unks1oAnhxRf/YWFYTbBfyCJKWLEGEYE0HkPm1u3CSjSCPj45ykPTca243xkKTJZgOt5DRZ+0ab9ch+aDuEMTbEldsLllEdSovfVsCdtAFulJSUuFHQ/9RK/g++ZKTCKutcMv7hn9h3Ih5flQujsUUV+rOU1c6SI4NpWwgJE17e7alp4vjpqm9oxXoxX03cKH2zhMKHR65MsKe7Pf0bK230MuDo2MCN
 T8D7gXeu
 hVB5hDe+NQZcnZHsIsixxXKrEiqGviSC6PbS4AXouRimGfKuGdUD8WaQVUVbAjyw2fLM+Yy2l9tIwSy9UEIQVm8tQkWEsjDRYjL1Vq7f1jVkiZXjxu6bCLPDTFM7UzTRzwmr8xd/fUCfpxkEifbCn4kwa02Tos2HR4ttRyA2fu1cReFsHTilRH2U5osxc3T2Lmj/+6t2ZWjDWUuBi2u41As5oHxH/SKJaWelZi5AozrT8267hpX3E8uvz+4lIc/p/lAk3Z3O3JQa746nNyvwnJqqTUNHQeUlt1f3ZIY6vC9dcJ+xN4ZG7LghHlM1MWOVNUjbIo5LFxpkvBbc4o81iNSrTa3oUyrvPrXACsGXZO0RhB9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal PFN and must be handled separately.
> 
> Prepare for this by adding a PVMW_DEVICE_PRIVATE flag to
> page_vma_mapped_walk::flags. This indicates that
> page_vma_mapped_walk::pfn contains a device private offset rather than a
> normal pfn.
> 
> Once the device private pages are removed from the physical address
> space this flag will be used to ensure a device private offset is
> returned.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
> v1:
>   - Update for HMM huge page support
> v2:
>   - Move adding device_private param to check_pmd() until final patch
> v3:
>   - Track device private offset in pvmw::flags instead of pvmw::pfn
> v4:
>   - No change
> ---
>  include/linux/rmap.h | 24 ++++++++++++++++++++++--
>  mm/page_vma_mapped.c |  4 ++--
>  mm/rmap.c            |  4 ++--
>  mm/vmscan.c          |  2 +-
>  4 files changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d..1b03297f13dc 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -921,6 +921,8 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>  #define PVMW_SYNC		(1 << 0)
>  /* Look for migration entries rather than present PTEs */
>  #define PVMW_MIGRATION		(1 << 1)
> +/* pvmw::pfn is a device private offset */
> +#define PVMW_DEVICE_PRIVATE	(1 << 2)
>  
>  /* Result flags */
>  
> @@ -939,14 +941,32 @@ struct page_vma_mapped_walk {
>  	unsigned int flags;
>  };
>  
> +static inline unsigned long page_vma_walk_flags(const struct folio *folio,
> +						unsigned long flags)
> +{
> +	if (folio_is_device_private(folio))
> +		return flags | PVMW_DEVICE_PRIVATE;
> +	return flags;
> +}
> +
> +static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
> +{
> +	return folio_pfn(folio);
> +}
> +
> +static inline struct folio *page_vma_walk_pfn_to_folio(struct page_vma_mapped_walk *pvmw)
> +{
> +	return pfn_folio(pvmw->pfn);
> +}
> +
>  #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
>  	struct page_vma_mapped_walk name = {				\
> -		.pfn = folio_pfn(_folio),				\
> +		.pfn = folio_page_vma_walk_pfn(_folio),			\
>  		.nr_pages = folio_nr_pages(_folio),			\
>  		.pgoff = folio_pgoff(_folio),				\
>  		.vma = _vma,						\
>  		.address = _address,					\
> -		.flags = _flags,					\
> +		.flags = page_vma_walk_flags(_folio, _flags),		\
>  	}

That's all rather horrible ...


I was asking myself recently, why something that is called
"page_vma_mapped_walk" consume a pfn. It's just a horrible interface.


* DEFINE_FOLIO_VMA_WALK() users obviously receive a folio.
* mm/migrate_device.c just abuses page_vma_mapped_walk() to make
  set_pmd_migration_entry() work. But we have a folio.
* page_mapped_in_vma() has a page/folio.

mapping_wrprotect_range_one() and pfn_mkclean_range() are the real
issues. They all end up calling page_vma_mkclean_one(), which does not
operate on pages/folios.

Ideally, the odd pfn case would use it's own simplified infrastructure.


So, could we simply add a folio+page pointer in case we have one, and
use that one if set, leaving leaving the pfn unset?

Then, the pfn would only be set for the
mapping_wrprotect_range_one/pfn_mkclean_range case. I don't think
device-private folios would ever have to mess with that.


Then, you just always have a folio+page and don't even have to worry
about the pfn?


-- 
Cheers,

David

