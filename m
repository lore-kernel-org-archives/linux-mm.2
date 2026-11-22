Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDF5606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 08:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Tm83Z057
Received: by kanga.kvack.org (Postfix)
	id 44F706B05B3; Sun, 22 Nov 2026 03:20:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426976B05B4; Sun, 22 Nov 2026 03:20:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362D66B05B5; Sun, 22 Nov 2026 03:20:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3BEB6B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:20:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E46440676
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:20:31 +0000 (UTC)
X-FDA: 85462058262.06.3D13A59
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf07.hostedemail.com (Postfix) with ESMTP id D32BC40003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:20:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Tm83Z057;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3zKUCawsKCIEpfqjxmxnslmlttlqj.htrqnsz2-rrp0fhp.twl@flex--kaleshsingh.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3zKUCawsKCIEpfqjxmxnslmlttlqj.htrqnsz2-rrp0fhp.twl@flex--kaleshsingh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795335630;
	b=EmLx3dLuuwvNy11pVNaVXzUm06YyH/rEN9dtK1ULKfgS6peGoeWYylGJbcR0jb+p31IFVE
	cKCEm5Nnu5OlwFLEgy2KZEDm/sbqEEgR+NEe7WfU05Zxgs2GTb7jO3pPY0dcy6kDUzvgAi
	ZJ0wRiet+qUjgdXapStQD40N7i2q9jE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795335630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Rf2VcTDmTGn3qRzDj6gU5ruc9gUgxiYv5dADr6Q67g=;
	b=Ur2xRuLEMEOGumJTPZd9mQeEGhSh7F0JVSLN5kphIB2bFf8eXja1iUzhYd9RRjSCCtq+wp
	7VjDS4sIgOfGShWbPvdlinlLlfLxKCpYafHKA7sEsM5B/7kil2+VDaSh0VqONye80QyOn3
	gxsmcLgGsuDKcN2bRotZL7Cm4A/QOuY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Tm83Z057;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3zKUCawsKCIEpfqjxmxnslmlttlqj.htrqnsz2-rrp0fhp.twl@flex--kaleshsingh.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3zKUCawsKCIEpfqjxmxnslmlttlqj.htrqnsz2-rrp0fhp.twl@flex--kaleshsingh.bounces.google.com
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1b3b5b49cabso2100388c88.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795335629; x=1795940429; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Rf2VcTDmTGn3qRzDj6gU5ruc9gUgxiYv5dADr6Q67g=;
        b=Tm83Z057mqBB+1dp/PSxlnRgupbJ4CWnTIrDegO8gK6FKqyjDeszXLcTGNNueQNvjF
         G5n+dddFjnlSpGsJDI7JjISkyT+H45K/U0xJVdq/Tx4bPIQtI9ID6HaH+Fy4o+yQgxTZ
         LTuXxFsn2YGLLA4vvzbkiYz/WUYy/xB7Mm/WwG5n7+ONRUQcrLgdvg/y/LogwNxjnooN
         6eRK4hrCXPmMHAMmKI67XKWAPbeczmof4x+o9VUNoh6X2pmVZ99CDao91eX7T2E66h8e
         jDFG7D/wIDR9wHgSyoBUhFSMuqZHrDYU0qDq33wbWlqO+6zvi/umPa1UBUuD95seMeuX
         3kdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795335629; x=1795940429;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Rf2VcTDmTGn3qRzDj6gU5ruc9gUgxiYv5dADr6Q67g=;
        b=w8/G/qOB9wwzhbtyC6AP37BnfhOoWgLGoLRPJwo2loDKdCnBfPOC7YsVRJjVv92jL8
         qnsY+9SD5JA1zqHbR8qlILX7/c81rHc2PdXen/oPHybECUjrzAFqJ2/y/8R1OUqvN0Ul
         4okF2/qQfETdZA3pX4KRWA0IshRGHsRA9CYEWbuvE05LTokQ1ZlapP2UZHHJgUJwol7D
         xU1e8YjwGJm9aOPnw5tmSGfL1g/xZnCC5SIPkSnWg5UKt97B1itd+FJ2Nv1DLgz4Q6z8
         GgLvjf6fQj+OXE8PhGMPKAy6eNSQCkeDwpu8W+VhAAjBT66TK86aXnPENC0rbGqoeqH+
         jgpg==
X-Forwarded-Encrypted: i=1; AL+hErGjmlmMhMPMP0dWn4piSiq4Oq8IqMLZBijrl0p/0HPK4hD7aBbHzCtAsmvL3tDtdHuRqq68DhQThg==@kvack.org
X-Gm-Message-State: APuU4Z8+nVPgPW5CIJypXb0vftqSbvHT8svAYHf0QFGCXrfWc+0IDwuT
	4P9foCK2K9CjugS0h+zJEZPMqzpQFks1sAitznNSxnTCYWplo7nJnRyqugySBXZludxPyYQOsQL
	u7BbLTNKQ4TDKetJCqpqiQs2XuA==
X-Received: from dybfe25.prod.google.com ([2002:a05:7300:bf99:b0:379:1aaf:7a27])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:860a:10b0:35f:8c5d:5928 with SMTP id 5a478bee46e88-3857073f3c4mr8592473eec.30.1795335628168;
 Sun, 22 Nov 2026 00:20:28 -0800 (PST)
Date: Sun, 22 Nov 2026 08:20:18 +0000
In-Reply-To: <20261122082020.1255434-1-kaleshsingh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122082020.1255434-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261122082020.1255434-3-kaleshsingh@google.com>
Subject: [PATCH 2/2] selftests/mm: uffd-unit-tests: filter required features
 per memory type
From: kaleshsingh@google.com
To: akpm@linux-foundation.org
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: n3xbxo3zm9jz9xyfs6s3fsfk53k6z7wg
X-Rspam-User:
X-Rspamd-Queue-Id: D32BC40003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795335629-444949
X-HE-Meta: U2FsdGVkX18P6wosNS8zF+FR93WUpyKPrpNygGOoVS5BlBkxMLJ5waXXuiLxu4aXijJf9FTvhM8VaD7J4KWiWHJP7+7wIU/wMCpOk5kQZ2A7r7PsHZuP8BDUzyBiGjHTmNA9huIT5yVjcXEb4aNnHOhY03VHuVj3wlhK31MaE1MyYIw/yUc7uq13g6EadGhBmGEliNV+0t2IGxGkvU/OKf7SyXd+Tz5ls0hEatfOAuUzXOtfHF9fB2J9egDZd/TFM5f2l6+lCSLVO3L+rc78eFZjx3qgl+zatRfn39FcOv+LJDAeI8ya1pPuf6OUiybGQzVbMOoVtvbGHEnyLWbOFm12THs2y3+gqlTiUswZl+okYOBN0yBkrSJzLiKwTQ0gdZNg4An85/5xokykXz2HcrfQzK8dSaxBDcDu0pWVG+smFtYZh2ADKHYEaZhblvCbl8N0vZJ992qv8z2LS/GOnUU4VjORqDo8/hzX1saxe5t1pT+CzNb82spS8nJ2Zbd0GafaSEcSqvBDm94w3/kNatu0mGy9y7wKfWqv2ke8JM0oQgDM/DxltN+zyboX9Y5BHuVXI+xaGrNM8ThqRKIYscNCelJQWqzs1Oa1McZ4qczCLcMnC1k+uOy5q7ysbJJawgSceHXjMHrGyNdcJzpNTOOSs4aTP+hkWI4F0STYAXwGQIYnj2ZgZWcpzjQBC6HTpKwZ0ktc2Pii8nmmcbT8nV8SipE9gjv3IS8CjnfHkJSeQD2SrTohbLHTAiwXUuSJykC9Q/B4XBCvcOKCwVzU9CyE2k56Onn6ejn2Y3RuUUfZZX8FNRJNMucd5MADPFjXoZVpk/KHio4wo3pGWoWFHeDPlGJFUUDDAP2jJm3Qn+TQ+DgKa/uRygFEqivQ/jeRBWY7Nz/4z5wY+CuyKXiZo9+3BntBMBbHH+ZICxyeWzM0VsYkl5fkNSunD+vWFzOtPEVOxVkJG9GSEOHuS5a
 G3nSm/rm
 GhCP+ri9zjxBt6b+WsedVNt3BtNrpvY49StfEq5D2l8ZCIfhLaA9reHLBkAOJCBUaTqEX7cx/nIofTZEMOjNLfbqmxt7jjJEZrGlL3Pr4zDZ6hAWV57Zg+1HE1gpQNFvAkyFbzev+EE5mC3jd/J6/y07vQ2qV1ZWtE5bwgj4K5DekqAXZTUmE60tGAHBIC8fnjX51MXq+YtMUUKIro/EkAetgOAN2QOY7i82Z2oBZNUMdxDBNfovwyGeGgtCvycjlov6F+JVYytQ0aG/lT9U1J6mbr0UfnCVXE58/CoIj9tTRKcX5e7qNlqeo4h5vyIx/rMTbL4zlARjwJXRAjVWdVU+GESZVRDbh6v8FRBCG0vtGg568ipJvxJ46e/4EiXFC4DXnf8TKKzAxE3IfQGB4srBztJnNpzjHeg4s6b00TzJCLfzpvLS2z7xcGgR433G7jE+kNo1wdqP5Ki522PLWZ/hk8vhvvQOV2cyvqlG7M5jADIsG9sBqAeHCDvi9GF7vEcBaYrfJLgG6sWiKw1b/GTbgTw85P0qpk2Ut/9YiXK10CFIjL8HBZpNH2IYJOeP0p42V2cTW+qZgrgLXoodJJiAMMzJxmhVBFbCCSMZ9DFuCpNvNOjbvfUkIIs3iTUpulu9ganaLweTINpompdG05e01VeDl5saVPcGTBhwdDPSdVI4AO4vFC6gEj/SVds8GMNLgR/lFlKK7UBOWMyhJfiT3iLaFs0Y2SbM9o9YT9sJ+V+fkNRGEp+XCjtDg9pN4S3EbojD7cSdGpoN3GF61PcRnPiPPBck61nqcXwKkPbK/y2dRwjVPiLAG71Qd4w97KhZRKlc0ndcfgU+b0SpUYD7T3NRP69FVajNYhivnOkDA4oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kalesh Singh <kaleshsingh@google.com>

CONFIG_PTE_MARKER_UFFD_WP defaults to y but can be turned off, and
userfaultfd write protection then works only on anonymous memory. The
kernel still reports UFFD_FEATURE_PAGEFAULT_FLAG_WP but no longer
UFFD_FEATURE_WP_HUGETLBFS_SHMEM.

uffd-unit-tests checks a test's whole feature mask for every memory
type, so the tests that run on all memory types and require
UFFD_FEATURE_WP_HUGETLBFS_SHMEM (register-ioctls, the wp-fork tests,
rwp-wp-exclusive, sigbus-wp and events-wp) skip their anonymous runs
too. Check and request only the features that apply to the memory type
under test, and make minor-wp require UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
as it write-protects shmem and hugetlbfs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 42 +++++++++++++++++---
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb..d0dda2ec48fb 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -176,15 +176,44 @@ static void test_uffd_api(bool use_dev)
 }
 
 
-static bool uffd_feature_supported(uffd_test_case_t *test)
+/*
+ * Filter test->uffd_feature_required down to the features needed for @mem_type.
+ * For example, UFFD_FEATURE_WP_HUGETLBFS_SHMEM (gated on
+ * CONFIG_PTE_MARKER_UFFD_WP) only applies to shmem and hugetlbfs, so anonymous
+ * subtests should still run when it is absent.
+ */
+static uint64_t uffd_test_features(const uffd_test_case_t *test,
+				   const mem_type_t *mem_type)
+{
+	const uint64_t shmem = UFFD_FEATURE_MISSING_SHMEM |
+			       UFFD_FEATURE_MINOR_SHMEM;
+	const uint64_t hugetlb = UFFD_FEATURE_MISSING_HUGETLBFS |
+				 UFFD_FEATURE_MINOR_HUGETLBFS;
+	uint64_t features = test->uffd_feature_required;
+
+	switch (mem_type->mem_flag) {
+	case MEM_ANON:
+		return features & ~(shmem | hugetlb |
+				    UFFD_FEATURE_WP_HUGETLBFS_SHMEM);
+	case MEM_SHMEM:
+	case MEM_SHMEM_PRIVATE:
+		return features & ~hugetlb;
+	case MEM_HUGETLB:
+	case MEM_HUGETLB_PRIVATE:
+		return features & ~shmem;
+	default:
+		return features;
+	}
+}
+
+static bool uffd_feature_supported(uint64_t required)
 {
 	uint64_t features;
 
 	if (uffd_get_features(&features))
 		return false;
 
-	return (features & test->uffd_feature_required) ==
-	    test->uffd_feature_required;
+	return (features & required) == required;
 }
 
 static int pagemap_open(void)
@@ -2417,6 +2446,7 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required =
 		UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM |
 		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
 		/*
 		 * HACK: here we leveraged WP_UNPOPULATED to detect whether
 		 * minor mode supports wr-protect.  There's no feature flag
@@ -2636,6 +2666,7 @@ int main(int argc, char *argv[])
 	mem_type_t *mem_type;
 	uffd_test_args_t args;
 	const char *errmsg;
+	uint64_t features;
 	int i, j, opt;
 
 	while ((opt = getopt(argc, argv, "f:hl")) != -1) {
@@ -2711,11 +2742,12 @@ int main(int argc, char *argv[])
 			/* Initialize test arguments */
 			args.mem_type = mem_type;
 
-			if (!uffd_feature_supported(test)) {
+			features = uffd_test_features(test, mem_type);
+			if (!uffd_feature_supported(features)) {
 				uffd_test_skip("feature missing");
 				continue;
 			}
-			if (uffd_test_ctx_init(&gopts, test->uffd_feature_required, &errmsg)) {
+			if (uffd_test_ctx_init(&gopts, features, &errmsg)) {
 				uffd_test_skip(errmsg);
 				continue;
 			}
-- 
2.56.1.750.gf70dc682cf-goog


