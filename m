Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DE8CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D306B027F; Fri,  8 May 2026 16:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDDE6B0281; Fri,  8 May 2026 16:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5F56B0282; Fri,  8 May 2026 16:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8B96B027F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:20:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDE7A1202BC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:42 +0000 (UTC)
X-FDA: 84745370724.26.FF47AD5
Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4767E40005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=dvyJWb0O;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWqx1blSQdp6dgm46Btp3ftogbY10gYMKeBKkQWtkfw=;
	b=i/H5maG3eO1+ZyxbME90wno/mc61C8Fdrgb+cjE/MAyYUIX78dxte0JkEWTndjrDbZNefA
	p8MuyWXK1U1HslS4A6uvjwSLFfZ+vKzmRmIfdFxb5+JwRwmKLGBkXArYB10AQygLV+OStC
	7EJoudAAbkFj63xPoneaAdfxQCQZEf4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=dvyJWb0O;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271641; a=rsa-sha256;
	cv=none;
	b=zH63MeKV8+wj8ppE0IxGchkCvg4n1AowVI3IejQDrJoHwCErefQbEu4+vmmWJRTyPp1VSX
	mVlK2WJYKa94loUHhN/mIEQbj9tH8VT5lXoRj5+pKoqm6Kv4kBGTCnVYI2SX+9lx2buXoc
	SV4y0hhB79sXsI5xUKTDfxOmKoVb85E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778271637; bh=hWqx1blSQdp6dgm46Btp3ftogbY10gYMKeBKkQWtkfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvyJWb0OGSTjSU4EJhFhbNSrBz2Bv2eoi6YPznBYGZe/H8Txc+jwnqtfErWpfIls9
	 mqYysEDTIi9tghh+NoklI0KwGfAWeohhxalnDg501Td6DhzlrQnTMib5uyy95I7+d2
	 1IQkfYkOXrV098uJK0BFURJP0DVsR870Ieerzsds=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 52124024; Sat, 09 May 2026 04:20:33 +0800
X-QQ-mid: xmsmtpt1778271633t2lmi0qjr
Message-ID: <tencent_A63328EECD6F78288F70DD8C5A2070593D0A@qq.com>
X-QQ-XMAILINFO: MhK4DKsBP06iWD5gycqxXUMJVpmboO9b7h3t7pVFSfFwEPA48/rNusLwO0eAWi
	 k7sjJptT5r94bC1JGJTTnQmm5eOGSSuE2J/VoMyUkP7jcu2FpemRQaPCfFEAp2KhJeYXQms9BySm
	 ovw48LEXWVXMpIakykHkqM0QASmYbJP+EDRkjpNr/iEbBINAZ/s5I/ReXguOkB5EYtmxX++O/yOn
	 EzxIRvqQmpzuB4kOSc6uUz2texAuYCJd4r2C2+dARfcBKB6LkyGwxHZ35tmpHOasGvJGFBqS8o+B
	 a2Dali0UPmXv9mWJI3zKycQCtpsHDEpCZiEw87Gs715CGnI1JC3LAOlclKDxzyOkct92j0VhFUQm
	 ypvmeHB8QcupvY/V1e3+pR20KRlCFT7+7oKtRuh+pcQShv8Pc6jHTiX9xaNHlFQEhvLz7jqvjH6l
	 WlvD3QUX5Rd6K6B7R8BGjGRINo1Lf2GHOBZHXZipSPMxD0QZBSWrGLBHon6ZHfjL6zDncfo1ooIn
	 YG5PgavlMxuftw+NmgOehI41+zZyUQ+g1VHr5FoLo+GNQmNYokj3KQKSKQWCaha5JU/OYc/JMJur
	 v2nGP1lTM+zNtRBe+/lmKDi4lsqLW/CIB+1y87kfICi/D8rSKhspt6a34R+Ygc4au295uEXmn4nn
	 Yk+Km3Z9y0rGr7T7lwWXBsiE28nay69jcWQEIpFJePkhGGIh2T6yjN3bDwwfMj0YO2mmYY9wqNpH
	 2qToW6SQbfCiCz/Sf7VqqTQFEPd1H03pKuF/eCrzp8XAixiJ1zQfzFHHm+XTEC857Ljxv/7UfsoH
	 tAUQCg6P5PxlIVkhDRwaHLN1lMrQHNlfpjNaPYL8Y6OqgIQiYszzUHDLdB4HW5IjI4ji2qPRgyRu
	 sJUxfFElIfZ9hYSi1udadCQfwvvcpwUvoFLZvVWfivYnvL74st1G3qPuSOkaGBT3/EHCoQp5nOxh
	 629zGiBlH5K0TcxmFztsUGgZojjwu0defQirckaTdFGCNRGXwPnbM54K1GEZbfyI6s3jg7Woxffj
	 gyPRYVn0f1oWxvdfnG8BjY2lzZ/YOBtHZPCg3uqg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baoquan He <bhe@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 1/5] mm: zswap: decompress into a folio subpage
Date: Fri,  8 May 2026 20:20:29 +0000
X-OQ-MSGID: <20260508202033.1834876-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4767E40005
X-Stat-Signature: kxt4foebkjuxk7akrh8b6tsxxkakytx7
X-HE-Tag: 1778271639-387195
X-HE-Meta: U2FsdGVkX1/ieueqWWeIbDS8t6Y1Z011spObGVFBMMzRpP2/WW3fSd3P2oXjZKFl7dncGOoDTaUDE9NTOBH0++IAM73AnyLcBiD6k4rvnPPZTVzlgbk8bmmbg70nA18BdRu8778GO0CLrE1L1dBdv+yydNWoynBvHWdI41Y9lzDLZXs3jMNtnUAxpCFx9p3AAZK3Sfx08MNyxRigFyOJKMj/Q9Ovaf0fKCmEYmZ0HYLYn+xowhsc4smMFfDDWoiNREgT1tT+fE4JJpwXsP2Z3P+NOka1P9Vf8KTC53f17xlUs4GpgX6G9qDka6c4pjL4qCl9zQOXnnPbrGGTYPSdTd/09qnFLRmG/x4WMUqSDlBcpQ5JK3NVlmXObd8yGEya8J7IEKnG4d5CyyAgoIdeMHQnNsND7mcQ+cS/A4wr7uCmmazW0baEkZ71YrsjMWPE4SBdM6eYnHeYYq2pIoyEo04dPtbaE3FSOZ0P/GzRqgR665/6OZBFFnR0GhrXZQz0Uj1Zos1H0H6J+pcB/19KqZYk3mTbsizZMS+DaTCWYNu7mq2KS6B3Z+aW+JbgRcTz4KSV8H6Ve5nmbyNYREP26t9FD/c/yinDedbAK2pAidzMihMeG2N9M0ews7RPTuWcdUWUEcoXhK+Uir2MUl9qHiacsy7BoIYygpd0nCscWq304lENqZMffmiSn7/Y5RxYj7NMWXkqaSaqmbOtKYLY/rufOjt5j92DL36jnzl/UgZoMfG9pgUVAx9FwYZ/BqYhqWBDd8ncFKuLg9ub14CE+oA2ctp44ZFsMUFmyyyBpmB9AI/1AoKRZ2aIu1jjxsrj6E1yFHgx+/Buiyo193COcd0CRynGD0kjW/uTrmeK1fXbGSkGFedMW2uAosVv9we2kffiU0BXoWoDmdKYIgudCk5keJU5mA4ru0SqwPHJ3QHh5hm1cJGUNqL4+lfPYhi3EUyvOC33lSxak0NiydM
 LsqvbsYp
 nMiDZNXeEiusSmxJ/x4zCjz1dLyjwbMd/nUpqfusWEFP+EzpJdcD6OvEghTtbH4ddScb5PFErOp+VUZqCuYt14N9U928v/TrHu+UTik59foQ8Vn3VCYGU76+3TjZXCXNqJ8azc3KMBmYXxyB5JCt5mgvo7Oz6qztn2KHy/4sYtOS13Pmv+lDI0F5hQajBbQClt5JusKr2axOTOhfsTe8o1tEr1JxrWlLIoCImn5sAJgaoY7VQ2DMWE5soZhjlPb0f4qpB6YsMsZZq2dw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_decompress() always writes to offset 0 of the target folio. That
is sufficient while zswap only loads order-0 folios, but large folio
swapin needs to fill each base page from its own zswap entry.

Pass the base-page index to zswap_decompress() and use it for the kmap
and scatterlist output offsets. Existing callers pass index 0, so this
is a preparatory change with no intended behavior change.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/zswap.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4b5149173b0e..afe38dfc5a29 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -921,12 +921,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
-static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
+static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio,
+			     unsigned long index)
 {
 	struct zswap_pool *pool = entry->pool;
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
+	size_t offset = index * PAGE_SIZE;
 	int ret = 0, dlen;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
@@ -939,14 +941,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 		WARN_ON_ONCE(input->length != PAGE_SIZE);
 
-		dst = kmap_local_folio(folio, 0);
+		dst = kmap_local_folio(folio, offset);
 		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
 		kunmap_local(dst);
 		flush_dcache_folio(folio);
 	} else {
 		sg_init_table(&output, 1);
-		sg_set_folio(&output, folio, PAGE_SIZE, 0);
+		sg_set_folio(&output, folio, PAGE_SIZE, offset);
 		acomp_request_set_params(acomp_ctx->req, input, &output,
 					 entry->length, PAGE_SIZE);
 		ret = crypto_acomp_decompress(acomp_ctx->req);
@@ -1034,7 +1036,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		goto out;
 	}
 
-	if (!zswap_decompress(entry, folio)) {
+	if (!zswap_decompress(entry, folio, 0)) {
 		ret = -EIO;
 		goto out;
 	}
@@ -1611,7 +1613,7 @@ int zswap_load(struct folio *folio)
 	if (!entry)
 		return -ENOENT;
 
-	if (!zswap_decompress(entry, folio)) {
+	if (!zswap_decompress(entry, folio, 0)) {
 		folio_unlock(folio);
 		return -EIO;
 	}
-- 
2.34.1


