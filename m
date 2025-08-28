Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E09A9CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA3D8E0022; Thu, 28 Aug 2025 10:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B028E0006; Thu, 28 Aug 2025 10:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8648E0022; Thu, 28 Aug 2025 10:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD178E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:26:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE1A2139175
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:26:51 +0000 (UTC)
X-FDA: 83826392622.30.59D179D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EF490180011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:26:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7kEKCt2;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756391210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7JaIyagrf5JVviam1SOhX4lrDrgcjZOjGrswLCcS44=;
	b=8b5gbv4q5ZHoXahYLMt5o2LMHo8vcZHRzopUa4mHmRQP04TPYh2eWbDKhpi5KzvR2R3ki6
	Dv3k1mjXWINVvgHYWvUNifSvNiad9h8MDnEC8bHbAmLh71XCzeULJgh4SkX8N8iBUzGRMg
	zSSWe3v4Swwv0EPd5wH/LdJlZvqCsVc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7kEKCt2;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756391210; a=rsa-sha256;
	cv=none;
	b=cuJ+RY01aWm6uX1WJuFBYxEIEDzjoSScFVR90819wRH3WfAYe8vrBFGgm/uJoOKCpH1AnT
	4K/qBSgsBf5BkdK+K5Ndh2ZrGzh78OhMs5UoSe44JUbsqx5p94vrY3GMqenxs0S9JQMYqn
	evaPIwkKZWE7m4oQX8QomOkHhuoXiA4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB28A4085E;
	Thu, 28 Aug 2025 14:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BB8C4CEF5;
	Thu, 28 Aug 2025 14:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391208;
	bh=p5P8kAChBoN4WOlr76oijnY83blpFKG+JTaA6cgwwtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c7kEKCt2emu8+T6n7qTfSORifJVoKQh2kg28pFXSWr0eYZyb/w6+Pb4ykjBXYLmm9
	 97jHgUVhwZWTzkgi/woAxVcFRSqNt76KPpYDjEo/EUHeq+X7Or7nKTgZZb078U0ARQ
	 no/xsYpiTG0WZghM96EE7TUKcqUIvqG8ZqxE6LONBXzI1oEaB9ZSsCRi7YWonu52OK
	 mYiGeIi4SmfWeptkTfY28Z5aL5e89Ptp3Wk4NECmiBSY/evwNnIG9qPCfRMJj6YBEZ
	 6xmANqqFEBrWPu+TgH7qlb/qozJe2OIv7rCaHx2IOvLG89vU7gWDeCHQGwDqPHiGPU
	 Ijmj0CkpirSdg==
Date: Thu, 28 Aug 2025 17:26:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "david@redhat.com" <david@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <aLBnHwUN74ErKVjX@kernel.org>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
 <20250828093902.2719-4-roypat@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828093902.2719-4-roypat@amazon.co.uk>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EF490180011
X-Stat-Signature: 3xs8wz6dgux99osr7fxpotm8pw57p8xc
X-Rspam-User: 
X-HE-Tag: 1756391209-386366
X-HE-Meta: U2FsdGVkX1+yfBM/1cAwCfCRLPKnE9QAM29dEI/s3VK8DeZspTSKDOUhngRD5soGdyN4IB9vBx8lT6dqB064IbZ34QKiGf+R7SYr07GPCRBfkEsY7kqcqFEQGUR1IFPW/EkSjgB0ohn4L04FAa2+nI0g/1HL/FSQjiv0y+QTgAma3uJNKdr7GXO4K9esvAMtcLf6/RuDLS+wHL2VxfxOOEju8AfXWAJVDfQe86zLfZqV1l3nsPPQhH4Dqx1Vvu+iiMzbb5I8k4u7ElDYI1eQfaa9/fHbtSOmw94jChJWz4mnSI5E4BqL80qRm4WLf0kpT0Y9VMLL9vHZUCrBrhd6C3EHr6yiihRC3ABPVM+Qv8gaTKRvUPxoCK0AwCBUDL/qhbCuguvhi/14+CK4Nu84pkHjSXPQiywffvIBGZUNpDaF3QpIxS0R/Kei26VqE1zQoYY7bqXDSUPZdKPDCbuPd6E8X/kr5jbKhI3cZ1DDjpwzxtTNOwaCNwQk6QIp77E3AbPj/BuORhtJaaCNt3bG7E9NunekaOxtJSQWGsIQbbrN15SRwa3hXTGwZ8c+xOAjxFgUK4KHggWtiGeOsm6/67ZugBJWecUACW4vr2jLnSDns+mO4YPV9I/SASUmb3bVx+nrCmOnRUfidFz2/D5ko9rilCK16BUT5m1O+CgAUjJUUhzU/mgiTA9KunrqBhFFk/a85EsDqx0Bly9Kfsqylyst2Ua9GzYefOMPkBFr2+UPe3YCm0Grgkc1qNOZ4UuYjIOOUv5Tfx7+id62zy6g9TPtExiRO0qCuU486svvnh05PJPx9DuciV7fJ7A0wLlJ1Mv1/61QgQjlR13cyTPisNomwCKdi7vEFn2PqJKt8BkLCrUjsywg/ZnRV27KpEuNM+s2oV4k7KPojfI2Lq+qVhmVnkq3Yg8pqZHNfzi8+sj5wGaheNe8PHBwfSxPqu7zqsCm1Oi6kiuoZ57c11/
 whmq9Eoo
 t6X5cX4/KAxF1XcRNX1wm08CrVzIT2E32paBHO9wdBpLg1elujitnttUnJcdVv84W1mKvL90AAILYWS7pOtGCqCV+jkWyY6Yrc0Kj36VL3m3kUxT/23joy2nucYEOYFvpHX2vsdHOtV4e9brgDEhLKmH2Bam39ME04MBQdIyZMDK7v7PEgGzZxYDnTlMIKYBLra7BLULCLdAbHqDkarSkaburMi+GRuJdEagU2uspYPOuQrZHRU+g4AEUXGNAkC4I1PNiOfABv7qVhJRL4oZ4ZkckoIgU7ZYCgux8iHjrZgFw8fU5FYYOc6BWuQ7ejB0BW0BRRfBoyTTR/LaEbqMOJMJtHV5qIvc173/5WvYgB1prTMMKCzp1OI3f+2lIaHplLm7UUmysOocE5PjJqQJ/BhcgDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 09:39:19AM +0000, Roy, Patrick wrote:
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present . Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
> 
> This drops a optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.
> 
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  include/linux/pagemap.h   | 16 ++++++++++++++++
>  include/linux/secretmem.h | 18 ------------------
>  lib/buildid.c             |  4 ++--
>  mm/gup.c                  | 14 +++-----------
>  mm/mlock.c                |  2 +-
>  mm/secretmem.c            |  6 +-----
>  6 files changed, 23 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
> index e918f96881f5..0ae1fb057b3d 100644
> --- a/include/linux/secretmem.h
> +++ b/include/linux/secretmem.h
> @@ -4,28 +4,10 @@
>  
>  #ifdef CONFIG_SECRETMEM
>  
> -extern const struct address_space_operations secretmem_aops;

Please also make secretmem_aops static in mm/secretmem.c

> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -	return mapping->a_ops == &secretmem_aops;
> -}
> -

...

> diff --git a/mm/gup.c b/mm/gup.c
> index adffe663594d..8c988e076e5d 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1234,7 +1234,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>  	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>  		return -EOPNOTSUPP;
>  
> -	if (vma_is_secretmem(vma))
> +	if (vma_is_no_direct_map(vma))
>  		return -EFAULT;
>  
>  	if (write) {
> @@ -2751,7 +2751,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  {
>  	bool reject_file_backed = false;
>  	struct address_space *mapping;
> -	bool check_secretmem = false;
>  	unsigned long mapping_flags;
>  
>  	/*
> @@ -2763,14 +2762,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  		reject_file_backed = true;
>  
>  	/* We hold a folio reference, so we can safely access folio fields. */
> -
> -	/* secretmem folios are always order-0 folios. */
> -	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
> -		check_secretmem = true;
> -
> -	if (!reject_file_backed && !check_secretmem)
> -		return true;
> -
>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>  		return false;

There's a check for hugetlb after this and a comment there mentions
secretmem, please update that to "mapping with no direct map" or something
like that.

-- 
Sincerely yours,
Mike.

