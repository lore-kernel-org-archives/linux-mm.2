Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0B1CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1508E01FA; Fri, 15 Aug 2025 09:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C4E8E0003; Fri, 15 Aug 2025 09:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43278E01FA; Fri, 15 Aug 2025 09:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D10138E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:56:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 669571A0165
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:05 +0000 (UTC)
X-FDA: 83779140690.09.0C1FB6C
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 608BF40008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gjM/W9Df";
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755266163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKLbQqBppRJDcJgKqWsD8LPR5qN9TJ+cj2ycCND4QA8=;
	b=Je1QLzkZ5BKcozvx8uFvBBa6J1xGnTmu3kz5/RA7EhalQffxnlfYEKJx6oXHN/OvNrfali
	gYe1tdg0xYYi9J53brZc1FSFW3D/N4LiGLgibp8HLvraCf23mD5vzE8vcAZILFBZKhF7KI
	4QysLN4lBQfjTOurg1d95EPOHdJ3AGk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gjM/W9Df";
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755266163; a=rsa-sha256;
	cv=none;
	b=FbZNb0XVlYkcdGC4cGrBYHBHA8/TXw0F+62S2zVnHNDiqsK4Al5p6mK0pVVdDX9do2szwe
	LOGUBIxfO1YPETa4OZHEwwXQRVvvMmkZceB2/B5tQOxwt7W0M+jOvFLdgpHwa5b9NYvQAA
	712riMWrDnAl8fzZmZ+Wy1/hWsUqPvA=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b1098f9ed9so13024811cf.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755266162; x=1755870962; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKLbQqBppRJDcJgKqWsD8LPR5qN9TJ+cj2ycCND4QA8=;
        b=gjM/W9DfEXOExY4ymHtL506OvXa/HIc9KGCJXeXSMp8Jlhq4AH7QvwhINJxeVsE3ik
         PCoNQHLVoTE47ujWKeWw1OkxBsz+aTXL9ytQYV8H1rTrlnNPLeTQoezGYcgSw8BaaJz2
         HFhSDjQpobTIdpH3JRyYjM6Uz0yLh7058dOhrJHvU34LDXzy8tWql4OaAGufSghWJI3h
         5duiuxQI2rvAYKF7ihJ4mepeSJWd7tucVcFMVVK++YuyZmPsVmQreyTdZ3a/KQF+TjL6
         NgizQdkNbrcb6Tga59+4JbzV3TrzE4KwqU1c1FDPvfs6CHfXRZaL4bKmEGdfRDsiJrde
         FJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755266162; x=1755870962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKLbQqBppRJDcJgKqWsD8LPR5qN9TJ+cj2ycCND4QA8=;
        b=wmKe+RNNwZHRt0Rl8AOPmXU17pjMjbRWU9lURi1KRzl5L+1ZzEbsg9ViLu0KuidZRR
         vJa27Bm+fKpKLQZL+SVd5WNygkkeSQDYngMGNUQfFNGkZJR0tLjBAbboHMdjTrwUcpch
         1Q5rP/2+dEKbIeVmasyeMEfdUdsGm5LtoxnjfYUMfuhzkxy3MIHsCFIM8a3y500QABSb
         E2G3cOg0uGtDHbWXtUy+SmsFSdd7QNKdP+p+rMepWnSkEzQBAGMDZXpobCpjwFPv94PJ
         mUHfh+nhNzBIHfQPUWdOoYDXhj/DLIzJU3Jvwl2hu9LrEHlCOIXcgPnEwI2Y1xXdHQXA
         ZrIg==
X-Forwarded-Encrypted: i=1; AJvYcCV/O1qYCk75R6jloD7sHc1rRUFWin7hsmFA1RF/doX/vNVhJiTuLo/fQkgPOB1KX6yIg+xpSf9rNg==@kvack.org
X-Gm-Message-State: AOJu0YxaIZAlWW9Xl/lXVbnhc6MgO8iNwpGyzYVyBhyfO50lNV4hYQ/O
	QzrkqgHNlmS7DEoVTU0SenxSg4tlyZP7dAcCfjHRj58HINRcg1JaGMF1YL3MN7+D
X-Gm-Gg: ASbGncs+RoXN8PJHUpgdqQbngrqivmsTjDFUSnaZs2abK5z6biaYB2ZOxVaHXq62Pcy
	Tq2ATYgCAuG4H8nF48Q48sVnfja4gkrgRrCw8yvbClGdqMwBpbC8pI6WkArlGliTqTGGFD3p1nD
	iunGnBEliAFwt5t+SIQJKnauageZcckKyA1eyd+AUC1X/OeR9sWbe0sbNTxE5LEi4yLk1VtA0hV
	AATjlog8c48N6H5zeWV+n1wLgKkgl8ayqEP7IbCYgA0iq9rgrDO9nmtB0kvNzGKhl1W15VrVvqZ
	VYeFeRF/ZV7wLg2v5O1Vpfh0bG9pEPwfzQ7Ix9+eS+XTcsfRg12Nw+KJqbtD79FLv++8jjtNnPJ
	c2PQweUjI3pfdqhY1Wpc=
X-Google-Smtp-Source: AGHT+IFRUMVXwq9t9zoppX3jUjPgp5npqXSGShrgHAx927648lNHSf66xRhiQlIDhKL6ceNqK3JUkQ==
X-Received: by 2002:a05:6214:c43:b0:707:3cb1:3fac with SMTP id 6a1803df08f44-70ba7af6bfbmr21560886d6.15.1755266162144;
        Fri, 15 Aug 2025 06:56:02 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:3::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70ba92f8c73sm8074566d6.44.2025.08.15.06.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 06:56:01 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v5 5/7] selftest/mm: Extract sz2ord function into vm_util.h
Date: Fri, 15 Aug 2025 14:54:57 +0100
Message-ID: <20250815135549.130506-6-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250815135549.130506-1-usamaarif642@gmail.com>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8p5j1yqtn7irjonhhuaizogscta1wy83
X-Rspam-User: 
X-Rspamd-Queue-Id: 608BF40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755266163-920854
X-HE-Meta: U2FsdGVkX1/0OunbhNSzbhD1PCPCxQWGls8YrlD1IoU6FIis2CYfPlZ4eoVrKuyfY/N0OJZxL+eVF7n9tWPkNJvROR/OR1IQqhqYC4X47xYH+1SIzqbpiJPYyskzPpfrG0oJE8LlT5v80mMlyyHWEdmSkkgcOZ2tz9xteavnobMQhZedZM0/r4aubs9FEVf0qJkZCYir31iBfJqtPo4QSrg/8GWMJowm+AKUPoYAIf5s54EWdxLmA2PaNtAltKNqsIGSKmywQmak2mTO3ntj8RZIRHyeJ52A33QJAzVZHMitp1y+6meT0x076Fb8Zj7Ym58AazYJZGpj+udPDsYwQgRqef8/VAJZVxAANFVc+Enm/t+we4zTHW4shsUJSc4hQQfpGWp/sa8LEUM/FVbFO1zI0RpKlIWqASsY+mPCuWqbv0cV+W9S+LoMoEW9yQeZTW+Sg6JvKKTBDFOjiXiFe96tOsUjkD8jyOpIqqTzHYfqC5YlvFjGshz1rZ02kslodYBdIBHjT+kgvJ1cJrmE55Hpt2sesFWhJkxxYoLi102Sf2w1x9VTz+H/kNxQaF+e6CHYnrIusD+0lkMZeplfbPFIFKqPQqB5MA/uTU6YyF8nwo031cgbCGioJTk2IO+Rcvi3IT+6NhhjYLsHojfteysgl5UHk20Y8uHAw+PBlgKqRQEXYrwbm7ZRYnIh7S65mkjZq2olIiRs2FBw1ykZZftptwU2MT1zVZqd3RFBbNwTc/bhQPDNS6EmlWnp/MUUqKjE1mm//Y3ckn33Jy7VzoILp+BOEQS+V3kVDzAqP4T9Ly8rnTxBSI/sKp8HnilTWMvkMxYsdzt9AuZHtNT8L40IeWNqHqDfmaA/z/JnNi5ulUp+txMxFiMO/bIEMoohzUlt+8XpcLdSVpV0ONx3CVkCeumgTTiXpQ7tgszqgDwsniuZT7YMKDRNaxjaHioznz8l58b0NmuIfYuTINw
 8XPfAFPU
 TtCI7FSbCv+EcCNDhYE6EgTpfh5uKspSOsZhiesOKKEMSOeBnJzu7VpNDnHqCuz8yL4IYTuEnxJNu3+0WBimYiE4EHcZFoESSeHeSw3r9yxEJlrA1n+uIncUjWErjMnM7tIDwJXIAvYRBqPPF/m1nWODrk6z9QRTD2w7Wkpw8aJHpLoq+EkTRDkHLmCH1evfqa7KXNKMz5bhqGLCOjutfjDq2/87tRZVaLmu9KlZsZLrYVoqk7Q4da9ebR48+6ZY+oy7g7vDC/YfibtoV+GOw097qDiO5I6zTWEZb/7YYKUH9gdHhUpEzLJhO29v1pTyQACjn9+C06+8E97fwPsQopQGr5rM8YFHwEHU+LeEwJY4DPVSjBWR7oV2sbrtObMfdcQCu9sZwcSnN+rhP64Eu/keQxeESwcD5elTVAjIrQeJK19FtkcXd8cB3ypsq/EgsN7eI4gLJM+ezmtSI5wOQT/21Y8nncb5DAQazaGWYgwlKovDQU0T+oUpNuFQh7kNpIH679jzdbikoBdqyP7QVxQRyEoamqvGk/iGa3z2dvFWo/amawFBtevP2FeLXxQDD+Gg2ZLK7PaAkX+WT+8zDDrbZloUkFPtPw6Fltn0pcKMpfci9DcKTtPgXkpEbe/4FVHHbT5W/s6JlmwBkPNUhEsvvMrYeN2Ng2rRNoHZz/tPYCnk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function already has 2 uses and will have a 3rd one
in prctl selftests. The pagesize argument is added into
the function, as it's not a global variable anymore.
No functional change intended with this patch.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/cow.c            | 12 ++++--------
 tools/testing/selftests/mm/uffd-wp-mremap.c |  9 ++-------
 tools/testing/selftests/mm/vm_util.h        |  5 +++++
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 90ee5779662f3..a568fe629b094 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -41,10 +41,6 @@ static size_t hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
 
-static int sz2ord(size_t size)
-{
-	return __builtin_ctzll(size / pagesize);
-}
 
 static int detect_thp_sizes(size_t sizes[], int max)
 {
@@ -57,7 +53,7 @@ static int detect_thp_sizes(size_t sizes[], int max)
 	if (!pmdsize)
 		return 0;
 
-	orders = 1UL << sz2ord(pmdsize);
+	orders = 1UL << sz2ord(pmdsize, pagesize);
 	orders |= thp_supported_orders();
 
 	for (i = 0; orders && count < max; i++) {
@@ -1216,8 +1212,8 @@ static void run_anon_test_case(struct test_case const *test_case)
 		size_t size = thpsizes[i];
 		struct thp_settings settings = *thp_current_settings();
 
-		settings.hugepages[sz2ord(pmdsize)].enabled = THP_NEVER;
-		settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+		settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_NEVER;
+		settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
 		thp_push_settings(&settings);
 
 		if (size == pmdsize) {
@@ -1868,7 +1864,7 @@ int main(void)
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
-		default_settings.hugepages[sz2ord(pmdsize)].enabled = THP_INHERIT;
+		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
 		thp_save_settings();
 		thp_push_settings(&default_settings);
 
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 13ceb56289701..b2b6116e65808 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,11 +19,6 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
-static int sz2ord(size_t size)
-{
-	return __builtin_ctzll(size / pagesize);
-}
-
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
@@ -87,9 +82,9 @@ static void *alloc_one_folio(size_t size, bool private, bool hugetlb)
 		struct thp_settings settings = *thp_current_settings();
 
 		if (private)
-			settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+			settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
 		else
-			settings.shmem_hugepages[sz2ord(size)].enabled = SHMEM_ALWAYS;
+			settings.shmem_hugepages[sz2ord(size, pagesize)].enabled = SHMEM_ALWAYS;
 
 		thp_push_settings(&settings);
 
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 148b792cff0fc..e5cb72bf3a2ab 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -135,6 +135,11 @@ static inline void log_test_result(int result)
 	ksft_test_result_report(result, "%s\n", test_name);
 }
 
+static inline int sz2ord(size_t size, size_t pagesize)
+{
+	return __builtin_ctzll(size / pagesize);
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
-- 
2.47.3


