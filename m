Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37753FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F1D16B00B6; Tue, 28 Apr 2026 16:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2516B00B8; Tue, 28 Apr 2026 16:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892806B00B9; Tue, 28 Apr 2026 16:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 750E16B00B6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:44:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 360C540459
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:52 +0000 (UTC)
X-FDA: 84709143624.15.D1143CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A1ED814000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EXmOL9ou;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aiz8kFxk57IkiOLNs06U09HzE5p8eI8cvZK0n+lLXTw=;
	b=Gac2W7i9QLKkYXnZD2IKrGMshruU81KotcG2IIP0OELjnu8PCAX8+OMfb96b6yHzoZ0WLT
	O2hQ99BGgxm2OBJV+hTgY4VjxuVI488wgZfJ6oKtenyXFUpvDcbiUwalrZJb+AMpV9epVb
	EpDTuqNk46cCDzrwdoMQ6maQE6Et0GY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EXmOL9ou;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409090; a=rsa-sha256;
	cv=none;
	b=NdS0E0XhNm8A7Dm3uOql3k5JaDibFu+zjek+QRdLJpJ3oKEnsnW39wD2UzlnLAb3yK0y9z
	Ogg/NqiVuMIKiCcq+JHVH7Sgw6ndX2/xE7E3x9xVANm5VRmPlJzIiO27eVMSV7cFK1G8mh
	TK9sIkPjM5/BXfMfJwlKh/wVneLZz/4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18E0D6132E;
	Tue, 28 Apr 2026 20:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EFBC2BCB3;
	Tue, 28 Apr 2026 20:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409089;
	bh=7qKHzCadzgEQAQzNVqCf6fre80BxdReFv76mDf7/IKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXmOL9ou5pb28Qr8PTiAefwZfwy88snUIzJS8rYsQHY0Zl+Z0b3Jh5GOP8TO2lVSV
	 pEvW97yjRJoPizvGmLDImbmW4ewcXa8F33xnWt7pyp5cuXmKanuTgK9L/Wd+5jq5Ju
	 TiA4/T9qHWfLhPNQCjNb0gNwENQ1ftUsC91Ky9NonciIwfyoHgSjQbcWvTjmqVRgZJ
	 k6FYkUKxvk0QQUUzA1yQmggAkvy3ty2U1sVv9Q2p0CT2BuyQzwr91/41QjC3lbMnXA
	 Lnxv5JQhLdeXJZk7DABLvQ1y0vpjuXSWAK/NAE7w+sa9D5FRdGm8XmCY5u9MCRE9iH
	 U6NlWwOIJ4PEA==
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
Subject: [PATCH v3 18/54] selftests/mm: uffd-stress: use kselftest framework
Date: Tue, 28 Apr 2026 23:42:04 +0300
Message-ID: <20260428204240.1924129-19-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p4wwzfqdsiiaw1nmoxme8gug9mjqrgam
X-Rspamd-Queue-Id: A1ED814000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777409090-597656
X-HE-Meta: U2FsdGVkX19A1zKQq2ddgDlKhY8GMF/FygO/88KmU6AlbWm1zDlpbkf++rQXsYMd7NCAdffJ7Q0RpfnwPzqq+5UvHtw92O5c4OrbKfWDodySF2AivF67iKVKHh2gHFvOYjrpaVt0jzqub3Tc2Z4k6079h2mHNnxvAeY0FDs87DjAR09EnEvXTdCTRJEr4C1S41pWQD9tyKjQ6Ww9ifi0+5Ko8uKBfbdra1y2VMkcDa60Az//fm/VH/yrz2OYZOSpIRy+INqyLb4VXpcx1WMSHlxgpWMYdIahvCTPk0I20Qaq3VNnZqGMlvg5UhVm9lbZWrXwP7B9cJUyFQi/YYPx0dci5b1VPKG4yXzSEP0SowomJYzLaYJqAkCxb3QCLuUvQT+9b2Sxc8GGSiGkAOxy4pG8RfS7QdHWsRRLD/63+o+sgnq03FFaDuAy1HXRSWViaHzWX3ngzn6KZCUxGYCE/mJ6TqbROPH6tH3lNf1U5QMFc0Hwb03LcbUqrzlC5VzgAhfrNcw7BVnLS1xv4sYvCKjinEhxu57MZH/jrOp4tuQbiMH6HbDMXnxAv70adygkfungQYA9evGSYUbPaBitlQ9iJj2Y47XeVJ3WuZYmetFVz4k9jkUv7b0ilpBHkbxAB2WEbmXclHPLx3lArr5sRc3OwamzJOUt2n2mtiH8brBtw9e/4MAwlraSp+kgrCebVK0FNbLWZf3o01FvjxYpq7SN0KHYzFDY1LKrvFswNn4Q2+oaAIsRsjIl6zGyb+diBeOUAgrPV7GCLg/Rv2rJ6KMDhujV9YJYgivWv+V/kHwdcT4OjMwU0wr9nXeRCGIpWLjZZ/MpNYgJB7eMy9ACtaltZuaO0akN/o4XRFa7uIHQVtighoz1qCS3T40uQPLZwvE8/nZ/zZSS1pW2pEcTarM5YROjwXZ1KN6+mKVqlt0vHvwemkOeeNfgnCiw0AYW5RkthrXeA6JcFoOWWbf
 j9a3Fzwq
 5Z02z6TR2adYgRvVIRhLOLmBAOccSGLcPOSUGcNfr5s3JZGHMLwy9obJT32LzqAirTuk81muQ+3HCpV5EBB7J0l6ccBeUF/9AA/ZEcyhGCAWu1pvRpmWPlZkQQzGlzEVK2tSKOW/NHW041aavJTIiUOH+c0qM1zxxqqHhR8BwsBLrOGsRhZd/1iNEw/WKDwj3Iejx/kHkFOXbgMZ2aNB3UV+eQfHeTKkAVXfKIt18Glll/QdKUCnTbDcxXrUpoiBIltmaHymCXzRprRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert uffd-stress test to use kselftest framework for reporting and
tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-stress.c | 41 +++++++++++-------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 700fbaa18d44..e92a85463eb1 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -286,19 +286,12 @@ static int userfaultfd_stress(uffd_global_test_opts_t *gopts)
 	pthread_attr_setstacksize(&attr, 16*1024*1024);
 
 	while (bounces--) {
-		printf("bounces: %d, mode:", bounces);
-		if (bounces & BOUNCE_RANDOM)
-			printf(" rnd");
-		if (bounces & BOUNCE_RACINGFAULTS)
-			printf(" racing");
-		if (bounces & BOUNCE_VERIFY)
-			printf(" ver");
-		if (bounces & BOUNCE_POLL)
-			printf(" poll");
-		else
-			printf(" read");
-		printf(", ");
-		fflush(stdout);
+		ksft_print_msg("bounces: %d, mode:%s%s%s%s, ",
+			       bounces,
+			       bounces & BOUNCE_RANDOM ? " rnd" : "",
+			       bounces & BOUNCE_RACINGFAULTS ? " racing" : "",
+			       bounces & BOUNCE_VERIFY ? " ver" : "",
+			       bounces & BOUNCE_POLL ? " poll" : " read");
 
 		if (bounces & BOUNCE_POLL)
 			fcntl(gopts->uffd, F_SETFL, gopts->uffd_flags | O_NONBLOCK);
@@ -456,6 +449,9 @@ int main(int argc, char **argv)
 	unsigned long nr_cpus;
 	size_t bytes;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	gopts = (uffd_global_test_opts_t *) malloc(sizeof(uffd_global_test_opts_t));
 
 	if (argc < 4)
@@ -484,10 +480,8 @@ int main(int argc, char **argv)
 	 * for racy extra reservation of hugepages.
 	 */
 	if (gopts->test_type == TEST_HUGETLB &&
-	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1) {
-		printf("skip: Skipping userfaultfd... not enough hugepages\n");
-		return KSFT_SKIP;
-	}
+	   get_free_hugepages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
+		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
@@ -503,9 +497,12 @@ int main(int argc, char **argv)
 	}
 	gopts->nr_pages = gopts->nr_pages_per_cpu * gopts->nr_parallel;
 
-	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
-	       gopts->nr_pages, gopts->nr_pages_per_cpu);
-	return userfaultfd_stress(gopts);
+	ksft_print_msg("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
+		       gopts->nr_pages, gopts->nr_pages_per_cpu);
+
+	ksft_test_result(!userfaultfd_stress(gopts),
+			 "uffd-stress %s\n", argv[1]);
+	ksft_finished();
 }
 
 #else /* __NR_userfaultfd */
@@ -514,8 +511,8 @@ int main(int argc, char **argv)
 
 int main(void)
 {
-	printf("skip: Skipping userfaultfd test (missing __NR_userfaultfd)\n");
-	return KSFT_SKIP;
+	ksft_print_header();
+	ksft_exit_skip("missing __NR_userfaultfd definition\n");
 }
 
 #endif /* __NR_userfaultfd */
-- 
2.53.0


