Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E25608509B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNvyMkl7
Received: by kanga.kvack.org (Postfix)
	id DA1296B00EF; Tue,  3 Nov 2026 09:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51CD6B05B1; Tue,  3 Nov 2026 09:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68136B05B2; Tue,  3 Nov 2026 09:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AADC06B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:01:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2159E14041E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:01:32 +0000 (UTC)
X-FDA: 85393970424.05.27E4028
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4CD184001A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:01:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNvyMkl7;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793714490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPRbykHolawBfCGnDVRos5HJS/K/9CLK+rvFUUZN+bY=;
	b=BxW4vV56aNrZK8f2pRfebqw3J9iGrYS61oUknRSolcGfgRKRwy/mUfrBHsvbMFcO534PdJ
	bGKA/KpC6HiH7PD9jaq6W+WME7oiyrwwVLRKQgS/SpxCnhFG7PlnhIAmxmTFAW6vLEKBx9
	pRYo9jupFSDirOYgoJyjggpt1cN5Mjo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNvyMkl7;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793714490;
	b=8JBYvV1gau3IECUqFJDHPrwyELxvfDa19OceadIyrc72dKEyytPeIcm1USYcHQXkNTm7Jd
	N7V4VkgJagMxdBPio1N729aiUfjmHq+hgWKuEuC00gu/Pcwadbt0HY5y4wDshehisP1Fzn
	t/EWTyNBMR78H2j6AafoUTnNZFxSTCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C4D940432;
	Tue,  3 Nov 2026 14:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2871F00A23;
	Tue,  3 Nov 2026 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714489;
	bh=bPRbykHolawBfCGnDVRos5HJS/K/9CLK+rvFUUZN+bY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RNvyMkl77/wB+TKUhO6X/Vsf2i8uYfQQHsCp2e6sIBV03LbpJ6GxqHxSUHPSpQTNZ
	 CI6rBm9JwRP2j7gDDaJ0y/HQLz6p+tN7IqgT+BVC7+kA4sGZS8K1SVjiC3OitAdmCZ
	 dnSjPivgNrMVhBrtEPnov1DXrYT1RLN0jluXjbTdgArGhwCYXQcu+Pz/M94xSpesUV
	 d/U62dXS00RO3dSOT8j+AIg5KMJ+kMga7RIMhFbTJK4cDrD0a0vHQOgN49kKEUz48R
	 RJ8/1JIm3uiZD5egP7DXyHHDKOftJyx91tyK/sOGckJ/q6Udv88hpE2LDUjFPp4fko
	 py1IrVmFnuSjA==
Date: Tue, 3 Nov 2026 15:01:26 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
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
Subject: Re: [PATCH 2/6] kthread: Keep unbound kthreads off nohz_full CPUs
Message-ID: <aunpNqPV38FG94-f@localhost.localdomain>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-3-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261103075940.110308-3-matthew.ruffell@canonical.com>
X-Stat-Signature: i4ff7zh6i1eh174qk8gr9q47w738n971
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4CD184001A
X-HE-Tag: 1793714490-283768
X-HE-Meta: U2FsdGVkX19AEbRZX81Cwc7njXMMe5QzfHHY5XMASJ0/Icloxi7wUYpyJ/YdSe1uL1gWsx83kqpVzfsatS4U02FMQ+LJ38HdaVZNOXO3tIsggqff4pOhnFNHDjK2nY5USMR88oYQpfnCHEbuRuvKIYXTiuYC+ps2MUYlgk85EhUjTIYMi+RF4dDBhCDP9EsvNRUfHGHTyGZ58HsF5SMaEZNauhvLXVzF1eE3KMC8pqGP/W26yoHg7gN5Cr9fTlZZOdATAiny+5H+NKe9Xe7pssSa7cZAtia8kFSDfmXQuNc1mI9D71VqGnz2HYZlRhOBU3QDI/+6qUryeKo+KTaMcW8Y3U+1/emTyQ7T0H4U1PCv5oLtky/IyVYPk2AT3n25ys9BZA+SZaOsau4oxpFHrm1oG4xoIRTrhAMxzQsN99VcOuZliup2jacJK/HT7zK2vJ6f7pP6WD4E2N0BBxcAS28kVgkEkS1uHjJli/3atzHlkXaqXS8xl+svsR273vZ0WicoGLmnua3ILounOUJ0S33NFanVktkctHUEe9aTR6xNywLoWPYsNctu8ydj5M2N9oLqo7F+4fcAOFG+4UR3krHLlANSWJHYL2uw7CY3XI5nbb/KYzOpTaMnsXL9k+4f3RxeNmjhhoI3/EZPs9zStmaTUXgxvkhiTsWj3ELtsDH0XWhxqRpy4LlfRp6WbNjNoYY65xVap1IaeKlFd1H6zt1yG3k1DfFWAosxacI+orBDWJf7LYvYfl4DaeJbUMTb3b01reweZAqF8TVoxBro3PldS9yXXP2O09E3BiBGTkCBQo0K43LQ8/vIknbL6rb24z9xXcuIeQDf0yaqYXdqq+dI3A3LWVZnaeG/9oF5nCgE5MNK7WIj9tDcl+yTYkU5KmgJYaXySoB0sK8oRljtygrOwD91svy+/3ztXkZLEXDHeA+wYEfDdzb4nFv5C5A56jE91dRYGkVcG4gblBB
 wbNbRaVE
 niFGR+cEPnUN2KD8X9aIi1HelfB2v/sG14Nx1G8r9CeXVe4etDR1hrqH1o3XdDtAlS0hiYMlNtauHbviucpXNdX/9dJBxU4XRKUUdiFxbgU7Ry9Wq2iOOOL3HN2s3RvXSE0IroySwGFBvKUVJgMSYeaE2PnSq/S1vGoTrYaAGOQzytxIqe9CtODVEE96N+r3wDYsC8dZ5HJv31SaR4UCQHiH8fg4nD9o6KfnitzcLYQraOL4hDDg5a5xnwYoOMT3TXmpcJaHGvHvS+Glz2YHp1iftPPsJXGAWby/e3mdCwt3aybOqKPj6jfPoFeGQD+DyOBLsoWpZLAapClu9EC61NQwX2c4RIse/ySNr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Le Tue, Nov 03, 2026 at 08:59:36PM +1300, Matthew Ruffell a écrit :
> From: Caron Wills <caron.wills@pulsar.com>
> 
> Since commit 041ee6f3727a ("kthread: Rely on HK_TYPE_DOMAIN for
> preferred affinity management") kthread_fetch_affinity() only removes
> domain isolated CPUs from a kthread's affinity, assuming that nohz_full
> CPUs are always domain isolated as well. Up to v6.13 every kthread
> inherited kthreadd's affinity to housekeeping_cpumask(HK_TYPE_KTHREAD),
> and from v6.14 the preferred affinity was filtered with HK_TYPE_KTHREAD,
> so nohz_full CPUs were always excluded.

This was done on purpose because on all setup we have met so far, it didn't
make sense to run nohz_full with load balancing. After all the point is to
run a pinned single task on a single CPU. We have seen too many misconfigured
CPU isolation workloads due to that constraint not being enforced since the
origins.

I'm open to counter-arguments of course but you better have a good case.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

