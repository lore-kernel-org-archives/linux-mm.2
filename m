Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0EDFF99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6716B0250; Sat, 18 Apr 2026 06:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1767C6B0252; Sat, 18 Apr 2026 06:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066186B0253; Sat, 18 Apr 2026 06:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E68906B0250
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9F80140488
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:35 +0000 (UTC)
X-FDA: 84671375670.14.0F1A630
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16082140006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y0ScbXni;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Wyah5uEA/szF0vhExaGCaoEg301nCZo17UPal1ZOqg=;
	b=315bcZ5kSQmgHb+ZIjNVkHDF12ifPNNvRX3cKMEdNNojjAuKAd9Yy151HxSVjpz7D5Ai4z
	f6TsitAhdNfqjkDKMZQaPTUdHkzwG7LiHKGiMJu+BvfGFJdGAo7zwULs0XpefoDSlmXwft
	kQTXTk57AjKjdmmbtEeS6nibiX/epB0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y0ScbXni;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509854; a=rsa-sha256;
	cv=none;
	b=688VH48xzZ62sMcNg6Zbrjxbnq8mP41rTmZRkfdzWDJqz/yoGLtj3rbUguL0rGpoDXqnFs
	jr2Ck4DXl2ArtSHDFbJhqjqSzka76v6CUxp7RMfJWOrF8Yi/v7wt/1XEM86FW8enS83QVq
	fcMjJ2M6AciV8pZE6TXa1qd21YUZ0Wc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CFCA40E2A;
	Sat, 18 Apr 2026 10:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7594BC19424;
	Sat, 18 Apr 2026 10:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509853;
	bh=W/Hu2qsaXpGRyFf0ATC603oNW1zzsqQgst2Eeo+Nd7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0ScbXniyzsFNYebjVotCaILdgbqhAIGBzp2R8i3jCLxPnDtOGD21cCfA9tBWs0GR
	 +jIRXy/Qdfxxc1K9bUCKDr6Qgxf7gDOUwc6xMe7HDr7sTPCm2e3Xoax3Dm9+dfO7Ve
	 hq9UyfQQiRBT8KfQY7CxdcAzVi9g4NfUqFPceACf7+9slxElQgo1vfQS5YG6jpOt54
	 3/YjL80/kSxq/JR9UQJT5O2fstFBK8rXrQz+kolQ/4WxUX4czwr+Dx+lYBhzMXTH85
	 sK41rg9yavX3dEb0lrTFHntVriZBvO2vej7DA93Fia6wJSvO66To4zvR7h+mUGUNCK
	 vmxhDQfbJwCyw==
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
Subject: [PATCH v2 17/53] selftests/mm: uffd-stress: use kselftest framework
Date: Sat, 18 Apr 2026 13:55:02 +0300
Message-ID: <20260418105539.1261536-18-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z7bu4frwn3z1937xiijwpybrfdcmzk4q
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 16082140006
X-HE-Tag: 1776509853-130915
X-HE-Meta: U2FsdGVkX1+u465RtNcNZ8p3ZwkYP+pRfmILg+bY1uP+hqFm10JUnHBT5Lz/kOkW8tPqFEs8qgDXd6kbXFUsh1Sh4GoHL4cWg7RwgXCawG4RKm81vIohW3jHutzcO14KFLw53fAECosAupEfHqVOA9dgR9/+wh+iChojV8F4sIEsbUhla2OLmf8ypEH4GEzvb3U1w5UAbkmuvvEA+ktg+bh/ky1vPeb1rqrSGFYtlYlSZ/DIKcWhnmMSbDRvgEAKKH3TZbuT81GViQvMmkjrNc2+sQzmLMpqmP2Er3uA2M8tUE3PZCekPt6wE8Lqak18FgJyqPTGpf3acuBvirAPRWYe3pXnB+3vVudGzJ7TZJArZ0SAEXJ2TbBEejS8xCvyu9hNr2nJFSIuN5GppVF5juzpWlIHZQGqirw09quYAvZ8PcpQxs/7ztNgsj/4lm/OUcmvXjlShBFVveueD9P0XbtKW7hX1ZEU6CHayvepix/nX278CRXq+kmDz20vblfnD6nEeVc7ZJ4XNUA/hC6LoSIDXOexD5k93xKpHcixjp+07RYsHJx1PuO80XtFT5J/rEyxjW9WU8GyN9A9mH+d6QtX734XJkO4F6XzBgiYuafQ1vhaKBD8P8xn6vNtn+a5PJ0Jnp8s6aMA5oWmC3Jx+IV4bHjCwD9geD4MqajC7Hmg7Cq4Nh3HP/vHl3NqTwEBfFQmMvBw1EbQaX5G6xq6TSBL7lADUUO6+nsE/uE5bqQEPx4EAD3JLvsY9d6EhedhS4Be8wUHgMmwbneY+Q6zE37yqpYUy0+OWCNRhf+pt0+76Exl3FYOmFdUrCKW92G3Gh35aOxqU1XpvYmJ0/sDkWUtH543GfHy3rVVPCcCZcXaeJYA8Me2ndyljY+04lGh8D9Vq/MaP6eXVYlGHuD0/hDmvCthDf3vaFxYKs8YOYiYiUq1TVavYc/IHD/elGzquwHsYG8ohXfbTrSinpy
 nnpOSCum
 rw4BFg8/aG3ZKD4eA34UK1VRLmytpjOPp/uKi19dc57CkSwqbFX+bxYWHgOwJt/N4RSBA52RROBfhy8+M2VHS1p+6Bg8023A+lrBeRfDIKf3O0PyQecUOD+O0upPrpdwk0krj3/e3F+rp2ljxGBEO0s0gYAn6HRdWJwFfOhQK/Nn3q5AUOtMSOaIB5VVTpwlsmPbqw5lA7s+FqPTmxSARYWLJPJ6QZhD+DY89Cw0QvDb7Oy3jgq6OPbQVpK0V9UobBVQA02sViwf/bQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert uffd-stress test to use kselftest framework for reporting and
tracking successful and failing runs.

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


