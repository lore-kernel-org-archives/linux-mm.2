Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1C2606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 03:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Efflm2x/
Received: by kanga.kvack.org (Postfix)
	id 340046B08DE; Tue, 24 Nov 2026 22:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3296B08DF; Tue, 24 Nov 2026 22:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9416B08E0; Tue, 24 Nov 2026 22:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E49246B08DE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:36:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C0E2140DA7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:36:36 +0000 (UTC)
X-FDA: 85472229192.18.6AC8CE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C2D58120005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:36:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Efflm2x/";
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795577794;
	b=VtA7H8033wJU/QAm2A7R6PTsbpZ6ZPaeuElomxpCMqyigGnRvwPwL4jgX0WFX3ZMeN8OkB
	TuUJZbD0tu084HybleX6TUquhmfl4lmoalRYxGujIoSCXe1LLYxX+ZKRndsufqFP+3zR2z
	3/ZVsS+f4CYzA8SvRc8VmdTSD1D/IXE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795577794;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpbEYzPL4+9HXslVBGDoIM4ZEdfZMsvJubmieVG8Kgg=;
	b=MpltA6Rr0/C8bMk5kEXSOf1+ebRUw4KaHkv3Dk8we7Bby02giLagyXiFhSu8u6uIlFW0Gp
	xG0jG9ezjEUzpZTqmKy1a0p0BARBmka66JOpgMTSI1opM5m3c36GbjFIJkhP5BuWF1mSNs
	tt/BLoZGsKnrwcvb1MCseqY71wvbMUc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Efflm2x/";
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4090561829;
	Wed, 25 Nov 2026 03:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3894F1F000C4;
	Wed, 25 Nov 2026 03:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795577793;
	bh=rpbEYzPL4+9HXslVBGDoIM4ZEdfZMsvJubmieVG8Kgg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Efflm2x/woiUXtSPov384648LQXwZ4Jg6dNuInruLMISNeVlvYSPahW4Tm/IUFriZ
	 Q8aN2it5SDui+1QCzjdSl9RMIF6FKtfOTbutiitxMkxpvgqbjKvSwtQxxaz0FqHcVU
	 LQ6+eU9FNcavKJZVs6QhTTJ2ZQkpsU2GgndpWEgdmwOxxO7ax53ydfroHN7l//mXDr
	 uCr4fq05nB+kt8FFS8zQYs+1Kb51q7SjrTrEJSBn8vqgZVjDnwH0aX2UvQaCKXdsIu
	 aiiXm7JuRx2Mp49Pd4tA7EgxGOPwkQLtJ4tQVAUNQYrvG8KyOzPeGF5tWi8MiTTSsS
	 remrvan84wjYQ==
Message-ID: <sashiko-outbox-232472@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: find the OOM group of a process
 where its threads are
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhan Xusheng" <zhanxusheng1024@gmail.com>, tj@kernel.org
Cc: hannes@cmpxchg.org, mkoutny@suse.com, mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, kolyshkin@gmail.com, chris@chrisdown.name, linux-mm@kvack.org, zhanxusheng@xiaomi.com
In-Reply-To: <20261124033547.2373352-3-zhanxusheng1024@gmail.com>
References: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
 <20261124033547.2373352-3-zhanxusheng1024@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 03:36:32 +0000
X-Stat-Signature: sednycbde9w4sdj14wyjs3gjf6yfd677
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2D58120005
X-HE-Tag: 1795577794-560994
X-HE-Meta: U2FsdGVkX1/JSXHn9UdY42NS/ilU1P+fOKs7qCEIHrPhtqrrxwtGEzFOCLcEPLMal+VQf7HS5VbFjs9n/+plVAHf3Sy16MyLiocLlwstcKJvZcyhrOvPGGSlVXpGgZ1aZ+1lSYzx9ErUOd6GaaP63pbfp6x0q01/q1EqKVBBuRr1Du9Th5ko1S8MK/8f/qhM01GLjufOFGbDSWvfhB+s6mWPt3RI8wAvL5ng7N/aXWuqAepatXgQJT4axGQgxbz0AjqUkCQsNbmNicqKzgvwyphExnH2JEuzQY4Lcz//7LL9kxSsC1CtIw7/bDGSZLQ+q9WF4WfK1omjBipKFbZoFMXzDelYwCx/o2TlWHS+7J8szHW4aU4orznQPbvOpAv4hSZWpogkblyjRPhsclaC6fJ9mnwDuQKU8jqdJYLZsoHg7IscK1HaZiCTkAUJZjiJkLFR/KAhND3i26tOAC//7rxELllzQgUJYyym38AAoFsSUdWX9y66Ju+Gs3PEjs2GFZkv95g+thPM5XSA1W6rV8zqVCyB9PsctIU3ivGlOwcuBiYQ/HJ3im1Eybq5/pAGLynb29/arQrNrDDcRAcLGxK4wiOlZi49qZ1iw558w/nyRDeR9tgcUZLDvHLqGApcGgVQ7tBG/CBx2TEHF3q3cxcwyqqKyoEDNCC5/qhaa6eBMwKL1iCf3IpvDp/5YevAdKX2EpyW2V6dEh+gB7dvjdiCFseSGwzvTxn5YS96xP6aZHNjJ1U9EOyHPrVr65v4buwugm1wP7rj8spW4aMPd8Enhaif5jvUg5vEbHacHLy7tYt9nEuVnhJtUIKZSkhnoZI2zE6SGgLDo1pf5TWvBeA0yZ5VZv9z7P5jxKS2cWMRTRw7bR/AQT3o9MNuoXkc6eniBCH0nrkg9MEua6lQJEYQCl6yY2Kfx2JfDViBvtTvxNHsxKJ5JwY+xoXmuCGk6x3cbXsor47UVEnrMKp
 06ehaH5C
 jBEEBeE91EHfJp1GRitkb2WvUx998XABlmFILoSxJB8tRJxJbGiAXT9PCPeJ4H+pRA67n/DBDE/p8hADoH/xExU2UFy9kHsxbnpvNvWqjKLosig9CPVE9ZXFv8+K0kkpJ71jY+N7jNYCKkyJwGW5kJADiBW9zzfVlhqXtq2KiBMPbcQf2LjZN1eK5SrNv/sG3FBniUT+4+YTgu+SNSTJig6gFy7F9cAllDKZjHsR/sik1cb8fUaeTBhfNU0n+fFR0KPHctxDKtLYm6k3e8Im85acpBYoSsMmng6U9bKnJR1+0ycye5UYp2DC1TYl+MVpRSRRwYaizQrUdmRVqUrdALI4iiUikNWG38dwK6ssp+P/difiyGhetmoI+bJl53OqbrVFhz79N+GjJq0IQvpMA1vdJpTFamdqILVsaqtTC/Hsh3FTf3xGFECg7mU+u0VY/M05SxDtmd3c0YBTzRlc2o3ObvxmfcgFQOZ6k7zGNombUdEXlN4STgTizBYnJ/8Pohg1SqGrVnIOCkb+9Bm/dlHHey7Y5rL1MYJw98OVR0ugJbLjJa764Y79DK7h/EznSVVb4CtS5e7Bijz2bAYUN+Ut5pCQkRh4/TAbD1EoPho5Z3hmTAXN1VTNWxSQ2oYoKwMmp4N9XV+pKpVeRtxIyqKxjJgPl0arEXaXCTqAjpn2QEom872my3poiGy1sbQjlK1gz/HN47TmTf+AXTlFQMh37VjG4sd7Upd0m8dtYg85K+MmdJ9cpn5mTqVV7jPsWo+e0Z5cXNRTjFINpYIX+RNeEUeXjUg/cF8uvVUM/TUnOT2m9nxJblp3f+TiLcALop0+MgvJUeNBzfhdj5PBPdbH1Xi+hGxn5RuyjRHFWQr1tfAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm: memcontrol: task_procs_css_set() returns stale css_set if
  threads exit
- [Medium] cgroup: missing cg_leader_left update in
  cgroup_update_dfl_csses()
- [Low] mm: memcontrol: use of task_cgroup() in
  mem_cgroup_print_oom_context()
--

commit 00e8b03872e16150479767210c746337c6018f3f
Author: Zhan Xusheng <zhanxusheng@xiaomi.com>

mm: memcontrol: find the OOM group of a process where its threads are

This commit adds task_procs_css_set() and task_procs_css() to resolve the
css of a process returned by a CSS_TASK_ITER_PROCS walk via
procs_live_thread(), and uses it in mem_cgroup_get_oom_group() so that a
migrated process with an exited thread group leader is matched against the
memcg where its live threads reside.

> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index ab442f94e29d2..0be7f96ce074d 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5237,6 +5237,17 @@ static bool procs_stand_in(struct task_struct *tas=
k)
>  	return leader !=3D task && procs_live_thread(leader) =3D=3D task;
>  }
> =20
> +/**
> + * task_procs_css_set - css_set of the process a PROCS walk returned
> + * @task: the task returned by the walk
> + *
> + * See task_procs_css().
> + */
> +struct css_set *task_procs_css_set(struct task_struct *task)
> +{
> +	return task_css_set(procs_live_thread(task));
> +}

[Severity: Medium]
Can task_procs_css_set() return the exited leader's old css_set if the
remaining threads in the destination cgroup enter do_exit() before
mem_cgroup_get_oom_group() runs?

When the victim is an exited leader left behind by a cgroup.procs
migration, victim->mm is NULL, so task_will_free_mem(victim) in
oom_kill_process() returns false and does not short-circuit before
mem_cgroup_get_oom_group().  If the remaining threads in the destination
cgroup set PF_EXITING between select_bad_process() and
mem_cgroup_get_oom_group() (for example while dump_header() is printing),
procs_live_thread() skips every thread with PF_EXITING and falls back to
returning the leader on the old css_set:

kernel/cgroup/cgroup.c:procs_live_thread() {
	...
	for_each_thread(leader, t) {
		if (!(t->flags & PF_EXITING)) {
			if (task_css_set(t) =3D=3D task_css_set(leader))
				return leader;
			return t;
		}
	}
	return leader;
}

mem_cgroup_get_oom_group() will then miss memory.oom.group on the
destination cgroup, or kill unrelated processes in the old source cgroup
if the old cgroup is also under oom_domain and has memory.oom.group set.

[Severity: Medium]
Does task_procs_css_set() also return the exited leader's stale css_set
after cgroup_update_dfl_csses() moves live threads to a new css_set on a
cgroup.subtree_control write?

When a thread group leader exits while sibling threads remain alive,
do_cgroup_task_dead() moves the leader to src_cset->dying_tasks.  If a
controller such as memory is then enabled on an ancestor,
cgroup_update_dfl_csses() migrates only tasks on src_cset->tasks to the
new dst_cset, leaving the exited leader on src_cset->dying_tasks without
setting leader->cg_leader_left =3D true (which is only set in
cgroup_migrate()).  Because cg_leader_left is still false,
procs_live_thread() returns the leader on src_cset, so
task_procs_css() in mem_cgroup_get_oom_group() resolves to the ancestor's
memcg on src_cset instead of the child's new memcg on dst_cset, and
CSS_TASK_ITER_PROCS walks on the child's new CSS skip the process because
procs_stand_in() evaluates to false.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617e..5704e4415a16f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2003,7 +2003,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct =
task_struct *victim,
> =20
>  	rcu_read_lock();
> =20
> -	memcg =3D mem_cgroup_from_task(victim);
> +	memcg =3D mem_cgroup_from_css(task_procs_css(victim, memory_cgrp_id));
>  	if (mem_cgroup_is_root(memcg))
>  		goto out;

[Severity: Low]
Should mem_cgroup_print_oom_context() also use task_procs_css() instead of
task_cgroup(p, memory_cgrp_id)?

oom_kill_process() passes the same victim task to dump_oom_victim() right
before calling mem_cgroup_get_oom_group(), so task_memcg=3D in the OOM log
will still print the old source cgroup where the exited leader was left
behind.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124033547.2373=
352-1-zhanxusheng1024@gmail.com?part=3D2

