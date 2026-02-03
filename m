Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D5FE87839
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 14:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0126B0099; Tue,  3 Feb 2026 09:58:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963366B00A2; Tue,  3 Feb 2026 09:58:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8487A6B00A3; Tue,  3 Feb 2026 09:58:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 528576B0099
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:58:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFA5D59160
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:58:33 +0000 (UTC)
X-FDA: 84403451706.08.4DD61F1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 684A920012
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:58:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bUWbI5Uk;
	spf=pass (imf03.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770130711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1HfUdPrrMh9TULkpQcZlfAxujJiWRO2oG3M94cIgm0=;
	b=4ScXjeMutvVXOUOVvgm84/0kaBLTtzisReo2XSngjVxAspMVF8KV0U4/itQVOzIym+6mo3
	oceZ9BXWNMxr9OOMRdn/dvUzFh0leMdVYVd245HqTbPPpz0okv4ESuqy0HxkxQJgHveWEK
	FPbIHWIiKw4wyLCzG6/Tkgbak1daoKY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bUWbI5Uk;
	spf=pass (imf03.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770130711; a=rsa-sha256;
	cv=none;
	b=gcTAtAt3T/VHreUcoVcCPoWYDwqr0C2Mdx3r78o/lW6dGeGS9k9acwAu1YqDsNnWgJ9O1T
	rTfTVtjZWr54eVgULMWpn1r+aI73KBg8XZIJ44Qa6YWH1bFyYA9VBNM4V52klGHUxerO+i
	8igWW/UdQYd/rqrQL/35tjmqK9DFAU8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770130711; x=1801666711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3OqK9oTeVR5lGSXtaWyFd41ZMpY3Io7T1BufEaZUCaQ=;
  b=bUWbI5UkkRIOjJEnQ0EJ1wKgY2fbNpd9mJIDd79WVC/BS2uYpfWd6cqA
   anfiPcI27IYvqWKvGou3wH69ddQaDeIOWwq+EZgXQsm1duvZ3F3Ef84V0
   cQoenoNFpCHAFTNhgVBRxpzqTyj+qcvpSEtzdV9kXgSHkKulraJCltZsZ
   1KmlYdFJL9Sao2aVj1agP70sLzRMjRbjTNlxUTw0TNY3YUBpv0sjzLvlz
   d6QcsMVX6mZ4TaY65Lq7gUlHiqBXCedZGV1MhKwh12QkfN7taVXkuCuZr
   KrRt/jb3EOPwLzi7rjS4udGjyGtZfCLVhqsrC2uF4/0etROUWhz1z+Csx
   Q==;
X-CSE-ConnectionGUID: l2GMulsgQS6T5hKgJsolxw==
X-CSE-MsgGUID: ipsy89lmRu+EgtvbadAuuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="70319511"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="70319511"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 06:58:16 -0800
X-CSE-ConnectionGUID: TEiuhvuxRciWAcrGKGfvVQ==
X-CSE-MsgGUID: pMj6s6SHTVauTS8hT+TbVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209901413"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.99])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 06:58:10 -0800
Date: Tue, 3 Feb 2026 16:58:08 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: kernel test robot <lkp@intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Simon Horman <horms@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Yury Norov <ynorov@nvidia.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: remove __printf() attribute on
 __ftrace_vbprintk()
Message-ID: <aYINAPJS9zXlUGCw@smile.fi.intel.com>
References: <20260202095834.1328352-1-arnd@kernel.org>
 <202602032036.FQK7gJvV-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202602032036.FQK7gJvV-lkp@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam11
X-Stat-Signature: ahy3pp1mspew5rfhwd688k15cmjc8iwp
X-Rspam-User: 
X-Rspamd-Queue-Id: 684A920012
X-HE-Tag: 1770130711-284091
X-HE-Meta: U2FsdGVkX19EkWyX2PV7AGIYUFOwACjFs3POLt8e7qHNzRuetjQEV1wxVwWcIkDWYS5BRhzi2urgJGcGdrBFNQJTMbbjQYWl9vkPYk4QCqiY2/qZnUed5HQB1IV1L7+o8GNhaXuV7tmjJBBqxzuFEuCsabaAaYDu/D+uLPA8IcPASCaUym6gMxIsZ/UOBX2xZF21+I7k5/ls/aQXDv/nupcSa/74XLFSqJbYsWbOPIuAePZJ7m2wPgnJe3r2lCgZChcNn+7H5qaPE+8+eApszQDfJ6R7xFoDIn5rVClXaKImFveqg2xhMMUWszQIaVfxIHc5rLy0IEDUnzhx6CMobqcTXSgoxHRT39EBwdie8xtY6GtKFvMumBQwnQ4zexKjTybU+oPOrXIlNX7tbaptoMPEcfrnCvODcgmhgopKbrnNj+6aGcdl3u9j8TG0l7dYfAV1vVTfJCnU4Ks0QuWmPRPK3v3PVKh24QjlRYt10KzQvGAp3lLG7KjWLbGLBtAHQvmrb0IOXyHX1DkxYSlHsacTkwiTb3yqISyOWwVS2OATgrBYk293bKkysAt6biOs0TUh4n5HSZ8vwtCtf/94ao/SX1057ojxWTg9MxUL79nB/Zk1DBJJ5agdt9JtfhGAwilL7OXPxvpCcDLAUPGo90/3bf6Q8XdQPHZzWjm73Izs8vY/A0YOMOipTKTCo9LtMLjyj166kYNqabNPAM0L6yczt21X3JFaTMuUu48GwaxGwehmFgVykoC0667hzqMgMGxQbjJh5vnb1ttV12ut5kJVY6nf1adHI8sNWUI9RgK5xbrf/eSzmn8v2yP5zjlQ/stT/uwQJluvrKOl8+xfM0eza/Cy6DLjqFvWOtVdSpMsvs6L9EPagzzOfe+LD9urMmnRNps3eSIdKKgVVWgZWFzvBFv0+DEEYPckQqQh7e+DYFb+l0uKtAZbID9YF6u/Fxk4nrMsneexVzzowCs
 Su7N0pUR
 obqqZnOb5eDgX65kSq8FPxQ2dirBRr5mWVBdE5eOjI+nHXBfX5I/3+rLw3xGZSDitcfEoz7WQNJguX+32hf3ad00rv/9+bT9HIS7RPHLOZRfrRmz/UM0ut/9VcY5yGxbLiTwP0GoBxVjaHIgcQx8cHALMdOvSk7FeI9sGCeMVhyDpuOmxrBpHqu6KCuVjIASNgS/NReZ1Sv06OYoE2e/o8/tNNvV+tAc0GxXtzjywB7D+X73oo+ThMTAPc7WFgs63n8FtSA6QZrf9e0/7hQihxae2Pc9YHj8gUtXH+E8C/zAxUvZvTT1+ONXNIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 08:12:57PM +0800, kernel test robot wrote:

> kernel test robot noticed the following build warnings:

Yeah, you need to go for the full stack of these calls and mark the bottom one
with __diag() to avoid these warnings. That's my understanding and what BPF people
required. Chasing this one-by-one would produce unneeded churn.

-- 
With Best Regards,
Andy Shevchenko



