Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EE8E73151
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 09:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0086B0088; Mon,  2 Feb 2026 04:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D3B6B0089; Mon,  2 Feb 2026 04:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789516B008A; Mon,  2 Feb 2026 04:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 64AD26B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:54:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11490BCBA7
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:54:29 +0000 (UTC)
X-FDA: 84399056658.07.4016973
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 678DAA000B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:54:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ByWUxsUO;
	spf=none (imf25.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770026067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Pu0UsVCQG9vrf6r9L2k7y8BIrpfSaWQDN3W3VbUraQ=;
	b=3UnRTv8FrTjN9UoQQi3dStSAuwO/Zjas5q/7Y/AazuU8CqM2J16npcPX4YZ/YmFpQlt+Li
	1gkQuY1z2iHxgBLSTP3MLAhiOScT7QhhQcR+zaVK0iZrpNfl3T57RM68Gat4yF6bkvcgbe
	3ccu91XIQ2lqyUjvDJgDcta2F3iuiMs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ByWUxsUO;
	spf=none (imf25.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770026067; a=rsa-sha256;
	cv=none;
	b=UTuZo9HNcRkk0GHeWrmrumvt9W+SH0e/gSJxcwV6qFnLdbjX3ZhvzXUXg+f/1m5mP1yiVr
	31guADjnGEJbGqja5cNyE+NPn4xc6JbxpsAy09yOIpiJV0VLHkbsZD0k7tbPNCxB0oBYDl
	W0+T0Tglom8iiaQnf2dieTDN2j65T2k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+Pu0UsVCQG9vrf6r9L2k7y8BIrpfSaWQDN3W3VbUraQ=; b=ByWUxsUOcWxLMhnki3SEF9i7Qs
	1Ryp6PQfjEpUpjKlHGRbJdhwYJQ1FlbPczZF407bYKoaimf7VMzfJFOUdToV1R3510WBOYyhEhply
	sd4lBMP1V/EtAksGDPpBiBBxW2QMugzzCYO1KvCmt+tBzJ6kRJtJ33LkxFu6pZDJyVwhnYyXwDix0
	NljZJH3Ooooo1ciud410bnqC7x/V46U+m3cLexl4MdeHw5fWM/P0gc9bQvNCh+8r/KnoURwWIowPf
	W6DfQsbStxwg74gKRTmICCEYiB9rwcx9ZlBKnJNXqnMgb8PBPxBDpoKR47hqlm4FH9havUqjOXLJ+
	h2KvJ5Pw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmqdL-0000000GJ5I-0aps;
	Mon, 02 Feb 2026 09:54:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 98BFF303031; Mon, 02 Feb 2026 10:54:14 +0100 (CET)
Date: Mon, 2 Feb 2026 10:54:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, jgross@suse.com,
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
 walkers
Message-ID: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
References: <20260202074557.16544-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202074557.16544-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 678DAA000B
X-Stat-Signature: pty3cdysczqubx3i9mhsqzrh3ya4c9iq
X-Rspam-User: 
X-HE-Tag: 1770026067-689593
X-HE-Meta: U2FsdGVkX19Xh8fVzbj6DUIcVXkr6TXcsJW04rMSKgnIhkPV3XWYxR6Es8pbruDtCECiiebSk2mnH3TONLofov1eR0kPBAbluwOIJgei1TgRHkq6N0B2ZyfEEhL/SEtN77S5/EG2munfy/ridr7N1CEES+Yz5TOGk2hNjxE6YNbjozYp+k6XPWODAhoW57qSLjlhMZw4LAdRSM7sGeVdXyVCJmgbmcKmrtFSeXr/Y8rvg2DcGFfgTu5oT8xxrUgxbkuPMbOfEsgTW+I+j9SGkwZuuFDemRMCnhlSKz7Cj2nz7E/FEzlLjFwSPGbsestc55eH3PtaEg7qyKfeUcFs3n6m2x+kcEGbYCMHIWFxsxJ0EKFJUtWvj3g3SJsoHntgK0lNqYZ9r9Z+JdcXr7AGzwMSszypbx1DcfvsP3oZbvVuJNrQAh+h4HMANxcAopepYTCGdnchi90r/3gaBnLFcsJGfmtQgVqucnx+GDEeWFGUnQMZBEpaoyaNuaBjqxBpS3tDsOqnlc/KvRlyvayF/7QeF8WQcIhzmh5gqi3QTll91kVmROGIUflxVwvSifLqZy1QJjiDu3BWAxKaaFtYS1w62b4l/Ve61G7VnnejFeEhGAhaWd3sYsMVOX7wJPhoVv5M9SHrw+7H9zTvYuebj9unyp8DMQDRCm3bNqUjNqEnPo+NN3KYevbFoRZ30ZgR+UsNBjhAbaG7QDZVsZoUBCwl77beDBK4U0+rB4rOSVxN78Y/J1ItTpqI8ikZVa066i+nRtvh7BFqIxVeS91kagObtK2i6F3Fl0U/jvSPG1Y4ehOXyY4cJU2KxY1JjrUtJ/x4oncrlZsP629p1rpCjh9c5dJ+gwU8yRJ+fJklNY54tCRNhOWJ5RfWB0XOmZuIrqzxv7YEviYC7P5VbFkV+cMQBcOSLlQgsprJ2iU1QEB5u3d/B0/6ZI8nhSDyL+DiJ5o9PU1Ckm7n8aodGVk
 tkzvk9b5
 9p2wB2damcZ2RBernPMyS1UhuJC5/yUvkqLPw+JI6WSd9KZOLT4fzjoS2EMmDtNgdWvHad4daVxMgiPMjp+mtqZNeGZNUkRWVMNLSa9d8R8mjEdPQJqqGoVW6C/1n/3/t5FCQ8M3rVWGGxiI3nwOjtXzYvlEVVs0uvuswHvqyiiYNaINClbx1nFRbiaB74V1TUawh/TYa0K+NXeHc/3e+VL2o7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
> When freeing or unsharing page tables we send an IPI to synchronize with
> concurrent lockless page table walkers (e.g. GUP-fast). Today we broadcast
> that IPI to all CPUs, which is costly on large machines and hurts RT
> workloads[1].
> 
> This series makes those IPIs targeted. We track which CPUs are currently
> doing a lockless page table walk for a given mm (per-CPU
> active_lockless_pt_walk_mm). When we need to sync, we only IPI those CPUs.
> GUP-fast and perf_get_page_size() set/clear the tracker around their walk;
> tlb_remove_table_sync_mm() uses it and replaces the previous broadcast in
> the free/unshare paths.

I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
__tlb_remove_table_one() actually uses RCU.

So why are you making things more expensive for no reason?

