Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3AD2F506D9
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336966B02C7; Mon, 16 Mar 2026 10:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4E06B02C8; Mon, 16 Mar 2026 10:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCCB6B02C9; Mon, 16 Mar 2026 10:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 059A96B02C7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:52:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9AE9139FED
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:52:01 +0000 (UTC)
X-FDA: 84552216042.29.E2ECD98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 08A86180006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:51:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tSLnPF1F;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773672720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpksEdxY9oQ6JN80m750ax4PtMoi0haCKsF/4lQ7uL4=;
	b=H7/tqqC1+sYQ52kaTQ7nxpwnTelCyL5NWOh73Jy/3FPCWnFSLNwCKZ2wzYV4PPLclccm9O
	ZgmvszJHfn8OByj9gn3goYNiQ28wxkH3VLDXahuyLlXoCSk+/1svqjLAeFMVZ+IfTrhXWK
	Re0zXiUJJLZ0B0mGFEkOD3uvEtw2r1g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tSLnPF1F;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773672720; a=rsa-sha256;
	cv=none;
	b=LcCskAmmw0jTCaHaUcThFd25LvF6i7Wfcg2n52QICS3S+F0NIULEKE9h0MOOQtMRloChdM
	fDzl9A8nkE5QUE6aAtmqx2swoKLTfaUmsP5QCxAVwSEPsjx1jph20fC+qciklD5z/gLoeL
	LEu9vgvwmdsb5k6Vovj4DZGxXHhcsoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2896260123;
	Mon, 16 Mar 2026 14:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB72C19421;
	Mon, 16 Mar 2026 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773672718;
	bh=KIRMkEs2ki4Q4dp6M/GOhb93ujwUaNLq8lzChwMmjn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tSLnPF1FQGukX0jNpyUPpw39RNpf5reYLO7x3EfolXRfSyklFjmya7iBIUL9cYR6P
	 03ZQOFOVkIRw02GeRSmaaZYbqDhPig/hYez6AG/QQcB6PIpP1NgYdwb2UyqLlLW8iw
	 xUqt4NFyQEpDdvNYzd7D140Zjk7FrDTOTJkLe0vutUmzUAeVv2IEcNlfeMcAvkPVaM
	 JQNf8HpqT3Lstxvxat/f9kXEENmcKZ8Ntab7TkVbAmfxGz8pl03oD9b+QUUc8+zciP
	 F7uXVlaQGF7zb+pS6vO6CMdBKRn645sD50BB1GRswzWJvFb4E88gqDAtEdIxjhTHlA
	 ZD/322/wk5nBA==
Date: Mon, 16 Mar 2026 14:51:47 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 02/15] mm: add documentation for the mmap_prepare file
 operation callback
Message-ID: <0eeb2bcb-3ee1-47cf-a5ee-45eb0038ec67@lucifer.local>
References: <cover.1773346620.git.ljs@kernel.org>
 <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
 <f0e33b51-d465-462d-b0f6-98a1db66bb15@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e33b51-d465-462d-b0f6-98a1db66bb15@infradead.org>
X-Rspamd-Queue-Id: 08A86180006
X-Rspamd-Server: rspam07
X-Stat-Signature: 9qbnwadu9xmemskerwyrowusg1myx7aj
X-Rspam-User: 
X-HE-Tag: 1773672719-499187
X-HE-Meta: U2FsdGVkX1/eYb6Q2RhwO4layTd2CXxWX5K3t+691ZgiWe66iKviysnjOz4SfPV1mXvciKXIML9WY6cpyt3X3JeiKYIRMto1t/b+pIrT3GLTvG94RaLNB4+/rp0gQxuLE7JzsDuqQpBoMrojFk22KBKEsUSxhZt9D3CKIrt/sjDi6p5Y3a6nXLjxZngLr41U4Rt0RsCEldaDPQ1N8bRYHSnccV/N26NEPrxs/FiOL++ve1MeCK7oY6KE3H6q2bZjl9pzYKkpk/coyucq5ZhOJlCvdGWj6cghb+MhEa3Q6vqoPN8Te5XPspE1A8cfwmXfW545D14v1An6CaISli0Ww0EVr80YJTa/QD3VI7zdZD5sO/Cep/n0TIFrJXIZJd8Xe1Zga88cIUMdQ5UVtJpItcLzvvuQqCQSwYs3nYskUkiP4Rzk8CLJ0+zmSo00DNfnVOqn/zSP7A+AuGywuXGq7xVcE7et91FQugARc8NesTsnxTVWdSdz+/57gHZnWHbkbAnCZezn9PXKM6VxAoYt+YpgDfys88NUvmH9bGzvX5zzjiMfkqupmC554UR4sP34jw81IBsW892FB/YvryQa7i2fV9c8vfORNWnDzSJ5Ww2W42q3K7hL0BV0BJ1UqIP4gNDwhvPkvok07uastyTj0EcV/75XDiI7UHee1zhQgHDIsrV3F9wsjRpwX5th7rv7yoA3gSE0DCp5JeCBbYIviJ8BI907dar5DrZDxENGwiT8uC2/HIi5p6TOve/mvaBdMwNOdzr5dzIHUZoeyB7mkTKxur4QUMuR5d7h95BqMhn5xaj0XPjtIdZhqgSJsqpWGeRlQgPjbwljq62LoD1zLX5W1VfN9NkC71+Q3uiYd6h+1jYp56biplpMf8xI8RBo+JxJdNIcRRRYpKRv3Dta5EkhNKViXrPnw8WeOUVItEMGR5kgrI6eV46TiItq6PMTyeNWYvYRy/zynGMjfLW
 w5PjlyNj
 55AqaC1g5RRaAqLHr8lVVxxVrwT3FkX7sV35yjb4VYmImHpfEklU9Ve7FK+1eUsqYBeELnr4dXTUlKwMsxdrUB0bhRwnZhSimNgDYrAqnZD+f8NR8GMz83Ddi1lu3HhgDVFp6PmlvE0BYQ2W+5CKa4RjaVo5vGgLZn18WBl5aWaI3O+seczjAWPKibkGJI4MD9Op6SsvQGzylLbqtYYn84aMEx1U2y+hgqElMmQGrqlblj9QupXEzMoway7oKUPt2KrhFt7Dc84bzL+U5VlfQrFdl07CkeCGC9R8Z/tmU9myytyUh9wG56jKnNm/apXMxeEZLFhdXVnqdNcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 05:12:04PM -0700, Randy Dunlap wrote:
> (Andrew: patch attached)
>
>
> On 3/12/26 1:27 PM, Lorenzo Stoakes (Oracle) wrote:
>
> Documentation/filesystems/mmap_prepare.rst: WARNING: document isn't included in any toctree [toc.not_included]
>
> Should be in some index.rst file. In filesystems I suppose.

Ack thanks.

>
> > ---
> >  Documentation/filesystems/mmap_prepare.rst | 131 +++++++++++++++++++++
> >  1 file changed, 131 insertions(+)
> >  create mode 100644 Documentation/filesystems/mmap_prepare.rst
> >
> > diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
> > new file mode 100644
> > index 000000000000..76908200f3a1
> > --- /dev/null
> > +++ b/Documentation/filesystems/mmap_prepare.rst
> > @@ -0,0 +1,131 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +===========================
> > +mmap_prepare callback HOWTO
> > +===========================
> > +
> > +Introduction
> > +############
>
> Kernel style is "=============" above instead of "############".

Ack

>
> > +
> > +The `struct file->f_op->mmap()` callback has been deprecated as it is both a
> > +stability and security risk, and doesn't always permit the merging of adjacent
> > +mappings resulting in unnecessary memory fragmentation.
> > +
> > +It has been replaced with the `file->f_op->mmap_prepare()` callback which solves
> > +these problems.
> > +
> > +## How To Use
> > +
> > +In your driver's `struct file_operations` struct, specify an `mmap_prepare`
> > +callback rather than an `mmap` one, e.g. for ext4:
> > +
> > +
> > +.. code-block:: C
> > +
> > +    const struct file_operations ext4_file_operations = {
> > +        ...
> > +        .mmap_prepare    = ext4_file_mmap_prepare,
> > +    };
> > +
> > +This has a signature of `int (*mmap_prepare)(struct vm_area_desc *)`.
> > +
> > +Examining the `struct vm_area_desc` type:
> > +
> > +.. code-block:: C
> > +
> > +    struct vm_area_desc {
> > +        /* Immutable state. */
> > +        const struct mm_struct *const mm;
> > +        struct file *const file; /* May vary from vm_file in stacked callers. */
> > +        unsigned long start;
> > +        unsigned long end;
> > +
> > +        /* Mutable fields. Populated with initial state. */
> > +        pgoff_t pgoff;
> > +        struct file *vm_file;
> > +        vma_flags_t vma_flags;
> > +        pgprot_t page_prot;
> > +
> > +        /* Write-only fields. */
> > +        const struct vm_operations_struct *vm_ops;
> > +        void *private_data;
> > +
> > +        /* Take further action? */
> > +        struct mmap_action action;
> > +    };
> > +
> > +This is straightforward - you have all the fields you need to set up the
> > +mapping, and you can update the mutable and writable fields, for instance:
> > +
> > +.. code-block:: Cw
>
>    .. code-block:: C
>
> Documentation/filesystems/mmap_prepare.rst:60: WARNING: Pygments lexer name 'Cw' is not known [misc.highlighting_failure]
>
> Maybe a typo?

Yeah is a typo thanks!

>
> > +
> > +    static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
> > +    {
> > +        int ret;
> > +        struct file *file = desc->file;
> > +        struct inode *inode = file->f_mapping->host;
> > +
> > +        ...
> > +
> > +        file_accessed(file);
> > +        if (IS_DAX(file_inode(file))) {
> > +            desc->vm_ops = &ext4_dax_vm_ops;
> > +            vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
> > +        } else {
> > +            desc->vm_ops = &ext4_file_vm_ops;
> > +        }
> > +        return 0;
> > +    }
> > +
> > +Importantly, you no longer have to dance around with reference counts or locks
> > +when updating these fields - __you can simply go ahead and change them__.
> > +
> > +Everything is taken care of by the mapping code.
> > +
> > +VMA Flags
> > +=========
>
> and then use "---------------" here instead of "==============".

Ack

>
> (from Documentation/doc-guide/sphinx.rst)
>
> > +
> > +Along with `mmap_prepare`, VMA flags have undergone an overhaul. Where before
> > +you would invoke one of `vm_flags_init()`, `vm_flags_reset()`, `vm_flags_set()`,
> > +`vm_flags_clear()`, and `vm_flags_mod()` to modify flags (and to have the
> > +locking done correctly for you, this is no longer necessary.
> > +
> > +Also, the legacy approach of specifying VMA flags via `VM_READ`, `VM_WRITE`,
> > +etc. - i.e. using a `VM_xxx` macro has changed too.
> > +
> > +When implementing `mmap_prepare()`, reference flags by their bit number, defined
> > +as a `VMA_xxx_BIT` macro, e.g. `VMA_READ_BIT`, `VMA_WRITE_BIT` etc., and use one
> > +of (where `desc` is a pointer to `struct vma_area_desc`):
> > +
> > +* `vma_desc_test_flags(desc, ...)` - Specify a comma-separated list of flags you
> > +  wish to test for (whether _any_ are set), e.g. - `vma_desc_test_flags(desc,
> > +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)` - returns `true` if either are set,
> > +  otherwise `false`.
> > +* `vma_desc_set_flags(desc, ...)` - Update the VMA descriptor flags to set
> > +  additional flags specified by a comma-separated list,
> > +  e.g. - `vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)`.
> > +* `vma_desc_clear_flags(desc, ...)` - Update the VMA descriptor flags to clear
> > +  flags specified by a comma-separated list, e.g. - `vma_desc_clear_flags(desc,
> > +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`.
> > +
> > +Actions
> > +=======
> > +
> > +You can now very easily have actions be performed upon a mapping once set up by
> > +utilising simple helper functions invoked upon the `struct vm_area_desc`
> > +pointer. These are:
> > +
> > +* `mmap_action_remap()` - Remaps a range consisting only of PFNs for a specific
> > +  range starting a virtual address and PFN number of a set size.
> > +
> > +* `mmap_action_remap_full()` - Same as `mmap_action_remap()`, only remaps the
> > +  entire mapping from `start_pfn` onward.
> > +
> > +* `mmap_action_ioremap()` - Same as `mmap_action_remap()`, only performs an I/O
> > +  remap.
> > +
> > +* `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, only remaps
> > +  the entire mapping from `start_pfn` onward.
> > +
> > +**NOTE:** The 'action' field should never normally be manipulated directly,
> > +rather you ought to use one of these helpers.
>
> I also see this warning, but I don't know what it is referring to:
>
> Documentation/filesystems/mmap_prepare.rst:132: ERROR: Anonymous hyperlink mismatch: 1 references but 0 targets.
> See "backrefs" attribute for IDs. [docutils]
>
> (OK, I found/fixed that also.)
>
> There are also lots of single ` marks which mean italics. I thought those were
> not what was intended, so I changed (most of) them to `` marks, which means
> "code block / monospace". I can fix those if needed.
>
> from the patch file:
> @Lorenzo: ISTR that you prefer explicit quoting on structs and
> functions. I didn't do that here since kernel automarkup does that,
> but if you prefer, I can redo the patch with those changes.

The issue was in another document it didn't seem to properly recognise the types
AFAICT (but I might have been mistaken anyway!) But I'm fine without.

>
> HTH.
> --
> ~Randy

Thanks for this, will fold the patch into the respin also!

Cheers, Lorenzo

