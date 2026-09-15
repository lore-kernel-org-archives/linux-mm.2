Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE20C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4490B6B00A7; Tue, 15 Sep 2026 11:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3856B00AF; Tue, 15 Sep 2026 11:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9F06B00B0; Tue, 15 Sep 2026 11:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3B56B00A7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:24:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54A8B4046F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:24:28 +0000 (UTC)
X-FDA: 85216368216.25.19B7227
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3C1D1C000E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:24:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LaYhjaMQ;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2y69Y0OdCOmdac9UFhhuRQleCsaQRsPBDc468BBCNVU=;
	b=wu/oQXaN3YTfxEWrFROHPIkQx5u/rMioQBmKMBQaxR3FCVgQo6/Yie9MlswaDaDMe6EQo/
	QlEL883ZdpxSp0htq7QtYN4OJMx4/52H3BoYrAk28Pb5ZTktlbKCLslerm2iEu1lNEqFOz
	5MunjRMStqjYyIInw8wC5KMQ9cSlekw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LaYhjaMQ;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485866;
	b=PoKuL0/x8jIGQNNNw7D1c+XBK4MU8OkBvzn9AF48oOuHkOR5bRdL5+nWaOla+KkkIafIva
	GO+IpZNhu4tigc6jO9g0xXfBzc+xQiwVOmlpRXYRE/EXigFIkchg5iHUpiRhlGksYZAFcC
	gFApfs3pURDeVSAHzLc3P6NAu7tqO0U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=2y
	69Y0OdCOmdac9UFhhuRQleCsaQRsPBDc468BBCNVU=; b=LaYhjaMQxahAszyxRP
	IP8O/nHjLSH4Kkt7ok78QfYW9xBijQWBDP6LSytr0vB0X521xX15evJYuEyumkYG
	O56GVusCvyZ0/rbdbwrTm7OMYb/IsjnClD+R7veAP5QVoUbxyCMRUCqMVYNLBVWS
	CNebuEgRLaCFkHg4TyrWg6G3g=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDHvVwYY6lqm28iAw--.18968S2;
	Tue, 15 Sep 2026 23:24:08 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] mm/ksm: pass folios to replace_page()
Date: Tue, 15 Sep 2026 23:23:47 +0800
Message-ID: <20260915152351.7955-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHvVwYY6lqm28iAw--.18968S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJrWDuF4UWFy5Gr1fWw4fGrg_yoW8Aw4UpF
	4kC3ZrJw4UJrWY9Fn7Kw4qyryay3s3ta1jya4fXa1avF15tw4qkFy8K3s8AFW5X34kCa93
	tr4UtF1j9FW3Kw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jo7KsUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xnj3GqpYxl4WAAA3I
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3C1D1C000E
X-Stat-Signature: ydmutzcwdy1azgkmnnipzuqj5qyen9od
X-Rspam-User: 
X-HE-Tag: 1789485864-854167
X-HE-Meta: U2FsdGVkX1+zlZYVQ9VkYFXCPQHP6Ll+8ruwPoCMZNiNbuTwj28Xt0WQD5LO8XxnBqxtrEXj4WKb5F+Brf8fEk7GbmJDfH9/ka38o9X7xKncZSj4UvkCRikVMCoohm+X3vCZEWgCnpfYDBRyKYHB2ELy5ryvshK1p1Fkb30MwIeJ6lGAKivAdxxiKe0sOPViHtPUwJgEb+avO8oqOzxg7H8AL4f76kgVQodKZI2PMIFRu0c+RZKkULVSBNYtGAKgzazGWDKkZ25xbnumL+oL32FdHDCQI/1zz2XWTQi/LC48x6jmz2qi2hBAeiCE81R/v8GdGUEBIjLVY4laFqhtMlosEnF/B+1H1f6c6oAJUwfA79B7hTf3t6FGRl6yq5z+YY2VrXNvjoVAMFyXsYtiNOpiUxk0pY6ilIHBMwwUkVuovhDqeHwLftpI+KBoWs+BBc5ceBiuc0UN2odI1s7vjki6YVSOkUhrzoNI/RJxqUJj92wuam8jnlOTjz28bdHnlj+ByLeBKhx0iX+j+NcmEEXK0tkRMwjkJSeG/eYqa20h/CWg8OfuOZufZnEzXS3Tygxu/KghsRrdqVvNKv8oy0UeohbSuslkwomdACLKLovPS3+lCVbvSB/lfbXE104f3VXCC+fy/mw4z2MJN9wJfkU57FSXBWqHZ0SajQOS5MnqHZ/Ag5gsy1Qp2oRFHAqp/Zzr/UY+lWBMFpO7M6/jQs4N3KsyFzEtYqHV+OueJ/azhDHSaOl8MOAthsxjhLbuKMU1d+69iNjXr4FBvCNqT3GRIQWQwWXqWzPqF5OqvmoXTZt16eF6dyMbIsrL84ceI5VpRzQe0mRgJZ40b82DFhIsyQj66NkMAa/kJYUUD29Pj7KJCVQk1M0Nw0ucpRBJxm0o9Yc1Gz1ZxE5H91PdAIHI8W6+yAi2sJxlHwvAXKAPcL+ko1t8Rmc9mtsFOXYFP/qA9mhKa97+1MPBtpy
 SF+Bjd8k
 GsQWzuPKRgDQu+yqBpdTw9TfrmHX84TWq+bgwEAE6+FOKlbBCLenolfnzpZTFHqCGVL40X+v1a5i7gQRBz21K4rjZ51ONxp8UziMts/2pXrnwo9T82Yp7VlemXL97TCPji0CmccgE+h+kLEbtpvNqWKveif+PeVPFquS49Ml2kIAp5BIv4QhivFoTQwuqzIDGhdOwzYkJWCgg4OUDBhCoS7l7NhB5240fABDB+N1cLx8uEz06KBpq2UPqhP6lCqDDqaw37x5w5Fl8SwUyGoAD/0C8XPlRBMBpPeI5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Pass the source and target folios directly to replace_page(). Any
large source folio has already been split; KSM and zero-page targets
are order-0.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 8884964d5a53..4a4347e9ce39 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1453,18 +1453,18 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 /**
  * replace_page - replace page in vma by new ksm page
  * @vma:      vma that holds the pte pointing to page
- * @page:     the page we are replacing by kpage
- * @kpage:    the ksm page we replace page by
+ * @folio:    the folio we are replacing by kfolio
+ * @kfolio:   the ksm folio we replace folio by
  * @orig_pte: the original value of the pte
  *
  * Returns 0 on success, -EFAULT on failure.
  */
-static int replace_page(struct vm_area_struct *vma, struct page *page,
-			struct page *kpage, pte_t orig_pte)
+static int replace_page(struct vm_area_struct *vma, struct folio *folio,
+			struct folio *kfolio, pte_t orig_pte)
 {
-	struct folio *kfolio = page_folio(kpage);
+	struct page *page = folio_page(folio, 0);
+	struct page *kpage = folio_page(kfolio, 0);
 	struct mm_struct *mm = vma->vm_mm;
-	struct folio *folio = page_folio(page);
 	pmd_t *pmd;
 	pmd_t pmde;
 	pte_t *ptep;
@@ -1613,7 +1613,8 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 				folio_mark_dirty(folio);
 			err = 0;
 		} else if (pages_identical(page, kpage))
-			err = replace_page(vma, page, kpage, orig_pte);
+			err = replace_page(vma, folio, page_folio(kpage),
+					   orig_pte);
 	}
 
 out_unlock:
-- 
2.43.0


