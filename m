Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0509CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F686B008C; Mon, 15 Jun 2026 07:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430B46B0092; Mon, 15 Jun 2026 07:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F176B0093; Mon, 15 Jun 2026 07:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 210F56B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:43:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B469D16633A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:43:57 +0000 (UTC)
X-FDA: 84881962914.23.5D1CC8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06B76C0002
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:43:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fuYLpI/W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781523836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DyvOEHKVCEkg7/agKguOd/UADGZvo/0DOwYS+FJxvWA=;
	b=IDIe+B0jM2SHjnM6pToHknMIoabJmCH6N/sorvA8pAFwD7pJ3ySK0OZHpXAcP6OIChFOpT
	cN2VJpjPvYxfIVD48HKgPAprap038pCZi6+AmXrEBuYug9Rx3fVpVfztsJ/+bUZE/Irwb0
	jPqB7D3AXam0B3IDbmgCfpdSDC8b22Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fuYLpI/W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781523836;
	b=m67kkgOOEBuhsT5PHLtgB6EOPTAHt3/SKbarXGWYQCI0Duwkds30Vw7/i/aTfHewUkZVoU
	MoD69eVWCNaUvEbR2eTP+yk/2Ahjy2yw6HUTU/E77E86jWRv5kzxJ0JHz1mVck8yyAPYVN
	Pkn5jTyuLTcX0nhT/I9MsCc6VNV6CDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AD776008A;
	Mon, 15 Jun 2026 11:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80E51F000E9;
	Mon, 15 Jun 2026 11:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781523835;
	bh=DyvOEHKVCEkg7/agKguOd/UADGZvo/0DOwYS+FJxvWA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=fuYLpI/WXj53VFQJ9EzBpY0RaK6so1ueSSvXPbByr1lDhJGL+yNCu22OC49iaWqGH
	 VDudECuLAi+mQoTMfzLDDxdYZdLH0RAUjnulVFr8Y2kHE/g5IVoApAMZdPqQHxXiSm
	 qdlTWdFtKGn+2FEFia/jh+N2Eo6i/vj+9I10WE/IFnJgk23vsmAVWWkIBH9Ah5TRoG
	 pKjxRsJD6jtPjVadSvwo3ZLUq9IkIRdICH1luUOHHUuQe76ks/XGNN5c/O8IY+V5xa
	 TURqXwiv/vq5VXXDaROxVG8GGjP+h+7rRuvVXCUsFuxrU2gic1QEcxmwAShjw3G7qY
	 squlwVnqH8qtQ==
Message-ID: <9c120401-0e1e-41d8-b662-10339e302c91@kernel.org>
Date: Mon, 15 Jun 2026 20:43:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 0/9] mm/slab: introduce kfree_rcu_nolock() and
 improve slub_kunit coverage
From: Harry Yoo <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
Content-Language: en-US
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------10ViNcef5i8ibbRYt2VHD6RX"
X-Rspamd-Queue-Id: 06B76C0002
X-Rspam-User: 
X-Stat-Signature: itmjhhzjsrg7bduwokxyu8csrziw9dtf
X-Rspamd-Server: rspam09
X-HE-Tag: 1781523835-52865
X-HE-Meta: U2FsdGVkX1/6Q3dWbuJtPRaFV+DNsP44solype5dbWX5eNHOeWh4hYN77uxa2FlAyQmxNfRs7V8uz36qsGsbtCtmxtEdMApDpbF6LgOyaQS2jyEa4YOyQU4sP7XNngHQbtsTansoUXPgAdFPT1sqaJhNoe2wZ0brOkQttNH1oCBTxHEY3haGdnErWunyECOH+FihBKj5hUN9h8lMAk2eqVrkJiWP2Ybc4e0AP6ySbiWsqn1HdBixV6+uQZ77vV9XjHXGSvCpvIcdHq8DpTVg/iF5PgfXYKac95EyLOGUR7fWAeJerJyrXbCofRWq8ssosbl+hMaWfSU35AqbmfX5YAw0qLZvaVQiWuLPZdFvp/cIreqkbArisI6axlmcSPW1t1ItAQwqdSYJQqPCct3+BFvqSbGkVvoPPmO/ojaTWSlN9WYNTr40b6DJ5Bk7Sd5TKeqnmQ1VMiamJfzql6q5hNBtvUJR2QgqMxuRiKozPpY/QRuiO6hn5FgiJkHUa1cjGxA4NscMiQKsP0dpDgQtcOq0pfXkndcIc2OW5maMDYZfoNF3nJuVZPyH8FuAC64jbJG9OjfFIPbUWz44l5cN+hOVL52D9nxmp5kaiQ1AyE2HxY7wNMsC5vFwBNe9YuWRnErtR58yJ/Gac3kRdDQ1NYhTFaGKYHP1LN70UbneVtnu9eitNKIToPhSDQovca1Em/KixSkOqHrR93MWAGiOedecD1eNjEFxmCDNpiukkxgrlkcnmPMvjWkmT0rnUzWTN4hUkdvZcWcjONnAPmmmW3mFzetCCw1tmKx+eF6OQg0emDZNspvfu46MoLieAUPHs/eWoIhZwVv+tvqXAS7JeIY0ioMh0xzpADDGrzgG8p8nl5gdjmB1hCdsxa0RIWoq50kdiWZorUDUhReEvvN4pot8wBCWPMo2E9VIy0ZWq9A7slsGtPDqsrmg+9iIL9rAWEIWb2fB2r6JLEyl8iq
 ETLK0+gp
 HDuXhTkfOXaTKKYCPckeZ0nOAM3ENvg+wliQriahesToKjATTzLwPWMNq7SQrNxEKe12hvEBpZA655AogtYmOamvQDe9OCt/KBu4QOo+vTYg/7C+GuI8dPRjrwqZVjfoNOYzh55rIwzUlR3Kz0DYsFOYgTJudXdzpM0brgxxXLKiT8Un4qb7BQcVdQVS1m3p+A/PFAoifHKlmGjC2R2nWutPwQcCd8FWGACdGSRkpSCEoj2sRSOSdmbHX1EYO2HV7k8LW9ew7dWmrESkt2k3byi6fyQH/V4JVTxovWPIHlM3gvlCR0ExWMAaXQw+vqzB9exhuV/RQm0Nz20DzXK11mtb2zlFS/0A3nu/+p1+e3UopwppUGrhNf4S4CUoRexv61j7wI6fXg4aNXCXypHqov/vDuntXe96WwaOXuWtZLELgq2fw/rCjYDQ9c07cSi3LeGRj3VdDDLi5IvDWJPEYalcxlyoQuSHjmRdM2WLWP/MaqDHc6PzH9VhU9mC6tATtN4nTnOmS0PbtN+VMY6vc/5r6agMs3eMDSHn5eAouHCM8/cI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------10ViNcef5i8ibbRYt2VHD6RX
Content-Type: multipart/mixed; boundary="------------J2SxSCJedZHomL0Ld69od8Yj";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <9c120401-0e1e-41d8-b662-10339e302c91@kernel.org>
Subject: Re: [PATCH for-next v3 0/9] mm/slab: introduce kfree_rcu_nolock() and
 improve slub_kunit coverage
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>

--------------J2SxSCJedZHomL0Ld69od8Yj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Now I'm investigating and fixing pre-existing two kmalloc_nolock() bugs
and (hopefully) planning to post the fixes later this week.

I will later rebase the this series onto Vlastimil's slab_alloc_flags v3
and the kmalloc_nolock() fixes, and address human and sashiko's
comments.

But this should be enough for review.

Thanks!

On 6/15/26 8:05 PM, Harry Yoo (Oracle) wrote:
> Not the best time to post a series, but didn't want to delay posting
> the series for too long. no pressures ;)  This is aimed to be queued
> for review and testing after the merge window closes.
>=20
> This series is based on next-20260612, and is also available on
> git.kernel.org [3].
>=20
> To RCU folks: It would be great if you could kindly take a quick look a=
t
> patch 4 and either ack or nack the patch ;)
>=20
> To BPF folks: Ulad asked to share workloads to measure performance
> of kfree_rcu_nolock(). Unfortunately, I focused more on correctness
> and have not spent much effort on that. It would be nice if BPF folks
> could help evaluate it on their relevant workloads.
>=20
> To PREEMPT_RT folks: The most relevant part is allowing
> kfree_rcu_sheaf() on PREEMPT_RT (patch 6). It carefully avoids sleeping=

> by acquiring the locks via local_trylock() or spin_trylock_irqsave()
> to avoid sleeping within a raw spinlock. When trylock or unlock is
> unsafe, kmalloc_nolock() always fails.
>=20
> Changes since RFC v2
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Reduced complexity and intrusiveness (Uladzislau Rezki)
> -------------------------------------------------------
>=20
> While discussing concerns about the complexity of adding allow_spin
> handling with Ulad (Thanks!), I realized that adding complexity to the
> kvfree_rcu batching is not strictly necessary: only slab objects need t=
o
> be batched, they are already batched by rcu sheaves, and slab already
> supports unknown context. So it is enough to implement only a minimal
> fallback for the sheaves path.
>=20
> I tried to avoid making intrusive changes to the existing kvfree_rcu
> path as much as possible. struct rcu_ptr is renamed to kfree_rcu_head
> following Vlastimil's suggestion, and it is used only in the
> kfree_rcu_nolock() path for now.
>=20
> As a result, the complexity is significantly reduced and the series
> became much less intrusive. This is also reflected well in the diffstat=

> below.
>=20
> RFC v2 diffstat:
>   8 files changed, 514 insertions(+), 163 deletions(-)
>=20
> v3 diffstat:
>   6 files changed, 370 insertions(+), 105 deletions(-)
>=20
> v3 diffstat (slub_kunit improvements - patch 1, 2, 9 excluded):
>   5 files changed, 199 insertions(+), 66 deletions(-)
>=20
> kfree_rcu_sheaf() PREEMPT_RT support (Vlastimil Babka)
> ------------------------------------------------------
>=20
> As suggested by Vlastimil (Thanks!), kfree_rcu_sheaf() can now be used
> on PREEMPT_RT as well, by always assuming allow_spin is false on
> PREEMPT_RT.
>=20
> slub_kunit enhancements
> -----------------------
>=20
> - Currently the test is skipped when there is no hardware PMU. This can=

>   happen on machines without a PMU, or in virtualized environments
>   (e.g., automated testing or virtme). Implement a fallback based on SW=

>   perf events so that the test can still run in such environments, even=

>   though the coverage is slightly smaller.
>=20
> - While testing on PREEMPT_RT, I found that kmalloc_nolock() fails ever=
y
>   time, so the fallback path is not properly tested. This is a limitati=
on
>   of perf events: the handler is called in NMI (HW perf events) or
>   interrupt context (SW perf events), where kmalloc_nolock() cannot
>   succeed.
>=20
>   slub_kunit now registers a kprobe pre-handler at the points in the sl=
ab
>   allocator where lockdep_assert_held() is invoked. The pre-handler cal=
ls
>   kmalloc_nolock() and friends, to improve coverage on PREEMPT_RT inste=
ad
>   of relying on perf events.
>=20
> One thing that needs to be further explored
> -------------------------------------------
>=20
> The global deferred_free_by_rcu (introduced by patch 8) list for the
> fallback should probably be per-CPU [5].
>=20
> Actual Cover Letter
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> This series improves kmalloc_nolock() and kfree_nolock() coverage
> in slub_kunit (patch 1 and 2) and introduces kfree_rcu_nolock() for
> an unknown context as suggested by Alexei Starovoitov.
>=20
> Unknown context means the caller does not know whether spinning on a lo=
ck
> is safe (e.g., a BPF program attached to an arbitrary kernel function o=
r
> in NMI context).
>=20
> The slab allocator already supports unknown context via kmalloc_nolock(=
)
> and kfree_nolock(), but te slab allocator does not support freeing
> objects by RCU in unknown context.
>=20
> It is not ideal to have completely separate batching for unknown contex=
t
> because the worst scenario where spinning on a lock would lead to
> deadlock is very rare, and in most cases, it is safe to use the
> existing mechanism (kfree_rcu_sheaf()).
>=20
> Since most part of the slab allocator already supports unknown context
> and sheaves support batching kvfree_rcu() calls for slab objects,
> implement kfree_rcu_nolock() with minimal changes by teaching
> kfree_rcu_sheaf() how to support unknown context and making
> it a little bit harder to allocate an empty sheaf, instead of making
> intrusive changes to the existing kvfree_rcu batching logic.
>=20
> kfree_rcu_nolock() tries to free the object to the rcu sheaf if
> trylock succeeds. Once the rcu sheaf becomes full, it is submitted to
> RCU via call_rcu() if spinning is allowed or IRQs are enabled (to avoid=

> calling call_rcu() in the middle of call_rcu()). Otherwise, call_rcu()
> is deferred via irq work.
>=20
> In unknown context, when there is no sheaf available, kfree_rcu_sheaf()=

> falls back to defer_kfree_rcu(), which inserts the object to a global
> lockless list [5] and those objects are freed after synchronize_rcu() i=
n
> a workqueue.
>=20
> Unlike kfree_rcu(), only the 2-argument variant is supported.
> This is because the last resort of the 1-arg variant is
> synchronize_rcu(), which cannot be used in an unknown context.
>=20
> As suggested by Alexei Starovoitov, kfree_rcu_nolock() can be used with=

> struct kfree_rcu_head (8 bytes), which is smaller than struct rcu_head
> (16 bytes).
>=20
> For more background and future plans, please see [4].
>=20
> [1] RFC v1: https://lore.kernel.org/linux-mm/20260206093410.160622-1-ha=
rry.yoo@oracle.com
>=20
> [2] RFC v2: https://lore.kernel.org/linux-mm/20260416091022.36823-1-har=
ry@kernel.org
>=20
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log=
/?h=3Dkfree_rcu_nolock-v3r3
>=20
> [4] kmalloc_nolock() follow-ups, including kfree_rcu_nolock(),
>     https://lore.kernel.org/linux-mm/esepccfhqg7m6jo76ns2znj2cnuaepx2xv=
w5zaygtwohq4psma@563ypprp6rr3
>=20
> [5] However, we should probably make the list percpu because,
>     unlike RFC v2, it can be triggered more frequently under memory
>     pressure.
>=20
>     https://lore.kernel.org/linux-mm/805c33d7-3a7b-470c-bd9d-065717a3e3=
e2@paulmck-laptop
>=20
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> Harry Yoo (Oracle) (9):
>       slub_kunit: fall back to SW perf events when HW PMU is not availa=
ble
>       mm/slab, slub_kunit: register kprobe to trigger _nolock APIs
>       mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
>       mm/slab: use call_rcu() in unknown context if irqs are enabled
>       mm/slab: extend deferred free mechanism to handle rcu sheaves
>       mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
>       mm/slab: introduce kfree_rcu_nolock()
>       mm/slab: introduce struct kfree_rcu_head and use in kfree_rcu_nol=
ock()
>       slub_kunit: extend the test for kfree_rcu_nolock()
>=20
>  include/linux/rcupdate.h |  12 +++
>  include/linux/types.h    |   4 +
>  lib/tests/slub_kunit.c   | 174 ++++++++++++++++++++++++++++------
>  mm/slab.h                |   5 +-
>  mm/slab_common.c         |  38 ++++++--
>  mm/slub.c                | 242 ++++++++++++++++++++++++++++++++++-----=
--------
>  6 files changed, 370 insertions(+), 105 deletions(-)
> ---
> base-commit: c425609d6ac4012c8bbf01ec2e10e801b1923a7b
> change-id: 20260615-kfree_rcu_nolock-e5502555992f
>=20
> Best regards,

--=20
Cheers,
Harry / Hyeonggon

--------------J2SxSCJedZHomL0Ld69od8Yj--

--------------10ViNcef5i8ibbRYt2VHD6RX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCai/lcAAKCRCGXBN6rc5S
1mXxAP4+e/OYEoIRSjG5ySSQjKnJWweua3EF2N5shwcUUTRkvQD/U83GisrSL79q
EVrJpmNKT3n6zrZKzJ+O/XCk5dMxrA4=
=a5NM
-----END PGP SIGNATURE-----

--------------10ViNcef5i8ibbRYt2VHD6RX--

