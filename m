Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E30CECAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDCF8E0006; Fri,  3 Oct 2025 09:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B57F8E0005; Fri,  3 Oct 2025 09:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34228E0006; Fri,  3 Oct 2025 09:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF2418E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:42:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D6B54509A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:41 +0000 (UTC)
X-FDA: 83956918122.21.73132D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id AAB7D140011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cseJeB+l;
	spf=pass (imf26.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759498959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RhaOcNHmb7LPmZ0Qghy3zkBE++ecIdVtQmAjZ928Tfs=;
	b=CpauYJeNkWTikC6RsXen4VnBgKXeIWdjGoD14qpaovlUjFMCpNLvnEZgV8iCoGeuSh2jOa
	Mucpd16SGu7OgRuD9JeySzOKEMDruYYwB12sqY7pnsPvGdP7ZsZuAKhwm3u9wn0CtEB7RC
	eCE1lKnyvl9NpY6PUIeAA+LRJuVbfs8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cseJeB+l;
	spf=pass (imf26.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759498959; a=rsa-sha256;
	cv=none;
	b=HlHJJytRYY/PrRrPSJLIgnJzwIiziYBrk3m+j7UmeUjL0g4pOiEk/0vBwMsQt4NvPohRId
	06WjIJBYVruv2YkZ0olvGufCx4THeNWrWQ+ZNlL8VpxWRbyYGnCcpVnZmLxFu2g1qPClu8
	IhIuLHtZ5Nx49QUInQtfOTDg3kOuilw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhaOcNHmb7LPmZ0Qghy3zkBE++ecIdVtQmAjZ928Tfs=;
	b=cseJeB+l18ma5X7czRngbFByI0Af6fUEYjAoAhkfW1n9mOxmRmdhu4k5NOqnYClUpyKM0X
	9yfnndZVHkshvKCQ8L4mgxFo4T+7eXDy5jGIbbwDSqNnRdfVWZoyZoBapyiOaU4/HUavYv
	T5v3abpiA7CFr+AagO10SAbrytwNQ1o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-Jb_DkJH6NRKWU0-g9B8PGg-1; Fri,
 03 Oct 2025 09:42:35 -0400
X-MC-Unique: Jb_DkJH6NRKWU0-g9B8PGg-1
X-Mimecast-MFC-AGG-ID: Jb_DkJH6NRKWU0-g9B8PGg_1759498954
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 497A1195605C;
	Fri,  3 Oct 2025 13:42:34 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC51B19560B1;
	Fri,  3 Oct 2025 13:42:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 1/7] filemap: add helper to look up dirty folios in a range
Date: Fri,  3 Oct 2025 09:46:35 -0400
Message-ID: <20251003134642.604736-2-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AAB7D140011
X-Stat-Signature: 8b7kgkzek11oa53fiirgfe61xb8tst9y
X-HE-Tag: 1759498959-428093
X-HE-Meta: U2FsdGVkX19IbNA6cJ0ePyIeFy2uXgdx0MonpJT9/73JRrEgUF7O3n9A4Ty5HsNLQg/F/OF1YjBR2n4I4649l/RW2QD0WtjHRqxsgLwG+U6/l3F1MiPeR6fYmiD+19Dmb/SWFFifXj9d/J5xx2Q66fYh9yGa+3LYHyePY/xNvqe7bmDF8bo/zTmdkcawECOVBxa2yC03hgeCphUHOPy/wx20FkulRrhVlZdVUZJL3VbzLB0AymlnMHQPP0l6n2IxAHAhyVBZV0xWkQnAfx9IRtRXUFxfJP8rYMVezwn1hTzv/U4HbmyxK0CJskhSF7UdcNzENGTmQosNdgsgV4YlYhmVW7KW/IRw7jhwBUksz0O7A/izT3YE/u4f9zxkwAvNlWjWI+qZPGmmIFQrq0UcIMZHRKMyg5CFwpZrv6ggJ2y+y6F9hS7Wxkia8zKQA55Pd6Z9Hlv1tr7vWmeLRnhZeWVcZDUDghtUOXyTpUns6R1kvCqeWwEYF7Bfg3hyjOolQ9M+ych0Ncq/vwz2lFEd97oqBxzDRo8LCBIe54cuhUC3i5WLJN9UdBhfjgnpYs25gMriLOC38zgG++XZdbBGd70iWGvlsinL9HHyYRjAhNnPJjCRfZ/0uZwF6riYKJ/fmIQlSISnmM1qXfen7WdrjEIqupnD6hXxX7rrpTnQFsB6VYSQVIIsrUJueDZN4SZkXTnBpwGjLupK1ZGRXyk/uTrBDs9dfW+NXbdf2hMzgSze9tYMoWMxkge8+gpipgP1EnwkQ5jItAl6tSKQ7Ac8xZ5EqZ9gZYB4cl0C8tKVX7wAoa4V3NS+O+XDO1HadVRhLUutxAOIa2as7YnrHgrf6I07VQeedJRoEXLiObNli8niXPuO9XNVIuAlR1s38MhiePzW4BVzm++KKHzsT456nnsru68gN59sNwUpD4wPpl7aT9Hiz0IuuOEMEQJRJHLxjZcrl7vaFoF1RUc6dhF
 akTehveM
 TDCGn9BwFLS1zm9AVtN99Ex6msl2i+NLoTWm/e/07vsWDepZWvY2kDcXYf+DD6Edm023k6qthM6nzac7LLegOzhmy/MeAujA2ZWBcvf9kr04VFLNMO4zAxrR3hzyQITkwElzAfWsoE6odTNgnV7VsCOU35pBeZ4hmqwBUb3pDp1YwoS/WTON+j0O9zFMEu7IZJwOHG6gVRsGvKu4DtSj/YxE1uSfZCpkiaOFmvRHvnwSQ1QO0OLuXeFKSpegw0JB9oeB2uhbIRJYzXH7qYci1e4E4GBqyPWMa/cb6n2xogaPVl+LtM3fDFsuEXiNrQJtRyQ/FkgjZI9AYIVFG1c4haWJ1jn6U0wT7b817lmwMbpF/wsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new filemap_get_folios_dirty() helper to look up existing dirty
folios in a range and add them to a folio_batch. This is to support
optimization of certain iomap operations that only care about dirty
folios in a target range. For example, zero range only zeroes the subset
of dirty pages over unwritten mappings, seek hole/data may use similar
logic in the future, etc.

Note that the helper is intended for use under internal fs locks.
Therefore it trylocks folios in order to filter out clean folios.
This loosely follows the logic from filemap_range_has_writeback().

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 58 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 185644e288ea..0b471f0eb940 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -977,6 +977,8 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch);
+unsigned filemap_get_folios_dirty(struct address_space *mapping,
+		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 
 struct folio *read_cache_folio(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
diff --git a/mm/filemap.c b/mm/filemap.c
index a52dd38d2b4a..db9f2dac9c54 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2348,6 +2348,64 @@ unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 }
 EXPORT_SYMBOL(filemap_get_folios_tag);
 
+/**
+ * filemap_get_folios_dirty - Get a batch of dirty folios
+ * @mapping:	The address_space to search
+ * @start:	The starting folio index
+ * @end:	The final folio index (inclusive)
+ * @fbatch:	The batch to fill
+ *
+ * filemap_get_folios_dirty() works exactly like filemap_get_folios(), except
+ * the returned folios are presumed to be dirty or undergoing writeback. Dirty
+ * state is presumed because we don't block on folio lock nor want to miss
+ * folios. Callers that need to can recheck state upon locking the folio.
+ *
+ * This may not return all dirty folios if the batch gets filled up.
+ *
+ * Return: The number of folios found.
+ * Also update @start to be positioned for traversal of the next folio.
+ */
+unsigned filemap_get_folios_dirty(struct address_space *mapping, pgoff_t *start,
+			pgoff_t end, struct folio_batch *fbatch)
+{
+	XA_STATE(xas, &mapping->i_pages, *start);
+	struct folio *folio;
+
+	rcu_read_lock();
+	while ((folio = find_get_entry(&xas, end, XA_PRESENT)) != NULL) {
+		if (xa_is_value(folio))
+			continue;
+		if (folio_trylock(folio)) {
+			bool clean = !folio_test_dirty(folio) &&
+				     !folio_test_writeback(folio);
+			folio_unlock(folio);
+			if (clean) {
+				folio_put(folio);
+				continue;
+			}
+		}
+		if (!folio_batch_add(fbatch, folio)) {
+			unsigned long nr = folio_nr_pages(folio);
+			*start = folio->index + nr;
+			goto out;
+		}
+	}
+	/*
+	 * We come here when there is no folio beyond @end. We take care to not
+	 * overflow the index @start as it confuses some of the callers. This
+	 * breaks the iteration when there is a folio at index -1 but that is
+	 * already broke anyway.
+	 */
+	if (end == (pgoff_t)-1)
+		*start = (pgoff_t)-1;
+	else
+		*start = end + 1;
+out:
+	rcu_read_unlock();
+
+	return folio_batch_count(fbatch);
+}
+
 /*
  * CD/DVDs are error prone. When a medium error occurs, the driver may fail
  * a _large_ part of the i/o request. Imagine the worst scenario:
-- 
2.51.0


