Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDFECCA476
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 02:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9E58E0011; Tue,  7 Oct 2025 22:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491CC8E0002; Tue,  7 Oct 2025 22:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CECC8E0011; Tue,  7 Oct 2025 22:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFB08E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:15:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA45D1DF37B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:15:50 +0000 (UTC)
X-FDA: 83973331260.07.17EC075
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id F420416000C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:15:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LNObAgyX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759889749; a=rsa-sha256;
	cv=none;
	b=C7fYG66xji+am2nQ2ZYZcqIuJKvfaNnlvsP7Gc3P3Cfox8MnqTtGbt1+SEh452T3jN1I7s
	bt1PG+ZX512fyq3LRUvvkCK56NBtRfyfB/gbNpPn2PL0MlLskhWz+sxdvZM+q/XvujxpCm
	/YnfZpORI6fnhqjW5fP4XUUq3G9EjJg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LNObAgyX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759889749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIg33BOFvu2DJKTJckDWopI10BTYzh0CRGfWO2QY7n0=;
	b=Bi+IxV3vCdRbGzbVT4FvuW9+EpLXqlrUjDSn2RUh/LanW2PSOMFH/riaMZONpc8FvSfyC1
	sXIT0kztoQYSjTlS9OSUFeehxpEpB5QPyPBAAG+JzCl42AbBue5RiGnIDF5tM+bjp43D+m
	HTkOE/Ov/dJQS0d2ySZTbRucv5LsqWc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759889746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIg33BOFvu2DJKTJckDWopI10BTYzh0CRGfWO2QY7n0=;
	b=LNObAgyXn7QpbbMMaXccMVDeUIbaqghyVb6uU4GzlJVkCU97y3ZDswl/JuAogn3IQOXnLX
	hX0kezR1H8s/664IJ/6vqK1EU6TH4K5Sogf2p48mnjJCsdnIluI91xgIH7kLl23hNZVr8A
	4TSArLy+pby/78AvJ5HuB9Zh2kqTpDg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Song Liu <song@kernel.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>,  Martin KaFai Lau
 <martin.lau@linux.dev>,  Alexei Starovoitov
 <alexei.starovoitov@gmail.com>,  Kumar Kartikeya Dwivedi
 <memxor@gmail.com>,  linux-mm <linux-mm@kvack.org>,  bpf
 <bpf@vger.kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David
 Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Alexei Starovoitov <ast@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <CAHzjS_v+N7UO-yEt-d0w3nE5_Y1LExQ5hFWYnHqARp9L-5P_cg@mail.gmail.com>
	(Song Liu's message of "Tue, 7 Oct 2025 18:07:03 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
	<87wm6rwd4d.fsf@linux.dev>
	<ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
	<CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
	<87iki0n4lm.fsf@linux.dev>
	<a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
	<877bxb77eh.fsf@linux.dev>
	<CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com>
	<871pnfk2px.fsf@linux.dev>
	<CAEf4BzaVvNwt18eqVpigKh8Ftm=KfO_EsB2Hoh+LQCDLsWxRwg@mail.gmail.com>
	<87tt0bfsq7.fsf@linux.dev>
	<CAHzjS_v+N7UO-yEt-d0w3nE5_Y1LExQ5hFWYnHqARp9L-5P_cg@mail.gmail.com>
Date: Tue, 07 Oct 2025 19:15:40 -0700
Message-ID: <87playf8ab.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F420416000C
X-Stat-Signature: ru1ne3s5oqh8kgp1sfmfo1j8x5fb9thu
X-HE-Tag: 1759889748-565584
X-HE-Meta: U2FsdGVkX1+MV2JmTDoDSvXzXb2ick+FfJEcZUncKybLOKFFsl6csE3rQh3lFnDS28PiiNDwB2JSQMB+Mi4JaNcw39pzFCjZI2Vj2gc5GGA2zHTB0oL3Cx185BfkjyqMe/xZEUfmz50e9Aw3u/Y9RGrmUFFD4et7ZhSNQ4Fy1WOElCSCfNHRp/iC3lCOoXAXlSnxmPsDGm6fmxTXIqapo+qZLCRqqglU3iiInIiZTnFSlWRcuchzWiArvAdsKXnSJkYNpSWK6lox03ENzL0DR7X8szrG8w7aqBjo6h0A0d0q56OAY9NEeIatNOZ9BkwFqbvY4GbxqHyKRAHaQcSaxaSw8UBTA+fH2p8qpYtxUVbQX/L4oCPyP8ogt4lpL2IwEsWvKDO4dG9k1Hpq/A32Hkk5ScuzojABUxJMVmwe0v53SdYV2Np++UtkmbXJyQuzr9VXvZv2cPSV/MkquHFed8sNN4ex8lPs4rAEPnVA+GQLy2jSyfiCYZ0EFYwIwEtppXpNvzWxiTLi3Bl5H7XxeWmYIoANgajHVW/zYeyovG60BsDgIazOvxyn0app0sKN4FiLkjqwKMlQ5kL0PBhpyfE4NuKEqhTrqa+/YXztK8cM2/ukAbytWnRvAQL6HTurUTcmctnpOtyAcMacF3+uqAGhn4+0u8YQHZ0gMvuAlemNToHgxBvRQ/6bFeSamQ334qJG3OWZzn00umuDg1qWKFrbH7uDTPNz8Kx4Xi3f4l3dvdnS4ugnU1eKg5JX/B38yA8NkzIXpIknSljFtuTL4Lu9PH3hCCCLXNT2bbzaHRVdNkDD/EK76GyMNvjNpXCY/L7G79/Swpf70cIWRNoZxex7Z9w1eK1/HDGvUf8UDzlntgxCzN0eEzCawizHAHwitdavXxi2xt/ge+e69F/GcLiH1pcjaJPMTM1ZBjSl+CrU0iwKQsk5gB/y1M54UejkUxl+15Tuiwsj+jOyfDa
 pEEzygaZ
 RPnZpiUBmcW/S+Lx8yi7FGhJ1tyhqAWeGV9y3ARoLQVD8LjRngAy68gqD+SHaMFGddCASu4kZRs7s2qafTUqhLSrzng2RrYxD6HeHyHYYRWj9Zpd/0ubHVEoT3zT7LHeAMZ6HHOwIbjZaDGsUDiT1uZalcw/ZiGfrCZf2erJ4Eqbhs66okuTaudZ6oOhGSXODUG+Hp8TFmmNm0TygCU4qIgWjXKX6UdNDsPNaqmFNF6qZ4+0VuWO0NICu28B8Hpa+vizvreAEcN96i93MtKL59Ar1V7LlWKc4Hx02rgj2jOi+9mc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Song Liu <song@kernel.org> writes:

> On Mon, Oct 6, 2025 at 5:42=E2=80=AFPM Roman Gushchin <roman.gushchin@lin=
ux.dev> wrote:
> [...]
>> >> >
>> >> > So, there cannot be bpf_link__attach_cgroup(), but there can be (at
>> >> > least conceptually) bpf_map__attach_cgroup(), where map is struct_o=
ps
>> >> > map.
>> >>
>> >> I see...
>> >> So basically when a struct ops map is created we have a fd and then
>> >> we can attach it (theoretically multiple times) using BPF_LINK_CREATE.
>> >
>> > Yes, exactly. "theoretically" part is true right now because of how
>> > things are wired up internally, but this must be fixable
>>
>> Ok, one more question: do you think it's better to alter the existing
>> bpf_struct_ops.reg() callback and add the bpf_attr parameter
>> or add the new .attach() callback?
>
> IIUC, bpf_struct_ops_link is just for bpf_struct_ops.reg(). The
> attach() operation can be separate, and it doesn't need to be
> implemented in sys_bpf() syscall. BPF TCP congestion control
> uses setsockopt() to do the attach(). Current sched_ext does
> the attach as part of reg(). Tejun is proposing to use reg() for
> sub scheduler [1]. In my earlier patch set for fanotify-bpf, I
> was planning to use ioctl on the fanotify fd [2]. I think these
> all work for the given use case.
>
> I am not sure what is the best option for cgroup oom killer. There
> are multiple options. Technically, it can even be a sysfs entry.
> We can use it as:
>
> # load and pin oom killers first
> $ cat /sys/fs/cgroup/user.slice/oom.killer
> [oom_a] oom_b oom_c
> $ echo oom_b > /sys/fs/cgroup/user.slice/oom.killer
> $ cat /sys/fs/cgroup/user.slice/oom.killer
> oom_a [oom_b] oom_c

It actually looks nice!
But I expect that most users of bpf_oom won't use it directly,
but through some sort of middleware (e.g. systemd), so Idk if
such a user-oriented interface makes a lot of sense.

> Note that, I am not proposing to use sysfs entries for oom killer.
> I just want to say it is an option.
>
> Given attach() can be implemented in different ways, we probably
> don't need to add it to bpf_struct_ops. But if that turns out to be
> the best option, I would not argue against it. OTOH, I think it is
> better to keep reg() and attach() separate, though sched_ext is
> using reg() for both options.

I'm inclining towards a similar approach, except that I don't want
to embed cgroup_id into the struct_ops, but keep it in the link,
as Martin suggested. But I need to implement it end-to-end before I can
be sure that it's the best option. Working on it...

>
> Does this make sense?

Yes, thank you for the great summary!

