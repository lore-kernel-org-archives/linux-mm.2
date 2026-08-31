Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5099CC624CE
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2026B0095; Mon, 31 Aug 2026 09:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9216B0098; Mon, 31 Aug 2026 09:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF946B009B; Mon, 31 Aug 2026 09:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00B5D6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:22:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90AFD1A0134
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:22:40 +0000 (UTC)
X-FDA: 85161629280.04.CC7230C
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf11.hostedemail.com (Postfix) with ESMTP id C785640007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:22:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="Z/fX1ADo";
	spf=pass (imf11.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788182559;
	b=NEqjoZFdFZe5iQPIvB624AOf+CJBbi+4dITJW58CApmic2EcX2fr+M7tnZAylrfILjByAO
	JnPRX0QdCbcspgl3YKTnUeahnjPDFYbkFHhTOr0uFHC+7yuKEQZHX+QxQxTpqZmxI0Rq44
	5Y0yZYP7achQYtzQhaOk7RNWA0XEqQ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="Z/fX1ADo";
	spf=pass (imf11.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788182559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5bhMWttEMUgIbj5UKS5FSbb3mXKWX3q6HbFRgQMzKI=;
	b=ZrylIEUJth/ndZI5XLWWxVEse06HpPZCrzInRmO0HW8QvLygSx80tKZ4OTcf4OP7g1tNit
	Es2VLIIxmHh1te14+gGlkatbAGgIvCOwsqx8ncMliLlvxyEotyLG1bC2bQN2X8dXalyaVE
	p2pFjZ0j5qJEewzJXaZBfkNTFrzkImg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+5bhMWttEMUgIbj5UKS5FSbb3mXKWX3q6HbFRgQMzKI=; b=Z/fX1ADo8gMI6p2qde3xIYicpA
	OAsRp3yZrUtVTNcA1n7Igl17tjj14XzR7I+xTazTgntMg3wbF49TyjbStqM3iYKvvg3K7AelqtdWC
	ka5DsVWX6pItIXKTIL7fV+K8zRdbeEpD/Ickjh5Ib78x1PXH0U8kRTVcEH+M3CjlhvsdqBFmYQa4W
	tc/yr5m3stcINNKHVjpVrGFDAY+MI1idN/7EGCH8uOnWwM8G6a+1KCvbvgvWKKJTtBySaB71rZQTL
	tadkNBMWnae+2fLxEbCnWcJFu+FxTs0ZHVFEMiPrHopOImWeykBopFeiaPVC9vZTbf0mz9zYIJ6Qh
	UX0IOs5Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x11y2-00000009sbF-3PLy;
	Mon, 31 Aug 2026 13:22:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A9AEA300E7E; Mon, 31 Aug 2026 15:22:29 +0200 (CEST)
Date: Mon, 31 Aug 2026 15:22:29 +0200
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
Subject: Re: [RFC PATCH v2 07/23] sched/cache: Prioritize preferred NUMA node
 selection over LLC selection
Message-ID: <20260831132229.GL4120091@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-8-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-8-wujianyong@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C785640007
X-Stat-Signature: b7xp3ch4ujfznfmqyexdawi1n9qsmjck
X-HE-Tag: 1788182558-610175
X-HE-Meta: U2FsdGVkX1/uCEGPNCQNNXc3bzUUEZDvHvfMLEAPjjM01HOS99cVFhErmiidZb31n0p0IjjNd+B+ojU/sTzq0Pu1Yf6r8rQ1nG6gonFsGesvUMSrIa3oqZjFneg93jTzKL6kamU7Oip85NKYvW/HzLG8rQJKYsq9kv1hvXuvlTq8leBdh9cqH/jJxGWc4UIu8XN9kiZm9BXgNVyx/mf+AQXHldKpkY749FFWZw+pMV1OftYjwIVvoQGfTTdu2F0Eo9QP3pXhbx+QrrLiyK+r7OhDn/5FST021qiPOMgluRo1TcjaCADLG2ejD4u5qVQeHoZNpXIPvvneUVJo3+Q61gb1gzAkrMsMLGo6uioq5zcEFbYnMDBte+9Vm3pWg8FUH1mQueoHuFvKaJUUMGFxkWUp3mQeoTusqgbhbPniocgyaZVxvVJUpvI824t+wy5QBt+vZ9/bNZcl5i/KkwiM+lQDtvuL5NTBmqhJdCbgp8AAvY/bGXhdzUQV2Jr9Mb8vh/9eSvs/8l1kSyJzpog558e7CfONOWK42tcy4TWC4qJ7+HmdcG+bB6/w4lIW3cca1ls+Rg8pmFu2aJmbfRKnLP8MNjLufNZ3PfrHzYPTBVpkz50C//wJjWih8+Ui/bOJow2VBfhUPqGq/9G5OiQVar2UnE+kfuFjc77/r9ZOVN7CN3Xc4h6UdlDspc5agl8XhYvjjUfMi1DajA8u1ANZu2VrQvdzXGzK+f/YlskUGtfIFcE2sYuwS2NHH4Ud8ZlAPuFEtVPaYoiKlhjT/ok0DbztcZlTMxHoa4aP5mbzf0BgDSCM5Aznq+KrEOwiQ7kZaQE8bxy4yJxXK19rS7bZLKQJQ5x1I9bNSMkaCGg9ynUFOVYqKmpyyfcEhWIH98yeu9McnACmMZgy3kjagpBHdZ2tkvRmLg/AlsL4Uwoxq/zmcq8obY+zbvHQ2trzOgOFyaykEgiZ3HDpN66vVNn
 MttOBI8h
 0+jvTf2lkxcG501A77CtUXBYNdkfo4RRFYHxJ9sNzhQFQATXuOtxEIWlJaNUv3xi4DIYYxmH1kS3QsDOGtJTKTUhf4W+jSMVErQMn1D+DpHIUTf4MGWevaGj6A1vyoG4XPjxo+h7uBWPElC9qF8vJshjRGbKXxio+CoFSAOuXnvbyzU5m5CHzvFZqCaXI30VaRM8Ck4CrFQAC+zU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:00PM +0800, Jianyong Wu wrote:
> In the current implementation, the preferred LLC is selected based on the
> LLC with the largest running time of the thread group. However, the
> preferred LLC may be prone to frequent migration when the workload
> spreads across the entire system, especially when the number of CPUs
> sharing an LLC is small. A better approach is to first select a preferred
> NUMA node in the same way, and then select the preferred LLC within that
> preferred NUMA node.

Hmm, if we're going to look at nodes, should we not also consider the
numa balancing preferred node, and perhaps priorize an llc inside that
nore, rather than the occupancy wise busiest node?


> -				a_occ += occ;
> -				if (occ > m_occ) {
> -					m_occ = occ;
> -					m_cpu = i;
> +					a_occ += occ;
> +					if (occ > m_occ) {
> +						m_occ = occ;
> +						m_cpu = i;
> +					}
> +
> +					cur = rcu_dereference_all(cpu_rq(i)->curr);
> +					if (cur && !(cur->flags & (PF_EXITING | PF_KTHREAD)) &&
> +					    cur->mm == mm)
> +						nr_running++;
>  				}

This level of indenting seems to suggest perhaps breaking things out
into a helper function?

