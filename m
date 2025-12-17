Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D31CD6554E
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 14:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F9B6B0088; Wed, 17 Dec 2025 09:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806BB6B008A; Wed, 17 Dec 2025 09:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D0C6B008C; Wed, 17 Dec 2025 09:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 649B76B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:30:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 142961A0B1B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:30:41 +0000 (UTC)
X-FDA: 84229199082.09.46ED92F
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 10240140023
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:30:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jJOTEGar;
	spf=pass (imf23.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765981839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bObqtAYbtqPyRtytU8ZPzJkSMQTXmYD1zvhyUZB6ziM=;
	b=AsMJgQg9yBLlorR4y0fQY1KK/F6uK2ob9g+lV3nQlgsrBnHoff6OLUTSpsN+Mv/PgGLCTP
	7z1HFfFV+1BGwepa02MVGb5hwlieADpdifQcPcOerDyMhIRr7Of79U5ut77aneLmCN7Uqt
	OhrrKIBFhiy5I6ZVedQ9au9QHA4mWU4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jJOTEGar;
	spf=pass (imf23.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765981839; a=rsa-sha256;
	cv=none;
	b=oj3E1M//dKZ2k1dSZtTQ/HT6lAdrUhdZj2SS1OTZ8/TXAAKM50fSjySo+XSFrljzhKOWcE
	AKs097iuxi88v2lodfoFfallmvOmuSIM6glkNxmdBzuIGLotbQAnuiRvBHYdmXFSzXsBO+
	EtyBFvsn2Mi1FX4IH9TcnZE0MhCP3iI=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8885b3c06caso35165396d6.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765981838; x=1766586638; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bObqtAYbtqPyRtytU8ZPzJkSMQTXmYD1zvhyUZB6ziM=;
        b=jJOTEGarEwVAjOVDtpTFbBdtvnx/t4PxgZiWkXYKlcO46T5hJzinx4mo9TeD7NiuTI
         peuu72AIoMH/ckqPiRI5UqK4s0EqqsIYO3xnxuBmH4Dzbx+M62MBgVjNFxqs3iwCotza
         AD/LwkcC3JJwCnuc8pRh5EV7fI6YrrsqO89z+Ms6P6yRSCON+IMROSiRndH0hMfaLQaf
         FpXFoUX5nEeTO0MyNGLCPbzJpRcXGl3mQLu2Kr50jRUwOBrNRtkhEgPC5jf+AJUYxP+0
         pHaZYi8YfqEGVUQ6s4TKH0Hh/KzvUqRwFjgd2ZSOCqpfbGdGZGh52n0e4W39R0+0uuIs
         ubuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765981838; x=1766586638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bObqtAYbtqPyRtytU8ZPzJkSMQTXmYD1zvhyUZB6ziM=;
        b=qEfgGM8Nz5zd9isMWBrTJ0J6QlHY+S+tJ3jyWyWxkHXhK34PlccWjYyZQ/hB/40Hj1
         lo4Oe4L1K1ITB91dkZm7cSsioWGtD1F3tpgi38jd+edAFre3y559Cgab/lNYiN56+hBC
         fYwYVUnJLScQx8mCnNZRthe2UHAJpqp3GjwMJmuNXHC0Xque9h2/nvxz+MYad84rLkJR
         c8w7Rp8+XevGRmFSzNn+eb1aPQyK7o2EEwUADT+aUzkviCjA88bQuhSI7W/J0TL9yG88
         TCzRsEFWNqmEXiYbYGKF7oowohu3htnm/JWUWdBDBnFspRkBzYHwhe4/5qap1in6pBsD
         qNRg==
X-Forwarded-Encrypted: i=1; AJvYcCWfTYnr7FVHoe7kA8wmXQTLJF5FkTjC7qgJ80s9M14vV+Y4RtC25q1nTKK4GaY6eauWYmp5IrkPnQ==@kvack.org
X-Gm-Message-State: AOJu0Ywl2akbbHhi5iRiqFM+zfVq9znHcZFo755CNk40h8d29nQbsCff
	X3WlcnyspGZPwFgYLUd/7mEAFgCZcIL/jaoMjJIdns5nu98TGH/ekSZ0M1vb079bfRQ4MZNmqHu
	HAGiKIIqkn1GWSkUvnayqdcs9j0uQct4=
X-Gm-Gg: AY/fxX6YnIizkgNKWabWfCj6I9Da2ULF15Q+D4aVfaKUZqdElj08oAy6E5RBNSclaU8
	B0yKNCIrT4Ny383QMoBslA7wczNDVfy6lh8pZqe8887nB0vN+YlWqRZweARhd0sRmrPSBUwZaLl
	GWo6KUesIYIEE/OfcdsU2WjtldSvAL90ump5qk4NOs8OSP6DepIaQF62QDPAeQJh/2LUoP4z42W
	7eC9UdNxPhGrHR/OnIoeemFIPPaQp8xuwKhGE2ALkFyTdxo0pImwnEyufnwMyb3Ix2qJIr+rDRT
	Wh/unOpUgOk/bbNI6ilijgU=
X-Google-Smtp-Source: AGHT+IG9CjUX9xvTFuZx6a2NPrFwtCK7bxkx/r5NoPA7mfHv28qSmnSSIjA0N0/sFHA8ebvWgtfC8wdZ4CSHTHQWhq0=
X-Received: by 2002:a05:6214:1301:b0:87f:fecf:17b2 with SMTP id
 6a1803df08f44-8887e1681dfmr277315766d6.64.1765981837872; Wed, 17 Dec 2025
 06:30:37 -0800 (PST)
MIME-Version: 1.0
References: <20251208094028.214949-1-akinobu.mita@gmail.com>
 <20251208094028.214949-3-akinobu.mita@gmail.com> <01d780a3-16ef-4f87-b57d-00d50afa4bed@suse.cz>
In-Reply-To: <01d780a3-16ef-4f87-b57d-00d50afa4bed@suse.cz>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 17 Dec 2025 23:30:26 +0900
X-Gm-Features: AQt7F2r857gCtTYlq9_ZRMrLStQLliPCzDrXV1Jhny-QQKzbfSA_Im20lse9vVk
Message-ID: <CAC5umygxuqYrV1w3kMc+uaZuBgqcx3sX4MsZ1C3tLpHHTFZW2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/vmscan: don't demote if there is not enough free
 memory in the lower memory tier
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: czzq4gsejn7im5focnprhqcbyxmo7hni
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 10240140023
X-HE-Tag: 1765981838-22656
X-HE-Meta: U2FsdGVkX1+MfntxMmNZl+jj5LBrfB8CS7xXTaVBKIF+3vOPHoC2NkgoBxMk9x8fqow40iOl7TZThJGzW/3FhPZiLwJLKXH3jRu/EjmUZ0E9gYUK+SLhU59Y9ciEofBMeHejB9KcLN3L20FqnfPa2spA/sUC17XcmW8NISxzMYcvRUEqH/gcGBI30iD6swqn9xQh4VPTJAcMt/dwmX+Nix4QlylGarAp1HrMnGgS6+0kzrGIjR0OT1+1Xzhi4wIegfT50sBV5557ttJh4EBBfwEbeFnyQIvPlZAOtAyQskwTOqK2f/BqR/45ZMv11FEsTcYBijP5wxwk361Hc6FNrEnNVu2e1KKGvjgr9G9LIvi6G+wT2PisuPwiooeIRNUg1HEvrx3aFFDFoPUdmbI+Vj3EIMB2VkpC+xTKba5d4oBUG8r4vsxOPGgVM5Ztk+Klz1S+86r+jhrmgtucWvg9qk45vDfshmgYhyBNXbnWCldEJtrooCrRUeXwAzTjr0hW6bNFgfZTZT+BmRcSax0zt8vQ824HsyoRNC0J3uNlNEAtS1iKi77/45Byi972qKRfSuw6goIMACPB3cekZR5WLkS3q3fudKqhMW01ZVv1GO69W1jhSgq6KkkHY1od7NbcKJ4iNbjlmejF4YgBzo1tnpNDUVtxJhgYaz9ukz/wVsQQ8Z+BCBu8rF00In6dERE+CgHnh4KVCCwAcQccZ9AOhI7Xx3IpF8lCYra0kzdIJqOXrQrrmK8jMWtxlY0Ze05ooCZ5N551xDkXhzVQDKboNogpw/BscpMErMwbvdNKpkPWF34KSZqSC/vdjGgNIdUYE4i6jHVjKrzPaoJLB7tcjYh1XobVncNgu5cUPv75y64YE9Pm3JJqxy0yFWTRWtblG3WiKZZYr9pv1F+HZeLOI9FfAqj4WP2kSRdnNw5QtNJ2i8dpd6Wk/X9eUp0xgrmuWRp/VW4kY8OStPfZeLE
 xx1qmB7j
 B40gyYsMEGomFT5bSRG8WOQvsJyFeu5vANzmrFouIn3FtGdWJRq5gsgF/+JR4/X5c+6zRcqM9UPL6Ufa64gqePmm7qejfUI4eUddn+0uG6UnADgWJ7yVXYzZW16nW3zOacsX2fp+M5hGqgM8DsBYFes1Zz/8CXnkCTjF3/Jj8wsBl3DI1wtN3sUs8WA+QZi5AYqijStp7tQV4PgjjjB1yZmRxZhGQ5/hUCxF2VGdBiF24ygeeHazDq21IVM74mmX8nYkJFzRKu4zYZGu00tO53mzJpFQdwLF6Y7ufM2FH0IUHO6YkJSqX1Q6wUXhD0+/f0vYV6Jq4n9OJm92qfZDICppHOPWnsLHX2OrkkN39Um8NHtnQLCl+VMSO+7Lq6uuGugqT65isy6qta4xhDgvVwI1Bjf/M+dhgWXvO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B412=E6=9C=8817=E6=97=A5(=E6=B0=B4) 21:55 Vlastimil Babka <vbabk=
a@suse.cz>:
>
> On 12/8/25 10:40, Akinobu Mita wrote:
> > On systems with multiple memory-tiers consisting of DRAM and CXL memory=
,
> > the OOM killer is not invoked properly.
> >
> > Here's the command to reproduce:
> >
> > $ sudo swapoff -a
> > $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
> >     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> >
> > The memory usage is the number of workers specified with the --memrate
> > option multiplied by the buffer size specified with the --memrate-bytes
> > option, so please adjust it so that it exceeds the total size of the
> > installed DRAM and CXL memory.
> >
> > If swap is disabled, you can usually expect the OOM killer to terminate
> > the stress-ng process when memory usage approaches the installed memory
> > size.
> >
> > However, if multiple memory-tiers exist (multiple
> > /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist),
> > and /sys/kernel/mm/numa/demotion_enabled is true and
> > /sys/kernel/mm/lru_gen/min_ttl_ms is 0, the OOM killer will not be invo=
ked
>
> Does this mean only mglru has the problem, or !mglru too?

!mglru has the problem, too.

> Also is min_ttl_ms =3D 0 a sensible setting? What happens without it?

Setting min_tto_ms =3D 1 or a longer value will cause kswapd
to trigger the oom-killer.

However, when the stress-ng devshm test was run in addition to
the above test to increase the load, the system remained inoperable
with only the oom-killer by kswapd.

> If !mglru doesn't have this problem, how does the fix affect it?

With this patch, the oom-killer will be triggered directly from
memory allocations, regardless of mglru or not.

