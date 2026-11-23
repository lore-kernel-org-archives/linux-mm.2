Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E31B606A338
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HBNjAsOO
Received: by kanga.kvack.org (Postfix)
	id 4B81A6B05C6; Mon, 23 Nov 2026 11:33:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5D46B05C7; Mon, 23 Nov 2026 11:33:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D8D6B05C8; Mon, 23 Nov 2026 11:33:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F33A76B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:33:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 887C5C0971
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:21 +0000 (UTC)
X-FDA: 85466929002.10.C585765
Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	by imf09.hostedemail.com (Postfix) with ESMTP id AFE1B14000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HBNjAsOO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451600;
	b=Wip0H5x8IFEX2+97BlJbzsCQbcVMP/C+XHw8JhdYA5L/OjPreJg8zrBPq5NLGtvCpy1Hgn
	bjJgrJb3bw3zmrgWFmzK+EhDDoeX4vCGmeTcovQIKtVNlttnActLvUUHVhjNHfQcwmHFng
	RvWoEOKdnz0MBIokLJvoY2NBPPh5zDg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHqXIb026uSXJYBJhjPjkt86/V6MV/kI2DuMRyyjh6o=;
	b=0UndNd70N8ls023Wn+mn2HR7QQM+fpPqO5ghIMyreQLGRY5oU6ZFv4bW6saSGxNIQN7jZj
	tjBoQ08lFZyrN3KP4Vg4TRVkREVvtR/r/n16IoyvgVzXO5RPCbqdKziRk5Vr95hsXwkYV0
	aSqY+vc8Bh1f81RtnUJgN8UnAZ5iPyU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HBNjAsOO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/0wwfmfO3rHlK4K6Y0qZ9SSTUSTnaQnx867yqHOwqOQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795451598; v=1; x=1796056398;
 b=HBNjAsOOaPHvdroCzQmNe6NTzDbrPQpVhzQBiXl2pjpCuUueWeUfh3iXjMRP7seoS+zpOfBX
 w6tLFKQoxsSRcZM03lqSsACdSzS3Wiy4H4wZjHNRT/0LubEl444am3rmwfKDBfDxu5d70or3z2m
 lCkOfMPBGODGQW+npAwtbBKE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 82a19ca6e1a70be8;
	Mon, 23 Nov 2026 16:33:18 +0000
X-Mizu-Trace-ID: 82a19ca6e1a70be8
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 3/5] fs/proc/task_mmu: read the PMD once in smaps_pmd_entry()
Date: Mon, 23 Nov 2026 08:32:09 -0800
Message-ID: <20261123163301.1568240-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261123163301.1568240-1-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFE1B14000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: t68buunhucwjcaskczz4smsdnz9wbpzm
X-HE-Tag: 1795451599-863570
X-HE-Meta: U2FsdGVkX1+RFQnwkCvB1kMub5RaRmDSya/BCBMvGnFhAkce6BtceTLO4gb4WKitbvxalt8j0LjBYt/x7haoF8A69DxkG09fALPkHEkfQV0Wk4SRMgq1eZqLQiI9cZOYezSwa/BeU+xGy3pqM7p9ZF8gfDQ5Z4ODr+Hbdp/aNt8iwtM9siMVdn7iJNR69WZ/Mu5PcK/eedzlJUfSerzRkMrLPbwTxXsKdn2aZ8WdAsu6LdAlsHwmamqwxpP+IDTcngR2GhGjj3APZnkgZ/tjvyALKre5eTkWW69e2lRchAv/mrv9fKEaBHK+aC/AlQix4j1PJjYVhHhVow4ojWCHkqQq/upLHI+1pCu0UOpZDJRC5TxI6Fsj7BOwKdda8hVEdlPc21mOUZqI0QI9oqdUAyaDjotciEkBi1Ppq6CCp7iGUr6wSXVukEHLEpNyGT+rl50YIlOJpfJNFD8cZnUBHEbxBgShLjJluxwD8rbCRcpy7PQy+f1oQL5NVuokaR2/XVMSoFXmtCho1VPqJqEtqDR+Idc+LGB7PySwARbgniFf1I5MaNyI7bAn0wdTGO140Ui7VmsGRHapZHAk5Rcjeo+CcCMbSJAqY9Hly/FjdhljblzLqMHa0K2aG5uOGLDOvI4aCOVip6VaQlhOzCuCFwKSqUDZlh4AElivo5jTog13zLxgNRFMx3nY38/1wLrEIm94H8I5wvYOKeCcUShKiKX3BbULod6qRxhH1mOQRiOUNqtmZwouFlOe04rQVHvh0wdSqV3PkNRBF9fNj4kblom8n4rEJF+91gWjh7ZPQp5juCQknNQ4wi0zLoZ0jkt98Y5HInrxY02Adzfc18II6wwo6wvNR6Kuc7rkEws5oL9N4FHRjhHvylS1kZTWBflSxF6/FGjEQtjgOvoksLMLnGlkpFMhBGAyrsXkbS3EaGFNZ8cwpK9y+lQMlhBPKRiPgVc2D+jQBrnr9YOGUTC
 tZvQAYAN
 mmINc/aqKuKLy0KDkTxfs/EpcBPZJM2kF/VjDY3az+di5iehxubsz4M8o5FfaDQM8wdsHw0EELhj91naDspQWgOZRVm12SjO1KCekiEKs7qat1UJ4c3jVAorfh2GEVan+Ro94P0OYk+Q5BugNOslGxGHrLG6b8gnyO6s+9dhKZf2AX7X9jry5U8X96tc7g0w0YACDYMiQprrekSSP7ZPYYo75NK9v4Y452xLr7E7IIVhD/UkQWldtX/rgxH9ymjI1fLTBl+8kVIhC9rqiPDKdmu8vj5sldkGQCxo54oOqFJszQYbEiTJnNIZCVykA5vbLfI4U4N/Mv6ToLMDX87XiCVki6eBX7+YXwJK7SAH5AJ1VPc+m/8V39M1C0Gxt5YYTgR2jgTrz7IoNHCNt7DU8H62jtoIRdyaicgEmukZ0V1sKhWA485NaaJaWSXvwdHBAnp3ulBBDvG05Uj4/eXODnW4X/T0dD+4VRh4Luys/B6bVj0NcRJ+9fPvCr+OP9OSKTUhvedUKjcZQVHTNOhkz61MkTLXRfTZ2+j/DQexdiMOpeAvp4HsF4hfMePPGABK+aO5U8mFxI3EVgQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

smaps_pmd_entry() dereferences the pmd pointer six times. Read it once
into a local with pmdp_get(), the way smaps_pte_entry() already does
with ptep_get(), so that every test sees the same value.

No functional change intended.

Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 540c936aad4714..105c4998eef48f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1022,14 +1022,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct page *page = NULL;
 	bool present = false;
 	struct folio *folio;
+	pmd_t pmdval = pmdp_get(pmd);
 
-	if (pmd_none(*pmd))
+	if (pmd_none(pmdval))
 		return;
-	if (pmd_present(*pmd)) {
-		page = vm_normal_page_pmd(vma, addr, *pmd);
+	if (pmd_present(pmdval)) {
+		page = vm_normal_page_pmd(vma, addr, pmdval);
 		present = true;
 	} else if (unlikely(thp_migration_supported())) {
-		const softleaf_t entry = softleaf_from_pmd(*pmd);
+		const softleaf_t entry = softleaf_from_pmd(pmdval);
 
 		if (softleaf_has_pfn(entry))
 			page = softleaf_to_page(entry);
@@ -1046,7 +1047,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
+	smaps_account(mss, page, true, pmd_young(pmdval), pmd_dirty(pmdval),
 		      locked, present);
 }
 #else
-- 
2.53.1-Meta


