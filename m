Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E6B2C88E6A
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB356B0088; Mon, 14 Sep 2026 05:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C6C6B008C; Mon, 14 Sep 2026 05:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B18D6B0092; Mon, 14 Sep 2026 05:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C63B6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:20:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 883A24017E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:20:05 +0000 (UTC)
X-FDA: 85211821170.17.429A922
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A624100002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:20:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf05.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789377603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrTKRWsqiEmPqH2f5wyexCi7C4G06z/3XyjzCEWI0Y0=;
	b=UNyhYcZqfYG0J8JWu4i9zW6QdU6/3an4l6ZIrloYYW65Dpqs91MdrzPg1SQ33UPzIQ543n
	K0DZCPlDUwhV+v5+RVA+tGE7g0pkCgLNGDoTQ/AEEJNLpIkrJBbeJuttRG+w/wSW1t+ZjB
	nM5A96N1CkIhPT7VgtxfcR+rFrJnHxI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789377603;
	b=6LqvbVHcvt+ikIwV3iNqk6sENLHMQHx84RMTc5FX9zAujSe4Fy9d24So5/ifvL30U7dICo
	oiio/QZGBGJNGIFIEAxSlejas5+7y7jY+7v6IMBjSdgiBdADAeEEVxn6+29/vDYniJcOLB
	/vvnyaM6fuIaI2qnpO3N60n1uuwRtJU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf05.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com
X-CSE-ConnectionGUID: xABupc/+Qz+KpllhNGSJOg==
X-CSE-MsgGUID: vMlld0GyQ1qLoyD+FDr+5g==
X-IronPort-AV: E=Sophos;i="6.27,102,1786982400"; 
   d="scan'208";a="188847208"
From: Shaobo Huang <huangshaobo3@xiaomi.com>
To: <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>,
	<dietmar.eggemann@arm.com>, <huangshaobo3@xiaomi.com>,
	<juri.lelli@redhat.com>, <kees@kernel.org>, <kprateek.nayak@amd.com>,
	<liam@infradead.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@suse.de>, <mhocko@suse.com>, <mingo@redhat.com>,
	<peterz@infradead.org>, <rostedt@goodmis.org>, <rppt@kernel.org>,
	<ryabinin.a.a@gmail.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vincent.guittot@linaro.org>, <vschneid@redhat.com>
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before vfree
Date: Mon, 14 Sep 2026 17:19:56 +0800
Message-ID: <20260914091956.100424-1-huangshaobo3@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <anSVlVpUXrA8ra_z@lucifer>
References: <anSVlVpUXrA8ra_z@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset="yes"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.237.8.165]
X-ClientProxiedBy: BJ-MBX13.mioffice.cn (10.237.8.133) To BJ-MBX01.mioffice.cn
 (10.237.8.121)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A624100002
X-Stat-Signature: 5s13sa9jpyx76u7qn7ryxfgagq5ofz4j
X-Rspam-User: 
X-HE-Tag: 1789377602-818053
X-HE-Meta: U2FsdGVkX1+MmGigE9O8rZRYC8ZRGU5YE4Id2SJLyFgADjWv3/6ZfzWr/h9Kfuriri5XQcM2Ccju2z4hLgJSC88kmLjUswZQllwR4VRSxJrzcMjMSS5KbYCSrD0NQCp6oGOAw+RQtpyDb1DpSjqRziuTq3yNF28c2R6fYGry0k5jRmH4flrTzkgobvYvfvPdOwb5x9pKmkelymoKIGeno9x0AmeLjBa3gXuwzA/ddgvi10QW7GpZSNovFVTb/RGQ0epuByWeEZJFw+3k37frda/9z96RD44nJnwMKaG9ItK/46WbJrs0Jsi0ITO8CE9Wmk2GzhKKUM1Arz7miBZmTm6t+VHiRgWoG3QXxW0ol1oQLZA7iG50FfpeY6wDSJ8T2D/nR+GNysPQuPvAA9nm1O8GdK8Ww42TQsgv2nUR93BiF4hbXPaspCqzJS6DVJWnjMGQFMBW8OcXoI7gCMyiOFcRcI7rdZaojxUfAJIkKfQXdz+64i0Y9NDTgdwvKHDt+es95piHK+Ylfg4m+7v5TBZIm/LuAONC9/uqPTIb7GZrJZRnB8egwrzBK9whIluaDTbG1hTskg5xa4bftJ3Yjosjl7KZTcm1WcXNMx0LCbyk8vPzbxI7BlsG76UgnR0E9oxW50WBjVKMk8n9TZ0rX9GOONtkH2skZ1r/Wmebac2XeKjYsX8aEZ2Ey1n7KxtSk0TZzgFr/D/RU1wO+5CgtPo46Zn7xD7FNOmb4+GtBTG8yCXyHGdLAWbkhpbemI7+7CNs87eS0g9L4+/JihEKOsWT4IZ6qcPJZSPA/f3oQjfKc746M5KUm7UOWjZY1XhdWNXJbmEhkMVZugmsCZ5Hr+8ZRMPzmkki+C9/EFdKmvKxcR3JD9wsjroyk1opB0WggfhKmvZ55DtoWJpHXlhKKqi9/1oUCCyRjfzCl6t2frEVVQEC/QHh/+QtVp2Y9OLwRO8+KDubFHi538gzgV8
 JH0+fto4
 CaiWVQfUsOdvQzFSP8+WVkiZfom+n1KYJbDKFFi77LqItKeVk5OSiiqqkfbsBLpdmJXcJZG6Y2sb0N96ek+KMzYryQXmU+nvB1B73y12OZPP3+NUyQQ9Hm6NrKQucEjnkKajTLxeEf8R53HjtQRcLrw4gHSdVkQOsy2cGLbuIOiTbMwBXyljoalop9klKsgzZh2SKIWA7vPBRWkOzoJtrN5hAabEkJwGP8+8xSSsZRbRfG5eoAH1cXLNfIY7hM2xxJ6Awpz5AZWVvz8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:13:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> This looks AI-generated but I see no Assisted-by tag, please follow kernel
> procedure on this please.
>
> https://docs.kernel.org/process/coding-assistants.html
>
> None of your 4 patches pre-dating the slopularity look anything like this.
>
> Also please use a real name.

Thanks for the review.  v2 addresses all of these:

  - Added Assisted-by: tag per Documentation/process/coding-assistants.rst.
  - Used my real name (Shaobo Huang).
  - Dropped the verbose comment; the fix is a one-liner.
  - Fixed the Fixes: tag (see below).
  - Trimmed the commit message; removed the full KASAN dump.

> Output from a repro that you don't share, brilliant.

Fair — should have included it from the start.  Here it is:

  Prerequisites:
    - CONFIG_KASAN_SW_TAGS + CONFIG_KASAN_STACK + CONFIG_VMAP_STACK
    - /sys/power/mem_sleep set to "deep" (s2idle does not enter
      cpu_suspend and will not trigger the bug)
    - A wake source (RTC alarm, power button, etc.)

  Method 1 (deterministic, single command):

    # rtcwake -m mem -s 3

    rtcwake writes "mem" to /sys/power/state, driving suspend-to-RAM.
    At _cpu_resume, kasan_unpoison_task_stack_below() rewrites the
    rtcwake process's kernel stack shadow [base, sp] to
    KASAN_TAG_KERNEL (0xff).  On resume, rtcwake exits; its thread
    stack is freed via RCU callback (thread_stack_free_rcu -> vfree
    -> vfree_atomic), and the llist_add write trips KASAN.

  Method 2 (how the original report was captured):

    1. Trigger system suspend (screen off, or `echo mem >
       /sys/power/state` with an RTC alarm) -- the suspend-driving
       task's stack gets 0xff'd on resume.
    2. Trigger reboot/shutdown (`reboot bootloader`) -- during
       shutdown, init kills services; the suspend-driving thread
       exits, its stack is RCU-freed, and vfree_atomic trips.

  The original KASAN report in v1 was from method 2 on a Xiaomi
  Xring_o1 (arm64, 4K pages, SW_TAGS).

> A 2016 Fixes for some KASAN state bug? Really?

Fixed in v2: Fixes: 9f7d416c3612 ("kprobes: Unpoison stack in jprobe_return()
for KASAN") -- the commit that introduced kasan_unpoison_task_stack_below(),
adding both the function definition and the _cpu_resume() call site that
writes 0xff to the stack shadow on every CPU resume.  The v1's Fixes
(0f110a9b956c, the vfree_atomic commit) was incorrect: vfree_atomic is
fine; the issue is the shadow/pointer tag divergence introduced by
kasan_unpoison_task_stack_below().

> And of course Cc: stable...

Cc: stable is retained in v2: the fix is one line, and the bug affects
any stable kernel with SW_TAGS + KASAN_STACK + VMAP_STACK where a
non-idle task drives system suspend and later exits.  Happy to drop it
if you'd prefer the stable team evaluate separately.

> Nobody in their right mind does a comment like this for a kasan_reset_tag().

Agreed -- dropped in v2.

v2 will follow shortly.

Cheers,
Shaobo

