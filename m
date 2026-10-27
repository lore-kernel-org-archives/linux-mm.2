Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA60606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLH/Tvkc
Received: by kanga.kvack.org (Postfix)
	id 164D66B0779; Tue, 27 Oct 2026 10:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115DB6B077B; Tue, 27 Oct 2026 10:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B996B077C; Tue, 27 Oct 2026 10:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEB5C6B0779
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:08:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FC33A09C6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:08:30 +0000 (UTC)
X-FDA: 85368586380.24.93B7444
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1BA2A4001A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:08:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mLH/Tvkc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793110108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbvGWJmf9YwWN00g1u/NHLatne7a6bJt0jiNry4VqD8=;
	b=HmN/QHikdlkBDxnUtCE2Wghi69TLMkP7jqYvYe+2uSru6FGljEPFTgoWoExlnN9eq1ujg0
	x/y9kYLIUu09/5fZmgDbDRCC5wpuytVi0zTP+miXpgBOVi88Udo489SAxdOd8uf2xgngiW
	yekYF7zPHgaXkaMy1f0EkmkH3A9RZg4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mLH/Tvkc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793110108;
	b=TaMbltrVk8oR5VshYOcjqCttpQVWbN8J9omle0dwdPcQHk3iBVnvd2iS56/n7pc40+i4CV
	qVjbJAe52oDViOF7C7l4b1olcZ2Hr2f0teYjO00gHgZV+tE7Yxz2IcsnalJY0B3TlTfPEW
	vZt6Fiyi1bu8yWtAzy9jOf6xF82p6DU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8526A60218;
	Tue, 27 Oct 2026 14:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4301F031E0;
	Tue, 27 Oct 2026 14:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793110107;
	bh=CbvGWJmf9YwWN00g1u/NHLatne7a6bJt0jiNry4VqD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mLH/TvkcbPJ5pX+EjBJOwjRTX74u6eNmAvjU9QfleDiVHjaVjQW/UQou30MulrOxj
	 jToXXyijxOB6MGesqEn7wu9ky5T8zw86VlRcsgKAnpYqYNkDKNrV6WE/Z8nbpCvEfZ
	 lO19Saq3/9HbIkvTIRHU901td+3nILEzJ/Gr/WAPBSpbxNJbFujf3z9Br1/D4YByki
	 3RRrOcQ4fNSbdoc4nJ2hs6Lf7+NnSiUPF3Tb2rYJ6ge5fQSMQ80AyBQhDFy+VhWIJu
	 8TL/npIiy1WUyq4OObCMLtpqBEnh8iql8u0bu3P4zLEUlretOIC4LadBPf4u1zanll
	 OH7d9xyxmpb/w==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 263961980047;
	Tue, 27 Oct 2026 10:08:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 27 Oct 2026 10:08:24 -0400
X-ME-Sender: <xms:U7DgavnxdSNtUxqaNd3ZPHA-GgqWp0ak_-5ObLq_rxP4hAiTlHOoKg>
    <xme:U7DgahvkmRPPsHyleWajOnL83T8ou18ct43iD-MVEmfDhiGNYWj7adNpuXMgzcSvL
    h-Aib8Gkk3fFuJtkkdHHLlzGDYFt5FEMK9Xn7XjtbUpLHkRz6o9QzU>
X-ME-Received: <xmr:U7DgamDt0DMoMRD9ALRRPZ69IGo-7jn5OsY2yyrJLpMhj7CGSymFsXIejhg>
X-ME-Proxy-Cause: dmFkZTEaZA2PaW1k67BxuO7K43FLH0AXzaKFjjKJfwu/KpGOFsmjjz9GSuR+5Cg+oI7dZA
    8BXp96hrgxr8G83eICbVIuq3GGRRXyrwDLmbW5B80ASp3E45NdoC/6iVPRbMkGsI5q7/3F
    T/g200QQfYlzbcx2nKjkpGdEmX7ucWHHKtmchRf9OkWPEt+EEpay6nygL4fJYyKb7W+qAI
    nnRokAmwK7V8GxQtulk6RfB7RjPcJAnuFWyVrb3qEDbKJeUsNsxtS0j+Q49GQ8esgGy3V4
    ZmsVBdUTtK1knjxzJbTbkJX1GHETc68pBeGN/x1WbGSyB4OKk1yN7DYa2iMaIpVnzTIslT
    7aA4dhG3GVMCk4eZnUELWNFF4UCcuoeVpQmaHUKgefcK9w4C4Fz6Xfyz1MXvkM+/i/gpv/
    wBnbicRBljlVlfuS5RDXoX/VTYAjKsd0JUJl0skwrZ0+MYdjfRy9CTdoATnXysrrO8qD48
    ApJmhXkDd/lBtfES8tOCo1i9zCfzVj450Dq23/37fF1tv1GUAZLrsktJHSdjL7zr28Z1ac
    S4BhWxDe++Qv8LvAK0GnXF9RoJFURWADYIzEd52HXcM6KX9aBC7rpJZnJZNEdRNln4q3+U
    PMKz0qtlHCAmXs1bZFdjhJBbn8eFOnfdZUQFqf5iyvcczuw2MU6juU0LijUg
X-ME-Proxy: <xmx:U7Dgasla_gR8q-sI-JNR1LqZkQT_nTfLQl1cHRv6T4W4Ake79iTPUg>
    <xmx:U7Dgavj3xzu4vBZbB51HVdp4cr7W5e3S-oo_c-kw6mfh46R1sa5L_A>
    <xmx:U7Dgalty37v8Eg1mkg7bNhiCDj1BSRmb1trVWEo2bwPQFkPmtlNaOg>
    <xmx:U7DgamBSPtDBwLyo5fZ2kF7cR9JCXEkjyH8DP8ww1lZzUQy3zWuzTA>
    <xmx:U7DgagVwQ30ZdR7dUwwj3cSK-abW5nEmNfwTYvWuLxrxaHMCSBiyglPP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 10:08:18 -0400 (EDT)
Date: Tue, 27 Oct 2026 14:08:17 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	kvm@vger.kernel.org, =?utf-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 2/4] mm/huge_memory: copy file THPs at fork like
 copy_present_ptes() does
Message-ID: <auCwHD83jRCtt8Xo@thinkstation>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-2-66f00b7a564c@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-2-66f00b7a564c@virtuozzo.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1BA2A4001A
X-Stat-Signature: smksntz3equc1qxrxxmbjcznjz4m1ssp
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793110107-966803
X-HE-Meta: U2FsdGVkX1/a7VhMbMkNaXC7+3J7zoAuPmU/QR7IXO7at+f2bhUe0c9wG5BPBhCTJtPx+3aLBr27hgZqm24/GcqhNiiT5ERgsc96oIMJRlcKZOqfKscoHER3HKNbZuccsaByrzSz/pKoDGYBkbkN3fJIkiuEHoW159eQ4KwPlNFI7SIXme3yLKozSIRTiEzWwevUZvuaWKqIvOOWDoBwVfi5C7LlCs4Ek2ujtgN0kQt8cyHNWU5V+qRalW2RaSmZPL1B0n3uZIknVEYfHSS3TSB+TrC/LEAkIiGWvNrYHj1Diil/PweLw+aD1IgRkC5v1stgvSRbJO3570bTZPlBepGmp81V6yJvtmJRw7B4KBSEQ8wMCSjT6ECjF/GNRoiKbOqqXgkULdufSe+H8kg2y0KRyV98m5nBUExBEZWGD5K6k7YprUX1Phni6rBllDXWfw0De1qW2Kosi5IULzJGUiMN4eB27obI/Q+vvDl6+J8wzVZl9XlPStt7bRKbFqR2PBo/uTJpTTrgYELwMOGTd/DtbKtkTWmKZXgsm4yl/H0D6f12fDtpi6JffEFiWPCstpO16r8uZt6J5v9k2A+UML/yEQ5rXtxGUEzcDUTPl6iyiqoeN5CLV0CcBdyJrUkR0zQHaDWR9IXA0bxlCXcJsKvpqnBicXBEiGF7eypDt3Veqhc/+qUQUYQKGD1/Nq0bjPsFRdSe8KybO+ujZslRc0UokS1Jil2QsOuPsEers38xLZ6A/oDObitM1so9rS9YOf5kRcYmEJza5Nc4Xdu1CV0g72Jn2H2+gfNplXzw3HkzBo8oeZSfREVYGbGqyS1IjYfqHZWbsjKQvt06KzvIS/7BniEdYZSGJmg6W7U08znduxJPwsbPo3L3UbD0lugopkAWSAipD/Uj9/S46603NN5rBDDe8uCxJQUmjnwUjhluEkNVSDQxP3m/15Ymz+3tjikMZlBFECtqpK3qGHb
 m7al9uPj
 bhSdpGLifLzdJWzIbi+mg8oN23xG2rSMOSJokUenEMIyfFeHiusuuxNewTGgaCwwnRXJNif131YTcmmaxNHom9uzFvJrmTvPa8lolelOBHX4mIHZ5psTEHu4nNTHsUhXg43NMWL/qG75BIWb7r+n0gevZC+nyEIzgv7NiEKbvShsxNacocA/ae1UXGQQg6FQp9SWwGQ8TFJGeONy9D6X9GGykwiE73jfK1t3+Cdhm3FVEeLr8gXeKqjvxM74K3Lzg+5rajKQIpM5FamdgR362PPqWR14lEvuGga0zvX4wC14I36oWF4nIFl+a6ogsCEKYOzmZ+NzK9NdXQi5qGxqsWWDGfM9u5TjjSu25ZZ1VE66cbOGSz1Mv0ZUwoalFubSqk9ey/yGgDRfdKCsB0tZovjKNZiqx9Hbb81/6omkz2Eyi4Ln7V0GkCfQXg5XDHhDbOClAap/Z5FjWmc5t1tY0W2Y6Mn8DNxZf3c5SG1bDoALjz9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:36:01PM +0200, Konstantin Khorenko wrote:
> This fixes no bug: it makes fork copy a PMD the way copy_present_ptes()
> copies a PTE. Until now copy_huge_pmd() skipped every folio PMD of a
> non-anonymous VMA and left the child to fault them in again, while the
> PTEs of the same VMA are copied.
> 
> Treat file folios as the PTE path does: take a reference, duplicate the
> rmap and account them. fork then pays a reference and an rmap update
> per PMD, and saves the child a fault per PMD it touches. The next patch
> sends PFN mappings through the same tail.
> 
> That covers the VMAs vma_needs_copy() sends here:
> 
> - private file mappings with an anon_vma;
> - VM_COPY_ON_FORK ones: uffd-wp and uffd-rwp, VM_MIXEDMAP (fuse DAX),
>   and VM_MAYBE_GUARD, which shared shmem, file and DAX mappings get
>   from a guard region.
> 
> The DAX huge zero PMD is copied too, with a reference taken by
> mm_get_huge_zero_folio() as for anonymous VMAs. A migration entry of a
> file folio is copied and accounted like copy_nonpresent_pte() does, and
> made read-only in both processes only in a CoW mapping.
> 
> The copy then gets the same tail as __copy_present_ptes(): write
> protect both sides in a CoW mapping, mark the child's copy clean in a
> shared one, and drop the uffd-wp bit where the child is not armed. An
> anonymous THP is now write protected only when its PMD is writable, as
> a PTE is.
> 
> A page table is deposited under the copy where the fault paths deposit
> one: in anonymous VMAs, and wherever the architecture needs one.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>

Okay, I see benefit of aligning it to copy_present_ptes().

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

