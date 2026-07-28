Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA1DC54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695316B00A2; Tue, 28 Jul 2026 16:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666AB6B00A1; Tue, 28 Jul 2026 16:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B116B00A2; Tue, 28 Jul 2026 16:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4036B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9FA940414
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:19 +0000 (UTC)
X-FDA: 85039363038.30.91659B8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECAEAA0014
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oo00+iJF;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHllHAYD+554jhDmr6CAyg40twiId7LXCrXkJDYooJQ=;
	b=LyfOVVz0NQZ9m8biV4+GR2V8IIv7kECCaGAZgkZOOppLZVWijUua2gCr46Pw/i5tR28/g+
	Z3wBNESXO3k8IV/DqzEJBlRe+dbDjb/a9wl4KWNkcOSDBDHohd1bdEwslKWP025+jJbWOT
	Rns59usEtVOb3ZGizEwOwvhnmb+Tpgc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271458;
	b=j5BSLK7GPihxV2AqrlblxSbC+rFI0IqAOoPlYMaM3gFXjIQZa/ccQ1OO6e+cAGPxvhkftD
	QNbh8H0hIhaLTW9m3T2b6rGT60K5LcmRPZ/xRxWIw6m4BBryHVnqya8Tb/cl6zAETFzLCU
	ZxH5vgEMR+zRbu9wKWNzT4fRxhjOCgM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oo00+iJF;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=VHllHAYD+554jhDmr6CAyg40twiId7LXCrXkJDYooJQ=; b=oo00+iJF/oZOfT62O7jdcjXrD8
	59ppCTLYc8F6O/VTKGNJRlkk0edQfalqMqOgwFc7garRDyOkSHRGKOMitcArgVOC1ScNQx0d4IDvY
	P67LR2o1FW8T8k+2QGIhJdRSAOsJwxnpM8Dz7bowvimNoxuj5ghmnMewVbRU1dxvE6bvBU16xaAzB
	OSLK0BjX8X1qIKVlG3jOh/uo/39jGacBt4bQRGQ8nXTOn47tx+ngG0q3PqrDZEkxfTUbY372pWaBj
	Y6iknI2Te++RgnUbQGzc8pdSzdNawpPglWjiQ23OpT1K/iL9aOIJjJnY6bfEZknkiFwE/Pnng/LgA
	HVP2LhBA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeq-0000000EFX1-2MZl;
	Tue, 28 Jul 2026 20:44:12 +0000
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
Subject: [PATCH v7 12/13] filemap: Add support for authoritative mappings
Date: Tue, 28 Jul 2026 21:44:04 +0100
Message-ID: <20260728204409.3396238-13-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ECAEAA0014
X-Stat-Signature: i7kkruos6xx8zxkmehcdie3qq36qs67z
X-Rspam-User: 
X-HE-Tag: 1785271457-237723
X-HE-Meta: U2FsdGVkX18d3+Narw/1fiFv8q7SxKwlQIjoAJjV7pKG3uyH908b2d1k9iqEwwL9gxOSVtA25Y9dhxXuyzTWP6klczSGHKG5ZrTe0l5fGMIHTLLJkZYioAgl8VaTAGEX7rsiaTV8oENQRw+ZpyrKEANC3ztNNcSj8J8BdIrablZXb9Xd4xeG6XwFtiq8tvFMHE9N5BUlUyAqSIMM+6TXq+L6Ruk7CxSmXRerHaV2dZEMUJIOMhJsgAmk1OQerc5U580UUfEaMP094Z97w/jLK9k+EOgE9gjqV2S9gdgAOLDiGqlm+vUdZFsizYr/gVE2jPfqc8rR5bWvgYCWQM6WgKMbnrIs7E5hvDnkplMQhEHZYuf2XhEPH5XBj205b/uz3gnNr0rTKeo4zWT1eisCutpehHRt2XaUSf6mh5rFGaffxUVVSz0zdPkILABDwBi4Uzmv9XjikkXnRfw4KnzqiEowtwkoJCSAQPE6UcusaCUvO90WvK+v1OREPZRYlQJs/27tIs+MoQHCE+2eGaatjnm3c+APrDQ+Rggx2qaKdZdoLYY7nEa3JeExA6mzOyS3C3zJ5owNHVnQjqpDDtQjdMt4Z5+abZSZoST3HFT0y8wXsdxnWnD1KiatQ1qEEGcTQo4FEplnmtN+wbhixwwX6nfHTLYJePWwx/rPxhHR5dkcdgbyFt9Bajr1gZWSQ+StwgIj/lk7pAFF8SEH9O6pW12PqR6BBH9ZzcOHH+0LIlBP0dZA6LqTLYOBtaIBRZAfR26n/+Qzm+1wYYxDnY4FiGd0Z+39y4aihOwYvqWZnQdstcTwo3+vyWbiIxrpK3kN6Wald8ja/fQyCcOajNCiOb+FYOgfxkgVYTPliabEcJurp7ZPJzip2b04qu6vcH230/U18cm0bWyFS0GRdacLootyVuSlYUmUG+B5dPNvQKyMi5MQdwl0gePRywixv50qRgMBd/BuRlQ5qH0gulA
 VaV9XsaD
 pEvz8GdC2GNLO65sPo6xh7sxg1EwCrFAv6K4sVIqM75q47bs5K08kjYZVbWTScg7mslhxUd/cFPj51s24B0ggNBgFagLwbtuaIrAMIsO+nCRJRmptc0ijNUtAwV+3ele3fLFpn4EiXCArQ7cDfQWpkrENFL2Ujt6Hq0EYe7c3LQgFcSswhCsHk0TlLK2prlwZPAr+pGJVWua7BvahxVjrbZCVg3pzODlI3oj/Nmpp3VU/XW9kqK+7le+2JfBLfcfW8ycjHDNFuMaYLrfNz8WBBD4RnV0ZNv5TkRC+V6/e/bvK2+1N3e1X5npHqntmrFQ3MgDIk7Xs9LCcDfQ=
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


