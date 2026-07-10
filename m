Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79257C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848936B0092; Fri, 10 Jul 2026 07:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81FD06B0093; Fri, 10 Jul 2026 07:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB756B0095; Fri, 10 Jul 2026 07:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB0D6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:58:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C37D21202C7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:58:12 +0000 (UTC)
X-FDA: 84972718824.05.B74A4CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 214BEC0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:58:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dAkxgwXT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDw4uHkrjrH2i/wDdxHnoRQvhH62dpRg5r0nrYMHl8k=;
	b=swb540qZRPNCfAfNTLQ8OGVMDWHi1Ua2xXShN6u16FldrSV7a6UZPk22d77UXAU71XesYO
	LQbYQt758tlp4rKEUz2nKkEFwLjXMzaL0YhbcYf2XfTy7QgSnU3FF9429lqZ32JXvY4KK7
	XBj7WUjkMSx7HZC7MMmWGh6W7MiqP18=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dAkxgwXT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684691;
	b=kCCSlzGE1R0mi1F60oTipF/ssM7QH5h0faeZLpWScWhNMlHHEMdXQSzUWUii3uaK956G0U
	jRJXcNaMOwaPBcUUIk3K8NDjCBBrm0z9wKjwysLviXj/9MwRawS+wcH8o044we+sT2E5BI
	AQM2n3cnS82jwtqCDokNODxHNzeN3Dc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 415BC43BDC;
	Fri, 10 Jul 2026 11:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF991F000E9;
	Fri, 10 Jul 2026 11:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783684690;
	bh=kDw4uHkrjrH2i/wDdxHnoRQvhH62dpRg5r0nrYMHl8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dAkxgwXT/R1DI7L+qLyNgdOAeakrAm08Pe6X6aqix0XakuDCSCOZnAqHQ2gRE0t9F
	 h3ZdKHfNDjgo97EBH/Aqec4PzZNwGJAd3zSq1wv6qKfoBcrGvys9ohsuamv/yuQqtL
	 IHh+n7NktbReynKyVPSjKL7zpmcAmDyw3Vf6MtiYXyeievv5tNFZ1ESTOMO9THH8mq
	 bs9g9tjQUWl554Yh5sw1nzgLe/RZ8R/BLPik3sr+gTdFfU/iUatq8IkUVk6xz7c95S
	 U7/08M6TK1ft8TrJ3DhiH4nyvc/SsXkVo/NzMdILO0bGEILpZKpcB4RJSfIJZox+Co
	 auVbqGEDaiSRw==
Date: Fri, 10 Jul 2026 12:57:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: David CARLIER <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
Message-ID: <alDeMJZdhbKfS023@lucifer>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <CA+XhMqwpDGYSQvDKrFz9XuQFiaz8_rgW0LupEzFhehSrFvUZaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+XhMqwpDGYSQvDKrFz9XuQFiaz8_rgW0LupEzFhehSrFvUZaw@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 214BEC0009
X-Stat-Signature: 9ogzyoxq3cx4m33xs6nsj63s6i8z6d5b
X-Rspam-User: 
X-HE-Tag: 1783684690-863602
X-HE-Meta: U2FsdGVkX18kIkK6FXnVVjI6rnxa785SZpdyufSLT7xvJCAzZCtBWu40P1X/ElZdc3sQgoOamL3JWLAvJW/75F92Iy+lBJ6VUBU8AVr9aede7gETTxhyp+vdX19HiaQTQd5Bhg9ntQZLyHJAJQWd71+vEZltpyuWwpQfqfg07Jg9pPG1iIipbJHMEo7va2G+jX7bgsoKpkWo/jzmimvLLcRaghkoXUpPx5kZ7DJ8Xe8xwzfbw+69K1sRLJnsSQk4tQ4fAp0QL7klEc8p1ON/EAFgTCnnnPXRjF+qL3iGHQo4xsgJLgo0ay4pqQ1NdVNhAQQBebHrPyeGlNhPtMORgrRXdysnrv2GduK6quNGss+k10/F2DvX4Ag0NR5Ut2ZYK6AlU9J0r/6rPWsT4oQhbv0n/ObXubydf07z4sOYvWTRXTKIGz8O+LrcmIthQAEHbU2QmxoW+rA0guXeysyhl53EnfEpR7cn+BbIg0TgTzqXXhdP6M1fvgmn6odg3vd7l3y2g/crNe7jqZD3NQRCvmKjrcSR7m4/2zH8A/VkNGuhNyUWeRB1d9to4nd9e9JaCQTq+zrRM0WbwfaylDGMDZfGQKoAY3MH4AMIgpDAUMLQhMYcp5Cx+YQI4cdulyafTiyQ88zeSmN63C2w8LjIx2dUT8Lys0GAekjTuMyAAm4SL3pj3/u+oAI2iWPHoUm+6wcc8Ttq4e+/KA3CBtTODIzUOk5+E3K60cVWZwKmbbvLdvpwbi+aXY9EShlogvxtD8OMHJEW4sHFWlTdtKUTpS8zxpEXXosXxEKw62dbMHIEP/ld8dI8y/iiEjYUo2JS33Sivh2L29vpxNiW4LjkR0/gEE9FTXl3b/Wq7K0mexgE03bwXsaSoHdTsNdmRsb9IW6c/g8WYRWsxnsXQQUHECxS40ZfQnBnAq141rKvcCt7kzuOD1iJ9hxdnIj6O42r7dNE5RBH5dqVkCLPCNi
 9nlvcgIm
 8g8AlH0OOMb+8SZxC+95avzInJosVn3WWGnBntzkhm6fyet5OjQst2AmI6Q92npXjS6WVvpruKGRlJCIJ5SyTY4KSJGHMrelop5k49cirYB8HucV5SIx9zZ5qeH7D7d+7x2HzJ8LEIRAn2zbXT+QRIWuKfHccJkgW3RMbtInZR+1YqY+DVrUQHPiuDdrM+yaHB+VmpR5bbo05c67hxbpzxSsv1ET39I8Z9yCGTgSMsHz73/QzBASo3Ibq/ChQV9qkTiDhwbOhC25f1vHXyvpP6Ujh66MArpe3MW+v0N8goxS1BiKGl2OMITmELaD3bf73Qb0KAjD0xmL4UElUPVt4nQsLQLpP56Ik2Iieu3Ex/6FPueP9RzHDQnFGiW5qKQDgfYI+bUg7kZ71lLHp+bVvNg2sK1ZdkrhBmkmG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 12:44:20PM +0100, David CARLIER wrote:
> Hi Lorenzo,
>
> On Fri, 10 Jul 2026 at 11:50, Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > Kernel page table walkers fall into two broad categories - those ranges
> > where no exclusion is required via walk_kernel_page_table_range_lockless()
> > and those where exclusion is required via walk_kernel_page_table_range()
> > or walk_page_range_debug().
> >
> > The former category is used only by arm64 arch code operating on ranges it
> > both wholly owns and does not concurrently write.
> >
> > The latter category consists of kernel page table walkers operating on
> > ranges that are wholly owned (but which need exclusion against concurrent
> > writers).
> >
> > The lock used for exclusion is the mmap lock, and for kernel ranges this
> > the mmap lock on init_mm.
> >
> > ptdump is a special case being both the only user of
> > walk_page_range_debug(), and the only case in which it walks ranges it does
> > not own.
> >
> > This presents a problem, as page tables may be freed under ptdump. And
> > indeed there is a use-after-free bug in the kernel as a result, which this
> > series addresses.
> >
> > vmap promotes page tables to huge leaf entries where possible, freeing the
> > lower leaf page table when it does. It does this with no meaningful locks
> > held against concurrent ptdump walks.
> >
> > As a result, use-after-free can currently occur. This series addresses the
> > issue by having the vmap huge promotion logic acquire the mmap read lock
> > while both setting the huge page table entry and freeing the prior leaf
> > page table.
> >
> > The ptdump code already acquires the mmap write lock, so by doing so we
> > ensure that the ptdump walker only ever observes either the huge page table
> > entry or the existing page table entry, and nothing is freed underneath it.
> >
> > A mitigation for this issue was already applied for arm64 in commit
> > a93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), which this series
>
> seems it should be fa93b45fd397.

Yeah oops, I typo'd that.

Andrew - could you fix that up for me? Thanks!

>
> Cheers.
> > has to deal with carefully.
> >
> > This mitigation resolves the issue by acquiring the mmap read lock on
> > init_mm on vmap page table free if a ptdump is in progress.
> >
> > However the fix in this series would cause a deadlock if we were to simply
> > apply it for arm64 without also reverting the change.
> >
> > This is because vmap may acquire the read lock before ptdump attempts to
> > acquire the write lock, which then gets queued, and rwsem starvation rules
> > mean that the (unacknowledged) nested mmap read lock in the arm64 code
> > would also block, meaning the original read lock is never released and thus
> > deadlock.
> >
> > This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
> > lock in vmap logic, then partially reverting commit
> > a93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), keeping the
> > enablement of huge vmap support, and removing the ifdeffery with the
> > partial revert patch.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> > Lorenzo Stoakes (2):
> >       mm/vmalloc: acquire init_mm read lock on huge vmap promotion
> >       Revert "arm64: Enable vmalloc-huge with ptdump"
> >
> >  arch/arm64/include/asm/ptdump.h |  2 --
> >  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
> >  arch/arm64/mm/ptdump.c          | 11 ++---------
> >  include/linux/mmap_lock.h       |  1 +
> >  mm/pagewalk.c                   | 22 +++++++++++----------
> >  mm/vmalloc.c                    | 41 ++++++++++++++++++++++++++++++---------
> >  6 files changed, 51 insertions(+), 69 deletions(-)
> > ---
> > base-commit: a635d6748234582ea287c5ffeae28b9b23f91c7e
> > change-id: 20260710-series-vmap-race-fix-2a4cac988938
> >
> > Cheers,
> > --
> > Lorenzo Stoakes <ljs@kernel.org>
> >

