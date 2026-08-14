Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E0FC5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 01:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E92B6B02D8; Thu, 13 Aug 2026 21:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7706B02D9; Thu, 13 Aug 2026 21:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889E06B02DB; Thu, 13 Aug 2026 21:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7546B02D8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:29:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95C1340224
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:29:54 +0000 (UTC)
X-FDA: 85098143508.13.68B29F8
Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68AC01C000C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:29:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ysodu+CX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786670993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N5QXTXZEMhKvytncrBdE1Wg4B3aKB8YtUm7KPoentWI=;
	b=Lq5bOKekzPFMs5zOEqzhI/uKA54V6f9ocHB+ROd70w1ph6j3xaz4/UXyAMHeGMXe3spFgr
	MkltKm9QUnFGZNkUeaGpnXRB+zwTKQXYnuq7MabobEYiujqAFTnWzFRbcmdq77XTHeHENe
	xu+ILateXMI3Nl1bqipVkI3NJR9GUzI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ysodu+CX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786670993;
	b=uXqBp+uc/Y0SKMhT+HVxQgPkAkUdkOXmeLLUtc8IyQSdUTEWpRNBwukW2GSUs5nxfxtgq8
	pjXtuIc4ymfD94lE2qUdKRbnA7LE1bevprdRHfBwp6o83H4qawABKWXM4OVkq0b4TLsf3y
	JU1JkU8iEogaQbmXO+/KyMljDVt4BAM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ek42tK/WchC2oA1PHIRS4QtmcmVuTZv2hEePGmd7yqE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786670990; v=1; x=1787275790;
 b=Ysodu+CXDPXTiIFLN2mqoN6q0PkiQFKOuSyzCh2Bofp2hRs3BLHSVhrRvFQsb/AVrBaFZZAZ
 VxqQbgTuBdQzlX6qNGdimqMwh2xO2y/4gxFuHuvjcVSy6PToEmTQcZ+ZOFu8+JLSQt/mi4Xxd4M
 +/JGO38orJD4TksyYyhGXEHE=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 8baf117ec7468f79;
	Fri, 14 Aug 2026 01:29:40 +0000
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	David Finkel <davidf@vimeo.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 0/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Fri, 14 Aug 2026 09:29:22 +0800
Message-Id: <20260814012924.2388613-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mo5xopdabmxo7nwqaitgayja1b5w91n8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 68AC01C000C
X-HE-Tag: 1786670992-795510
X-HE-Meta: U2FsdGVkX1/hbLNJGablxZo4vGNOxU3KCPDy0vbO2QqyqElVjRJI9kZ9K3x4ZIjiqdQX0fjyq/6OpDRv1SUB6V1NQ71Ot+STRra0dI9g5SKduvAmJ2HqrE4nscoY03eHLVvLVVFj/FDnHPGtoW6XB0JRsaF1XYriCj0bKqapZQyM2FgKm/Id1y/2qf0tFP7iDv7B9GROZd8xWbWdKwh1HYhpje6dlrLhgHC6tAq7amD/10NpZXMOqgi/iOp6AezxOHawSADjTCZ4E4wdan3hyCFuO8rs82fv2Rq+tj1nvCgQWBXbZ6pWetEldk0q1+AWlD5Mu3ZhFm2psluIYQkBkC0OADLHyLU8T9gbwM3pPHQ9PmUo4tYNpaMtwKstxqwvdLmqRmIC6XflFoifz9NghQ1IvGLM/YTRV2pjHVa61gJqKpgnZALt5TORvfEgk6t0+4vCnMJ6iS+8+K4p52XzEp/oztM3yjvgIJwLH0jjuFV5QlhfWJqBFbU/WnPah21vrzPffqwnEe21/7fDlgkyeVZoV1dqw0JztnFciOtRw+iUkR1O0aYn1FrLosGuk03g8SwSYsGKf1JDHiKXd0D5wNxEBKW2bNUyVE6jCBhgbuYPuf9QY6K7NlcsqImD8PBtqERfNisyeg+4K0B1PVDtQJ4UiUz59T+SvG2Ba0qaCHRil/gk6jbmzNZGuwhuxW3XhWodnSOvUWoUQQVJLtbQN4psmhifNAqtstsikPYzp0KIUj5krjofRGHs4XyL+5iULBoWm+dKpxNtRctDWqoxyVqCMLdVTD60I5ecK59zhuhyKXoUhfNjwOS7suZO0Br3b3j5015DH/itUPg5MrQC1Ivhc/960BsOf7HGX/XAPFm65Qy3APfQiuN1JEoaw3405hJbg1zOiw7IzoPPpoL6J4epIKHW6vmyc4avPIkeUOnt7lwjtt1lzXP8HkID+mVetnWS1OtKLO0DgsIetE3
 hYVbC3/+
 WoMBUQT60NHQvCNHWA4BcHv7o23mW3oNpW+ug5Ai2QDKGBOIOFuWlQxjPsydElOwPDF58/Kf/zaRPVebhRpiPtx9Y2OXZ1TE6gF/kjIuyShVtm7MYccIfAmP9rsGrh9Kd/FkN8kHAZvvfdvDoYlJzP4rdrLmYTvnhj3RHK8dIQgc5P9ArWFX3VL1IhYYHsiMY9JuimhV4YjADC8i9IULnwJ3C71QrSPPT7A9ZNpxYawA5kBMs4ed0eMOwjdXwrfYB139+bAhSX04VriF70llHAv1MPHXCfsUF235aEhEJ7UdQK+kcKVrDxXEwoXtA3+dUrkZfBAlrnC3yOW5oxyoag7EzfsaLZgL8IL3pnc4Bn1HD+a+0/y4T7Ikn1GoNzn/O/Yh01dPCKuas1lO5fmgkWKlv8AVZ3Dk30YGRaG9ZySW+utEQS7iPtqf5ltR/fuG3XsnySmjWqzA+53m96Ru4S3Cj8KyBVASxJ0iTKpBf4rkflV/hV0HiVSTpgwIhVdkbZFzNIlagmcVKThnKRh4PXKiuzS5HNgYzUsKqvtlRTStGdNevL5ek3UJqYCkCny891mVu+q+WAjrOGR52HeFVQewa9zd76GoVab7wjO7k1RVvAdmcm4HGs2aEBy74TAMRy9hIHlErRPiew28H48WDEnAnjw==
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

 mm/memcontrol.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

-- 
2.34.1


