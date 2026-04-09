Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5BAEA3C55
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC976B008A; Thu,  9 Apr 2026 08:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CAD6B008C; Thu,  9 Apr 2026 08:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93496B0092; Thu,  9 Apr 2026 08:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B657E6B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:27:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4614413B6C2
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:27:02 +0000 (UTC)
X-FDA: 84638941884.18.7D56CCA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D3FD40005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:26:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gw45fOEi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775737620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RyTOqeITLagvuFs2mDcK3Qx9vkcML7y9dkzPswSeJak=;
	b=en7T0n3tJLGIr117pAVw1T+S4oZjm0cqYkT3FahDJs/6/CztZ5YY1I2QAxQgloBlyMjW7y
	ucw5HDirKmLF3ncrPbnsfCfMW0Np4St5JZcF8ufZqhlbxbKnplB4TH3XSHWWxIBUIEG3DZ
	FCmjgLKfVtM8H+m833YWb93Wax2YTgE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gw45fOEi;
	spf=none (imf12.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775737620; a=rsa-sha256;
	cv=none;
	b=nW5tMts1iU2KRkGXk6q7zTHdWPjgMF+TaSLehOWCWr5kNevsCdGli2N+7q6n9YbljqRV4F
	T4112BoI+XWHdQ7E6otv47T6No4ai3CEmSlRAows3s+cZk9s1irX/GaZHpq4Wu7+bfdiB8
	1iNkhIRbDpUUeHoRjviDvdnsDFC4/Ak=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=RyTOqeITLagvuFs2mDcK3Qx9vkcML7y9dkzPswSeJak=; b=gw45fOEi9RoUFaHcgE2WvhcvHB
	HYkT+dB/DCp7Qa7Frp9nrbAQkr8qUMcOnlvY9mmzeaCgOkaXS1iSROZvb/M8vUFpa0s21kYKpa8V2
	SxP2Kr0qKirBAiB7k/NgJaFMN0yfuVLu7GdYF+8Hg031gmA/QPWBK6XKpD5EWjyK87yn0Qac9OJow
	azLbx+cTWaoUgLAPqS4sKeySDnfRNU30gr19T4Teny9ZpjpKD7UYZCA18JuExjTovGxf6Hoj8PhN3
	QpUwGl727/2sSU+Db4JApvT7yuhTMuAmLPatWnCYemBB+eqj9t0DDkCfbbdzlPOXFg3E0BIpzTOxh
	bHoOog4A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAoT6-009CJU-2N;
	Thu, 09 Apr 2026 12:26:46 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 09 Apr 2026 05:26:36 -0700
Subject: [PATCH v2] mm/vmstat: fix vmstat_shepherd double-scheduling
 vmstat_update
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
X-B4-Tracking: v=1; b=H4sIAPua12kC/2WNwQrDIBAFf0X2HIsmGoKn/kfJQZM12UKTolZag
 v9eTI89Ppg3c0DEQBjBsAMCZoq0b2BY2zCYVrstyGkGw6AVbS+UkDw/YrKJCzWg8Gh9pxQ0DJ4
 BPb1P0W387fhyd5xSfVdipZj28DlLWVbuT5oll9z1w4TKdlpofZ3Rkd0ue1hgLKV8AYG1scKvA
 AAA
X-Change-ID: 20260401-vmstat-048e0feaf344
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
 shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3434; i=leitao@debian.org;
 h=from:subject:message-id; bh=2K8+Ryh5CYTlYSK3JxJau1TxsZI23fwwxvROlCFTSPo=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp15r/OU19OSkGmX/Y6UIrGWXMbpDn+lJdP+3nb
 nkBS69CiNiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadea/wAKCRA1o5Of/Hh3
 bd1CD/4r4aWtdHN/BsI4SB8AOdNGCLlWMhfj1wQMj/1GeqZUVnfDV8Q7ZFVFkyJKYPUfBqAfyJv
 LxPTcawrJBfho8DV/okYRvHsxBwGxyThO9YHfzGmi6qhl9ro0F65zLiJ9JSiZzWFXLCCO19gpxa
 dL6syUVI7PX3mpYQe84guBRwemprOpXLQ4tdca5FsLKcjzdPpPTQ3Ng4JqXPrv0pRaSZDHlWw8t
 qBrd5a+R6jYUzL/tDVW6tdAn17qfCKItSabcOoZmJ00CpQgI7tDxD4MQOAZgxgdxExfU1W66vNP
 lovS1EN9HATrtgwxG97GvkxrQ3g2Pyn/LAKQ4H46oTs2M7u1k4sxjAAQiPUfLo/E/Rw0tknIZax
 ovk2CL5QGeHASbPMCeZ+gb41q/3LLkfQZd4Ti98kJ6iTPsGBH5a7UbEFVsPg5DCWz3dxLiysNWH
 kzn8biDclRoMYpAr6YZ58xZyaw2Ix1MZOJ09XFc9Pbfo/imjEuY8cTOQXZ02aTQhGRz7a1/ZUJf
 cMUxEytTdbr1jP40faWy6magzF3biJ/yjWWa6FfO0zGD8tVaQx/xpM9eyYrxExafYo5GQZMGVA5
 rfTohDyYBxplki6o0+czIObGVTwhX8Zs3qaMGZjnhTKxxFhfoPvMXUXn4lqCGBni3iZuebZNETY
 srwSrfm3l3ET+vg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D3FD40005
X-Stat-Signature: 4pahzh7ep4hq3ffq36gyhiyj19knbiqy
X-Rspamd-Server: rspam06
X-HE-Tag: 1775737619-736925
X-HE-Meta: U2FsdGVkX19608r4PmoySj+Dbu651sOu0biRWf3h6kR/7cZzg8or9QD+AKsMXgk1qVy09E+phrbpJJsp2fikwzUpB2RTrCnKDOwHp+WaQdWqzmYYF5PgSqfWttKeGkgIjW0e2S3MmjWCTlOQgclzqNYhC/3kEH+IXPRz4gEO15Zi676wDLuRF1aEvwbBvbhSwGU+85nI2lVzMzPU0pzxTcQpMTdQG1KsJlTydZgkLRsYTs/3s6PdMBw8K8NBh/AkqZhB9heONxem30ALVuy5oGTVXvKUM++M8jhzOBxSqjSDvfmDVYKWOrNkC55yIZpDtgs4AlxYI1BPMUB9FKeWM165OtHrCgqBiALWCnAZzZVT1kUeH63zYHVPSw9QNBQnO32u04fCteov69ZoWoJ1ysfz2oSHMnF6qKyV1rU2LfwW0jUJiQQvluUD/Cz/z4DlRX7+7JFj9vcWNg28AYSa/0ZyMFH/V2UoNraMYUEdxENQzQgRGAvtnJH0OIfAVXlDTp5kBbRb+JkglFb9Ed/YpVHPcFFhgtW99z2yAbkUf1sXZzH5q6NqZM2RkVBSqGGNgcfh78LH0Z6Ws9cq+r9fQiDQUdEqRZsUnrSZc+nDfhS/cbtLaZeqws8tk5xR/Y1vhnfZKcg42Ahh5LPn4A0POdP5iy90uPWuR/mFyJH7zYhfWjKfhBfO9Y8iwnUgTXEUCTYMSOfImGMqyBPAT5IGMaEdV7R4s0bKEtA6vJRyFInMS1ilflsFmRNuUJ7L9A6NWjmdXn7SkBV8O8PnMfWwAO1JkTLT0d6J2oATfcbu84tQ3Asge02NkOksLMHHhKuGvuplrZGzNWVuQmXyQNEeItBcmCe7uSsM4WjG90m4JrxdVXel3Fey2uu7bgl6/folOOqkCmeP2bZRkN9eP59e0WzdkpmwcNOufJ296Groz6uCDIu3JJOvrjCbgR7VGOE+u0B9ytIJKzogwnJuIJl
 4vmrulbq
 utLBH8pEVhuHJLVfnjjawfeIPUPisRiYsL+vpIcvJWyuAG8KzL67x7edvg6TsgWDXWEoC42AHjkc/q38tb/m6ind6v2yeLBc72A9TQBUYTJh3rx64XTdoyE6TieKLNtvyYzt+vJ1A+TEOSYr6f1FQVWJKNSrOksoxwbqMSaxGVBJllEd2EpmZNuQlMA+G0fc9esckTW/scH8AMrylgyCVaFScFQeKnpZB+RDurZXi7VhcY0eR90e2LVdbOza1t51A27r8UoQAZY5fK0ltgd6NujsUkT1mVUoHfZjtR+NJ59rj9+ltLkWHNMM+z8lhqbsQCUaoobkP0MfNIaLTUAkCAUElvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmstat_shepherd uses delayed_work_pending() to check whether
vmstat_update is already scheduled for a given CPU before queuing it.
However, delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT,
which is cleared the moment a worker thread picks up the work to
execute it.

This means that while vmstat_update is actively running on a CPU,
delayed_work_pending() returns false. If need_update() also returns
true at that point (per-cpu counters not yet zeroed mid-flush), the
shepherd queues a second invocation with delay=0, causing vmstat_update
to run again immediately after finishing.

On a 72-CPU system this race is readily observable: before the fix,
many CPUs show invocation gaps well below 500 jiffies (the minimum
round_jiffies_relative() can produce), with the most extreme cases
reaching 0 jiffies—vmstat_update called twice within the same jiffy.

Fix this by replacing delayed_work_pending() with work_busy(), which
returns non-zero for both WORK_BUSY_PENDING (timer armed or work
queued) and WORK_BUSY_RUNNING (work currently executing). The shepherd
now correctly skips a CPU in all busy states.

After the fix, all sub-jiffy and most sub-100-jiffie gaps disappear.
The remaining early invocations have gaps in the 700–999 jiffie range,
attributable to round_jiffies_relative() aligning to a nearer
jiffie-second boundary rather than to this race.

Each spurious vmstat_update invocation has a measurable side effect:
refresh_cpu_vm_stats() calls decay_pcp_high() for every zone, which
drains idle per-CPU pages back to the buddy allocator via
free_pcppages_bulk(), taking the zone spinlock each time. Eliminating
the double-scheduling therefore reduces zone lock contention directly.
On a 72-CPU stress-ng workload measured with perf lock contention:

  free_pcppages_bulk contention count:  ~55% reduction
  free_pcppages_bulk total wait time:   ~57% reduction
  free_pcppages_bulk max wait time:     ~47% reduction

Note: work_busy() is inherently racy—between the check and the
subsequent queue_delayed_work_on() call, vmstat_update can finish
execution, leaving the work neither pending nor running. In that
narrow window the shepherd can still queue a second invocation.
After the fix, this residual race is rare and produces only occasional
small gaps, a significant improvement over the systematic
double-scheduling seen with delayed_work_pending().

Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Changes in v2:
- Instead of changing the timings, do not double-schedule.
- Link to v1: https://patch.msgid.link/20260401-vmstat-v1-1-b68ce4a35055@debian.org
---
 mm/vmstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2370c6fb1fcd6..cc5fdc0d0f298 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2139,7 +2139,7 @@ static void vmstat_shepherd(struct work_struct *w)
 			if (cpu_is_isolated(cpu))
 				continue;
 
-			if (!delayed_work_pending(dw) && need_update(cpu))
+			if (!work_busy(&dw->work) && need_update(cpu))
 				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
 		}
 

---
base-commit: cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
change-id: 20260401-vmstat-048e0feaf344

Best regards,
--  
Breno Leitao <leitao@debian.org>


