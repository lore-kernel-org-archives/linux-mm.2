Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DBFCD98C6
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6EBA6B0088; Mon,  8 Jun 2026 10:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1F3B6B008A; Mon,  8 Jun 2026 10:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8393D6B008C; Mon,  8 Jun 2026 10:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 713AE6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:55:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22475C0442
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:55:35 +0000 (UTC)
X-FDA: 84857044230.24.250AE62
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00A3A40011
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:55:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O3rMN7WB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780930532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HD9l3rshhdvjF/dR6TAQujaSrodzR3TFHgxLsri2Hp0=;
	b=VyZp1p9Nq2TNgwWHLbGeIriSFxXbVVEzRr/0mQuvOhOyWuACnY5zZeuuqTyMYDoWSUuEjj
	EyGp1epWp1gcEVr0D0gy1hm5PfTv6NtB9LXnliz3WbjYwJMGsEHeBs6vHvwxe8x8YvnGFe
	fHkhQF09Ry7c7nL8MKe8yiWzT6SNPR0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O3rMN7WB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780930532;
	b=xGJDaJloBO9oytYF/QEyhifabADnI2s4HrXR2/vSFmuS94UYZfh3sp0YxwOasknB3HMfJf
	a/biGodmMBqIOYCEnUZF7J5wYAHAWHXNrVHpqb1jrcjkBooHRrLEc6UVekbV5c5jxIk7C8
	HPFawcx0TW5Rw+Dpw4UzlhfY32s67qw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780930531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HD9l3rshhdvjF/dR6TAQujaSrodzR3TFHgxLsri2Hp0=;
	b=O3rMN7WBZeyoYs2SeHoBAUVaQp/NRRaxqC8Sfir9EKTnpDeC5wa5FJw40AtWh3pIYg8Jqb
	Y2gYBUad3xnPAcDx21IH36vZ+Nwb7SNVY6t/0mHS+X1Dsp+uUdugbLqESOs8dGMKcrf3gY
	fpRqNUTUZl7uBHc4bZtXwkwruN36iyg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-X3VTno1NOkaZZyDJ3DO6Qg-1; Mon,
 08 Jun 2026 10:55:27 -0400
X-MC-Unique: X3VTno1NOkaZZyDJ3DO6Qg-1
X-Mimecast-MFC-AGG-ID: X3VTno1NOkaZZyDJ3DO6Qg_1780930524
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA83C1800BEE;
	Mon,  8 Jun 2026 14:55:23 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.43])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 01D9D3008B39;
	Mon,  8 Jun 2026 14:55:16 +0000 (UTC)
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
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
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
Subject: [PATCH v3 04/22] mm: Make readahead store folio count in readahead_control
Date: Mon,  8 Jun 2026 15:54:12 +0100
Message-ID: <20260608145432.681865-5-dhowells@redhat.com>
In-Reply-To: <20260608145432.681865-1-dhowells@redhat.com>
References: <20260608145432.681865-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 22NxIVSmMCCLoahkaMqKY8NhNDUhD7V5WKdacND0y_Q_1780930524
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zh73dgd99yfyp49g89bfcst8e9ztt6b9
X-Rspamd-Queue-Id: 00A3A40011
X-HE-Tag: 1780930531-286802
X-HE-Meta: U2FsdGVkX1+geTPtp0PSpt/wwcpa9A6tgs0Lvp5sdpUk67x9FoB841n4rO0GoZZ1ymK/ialUADqm3l+v/KgAe+SPRkW/ZR26s80Pk/J6lyWmt4CCe38+O4g/zp9BP8qYXZf/gH1rjGQgigyJ/0gti4ah/aITCBxlOpWKeoQcKZEQ6M2R/5gBXIqlKD9xVyO2e2+ZcOmfHXwlK4GXP9mGi14c53/U44h4zml774r+dP9rLS52A7RoSy9s2rRJSVyXzmTmin2e7fuobWt+drh3IuHfqVh/ul6BnGQNCmQ4QWwWwlyGpK4eHLBdDyAgGya8r65wGSVQY+IzdZHOy7V1j2x5u1T7LTYYLZi4jyOnCyhVvCEIYcw3ElJHiZZ0RA6e1o1OjLPFmhzwK+KRH3rv1oFSf7R4Y9sVUB6RgwTmagT7SMImb3+kB2SBLE2CfSucdDxxWt6BkGIqenIaB6MNJUHWfyFOpPDGSk/DVWoLwzqwTSUT2hEYNgUaIbMTJGdz0W5aeLLRAiHjEFWyAMYh1qsubRNz47BEBm898gwg2HdZGB7IouPaP1wT3NJG2LFKEWvhqrsmr+POhO7Wmm5hdM7KyxPS0n3NRoyIS6TK1SFVyXQMV7OU2p43b/xbyBvHLJYjKoaI5AVUXv/2hXUuKW4W6nqsYWSMNSBSxD796xWpx3riFAFTH5uqDI55Y8JWZbseDf8nstQdBYiIEoBWPzm/vA+fewcma3fQk6TnnIZgZ/kZakseXMj9/masRZBAOdRcMyy5I/OpTUEl/gnDu1MFYSv7O3qmLJIopbTJovHjAiq7Yf5WglHN/2EtAiIKtRFeAV7NIzY5tYGi2APXysG6a+jSvPD/vWBjyaVrrFqonUlUon1KnZoNe+yizu2FJYuYax/FZqKnyZ4LoAiaq3rvdkKNfVdkxO+HHC4zL+lRptHR8EW6NFi/xO8LtycfBecSDAyH9pD80vtuf1m
 dFKEyaIc
 3ncb8NFiti7w2fUYRphgnZ+Y6gJJ++khp6an22etxmmpb8FaI/IP/qMTP7k0x3jdIeJ0+jhvwqi2sDTTH+vJQygOxVLLPBp/gNPVE3U/EXFCPMPFyZTgGGmvBzUWqgcLk9eoSoxlHZ9XjX+cE7DTzp2GUvw/eVXb+HPJh4OPq8V5TE6wIIpmI7cQFv+n4B7tO58HL6rsD/Foh5r3f7a+r1T8UkboJ0E+mgQ4WA8zD10Q06YeYLtCVrDdIPeqvKR4uzyeFdfe6AVACv5yMllYfSqkBzX7Amf/yk68Fz4pUn5Gz/pYxiKDaTgpajkgemXxfc4KG+GnzK1WMWgzqkJ3eSjBI6kz4Ra+tHfgrMMTWxs2p+UBpiG3Xaz2QD94fZ7FDCsBspatX2eFG0vdVu6KavbiIOHdKNotJwphHcoq/AGHtvPAc1q/eTCzDzKFr8JmM1VXe0mt0l8QQik9rPEtoA4QhNgZI4bXF3EdDo5AQ/clDCWJJWU/i/ushxU080TPUrs7aTE7RGKiaBXUYiRMYbIfSS4sm8Uq9aDIHMLWJYC1OtF0=
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
index 31a848485ad9..1de60ecfd6e3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1350,6 +1350,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	unsigned int _nr_folios;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1529,6 +1530,15 @@ static inline size_t readahead_batch_length(const struct readahead_control *rac)
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
index 7b05082c89ea..eba194f4635f 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -177,6 +177,7 @@ static void read_pages(struct readahead_control *rac)
 	if (unlikely(rac->_workingset))
 		psi_memstall_leave(&rac->_pflags);
 	rac->_workingset = false;
+	rac->_nr_folios = 0;
 
 	BUG_ON(readahead_count(rac));
 }
@@ -292,6 +293,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		if (i == mark)
 			folio_set_readahead(folio);
 		ractl->_workingset |= folio_test_workingset(folio);
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		i += min_nrpages;
 	}
@@ -459,6 +461,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 		return err;
 	}
 
+	ractl->_nr_folios++;
 	ractl->_nr_pages += 1UL << order;
 	ractl->_workingset |= folio_test_workingset(folio);
 	return 0;
@@ -802,6 +805,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		ractl->_index = folio->index;
 	}
@@ -831,6 +835,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		if (ra) {
 			ra->size += min_nrpages;


