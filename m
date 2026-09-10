Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 727FCC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 20:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213E96B008A; Thu, 10 Sep 2026 16:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5066B008C; Thu, 10 Sep 2026 16:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6CC6B0092; Thu, 10 Sep 2026 16:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB7B16B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:46:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4DFBA54DB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:46:11 +0000 (UTC)
X-FDA: 85199034942.06.B586918
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1184D20004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:46:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bqyqxrEB;
	spf=pass (imf31.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789073169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tVoaT6bQyZ1RLjzAr3rw9z5iCp+5UJgyxL6HUB6u8E=;
	b=Sw1vPy+GX6C58rJXoTOxLAt/r3bzhE8u4mMbJmr8tRNhU0GYp8lp0FoKgh8YxH9e4W+Ll0
	fTmTlTo8zYOUkZvVfcj0Rg800tPh3qnK6D35/nIG7eCB9s/MwWPCnPVusFAV7pBPe8E48G
	qmolHNaOROtCKzXkBFtKXrbh8KxgaD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789073169;
	b=5LOoMVx00nWbIf244IVT+B+PTkh7VwrHQ+ykEXLhSkOH2pBMgn/Xg0jZwNbtQuwqa+POgV
	wp6tRV1rR2hX8GRd4O8sm4K7aFKfn5Xg3t4WR4yymPnMt+vg6G+Tmy59uZXj7eGsKxNt5v
	R1vTDg4HmPlSBZzFXu5tGy6UnPox2M0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bqyqxrEB;
	spf=pass (imf31.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789073169; x=1820609169;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=u95HbUhQ4RS63Z2SF2toUN8QlmyAdZmVTjoX5PdPJQU=;
  b=bqyqxrEB81rr6z1ybqRdT6/i9UcwBj1ZueQ/DpzDgMJl5Hye3MpsfmbK
   OGUPNRHqDMEcwnq6UVnjKipQ3UJ1PL9i7pVr62VlsAoEft1bf4IsJA4bG
   f4I71ZGjey0pjZ3Rh/CEVYLaUJIa3itnwq6zc6+hHX+e/9QXJTjHaQSpj
   6MmrXJ+JPrASytuvaUFwfsswOwGLf34BmQyMvhbjgz7hM3sLwcS/+dsag
   3EQJK4mM8+5c+RN6IWJpRic7EL8EFznCQdQE92avzzM3dBeHcjthxPuG9
   W4Xpe9yw3RLDqSQ4S+3Tnhyp/sIBoycyQpPd1EYMtIUgGyrEKZbmtYLoK
   A==;
X-CSE-ConnectionGUID: rxqmu6mQTguU07nqHR26Dg==
X-CSE-MsgGUID: UsStdLRZSz+dV1jijJa5nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89659072"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="89659072"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 13:46:07 -0700
X-CSE-ConnectionGUID: 3TVrN5bdR8Sn0EcEiUephA==
X-CSE-MsgGUID: uPHYjxBJSainYFU7HApydA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="295219996"
Received: from unknown (HELO [10.241.243.185]) ([10.241.243.185])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 13:46:06 -0700
Message-ID: <f3b70dd40e29b309ff3449a95a4af4513ad0ef70.camel@linux.intel.com>
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the
 runnable domain
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Kayra Cizmeci <kayracizmeci@gmail.com>
Cc: brauner@kernel.org, bsegall@google.com, dietmar.eggemann@arm.com, 
	imv4bel@gmail.com, jack@suse.cz, juri.lelli@redhat.com, kees@kernel.org, 
	kprateek.nayak@amd.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de, 
	mingo@redhat.com, peterz@infradead.org, qyousef@layalina.io, 
	ricardo.neri-calderon@linux.intel.com, rostedt@goodmis.org,
 srikar@linux.ibm.com, 	sshegde@linux.ibm.com, vincent.guittot@linaro.org,
 vineethr@linux.ibm.com, 	viro@zeniv.linux.org.uk, vschneid@redhat.com,
 wanglu.priv@gmail.com, 	yi1.lai@intel.com, yu.c.chen@intel.com,
 zhanxusheng1024@gmail.com, 	zhanxusheng@xiaomi.com, ziqianlu@bytedance.com
Date: Thu, 10 Sep 2026 13:46:05 -0700
In-Reply-To: <20260910183301.1208504-1-kayracizmeci@gmail.com>
References: 
	<82736e1329bf8ed195bbbc4990486c87094e6789.1789061845.git.tim.c.chen@linux.intel.com>
	 <20260910183301.1208504-1-kayracizmeci@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: o9xeq1itu8tsy6qftibjuj1jxyncwkyw
X-Rspamd-Queue-Id: 1184D20004
X-HE-Tag: 1789073168-258776
X-HE-Meta: U2FsdGVkX18TkduwO+N20wydYQ5rm8Em7/cZjEPh+4BAhDBaO/IL8IwPrmH9Nk7PKPfAfNUrPVlEBCTD4LViYAS6YvQMyBhS27+dPDN4Q1C6mO19ZffndV3Vm+9eouIhburj/XFP0jgBMImPoznkSDCYj9ZC3M6kARBmAKxU35/9jHaiRTBC+8fZX5NVFj1z3HHtMQfFXbPj+zIqA4yc790MJ0o8FVAf+HwARzFu+M7GTB/slHWrd5xoj+Rw1ukrhYO769LO6ZRR1BfWZN6rrw/MNW8sPs9gDADdppgKarIhZBtDWV8EpvQc+m6xPljGUJvvZqoBMYNtQbE6cvOrweTjVFdSrmig6c2+WflYeipGUr66Tok3xENweZTJ3kInV0ZrO7PVgLF7puPZRMqP2f+yE84qOoMfqNQN92k+tOc7rgCpDJ/x9wMXPCSFhVP1BLcQo9RdfX89S99W14colt2HxHDDVqvjQ8A6x52/qsxZnAKTrDdE448HPeZvyUUWNuft51H/24OS3ef64Ywly7tTKCsKFPPf/40A5ELXAAeKpu34LiHeovunqLnPYZwMfDWTxo82P/0KMZvLODchNK55UfklEkdWExbY+I9q2Mhdz5N1LqhBD/b+uUR288ANanp7P/UicS/W8Li25qO0G3bghuUH/oGpnoOVqUGZI7Bq35+BfGSlvfREFJGm4GKe9xoeocYg3YwC2SzhBB/KiqQYeccTHMjE28Icrj3wf4+ZOYmW1Dqze9ug71qBqc0eV+k5772l6ARxeYmaUP5O5hFL1Lve4lcjp3IQLSXe6VgHEOvdzyw5NfT+JTkgSlmpvaShZlVPjj3Qu8KYXj49WjODNQxtN4ZBSzqLGQ0Qvmn31WI61HJVKPmfqS8JjhYFAQQcpIWSbXeCSEVpDlrpKidEx7eNLiQCBGdE6oarx7jJtvg3MUZ/JN6vkQE3KEYCgSVdl4PLqy2OfnQMRmD
 1YyilPUk
 g4wz1SrqTFTI6UVyr54LOF5Uitw09m2x04VqCptEH2Hu6rnAWLQujyYkwKODszWvxfHYRwI2KzLO05b6zSXf9tNtR/jvGqzxsmTbvupAkpxpOkjpkAq0GvTLf7K4rRedrN259ppwAae5Zts6oPwYbBRzIlrepn6EfT8FCZXtaoGhN6/9cEF6A34esrk61pHwnqiqL4EQ/LBRFbHPM73Zi9lzpGG9mpaSxj2C7iHV65HZMtL6rxZEDCfDVg9Z2TE/DTP6MpS4SjFwqaH7pVNkVv7wyyce81hCTmC9z8K72BIdvJ0eVbJn6/Y4vqN9yTKLnVOUrinfi3sNE+YI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-10 at 21:33 +0300, Kayra Cizmeci wrote:
> Hello :>,
>=20
> > alb_break_llc() decides whether to break LLC preference during active
> > load balance. It does so by testing that every runnable fair task on th=
e
> > source rq prefers its LLC:
> >=20
> > 	env->src_rq->nr_pref_llc_running =3D=3D env->src_rq->cfs.h_nr_runnable
> >=20
> > But the two counters cover different sets. nr_pref_llc_running is updat=
ed
> > in account_llc_enqueue()/account_llc_dequeue(), next to cfs_rq->nr_queu=
ed,
> > so it follows queued tasks. h_nr_runnable is updated in set_delayed()/
> > clear_delayed() and drops delay-dequeued tasks.
>=20
> > So under DELAY_DEQUEUE, a preferring task that goes to sleep stays coun=
ted
> > in nr_pref_llc_running while h_nr_runnable falls. The equality then bre=
aks,
> > alb_break_llc() returns false, and active balance is free to pull a tas=
k
> > off its preferred LLC. Active balance only moves runnable tasks, and th=
is
> > is the only LLC check it consults: once the stopper runs, LBF_ACTIVE_LB
> > skips the per-task test in can_migrate_task(). The runnable set is the =
one
> > we want.
>=20
> > Fix it on the counter side. A task should be counted in
> > nr_pref_llc_running exactly while it is both queued on its preferred LL=
C
> > (pref_llc_queued) and runnable (!sched_delayed). Define that membership
> > once in task_pref_llc_runnable(), and adjust the counter only through
> > pref_llc_running_inc()/pref_llc_running_dec() from the four sites that
> > change either input: account_llc_enqueue(), account_llc_dequeue(),
> > set_delayed() and clear_delayed(). Gating every update on the same
> > predicate keeps the delay, wake and dequeue paths from double-counting
> > or underflowing; see the comments at those sites for the ordering.
>=20
> > nr_llc_running and sd->llc_counts are not touched and stay on queued
> > semantics.
>=20
> I have one question tho, can't we combine the checks with h_nr_runnable? =
On the paper
> if we are updating h_nr_runnable we could check if the nr_pref_llc_runnin=
g can be=20
> updated and update it if the condition is right. Because, every nr_pref_l=
lc_running enters
> h_nr_runnable while not every h_nr_runnable enters nr_pref_llc_running.=
=20
>=20
> Why instead we just check the nr_pref_llc_running's conditions on task_pr=
ef_llc_runnable()
> and call these dec and inc functions after the h_nr_runnable updates. Wou=
ldn't it be clear that way?
> If possible?

Yes, nr_pref_llc_running is a subset of h_nr_runnable.

We have to keep nr_pref_llc_running accounting apart from h_nr_runnable in =
set_delayed().
Note that in set_delayed(), pref_llc_running_dec() has to run while the tas=
k still looks runnable,
that is before se->sched_delayed =3D 1, because task_pref_llc_runnable()
gates on !sched_delayed. h_nr_runnable is decremented after the flag is
set:

        if (entity_is_task(se))
                pref_llc_running_dec(...);      /* sched_delayed still 0 */
        se->sched_delayed =3D 1;
        ...
        for_each_sched_entity(se)
                cfs_rq->h_nr_runnable--;        /* sched_delayed already 1 =
*/

So moving the accounting next to (or after) the h_nr_runnable update
would make task_pref_llc_runnable() return false and skip the
decrement, leaving nr_pref_llc_running too high.

clear_delayed() happens to be safe either way, since it clears
sched_delayed first, but keeping the two symmetric and calling inc/dec
explicitly at each site is what lets the single task_pref_llc_runnable()
predicate stay the one source of truth.

There is also a scope difference: h_nr_runnable is per-cfs_rq and
updated at every level of the hierarchy in the for_each_sched_entity()
loop, while nr_pref_llc_running is a per-rq scalar updated once per
task - which is why the dec sits before the loop, not inside it.

Thanks.

Tim

