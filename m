Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF506606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mRvrOOSg
Received: by kanga.kvack.org (Postfix)
	id E32896B0777; Tue, 27 Oct 2026 10:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3596B0779; Tue, 27 Oct 2026 10:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9CF6B077A; Tue, 27 Oct 2026 10:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC9916B0777
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:06:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4235A40A0B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:06:40 +0000 (UTC)
X-FDA: 85368581760.22.FA5D6E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 690FF18000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:06:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRvrOOSg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0u2sU8fv44IdbL2rqY0zsZ1MwMIHXr4E88UCvKAQ3oM=;
	b=re9UKNFX0UCIQ0Wq2NrI1c+NgmIsvkvlzg/5hi1mt2TOU1ZPtV67XRC116mwHzUjgbv5Ej
	ddTxbOzZPjQcGqa+mQKeOoBPcQraWIpXOt4BALBwuse1r0ZLADue+SuYRQYOU/gPMF17KI
	UAVD1yikBatSO02WS4WnCbk+2GY43LQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRvrOOSg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109998;
	b=SVhJKuLsOI0ubHFvTYUvK0PlrHX5mkq+o7+AJ0j2KqVQheZWO1AkRuc0cEonnKwS66GiZs
	YeebNkYKXVgUVY8iRMwEuQkuwf9WfBQU6czWH/IMwirdz6jJINkT5uFdwbR394apdOQgv+
	c440hQ0ikiztNY9Ms18CH9FoUGzVNOE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E7AD43AE8;
	Tue, 27 Oct 2026 14:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514D71F031E2;
	Tue, 27 Oct 2026 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793109997;
	bh=0u2sU8fv44IdbL2rqY0zsZ1MwMIHXr4E88UCvKAQ3oM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mRvrOOSgjdCxSfV4CAfO4tcpSYh41Pg239SgUcuSZUYgDaOyxgFlV9PNmIOHYL3CY
	 vYJpvkL2efCTKqHIF1P4wYdt6XqrEXQvriF8RDuiBsDmOaO34s4R1pOzoXPqgy5EFW
	 oqr8aS1elll1K1kIDHAob5wlCH9DQSfr3ci3chP/VixwQWTJu2mOUpEaCUBqIrW3Ws
	 5oBukZ1Sk3iKPkTBncIMPFXOXwlTOVC4yzKYDE1uQcvAXFGQgzTBFYMrc57XOMIjXk
	 wMyjsU4YHDRuXRBP325OoyDoIIL6DWgVK7Wa9XeCxEOomeVBKfNeVQ9HyUQjDHkDTT
	 ZEG0Tkbfp7qdg==
Message-ID: <97aa3a39-3b39-4d8c-8e99-d58a059aca92@kernel.org>
Date: Tue, 27 Oct 2026 15:06:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 690FF18000A
X-Stat-Signature: r6e1f3fxa8akkym4kcgsc8tpmz5fnmbp
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793109998-934011
X-HE-Meta: U2FsdGVkX19sflsOdUZi/YCNLHrDCv1aIdJiXlJE6p/cEWqAPQu6Q/YSMeHPPuy49gchlRD7Bc59NmvilamRnmDRGOLd6woCnDAoKqyMAVcImsdmH3v4I2pj0E3pSeoB4kJ5kvFXi/skmqQU3WhTcybGKNloRbJ7xwFwAkEBBUxNhkr2fz3Nyq6MhlTyzMHKWRJsWfEibhOgyUk/Jx5sjQc/UoiZkuZe+GXAeuW/RZTiZFX0Y90O9ihbn/PC34fO2cIr2fMqH7fyLj9ty3riijieYH0bHeWRM6q1Vow7j67Pe1icybH5t5fCWQyq6rxRxI5JR/E7lcwYTXla4bB2fh2pMhjCkZYDS8i1JpM7AMXoV4+3PC72KQSWQhgfsRPXTXFoUPd370eFPI1TRESWJx+eJDtoFcttxZXSjd+cpwVc36et1OxHqOPoM2ZgvBftfIUx7+ONkzqEFl9uwXMSV7w5HkII+bcm72Y8gi8L4RE9JTH9DhHlnlDrwqiVZPPl5CjORVnp+bmhb5tc9y17TH+9PC/m2VILNMvNGpITAMpx2isoxXmb40jRKZtqcPTnQb6R4UgzPcaSTw5lUt3WAmpO3Vsy2Rc+W031FWBF60ocfo3t7QxP6QNYu6YU6QPNwNra96WVj5SACr/HlYBtJJa4fffhDifRNJw7CFG+9+J8uG1AAXfxWHVGDamF82LJC+yTSjwvvqKRDxQHwIXZM0De9bpsste2COMhENL7ftbGwWfe2MPEfpZFOUIvYpIOJ5YVNFA2BRK+6dPh4Cz299IdeAqoASdbu42GX5uGK7vm5w5YFlu2L6xROQCkEPecFBLXpl7nWSDOEpA573SpvGb54g1cK6Wil3lxpvORp3RSw+LfBEh3KI5sZaEQDn085ThT/9i6/po00R+uQwbDu18QFoOaSVcIXEfz346iZD9LnB4Az3LlicTJzSCFfUlsd+DfFBqfGpqnf1cbijJ
 TJuA/1/v
 kLEzTr5WalmZO/SJF+MOhgXy23tTqyonGPpWmswvX4A+iOUpNB8/D/AtiO2OFcsPFnGS+egMOUIlKelrBxltGf6cYiVMN1mKx+AB5hXkBwHpL0O+e9AFKWzYWhYb+X5tU+bE6BUjZ8qvgA0wxSFk/3fyVdicppLH7YqthMzaPCSeP4KS+nfsavzSD/s+bNNp3TM1+vQa+jK8LuzlVomk9vxIYXSVAS81DPvRWp51fsZHk27xVsw9pMXKM168p5QOi7vLGjhk5K+JkT4oBwk6Gn/HurSKrGidb6a3CLPEohWIkCvE0M5GHPH1uOWpyRvexa2ODT6DWwTgIACmJfQpHYcIRDYyNJIMiFEEw6hW/6kuwHIDtcopgG2HCppWjMvMXZnPjsYa/IVwV4Xvdso2vjMCCz0z51DPD3nWuuXPHJiP4XMz/vPbst++LImjko5V/oVSRj4dhy21fhrcYn+19uHC5mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 22:36, Konstantin Khorenko wrote:
> folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
> __folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
> PTE mappings to the folio instead of one PMD mapping. Each unmap of the
> PMD removes one PMD mapping:
> 
> - the folio's mapcount never returns to zero, and removing the folio
>   from the page cache reports "Bad page cache", or hits a VM_BUG_ON
>   with CONFIG_DEBUG_VM;
> - the first unmap already counts as the last one and drops the
>   PMD-mapped statistics while the other mm still maps the folio;
> - the second one drives the entire mapcount below zero and drops them
>   again.
> 
> The helper has no caller yet, the next patch adds the first one. Pass
> PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.
> 
> Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  include/linux/rmap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 0b332770abeed..7562017416094 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -558,7 +558,7 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
>  		struct page *page, struct vm_area_struct *dst_vma)
>  {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PTE);
> +	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PMD);
>  #else
>  	WARN_ON_ONCE(true);
>  #endif
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

