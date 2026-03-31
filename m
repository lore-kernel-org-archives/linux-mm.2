Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F32F01061B2B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 03:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2926B008C; Mon, 30 Mar 2026 23:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093846B0095; Mon, 30 Mar 2026 23:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB3F6B0096; Mon, 30 Mar 2026 23:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD55C6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:02:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18324C3120
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:02:41 +0000 (UTC)
X-FDA: 84604860522.03.22DB595
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 40E654000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:02:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AjfzNudJ;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774926159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcgf/nnaWd6CtKz6QeNTxmCGWplJP0pcuH1q2jZJj0U=;
	b=neak5SgY1Oc1v5ZoHy7glJKpDT0xdjN4kSqnjHCYE5g6BVvEj3K2sPt+7diJBDuNCER32q
	8pLa74Cmn7bOFNzS51d6MnZO/dpwXth1xKCU8Dp7XtLaYjtGHIwFRcceyjEMpGltXMogMw
	4pdPm189QtvyIxqf6G2RmTbjWnH6HPE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AjfzNudJ;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774926159; a=rsa-sha256;
	cv=none;
	b=0/fse/meCKgToO26AP0uojEK5c/UEdDn2cfphNzn2w+ekFvysWky+Q/hljcS8esxZp3ADj
	ODQ9MVzVqqvYrExJlSyUl+84VB7vgNah5EmYhLReu5UgJLW1FS8kxw2ik24IqnLG7TXZSg
	k1EVdfpbfZ1MyEi7e9HS0PE/X6xpYNY=
Date: Mon, 30 Mar 2026 20:02:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774926156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tcgf/nnaWd6CtKz6QeNTxmCGWplJP0pcuH1q2jZJj0U=;
	b=AjfzNudJ+37u2+bTzacJSPj7Y7zPpLOERw1g9uBPVSKcibUf86ePoyN72cc1vPJHdr2HFE
	skRaNLjBx4b6Ym1bSo8gkexoLRfAtQ8g73XyBAVC6Gq99djw9WqkE8eGZjrxRUY77Hiveu
	dAoPCCQ8p6yfJGnets+tnYQTGRyINv0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Petr Mladek <pmladek@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3] mm, page_alloc: reintroduce page allocation stall
 warning
Message-ID: <20260331030102.GA615109@shakeel.butt@linux.dev>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
 <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com>
 <58a10940-e44c-a120-dd6e-ee9f480c4946@google.com>
 <371c86c8-1d47-bd70-b74c-769842718b1f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <371c86c8-1d47-bd70-b74c-769842718b1f@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 40E654000D
X-Stat-Signature: 3zro6t58z6mfyhbxsw9ueqskxo4px48c
X-Rspamd-Server: rspam06
X-HE-Tag: 1774926159-952985
X-HE-Meta: U2FsdGVkX18TcBTjzmaevoKPj7GUVNMpB+7wjTJV+f0LTZsIhxjO89dgHu/sPYfYc+hyRyzudpHYWfJl43auIeEjSrZ1XqEpZ2WLE01Ila61RsN9RwL/gkpLq82/ObnOziSw66+NpYO5aHJhdm3mZt/BMzWj6+q+6/slIScCrNJWpaLs2eVedCTP8+bOnOWZj0qyCKye9Yk/ePRI7CMGmcwniURCDEvsAVssqHfRL+5SPk4D8tQPWcEs5e0pvyo2dgqYeDfta61dQQ2N5GMXCccfvH6BT57sVbtTaMUDAp207azofzWEEEKZQNkmWJFbeMQbHqcBobeLRjQUdm40GbO8rDDO+l+0+m7Un+Mrh0TbTh8WV+PDD/CQJxNVHHEQ3Jur/TMFw6EtOmKC4AZ3w2JcJFz+3Q5bMEhaYejYFOaRY6V+4lcyl9rVlDJtQqC5wNLGUQj425RfmX4Ftkqbn0owvR4k+2lphM7O+VjC9enHEvB5wqCUvLRJutj3lGu1Yr/J383IBCU2320m8a2ATLte25EvDB2zinocEbs0nw6bYypKBB58OL+rW4sEgeBDIn7T0XirK3j+63H+3ZgbT/czs//DzlYEapF0nyH/hGIFAG/83hlxDSZcduT+oGGkedt1pU/ueapebRM9c41GaaMQK2FUHcg++luDouHl87KLmUFBalZzoQwjLUsHln9a7VxOEtL/BzUXt4P4ptsTFT/hFs/9SU+ahA0vpZlPSmfjZUmv6jdtcxPEXvhm75QApAtCIZUGaFfY1X5M6mjQrVqZRdICA38p/N1viparaJCMLtOXYK7rmee+UEmerEGbm1mcbDRhT9bm5jQl1GNZ3qcIhtPMixdcoJIIRnVnxRmA3hAv2Lu7YpRWHm8tNI3+H7i0OxFjP72T1v7VyesnURDDfc0DVnOid4CBG3uC+5CvQTtinWNGIz6aWNH+Uqnx4WcL1pcTwbpKQEZ+IBq
 fbM7eHZ7
 ZpFUHUTs3xHKPUfpzCx3haXo15NoxYcaU4s8H27GjmjMEaidS5dG//3to5607LdUxWaRxKQe2NRM8eCM3HTHkMwqtdQ69tnQ79ZNPHWZem9an5roRTDKJD/B4ZyOgvkC35pSkwFFx+kB2nnjqIYuJNAwUI+4jMzmfxI0SkB/tnniuvOSpe/1LIu1cFwSvf6gBYjJeRHLN75bQwq4EOOR8BRV3Eg2BOVJEmTjlM2zHZ4wROCUl/8i+M8nCRVMWMUwYa/ClLkXbC+sUX4lUuUPwpyOaLXqnII5pc8RnCvDnGKGZQtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 06:20:57PM -0700, David Rientjes wrote:
> Previously, we had warnings when a single page allocation took longer
> than reasonably expected.  This was introduced in commit 63f53dea0c98
> ("mm: warn about allocations which stall for too long").
> 
> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> warn about allocations which stall for too long") because it was possible
> to generate memory pressure that would effectively stall further progress
> through printk execution.
> 
> Page allocation stalls in excess of 10 seconds are always useful to debug
> because they can result in severe userspace unresponsiveness.  Adding
> this artifact can be used to correlate with userspace going out to lunch
> and to understand the state of memory at the time.
> 
> There should be a reasonable expectation that this warning will never
> trigger given it is very passive, it will only be emitted when a page
> allocation takes longer than 10 seconds.  If it does trigger, this
> reveals an issue that should be fixed: a single page allocation should
> never loop for more than 10 seconds without oom killing to make memory
> available.
> 
> Unlike the original implementation, this implementation only reports
> stalls once for the system every 10 seconds.  Otherwise, many concurrent
> reclaimers could spam the kernel log unnecessarily.  Stalls are only
> reported when calling into direct reclaim.
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

I am hoping that the reason you are reintroducing these warnings is
because you already are seeing such cases in your production
environment. Do you have anything interesting to share?

