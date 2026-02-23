Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B788EC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0AA6B0089; Mon, 23 Feb 2026 14:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760D36B008A; Mon, 23 Feb 2026 14:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639106B008C; Mon, 23 Feb 2026 14:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 482CF6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:41:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF1698A98A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:41:10 +0000 (UTC)
X-FDA: 84476739900.02.4EB0247
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3DFC01A0004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:41:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HHE7diwS;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771875669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxHdHRwYL/aoVCBqMt4jHbwwJS5dM7pxvVOEzBVUDGE=;
	b=DXViZItfHiofTcMNJu2UarL6DFeVnQQkA9GK19pxxXk35RrNbh6j8gx1dFf0y9JNTAXxti
	/DMCIZ9pMLmegV2OCKuKq4AK2gImzV6gHDZm9X24dr7vLz0QncIkeQp4pImbiOehEeJR9/
	RMziNN4msT/kAAX/Ik68mWMQuVsHZ7w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HHE7diwS;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771875669; a=rsa-sha256;
	cv=none;
	b=KLKjQSJAHoHsz7HQEOXitA8767+tAzCaqw48QnU+mrz5IRZPSuAb/PbpekHwtlCnM8njy8
	3/y+XiiyRq9fd7DL05yJ8SdZ8gOxMeS5PxCfThZKUy9CvrGWZBEm7TH1UMCw1GXTD8Ejy7
	2NSCe6Ep359vIpQZwd8L+r5eXznrtq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0851A41A8C;
	Mon, 23 Feb 2026 19:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8185CC116C6;
	Mon, 23 Feb 2026 19:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771875667;
	bh=WEA6P95rkpZGExTdoo0RdXuU9UiczYMaZDEepqmmNf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HHE7diwSspbMM7gFWFYKCy8L8ucllyJCnYSvp3iCleZ1TGGXI2au3miXIunOKIsJ+
	 VBDHHzqtvSaMet6brn85yJfH+ndBeWY2y4uqBzIxb8dno1e3MfFjQX6Gc2yjDyIxSP
	 pBA86kZeTw5qvbxPYqJaBLHt/9WEWufkPKOEqM+K7zVMGGe1f4G/Kqvl5ts4IeFIZr
	 qszRyR4+lO2yG6+Clh6gDC+tt/IavaWv8EGjzPasQgM8umTyGCAEVhaQiAGuuwzQPL
	 7QcSsNYgrrxCHge0KyVDHNl0ha1DYW70VaWBP6Kq9iNSPldoa66XNX1nIeg5G0ijvw
	 elPrtlC69zfwg==
Date: Mon, 23 Feb 2026 21:40:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH v3 24/29] arch, mm: consolidate initialization of SPARSE
 memory model
Message-ID: <aZytSwzGj24lqkLU@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-25-rppt@kernel.org>
 <20260223144108-dcace0b9-02e8-4b67-a7ce-f263bed36f26@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260223144108-dcace0b9-02e8-4b67-a7ce-f263bed36f26@linutronix.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DFC01A0004
X-Rspamd-Server: rspam02
X-Stat-Signature: qcc188ws5mcn58wxe8haktxnnrx7xgy7
X-HE-Tag: 1771875669-322703
X-HE-Meta: U2FsdGVkX18r2tpAxS6AFnKPagONQvdUG9thVbX+4CuVLWW6ZdLgOebCahwMcSo7Dwi/5xcry2DGAfWNJj3l2+jKmh5hxzvEBR1mRScxGUF1UQUSZAaqaH/9XF1CAutlqKAMHyEzF8qRcCuvoOEdDAW+O7DBZU/TIkyI4n74f8UaxUwsqL0nzLUOiWtckVXbaY4HaFnYlUggkid4lSL2aH13YhbKfHmTwPK0nPOo1Jx4yWguIcSzwqmITc2CNNw6KlnY8bnNwaRs4tcx1Msc8xtPCd7UwM6e5WH0oMqQPDNfbEVWzYfwwyibe7IpR+UGKE8M7KoQocftBjnLi9LJwBfedGnZ5b4CwTLVBHNKMVOmEYy4D1SwZeksrHaQ+y2rnjPAZAVC/2XJmCvRn5Ssb/jzs7d65wOV6NQWLjxvENNCOE7cPtlRhGDABrjJp9mfMbrdWjQb3E6uu8/KFiiWnANVG5Z/E2RAAqlUObpBaFoNnIN2U1uQG3dtfAKtPVs5IZ7C2frrrOeXvW5V34LX6foJmmDbhc0ep4MHW1ZU8lni0n8VQjLT4KDpwNN7cBSDf+iHd/G+aHSbqHRHO5UDLvYWCQNiKu40b7I+AG5/+kP0TDOnz0E7yVmf0EWBAicRhMSojSuXUdjeTbFaM8SooDZ0RHTi9r+LmDsxfMGCiBA7DAUKVZvEQEeG+Mx1a61Sa9eVP7uTP03zYfFE1yUQt1G19vq8SWcTO7RAzhn+fa6E07ITfKQTe8DhXKSw8km3sdjtIn04Kh1WP1iYI15edqmzHq4CO7oKfgJ/Ju3cbkqtAwpjiV6TOacL8A/q9EfzJlnowlG1WbdT7ylRokaHLTunrep7A2ARNYBRP9Atw8wd6B7wdVkpBwbxZ7O70KFfseJcsx1WY7i5OVAGPpVyZe3F9Q0Oj92jO7Ji2qcpalrksoWN5ilQCNUsNKhAHsi1IuMgAXz/fDTNViKJ8Fz
 rOIFgUBC
 2qA1AJ4zS/39jS5n+Ak91VqOFTFrx0CXIohNEpHIF8jF6lvsfrIX1zZTiO5t5RgeuMV0uUQM+IxY6GOBzFkDAzPpAG9MKMOfUeA4yDdpfboBE4zHfdufIYBO89/ARGkPPJRSteidIW7WHLr4thiB1DOt2dU1UHXo6OEKkulxdAoqo8MVA8p0aCe6p3w4H4zEusqUfZu6WZvRvFxPMpOamJ0MPmrEb+vdDhEpmjHSxL18dFzy/fwyItn4LPGhAo/QWLbKGA3OvrsWCi7JCnCmacw0fIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

On Mon, Feb 23, 2026 at 02:52:45PM +0100, Thomas Weißschuh wrote:
> Hi everyone,
> 
> On Sun, Jan 11, 2026 at 10:20:58AM +0200, Mike Rapoport wrote:
> > Every architecture calls sparse_init() during setup_arch() although the
> > data structures created by sparse_init() are not used until the
> > initialization of the core MM.
> > 
> > Beside the code duplication, calling sparse_init() from architecture
> > specific code causes ordering differences of vmemmap and HVO initialization
> > on different architectures.
> > 
> > Move the call to sparse_init() from architecture specific code to
> > free_area_init() to ensure that vmemmap and HVO initialization order is
> > always the same.
> 
> This broke the boot on RISC-V 32-bit (rv32_defconfig) for me.
> 
> Specifically if sparse_init() is *not* called before the following callchain,
> the kernel dies at that point.
> 
> start_kernel()
>   setup_arch()
>     apply_boot_alternatives()
>       _apply_alternatives()
>         riscv_cpufeature_patch_func()
>           patch_text_nosync()
>           riscv_alternative_fix_offsets()

Hm, most architectures do alternatives patching much later in the boot,
when much more subsystems (including mm) is already initialized.

Any particular reason riscv does it that early? 
 
> Simple reproducer, using kunit:
> 
> ./tools/testing/kunit/kunit.py run --raw_output=all --make_options LLVM=1 --arch riscv32 --kconfig_add CONFIG_SPARSEMEM_MANUAL=y --kconfig_add CONFIG_SPARSEMEM=y

Looking at patch_map it's quite clear why movement of sparse_init() cased a
crash:

	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
		page = phys_to_page(__pa_symbol(addr));

phys_to_page() with CONFIG_SPARSEMEM=y will try to access memory section
that are initialized in sparse_init().

What I don't understand is why patch_map() needs a struct page for kernel
text patching at all, __pa_symbol() should work just fine.
And the BUG_ON(!page) is completely bogus for phys_to_page() conversion,
because that one is pure arithmetics.

If moving apply_boot_alternatives() is not an option for riscv, something
like the patch below should fix the issue with access to nonexistent
memory sections. But I think moving apply_boot_alternatives() later in boot
would make things less fragile.

diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index db13c9ddf9e3..89b3c13f2865 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -43,18 +43,19 @@ static __always_inline void *patch_map(void *addr, const unsigned int fixmap)
 {
 	uintptr_t uintaddr = (uintptr_t) addr;
 	struct page *page;
+	phys_addr_t phys;
 
-	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr))
-		page = phys_to_page(__pa_symbol(addr));
-	else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
+	if (core_kernel_text(uintaddr) || is_kernel_exittext(uintaddr)) {
+		phys = __pa_symbol(addr);
+	} else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX)) {
 		page = vmalloc_to_page(addr);
-	else
+		BUG_ON(!page);
+		phys = page_to_phys(page);
+	} else {
 		return addr;
+	}
 
-	BUG_ON(!page);
-
-	return (void *)set_fixmap_offset(fixmap, page_to_phys(page) +
-					 offset_in_page(addr));
+	return (void *)set_fixmap_offset(fixmap, phys + offset_in_page(addr));
 }
 
 static void patch_unmap(int fixmap)

-- 
Sincerely yours,
Mike.

