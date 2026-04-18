Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D347FF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486FB6B0213; Sat, 18 Apr 2026 06:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437326B0248; Sat, 18 Apr 2026 06:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326326B0249; Sat, 18 Apr 2026 06:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DEDD6B0213
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D852C1A0437
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:04 +0000 (UTC)
X-FDA: 84671374368.21.51D78D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 304831C0008
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kzY8iBlR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509823; a=rsa-sha256;
	cv=none;
	b=YyX4kGhEdHGFNSImLcW37HdwcnfYradkUpAv4ALTkc3+68/eutXFOvRmvxiLWLRjyxbtrN
	MkKxtJ1JJLw0lx98/jpwMoeT8//wJPFFfgEnCroOvQKWqEbOyFtxPImdKVnK0hvQJVpXt/
	nlMLCUC8GmrY44LVNp6ieHVMZsR2r+M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kzY8iBlR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWmZjhx8f/2pJAidENRSlmCOTJPZChkbsdvgf3r9khc=;
	b=4Z4Kr32ffNX04/fpvZeuNbVcQdP5+Pav9ewt2aHmlFSVDWK3StvM47YP/t3+PMKvsu/uh7
	jagtKn2xvWxKOVoo5/GG4XAIbz1A7R7uR6lfylNHVG+Mk0xOl4JI0AqTb5RWgMchgL5qZU
	GqZ9bKb/rsqZ2J7YKbeLMEpqlo/LuVw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CAB3434A5;
	Sat, 18 Apr 2026 10:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8905FC2BCB3;
	Sat, 18 Apr 2026 10:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509822;
	bh=+LNQibm8aLuZSYwVY9FBq0cG7Hin4pW2zRDuMUNoq1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzY8iBlRiHHKSBK8KKhiUcnEj6Tvqe0U4TiVoAz8ThiGpUpe2q1NJowR/hb/Ynl6/
	 5zYsw6qCZu7fDjZYxj/xmVPup92NWSSXnFCpfbnQBJfmm3DAnpxIlBtIwYSVMh99wN
	 2dm1/umoeOV0RpvCziqFt7W7tirImes+dM5bTiFc7G93fft+XMwAkfqype+QmJXEqB
	 WmxbnefLdQo6EodKXShbuaKyYaR44lr9HxLks1KZbdjSpkcG6HLlXpJqdsGxzZ4vPw
	 Jj9MFeOb38+hv9gPoq0qvlGX4aKY7FwD+AeyTkOsJZFYomXmyzHUR9ZZJeh2DRSlqJ
	 sgOzGr1g9GJhg==
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
Subject: [PATCH v2 12/53] selftests/mm: khugepaged: group tests in an array
Date: Sat, 18 Apr 2026 13:54:57 +0300
Message-ID: <20260418105539.1261536-13-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: kn9ta9thtndeuwyyedd3i1g6bsnrsmj7
X-Rspam-User: 
X-Rspamd-Queue-Id: 304831C0008
X-HE-Tag: 1776509822-297558
X-HE-Meta: U2FsdGVkX1+6B8uTqOX74sB367FDPVnJysqiDZbb0UJIjshBIiRGVjsAZvDFHVAFlpYXEW6IN+iHm2J7yIRYX5eb4dtBFgrbM4q7ltd6FB4hIt6rbAuaNEC7LqrxSaeSr6wFMQJxN7oyzR2XrxUr0faFVeXI8MET/3RmX+fihFOYLNqy5TI7fdMcEYqDYVj0xyGqSQNBr/iiWSCobFvI0dQLV7WjFQDwiGIE0aOxpPJoeXlmVfRZTUBj/Hd+AUEToGz+t+JOVgh6p9FDeIOeRUkri04ABKQU22+4uyLY0FzO/7XpWMsniFIsVl++NNGAzfLlMS4aO5gFAp/zjqRVsow/EwX4Ho8HvfpkkVVzB1dzwslkohBw4Hye9uslSoMZoByL5deLWMHTMoM8P3l/WAy/qTv25V6x/Kbv54kHliD3stsziHfag+KSsag+QrecGlXQSGQxdjvlkkQl8TTUlzfEjz1CdSe79bmYtZdD3SQrMu+fvUDIf3BCrWBaeX/zzJAbV2Bx4oBej2B4hp/EQEzpnQEOH01a8Qaq6GN+DdJ4GPdBDYHEex6L93reEbBMtBbjQkIJfYsjIWXOmQUHR+mBXODpa2mNVGmBG3SiJy6vhAhUwl3jEaXBra1nGPmKm9fMx1cG3JM9lHz5dvUvoJCuY8U0pp00482li1fiihPZkr4uRvkr8zshgIhYRD7y/Eefkhb94pTxIqcUM+lnEbVXnAaC2JH07NfN8ExXd1p7j/VWmkxsrbbZrpap6Bhx/9/BLdpo5LvSZRAf/sQG+Cpvy81Ac5LNsKYdDofIhbP6eUvc+rJhDOaqNxJXC8BwIveIbGGZ2bNVkb3G5kQQSc6Ru1abJJz9yjAuorLlduwI9mwyHWszllWVrM9x+kggPo2vVdmEqthEkMSix7kOHlRK038UA8H8PlEJ5jS4Yq/nh/v8zJF1Ao7rlnlnhZ4pis3yZeJWgPCOioq1U8u
 vEhXyhxR
 Pfewc0FPKNSRmVzQfZIPo/1ZT5LOyqFSLIoZC3jx6XIJTpSvCFZtIgQJpMnU6z2z5BNhFvQ5988xkT9G1VaTg5eNh/qkdj66AHwPifbu+aprRNuKIGKpG4AiJrRx29v39Wws15vKx3JwsnxfcSUG9Sx3/Z/Q+uqBxxRVU3C6smW7OTN/F2+cUiD60p4/5Fd/uqU5y95F6F/OLO+H4tWOjlNqVppxe/hhymhUJcrs09wspY5f0svvgku3p0elbNCQ1n4Ac8goa5qivoXM=
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
index e6fb01ca44ed..56494eea5ab3 100644
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


