Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4ADECA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780859000A1; Wed, 13 Aug 2025 10:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73086900088; Wed, 13 Aug 2025 10:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620169000A1; Wed, 13 Aug 2025 10:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49E7B900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:58:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 129411403BE
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:58:02 +0000 (UTC)
X-FDA: 83772039204.21.9F3071A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73E1A20004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:58:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=I3u5d4XV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=BPoRvRPO;
	spf=pass (imf03.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755097080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LK0fse9piQMDsNEawnHa17CJtTGb1+S7lgjGFKtF0tc=;
	b=e55XvsKRGRv9Tya9RGyaBIMDkNp9hVJjdBHAqj7XgCjDCpJ0c+ZxzINGHIJG/Ie6HBtwSW
	TTX48VaTr4NqfXJKY/JNBvH75I2uwiekN75Qj3ssL3Ynn1v6LQ0yvSMCsEzb+h+K05yy1Q
	N6YHAV9QOyzRJdreYf/8KOxvaLwNq24=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=I3u5d4XV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=BPoRvRPO;
	spf=pass (imf03.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755097080; a=rsa-sha256;
	cv=none;
	b=lOQnSSsFPxcc2YlP8RLM1J4AgSmd6LCMx8zu+vIerfTFv+sPmxEY9ypzohRgESyeOo/GoS
	Vet5bU8Oz0FHRFzqhyC7aHZFMxAUMuD4SrB2fPDPXcizWEyF6rPLt4iL3QDT9huyCPReIG
	KDDfmTkBwiru5P5w25mJzg0kTpymJ7k=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755097076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=LK0fse9piQMDsNEawnHa17CJtTGb1+S7lgjGFKtF0tc=;
	b=I3u5d4XVCbp9sJAiqzUxxnN8jogvVz330rmXlvPc4EIs9kOtcf3Mj8uSjIxg1fRTrbwecl
	TMhr5g/y26FthJ72gtEwrU4u6dRhFhPmFvZEuofvCR2S34BZx0XaO71/N7GdY3Si7KdKQH
	rRll7+2m0QLENvmItC7EZWe2cT/j1aiQ6gFxiMmD1YFmNrWvCltHacGpPwgXO0KxHf97IA
	wynDG8BsBzIwHDNhNCP7ES+PQV4KCfRw73ymS0am7NjJRjrB20+Ua//P3TMmK8Xia9SQNY
	/xlAJETgVH3RXlHC8LNh3uYz9R0F8OR6g5b5Bwckh4QWwwVqXxslL1lpiee33Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755097076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=LK0fse9piQMDsNEawnHa17CJtTGb1+S7lgjGFKtF0tc=;
	b=BPoRvRPOD4TmXUa3bcE7pvCwZh4VhvmvEvaz/Zod57Zu5kVP4MdtmFgc2nUPCdQq1DcUDv
	jEKTQlAF2z04ZwDw==
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] memcg: Optimize exit to user space
Date: Wed, 13 Aug 2025 16:57:55 +0200
Message-ID: <87tt2b6zgs.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 73E1A20004
X-Rspamd-Server: rspam06
X-Stat-Signature: hpm781uroqqg8uxnbw6e5zyjgxr6qjeu
X-HE-Tag: 1755097080-658933
X-HE-Meta: U2FsdGVkX1/gJrMULds/CI+9aAh5/R5x3T/1Ck/QgR6CuEewrTOJxoMkaz7VJxjsgwzqCV6o4vOBOrG/SYjeFYaO7rT6Lgvear/BcxBFAw7sMOTZWDZGDZQPUs6DeNAQ9PKOIYHtZttYNG/h1pxEfEMdJeqcgOacB+E3KN+eajVn+wMh61W6IdNZpLYmhCjs3TbFq/z3kaC6Sd8wds3KUV0xCK8K0FdI4SKcM9qRhU/nIYXy/tyD9NoI9147GxBFMN2RYHYQVUd4w7BNoC4aZpmDx3LMnIQSETCkewhdcQcciat2JSwpKdQHNRWptkqqakmVBTuf7hsVJtruISt/yvhBnE9F4n1XphbIULX1JvJTLVxjjh8lsxj/PYwnTG1gOvr6kEtd82PBxpaGoZ7qo0es4aaVCrMPgTfmZnlu2UOrvuugihixTTg1sz+joq2XlDL2IeCWIB59FkjGuxyHVBYmQdN0yjAvYOOAV21tM0qqksY5WcSy/PjVFhimyS/aO5Dz5J3XXP4EV910l4Cd6pLQR3UJSExsekohGz88x55lTIHKkPXoSjqy1MLy63LV70vDO0w52DD/vNV6dP+dB3XR7oVD5jqu7r0W4nsVeaGPd6PrCPR/hnonhRIEt1xOGkGLHN6vfeUxzJVT0QAJtFKQWHICIderIywLcHUqWmo7a+p3L64q/tp2hWaly9zu9P5RA+isdsSfnTDATjd2++V6lhfd4XcBLHCRWf8xDw54F0h3aZNdne34FGiFGjWeC+zCXAbNGWohComa4jt2fS4NZeAZniClODg37AstkrRwUoThoTXE0oeChra32tLp4XQeyyefAohBtpE5CR07mQlMdobOYaYjWMZUsvFhW36a9QOB1ARllVjJdouSb0M2NJ4Xv37Ng+JFo32rfCmUOyCLx+lwPyyyvh7aW9SyFw8xXWaQj691+qRtUPLG3XlYoMnlZM5tVJxGOUNe57V
 D2megfzq
 ynMsLUCe9ZByin+/3pWNHgs27Hk5mc+bfvFZQ5w8pqFrTo+kLNQgLEMVBlaFcEx2qsEDWWtCf4XfG2BoZEStvPDx77zbl07uYd81y0W7MB5AYOU1Nelv4LYkyXI/cqwFotrQUsL6WCzh6Ewh8ToV+VV1QrcJYhKYjQnTha+hHvYgp62dYUcq5DCfso2J1an8hhIAOFMW1XGK/taq615OhvNMtT5JQzxOB7acqidyD6moW+voAjxcjV+BEBiV9f2oc0RwsgdqK+TWvvEAbgXBKtwOlpMQOxXUBP9JM03/1g4DEdh+DnSPpT8UdL7/M3nPRE68aDnKDML989oDWGUAX0Lge9h7UTPelKFqpH+wyPWjFOOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg uses TIF_NOTIFY_RESUME to handle reclaiming on exit to user
space. TIF_NOTIFY_RESUME is a multiplexing TIF bit, which is utilized by
other entities as well.

This results in a unconditional mem_cgroup_handle_over_high() call for
every invocation of resume_user_mode_work(), which is a pointless
exercise as most of the time there is no reclaim work to do.

Especially since RSEQ is used by glibc, TIF_NOTIFY_RESUME is raised
quite frequently and the empty calls show up in exit path profiling.

Optimize this by doing a quick check of the reclaim condition before
invoking it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/memcontrol.h |    8 +++++++-
 mm/memcontrol.c            |    4 ++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -900,7 +900,13 @@ unsigned long mem_cgroup_get_zone_lru_si
 	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 }
 
-void mem_cgroup_handle_over_high(gfp_t gfp_mask);
+void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
+
+static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
+{
+	if (unlikely(current->memcg_nr_pages_over_high))
+		__mem_cgroup_handle_over_high(gfp_mask);
+}
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2203,7 +2203,7 @@ static unsigned long calculate_high_dela
  * try_charge() (context permitting), as well as from the userland
  * return path where reclaim is always able to block.
  */
-void mem_cgroup_handle_over_high(gfp_t gfp_mask)
+void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 	unsigned long penalty_jiffies;
 	unsigned long pflags;
@@ -2486,7 +2486,7 @@ static int try_charge_memcg(struct mem_c
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
 	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
-		mem_cgroup_handle_over_high(gfp_mask);
+		__mem_cgroup_handle_over_high(gfp_mask);
 	return 0;
 }
 

