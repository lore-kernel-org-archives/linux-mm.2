Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D992C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C836B00A4; Tue, 15 Sep 2026 11:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF1C6B00AF; Tue, 15 Sep 2026 11:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8FF6B00A4; Tue, 15 Sep 2026 11:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4F7A6B00A4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:24:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A4811C26B0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:24:25 +0000 (UTC)
X-FDA: 85216368090.28.0E58E3E
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9005280007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:24:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gk1a+vrr;
	spf=pass (imf02.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lui8iyV3DDVNmQm8D65uj/p2PuGVb76pdc3dJpjd7Y8=;
	b=0GxUaVZw7yPQBQ2RdobzX/3xlOH6VcXyAw+wzGUI+gcVY7qzMoV4l4Ob1xNxd3MKa7dB7u
	oIIDvo/AkU9iJv27svg/PCFz+63fdtBGmYEDo/n49lTt+XYqeDTdzpA2/vEk1ZXJ4iVe80
	V48CkEZ4f3u3ww+ZtgFSE8w/nYJqE+8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gk1a+vrr;
	spf=pass (imf02.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485863;
	b=cIcQPeOpa6pRAMwjqQEVooK6HDIgx1VUnTaEpwaqjpxpJyL8alAoojzpcMIkDgDvPY7buP
	8lkssj8Sks+6b0Ki6iu+e85n91BfRjnStdr0JQO860aMD+gnL9W/gGzrFb0WqQV/NBvtDy
	MefoI6IXH+txQNxyKdeBzsOlmEMwx78=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=lu
	i8iyV3DDVNmQm8D65uj/p2PuGVb76pdc3dJpjd7Y8=; b=gk1a+vrrTtfPHmd209
	6hFGKDVUc5e5Yne0GLxPkE+vYFabklkvn/0wuW7dUyPBOEezHOKXv+CFTKr/igQX
	iV4g5yRt8tEIUt3YeI1WLWICJJnwHpjRVOAdqkEqEdkLB1d5vdoGMtGPJ6oEIDCG
	WMRmfm8ScH4vAeQ2Iw2RPDBUI=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDHvVwYY6lqm28iAw--.18968S4;
	Tue, 15 Sep 2026 23:24:09 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] mm/ksm: take the ksm folio in try_to_merge_with_ksm_page()
Date: Tue, 15 Sep 2026 23:23:49 +0800
Message-ID: <20260915152351.7955-3-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915152351.7955-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
 <20260915152351.7955-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHvVwYY6lqm28iAw--.18968S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxXw1rCrW3Wr4rKF45uFyUWrg_yoW5urWkpa
	n7KayUCr47Xr45ur18Ar4qkw4YvryDtayxAFW5GwsIvFnFqry2yF4SyFy8Ar1FgrWrCwna
	kr4UAF15Za98A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jDPE-UUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+Bnj3GqpYxl+GAAA3B
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9005280007
X-Stat-Signature: 1u3ndd3qura1zbwimu34541q5o7oapu8
X-Rspam-User: 
X-HE-Tag: 1789485862-365412
X-HE-Meta: U2FsdGVkX1+gOWpD8WFe0ZNpXpFKIiN073v9K42BHL+PGyWS4kQtfyBuN/RyXxEUTmWM8/fhhld7bUyPhejVTHNdHd8PPE9Wo0KzLMcg6dNbCGn5Qivg5Mmqj8hk87SGuJEMpjr8KfunEf7HlgOK5y3pz34DDD88VZ+vBPUIJTd0AvLYs/fBQq8uZC8JSEuqCcvKP8yMF8LjiIT6Uk1SgkPeArF70ebwq2nYJTEgjbWahZXZvbmaFrVamj1m+ug4cj+j1imfuVHoH5lnqEsSdMnkI3jt6qLM+rGxt5TYiqSYQuGzqQMoQVy7n8lpBh2A310oDaWYrwmZJHzrZHIbQdRRWSJ6JaB/AJ2Pcx8g1qSvQyVQ6yafdjXeaR+qrnRWwbuYit2FosOVtf2g/zEIMmWlIOO8cpG85o5NtFavQ8LJ8O2FXIHGLaM0I8oen+ehyLCGoNradAY0TrbmJ19dx5+AbJn+4As+/Ef3nVgx9ezhXBN0OTRk5MD6ofuc/O2dzaw40I89WExs1855RTp0zBmWZK0NEwfxddVinqF+sFzWFEiCsVAuDzsxwedtTUuciM3x4G7FltaLccfS7w1h5dPOSdzvzLl1qlRW3uLqOb3LY2RmzJ8NbdpYoVzINnZxxBZYi7L95flxHmlDov4eMESk0894ug9wzXEH1iP/aGsgQH3rqh4eXLiXMA1LcgaiidTURRb3QOh/u4xA4Zvze4kUTTGLEOwds3e3cgWXIvb1x8CkncanbX5RQIQA1RPG75RKXtmiHnW0gF/kzxOcpPVy8A9PNw7CdQYjHnR0weokCPIHip2igWZRnDIzVXDKm0gj4e1aMV97X4ACmrd/X4luX+TO3pGC4c/lbqbTr1v1EAdwwSxBbG/z27aMFamaL3voTSNtI+FpvqZi2ubUdfn1KKh4roaDpeVS+UKT+a0TjFR2bAwfXndYCW8aM3eO/YpcCEClPAT7t8ZIQUI
 60E+TdEY
 qLQW7wv7ku5Jql6mkB4j8DM7alQlui9as6+6T7e0BJOSbcngQQlkhcfvNpbOCxem/Z0bX6jJnij5CVS560LAQW/sT3SmwEd+Z6QeI/tLuK6LUsKUJi4PvnW16+sV7mVkY9Xl7iDUfC+1A9CftEEcKa3GDpTlKAo/Rtoyur3GkMg5sEUwdtHD3dxY6xj3hP//3iSGg/emlKf4jCWF3gm4Wz+WdLsbzfXcaDmsqxeut8dJM5v04Zn3tyBXWneFWJwug//Wetn1Cc66N4erVqXOL5NhmqAP/ZtwkgBqo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Pass the KSM target as a folio and rename the helper accordingly.
Preserve NULL for the initial upgrade of the source page to KSM.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 10fcae7132b1..937d1ffea4cc 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1661,13 +1661,13 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 }
 
 /*
- * try_to_merge_with_ksm_page - like try_to_merge_two_pages,
- * but no new kernel page is allocated: kpage must already be a ksm page.
+ * try_to_merge_with_ksm_folio - like try_to_merge_two_pages,
+ * but no new kernel page is allocated: kfolio must already be a ksm page.
  *
  * This function returns 0 if the pages were merged, -EFAULT otherwise.
  */
-static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
-				      struct page *page, struct page *kpage)
+static int try_to_merge_with_ksm_folio(struct ksm_rmap_item *rmap_item,
+				      struct page *page, struct folio *kfolio)
 {
 	struct mm_struct *mm = rmap_item->mm;
 	struct vm_area_struct *vma;
@@ -1678,7 +1678,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	if (!vma)
 		goto out;
 
-	err = try_to_merge_one_page(vma, page, page_folio(kpage));
+	err = try_to_merge_one_page(vma, page, kfolio);
 	if (err)
 		goto out;
 
@@ -1697,8 +1697,9 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
-	trace_ksm_merge_with_ksm_page(kpage, page_to_pfn(kpage ? kpage : page),
-				rmap_item, mm, err);
+	trace_ksm_merge_with_ksm_page(kfolio ? &kfolio->page : NULL,
+				      kfolio ? folio_pfn(kfolio) : page_to_pfn(page),
+				      rmap_item, mm, err);
 	return err;
 }
 
@@ -1710,7 +1711,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
  * pages into one ksm page, NULL otherwise.
  *
  * Note that this function upgrades page to ksm page: if one of the pages
- * is already a ksm page, try_to_merge_with_ksm_page should be used.
+ * is already a ksm page, try_to_merge_with_ksm_folio should be used.
  */
 static struct folio *try_to_merge_two_pages(struct ksm_rmap_item *rmap_item,
 					   struct page *page,
@@ -1719,10 +1720,10 @@ static struct folio *try_to_merge_two_pages(struct ksm_rmap_item *rmap_item,
 {
 	int err;
 
-	err = try_to_merge_with_ksm_page(rmap_item, page, NULL);
+	err = try_to_merge_with_ksm_folio(rmap_item, page, NULL);
 	if (!err) {
-		err = try_to_merge_with_ksm_page(tree_rmap_item,
-							tree_page, page);
+		err = try_to_merge_with_ksm_folio(tree_rmap_item,
+						 tree_page, page_folio(page));
 		/*
 		 * If that fails, we have a ksm page with only one pte
 		 * pointing to it: so break it.
@@ -2411,7 +2412,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 		if (kfolio == ERR_PTR(-EBUSY))
 			return;
 
-		err = try_to_merge_with_ksm_page(rmap_item, page, &kfolio->page);
+		err = try_to_merge_with_ksm_folio(rmap_item, page, kfolio);
 		if (!err) {
 			/*
 			 * The page was successfully merged:
-- 
2.43.0


