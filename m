Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8159FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BEBE6B0088; Tue, 28 Apr 2026 07:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1966A6B008A; Tue, 28 Apr 2026 07:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC8F6B008C; Tue, 28 Apr 2026 07:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEAD86B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:47:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93E0E1C0873
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:47:32 +0000 (UTC)
X-FDA: 84707789544.24.38D6D70
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5F74A000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:47:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZTGzB46i;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777376850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0f8rP5heUGC6F5VBSMw14CaIOiuQPXY1Shr8xqxlZsQ=;
	b=EVMCAKH3Hz4U+h3yptEXTTWH+2xKZ23IwpsEAmP+tR3FI8upG2rZfgGaIZx4deEsLnfvJ0
	dkv7S0UJLyszbrWwh5s/l1vVCzxqNKkjKKofxrjYoEe7g1Jtwk9jxYn+dqoyFCAE4APMan
	7yyDdiRqlrbqmEwGaO14hamC2At+8Ew=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZTGzB46i;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777376850; a=rsa-sha256;
	cv=none;
	b=cGV+FsTwxwRVmTDXPdx73SzGcSTMZ+vDz8VR9gYRqjNDsPNRVEw134tPtDDGu/cvhCw8yL
	LUWf0cYvC5FT+o0VWSGePHeWsVrT5QNuP/pWLBjIdpjEPmgXG2y6CGYGNve6C+a8IdcdyU
	9ot5x7kVx/0Y445uwASBGCzonHnw1O0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0f8rP5heUGC6F5VBSMw14CaIOiuQPXY1Shr8xqxlZsQ=; b=ZTGzB46iDeFbTICbvy8X9RkG3T
	uB3IP4Z460bv8unTcbc31PEGV3Kuk/3zS968MHI2qRl8Mb3l813eQWcsdhit+GoNPgUZwdmxGi52Z
	7KN79N+z4q+Loi4t8BH7VHAx7+grjRAQb/9dvjcEh6rQRHTnVq5rIgENHTcz3M+QoRCCczdTG/4Qj
	O4ixjrixiwi+e/RnfiLEcYetjD8Cc90BDD2tbneqoCptAwReNzZvD/vowm5L2W9ZHa0EELPxrLw1g
	MZSHkShrXCV3NviizhTS4/x8pfZ09TFXvunxYItRLGacVL1v5ycNrOC7qOXdznLXUv50JDLoX+Jop
	7sl1uPkQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHguQ-00000003jtX-18pJ;
	Tue, 28 Apr 2026 11:47:22 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CE1E0301CEB; Tue, 28 Apr 2026 13:47:21 +0200 (CEST)
Date: Tue, 28 Apr 2026 13:47:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: dan.j.williams@intel.com, Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <20260428114721.GV3102624@noisy.programming.kicks-ass.net>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
 <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
 <20260309164516.GE606826@noisy.programming.kicks-ass.net>
 <afCS4d4YccQFtvpi@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afCS4d4YccQFtvpi@shell.ilvokhin.com>
X-Stat-Signature: i4fzrw4wpfdaf3f3md6s9d1w37sdos6r
X-Rspamd-Queue-Id: C5F74A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777376849-709583
X-HE-Meta: U2FsdGVkX18oLb/VMgQd6u8JXdy4MURAw6NXwelUx1X/exVO0eIbEqBf+7fMT5USYUacpMOLo4qQ/s8ane7Nw3Y0nXCjJ/qFeALmuT5KVScWDFH8kXbpCt1r03qkvxHjB+Ux3lFd95mtH6PeNJcQjKa1srWS7VEL0TI91B0McN4EW0XYVjXQLI7DmM5C7Obzwlj9B8vtHmqlKxMBakVJvETTlmcTLK9tu8+HsdbcVZAj/vRuJTHkC1zOgEl0nNfEWni9vjfoI7NMbo4YNSIn5nlImVEJXx1t8MEUfFOuwpHwnb9hgqxp4Bu3tS6vUDY+ovzcOMwLpx8scsWOaKc3+dhvlXKXVFVQnQyrToX8BdWgvPrKpiOne4zrOMVL0b5It/sn62uNtDQuUS3ulWPdDJCS+UwlxqjGL97Pk1AcAIce8XTcSHtjhExWXS81oBnCDlgezBUQgPosIIjSpJbW5587j6LSTSgRch9ry9ZrFhXdaF7tgmw9GcP5HAkXSTus9h42/KdPUgq3aG3Qzu/Mpk3mPQ0ZpqD0IYIweXZpIRMiLkCprsgEmS8dq3WkPaBOL4O0MrwkHbSnCZauyy+ApDU19cyquqakausBIHynfUpzBkAGKJJZvgcVEeSitiWG/UlVhemcsRBsdidNEOR4IaDeNkzL6TwSZ0vuAgbbhthmbSEWAOPmmjD0kGaIcv0BwIr4a0FzpnzMxvgZQg6pnhI0sYyQls6OiY3QmAU3N6MyMMMh4y1AmknUn8KsZV3VtSVT/9m8/hfNTz2OhHGyY+NqDOxHh/foiOB5pgArgME2Nk1xdrV904yrXE07Ul+F5EsOnY750LVpaySH14JXFO9VNb8QjVmXHf5bm238x7KeMd7GKThDiISjZxg3Eb6DJY4qYf/HZDRRohFGI6bfODJE+ehVnF7+p5KKd4dZIn0ebC5enAvRobl/poGO9Voh4uqUd+JjN5h32K9EsPQ
 IWSG0OLD
 ueOH+vAUhsirmE2IdLqDSZ+7to+THMaXl5lmUNXr4jzL+c9Ktnt7+pJ4xJv2fyQOiijOuzDSj1keMg7E53tl1p3NnvY34c9ECibSC3ww2vo2joiWhGBidSalYpuOJPz3KDU639LsVuv9fJ223G1/c+zHuTiADpXAU8e/4MgBSmljxBBMM6HQOIo66LtQav1dmKtwwKo/GUdWZkWVXoidlRa/N6W0n5hjpRFvArrxFw9M+JpYhsuTf7yBaYpmoq9SlEVf/HBY1naJy8HUYHbEKasXsXBbw2uBnDO2zauAkxD/GzMlq+ykTdiWPuddoOax1qIzjnqJjG68zCf+xbhOr6r37Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 10:58:41AM +0000, Dmitry Ilvokhin wrote:

> I re-tested my original patchset after rebasing and can still reproduce
> the regression (though smaller). It appears to depend on compiler
> inlining decisions: in some cases the compiler is able to deduplicate
> the cleanup path across multiple return sites, while in others it is
> not.

I'm confused, all this has __always_inline on. And the compilers should
be able to track the assignment of the variable and eliminate the test
themselves if value-tracking excludes NULL.

> Given that, I think we can go further than just removing
> __GUARD_IS_ERR(). It should be possible to eliminate this branch
> entirely and simplify the cleanup flow.
> 
>     https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/
> 
> Reposting here to increase visibility, as several people involved in
> this code have participated in this thread already.
> 
> Any feedback would be appreciated.

This would require very careful audit of all the current users, it's had
this behaviour from the start.

