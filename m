Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6656A106FD85
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 06:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D916B0088; Fri, 13 Mar 2026 02:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E13E6B0089; Fri, 13 Mar 2026 02:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0B96B008A; Fri, 13 Mar 2026 02:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8038D6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:17:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 217ED1407F9
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:17:27 +0000 (UTC)
X-FDA: 84540032934.24.7C3EB30
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3921240011
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:17:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BymCD4Zr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773382645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlZNI/5acX8z6wx0x3sjimiPxTKa3g6pXUT2Z8+5yzk=;
	b=XAa31YaCXItUxMagVg4EFyodhhNTtOkIKiSHeoODO8WfqKRxWJysGPpZbswX4IvtcKBCtY
	0xyICSFlkNuQnHp33zYXp7BInWcgUBcxNTxr8cZKK3vu3hzTmzszihBoz6vW8zAabJB+zs
	MlNN5pBcTTo8kmkB2kUTfALHpMZ9BWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773382645; a=rsa-sha256;
	cv=none;
	b=MrPPI9fzk0byeh1gf03fh1qjYpYMOn0go5nZD8XbMeA98ZJQMQ3imOWN+JQlTsb2poSdch
	CoSKQ1FBRuUcrdimMjbL4tar7YxaKONvWmQalOD4LZCiVeiWDy516N75lTZZ8aZ3ekdXGh
	i8pC9NZZ7z0Jtrt1qwPslfRhlnVBAu8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BymCD4Zr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773382643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlZNI/5acX8z6wx0x3sjimiPxTKa3g6pXUT2Z8+5yzk=;
	b=BymCD4ZrgzFHF1x87zKIoazqFmSjkOaNt3zN1X5rdXKRlDMyukkg0amqB7bd+yuEz9vea7
	DzSPS4PMBxu0jIJifSFscC8oOtcNwv0ncRczmqjPYxbE5UdMJq/xluC0f5QAFgPd87aecX
	qNVBryDztRpsfB0Nyxr76bAhsphQFQA=
Date: Fri, 13 Mar 2026 06:17:18 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "teawater" <hui.zhu@linux.dev>
Message-ID: <90829ef692dabd1635daf6475bd09b192788376d@linux.dev>
TLS-Required: No
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
To: "Muchun Song" <muchun.song@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Tejun Heo" <tj@kernel.org>, "Michal Hocko"
 <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Alexei
 Starovoitov" <ast@kernel.org>, "=?utf-8?B?TWljaGFsIEtvdXRuw70=?="
 <mkoutny@suse.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "JP
 Kobryn" <inwardvessel@gmail.com>, "Geliang Tang" <geliang@kernel.org>,
 "Sweet Tea Dorminy" <sweettea-kernel@dorminy.me>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, "David Rientjes" <rientjes@google.com>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Meta kernel team"
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8F3593EB-9D81-4459-8675-E922426DCB1E@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <3ECC9B38-6C1A-4F60-9C18-98B7A1A56355@linux.dev>
 <abHPsCypwo7ZhqIt@linux.dev>
 <8F3593EB-9D81-4459-8675-E922426DCB1E@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3921240011
X-Stat-Signature: 45mu6kce43og6riei8o14tmcocybxqzt
X-Rspam-User: 
X-HE-Tag: 1773382644-864631
X-HE-Meta: U2FsdGVkX1/XzVkDybaM3x+diD/EfY/+Ab2e1doZZhAbNSQVnqFOpFbiu1AqMWyB4zK2gcIQPQGPtqIIBr1XfC2oMwJoiCLsRg5A3SYfs/XTzqOPW//A4ODpW285HFTwr7wzIFWKKwZmglQxzJKJEwtiK1o4GlxkpjUD+G+1oJBqXnqBtHpLwjOS6+oZueACVkDHZeNt/tAlFxY0Xv+8NhHwBClNaEngxJiSy/XU9vQWj/6U4y26SK6TnM5AAIo8r0Nl0ukxUEHK4/YYutG5KPGk3BWgStgLHY6H5KQPaoASP+j24jTTx0Rh9ArD5tHWMHnODu4a2ULKV7KrmTiRYnqL1zuqovZIRwi7B3es7mrKaKk4x5iUrrg7EIsYp52EZevxMKOafJMSWPzMungkWDBiE9eyVTzlCnPttNY4P1Ca8NCKMjnNFU6YDfBLKzdhkVvuBqNi/t16lwbS5Rw6OduQ9A1EP94IZmMjGN4mxWM0Jm3r+YpneWWaVbfZOxQx+rHyAnBZFo8Dj71fXEynzYCC7Vcy1tvrhTjBmsipqJOasxSMA9Zq3gNIFlu5P5Iwvz3fO9tIf2MmaHSS1707i6/rmdEnCvGQJsSDVGhTM0z+m+YBJ62v/OBJ9Zs3E0Fwa2y+kWX0RCf1nIx+FksigYcoUk8ozqhqOokkbsZTemzCdCOoJZpwSrYIUbXqGrOcP38MgjTcm4d+HwTOD9shziHquSZ/0r5sVg28P/DryPnmY63JfI2qSodRNMGg/3lN6upCFC6PhuUfMR6pD1hP0IP+X5Y/cVzin/igSk8PFNwXxkN1tshXOUDv5sBVQgfyC+wH/O+jOb8vJXY+JiO81EFFAjy/iMF1lslUvJ2DyLZPQJbMY9sDNqqbZDsXWjdSM5rFqOtHraTi3cOs70TcbTpCeVZObqzgszV4byNn5ZxsC/If/3vrAj2JK7Zv9Hvv5sVINRb4rcNKhPJkcs2
 AmAjcu+g
 opsep6qZGLFIxO/CJLrcrMyewk0tLEvE1rXtTlsjAjC9K6gtsAY5jYnFBn5UaVrcC3Krsyu8OrPpqvRdYKwdKXDWkQ/wXTvtEfv+oRlUFv5V43BQwExvHYJHAv4oTnGj0iwdzao8QhQ9Whzfi51ZrTgIgARXlw4wm15qEuhlfZ8/cNTdgII2jr0G6cJFHdokkphN16igt7JY+hv+g9A2qPSry2cF68xLBWKY7dyYD23Ss9Em2G2kD0b9v+Of5K2LIWjBMybInyyAI+EC1FA1qlOrIUBkQf9QCVB9yNpE5bd43S2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20>=20
>=20> On Mar 12, 2026, at 04:39, Shakeel Butt <shakeel.butt@linux.dev> wr=
ote:
> >=20=20
>=20>  On Wed, Mar 11, 2026 at 03:19:31PM +0800, Muchun Song wrote:
> >=20
>=20> >=20
>=20> >=20
>=20> >=20
>=20>  On Mar 8, 2026, at 02:24, Shakeel Butt <shakeel.butt@linux.dev> wr=
ote:
> >=20=20
>=20>=20=20
>=20>  [...]
> >=20=20
>=20>=20=20
>=20>  Per-Memcg Background Reclaim
> >=20=20
>=20>  In the new memcg world, with the goal of (mostly) eliminating dire=
ct synchronous
> >  reclaim for limit enforcement, provide per-memcg background reclaime=
rs which can
> >  scale across CPUs with the allocation rate.
> >=20
>=20> >=20
>=20> > Hi Shakeel,
> > >=20=20
>=20> >  I'm quite interested in this. Internally, we privately maintain =
a set
> > >  of code to implement asynchronous reclamation, but we're also tryi=
ng to
> > >  discard these private codes as much as possible. Therefore, we wan=
t to
> > >  implement a similar asynchronous reclamation mechanism in user spa=
ce
> > >  through the memory.reclaim mechanism. However, currently there's a=
 lack
> > >  of suitable policy notification mechanisms to trigger user threads=
 to
> > >  proactively reclaim in advance.
> > >=20
>=20>=20=20
>=20>  Cool, can you please share what "suitable policy notification mech=
anisms" you
> >  need for your use-case? This will give me more data on the compariso=
n between
> >  memory.reclaim and the proposed approach.
> >=20
>=20If we expect the proactive reclamation to be triggered when the curre=
nt
> memcg's memory usage reaches a certain point, we have to continuously r=
ead
> memory.current to determine whether it has reached our set watermark va=
lue
> to trigger asynchronous reclamation. Perhaps we need an event that can =
notify
> user-space threads when the current memory usage reaches a specific
> watermark value. Currently, the events supported by memory.events may l=
ack
> the capability for custom watermarks.

I agree. Even with BPF controlling proactive reclamation, I believe
there needs to be an event reflecting capacity changes to signal
when to stop.=20
Otherwise,=20the reclamation volume per batch would have to be set very
low, leading to frequent BPF triggers and poor efficiency.

Best,
Hui


>=20
>=20>=20
>=20> >=20
>=20> >=20
>=20> >=20
>=20>=20=20
>=20>  Lock-Aware Throttling
> >=20=20
>=20>  The ability to avoid throttling an allocating task that is holding=
 locks, to
> >  prevent priority inversion. In Meta's fleet, we have observed lock h=
olders stuck
> >  in memcg reclaim, blocking all waiters regardless of their priority =
or
> >  criticality.
> >=20
>=20> >=20
>=20> > This is a real problem we encountered, especially with the jbd ha=
ndler
> > >  resources of the ext4 file system. Our current attempt is to defer
> > >  memory reclamation until returning to user space, in order to solv=
e
> > >  various priority inversion issues caused by the jbd handler. There=
fore,
> > >  I would be interested to discuss this topic.
> > >=20
>=20>=20=20
>=20>  Awesome, do you use memory.max and memory.high both and defer the =
reclaim for
> >  both? Are you deferring all the reclaims or just the ones where the =
charging
> >  process has the lock? (I need to look what jbd handler is).
> >=20
>=20We do not use memory.high, although it supports deferring memory recl=
amation
> to user-space, it also attempts to throttle memory allocation speed, wh=
ich
> introduces significant latency. In our application's case, we would rat=
her
> accept an OOM under such circumstances. We previously attempted to addr=
ess
> the priority inversion issue caused by the jbd handler separately (whic=
h we
> frequently encounter since we use the ext4 file system), and you can re=
fer
> to this [1]. Of course, this solution lacks generality, as it requires
> calling new interfaces for various lock resources. Therefore, we intern=
ally
> have a more aggressive idea: defer all reclamation triggered by kernel-=
space
> memory allocation until just before returning to user-space. This shoul=
d
> resolve the vast majority of priority inversion problems. The only pote=
ntial
> issue introduced is that kernel-space memory usage may briefly exceed m=
emory.max.
>=20
>=20[1] https://lore.kernel.org/linux-mm/cover.1750234270.git.hezhongkun.=
hzk@bytedance.com/#r
>=20
>=20Muchun,
> Thanks.
>

