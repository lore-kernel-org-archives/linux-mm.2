Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6542CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 21:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656B76B0088; Tue,  6 Oct 2026 17:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607886B008C; Tue,  6 Oct 2026 17:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7076B0092; Tue,  6 Oct 2026 17:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 294BD6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 17:00:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9956C140351
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 21:00:19 +0000 (UTC)
X-FDA: 85293419358.23.E37F57C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4EE70180010
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 21:00:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RBQh1pSp;
	spf=pass (imf06.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791320417;
	b=0Sw+WL6p/zhiCVsBWRkBMTspleYWfB59P/6ipTefxnLinXWB2bGg4ubmh3ikj0YoGkqpia
	h8MOu55rX147rwlzOFiNGS2nnji0uvlba78EHeGeMxAG2GGY4UVjCkozWksWFY+qUPXohy
	kg0fsPvW0JNxwFajVpsFfkiOTZmacoQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RBQh1pSp;
	spf=pass (imf06.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791320417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=xABtA+YT/7vAUXH6nC2gkO8YoGhNgcLbUoT8zabUEeXB7HzuYHly+SnRrBFmpD5DDCKohZ
	AMTw63Vl8xUi/zIskUaKnA4ZQd43dspYtG+PPGcP8NW+9KFz7FzbsEBDchHUhWfrI5CPD7
	vzXHpKjfYqkPeNuMqP8IglHoI/aYy4I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791320416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=RBQh1pSpTelWzEriASIeHwePOJIANBngGRTmzTC3PfjBSX1AK5Vhu8ObopfBgMHzk2a6Vc
	8qkSPPTuH5KV5/sC6lMTH+Whh9x9RWWt4yEsAVbyQ2ynnYNxV36ge+QDtnVzeU9J/XR1y/
	2bkfmdg/OzdqvsIDMKs1FKxv4fROpKo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-pA8JMPwMPvuf_UZ79wbw9A-1; Tue,
 6 Oct 2026 21:00:11 +0000
X-MC-Unique: pA8JMPwMPvuf_UZ79wbw9A-1
X-Mimecast-MFC-AGG-ID: pA8JMPwMPvuf_UZ79wbw9A_1791320408
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 609491977597;
	Tue,  6 Oct 2026 21:00:07 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.90])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2A8561800581;
	Tue,  6 Oct 2026 21:00:00 +0000 (UTC)
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
Subject: [PATCH v13 1/8] mm: Make readahead store folio count in readahead_control
Date: Tue,  6 Oct 2026 21:59:37 +0100
Message-ID: <20261006205947.608356-2-dhowells@redhat.com>
In-Reply-To: <20261006205947.608356-1-dhowells@redhat.com>
References: <20261006205947.608356-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: kFtnXnZU6k7kkR_fQ_Q5h1Fb-hJ2DFaA36D0xaAH_AE_1791320408
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: w75w845se3tgcw4iyjcxseaq6593m759
X-Rspamd-Queue-Id: 4EE70180010
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791320417-651581
X-HE-Meta: U2FsdGVkX1+eK7XEQ6iuejlAiM3+oMNb0E8CdgMERJl3MnYGUZGTqvEbcqEPETwA6Uge3WdR5uYcH58TWXRicQJ55ppt/eai2itMRFCCHG6lDx0b6g6srkHCa0auaoed6xymami/qa1SuhbAumFpEeysDlXILHSmFWgCoC4PbzZzlRzF60Xi0cBx30upSXopb7Eopa5UkuDhXt0aT+SgsvMO6RGkRjaxJYVt92o/v6LtUZkav44w9M8eFzRAScWsqdXY1jd0yr1ySHMmaBzdO7Pm/QhNVDvILiYNhyEbsHU+PhQmIh96Z+LtgdAhtVvgANd9GyOdQYhLb8elRBVzHbt0ieJivQWzeGEwwQER/Mkhk+ujS0IuZ5Sj39Q2xDmVI2RcY+RP3y7WJCsqbywW3nYNWw/4z09oJDw/Ha64wPfhJ2P78RsaHgO8fzqQcuzH/rLzk+kr2myJlALN+BAAUhT4yJGGGKsvoQ272obBprei6yF7qgrvxyPNw5sZyFmR/9W8rrp1p2jaC2HE3ATPnSl0MvWfr0mwpVxdpjNpUyR3v2JB/3j1z0NMl/nT5drM66VfetDgULptfqHitAObKIv5rslYVA9lO4PyDeDAY0RR8keSYx5p6ikOM937JTh4gCtf444e7xru1bCYRZIA6Tx8bBfSZptmHRgpDfGbnpzN9K6Hn+Y96D89VcYSjzdna4iMNgacw5TYoOH37+JUaoHCK/G9j9RcRO4VezXMpDcUhtobSKmd++534pnksR5d5I49LnvGQiKw7IOuWmr32tH4HEX0kBsY32IxGmK20MCImTls5w59ixgtiGK+/czGaEcH2wUQ4cXqZlFQUndXQK+Uho8zINZ/cO5W9rKK72j9DRME44xMtsdSQ3PAFIQRHe5NdT0ltWvt9UD7vxzNweiXpVonX2iYmoBHeUJd3yrGWU0HI3bUN7ZdZ3fwBJ/XfVA+d9gGHwh9Z2B33t5
 yIz9t5rx
 cNV0/AFx9nSh+NHPKLBHRWNzrEW4eTacSBX39+2GMcfV3CC3O+ztzuwYYZfBBF+4MHfFmZC6wdNxsCwFu9qmgxtinVX/WGw9uGHs7Txj7KjRw3Ds2hQqD35GjMxMlGpFvg6dhcCtuDTeJAIxZzmn7yldnLiSq69G5Aqp72NwXSGErOQMhEtuIPc+M0B9yuKLXoR9mtY5O7a/a++G5ex9TnpY5seahM5mZ0IO9O1o6Nqw1aKfbdOCx0JyIG2uXWM86YIOnO3gfwYvckhvISG2veAn58u8LFQV7LQjFy4yPJ3752uNFJ9N1mGf8SPIo92DeUqrDEcrzXZ7cg1ThTUrmvX7KBNymzkxQdkeU4Dk3dih1oMuynwAwkSXOk2775eV1wna44T3HzbGLerYeADRHDQFltN/cYumS8ZG/vlvukDveQkCMLltFUTpygny7TeVBATt/nH1FEYaqsTWRhyhMXWvWksqBMD0uVlLhje/pdkZDnqljPCc1lWl0JJOEht9wCS0iiteaE7eu2mq+rhv7Ipuk6Z7iYV/RVCexAUxBNgXJFVo3WzA05B6U0bEKpFju18aWtQXFcP7fvx7DWO3iLQdDQNNr6BGOtuYv4LaL/eJx6sHzOagCQ3y/UOSfpu7GJyRIBuWh9zftpJT1RRJCNUScIjEw45uEGh1g/3O9nhimM6FwoID1NYIxjbcYxYSWloA3vwv4you1wnnUyP/fmjPlBw==
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


