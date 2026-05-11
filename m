Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3B0CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119716B012B; Mon, 11 May 2026 12:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4826B012D; Mon, 11 May 2026 12:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4BF6B012E; Mon, 11 May 2026 12:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7B286B012B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94C7440215
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:46 +0000 (UTC)
X-FDA: 84755685252.23.234E297
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0A1CC140017
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQRHJNZ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5Yjs5NIq4ZaA7N0CJDkasW6tv//EOmaQnLYz/pGX2o=;
	b=0ri5Cx7wydWZ3MiJtiC0N+2c3jctak4BQK+ymqdum+nzF8GQnNkzC+Ss5x4iM7JP6vUXo6
	11omfHHksFomutMucslf84d6KogwKrZS9FfoPDLqracI/x6vwS7Tj6Btn2sz5geDisTsNX
	Z6zThDKHoO3/DDTUenK7cQedHzTrzb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517225; a=rsa-sha256;
	cv=none;
	b=2XDuZOqIAK7nhpCgte1+Ozo1YXZBrCtlqA0WIKlU/ZjDRsnT58lMEl5kcmbZKAgMc+w6wL
	VfPnjGI6EXwmsf5Qz+YzN2O3oBwh8m9iMyG4y4WMdo07Zm+eh40DD0JENB/wii6OLFuSaI
	wT3d81UMrILRUFr+539S7ciw4/xfWx8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQRHJNZ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92E9260103;
	Mon, 11 May 2026 16:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A772C2BCC9;
	Mon, 11 May 2026 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517224;
	bh=f0LPsZ8UtpMTj9mp/rE/Gt8kIOCrI3dD0EgIZPJUfRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQRHJNZ+09dzgdo6rJipWL/W7o9A2l295KrXfH2LYm4bjfkeqt/JNmlhgAnclM3qQ
	 9K0lb4NrBcLFlfsOmZO6o2eiicj/FluFTJhY5oy0MflQWqOLEpuv6l0lT6FI4pRtli
	 1g0v/hawsHmS1an7MCk4wIPlonNCjLZ/XcYfwkGjNoxShQsL07nc9uhdKGftIhJ0vm
	 d8kDOejJEWaLvxyRswhs1es0i5C5ZQc/Yyy8EeSLmFVSaPCfRD9hjtigLVoZkmFdJE
	 aJSDCyeRmB+R035wO7zhFvE3Ki5t6hibjvD2g6Mo+DZDqlHoTvgjbirZGCOPbU2Cdq
	 pPeCj6jLjobrA==
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
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v4 45/55] selftests/mm: migration: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:29 +0300
Message-ID: <20260511162840.375890-46-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A1CC140017
X-Rspamd-Server: rspam04
X-Stat-Signature: pwzkcni6xtns3465n7h19h39yumnf4nh
X-HE-Tag: 1778517224-259792
X-HE-Meta: U2FsdGVkX19mnZxO0CBrQhWvDA1awc7bx3ehOBGwpjV0C1myYpP/Eb5dSmHGcF2nqDnCp4Yfj5VkhhFM0Wa5rJxbEVZFJTgXeEi4dpzt8JPjHOeyYSPsKgZkAgLVcCB4w6l4lAVXYpWuVxIzaXsTAxrscfl66VC3cDj8xlmsCknFkmnYuSxG6V1Fk3qffkW8qTb8jqaLuOKns+67G/Q3ZK9Bu25poxJNW4OZ2/Dw73fwh41x2RORVjHF8ttL7o++F6lPf4yKDOwKekF4SoIQBF4iOEe3SDI2cOdHh+OqyuBmJB5D/MsJLvw05SaY5wkEpc9mPVxvCgaW9Ebg7apPq+8mSaUBEeF6I2llaIKy+VuCLPOjmmo1CRPhYRyLCGafegfzMrnx4RYI6PPUEke1UGfOpetJRUJfiWJVE7i9Eyq2i07LP7TFKbxNWNPuNAYKbrrh7wGDwpPij7eG3MMMFzI5INBz/KQQ+O7TEP5OFlrbYFc6GyRDIJl1mvFUkmK/siTOvDs8aRiChuWFOYp/9+XHccn0UYt9tHJPqNZ2HkwC/14Un6elONPJFocL6AG8kmaxm3MsVC+y9S8aFKXoCNCDWxQ55GWrZZJDONSs+zQLTfLmdmQPvvZ/Vv+zmXbkHVYDako3aZPrlA139jXHjsviEqriKUIhFKJqJmZW0WBbjZtOfNpwGZOEGTj+Wto9E7RB4Avyc+g/XcgXKELnUBtOlChQvEzbJm3sENagWrpiURw5TozwsKOdNUVDsCBHg0snJqEBCk+Kx0IF6CatKsi8LBUnufRpXOK1aolURV4QwdUZ7SRD0qNKBR7658VfS5ipcXPUCoCL8vlfr9nbDLe+q77OYYCQCgLltTczWSrX54UPELuVH37RzNLedyj8X7W8lNQs+OtPtZkU5UEsDxWtEqhHv+WpjBbn+Y16jiBJZob7B84dlVXrEmXsSHhMgiwcdcpz+v85+j6Q5xP
 c++qUtbL
 ErIFKOSBhUvE24GdvctSJ3fwZlqZD1lrIOfXrLXTSP3Q5TniW03IFMxZ0N9ZN740AWdq72MPMqR/4Koqkc+uTisr5wH2fPacefhfynqBa3HpiffmfOB9hJMYqi+xmRsvI96nfGiVq4Po3y7QvVoZSj0F0UY70JYQkH8jlJXbLuXCJXWtixtVNA0B45TyJegGFZWBPfDPUjl8lWxtGUqIGZt/9ivvmk1eI0rStWIeXB1y1thn6T5Le0iLhLEtDleTYYVu09eH2XTD6EZS8YqfKo/IEy0REo31Yu24mf+7W7lLxk38cOK9RoZKnLZbJeE/qp8B9
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

Reset signal handlers to defaults in FIXTURE_SETUP() so that sending
SIGTERM and SIGHUP during the tests won't cause restoration of HugeTLB
settings.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 7781a59bb9f8..29f7492453d4 100644
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
@@ -32,10 +34,23 @@ FIXTURE(migration)
 	int n2;
 };
 
+static void reset_signals(void)
+{
+	struct sigaction sa = { .sa_handler = SIG_DFL };
+
+	sigemptyset(&sa.sa_mask);
+	sigaction(SIGTERM, &sa, NULL);
+	sigaction(SIGHUP, &sa, NULL);
+	sigaction(SIGINT, &sa, NULL);
+	sigaction(SIGQUIT, &sa, NULL);
+}
+
 FIXTURE_SETUP(migration)
 {
 	int n;
 
+	reset_signals();
+
 	if (numa_available() < 0)
 		SKIP(return, "NUMA not available");
 	self->nthreads = numa_num_task_cpus() - 2;
@@ -288,6 +303,9 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -316,6 +334,9 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
-- 
2.53.0


