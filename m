Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFD9F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438236B025E; Sat, 18 Apr 2026 06:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1E16B0260; Sat, 18 Apr 2026 06:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289FC6B0261; Sat, 18 Apr 2026 06:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 133366B025E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D97EF1B7EDD
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:18 +0000 (UTC)
X-FDA: 84671377476.20.13BA7D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 33E19140006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IGeA0rJG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509897; a=rsa-sha256;
	cv=none;
	b=i80jjy2m5oAFrMWiXoXousgIEx3QrgK7hDg2FEzQ7PKZ2RrS42d4LDBS7nzv3PWvFZEK6y
	x6KOZ2/El+AuBD7JeUTYoa4xUmtw/q/ZeU1Pyn/Qi7DF2D3X0/T18ugiOrRW/qcZ1I/eSb
	flwbBPbodtLPxOxB+wqoTClpePUK83g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IGeA0rJG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VUcD001jzpiQXtrj7RFlcVDxuMqwRaPydFSJTdD1Bc=;
	b=JT31e6v41HB960b0C3q9SW7zBQrY88WWgTBcHfkoW3LaVZ0tc8gNvLoTo9jymBgxsSOoqC
	0LfPdhQuYI3mc7fphvjU+jsaYUBpNYBiodSZgYbWQSmtbO/JM/Qv7a37xFCTuRQDdJ0IM1
	nHB/XaSO4483gSWvAcg+kGUXPvCi9p0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6629040890;
	Sat, 18 Apr 2026 10:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7C7C2BCB3;
	Sat, 18 Apr 2026 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509896;
	bh=6tmwrYqrWIbuMw5GfhGQhH/MUUQ+JMHsDHml8bmka3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGeA0rJGx3EWp9zaN0FaHGeJ9lm88kv7Bj7KXhkxuDxTaqqIzTlQsYOEk+jLaeFt8
	 FTyfJkn+83E5IkPSZyF/k1gHsjGb1COu3oaE0i7mUUxIauWfNI8s9ws0BaaB5ZKYq/
	 732rTBshW5d65zXNh87oPwri3SVXrEdZ60BlDqmB95Mn18DB1m+EAxoSAN8CY8bv3/
	 RbyenMAz6F7hQsyOCLvghFYFLYTiaFul8Bw1D4DWM7A7STNWFvg8i586c7KMh4w70l
	 A3J7RNJrd9Kxtd3kG4BFO3d+LvT8zaZIrQt4Fn4S93PGQ8/2UBxJMao4UlR8pkVfxm
	 AuR81iyjr58Kw==
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
Subject: [PATCH v2 24/53] selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
Date: Sat, 18 Apr 2026 13:55:09 +0300
Message-ID: <20260418105539.1261536-25-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 33E19140006
X-Rspamd-Server: rspam12
X-Stat-Signature: gz95xrh6yckfhxnzwtaz6dsxgzb9btua
X-Rspam-User: 
X-HE-Tag: 1776509897-190288
X-HE-Meta: U2FsdGVkX18XVfCSNN0UUsjL75Ztmf63dVhewWjRDs+dsgUWBBCHATotPBOLLmG0Q8srqXDtr7aNS7iG/xMSw9T/msY1Nd54aOn3f9Bx0pcAyiHzozurvuCAfe0BbB3LYUdOXUv+tnCM/23qxgshzbAhUxx8SNzIYXVhi1i+fmfdPt3cOsXmX9WGpFROayIONjESWanNlIKY0vcEcfqVbwN1dOeKlrQFQZtd6iTov8/YZ1xwpGFQfVaP2DgAveXbBHJ0u7GIb4S3OwEmgbthct94F3V1r2pHxxoPOS4q8EhSFYQme3GFyIfzB5eM+eptFeDD2fnaikxc+3ukEOI8a7ZwC6XKV/z+DqBltxvlwYgaVhEh0qkEA/XWg3t1a8FaLIwErpY7gH6j6PxZZgrFi4q+DdeCbKVoA/R7sD5pFXmVj/GG4k4l/UJwOzmCHPC88yJluJSpAILQdzx+qeJkPXO5brNr4NwDMGDtfoE8aQIEYCoNABzfzKeexuLgUHYbktGK6gPGzQCCvLbNBNHEDIqBPLpTvoYPGPpMbp2UQdToPD6nY8PcLGAthOLPp/ISP4KoqwuTVGlO1lglPjChLlNZRxZ4sU7JQzQSpiS0kpUDle4zGsU4p5gG7JRoP4RNsCejtO9Q8ifTm3dlUp7KPLytz6yNtyu9ZUyRDOmcm/ST2cQKihxLAw+UtTBOudNngVM3iVGJyGCTP8grCJWBwxrLqT5dIRIaB9sgQys9ucGacifAjnK2JOrMkzDjXQMR3N05Y+nlgBLzS3VB+RJpRmwJm4F+rjA/LdJvSOR4b4zkedBr3D7lZsAOhILRCCtTtRJdcJvsyx9RLKJ8KPxsuTVnJr17c+uRqpPxqxc3TCBCYIJocJcVkFIG1G/6TRQ3ejJKzkqHKtpDgl+cZ2ERQ//gUFq63UEFlSxOgKfwW+DxR1syeneSiOwWtHHqQ44vsds/Bhde1FxTwM/plpz
 MFpWiPtv
 7HAdCV3o6hiwODpuRHwyBa1EmeTGIUdqMwDLr+VELrLOaSxzLizEJRAeZ0bnjash4mf0UFe0bF2+uf8QkrveooPBkBpE9fXUbQJLcaELejxZe/BwDSRQT7l7EB93/ZrTUX89dTZ5NzElXaDbKdO+YbYhFhmT6+HS1t8UWcjggFhuuoI3jqfb9pSuVqdqWcoxATnrs+fkz0J5/FwSB6meJoRtiAYB0Pch+HkU9DdOAWI+MXoyoCHtoVeVaW9M6rkh+uyKi41nwjCa5OvmahR4NuwatE2jFtFTnAgnO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Add APIs that allow reading and writing of

/sys/kernel/mm/hugepages/hugepages-NkB/nr_hugepages

to detect and change the amount of HugeTLB pages of different sizes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 25 +++++++++++++++++++
 .../testing/selftests/mm/hugepage_settings.h  | 23 +++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 8f563315b1fc..5961229b9931 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -464,3 +464,28 @@ unsigned long get_free_hugepages(void)
 	fclose(f);
 	return fhp;
 }
+
+static void hugetlb_sysfs_path(char *buf, size_t buflen,
+			       unsigned long size, const char *attr)
+{
+	snprintf(buf, buflen, "/sys/kernel/mm/hugepages/hugepages-%lukB/%s",
+		 size / 1024, attr);
+}
+
+unsigned long hugetlb_nr_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
+
+	return read_num(path);
+}
+
+void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
+
+	write_num(path, nr);
+}
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 9357d07e6c1b..d6f41a45e8ee 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -94,4 +94,27 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
 unsigned long get_free_hugepages(void);
 
+unsigned long hugetlb_nr_pages(unsigned long size);
+void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
+
+static inline unsigned long hugetlb_nr_default_pages(void)
+{
+	unsigned long size = default_huge_page_size();
+
+	if (!size)
+		return 0;
+
+	return hugetlb_nr_pages(size);
+}
+
+static inline void hugetlb_set_nr_default_pages(unsigned long nr)
+{
+	unsigned long size = default_huge_page_size();
+
+	if (!size)
+		return;
+
+	hugetlb_set_nr_pages(size, nr);
+}
+
 #endif /* __THP_SETTINGS_H__ */
-- 
2.53.0


