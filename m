Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE54CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 03:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554AA8E0012; Mon, 22 Sep 2025 23:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505228E0001; Mon, 22 Sep 2025 23:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4423F8E0012; Mon, 22 Sep 2025 23:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3416C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:49:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFC361196E5
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:49:24 +0000 (UTC)
X-FDA: 83919135048.04.EF7E2B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2DAA7A0007
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:49:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EIaeeEoB;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758599363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HolQDODPyhQpKJyYF9xTae4d3HIDUM6CjM4Q0UXx/qw=;
	b=qaD+2B4pfi4RXQHBH5k1OTRElA8xS8MyxZdvxdLZxSMxB5e7aFrWYEFMxdvu4RInR6+APd
	wKztBZsJvyurYo9kHIiSbQ5v6xaHYBKklj2SFbfKlTmTMBFuDsj+pebQUDt7YQ4+W3zMOx
	LliKVdrW8ZL/Mkgkf+ivZkNE4/3vaCk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EIaeeEoB;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758599363; a=rsa-sha256;
	cv=none;
	b=1cr4bFVxjkXcgrUAX2/9LtpTVTHLawJSliIUJZFy8BX72BL97+0H0ww7TTj1pO1Adlxw/y
	xnEMYtlzD6Z50e4qDzOScKScLtxrgKqQppcYfdZsr2GDWUgvihd0lMXUzRJlZMVcFa4Oy0
	dRmZhEcOFdMUCxDJA9y1UnZBBVpNBdc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E3F560271;
	Tue, 23 Sep 2025 03:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A650C113CF;
	Tue, 23 Sep 2025 03:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758599362;
	bh=sbacde5IymS4zt+PGppvs/FCiZ+f8/Siy/4gHLV/nA4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EIaeeEoBduPf96ORvfIJNMSLaqJgIRWO/INJuf3A34PfOahvpky4EyMCRd75MFVC1
	 TaoN2Vdk/qp1jn6U/ybWSUZkyf6GH6cdxHVaZayivCjl1Cd6yB9eN0oQMLRQ2xAaTy
	 HZ/Jyxanb9JEKifvsIJqPsuLLOU/bjACVUICbgS4=
Date: Mon, 22 Sep 2025 20:49:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Nanhai Zou <nanhai.zou@intel.com>,
 Gang Deng <gang.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Vinicius Gomes <vinicius.gomes@intel.com>, Tim Chen
 <tim.c.chen@linux.intel.com>, Chen Yu <yu.c.chen@intel.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, Roman Gushchin
 <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/readahead: Skip fully overlapped range
Message-Id: <20250922204921.898740570c9a595c75814753@linux-foundation.org>
In-Reply-To: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
References: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2DAA7A0007
X-Rspamd-Server: rspam05
X-Stat-Signature: 36axes6fkhhcarhysom44crtqbcam6ko
X-Rspam-User: 
X-HE-Tag: 1758599363-153052
X-HE-Meta: U2FsdGVkX1863EaaF1Jn5WjmeFCGhFmm93AR0QHpGW7Y6BfFr0k5P+eI2+nGHFOSmQbqOwM7eXpcblIvFAuseTU/ARAMdNWXlUl42UGx5cMdW1wmqxaIKW8xbFMmqZl4nEHcWCYv6CFSzOKFRWA1GjsU+TLRiTmOihXCeYs7qUT/vXEZRHhuvUAhFu+kaEtf4XXBAhJI5O5f7mi/hVXDHuja6KsBb5guPMm9Zno4ioMu2nifFP7OvFug5jQ6wHbUwJlUBFcfynYR4hGS6jwzrQ5ZqSRby/ufF9/RGHCjqWHFoK2ehMIxLTEVbXDUCCX2iyFR0qQylbZ8FVIR+6gQMAFo6GOg2jB8Pjsck3RhuocA+72OmvjZ4rl147Znlt6Hk3tInPVER+/dxDlj9XBqw1lH8xh1okra9+Z6GcgZMHlIEJlicVQX5fS0D03GIAqBfqS1bHmorUwNFV5iSuPh+X14Qrl1WrEiFsXrIXxo7q9CkDEQg4vnG9dfgZGS4tdRQve87M2HfI/bJ5v1vSTuPRC2PpVAEBq5Yx1Xi8/JIrC1edLEkEY3UVrYwH6hZFeCZ1+bpvNi81UpLcHQ7MGqLrWBxSfamYKqC0WHjvtQvaX1k3q0fJ3rQ9aWHl2bw6hsiT/xo6tIVrjLcszr6boNNJ11r/2HrdaLgolC0uy39oIg7c1BnT0xo5NmtsCW++E9yEW1rnk3ruvjlk/n/ofL5SkwqyVE1u0fEhMptSEtFlOSvYGpp1/HURJXROu0KSZm9PKKb5nCN0tDDaBP/W6fu3uUL5IIrRwEiyRbACrDy5wiGovPJh9va2+tGV69mzVb/LCAAw5a8N4r7B5WMWHZ63Wa0tmIqPzvo+zGjSCTCegGfaP/9t3rc8/peYu0k3f3td650qt8AGiJfZFs0hgf0x3xLbLXlGt5ZPUG3cswH/rfurTvWvb5ktV4Q4/vAPJ0MmcrDBvCF99UVm6HBl5
 S5bYJT2m
 te51ESBcucPldgJKcJIe1+GkjirEoEzA5DJ7EhbS3mIK3H/K17eUmHtZl7JI1HrxPKNs5DMfpQtDQYn3+aJlgL315mDu4PjkEztaEAiLnf0fiWfXxqdQs9Es0YUyH/PHz4FZY8j/dbzgaX0lpvsSmulydlN9ne4aHgWDDuzsxkJre15aV/A2FijWBIyIkZJ9gFIEEj90Uyjo/f46y8wH0lheOEXYLmVYh1wvkU4NBDse+QnfFbXrGW5FOO1OSpqRVD7y5UIPtEXPnEnTQsLWZaze49w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 11:59:46 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:

> RocksDB sequential read benchmark under high concurrency shows severe
> lock contention. Multiple threads may issue readahead on the same file
> simultaneously, which leads to heavy contention on the xas spinlock in
> filemap_add_folio(). Perf profiling indicates 30%~60% of CPU time spent
> there.
> 
> To mitigate this issue, a readahead request will be skipped if its
> range is fully covered by an ongoing readahead. This avoids redundant
> work and significantly reduces lock contention. In one-second sampling,
> contention on xas spinlock dropped from 138,314 times to 2,144 times,
> resulting in a large performance improvement in the benchmark.
> 
> 				w/o patch       w/ patch
> RocksDB-readseq (ops/sec)
> (32-threads)			1.2M		2.4M

On which kernel version?  In recent times we've made a few readahead
changes to address issues with high concurrency and a quick retest on
mm.git's current mm-stable branch would be interesting please.


