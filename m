Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646D1C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6543F6B00A0; Mon, 10 Aug 2026 10:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B8C6B00A2; Mon, 10 Aug 2026 10:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5433D6B00AC; Mon, 10 Aug 2026 10:48:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9336B00A0
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:48:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 980F180190
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:48:33 +0000 (UTC)
X-FDA: 85085640906.05.3E52C5D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 848E8100006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:48:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LaRHbxiG;
	spf=pass (imf14.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786373311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=YI6B4mV3DiQhwKh1a9qqLFnJYHwdd7ck+D2vMz941I3rnPbWj9G8xM7b/Ak7rCX/Wj95Hr
	MGOZDyT2jCflOs6BEe5/sFLcljWwCEf4V4dg/KI1W+9Oc915AHi4M7RFvfWqp4COtP8p6v
	rsSYStKyGP6KViJyGbf5jxajc91ErB0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786373311;
	b=gVx7YlUsc66xDfYaJZLm41ixK+FWqNa0oZnO9jLGWsusVj/0Ksv9NiwNikluc89f6YNr5C
	QjHDWXmVaAB+HiKJSbRhuF2yO5QDsgtvM9BrCw7Jt66KU+meXSBBS8g2nSm1l++PuTHjv3
	zfXhCwWl4hqNISdibqcZ6gtkT73CCTU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LaRHbxiG;
	spf=pass (imf14.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786373310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=LaRHbxiGRXSC8wsYGtxw3Nl3pvMu09Adv8xEFayfmVTxVLCHQg1kTietTocsNHH4Cu+uQd
	uVTiCDN7FFS8xfuB0pVBiajFqlZ5ETwJUeDHwKK2Pjfn8P+FHflJSo2U6R9GL1mEZGc+DK
	bOxGFiGnn/H7vKudmzhLxG8/GmDS/lU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-Px03ACNdNIe1uLQAit8Dwg-1; Mon,
 10 Aug 2026 10:48:24 -0400
X-MC-Unique: Px03ACNdNIe1uLQAit8Dwg-1
X-Mimecast-MFC-AGG-ID: Px03ACNdNIe1uLQAit8Dwg_1786373301
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1B8619560AA;
	Mon, 10 Aug 2026 14:48:19 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4C39D1800346;
	Mon, 10 Aug 2026 14:48:12 +0000 (UTC)
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
Subject: [PATCH v9 02/26] mm: Make readahead store folio count in readahead_control
Date: Mon, 10 Aug 2026 15:47:19 +0100
Message-ID: <20260810144746.574036-3-dhowells@redhat.com>
In-Reply-To: <20260810144746.574036-1-dhowells@redhat.com>
References: <20260810144746.574036-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: RGbe3FU5pqVnnAmFaUycjF-wMhoxRfD7pYrXFZHSIuc_1786373301
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qmzaqg36xikjpixwr7w7gjo9fxu63nzc
X-Rspamd-Queue-Id: 848E8100006
X-HE-Tag: 1786373311-384494
X-HE-Meta: U2FsdGVkX1+kodQ2EaY8bI3Fi8Szi0tHXtT/66ymYQUeRQaGU8JYQtX1X0D/ubNuDk+cAVuuodR3AdAA9AlgB9vMBGZjuhd62Jk4g7EyczkjxrmPRGa09JotfIT5Pm2yZFg5PdUnd1Ko9Zhkoe/u7oj8Wbp7p/xP0OEthwLVzqvnZDX+yFvjufIZ45Fh5MSjbIKQWZLS805xdNmsPNoiWjyJnSXT0LMO+RJ425DI2K7aXkokjNfdvdAzSD7Yht+4BMqqO3DbIALeSmeDD47pj/bWvCkJjAamCPCoynwiT0hotftExwnEckMMgGZC5vkc5LuVTMYlqM6O298jL++eBvVAxuaFgZ/I10mworAaE8biObpmXweFMJOdbLQeWBPYfx+zJRxkFm8sfAH+pzvflGHk922E44uL7Hbtg+MxZnEvL6jiaTUydjlPLPozkD05jbTqePiFSvqiB/8k1gsgVGj0mAK3w9RBAW90UlUQQrPlmZrKuyFqjThbtsYzikD5Njw7Rw5uqR/OUqZroKCavpJfMu22rx77bu7hK4zUGCgHqZxALg5zEXJY9dDkQIGOLRL9244tMRli0YenbbLlJw54fySrvztF48C7gJ5DuWgxkAy+Lgv6CyMpWBiSjXRoZlGBeF8CWIEnfI5NJXPV8i1OzfoGk2bCykW/OfE1+7vZZ/Bdkt6QZ9gXiGggykHMJMg/aw7oiKF3XdMlDBIf3g4QrANfrxnZJvJHHTe+ysXL2BC2WN64PD4pAP4rsaMwLdR21rDsTkJ6ZcK5+1kfJjYsKJfKOtpwIpDQsfJmLHtY8KpTD17C+pNcSD2Qh2vofJBz/9sjg9zMHnRf6WZM0G28qi44VgjQGg/AnY/scKGVnjyAbuiNfU/xtN+CUXQBVBNOKtvnf/4118yq8nHg5uGj9NJQbzNuu9QYhPxCsOjwuou+Q2qqKXt97iMZQj6mMvLI2S6iY+OzblV4W3+
 ZB5PFEB+
 qO+WD0NOUtrcuz2TKOaDno8HSKVsFTucWFiM51jlLVnQdkRlPWWTNr8MoeTz9WXz6uL6ABTs8SgdlTXPZZ8YF/Mrw8JXQfMKAjE9wyj9FEhfX/v8Cdb9ozufXoM612uTIffpe4xoytEGcdgGd93fXuPx/4AqVZFWVu8UAGZfXdLwyAVriTMB2dfC1Ck/ex3CBHJq3nlQtyVPQj5hNdt83cApNAmv8sj2ckIrvwyCL3rXs+2UDg7Cf3kwBIBw81Q7fS9szD4/Pd/1sYIXmkne6N2xTHnbbautPKlbLqFpC4SmbC9ZYbSAH4yX81I8FY2l2TUhm2WJduuKSC/oJCMpzExPdBk3gSGfkTHYSvdQxo3cGwYAL5k3Y2XAamO5QsqkWEW9anQWbJ2dEG13p+ofMC3I/IuZd1wiQHc71hmet/HFh9ilqCdxzEv8EQWf/oBaDSKLsBwdF+GpBUeqORDbeMK4P3bLacieOuz3rlWAdZiYHi2J/KXHNjqYLe26kEGRi1X9VPITMGUJO3Yddz/ZzNIvStMnBA3p8kjXdXpfiLsMwRElm814KQcaCoAXweJlnEQY1VGyiqJxjCfLqxC1fqAxCaorx9qe+3gxo+IRbUD18TqiKgnWX6pA24w2ptAgPChRHxtlbqnz3j+NPgO2WFC1smSixYw/c3GtHxJZFmfqq9m2dEdevZJnr/rKyU1/wZNjrX78zJWFdYMo=
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


