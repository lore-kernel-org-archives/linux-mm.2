Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9F1CA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 02:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9656B0092; Mon, 12 Oct 2026 22:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D893C6B0096; Mon, 12 Oct 2026 22:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EBA6B0098; Mon, 12 Oct 2026 22:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B16136B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:31:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46F32A8D83
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:31:18 +0000 (UTC)
X-FDA: 85316026236.22.4C12D14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7EE65180003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:31:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ex3bO/Fc";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791858676;
	b=P39gOBaDpPViqTXCY/TyjEY0Y1AO/enYlWU/KGGTaXRlVP0ABdG0oydZkrutCuvysgajWe
	aDIuqITDap3u8LrabtWn707xXsUVF5WifVJNX5QMU/ioeOjuQNSkh7vCDPY/R41WdGgvMn
	I7Fi/yxxnzXiUoGFVyTHQ2NumoXguiQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ex3bO/Fc";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791858676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neF1X1SW8f+CZ9aYnUdm8uqTfZ53Y+iDZ67qd/EFbto=;
	b=cHfSpv78c3+h8+ki64xtY/FYR8gtNT9j50SIBiNbWjCi5WQqBDj2bRbM+e0hNiePqflbeB
	m1IWONhjITOhmnXaqPbLFC+qaqCAXFAO1nENAvVSQdKoONvnOODX4kl/umiWDJjgTuGHrz
	Fb0HBs0cSBisR32FPE1FDN77GnC4MFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84E03405C7;
	Tue, 13 Oct 2026 02:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AE01F00893;
	Tue, 13 Oct 2026 02:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791858675;
	bh=neF1X1SW8f+CZ9aYnUdm8uqTfZ53Y+iDZ67qd/EFbto=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ex3bO/Fc0+ngjO39stCKwVk9Hhrd7Rifhq8ICQiBsfVb3HzvVvtZSrGzLxkxqd+0U
	 VLhJbkRlvRhudx0ySSyQeBPTjSDeHdu/kDYU/bsXoTKFOYkEV6o2q2M5XgxrDd31WQ
	 PGabwoaz3EcC7qUr+ttZxY9i9xXwWCFmuR7C0n1Q=
Date: Mon, 12 Oct 2026 19:31:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, Muchun Song
 <songmuchun@bytedance.com>, David Hildenbrand <david@kernel.org>, Oscar
 Salvador <osalvador@suse.de>, Dave Hansen <dave.hansen@intel.com>, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, =?UTF-8?B?Qmo=?=
 =?UTF-8?B?w7ZybiBUw7ZwZWw=?= <bjorn@rivosinc.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
Message-Id: <20261012193114.77147e0a43affa8ee1ae896c@linux-foundation.org>
In-Reply-To: <145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
	<20261010112457.49485-2-songmuchun@bytedance.com>
	<asy-b7_C3SjnmSaS@gmail.com>
	<145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7EE65180003
X-Stat-Signature: cgt8ww8czge65dxbte4tmuaitc4cyt9b
X-HE-Tag: 1791858676-381559
X-HE-Meta: U2FsdGVkX180k7V6GTtwINCLTK3KSgLCt9Qy+AnoULu56YsG8vuoOEepVfwxfE+y0U3L2O0X6wcRGGhZ9dGrD4gjG02eZXJhmaD6h3SxaVdkF/NXQvYZybc3jygweAcW/MAZjnwPLGu63QK/o/S+klJN9RUOs37ga8XQSQU2eunZ+8QHpblYuM1Mx3EPJrWd4OMO5Zc7LmBp2vzQOA0bRMt2x4GNBsiDspZ9/9gfOPl1/bjyJo7S/SqHuwjWsYn9+82I8O7tr6BNl1ormzmKRvp8YIsjR5jlsNbsTEdGhg2zhkW7gpJr8QcsOkBipNLXfeXq5b1kKhBXfTVSLRzKZ4JYNwXiXEiZhKa/rDFNYRgLDpiBBFQEGsQD4kIrjfh1Q51NaiAcpGx0waVLyENHZf8IsUdq6I4XRYPVK+2N3a8UcjwrUm8Y/LBxXeN3btxwiuyvW891MwvXAMUnXAByVExyKLSEkPzZyKwzRwqQNTjJP/bppGUiOIO24epMfKa91/nJ1NZlkg9v7pyY4NpUfgJ9zaRr7Q1+njMfTasETgpbzeKt/BMlecYCfeGArGSWxD72G0of3OkUCE7Dq8uFqElIEptts/2HN47Fsl6KeqBtrb+Clp7qkoMtYeS8gfOG4X7qEuDi7GieBt42A0mqbloJzMkEOjELptIIBkLsHBSiOS+Nw1ehwOd7RMjgvb80/sh7/l6tYJzsB66He7nrBM2b+n6VUKT70DLuGV4drpxn9dWOxYbmeCh9o+6BqpC5bPN8BpcrMNuIK3nMEBMljVA0RrSoj+iR6441JzmJkXdPfISE6wJf/8ORO/3toK8efWVRWrYLRlvj9iByiXvvfgBHtC4qC3hdUIBqJY79ZWGwCyHOhQXt5T3EFDDyN7aDRwOt5u+sa3ZNk/wvroKRBh+3MbrTp/+oJnkqqBuLtb2x/P8P3M22I9nhZtFFnco6DlyN2kQcBuW+4LZ2ifh
 mD2sC+gN
 364qQeKArMLvj5Ht281BgWDknRezF8XB1MvdE9MBs4MUfLtaSTCMXAZwnv1rPD/p0x2+ArOVuGdtGe9CZyrxcj/rJhdv2ODffAAtjE5LYcSt4ErRaYLX0GFRH9esPlBcg6oFVSTnCwlXIphyn3Pd6X6nUDoDni1xtLhwRbCRJMO9dp0KAWPagBr6UgIbX5WUnFu6BTXRjtPjUHkQE1Cy5fg3+6PkWREV6wSRV0MqeLyedeMAnrh6VmxKZ1obcGH1FEvKMV7HUWuFLZPrgVWbsoGYiW3VvG6xzzXTrorWe7t6/YgeV9aOb9EHaNtkMb5NG5GOeQQfXoNPvXGbaHGfNe1Tz5LHT43C7Ja8fAp8SnI3w92AagYtuKzexRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Oct 2026 20:55:06 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> 
> 
> > On Oct 12, 2026, at 19:15, Jose A. Perez de Azpillaga <azpijr@gmail.com> wrote:
> > 
> > On Sat, Oct 10, 2026 at 07:24:54PM +0800, Muchun Song wrote:
> >> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
> >> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
> >> tables.
> >> 
> >> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
> >> splitting a PMD. Restoring the vmemmap backing pages does not collapse
> >> the PTE table, so a later memory hot-remove eventually frees it through
> >> pagetable_free() on x86-64. That releases the page without running the
> >> matching destructor and leaves NR_PAGETABLE elevated.
> >> 
> >> Make pagetable_free() detect constructor-backed pages and run the
> >> destructor before releasing their memory to fix the problem.
> >> 
> >> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
> >> Cc: stable@vger.kernel.org
> > 
> > is the x86 case covered for 6.16-6.18? as far as I can see, x86
> > free_pagetable() only uses pagetable_free() since bf9e4e30f353
> > ("x86/mm: use pagetable_free()") in v6.19, so the backport wouldn't
> > change anything there. or am I missing something?
> 
> Yes, you are absolutely right — thanks for catching this.
> 
> I double-checked and indeed x86's free_pagetable() only starts using
> pagetable_free() since bf9e4e30f353 ("x86/mm: use pagetable_free()"),
> which landed in v6.19. So for 6.16-6.18 the prerequisite is not present
> and the backport would be a no-op there.
> 
> The correct trailer is:
> 
> Cc: <stable@vger.kernel.org> # 6.16-6.18: bf9e4e30f353: x86/mm: use pagetable_free()
> 
> Andrew, would you be able to update the trailer in the patch when you
> pick it up? If there are further review comments that require code
> changes, I'll fix this trailer as part of the v3 respin. Thanks a lot!

I don't know if/how the -stable maintainers handle a comment like that.
I expect it's more reliable to do this via Fixes:.  Possible?


