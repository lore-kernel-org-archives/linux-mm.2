Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71459C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A448E000B; Thu,  7 Aug 2025 10:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3588E0009; Thu,  7 Aug 2025 10:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4838E000B; Thu,  7 Aug 2025 10:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4FF88E0009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:43:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EEEC116D45
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:43 +0000 (UTC)
X-FDA: 83750230326.14.C315DF0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C2B1A120004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GUze2eE3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577821; a=rsa-sha256;
	cv=none;
	b=L9ouiBMAzKA8f/IeHovMcOOZVhLX573N1aOO371/U0QYlA9E8QFPu9WGG2QORGxVWPZI/q
	f3XOc9Cr1fBxWz2ja8LQO83lDTHTqO7Lk5/ir+vKx4lIkkW/JMboxFqsAu21wE1Od3i0OI
	KhnUH83Af0WOFH9ceHjW3ele9ze76sw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GUze2eE3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6S68yZ5CuJZZY2VXqHIY9kfsBhGeaBc+jIgknqToag=;
	b=Iy3CaRSkT+FinDuvMFsCFdprKvVDmBFaOOZuc43IoQ7OxudE5lr6JbXxgFH2jZg2vElaAT
	Sg/C0ZRlcB5Zu/p5Jblr3tnU0z6tqjzWjOOlZ12ibtZZsn8/NNzDbN7s8Bw5q8n1WkPzAb
	rjJ9/Rm0fihm5pzhWXOH07+YCQirPN4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r6S68yZ5CuJZZY2VXqHIY9kfsBhGeaBc+jIgknqToag=;
	b=GUze2eE3f5sl4mJqNeRYuVJ5Kqd0NhnHizOzHLxFkTu65UOXOeiSsFG1VXfdMQMjx7S8Bn
	6avjd4p7RwZjJf+MJaIsv1fQf+rptHyDXOhhQXwzVcG4VfPgLeEGfUNUbUHvmvMbxZ1A0Q
	ByrgKKsLvLY5Z8LmY6l7DLCj0JrPRZY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-205-gL0YVTPROaGlKXnCuVsBEg-1; Thu,
 07 Aug 2025 10:43:34 -0400
X-MC-Unique: gL0YVTPROaGlKXnCuVsBEg-1
X-Mimecast-MFC-AGG-ID: gL0YVTPROaGlKXnCuVsBEg_1754577812
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 672591954B23;
	Thu,  7 Aug 2025 14:43:32 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 362C11800297;
	Thu,  7 Aug 2025 14:43:31 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 6/7] iomap: remove old partial eof zeroing optimization
Date: Thu,  7 Aug 2025 10:47:09 -0400
Message-ID: <20250807144711.564137-7-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: 96rm8j9eyjznz998zxp8ic7s9rkns8ji
X-Rspam-User: 
X-Rspamd-Queue-Id: C2B1A120004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754577821-977214
X-HE-Meta: U2FsdGVkX1+IquJDDDEN0CPkVJigDtudg07XIGAfSi2GPodBPxAtl9Y5Z5PhUWcFEeygmjZS6v+ey2wLl1AGobcdOl1IqJ2p9yv6uirk0GMq+eUIrmMMe4d9p0EXQlzreNNLTLuWpPrD7qCqux1oIiohegFylRv3NTU6vFbZZ2zh7WeqBJpS+37bxIPQutCgrAAinD0lcKKn1us7ddiRVM+ufJ70bxHE3TsZouU+dtP1kSta7jtFU3om9rbJHAU2uMMy6f8H0YNRDm/dJLcWCZC3QquXpjSKdBrojfNoJvgmDtoutqrxBbOQoboRNmgZP6QIMICXeBJgiqLsTZuAgjeyTwilgjNAv6v4lZX5BR8H8p5mlhB0/jMyN4GFWBuJkA2HF4jJhfKgd0BZQBSXLSIGqH5hrocDMZO4UaqfLlf5g2PxxCDTsnSZujLb9jFfAtej86BA4ZezmPi75MmN/a4Jhf3VSp1NImB49msMXhm0WzrWqnjpCYi5wrXTfFtzev2K9/7nYGnYjPDxEMDA1J//EEr25y1jJcerL7sa3jfFSPrtUGGae/cr0/Rr0DJFn4ZUd7RXN5BLPn0JIRBhP4mI5cjhE1OYnbYcUtJpi1WoSFYVMJ9hmHUgR/4QZ72QqlYZhK06dMoMagBSQuO6kpWxvefGYDKa7fSbYR+QqQikcmVAOlxKABKdVGROHfyJwxBjX6NJM84ZW6E9fPSXkj/xj7pzitRyVJvOnxnnj0XT2gKIBHpgznY3HoENCHfhwupg3rGiFb3HDFUTt6Jw60mVbZHkowpWCQeL95rixYp9bCaB7g8H7sm1nKeQd94tjTqNLluO2cUZEbrXGubSKMW3K27uXhJFbaQzhET7cEs3R/R45JI1UeE31j54UL9ocZrxLCne7E2PYcLS5jMuViNjgRC0jVlzJ7+LOvqvA8i4Co4xHgKUeQyORGhuyxYbKcIalnUlBaj0WyMJx8s
 RPSXL543
 isXif8iq/K++V9ySwFFO+5+M6na76gvKuwNCTAm1C6RpXssjrEyLjjNaUYEC93PxxAb2e4CHwd2ZXYUzANvgl1iLcFl/xA901KHM7Sys+CK8KVnbCEsbP7/eAYAo6EDfduXjfReC8zpR+xIkFnViQB1PWXQQT494WzAt57zFc3WYwEQy5b09lXcG2ZvFXnqNpYI0fsCRcJJzexLYZLu4gH4EORhjjos/RNO8F+xWqGySZ1E0X5zIz7/SzA1pGkzIljFRTPFF1BzCtY1mhLzZIVdI7HImkM2QV/NgnhWXVw8XXGOw+nTbzvEmx8wCtDx7Z38GbR0nhsqw9t9R3R21ttJFlj3cOJ7NvgcRl
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
index a08a341c6f5b..73772d34f502 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1498,34 +1498,9 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
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
2.50.1


