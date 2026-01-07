Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5F8D0D167
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 19:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF3B6B0092; Wed,  7 Jan 2026 14:05:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1935F6B0093; Wed,  7 Jan 2026 14:05:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1866B0095; Wed,  7 Jan 2026 14:05:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC8EA6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:05:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B1B3B98DE
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:05:37 +0000 (UTC)
X-FDA: 84306096714.28.F31D10F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34202A0009
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:05:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A4RHJTdV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767812736; a=rsa-sha256;
	cv=none;
	b=oT/AxnDuAF20G1qnaK+wHUcZ8dNwzEIlc5irWdmyYInnFG+BU2YB4BvST1T/1DyidEUVym
	6QSFks8481Bl/UwGAyHQ74IJJ4jgXCv3QAcg/1pHRRuHRzpM0PX2sS5AMlYIpns/6g0PvU
	y5AKdFvTEF8TOEkjSTDKBIYdfKDFEi4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A4RHJTdV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767812736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=MldaEfbjcVC2b7Y9Q7MdTrFDUGsg6SwZoadzt/x4YTI=;
	b=O15jNbfgscPlx2wb0akmRQtvNRXLTp6wgC72LPGbaz3jq51kYsnpF1i40Ij1HXCtx+1BQ8
	iOp4yEnKkXht77VNAz7pKJ1D3HxESRKNYb6P+GjgsLf6acf0sUrGbW2bDXSAjvtMY2VYC0
	+Cm+oLENcnnX1z+qYED55t6LX8sEAJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B20A96000A;
	Wed,  7 Jan 2026 19:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F10CC4CEF1;
	Wed,  7 Jan 2026 19:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767812735;
	bh=cXrxAzv98+rTuAo6AZR2IpL01l/GgbnBK6hzUkgo918=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=A4RHJTdVg2eo8w4IuucYp7SsRoCH3YT//hVw93Zkkrf5yuY7VdVHzXn5p17rzjL12
	 qFhnYO1sBxAF8pzvUHMpneAhxajxGMSSn/P5eWKV8DgEr+V8cC0I0it/mxBoIwnpzA
	 ZTG5e65Y87dMZvAKJQ5K5dt9Ppt1bkZCnEZg46y9U/FleUdZZwCi/IwOgRoSRZueGl
	 wWU3xb2cH5R7JKWBRu+isqhIrXzOJQiW5H8Z0OLzuYO0YHMw3moiytq6UZetkvnrs/
	 q+BCtxWtQqAd1Xg6v3hFI08liH2/hzx+9bPTHbu7bb9UT4hw/68aVlXtLjWeg5+mZk
	 TljZ3k+3lL8bg==
Date: Wed, 7 Jan 2026 13:05:34 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org, Jinhui Guo <guojinhui.liam@bytedance.com>
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <20260107190534.GA441483@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101221359.22298-2-frederic@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34202A0009
X-Stat-Signature: 5tzog8fffsgfaqngqt7hrkf3oe5jsdww
X-Rspam-User: 
X-HE-Tag: 1767812736-297163
X-HE-Meta: U2FsdGVkX1/R0dRByDfp4jgUiri2IsDtMAnOysEwqhdIafyKLBcHJvbhBJ727o9uFp4YJ30x/jLggEyGQTO2Rmyz9t+2aGdTNKaXfmzirK5CjA74fqhXU4RbgDwvcj045MmhiETEVRT7b/3UHTMIHnBSryl/Mh1ZEH5qa3GeVaPaNsB0SMgmy1prA0bIn3pd0IxftaWZRYTuex44AZ2wajkGr0r1KwykjdFzOh61ZspoExHCoiGt8ursAA/3g57FrsDDnGvrjv9XIXIR17wRvVnxQQ5BtvOGLh9YZ9I4Wjrt3HQGYEPaSWHProLkKZQ8qZx7u3V0zPjQSeisbX5rLS3xHCFYg4CNJ8ssfgOVlFq6qXCayEReCWtFg4YgCt9SReVeYVfoP1BMdtKgOvpNv1y5rZFkE0Nsqy4P52PqBomf9u1s3PKXoxz0AUrJiFJpFn606QodHv2jHqNTx3N09WZJ8yXPDKj+6Us+YYJbkQ+8FB7jj/feHHk4SV0LjFRkjfPXfhUVLI8teVznMRCzGTRzrs7+3xefa3IoOHyQx6TnOl6TE1cij+4i29tiqnTnpkM1wzqxMuTUNFpLyUNnv5/qnEztVA2XVsciitiqqWNhQtVDH59r3IiiF+grUCSUkLnYscgVof0yHbkWd9h4+zZ3V+seeLoyv+SIIwJI72qvRW/jbEZqsTXUftekCY3NY0b5dILxww9t5wSexjzpjZlqN3N6g8aGrgTufCft7aTL1K5Axe5j8nog2vfH4huuTujDpDh9lFa+I7034YDVF6ujaFfUfX/yo/EvWVLra6aMaNEHzSxb8RPAtiB/jIOdwDS/pwpEX6QmjLV3BPaFfEENGifB5deTtIl3+AwcNFjCqNZ3fy+mrHIcVnpk5tPSwhadXrnD2nEFr0lwx94Ab5oXyXLcHNyqUgpMgTxZ6zg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+cc Jinhui]

On Thu, Jan 01, 2026 at 11:13:26PM +0100, Frederic Weisbecker wrote:
> HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
> therefore be made modifiable at runtime. Synchronize against the cpumask
> update using RCU.
> 
> The RCU locked section includes both the housekeeping CPU target
> election for the PCI probe work and the work enqueue.
> 
> This way the housekeeping update side will simply need to flush the
> pending related works after updating the housekeeping mask in order to
> make sure that no PCI work ever executes on an isolated CPU. This part
> will be handled in a subsequent patch.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Just FYI, Jinhui posted a series that touches this same code and might
need some coordination:

  https://lore.kernel.org/r/20260107175548.1792-1-guojinhui.liam@bytedance.com

IIUC, Jinhui's series adds some more NUMA smarts in the driver core
sync probing path and removes corresponding NUMA code from the PCI
core probe path.

Bjorn

