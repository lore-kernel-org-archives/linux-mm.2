Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E704FFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AA366B0095; Tue, 28 Apr 2026 16:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581936B0096; Tue, 28 Apr 2026 16:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497E06B0098; Tue, 28 Apr 2026 16:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 363906B0095
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5D5A1C021B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:19 +0000 (UTC)
X-FDA: 84709139718.22.AE94AA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4805240010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cAZE/WSS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777408998; a=rsa-sha256;
	cv=none;
	b=8KbzNOVPmKTXGbtOsHs2KJNjrQ0rGwgzb1oHcqwg9H/5TiCNrpUhWZkJrWpJBGXhqAX3yL
	f6N1tPnwuKdDR69r1jj9nClqc3ZP3sQ5t88/pklqrAf8/uzX+N/nAeAVpLPNePniySqKTw
	xcD+oHgYgrb7pPuE39WC0ixfh8g8zEY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cAZE/WSS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777408998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3EqimJ/8x94574ZNlatJU6BZ1AXOW6kgaQfoTUACkg=;
	b=hA8EApIQswxuNJuLlM+E62VWT/XV8M+44NMIlEgEWigcLkAruPJoEEjgPnAfiiSFdDpu9Q
	bjnpwjcwYu+F517egKjSteVXS/BwWSkiYWonSdpfmv8OcLCz/Ehd9W/5VdGKe5ozvnLVYK
	auyAftNozBp3vA/WwJKIIF5Lu7JbAbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C9BFF61335;
	Tue, 28 Apr 2026 20:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704AAC2BCAF;
	Tue, 28 Apr 2026 20:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777408997;
	bh=YVLuQpulE4IGKf3/7Seoz5g6EvCitjNNVoS1iFEVWZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAZE/WSSmQVOFRo/+tVPHTO4Sxp02oS/bYllLIpL3lw8OXLIQ0lrkt5dKHdUnkU2K
	 CB5JaWg476OmEVmbtTJJypc7Zh4Zgk7N3cXU6tOpohf6UFC3voeUklGLT/UHIs4OS+
	 XogWu2BK+VU2RnPNUMPRR7r+wBr7WM6HJIjGFaJKndndNqZJ2GJWoQdVUX4FAsbNg+
	 qeQjiwJJSLqSjhx9+jWoW7DRC0s+prg3meLM4VELz/UUcnBWYulBwX8GQOmAJzMrFl
	 oKpgMml6UiOmp5QC1W/wIIWZvh5QnAgv0e4TvuAcxmKagy8vYDR/SW4Hwt7whzzd0X
	 8mzrcXpDGMMPQ==
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
Subject: [PATCH v3 04/54] selftests/mm: migration: properly cleanup fork()ed processes
Date: Tue, 28 Apr 2026 23:41:50 +0300
Message-ID: <20260428204240.1924129-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5e9z95op6bfr7aoor3bfqxyiwntdnzoi
X-Rspam-User: 
X-Rspamd-Queue-Id: 4805240010
X-Rspamd-Server: rspam07
X-HE-Tag: 1777408998-122289
X-HE-Meta: U2FsdGVkX1970nlzWaSgKL0Uk+t3HyMyovIUIqTkxbAC2cgb/GGif4f7lOlG3SMbRT9noDyxLhZKAvm7x1EiNQf/DMXYHKzrtFCOpx6+1eBp0qKItXBAQOjlfnh+xjxgd01GTzFhjqwxwU1cDQb7dVUP+CVKmoVZNI6FUwH+ZlXjS3/l25kD8gDi0npSrrIouTS3GjbWaXe7IUIUPFdCsEj2OpQkDfQy2b8qluTERLQdlUAsk0XM7pJJ9nDLD99ymzEPlqDppyeQjcsqkIYhmDxg1JVnY2gUDXT/rPLE+8XFUtJQ3nONdZ0WMKpxScKojudCFie6mjpjVFjysCpJWDvHGs1cQUPa/X4ML6VgOuNd2LYzow54Tx1QKquXC7/eUDvgo6/Gn/midjcjunQxGkAipjty9Siwz3MTxzBdNH5P/EBxiBCpbZhMBKWTm4sjN7GCYI0A5dcVgtvricSjRWu2hBihDm8jsv5r0JevkBvCOJLWWSlnfa5tKEa70pokfd1UapHDJaDJsYiX1hMMO2pxbpkpo1ea4ttZUkMoG2XWbO91COqBv7Cr2CY4gV7/5DckpC3ASO1ZgX0SZc5LfONajk131lq0cv0vCbcHr9tXKXDPN6+NxSjO5wLcKO63TnLXsJO6qWB8cOwRMcTDrVARi6+G6K8QtRlo9T8YTrVnIW75jx/B9m8ItdNubUNtOmdTnazwn2/K9LRyxjZes1T5GYexw4is93DJaAjuz54t+MZc8UvtOtThBIEsMCk1HPs6jXRi3wjLz1Y5NmHX5h5tn2Hoi+rTDQHS1il2qG9U064cjk88ClNbYZXOG4RLjPQxoU772nK/8VQR3ivYrKacgQMoAtVoedcoCyT+6BPVtIc1tzydR7zbMjz/BaJjxFAaIHFaoBLbxUeUDXykYIOFm/LCvg08XFIuIc0SwNG0f98iFAc+aX9XVch3SEmLvG1oQVX4F8re2/HHV/+
 r5kofZ28
 FcJ+Pu5XYy/N8KbWQKxpgbgriGPnBkgQ2lwf2XiPEx4A+6yU9DYXONPbizgIz15Eg2LR5TzhJ3MoamJlqXS1pAHAXIIZ1rhYk2FFaDFFzs6dEJCn3pgo59VsEj3K+3QQwxkV2q4wQgo3+h76swWIsg4GrGs5xaEK4moDOu6PSClmNnl8g0dO9LuSBMj5T3RfVKUlRTGuGsI3UHaTJ58KiFn992wtNZUaWyuCFbBqTaPNers+1KCy2fWs6vb9O36bTCg84
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

The addition of waitpid() calls also makes sure the migrating process never
exits before the processes accessing the memory, so it's possible to drop
the call to prctl(PR_SET_PDEATHSIG, SIGHUP).

Reported-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/migration.c | 54 +++++++++++++-------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index 3630f2fb0800..76e380b74658 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -67,6 +67,24 @@ FIXTURE_TEARDOWN(migration)
 	free(self->pids);
 }
 
+static bool kill_children(FIXTURE_DATA(migration) * self)
+{
+	int i, status;
+	pid_t pid;
+
+	for (i = 0; i < self->nthreads; i++) {
+		pid = self->pids[i];
+		if (kill(pid, SIGTERM))
+			return false;
+		if (pid != waitpid(pid, &status, 0))
+			return false;
+		if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGTERM)
+			return false;
+	}
+
+	return true;
+}
+
 int migrate(uint64_t *ptr, int n1, int n2)
 {
 	int ret, tmp;
@@ -160,20 +178,14 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
 	memset(ptr, 0xde, TWOMEG);
 	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
-		if (!pid) {
-			prctl(PR_SET_PDEATHSIG, SIGHUP);
-			/* Parent may have died before prctl so check now. */
-			if (getppid() == 1)
-				kill(getpid(), SIGHUP);
+		if (!pid)
 			access_mem(ptr);
-		} else {
+		else
 			self->pids[i] = pid;
-		}
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	ASSERT_EQ(kill_children(self), true);
 }
 
 /*
@@ -236,20 +248,14 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 	memset(ptr, 0xde, pmdsize);
 	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
-		if (!pid) {
-			prctl(PR_SET_PDEATHSIG, SIGHUP);
-			/* Parent may have died before prctl so check now. */
-			if (getppid() == 1)
-				kill(getpid(), SIGHUP);
+		if (!pid)
 			access_mem(ptr);
-		} else {
+		else
 			self->pids[i] = pid;
-		}
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	ASSERT_EQ(kill_children(self), true);
 }
 
 /*
@@ -300,20 +306,14 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
 	memset(ptr, 0xde, hugepage_size);
 	for (i = 0; i < self->nthreads; i++) {
 		pid = fork();
-		if (!pid) {
-			prctl(PR_SET_PDEATHSIG, SIGHUP);
-			/* Parent may have died before prctl so check now. */
-			if (getppid() == 1)
-				kill(getpid(), SIGHUP);
+		if (!pid)
 			access_mem(ptr);
-		} else {
+		else
 			self->pids[i] = pid;
-		}
 	}
 
 	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	ASSERT_EQ(kill_children(self), true);
 }
 
 TEST_HARNESS_MAIN
-- 
2.53.0


