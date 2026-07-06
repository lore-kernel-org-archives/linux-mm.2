Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8BEC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10FA86B00C7; Mon,  6 Jul 2026 11:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C09E6B00C8; Mon,  6 Jul 2026 11:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1D66B00C9; Mon,  6 Jul 2026 11:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFBE16B00C7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:34:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38C9340105
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:34:38 +0000 (UTC)
X-FDA: 84958749036.14.DB38502
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id C9AD240008
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:34:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZIz5FcV+;
	spf=pass (imf12.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352076;
	b=OS8xUDN3zdEsH5P+733l9NMyj7128lAwrov3M0sewLNPrW8krWotduhrhBOnmcZwRThI3n
	hjfxHkmO6CUbDWSXSPEIbcb7r/1CexhsZEQg8YjM8IBRn6CAKOM6PXL2gDJk4G1eQmvmhX
	wRLj5pkfUuGmvZ0skYjvN9OF0eU34Lo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZIz5FcV+;
	spf=pass (imf12.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=HDDKqFYihPDasDOx+WQwgWFwAEeFtB1VV4wGahy5H1zEqzFQKAJU109brGlSCMOj8nxImE
	QD6esElL6L0dMurdw44EZsfYETKDoxgqFGgi0IsWQJTHqmed16VosuhtSCvEiP6KMEYRD5
	l/xt5q28MB/s9oDD+F113D0rj5zV5B8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=ZIz5FcV+kbTUoKL2tsm/rqRS54W21EmApWtwIury9xQPt41THFWC+qedKN5nJTDsq3hkv2
	374rEvBqqwDyv0nlHRpoCKfSqNbvfusLFDH60Uo1WSK+nF7+rNl7HTwQNCmV0LO3kc8eUd
	nLUiGRYh/RP+CoKpm+1l1zaPO8xKZZ0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-CzLBI2gxMbu0Oj7J76YUmg-1; Mon,
 06 Jul 2026 11:34:30 -0400
X-MC-Unique: CzLBI2gxMbu0Oj7J76YUmg-1
X-Mimecast-MFC-AGG-ID: CzLBI2gxMbu0Oj7J76YUmg_1783352066
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08C511800A3A;
	Mon,  6 Jul 2026 15:34:26 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D5CDE195604B;
	Mon,  6 Jul 2026 15:34:19 +0000 (UTC)
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
Date: Mon,  6 Jul 2026 16:33:47 +0100
Message-ID: <20260706153408.1231650-2-dhowells@redhat.com>
In-Reply-To: <20260706153408.1231650-1-dhowells@redhat.com>
References: <20260706153408.1231650-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: kCeOecfzZgSaGMLKq3bZTzavlnaYuQW2HY4ncO-CKmQ_1783352066
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9AD240008
X-Stat-Signature: 9b3o4t8h6mtjcd75mqj9nnr3ni1txynu
X-HE-Tag: 1783352075-893003
X-HE-Meta: U2FsdGVkX1/BrRjclK8Wp5jEegXC5uDgHsMlW/M9hzyHledOM/oRovo4ysUgF+gwCyq8bMZW8HJG+IpPuRKcqWIet3rq/lXFldGsWhfp44S+XYgyO+XgTdyecRcgeOZRg2NBheiDGd+wcbt3Zdf26dJHwbPJbGeC34f7xN0fyv89r7ti+OYM5rp16tgyv9HQ0Ng9Lclmo+xpqktpG2QoSoQtnOsyITw/oUSULQ1gEyvu3BGj4M9IF6U5rcNFXYKBMAfICeBflQj/rSLuJYLS3OiuOOeO+9u3rheWO/sqrjBm4J+X+XWWDBc5mwN0Be/Lv02flGZpzWkQzWYGvEtkGOyYgl3ZWH8oRsI1GUftbZwmDw6yVWz/KIudeuMTvg0i4L+z9LQXpjsYvMH59ey6wy1lwcD5EBhKhOGG+3rHJ8jKBkgrYS1aIrtJgJNzqCbGbl5NmRE3Dr1voxlCfJ6juQd05dzugpnOoF1UXEVMJooUGCU1u2wpAtKnWy425ExCalPnMlTGNGUMJeqMXG07lRniCnvFSruDE1AiGxbDL99lu1LZs6WN9I3sc1tVNUaFKwi87ESdSVwSpQmXQjdOHPVK2N4VErmgKweDM+I0qyX9D0bdrFMKr676TNpskewqi3wBCjUP7wPEaJ5577Y6kJkFTcqkxjLzy/71Z/dMt8BqLrUE2p1B2DrIpGn4lyf+yK18t+kVifpZGsqWXsUS5SQsAdrR1hzeEGBT9K2nhKQIvLny/0VGq2p7UcaoXgLLcsqycCIgL5mZ6ezIa4cxvCUk+d/1Bm+5InlwdV9aKx9SjkM7O3z5gNsYVMCL+Sgir9YBb2GpQK3mIE+DrXdxWMOVkgu+pzNfr6Zfn3cDkcEQCrYNvfJyYU5Ovytp7wEqqpnidDoPdsG2E2Aj478F3VBT0FfSV6+aIdLXbRPTPlJFUak0QO6m0Aeo1snveu2otfvoVL3oajIgS/iZYhR
 2HP60FKQ
 mIL6zXFblUMCvSgnO0MKMMaq/EOdU+Dt+UesvN1Zpm2NckoK903/HHvXD0pgSm8CIomtkYstOMzRG2uQZ6/HZmtZE77JXU19ycicbhis8f4PUmHnq6mK0a4FLXu0sdX6twDRVqFA+dvpzY4geKdtAc36D8XbKm1kEBgT8C4crhEoJaqodS8T3cZf3LuDJDtrjBZkn2Hih2SMQ0m+W2M8EzdWJb0kI87scQHhNxP1Lw1ha9jHsiiup/mrfvV4EA6yu9ShZHrggNp627qy51O9JmbRxc0d9fcKCj4WbELgQonq99gARp7uWy8vFDBMJ40S68r4QF6GKMVvr/9T0Y82lYeV0Kp+N3cEEX7KYPVb6NWYe0q1loRCu/NDpokqVgQQvgT3uyj4Cqinv78dy15OGk51hfGtwYwTVjyS9htZk10YGcj1BqDPGEtOTn89dizaqmN8ELMU9vU8z1Z00epIVrdj3ACuClbZWCIHxy2RTYNCwzC6cO2Ss1YZ5lb1PYCR1O0M6YOK0GPBdIqaaSlTlUCpEfEWEOn4K82ec4GUtKnSyHmYK4QHX56kH8T7lYylw6Vwe/Vb2d6EISRSG6n+RahUbXA==
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


