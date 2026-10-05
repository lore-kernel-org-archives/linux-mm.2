Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 143FECA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 07:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FF56B008C; Mon,  5 Oct 2026 03:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7A26B0092; Mon,  5 Oct 2026 03:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28786B0093; Mon,  5 Oct 2026 03:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD1C86B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:06:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63B72A4A27
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:06:36 +0000 (UTC)
X-FDA: 85287689592.21.E55F695
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id AEB6980005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:06:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M8NjU37P;
	spf=pass (imf30.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791183994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+vg5y7TFdC/oAYFLNYNMU7By8Gx4IwKuOI2ehF5mxV8=;
	b=C1Gl0vgHUN9S4/NV2ZXdXCOld3+6XAFW51IVDkVidqsWZjkNP+kJqTBVgUlWd7+Q4yZ5Pa
	4pt1tWU8dblHZ5U/5WDNYtZfThzj0xECP4HPhQYHFhg/f1w3AiBc/KOIV9ILdz5XF5TONU
	GWcGB6fV0b3CoRgKtBEfijC8qgdOtuo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M8NjU37P;
	spf=pass (imf30.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791183994;
	b=hGdapbZnbAO48HGyKCa2L07hoJc1pP+YH0aa56Bbw2QXh86OdUD26xtb09TCh99gpBaLcI
	dm+RqxoqECt2w1u0ZTC+zMBdbGjUq8/vkmIib3DewUuE3SPx4B+b+NJlpG5Pg6c+5kJCn6
	mHN7WUj82JfEwYThVDnH70c+0GdQPiM=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a01ff8c098so8937855e9.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 00:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183993; x=1791788793; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+vg5y7TFdC/oAYFLNYNMU7By8Gx4IwKuOI2ehF5mxV8=;
        b=M8NjU37PKbQpLG+SnON1g9do8vJZtEPdhQ5C4Czi0pCVCLgdeIRgRqO06keeEzWiP7
         lyTKbhLZXmY70pUT7XNtnUB42ghgWwTAtCUrif6ogJy2GkiJXk2BFVLmpgIwNZJI47k2
         GWoWPCXJEwKgxOxtbEUggOkq/UK502vrUnLhIGjPMpCzdxTCvVswbJOqjKyynCVP6i4b
         Y2IKebtnVffNGiYAmzlFcNNmVfPHHn5ps+D2uaBRLnE/nz79sFxDHvYcIr0A8/9Sj7iU
         y3axf+wFie7YvhzUkr3caeLimLTMXQF+hLGAwv9sGL6N/sBuDYX4NIR60TTqgU9Rawcg
         yLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183993; x=1791788793;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+vg5y7TFdC/oAYFLNYNMU7By8Gx4IwKuOI2ehF5mxV8=;
        b=gl+M3JVU+bHoPXztCtoZTDnxf+ARFifSgWO28fjK4NKInR/QK73RO+LAS9rIas7Pd2
         M8TPKasDAYcDXHz85LWKm7nq+gzYKS6xHeEq4o6dNbLAGAYC5a/VKMok6ICTDo9NxBXw
         kIW72TmgTb7g3n6BMHB3RCI9AI8XITWhsSpQxzSBr5P8lEj80FhNmUpYm9F8ebCPU3Lo
         VyaAVTq1uThjPkBzSEGyXCDeVj4G+U6fv2UoaXQq7Ahz8feCulQHebHFO5lr4iYlLnWA
         58p4tDCA7u6TS86dgkupWtyR/B8M/nS5hMJM42uqtUWRIuJsF9G7PwZ0AzlI8b5WaZfL
         zeUg==
X-Forwarded-Encrypted: i=1; AKwUvBzP4usL/6bOtILATAWpYCb3arvH+IeeUq/02KQXJb2lcb96js1b6PbFg93NJC8m9kHzRwG56QktJQ==@kvack.org
X-Gm-Message-State: AFuF++nTQ4bsJd92sirv9CPv35Qxd4QPh3oFGGwcrND8Q6lkBfb2Zqq7
	Lvmij34xppKwBa8bQXvaP6QxM4eHSoDpr03UllO/mFQwwIb3Il81Bv10
X-Gm-Gg: AYBFou2foi3c4PV9rpwYFhOY6A0UhtZkKtVbnJNq6VBwPXlI7Pc/LCOrqbJjqdgH4i2
	IE7kiA+tMr0lRzQNOnNc36qermA0paSxfQ/cjHW98ej68B/lbIN4DJY/jC9SQEr1KXkKX6ygxbk
	J1FqxHLtZyNfMQ6doA45Q6TXFJNtsPKMB6N0ijtFI5TpQQcBJaKC/zeUiTOI3tXRy2JEMSrcIUo
	z+QZLxIObOHhbIkIHs4G0byX7LABw39ZWjODqBuAYCg0RBjymu5jipKpQprG5r+NFgsq7jQwCuv
	bBDCYzwpxtKkYfs21KjVPh0Guy/CabVPgfElrP8jVWpl367RKz+jEpKVqLtGhQOHJsEAzGHt57Z
	7yKdjWkyGQQOtXHHZwUzzSGMQTJpfOMntYVhLGhB8u+jQpfgjt6sQ7nbHfJ0H3/yzcrLL6aKa9L
	dWt3SJMMnaTx85b8W7zMKtsuAJTpWPFK/Ws/dOnFj0R0YItYwt2yukWJbj/UwQSirVB9pQcBNLC
	tWEhRpIVVHu3ckhs8juVk0qLp2TLA8BJWjzXz3F7pS/9KLzPXyKFOwU7WYUnXbl9MeeYXSNhyz5
	eWeTbdWww+56NW2nBr3oBVDjNFsfhOMRcKfsj6puSzNEIGVPdp+d6kYTfiCNnGQh08Gcozsop7V
	Lmg==
X-Received: by 2002:a05:600c:c4a6:b0:4a0:25e9:bc47 with SMTP id 5b1f17b1804b1-4a02759a443mr172676745e9.19.1791183992976;
        Mon, 05 Oct 2026 00:06:32 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b305-2001-39fa-3d24-821a-4eae.310.pool.telefonica.de. [2a02:3100:b305:2001:39fa:3d24:821a:4eae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a16bcb9a21sm283461465e9.10.2026.10.05.00.06.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 05 Oct 2026 00:06:32 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on RT
Date: Mon,  5 Oct 2026 09:06:22 +0200
Message-Id: <20261005070625.8871-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEB6980005
X-Stat-Signature: ef3irar81ubkhriuzjc31mg5zg8ai9ak
X-Rspam-User: 
X-HE-Tag: 1791183994-44463
X-HE-Meta: U2FsdGVkX1/R1HmVvdUBgpxPwfO7ldER4Okf4BRKuDbe26eD0F9UdXDWOOQXsIqWE+DbXCkWgN1Q+o5btc9XnMVowIECOTSkk7C+31+LoK7OM+cRcLJi9gPBtSJy54Yz7pp6xOiKcT6FFfO7IoYavgiVV2nIMQ6ZWSu37l4Iv7mjBI9eOevOGx/wVPoPdIc028PUvZTlhohrDJ2fWVOaK4WQnBbW0vY8AOywZBhsI9QUNmtI6a7GlwFrpOt2Kny0NlBF1F53eshB0tupsyM6UwJehXAKquqMfGsxHQB2qQx9WQJ3bwprHGRI3bfwmhpOgz0J7ql6XUz8OZA9OAXgPAghE9NQ2nyl2+70gCfPvMdNjYlo1le9+y2cNQb/wDbpQT6sN8iowLTUG2X/6f90TOBrfWvj+vpkpjOkFX1ezn9r7/c3B6IFOIkQ24cMPPT+2886FFNebSWONK4SGzKd0G04x1b5FCEwAkrLpziNMXZbjauYyreebLyUIDyZE/jeJ9KVrpdfz405dzi9OxOMQpn4pQpMng9HSYfmrPtQhZrrQtfBkSCEIJsaRTK8D0dq0szOP8D/+aNSCF3cR70vFjDMkMkL+PaiHhSm58+/wDfUPWgsbaF74WiCRw9YS34Wy+gg0XXbtaBf1dAH8CNrGf2z492BU9dJSPq4GY/XeFOuSAfYb09oiv8bOYc9IVnemM/AQz83xhxhFAOVBR545icBMNQnS8mZGSaHktLN1GoMkdp8/fH6Tnsk285C7+GWhWpeIvF/aRfKTO9CWWGaMHLg/fS8Kwy7rIqsG328wpv8uDiRWMIkfCpu3kfvgXI14uq238YPa0w6t0UCDOlVRGbUDeGfjFmNcFHW+3wlP/tNbnbM9R1o50ajPh4RiivYuOWJ+36Ch6SLItQQEiYay/shT8CFWTMXOBbn1lVvhEbscNsNqTBPzt4MMrDnLj4zjQ7SCk+uITa8154CEtj
 abV4cXfZ
 urUOlvO7dLZH2e+pmIDPRHt7Rwkxuai0y7Y7QHl1vbBi0hqyvIefZRPP+TBIRk3kr34W6/vRbQ+2vFXe4BprpjwtzzC5aTW3wfmzFN+U6u0XhJH63oGXDWPMvWmMqiQ4uSWFE6gq0hEFk6HjcNEHUBmXJFl472SZygFrOLhWQBuI+z9eVlQM76gVXovuZqWudWzg1iY3H3bNoYc3WegkXYxTewaIyMLVDNIjGfies41LjXf0obCNw58Pc13Xw4IioLmqmDNkLcJNNlj8aq3TmzwVApDTYJN5OT/AiO5Y+9Ub27ZoX8H+LiCQnF6d2OaSuquVjRCZNoywxMtAD7AhMKw0N7tDlHRUMhhCQnvpP+gg7de5DCNh71zGCnEDrJrU7gakgRsmKulJVv9KVWpdGVoHcYbAm2uyRb9suYfZcVP+cz6LqTtdbISSygyd+b+WKWgPNiPS1HWSxDBO39p5GoY8zxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On PREEMPT_RT, a BPF task-storage program attached to sched_waking
can deadlock when kmalloc_nolock() obtains an rtmutex-backed allocator
spinlock while try_to_wake_up() holds p->pi_lock. Releasing the allocator
lock can enter priority-inheritance or wakeup code and re-enter scheduler
locking.

The first RFC [1] rejected every non-preemptible caller. That prevents the
deadlock, but it also rejects BPF arena allocation and faults under the
arena's ordinary raw lock.

This RFC instead adds an atomic owner state for bounded PREEMPT_RT spinlock
trylocks. Atomic acquisition succeeds only from the completely free state.
A regular waiter sets HAS_WAITERS before waiting, which prevents a later
atomic owner from barging. Atomic release preserves HAS_WAITERS and does
not enter priority inheritance or wake a task. Preemption and local
interrupts remain disabled for the atomic-owner section.

The design tradeoff is that a regular waiter cannot boost an atomic owner
and spins with interrupts disabled until the bounded allocator section
finishes. I would value locking review of whether that owner state and
handoff are acceptable, or whether the no-lock allocator should instead
fail in these contexts.

Patch 2 uses the new operation for global SLUB and page-allocator locks. It
avoids regular per-CPU RT local-lock slow paths and reuses centralized
objcg credit when the per-CPU stock is unavailable. Patch 3 adds a BPF
selftest for task-storage allocation from hrtimer_start while the hrtimer
base raw lock is held.

The series has one prerequisite, recorded by prerequisite-patch-id in this
cover letter:

  mm/page_alloc: skip shuffling and reporting for no-lock frees

That independent fix has been posted as a normal patch [2]. It keeps a
successful no-lock page free out of allocator shuffling and page-reporting
notification. It is separate because the issue begins with the v6.15
free_pages_nolock() API rather than the v7.0 slab regression addressed by
patch 2.

Patch 2 should also be evaluated with David Stevens's pending memory.high
deferral fix [3]. There is no build dependency, but bypassing the per-CPU
stock can make a no-lock charge reach that pre-existing schedule_work()
hazard more often.

The pre-rebase version of these atomic-owner changes passed four-vCPU
x86-64 PREEMPT_RT QEMU in release and lockdep/debug-rtmutex builds. Tests
completed 5,000 forced waiter handoffs without barging, kept asynchronous
IPIs out of atomic-owner sections and passed the BPF hrtimer workload.

After rebasing onto current mainline and the prerequisite, the affected
locking and MM objects build with PREEMPT_RT and lockdep. I have not
repeated the runtime campaigns for this RFC rebase.

If this direction is accepted, patches 1 and 2 would need joint stable
backports for v7.0 and later.

Changes since the RFC v1:

  - replace the blanket context rejection with an atomic rtmutex owner
  - preserve local IRQ state across a successful atomic trylock
  - cover the global slab, page allocator and memcg-cache paths
  - bound shared objcg credit when the per-CPU stock is skipped
  - add forced-handoff, caller-attribution and BPF hrtimer tests
  - keep the independent no-lock page-free fix as a prerequisite

[1] https://lore.kernel.org/r/20260919171443.90512-1-kmehltretter@gmail.com
[2] https://lore.kernel.org/r/20261005063515.6312-1-kmehltretter@gmail.com
[3] https://lore.kernel.org/r/20260904173145.2028377-1-stevensd@google.com

Karl Mehltretter (3):
  locking/rtmutex: Support atomic PREEMPT_RT spin trylocks
  mm: use atomic RT trylocks for no-lock allocation
  selftests/bpf: exercise task storage from hrtimer_start

 Documentation/locking/rt-mutex.rst            |  40 ++--
 include/linux/rtmutex.h                       |   4 +-
 include/linux/spinlock.h                      |   3 +
 include/linux/spinlock_rt.h                   |  28 ++-
 kernel/locking/rtmutex.c                      | 211 ++++++++++--------
 kernel/locking/spinlock_rt.c                  |  66 +++++-
 mm/internal.h                                 |  27 ++-
 mm/memcontrol.c                               |  90 ++++++--
 mm/page_alloc.c                               |  33 ++-
 mm/slub.c                                     |  36 +--
 .../bpf/prog_tests/task_storage_hrtimer.c     |  50 +++++
 .../bpf/progs/task_storage_hrtimer.c          |  48 ++++
 12 files changed, 479 insertions(+), 157 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_storage_hrtimer.c


base-commit: e767a4ea70a3992c37ed604157d32f0dfbf9b1e3
prerequisite-patch-id: 33838040c410e5de0aef855a2719a092b561a5c4
-- 
2.53.0


