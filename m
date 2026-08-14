Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27402C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 01:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94D176B02D7; Thu, 13 Aug 2026 21:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE646B02D8; Thu, 13 Aug 2026 21:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8A46B02D9; Thu, 13 Aug 2026 21:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46C706B02D7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:29:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACE00140205
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:29:52 +0000 (UTC)
X-FDA: 85098143424.05.B7C7B6C
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5BBC0180005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:29:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="umpg/rpQ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786670991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjXPVx6zmgC3YAZ+F/JHoSJB/1vbFfNmmY3pKy6lJIY=;
	b=Ym4g1WPBb/DuutTR592o5tKp90w0pEeqIf347vnI+6PGLlvfkvWQocxLszyPfkptjpLPvL
	tieeaB8jKTySnsl+dHXP7eUeNQ61JQTBUQxy4uNVmUo/gLmSIqXiTafOpDQ2eipoOGVg5M
	rnWWSyq5+yVMSAaPC5BQz+y0/JKY0lo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="umpg/rpQ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786670991;
	b=ffw4v9qnHIWUiZRW8ahn6fKJ9tvoE+HEdvNvd6WT7w/SdhHAx3d4AwVDWZ+pxM5tzrKbT/
	Qci6+3Hpc5X92K/DD2+rNXdVdVvlxAorEC+7j85pfFmNm3fUfFuRjGbOxrYK5rZMEhVXND
	t+CJZI5Ryu4UgTZzbRKEIXbVUBDc4sk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YRIK/awmx71exiVOjlgX7attdFmpDuckcomywEMtZlw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786670988; v=1; x=1787275788;
 b=umpg/rpQ0RnezST5AyWEhNrlGcp9Ihpe2PksMoQcWQDlXU4R8wBA/WB1e+ajFOSZkEjI3oPW
 7Iww2O7O1qIoVY0nTOABHu0X/YM44axR0fC36fO1MBpC7acU3Zg1tf04P8K2+vl/bpDcI6fm+AI
 Sx8Mh1hddQEV5PGthp5Dx/oo=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id bbd37d40f1c9974b;
	Fri, 14 Aug 2026 01:29:48 +0000
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
Subject: [PATCH v3 1/2] memcg: acquire peaks_lock when reading memory.peak
Date: Fri, 14 Aug 2026 09:29:23 +0800
Message-Id: <20260814012924.2388613-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260814012924.2388613-1-ridong.chen@linux.dev>
References: <20260814012924.2388613-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a691bwpw78ccuwsohu54f14fuf4n3pjf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BBC0180005
X-HE-Tag: 1786670990-104773
X-HE-Meta: U2FsdGVkX18fFr4VWHDxVKlDwyMg/WryHJP5HwJPyCRz6A75Xay3FUgPE0e0f4+3V/Nc20mVSMighGElbpFI2JY0qS4xa0xcBIvTh+C5NGmou9+bYbFEsNPHri/gj1VJytRmnQOpo7fyyfnkKm+rA3OUrns5YYuqEiTr8bvwukxuQpKTTqY4j4kr5VSVKjuFMp9oWF9m4cfkR0IyIF+Yr1vXQcSOpO60wRLIAM/5OyfAN0qqb/sOr+clnfmSt9KiNjGav5yOMQHNhCeJrF+ElQ82YNZkYtr1Ib3/M8y51D4OGdsBVBqPO92Q8Q0IlzEKXdFkMr3kCSF7ueQNVJbtAJzTstpAER4y6RDlfDIhDCXUQ/KrvQWrUpL3cTWE6s613WMd1JVBMiBU4npbiQMzKxMrkN178PmVxNFUSY8K2KkM9sALhxZNcVTF4deMRZsJLbeWWEKRmQefwj/diI3anntFJrVxbGh1j3WBJ5ZgM6aQZx4N61SBerd+45m0+ou1QbIAu1NaQrCosSdHM2WNfDP3D7rPajwmEKHhOhwxU1pY7D8lNkuO56FPyYcB0KJXrdVOkXhcb9W4E5gBcCtm5JzXUHC4/uWN7JU2dsOKGjF5plCOsryx9BBWLnj5WKAMPaWb9H/VJlJgs8ESw6zkHR1AiTzWSkxDSV257KlWL/TO3c4SeHSM9qJnXcIokTL8zjiEjRKLLLt0TTn3h7minJbbSei+eaa40uDTYwUQb2v70I0xahAYI0M4FYMh6GQC/qcPYRHag/QFts4oNEEL4Ey/utLd0+jd1kAuM5cZ7dWFvAnUtvnjtXlhsmkpKI+6Uq5yjdLuDgSyFi7Ow1ObDFtUDM9IWtyWrmYJCsmyduMblUWBHGv03Z7rzaEb8JodlGMnP++aNtXdqENddF5QX+fmwwSHz0RBi9/Hf21asi6f4fhLO15PeU8mXS9/1aZQFLQMCrjHag66LQ6x4W6
 S1yUjqv0
 MThKvSwSieOSl40iZhIYz7R1p5Yo5qiEJCP4ERiPUEniZum6g0FFls0sQmtyCEDUlCiw/iKchr1+DxW9+8v9XQ2ZBjQKyAqozbjjRi6Occ9vPhy2AA7lx8mb9icLi8qB9XT1JTwWfrW38v07RrCRIizLL3xTGDYiQGexBj3kyD56ZUbb/yCHs8M4aNZ8f4O+hCgQ47j09ochfw7exuEHxlv4/tViIGvYVRt3uko1vXPTZJ1JPv2i1PNbm3rHGOiDftEBQdjWqD1SUTOJNHwS1e9FnGg20RhhlczFM1YblagTBbLEfGQxg73uDNp5b8a/SvW74LFPXuVo19vmx59985gSsTjQbQrr7O+Y6cb3k3PVa/MV9ukqnlWmaoAwzf6jqIROvRQNie94jxgZpV1zrYFYcBsW0w4+jg+jTjIAZjkmAGeJfUm292Tu/tFidPn8fFiW/qVrJ3YEzHEGJa1SpqrWyrMFcCWQx30q6DY38Ijuu6dBbLtyAAsBpfCEhvyKKZ93U+yVWU1qzuBG3WnlVqPnZKumv3bQJ9yZC1jZfK3h2Kln4pa3ZTUW65K6Ak/zy/UtZyVZLNsNnaX7yew7LpOOOO512DpKIDzEzhz1ydvZJ0zFnuYK665ZFqL0bl94hVcMxdYMXoHOMKRfby7iuDCnOwuBBLz713J7EIDovMPBUIasNCUECMGkEl1+2RtR4AUZkSdwmvtIyUmjbhobqxEXW7XvYQQOsqFzn9H8OcQCbE+g846FtnJLSYKbiY9o2FoC/
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
 mm/memcontrol.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..6dd8756870ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4713,8 +4713,13 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
 static int memory_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
+	int ret;
 
-	return peak_show(sf, v, &memcg->memory);
+	spin_lock(&memcg->peaks_lock);
+	ret = peak_show(sf, v, &memcg->memory);
+	spin_unlock(&memcg->peaks_lock);
+
+	return ret;
 }
 
 static int peak_open(struct kernfs_open_file *of)
@@ -5858,8 +5863,13 @@ static u64 swap_current_read(struct cgroup_subsys_state *css,
 static int swap_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
+	int ret;
 
-	return peak_show(sf, v, &memcg->swap);
+	spin_lock(&memcg->peaks_lock);
+	ret = peak_show(sf, v, &memcg->swap);
+	spin_unlock(&memcg->peaks_lock);
+
+	return ret;
 }
 
 static ssize_t swap_peak_write(struct kernfs_open_file *of, char *buf,
-- 
2.34.1


