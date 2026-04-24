Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7882FED3C0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2556B008A; Fri, 24 Apr 2026 09:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189786B00A0; Fri, 24 Apr 2026 09:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5C46B00A2; Fri, 24 Apr 2026 09:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECB5E6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:02:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE22840163
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:02:17 +0000 (UTC)
X-FDA: 84693462714.27.87F3E62
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF44440021
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:02:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=E33j+Pmz;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xQCJioJ6mQW/t4TnMvvD02IbUmr7uhQng2e/jVcwDcM=;
	b=h+hWNZ6k9Xw3vDboNaaeeVqwR4o2IE8G/P4DwlgkksUp2vH0NDuwBrmM4FGxqSZ76Sz3ZM
	6b4yHr7yafxMQy9oqrciwK3v/K/YRp7UKv3YX+vWB7nlMQw4it2LwvQQaNjizups1Dlm2c
	2PK7g69pDyk3TdOZkW78Wlgt4fmCTB8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=E33j+Pmz;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777035736; a=rsa-sha256;
	cv=none;
	b=kt+s/WEpKXmnn3qaHaJujmmePEP2jnPvN8u9sHXdyVvcKDHic174cEg/eph8aS1q2nHy7g
	xjwrre04e/Lf6Enum3KojQeI5YWV+S1WCGMJ53OZZC3YtXDHyAOfAlCf4xg9SCYjWUCG43
	rOXf2FyRISp7Xj0jIYpP3uMNMZsM2MQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48DAD1AED;
	Fri, 24 Apr 2026 06:02:09 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4A8963F641;
	Fri, 24 Apr 2026 06:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777035734; bh=2GQQpZVfKf79CLkB3vuTV1KsPX0Zall+u2kivJ9bl90=;
	h=From:To:Cc:Subject:Date:From;
	b=E33j+Pmz05YZfhkrDU022/rWSei1SFcH47C9oocH/5SUfc2ps0SefGiVvBrbaTqh3
	 MUYngzyinhJekaRpLPWdPjLzMmnx46DUZwn7Kgs0ZQ/tjpQ9M4VX6iLpV5cG49IgBq
	 BGlhWjbqUtqLJizsevU7JkEmCAPdkS88/toAcKy8=
From: Dev Jain <dev.jain@arm.com>
To: arnd@arndb.de,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com
Cc: dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	tglx@kernel.org,
	usama.anjum@arm.com,
	mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v3 0/3] kasan: hw_tags: Disable tagging for stack and page-tables
Date: Fri, 24 Apr 2026 18:31:54 +0530
Message-Id: <20260424130157.3163009-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF44440021
X-Stat-Signature: bbghan83ns35qsdkbqtx81og5q7odq3r
X-Rspam-User: 
X-HE-Tag: 1777035735-691124
X-HE-Meta: U2FsdGVkX1/oylO33fkNKgMCdgzGmlII3safhu0iln4smoT1K3oZQUzUTNpfjshLjmRdlv4RC1Gorrl3IAGI6JDs/NRITR4rfIVMnN4jNyfuYNrdDnd28qglJy8XOnkogo72rRb9NBOVE8eJyahYs7w+LP0POcYLYwLE21qnAOciygR8fbMaJ7YvDPWydzsEZa/heEp1+dqcb5868xWcZ/TwFpTiSntEcH10xUwa6/Q0skGAlx4XQ91Dn6Tqk0PPOnz7U0g65EWinla0aWGaAulMpZCVLkLCAzaY2ETB+TzZvkYvoRNTPI+8afZ+yXrJ60VxZexo7vpt1WbSdt1mLJ8JT2CR/1FJZDM8g9M8GjkgW5/8OxfdEtgJJwgk9pZ6crEzllwAdBA/jH0WwEt6IxUO6czikH1gkctBREXkhmlZsoZrbSnv+BKI2QO4CgxJqjEWCREturLofT2eNGk6HHTBsOGQCnrBHgERbajSQ7L5HKbEHIHF6Mv4PnkN2uEcG/UqxLDrA+r9JJC48idX/H6hGCz8ZrzzkurqoyJmvc+XLxl2Nhd5LzoKqviNjmCQ81gpBxNQy4gcMXl3T4ykYKG5Xw3mUf9C6s+HEEYQuxZjZJwdR8XGBMmfDUse8xFUMN5tEUPDthDcE+a9ACFXb8YAVcyXaTPY+qP84/729U+wqCD4UD8gjK9jH51KYJg7t49EcKV1HOiggbKwcxkJiQ4rFoCgqG/KadO+KpdjZ+ZUGbXf1epRXwKIUC3AbnbR7cN0c84nSmPBHMyq8fqs5dse/W6uCIMls82l82fzUFkKNp/gTX1WeEOais/me1l+8rZgZHeFzkM2CsNn9iGl/hD9IUaW/gbyD4vifZwakM8ouqvO/QHOPS/Jh4Agsl3dtFmOv2Owyh1D+OcxzA+AVGIp7dVpBzNj5m3GbtsnTcA7ntqZXu+h3w8TTY/EIu216TTXiSD6wIvXQ9no1Ry
 Zcb/xB01
 +Fj1MMe66ihwm4DByRU5dtEV9L2quitbQtM+Ik8Y1ndr9NMAvlGR9Tw3dqlAiEs/+IYT2YdyKHdLRD+/pECaKo78ADeqqRrg1KHg0vYDGHYmFVMKI38B0dys7/BPkuoU+3HpaWPO8D35FNnt//nAnHg5tRclOV8pP9Tk59pS694+omam5pS3RXAahMkUT79Y+GrIrpDP/Wfmb61y0urlqJNduwhJLPoPmOREH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stacks and page tables are always accessed with the match-all tag,
so assigning a new random tag every time at allocation and setting
invalid tag at deallocation time, just adds overhead without improving
the detection.

With __GFP_SKIP_KASAN the page keeps its poison tag and KASAN_TAG_KERNEL
(match-all tag) is stored in the page flags while keeping the poison tag
in the hardware. The benefit of it is that 256 tag setting instruction
per 4 kB page aren't needed at allocation and deallocation time.

Thus match-all pointers still work, while non-match tags (other than
poison tag) still fault.

__GFP_SKIP_KASAN only skips for KASAN_HW_TAGS mode, so coverage is
unchanged.

Benchmark:
The benchmark has two modes. In thread mode, the child process forks
and creates N threads. In pgtable mode, the parent maps and faults a
specified memory size and then forks repeatedly with children exiting
immediately.

Thread benchmark:
2000 iterations, 2000 threads:	2.575 s → 2.229 s (~13.4% faster)

The pgtable samples:
- 2048 MB, 2000 iters		19.08 s → 17.62 s (~7.6% faster)
---

Changes since v2:
- Directly skip kasan_unpoison_vmalloc() for GFP_SKIP_KASAN in patch 1

Changes since v1:
- Update description/title
- Patch 1: Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
- Patch 2: Specify _GFP_SKIP_KASAN in THREADINFO_GFP and GFP_VMAP_STACK

Muhammad Usama Anjum (3):
  vmalloc: add __GFP_SKIP_KASAN support
  kasan: skip HW tagging for all kernel thread stacks
  mm: skip KASAN tagging for page-allocated page tables

 include/asm-generic/pgalloc.h |  2 +-
 include/linux/thread_info.h   |  2 +-
 kernel/fork.c                 |  5 +++--
 mm/vmalloc.c                  | 20 +++++++++++++++++---
 4 files changed, 22 insertions(+), 7 deletions(-)

-- 
2.34.1


