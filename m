Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24785CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844D38E001A; Mon, 17 Nov 2025 06:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C598E0002; Mon, 17 Nov 2025 06:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759718E001A; Mon, 17 Nov 2025 06:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 668E28E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:04:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28F4A160D2F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:04:27 +0000 (UTC)
X-FDA: 84119815374.23.570DEDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CF331C0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:04:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L0k3QEKi;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763377465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DN802ksBnrqB+PCZ/mLlzCfyvO2R+PrmSUbbyDL1eN4=;
	b=Wv+OE1hJ/pL70TTL+BQFyRgjzW4gitbiH4onfwfuOk+X5QlVoIwVT/wVpZLeoJeIfgz1TI
	SElYzqjHXWxztaYs32VQRfVNYab3sGvl20GBgKVWzFSil0jkrpp6hj+z2l37xeyGV8pgHL
	6F0cQcjRt5dwu8oyycPUTKrdqnApuzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763377465; a=rsa-sha256;
	cv=none;
	b=p8x5Blg8XfO3ezwuyFVNbyg0zufBft6WkNl+VDWm0jwGFebzPVKSRVJtgcQ8rZENr7BB0N
	36kIVnbMICc3Qtp1adyQDrB6NQDMSy97FTxDZtMc/axFiTZhCqZMIysnnF3T63nv8MP0Hp
	wQapmM710HcHBr9nX2Dats5lKnAPw3w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L0k3QEKi;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39B95435AD;
	Mon, 17 Nov 2025 11:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E08C4CEF5;
	Mon, 17 Nov 2025 11:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763377464;
	bh=WWE3t7I3SF3DlAE8BdmFrmCS1M/rFEV0vnSNWTBc5tM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L0k3QEKiD+rh0bxxX4fVCaTPVujvmto8tLg1+BtAac2R9g3v1tykJEAkfem0Pb348
	 5J7cMEYG97oQY/jmtHQL4hq0YWVyu9sjQ+bamnEw24il8JGqUNljNbi2tNf1SE8M1o
	 7kIb025ro7tzRhVKkfhrdWEt81mbmyXnC92DQCJfsIuoZ8JOBHVNmGYkW/+mcu+44H
	 vlDwPn8Ru9Iwj+/+x4jmCovyEDM6GMzKw5WJR2gC21oZNSZMie6FbcjuKvoCZqs1zS
	 vNI33MsNbl0wbkQ3l3Ms5VR1t1pU7GIybR5Pnkqj3TfEUhoojMKF9MbrI6OEw9HmVl
	 BTlC8ggjtSRNQ==
Date: Mon, 17 Nov 2025 13:03:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 15/20] mm: memfd_luo: allow preserving memfd
Message-ID: <aRsBHy5aQ_Ypyy9r@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-16-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-16-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CF331C0006
X-Stat-Signature: i3r1kgx5qo3p3bbrgrm6cnyqec97q9tm
X-HE-Tag: 1763377465-52723
X-HE-Meta: U2FsdGVkX1/9iuhCHwLtOrykJAhBR5aiRl6FtarIUIAWP5fkinHIww2COliDiz+GG9UIpbe7ZqVtw8ytbIqn75VghS6E16icd/UOGz5MoxAEFMf6UNQFQDgBgTSiD1QqaCJmcurjjzA7O3E/TRLeyY+t6jylZ3ddX0dQqfsnR52oMI7VVVIqj99fQ1qcOXdp7uwTatiZZXpmtbYa7zDOLb5YeFTxQiAZN7ZDnHLBJDqm1DI78AMYQpABb3n+BGa9orh7jNjbPnUhvRnQ91FAGqlc54MnwE8X4jY0dpmrk/c6l6+l7uYhcb/kG70fkunTevgNToeY+0x4gbaDxNwito/EPBP0b99TatC6ROrECQ0nrF3VlmQuF5WSNg/EXKOvvuRa1Ez/HQg6fWOLGzUqkBezpMC8nx8NlOfMgZ8c+S2ufYd1US/h1hD0HXINBIXWAe6ZrsBo0tlLZ9G5F63DrNutleXrkC7bs1WlTuEbcIYOVv0i0jhxUOyXv9/mZAtM3E1RVy1h9tKU2tMzR7+0U9BOTMIxi//sLwxT9QZKSZMjpsQNWD9UD4UNlq7Fq+RxWnA6/pg/b8mNfEZp0S++xfPmsgZaJYSXivBdTCj759N1u9yYmoytpSfsrHXvp+sJ1sncIOU/8usXk3pMoGI23IBvBA+vHXrlNDGlVwN/UATTI7a1aRJDdytTE2bv10TzQc4VAksbumIyrB7kEIAO4ev+5/Hr7TzsyArmPL0OS4D5aQRy5Vypg/nOP/cMRWYT8DuXlMpSJ4QSjUjT2uVJlrUsCSNxdBHKbyZpRBXM4yml4mCQqU+ADQ2OiAykBpBIPoXzvd7Q2t5iEHrX7LvM0pOwitFbJrVGekbUsCy/NehbukOvV/szRFzlkTf0M1wVvvpdOqQRe2iTuDaryA4lckhunYYfbbe5w134ExP97gwWKJtkiYY0EeFEOxZIEZHHmzsahNVUoLoWgFf4LWi
 HEdjW1cW
 XR7yLgBr1o/fLvZnFD9REjch8FhkPifaOT83trJR6ydy4mcxrHrfCASEMzE+4dA+2mb84N/3kaPLsof11KRsz0t91Ex5cH3Rq6teHJGzIXONcLi75GDYGYdVrnk2i+uR3TQ6yIvPTqYDroj740E5i1tbmBEX6w1u3WRwVtdAxiDvwtHAZk+k+2MMA9Ka0t+WKvCReo04qtDH12eVpqfBWQHKH8GTz7KK6fAPZeSpscPqsgWQlnDf2Xxj/AwwC8vmAgIkYn0NXTyGgVUAcSJh0hiKCnbdUQcasJGRfUXNuX9yz9yhUxo9pl7QqFJw0/lxqYnkpGKMpOqSmAp0Po+NkuFQC302JNFkFiBYy5U8FlUA71HIGEl74hrCIHmCRRrpNhIwoD8eZBmUiA4W7/XAaAX+CUDk2m3O5+uoEUJx8Mowo3ErB3+F+yBW02sMtlohKIzJrRC62+n0wEao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:34:01PM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> The ability to preserve a memfd allows userspace to use KHO and LUO to
> transfer its memory contents to the next kernel. This is useful in many
> ways. For one, it can be used with IOMMUFD as the backing store for
> IOMMU page tables. Preserving IOMMUFD is essential for performing a
> hypervisor live update with passthrough devices. memfd support provides
> the first building block for making that possible.
> 
> For another, applications with a large amount of memory that takes time
> to reconstruct, reboots to consume kernel upgrades can be very
> expensive. memfd with LUO gives those applications reboot-persistent
> memory that they can use to quickly save and reconstruct that state.
> 
> While memfd is backed by either hugetlbfs or shmem, currently only
> support on shmem is added. To be more precise, support for anonymous
> shmem files is added.
> 
> The handover to the next kernel is not transparent. All the properties
> of the file are not preserved; only its memory contents, position, and
> size. The recreated file gets the UID and GID of the task doing the
> restore, and the task's cgroup gets charged with the memory.
> 
> Once preserved, the file cannot grow or shrink, and all its pages are
> pinned to avoid migrations and swapping. The file can still be read from
> or written to.
> 
> Use vmalloc to get the buffer to hold the folios, and preserve
> it using kho_preserve_vmalloc(). This doesn't have the size limit.
> 
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>

The order of signed-offs seems wrong, Pasha's should be the last one.

> ---

...

> +/**
> + * DOC: memfd Live Update ABI
> + *
> + * This header defines the ABI for preserving the state of a memfd across a
> + * kexec reboot using the LUO.
> + *
> + * The state is serialized into a Flattened Device Tree which is then handed
> + * over to the next kernel via the KHO mechanism. The FDT is passed as the
> + * opaque `data` handle in the file handler callbacks.
> + *
> + * This interface is a contract. Any modification to the FDT structure,
> + * node properties, compatible string, or the layout of the serialization
> + * structures defined here constitutes a breaking change. Such changes require
> + * incrementing the version number in the MEMFD_LUO_FH_COMPATIBLE string.

The same comment about contract as for the generic LUO documentation
applies here (https://lore.kernel.org/all/aRnG8wDSSAtkEI_z@kernel.org/)

> + *
> + * FDT Structure Overview:
> + *   The memfd state is contained within a single FDT with the following layout:

...

> +static struct memfd_luo_folio_ser *memfd_luo_preserve_folios(struct file *file, void *fdt,
> +							     u64 *nr_foliosp)
> +{

If we are already returning nr_folios by reference, we might do it for
memfd_luo_folio_ser as well and make the function return int.

> +	struct inode *inode = file_inode(file);
> +	struct memfd_luo_folio_ser *pfolios;
> +	struct kho_vmalloc *kho_vmalloc;
> +	unsigned int max_folios;
> +	long i, size, nr_pinned;
> +	struct folio **folios;

pfolios and folios read like the former is a pointer to latter.
I'd s/pfolios/folios_ser/

> +	int err = -EINVAL;
> +	pgoff_t offset;
> +	u64 nr_folios;

...

> +	kvfree(folios);
> +	*nr_foliosp = nr_folios;
> +	return pfolios;
> +
> +err_unpreserve:
> +	i--;
> +	for (; i >= 0; i--)

Maybe a single line

	for (--i; i >= 0; --i)

> +		kho_unpreserve_folio(folios[i]);
> +	vfree(pfolios);
> +err_unpin:
> +	unpin_folios(folios, nr_folios);
> +err_free_folios:
> +	kvfree(folios);
> +	return ERR_PTR(err);
> +}
> +
> +static void memfd_luo_unpreserve_folios(void *fdt, struct memfd_luo_folio_ser *pfolios,
> +					u64 nr_folios)
> +{
> +	struct kho_vmalloc *kho_vmalloc;
> +	long i;
> +
> +	if (!nr_folios)
> +		return;
> +
> +	kho_vmalloc = (struct kho_vmalloc *)fdt_getprop(fdt, 0, MEMFD_FDT_FOLIOS, NULL);
> +	/* The FDT was created by this kernel so expect it to be sane. */
> +	WARN_ON_ONCE(!kho_vmalloc);

The FDT won't have FOLIOS property if size was zero, will it?
I think that if we add kho_vmalloc handle to struct memfd_luo_private and
pass that around it will make things easier and simpler.

> +	kho_unpreserve_vmalloc(kho_vmalloc);
> +
> +	for (i = 0; i < nr_folios; i++) {
> +		const struct memfd_luo_folio_ser *pfolio = &pfolios[i];
> +		struct folio *folio;
> +
> +		if (!pfolio->foliodesc)
> +			continue;

How can this happen? Can pfolios be a sparse array?

> +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
> +
> +		kho_unpreserve_folio(folio);
> +		unpin_folio(folio);
> +	}
> +
> +	vfree(pfolios);
> +}

...

> +static void memfd_luo_finish(struct liveupdate_file_op_args *args)
> +{
> +	const struct memfd_luo_folio_ser *pfolios;
> +	struct folio *fdt_folio;
> +	const void *fdt;
> +	u64 nr_folios;
> +
> +	if (args->retrieved)
> +		return;
> +
> +	fdt_folio = memfd_luo_get_fdt(args->serialized_data);
> +	if (!fdt_folio) {
> +		pr_err("failed to restore memfd FDT\n");
> +		return;
> +	}
> +
> +	fdt = folio_address(fdt_folio);
> +
> +	pfolios = memfd_luo_fdt_folios(fdt, &nr_folios);
> +	if (!pfolios)
> +		goto out;
> +
> +	memfd_luo_discard_folios(pfolios, nr_folios);

Does not this free the actual folios that were supposed to be preserved?

> +	vfree(pfolios);
> +
> +out:
> +	folio_put(fdt_folio);
> +}

...

> +static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
> +{
> +	struct folio *fdt_folio;
> +	const u64 *pos, *size;
> +	struct file *file;
> +	int len, ret = 0;
> +	const void *fdt;
> +
> +	fdt_folio = memfd_luo_get_fdt(args->serialized_data);

Why do we need to kho_restore_folio() twice? Here and in
memfd_luo_finish()?

> +	if (!fdt_folio)
> +		return -ENOENT;
> +
> +	fdt = page_to_virt(folio_page(fdt_folio, 0));

folio_address()


-- 
Sincerely yours,
Mike.

