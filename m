Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003F6606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AaKnaV0X
Received: by kanga.kvack.org (Postfix)
	id B4B8A6B05B4; Wed, 18 Nov 2026 11:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B236D6B05BA; Wed, 18 Nov 2026 11:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F356B05B4; Wed, 18 Nov 2026 11:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58DDE6B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:17:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7D62C0620
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:17:43 +0000 (UTC)
X-FDA: 85448745606.20.2B1643A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 26FFD40009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:17:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AaKnaV0X;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018662;
	b=S8Ym4tQfyKgo1eqiaMUA+LkfJ3RXwyz6U2EhVeD2VGRr2SZ/qciVE3FreM0rWDEj7lV4kF
	EDlE5qP3+Bw2jy3g7ANjQnIuJCzn7JWDtfky4CautOmemju+CVqAvtEFdi1qRdCntlYhv+
	/0Kh1LPHZl8f39TpjPdDRKdErYVlyJM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AaKnaV0X;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018662;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wI9BAaHSpQ0HIzhM5Lg3uuaN5UlVLPwNZ6em51bIRM=;
	b=C9ElWnv7EM8kgKfVHry8DknSthLaIXEvJVZhCtGc/EgjVQaYfiufdrppJKNhUWLAM7YxBB
	Xxtu1RzO5cxkAUp98kKAPab925AeRrjjblwNI7VEIwFEY3/et47VYKa2fSLWT2WmEM62zR
	O9OV9xSshg+NkRCuBWxADXXs61TBAUM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DDAA4634C;
	Wed, 18 Nov 2026 16:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267291F000C4;
	Wed, 18 Nov 2026 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018661;
	bh=0wI9BAaHSpQ0HIzhM5Lg3uuaN5UlVLPwNZ6em51bIRM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AaKnaV0Xl1/rtpuRl0idSlXPWETWvsBa9rvfflSsTR7Y5iK+i2QaI0zwFXcQs54Kk
	 1p+zcUQ0n3lbC9+uQPoFgPeWlv/OevvCv/LZcn2rjXlFu0Mr0fsoPwXGrGG4T22V7n
	 eDBsMSVObmGMmIPlzIcbnBnv4beYQn5xzsBRX74jjbSo7NnopLW6PTz4ABKWhoU5VB
	 vCYCAogn3/npR+RSMzkFxqoZxqzBUyKUM2I3eXe9A646DDHPLNCVZaGLzxScl6WDAk
	 WQsX2Pk0ORueBT5QQYTwTnBQuuFUAjAEz2TbQ3jkM84tq6vmYl/QNtqekzze7X1SKE
	 +IXSB/52i8jSQ==
Message-ID: <sashiko-outbox-221457@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/17] selftests/rseq: Test the concurrency IDs after
 the affinity is widened
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, tglx@kernel.org, peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, paulmck@kernel.org, boqun@kernel.org, shuah@kernel.org, kees@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, oleg@redhat.com, bestswngs@gmail.com, xmei5@asu.edu, xujiakai24@mails.ucas.ac.cn, linux-mm@kvack.org
In-Reply-To: <05781fc46cb63b548588e58b356ab08b10619aac.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
 <05781fc46cb63b548588e58b356ab08b10619aac.1794932121.git.mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 16:17:39 +0000
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 26FFD40009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4gzhwzyr3g9tfnojcjtmybpqirgp1ps8
X-Rspam-User: 
X-HE-Tag: 1795018661-81952
X-HE-Meta: U2FsdGVkX18csDg/wHuPyHD27e0hOHVlWeXo7ypml1vd7lHSwnRkbO/0DGCRMK6d+mN0+h8HXrO1oxNcUI+pB5qBJv4TenpeaufRd2aOnm1An4esOm9Ub3IFs8V5OCZiZyLfeJroSaxURpgUm95nUn/YGoNuKknny2nqfvo/4pvr1F7vjAE3tRAcxit24WMM2XErlvw24ncKOkvIbIJhx4fRpdDLY8UI1CVHuEFzOp4kpjX5H+SrcpREpq1l2fAreKNN6WpoK5EnzHOFqFg4z2NFoe3KpRhr96EitdOcuvaUqL+mBLpWG0M0MUZyJFRSRWKbLQjFArMV4eEyWN23BQR2TUgLFyjmlCdywnpE95I5GrtyBe7HT5aajKCFW93SrWue7JN2mXgWTKaBEi8h/S9cH0/T5+6p420nWBgJaHUw4sXG3eaJfXwULfpyXwAovwczK17LvI1vQz8y8H4nJUmiPMVw9g/C2dSXsGGNWNzRDZvJ6OQoje59Doios65/XZ7I1daSaQtv0t49ya1YEfXbRjHdEHwn0kPWH1CP2ss/FdHDuV5R+0nMhAaUi8T41s7ItauFV2KDzjrX1lNYs5bWiWLaJIlgf5IDvHcPXKWtQmIjX/4dcrZC/3Eap9/ZLmIbXLlYQOvx60cW7LeRPK0B+HhcvgfHEqSW69yEy+SInO3LVy7j1AmXwT08PlxmahXGEAJPFnlYm1JIm2kfB2z9bcAm0t3gDcPpTzCbuoBfVkw2iBncy0b0hc4SYMrd7HWd4DyFARaF1D21+asI0DSxtTIY7K43eP4vkGBnOKhHAZiTcCyI3pUxWPuVw4SpYPo2mHSIMsYtYXlVT6pTowu8b6exq8lbMgm8OeMMJ1OwW0daw5+NDGXheYvyCsyH/H0GpQv5vqH8qwornwk0VXGffkXyMzw7/Vj+z4V7Gkv/69fWJbQWO0rjApd/GC5hFLjpeEtPQnlSxxndRRG
 xtyYZcFf
 5UQhbNzW5qhY3JpftbrRZ1x0ebcUNtDEwBD2WAP9bevqTmvp3Cfw00RzHIGSxR/Z2Z4WzQZJu1/0CskRFM9T7lQhMFbAYMA1ujCpdr3w2uj/fGjmlqBSHLAKgVFrAcA6v5PKGjCKNs6598rAHFgyyi26bsJLAPMfY6Cn6SPTWl+ffdpggfrbUgINFZNjP68DIOr2uEbLujzL2ksDADVrosDzYEQHpkbcHhDYU7Z8t+c93tIFhCZgSVafj2o/502CSt3gCxnJCylmWvH6GH+IIhD9EKr7bpGJFdc9fg2QLi8nlnIJ6a78xaTtiXL1FAXi535lVDm95q48DoVz2zBue3WTWdtbfTfWJynDAo/qymV1fzhcx2DQ+/2o028YbqCTVDICzT+njmmUTajhqvxyMpmP5UGY31abO32Ud25bd+h+VSgRr+5IEKyQ22yuyZEsQ7KGK0FlR6XnCaHPQvXqXwsR8BwNwfuA0B7q3OZd3OxWYhldNPKlacWyPnQCtqwkotXVv9vqkY0D59Zw1knrlPFCwjMuM8ag3vqNFIWiRpyvDDOnHtumhkwFSvKJnwCp5zRfO9toor7Cyab9KO9KhlUYNVaw9Uzo79/p56MvLwXjEdY37eRt+f9KKRQ==
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
- [Low] selftests/rseq: missing release-acquire ordering on epoch in
  measure()
--

commit c93d413e090ede336a58daf34cc339f9241ae7d4
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

selftests/rseq: Test the concurrency IDs after the affinity is widened

This commit adds a test case to mm_cid_bound_test that starts three
threads on two CPUs and then widens their CPU affinity to all CPUs to test
whether concurrency IDs are reassigned back to per-task mode.

> diff --git a/tools/testing/selftests/rseq/mm_cid_bound_test.c b/tools/tes=
ting/selftests/rseq/mm_cid_bound_test.c
> index 11332b9ff24b8..a751d89291380 100644
> --- a/tools/testing/selftests/rseq/mm_cid_bound_test.c
> +++ b/tools/testing/selftests/rseq/mm_cid_bound_test.c

[ ... ]

> @@ -228,6 +237,49 @@ static int run_child(const int *steps, int nr_steps)
>  	return ret;
>  }
> =20
> +/*
> + * The process under test of the widening case. It starts on two CPUs.
> + * Return a mask of the OVER_* values.
> + */
> +static int run_child_widen(void)
> +{
> +	int nr_workers =3D 0, ret =3D 0, cpu, err;
> +	unsigned int cid;
> +
> +	if (sched_getaffinity(0, sizeof(allowed), &allowed))
> +		return CHILD_ERROR;
> +	nr_allowed =3D CPU_COUNT(&allowed);
> +
> +	err =3D set_workers(&nr_workers, WIDEN_THREADS - 1);
> +	if (err)
> +		return CHILD_ERROR;
> +	measure(nr_workers, &cpu);
> +	cid =3D measure(nr_workers, &cpu);
> +	ksft_print_msg("%4d threads on %d CPUs: largest mm_cid %u on CPU %d\n",
> +		       WIDEN_THREADS, nr_allowed, cid, cpu);
> +
> +	/* Each thread widens its own affinity at the end of its next tour. */
> +	allowed =3D all_cpus;
> +	nr_allowed =3D CPU_COUNT(&allowed);
> +	if (sched_setaffinity(0, sizeof(allowed), &allowed))
> +		ret |=3D CHILD_ERROR;
> +	measure(nr_workers, &cpu);

[Severity: Low]
Can the worker threads still observe the old 2-CPU allowed mask in tour()
when measure() wakes them here?

Previously, allowed was only written before pthread_create() spawned the
workers.  Here run_child_widen() updates allowed while workers are already
spinning in worker_fn(), but measure() and worker_fn() synchronize on
epoch with plain volatile accesses rather than release-acquire ordering:

tools/testing/selftests/rseq/mm_cid_bound_test.c:worker_fn() {
	while (!RSEQ_READ_ONCE(w->stop)) {
		unsigned int e =3D RSEQ_READ_ONCE(epoch);

		if (e =3D=3D seen) {
			usleep(200);
			continue;
		}
		tour(w);
    ...
}

tools/testing/selftests/rseq/mm_cid_bound_test.c:measure() {
    ...
	RSEQ_WRITE_ONCE(epoch, e);
	tour(&self);
    ...
}

CPU0                              CPU1
run_child_widen()                 worker_fn()
  allowed =3D all_cpus;
  measure()
    RSEQ_WRITE_ONCE(epoch, e);
                                    e =3D RSEQ_READ_ONCE(epoch);
                                    tour()
                                      CPU_ISSET(cpu, &allowed)
                                      sched_setaffinity(..., &allowed)
                                        <-- reads stale 2-CPU allowed

Without rseq_smp_store_release(&epoch, e) in measure() paired with
rseq_smp_load_acquire(&epoch) in worker_fn(), either the compiler or a
weakly-ordered CPU can reorder the non-volatile reads of allowed in tour()
ahead of the load of epoch, leaving the workers pinned to the initial two
CPUs during the widening tour.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794932121.gi=
t.mathieu.desnoyers@efficios.com?part=3D14

