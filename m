Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691E4D172AB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61F1F6B009F; Sun,  1 Feb 2026 19:55:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCCE6B00A0; Sun,  1 Feb 2026 19:55:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4848C6B00A1; Sun,  1 Feb 2026 19:55:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26DBD6B009F
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E62481A0992
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:45 +0000 (UTC)
X-FDA: 84397699050.02.95B31E9
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 16098C0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V5R96zu+;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gvsdt8gBwwkrCim/nEc53pgmTP4BbWKzy8tyuoNVZ4Q=;
	b=qjbg5i3Z/WpBs6VULM7h6I0w8VkvBTiWZPXK91DiLm+wQQc6oC1D6hhrsxQjHObcfLdfmV
	x26E9w1KQSKoDEEUDRQlhHGk+0+u+fIscC3mMMwhWzmFH7KxwUcJPsCX6kfiueuHn+2US0
	8KavrpbXA2AnLsm4Qn/s7/PtRenScM8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V5R96zu+;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993744; a=rsa-sha256;
	cv=none;
	b=8XjDpkPcowGU7WBOzApIpUKeecyPwh6MjR0wdqJ0YD5hksUp4zbDPVg+7UarciWO3oH0Rt
	hTjqtchvHrfN5IUOyRCE0BH4WyJVrilKQgK6Sz9SeC0ApltkNjCEkK1blHWsVAKKM09Gbb
	MR8Fu/E85YzuDZyQGyhnkiULHJeBOWQ=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-45c9fdf2a06so2735109b6e.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993743; x=1770598543; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gvsdt8gBwwkrCim/nEc53pgmTP4BbWKzy8tyuoNVZ4Q=;
        b=V5R96zu+xkDYKpEx3Fo/T4K8Kn2ZlsIQlAOoSmEwn8qy3G4uyHUY9F8ZMt+jzvtt/U
         VrcSNcMpIFdhMTBb3SOPgTmvN73UAKO4X0HKuMO7Dw/CR9cYeRSL9ndzRyiy9TTjLgP2
         wDOwGPMUov3qUcl/exIX4DM5XUjr1LX40CDQcckBeXRDBkSJO933mSqHD5ma5h1k0OYK
         4boiM4A8VQTX03OZTYtekGrEYT12/uyoyNZcTsJ0m8MaHE+/EpmLsiYzD2xSiRpEtkar
         OB3WYSwjHvR8XeTxReVfczJXJ4SLSaDLt2X+UxtxPXw0AOUZ6yD9lQAftKi2MA/aSg/1
         VKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993743; x=1770598543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gvsdt8gBwwkrCim/nEc53pgmTP4BbWKzy8tyuoNVZ4Q=;
        b=MZr6wAHzY+IWmQs3GmeeIHmH4Tbb0092dIFRb67Vf+FSSpnhsZLT9CcuoCX6R4RGPT
         QpoOMiLMrYHrt7KNMOHDY3bI4xfadhagvNCEiwGg8YOR0S4vTcu4w5SZ4q47Yh0vf/iQ
         X8Z5D6eF/DHHKzvMSsHDP1RA2tBduX1D8T3YD8vs5JMgVK9S8CB2+dXhB04B2MDoMXPJ
         +VJsN2KgciMvKdwQb2zjNTSUHtPOYm89Z3tGKVL7ihMA1nY/WTryNVsOvz9lnXsX5kVL
         eqBbnIWpByrPgDDpRIB7wLenV6CzAXmd3OnjfTU9ojxT19fAXVH/fATU3nkGcyxsvXT4
         PDew==
X-Forwarded-Encrypted: i=1; AJvYcCWKVmfbvgVNeSlTidT0RunAFC9fAlE9avpepG8h4bWuWYEtVoOgXkDcNgJgyO4Atad0o4iQUQD+Kw==@kvack.org
X-Gm-Message-State: AOJu0YyFDV06+0KxD7oUJdW6da4b+UiOYmM3jHUkbBF5dmm+m185gfFf
	euuc35ezSHsNuHx5mbtdCk9MaRytNkSvesu8oaIe6Cp1cl+0Z8msLWhG
X-Gm-Gg: AZuq6aKpOHGNtYjRTnnSMT7ajzf5StwuqkQbZxrLg8kMgdadeEguPamMPVS/iwIBng2
	8LEto1AA1QGhpdEYRkFwX27qz8lTYMYN33DDyfdXH3LV+CpRjWK0KS/tcACBTpGN0/SDbLxzvSz
	VvWXZotMJvf9Lz04KwfYEQImszz2Q8iEH+aVW0kNQt/YxyA7uIpvMaEjHEO/X9HjknZB050TtX0
	ojanwiSNc6M1GblyuSJeAzRgBh8y1Gla1ez9wQ+hKk9kS416gqzWFamX/rY891xeqgc1RbGtpRu
	zdm2RyC6uB+oyy6ZegAmV1K2ib25mBxqDmbQkjqDprdN/SRvzLs9bcslIDdtaxTOYRKWJXnrZiC
	nRTy8qIUWIVG79V5dy1LAwRiOkbFmc8xdUr4TxpzyqAfW6fK3pTytHWdcYDi9O7jny2CpAIZG9e
	EycQNXtus=
X-Received: by 2002:a05:6808:c1f9:b0:45c:75ec:b9d0 with SMTP id 5614622812f47-45f34cb4ca2mr5143633b6e.34.1769993743045;
        Sun, 01 Feb 2026 16:55:43 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45f08f6010esm8293308b6e.15.2026.02.01.16.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:42 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 12/12] selftests/mm: add PUD THP migration test
Date: Sun,  1 Feb 2026 16:50:29 -0800
Message-ID: <20260202005451.774496-13-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g997z9ahxorukcncode3aaizj91jixyt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16098C0005
X-HE-Tag: 1769993743-1875
X-HE-Meta: U2FsdGVkX1/7KzmzKCV51ivjpmzVdfJDO7/AL3Mm5/5c6HDmvEJRz5UlWQNH3EEw7kz0PVE0/DCKnmQb1uttsG4Uw91KCKaPiFQHibIoXNIzQ2hUrOzDBp2AEBTHEeREijPQPO88u82P5YonbTiRQpnhsRlyzsX+LaQz5YdXyV6X3cv+A5vrLsVDuxFbX2jLabqVnAYPUtbfimjp5AhkoWwA+E9spSezCMgyZqOf6DD57z4vnhw05dtpY02RuqMAd7FyMwqJLqp7UEnM7OL81R7ofaLyK3gGM6CZAirBi/ctNNEGKr0qeJe0n6s0Imu0DYRuDF5dMfTWQ/HtUw78DkY2qNimTr58DAxiaS10433ePeHceNeXNVG9PfD5LlgOBemqzWN2cCYXJSes3vqGTf8N+alHHCX1HuDYtxtQIOmYK++NOkF2WatoOzImC1Bj1qdd2qkVhBlUPnH/EG5SdqMYEALA9kPisNUvd5a9G2A9ddJ2p/A1saDhlZOnK36rCzoEgiUc/T/azuv7ubddlWjskZpqI79Bx4/HQYmVTvezET2EqnQfxIgwWWbCLmZ18qC1zMuThVHtWg2F021UuKrTBn+eA0vt4ebNG/1yq/NjH81pokVfYMsAdvE2095S7jmoM1Brdkc5SB118QCCOSQQAvWe9mRLsCdwnHT5ZzFVcayjMGBqrnzC/NH7YAUdavl1qRSSQgFmcsGRC9YoCoRNEPZIdGIPPrMyNNOsENbkvYl8Av6bqPQ9kx2m7Ealmo0HcyokW6y7izF+lA6L3nmzzrqxudrEQqrsEh+RvUUx+2q+3S8DrtqtDAPre9K2oHRhUtvtLYEA/B3TB5wlMWS5ip/JZ5gtBk2JQFMIOuBxkELZI1IOr9/3zSlu6PaskGyVXaGYmsybaRUmY67Q0ufa/eW3sOdMWIuMChOD+Psor8IDBoLVaieFD8OFegLLPSuVPlLOJbrzXDlRqBQ
 JhIukLL7
 UUkKo2fkbxay+ODskRGFNZeOhuM0NSEVygn4tNvF4qtJwQwS4pKurrlWB/3dCWiwSrmwiLkSJcsROHTWmfgDjJU6P/BxIH0plcrsPsrDrjv/xXQhYI4OzX5BwqupDJJEPkDqCK9AcxY1J5oKqdw1+YtwlfylDCHwAhXA/A/PNXM/yKh5PYhqDVYbsREmUF1o4iArhN5HfaC+XAkFaY7/f/AFDFZgNAOVbQkEiGyXt9zNTxYlE5yYxpwweNscyaBa/499ib+UCeRNttGXrPuLJ0vK9dacy3UwUTi3GGq0aKRvT7/4zMI1BudnJhd7Y4J34gTdmAcHKiu1ckdrws8UPhpun3JJWiZf5+pjZ8KRBn59XPUsbK5n+XOcVcxSBZPF7lEjND1ybGW4V6HZKG+RvWwbUmVJNacDON0iHTBJtK9mTZiqFtcbdhKhq9qD7jWOTID2uUS+YFC8jtBzrToE0Ec+CMIuzrMOxetBym08eU3kZRpjowhbOm7+/MQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that uses mbind() to change the NUMA memory policy, which
triggers migration. The kernel must split PUD THPs before migration
since there is no PUD-level migration entry support. The test verifies
data integrity after the migration attempt.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/pud_thp_test.c | 42 +++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/mm/pud_thp_test.c b/tools/testing/selftests/mm/pud_thp_test.c
index 961fdc489d8a2..7e227f29e69fb 100644
--- a/tools/testing/selftests/mm/pud_thp_test.c
+++ b/tools/testing/selftests/mm/pud_thp_test.c
@@ -32,6 +32,14 @@
 #define MADV_PAGEOUT	21
 #endif
 
+#ifndef MPOL_BIND
+#define MPOL_BIND	2
+#endif
+
+#ifndef MPOL_MF_MOVE
+#define MPOL_MF_MOVE	(1 << 1)
+#endif
+
 /* Get PUD-aligned address within a region */
 static inline void *pud_align(void *addr)
 {
@@ -315,4 +323,38 @@ TEST_F(pud_thp, reclaim_pageout)
 	       self->split_before, split_after);
 }
 
+/*
+ * Test: Migration via mbind
+ * Verifies that migration path correctly handles PUD THPs by splitting
+ */
+TEST_F(pud_thp, migration_mbind)
+{
+	unsigned char *bytes = (unsigned char *)self->aligned;
+	unsigned long nodemask = 1UL;  /* Node 0 */
+	unsigned long split_after;
+	int ret;
+
+	/* Touch memory to allocate PUD THP */
+	memset(self->aligned, 0xBB, PUD_SIZE);
+
+	/* Try to migrate by changing NUMA policy */
+	ret = syscall(__NR_mbind, self->aligned, PUD_SIZE, MPOL_BIND, &nodemask,
+		      sizeof(nodemask) * 8, MPOL_MF_MOVE);
+	/*
+	 * mbind may fail with EINVAL (single node) or EIO (migration failed),
+	 * which is acceptable - we just want to exercise the migration path.
+	 */
+	if (ret < 0 && errno != EINVAL && errno != EIO)
+		TH_LOG("mbind returned unexpected error: %s", strerror(errno));
+
+	split_after = read_vmstat("thp_split_pud");
+
+	/* Verify data integrity */
+	ASSERT_EQ(bytes[0], 0xBB);
+	ASSERT_EQ(bytes[PUD_SIZE - 1], 0xBB);
+
+	TH_LOG("Migration completed (thp_split_pud: %lu -> %lu)",
+	       self->split_before, split_after);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


