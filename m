Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E47CCF9EC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DA78E017D; Sun, 26 Oct 2025 14:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C4C8E0179; Sun, 26 Oct 2025 14:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8F38E017D; Sun, 26 Oct 2025 14:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F00A78E0179
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C635E129D6B
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:28 +0000 (UTC)
X-FDA: 84041085576.22.61759E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 307484000C
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hz1orSbv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502947; a=rsa-sha256;
	cv=none;
	b=j5fuZyBNetx2gui5+qooU8hMUDGy4vKiZnlvDgVi9iV2jzYuka7CMnPO3qCZ1MUEx03h1q
	xYiJLK3qlo2Bdff48VhEwOZYvSQMCPC158MX1W6qkBHzg8qSh1cYGJBTGksie2kSBJmbGm
	MP5I6FTk70HG8GYrmJB+wqPBl/1lP+E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hz1orSbv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wc9W9cvZu6ji3KL/0jCsRP1SeXOo16vZLOttk7+IIT0=;
	b=nj3J37gSDGYd6jQ/HjrQG6EL1K0JAW3BaYjOpuxvISqEFnjFErs0EqP0iZs9hprxsSfPGF
	mv/vh+CXIvEvWbQnYixnyPp7l8VTvycM74scdQu/hS9XIBxpDBwsDN6LoiQ9rwysZ4kjax
	WpGRyGVfAjKgXCFLTL5QTBuVBGSHEU4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 176CB451C5;
	Sun, 26 Oct 2025 18:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B4BC116C6;
	Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502946;
	bh=I1qOOem2KN/JkZ9BYY8eeWzyQQxWRZ7InKt4fNjdwKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hz1orSbvkBt07uCPY9LqB+5RZ4lOiEganPCCSlYwGKdf8CP5+J7XAkwN5Ov9Ow2aX
	 k1Hp1eHEVwLCMHudHdZ8AZ9Y3xVPutNbeQ8aEDMz0QHP1MCQk+C9E9SplA4v2E/dhG
	 KSc2I1kpRL2KEyL7ZyrUzL+SZAKWCRwYsWz1E7yGWqMJwdkTzGV3cbPe+oNqtMfeoK
	 duJx7rjzR/20lz3rrdDelbelInYeuR72NwUwFemhjiPTKLZfPmKmQ9p9pnToJcz3iC
	 MjbpydH0AkfLc0zE8FfYF33u2a7C6oJIl062xJ3rV3EUmagGbs8KbeE2CHGUI6LP3N
	 0yzbVz46qNZYg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] Docs/admin-guide/mm/damon/stat: document negative idle time
Date: Sun, 26 Oct 2025 11:22:13 -0700
Message-ID: <20251026182216.118200-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026182216.118200-1-sj@kernel.org>
References: <20251026182216.118200-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 307484000C
X-Stat-Signature: 7c1g1t3af5zx6po7ehzimytxxqe8c7uc
X-HE-Tag: 1761502946-764387
X-HE-Meta: U2FsdGVkX1+qR3nDal/rjdyCM8xP3xPr1waXTacFfZ5Ay6oQkf6vONDytkkQnbR0dOCgPP0n3hig1fxMRX5GQxLa9XWH3M7Q0SQNxfg+Og9yLGf4IoW7MpSyVLdq9x44lpNJAkKremPqX3bge1U4cwjTcKIZr+YnBnEvjC5mWEAPau5RNur+DPQYzcuJDsZMA5pKHOYj9dWhXqfVgk7FM2ejnw2s8V+/pZV6XOXlXNyzflHgb29SsKklBH/PitvGUqFt6cCtS6uVCtA2vcH9kQ2OKfea+krxrbIEF8y43f6votwiMv6XOl1I80mMbidTG3YCJ7zs7vUPZ1vQv9vEncrF6X++nSpLxtLMAGV9SSzfzWAYglkKQ/UaM+t4x5lrZBl2c6JaDiS1ZsXLuYwoDYVzUz+wPHVcJUwjuu1+15RLlNoE8zZNaJTR2q3or8wBJLPA24mcqaFAN2rQz6ptgEJ79ITBYXChLRZtirdD8MeU7wBIrSAcutYeaQbG7p6W3KEQ9YUL+eY2pKz9b4l4fIkNsAyn8J4Ncd2/sPMbi68e3ab2b9lxe3gopmjxa/Mdf4KRF9oBOO42dJKxX0L70VdLxtUUjPmu9QNeo7a59aEWGTIUV2UTKYK6QPNsKGaQNFv2TRXjm6rQ00h15m7PjQTcUa6NjHCxIPNHzgcknZn3io1r0svjvkg2G5bBTTaDuWC6TeQhMt/HNWMlGgYSLD8V+WN/KTY2gliHvYuHjjbj9Clb4DXSPRfHjLZLLmJ10k5Vtmer/Ji/32ObAe4e8GvJxpydkS77vHE+3CPkyb7tFSSiEuT1jjKduxYu8IFUlxCZ+wbsmZ5ZLGnPZn5/AVch/GCiNrxpkEywjzvQFvQ5ncx2LvtVaZbhAcFWaXcNyhOuzuL4e9XTM3EbJZTu5Y1l0w3qbKbc68HBV0KmuOsPomvuyBerP9aZ8X/v3Mdxirg2NtlDIZlsR+YpY8U
 Y/4EkZ+I
 u7G8X5xc2fNYxot1hLwquJWqVSyUWo/0eqBr/O8ldoKRXdI4CEp1C7aqJQr9sBrqBFmPu4+vJiODQax02pnTHfVerCqYhlZcB2q89vzOeOpb6XG3NrBeozPyyAGvsItiZj9FNWSGcM8HNursJ3aRIcPIDgU+oCbfgh8DkvacDrfunh4mAxtHk8GIwOY7VJeLOPSXlXWmrXhCe9u0hywYU43jYZcHVFYuVyhQ4lTdEvOq5pTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a983a26d5298 ("mm/damon/stat: expose negative idle time")
introduced the negative idle time feature for DAMON_STAT.  But it is not
documented.  Document it on the usage document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/stat.rst | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index 754f98d47617..e5a5a2c4f803 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -74,12 +74,13 @@ memory_idle_ms_percentiles
 Per-byte idle time (milliseconds) percentiles of the system.
 
 DAMON_STAT calculates how long each byte of the memory was not accessed until
-now (idle time), based on the current DAMON results snapshot.  If DAMON found a
-region of access frequency (nr_accesses) larger than zero, every byte of the
-region gets zero idle time.  If a region has zero access frequency
-(nr_accesses), how long the region was keeping the zero access frequency (age)
-becomes the idle time of every byte of the region.  Then, DAMON_STAT exposes
-the percentiles of the idle time values via this read-only parameter.  Reading
-the parameter returns 101 idle time values in milliseconds, separated by comma.
+now (idle time), based on the current DAMON results snapshot.  For regions
+having access frequency (nr_accesses) larger than zero, how long the current
+access frequency level was kept multiplied by ``-1`` becomes the idlee time of
+every byte of the region.  If a region has zero access frequency (nr_accesses),
+how long the region was keeping the zero access frequency (age) becomes the
+idle time of every byte of the region.  Then, DAMON_STAT exposes the
+percentiles of the idle time values via this read-only parameter.  Reading the
+parameter returns 101 idle time values in milliseconds, separated by comma.
 Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
 times.
-- 
2.47.3

