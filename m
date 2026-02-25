Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83024EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43866B00B9; Wed, 25 Feb 2026 02:55:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00646B00BB; Wed, 25 Feb 2026 02:55:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D441C6B00BC; Wed, 25 Feb 2026 02:55:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0A7D6B00B9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:55:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83AFBB8EE7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:55:01 +0000 (UTC)
X-FDA: 84482218002.18.96C5FB9
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2D13C0007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tle46y7d;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006100; a=rsa-sha256;
	cv=none;
	b=Ct3Jagbj81ZJzysyUR6wCj2lHSTMajYd7KdZL4debYcChOtyaJOmWhsfBF+EJqQoG6vpAx
	uNJlBeGkME+SOvKODfLxettIpde9nIQCulxj+S9mBVb8kCHfTZl9IUZ69zKgBSjyv4mB6U
	jNUsNjXcF695Cl6ThPVghM5ZlytfXMI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tle46y7d;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FlmauyfzMJ30WpiQCMliVOAMipux2gAWQ7/AZwbz08=;
	b=Ul2dfePWma7Sq10Z1ajwYK0utWcdQ+pSXRsrgy/tIV3qOZjeNwrbaB8O4SzV2hIsFwVOWk
	MsxSYuTMSqyNG6JOBZuZq2JNbc3S9FEDyVffYKY7vTtry3gTd5DQRs2yC2AsGTlXB8Okpe
	ufViARD6LI9pj61Nai9Y2fRF3qHUdG0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FlmauyfzMJ30WpiQCMliVOAMipux2gAWQ7/AZwbz08=;
	b=tle46y7d9kpYoWp6mN0mjfokD8fL+rIjd2+QtkwlVOIykASwxMaLLCVFA8y7YQFZgxCmax
	2dDyGcyd0b7Yif8LBIthUvv2UVBO1nf/20x50SR2qOAcZY52F43E35EmlD0lQrkgUa2DjF
	t852LCK+qY1BZyxlVhY8cYjbSnH6SvE=
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
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 21/32] mm: swap: prevent lruvec release in lru_gen_clear_refs()
Date: Wed, 25 Feb 2026 15:53:04 +0800
Message-ID: <986cd26227191a48a7c34a2a15812d361f4ebd53.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D2D13C0007
X-Stat-Signature: nztx5iddpr4i5ya1iyomahwhnxkys4nu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772006099-952428
X-HE-Meta: U2FsdGVkX191pw3taBzTS+L9EbyOAdkSf5e5hS1GcqkFSTDP+0y0D4Rwhdr2rUhM0RaFXikyOYZmecm9stsMO+9QkB2Wz1VsoPiK1fpP7UD6rVJ8M9fbzpRhKYBzejjF89ZjrUiBEJx61e71DL/IfyVrSyLmrxS+zMncQ0mOioajTJ3xHsLmYv5Lu3rPYURsQ4XtXpvd3QQx6hv6dVpaZ/zz7CYGkMH3MFNwP+pJrSzlObKy95wxa+eJeFoxfNSdzPnvxjrmIZWykgeUIr3iyr8UcIc7sB0z9MbQezh7cqt0e3peXyUB/m2dg/9O32LEylkF7eSXHQFeCkpUnL6d8BWf7OpWvbtnOpzvD7gfwY9RC8ttdy7L1VC55LihDRn03GMVu1Vnmm8rQF/PWPHDtsIPoN9OE6atez5q6B9a5uk8cc6jn9cQKzNLjC4f52I7uV8aZnwpUDdkxd7LAdsOPdKHsy4zwChtggHSXRIPd54oDdbUxu5K6aLhtVjP0Q5QZSlKx2xGTIzlJoxrYQyKzdQxZxjoABpW8Tv9yCktKSTNnPGVoM96bBgM39WDFtvKsIfrb4TWTvqB8x4FmhEc2y/hXOGEbJ6KY9HEi8n0w5YhJtOtXY5eFWm+1GpajB/VKZsrYw3xm54dYIUeDuMdfrEZV3+qZMu1KAegJPw3ZJIu8LzkL1RyEqt9dZuf7tg4IjTTTW54JKEopzEujhM5IGwM2jBpJqj+IGIpvrvIZ6eq87VtR6NXPBRHWLDl/+UuVOP7zNpphPAQN8xS2Xs87/FXp5FFfYjnzcHuAvMMViN2scW5iqfGdlGOUlTIe5nO/yAtBwJVloUxb2ub1sIDEWRTmH0ZhuBFExwXMlj2u0i15v53FW60NmgeI9HIwqmwO4pUqRh8yqDilW/t4Cgi3kCgKr+BCGUaYe9oFP73hdJBnjP63MUSa7PKjdRnQPaPh1sKEmaUuSHdImHMXTR
 PEiGiT/s
 zVVx+OdAXxPXuxhSt110lYGvtrq3R9hq/QocXfK/7Y1wjk+KBw4R6y6YQ4xxs5ZMSCKgnZEeGHB5qIj4lsIwOG9OdF2reG3so9iwawt24MFqgh0SKZb8GNtOpN7upoEbFli/haya/s9bup/cWqZOW57VOTFoQ0yp7lDYCWmxwafiyOEmIN+jEzIAtM2dmqVcIO++xlNDdmks8oOzU4ZvT8Qx9kAWbybOUtZ1Dqd+gSmvTh6s6VDXgCMqbIDX53lvXVYaofbJq4lytUgwz7XplPCEQOC4mAB+n284RNwf2qvvBdXTvzIrdbW/BSRmWxCcx4Bn2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in lru_gen_clear_refs().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/swap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 245ba159e01d7..cb1148a92d8ec 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -412,18 +412,20 @@ static void lru_gen_inc_refs(struct folio *folio)
 
 static bool lru_gen_clear_refs(struct folio *folio)
 {
-	struct lru_gen_folio *lrugen;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
+	unsigned long seq;
 
 	if (gen < 0)
 		return true;
 
 	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
 
-	lrugen = &folio_lruvec(folio)->lrugen;
+	rcu_read_lock();
+	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
+	rcu_read_unlock();
 	/* whether can do without shuffling under the LRU lock */
-	return gen == lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+	return gen == lru_gen_from_seq(seq);
 }
 
 #else /* !CONFIG_LRU_GEN */
-- 
2.20.1


