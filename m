Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BF8C5DF69
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 03:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C486B060F; Thu, 13 Aug 2026 23:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174186B0611; Thu, 13 Aug 2026 23:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089BC6B0612; Thu, 13 Aug 2026 23:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0E676B060F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:30:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74B8516033A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:30:42 +0000 (UTC)
X-FDA: 85098447924.01.8DE79B6
Received: from mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FCF01C0003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:30:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhFM+6dT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.160 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786678240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbksEIphrlPTdj3A5EBmd4yYCXV+2YLfz1r9gyFUC/M=;
	b=dlW2W1OsivxXNNMjiqU71YSXhF+l/aQ7ZzNr6+ax7z864lRlgA2RoJ8podZgQ2KllPGogV
	CbOQSgwi/Bf+lpukrTWBUFrlnjJLJTskcL59pLK5gAf/dOrBpDDcIEh8oAjvOTUtR8IxFx
	ofvyJBjE11tMJgxPBIAyz14ikwjTqbU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhFM+6dT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.160 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786678240;
	b=4W9UbssEyZ8pRZ49qvhxQNkNyrbvJy1RSjuJ0Rmnm6jNMkGh1rXfYJXUZcgr9yMCfEOmts
	CpmYm0JrKUiDCow3iPO/0pRbPoScbZqIA2tMYkvTC9XgRCUEzBWm5upLoYS2AWuM1TWUmO
	a9RR8D48P6xsYiQKLciPI00I9RDEw7o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GAsBrFVCIC/PHgQfkxgjYF3vPMw7obXhhWZeeIZbrC4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786678238; v=1; x=1787283038;
 b=PhFM+6dT7p4lQwnUche71QzU72QF90Z8EGC4k55nIrPazKQd45F5/TSFULDUnnmedxlV702l
 LUriFoZ14qkQDYFqX9JTmJecKcp/x24mSK77QNSoz3NU0S3WJ0yZDLvnfut3B3rulCADXlbdTqs
 3rwn6sV84OiCdgEO6xm7ogkM=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id e5bbb15d4ae1c122;
	Fri, 14 Aug 2026 03:30:38 +0000
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
Subject: [PATCH v4 2/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Fri, 14 Aug 2026 11:30:05 +0800
Message-Id: <20260814033005.2481920-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260814033005.2481920-1-ridong.chen@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FCF01C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: dj34bm8e4aogntorifg476ojogt77479
X-HE-Tag: 1786678239-72516
X-HE-Meta: U2FsdGVkX1+ICIH1pqRdh2wAVPOc37fQk6yowKGydPvDfIphvWBM4erMROMErAgVKUeG1QRH1FnWrfm0+vdRGc2JF3Zi8F6vdg6WLzQeFt/DBjMyOgVBso92h3OODPn0KmoxwilVeMTvwK4YpX41Jyn4qjbh4uvUtzUWg8w4QuEqWH0Hz0kA+90emDwLskJt1ee/etcYcN7hfparymjBv28XrmfVUOie/3zxdFm/4x4k8Xx2Qg76DnyfGBgM+539I0RE8xO6K9JjhVcr4UJV2HrQsrP5DE2TzcxT3ynGAK4wPRwpg4XITWRfdrnN5/1w6tQi36lUSQzdhhLSQ49BrbNbox4N9UnG1aVLmwTWKofPFJbxjOwSxvMOMzy5YTfBuzMisbApgVWPEL7YiTh8P8u+MVX8yhnhBkxuvpHwLApLY7spVIn4ujsJSVOwqsRxtlxLpe+Orc4pLtC6iDOk3gV8SC+Zzq3ayZ0Bmfi+qmH46bAoIAALZE7+y+D4GBsVIp8opuWGaMsb7bn0o6n22pSDppYdIfXkbKBK0nN2ztHFHSBePdjBdB1T8um9qI/MFeZHlyLqmqZ0+HXfmDNH+43fLcMi5UL3UkdueA0W2026IjXfmWD3hcoAU/F+rO5XhK9qr5d5ooiTohxrtfRh9uT6oacQ1/oMQW/gsQkSxjBEPxbTfvM+NmIs8wmzs1zvVJlpTsHWPaO93gSguMTdd335+BClB+LqM6V1e9sVBsvfqMesf/lJtadlHiKBqx0yllAxEZEyOt1iIf/QV9pXVySCJ4s40oa2BL46plxHnZPF7JSihJ7W2TOls/kOcaeZRGg8ZlHMjD7x9QJbx+14G8B8MMfG69Ztu97uBUMcZ4gLHHJrjKwav9ChKF+Bmm8eLSDTho/vP2gEk/xdoEEHB0Spz+ZIHdw2S3A8R1cLCJnnHD3ojru0dnmZu7/8KaSB4V6bniKsz2S38hpGvpw
 IpU+VzFt
 cKIQTyUj4VfPuT4aSocN7IdQ92ULRVHzF2uKIRLl5B1klPLCnSlDn4J8opD3FTnuyPdqfpO3cx4hBiW3Nws86E8E7hMYXNTtfnQIZqTukiPIs6kQayHpfQx2ZNhes+xxY593jenDoM5cDfIJsMgpmfHpU19fAAve80eSN706nLR8KB+mCI+jTr0YkQ6OCkEb8TPaSpeS4zQUgxRCq2nJjKkl/VlcAgnlnz4ZVk4Z/s6zLLW2pNk4pyONKml4jPr74mQ7CwoSuD44KCkIIjgeGGQbRGZ/B3K0+MIR+o91SPcvwu8jFDbTRCcNn+X4G0iW9Cy4e8E2OuKeP2jhOKXDOlMdWpwDoi3Sk9coVc8jAQhku2M6nbZl9hzaHoHzs2exttyzQnIqvy7En9oxySwW0/rjh8KRO81C/l2LJS+/ei+djFAs1kKKeGv2+Mbkbz3XT8dAwsWUw12KFWFv+1VeU5XXyNVonyifVP0qgBZWa1MQ1YhgkJUBA8e1rCv6vR2eSzrt0dBtFNJVqh3NbWznld6EDvg0UslB3IpHYY0XBFrMiAgfspG6rhRZ2r8XTIKv4+hu8GVOjilDoXL9kwhObD9soJNNEn2xIbFRaE5SDu6FRdGkLpI8Mq69iNkWe/2gG8CxDhi4B48E0FEoeEGD0G/eEHQ==
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
Closes: https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
Assisted-by: Claude:claude-opus-4-8
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ceb43b855122..5932046c637d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4744,7 +4744,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, old_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4752,11 +4752,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
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


