Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56346C531F5
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539146B0095; Thu, 23 Jul 2026 10:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9E96B0096; Thu, 23 Jul 2026 10:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D99B6B0098; Thu, 23 Jul 2026 10:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 119B66B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:30:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA37F1A0242
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:49 +0000 (UTC)
X-FDA: 85020277818.29.9F906CD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id A67E61A0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZymUx1b2;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgEqaR+d7oMg+OXW1piQIA/vwtndewjL/6n9mPT59RM=;
	b=Xgp554qmKw+6sPSST8Ib3c/JqmBshYxFCwR2PZfNL60Lro1AGqdH/11RDTeUJeCWBrb733
	lxSHmVCSA5ssiIwjYQzVmGGHzvmrspcXY20/j7bYHsr+/4qeVk9qlawEycg2dvjYwUYdG5
	x56f7iFhEJ1exaUiCtqkqAX7uaUVYLg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZymUx1b2;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817048;
	b=LYoZAbbXrbmEztq/vnmHDVSzfEzWTgEMzis9xOD5t1Qb02ZKxM7JLnr4YbKnZeivyXVxdq
	sdlUZOgGeW8YNKZct5aoaJ/Tw7NccEd7z0hcqS3aJIazXFFF8A00kHTOt7yCfAONrWDHyY
	9tPITw0vV9gLCUemWi3Yckb27B+kHmE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=CgEqaR+d7oMg+OXW1piQIA/vwtndewjL/6n9mPT59RM=; b=ZymUx1b2XJMwy0Av5eYHFAGkt8
	9MBjSBOxA/2YuO/UVKqF3Y5YWeYzIicZvqZl3rstjqO7/EoHN69b3F8OnyWGupymcv4oVNXYVUGTc
	xKBiBrSyOykkjZC7SSrDKzui+alq9VTAfhRU08sKsAQ8Uo/Mi3q3NpVxkSD7mZjCG3RnK7guo9MRr
	L7Ur2Vi7pGO38dFXcutmJiU/nE2mnBY8ikkK3xFYbvLZCXZvPkXcwT5xaOcmnaS+QNyumqrrVT+Sj
	tDdqr+0s901HTsWEn5X6PyXHhgm1btb5fp/Nx2c5FyDxtoKuuR1ryCdjPdivXL3oX1ulK+odvY6Du
	WqYwUwMg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000jiD-3LPo;
	Thu, 23 Jul 2026 14:30:37 +0000
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
Subject: [PATCH v4 13/14] filemap: Add support for authoritative mappings
Date: Thu, 23 Jul 2026 15:30:30 +0100
Message-ID: <20260723143034.175661-14-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A67E61A0002
X-Rspam-User: 
X-Stat-Signature: iaif653xeszeqmxi75gors6111po3ffj
X-Rspamd-Server: rspam04
X-HE-Tag: 1784817047-434490
X-HE-Meta: U2FsdGVkX19WGRPZrNnTta/pkeEulvpoJMC6sObr4tir/t2uDOzLHwSVqtz3JZOhaGHu27pvBIET0Crok+NaTJ63Kxi0Bg3/gsK6XvGFV992fSArWD4JBKI3Axt4WpYvK3CFXf3ATBUc82H+/Xb+hJikSrBs4PYX92JIaM77n104W8vVFcyQtB59dD38TyCWme3OnQEep2T3902wsz2l7yxoN8qdbqNer2jdWK/9i6AZB9PV7JsmmJawx0oIXitlZ2a6tzu6R1GKBinz3WUo/hkG1GQFv+fw4Xx1J66pNLKf1jRLIxt6VmuYFaOxFN9muGjxUjrEAwN9HbOo+4jFTsanJopvnePRAFsPClqzxVjzHH4mxMyHXrcp1Toe9ckCoQHuUbB3F5dK8pJMpcsHQn206HlZvTQvOVHu2rQ+0DBfkWhmuAsisb6Zit42QRzzy0UimA25syQaXfJwlJyqDw1KwANap9jBxYVoLBxJpFN30M83E3n2qxDQ/XryYe0PQTRIMZI/3Wp4zy/Evumdw6kDM54Z4fpPt54uDj4ZvaJxIIMgdXSu9FVyxn9SWeWiuT9Whb1foUbtGb3iJ9D8q4cVKtgQp0fIgeZn7+Fxkx8W9x7wMBMb51eHrWKtTtv7IGa9NsLMqt3niX0ipTPH5cKXTVrCo5Z0BdubVFNuFZEuk+7Ybg9J7ue+X+xX0yoZS0lRBnLBM8rUniXw19IJRHGpkSDxvJQ6j5H3/DC7JW0y/lh4AIA3/6T2lq4cMRC6e7n1aYn2c4eLvvpi1SIcOkeAXT3cX6LbWQwx+e/Ah/0uF7XatmjL2eWOLf6io3wnHMrryb7jvFyVbQFjLn27CCIKRYgLtGpQdpUtdzuOkp7OpvkfrnWYCkTnbjDdaO1e5KjDAa/Sltt0xcB4z8LmamTitvNK9Q4vvo/qSWIe4SQdKzo9qJNM6/+AAI9hWKMjKfIifNO7yEoApfjKDrU
 fbDKcA7k
 syxxln7DAriDjBGKFSJecO9iHomfCnDa9IGGiwF2thbK+Bv+jc8p4qvChLdDntD6aQ/RrmV6A2GuTnrT0Ao8BFsSx8eysC6B5nxbUZGiVmnqs1DPGMRVaF6BvTaiqt3Sc2PYBhxdPc7MnDesv+D9dx+cj8CD7kGb0YO7OmkJvdooG8Dgmqe6tE0cNs4O0R1IHzsV4LxmPgP2vhosi+akcRLS6yWdqIHR5Aowpkmz+nOOFXJr5YLMdUI1ma/p5a0SgFnXJGjTdC1AWAekeU+n7p/XQhKSYufxXTSvh8loIBuSG8Ij5aMqQ1nqf7IRhw3yTxNAdeotHH5tTSMg=
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
index 436987f47aed..6fdee5b03621 100644
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


