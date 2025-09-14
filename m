Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411F8CAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 08:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941078E0005; Sun, 14 Sep 2025 04:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919D08E0001; Sun, 14 Sep 2025 04:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8088C8E0005; Sun, 14 Sep 2025 04:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 664BB8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 04:12:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95757C025A
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:35:57 +0000 (UTC)
X-FDA: 83887046754.16.C0F2BF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 105E6C0004
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:35:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KKfr8C/P";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757835356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnlRCS+XXbWtUx/DVoshyFSiwdglv1XpdRpQgCTEGkk=;
	b=0QLNWEwjpKexQd7pxc8GtkHDXRaLtDN1PKjqyrvKuWueAez81pzet6NCZkAX7MntN7wlQ8
	vJRFm35FD3b8H2wv8MQpILzaCz/MB7BXLmxamklB6OiTMIrqfPNegiEO7mmL2ybPDVWP3n
	E0ZJxNF66dP6o2W5aOZ3aPLaffoYjAM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KKfr8C/P";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757835356; a=rsa-sha256;
	cv=none;
	b=fxPCuG1aWTPhjGcgVnZobsfttoqd89RSYGm30u+337Jniwp7oqCXvoTk1yQhquGqcOgaWd
	+yXkm8YC/PIC7WWICji0esM0HPUZR0s/Eotw3xkFxh6LcctUkBwCQ2Dc7HIt9VgpNiqx+K
	4/5UfuCsp+W35Pd4hljAK4X8fc678NU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E47960139;
	Sun, 14 Sep 2025 07:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99EBC4CEF1;
	Sun, 14 Sep 2025 07:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757835354;
	bh=vFnfGTkj5/KhQQ0QRoZ2pu4iIv0mM+KWgCa9F0xbdl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KKfr8C/PuOOvlqMXgt2nNqevFc6crDsLfQefigkMxEmHUQqKThFaSj7Kt7tgJN4Ql
	 tqwGBz8U9I31FemsXLNBesItokumnSgVNDEzsAQrwzbqWwJwnQIDazhbA1Q/3KP+VP
	 AQqh9YXlhPpv9/6VgKrt9NrHUMC2s8z6wl4SAPtpDk0BMTpCk+1VBM2F7dJPjMiCgx
	 sOI4Dv09T0ldqRZdEnwtXoIPVkkM09/pR0S7gXJwMOp2kmZ/LcHM4PYRqtqXpfzW6h
	 UcRqfaCUNbA3FMvl6sJbGdZ3ojqu1Nas1iYqlaPOanydB0APtSr/WcoEu4gvcaosEK
	 LUw3//H6uFjmQ==
Date: Sun, 14 Sep 2025 10:35:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "Thomson, Jack" <jackabt@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
	"willy@infradead.org" <willy@infradead.org>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"alex@ghiti.fr" <alex@ghiti.fr>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"gor@linux.ibm.com" <gor@linux.ibm.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"trondmy@kernel.org" <trondmy@kernel.org>,
	"anna@kernel.org" <anna@kernel.org>,
	"hubcap@omnibond.com" <hubcap@omnibond.com>,
	"martin@omnibond.com" <martin@omnibond.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>,
	"yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"devel@lists.orangefs.org" <devel@lists.orangefs.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v6 03/11] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <aMZwO8uR_JG3nr4X@kernel.org>
References: <20250912091708.17502-1-roypat@amazon.co.uk>
 <20250912091708.17502-4-roypat@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912091708.17502-4-roypat@amazon.co.uk>
X-Rspamd-Queue-Id: 105E6C0004
X-Rspamd-Server: rspam05
X-Stat-Signature: 938gfckx9snybaygw3q1o1jbjaeo451a
X-Rspam-User: 
X-HE-Tag: 1757835355-877541
X-HE-Meta: U2FsdGVkX190WVwujTA9DdqgslRs00XezZzb9JFVDjchIvN6fBfGXM5AV7wxbUrr8QpJ89tGv0gMKdHKKjkIYop3Y0bEPrLpJE9TOW8H5mWHCPVjClqZ3tlRMmH6e/dy2giUMXwBi/eZFwWuaIXYPSZvNsmFtg+UKgzhawYBupywffquBg8itSxD41qgPk/dG8UK0f9q/AObRjyFXfj724Ifcoi+GfBPOceviY9f3fUaapEsOvgMkTto9gsASJxh9g3Nbo+N62GaN4/foeY2arvMYxdkAV0rh2FXWeBzSzKdIlG86T+cxQI63Jc6ejW/Bjr1DCbelqvJsbu5FM3sXcP2NUCLCGsjeTqf3nMciWIvB3ZoJGZZaFb+8iHB8qNdsVyohzUN3ir3Efxdx3Cj1MRjWQeQ20E33NuU7LF22CqbGc2zNlLO++4FTeVCBN5M+xnJ1u5Xkz9ZTzNOwlgNyXtH9MKoWUsCiE0DCnVabxpCnm/xYYC2o9qsn84dfJURTqMHvDqDsmWktT5+gGDcf5UKaEkiUjdKzZDbK7kSXjOWoS5RvrLc6Zut8TG1oLtPfxeoooa08N6B/yCBWEPER7zi9f4OMxfvzei0gDnKVngVTbA15lbYSXtO95/i0bQ2WxfvgIXIv0tgnAom/pvD1YQs9KnKXxmJvydzKDc5R4M4U4jiGS3VHClwHmHB2CsjRDxOC6jaFY+Mzmr+//Pk6eEvK2wQznkHq5SUGjKS5peTP+BSPpJfEVuwbcszoaGKKyuYMmJmVwZCXAbXkFNDFDY1+hbCWpnYhji0t0DSxuoOxJpsFQSascGilKJII3Uc3dBk9mBLWcVhiequSXw+HtJju3phgXSu7dQXrR+rb6YhPKtxiCMZmpGaU+4NDN4aRsrUsDd6xjAenY2C0SAAJYfCIzBTSKCMq1lZso/grd/N3KEu8xePO68pk7CNeg+u4LO0wYFZ+xnOabkDU8O
 IBRQcCg5
 5sV5vg8EX61Pxrr/N8hC1Ps0csTOrA0yGN37S9Xf5yeMG90Oat3xAMkn8umXZctI2le0y7y1iEoZ3L5XIM+W2zZRSV5xINd39ht8Mjx1o0iFUrtc/xsHuS39Kp4nV7RIz1kLwDv8/U2LS5aYuv8wI0DQRuiU3mo/Rvf6lWuF5H4auR120ugKm2UNLl1vA0ABZopojQ1jvOeNQi65FBFI6BVfpl1NTDHEHMMV637/94oNzHpJlr/oaVXqllnoDeAR4nM+F10MQ5Z0I8CToF97+iLnSXAvzy068rKSEatqX9j6zwB+SCt3X97Y3uuAh3bLKnnZ9+grMDjduzftOdEd93S+ieIGFESDqwTFZSyJzDHSPNtczqeSlPmlOlgqv1OwLtf0b1+2enN4DGRfg1wbcQgtrMEIijHAcQ5RqB2USj/62wJmEie9ClTegoF8Wc9F0oI9FZH90AuzkbuK6TAg++0ornTMJ1p+5j/v+nuD7/KhoVR8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 09:17:34AM +0000, Roy, Patrick wrote:
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/pagemap.h   | 16 ++++++++++++++++
>  include/linux/secretmem.h | 18 ------------------
>  lib/buildid.c             |  4 ++--
>  mm/gup.c                  | 19 +++++--------------
>  mm/mlock.c                |  2 +-
>  mm/secretmem.c            |  8 ++------
>  6 files changed, 26 insertions(+), 41 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 12a12dae727d..1f5739f6a9f5 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -211,6 +211,7 @@ enum mapping_flags {
>  				   folio contents */
>  	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> +	AS_NO_DIRECT_MAP = 10,	/* Folios in the mapping are not in the direct map */
>  	/* Bits 16-25 are used for FOLIO_ORDER */
>  	AS_FOLIO_ORDER_BITS = 5,
>  	AS_FOLIO_ORDER_MIN = 16,
> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
>  	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>  
> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> +{
> +	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_direct_map(const struct address_space *mapping)
> +{
> +	return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> +}
> +
> +static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)
> +{
> +	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> +}
> +
>  static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
>  {
>  	return mapping->gfp_mask;
> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
> index e918f96881f5..0ae1fb057b3d 100644
> --- a/include/linux/secretmem.h
> +++ b/include/linux/secretmem.h
> @@ -4,28 +4,10 @@
>  
>  #ifdef CONFIG_SECRETMEM
>  
> -extern const struct address_space_operations secretmem_aops;
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -	return mapping->a_ops == &secretmem_aops;
> -}
> -
> -bool vma_is_secretmem(struct vm_area_struct *vma);
>  bool secretmem_active(void);
>  
>  #else
>  
> -static inline bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -	return false;
> -}
> -
> -static inline bool secretmem_mapping(struct address_space *mapping)
> -{
> -	return false;
> -}
> -
>  static inline bool secretmem_active(void)
>  {
>  	return false;
> diff --git a/lib/buildid.c b/lib/buildid.c
> index c4b0f376fb34..89e567954284 100644
> --- a/lib/buildid.c
> +++ b/lib/buildid.c
> @@ -65,8 +65,8 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
>  
>  	freader_put_folio(r);
>  
> -	/* reject secretmem folios created with memfd_secret() */
> -	if (secretmem_mapping(r->file->f_mapping))
> +	/* reject folios without direct map entries (e.g. from memfd_secret() or guest_memfd()) */
> +	if (mapping_no_direct_map(r->file->f_mapping))
>  		return -EFAULT;
>  
>  	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
> diff --git a/mm/gup.c b/mm/gup.c
> index adffe663594d..75a0cffdf37d 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -11,7 +11,6 @@
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
>  #include <linux/swapops.h>
> -#include <linux/secretmem.h>
>  
>  #include <linux/sched/signal.h>
>  #include <linux/rwsem.h>
> @@ -1234,7 +1233,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
>  	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>  		return -EOPNOTSUPP;
>  
> -	if (vma_is_secretmem(vma))
> +	if (vma_has_no_direct_map(vma))
>  		return -EFAULT;
>  
>  	if (write) {
> @@ -2736,7 +2735,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>   * This call assumes the caller has pinned the folio, that the lowest page table
>   * level still points to this folio, and that interrupts have been disabled.
>   *
> - * GUP-fast must reject all secretmem folios.
> + * GUP-fast must reject all folios without direct map entries (such as secretmem).
>   *
>   * Writing to pinned file-backed dirty tracked folios is inherently problematic
>   * (see comment describing the writable_file_mapping_allowed() function). We
> @@ -2751,7 +2750,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  {
>  	bool reject_file_backed = false;
>  	struct address_space *mapping;
> -	bool check_secretmem = false;
>  	unsigned long mapping_flags;
>  
>  	/*
> @@ -2763,18 +2761,10 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
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
>  
> -	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
> +	/* hugetlb neither requires dirty-tracking nor can be without direct map. */
>  	if (folio_test_hugetlb(folio))
>  		return true;
>  
> @@ -2812,8 +2802,9 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	 * At this point, we know the mapping is non-null and points to an
>  	 * address_space object.
>  	 */
> -	if (check_secretmem && secretmem_mapping(mapping))
> +	if (mapping_no_direct_map(mapping))
>  		return false;
> +
>  	/* The only remaining allowed file system is shmem. */
>  	return !reject_file_backed || shmem_mapping(mapping);
>  }
> diff --git a/mm/mlock.c b/mm/mlock.c
> index a1d93ad33c6d..36f5e70faeb0 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  
>  	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
>  	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
> +	    vma_is_dax(vma) || vma_has_no_direct_map(vma) || (oldflags & VM_DROPPABLE))
>  		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>  		goto out;
>  
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 422dcaa32506..b5ce55079695 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -134,11 +134,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc *desc)
>  	return 0;
>  }
>  
> -bool vma_is_secretmem(struct vm_area_struct *vma)
> -{
> -	return vma->vm_ops == &secretmem_vm_ops;
> -}
> -
>  static const struct file_operations secretmem_fops = {
>  	.release	= secretmem_release,
>  	.mmap_prepare	= secretmem_mmap_prepare,
> @@ -157,7 +152,7 @@ static void secretmem_free_folio(struct address_space *mapping,
>  	folio_zero_segment(folio, 0, folio_size(folio));
>  }
>  
> -const struct address_space_operations secretmem_aops = {
> +static const struct address_space_operations secretmem_aops = {
>  	.dirty_folio	= noop_dirty_folio,
>  	.free_folio	= secretmem_free_folio,
>  	.migrate_folio	= secretmem_migrate_folio,
> @@ -206,6 +201,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>  
>  	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>  	mapping_set_unevictable(inode->i_mapping);
> +	mapping_set_no_direct_map(inode->i_mapping);
>  
>  	inode->i_op = &secretmem_iops;
>  	inode->i_mapping->a_ops = &secretmem_aops;
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

