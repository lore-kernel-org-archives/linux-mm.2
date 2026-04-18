Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 341C4F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993A76B028A; Sat, 18 Apr 2026 07:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A776B028C; Sat, 18 Apr 2026 07:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881566B028D; Sat, 18 Apr 2026 07:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71F406B028A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 390991604C7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:16 +0000 (UTC)
X-FDA: 84671382432.02.EB90974
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 85E50180015
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TaDoVv14;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocTnSYy1KxNgPzpQMQrdurE88Vv7eYufvdv32EmtaKA=;
	b=2OfBRVvOvLPFV3CHVVgM78NchZYSm0P3F1pzmU4GPdW8xzE7UkEnbghJO2cET/SZGFAAG3
	2zvIMv2j5PwOUojs8UsFQ9w/n06zOHJQbz85GypSulb6NyDaLvL/806sWkiZtfNocUN3bY
	QITulHfYXPNLMDHQ/a4IMpaBZFhjzms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510014; a=rsa-sha256;
	cv=none;
	b=sMK1J4xpnAU8N7gAKAndVfZMbgcDkmrA+4N9PShuNHOXPBKNArHhXuug4bCfZgzD6ilT5u
	bPWiQh2L9b4EeP5uhObCoX1YKvU6eX/zqrIr0J1jVcdGIHQvWos8My6zNHijJXdO+T4JTP
	AZ/Mw0j0wb0oa6E6K4Aaxm3SoplmcRk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TaDoVv14;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1212260145;
	Sat, 18 Apr 2026 11:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F379C4AF09;
	Sat, 18 Apr 2026 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510013;
	bh=vCnjdXeTkcOgDXKHH4wTrbHB2ThXfy9k351DRlaWe10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaDoVv14/8Fah2uXDA/u44pgKtLa4mA4Sz0dc+FeGC4gJDl6Ip7n3MDOG4GbJMz0i
	 PKCgi0xA/IeVFb58q/skqU3DoesdMBxv7TsLKclXAAM8yRTVKXsA6bztW1QoA/jdZh
	 IOE8k3WuMdevXQv5R0CH9P8VCGGUvytNxHSfd4BmnsGfLlk2gGX1iqHOpDLQES+Ek7
	 HwbBDuAE2zYLlfI/GhMg74R95NcMHEkR5CQaHzYuVhgzaJtp+c3kV+AoyxdBaUnje4
	 RjBQDpT2WizzMjgMW9vEESm821VjqCnoyv519l3boWIu2AkPqydT9BMImcMkrWvZuz
	 p75reaaiMpOmg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 43/53] selftests/mm: migration: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:28 +0300
Message-ID: <20260418105539.1261536-44-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qy1c747h5t3queswkosjtj5z44yp3xew
X-Rspam-User: 
X-Rspamd-Queue-Id: 85E50180015
X-Rspamd-Server: rspam05
X-HE-Tag: 1776510014-357522
X-HE-Meta: U2FsdGVkX1+sJGuFGQWwApjRFMnYwH3lmzUim7/XyiFjjQ1BS2wojVpEj6RxmPxnK04ySxXbRA44LXveV+wSPg7NKmOS1kh1jOLM/PX+GtUmO0UMQlAt1gyudViOOXFlAEYRgIjhjEquyIFbnGCopriFymRY1nBSLd+K7mipKGcBXB7FSOFG52NFClhWRjbEBsznIO/QJfjzBtWvaQ4wdth3X3FSazJHxQCejOv5Hc50RN+QhvFaliDye7dWD5UbYIiVPNCooDrwIB7FbfeEtjQTu/uUd9w1b/cBaaxZK1hScPvZcH3Aq8B+7Vd8Gg1nXhL+8mXhNZBw8+87apRZ1cXDPrty6DVc2lw9tyjv64DMJirfIFZAgufRpa+iqTwQym4Zy5q7qB5I3MzAOIw9Emx653qy6eYoJxUVFgGvn68hxZJ0g7nUqZp+UGQ36LHi4LQV37OasljhLZJtFoCc19HA5Qi9g51U6O0hYZmtiIZpOncUQlnKBNTrVxNjo+DgzFz3A7SXAKB61sDY59akUNX/068ZEomrBTwcQ+wIiZUJBx7ZUSUJHn4nKxfb66aqmb0THBUM0bFXjyIpUTppYB+M016F2UdX4Hyx39DxIYOg723+QK0RWNFv81/TMcxh4n7r5uITt6mEZa0YECs/PVp+vwmdYe90C5yQK/oOnp2vGlFJ5RV4boP0Pc96ttuwRLRcHaD9ubF9/XSCxcKZ+idaridR1PgD/JDtuAhynlNClx4nSBwtiPL11hNNkjVnSzsK26moPZnk1yJxpaOm8ZDAFnmwakU67Xcu278NBYT6Kd3wTwcszyiVJgiyce83C6RgbPDutUvovRLOC34KOLqthulY/KfDo9PqQl+tJ8rA/R1qdQJ1SlzURGLxyo8nxSyU4vwna0bx48AdZ8dyWESVZhw6qWT7tvsX6YU04DnFjiiXVJbVg/EPtieYjYD6zonUFwe8+WZMvap4X2K
 RAJJ6pWY
 hfn4EymzGbWbZI9/vefROYUwe7mGNSSlpi0bEvSaD0XduvvQCHNd2f0vHYJ6lDisCr63SAJzDDcKoZDX+MPXrQ7b5uPJIXSvQ19eLX9oyWOPdCbwouFl+2Bd0oUKX80z9AYaG2+NKPMyea0xK1PLoxEUL2DvNmoLvJn80Mp1foOdV9ixzoBLSEPbxhZqaXlFVFARuJSwTcbGreP5x5x11rwzLLvvQCa7VRNrD94EiX3U6FcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

migration skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Since kselftest_harness runs fixture setup and the tests in child
processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
that runs in the main process and add verification that there are enough
free huge pages to the tests that use them.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index ccf42002ce86..61fb00953f83 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -23,6 +23,8 @@
 #define MAX_RETRIES	100
 #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
+HUGETLB_SETUP_DEFAULT_PAGES(1)
+
 FIXTURE(migration)
 {
 	pthread_t *threads;
@@ -277,6 +279,9 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed\n");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages\n");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -308,6 +313,9 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed\n");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages\n");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
-- 
2.53.0


