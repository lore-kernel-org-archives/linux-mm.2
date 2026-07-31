Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 678B7C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5AC6B0093; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430146B0096; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E346B0095; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 045EF6B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74D008014B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:09 +0000 (UTC)
X-FDA: 85050158298.12.C3C9CBA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 394D44000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="N/BmXnNM";
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHllHAYD+554jhDmr6CAyg40twiId7LXCrXkJDYooJQ=;
	b=5AzSjS84DttboGcN9aIMY/GNF73TzQjIsqapUjOGei+eAI3rBfRR92dC34exAPDj86cWUQ
	X63CXgOh62h4Ub/V6cHt3UkXDh6NaqULfB87pmSdz4LeL41VY4T6ZsVJfvfe5kFr6w9gJK
	Kgq2F9dfcOLAbU/OUwn7g7pXytGfvLc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528487;
	b=yOQcpKdrGMqun5eq4AyX0JzRPcJOHoftG6Jcnz/bTksYCxAil9IBzuwjYqXrFpDvMHI2I1
	ugWT+DPfde7I0PyuPDhkqUihyjeoov6JeP+XqbOsEA5DAGscT67P+y7sfUJEbELnJZQXe7
	zjN/AuKTi8vefG6gu3D0AkAGy+U7ol0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="N/BmXnNM";
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=VHllHAYD+554jhDmr6CAyg40twiId7LXCrXkJDYooJQ=; b=N/BmXnNMcwyAp3gxXilmxVsdIF
	RGNS7m6hVd8yyMq0eNO9HSKYQdGq+ClV5HNga3HuWWa1pl2VdITug11sbuatJa7n8hIF+YxoJ3MRJ
	oGIe/xon1SGSfgVbPOB4Vz6OQiZ7ghwlEFyNbe5+gaRcc37JHCDKV4w3tmFUguqlxICoTQG//WMXd
	vLGOS/lcAVLS08/nPdGOCti+s5gIMriYFMcoPUcVDRiZjJeSsqqJxhPGAnB4of+mFwyuMAz/llnCR
	Tw7K9I3SM3ZWgPlMeR/hVeRETMzndETE7zsVR+r+RWsHnaAw6Jfle5+P33cG9gkcp0g4dRTyd6rjx
	zMmIy4Sw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWX-00000002PoU-3Hl6;
	Fri, 31 Jul 2026 20:08:05 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v8 14/15] filemap: Add support for authoritative mappings
Date: Fri, 31 Jul 2026 21:07:59 +0100
Message-ID: <20260731200802.574821-15-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 394D44000B
X-Stat-Signature: bn9e8t7bpdyuecp4xc9o9oiwsbhpkixx
X-Rspam-User: 
X-HE-Tag: 1785528487-359783
X-HE-Meta: U2FsdGVkX18oBT3xUYtGQCCveA4dAytCFR37gdEB7sc8Q0ed3arsM1+A8fpCaPqhofg0oMxm4EtqaMKDL88M7nrhYeEBajU8nxV1xW/KMnV3wNHWDcZ2iYpTRbci3MNdO8ZdffBw7PGlzHexry0BXv14s954qmd2D4/lau+Au5enFgveCMMyZ1ks1eJ4PKhfabeke8Wb6QQQwwvGIfNgy/l1BUIggjiOtz0ct4BSakdfmhoI45JbkPN0ClOul59TJeU2abrlJKTxjZBjm7SzE3niSng+VnsVjm5aUM1nekM2WIdFfsGVUWacKTE+/eVuoGB4FbYXcaSDE3R9oaVohzTu8u6u8ZkwnjmQF8LvwAZ6HD9a5FN7N11mTxuCAICsJVqH0jJ3vXxqJIPRWkcjQPfHVcVNf4fzxWMb9TsvJGVPzenluFZTfyCCEWUFWlwE9ZJGNhEdQjrvPjEhowoAXo+N6J1QL/EbnTDSanVGGrKRZVW+ifPcSl8UYeMekPFagndHqp/m4w8SQdF0yt0094jkifZ+U+kDEsLdngf0PVYCkkzBlpmGENeH4zsvEabR1JN9tkKyBcU/LOuQIsOyDSGYRkegpxcn/GI5uEXYoDcXUhZGsEyT1BekvFgpi7ZyhPaadBeUMTfDUn5le1muLJlEz2bbcgIDUg2U5OvUytI8Z0zohmeCEFtatt5fBGvDqOpyjUSVPeBzxhRocrap9SIeXUbwzBaIq9Zw5zOWQQxFBJjTuhGPpEssc6ss9IgQwcj/xViz8SB+VHyhH81su3uZQM/G1hiGvvAQ1PxbS9ORbaLGOIziyp2QJcbMQCZ7hKSjOsE6xq4AzX4zWuKWc3jz2+xZk3dR6c5leQzIQm8KmA1/mDdOGyFdqX7ulfFWnIZTMUGpfo5IMSfW1If/Mo8g9RW2BCCukRwWYKCYzNm5230mugh/QTZfRmw1eUs7MOHb1qnKbQgmjJ2xiXs
 sUCr4IEr
 bz/KipxcOGLKDCXQv5eT0BeJX+Km4D8n4+GhJfXj1cEVkWR2JOChnm0Sx1MRtet0UJ/tvKn+6p0sX6bamjOKNnoZ7yJxxOcV6IxskBMpChFw7djLEepNIwkROLFOZxCm/R9ucZgHBBzwBXd8u50rddD9yURShML3YC5QbB5uNlFLJyWqRZPOl+CqF85Pa8IhUnlPqVgYiyWRgNRbOR4L255wJQ318uIM84o2qWPnp9PyKCGvfCNnaa6lrQNFXuvArmAs+mOiXMEiRl3xGvSRcESNiehPyNkGh/KcJSqR/zBbWHpjJPSgWJfONs9xQopb+05MPxWFcKW2FJFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An authoritative mapping knows about all the folios in the mapping.
If read() finds a missing folio, there's no reason to allocate one and
try to read it because we know it's a zero region of the file.  We can
just call iov_iter_zero() instead.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 11 +++++++++++
 mm/filemap.c            | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 968b791cfd14..22d48935ffda 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_AUTHORITATIVE = 11,	/* If we miss in the page cache, it's a hole */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_authoritative(struct address_space *mapping)
+{
+	set_bit(AS_AUTHORITATIVE, &mapping->flags);
+}
+
+static inline bool mapping_is_authoritative(const struct address_space *mapping)
+{
+	return test_bit(AS_AUTHORITATIVE, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
diff --git a/mm/filemap.c b/mm/filemap.c
index 26a5f18121f9..5a8cc20e624e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2697,6 +2697,8 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 	if (!folio_batch_count(fbatch)) {
 		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
 
+		if (mapping_is_authoritative(mapping))
+			return 0;
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		if (iocb->ki_flags & IOCB_NOWAIT)
@@ -2853,6 +2855,22 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			goto put_folios;
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
+		if (!folio_batch_count(&fbatch)) {
+			size_t fsize = mapping_min_folio_nrbytes(mapping);
+			size_t offset = iocb->ki_pos & (fsize - 1);
+			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
+					     fsize - offset);
+			size_t copied = iov_iter_zero(bytes, iter);
+
+			already_read += copied;
+			iocb->ki_pos += copied;
+			last_pos = iocb->ki_pos;
+
+			if (copied < bytes)
+				error = -EFAULT;
+			continue;
+		}
+
 		/*
 		 * Once we start copying data, we don't want to be touching any
 		 * cachelines that might be contended:
-- 
2.47.3


