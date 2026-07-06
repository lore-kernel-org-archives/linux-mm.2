Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6999FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3526B00C5; Mon,  6 Jul 2026 11:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D9F6B00C6; Mon,  6 Jul 2026 11:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215EB6B00C7; Mon,  6 Jul 2026 11:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E93096B00C5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:28:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33F3A1A0125
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:28:19 +0000 (UTC)
X-FDA: 84958733118.09.07C2D4E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1243E180015
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:28:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YL16rjoK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783351697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=hxpMJ/+m8cUu28xF4XES6n8uvRwRMuNgyOTsnfqlFafgUhbUZ73u/i1Z6nZwnA1FNYIb2x
	yjy7eSMg439iRaGtRkFC5wuedilX1WdpePzXy7doqHTNgJ8/FX4YWmfkGEzs0gbfMM9SjU
	in6dWhBo2PrXVOeBlCfC99yugoId2OY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YL16rjoK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783351697;
	b=b2qi7Ngeih3Q/DhOWxiHGORVcgg+2sR42Nexg8P7CNRZxfwSQLFaEH+gKCbOlzHD5BT2xj
	xyp+oP02b709xHAbH+xtd++iu3WMGQ2uDEWRtyUeryyoGSK3Qk4Fm8b73Qjx8pXXUg9Sj4
	MRAIdR38/WTAH03M5eaEHgEWsJ8wTn8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783351696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=YL16rjoKTOASPCfBpKZBDq0WuBXYck7f49wpRxTHhBxraQvk3gU6eKAZpoQ/eoCLk1KIOx
	8rw+V7XCTcGj6OGm+gy4+CroaCvkDnj5oG27aUh3miow0kMIm2cWos6QcjrH1GinKBm7XK
	hnxF9pIZWoF8O2/locGjgGGQ7s4HsrY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-QcHcavJwNXO9huLoueR7NQ-1; Mon,
 06 Jul 2026 11:28:12 -0400
X-MC-Unique: QcHcavJwNXO9huLoueR7NQ-1
X-Mimecast-MFC-AGG-ID: QcHcavJwNXO9huLoueR7NQ_1783351689
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B65E18052D0;
	Mon,  6 Jul 2026 15:28:06 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9039E18005A5;
	Mon,  6 Jul 2026 15:27:57 +0000 (UTC)
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
Subject: [PATCH v5 01/21] mm: Make readahead store folio count in readahead_control
Date: Mon,  6 Jul 2026 16:27:16 +0100
Message-ID: <20260706152737.1231312-2-dhowells@redhat.com>
In-Reply-To: <20260706152737.1231312-1-dhowells@redhat.com>
References: <20260706152737.1231312-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: aebgUEpHBKY-M6Tl0_h9foO8_HNrjbmj5j32KcjnVCA_1783351689
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1243E180015
X-Stat-Signature: 9b3o4t8h6mtjcd75mqj9nnr3ni1txynu
X-Rspam-User: 
X-HE-Tag: 1783351696-950531
X-HE-Meta: U2FsdGVkX1/btsTK5/TVjDDccjCx0Wne5sAmjWWsvi62U8ffm6zHB/CEJYAwr9H7noRx6K0ZplSp7lSbWZJLikxRL5K8mflUP2htOzgPKlgnFSt3vF+NKpve/C7kuRGZU8VpS4rdsV9mjkHPtTIezDNQswxayBcNrbcLJ2lws5O9rTUUdqM7sMcetLKYcqsEgp/eFMXo6F1JFLOtCCgDZTolJBVMFS2PQ/8UGWZxfpPzsZaHf7gRMEMjmY60sb2IB9+82oCPyZjBRKbtrjUDxR30Jaex47nQIWxB94DKaIv42B17WCJVtclfCwNui33SsbyEoZ6EG3mBj5YjSMjLlRvEoRkJ70x+yHoKiDtj2DR5LGMHpaN3ZNf8iGnuXpFwEvM9AAln2lBbcprzwchSPp5EkEvwSp4t3OOYKUccuM4Q0W8q4kF6Z2PmflhgdtmJnDCf2ZwjmvEdcLKU+PIQykLnp0svC4TY+fX3tQHPsGmJS4dVVkGk+pSHbHr3pGffrM7netCgTKT3bW6hKYI3po+I3vN/SIOPojabny759pkoYGWfMufEEm6BOAUZCm9oN3gMdZQkw35IE1GGzo8TRoihp55VypylCIn0gtPTZlXQXlyFkA0yuPu+q1QGPpkUBhoOCjEu8UZjNkXW0rgUBox+PH1YG30f+QfT17cdOHan8/VkEoXdJOH6q8pYWJ+2aciC0W7SdAOmNobkTUPAaGZfjxDpy9EBP2fRYTvumZZLCTAb/udTY/FojdO92XR5s0pxyQDBRo1sarhcTy0wFsFL3/RICvdvF3QPy6Szvr/zRwc5zlV+68qXptPhwtwtiU7XZRIGrYl4jGbqA1+YO879FKJmHWMqQa9b2VXIz6GE3m6DDr0yccUhX3l/XUlRuT7+YlS1JD3AagrtcIer014ilJyNS6XuAYnRV8Q0SFUmaYPpN7YtDZlzKb8IxByxxYcgbEaSlevE86sLsRz
 Zr+YWxXu
 idvCCYt6kuGpNcv4VXum/ddpc9d0bnJhLKvdL9AviKIyx0QokhosAYiuC3TdAp1+6tIP6gg/V/ea/2wf58lrkbeIf4Q3qshdLMfBb2lH01+cxdel7D4K1MdNvyKPeL1uyKUZn87gBZEh/Ypltegg7mZkehxhxVzH9ERG8G0c3b5OOe82nTEP7YGqCBa/62n2UDHxRju7BvP04SDd7eyflnAys4dwimYx9z5Cus1NtSQfrDHdj+XR2COV430IXLHTrhtX7YeP5WNJTMXNtYgLdHITT+VeAbq2V7JtmoOayezQZVzuVgrg8TkPnQuhmsT5S5WtZ+CtvJD7HH/G/HdPByLs/3q43uDbm5AZtSr5HFEae7PMJF+RuF27kgNrrCQviPkk7jvCsjQEsKvd0+rD3PfM+IAsHEw0vqvTw+UK1wHpLghAyd2T1uy/kB4MfsDBkCjp1jUBB3HJvN8TgMpZ2T3u0/DVEri8g8RuPEPEm1WtxU5IRmGME32AvJWNLxnTeXGmKorNFe+cK2ZyMxIFcONsRfUATumoAU8UMMW7x6qeKA20zTC0io3gaTxJvz7fbCTEyo3+9q3gBUqu0i6kIp9OFfQ==
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


