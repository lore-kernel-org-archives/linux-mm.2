Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC21606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eiB3Z7oc
Received: by kanga.kvack.org (Postfix)
	id DD5486B05B3; Mon,  9 Nov 2026 00:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85B66B05B4; Mon,  9 Nov 2026 00:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CC76B05B5; Mon,  9 Nov 2026 00:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5E386B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:41:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36852160594
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:41:11 +0000 (UTC)
X-FDA: 85414482342.09.B572223
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B860180003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:41:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eiB3Z7oc;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794202869;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh18oYDi0/D3vCx3r5khgR9nfMZ5vYV8YkdpupLcvRY=;
	b=gnc7P8rEdrC7i6p06+k7Idhwv3QBNiKdsCJiiHeEqE7jFBhNNAJCTgAnii5rYyP01m5hAN
	wgWsSSDhii8RdhCovRSCB8jP+LKSqMFA7ebaTQfh1CB5ythQ53iJuD0h/fCHBqK0tutHux
	60HkT8/rMnY8HPELEpLoj/xZ/KKmc/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794202869;
	b=8Nz/acQoeob5cMmtY/lc/wXHj0PXwyw51J18+2SAep4GiYweCU8vQ+sRc8uYGfqeUWIQmz
	9NSM7VdkbFuJexN+S/G7O3+seL2NjJNU43jybfX07GzALE8CXzPFcJpeAjxrZFUunQ74hm
	Ynl55NwuuKaNQX5yjB4pXg/PyA8vvuY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eiB3Z7oc;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EE0644686;
	Mon,  9 Nov 2026 05:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F081F0089F;
	Mon,  9 Nov 2026 05:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794202868;
	bh=Gh18oYDi0/D3vCx3r5khgR9nfMZ5vYV8YkdpupLcvRY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eiB3Z7oc3i5bmtbXIDuHZmK0k0BadEkoy765cFhMkVWRv2Bohp2cpMUiBk5n6qj14
	 OYk1ujl3F/zSGvcEcVCwIC7tWOMzRoFN9dfwoNKkSxex+v9LkQm9wMYJLDU4LS9Zf/
	 gwW4juJuN3PlNTj1baqw5ilUyPU9PAMnxhvPTiUKWkjAMNiGyr5WnSN8FTPFPnCDa/
	 P+sxv9A7sfSMQMpNMQdxVUA3z0sCRraqkgCfy6dn4RY38cnHXsASbzs7up/1nqCRlH
	 sE50f/3KMc2FR8tMIgLYydSVqzGrAwhP+r2tAOVijjbThsL0uLQmTZ+vkZguW2fBpJ
	 rWkOfuHFzeRDA==
Message-ID: <sashiko-outbox-204449@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: memcontrol: don't lose track of exiting OOM victims
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Down" <chris@chrisdown.name>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>
Cc: "Muchun Song" <muchun.song@linux.dev>, "Tejun Heo" <tj@kernel.org>, "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>, "Zhan Xusheng" <zhanxusheng1024@gmail.com>, linux-mm@kvack.org, kernel-team@meta.com, mkoutny@suse.com
In-Reply-To: <avALaDR1_epaAfOp@chrisdown.name>
References: <avALaDR1_epaAfOp@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 05:41:07 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B860180003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: oe63e9wahfy65xbcbbkmhbxcs5i7gisc
X-Rspam-User: 
X-HE-Tag: 1794202869-943891
X-HE-Meta: U2FsdGVkX18Sv7N6O5vrAlFMREll869PtqNXV+qtLQ9I8xLpGetWrGsJweAe1JykbNr30iQSoKt5bH7CjcngZB0l+StOoFkoCkbhSbtsCZL8l+KvcOfZ3lsS2Azbp0nxmzHWoZ4UgyJe4z/i8ZUKwXI4G6hXEX9wo4/R0HjNp+UCuuGwXbKrgSzR/rA8WXoOKuVNgrbE5g4QZgExOQ08vWpxgFJi0G29IEOuHwMOEKVBNf4QevPaUOeQjr1ZQtAX2iaiMWkkqooogN4UAP120vxtxy8EtzIEYsiOOfBcDsU+o3AKUq9Y/ndmZ304eoHWpewFsqCguQ5LSJwCOquMJEEovbhwJwKRnrQN+gUWHgyIn9iKrjn7gug1+cdxBxe/NUo9VF/Rdxiq50j3eOp+88+MzxoapjxWNytYbfNe/YoXxZn1CcGBjO4P1afKNtZnvgC3BDuU4SCD5k2aJ4QxfViEgcnALm+vbtjvLeK8QU7Q6/dHH2AKwZQnfesopjW2yybLWqfn6cnWlSOsL+OBeH2TnCawjDQa/p5+l22VL5e/ZVQ3etBqpxH5XGx554cLgihgW8BHWSHwelWFkzeHt+gEolzqek9tmzFpA38ta+vk3/JziYW2rGwdm+O/mtUyqdVRLxM11qAvg5FbYO9Om/hpRgsUYTdbtVRQxu+NH+Wy1+w7FlI09RgZjEvywtsmvFHoPhcpJpDhS5mrJmqagWLunD9DihxgdNReOKm6Jh85DfhwcYWUOEd7CNbGro9Lq9aitvE6qTADuTpobSKqlFyeEzf0M2KR9b3zmAyoNaIelW4Ozgd2sYOIKT0VU64bwzDGrGGS8Xj2W1+SfxecRZvoRCPCRG9Ao4q32gBRdJ/SfXjd61/rJWJ/EdLvdgaDdsZ006S2Ny+VOnT4bGbln+1OD35g6C3XF8ITBfcfIhRHY+d9HDmK8KS9fUuZ7hU1YZyqCrfZcmf5KvJ9EXR
 ZaPF8tCK
 p/P5+CCbixqOn8ZeBDP1uBA3CZMkLtaD8DDiRQOMqcfxvS5XpIjIuPpsKK7a1Xn88+SC78k9QWZ/cfbWFjfkfTepjAo0IGj4HmDa7a5cQc7aCLTjqJQzNeJq9wFzdH/R/v9i4au0VkCItatBidQBwZpGQl7qYAHzToOGR6QBaGf/PSM11AndPZ/V5UitN6hiBYeD5KR6ehQ+8b6ORKn/9bkVURDiHTamh5FocbgyO61PwSh4LcYz8M64OTisel5gTLjtZvPh6l1M7UxRmnhEyhcgiBgJTNRMVVR9VIWrM9pMgHbp30orD41H4nBTUWz2OkEJZ4qagPhPlqaHN4CbLSJd3bTsc21LjKSPz3LlFe3lf/Y3ZDzhU6rYO8U7ZbmTr4umTFW3w5E/tjLmLpvCF8zwpHnoJkUQgZVzFrB6l8vsI5GwYQFILQGqlEhNi84mcttlEbeNLfVBbba+DKRpV/aNI00eta5tRr40rWDC46husKfeZuQFIqiYZaRS6q2AckzgRKIFvkvuzrVJxmbnKxL7IGVhzN9BfTZ8/+rILoIO/kAn2+F9ApMyu9Lx+87nKwFMs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] cgroup: zombie leader skipped in cgroup_migrate_add_task()
  breaks PROCS iter [1]
--

commit c9380747740bff9194e7da450313ada190919d85
Author: Chris Down <chris@chrisdown.name>

mm: memcontrol: don't lose track of exiting OOM victims

This commit passes CSS_TASK_ITER_WITH_DEAD to css_task_iter_start() in
mem_cgroup_scan_tasks() so that exiting OOM victims remain visible to the
OOM evaluator until their mm is torn down.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d16f..cb7cfae9ce5a6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1451,7 +1451,13 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memc=
g,
>  		struct css_task_iter it;
>  		struct task_struct *task;
> =20
> -		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
> +		/*
> +		 * An OOM victim can start exiting well before its mm is
> +		 * torn down. Keep it visible so oom_evaluate_task() can
> +		 * back off while there's still memory to free.
> +		 */
> +		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
> +				    CSS_TASK_ITER_WITH_DEAD, &it);

[Severity: High]
This problem wasn't introduced by this patch, but can a CSS_TASK_ITER_PROCS
scan in mem_cgroup_scan_tasks() [1] miss a migrated multithreaded
process whose thread group leader has already exited?

When a thread group leader exits while sibling threads remain alive,
exit_notify() sets PF_EXITING on the leader and moves it to its css_set's
dying_tasks list while task->signal->live stays non-zero.  If the process is
then migrated via __cgroup_procs_write(), cgroup_migrate_add_task() skips
the zombie leader:

kernel/cgroup/cgroup.c:cgroup_migrate_add_task() {
	/* @task either already exited or can't exit until the end */
	if (task->flags & PF_EXITING)
		return;
    ...
	list_move_tail(&task->cg_list, &cset->mg_tasks);
}

Only the live non-leader threads move to the destination css_set, while the
zombie leader stays on the source css_set's dying_tasks list.  Because
css_task_iter_advance() under CSS_TASK_ITER_PROCS skips non-leader threads
and yields dying leaders while task->signal->live is non-zero,
CSS_TASK_ITER_PROCS iterators on the destination cgroup (including
mem_cgroup_scan_tasks() and __cgroup_kill()) skip the migrated process
entirely, while iterators on the source cgroup continue to see and act on i=
t.

[1] https://sashiko.dev/#/bug/linux-5cd0ee80-1266-4ed8-90b6-cb34245e0333

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/avALaDR1_epaAfOp@ch=
risdown.name?part=3D1

