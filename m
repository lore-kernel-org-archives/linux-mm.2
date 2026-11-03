Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECEDB606BA02
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OyTBjdX3
Received: by kanga.kvack.org (Postfix)
	id 0F3F86B05BB; Tue,  3 Nov 2026 10:02:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6316B05C0; Tue,  3 Nov 2026 10:02:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25956B05C1; Tue,  3 Nov 2026 10:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4DEE6B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:02:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CFED12045E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:02:37 +0000 (UTC)
X-FDA: 85394124354.12.DFAA57C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A8C9D40008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:02:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OyTBjdX3;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U9IkzZm34rCCgwwxhYv9RGNAtGYJYLV1upi9Qm+KRR0=;
	b=Kc+uH/a9XOlyPZ63fVAwuCBHGklsQvv2PPe/nCxibMpuONV3JPNh7I1mmIaYtcgc2XRz8U
	cNG9eE5YavRxXCIZ/EA7raMR9XbXCM+zrR4OQ6DhXuVg1jFLOCtnLz1erJf8Qyi2u7eJ1b
	tP/xeptTZ+9h1cRKwaU91o7Vjrq9hTE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718155;
	b=EIMMcXkgeXNA3NZetfboczpBhOJu9cIXVTv2/Ya6s0cnhrXYw0DTK0x0EGkSshhjB4D4ZZ
	Y8wAN4HAn17rg7+ShZ3CQ4WpINk43MUvSRPoTX5ypgjjkHj80vuxT53oCdjDXgHvH8Hifr
	Jja4a+OQPCGZ+LjEStbGTNV0C7yWEPY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OyTBjdX3;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D6E554195A;
	Tue,  3 Nov 2026 15:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9A91F000C1;
	Tue,  3 Nov 2026 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718154;
	bh=U9IkzZm34rCCgwwxhYv9RGNAtGYJYLV1upi9Qm+KRR0=;
	h=From:To:Cc:Subject:Date;
	b=OyTBjdX3/O/77emKUjMIfGN3cKSCmukSiTZ752wiHDG9WLvrB9qQYKO8ht4WhajoF
	 lYK8EDipEvLxf040Lpl+aK/97qdx5k8G0HT3MPO2br2dlKRCr3HiG9V/C5UR7Kzuqg
	 D3ghy58HuzNyzHDB/Pt6recTVr0vY4GmIU0cp046a3QCtUQ8nevmVCL226WfgbqAIo
	 ST+b79klpCXua6UBlbPduChw/aLJFLlzLkngz/GwVkfb/OaKr96nf1c+U7wV7TmIm3
	 AQ63gllNewgdmm508klPOH/tbrcECb3c0iNLvxnhbTXZDfrHlhK2wAchkKLa8h+izX
	 e0lT+ROJioH7A==
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: uffd-wp-mremap: keep the THP sizes in unsigned long
Date: Tue,  3 Nov 2026 10:02:32 -0500
Message-ID: <20261103150232.291827-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A8C9D40008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n88mzwyremj4dg5xguxu986q5bu9reob
X-Rspam-User: 
X-HE-Tag: 1793718155-166648
X-HE-Meta: U2FsdGVkX1+fV8P3b1OwV+19qf7/054/BWBdhEHERb1qurCkZri8+TNBAdGVdinXxtdZqK7x41Dkm62cBv5QemeBwZFiQ7rWt/erfB7GHUtM4HcM+jl/cgI4rTD/K8zsJciEDtgZonlYqbgYLjKSZDmP9oUc+seTSNxs6brA38gHf5qs2qnJZYJST3G9mQsDCUjvu0hNtnqH1HPu6e03gOTB7hJ7GLQCuOBQDZNij4uYIRynt8o8uIZMTGgkZzqLYUydqWny4iKNZmaASfNOUQEgiRq0ftxGcUq8NnQCwpjYemk+Lz+z2b5fCG6p/YneJbXcAW6f23eJln/+jLzJrccaKI9lMQsrcCETT9u8XPsyXYvFfzC3g2WgJ5DlcWnBYCCWyCiiog1LG3tnNB8fg5KvjuTHgzOrA5i0O42xLwXl/VXycvgA/9r3RnHv59Y3zBD4F5s/JMilaxLcNl1RLcms4T4/yhYxMNS7akZ7ATQLfhtpiyUXrV2u5aAHX6anysSf1KS8uw5HUZ2rbxXxy7TeJSv0xrwKh6YbSfNmPE6C2hiXqjEyo9aNRf8oQnRXkp7zyS0PZi9Zu2y6HuXjzhAbHZiH1IjapjUMw9xfEhNB1TlQJej+/LnN0RvHG8AJl0+u2BFa5+ugbUxus3SdSzW4CY7nHc4pioGO1Cy6dq/qW0sxe0lCtZ/30/ggc0A/ALOsTqptSzlACs5h/Szp9A3zBrXNmX+RUn1H4LyclXIRfkMSJVNeIIccNBYWxPsZqW4pq8ZpcznpSFNkl0pN4NcOcV3vQf8QYv85tTIo2kpqCEyIEKQ1KtUdYsY0ro5w2Z8RqmZKQPxEvWFD1xNGduG5jMCMlmP4mcDg8xnnN3FK5NaWgwnm2VQpLlNDfqX7Gc+ioEJlFUO6Rdd6r8cU5iLdCQnABzPnBR5VHZGh02IqobrtisS6ugDiq3i1EZywbGmNKkcrSIeX76xrOIy
 kF4JtFMU
 wLLZMNBk4KwFQUYAmHC5oE2zoIRFVSitUeduOGxNM4WtqMpafxFY/HmN7eI8uUC64Q1dDQw3av3z67hYEI0+MOE+joT3tWHIgpZ3Chqc81S++Y+SiEdM7mz6/cQxfb3VUklM2VTPZXVjgkm6qASPR+g52628jtZf/OeXwvIjU24omBaeECSp2THWfczlbW+B9KWp+NFM3AGJeML1N82Z58pR1+i9sI5FZMmzGK2GcmdxDv6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 0020a1f5ca36 ("selftests/mm: hugepage_settings: use unsigned long
in detect_hugetlb_page_size") changed the sizes of the test cases to
unsigned long, but left thpsizes and detect_thp_sizes() with size_t. On
32-bit architectures size_t is unsigned int, and gcc 14 rejects the test
cases that point at thpsizes:

  uffd-wp-mremap.c:299:26: error: initialization of 'long unsigned int *' from incompatible pointer type 'size_t *' {aka 'unsigned int *'} [-Wincompatible-pointer-types]

Use unsigned long for the THP sizes as well.

Fixes: 0020a1f5ca36 ("selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
KernelCI's 32-bit arm kselftest builds hit this. Built the mm selftests
with gcc 14 and gcc 16 -m32 (four errors in this file before, none
after) and natively with gcc and clang (no change). An i386 build with
clang runs and detects the THP sizes as before, up to the point where
the test needs root.

 tools/testing/selftests/mm/uffd-wp-mremap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index c48eaab8e75cf..fb5582ec5b201 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -15,7 +15,7 @@ static int pagemap_fd;
 static int nr_pagesizes = 1;
 static unsigned long pagesize;
 static int nr_thpsizes;
-static size_t thpsizes[20];
+static unsigned long thpsizes[20];
 static int nr_hugetlbsizes;
 static unsigned long hugetlbsizes[10];
 
@@ -30,7 +30,7 @@ static void check_uffd_wp_feature_supported(void)
 		ksft_exit_skip("uffd-wp feature not supported\n");
 }
 
-static int detect_thp_sizes(size_t sizes[], int max)
+static int detect_thp_sizes(unsigned long sizes[], int max)
 {
 	int count = 0;
 	unsigned long orders;
-- 
2.53.0


