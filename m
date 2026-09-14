Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D13C88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 22:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00FA6B0088; Mon, 14 Sep 2026 18:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91306B008C; Mon, 14 Sep 2026 18:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52C66B0092; Mon, 14 Sep 2026 18:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B92F6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:25:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 056101C1DC8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:25:11 +0000 (UTC)
X-FDA: 85213799622.17.3147A45
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4555E40003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:25:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ak+qK659;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ak+qK659;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789424709;
	b=5FDiTsMk+UbNWXEBK3JK1dEjLhqSrtZpehJJ3v3siYmLUoleI6MfmAainURCUHmyewtevE
	Hsz476ufhNe2B02TU0rEufzLo3k26oIyQl/3oS3KkgWwyMkyX3ALruiu56Y1u7tSo4SuQi
	/pbBFyKZAMRNrlwZcJqbWOSLSqIov9Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789424709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkTXiZumtDzAasBazKVpGXLjxT6F3SF+2Qwzh0Zou+w=;
	b=Al9C2CnWXPmG/b1BkT+EmAPfd4hnnzfxq5no6nafm5ZhIwmnWaonsJyfTShTFXUYATuuzC
	Uv65aoCCR5IwSLDVrf/p8XAyKTtUHu93ZZ765tbDOBPoeKEJS6Yj21XkNSCy556qlXaz4l
	fsfce7OZCgMAYx1znrM++FQNInog+eE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789424708; x=1820960708;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lRwyLDKclG5PTkKiaCP0WfETw35RY2cC30b8ggFxCpg=;
  b=Ak+qK659A6xqDuMlycmnmB71vBLGJ4mLmIi7GNW9PGuNE1BZ+YlRHKeE
   1TpnJSIk2ZY/M5u0n1apHREmBct+jSoui9WO7mCN4hLQJOSPCFwWfvdf7
   ECJfIR2hl30KjvZLYJqZBcWV1uIxWKKAmx7jxR0xcRHjpCa0Pp+5462/+
   i64CZ7ozVRR3VBhW2+TT4f4+T5wajCWsynL1yKguGXLHmHr6yiPqjilc6
   3OKvvuGh0bR3bUZbaVFm3zBD0t2StfQnxBUPbZOBecvuXk0K+p+XzeR4N
   HCz5tdXH8fxPl+0azqp/un1VEmgzfoe76w934gX/Dk1fm0BZ6VUWpzfSo
   w==;
X-CSE-ConnectionGUID: jbCI0wwHSiqCeDwSVSqvcg==
X-CSE-MsgGUID: pu2DxybYSwy0ACghKUaeuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93608058"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93608058"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 15:25:06 -0700
X-CSE-ConnectionGUID: o6rW3JWLR0yDEFjVHAANFA==
X-CSE-MsgGUID: AxBYWUm+TPqDVSYWsw29zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="274710260"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 15:25:05 -0700
Message-ID: <025bdcdef34170b1ffcc673c6b59cb51abc8fef5.camel@linux.intel.com>
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the
 runnable domain
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Chen Yu <yu.c.chen@intel.com>, Kayra Cizmeci <kayracizmeci@gmail.com>
Cc: brauner@kernel.org, bsegall@google.com, dietmar.eggemann@arm.com, 
	imv4bel@gmail.com, jack@suse.cz, juri.lelli@redhat.com, kees@kernel.org, 
	kprateek.nayak@amd.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de, 
	mingo@redhat.com, peterz@infradead.org, qyousef@layalina.io, 
	ricardo.neri-calderon@linux.intel.com, rostedt@goodmis.org,
 srikar@linux.ibm.com, 	sshegde@linux.ibm.com, vincent.guittot@linaro.org,
 vineethr@linux.ibm.com, 	viro@zeniv.linux.org.uk, vschneid@redhat.com,
 wanglu.priv@gmail.com, 	yi1.lai@intel.com, zhanxusheng1024@gmail.com,
 zhanxusheng@xiaomi.com, 	ziqianlu@bytedance.com, chen.yu@linux.dev
Date: Mon, 14 Sep 2026 15:25:05 -0700
In-Reply-To: <aqdVpO66OfmHvvqB@chenyu-dev>
References: <f3b70dd40e29b309ff3449a95a4af4513ad0ef70.camel@linux.intel.com>
	 <20260910220331.1209469-1-kayracizmeci@gmail.com>
	 <aqdVpO66OfmHvvqB@chenyu-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 4555E40003
X-Stat-Signature: 6sbma6uwkhbjodt31dk5iibdmtxdcxeh
X-Rspamd-Server: rspam01
X-HE-Tag: 1789424708-609047
X-HE-Meta: U2FsdGVkX19TRRfpGE/h27kum0Wf0bdPcsrlPP2hYJcFOxFKCAZ3+mrZ4ZaRb5dOLndLcRg2PbQeUzxklAfMWD2pQ7Ck/1eC2NwHV0ge1PNKqalBx/WwMcxCYSEPc7UJt3aGIb1xdCzmzzLp1+eGNEj1vcLe1vWA7VglXz2ienqm+SLv8RbYs//Bvyh2dPEGgfLrTyQs9TVaEmK98s/DkTOI/87Aczg5ZjnRB6wh9cMcjyCjJP3xofqSmSwJzi+3zjNBIHGfvecke9AmDb4o92CFOV1P2UIk9zDsIAeLRtXCD+YiCbcyd0DR/IwTh96Lrah8mF0urqOeBpKBw5TIQniBQhMOc1N1tqqZCnsYy92Yxe+1UX9bIM1R52zCvPb1EFkgNQX31GoxElW3BBss8nHmzEDcwFX+WFmeUM3G+9bc01+qmNeD6SfcgiXU+geTPd7LJHDtob8DTCJw/uCes8ZkpIvpEJWrOG53FAN2rIppDOZqdpgTdP99TiD72UyW6h6pBhTVr7Yo1RpP3TgLbyD0SKzKmhbQYG/gWGX+ghU2rompgbit9ziyYCsPBgkMh/n615hbHOlDB/oRyG6gaZmV74gg/81b0TLRWP8gqAAE/i4BmP7OV92ryCl4jDgHNOMo/9AabrwdS12Z+Gz0wbezmsqeBWkDtyV6KbJD6U/8uNb/mSGQiyqU4wIOyUcfTSBmHTRwHf6O7sJ9LBIySk+HZID5QAxtM3kvSMW5vrtKDZJEhdUgXVSXS/AJGh96uUtxLwrLTevYXaTFhxteCWBWObxeS9cGpoAx93/wwBxqSYMbCkL5MixDBBL5rwVm31E8sw+9MFidn4R85UmCKU78JxvZpFpqjLijO4o7ZaHfSvqpxG1ACOaIK8HR9uK7I/mkNKcqrAe/tLSgDNhLtjppwWfFOCHWg6PFwy83NdtTCIvokPcnzZ1/EsNOU1uKSN/r6JvBGNre3lbTXHn
 ZNakrWfe
 zGo0e+n5CRDIOhs3kSWliFSiNf5Lo0Ysc0bLiIhT5I/wc4bE0n0DgAecf8Q1btRYUDXwnDDhxve1J+3DbbtFoj94DkG+p2zbnHxrVaw7gIIXGua9oBzh4oks7hO1r5j6+P4/pLK1swbOhr06rg4l49zWQNSD90kkSUq2JFFD+CDn6+pZU1guk/Cx6/yUc9D2g3fzKxBRssJhqv24S1Ch84Dy4cGjpZCnIMU74aDxVGkwwW58apynAFjLgd7ndERWNLQoOWCFP9R8CacI5qktFQMjgdgdii0ujXrFzufiOirjY7oTPxfW6ZNnwn8VDO4AF/4kdc0l1dWHs2Oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-09-14 at 10:02 +0800, Chen Yu wrote:
> Hi Kayra,
>=20
> On Fri, Sep 11, 2026 at 01:03:30AM +0300, Kayra Cizmeci wrote:
> > Hello Tim,
> >=20
> > > So moving the accounting next to (or after) the h_nr_runnable update
> > > would make task_pref_llc_runnable() return false and skip the
> > > decrement, leaving nr_pref_llc_running too high.
> >=20
> > What I really wanted wasn't getting the accounting next to or after the=
 h_nr_runnable.=20
> > If we are updating h_nr_runnable in some way that means we don't need
> > its check since it's already getting updated. And if it's getting updat=
ed
> > that means on that branch we know how our check should behave since we=
=20
> > are a subset of it. We can skip the delayed check on that way since we =
are
> > trying to behave as h_nr_runnable's subset.
> >=20
> > >        if (entity_is_task(se))
> > >                pref_llc_running_dec(...);      /* sched_delayed still=
 0 */
> > >        se->sched_delayed =3D 1;
> > >        ...
> > >        for_each_sched_entity(se)
> > >                cfs_rq->h_nr_runnable--;        /* sched_delayed alrea=
dy 1 */
> >=20
> > For example:
> >=20
> > In this code the h_nr_runnable is updated the same way regarding what i=
s sched_delayed.
> > That means if we want to behave as a subset of it, we don't need the ch=
eck delayed,
> > since we check the delayed to be a subset but if h_nr_runnable is decre=
asing/increasing
> > we should look into our checks.
> >=20
>=20
> I had a try according to your suggestion. It seems that the code becomes =
more complex
> and brings more headache :-( due to several corner cases. The current ver=
sion is a simpler
> version with less code IMO. But I agree it looks a little hard to catch u=
p with, so I added
> some comments around account_llc_dequeue() and adjusted the code sequence=
 of clear_delayed()
> to make it easier to understand. Tim, could you please help check if this=
 makes sense?
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e64d9ad7a108..89311bbadfac 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1609,8 +1609,58 @@ static void account_llc_dequeue(struct rq *rq, str=
uct task_struct *p)
>  	if (p->pref_llc_queued) {
>  		/*
>  		 * Skipped if still delayed (set_delayed() already removed it);
> -		 * clearing pref_llc_queued below also stops clear_delayed()
> -		 * from re-adding it.
> +		 *
> +		 * The nr_pref_llc_running varies with h_nr_runnable, it involves
> +		 * set_delayed(), clear_delayed(), account_llc_enqueued() and account_=
llc_dequeue().
> +		 * The following shows two typical cases of how nr_pref_llc_running is=
 maintained
> +		 * during enqueue/dequeue.
> +		 *
> +		 * case 1 - wakeup a delayed task

I assume both CPU0 and CPU1 in preferred LLC, and task woken on
CPU1.  Should say so.

> +		 *
> +		 * CPU0                                       CPU1
> +		 * __dequeue_task [fake dequeue]
> +		 *   set_delayed
> +		 *     rq0->nr_pref_llc_running--
> +		 *     p->se.sched_delayed =3D 1
> +		 *
> +		 *                                     try_to_wake_up(p)
> +		 *                                       enqueue_task_fair
> +		 *                                         requeue_delayed_entity
> +		 *                                           clear_delayed
> +		 *                                             rq0->nr_pref_llc_runnin=
g++

							       rq1->nr_pref_llc_running++
> +		 *
> +		 *
> +		 * case 2 - LB for delayed task

LB for delayed task from a preferred LLC to a non-preferred LLC.

> +		 *
> +		 * CPU0                                       CPU1
> +		 * __dequeue_task [fake dequeue]
> +		 *   set_delayed
> +		 *     rq0->nr_pref_llc_running--
> +		 *     p->se.sched_delayed =3D 1
> +		 *
> +		 *
> +		 *                                     --------- load balance --------=
-
> +		 *                                     detach_task(p, rq0, migrate_loa=
d)
> +		 *                                       account_llc_dequeue
> +		 *                                         ** DO-NOT-DECREASE **
> +		 *                                         rq0->nr_pref_llc_running

						The above block should be under CPU 0

> +		 *
> +		 *                                     attach_task(p, rq1)
> +		 *                                       account_llc_enqueue
> +		 *                                         ** DO-NOT-INCREASE **
> +		 *                                         rq1->nr_pref_llc_running
> +		 *
> +		 *                                     pick_eevdf
> +		 *                                       __dequeue_task  [real dequeue=
]
> +		 *                                         account_llc_dequeue(DEQUEUE=
_DELAYED)
> +		 *                                           ** DO-NOT-DECREASE **
> +		 *                                           rq1->nr_pref_llc_running
> +		 *                                           p->pref_llc_queued =3D 0;
> +		 *
> +		 *                                         clear_delayed
> +		 *                                           p->se.sched_delayed =3D 0=
;
> +		 *                                           ** DO-NOT-INCREASE as pre=
f_llc_queued=3D0 **
> +		 *                                           rq1->nr_pref_llc_running
>  		 */


Thanks for describing the operation scenario.
However the above cases are not comprehensive and a bit long for comment.


>  		pref_llc_running_dec(rq, p);
>  		/*
> @@ -6415,23 +6465,18 @@ static __always_inline void return_cfs_rq_runtime=
(struct cfs_rq *cfs_rq);
> =20
>  static void set_delayed(struct sched_entity *se)
>  {
> -	/*
> -	 * Drop a task leaving the runnable set. Must run before sched_delayed
> -	 * is set, or task_pref_llc_runnable() would already exclude it;
> -	 * clear_delayed() mirrors this after clearing the flag.
> -	 */
> -	if (entity_is_task(se))
> -		pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
> -
> -	se->sched_delayed =3D 1;
> -
>  	/*
>  	 * Delayed se of cfs_rq have no tasks queued on them.
>  	 * Do not adjust h_nr_runnable since __dequeue_task()
>  	 * will account it for blocked tasks.
>  	 */
> -	if (!entity_is_task(se))
> +	if (!entity_is_task(se)) {
> +		se->sched_delayed =3D 1;
>  		return;
> +	}
> +
> +	pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
> +	se->sched_delayed =3D 1;

This change looks good and make the code cleaner.

Tim

> =20
>  	for_each_sched_entity(se) {
>  		struct cfs_rq *cfs_rq =3D cfs_rq_of(se);

