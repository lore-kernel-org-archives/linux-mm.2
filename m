Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 141A4CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DE06B008C; Tue, 13 Oct 2026 06:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE506B0095; Tue, 13 Oct 2026 06:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DA16B008C; Tue, 13 Oct 2026 06:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D46EA6B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:07:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56CF612041A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:07:13 +0000 (UTC)
X-FDA: 85317175146.23.187F978
Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E9414000C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:07:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JbHWWL4b;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791886031;
	b=7kCQPSzIph9odybB4IOVh1MVfXn7Ueb9fIi3ErsWOYuGp0e3O9MVXZ4QLbXF8OvnN4mG9l
	WW0kq5IxEEbyFVlTlRGC+iQDggyIFz+mxX4o33xvNUdGzCCceoJ3UD6QOgrLysWTZtZ/9B
	maViYkldQVZqJZOwAf7MvyhoFjS6h2M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JbHWWL4b;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791886031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kbbcsq4gjfhjCcmUx6vDab+WkFJEw2PfLoeMu2drfZo=;
	b=ZSokX6lGsCIpkiwnemi5YuMcnlWu/P/kInPtEkBDAMLEaESwICTKMEC2VEC+c86213wuSY
	+4E0RnScdilycXh8sL7GDwg8KlucKoWFjNDUZw1/SmgToOqRARHOSjMsszMRyHENe8Ky1j
	wl5kvN88BlOpLfJ/X98bKXUyc4CpREU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=19GLy3aq4B6Z6bUMOpryhrMAzIgxJ66Kmju5Caaif9s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791886028; v=1; x=1792490828;
 b=JbHWWL4bkVmD+IVquRhgSsCk5oHEZk3IOOiQitNJq6CEoEaI+nvbou+NxfP861+c3fismtS0
 /xOeg2yF3UMtLc8cpjaeneuguC/a9+zLpiL0A9sqWPHSaLQVbjWjU9V0R8htRbCR6w1MTMSiD57
 ptBQGIy4yeRW56QPplt+GpzU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9e66ce19328045b4;
	Tue, 13 Oct 2026 10:07:08 +0000
X-Mizu-Trace-ID: 9e66ce19328045b4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 0/3] memblock: Remove unused exact nid allocation API
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <179188501773.4183299.8247277870365097333.b4-ty@b4>
Date: Tue, 13 Oct 2026 18:06:49 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Kaitao Cheng <kaitao.cheng@linux.dev>,
 Priyanshu Kumar <priyanshukumarpu@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <35057B7F-9E89-447B-AF4F-92A78B45F8E2@linux.dev>
References: <20260919135327.74089-1-kaitao.cheng@linux.dev>
 <179188501773.4183299.8247277870365097333.b4-ty@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E9414000C
X-Rspam-User: 
X-Stat-Signature: sngwyxep933fxnabd5wzufoz55uxyciy
X-HE-Tag: 1791886030-715170
X-HE-Meta: U2FsdGVkX19YUv93Uh0kQQNZks5ID0pDlrUc3SJJJwcCnA8/iJecp4Bzs+HNi4+OOlZg7ZC9k9QTHS1ePbWvaAfRkmDwyL0CJnj22eRwsvOzQwgcYg42fQTdjaT4sekvoe8DsnQNk4O6VOJmhGHG5MgHB14fPsiEojFx9Tt/5cZ4Nhhk/UJg7KTvstXsZWcFkAURNsUzLw2ulsdotsxiKiWkwvBB1kTdCD/0V0XyRZeStyWrn2+cY89UOI+PUiizYwnQdfEe9LGN34oZtvjFOlWQ+1BejBaPIivHySbeWpRrLrz9ePyNaZmU2OYCFbOBHtnTdAEfAOAhWrlv5M0RzLAH5QfDssEp8R4IP/OUNkwdR6mVd/5qBV0uXYU29maTDWAY06SEJoN5W7tsZYTf39Uj9Hgrk+wutFPPH/KSbhcLtVTyPOxYzli2MWnV6803fHcDX7qozy81JsFR5O+Dp6UVQvMgY+bbg4uSjAzFO01RKfAUqaewRyLzKZ3VvheKu5nWgDFGWJEZvh8Pdg8Ju6EBBIrnfVSFgElcPF8ChwNgumwApB0XUJlnoFwwYkbyi0Gx7Ef6sDf8Tt+SCLLkfn7gHLiw8sQOTHYMsSQYbE5pNVYuPncXHDs9m27w52g9cswyrjRcmp7406WPZagH9VI7MDfXuhbsQSVM6BkkJcyXP5YsMcPnAZpKgjhuoepMr3MyuzK32+QkFQ2DRceHyUVz8w5XaOQ39umttIeTh6TOymtKkrsAM1YmOO0ZnKVcxGTYqVzZdgGppSa5yrL724kkhd0wvN7dA1PjWOd4kvnbMb19OR/HCLiOP2bMQeKvx/aumy4Ht5PLfo1S4t388bgroIZhNU3qG09NwdPuBvrITDSo3LUz8anTZxwfoA2BvwBZbAAa5bGVRfQ96xCNj1u1mnhDQ2CXK9jOw4apRBuLJ16mNCR6N+khkHsrj8S9b2YZXLevsbbcX2UJRiF
 SJSLFwxk
 IP6aWjEwW/znJMDZ6zF/+pL4YRTUYhlmuSgPxxMdV9HNY2zBVp1nZ/akK9j3IHwQoWkH1YxQci0q+LyEfEcLNGzp6a58vuaqdBj9UZJnhSQZobti1HjQb15xr+smYRw4eV1OCFikavVE+J8tL8WOu/DWGc82XulH7WcJOYK+5G8rkKAsFTuhWx2lfu+cO3fJuaHV2bBulTTrnUK7hp3hny19bL4Sw20GowSYAIWs/OrRPAYHs58dACh0MfeOsmHxptLO0bFzYNXfo2bBm1AWOuOE31CEw8BTglJd8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 13, 2026, at 17:50, Mike Rapoport <rppt@kernel.org> wrote:
> 
> On Sat, 19 Sep 2026 21:53:24 +0800, Kaitao Cheng wrote:
>> memblock: Remove unused exact nid allocation API
>> 
>> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
>> mechanism") removed the only memmap_alloc() caller that requested an
>> allocation from an exact NUMA node. All remaining callers allow fallback
>> to other nodes, leaving the exact_nid argument unused.
>> 
>> [...]
> 
> Applied to for-next branch of memblock.git tree, thanks!
> 
> [1/3] mm: Remove unused exact_nid parameter from memmap_alloc()
>      commit: 063b5e8bbd216c27e885f45e29e23d053aa565fc
> [2/3] memblock tests: Move exact nid tests to memblock_alloc_range_nid()
>      commit: fba3e86fb848f79c4573243affcd7d79d378958d
> [3/3] memblock: Remove unused memblock_alloc_exact_nid_raw()
>      commit: ea27be9f7ce90a05e779d20b60969ce2a9834f77
> 
> tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
> branch: for-next

Hi Mike,

Just a heads-up, the tree has moved to:

	https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock

Might want to update it next time.

Cheers,
Muchun

> 
> --
> Sincerely yours,
> Mike.
> 
> 


