Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E831C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67E76B00E0; Tue, 30 Jun 2026 07:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C407A6B00E1; Tue, 30 Jun 2026 07:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D526B00E2; Tue, 30 Jun 2026 07:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 937436B00E0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:26:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 243FF1C1601
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:26:34 +0000 (UTC)
X-FDA: 84936351108.19.ADBBC34
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4D5DCC0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:26:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DgM03IMw;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782818792;
	b=AH9gngLf+6ZPi4BlGKoLKUnsiUfp3bQTyhNnlYLm/KNvlk2y9RtKLct11FyvE1yS6VSAOi
	1YRFGJ5icAWtiSQwhWTD3ZsXhIXY5TNbwjRjn7p6pEEkDPwY2SNgLvQadd2HubjGwWuvfk
	qzWBwlRo8KNsCdw2r4kkN66KeD8lslk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782818792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FedLfmQ5jQup09b0jvVq17NcnfWVfzz13Rawjxlqaw0=;
	b=P83MW1g5rzHsNKGjCQBopOGegUCDC6yCCqjq4RdqzTjHMwVvxfOZNdFODKX7V7eB2SdCIO
	O7ACxJcgrGpOeZlZg1xsvLEeDxKgJM2XJ3QWxu15Zds0YPfPAtyOce3bFCthovQ927ZZvf
	kb2aAjASlv7bJpKM8TwxciLJIqzuE+Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DgM03IMw;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782818790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FedLfmQ5jQup09b0jvVq17NcnfWVfzz13Rawjxlqaw0=;
	b=DgM03IMwPfYvkxpS+yWuDb8XUVmz0XITjkiTan3sS5+RXSFBQGCSG8HzCPkAeeRvtYeUxk
	TdiSmH09BxhKECRq85Ph/eTGMpHCKepbHj6C76Rah+Ous+orL7H43PDtMthsj+qRrHHnTP
	Onp97M+PlxF36vSxEqMhlRqi/+GKUMA=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	tj@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 0/2] mm/vmpressure: reduce CPU, memory and code overhead on cgroup v2
Date: Tue, 30 Jun 2026 04:23:31 -0700
Message-ID: <20260630112617.1198623-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: gepzisq6gc6babqwxccmbuu1ky3g7c8s
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D5DCC0002
X-HE-Tag: 1782818792-786993
X-HE-Meta: U2FsdGVkX1+dqCkpR/4sUDQbu598zBumU1YolgJM80rIt9gNyzG2o8b0YiLhFzeeJCT7hFIci7HvFyLXlPC57wMN7MSObRFYJ4CgJfpH4BvLeVzveKxRQipiBlrPnuQakS8UD9yREa9B/s2gyL/dsXPo3sqQipcmnaLvQqipP7N+F9qpUZH9Es0/0Ev/laohwczdMWdBM/TTmdKtw+BuzDr3jPWFvTkOnb3fcr1ataX1Ucnl4X91eNGn2O3adE5QP+R+eyRWaW7IH0DyJMtLCRCafyHQCFRPoEOajOdwI1Y5yLDFlPHsKaQ6ZRHRJIwh89Ul4vgGd5H1Hz+o+pjF/8GJi7sq2VWe7cFZIn6qDcfbIUp6uqne1G5YHYKpAHYnUlS8cdTr0N3kNIbebDn60VD4Rn5CozVFg9Afjxo3k1Gk0GB7aObRb1e9RknhKCnVoCHqz2AU7M4OvkfPqkfNS6Z9alURqMToMgsiu8CDmvuRZmGcAVKKR5Mda+sqjM7Y+3Ht5pcyvh81mpLaTxr/0XUMoV0rCH1EQ8MarmnaVwO+L3oiHxU/nuz3g40vF2uiHzDpGeVX+INz9Rr8pObbOrD40jL/b/xZyjZLmFqu3JEgLRU951RIzLUMYZn7Qo9aKE1Ylvmv9RtvYxHDl3UuYp+COrPrv1zBMS9iR7TqaUoDGXqkYKg+dZDol9KSf5KgKHLePuqhJKf4emWYkEjKuF2TazZVBe7n5djXqt16rsdr4WkRS1xLFP7wr1fc04sKCIEQHc5ESgaD6bXKZUzoKArGe++iX2TeXF1/SuHs+Sy4iwFCsAuh+gXzY53o40Vsk/jIBcprdq4bwavxIFWMluJwEj73//NVw17N/gEyAbyjM+6I3vfCbjEN7HawWG83gWvUftZamJMgrKp+NoRCv3VtjDJ3lVvxTKQBo/64IQe0OuRjaAY2IlA2f7bL7itnt02GovcU8L8RyT54NNV
 BALDZnKC
 MwrPl4X4b4M7j6WK7+Fc6TqOJEJ+JciY7MX54p5TpXrmZyy0Tlbu5qph8xp0UWUaNIpH5EDP00foff1WYw53u/duMpEsLnlgKDuobV9Iik2SlXuAt7MNVTTOhTUttgPl4z4p5XLYd+n+EmnqyuoE0U11W6z4MRYdDSyBKfGmtvRjJAGFD3L2+rZMMqq7brjtodlSvRU1SA2q1KgDNZK8XU6zhFmCWvUOAQJvc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vmpressure subsystem has two distinct consumers, gated by the
@tree argument:

  tree=false : in-kernel socket pressure, consumed by TCP/SCTP. This
               is cgroup v2 only; v1 sockets read memcg->tcpmem_pressure
               instead.
  tree=true  : cgroup v1 userspace eventfd notifications via the
               memory.pressure_level / cgroup.event_control interface.
               v2 has no equivalent (userspace gets reclaim signals
               through memory.pressure / PSI, which doesn't touch
               vmpressure).

So of the four (hierarchy, tree) combinations, only two carry data
that anyone reads. The existing early return in vmpressure() covered
v1 + tree=false; the symmetric v2 + tree=true case was falling through
and doing the full lock / accumulate / schedule_work / parent-walk
dance, even though the events list it eventually iterates is empty
on cgroup v2 (vmpressure_register_event() is wired up only through the
v1 cftype "memory.pressure_level" and can't be reached from a v2
memcg).

Patch 1 extends the existing early return to also skip v2 + tree=true.
On a v2-only host this eliminates a contended path where reclaimers
can serialize on a single global sr_lock. bpftrace on a 176-core production
host (cgroup v2, 285 memcgs, sustained reclaim) showed ~16,200 such calls
per minute with tree = true.

Patch 2 follows up with a cleanup: it splits the v1 userspace eventfd
interface (struct vmpressure_event, the events list and its mutex, the
work_struct and its handler, the parent walk,
vmpressure_register_event / unregister_event, and vmpressure_prio)
into a new mm/memcontrol-v1.c built only when CONFIG_MEMCG_V1=y,
behind small no-op stubs in the header. mm/vmpressure.c keeps the
shared bits and the tree=false socket-pressure path. The size of
vmpressure.c goes down to half and the code is much more simpler.
The only #ifdef CONFIG_MEMCG_V1 remaining in source is around the
v1-only fields inside struct vmpressure itself. Memory savings on
CONFIG_MEMCG_V1=n:
  struct vmpressure :  112B  ->  24B
  struct mem_cgroup : 1664B  -> 1536B

This split is the first step toward eventually making vmpressure
CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
(tree=false) cannot be removed today immediately: PSI is not an
exact replacement for vmpressure, and switching networking socket-buffer
back-off to PSI may regress networking performance or increase memory
pressure in workloads that today rely on vmpressure's hysteresis. The
medium-term plan is to introduce a PSI-based socket-pressure path, keep
vmpressure available for v2 behind a defconfig as an opt-out for several
releases, and only then drop the tree=false path entirely, at which point
everything that remains in mm/memcontrol-v1.c is the whole subsystem.
---
v2 -> v3: https://lore.kernel.org/all/20260629130042.2649505-1-usama.arif@linux.dev/
- Move the cgroup v1 code into memcontrol-v1.c instead of creating a new
  file (Johannes)

v1 -> v2: https://lore.kernel.org/all/20260606114158.3126210-1-usama.arif@linux.dev/
- Add more in commit message about future plans of vmpressure for cgroup v2
  (Shakeel)
- Remove unnecessary return statement in vmpressure for v1 only tree path
  (Michal)
- Rebased onto latest mm-new
 
Usama Arif (2):
  mm/vmpressure: skip tree=true accounting on cgroup v2
  mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c

 include/linux/vmpressure.h |  46 +++++-
 mm/memcontrol-v1.c         | 292 +++++++++++++++++++++++++++++++++++
 mm/vmpressure.c            | 302 ++-----------------------------------
 3 files changed, 349 insertions(+), 291 deletions(-)

-- 
2.53.0-Meta


