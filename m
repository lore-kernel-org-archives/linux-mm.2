Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E6CC5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 02:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9576B0095; Mon, 10 Aug 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90786B0096; Mon, 10 Aug 2026 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDB26B0098; Mon, 10 Aug 2026 22:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B111D6B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:53:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C2121402FA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:53:13 +0000 (UTC)
X-FDA: 85087467066.20.B96B26C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1BE1510000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:53:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JwZAbhVR;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786416791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WGoRZehvZShX8ntlBWBCd1g1DPrfcbm3SKIWuxii1M=;
	b=q2ZkXhCV7n1y4BwxEeWGrVjutyv6a8O4Z49eX35cS6Ulnhtjy2smkVwKlYGZqQalRcJ41g
	0W5M69+0qawRQXzvoH9yg2oJUFF94D90ruDRu3Tdmehx4DKNfiMqpupQ4AHQPveKnpA0ID
	6VW7Cy3dlDMgZnVqerz0rHud01Dpwm8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JwZAbhVR;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786416791;
	b=eb8ah6IvUyBOfvdxfDsQSgjYqqDm7gQYBfO1XMkIsN3PqdPyCjyIkReFGWw3bKQnHIJnbq
	R/wHf/zeepYugsCJAOFSCT4zlg5OuFYVareVuPggPK2Rk78Gm5wC5Y0wucjCzW82Kg21kx
	AIEmpgop+dvEqEd8/j/HoQeA85mEFxI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5WGoRZehvZShX8ntlBWBCd1g1DPrfcbm3SKIWuxii1M=; b=JwZAbhVR3ay33saSROg6T4Ppwb
	25v0RbqOWQ1fh9DD+Qun9DwVwfJw0AM5zZDsgi7/zunwBNgPAq56cnWR+ekB98kkO9VsZ7W7oPpzW
	NPiNauO41x/GDj8amqVOCqknIHkh16v4VSuXymdJMZe9RP8nPe+tJdtIl1wvwL2S+Doe3P9Xlv3Ly
	sO5dyRUQc+q8QQ1y5VO4Aa2jkq6KYYJf85A60ytF0GJTYrUSj9IoP4WzjFPxJN/4B1l4noBjE9z8S
	GIvJB9mp8pyC2N0XYEFU+Xm7i57pzrWO2eEAuy3Onqgj0XF3IDRd2tn9FnEfQ0yYFdUQV8lH0eanZ
	PGUdJviw==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtcb6-000000007kZ-2JhS;
	Mon, 10 Aug 2026 22:52:12 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 1/8] mm/gup: break out gup_fill_pages() helper
Date: Mon, 10 Aug 2026 22:51:50 -0400
Message-ID: <20260811025157.1632867-2-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1BE1510000F
X-Stat-Signature: hbsa9h18knwd1zjneg9fgqo7g1o7njti
X-Rspam-User: 
X-HE-Tag: 1786416789-470970
X-HE-Meta: U2FsdGVkX1+cHCWXfv983MMg0oPtdZy9OeUG0K7z2FLORmT/P/lckUSm2eaNTQLdc5Tg0/zVqiWPtFcExB41jCy5rGVlEipfjll6ELUfwIBj+9NksdasNR5aDfTxFbYbHnzdRt+02k2a/F8rL88XoIDix6g+sjUpu0xH6uFpIetCmaH5vIShNs9WdPu1JUZLGMkgoMLwVkAaJ56HfVzirPQEx5jWxlL1MsvYe2ZatUUlRceUxnCXgcvlqcrmH6ESagyIm+1fR177lDt25HvvdmzZqD8LPBvi35pN5ccdxeXYfcwWCgXs1ztobhpZDabzWwj1Lf/OmfCAQKbq74wiVoVlzFitY0krfIICJurDpC6rJAP37+HhaXXT8ZMFIxRLS+az8snSOKCTe1+7Yyg+5nunMLoNG3XzImugaj4McAfjiU96v69DxAHxyE1HKAcIv848Xo9mV6Zg5/bQMfuaozHmgZCf+nAUhNARNbxZozRwRKfc6Bw9jsKrTUtGVeRwVbpZWoGfZBRAW7ZsO4ciKqDRROmBXPO/VpIfq5lCGEzcE+eJapqWRtKkCepbNlo9RrfC0IqL3TPIB1mdK5c29Q0Ev4+AuC/4i6SbyDf5im7MPzW04Belk5tcuZIIOSG70xhC9EsuMuJRz44MhNlIo1qn4ei07GIuOgBua+0mF4zSp+MFbmmpyWaFZC8ToNxweljYf/4cGpj4FhaNtTJhscYTcc2yo4R/eVxmLjEiHjnj5PwtGIuSH1PsJ2FwCq1DJIIyapt4m8CK/r69inn8rGNfwxDAG6O1gY+uHVmMzygYixgE0KMeQhBshNIK567/9qDYc2fgp0jaTmLH24bYRDdZIra+ljNP5vS+43wzNQz9fYccfDLTjhTxX8vZ8VsbiOcazVSXeWGxcYODukUhnUqdPVsZtd3sKOwi7RlFnuS0dSJkmkCnxfOnrJtefzByqj+V+khIdgCOqwjq1M4
 +1Qj/11M
 b4xmHo08nkbq4jhUZM0Aj2wTZ4UXBRLzWVHSzd12qQWpDbxO5Np1GAXmnlC8DE2sA7e5+SXDfR2BPTAf3xnapOrkTNr/qg4Q2i3jjiJn4/vHTY7lgCi2/Yz8KoQjvSqxb8T1ZZVZe6AVyCdK1q2b4SC1+w/a9oPTZsECkKJCBseNlGa4JpSHiwohU+azMiqcJmAz207Pb3Cp4vlcAVYHxJ1le56zwMbhxCPtOp29FNmzKh8sturk43q1X+U+lQy6St1T/xFtUm9OyuFI9mU1XWkGd7MR/t2pLtjoz5AFLYl00MoJhpWkB2J2LnZAzMtNA80AzY/g8Jb+y+IaMloYA4VBeTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__get_user_pages() fills pages[] and flushes each page's caches in an
open-coded loop.

Move it into a gup_fill_pages() helper, which the follow_page_mask()
call chain can then use to fill its own pages[] slots.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..7bb40be89529 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -633,6 +633,23 @@ static struct page *no_page_table(struct vm_area_struct *vma,
 	return NULL;
 }
 
+static void gup_fill_pages(struct vm_area_struct *vma, unsigned long address,
+		struct page *page, unsigned long nr, struct page **pages)
+{
+	unsigned long i;
+
+	if (!pages)
+		return;
+
+	for (i = 0; i < nr; i++) {
+		struct page *subpage = page + i;
+
+		pages[i] = subpage;
+		flush_anon_page(vma, subpage, address + i * PAGE_SIZE);
+		flush_dcache_page(subpage);
+	}
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -1461,9 +1478,6 @@ static long __get_user_pages(struct mm_struct *mm,
 			page_increm = nr_pages;
 
 		if (pages) {
-			struct page *subpage;
-			unsigned int j;
-
 			/*
 			 * This must be a large folio (and doesn't need to
 			 * be the whole folio; it can be part of it), do
@@ -1493,12 +1507,7 @@ static long __get_user_pages(struct mm_struct *mm,
 				}
 			}
 
-			for (j = 0; j < page_increm; j++) {
-				subpage = page + j;
-				pages[i + j] = subpage;
-				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
-				flush_dcache_page(subpage);
-			}
+			gup_fill_pages(vma, start, page, page_increm, pages + i);
 		}
 
 		i += page_increm;
-- 
2.55.0


