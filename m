Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD9FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CA16B0137; Mon, 13 Jul 2026 12:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903816B0139; Mon, 13 Jul 2026 12:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8197F6B013A; Mon, 13 Jul 2026 12:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 529F76B0137
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:32:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1F3A40217
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:32:16 +0000 (UTC)
X-FDA: 84984295872.12.52A82EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B49DA20005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:32:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dr/T0UW3";
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XO5F4pQ+uHUwJNwX9eNu6Me3Gfi6NA9rxgfZG/tLNj4=;
	b=IBc93mmU/jiZJMyl0IXBiW6Vjim4x+J5ogrpKAVWRZu5zyTdi3gjJgwOxlhgbqZ9hEuPeJ
	SJuTyv2xMaHBlLukznAJcGbTKqfVWS93ni5XjtvaWH2TefL4V+pWWZv+i7GvdATXV/2TyL
	jvlOgBvHhkhaECvqrSNTUES3Uv6XwLg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Dr/T0UW3";
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960334;
	b=3iA8DYVUdtFpR1LSJAdp5Jh/8F+02AG++iZMAsuCHkjMfM4oSMi5Ufdr9i1j/8KfRH8lcR
	1fNYQ1TCD6Nb/iiD0Jn6w7iuEX9UgH7gM5ZDX90/J335jhSI35ZBX9B9Eob14+BuevGhOJ
	ria84+5QDELpMsQyiDDlhjN1QJwNOSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECB734192E;
	Mon, 13 Jul 2026 16:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0B31F00A3D;
	Mon, 13 Jul 2026 16:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783960333;
	bh=XO5F4pQ+uHUwJNwX9eNu6Me3Gfi6NA9rxgfZG/tLNj4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dr/T0UW358QKTyZ8NRkKIsBQJ3dyMVgEz/caYGlVwcnosPrgXCUaQ0tKWeGdGEtnV
	 Hn2nxF8JA5g/wIte3wfbOZui9fvR0yROP8q17ET94eSczCOAY+luULqcoUvDBXjmUW
	 bbmauJ43oP03TXO206VDpvYseK8KUPntooAlZgZackHXLtiHsaBAtVp0WJbo3w9+X9
	 BhInQ5Dy5EQLQXpTU5hcnu8FfIfaq7m+YyPEAfOMauolfIJo9vP44+bC/+Ua9DJKlw
	 wUs17vjPiy6A4ZbpE6ZzQCPGyj6IQGi6N3cxvdJgE2bpIA3orPNz9wBpLgioD5kqK3
	 OSOdfGBhiviIQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 67056F40252;
	Mon, 13 Jul 2026 12:32:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 13 Jul 2026 12:32:12 -0400
X-ME-Sender: <xms:DBNVakdTAH7A03y0PVsUFydyobOSVexxJSFqlFeaXN2gJuW21w9G-g>
    <xme:DBNVamq3e2f8o6fdaIqgkHcG5wn0i8Mo5PPwNmbm-cqI3yJ6s_0LsnH-PSKezPO_r
    rS71P2dADZq1uKOuziFaY3t6BMqI3GiybLmbUtfDNQWOwxOzZMaMuU>
X-ME-Received: <xmr:DBNVam_qkOSms9UlXYzdeQQfCJyepU29MkMP3HSjmhZK6Gw2vdrN_57JNMUNHg>
X-ME-Proxy-Cause: dmFkZTFq7auBfYltiyKJgfsKmtNrxbtFQPID/Ha/Lse5/6brVgWYZB5+s1G4w4NrQdjRlo
    S+9ZluVXTS0Mx8qv4yUojVg1/rEXTSXvInmMbAfYx0T1GWN4yTyFiK4MrwlsqiKhtualXn
    W9EKSMdhAS2RHbfypEfgho+96CGT6KW9+kcjqdU7cAp73Anek3JkyeYo0JzGt5C+anyzur
    xRxqjo2YlbJpkbLtJfh3tio8Vw1X4VMa7Q/BEm3quwxbg2Mt1IbwYOJhVfV+bjSxaxuNqw
    Z9WTROtWkq/gxmF7OGIOcKnkDVOiSMYI7yAwkjOFJvzGqkK4VsJJEdIw89xpz39LDTAKnR
    D/1MW8lIqw+Tw47z6Z1dy1q3aRmclnvSj8mZ/S2W5WHprDcMBXt5vkBBmyyR2uTEmlfhgN
    /9p25W5wlwyrRZwrbiQoXXyTJcK66yp6mCcgyZnMUxsyhHEuaXxN+6dWDoojCUw5i5EM3S
    CSWoXeam3rydYUAbhPgB/qYhB7YbRzEyDaYue7+ROqZ0g8HuEBsCy/jqB4qGjfXlkzrEJt
    BD9rN8il3ulOjy9oSwhvomtPaEMzT3DZ5o075tMAhOBZRJmRBcQoH4c7KXbhiuMerE2wgX
    eSPviL18pHUK7/M/mvmBrgkMJPwUi/UraqageBJ7L3SJep6hPeUykZ3EXsFw
X-ME-Proxy: <xmx:DBNVap-yUhFRI3GY-f0hINUiQDYxdT8yMa8up0rYkkj3fE9AlCbYGw>
    <xmx:DBNVagFU1EIHxdnNB-EwqO1fyV0dt7WFZ3_grIqCpowx966aa2GngQ>
    <xmx:DBNVaoflV0_VXGYAV9XBf8xTv8TLV1LUgzckvmPnY3_lIhXEdgfMWg>
    <xmx:DBNVavIWlmU-Em9Uflbr3BetO8FaVtw8-Qxcp5x6sLaWppodvhnMDA>
    <xmx:DBNVahpEobbyVz5NrCvkSki_p362I_vspPvZgl4OsK-IW5KwWY57aAo1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 12:32:11 -0400 (EDT)
Date: Mon, 13 Jul 2026 17:32:10 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, 	Uladzislau Rezki <urezki@gmail.com>,
 Toshi Kani <toshi.kani@hpe.com>,
 	Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 	Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, 	Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 	"H. Peter Anvin" <hpa@zytor.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, 	David Carlier <devnexen@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 	bpf@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v2 0/4] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-ID: <alUNiWcygLd4rqBo@thinkstation>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <alTn7NguEW_4bodu@thinkstation>
 <alTq4V50767L-s5H@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTq4V50767L-s5H@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B49DA20005
X-Stat-Signature: sd6u49aohzk6pbzntd5eoe3ktwf5b5aq
X-HE-Tag: 1783960334-618560
X-HE-Meta: U2FsdGVkX184k3ER3yq848G5lvsOIw7UCc4G0lXthkzWfwq55uYvvPUWXm3tdze34sEvgluuVfp1oQ9DRWbEG8w6NMeU/3Ffyw7AEU10VacJ4PV26bnSnQbF9HAXNtaTZAUCNARwaGw3qegaaX4FKxymHbg94LLTjtnd4XRrWS9eRCS8nIeOFW/aflBsFNCQ1OzaSlWtbiKNhfNGgyL2oUN2iRpe0d7uEOFF4+c2oSHEm/0YShJa0hdBVbjNIqwOjZzZh67NnMxSgtNnNVuw0ybEcEJbKFEtoQyFOXnJ9jqN+kkFmoeCx5Xt4RmQKrvTEUsczgUJTQz0fNKBJZVxaXC47AD6dzx5AG1+wxSE22z6XdZilkLaJr1LQdK9ah1OVFXfl9q5y0TNMGMrUGVUuGTligo/InBDO57jMjfmb/l1gmw2JoFTnZylS1ArTxXDvt0+xxNxu8yNnXd+FARotdiO5x4CTaRFptUuTJW8Qa/3NnQC8pJKmv6WYu8q3vc7rP+XPEAf5Z9QEapm63dESZvC8cSrckJQdttAjWgE0CW6VTjJTpgumwFiaPIJaJ9yf89Jx0k611zkJRuPKbROyr4aPt0TqoRZQszZqG/u2FG/xfrRunoTsObQDc8x40Rjex4InOaYRvW3hubDe3ZvFfnDIIcoGXxZ9NLFhWDMbRMHly54piyEEPQWFRZTxG/WHmX9pLPv7nvgkz5EUtDIeE9ouWEOUqs883UuKWS3Cnyz8sNdu91nVvsVx13+kpLEByL8RXkn3UYxfXPJDnRuF7hwpIjHwPXXN12gvU3pI+qSPw12p9Ka1vX6bx9eQRDc6j7gRaOqnpwkLM2YRvlHoXlPhwIXIn3m6SXP1FrT9ICWanf23tOOuXZ8xxYTMFbPD0LSmw9vSw8udCALZZYUuaMFS70153wMryhrvM4Vgphuoz14oceEMg905XmHOxDTL95YuJf6qTgTK/0ZdVF
 8ZFV1KdA
 VdpT1lofUUr0FC9IGm4ivKopAwWQGTaeBIP8sf8clvyuDEtsOl97r2zhSdsRCqVeC/rv90jU5g5cnwHXq+BwZh5/K8o9LpjsB+PGCthPk1mZCWyZxV2FivzmubBqNs86jFv7Ds7RPJIjUiLu/Kfyn7TTmZSl1gihhoOiXo2tsf96o9Ws5inaL4UBsjfJ1ljrdNP3xNWn5QEHNhkJfUIclZxr0bxWPI4XWjLITBr2zom8MxyETZI1yN25kZeg9zS63ovMJx02wHZxaZmqhHR1g1/Mwq+XvwvsoPA38nLAgePIAqf+qTRJ3yQhqqOZI3Nf7R+FWSMzd0MfngoskT7DMjJz6lp3qi35cN0S5CJPl55SVAbRUz4ZLrtkYdsN/7RoxISLE5lOmDXQE0rZYUSJevQMfrdwCFyNZOYrk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:54:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Jul 13, 2026 at 02:32:09PM +0100, Kiryl Shutsemau wrote:
> > On Sun, Jul 12, 2026 at 11:42:23AM +0100, Lorenzo Stoakes wrote:
> > > This series addresses the issue by having the vmap huge promotion
> > > logic acquire the mmap read lock while both setting the huge page
> > > table entry and freeing the prior leaf page table.
> >
> > Hi Lorenzo,
> >
> > Before we settle on the mmap lock scheme, have you considered handling
> > this the way GUP-fast handles page table freeing -- RCU-defer the free
> > and make ptdump a lockless walker?
> 
> Overall I like the idea of eventually moving this to _all_ being
> RCU-free-able :)
> 
> BUT... I don't like it as a fix for this bug that has to be backported.
> 
> I think there's a lot of subtleties to worry about and I don't want to
> worry about having to maintain tht as a backport.
> 
> But also, we have an unfortunate situation with ptdump where it also walks
> userland ranges on x86 (and ranges for efi_mm on both x86 and arm64).
> 
> And for userland ranges you have to have the mmap write lock to exclude a
> downgraded mmap read lock munmap() operation (which gives rise to the weird
> inversion you mention).
> 
> So the walker still has to take the write lock in this case.

I think the userland side is fixable too.

My first thought was to walk only VMA-backed ranges, which would make
the mmap read lock sufficient: munmap() detaches VMAs under the write
lock before downgrading, and free_pgtables() only frees tables
exclusively covering the detached range.

But that is an unnecessary limitation on MMU_GATHER_RCU_TABLE_FREE
architectures -- which is every architecture with generic ptdump
support. There, user page table freeing is already RCU-deferred; it is
what GUP-fast relies on to walk user page tables blindly with no mmap
lock. khugepaged retracting PTE tables under the pmd lock is likewise
covered by pte_free_defer().

So the downgraded munmap() teardown you mention is already safe to race
with -- for a walker inside an RCU read-side section. The write lock is
only needed today because ptdump walks outside of one, so the deferred
freeing does nothing for it.

That would make the end state: the whole of ptdump -- userland, efi_mm
and kernel ranges -- walks under RCU with no mmap lock taken at all,
and the kernel-side freeing conversion we discussed is the only
missing piece.

> I spoke a bit about it overall at [0].

I think you forgot to paste [0] :)

> We already have this mmap lock convention as a requirement for kernel
> ranges, and it was being violated by CPA and vmalloc.
> 
> So I'd prefer we keep this as the proximate fix to solve the bug here, and
> then revisit this later (alongside moving to RCU page table freeing
> _overall_, though one doesn't have to block the other).

No argument, let's do it as a follow-up.

I will give the current patchset a proper review.

> > The free side looks cheap: kernel page table freeing already funnels
> > through pagetable_free_kernel(), which already has a deferred path
> > (used for IOMMU SVA). Adding a grace period there -- synchronize_rcu()
> > in the worker, amortized over the batch -- covers every freeing site
> > by construction.
> 
> Well I did want to say btw that CPA doesn't actually mark the page tables
> as kernel, was going to chase up with something on that when I got a chance
> :)

You are right. CPA allocates the split tables with bare
pagetable_alloc(), so ptdesc_test_kernel() is false and collapse frees
them via __pagetable_free() directly. Note this also means they skip
the IOMMU SVA KVA invalidation that ASYNC_KERNEL_PGTABLE_FREE is there
for -- that looks like a bug today, independent of ptdump.

> 
> synchronize_rcu() is a very bug hammer, you can just use call_rcu() (and
> the ptdesc already has an rcu_head I think).

Sure, call_rcu().

> Keeping in mind that vmap can (in theory) span PUDs and even P4Ds it
> becomes a bit tricky.

Since the walker only reads, I think it is enough to re-descend from
the pgd with fresh READ_ONCE() at each level after dropping RCU --
whatever level got promoted in the meantime, we see either the new leaf
or the old table. But agreed this is the part that needs the most care.

> 
> But also I worry about whether the entries in the page table will actually
> be valid at the point the walker reads them.
> 
> For vmap/CPA pretty much yes they are, but if something was to actually
> unmap them in future then that might no longer be the case. RCU will only
> guarantee that the page tables stick around, not that they contain anything
> valid.

For a walker that only reads, I don't think staleness is a problem as
long as frees are RCU-deferred: the walker can only reach a table via
an entry it read within its RCU section, and freeing requires unlinking
that entry first, so the grace period covers any walker that saw the
old pointer. Stale leaf contents are harmless for a dumper. It does
become a problem for anything that dereferences through leaf entries --
agreed that the general case needs more care than ptdump does.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

