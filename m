Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1708606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 08:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JCheiaW7
Received: by kanga.kvack.org (Postfix)
	id 056756B05B2; Sun, 22 Nov 2026 03:20:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007F06B05B3; Sun, 22 Nov 2026 03:20:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87D66B05B4; Sun, 22 Nov 2026 03:20:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B14796B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:20:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B979A06B8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:20:29 +0000 (UTC)
X-FDA: 85462058178.01.6A87536
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id 73EA820002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:20:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JCheiaW7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3yaUCawsKCH4mcngujukpijiqqing.eqonkpwz-oomxcem.qti@flex--kaleshsingh.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3yaUCawsKCH4mcngujukpijiqqing.eqonkpwz-oomxcem.qti@flex--kaleshsingh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795335627;
	b=HH6UPs8Lk3KZhDIwY5z6P1HfoJ40Ncn2yq87nldGiRvnYJ8R5ynk1GF0rg/srdhf3T4Ds7
	N4yTy1R/cdUW27DdavDulrYyv8oe1wOM0KevD3nLM5K/ASTQqEmwKn0aQCFhIj+D3KcHfd
	FL3oHbi+ZfaQW9WZZaSLjvJnRqHOvow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795335627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LgGMW7nTxTISYX0jXbZvoZG+Dao4TWx626ci6dSPaQ=;
	b=3e469bVVo7B5qIfxpj7OZL8+KJzRYpVPkd58RzkbFLfva97bKU7jBmkENiZM1fKddJLSny
	y46tZ5fSauvocOcPl9ZRGnnuRf/346nXbucuBUiFyevaavndlIW0bsO7eIbmI/o+zUIyYR
	UbaNX5OOu88jlEHKV8ThlEj3FCTlYG0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JCheiaW7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3yaUCawsKCH4mcngujukpijiqqing.eqonkpwz-oomxcem.qti@flex--kaleshsingh.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3yaUCawsKCH4mcngujukpijiqqing.eqonkpwz-oomxcem.qti@flex--kaleshsingh.bounces.google.com
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1af203073e0so2561434c88.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795335626; x=1795940426; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+LgGMW7nTxTISYX0jXbZvoZG+Dao4TWx626ci6dSPaQ=;
        b=JCheiaW76yls9fuf9x/fW+T0182qUItwGrWxnoi+yRU29SNrfo+xVeSqC0zYcxtt9j
         xss1CSVgor/k0D0uwagsPfKwqmRJAltz/wvzrCQpejfa4U7GWuorkRnTWvq2MIZZ8hJ6
         VT97LPd9G7ej65n2fnbvw+CpZrxWtQe2iEnGjtgiGPANfWomxK2fH9goJ6u3HdyfE6e5
         IFvq3C55quoe1+8pUlCw8n46T4FarF6H5VkS1AlYFVRh0HxitvWg4eWl33ZXSBe/34or
         FguYSJo8v66GlaoPEuJPDLv7GGFy0EAf4liuHyyWRbmf7ojAjTWAzxeoohr5NBdt+xph
         qiXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795335626; x=1795940426;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+LgGMW7nTxTISYX0jXbZvoZG+Dao4TWx626ci6dSPaQ=;
        b=UqphSILaggYpYSFJ4+T9xtpcz9DsYIW8SYiE5tlCj5jTUPtU3apXrb1qhQ2WGHYISU
         za/e7oFGLlu7R9j9Cr4vG1skGBf85PDQWrGQAbOv7k61QanIjmd9stukTA+SHuCMqNLz
         AQCpHZA6Gy+GkP2Ao7Zx71bM1s6I0DXhJaAt5unfxvPlc0ilHGCWaZD/qsnNKQELDIOZ
         8Taev18VOJ+5S36HkMPLBGemBBZOgRqpngf453G/pRz4aMA0XlFwCL6K+a722YH4jjvj
         O9M2+JOPrBTcb6rce2kiWkohBcskPlYy7YMg0mREffpgTV/56k56U71dCunmIOq/L+c+
         /FNA==
X-Forwarded-Encrypted: i=1; AL+hErFYeATG175R9QYAL8qGE6ATRF+Bfr2xtnUFljFSsRA/rY/ENJ5ab+ZmjaE9B7hpAHbAaRHxyjFP4Q==@kvack.org
X-Gm-Message-State: APuU4Z8mUbi9rVLAOsDiPcJyC2y+TGDYcU4LS4dTo9I7r/sluU/AYCi2
	n/p5A6lYH/BUG5/Q0WtmNqu6rjdy6q6Psc+LehY1nnk2y89n59buV+inT0Q+ndwYE7NulVcCqTx
	LJRX8wuJACb0pH5cH2KTEP7I3jw==
X-Received: from dlaj4.prod.google.com ([2002:a05:701b:2804:b0:1a1:3ce6:560b])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:3f01:b0:160:90a3:ca8c with SMTP id a92af1059eb24-1b55689f73amr8620553c88.7.1795335625670;
 Sun, 22 Nov 2026 00:20:25 -0800 (PST)
Date: Sun, 22 Nov 2026 08:20:17 +0000
In-Reply-To: <20261122082020.1255434-1-kaleshsingh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122082020.1255434-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261122082020.1255434-2-kaleshsingh@google.com>
Subject: [PATCH 1/2] selftests/mm: uffd-wp-mremap: skip unsupported shmem and
 hugetlb cases
From: kaleshsingh@google.com
To: akpm@linux-foundation.org
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 73EA820002
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dfm41m7iymes7nafd9zxmgtbgqhjduc7
X-HE-Tag: 1795335627-783649
X-HE-Meta: U2FsdGVkX188ljY3f3ML9XkfQXqwRCPEeunhblvFNi1PJ8aDwx99On9VXlrHekeEmr6gn7Fkm4AKbmxAb3fjL7mag6cIwVjGOwCs2JeKtDZ7AzmnD6gDUIWhDbj6zZsc8Xej2YHGg0GTurTccpC/Kb/u3Tha1GhNu5iQnZX+QOFG6BMFNDoRq5umMu2pcXec5enzlFyvcRu+Wr4DqzjeCRQ9bnBvt4UL+tOOa3WzmuXSJB6M0/+YrhaseGuLthhXCEaOzHJhNK/imf6SIZmtRtFhPfTn2TwRIA6tBm6QXaVyc1F7EsiUGyaB06ign5Upe9izWw6h8JuyK1qhExE9LsQd2qTdRVEARnfXJwIfOSVrZgyWA1KtcoNkpKe6uE4cJysP5NMYlP8lq85m56pfdJo7TQqMFiA+RkoGIZTAmfxLJsB1wJT0K+a3JKk2FR+IxQDijvZEoSSIH3QsfhXJpfCZx1Whx4V04tglIjEpI3p+Sgg6XRmPGnCyN0ED0z/Vmxkm5qEIOtP3gOBuT2j1qzakvHh0s+jyzY8k2y332rpARjtaYLQ+P2ail0YovzKbwKOv/hxX5rw9ssC/178W/6OYGr5cuvhAJH/+McFYR6AY0pl0s4ilURlq+//T+pGag+4Ar/UF9eYR7GfILYVlN6C8xLW8kH0iEireljERMDjUTPr5qqFbwWrUaoGeMB1DNW9i+OzExHhetSjnZUMfrXnzhFz1EUvvG5FF2vgOlS4EXfHXaV6Yqms2c+PSmeqxiGoPKCrzBrQIvlKXDbBa2nrFDcy7ybV66+NrFJXVQuTwz1kQw8LN9lX1C+AlPqsSMfCc9uarA2IwB6AxqQnZncYSrUqvM9ZAlT5Lu5vsem3k9pul/Xhnl5huL5D3BoL500ApbEsJLd9x3KAE5v26Zs+b6Ot9g9vJjW8GxYNcMTiv3BJhJKE72mQTQcaTtRaTX3Csq+dkgI8s+M7XAfl
 It1Z4q28
 6DKjuFkxEAdUL+5Ye73R5LExgSQfDV8oBISD+xdSg2duiUbkTXTKO2slx5UhN+vzd/M0YFCJPRsQ4kEmUpEO4I9ftMPGXzeM2Ls5anL67gjyfqKTzVRUA0UNtMqNqaZRApd77Pg/zYzwQhXuJBZgXqzDG58S/SwXz/b62RKKbq1dHhFHlstul/VdBMpWDxVea7r1Rt81NSptslnFdbQZB7AlgqAHcSiYptX2uVsG8PnD4mCA1blTteeADj44kuv8iZpatm+jVk2WjOJXpEKA8yscaPosSlpJyDymYzqSM0ODqVg1tcL7fX4VA2IQjW9Uo2nwjRNDVkHyCxXhjkhq6CnxiUo6aQIleacouyOR9DWmeEEW0UQdh4pVwFH1jL32S6tf2P/6K+HiMECTo94nWBGYmbLMI0WgewocMV6zwW81P7ehtDnWUgyK2u7UfZSdlZuQk/C9IuYednUuhsCvmdwjx59emxSjL551rTYofusa7PO19KkoiEhrZ4RpvrTSzLG6SmdHG/1xGv7qO3b3q8I0hUsva9GzHWyl/283K81jcWyPracGNA1WFv90JPBXBlz7Th/dEDVx6ajbaezqWpHE3gdcsNMCwYk33klqBdT4847WwhKbW1FzQrrrOrlYtAh+afuCYFZYTP/EOQiZrlP5k3Cu0mfWvbavwlqmoeQAoTplTcl5Mi+SIqrma601EjLL490IR+jDCPxO1VdrIFLt33RRvoZMa8icLJXq0yYIw7eGt5ek+ZBN+GnjnC09P1xOhS/3Q79p6s7eoPMq0TVEEqiAEDNBwyLoZyWQgFgmSmFp3pYAYvFhXh4vRDCUEy/gmV9JmTk6AbbOm2gFrxBcVxyLpdmCjcz0PIRqIOdazzLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kalesh Singh <kaleshsingh@google.com>

uffd-wp-mremap checks only for UFFD_FEATURE_PAGEFAULT_FLAG_WP before it
runs. With CONFIG_PTE_MARKER_UFFD_WP=n the kernel keeps that feature
but supports write protection on anonymous memory only, so the shmem
and hugetlb cases fail with EINVAL from UFFDIO_REGISTER instead of
skipping. Skip them when UFFD_FEATURE_WP_HUGETLBFS_SHMEM is missing.

Fixes: b2466bb3b495 ("selftests/mm: introduce uffd-wp-mremap regression test")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index c48eaab8e75c..f7b272baa6f5 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -18,15 +18,14 @@ static int nr_thpsizes;
 static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static unsigned long hugetlbsizes[10];
+static uint64_t uffd_features;
 
 static void check_uffd_wp_feature_supported(void)
 {
-	uint64_t features = 0;
-
-	if (uffd_get_features(&features))
+	if (uffd_get_features(&uffd_features))
 		ksft_exit_skip("failed to get available features (%d)\n", errno);
 
-	if (!(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
+	if (!(uffd_features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
 		ksft_exit_skip("uffd-wp feature not supported\n");
 }
 
@@ -180,6 +179,12 @@ static void test_one_folio(uffd_global_test_opts_t *gopts, size_t size, bool pri
 				swapout ? "true" : "false",
 				hugetlb ? "true" : "false");
 
+	if ((!private || hugetlb) &&
+	    !(uffd_features & UFFD_FEATURE_WP_HUGETLBFS_SHMEM)) {
+		ksft_test_result_skip("uffd-wp on shmem and hugetlbfs is not supported\n");
+		return;
+	}
+
 	/* Allocate a folio of required size and type. */
 	mem = alloc_one_folio(size, private, hugetlb);
 	if (!mem) {
-- 
2.56.1.750.gf70dc682cf-goog


