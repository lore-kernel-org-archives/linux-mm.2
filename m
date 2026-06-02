Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5274CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 20:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5BAC6B0088; Tue,  2 Jun 2026 16:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C246B008A; Tue,  2 Jun 2026 16:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB5A6B008C; Tue,  2 Jun 2026 16:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9FC6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:34:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E278F1A0106
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:34:52 +0000 (UTC)
X-FDA: 84836126424.26.EB0D758
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1668A40007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:34:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxfxWfdM;
	spf=pass (imf17.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780432491;
	b=37qwy1J0I/0fB2iul37jQd4rX6Ig19sVIQmdaHlRqnR/m55YTtLfllrprQljbEdBmzogfJ
	maBwbgktqvW/JmHlZkmFjuvkZmx78AsBdRkQleZ1JNrWTVOgxf8bjSdh/W2Bc/z91D5Apx
	FYXTrAB1jShTZDc3y5pX+x6z33DMjo4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxfxWfdM;
	spf=pass (imf17.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780432491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S//fEDteJ4rzTnDBScY4eGHQWJlVMyyy6h7anmp3x+k=;
	b=YOhKJBLz75MKYJ1aL9oCungW3RyfMOo//9GBOQV/lCaAE0fo+tkRhyA2tf71ECWIhnWXLT
	biq7QDYdCxg667HoOHvC84Sf5M6qy1a+gSPVgEsEGlse7aH7OIhpRPvzsNZTKMDCapIdhK
	U3jqj83iTkLa8imFF+gqYk3GQ1ytpYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 311214174C;
	Tue,  2 Jun 2026 20:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1437C1F00893;
	Tue,  2 Jun 2026 20:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780432490;
	bh=S//fEDteJ4rzTnDBScY4eGHQWJlVMyyy6h7anmp3x+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxfxWfdMQ3+Vq+Ma03V2QSXlB3XRJ2M5Did8lMtEII0G+3I0Mn+KoGSxk5Mbv0z3I
	 eSifAuVTOlBV98gSsIUbmj8ujq+U/KmlZ/dQP7pUzZjY04CU58Y+sgkwr1wg6evnYM
	 IVoXvJxep7VzxPFXOGANf1mU6ye3Mafv+WmYKvzi7at8qUa+iZFeY7zqiUxCEvZFM/
	 fjusegJTSCUmjBP7CA/qHQtB8wTK8Jc4dadNTvYGMtjatVjBZN4rZEnYKHGBQHPrCt
	 j6I3SYxIA9f1IMqxFo73y3NYXAPu3pvvOvODplkrV/iUNmLrtqWvgusvQ/0MXkcYQw
	 RZn0bqJ/It5Ww==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb+git@google.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	mark.rutland@arm.com,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Liz Prucka <lizprucka@google.com>,
	Seth Jenkins <sethjenkins@google.com>,
	Kees Cook <kees@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v7 00/15] arm64: Unmap linear alias of kernel data/bss
Date: Tue,  2 Jun 2026 21:34:36 +0100
Message-ID: <178041415770.4024555.11336437584927054639.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
References: <20260529150150.1670604-17-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1668A40007
X-Stat-Signature: gw8uhq3s1icmnpukbouikoe717ebd7e8
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780432490-763669
X-HE-Meta: U2FsdGVkX18toZ2+dVnSZQv9O52622gZPNhiHMBn1ncCjQXR5FZ4Icvw0EwM+sdsrm23YJvvcrSadDM6qs2kDDXM44vWcKD2C6KHmHmSwl53N498GFrnNmjcuuhzQf/6nkLbl4f7BeSq1HVoqksGrX7WF7rgXe3aTYqe5fW1JAplpnHVJO9viSDlZq0+tpOOm6IFB0afWS3xyEqrTHN0nIEDyGAnYHIbnFnfZYvDtfShruxETQp9ydbXaYTjO5uu+HSdYhlTLXZGKaFFUuLsYEGdUswSiCPlyZmoxQ27xALB9M+u4N4lQJ1x5ZdAyb0KML44YSgBbab8AQMy7AQNdR6976Cfc3IpRZnRIZRmo2HPdxO+NWtyCpWcm+56TKidd7a0zFzmEWuGZC0anNaIaeiLfH8rwZjg6M3oVrT+x+rKqNZtYnLsxTdVthiwsn6CPLnpvSCvqbCBIWqTy+/CeeFUi6ZX3DlZna2uoa6EzhbC3CEHHwUZRWxQx1P9KezGIljkCLniMK+y0ZP0+/FfQ5IHSYnJ3U8ew3Lw2wAsJ9C6/qO1f0VFu4ZnVZ4f5Xf/wzBT/IMkJj65MwlUGl8iF3bKeTSpgbmKIHiGrewO9jYxBXJrI3srlJ9Kl8f5TGhee02Qj/gZohuC4ELUE0+Mifh0G9q+Btl+OtNu/uVTGFWvDPYZo6n8GUseh3HQ+XBKUAmjLNmZydiamnxpo9FOIP06PpvNFH+a3Y7D20puUoj91zIk/NYOViIqK8WMYHxSqbGktdFJgH8fmBDCqTzpbaN+Zz+m0etIp5sfk4jeyJAUn+5JYCPQJoEIQWEqDWVKkMZiJ83msuaGyYLEoxV/1WKbm2gA2lZZr6vFTpKrIj/c+BkGRXC5tKU7wBha8R6dyLqNghD6RrsmYoN0K3LhATCpIVhmkH0iHPyutgOdTeGrk6Su69Kq/ORSq3TYNPD/k5Tx/MyZlW1nOhuawBg
 aS8ei3nY
 IWoOm4u3PXaRec5OEjpH1u/N05wHoCCNWm5WwWhVByu83ps9USsknnnAImdS+JDUnmhMN8qS88oUD4e+k7im2oaUSXzALGIfmCcgLMzNeQx9lC6lEBpXisP6zU/v17CRQxNPzEOBVyJsduURvqiRO7VN8CyoCI33n0QiDFdRU44f+2FtU1eb1SWehMIZZcL9pQjOE61bQ1UCUdbmrFDs9Maiun10kD3G29IGVVuQ508rh8/HW2xWkZJeflixUFupKvny5HGO9nSELXAIcVF/gs/CLbNYxvFzpC1lDjmyOY/CgdGWM2KWZk8DOYof4PHao/qBXw66R5mLXVT1Oc842/wSUNSqzzVwNui6UF3JuSSt9/xNHmk9LB3T/Vkpzlbx+tK4eA/M7Juw88Z4T24lFChCP183zpl4UfsrL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 17:01:51 +0200, Ard Biesheuvel wrote:
> One of the reasons the lack of randomization of the linear map on arm64
> is considered problematic is the fact that bootloaders adhering to the
> original arm64 boot protocol (i.e., a substantial fraction of all
> Android phones) may place the kernel at the base of DRAM, and therefore
> at the base of the non-randomized linear map. This puts a writable alias
> of the kernel's data and bss regions at a predictable location, removing
> the need for an attacker to guess where KASLR mapped the kernel.
> 
> [...]

It would've been nice to hear from the ppc folks on patch 11, but I've
picked it up on the assumption that they'll love the negative diff stat.
Worst case, we can drop/revert stuff if they have late objections.

Applied to arm64 (for-next/mm), thanks!

[01/15] arm64: mm: Remove bogus stop condition from map_mem() loop
        https://git.kernel.org/arm64/c/36ca7f4be809
[02/15] arm64: mm: Drop redundant pgd_t* argument from map_mem()
        https://git.kernel.org/arm64/c/2e527667a3b9
[03/15] arm64: mm: Check for pud_/pmd_set_huge() failures on kernel mappings
        https://git.kernel.org/arm64/c/8dd640d9233d
[04/15] arm64: mm: Preserve existing table mappings when mapping DRAM
        https://git.kernel.org/arm64/c/a64293e993f6
[05/15] arm64: mm: Preserve non-contiguous descriptors when mapping DRAM
        https://git.kernel.org/arm64/c/ecda73ae92ca
[06/15] arm64: mm: Permit contiguous descriptors to be manipulated
        https://git.kernel.org/arm64/c/05c5c31e9d8d
[07/15] arm64: kfence: Avoid NOMAP tricks when mapping the early pool
        https://git.kernel.org/arm64/c/dfd73e574d38
[08/15] arm64: mm: Permit contiguous attribute for preliminary mappings
        https://git.kernel.org/arm64/c/28becb2c1d74
[09/15] arm64: Move fixmap and kasan page tables to end of kernel image
        https://git.kernel.org/arm64/c/382a03e12eba
[10/15] arm64: mm: Don't abuse memblock NOMAP to check for overlaps
        https://git.kernel.org/arm64/c/d672a4b72c95
[11/15] powerpc/code-patching: Avoid r/w mapping of the zero page
        https://git.kernel.org/arm64/c/c0693153fb17
[12/15] sh: Drop cache flush of the zero page at boot
        https://git.kernel.org/arm64/c/99bad3e992e2
[13/15] mm: Make empty_zero_page[] const
        https://git.kernel.org/arm64/c/0aae825f1ed7
[14/15] arm64: mm: Map the kernel data/bss read-only in the linear map
        https://git.kernel.org/arm64/c/f2ba877402e5
[15/15] arm64: mm: Unmap kernel data/bss entirely from the linear map
        https://git.kernel.org/arm64/c/63e0b6a5b693

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

