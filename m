Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1561AC4451C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A586B008A; Wed, 22 Jul 2026 03:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D028E6B008C; Wed, 22 Jul 2026 03:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C186A6B0092; Wed, 22 Jul 2026 03:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 990AA6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:16:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21C92A0B04
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:16:14 +0000 (UTC)
X-FDA: 85015553868.04.2B82124
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7BECC8000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:16:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bc2KXFhL;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784704572;
	b=LnouhpbjBX5ilNTXzZMlbtT+ZMZovaeiwHp4QYQkUy/VLhbwfZagHRoYtXaWNoKoXYN4ZT
	ORJzOqdXsLY7jhylvRAqeFIiSo2od8RNzEFzxt1f6OAg5Wiv3VC15kqmk49pWSoSxqL4vL
	pNajuLsgFpvrgHu5a4Vez/mk4Z77Apo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bc2KXFhL;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784704572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QczM2k3gjfBkQg6SLRGr4KO6x2nabmYHG3X/oqp3yTs=;
	b=TtG/Vs6L2Spykt9oIlWMVZiXCUh1NL0V7zbY/sTz7t/osCGgXZYwjxCY7ZfDOVsHw6JfXj
	NNdzDTGw1lSDtVVDk2XyHDAVpIS2+LKmACrX/AVApMSRrsS4p4LRVBcPkKe03n26K2h9J2
	cQ5v/lzm5Iegc4ziF12N5lKLd1wjZYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D88A960A67;
	Wed, 22 Jul 2026 07:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CF81F000E9;
	Wed, 22 Jul 2026 07:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784704571;
	bh=QczM2k3gjfBkQg6SLRGr4KO6x2nabmYHG3X/oqp3yTs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Bc2KXFhLyD1DFGv9udYttAPL0u9PjXCUNwYk04HPyfgCvnAu9cGaUQrkVKvywTKP0
	 q6a4lSNIvV/Uj+o6GsQJz7gfTQhwKYCN2YV0cMHbW9FvAzXDNF/r4gRv347/cb4NkC
	 BVwlbm1iBJ/BBJaazXm5X/zPLqkS0JgXjeJxDBkvuFqjPh+YhL2ruH6sNcNAGmJzKc
	 qcOh6urXoStSQVqxwmwYJK0SDceGzyBkt3rXoQVi8NT1r16WBweAkE1aN19QvgPL/F
	 w1II5sds5nmCRYLsCDvcjrsmqp3Oygz24L/gQM/umdbjIO9AQIsbSR9uTfnPF3ijIC
	 NfIcK7iov/lCg==
Message-ID: <004d1215-a1da-448e-bf10-df637c7029f5@kernel.org>
Date: Wed, 22 Jul 2026 16:16:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 1/8] mm/slab, slub_kunit: register kprobe
 to trigger _nolock APIs
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 ast@kernel.org, andrii@kernel.org, puranjay@kernel.org, ameryhung@gmail.com,
 bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org,
 paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, boqun@kernel.org,
 urezki@gmail.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, pfalcato@suse.de, surenb@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260722112748588_IEr10bQdigv8c8bjw7Ck@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260722112748588_IEr10bQdigv8c8bjw7Ck@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------l2diSXyS8PSFwRyJhRRP3Q53"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7BECC8000C
X-Stat-Signature: y9gqhgj74bmtcpbykcec7brmsyrxf41j
X-Rspam-User: 
X-HE-Tag: 1784704572-70362
X-HE-Meta: U2FsdGVkX19DWxC/V4RXPTj+ZCjIlEZh+mkC9KkD+4OETcZ9AoGlSokS9nDICKi/pRGulb5Y2mqnlV05ZWsvLzPU4B4enInoSmtPbAdFk2fkvYeXPinbiXxXGkTsehKU+PJ/zJ8lOz7HSgyC+pNn7TWF2jADL79/3xZvpwrxQxO44q1bbCk4zOn3ap33jOwcZrUI/t8rCtXeaqSiY6tzihZyb3Rb0NwNDu7Rf92v9JYJjn6RqkT6Gcmn5clO8H/ZvF+V3j2nvk13/EGp8Xa5u3aoQ7jB3B9ozaKrv+wp9GOM81mjcZKlg/fJlFe27uxwZlVlGKTvrPhiB5AUaTp/iTc1jXEhlwoNMH+c0eSh042YFpgxbw8+twpiF21xICWBkkeOAEistVGNI8Wu20Nb4W3Ar3woA19R65kH4ILzzNiYTRB0OL9IA8vWOC+d8A88fXluAjJEwYUd+EU7tIHWlQlsanRCz16TcEmksxlTM6jxRmQ5UK4/pjnbl3ET5kbE2pP93SDubFpwcMBTJv7Zn5drOQo2sW24mFnVd0mL2SvF16KafksdeSy48PUE0PjXr8o5GUO/QSqhHi0su3EsfJSz29aAnRfbRw5HY+jdAz7amRXNKkDCg0b5v7ZMgPDPNuYC246p10XyLBVmA9eZAZEy1jFdWZmgl8UwGwwumWYrTk8Xk8LydOFmA0wHiDWj9AudtPpv+3LWZScPk5FNuh8xOWsVRCZXA7OHLmpm3Dl132Qxqr3PXX7rZpmMu8WrtRJqCOl754Q6FAJ2zLhoZC8Q+7AgsKYICOJ4xldfegXZ8v3PJvmyt4RdkwuWI6UjgS/988BMaIrUiPkEnS3T5TMHhUCVfPDzaRbywjE2VHiRGfurqlbyA6bRGQR7idhAGsUp0MizMkhYtR6GmvxGNTW7/M2I8qhJvDOJEyMpkaaGpWNrNffncYl6m+oOJTKsd7f207Irf8KXbnz1sL3
 I/MSwc7Y
 e/hQ+vNeTlB1O8c3NVDD7+QzFuSieay6u/H4uCCyLq/LJPabDXx1/00nM7bKvz8sVJvoNMSHBWHh0bi/W5/ebKs8+ulT8fgcm958KbHQY8nM3jS5CxpKYGZ/nVhoQRACk0Vm/fV+pHNzB/HMYYUHBXbniX5T+LbV3Hw7f98iWykrBga4VG7dYq2D/a5Z4kCCo+SahY6AQ5WYCzHbzxnamxrSIyklb8SuUlo90dlpylYsBVOxTr2fpR7Cgq5yD1NEJZjiEPUHVT/z7q+WEE0QBNofSNtm8OE1J7aK5nYgSvtZaVp+JJbGyVCDLCHC3rw6V3UD1ETG4sijQ3DB6A3sYu5qAmnnxSDzJqiI/3UMPXGBpDB+n60MnfSmvEYqTtU453/xpSv0XFTw/Y3NlMMu0UCAn8vIKEaUuFCVhrjgsfxIUHMU8++Con3vVIUcnIXADxsbhi/p5Dabfa4SxdweMfCfDN4j9LHXHurFUKNAN+e2428EgzDBQdiHC+miKypx2tyXKTCT8p4yKYG7KU5coEWlzBGH9Q1FutcYZqGyDCZsEld4V8j+KLAvHqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------l2diSXyS8PSFwRyJhRRP3Q53
Content-Type: multipart/mixed; boundary="------------80TQbEbkEElO0TKxmuJVujmY";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 ast@kernel.org, andrii@kernel.org, puranjay@kernel.org, ameryhung@gmail.com,
 bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org,
 paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, boqun@kernel.org,
 urezki@gmail.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, pfalcato@suse.de, surenb@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <004d1215-a1da-448e-bf10-df637c7029f5@kernel.org>
Subject: Re: [PATCH slab/for-next v4 1/8] mm/slab, slub_kunit: register kprobe
 to trigger _nolock APIs
References: <20260722112748588_IEr10bQdigv8c8bjw7Ck@zte.com.cn>
In-Reply-To: <20260722112748588_IEr10bQdigv8c8bjw7Ck@zte.com.cn>

--------------80TQbEbkEElO0TKxmuJVujmY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/22/26 12:27 PM, hu.shengming@zte.com.cn wrote:
> Harry wrote:
>> Since kmalloc_nolock() always fails in NMI and hardirq contexts on
>> PREEMPT_RT, slub_kunit cannot properly test _nolock() APIs.
>>
>> Register a kprobe pre-handler to invoke kmalloc_nolock() and
>> kfree_nolock() in the middle of the slab allocator. However, do not
>> register the handler on UP kernels because that use case is not
>> well supported [1] in the kernel.
>>
>> To attach the pre-handler while s->cpu_sheaves->lock or n->list_lock
>> is held, add a wrapper function for lockdep_assert_held() that calls
>> a no-op function slab_attach_kprobe_locked() on debug builds. The
>> function is optimized away when neither CONFIG_PROVE_LOCKING nor
>> CONFIG_DEBUG_VM is selected and register_kprobe() fails.
>>
>> The function calls barrier() to prevent the compiler from optimizing
>> away its callsites. Otherwise, the compiler may consider the function
>> does not have any side effect and remove callsites.
>>
>> Compared to using plain kprobe, this has two advantages: 1) it avoids
>> hardcoding function names in the test, and 2) it can trigger those API=
s
>> in the middle of a function, where the lock is expected to be held as
>> annotated with lockdep.
>>
>> While it was proposed [2] to use kunit function redirection to test
>> this, it is currently infeasible as some lock helpers don't have
>> symbols.
>>
>> Factor out the nested loop that calls kmalloc and friends to
>> test_kmalloc_kfree(), and call them in
>> test_kmalloc_kfree_nolock_{perf,kprobe}(), each being an independent
>> test case. During the refactoring, drop alloc_fail handling as it
>> doesn't provide much benefits.
>=20
> Nice test addition!
>=20
> Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

Thanks a lot for reviewing, Shengming!

Just FYI, I'm going to adjust a nit pointed out by sashiko
that kmalloc_obj(*objects[j], gfp) is wrong because objects is an array
of void pointers. (which is fixed later in the series)

> Nit below:
>> +static void test_kmalloc_kfree_nolock_perf(struct kunit *test)
>> +{
>> +    struct test_nolock_context ctx =3D { .test =3D test };
>> =20
>> -    kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %=
d\n",
>> -           ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
>> +    if (!enable_perf_events(&ctx))
>> +        kunit_skip(test, "Failed to enable perf event, skipping");
>> =20
>> -    if (alloc_fail)
>> -        kunit_skip(test, "Allocation failed");
>> +    test_kmalloc_kfree();
>> +
>> +    disable_perf_events(&ctx);
>> +    KUNIT_EXPECT_EQ(test, 0, slab_errors);
>> +}
>> +#endif
>> +
>=20
> Maybe it would be worth checking that the perf event actually fired:
>=20
>     KUNIT_EXPECT_GT(test, ctx.callback_count, 0);
>=20
> Otherwise, the test could pass without the callback.

I'm not sure if that would be useful though.

Ideally we want to make sure every code path that handles
allow_spin =3D false is tested, but it's tricky to measure that and
also it's tricky to make sure those paths are properly tested
(especially with perf events).

callback_count is not a good indicator to measure test coverage.

(I use GCOV to make sure we have reasonable coverage,
 but it's hard to turn that into a test case...)

--=20
Cheers,
Harry / Hyeonggon

--------------80TQbEbkEElO0TKxmuJVujmY--

--------------l2diSXyS8PSFwRyJhRRP3Q53
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamBuMAAKCRCGXBN6rc5S
1sPeAQDxKa0DMrDQTezN00ksgEUR3eb05xC3gVwrShymZlkh5wEA7tBOlrr/Ntis
S3x7DXHLG0TmEitCZ5rUhYKcT3diOQI=
=g7jN
-----END PGP SIGNATURE-----

--------------l2diSXyS8PSFwRyJhRRP3Q53--

