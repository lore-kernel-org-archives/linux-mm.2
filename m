Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 614DECA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C148E0079; Fri, 22 Aug 2025 04:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF32C8E0056; Fri, 22 Aug 2025 04:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E22A8E0079; Fri, 22 Aug 2025 04:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 858DC8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:23:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 251E61406A9
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:14 +0000 (UTC)
X-FDA: 83803703508.28.106C6B2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 77F724000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OGkNfH2+;
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755850992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYJ0HYY9NqlVyRWcfV9rBpKj3nrAUZ6hFe9JiCDznz0=;
	b=rp/qoR6jb8PxMyz7Am9p2gMf7sIncyl/9pD1Qjll8dt4pdu4Pu9BqrS6egr9l9n/THtHG5
	kmnhpad1cmfPdyJBjUJ375Iy2NY13m6bfGR+CKibtkqjuY3MIPjavsQ4rF2aLqrUgoof84
	u0drQg0YIIR4R8C35V88t04L3BGKSkw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OGkNfH2+;
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755850992; a=rsa-sha256;
	cv=none;
	b=S3b6uJAXYsYFKMK7Bez7OH/82i1CGaWpNfQGo9K4ryHa5JtQuZdBApN+eVURcv0kcINz2e
	YOOkC9Y384K2agVYOFSe98nhegMAu+lTW7lwg6getx7SQh7qjgrcjQfRBsuA+Oa/VRSa61
	Kn56gwRfjmyr4KchMpOcVjKW0bVFkvA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755850990;
	bh=aHdKM33fPfvODogG5EIfl2ZQHN+nSUZVsocpGCSr2PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGkNfH2+jOKoqsx4XZqdfcwgt5aP8gbPPl82/usiD/mSerW8TBt/XWrm8vxI1zLpK
	 eqcr1/i/34b4xZc0sJCqCeN9WAVRV28rq+MnTzIFG95wrWT8p2l16Nom1XVGvbRMkU
	 /XfZMJLkH4q/k3giOG1XhtkdHJUte8XcUlb4m3GG1+vS++hxw0RDLbu67zL0pWxBp9
	 Y0fe+ERCypRn+qaBnXtNXTwGEfvJmiG6AnmA9QIziJ59Ql4CoOWW/skcucNYUfH3nz
	 2Y+8tIu4BinYPStQB/I8QnEondQp1YOhBDz76oVxE6fLq0URfGaLnzH5UM4IOS9m1d
	 MfHrw+RQE2ltA==
Received: from mt.tail9873f4.ts.net (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D0F1817E137E;
	Fri, 22 Aug 2025 10:23:04 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kevin.brodsky@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v3 2/8] selftests/mm: protection_keys: Fix dead code
Date: Fri, 22 Aug 2025 13:20:59 +0500
Message-ID: <20250822082145.4145617-3-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250822082145.4145617-1-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d6nth3ixpkqn1zp8rrdm9g7tpxatcst8
X-Rspam-User: 
X-Rspamd-Queue-Id: 77F724000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755850992-324225
X-HE-Meta: U2FsdGVkX18RKZaqTW3LLLAAPKowoiwI47Js8FXkJdmxi+QVc9hhPsbMET0z6Fql6q5WOaTtnqlmBw9JJZuXItf93zFszC1c3+6UjYLHd/DfpFICWy3YmMfaMQlfYt1g6HwDGb0Hdp3oRGtM0Lf0fKX1lGOGGwa9pq4Y8OFefbzAXREe6npnecYKVMbpRfvUXxKS23IE8geOVv4xifSz47pKP3JwSHHTOJHJ7Pa2WZGtCAgOE894Gfxq3ycknYza1U+xO9QJ+UjJbFveR5/NBmjLv/GgnQw47nlE6IboZYB7nGsz66ikw1VeLppfqf+pfFOLfWl/O/g4ZxiDdnJflZ5N9fus2eGyeY2oYqzKSG9nd+wYpsxC6jdcZovtn7NXUUzj6GEHj6OKgpV0MJ1FcwaHjBD6x2enRsi0bTFSULImZKyTMmZlruX2mTaLvM78TXKYILctPRkPBXNolvXl7bJGOAeRq+rvk8Jjs9W7nJNFo+1xawE2sojS4cnRxXhdl1ZVvNJxpL/yaW88hr9STauEehtwAZHXHnkpofSRsjErKM5ndM5X+RElmL6X79DnvlqyIU4TcjIoON7ZJpngyHQlQkyC1BF3Okfysbcpj4tdZkadkO//5CU0q3aJZ2MAPKZxDsGMoZTU2Zt1fdpRE16fHaRmM7qu9Rww23MWLg3BFV0A3v7IAcnPHVG5iDVvrPsmqwryOCigYEOXMAKPMmx0NQ0Z8c/MT2YaTLfMNoQsdDt9A8f8L0LgNx8gPIpcdSklO+6bivoEkJ9BxP9QWNGH+1Jd8yilUayYbqcdXaqMpDmULV6NcyDOwVrzE7rdUytY/gDhbyvwgkftUCXWJbiph46NH4raCQT4Wfj8eqScSS8cbwhfeadon3dKP86NoLy0LMQiYRJQ9rRnRiHE7YgTnEVFLfOE1zxFDdFOMtvrd1VcY771jtB/5GaVo23idynLNcM01uAQvvjldJN
 GnUMBDPb
 bRLAsxpvZOrXqbYgQCf+8/M2DzFqHe1TSBu0jNhoMLYaiFKbRWxoFrODkDqjtKfBqm7+krBwNNgY8WN2ZjhMJo+Wx5YYGLsjIwoC7TJxA6Qb8coj4bLswDC/WW2NZPkSWJuLrjeZCrf2kmS7nA4wd6Eh+JOBZeUnSbdTgwzr+vxt8OsPJBQ4gnOpKpvpVVfCzGMJ2f1X/7MRRrE7OBR+agVKqKyZxqM0wGgNgHKHo76/4AF4CXp0tUnFIZiXleY+9JkSQE4CSP+tumuOwHoSI5c4IlOYmiY2f2TaUqm16sSCUfBYcAu/+bE5SDe7Zyyez2VWn1cGI8w/kzP07eIefi3lOAeMyYT9mQDGn5fB87J4TRjXLPId/ubMhTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The while loop doesn't execute and following warning gets generated:

protection_keys.c:561:15: warning: code will never be executed
[-Wunreachable-code]
                int rpkey = alloc_random_pkey();

Let's enable the while loop such that it gets executed nr_iterations
times. Simplify the code a bit as well.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/protection_keys.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 23ebec367015f..6281d4c61b50e 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -557,13 +557,11 @@ int mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
 	int nr_iterations = random() % 100;
 	int ret;
 
-	while (0) {
+	while (nr_iterations-- >= 0) {
 		int rpkey = alloc_random_pkey();
 		ret = sys_mprotect_pkey(ptr, size, orig_prot, pkey);
 		dprintf1("sys_mprotect_pkey(%p, %zx, prot=0x%lx, pkey=%ld) ret: %d\n",
 				ptr, size, orig_prot, pkey, ret);
-		if (nr_iterations-- < 0)
-			break;
 
 		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
 			" shadow: 0x%016llx\n",
-- 
2.47.2


