Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED5FC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776756B0136; Thu, 22 Jan 2026 04:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728896B0137; Thu, 22 Jan 2026 04:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FD96B0138; Thu, 22 Jan 2026 04:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52F516B0136
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:56:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E02FBC0B36
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:56:42 +0000 (UTC)
X-FDA: 84359145444.01.E395D5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A644180005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:56:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hyxzfZGL;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769075801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hyn3QjrTtRTLodNMi1k9CKwpfN90X4xBtJ4HlPnOTY8=;
	b=RxD55yU+Kf8jfDxg/mrwAyE84OEKQ/XgrWoYfP3M06qsX099aPVOJglx3AOFPZd2j0tqDI
	0zMdHtQPyFSFqrUWS6HCNl2PmlOL8WWyjAMK0f8B994cCprgCA7l+UtraIzG8W4LWqaaWo
	LSC7cgIJkY4aw22m/kFNtyThj5jNdn0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hyxzfZGL;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769075801; a=rsa-sha256;
	cv=none;
	b=5gvNBRz3Nt4MrESWKE2U2OKWVuD5486FJ6RJXE5sPwe3sUQNZNOxBzoj6LEjfYAwLf+ivX
	3LN9p9mnOpBkceZ4j+ZNNCgr6pD1Sm2XN1akyi9h5E/WXnZ/fZG9F2btPjtjeu98THA3gQ
	1E0xRxefttMqfbyiT9nswOq5WeBgqd0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 045A743603;
	Thu, 22 Jan 2026 09:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C295C116C6;
	Thu, 22 Jan 2026 09:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769075799;
	bh=dcxoVFz6LVoWrvVHVZ3y55Q4k5TKYzriByuTAgV3hWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hyxzfZGLcbvHXsYMNZmY0TclxVsCDges/uNr7rTIWjU7dEvvZWpe3y8gLjHiYPb4P
	 gQ8LoHdGdjymvWkmBREjtD/TG+AEf+cNOi5i4o70izpt1KJpjylatpowbVYkbk7pcP
	 CYG9UP7rOsgwnKAYwORRJM/imqq2YlfQqXjjGRf+llG3fqyyNKe9qA6NTgQgEwPWK+
	 4+DoR3K0+SIxnm4RP+gCIp20fsGJqFTdW3y9d/2ZeCn3W21XRuLsQe7Cps94/KFLsY
	 n7FdKC9l8vf+Jalgv6nJj7/fkB0Dp2sCnCpXPIvgQZsI0TX7LhQzCf/hGB0UgxDjcv
	 PJXfg+UrhfKbw==
Date: Thu, 22 Jan 2026 09:56:29 +0000
From: Will Deacon <will@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
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
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 29/33] sched/arm64: Move fallback task cpumask to
 HK_TYPE_DOMAIN
Message-ID: <aXH0TZU7UNowTmwc@willie-the-truck>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-30-frederic@kernel.org>
 <aW-cAlJCtI5Qtify@willie-the-truck>
 <aXEHf5nbZMI8LT4b@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXEHf5nbZMI8LT4b@localhost.localdomain>
X-Stat-Signature: 7yrakqiqfitc9cdeyx1u6ujzbks8qtgk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A644180005
X-HE-Tag: 1769075800-339991
X-HE-Meta: U2FsdGVkX19xSwmB8ZyY5tzT9Iy0FbqH9cX/GoHyHB+QOaXT/sFLQD2cTJ8r7EK/Gh2JgDcbKLFXVBZl7cBfkaAITZTTEdOElQDwxaVwpl6Y5RP68YcYZatrWt7L4Svp5oZEDDqUC3ZP2GLA5FOndEWvVNPg/2I+3+kf+w1MSWYT7XwwZJ643sJk/Gx7c2K3YvAyUT7/AfN8RTvcdSuoLHrCrXb0BVgdfCvIcMgA4xsDG64YDSBMPu2ckJsprwXVlqcKZfOZv4PDTBh69uEbU1NCf5vPjdapH2Pr1qfd+4+RlwjvJs6QlsVTbis1BCna3wCrbXmAaEJR4exRRkUgLoCVDryhtkj6vCPsVs0+YYL22uyDiGqWqwFABZTF2rZJJhIlnjt7sRZ4sE/BAvvutXu7TUfblWCHDVy6KMFFmgOaufXNz5apcgpIAoF8yxhuKrgWQjQMhg/BLmWs9DZZXzPLKJdJPyTyvZpa2upCBoB0/Dcd7p4/Ul/meISIV0U+XIFRPUJQbiPCzT6QZs/qyFMSY3QB2aemxb3QtPZ9VZjPTssEJEdX78oUDIZHq7/SbgQtV/usn3QpwSNirp+ncmJEFjiMvaGWadVpll8Cq9Wlu03GeQlEWaRcCPwQlqYVSy6pxVk8NPGTGCR8tJF5tZ5gVv9NRSOXBfLPVNYiM4ZXYVToJVctfNBYdcjxjIKMAzrNrtVtmHZUZtD1JTNwebbsNUjoMcs/1h1BvilVdwH0l6XGwSu2RdukqCdIOj64uScxw+z/+xdc8L078w6vBawhhYhq93kzNi9r13x376eNOF2pmH4CCmVHyz5a/LakS/NVxsEpZI8LyudrUlYy1f4ioW0yfm5rxjGLvSqSqWdlUI9p863ZotRh25v1sMYySPEjmgeNcmU42tPXOYzuBdtTF7gGaGMYKUwuBuB4W3e7t2wgdv75/7h4gSaif/gX0d4sFeqE0YjfPLK76GH
 Y3hLQJ8H
 9gXB9ydlKYnM0BVIqbEFhCzI2KRdmqZfOG9pnTnxLEt8/c3cw1kRwaXmIXWltHYqf8ZTGbldMdWmqbUlD/Em3bDyGbJ/ajNBETZDf9jO+VJnfI6lXY9b4y+SjzgdrQwKf2Py25kMzoL39RZ8l/Yq3JQypcMagxntVLkKRU1aYS1T8aShAUK6uBuCS7+s2aV4Bxeq/DlyDkuFVfNSwPYfsZOJRBn0/dnDT4rnTfAFr8WDVAv2Cx2p1fIz6adYgLPrmbdsHMnTbPw1La/TnL2ZJJtreZmPd3IAMvc4EetVntIfEIDC7PT1Uw6xLWpe93V/doRavj0YOUYqV3tsBIj1rr4RP8MJRcksn4Fu/EEYbIXLeCpbTByVKCELhKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 06:06:07PM +0100, Frederic Weisbecker wrote:
> Le Tue, Jan 20, 2026 at 03:15:14PM +0000, Will Deacon a écrit :
> > Hi Frederic,
> > 
> > On Thu, Jan 01, 2026 at 11:13:54PM +0100, Frederic Weisbecker wrote:
> > > When none of the allowed CPUs of a task are online, it gets migrated
> > > to the fallback cpumask which is all the non nohz_full CPUs.
> > > 
> > > However just like nohz_full CPUs, domain isolated CPUs don't want to be
> > > disturbed by tasks that have lost their CPU affinities.
> > > 
> > > And since nohz_full rely on domain isolation to work correctly, the
> > > housekeeping mask of domain isolated CPUs should always be a superset of
> > > the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> > > domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> > > CPUs that are not domain isolated):
> > > 
> > > 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> > > 
> > > Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> > > tasks and since this cpumask can be modified at runtime, make sure
> > > that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> > > by cpusets.
> > > 
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > Reviewed-by: Waiman Long <longman@redhat.com>
> > > ---
> > >  arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
> > >  include/linux/cpu.h            |  4 ++++
> > >  kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
> > >  3 files changed, 33 insertions(+), 6 deletions(-)
> > 
> > tbh, I'd also be fine just saying that isolation isn't reliable on these
> > systems and then you don't need to add the extra arch hook.
> 
> Hmm, I think I heard about nohz_full usage on arm64 but I'm not sure.
> And I usually expect isolcpus or cpuset isolated partitions to be even
> more broadly used, it's lighter isolation with less constraints.
> 
> Anyway you're probably right that we could remove isolation support here
> but I don't want to break any existing user.

fwiw, I think it's only some Android markets using the mismatched 32-bit
support and we're definitely not using nohz_full there.

Will

