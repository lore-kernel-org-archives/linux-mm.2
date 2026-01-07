Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E929D0D143
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57F86B0098; Wed,  7 Jan 2026 11:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD92B6B009B; Wed,  7 Jan 2026 11:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0256B0098; Wed,  7 Jan 2026 11:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B18766B0098
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:48:59 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 685DC8B9CE
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:59 +0000 (UTC)
X-FDA: 84305752398.14.D8AA037
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id C6B57140011
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804537; a=rsa-sha256;
	cv=none;
	b=1AzbzD+FK3zXCrkdsEVDbxt/CBfMOEz0zEsraCSSw6HLESwJ5+Ol6RCULt0upcja7/KUyM
	iAm+Sw5CHFFbQqBh5JW3IUJEMVIywU2TSxw16c6J7GhC0Up5Q68Kp4PSGGvo5tN5a8Mw7x
	7pUJPFSSkjnWHRkHR4z2lTYCm9ZXRTk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9js0LGTCYWgRrJ28mS7Bf6CHYKmXb9OG0hKPXh8YdAs=;
	b=X0q7NyvVsPE5Ra4IopO9mIZWgIgkNiIof8BZLOcIASTuCUaCdLQ/jEUaM74BAUVayygG+t
	tA8o8we7clBycUavNC/gy3yMZDV9Y4Gppm4JAxB5Sw/UVNifkCLReHtB8y96MFX55WABzZ
	4isPzptwdzhhUEQ8NSPd+rz4g34VNpo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85C241682;
	Wed,  7 Jan 2026 08:48:50 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 232CB3F5A1;
	Wed,  7 Jan 2026 08:48:56 -0800 (PST)
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
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 4/8] selftests/mm: fix usage of FORCE_READ() in cow tests
Date: Wed,  7 Jan 2026 16:48:38 +0000
Message-ID: <20260107164842.3289559-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107164842.3289559-1-kevin.brodsky@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C6B57140011
X-Stat-Signature: bmspjmo6hyf4ura7mskjx589epc56mcc
X-Rspam-User: 
X-HE-Tag: 1767804537-478969
X-HE-Meta: U2FsdGVkX18YpxU+0MeQZijhY7ZuNf0KXTeH4d+EojEfoVQJzU6t5bJf4j5TEtcHTy6s6lFkDKAu/FcAKl3hbxAlCoFI6YJ6QfgKhgwAWk5O6huydB6B6qFxv9fTmsjwmDAbCzIMQcyoaKjdlHzHyaXiYyo7fdbG/KC7MqACt1bgUzkUNH+j7ObtaB9E7HpP/3EGt7TpEh0rVMlVPguqZklNcdkJ/M4+cxZuUAvDmMOfHyahb9e7WcBYwr+6lrDmWywEujpJKV23iBMVikvRZVyQvMWo5zhnvLTbj+CpbCYIzNvxTP+rx93uYAhZr/6lKdRdyQ2Rq5VWkjyvv9xW6Kt68MK+t0qnAB0Ay+1JGR9frQwAIO1xXLVUJdOITjPVbcZR9Kmc2zEMhPtfwoLHX/GWuXNwdi6zvgfmhCoFaZ7useNc0INZVqloFx5fdbOO4J24q1ibVCtcuIC74Al1KMJc8dqe7gabjDn13sOWuMDOc901qxP7bxG9c0X20TO8x/AXrywTTxMnJdHoX6e1B1+6+NhH14mWDBAyb5udkjl6POVfNp4tnQtLgEadTuDFJugh6CXrYwDMWR8Tze3Tho/8Z9i2lt5xHbcKqyRPI+5SVa01J5o4DPTdyzoKMs0bo0UPgEcHm14EvYJFSUVRCrlt7WSgSkbrXIiBSpieZwOXsAIkfqoEBRwueyyLQfySBjoBnqNcL7RVY5vfzWLQ0sdwqjd2DBghIXNnBVr17shdhPSPhf03e3q9A84k3iostH9TyL5h8u1kSG/Kc7RhC0k01whXljGOxBLEOzhwEgnDS4JA4sqNpvwPV8w+aYurBnY1Isel0HofJmhUf2oHkiyj5c5i664+WXuHIRdTOXfTl4lF37RtsZiOJslBGRDQrqFH1iUGeZyO3nJJD/QNQ48YfVXcb4fgpHcEZmHGqYan7WU2EtLqMm9dAA0YihpQ2FuVVc/FD0LZ+2IjAVb
 LIN7iIbl
 Yzlxxd+vQgqlp0/HJ76habIUuRGt+RlY6P5ktc7fikt9ZlrIFef8a3g6xRqip9lcsOmQvPOz24TtQmrm9z8sFzMX6X4O2iSsZGSMKjDswyVeiYcleVOsOT+hc02gdwll1dNGCfvA0kBy3KqHflRBAMVRd/7UsQbcl8cbpsQkkkAkGIbf9DIlUYRw7iEv5CPfuKCKKewHUON7DuFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input
value correctly") modified FORCE_READ() to take a value instead of a
pointer. It also changed most of the call sites accordingly, but
missed many of them in cow.c. In those cases, we ended up with the
pointer itself being read, not the memory it points to.

No failure occurred as a result, so it looks like the tests work
just fine without faulting in. However, the huge_zeropage tests
explicitly check that pages are populated, so those became skipped.

Convert all the remaining FORCE_READ() to fault in the mapped page,
as was originally intended. This allows the huge_zeropage tests to
run again (3 tests in total).

Fixes: 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value correctly")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/cow.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index accfd198dbda..83b3563be26b 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1612,8 +1612,8 @@ static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
 	 * the first sub-page and test if we get another sub-page populated
 	 * automatically.
 	 */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
 	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
 		ksft_test_result_skip("Did not get THPs populated\n");
@@ -1663,8 +1663,8 @@ static void run_with_memfd(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1719,8 +1719,8 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
@@ -1773,8 +1773,8 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
 	}
 
 	/* Fault the page in. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, hugetlbsize);
 munmap:
-- 
2.51.2


