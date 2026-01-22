Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A14C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11656B0158; Thu, 22 Jan 2026 06:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9486B015A; Thu, 22 Jan 2026 06:36:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15C86B015B; Thu, 22 Jan 2026 06:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCC976B0158
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:36:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57D638AF71
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:36:34 +0000 (UTC)
X-FDA: 84359397108.01.29B5CCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B5CBC8000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:36:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZDryn4r3;
	spf=pass (imf02.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769081792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTFmffWcUZMiXbLCD1+D1ZWQQg5xf8H7xFg9wcW8zuo=;
	b=bQHapINEpIX2zx4Lt3wrrVKheUzDlSAGZEnWv2Q0gbY4ipdjOvIohpeWyLXq8j2aRCA8jz
	64yqR04VaRWn2Wsp3tDBauEXRyfvRM/jtM2w8ZPoKy0EApD7vXWg+K92lc7VZ2hg0z9Sqz
	1zlADRlOA8QK+bYiB8A4D9zGBpDefcw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZDryn4r3;
	spf=pass (imf02.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769081792; a=rsa-sha256;
	cv=none;
	b=neaxoP74y1aIlx3vJb0klhxNGo+M1JQlpsxFbU1QAMP9AFqKR75qcIU+csVkevMZHu1rqC
	wyPuGHZ5TSmcFmHesLIuF+wNJgE/5a3qxO2ewqufobtEkh0kM7kfahDGI/gTVUg4/C1pmn
	mh3V4GL7F7oDVrSOUK5DjnoQlIb8MDE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7CF5600CB;
	Thu, 22 Jan 2026 11:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A76CC116C6;
	Thu, 22 Jan 2026 11:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769081791;
	bh=ENaX1Ni1MjEYqWK5DUAycRHraRvMcIc+oNSelx9/l2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZDryn4r3pVEndSSCPyKyGmEaA5BTct8VAHmY8jYwQGX6bZIuzGBK2tyiehlMSViCM
	 Ei7gUubm2NpO0vLH1gLLEG7shYisa/qu58z1kPKCeHT7psSLc0dFIUNS20igfaqR8y
	 H0JYR5Y3GLo2UHCzTKrQTDQA5CIsBsQX04/nfiZiuS1HDLzqsOcDFUUSDSixFNi2cA
	 bcka/tqaxHdr2hWnQ1CWDAu9Vo3BBVN03Rl8iRMbmoAtVSYCecBSZ7PNzldFeiHaHe
	 bmQniStX0qxItibPa8e+b/txibvQDRMzP6YVhz2gBqk8YlXoX44FzT/wg3EmzCppge
	 Qf8lkGFsAGPRA==
Date: Thu, 22 Jan 2026 11:36:21 +0000
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
Message-ID: <aXILtazyRtpb3Yjy@willie-the-truck>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-30-frederic@kernel.org>
 <aW-cAlJCtI5Qtify@willie-the-truck>
 <aXEHf5nbZMI8LT4b@localhost.localdomain>
 <aXH0TZU7UNowTmwc@willie-the-truck>
 <aXIKDduX5qUXvOUX@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXIKDduX5qUXvOUX@localhost.localdomain>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B5CBC8000D
X-Stat-Signature: 6f6gbehmw455f6xdj3qn9kjf37mqfg49
X-Rspam-User: 
X-HE-Tag: 1769081792-534405
X-HE-Meta: U2FsdGVkX19/usW4D5lJBIZxEme9vPWXetSsGgJAZ6yXHSeMqwATbQBtu3KiGjtctzU28wIH4nbn43kiG4CoiJgIwdrhEHZOtaMuI0LBa6Ep8pyUjBrl2M7qi13oWYbXqbaHAH4CV+cTwvCsbYbp73eeAJDrT/B7+gZkDm2gTE4OdDvX7SiNFKHiQ3lXrb6IZM/4lTVB/YfjXp6stg6F2jobY16OkqRxL9/aune1maRw0THo9WyMwQmUyNqX0MmZEy+RGxDaAAITdQzYowRnrd+vKerbi2u5LSkavR4O2YFZvuB9jSUWKWhB41q0zkT0boJt3F04xT9wyxg6qr82d49AlDtyUd0LILF2KYodGk1/wn0m4AGgug0diq9EA37JV3KjolzsdeyN2zJEyWi895QlcoiwHH5vLjBJzV6blxpjd/LYHdBBK97Q0IPPJkrQevm5K+iRh85LQME/SNR5fpEyPdVzlAiX2VNfPjT9bR+QJYGTMp7aHJBvB09+yTYUYRDvK3Mnj/i8MH3jwT46MT4pQq3ADmY1QXqlVYUJKgWj7I/9ghnObN3X/2XwCg9CETzOHAPnetpu6jJ0PI7JOkpp/tv7R+g+s3vwqCObQr7uSvSC11Ua5mypUzgbSYrLuRD50CPnsNXJKszDvRtUeR5YjLt8lhzGVeaKjKOk6pNOuCtVB0m0MylpCs0kTiJyzj+JHmugKIR0D7K4B/mx6Rq3Bu/qZQLFVO5zoNcXlAQSAxZsvOLDyD7/TS9rDvO3iBXT4s1thmJAJBEw4lqJHGVP51Ql/GEKADsFeGad7m/8gcC5kgqi1xIYIFZDIaFBNMhLPleU5rEcKW1qNWeqPpGTOUP1bP47XS3Q1ZyZw+7Xiee2y4Eq/UZI3Y9zI/hXSnjnI+rbxxY74J4EpXPZsug3WSL8yi2CQnuipRQ313i8dPFe1AAs2s39j9cGVzC54IyKj3cwTbtrgDCOZui
 a+73Pfyv
 1xRTuHGRPRjDpMsjc64l0Tw/D8DeseAeCdvkaBRsVinC795C5uv7k6cfIISpc/hFwcPs16csisMzU9Mcpq7+xFcybeQfjv+rvjldzHC2f0fLnZFlevJm1qxpOVU01xhBpkyLKTBxJmk72gTJ6mgbvJ890v2/Tdu/9tfZIlWKzaD/4D5JOeSxotJ33Wx8p0R5shhGqP7avmgTXXHZubhydOgTtlrcd2EHQgvrl50kdXhgHre43NRtC57fH7Izj6EqGT4wA7gu16tzXlJJ3QCJhs1CNsUdIQkBqUM6Bxc+FGR3iUvgkkXU4HNxlMNPP7KR9MxS25gDtfQpzKVjbXCnm9RDcQiq6d7ZJki3tlhIWzcVE35hTj7fHK3KwiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 12:29:17PM +0100, Frederic Weisbecker wrote:
> Le Thu, Jan 22, 2026 at 09:56:29AM +0000, Will Deacon a écrit :
> > On Wed, Jan 21, 2026 at 06:06:07PM +0100, Frederic Weisbecker wrote:
> > > Le Tue, Jan 20, 2026 at 03:15:14PM +0000, Will Deacon a écrit :
> > > > Hi Frederic,
> > > > 
> > > > On Thu, Jan 01, 2026 at 11:13:54PM +0100, Frederic Weisbecker wrote:
> > > > > When none of the allowed CPUs of a task are online, it gets migrated
> > > > > to the fallback cpumask which is all the non nohz_full CPUs.
> > > > > 
> > > > > However just like nohz_full CPUs, domain isolated CPUs don't want to be
> > > > > disturbed by tasks that have lost their CPU affinities.
> > > > > 
> > > > > And since nohz_full rely on domain isolation to work correctly, the
> > > > > housekeeping mask of domain isolated CPUs should always be a superset of
> > > > > the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> > > > > domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> > > > > CPUs that are not domain isolated):
> > > > > 
> > > > > 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> > > > > 
> > > > > Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> > > > > tasks and since this cpumask can be modified at runtime, make sure
> > > > > that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> > > > > by cpusets.
> > > > > 
> > > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > > Reviewed-by: Waiman Long <longman@redhat.com>
> > > > > ---
> > > > >  arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
> > > > >  include/linux/cpu.h            |  4 ++++
> > > > >  kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
> > > > >  3 files changed, 33 insertions(+), 6 deletions(-)
> > > > 
> > > > tbh, I'd also be fine just saying that isolation isn't reliable on these
> > > > systems and then you don't need to add the extra arch hook.
> > > 
> > > Hmm, I think I heard about nohz_full usage on arm64 but I'm not sure.
> > > And I usually expect isolcpus or cpuset isolated partitions to be even
> > > more broadly used, it's lighter isolation with less constraints.
> > > 
> > > Anyway you're probably right that we could remove isolation support here
> > > but I don't want to break any existing user.
> > 
> > fwiw, I think it's only some Android markets using the mismatched 32-bit
> > support and we're definitely not using nohz_full there.
> 
> Now that removal becomes appealing. And what about isolcpus= / isolated cpuset
> which only consist in scheduler domain isolation? Probably not used by android
> either.
> 
> Ok but is there a way to detect on early boot that the system has mismatched
> 32 bits support? Because I need to fail nohz_full= and isolcpus= boot parameters
> early on top of this information without waiting for secondary CPUs boot.

Honestly, I'm not sure I'd bother trying to be smart here. Even if the
system has enabled support for mismatched 32-bit CPUs, things should
still work properly with nohz_full/isolcpus if all the tasks are 64-bit,
right?

In which case, I'd just document whatever weird behaviour you get if
somebody throws 32-bit tasks into the mix. Adding hooks to the generic
code for this use-case just seems like a waste, as they're not going to
be used in practice and it increases the maintenance burden.

Will

