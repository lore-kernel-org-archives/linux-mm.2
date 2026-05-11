Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD973CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533FA6B00D9; Mon, 11 May 2026 12:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B9F6B00DE; Mon, 11 May 2026 12:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448146B00E0; Mon, 11 May 2026 12:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 339256B00D9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 011261C00B9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:17 +0000 (UTC)
X-FDA: 84755676474.20.3832898
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1D99140010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RASCVci0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBffUw7n7I6ylhV/NkkBtcrlz43zz1HGJe5n+HQlHUA=;
	b=vaQ8p2N7TWuTWX4oRbmw8xL+4Zg8RJrvqDlaLzRN2OHhKHaL5kqeGR/fkJZISpJ2Ngb3ia
	9IT+N08zW369MTe2W+1XGxV5EmBHzKZYfa1JjkFoy2ztFzGC/ZoNfwNjOf6BYgLVRVdDyp
	yZ5Rmx69lFMocSYtTPPy/bZOmAcnikU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517016; a=rsa-sha256;
	cv=none;
	b=30pFGGyQPAd/TbsSdGEe1ijH+EMtAKKc2pm70Tb3VpzdhshEuu5tDjnJDUbX0RkBGmBl9U
	kNO+0smw6Dd+RIssthT/DMI/VFP+3wwovSPR+MosWcqJqYNcwDbSswmh+oYrliUf4Mug12
	AOyoch0pGSX/HmMDvMvLKE9K0cHnIQo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RASCVci0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B0D842BC6;
	Mon, 11 May 2026 16:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17673C2BCB0;
	Mon, 11 May 2026 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517015;
	bh=+tyhzUeUEnzi1iDlGNaasRQg7y2vvwXExnHRF7PW/zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RASCVci0CiekyunSKFk+4nebtalZXqMtTqFsylGOr1atHx+Bw7NPglCdvbZ/xHxNr
	 1UdginOFsZHRcqOLvZ3RkOi2V53eKlyJ6BGa4LaboIQJ4YgH+XSR71l7ATIxM0teea
	 TVw9suEblqOdzta2E99NgpHM8ieM5L3JlwIi7KEdPXl1fmGuKHVgE/IrLx4s8KA2zh
	 ciK878p1BsNq/EhGvpc1jPwLCFlVW5vkn9aEjSqCwQiaF4u4cmlp3N98VHgJlP7hRI
	 mtOnS5erFLQHhf2/970mcaRkjuLTXGeN0w6KvYZtkF/nJwq9A5Sd/pvkOk0gQOYIiS
	 6no5loLDsWzZg==
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
Subject: [PATCH v4 13/55] selftests/mm: khugepaged: group tests in an array
Date: Mon, 11 May 2026 19:27:57 +0300
Message-ID: <20260511162840.375890-14-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D99140010
X-Stat-Signature: kkn8cann34cmcgddfu7uy38ymg1rheie
X-Rspam-User: 
X-HE-Tag: 1778517015-78136
X-HE-Meta: U2FsdGVkX18r15JeNego/2Q/6BDDiY1l3bgPprTOdhnjzE8YUCHhcuXiiFkSdsfXxv87bHFu2OA1B4qMY09JW9QFw3vNHQUaP54Fx27Nz9HebdzLWLuyBip+SRB7JAapVcykvt/6G9k0Na9ppMKI+91AMcsgFSUz9dvEX9oL6AeJCfBBuOxKGM+hN291qpznvB60yKmvsa54gudqIbuuC3RA/IFe5KXC1InJDVvpXY1WjrBKHJxC2LeR7wZnrrD+lKpRlZ5XFDKichud8FCfnPruMukZhkwaQ4Y/AHastjmYkqueVqCLZGA2qkx2Ch+Z67A4T+IiXjhEZa4+KzOKOWz5hFBTx/kDWA+5tgAyUyhNo4KOzyESZwQ6tsLOdsQ0IhJ1M2mnnLq3VyTF3RLVux/tcdzP5o1yFYGeiQySvfQXXRpyBdcojCO4N5+3x3dQNweJVgh/RPYDPSfS0v2UoShCEIFxMd8tv0km1CDHx7g0unRcsKRCpdKaySU/sf2Lum5Lu9MKyJLbIzf3/AJsnJzTWd9adiP9xjA7CLGLPsxGVboqhvg2+wuoiuLH/Mdy+MNgozE66/TF8HGL21ti4auZONxgHgdoE0HPW6TJQBnV3ko8unXP1jkSYHkneQbRZdE10sw4NpTAR61aLpdj+m0Zk5fr8hWsGIMvi/FRvPTm3sSG9QY68oHjbH1xvloIjXuG9CLPlSFlilxXLG+NFPDcrt5Ve9J7nQFncvuUFfGMhhO5WTJ3ZaMqGnN4NxT+9Q+l2e5BoihexjX2b3fH9/xaQAq0TVCJHv5ot8bhvVpgZjDgT3WS5oBht1sp9WU7l4EL74pa59WbBgoHZ6Gf7lCMHyqAybPFFlCKcSmurYWmedE7VyJZI4gqlgiNcxX2VsFSBXmGJX2nbAn7pAetQtq6e/DOSXNmcJVJO1pr4vgXhkyUHM6phts/AbkTNJRy0B9F5xHvxHtOvs2sEYw
 YM70sw/b
 mh0m3kha9iFD24Pmvk7nkYz/glNhJDmp3TnqgaxUkaVmzo/qByGhasQr998be2j/Fzyk2yKkjWgwDDoMEikAYSVyZ1mt0J/rV5c62ZEebaoHAw2fdhDZGXrcw7YlmNPSSio1i3TDtJNGpopAbkI/10V+2xgR6UQPrdX2k4NLjKzl0bSAQJbN5yTpLREEXdTAO/hWDyldaoxgYZWgaVLoGVTSIl0sRarkqExNONGphrIKWHqgBx9WjZsVnIAmPW8mti4i4
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 43 +++++++++++++++++++++----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..4e3f6bd3b933 100644
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
+			printf("MAX_TEST_CASES is too small\n");	\
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
 
+	exit_status = KSFT_PASS;
+	for (int i = 0; i < nr_test_cases; i++) {
+		struct test_case *t = &test_cases[i];
+
+		printf("\nRun test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		t->fn(t->ctx, t->ops);
+	}
+
 	restore_settings(0);
 }
-- 
2.53.0


