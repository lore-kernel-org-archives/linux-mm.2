Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5330C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0D96B00B4; Mon, 29 Jun 2026 09:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71B86B00B5; Mon, 29 Jun 2026 09:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9870F6B00B6; Mon, 29 Jun 2026 09:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76A976B00B4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:00:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02DDE1A06C1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:00:53 +0000 (UTC)
X-FDA: 84932960028.10.D668EA2
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0F80C14001A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:00:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhYScBkp;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738052;
	b=j5HPW+NI7IzASHo89Ez9l51rM8qBfvA+uuIATcmFcYK4f8s2gK7XHLK7MRM7nkgDdB5LQV
	LMdQ4tHywcpXO5UPd0BLMad1QCdLR7KJ3DRT6rfPB52PX8BJ+6djUqG5Y/HNZKX7R+ilm9
	1+mPSX2yWm9XOwRcwElJR/gooKUeWxs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bymgERp/YFbwVBxVzPFXfDs+LSnZmVynKzWNDPQQDUs=;
	b=b0OmoFPtigi1XfHnokIVWUo/DJIpzqtoTkrLtaoKWVsCD/gZXZP7yhW30UKCkDaFXVKjA/
	E44eyxOFXUtfggvWPp3FFOb8R5OxxoQOrbCPBMRERDyhrEo31BJA2d5A8+m2W1wwokg+bR
	VpmR16Z/ycD4q2GPFuw06+IDtDPhdyk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhYScBkp;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782738049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bymgERp/YFbwVBxVzPFXfDs+LSnZmVynKzWNDPQQDUs=;
	b=PhYScBkpS+3gjZ3UnAmke9dWXpY17VSXA8SzjnJZh3XYFBt2diml52/3bsONtdCJX2Z3IO
	gGFZlyWXt6jw1gfKOoHN1F+lePE0FNBVsUL3yYK09EOb79m2QBYFJeK4/CszI3SK3zkBMt
	doM3b2Kc7q5rztN4Sa2S4Rz8mTfCz4c=
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
Subject: [PATCH v2 0/2] mm/vmpressure: reduce CPU, memory and code overhead on cgroup v2
Date: Mon, 29 Jun 2026 05:59:35 -0700
Message-ID: <20260629130042.2649505-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6s9gooqz494gxuo3f5iz99syxzwhf136
X-Rspamd-Queue-Id: 0F80C14001A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782738051-821214
X-HE-Meta: U2FsdGVkX18UqPkAEG1yKfyCqbV7uyF1fXARkOvQW7+4+3pRMGPqhGC8xPMMlx5P7/85CTcH9orF9cIHvLecHAgyOYdgq2/yYJfD/kjpTG6H7cCMy5VzJJy2Epctc224Kl1z/AIT37qg/usO+nyoLUVypCJ1fPnLd2cYg4TiVYz1jU7oEOIigatjKCjJ9uKPzHitpsKVjRNIIFTWPU2NactGKG26KottTuwoi9gaA+Vdftw2rLnC/m4Z7QiQxaCDj3X+Qv5qA01N6Amz3kuFf2BdzaZ/qUM6ZavScd6L4GqAuG74E9klUVCs6JF7bhLggBWQ7/NvXRidiKwpJ37HcH4RH4IqY+/5YFi2rdBzYeYjXc2blGLMoNK78h5I+0ioHyLpaVO/XUMQUXToUQb/llNfbRgdauC72brqzIdfk7aDzTeZqYejZjCoCweeSZQaOV7GTk6ZHb4YfOlznQqEJS6HDEUHuQepTq/BL6DsjVFlu66it3k1/vxAs3KTSaFfJgh6fWdIfqJkT8STgLyOkCivrIgz78maGaZHaq2C3VRQSIZ3kuPHiJtq73FouVytflbVaiVoBjdHSGS1I5A7MFkUByrkyttPoQkIlsAAErRywe4j1AGSvXcpONanYNegNJ1FuvjGXIeBd9TfIHJ/g5QY6iO4KHfkNuSWv7dMHG5vRq63+dFeqjVKeNWKxlHR5o8ZhPJTLSklM8Q4pGNEWGnAU9BGz1VOYm7xsVasW24M5JmOzekUNvPC/XFM7tBB/Zcf6UA1Vrx/TeBpBMehOJxAPu0l80uMU7Ddh6Buvcuhi9RK/i1bzMzp6UuDK7gG40SCz1dOhIBvt2dQUegETP9GP178KPgp4GMjW1EGVxLbejEbzQxHgrwOc0cQknK33/0I37fnvZ95XTEXPhc72qwFenkjB08O/Z9xXKW/bLxUYWXe+RaiqkBqXFRdYGx3KnPr7ebWfVWy/NQl+/3
 ir+8oxRr
 CvbZUDFIDKOOPA+CbDSTWg8XdyoiWemau1qRFj+c+mVvXR3MXW9PKcY/4AmfDI9Z7hwFJ/GUpgb7KeAtIqQGhABwCK6p2ZYiRXv+JrQY10Z72Ys0rqnFYN1pcb57wbxw7BHuBiTecHtvid8UU7pwx7IpB+LMTsd7w8VzCjcLaDk0XFQOUxefI3bYZGX2ngQi56YFmee9vUzS3yyYTJpt4ScXqmLr6se/6luhg
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
into a new mm/vmpressure-v1.c built only when CONFIG_MEMCG_V1=y,
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
everything that remains in mm/vmpressure-v1.c is the whole subsystem.
---
v1 -> v2: https://lore.kernel.org/all/20260606114158.3126210-1-usama.arif@linux.dev/
- Add more in commit message about future plans of vmpressure for cgroup v2
  (Shakeel)
- Remove unnecessary return statement in vmpressure for v1 only tree path
  (Michal)
- Rebased onto latest mm-new
 
Usama Arif (2):
  mm/vmpressure: skip tree=true accounting on cgroup v2
  mm/vmpressure: split v1 userspace eventfd code into vmpressure-v1.c

 include/linux/vmpressure.h |  46 +++++-
 mm/Makefile                |   2 +-
 mm/vmpressure-v1.c         | 305 +++++++++++++++++++++++++++++++++++++
 mm/vmpressure.c            | 302 ++----------------------------------
 4 files changed, 363 insertions(+), 292 deletions(-)
 create mode 100644 mm/vmpressure-v1.c

-- 
2.53.0-Meta


