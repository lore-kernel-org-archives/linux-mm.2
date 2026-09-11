Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE6CC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4086B0092; Fri, 11 Sep 2026 12:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599926B0093; Fri, 11 Sep 2026 12:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1DD6B0095; Fri, 11 Sep 2026 12:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 212636B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:08:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0BD01A02F7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:08:42 +0000 (UTC)
X-FDA: 85201964484.13.110EE16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 249F2180009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:08:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N/7De1Zj";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789142921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnCshcIoWhJMLbbpjD+kSB2RQWWN3gtcsfG9Qvmj05c=;
	b=ZG8XUlbpR6uNEQBhYUmfebX/N5A/ThDh8WRZAn4bOxv1YF7CXyZ2Apl+5CaamFPTNnlZ7l
	Lycl6IZjdHacFJd8TzTUNdC/dNBIEp91PFkaxjZ0Va6f9cO8DMiQWfuwy0JJrV7pKc2f/u
	KAsE5BfhcRRUZF/ZVbRcTCkugtWWXWM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N/7De1Zj";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789142921;
	b=x+6J347mSTjcKXxEVaqwr14BLNPETxKWG5NYs/5TAcpXPYcLel1t20+kOvn+fQfzsBwsFj
	Rj9F8N2RoammJ2ZyFzvsUtG0ZuR79QG7Bpd67qkxtY4Ps1gCRRSglqMZf78Q12sjAvwSwb
	8x+t2kOBul30lUVbsxDpWXSrD0R8GOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D41160008;
	Fri, 11 Sep 2026 16:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273A51F000FF;
	Fri, 11 Sep 2026 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789142920;
	bh=xnCshcIoWhJMLbbpjD+kSB2RQWWN3gtcsfG9Qvmj05c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N/7De1ZjCZaLOY85gfXq7OouuwJ8uDEexXhtxrc9S5HqY0Wtv3bRFUg+Z0AXlvBNJ
	 usTMbaKC1mB1d8KqQkBj7/v5i8T+WnlVxNrRWSnqe1o7+Zj+eo2+TPq7vOWA4oHqFD
	 NrhiyNLPlF7+2HkWdQaYCuC7x/v/RQGdDA3iKNjAsgfEksb3y8k1qM4HJe2edezKPl
	 u6SJnN2GHgQWa3t1cEMi62NfXqPd+xSpWbnTYL8F5LryK/saDWM/d9Dh5vHNGc1rKO
	 ARtVinN/r7z1HjZ5frK4sYk+D0qBIvB0LzyJGLbdQylVDZID+enlWwwYQ4tV8mXbmJ
	 nPpCx8dkBIqsw==
Date: Fri, 11 Sep 2026 17:08:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Tejun Heo <tj@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Dennis Zhou <dennis@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
Message-ID: <aqQb_Jzl--8So9p_@gremlin>
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 249F2180009
X-Stat-Signature: ya8o1x787xiaytt4bs8xc56k5ja9cfno
X-Rspam-User: 
X-HE-Tag: 1789142920-422554
X-HE-Meta: U2FsdGVkX19JmWade5zv+Ysp4LLU5d43xwAw85oEobv/GNqJfTYbk7wScfy82O3nvkVf23ICntXcXjlNSmPBFdrJDWkFoWsnbab3y8F+wodcNXxMzp7XYgEIYmzCtdIyQJ8klFjtPNJUSm/JEGDTUKshbHhZwuoWLCUSBMEB1AELEJzNAWvPjNCII5/zGOjuCOmYbZNSLS9o97wdmX/2nUdG5o08Xbe4zqOUlM4VLcViKuv/AtmSBQXaGfluDJwfsohK2DVSTgZXqxmdMLk/vxtwdcT3HMbJq4AQMzyiApgM5oz34YjUjsmbrAqjfxH0drwyjLI+dKb9NUGLEcVsKzx7Rb5UZsjI/1VGtQcsMWh+eoOdN85OvSS8DSkEqIAxNaRAbDbd0DW0BXWawR229vKiViI0hpxQqqv+pvlV/mp/SHJy3jGNXSSKr31TMWgx9SPzKR4fKmz5N49Os8vG9mtaKPpgb+LuAcoX+FqwKI19imIYReh+CpPgT+A74FBPbXF66hJ7Ya06iLn4I9fiGSHg5sPTAY5WWRT6xGC0Xx5S5a6UXWw5a4bFeyGDKF4MXYl8HTEHqg0T7VmBEX47HM8b18rF+3/fGJFkS+aIKuY2jb3Zel/BfWw2NgaT3ZnMXRLd1qe4MVNgxWWYv19dQ2AXKeDPR30CJkxkahwPcltGLaqHwU6oMXUfDRP/h44PLpa3mXjQcam9k7yUjubH8Jda3zByULdpDSiK4+tsn5KUiPYKbM71wwhHDjv6ObXjVf103yin97cwN3aPay8v3Jr6lWYlLBDP9xq8X8GxsMPJS0EreMN2GlO6b0MLMIPCwNgDcyFyfspk3FTbP9b1KBTkJuk4QqcJ/3K7xr5zGmzvB8fnO5B/wZGlb+j0tZSek9VqxdvwU3v6wvkW/HMDWB5cbatJFzEjEVfPMKn2MunPJZy1AuSn1BwKvxESacvh7tCq8zYx3gdzkJXFB5S
 lSKiR+OM
 o8uNsh/hW/zx4g1cm3U/P7ox5cH21zANuYcNxWflkO86d6fSLuMJMMsmk6upoP0tSTv7MzQU7V0EORaO9YK5VejayT/1WGtjEG3kZgtpqtqDL5PepJcAv30mRaNjljQWK+xRPE+tHrpKzUTPcRdT35/DVy/ZNBpz3OtKL2pkc8W6FxunKiDTsMGV7CTTMxo3iPVh7Oja1/X/qiNFlpU43pmDRszQ6uBnzvC2zp8J+0ae1tyPD+nnes6kK750ZmI0z46Rp7rAQobGK32Szo0r7/89XrV/3tASORW4pncUlqGRrQZoiiyfkXjuSmnfq8kwaO4ipmY/BFR/kj4Yaq1fZtTienQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc cgroup guys + paulmcr for rcu aspect + willy, pedro for fs stuff

On Wed, Sep 09, 2026 at 06:01:07PM +0000, Josef Bacik wrote:
> cleanup_offline_cgwbs_workfn() drains a dying cgwb by calling
> cleanup_offline_cgwb() until it returns false, with a cond_resched()
> between passes.  On a CONFIG_PREEMPTION kernel that cond_resched() does
> nothing: _cond_resched() is a plain "return 0", and under
> PREEMPT_DYNAMIC the full and lazy modes disable it.  Since commit
> 7dadeaa6e851 ("sched: Further restrict the preemption modes") those are
> the only two models on the architectures with PREEMPT_LAZY support,
> arm64 and x86 among them, so the drain loop never reports a Tasks-RCU
> quiescent state.

Hmm, I thought that for all intents and purposes cond_resched() was unimportant
and something we wanted to get rid of or it was silly to use?

So it seems very strange that it's so critical here.

I think there's probably a bigger algorithmic issue underlying this.

And I don't think cond_resched() is really relevant here:

Looking at my RCU notes it says that [rcu_tasks_kthread] polls and snapshots all
CPUs which have undergone _voluntary_ rescheduling, and quiescent state is
determined by that.

It tracks holdouts and then at 100-200ms it forces a context switch for those
holdouts.

But AFAIU cond_resched() isn't a _voluntary_ context switch from task RCU's
point of view.

So this whole bit is just wrong I think.

It's more so that no voluntary context switch occurs in a context where task RCU
is all you have for RCU.

Also actually I think the comment on cond_resched_rcu_qs() is out of date:

/**
 * cond_resched_tasks_rcu_qs - Report potential quiescent states to RCU
 *
 * This macro resembles cond_resched(), except that it is defined to
 * report potential quiescent states to RCU-tasks even if the cond_resched()
 * machinery were to be shut off, as some advocate for PREEMPTION kernels.
 */

Commit bde6c3aa9930 ("rcu: Provide cond_resched_rcu_qs() to force quiescent
states in long loops") references reluctance to 'instrument' cond_resched().

So it was provided as a means of actually achieving what you need here in a long
loop.

Paul - I think maybe it's worth updating this? And maybe even renaming it? :)

>
> A worker draining a cgwb with millions of attached inodes runs for
> minutes.  On a 6.18 arm64 host in lazy mode the cgwb worker drained one
> dying cgroup's writeback domain for over 11 minutes.  A BPF program

That really sounds like something bigger is broken here... why is so much queued
up by this point with no voluntary context switches to clear any of it down?

> unlink (bpf_trampoline_unlink_prog -> bpf_trampoline_update ->
> unregister_ftrace_direct -> ftrace_shutdown -> synchronize_rcu_tasks())
> waited on that grace period while holding the trampoline mutex, 42
> tasks queued behind it in D state, and the hung task detector fired at
> 614 s and panicked the host.  Any BPF or ftrace detach during a long
> drain inherits the drain's length.

Yikes...

>
> Fix this by calling cond_resched_tasks_rcu_qs() so we do not stall out
> anybody who calls sycnrhonize_rcu_tasks().  We put this in a do { } while
> loop because if we have many small cgroups cleanup_offline_cgwb() will
> return false and we will never call cond_resched_tasks_rcu_qs(), creating
> the same problem.

So I think this looks fine as an immediate, backportable fix.

But I think we need to look deeper into the real cause here.

I've not looked at the writeback code for a while, and am certainly not au-fait
with the cgroup side of it, so asking the LLM:

" - fs/fs-writeback.c:726 isw_prepare_wbs_switch() walks b_attached from the
    head on every pass. Inodes already marked I_WB_SWITCH stay on the old wb's
    list until the consumer moves them at fs/fs-writeback.c:465.

  - Each pass isolates at most about 120 inodes, per fs/fs-writeback.c:269, but
    revisits every already-prepared inode, each costing cgroup_writeback_pin()
    plus an i_lock round trip at fs/fs-writeback.c:624, all under wb->list_lock
    with preemption disabled.

  - The consumer at fs/fs-writeback.c:616 does a synchronize_rcu() per wave, so
    the producer outruns it and the rescans grow. With millions of inodes that
    is quadratic, and it explains minutes of CPU-bound worker time without any
    preemption-mode change.

  A follow-up that makes the producer wait for in-flight switches, or that has
  cleanup_offline_cgwb() resume from where it stopped, would fix both the
  runtime and the Tasks-RCU stall. "

So this DEFINITELY needs some follow up attention I think.

Anyway for the fix as written, it seems sensible and the right way to
immediately address this, so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  mm/backing-dev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index cecbcf9060a6..18e999053bae 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -910,8 +910,9 @@ static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
>  			continue;
>
>  		spin_unlock_irq(&cgwb_lock);
> -		while (cleanup_offline_cgwb(wb))
> -			cond_resched();
> +		do {
> +			cond_resched_tasks_rcu_qs();
> +		} while (cleanup_offline_cgwb(wb));
>  		spin_lock_irq(&cgwb_lock);
>
>  		wb_put(wb);
>
> ---
> base-commit: 893e11787f78e43b534e252249ac3fff4d1333f8
> change-id: 20260909-cgwb-tasks-rcu-qs-42341609f3e1
>
> Best regards,
> --
> Josef Bacik <josef@toxicpanda.com>
>

--
Cheers, Lorenzo

