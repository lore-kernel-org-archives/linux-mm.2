Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D47CDE012
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA18D6B00B0; Fri, 26 Jun 2026 04:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78B26B00B1; Fri, 26 Jun 2026 04:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6626B00B2; Fri, 26 Jun 2026 04:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE3C6B00B0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:23:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3B03120369
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:23:18 +0000 (UTC)
X-FDA: 84921374076.17.9E60457
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 68A224000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:23:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0iz61wX;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782462197;
	b=u487IA4oFxA9B8higcBbMtu3u/HARHqAH1FfduzPw2bBI405OG5dS3sExNZkR0NaydtkhZ
	MGrFsFOi6KorRyIINbWmaB7KcqWxSTgqOl+skRHZXugB+IUwIrwpFEXvkmVCHytCaCGtTy
	kg69QteAWmLO/waLXsXegSk2qEvp3UA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782462197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmCZQsSXsYfJR1VBDG7KzxqBWjPcEA12Brcw1hCcOr4=;
	b=ksKYkyQUbwIN1ysNnHW9UrecB2kIWR3/r99yWLsx6MaDw9wvSpCfRJIWhKnrfXwQ2qtFuj
	LbZUUS8SurEyO17ojoxAxL28Gx3oQ2+oYwJEYOJbZWCtf+gnCJ9UE15zo8t7c0ybeZKyDb
	o+DQOTlGBC2HoDazkqw+sOw5vGwH/K4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0iz61wX;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D242560122;
	Fri, 26 Jun 2026 08:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D041F000E9;
	Fri, 26 Jun 2026 08:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782462196;
	bh=BmCZQsSXsYfJR1VBDG7KzxqBWjPcEA12Brcw1hCcOr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q0iz61wX8mF1P/AT5iS0RguEKJoHnJbaf7dG2Xaw/wVTBi4SxVOBIVG9crP2DYbSS
	 9B5P3SKEr70iokd3WQ+CCaYah+LPidn/GAJZipn4uhCWTywct1mVsz3YZ/ftCiTQrE
	 qIKkvlTg8Pcl/XL4UTF/vAUtFR5Hf2bQTiCbSFFd3gE54FeQAVMkILpX728AtqliRP
	 9e4GR/CJT3k+Jc+rLFHTS9efO5Exl1wE+5HVjEfsZQBkSR7kbXAmF71M2tvjQui4IF
	 S6ag1cun9+W4Xim0JhLSIlJgXd4VVCduvxBVUGsqrgxZsPOvLnnwFdNX8U6/QzpZig
	 6wlgRknzBcAQg==
Date: Fri, 26 Jun 2026 11:23:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	WANG Xuerui <kernel@xen0n.name>
Subject: Re: [PATCH 0/6] treewide: remove unnecessary invalid range checks in
 memblock iteration loops
Message-ID: <aj426bA-YiOKt06m@kernel.org>
References: <20260621145919.1453-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260621145919.1453-1-ekffu200098@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 68A224000B
X-Stat-Signature: p1pmsu17n7a7nde4dbnxo6hygma5iumz
X-HE-Tag: 1782462197-419357
X-HE-Meta: U2FsdGVkX18a5665ibbxw6eqgUrKqHcwJ3SO4gmBebCaFMzi9hI4geQvOhrXJ1SH6HJXBGfBKoJ/nWqKJAgkneDEGWSLIX+qh3SBq3tk18xoAjITp/ksIuhNIIZenujFTYjSClViMRxYSkHi3zt2htLPPEmUe7SdOAGdRyLD/ZCo5gdtqj5tMXBnDD2KNHS1su6dFLiOowhA4IL/7vI7GkNUiynWSA2vr0FlsldEL0o8eM3D5+p55Fith1fqV+gnhyH6Nj1BLSWFEyVy+gDr6sCWkJUK/rKetto6dNP7ZhdLvdrUYm7KNSGRPKvxYrvtXPxrWAEK5VtaCyugmdO9Fya02g97mOeja65D7KW6j/XyHc12cuy4KqlzTmBHPiG5xWpnJ7vmHyYGBx0KdYmjqQSoCJ9cDnkrDd9H1o+zhMntgs/9WstDLwCrwTGUhbOFdO1y4pMWskuLDubMQES27ZlJkWFckZlWkokVY/Uk6lnHYmWrORcoYgMwXoBgicaSgBv77rB6TQq3ITwTAT1rk1foUpuduasAHl3nO5tfdmCfckAIeQcTvMJShLlEOZG06U8C/Eq6BHLX59PXgpRvE/2dlL6Lw59eSCxwbKVt+q38YCPxSqMdNamOJ7Q2621oZmfaKkB+9JhkeDeK4zYKtj9ULpeOEdp0A7N77Z57vMfwjs85+r1YF2OlgpulhK1GiLJaEsLhH6zAzH8DSPhW1Yx6aU+5ZwkLcSFh8J+2hgdQBGQbABm/Qzb9kw2AgHSGMnfQVvSJhw45CKtOsit+tTD3mxc87+pyIgXvGbtf6wnRX3tfQn6ugnQOcXePirFglJaknElsfhA6v53gff2Rz49+FCRi0YH8CoSSpOIYdfJ8y801OTK0EWGkLHNGpZBrZwaxMHJkOtGwmoAMlWfaeOOIBmozUek4Si8HzJuvWtaKABs7KUjC7KlYF50T5W9+xG/p+V3BXXPb1mIFpuo
 EwWQLLtO
 tD77HbCx0C5NCFpfEuvU0dR4g3xc+7F6WLvdb3aHN11lglfNK+hvSzT2khlp5sZXC3CqEPsHs6VyOZiQV9lao26VefcDrLVN6v+2mGWCkq6PkvCtbhLM3vQ9drbUIrDroyL/V4Nyqao4YivIuanbZAzWCAThiIf1r4uuaD3VxMGGr8n+U1mKhR056pg1xonkNz6HRaGzXDC70N/w9Tmt0I/XyrA4sX52ELNcoPz+JHB1OwtG5xQOVQIGb3gcgWwyCWrEOttBtLoqYoisAcGQqVzDmAJb5OfHELpl9QMmpRVpZ9dsiOcPIOGnsVcMNHnxNPMn9ASNuhjBRwUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 21, 2026 at 11:59:10PM +0900, Sang-Heon Jeon wrote:
> The memblock API guarantees that for_each_mem_range() and
> for_each_mem_pfn_range() never return an invalid range, meaning start is
> always less than end.
> 
> Several memblock callers still have unnecessary invalid range checks in
> their loop bodies, so remove them.
> 
> Sang-Heon Jeon (6):
>   arm64: mm: remove unreachable invalid range check in
>     kasan_init_shadow()
>   LoongArch: remove unreachable invalid range check in kasan_init()
>   riscv: remove unreachable invalid range check in
>     create_linear_mapping_page_table()
>   riscv: remove unreachable invalid range check in kasan_init()
>   mm: remove unnecessary empty range check in
>     early_calculate_totalpages()
>   mm/hugetlb: remove unnecessary empty range check in
>     hugetlb_bootmem_set_nodes()

I queued this for inclusion into memblock tree.

>  arch/arm64/mm/kasan_init.c     | 3 ---
>  arch/loongarch/mm/kasan_init.c | 3 ---
>  arch/riscv/mm/init.c           | 2 --
>  arch/riscv/mm/kasan_init.c     | 3 ---
>  mm/hugetlb.c                   | 3 +--
>  mm/mm_init.c                   | 3 +--
>  6 files changed, 2 insertions(+), 15 deletions(-)
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

