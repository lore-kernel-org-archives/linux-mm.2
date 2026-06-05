Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F304CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93BBB6B00B7; Fri,  5 Jun 2026 14:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBF26B00B8; Fri,  5 Jun 2026 14:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3936B00B9; Fri,  5 Jun 2026 14:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 690696B00B7
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:40:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E04FC157B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:40:08 +0000 (UTC)
X-FDA: 84846723696.20.0137388
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E0B24000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:40:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I10tYfVd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTyJbpnjz0kWvq3rixWsFNs2cgyukhDKAnb80ImkEk0=;
	b=LKxlTuSnANT9acicx9Bk18kztuwuCSj+Ab7SAkSQGWcWfTokuVbdntnHVYxm5/XGoj8bnC
	71p6bOCnzgDAjjtbkWMXMPY7ax20ZYf1zpIR7WBAg7OtrSZeptAsp4A3tOPPGm+Mb8ZBv/
	cqifZbyDgaiKT7N36yoQ23Nc+/6rLow=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I10tYfVd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684806;
	b=K2jPxtvnQkDKtX/+skev04u5WzeXNdQMxms7u+hS05FSl03OcIQ5BLs7vbCIINoeg3SApC
	o6DbRSU0XM5qjRBtRjpoHhKlXQj8/wtd4GSkbXq6Db/d3pNKry3dEWXwnahLWQxCymH4g2
	sbNPnDmJcfdG/WMxWffi6LU40c6QBK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4B9C601DB;
	Fri,  5 Jun 2026 18:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276061F00893;
	Fri,  5 Jun 2026 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684805;
	bh=jTyJbpnjz0kWvq3rixWsFNs2cgyukhDKAnb80ImkEk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I10tYfVdKGGqSv/Q2EFZd58lQ1NVLROgG98kfjLYCeSLNbr0Z+YZ8eea48dvlaqy+
	 Qa457EFC2SY8r95cit4+OarwxX5irG2eXykkU6m5cHXKSQiOtOyoL7kjoR8SIulO1l
	 xwh/ScwA5P75F9KgnYp26rFR2Hd73t/bvTzRwWgZeRvQaNbU9WAZYpwqqDAYdSrpbM
	 teCvM9V2O/6MHPZuZIbgZyMNhAQuDJmuF6E08pXq1nvmHV5wUEW03KQiusiQyJpNLW
	 H8nSIqodzTx9MZCmaGSTZncnnfOdidaWz6DhMJpWxe6eAbG0IN6wXfG/ZLQMgDVnj0
	 gYeAhzXIDB1MQ==
Date: Fri, 5 Jun 2026 19:39:50 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com, 
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 00/14] khugepaged: add mTHP collapse
 support
Message-ID: <aiMXqZkOJ2dZgyDU@lucifer>
References: <20260605161422.213817-1-npache@redhat.com>
 <177704e1-03b3-4791-9a69-9b83b72d61d5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177704e1-03b3-4791-9a69-9b83b72d61d5@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E0B24000D
X-Stat-Signature: ymomk7wjuwstyb9zo6d9aj7db58k6o5i
X-Rspam-User: 
X-HE-Tag: 1780684806-685591
X-HE-Meta: U2FsdGVkX1+xoB2FOCrvoYtXdz1ZYksPDcQJ2ncFzKXSW8N715tMs5mUQpFzQWqd/f0U5cT3dj5HwQVNATDGxeevnoaORop1/BpRHTRn4h/YqMS2FvMcbmyoo8W5X9KhKrKOX9daFplj+IxIrqINKGjoLUFbvmyfBFWXT7Nzk7Ky9dbJIklI1zVFpIfr3VKG9kqE02BZupJZfMZ9nForeTgZvJ1aygImkx3U6eM6NU91a3uEKryApH5pOeDiC1bgRKUtzlfpcPLQCPWNwovpAg2h07UUXrU5b3tZC5euTgnspa50N7VOYUeWKOK6JThYGgkfpOzMpPuOSDbIZpge93iwn6niVNVNAjuiUdeft8AgqQ3QmECl+Irj4exLmYvPL4+8fXDNeKLEM0jbGA6w7ERkYx0gHWMumWW5ZOrx0MjDCYfX4hObcxMP2LtnOvtM2pUxo+WkSpFNV00/MXg46lStQA2UiC/GrjE7sYBoF8Ppg1rc1l/D9tvSW9M6+rTb/3R0/Cq4uVbi47vElR9brzXaKXAa01EGRZ3W98Tl0hotlVrCieFnWmUEZPRN1pbfh/Srz2sf1qoWa86iy89z0oXnN53yjePjDLxnjcxrrIrx0Vaix1ticxhb7nJUBZ+mzU5OUZY7uOyVWJ+Wk/kHiLxbEBo7kcU84tda0nLXp8Il2+DAfLyDNKWnp+NgYvPnKZuFve5O+sPyTaLUarH5kvPYilPvdp3SLI5hSmrMSr9LaxHIFbOrazCpVy12j5c388g34gZqq0yeOVgGCZvHkPuzQxXObkc+2HEV/TKr+GQVC+vvtjW+TFEI5rpvNnfwtLS7APdx/G01J1ZX275AmdB11lSrsMhSa14ARFnlN1F9Abwjpjy4u0Lz/oOMa8852g3yMCjxexjvOI/6vRULOG8YgktH6enW76WysTF4BhI6P4zljj6F4fODisIT9snh21UMbyYnhAr1xqTIe+i
 0TVmjouz
 Q3DOUiGgUkaIE091+9kP0myDCG7chbjx+DLMLh0zSIIqt9tPi7zxqnRDdud+UcPbkFHJgsQa3YVdxM8mUGFaYtzv3B8XQNPjxpg6WDvt+iGsGczjaiH/y+EbGo5dMr+dvHUZtX3y1Tn/7GNpCG9p+Ql7kk0ZesoQ5uWzFdyCYQOzhKZqDupeGEHorKht3J8hKFOP2MQ4icQ1y83SfjDv5Mg67aqxdoKQNCZhfI19MfCMujDQN85WzKNXwDEnMf8CFoz1xFCNtouZsC5jzLtHYSYYmnc9bSsy9cA+lUFwe4GWwowDEcg3HV4/nCJ0xbZyIp7cduuV2z7Rknj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 08:07:02PM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 18:14, Nico Pache wrote:
> > The following series provides khugepaged with the capability to collapse
> > anonymous memory regions to mTHPs.
> >
> > To achieve this we generalize the khugepaged functions to no longer depend
> > on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> > pages that are occupied (!none/zero). After the PMD scan is done, we use
> > the bitmap to find the optimal mTHP sizes for the PMD range. The
> > restriction on max_ptes_none is removed during the scan, to make sure we
> > account for the whole PMD range in the bitmap. When no mTHP size is
> > enabled, the legacy behavior of khugepaged is maintained.
> >
> > We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
> > (ie 511). If any other value is specified, the kernel will emit a warning
> > and mTHP collapse will default to max_ptes_none=0. If a mTHP collapse is
> > attempted, but contains swapped out, or shared pages, we don't perform
> > the collapse.
> > It is now also possible to collapse to mTHPs without requiring the PMD THP
> > size to be enabled. These limitations are to prevent collapse "creep"
> > behavior. This prevents constantly promoting mTHPs to the next available
> > size, which would occur because a collapse introduces more non-zero pages
> > that would satisfy the promotion condition on subsequent scans.
> >
> > Patch 1-2:   Generalize hugepage_vma_revalidate and alloc_charge_folio
> >              for arbitrary orders.
> > Patch 3:     Rework max_ptes_* handling into helper functions
> > Patch 4:     Generalize __collapse_huge_page_* for mTHP support
> > Patch 5:     Require collapse_huge_page to enter/exit with the lock dropped
> > Patch 6:     Generalize collapse_huge_page for mTHP collapse
> > Patch 7:     Skip collapsing mTHP to smaller orders
> > Patch 8-9:   Add per-order mTHP statistics and tracepoints
> > Patch 10:    Introduce collapse_possible_orders helper functions
> > Patch 11-13: Introduce bitmap and mTHP collapse support, fully enabled
> > Patch 14:    Documentation
> >
>
> Went through it and didn't find any blockers. Let's wait for Lorenzo's assessment.
>
> If he also doesn't find anything major, I think we can move forward with merging
> it and handle smaller things as follow-ups.

All LGTM :)

Unless sashiko tells us about something utterly broken (trivial things meh,
existing things meh), or we see some massive breakage in testing, I
think... *drum roll*

We're good to take this this cycle :)

Thanks Nico for your patience during this process and obviously David and Lance
and all the other reviews for taking part.

We got there in the end :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

