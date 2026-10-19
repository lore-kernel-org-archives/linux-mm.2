Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1738BCCF2D5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 03:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990D76B0100; Sun, 18 Oct 2026 23:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941326B0101; Sun, 18 Oct 2026 23:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830D66B0102; Sun, 18 Oct 2026 23:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CCF56B0100
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:53:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9607BA81BC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:17 +0000 (UTC)
X-FDA: 85338005634.20.D33133A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F1BE540002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:53:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6s4hY1l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792381996;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTAJ39hBUarIZFhO0OJWMfQPPN8/Ral7/CgoQ38TKhM=;
	b=8jyrtZ79LRx5BgeS8zzMIcaP1D1MdP4u2qTWuKSrcqWsLCdZ4KjiDpKFzWOFu56JEszoaU
	TdAAKN3zwKO9oHdR4HsjaxHSXcdPU/fmb67USKLhyq+Jw7M/voeFFniUB0XrGS4Kzf1Ork
	XoVkGvvoQzqm7prrnl2hqCr3AKXWaUg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6s4hY1l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792381996;
	b=x4Wm2q8qtD0YOMVu1sMGHXqB+A/idf1pZPHywfVRGRvAQmYVPDMJFcdgWe9t+RttNiao9y
	KYhTbtcoMiDIJ04tUP76n6/iuMOe+t03129PcBNRJNpWq5JoNMzVUOpLR57uEOeKmcPAk4
	Vz0vUNs074YJWxfKDzqUnE090B3zo/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1531460233;
	Mon, 19 Oct 2026 03:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787C01F000C4;
	Mon, 19 Oct 2026 03:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792381994;
	bh=aTAJ39hBUarIZFhO0OJWMfQPPN8/Ral7/CgoQ38TKhM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e6s4hY1lG4WND/DAKwuOfxj8htQX4HgmaTsBAaTzgUfGJbpig5y7TRGrGiUErYdM+
	 R+y/cl2WHFhYKeJQDxKq8pMvqckrlFQbGXp67TQE0io2loutvcQPKdYh4JMWw0LqDf
	 ikKY6n+Le4rmVFfBZbsFC3WfVvJtxZKbgbIv+VRnT1uhIvUAUqf6s6eNtu9KV1ATkK
	 DVZ5ifyVlYj8c03hU7D+jzGsIPxZJSqipM8YbO7hC4zkWTkOkZZROcZLjQNzKnoeNm
	 McZvz3pk38TcGF6DXmROyqAvD7WW4uSMjXlnqY2UUW+cN0vxjwHZLQgZ85nQy7eqI8
	 A1CWTFfgm0FpA==
Message-ID: <sashiko-outbox-176604@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/13] zram: borrow idle decompression streams in
 exclusive mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Brian Geffon" <bgeffon@google.com>, "Barry Song" <baohua@kernel.org>, "Bo
 Zhang" <zhangbo0325@gmail.com>, "Minchan Kim" <minchan@kernel.org>, "Richard
 Chang" <richardycc@google.com>, linux-mm@kvack.org
In-Reply-To: <20261018035125.3120704-13-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
 <20261018035125.3120704-13-senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 03:53:14 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F1BE540002
X-Stat-Signature: hnnudzcywshfrzib5pxcs8cmonc1z1m3
X-Rspam-User: 
X-HE-Tag: 1792381995-6872
X-HE-Meta: U2FsdGVkX1+yivpGkFOFIG5fj/t115rSNtABRaJyHENuK4UXJCmJgFpSCCv8jI4+6btA8P15hnSe6VYcAh5uPIbqHk5ZJN3VSsbuLztTnepBRA9PROAxGjB7prdNVv9Q+q0bC09S6wvg61gKyjMSmDzqsI7y6prL2DtsHyhoyIy5ymsumtQhcmErCXXxmAI6OplDY5MzXgSjF8hZa0yFfxthrCf/9f8ZtfrWYNmP865san76iwRsv0BL5Ty4S0mc4UrfIXe0HeBQcdglVeUmu25BQ5hEHiQ/5eezeT/n9czF76GndIIXMc1XpquZ03kZPbh9n41vAJct0Fa8SxEf01CkiixqLykLZSgxHqDQ0lGxYAVIOAMVUJAFdXYqrsgekMUu/+WRG4nyHmhMwWZ4jLb7RmeO9Hngk5huVbXDGgr0D3FKmDund9hfjjw07PElEKm9O19S05sZRSBj15eqfGpmFUViOnEaLwI15PJEr+JdFbuvXvZ1T/EXN1kcNv38QsFav20Z4EMafD+dAk3U660a/8y6IfUjur2IfsueDUJk3gppI14CD5/cVK3+yloxS9+RhvsnYXRcRS/vvVSw7yJmH4ny80PahH4FgPovm9TqJnZDIcFirffCTqS0M6gl3ES2aqvE2l/scnRQQ5F3EDk4CSYDGv+IXt0ZNFz2ujyekjBRESWlnwcXYsyZDCu8lV/JNf0IIVytWRsQ4vZum9dbSNv0xmdQk6HNnQ5ZQ/dUdsYlbiMctW2z1FiD8qGH/nP9hHd1ChXQfpHP9R2G1GbxRa8EkvTQMcvpByssSBZY+9gAn6YcK28waIIrTuCng4+7idHABGXNKDRC/IMWqeYyXsVxs9fUJdc+BWttm5WjSq2l6bukWY+flTzBSRTTTvn0PeSV3EqG7/cGeukGzRlZEqYVkBKldPEeKV6PF18bSCANnNPluOw3ADI4JIYs8FPm1q33CO3CVkEBobf
 1QaYe5Im
 S/3kdS6ATolW7vNBEJbmzOKomukekr48PVNK8RYxTKB/a4Vkjc5fGxg5YsduSwO+rp7dfrUl9/W2UnkZuIPdqIoXOizFODSTsY2tPvY43uNEvard+tv2qwnXRmXWdzD4rt3V9gAP3HxZujxUnA3plTvf2+Zddwf6raN8CcYviUct22yH3M0xhfcam9cikHvkvYoxJXlykfnTsSrkKtWN9drPqRhBdYys1oC9exvZ7SCAEJFQ2kOuSjldC5maOLJ6gd+XXd8/Qu+iN0yOpjVoowi0r4eMIyOho4SBNwBSJIYT0rRX+5lDZ97P7hMvz+SsTqXTPmGbF+EIBMq6YXHWHS8EIuT5MFQTQsQ3QW9qjG1sN53Ab1QFRm5J/WDeizAlNlGaDXbG5eHMJTr4nGHY1zfo4dJmNHi5MTXsXBTsUIc8H8E2nmjj975KH8dzQgRZ6D97QEtqtO+ffRIfTU0ogy3gKHAS6HUI3CVXSmyyt0e/e4mLbFudbVfJm8rVe58YyhKmzEzb86AKBwPBmipHx7zKMnGbufdDnNbDSFIj0Xfy6IGEXTMI0zlYz31xzPEL5H6zNYtUz6WjrXEEtem5VPnTjVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] zram: raw_smp_processor_id() re-evaluated in zcomp_dstrm_excl_tryg=
et() loop
--

commit a4463f4c7972dc5e8129cff84e8c92b3498b7a73
Author: Sergey Senozhatsky <senozhatsky@chromium.org>

zram: borrow idle decompression streams in exclusive mode

This commit allows exclusive decompression stream requests to scan online
CPUs and borrow an idle per-CPU decompression stream before falling back
to sleeping on a per-zcomp waitqueue.

> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 4fda13aac8965..c6d2fd23c6f66 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -185,38 +185,67 @@ bool zcomp_shared_decomp(struct zcomp *comp)
>  	return !comp->ops->create_dctx;
>  }
> =20
> +static bool zcomp_dstrm_excl_trylock(struct zcomp_dstrm *zstrm)
> +{
> +	/* Cheap pre-check: don't touch a busy stream's cachelines */
> +	if (mutex_is_locked(&zstrm->excl_lock))
> +		return false;
> +	/*
> +	 * Pin the stream.  The write side of ->lock is only taken by
> +	 * zcomp_cpu_dead(), which also sets ->local_copy to NULL.
> +	 */
> +	if (!down_read_trylock(&zstrm->lock))
> +		return false;
> +	if (zstrm->local_copy && mutex_trylock(&zstrm->excl_lock))
> +		return true;
> +	up_read(&zstrm->lock);
> +	return false;
> +}
> +
> +static struct zcomp_dstrm *zcomp_dstrm_excl_tryget(struct zcomp *comp)
> +{
> +	struct zcomp_dstrm *zstrm;
> +	unsigned int cpu;
> +
> +	/* Best-effort start CPU hint; migration during the scan is fine */
> +	for_each_online_cpu_wrap(cpu, raw_smp_processor_id()) {
> +		zstrm =3D per_cpu_ptr(comp->dstream, cpu);
> +		if (zcomp_dstrm_excl_trylock(zstrm))
> +			return zstrm;
> +	}
> +	return NULL;
> +}

[Severity: High]
Does passing raw_smp_processor_id() directly as the start argument to
for_each_online_cpu_wrap() in zcomp_dstrm_excl_tryget() break the loop
termination logic when the task migrates during the scan?

for_each_online_cpu_wrap() expands via for_each_cpu_wrap() to
for_each_set_bit_wrap() in include/linux/find.h:

#define for_each_set_bit_wrap(bit, addr, size, start) \
	for ((bit) =3D find_next_bit_wrap((addr), (size), (start));		\
	     (bit) < (size);							\
	     (bit) =3D __for_each_wrap((addr), (size), (start), (bit) + 1))

Because start is expanded inside __for_each_wrap() on every step,
raw_smp_processor_id() is re-evaluated on each iteration rather than
once at the beginning of the loop.

__for_each_wrap() relies on start remaining constant across the loop to
know whether the scan has wrapped around:

	/* If not wrapped around */
	if (n > start) {
		/* and have a bit, just return it. */
		bit =3D find_next_bit(bitmap, size, n);
		if (bit < size)
			return bit;

		/* Otherwise, wrap around and ... */
		n =3D 0;
	}

	/* Search the other part. */
	bit =3D find_next_bit(bitmap, start, n);
	return bit < start ? bit : size;

Since zcomp_dstrm_get() calls zcomp_dstrm_excl_tryget() in preemptible
context with migration enabled, if a task fails zcomp_dstrm_excl_trylock()
on CPU k and migrates to CPU m >=3D k + 1 before the step expression runs,
__for_each_wrap() sees n =3D k + 1 <=3D start (where start is now m). It th=
en
treats the scan as having already wrapped and only searches [k + 1, m)
(returning size immediately if m =3D=3D k + 1), skipping CPU m and the
remaining online CPUs.

When that happens, zcomp_dstrm_excl_tryget() returns NULL and
zcomp_dstrm_get() sleeps in wait_event() on comp->dstrm_waitq even when
idle streams are available on the skipped CPUs. In the case where CPU k
is concurrently taken offline (so zcomp_cpu_dead() sets local_copy to NULL
without waking comp->dstrm_waitq and the task is migrated off CPU k) while
all other online streams are idle, no task holds excl_lock to wake
comp->dstrm_waitq and the caller can sleep in TASK_UNINTERRUPTIBLE
indefinitely.

Should raw_smp_processor_id() be stored in a local variable before passing
it to for_each_online_cpu_wrap()?

[ ... ]

>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261018035125.3120=
704-1-senozhatsky@chromium.org?part=3D12

