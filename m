Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B24ACD8C8C
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 11:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466AD6B0005; Sat,  6 Jun 2026 07:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D986B008A; Sat,  6 Jun 2026 07:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A506B008C; Sat,  6 Jun 2026 07:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2627B6B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 07:42:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA49AA0439
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 11:42:15 +0000 (UTC)
X-FDA: 84849299430.08.DC88038
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 038614000B
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 11:42:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UwI35iNn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780746134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LXjmm9+ZvSlFJvfC2SPtLS5CK8YMB/c2K6dwL+Jj4J0=;
	b=7tPoKVp8ah+FADC+8iCD4MqmPnxv6Mwk4Ztaj/lFXlgIVO+u5JaaXq5aLBHk1yGF+OYpDE
	E2utz8SCxTtd+6blO2y5V3uPIWJ4QSVBvYyKaRya4VAiyRYYmzOescgdJQXhtdZd2tjsNl
	3LdWnWhcWsVqE6sbpXkQB/uxV+bYII8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UwI35iNn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780746134;
	b=Oc/31d6u6BTrf/CHm0nYu/b4ja8WTrCHmZjga7QL35D7HYQS+0FqFOOwS8bgIYnts7GiKI
	h0InmjYVzN7npGjfCqBPc+xPQcZ2UfmgcdpDBsDyo5NeBtKcb+6H1KrVy1qgWqPgyIBUtz
	5ryWeURRqUg10qD/PskmggZ4/wBYQ3g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780746131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LXjmm9+ZvSlFJvfC2SPtLS5CK8YMB/c2K6dwL+Jj4J0=;
	b=UwI35iNnA4SH3IlinQwmGId/xrYwI4DKBtBSgf4Py4hWUGiO5ZRk0HFKOXfWKce1OzuaG0
	HOCulQNOVifWQ/evGv8So4wJT/rCMBmTyyG1fxjSAiIA/vfNlSi7TufIsKkqn9Iu4WQx2P
	s52pEDBcwizSSZQaTC479XHAsP/xUCM=
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
Subject: [PATCH 0/2] mm/vmpressure: reduce CPU, memory and code overhead on cgroup v2
Date: Sat,  6 Jun 2026 04:41:32 -0700
Message-ID: <20260606114158.3126210-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 038614000B
X-Stat-Signature: ec18owkhocynmfsjhkgbjuxzpgoxpotj
X-HE-Tag: 1780746133-944552
X-HE-Meta: U2FsdGVkX1/oy2muIiWccbumAj8gXVtzamiKykxkmpFHgApfQkGgsgt7O2qiPhu8Buk++1hyjPPte5OqRCrvzQwfzoHtvR7wtDFwKEGs9X+3EiPfS4v8o4vfffdJAyrbbsxro7j9CWUC/4PjzkUp/rzTdRWPzYHAPn6k543wXJBboPoHJ2SteY9IlVRZjJ7U9WwIYF9qzqE0ajqc7yB9Tz0lzw8ETyNI6lZGWbaQdhVScjxr9Wj9XkueWCZj+54K83GNGJdHRi3s86H+YQcb7D3rH51u16QCl9+fV5CX2nraAg83fF90xqsyLT4+iLDRshePZeirgoXcTczVfOSdwbjoJCFQacXg+4lJBqcYrvVduazTH0D20q4l1zPBHUWW4THqyIArzhMth5N6SdqxFWXFl5olm9Rgpmb3U5ruEd83lkdeD4xdKucnMbly1p+qkXUh/mORp2s/7zpl0vLLSuQZxVSnVBIhyPFHM3dDxGykk64Dk2DYkbB971+1+QbKXBM7o/EzejHqfU3XcxPPIQ7ERXcgKYF9zRHXEd20HiFIs8JJg35o7zRvXNJbJny5Qyz5/A/YX0N7GRz5RyTGKyOIQvvEQB6Tkmryd0nsAMMzp4YR+snT7jxfLv7d9JRraxkJlk8/swc8hid6HWjsZsLO0WAJHQ/0UqNIgVipwt9FeULuwLrSvxxxdbcIg5GDb/9Xvzlzk8czMA9JnN8iW4ETmHu+wSmGe/qACRyjPmCY8VWg8ClFvRLQ5y/3JVYlK87dAH3tYeyDFYiqTu+iAQqIqGNYGLqRegnlEe9fI34eT8590rF3+WqWPmQZOPJ1F/CWlmDEpEQtfPWxA+t68idDd3pN412BLHDaTc+8yd/gyxWGtI/A6ewLG0AqGD6Fytjn7Mowq4zPD24/O72K7rf/2G81AszU1Tk7JQCOP4KAnR+t/7TlgJb3x0oc8CrLPzXeIxEEaNb1+LukWRR
 hxePhLin
 9ax0/wrHZe6BnI8w7AGbP08VoX4KwxEe+Uu/l4bEhLJbn/2GEuJvrkdE33L73IaJkkwO3UGNKGsvWINYBhy55UtoCw5mqIDwK+Y94Bxc1tGzc3T7XmUorAY+aEixN9qKwNHN1q7gou8nvOPWmE2DBk+XuoWxNXcjNaUhVPggOLhBifiOQ/f6zDKSe4rT8Mj/FmA1H
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
 
Usama Arif (2):
  mm/vmpressure: skip tree=true accounting on cgroup v2
  mm/vmpressure: split v1 userspace eventfd code into vmpressure-v1.c

 include/linux/vmpressure.h |  46 +++++-
 mm/Makefile                |   2 +-
 mm/vmpressure-v1.c         | 305 +++++++++++++++++++++++++++++++++++++
 mm/vmpressure.c            | 303 +++---------------------------------
 4 files changed, 364 insertions(+), 292 deletions(-)
 create mode 100644 mm/vmpressure-v1.c

-- 
2.52.0


