Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABC9103E302
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB386B0088; Thu, 12 Mar 2026 20:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF376B008C; Thu, 12 Mar 2026 20:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D982A6B008A; Thu, 12 Mar 2026 20:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0F746B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:12:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D2D3C1D4E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:12:24 +0000 (UTC)
X-FDA: 84539113008.21.481B853
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F6A640002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:12:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qZu7Mcth;
	spf=none (imf04.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773360742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GAI1yniehNGO2chwWjeJzMqefzHRGvnktfqEKsFLzY=;
	b=pLgeo0CCjgfHj26hxIMEMuXjFSicWUvaISR3d5CmQ8ndj+ImnFy2Dp+myMhfj+PHZJ1qji
	UY6qwLpoYqAE1gXLhYEfFw0Ub6VU2qJvjqudcxC+r0OS3wB/EtlOWkhhP7orhVI1DUEVV5
	GgL2DTHEQwiKa069JxcuoL+95j08l08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773360742; a=rsa-sha256;
	cv=none;
	b=YCjPKOA21nPzV15IH9OKVcsPq1L+vXz+2TM7Z+NFh8DXRO01Ts4Lz0amxLwd3RnsJdUKvD
	HQEfZvwudZx19jpk27srqPjwOmsggdQX/V7ZgJKnGxQcFo4ol1tvCC3fS1FaGUcVfELog6
	h2Bb5lYENti1+IRtxV+Fn++VGRtMdJ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qZu7Mcth;
	spf=none (imf04.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:From:References:Cc:To:
	Subject:MIME-Version:Date:Message-ID:Content-Type:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+GAI1yniehNGO2chwWjeJzMqefzHRGvnktfqEKsFLzY=; b=qZu7McthjBQtMj3aupJH1qJGgZ
	hKfu0DbCBr+3K+tnF9BoSB27l+4l1SpwxmKtVIMSc2xx+jsyaAa+w2I4QqDb7xtpgpaEXkMpdA4nm
	mU+yVb4umzLA87r5gf1DLfd7BsRQ0pP6gUDStnSk9lsUu/aytOBVbnxWQAFzgRbGNRBIl2Y1nMicN
	cmtT+S3U+xXWfSATHp24Wop6HYDRJiuNPDo+fBX5eYhi+EChJIGxPpnUdbkGi70Znq6mst/6jhwvs
	yztWkaiTkXncGNcjnmSVCXuuJE21lkxpP2x5JBsvLXf9YP+caSyG+t/jo14zcoxoVtD+8+Q/hB9PC
	nfWCKWoQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0q8L-0000000FsPm-2hlm;
	Fri, 13 Mar 2026 00:12:05 +0000
Content-Type: multipart/mixed; boundary="------------27O3bLyj7x6zyBk5Hv9GUKC3"
Message-ID: <f0e33b51-d465-462d-b0f6-98a1db66bb15@infradead.org>
Date: Thu, 12 Mar 2026 17:12:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/15] mm: add documentation for the mmap_prepare file
 operation callback
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1773346620.git.ljs@kernel.org>
 <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1F6A640002
X-Stat-Signature: wgpgpw4z7w8u3qknn8mubkrhxr6cj7mw
X-Rspam-User: 
X-HE-Tag: 1773360741-472113
X-HE-Meta: U2FsdGVkX19+UBhnU3bSPtfXHpLszYKcvvFc1Jn07gzC5EvJnc9JRqv3D2PmOnozmCbK5TEhVww0nJdV1zDn9LeRRJY7iNpozeZuMpz0R7wfor+H57dheruxpSI06l6Zzkigh6Ceq5LdeVizMO2yJuCct5hAccxjvzD+Pgrrj2/isvrlNTyWowcR5Wc2XeT2ZwRYSWNm9IkSPwroF+9yqdtTUYhrBilNOvr9Ufs6WHhBCIeykdwXyhWMiZc/kZMmULO2aM1YRXFH/YJWlZmXNIYOPCJnlfLMhLPld7aSUmjc2vmBwUZF4ib98bsT0ClivayV9s8cR92onZaFxu5Aenhs7IQ8Gzh19v6/DXduSSCsjU5kxePTPwd82rtnFHBFCxA2691kCsh0MRGcaSRIKLLolNMn3Cx3iY0s8fv2Nu8xPurf9F9nvcMkpJd62UxnJahN6/EReeSGaPJfAXBi8Vom3G/3TJXvF1ad2xe1ImmCx16Wz/KElGnzNemul1B7KNOt1pPVwdIjEzg6udtrADF0zFaS4G77Igisw89JL6bdIxgHqiAY89PNM1zOou3ij4y1Qkj1vEjA/GdT2wVSbMJMZIvWsKl55Ym3xSyR4PGQrSXGUt289yoyrZTnuyduDBUGLVE/5gO5u9wqSATxCbbNLKIMDgJWLjCHG+exsngYMSJucnzT4ZObXQw1lfpQvn19cOGTN4beoPhhnS5oAK7EjK5V2Bur0z/EDwnzbuQPTwjizh2AB5vtaz+34fA4E1Kv7kOHpJ8mVdWmEQOWpwarJ+zdkpT3wWmFWeieA6kha+xG8uVk/fQtcBoVwz31aPUt5kxruCXr2BADh6Vnn9RlUC54hlbXm6LiLg6zHcb7/Hbop+kPF79ILUreKZrtx9zwuiSHDA4V3XskaP2iN89ygO6dPs87K8jraU6YMCTRNWspr4Jugif97my/yME9Z6bb1rP74xMO0t+AbLC
 gCAmm9+v
 Y67iQGMu5akJ9W3+5hth7VasdnpAj7lggaIHRJTmxeW17DotjMLKuKQn7Sv88I+oWdTE+VVEtXxrGAXaETURtnAyJZlAiFe60/CHvubRpdJ+rOg2Uvh3cr2ccj4PMYOJvk5y8PeUqDUs+c725GWhOdyXS04GcPS/aCTj9zMZkL4ajtiCyU6QhNqbRIYRHUDTuFolIQy4nL3B4f4VrUZnFg1t0XO+6L3x+f/FjKfQd37c3i7bmVYq8vl0P9YSDHr9F7Lu5gKpC2oMBkQBBhSv1SY6c1croMlau8E1sy7be5lzmwUvcJgINo81EL0P1IGaRnghA3K5z/+53e74r2oPNimOIsazOwlC870mh0PZiMkvb78rFRmeeQyd5SsRRCxhoUqlRyhNsD1PG1IQUv00GNKgQEe1Edr2QLQ8BMiQJiEBqnnJkk2xOOBIxpdpl78Xyb6977c4PDALsjZiQz26H+UwaTv9A2gSmQDpjExUaWhuelr/HvPmN8zS8tN1r4BapmgvFFzq8jZqhO826azDN5nIUfuBYsPL6oH4rkIhBHLJtAe/DLKDk2byYJfw/LIgut+PsNNLcPL/VBd2chCskSZ0lyKlzqEB6Sz4bWF3F0t/kN2iafVcXAItL2qP8O1ooM7+r8uAK4mmKLosIoCJvZFllgFTQMfazwk/o4z0TnI4Pki2lgMlWllCDi+nKjuUbWKx9KITO/UCinLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------27O3bLyj7x6zyBk5Hv9GUKC3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(Andrew: patch attached)


On 3/12/26 1:27 PM, Lorenzo Stoakes (Oracle) wrote:

Documentation/filesystems/mmap_prepare.rst: WARNING: document isn't included in any toctree [toc.not_included]

Should be in some index.rst file. In filesystems I suppose.

> ---
>  Documentation/filesystems/mmap_prepare.rst | 131 +++++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100644 Documentation/filesystems/mmap_prepare.rst
> 
> diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
> new file mode 100644
> index 000000000000..76908200f3a1
> --- /dev/null
> +++ b/Documentation/filesystems/mmap_prepare.rst
> @@ -0,0 +1,131 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===========================
> +mmap_prepare callback HOWTO
> +===========================
> +
> +Introduction
> +############

Kernel style is "=============" above instead of "############".

> +
> +The `struct file->f_op->mmap()` callback has been deprecated as it is both a
> +stability and security risk, and doesn't always permit the merging of adjacent
> +mappings resulting in unnecessary memory fragmentation.
> +
> +It has been replaced with the `file->f_op->mmap_prepare()` callback which solves
> +these problems.
> +
> +## How To Use
> +
> +In your driver's `struct file_operations` struct, specify an `mmap_prepare`
> +callback rather than an `mmap` one, e.g. for ext4:
> +
> +
> +.. code-block:: C
> +
> +    const struct file_operations ext4_file_operations = {
> +        ...
> +        .mmap_prepare    = ext4_file_mmap_prepare,
> +    };
> +
> +This has a signature of `int (*mmap_prepare)(struct vm_area_desc *)`.
> +
> +Examining the `struct vm_area_desc` type:
> +
> +.. code-block:: C
> +
> +    struct vm_area_desc {
> +        /* Immutable state. */
> +        const struct mm_struct *const mm;
> +        struct file *const file; /* May vary from vm_file in stacked callers. */
> +        unsigned long start;
> +        unsigned long end;
> +
> +        /* Mutable fields. Populated with initial state. */
> +        pgoff_t pgoff;
> +        struct file *vm_file;
> +        vma_flags_t vma_flags;
> +        pgprot_t page_prot;
> +
> +        /* Write-only fields. */
> +        const struct vm_operations_struct *vm_ops;
> +        void *private_data;
> +
> +        /* Take further action? */
> +        struct mmap_action action;
> +    };
> +
> +This is straightforward - you have all the fields you need to set up the
> +mapping, and you can update the mutable and writable fields, for instance:
> +
> +.. code-block:: Cw

   .. code-block:: C

Documentation/filesystems/mmap_prepare.rst:60: WARNING: Pygments lexer name 'Cw' is not known [misc.highlighting_failure]

Maybe a typo?

> +
> +    static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
> +    {
> +        int ret;
> +        struct file *file = desc->file;
> +        struct inode *inode = file->f_mapping->host;
> +
> +        ...
> +
> +        file_accessed(file);
> +        if (IS_DAX(file_inode(file))) {
> +            desc->vm_ops = &ext4_dax_vm_ops;
> +            vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
> +        } else {
> +            desc->vm_ops = &ext4_file_vm_ops;
> +        }
> +        return 0;
> +    }
> +
> +Importantly, you no longer have to dance around with reference counts or locks
> +when updating these fields - __you can simply go ahead and change them__.
> +
> +Everything is taken care of by the mapping code.
> +
> +VMA Flags
> +=========

and then use "---------------" here instead of "==============".

(from Documentation/doc-guide/sphinx.rst)

> +
> +Along with `mmap_prepare`, VMA flags have undergone an overhaul. Where before
> +you would invoke one of `vm_flags_init()`, `vm_flags_reset()`, `vm_flags_set()`,
> +`vm_flags_clear()`, and `vm_flags_mod()` to modify flags (and to have the
> +locking done correctly for you, this is no longer necessary.
> +
> +Also, the legacy approach of specifying VMA flags via `VM_READ`, `VM_WRITE`,
> +etc. - i.e. using a `VM_xxx` macro has changed too.
> +
> +When implementing `mmap_prepare()`, reference flags by their bit number, defined
> +as a `VMA_xxx_BIT` macro, e.g. `VMA_READ_BIT`, `VMA_WRITE_BIT` etc., and use one
> +of (where `desc` is a pointer to `struct vma_area_desc`):
> +
> +* `vma_desc_test_flags(desc, ...)` - Specify a comma-separated list of flags you
> +  wish to test for (whether _any_ are set), e.g. - `vma_desc_test_flags(desc,
> +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)` - returns `true` if either are set,
> +  otherwise `false`.
> +* `vma_desc_set_flags(desc, ...)` - Update the VMA descriptor flags to set
> +  additional flags specified by a comma-separated list,
> +  e.g. - `vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)`.
> +* `vma_desc_clear_flags(desc, ...)` - Update the VMA descriptor flags to clear
> +  flags specified by a comma-separated list, e.g. - `vma_desc_clear_flags(desc,
> +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`.
> +
> +Actions
> +=======
> +
> +You can now very easily have actions be performed upon a mapping once set up by
> +utilising simple helper functions invoked upon the `struct vm_area_desc`
> +pointer. These are:
> +
> +* `mmap_action_remap()` - Remaps a range consisting only of PFNs for a specific
> +  range starting a virtual address and PFN number of a set size.
> +
> +* `mmap_action_remap_full()` - Same as `mmap_action_remap()`, only remaps the
> +  entire mapping from `start_pfn` onward.
> +
> +* `mmap_action_ioremap()` - Same as `mmap_action_remap()`, only performs an I/O
> +  remap.
> +
> +* `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, only remaps
> +  the entire mapping from `start_pfn` onward.
> +
> +**NOTE:** The 'action' field should never normally be manipulated directly,
> +rather you ought to use one of these helpers.

I also see this warning, but I don't know what it is referring to:

Documentation/filesystems/mmap_prepare.rst:132: ERROR: Anonymous hyperlink mismatch: 1 references but 0 targets.
See "backrefs" attribute for IDs. [docutils]

(OK, I found/fixed that also.)

There are also lots of single ` marks which mean italics. I thought those were
not what was intended, so I changed (most of) them to `` marks, which means
"code block / monospace". I can fix those if needed.

from the patch file:
@Lorenzo: ISTR that you prefer explicit quoting on structs and
functions. I didn't do that here since kernel automarkup does that,
but if you prefer, I can redo the patch with those changes.

HTH.
-- 
~Randy

--------------27O3bLyj7x6zyBk5Hv9GUKC3
Content-Type: text/x-patch; charset=UTF-8;
 name="mmap-prepare-docs-fixes.patch"
Content-Disposition: attachment; filename="mmap-prepare-docs-fixes.patch"
Content-Transfer-Encoding: base64

RnJvbTogUmFuZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+ClN1YmplY3Q6IFtQ
QVRDSF0gRG9jczogbW1hcF9wcmVwYXJlOiBmaXggc3BoaW54IHdhcm5pbmdzIGFuZCBmb3Jt
YXQKCkZpeCAnbWFrZSBodG1sZG9jcycgYnVpbGQgd2FybmluZ3MsIGhlYWRpbmdzIHN0eWxl
LCBhbmQgcXVvdGluZwpzdHlsZS4KCkRvY3VtZW50YXRpb24vZmlsZXN5c3RlbXMvbW1hcF9w
cmVwYXJlLnJzdDogV0FSTklORzogZG9jdW1lbnQgaXNuJ3QgaW5jbHVkZWQgaW4gYW55IHRv
Y3RyZWUgW3RvYy5ub3RfaW5jbHVkZWRdCkRvY3VtZW50YXRpb24vZmlsZXN5c3RlbXMvbW1h
cF9wcmVwYXJlLnJzdDo2MDogV0FSTklORzogUHlnbWVudHMgbGV4ZXIgbmFtZSAnQ3cnIGlz
IG5vdCBrbm93biBbbWlzYy5oaWdobGlnaHRpbmdfZmFpbHVyZV0KRG9jdW1lbnRhdGlvbi9m
aWxlc3lzdGVtcy9tbWFwX3ByZXBhcmUucnN0OjEzMjogRVJST1I6IEFub255bW91cyBoeXBl
cmxpbmsgbWlzbWF0Y2g6IDEgcmVmZXJlbmNlcyBidXQgMCB0YXJnZXRzLgpTZWUgImJhY2ty
ZWZzIiBhdHRyaWJ1dGUgZm9yIElEcy4gW2RvY3V0aWxzXQoKU2lnbmVkLW9mZi1ieTogUmFu
ZHkgRHVubGFwIDxyZHVubGFwQGluZnJhZGVhZC5vcmc+Ci0tLQpATG9yZW56bzogSVNUUiB0
aGF0IHlvdSBwcmVmZXIgZXhwbGljaXQgcXVvdGluZyBvbiBzdHJ1Y3RzIGFuZApmdW5jdGlv
bnMuIEkgZGlkbid0IGRvIHRoYXQgaGVyZSBzaW5jZSBrZXJuZWwgYXV0b21hcmt1cCBkb2Vz
IHRoYXQsCmJ1dCBpZiB5b3UgcHJlZmVyLCBJIGNhbiByZWRvIHRoZSBwYXRjaCB3aXRoIHRo
b3NlIGNoYW5nZXMuCgogRG9jdW1lbnRhdGlvbi9maWxlc3lzdGVtcy9pbmRleC5yc3QgICAg
ICAgIHwgICAgMSAKIERvY3VtZW50YXRpb24vZmlsZXN5c3RlbXMvbW1hcF9wcmVwYXJlLnJz
dCB8ICAgNzQgKysrKysrKysrLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNl
cnRpb25zKCspLCAzNyBkZWxldGlvbnMoLSkKCi0tLSBsaW51eC1uZXh0Lm9yaWcvRG9jdW1l
bnRhdGlvbi9maWxlc3lzdGVtcy9pbmRleC5yc3QKKysrIGxpbnV4LW5leHQvRG9jdW1lbnRh
dGlvbi9maWxlc3lzdGVtcy9pbmRleC5yc3QKQEAgLTI5LDYgKzI5LDcgQEAgYWxnb3JpdGht
cyB3b3JrLgogICAgZmllbWFwCiAgICBmaWxlcwogICAgbG9ja3MKKyAgIG1tYXBfcHJlcGFy
ZQogICAgbXVsdGlncmFpbi10cwogICAgbW91bnRfYXBpCiAgICBxdW90YQotLS0gbGludXgt
bmV4dC5vcmlnL0RvY3VtZW50YXRpb24vZmlsZXN5c3RlbXMvbW1hcF9wcmVwYXJlLnJzdAor
KysgbGludXgtbmV4dC9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL21tYXBfcHJlcGFyZS5y
c3QKQEAgLTUsMTkgKzUsMTkgQEAgbW1hcF9wcmVwYXJlIGNhbGxiYWNrIEhPV1RPCiA9PT09
PT09PT09PT09PT09PT09PT09PT09PT0KIAogSW50cm9kdWN0aW9uCi0jIyMjIyMjIyMjIyMK
Kz09PT09PT09PT09PQogCi1UaGUgYHN0cnVjdCBmaWxlLT5mX29wLT5tbWFwKClgIGNhbGxi
YWNrIGhhcyBiZWVuIGRlcHJlY2F0ZWQgYXMgaXQgaXMgYm90aCBhCitUaGUgYGBzdHJ1Y3Qg
ZmlsZS0+Zl9vcC0+bW1hcCgpYGAgY2FsbGJhY2sgaGFzIGJlZW4gZGVwcmVjYXRlZCBhcyBp
dCBpcyBib3RoIGEKIHN0YWJpbGl0eSBhbmQgc2VjdXJpdHkgcmlzaywgYW5kIGRvZXNuJ3Qg
YWx3YXlzIHBlcm1pdCB0aGUgbWVyZ2luZyBvZiBhZGphY2VudAogbWFwcGluZ3MgcmVzdWx0
aW5nIGluIHVubmVjZXNzYXJ5IG1lbW9yeSBmcmFnbWVudGF0aW9uLgogCi1JdCBoYXMgYmVl
biByZXBsYWNlZCB3aXRoIHRoZSBgZmlsZS0+Zl9vcC0+bW1hcF9wcmVwYXJlKClgIGNhbGxi
YWNrIHdoaWNoIHNvbHZlcwotdGhlc2UgcHJvYmxlbXMuCitJdCBoYXMgYmVlbiByZXBsYWNl
ZCB3aXRoIHRoZSBgYGZpbGUtPmZfb3AtPm1tYXBfcHJlcGFyZSgpYGAgY2FsbGJhY2sgd2hp
Y2gKK3NvbHZlcyB0aGVzZSBwcm9ibGVtcy4KIAogIyMgSG93IFRvIFVzZQogCi1JbiB5b3Vy
IGRyaXZlcidzIGBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zYCBzdHJ1Y3QsIHNwZWNpZnkgYW4g
YG1tYXBfcHJlcGFyZWAKLWNhbGxiYWNrIHJhdGhlciB0aGFuIGFuIGBtbWFwYCBvbmUsIGUu
Zy4gZm9yIGV4dDQ6CitJbiB5b3VyIGRyaXZlcidzIHN0cnVjdCBmaWxlX29wZXJhdGlvbnMg
c3RydWN0LCBzcGVjaWZ5IGFuIGBgbW1hcF9wcmVwYXJlYGAKK2NhbGxiYWNrIHJhdGhlciB0
aGFuIGFuIGBgbW1hcGBgIG9uZSwgZS5nLiBmb3IgZXh0NDoKIAogCiAuLiBjb2RlLWJsb2Nr
OjogQwpAQCAtMjcsOSArMjcsOSBAQCBjYWxsYmFjayByYXRoZXIgdGhhbiBhbiBgbW1hcGAg
b25lLCBlLmcuCiAgICAgICAgIC5tbWFwX3ByZXBhcmUgICAgPSBleHQ0X2ZpbGVfbW1hcF9w
cmVwYXJlLAogICAgIH07CiAKLVRoaXMgaGFzIGEgc2lnbmF0dXJlIG9mIGBpbnQgKCptbWFw
X3ByZXBhcmUpKHN0cnVjdCB2bV9hcmVhX2Rlc2MgKilgLgorVGhpcyBoYXMgYSBzaWduYXR1
cmUgb2YgYGBpbnQgKCptbWFwX3ByZXBhcmUpKHN0cnVjdCB2bV9hcmVhX2Rlc2MgKilgYC4K
IAotRXhhbWluaW5nIHRoZSBgc3RydWN0IHZtX2FyZWFfZGVzY2AgdHlwZToKK0V4YW1pbmlu
ZyB0aGUgc3RydWN0IHZtX2FyZWFfZGVzYyB0eXBlOgogCiAuLiBjb2RlLWJsb2NrOjogQwog
CkBAIC01Nyw3ICs1Nyw3IEBAIEV4YW1pbmluZyB0aGUgYHN0cnVjdCB2bV9hcmVhX2Rlc2Ng
IHR5cGUKIFRoaXMgaXMgc3RyYWlnaHRmb3J3YXJkIC0geW91IGhhdmUgYWxsIHRoZSBmaWVs
ZHMgeW91IG5lZWQgdG8gc2V0IHVwIHRoZQogbWFwcGluZywgYW5kIHlvdSBjYW4gdXBkYXRl
IHRoZSBtdXRhYmxlIGFuZCB3cml0YWJsZSBmaWVsZHMsIGZvciBpbnN0YW5jZToKIAotLi4g
Y29kZS1ibG9jazo6IEN3CisuLiBjb2RlLWJsb2NrOjogQwogCiAgICAgc3RhdGljIGludCBl
eHQ0X2ZpbGVfbW1hcF9wcmVwYXJlKHN0cnVjdCB2bV9hcmVhX2Rlc2MgKmRlc2MpCiAgICAg
ewpAQCAtNzgsNTQgKzc4LDU0IEBAIG1hcHBpbmcsIGFuZCB5b3UgY2FuIHVwZGF0ZSB0aGUg
bXV0YWJsZQogICAgIH0KIAogSW1wb3J0YW50bHksIHlvdSBubyBsb25nZXIgaGF2ZSB0byBk
YW5jZSBhcm91bmQgd2l0aCByZWZlcmVuY2UgY291bnRzIG9yIGxvY2tzCi13aGVuIHVwZGF0
aW5nIHRoZXNlIGZpZWxkcyAtIF9feW91IGNhbiBzaW1wbHkgZ28gYWhlYWQgYW5kIGNoYW5n
ZSB0aGVtX18uCit3aGVuIHVwZGF0aW5nIHRoZXNlIGZpZWxkcyAtICoqeW91IGNhbiBzaW1w
bHkgZ28gYWhlYWQgYW5kIGNoYW5nZSB0aGVtKiouCiAKIEV2ZXJ5dGhpbmcgaXMgdGFrZW4g
Y2FyZSBvZiBieSB0aGUgbWFwcGluZyBjb2RlLgogCiBWTUEgRmxhZ3MKLT09PT09PT09PQor
LS0tLS0tLS0tCiAKLUFsb25nIHdpdGggYG1tYXBfcHJlcGFyZWAsIFZNQSBmbGFncyBoYXZl
IHVuZGVyZ29uZSBhbiBvdmVyaGF1bC4gV2hlcmUgYmVmb3JlCi15b3Ugd291bGQgaW52b2tl
IG9uZSBvZiBgdm1fZmxhZ3NfaW5pdCgpYCwgYHZtX2ZsYWdzX3Jlc2V0KClgLCBgdm1fZmxh
Z3Nfc2V0KClgLAotYHZtX2ZsYWdzX2NsZWFyKClgLCBhbmQgYHZtX2ZsYWdzX21vZCgpYCB0
byBtb2RpZnkgZmxhZ3MgKGFuZCB0byBoYXZlIHRoZQorQWxvbmcgd2l0aCBgYG1tYXBfcHJl
cGFyZWBgLCBWTUEgZmxhZ3MgaGF2ZSB1bmRlcmdvbmUgYW4gb3ZlcmhhdWwuIFdoZXJlIGJl
Zm9yZQoreW91IHdvdWxkIGludm9rZSBvbmUgb2Ygdm1fZmxhZ3NfaW5pdCgpLCB2bV9mbGFn
c19yZXNldCgpLCB2bV9mbGFnc19zZXQoKSwKK3ZtX2ZsYWdzX2NsZWFyKCksIGFuZCB2bV9m
bGFnc19tb2QoKSB0byBtb2RpZnkgZmxhZ3MgKGFuZCB0byBoYXZlIHRoZQogbG9ja2luZyBk
b25lIGNvcnJlY3RseSBmb3IgeW91LCB0aGlzIGlzIG5vIGxvbmdlciBuZWNlc3NhcnkuCiAK
LUFsc28sIHRoZSBsZWdhY3kgYXBwcm9hY2ggb2Ygc3BlY2lmeWluZyBWTUEgZmxhZ3Mgdmlh
IGBWTV9SRUFEYCwgYFZNX1dSSVRFYCwKLWV0Yy4gLSBpLmUuIHVzaW5nIGEgYFZNX3h4eGAg
bWFjcm8gaGFzIGNoYW5nZWQgdG9vLgorQWxzbywgdGhlIGxlZ2FjeSBhcHByb2FjaCBvZiBz
cGVjaWZ5aW5nIFZNQSBmbGFncyB2aWEgYGBWTV9SRUFEYGAsIGBgVk1fV1JJVEVgYCwKK2V0
Yy4gLSBpLmUuIHVzaW5nIGEgYGAtVk1feHh4YGAtIG1hY3JvIGhhcyBjaGFuZ2VkIHRvby4K
IAotV2hlbiBpbXBsZW1lbnRpbmcgYG1tYXBfcHJlcGFyZSgpYCwgcmVmZXJlbmNlIGZsYWdz
IGJ5IHRoZWlyIGJpdCBudW1iZXIsIGRlZmluZWQKLWFzIGEgYFZNQV94eHhfQklUYCBtYWNy
bywgZS5nLiBgVk1BX1JFQURfQklUYCwgYFZNQV9XUklURV9CSVRgIGV0Yy4sIGFuZCB1c2Ug
b25lCi1vZiAod2hlcmUgYGRlc2NgIGlzIGEgcG9pbnRlciB0byBgc3RydWN0IHZtYV9hcmVh
X2Rlc2NgKToKLQotKiBgdm1hX2Rlc2NfdGVzdF9mbGFncyhkZXNjLCAuLi4pYCAtIFNwZWNp
ZnkgYSBjb21tYS1zZXBhcmF0ZWQgbGlzdCBvZiBmbGFncyB5b3UKLSAgd2lzaCB0byB0ZXN0
IGZvciAod2hldGhlciBfYW55XyBhcmUgc2V0KSwgZS5nLiAtIGB2bWFfZGVzY190ZXN0X2Zs
YWdzKGRlc2MsCi0gIFZNQV9XUklURV9CSVQsIFZNQV9NQVlXUklURV9CSVQpYCAtIHJldHVy
bnMgYHRydWVgIGlmIGVpdGhlciBhcmUgc2V0LAotICBvdGhlcndpc2UgYGZhbHNlYC4KLSog
YHZtYV9kZXNjX3NldF9mbGFncyhkZXNjLCAuLi4pYCAtIFVwZGF0ZSB0aGUgVk1BIGRlc2Ny
aXB0b3IgZmxhZ3MgdG8gc2V0CitXaGVuIGltcGxlbWVudGluZyBtbWFwX3ByZXBhcmUoKSwg
cmVmZXJlbmNlIGZsYWdzIGJ5IHRoZWlyIGJpdCBudW1iZXIsIGRlZmluZWQKK2FzIGEgYGBW
TUFfeHh4X0JJVGBgIG1hY3JvLCBlLmcuIGBgVk1BX1JFQURfQklUYGAsIGBgVk1BX1dSSVRF
X0JJVGBgIGV0Yy4sCithbmQgdXNlIG9uZSBvZiAod2hlcmUgYGBkZXNjYGAgaXMgYSBwb2lu
dGVyIHRvIHN0cnVjdCB2bWFfYXJlYV9kZXNjKToKKworKiBgYHZtYV9kZXNjX3Rlc3RfZmxh
Z3MoZGVzYywgLi4uKWBgIC0gU3BlY2lmeSBhIGNvbW1hLXNlcGFyYXRlZCBsaXN0IG9mIGZs
YWdzCisgIHlvdSB3aXNoIHRvIHRlc3QgZm9yICh3aGV0aGVyIF9hbnlfIGFyZSBzZXQpLCBl
LmcuIC0gYGB2bWFfZGVzY190ZXN0X2ZsYWdzKAorICBkZXNjLCBWTUFfV1JJVEVfQklULCBW
TUFfTUFZV1JJVEVfQklUKWBgIC0gcmV0dXJucyBgYHRydWVgYCBpZiBlaXRoZXIgYXJlIHNl
dCwKKyAgb3RoZXJ3aXNlIGBgZmFsc2VgYC4KKyogYGB2bWFfZGVzY19zZXRfZmxhZ3MoZGVz
YywgLi4uKWBgIC0gVXBkYXRlIHRoZSBWTUEgZGVzY3JpcHRvciBmbGFncyB0byBzZXQKICAg
YWRkaXRpb25hbCBmbGFncyBzcGVjaWZpZWQgYnkgYSBjb21tYS1zZXBhcmF0ZWQgbGlzdCwK
LSAgZS5nLiAtIGB2bWFfZGVzY19zZXRfZmxhZ3MoZGVzYywgVk1BX1BGTk1BUF9CSVQsIFZN
QV9JT19CSVQpYC4KLSogYHZtYV9kZXNjX2NsZWFyX2ZsYWdzKGRlc2MsIC4uLilgIC0gVXBk
YXRlIHRoZSBWTUEgZGVzY3JpcHRvciBmbGFncyB0byBjbGVhcgotICBmbGFncyBzcGVjaWZp
ZWQgYnkgYSBjb21tYS1zZXBhcmF0ZWQgbGlzdCwgZS5nLiAtIGB2bWFfZGVzY19jbGVhcl9m
bGFncyhkZXNjLAotICBWTUFfV1JJVEVfQklULCBWTUFfTUFZV1JJVEVfQklUKWAuCisgIGUu
Zy4gLSBgYHZtYV9kZXNjX3NldF9mbGFncyhkZXNjLCBWTUFfUEZOTUFQX0JJVCwgVk1BX0lP
X0JJVClgYC4KKyogYGB2bWFfZGVzY19jbGVhcl9mbGFncyhkZXNjLCAuLi4pYGAgLSBVcGRh
dGUgdGhlIFZNQSBkZXNjcmlwdG9yIGZsYWdzIHRvIGNsZWFyCisgIGZsYWdzIHNwZWNpZmll
ZCBieSBhIGNvbW1hLXNlcGFyYXRlZCBsaXN0LCBlLmcuIC0gYGB2bWFfZGVzY19jbGVhcl9m
bGFncygKKyAgZGVzYywgVk1BX1dSSVRFX0JJVCwgVk1BX01BWVdSSVRFX0JJVClgYC4KIAog
QWN0aW9ucwogPT09PT09PQogCiBZb3UgY2FuIG5vdyB2ZXJ5IGVhc2lseSBoYXZlIGFjdGlv
bnMgYmUgcGVyZm9ybWVkIHVwb24gYSBtYXBwaW5nIG9uY2Ugc2V0IHVwIGJ5Ci11dGlsaXNp
bmcgc2ltcGxlIGhlbHBlciBmdW5jdGlvbnMgaW52b2tlZCB1cG9uIHRoZSBgc3RydWN0IHZt
X2FyZWFfZGVzY2AKK3V0aWxpc2luZyBzaW1wbGUgaGVscGVyIGZ1bmN0aW9ucyBpbnZva2Vk
IHVwb24gdGhlIHN0cnVjdCB2bV9hcmVhX2Rlc2MKIHBvaW50ZXIuIFRoZXNlIGFyZToKIAot
KiBgbW1hcF9hY3Rpb25fcmVtYXAoKWAgLSBSZW1hcHMgYSByYW5nZSBjb25zaXN0aW5nIG9u
bHkgb2YgUEZOcyBmb3IgYSBzcGVjaWZpYworKiBtbWFwX2FjdGlvbl9yZW1hcCgpIC0gUmVt
YXBzIGEgcmFuZ2UgY29uc2lzdGluZyBvbmx5IG9mIFBGTnMgZm9yIGEgc3BlY2lmaWMKICAg
cmFuZ2Ugc3RhcnRpbmcgYSB2aXJ0dWFsIGFkZHJlc3MgYW5kIFBGTiBudW1iZXIgb2YgYSBz
ZXQgc2l6ZS4KIAotKiBgbW1hcF9hY3Rpb25fcmVtYXBfZnVsbCgpYCAtIFNhbWUgYXMgYG1t
YXBfYWN0aW9uX3JlbWFwKClgLCBvbmx5IHJlbWFwcyB0aGUKLSAgZW50aXJlIG1hcHBpbmcg
ZnJvbSBgc3RhcnRfcGZuYCBvbndhcmQuCisqIG1tYXBfYWN0aW9uX3JlbWFwX2Z1bGwoKSAt
IFNhbWUgYXMgbW1hcF9hY3Rpb25fcmVtYXAoKSwgb25seSByZW1hcHMgdGhlCisgIGVudGly
ZSBtYXBwaW5nIGZyb20gYGBzdGFydF9wZm5gYCBvbndhcmQuCiAKLSogYG1tYXBfYWN0aW9u
X2lvcmVtYXAoKWAgLSBTYW1lIGFzIGBtbWFwX2FjdGlvbl9yZW1hcCgpYCwgb25seSBwZXJm
b3JtcyBhbiBJL08KKyogbW1hcF9hY3Rpb25faW9yZW1hcCgpIC0gU2FtZSBhcyBtbWFwX2Fj
dGlvbl9yZW1hcCgpLCBvbmx5IHBlcmZvcm1zIGFuIEkvTwogICByZW1hcC4KIAotKiBgbW1h
cF9hY3Rpb25faW9yZW1hcF9mdWxsKClgIC0gU2FtZSBhcyBgbW1hcF9hY3Rpb25faW9yZW1h
cCgpYCwgb25seSByZW1hcHMKLSAgdGhlIGVudGlyZSBtYXBwaW5nIGZyb20gYHN0YXJ0X3Bm
bmAgb253YXJkLgorKiBtbWFwX2FjdGlvbl9pb3JlbWFwX2Z1bGwoKSAtIFNhbWUgYXMgbW1h
cF9hY3Rpb25faW9yZW1hcCgpLCBvbmx5IHJlbWFwcworICB0aGUgZW50aXJlIG1hcHBpbmcg
ZnJvbSBgYHN0YXJ0X3BmbmBgIG9ud2FyZC4KIAotKipOT1RFOioqIFRoZSAnYWN0aW9uJyBm
aWVsZCBzaG91bGQgbmV2ZXIgbm9ybWFsbHkgYmUgbWFuaXB1bGF0ZWQgZGlyZWN0bHksCisq
Kk5PVEU6KiogVGhlIGBgYWN0aW9uYGAgZmllbGQgc2hvdWxkIG5ldmVyIG5vcm1hbGx5IGJl
IG1hbmlwdWxhdGVkIGRpcmVjdGx5LAogcmF0aGVyIHlvdSBvdWdodCB0byB1c2Ugb25lIG9m
IHRoZXNlIGhlbHBlcnMuCg==

--------------27O3bLyj7x6zyBk5Hv9GUKC3--

