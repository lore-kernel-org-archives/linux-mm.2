Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C2D8F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54AA6B00B5; Mon,  6 Apr 2026 10:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C826B00B7; Mon,  6 Apr 2026 10:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B428A6B00B8; Mon,  6 Apr 2026 10:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2AB86B00B5
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:19:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F3911A047A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:27 +0000 (UTC)
X-FDA: 84628338774.08.CC1ED84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D58D0100009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5tD0iSF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Wyah5uEA/szF0vhExaGCaoEg301nCZo17UPal1ZOqg=;
	b=aH2nCt4zCMyg8vbRcXfx8cGE0gJ34RL0qs49wp/45SDHMFscVTofiR49WFTU5Yvt8nSQBh
	hunkjDLwELV/IYcZIsYMSnQn5T+X4eTswnhs8c+PAd+WVcj8olM99Gfb7XcJ0H7YQr45hG
	RgXnrOdHHYJebBeq4L+15dx1F+4pEQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485165; a=rsa-sha256;
	cv=none;
	b=GuC3Q7bh0QWLrNtjcNsKqym68avMPMdXiqrBqTRzuncmiBVeoLJDLN32ek5KXvUfgrBS2Y
	r8lJRXYcb7S35A96Yzy7MdXmOcoThJPZ2ScB6X9nLJnFhi71uC6PlvnjosvfUjFjzpfrfW
	g/aDGla0EVacGC3f09K1doxY0b6sRd0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5tD0iSF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A0FC60127;
	Mon,  6 Apr 2026 14:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C96C4CEF7;
	Mon,  6 Apr 2026 14:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485165;
	bh=W/Hu2qsaXpGRyFf0ATC603oNW1zzsqQgst2Eeo+Nd7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5tD0iSFDXXnqXPLFdQlAY8UO5/TgM1IESk1sYZBeQyG7MaXXD7xgXZkaU6yviBcY
	 FGXPHAR4JsWuqJ//tWGI0828HpRQBBig0Ltu7aEA3hpIe2K5/IXbQ7YKoWv0CQvyHD
	 daxe7pV20CZCIDJNn+5b/zk1sdtOd8H5RJpU9dPfYQXBQ9vqlKRAWcNsusgnmSCgbr
	 2+JKmGYn+/lNS/wkC2+BHtvu0i/2LpzieJV4cM51g4X8sRbC2CzgFCTitminOTI7+m
	 FdixntedHFrnSoIJCWQXO94jTxeTH74hb9k3DCCXK5IQlL1BqdlQ6f+cqKMXbVuNso
	 6Q/0nnCC3frSg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/53] selftests/mm: uffd-stress: use kselftest framework
Date: Mon,  6 Apr 2026 17:16:59 +0300
Message-ID: <20260406141735.2179309-18-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D58D0100009
X-Stat-Signature: p5mkehwg8qhb3i53ac8cth6pkg78zcqf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775485165-535553
X-HE-Meta: U2FsdGVkX18Ev5XccZObv8QCGm1ZZGsbdr8yKNZdJN81YvLJOelYZPsFAjQzIk4e43PI/epBLIAHTgDQcoJ+MKhhrwd//ePWv2YhZL3hKDcV3ngnhEdGCHm63R0qSz0mY2iiiUZf4jkMpHvTi9zdiBllIIQpKN9kcCJf6A+SOgHjyYI8sdAh09RV2Gz3+rsDTDvMn79HI7i6FT8gKde4iX5TON35DxGcwnmSFpw8fJy4MYi/gk+uuBzBWMStfd2rRLRhm7advG7bVusavCQzP8J+LMyUYyrOPqg3Twz26Unlk6o8xd8guKMHNGL/gT2bgL9CF6x/fCBoFeaLCSWJGUFl0jbPo8K40kxHTZPHtic6bVF4jj1V2LBk2vfVOM5s6RRcgdgaPVSt209jXNq7lo5ZQ2ROiAJu7YRpUTpWl+HudBji3lCM33XkY0pGEVMDjynI9dU6gi1YAic7vS/xXynZQZ1tDXlFxxIvQunahUQ9O0DajLF3ddK7oTTqQriwm1yeIM6W22wPoEniP9GhU18iTOpaz/ClDq7GAhQmCKcZt8d1wUVr4ezIPP/1IpfamKM7gpWm1RFRifcIJCLjBBmxFiH1DyObpHZAMBKTehYX5+JvvTxd7WvYN1cMvD5JHhyWokTKjItDM6JDtajw1n7kSkH0UpIEJJjEnU8jiPkkXr58G/4xi+URhWXu5nlBZhNJeWbopISj3WpaH/1l7BrPEwlOqMyf7cxAJFtbW9mUtUFJ00AkPHTN/e3Bjl4uDOqpnT5X7YyW+Y2MhAIWzsWhpOq2bbxolSE18Vk9AD2/EWohscj5MD1+DmbwzYaQVNRA3nlMN3ZxztZZzPyVzw5qVwYyfSn1Q3KYEr3LIGwp8zp3cUuc67W+SSsksA82dWJ3F31udYhVP90zo6iBzDUUXZ397szWv2a1+98ITE+DX2oQRuyxi1wFw4ucrHiiv+J8qAWqmDsZTATnYhe
 mH83hzmw
 cZrz75/cKSfF7qWZx/Lvq3nn8ITvxSAs68yq6FuD8Smv8RAC+AQ5MKMTxLUAk1v3EFC8qrKDWr4TXvl3LzbcATfNWFjTFusiDxNARvF7+XE1O/F8WtMTcv56tcvPTZTgL7fZho3eeAiQ5qRF0UZLO62T62GWBjSmWPWNUR7DV0Gj6juH7U+yDEDRaYX5ROrA0HEbsMyxm22d/0AaAhpVR8ItaS19OMUE2q/W69wDxG9NTOmKUqBdk/gSLcVIbToUOEGImHCwYdNbPIQk=
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


