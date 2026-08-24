Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65420C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563EC6B00A0; Mon, 24 Aug 2026 10:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B426B00A1; Mon, 24 Aug 2026 10:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478516B00A2; Mon, 24 Aug 2026 10:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 218AC6B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:42:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9668C017B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:42:46 +0000 (UTC)
X-FDA: 85136429532.07.5E4B27D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9885A20008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:42:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwMV91uk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=A1jPsRCjr0fJHcQCdqA65cuN57sS8bpsjhtyOePcsC1o/q+JOufv2Gouh+3zPRTZi/tOJ1
	ZP3Gd/IRfhzq+KvGoLACLgo6lUBTNu91m6ifUSXR6XLKj9U7RHD5pkKWXU4vNOriYSfgE2
	JT0pHLKcs0W4lSGAJi+WAdtotTAWWPk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwMV91uk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582564;
	b=jr2JBExM8R8VkrQY8JDYeCh8/m1jnuBZEjMs/mIU/F1Cp3hoTZvVqk0OCbCsBwu++X3LoP
	rCqhCykQHwQgFZ6knryNsCAva62+B6XoESQKDkWOfA2O16Udt5QMudxxC8PFxYTsbxZg+v
	8mW3YCZkRXK5M0n1uL1TSOOWDiVdC0o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787582564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAh3PBs47lZUHcwbeGXM5gS5ZzePV60tR0gQfqSs8Ac=;
	b=BwMV91uk0rHGti/hrG9pZ97agNbzfyo2epKaIoB1TCIO0YCzfYDsFC4NC7Mirbg6Qvw+zr
	XbM/p/3o3hW/dJoAnm24/t/OMFg+F0djQLcwOfdOa+tpDN6qMzWGSo58IJ+9tec5yN+W3V
	NxtnX/f/7WH2X8q2bSVt53vRQt4fh0Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-fezJf3dqOA29Pdmv6Zl6fA-1; Mon,
 24 Aug 2026 10:42:40 -0400
X-MC-Unique: fezJf3dqOA29Pdmv6Zl6fA-1
X-Mimecast-MFC-AGG-ID: fezJf3dqOA29Pdmv6Zl6fA_1787582557
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A7F818601C5;
	Mon, 24 Aug 2026 14:42:37 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BCA1D1800767;
	Mon, 24 Aug 2026 14:42:29 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
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
Subject: [PATCH v10 06/35] mm: Make readahead store folio count in readahead_control
Date: Mon, 24 Aug 2026 15:40:59 +0100
Message-ID: <20260824144130.759997-7-dhowells@redhat.com>
In-Reply-To: <20260824144130.759997-1-dhowells@redhat.com>
References: <20260824144130.759997-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Gtj9Qgt4JCSc8iSrBLdzeZcTTQOe16lvWbtC9IF9QmE_1787582557
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 9885A20008
X-Rspamd-Server: rspam07
X-Stat-Signature: q3yu483xkjuadmz8nnmmftg4jt4p8z7g
X-HE-Tag: 1787582564-275956
X-HE-Meta: U2FsdGVkX19PN7pZHtM8UDOQZw7zOVNkqA9M7H9fbKm20g6h6d2+EEwF10iSOsymUltDutzc/8vtcV5kt/WYiAN5wCEOHfu82Bt3BO3QK9iAK2cdw8Y//DjOr4uOlbKFGqBpmo0JAaBxn4I1dh7l1eRtcsSV+vqViZmb/c5taYmJxX5Hr80FcNiRexjMXhH9Yv4Q0HIomzE6YOAEfhHyK9Dn0NBiNvuqdBPRJa4n3yv378q/LwOOVkP0vWmtqJ43A6UW/zKowbVC0TY1pc6R6EDrmSHd7o4Y0663Cnel0AeqCBwt+twuBeCYZGFr1nanQEBIxmKH5KXtDrtcxXnPYQQRpsM0S3LJc8XDSmplKTjanT39anouPbxVQj2ainDJj/p6ja//LUPN8g93rSqc/lvwFcMa53ExROoD/9SY7aI1J0DFMsZgKzAne99T8FQoewFptrXEbPO0Ak8EwpQfhKtFqYNai8iyx7uoT3lXRKI7etp9ZlexC+AWnagalQx8YXRkO3nnw1LX4E9uPx/PXJjCyBf6mOP/aF3W/Ov7TUePg4U7qok1Fej+9Rw8x7SthiUw1VmBy5WWy99HOZV8HqZ8iNPPemX+zgCHKR1+flrOyIRGZ+fXLyaI8B/GGT0CL6qx7mWBOlBIXL9C2hmIy2gsfhiuC4fUqmOztfd9tQRPwK1P0hiXubKo8BiTpN1TqyTAMAtzB+Fcn/KFniOFESpiqANJh/hVXMnIgLAqZp8BmhA5k+5jwshuKB8lHXpRDNErw0oz11SYfN2lm0vT6PZ+se6D1CMlPMF7OH1y/oacNVqCGOighVn9xJUoLtxNhSJtxL6h/wymEBdbASL/CnUeGaudvog8EFqauq7U3mmfBNu21UnwF59TZEiVcMwkI8Z0vM2wxU/I8T5a0rsZ00o1dv0K3XWF6/y+MhMA+OQZZpAemwmHBNTz+N02oe1mMxw0NHHpMJfy0WQd/Qj
 o4fNycQE
 PDUxPTmlCAZjk7RUij0hfmnJVfLpinVByZposKRSW9whzDgeLQJc6uNqoJL/U0pm6gyZdtbm9lmT8mRhd34eswwNwaujRwJ6WrSFu4b7PWnOsvW46BnCMgThPy/HTzctH8Q8a6aXouhiY96Zt+jgAZX3TptffIuynxGg35kGIWu9Lw959rBZEYgq3LuQC3W6ZCzFXXuhT58kpoTBGL3uI63ZitmOOidlCZQ9032ZIckbv+efMOa9HyMsDxCAHJkW6OURjBgnta+8BzjhxmGP+ctWTPlLWpWLQfb39hr44qECt2GtCxtXP4qOBNU4Wed6VpHM07ZAUZOzjwNRKiCl7ISsuxaZK92FCPCfJ/NOviYmpexC4yk4pjK7QRoJg8v7fCXQYQNyHRIFJ3THwrTt2SwC3R3g7bVlXu7+VWmJm/6/tL/bGJgGfLgVDAnTt9sfFflVcn4IUgCNLj0vn3nfErt9PPOiiruSZWnYiT5Txk8wciw17S5jfDsnpPgw20xLzB5jMF28mKyLmAblsAOvBxLSgkF11YxRdFLHHycIFPHoZ9HcERxOKgV05IbuTrpXV9oDg9VUyp5XtbbITnFiWRxoAPQ==
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


