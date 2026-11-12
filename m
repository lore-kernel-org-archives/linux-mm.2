Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D056606A335
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 20:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IoRSmR+k
Received: by kanga.kvack.org (Postfix)
	id 01C316B05E1; Thu, 12 Nov 2026 15:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0EC36B05E3; Thu, 12 Nov 2026 15:37:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE566B05E4; Thu, 12 Nov 2026 15:37:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8E96B05E1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:37:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE1B5A0F95
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:37:49 +0000 (UTC)
X-FDA: 85427628258.05.D9D7033
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3692C40006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:37:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IoRSmR+k;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794515868;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yee+wxcLaXMSXZcwc3mnTan8zJx8NOKtHj/C/GekHBg=;
	b=eEpIt0iVeiCNvmHgL8QQ4MlJbtfYmZEVXFDqs2gy1PvrEe0TZgWmtOY+GVHt8IgVC8/dN8
	zdHwNkbg62Qze8J5DqJTrqs1WQX9ud43ssnnnwDShlZ/+h4dam7qr109DLYluF4Ky5e0YM
	jKKSODDtX6b2+Jl5i79arTs7NjPTJks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794515868;
	b=TSZ/ohATWMEj1azAyzYmE9QtrJuEWY5am1Nr1GqnsouQdXUhzPy3AftCcI/gXUxTg7rQha
	HzwMnuvP6RHTr7REusNfutrBm5ASTlHuFrtIenzIE/8tnwUqAqbVx3COoPUjF2vyyrcZeV
	zv5TMesL2yc5D1PpMZRumS+5sgO6s/Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IoRSmR+k;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 784D746429;
	Thu, 12 Nov 2026 20:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E0F1F000C5;
	Thu, 12 Nov 2026 20:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794515867;
	bh=yee+wxcLaXMSXZcwc3mnTan8zJx8NOKtHj/C/GekHBg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IoRSmR+kSj4t/yBRXD+H8lf//npdr/Xr68eYsaOAz6GDvcFvZ/ZqwhuNzkVL4a1PJ
	 OidEi1luy3UhjDAlKJ7831WAn0fWy/LDON7P2uQY5kTW6BMrRj8MUQFyjSkDpC/Lkw
	 gwwBnaUgJsq0dDPVSXukBmMnNo8z/F6EP6ZPI2AbZYVuSc8+uL7z3j1sz3bHHdKCss
	 dq+t59wspSicDf9lOXft45H2wexa2Ryl3RLGfnhi4PdhKz98oL6TCyTrgFkserg4/T
	 nwAqkxMdtUqT/xF2p71USeugqkMyBT+A+dBTrCc0/uRHEaW+beBW96U0Bb66pjFfQB
	 pSxczSib9uYlA==
Message-ID: <sashiko-outbox-211802@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v25 07/14] mm: keep the RSS counters of
 single-threaded processes exact
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "David Hildenbrand" <david@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Martin Liu" <liumartin@google.com>, "David
 Rientjes" <rientjes@google.com>, christian.koenig@amd.com, "Shakeel Butt" <shakeel.butt@linux.dev>, "SeongJae
 Park" <sj@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Sweet
 Tea Dorminy" <sweettea-kernel@dorminy.me>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Wei Yang" <richard.weiyang@gmail.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Al Viro" <viro@zeniv.linux.org.uk>, "Yu Zhao" <yuzhao@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Mateusz Guzik" <mjguzik@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>, "David Carlier" <devnexen@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, "Jonathan Corbet" <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Harry
 Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Kees Cook" <kees@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, linux-trace-kernel@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Oleg Nesterov" <oleg@redhat.com>, "Alan Stern" <stern@rowland.harvard.edu>, "Andrea
 Parri" <parri.andrea@gmail.com>, "Will Deacon" <will@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Hugh Dickins" <hughd@google.com>
In-Reply-To: <20261111203626.95838-8-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
 <20261111203626.95838-8-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 20:37:44 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: krkuzqfis5rd9i8y36ij3i43cxh1mpem
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3692C40006
X-Rspam-User: 
X-HE-Tag: 1794515868-998410
X-HE-Meta: U2FsdGVkX18t5vgpKItwRMS4iW9UYP95ot82+WtLvpBWyXRZE/ljmgPEyD+5wE4yj5PjtEzdPD4Q27NLIcSiQOQdeyfcLlp90IV89D0doYkqdzplvbwacZbW5U1/ctGIYm7XisS0XXC1n0+3WyQvd7CavMzaZZWRKe5riP+Oqo7yUqEvDaMQ7cLjLWU26cxsi8TW8k768MHSfAJ2axhEngBSR5lyvxEMwRmI1XlG8rETrWMLVtWlPFRCSp89V9Fi6TzwSzR1Q4O5k7XAd6bhSqhHeZ8Vy8V6J9a2gRsrtMuoNq+aP54fmPRPWXPOtzFx6B9ntN7I3JRdxdaoAL0jqLsJ40bK5HfDYwe+bpx0R16sD803bn8HKac14pIRpUrRyyHNzNQJdol9Y5k2A9ghkbTIoWl+lQ7Df238baWXq/RudYhe9HZCSdS6rQsvUGPfD++Ory0coHZ0lMzYXn8RzJKac2YOnEy0HL51IasKDDlyssZltxi70LEpqK0yOQqX1VLkQCGzVmiTYTFshelFch7nXjs1JHXSY5Cf9Se76Q0RWgyGJDqWN7ANLj+/T6v/N7bsRUNsDW47bSDqo2pmgrRMJKfpT0Zr5TyLcd89+M+OSbgJBtjU7UZl9YNXL9FRrJ1gsd8vlO9+n8Q0CznhmLmSzXRTCXKy1pO2SSmqxnxcLNrapr0vrxzT1yzEycKcEfB+kOq39Y4UsTEZnFen3+NHgH1ujaGyCgs1wMjjXJsyEPQoXt4XYdQCxUiMfSHianowngVkUBHiIyl5u1+prLJ9cmSGmqPm5/jiH27OFX4zepGM6tloXB51xHV9BOwHOUhwFyhDi57xtAoMh5OG62h/1JzeHUMs5F8OwV67+CPDbC75IacIPlo38GmRU2vw8EMBejgIvIscTLc5Naacx52+UQf/k+Ud5SIfwi9mcKwsALmNtveanVJ6wdya1u3t1SRU40ikF4grgXy692k
 77Uim0qL
 QqpOPSrGXy2YHPCHBgg4LhM9TVKVNWZIieFPOCrdfAFVJfDyD8BEckiEEK13NwMA7fBUSMcX/70ZhjUh6vaJWZdjAY7yZF7SCrfHciQFDJF2FqQAFSKa1YEakE2Bbq/vTyx0kNT6qDACd7/6LTxqBZBWOdEV9cuHOxyvd35c09JTUhaaYPW1bxDcRxJuor2ARBsyIlZh3uY9oHjMJiGv5S9n6FisbWh+Tu5zWVgZwU2ZTsd8i07nt5F0A0u6aui3/ctUS6mGAtV7859il0zOx3HkH/P7GCATM4gsA+3Bz/SeM8rP+UGwedaASCwc0V8Glx7vU00ED1RGXDKIBfTsVK8CbuXQGx1rwktqR1tz8ERlPxlpoU49FbPQ69/rZ+JT1+LJXuP7MmzK5RpHt4hvO6PtYD+cxRlyElEGnz0knSp25mV/piMX7vCt/IKylKSVru4GYulk3cRiRn3jsqQkGLqMvVTmSn661Ri39TONelD2yzTpce8TmaaQFikdkxVnxeZ683LirxHvYdv/zzIjDFrCnSmF5L/48jrngrMPXzQAafureYu2I2qAQbcs6iafNH74LaSl270C5OMuK7qVdvqinKSt4khAWV+I017UnM0LkdVzDxHO3MGKMFI8LXTe48bB4Df09XMWc8rBTycPkh6J6/C1Du6F9nBNnFb0vMBetPtFjvNszl0IFCTFslLGADXiU
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
- [Medium] mm: clear mm->rss_owner on fork failure in dup_mm() and
  copy_process()
--

commit 388976e575ede4fc50ab3cc88ddde7c67d80cb2e
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

mm: keep the RSS counters of single-threaded processes exact

This commit initializes the RSS counter tree lazily when a second thread
shares the mm, using a plain owner counter and an atomic counter for
single-threaded processes.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index d9bdaf2bd9984..dc1db6cb5da04 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c

[ ... ]

> @@ -1550,6 +1550,8 @@ static struct mm_struct *dup_mm(struct task_struct =
*tsk,
>  		mmap_write_unlock(oldmm);
>  		goto fail_uprobe;
>  	}
> +	/* The child owns its RSS counters, see __add_mm_counter(). */
> +	mm->rss_owner =3D tsk;
> =20
>  	err =3D dup_mmap(mm, oldmm);
>  	if (err)

[Severity: Medium]
Can a failed fork leave mm->rss_owner pointing to a freed task_struct?

Once dup_mmap() succeeds, the new mm is reachable by external
mmget_not_zero() callers such as userfaultfd or swapoff.  If the fork then
fails in dup_mm() at try_module_get() or later in copy_process() (for
example when put_user(pidfd, args->pidfd) returns -EFAULT), both error
paths clear mm->owner before mmput(), but neither clears mm->rss_owner:

kernel/fork.c:dup_mm() {
	...
free_pt:
	/* don't put binfmt in mmput, we haven't got module yet */
	mm->binfmt =3D NULL;
	mm_init_owner(mm, NULL);
	mmput(mm);
	...
}

kernel/fork.c:copy_process() {
	...
bad_fork_cleanup_mm:
	sched_cache_fork_cleanup(p);
	if (p->mm) {
		mm_clear_owner(p->mm, p);
		mmput(p->mm);
	}
	...
}

If an external reference holds mm->mm_users > 1 across that mmput(), mm
outlives tsk.  A new task allocated at the same slab address as tsk can
then match current =3D=3D READ_ONCE(mm->rss_owner) in __add_mm_counter() and
perform unsynchronized non-atomic updates via
percpu_counter_tree_add_owner(), losing counter updates or triggering a
Bad rss-counter state report in check_mm().

Clearing mm->rss_owner alongside mm->owner on both error paths before
mmput() would avoid leaving the dangling pointer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111203626.9583=
8-1-mathieu.desnoyers@efficios.com?part=3D7

