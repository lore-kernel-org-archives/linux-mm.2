Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A878FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27C26B00EB; Tue, 28 Apr 2026 16:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFEC26B00ED; Tue, 28 Apr 2026 16:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15226B00EE; Tue, 28 Apr 2026 16:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0D4C6B00EB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A08251603EB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:43 +0000 (UTC)
X-FDA: 84709150806.01.9767E4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0A1652000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DfWyMyE+;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q42QvwZnhBEly9H1h3sP9cvnLLLqp8hGnUQRRVCaRfU=;
	b=GjEJ3ZQ3L04gvRd1sielF0e/GZHsFzby0llmsxTI433JD+QCBqDlAqefKXoriMn7Nno5CX
	MXmgbnIepDGdHX4nKtBk8+2UV70Nc1yurHkjKleqlsDmUeuc9HKvz+xwQzxhfEr1LJ/W6C
	YgUwU+jtArGyuHbUQRvro4Jq4XlGWzc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DfWyMyE+;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409262; a=rsa-sha256;
	cv=none;
	b=wNyIPICbsoA4l9WMvqnd5tfh3ThFEU5FYn5RrRWkNqnE4Nj4h5IjBuDypgCv9EETl+eOaU
	CA5THNjUC2pRH4wnwTpkDGyEqKzE1UR5htHRaCQ4UR3pqaX95QFitbwpMh8e15yLSF9q9h
	FGp3TZ7Zxb8MOJoVOADhIxwbHAnSISs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 648886111B;
	Tue, 28 Apr 2026 20:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B86FC2BCC7;
	Tue, 28 Apr 2026 20:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409261;
	bh=WQo8riTW+gdC2wg2rFje/aEFGdbZITZfBZEkLvZiGOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfWyMyE+wURM9Ch4JrXDDNborGc6PdSkvjRQf8LzswNdIbrYaZa/c4ViXt/F+1eWS
	 v4Wel4es9JGNXLZSfWHoRXqrxQgv+atphmr01IE9OCGqh67batJjGKF2qg/poHm8zN
	 JKfr7na4AcLN32XDtWYQa4XzLbyMpktAxE3pWTD/DG/2pi9ViTVaKJISeU6hQKku+s
	 2ThZMGJLLV9yfREP1ZXQbjGVpfkGLpQhDoIJ4ZH2VodxBG65B3q83D9JODrC/g5Ng8
	 rZ8xn82nE+Mb1Z6IUkm9t6BB2GJzd7/JBdDrDdD2+nUk3nyX17BRqr81pw1+dZa1Oz
	 Y89gz8lrylySA==
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
Subject: [PATCH v3 44/54] selftests/mm: migration: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:30 +0300
Message-ID: <20260428204240.1924129-45-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A1652000E
X-Stat-Signature: yhrxi1fnpief81t5rqrkrd3j6zct98tj
X-HE-Tag: 1777409261-164287
X-HE-Meta: U2FsdGVkX1/XGOxtcGPDFgNJIgN5pm981ALCARD0FvfdD530vcvC/+Fl2humBmLHi6Dy/uoldlQFRAFGWI+QUtETmYA2mRP17UV9hUMyQgoSfaFOFhh/HxwxiOcFV7nUQLz8afDDVVRN5lxDXmFU4O12ALxnh0+OPeijy3PHGIIrBHPE2IJGQgFTLIkIwPgvvqaN9kq2GkTc2XeXM4qrUtbPrHh9Md5fvV+QpdXms97+mAdlXpkVqCQL4U/kjsUtfRE/h9jdz5x3DWVozJxWm0AMQgJef2i9bIFTU3TfFKKTBkVsMTBfR0Sf5iLAXpZdXQXVEqsTIkB8QwJQClyl4qnba6qAFqs5isF1lJ7GeoA43K4MssUHFDMGFn3146X92NkNIlqO0pUz9A8qqAvuFxjQWoVZR9qpMEWts6XInqefp3VhwtY+Gf1S2XvWQUFRR5znEwjsbyYMmH29fgpqJFyKKn1oVZsyS3qIgjkwCQ8hl07jEqrk/8srQK5R3WuTuIaPENi71xrCNn+5uAtt1HxbScqjEFdHo7DGzdH6THZ6/QKPCN6W0hLGxITJQtLDB2AGP//9jcwUmpRN4kx6XvttrtG4yB1RpbOZeJIUPT6Vepm2/gsnRSwlRLtDhMa6PWpqGcvvnEaqgUhOdpF46+hsbeK5Pqn/n4En3MQyxRZlsZo72290g5uhU/Tb18TJry9EEYphRpI3gwunp+0+dSshlJLUjKjDS/V1O47pCFAgzu50wqqZP3zvO8G44R3JboU47cbTHaQ83UdSSlWGS+kTaObFSVAnCc7PuEql+7e24msP2eezWS/6K4j9hQh3QWm40ye1GuPJdg3BR5pRwsNJKUKjLZ9KYZtvOFP3e9ekxl0TvnR8Za329Ie2LUYcjMIprMfFK7OfoNoivcGJrdOz3LW7unLkRBAcSnXw939c3J6lMO3TTXgZIlDHZc7kBaSCuolVlSfi5iFIX/A
 UxVdz9B4
 +Ur0GnQhWa5XZXtkmFXPwIT+8Tquo4HWkJpK4hK/MKn4fJ0bDmEg3bERfbtY0Lxu5YJU+KWNIIYewVunbRxiZBbXus6pjkCNY79LzGQnj1mZKqUhXIB44t0UX5WiZh6JKTOqv1yxwsk4VuVPaybNCcGaOjpC9RkBjoyoCHU0tD6XXsUUAQOQqFs2Yz/77l82OZ+36S9LDcc+K5CrbXebXIgF6sgILo4tdjAQh4/NKSNGrw3M=
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

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 0212cd5bde6e..f212c1b06455 100644
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
@@ -32,10 +34,21 @@ FIXTURE(migration)
 	int n2;
 };
 
+static void reset_signals(void)
+{
+	struct sigaction sa = { .sa_handler = SIG_DFL };
+
+	sigemptyset(&sa.sa_mask);
+	sigaction(SIGTERM, &sa, NULL);
+	sigaction(SIGHUP, &sa, NULL);
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
@@ -271,6 +284,9 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
 	if (!hugepage_size)
 		SKIP(return, "Reading HugeTLB pagesize failed\n");
 
+	if (hugetlb_free_default_pages() < 1)
+		SKIP(return, "Not enough huge pages\n");
+
 	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
@@ -299,6 +315,9 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
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


