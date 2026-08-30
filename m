Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCA1C61DD6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 00:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383066B008A; Sat, 29 Aug 2026 20:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3330C6B008C; Sat, 29 Aug 2026 20:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B656B0092; Sat, 29 Aug 2026 20:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE5766B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:21:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45663160134
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:21:20 +0000 (UTC)
X-FDA: 85156031520.10.8E09DC3
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F3C6180003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:21:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KlLBLmwt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788049278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SsQKvqqv9lwxQmy8bH/1T7isVoCT/trRlni0IzeSIvM=;
	b=wTLz1YoDOjyGNb8h26wBCEsXa0irQs0dTnZQ68F9QU2yaZpwhxoj9uAhB8W1BTxYz84TMm
	ok3pHCi/WDyD5RVry0Y5JokNHbEL10Y9jZtzg5gKQP6gNH38TQ4lPe28ro8N2ARwVB/nYR
	h18XxVkSehMoydHs9n6cbN/wkkClo34=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KlLBLmwt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788049278;
	b=TtxOLInAyue7jjMrJn4CTVatmjNxh/cIOSaOy/DCNJMktcGOlz2J8fCB24n99yALXb+Jji
	61i+pcJviQ0FVEBs2idaCzCCE6f9k3UE5XHYOjJ0gJ7gqXgVAWyztJp6NcOaEupiJ6oHaM
	ejGNuHJdQTjf+crzoAt50l9o1n8uYUg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BcGgUmgJ5bToxf4lyEoXBY/SvuxrW/zu7KIJo4jPTnU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788049275; v=1; x=1788654075;
 b=KlLBLmwto/gjzqlJIF89Z4XIEYQdlJ+FKtWtI+IiDMoEoLyeRB80gg+j0avYydWUvIDoB4iI
 pRW/+Z7bFvvh5TKOxi6acq67WBcOLkrSt1brFF2SW64B/qG4Qy+x1NK7AQr/Cni2HWJjqg60kHZ
 cU6yU3b8vPiPZjIeXIqWAL1w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 19d959b935d34d05;
	Sun, 30 Aug 2026 00:21:15 +0000
X-Mizu-Trace-ID: 19d959b935d34d05
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Finkel <davidf@vimeo.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 RESEND 0/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Sun, 30 Aug 2026 08:20:42 +0800
Message-Id: <20260830002044.1938621-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F3C6180003
X-Stat-Signature: btjhh6cu5thcar1ensz8npp8e7fy9sh5
X-Rspam-User: 
X-HE-Tag: 1788049278-150737
X-HE-Meta: U2FsdGVkX1+yMRZ7gCWaus/mpE1UgYXl1biMO38WHXvteCrwpn8jVcH5WK588WUE2rw/uuX0GYCXsOFcsWbVvwY9kzjzH0updUQ4fgg3lQMpAOz1Rf+WpBDhUH61zrkFDyBIm71q8lhUaqL3WmqwYq0d/cD3NB7SUYfJb4nb1wmTLAcktisoIJQ69RcQEotftx77MeuY6NcP6VNSgtRQVnVIY8jJc8XKVPu1fVQD0/p7jr5bMCUk7rDp83vpcmztBLrim9nJqNmCxQsXH5BSB5fZjmRDWaMiP2RI6QJJ/uvsrf0WbDbyjUnMmgmPr/pP7u9aI2ipO8kYx8uFUEVkcM8vCwyCEoGvmocnm4gCP0RYyx7moercr8/8/sabusu9Ip6otwujNwSooSsNOYOn42ufsTy64pQtJC8BLNusQqUrTNa6LP+GJDoS0gYdWiJ+q2hA9QB9bq8vDGkOA6x1HmsRo7KapMjUqP40VGKhQVxRe+l1wqt2DkXNvilZpfhpxKRpklzDdKgZfRMMY9BK+4rS3/XzTlYxLqARnCki1AD1vOnxRRQmb94QQRsH/MSm0nHhZ2Kyg9PY7ShPylEo2Y+u7vo7ggTbALAZqeKnO7NJC6Eg1uY5hZo1VBga51Y4VKzinups5ZI50vecpMMVVrXz1fnJIL1eGmuLw/B75g2HcVMyFczbWjFDqxH6TYsx7P/Tkvi5NUM/OVLFtCv7fVDeq6RyF7pLrZ9R7dcnNxAFYiqHGJWiwEFqHlxbGtujTRuHXbnJSEzR7J07nBH/pXewvPIlLUb3uYKnJEY2iRbFoucCLyObFTedjiXtJfzJwG0GYMNCDLsKqpmOHzlZihuO+VkkVLrD+Rt6WA+4AYPwf2a0Drx1kg0HBpD24awhAUiIlWrp8oYLFVL8A1ATloUZG983PbGd9rJ+u5xjvmt4VVlZMu5q7/p76KPnUJDzHxPZvQBC2rii8m3J4NM
 4q3s4sUY
 ePbWsh29Fq19IfHrugRxTPg1dYhuAdVqwsnXYVNWi0mB3I1xvgZn5aPVe5XOZjgeqd8POXQle+B0PuDfDPDMkr6ZpaeVZ11FKhWw/9lIrraRcdsPYr7wg/bZGx4iNxYwb72RyHI6lKpbevsfPaB5tDaZLupE63SkbUw7N+QbRiWut/rIv97Y0fRhsIDBHyHtiWaEpniuHDD5TTHOXzQu7C/dvOtzGh/Db6SIH3TmxDa5Rs9Dju2OMmnrQQAuhtKXBkbKphv1QkH77w9Oezc5whvKeoLY7GvcppzBatMg8afF01ADtSW2i5vc4GzPco1Hdb9c+Rd5SoTihaCiK+XJ6NEuth9cOhzoBR6bUY5ukhNr3Q48kz5e6+UrAEaURV74IwLN52TVln1y2BeY0fc85yPcsa48h8u+b0QG8ZhEtQpAB+lL68ImfajSP46aRX4SC1V39T2HzGYw5MZZ3rmCVFtJiPR1sbVJ/DR8MVeXxH0uJOKo4A+uwoyCAPXECucsTaN2e7KW2hC2oVryQlBbH4txWySatjzLqh4Ua2H2TwiiCiiqanih7UmDv75eNbXfTmK6xu+V1AEBxzwla/vuPbA5LVHxSnpxSbg0d7GeVI7+JePj1QY4aLB9Iwu5RPTmTU4uh99/vK8SxXCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The memory.peak / memory.swap.peak per-fd watermark tracking has two
issues. Each open fd is a watcher and reads back max(its own value, the
shared local_watermark); both bugs live in that scheme.

Worst case for both is the same and is userspace-visible: a reader of
memory.peak (or memory.swap.peak) gets a value lower than the true peak,
so a tool that sizes or bills a cgroup by its peak usage under-reports it.

Patch 1 (read side) fixes the race Sashiko pointed out in the v1 review
[1]: peak_show() inspects local_watermark and the per-fd values without
holding peaks_lock, so a reader that races an unrelated peak_write()
reset briefly observes the lowered value. Transient. It takes peaks_lock
in the show path.

Patch 2 (write side) fixes peak_write(): on a reset it stores the
current usage into the other watchers instead of the old watermark, so
once usage has dropped from a peak a reset on one fd drags every other
fd's peak down too, even fds that never reset.

---
Changes since v3:
- Switch to guard(spinlock) in the peak readers, suggested by Muchun.

Changes since v2:
- Spell out the worst-case userspace-visible effect, per Andrew's
  Go back to v1 [2].

Changes since v1:
 - New patch 1: hold peaks_lock in the peak readers (Sashiko).
 - Patch 2: floor the peers with max(usage, local_watermark), mirroring
   peak_show(), and skip the writing fd (Johannes Weiner).

[1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
[2] https://lore.kernel.org/all/20260730115314.1069089-1-ridong.chen@linux.dev/

Ridong Chen (2):
  memcg: acquire peaks_lock when reading memory.peak
  mm, memcg: fix memory.peak reset clobbering other fds' watermark

 mm/memcontrol.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.34.1


