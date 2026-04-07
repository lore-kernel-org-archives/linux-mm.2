Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF81EDB7CC
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 08:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E1B6B0088; Tue,  7 Apr 2026 04:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F266B0089; Tue,  7 Apr 2026 04:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83DCD6B008A; Tue,  7 Apr 2026 04:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72F116B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:38:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DAE9C1901
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:38:38 +0000 (UTC)
X-FDA: 84631108716.22.40648B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 467BB20003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:38:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Av5Oge3U;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775551116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIqAwjU4p9/Fjo55FqfesuPnIvzREogR4DdDD++Ha3Y=;
	b=IxtgolM3jLWYtelq9dj/MdOkxMoVZpLyGjtf4Jx2aSWjfhEvRF3dOlRtSR/MlnLQ0PXnWE
	Fv3h7lQMgC4GHjtaN/cd2Z/5pmJWKMXuAHXxezxEg/WQwC6mC3RZtSszri/5CVYovX0RBs
	ED3vBUtFuANuEgc4XtAuLKNc6SFGVFg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Av5Oge3U;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775551116; a=rsa-sha256;
	cv=none;
	b=H7eIRIcVM16VRzBK6oTUANFNZ3/4ubVVyiPm6IjCPy3UKVucQv95noSbMYMu7gpxus5XSz
	iPiWN/d++GsxrPHHxAEHqGnDM1kNMA6bpfjEe/4WYJKES+RqhxvsDjP0jHXSe2tiNPHTZm
	KqO8AyOc9H+DY7Rhd8pwETD5WYRrqFE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB83E40D63;
	Tue,  7 Apr 2026 08:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F10C116C6;
	Tue,  7 Apr 2026 08:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775551114;
	bh=TIqAwjU4p9/Fjo55FqfesuPnIvzREogR4DdDD++Ha3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Av5Oge3UETJyIIcmTYUA487LmfI8kVI0LKPw0cYKj0WbFsIMzwU/k60JYoWrm8sh0
	 OoCHkEGhENBpeL6GE6d9W8sDK8B6aod5DOorbOMVJ1Av8WGTQow2O7ISuDz3VDU1Ui
	 8jsmDjmHDI3OXTB+GtaBw0qAx2WRAEsWyItTCTHz5lrMVS8eCFOk2Q8oEnct0tCSxU
	 xvMeYXZdBDxJCQVCLa2J1GzDkgpbwt1NJc5OWmjCMuk/O8JaKQd5Kp4SIAAGsSI5Tn
	 WBkt4O5m6zVKEU+lPukCg57Li9SHgz9x1YFAaldShbWLA52ShhGqovp1d5kUemMCBq
	 ED3+0AKuPUCAQ==
Date: Tue, 7 Apr 2026 09:38:19 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nico Pache <npache@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-ID: <adTCJ8NQHGNMqR1d@lucifer>
References: <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
 <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
 <37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
 <9d5a4703-a15e-4be6-926b-af2d98db40c0@kernel.org>
 <CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com>
 <87b83f7b-f0b1-4184-93a0-3b4b574c813b@lucifer.local>
 <20260401133145.90b094a7b87bdceb0013b5af@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401133145.90b094a7b87bdceb0013b5af@linux-foundation.org>
X-Rspamd-Queue-Id: 467BB20003
X-Stat-Signature: u6sotirmu4bmw4icffdxtcia4dnxjj4k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775551116-856035
X-HE-Meta: U2FsdGVkX19EKxg2kno2UCZ2hFpj2M2wpvwv+AozCRxnO0eAA8J6dmkCbW/TH5VCibUSFE7hwEb5vUASd6LkSlsKnkUs4ItmgCbUcZYn/ES1asv2ADsp7YdoZHCw5daXw9c8v2nqt0uwUx40WFBNP9MxlILorTVamV/HZPd5lRTHi5FAoTn5JhW8RQeumbUljC3IjAmOBewvSul3ZojOAFpSu9PAO1CpHXC2O6X9oB2I0WZ7PTzXdlrx1Fp1BxAxSDDX2QGwrBrwXnNInq0sumFJxDwU8VPdX/ZI1Za2szU9lzdo3KMDZJE42fdfw1kfy/S+WgzuZOJpH/RdVlw8otYQcDW8T0JwUI03triLlDI2ggM0JO5roW+r67vG+TvAKLSnM9+xW2v4OWQnKlu+Mws4rkz7qz0m8h6HnJGi9bhibKuaXfWBkTM70d0u5elfEa+/2CUtP1fHJjvxPTCZIDEdaXXzhhuDJxV2IeAy05r9ZdG/TQLkE07ib75tptKD5L77w36rGipReuPCRJk/bHx+rvKGKUR9O4mgLjoTvH+5EoXMIvvE5eDNakrUxefERssXB6noJzO0fp7euhNr3crqJpH2XOqnv9WzwUKsTeINKtZCJCwy4XqtFTfZXHFuzq0Epjp9TLr33cjbJ+9J1fEbSISS6LNtKdqZ0iy8qAr/Oqx3W+Unt+cqpMwFDxuUH8m7jwOBzK2OOOS+09eW/mnf2nkQnGPTfsTtcWX1phAPUFXm04odaBOKssJmmCtMpb1znX3A0IJnjKU/tIhuooXu4Z+gn6HiLLqUSg3Dal0vu9URmn29a7cGRsQbZnznmLKBjUG+seTzp/Hhs0OH0GtEjbN9l+kFUJkXUiRk23ecZcc3HKRmbnHXWLZh07xTVDZIUkiq8j0yNqyE68tAuyWfEKPAD+En+5QT6VZY3EaZHKEhyQBkXCuj2HTx4hI9TFxpV6eVsDdt7AZQuib
 ilTDMkew
 G8lH/QNa32RnzIxClg7wV7HqIWvSaO7U2Dal6o+B/1Bs1sXF3wwzUqFvNHJtvIuVtAl932BT6NmTbZfikD4POlhOsA1rZr7nWD6q8USiKyF9Llq0u/otqbraUd4HnuaC2UKhCV2imYBeMqhQkZRrlvc9P/H8QzEh02u1nCMz2VPho3yzmf1YXxn7+uHg45KwI47W3TKDGuswS78FI85B1gsjqQhfC9bJCAZPo/xLzic9qhmeoKDqC4cIiFrzt7FB62/1tlvZgt+WuOGUOVPwa71FLvKucxt7rnefgSm/e3+0omIsoH7fusWVuTwJiKhfnmjGSoZOj3bFIS7KLgD5YMrpSOeJf/Tr3ddCND4lRtcy2q/WCp5qHCL1xm2zOhciQdBk+6cZMuM2afNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 01:31:45PM -0700, Andrew Morton wrote:
> On Wed, 1 Apr 2026 09:14:35 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > Date: Tue, 31 Mar 2026 13:11:18 +0100
> > Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> >
> > We are incorrectly treating lock_dropped to track both whether the lock is
> > currently held and whether or not the lock was ever dropped.
> >
> > Update this change to account for this.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Not sure if I should add this?
>
> Should it have
>
> Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse
> with collapse_single_pmd()")?

(Sorry only just noticed this)

I mean we do need this patch, if you plan to do this as a fix follow up then
should have a fixed tag, but I do worry about bisection hazard by leaving this
as-is.

We definitely either need this patch folded in or as a fix that gets sent
alongside the change.

Thanks, Lorenzo

