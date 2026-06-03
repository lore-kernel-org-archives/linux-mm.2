Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48194CD6E6A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95DB6B008A; Wed,  3 Jun 2026 07:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45E36B008C; Wed,  3 Jun 2026 07:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D116B0095; Wed,  3 Jun 2026 07:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8312F6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:54:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13E02A034E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:54:05 +0000 (UTC)
X-FDA: 84838442850.08.5CDF8E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 42E39C0003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:54:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MjYzbsw3;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780487643;
	b=zjnC6wsUPj2ef9yLbYZXoSGUljLDqhD6ZfwheKtzUKCcFDDW4pjR++dEY8kaXydrGeRhpw
	rQi1L1PrgvceXH0jqYyw2qeRNgiY4A4Qc5dI93zEvVDRnp3SQcRzybmG/u4gByy1WGi/5i
	JFgip5y81Q0wQHe+6fJGgibXVk9n+T0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MjYzbsw3;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780487643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5adSmP3M8pQIq+67TwL9E/JizpqFKvF4e1lZSTlkFMU=;
	b=dRR6UE6aPIxQcjo5gIiM80q46EoKv3XqLV0AMzJrj95AqfoCG3PMuVKKqCuQzUsyGjkwHq
	0xXHNDc802CzT8oZOs3x2rFxPHxJHxOvn7Rj3N/tZfOCM7eAO7BefNXT+flaDN0Fh4sKmg
	KysbLoVHhIQ+y2VfYyA9O7hPUyl2m9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32D494150E;
	Wed,  3 Jun 2026 11:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2541F00899;
	Wed,  3 Jun 2026 11:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780487642;
	bh=5adSmP3M8pQIq+67TwL9E/JizpqFKvF4e1lZSTlkFMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MjYzbsw3K+F41fa0y2oj48Zqy9s5e4r/+635q1WWyS6kQQ7Uc0pEtJKpsMb18xVPe
	 aKNa8tUnour6fTxGaZqQcsvaMwZG7xeZDsklHPWSJcz3BLaqdkb1vVptL9onDr1l6g
	 Y3im0alf9Q5tXMUe//chKULAwR9Ff5HcFg2jNqUYNcDWoAU4kSUkM+E75+k0qCNxho
	 wIrjbzTVi0PqbGgVMLlLUKNhbUw5p3q6AAP3lsc+M3X5dLsqsn4tPWK5Y4hizw4j1L
	 wf8ExMezeEzmqu2jW60RXrsrjStGNNAaSqMKrIh/tv/XCbOu4c+t9+Tb4UoFA6kaPL
	 D8Mwk7/vUoXlw==
Date: Wed, 3 Jun 2026 12:53:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: wangtao <tao.wangtao@honor.com>
Cc: Harry Yoo <harry@kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org" <baohua@kernel.org>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com" <dvander@google.com>, 
	zhangji <zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <aiAMHhq9QCp-z3V9@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <0867dac0-bc48-4aa9-891f-2066a3eff989@kernel.org>
 <7319ad82f9ee4fc4b18b50b1842c9f99@honor.com>
 <ah_VMf0ZJTRsrArV@lucifer>
 <c769ed2347bb45b19cc3ba5717e9fdd2@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c769ed2347bb45b19cc3ba5717e9fdd2@honor.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42E39C0003
X-Rspam-User: 
X-Stat-Signature: dhggj17cupoz658kekawb4681q1i8gds
X-HE-Tag: 1780487643-969809
X-HE-Meta: U2FsdGVkX19rMQe8BktkgP6lFJd/3TPGU5U3FpUHot1ugnmnCfDK5+mLiSuyMdpWrxlqvgWrJwsCRxd9K/aQOuKtFV/5qJirOXCC4yFqpoCXpjhFcervxbsCJv8XUYJPq+pc2uBhoQwH6HVp82+7wYiaBSzcrKvolu2ZKMfIralKMNiogewrZWOQc8I2gM6yfY6YeQQbQXPnMevyrrnMr6XcyA8Rq9wqBspqrKWHiKcTPocXEppRHnPkh6DSyLjvpSzsSd41fdKEWvX530wgVMAgpH7bKMjZIWGHT2sVmUOfYbYQ1Dc74xKefUDdLaC2yqK6qXkZwEEpk75f9HUtUU0N36yruWiyLViOpOMCWTdipiJY84m0UsDOzoVYyFijdcSLIgYWzmLZoxdAQr385voXbnup+og0IUaWA+ljQDZ7mXCKV83Tb1YBax+7lDn+KwTGf22sqc81Q5GjOtS4IZC11AG9XB9zo6EnshS3oW/kswB6qNjHAS8wIhjsxCkIhja9vPY+fMrm/mMANm7IoCm04dQMZKMynsx5OwYNscyoPY65RKVL0iO41uoV3Wde8pMZgDz0EJh6X6Noiv6UooibzQ4vGIW+bjU2hHZoXGZeTACOJ3Q3aCKKZWiIOo71wgPXI7gbtj4hwHJ/Grv5497UnydPVe+yl5066Wcq1FDhM5e9hJb7//QspOJyXRan8Lxy/gOM8e7mUzTJwgyksFG4mIbdinxC66DkodYUvnfggi5/PNVrPZcbLR/FT14bds9Gl4nIMA42LskSp1WyEB25rj69pi5+DGAVtmmwWXLDOD3D6lqvc9eTy190X/dAYuM6sbYPSxHH3bQZ+rf1n2qsDq5/iASMYRyYJNUxh0LMcN44RiEBC8FVfrABmp5b6kdjS01yv3OPFql+gzG4tyITRpAOeV8Puma1dcJ2scEFq+kwlKk+nhQR4d9DCp1fp7P4bpX8CBr9HYqALme
 hU7erGXG
 NinexQu/uwc56XZXv/iB6gvImbdqwqIUeo52xUHJ6r1GE+SfMWdonTlyVylB7+F+T/24KgoHiCSflKPkA9cu0RAlDv/AQO5U5k1ur8CHjOO5th4YFsiSmRrSDSZvqHG8kpMFzWrrbJD/vmsioJ3FgW05TYCNQFvPGkFC8elZnLd21GxNwb5U6M8GW1tgtmKkMg6Fyqy6eXP7BGFJIl9hBDyERxsrqeag2dMo8rdzyej++LVxk/0b3eg8IgLX6YN/npp6u7+ZBUzqk6YKql366dHyFsXiiT+BOgNjNlwKsn1tE4OCyKzofSg+eAT5FPx/rT4qAiaMEjIJEFSGeBlx/w6dKPuppPO8fkOsGO0TG1Rz2nSkgwWXFy/d5NrCxqKm4BxP7xviYidBZZXKTxRm/Ep2l2u1BTB3/afxG7uBufnvCvSUgakK8Eh+2JxtYbxFXfNPVlQl7LGaPdzcWJj873ss+zeyHzq7zTtak/Lhgii/oMGaTYlED8tk9DqrqmSrq7+dsn3HLkL/DAlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for your replies, but I really have to stop doing deeper analyses like
these for time management purposes.

I did this more so to make the point from [0] as to why, in lower trust
environments, this is just not feasible.

We could loop around for hours and hours and hours here.

In general as before, even if all worked perfectly (I'm very much not at all
convinced), extending anon_vma and pinning VMAs is simply a no-go for
architectural and complexity reasons.

I also find the locking story dubious and the lack of tests or anything
corroborating correctness is additionally fatal.

And finally, I was already working on a replacement for anon_vma, and the
generally done thing in these situations is for my work to take precedence.

So I'm going to bail out on futher deeper analyses here as otherwise I simply
can't work on anything else :)

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/ah887A5VkXOcmq-g@lucifer/


On Wed, Jun 03, 2026 at 11:05:28AM +0000, wangtao wrote:
> > >
> >
> > Against my better judgment I'll address the stuff here...
> >
> > > VMA operations can be roughly divided into three categories. The
> > > handling of ANON_VMA_LAZY is briefly described below.
> >
> > I don't agree, there are plenty more VMA operations. But with respect to
> > anon rmap there are:
> >
> > - fork
> > - merge/split
> > - remap
> >
>
> Yes, these are the three categories. I originally intended to explain them
> by classifying based on system calls; I should have used mremap instead of move_vma.

I don't think you mentioned move_vma()? Maybe I missed it.

The categorisation is most usefully based on callers of anon_vma_clone().

>
> 是的，是这三类，我本想从系统调用去分类说明，应该将move_vma换成mremap的。
>
> > Your approach seems to completely ignore VMA split and the need to
> > maintain an interval tree to _multiple_ VMAs from a single anon_vma.
> >
>
> The folio uses vma->root_vma to compute folio_address. A VMA split from it,
> vma_a, also uses vma_a->root_vma = vma->root_vma to compute folio_address.
> During rmap, once folio_address is obtained, the VMA can be found through
> mm_mt. Without fork, there is no need to maintain the interval tree.

Well you need to search for every possible split VMA in mm_mt now, so you have
to go page-by-page searching for each page for the rmap walked range.

You're also potentially racing against a remap, as you say below you don't folio
lock on remap so concurrent rmap walkers can be present, the VMA can already be
copied.

We already have VMA lifecycle state around detached VMAs, so a VMA could be in a
detached state, assumed by the existing logic to be entirely unavailable for
use, out of the maple tree altogether but kept around in a zombie state.

We'd then have lifecycle issues and races and edge cases around process teardown
otherwise we might leak memory.

Also, presumably you set vma->anon_vma to some lazy sentinel value so that mremap
doesn't change vma->vm_pgoff when unfaulted?

You would need to update any path that manipulates vma->anon_vma also so it
doesn't incorrectly dereference it.

>
> folio使用vma->root_vma 计算folio_address；从vma拆分出的vma_a，使用vma_a->root_vma = vma->root_vma计算folio_address。
> rmap时得到folio_address就可以通过mm_mt查找到vma。
> 不fork就不需要维护interval tree。
>
> > You may also actually split a VMA against a single large folio (waiting on the
> > deferred shrinker) and have a SINGLE _leaf_ anonymous folio that is mapped
> > in two places.
> >
> > The lazy approach doesn't seem to address this properly. And fatally it ties an
> > actual VMA afaict to the folio and has to implement a VMA reference count
> > mechanism which interferes with the ordinarily VMA lifecycle to do it.
> >
> > The fact of us taking advantage of most stuff being AnonExclusive, i.e.
> > 'leaves' is something that my approach is exactly taking into account.
> >
> > Of course also extending anon_vma is a real non-starter.
> >
> > Also the below + the series ignores MAP_PRIVATE file-backed mappings
> > which is a pretty fatal flaw.
> >
> > It also, as Harry says, has zero description of correctness in a way we'd want
> > and no tests.
> >
>
> 可以正确处理拆分vma在一个大页。拆分的vma_a或vma_b上的sub_page使用如下方式计算地址。
> 对于文件vma的cow 匿名页，也用同样方式计算page/folio地址。
>
> It can correctly handle the case where a VMA is split within a large
> page. The address of a sub_page in the split VMA (vma_a or vma_b) is
> computed using the following method.
>
> For COW anonymous pages originating from file VMAs, the page/folio
> address is also computed using the same method.
>
> subpage_address = vma_address(vma_a, subpage_pgoff, 1)
>  = vma_a->vm_start + (subpage_pgoff - vma_a->vm_pgoff) * PAGE_SIZE
>  = vma_a->vm_start - vma_a->vm_pgoff * PAGE_SIZE + subpage_pgoff * PAGE_SIZE
>  = vma_mapping_base(vma_a) + subpage_pgoff * PAGE_SIZE
>  = vma_mapping_base(root_vma) + subpage_pgoff * PAGE_SIZE

OK but you want to walk entries in a _range_ in the interval tree.

So you are then now looking up VMAs (in a racey way) using mm_mt (which is the
whole basis of my work actually) which could change under you.

I guess what you're doing is using the pinned 'root' VMA as the basis of
everything, and the second a VMA is moved you (somehow) walk the page tables to
update the folio->mapping.

Again pinning the VMA like this and putting it in a folio is really not
something we want to do.

It adds a ton of complexity and also impacts VMA lifecycle which is already
fairly fraught.

It makes the VMA no longer just a VMA but rather also a 'memory' of where
something was first faulted in as a hack more or less.

>
> > >
> > > 1. fork
> > >
> > > fork duplicates the parent's mm/mmap. (exec creates a new mm/mmap
> > and
> > > is not involved here.) This can be viewed as copying the VMAs with
> > > identical virtual addresses into a new address space.
> > >
> > > If the parent VMA (pvma) is ANON_VMA_LAZY, it is first upgraded to a
> > > regular anon_vma. The corresponding folio->mapping is then fixed in
> > > try_dup_anon_rmap().
> >
> > And so we make fork, a very sensitive path in the kernel more expensive.
> >
> > I also question the locking situation with the conversion mentioned, updating
> > folios in this manner is extremely difficult.
> >
>
> Because rmap takes the PTE lock, while fork takes the mmap write lock,
> the VMA write lock, and the PTE lock.

The PTE lock is not held for the duration of an anon_vma lock.

You will break anything that needs to hold the anon_vma lock for the duration,
e.g. migration.

This is substantively the issue I am working on in my approach and as per
https://ljs.io/scalable-cow-lsf.pdf you can see that's an open question that I
am currently researching.

>
> Given the rule that folio->mapping can only transition in one direction
> from lazy_vma to a regular anon_vma, the situation can be handled
> correctly even without taking the folio_lock.

Folio lock serialises against concurrent rmap walks, and you can end up reading
a lazy_vma that later gets converted into an anon_vma concurrently.

>
> When rmap and fork run concurrently:
> If rmap observes folio->mapping as a regular anon_vma, there is
> obviously no issue.
> If rmap observes folio->mapping as lazy_vma, then rmap only processes
> the parent's pvma. At the end of rmap_walk_anon(), if we see that folio->mapping has
> changed to a regular anon_vma, we simply process it once more. The
> various rmap_one implementations are idempotent anyway.

Hm this all seems very racey.

>
> BTW: the commit message of patch 13 says a retry is needed, but the
> retry handling was accidentally omitted in the posted patch.

:))

>
> 因为rmap获取pte锁；fork时获取mmap写锁、vma写锁、pte锁。
> 只允许folio->mapping从lazy_vma单向变成regular anon_vma的原则，不获取folio_lock也可以正确处理。
> 当rmap和fork并发处理时：
> 假如rmap看到的folio->mapping是regular anon_vma，显然没有问题。
> 假如rmap看到的folio->mapping是lazy_vma，则rmap只处理了父进程的pvma；
> 我们在rmap_walk_anon结束时如果看到folio->mapping变成了regular anon_vma，则再来一次处理即可，毕竟各种rmap_one实现是幂等的。
> btw：patch 13的commit msg说要retry，但是发送的patch由于操作失误漏掉了重试处理。
>
> > >
> > > 2. mmap / brk / mprotect / munmap
> > >
> > > These operations create, modify, or remove VMAs in the current mm.
> > > They may split existing VMAs, merge adjacent VMAs, or remove a VMA
> > from mm_mt.
> >
> > mmap and brk are not at all relevant to anon_vma, as no anon_vma is
> > assigned upon mapping. It's on fault.
> >
> mmap/brk 指定地址时可能导致匿名 VMA  merge 或 split。
>
> mmap()/brk() with a specified address may cause anonymous VMA merge or split.
>
> > mprotect/mlock/munmap/etc. might split, but I don't see how the lazy
> > approach in any way addresses any of that.
> >
> 上边说了，split后rmap仍使用root_vma计算folio_address或page_address。
>
> As mentioned above, after the split, rmap still uses root_vma to compute
> folio_address or page_address.
>
> > >
> > > When a new VMA is created, vm_start, vm_end and vm_pgoff are
> > > initialized and the VMA is inserted into mm_mt. Although these fields
> > > may later be modified, the following value remains invariant:
> > >
> > > (vm_start - vm_pgoff * PAGE_SIZE)
> >
> > Err no it doesn't at all?
> >
> > If I fault in a VMA at vm_start, vm_pgoff = vm_start >> PAGE_SHIFT.
> >
> > Then if I remap it, vm_start changes, vm_pgoff stays the same, so:
> >
> > vm_start - vm_pgoff * PAGE_SIZE
> >
> > Changes right? And then that becomes essentially the offset from where it
> > was faulted in.
> >
> If mremap modifies vm_start, i.e., move_vma, a new VMA will be created.
> This corresponds exactly to the third point mentioned later: upgrading
> anon_vma_lazy to a regular anon_vma and updating folio->mapping.

I think updating folio->mapping here is problematic, I know this because I
worked on this very probably a year or so ago and found locking issues prevented
this from being workable.

>
> mremap时如果修改vm_start，即move_vma则创建新的vma，这正是我后边第三点说的：
> 将anon_vma_lazy升级成regular anon_vma并修改folio->mapping。
>
> > >
> > > We refer to this value as:
> > >
> > > vma_mapping_base(vma) = vma->vm_start - vma->vm_pgoff * PAGE_SIZE
> >
> > This is mysteriously close to being the offset I mention in my CoW context
> > work...
> >
> > I'm not sure what 'mapping base' means here.
> >
>
>   vma_addrss(vma, pgoff, nr_pages)
>   = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT)
>   = vma->vm_start + ((pgoff - vma->vm_pgoff) * PAGE_SIZE)
>   = vma->vm_start - vma->vm_pgoff * PAGE_SIZE + pgoff * PAGE_SIZE
>   = vma_mapping_base(vma) + pgoff * PAGE_SIZE
>
> vma_mapping_base depends only on the VMA and is independent of the page.
> Alternatively, we could also call it vma_rmap_base.
>
> vma_mapping_base只和vma相关，和page无关，或者我们也可以叫他vma_rmap_base？
>
> > >
> > > This value also remains unchanged when the VMA is removed from
> > mm_mt.
> >
> > Why does it matter what this value is on unmap?
> >
> If root_vma is removed from mm_mt due to munmap, it will still remain
> valid as long as other VMAs hold references to it.

Yeah this is something we don't want.

>
> root_vma如果被munmap从mm_mt中删除。其他vma持有引用，就仍有效。
>
> > >
> > > If a VMA is split and produces new_vma, the following holds:
> > >
> > > vma_mapping_base(new_vma) == vma_mapping_base(vma)
> >
> > This is a roundabout way of saying we offset the vma->vm_pgoff after split.
> >
> > >
> > > If two adjacent VMAs vma_a and vma_b are merged into vma_x, then:
> > >
> > > vma_mapping_base(vma_a) == vma_mapping_base(vma_b) ==
> > > vma_mapping_base(vma_x)
> >
> > This is just a roundabout way of saying the pgoff has to be aligned.
> >
> > >
> > > Assume the VMA where the first page fault occurs is called root_vma,
> > > and ensure that any VMA produced by split or merge holds a reference
> > > to root_vma.
> >
> > But this VMA can be unmapped later? Or remapped?
> >
> It can be unmapped. As mentioned earlier, if mremap modifies vm_start,
> a new VMA will be created.

But everything's racey?

>
> 可以被munmap。前边说了mremap如果修改vm_start则创建新的vma。
>
>
> > Holding on to a VMA and treating it as some kind of canonical reference with
> > a reference count completely changes what VMAs are, impacts the VMA
> > lifecycle, and produces unwanted memory overhead in itself.
> >
> During split/merge operations, we can try to preferentially use root_vma
> so as to avoid deleting it.

Adding yet more complexity and edge cases, we really cannot do that, sorry.

>
> 在split/merge时，我们可以尽量优先使用root_vma，避免删除root_vma。
>
> > It also raises concerns and issues around lock order which is very sensitive.
> >
> Both rmap and fork acquire the PTE lock, which ensures that handling a page
> with respect to a particular VMA is atomic.

The PTE lock only locks the PTE. That wasn't the issue I was raising at all.

See the top of rmap.c for lock ordering. There's substantial complexity there.

>
> There is no need to add folio_lock.
> When fork converts folio->mapping into a regular anon_vma,
> rmap_walk_anon can simply check and retry.

This seems like it won't work.

And again you're adding a lot of new complexity.

>
> rmap和fork时都要获取pte锁，可以确保rmap/fork在处理page的某个vma是原子的。
> 不需要增加folio_lock，当fork将folio->mapping变成regular anon_vma后，rmap_walk_anon检查retry即可。
>
>
> > >
> > > During rmap we can compute the folio address using root_vma:
> > >
> > > vma_address(vma, pgoff, 1) =
> >
> > What's the parameters here? What's 1?
> >
> > >     vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT)
> > >   = vma_mapping_base(vma) + pgoff * PAGE_SIZE
> > >   = vma_mapping_base(root_vma) + folio_pgoff * PAGE_SIZE
> > >
> > > We can then use folio_addr to locate the VMA covering this folio.
> >
>
> I overlooked this earlier. We can unify it by using pgoff as follows.
>
>   page_addr = vma_address(vma, pgoff, nr_pages)
>   = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT)
>   = vma->vm_start + ((pgoff - vma->vm_pgoff) * PAGE_SIZE)
>   = vma->vm_start - vma->vm_pgoff * PAGE_SIZE + pgoff * PAGE_SIZE
>   = vma_mapping_base(vma) + pgoff * PAGE_SIZE
>   = vma_mapping_base(root_vma) + pgoff * PAGE_SIZE

It's really just saying

>
>
> > I'm really confused by this, you're kind of mixing and match parameters here.
> >
> > What I think you're saying is that, if a folio hasn't been remapped, you can
> > figure out its address based on page offset.
> >
> > That's completely broken for MAP_PRIVATE file-backed mappings which also
> > use anon_vma and also have to keep on working.
> >
> > It seems that for the lazy approach what you are doing is essentially caching
> > the 'root' VMA in the folio. But this doesn't account for large folios and split
> > VMAs.
> >
> As mentioned earlier:
>  subpage_address = vma_address(vma_a, subpage_pgoff, 1)
>  = vma_mapping_base(vma_a) + subpage_pgoff * PAGE_SIZE
>  = vma_mapping_base(root_vma) + subpage_pgoff * PAGE_SIZE

I'm not sure what these

>
> > Even if you disabled it for those cases (which adds a ton of complexity in
> > itself), you then have issues with locking - the anon_vma lock has to take a
> > lock (that cannot be a VMA-level lock - results in lock inversion) even on
> > these leaf entries, or you break locking.
> >
> When there is no fork/mremap, we do not need the interval tree or the anon_vma lock.

We need to stabilise across the VMAs.


>
> 不fork/mremap时我们不需要interval tree，不需要anon_vma锁。
>
> > And we can't reasonably start pinning VMAs and using them as a sort of
> > proto cached thing on top of the existing anon_vma logic.
> >
>
> In most cases, root_vma is actively used.
> Although it may be removed by munmap, overall it still saves memory.

For what workloads? Where? How?

It's adding complexity we can't have.

>
> 大部分情况下root_vma都是在被使用的，当然可能被munmap删除，但是整体上节省内存的。
>
> > You also then need to, on remap, undo all this, which requires updating
> > folio->mapping on remap, something I tried doing previously myself, but
> > that's fraught with issues around lock inversion itself.
> >
> > >
> > > 3. mremap / uffd_move
> >
> > userfaultfd moving is not relevant as it actually updates the folio correctly.
> >
> These two operations are different from the previous two types,
> as they modify the virtual address of the page/folio.
>
> 这两个操作和前两类不同，修改page/folio的虚拟地址。
>
> > >
> > > If only the size changes and the start address remains the same, there
> > > is no impact.
> > >
> > > If the start address changes, the page is moved from (vma, addr) to
> > > (new_vma, new_addr). In this case:
> > >
> > > vma_mapping_base(new_vma) =
> > >     vma_mapping_base(vma) + new_addr - old_addr
> >
> > You say above that the mapping base never changes? But here it changes?
> >
>
> For the newly created new_vma, vma_mapping_base(new_vma) is not equal to vma_mapping_base(vma),
> while vma_mapping_base(vma) itself remains unchanged.



>
> 新创建的new_vma的vma_mapping_base(new_vma) 不等于vma_mapping_base(vma)，但是vma_mapping_base(vma)不变。
>
> > >
> > > We first upgrade the VMA, and then fix folio->mapping in move_ptes().
> >
> > What's 'upgrading' a VMA? You mean converting the lazy anon_vma to a
> > 'normal' one.
> >
> > As above, this is fraught with lock inversion issues.
> >
> Yes, it upgrades from a lazy_vma to a regular anon_vma.
> As mentioned earlier, during this process we hold the mmap write lock, the vma write lock,
> and the pte lock, so acquiring the folio_lock is unnecessary.

What's preventing a concurrent rmap walk?

>
> 是的，从lazy_vma升级成regular anon_vma。
> 如前边所说，这个过程中我们有mmap写锁、vma写锁和pte锁，可以不获取folio_lock。
>
> > >
> > > If performance becomes a concern, ANON_VMA_LAZY can be enabled
> > only
> > > for relatively small VMAs.
> >
> > I think you've got serious correctness, lock management and complexity
> > issues and it's all a non-starter as the costs deeply exceed the benefits.
> >
>
> I think the approach is feasible:

For complexity and architectural reasons it's not.

>
> 1. During merge/split, the newly created vma_a satisfies
> vma_mapping_base(vma_a) == vma_mapping_base(vma) ==
> vma_mapping_base(root_vma). Therefore, we can use root_vma to
> compute the virtual address of the folio/page mapped by vma_a.

I don't love these formulas. You're storing the originally faulted-in address in
a VMA that you've pinned for the purpose of that.

If you happen to merge right a lot of times you keep around dead VMAs just for
this purpose.

We're not having VMAs have a dual-role as a 'store of the address first faulted
in' as well as being a virtual memory range.

>
> 2. During fork and mremap, we hold the mmap write lock, the vma
> write lock, and the pte lock. In particular, the pte lock ensures
> that rmap and fork operations on a folio/page within a specific
> vma are atomic. If folio->mapping is upgraded during

How does a lock exclude something that doesn't also hold that lock?

This is also adding _yet more_ complexity and subtlety. It's really a hack.

> rmap_walk_anon(folio), we can simply let rmap_walk_anon retry
> once.

Again, 'just repeating' if something changes like this without proper
serialisation is not sufficient.

>
>
> 我认为方案可行：
> 1. merge/split时新创建的vma_a有vma_mapping_base(vma_a) == vma_mapping_base(vma) == vma_mapping_base(root_vma)
>  所以我们可利用root_vma计算vma_a映射的folio/page的虚拟地址。
> 2. fork和mremap时我们持有mmap写锁、vma写锁和pte锁。
>  特别的pte锁能确保rmap和fork在folio/page在某个vma上的操作是原子的。
>  如果rmap_walk_anon(folio)过程中folio->mapping有升级变化，我们让rmap_walk_anon retry一次即可。
>
> > This is one of the fundamental, frustrating aspects of the anon rmap - you
> > keep thinking that 'surely' you can do sensible thing X, but it turns out you
> > can't for various annoying reasons.
> >
> > It's one of the reasons it's really fraught for somebody coming to make
> > changes, and one of the reasons why I am very keen on fundamentally
> > changing it.
> >
> > And also on a not-wasting-time basis - I was already working in parallel on a
> > rework here, so I think the civil thing is to at least wait for my work before
> > issuing alternative solutions.
> >
> > Thanks, Lorenzo
> >

