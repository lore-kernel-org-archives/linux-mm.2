Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8CEC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BE76B0098; Fri,  4 Sep 2026 07:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F46D6B0099; Fri,  4 Sep 2026 07:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B556B009B; Fri,  4 Sep 2026 07:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0B726B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:26:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B70E40C62
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:26:07 +0000 (UTC)
X-FDA: 85175850774.20.B1ADAA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE0E11C0004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:26:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mluJvJ+2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788521165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXIZF5ElAIHZa1rnUZHWNzzVs/Jy9yMMRkt9sWYgbvI=;
	b=nk7iXkqzoMpmDFCmWNMB1hiZBvEhMNweOwrIZeuzes0kVtnesPH1pnVtxWJX9wEfeDVJbv
	rRXdUVsohMxi+ocKb14jqgGeqYfT72AV5AQ40Zxtxt02dowvYp9/JG5YdRO/f6CeHCUQLG
	cD6UwECMcEy1Swi8twmxiXkbuThMMk0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mluJvJ+2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788521165;
	b=U/8NBCJ3oxgTo6SWB0gndGPnoSon4bZ0kTOWbIyxD78rofs/LgMVdr3NUeUg1fd+t1UFIu
	N/7utb8ZQ7ouUH1fvxKCshmOoN9356xGbATMqky1f6Sew0uQaq73AVcjcdqQyYkGqwP14M
	X3FmKkfj1IwPRh0dITin+VR+eTgNapE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4CB4413AC;
	Fri,  4 Sep 2026 11:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356561F00A3D;
	Fri,  4 Sep 2026 11:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521164;
	bh=XXIZF5ElAIHZa1rnUZHWNzzVs/Jy9yMMRkt9sWYgbvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mluJvJ+244GVSHaOz7Q2krQ0KhxoLZs7iOnA4ksTTISOwY2skVParSwBT9v/4F0OF
	 g3xtpF8RfDAHJHVIcRhTHSQ+Bqle/H/Hvrnyrb2jk4Zoqbdcqt1HVWBDYJoAjafN8i
	 9kx6abHPk8ucvAX1eyRsxH/xeCyxC0guHR0CsHqOGT3+Gd1jYXTCRSyyfnROvZFGrn
	 8qYi5w7eqFltyhRXUIx3S6Vi1pai4OLZej+YcrU3JXyJzalY+QnRbFlhA8E5vImoZn
	 CKhhb7EZuqP6UXbHbxDA3RXkJWh7XlTBs4tvQRC42O4apjIBSym9i3tloAihiDGU45
	 e/j5PHm1j3JXQ==
Date: Fri, 4 Sep 2026 12:25:59 +0100
From: Harry Yoo <harry@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v3 0/5] slab: ZERO_SIZE_PTR alignment and ERR_PTR
 hardening
Message-ID: <apqmVDiyGJWnEnp8@nixos>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903203720.63689-1-kmehltretter@gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: b71cq5anu3nzqpeauuohz7usf7eiqzos
X-Rspamd-Queue-Id: BE0E11C0004
X-HE-Tag: 1788521165-188033
X-HE-Meta: U2FsdGVkX19pWHOU9gvGGHzyHxIvwIN0IsBbwtXohCVmqGkKAoP3bmBLfeiD9gVZ5S0sHL90k+9fts0hPMU4z+KY2IndI3mwhDCJrkXzj5s0G0+xa9vzHbf8ZP5qbNADbRULXTaCpbFuXCs5xS1Usx+Rz7SazLee5pr5dfuCgYWLFL4epeYou/Dqt3EkWcml33u5JxblAtbLYVb+str9l6nojyKgO0eXZ4iNplikDN+ESHpPPnqgSsa8P1MaO7suVqMsr68gtd4Ulg3eQjj2v9IXavpF70v0N4KZjyRznPx0R9K3Zb0CEMRG6PFvnG2Ui6e1DY8PE4LprrDkcEfcutb6vt3U2lsOMpIicd4nP3UB/KeE43AFELIqi7iOxb5zJPJMebTRixQJZTd5z/v1/oalGxbyIzF2Irf1t1K4RDKsMxmpgZN0/ROXr1r4qtmgEPXOE8sFwkxiRZWE8run7C3prWfCsYV0MpC3pz46dcViQ0ECy569dWjorpp0Kc+RdEuiQSLLzV8kj+1nUthLLiwem/wXdwKyuMUAZPPOu7IGivvu2jXNQX2hylxG0NNTP+Qogbeks6EItvGhq3ooGsdrlAzDTdFX5MwAeJJRYvzmrzhLfca6z5rFSpc+vEyp+ZIqUaQaFyAx8A77JyKxX0OGS611Tllp+awmqzD8yDVnkV2xx6HQP4Vc2SmY4nuBs5z6jSZ/JrlUHu7lnL5+++EJSXP1utbYBH7wxzROfOOso66HbVXJb07nIJb4Y7Ami7nWY3zquI7Y6k7++BJaS3u3bnXhDFHrQvhnYjsW3apMkgRCtZK8ZXbFGqd+S6xxP9aQa8X9nJpgR0kl8twq9lXlSHyEPdCuUNKKk/YSLSZbWnFGiOe7HKZlUqAd+YaXyuT1gsNtEKbH+x0HXxBSQbkNYhnPDRinpKr1AsbtJswMUewIGMEgYfAcZkq1eDI9t3OhNnnitIi/wKu/SvB
 L32YEmMQ
 k0T1R7/LdrWcYyFD+MFUjQw1Z8KkkFwtRnwD/LRs8633XD9pIwHqEs2S51Wdyi0oRJ7m53Gidpj4MfACgs7rpnFw+m86s2nugwIsg1RpBR1Eo7QjpjkWJnxDRNFzttuE1cwex6N/X1JzPyzID/MsmDuHPbzoEcwZF2pdkHHFFxpiR2+5qwcbTkVfhAtjKEVwKCUBXM8mZ1hU2JAuSRisstlky0vkUeGqG/E31z/Q6ba6Ymz/M/FjFKojALK4CGki+h4YsOggerAvdest/30HaPQCwoY6qNBFIOjPji/93EuIyEiHNSeO1ylKHpCr+5IHN4PcbpZ4pkGVcu1ae+ie56tkgrfgTOc5vhX3/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 10:37:15PM +0200, Karl Mehltretter wrote:
> The kmalloc entry points promise ARCH_KMALLOC_MINALIGN alignment but
> return (void *)16 for zero-size requests. Patch 1 aligns the sentinel
> to that promise.
> 
> Patch 2 limits ZERO_OR_NULL_PTR() to NULL and ZERO_SIZE_PTR. Patch 3
> handles ERR_PTR explicitly in kfree() and hardened usercopy, without
> giving ERR_PTR special meaning to other users such as krealloc(). The
> old helper did not match ERR_PTR values either; patch 3 addresses the
> adjacent hardening concern raised during review.

I don't understand why v3 of this patchset suddenly implements
hardening for kfree() and usercopy to handle ERR_PTR().

The address range for 'zero or NULL PTR' range and ERR_PTR() do not
overlap. The bugfixes and hardening patches are irrelevant.
It should be a separate series?

Also usercopy.c changes go through the hardening tree, slub.c and
slub_kunit.c changes go through the slab tree, and LKDTM has its own
tree. Patch 3 and 5 touch files across multiple trees, which can be
avoided.

> If backported, patches 1 and 2 should be taken together.
>
> Patch 4 adds zero-size KUnit coverage; patch 5 adds ERR_PTR KUnit,
> LKDTM, and kselftest coverage, which is why Arnd, Greg, Shuah, and
> linux-kselftest@vger.kernel.org are newly copied on v3.
> 
> Tested on 940de590b839:
> 
>   - GCC 15.2 UML slub_test: 10 passed, 2 skipped, including
>     test_zero_size_alloc and test_kfree_err_ptr; NULL and ZERO_SIZE_PTR
>     produced no warning, and the expected kfree(ERR_PTR) warning was
>     suppressed and counted
>   - GCC 15.2 matched x86_64 builds immediately before and after patch 3:
>     kfree grew by 15 bytes; __check_object_size gained a 13-byte
>     comparison on its normal path and a 23-byte cold abort path
>   - GCC 15.2 x86_64 defconfig with HARDENED_USERCOPY: build and normal
>     QEMU boot passed; the committed LKDTM selftest matched the distinct
>     ERR_PTR diagnostic after reaching usercopy_abort()
>   - Clang 21.1.8 armv5 UBSAN_ALIGNMENT: no alignment-assumption or
>     slab.h report; generated code retains the exact comparison and
>     single evaluation
>   - GCC 15.2 MIPS64 big-endian noncoherent build passed with
>     ARCH_KMALLOC_MINALIGN equal to 128
>   - Microchip SAM9X75 hardware (armv5, ARCH_KMALLOC_MINALIGN=32):
>     ZERO_SIZE_PTR was 0x20; zero-size allocation, ksize(), and free
>     passed with no boot splats
>   - Raspberry Pi 400 hardware (arm64, Cortex-A72,
>     ARCH_KMALLOC_MINALIGN=8): ZERO_SIZE_PTR remained 0x10; the ERR_PTR
>     KUnit and hardened-usercopy rejection paths passed with no boot
>     splats; the revised diagnostic was retested under x86_64 QEMU
> 
> ---
> v2 -> v3:
> 
>   - document why patch 2's sentinel-derived low-address window in hardened
>     usercopy was incidental
>   - add new patch 3 to warn and return when kfree() receives an ERR_PTR
>     and reject ERR_PTR values in hardened usercopy
>   - replace patch 4's pointer-cast static assertion with a run-time KUnit
>     expectation
>   - add new patch 5 with KUnit and LKDTM coverage for patch 3
> 
> v2: https://lore.kernel.org/r/20260811141240.62519-1-kmehltretter@gmail.com
> v1: https://lore.kernel.org/r/20260808105622.62026-1-kmehltretter@gmail.com
> RFC: https://lore.kernel.org/r/20260712120728.96628-1-kmehltretter@gmail.com
> 
> Karl Mehltretter (5):
>   slab: align ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN
>   slab: check for ZERO_SIZE_PTR by exact match
>   slab: handle ERR_PTR values in kfree and hardened usercopy
>   slab: test zero-size allocations in slub_kunit
>   slab: test ERR_PTR handling in kfree and hardened usercopy
> 
>  drivers/misc/lkdtm/usercopy.c           | 27 +++++++++++
>  include/linux/slab.h                    | 20 ++++++--
>  lib/tests/slub_kunit.c                  | 61 +++++++++++++++++++++++++
>  mm/slub.c                               |  3 ++
>  mm/usercopy.c                           |  3 ++
>  tools/testing/selftests/lkdtm/tests.txt |  1 +
>  6 files changed, 112 insertions(+), 3 deletions(-)
> 
> 
> base-commit: 940de590b839f71d6dc846160534bf202401b8b7
> -- 
> 2.53.0

