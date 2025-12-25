Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B121CE7AD4B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB366B009D; Thu, 25 Dec 2025 18:22:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19AD06B009E; Thu, 25 Dec 2025 18:22:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1A46B009F; Thu, 25 Dec 2025 18:22:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC3656B009D
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:22:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C576A13BE96
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:22:30 +0000 (UTC)
X-FDA: 84259569660.15.87ADF8B
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D39280004
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:22:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lpuglBuc;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766704949; a=rsa-sha256;
	cv=none;
	b=iob4jGImcRTOaMiC1YcojgvHD70eQ+Y20o0y6fLUTCtbMPigzXuIdX9dz6/k6a7VoiHR6x
	afW+aST7AtwH+kzFRrpRiO6NpHtc4LNzh5RC0u4TAR7h1sE0Nq44m9CMNrPI1Fmmr3s4OQ
	fSDBIPBNeJZRwc+dlkmQUWflDN7nqW4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lpuglBuc;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766704949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Emeg4oe9Wf0hyjEB6RFxn5Oy5f9oafLtHS4W3VCookU=;
	b=H5jkvcxcJk4KtOTPdtjeoqXEhvk5L9TSeptHdN36OykZJkNuB/vqlbAy0TQMyPEBhcJ9gO
	oi7G6DhZLDOe49kO42XdI7Ku6l4oyI557eKQG6kGbQO7I2m0aXEwUE4Qhp43Zm+9lQ+nZ9
	CWgwfAPkf6zOp3/G2G794Gd0XPHeC88=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766704948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Emeg4oe9Wf0hyjEB6RFxn5Oy5f9oafLtHS4W3VCookU=;
	b=lpuglBucsWYRiDV/OnmxWeINhdtMYGc0NTEFlwikXxPSs0ejEd4LObkAP9Ac3BAHuc+Fvd
	Nztz/FLx82sK4xM2VUmg1+MA78XKQUDuQTQFd7WgwRQRM9JF5YL33GsHMO0B+BFsWDHuL3
	ru71F8vValtJC/97v4Cc466P12Hpbzw=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] mm/vmscan: use cgroup ID instead of private memcg ID in lru_gen interface
Date: Thu, 25 Dec 2025 15:21:14 -0800
Message-ID: <20251225232116.294540-7-shakeel.butt@linux.dev>
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D39280004
X-Rspamd-Server: rspam04
X-Stat-Signature: gs3eqyo7iuye4q9rn858u5ettkgpwx7k
X-HE-Tag: 1766704949-461491
X-HE-Meta: U2FsdGVkX18nhKoA9llUmjjeQTpF8kk5curvia6s9+BV9IM2hmLeDAKSC/YVVdnixVCTXmTdYSb932UfogU8phC4hsV9909U/b91lf7+vfKp4ZbNs9k/L+uRw5SLan1fBgA7ba3C23UvNS26OrNDPoqsDo3WUVgTM6WWbZFgJFJDh4sTcEtafptGXmTCX+YAnuEcdw+GUS0pXePrh0u553sG2gg6s8qZ6Dm34rahSD46hYe1Ijd1lvaGWnVE0fl+oCVkZibQG5sDQxh7PcqxvrzqeWBQ4oNXrVbNqop95Bhxma3uJHwDYMTGeKTn7cJ9nqkDkOESnOlzoG0ymDLKddFkfmiuyIhjlr8hpzmfGyifK29rXQ7QPMatokpFe89bPckvaRd8kapXUZHkjCrYhr458w5lOsY6Mtcs+Aj4mueNuT/sJcIwLDGWEVl5ssOJH7SUveutl/JQrzJOX9LrAqO40ukD22wmCdz5iJSvhkw/1+M4UAmHEx870Ve7VlKbUo/F1GjfFjAHUZsEzsAhU1+0OyITc2TcsQd5uS+S3s4QtY2MqBPFBp58QK5NBOsQju8uTJQgesVfUE2o64VPLBmaOOajdVLVpkV2a2tW0WicjHqdez29oS3f9+jC/wYVMifTQoi3qgdGDBWe3zRyzhgMCrQBtHkfHqDjCkTypj7tdI52xUe+WZJIwPbIN3sobPkZv6xch47YEoEBFakM86Gnygrk+tjqUHOc8VhrUV86L1AZCKJhahrOQ2NOL1RKnD+1SKIbqtVpmWpjCMRbwhX8tbKR0c7V6UEydk6L/9tw7ob+czCWapXlTuR3tASWWCyOp6dfEEGrx53orIQXdbiHRAKhgM0DuBZIdqUdf4Ee/GY1Ae+BzhQpO/q7M4UiTNfFnY4vl9m/DYn8UlRVRer1Pr7l1JCo+jVQkAVa5uVGx8lbndEoaMFbFOJG5d6xOtmYPEY/HgM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The LRU gen debugfs interface was using the internal private memcg ID
which is meant for tracking kernel objects that outlive their cgroup.
Switch to using the public cgroup ID instead.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/vmscan.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a4b308a2f9ad..d78043c7e4af 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5426,7 +5426,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 		if (memcg)
 			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
 #endif
-		seq_printf(m, "memcg %5hu %s\n", mem_cgroup_id(memcg), path);
+		seq_printf(m, "memcg %llu %s\n", mem_cgroup_ino(memcg), path);
 	}
 
 	seq_printf(m, " node %5d\n", nid);
@@ -5511,7 +5511,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 	return -EINTR;
 }
 
-static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
+static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 		   struct scan_control *sc, int swappiness, unsigned long opt)
 {
 	struct lruvec *lruvec;
@@ -5522,19 +5522,12 @@ static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
-		rcu_read_lock();
-
-		memcg = mem_cgroup_from_id(memcg_id);
-		if (!mem_cgroup_tryget(memcg))
-			memcg = NULL;
-
-		rcu_read_unlock();
-
+		memcg = mem_cgroup_get_from_ino(memcg_id);
 		if (!memcg)
 			return -EINVAL;
 	}
 
-	if (memcg_id != mem_cgroup_id(memcg))
+	if (memcg_id != mem_cgroup_ino(memcg))
 		goto done;
 
 	sc->target_mem_cgroup = memcg;
@@ -5601,7 +5594,7 @@ static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
 		int n;
 		int end;
 		char cmd, swap_string[5];
-		unsigned int memcg_id;
+		u64 memcg_id;
 		unsigned int nid;
 		unsigned long seq;
 		unsigned int swappiness;
@@ -5611,7 +5604,7 @@ static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
 		if (!*cur)
 			continue;
 
-		n = sscanf(cur, "%c %u %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
+		n = sscanf(cur, "%c %llu %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
 			   &seq, &end, swap_string, &end, &opt, &end);
 		if (n < 4 || cur[end]) {
 			err = -EINVAL;
-- 
2.47.3


