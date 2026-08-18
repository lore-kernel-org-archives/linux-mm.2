Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BA8C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BF86B0593; Tue, 18 Aug 2026 14:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A638B6B0594; Tue, 18 Aug 2026 14:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0546B0598; Tue, 18 Aug 2026 14:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA3E6B0593
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:42:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6ED980244
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:42:18 +0000 (UTC)
X-FDA: 85115260356.13.6F3FD90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E606140004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:42:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjzkzA5c;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787078537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DV5Xiy/AmYlLlBBUlANyFhMnUD/qJF7tkMdEBI76djE=;
	b=odDXrezvxfYtOlAREej7CNDfaWwsr0rKGUABob9xXowpHmKLNeeFIfJ4FZ0WzehJrVxZO6
	/Ba6psdCLeqvMmhC58pIdWSp7Y1Ln4iySrlojWU1cXoFXzC/ILh33lZExDyjdohOnltpGr
	nghK30Deg/e2yo5rnbv7IUBOk+B2giY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjzkzA5c;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787078537;
	b=ym92e03715M3BQmH0IZ/WP6TCvgtIhOzEqJQW3ONhAUVqjawfqehV/z8s+unxv4S+ZcDly
	t320/EkoEo/cWuwdXpFh4fF2Zl+ahxpjKdQdcOdmT8htx0dFvFyTKC/J2157UeIX2abbgp
	x4ms+CSgmtaEGvASJNg61hCuZTRU5FI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7881F42DB1;
	Tue, 18 Aug 2026 18:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F17B1F000E9;
	Tue, 18 Aug 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787078536;
	bh=DV5Xiy/AmYlLlBBUlANyFhMnUD/qJF7tkMdEBI76djE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bjzkzA5cyjcxb6jvIbL/KCjgThSfC4YBnQRMhTomD6xhGLADPUzVSD/wVbTSD7Qbn
	 2Igf6eAFgtxhjB2K4PDpnwl0C1Js4HyZiz6nnnyQT3DTYqQ3JGbppjmDzh4OrDIsVw
	 0NPBiGbZUr9HL/pia+wDl3eRS+uUgadkU4A6AvnJ38/63WPfTViWOydhKK8zRqvbS1
	 O5XVJVR6oE+KUYjcwJaqrQzJoLwyjKTCtMbNXQaeHUkmwwRvx+XDKq8sKuWmCtW/5O
	 nWk6vEQx/5pAHpdfjuMPWXRUhh+3HLLLddrJk7nKVtFfT2Euc7yIFzGy/TiBhObUeP
	 5zNkANsCpk5ig==
Date: Tue, 18 Aug 2026 19:42:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org, kasong@tencent.com, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 02/12] mm: add PMD swap entry detection support
Message-ID: <aoSmlTH8e26xAYLp@gremlin>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-3-usama.arif@linux.dev>
 <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E606140004
X-Stat-Signature: 1s9apm4rjk8g1jt15wqxq7tnw453sgm9
X-Rspam-User: 
X-HE-Tag: 1787078537-614115
X-HE-Meta: U2FsdGVkX19xvK6F15m4NugSIDnb9Fard3lBvadSXx/Ste2CKw8xBGv4kmueTDuTkHi1PpMtsh1m1fuBPODbLIeYYxcqsOhrw2nbKWWXQo3kPpO8JgzYbCkMH7++7X8yKL11jIvdN7cA5e9TxjSmcmdoYwusGV3PM/bSvpxPWwp4ye30xWBeBjgRRb+hyEGTFd4mf1R/oqGs+xV/YnuWOM7D4uEpcHceORu7nbJwGljPiggBD3Uvnz/U/OCJGnFlT410RSvaA1sJdMN4wilb9RAbeqVCypyvLTV7MASlsgsz3tKKp5j8ASft+qb1n+sVwvoBEiqF5/Z9ofCorusbvxPXYPuNxQFGzWmGKx4RKCYikTGKuvmSd1OpFGk/QolQ9mFCl6/9zmgqVOUTq5mNUSo/SDS13qHtUO9GkTYErCPyXNar6HfHD+Ogeld9rvasWp/SVcTe4301SUUPLKyNMedtyM6T6TBNSsz0fxdCrBT7d47I4BVk1ANJyZ9BsZiZAQ8ohXIYIV4aBgjoHpBOgJYDBGebIfnibA/TJ2ALWl7XTZD6aXZGHO6mZhjXxFTTQKXIFRtBHptRIabO/XgwGCcp1geU2SwEhe4/WDxCX6Qrt4TVwbMO054kLMwJHdy2mWEUw8Vl9fn3+fwFtRo62hj4DMinlt3wzGx4n5VKwPcWRfME3HCOLRW0E6DUoiFS6DF+UPDlxJbiDrFWjp88nfE+T4XdJQU9xS2/DFWqr4D+jnDdu1nIiPvO4iFJk/LhWBbNhUVeWSZjoORGm6IsqWtuGzUMYJx5zW5k7UNhLbfBee+TSQT4Ubki2rxdcz1JpeqTYQlJOlkAfNbkRwBAdi5hTi91V2zBvheG6iB+LarfeA4nQjR9diYg6uoxacj/GdtWgdSPzw0gVZOM6Rxix7g8r667debiFUtqgYUtHzJn83HienQT927OppM7cXbbfqMXXWHepUMJBQvA/hR
 LKF05BVR
 QgEuw1J5QYPuiPF6Dxd3OcJn0i0ir3fuH8HSTt5PMV/CQu8jfmcZqUZ4+LZIJjAXzct6LX8ls6TGVmGs94sW0Jrn0Ac/NvvZsszGX/MAZBd9I2zf2L1lzR6c2E+9OZ08CeOK6IyttjZGPvAjrJIEGjTADLt+k1UkTb3O1ce5AWsjTvYf5vOXCBPcLT6IWgFsSHQpBrO2ucBQXyNXUGdhMaGqeBTAxaiNXnDPIECksmeKDPu+M+tF4IBTlc5GAxmvgpnm9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:40:25PM +0200, David Hildenbrand (Arm) wrote:
> On 8/18/26 15:09, Usama Arif wrote:
> > Currently when a PMD-mapped THP is swapped out, the PMD is always
> > split into HPAGE_PMD_NR PTE-level swap entries. To preserve huge
> > page information across swap cycles, later patches will install a
> > single PMD-level swap entry instead. Add the infrastructure to detect
> > those entries.
> >
> > Teach the softleaf layer to recognise PMD swap entries:
> > pmd_is_swap_entry() detects them and softleaf_is_valid_pmd_entry()
> > accepts them as a valid non-present type. Because swap entries do not
> > encode a PFN, make pmd_softleaf_to_folio() warn and return NULL for them
> > instead of passing the swap offset to softleaf_to_folio(). Clear the
> > exclusive overlay bit in softleaf_from_pmd() before decoding, matching
> > how soft_dirty and uffd bits are already stripped.
> >
> > Add pmd_swp_mkexclusive(), pmd_swp_exclusive(), and
> > pmd_swp_clear_exclusive() helpers to each architecture that supports
> > PMD softleaf entries (x86, arm64, s390, riscv, loongarch, powerpc),
> > mirroring the existing PTE swap exclusive helpers in each arch's
> > pgtable.h.
>
> Ah, for migration entries we still use a dedicated migratetype. I actually have
> on my todo list to move to PTE bits as well.

We do seem to have rather hacked in PMD level stuff across the board
previously :)

>
> (likely the _swp_ part should then be renamed to indicate that this is for
> softdirty entries, not just swap entries)

You mean softleaf?

>
> > Provide generic no-op PMD swap exclusive fallbacks for
> > architectures without PMD softleaf support, matching the generic PMD
> > swap soft-dirty fallbacks.
>
> No softleaf implies to migration and no swap, so this would work.
>
> You should extend mm/debug_vm_pgtable.c in a separate commit to test what
> pte_swap_exclusive_tests() tests for PMDs.

BTW one thing I should maybe mention here is that I never quite _finished_
the softleaf thing, so there's some awkward overlap between swap stuff and
softleaf stuff (swap entries _are_ softleaf entries, just a specific kind).

Infinite TODO list etc. (maybe this is a hint/nudge to somebody else to do
it ;)

>
> >
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >  arch/arm64/include/asm/pgtable.h             |  6 +++++
> >  arch/loongarch/include/asm/pgtable.h         | 19 ++++++++++++++
> >  arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++
> >  arch/riscv/include/asm/pgtable.h             | 15 +++++++++++
> >  arch/s390/include/asm/pgtable.h              | 17 +++++++++++++
> >  arch/x86/include/asm/pgtable.h               | 17 +++++++++++++
>
> I'm sorry for asking you to compete with Kiryll's series by creating one patch
> for each architecture that directly jumps at arch maintainers :)
>
> [...]
>
> >  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> >  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
> >  {
> > diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> > index 7c13c58a5e218..4a6c52974b305 100644
> > --- a/include/linux/leafops.h
> > +++ b/include/linux/leafops.h
> > @@ -102,6 +102,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
> >  		pmd = pmd_swp_clear_soft_dirty(pmd);
> >  	if (pmd_swp_uffd(pmd))
> >  		pmd = pmd_swp_clear_uffd(pmd);
> > +	if (pmd_swp_exclusive(pmd))
> > +		pmd = pmd_swp_clear_exclusive(pmd);
>
> Can't we just unconditionally clear these flags?
>
> pmd = pmd_swp_clear_uffd(pmd);
> pmd = pmd_swp_clear_exclusive(pmd);
>
> Avoids these rather unnecessary conditionals unless I am missing something.
>
>
> >  	arch_entry = __pmd_to_swp_entry(pmd);
> >
> >  	/* Temporary until swp_entry_t eliminated. */
> > @@ -634,18 +636,30 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
> >   */
> >  static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
> >  {
> > -	/* Only device private, migration entries valid for PMD. */
> > +	/* Device private, migration, and swap entries valid for PMD. */
>
> Can we just drop that comment? I mean, it's as clear as it gets in the code
> immediately below :)
>
> >  	return softleaf_is_device_private(entry) ||
> > -		softleaf_is_migration(entry);
> > +		softleaf_is_migration(entry) ||
> > +		softleaf_is_swap(entry);
> > +}
> > +
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

