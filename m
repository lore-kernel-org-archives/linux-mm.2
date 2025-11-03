Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6219CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 13:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0488E0080; Mon,  3 Nov 2025 08:32:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178728E005E; Mon,  3 Nov 2025 08:32:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B54C8E0080; Mon,  3 Nov 2025 08:32:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECCA38E005E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:32:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B0CF85538
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:32:48 +0000 (UTC)
X-FDA: 84069386016.01.567F294
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D3AD340017
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:32:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Icl6eF75;
	spf=pass (imf17.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762176767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3l1oHecGlpNpSZOR6dOjzbo00UCNKjOaXvRkPwiEvSo=;
	b=MZpa6Rk0tgIyZ7/oqF6ThT9bMcQHZeJ+tFyGhrISuvPhJ8/G19c/p86w6DuHdn/iM4D3a3
	pI3b9wnZl2PxsGaUoB+bHt3tDOWgcr6TeO/uNjCBwMGvoq1SX/qbdQ9lNmt3fOhy04py/6
	7Kg9RzLJcCKCZj8L1EDD8h5VZDuHKaM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762176767; a=rsa-sha256;
	cv=none;
	b=1WxVtZ9axpFvyh66BlATE94cH1HPngoIKjCAymsW8wSV25Z1FrEoJCtah7Pq4Tb33oNidG
	cY/8t17Pk+BRaHxf5DhRYloGiyd/JqnqRwT7LC//HZN7K0+r4IbB9ECVo08vKZvbW0+KaM
	D6y4+uBPxv5/T7TqaJUfuL5NUpRKbpM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Icl6eF75;
	spf=pass (imf17.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADB90417B0;
	Mon,  3 Nov 2025 13:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2BBC113D0;
	Mon,  3 Nov 2025 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762176765;
	bh=rv5IOYmAi9gffnN3PWIBCsFc9IzI9PzRnuUE+GpwrQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Icl6eF75jY80ayW75IoZ0+LaPiPi2EcEgn13Ycd69S2hVI2xar7gCviAMLxOeSJXf
	 GM6OXzXYvbzUIkLAxOFnoRp0A34f7TykgQJyW9q63ZZbrinhKCvq31c/jwUYw4H7kL
	 O736gPg0odgIdTIHBw1WTAJnptmFtT5qer3mfGeZgE8KlOLxH6u0/ehNdXJUNUPN01
	 kSrXRcKNOimokj5fhuwid3rYkYiteka7WzdG+2pVwmBHrUu8iy8QjjoVxzoynZLTVO
	 d7k1b1LcQKs7sEf2/ddXpwpyF27u83//ZaJkf7s9iFyYf8GyfYxIx9/RwH8UgJcPse
	 0dvcB+RZyVmZw==
Date: Mon, 3 Nov 2025 13:32:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Will Deacon <will@kernel.org>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
 folio
Message-ID: <aQiu-hU3x5V5drHF@finisterre.sirena.org.uk>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W9aQpuovxYTKD7ef"
Content-Disposition: inline
In-Reply-To: <20251031170133.280742-1-catalin.marinas@arm.com>
X-Cookie: news: gotcha
X-Stat-Signature: 66qfw6foea79kidmkxrw8otkwccm6dmc
X-Rspam-User: 
X-Rspamd-Queue-Id: D3AD340017
X-Rspamd-Server: rspam01
X-HE-Tag: 1762176766-15118
X-HE-Meta: U2FsdGVkX1/7WyovlQO5CwOY1jD0kSvTrEothiiFx3fVnLKQj8lWw7B6xfy1vQPyMgmej4L8rphKZJDOrXDDAWpEPFYs9fciLcOhgVa/VKyakQ+3KLuGKPdijg8V4RRdu6Va2Pc5XNNbK+F5k/7SoElU0yZZKFKDcCBApBiMQ8cNNfa8UkRlgComq/4g/Zc99z2fe+5YYKDJdmKUS5LW1HC58JjdDLbZCIZDTFA+UQc56OZBCIa7ER0RLGD1azzqjgAvnR7Jp0B9qV77xLXJ3JfY9hepUPa0Bx10/RwbDekQg6umeI7WidKgQL3/ricqrZNT+TKD/+2sHdjKINjU0aXUg1ci8s7ElZd35/64XNAI+hkOGbnVnq12CH2xDE5jR1hzdCxlth0HWdJ5DoSKTVOdpzGm2GQwCEjZKMzEvJY+wuChisf8lpXeCw70bi67q4TFqtcnePlVYXekYhSgMGY17/KdCsxc7yeP+k/RhxJ1AzctweDP/rI4/gTliC+IWJmrNHdxa7iqhT6BMk9+au0ag+qGObNY1CB4cxgOytEkj3pnHZRGBxPp8f25girSttgDy6MzKF8ICFnQgcx/1El8XuPU0zSBj2yVKcBpSpfcECKDNZ7NPjAoqsQHbUC2PqoUMFUl/JzfYgnwex8g1FkBQNZxWcpEHMRXwtg6j8BIbon/C7pJePif3o+yLhyvx+jr6KM3PLbmjnSLqeNkdb/vXfI4sd765a/PIy6qrNlK8R+Ywl2zi/X3WMpEeB5zqm44t40k4hJ+6UEp3JYHXNG5j72TwOOcAJU/5eV5bOgHw3kLHHCQ90p2uUjH185VqLfucqMOMHF2ykSF2v1+9vKfyTS38lhqkH51zPim/wS0AFTfSjJ+b1XvbzK+iOxt441kksh0RZwjAZm4Mb8/IXWblkvhL26PefzIFB2/wkojfwxw1xIUE71LUMF+SHXC1Z9nG9x8hqiAHl53sa4
 OJIWnmAe
 bZ5IGTpkoRKVoy5ylFU1Z59Ildz4HxGYefwRHZM6thxBz3lrv+r72Qgb07JB1e8qVqWB8/I0NA6RVKhkPehS1zfKFkXTLtWTC6+T6WJkU1SeL2Wr3YB/6B48NEv0hKJ2s4X61t/MBLCtgdNcjfLqzL0m+bNnpz62zQ7+ZLV7/jdIewOmc6I64yjDsUu2C9m90apR4rjVvPESF81EQ6VnflShV9TLmhJVVe42tHhxei4AF4l6qetGeSIG+yzIxHqLuA2Lo97Q3BIi2wdUg40NKODPY3oh0wvBt+4/CNku2i9I1gwKT40Zbb8gwSztyemETZ5PnSj2EXfR2BQ4HeJQHt/wrlPAUrbyRy9M/QMnGUG1khFBpbwF0tzIelyH6H9z0NZiHNYQ1Jv3glCDxFKGHvKbaZJpTtG9l7WusWw8VKbx5mFqI9NaLLebTOtJ9tOH4Fn06
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--W9aQpuovxYTKD7ef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 31, 2025 at 04:57:50PM +0000, Catalin Marinas wrote:

> On arm64 with MTE enabled, a page mapped as Normal Tagged (PROT_MTE) in
> user space will need to have its allocation tags initialised. This is
> normally done in the arm64 set_pte_at() after checking the memory
> attributes. Such page is also marked with the PG_mte_tagged flag to
> avoid subsequent clearing. Since this relies on having a struct page,
> pte_special() mappings are ignored.

We are seeing breakage in userspace on a range of arm64 platforms which
bisects to this commit in -next.  We see traces like:

[   59.746701] Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP

...

[   59.819007] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   59.826055] pc : mte_zero_clear_page_tags+0x1c/0x40
[   59.830980] lr : tag_clear_highpage+0x68/0x118

...

[   59.911874] Call trace:
[   59.914333]  mte_zero_clear_page_tags+0x1c/0x40 (P)
[   59.919278]  get_page_from_freelist+0x1a60/0x1c80
[   59.924042]  __alloc_frozen_pages_noprof+0x178/0xd20
[   59.929068]  alloc_pages_mpol+0xb4/0x1a4
[   59.933022]  alloc_frozen_pages_noprof+0x48/0xc0
[   59.937683]  folio_alloc_noprof+0x14/0x68
[   59.941718]  mm_get_huge_zero_folio+0xf4/0x30c
[   59.946200]  do_huge_pmd_anonymous_page+0x278/0x6a0
[   59.951119]  __handle_mm_fault+0x700/0x1834
[   59.955332]  handle_mm_fault+0x8c/0x2a0
[   59.959190]  do_page_fault+0x108/0x75c
[   59.962964]  do_translation_fault+0x5c/0x6c
[   59.967181]  do_mem_abort+0x40/0x90

Looking at the codes:

> -       zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
> +       zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
> +                                ~__GFP_MOVABLE,
>                         HPAGE_PMD_ORDER);

This adds an unonditional __GFP_ZEROTAGS - from a quick scan it looks
like this was previously only enabled by vma_alloc_zeroed_movable_folio()
when the VMA has VM_MTE, I think we need a similar test here.

Full log:

   https://lava.sirena.org.uk/scheduler/job/2036941#L1423

Sample bisect log (with links to further runtime logs:

# bad: [3575af345aa2424636e69ac101a568bda249abe6] Merge branch 'i2c/i2c-host-fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/andi.shyti/linux.git
# good: [6146a0f1dfae5d37442a9ddcba012add260bceb0] Linux 6.18-rc4
git bisect start '3575af345aa2424636e69ac101a568bda249abe6' '6146a0f1dfae5d37442a9ddcba012add260bceb0'
# test job: [3575af345aa2424636e69ac101a568bda249abe6] https://lava.sirena.org.uk/scheduler/job/2036941
# bad: [3575af345aa2424636e69ac101a568bda249abe6] Merge branch 'i2c/i2c-host-fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/andi.shyti/linux.git
git bisect bad 3575af345aa2424636e69ac101a568bda249abe6
# test job: [81f07f151b0759666fee3184651aab90ef1c5ed5] https://lava.sirena.org.uk/scheduler/job/2037418
# bad: [81f07f151b0759666fee3184651aab90ef1c5ed5] Merge branch 'usb-linus' of https://git.kernel.org/pub/scm/linux/kernel/git/johan/usb-serial.git
git bisect bad 81f07f151b0759666fee3184651aab90ef1c5ed5
# test job: [661821dc41b20c505d5adad10bb71fe5746c57fb] https://lava.sirena.org.uk/scheduler/job/2037588
# bad: [661821dc41b20c505d5adad10bb71fe5746c57fb] Merge branch 'fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/krzk/linux-mem-ctrl.git
git bisect bad 661821dc41b20c505d5adad10bb71fe5746c57fb
# test job: [972cbfc499182c200bd3d2fb8fe4173df0d4d3e7] https://lava.sirena.org.uk/scheduler/job/2037773
# bad: [972cbfc499182c200bd3d2fb8fe4173df0d4d3e7] mm/huge_memory: initialise the tags of the huge zero folio
git bisect bad 972cbfc499182c200bd3d2fb8fe4173df0d4d3e7
# test job: [6923ff319e1b0d3541cd240b6ed494e1cb6287d1] https://lava.sirena.org.uk/scheduler/job/2037885
# good: [6923ff319e1b0d3541cd240b6ed494e1cb6287d1] fs/proc: fix uaf in proc_readdir_de()
git bisect good 6923ff319e1b0d3541cd240b6ed494e1cb6287d1
# test job: [e356021a7589f6dd1c946b86c933462dca0bc1ec] https://lava.sirena.org.uk/scheduler/job/2037973
# good: [e356021a7589f6dd1c946b86c933462dca0bc1ec] codetag: debug: handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext
git bisect good e356021a7589f6dd1c946b86c933462dca0bc1ec
# test job: [decb83d6239894a14b07c8f5ebf9feb5c87ec651] https://lava.sirena.org.uk/scheduler/job/2038008
# good: [decb83d6239894a14b07c8f5ebf9feb5c87ec651] mm/damon/sysfs: change next_update_jiffies to a global variable
git bisect good decb83d6239894a14b07c8f5ebf9feb5c87ec651
# test job: [53cf2716958490997b8ce11cc4665256905b23dd] https://lava.sirena.org.uk/scheduler/job/2038076
# good: [53cf2716958490997b8ce11cc4665256905b23dd] nilfs2: avoid having an active sc_timer before freeing sci
git bisect good 53cf2716958490997b8ce11cc4665256905b23dd
# first bad commit: [972cbfc499182c200bd3d2fb8fe4173df0d4d3e7] mm/huge_memory: initialise the tags of the huge zero folio

--W9aQpuovxYTKD7ef
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkIrvkACgkQJNaLcl1U
h9DhLQf7BoAYx4bPh8mue63qcZgpM2Id1rQlCGH5fqtgH8QCKKanNo/GxHUXLrK2
ENTCk8/ysVGuUjeRRAvgO+3q0MCOu89oKZXTq+N0mmsODdcj2AkfsYgeKVv9dQpi
Re1/brRZ7sUTOLBfKzfzOcCaOqyE+w7aO7pUGnrop8Zx1g7cNXcfSBPLjtytd5F9
M/3Gr40H+YEUmq0r6wDp5xn3X8tzA+GkRkfNL51Kv/sM8/XJTbxzQ9c0G5nW0cC0
B4yUxKJVKT3wRF/svVwxZwgbRMXXbbjhkq2LvAw9p1k3xFonFxViUNWTn16UsoeX
RfH4WuDp6M/sDmsAQ+BTDVx8Bl1feA==
=qRZL
-----END PGP SIGNATURE-----

--W9aQpuovxYTKD7ef--

