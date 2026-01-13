Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7B7D29DDA
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 06:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6B26B0005; Tue, 13 Jan 2026 01:42:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE196B008C; Tue, 13 Jan 2026 01:42:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7686B0092; Tue, 13 Jan 2026 01:42:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3A26B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:42:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9DC1138AD2
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:42:19 +0000 (UTC)
X-FDA: 84325996398.16.A076435
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf13.hostedemail.com (Postfix) with ESMTP id 867A420005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:42:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=YcyW8Nml;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768286538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Qb1R4lnjaFXVEvzdYsxnVqS8DmE3lYGKOt4usy55kw=;
	b=fwy3YC/6Xi/wiE0sFJEabJ7aFGkaiiEIO8vU5h7J5Y9mRwqwwqJy+Ts2q6M9uQdWCN2kEM
	PEB0PXqS8jGRTBhRbl/a2sZ8HJJmLoVNCBxteEjsDp0FkCsmxdq+NtxmuzZMcHhKEWsaPn
	tLYelchGtgpiX+EgSyplDrsFZoN2SBw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=YcyW8Nml;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768286538; a=rsa-sha256;
	cv=none;
	b=erfUD/CFjILYyWjKvAzgdrl0Yb9cA0LB5gi63zF9yciCFKqxKeX6mIqJsig5UKQOx34V+z
	I8nTvhxES2K/8Uq/sV5/+ua24shE3NG86pa80PHpBkAxJWSFh6IH+BwcC9JjHRMad8Iau1
	OMqP8HisGFJv8tZNrT9lbOZbCdmqOx0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768286530; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=2Qb1R4lnjaFXVEvzdYsxnVqS8DmE3lYGKOt4usy55kw=;
 b=YcyW8NmlcrOM6tM/LguKMMJyP/+8swEA9nPSC12emQH5xPOQifiP3wZsrTpkwIriIQ7mXt
 zDTq2Qburr4aJv99EvyttjBh+sRPe56EHBKLrMizl3idFkpGsac7hl6xXf035ZpKdJUCE1
 X7fbftjhticwWCB+ylwAXWF0TYbWEPh8IF79D26pwPfDgxcSL79zege9AUQ/QRhgAxUlSr
 cXkec3gV849VnhaD6NmNrqZ23YONy3DKsnM6+oZF3fkOgLOYmB6UEMaAIYulWorpWVzPWx
 Opp1PiIfNW1e/X1ICMo87MYwinyu1FxoQtxjKAXNo2dk5Fph/q7PWjv17hbK6w==
X-Mailer: git-send-email 2.45.2
In-Reply-To: <87jyxmjxs6.fsf@oracle.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <fvdl@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <muchun.song@linux.dev>, <osalvador@suse.de>
Message-Id: <20260113064155.29900-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <87jyxmjxs6.fsf@oracle.com>
To: <ankur.a.arora@oracle.com>
Date: Tue, 13 Jan 2026 14:41:54 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26965e940+ca8246+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 867A420005
X-Stat-Signature: gxmskus5e6wxs3mdqcd4msix9xw8odow
X-HE-Tag: 1768286537-780337
X-HE-Meta: U2FsdGVkX1+I+r7CCmNzEqplgERQ8qsEy8qmtIyaHlEXC1qGcjJb8bgVAf2uk7v1NKZTaDTWvF0+qA931Yyu0QVvaDXTW2lsDDPNX1fXnWElYViomHqaEb4NQO2LPxIyKDeq+5+/oNp2qpJ1HqLpGqRoZYExPS8Rd9YenQTJGp4ekaZtSjPcOMPJ+tCQeYA5e7gE4g5gzeEhNwykHb6RztgKXLhl6a9+cqr33KPaAciD2KPWkPUwV0KpCIpDpSMNmtL2EMEIvBQkHyrf4FPJyVlw+dtwhrV+ZKV6Fs/jywqjCBVr9OF8VoZgUx0ml1I2/5bEB6gCQWjljLJ7K2kHP1sMZWaD7y8+cNM3nwjqe/tvrHP84Uui1zRfpuqYVlllGXeZ1ARTrTRNGkpn3Uo6ap4S4sMXR4KFf5Z7IFNMjklALDnsfLLu3dQY2ttXZvKCsJbRFmcGKxsGIAZR9wPZEjb0nWw8OFKofE41vNEP2hgY1coFcIz987OESEqsH/U1ACaR6bnx9ZePM3B0dcrwIY2oQ4xmGnYLQpIHcoShMBBSj4vGHse9lZPc6TeMkFRdZS2Jdst7/Xt1/yFq2xp0Kv8Obi2iWg/pOwQtNvEltwXKFemKv7P9RNEhnL0nKThB43SvKkgSdbBBVZw0XhRc2hCiZGXI5vOOKIWZRlTD2BYDTrZwTgS3KxInfuhXiHnjWS+5KD3v7G9EnPZhdM3sasGmyvYJMreJVKUZQH1F/CkQX/txiLIxKM+xpCWWWUNNUV5JU9f4g8uNmEH/sWUaMI+YWKSjdQaybwbTScgS23T7/6IPi0BMfOjARpDQ89xYpAVQ+k1d9+Hf085w3YDZ74j98dU0dQXib3sj2DyCBsiGRB6gQh/DOXeKDcORwn825XuWQ24NLX20c/7zvOVx1yy0rlgJZ92v/++vf9jnFD82Mjwdk9AvyqIitU1z99Gs+Ey9IK3YbqOyHC2qdmK
 NF4MfwfG
 bRYgTrAW89AOGQ1Ym4vPOPD3smSDBLhzv56huvSP6z3kXjMsdlrdBPzCy0cJicSUxajcxJ2akeASIbNKE9Sz8sk0UGMHJN5mR50Zyor8VtHzldpuhSNj47uMOhes+JKegb1EUceDGszF3i62PfcH6c2PLGJ78XbB2eFjnfaUnP8JYI2cO6oJlztherIWVfiquF2uykSAvCtxxmB8Ip8Aea+ID+or9OeWb8LPJ2eY0qIuIHLC1o5mQJArSO5Hvsqgu7VSt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 14:01:29 -0800, ankur.a.arora@oracle.com wrote:

> > In user space, we can use system calls such as epoll and write to zero
> > huge folios as they become available, and sleep when none are ready. Th=
e
> > following pseudocode illustrates this approach. The pseudocode spawns
> > eight threads (each running thread_fun()) that wait for huge pages on
> > node 0 to become eligible for zeroing; whenever such pages are availabl=
e,
> > the threads clear them in parallel.
> >
> >   static void thread_fun(void)
> >   {
> >   	epoll_create();
> >   	epoll_ctl();
> >   	while (1) {
> >   		val =3D read("/sys/devices/system/node/node0/hugepages/hugepages-10=
48576kB/zeroable_hugepages");
> >   		if (val > 0)
> >   			system("echo max > /sys/devices/system/node/node0/hugepages/hugepa=
ges-1048576kB/zeroable_hugepages");
> >   		epoll_wait();
> >   	}
> >   }
>=20
> Given that zeroable_hugepages is per node, anybody who writes to
> it would need to know how much the aggregate demand would be.
>=20
> Seems to me that the only value that might make sense would be "max".
> And at that point this approach seems a little bit like init_on_free.

Yes, writing =E2=80=9Cmax=E2=80=9D suffices for the vast majority of worklo=
ads.

However, once multiple mutually independent application processes each
need huge pages, the ability to specify an exact value becomes
essential, because the CPU time each process spends on zeroing can
then be charged to its own cgroup. If we currently considers =E2=80=9Cmax=
=E2=80=9D
sufficient, we can implement support for that parameter alone and
extend it later when necessary.

Although =E2=80=9Cmax=E2=80=9D resembles init_on_free at first glance, it l=
eaves the
decision of =E2=80=9Cwhen and on which CPU to zero=E2=80=9D entirely to use=
r space,
thereby eliminating the concern previously raised.

Thanks,
Zhe

