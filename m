Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A65D2C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806796B008A; Wed,  2 Sep 2026 13:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC886B0092; Wed,  2 Sep 2026 13:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3446B00A4; Wed,  2 Sep 2026 13:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4506F6B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:34:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD13D1402A5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:34:37 +0000 (UTC)
X-FDA: 85169521794.21.05E9E46
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9FF1E40003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:34:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X1ZTUAcv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788370475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUUmmVwcFAp6YFhg7FH/R65tRXOdVOTCH2JYs+qmY04=;
	b=bdcd2r5mybLh2Vikg49/8XJ6Np49Z74sYIq1oHam/YLECgLzJafbHFh8r8YUIUf9TuBOeT
	0LSh0QFtFczLovf7ko6lF59vHC1OB0Qxp6IDd19+cV6VSjoHKeHSBrerhBuEyumKH27h5w
	PY1mDLvwBaqBMCRkbcdVn0dxCWtNOyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788370475;
	b=OUj1EVL/6+0ymMXyR52/+vhnT2rnDlRVx2Bt6I19cgvt51pwtKw4VGEGO+15B0yEOO0sbA
	vtX4x77jSCfLVo5mt+OM5wW/kxeb5G3oHHjHCHQcmUyP1hv/8cy8JK66wwtRhT/hAoYWsR
	uQTTBPQCNhkvAWPLrwiTfXB0X6ECRWg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X1ZTUAcv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WUUmmVwcFAp6YFhg7FH/R65tRXOdVOTCH2JYs+qmY04=;
	b=X1ZTUAcvRIcapE6VsS8ME7KPgjzXcsvHbTcmdns7j76XlmS9fV3uTO5PQbDOhXLKCtLfoZ
	7IxT+YXGmNrL55K+frsEsURCZqUNLLrWe30WQ61GSl6YDXA1S9unxnfTYSUTFgGAFEaRAO
	oCWLI07flnPzWA+JB9nQTmDdeA4CFO4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-483-4CaoPTtrOdCq_XtPRdZ90w-1; Wed,
 02 Sep 2026 13:34:27 -0400
X-MC-Unique: 4CaoPTtrOdCq_XtPRdZ90w-1
X-Mimecast-MFC-AGG-ID: 4CaoPTtrOdCq_XtPRdZ90w_1788370464
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAC9D1933F8D;
	Wed,  2 Sep 2026 17:34:22 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 70C9126C;
	Wed,  2 Sep 2026 17:34:15 +0000 (UTC)
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
Subject: [PATCH v11 02/36] mm: Make readahead store folio count in readahead_control
Date: Wed,  2 Sep 2026 18:33:14 +0100
Message-ID: <20260902173350.3468672-3-dhowells@redhat.com>
In-Reply-To: <20260902173350.3468672-1-dhowells@redhat.com>
References: <20260902173350.3468672-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: rQhrJyF2Wq60nRGvfud5ZtThVS9Uqb2bNhQ3atoNDMo_1788370464
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9FF1E40003
X-Stat-Signature: wgtt6kyhk3w3fhmdhy1c58ougnohjkzt
X-Rspam-User: 
X-HE-Tag: 1788370475-800215
X-HE-Meta: U2FsdGVkX18MkvR9Rq6RCNXtPdRW21o7829xQPDW5qTND76hv3BIVbop0yTllO6dYlN3fyQqdmwd1vBBxTRJGVFJ34cRb29qMq2ADOir520qX6JlkFRChisV/sUYzfh/YBo92xKk/NsBIX2z4gQnD40SJpdJuP0wvQzeqzMdosgVmtkrPoinBfQKhlHfP8d29vGBFVa1Ps+2YVhJ/HsoIaGafmigXIla7+RdE4jz9V5x9DCrgODb+RX4B30FYRVuVCRn86a+PEBIGrj0W8qORwW9HXpJ2/v/2fwOBizBOycaMHYb6v0Y9Me74hQPTwGxlerzTTcP2PdJOnZAch8NidJ32i9Jpd1m58hvkTEjFHnmsYNenvhDhV6f/RVwS3mmadTVup4oyktmLoDaB89U6zrUpHH6N8PRBHc/c1EG7fZ8hpSRajL++fkB9G6V9MNmJQt21Ft2tolqe4p5f2tqLesNx1pTrrBYD8mH4L0YSPi/DtQunPPrvVhgA0omiU2IR8ULau+t8zfgwBDkHiQ++NVsWyiVaj3UwXREMEEsjLLjSRyxnGNitk7i03ReAlsnyPEIGuyaTqbknsCSkaymp9C9Gk8HZTazPfRx32IRzcDvvRjEx2JkK25xRRi52aIU7lblEWONC+dti5ZGf97b22fIzseaGF+1DHKp1F3v5phh9CtYX+0k6cWY8iN73NLT7WwaBxo65nnsbPprCxUkizsVm4oqP9VmW9FvpZ4rxEdMmKtumZA6bH/pOgLjLO3+qtWs8RKA2KmD5DflCL10zTGp0NhCH/EZHaEeamAUwLUZhVgxzLiV8tdqnAjPb64NoC3O6+H7MXqS0GBNIOR/U641KRe355aj7AC30qcW/OJt9td0SXyGwsWStNX2mjBmFRerC5ChWEIt2tDv4OHlsO4SqaVx8zaBwX4ykvYOUSCedcpfccOcKj5AG3cUJbzKmwloti+02UA/a4pA9eE
 li3+9mbQ
 cyYhjF+JLfQx27oq6yDFuq3BkCcI3C/f7ixf3iYLyg8JtYXYUugvj2iKBWgziL0gkrpzCQeafl+pYt+hJ6/ult6DP9pa3uTAbg/q+OwEwUVBJkp/vY6OlRescLD2Oim5z2n6C4AnBZ02eLN+kUkbWkftfrLpmBilU4FZ9/JSdSkI9fIaLTyc3JApWIDbxvloCa7gATXMSSGIzG+uCbSgryqgp9CFBBuhdqCXhpsaJy4n9Q9BNEpNpccfxpZ72G8yW9Hf2LMCz2R1MX6KC/T3CsLsO8jp6MN41Y72219WhGcwXjJ7FZedu0b6M21NsaSAFXrYdIYwaXQcOHCQ+pCapJxm/xfErWbwc7v+0BxThuyhRmIDKbWvoXfmS5W1cwae/om79cRMLYstqtJRlUO1hoP3tCkdFZi7yHluOd70+nxyzzXdZKPCzfAVBao3TSiGLsMh25PQcU4wH/gyKInFcy2R2QXZ2syPMdx+kntRDSrCd6VoSroY55LLJuGWGXkPZLuNoIuM53L8Dm+Axpn6ow0xsVEkulUEDAcW6Fd5obJ5GdiHdBD3slrNbSycqUKyaSWod3dotmrr8NBN40XXNOeE3qg==
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
index c6fc783aaee5..e2161bce13dd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1377,6 +1377,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	unsigned int _nr_folios;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1556,6 +1557,15 @@ static inline size_t readahead_batch_length(const struct readahead_control *rac)
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


