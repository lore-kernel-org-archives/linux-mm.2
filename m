Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C786AC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96406B009E; Wed, 16 Sep 2026 09:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46BA6B009F; Wed, 16 Sep 2026 09:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36F76B00A0; Wed, 16 Sep 2026 09:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEB66B009E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:02:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 329531A06FC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:02:51 +0000 (UTC)
X-FDA: 85219640142.27.B61B6B6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 17AB11A0009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:02:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YtFeZrsn;
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563769;
	b=XdpyUy5JwIeEgUiTSzOT1+D6aVoA10A59pS03Kv577Ox8AMXZrHgrQnCc2DHQ19cW9JEy/
	RM9oaa+w3Z2AKBwWFoJ/TfRtPFcmMhyEB3R4Y8uEJ03b26G8ZSy22a3X4PAT/vLDIRVPi6
	9RjRT74XAP613HJOudzNwWUSFsfKFT0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YtFeZrsn;
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bywUojkkDxv7YhCqZv+tPm5XeEwqdNL7YKjmi3qlnMo=;
	b=kw6BjD+hRKBcaMhpe0eTQmuwFXJZKs9fwWrqxfugWCZckPo668VeSQhM/QqS5mAZQ3jDQO
	XiGLLHkdYBL8UL/vVtWikUjHmZFWz1XidbDph0sINoR8Mv/unYmcpGwGf+qVt82iiXExIK
	w16fgD0G/N68CfxhYqFbkUGWjEOIlFU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bywUojkkDxv7YhCqZv+tPm5XeEwqdNL7YKjmi3qlnMo=; b=YtFeZrsnU+A7BU1JaX4MyXUmv0
	Afu3u0xlzKl09/oYqpikzQAlV95NIXZVXjc0zFmWkjmIgY73Q37I8wvWN0GbTkXOjuuNQ2PjHAp/o
	TSIp1/ZpiG+WTquDJjQCFQZ9TDty73m7pQijpYxw//tytzQqs7rqvrs5BOInr+ho68tZOsra2OE+u
	RzQpdzqBLqC7ZkvTRIdt9tWetnBoa4CFxkc2J1jtvmvyR/STiXUfZa0cAxDtDcO254OOsE+Piectw
	zYpreQeVIdF4Vsz4cACf3CfOOuR6eTqOBfgKt+GqYfiTbsDnLcMtQt6vKWnoMso93wLRnPkfh5A7S
	2mfphi+g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6pHY-00000004VjY-1lcM;
	Wed, 16 Sep 2026 13:02:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F144A300328; Wed, 16 Sep 2026 15:02:35 +0200 (CEST)
Date: Wed, 16 Sep 2026 15:02:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chen Yu <yu.c.chen@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Lu Wang <wanglu.priv@gmail.com>, Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] sched/cache: Introduce task_struct->sched_cache_grp
Message-ID: <20260916130235.GG776954@noisy.programming.kicks-ass.net>
References: <cover.1789061845.git.tim.c.chen@linux.intel.com>
 <4532ec4fd5beb829bccb85822a19360fa4191fe6.1789061845.git.tim.c.chen@linux.intel.com>
 <20260910191901.GW776954@noisy.programming.kicks-ass.net>
 <72bd9014ee83d5833bc1c78379ead84458045867.camel@linux.intel.com>
 <aqgF7JHKxQaE0W4b@chenyu-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqgF7JHKxQaE0W4b@chenyu-dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17AB11A0009
X-Stat-Signature: w8q5i6mrbudugyd3jpduhq7ebzz1x8ww
X-Rspam-User: 
X-HE-Tag: 1789563768-159054
X-HE-Meta: U2FsdGVkX1+SZiVnV5kogdOJ7N+pAVgVt1h7eIuvRM8C57CLZNJ83aRjilrcLONH8oDb4XSBKpB5vQUKTAX3u1FmBDrnM56OQ3P3gQX/cDKoZHkF2THOcDJd9Ah0lgqXZ5M+pehp8ygCJCk5uy5W16brKvR6Qgk/9AuGVG/JSAB+DJ1P4mRew7KzApySa7iHUHVR1m7exYxEn2uD0uuELENtKvjROoRnCKxM6GaH9DWc4TcinvDoth8MZdmjyvoC6APq7PoObR4xMVl/SG7SeuhpaQ7tlP+7m0p4C5VidqVeJ/ks22v+RM+tR5E14oTb7vRgPZxmb7yT85qNzMLNU0bD39efPlMTyPRENnLzoS7LV2/ejxcVQqN+Y5MW1qdqEnSVDyWvXqFVlw/OPphtef0su7cqjCxVVKiYtUX39wbf1B9w9B6fG/3UUEh3YWptVjLTWL6v9OpiHTTGY5F9Ix3M+G7p8axrSBbxnOawMdglRH9gIL/+fUdxYOaur53XuT0XPaE2jydhTsNr5IS9o/tojW23gwqmYP6F3agFG1x51TfWi1cGRcwNE5aShEht4zSQEEGMA68OZ0Arxvh7J7il5kpCr4F+Hojak/tNNGNkNYMgQbwAzukmeBXitFt0jU/G91qM34jgMFnEwBFlt5ShwJnz+dmyEFXf5i0MMEpmXKnU8LKHAq+zILIWn/AUIoRgGwlZgY2UMStK255+aojzslrOH26aAmwiepExgedFVwrcSzdydt0pNCVGa4pTs1eRk9X64hY/d9OViIAh55iyzYOq1LFssRe4Av6mfyD5DFnUD149Sp1NW1UJhOgwEfk0KcBtjRDH41W4G2Z7gQTbpJG54W1tcl5KIBmWDD3IUc/IVCujqwFT0FhLx7W+UEkLIwj3TyE+YAEEMQiOMg3sWORJPEH7yPY7nwJ0OPx3uYkklOYgOSDMAlSkw/3BYn1GOG2kTOZtMWWdahe
 kWCz56m5
 U3hupyBeBnoy0odrx684KVR2dmR2Q1FPXsGP+Rm+YeqOfbHf0U6DwE0xiFJ5C5QDjH/zaHlAu6ZWjImRArSTIZBvY0RChqLsKQxEVT/fUp/kHoJhUrDqAJwe9tCs0a8W7lfVV5Z3AVwIzbuAPL+4zhCw99ixuziO4W4zb93BFvLjADYORS+CacM9qV2jkgpsEo+HzxA1BJ6Bc+XWjv87DoAEerHaU0q/7MWNKygklnqZ676qfmRYjemdtPROKrveyJkN8+jq9X5RNpEruzHHTK1lHX0fGVArio/u1xCE/cZv28MUeraJSaKUVu+nPk0i2CM4+MWS9qdgLxdOs7qUVdnyo/Q/5T11UThKOk5m9w32srT4eTZ6VPTC4LJTkNHwqy2mFanHkHtE0BjY5NNiVBmqM2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 10:34:20PM +0800, Chen Yu wrote:
> On Thu, Sep 10, 2026 at 03:50:56PM -0700, Tim Chen wrote:
> > On Thu, 2026-09-10 at 21:19 +0200, Peter Zijlstra wrote:
> > > On Thu, Sep 10, 2026 at 10:46:12AM -0700, Tim Chen wrote:
> > > > @@ -882,6 +882,20 @@ static int exec_mmap(struct linux_binprm *bprm)
> > > > +
> > > > +		old_grp = rcu_dereference_protected(tsk->sched_cache_grp, true);
> > > > +
> > > 
> > > Also: rcu_dereference_protected(.c = true) is another offence, that's
> > > just wrong.
> 
> Got it, will fix it.
> If I understand correctly, the "c" should never pass an explicit const value?

Right, that is a bit of an anti-pattern. The 'c' thing is there to
validate your claim of this in fact being an update side, eg. you
holding the write lock and all that.

> The original idea was that, in exec_mmap(), the current running task is the only
> writer to change tsk->sched_cache_grp, so the condition is true,
> 
> To fix it, it might be turned into the following for now:
> rcu_dereference_protected(tsk->sched_cache_grp, tsk == current);
> like deref_curr_numa_group().
> 
> In the future if task tagging is supported, the race condition of multiple
> updates would require a pi_lock for this task, and it will become:
> rcu_dereference_protected(tsk->sched_cache_grp, lockdep_is_held(&p->pi_lock));
> like what we have done in the prctl based cache aware scheduling patch set:
> https://lore.kernel.org/lkml/50fe2db1a62ea2376a87d0c14778b1ff456d11ec.1787955777.git.tim.c.chen@linux.intel.com/

Right, it might also make sense to have a helper, like:

#define rcu_deref_sched_cache_grp(tsk) \
	rcu_dereference_protected((tsk)->sched_cache_grp, (tsk) == current)

such that you don't have to keep repeating this thing over and over.
Also consider if rcu_dereference_protected() makes sense, I tend to
unconditionally use rcu_dereference_*check().

The only architecture where it really makes a difference is Alpha, and
nobody cares about that anymore.

