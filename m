Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33B4AC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4312A6B0088; Thu, 30 Jul 2026 07:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1AE6B008A; Thu, 30 Jul 2026 07:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7786B008C; Thu, 30 Jul 2026 07:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 092B56B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:54:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91FA8120116
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:54:27 +0000 (UTC)
X-FDA: 85045285374.06.7DD0F8C
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7AC9B1C0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:54:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ltZxcP7t;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785412466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ti2bSmazGTeJeWuqEsKxELAbB2h/8DFLycOObfhZA2c=;
	b=15VmAH6ep/ArQx1OrDWEKOt/u3kl+QH4VzfgnGwamBDA05Za5ENEI+A/ekGtPIKtqWr46p
	ucsQB+BZziLXtZgs2XNKLHHGSmBwA+QP2dxWaFEU3h5S+fLerCDIII4q9ypAPf5KCVlQK0
	CmRZvjodoBuXeTjwJBtkDACk/r75pJw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785412466;
	b=CJKJrLNpnv6GA4dG0HE/aCp1GOw4w4bR5WgD9u08oS2GhoTevl3T4wPfdoDzGtMgh9lA2+
	ho3haqSaM44tqo82I4mJNKKuJepJw/p/MpweNvFpWK5OhIO8adXRgPGtMMgWm9UhJKl45k
	nE9NuZEPOlG/7KP+KMhhmkH3y6NXdns=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ltZxcP7t;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785412460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ti2bSmazGTeJeWuqEsKxELAbB2h/8DFLycOObfhZA2c=;
	b=ltZxcP7t3+OjBynxx5eUHF4NPsMADw77gEwHiFN27N1wa/6uj5b0KtDS09qnl70esX3g/P
	OfpcZ1n9roz4V4PhzDlvoAlEoque5p/Xel7rhYs3tlBwdc+xDsCo56T6y4Y0NrQbh5VrYA
	p0n+Zb1zGpsF+8rNSKmuYp3ZeaJq6fU=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Finkel <davidf@vimeo.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Thu, 30 Jul 2026 19:53:14 +0800
Message-Id: <20260730115314.1069089-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7AC9B1C0003
X-Stat-Signature: e4txxsociwkypkh74ot76fshxwgmwkjr
X-HE-Tag: 1785412464-925062
X-HE-Meta: U2FsdGVkX1/uGDg05RVcZAqA7drhdVBPdTtAzHBplQGvtLTCHX2e/krbwkbF+LK/MqLwPfWEJcWblHrjY7VjgNYNP4hTsXncYPpkAaQ0ziYIategMO+1ruSLECP5biiZDnJtsgLtuVHb9r7z+m50CqjPcNe11RPg2UNCEU3ZF2Ejhe9CA6YMt94BZpXO/5CFohCZeTX+aPgKHcrmBNBQTTEnR4bHQyyC4s5fnAu5/LzOEgPd9KbfZDwcIQUmYEZWBnGHwXWn43CotkFFZRknXaHtj9M9LAc1YuUeSp2QljXeb8zg48N2v3wzE8pSmRll0WC+EFkfbuc0AaX9Fyom3YbbsSCpU7m0PNgB8yDpjQZT+q9J2YU76rSvfcgOGmgV4yK62Hw0YajYk6jtUk7g2cmjJqvFcD76Gl/1Erb2XfyWOvmy/RfiLPydhzieYRjQ/dxPeSsEKrsa5MHmvCNeoXh7y/Gg2O5NK1ubb9kWYRaeMg5CemNWBWafU8ylm96IYqvmmUMmRTXk6/2ug5Z3xMDO+GWBRyWEZ8xOn4EBEbcKX/QAg8t7u5UIt0/LlY6G0aPRio+Ra6xlowAUZFIeD//oB6rMvxpxglnz7OuAlwGqkAhdvEvKUawemSHtLdpkJemUZ4Tfu4iLZC+ch8SXRxwXJE0S1N5LtbDX+ZnQyRpn0FromlcLvRnq81Ld+AhduLCPDAMMpLcCTmnLha3ys3no8eyBABX3CLAbjS5dYxVcjKHLSpV4qVlMbzfipvC4k3Be257tfjdIwOTilTMnSywjljVlyvRaTFDH9k4CyIZGKZZRMpl+aER53KLJqM6NjgOrCl6nPVZdEmt6zDd593IuMzlSlcNNNQlpmq25HM7It6gmPGm31FIT2e3QTuz+iv6lPqpbMq+eHTkJ9zT26FTiws2RXzPwKzPW9dOTrm7ReFcQmJcyF2h5bIOC0ztAtF29R5gTqA2mzrConxe
 FvJfnnvm
 iTR4Vi91j2f2+MOBX+pDPVAwEQhLPtP4YJNJgcFfSriZhzRUfD0ZyElqMkdpu/KrNQJFTGmvzRPxmzp/l8HuCSgIEWMxtx1iq7UCmkHLa0a0r+IisJis+qetLN9la4iejvPSX13zydvdj5YP1ADr4lUQueVjbjA9/j6Q4/Gn1UlltHLROYlEvIds1gJarTUr00mTDo5Ksm0gE42BvRQN9ulMgySsj4MS4QY0e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Writing to memory.peak resets the peak for that fd only. Each fd is a
watcher and reads back max(its own value, the shared local_watermark).

peak_write() resets by lowering local_watermark to the current usage.
To keep the other watchers' peaks it then walks the watcher list, but it
stores the current usage into them instead of the old watermark. So once
usage has dropped from a peak, a reset on one fd wrongly drags every
other fd's peak down too, even fds that never reset.

Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
collapses to 1060 KB although B never reset. With this patch B keeps
reading 410624 KB.

Fix: save the old watermark before lowering it and use that to floor the
other watchers, so a reset only affects the fd that issued it.

Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 60145aadfc5e..881e7c459c64 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4692,7 +4692,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, old_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4700,11 +4700,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 	spin_lock(&memcg->peaks_lock);
 
 	usage = page_counter_read(pc);
+	old_watermark = READ_ONCE(pc->local_watermark);
 	WRITE_ONCE(pc->local_watermark, usage);
 
 	list_for_each_entry(peer_ctx, watchers, list)
-		if (usage > peer_ctx->value)
-			WRITE_ONCE(peer_ctx->value, usage);
+		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
+			WRITE_ONCE(peer_ctx->value, old_watermark);
 
 	/* initial write, register watcher */
 	if (ofp->value == OFP_PEAK_UNSET)
-- 
2.34.1


