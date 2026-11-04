Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF91606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+JjsJAY
Received: by kanga.kvack.org (Postfix)
	id 3DF6F6B00EF; Wed,  4 Nov 2026 07:31:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6DF6B05B1; Wed,  4 Nov 2026 07:31:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE376B05B4; Wed,  4 Nov 2026 07:31:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 055DB6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:31:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59E931205D3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:31:40 +0000 (UTC)
X-FDA: 85397372760.07.9393CAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC1994000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:31:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+JjsJAY;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793795498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7N3s/Fk0FC0DIJXDd2TXVzu86yiov/bVF/UpU5EDxA=;
	b=Fpkyz8t/EJTSh/dsk4MPJUZTT49BEnEqQOJ7hlUeO2i20kgHgrCN/KB2nnhP/97nwji5Ss
	EN0YkOokSfrqyG5acS9mZaop4FDI8KgcA7Tyr/UDRjU/L4I26MtOq0vYpaUzS681FJMFkY
	xfHESvILBQNkq9OMBkOF/dxfyjtTZyI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793795498;
	b=vMmsge3p05yC+46HUH3OP37jiJgz7zNc6W45yjcs1ZZObO0GgWZytbBdrxr6IrFOIMbPD9
	ON0SNTVZ6TfjS2pvCn1J3+j9xLGJ3j1K8aktKs81npylfNtpiyAiiKQG89eJPZXOrYH2KY
	nNP8pv+m0sbX8C8Lj1ZQFGQN1xuEHQs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+JjsJAY;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B35060F32;
	Wed,  4 Nov 2026 12:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9431F000C1;
	Wed,  4 Nov 2026 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793795498;
	bh=d7N3s/Fk0FC0DIJXDd2TXVzu86yiov/bVF/UpU5EDxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j+JjsJAYkPpZEw11dLp/jNcSe2cW7ZtaW501/o17Jebog2qcBPsZHeT2iz62r2ae1
	 WLk4RorrJUNOZk1wfUVtX0q/D2494vTsgA6m1EkyzcnRqumKVl5JkWhU/xmkSy6WqX
	 OOdehNRcyKKe4Wzk6WK50t2c7/27ovl2oC8hmpafP6aCD5rDynipvmry4fIUcYmpb2
	 tD0bdg5ktq+JKFY1K90H6FiBXm3qP5N7gf+YBI/gFda4CBZvVyPyG/wEgdhShr+/OI
	 xBB8dE+rAHcXcTnvsv+xYB4B9Vz8KDFpbsWF3dJxEfs64gbpZIUL1iT/IV5GQp1yRM
	 bqcbnsNEabvcw==
Date: Wed, 4 Nov 2026 13:31:35 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Matthew Ruffell <matthew.ruffell@canonical.com>,
	Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 2/6] kthread: Keep unbound kthreads off nohz_full CPUs
Message-ID: <auslp4kRazpwtlKZ@localhost.localdomain>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-3-matthew.ruffell@canonical.com>
 <aunpNqPV38FG94-f@localhost.localdomain>
 <c9b24dd9-8c6a-4d35-8f68-07274f06299d@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c9b24dd9-8c6a-4d35-8f68-07274f06299d@redhat.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 818oxs69g9rffmm1rpdsrc13u6hzjfbw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BC1994000B
X-Rspam-User: 
X-HE-Tag: 1793795498-167280
X-HE-Meta: U2FsdGVkX18/rwkkxiLD/iWL03Abg8NjUP2dnMQPN6/Jos06r9fIcgBJJj1ydav/YBy9k1Me2MK9fHV24J4zVvUbE2kGQgtuWqmHNpjr9nb6HCogODcYtB/fI1d3Hs4260vrS0qk/PDgcK/rGf8KVE/QY2q+WFEP//kGrGIcCbRqTObYzQb5BHYgoaLp/FtVNmMbJsu7TGsRqEoyZ4ldzdMGxk7GDxD3+oaLwGAJvd9kJXX4lfbbCTiib2JRU51+/hh0ugaii3hwHkQPmEFrbDD5+91xivkqOKcvzj0MoZxXh8na7hv3fWwabXmfJTTkzzECTeWleq2MaMPAk/g8w+NsfRvsWggTz+yCPWFYnmKcndEJudzUEQ+XBvxMFEU3xJtZmxiwbCGVsqu0kUWEta9AoiUWAjtN2w0R5u49VkQsI7v82JlzIaGMZ8XcmIsY3BWj1seFy8m9ld2iBKtcOuKWgLN81KOGfUTuq57BkCJzSvmYBmJRAriG9o+y133Fb2O+u2btwuc5nq5zcMxjEFl25niFy9OISswCUsSw9QWYWdbqyb33TrusduJmOumObbN3dKvlQLDb+ki2/37PDKoB49W/chE6Ki/RxXwqCs8jYgFCMcbNXD90xMJCj2N7iXZTW2+eSB2UBuODJ7F1OMQ5XFN6SW0WbD1CGhs1OqgZVNpt7oLbnKUlaSsYb51HvHAm2cQ/9Ub8tTNib6t/o7V4WsGmeizEU2DgxdUzxfXqpEXQsCt86ieKiFXHX1mInNi3RwzkssGIX2kq8OAUvRGHX5OK3eEO+x9rFiLafcEQ5VLlrPPAOL4H8IArCnji0hUVijYpkneixq2Uf3UU+46xQvJFDW6ES02y39pkeLObv+EFPXlds3/OWvExy+vtCgmSAIVlEC8YbxJy3ycmw9raq5piO7ijIlTDdsTRaF5D2W95uaDQ60VS+BEAKlKhPUEFiDo15N/cc80BNNU
 Pd4LgZ5N
 WCH68mOr4RDBz2vbCK65jKnbauwfEwzNYc3CZTJc8gSF+JFaOD/3CerIPGjbmdvqTYYz0Y8+t7CmBaLrjXMdzM5TjOHel4s/OoqgifDmbLOcMGrjVu+0fEf4jK7LawhSq+5na4g0rwLpzDtfcz2k1ZBjWUrHaJXniFodNexmnouT7w+UKwgFmeBNo7wG1k4MB9x4/KjsKjhM3A4doOG3eyeHp73+M8INujbzJ8spIfT6Ndmpk3PGmX60sCTvXdsVQArAXsfjpyicxjCBftSdiPXhog+5Bgg7XzyeYxMNRm9F1nxNjTN/L8cG0Yet8GsDwktZ/r8Tr+FB2gI8RqjA7Nl3QUu3aWH0y6wzR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Le Tue, Nov 03, 2026 at 10:13:38AM -0500, Waiman Long a écrit :
> On 11/3/26 9:01 AM, Frederic Weisbecker wrote:
> > Le Tue, Nov 03, 2026 at 08:59:36PM +1300, Matthew Ruffell a écrit :
> > > From: Caron Wills <caron.wills@pulsar.com>
> > > 
> > > Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for
> > > preferred affinity management") kthread_fetch_affinity() only removes
> > > domain isolated CPUs from a kthread's affinity, assuming that nohz_full
> > > CPUs are always domain isolated as well. Up to v6.13 every kthread
> > > inherited kthreadd's affinity to housekeeping_cpumask(HK_TYPE_KTHREAD),
> > > and from v6.14 the preferred affinity was filtered with HK_TYPE_KTHREAD,
> > > so nohz_full CPUs were always excluded.
> > This was done on purpose because on all setup we have met so far, it didn't
> > make sense to run nohz_full with load balancing. After all the point is to
> > run a pinned single task on a single CPU. We have seen too many misconfigured
> > CPU isolation workloads due to that constraint not being enforced since the
> > origins.
> > 
> > I'm open to counter-arguments of course but you better have a good case.
> 
> I do see configurations where nohz_full/managed_irq CPUs are set at boot
> time without isolcpus=domain. But these nohz_full CPUs are there as a backup
> in case some latency critical workloads need a set of fully isolated CPUs to
> run on.

Sure.

> Right now, isolcpus=domain can be set dynamically by using the
> cpuset isolated partition feature and they will be used when the need
> arises.

Exactly. Whathever way you use to do domain isolation.

-- 
Frederic Weisbecker
SUSE Labs

