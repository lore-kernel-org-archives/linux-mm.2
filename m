Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C04AACD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3117D6B00F6; Mon, 11 May 2026 12:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9316B00F9; Mon, 11 May 2026 12:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226A66B00FA; Mon, 11 May 2026 12:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEC56B00F6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF3251601F4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:56 +0000 (UTC)
X-FDA: 84755678112.24.ABC967E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3C7D820012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NU9JP2JG;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXlaSYBs06S58Ps/hp/UnVy3Cn6syoMdXcgK3K6Stj0=;
	b=O85hK18DAKPmvAexOMk+JPgN3SM9YTkxQn7alSmHvqQ4r4IUwd9YiK8PA7IVjYgfcqHm2Y
	7U4C76zBcgeQMgAB/vIO7iHFtiFwABEsWWb87eerIp1gFQ3GM0d2tAKHYuaALqaIN5iXlh
	HllTJdPD8p0JiO5XspuMSX58gXfWZBQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NU9JP2JG;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517055; a=rsa-sha256;
	cv=none;
	b=U7pwEntY5t613rqZVw4K2lux2Tt6Go0W24FXQfKEm8WanLEHhnYv3hsCtSlseGlVptmMcq
	2/xCj37II0+Mkt5O4U8FdqbYd9gDPENsYtxmKdZ9NpabtAegCIixP9jzmpdhgA4wjWBvpa
	VIE743F3yfeS9SPwx7XbuGMrsCZgMKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AC878600CB;
	Mon, 11 May 2026 16:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ADEC2BCB0;
	Mon, 11 May 2026 16:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517054;
	bh=4CvakidC4k3PlHx7PmzyhHnywybONIxudHvw8PNsZ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NU9JP2JGlKdbkF1govg9E7TLsQjSR5kMC6HLa5ggp6nmcki1dBrodS+sKXCxaPTVB
	 SHFBZ+oh/fpxHBNks6a7LIBmSkJ6QSsW7nNv5QXwuSyJsnwbBZ9RkGHslDykycu3U9
	 DcKycPA9eX1qwsKo8gVAI3J6VpMcwMxC+F0To9rCGdmafFO0qon/YT3psLmuHVZE3j
	 wfQBeYuKpF1Wuzvg6nqBIOIV2RCwkTw3uFnaR+qTta7efvhffa4pyU+lH3KotaE+qx
	 +xoGvueKHl+kCfQYuaxJfo2A0I4+Y/gcYqjOJZycIPT5skLl5/B7JVKHGJQWunKGEU
	 y17O9oVDetZyw==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 19/55] selftests/mm: uffd-stress: use kselftest framework
Date: Mon, 11 May 2026 19:28:03 +0300
Message-ID: <20260511162840.375890-20-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xhkcq6d7gimj54c4hfs1zphzx4fur5nx
X-Rspamd-Queue-Id: 3C7D820012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778517055-156427
X-HE-Meta: U2FsdGVkX18AXukMtqzVY6VuzsYbnskbamPZm6LvX5AwF6l2X7ZM9PKF3Jgn+XKN5lhkipvXaKjYFrmTRck3rTVtX4x5KujtdpSXqCpIj+uYyj9dHOsFaup9hFNikLAUjada6sG62raCGaeUSEq0tV/pbYgjU3WwgVIYIZ4Kc4P2FrBfFzkDq/T6UjvCmqQd+wxGFQ7SGbcjRQ8jCWi2hHBfXbpQU/Ipl/DCw9DFdX7CyZr5uyCWLap8Xrx0xt0WYpEiG/EgBW3CcI2B9hl4mRFlLqGu6GJK4cIHb8f/Xcs/JHbFZ44W7V2U0v9jpa5YJGT9WVtBdZ0PH6To4CXoiutrp7r0BoarvBc7l/tcb1qTQ1P1vXWKKJYNZJUuBMLdpnILnoWb9bPAuDPSeMW9n80kDzClNUY3oWFw3ZEIJ+e35vmdlnk/a79T58syMco+/TvAm9IBHbrsJkcXmciXOkjmgQphybQOqhK4SYr5Jud+U+qiSepQgYQujz+zQk7xOL74xsFM06M8kNgzGEMIbAD8uX8Hw/SJ49hU9kbxzy1EJg3+ihVxXNvF5hlzZkwih748G2RHXcCU2mj1YigffHwDQZc3byZrmlYoZmppNTDE/7GEEpcHKsLka1FhtNQnPJtrfByGl+EJLS2dmKvIv7TDIElamKEKqYJMuQcw7z0ioHYdOCUYY9m/CvVCLaSeDOy6UKKRG15FophCyoY4cmgwQLx5z7vfN+NvK0/8HoFr6icpRJq/a2sNyXkDHA2QiC7qImvIYdSh7q0O2npAF6Z68vWeukjxLIkY36SKRb3gQ6dfFEaIz1TVdDl4UpMTRkUYGbzYjfxKpADQ1DKbeBOqKfQM+e3bvTdJ9n2boiJsHgrMsIqtRKT44MAHE5TmILwnHz52brmGPghEIjh+QJJnG5w3JZ6Jhq6Cg3djhyZyU7pU5CTZQMvh+VYzqfcncI7vYpKfEZ3G0csT0WE
 Wz8qb6AW
 lc9SIOZ46cxpvHKvi2Quow6+OA6FhHnFUATIKPK3DlMJsTCNVVHR/UG2nmCTaE8wXhVz/+RNoEHeGRIu81P04ZIIUbkBhF0wJYtsmdMZNVuLyixi73Qohe0Vxe2lPnOT5YHhlZNKL4g5NY/6e2X/UU4vV5c9vH75oFwW1s8Njk1wJfsQLX6CDW0DYGhotZlbsNJ/0XAEftoFjgwl0ZmINFUqdtaCAsV30V7/WTLW+QZhcMZ/PyJ6gYBMnlf/VVh1i1qaLkbFOiDgW3gx2ua6SSjRYxblr3OVkXsOKmE6SVnxL5aYruvHO0XFX2P0JG+yXTAFX
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
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-stress.c | 40 +++++++++++-------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 700fbaa18d44..0ce493dac354 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -286,18 +286,12 @@ static int userfaultfd_stress(uffd_global_test_opts_t *gopts)
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
+		ksft_print_msg("bounces: %d, mode:%s%s%s%s, ",
+			       bounces,
+			       bounces & BOUNCE_RANDOM ? " rnd" : "",
+			       bounces & BOUNCE_RACINGFAULTS ? " racing" : "",
+			       bounces & BOUNCE_VERIFY ? " ver" : "",
+			       bounces & BOUNCE_POLL ? " poll" : " read");
 		fflush(stdout);
 
 		if (bounces & BOUNCE_POLL)
@@ -461,6 +455,9 @@ int main(int argc, char **argv)
 	if (argc < 4)
 		usage();
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	if (signal(SIGALRM, sigalrm) == SIG_ERR)
 		err("failed to arm SIGALRM");
 	alarm(ALARM_INTERVAL_SECS);
@@ -484,10 +481,8 @@ int main(int argc, char **argv)
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
@@ -503,9 +498,12 @@ int main(int argc, char **argv)
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
@@ -514,8 +512,8 @@ int main(int argc, char **argv)
 
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


