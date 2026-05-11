Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 682FBCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3DB6B00BD; Mon, 11 May 2026 12:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB546B00C1; Mon, 11 May 2026 12:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE84C6B00C3; Mon, 11 May 2026 12:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B03716B00BD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:29:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5332740210
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:18 +0000 (UTC)
X-FDA: 84755673996.15.46B07DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BB86D14000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ElzUc2q9;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J32J2+sOCtgpVneW8RjBFab7t9CIQEzf0kqyP2YCsH0=;
	b=pbabI0PbUCjWSxQ0EPKmc8ucuUS2vLw/az8k4fhRkJDLP+EbKQqHhaIf0S8VZi0o2gpl70
	U0lM+u3DpVnwcC7G1bUWJleMXJ+HMcQGPCnCsvyFXIGWVdD4zi09UJJ3QK3McjjJB6qeRG
	bJBzbo5nUrzROOWWed4Loey5/RdK+kw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ElzUc2q9;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516956; a=rsa-sha256;
	cv=none;
	b=EegjKU7EQgp2OHUHRlPJqsZMZCHkqTUb8NXy4otL3+lOoHPvOGPoUjV9credvyj+3dqICI
	MFb+PsjTIVVeJn1o02gSE5oY1YpGDovVtmmLWb1y9FVvmWQ5MEyDSp6fxNKm+PmkKjNSiY
	b7U/d0rnXeE2Jla1S2qxM1kJL9xKNWc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CF7860121;
	Mon, 11 May 2026 16:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33B5C2BCC9;
	Mon, 11 May 2026 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516956;
	bh=D3ucbWX1umJfXHKxzz94PIX6u8f6Y5ITK227CSAANgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElzUc2q9icB8fVCWT3YXVt6seSEwj6pXFOTBb9Sv60fVqzSgolcvFWBKj2MMYtrsc
	 S8UieN7pOCcupgZ5Hu1TbxkciuGtPKqRKg1sGRE1AqfK8+uylDD7oTWoSYMaTiZoTn
	 qXMdhrGVXzqk0iRKXaR/u8VxDZcn1P9oOKjeGeaqPu1m2zjhbjKnEaUwDC4mFiAKYo
	 nsvp8NmgMq+1YydIPkZggBuaO4IBehAIgjqkjtWPKTYxvsHWij0qjrv9CqzVaI+iX0
	 jl91WkkyVzTPLvVwp5ISjTh54Ynx7Y+dSU55yruRVfIrraQVtg+E5DiCm9s69aBo/X
	 aQY9IAUvnSWWw==
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
Subject: [PATCH v4 04/55] selftests/mm: migration: properly cleanup fork()ed processes
Date: Mon, 11 May 2026 19:27:48 +0300
Message-ID: <20260511162840.375890-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB86D14000E
X-Rspam-User: 
X-Stat-Signature: ekisw8jmjg8iawec1u3z7wuzg5tm3tzf
X-HE-Tag: 1778516956-445279
X-HE-Meta: U2FsdGVkX18eBrs5Je09eU4tK6MYl7PgVYE4DGnEtN/yq8uBEW2kP7oemyQJR52USBY3nzR2l5gXPq9av2d0/Xgrc2S04zxmJyun/L0B1ao6fmWfqenY7WEcmeJpKP1kkzWeJxPoC9coalHurCPzLaFXy51zk9EgJA2U3yco9n3XEn5cA+dqluD+uyvb319d/pORL8hBEWLXMn0FBWIEf3Tc4uTpOSwSd4A7GdM8Xs3aW2oqk/1AuGtlWTwl5teFiKtuQN/hCVTK2JdgUjdNmbcVksMRouL57qOVeUqMVEYrVNkgDm1VfQKlJC+WwbgE3QWgE6vUbLIlaWOi68+AGbD/F59Ka3GEXIofmVHf3CApNCk7XAy87b/np/4Ijza8yq0mlLXPQbejFp+0VG//kr3L2cjKCVUsMoIblrZsVjte4/bn9R0VNVIrTn8zuswg5FQ5MvrHE9m+PrTwcATlU4pk/uZA28a1Hz+Xz6WnJElIjrbBdCEN/ut5WKQzdMNNP0tlToA9zfdyCuq4MlODhZp2LelvpMTm8VgBjcxF7xKYVTVGxyafL89BzCfOtXFrpsKdAx8B7/O7EwyWIvfgwQo+On8amCMGl8cbwVIn58Q652TRmeNXpx+8WoOLiyJcjoSeX+v8s2KRu6splHvS63WhDaWJhQPFxLQi7xLsNZqdPTfhD1W6M6SlwFtV8OBTYcSL53cjIszG7A6sJDUN5tFS6NYi7uPNrUQlEuT7d4nXLt5CAJzGkeH4Nm44carb9yWq7MmaA2C+XLGqwj0sO85ba+ic9RY0M3UniclGlDNksVZEoo/l/CqGkagufT1loBVConaZfuvoH1H/ITcSpABgNjVHjm/pnxfGPBrPX0KnzZDo8/3e4TNZonf/TQGWDeFNFvxJwPt8gsDKXe7DL38fXajXu4ub/p2Wyh+nT/ELwlbL6/l6/EM0HJWgiqTJqK5ObTxEdAXI9uZEAld
 i9TVd2kV
 55CzlspGUIW/PqMwH9Uc8qgkD0Fa4Vo1RuQao6h4N4Uu2wfmiDXVzpCHi5lvrOYos2S8N2SLGH9eNps7jG5x49hDXqmwEV3yyqm379nbi7Bc4Zzduw8vqMLXFTS2aGu94jRJUtk921mo3hlX5389rsGL6cplnpjbLWYzWPw5vURZGmXoKI4s6mazIud2jsGYAuy8N6TiODlakjNM2lbOZjNFCTFQ5u908Gig1qdau/GUcXoKdstygMkkQIOfTtqKOtzwV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Several migration test use fork() to create worker processes. These
processes are later killed, but nothing collects their exit status and they
remain as zombies in the system.

Add a helper function that kills the worker processes, waitpid()s for
them and verifies the exit status.

Replace the loops that call kill() for each process with a call to that
helper.

Reported-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 47 +++++++++++++++++++-------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 16ffd3c55ee0..e504829df6b6 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -67,6 +67,29 @@ FIXTURE_TEARDOWN(migration)
 	free(self->pids);
 }
 
+static bool kill_children(FIXTURE_DATA(migration) * self)
+{
+	bool err = false;
+	pid_t pid;
+	int i;
+
+	for (i = 0; i < self->nthreads; i++) {
+		int status = 0;
+
+		pid = self->pids[i];
+		if (pid < 0)
+			continue;
+		if (kill(pid, SIGTERM))
+			err = true;
+		if (pid != waitpid(pid, &status, 0))
+			err = true;
+		if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGTERM)
+			err = true;
+	}
+
+	return !err;
+}
+
 int migrate(uint64_t *ptr, int n1, int n2)
 {
 	int ret, tmp;
@@ -151,7 +174,7 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
 {
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
@@ -171,9 +194,9 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 /*
@@ -217,7 +240,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	uint64_t pmdsize;
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
@@ -247,9 +270,9 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 /*
@@ -287,7 +310,7 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	unsigned long hugepage_size;
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	hugepage_size = default_huge_page_size();
 	if (!hugepage_size)
@@ -311,9 +334,9 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 TEST_HARNESS_MAIN
-- 
2.53.0


