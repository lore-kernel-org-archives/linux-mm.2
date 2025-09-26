Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75250CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA8D8E000D; Fri, 26 Sep 2025 15:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64F68E0001; Fri, 26 Sep 2025 15:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53BE8E000D; Fri, 26 Sep 2025 15:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1C7E8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:54:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52CFE1407B3
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:54:44 +0000 (UTC)
X-FDA: 83932454088.05.48DBEE0
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5EC164000F
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:54:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TBjfehUd;
	spf=pass (imf04.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758916482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1S6qVc8zFJzoJotfzJqFzUNbTwzB+Ke9Kbshsqdjck=;
	b=sHppHN3dzyKQZb/ClWnE5d+51mKUD9//Zx0c9AJCWPVAHdnFI1Qt7q5y8K/+UXvz+fFBnf
	EfJhq0OQc9t2qa0Sp+zWHPXItWnL9yrYsqK6+PS4goqKnwxcy/gd18Vah0Y2+dlZYC5BEz
	kO28pPKafejyH03dTrQl7gf8z7IIuyw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TBjfehUd;
	spf=pass (imf04.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758916482; a=rsa-sha256;
	cv=none;
	b=uAXNo9X5kZGU1wVBeQduBU0FqlyDB1pMs3KKJ5KyRq9m7B6oYGAXAeGDzMTtn/9h9ZGEHr
	/D2zmJvUPjfbMmyXfztjzaq34SUuZqg8ulsreEAE+mLT0FOYmkXzKlz7c6MUetLfUVZSnH
	G1pDGsVK7IKhk5Ayr8ViICLNIVofy4I=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-57dda094f6cso1681e87.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758916481; x=1759521281; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1S6qVc8zFJzoJotfzJqFzUNbTwzB+Ke9Kbshsqdjck=;
        b=TBjfehUdooS9vMltmUOFl/PrCf/jHqODgrIm7Hw37yv0o7I44Z8FjUvaZaDiMqV/PC
         RYIrq0xTTPU2oaAm7xQ5/+8IJaMdD/LztttGVkIqXkyDbgQa8QrJnx0dSyLNRilBNn7o
         HgDg+4nKC+ZqTfp9sDtcmR6CUa26JUzqTkdQ+Qz0heGhQXKV5KXVY9ocipG+B6rCbi8z
         OavX0Tla6VLU7vT2gDSr7Xer91PzXC7LXQH8WfYUNkmLPyJFj0nEuD7oYRNvR3CjalYp
         FqADOrJogXzsVZoWEkttW3eLPMHrfsQN3JN8KkcKng0dqt8DFz/PDSEYIGf474wmscdW
         dZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758916481; x=1759521281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1S6qVc8zFJzoJotfzJqFzUNbTwzB+Ke9Kbshsqdjck=;
        b=KVQITRS0foIbup9iOqde5AedaQQ/XlvsT0HmJuNJhCDXmvPHpOFm1wub5lmuP8VWqN
         Eycx3mNWgTIGtBa+QTRKT3UgS2lFqEMnWqzGj0w8u5Vjz0rr1idP8A3xTZ0ctvkY64rb
         k8CNd9p5g0mUamQUHAH78HuDeIy6BqIgy5brFJ1X3BH1dH8554QDj5juuqgzfVHRUiKg
         EcLFpYfmX3Y7dN799CWV9Nrq+RBmgG79aWEQcK2YhJVIkDlpheuDWj2ISQD+CnHN2e2g
         59GFCu1kPevGm0//Qazk1mzAwRztfBp3L7OpTIPP1bB+2VxrJnosnyHDcjmaEW7R0HNK
         jx8Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/jjsk68UkfLbVpjnzOT3MNoIkpS0XzBunxwmqgyKcieQalwfZYdeQQ7f+Wl9cZuVtcNGEDOFQNw==@kvack.org
X-Gm-Message-State: AOJu0Yw9Gyc1Du9y0CjUbZwvSD9IIXqpZCl5j4Zm8u4v8x8Fv7Vz3sHw
	xm0iJkiJPBBboE1LA19ZCNbkyqfcrrzPaawXcbqGGnKHmcr3il8aVoO21QM0aWT7tbxQFRKvrGe
	UqVrrTRoJRbOh0RR66EhJDdOZ6jepboiZyyk3JRE1jCOBFyVt2g4sn50OVcHqDualw+4=
X-Gm-Gg: ASbGncvDjBDJaBE7wVm07zEjTLeA5zR11jxr/2z+JbgyrHBg0ZQOq8S0VZA6I/mcP26
	CqSxR2nM8yoE/45w4S7RzYPe54znbxO4JGE7DEN9u55gufuySav/SuQjKXQnQGvuWoHPWK2ZqKJ
	NuxtAeNAdHIPyyg7K31yMSw+rCoyMOHSu9DYH+tcNC5uzuEcl+ZzNxv1Iot4ZX4eaxFP11kbW2c
	wSz1SrLDJZ5+AYZofXCEZ61
X-Google-Smtp-Source: AGHT+IF9p/Vk9hBagqlH0ejW1INRFKq9VFCCHdEBxMHhLNqOc29Rt7OYge24foh+THkGfa5X+tEs//zmFLcC0ULmHb8=
X-Received: by 2002:a05:6512:4c7:b0:55f:6aa7:c20 with SMTP id
 2adb3069b0e04-584326d10c5mr428290e87.2.1758916480268; Fri, 26 Sep 2025
 12:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdxtTYQye1Rtp-sG48Re+_ihD637NDXTG_V_uLkerg=m1Nbtw@mail.gmail.com>
In-Reply-To: <CAOdxtTYQye1Rtp-sG48Re+_ihD637NDXTG_V_uLkerg=m1Nbtw@mail.gmail.com>
From: Chenglong Tang <chenglongtang@google.com>
Date: Fri, 26 Sep 2025 12:54:29 -0700
X-Gm-Features: AS18NWAn31xRvapqJUiXH-hfN9tbWp6MkQfkrW8U3FsmNfI4-_A_-vBbYm2-64Q
Message-ID: <CAOdxtTYKrMhjW9JiOCDBia+s=2tob1HF6yfAytYnajYsSoX5Kg@mail.gmail.com>
Subject: Re: [REGRESSION] workqueue/writeback: Severe CPU hang due to kworker
 proliferation during I/O flush and cgroup cleanup
To: stable@vger.kernel.org
Cc: regressions@lists.linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, lakitu-dev@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o1msp5fcupn18kmcse7xp9n3djpa9k47
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EC164000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1758916482-798649
X-HE-Meta: U2FsdGVkX18ihxOjfCgB670PHZ8xIzmVU4aHNO0IBCHBaMuUZ8ZNl+/8NN/aJHUTt6EEQXB8IggaYcxbbrVFNpacIP5Oiij0bF5HrjXMSTsh/Qm0h/vupr0/I1zkYCh1TERx/N5/VSdxVpixJYaQlRJuNu6ISmbLwya7Fe9rXYqQdlPcBSx7JTqxzgM5zjRLbvnkf1kRo8//saefsTFpRRN7FuHrQcGPmOqfGneTqJ2rI/xG65gygsKP/w6beYj1vAH5ws0MRCIdvJokRTA5PRm2J4KyyjgM7nKnUFCNjRfdgQIbjjC/qMXqo0PnTbni8keyWCa323m14ng4MXYq8ROBNu7fLvkTcYvbRRqwleS50dGqbqqt/SqRAP36H0c+n903Ez8NOD3ZHNXOQ5dMhpRdeZlzvi6jM/I/O7T50fxhRurDDHW2F1Haf5k1qSVye1HXv5jO7gFSkgn9KmaXTMsnqIJCisZMXV8EVyl6VZG+Wko1emRntF5A/P7QNpARYECUEkJZkvYcophu7aJnEDcyJl5pZYofX31hidOA5yN28s8Bf3ADJCR8IqO7vhEnufUot1GgrRrd7WnlLO2P9D2QTD4fI6PSmQKjgiw0HL2XOQTvPlAIm8rp/x16jcvD+/pUtfcf8pbAb8Xo4MlMLnGMiRdxayuN4iWkKarR6hqzDPnigDa3D4Ld4Lbm/VeONalWiNTTWcxW26ltSvQ6UjifAPMtmNaO9HdIDvvJtbAm/msS6zBVrN3YRucFh/GfhAwav2I0NYSoNPO3JRk62RIN+g/zrGLUG6wpCRPI/uVNYsNwe+kxZ4KkSVx4uWQVYsNEjreffqvU3upd9efFdwVQa56EsNdUoY5kD/3R70YsWOzp8XehXwTS3JieDbg+3KxLUlcxRgRMBUUrjij7ZMJJHHFWCYv0ils4wk2io4i02mYF7JeH1jUJfzkEYVwo5KXnb4/KXVTPqSaGhQZ
 JYidXWjh
 h37Pa7+J1peZYMwvBfmhiLQj4TV1Aj1ybLlSlqqEGUnTYdi4mU4NBnHX7hjOly5gqUMEIWyiVnIgB4yNvvtTsHXrBjSlYKz2Jc2sSduzdOy+ZOepoeiKdrQCG+DrzOkknY4dnjgZhcet4XirONrnLqvClaVbqyNyRO4jXmxWrm/X5QNbZ72EourHXQ4WdUozkp31H6IBN/Ywh2x64Dpp60xQQjE+fvs0COBQamguY2aRG2R+mleAyciHL2Za/Qob0SHyXmbmAthOvi3Jg8OuwpWzFmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just did more testing here. Confirmed that the system hang's still
there but less frequently(6/40) with the patches
http://lkml.kernel.org/r/20250912103522.2935-1-jack@suse.cz appied to
v6.17-rc7. In the bad instances, the kworker count climbed to over
600+ and caused the hang over 80+ seconds.

So I think the patches didn't fully solve the issue.

On Wed, Sep 24, 2025 at 5:29=E2=80=AFPM Chenglong Tang <chenglongtang@googl=
e.com> wrote:
>
> Hello,
>
> This is Chenglong from Google Container Optimized OS. I'm reporting a
> severe CPU hang regression that occurs after a high volume of file
> creation and subsequent cgroup cleanup.
>
> Through bisection, the issue appears to be caused by a chain reaction
> between three commits related to writeback, unbound workqueues, and
> CPU-hogging detection. The issue is greatly alleviated on the latest
> mainline kernel but is not fully resolved, still occurring
> intermittently (~1 in 10 runs).
>
> How to reproduce
>
> The kernel v6.1 is good. The hang is reliably triggered(over 80%
> chance) on kernels v6.6 and 6.12 and intermittently on
> mainline(6.17-rc7) with the following steps:
>
> Environment: A machine with a fast SSD and a high core count (e.g.,
> Google Cloud's N2-standard-128).
>
> Workload: Concurrently generate a large number of files (e.g., 2
> million) using multiple services managed by systemd-run. This creates
> significant I/O and cgroup churn.
>
> Trigger: After the file generation completes, terminate the
> systemd-run services.
>
> Result: Shortly after the services are killed, the system's CPU load
> spikes, leading to a massive number of kworker/+inode_switch_wbs
> threads and a system-wide hang/livelock where the machine becomes
> unresponsive (20s - 300s).
>
> Analysis and Problematic Commits
>
> 1. The initial commit: The process begins with a worker that can get
> stuck busy-waiting on a spinlock.
>
> Commit: ("writeback, cgroup: release dying cgwbs by switching attached in=
odes")
>
> Effect: This introduced the inode_switch_wbs_work_fn worker to clean
> up cgroup writeback structures. Under our test load, this worker
> appears to hit a highly contended wb->list_lock spinlock, causing it
> to burn 100% CPU without sleeping.
>
> 2. The Kworker Explosion: A subsequent change misinterprets the
> spinning worker from Stage 1, leading to a runaway feedback loop of
> worker creation.
>
> Commit: 616db8779b1e ("workqueue: Automatically mark CPU-hogging work
> items CPU_INTENSIVE")
>
> Effect: This logic sees the spinning worker, marks it as
> CPU_INTENSIVE, and excludes it from concurrency management. To handle
> the work backlog, it spawns a new kworker, which then also gets stuck
> on the same lock, repeating the cycle. This directly causes the
> kworker count to explode from <50 to 100-2000+.
>
> 3. The System-Wide Lockdown: The final piece allows this localized
> worker explosion to saturate the entire system.
>
> Commit: 8639ecebc9b1 ("workqueue: Implement non-strict affinity scope
> for unbound workqueues")
>
> Effect: This change introduced non-strict affinity as the default. It
> allows the hundreds of kworkers created in Stage 2 to be spread by the
> scheduler across all available CPU cores, turning the problem into a
> system-wide hang.
>
> Current Status and Mitigation
>
> Mainline Status: On the latest mainline kernel, the hang is far less
> frequent and the kworker counts are reduced back to normal (<50),
> suggesting other changes have partially mitigated the issue. However,
> the hang still occurs, and when it does, the kworker count still
> explodes (e.g., 300+), indicating the underlying feedback loop
> remains.
>
> Workaround: A reliable mitigation is to revert to the old workqueue
> behavior by setting affinity_strict to 1. This contains the kworker
> proliferation to a single CPU pod, preventing the system-wide hang.
>
> Questions
>
> Given that the issue is not fully resolved, could you please provide
> some guidance?
>
> 1. Is this a known issue, and are there patches in development that
> might fully address the underlying spinlock contention or the kworker
> feedback loop?
>
> 2. Is there a better long-term mitigation we can apply other than
> forcing strict affinity?
>
> Thank you for your time and help.
>
> Best regards,
>
> Chenglong

