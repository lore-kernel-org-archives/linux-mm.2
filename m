Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1692ACDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5EE6B0088; Wed, 24 Jun 2026 09:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5FAD6B008A; Wed, 24 Jun 2026 09:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C026B6B008C; Wed, 24 Jun 2026 09:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93B5E6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:12:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 016E1120370
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:05 +0000 (UTC)
X-FDA: 84914844252.12.04F9B5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44FEF40014
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jfSQ2JUb;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782306724;
	b=69samca7eCkjKfI4pp2oOuBR/OQ2WJ5JQb995rXZKc18rdR0QynCTqvVctkRNp2sAkRjhV
	8o0d/kxRbtcMspD+LtwojPtjXWAg7lbkSMB8qIcrKE/K9gBtNHenibwCtpcWcWeYXyNxiH
	nurLBgs0gR/OYKg9Nt7Y/zHmwtWrq6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782306724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7H6w+2jY/f6FuMYxVOvZHmer+ikNgecUTmJ2xQG7VNI=;
	b=DKLY7/3GQZwlSqLyyAD15/K7zws3IhILgkCgDYWSBwFQr5JEdF0VP5xDmZ2kiUHs1sT7QI
	aNipdW0W9JHxBa2be4FZOxz6dru2Cf1ADAzO0Vpp7KqY4HQEjL+0Ud0ysuQ1X8irxrRb1K
	0yk3QM09/sDqcxlqIeYbVBNQb5J6o+4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jfSQ2JUb;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A597760018;
	Wed, 24 Jun 2026 13:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2DE1F000E9;
	Wed, 24 Jun 2026 13:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782306723;
	bh=7H6w+2jY/f6FuMYxVOvZHmer+ikNgecUTmJ2xQG7VNI=;
	h=From:Subject:Date:To:Cc;
	b=jfSQ2JUbJgnkNkzGlxGTJWufs8jewQhqySJsyXEr6f2bz6OIPbF27kPc9YfBJayl0
	 HB/6Pd5iCPMOXdHI6BFfndarPuxQPTNseXaoH41ku9bD+i9FGPtkCzSOAv4KaC6qep
	 I5mAkcpnvwVRHEaHYwDurvEsrXtZ40JNsZK6/Lm0wOPaPzj0EDjCejAdlgBURf++s7
	 8chQRbB03Ks5yGrh44kl1TN0WepN76vdD/o3vmI9Xf7O49tuop23xpvyZPzM3sFn2Q
	 uMO614azVJ+xEzRM42mLsdUK01cSn3E0nwZPZrImzYY00DuyGCT6sA9fcZ61Gs8Bvz
	 2cJYpa+1Znf0g==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH RFC 0/4] memcg,slab: kmalloc_nolock() fixes
Date: Wed, 24 Jun 2026 22:11:37 +0900
Message-Id: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDMyMT3ezcxJyc/GTdvHwgma2bllmRWqybbGluZm5qbGRhbm6sBNRaUJQ
 KlgDqjFYKcnNWiq2tBQCHyxi0awAAAA==
X-Change-ID: 20260624-kmalloc-nolock-fixes-c97675328773
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Stat-Signature: kfafpyys7sorimsbok8wn8yh11pd4dqg
X-Rspamd-Queue-Id: 44FEF40014
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782306724-901769
X-HE-Meta: U2FsdGVkX19zFB0nMUsH+4ASY1SB7Yr42kgsBnb0Sg/ZzVxXArrQo3Emyv5lEHU22KnmEjaCec67rXHTMmsIDaRUX960oQHtiPQG+I0563Qqu1EDe7MIMZd+kEzLM+96yk8A3I08Y8CtFp4D6mq8yezeEt7I+hYVhYbriwvVWSlIh69dTuXLuy736g2WWShzuMHro8yM+Dks2itZIF5/VHsLdnB3sBItXBhdqDeEsFvgmFGixeru3/On4YQJemL58QOuDHispoPoargiMMKlZTOrly6hIGhpuABdsPtmbd8z60pSH/JXvpKB/goWou2ONqlY3eMJ+cXBwMQWHWwyQS9ldv8eJNAxugAyvJiNcnVppScKFjAl/vRHOq1nbG13QTwD+fN6AoDZY/z7sfj8V9p3AcyK7Efjt3RC+8nHevWRJYEj5fXyWFCkeucn5MSNC/eaXZoDZZ/vF0+TNRZDqkg3qWh/hNLpyIO1IXf9e/DlGKzhKdDswlE3hQnGMo1jm9nJxvoiEAyn1Rc1uymN0VbO1XK+UvHzTK81fGiU5EqcYP1c0V16UvHYsqq1BYx9kgycTni9gWRsTLl0FDmss4HgnC1CjpdmHuxUe0lgoskPSqXz/ukn81NTHFLCDWMLTJL4ROzLMDSNFhQjDZ4DX7dYBphc6RjuCtn6Yb+7tCzMgOIx/aUDLGbC7XQX68P7bwNWM69E9z/MnNjRuoOqxU3T/8EalROe6cyHZ+Znmxl0Mz0KPn/1z3JgFUzPcWDoX/RTje5a78kgb5HORaxWGYD1lJ+bcaCbPOj3dylx6tH4Gv0az5f6qKo0YpBLSSUcyqHFLdplmAgqPQscND3FIsZlS2wcAL6958OMcCRTTUgZ1WOBT6Yruwl728nkka7CP9CXmg+bZyYatUWfn76zHVhIMZRm9q7Q6l10xSNQlCLsotzk9lsUmfE2tO5gnNIYGrw9L00BY/OFuHjUafV
 dxP5LM+P
 wFz6AR5UOcfMiDVkG9TDtT5Tyh8UcnE1m+bAlQXYGVHtLBhJdgnccuuZvGFLyvN8Vii59z9rrWoTIKozR4jr9OdYeoMchcvoehg27LkiRdNAHAYOZ9sltT4ZLAWxlkC92ZtGZxGFR1d89NMvsFlqcOhWfVoywR0qqZCYiTQmxJnWUyq3vmCm2ssKMytYIUBaUpGtpC1rBQYYzTuwcVw06No9z/ztp3uwqIVOjy2DQZ27XB5h27OUyD1pY1ZBb1iolDd4/SU+XUVcrTMRyVSCNwa/+loH9mQKPcQrk+jw5F99Ex6BdaafS4OhgYuO2AT9yQYqQL32JJZXubOpDE9UXmwqURW2vYrkGGjHi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apologies for posting another series during the merge window.
But these are bug fixes and there are other features that need to be
rebased on top, so...

Overview
========

This patchset tries to fix three kmalloc_nolock() bugs.

1. obj_cgroup_put() takes a spinlock in the release path
   when it is holding the last reference.
   (This needs some thoughts from the memcg folks)

2. A spinlock may be taken in the following path and may lead
   to deadlock:

   kmalloc_nolock()
   -> slab_post_alloc_hook()
   -> memcg_slab_post_alloc_hook()
   -> memcg_alloc_abort_single().

3. irq_work_sync() is called without synchronization for rcuwait
   (on PREEMPT_RT or some architectures), potentially causing a
   hang.

Bug 1 was reported by lockdep, and bugs 2 [2] and 3 [3] were
reported by Sashiko.

To MEMCG folks: obj_cgroup_put() is not safe in unknown context
===============================================================

I tried to fix the bug 1 in the __refill_obj_stock() path in patch 1.

Patch 1 considers correctness aspect only, and performance may
degrade because we have to fall back to per-objcg atomics unless
some else drains it for us.

Ouch, while writing the cover letter, I realized that two paths need
some attention:

  1. __memcg_slab_free_hook() -> obj_cgroup_put() and
  2. current_obj_cgroup() -> current_objcg_update() -> obj_cgroup_put()

An easy solution would be to somehow defer obj_cgroup_put() or
obj_cgroup_release(). I would like to hear thoughts from the memcg folks
on which is the preferred way.

To BPF folks: do we need to backport kmalloc_nolock() support
for architectures without __CMPXCHG_DOUBLE to v6.18?
=============================================================

Originally I intended to fix this as part of this series.
However, the issue reported by Levi Zim [1] was on kernel v6.19,
(Thanks to Vlastimil for mentioning this), and v6.18 does not use
kmalloc_nolock() for BPF local storage.

There are still few users in v6.18, but I can't tell whether it is
necessary to backport it to v6.18 (hopefully not as urgent as other
bugfixes).

Thoughts?

[1] https://lore.kernel.org/linux-mm/9bea1536-534a-4a59-9b5f-92389fb05688@kxxt.dev
[2] https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
[3] https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
Harry Yoo (Oracle) (4):
      mm/memcontrol: do not drain objcg stock when spinning is not allowed
      mm/slab: handle allow_spin in slab_free_hook() instead of open coding
      mm/slab: fix a deadlock in memcg_alloc_abort_single()
      mm/slab: serialize defer_free_barrier()

 mm/memcontrol.c  |  34 ++++++++-----
 mm/slab.h        |   3 +-
 mm/slab_common.c |   5 +-
 mm/slub.c        | 148 +++++++++++++++++++++++++++++++------------------------
 4 files changed, 111 insertions(+), 79 deletions(-)
---
base-commit: 892a7864730775c3dbee2a39e9ead4fa8d4256e7
change-id: 20260624-kmalloc-nolock-fixes-c97675328773

Best regards,
-- 
Harry Yoo (Oracle) <harry@kernel.org>


