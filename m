Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B03C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC98A6B014F; Thu, 22 Jan 2026 06:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D7E6B0151; Thu, 22 Jan 2026 06:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD616B0152; Thu, 22 Jan 2026 06:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEEE6B014F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:29:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E1F6C157B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:29:23 +0000 (UTC)
X-FDA: 84359379006.19.78629E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6C5611A000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:29:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hntVHlxv;
	spf=pass (imf19.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769081361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTL/05y6Ck5Yf8IOljFlpo5NyFkh9H05oH3KXfdhA3k=;
	b=KysUK/4/JLaFz1kp2qYpeMfrJOnorQ6caFWNBn8m0r/GLLZeTb7riqy5ZT7vRcHRy7xjsm
	V13zfXQy2qXqdg74J3sJY0zVuw9JIEMbUZAgXKJ3bpHL/lsB196oniHP2RLnSJhiXI9kpD
	1BiQJRaZlDrbm+HjWou2Ny6WAaMUCLk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hntVHlxv;
	spf=pass (imf19.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769081361; a=rsa-sha256;
	cv=none;
	b=MTBu0taWsD/uNYt+KccE/RMG8MBoxYDEAEKJSvpYF41I26LtlKAGjj/GFuGlhM0fYcefyz
	rKkgTaDV2cr96J/7UUbzdzyFMVKgJHV2WAywPCHPcPpBrxPahCk3S3qQ7qIbhkRFC75KuV
	+1VNH+HdO0/hWu4oSQNn3R4+Jr0TgEE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7164043E60;
	Thu, 22 Jan 2026 11:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAA5C116C6;
	Thu, 22 Jan 2026 11:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769081360;
	bh=WiogiOmlVrEBDmxiYq5jKojVlIXsrZ6n9wcQdU9VhMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hntVHlxvRLtZcEpsFecgcuy2/WeJl9lYH2mWE9f8dZGjyucvG1zCLlgF1anVNM8Mq
	 ATZwc6IftbgZO2kJLtftNKhMvBjvPvqfUNlH6JrZwPiiiEXtxPJi1HRA+GVlhwH0Xl
	 7jI4hCzwdhtpWuORobWzm0YF5J1jsS7gh1CwOGDB5EOeJZKzxHCuCd4SkLrzE/tlGq
	 JVFBs8UA8NYTjNB18RHp1AShNa5zdE3qLITZrz7qt2dsO/+/eP32L9P7IpEILF4h3H
	 3+SL3O++ddzf33ljYPKdsDd6l1rT8hde2RP+XyHB6xkPeaAyuWp9p0Q+aK9fItrNc6
	 XJd/YpjN6/DQQ==
Date: Thu, 22 Jan 2026 12:29:17 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Will Deacon <will@kernel.org>
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
Message-ID: <aXIKDduX5qUXvOUX@localhost.localdomain>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-30-frederic@kernel.org>
 <aW-cAlJCtI5Qtify@willie-the-truck>
 <aXEHf5nbZMI8LT4b@localhost.localdomain>
 <aXH0TZU7UNowTmwc@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXH0TZU7UNowTmwc@willie-the-truck>
X-Stat-Signature: 8udd8mx6we1974odesdmcxsxi9ikhsx7
X-Rspamd-Queue-Id: 6C5611A000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769081361-674346
X-HE-Meta: U2FsdGVkX19R271okLq/hNqZ/sMH8VFKSjHZKpQFbESwipkAlYqmUE1IijkiC16AJhFMH6d/0G5Azi5hDu+kphn2cY00BPIqOzxYIJLOkN+x0fBhfZeQZsuzFsSvEhwXa5R1kEu5wXFqR8gRoWdUFS8Ba07jHfkCUDqYOms+y0iAXWdGe7PXXZ9fZoqkBcGacBZSTQwd6tZQsBwCBfHlzUS0hk4lodI1G5NyBSqXaw3NBnatVXVSBft2Z4uasBFYki5A79rOf1/DzXbk7NGUlLUFIvOJ6MRd/odhmVEg0ejmEurr/52YobdcPR+9SUUQCOaj/Hs9lxWC1pLRylWkCBJsnBxHmjSR+imidTTCIzMyWnBRuqmhqvp93xi2sW8SOu6XAKp9f1kk4mvr96cIGcULnVvWDryG8ZbjOmNgiJI0OpZIZgyr3IaXYHrf5jw6O0+9xlJqK5M+cpH1l5+2NE/QUav6AoCMi0LjA7jU5dlWo3FXguaV5p668Fb60F5jmocZblycwGs9rA58H+qSGD+H1X6VFsv/bWQNeCewvbgIwviMuV47PkfntOuKb7GuEUNoQudSbL/03urNqcY8bl4VO4JoEoYuvDyc8eNiKCreMQb/vSiYAhGThUZusYzyzLWwsQqoyvX8UU7THuqjSisgT0X3/m/eVUFd9VIxbiEBKs/dQr/9drw1bAxLJgDBx+9lCd4j0/MKALriYVa/Nd4FCrDyT+2WMx1H7HFzWPd/SrTtTg4N0hTLbufYM5IjUpRmjz47YNe1+3EeoV/8DZ1KW79yYPNWd+dyTgHVQayzHua4YFeOC9gam33fL4jLRr52Os5eDMTdSt9ixnL2p2hahAxdCTnKGkLtzo/mi5r5UXrcgR9ZSel9hx3L8/FnzpumIrTQLdlghUId3mQgl6AL84/kJdUVA5wfgzbewaFmJabVJSR1NgSaHrSb8IRcb2pnGYfG6YteU9x8Pbn
 O522ms1q
 cXUVPaP8cag4XcFvfR0S2HG1f+FtCoJDERFhBjYe0CR6Ar5a3/P9UfJy5PRNh31/LnlupJnlEkvYQvru/hR/yB2HHS8C2t+CL1JwuNrL85HvQDuU8fMK2AvfiDScE8/bydysrT3HriM+LEW/3MRus/ZEwbCRDD7Sz6Y/y+sD5U50G4AeBUM8lM6aP/9/rthaBnZz1i2vlUBQJodi4elUkUtRGNuizWDF4dcH8Zd6pTuASPicQGwpCMVpu/U9cb2VVnxWolwrUxiiJ5kDavb0NG9ggFSHQ0oQ/WkRmIrVe1s8Qid1Kk13OBdSO3m+7+Ig0D/ioSJ3kTvUJxQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Thu, Jan 22, 2026 at 09:56:29AM +0000, Will Deacon a écrit :
> On Wed, Jan 21, 2026 at 06:06:07PM +0100, Frederic Weisbecker wrote:
> > Le Tue, Jan 20, 2026 at 03:15:14PM +0000, Will Deacon a écrit :
> > > Hi Frederic,
> > > 
> > > On Thu, Jan 01, 2026 at 11:13:54PM +0100, Frederic Weisbecker wrote:
> > > > When none of the allowed CPUs of a task are online, it gets migrated
> > > > to the fallback cpumask which is all the non nohz_full CPUs.
> > > > 
> > > > However just like nohz_full CPUs, domain isolated CPUs don't want to be
> > > > disturbed by tasks that have lost their CPU affinities.
> > > > 
> > > > And since nohz_full rely on domain isolation to work correctly, the
> > > > housekeeping mask of domain isolated CPUs should always be a superset of
> > > > the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> > > > domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> > > > CPUs that are not domain isolated):
> > > > 
> > > > 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> > > > 
> > > > Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> > > > tasks and since this cpumask can be modified at runtime, make sure
> > > > that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> > > > by cpusets.
> > > > 
> > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > Reviewed-by: Waiman Long <longman@redhat.com>
> > > > ---
> > > >  arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
> > > >  include/linux/cpu.h            |  4 ++++
> > > >  kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
> > > >  3 files changed, 33 insertions(+), 6 deletions(-)
> > > 
> > > tbh, I'd also be fine just saying that isolation isn't reliable on these
> > > systems and then you don't need to add the extra arch hook.
> > 
> > Hmm, I think I heard about nohz_full usage on arm64 but I'm not sure.
> > And I usually expect isolcpus or cpuset isolated partitions to be even
> > more broadly used, it's lighter isolation with less constraints.
> > 
> > Anyway you're probably right that we could remove isolation support here
> > but I don't want to break any existing user.
> 
> fwiw, I think it's only some Android markets using the mismatched 32-bit
> support and we're definitely not using nohz_full there.

Now that removal becomes appealing. And what about isolcpus= / isolated cpuset
which only consist in scheduler domain isolation? Probably not used by android
either.

Ok but is there a way to detect on early boot that the system has mismatched
32 bits support? Because I need to fail nohz_full= and isolcpus= boot parameters
early on top of this information without waiting for secondary CPUs boot.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

