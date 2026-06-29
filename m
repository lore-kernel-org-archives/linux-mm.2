Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E1EBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33596B0005; Mon, 29 Jun 2026 07:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A5A6B0088; Mon, 29 Jun 2026 07:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47A06B008A; Mon, 29 Jun 2026 07:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C115A6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:44:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 414C314067D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:44:11 +0000 (UTC)
X-FDA: 84932766702.02.8E8166C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A03E61C0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:44:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q8m5WZPQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782733449;
	b=zecyHP1bfdl3pTBjSFG1pKiSeWjsF7P1zneQ3CModDQjxkMOU/DuMeZLF9hz4IO+qV0Z01
	dAcGtI5i8S/exufsRHX730WK9pdlY5PHX5qfhOxcxn1ynB0WPqS2tvE5A75vGHIa005FKQ
	i9EygBVk490N12SSragPCGlD0y8/lps=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782733449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViaMG4AIx4t7Xw8EOKV5lY2S4wNOCDcLNhNIuR/tVoE=;
	b=Z2QANtY5XkwYHLyjMqOS+GhTvI+N4tHF7ArGGVavRZ4VTfIME07a7jkgKWwJx+GTI+tLQE
	5+vkvv8W83NeIm02mSD2dWzDTBDW+3W5a0wn5aBKjstelcIe5eyk6DJim8h6Qr8fnarWhS
	y7gKOU8lbEa9JArYJNBCQ7jCa4Bi1Hs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q8m5WZPQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A71B6001D;
	Mon, 29 Jun 2026 11:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D281F000E9;
	Mon, 29 Jun 2026 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733448;
	bh=ViaMG4AIx4t7Xw8EOKV5lY2S4wNOCDcLNhNIuR/tVoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q8m5WZPQxys7TASSEPS79b1PS7Camd9Fn+c6d1C9gq57MCQiYrcQnCXQfgL5Pom18
	 DEi/W04AGewzD/rKoMQlj7PH7ZlvfhgT5wCxco8mN/yozzeDJebmnwHsmAjUc92Hvw
	 6FvQmlN57DCT6ekazGvEXvtaVtlZGacM99DDCOSxpOBVSleTe4irqCX5KbtC2izNKF
	 T291dor9anDtABM3b/yxgkDP56ANzslcvn4NGksr9xxTxzQ33O68zYsFM+1kAbKewL
	 8f2NZFEXGGeHuNzx86QM2uiAaWdYbAx+u9ZKEshlHOlDMKPf26u4dffwBuDK6k7Dw4
	 85OiP+UwZqwrw==
Date: Mon, 29 Jun 2026 14:43:57 +0300
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
Message-ID: <akJafRKJJBd5Jrv0@kernel.org>
References: <20260621145919.1453-1-ekffu200098@gmail.com>
 <aj426bA-YiOKt06m@kernel.org>
 <CABFDxME8wej3m8T5gn8y4dmpOLZutm=tDTa7ZcfhbWwScTu_5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxME8wej3m8T5gn8y4dmpOLZutm=tDTa7ZcfhbWwScTu_5Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A03E61C0003
X-Stat-Signature: g7xuh1adge85yd1rp96zgg5314tnpyo9
X-HE-Tag: 1782733449-437178
X-HE-Meta: U2FsdGVkX18d6RPjWNmuCIQerLNQZuGaoie+kjcU0cLkAk34qYZQhPPhYNqkl0bRGALgF0YcfpliU8oM97ZzLhivJb/JcPzOyVOZpZrlLVxjcgcR2uJVe8c38bjq2MhCqnreB2e6+hTWvpxPDeJTGDJI00fVNUSKMPqL40dVjsflAlVR5kCMrnOY5xeLJCScuHXoMIjl72N7214RlS3N4XgOQvW9Bf0vikaj2HvhhK/N/fmfqgSU+prMTv48ozNG35UT4yOYTt1gTsb9tWNGmOjTC3kbJV1yGQvucJt7J1YQ6lySH9xp74IzNmldg+kjQUgKuEIJ2TeM8T3gn7VIpBORMm879C6bd20W3P3g826wl2DrKrQqQtSlxWs4sPm/gh9KzVQipsK2CJ7uPoRzy0scQKzsSKrJCSb5HKx4BiJCR7q9LCufbOXSomf0oeP6xWfhpyd+X3j4lATauXElbapJZk4VrjOqVj8f1ggu6COwUxbM0k30EaZ45J+w/piRrxeZ/rIkWYhGoffL4635nnp2HD/XtA8HKGD9/Z55RXt7rniTdxo/wI4zMxeiwMH+J3awylXcGblY6Izl34hfHd+WgktTtzohx66vxc30WL0zBdqfuqAu5JfMM79i6FN7aJsCLH+2+Zftldf7k83+OI2mP97WaF4+1CkrBTBMi/1xK9VdKqSToYU2dMdttoTe0gc187x7SSDxsF5zGsZHO2878SrLQXg0pLwx269GuiIE/undnLMjKBPAmD8PJpepdJ3LldwBCo/EVIOtBhWa7mt7i3F9Un2B9qJ9AVD3UkjquCK7bEKRkzef2fdWv8qDTwU+GfgLRCPmHZU4J0Wbch9nNEz3MVs3qtviDmWt1etXe5hZ0m32CXJlnZy8C1eBn0lHrw90HUkCQ7u+acEZ5XWZYoSljnCgL23nCjQQbxVyL/bhA43KjNuMlwbjJPxJt1hzoqXVWmEgQ8hWXAj
 1C8X5RRu
 06CeGfq+rIFhF8flF45BVlqertCDsbsGzvE/HSggjfNhaNwhO3WpVdQ7ItdTWXsI/YELC8HNLkcboQvmBlnrei1aRyuyrkr+lCBalirog/irWuw2piWZ5R/RqrIHu2Tj7UfspnHHD7cjAuW4B1blkBdiB36bUAn4w7IP6WZVmvzzmiUbBJLS8RywayciMUv3RJTYh5uZyw8vIjUaFBVJjvf8/wl0H7lePzQEfqiJbKu3xVmvJVxsYAVbjlb4FPQL0ZYuLpLd6ezGRHI1+5rGP5GP0AxzPWKWdrLzCFBcvka7KYFRvjGNc90p4p8i04QvtIiE4XF+fnHAkijZv9K7MqnDkvCRmJUK4OM8wenq1rBVIb8fXWp7ODW4mCl975UGwt8jLXtzxMjUAnOyetTZQLWOu9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 07:59:22PM +0900, Sang-Heon Jeon wrote:
> On Fri, Jun 26, 2026 at 5:23 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Sun, Jun 21, 2026 at 11:59:10PM +0900, Sang-Heon Jeon wrote:
> > > The memblock API guarantees that for_each_mem_range() and
> > > for_each_mem_pfn_range() never return an invalid range, meaning start is
> > > always less than end.
> > >
> > > Several memblock callers still have unnecessary invalid range checks in
> > > their loop bodies, so remove them.
> > >
> > > Sang-Heon Jeon (6):
> > >   arm64: mm: remove unreachable invalid range check in
> > >     kasan_init_shadow()
> > >   LoongArch: remove unreachable invalid range check in kasan_init()
> > >   riscv: remove unreachable invalid range check in
> > >     create_linear_mapping_page_table()
> > >   riscv: remove unreachable invalid range check in kasan_init()
> > >   mm: remove unnecessary empty range check in
> > >     early_calculate_totalpages()
> > >   mm/hugetlb: remove unnecessary empty range check in
> > >     hugetlb_bootmem_set_nodes()
> >
> > I queued this for inclusion into memblock tree.
> 
> Thank you, Mike.
> 
> Could you please review and queue this patch [1] as well? It does the
> same kind of clean up, I just missed it at the time.

Can you please resend them all as a single set?
 
> [1] https://lore.kernel.org/all/20260626032902.703944-1-ekffu200098@gmail.com/
> 
> > >  arch/arm64/mm/kasan_init.c     | 3 ---
> > >  arch/loongarch/mm/kasan_init.c | 3 ---
> > >  arch/riscv/mm/init.c           | 2 --
> > >  arch/riscv/mm/kasan_init.c     | 3 ---
> > >  mm/hugetlb.c                   | 3 +--
> > >  mm/mm_init.c                   | 3 +--
> > >  6 files changed, 2 insertions(+), 15 deletions(-)
> > >
> > > --
> > > 2.43.0
> > >
> >
> > --
> > Sincerely yours,
> > Mike.
> 
> Best Regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.

