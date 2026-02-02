Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8295FE7315D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 12:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4BE6B00A0; Mon,  2 Feb 2026 07:50:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D520A6B00A6; Mon,  2 Feb 2026 07:50:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33A96B00AD; Mon,  2 Feb 2026 07:50:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B29C26B00A0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:50:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D5591BD18
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:50:46 +0000 (UTC)
X-FDA: 84399500892.02.9DB896A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 83EA1A0009
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:50:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=B0Wen35h;
	spf=none (imf25.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770036644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49YW4SEmeqfmsCTg6PnrOrf26Ub+dtDy1bNpRRDJ8LI=;
	b=EQSXE73lDXAG8gzSMeD7pjApr2AS5rrYAkftc/IHL1IkbRHJhHW0mYl4/HEckUZFdANwv+
	HZ26bBVfFTAoG84eMMImYtd9T26hddYLhflM93BIeW+ofq095AI7K++KqAbHmBocfST33h
	70r/t0MDvL3lmKtd13BttEo7J9ZdKW8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=B0Wen35h;
	spf=none (imf25.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770036644; a=rsa-sha256;
	cv=none;
	b=N6FbXqtry22xoDjg/JRHrUKsnMj4SV1ZlOig10gRjOSyDr7TnSy/dKtNYziayFwHZ8GGXd
	QIwhoiQ08goNasBqe414DWZ+adCUoWAt0UYtZ5XnfbTEm4jDalab6ZYbQoK+ENBaSWkHFL
	uFDzORIbAazP/3xBJZRNrL3cXWlPFuk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=49YW4SEmeqfmsCTg6PnrOrf26Ub+dtDy1bNpRRDJ8LI=; b=B0Wen35hmxwwSLZeLWd4c5nyBO
	QO6xYjhwA6gvmJLUCOQdqub19x/sF1d3H5kKuVI7PvmRhOtrJvNkudJ+jWUitdl/T3Ma9XjkKogBH
	+Tf+OnMbnKv3cWrvqGB7FHNiU3Waz5nzMzcL8o3c2MEn/9KNfgb0YsNybHfJUTGKaCRLZdFqNkhlw
	Zx3FQBG6Bt/i+znJEqwdmBH2Tej71AIZjPlvCY9DcJhxSu91JioT1qPIBPxDtH1KqyOfmC2ss7kyH
	x/7QfdE0ioHIQT4LP2rvaFfSlo9YPrVTUpYhcMq4mnkxf84mjFUS5pTz7T9bPjVs1ZzcjcFj3duBO
	nNPoaGsg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmtNv-0000000GVCQ-1VFp;
	Mon, 02 Feb 2026 12:50:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E633D3008E2; Mon, 02 Feb 2026 13:50:30 +0100 (CET)
Date: Mon, 2 Feb 2026 13:50:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com,
	bp@alien8.de, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@kernel.org, dev.jain@arm.com, hpa@zytor.com, hughd@google.com,
	ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
	kvm@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
	npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
	ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
	tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
	x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Message-ID: <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260202110329.74397-1-lance.yang@linux.dev>
X-Stat-Signature: seiphqcquz3xy9j1w6obgfh6omfkqnim
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83EA1A0009
X-HE-Tag: 1770036643-119015
X-HE-Meta: U2FsdGVkX1/ehALMwuVhoKW5bnQKHSXZW301z0DAWM/kEwGKynBCEO9GQXPtwfh97XLgiyTStembUzIZ7XcbqK5gwOLfNFgkkUkKlV0CNI23Au6uNAc//yXmta+GL8UDn89db32rerron8ewITmetj2iUc7uxGmeIaqgE0HJoQJ2bVBB6WoGzzTyHqHYkIyeeACxZK6N56MDiGj6sENf9IQpXu+iJi4up8dNISoElXe6XretU7E7J2sHx+1nu6XdTceb42xSFVOvLt4pc0wEDqLDIBYhyT5Mhpvp4W5k530ecvYWQx6XJeQn8xzXQdihMGfoIAYhhh7+fNP/JeWpXmqDyhth7pJcJbNRlqlSnF0Mcr1G8i9eal63cXIBlbBOFXAGxAnKGvItjfuvO5wPwlpsWCv+5v2Os3oA0BCXLkD+aA2/6kLxwTQpFZx5yUdESgt9rugi3x5YZkD+RBKauAROqwQ0+ijVF559+qBUFFeNXsGVOeVdXXnt1msoZrnhw/miRNFlPITJBbGQzfq8dkhSwi05fyJPs211W8H4iXco2/4Fxi6Kg86X5zy7Hpa8UlUjBWB5HZHCnGNotEd3EGCB/ZQ3kOMDEyCXhRIfvck2xcEuIABoJlGLxFtPM1lUMfY3IJj8Kahro03ILkOUr5nOfVdH6PnRz0c1Zm7kpaIlOzbX7A8+jPO86cMH+xu+L773E7Jl+YsLcyiGR1oAPNzFChkQ5EStP/MT0LOvGdOMFufJLAXK/Nt23OSY190uF1+PRnlQdkLQ3/y0RgvGOeMHEWpfZfZR/ZxgejmvWnuhboP6sEkbT6eJ8z430KnEsG3Eiud3rr0ZpwaYhgNOGHqXFAc+eNGGyDNKTiUO9bwhGb7hZ6/hNgmQ1+pvALlsRdcs/Tl/BtunX50CIIQ9bVWCseX9c/f1gU/F6aIKD9SEI9Zv4jAK4zkiPFmOO4YCs7D+Jl2hnxrBEc4j2MT
 uh/vm6hK
 sN40QyQvo8t+y/2KJgy7SPEC+tc0BCgZA+htFBF0RDFmXKuWBX9025uJDsU39Dz8Gg0Wd8gGtuWVftniHxx/4aybGgWB+npPOZ0UK90XgyzB/plZvbFCTrXrY6XowHmFyRzQTJ/xRdd4C4AWOBXeoWbjLNwSMLoO1iyCT9dqGGOKnh+2xgfl+zlZZkqxZWAj1MNfcbLU8WJgd7bvVZdp6WNhPCfVYnY8FdXnTsM/hQIWsgm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 07:00:16PM +0800, Lance Yang wrote:
> 
> On Mon, 2 Feb 2026 10:54:14 +0100, Peter Zijlstra wrote:
> > On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
> > > When freeing or unsharing page tables we send an IPI to synchronize with
> > > concurrent lockless page table walkers (e.g. GUP-fast). Today we broadcast
> > > that IPI to all CPUs, which is costly on large machines and hurts RT
> > > workloads[1].
> > > 
> > > This series makes those IPIs targeted. We track which CPUs are currently
> > > doing a lockless page table walk for a given mm (per-CPU
> > > active_lockless_pt_walk_mm). When we need to sync, we only IPI those CPUs.
> > > GUP-fast and perf_get_page_size() set/clear the tracker around their walk;
> > > tlb_remove_table_sync_mm() uses it and replaces the previous broadcast in
> > > the free/unshare paths.
> > 
> > I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
> > __tlb_remove_table_one() actually uses RCU.
> > 
> > So why are you making things more expensive for no reason?
> 
> You're right that when CONFIG_PT_RECLAIM is set, __tlb_remove_table_one()
> uses call_rcu() and we never call any sync there — this series doesn't
> touch that path.
> 
> In the !PT_RECLAIM table-free path (same __tlb_remove_table_one() branch
> that calls tlb_remove_table_sync_mm(tlb->mm) before __tlb_remove_table),
> we're not adding any new sync; we're replacing the existing broadcast IPI
> (tlb_remove_table_sync_one()) with targeted IPIs (tlb_remove_table_sync_mm()).

Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
unconditionally and not add overhead?

