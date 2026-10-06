Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B458CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70DA26B00AF; Tue,  6 Oct 2026 05:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E55A6B00B0; Tue,  6 Oct 2026 05:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB4E6B00B1; Tue,  6 Oct 2026 05:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 444356B00AF
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:25:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7C7612057B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:56 +0000 (UTC)
X-FDA: 85291669512.09.61D833D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2762040006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NqrPAzy5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278755;
	b=p/Db4S2Hmr+ysSiYOpt1lKkngLn24GYjOA5oz6Vdx2f/3uqdyEMu1FK1VhppTM/1IMvJ5p
	tmu+rlSW0lghSJ6NluCTKzCu77jC2g+BL8CV5/RK5rDhyS/It4xZxXKvcmpzWNrDrdoSoP
	hR90/4y/H/q5/YLhrCWBGYJQ8D0DD5o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NqrPAzy5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIB4fC/J/fg9JpBLXc4Ivha+cLtFEizglnWJLnyv8mA=;
	b=hdko7CPwpKiiakxMswulyg8PoK9aCc0sX+gJW+IzLNWxpbRAgONFUyfMdd1Q7bRkpV1WUE
	R9uvhl2Y3/olHRrHxQq8Hem0yUZp09QCKq3MyEXOFDGBCHHLBThzC/ESi6qV4hSP9rImLd
	U7pgxvxEdi+Ox3yWk4unAtS7ZFCx2XU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C0BA1516;
	Tue,  6 Oct 2026 02:25:51 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 261E13F763;
	Tue,  6 Oct 2026 02:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278754; bh=a586Sp6pUc/Rl0Hz27O7nZU4psH3uyrQcOIiCrjEAuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqrPAzy5JUyK6aAQqeRno6BaQX5SMC0KAUPoany2vZccoCJ0lR1GZVDcCfe1VS8V/
	 MORnFLEHBiT7ImP/rQMIn7FHj66Qxb8m7KkmdI430E6XoI8JYSsFBnUPgOz+hKkS+j
	 jxLj1llAp1wOu16+f7UMeZ9vgdol206SgobB/IFY=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 06/12] selftests/mm: mremap_test: fail unexpected mremap successes
Date: Tue,  6 Oct 2026 14:55:05 +0530
Message-ID: <20261006092511.145776-7-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1nh7r1p7z34zoowymei3amcap3rqio6d
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2762040006
X-HE-Tag: 1791278755-928234
X-HE-Meta: U2FsdGVkX1/+Ap41ZGV9z9r4dxDC+xh3pOYKXDLTu5vLoS0xSAZ1hiUZNJHbh6krLemNOo85Bw+XtOXedxhva59rY5oDTtTLnUd1k2b2ttybc0UMTtvHPMLQN0ItMpMcFzscMSOxn6AfGVPPLYM8RegVCcyjLqi2chiJrLZNtVZwJui0f8l8mKq7iSPgb0nEEjnvL3I2byvFvY3AgkK/skmjwMWDWx+y9qlCY7A8x7JiUtnGRmBVo1tnqwLo9FjJKp5w+abXu/bYRyAcuJhtss0gFy5gVkQUawmWwxk33Sx1AAFqaMtOivN/LySH1Y6sR2s4p3D8P26iqPylQIwE8Gclx3cCk4TAmdAjeyA/PvOxVbpyRWnjppyMpLcU5GO25LGUldXKdGnYYGr7ryZ/FlVfskO2wvFkxMf+F0fM3qAIFZXSr5PFjB0IynIjVvWZZwcopdw13x/8dL5DzPEkOmpRRzGkCVrWE0EnYHZNfZvH2NEzfdH1NYMFxji7np4JRsRjLVyImQrG/2wYN2xNRmsJ7cnbAyfK1fouRe0tD3t+qZr6zFmPsc6gogJ8qi/Eh6998qjN6UEy4wnchIzxr1joz2sQr2WgMm1V5cdpTIhdj7wHP9E9Hghirzt+mNNwx1ALkkDD8KqZqxQfSsSvsCS/IWRNoZq+jbtCx33/j/VqiXUvgUCR86+YcGYNwIG1+WoSfZ437pGpJS65w0MVFtOC1eDgajoBaTXZfI2PGJdkFmAdnK89uOH1/9r4jSJD28fgadu65igYq6nPwNo/dmJVNX92ZWw4eLW3WN6ebQqOkMflbo3JKQw3c7QuWVEaq4/RKETC5ox5cdQpK3PdNdExX9hEu474zLYacPO2MhPyKF87La/8lswzG4a6TBj4zqlFVyWKE8PDC1W5ujE5JC8WAWv+VMy40tC0Me6WlcR/ttKRcHQsJlLD0rloaGXjC3X0nNLGjta/fuLCmAd
 DQwYKs4b
 CKOdtF0rPlHrIVa8oNPGDWWNdvhLHK1wyw0yFF0Hc8EBSWqKQJ/3jYQeZww8W5gAdN6GdEFuTrvQvuL8ei6szA3koK0pXGbyqqnf2rJ2pGdVTcdEqHG5/jRdIJLTrgaAy2ZJPyNgaPOStU6nI0ZxhX683AmXvyQiYee8RS7+bA785moauUPX0heJ6d/YitMj8Zu1GfdSqg1vo+ZJXZcEi+XA3wjszJuwgXWLJYV2oiCHqyjzNSyDCUWvhW8MB/kQI2LUghN5wGh7XzWk9uLj54bV6jw314Otmb9EMe1PaoGpV7gjG0fAW83GCyTK5wn0rFTcf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_mremap_test_case() reports a test as pass when remap_region()
succeeds. But if the test was expecting failure and remap succeeds,
it should be treated as a failure and not a success.

Check test_case.expect_failure on the successful remap path. If
it expected failure, report a failure instead of success.

Fixes: 7df666253f26 ("kselftests: vm: add mremap tests")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 0be47348ecd0..1baf6374ec67 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -1122,12 +1122,15 @@ static void run_mremap_test_case(struct test test_case,
 		else
 			ksft_test_result_fail("%s\n", test_case.name);
 	} else {
+		if (test_case.expect_failure)
+			ksft_test_result_fail("%s: unexpected mremap success\n",
+					      test_case.name);
 		/*
 		 * Comparing mremap time is only applicable if entire region
 		 * was faulted in.
 		 */
-		if (threshold_mb == VALIDATION_NO_THRESHOLD ||
-		    test_case.config.region_size <= threshold_mb * _1MB)
+		else if (threshold_mb == VALIDATION_NO_THRESHOLD ||
+			 test_case.config.region_size <= threshold_mb * _1MB)
 			ksft_test_result_pass("%s: mremap time: %12lldns\n",
 					      test_case.name, remap_time);
 		else
-- 
2.53.0


