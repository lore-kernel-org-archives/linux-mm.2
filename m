Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723E4FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D776B6B008A; Thu, 30 Apr 2026 12:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4EAA6B008C; Thu, 30 Apr 2026 12:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C64F06B0092; Thu, 30 Apr 2026 12:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B594B6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:37:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B7B59F352
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:28:22 +0000 (UTC)
X-FDA: 84715754844.17.E8B2CCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DE6E1C0005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:28:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YrN/xFL8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7TW6CQBDhC3FPT0klyw+gRcjl9YaLy/d8soZU0no44=;
	b=v6lZBxMekVpPxDpLdj1iqYSpQgCgEZfj7MYyNspqvlfdsuSDEi5JwhwoO4XDqooo3HO2ZJ
	URWzlkslg6Xk79HapFnAJrSONDIMVtylPClcttIJMG9eqrxmvGT2rMjWZ1Anc+sDton8tu
	sVuRIguhNCdy7w82xV/wN9KlxB10fZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566500; a=rsa-sha256;
	cv=none;
	b=H4QDH/uMZ1BFUG43WQddVFKO0e75zZquBMNDUq8zeRFT1PdON2lxOeonhJxWyypfPSsO8/
	oIUWFqUGnMlRmwuUrFywCKZ+cJDKB2BBQ8Ysdo5Z299U2wDwDUGTqVJlEHZJQ05W8Anxrx
	GwY6GfA4rnXklnDlot9MvGplSpChR5U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YrN/xFL8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 619A543F78;
	Thu, 30 Apr 2026 16:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F090C2BCC6;
	Thu, 30 Apr 2026 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777566499;
	bh=xuHLlRVx0WdFbm/ciuLaXhbgiLBbjPGhjCQyHiREPFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YrN/xFL8k5VgBaNpK5LHDdomvtjX9zCVPkilhGlJ304+ICekhhk+PzD5cl+IUNYPC
	 Fb3ArpaMIEMLc7BN4CRT8wLsrRukGkGqIdV6/e0/HvTYYDgwyv33ejZZkfrXovYFDb
	 8H5U5Q+A9fjAwkQ6w0+unT1EGKbSp2wGb8fKZWwyP5QN7bpfV6rq7zcVWdLkc2sqB4
	 d7RLtD1z7tZd5SjYfvuSJzKmB6JEa2n7tZcdt4SYFGrvZtW3MnTTWWT6Mxk4T/Ze7J
	 F15PRktsnx4etKx/CQ+OOLNsEqz0iqWHSrInTQjkOWQF97QosnVSo9S8pTfEeNY+qQ
	 sxwcbCy+9/TRw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 68B4CF40080;
	Thu, 30 Apr 2026 12:28:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 30 Apr 2026 12:28:17 -0400
X-ME-Sender: <xms:IYPzabrEaTTcoVHbOU8Ie-jBwN9yekMCWj0oti8qKoYkC107BYdBPg>
    <xme:IYPzaeqktlbosTGgF0RMQ9mIAVA3CRhYGBrVWa-VSfRhqNbyE6glOJAhz_NkDgB7u
    010dtQL86rUaX2AO-bBdCM0yrbNsa1iO1Hql1F4XPk2XLJxHAZjmHc>
X-ME-Received: <xmr:IYPzaR6Hg64kuEe3KSi2SIGLExTJCxZKXaWUaHqF8zwOxNk5hfwFAEdLMFr2Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekjeektdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgv
    lhdrohhrgheqnecuggftrfgrthhtvghrnhepgeetuedtjefhkeeuiefgudduvdfgvdeiue
    eigeehheehudetuedtkeelhfeihedunecuffhomhgrihhnpehsrghshhhikhhordguvghv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:IYPzaV3LWTFN8XfRSCiRwGIC6e-pKYil930TJaa7zUHObc4fVT3QIw>
    <xmx:IYPzadlAdJGUbc96HtR7fIZDC2Iy1FdPr5XLM6d7Nj0_Yp-TL4uufw>
    <xmx:IYPzaegg5wt9LVrIuTqa6gy-ZRJ7gBH1_0_6b2QPw4xRK57zVnDpdg>
    <xmx:IYPzaU2FMoS_d2ECU8W6GqFaKCAiG1a9OOh76eW6SUV8f-8qZ1knuQ>
    <xmx:IYPzabYpwp038SUGhWJQqOEZL1x6wK5YoctLTEvtdxpDWv6eu7DBYYWJ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 12:28:15 -0400 (EDT)
Date: Thu, 30 Apr 2026 17:28:08 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 07/14] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Message-ID: <afOCAZ-dTQiLFN0y@thinkstation>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-8-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427114607.4068647-8-kas@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5DE6E1C0005
X-Stat-Signature: z9ktwfxgrw94nmbsir9fh69ufhew5q44
X-Rspam-User: 
X-HE-Tag: 1777566500-89193
X-HE-Meta: U2FsdGVkX1/lev7iCiMOgAFNYZkFBGjXYNzHwPERfWWgtytRecV096gB+p/0EWjIOKkZHIvNneVtg8lQ+Npvwyi9PP++Z8dcUFUbrRD3y6KVqdiVFxHlP9IUZAjLHlwnuuRov4eEo/hetRRMaX7LcrG1EME4wDTZjppshJQFgkMiOt7G0EX6Dtcy2ipijQ4a7NhI/tzOiyo7cAljFNN3+OUpzD6yElbhF9ito4L7Nq6H9Fg7V5gdxp4m7eCGnrgAjoe27jRz4c18+FSFfYdWYl1uIRxoLMSMuiiCqi/OCTjBVA8u+gBgKkIXvNc5I9C2P4dXhmEMJWM4oXazVw4gPQ3lcbZ1mJGCeEHxDbMdPe7DEU46F5dZc6iPOLsfgIiwmveI2YMu+blev7fEMB3lRhdmmSnvU/mw5BJeTJmX4sA+jEMPYQeFczA93iLnXH9VWnmRkXa5M1BKhj6yZbxUOEhU6tnX7ummAX59UI20xbsYi4W8gbHoe0PeRpfKql/q4z2rTLvE95G4+K1LP0S1uBGYfLM3CW/bQalhTSpvgsETgd9ZYNcxwa1eEvj8Ibdi+8rYQFRweUmgJNcZrvnhfaNwoj4DiEM7649AYf6zt9eykRO2OpyGudtxHokOaLYrTwzsvmw1ANYvxfL7K8bp7D5ISL1I0/B4w88aRD/RBrvoAPEyY2Etvk26mXoljLIEHuY9zcoQ8kmT29Bblbj0IxMD8VZ7cT+zdnXMrNLrFevTZhTq9JmTC4U59JNRWgLFNkqZJS9VZL+th34fpPg6o0Pu6ksURuxJvuYr2TZWqgPib2pEUGlu+NUENpbBvWLLKrUdKm5yNj5HMlEcqNse1r45ZUTUrWCHE7Ff8dOjJ8x5UqE4K6SHx9vQPV7b5alJiwMM54AxVrVL+THRdeShfKjfE4Uz4ZKDp3xr79ujApvhRgIkAJupnbhjy6PF6zHePpRCPpyVCi+JPdZ+tAa
 b07Rvw7g
 uMVt2hjvQxBKJOBC1PYSmwbkjFLCef2+8zHBUBFb3N6luUN5v4e8ySbMyQLWOen4ghyHtT0zVFIfjsLtMw0nocJGQK9fC3ZpsNx9opXiucxmRhq383rh0UKyAl3Rh6IvSaquKGA0TMmXM2pFCxmRYvffDSP9QLdnJ16xgzmI8m1conWP8y67ENF0buBk3pMbz7TRzreQz8fFus6JcZWPi62gOKwgHv3oUbSwpJl7S0IljMKf6sRrHtJBxpVhMc7r6E80AOm3VYNWspsszlGoCoNk6qQAeuxZTDswE6RHxLoyAKdKPL7kvPPT8IulUgnBMBbJB6tmhAB7BOBGaVH7/z70//BecfiYnpYKTx8qtGK/8Ya7xQlgNSEBrKbAb4Wd+gNCuzhCsi8aH09aUXtGIFWvNbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko.dev -- https://sashiko.dev/#/patchset/20260427114607.4068647-1-kas@kernel.org -- wrote:
> > @@ -1084,9 +1092,29 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
> >  		pte_t pte, unsigned long addr, int nr)
> >  {
> >  	struct mm_struct *src_mm = src_vma->vm_mm;
> > +	bool writable;
> > +
> > +	/*
> > +	 * Snapshot writability before the RWP-disarm rewrite below: when the
> > +	 * child is not RWP-armed, pte_modify(pte, dst_vma->vm_page_prot) can
> > +	 * silently drop _PAGE_RW from a resolved (no-marker) writable PTE,
> > +	 * so a later pte_write(pte) check would skip the COW wrprotect and
> > +	 * leave the parent writable over a folio shared with the child.
> > +	 */
> > +	writable = pte_write(pte);
> > +
> > +	/*
> > +	 * Child is not RWP-armed: restore accessible protection so the
> > +	 * inherited PAGE_NONE does not cost a fault on first read.
> > +	 */
> > +	if (!userfaultfd_protected(dst_vma)) {
> > +		if (userfaultfd_rwp(src_vma))
> > +			pte = pte_modify(pte, dst_vma->vm_page_prot);
> > +		pte = pte_clear_uffd(pte);
> > +	}
> Does this unconditional pte_modify() create invalid clean and writable PTEs
> for shared mappings?
>
> Without checking pte_uffd(pte) first, this blindly modifies every present PTE
> if the source VMA had RWP enabled. For shared writable mappings, vm_page_prot
> includes _PAGE_RW. If a PTE was clean and mapped read-only to intercept the
> first write for filesystem dirty-tracking, pte_modify() forces the write bit
> on while preserving the clean state.

Two reasons this is safe in practice:

1. RWP cannot reach a backing that uses the clean-RO + page_mkwrite()
   dirty-tracking pattern. vma_can_userfault() admits RWP only on anon,
   shmem and hugetlbfs (the ones with vm_uffd_ops); regular file-backed
   shared mappings are rejected at register time.

2. For backings that *do* support shared writable + dirty tracking (i.e.
   the ones RWP isn't enabled on), the fs sets vma->vm_page_prot to RO
   precisely so the first write traps page_mkwrite(). pte_modify(pte,
   dst_vma->vm_page_prot) would not add _PAGE_RW in that configuration
   either.

> Hardware writes could then bypass page_mkwrite(), leaving the filesystem
> unaware that the page is dirty, and potentially causing silent data loss
> upon reclaim.
> Could this also overwrite other important PTE states like NUMA hinting
> or soft-dirty tracking?

pte_modify() on the supported architectures preserves _PAGE_CHG_MASK,
which covers _PAGE_DIRTY, _PAGE_ACCESSED, _PAGE_SOFT_DIRTY, and the PFN.
NUMA hinting is encoded in the protection bits, so a transient hint
state on a resolved (no-marker) PTE would be lost across this rewrite,
but that's just a re-prime on the next NUMA scan, not a correctness
issue.

> @@ -298,6 +298,16 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
>      else if (uffd_wp_resolve || uffd_rwp_resolve)
>          ptent = pte_clear_uffd(ptent);
>
> +    /*
> +     * The uffd bit on a VM_UFFD_RWP VMA carries PROT_NONE
> +     * semantics. If mprotect() or NUMA hinting changed the
> +     * base protection, restore PAGE_NONE so the PTE still
> +     * traps on any access. pte_modify() preserves
> +     * _PAGE_UFFD.
> +     */
> +    if (userfaultfd_rwp(vma) && pte_uffd(ptent))
> +        ptent = pte_modify(ptent, PAGE_NONE);
>
> For VMAs registered with both UFFD WP and RWP, could this silently upgrade
> Write-Protected pages to Read-Write-Protected?

VM_UFFD_WP and VM_UFFD_RWP are mutually exclusive per VMA. The combination
is rejected at registration time:

  fs/userfaultfd.c, userfaultfd_register():
        if ((vm_flags & VM_UFFD_WP) && (vm_flags & VM_UFFD_RWP))
                goto out;       /* -EINVAL */

and re-registration cannot drop either bit (also -EBUSY in the same
function), so a PTE in a WP-armed VMA can never satisfy
userfaultfd_rwp(vma); the new branch never fires there.

[ ... ]
> +        /* Re-arm RWP on the moved PTE if dst_vma is RWP-registered. */
> +        if (userfaultfd_rwp(dst_vma)) {
> +            orig_dst_pte = pte_modify(orig_dst_pte, PAGE_NONE);
> +            orig_dst_pte = pte_mkuffd(orig_dst_pte);
> +        }
> +
>          set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
>
> Could applying PAGE_NONE unconditionally to newly moved pages trap
> applications in an infinite fault loop?

No -- the post-MOVE access is delivered as a normal RWP fault. In sync
mode it goes to the registered handler, which resolves it with
UFFDIO_RWPROTECT clearing MODE_RWP; in async mode the kernel resolves
it in-kernel and the faulting thread continues. There is no loop.

The semantics here are intentional: a VM_UFFD_RWP VMA has the contract
that every present PTE is either an active marker or a tracked-and-
resolved PTE whose next access will re-trap. UFFDIO_MOVE into such a
VMA must keep that contract, otherwise the moved-in page would be a
silent hole in the working-set view. UFFDIO_MOVE has no mode flag for
"skip protection", by design -- the same way it has no flag to skip
WP arming if dst_vma were WP-armed (and the equivalent could be added
there if we ever decide UFFDIO_MOVE should preserve markers in WP
VMAs too).

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

