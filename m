Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CF5C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 13:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6CF76B007B; Fri,  7 Aug 2026 09:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E686B0088; Fri,  7 Aug 2026 09:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D335D6B008A; Fri,  7 Aug 2026 09:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD2506B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:50:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 950C51602BC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:50:39 +0000 (UTC)
X-FDA: 85074608598.06.4C81137
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E21A740009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:50:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cp0jaKCR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786110638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4DjfwV4ACAZUpRZw8MHQBqFBcbFpqFXHuRpYH05Uydg=;
	b=xh4BMP7TKAgDNz85z3r+BWw9RWqHmi8m8Dj8WYl+wstaOrCZqM7sSF1rfHNbndmhHUcAA5
	2XCRqHrkZgPDC2wArSsVYnEd7hv2SZ46Bhn/WJGgIDhRxEN8AfkMtY3yWGnjdrU8Nl7rI/
	6n2/Z0/XIvzAUXSpX5/YxAEacAVP+jE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cp0jaKCR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786110638;
	b=KAPLyWw//yGWAsye2IkdmWMJjLjnG6c7GcwKicOZ6bWE7sj7fpxtEzSoH1t+hQ7Lr0jLta
	j89LV68wJSalHNh8RzyOesrdXFw7h8v8Ruru/26HuG+xW1XBltEYGxGJHK5f5OZdWqJs5E
	COsgxuovWWhNxW3QAKN+rmJHaKqsvvI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE66143A4B;
	Fri,  7 Aug 2026 13:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132021F00A3A;
	Fri,  7 Aug 2026 13:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110636;
	bh=4DjfwV4ACAZUpRZw8MHQBqFBcbFpqFXHuRpYH05Uydg=;
	h=From:Subject:Date:To:Cc;
	b=Cp0jaKCRDnHCNEKuRgGcimB5c/OcwG/zvo7mP0N4Fa133BwLaa7BHfpAZRKIILPo6
	 7CjfGJ4tXc5ZG3JmqiAtktsJw0/1fbPBsODeqyAtXiuJqDiwy+0eT5ODBTu8Tvto1J
	 Sbly6dpwQQkkx2IjEzzozvYHi9u+WDb/DN37BauhuqKeEnFPO9QYrWPkzwsUw2xf6b
	 HmBujHQs0QlKI+EBXVHKerqIcDOGLAQ2/zICGf6VSpGoMMBboxC1LXehxtM6c/thcr
	 OHFX3+PojipRuK5JkNDRNuB7hsPb7TdGzpFKFcjYwMIAEj34A+3zHg8LCJ+q7tdjLg
	 HT0JC6CyGz4uw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH RFC 0/5] allow kfree_nolock() handle kmalloc() objects
Date: Fri, 07 Aug 2026 15:50:26 +0200
Message-Id: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKLidWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDc2MD3ey0otTU+Lz8nPzk7Pjs3MQcIEPXzMDM3NDcIC3FNDFFCai1oCg
 1LbMCbGy0UpCbs1IsRLC4NCkrNbkEZKBSbS0APFcePH0AAAA=
X-Change-ID: 20260730-kfree_nolock_kmalloc-6067170fd5ad
To: Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, bpf@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Dmitry Vyukov <dvyukov@google.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 kasan-dev@googlegroups.com, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
 Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E21A740009
X-Stat-Signature: wcrzcyngq9pnzztdcn5eaoz39t963de5
X-Rspam-User: 
X-HE-Tag: 1786110637-879909
X-HE-Meta: U2FsdGVkX1+xS8W3vV4S4dccIKLwIk6xDLeesPXnY4QIKLXBXrHC9/A3tHGNePcgkab0R+PeImmFjdLwrDUlIIzR0mzCOCFzNnjjbSSoRXzKIyJKOOxj3hn2u27W6cNb9i6QUD8DA2apxwGqJ+LY7DiqmfP58Kgr93Rkpi10Kmwvs01eucDkeNYaihKBBe0BfTdYtFsJqA5gDIy/X75rLNYe4zIRLjVlElWErRg4iM1iW7/MzE8AWweYc1fP0hAaFmf//Jl2Pt42P/q4ZpKBBevurcziZtQnTlwakJCY9eIUi8Ex4YDZ/DP+SJhvzGrB6N3iy6u0pcZaHPgUphMrOGP5SnywbMbrqK8tZ1lwQAtR2qrEgG1vY4Yawu3VLtPKG9LPIYAVio1oYUNaA1aMrSQ8w2dOUI6seUVPwC38fCJYkM6Yk3hPzr0WrKyIl9hVfhiyZ8iP0sqjd+5rHf0q10mUfQOWwXLhwSYycSRPZxYO5MQhzmw1Lanwu4W2gk/TGfm7/Zb2m1tZ9jH1J3fkfpY4UZs4gQA/0w7aEJZuH2cQ6fqhcSqpCAjJAGNRad4hF807o/7bBKvI9q+zAX1qPDkDzKsrckMwjNzv81fNm1Fqti/bMgVb/BfO0g8wLa7Og8ruNnm7qS8waXSKtqtqUwMgEWevrqGcOr4zYKBPo28c/mSN2Y4lTQqjB0npjvYnYI9g9RVaGxnJYHUSKSmgmNeOzI0To4JjGuJA2P9AvtukvxO035z6l/FOrT+593UGkfk9B43G4UsXG4XAAabKafmx9g8s2cahAXN7gFzKKtLQmaqKSU8V02KD6DBR6e8YFaeYP5CSGxZo8BWm8C9AuQC6Q6FnHWfBcemKQKEgWIG75QLLl0Lo1bTh3ZsKOY2HLEzrZKAcjvSqa//j6fAmE8++t0ifklNjjlyKH3JefBEXNqt4u4T4SxAxX2AQiocTXq/AJ9KsWNsyyDFfAOm
 5Dm68wtf
 clIUFT182kiMWKwclurl6HD5vdOMUGGZ/IQcET+M+r8UAs94OsVB0nQOMtQ9YISwgEdcmDG7S0PGn0OPIHkLQXnKL24R+si6jLcjeLN//DajNmzQnZm4uSoFTuPyWwBHTbIyw3cS6LaXaA2Kv1huqqF97NezgWx+Wv0T1ENZKoABSpVOgzjg0QjJqpEUPbvoh5LPr079+YIocfqd6X2XSqO/7ns6kjgfwGMKLGnQxP1CZDDaDQiF5I2ufg8I5lrIRvP1gobwN+4lDjWHttIMRy7hU8mv5cweOwOCT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an initial RFC for something that could target 7.4 and
definitely not earlier merge window. Based on
slab/for-7.3/kfree_rcu_nolock

Currently kfree_nolock() can only handle objects from kmalloc_nolock().
Removing this restriction means an easier to use API and might be useful
in some situations. It means dealing properly with kfence, kmemleak and
large kmalloc allocations. Some of the cases may end up being deferred
to the irq_wor() but that's not a big issue.

As a example of usefullness, convert a kfree_rcu() to kfree_nolock() in
the scheduler code, where kfree_rcu() has been used as a workaround for
kfree() being unsafe to call under pi_lock.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Vlastimil Babka (SUSE) (5):
      mm/slab: cleanup deferred free handling
      mm/slab, kfence: support kfence objects in kfree_nolock()
      mm/slab, kmemleak: handle kmemleak freeing in kfree_nolock()
      mm/slab: handle large_kmalloc objects in kfree_nolock()
      sched: use kfree_nolock() instead of kfree_rcu()

 include/linux/kfence.h   |   5 ++
 include/linux/kmemleak.h |  17 +++++
 kernel/sched/core.c      |   9 +--
 kernel/sched/sched.h     |   7 +--
 mm/kfence/core.c         |  14 +++++
 mm/kfence/kfence.h       |   5 +-
 mm/kmemleak.c            |  42 +++++++++++++
 mm/slub.c                | 157 +++++++++++++++++++++++++++++++++++++++--------
 8 files changed, 215 insertions(+), 41 deletions(-)
---
base-commit: 648294a02bfcd0eddae51877e3b30f8bbb2d4bb6
change-id: 20260730-kfree_nolock_kmalloc-6067170fd5ad


