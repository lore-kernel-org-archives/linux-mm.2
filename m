Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C27D2D68BC9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2F26B008A; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58166B0089; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84D76B0092; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 998966B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F157613C195
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:37 +0000 (UTC)
X-FDA: 84230899914.28.06302C4
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5813C180012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=E7da4dWj;
	spf=pass (imf24.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766022336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=R75Ozd7LaHo642pj4EdBSiV+wVzhB/Yr8urL4+DdIig=;
	b=cMV9420w7BdhSbGFeEqjQnDsa6wFgFPatKBdZLhd8qJ/9q/JTZMiq3b/6Pqrc73kRZ/Bo+
	SfI9AtEenNcyXgSZB2an273Vt3WoV/710OXygSM7r+UFYAwATx5IcQpOV9pE7YeHTB+Wmy
	+2e/O78TikSU6PHUjcBx8R43frBfIlw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766022336; a=rsa-sha256;
	cv=none;
	b=cQX3DAzdv7bZbYQPEApw5M6Sq4ofN0Z525HQr6TEHi78rGWThkOoebPMU8u5wICdabf+d9
	T42eLdQpdtplFK0k9/Mnj52NHshzUu1QptPDEhqgPmPJk7c1yhpul/zpTvoDhnx8M7c4TT
	4nadACbJwsT6Bb3aH0F586AO2sXw97Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=E7da4dWj;
	spf=pass (imf24.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766022335;
	bh=R75Ozd7LaHo642pj4EdBSiV+wVzhB/Yr8urL4+DdIig=;
	h=From:To:Cc:Subject:Date:From;
	b=E7da4dWjePDgirJQpNDti55t4Lvfx7Jf81vQ36+CkIqgj9MB63WkMUWZyFQ4l1Z+R
	 fAahGYiBnYSMLbCrrkBDJ6ZjD7ZmXcT4ysvYn/d8WL5Cp84REXy/j6nLFDqEE1hYfZ
	 7HiwNvgnYjRhN05J51pvo6tSE603MTAPaFVZn8ANCAHtT3lsS1YvEiHihrhFMmnqcQ
	 8x4/LqCVunc/980kQhAzne7oIli2Lh8Rz/joV08o9AtRTTAi470vfVVLK4AgYrLA2Y
	 qQKX2wXJsJvbB4Cer/pu1bI7rx+VXl6NmGvluTrGJGf2eHLq4J4nLIfI0ZQZwT0kZL
	 ks/6qo8Hku2gA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dWtlz1TCCzbmj;
	Wed, 17 Dec 2025 20:45:35 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	maged.michael@gmail.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev
Subject: [RFC PATCH v4 0/4] Hazard Pointers
Date: Wed, 17 Dec 2025 20:45:27 -0500
Message-Id: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kr371uub3oyxr4eiib6zabbe3sepc4oy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5813C180012
X-Rspam-User: 
X-HE-Tag: 1766022336-420957
X-HE-Meta: U2FsdGVkX18Cj5PsC+/ogvfz5GOfMVLPFVMgkX3XMsq3Wj0mBTYJZ1iKILJH/KjY61VAsz7AvUguaqNOMycDDN9zsnb5sIw46egQwyc+3CbuQg1fEWfS09O93530qI0VgKqondLOh24dtkwLAhqz9BV4/DKmsH6p2xiZcbSrMeJhPhujg/2Oxg/Z6/waMIFyKfX3aH26U/xY5pPfJknapPqd1jx9ERpLsLRQUG6tUeJKqmRdORGCC0Qw5YzVKSJji2SeROrAyjFjetIcvWSQGN7eh1TJC9xjbZok4h/EDbo6/RIBqlZbsXZO0Q+TVT4ujsVKUKiySM1Bey83fKQYRZrjpksCRzkaSDvE/y80FHHXRrvdAvNTzMhB6I0d0siO0xIs49mJ5me2DduXvYaQW1v3Dv8lofwT6aS4um/bUnrpuno3IzZnUZ2Ah4zNVKrrHonPfD4yuv6PxwcEst6YTgoutiUxbF5tdVghEsjiM180GDx6oCZt7xin5O0FPNeJ70SfDkkOAHDKgN5ism8CcCTE4uJ3vRGFT/XRbBh1pBNEUcVOWrmU0muxQ8BARbbsshFCd9ofNpiF9qdZMXsS5RN+XrhWKXcrX2bqLexC/3TJy/bp+z76k3KklP6yCooGJeRlp1BYTDN5/2STmwSKGeeJqNi4EAnT/pTpea2WDHMiSNNaSYhNNamwS90DeMoGuVuPZVmzGrQX5uR7sky7Ib1ebwBKdmTk+jXctGINchkyvH18fkfj9R0N+Alpo1tToqB5Im7cMfW90Buqv/9qH4q5JghbI1HAfd5BkVF1nbRpwEhLcDb+x/7YtHaOo+SE9v3MNG3dNged3FwErsCZR7U5ZK73EsfDQkyU+KUdjEnOVqsHH/K4/DkmiXktNSq9cn7wftiv6EDv7uUZ5ob8gDFH3guWfZrrHLcO36vfXenxqS4liz5KVw7LbsQuj3yDJp1RF3hgJFrd+RlHTEt
 UiuM3XF9
 qxQIJE7S7qrtPUCmeOY4GXBWYdGVVIXwK2zTvXs7+6XqvyMGsz1ASZTk8Z0yMSYfb96xuEDz/QMHM1YFD/Dnz16sejIRyTMcaOyQRS1+givTf7x7ZGluZYYZyWYPNOlWt5v8RzFLsBJGGfW6dyMkHshkL8/QYnOFMpaMIKdUaeiUxJyrwQe04X1/4dBZW6d2Exs6zzb3C8bZwFQ6p4CmYQ0f6PLmptlYehKk3s2N10oM8ckrawDE5svj5b+2Vvqi4Z+IXOa317Hh0xI8jJYQVnJqJVjZ0txR4OwUp3IXDIefUIKSxdF/a5349uVyO3VW9bSg4donR1JtGdsdlmfZ6m70220mYhhgs1ZBkL4ssi4APcMZfu5d1pGB7paRIGQjDkcfAU3Ro7um3SgHPCzXwBwkCQ+pP8r7JEksjVqMYVLmjDoH3FcRN1kIEjCETumtZOhiTmdbUBL52Dpl1cFR/nYSfw4t2+35BWgkuOQds3SDA51O9czpD9p0kyefzwW7oF/3Q/5tJ15Bwiz/cOfmJfmgvdLixIHtAuGcWo8tmwF6gXMxsNYofiyo3ebjvdTqBG4XCs9k/nYKfNqQ1q6Kn9i8eoblAZNdyijWAFJuAOJKZ5iAtZMwE+F8xeePt5XcZzTv3rWM9drAPIg/X6F7/AeJ6zDVaByEYFTwEwn159U94JHDT55QWdb5t/T2oYf2Ht481owF2j1MYWn/lClbRonRP7ONn6TfoNWwb6xOdXS+H8RXvb/1Vnn0u2I/qjBS7Au+Rw3CsN6rMOoZo4YJbRDVDUp5DBmSVG1wuy2sJM4V78sEj5+RuH8LYPBGQAVxkp7TQmmsIknB+6/MNNReUIS87T8bp2naYzz6juPak8x2i15F4sHlGNIEMtm77mnZia3YlKWWp6ykzbHOPvKUz9pjo5fKdhDOasMxi62o6SDlTugYKiqIq1I8LFyLW2suTtC/+acwoLyIjDYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Here is a revisited version of my Hazard Pointers series. Boqun, Joel,
if you guys have time to try it out with your use-cases it would be
great!

This new version does the following:

- It has 8 preallocated hazard pointer slots per CPU (one cache line),
- The hazard pointer user allocates a hazard pointer context variable
  (typically on the stack), which contains the pointer to the slot *and*
  a backup slot,
- When all the per-CPU slots are in use, fallback to the backup slot.
  Chain the backup slot into per-CPU lists, each protected by a raw
  spinlock.
- The hazard pointer synchronize does a piecewise iteration on the
  per-CPU overflow slots lists, releasing the raw spinlock between
  each list item. It uses a 64-bit generation counter to check for
  concurrent list changes, and restart the traversal on generation
  counter mismatch.
- There is a new CONFIG_PREEMPT_HAZPTR config option. When enabled,
  the hazard pointer acquire/release adds and then removes the hazard
  pointer context from a per-task linked list. On context switch, the
  scheduler migrates the per-CPU slots used by the task to the backup
  per-context slots, thus making sure the per-CPU slots are not used
  by preempted and blocked tasks.

It is based on v6.18.1.

Review is very welcome,

Thanks,

Mathieu

Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <jstultz@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: maged.michael@gmail.com
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
Cc: rcu@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: lkmm@lists.linux.dev

Mathieu Desnoyers (4):
  compiler.h: Introduce ptr_eq() to preserve address dependency
  Documentation: RCU: Refer to ptr_eq()
  hazptr: Implement Hazard Pointers
  hazptr: Migrate per-CPU slots to backup slot on context switch

 Documentation/RCU/rcu_dereference.rst |  38 +++-
 include/linux/compiler.h              |  63 +++++++
 include/linux/hazptr.h                | 241 ++++++++++++++++++++++++++
 include/linux/sched.h                 |   4 +
 init/init_task.c                      |   3 +
 init/main.c                           |   2 +
 kernel/Kconfig.preempt                |  10 ++
 kernel/Makefile                       |   2 +-
 kernel/fork.c                         |   3 +
 kernel/hazptr.c                       | 150 ++++++++++++++++
 kernel/sched/core.c                   |   2 +
 11 files changed, 512 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/hazptr.h
 create mode 100644 kernel/hazptr.c

-- 
2.39.5

