Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC845CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D74A6B047D; Mon,  1 Jun 2026 13:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADD16B047F; Mon,  1 Jun 2026 13:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA4A6B0480; Mon,  1 Jun 2026 13:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F21F26B047D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:08:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B94201C0CEF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:08:53 +0000 (UTC)
X-FDA: 84831978546.25.139FFCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1C8AD120008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:08:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdiSuNz6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780333732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBXI4HbJibjDLVvDetMK7+6KAjdi6I5+A1gy4GVSqbY=;
	b=ugj5opajH6lPUitisQctO2KJUkPhyQIeabINSf6k3fKWZeB6bK6d/gSFng9YWqOmAnAvnH
	tPGnxLL5gIrijr3hg/uSTlXTZfVOlrQ6I4fTeQwLcO4+9K7l9PXpZdmEKcbck7D45QbWFS
	rlDstdvVDrUbiainX9YpB17TNyTJl4w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdiSuNz6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780333732;
	b=LiDnr1W+kY+fFq61vVW2bY+lShda+uo9eeQrFIJNmdB5wvdJuns/toUmaHvzrBL2Fpiddn
	AW2Qbk4p2gQGGDUeRNBtQ+SHUxnhK7cnVnLQhX+O2QXrzydzegtbfImQpfzDU3GlNA9r9J
	v7aGPPhUeutdP0whKOXufPlRM5lRNsE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43314404E3;
	Mon,  1 Jun 2026 17:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B72B1F00893;
	Mon,  1 Jun 2026 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780333731;
	bh=EBXI4HbJibjDLVvDetMK7+6KAjdi6I5+A1gy4GVSqbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hdiSuNz63MftBuD8XNFnT8sEmDqA1Vfhdf0FTLIV0LEyU9ZfxYDXAgk2Pk8RT5LEb
	 Jrdn+y0//I/UejlL3wJOCX2Laq65odRaPmXRHWfIXTXAzkmoVV0qEVeqqNU/cXnF3b
	 vte2aEfqZcJowbZf/aBEwMelM7YB+ppWKwOOoFYYCMHE3siBqhx45paLmoZhnDaDkq
	 0GjY/6l8xiQOANQGNuqD/dbt9vxee/tRcAA8W73u6Mb9X2jGWHa26QmsrT9itRWkwL
	 l51vmTttsVev/EPzBafewKWUkGMIZ4GYFwpbKtDHPHVNKQwx6K8dKm6mPMHMZx1cbY
	 U0bTqbsxsEcqw==
Date: Mon, 1 Jun 2026 18:08:34 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	linux-s390@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
Message-ID: <ah2z26OzPktchVeT@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522134724.f4f11941a85ef18b307d16ae@linux-foundation.org>
 <20260601155808.2755103A59-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601155808.2755103A59-agordeev@linux.ibm.com>
X-Rspamd-Queue-Id: 1C8AD120008
X-Rspam-User: 
X-Stat-Signature: 78x3s8im1hbx5qqur4r5fjst3ktfzzwe
X-Rspamd-Server: rspam09
X-HE-Tag: 1780333731-315646
X-HE-Meta: U2FsdGVkX1+YOZVffqFieb3tPYcmByKqbb2pNMlnt1Zqd2U/d1Qu7PZk7E6Ibu7MsOflym6C0KInP65rwcYwm97orADpRTIUCWfC345EFAqg+TLH7DtGvw2luVlGcUXhseVXKMwJxoKIXshccpDTGXkuvEFzsppvEAhWDgdGZtwimOkv6xW4tHXw9d4x8bvJRiDnlUQ1FLIUlDDzZHTQMnKZPFvaSM+2CLeFNtI7DCqp979f27fmtXBzzQmcy5GVfvk1GlH0aH5D0spKimFw/xfv8FxLXrVYJOjcG7lo65UsW5Cg0FnRLRdiIBZtm0NqOej4HH23QPyR9iUf7xWe5e0aZbC9iDMilq8GXHBt+tMQHLefjXJMAX5Z4Iae5k6c+eq4mXBSLnFZB7tBI1uBvfEzpacHR+S2MBge8gh34T+6l9/SrH1j7l5j9oGh7uN1G8IBf0NaT1n+vWhYYPe92qe/N3YHLWpEyg1aHqX8YtNxO7b8sDZf4HdZruFMW0QFMx/0cUmzAv2o7PlmtHWZIdSWTNsfsngEKym/HxYdecn18NB8O5Gl187/DpKwqqzMxRnF38Y2uad72rARgKJwD7BJMT9pRYa3X9QK9fBqo0GdqUG7YQv+Lc+LsO2laConFZVjpZRShejN7BL7ekQzrGgi/NRn3RpkeIGJshH4CfzTWrQk83NDBmgkzY6Kn95v8N2Y6zP/eQ0eRi2NOgHWUQ3Ydywn94bfApL9frKuMh76N9Q0JTpxuKwv9tjbQ6i5clfvkAijXtmOl/6Wwf9SUSaLBVvXddLoAEiKY5dMobm6ooDHSGx0mbOxhUEk4g1WBEme3ajLwtMyYRPDg55XPq0NcJ2s275Mq48PBBlmMuVUwVbXGl2OEO7ArnyApzOwCxUqf6tllTw5w8OoJNPO7G7FPyqWQbwCLyel8CIiqb0KqxNJEog8fM35/85bGk9uuMZmH3bddsO/ZaV3ioL
 Qe1nZEl8
 q9yqtcE6j3ZIq9dQXAyCKWv4ni77vISERt9110HtF7KkRuRZ30qPlu8YElLbRgo3u2G/efuahWzNDc1j35N4p1eduvVGt17z4XOV5ktdxVlOTuQM+MEuBEEBCk6iLHMmwjULPRovMrvXBlDLjtvVnxCsq3hXcjnH2fVwvKnrbtFuR1D0whw7X0OO40LJct1Q3uUYRCPCm2grlHJ86nS5DiWfm6Gr1TMdDfCSw5A+/Cuhatn+ZYeRdhq6/eL5rViNAD6CLbDMPW8/AXvzoVtvSje8yEuDBo2+Nf6zS8HkXHXakb59tBcSPn/P79xQpQzqT2ZluUtUu7ATasXhaP+fpffmqolhG2/7cDO18
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:58:08PM +0200, Alexander Gordeev wrote:
> On Fri, May 22, 2026 at 01:47:24PM -0700, Andrew Morton wrote:
>
> Hi Andrew et al,
>
> > On Fri, 22 May 2026 08:59:55 -0600 Nico Pache <npache@redhat.com> wrote:
> >
> > > The following series provides khugepaged with the capability to collapse
> > > anonymous memory regions to mTHPs.
> >
> > Thanks, I've update mm.git's mm-unstable branch to this version.
> >
> > It sounds like I might be dropping it soon, haven't started looking at
> > that yet.  But let's at least eyeball the latest version at this time.
> >
> > Sashiko was able to apply this, so the base-it-on-hotfixes thing worked
> > well, thanks.  The AI checking made a few allegations:
>
> This series appears to cause hangs on s390 in linux-next.
> The issue is not easily reproducible, so it is not yet confirmed.
> Any ideas for a reliable reproducer that exercises the code path below?
>
>     [ 2749.385719] sysrq: Show Blocked State
>     [ 2749.385730] task:khugepaged      state:D stack:0     pid:209   tgid:209   ppid:2      task_flags:0x200040 flags:0x00000000
>     [ 2749.385735] Call Trace:
>     [ 2749.385736]  [<0000017f63c8b226>] __schedule+0x316/0x890
>     [ 2749.385740]  [<0000017f63c8b7dc>] schedule+0x3c/0xc0
>     [ 2749.385743]  [<0000017f63c8b888>] schedule_preempt_disabled+0x28/0x40
>     [ 2749.385746]  [<0000017f63c902ea>] rwsem_down_write_slowpath+0x2fa/0x8b0
>     [ 2749.385749]  [<0000017f63c90910>] down_write+0x70/0x80
>     [ 2749.385752]  [<0000017f6313407a>] collapse_huge_page+0x2ea/0x9e0
>     [ 2749.385755]  [<0000017f6313491e>] mthp_collapse+0x1ae/0x1f0
>     [ 2749.385757]  [<0000017f63134fda>] collapse_scan_pmd+0x67a/0x8f0
>     [ 2749.385760]  [<0000017f6313751a>] collapse_single_pmd+0x15a/0x260
>     [ 2749.385762]  [<0000017f6313792c>] collapse_scan_mm_slot.constprop.0+0x30c/0x470
>     [ 2749.385765]  [<0000017f63137cb6>] khugepaged+0x226/0x240
>     [ 2749.385768]  [<0000017f62db3128>] kthread+0x148/0x170
>     [ 2749.385770]  [<0000017f62d2c238>] __ret_from_fork+0x48/0x220
>     [ 2749.385772]  [<0000017f63c95d0a>] ret_from_fork+0xa/0x30
>
> Thanks!

Hi Alexander,

Thanks for the report.

It's a pity it's non-repro, I had Claude have a look at it and it couldn't find
a definite issue with the code at v18, all the locks seem balanced internally.

Things it highlighted FWIW:

- Far more mmap_write_lock()'s being taken - the stack-based approach calls
  colapse_huge_page() multiple times per-PMD each of which entails an mmap read
  lock/unlock and mmap write lock.

- anon_vma write lock held for a much longer period over partial collapse.

So maybe these are triggering issues rather than being the cause of them per-se?

If you happen to see it again could you give the output for:

'echo t > /proc/sysrq-trigger' so we can track who holds the contended lock and
get more details on it?

Also the .config would be useful.

I'm guessing you've also not enabled mTHP in any way on the system?

Repro-wise you could also:

# echo 1 > /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs
# echo 1 > /sys/kernel/mm/transparent_hugepage/khugepaged/alloc_sleep_millisecs

To get khugepaged going a more aggressively:

$ for f in /sys/kernel/mm/transparent_hugepage/hugepages-*; do echo always | sudo tee $f/enabled; done

Then maybe some stress-ng like sudo stress-ng --vm 4 --vm-bytes 2G --vm-method
all --timeout 5m (or maybe something more refined :)?

Maybe some of this will help repro more reliably?

Cheers, Lorenzo

