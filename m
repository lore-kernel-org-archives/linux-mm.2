Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD472FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44FCE6B00DF; Tue, 28 Apr 2026 16:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400DA6B00E1; Tue, 28 Apr 2026 16:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316CD6B00E2; Tue, 28 Apr 2026 16:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAFC6B00DF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A19E2140443
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:11 +0000 (UTC)
X-FDA: 84709149462.27.33EF940
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F1BCB160011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUpSi+Wl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409228; a=rsa-sha256;
	cv=none;
	b=ZSmcapJkRNlDgFnuNDNlHm3ob+rOANzIrvbVi/uNdMZkq0vXfwwQPxy0KuAB+dliyMjGfh
	2cLBaCHwFNXohnR+mYvWIIpgV+M1uvUjGP6h+36eLAb2BDEnB1TxnqCLmMYSCf35qKXKr7
	R3+mhgmR4KabIURrKxNGppTyuThxcG8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CUpSi+Wl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVh/7Aa/cnIS7AjqQi+qhfnzIfXzCps4ncChcwj3kY0=;
	b=HGe3CsJr8srs3gV+ucfEkscKeFTPtiNAOi6NZvfpQTH66jxbGGao5/7DfuvaJ/53cv7bvE
	wViDQCARRCW/6HrzNeJFyU2bg6UQhlzviax0n+tfSPkrHM4GCuxuQZfiPHfxSJp6PSQxdA
	68tdq/D915qcPOeIA3to9iqv1GEjG1A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8334361119;
	Tue, 28 Apr 2026 20:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298C0C2BCAF;
	Tue, 28 Apr 2026 20:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409228;
	bh=H40+pLu8ZXyLLCNuZ1aw7t2Lxy9FF78cv/g7Q6Z1blI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUpSi+WlocgmOIRAqyCd2U0J+RRYYD0kUVlOkWBufcWndXzjq+aJv3VMiMpWVyD8z
	 ozi9L2nDHyBbYziKZZ1i7gja3h1ARE4bu52ED0clgVQgZXX1ivXZSQWZBpTW1LgLhR
	 IQ4OTgGQL21uWskksLhlCdonNTDXdCtIePG/Whe0MAlO0WSx+g1ilu9EinYENtB1/6
	 h7LBHRYPbTFIIHFWFa1BWOtAjaKwu86h9qMcDpxiXfCb+jeW7LAJ0nf20xpKYTHzF2
	 ComEQb8K1hGs1ctWo74laWEXNg4dFfgkEY+nMvzfEOwFs9czach7b/BvD4O9gjWYbC
	 6Zx00aMg0ep0A==
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
Subject: [PATCH v3 39/54] selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:25 +0300
Message-ID: <20260428204240.1924129-40-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3dg5djewnpbgp4u9jisc876yw54bcd1q
X-Rspam-User: 
X-Rspamd-Queue-Id: F1BCB160011
X-Rspamd-Server: rspam07
X-HE-Tag: 1777409228-718152
X-HE-Meta: U2FsdGVkX1/kNgsVqlrcw1FtOIWidq8iblAr6BVvT+3RMgjrcUeld8no4L7Ymx282ylYvkyfvgsE5ZayfTjBhXcfdzH7XNqBOqcbWF8igiOu0id4sWXHo19lw7fAHdhqWtX/7e/1upJapvVujS7tfLdhRDCegHsKJxxB2S31qeRRCRZMRYoyV/Dn60ms8qIwlSfzNbjYp0mLf9FzSoYFG6tNAzR+dBfzLMUlVuEKydfbyykAfpLJNHtHv1xSr4z9PotCDd36A0e9eKnKQoZEQXh1FHriRQVo+GIdL+rLZOXwSHzr7uHkcNiw11g+Y1hCglV8mXLJO0u7+9kBTT7XS7o0LPoDa7tw5H/I7nYRP6N4eeyqDSQc4VzdEdUcx4qskA4rSrwD8h9+uH9cRFf25tmJMxPnvdbAdrU4f3PykatRdasCcROMHjxrdvX/Z0dk5exCSwI1NbuBZKLrZm6NqxlJv9B9rbP+Fa+BOIE5sHjobsQxU7qijumgDy7258hRDvV/hCw+docquKwFAA66QxnhCQGixuNRSca5Kyu4EfxyajP0F5bTmsvIqo3Gpq+cyO0Ps79kae5u2z8op63WlmX8gKALpnjj08bcgsT5HR4K6X0SGxs0eSrUKq5MVDCdtjIxMSU3MdjBXdzxmSky7IVaIH+pdS9PJfai9ykceOGqVqZKNQJMnwV/naimA++hbskU4EUrXnzxG2ePC8vcd+YlflHcuDPi4i1A7vx3NBHycJZK0GGEZZglxLnFZddnBv+kXuwg0q3FRRVvXtnrVx+Da1QLzPvM11XjECyNb9ARpeLvJ+mFW4kJRx/88bvCGmVnTKEURaPrwO9YRpOvu1K29OFVGAJf757pLfwqHGyQ8qV31beRRMuvL5jS7ugxn2/Fx5J4slDi0Q7ylNNFcXLiXEoYVKW21pxmhrl0/6PtOtk6ladxC0BZveghmQzt7QGtylvbdSqXyld5ovd
 yEk+Lv+B
 fdL8m9QvxTAP2cITANoRDvlvY1v3qm3mOshsxzDgL5CM6+ND5Fj9eUVD4qYy5UqZZ8bqc5iQLgugXcW8bf0Qi2FzF2wzOd1oekt92NEoV4K5sTE1+rGlgniC1weENCKinQn1TnwUW5Z845O3+zfKYTZa3wKy+qZ9xVl4R+cBpGXf7F6geo/khtfZuYfGFsX96sHcyPb8+6zLCxvZ6L7BwzMENnPuuKoBcEIuedXAJAJiVAs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-mmap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 031085cb7d17..f12fc288ef4f 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -109,16 +109,16 @@ int main(int argc, char **argv)
 {
 	size_t hugepage_size;
 	size_t length = LENGTH;
-	int shift = 0;
+	int shift = 0, nr;
 
 	ksft_print_header();
-	ksft_set_plan(2);
 
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2)
 		shift = atoi(argv[2]);
 
+	hugetlb_save_settings();
 	if (shift) {
 		hugepage_size = (1 << shift);
 		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
@@ -128,9 +128,14 @@ int main(int argc, char **argv)
 	}
 
 	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
+	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	hugetlb_set_nr_pages(hugepage_size, nr);
+	if (hugetlb_free_pages(hugepage_size) < nr)
+		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
 
+	ksft_set_plan(2);
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
 	test_anon_mmap(length, shift);
-- 
2.53.0


