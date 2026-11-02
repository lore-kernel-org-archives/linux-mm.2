Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00ACD606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=mz8eAbE6
Received: by kanga.kvack.org (Postfix)
	id 97A776B05B6; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8200F6B05BE; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A326B05B6; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A80E6B05C1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 242B31A025D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:14 +0000 (UTC)
X-FDA: 85391172468.10.EAAD20F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8D0E11C0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mz8eAb E";
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793647872;
	b=5Gu04zr56yOMk8p6/06EI0g2QipZSCON+G7szkUGvu+9XVNYgQPEo14O35aJsYPtRYPv/i
	rNvLjhwHiJtirIkqGQ0xLqsI4GAfPEsDdIG5ZIWVSSBd4drDNPRKo9oeugFLW7mvvZ+HAu
	Bnr7FjNlR2EOEM/iLISZqFpjuXCSGo0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mz8eAb E";
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793647872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNNApX8IrT5tO5AUvYvK0uTgCkV0Iwt/YzGIuYnFDaE=;
	b=He6RVsDOLnhEhcN+GoQYBytXmPC7f6mWiZAmNzGJZL9aw/oxcODQqYNQ2avBiDBwoTo/HZ
	IZBqbnr8Fti6fOyyNOMtW2OtT1atUtDDkaqsuFjRDAjuqoStGqT2TUDom3XWKJbhH5ELei
	AiTs5qbRhpGXnDA7rtLFSxg5aFgz6BU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=GNNApX8IrT5tO5AUvYvK0uTgCkV0Iwt/YzGIuYnFDaE=; b=mz8eAb
	E6z69j+3hRzeVNju5xno9eDETUBbCUM5G8aSlPOgjGYIZHYsbhpl7wEohhsRHPximhFAzOYV4Ionq
	MZS4x7Yhk4q/fqODNmLvckcvrF10HzH1AwSiPpInrBN1u68v6DopdKKdOBCdKkj7gjEyUIk+VhB3z
	5/zLqFi7GqEuG0nA79EQUJW3j/TBRzhkcWuWIstcYZiUKiDK0ndSxniZqw5p3mTS982b7ATvpzAsg
	5y4uEvaMAZtHOyRqaB7qJE5mbiEHPlUq0WxWmV6imX4QNe8VIljVVA81GrrhR0ANhZG7xB1yGDfnq
	PkVv+TY3jPidhQn12EUY+qsGeXkw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xNxjk-00000001W8x-09WO;
	Mon, 02 Nov 2026 19:30:32 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 1/8] mm/gup: break out gup_fill_pages() helper
Date: Mon,  2 Nov 2026 14:30:19 -0500
Message-ID: <20261102193026.3860700-2-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102193026.3860700-1-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ugmmbsp1fcifbzcthmgigru4tqh3bm3
X-Rspamd-Queue-Id: 8D0E11C0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793647872-918258
X-HE-Meta: U2FsdGVkX18PmME+wMPMGZJuuI3C5FX559H5xjmmK9SlcXk2ALVQkHq24zkM3lDuxczYiixmu7/j7LNzp/urgGtwHiNYxjXu5VhqBw9lF69a2/PD6mO6fX03bfiyzD53blwulHMt3CSZ5pV9K4P3cGY2KQBDrAnHhCRMJwo2TRSTB4pDv5fQMoLQSXyh8rDCVpYm1EdrQeaJbG8qXjuvG2HfwvS2x5xOrGWiD4h9EOmVi8kHjquzp5bS5K1SoNa/IO/iv7vlPx3gxcPYiIsgaL4efaEgP97/TzPbSe1eMLHfdkUROQuzbLgbKkuT4OYTA+EJHmYBAydM5z4u/LArSdNFTAnn/finvujLJlzLdRUh7ZVP4OAA9KhF4qXslBgYvf1cnhmmOZquzjicjH0zN7qYpFW8XLzgpYVO6K9DmqXVbrupGLg+G9CCuaWNqRKAIcmb5wwU79W86+KvKcFh/x6lYc0U8z98QZMyh+1gWQ38y5ao5CWLPcVZCljvn0NIbrBoyCTM6NmaEoABXE71fH0Fw1PHAJQ+UUFlFrcykzcOjvSh3S90k8kp2h8+0teolkwkUlb2LNqNCiNlXRdMHy9sZ7FQd1RXfVQEKYiJ7ivQ8VVVAZMRiPF+bJnaPBQIRL+NftHHdsJxLQrzsOlt1aIeTQBbTRlEXrvjHEW2/TVtZIB4sB6w1ryx1M8D03L/hBWfX6au7jKM61IEhREvV/KXMNmvB0K26Y+NgCgW5rdB89DV0oXaHs+Yix3R0fxS+FCvYD2SKPrR6WlRLZ/uf+fyjrjGR0/A0TbmbBSuClxgQUhNm13AQB2Xkbw2PuWo2E4u6L56NwaQGBgOLZ5SWybU3jiXItt1TWjlPgr/iYepLa0wPai1ZpsJUdhy2wvaiUy6wKvDu+ppBOhWV1ARcn35e73RrZween9200RE1bkmj23YSyiiyrw3y/CdUhX2j7WJyH0re4JyrjOCYms
 4YRbKk5Z
 YboHGrmibI9pnSMjplotaicCAxjwYYv8vqCai7w8AXqeJDCJ0uLrAlvq2fZG+ItIl4U/cxcf0FnxbouphN7j8754cEWl/OcHMP5vNFStPdQcRsOA55gfl8eFsJN4WU3HG/yd0xvPP6rePMRhQ9az13Gr385T0yhlixdYha8OGk0sHrw/EONtVxVS/PuPV0DZiRQQ7NWptPPpIBWNHyG79FEmheUrtDRWzYip0jWdgQIbF9+W7xuvAhdWDql970xvd1l4Q/+92W0v6hkQHqS57LlojI5hYiDilDdAULk3YIOvfysB5J4B2UMCoRbaXTlyWSCHQs8ky9//YgN1zy/fifVCMS67elEoEYD4zHAqfFTsjeP9u3gkJbYHOINIOg2Z4Q3/69UQOI+Zr4lYGxZudXf9o4i2ywnRqrN2BcCoTOMDEmN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__get_user_pages() fills pages[] and flushes each page's caches in an
open-coded loop.

Move it into a gup_fill_pages() helper, which the follow_page_mask()
call chain can then use to fill its own pages[] slots.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7d43ce717b246..cdbe2ed3e6442 100644
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
2.53.0-Meta


