Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44AFC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127106B00A6; Mon,  7 Sep 2026 08:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105A86B00A7; Mon,  7 Sep 2026 08:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014EA6B00A9; Mon,  7 Sep 2026 08:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB77C6B00A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:27:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EA491A012A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:27:22 +0000 (UTC)
X-FDA: 85186891524.01.C9B1E4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD1084000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:27:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hBJkmeHo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FON6q6qStRwddcTjTo4OO7kzte1WdlEtk70KYE6DEZc=;
	b=zJ+rQWrm2c+KKXS1QuF504ZH1aNB2bGusnUlxBKh0IAQdR4Kmxg1oOsegRZP9y/SOjI5Dt
	sg+Jl1LPhZs5Nh0qj1FriDGXheBIDScGBXY1ivSqv+ZG0MDYJukSlq6n6GhXCsbxmEN6YT
	JUi89yDagUumfn9k2dyYV6z3crW9rEc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hBJkmeHo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784040;
	b=ELWvgbEbO8iCSFI9lP4ql7lTtOG6f0zpN0wYcgetg/HUhy1+nRKjYw6Pu/H7qE2Y7/4sjn
	kYCh2oPWjgmLfZEPn//1zA8/oZUicv0rjHcKmNn7rRXW9W5et5qT+TUDFSIBzlDCgXr2mZ
	htTU95IRwKEx51ffGtAq7JW8QlL4+zI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B94A43FEB;
	Mon,  7 Sep 2026 12:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8107A1F00A3A;
	Mon,  7 Sep 2026 12:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784039;
	bh=FON6q6qStRwddcTjTo4OO7kzte1WdlEtk70KYE6DEZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hBJkmeHoo3adk3zkUC7eYlw8h/TJyFQC7PnBfhei3eMbML+nMpxFUdoab8vEGHrC8
	 qv1TOSO6hpNr8vp5zd2I50DVcVBN2gbGEAaCVwtfnjCLuQaAOdZeOlXR/p7+Z4JKeP
	 9TN2uOi8STQr/J/OHftEHtUR0UvWj+6PFSAan524lD3d6akZQ7EehNCueclrUrGHOR
	 8ejbl/+TwuNme7llFf+Fy/j3D1/HZyvT3e7tKvC0GorCTf0v4LFtXuURtE7JiUbqv4
	 nlEE6828TnKP1RT6mAXgU/uOPKyk9IkmccHdH3cVzbR9hDg5I7E6j9AKneb4a6l/SN
	 0ymItKMeX+E/w==
Date: Mon, 7 Sep 2026 13:27:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, x86@kernel.org, Christian Brauner <brauner@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, "David Hildenbrand (arm)" <david@kernel.org>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Ye Liu <liuye@kylinos.cn>, 
	Michal Hocko <mhocko@suse.com>, peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, 
	rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net, tglx@kernel.org, 
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com, 
	sj@kernel.org, rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, frederic@kernel.org, 
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, lance.yang@linux.dev, 
	mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 6/8] fs: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap6tk14FFBAYaQNe@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-7-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-7-ye.liu@linux.dev>
X-Stat-Signature: ca5e6o8jhyh1bza9efb5npbgpqmti3un
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD1084000E
X-Rspam-User: 
X-HE-Tag: 1788784040-305889
X-HE-Meta: U2FsdGVkX180Zd3CSO9axnQ4N5QcW7aeJbkoFlAO5EAT5fzVYLKO5RxVGrubHML+tEawK5k/t6/zeobR2GmX6nPrm1AAz30T2+9iH1xtebHGZlrwoG+pcgXdt0ap7gMFupk+PGUlA+WapvQprmpFCSw69RDZjrHca4b3dZTDWyGgniMWBD+ssYFaCB23b14HrjZSi15qsJtq6wWKCDVxL3O4cvc1qBVwpLkZdMY4gDykqzxtXOpEj8d9AhjK8zzH3PbVWCIZy+qa03fctqxaWs8YXzkKD/UrOr5sYg1MAcNm2ktYmQe1NiSGkkKktrUC2f6rO/xs8SePHi8YqT0AnDnn+JesLH3T94ukBF2l1+fvivj2fTt8FAtW+SLHA0OTNPuH/X8R4GhOf+8pWg+UbWssEftoeztUhSxtps4wGezUVBlFw2LtmZVM4FO/A2QEb3e7WY9wIX0ketoS5TJdQTQrEVij47bVbRMU/xFN99HZzeyqyFtCm8ULSjg0X7nWEhhqz5SOkzC8SBUuawEdtlSFoyVNWEKLTkpc4Yw6+2Szqw4AlF7v/abDelkeS0w0rgbeVANj56ntRrOmESc7LrFxv6qmUvZci5rSjdGVeE0mu466K8YMWFOyY99NkTTfstbNXgeyUzTjoQtpvK0MCTr9oLDxSnoDjUjWOBrySk2JXIzYXGEovsl+jIsdBdyRgSziOk7VBnfIyBnTAYUrybXpZpZM/Nji2Fl/sUk33ksfcrGV2Xxc/7bheTR55xwohFom/Nl0RyaENDgaWUvxWPLm9tpSXH8bgcYRcmw9HD4XOF5ZC2JHxshoDnc+ehPazn1kSgYewYoLZlCjWKgvVA2XXxHvhb/HotWqrmOM67XY3wlvUPBduCjPdMvDGbiCC1SY6zOJfsYObCBsy832UOGLgQ0IStfzLS1mqdANZNStGg3a1+Ix17/pRRuR5qMRw8X3gggRHTQBGLsUluB
 jozuZXyB
 UcqJ+aXSgVjYawmvdVP41SeSr3sOcPHeD6N7L6NclLEW6QizeXGObkCDdLfPAkgg7tXrail1yMVogDj4lTqUkpTROt8DjW2yDfcDD28W5XQ/uSfrL4FuIUbsGXkHiORrn+1zru8QhFGWbAA52RgYW6xO+9XoVJxUP7oD7NgtJbbvZFAcglqIxidwmk5JWs/nDYsQY0pQMSJ4TNDZIhkMwoa8oSqNLmNnz+akB/WKOWSO7kyU9zi2bV7ow/vX1fZUR7ibfPgtdt4dUHX/2U3qco32OdlAbYltx2xvZuJQw9sTZ4sFX+6pLhPlf3gWH5Ln0WYIbAgScZ7dOnrABQ9CRJr3gW/7qIsHS/ukh2lFbDbqZKDh8YU7k7wd8vcuN76slNBDPdRb4moQdvLErEXvseWwI5vuH5BmQo6UgYxcObfKOt4DMIXl6X+rd8XMP+Vczcq0PAaBl0oRJZqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:32PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() and for_each_process_thread() loops in fs/
> with the for_each_*_rculock() macros, which scope the RCU read lock
> to the loop body via scoped_guard(rcu).
>
> No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>  fs/proc/base.c        | 4 +---
>  fs/resctrl/rdtgroup.c | 8 ++------
>  2 files changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6a39de424f62..3de4f4557e4c 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1160,8 +1160,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
>  	if (mm) {
>  		struct task_struct *p;
>
> -		rcu_read_lock();
> -		for_each_process(p) {
> +		for_each_process_rculock(p) {
>  			if (same_thread_group(task, p))
>  				continue;
>
> @@ -1177,7 +1176,6 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
>  			}
>  			task_unlock(p);
>  		}
> -		rcu_read_unlock();
>  		mmdrop(mm);
>  	}
>  err_unlock:
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5dcbb0a964e8..b14df8b23f1a 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -709,14 +709,12 @@ int rdtgroup_tasks_assigned(struct rdtgroup *r)
>
>  	lockdep_assert_held(&rdtgroup_mutex);
>
> -	rcu_read_lock();
> -	for_each_process_thread(p, t) {
> +	for_each_process_thread_rculock(p, t) {
>  		if (is_closid_match(t, r) || is_rmid_match(t, r)) {
>  			ret = 1;
>  			break;
>  		}
>  	}
> -	rcu_read_unlock();
>
>  	return ret;
>  }
> @@ -826,15 +824,13 @@ static void show_rdt_tasks(struct rdtgroup *r, struct seq_file *s)
>  	struct task_struct *p, *t;
>  	pid_t pid;
>
> -	rcu_read_lock();
> -	for_each_process_thread(p, t) {
> +	for_each_process_thread_rculock(p, t) {
>  		if (is_closid_match(t, r) || is_rmid_match(t, r)) {
>  			pid = task_pid_vnr(t);
>  			if (pid)
>  				seq_printf(s, "%d\n", pid);
>  		}
>  	}
> -	rcu_read_unlock();
>  }
>
>  static int rdtgroup_tasks_show(struct kernfs_open_file *of,
> --
> 2.25.1
>

--
Cheers, Lorenzo

