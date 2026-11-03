Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22616070AA4
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oEbqHgIE
Received: by kanga.kvack.org (Postfix)
	id 003E46B05CF; Tue,  3 Nov 2026 09:59:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E5C6B05D0; Tue,  3 Nov 2026 09:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CCA6B05D1; Tue,  3 Nov 2026 09:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3E966B05CF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:59:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42DCD80485
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:59:12 +0000 (UTC)
X-FDA: 85394115744.20.55104BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 948952000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:59:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oEbqHgIE;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717950;
	b=BhDJ5oPWqyIZegzY31XHxRFMvhnoRqRnd0SGB7nnpFj+ywF117CLuzpQ1nviRk+kDG3vOH
	BtSIKtbUNwXgRty1lH5lDP+9WXavr3Fp6/sLFcFfRzB+l1eIVh3RORGgBCcbb12vtWTn0z
	WhIjmNRJPskSBX3LAYgARwWBgt5I8Ns=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oEbqHgIE;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTaO+IpTNWTE3CNFVHX0P2a4foAlotO2i/j+8kuODPc=;
	b=aoWjUayYLqBIsmpzghu+RJn+O8uTuXvm2cmFc2mFf/JMQ88abGNETc0j1/vGWsyGyc0R1/
	bzgf94BgJCBVIjrpBVz+QHBstSmFkYAHJyA6m98NyBQ8DnMcEV3YmdHcruZF/RhAcft4vD
	VNbYH7VQt9kwwVYSS1wihDd7IQVNHqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E4ED609D1;
	Tue,  3 Nov 2026 14:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA0B1F00919;
	Tue,  3 Nov 2026 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717949;
	bh=xTaO+IpTNWTE3CNFVHX0P2a4foAlotO2i/j+8kuODPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oEbqHgIE+lY1Hs45AftM4rckAxM0DUPGsSUAtVRRHsLlCWFfg/veggpDHx7lSfgRv
	 ibzBHmChGFeeUx2SP8E1zUBkySc9PwAFVUIn62YQlpimDIta3QR35XHjkbcYNhi2BP
	 wa5a1j1zb+NN9BiCdbdo4lSvj/oJnzVDxiLtUzOZoXLffAYC3emYdylnhzQAsFQTHB
	 MIsduntKoVn+y2w6wh8viyDeUGIUXaVSs+MsCwmDnde1ZryBcvS0rGAjKFJa4nyqG4
	 eOwC9caU3Ww1Mvk8kYxmni0poKc1wvsFuKHnE3Rp1RRiZjxtRv2zHsYytALtoux6LT
	 2A8C9VrUM5m9Q==
Date: Tue, 3 Nov 2026 04:59:09 -1000
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
Subject: Re: [PATCH 5/6] cgroup/cpuset: Don't wait for memory migration when
 cpuset.mems is written with O_NONBLOCK
Message-ID: <aun2vUjloJjH3Hpb@slm.duckdns.org>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-6-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103075940.110308-6-matthew.ruffell@canonical.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 948952000B
X-Stat-Signature: 9pnqmd3p9tmcthsirsrqah5yf6epfxgh
X-Rspam-User: 
X-HE-Tag: 1793717950-925526
X-HE-Meta: U2FsdGVkX1+AOAv8WYKAmBDSrs2He1jTpfXtg3EKKIR9Y4A2ex2i2aTFeW2kVEp4vpJhgnNa445dW7b514n8uRn83VXQRoWB64O7ZMZWfsqKyWdwIplRCIZzg+odvuacQ8fmMw/VJbGH5NFtIPlz6j5WfM2jWk+kMX2Fx9NAHYzauXgy4Ci2bR6FDFSOLiI2TDpyyI1otZUfEjTYuCvEa28soqlfIQfH8wMuGW3RSqBO8v3AXEMMt1UeOqPwDpBk+H+YS9FFcMFqfbs7GH3hY0F1mnf9Wt0GZWySAcrMsCQfSdZA4owbGl2jXGEXTvqTMeiFY1ZvOPkw6wUHV0Un+kp1p/ANYWUPlkDzXbYC1heiIaDud1SNhE1kgcFPQaPd/Vz/h6d4kC8TP6VUWZdrZGmfmAAQhaK/ugFxqnJLdfbksLuQHqo4uDbKw8nCpp+WNZgp+B97yXlc2AS5C6mm3SHAiIDQR/IbsiB/t+8hRHkVS8ohkTedC9A17MNK0choLj5e6qGFIQ+Jb6DGnPwgIXzCR8JksMCOKTeJUr6kY06Nq2c/wNK+8hWKz6TqTa5YNLwS7JENRx0IoT7yKM3eqLD8SndCexibbSYPr8PyVsxcD8UsgT3FQIWzTR2VE32i3/qZAZ84+kS2irYQQIRgDh9Nty3Ewl+4mrroztLbWaAsnYw6UoWlvG8pk5mRDMmrsmx/rsQ6EMYtdHNOli3oz1nZBEgzHYmQbhyLAwrbh8NJa8TkaX2/GwnPhyuNdBlAsYZ6V/zRDquVMmd/xt7I9HO/sQZRSMu9lsmhJCNug3SEd0Ncl+MQUY1P2pN4Ww+qyDLZGgJjQDLSdmhTZUWjA8xzgh/OmjUCj+b+G4SJvzwUIVh/SfiNT9RYwENJLzPCWTrIPPm4o1p++X8/9cmdiGCwCVhtICsO2kmcVnUDipasyF79g3osVjYzvCMKptS5s5s1GUuyqPLAYrEbXCI
 snk3T9MV
 WpaxCjtM38iHd5+wIruN4zPM3tkxGqe8ZFMjWdhpFBSRSasHT9zvonHs/9x74gN15n7nTk5Do04R5BmlbNkv1J7nllzg8gepiPuCwVLcvXHkzYOT+1dwEQKb8j0SOnxRERUYcKPMoC9igPCX7JWb8R/JPSRhArO0zLQHlPs0xGNGnZET5k4q2mK6+YNLXq3LE8Q3nbJ8OTL1YWqekbiVST4yd5iETIUH6N6TU7JpteaVzAA4OwuLmdFiKNT/pnXYad/etT06xnUn6MZ9KuSdX7FkSReX5fQ4nHcPh4X9v17Qa/a2E7xUVhPBzlcE7/13XKWzezA/YM2VFfsGvFmHvx6JIkS3sIIYAD5YpsvwKel20LwGuMwFkbqvMbHXReq/BLVssWr3c4yZ3vZ1TPgEn1YLMNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:59:39PM +1300, Matthew Ruffell wrote:
> From: Caron Wills <caron.wills@pulsar.com>
> 
> Writing cpuset.mems migrates the memory of every task in the cpuset on
> the ordered cpuset_migrate_mm_wq, and since commit 3514309e0322
> ("cpuset: Defer flushing of the cpuset_migrate_mm_wq to task_work") the
> writer flushes that workqueue from task_work before returning to
> userspace, so that the write appears synchronous (the design of commit
> e93ad19d0564 ("cpuset: make mm migration asynchronous")). The writer
> therefore sleeps in TASK_UNINTERRUPTIBLE for as long as all queued
> migrations take. On a system with isolated CPUs running SCHED_FIFO tasks
> that was measured at 2 to 10 minutes (LP: #2165410), and it is unbounded
> in principle: a migration blocked behind a starved kworker or a slow
> expedited grace period holds up every migration queued after it.
> 
> The writer is usually systemd. It applies AllowedMemoryNodes= from PID 1
> itself, and since v259 it opens every cgroup v2 attribute file with
> O_NONBLOCK precisely to opt into asynchronous semantics wherever the
> kernel offers them (src/basic/cgroup-util.c, cg_set_attribute(), citing
> the memory.max/memory.high behaviour of commit c8e6002bd611 ("memcg:
> introduce non-blocking limit setting option")). While PID 1 is stuck in
> the flush, logind cannot create sessions and SSH logins fail.
> 
> Honour O_NONBLOCK the same way memcg does: skip the task_work flush when
> the file was opened non-blocking and let the migration complete in the
> background. Blocking writers keep the synchronous behaviour and the
> cgroup.procs attach path is unchanged.
> 
> This does not make the migration any faster; it only stops the writer,
> in practice init, from being held hostage by it.
> 
> Link: https://bugs.launchpad.net/bugs/2165410
> Signed-off-by: Caron Wills <caron.wills@pulsar.com>
> Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>

This makes sense to me. Waiman?

Thanks.

-- 
tejun

