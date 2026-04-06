Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2636F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26A206B00AB; Mon,  6 Apr 2026 10:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240CA6B00AD; Mon,  6 Apr 2026 10:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DB66B00AE; Mon,  6 Apr 2026 10:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05BA86B00AB
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47EF858E84
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:58 +0000 (UTC)
X-FDA: 84628337556.27.A53CE2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8082318000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h8nwyTgS;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h8nwyTgS;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485136; a=rsa-sha256;
	cv=none;
	b=C+hdIS5esa1vGMqOfa6i9Ef07zPQ61S6DzUQYicm8P9294uH0d6E/wQMdp1px/Xs6/dnzI
	Tf46ylrKE7TKf2osElvX8yB7r5kfibES8xzwWMyirFJE6oF6BzbloWwrPDlDbnBvtMNTQm
	CVbQOBlh3I+sk3eJxnGKHXgLlEVdgYg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqeBUVB4T9342XqvEHAR6ViVRnMGvpUXxiHjyoQiEfQ=;
	b=IIt4/GvIdFCUqSW6cSAe1iPjsjJ7SPucsEiltSeSOgSZ+Z7YMAIhcOPQIEAfd3762kqa4S
	N1chC77xWbrEE0plTf6bJYIL9gB7F4wK6iEVtzkOOoDx/TqS7LdRIbtC8okcaJdPC1IBSh
	vrG1OhtNN+vsiWyxYcLAVY65rCBJubY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A896F4013D;
	Mon,  6 Apr 2026 14:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4949DC4CEF7;
	Mon,  6 Apr 2026 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485135;
	bh=XhpXuGv3Q2N5RR3SFrfFVeXHJDW2/LrteJ1gRZygmv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8nwyTgS4YxERVKRIl2J6mmLTYZmy2J2Bl6MhuHG1WEbspQaH44DvdR/FSR5Mk6cl
	 HS87h7FLp3GiprDlQRc/9sdMdVPrrKxpAe3VYkLYonXe4uuGuzOBbCH05LHIgKkt10
	 OK7cK7inCWzdP4X6KWo2wCweoHTPwbWDayt8COtHN4sckOHDpHgUj/k+IJOrigVjvg
	 KvzFOA2oJJ97uTcnkJJ3HMOfa3qlIsH2qTKozKhqfPJ92xb6fnlt734cy44gfv3/Fl
	 1N0xyuMkWOaAd8k/SD5sSGUPpgoC3FQ2nzzxKJ2sqnnd9hu+zsDx9SDgaCHgb6tGSE
	 +Ci8c/qpSG5Gg==
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
Subject: [PATCH 12/53] selftests/mm: khugepaged: group tests in an array
Date: Mon,  6 Apr 2026 17:16:54 +0300
Message-ID: <20260406141735.2179309-13-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8082318000C
X-Stat-Signature: jojfyautqhucir7az9n7kmedrpakxz48
X-Rspam-User: 
X-HE-Tag: 1775485136-460786
X-HE-Meta: U2FsdGVkX1+EoeeRUX1HWbaatkRzD1YHn8hBNxpPI/xkM4MZHTYb4gMpxCF5idgHlY1IVsS7/PH/NspaQO4S5ZJKUL/rimoUyk7kFDzmxEdZmzuB6HJxNULlqwkvY0bNeQ+fHmXQqBL1wc89VtgfKt2wkTVMOvkFvA9wd02UvyeiHw7qAOlRRtTMkkPThbhnLxPpJrBq7q9onnqddM8ayetldUXkNF9zDjt5AOVbY0jiHV87H1QN2ZUxZq/K38AGdeIRZcOBy/UjtUuizWmWsxYunehieZ3MHUoWoA1xmKgDGsoyyqkf08VsJplM5d6QB5UF2fg0OKpyN+fe3tvuC+QEHpcMXNIylJpttaVIh8HlU34/w36ND3YPWxrFJ8SPMLT12qMWLt2cbvN45oAhffYN7O3p2oGWyLIzNFWzPOP+8Cd2u40xSeSwb+F08pi+zXw48OHPLXKoSl52EBHD+6F4dJKGXuEWMYKvejEsI2upVKv4wSsNfE5DpYm/DLT1nPqVwaX41+kFFRFoQhjt4+Aufonjps8mkL9DaQZzc4i54Rn0jLIfj4cVCXHLTvNnaxMvqCKTpeomeaH/yaCrc7NkFr1Keqd/Lol/sTRiJdQg2MVrIP4d26v74SkgTOFoJRzD9YOoJyBruc6AzFKRtO8vzkRjsZ/DHyktM0/39kI292g5zV40n/76z0c0k3bD6qVdJ41Sz8gmKc3iadDgdC3mEysKnTLms9NruVZNSbitI5apV5BnhVGDf0fVhEvEvdF0pwvhQPHsGl8CBYbaw4jpD8hw5Hs4EyKuqmtnDFTaWsJZVbbCX8X2YMg3J5TG1XzhY6ubB4AkrHn5jEdIvA1zSd0Wp3l9T1lPnFJ7vTU1Ns59YzRn6UT5369RYESb71jA72NSSPnr0c5ABq9b0JyS2VVvlYkfzm9MBCPw75uJdaFGRdyKsNMJzq/XYm3SQOfIV7EuDKzDnm6ksth
 9MbR4Ijz
 OAALtuyII98xmUOxzOPpVSIpFt3+YHBxoUI++O3W/ZdXkUcX+ApM4sOgaQbtl+mTJnHXYgGz0+bKu0a/Ir+USahuxbbrqqWvCK1OTDCAJCVmHj0nX377bd5RBnmDRzr8LSjEqSUfzMzJ3FtJ8/YTGJt/pLjUjNypHEBwVltzhgcwMVogUyvSBRfxoXTEKN7OlHLPEsxYCj0zfivs+iaIb4M8jN6v9OtNaP5OGM7/AoWVomC7JIxqRj73gK0b1qm2gXhW/FY58wGOUwZw=
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
index e6fb01ca44ed..1cdc5918d20d 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1161,6 +1161,34 @@ static void parse_test_type(int argc, char **argv)
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
+#define MAX_TEST_CASES 45
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
@@ -1216,13 +1244,6 @@ int main(int argc, char **argv)
 
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
@@ -1284,5 +1305,13 @@ int main(int argc, char **argv)
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


