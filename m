Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21BBFD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 12:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7924C6B0005; Sun, 18 Jan 2026 07:52:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7400A6B0089; Sun, 18 Jan 2026 07:52:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635156B008A; Sun, 18 Jan 2026 07:52:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5334A6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:52:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB8CFC1F57
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:52:03 +0000 (UTC)
X-FDA: 84345072126.19.D1E3864
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id EB65A1C0004
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:52:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M7JUW8zP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768740722; a=rsa-sha256;
	cv=none;
	b=xajfDgH4XgTm2O5Lu2IchOjFdRl+4kp+3nLl0R740MUsnRTrVUzS8/oLmYSz7UPeO20d0/
	n3YuRdoBnvyNgweprqiuuwsZhS6455NidbJJRnDzNXSDjZ9DiY/H+08W77KVUwn9Wcza0R
	Zzyl6WXaH4r6hal2325inS5VyzAJGy0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M7JUW8zP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768740722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggyrGNgcMzV9mduRJGeAQ/EsOm6O1/O8LGbr9MRdajI=;
	b=6yZ0Cj417sPUU+8nl7jJfhTn5U23XvVHeoiTRI1QuFHBAa8HwFjM5MvK5p3im8jrF4yp+x
	NynS3i7O/U/aWpdRdcLid2VrgQJNreKxFf0d6w2ZLhzW9/CeUPGU7lLWxiuTaaPotygh/w
	/FdqcTgGGpwQhQyYMsm7OIZR9HoD4v0=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so4638469a12.0
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 04:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768740720; x=1769345520; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggyrGNgcMzV9mduRJGeAQ/EsOm6O1/O8LGbr9MRdajI=;
        b=M7JUW8zPUft3jC6TuKi55MoW6GfaHqWSaTpWXhC0YHTCXfs4xAaNHD+zbiDqCrJph+
         MUCXjcH+QB1McSEweewZQ5I8ThPOZHv/VuEFBqLM41qaB3l6kmUTzXqRf0XOP/pCMdXA
         H+O5zqkJSJYuSS3b1wexAtmIMAW/3zN31YmfmKqV5E+vO1S2cxnavRD1LXFjtpvVuVlw
         F1ODrTunh9vpuwilrJgaTvtkZELy8A7qrWPkpccUa9lGp6rz+J+abWUBGjqSX9KOLJF+
         TzYvFRO//btj8BfAhdBv0ZADZnJtkqHEqt09jDk4dp+HROXX6ea5gF/mZllYSPDBq9Qm
         6siQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768740720; x=1769345520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ggyrGNgcMzV9mduRJGeAQ/EsOm6O1/O8LGbr9MRdajI=;
        b=H+q3z/QwhXXx2eT6wllqLR3Few2JhfsAgsPxQA6s4C0LehmCLpaU76a75PysbpeiqZ
         6APoDFv9nv5ykCHcd6207CnOKSI3AwLOSVH9Hk+4Hl+HM7F3rB3bjAgjpNPBrA2Kf5zK
         qgesgFghmuUeKu6LsdhtJVyyojbF9cqOBH3afvBo29ZdSpxJuUHRwsdbbz9GPMhL2ZXw
         6sUkszX3RnL5fLtirZ76Fw/A63l3ZCQ8oGBZHQvYNhHz6ZuLqK49qDBF+GkUXGfvwMdg
         iS3mVbz85YLOG9wAk17QHcZko4fjX9dBI2ljWddNoCvayi7B/cWIdiAKgPTbxEcPhPiO
         W08w==
X-Forwarded-Encrypted: i=1; AJvYcCWasesDZkZe/5XZmeXBG7nlglwIUfjCTx0y6cp4tVpEHEWrh/S0c7cPl+1PnMpQfzJDAm/X60rHHw==@kvack.org
X-Gm-Message-State: AOJu0YzaUGOVTxzBDq/tnNnNw1oAZHRe4VsOjryAeb9ciH1VBVl2FG1w
	pc/eizXYMGqF0qnnyhyLxj1y3sRxvvYns2Qa1O6XRmj39LIV8RHq47bRCGJVnQqPgm1HeOUiDo3
	0WOx/lgr5M4jocDnAMPCBSWpO6kB04ws=
X-Gm-Gg: AY/fxX6r6JczDYh4RHTDK+kea8gO6fzs2TOAJpe9rjNNu+NK1gJFgB0NJuYSaBHhnzg
	FuCB9sy/80/2X5uM8JPSgp+/FrR815TGMQDAQXCaaj+72R6CYmccOz12HARSwXF5ec9ghUBQUgK
	io4v4jQNtpm01ymHZCairIFU8dHRROTcnMTOK5XHOpZCou4iQY3ro4DbcZddv2wIso+z/jzfiZP
	Cwhpd1BA/LDHXOp5ho6DZdrmDC6Xunziyiggfrn165gftRvf/RB6ztYns7701HufAP1xIoZR+kf
	9wp1NBl2gBkZdC5x1mx3UXk1MaQ=
X-Received: by 2002:a17:907:3e83:b0:b87:7e8:e268 with SMTP id
 a640c23a62f3a-b879300cc4bmr745096166b.37.1768740720017; Sun, 18 Jan 2026
 04:52:00 -0800 (PST)
MIME-Version: 1.0
References: <20251206131955.780557-1-mjguzik@gmail.com>
In-Reply-To: <20251206131955.780557-1-mjguzik@gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 18 Jan 2026 13:51:48 +0100
X-Gm-Features: AZwV_QixB2thWIKI2TNsDDOtRvVRGu-doBn8-CjV0tL0jEHK-AM64cg-9FTlJ5s
Message-ID: <CAGudoHETe9=un510HBh6-rwwyoE+qHYNLoxDK8-suTgbTfN++w@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] further damage-control lack of clone scalability
To: oleg@redhat.com
Cc: brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EB65A1C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: fbadik3nc9zma9kqeec8ype7yb8p4a7i
X-Rspam-User: 
X-HE-Tag: 1768740721-302169
X-HE-Meta: U2FsdGVkX18uVERx9KJqB00O4JOaTA6nTJhbAJIrnjaPgVHvwiPhOm0VjqLpwGKLqxdKIROZ9xCvPkUQy0Cuxagh+xivWvPcx8g28SAf+GhnPKEIKYlRzFpahTO5Vas8hg1raLeBXm5tjlgGGUDt63u6UX3sVhjlQmW48UHqvoj0aXP2ySvgkV9bUxOfDiwV11hIVIc/wIILSqFFylBjTzQzvvbfu1rofk2zqkQ4LadTRTYZ6cnpXYa/bG88K5s1EJP0G+cwCN4krBggHH9BkQs+eAGAhrEE0C4fNOTEgIeExPv+Ypy/UCB6gtZ/wNwNkqRAkbEcJMlpbkBLJAhDYRj4Ig/CZ6MfG4+6fsGVlAP5iFBO1DlZIxnA/0tEgGKHCVREI1GH1HbTtiOcfayZAAjwIocO32y60K5G+W/luWwE6Jouv5PkCcugXpNFAaG00/BmHCUOcWDfSGtFci+tBV8r1dDxVBBQCTMebeHmZeNmPokeygAM39SYKEDOcNjjTLPIyXROgzGoBm4gdSNB3qPAVgQOdtMKb4+HHOxdrHXMh3unAM6ftogiOQYawgGJkldWqPWKnAgjahJPF950sZmLge+uEfSAvM5fob70emAYYtnb6T6uU43C6En35lJ1sPkk40ZNEk9HnAOrFuy9hS1VoiCUi+CgOwAqHHMmYRLGONE2L2clhAsn481n0gn5Zqm5FE5/YZWsCEHwKytc7Re6LIlo0joQRpcKmDc6bLwESzialqnMVc/h4WY2riX72nH5/oOvDyOU3S9BGzMjhccIB1lPy63t9LFZ/EJVVeekPCRT41Sztup+55knO0yorNHoZ8wCTPLiTpMvSouQ0cJ9lp/o+mPgNM02PT6sCcSN1IWTfadIeANXIfbMyaT5Lr5aaceP714RT2K6Vl+K8XjvycbHxLFSE7tZy1duFos+JXvFntUaOEZIVfIjvAYfH5qNBV9Gv9IBm1fc+qw
 ygqI/Xwq
 K+nHR7Tnnw3Ai5BVRdVXqU3BT0bMGRG/Gbyb+CBVflKisxm2rK9c5ZLrML6VlcA+GbY0T7V15d08O+C25Cl2MTDC9JYBtNeOvYeDHeyOtva1XO3vVTeM2ugrw2dSd+XuKdEYomonslCo0EQ+gtN7/jEUjoMv/IflLSQeVTxW2vuzTGWXEeYhIFpSqK9PfDnOc/MwrNuZyWTXfd+tMDy6Gtl+H0kHrxP3d1u5UotNQ5BNSZ3+KYov9bnAXiw02rQzn6hvLBm03fz+IqtKGpOAJTzIFX+9Qa5qFza1PP9CyehfbsZ6QhcQSWO5Lf33PTQgD1XH9+kxrMbGFJQA3c9n2sQPwpMay+BMKlHsj1hThI44iZwbe77VJUQdEljlj5uTBcnVMyV+PvoS2srXL8f1OH78Z0eIA9TCAi8xZ/WvU94bd1k3Ua3K82SxdxMabtEWolk1LaDpgEI6+IHB/bcmwYNptKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 6, 2025 at 2:20=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> wr=
ote:
>
> When spawning and killing threads in separate processes in parallel the
> primary bottleneck on the stock kernel is pidmap_lock, largely because
> of a back-to-back acquire in the common case.
>
> Benchmark code at the end.
>
> With this patchset alloc_pid() only takes the lock once and consequently
> alleviates the problem. While scalability improves, the lock remains the
> primary bottleneck by a large margin.
>
> I believe idr is a poor choice for the task at hand to begin with, but
> sorting out that out beyond the scope of this patchset. At the same time
> any replacement would be best evaluated against a state where the
> above relock problem is fixed.
>
> Performance improvement varies between reboots. When benchmarking with
> 20 processes creating and killing threads in a loop, the unpatched
> baseline hovers around 465k ops/s, while patched is anything between
> ~510k ops/s and ~560k depending on false-sharing (which I only minimally
> sanitized). So this is at least 10% if you are unlucky.
>

I had another look at the problem concerning steps after this patchset.

I found the primary problem is pidfs support -- commenting it out
gives me about 40% boost, afterwards top of the profile is cgroups
with its 3 lock acquires per thread life cycle:

@[
    __pv_queued_spin_lock_slowpath+1
    _raw_spin_lock_irqsave+45
    cgroup_task_dead+33
    finish_task_switch.isra.0+555
    schedule_tail+11
    ret_from_fork+27
    ret_from_fork_asm+26
]: 2550200
@[
    __pv_queued_spin_lock_slowpath+1
    _raw_spin_lock_irq+38
    cgroup_post_fork+57
    copy_process+5993
    kernel_clone+148
    __do_sys_clone3+188
    do_syscall_64+78
    entry_SYSCALL_64_after_hwframe+118
]: 3486368
@[
    __pv_queued_spin_lock_slowpath+1
    _raw_spin_lock_irq+38
    cgroup_can_fork+110
    copy_process+4940
    kernel_clone+148
    __do_sys_clone3+188
    do_syscall_64+78
    entry_SYSCALL_64_after_hwframe+118
]: 3487665

currently the pidfs thing is implemented with a red black tree.

Whatever the replacement it should be faster and have its own
non-global locking.

I don't know what's available in the kernel to deal with it instead.
Is it rhashtable?

I would not mind whatsoever if someone else dealt with it. :-)

> bench from will-it-scale:
>
> #include <assert.h>
> #include <pthread.h>
>
> char *testcase_description =3D "Thread creation and teardown";
>
> static void *worker(void *arg)
> {
>         return (NULL);
> }
>
> void testcase(unsigned long long *iterations, unsigned long nr)
> {
>         pthread_t thread[1];
>         int error;
>
>         while (1) {
>                 for (int i =3D 0; i < 1; i++) {
>                         error =3D pthread_create(&thread[i], NULL, worker=
, NULL);
>                         assert(error =3D=3D 0);
>                 }
>                 for (int i =3D 0; i < 1; i++) {
>                         error =3D pthread_join(thread[i], NULL);
>                         assert(error =3D=3D 0);
>                 }
>                 (*iterations)++;
>         }
> }
>
> v3:
> - fix some whitespace and one typo
> - slightly reword the ENOMEM comment
> - move i-- in the first loop towards the end for consistency with the
>   other loop
> - 2 extra unlikely for initial error conditions
>
> I retained Oleg's r-b as the changes don't affect behavior
>
> v2:
> - cosmetic fixes from Oleg
> - drop idr_preload_many, relock pidmap + call idr_preload again instead
> - write a commit message
>
> Mateusz Guzik (2):
>   ns: pad refcount
>   pid: only take pidmap_lock once on alloc
>
>  include/linux/ns/ns_common_types.h |   4 +-
>  kernel/pid.c                       | 134 ++++++++++++++++++-----------
>  2 files changed, 89 insertions(+), 49 deletions(-)
>
> --
> 2.48.1
>

