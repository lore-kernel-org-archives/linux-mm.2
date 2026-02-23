Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68ECCEC112B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E656B008A; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719656B0089; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5826B0092; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C73B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD1171A034A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:44:23 +0000 (UTC)
X-FDA: 84476899206.18.AC1274A
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1AAC6160003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:44:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=g58SLHS1;
	spf=pass (imf08.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771879462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LzrTBUBA9Xan0G/6dErkCnhzk9YByLdnZjMaMmM4OD0=;
	b=QhwyvgX+y6B7kJhFErXOZUpTO/hfQyop+/2IYp6XnoLmL0I6m2ouyRX1dT+MPIKfYtpURh
	+bsfOZGg0E06MVFv7E0uMTcvbicO331hirLAGgEJomiv9hBwn3HwLjv96075FwIwiYiM2G
	m5H7QzdvsXaiBQgSeBhfr81CwV3joNs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771879462; a=rsa-sha256;
	cv=none;
	b=I4XpRqU7Io/W3n4hwYjYq6Pb9UiSdJZaatShe2sneFn4KbXxOdb/Y3dnjQWjj2l0qnFNIp
	lidV3W99zImzdykKJx/QnyFRTht21DotbqkxuzK/Eg+f5JQnXsKpCV7uTuVzRu0TK10qt/
	6DbbF4cXUfBU94nGOt/AYYEEkoRDK9g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=g58SLHS1;
	spf=pass (imf08.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1771879461;
	bh=LzrTBUBA9Xan0G/6dErkCnhzk9YByLdnZjMaMmM4OD0=;
	h=From:To:Cc:Subject:Date:From;
	b=g58SLHS1WmcC/+tCAn/vwRtUYUR4EZ2G+eGA0Mm7zzs/IussNdmSyMeyLoFZ8Kn5F
	 XUB8ixuMvQDjZaYpxqzzezrqkImKDTttx9YQoKIjKaKPjnGjs5uzSDK+YAQkiC71GY
	 BmOkvqpJ3JwovwqCqCS2uQv3mEuylEA9nRYly6n8Bmnes8Tvn8rDlkdNhws98NBd1A
	 RTiIB4o0E7k8/t1nxbZRt3EbxASXbrj5kyNFLitbO/fv0kggeeqvHQUSvk4hXXoRI8
	 1UbdHbXT1gXNPgJS7Q6xvrSwmo9FU/uz2qS4XZRnF1HL2GRcQJeGbT7pKzYWa/yEl+
	 T1yceLaLrW/jA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4fKXs10WhhzGXN;
	Mon, 23 Feb 2026 15:44:21 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
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
Subject: [RFC PATCH v5 0/2] Hazard Pointers
Date: Mon, 23 Feb 2026 15:44:16 -0500
Message-Id: <20260223204418.1429025-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tsz4n5fz46qjhw3shmc99wkzbp79kt9t
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1AAC6160003
X-HE-Tag: 1771879461-692863
X-HE-Meta: U2FsdGVkX1+XDTIQS9pnM8dFQEP+5HQVCbdw6+GFiJQCO7pBv7paXfRLNsEcb5J748h9PigzpUU7cHdyv38JPUo7uxH4pMR2G7sRTAHrcm55zhCD6m1G3uXh9MhRr19kPd2h+3YxHvwOQKkm5pioOrTYsNnl5UBFTYIZoe0dcSwvVYK9vn6l9y8r2izjb7uaiHciGVlwrsOu06fBrnDIYPKN+Gwm1PVrGmRsM/vBkSr3vBn/1qBpeFke0DDW+C8UHEDc8T3AZfvErlpgvGOr0ehz2hiqZuM2pRgIKwZoklnJVU77DomgXuipxi+xyOV+pkjK0Ew2BxrTdruOvkcxzAiOvwZE/AZUKbEJoZuT33/jF1OSuZqvpyT8QT5JTMevrI5SJLHx4d4J/ZQowT+SuPQNpMSV6KeQtbn8l9iS0NH5FlynB8w5flhIsUyzok095HwssIejyxkPkWSTug3Eve0gzesLsBe/S3aa9g+LHYqZgZz8X1Vz05FV3S9t/OYlTO3+WdJQJq2pB1MLHgjoNliQ0Cl1xEI2SNv8BOtQnmVelDonsptIXkFKMKFJe94KURw8ggeL6C0BdkVgfjIzNSPXRb7TqhLCgSR2BJRkMY1oowWs1HzxcWsQBGxcv8fElHABpBEg+SfYJ3vJLHXF1pMBqe19rJAyPpExiwcGi5+xijdxhGMTFT0BJf6p24qUIDOiQAf+oGJgOGU8v1AOUwGXL55x3BHVSu9ino+AmZ6KdeQd756HUCy8wLUNtjRfDFre3mes5o1Ukaz7NYmyySoS2MQUIsBTkPiMGZtwMJKgtWDP+ZAnFIqU/w0EdnRieNI8hcf8rCrwuV7FpJCRXTAJPQ5Kraw8Pvhh/YpS5tKK+SAoSHkVjICvhY5i3W0udn7Q6ch0ktkw1Q/cB0a8hX5d4kKp+iJNVjWwoBoda1uXqH1dKwtPh+HDZRCH+xkMJJKvK8yjvhbzprFOqTu
 PJNFxU6P
 +LHemPf+Ez3fdEICS2ZzrvcEWA7WEbMB9xWsCNHTX9VxWpbSLFRn8gFpH7mMCf8IzHT90VPbZNAEVzrGIDIf7c/1MeOaMctVijAhsktHWjQbj/V9+/xrpzVixmdPkvncoeGXwrtgDfoCVY54TmRfRQjcmuBa/uH4A8HGdzBhzVEAQsiKl3dCKGCKn5ESiHucAl6sZr0wDWZYjhrkeJDKRKUIWHM9VnT127Bkw76HzTvHveyhE3IYNknqqKfcLYlnpnNLjL56PROfHpoUjz3mEEHk/u4qW0Cy9YDDmebmoB0tQ2I7XiScWbO3/gmLE2C4K49VJXf2C459luMUc3W62+aYlDN93IR6+0RoJ2aa06LQdJoge1vE9dux0/bxbxWU+LyQqiChCW1KGT7poJeO/JqZ0+Y+lRn1fFzK5p3KLqnws15d71xmhTmCQM9EjVuJcHb9fHHyvXEayZn7uoul0PqtPQ9YFq+fxqF8uufxXIKtFToV5xqwTH7EwS/Tgj7sPt8LjiGjhMUE8tfP3Qq+cqNX35wyY4NMjiaVbWvz8I6iowmOpfDjBTSmQQW0T5mp516Q388wBajkwY49nCkHFO6Y53E/wr3IbrUzQHDuTl7wPqJ/R7oDjJomFd4w+JGfa+h4Isw4cOSxx6wc3dCjepzheaRAkxwXMskTbQr7g0qzHdSGJohZnNFJOI5Ip8a/gt3FMnsNTBYFDfFc9tzgdqVvy5hZK0zqGSFNc+B53HtMm70SZbmBGglN4nbj7e1blxrD+i/t4cJCjg4JgDlX56/vaA3zIS8g8BrZxbcLpYxjbBzH+sNQ8iUB3ZBCQwj4NRHWWQHWT9Q2s4EGYaHyUfsLF715Yy4Qec2rUVENOWFPaWbOLZUcEuHVKpz/Td1XIK7wlojwirW68/wKb+Gvbf3sAdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here is a v5 of my Hazard Pointers series. I know Boqun has a use case
for it for lockdep.

This new version has those significant changes since v4:

- Fold scheduler integration.
- Actually set ctx slot to backup slot on context switch.
- Remove CONFIG_PREEMPT_HAZPTR config option.
- Use per-cpu ctx pointers for context switch slot tracking
  rather than per-task lists. This accelerates the hazptr
  acquire/release fast-path.
- Guarantee scan forward progress with two-lists scheme.
- Reimplement the hazptr acquire with a temporary wildcard
  to eliminate a dependency on the addr_p load, likely to
  cause a pipeline stall due to the needed memory barrier.
  This simplifies the algorithm, removes the need for pointer
  re-load + comparison, and is expected to be faster on some
  architectures.
- Reduce number of percpu slots to 4, introduce a hazptr_slot_item
  struct to contain both the slot and ctx pointers. Reducing number
  of slots to 4 makes sure all the slot and ctx pointers fit in a
  single cache line.
- Rebased on v7.0-rc1.

Feedback is welcome,

Thanks,

Mathieu

Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <jstultz@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
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

Mathieu Desnoyers (2):
  hazptr: Implement Hazard Pointers
  hazptr: Add refscale test

 include/linux/hazptr.h | 197 +++++++++++++++++++++++++++++++++
 init/main.c            |   2 +
 kernel/Makefile        |   2 +-
 kernel/hazptr.c        | 242 +++++++++++++++++++++++++++++++++++++++++
 kernel/rcu/refscale.c  |  43 ++++++++
 kernel/sched/core.c    |   2 +
 6 files changed, 487 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/hazptr.h
 create mode 100644 kernel/hazptr.c

-- 
2.39.5

