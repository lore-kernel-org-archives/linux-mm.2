Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D64AFFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F696B00CA; Tue, 28 Apr 2026 16:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425F56B00CB; Tue, 28 Apr 2026 16:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BBC6B00CC; Tue, 28 Apr 2026 16:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 243E66B00CA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4F03C0AE2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:04 +0000 (UTC)
X-FDA: 84709146648.21.FD6C90D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C15F1A0012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KvvrQz/H";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3KYmiOhib6UgMB+RvvAlGmKtMO4Cjsc7yUgYi6viDk=;
	b=B6g6bWSXs/YkqIyVMhhMOiA5RF5c+hIDHT36jnbk0lhPU55573WcZahhXGVVvN9wq1fBOb
	9M8ZchwzRe+AM1djTgoXvxj/qgANEjZViG9TcPosF+KxEWhyLb9VzCKzMSF457OwJsYcXi
	CMwE0EyCvC6v8LH6WaDMwbWJ5FHxCss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409163; a=rsa-sha256;
	cv=none;
	b=FcH3Nk9eBgpYTBNwQJCiWAX475O4hFcFpwSwhIv7atIyagEsCg7BUPciliu7kt/ZE4pbqM
	tGVjJaTe+hFrZWsxNZsfd8MB522U/3sdVrGAUujgY7o0TpWEZZRrFfkABRl2kBPdjaTRo9
	8dEBJnKUohJC4zbyGLumSUiEQi7LE7A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KvvrQz/H";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73C3440056;
	Tue, 28 Apr 2026 20:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46996C2BCAF;
	Tue, 28 Apr 2026 20:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409162;
	bh=tO4w/saWs4TngI1dGJjVb/BDaQv7f0xtr7dZaOtNvYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvvrQz/H9MZvu86YAxyj5rQhIx/ZHPTpmdjW6uyN07IO7+ThUJ49IxJ86Ngu3/BjQ
	 ViQ+H54GPyl8kerSDJPSxgtRGtytzWYqT0iSSGocFwCdIODYR/1EE3IrNgG8EjaIx/
	 A05BS4zchquoEri2LpJ9bokTQm7yn3pejiBpXmeLnHwS9jTEmHqJ65Lu4o3BIJt4rR
	 NAl4TJbWorv+YtUcgbe0Vx7cCqB91HhWkciiaYFgBk+HgT0z9c6mOtwaJB2SNOVirQ
	 xes7xvc/+tXfA6EVZ8U50mb7VkZXNd1bc7xv0te4q+8O0iJOd2uPlEcviiE8zAwh0W
	 tIOa7kh4QNzoQ==
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
Subject: [PATCH v3 29/54] selftests/mm: vm_util: add helpers to set and restore shm limits
Date: Tue, 28 Apr 2026 23:42:15 +0300
Message-ID: <20260428204240.1924129-30-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3C15F1A0012
X-Stat-Signature: 3kmxzrq7drj7gbafotjeqhiiuh714d8b
X-Rspam-User: 
X-HE-Tag: 1777409163-816951
X-HE-Meta: U2FsdGVkX18WROChfoRh2jQ1qOySfwQPfSjMu1MsG+Okba24NULDcvZxcxDm3PBSkB/zySnN+69xPu6fTUjtMbB6kKm8khKupWlph4YsTsW0LBEm6sVyrEYDd+iaSsJ+HRdankixsap2ha4UZAzLpQj959RMjio6alNxmVTBB5ySQUpR2+pE/096EtX92QdAIVLQdXDdXiHbyoot9n8j27rwfq33P2wMEi6UBak1rR5gLIb9fQzmnc/Ahiu8L0vtt/nT0RgTvDCmIT75uvNA4FheNuVc9RnOmHJxVB6C3IHTNd4D4AI+wefeWB08mVhqht8+TAPCqXLFI1bOs36KRPkWUFKC5f7MpmC7jmHuL1XS2tuXkduUw+WZssbfMAsOX9x+krh8qgbT4kTqkfTG6HKcduMoNMrjpM+wHM0rqI+ZQQzpAwGPXTxTcIs5pDW4kM/p2l/SVOQvehgm4xpJFrE6XYBsl0wWetoXzoDaMW3ujoYVLCQ7lNAE0SQO7NKZxCNYRUh/smcTulI1QV1sWx3iA2cmeJcjj0xqoPLtB0cAbdR/Q+TbghwsweA84hcF+JdzEKJV/W3CKnCEspvMGByrvdeDiifeJOo4OwSekJDyHIIiIJcvY2MTrCGt9bZN4fBbGWDhGgs7SgSuEjK25MijbAKPVPhz2Bz/Sj5ltAaCYHAEgT65fZWeaY+biq96BKJb32akXLXrq3/NEx0rqeKQzyVJFbdfSMMW+vuKeBjpPhVgVXd7E6h3uBG4pIUptdS9ojHbp2YAJjHoqz9lhsgxIBOuN1jX+HW5RQJ93g5skaV8YYvazqPzuwGapa4XszPRm+NfL3JB81r0H+ATx+AKDwg28xoZwKIvEsp3cB8LuLdHQMVQ41+NjPeW0NKu/ObonOTvSFsnMtZbC4O+GGIBQHtIfbatgJL0TV6iUiP4KvuL7EgZWmvJk4pmzMmnIQ37dDPBRlwRpMtLZnM
 S3EdnuUA
 +YrSTr8c8zIvpPUZVxTlR3tek4FcVdCJUlmAg/68P0YI5nYP0qSu9dUgNg6gY5AKgbmN+zWHAlVS2/CXGsuXFPg/d+aoV9SJ7NJfxcDMfbdAbwaEIifOw9/7WvDEDDTkqLT3SfgxVNHU+57AV/fbS0sviCcVfNR3U9mcesjsh0El6ZxFSZGFTcPOe+MzDaz729lus84Qb6KaHVK3YJZFdV2oh72Qzv8xDnmWmr7W4i4QdpiPwkoz0uN8+/mP2snq/9wnAyJkgkM3RHzQQZsvMTfHOqhXMnlYVHyPk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-shm and thuge-gen tests require that limits defined by
/proc/sys/kernel/{shmmax,shmall} should be higher than certain values.

Add helpers that allow setting these limits and restoring their settings on
a test exit.

They will be used later in hugetlb-shm and thuge-gen.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 28 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  9 +++++++++
 2 files changed, 37 insertions(+)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 752566f75c0b..5a89c2d903be 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -761,3 +761,31 @@ void write_num(const char *path, unsigned long num)
 	sprintf(buf, "%lu", num);
 	write_file(path, buf, strlen(buf) + 1);
 }
+
+static unsigned long shmall, shmmax;
+
+void __shm_limits_restore(void)
+{
+	if (shmmax)
+		write_num("/proc/sys/kernel/shmmax", shmmax);
+	if (shmall)
+		write_num("/proc/sys/kernel/shmall", shmall);
+}
+
+void shm_limits_prepare(unsigned long length)
+{
+	unsigned long nr = length / psize();
+	unsigned long val;
+
+	val = read_num("/proc/sys/kernel/shmmax");
+	if (val < length) {
+		write_num("/proc/sys/kernel/shmmax", length);
+		shmmax = val;
+	}
+
+	val = read_num("/proc/sys/kernel/shmall");
+	if (val < nr) {
+		write_num("/proc/sys/kernel/shmall", nr);
+		shmall = val;
+	}
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 5fc9707f6b9a..ea8fc8fdf0eb 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -168,3 +168,12 @@ void write_file(const char *path, const char *buf, size_t buflen);
 int read_file(const char *path, char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
+
+void shm_limits_prepare(unsigned long length);
+void __shm_limits_restore(void);
+
+#define SHM_LIMITS_RESTORE()						\
+static void __attribute__((destructor)) shm_limits_restore(void)	\
+{									\
+	__shm_limits_restore();						\
+}
-- 
2.53.0


