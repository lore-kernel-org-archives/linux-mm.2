Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D7ECA5FFD
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 07:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0456B0088; Mon,  5 Oct 2026 03:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1525B6B0095; Mon,  5 Oct 2026 03:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040B46B009B; Mon,  5 Oct 2026 03:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC0FD6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:13:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59615A4BA0
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:13:04 +0000 (UTC)
X-FDA: 85287705888.05.9FB8D87
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C42E180002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:13:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dMpYcVEi;
	spf=pass (imf16.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791184382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=agz+9mgVOknD9JWUwW11l9kzUzMZ8UKpme+igbuluFsSYHwjhvhzFYtpwKxNldLm8jYgnP
	aqq4qOmJeAu1lNRTZitxYLSIE9RggMhpLk7JOfhV1xHcBoVRigfTTWWAJrT161frUvznOP
	TNjsSBI+OJ3KnGJP8SoxuoW8c5+feqs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dMpYcVEi;
	spf=pass (imf16.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791184382;
	b=nvg5rez2hqUoPDPlva1VYXVPZwsYpBORWo6K3EEEGGqZwFoM9ERgCMvVKwtNf4dqK/DYrC
	dvbcgFlgCLvKuoMICqI6LDV4I19uxJB0m4IgoTcE7QqjTCY9UUDjpmcxk2kpzs6tzfX3GX
	lvWJ/yrfQbdjRYHHbxHrG+2T6gErw6E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791184381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=dMpYcVEicL3SN3GS/aBoNhBoe+YkT+riRR+pf6bmjx0Amqk+o64m8C41wHrK0mS6PWcGvm
	BIJnY+VvblfaO3E1bRsSVybzQD7EHV25AwJkh1T6aJ6ROR/Kch7FLX+hIroB68ih13F/pA
	pmQLAQ1KUB45qg8bieJgMaq39K4UMog=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-57Ru-Qh6OESMsKZrHMXjZw-1; Mon,
 05 Oct 2026 03:12:56 -0400
X-MC-Unique: 57Ru-Qh6OESMsKZrHMXjZw-1
X-Mimecast-MFC-AGG-ID: 57Ru-Qh6OESMsKZrHMXjZw_1791184373
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCDDD180061F;
	Mon,  5 Oct 2026 07:12:52 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.90])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 322B119373D8;
	Mon,  5 Oct 2026 07:12:45 +0000 (UTC)
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
Subject: [PATCH v12 1/8] mm: Make readahead store folio count in readahead_control
Date: Mon,  5 Oct 2026 08:12:18 +0100
Message-ID: <20261005071227.147182-2-dhowells@redhat.com>
In-Reply-To: <20261005071227.147182-1-dhowells@redhat.com>
References: <20261005071227.147182-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: zRsrhugkNMl4HwyJF0BXQ6R00rAYP071Ce9OVSq787o_1791184373
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1C42E180002
X-Stat-Signature: mrffbty5xs5s17tip9hayqeun939xzkg
X-HE-Tag: 1791184381-715474
X-HE-Meta: U2FsdGVkX1+1gR2DLWRs5kqW/s62m3ZI6yd+PRbQa/nTsX2qzQqA6DMM0081/1T3TP2ZUcidpf3GoHtORPZaauL5nh0D7P0M+R2UpVNnnvNCELRTfq40vSpiKS62MEqO7lIY8sPpZRNs/jyXG0dPuszVGbP1RjWpL14AWtaGEl3wILFpGPtnjl3NfSe08X6d+d8WgFAk1FAVW2VLTEmKZfVZvsbqhmcDjd3BxdwMNJHLCl9UjQOSWqewKgM4Ij6GXph/8QIatTGacpCxkRYco8Ee9OxzaHjXcxDPvqKjqve7Vboa03+euTCRb62WlrmjqtHiRB+Di7fIvL5onSU3VzIcTLKenVnwnOZLowgrrABakeCa0yWJvlUJO23oHCHxsRLawzJYfzq752FD8YSMj72jpCoC/2GjizLBB0t7EBz76kQFXtWe2G2GCZcjsty99LrvTh5/cPIfAyoopi5ZmtchdLGKS9xiRLM6XZpUF9BOi7QkWzr+fTmtJe2vfBFIT1Hwi/8OBjf2xaX7l4rcV/AgrxnK6lm6LWBoR3Iw45TYAKHB8+eXoaSRYSLDuPKxM6Inu5qbKIIsPsiTaR4AVgaUCJBkd1UtGHmMfqvr8CTbi/NSxe2lHVu4Ai08I2IPiUztwi02sY/KiHUojRY0K8RNS0GwUppKrdzTh3pD/A9J/QMUZM7jOo5TriH1CRkdIdnTwtl8yeD+ayvajeVCt1yJiovKwMGC5wMIhoj7L4o7QC5bDtxFoaslkXv98Hf+YrCLNi3Ou/afJ387CV/sL7v8d2Ssmxq/BBAiztm6b29tZ8xHE2uinQshhiA6sfx6SQjuCRtqoW8urNH7A7VGHRXkxDgKnh0p1kWRhxi0NgaULho2zmtzlOp9O0B8HsWTaP8SkjumMlhMkftBic0DJVnyMnbc1N+uwRtvozi0YF7v7eBKgRGPclxSDgF0Cz6/TnTjpz7thQhO4l3ZEnz
 sKV72kQ3
 6NWwYYVjqkETkwSzctu9gTG3B50/zZ1V7AhOstvygLrY6JG0D2tw4S5bDIn/9eU/vNp8kG0P171hgvPvHMhu1iOB7yOI+R7voBxlxwrS0kyDoTSqf1207bqy9afTLxdqDaEqCZ7rxTQg2cs5HsQbjicMT5gPvyh/Juuu2FgRhIXK7QoXOLqyBDbL/KKexqC0fjbEdDJm2lB+UiQ0pBTFlOOvFIXNx0JVntHdiMU4ROn++Ntw8omwpbgOcZyefOxLf5M7+JFXTuA2/OGQxS6P+fBTx/1S+56UULwOe9UCKushl5YTHY2H1S0LxEs1B185fXug7CiFOgkgD/eBPBNlbtYpYpjQ+cf2CdNRGRvz8GzQfFI2yxwAMkPg/3/82sOq9mCuOn9Bgj8EAPl4nEPh6hvXP8PJ17ZRSpcqRqspOnbuFZX++xeLREDiMgz1cQdtmsJIVptMjiiQJ0lnOgTadb/KHjxJKsXFZCl5KLgU+etKJg0ITlCw3h15+9V3aY+zSuUg3JgErQvb6OChKinOwg/Lwm0QJ55F7WSWjnL479aSn5AjNDaqhO97ixJYwDAqFJqaje3DCAlKEV5kdwB8YKnm2DQ==
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


