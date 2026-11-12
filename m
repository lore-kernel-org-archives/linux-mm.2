Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F311606A336
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=UPVCyoPF
Received: by kanga.kvack.org (Postfix)
	id 948E86B05B2; Thu, 12 Nov 2026 09:25:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925FF6B05B3; Thu, 12 Nov 2026 09:25:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836CF6B05B4; Thu, 12 Nov 2026 09:25:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDA26B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA43DC05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:16 +0000 (UTC)
X-FDA: 85426689432.03.0F68122
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf09.hostedemail.com (Postfix) with ESMTP id C8594140010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=UPVCyoPF;
	spf=pass (imf09.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VaFyFdbYf37IpbzQa49x1rzy8WEarNi6kqPV3fC1o+k=;
	b=EbknKiBIn1yGvrmJSC013dM6khDF72x85TIYOMMf3jvGanAhvqjF5juqlxRrFrhg2JTbGr
	xwVKYu5j1I4cla0cyM6upV1mOnRiXgh6ErdiL1qDjBCmqadiFmgmSxGEDk7Q0md5z6wka6
	cOGOl2+gPPaf+B2LbCfnVv1whOMxi+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493515;
	b=CEsdBul4C1a8YTxveH6KuPXySG2AFAWdWJft63xVsAPmm9Hv8n0ifkm0VnaK4hZ+VS+xhe
	DfTHsiobP30vdPMvKuLxlvoackUn4tiTxX6uP2aicMu+QikjCREXf6X+M+SWsWz0VLRLV3
	RW3GKDUiBy+WfCZLAHrNzbl3iYbjSqw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=UPVCyoPF;
	spf=pass (imf09.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=VaFyFdbYf37IpbzQa49x1rzy8WEarNi6kqPV3fC1o+k=; b=UPVCyoPFpPOx1HTruMDeJPJUAY
	3GdeJrv2jkYlO222oTZPECS/N9JbxkFPHVMXl/JHgQU/3kYvOQM2ak0aPBju3N/qUXqzA5Jw36Qw/
	rjs81UNilNMSCSH9jpcDrTn7Jc1j5co3Xn6qhlzZ4HlG3vvzHtvZYuufgKcOGhykanoHwODBfVczY
	Znh92751M4i5i3uov7axz2/sCFt40NbS43E/w8fJy6U6VpCXEXzBFMD74+o+kwbZorXrgbmifzXuR
	C9EaWjAz7wqcIaRVEvlyYX4l2DodAP6F0827LEs0JRnlA/yinm2+JAmFlzYvyK9Uxb3oNpnaKPANe
	VQajPi8A==;
Received: from [151.115.150.205] (port=59302 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xRVjm-00000005AE3-0HJX;
	Thu, 12 Nov 2026 15:25:12 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
Date: Thu, 12 Nov 2026 14:23:35 +0000
Message-ID: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ntk3pkzb9a9sqnx4ncma1fsipd11ftcd
X-Rspamd-Queue-Id: C8594140010
X-Rspam-User: 
X-HE-Tag: 1794493513-164370
X-HE-Meta: U2FsdGVkX1+Ehb8fddkgePEQjZjCMc7uztcGVeSd0W2p+78/D1M2iJYgQVxty81vN34EBNdEgStqv90FBT9YPaGRyXm1G8Qb38ug9vePl0h2plLiJlGs9VM6mFgycFp3RrBG9lVpPjJ/pCbBGNO0EuEa7aNcr4Bkt/8kaxH6dBlo7RCzal9OQ32+iDjBqS8mpcGCeVqqQUbyWSdjALUVgQ7GAXbKSEK0CEcZHPQdWwtOFNHk/VarvL67FAF6vGVcIL+ajy1/IeWqgurq9llkZ4heWcMsYc33WTTeNPW/MRwi8cpVnLHobBAIqUcxYkkxrT6rwsJmzfD4wyX2nRXg5rRu1frLUNotTZY2C3Xwtu25RmeQ3qnHeG02f93OP2AwWZYICGS1OuVUi804wGSgxAWgN2JfANc5HJA4FN9t6dwAUWaT7uFCVYzk79zwciB9sxZE//L7naYGv5uhKZ1nnsxzy5ZRrIPKcZUUY3uFIMCVA+iJhElZ5GMpQNed2WYvDH/2zdXGXhEIg7X+fuX1jKnW+qMBBOOYbJMt2Y/kAeNuCwd1rYQpMBRQtQMfSoXf6EijVzKU/BuntWH7qeV6lkfH8kk3TI68D2eWr+KgSEN/DkzFCYSK7x8HvUg7KnEkMqIjTfQmLT+fkxtL2F/L+y/kb3QVM28AMQy12MDf+ADeRi+YCFG8ByUUvk7RBfj0Z1QFWay//vL6e8FkbwI6VdwScFjiZC8hl0xY0wlPGXiIvN0qS6BY3ulBTnZX9c211YustNoykhOxYA6OdlzH/KYWb4Qfjp2q0I0AZdNTi4hC6nTC4kNCDCfdDvYfNm46MvBwPsU9xQFt8F+teJX7VdR38e+BO9no6c8OrvUbJDC4xFb0ef/Er2VSLwfNoUUd+QAruU1YPldofyBAMEEcVS2z6wBdJryc6gUm6S+Oms23cMbF7aQV+gaQYhHTTByTyAxxCrMWUafpwBT9USP
 BhvYlMtP
 jvUdYlx+riPTuEggCRVQVB1gf/1GBl84mu8iMD59uJO/eUSAtKMVS79EW6q233iRA4l2xz5RPuQIHMav5rDNPttYy5e4Nlu/lwx4N41HB4ddRiZsCueSn5UoRTaaTQUypAf3khY4LhAlyPYJ4VIgedQnV76pDed3+Xob1f7zvdLG11xV2SC25WHhNMkgFjWmncwKomWqBhQXhvLvPlYX7hS0OpekNvdYvZwT/hpwYRb822Vswdopsac0EMjc0o+ggcLUpU1HaRETKso1fS9OlHr0O5wQ62m9lp1mziVfJd11DrzccqlxhBdtByFYfYasrl8obPkfnLEIrJUzNUhWbbyfDNh2YZVeAcC9EVZ4ERCkQss3Rz1Zo393WU9KKoc3ZdZ0Snn5+Cybznc6Cmf8dln/eAurrn5EK8twuzQbAFg0qZ+SIw9EpyZG6cCqRKN/NlruM83QdqX//vggXvVZ45nJycTLqy+NZv1kjfNquua8QegPEEEvzK6h1pb6E7VotinpC/1aE94kLLuJubuyvQEplEI1LakNQkta4bOQHUbcT1JpNv+aA1vWAXfM7Y+qWv+KXdxJFAf5/z2Zo3NbEsOkcsrDQnHtyhBDipxOb7MxP7gClOjcUPGQJ+SpO1/1f+fWKz+zydq2C5wXGzCrpmWErgHHgQgZlq4t2CpK5vvi2DlQ1WKDgqrSaabGpiJlL2DYigBf1FYBWDK5lIiuCtUgyyr/UQoqxzm23
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_COLLAPSE lets collapse_file() treat absent shmem pages as holes
filled with zeros. It does not check i_size, which allows one present
page to become a huge mapping that covers the whole collapse range,
including pages beyond EOF. This makes those pages writable. A later
file extension can expose their contents after F_SEAL_WRITE.

Hold inode i_rwsem in read mode while collapsing shmem so i_size
cannot change. Reject a collapse if its page range extends past
i_size rounded up to PAGE_SIZE. Keep i_size_read() outside the
page-cache XArray lock because its 32-bit SMP reader is not IRQ
safe.

Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 mm/khugepaged.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4bbe319..e20416a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2251,6 +2251,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 */
 	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
 	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
+	if (is_shmem)
+		inode_lock_shared(mapping->host);
+	if (is_shmem &&
+	    end > DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE)) {
+		result = SCAN_TRUNCATED;
+		goto out;
+	}
 
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
@@ -2682,6 +2689,8 @@ rollback:
 out_put:
 	folio_put(new_folio);
 out:
+	if (is_shmem)
+		inode_unlock_shared(mapping->host);
 	VM_BUG_ON(!list_empty(&pagelist));
 	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
-- 
2.47.3


