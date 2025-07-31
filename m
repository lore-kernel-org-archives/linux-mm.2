Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81721C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 14:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B146B0088; Thu, 31 Jul 2025 10:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52F86B0099; Thu, 31 Jul 2025 10:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C900D6B009A; Thu, 31 Jul 2025 10:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB8EC6B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:44:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38A1A11441D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:44:38 +0000 (UTC)
X-FDA: 83724831036.07.0700303
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf20.hostedemail.com (Postfix) with ESMTP id C02FA1C0003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:44:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/wWLwah";
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753973076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KwmrqbSf7mTR/+21Zla87nvsbJbCKiZvV4A2gjomjro=;
	b=vD59R2QdpaYNxWIHqmjavwZ83KH+F3Vd2OqeKXXDVduyR6/jgslh7GxV2Skx3e8uvYlKKm
	4bL8E0DgQyYykn0fYlCAETL/1M8MreHdA1NG2EGOPfwGAJXHVaiqcHEQm+95DKuVRbQQsh
	5SSTx43EfjDnOTnGLGjhbabkcCVMSuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753973076; a=rsa-sha256;
	cv=none;
	b=hKUd63skd2JMn6ccNcPADvEJS/jDgtByxlLOD5/MqojhHOyxvyxJhZdqJlW/lJgPj4Mbw0
	Zz1xOFLQkZ0UgShiAiAoVhFyei1Sv/1xxieTWZDhsaFySCOBOI/EFoIIOO+0lx/mdYHuaZ
	DJ1VKOx32lWn1CLErR3iyqrDLE6h5Dk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/wWLwah";
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 184FFA55410;
	Thu, 31 Jul 2025 14:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C579C4CEEF;
	Thu, 31 Jul 2025 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753973075;
	bh=uO6JqQZIr//xPPdRWmqTk0qzriWXeePZU1lNA+yO5hg=;
	h=From:To:Cc:Subject:Date:From;
	b=Z/wWLwah4Li5c+pfrKApTo5VXzHxfARVihf4AGVCD3RuuhwAj3rtImIwXRqVIk9VJ
	 bSzQcZRYsrg7fZWOcGarXnwD2+cP/KgFD8iq4ox1wcHHZoK4FD/dFa6oxFwn4yaScL
	 rzSEL+bVcdeNocSoqrv4Ci5FRk5Cs06R48x8otlYn5WKb+ZlXz74NwJ7htNa5HFk2/
	 2eDV/0CUMiZ4lbc9gY7W87l1urHZP0Wx3WrrFwnFTYCefnowfIWbS3p8Ab9mtR8oBl
	 hRbmX+v9wQbuguQb7GnHUSL0hZV8GsOUEjtUIOEGCMDmnn7GUQTJ9n/pAIzhOT/1fJ
	 ZrwIrY/rhClmA==
From: Sasha Levin <sashal@kernel.org>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH] mm/userfaultfd: fix kmap_local LIFO ordering for CONFIG_HIGHPTE
Date: Thu, 31 Jul 2025 10:44:31 -0400
Message-Id: <20250731144431.773923-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C02FA1C0003
X-Stat-Signature: tccnmzjhykw3f38bbqzr14xp7mmuwphh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753973076-507220
X-HE-Meta: U2FsdGVkX1/RYPFBdnXHJ2tZ0shocHb9zAPMAp+srQ7VrhjQir832FjZZ7VWsWI1uDdIo9l736n1q5XuKdSOYRCWbbVxNuOs8DkCkCgFENHiDk/Rq+H1D6C/A3yxJzg2Yz8GdqSrJuuhcGFF0ph4dJEF0PuQVduUnIFj7p181l01FEhAN2Hw9qvGkAvcp/IDs69yeeOF58dE0pn/ghgv3gD2L+mwln+QRAuE74f22aYoJUDoLHDdlCPiFramsWjOAbs6+7g2cP2Jiyzcp7ntg9pKscXvG/Pb6aJxviNbATNZjkm+guYVBLf7Ell/Dv8RDvwj7FuSGcsnrdBD9Eafu89UdN49xOzQZYSePpsBvet2I5byEL2BsxAVwS8EaDDaU6VDQixsL9wRu0ORqwmXOX8LDhufKtQgT3sdXWROns/B/5kXg9qP0QN9+BGWmvhHpDaZbCWXHLsV0UlCshSkWPOOnKnoUDopUSVTwjC1VK3S4qwNiuZKB+BqCnkhDEzoimLSO1JA9PdI31eZridgm84GqiCe4KzHDL4hPxC7FCiNUUkLyJhq1JhXtTkHyZI2hb7ecZDBbHUXonB6++eqkhw9cc5QbUwLmfTf6NhVUWYXncJd6TOWzVU48b9NwR4rSUleXrx76T0yEMMIYbPmwsROKLv7Jxlqdn/wef4FEEzKyUjbS+capwekIl9HQVgN5jk0sWpqZLQmuJaY5nKRbALCKST7IoPlr+qEfXveaBbOldrGJreBKJSKD3jwpFpflVsuktkq9LXFP6HAWu0KWQgJ7n4xtgSRigmV4/DYgSoDIk/QWcDmKz5agM6eXepuTJXU8GeCiVYMmCy9yT9sZVF9qkKT6Dr6hc71FVfKmCM4F/ZJudWXCaaURO3XgKSHQS6r1uI9Amq+uCULMACaeQ2j77HyPwvz38mCNlJiiba9DzPZ0w+NKBxIJHAvv0VNLG1e85GhZkQ2wZ4ldN2
 haAluaXk
 GO5N57ggt6gayiQxnNK3KhppgcIXfFbYGkxg8sE13UT8w98uQGh+/0C+fjyQ48bKobtncW/y6favw6GdAlmmjXfnlQMus7QV5iUakAby+KwRVE4baiX+lSKOrseFEd6OWp7sm6JAgEXCh04RaCmAF7n+wS7k9R+SI2V9Rlr6WbgmmKwxroVSkBg9PBGH6uw4ypQsOi7S6jSEUQofw+iqU2zO2psn4hEfmSPLdzrGRLWjY1NLogtq8o9Eg3TIEws5UNED8mjnXQhPO2kJ2mr3LHBRmPJHqyBIL1l3ALLE+iHJqInAXVE3nkIbvFqpvG9n0g/Si
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With CONFIG_HIGHPTE on 32-bit ARM, move_pages_pte() maps PTE pages using
kmap_local_page(), which requires unmapping in Last-In-First-Out order.

The current code maps dst_pte first, then src_pte, but unmaps them in
the same order (dst_pte, src_pte), violating the LIFO requirement.
This causes the warning in kunmap_local_indexed():

  WARNING: CPU: 0 PID: 604 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
  addr \!= __fix_to_virt(FIX_KMAP_BEGIN + idx)

Fix this by reversing the unmap order to respect LIFO ordering.

This issue follows the same pattern as similar fixes:
- commit eca6828403b8 ("crypto: skcipher - fix mismatch between mapping and unmapping order")
- commit 8cf57c6df818 ("nilfs2: eliminate staggered calls to kunmap in nilfs_rename")

Both of which addressed the same fundamental requirement that kmap_local
operations must follow LIFO ordering.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Co-developed-by: Claude claude-opus-4-20250514
Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/userfaultfd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8253978ee0fb..bf7a57ea71e0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1453,10 +1453,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		folio_unlock(src_folio);
 		folio_put(src_folio);
 	}
-	if (dst_pte)
-		pte_unmap(dst_pte);
+	/*
+	 * Unmap in reverse order (LIFO) to maintain proper kmap_local
+	 * index ordering when CONFIG_HIGHPTE is enabled. We mapped dst_pte
+	 * first, then src_pte, so we must unmap src_pte first, then dst_pte.
+	 */
 	if (src_pte)
 		pte_unmap(src_pte);
+	if (dst_pte)
+		pte_unmap(dst_pte);
 	mmu_notifier_invalidate_range_end(&range);
 	if (si)
 		put_swap_device(si);
-- 
2.39.5


