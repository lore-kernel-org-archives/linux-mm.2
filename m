Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C21F7CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2318E001F; Fri,  3 Oct 2025 09:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05558E001C; Fri,  3 Oct 2025 09:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC2D8E001F; Fri,  3 Oct 2025 09:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 639CE8E001C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:42:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 149AE5B6E1
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:52 +0000 (UTC)
X-FDA: 83956918584.30.60CA211
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 42A9D1C0012
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W0MWHhR4;
	spf=pass (imf20.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759498970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S90OJp6nDTn7TMN9sQFl21M5wwKOd5IMR+vPEuCvBrU=;
	b=lqZ7e8M74NhDcnaIiCMtZJ4Ft79xlLMyl13oo+D1CzROrfCcdL4WAHME+sZH6IGBTQX3Cr
	fHt0/+RaHKX3pZtn384/H27xog+EtoClqnGCAvbs0rR08xG9t/yYFtTPe3OAIR7DCcuNfp
	UJd2Yc8gXjjmUPwMDpEKJdkAlRzCHi8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W0MWHhR4;
	spf=pass (imf20.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759498970; a=rsa-sha256;
	cv=none;
	b=IlXHMO/5kO5E/g33VayBluXyhqSrDrBCXNURm9YLDx2/fhcaRRPNEbrHG9QBpdjdByAhHF
	9U2Jm694Qqz4wGQ3kPzlnCbcSHbL3ryUmQpdeHG6hX2TWEx0qTXKcNYXZkhOHPtzdk1THI
	+8M9Sl0J3MZFUtDmUAHg/F7psN8FEgs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S90OJp6nDTn7TMN9sQFl21M5wwKOd5IMR+vPEuCvBrU=;
	b=W0MWHhR4p9bsB+JeKvbkN3FEDs7UvH8JRxYPdcG4BLh3N9GOhur3s1hEKYyMMjdwlkecDv
	Ja+BLkBL9Gc4nUOanOvuW4DUUp55k3AHrYHhwSqgkDfDSeTX7IUKW2cJg4WH95xsYQ486N
	nGxSOFz/12UI/4LdG55lMm/r7Subu9c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-s6ctFc9jM6eOasNtT3hq9A-1; Fri,
 03 Oct 2025 09:42:44 -0400
X-MC-Unique: s6ctFc9jM6eOasNtT3hq9A-1
X-Mimecast-MFC-AGG-ID: s6ctFc9jM6eOasNtT3hq9A_1759498963
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAD99195609D;
	Fri,  3 Oct 2025 13:42:42 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8111D19560B1;
	Fri,  3 Oct 2025 13:42:41 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 6/7] iomap: remove old partial eof zeroing optimization
Date: Fri,  3 Oct 2025 09:46:40 -0400
Message-ID: <20251003134642.604736-7-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 42A9D1C0012
X-Stat-Signature: drsgfxeff4jrxt7ngf1m9wsyhwu755x3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759498970-234404
X-HE-Meta: U2FsdGVkX1+GUz1rhVaJsD46o8R7MjyG6M3+9bdtBaxvRst3Fl7lBoe2HNFYMn6JHGasg0kBwVvPRk/2WW2NTe48nH5oQZzB5Rx/asG6WPer3UjvdelN1TWmcQCwdfKz4EhXo33NyrokVSygvQCXQNu/AchRSpv6j4V/MHV6tV6M9j+iO36zZGQXZSqrpm/iuHkjLt+WqCCoguzvyeJ0UPmTcWwppY2mN9IKqDfBXzI0Xl1LeQuR6UfptxZRg8Drcy4+kq8Ilaf/vNqWrrfdBZkNyDKf+M5c+VcKHcsShjuiJP2pVfQdNtKxrrDQHQbaqAAiOh9EzZjZWH65elNbXa+R0MYMp1gwHyH+gdV7MXULbimJ3ePjdWUz00cGTyDjsiSkYY0C9Ojo7QXNmXyG8Wgatp4KbqcCwpZRoBIxiQvDRPig1K9peUFZikRZdCZSx6S23Z1GlHsb3uPCJ83HQHK7ZipUx0LiOHd9rFC4Cdr400XbUDu778adjv21VeKiMgPqlfg+OaT3HQDLKGnE+2Wfc7e8idrJskZuW7zfj0phnY6YPwB+NfZTYYMlUKRU70IXWgJNozKZBfmYu67fRji4gLiGTvYbCaJS3ytOtkbEaiHOrcoFlJuIFIsZlMS3WScGP3gzrFpta3M7QXtEMsb/ELgZGy3H0slL2SglkARWWko7LJ/hqRk9Z1uie55LNu/joAJY142CUgas1vtBYoCHKNKZVI1C0EvmUlp3R3oPQMwuLIRUvNwAaVu22mgWLXO/CFMLZS4nor9q8ga9Be1zalePzTMRmw36Payo+JD63NOErPM9vodO59q54cb2UXGMHihSrgk8jlBctMWe83o7HI5XS3AE6h6pJ325mIktL9TwXlJL3B+tKtgReh0qv5i/NybAlZEQMUe6xDBZlQr5XU5OH5sgg7hpu5qYeaqTL20vxTGpv2C8IBDzNuWCI+GXvUolBFlguPVzoYD
 0+PnkpWf
 xShqa1C+baaWiWBTvB9SDYP8ZCWW2xfY2lymIEgkTUHcYt1+CON6QdtgYqukbF6qv8xLaCsI6/C0TUnFvnn5rht3ISysONSoDwvKgDWQlfyXKu+nKy7pTXcYLcA5Tnzk2bUEOoHIiDg+qXz9rbUQ970oO/4CzPFJ6nz/p3NS5UetdQLh+o9+++fzoSFgt82TA5THbz8CbFPwvdOa2VBiIKKoz94Fk6aBaVwpZn4D8LvQhGs1WtjaWUtgZxoxMrc7NJYqAHSl1cwgPGdFPyloSpExhDN1lVmQGZ/KfYToYO5L+g6UiEa8DMn/PuZiataA6oHLlF0YklQDqXNAKWnNIWxFvW/fMT7XIT7fm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

iomap_zero_range() optimizes the partial eof block zeroing use case
by force zeroing if the mapping is dirty. This is to avoid frequent
flushing on file extending workloads, which hurts performance.

Now that the folio batch mechanism provides a more generic solution
and is used by the only real zero range user (XFS), this isolated
optimization is no longer needed. Remove the unnecessary code and
let callers use the folio batch or fall back to flushing by default.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a830ae5f5ac7..51ecb6d48feb 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1506,34 +1506,9 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		.private	= private,
 	};
 	struct address_space *mapping = inode->i_mapping;
-	unsigned int blocksize = i_blocksize(inode);
-	unsigned int off = pos & (blocksize - 1);
-	loff_t plen = min_t(loff_t, len, blocksize - off);
 	int ret;
 	bool range_dirty;
 
-	/*
-	 * Zero range can skip mappings that are zero on disk so long as
-	 * pagecache is clean. If pagecache was dirty prior to zero range, the
-	 * mapping converts on writeback completion and so must be zeroed.
-	 *
-	 * The simplest way to deal with this across a range is to flush
-	 * pagecache and process the updated mappings. To avoid excessive
-	 * flushing on partial eof zeroing, special case it to zero the
-	 * unaligned start portion if already dirty in pagecache.
-	 */
-	if (!iter.fbatch && off &&
-	    filemap_range_needs_writeback(mapping, pos, pos + plen - 1)) {
-		iter.len = plen;
-		while ((ret = iomap_iter(&iter, ops)) > 0)
-			iter.status = iomap_zero_iter(&iter, did_zero,
-					write_ops);
-
-		iter.len = len - (iter.pos - pos);
-		if (ret || !iter.len)
-			return ret;
-	}
-
 	/*
 	 * To avoid an unconditional flush, check pagecache state and only flush
 	 * if dirty and the fs returns a mapping that might convert on
-- 
2.51.0


