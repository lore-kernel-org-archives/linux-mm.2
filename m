Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054B9C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 03:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19B9E6B060C; Thu, 13 Aug 2026 23:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1541F6B060D; Thu, 13 Aug 2026 23:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063186B060E; Thu, 13 Aug 2026 23:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D426D6B060C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:30:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D2C78030A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:30:26 +0000 (UTC)
X-FDA: 85098447252.13.B697AB1
Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5283D20002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:30:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oAPfvslq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.126 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786678224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SsQKvqqv9lwxQmy8bH/1T7isVoCT/trRlni0IzeSIvM=;
	b=JCKBjVmZgVimSYv25m/y2oeAyxXR+Ic+s3y1JhkyyUSs0cD1QKSCGZNMykvHoY/1b8Tx2m
	Rmq0DRvrMq/4TKav+XggH0IKCzUunAJTiafawlKAirrmWONdZFhtgo2XdegDn0SyPRlizD
	IKwHpbYFrIsQPhYauFNpVwuR2IpyLFc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oAPfvslq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.126 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786678224;
	b=QXS9rPqUw3gM3xRFo/QQymiJEol4Lxs550OYhUYp3sSbqNiiUWwSaql0+DFrn5iwQY4q/3
	ql+/eEh7XMpyN+ZSltG88W7pX7mUMNej8hZ9dxcJwvhPNTkW96U+4nMtyDXUO1pBLnQD6y
	fSJfYLcHZ7h+jHOAftDUr1a13+FUsFk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BcGgUmgJ5bToxf4lyEoXBY/SvuxrW/zu7KIJo4jPTnU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786678222; v=1; x=1787283022;
 b=oAPfvslqk7lsFKqUtuWMXuZ3cDcQPOnHWUXVRVg9sGTEbh8rKM++3vcLQvCN4wCbvnKmnj7L
 6drCx29caTeFSs+vCHjMHbl4u/XM9aJlb8JPHf+OQatlZDrwUfeD8PYHGSqfw30PdnzcmpCGY/u
 h0a2M3nouaVf2FztValnqbcE=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id bae11645a998b6aa;
	Fri, 14 Aug 2026 03:30:22 +0000
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Finkel <davidf@vimeo.com>,
	Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 0/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Fri, 14 Aug 2026 11:30:03 +0800
Message-Id: <20260814033005.2481920-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: enxe6ypomkpmt539mdyqaoypbz8e1z36
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5283D20002
X-HE-Tag: 1786678224-990960
X-HE-Meta: U2FsdGVkX1+0HXqnkhWRP7R6McqQ4hPNmZulAwpNKwaaYI5dZc1pETyHqh7sXMW1FmCFj5DfFLcMdazFgn1OrVPqMMFNd+XK71IFz6gtaHN62OsJn83zc5F1+RPOzxfelazJCR7W6F1dG62KrsIeQCK6KLDGMPpMy6ep+mzMYhd+lh7TAR490zXeXOhEo7QPGDd2WZSiVpv23otKAwDeFKEyRHe5uWq51Xu4aq5Yq7YYIjyh27edFzG+w56OF0SsoRe0AaFO2mR+WafoI2nqZpLcItnk6gtkNgMpRky9YQP4x1My7BniIygWs+MbDQj8xOI8nsi+5j9WbAp7cRKaD6/Q1Hx+zhM4W2AFjnLpWdDWBb4JlS4E3Th/Nw0wi8la9DzsbGrT8b5faImtXqK5zST6hA5sEBVPJFcPlYib1an22yNACZ8uatpGroMyGeEFCAjGC2/NUMvZK+R5M7h4pzxY4LWtUpyATDb7UTKP/ZXhuQo2SJFJHX6RU8nWDLfPuvEllKvLltKkL02O5YZhMTMiwUiP2SRpaZn3tMtVoXVPGuGxD5uZykS/pKZ9SCWYSM75xWXNOAUCCsck1ajSuOAFHsbVTK2QPgCPhSayL5vzCzarVANoq7p7sKtmpmpr7EodzB8mmq+M0equ+okm6DHdJN53o90241njO087kceh2KqOX1gyacCz+/BigqaRLNMMX+/VS284e5TMAkGSBfQu2VlyFClHfPgA7YT0eWjICmIIZbNEIg6b//TuSvalpig3V5qoCI2e57e9pTSjEEAU8yC0vQTgsw5IuGXdZUBv9r+BEN75+BKlIlJBrEkl0uwH6zKNpEFE9zZFgYGQwM42eS0PReO+zXmO1aCyQ/cDcbdZZcuJ9Ev6+B4Yv+DrWg+1/3uHuhCczL4Jdmbi35KNJbXQBP5/jeB7h+e96UDs9edbbr67BlWqBjTOfjSAlHQtfj9O/1wCBu8Vh7O
 kzAWJ4ml
 ePnW7qEW+XBXNxQ3HrkIZed3n3tovIKPx5W4zL23Ysg7RdtMDPJMRiVrWpR1vLVWZgAXLt297uzoG+00P0IvvkkYuO8KmgqCOcq+RNjsHA52Zd8j126iB4b+y9x5rjOzI2S2jrfgop4r7FOOM3dODHAACoq2Waplsilc4RszUZrF4nL9NhlaKhJcRBBHc3qzyvgO6wsnDX225DLg8BcXjBo3sd82jXvUNzKjpDk3n0MiH8e/Ul9koCpgbSUHsqibPZi0Bw5PxvbkIqB46ByCaCfs7iQuNxgs8mRusm36+kXcF1hfOi9VbfMhdvOBQmK79AO1DuWHoOOUyGUY4vpMApgilCxXubRcKnIthlkblmm+z0UUxoKFElh6/bIKCLbnQvd8tFpVjLzPgVE5+4o2J8FVEVZQ+MHxDUwAU8xq49IUog/rrTEA5c0dNbG0Z3FR3gmB2gTzYpSiCaMKBEnIw7dzwPBOnEzqEaY3KtqRWWQ8hfOyVjYaEjiokZIZdAQ3ItzPf26si8PaTeaS/SIiecGp70pFYj6a4TXmvc7PwK//NLtP+ESu0m/rOFdDspr53V2peHDrvOvdgi06lVZqVXTGNvHlyl59DgPEPwfVxqYnIb+sjBOjq+SVtGw==
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


