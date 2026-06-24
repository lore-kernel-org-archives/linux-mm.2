Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D6CFCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F9F6B00B5; Wed, 24 Jun 2026 11:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7456B00B7; Wed, 24 Jun 2026 11:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26FA6B00B9; Wed, 24 Jun 2026 11:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92F2C6B00B5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:21:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3F941C1CD6
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:21:37 +0000 (UTC)
X-FDA: 84915170634.29.CC235F7
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55328180008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:21:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HNCXnnkT;
	spf=pass (imf06.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782314496;
	b=H0jejGv3PGmctaZGdWJ5clO8eZvQ27fInllyMcTgFd+bv4CT8c0ciyGAT2xOq37FbiWAoI
	l1DmgS/9fPmR9kyEonU90VBndhSBzHvFnnKgeXvFT4guuX8H0k1+i5jaEDygVYJY9P8pOs
	t9oy+Q8Kt7I06bpwyAdJeNydtkpG2R8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782314496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLPUSysPsLS/lTKrhCAv+kKmeICUhhnEXQzcaQ5iT/8=;
	b=hN+CG4rO0ZwHxQulzU8JbVVMkwUosxekUdCaQnSSoFpFtjH+OplYlGjlW8jfvPTXWBzPUf
	cmKIduP549DvE4AbSQblBIJL4upkVCzwWWLj+LU1DFi2nR3UG7Orh/BbvX3ypL9OUiIUqE
	0VCfT44lp3tu5VFh9pCxVchg1FrF6j4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HNCXnnkT;
	spf=pass (imf06.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XLPUSysPsLS/lTKrhCAv+kKmeICUhhnEXQzcaQ5iT/8=; b=HNCXnnkTcOqmURs4era2o+oyPQ
	R95RjQgQp5Gd46soX4YTZnI5PbWMolzSfvvdQxwIRQBO71SbJtSF20kWYfSBJA4aaq0r4zZ4U0R88
	RHrr1xF7FY5R57GV3Lt/E/wz6FA8wH5cTJltnIxJHFr6ppD3OGW+n9DAJZ0jMPWJ5qjyChrkjEzmO
	a/sZ6e59LSjS6zFIMHob8/4mFgm2n5jsaq6nYH5Upamqj1H8mA+MEkcKTBX2fBiqsUXLPwGzfzvBb
	4OqN27CfeKikgqU3rmspDNJI6ayK2dZRBc+O0jOGnCRrdZKt6h1sU+dxBukVj3FIuXj5TzhSB/UfT
	4oiuOXZA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wcPPl-002W2H-2I;
	Wed, 24 Jun 2026 15:21:21 +0000
Date: Wed, 24 Jun 2026 08:21:16 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, nao.horiguchi@gmail.com, 
	linmiaohe@huawei.com, david@kernel.org, lance.yang@linux.dev, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, pratyush@kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, rneu@meta.com, riel@surriel.com, 
	caggio@meta.com
Subject: Re: mm/hwpoison: persist poisoned PFN list across kexec via KHO [RFC]
Message-ID: <ajvzUg8KK9gtFTYe@gmail.com>
References: <ajut_LDQGYCShApx@gmail.com>
 <aju5_WjBtagTOSJw@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aju5_WjBtagTOSJw@thinkstation>
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: c384cn5idhecqhxfb8hbd3kuaei78bd7
X-Rspamd-Queue-Id: 55328180008
X-Rspamd-Server: rspam06
X-HE-Tag: 1782314496-586504
X-HE-Meta: U2FsdGVkX19QTcYOV4Aszg1qxBEuQ9uGT8fQrBuGafPW360PrhClK6QgLptAXyB3rrpp+kF42AC3FoLFzskMvmuYFyGYJCs6AquFWI5iNvqyjAlZHdRg2CDak1Cx9QfQrw8rGEazBqZ5nz+huVBgv6OlQR5dSxz3SccQ9x41IDaXBDFBNqXvhUmA3365S7Ta+5OgE5cyG+pGPwypErFLAuRef8hxNGki/RHmh1vVLN9pS6SpmpTCFUMg8weGxWbPqBr9ah+KWLmZGiBJyJ4eewMqA60j2aw7QMCkW8h+U9mzPt0EUQBpGat7Up0QrU8XsgTcZsis19wfn4fN++iRk4k0KXXX26BPMtWHJUAPiG2iVkuHZwgVi5GHhQAhsAmk9b/FsxzpVV4VuITI63zc1zVqLYqapHB/f/XMOupu1pxt6b0iq2m4O51OFRlgiQszrihF+CS6lp28JcO8YURxS9+MchxJ1ze89RG6/SeJkd5pFliatZzDeAQ8EeFgOWUtlDum1LLpdl4Mj12L+DT1Eae851OQHpJTaR7FOeRfbkAZG7akfmom6uMNsdxyg1u33VyLas4vREIelNgrl/3LJM59+TM5vsXVMKSOx8YKnlHj4TKfbdAJ6XeU5VBl3GPWHPkBXhB79jjConKBDlhFQSjrIYJnae18Iri9xh04TrdPUbJT5ODJfvVZ9sttzFr9USBB0wYbDZpdzqVu5iti0s0gZ/oeKikTX16qeLMuT/N7QtnggnYgKkzHqV+qIP2M4nW8I7ATdiG/uK/g9SV4PNvgqRpht2vBMbaiGxztVdfpQyOwcO1uqfTOAoNdLa8E5N/pGDlH5/G6DqFjonlg4U532x7hPgAMD9QXciN1VHR8IOfH7FxYwGOu4DrSJ4qcwpwsvLWJ2OXnSwnz5yrff92omzpz/MnaEKAyxsvtkzp1ItzEHDtyx/jjTjXRm+HSe52bd/r4mbdROVDxJi8
 50qQeIsx
 nAzfiBQRGjJai8TuWByVOVZf2gjmau514T7XP74cuPvEiuBUiQxxAvJXog4E+mKJgDzoADcTq0xo3oxXX2KUve2Ygsb/MAwL255Zmf5XRvfLlsJ8zR2GwvxxZYy/nczp36Yzk2f+i43KOpDmvitgEnqMYU8g+VApUuyMxfw7HrG3DMf3npZeqg63rAX3JFDsrBcVGJVmP4LtY5OxREIXV7pQsaiERRK3Wrn5LhR5qxEbNRZdXp2dg5Vl7gpFqh3pd2oqUZg4fYNlmrrLDPR5ZdxNJWE28xPBVcbvB11repEXLEs+9AMX9F+b71YDI14mfITGOS6pc1kB3+gE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Kiryl, 

First of all, thanks for the review and topics raised!

On Wed, Jun 24, 2026 at 01:04:19PM +0100, Kiryl Shutsemau wrote:
> On Wed, Jun 24, 2026 at 03:39:38AM -0700, Breno Leitao wrote:
> >   * Consumer: early in the next boot (fs_initcall_sync, before the
> >     buddy allocator has handed anything out) it restores that array
> >     and re-runs memory_failure() on each PFN, re-offlining the frame
> >     and rebuilding the full hwpoison state (PG_hwpoison, counters,
> >     HardwareCorrupted).
> 
> fs_initcall_sync is not before buddy hands anything out - buddy has been
> live since memblock_free_all() in start_kernel(), and every initcall before
> this one has allocated freely. So this is recovery, not prevention: you may
> be running memory_failure() against a frame already in use, possibly by a
> kernel allocation.

Agreed - that wording was wrong. It is recovery, not prevention, and running
memory_failure() against an already-allocated (possibly kernel) frame is the
not ideal, but, still better than what we have today.

> Two windows are missed entirely:
> 
>   - memblock allocations between setup_arch() and memblock_free_all()
>     (page tables, mem_map[], percpu) can land on the bad frame.
> 
>   - The kernel image itself: KASLR picks its location in the
>     decompressor/stub, long before any initcall. The next kernel can end
>     up running *on* the bad frame.
> 
> So I don't think this should be a memory_failure() replay. The frames need
> to leave the next kernel's view at the memory-map level, before memblock
> and KASLR.

Agreed, this is the ideal right approach.

> > Possible solutions
> > ==================
> ...
> > 
> > 2. e820 / EFI memory map (E820_TYPE_UNUSABLE). Tempting because the
> >    frame would simply never become RAM (no allocator race at all).
> >    But: it is x86-only (no arm64 equivalent in the same mechanism;
> >    this series is tested on arm64);
> 
> (+Ard. I might get some details around EFI wrong.)
> 
> This isn't accurate, and I think it's the right direction for EFI
> platforms. EFI_UNUSABLE_MEMORY is honored on both arches today, no new
> consumer code:
> 
>   - arm64: reserve_regions() marks non-usable memory nomap.

Is it true for non-UEFI arm64 hosts?

>   - x86: do_add_efi_memmap() maps it to E820_TYPE_UNUSABLE.
> 
> And it closes the KASLR window for free, because the image is only placed in
> EFI_CONVENTIONAL_MEMORY on both (x86 process_efi_entries(), arm64
> randomalloc.c). So the bad frame is invisible to both the allocator and
> KASLR, which is exactly what fs_initcall_sync can't give you.
> 
> There's also LINUX_EFI_MEMRESERVE (efi_mem_reserve_persistent()) -
> cross-arch, reserved pre-buddy in efi_init() - and looks otherwise fine, but
> it's parsed too late to keep KASLR off the frame.

Thanks, I am wondering if we piggy-back on this EFI_UNUSABLE_MEMORY (or
something similar), than we don't need to use KHO at all, basically just marked
the page as EFI_UNUSABLE_MEMORY at poison time, and rely on kexec to avoid
passing this page forward.

Thanks for the discussion,
--breno

