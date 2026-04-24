Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED45AFAD41C
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6006D6B009E; Fri, 24 Apr 2026 00:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D84D6B009F; Fri, 24 Apr 2026 00:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5159E6B00A0; Fri, 24 Apr 2026 00:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40E9D6B009E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:02:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED941C2B5D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:47 +0000 (UTC)
X-FDA: 84692103174.20.31DF3FF
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 17CD240007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U5fjPqF+;
	spf=pass (imf27.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdU7Rewe0JBnvI+IPS10alBnrpSA6+jzICgCf1+ep1U=;
	b=Y//bAsZH8aQygV5nJL+VXYiX9Y68n0Eq9XNKiJhCY+fYtK2Gb+/aJF3Cx0ey/b5zt8rym9
	rFp10I4gVEIBoiUutRjTjU/+WpwTYQGm+8ekhNSsr3T8W02gHwfkFlFyrvNcohUxQOdaz4
	01MZh/YC0ehBe6paGMjlFpV5nydYrEk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U5fjPqF+;
	spf=pass (imf27.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003366; a=rsa-sha256;
	cv=none;
	b=E+FDfxEU/NaFe01SHCXK/6wV2ESH+wShfQIn/Ql2dYxdoZnWYq/xR7oCT/tGYcHVvWzEo2
	lZIbLtJK0hfE1A4REb2KHG3Zbmt/eFoFbvhZdvJBCdYdm47ONEuPtAgqwSfsRyVIkD79kr
	T2HQfsMxqVTW8rwvsjiP3yaqxYnhs9w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FdU7Rewe0JBnvI+IPS10alBnrpSA6+jzICgCf1+ep1U=;
	b=U5fjPqF+pm76sZZaxN+3woOitsl6wVvsvP9t/e4ULmjo3veM4lWVgJjWTRsEplnE37Kr3r
	VQ21e7PjO8fKU0qLT1WAdg6kCaUmJOW+3ZFViARe1zenaAHAUlZpmIDPKhUC+f0r1E+rCm
	jDJmH9BVwhZ/Fm7ocQQR/R4r/AHxTLg=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v7 7/8] selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
Date: Fri, 24 Apr 2026 12:00:58 +0800
Message-ID: <20260424040059.12940-8-li.wang@linux.dev>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17CD240007
X-Stat-Signature: tapoabgcws9z3xanyhd1u6demtzzin8u
X-Rspam-User: 
X-HE-Tag: 1777003365-424927
X-HE-Meta: U2FsdGVkX1+9em3+kOOqInO3p5HZrpx2jVX/iSw31dm8qXIm9v5iA4xS6cjblF8CZqbJeYrnIULGL3qA2Se2udLrSrjsRj4Wy6lou7/tu70lIzhJtu8k7n/qn7FqvhMemMefUHPvMTaXc3US3v1XSy0QxVh4WBmFi6JimX/cM+6tLxTTIZM1gu2qAFp6DlMHRs+UQ7J9g4clc/tXjWP7ZRtLRbetAhK+ctkB1u81G+m69w5kjFqm3K6ZhhpvANJJXVp2VW2FRDPwY7zp6ck3UKgGT1CWh4FEqDH6Fe4OCjoza3yJFQ7VeL4wuUUvkhNRGuJ42sCNCcehRhkx5gmUASdDzC/1ejrbLp3yzgBoHE8jB4nGHYfPW3HKX0YLCW5SihWZKjjPDPqLKBsfYjyVj9CfYjBMUhZyCFiBJZItOVZBS6UxugZnSxfRgju4miX9uvEq/Bo+v+lru9Kq/R24KVYW9OnDJDKQkrew0w7xqPGZH/Zg2YBfaxpADfxL4NnLuM/X8eRzugpU95jHO0hm64+OOMz54OtgxpwRZSV6ztZDPtFh32Udq+8Gkb2N5loZEtQXx6vQ8NTdWm4GHRv9tc3RDo88o9kPna8L5XqOKeRCbrFanjn4c7VQGuINFhV+F2djccskAQy0qxSEAX5g36/PYWSjfRSDWQ6dicXVjmoiHMEEHR9cYVSnEdg0/4PBHCrS/vW76c4f7G0sf33X1E4t1EKVprcJfrl7U0LLL7GyvT/3Z8mmlxzmA+LNCzHK44bVnyyy1Jx15p3QKt7m9B5PTqMSYJNSI3qMb7y3sHYpTSzLR9F8c2vUkTC8ORI8XYQ2HCjHSMN3pNVLF2kE1er4LiOkdN8TPUw/V/uOwOt/KWTTZdwZ90WMcIWKh/X2VMbkTE3rtnhi1F8RcC9ZANHEUmiDAxxFzPTKXTWySz2edfzH5YHb01hkeLtic0Up6etS41z9Ju5DJKwMwB/
 grMJHf0o
 I22eo6FEePEeRVOJ84yOYPqq+xStiKw7GEbLkkW1uva9U3ys6+x6xXPKPn81Cwd6FSZL2Dm5KeOdnWtPkdnXA7MG5dQRGyLQLDJHbNNJwMMiXDfB8uCcdEo0sTo+DcZU64O8whuFVFprMUJc6NG1bjo+m6voElRXYLcGOqCW4mkSJ2MONDArwUy+kR0GY5Pl6GORgjMiTi1xMqm7m+YUoaaB/nUWMqiVaWybCmnHucwI8sm/VL4s2ojyhxnERPS2HF0O7+6UNBDLQCTO8SUw1Fo9KwqFh2s/j8ryJiC+ebaEuyI1pYxf5upcfeXw1TJZagkv9BaYy2gKRaV98zP6kPg4+dSybTjjJvDmvwYMyoWIWOTnI8rLE2NEuZg6gBoKM2BRew0X/dZdpDA43Pu6cRVzOrPaSY+wdj30mM87DnILuCv4WllWgVgSdkbeyw0bVu2H8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K
page size systems. When memory.reclaim is called, the kernel prefers
reclaiming clean file pages (binary, libc, linker, etc.) over swapping
anonymous pages. With only 64 pages of anonymous memory, the reclaim
target can be largely or entirely satisfied by dropping file pages,
resulting in very few or zero anonymous pages being pushed into zswap.

This causes zswap_usage to be extremely small or zero, making
zswap_usage/4 insufficient to create meaningful writeback pressure.
The test then fails because no writeback is triggered.

On 4K page size systems this is not an issue because 4M covers 1024
pages, and file pages are a small fraction of the reclaim target.

Fix this by:
- Always allocating 1024 pages regardless of page size. This ensures
  enough anonymous pages to reliably populate zswap and trigger
  writeback, while keeping the original 4M allocation on 4K systems.
- Setting zswap.max to zswap_usage/4 instead of zswap_usage/2 to
  create stronger writeback pressure, ensuring reclaim reliably
  triggers writeback even on large page size systems.

=== Error Log ===
  # uname -rm
  6.12.0-211.el10.ppc64le ppc64le

  # getconf PAGESIZE
  65536

  # ./test_zswap
  TAP version 13
  1..7
  ok 1 test_zswap_usage
  ok 2 test_swapin_nozswap
  ok 3 test_zswapin
  not ok 4 test_zswap_writeback_enabled
  ...

Signed-off-by: Li Wang <li.wang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 8f0478923bd..5fe0cffb557 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -268,14 +268,14 @@ static int test_zswapin(const char *root)
       This will move it into zswap.
  * 3. Save current zswap usage.
  * 4. Move the memory allocated in step 1 back in from zswap.
- * 5. Set zswap.max to half the amount that was recorded in step 3.
+ * 5. Set zswap.max to 1/4 of the amount that was recorded in step 3.
  * 6. Attempt to reclaim memory equal to the amount that was allocated,
       this will either trigger writeback if it's enabled, or reclamation
       will fail if writeback is disabled as there isn't enough zswap space.
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	size_t memsize = MB(4);
+	size_t memsize = page_size * 1024;
 	char buf[page_size];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
@@ -313,12 +313,12 @@ static int attempt_writeback(const char *cgroup, void *arg)
 		}
 	}
 
-	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/2))
+	if (cg_write_numeric(cgroup, "memory.zswap.max", zswap_usage/4))
 		goto out;
 
 	/*
 	 * If writeback is enabled, trying to reclaim memory now will trigger a
-	 * writeback as zswap.max is half of what was needed when reclaim ran the first time.
+	 * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
 	 * If writeback is disabled, memory reclaim will fail as zswap is limited and
 	 * it can't writeback to swap.
 	 */
-- 
2.53.0


