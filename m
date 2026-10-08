Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37030CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ADD26B008A; Thu,  8 Oct 2026 03:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283A46B008C; Thu,  8 Oct 2026 03:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173CB6B00A2; Thu,  8 Oct 2026 03:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFAE46B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:44:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E522404B4
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:44:14 +0000 (UTC)
X-FDA: 85298670828.15.1C1A48D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 71D4D40002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:44:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LEYr7SLy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791445452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=DCkyk7hcqTIaQHxiIFsU4/CQtQzKmW3aWQMGQbF1ehJhb6P234tVXbpR8yWd2g3l+zTLx0
	cFXPrR6wjq9cwIjlQ3u8/PQn56VKQ+P/K+Mbb9VOdDjUMTBlD9XS8snAODpQ/I7qdNq36b
	6pmA8di46Ms9Cl0nJFEbPtWmU2jOE2I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LEYr7SLy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791445452;
	b=4OrKyKERXP9D+cbn4BSJSc50h+V3MIhzvG8AfAFsL7bxWxHO8V8EQtMz3P7nIuBmtjTkFw
	jbYO4Ze9w/t+PBRdBen2Hh42Kh8HuNyeRLNnFT31kgBPeQZyW/gjj7ZF2wIOF2mJi0n27s
	xmcArWQTTk/8F3MM1JGy5P+tfPTtTYA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791445451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=LEYr7SLyatgxa+rLRCu+p9UFY6Pr6MuAQ2Q8tIEVDyX0S3g+Uup1g/SObTloDuDSHyZvsH
	vR+dTukQnSQjZPilfhKxAI31b9JArjXwz1L7Fs57NVQQS8Y7OFjyaB+PdSvtq61oe/vnQD
	FqqwocoLAs6vwD3XDWi2lBM89F15+3o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-16vGR1_fOq-m-BIuCSPT3g-1; Thu,
 08 Oct 2026 03:44:08 -0400
X-MC-Unique: 16vGR1_fOq-m-BIuCSPT3g-1
X-Mimecast-MFC-AGG-ID: 16vGR1_fOq-m-BIuCSPT3g_1791445446
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 26CC51955DD4;
	Thu,  8 Oct 2026 07:44:05 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.90])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F29A11956086;
	Thu,  8 Oct 2026 07:43:58 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
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
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v15 1/8] mm: Make readahead store folio count in readahead_control
Date: Thu,  8 Oct 2026 08:43:37 +0100
Message-ID: <20261008074346.936909-2-dhowells@redhat.com>
In-Reply-To: <20261008074346.936909-1-dhowells@redhat.com>
References: <20261008074346.936909-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: ZAD8r0vNosZ5T3sG8Ut-v7coJ3aeJgRV7gvyv0zwuqI_1791445446
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 71D4D40002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: tyr5aymzmhx8e1m1mtsowf6hdnjmywe5
X-HE-Tag: 1791445452-770590
X-HE-Meta: U2FsdGVkX1/ePClEJXXF2Za0o5AB2DpFKb2RHAkMVpFqSVZcjqxCbYItDC85BQp02Y9m3Ipn3tV/vmUrVY3kcXMa8bTsP+yroyIKTFnOW018nxlojnVLpoaT+jkfNaaUamDMaOVgvAAH0JtBUzrXMPvk0V+kUzxtrwBpbOYXyJyyWDESTN20/B/iIywdc0hZVzATJGNIJd+pDi0GYNbh/XxE7TVlfsgfBFriCgfWqMnbgUlT/zD5vCC1PMIOYBX5FRGvBhbrLHjvWFHa4WQOm/WzQzk9jo1znciivWjt2T+SHZzqYr7rIwKj+bxN7YrXMuvLcAOc3EcrbySplAMQaKaMejW20AFOcQqchGdOyTsS2HGomhViLgIXWBrXDg/j/eJ8Wd3qAtsxQbrdpKCd+VvVlA5kSxXoF3K/I+Zy78CouAkCU9V4y61aG90TxFihd1TUwgu6yrF/BJy412RX40jHftfCeirpV/9DakCVZJRhoyM3xcle0+/Sm6Mb+NrTWrKuBDGqRQpZQpNARRTJD/toNClg/dtrl6vGW1zOkVZ9FZbVYt9EA2bRNFG4rLUUwJhyykCdby3Nqto0xLYvWmMzri4PYabPn1YQnMRTp9fpbfmC/svwjH3yGxefwvVvaBWc9xDA//OTQMy9GMcQtx3KidErAm2dUvKTzetubx2CyStcPiBRQ5zJFt+xkaRrgaEUvwqon62Al5qjPssTluQoYaeKK2YYJH/6o8M4QdeKVXzgSC+7FHAyKuMlbXE2NpajkDsS49Jkii/s5NIYsbPqQvFkdCi+Iy5jBjaySiyR+2iYatzCrKptpodVfV8OY0N4GIZqre8/76S6p/+itjqR/BEGnhhCsd4Xoa2MJ4Ezk0UBA6cTEzGyPwipmlvpsi0eaQTRnqq6Mwtdm/OIMd/LN9+ekQfnczATf2PXawBCsjOPlkvPrtAtcNYg0Gsp+A47EJTIe4x/z19oz+C
 FGYUwnNx
 vlTi79UmVAb0qzr4tbO/efk7dHlyo5gzRiVsLEJOoJ385suyWSnW9ynGTmyQXmY0rQXaEVNuV+XVBgkof99TKValB6a/MOuqeJpziHmYdLzuIjs8muX6Z31LH4mEYfo3Qn5pQ3zT9wZ5jEcaYO5gBib9lMDzVX88o6b12aoF46KTfAWLdQWAODR7f2Ona/RWT9TTT5CIDk7wtNIlTAaccXpbmGEdJXj3ldRZP2ATVPM2Ymc1gSnp3i72q5Rg3NXg/+vUpIk/2xoEjjwUeU0L6WPJRIqKT8kFcs+vorWyI59Ak1gWPwrIHzqNMuIDiSQAvk8MAaMwr0byXrV6eiN3fPrf2FxGrI5nT3iWfMkI0D9cqRGDFVsqWmL+rjaJn5H5qsyKUhZkwQNc3yU/uRaR5hdVBA9M1bZN5Gvb3hUNSaXNsh3/midqKnEJ3L+gHwkD8d/L4CrgMJtpiOJed7HC9i7V4Iwrp5rpEkccocD21nl0BUFuLCVIcF+LoDk1umQRTOPXrQxUq8xIjBkcsCm5yQq+o2MmN8KcjrhMft6BOdFtx/1qQ6Q8yxTPc8nPzuKy/TRv6e82y4/hpGfjDiZjbaMuwWTSSmYzvme2eZXykdjX+gxQswl9h8JKFvOjk9BGz2a1jMn6+bBRqz0kLrSdkbn7EwH1fA7M0HBfAC2XWNLd52m2m+KKxlcQzwsVwW6EJ6ws6EceO1aLch5M=
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
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/pagemap.h | 10 ++++++++++
 mm/readahead.c          |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..b7154b81d0d7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1411,6 +1411,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	unsigned int _nr_folios;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1590,6 +1591,15 @@ static inline size_t readahead_batch_length(const struct readahead_control *rac)
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
index 6e5563290287..196542fb1c93 100644
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


