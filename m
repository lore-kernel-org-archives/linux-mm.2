Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7E3C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 14:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C009E6B0005; Sun, 28 Jun 2026 10:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1646B0088; Sun, 28 Jun 2026 10:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7316B008A; Sun, 28 Jun 2026 10:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE096B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 10:31:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9B371C144C
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 14:31:39 +0000 (UTC)
X-FDA: 84929559918.14.BE9E5AE
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0E9404000A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 14:31:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iLwALtkn;
	spf=pass (imf17.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782657098;
	b=0zbFj8FgG5miyZ425CmT8wnyKKL838SiRFRddfgzFosaHj7lzmaMya3LdqI1KumvTOpyiX
	wWJDXxd4KLAMjNOGrecibdILbdyRBJs6hsxUiTidC+F/Lch1R7cTBUKR4KKMp7BFdpdJBP
	nn0PiEQ9mjl27NWhz2RhJMWi/JvFW+s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782657098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=giQ5JZiMBc+levHSGoNxfSkMTUQ4CST11ly2JfyN3Dw=;
	b=QuuSF7KQEO0NINkcLdt77uNCfIHOnSQLRoslpI2Kxj3N5uo7CJAaSB43TK0nmWq1mxa295
	H0VFZmlRefyr+727L8bShlr2d8umQLmEVwoys5cf8dFT8ZPC2tw/U3r6n7EhiDhm9v1Kaf
	oZdtV9xwO+G4TG3V1tp3YavQNpAdQjQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iLwALtkn;
	spf=pass (imf17.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782657095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=giQ5JZiMBc+levHSGoNxfSkMTUQ4CST11ly2JfyN3Dw=;
	b=iLwALtknnxAdMMZb3J5Y0+N+4RbEzF0FRS4LcT/leUorBVKJsQQQeZ7RDQHy5dXOl2Pujo
	0lh0UN/zvE8ThNEYgSUDYtNdd4FJnoymm1ShXTqMpeO8Czgl3r+0zgRs70vSyioI9erYvf
	Ft/gB5iL6rP6+iuSCsGliHjeZSsuirU=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	dev.jain@arm.com,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: hmm-tests: include linux/mman.h to access MADV_COLLAPSE
Date: Sun, 28 Jun 2026 22:31:11 +0800
Message-ID: <20260628143111.36863-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3b64pdx5p7g47xhbn1ifmtoeskp4z9f3
X-Rspamd-Queue-Id: 0E9404000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782657097-179675
X-HE-Meta: U2FsdGVkX18E2c8zJ1x8o8HWHHKPl4xWQs3UETE2oy4NGKqWlWdJHEWSVlZJp4W7wINiZ4WjTwkpgPVcjhVw49SZ5R+bLKmNuvOjTnEZmWFYfL3wqQEQsbJ3HBgRMB4nrqthzjYJo71ohswZzyMD+vja5tesK6KKMBgGwRKXJZVru/LZNwGjsZw5/vdpGag+T9MV9dHnebd5/hQHxifT6S4u2yihxaWFiotuRBeSQ+MJUOCiQEmOWBfrPRB6D382mr9g+Sj1kiC5/y7zGxaptLTTvlx6apPGuAw6sBiE8jQnAUJ9bDYqjI3dmAH6UdpVeSRBFIbvQg1rHSRaBaBbDslxHwI0DNXtOCXopX3XvI8QJvb8M1PWcIYCUl6Csp6LLIa2dxxPu8wwSZYzBGOON+1cWYep4AXXf2moUE0PNwwMNqZ07iw5g7Id1eJlfIbQcF1SEPHFxugvCjJM3T4M4We0B5v8fpKcgn6FeWhcuzcTUYC0uxcWtrpF2p5vjjlMycJRtYs26IxY+a4E+bsO/B/hIZxEf8AOB2q57xpDD1yK7K72hNilgf6wXPi4B1oZpCysaI0KY0zgLQL6Hwi/Ar/gAuDnNUEaZGN0XQdwC1cHJ3RLUdaVQvs3YTPdJg99Q80zh+MFDEgiYq4fph5/0b29f0wb5KbrwP1hzmN4Te4KrUbU/hP8d3yVaEuAo1rDjjKKp6Qgovp09isUmFkILHmzF2e4P+C+JJ4/XrOFMezxqpV7BiG6tUqc2VlY9Sc+wMWWzuEVNn8u412FbjptmfAp7yJ6qTg+8xxwp6fPZrw/RngcL6TLwohFMDo+mkeehy0iiOJT5aLJCzpHab/99uOzkjsNEYNRLupxRQ/KaRDNgPBoKlcyEnDtyrrtAgwUtm8gzSy3R2Em0w/txjwQBHULvea9OziPFiLKImd7rjeDu20hkUTv6awea0TUyRAoAbp1kCmgVQVOV4nU6ca
 5JS2584J
 uGsf6qO7Ilk0I/C1PWR6QkbPvkP+HX4JsvzaDAmsQHEZ+rIQbo2lyKe18wnpqpTuVwb/ux3WYe+fKCVS4mj4M5tQPYn3iMPMdtBNXzXrW+Zl0ED36ip5L1cCW5bHTDgg65vYtLJOsrDmiE11fvnxAUWKwFzlmUasz3t2w0ApUxK4uVTu+MDH1g2Emwb3BRHkOzrqHyzPKupr/Pg1VZ4qPZ/BSeQFzp3qBl7P+m5tP1ReXUdYZtIDx/0vN8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following compilation error occurs with an old version of glibc due to
a recent commit adding MADV_COLLAPSE testing:

 [root@localhost mm]# getconf GNU_LIBC_VERSION
 glibc 2.34
 [root@localhost mm]# make
   CC       hmm-tests
 hmm-tests.c: In function 'hmm_migrate_anon_huge_fault':
 hmm-tests.c:2355:27: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
  2355 |  ret = madvise(map, size, MADV_COLLAPSE);
       |                           ^~~~~~~~~~~~~
       |                           MADV_COLD
 hmm-tests.c:2355:27: note: each undeclared identifier is reported only once for each function it appears in
 make: *** [../lib.mk:225: /root/code/linux/tools/testing/selftests/mm/hmm-tests] Error 1

Include linux/mman.h (which provides the definition of MADV_COLLAPSE) to
fix the build error.

Fixes: e3d8707358ea ("selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries")
Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/hmm-tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e4c49699f3f7..2f2b9879d100 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -23,6 +23,7 @@
 #include <time.h>
 #include <pthread.h>
 #include <limits.h>
+#include <linux/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
-- 
2.53.0


