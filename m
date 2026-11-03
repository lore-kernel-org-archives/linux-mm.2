Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7648606EE93
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nt5AkpQ9
Received: by kanga.kvack.org (Postfix)
	id E12136B05B1; Tue,  3 Nov 2026 10:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA4F6B05C9; Tue,  3 Nov 2026 10:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DEB6B05CC; Tue,  3 Nov 2026 10:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4B8F6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:01:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3740D16047F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:59 +0000 (UTC)
X-FDA: 85394122758.05.14AE992
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A34531C000F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nt5AkpQ9;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+DwvzPCizDdWmjSJvWlcQRJydG6oUcS5wV4t674KgA=;
	b=gryqMS7GoXzm4rteCNrUhg879o0azBWGKXVHRXGyW8XSNl33IsNDt/x42ZqHTqMMSu1hnt
	kQ1xM/fimross/6KsmHWdtVwBndoC368VyB/qc1MuuZwsQMbfWXZJyL3AJH8rOlquunKyN
	p9EDazIfvvlBNKX2IZDJ/L3viBfkbrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718117;
	b=mZ5gYJFkbm0+EZ5E45nzs2DSo8QRRDudeiHZRwczcuwaIJGKH7KGnVmKZNUTOw1p+B/lxy
	/Xuwh2OmqmbGYlgFadgz69vVsAj+4UT4msqzBD6cTbcba+Ik3YOJmXI958Rk4Bh9a0T3MZ
	Yek4AIG9lZVUXjZ6zstnK7IxPsq7p88=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nt5AkpQ9;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A7776020A;
	Tue,  3 Nov 2026 15:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B751B1F00919;
	Tue,  3 Nov 2026 15:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718116;
	bh=x+DwvzPCizDdWmjSJvWlcQRJydG6oUcS5wV4t674KgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nt5AkpQ9xzaOQ1fTYw0l5B4HfodCv0sPfD7QFVJnV2c9oEkdAzkw+NTT59o2ggnYz
	 SZbi23+yzLh/v2Wmpx5CcIEUDB/1X8Quo+88j2eLBa7Atfjqeky9v2k319KGMODtCL
	 Ftok0laG7i6piw0fW0Q9jYqWx9uBGsBs0lSJ2yTdHUS+DhfdosZx8g1F1Hs27HmGh0
	 4IhfI1cku3+T+DlOdPXavAnvm4eVfgYQX/2QigbFcpkT9b//JO6CmCEC6mB6ePeJWt
	 9zdofkU10cLS6w5myGpOLtx8+RRydr5ein+oH2Hfsg1neaOR7DpSJV2t51KkYE/IPO
	 PMvkXzaCKV5OA==
Date: Tue, 3 Nov 2026 05:01:56 -1000
From: Tejun Heo <tj@kernel.org>
To: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 0/6] mm, sched, cgroup: LRU Cache never drains when
 isolcpus are used with spinning SCHED_FIFO tasks causing page migration
 stalls
Message-ID: <aun3ZGLR2sLsvG6F@slm.duckdns.org>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6nmo7fksmyuy67h7ro1hzh6s1zj8y1cs
X-Rspamd-Queue-Id: A34531C000F
X-Rspam-User: 
X-HE-Tag: 1793718117-504615
X-HE-Meta: U2FsdGVkX1/ODRazdpLLjqyQj0VTLwZo+xOXpZKLcy4ALTo7WkpIQmFXs91Qu8jAYvVHQ+8XMdHukUOhszSofI/ueq+N8E7IVMBQ0lVQNBRrTVqBzplka4VD5QgrV2wAvo/X3d5dqzi8T3VbX5rxkEP4NkzvYxexhtMj38yP6gvp97sZolbj3jTSYieZskAPgDR04Pyw8YNJvEmMEQaKCoeQ8wFKaJk82WEnw52sSnU7NUWd0WZ6DAnrn1fw/p2vxOwN+srlYB/09UA5sTZyWSVBO3JjWTFjSnDSVkiKjyMUtP5In5NPKwZRqaEkTmrtO52mgAJTyOZEJH2ESGuGRT1gMcHVML9Tz0jQF/EWhFEPvWvQDj3G+Pd++6ZiW9Y7m8LjEIU9wGZjnENruzaig2fv8ZhZERaCbb4BAENWifd1bU7S+rqI9xobgSF4CEcZCSKr8VmTmy8prV4sz3BuxWH+IAI71rdKt6/hx9oAJIoNGj7tZdouzcmJE2yaLcASuzUkzjCR7Eeo/c9KPaOT2WkNYz61iDSXw6lUHpQfIbqv6pFosvlpw9rJKiVpD1PtsTNfazWhbiZQWeGB6B2P2D2bNPRqzizB0fEo7ACJyJC9Iet40AVKsOvsiPpctEMLvFwLCXpa5obd/lk+gwcKODgE22U83DCUq6liAE7VCE/dlwk0Y/oW3QxqKTvdfixX2NgP5CpaMS3V4DAaSRyx2kjCJvD2LWi40HANXG/GbRH81FolSKoMkt3ENvuIzpSgMjCBXMnQssPWy1tUjYYeRHEj69ZNWVz5aVayp7JZkz9ziuGmmPJ8TMn/XAaM9m/vHn0Whg2DcJ6OhFW9LXeDkKN9f53TG6cqEHzvNpC/JXXFgddqBGsXpBzG4PY1ng4HMQ1ovH4Z46vLkUu7QwCo3+G3aqS1rWITJHo/FGLCAKncm+woOthQW8srfBWL9koWg8O7sMc+UT1UPHzYMc7
 C+YqYSVK
 J4P8nRhRACJFl/Vgf05TRkC8SlkaIEDkoiEP7eXQy3Rzon2JCDgS931RQz0BZ2p43zJB0ElwnwL4fC1T5Erna7InkKSFCq7+gUp7SxpXkDVP3Eg82eBCgK9M8ZYzwff7N83zS1HyEDGtZPq2tTM7mn28uE0k28XKJRo2FjMDfSwQoE09cHGuVPscHufTP7w3+Z1iM0YNy+9JzO3kJ30mO7lfGb2YY+lJ/VdLghK9y5z5OCusAzEqOGJgVtDlKEqT0yH6I44a/xIQYxoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

On Tue, Nov 03, 2026 at 08:59:34PM +1300, Matthew Ruffell wrote:
...
> isolcpus=nohz,18-95,108-178 nohz_full=18-95,108-178 rcu_nocbs=18-95,108-178 
> rcu_nocb_poll skew_tick=1 nosmt=force idle=poll numa_balancing=disable 
> transparent_hugepage=never audit=0 nmi_watchdog=0 nowatchdog mce=ignore_ce 
> tsc=reliable clocksource=tsc

We should get rid of fine grained isolation control. This is such a footgun
and ties implementation details to interface too tightly.

...
> What happens is that the spinning SCHED_FIFO processes running on isolcpus are
> constantly dirtying the LRU cache, and when we attempt NUMA migration of the
> 50GB of pages, systemd calls flush_migrate_mm_task_workfn() which creates a
> kworker that calls cpuset_migrate_mm_workfn() then do_migrate_pages() then 
> lru_cache_disable(), and then __lru_add_drain_all(). __lru_add_drain_all() then
> creates a kworker on each CPU to drain the LRU cache, and systemd and the
> initial kworker wait until this is done on all CPUs.

I suppose you have fair deadline server disabled?

Thanks.

-- 
tejun

