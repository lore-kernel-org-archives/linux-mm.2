Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19ED7C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211186B0092; Thu, 30 Jul 2026 04:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1AB6B0093; Thu, 30 Jul 2026 04:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B13F6B0095; Thu, 30 Jul 2026 04:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9B196B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:23:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 636E8A0903
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:23:30 +0000 (UTC)
X-FDA: 85044753780.08.21BB85C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 77E43120004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:23:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dha0F2uH;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785399808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNnkodnVzSlZXSO/UwXnKiX/1FHyOcbnvHyWtcjIaHs=;
	b=u5ERE/VovLlLlXlaKeRkGv5pFB2zBnkf5phtzIYbvlYoCRJyltIVVeUMFKHPYX7FF40R6i
	AynsQfJjRr7vOcx7dHNQP/zgeA1TmMkwocfBrIz9cmkUAjM4E805AHayzlEqod3s4RD0tJ
	eVb5UGJVCxhFxxW4hQVxakBJt96uV6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785399808;
	b=8P2rK1TtNhG/+surV0/La2xnrN75LiC9UTKGbusLFcnJ9xLVJLqRgxpkNZ6T+4lWTrVdTj
	EZGklMC2WX5ZA359FLiauYvB1QX4+/IJoFk14xFWzJq54/jX5MFQT1HXDll2f9edqK8SsI
	ocaZCrcsTmZSJ5HGLBIliElkIb2ypLs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dha0F2uH;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83C33600B0;
	Thu, 30 Jul 2026 08:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0061F000E9;
	Thu, 30 Jul 2026 08:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785399807;
	bh=yNnkodnVzSlZXSO/UwXnKiX/1FHyOcbnvHyWtcjIaHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dha0F2uHJjBI8ozpAttF6VGOnFKi5ONE6v7CaGZ8oayuwX3B/M3sAvCtsddp7CMjD
	 pZDi6tsF5sZ+jvCTS5sW/fiCUnc8GqsmvlgUj459039yOuVWfaIkanXg42vBJe6Ds7
	 bgodgbA0uMZ4Hvo2Z0toh3LsAHSU2aIKCNOznO43PXcPEQRVEObERVf33nP8HHoh86
	 4Wylo/lHHshCbj24VdQIoP3cNpF2e9QgkZmRIcZZMDNEMYc6GwMlDbmcD9EKaFotC6
	 U9e2AtiYKNAWdiRMtPQb5LWKFaWgsVSNpmAGv3jNEArs7wcP487KOLavSQdZ59M1mm
	 Dx/sLB4en+kOQ==
Date: Thu, 30 Jul 2026 09:23:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Baoquan He <baoquan.he@linux.dev>, Pratyush Yadav <pratyush@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Simona Vetter <simona.vetter@ffwll.ch>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Dave Young <ruirui.yang@linux.dev>, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, kexec@lists.infradead.org, 
	driver-core@lists.linux.dev
Subject: Re: [PATCH v2 1/3] mm: Add unmap_mapping_file() helper
Message-ID: <amsDgehckDyv9BPg@lucifer>
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
 <20260725210549.3716546-2-kwilczynski@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260725210549.3716546-2-kwilczynski@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77E43120004
X-Stat-Signature: qm814st63qfdgyr9goiw5j7s34ujqif6
X-Rspam-User: 
X-HE-Tag: 1785399808-766287
X-HE-Meta: U2FsdGVkX1+yqavTH/mC2C0J6YiFN0JhA897FY1zta9dUmMH9CnFtEz609ND5vr3RIA/Ey1hkQw8bGWMxDJWc4brngXHQa/rmtTyV+OW84bQEBd6fYBgfqAgL1ryWiKSjT68zRUdowXDDEz4isM4CoA+aqssGsJf1r7febf6V85EDvMBBV1RRtHnjjPpdWOUR2602efJjLkCNX83ZigtSn8mxJR5rAt3VYRCMpQjC9M8KkACruRvPHv3Ru2wnjYVilSffpIFVT4sst/q36cNpW7zV+53XPRMs8wZafey1mCr0gfqxDqSBa7xo26frmz14TWhp2Q749MrfQGydEIKIadheqM7Q1WbgYf0mEMaNfJbTBFzzyOXWaHUdhB4Eq+usRkhds9SZdNroCkEgLbaVBWodPQGLLT9MJbd5iMa0XnfzubcaeQxZ2R3eBd6Uf+KCRj/RHK5dkoyLZqnDklQS2qmizNbj/xXJTg3486mOeTn5P2qyv919pgw1fvPhyMneUVhvAY/0N+Rms5SotWhiWfGxhM8ciOMfmi3XttHpU5PfJXJG23Nda90c53sIyQqrohs0IJrzv/st1ZCdswfCp+WQQ6UKpjaOWI8/XGAgP6EkoHyuz3c4gYbiLJr49lUGw2av5CM23nAqXp58Jj6eSY9HUN7Gi4EqPmkJ61hU/jRdrLfRiC7Vf8dUKm6TuC8oYyT1rbThuuFmP9FupHp5eNYnRsrJlsk07ohmNfOWjdd9HoHX5/NzsKRyFsQVdTaPU0bsToqSPwf2YSElV06oK291TZtKygp7jlDfSyUCQPOkPpKFhhRVrx1/qGvWFu9PUV7Xxcw47hCmOO9syhKnuPiJ0wmT59e3L49R8vlAtxzOOfVPXulgPhjZtfr01d0J5Hfer3rnZqRUiA2qfEzS6obg6USjz4pfqJOgMeGVSeo5mjP1K4FHIap2eoXec0N796BFIMugBzQYI8WmtY
 leBmli+8
 ObwsyzK0doaulBgCWKQ4YATNICWiEXFdtIcBF/th2Wp7uaqIPMtK2op9HclIGF1PfS+vVkqWnFessGV0xbz6lYDncWmSM1ZnUJFowPRlkcDgn+kicvruN6UUF2kq+GcP1S2TYerJUyP+9KGKkE2yrfM9N+STjI0q4vd4KMF101zS92aMC/X551e2S0nP+xG6mnW27WsT1ZkB1qcGPJM0y7JekoSKzOsQb5sn73FWLv4qgylPJeKz5a79csI7yMN7FxXZrbxtg6J9v9E0GpGfqNpBB47L8UbPpYxfaRvbyG7awgwML8PPMZzMrjtOtsww9n0GcfQD/AwZ6avy4inITJfzoVf8hFYu4bbeI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 09:05:47PM +0000, Krzysztof Wilczyński wrote:
> Currently, unmap_mapping_pages() and unmap_mapping_range() unmap a
> page offset window of an address_space, and code that removes a file,
> such as kernfs_drain_open_files(), relies on them to unmap the pages
> of a file that is going away.
>
> Files with f_mapping swapped to a shared address space at open time,
> such as PCI resource files using iomem_get_mapping(), have their VMAs
> attached to the shared mapping instead of the file's own inode mapping,
> so unmapping the inode's address space cannot reach them, and they stay
> live after the file is removed.  These VMAs can only be selected by the
> struct file they were created through, which is recorded in
> vma->vm_file.

I'm confused about what the issue is here.

- file->f_mapping is swapped out at f_ops->open time -> shared mapping
- Mapping here gets you folios that have folio->mapping == iomem_inode's
  mapping
- /dev/port goes away and...?

Is it that /dev/port going away then potentially zaps stuff it shouldn't or
doesn't zap what it should?

Be good to clarify all this and add a specific example also.

>
> Thus, add unmap_mapping_file(), which walks the VMA interval tree of the

Now mapping interval tree, been renamed as per David.

> file's f_mapping under i_mmap_lock_read() and unmaps the pages of the
> VMAs selected by should_zap_file_vma(), using the same per-VMA zap as
> unmap_mapping_pages().  When f_mapping is the file's own inode mapping,
> every VMA is zapped, as unmap_mapping_range() does today.  When f_mapping
> was swapped, only the VMAs with vm_file set to that file are zapped, so
> callers do not need to tell the two apart.

This is really confusing, so I think serious levels of clarity are needed
here.

Also is this intended to replace kernfs

>
> HugeTLB VMAs are skipped with a WARN_ON_ONCE(), as zapping those takes
> i_mmap_rwsem for write in hugetlb_zap_begin() and would deadlock against
> the read lock held over the walk.

This kind of insane 'swapping' would never happen on such mappings anyway
right?

>
> Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..e882a03eaddd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3183,6 +3183,7 @@ extern int fixup_user_fault(struct mm_struct *mm,
>  			    bool *unlocked);
>  void unmap_mapping_pages(struct address_space *mapping,
>  		pgoff_t start, pgoff_t nr, bool even_cows);
> +void unmap_mapping_file(struct file *file);
>  void unmap_mapping_range(struct address_space *mapping,
>  		loff_t const holebegin, loff_t const holelen, int even_cows);
>  #else
> @@ -3203,6 +3204,7 @@ static inline int fixup_user_fault(struct mm_struct *mm, unsigned long address,
>  }
>  static inline void unmap_mapping_pages(struct address_space *mapping,
>  		pgoff_t start, pgoff_t nr, bool even_cows) { }
> +static inline void unmap_mapping_file(struct file *file) { }
>  static inline void unmap_mapping_range(struct address_space *mapping,
>  		loff_t const holebegin, loff_t const holelen, int even_cows) { }
>  #endif
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..4a09d7b6aa6b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4423,6 +4423,54 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
>  }
>  EXPORT_SYMBOL_GPL(unmap_mapping_pages);
>
> +static inline bool should_zap_file_vma(struct file *file,

s/inline//

> +				       struct vm_area_struct *vma)
> +{
> +	/* On the file's own inode mapping, zap every VMA */
> +	if (file->f_mapping == file_inode(file)->i_mapping)
> +		return true;
> +
> +	/* A swapped mapping also holds VMAs of unrelated files, zap only ours */

I'd be careful about saying 'swapped' here :) for obvious confusion in mm
reasons.

But I'd actually explain clearly that file->f_mapping can be changed at
f_ops->open time and thus

> +	return vma->vm_file == file;
> +}
> +
> +/**
> + * unmap_mapping_file() - Unmap folios from all mmaps of a file.
> + * @file: The file to unmap.
> + *
> + * Unmap the folios of @file from every process that has them mapped.
> + *
> + * If f_mapping is the file's own inode mapping, they are unmapped
> + * from every VMA on that mapping, as unmap_mapping_range() would do.
> + *
> + * However, if f_mapping was swapped to a different address space at

Same comment on swapped...

> + * open time, only the VMAs with vm_file set to @file are considered,
> + * since that address space also holds mappings of unrelated files.
> + *
> + * Must not be used on HugeTLB files.  HugeTLB VMAs are skipped with
> + * a warning.

Couldn't you just catch this at the top with the gloriously named
is_file_hugepages()?

	if (WARN_ON_ONCE(is_file_hugepages(file)))
		return;

I'm not sure who's supposed to call this though, if it's literally anybody
including core mm that might want to unmap a hugetlbfs file maybe you'd
just take the write lock in this cae?

But probably better to be conservative first I guess.

> + */
> +void unmap_mapping_file(struct file *file)
> +{
> +	struct address_space *mapping = file->f_mapping;
> +	struct vm_area_struct *vma;
> +
> +	i_mmap_lock_read(mapping);
> +	if (unlikely(mapping_mapped(mapping))) {

(nitty)

I kinda hate mapping_mapped(mapping) as a thing, should have commented
about that on that patch, but then again what could it be :) naming is hard.

Anyway be nicer as a guard clause I think e.g.:

	i_mmap_lock_read(mapping);
	if (likely(!mapping_mapped(mapping)))
		goto out;

	...

out:
	i_mmap_unlock_read(mapping);

> +		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {

As David mentions this is now renamed to mapping_rmap_tree_foreach().

> +			cond_resched();
> +
> +			if (!should_zap_file_vma(file, vma))
> +				continue;
> +			/* Zapping HugeTLB VMAs needs i_mmap_rwsem held for write */

See above about file check.

> +			if (WARN_ON_ONCE(is_vm_hugetlb_page(vma)))

> +				continue;
> +			zap_vma(vma);
> +		}
> +	}
> +	i_mmap_unlock_read(mapping);
> +}
> +
>  /**
>   * unmap_mapping_range - unmap the portion of all mmaps in the specified
>   * address_space corresponding to the specified byte range in the underlying
> --
> 2.55.0
>

Thanks, Lorenzo

