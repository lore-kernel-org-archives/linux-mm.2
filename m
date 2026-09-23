Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE1FC98311
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAEE6B0092; Wed, 23 Sep 2026 17:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB736B0093; Wed, 23 Sep 2026 17:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376DF6B0095; Wed, 23 Sep 2026 17:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 076E46B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:38:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AB2540151
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:38:22 +0000 (UTC)
X-FDA: 85246340844.23.D41A124
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7F14EA0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:38:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dxo6gZMN;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJsOwx/QHJRKZ+n0C8ukvZV0N0chl7bP1M9sQ8QHM+0=;
	b=raJREzqlQ58mL6yO3c4mi1JGr216KkG6jPb4XdAHDjXNdiRGrJXNDaOlK7/dz6cFqZxyZe
	MDsj4VzwTzOYhxR7GU76g0vl3km5/e9eO8Fc+px28OZBwe1jbP3cGFnw+pataOnGTL84Pl
	HweUywUgGusN2X2uan2RHbrie23Dblw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dxo6gZMN;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199500;
	b=4nJJBiiDPEfyZICEJr2GNhnfPXZQBGWShxvskzMyXUoQrcEWELIaQIYIPaYxGwoCb8sOwE
	G5K5eW9X+tTfJRm0f8y/atuYmKgT/iSKJOfge79LMLyeUnzPGw1kAXoRm9fa3pJNxgw3vH
	wf5msO/I5RpE0QYPC/mjVSqKu/Kxr1E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1047E601DB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB21A1F0089A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790199499;
	bh=YJsOwx/QHJRKZ+n0C8ukvZV0N0chl7bP1M9sQ8QHM+0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dxo6gZMNT18URkGZhYXcRMlxr2sCiuieBP1kADBFjFrV7hwOqC6KI+cYMVN0+459x
	 7bn80QRNap9jNWfvtKyMpgpbo9dLFi6KDfP2icWTd2ZXz+yFAtVNl4+QreAQpCSN8N
	 pC4LbSpIqLDDzmSsZkRoXkFZ3iOH9lCUYcDsoRc4hRQC8K44gptrtwf20PCytUIj26
	 IePdBbiMQvRknVtoEJFcE09lTXXYBC9s5W2TkhZZjI55udEfooLXi7Jr2biYFbVExJ
	 97k0rjqJWdHJzNynvyNVR0yXYZJ/UHOyaBuKV2u/YIrSlq0Onv6ewm8Kr3NILwH2L2
	 6uCeRWG1jXQsw==
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb766bfd3so10147131cf.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:38:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwRhe6fiRnrSKim4DvZ7XG2aTzVwPCwF2+NfW56QuKPm1F8ZIYCPBlGZFpi32CL4wCyHr9ufJyFuw==@kvack.org
X-Gm-Message-State: AFuF++lNOEbdMNqj7B4QtamTJ/G9lxHoxlNRXK07RHIAE4wwD8U8p2MZ
	mewu8bnjTw57855fzCjy3YE71gTykNckX/yEcnmfC7+4neEniazDs4f3dTeBaoKuWnJWtRsRCBx
	2x7i/5vlaPBGcgHHB4E2NrXE3CjJX50Q=
X-Received: by 2002:a05:620a:2556:b0:939:7c8:78a9 with SMTP id
 af79cd13be357-93c346c0eaemr75510685a.3.1790199499119; Wed, 23 Sep 2026
 14:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-4-jiangwen6@xiaomi.com>
In-Reply-To: <20260923062832.479455-4-jiangwen6@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 24 Sep 2026 05:38:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z-oqoxKynRr6mz0-5zZU_2NBnPkwz05CEEHHnwTyqa-Q@mail.gmail.com>
X-Gm-Features: AclHuK9KKxh7jAVCjl18JX2rsGxXVsV-K4ZOPHC6NmnXnXWa0kkH7W0rz6HMa0w
Message-ID: <CAGsJ_4z-oqoxKynRr6mz0-5zZU_2NBnPkwz05CEEHHnwTyqa-Q@mail.gmail.com>
Subject: Re: [PATCH v9 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F14EA0002
X-Stat-Signature: p9851s89qw4smxmfd81cyttbm8xntz9b
X-Rspam-User: 
X-HE-Tag: 1790199500-253706
X-HE-Meta: U2FsdGVkX18ZUv+YbJ6vinUJtU/bcxDw1r6pCouOBPfi4CeklBkVKwCbIy1y8yCM/GgnZxJ5c3PK5qyvCarVV3gjiTkn11Khv1kNba6jkD2/ImuKUPs4/HTJ5PqEIWzC3SiQ9+0/OfRx6wVskte5ST5UvvJceFroOMkP2pgc6agjRQyymCDqZn7ETwagQRUlx2Ea01pmNMogCGsUX2QXml3toVZHHLTBxAeU4vTiFbC19LeJJiJCsUlslIImcj/a8iUGoFY24SMvF/fLiiodAUmWtB0DRSxV/RNdYG17W52Q9wrfvpGDjGbYYGcRT7fNuxqDouB9ArA/bx7FKXtJqChSab2RWn1HlILtuWK4T3WAD/Z8XA0I1NudSWFXQ5UTCYMZ2E3B5yMJmj/aWzQwLKCE7agFScJ2x7yoN79OKOPjC33hSosNJcXqMFv8b02ImUFe/tPefUCgpqmsTvAjLk8faDZpYb8hHs9i5CtQVRgFNNc+1iBZWmcZuXz3fL531xaEHySmzftwGvNxV+dwGc1AhEVzVW8wzgHU95TTTUX+nL03p2GUeehRWSEOabdPFcL2buKn62AjFWZXrRjz8gc8xYnLFZNgVvi8a5kZ8q3+uXrN5kU0r2bPQL+LM0bbK1AhatJGu251sw66PS+cDXF4/ZTwGjcNZCuBp84v+N1qhjfIkfZHZs98MPgTzpDitGHauj8rXaO5aW0fudCaQ3sDXwU+pjBuu5c1a4n5lxX9vIy3Kj38fANIyaVHKy8nw5fgGJTzcvNoKL7ixClHjcZvDKgyRpnoI84/ibBO6zGePt+P9DqTcM4EzkUKMiQcKV/98B7RnLvnDRqpJZkDrcG6yDUFxZ8Ag7ZOrEn09SQp3wft0g8qZBly54DVfMukaXrA3cb/CNF17ohe/g+gbOuXn1B9qpET7pIzFOjZ0b9NwBbouVnGkW6ww4QGUHCTHy4xWwWcmAC182PifTR
 DAd2n3zd
 5ZEgtuwCX3v16t1GtKYo6yeIoEaRg3d5janGU/F3CH26xiWleLztgPKQVl6RQXjCTybfIlrOWpYuBlKwJDCgu2VF9QUazlLW/qE2cqy3XdTnK8kvQP9/vlQz0j2IvAlIVDeDykO5IO2BSdh1vTJ+3yJogw3xGUiE9UdcA9CIY3spWaN0OYptdmX6SvqKxTQd7ooHNkcJKvA+90VMXDrcBvtswA6VBTaR0ssAqm6vMSB5K8op72Xw+nNyC4hhsOu2sGaTir8wb7KMzt+eQeU3JdfQpSxILaa5n3UWHOTrmB21VnBHv/rkzFqn/x5bWFYvPv8AE9sdKahGCG21g2h6KjEnOUzGBwAUx2Jty4l0OVNMsjz78JNRwCPuiMdvcSJ6hwTOYkjR+sEeUqIq+xC9vIqv/dL5ZbF0J4qaN9es/2FUdBuLuIg3178iDAkkT6aMw9WJiPZS81ohZF8NODq/I5MMC7nOVNl9mCsi6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 2:28=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.com=
> wrote:
>
> vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
> huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
> the feature silently unavailable on CONFIG_HUGETLB_PAGE=3Dn kernels and
> couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
>
> Now that arm64 and powerpc/8xx provide pte_set_huge() and
> pte_clear_huge(), add the generic fallbacks next to the existing
> pmd/pud_set_huge() family and convert vmap_pte_range() and
> vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
> around the block-mapping paths are dropped, so PTE-level block mappings
> now also work on CONFIG_HUGETLB_PAGE=3Dn kernels, and mm/vmalloc.c no
> longer includes <linux/hugetlb.h>.
>
> The fallbacks exist only to keep the build working on architectures
> without PTE-level block mapping support. They are unreachable there:

Since this is a `BUILD_BUG`, can the compiler simply eliminate the call?
I guess the build would still pass even without the fallbacks, so this is
more of a build-time check than something needed to keep the build passing?

Am I missing something?

> the callers only run when arch_vmap_pte_range_map_size() or
> arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
> which requires an arch implementation. BUILD_BUG() makes that
> explicit rather than silently doing nothing.
>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>

Nice to see that `#ifdef CONFIG_HUGETLB_PAGE` and
`#include <linux/hugetlb.h>` are no longer needed in `vmalloc`.

Nothing concerns me except for the changelog issue mentioned above.
Please double-check whether the changelog needs to be corrected.

Reviewed-by: Barry Song <baohua@kernel.org>

