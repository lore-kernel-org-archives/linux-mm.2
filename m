Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F26CA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 21:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1AF6B0088; Sat, 10 Oct 2026 17:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1F66B008A; Sat, 10 Oct 2026 17:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8766B008C; Sat, 10 Oct 2026 17:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA00F6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:10:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38EFA16060D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:11 +0000 (UTC)
X-FDA: 85307959422.30.DB7D5B5
Received: from mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf27.hostedemail.com (Postfix) with ESMTP id 206A040003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nZYB7QHr;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791666609;
	b=CUowuTw16ant3lZMFTSW0wtnb9WnPghTAMIBgxKWUHvQEjLzeK6PngOrBP9GFkxgZbxKJu
	TH6LA9KF8SfTKMngjI/9MhJebbz7p8ynMUy4Q3lZQbf0VyT+7FCwlpT7w+Q5Z4nF42A3P9
	4SLilJryZYKf1kvPDxZNxNhyxzX1j2o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nZYB7QHr;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791666609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q3QDuXbgPrLO+XvE43F6WGZoWbstiwD3AbZeIaG3CZ8=;
	b=PzjdLMRvu5g5XFpt2i1rWYr/Wc0jFnriLEupOQiueRV7ODptWS1lr/BDj/eI66xyX/v8Bt
	2SEG5cvnceTPJwKJ7rDy/hLCJBnxk93KTBx0+6PpR1KRlgl0KQd7deeFN3VBCY6cJyvR5w
	DcJmOmbNjhOnChakG9qlb5utdzEOK3Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R6hukEq+j5VBimksOBhczcPosF9ZrdYYxIc4MT00GpA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666607; v=1; x=1792271407;
 b=nZYB7QHrTFjY9naZCt4x788AaOV4ZYrKtZXUVJmqXtLQCExPfsVUFTveIVQNg5mg2cnGfZIQ
 KouCV64llHWXdSt3oxBJU+sBEHKWwEWb7V0qZQFuNDWDkC4PL9gBRogZj+A67N9frD4km2iyvXH
 R/sE2NdB2ruvkOdvRS9mhIh4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d8c3c3c2c6b85a0b;
	Sat, 10 Oct 2026 21:10:06 +0000
X-Mizu-Trace-ID: d8c3c3c2c6b85a0b
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH for-7.5 0/5] memcg: clean up memory.high enforcement
Date: Sat, 10 Oct 2026 14:09:52 -0700
Message-ID: <20261010210957.1350874-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7cwiiex7b3uiun1qxefarmwa37634b44
X-Rspamd-Queue-Id: 206A040003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791666608-799264
X-HE-Meta: U2FsdGVkX19ycJuXRs0FDy+2JfJ1w6Uom7TodvPapHZIPYh2s2AXrILMkw+V79VUTg9rTCk0nFPKtu2DVmBDRAUL7aBtnkGa7LWEGptqK67Ky6UPoXmRRsrfSU30470fyYzFSkxTvqRh+FeRo1Lnqy4AxuXoFndFI11wLtb4LNH1yOoJ/ohzfZj8HkN11Jcp6ZsqVrW7sdad0rglqmuISD0d2ace5syj5oP6AtJt6pXpl3rWWlO0DwHZP9FzXgpGwte0Ennmj1qN1m71nBMFyUEQmWd0z8doEC//dEsxFdgaHLkCPGDNeo9tbHEx/N5Azw822r1gJad9256vwCAVzbpC0aI/uYIw8e3tnCtYhtSxKb1aQS7WxQLiElMO0262s7lTZnWJeG0Hr2RgfG6ftirL6JzhiZf8KWhRqdRztcuu5rXRzsBlWpY4LUmhPDZQEZ+6zaAbz68gjwhFSXUHoeWwuSfMxAr6I3ZNiK4WURBo88h0EVqLDkAoj8QgpjOgg50FIcquntn6oyl3RjRNlO/o5YyKbVPNXJBX8KNVYZTmlwcOUDyx0+AbHWMaP1q1Hf+6O4hI4APHXaSAVPJMx4ftis5t7EJe45SDfcAQ5aDaZZaO+/CzXYrRft0DT33x0hzcPWmbsW0JJnc7lt/Q0Zdmg5onPb3wkvaVcd62Y9vG2h7lglmXEK1zO173le3x73bZ0jb1hntnXb5Vp8PHCBKGw5952eFUq58yL3x4OuW1Ih159A9/gW5uyobLX+8eBDI71W1lkRdBvFmxSXpfK3lbEgTaA1gI6G8ZCOujbaSYjenwvEGInN5pbv76P1P9/M3wCZmqjYTV1pbdCNYWV9HECLoC0hAtKpwd13ixvTrSdIygmOSAo2TSCSXZgYglYrHDYiiGMW/Zi/M3JbFFZACAbho0DQxNFmGSJLcKUU57qMIWBxGpeuRevi5DwC7rw3sFfae/s7AeR8RMl47
 L9h9miBM
 M8bYES9KzdyVFGH3miOFf571J4IeQ0gabh1qUSoXI++CqCpKMekwbS1aiWofgSRBeZbPhgrQklZRD4Krc4OeBU2s7+XFg6A32Rbp9TzOa156AeVrvZb7uWZ6OiUFmZDW6Cd8zDBYMjR9lS+u1yCMcUxnIDLQMqpqaTk01u7+6/AbzPFNz/6nMyPNj4CPh75stz6GlkUjKxQIdG5+OmGTod5GhXebvlqgW+nK1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series cleans up memory.high enforcement and uses a worker for
kernel threads and remote charges.

Kernel threads never return to userspace to run deferred reclaim.
Reclaiming and sleeping during a charge can also delay work they do for
other tasks.

Remote charges can go to a different cgroup from the caller's mm, for
example through filesystem notifications or faults in another process's
memory. The high handler uses current->mm, so it can check the caller's
limits instead of the limits of the charged cgroup.

Use high_work to reclaim from the charged hierarchy in these cases.
mm_match_cgroup() identifies charges outside the current mm's cgroup
and its ancestors. Local user charges keep their current handling.

Skip queuing work from PF_MEMALLOC tasks. Reclaim can charge memory
itself, for example when zswap stores a page, and high_work must not
keep queuing itself from its own reclaim.

This is best effort. A fast allocator can keep usage well above
memory.high. The worker paths also skip memory.swap.high throttling
and its high-event reporting. The memory.max and memory.swap.max checks
stay the same.

The first patch moves enforcement into memcg_enforce_high(). The next
two add kernel thread and remote charge handling. The fourth adds the
reclaim guard. The last simplifies the scan and comments. The first
and last patches have no intended behavior change.

Based on next-20261009. Tested in an x86-64 VM with loop writes, threaded
NAPI, remote faults, notifications, and both vhost worker modes. The
remote tests kept same-cgroup and ancestor charges on the local path.
An incompressible zswap test queued high_work from its own reclaim 163
times without the guard.

Shakeel Butt (5):
  memcg: move memory.high enforcement out of try_charge_memcg()
  memcg: use high_work for kernel threads
  memcg: use high_work for remote charges
  memcg: avoid queuing high_work from reclaim
  memcg: simplify high limit handling after a charge

 mm/memcontrol.c | 136 +++++++++++++++++++++++++++---------------------
 1 file changed, 77 insertions(+), 59 deletions(-)


base-commit: becb95e45ef0dda9ffb35156d909d3da7a2789c3
-- 
2.53.0-Meta

