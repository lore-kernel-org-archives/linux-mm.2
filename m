Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA08AF531CF
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500C26B00B8; Mon, 13 Apr 2026 16:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AE66B00BD; Mon, 13 Apr 2026 16:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352386B00BE; Mon, 13 Apr 2026 16:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEF06B00B8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:43:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFF2C16032B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:42:59 +0000 (UTC)
X-FDA: 84654706878.20.E85C9F7
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id D1BF0A0012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:42:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TbJLyYoa;
	spf=pass (imf25.hostedemail.com: domain of travis.downs@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=travis.downs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rE+XA/qRe+ggUEZzeC2Yhczq5JBa9Or6b6vFQEKRqXc=;
	b=DTxcZVD63DnH/ZHRgwSIOYxyd/uW1XBbZ57Ik2FfzeCXdSiMByMnjveO1ulTELOtPrPZSo
	347LNnY62gtQzw3DxmiBWdgQ9LD2Zn9nfPst/73/hhjlVsIZrYz8chciowj2fzj5LV263l
	qUfyYm7s3ulrgdvfGGBJjKOKh6wFwAY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TbJLyYoa;
	spf=pass (imf25.hostedemail.com: domain of travis.downs@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=travis.downs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776112977; a=rsa-sha256;
	cv=pass;
	b=FJlNSdDCeSAugDYuHmHZaGzTWOuvQLG0n/OkkUKKzTrQ/NHKAjScJWSbKHNnFgoBIFxTc5
	p9Dh+UWcUHdUd5Yth5l5FT5kkzVLuWV1el//KB58Dxqt52M6l9rlzCt9JIZKvM0k6C/ocM
	P7Ht/3WxGgLwT1NBIX21DboPYqZc108=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ab077e3f32so23313965ad.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:42:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776112976; cv=none;
        d=google.com; s=arc-20240605;
        b=fHKR152dRUCfu+v975HUOp6p3b5wnI0gPHoHiyLwPVy5jecGO/CrmzLOaZBPhDwndo
         fabE9M1eEM/BKYzqpFAxmU13GpF8fUrznQDkXgCsyQSjZzYdZVcvg4vQbyaXUtdhn8RV
         1ZhiLx/vKzzDq4/v3c22m+ruajVxixtQyWgXWPXtdVq7BeL7cGZfEef06p4vAXvXIZ9M
         XIM7HICjHXlqI9emE6IoEKaNTc0fDkQeb8OfdAXVJGEsJQ8eD6UEgYP8iQ1dHh/6ge+F
         PyDOcQQqt2nBwlSblo4KLG6qRc8Oz8ZG1q22zXT1Ed1Y0Snv7mV/0av2fe1EDOxxsEi9
         z7Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=rE+XA/qRe+ggUEZzeC2Yhczq5JBa9Or6b6vFQEKRqXc=;
        fh=8D2X/LdyDfici0U7oH+xiOtNUqRfnYTVSGrHfhgYH1c=;
        b=DCq3G5d0GiaUMvw254XRRwWjNxnx5dZ+sbTg1faME4dPvnEtjzvUd3ceNzLtr5fXm2
         st5IqPt94t9Zewyp7fDgUOeGsulxL5v+KDD7D1uVh8UM4CQlc7FAbr7tR8cbxPXMh4sJ
         6Nl/iWyjSAnFR9Y15NJ4tFMSsidn3PoYTPi9qwFjhKHJJdJ+Pi8PrrJUiw9O02Yydw/n
         tf/+z/4sBbBQhNArNuO53ZjpJ/gA+lXoMPFtkZ7yTgGfvfIdtkuZuFUFAc4+xKziaIvr
         yz1YnwWY91CAtosPbSWnmZFUIKdSmHf8kLLS6V26E9eDhXE5u2jXf2qdjxbI/zfGs6Je
         mQgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776112976; x=1776717776; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rE+XA/qRe+ggUEZzeC2Yhczq5JBa9Or6b6vFQEKRqXc=;
        b=TbJLyYoaZ2ivckCeeuuJDThFFzMMACucV1MhM2TIqQn9d1BpwhvOU/JmJvObX/uH1C
         xFjXPifD2NHrjY6nJtdQf3NnOLpoeR0Ydlx1Z73z8LDXQPgyiiV8DXgpcDHZSmdB8a6M
         9BEOGhpWqOth2CceW1Vt7d3O2OSN+Rbv6S9pVrfVwIaaXuNeDM8Xf9JloiVLe8oJAN49
         KzZkVAxHWI72R/9Wu6YDDQV0+c/Z4Gv42JTkIm+blh2z3qUSZsgPiOh8KmJBf3xh5kvH
         oCHJKtJNnxem9Reejay9mHScaM6pxy5EHy0NUxH5EsuNDUe2+MNtpTjokHmoCRep6xhV
         m2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776112976; x=1776717776;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rE+XA/qRe+ggUEZzeC2Yhczq5JBa9Or6b6vFQEKRqXc=;
        b=FlbUMd+CuZyad5D4t2t6xfZjazHRP/7C8xYONEkuXgLK09yJDUJmHS6EsgH+H8MbWQ
         JVdBU/4NJdU9oi1vA+/EnLY2r+m6oKKkBV8Ld4Hc1KKoWZxYgGgu1DoqnEhk59WYvOVF
         cZkR6JkMnDFCb//dPJvvl1XMVH5RZXLRZr6/M499HTx/B9cD/QEWlEBDblpIkPK/tFCl
         WByTeZvemAkVUtWUCWhC9gzPZEZ/4NUJ+1iqIi8x1CItunayh74HPs9GpjMMFG8148oy
         yTDgeMDFE3Rw4gAra7GC1LV3z16qxnPGOY10vLWNB3t+CdTTc3XH0AgFspojXGLNbr5k
         z36Q==
X-Gm-Message-State: AOJu0YyBTvgV5sL/aGEGJqM1A6KbGS7MzZ45kVzvM+vdbZPmgznQxE3W
	4amFqssfs79IpYwxfM5ZkAH7YAG16g7nz7sfbBaM5zoe8XbGhcUpPNz91CG2upvlvcZs50+EoeT
	iv9T0TyYpeMR4NPfEt51t5RjT6EjWiUbzgnjh
X-Gm-Gg: AeBDietBeDTPcWDMbAWf3DYueXmJvzbykELTFDKP/tknpzJNeT8if+CuGhDW63bQRmk
	3xb1HcRLJdh7bYk5tqvijz9KbO7D8xDBO8umsFqTHtroUnZnq4thF92XGUslegS72yfkIqvaZ3Q
	Ut8+dqe7A/1kgmVfn/JfQPXRyBsgeSc31O+O3JR2Ci4eyCIeI/tRiuysZXt32uKNQ1nKexrkb1q
	svcb/22Gt211TY/wVdWA31hrEJv3nBcRmi52HzjQQT2NOkavmXiQYwhXvifotnhYQ0KI1zC8mj0
	T4ZXoBM=
X-Received: by 2002:a17:903:283:b0:2b4:5c0d:314b with SMTP id
 d9443c01a7336-2b45c0d3361mr58089115ad.38.1776112976235; Mon, 13 Apr 2026
 13:42:56 -0700 (PDT)
MIME-Version: 1.0
From: Travis Downs <travis.downs@gmail.com>
Date: Mon, 13 Apr 2026 16:42:20 -0400
X-Gm-Features: AQROBzAaIycVKs1ICauMlejAkUOd0pEr6o48_VtCYt9J-_oewmDIIxQDMnU05Wc
Message-ID: <CAOBGo4wrHeqCe1=++N-nvZ2piPKk6zK9Ro+x_-cbj7YT3mWEMA@mail.gmail.com>
Subject: [BUG] mm: lru_add_drain_all() hangs indefinitely [6.17.0-1007-aws aarch64]
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1BF0A0012
X-Stat-Signature: hqet3dzzuj7y4sesmsgnxz9xux7hac3o
X-Rspam-User: 
X-HE-Tag: 1776112977-943896
X-HE-Meta: U2FsdGVkX1/sIscZfHdMyemiGCxVmoFQss6/p+nzt2FIclzE7wZCewUxKOidxW4KzMKUhcNWQ3+aKx0QAQ01rmQigBi6Y9r7GhSj2kZJ8Ph6U13nxyuZ7UyTEmeRy2eaycnJkIeigy7tbOKBWNA4cRX16XnY+giOwA2atLjmru5lIWLFJMjItoIUlB7gGq8mbqhGhd7J0k79RAF+HnMt1zH4S8VHH8QDz8wuzoly4BHCtyQa9iHF2qwwA6y2Lyv0Vl0JprGgqo2kGhmbJwG5CaVQETfPt+OkgXS8gX5GSoxcQMpO2KmXBUoArT9nxTdHEyuAb/R6WP+9S7hpSMT/1jH54h4YctUpyYabtsYqoiRHqGE2q3hBYD1DxF54IGr8S8uEbZkP/Iby7wAgEZBxL/rNJhv6MlwuSMJFlNibeB7Up+uv7RU6+5T0TsL8jJzHvXGyRb/JrJ++W4TdSF81lCA+BjHTMRtZLfUISA1A16pOTTC59QkwJynYgjrGpQXw8KnpAL5f/Oq+IL585LV+i388c/kVTMZCQK6uaCCP1Bo8rJWVuhSjfXU/t48eQ15FTZVUvycP03RtxmxYsd8b4CEgDdbaDn/GjT26GyEUiCFd+glIyq/5i2jX4OLE5FbLklr2jLlVKPNVvdTdn/t3OoduuFldb9NuP1bXFZWc6PxXdjInmIhFdX4otc7MSmeyVeR/33AJO2Hp1TstlNQomPWV4dvKjOgxCEbcQqjLxsu9DEkWHKwZrOujIGlHt/y61z+ncPg3lkDPoiXYs66xqcqwxxpPn0SphM9C9NrMp6ipvsEiZK2YJfEs4k65HFz2EaJjgJMc+MhsUkpFQoFMVFWz9VqIJoPGjFLsRNrLFnPcDIQa3zyoVrCbe7+1cb2vUyMlvEOehC1lU9vrZwNbEgs2aVjAtNsdvWwtIKWsoKqCSKoUHhjbe8eEB5HK2c2rNm3VsKzovKTfSf5j8V0
 KYDdiGoI
 /V0GInZewczAP+vW+d54555B6JCiDdhXU3kfT9vMMJB1uouID99aOSILlsP+3a6gbgp6/eJywhUc0umlDo5rlR5Lp4/TtDQ6RwqavMe67OKTV77xBusyGY4Gyma2dNouhljevCttPV/++RSlwzTUQVwIaO/ErmgSgpQH4aI9FuoqJzRQ/s8DAiJxWf6LcDQrZhwJtzxfRToztDpRfzKcH1XtjlSpoxBamYsoVQhM5QLJ3f3mtoeqZ+n90LuLc2EEnXp4BYNVMPO1a4ydJ0j01p7Pql5IrarKNlp1mU5+jdrlNSNvt5JdLaF8B9aBgCH8p39XwOPFB9TbUvoHazn0dCfMz6/iIFslO5cgfm2dLGLfuVHRefCVpTeVYCqrZD6hRDGhjuU87Tq/fF5TX4tSxcL4wN1ByPNqQS7Ab+zVFKigrpyhbLDDi5f3Q9L/eC8RUEMptiGgF9HjHNCeCkR+dlZ1E8E7bsw0Zd3DPdOlBXFhcrSQEV9jNzOuWnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After migrating from 6.8 to 6.17 we observed that lru_add_drain_all()
hangs indefinitely on 6.17.0-1007-aws #7~24.04.1-Ubuntu (aarch64, EC2
m7gd.8xlarge) in production workloads. The hang reproduces reliably,
happening on ~all hosts which migrated to 6.17, within the first hour.

The hang leaves the system in a semi-broken state: not frequent enough
to lock it up immediately, but slowly breaking it as various userspace
syscalls and kernel work smack into the mutex. flush_work() blocks
indefinitely while holding the mutex, and all subsequent callers pile
up on it.

This is a regression from 6.8.0-1050-aws (Ubuntu 22.04 HWE). The same
workload on the same instance type runs indefinitely without issue on
6.8.

Trigger (or not)
=======

The first manifestation of the hang involves two callers of lru_add_drain_all().
One caller acquires the mutex, schedules per-CPU drain work, and blocks in
flush_work() -> wait_for_completion() because the drain work never
completes. The second caller blocks on the mutex. Both directions have
been observed:

  - khugepaged holds the mutex, stuck in flush_work(). FluentBit
    (flb-pipeline) blocks on the mutex via generic_fadvise:
      INFO: task flb-pipeline:18374 is blocked on a mutex likely owned
by task khugepaged:220.

  - flb-pipeline holds the mutex, stuck in flush_work(). khugepaged
    blocks on the mutex:
      INFO: task khugepaged:220 is blocked on a mutex likely owned by
task flb-pipeline:18416.

In both cases khugepaged was calling lru_add_drain_all() as part of
THP collapsing, and FluentBit was calling fadvise(POSIX_FADV_DONTNEED)
-> generic_fadvise -> lru_add_drain_all().

Sometimes the two processes are reversed, i.e., fluentbit holds the LRU
mutex and khugepaged is waiting on it.

It is not clear that this is actually the origin event for the hang:
it seems more like
the workqueues get into a bad state then this is the first obvious manifestation
as the LRU drain does not complete and things start pilling up.

Kernel version
==============

  6.17.0-1007-aws #7~24.04.1-Ubuntu
  Architecture: aarch64 (ARM64, Graviton3, EC2 m7gd.8xlarge)
  Distribution: Ubuntu 24.04 LTS (Noble Numbat), HWE kernel

  Source tree used for decoding:
    git://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-aws/+git/noble
    commit 8d7dfbe07b0b ("UBUNTU: Ubuntu-aws-6.17-6.17.0-1007.7~24.04.1")
    tag: Ubuntu-aws-6.17-6.17.0-1007.7_24.04.1
    merge base with upstream: v6.17 (e5f0a698b34e "Linux 6.17")
    includes upstream stable patches through v6.17.9 (65723f3975a0)
    3687 commits on top of v6.17 (1193 UBUNTU packaging, 2494 code)

Stack traces below decoded with faddr2line against the matching
vmlinux with DWARF debug info (linux-image-unsigned-6.17.0-1007-aws-
dbgsym_6.17.0-1007.7~24.04.1_arm64.ddeb). XFS module symbols decoded
to source file only (no module debug symbols).

Dmesg evidence (host green-0, i-01fbf12d0b46e234d)
===================================================

After the initial hang we reproduced the issue to capture additional
information. First hung task report at Apr 09 22:01:23 UTC:

  INFO: task khugepaged:220 blocked for more than 122 seconds.
        Not tainted 6.17.0-1007-aws #7~24.04.1-Ubuntu
  task:khugepaged      state:D stack:0     pid:220
  Call trace:
   __switch_to+0xf0/0x178 (T)
   __schedule+0x2e0/0x790
   schedule+0x34/0xc0
   schedule_timeout+0x13c/0x150
   __wait_for_common+0xe4/0x2a8
   wait_for_completion+0x2c/0x60
   __flush_work+0x98/0x138                    # kernel/workqueue.c:4249
   flush_work+0x30/0x58                       # kernel/workqueue.c:4266
   __lru_add_drain_all+0x1bc/0x2e8            # mm/swap.c:881
   lru_add_drain_all+0x20/0x48                # mm/swap.c:891
   khugepaged+0xa8/0x2c8                      # mm/khugepaged.c:2623
   kthread+0xfc/0x110
   ret_from_fork+0x10/0x20

  INFO: task flb-pipeline:18374 blocked for more than 122 seconds.
        Not tainted 6.17.0-1007-aws #7~24.04.1-Ubuntu
  task:flb-pipeline    state:D stack:0     pid:18374
  Call trace:
   __switch_to+0xf0/0x178 (T)
   __schedule+0x2e0/0x790
   schedule+0x34/0xc0
   schedule_preempt_disabled+0x1c/0x40
   __mutex_lock.constprop.0+0x420/0xcb0       # kernel/locking/mutex.c:760
   __mutex_lock_slowpath+0x20/0x48
   mutex_lock+0x8c/0xc0
   __lru_add_drain_all+0x50/0x2e8             # mm/swap.c:843
   lru_add_drain_all+0x20/0x48                # mm/swap.c:891
   generic_fadvise+0x228/0x3b8                # mm/fadvise.c:168
   __arm64_sys_fadvise64_64+0xa8/0x138        # mm/fadvise.c:201
   invoke_syscall+0x74/0x128
   el0_svc_common.constprop.0+0x4c/0x140
   do_el0_svc+0x28/0x58
   el0_svc+0x40/0x160
   el0t_64_sync_handler+0xc0/0x108
   el0t_64_sync+0x1b8/0x1c0
  INFO: task flb-pipeline:18374 is blocked on a mutex likely owned by
task khugepaged:220.

After resetting hung_task_warnings to -1 at Apr 10 20:28 UTC (22 hours
later), the hang was still present and growing:

  INFO: task khugepaged:220 blocked for more than 16588 seconds.
  INFO: task flb-pipeline:18374 blocked for more than 16588 seconds.
  INFO: task redpanda:19263 blocked for more than 122 seconds.
  INFO: task kworker/u128:6:763273 blocked for more than 25190 seconds.
  INFO: task kworker/u128:4:804606 blocked for more than 25190 seconds.
  INFO: task python3:1169237 blocked for more than 16588 seconds.

By this point the Redpanda process itself was blocked in close() on an
inotify fd (sysrq-w at 20:37:41):

  task:redpanda        state:D stack:0     pid:19263
  Call trace:
   __switch_to+0xf0/0x178 (T)
   __schedule+0x2e0/0x790
   schedule+0x34/0xc0
   schedule_timeout+0x13c/0x150
   __wait_for_common+0xe4/0x2a8
   wait_for_completion+0x2c/0x60
   __flush_work+0x98/0x138                    # kernel/workqueue.c:4249
   flush_delayed_work+0x4c/0xb0               # kernel/workqueue.c:4288
   fsnotify_wait_marks_destroyed+0x28/0x50    # fs/notify/mark.c:1008
   fsnotify_destroy_group+0x54/0x120          # fs/notify/group.c:84
   inotify_release+0x2c/0xb8                  #
fs/notify/inotify/inotify_user.c:311
   __fput+0xe4/0x328                          # fs/file_table.c:469
   fput_close_sync+0x4c/0x138                 # fs/file_table.c:574
   __arm64_sys_close+0x44/0xa0                # fs/open.c:1574
   invoke_syscall+0x74/0x128

Two kworkers stuck in fsnotify teardown waiting on SRCU grace periods:

  task:kworker/u128:6  pid:763273 (blocked 25190s)
  Workqueue: events_unbound fsnotify_connector_destroy_workfn
  Call trace:
   synchronize_srcu+0x194/0x228               # kernel/rcu/srcutree.c:1528
   fsnotify_connector_destroy_workfn+0x5c/0xf0 # fs/notify/mark.c:323
   process_one_work+0x174/0x408               # kernel/workqueue.c:3241

  task:kworker/u128:4  pid:804606 (blocked 25190s)
  Workqueue: events_unbound fsnotify_mark_destroy_workfn
  Call trace:
   synchronize_srcu+0x194/0x228               # kernel/rcu/srcutree.c:1528
   fsnotify_mark_destroy_workfn+0x9c/0x188    # fs/notify/mark.c:998
   process_one_work+0x174/0x408               # kernel/workqueue.c:3241

Sysrq workqueue state (host green-0, Apr 10 20:43 UTC)
======================================================

Most detailed dump, captured ~22 hours into the hang.

The core anomaly -- lru_add_drain_per_cpu pending with idle workers:

  workqueue mm_percpu_wq: flags=0x8
    pwq 114: cpus=28 node=0 flags=0x0 nice=0 active=2 refcnt=4
      pending: lru_add_drain_per_cpu BAR(220), vmstat_update

The lru_add_drain_per_cpu barrier work item (queued by khugepaged, pid
220) is pending on mm_percpu_wq for CPU 28, with two workers on that
CPU:

  PID 1042104 (kworker/28:0-mm_percpu_wq): state I (idle)
    stack: worker_thread+0x220/0x4f0  # kernel/workqueue.c:3416

  PID 1158410 (kworker/28:1-mm_percpu_wq): state R
    stack: worker_thread+0x220/0x4f0  # same idle path despite state R

Both show idle-path stacks. The work item is visible, workers are
present on the correct CPU, yet the work is never dispatched.

The BAR(220) annotation indicates a barrier/flush work item. No prior
work item is shown in-flight on this pwq.

For comparison, mm_percpu_wq on CPU 29 looked normal:

  pwq 118: cpus=29 active=2  in-flight: 1149421:vmstat_update
                              pending: vmstat_update

Workers on CPUs with pending work show anomalous scheduler stats
compared to workers on normal CPUs. From the sysrq-t scheduler dump:

  Anomalous (CPUs with hung pools):
    kworker/28:0  pid=1042104  state=I  sum_exec=8450s   switches=1363275
    kworker/28:1  pid=1158410  state=R  sum_exec=3926s   switches=641601
    kworker/29:1  pid=1126545  state=I  sum_exec=14499s  switches=2250077
    kworker/29:2  pid=1149421  state=R  sum_exec=3750s   switches=578918
    kworker/7:2   pid=677335   state=I  sum_exec=3609s   switches=627256

  Normal (other CPUs, for comparison):
    kworker/27:1  pid=1226273  state=I  sum_exec=110s    switches=4906
    kworker/12:1  pid=1235753  state=I  sum_exec=248s    switches=14159
    kworker/11:1  pid=1225304  state=I  sum_exec=307s    switches=16239

Workers on the affected CPUs have 10-100x more CPU time and context
switches than normal workers, suggesting a hot wake/sleep cycle:
waking, failing to dispatch, sleeping immediately, repeat.

DIO completion worker stuck in slab allocator:

  workqueue dio/nvme1n1: flags=0x8
    pwq 30: cpus=7   active=6  in-flight: 713604:iomap_dio_complete_work
                                pending: 5*iomap_dio_complete_work
    pwq 34: cpus=8   active=66 pending: 66*iomap_dio_complete_work
    pwq 54: cpus=13  active=2  pending: 2*iomap_dio_complete_work
    pwq 66: cpus=16  active=2  pending: 2*iomap_dio_complete_work
    pwq 114: cpus=28 active=2  pending: 2*iomap_dio_complete_work
    pwq 118: cpus=29 active=1  pending: iomap_dio_complete_work

78 iomap_dio_complete_work items piled up across 6 CPUs. The sole
in-flight worker (PID 713604, kworker/7:0+dio/nvme1n1) was stuck in
kmem_cache_alloc_noprof during an XFS transaction commit. /proc stack
sampled 3 times at 1s intervals, identical each time:

    kmem_cache_alloc_noprof+0x220/0x3c0       # mm/slub.c:4266
    xfs_rui_init+0xb8/0xc8 [xfs]
    xfs_rmap_update_create_intent+0x38/0xb8 [xfs]
    xfs_defer_create_intent+0x78/0xf8 [xfs]
    xfs_defer_create_intents+0x5c/0x118 [xfs]
    xfs_defer_finish_noroll+0x88/0x3d0 [xfs]
    xfs_trans_commit+0x88/0xd8 [xfs]
    xfs_iomap_write_unwritten+0xc0/0x350 [xfs]
    xfs_dio_write_end_io+0x1f4/0x298 [xfs]
    iomap_dio_complete+0x50/0x208
    iomap_dio_complete_work+0x30/0x68
    process_one_work+0x174/0x408              # kernel/workqueue.c:3241

  State R (running), Cpus_allowed_list: 7, stime=178, utime=0
  voluntary_ctxt_switches: 301273, nonvoluntary_ctxt_switches: 70

State R, pinned to CPU 7, 178 stime ticks over ~6.5 hours. Appears to
be yielding in the allocator slow path (301k voluntary switches) but
never completing.

The events workqueue was also backed up with io_uring/AIO completions:

  workqueue events:
    pwq 114: cpus=28 active=29 pending: 29*aio_poll_complete_work
    pwq 118: cpus=29 active=24 pending: aio_poll_complete_work,
                                        psi_avgs_work,
                                        aio_poll_complete_work,
                                        aio_fsync_work,
                                        20*aio_poll_complete_work

Hung pool summary:

  pool 30: cpus=7  hung=23642s workers=2 idle: 677335
  pool 54: cpus=13 hung=3116s  workers=2 idle: 788155
  pool 118: cpus=29 hung=17036s workers=2 idle: 1126545

All three hung pools: idle workers, pending work, work not dispatched.

In a separate reproduction (green-1) sysrq-t showed the same pattern:

  workqueue mm_percpu_wq: flags=0x8
    pwq 90: cpus=22 node=0 flags=0x0 nice=0 active=2 refcnt=4
      pending: vmstat_update, lru_add_drain_per_cpu BAR(220)

Same: lru_add_drain_per_cpu pending, no in-flight worker.

Reproducer
==========

Reproduced on two separate clusters. Conditions:

  1. Kernel 6.17.0-1007-aws on aarch64 (Graviton3, m7gd.8xlarge)
  2. THP set to "madvise", all other THP parameters default
  3. A process calling fadvise(POSIX_FADV_DONTNEED) with frequency --
     FluentBit (flb-pipeline) does this naturally on log files
  4. Redpanda (Seastar framework) performing O_DIRECT writes to XFS
     on local NVMe (nvme1n1), generating DIO completions
  5. Kubernetes environment: FluentBit and Redpanda in separate pods,
     cgroups involved, possibly ongoing cgroup creation

The hang appeared on all 3 nodes within hours of switching to 6.17
(from 6.8). Other clusters running the same 6.17 ARM64 kernel with
only 4 vCPUs and modest load do not exhibit the issue.

The hang does not self-resolve. On host green-0, tasks were blocked
for days when we last captured state. The k8s control plane eventually
became unreachable due to cascading effects of the workqueue stalls.

A separate reproducer on the same HW with the following changes did
*not* reproduce the issue:

  1) No Kubernetes, just plain EC2 VMs (cgroup CPU parameters adjusted
     to match what k8s applies)
  2) No FluentBit, just stress processes calling madvise DONTNEED in
     random patterns, plus stress-ng doing mm stress

Open questions
==============

  1. Why do idle mm_percpu_wq workers on CPU 28 not pick up the
     pending lru_add_drain_per_cpu BAR(220) work item? No prior work
     item is shown in-flight on that pwq. Is there a race in the
     barrier mechanism, or is the workqueue state dump not showing the
     full picture?

  2. The same "idle workers + pending work + not executing" pattern
     appears on hung pools 30 (CPU 7), 54 (CPU 13), and 118 (CPU 29).
     Is there a common root cause preventing worker dispatch across
     multiple per-CPU pools?

  3. The DIO completion worker (pid 713604) stuck in
     kmem_cache_alloc_noprof inside an XFS transaction -- is this a
     consequence of the hang (reclaim can't proceed because LRU
     draining is stalled), or is it an independent issue?

  4. Is this ARM64-specific? We have only tested on aarch64.

Happy to capture additional diagnostics or test patches.

Thanks,
Travis Downs

