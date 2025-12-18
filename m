Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D22D6ACE2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 10:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A576B0088; Thu, 18 Dec 2025 05:33:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B2A6B0089; Thu, 18 Dec 2025 05:33:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E169A6B008A; Thu, 18 Dec 2025 05:33:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDDD56B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:33:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92C4F1373CB
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:33:18 +0000 (UTC)
X-FDA: 84232229676.29.03B75A3
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id BEDA24000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:33:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=joelfernandes.org header.s=google header.b=tsodB3Zw;
	spf=pass (imf01.hostedemail.com: domain of joel@joelfernandes.org designates 74.125.82.43 as permitted sender) smtp.mailfrom=joel@joelfernandes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766053996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAu1e8FBRNeI62zjm4DDzmRr/lJD1JUOnEjNmLdGRCc=;
	b=mN7X95L8j66trmWKCArs464uxNOKPVuO2lYH2fQW5I46E6/OsOfVXFdQNk1L9wKRfPpwrL
	XcyrkdZxE1ZR8wZrRfHvNk+u0HSNIbNrjhuaAU6Xgxoy+uO1Uuk+0rhYxA75hL+YiPcjyd
	pJLNiHjN4u2UeGMj0tOZQR9fWZcdVc4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=joelfernandes.org header.s=google header.b=tsodB3Zw;
	spf=pass (imf01.hostedemail.com: domain of joel@joelfernandes.org designates 74.125.82.43 as permitted sender) smtp.mailfrom=joel@joelfernandes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766053996; a=rsa-sha256;
	cv=none;
	b=fLSaU+8c5+WxQS/imZ7KObzKjkvjfd/+z7SJhowVnihy/4sX0EtvCjwkW/lX53CeBXRdgr
	budKGGQpeHnCmI3X3yc5vhg5LmrFPg/IFsUlPe09ZBBoUEmHkuXKUILGAko85GnCNvjIvc
	tmvsJN9NQTLn2kVB0EqupVxTPxClR7w=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-11b6bc976d6so2330452c88.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1766053995; x=1766658795; darn=kvack.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AAu1e8FBRNeI62zjm4DDzmRr/lJD1JUOnEjNmLdGRCc=;
        b=tsodB3ZwrvMHl1GNcFL0AfDzZI/jhMUdTFcDYk+/wzzrIDxEjTPbY/rXXQvyOJcLcT
         pE38wkLypRhgzpZJT21u0EJ3VEu1/vB/WtcA5R/08ie3L995qImrnZHxpiJoOgc8aVIA
         Mjc4E9k94ZZXJqZgxzDtkt5qlYDfq7TnkNHPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766053995; x=1766658795;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AAu1e8FBRNeI62zjm4DDzmRr/lJD1JUOnEjNmLdGRCc=;
        b=jaGWe3gaQTkPULqvwdDOTanhe+h7+9VWrJlzxPX8ZSmVxLNhFMBMr+sd/StqCMwV0D
         Cn1RG1oCP5gzpOe5RGGsH6QEe0vUc2aexjXyPNku7w/cvYKDvdNRJCegxGsbKICbBLFI
         mlJTLDrl84LEfU6pwPChJJqZfXJ/jNRiU95I77hplGRCzGYXRrtmVCja2uWNUOMfxtkn
         RlpemABx35+9fq04Z1lurKVoKs+cp4APfTF81uja0Kw8ljOxOerScKjmQhi+7zuQCbmd
         kQxnxnKqzVGvl+vBW5Gbn583Sz018/13+2ViUkGY01HNz+DRLj/lVOe0i3FL1i9vIqa+
         G3Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXvOIwdwT0h44ir4TJdwYpiA8Gm8753xKosh0Yr74ILkB9VKPk8MCEo2+TVBozRrQYkZpqjX39+OA==@kvack.org
X-Gm-Message-State: AOJu0YxdG3m3rdAioQvR3JnxOstESNToV1PXATzPKHfqkM7Vfetq/H4I
	Old/9XKGxxYPAuCUlpQG8ocuAK1ekN/gyyvFPvYeNC2lN7og8B3vJaZgxBwTg0dZdnk=
X-Gm-Gg: AY/fxX6riXeW+MsJOlH0HIZ0+/jB+eqPFaXslZhy3souba1Ad1tA3bQn/pZA7VZokkw
	7TJJz8YX+vISpjSL4yl/melIzT9DK025gVoPBpTqhukRa2PDmapxXrmpPPp/OBZBUGmOrhJbFFL
	8XSZnoYq0h6KhZV5MEQzzgvIJYBLMia4qHM17dU1c+y6AzWJFW4KFzSrbIYsFVMKz2gYBd4KpkD
	C4f8j30qCDZrqr+roMoPcxACEKI3y80ah6GMQCwp9fVDh+yHQs3ksg8xxdOndPd3jyUkTYsbns0
	gYfAOkW226LmtN3tusTU8dVxW2Al7EZkx8CEobHdyDMkinrNWHUtJf9aC3+ySys5fPl+/Cs8bF2
	a6+7eJAumHQMuaaTLJt4iioMrL24tbwIq2vJrO8Eip/Ku4Gdw5I3Z1J2yxCUXh9DQBx15zpEHbI
	DrHVxgSUO7OyzdrkavDgfbxjU78QBPs4urEA==
X-Google-Smtp-Source: AGHT+IFtqtcMyTzlaYKeDxicEozD/tLr/safKQ9+lAGXo8G2u7+cxfn0zs8VwmeAOGXFGsyxxH+sjA==
X-Received: by 2002:a05:7022:7e8a:b0:11b:ca88:c4f1 with SMTP id a92af1059eb24-1206195c6d8mr2015036c88.20.1766053995200;
        Thu, 18 Dec 2025 02:33:15 -0800 (PST)
Received: from smtpclient.apple ([71.219.3.177])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12061ef3383sm7327215c88.0.2025.12.18.02.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 02:33:14 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v4 0/4] Hazard Pointers
Date: Thu, 18 Dec 2025 05:33:02 -0500
Message-Id: <54E94704-92C0-4F10-AED9-46DFCA61233B@joelfernandes.org>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
X-Mailer: iPhone Mail (23B85)
X-Stat-Signature: atce3wztgh19uooj61mnm3ygshsru7yt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BEDA24000A
X-HE-Tag: 1766053996-233880
X-HE-Meta: U2FsdGVkX197ZB3qYjrSFwdqfmcPH2L1Dnv737dN895/ngVcMFoHXbLzYgc9hBInKfxIJNy1kedtQvReNwrctISo7hD8CWgzQPAPNZTT9TKO89kwAKIZTOCNUvRYzmqqyjsbuk/E7p7GszdBDyTTRLQNJaf8wCoXEnz8soQ2mn5wRQLtgHENMXVXE146d1ixXBzkvCUZUWj7SvEAtapeqSiRhYdlwcC97bJeR7nCjNYwehIQGS644w55HAnnMuPe7o11caKKCmAmgKAW78kaCoeb1fVh+3EsvmObwD913ykeJSnG0LouHlrmFFUlfUdr6exXEFM0RGEy0Qno/0hIdFZlwpUY74JvbPM8oJ1xIKH8ZWz+6vFIvG1KFyv8Zh8VNnmynFhsGIGLW4JwTbhvb09oqW/zckbHhd+2JBagILeqzoNjT5+QLHDkFQTqsjfZOJUGRwgCo+HhJKWZqWgtnrtHCdHXcrajj2N6MDGIFbvcPpxoqE29LYfuLq/jdkCVpsJbAdbrGq7fsmpkHt/EA47Dxit7dSV8Ov8lfdpkJFf6dXq94TQoMvWhwI7JjBEzYyuHiuPwyrcvlKxr6BJ2eXvmu4xMql1385dTcOqhJ5osmjTfHX/JpJTBCrWpPV4WRmixm3OtdI6r9CsZMSQb+WubRoMZc9EfvwGm53/B8Ppu3k5Yo9aOh4B+MeQrmlvZzZnU4s1N64q+kCGdsVcTRtw0vOLmZ3iI27WbE++O56NMGOm+LRlgMlgq5WaVMcDI8UyiGZ7Wdvl4B89BCViRlyxeewzc+Pmwln7sW1xoMvlf8fSPJwRC5DRZlKscAXa5azWdDCVMErpTs1Le23Z/dasW5Pm0x59LqcC8yKA/pR6gHVljHmSdN1RhU0GUVmNFZ9jTCBEAPcNjp6Cp13sb2smYvd3OPnyIzTaeyMUSfHi2SKuFSy81mwVSyoOJWa+rLNxcSA6FksAPdlRkYoU
 HeIvho48
 5L3eeL4StTcH/ty5obu7K34mcluJ1sv7pzpr0FEa4skbKAP2N2n/GsibQY80DEQn6lywuct+g5323+3NPM21AvEPMAJcZ1xuLfGAdh5eJgzdSGj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,
Thanks for posting this.

> On Dec 17, 2025, at 8:45=E2=80=AFPM, Mathieu Desnoyers <mathieu.desnoyers@=
efficios.com> wrote:
>=20
> =EF=BB=BFHi,
>=20
> Here is a revisited version of my Hazard Pointers series. Boqun, Joel,
> if you guys have time to try it out with your use-cases it would be
> great!
>=20
> This new version does the following:
>=20
> - It has 8 preallocated hazard pointer slots per CPU (one cache line),
> - The hazard pointer user allocates a hazard pointer context variable
>  (typically on the stack), which contains the pointer to the slot *and*
>  a backup slot,
> - When all the per-CPU slots are in use, fallback to the backup slot.
>  Chain the backup slot into per-CPU lists, each protected by a raw
>  spinlock.
> - The hazard pointer synchronize does a piecewise iteration on the
>  per-CPU overflow slots lists, releasing the raw spinlock between
>  each list item. It uses a 64-bit generation counter to check for
>  concurrent list changes, and restart the traversal on generation
>  counter mismatch.
> - There is a new CONFIG_PREEMPT_HAZPTR config option. When enabled,
>  the hazard pointer acquire/release adds and then removes the hazard
>  pointer context from a per-task linked list. On context switch, the
>  scheduler migrates the per-CPU slots used by the task to the backup
>  per-context slots, thus making sure the per-CPU slots are not used
>  by preempted and blocked tasks.

This last point is another reason why I want the slots to be per task instea=
d of per CPU. It becomes very natural because the hazard pointer is always a=
ssociated with a task only anyway, not with the CPU (at usecase level). By p=
utting the slot in the task struct, we allow these requirements to flow natu=
rally without requiring any locking or list management.. Did I miss somethin=
g about the use cases?

I did some measurements about the task-scanning issue, and it is fast in my t=
esting (~1ms/10000 tasks). Any input from you or anyone on what the typical t=
ask count distribution is that we are addressing? I also made a rough protot=
ype, and it appears to be simpler with fewer lines of code because I do not n=
eed to handle preemption. It just happens naturally.

First of all, we can have a per-task counter that tracks how many hazard poi=
nters are active. If this is zero, then we can simply skip the task instead o=
f wasting cycles scanning all the task slot. Further, we can have a retire l=
ist that reuses a single scan to scan all the objects in the retire list, th=
us reusing the scan cost. This can also assist in asynchronously implementin=
g object retiring via a dedicated thread perhaps with the tasks RCU infrastr=
ucture. We can also make this per-task counter a bitmap to speed up scanning=
 potentially.

I am okay with the concept of an overflow list, but if we keep the overflow l=
ist at the per-task level instead of the per-CPU level, it is highly unlikel=
y IMO that such an overflow list will be used unless more than, say, eight h=
azard pointers per task are active at any given time. So its lock contention=
 would be rarer than, say, having a per-CPU overflow list. I would say that c=
ontention would be incredibly rare because typically hazard pointers are use=
d by multiple tasks, each of which will have its own unique set of slots. Wh=
ereas in a per-CPU overflow  approach, we have a higher chance of lock conte=
ntion, especially when the number of CPUs is low.

Other than the task-scanning performance issue, what am I missing?

Another nice benefit of using per-task hazard pointers is that we can also i=
mplement sleeping in hazard pointer sections because we will be scanning for=
 sleeping tasks as well.

By contrast, the other approaches I have seen with per-CPU hazard pointers f=
orbid sleeping, since after sleeping a task is no longer associated with its=
 CPU. The other approaches also have a higher likelihood of locking Due to r=
unning out of slots.

Of course I am missing a use case, but I suspect we can find a per-CPU ref-c=
ount use case that benefits from this. I am researching use cases when I get=
 time. I think my next task is to find a solid use case for this before doin=
g further development of a solution..

By the way, feedback on the scanning patch:

Can you consider using a per-CPU counter to track the number of active slots=
 per CPU? That way you can ignore CPU slots for CPUs that are not using haza=
rd pointers. Another idea is to skip idle CPUs as well.

Have you also considered any asynchronous use case where maintaining a retir=
ed list would assist in RCU-style deferred reclaim of hazard-pointer objects=
?

thanks,

 - Joel=20

>=20
> It is based on v6.18.1.
>=20
> Review is very welcome,
>=20
> Thanks,
>=20
> Mathieu
>=20
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: John Stultz <jstultz@google.com>
> Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Zqiang <qiang.zhang1211@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: maged.michael@gmail.com
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
> Cc: rcu@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: lkmm@lists.linux.dev
>=20
> Mathieu Desnoyers (4):
>  compiler.h: Introduce ptr_eq() to preserve address dependency
>  Documentation: RCU: Refer to ptr_eq()
>  hazptr: Implement Hazard Pointers
>  hazptr: Migrate per-CPU slots to backup slot on context switch
>=20
> Documentation/RCU/rcu_dereference.rst |  38 +++-
> include/linux/compiler.h              |  63 +++++++
> include/linux/hazptr.h                | 241 ++++++++++++++++++++++++++
> include/linux/sched.h                 |   4 +
> init/init_task.c                      |   3 +
> init/main.c                           |   2 +
> kernel/Kconfig.preempt                |  10 ++
> kernel/Makefile                       |   2 +-
> kernel/fork.c                         |   3 +
> kernel/hazptr.c                       | 150 ++++++++++++++++
> kernel/sched/core.c                   |   2 +
> 11 files changed, 512 insertions(+), 6 deletions(-)
> create mode 100644 include/linux/hazptr.h
> create mode 100644 kernel/hazptr.c
>=20
> --
> 2.39.5
>=20

