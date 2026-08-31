Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7AFC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7566B0088; Mon, 31 Aug 2026 07:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E1B6B008A; Mon, 31 Aug 2026 07:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF036B008C; Mon, 31 Aug 2026 07:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F371A6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:50:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E82B1C2045
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:50:18 +0000 (UTC)
X-FDA: 85161396516.05.051EF89
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2CFFA40006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:50:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=AdN9RsL6;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788177017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDebJtj+sX3RBx4IpJ0XhmIJry2c2+dglSVudIUPZUE=;
	b=2uk12ByaVoKP7OGQaZnFHyJVFC5l1/3rXyS1I9JyDib/Un96R4KP0bJPo/cUVVXQ0adtKd
	O33LhUV4BHdaJjuSLRsgKu6zgMGF/FkvA0Cpj8km70SnXtyNHgwEIhyc8QghiQhjyP1c7v
	BltMLUCWXbNw3YurTNEvCmlYaipMUow=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=AdN9RsL6;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788177017;
	b=lamGn9/qRDwDYSvjxsjl61jD1OLG7Qpx5TxNsz/ANtN4pnKi08dOkyhWCpdqQAcZnt9CFa
	yjD7/GEicGuhlj0H0M09C+1HANIFmLYtk1zPF3JlgOwr1FqSLaEcOISixrV9jvS+py1Ur5
	3YUD3ltTfJccLlmFCJIfQ4e9/6qmkiQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aDebJtj+sX3RBx4IpJ0XhmIJry2c2+dglSVudIUPZUE=; b=AdN9RsL6r9JMai+CEQPHcCKxI5
	sZcsFUTuoQL6iHOH6Clb6WgoiyAA9PwDD4JH5q7JQeW+nHPBtN9X5NsYMI3ng+YkoVM0ijVv3vo3/
	L1QIFiGxIx4AQ9V7FW6Q5suvhmktMUDQ9r44TX4PMVPR1ShBBzfCbMVYkGf5WxNKXmLe4rT9KzQVI
	vCWkAzQ9t0oSSb38vAk1oiqqfWVzLBPrEfXrFXl3CDlZLfdAycoT+bIrQLKpIHls5VlavQUACUT0C
	9zqYTcbnHFjpIkgrNrbxDuawsr41c8kARi3OUlLWu5RawNfuTEOQLiMCKjQ0O6ACYwvSRKkY5pVwo
	KaW/3SaA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x10Wb-00000009pJc-3iGF;
	Mon, 31 Aug 2026 11:50:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 21E69300CC0; Mon, 31 Aug 2026 13:50:04 +0200 (CEST)
Date: Mon, 31 Aug 2026 13:50:04 +0200
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
Message-ID: <20260831115004.GF776954@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-3-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-3-wujianyong@hygon.cn>
X-Stat-Signature: c5n4ze8m3d3z1wrjupznnbud9ghz6nns
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CFFA40006
X-Rspam-User: 
X-HE-Tag: 1788177016-934705
X-HE-Meta: U2FsdGVkX19Lwbkxx0wmovqwgtyTL1gbPej4w3tIeLxUKGcgrr5NJWLqJJFLOJ8ezzFALQPFYLC4+lwivWTxPYLn9FUCxjINNIaUqNS8aNRf6gfEuGyesMlFzhQFZo8xeGMffSz87lKmtycBXtQB7x1WVmCHFAyM4rw0O8MRXgfnD/7Ng/ORAFD+6Gl58MZtFmbciwXAyDu2B/dyopZ1sPlQMmVCz9hiosAof9W8squPKrayrU5cR2kYGtfGXEUbEZzb3UKQmvWadBg15DWRWAB9TqGsJPIpIuCZSOyFcpO9sE76jSXFamuO5Equ3bJQ7MHkqn55vxOjOfDGiMDznVcJtiJ4p1/0gK/QfoUkhgX+xcNtF/aSTP5nr2KUiYEKKXeBbfm03oAJnyS5ewMmQhR6gvl10ogHZZWTa6pUpB/Dv/NunmKLP/Zms5L56ubAi0jtvzX8/xug0AIKIMpVO6jisIDl6GR9S4uxRW3RD58DjdrnC/VubgSyR+zKVuO5R48g66BVtiEVgYqACHte+f4/aWGAUp2eNkR6tGLCnHEMDK6XXq0cYR2Ot0/5RVKQ46/H1YnZshBHvNdovJ25El2zlE61BxokudCdTEf+eN3CB9TygS5ba+3OX9WmHyc9M8GnZo7CDdNeh1RNhnbH82Gc/g2Z9hm+oBt6rAASmisSZMDI8Ne7NABM2wEe9mLE0G7KgzpICcaL++n7g7CfBNHk/xRJlHvtxf4ZSazrTNs9d6j5P95WO9YAZFkk4qRahVVMQPgJ8bjGvfeFjqMYjjF/wVt7TWvfyJO747AN6KsBSZ4MYsXFhMNtymljLqxeJlH15CHr/jwesOyrkCokNUCJ9567E38qGHiHjxzh4CK098EMb5rwcq+u+dAd2puy5KILyp7QGAA+pww9l3u+h7JMptDffAwzroFucrm3TpW09WTpmTwwEMfhU/FGkuvZMQKVXL69J5qanR7zRRd
 tpB8UamD
 8/O0n8dLZXzHZlxk9gIXaRpztINaMBaZq/4KYQ9G+A6XjEfuDwnovHDrIQpR4JO4oNl9QdymeesDaxtG8B5kvFlL1X4FCZyNF/bZqnsSIuzzXZsm08r9qNgcnHsum/Eh7R86qICqzvZ2fQrxzvcc6dtldeZP20dRvh0gqQ4Ryvw3xy3J9VCP5zZeg7Je/FP+fG+koRlF61P5QMZtrrWS097cu/Q==
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

This example uses Node only, but the code in question is specifically
aimed at Cache granularity; might it be better to use a cache example?

A little something like so (I got tired of prompting Gemini to generate
more complicates / less broken examples)...

Pre:

Cache |  C0   C1 |  C2   C3 |  C4   C5 |  C6   C7
------+----------+----------+----------+---------
  C0  |  10   10 |  20   20 |  20   20 |  20   20
  C1  |  10   10 |  20   20 |  20   20 |  20   20
------+----------+----------+----------+---------
  C2  |  20   20 |  10   10 |  20   20 |  20   20
  C3  |  20   20 |  10   10 |  20   20 |  20   20
------+----------+----------+----------+---------
  C4  |  20   20 |  20   20 |  10   10 |  20   20
  C5  |  20   20 |  20   20 |  10   10 |  20   20
------+----------+----------+----------+---------
  C6  |  20   20 |  20   20 |  20   20 |  10   10
  C7  |  20   20 |  20   20 |  20   20 |  10   10

Post:

Cache |  C0   C1 |  C2   C3 |  C4   C5 |  C6   C7
------+----------+----------+----------+---------
  C0  |  10   11 |  20   21 |  22   23 |  24   25
  C1  |  11   10 |  21   20 |  23   22 |  25   24
------+----------+----------+----------+---------
  C2  |  20   21 |  10   11 |  24   25 |  22   23
  C3  |  21   20 |  11   10 |  25   24 |  23   22
------+----------+----------+----------+---------
  C4  |  22   23 |  24   25 |  10   11 |  20   21
  C5  |  23   22 |  25   24 |  11   10 |  21   20
------+----------+----------+----------+---------
  C6  |  24   25 |  22   23 |  20   21 |  10   11
  C7  |  25   24 |  23   22 |  21   20 |  11   10


> Each row of this refined NUMA distance matrix is sorted in ascending order to
> generate a unique per-node affinity sequence. This sequence will guide
> thread migration logic introduced in subsequent patches.

IIRC greedy has significant worse bounds than many other schemes. This
would result in more unique distances than strictly needed here, right?

Since this is all on slow paths anyway, does it make sense to pick a
slightly better algorithm in order to reduce this bound and get better
results?

Anyway, let me continue trying to dig through all this.

