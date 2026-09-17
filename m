Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D86C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB676B0095; Thu, 17 Sep 2026 11:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083626B0096; Thu, 17 Sep 2026 11:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D026B0098; Thu, 17 Sep 2026 11:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5CB36B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:30:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F8A41C2479
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:10 +0000 (UTC)
X-FDA: 85223640180.23.FA02453
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8789414000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Y2TFScVh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789659008;
	b=owHFFBSTApijK+DrQDbdwzH8urHHAVOi/ExelS71ovYMVFv5NHc7Tcq5kyNTX/sMEt7RfJ
	HpPGqspS4YgG2vOBkW8irhwG2POEODcy8J0RABzpzes/CYRhPecbOiJ8mQc6pZxoWzrUAH
	PsowbsgeqLicT5YoS1yoZCjVvp0W2qg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Y2TFScVh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789659008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTfUOkKMGqgqjaFCBY9cwK+mhbSSBWEoZUq8zIqkfmI=;
	b=3B78HP5GLZ2V+XEpRQoZ+Gb9TVPdpRof/lh/dm9rPODAzC6gcqCxLbhgfQRB7htfrd7adp
	kYvM3aMxT8/CKXPbJAqyl1ywBnQ2hfPe4UewdcB6K+B/bcPQxzRwV2V2EbzHeo92iasY22
	/o+CSqyaFyq+GHl5jsODSKuq7aHhsTE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sTfUOkKMGqgqjaFCBY9cwK+mhbSSBWEoZUq8zIqkfmI=; b=Y2TFScVhT4tsYVFry161EhyqSe
	Hme1WS9xN6vaajiMtnqa0tFXEm1VBXMSwUSWcpD+j0aqgz0+QUKwAyIo7MXChWqf3W2CHRSrffvvb
	//7bKSIw49o1liqfVlDMtnAYLUgjPQttyP0fUR0ScQuGI7pcM9Fp3ERmddTFgQjCr13Nzyt+nmcRa
	kMhoTMoPaqTHevxxcKSO7KhMg6C/tb41LnyNRKzv3YyNuyFLXhhgVFM3nvx+DD5qt24MBlKS/srQV
	nOIRvdgTvv9mLRHYvhjmW3aqR+S9kJozLTRLtmcX2c5GWRK2+C9ANaRh5iedx6gLVDIgNlYNCYcYx
	jpUAYrlA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7E3k-0000000Alj8-3tlT;
	Thu, 17 Sep 2026 15:30:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 058C1301BD5; Thu, 17 Sep 2026 17:30:00 +0200 (CEST)
Date: Thu, 17 Sep 2026 17:29:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Harry Yoo <harry@kernel.org>
Cc: Tim Menninger <tmenninger@everpuredata.com>, linux-mm@kvack.org,
	Chuck Lever <cel@kernel.org>, linux-nfs@vger.kernel.org,
	Jon Curley <jcurley@everpuredata.com>,
	Eric Badger <ebadger@everpuredata.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SLUB] nfs_page cmpxchg_double_fail and perf lock perturbation
 on dual-socket NFS/RDMA
Message-ID: <20260917152959.GI4121339@noisy.programming.kicks-ass.net>
References: <20260916232227.4098143-1-tmenninger@everpuredata.com>
 <aqvq8-6IJBDer90O@thinkstation>
 <aqvy8NqRRRmUlxjR@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqvy8NqRRRmUlxjR@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8789414000D
X-Stat-Signature: 8ygk1o5eerzq3np95ig1ikiqoxngegf9
X-HE-Tag: 1789659007-591516
X-HE-Meta: U2FsdGVkX1+XQe3nfxp8ulqUmQvsO6hoVpaplAuol4ip/pfMKnQDuAhTxO8/0eY7vZUFxJWefn1yrfTAtZWG5IoiRFzZluxWtwboXjm/EMv0VZmI80VNzXUFmhijnBwjJmJzmxxBK0ooiU4GnIWWjrGSMO27sdFRC1jQ0HjrWIU5XwhvkSFkAH/zv0IR9mQ8W3zZHN6WrcVpRbqnD88gTr2xlOYceRSHEV/6LYO3ybOJV0yCEmjKy8fVMB3ADYKPa0v70DX2/EVOK8JZpUkKqkvvz6X0vZCpTiHnyFk5Hws/ZTK5DyhxSu9yMCN3cXKc9ihkITPt5ysjZyECwYapbGLEWqrtsfuujkdQTWYrhn3N5/hAH5aZrj3u89OjwQkrbdJiRCdjkyfLFpcNi/ClDW2DYpXikr9iWiPSqeFUAqF+/AbjhC0qWrudvhxZJ9NdZhaksjC+THkp7O8FS4xeI9qUnOjrmwJFL7ZYj4S7CWZUVXAZHqKMF0obZr9jsrSnVB/sGBsa1LrsRzXQ89HMrOEYplNUtDCF281odGZkAleSTK4dEO8QShVuWQWVSazKK+bavrNMUXW35Y0sNUMq9ko2QfRVPJORwcec27PrZTJDVC4qzTeFUiKHoyCnF8tt41vUNywHT4qZGLU52C82vxcVa5+bE/Wn+4A3wtV8y6+Cu2Xi5lePcjtWTmoGJ/ZLhTmwKmTIOY6YauG78gaVtLahs9J1htnyo8ddtMRjhZGfkaH8sI3UA2yZhcB+oWtuPpx2nGrSstzHQ0Cy7UY70jli4mL6gEua+YRv5H7vtBQtb8tMap5yR/8ZiUkSNR+W1PPmwkuYWIVsukBymVRBY9Hq+qJDTLBceSPYZONj0Nu7VNAYYxVsvRvKdlXs/l7qSZJLqJv0NHQ0VnJbqXqwkECThE8w7XFh8cBTG4v04Ke+lTe36HBn1v7WtbEfw9MQ8SozNbJjJBAVj0BkLWe
 sPUlk+7m
 pQ8iF7AyPgbM4Pzm3Mos3P4tpWbCEeFbyfd1ODGIVbCFTv4Yy0HY4B3BuAqP++4emfT+hD5tFXmFARk77vS88w/1FdQ8hd8ZovC477Yu4nNvrfah8vbsLPtfdIlyVTYPjYT+78eJCDfBM+T8GCO/Y8MaEGhax5BMi4DjDj/ecRKq1Bzw973Bwn6TJwxWyZtskzgI/gzCWtTdcW4GK9kwUwxjPo3boCLgYFOPfSyHID3WoDoQBF0Sjov+gWjHrwG71LuO5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 03:10:47PM +0100, Harry Yoo wrote:
> ... now I realize we need to add PERFORMANCE EVENTS SUBSYSTEM folks 
> as well ;-)
> 
> Hmm, sounds like perf lock is somehow triggering slab allocations
> and interfering the workload.

perf should not have runtime memory allocation, its build to run from
NMI context. It can allocate some memory on event creation and the like,
but once its on, there should be no more allocations happening.

