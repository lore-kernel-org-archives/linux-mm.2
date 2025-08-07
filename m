Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA23C87FDA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E725B8E0005; Thu,  7 Aug 2025 10:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49498E0001; Thu,  7 Aug 2025 10:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F0D8E0005; Thu,  7 Aug 2025 10:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF9D88E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:43:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C2F3C0EBE
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:33 +0000 (UTC)
X-FDA: 83750229906.26.CA6E291
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 91FBA40007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PUpGSAVE;
	spf=pass (imf01.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577811; a=rsa-sha256;
	cv=none;
	b=JKoi5uOlv5XpaBBeDrFB03n3ZyJlawn6ZPVz47D4UsK1MAlzjra2gjEO+u5jNvWxGtbTmK
	5r85gsMMjEWeFJvE1thQcPhWyjx1Czg15rSy5sNBNAA/1dEgMKtMjKwrUdYSkoLqiMR7Rz
	mF0mPE/H3VVfHAWkLsxPD5qi4losjuQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PUpGSAVE;
	spf=pass (imf01.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6bsgRu0WtomGohiulpJYtRNQ0nLYImqeqPxtDZ9pr8=;
	b=E0XfZ9qpZQQGd6T47BTBJp5IvwkMIo/KEoCGvdWdYsinateRoLtpdwr4AkTI7IU2ryusBc
	NkIR92/f6iSgy+nXogb8mxSVHw7CpY5eStRpkp1Y/dKeaJQ2zSjEky3Rj8f4GJLZcMQPrY
	lV00f1iBb1lqQ6e+ulymdVlJ/Fr4b0o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E6bsgRu0WtomGohiulpJYtRNQ0nLYImqeqPxtDZ9pr8=;
	b=PUpGSAVEGj6+X+ywCSXQ3+v74PcnCGV6xQoKDSGKpEqm/cychTbr6yc6EEE4/jQwb1yzU/
	nCVxXOZKfrPKRUaXo8sPvLqaC1zJ/qCfMp8y4JOw7RZqnC8KfYLr6Cf+GQEThwrdPViko+
	L56aBvFvU8qY1wMAptg4WlgOaQHG60U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-lp9y-YsGMDqtmmRa_K3UtA-1; Thu,
 07 Aug 2025 10:43:25 -0400
X-MC-Unique: lp9y-YsGMDqtmmRa_K3UtA-1
X-Mimecast-MFC-AGG-ID: lp9y-YsGMDqtmmRa_K3UtA_1754577804
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D35CA1800352;
	Thu,  7 Aug 2025 14:43:23 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 56EDA1800285;
	Thu,  7 Aug 2025 14:43:17 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 1/7] filemap: add helper to look up dirty folios in a range
Date: Thu,  7 Aug 2025 10:47:04 -0400
Message-ID: <20250807144711.564137-2-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91FBA40007
X-Stat-Signature: pq3rpn8odwshmjg8pumwfy4j8ru8qhyi
X-HE-Tag: 1754577811-696110
X-HE-Meta: U2FsdGVkX18+dfRkdQ+pJvwTFB0OAKRIuiatv8zBTps8x22MK5qYlmnZa7p3nJVnd/t0lUgzKou0B24FxXUGPawkl4PknZk/9CUUquj6c8/vjjgE1KH/vv0l8BBOaSTLz6rYuAqeGrD7Ud3Utky0DIcFNhvoVYaFNmiqWvCsvTYhLG69AHHx2sprouXjFyB6rO2dPm4XylsW82Rz3+DAQQqWDnEDxpGDcBiPMIAt2yKPnuveNSn6zaTR8GMjYxBvdmMvRmtLAK24PnY38jhTdxh22pPIwl8VwA4ZTfTD3yfxkQCwzdHKPHScdikIbtAtqN6T78FKZulJdXqf4i7Tk8JuHWOHD9QCn5tBTEyNLI2ze5o1tdTOUX+hhPt7+x0GQ+uWiA7swcbbUjteXUym70HCBJMyBrBW7dVTAP2QWHKeadx1BKv3CrgSz/tGPBcmNEWhBnYDWd3ydd2zwcSnPrzQN5920tfQgyPJbg/gisSim5h81M0pIcURMpksKhBuomWjEK+Ga2sojb6sgsmCE9A9Q62ErEhTYpd82/7yf5a8zHiNxo2LxR4LbCT0AA1Xa36J476XNhCQmaaMuPYMlW+dRnmlbHq/SPo2KgzbBqQmEw8Itxm50xinLc6Hlw5ADWNv/Q5dHQZ1BlWdWu7ytE7kO4AmSQh8OaYVde2OCz/iDUcqKw0mE/OkduQWsOF1gWLZ0Vs3ijYSRCFb+D/w/3rIJ03anNe3nD4BkXSdPKOvP4Ii62lMEfPwv535ir9Li7mtGFoz/6fyKmaWn4pjjBuFPV2HtqHyAm0bcUvQEQfrpID4UhogsoJNTjoxW9dXROL+e/9MSrbA2/IFVENmdtEyYriT6xaaBCiD/VcnVbMydG3J03LqlgZZg0ax/sHEolLUQ3Cv3rhOpK8wNtRtvgI6pkVSVVKPhLKgJNVGnJkANw7TT2dCUxm5d4/gvMDl8exfkVx7XswtOzJaaNp
 qZiyJ/gK
 GINmSMCSQv7SbgMVG/8x6EiYiexEp0px7EaLLka6KDh6SlO/6NMtvpC21mfqiUI8wVfsHpIKwYAdwj9R8Go6k/m12IPmFIEeSlmPjnOFZNOT8lIiL1cZP9SLJOrTPJQCjabmJtRY3REJIOSBZGpBZ4Gr1eGfS+bbob8BeNLIY8doc3yULLXH7/xN1MgYsWXwYps4oclRMueGrZj1BP0svRyELfslTouAC+nL0cJkft6E1p6z1xISqsKzu3+kxhsGADX4tDiVIfL9zDXfBkOu13Cn4hoVU5nR4MNZC4zxauJgs758C1vjBcnsPYIb+n4jZ4ItKU6D4mMk2g1KL3zrZgdrvU+C4TIe1JeR3
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
index 12a12dae727d..ded8537e9baa 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -969,6 +969,8 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch);
+unsigned filemap_get_folios_dirty(struct address_space *mapping,
+		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 
 struct folio *read_cache_folio(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..dc24ae04cee7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2335,6 +2335,64 @@ unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
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
2.50.1


