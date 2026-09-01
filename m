Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55DB3C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2046B0088; Tue,  1 Sep 2026 16:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4306B008A; Tue,  1 Sep 2026 16:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C08C6B008C; Tue,  1 Sep 2026 16:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB2EE6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:40:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 693701A0536
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:40:58 +0000 (UTC)
X-FDA: 85166362596.12.C983EDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 93DAC40005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:40:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jsffA4pM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of "SRS0=1F1W=GZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=1F1W=GZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788295256;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTqSBy/5+AkfT27Mcm6NsSAgir8oHYfp952cjXDCZTU=;
	b=pl5SBfTrAFEEmLZVzXNcrHft8jWJOzdQMA3F5v+SAGCyMBJ2SYgd2XDB0fcXtCum5IL6Es
	2PrC3OCJqrkdMuqAyleKpXJIcn2LAayncIwmGQyvFb+zHls1v3QNzNsZ8Zzrp8ZuHPYk95
	Bt9sIymdHSDBZVO6G3hu1BoRVelpuv4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jsffA4pM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of "SRS0=1F1W=GZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=1F1W=GZ=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788295256;
	b=Ow0gKtUwqfmfI4oSh8EHmH4KxqflKxuVCwouRD15YzX0E5rIQvWooTCb7iC8yGPdPEfV+a
	E71JRF/DCMA7s/l9yA4wXQNcxKN3v/lLDkP7fuJJtfV9mJ69Wm7Ti89oEsh30uK9HM6RRn
	kxLpBDAMA8eALEuTqFPqpCpSCuFQBno=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9784843D3E;
	Tue,  1 Sep 2026 20:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DB81F000E9;
	Tue,  1 Sep 2026 20:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788295255;
	bh=lTqSBy/5+AkfT27Mcm6NsSAgir8oHYfp952cjXDCZTU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=jsffA4pMJhRjvS+g0egMuEshBL2lvsMIMlk8cDQlWP8HCF8035Klp6vh3M2m2dJ1i
	 xmJZSXW3Zg91S5Jucfq9H4vQV1ciIvBB0gJKxWpx0SEVk4Wtkd0nNjFM5uF6joIhMy
	 Hzn5dVmEA/U9V3pQVbVwPoez7qyRjZUyWH6JMAI9sCCIq2hTR8V1x482isg6bT3Lnx
	 EF7NZQ4bY1yWu5q2IwQ742r2e/a0h3L+YOlnQJfZx8JVWeHRmNQnZqaSpFU75oR5Zy
	 KMaAfJAjYBtLHN7I2+D8HE0NZgwB3DDBbICLUPO6Zwsf+sgsumwXhxYObqk/QcEhvz
	 7BcKAAQvmXxcw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 4098ACE0ABD; Tue,  1 Sep 2026 13:40:55 -0700 (PDT)
Date: Tue, 1 Sep 2026 13:40:55 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Jerome Glisse <jglisse@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <e3197a0a-e167-4ea1-bbde-9c7f11f42198@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
 <c39bda52f4c1573193aed39246f0d705755143fe.camel@infradead.org>
 <90d91673-a912-439f-98ee-e43285294486@paulmck-laptop>
 <8cd4aa65b1b499d4c614aa4cba445b6aeb89acf7.camel@infradead.org>
 <apcjs83XSU4Eb9hm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apcjs83XSU4Eb9hm@google.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 84jpynxbtde79oxnry6moj3btfpfzk71
X-Rspamd-Queue-Id: 93DAC40005
X-HE-Tag: 1788295256-764736
X-HE-Meta: U2FsdGVkX1+G7DZGZOcU0sQU+XxPX7SZt6xaUxozXBqZa0IO6r/Aq9LwakOBGjy77o06NIaTqK/HGdw+CpZL+yZ0cM40iwaxKzsSH1bgzhufZtHg4wPL8muduYEQOCHKEkeZZwerwsvF21yeFq65meTvTIGhBUXY3MfPsuT1moT6k5LkpKQNnBO7Xd2TPxtAZSofmDBFm3eygZRCpa2Sbiq0NVn+7cqM6P5T9PY607k4Ph/ePJKRawZnVnGKEAFI2Mor58UXcMC5ZT4gVuHX4xz4FaERDlstniu5hCQFycH5dr2w+R4+a8xpkx0C/ne7VCjE5B/hW2dK80W6qy3hBYCNkc3T9oNbl5+a3vZMOmRJH6Cr59FfAOiSXx5SOO/C7980+j8MwUVwpLelnaNXafRMMg3XBQZyq12pEveoc/vxadQdNwTyRVK5OCGcBJe5pwBHPIp2D9b3KN2YR6P6zR+YpjLEVFwJKS9oK91LWCx9lkzBhcDG1CQSBnyCeQD4ktQ8bS+pkZuLm0MIaOK0j+ETj/laYncLvl2mGKE7IQU4YcOc+j0vfF17tjIrcieJQXxhfgWKjFpVxdeNqzwqI3rSQ2ZkgN/iTq5CFuM0aQT41VoCri/WxEsmWgmlAj5R1CjGbqFHM87w7Bb2zvrlUJD3348Qhtqw+734ho6utyoFsOM4AX4rbvFBWWboF4SDxDfgryg4ZPNJHOyRaIKgZirzzvqwwR0qH3TwDAV07IveLKkMefSv0KaV9RZQVSXnZleIMk7Yk6zL7X5b3M3SwXT2Zi2EiSFFpjAFE1JpjwW7kEr1mhCUa1Lr0YN/UhY9Cl9/tFQnIWTSG4oPP/JjdbrpeN9SE7dokyi7V7uNjDZK+pnnxXmvFlck041S5cbl9PI3EFy+49DXKMLql5IZY2PUFxLRZNgEstqbz48JZuIKRQGF4DY9TzFl1fvukyFmdPgr1KgoifER259Op43
 AbPtenaU
 hchHH68fWMKFIfNfoASnz1cyWlc+r7sJhJKV3qGNQSwj3mw5eI6bX97ZLNfFNPOndpTj2fjF5mC94YUvZmrrP8u8qYzIP+CfA4Ll++plnaxziApAO3QcVVrW/o0ErbmrPoAb+NgJy2FFFxLsfyAQc98tSQgzA5J3dDti/e+BAXy4ZF2Gly7CHqGiUwMny4X58U1sH5DXlSJGYZWIKWFieb5KUfHlPEjpj2J88HX+hg1KwqJrc9LnWoF7uoO0n/z1sdr5ru5sR+5aRoOr567N0BjZVqbLTxq/GCvUKqvI1xrK3cWuh+wYdWLMrpYNDjHvKM9/BiL20b9kXJBAnenjZJGvFnPqrWhn75a+gk3ikW9SGjtR1jgl4HF6JlefseFW5Jn2yYVZ0Ngg9hRjIuG3RvgoZHCN4V4x5MOEXLwgbW1S0IgSuhGr+qTSByGRaT9NVCixcZoANYFSIUAN75I53FSI80aYlX8xIosptwHX1QzgyrbRkD66pzV1d+k3gV03Rblu+Hnu7L4owMXXamlJP44bju5VaSqtdKwf31F7Hd4ioNYg/J/nRguislMJmjWMB/3++PKCw31jamd3mrbULkf4/PEwXsxqI4Dij4kuc1OIpUuJfln7qv4XhUfo1pRIg9IjqzDzWLwTZ9Px3M5IwLcHLDPLwXi/WjS+AkWhBDdVGyF3Orr/mcnFatrxghDEZJ/uP+T8CuW3qcgVUsV38/yYgL9blg1cTbIsaGbrVFPhXKQQzsVD+64X9eTljByuCkSHqsenjrmNeT6r9/cP1/sDGvBtlIFxValhs9RTvD74eNmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 12:12:51PM -0700, Sean Christopherson wrote:
> On Tue, Sep 01, 2026, David Woodhouse wrote:
> > On Mon, 2026-08-31 at 17:58 -0700, Paul E. McKenney wrote:
> > > On Fri, Aug 28, 2026 at 12:25:01AM +0100, David Woodhouse wrote:
> > > 
> > > 
> > > >   * 23f10e07aba3 srcu: Add try_synchronize_srcu() for callers which can prove readers absent
> > > 
> > > I do not intend to provide a separate API for this given the possibility
> > > of indefinite postponement.
> > 
> > Makes sense. In that case, calling it internally from the 'right'
> > places becomes important, as the callers who care can't do so for
> > themselves.
> > 
> > We discussed the fact that synchronize_srcu_expedited() will also want
> > to use the same fast path.
> > 
> > I'm also looking back to Sean's call_srcu_expedited() patch from March:
> > https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.com/
> > 
> > 
> > | Due to differences in how VMMs manage guest devices, and in the
> > | architecture being emulated by userspace, some updates trigger call_srcu()
> > | with concurrent readers (i.e. while the VM is active), while others occur
> > | without readers, e.g. when configuring devices during a pre-boot setup.
> > | For the later case (no concurrent readers), using the vanilla call_srcu()
> > | is problematic, as it can kick off a normal grace period (totally fine for
> > | freeing the object) and effectively transfer the non-expedited grace period
> > | to the upcoming synchronize_srcu_expedited().
> > 
> > So the offending path uses call_srcu() and triggers a normal GP, while
> > the victim calls synchronize_srcu_expedited() and gets stuck behind
> > that non-expedited GP.
> > 
> > Sean, if the victim is the "no concurrent readers" code path, as you
> > said above, do you think the fast path in the victim should suffice,
> > without the cost of an expedited GP for every bus registration?
> 
> IIUC, you're asking if being able to use try_synchronize_srcu() for the fast/happy
> of synchronize_srcu_expedited() (i.e. for kvm_swap_active_memslots()()), even if
> there's an in-flight GP, would suffice for a fix of the regression introduced by
> commit 7d9a0273c459 ("KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()").
> 
> If my understanding is correct, then yes, that should work, and presumably would
> be a notable improvement overall.

Then we could abandon synchronize_rcu_atomic()?  That would not be a
bad thing from my perspective.

Just to be sure, please note that synchronize_rcu_expedited() can and
sometimes does sleep in order to avoid odd corner cases that could
otherwise pointlessly monopolize a CPU.

							Thanx, Paul

