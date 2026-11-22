Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C753B606A334
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 07:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lJ3nCZd0
Received: by kanga.kvack.org (Postfix)
	id DF05A6B05B2; Sun, 22 Nov 2026 02:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9FC56B05B3; Sun, 22 Nov 2026 02:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5BF6B05B4; Sun, 22 Nov 2026 02:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB2396B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:32:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FE4A1A05CC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:32:50 +0000 (UTC)
X-FDA: 85461938100.20.D634E86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7372E1C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:32:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lJ3nCZd0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795332768;
	b=SdxndbvtyDqNzArKZp7Q9w1kTXuFam08G2DHTgSzFJjQPLR8CxR2zEsGFbydiblsnwGVpK
	Gy9IsdUkzonr5/IM7HynnX6DbK9RH1C46hXukujF0GRCa5oCgKhxoZTuLr3heSpoJIxHot
	A0tk8Sr2hkI1VYKRBOcP7lZPFVPLz5Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795332768;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyD6vZwsbqD1rCnJYnzGCC4kFn6/ifhIz6k1Z/FVYBE=;
	b=MrdyKm/EqDY6nVu2muKuTRR5JFuI14bKDakPZfag0LLFupGQLlVhRAt3pEeA48p5QacSB4
	m2J2JM5u3Z1HO/h+GZq5YDW9M2OHz77CosezHt3Z4DbwwD5CigeGaPnmPu5Dl6Tjdm1yNI
	mIoONDkQyBYOeqKjYB2VYIRHsmNxvRM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lJ3nCZd0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0237438AF;
	Sun, 22 Nov 2026 07:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD531F000C4;
	Sun, 22 Nov 2026 07:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795332767;
	bh=WyD6vZwsbqD1rCnJYnzGCC4kFn6/ifhIz6k1Z/FVYBE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lJ3nCZd0tkBKG+H/14bwIIoF2T52C3dYmp+wXDbhAQ834OdNDgmcIstR5aW/JSlz6
	 J2PO8y3kni4dzglkdA6e3lykQWEw7aKbek9xmRIZAGYWarW0+POXzpWQdY+H+vCrAq
	 t6F+xcAK8ngaLwl0Cj075UrmF1CzoAPIZeWGljV1rjEZFt9pALsGIVQ8qGJWWuz5sD
	 WJWl3oSEs6QmXcWEp9W6weL/YzeOIbjaZEFPrW3/PYDe2r057raVvVhzudmPRFfJLX
	 kvoxH1bg4jh3By06IxlfZ3i17+5gi7TVO/QDYS+e2Gp9rqwcyld1Fb5K2HFXM/2EcH
	 aC4oN044t9q+Q==
Message-ID: <sashiko-outbox-227786@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader
 has exited in OOM scans
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhan Xusheng" <zhanxusheng1024@gmail.com>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, penguin-kernel@i-love.sakura.ne.jp, tj@kernel.org, mkoutny@suse.com, chris@chrisdown.name, cui.tao@linux.dev, linux-mm@kvack.org, zhanxusheng@xiaomi.com
In-Reply-To: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
References: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 07:32:46 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7372E1C0004
X-Rspam-User:
X-Stat-Signature: 4ysi7emsf49ycst9mfe6zpamp5mioxpm
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795332768-652824
X-HE-Meta: U2FsdGVkX19wAsQb24MJ07dVMgFkyHFPWzsgrHs4YfYpAkHXNiNdLy+Jw8X8q+stvLh92lNT7HrteQpH6yKxw5RhHrovAfp3qelj0Vv1f3ruL+t8G/mRfmQ6/B5XhyII5NfVjA01kyVBuvlldC/JV2glhvj2GtuorMVDwFpKKeeOmEJzeFhNnf/uzZq9DkrMHFcLYD+IpXKzRPx5JwDJCEBkyhEHKXbZ5XA4YYMVZFI/R59YO76hJdTScgLZhT1RrqSEjbJkjOmq7KYEIJkFedx94v/y/k+a1+UTKICIRhFCB/T7gqHmowhFyAx2AzhYfQNHAhXQuhrdioBwEVbXuBjhtSqbtxeUB4zUeNmVGVOGafcO6Fb97lDWlWcBdg4S9G3M8YOovAHOVgo+B5jxKXSDfJR2xxOF4Q3uqhLTI24OISmQIC8iiWsxMqgEqMCL3wkU3nsJdkfQkXZr89zdTvr/3tPRV0241ciNwn44XlIt1nDOGZ+6lNSlTGiAqkW3xtbFYGKvwo4IKGz24g6vWMtYUAVloGCyLVaaWzCBN7HtnZCDwj0wrHEmksXwHEu/g6zwn5j8eJApPjBYBav8iG4iAXwUy+3Nakwdj7ASdx0DbIFwnbEPveB9sE95bCrsa2pYrdiSy4yRVc1ycFiAiZwmHe4/47JBPcXl9ZhN7SDAg4fDTkHbafm2BWvs0vbaFKsVzwmZ7uPgyZwws408qG9T8Sc4pj04DxEZX78Q2mUhH/41CnvCtKBNppozIiM6RKb2fsUEwDuPunISX1A68sQnoC27eNsE2l36h7RVXTKlRodq9f4fD1vSR1HC0W3XRlaCA833PuEGUHwj5xpkqt08pULjrmOp7FVHdzo7GLxRMVaccssG4+6yhT8nznrKGL+kw26McVbwrXf2OW8R4rz/cTmJlQz5xme/i2K4ynsXakmYOo8h35I6O/TJ23DXdl1/oAMoNcozc16OIaP
 bLfFfOMA
 LW7pGoCCal62kieZBlZk62flk2BoTFEBBwKzKBkWIDcEeTHr9qCqqD1V5bl8KCQD2tOj6OBfvqUYlM/N4JWQ8ah8JaNLvU+sssoPeaek8gEt/hBsUGoNEjGvGH/vx3XdydacKg8e01fPwIIu06BYzPGGrtHzPKvOQIjioxpobZyNnCMKNl0/rPQLmJc4WHKa8IDQFlXJvCJjp7mpiRQmR3ZRpkl7xETgYfMa4tCg+kcb/fr1MiLuKbyNeaI18r2Bkpc7Tb2pjPRjMTXZA1jzyzlpB9rWBC5JNiaEftpm/DhHWv6bLFFDdsdYKzhbb57s5POM0nL32/PqwfXOEAEtxkidSiv08NKGh7EPGE/Rnbw+x2snDFRDiZTdiBu10RVZFMdvGTJPMOU/uzOBVWEqcTIftkdoJ9iqqJI6Rzbgc7RMZ0wjRjabIPij71MvQQ/FRC6OURtVe+EGi2zPCi63URLhCbdpEZELpYf86VGqIqe4H9qNcUxtHs3/FtvCYxsaxUIXFqT/USPACVgDQPUYlMzsiqkupBaW5OEl6+kXvP6JpGvEUniPffHAPkK5crRSjqjkYDBDtS2iItsCaH7EGwPRObAvyYf02b2AOqlJFgw1XaM0iy9ITbG9hmSKDZ6uIYF2oRO4pycpvXgho3DOpvHkZCy0YhawL+U35IDPk5C9Hh0++BI6lDnr8VOz4jQxs6nOUlK3cqI35NaAa1Vsx5kofWFdgkSMOrTAPyJDQ0JXahNig0QeiQ2L5TE/quwgG9FV7JWI1bKQGFnDQwx6q5x4nFBVPi7mDu9zA37djU7Sgajjgawc30ZfHmWraGFZhI2CprCuPpavZVC5GFN5WF+W5Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: memcontrol: mem_cgroup_scan_skip() exposes left-behind
  exiting threads
--

commit 7a7da7139a4622f1e1e4394bcb56c233c1176259
Author: Zhan Xusheng <zhanxusheng@xiaomi.com>

mm: memcontrol: don't miss processes whose leader has exited in OOM scans

This commit replaces CSS_TASK_ITER_PROCS in mem_cgroup_scan_tasks() with
a scan over all tasks filtered by mem_cgroup_scan_skip(), so that
processes migrated after their thread group leader has exited remain
visible to memcg OOM scans.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index afbb638e7e1cb..3355341666db5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1426,6 +1426,44 @@ static void invalidate_reclaim_iterators(struct me=
m_cgroup *dead_memcg)
>  						dead_memcg);
>  }
> =20
> +/*
> + * Let one task of each thread group in @memcg stand for the group: the
> + * first one that is not exiting, or, once the whole group is exiting, t=
he
> + * first one that has not exited yet, so that an OOM victim stays visibl=
e.
> + * The leader is not enough: a group whose leader has exited can be moved
> + * without it.  Exiting threads left behind in @memcg do not count while=
 the
> + * group has live threads elsewhere.
> + */
> +static bool mem_cgroup_scan_skip(struct mem_cgroup *memcg,
> +				 struct task_struct *task)
> +{
> +	struct task_struct *t, *dying =3D NULL;
> +	bool live_elsewhere =3D false;
> +
> +	guard(rcu)();
> +	__for_each_thread(task->signal, t) {
> +		bool here;
> +
> +		if (READ_ONCE(t->exit_state))
> +			continue;
> +		here =3D mem_cgroup_from_task(t) =3D=3D memcg;
> +		if (!(READ_ONCE(t->flags) & PF_EXITING)) {
> +			if (here)
> +				return t !=3D task;
> +			live_elsewhere =3D true;
> +		} else if (here && !dying) {
> +			dying =3D t;
> +		}
> +	}
> +	/*
> +	 * Once every thread has exited, the leader stands for the group until
> +	 * it is gone, as with CSS_TASK_ITER_PROCS.
> +	 */
> +	if (!dying)
> +		return live_elsewhere || !thread_group_leader(task);
> +	return live_elsewhere || dying !=3D task;
> +}

[Severity: Medium]
Can mem_cgroup_scan_skip() expose an exiting thread left behind in the
source memcg once the migrated threads in the destination memcg begin
exiting?

When a multi-threaded process is migrated while one of its threads already
has PF_EXITING set, cgroup_migrate_add_task() skips the exiting thread and
leaves it on the source cset->tasks until do_cgroup_task_dead().  With
CSS_TASK_ITER_WITH_DEAD, css_task_iter_next() continues returning that
left-behind thread even after the last migrated thread enters do_exit().

Once the migrated threads in the destination memcg set PF_EXITING (for
example, after being OOM-killed there or calling exit_group()), they have
here =3D=3D false and PF_EXITING set, so the loop above ignores them without
setting live_elsewhere.  If the left-behind thread in the source memcg
still has exit_state =3D=3D 0, dying is set to it and mem_cgroup_scan_skip()
returns false; if the left-behind thread is the group leader with
exit_state !=3D 0 (or a leader concurrently migrated out of @memcg after
css_task_iter_next() returned it), dying is NULL and the !dying fallback
also returns false without checking whether unexited threads exist
elsewhere or whether @task is still in @memcg.

An OOM scan in the source memcg then visits the migrated process through
the left-behind thread: if the process is an OOM victim in the destination
memcg, tsk_is_oom_victim() causes the source memcg's OOM scan to back off
without killing anything in the source memcg, and if a migrated thread has
not yet reached exit_mm(), find_lock_task_mm() on the left-behind thread
can still find the migrated process's mm and select it as the source
memcg's OOM victim.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121073222.8342=
82-1-zhanxusheng1024@gmail.com?part=3D1

