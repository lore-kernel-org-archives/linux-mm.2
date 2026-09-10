Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C92FBC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B946B008A; Thu, 10 Sep 2026 18:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5CD6B008C; Thu, 10 Sep 2026 18:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4C86B0095; Thu, 10 Sep 2026 18:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 414BD6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:51:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4F63C05FA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:51:01 +0000 (UTC)
X-FDA: 85199349522.15.651E2F3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id 09E5F1C0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:50:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eWkB5sEd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789080659;
	b=YpVEn9dfJh9hVr5nJgVroohxEo2RMqIil7IEgUIi5RLaVLrAHpDLw0fOolaR54a9YLQFJh
	LzTsMjMA8AlX0GUSGYwfK2VpFF5iJ6vPN2ME/aqBgEIwKXApYTb5niUo9+7DGphN5RkyL+
	z+w2nm7Yzp5VuGNYTcjJc8FL4FJ53zk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eWkB5sEd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789080659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CL1avPpMMrkd+vpqi8+JGikW55h470TbWac1xw9X/U0=;
	b=gjmoPmtWL6Ayo9MfXF5wdEd/HOeO+g71IVhYqvlCdDArPgEswoEzKuvyxXmZ5VBg127Ooo
	bTq0WfLK5C5p9jUg3QeLo5Wbc73sTeEsf7y0UeAFIrw0TurnN9xQeQhC/pVn3MXQEZmMo0
	7g+YaZu9Tq8ioxx2D4NT3waaAxMMqTw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789080659; x=1820616659;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=P7maDS07+h6HnjGuJWTSO8SdcPWU542f5xnMtj80oOY=;
  b=eWkB5sEd5U3Xl+pnLKh/qoqvy6Vg7EnmhNZwG3398MwsGjrnE0E3/yd1
   xIS/quIvnJtW8xdaYvSkdtCMNImktWpOqRM3+noM4P0GQtW/l5qMtBZi6
   robbsSIyPr8vbDe8TbZEdyLk3eI/bW01v6sQd0YpJpn+vZdCWtYs+lMM1
   SxGtAuBm9IlCE+bRMyq/o/NM+m0Ea2dVULeuqP2pXZg+Pmm1UOCILuv8l
   kqt616qGdK8cJdhe+VCr64RiY779Dxe/WY81ZhhiQcRv87GgXjPQvyy/b
   jXLa4Ohlw5xsGsPCrTUNgmdxr5KDFSuNkfM8B32tUOrnwZgo75VTaKTGr
   g==;
X-CSE-ConnectionGUID: zrIAc+0sTI+zu/LNmctoJg==
X-CSE-MsgGUID: x+0FjfJ8SSOL0okPd8GbAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89558407"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="89558407"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 15:50:57 -0700
X-CSE-ConnectionGUID: q2AyFywVRruYetA+j99ZxA==
X-CSE-MsgGUID: F1zayvQTTme62BN39KwMHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="275285741"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 15:50:57 -0700
Message-ID: <72bd9014ee83d5833bc1c78379ead84458045867.camel@linux.intel.com>
Subject: Re: [PATCH 4/4] sched/cache: Introduce task_struct->sched_cache_grp
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt	 <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman	 <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, K Prateek Nayak	 <kprateek.nayak@amd.com>,
 Kees Cook <kees@kernel.org>, Christian Brauner	 <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara	 <jack@suse.cz>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Qais Yousef	
 <qyousef@layalina.io>, Aaron Lu <ziqianlu@bytedance.com>, Srikar Dronamraju
	 <srikar@linux.ibm.com>, Vineeth Remanan Pillai <vineethr@linux.ibm.com>, 
 Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>, Chen Yu
 <yu.c.chen@intel.com>, Lu Wang <wanglu.priv@gmail.com>,  Hyunwoo Kim
 <imv4bel@gmail.com>, Zhan Xusheng <zhanxusheng@xiaomi.com>, Zhan Xusheng	
 <zhanxusheng1024@gmail.com>, Yi Lai <yi1.lai@intel.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Date: Thu, 10 Sep 2026 15:50:56 -0700
In-Reply-To: <20260910191901.GW776954@noisy.programming.kicks-ass.net>
References: <cover.1789061845.git.tim.c.chen@linux.intel.com>
	 <4532ec4fd5beb829bccb85822a19360fa4191fe6.1789061845.git.tim.c.chen@linux.intel.com>
	 <20260910191901.GW776954@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09E5F1C0003
X-Stat-Signature: syt41bxa77hno451gutct6pa566k3ia4
X-HE-Tag: 1789080658-474254
X-HE-Meta: U2FsdGVkX1+Fz2oqBdJ9T4j5NxaMRcWRMZHSMc9oGPh8cdQ6gQC16uRF+xs7jV6dii3gm3YZ9WFM0Xbhn8J31EJqkGAS46N3ziji4OGtQ6szPlsjRS5/t8pcbjVjQAGHTBTYACe21N2rSy5A/j+ljGgab2+H1hiKO8AUS3uWs2+Cz31b9/qtl6bUpKBtPCJ/Cr6DzzaLl6LkxHj8iU/Eh/SfUooh+8vTfD51YYaD4+67xuSzwRaiDwDl+KOldwR3chAFrJHJ1GINLjBId22gw3fadG+QsOnwb+w81R3N5q/eMV4/vx1bc0PA9AZ6mPDsmkXuMC496bAEraVu7rARILVKI5ZDMO5lUvJANeZRZ+pNgKO3MTnGimb9frE6yI8zZVAlqVu6hZRmmGij5oTtpvXt3DKx/zp1F5M3ddZT7dBiexUOW6yopf6BKbettyTUgP4wuRF2kPiT0nblx1o2IR3AeE4bIsiH39891dNxcCSXcwzvGLnd3CMRjz8WE8BB+Qd+X1DB/jJxsX8oPaXXvdRj6xoZYMQbVUAIGxTscbNkS1Ol0JxbjHtZIR6P1h/jEsqE72wZ53bFnW3P2DV6cqOBbGQei6NO+ulrDmvs3fm7Wp7nv3AopWzNzcO1RgVU9b6QioZzaoRp7nT1+CThaFsPbg74+NzbmBHO/DExN+MVQUnS1nxwUX9Tm48+Zf/qJbldoS4hE8JRoLwjBX9ADRPb+Cc71mQ1xli3kYuaeHaSRTmEfXHpAJvCu0hGCRmY3nb0qgO8jefp4YAsERyaKWm9SsRUxXHe0mzO9dOwXUTqdxCBatwMH5zw9MY+miySyUZygcwKTtMadxww8F1CgLzQdjCFHadWK8g80a6HU0TZKrnzmBFo1FZU+e9o3QrVWelTZJllJqENDnfQgo7cx9qTdQjRYulzCHPbLpJldfmfUk0MI3CM+beIMDjjcg71oLL2NGLkIKKIWV6/2Wc
 BQ4AyMbm
 KFk1F5riQXleK1a1Xu+UuuyNcNcdxOc0mUvhG3XO/NpsqtMMqHwSV3rbSnklH+u9voB5yoS0/AVmsTWSa/XT7aqIEbOJpBYi2RiQLv1Fi45grWjBXGAf90pNXfZYDV4dZT2QBhaZdMK0Lmj9nYh0vp52Vt44yUbizVahIwG3AkS1Ojp1FxzTn5QgdNjTuOuVGzjDVA8dMtvNX1+cs49lLJXUD/MOOxkdSDCmj00ALwAPcxdmvMM2wcrtgr3EAL2WqQ4ne0wuswxflI3Dr+Zf1DJzxf/Wt0cltJ+OnQdpa8OglTW9ECiBBlWDbx+aERpexg7lM91bOmaXZNG90TFrLd5sl/T4yyEeuzMp6TQQf5HPSybs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-10 at 21:19 +0200, Peter Zijlstra wrote:
> On Thu, Sep 10, 2026 at 10:46:12AM -0700, Tim Chen wrote:
>=20
> > Co-developed-by: Chen Yu <yu.c.chen@intel.com>
> > Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
>=20
> :-(
>=20
> > ---
> >  fs/exec.c                  |  14 ++++
> >  include/linux/sched.h      |   3 +
> >  kernel/exit.c              |  26 +++++--
> >  kernel/fork.c              |  23 ++++++
> >  kernel/sched/cache_sched.c |  19 +++++
> >  kernel/sched/fair.c        | 142 +++++++++++++++++++++----------------
> >  kernel/sched/sched.h       |   3 +
> >  7 files changed, 164 insertions(+), 66 deletions(-)
> >=20
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 745f6eb5279e..7a8a9954343e 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -882,6 +882,20 @@ static int exec_mmap(struct linux_binprm *bprm)
> >  	active_mm =3D tsk->active_mm;
> >  	tsk->active_mm =3D mm;
> >  	tsk->mm =3D mm;
> > +#ifdef CONFIG_SCHED_CACHE
> > +	{
> > +		struct sched_cache_group *old_grp, *new_grp;
> > +
> > +		old_grp =3D rcu_dereference_protected(tsk->sched_cache_grp, true);
> > +
> > +		/* Acquire the reference before publishing the pointer. */
> > +		new_grp =3D sched_cache_group_get(mm->sched_cache_grp);
> > +
> > +		rcu_assign_pointer(tsk->sched_cache_grp, new_grp);
> > +		if (old_grp)
> > +			sched_cache_group_put(old_grp);
> > +	}
> > +#endif
>=20
> Guys no! This is horrific crap. This is not how we do things and I would
> have expected you all to know this.
>=20
> Have you heard of this new fangled thing called a function?
>=20
> Imagine all of those being just:
>=20
> 	sched_cache_exec_mmap(tsk, mm);
>=20
>=20
> Also: rcu_dereference_protected(.c =3D true) is another offence, that's
> just wrong.
>=20
>=20
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 006edcc0c2c5..442535778ce1 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -552,23 +552,25 @@ void mm_update_next_owner(struct mm_struct *mm)
> >   * Subtract the memory footprint of the current task from
> >   * mm.
> >   */
> > -static void exit_mm_sched_cache(struct mm_struct *mm)
> > +static void exit_mm_sched_cache(void)
> >  {
> > +	struct sched_cache_group *grp =3D
> > +		rcu_dereference_protected(current->sched_cache_grp, true);
> >  	unsigned long fp, sub;
> > =20
> > -	if (!current->total_numa_faults)
> > +	if (!grp || !current->total_numa_faults)
> >  		return;
> >  	/*
> >  	 * No lock protection due to performance considerations.
> >  	 * Make sure the group footprint does not become
> >  	 * negative.
> >  	 */
> > -	fp =3D READ_ONCE(mm->sched_cache_grp->footprint);
> > +	fp =3D READ_ONCE(grp->footprint);
> >  	sub =3D min(fp, current->total_numa_faults);
> > -	WRITE_ONCE(mm->sched_cache_grp->footprint, fp - sub);
> > +	WRITE_ONCE(grp->footprint, fp - sub);
> >  }
> >  #else
> > -static inline void exit_mm_sched_cache(struct mm_struct *mm)
> > +static inline void exit_mm_sched_cache(void)
> >  {
> >  }
> >  #endif /* CONFIG_SCHED_CACHE CONFIG_NUMA_BALANCING */
> > @@ -585,7 +587,19 @@ static void exit_mm(void)
> >  	if (!mm)
> >  		return;
> > =20
> > -	exit_mm_sched_cache(mm);
> > +	exit_mm_sched_cache();
> > +
> > +#ifdef CONFIG_SCHED_CACHE
> > +	{
> > +		struct sched_cache_group *grp =3D
> > +			rcu_dereference_protected(current->sched_cache_grp, true);
> > +
> > +		rcu_assign_pointer(current->sched_cache_grp, NULL);
> > +
> > +		if (grp)
> > +			sched_cache_group_put(grp);
> > +	}
> > +#endif
>=20
> Seriously, WTF ?!
>=20
> > =20
> >  	mmap_read_lock(mm);
> >  	mmgrab_lazy_tlb(mm);
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 416758c8a3d4..2e79548cb7c1 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1599,6 +1599,19 @@ static int copy_mm(u64 clone_flags, struct task_=
struct *tsk)
> > =20
> >  	tsk->mm =3D mm;
> >  	tsk->active_mm =3D mm;
> > +#ifdef CONFIG_SCHED_CACHE
> > +	{
> > +		/*
> > +		 * A task holds its own reference on the group, separate from
> > +		 * the reference held by its mm_struct. Acquire it before
> > +		 * publishing the pointer.
> > +		 */
> > +		struct sched_cache_group *grp =3D
> > +			sched_cache_group_get(mm->sched_cache_grp);
> > +
> > +		rcu_assign_pointer(tsk->sched_cache_grp, grp);
> > +	}
> > +#endif
>=20
> And again.
>=20
> >  	return 0;
> >  }
> > =20
> > @@ -2599,6 +2612,16 @@ __latent_entropy struct task_struct *copy_proces=
s(
> >  bad_fork_cleanup_namespaces:
> >  	exit_nsproxy_namespaces(p);
> >  bad_fork_cleanup_mm:
> > +#ifdef CONFIG_SCHED_CACHE
> > +	/*
> > +	 * copy_mm() took a task reference on the cache group; a failed fork
> > +	 * never reaches exit_mm(), so release it here to avoid leaking the
> > +	 * group and its per-CPU buffer.
> > +	 */
> > +	sched_cache_group_put(rcu_dereference_protected(p->sched_cache_grp, t=
rue));
> > +	RCU_INIT_POINTER(p->sched_cache_grp, NULL);
> > +#endif
> > +
> >  	if (p->mm) {
> >  		mm_clear_owner(p->mm, p);
> >  		mmput(p->mm);
>=20
> Drugs, it must be drugs and lots of it :-(
>=20
>=20

Sorry for the warts in this version.  Will clean it up and send
an update.

Tim

