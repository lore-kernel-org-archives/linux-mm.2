Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EF6ECA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 14:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0026B0088; Wed,  7 Oct 2026 10:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0ADA6B008C; Wed,  7 Oct 2026 10:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB5C6B0092; Wed,  7 Oct 2026 10:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C25C6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:20:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03CAA16021B
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:20:55 +0000 (UTC)
X-FDA: 85296041712.21.89CA06F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id D7792140005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:20:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IpsSXMvi;
	spf=pass (imf23.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791382854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=k9QygpDZ0NFQCmOYPz/ib+o3cR3HcWXLVkPQkT/xk9Bw42tgWhC1MVZiQ4x9tuTTuXSkhq
	xQNMtkYLON+Bao/AOSS4qt+Iae85yxhR3e26EB/nHnexzIL2ZM4ZTVVlX2tOvtdAQcNmAX
	QBpn1mbsgR3blrXd9JNoC0g7LTHKWxo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791382854;
	b=U7vjeYMVuMyM3YYglFXoKsn1M7fdaBnjtkCAY/OVYhPTbXTjVSbum/vNJIfHPHQ5Y9U+OJ
	7WjHceejQrO0fYGV6yOwoXxnGAj+ybBueZ+uYZ72/7Yfxnc30A4TuaOrvkt6VWpw+Ob6AB
	Lj7dhHSRVayU7WbzRw5/oMeTV1YkNHc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IpsSXMvi;
	spf=pass (imf23.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791382853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=IpsSXMviDzIWBH3jOhvkrArTtYxYHaKqCRtjHtQsHtfE3GYAC3Y42DEoiy3ecHxPKbxNuN
	isrqXBOEP/GWTHQn6Ka4G/8TZ9gwwTRY+qhbVL/WuURdFFy+5V+DUl2F5Nhqv2iwg35KWv
	MVrkD0Nn3aOUp9Y7VekG/a+uvTUoPSM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-NSJhfmQHPBqVgX_LYodzZg-1; Wed,
 07 Oct 2026 10:20:49 -0400
X-MC-Unique: NSJhfmQHPBqVgX_LYodzZg-1
X-Mimecast-MFC-AGG-ID: NSJhfmQHPBqVgX_LYodzZg_1791382847
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 527C2186BBAC;
	Wed,  7 Oct 2026 14:20:22 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.90])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 018DC3004195;
	Wed,  7 Oct 2026 14:20:13 +0000 (UTC)
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
Subject: [PATCH v14 1/8] mm: Make readahead store folio count in readahead_control
Date: Wed,  7 Oct 2026 15:19:52 +0100
Message-ID: <20261007142001.851620-2-dhowells@redhat.com>
In-Reply-To: <20261007142001.851620-1-dhowells@redhat.com>
References: <20261007142001.851620-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: _BBEyAd-FRThoeOnqWoUUXGVxNFPGtb1TOUNRZ77hPc_1791382847
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7792140005
X-Rspam-User: 
X-Stat-Signature: da1t36sor3aq3yt4s4y46fceirn7xk39
X-HE-Tag: 1791382853-728946
X-HE-Meta: U2FsdGVkX18E9kyJShHtoSXsZi4n7L82Ah5Im/JNR3hh0C3+e4Oz4cVaOIbGErNQU2iSW3JCxtkS/8WIN5nLVSrB75sDkjT1976+KBpiqcMbXWV83x+acRbMXzctSHTACCZ7FkKFiDjVIpl/nLteuNLeWsdfOIq5zcFEpkXEXVyd2K8Ng2AB9KRoG+twd/X0kgBIpOVt3Cnzm3037bXxbkTWYKqnk91xofSi0bVLwMisVzBHVAdKnmNXt9YGpxwLcOWzpbK69V5l5ZvBBXyDUGa9zDktVMqfLTDNfnD7bvbHGorKlmj7llEfVp3JBnpsdCeoLjgiaDSSgQ6+IYoHIMX44IyBoMIvqcXljG/wvYFStJqVhG2kzBTcRgdDzajPga8EzV8B7uq+i+MZ6Aw4R20NtZRZuk97TUOTl56oib0Og8X2UuxfIRxHrEkWjKpq5zqHthCOKnO73H68Pezt8/kPofHG1ua9/sjdtp+KlFIPQg+bA6K11ZAINzUdZB0CBzkIXXRNsPTVAQs80Vvee45/sfni/tVmSml7v57g4IAGzDwY+rydblvVX68N12+7KK/xTOJR1yEpdWZGSjnKZqCYRnseHjpEkiMAR1q21PkQio2KhhO1x7mx/GQtKxy/boNRQnEpB22gFChvupqPKxwqucZxXtEiZm7SuG6qo9zcJ+ANUTxah/kLrbnDB/hUlLk+oagwOZDQegSW5Y0xYYGtFMZ6z/k4b4N9jf4azqmgLVD/Jqxq4sArWSQPgLlyyI169DNFdYlTj47BhAZ19T8sW31g/RQw6y0xTBnuFZm6wmIALTaboUb5aHQOzLNy7qYRZCkNaJIDZ4AFJ0s+H5rNcjRWqLbiz/Cj1hXKPJfz8lAFS9J6ZeqV0+uOXePSk8pqG9Dn50MTMFSRukkoPAncEhlFZww6FtyRrk4MVZBZCtX5yo/+ZO4UbTw2k7VTD9sgkdBMwAN+bbo/EZ2
 NmJfj88C
 ihITieyuI/EyBri36jtj+/fO+FZzz30ZxRRh4QzpHLBgy++Pc8RGDHU6UzGA78w5D77V8jPeBVaibw1C8Nq49FnpsSbGBGC9nZa5Y0xr6cVfSD+NfkU6hrFiiRc/q9VFWzskC/JUGGQOSkGPQ6bw1LPLcOQojQBp7EcZlSTiKI5flLDo5Av0PRb8KFG+L1n1TFGbufvGHBITR/vyai/kO1CYdt+epE0mF/V1KLZ9jELO5Md9JzmEyWNLgkZO3OIyrg8Cb37UGGgIQ9Fh81gfv3Be4SFCFXSlg6ukddU26+CMViAQrtbqzcQT3H3qGRfnm+HTb6vIbTKc6vHQcJ0iAigXv/2pGfS7cg3xbGDFQB53LDnTeLrWk/vZl+A+HzEWNLom7TEUVu139kWu72sMe6GAGu0pXV/ga9dBYI86uqMm3q/hJqoW94BjsNF4yTG0/xvPKDv0uOiDAuOL5UxvqkOrcWtdGPu1yWa18xYyMuiIXMeAF7K/CXXXx1XfdYcG0He3cjHKdFGHZIGlHnh9IuYfjdVaRbeLuGK5L2NkBbv3OUWu97ooIeTGi6QdWcp0CRQg6GdqNw44/3lBDRbV3IeYWIsOcxPpSo+O3/5xw3U8v7aR4mID0xV7mxc6s6wnOQ3Ua0Asr6tiRf84nOGooR78b+JU6qUsLK4TUZr4CL1mfziVUpPg02hpYeYSFitqfMO0wCUXsZgt+8aaLEXmhRPMjKA==
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


