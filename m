Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315BDC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A666B00B3; Tue,  7 Jul 2026 02:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5056A6B00B4; Tue,  7 Jul 2026 02:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6626B00B5; Tue,  7 Jul 2026 02:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0605F6B00B3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A5B8A02FC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:36 +0000 (UTC)
X-FDA: 84961032072.16.AFFCD64
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf04.hostedemail.com (Postfix) with ESMTP id B705F40007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="aqiA0Q/D";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="DiBkaT/r";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf04.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObyCEryIwmniZMWVgbaPW4hyZdtbe1mtphtq19MumpA=;
	b=RNNDyOKwsrkKBBuIxTjpFOjxnO1J0IzoVq9sVc75INXqT4J+XrkAFzTyjARy0DV0q0KAsf
	1DAoxF3m/RyjtsFczhMhATV6n9k0LA5wrtHc0wmk0qZ2PtdXRV0uqiQECwu2sX8SbiKxd/
	DBeR/n/HxG6YOtEmiafkkgC6nTizqtw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="aqiA0Q/D";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="DiBkaT/r";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf04.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406434;
	b=poNKrApWPm+lPUn1NWzcXgubG2B/EaeOzKtvYZHG4ENj/FEuw2vISNSjdoaaTRJ8EVLzQc
	HTiYubK0KiCYTUPpfDOhnIE5wSy0RdVBmEN+8dRFAuyxPankmKB1d77B5xaMdXAUlKWraI
	74b4DVsKrQzoY4B1/zRDPiQ7ooGg9UQ=
Date: Tue, 7 Jul 2026 08:40:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783406432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ObyCEryIwmniZMWVgbaPW4hyZdtbe1mtphtq19MumpA=;
	b=aqiA0Q/De1LQTMVcPL443duYUftLEhAds/ioHhSi9c7pBkHim65H+7Uiq16TWEmbFU2a1k
	p9uyVTd+wv4igg30l085v6rLL35cNoG3Jz+Tb3z2Oj6c5ZVwQ+fq4uPXCBy2Ky4Mys4Z0F
	AdZbyTrY/CmhyQ7lBF4thi5AyZYNilvoCJOxEbqZnNN8SHdDTuQzIYJd6h43sszuOQTEn1
	CQzhfMOMHVdgdJgPIytUh95nEDxPC3ckFRNz/mkWJVgJHA54k9I3MnKTFNNikPMqK4iOAL
	5WeB8G+qbU3Fpxowc7gh5SXyldug0VS1gqR00IGRL8tlN4r0YoxC+2eANjVnIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783406432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ObyCEryIwmniZMWVgbaPW4hyZdtbe1mtphtq19MumpA=;
	b=DiBkaT/rhrfJ64NQmFry1pmfAdq55vJHTJVSi7+Yu75tSJDOmYgcUqyioM8ewOftFnQAOO
	Pdei3mnVjhtcTMDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Hillf Danton <hdanton@sina.com>, Kairui Song <ryncsn@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/19] zram: sleepable entry locking
Message-ID: <20260707064030.D843llKh@linutronix.de>
References: <20250303022425.285971-1-senozhatsky@chromium.org>
 <20250303022425.285971-2-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250303022425.285971-2-senozhatsky@chromium.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B705F40007
X-Stat-Signature: 6a345itftwk4t7i1hmpbwwf38tikohs8
X-HE-Tag: 1783406434-656068
X-HE-Meta: U2FsdGVkX19juAf74rqf+NND3Fq3KYzFHDRnVOF5Av0VrFMXxeZStxut9Ao8v7M1BcVIQfKHkNt8V/kestU4rFP6BbcWxmck+33Z7mf9uNridbRSkikBb/v5dE/dnqcs1IRa9Zq9FLIryc68QcHPdaEreAcCgI74sxlSWkjJbCGbCsuBMX0QteT4w0osqMu8pdrTKJ9SYYctZlN4LdEGbpOVTO/TBwJLytCdLtTZHV9RD7Wd0lyF/g8iYbaWOULiR+lOW8HeczxLkAClLrcAJtj2QcCGQ/e8a+r2/ylfjiZfx8mc43XI8W7S6VEPcneHXWiJVp9RNavne5Kjv37tY5yAJCuIZbBlqsZ6d13HH+bPF21eLIE8qH+97cH8CgHgDxMpZkTjBQZQ7GdRRM21uxXMdgX7a8Cx6rcTD1pEqe7w4VN0M70ydr/5qEkYixH1mpTPhKRXWr483iggClHUdMlchZVG2kjWXHbM6JVy0Fo3kREvdefperOKxb7b4D411hWFnO0P+cYC+CEK3JX6gadmch8bFhmLuSGO3xDTCnxjK+4PmkUu7/LhpYjJqajAll2UIdKnC6JO5MWG8//bb8+i9rU3oCju6aHTahz0wF4Tg9V9q95a3hf5K43Hi+OPSKjXZ6dcooCxx8J7n/kS4mWS9OOZDGonfpp7lGkVCDZkTlBdt4D7KxNau63cA0PJF0X9wNkX1SrFJlUHFz15d2EOi4BCyStGU9Q1O8onK7R398DsDCWf3uFMfpRmgJW5lj/ziTAnye97Naq757VBNK5AOvr3pIHEcKt4TE0Qk1T2fLzvCdXRkT8k+wVAdgBi6RvxA0sahlUs+b8U+HJlNQpdgZmhoD3wvW63TWMXs0s049wRGPUtAcedpIQxCy63kX8rNI/OcczxjeqJ2m6dlt58Xp13uJQi6d0ko5FeZ5roYSVYwZO59DJAIlfCLvw+rG+SNere8bXWT0iFLWW
 hjwz9a2U
 FKFLP5eti3ztc1TS4xNoxAaTQL9AZgaga3dUCZlr5GFTD6iES+iPBR8fO1yvA7hUCsFWK4FMcoSJMjYvDJoG1Rla3NzD05c7Snol8Sb0xchLVAtzNOkz83Vrewzfuvr6WBKKchPAaTo0YDZmxfeVKZ/ns20Eah3qRbx59F3bI79ZMgQESvpvKO9wdG8uPKFPeOXPfTtX1YCoEmsKCHS4t4+cw6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-03-03 11:03:10 [+0900], Sergey Senozhatsky wrote:
=E2=80=A6
> Having a per-entry mutex (or, for instance, a rw-semaphore)
> significantly increases sizeof() of each entry and hence the
> meta table.  Therefore entry locking returns back to bit
> locking, as before, however, this time also preempt-rt friendly,
> because if waits-on-bit instead of spinning-on-bit.  Lock owners
          of ?
> are also now permitted to schedule, which is a first step on the
> path of making zram non-atomic.
>=20
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
=E2=80=A6
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -58,19 +58,56 @@ static void zram_free_page(struct zram *zram, size_t =
index);
>  static int zram_read_from_zspool(struct zram *zram, struct page *page,
>  				 u32 index);
> =20
> -static int zram_slot_trylock(struct zram *zram, u32 index)
> +#define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
> +
> +static void zram_slot_lock_init(struct zram *zram, u32 index)
> +{
> +	static struct lock_class_key __key;
> +
> +	lockdep_init_map(slot_dep_map(zram, index), "zram->table[index].lock",
> +			 &__key, 0);
> +}
=E2=80=A6
> +static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
>  {
> -	return spin_trylock(&zram->table[index].lock);
> +	unsigned long *lock =3D &zram->table[index].flags;
> +
> +	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
> +		mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
> +		lock_acquired(slot_dep_map(zram, index), _RET_IP_);
> +		return true;
> +	}
> +
> +	return false;
>  }
> =20
>  static void zram_slot_lock(struct zram *zram, u32 index)
>  {
> -	spin_lock(&zram->table[index].lock);
> +	unsigned long *lock =3D &zram->table[index].flags;
> +
> +	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
> +	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
> +	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
>  }

Looking at this, is there a special need to have a lockdep map per
table? Wouldn't it be enough to have one per zram? Logically you use the
same __key so I don't think it makes much of a difference but you could
lower the memory usage a bit by having less of those structs per zram.

Sebastian

