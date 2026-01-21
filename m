Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392DBC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB036B00DA; Wed, 21 Jan 2026 12:06:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C28C6B00DE; Wed, 21 Jan 2026 12:06:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF9B6B00DF; Wed, 21 Jan 2026 12:06:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0FF6B00DA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:06:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12E5113BBFD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:06:14 +0000 (UTC)
X-FDA: 84356599068.21.7B067EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1ED9BC001B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:06:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YurHeLrj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769015172; a=rsa-sha256;
	cv=none;
	b=a18BhmsjDTAlIzegJhZgsurpRihWBMplnOOVce4uFUimCpoqiXb3sDnRUTcsCHREAW04ig
	gfa6+Ik2XxxAu1uvBLkKmlBYh8T9rV1EVgcQ33NN4Uy4U3V9MMS5If4mMo4PdfacMm4gYy
	0vzjRlQ5KxnXw2allGFGzKO3v/yj/s4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YurHeLrj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769015172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENCjiUyFyqKTfowkYdXmyJGMEeUb4ui0gjmTnlKiIkg=;
	b=Rcms2j104PBwgbfQdN5Cj7k9mQ3zzf5bgMs1zwPdVdSEw1kaq82vgE7SrYkjTWU/TebdkG
	sU62kOjM+RyOFUSoMCCAPbi9MqpQo8kKFRZN3EN5U4H+gR4FdqkBvCe8yaTAHy6gA9GWTg
	aYXrOkV0MosevAxglikcOqwB4qjZBNY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0271A43290;
	Wed, 21 Jan 2026 17:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A976C4CEF1;
	Wed, 21 Jan 2026 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769015170;
	bh=ida7uC1+IcLm3mH5OnwxhdYHy+GE2IR1NjNzomFuB9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YurHeLrj0Kc1Z0kXwWObFZEVHgWtGcldhLnc/9rTtIWDrfOF5OHZhBDWWdjOE+462
	 fvExXn7KnbYEhXpWGo0kukD1NpS4gyjv+Pr7pHR+Giv+UGDKpFQR4jiFII2JYw6KuB
	 7Y8ozd5liCmajIIf/Gyx/RwYNYOZ5mWwJctr8S8J+TzMEv3rCWxOO3RhAdYzLaQL+n
	 6gnoTvdwYhSMdpeIgae4LwcnvIuh1RGjcBa0Uwy7/qPLVdXh1CzAp+l96r9ZaxuEan
	 Q0gajJnqRVo0ClKW8SRy7uN+F5eE04OGnRK255rIs66OEyyWUFcE6wDDLeD0IN5rPp
	 vKuYKaTb2eaLg==
Date: Wed, 21 Jan 2026 18:06:07 +0100
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
Message-ID: <aXEHf5nbZMI8LT4b@localhost.localdomain>
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-30-frederic@kernel.org>
 <aW-cAlJCtI5Qtify@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aW-cAlJCtI5Qtify@willie-the-truck>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1ED9BC001B
X-Stat-Signature: e51jxwioh5xsin66h5nfzem9dz6yan6w
X-HE-Tag: 1769015171-353513
X-HE-Meta: U2FsdGVkX1+Ki/ks2jpseYqbu6svsszmxua1ikGmvDIQBz9u1wTKwH6nkblMzXl5YdZFSSwfPwhSPTO58ZnmYctH8bO/Uv1zh8gSNx6zxBVxRWvcT17niU7336Ts1cB8MUXt3sLxCVhZ7OVFLptZqPVl94KN4cDxC2bSRk4hNQ4v8o6A1d2J7SSTGZJv9IbxmUeARrbFJgXyQKhILysgNTMYLTv+KiVdDmisQxNhBA7CCIXtRPs7TcRy+lgZgkwB2I5pec6ezSpCX0dyvUXJFq9POaoXjkKrWHJ8nS0JC9007xkmptWeJKZeIitchDEfR2/X43QGIx/b3LznVgxE7/HFuf6mq+eXYq3dPNfk6q8LPatW9EJc9XcDG7vvvt1ONemtyIOS/XIs3Ixw66u4TFmfyA40AZ2VNQJm1VmODMbkoYUd88zHTbYG9RZCgnocbjf4Ooht/BtxUl7AHPmN8+cY4lfV2Bt15L6frOwufT2a0IayObmZMs6O4iBXV8wEa/Z4Hso8ERsIexB3Al/+CKRCppek7iGqAHlezQWKgaHSYgOUjcHyp2g8POPEOIRuf2+7k1j7EDMfCOG2iIAR3HK4HAyyW7mwwB4cZYHP1sHb4H8HMvMJTzzJV2xtDQRusb9c7dSv3vSVHZPnzbKbDEuw3+KkKpSzpXNjtpemcF7SpWxyCjRkTZ/b/tt1K0LNmTFQG299n+1Dl4MRdpn+29N1kR+vL+AorYNIYYjyA1BCFUlzuBoOYBj1MwWkmRRza7rGCSUhQz72roSIIecal3Q+LnqMn2eqHEielkzVaqYzcFsNkL04sFovgJtakBdHqiQFl5t/qVeGCa04M5q3hzkREGrlN4GGUwN8Id1+fgdQ5RsMQZZwP9DvEbYfzFlD4YzMylveLQb1jAAXWlBH/iMXVYFYnrAv7vtqFuXFQUb9B0jV/wn1C0PE7IlSLwclO80ykcBU0sb+GZKT1B2
 cysDd/VK
 5D06GzAU4FFgOAlOsdvorH0WZUOGfXZ2KAMLtqFv9WBhAOkvuiGt1UFge8sK9KKo2vzlcZdbxKl5LUH96WY3FjDBlnQxUYNdwHWtIirdMAcLnPnF1XRLVZ7UUo4M42NxZwhAUPR1V2KB0pu/9tkTL8dne4wiNxA+xUtvaSrGhXvEXI1UWdhu8pxC5Crmf8/lQclVG4VMTqLbQAfVtQkR+oArNxF+FMJ3FYYB5cKzi3GEiuBOHCvpWWnuUtNRmu//1vaKKaMYM0arv4EVKlPOfgXbKQdoGy7qaExMJI5toqDZSZY5M8uebhJsqs5Ih0olSbTzX4d8wHRxuP42qYo0+ibXGTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Jan 20, 2026 at 03:15:14PM +0000, Will Deacon a écrit :
> Hi Frederic,
> 
> On Thu, Jan 01, 2026 at 11:13:54PM +0100, Frederic Weisbecker wrote:
> > When none of the allowed CPUs of a task are online, it gets migrated
> > to the fallback cpumask which is all the non nohz_full CPUs.
> > 
> > However just like nohz_full CPUs, domain isolated CPUs don't want to be
> > disturbed by tasks that have lost their CPU affinities.
> > 
> > And since nohz_full rely on domain isolation to work correctly, the
> > housekeeping mask of domain isolated CPUs should always be a superset of
> > the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> > domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> > CPUs that are not domain isolated):
> > 
> > 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
> > 
> > Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> > tasks and since this cpumask can be modified at runtime, make sure
> > that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> > by cpusets.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > Reviewed-by: Waiman Long <longman@redhat.com>
> > ---
> >  arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
> >  include/linux/cpu.h            |  4 ++++
> >  kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
> >  3 files changed, 33 insertions(+), 6 deletions(-)
> 
> tbh, I'd also be fine just saying that isolation isn't reliable on these
> systems and then you don't need to add the extra arch hook.

Hmm, I think I heard about nohz_full usage on arm64 but I'm not sure.
And I usually expect isolcpus or cpuset isolated partitions to be even
more broadly used, it's lighter isolation with less constraints.

Anyway you're probably right that we could remove isolation support here
but I don't want to break any existing user.

> Whatever you prefer, but please can you update the text in
> Documentation/arch/arm64/asymmetric-32bit.rst to cover the interaction
> between the asymmetric stuff and cpu isolation?

I'll keep that path and update the documentation. I guess we can still
consider removing that support afterward. If we do so anyway, it would
deserve its own patchset and shouldn't be hidden in this pile.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

