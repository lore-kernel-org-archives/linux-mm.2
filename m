Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D34C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B276B0096; Thu,  9 Jul 2026 14:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35276B009B; Thu,  9 Jul 2026 14:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948B26B009D; Thu,  9 Jul 2026 14:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 622FB6B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:47:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC77F1A0279
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:50 +0000 (UTC)
X-FDA: 84970122300.30.B216248
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 197EC40006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=se0JPcqZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+gzxfPCLwqteQeNfEBhkBCsllyjJc2ee+7IBWDm2H4=;
	b=wpwKk14+98O0Un8Y5qr0S0FaiT6bZ0OIGa8VOgy8uJgLaR0iPye/19iaj/Flneq5rqWznv
	BEU3hGpq+EWcLIZuiLI8hylEdMKeX+rOUN4gMqtixGw6VZEHx/3qwQDa+JYd3BpLF4gxOE
	TshNOuan0Xo/a41KZYVoVmEPjtZmBP0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=se0JPcqZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622869;
	b=LLDRQu+CI3TCrrvy51pELELFkQv8paRj0cYkVouJ+31Z3x0jpBOSJjWNCZP4ndsEIFQ/MW
	tsXyWbhzzpuipw5khicu4e4tRy1bgeMUBVIED2UgRkgPpZ6CSQOuv2eL3aVFrmXH8WJ/mF
	6dvyL+ijqrx5gS6Lo0edb0nALWecPBM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=O+gzxfPCLwqteQeNfEBhkBCsllyjJc2ee+7IBWDm2H4=; b=se0JPcqZDWQMgEY8NKEdJzfIB/
	/wSOEo/YrwziDZtrCD4h8QangqX7dyI34UmF3BpT6bXYquNFbhuDNVaszVi67ftXrAFsyfm0qGqQc
	me2iKzblj1dotTHk3rt33SKIfrP3pp3Zw6J5HGC+J+uGXD+MejVkzKtEVpiaqHGUeoyqvObJQOqyx
	SUcCdVPMfAZWdS7l11gU5iDwI6DfZss1g6wRmJa8+XFhOG0cSNR7+AHeRqSj3Dgadv6QBormlkK/X
	iZeQkmm+nh70HLQ7ZSJiVWLEko7ByWAqY08WyHEu54nmoqcHjgTwJzdNZ6ehjuGLRADaDkGTIsB81
	ihWj+sVA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmh-00000005OhR-0ua0;
	Thu, 09 Jul 2026 18:47:43 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 09/10] filemap: Add support for authoritative mappings
Date: Thu,  9 Jul 2026 19:47:37 +0100
Message-ID: <20260709184740.1286561-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 197EC40006
X-Stat-Signature: myjxsrw6zpok35r6ir5rt784z16imq1b
X-Rspam-User: 
X-HE-Tag: 1783622868-237728
X-HE-Meta: U2FsdGVkX18whbqnFVDWddjItmDwamVadVF3BKTOlQjNvCH69n8K1ihuV5zJ7ytWykQqfj0Q28wbN4OZuAJOOGZeUUI+SHph1T3osq1IrfRI4IOu10AmUpjJ5osi1Yn3ueGcLX0k8PPGG3aSgRkHmrI2gopBYr1mRWc26xoHmNmSZcYA0dCCIk0dJoui8pnGKubatpeObnv2rYVcP5K7xb1Ow4EJWbYu+40VLJ41iby5YnuYE/vmdY49UdPB9EIaOuMhQdNlfrEyaj2uiPBdt3OVIrqmLBkiekmnKl8D+Wf5Ah+u2+6hsR/4K+c8dJwfQxG2WNIW8I1wUokrxEMxylYUGcI6jJW2sz7EA6S0rhYCIa1Jz2GGxlL9hQ8dL7kp1vQ10Axrfckhx/WPZKPlVJQ+iR14otBiO+jm7vaVxCNtdtAkkVIJZBg9xG7HJG2Ma1+45zx1OzJ8HaPvjKS/jCVUf2vAcebW6ydeI1vy4s5yL6Pp4LDMtixV7EENRCBU+4Lp1t61GBORub+Gk8stuB2G7sqHkahrFlDTF6JrhXID5TyUfb8TOSp0Go/5guAcgc/dUdosAyS3ajAzItVKpx+DuDbUGzbKVAvEpo93qreP8s5HHNoQOs/ZSQIecZu3vlG8GqLCaE0pDkD6iBmu2tEMbYzoePZl1LvQaFkcZX8vwqTSzXhHFlT1KS+8ukFQivopoG82j1qrM5D/WlSSVQmLu5NUTqrBoQ69wrgVL8KUlK/LaZstBQpDx32ZfkcmbL3+Je04dQYqmxYjKxW2YZpN4WnDTkDfPBdK6fqwNM8gBXsiEg/410lkdPF6evF/ry0nBI7FlPAkcGmAtWlX77Kf6SgCf5qKRsr7UZFzuCVpUtBVEkLlv/CVf18wgv2y/u8vjCvDoJHJwne2CDuDG8ipY5HNHTOpu9/sT6jhCgb+do2hjU4OGfh6rHfWOmZapjyFxhuBX8ie83rpC3M
 jMRxCKYf
 MaUssxgPn7i0gVwf+dUkjXJOm94d81G1D1rLzuqBPJRQZJdUwxyE9qiZf4ZBQ4adlUsTb+ADfKUYo0SEP0fq16lx9W6YIpj71byu5Z0eBZ81zO6ab+es7FiXmek1WG5eDN34H0Q1qAlL9dpg9g48AGxWDeWOsbiuQ6ALGtWByiw/tapGKmcqvxIwIo8ClSAzvVOb9iVszm2Kj6jtcyoaB9BP2jw1CiH+qsvHW8pbFZ4nfxk5hzbHjFFhVDtqpTddwpxqewgv5R3nT7pHGtaI3+kS69zPmzfQEE/MhnGkpxZVYHdo2gsXNM+QUYnpJNmmo7ZKqRpdVKmoxtcY=
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
index d0c9aecaa4ac..64e67bf79b20 100644
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
index c568d267c803..c113bc69887a 100644
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


