Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73988FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D740C6B00AC; Tue, 28 Apr 2026 16:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BD86B00AE; Tue, 28 Apr 2026 16:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61B16B00AF; Tue, 28 Apr 2026 16:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2B306B00AC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:44:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 791E9C0F37
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:19 +0000 (UTC)
X-FDA: 84709142238.09.E3A9AB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C29791C0008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=No0P7iwP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjR/dzinedlGiZixJzjYbK2IEvLVBTHfUFNiAF2cj8A=;
	b=oVs2Pbv8xgTuQ30Mua7JrGWI9umsY8mktxGMArdUoKsxqBdeaNNJwUJjZhM6oBGWbGWsQh
	KSp5TX35UY3OoReiJrQmzIg3uovHDVx2NCRnukNmfSfgiOxnuVmYaj36FRbNs3rpirBg5t
	XvUnVZyeApCug8umZP+kP+Iy/FGGlBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409057; a=rsa-sha256;
	cv=none;
	b=IypLQ8/Pz+UVaj9vlUvsY+cOsif4cvlNlZS/s5E+/+k2bKl5GJ3OxO2S/qpvqJ5pRI0wWQ
	9dzQwPGxFpwNShBLyFmx22+PmMmvShIBUij3nLI9GMhAWBao1s5ifuui4cGo8Glv5/0ygw
	qeik2ZZdz7C8zn6tNAv3iU0KmaMfQms=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=No0P7iwP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC9A640BE1;
	Tue, 28 Apr 2026 20:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB29C2BCB3;
	Tue, 28 Apr 2026 20:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409056;
	bh=UcY2aZ851ybWDtG1WmSWUypuuOgK5C/YOGkz1yNU7vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No0P7iwPSUp5/3eOjmCWqYtNs5gQ3UKdHYDH1NsE0W2vodcggH/FYgkl8Cj+xo1KN
	 rcE2m4twOPyfw7B+bYZjRlBRjVz4lZeiAfuo65HtRVkT4V31FUVXFThAJHbvM6lLPf
	 GVbnXgtd6ofoYXGZOTZloOo5dbgM8cwGTrvh+ilbVYC3Qr8I4rk9Q3VeRXqOTFT+rz
	 EC4L3ezv89EhnbGzDGSCuyUuAhY6AUp/RdNzvzGzuis03+xNcj9MQwx4wiAy3dRo0r
	 kXG17Ru1V7wHj7A5LjveynkB7f7MTRkn0uAkrDVo9IKfTjnKpxoipOy+/lmNVRtjoZ
	 HK/4jQ+e8hSFg==
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
Subject: [PATCH v3 13/54] selftests/mm: khugepaged: group tests in an array
Date: Tue, 28 Apr 2026 23:41:59 +0300
Message-ID: <20260428204240.1924129-14-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C29791C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: i6zuks35y3q3sir9i5o13o9fzg45swry
X-HE-Tag: 1777409057-390165
X-HE-Meta: U2FsdGVkX1+KMg9VlFDknP3ySuC75fK4r8WEUgi91g/fL++g+0joj2pEK2EkBhcJ8viTvHSxdQQ8U9siHmdikWIz2B0Ad2sBJSRFBbVTxqgxrvRwF6znxgFVGvQkYMJk4Mp0N4wXh8haNLCU3/iu6Vtl8ApVD3JRDIdRf3FWvk3nNo1wrkBw3YlpoS+X4CPeHyVqQXC3qTY8YXyA0jw4lONDwFfDCAAE6wLzW1kZP0fsJz1yWRHY+xTqfskAJyr82C+NyT6rRDge4DKISvigWCRCtF4Aoh/ZFz6nBo1IXpEXdOLmHs43lGDahZPSGmBScMhHKAvL70i6mOFpSpfdzd6gJq5iO7RpUuze1iVrQZFu7fChl+I7gxuBc6aQqxPoiUp69AGYB00UK+o4mLVrc3MFeRvq97k366GRRbMfCY+fRQybSjXqyTFbrUoip7bP33VajM5wnPoW3gt84/AiCkIxj0HTN/G0LwzkNFTmMDHTTNm4PxUUXLngQ6AxOjLxJKp3vsLm0BpqvMvXf4UFBa0wzeioo+EBBluKsLg6M/izqIdGiDEmyFnPZMoJnD43RmgtqG2d3q3cWNeANCafOxl+yhzrcB0AbHBFgk9abol5tRqx9ce/CCCl/P88AIeRlMsOTNIxcIRYcdl8/yOZ2YxeddRlJ6hMXmzx+tciXym8fnFc34qi404wvKlHBwYdw9gJdOQjnH5T6RTJEHFozuFALlKxYKsAWRtYmbMNOjJFUJI8EQvkPr+whs8W1MzqOYPL9r4Q+JvBq24aD2VKGCNQBcwHGgqgxSlyzRABmwwNo94ywdxKlY9fTkq22oxjbcD1OWEuNpblce+3MaFUqlOhU+CZe8LVopxLs6a+cEAdgH/8Sq+Uj2r9mcmQyIfUbn7SMEilKut8iyH1AWRCnyk8ZqrzJwBwYrSpv35ie+te6QNFPcVxNKsBUAGdmQKn2Rtxc2th5tv5EtLGQjr
 wvHu7BrP
 kMlc/qWeMMt85JdPVkja5TotOlrxxQW64lSnr2mMd+3z6wnhyYrvpROuAU7UhsOXuepjPmjJNYiq4Nm6wx3mhe3WJs/EILQzyYXvKE2r+UP+AcaX4ihPHxBzHsJ8CKp3NKFpEQbdLYZ8DZQUR8iULmTyW47fyvOGoo4p+0s8Pp9bgvfFgYhV8vQ+goAFEkgQdceXbXG3gHWKAB5APfFFh7UblptvACghbFOXN97oY7XFQEpbkau1kaTw5aEskQPGc3XDwrtrDcYqflcJmzIBdZNB9Tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Currently khugepaged decides if a test can run using TEST() macro that
checks what mem_ops and collapse_context are set by the command line
arguments.

For better compatibility with ksefltest framework, add an array of 'struct
test_case's and redefine TEST() macro to conditionally add enabled tests to
that array.

Then execute the enabled test by looping the test_case's array.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 43 +++++++++++++++++++++----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..10f0d3cb1b81 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1165,6 +1165,34 @@ static void parse_test_type(int argc, char **argv)
 	get_finfo(argv[1]);
 }
 
+typedef void (*test_fn)(struct collapse_context *c, struct mem_ops *ops);
+
+struct test_case {
+	struct collapse_context *ctx;
+	struct mem_ops *ops;
+	const char *desc;
+	test_fn fn;
+};
+
+#define MAX_TEST_CASES 64
+static struct test_case test_cases[MAX_TEST_CASES];
+static int nr_test_cases;
+
+#define TEST(t, c, o) do {						\
+	if (c && o) {							\
+		if (nr_test_cases >= MAX_TEST_CASES) {			\
+			printf("MAX_ADD_CASES is too small\n");		\
+			exit(EXIT_FAILURE);				\
+		}							\
+		test_cases[nr_test_cases++] = (struct test_case){	\
+			.ctx	= c,					\
+			.ops	= o,					\
+			.desc	= #t,					\
+			.fn	= t,					\
+		};							\
+	}								\
+	} while (0)
+
 int main(int argc, char **argv)
 {
 	int hpage_pmd_order;
@@ -1220,13 +1248,6 @@ int main(int argc, char **argv)
 
 	alloc_at_fault();
 
-#define TEST(t, c, o) do { \
-	if (c && o) { \
-		printf("\nRun test: " #t " (%s:%s)\n", c->name, o->name); \
-		t(c, o); \
-	} \
-	} while (0)
-
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, file_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
@@ -1286,5 +1307,13 @@ int main(int argc, char **argv)
 	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
+	for (int i = 0; i < nr_test_cases; i++) {
+		struct test_case *t = &test_cases[i];
+
+		exit_status = KSFT_PASS;
+		printf("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		t->fn(t->ctx, t->ops);
+	}
+
 	restore_settings(0);
 }
-- 
2.53.0


