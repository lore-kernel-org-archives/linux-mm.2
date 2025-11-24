Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5782DCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53CEB6B002B; Mon, 24 Nov 2025 09:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED696B002E; Mon, 24 Nov 2025 09:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A676B002F; Mon, 24 Nov 2025 09:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9636B002B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:23:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D471E8910D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:23:39 +0000 (UTC)
X-FDA: 84145718958.23.C176E63
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 08C1710000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:23:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hM+OcIqI;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763994218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hUq9Nr9zXWWDoGLhYtG18k9aeDOk0M7cd6QDkjP75Wo=;
	b=xWeETMb0vd9EGaczDXtNRGGUIMuCiOq1SUaEMnIwURgFq8mg6epMMxC2VKYS+jDhdRXzBj
	3yeXiL1rwZ0iI1Okk2/b7+UKfACGnmjrJV11mlXUJ/CR9Ti0uGFJNQ1BWCt6IR/9qW+weG
	OjV6KEZrbTXCIl84+JUkaiUeX5gAbCI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hM+OcIqI;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763994218; a=rsa-sha256;
	cv=none;
	b=4XWUo1maYGWkNghsTdbOAdbk/lpsDikD0sMqjMubjtlG/WePBvhVSe4COYUTT3EGo56a//
	UwrL1wTwcCyJw72LZ6L7D9FeDxaFyYh8inGgKtwCD9Onq5HwXBBtUUF8Dc1HRFUzgFowu1
	1LvM7WSdWdAGfHHmLWlI56UT5mz3yVk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hUq9Nr9zXWWDoGLhYtG18k9aeDOk0M7cd6QDkjP75Wo=; b=hM+OcIqI452FEu5OaxjvlfofE7
	QsEoVE8zQdTI7v6Fk+aoBmIsGo6b8curShViues1C22+IJdyLXyK0mBW6Odhckkgx2QEf80kYwoIr
	4YW6GoGWIQ0BzedL7tOVtOTAoFep2GxQNdTcwoz3gQwIgCr6TQvszH4rHtwyiM8HgFODoZ3EvxclW
	ZqceYDqZwXykgNlkTfGquhf/pDOYhPXJevhXpv3I2PZv8bwxFOQ0oEqCltoy4b8HSFfp8+EAbgtcw
	Ujx3qimvKYyl9sEYlqr44MYo40yI6D1Yp8o+Oact5YC2ADqZuq+uVOUQQczWfziYT/SQQbyDodjZq
	8BZ2DS8g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNXTX-00000007671-2oSq;
	Mon, 24 Nov 2025 14:23:31 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH] slab: Remove unnecessary call to compound_head() in alloc_from_pcs()
Date: Mon, 24 Nov 2025 14:23:27 +0000
Message-ID: <20251124142329.1691780-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08C1710000A
X-Stat-Signature: udbafifbzx6c6rej7wwr1b848mksy6ox
X-Rspam-User: 
X-HE-Tag: 1763994217-97497
X-HE-Meta: U2FsdGVkX1+6Z1T/1U6D0/NULTUMBbEKzHXuJ3CTstg0o2lp6YOco+cVxDZca6O4is2T/zp4PCaqGo5d6KpGA6i42ey1lzSqO8cUyUP1g9j+I3JHSGz+cde9xeSRFfE+vSqRc1B+A4vesFh1fBsr4V8uRp9wlhOZb604K7bhXbRGiK+K36T/p/R/T8SVLbLkKKhfzjdfQ1G1b1bbuNNdBFDlpgAfdTjQ3FcBftUhX55nS/xKOrdMn3qpoYS+vK7n/wv9S9xB93y+lkIOTnOa0kI+pSpxF6Z2yqgbGGLbhYVuoLYvOtyI+HC0fHO86kZbK2vccsvBtoAPhxJjy/tiqukRBNip/LUu8y6YoZ2yEa7Fytae6YeQqNkK8xmp6JvSsvR3ucXrFzvLEjTPEp47GPmSoLQRhHyhDch27+V8lvCTUZwr7tShAdjvL0iRj+08tXHFzIj2gKxIt+UG/ue59YOATVD2TxzT3g1CLyduBjLb75u3T4Valbs8iYFGNF5L5YnuzObjZAQbAzle4Wx1OxsXp7L5n09ALMG1LPdykrGo8aaJ9jBE9yMcmq9E6tz7a/VnMubQyz/MjBStJolDD0bOlMULtEaA9CSr1RPJQLtzP0aHemZpxdWWScIAh1e4nEbse8VaXUDizhu2p55qITVEdMpDxmnzZFavczLLkb9g08Idc29SoisQQsCtunljicvo4acygkYmVLARchBk7fQB93ETKJyWgQWDZ4GEfSN3xxVsVZkdNpqFqWi7c1viCpwMFMgdGPbW8nTsHgHLgCwt0m5GrdvIcYn6NvwisHFpwqmU6Qa0X71D1V7xfFZwwpxQeuuAYTkC1JzWo3mMWl71Lxvd0nARGjFUJgjwrBSFg5OI36TmPBkQCKOjL9a+rnF3G2g0iKUXl/9Lbs4/tEg6x1RzFB0can9rCTms1Q9ZqYz/WCNhYwSWthAzuM7dC1tluT42/TsXPiy4CdR
 VubP20lx
 G3uBRZKhSSWX/R2wgQPk0TM+SQfvO2xMK80WBMYTf+lsuO5rNSVZAKhW+lWrPiRbVTnQvQ7BLLZYh46dz81vjfAnGkIlX3We9OrO0eGgq4YWC6aEXzNn/+wsCae+lA26boGuM2TAA3t+BvtCojhqRL8cAATz+AFxesmUNvy+FXU1wz3OEApxqiiadGMgw48F8mZHduzaysYRqaHi4qsKRYqc8Fv13UK3kxa/NxocvoRRxu9A4WOpr/HvpkzpjuEbkjgglqVzlwUpdEj2m31KxTwkNuRrPupnCkCRthN/X5rX2ARUtzONwWSew47YEuVOGXaCoaUtF8Pc70A2myDIYelxQXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each page knows which node it belongs to, so there's no need to
convert to a folio.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index e4a02586dacf..e6a330e24145 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5126,7 +5126,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 		 * be false because of cpu migration during an unlocked part of
 		 * the current allocation or previous freeing process.
 		 */
-		if (folio_nid(virt_to_folio(object)) != node) {
+		if (page_to_nid(virt_to_page(object)) != node) {
 			local_unlock(&s->cpu_sheaves->lock);
 			return NULL;
 		}
-- 
2.47.2


