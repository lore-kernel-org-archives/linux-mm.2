Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2842606A328
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=ShpT2mht
Received: by kanga.kvack.org (Postfix)
	id BF46F6B07A1; Wed, 21 Oct 2026 16:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6876B079E; Wed, 21 Oct 2026 16:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66526B07A1; Wed, 21 Oct 2026 16:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70FB76B079D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:36:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 783071206A4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:36:29 +0000 (UTC)
X-FDA: 85347791298.21.71EDC22
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD685160003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:36:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=ShpT2mht;
	spf=pass (imf08.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbceIaRF0sAuckuiO6cyxQdP9/vX0G/uVvpCY2YPfrc=;
	b=EjMhNgF5hghsV1sAPo+T+DUe4YPVuaq0W92tF5Fo7U5GbQtfIwAkg/yzsAwPRMC3XiOnz7
	jVPc0mBdAGa5ROFC/UNhFtOHQbspFa0QQ7REBJSSoRXOzOTbWLsseD+Gt4ebYnNeQXjXZP
	dx09GaDa65mvL3oyGi2r0li83e2yRFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614987;
	b=ohkKJNzLSw1V/c+ehD3NjW9yx//kDOPd9qdnfShnTfdVybEFHcXFKmbV56bMceC06znC2R
	u5NGuWqnbhuq6acnD9y6kMviSYUlPk2aMOs91ySmib+i15OKZGLgHBWG1clR+gb1BDSaEf
	xc9YiPN+MeqMisGlS6IIy1FBXy1jYRU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=ShpT2mht;
	spf=pass (imf08.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=tbceIaRF0sAuckuiO6cyxQdP9/vX0G/uVvpCY2YPfrc=; b=ShpT2mhtcIjao9HMfss
	jXF7S4rKU1qxrdXq/oerjb+AA9xKx86xQW4rVJcpTdwN6GZi3Ko03fok6bTdeQmb9HLFJhC/LurPW
	1vQvll05taTdW0NaVp8f8eYgYZe+1epvUyhyliWeJsPezDRk3ikw09d6PCLoOfsOIvbJnLtepWDc7
	770hBdGBt5KnoFXUorGIvPN4bqx6So+zy2P1wOKtrmnLIHwIBZjXTG8O3dnlK/61VVFjzmJad2pU6
	uuZzEx1oTR8I+jU8m2RTFniKH0ugGCrSddrm0qHfJ1vCBbLSvq8/mQ5Qr0H1zCbcujPoWNMgHY7+g
	nBKgoTqn5gaSY7w==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJcz4-00D9zC-2y;
	Wed, 21 Oct 2026 22:36:09 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 21 Oct 2026 22:36:00 +0200
Subject: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1546;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=zhntYNSyNOhAa1ZPHwaiFUV3wOk6ing6WAMJ8CgrgUQ=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2SI3kTt0eGcvGYVZkf1nokMQHDfejBZY7fajV
 0TyI+y7YxiJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkiNwAKCRBRlgpH+WFc
 KgnAD/4ojtuF4NBnUvfl/Psk86uzqUN1kVtoLEKMaMThvlqW1s3hK5DewNJbbtEf8Kazy+pGsy7
 2MNBKYRUNiZDEhZn/2DHUE1gt+A1tVbizNXBa/MWAiM0mHN4ngFsKzIt8G4YzVFPRIiFTv47n4W
 UzZ9V4zYqU+0s0nv2SkSdgabyHn+IOd37dsdB1FOWbqkMfFafvXpi338tn8jdGLrv9NurDGPBXa
 JZN7A4rUTj1hDfc6KXc2+NthJvKbdfaeHECDDIrCgp96JMX4YtV1Oq6Vo4PNsA+spLXB6gm22vs
 bt8zKJcN2+rdAim5R+CHKro0V0Fp0XAZp4Xj82XaDXiCzDfPcKc8FDuP9RDDvxj6RzW+X2RIO0E
 612Fj+ImIt3/D5SW82Dj9MLXESvv7BYtG4DMGFZ7XcgRqlHZpzwiWRnWvsGrxcJKt2wKFFMBlJH
 cuLulc+7fr3I4ndV99zx4sbup7C77YzhIsIspwXhd6cDjs9nPaznCZrSIcs5vKegskyHFrqx+Db
 rqe+t05922C0eCwL1UxqL2hupnKSl4lwMd1mwvKy9yhaHtuSKLRavqalIHyXq5zh+tUCFdTvAP+
 kEDIzV2/fARqYVLPRiGeTeSch5+t8I9q8grSh7VIqydeFZPMIov/cihVtwGD8oOVUOK0w5eQsBw
 F++lxfRANMnnNdQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD685160003
X-Stat-Signature: umm9th8hjn8mjr6c1pwt736qz8rsfwpy
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792614987-852329
X-HE-Meta: U2FsdGVkX19/HeEXSSkigdSxJZVEjL3IzD5Dpr48IAfX7gKSnYfsMzpF0e/eqs2iLyGhZIPO5HjKIwZIojVzACu2dBgfQLzivUNBk6VgIsSP/1AG+/OUorpOKyOQ9bfyE/NIkKBU9wRknJ1jCrYlC4qYgEoePiB6kTqTsI1PDKmH9vcTYrOzZCaNwbU4YGNBX0IhItis48bIagzM0P55hmHcDwJMs4B8jeNqRj+qG9WJEeHd2jT/WQeBJOq22iHkqzHRcLWOwytCnsymDaokPK9UjcxIr7PZq/8cvkl8yR7Z60eCOUemzu21ss14QH0e5Ad+92YQxj3caFswsPZW1Kdl38U4JVczgvj9sYHcHCymJnMrkfNof6xZW2cupLunm1O4ouv8+SviMHmhqwdMxaQkLMjSqdrP+hMaylWlLKyhnQ2bcv8wknsvhxtzARUm84zbXQsf8BUfR45MSUpWwYqAlF2aWjFGCw0QAKfo2txN/+Ivo19GUwVj5oRTZ+LHYd8FpSOfOn0hgqeRIp4WhOupkbjGwQc9nDnqztDUPnWy5ZH5lAvGUPIE5XQFxhSsuWKHAahohqlPC8F+aeUamgOzs4a9AdceMeVRvZjcT/rcpKBw4v9igRtoexXeGIj4RlCR+XB/9ZxQDl/Ihx1P7WtNrSBx9VeCbYiM5+fRb9RFHzUlpD4/zOHbuceVTYveve2A/ESreeI7PqUzkmYI/5Z7vibzDdTq++vqXKkwGVaT5R5OPhIIFbAXURkqBZsucROM+PJvJi+aGBWglI43MFdeD8An/2p8R+CtENozIeDvU1qZhgCs9lavfjELGImdNgiYGqODHTdd7JktIXTHUZFPAKZrVouNFkhVWZaNQ5RUSV1SAkyIRWbtKZoQfSiJuBaZIZSr/6ulqK/4txD1PDq1Okspxij/taPzbtzKtUUAgMHfBnEMkzL3vMMo72pMYbSuLdI/DHgKNAtIRYg
 tnxklFAQ
 UJ8IRVMOKdtLgJk2bNBLll6OmWPhtdm8ec7t5q6vN+xClu7uqlhS/SdGFJPNZgHRhVP5hAxewXJQMyBf1Cn/b/o+ukYHERP3yBNXqFo0ZiRyfHc7mwWv0IerFlFWPlnPyhsrpLGS4vGEygXOGIVRHM8LUEwCotSqK4gsKq7njLI0GppXhgiE5ZUL3WXpfPgBbib6P8qUz+ERpUxe8E8PaNI1jFklsA/0jPHlr925z/Ik0mQnuSg7PQ1PckDXtItMoDxautFOBh9pYWLBNCoYupJmEktiEwzd85Sac7tyEHeYMygIrpTGYj9K4Gf6Aj/9N4GvEOW6sMg3Zm+pvP6Y0HNYj2cYr91BPv47bvWzcvsX1tKeVJB1fo9pkXuWfyV7Aq+LZ/GulKouC8ToZYbneGisJgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
__folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
PTE mappings to the folio instead of one PMD mapping. Each unmap of the
PMD removes one PMD mapping:

- the folio's mapcount never returns to zero, and removing the folio
  from the page cache reports "Bad page cache", or hits a VM_BUG_ON
  with CONFIG_DEBUG_VM;
- the first unmap already counts as the last one and drops the
  PMD-mapped statistics while the other mm still maps the folio;
- the second one drives the entire mapcount below zero and drops them
  again.

The helper has no caller yet, the next patch adds the first one. Pass
PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.

Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/rmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 0b332770abeed..7562017416094 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -558,7 +558,7 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 		struct page *page, struct vm_area_struct *dst_vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif

-- 
2.43.0


