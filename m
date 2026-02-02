Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B5AE73159
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEAF66B008A; Mon,  2 Feb 2026 06:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98326B008C; Mon,  2 Feb 2026 06:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA40F6B0096; Mon,  2 Feb 2026 06:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA9496B008A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:04:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85E55BCB40
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:04:28 +0000 (UTC)
X-FDA: 84399233016.10.79BC0E6
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id AEA2380006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:04:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcHreQ2z;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770030267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZEap9olFo7mT2sNYk1w5rpD3JOe/VQuaiSKjgwHkTY=;
	b=IaKS2DalR+IXZzZ23HNxHGkA7hB/xq879icm7578eX0KHaht/a0kj9aNkm/sR35qFbHp9z
	cXo9I+9xKwV97o6K/8uf4IxVja2zzlF5AvN+bSgYnBMpGJs8TwP3zbSa5RSiUrHAdT50aZ
	XO+8kBvdqOpc0FC04Y8ZNCxmGV3PiI0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcHreQ2z;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770030267; a=rsa-sha256;
	cv=none;
	b=zURBDKPR+nOW09pGD7GQc5NMKAMYng66g2NFSU4LmOH0wfWJ7PIE8dma4e14ZULQK72cTy
	UtugXzeeA9OGnrP9qPnYJhXxD6Ztdd6vyjy6X84oIhTnsS28nQzhD3AbfOQllqAhkwPySO
	fyQH8BtSowV/CkQ8B8lI3H/uG3XNets=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770030262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZEap9olFo7mT2sNYk1w5rpD3JOe/VQuaiSKjgwHkTY=;
	b=VcHreQ2zTk7FVhSAZ6GgUVFwokNTeD4Qx5X8cU/BISIGZVGpdy7EuBWbXiewHlZJITBq1v
	h/0NPTey/RmvLR2J0f+PVlOVl0tKua0+75bhoCb7KXd8iwLBkGedJYaf/5skYt6MUHgfFl
	4MeXi+ZucQEe1Qgwzqawa5cry7k29lc=
From: Lance Yang <lance.yang@linux.dev>
To: peterz@infradead.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	arnd@arndb.de,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	boris.ostrovsky@oracle.com,
	bp@alien8.de,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	hpa@zytor.com,
	hughd@google.com,
	ioworker0@gmail.com,
	jannh@google.com,
	jgross@suse.com,
	kvm@vger.kernel.org,
	lance.yang@linux.dev,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	npache@redhat.com,
	npiggin@gmail.com,
	pbonzini@redhat.com,
	riel@surriel.com,
	ryan.roberts@arm.com,
	seanjc@google.com,
	shy828301@gmail.com,
	tglx@linutronix.de,
	virtualization@lists.linux.dev,
	will@kernel.org,
	x86@kernel.org,
	ypodemsk@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Date: Mon,  2 Feb 2026 19:00:16 +0800
Message-ID: <20260202110329.74397-1-lance.yang@linux.dev>
In-Reply-To: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AEA2380006
X-Stat-Signature: ag1xnpxb5613hardo6zk6655i3yqe7j1
X-Rspam-User: 
X-HE-Tag: 1770030266-238930
X-HE-Meta: U2FsdGVkX1980Rnsj4WOWk4CqCNNxZaVaq6YGbb6X8h0W1GWtOqFMVCFHQlYktp3gTVcC8r0d3cZldTdBdtYOjFVo3DjaOzwGYm8hOp6SCHu0b4lDJfFJjBJ8GDv761fA5ETHpisSaPd/MrbL9NA5tGX29nkyoy8j+Iptt+49y6YZTTckpy99bZC80fED4VdelzLZnbG0OUjSd/870PrmBziMrNEWfi5PS3dmEaMaoYrtU/lcBLEVdn9v9I8T8QIYK55+l1dW5sQG08VBWW7FdeE4pkdoRJYTArXsCthDo6taNSfTRNK+TQxNcatL0zjEn8tzqxjC8g6Sl/Sg15m82BRjckAM6LFYkGk4KoztxB/csbvetOTeB47KbzYf/tiJzImiNUTseksjOUmZ68shK2QstN/YtX7C4CE6NoXVf87Dt6li2MfYL8Xg18lbrOU17a+SnCE8Wj/KXLXvVNItOO1otuoBGYk3VRw8PTbH+mYjKJa7fd7cKiEfD7vAqfQV7LC28QuFlFgntPmxccjV3w7x4kaGlv5Yb8hIsBYmJXuYnddGxEE6bJUgZQCS5j2Ocx97ww7dOlKWvRPNHE4fGy+llkrwBzcoMongXGAANQl6YzSDa1xWhFiQI/g/e+7pTNFtq1aMyOelA3ZELyetpZb+OTLrRd5fqRmqAI9g8UqMc31h0ak+2m5yf4dVM29Ikx22/2ham8XYZhBKX/h6JxrbgkD/X7ytA7q0uYWQCgNtLTjOgnYjfxH1W+GwE+/CxcwyHuFOjOMBP6beVC+e0cQxSAzfGSYb/HnmpE72hiXiuBJk0t86CEVUv0i+tOCNBMKwCreEdjPiYFNc6uy/yhs43nJK5BjJWI+ev7RfG859CF4L7Va0OZu0KXyGMnRz1W9KOvABng7cz5rzMXS/dkejNtNoSkORK930aPO8lbO//i9vx6QLp1brDm7lX1W+NWT1T0HV78v2UVl719
 JshJP4EJ
 3rbBxAe1MNAE1QxEwO73wREseNM6XaDOxseyWaujCh1gDL17d8+qaB3O5wcuUnv3W7Vrqfqx9XBs6PCAsEr/QbZsmMOSGlK5HclG3ZpITQtptbJVM6wUtLB8RClhttds11WE+EpLszRryWYk/xja0AnNo41sGpt1V5J0I4cagy8IvnQMOVxuuII5VZoCUiX4scV2XYoxzZCZCakU4HUjC65r598YzQeEEt3cjqI+IaAw2bhA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 2 Feb 2026 10:54:14 +0100, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
> > When freeing or unsharing page tables we send an IPI to synchronize with
> > concurrent lockless page table walkers (e.g. GUP-fast). Today we broadcast
> > that IPI to all CPUs, which is costly on large machines and hurts RT
> > workloads[1].
> > 
> > This series makes those IPIs targeted. We track which CPUs are currently
> > doing a lockless page table walk for a given mm (per-CPU
> > active_lockless_pt_walk_mm). When we need to sync, we only IPI those CPUs.
> > GUP-fast and perf_get_page_size() set/clear the tracker around their walk;
> > tlb_remove_table_sync_mm() uses it and replaces the previous broadcast in
> > the free/unshare paths.
> 
> I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
> __tlb_remove_table_one() actually uses RCU.
> 
> So why are you making things more expensive for no reason?

You're right that when CONFIG_PT_RECLAIM is set, __tlb_remove_table_one()
uses call_rcu() and we never call any sync there — this series doesn't
touch that path.

In the !PT_RECLAIM table-free path (same __tlb_remove_table_one() branch
that calls tlb_remove_table_sync_mm(tlb->mm) before __tlb_remove_table),
we're not adding any new sync; we're replacing the existing broadcast IPI
(tlb_remove_table_sync_one()) with targeted IPIs (tlb_remove_table_sync_mm()).

One thing I just realized: when CONFIG_MMU_GATHER_RCU_TABLE_FREE is not
set, the sync path isn't used at all (tlb_remove_table_sync_one() and
friends aren't even compiled), so we don't need the tracker in that config.

Thanks for raising this!
Lance

