Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A54D7E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A84B6B00AA; Thu,  5 Feb 2026 04:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169596B00AB; Thu,  5 Feb 2026 04:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0746B00AC; Thu,  5 Feb 2026 04:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE8E76B00AA
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:03:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B96CB14044F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:16 +0000 (UTC)
X-FDA: 84409813992.04.E61E7CC
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0FF0980013
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QBVYfQQe;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkC4ZVvRMLdyP21ROmg0kuk5/4rFdLy2Jo+Fn1857AM=;
	b=74pdBTrW02xniPXjfN96MVKwzwTcx48FXdBaXzPtQjVDsIFwzExTiZHoxfsHOBi8NQpJyY
	jcM0ReTOaNLTLKnC6ZIrc/Wd655tuK4dvxQciUy84XD+kEIYlxatyCWvm5BXfIhn+GlcTJ
	o4qnoidfQMJILBWJ1lCcTmFLjqyrLIY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QBVYfQQe;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282195; a=rsa-sha256;
	cv=none;
	b=h74MCaLddeRsrbk/k52YGyxFhaOh/mgt1EJq7+5TuTm4mdRgzDW3yobvbFeLWuwyQlkFcT
	LfrUjp3J/1zxm9FCN7oPeYKZprawXPLNXCSkNZAAe5Sl4cTvSYX5BwuJ2aMXIj9PGbCi1S
	eVPatHw8R6xv+16Zo0RgMbAwoYeClM8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VkC4ZVvRMLdyP21ROmg0kuk5/4rFdLy2Jo+Fn1857AM=;
	b=QBVYfQQemftff+h3MW5wPhwO0xVI9V05+Q13myFP3gl3u7X/2oP6J4G2p66a1GmwqzG/nA
	3jtMRqZ0Nh60kZSfMtG75/Y9rQBAHrZwrrMLQXZLUJGvW3aNftz/lULQepF9Q3ftu4W5pp
	AlQ9yCRwZ77ZFQgyMK+rzSb8FF3KWDg=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 15/31] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
Date: Thu,  5 Feb 2026 17:01:34 +0800
Message-ID: <366517642ed7dd6948621de101fa592450ee2c3d.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FF0980013
X-Rspamd-Server: rspam07
X-Stat-Signature: d85xs57rq71dodt6fyxpc96we9bar3zt
X-HE-Tag: 1770282194-737002
X-HE-Meta: U2FsdGVkX1+kp2s9ilHT6F6Sl2xr7i3SwNClOz+bvztg6AilLvEjZ5sdUN9GQaAjazCXEyHt1VPqWuvt/mFK+ACaZVctBmTDnCXelxyJn3fzi/8Rgr3gLzdf8TvZ8PizcN205qIlSWj5F7FFPoh8lCcezflk8mrsk01rypbohlP0OPw5t4QpmI7sDXk1jdqARmXs5SrKWqDGEGpM/Iw/Vn7cQdvbXrlVEDs+QU77EoDY0swnQFz9XJnKHLfqUzQbmK9hlHN4x7AyiLb3ZDFuQdNEgYP6PdewOU9+SS8mqxVZAMoLIRQkwtasH1/rMRYMf0cOQrUxEVbFaMSKDytVcHQw7pTAQUr9eYzD9lXqZnapW389S9ypq00o/GMCKnoEEVM5yKGgaUNnQ3uIqAdeTz0UnhWMGwrqBshQNL/5pyKHlTHitRlLRCIl9X6fFExuPGrSIkN/pRSJsYpQHuBv5B/xnx1Bsp+CJGT4oTfUWXQHGmscr9lwNPEZXBdgzlKbzPAPa9mYYuPJZl+QvRFrroPTfM1TddWBDUyIEG2Y+eSFb7txeTdRKUk405wJJlb0bmfr20fC+iWvLdtd1sXyRx/NhqaWJViYNl4WtFj27psKo3Za5v8JedSusqsay01zQu/0zpor1VMyZ1iGrnyDCudW3YvfpGRKk5pUgHH2LtcmG56YqOTxuJwZbfrOykHdW53XSzt3I1gThci2CxqEy7YUKcofOpODCTzFORp+Hz3KSA35dHbtSxptJadPgOBgmQxvd946gxtaldpBDo5SPodCdBNxrCiOeK/IEPuQEG4Nc7a7YYr02FIKSdItoEx98rzvMpxf/ikgsI5HOINOLXgXXJ50XpwhqAjdOeD7wBXDeJ5Me0hQWvIjnZXMaewUajdaC/JSVq/ulvIcaOo0bT9jT1plTi8qUK3tbD8jOxXJlNc5kvdelDLTba5AV+JY2280Stz9j5uVoo599WO
 78vfnI0e
 uE1nvl3+1UkBQpTO7aZ4l9Oinbn8VsOhOvHXMgERrQLPlphep8r2YmMOfhI8a5GSGXZjXB1KdPlK84OEYthGoYyYDPMkAaMTMu8LSAYmAOM5EbOpn4mtWx+7FRaUWmPS4dRMFpRF7q/HuOOkbXxslWiJXe9wUTriQBrY05kOoTKnPvYsl+Rj+b1umjTJH+m0Jg2BWv/RsDUQP1OEjTEmppJEs7e8Grxdmc+FL/NCUDylw6NDzyZBPKNF5kXDbBOBe3Nr0aDJ93M262xm2DgfB+hDU3M0y42m8sBxRc4wklcRvYopwQl9bJ4BgfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in mem_cgroup_swap_full().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5508a4aced0cc..641c2fa077ccf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5283,27 +5283,29 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
+	bool ret = false;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (vm_swap_full())
 		return true;
-	if (do_memsw_account())
-		return false;
+	if (do_memsw_account() || !folio_memcg_charged(folio))
+		return ret;
 
+	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	if (!memcg)
-		return false;
-
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
 		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
-		    usage * 2 >= READ_ONCE(memcg->swap.max))
-			return true;
+		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
+			ret = true;
+			break;
+		}
 	}
+	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 
 static int __init setup_swap_account(char *s)
-- 
2.20.1


