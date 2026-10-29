Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C58A606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8E+Cden
Received: by kanga.kvack.org (Postfix)
	id 82EC46B05C6; Thu, 29 Oct 2026 06:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806236B05C7; Thu, 29 Oct 2026 06:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C4D6B05C8; Thu, 29 Oct 2026 06:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 515366B05C6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBDA4160367
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:12 +0000 (UTC)
X-FDA: 85375331664.09.28635A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3212D140003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8E+Cden;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEPuOS39iMOT1AtyD14etoYTLMUy392NJap8KxtSbSA=;
	b=aWnT8FCaTdeXZH3fZlYUCf71l8IUc/QjAaGAHyuhzyQi0+ijmp9cAc8HY4l0BiXdnEjlSk
	6hBPYUPL4lVs1joZ/bPUW0fSMK8qR6PfvAbRFp+nENcXov5/+VSabPzZEGUkBZ6iYysw0M
	UxFNjY/At3rBWhvgewq/MzxRWbiv1us=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8E+Cden;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270711;
	b=GqD3819h72co+5uDuMkJUC6arut8cffIExb6sY+IeiZs7spxxrjnARVcwkfwxnilmiVL1C
	PORvKIW2AEMRhikqArXOTCK3EDtjtEkztW6wJDDBkJPYb3MpRjmFTXj2iW3xZ9g83aYFc2
	y4xxc2I1zIdcLQ/hR/DWoqC92Lonkl8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC89E60211;
	Thu, 29 Oct 2026 10:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2161F01828;
	Thu, 29 Oct 2026 10:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270710;
	bh=AEPuOS39iMOT1AtyD14etoYTLMUy392NJap8KxtSbSA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W8E+CdenzSDdHs45AxnPumF3FatOKMf8gv/+2TZlirGjhixsHG/6GJqoiygMaICKz
	 fRQsV7/5KRmuV4I3WM1BlhFfuj6drND5kRzsRagDA+8XA3v2ymwpbQM46g08Y3AFay
	 znjg7ecOfoAq0NSNXQlN/mg6qoFRidmHdYjkq9l7KGxAReBYWK6h9x6ZtwwWSuw7nx
	 sRI6MovwXTg9yt6so/m5g94v/X+lqUoIfO4oAc4UBXnlOU8rS590UTuyWcEPErpOHM
	 9tXNFp/UXX98xctwvVqWL/o8A8Ve249k8phQDGzxcmEDsZ6M6KI80u+ogxbCYALfnc
	 ejw7KACrCpXfQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:30 +0100
Subject: [PATCH v4 09/15] mm/shmem: discard whole new large folios on
 fallocate rollback
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-9-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1588; i=david@kernel.org;
 h=from:subject:message-id; bh=EsQBDFsf4HLOrrUjsCbpKGaKH12qFBA6scTqE8mNROk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4d3vldzN/NYt3nr0a4Juquurqz0Sp5iuXKW8jr+Y
 0qfS3nyO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIUT5GhkUnNOMfHgjZFi0Y
 cizh/+nOL6e5dp/JVeW7YSN//95rw0WMDDeX+t4VfmdiI+P+fDfHoY/MsTpC5XvmJxzVTKyNrSn
 UYAEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3212D140003
X-Stat-Signature: aakf3qr8uzdfypkdzfyw5p7ieetgiba6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793270711-701076
X-HE-Meta: U2FsdGVkX18eEOH1tY8gs3yfxk6hvyMPGdESDhgLXzoECcAvu43NlJRy8QgTArvByTtYdPwu6vfLhisTGS/YB1r4U/9EyhcmzSR5jzAXAPqH/gRlvqAMOI4cE4kQwPCgeFZbUz4deJ6XbKqUCzbkI6qv7dGHyP1cCLvNISyYX/YvBBw46AXlTlduMSTWfMCoPBbtNqrqh1xYnbq3kOuWCQHjTiG53SOGUwXp6Ynb9MBwgHzjQfo8wlUNSVx+0pN0mVx8s60tnchsU2olP7dp3pA4YaIX4MH7JGqDxNtNSFwtyAnl4NBRCPsgW+dsc//h/fTWfgCcA18/GO2wjc3N6FfHVLW2tJeTA0dKfT477KcvDFR1K9NcIeF8kbMNpCXT+15qlzT0crEKQjXf6JqUYMId1aMIeg9hke18YDj/pWSW0jkRKZgcHjpz5iGcw1tSAtJdPNABYNFSzoJj1B8l7MSGMa2X555g0UBLZWbQHqlswGDwr5kH9juNslTrFuKHGN/EGsB7TeEovhMP52AuodqW5kyqSzQU4LJBXw7JMy982w/zoi4iFx1ykwY8w9yGabXkap1xNMKwT4RjQIHW1F+Pr3jUcgxTnr1pofDcxaGgxedXOQdoLqSgK/pKDVXStFhMEHYWkNwFfLetQkmF3UXXoSF+D98iFQu8/bWOWPS2pUGJPhl7TANBhCRKShjMrkty1gizStNsgOy4vKt3Cv9iHNkOzX+Vm6qg1nnHW9cA6uYFQE7zCUSPRcL5MAei3VRAMl8Pwm7qBrsl17cBq4BiebcGKN2AwYi9fQKkQTieNbg6bwe4v1XbJEJpdeo11EW/nBcdV2Z7UD5tTwU0c5mLImp95gRxArNNehes0l0ffgRJcvO4CPnMPZRAGRtOugK5OJotdFzQLb48ClbirVkUeBVTp8ZwKpJZn3XTsM5FIQ8/sfUVgC8veDTDNp+IRODkxm1dzkvAXP9GJ7r
 +OOYxNR7
 nDSRKwp9byFp8LcfRFVJopjOwTXqxO80/G0sUCdlZAvKZVG5tCF8STNiXzGiSx5ZtC6fN7gdt8aR5f2mw5W5zvDRiT663GMP/IMT0oFG8RMhsRv/m30ahpyymlJmLVG0RmRFqvH5cKNUq1ezT33QU7aBxvqC6dbj2dJZ8ZZdtrLvfuB6BdAkD5FnY7iV0PvmmUxvopmCSmL8+BaPwpstLjJNVSDB/2LqP8fvNosldruonT3IYbprCVmANG6pGHJBjzOyAJK1oMD9HUPu4OozrCCneZmXeDzNQwVsUhxJJQOpRQmeEnIcFqauPbPA1Z9qgYSJgRXpHom2lkl7ZUStV0b8Rsfmb2YtyJ9+s7QHRgrbO327BMZtmrqSu7rmQH9HdEFnLeT6ArU31lXyJCOeiwCQJnxUKvRaehXYIQydYcOVf7FQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When undoing a failed fallocate(), shmem_undo_range() must discard each
newly allocated folio. Its second scan instead passes large
folios to truncate_inode_partial_folio(), which does not necessarily
discard the entire large folio, but instead tries splitting it to
discard only the requested range.

For example, with huge=always, a failed allocation starting at offset
4 KiB can leave page 0 allocated in an otherwise empty file.

Discard the whole folio when unfalloc is set. Note that we enter this
path only for folios that are not uptodate, and can consequently be
dropped without losing any data.

Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 11c3e6b1aa76..151704b2091d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1473,7 +1473,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
 
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio,
 						lstart, lend, NULL, NULL)) {

-- 
2.43.0


