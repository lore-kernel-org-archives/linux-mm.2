Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54A1F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5976E6B025C; Sat, 18 Apr 2026 06:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547ED6B025E; Sat, 18 Apr 2026 06:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9466B025F; Sat, 18 Apr 2026 06:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9046B025C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E72941A049E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:12 +0000 (UTC)
X-FDA: 84671377224.20.E4220CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 458D7180003
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkjbTYkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShoW+mtvOdyl1QExhIaW0N6EwTQUExNdZfr6eOd51I8=;
	b=CFI/6jBAfh6qNpYQLZjsHT+IsRrHDnn2meOOuMr8dxfKslQYQuYMRelTm57bi8UlBnK8GU
	09lVx6y63/ryYD/xh4655l0ru+XsPG38hBZdByw3m/hWpd4QCEUU0bXJzU3vW5aa49iTt0
	lKnpk6VqN6pybVkls4XyBfDNRnPrVi0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkjbTYkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509891; a=rsa-sha256;
	cv=none;
	b=ik3bq3FUzxg20ZVcKeSZcZY+Af9hQJXEg8Uhr4jcjRJE4fBT+eNOGqdTcu+dmK2E7bqXX/
	azjk+gcMsf6r6mf758nM+tnxjndf5gGPDQIb4ZHgSiB3LgU3sGI6iGleEN9XiUFf4IX3wL
	XghzdTJDtFmpUkP4ka2GRtsnJQehYNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44B8A407DE;
	Sat, 18 Apr 2026 10:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4C0C2BCB5;
	Sat, 18 Apr 2026 10:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509890;
	bh=/Wvi9uebpP/hGBuUfLX+2dm76zvxNiYlkCrT9K3LAcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkjbTYkYLePMuP6Vg0cVPkgb2IQAYT5sZI3kf1fZ6eFAfzrQMovKouwxgDlzZpFXA
	 vulAonW+RmRzzCWG5+cCkt9++7Joj4U0jwB8A8EKFzu/cO/mc4qfMNbBesxNRBAMg+
	 vzKNYuCLzo6R0MVI4xKI0vyeaFsxQ/qlUzKUSuWer2BuURrZH00N5nprxu3oJk7uiq
	 S1uP9xasGb+ukX5HJCGrj6Ak2aLkwxQxOt3Mo0TIrP79g9QFTF4FwedTm5byXrKxQH
	 FSwhBVur6uTDtNIigIOYrW+u+l9j3vu4cN3ZNvH6C3wG8oix+62/HUdPjbkc8sKiGP
	 dPg1EN33GApqQ==
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
Subject: [PATCH v2 23/53] selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
Date: Sat, 18 Apr 2026 13:55:08 +0300
Message-ID: <20260418105539.1261536-24-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 458D7180003
X-Stat-Signature: 5rff4ty7n8qkzzw14yfjnqs4s8x8f586
X-HE-Tag: 1776509891-698117
X-HE-Meta: U2FsdGVkX1+NO0wvPQyqn+zkhNi6sEt0hPyT3Bikzmsz5e3N8VwmyP4aLCdbm/s9Dp6g9hJEeo6CmqaWe3qf97eULpcrka734+jd+K2I3V16YuSK7JGQ8NRVt5iI93cerWpZMKaB2KJ0TudCgAsZGYoByMFQQmrCnZruNhnEYRLzdr9BxPagQgZDRj2fatnqV205Rkqn9vo83r/HrN80wEzMs7vPYMbpV7+MC5Y/hrbc/pAbTSAerwz0F7aAWSUGn5zXi8On7n3T8KXSr1wKIHqoRXFnh5hGxup9WsLqk6lTAtPgHYlA7iY/V0FLgJTFfA5s/TX9yIxP5SVNFpmR3FsUVsqdTqaQbAnOyNGf/enwBtVk3qboKwVoB4umfoNXpbsyYiBOykae5VYYsOrbuBvt19/IfpWjX40FdSL2v8roxr+MnXlZ0ZG67KP1qU9ml+5/W1OUx4F2zlP6WvEmEHKQzaL9hjD6BDBLp/YkHCkDUqW6mDOm5NzjWwFt3ues595huO6vvtw4vlaHil0J409VjqEkeJ4Pl3UV3Clfnj/N+bA7K9TkQCjE1Mm8C1gz+Q8uFNPZK04I3379cTUo9MVJE3sJ5YiGwYsq9wuFkUJfEScNDWv8X9sYMFDQLG4nZvsOiGeU5kEN/OreQXqy92RNbT6QwSt7IADO+N9FDBEotdYT0blOhVGBjdHzAMVZEsKblG4Q75SPuOjaikWPusCoDdyyhBx4ZZrr5L11Gr3Epn66QFtgb2u558SDxKZgBY33pc6SqyGKl9Zzlz3x66hHFRLGDVaE716LgH82iGu/s6TZb8ZDFwvbS2jq6BfFJz2oNcGE8ZH8CPL8Zj3fWlEN7hMUCrdtLwtSstkk9q3h8Vf+ILCimTiiKWeCBESPIJSicHEfv5il532DCBtGP0LeHDDJMuZO7dARO/dMynoUoMtJtwoEez7ZSG7PkfXqnqCdul/UuXsu7yTolt+
 W94i4gJ/
 uNiqct6vdK3AG98Oyrp68AyJgrBPo6SsnOVCGR2Oz4j8vW/R04wT2eLzuZ5DZ97FU9ylUDlcxXjkZL7KSktFpK2h25trwOc/z7hLYF4Gul8T4VfNidlvile2qAmCgIY7+ebsqIFvXpLlpOJmWaIEpCapmD04IZ4Q/LG8AodfA1R/MP66Z7JMG6kZkDoDmDbIYbxAiUueE9/J7u1zOdodAfSI+6UFYY7p4M4KjRQXjj4hp5oirT6vX5hfYwrcEemf05O/M0zYh6yVJ5i3SZJINVZbrOAtaP7lne5qd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... instead of size_t to avoid type mismatch in 32 and 64 bit builds.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugepage_settings.c | 2 +-
 tools/testing/selftests/mm/hugepage_settings.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index ebaa621c45c6..8f563315b1fc 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -399,7 +399,7 @@ bool thp_is_enabled(void)
 	return mode == 1 || mode == 3;
 }
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max)
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 {
 	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
 	int count = 0;
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 320b97e768e8..9357d07e6c1b 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -90,7 +90,7 @@ bool thp_is_enabled(void);
 
 /* HugeTLB */
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max);
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
 unsigned long get_free_hugepages(void);
 
-- 
2.53.0


