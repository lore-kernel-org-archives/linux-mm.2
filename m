Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC08D5E370
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2336B0093; Tue, 16 Dec 2025 09:26:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567816B0095; Tue, 16 Dec 2025 09:26:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4DD6B0096; Tue, 16 Dec 2025 09:26:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28EFF6B0093
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:26:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFE051404D1
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:51 +0000 (UTC)
X-FDA: 84225560622.28.94181E1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4B93440011
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765895210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IzQzioPvaa3nEzGuI1XlV2tJJu5xBH9dbC7cJQfrNd8=;
	b=KP8tm7dSHqCQ2RQa/1Zh+D3hbnZfsT/EUSb6Th/pzI7dIh9WqpQRLlQRjE9xouh5knKeB6
	cQ3fTKO+AbRjePwFTDzTTZA6HmilBhPTzDVT/rxqoxAZSdbsfwut6SnWMdsKv3htlpdDhl
	hbXQBUMJGTtZdB1GM8XbcZnV9euSLpI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765895210; a=rsa-sha256;
	cv=none;
	b=7EJx1RMwmz995IrUylsMjblNUb8HNCye0J0UOEsHl9/xnmorRn/gPSCBmXOjtYDSn5HVV3
	tKDtuzaTNiq0X+n7Ieq1r8BbEnDU+5GhvyYO3QMOO3uZhDMxoeExCI1kgLFuI+qRxct5QB
	1VEGK+BfRWyFsBWPxMaG0j6NEslOK3A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CB851682;
	Tue, 16 Dec 2025 06:26:42 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD66A3F694;
	Tue, 16 Dec 2025 06:26:47 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>
Subject: [PATCH 4/4] selftests/mm: fix exit code in pagemap_ioctl
Date: Tue, 16 Dec 2025 14:26:33 +0000
Message-ID: <20251216142633.2401447-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216142633.2401447-1-kevin.brodsky@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B93440011
X-Stat-Signature: uibyputix49xisky8e588ojk78jn4a8u
X-HE-Tag: 1765895210-204185
X-HE-Meta: U2FsdGVkX19pigZ+IzmLoo4G6gc/+7i6iRrS5XNkgsh+PRs83vQcI4PjFNVYY/q28GCJR0dLc7NKVqOVnOvXsgObeNU7b1BR4hrfr+7Zq4/AxdolfeE9OhrbH9q4pfMWH3zCuRaFGc2T1OKumt1VYaTI4DLUlQIcLOw116dS+I1otTaVfcIqpyHiENZ0wyOZeFEQpW6HDIamibOF06ZOEgI6TFWIHkPdXd4MGm7C60zBY4KmIs7Dd0WU3CJUXprlpDyXp1+r8q5qfL/RLGVp79ndkayBpMgOAR58Fl9EzU8T0avvJDGDHgpUxpjPdro8rdqo+v47pKPFM+RgwxSU0wrP9nWcbLgh9F4+Awik1OgnSfi9RxJXvIx0RRn5jnObLK/JjK8YD+x8mYjB9k5iVKuh05HZkeGHek7gn5BlbUoLI1X+7r4vXkUbqzp3XWYwvKj4rrZkAXmvxH6B2V8FFKjLXh8Gqf1cFJ6Lu5KMwy8yLTPg8U0y1cUbYxsk2OGGsgr89a8yTCBVy54jWiJwOYH/ahfsdEPyw9oJZrluC9P5p0qaNQR4cO1586OK+9saA5uq7lIvkI5nkJD5NUHopHKaPijxJMdS30hMBP1Y9h1LJLNPosQlT/oqy1x32O2jLK1cJMLPxghT1ewg/OlcYdoQxzvgtkwyQA8RGO0uLJDuIr5PqTrFUW+nf0gOgAYM+xrQoaOPreiq8VxZkrwtguxV7jMrYlFXmPu0KFJpRjpBo9awv2kcpPBOMIND3ix3mCy5ID29B+H4Ddz9UbB1nBg7J3w4hhmjINnO8IsVvV3WNNXQ6XaEmZgGa+tfsvZYRE/u6cOXsqX27fx2iIFv8EoKKUJXTg0DQg4WLuLolFZuBpO61JOmZCfQlbupK7ik4lfBDwMfuoTYJrrvhevlEmKn2H+Ilf9zn3UyRvf1p2Q8/bpNJYtSL/sKzADyGatjuXcaC0oWL+KD+idDsuR
 hKyRFDPC
 hUWrR98mdxsB+b/XRR8v+aVo5cluARRLNZqmxt9k8y6DDStOlKEqWKC0sAs9Xk/VO55xYYkIbkThvGG6eTwaZdS9/BZvyGFWofNMCKDmo0DdumlPhCJ+r5s32Nb0lVYtdZJX48CWrztsLr/CdZZgBO1IDrUYkL4W1p3Hx8V7pimxuZsEdlswZgwDdQbx5TEldMq7M+c1hAgaksoU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pagemap_ioctl always reports success, whether the tests succeeded or
not. Call ksft_finished() to report the right status.

While at it also fix the exit code in unexpected situations:

- Report SKIP if userfaultfd isn't available (in line with other
  tests)

- Report FAIL if we failed to open /proc/self/pagemap (returning
  -EINVAL from main() is meaningless)

Cc: Usama Anjum <Usama.Anjum@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 67a7a3705604..aeedb96dfffb 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1553,7 +1553,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	ksft_print_header();
 
 	if (init_uffd())
-		ksft_exit_pass();
+		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
 	ksft_set_plan(117);
 
@@ -1562,7 +1562,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
-		return -EINVAL;
+		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
 
 	/* 1. Sanity testing */
 	sanity_tests_sd();
@@ -1734,5 +1734,5 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	zeropfn_tests();
 
 	close(pagemap_fd);
-	ksft_exit_pass();
+	ksft_finished();
 }
-- 
2.51.2


