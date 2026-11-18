Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13272606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=crO6+6N/
Received: by kanga.kvack.org (Postfix)
	id 8B09C6B05BD; Tue, 17 Nov 2026 19:26:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861156B05BE; Tue, 17 Nov 2026 19:26:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701896B05BF; Tue, 17 Nov 2026 19:26:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36B036B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:26:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD213A05E3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:26:22 +0000 (UTC)
X-FDA: 85446348204.02.1E2E5C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9445B20002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:26:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="crO6+6N/";
	spf=pass (imf13.hostedemail.com: domain of devnull+matthewsalsamendi.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+matthewsalsamendi.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961580;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yjJk9mmqwIA6tlXuJLnvT93Ny9bjpeUE9ULmreaqulk=;
	b=3pMlAsh6dLCyRlZCyeqFIMJYX7fVvMSBrLLUkbCXZa+nKM5+VHjBUdEqI3VMaxw9L0wY02
	rJXGIMu7nZvlL3rsq9wIK18BrLzYwvhaIcWVaqAqjjIj96QtwWxYnlF50lFXNg3xgo0Yy+
	u7m33ExsnPuc2ge69gs+6iZiZA/AQc4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794961580;
	b=jIirxxPF9ClXWoiJ1plemarEWenm7JHCLn0MJi6Wf0CPEg+CiG6N4Nu20NG/jg2zHpkbcw
	HqIC7cZ4ztJ+5c4ssqqB28FrG5lYlyllrg20bp6J83+jAoT+VNv3NibY6lSvQ7DxQE4pvn
	Uaf37SlwO4BhFI5kGtZltUu+WCDPAxg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="crO6+6N/";
	spf=pass (imf13.hostedemail.com: domain of devnull+matthewsalsamendi.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+matthewsalsamendi.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2337261ED6;
	Wed, 18 Nov 2026 00:26:20 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794961579;
	b=SG5yjTW8JJBD+z/aMo3GsQ6eF2ElHJD/2vHeqKYC2ggLfDMSugIBgQLKEuXlcqdZTZ5B
	 OZFqptT+THZ7WZSBJzEL+fAW13jY9Gk3ri2SWNDAF+l6uqvdTVYAiRtBddiNa44RKVT+p
	 SQ972A0mUiLflpoH3RW3vFom8Y3EAJC96MQyi2LJcYLwAOLf11YlXwEzplH1eoskGo1Tv
	 14QT2pIaJ+FlJ8rxTrcY8mdan6wufMNIwDNjbP4XJiHTHGyi/oQOJIzPu6938OvaURoMw
	 95O4ugNiJEVsvAF3kGH9+h1YGaRZshPFHb0m7pZkubIa6p65MZGtCWfhufgR/gejZxA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794961579;
	h=DKIM-Signature:Received:From:Date:Subject:To:Cc:Message-Id:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yjJk9mmqwIA6tlXuJLnvT93Ny9bjpeUE9ULmreaqulk=;
	b=on8+ly/Vrc7oYMStH4CTe83GCuxHTaDHAynSjWpwC6NB9daUfkWmH3a7+8qqaUx1keHX
	 aPZ1JpOsen/DdSSiT6N9jaGUsAJEFgst+s0auQxupMMcpZOdUfU9nVSpKXM80kuioZBNj
	 6HfI+aw5fvmKu45ti/oBZGtPomukJeqW8r3pRITFvdViK9O/mCKnj0VZlIHNRYL7eNpo5
	 0UFxB8dXT1LtdjqQKAAXrRvcedwzAwE/MOsodXxTC2ol1IKfGrWyFY5fXu+/ZRk742sTQ
	 JraY4VHNePx/kpNogKtq/Jo/YaNAd770OP+tEf9bng+R+v8adT8Jfc95TgdIzsArsCA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 64D471F000C6;
	Wed, 18 Nov 2026 00:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961579;
	bh=yjJk9mmqwIA6tlXuJLnvT93Ny9bjpeUE9ULmreaqulk=;
	h=From:Date:Subject:To:Cc:In-Reply-To:References:Reply-To;
	b=crO6+6N/H8rwSzpIG9s9eCFt/+LVoxEnf6cIAeM9eCr2fpAIXv6qA2P+siYTABMs1
	 ERCmnzsEJZV3kcvtMO1RuVC3LG0r2o80z4PjXLs7VVtZfd949IVOW+E6Ci3kC/CMXT
	 nulMA7JxafqVwLHsypuLw0c7PHBnPVJtF+NebE8zf8N9NZVg7Nf7QRdHSRZKu9NfOW
	 2F90DgEgHCT1WBO82BX20503AXdUWgjAt8o9PBfjh6mIPJpUYrPQ4++P1bovAXlfFg
	 S/Fq4jwKPaHcXXbSPHkBPsvooeY/fx3hFAKOJezsdOfvcMh8NRG0eqN3m27tqGaNL4
	 LX9TPxZhqK5yg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E69424AB7A;
	Wed, 18 Nov 2026 00:26:17 +0000 (UTC)
From: Matthew Salsamendi via B4 Relay <devnull+matthewsalsamendi.gmail.com@kernel.org>
Date: Tue, 17 Nov 2026 16:26:17 -0800
Subject: [PATCH v2 2/2] selftests/mm: cover PAGEMAP_SCAN refill and HugeTLB
 retry
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Vlastimil Babka <vbabka@kernel.org>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, matthewsalsamendi@gmail.com, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-kselftest@vger.kernel.org
Message-Id: <20261118-pagemap-walk-end-v2-2-94cd92d838b3@gmail.com>
In-Reply-To: <20261118-pagemap-walk-end-v2-0-94cd92d838b3@gmail.com>
References: <20261118-pagemap-walk-end-v2-0-94cd92d838b3@gmail.com>
X-Mailer: b4 0.16.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794961577; l=4010;
 i=matthewsalsamendi@gmail.com; s=b4-kernel-20261117;
 h=from:subject:message-id;
 bh=NjI4ckbRiDH/qj/osMQWWUKd8BFP8IcXjX/T5XOwGbg=;
 b=mrjF2WrjZGFgovurzwg8O491bymKSYiw6D8PuPvt46rgg2nazqv8TPr8dKIckqMsNpfgMOKTh
 YEQcy8h++zCCbqFtnK/w6RdNSXJy1wNYLOihLNAAODzz4YDmq/jUmr2
X-Developer-Key: i=matthewsalsamendi@gmail.com; a=ed25519;
 pk=K4Lg4pTU46IL2CPz2Nb/u30nsnWJ38MlR2/Co4n0tto=
X-Endpoint-Received: by B4 Relay for
 matthewsalsamendi@gmail.com/b4-kernel-20261117 with auth_id=1555
X-Original-From: Matthew Salsamendi <matthewsalsamendi@gmail.com>
Reply-To: matthewsalsamendi@gmail.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h58uti38b8m4bkhpye7s1q9g7twdnot1
X-Rspam-User: 
X-Rspamd-Queue-Id: 9445B20002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794961580-262439
X-HE-Meta: U2FsdGVkX18TTQIWSpBxCcN0ERvia6jfs+ElsDBJ3PiHJcqjBdNFMjr2IfjXokOnxXx5LbfsbZZH1xjPFwlUDVdSNG5l5PIUVdEAEOKCrRD9LHc/puKR7lxePOb826ulu9V9+D7XKafeBLu2opKN//kD6aC+OqH2kHDExRR6KB9n1hqsI7A4Vvc0+rLdkbpn4nbPTsmsVBrlmjQgyGTB9iyeqFTGmw2TmyqfjQ3u7ncjti81XvWI8HDODPx8iTIZ2DyppZWS/6xBaLFC5+WSMImmGNnUKAfJzbga0Hf4NuDn/ET+cGOh1TgtQxEf64kQZ9krQS8w+QRRuVsXC/ynZnSwObfuhwC/dDIXIs1Fcs04le4+qZKF4GYvawA/k4qwmJ4jJ7AzAG8jEDVE3QAUBhx8e/yCZSfRf+EPNKcDeZKJQN/QhOOu5bDHB+me4pnFcW3XdruCbvxzafJDaqgjF8AhyR9UyZFRh7ukfFEbTVYIjB7Md3+sRf2SM9skigP0K+ZTLmcV+qUq7roi2caY1PfEQ4ERSoAlhHGaTOTvikqTkD9ipSmU2PAOTD3D67jsxBvh7ml+S0kOEWOGotPOoMBgjrfjchDU8QyPeRN8OQGDuirqSss/Rw1W63AcNrkRhfURDtdu6QzLfy1q1QwfNl2WK+GkJNOZ9wDgpjPq41xcdaUMTiEifKu/OEuRZ+rNpca16gREyUjY6wxmABJaUqhgYmfy1ZV4rXWmvaXZCS57vjh3zqIdbCxqhZToFZzzNbnPCp3yEnz+S+q57mZDbBAWQEZx4YFlz+CufwFGzEQlx0hGlATx+oTDIMs2ZLWi7nnDfO5KEnT9ac3P19vc8LL2P2HXVW8r1Hp915cuytqQDkgZs5pxoW9UaLGdtnByAineKC3kqyFuA6YPUToAICqJE7IRMp+s0JcB+8bVYK8h6gW1WOcQrNzGs/EFub77GmZRjCMHQXGy/PKaIDs
 8I45gcoA
 qB/yIAR8NMcNYcZuxsMhO7jUnDekj1Ut8DtJdzaasb3OvQF1ZejyZROiwQGf3tAYobSAVV0Tnut1WcSzWpadrSA7rA5HLYAKcU4NX6Cle5cmjzkPx4KNkxB97tj7FFtJfVGIi5RKLJHjCgHdLpcuW6N8axQHda8uh1YicTf2433lkTWUGGvcWw0FYOnODumsNWnagRhW6HmI8wUlhpleZbTRhWWKUpEYYmVT6O1LArCu9+2lkQVMHnlEH9ffZhTDvpSbDRI7C1XCRyhTxyoF/FbKhPIxGdOQZaCgTEJzldfMtvfnZQEa3MztGX40oZdFtZiRi9EXjz4/W7eIGxfN1pQID+sWVQ0Yjrfy1OgOa9lpaNrYTaSISJqUSGZfmNWQKowdyfwtGROD6RRwSRDlPeAJb+iAFjCWtYiMu2TeMKbb4aTLZfuo/lGI1+8M2NQNAA1yBeMPqaX6H/pVeB/wAVPJcqNZ/t3x3X+6metoGkVYMFeEkNDs5xOOTwlwvO3+mp3aAB9ClDiqcf1cdz/Y1cQ3WXqFmPMUzc5cgFkwcXbFR2UVfpK+rvbD6FL8TaSRxfuJ9RzqxfSsUJemMUTejifZBGLoKYjuzTg/JYIeoyju0jgKqRakLuOVbiiQt1exflPMW+9XfAz3xtsJJiFaDb+5TOuPqClc5Ef4gDGeyhPiHYg6GbX/4l4djEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matthew Salsamendi <matthewsalsamendi@gmail.com>

Check that scanning 513 disjoint dirty pages returns every range and
sets walk_end to the end of the scan. For a written HugeTLB page, limit
the scan to one base page, then retry from walk_end and check that the
whole page is returned and write-protected.

Codex assisted with the selftests, validation and this message.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Matthew Salsamendi <matthewsalsamendi@gmail.com>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 61 +++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 03898b4f6cda..02062b178aa5 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -682,6 +682,62 @@ static int sanity_tests_sd(void)
 	return 0;
 }
 
+static void test_walk_end_after_refill(void)
+{
+	/* One more range than the internal buffer holds on x86-64. */
+	struct page_region vec[513];
+	size_t len = 2 * ARRAY_SIZE(vec) * page_size;
+	long ret, walk_end;
+	char *mem;
+	bool ok;
+	size_t i;
+
+	mem = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
+	if (madvise(mem, len, MADV_NOHUGEPAGE) && errno != EINVAL)
+		ksft_exit_fail_msg("MADV_NOHUGEPAGE: %s\n", strerror(errno));
+
+	wp_init(mem, len);
+	for (i = 0; i < ARRAY_SIZE(vec); i++)
+		mem[2 * i * page_size] = 1;
+
+	ret = pagemap_ioc(mem, len, vec, ARRAY_SIZE(vec), 0, 0,
+			  PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
+	ok = ret == ARRAY_SIZE(vec) && walk_end == (long)(mem + len);
+	for (i = 0; ok && i < ARRAY_SIZE(vec); i++) {
+		uintptr_t addr = (uintptr_t)(mem + 2 * i * page_size);
+
+		ok = vec[i].start == addr && vec[i].end == addr + page_size;
+	}
+	ksft_test_result(ok, "PAGEMAP_SCAN walk_end after buffer refill\n");
+
+	wp_free(mem, len);
+	munmap(mem, len);
+}
+
+static void test_hugetlb_walk_end(char *mem, size_t len)
+{
+	const int flags = PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC;
+	struct page_region range;
+	long ret, walk_end;
+	bool ok;
+
+	mem[0] = 1;
+	ret = pagemap_ioc(mem, len, &range, 1, flags, 1, PAGE_IS_WRITTEN,
+			  0, 0, PAGE_IS_WRITTEN, &walk_end);
+	ok = ret == 0 && walk_end == (long)mem &&
+	     !(pagemap_get_entry(pagemap_fd, mem) & PM_UFFD_WP);
+	if (ok) {
+		ret = pagemap_ioc((void *)walk_end, len, &range, 1, flags, len / page_size,
+				  PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
+		ok = ret == 1 && walk_end == (long)(mem + len) &&
+		     range.start == (uintptr_t)mem && range.end == (uintptr_t)(mem + len) &&
+		     (pagemap_get_entry(pagemap_fd, mem) & PM_UFFD_WP);
+	}
+	ksft_test_result(ok, "PAGEMAP_SCAN HugeTLB write-protect retry\n");
+}
+
 static int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 {
 	size_t vec_size;
@@ -1661,7 +1717,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(119);
+	ksft_set_plan(121);
 
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
@@ -1669,6 +1725,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	/* 1. Sanity testing */
 	sanity_tests_sd();
+	test_walk_end_after_refill();
 
 	/* 2. Normal page testing */
 	mem_size = 10 * page_size;
@@ -1730,10 +1787,12 @@ int main(int __attribute__((unused)) argc, char *argv[])
 		wp_addr_range(mem, mem_size);
 
 		base_tests("Hugetlb mem testing:", mem, mem_size, 0);
+		test_hugetlb_walk_end(mem, mem_size);
 
 		wp_free(mem, mem_size);
 	} else {
 		base_tests("Hugetlb mem testing:", NULL, 0, 1);
+		ksft_test_result_skip("PAGEMAP_SCAN HugeTLB write-protect retry: no huge page\n");
 	}
 
 	/* 7. File Hugetlb testing */



