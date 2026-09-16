Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D387CC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA216B0088; Wed, 16 Sep 2026 08:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1AD6B008C; Wed, 16 Sep 2026 08:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDDE6B0092; Wed, 16 Sep 2026 08:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77B676B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:57:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C99091206F3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:57:53 +0000 (UTC)
X-FDA: 85219627626.03.CFABD41
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id CF65440004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:57:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s4Xh1WSK;
	spf=pass (imf12.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563472;
	b=Gt2jtHDraPPFMBb1maTTPkNC2hVeOCe02X77GwpSSyv6LIdiuJCu+oxmj+DkdKL1PngN6O
	4SDhqIPCzv/Ixuqo2U3EI9G1e5TO3LlnvMjviZwiz1rPqcSNISyYoWQwKuNuP/vfU5pBCB
	c4VuadL0U81GfLiTirNnGquHk8W5qNc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s4Xh1WSK;
	spf=pass (imf12.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6LHRwc9hfe+8wlSdYZiBvpHQWnek8bduHheP6Q+JQxs=;
	b=gZS+bukMPn/EmF3W99fBcDphrD36WNJEOK9aOJ3Ir8U0FDDrp+2ECZaNkWMyIk8lg6DHk6
	HCIZUTTLa60uQV8TLNem6oCn2kM7B5ksCY392V/4wSWxEhk9keAkmrUXTr9zZ9+du6s7+7
	72UhwnCOkbabzUZurqK0gGT8KCd9HUY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BDH6FArRRvE+3dLKSpGnjrGvHJG5nza7z7Yx6pA8U9k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563470; v=1; x=1790168270;
 b=s4Xh1WSKdwOjNiQ8eD0NOLf522d0JY13f4oPJlpsW/yoG+ECbe6bVXYYjNdsKMjoa+4HUrIC
 SZxDRESXo6Zf5xczH0y5JQBQKRdMm8kvxf7f3dXlhegtYFqjFzJuph7imecyqVUxmqjvIkDq3OT
 aUEOCFwY5HYtVpxkzrNf/4tY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 13d5477597e6c301;
	Wed, 16 Sep 2026 12:57:50 +0000
X-Mizu-Trace-ID: 13d5477597e6c301
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from struct mem_cgroup
Date: Wed, 16 Sep 2026 20:57:34 +0800
Message-ID: <20260916125737.1095414-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF65440004
X-Rspam-User: 
X-Stat-Signature: phacgsx5o1mqsu6idod583trwwy5tiu4
X-HE-Tag: 1789563471-956927
X-HE-Meta: U2FsdGVkX19Tx9UkFbsKqpbP18z9W9P9c6GNok0+gFet2cO31PtaBtUt4Ruxy1BSVMEgU5Xs5Oni7Og3TYGUqpBbQmz13F/67oNlqUYk3yfAgfS4BlmmfJaz4qoo2micNDJHv0VuyebcDN01R0ECThPnHZXcW/8stDQAcmiqNeJve6956OFrV/gHPMU0/6WWgKvnhowwIY15QkRMY6XDzvtspQDK06347laRzob7wEYuvDNuIKtl5O3SoFJKpP5AMqbtYNhPBO3Hr6cVXWpaoM73TO5xxGyzxuDOR+FHdywC5D9FZ9eaIimqBEoGkyP9T5M43r0Bt9POhx8p8xdK/ozA1ISMy2gyJlhecSa4y2dbdZaiEggmY2HQZLionndbiSCl5zz8MVdFAq7xsZO0680EUee8nTgb9U3CeXPGpSG4cF/yKmINT9JnRMRUKvQtFTg/9yzQKsGSO+PZKrdMqa9ewlFiI9PtigNzBy1XY8GZAAUrBs/diPYbxSb7qa8oo+T63awzonCUnBQ6weQhM9UlC9JahWsuuUBISe18Bi85/fs7/+3xnm3uW6MdThoCx2ZAkkzbuWtvyv7I/1G4fWVJ3lDdS56z4rs9JSlLW+920ZQaznzEq0Wnc7iTGuoo50zL2qH+d+3HEIUCs4LX8JlE8CMoZanwFgZTWPt7cEz3dfGF/+kXz6CaeYo5AUWo5MYL706uDVfe8EF0O8vsCJCAk2R6HLQ1DYjaPjFJeoHpSu+KoWxbYVO72I3FqRmRs7BaglfzG3mA/4SRuoFyMHl6UI+DiqeFOdXNadL1a+o9H9Ye7+d6LmXwd5Wph1Uxpr8KhhdoscBqtzxTPKOVeEsaWn2jwOTjEo5uokcoc3qjMQuzEo1vkMQ5g1nDgWXDBjm8VLSXfCHx8YeqtAp2BGqCG2sbMVVdfG3JNVFVsyBzV7mopjE/uFnLXyUhrfg5WCgFFWhNSp9d8HZTKxg
 wxEa4acO
 TSNZzUrp4Zmo7U3s2kcvvtLxdsddNJQuFa+hLAaDTK7adiIAAIawBJ97r1hBVGxjT5/rSVxmB6cH6Q2IEOAPMEDp6Tzi+8fWqfWl/7VYWQjQyxyDvnanKl9pRuek99KP2VAibmxkfHWeB6gx9zU8/mtKmDrdJT2zhYjeXP7swM+J9RE2/Y0sVTer7uR5RCOUxV8Zu+WHBzglerMvg6XO5SN4pGzNOrCg+IBoY72pDCp6eDRDjHI6uWE/+6s7UTBTG9zkenY6VwvobrRo8B0frMlBs6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tao Cui <cuitao@kylinos.cn>

The legacy cgroup v1 memory controller has already been moved out of
the shared implementation at the file level (mm/memcontrol-v1.c) and at
the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
per-cgroup state, however, still sits as individual members inside
struct mem_cgroup, guarded by #ifdefs.

This series isolates the deprecated implementation from the shared hot
structure: all v1-only members are grouped into a dedicated
struct mem_cgroup_v1, and every access goes through memcg->v1.X.

With this in place the v1 implementation is self-contained: its
interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
its eventual removal becomes a localized deletion of this struct
together with mm/memcontrol-v1.c, instead of unwinding
ifdef-scattered members across the shared header.

Patch 1 introduces the substruct behind a transitional union whose
anonymous side preserves the historical layout, so the patch is
semantically empty.  Patch 2 converts the access sites and drops the
anonymous side.  Patch 3 documents the boundary.

This demonstrates one possible pattern for isolating deprecated cgroup
v1 implementation from shared structures.

As a validation detail, this does not regress the layout: the member
order is preserved, so offsetof(struct mem_cgroup, v1.swappiness) and
sizeof(struct mem_cgroup) are unchanged (verified with pahole), and the
generated code of hot paths such as mem_cgroup_swappiness() is
identical.  Build-tested with CONFIG_MEMCG_V1 both enabled and
disabled, and boot-tested with both a v1 and a v2 hierarchy.

Tao Cui (3):
  mm, memcg: introduce struct mem_cgroup_v1
  mm, memcg: move v1-only members into mem_cgroup_v1
  docs: cgroup-v1: note the v1 memory controller implementation boundary

 .../admin-guide/cgroup-v1/memory.rst          |   7 +
 include/linux/memcontrol.h                    |  74 +++++------
 include/net/sock.h                            |   2 +-
 mm/memcontrol-v1.c                            | 122 +++++++++---------
 mm/memcontrol-v1.h                            |   4 +-
 mm/memcontrol.c                               |  22 ++--
 mm/swap.h                                     |   2 +-
 7 files changed, 121 insertions(+), 112 deletions(-)

-- 
2.43.0


