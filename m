Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C64C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 03:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211686B060D; Thu, 13 Aug 2026 23:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2376B060F; Thu, 13 Aug 2026 23:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FEB86B0610; Thu, 13 Aug 2026 23:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E51266B060D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:30:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFA0A1A0151
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:30:36 +0000 (UTC)
X-FDA: 85098447672.18.D3559BE
Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8B415C0004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:30:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V943aBKj;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786678235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIDfqaon5W50fxRaX9+/Fg4vmmGp5lH56w7S1/uhW9Q=;
	b=nA/68LJj/WSpg0mfK2ch9U543xp38T/d9r1ZmvCiyQu5r+q3rbwTqFBnqs6stNUr9hcVYy
	eQCNyFToMGgyUaTTmErKWmVWwBmSMeZbVxzW+P0d8JIJrhnJjo4j1bQFwK/VV340pd9Z6S
	HpGoKOfAUcW6x5LapWHJnUZcjOt+u/U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V943aBKj;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786678235;
	b=4rjZER2joPt1f83/VPEryrY8BBVQ+YKyX0NKuoYxVrjhQTv1mKF44OhLEfas+8kl/L7tdr
	fMCk1/8s6GToITHJ1hfjc/BmpM5yIXbQTF5GIEHXy0U0X1JvfJAsgdz3X4DuceKEh3dxkT
	BnijE+dRzjQpduopJaj5rlsAwr0oUvs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M3M6KYCU8WrjOH8M0FSq9Y5uJuL5tl6xBP8M1lGPC2M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786678230; v=1; x=1787283030;
 b=V943aBKjkdKDyNGKceNY3ZfcfJ9m50izyAcyqCSA66icCX383muzykY0F6PuuM98+s8Qs3Kc
 ywJy1S/iodyIS/o5Dcdm4WmfCy/B919sNZoqOHuztg25wnK/ksEV5Cnw7GCs8vJxP20/6PWqLNe
 ys8jE5+qBhxtwLDyrXrFpfAM=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id bff796e104338a1c;
	Fri, 14 Aug 2026 03:30:30 +0000
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
Subject: [PATCH v4 1/2] memcg: acquire peaks_lock when reading memory.peak
Date: Fri, 14 Aug 2026 11:30:04 +0800
Message-Id: <20260814033005.2481920-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260814033005.2481920-1-ridong.chen@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7qe3nbzf9bcoc7zanhaabxicr87o6bx7
X-Rspamd-Queue-Id: 8B415C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786678233-973258
X-HE-Meta: U2FsdGVkX1/By4fodw700QT20lxrhs7HNFvp76QwQe7ho3d+G1QCxESogIJI+kfRKUVWSpLd+Yf6PUf16bztZLCnaxVMdNA7iytozRq0SR0vxcw3/0WqUqGIJ2/JDFqewIZVWEjOfv0WeBXNoW0kGfdquRhMvN1MYektI6PFT/yK7O4frBkN7v/IIejhfWWxw/hUuh5R9Qh3UDF1ST2gMgdf8lIyqD3ECKU/Czael8drCMb336HSgS6Gk6+n/rG4BduFaE1AxaVm70dCLA9jJd0CvAMPDUw4aXjYS9YZdw3Wap3cWCxQgxnJtxe9ZHyP4yPPF9R3Nlt7GulBlmJHTgR7Ais25S9SP2P8EDeN/JdfJ2I/I/uW/zabXnUBTD0+i9VDyZwCkr2N5o8fH27IThD0iCrWszT+UcBxd84p4CtpyFzrVRKSAaYHOKJFHrWtCk6YY4OHR3RfzfvnOA8HUgHb4dtJ3mV9aVfDwnHKhW4H7RQHqSY+/J86DexvvJGJbm5JI/Pw1aKgRQ6LosYGb5FgoFuOdX4mnmmTcH+Fv/426+SI6tq6Xa4smUSfqB1MB4giqUtuovnT4XnrKz9GpJenwEYKtTsY7mx3F47JtZKDwzqAgekQgEP1jVnKdhi9aO2Gvkp+gJGu0dXTMI0IM7EJwPFwYFyDiQR0p9kDqD6sQSKM7XlpNjXxQLS/pjbUD8tq1xTW49WVz93Vb95JTLo1pKaJOUK2JbAs/byZ393nhmVScccvzm5ZrNmPndicoF9CQC5NPdHu9XifzdANdt02qpv+C+yQGMxMY/dmFUw+18hPlgXCcCpV1/A+3RL7IxOtDhLYgbmDi+Tf1n6/q0DbMsDId9HxuNKN8AyUbLw7xrejHVqHKUk0dY42A1VULQEc1dx9paZV5Oq/Ke5Eh2pCo3mbi0iw1G0TKINO0PtJ5X5yQZM9ZI3e05Oy3cBbdoF3glrV3fgJP9ltRLI
 yHEyPKcw
 ijtzfQNZH8SerqTUwztcrAAoiXAGdwVZ3N637Xk0KvqcSGTl+X29U1+UXAdjmO2N70gTLhFBjxuk+iIJ2HNHr29sHTt4c+FuTcocvPvo2L4sBdEg546+o1JxbgxuLPbIXVPR0+2ROTnoaSMDyisiiiW8Fqp4kwG6BKV75vFJL6p/Q/zYF/0ntbVnstjOEboA1y7BV/LC7R3EFbQ7mzYbemCP/tVme/pPXDl+CRYRRQdgW4y0UdNxk3UHH3DE9EhTmXb4b2h5XuvNW23moFWDI+kY2TsyiM5XEZKzk8jzgtoEvrjEWAHF4uRT/m4wda9fRIS9CvaOHE/XS4CbRSo1eAub8MwVsEhlSIsgFynqwWOhQ59JalVL8Qtuf/16AdqVBRGhza+l2JrmNzjJnrWlKcrF3Dxp0img3NQWUfwVxOJxibRytTD7J3Twaqxnd8lHi8CC8qOY0lWcPtRPlkqVdehKAPmobLm7SNkVQis2X+L6G64TRxy03YG/FQGeuJW4252u8E04CKvXUWRtQDfgRujxNELticIgnpa1SX9ZGKSvwRHLRYIHR2hGNd6oBcZoX/7DpZOzJCD9tqFkhzVrWC15S/CuPxBWfk113i1g3Zs/s8gJfo52rrPUsljOxhlhYEtKsPHbajbjMfNbi1T2kxivYNETXgsivfyx2gSdPWhnvUeybZ8PUUCAzcGo3BDn8w7cepdvnHiHyGOQjQxAv/9q0X3DEJ6pWlIo0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Sashiko reported that a reader can transiently observe a lower peak
within a race window [1]. peak_show() returns
max(local_watermark, ofp->value), but peak_write() updates those two
under peaks_lock while the reader takes no lock. The interleaving is:

  writer (reset on fd A)                 reader (fd B)
  ----------------------                 -------------
  usage = page_counter_read(pc)
  WRITE_ONCE(local_watermark, usage)
  // watermark lowered to usage
                                         lw  = READ_ONCE(local_watermark)
                                         // sees the lowered usage
                                         val = READ_ONCE(ofp->value)
                                         // B's value not updated yet
                                         return max(lw, val)
                                         // both low -> low peak
  WRITE_ONCE(peer_ctx->value, usage)
  // B updated, but too late

Fix it by acquiring peaks_lock when reading the peak, so the reader sees
a consistent snapshot of local_watermark and the per-fd values. The same
race applies to memory.swap.peak, which shares peaks_lock and the
peak_write() path, so take the lock there as well.

[1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..ceb43b855122 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4714,6 +4714,7 @@ static int memory_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->memory);
 }
 
@@ -5859,6 +5860,7 @@ static int swap_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->swap);
 }
 
-- 
2.34.1


