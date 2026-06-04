Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D3A3CD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10FAA6B0093; Thu,  4 Jun 2026 01:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E79F6B0095; Thu,  4 Jun 2026 01:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025016B0096; Thu,  4 Jun 2026 01:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E408D6B0093
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:53:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BCF68D2AD
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:53:41 +0000 (UTC)
X-FDA: 84841163442.04.8B71DBA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8153140005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:53:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m8xTLEBX;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780552419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Y43OWw3vP+hwY6NUYwilLwmI43MkVQfgGGpOkPxK9w=;
	b=1fASRLnoHFt6WLWKQVVbD+jS3JmugBHlubNssrRk9I3H2Sbq/tR40LazQWay5QI5D0Ncu7
	kXrkIMKtK7Jo3pgO5iHshKbi/o2WN1diz6bemvHQw3uMH9TgHBE0X1nVcSa06WERccogRM
	WFMeBf80uKWlOzmqQyLgt23Dt6YvgsI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m8xTLEBX;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780552419;
	b=ws6pV5/U7fsN1QYy/lhVXbguHRMOdArwziyx1kF+VzztfdcUJQe1bQJUMcfqylyY3twFXg
	fH89oRaOKt754FEG10wfdlWtEnoTAJNm22hWeAdwc3aGbAwJGZgNirgzZxdGnGeG5tG2nV
	jPo0ybB9jB6U23wNR2r02jMSQP7Fm6k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7BD1302F;
	Wed,  3 Jun 2026 22:53:33 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1FA273F632;
	Wed,  3 Jun 2026 22:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780552418; bh=4rGQj+ttPYrbAPiFOCuG9APk6p34IFP1qYSW6A86tnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8xTLEBXa3wzGDuPDeF6Vj8jVWgoOeLm71olZ/hYv2RKOQF8UTzE2+9HroqAVpxCQ
	 y6XTey5VXwD85ArnHU+jKrOAYxECB1XedJLrOhNjCVxOTmqEi2RiXl/uBdoIUg/4GS
	 JQLc5dxE2LZVeA1B+E0awCz+y4P4OtFVX5WCvfN4=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	david@kernel.org,
	shuah@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kselftest@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v3 2/2] selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries
Date: Thu,  4 Jun 2026 05:53:06 +0000
Message-ID: <20260604055308.1947679-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604055308.1947679-1-dev.jain@arm.com>
References: <20260604055308.1947679-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8153140005
X-Stat-Signature: j4hkguysezxztytm1deawor6zjp8wa6m
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780552419-114199
X-HE-Meta: U2FsdGVkX19S6XHZYYDaUcEiVsyplD1mZdWt9b3E7qpYPNh190mtVZ4GHEZlDB8b7xUHTqsMJJX7xgbNPaJ1tW/BNoZWd/eD8l8g0UNqtnvYc3Pd2vgVF4stjnPDvgl2WLM0WQY0r9mGtAI8XLwOBnk42BFEIoRHu5Kdnr2QrvPx+0yJsnD84G4MNolXiSyXawk9EHM/lYDMXyEy2W8GoclWQ23HheVlxCQO9DQD7YVWqq1sTITAr3ex/O15xywEt5PkUISZJB7xvBPYkJuxBYPjY9odGFMQ6mRE/C6+/Rp1cKH77EGOmZpvQBwqU6cem4KmYB4IIFvoRd7PZ+uXVVXjDZ8wjzDjl+I4MlwRmSz63VfgV03TmJD52lPHcR2kRNvZ7ch7HEwBSTHnB0CiSuS54rZ2TwbsS+VeXr1ASvhv2S4jmlnmTzdNJfh1G/tqKQ4wCVsm0LtAhq/wJEyEthxrJaR0xiyEUMZlHD7GgjNwhmg3v2b8Nj9ZgDMwY010gypGDWGBODUh9QsXxzNiK25HX62c+kDQkDqZ7iYl0/kZ+yHgUurx3gALLD8t5jUKrVPZ0HOdmXtSJ+Lnk2DhII85or4Ua0TxFyDrts2rV3AvG4urynLv/2c5Qcnsng3GfzKacHoipGFuY1xw9lzmE5ZDPfLiL+ezDojB9qBK/jisGOVYy/7MtwxW7LOIsfy3LTO0wCF70TKq2+tCgNU5Rl/+DdGzbOnoRSH4MeB4fmmx6z8kQfmu5HVxEGnFWcDMvB12W2VLmaeK4vCc0ThcZD1herRD1nCcvwJcuMptFGxcOSBagZjyFaQ1jxALd2LrKFaxYh8NF3WI7uZqrekvD5a0bhijwf0t4sAWdJ4d6Hr1o3wjKsbJXo2qe559inCsgkul9PiguSmWfnW+eRWSbefcF9/fpkgwFuEjMSitAoRFk4c0r6s3Rpu449EEC2ipK85m8bMQ1fdOW9uYkEb
 dJlDYCGl
 6PDmuHVIlhQacyFscT01C3UxGYyAWIrAGJL/gloDS2+WRtkPLY9BIfXWDSs0dTSRzvMITvaLNNG9VEyEkjHg5lKEKO2ust02DGf/lP878r4vcy7CrGE1vUzdTuxx//eZnpF0TZkNEAWh5Jq7fw0nhjUt06WxQab3RPljgwy58rP+NPsW0p0oBptzr2WTRA0CaIsLHdr4lF39ztPxz7ixak7fnMaWCSPXLXxd3u4aHwVJclAAZIlZzp6fZ5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To cover pagemap paths scanning PMD entries, add assertions to check
whether a device-private PMD entry has the correct pagemap information -
the PM_SWAP bit must be on in the pagemap entry. Before that, we must
assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is
at PMD level and not PTE level.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 34 ++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e1c8a679a4cf3..46e0c8c921c3d 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2276,8 +2276,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	unsigned long npages;
 	unsigned long size;
 	unsigned long i;
+	unsigned char *m;
+	uint64_t entry;
 	void *old_ptr;
 	void *map;
+	int pagemap_fd;
 	int *ptr;
 	int ret;
 
@@ -2300,8 +2303,6 @@ TEST_F(hmm, migrate_anon_huge_fault)
 
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
-	ret = madvise(map, size, MADV_HUGEPAGE);
-	ASSERT_EQ(ret, 0);
 	old_ptr = buffer->ptr;
 	buffer->ptr = map;
 
@@ -2309,6 +2310,9 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
 
+	ret = madvise(map, size, MADV_COLLAPSE);
+	ASSERT_EQ(ret, 0);
+
 	/* Migrate memory to device. */
 	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
 	ASSERT_EQ(ret, 0);
@@ -2318,6 +2322,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
 
+	if (!hmm_is_coherent_type(variant->device_number)) {
+		ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT,
+				      buffer, npages);
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, npages);
+
+		m = buffer->mirror;
+		for (i = 0; i < npages; ++i)
+			ASSERT_EQ(m[i], HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL |
+					HMM_DMIRROR_PROT_WRITE |
+					HMM_DMIRROR_PROT_PMD);
+
+		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+		ASSERT_GE(pagemap_fd, 0);
+
+		for (i = 0; i < npages; ++i) {
+			entry = pagemap_get_entry(pagemap_fd,
+					(char *)buffer->ptr + i * self->page_size);
+
+			ASSERT_NE(entry & PM_SWAP, 0);
+			ASSERT_FALSE(PAGEMAP_PRESENT(entry));
+		}
+
+		close(pagemap_fd);
+	}
+
 	/* Fault pages back to system memory and check them. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
-- 
2.43.0


