Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB2FFC2A072
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 08:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171EA6B0100; Mon,  5 Jan 2026 03:22:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120D46B0101; Mon,  5 Jan 2026 03:22:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022026B0102; Mon,  5 Jan 2026 03:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E50A56B0100
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:22:04 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90888F52C5
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:22:04 +0000 (UTC)
X-FDA: 84297217368.06.0750BF6
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D7DD140002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:22:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=wH4A9r1L;
	spf=pass (imf23.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767601322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXZuyiPqxgHVa4OJsj5vnpr+LBGAt5DcCj3yHiyEQoQ=;
	b=TdZGPZgLNHAl48BruGwziqkb94HJe/Ap/DKqdPMz1ZlKgKCjVoK0F7dSKQAinRA0aF23it
	Ap48Znn29qMibl0kBkzElE/BgZW8YVir54VTXexlfYqM7CBX3eflv2qP4+QyFM5vMNV9gU
	j3iyJEMNLwm6rqHD0E7yIvrryBQHc20=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=wH4A9r1L;
	spf=pass (imf23.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767601322; a=rsa-sha256;
	cv=none;
	b=3/svpprOylBDp6epFG/xTUCED2skiYdeQkxenjKodrRpLIy+/8da+6SseTeoeJXxkxoVAj
	fVhGeHtCZlGalG12yvyxrsy7TVaq+20rwibokP3sbnw9bVla6nHC95HA0PfBY+y/4Euotx
	BDXWltu2KFjQ25Y4QQKAftnP9rbYCiY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767601319; bh=lXZuyiPqxgHVa4OJsj5vnpr+LBGAt5DcCj3yHiyEQoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wH4A9r1LK+aYSGQfyZwHi6+q3URFe8D5ty94H74eE4sM720xH4I33z8ajNaEQStc3
	 5roHpeduXj2eaXUcJKFj/QDxH5CHMg8Yi4XeRQt5ybFY7njtpiY9zTrton+CXFF3qn
	 fWfdp/qB8TccWzrS8vOPRaIvfheVCUa73fEIe0M8=
Received: from localhost.localdomain ([61.144.111.35])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 57925034; Mon, 05 Jan 2026 16:21:57 +0800
X-QQ-mid: xmsmtpt1767601317te9acxqp2
Message-ID: <tencent_6FE67BA7BE8376AB038A71ACAD4FF8A90006@qq.com>
X-QQ-XMAILINFO: OIPiZ4jSkGWAR3rmek1NQfj50RkwmECUekHdPWHPKk507wzbluK5Co6bHHMYFY
	 kERosLo8Gtgz61l8Nm/FJlDsX4HS9R5lVhSFVsZgqv1+qDjTgNoHNSpy5lFm4ym8FnR7UbrfFrlz
	 39QSHF+VAvq+u2Sdfl5se80xQ+cDT5ybweyjV6VTGxcSnUnKfSWzMyOlb102mtY55sXdBr8Zn/UJ
	 eLhT+toHXZbajg1LwBiJQvwvAxZdYz3eWAz7yQfwe1sQP86l3UPUGH3eExgB0DsxCD3vil602cR1
	 k4d5EfHpImtZH+xRVmqKf4h/ejh1RduchTBk42PqGAcs6XEAMSFyf6yAIfrwSYIE2lwF++a+RTTJ
	 f0W3m/rT+9VBt8IYizDsTZ9TK03URJm1ZWGeBYuCOIhatqB9S9M7YSzL4sLBvBd6ID3idI5pd9Y1
	 VnHGtOP2Ww8EcFobcIrhxtxDTopwc7JEiirvUlQFFAPdH1Vmu441m9EU+bx+NiXA9uZn4H7QBoKp
	 +Tl+phISV2FpjFVVOPabDlvBW+FKwuMYHg7Q5hLkHYP2RM1EoPRfYZWGsFSsK7Erl89DjySQZZVz
	 xxV3xCP6O9H07rYVNdPAZcVV6n8Cg0uzIb8K64td2NDat87POq5rVfyuSXCceuB0vL1xt2hB+XVz
	 KARwbwFIc7GaAIfD9p9zAbZfM6uXxjzCJVHyAuWVUXwz/WL1cEQ459jz2cNmpj/1PoKrewF5eA/6
	 b5S7isLxKVH1VhO6YdeHQm2aPhpcfMywz5rouaH4UA8hIyurkw8Xo1r6pLzTdL82amK/DN16mYKj
	 Ulo0iaBKdpfHQ30GoTbS1XtcoERBWn4VvO8q7zfzLsMu0xK0HY/PRPs5D9epA38BjNW7FaU5RIcs
	 4zSdlKU9bGRKGYRQJrkEKu8dfxkCM59/8IYX+kUNEDYGEXU0r2WS7agvkqh4c5bPDVq6i/MRneb+
	 DeZIJgn2dD+49kRiz/5KXbsKSxleHl79y8laLiehDBYpPkJ8Jjf1uDM6xfh6LUwW8uZSOCpBrYbX
	 HVD78NQXvBcXGCFTuwh1Pwbi2K541ewM3MrvemRDP7/Ty7zVRy3f5pyjFj80pyxfDFRj8qi7/URb
	 +AY4g44kLES8P/+l8=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	wujing <realwujing@qq.com>
Subject: [PATCH v2 1/1] mm/page_alloc: auto-tune min_free_kbytes on atomic allocation failure
Date: Mon,  5 Jan 2026 16:21:52 +0800
X-OQ-MSGID: <20260105082152.1309853-1-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260105081720.1308764-1-realwujing@qq.com>
References: <20260105081720.1308764-1-realwujing@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D7DD140002
X-Stat-Signature: utq7jqf5tjarz3pf7amiiqawq8sfucr4
X-HE-Tag: 1767601321-413826
X-HE-Meta: U2FsdGVkX18pN59oRJQ+Exb53GFX/j82skNtRUJQDo9a8QRlAuqUtoiI7SAZF5/OTvshUeDZQ2g3Y+GyStZWJA51vYvIEF1wLvMCTwWqgnPT9tCz0pa6PBsRmiyGESsR/bpiS1hqc7cApv2YbncN1RmBFvKdkbcVwUnh3CcKEc+Zix1Pbpv87dHquEs4jo0v2JB2fGHLdHhEDMxtgmI/9eSX3TLknMkB4BBE90P8xzhw07C1RzJ7Gnwvb0gL6AHseDh0mm9WtSrMUiorEm2lpwIJ4Exrt5BeaE7qCNwS4y+5dte58/daY3coFDoEqb4K4oYKsYuq//DQEOp3WR5xvQPCxU2bmrvRvuBXgTfdmfKOw4lDiWJ+pHw1c8ms9Fga4XkmDBrZMPLJh9BV2S+zK51kWeEhj81eUIRjclkZuUv8DgTK+IyGsj/72DopjdSR5VZlJguf/lM581lPmlAKvNAc2DLd9rXih40QHawckEUg1jpbhG1xJUrktz60CFZ/MebRKeURc0vFe2TAPTOC77ZHZPIYme9ZiElPZ5+9dMELcWWnfgeZ4sphtqPh256Rzx41O5vi7mIBP7HGz+gAc3JVKgMlMM3pK2FJKf3vdVjHWjIql+WbYxKqdZVqSu5Do1C7uS0e9jKQFGHUzesGk03AWHMN9GVlLGZ6tez1JNQvJziMV60MQbJjaDj1d64BVLwMNnmnsvpt2NKyKfhqW1ZEldJP03ENGa3wCw6nMM/WXFOynO506OO+Kb6DEmYqUFzmBulCRjI/0IVeYIe1grRDQFw1X8RHJ8Y1dyJNm/UfuYO/kAc2WXQdAzlHpkyxnQ3Vp1iinzkr7RQuwXdMqU3RzAz7rBoPl569Ahw1ji9ZebmGuQcERABLL3kICaNQAyYeCXKLtwLKPpmdjZDcMewy0suG8lc3ClccMifz0jCyDfAV2bwbKKm//pLEODPuw2emhnNCaUooW9q3FXW
 C28o5EsW
 pMNzwbZHZqzNRjvsKdzNcgDm9C+BKFORId6gpPjEqU6n5zXqCi/2SDP8W1GhN+pCPqXIMA7ihvWVJFwdeq+UkkSwPIhFyZCcHRWn+nFxTYqIJguqhZ8p+ekpIYjV0tcZEC/Pcl0Ucck9O7cAv9sJDu411RDNH6gFue18yqri2Tap7puL2mlbkOQF0ZmkeW1a+3CFCFCGAxQuSw46Q5yzi/5a11oDfvU04q2ONUNXYr6N9TwzzWGp8h8QiMQlBX4n4RCSbLTDDQT+/n9wFlcrbZhBhqVoFyVWTR22oS1O6BW0K25LOYk7G1liDKGT3wpsjFg7h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a mechanism to dynamically increase vm.min_free_kbytes when
critical atomic allocations (GFP_ATOMIC, order-0) fail. This prevents
recurring network packet drops or other atomic failures by proactively
reserving more memory.

The system increases min_free_kbytes by 50% upon failure, capped at 1%
of total RAM. To prevent repeated adjustments during burst traffic, a
10-second debounce window is enforced.

After traffic subsides, min_free_kbytes automatically decays by 5% every
5 minutes. However, decay stops at 1.2x the initial value rather than
returning to baseline. This ensures the system "remembers" previous
pressure patterns and avoids repeated failures under similar load.

Observed failure logs:
[38535641.026406] node 0: slabs: 941, objs: 54656, free: 0
[38535641.037711] node 1: slabs: 349, objs: 22096, free: 272
[38535641.049025] node 1: slabs: 349, objs: 22096, free: 272
[38535642.795972] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535642.805017] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535642.816311] node 0: slabs: 854, objs: 42320, free: 0
[38535642.823066] node 1: slabs: 400, objs: 25360, free: 294
[38535643.070199] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535643.078861] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535643.089719] node 0: slabs: 841, objs: 41824, free: 0
[38535643.096513] node 1: slabs: 393, objs: 24480, free: 272
[38535643.484149] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535643.492831] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535643.503666] node 0: slabs: 898, objs: 43120, free: 159
[38535643.510140] node 1: slabs: 404, objs: 25424, free: 319
[38535644.699224] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535644.707911] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Signed-off-by: wujing <realwujing@qq.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..2f12d7a9ecbc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -30,6 +30,7 @@
 #include <linux/oom.h>
 #include <linux/topology.h>
 #include <linux/sysctl.h>
+#include <linux/workqueue.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/pagevec.h>
@@ -3975,6 +3976,16 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 	mem_cgroup_show_protected_memory(NULL);
 }
 
+/* Auto-tuning min_free_kbytes on atomic allocation failures (v2) */
+static void decay_min_free_kbytes_workfn(struct work_struct *work);
+static void boost_min_free_kbytes_workfn(struct work_struct *work);
+static DECLARE_WORK(boost_min_free_kbytes_work, boost_min_free_kbytes_workfn);
+static DECLARE_DELAYED_WORK(decay_min_free_kbytes_work, decay_min_free_kbytes_workfn);
+static unsigned long last_boost_jiffies = 0;
+static int initial_min_free_kbytes = 0;
+#define BOOST_DEBOUNCE_MS 10000  /* 10 seconds debounce */
+
+
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -4947,6 +4958,17 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 	}
 fail:
+	/* Auto-tuning: trigger boost if atomic allocation fails */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0) {
+		unsigned long now = jiffies;
+		
+		/* Debounce: only boost once every 10 seconds */
+		if (time_after(now, last_boost_jiffies + msecs_to_jiffies(BOOST_DEBOUNCE_MS))) {
+			last_boost_jiffies = now;
+			schedule_work(&boost_min_free_kbytes_work);
+		}
+	}
+
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
@@ -6526,6 +6548,10 @@ int __meminit init_per_zone_wmark_min(void)
 	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
 
+	/* Save initial value for auto-tuning decay mechanism */
+	if (initial_min_free_kbytes == 0)
+		initial_min_free_kbytes = min_free_kbytes;
+
 #ifdef CONFIG_NUMA
 	setup_min_unmapped_ratio();
 	setup_min_slab_ratio();
@@ -7682,3 +7708,62 @@ struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int or
 	return page;
 }
 EXPORT_SYMBOL_GPL(alloc_pages_nolock_noprof);
+
+static void boost_min_free_kbytes_workfn(struct work_struct *work)
+{
+	int new_min;
+
+	/* Cap at 1% of total RAM for safety */
+	unsigned long total_kbytes = totalram_pages() << (PAGE_SHIFT - 10);
+	int max_limit = total_kbytes / 100;
+
+	/* Responsive increase: 50% instead of doubling */
+	new_min = min_free_kbytes + (min_free_kbytes / 2);
+
+	if (new_min > max_limit)
+		new_min = max_limit;
+
+	if (new_min > min_free_kbytes) {
+		min_free_kbytes = new_min;
+		/* Update user_min_free_kbytes so it persists through recalculations */
+		if (new_min > user_min_free_kbytes)
+			user_min_free_kbytes = new_min;
+		
+		setup_per_zone_wmarks();
+		
+		/* Schedule decay after 5 minutes */
+		schedule_delayed_work(&decay_min_free_kbytes_work, 
+				      msecs_to_jiffies(300000));
+		
+		pr_info("Auto-tuning: atomic failure, increasing min_free_kbytes to %d\n", 
+			min_free_kbytes);
+	}
+}
+
+static void decay_min_free_kbytes_workfn(struct work_struct *work)
+{
+	int new_min;
+	int decay_floor;
+	
+	/* Decay by 5% */
+	new_min = min_free_kbytes - (min_free_kbytes / 20);
+	
+	/* Don't go below 1.2x initial value (preserve learning effect) */
+	decay_floor = initial_min_free_kbytes + (initial_min_free_kbytes / 5);
+	if (new_min < decay_floor)
+		new_min = decay_floor;
+	
+	if (new_min < min_free_kbytes) {
+		min_free_kbytes = new_min;
+		user_min_free_kbytes = new_min;
+		setup_per_zone_wmarks();
+		
+		/* Schedule next decay if still above floor */
+		if (new_min > decay_floor) {
+			schedule_delayed_work(&decay_min_free_kbytes_work,
+					      msecs_to_jiffies(300000));
+		}
+		
+		pr_info("Auto-tuning: decaying min_free_kbytes to %d\n", min_free_kbytes);
+	}
+}
-- 
2.39.5


