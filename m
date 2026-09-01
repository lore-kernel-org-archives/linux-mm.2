Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A0BC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E266B00B0; Tue,  1 Sep 2026 04:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96B06B00B1; Tue,  1 Sep 2026 04:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B390D6B00B4; Tue,  1 Sep 2026 04:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 899646B00B0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:48:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10052A031B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:48:15 +0000 (UTC)
X-FDA: 85164566550.28.D8CD5DB
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id DE2C920003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:48:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=crpT1F+U;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpu/fdT1/zQmBW2aWFatHbtf3Lbyi0UgKBAQFFYR+/8=;
	b=Um/5a3y9KuFaw7GjoZ6KroQGyrhFfm3SCbY7Cklfgakg1DiTwBt4GY1YwzWgVDHxFp5NDm
	71OSaY5gCgz2x9/yTjN3peIcu7WtXT29zmdLVKFiJafAzfR44zdcc82sHyCdB3hlB/zX8w
	gtZgQvIceyVYbht2lUJuDUNMwTxSQOw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=crpT1F+U;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788252493;
	b=W2725PryHGCYVFUzeo38y9WdolzUPscmpjQLebxHSpIriJD2kmpVcsVLFPaBgywx5ByZKf
	7GshoYwBMk5hLO+M7gXYbTBJWPMDRWoZ2WkVbeZ79Rtn+/gOisN62abTuBK/u8b3X1dnlB
	ctS3wYL65yVLqnRT5Pxwv+8YIxw5QVs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rpu/fdT1/zQmBW2aWFatHbtf3Lbyi0UgKBAQFFYR+/8=; b=crpT1F+UAX0B64FPtk3BPp45rL
	WOezknIaCCTAx8c0mbtWllpYwAhnPrEUj1Dw2yNcqHBJoMNNsoXvgyopZ3oE5E46OnA3TV5aLsCmf
	qjtj9YFWseWAVp7NdLvBthCj+SJ/DYkji7LJsRv8jbMDxUtT0co6JL8UDEivWcGM/wKahhwf+kTV/
	Aa9oEEuBOBJ7/KuIIkmkMUQ+ACck6r+vLqUbOaqngRlUHX7K0/PIiv/0uuecPishpyR8Y8ArkXiKY
	CsxDpBdAC1n9+G5DTQTKvvxZq249yEn1SO06VMNWiQtEOaz752NQZLpfuZElaZgfORuC0MIsJ+VBd
	jq38t8rw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x1K9y-0000000AlQg-2bQH;
	Tue, 01 Sep 2026 08:48:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C3B5E30031E; Tue, 01 Sep 2026 10:48:00 +0200 (CEST)
Date: Tue, 1 Sep 2026 10:48:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jianyong Wu <wujianyong@hygon.cn>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Phil Auld <pauld@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn,
	huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn,
	justin.he@arm.com
Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Message-ID: <20260901084800.GI4121339@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-3-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-3-wujianyong@hygon.cn>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE2C920003
X-Stat-Signature: 6o5x85wfmi5ofpgupqges838xmu8aqfx
X-Rspam-User: 
X-HE-Tag: 1788252492-340962
X-HE-Meta: U2FsdGVkX1+nXI7XQaDhMQZSHUyNoIHxWiVF1TuUb/NrPCzjw+1VoXcnDAyg22zoNzbu4zfcjt6wTpgPuL7JzWCeIYzfABKiFyToGT+gaLCHE7agZkpRvJ4e+awBi2frmbRjlH3KfKjwLTD209aCvok8DBMAPT0JgmNzHcI6GmeovTohKY7LS25/f/0kJUHLUZRn5fIlpNJrj3BRblnkHxLCr8DFhkwMM6RKj6GwqjNJKkhYYHJYFfEzR9EY/jgYacFwLPVwhoiIS0DD0X1L4jV8XXAlgZKLjUmN4UbXs+6fYz7rUNWH6nV1M56vRqhoNbFWSs+/JykeAKcPiwNhfmeqzukIkwnv9n6Potpx9oHgE6Nolp7FT3mhQaMaOrixHJfEyeV9fznRQAEowX3vbUsMJhFW1J0HsTKWDUM4+qAp1Ava7AFksPMbXfaDn19nb7OF2ceJcr27UwDRrDXPnWSst2W8pbvu2D3TZXeURLw90I7wQXn4ozr5hBy8IrJOq3jaS1yeA9F5OxQ6rCncHwgVLI8vOkcT/uV44lopsHPbQlp/E9tYJcPmoFr3ZQxsV6AsYyPmMlkgkW3c1b4+0vWd8+YFBA6sAhExqep84qH/5VKWJdTy1wdQMQwubevDz6GVv39h7GZUwH6ax+5HFjxKP1T9bbu7bKww/cBXD+z/wGDRd083BOMpelO1rLc+RUm1KE1J9Z9MIqKOGhEGLV+dXSP3RL9/V4fraY+bT8q+YhOxOkckEJpwhsbrHy6QWW50sX3gDynCawQDMotCYAvb3ao4KSi39Rw9uVtYhALIpkLNbvBHjk4NEQi/gT0vGcDxa3toUwq3DyY75EX0YigI8i2DspgTMZppny9wcm07+Br91+UcIfg2eW0gpSXlCqwvHdgtsIzOT3yTFkpv5E55GL6gjThyghdghfugXqWjHML3xS+YfyghkpZK5mrx9JBpYg9HsvIwy+76cja
 Foi8JQzp
 18TBdeq+YAAv1W8iE6cq08ei8T3UUiCTJeaDGHNdtMaNGWmiW09jNbeEFvN1RD1bS97hIqDUOBLG7WpT94H/Qt/wvE/+T6+BjbnpfYw5K0/FTqJd6NCspYATbg1Gg5kGP9nTLRdqtUD9QJVYDlFV0dNDGKQAJ1y3tKDL/cEU9stH67PCov8Qtbh0HF0JDWkNaqNe7/H+sdgUxfGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:27:55PM +0800, Jianyong Wu wrote:
> Builds a refined node distance matrix based on the raw NUMA distance matrix
> provided by BIOS. The refined matrix preserves the relative ordering of
> NUMA distances, while assigning distinct distance values to node pairs that
> originally shared identical distances within each matrix row. This matrix
> is exclusively used for cache-aware scheduling and has no impact on existing
> NUMA topology logic such as sched domain construction.
> 
> For example, consider a system with 4 NUMA nodes. The raw BIOS-provided
> distance matrix may look like this:
> 
>         NODE0  NODE1  NODE2  NODE3
> NODE0   10     20     20     30
> NODE1   20     10     20     25
> NODE2   20     20     10     20
> NODE3   30     25     20     10
> 
> Multiple duplicate distance values exist within each row. After the
> deduplication step, the refined distance matrix becomes:
> 
>         NODE0  NODE1  NODE2  NODE3
> NODE0   10     15     20     30
> NODE1   15     10     12     25
> NODE2   20     12     10     15
> NODE3   30     25     15     10
> 
> All entries in each row are now unique, while adhering to two core principles:
> 1. The relative distance ordering from the original matrix is preserved.
>    For instance, original distance(NODE0, NODE1) < distance(NODE0, NODE3),
>    and this relative relationship is retained in the refined matrix as well.
> 2. The matrix remains symmetric across its main diagonal. Maintaining
>    symmetry is critical to guarantee consistent pairwise node distances.
> 
> Each row of this refined NUMA distance matrix is sorted in ascending order to
> generate a unique per-node affinity sequence. This sequence will guide
> thread migration logic introduced in subsequent patches.

Hmm, I wonder if __build_all_zonelists() wants to use this, rather than
the unmodified distance table. This would ensure the node fallback order
is distinct between nodes.


