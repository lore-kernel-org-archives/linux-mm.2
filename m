Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA53F53D8C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811216B0360; Mon, 16 Mar 2026 15:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB116B0362; Mon, 16 Mar 2026 15:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDA66B0363; Mon, 16 Mar 2026 15:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 536CB6B0360
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:17:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 093B9C1D76
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:17:11 +0000 (UTC)
X-FDA: 84552884262.18.73215FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5C49C180013
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:17:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p6V8nYcq;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXPTyI1h6YLGDNRh6IFFqsQpxH22cI7smUznlmS4dSA=;
	b=yim9zXPrm3WspXT1AQLVu5+B1bJ105SIeNnmlVU4kHIx45+32FFqDObEfhqXzGJTSt2oAW
	O99u0sEsZ9ErV1BOnvnUevylvvK4riopA3WkYomCMGrkHxLQxZwIpcOf1M3cUKQavC+30J
	q1Bn8vPYeRZBbfeLP2sjT774MD2OMBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688629; a=rsa-sha256;
	cv=none;
	b=j/NlOUZ5poYSn/SESpA2iq3mI3lQAN9Akk+1iMjMDmyANc/V6vi+zt03xT2ZnIT758ZyfE
	LX56ww06kNRrMccRZ5UfDnuIHma9M3dHaqr2IzgXzo0OA3Nz/w56iYBHMRQSzXG2U9e7xk
	7r/uTm/NIC35X8MikCcJrFxSM4ZvqRY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p6V8nYcq;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6F9060097;
	Mon, 16 Mar 2026 19:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7BCC19421;
	Mon, 16 Mar 2026 19:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688628;
	bh=QyEpZlZG4opNA8anvj6G5Slo7c/FEhsWdlvBbfWACi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p6V8nYcqmeDZKuY4zGNJ/3JO3CnU0d9efgyFdkVY7WSUNYIDhCTI9Db2OUNnvZkuV
	 DJKNEIr0LVqkw7Qm+7/LNMZVIy2H6lZSikEMJxAeb3rC/4Ok0+/5T9pPdWx0hxlyfF
	 YC9hu93u2F0y8eWR++ss1I+ojYbIFXoX/ZuREscW0OSdbh8qpKKHZ34v9W5/hiyDoR
	 j6phsp0FGdk9ZAHp8Dp/oyzPLmvM0Lji+BhGIxnplEpsoKuFzNUNe28cRSEOmi6Zgz
	 5pNsd9DGY8/zp1LM+egYfiwZmkjPSb7Ys/IvaCJPlZM7sDDRwMQVyAWIqyg9+q9N6f
	 35RjXxG9KVfKA==
Date: Mon, 16 Mar 2026 19:16:56 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
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
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 02/15] mm: add documentation for the mmap_prepare file
 operation callback
Message-ID: <6a0e73a5-519e-49ca-9f76-2f6cc5a1577c@lucifer.local>
References: <cover.1773346620.git.ljs@kernel.org>
 <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
 <CAJuCfpGd702=Xop3X5Aop9rrScdiAOQEEooTu1gcJqR9pmO5GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGd702=Xop3X5Aop9rrScdiAOQEEooTu1gcJqR9pmO5GA@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C49C180013
X-Stat-Signature: ji6spakdw99pkhn5j87fetmnd317gpxg
X-Rspam-User: 
X-HE-Tag: 1773688629-277189
X-HE-Meta: U2FsdGVkX18suYpgjHz9cuW1NYGGIwcFzOemHtoQ5RY2r7Xdw9pXrMZK5ho0e1Dr2mkfdX+z1pRPvFoc0SCDi8Qg/W1F5u+STcrsMgzubw+XHNSIqvHhUEB3z9GSI7zY1njd8kJnc4a4lnDiFqqnCf4mSdENS1j3EoB5q22IVG+RK7M9EMiGIyHcNs5hdY+vSz4wbxt3pFdq9fbn9JYZUkkIBki96/2/wgpzr+7wk18xO+vij7tp4dt0jRQEn/KcQhW3y1OhFpJ1PsdDYn/oHWRILM4X7UQZgUbxabZ3p4026JWD8Bab4tmzuj1hVhgzOzQ2v2kcEQMpfTEvapyDfcfvT20ZmGgTS7lGVoPYzte6ndHNwnOq+Azu8BVcLmHK0ui+7wLBmKK5olE0kKDLm/ARV8mu72n2h3QWL0ju6f8rHhc4hlxg8pOVSSmigMuYPruCi2ERfeh8IUVVDcu1w/V4tqerMo2SBNsFUE7zT7YWe9iuzBdLLh7nY6ynpwT9ywXWpQlSu0tdUwUTqdageeOTN5XEGmMRDwAc+ESNCbeFDUwmOZHDnYVuzXB9iyFmXaNZZ/RwxSFSndCUO7Ad/TLRwim3WM0+6mWeyKc0sT0n0eznAWHdZlnX+LPmopJBsehK8sQqjxpBjk3ckbD0g/aXo/QfVjjR4pLYsg9TnYSAgr/Z+I6QcfmIJ+DZQkVlvvvn2IvtqYlTH9FwmXxrtEzzMcAf/inD9ZYas5nn8sRWzx4+VGhNLecr4PgUbTCg+oek9xWL8fDLfm3lV+5Tk3mhtDOsk7DPR/acgo7Xq5pbXEWGRTyVbH9haHeFks/gpBx9ystHHsyHNL0FNzyMxjuoDPWmeYpgU1b8sWMfEHRx+nLwwSFBRIzAuD5xXsNks7Rat7OrwrqZcIOS03lV0G8pHB9aRNF7cecmFCNBci5dlxkASvp24NA2v+G2j3NlpUm3MWOEZHCvpaXfrsq
 Z1w9Nalq
 jN/qsEA0sS326GdM1djY96KN897i319Nsjyp7X/BNZlEXc5b5zd0X67TamF6sTeX51mNMYj3R3xByPkFQV2LrWzrdrkMZbPTQAPNrXnEhVVuSonVwSl2iotXyQW4Iwtt+JSl90s6XJ6WOxV+WOIrmi52+MvYtJOSijsxhZIuRUZdKogplK/Mtpk3oi3OZk2szMpTE1bHRnQPrvuet4ccb85J6IvsD0hPblTqVlyh/+UScl5BnYNRBhlLOcUrdVD/8v3dWh9tt+MekqA2b9Fep10HxHywjgjnlXmr6bDOirvoBYzwx1vn1nENpLCDTKoEQdG+rENrJm6AXf+rI6GEqJKTqLjHhuYFZE4WEgWB85t73L3tQDe5/+Qg+HgPQ1ve6GTig
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 04:23:14PM -0700, Suren Baghdasaryan wrote:
> On Thu, Mar 12, 2026 at 1:27 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > This documentation makes it easier for a driver/file system implementer to
> > correctly use this callback.
> >
> > It covers the fundamentals, whilst intentionally leaving the less lovely
> > possible actions one might take undocumented (for instance - the
> > success_hook, error_hook fields in mmap_action).
> >
> > The document also covers the new VMA flags implementation which is the only
> > one which will work correctly with mmap_prepare.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
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
>
> So, action still belongs to /* Write-only fields. */ section? This is
> nitpicky, but it might be better to have this as:
>
>         /* Write-only fields. */
>         const struct vm_operations_struct *vm_ops;
>         void *private_data;
>         struct mmap_action action; /* Take further action? */

Absolutely not. This field is not to be written to by the user.

We sadly have to allow hugetlb to do some hacks, but these are things we don't
want to point out.

Users should use mmap_action_xxx() functions.

>
> > +    };
> > +
> > +This is straightforward - you have all the fields you need to set up the
> > +mapping, and you can update the mutable and writable fields, for instance:
> > +
> > +.. code-block:: Cw
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
> I'm guessing the start and size parameters passed to
> mmap_action_remap() and such are restricted by vm_area_desc.start
> vm_area_desc.end. If so, should we document those restrictions and
> enforce them in the code?

I mean it's the same restrictions as all of the functions already apply if you
were to use them with a VMA descriptor.

I think implicitly a remap will fail if you try it out of the VMA range at the
point of applying the change.

But it might be worth adding range_in_vma_desc() checks at prepare time, will
see if I can do that for the respin.

I think it's pretty obvious that you shouldn't be trying to remap totally
unrelated memory, so I'm not sure that's at a level of granularity that's suited
to this document though.

>
> > +    struct vm_area_desc {
> > +        /* Immutable state. */
> > +        const struct mm_struct *const mm;
> > +        struct file *const file; /* May vary from vm_file in stacked callers. */
> > +        unsigned long start;
> > +        unsigned long end;
>
>
> > --
> > 2.53.0
> >

