Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3326EC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9616B009B; Wed, 22 Jul 2026 09:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1126B009D; Wed, 22 Jul 2026 09:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2B76B009E; Wed, 22 Jul 2026 09:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E623D6B009B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:03:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64156C0188
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:43 +0000 (UTC)
X-FDA: 85016429526.12.4371CE0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D4292000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ey8JmbyB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=Ol/KAnhQgcjm559wsDKerbFZbOwv+4sX2f9lYvU+/UDn068FHi4UVFMrbuavlF7hJufh0K
	CQoO+2onrObsHTZrhBd/3U/QO/JNg29S7H+S5v1q1pgNu/QaG/zLZaxaiSLvzxQ8W2zDHJ
	UsEytPjY4eIuoiT2U9qpt2fkIEBbTCs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ey8JmbyB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784725421;
	b=zzy6aEvijpyj7F9bxv2mfprqy9DMcdZrmUMGrFojNj5rt+43sBbMi8nTCE7b/Cc2MAifGR
	fE+ZGIK1JwY6vLsazo0ZmSmOpOjImyDC5/iawGt8LiFUVud2SpztE6TrAaCGg4Yh5WZ4pM
	+NJhRwUWgXFDFYKNBC4862iN4P9vaaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784725420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=ey8JmbyBdVAdY3L5mBWg9YKEG5R6AyAqZdms6E4IE8ITZBchno0bj8lWA7qQu8XKY4RJu7
	tsifERantFExFs+IJ3aqzLw2+IYBLyE1h6vbltzQ0/+lfMK4sa9Xss8ylA4VGKVWvP586p
	UB8UBpI73xZTJzMComfkpfg2+lPwoZA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57--LamWEhSPLKCLmLxciHA8w-1; Wed,
 22 Jul 2026 09:03:37 -0400
X-MC-Unique: -LamWEhSPLKCLmLxciHA8w-1
X-Mimecast-MFC-AGG-ID: -LamWEhSPLKCLmLxciHA8w_1784725412
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9726718E6A67;
	Wed, 22 Jul 2026 13:03:32 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A8EEC1800623;
	Wed, 22 Jul 2026 13:03:25 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v7 07/29] mm: Make readahead store folio count in readahead_control
Date: Wed, 22 Jul 2026 14:01:54 +0100
Message-ID: <20260722130218.78958-8-dhowells@redhat.com>
In-Reply-To: <20260722130218.78958-1-dhowells@redhat.com>
References: <20260722130218.78958-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: HK3UiJ8vRZrrl5TqYXf6sGOCxPBy7H8MGHqIISa8geU_1784725412
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D4292000D
X-Rspam-User: 
X-Stat-Signature: hykjq569kt4pxgta41iyat1g53mxm8q9
X-HE-Tag: 1784725421-341363
X-HE-Meta: U2FsdGVkX18Q1f3wYsnudC+Pv8DyHPlOBsJiQjjs7nQmGgSvZdYPXjVn4mm6+KCASpJq890wKpNFHwDrwYMNTlU8zdD1NLORQobJORF2D4+WLZ+B0KWtdYgVPG/BtLnpLqtwjVaQQovr/odZickVlvReWrvI17P7kfm/aK5Xds8t53RQP0lDgjM/jRNx6gdMib4a0qzz6Ksr1u0kRZpJZjiH8OROwd5J8guj+d/gp1w6PEqYFHeczWzrx8fHrqilsddyflhfFqu++GxsEkgHFz24iyAd/LP0V2PlyUTeb6zWFTkGerPBJ8EsiiAxYAMUBkPrGeAJQ770eVR56b+YdwV0tg7byOBLiSOHy5FRJaQhKQPnbRloBQljxiAiuB+0oP6le5g1pEXNpG6PotYj1xR3jgAmfriVHSMB9U6PfpkxdPnCh0G0fTYBhYzPO9E20VLChWISjq0S2UP9tJL1j3cSvxaO1hFX1V2ZiJ7RVn6dedEPbwRspQXbS4SVI6Ec0xWRMReOd3sTIAFS9PvLESOfV519YK3OO3I7Jggwuv0uAo3Q3LGJq7PDAnhaLXKLPhzvPSKsXm9sl5UFUV7E0WyiFkTqEQeXdT4ffx6PzKAw4mMXy1hQBROxiXkBRtKuWd8WlAn6WK4L2o/1ABcTIX84kaIAeQ0wkSD3imA0H200qL21JJPqxxNdN3saj1ktWhFx8x1iY4RW+hCl3CpnjvSBMKqqGOCNlmFBlunWYjXzl5qIPtAIVg8V6vAvy2LlgB8hJFRVrINhVJfv6iZIYsCWBcZCq6foVf6zayQMKX8YQfFK1w6+JjfIrYml9k7s2drO8ZRuSbTRSie/Dwkwi+H/bfX1wC2uKKJ1SG7/f1ViNqqtzE1ZRhc2puOznIEnYCzQc7u4emupwmF3SffMz94Fnwy6ZmeZahVdtACQwEqqMSFmV21aJZxS/eAmgpHxPUUaPftM5ebckMTYAih
 VR7u5Ngl
 VoU8ognz8EhumjD2jcaD6/DHvSTxUG0wcK713IacKubdrEHQ6248tU585MhLitL66yrbjRy/+lDgbBBhCdQv24jtPA6nyBZXhS5nqrbcV/EVmCcn/rGpilwjfR065NcRQpc4ii2o8tDDREb3BdEDGG/K38uQiq/gQQHGa3UvwCfWKlrG5RKTke3q5fLzrNT+QnlxO9SjH++vQ3P7eNQxYQGXxq3RxUMMjn+AEXGS0G33c41qr+55orFXy+TQx51sjoscWtnQB9niBNMrqHNlPYxTnMzYyLWOa2ctL9EWGOm78LJf4c4U1xaW1iRclIqGVDgSvFAH6Xuxz/irT/LInX9QhuFXrlP+hG4wCgGM8mgt5+UUmiQv3uT4kUkFHiU5fKe9fqihjhVp712YeMMm1nb50Anq6ulZ3w9HQ6DQZuegQ1yg/UYh103bmWNAPQr1z5VzwswTsDWM9FYy23vPssAbxKDQI8XcNC1gcwgx+KGBH1o2NrSDBB1ebZOULBOD2sS2avP6joC3XooAW5juX1mjN9CRNSjb1/OvpKCxujlpJHGWfnbO3NrSHQaTJ6JxK8trDb/jttwAmA733aI2Ab/fspXJw2uoD2ZahNCnNQYfq/x61cvyVLGCbeXU5kTmCLHVioAWtvWa8a7a7xSnPgOIp3AEIAzRjfcboFZr2YA8O5qxE9Qu31YKWhKq9jZaqtLokDrCX233F2JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make readahead store folio count in readahead_control so that the
filesystem can know in advance how many folios it needs to keep track of.

This is cleared by read_pages() in case it is called from a loop.

The count is accessed by the filesystem with readahead_folio_count().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/pagemap.h | 10 ++++++++++
 mm/readahead.c          |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..e1e51bace388 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1348,6 +1348,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	unsigned int _nr_folios;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1527,6 +1528,15 @@ static inline size_t readahead_batch_length(const struct readahead_control *rac)
 	return rac->_batch_count * PAGE_SIZE;
 }
 
+/**
+ * readahead_folio_count - Get the number of folios in this readahead request.
+ * @rac: The readahead request.
+ */
+static inline unsigned int readahead_folio_count(const struct readahead_control *rac)
+{
+	return rac->_nr_folios;
+}
+
 static inline unsigned long dir_pages(const struct inode *inode)
 {
 	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
diff --git a/mm/readahead.c b/mm/readahead.c
index 558c92957518..069ded56fd80 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -188,6 +188,7 @@ static void read_pages(struct readahead_control *rac)
 	if (unlikely(rac->_workingset))
 		psi_memstall_leave(&rac->_pflags);
 	rac->_workingset = false;
+	rac->_nr_folios = 0;
 
 	BUG_ON(readahead_count(rac));
 }
@@ -303,6 +304,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		if (i == mark)
 			folio_set_readahead(folio);
 		ractl->_workingset |= folio_test_workingset(folio);
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		i += min_nrpages;
 	}
@@ -473,6 +475,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 		return err;
 	}
 
+	ractl->_nr_folios++;
 	ractl->_nr_pages += 1UL << order;
 	ractl->_workingset |= folio_test_workingset(folio);
 	return 0;
@@ -822,6 +825,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		ractl->_index = folio->index;
 	}
@@ -851,6 +855,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		if (ra) {
 			ra->size += min_nrpages;


