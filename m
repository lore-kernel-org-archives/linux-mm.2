Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 257C2F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE416B027A; Sat, 18 Apr 2026 06:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A55D6B027C; Sat, 18 Apr 2026 06:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBCA6B027D; Sat, 18 Apr 2026 06:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 692A56B027A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3467E13B0A6
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:26 +0000 (UTC)
X-FDA: 84671380332.09.981B44B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A25E100009
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pavFNxq/";
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZoDhbWNEouwgaGlkfkUpjJoSc42y7xWd91vFax7+2Q=;
	b=JODUqhyauWCboHbCbMw+wew6Y5RF/9Ie9Xr1ggq9OhZPxyazWVtiWUs47GNznQCuzp26rM
	FL0rnYadjL7Ek6z47ytJOw7aAKMzcyZKFyPcBZKPJi3WyxnDx5RSv8kE+yOoPCW72zpSaz
	EetIg/RMmPcievPwd6O5yB49mDBldEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509964; a=rsa-sha256;
	cv=none;
	b=Xr0V1rftWaJ0Xiof2Mw5MkmLRIVWynnNxrw9ETzdMcMPUEGQVE5FGaHQxMwKLh2ZF6Trpa
	mNXwc4oehfOj/z0avJ2vlCwuBFgSf8uOdtVUle3I7VU3xuO5yCn6EM9GCN4AoQqZPnYhZX
	XOLFG0YWst+Jk/tWw8Pnqm1au4wWMJY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pavFNxq/";
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2387E60138;
	Sat, 18 Apr 2026 10:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328BCC2BCB3;
	Sat, 18 Apr 2026 10:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509963;
	bh=ib9LXsJztlT6AS3f5wMdXHDwOYMXkAdeN957x1qT4BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pavFNxq/2IwGOfwlXixJLLH3uA6ytRbiy37uSfffBDhjDHasiINfzv5MpmEfSxnap
	 9+3as8gDKrxlI5DWlTwJmR8gK1ZhWi4Tugz6mvyCUYyKCkqnSV9cLUOjgEp/RNu1r3
	 nrtXGxtarPpSJSQDss7K08tB1BSSc5vCSSasegK3ygq+8hxAWcqWJ3n7OgqriXxb15
	 niVWY/utkt8tvgIxBTAPKXH7zFSTPFxM3TTZaNk9WJ2Z6LyetPDAyghkTsP3j4kgWb
	 JCumNx+lX3p4Ne2CT4oLhWfVZd8CDZpeM5fxg36Nr1EUIyx7CnRnwhovOruJLZE+yJ
	 YgqksBz/TYhog==
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
Subject: [PATCH v2 35/53] selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:20 +0300
Message-ID: <20260418105539.1261536-36-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: reeweb7ymshsj4i3mqx9uw4ffpr58ko6
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A25E100009
X-Rspamd-Server: rspam05
X-HE-Tag: 1776509964-518949
X-HE-Meta: U2FsdGVkX19RAB3ZdmbWmSpMJA8CUzR8yQYG1TwJ4duOtJ9ldXBWZLovYx66w0zmNlpSvbsU13WHJQz7xqcwEQ6szVhMsLfu0AKI/hrvucIKx6yeg6QCjQXgFqp0wwx4qltSC1qDOrz51A2kzoG8kstS4T0DWvcd0kbfKITjsylzoePcjQ9lPwOxxtZjI5UCVhxZTo3zgP1k8+d8Sa/k+99WCv3QBR1A4JJTkKH6v0vPsjujSYhU3daNYLnuRDEWvSjVtRcwe5YeiluYOVUSuJshItSusVJjuX8mEKIA00w9S2SqsRxkkOM28OGUVxo3mP/YaKwswv/Pxz8TtKvbeVkLjcawhPL3AhdUUtSq1v+8fXZr8Pe/eXPcNbwFFGd/DJ22T3j3jSp9uJqCr2Jk90BvMwPTde/eGHweu/IQTJTeqB7gj2ohmRtDSRl06MfhLzcmeJu5jDBDyhJFWYHzDQP/xXs+d9ew2tz2SsAB8PEERSeivGN2h1C9vjCf+xY8LHJN/01q6i4mixymzWq9d0ec+z+SnllIjOBvRB9Mcq/AE8+eC3RdmP78NHJIKHdcdLGUcg51s/Ij6Ny6Q45Y1cLrwDzvMtxQFgvkcujFNpetEBVr6QEJpx95WwHz6BQxo+AkaZy2v+tA1AGvRUhzAed1xqpuqYcvFV9/xfNrRlacUEXHiv6Mpy222F374Bs74fyAXVWR+tjsRBss+KgJ01/1WU37XXFaUtkUDdD0c24858sRBE/Q/HScBlAWZXU6ajcchXJ2t7NKH2/FRZYVEgUYzSG1RBw0JMkyOx3E86y9YzDAXiGuXZYCfKazY5wdAFy/Rajaitaz+jCTc9nSV7Evo/gsp1bIElFzLc8mR38lEXtgeTBblreE5py/1Da9NspsCtJ8ypLYhOjX4gVVCQZ/A9YTjngajW2lhCk/nfbmBKJtyGBN6U8TMnc42vp7jNjckcz7SN1RPAHixpi
 Z0e0mVA5
 P19+VnB9wtxi7TghVoRX9AE7Qp2wMdiWERqqKoc4pAxseBOdla0xZ5tP0Mj2xCdPMgNfhLOyhMt38weoat2sw1/O+FkWOoT6s+HGvxxxRp7qzqm9jloA8T2dnly+FSGsHQmvBd+jUji6L92KG+ii3hzP38ozSNMCwO4PgdcmRoE+VsmaotXfXX0KFJnFx+shH9r6nyeszXh0x/O1Vk42cv8Ww8wjZ/TZqQp3DaLRTMvf9ip7C6hyXBg+lnhowJdpDwUQAUSqHX/z3namBEApCeI8G0oqL7wuwcNrl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb_fault_after_madv test skips testing if there are no free huge
pages prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index c718dd065d53..481863cc5fda 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -54,7 +54,6 @@ void *madv(void *unused)
 
 int main(void)
 {
-	unsigned long free_hugepages;
 	pthread_t thread1, thread2;
 	/*
 	 * On kernel 6.4, we are able to reproduce the problem with ~1000
@@ -78,10 +77,9 @@ int main(void)
 	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
 		       huge_page_size / 1024);
 
-	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages != 1) {
+	if (!hugetlb_setup_default(1)) {
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       free_hugepages);
+			       hugetlb_free_default_pages());
 	}
 
 	while (max--) {
-- 
2.53.0


