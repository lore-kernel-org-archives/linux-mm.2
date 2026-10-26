Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3F6606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OenGcW7s
Received: by kanga.kvack.org (Postfix)
	id D7FAF6B05E2; Mon, 26 Oct 2026 19:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D569F6B05E3; Mon, 26 Oct 2026 19:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E596B05E4; Mon, 26 Oct 2026 19:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93A5E6B05E2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:26:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EEED140841
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:04 +0000 (UTC)
X-FDA: 85366362648.30.E6C3A08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A1E940002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OenGcW7s;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pd6OfqmpOChanyaBg9muCovOqLNLeBHLddsioXEL2d8=;
	b=V+7xwDksJR9kUtEsf4cTBO+g2AHK+DAlbkxaWztSDKzixFNl5Zmi2WIuVEmBGoS+3206sO
	XLg48O+Hha4tnpCB/5YU1NgI8zZK9iwrAbedTwwhoHrVrFuRP9Es+T2oCnhv69lqxklNaM
	+9b+6UhpCbQ3Jsz1bonu/zKF58nlWdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057162;
	b=VF5SXnDQqExQ1cCxkJK5D4QP6WwUFYFhZkl7eYFFzLDPkerzwrZsR+LrEAPODt32UHesJU
	Jydw3wxIkelrlyuVpbN4hV63bJMwKPfJ5orSNBRddSmP8xCGsPNKwZGzTXMU4f3mlOy7YV
	8EL0R7nTqdkYWTA62ht9JzfRyVmw4PQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OenGcW7s;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBC5F60546;
	Mon, 26 Oct 2026 23:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82AA1F01828;
	Mon, 26 Oct 2026 23:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057161;
	bh=pd6OfqmpOChanyaBg9muCovOqLNLeBHLddsioXEL2d8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OenGcW7sFoZGtv1gaXQpArBMVVnJOhx+l+0ykN84+ptoXAervg2MfMkka6s9HSVYt
	 tgcVqLUGEeLeqEoFYRQ9jzW6NyFKFNuyEYv4ZWrG0aKe85MpelQ3jS81Hv84bvTKJ/
	 jwAyd5xVDT1L5VfHo4kHUml4LJ4183wu2xwgQzh/EgzXIIFIajoE5bBmtTlNWt7JWp
	 gCu64lDRoEk2GNJoKmSfar44UgKDAIq/GF3c/idb4eUGQgJVmbOoDavw0xuvlJ+xx4
	 xw62M57+bReRfFtktYO4uLFMd7NCesCYhsca/BQIPApEutsj01S4PN9uTgwYKPFOjH
	 75BU22gCY+JxA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:46 +0100
Subject: [PATCH 26/46] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1683; i=david@kernel.org;
 h=from:subject:message-id; bh=vZJ6VSoQXMdFgpkoHzKAC0N6aJn0tSkxLvHpOmbVOwQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/2tcJn9u2pedVh2kaKzXubJ26ytvuerLI1/PZTd
 5aXS3U/dpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRgnZGho98yTLy/Kv6Anbt
 tX6T+fSrkcfObflNKQvkEm0CRKusnzMyPN/TNOFSidoD7sC7deuShCurFjokHp1+fqsd09ZXLCf
 amQE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A1E940002
X-Stat-Signature: 8wu4kfxn1q878jrsp3mar4i6t7jy34dr
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057162-723861
X-HE-Meta: U2FsdGVkX1/QTzRDjMpblJsgrSIKqDkUWPJahod72UTvgVeUwR+S9sNod7/5k7QZl5wgTCShyo3NDxcu1SVngfxWpmTQ7qhaY31ps2DUOxQu1/jtsSk2xT39vDNVc0ZIP1ZqUVmTNhRuqHtsucfMu3zDcM6EPpgbjtIgbb4YyJMRKafLAqvSlxS9Uw6BH2OmG2/Pi0WcXqNPIQKXuP7+qpqGDab5RgdLxcw2TGJyP96G/sVRPBU6YEJOfcz+0J5AGlx5b1o0Py4RvLAG8FLrXmw/C6xrerfdiT7x5nj3xeyf7zWu1lJz2dC3BBgH5k+PuNwpv22L5DPDmeSR+RiCf+fvJQj/MhuhCfmXleclpogqsEO41DaXargRXmjYlJR+L8ZjJSkMScx+bQjYhI15OPV3rmddhYBTP+r0ru3FI+U58XnAfR225hhohLldq3cX7HGtJE8GzF+eFJWf5JzW6HphohRMKf/p6xI9+yFHJDTF+I53nkzgRvpeIIZ5SE176HOTSveCds7soHuKyats4aM+fswlS4giTCjdi0z3XdEoCrYG/nhnKDYtOlWwrgaKMSZhMmrM1f1xkiAu07swvJtyel92A2FHqOUQFfrV0oHAqvtvLVYcJQGaCwo0c0voL9WV3A3DPOCEoLCyxdR7uVXYY9KjSBrbYhc5sI8R9u98CW/vQ13gOA98XXewZbj9ifpUclkb1KzbW7ssaA24u5FjnCQTCiX22RosK2TCl+lvsPiuo0nhReT7QAY/ZVQJ7Xm4sIXmufRREarLADEZkw/SuKh+R1q4QItkLhxYRgCLOpHWqpPbrL7Txo6/2eVXHypTo1bqfMMiVormgoBq1DkuRfgXelFM/Oz69CjUWlDNqtQvcDv1qUnftEediyP36tkmrPfy4W6X64SIe2WkLZPrIO12XZNxldBm502pgFlTR1cQMbEaTKH9E9NAsMOhIvMLIZ9qwsPMFIROF7V
 TBxEtWYC
 tAOE9BzKIjeQnay52LtqD8R3+nz8Q37C6qnZ3uLM94P6vwyOz3ok/hsOT6fJRXXyL0A5IsUWvwOwLlm4rNUJugRYgSG+zC5fERJPiZrqVM/imMBctggj2Fr/wLSBHZoQTkLS0VP2SQ8UdlY5K2ZwZywujnWTAYey1sMTa6HwgQYFujgDCAVM4nUM+hcf48M5qY7imN4FnP5yK1PYPx4t+4GyIDKe/nyHHNkE56DLcRTqeYf23gA/qwZ6P9exg5dak9PRvOZlkeWQUSOjtyHixVzBdx6jBuYYYpfYo3m4P4HHmIDwh3/CSs1BiTd4fTXS16wDFaxASkGbcUfc05RttPL8HBHi+PGIvzKuS87QCcF/KhaHZoXQwzJFwty2KiJRRt0OX9ofg5jvuj3s3Y/UrxWF96m8doFOOXU7WwoVVpFZ+4Ig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

__tlb_adjust_range() takes the size of the range which has to be flushed
as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
and pass an unsigned long. Consequently, a range that is 4 GiB or larger
gets truncated, possibly to 0.

On arm64 with hugetlb, a 64k kernel can flush 16 GiB hugetlb PMDs, and a
16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
at least these two scenarios are affected.

Fix it by flushing the proper range instead of the truncated one.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages")
Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: use two-tab indent, simplify description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/tlb.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index fbe1114e9a443..3f4a180b48f3c 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -350,8 +350,7 @@ struct mmu_gather {
 void tlb_flush_mmu(struct mmu_gather *tlb);
 
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
-				      unsigned long address,
-				      unsigned int range_size)
+		unsigned long address, unsigned long range_size)
 {
 	tlb->start = min(tlb->start, address);
 	tlb->end = max(tlb->end, address + range_size);

-- 
2.43.0


