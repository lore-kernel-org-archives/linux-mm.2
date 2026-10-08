Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD25BCA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 10:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200E86B008A; Thu,  8 Oct 2026 06:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8456B008C; Thu,  8 Oct 2026 06:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116A06B0092; Thu,  8 Oct 2026 06:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD7FF6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:23:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C41914010A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:23:25 +0000 (UTC)
X-FDA: 85299071970.17.A6CCF40
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 10A811C0011
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:23:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c5nU9s/k";
	spf=pass (imf18.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791455003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=fuL3z4EN/Ad1KNXIlxxRJrPOyRBSaMUduPe33g6cfqoKsNJVGpaDU/vqF4CgkiTk69kRjk
	wS8aWpMOCRUA2s614ar48yEXK+WK1dclXWVp+T06fZ0GCFIPH9CL1lSVPI4aY3dGpoeBt4
	4xqwiXZYnEFufyXXJvlpGfisE0SA9eA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c5nU9s/k";
	spf=pass (imf18.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791455003;
	b=Lb7UukinPfpel7/5VKsf8ukg9BnhL2kB5hFYKSj7K7kphrXFjwi3KV3pcXjTroMSOfkgbz
	RQdjwZuzTdnoy63PdL9BKSe4LPBuq+Dhxcs4GQA7S8gIk4AbcH5Srnjvhz95MKG4aTjM7T
	I6rjn56l5sApAHu1lN4jpNzbvatP7uI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791455002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qex3q47o/llFp5icyZaFvcldeQl44QEXS98v350pNx0=;
	b=c5nU9s/kMA2QTU2kpr5dKYLbmp1mKawL6qx7bayKaKJs8Pf17X3iHrinvW0gZlimFFaKTK
	upivphUi8FnVFB+H6qt4s9EAfbCcj4QHbu2TQj8tEQvuD/bhoUzVZR85HML5qKX3ikQOQW
	QQIUo5fZUnupX82esBv9AP9FmXsTgKY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-600-IuioQ6RDOdq2q_Ze0WKFkw-1; Thu,
 08 Oct 2026 06:23:17 -0400
X-MC-Unique: IuioQ6RDOdq2q_Ze0WKFkw-1
X-Mimecast-MFC-AGG-ID: IuioQ6RDOdq2q_Ze0WKFkw_1791454994
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09BF4180AEA5;
	Thu,  8 Oct 2026 10:23:13 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.90])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3BF581956086;
	Thu,  8 Oct 2026 10:23:06 +0000 (UTC)
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
Subject: [PATCH v17 1/8] mm: Make readahead store folio count in readahead_control
Date: Thu,  8 Oct 2026 11:22:45 +0100
Message-ID: <20261008102253.1003776-2-dhowells@redhat.com>
In-Reply-To: <20261008102253.1003776-1-dhowells@redhat.com>
References: <20261008102253.1003776-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: ZyRzPNCNIJJ7aWV6gFyrpBIVE_p1g7SmkriIuWdRSYE_1791454994
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 10A811C0011
X-Stat-Signature: aec81bdtdwutmk3xt39hqf6zhjr9xr35
X-HE-Tag: 1791455002-240478
X-HE-Meta: U2FsdGVkX18AAmtg6L135CdNSB/WIUnSuXVuGs2T3MMToheCxTMUoxTzWnTH7PDt8kkYGSeXiT5oLHrv/IR870Edom+TU/6Rkec4y4kcpUfkbYwGU6IPeAX1H+FPeQnjUymV6dFF7cu4CNDwrCfo4AShnAHpgrW3lf2KFL0XVEgJbCmgiaBnCr+d0eFOW3ZlF5dw3yKucgDWE82das9Xt6zibdyMFMzUvmqSbSz72F+nmFT3+Lkjf7MWn0zmA039JoDwZk6kOkR8NswVWNS3sDO/L8QoxfT/0kT1b0ThAi6GT10E6zFuRcoQBcrWeaTa4cx2zTZe5KDBsHP54Gd4tC92rhy1tQUaWcpqlFc5+F44nt77ruMvRV9Bzp7cLMVfThJwehODhHjPAgEzMQtaMve8UuOF3o1Kv4WLYGpFL1rDG6QYV3R7eL+QMHWbmvYSmzJMrhQUI2AmmjDRg7E3EiLHErNXowiQ/jQEF46eLH+q7RLw4XfTBjcNupZQYe5xfzjASwr5j+mwGDokKUVOEaGrpiXihITlJTtsdKAexehoB/6X4D5oQFp/uRsp4Q9ib7z5lilMcldmobQigFZa27+na+9DSYWJK+TM+42hgCRINUS/aTRvUFAUW4dvWK7gu9aldHVpw4bEOoD0qnpBG9TuBZHsQZKAJkuierP9eTO64S8zjmdo+A0TwRS18DD1TLF80j0fyll6Pxr38IoMNQxfIrrEgap0TGsIhPm6UHKt/Z5LWKLNUt68EQCb+CFdk4z/Z7RQNbeYnsja4CkRR2XeNIYg8D9Sfsl7lhR31erXkLTDL9KdW+5r1/ipMeSyi5V9nlkdZmet1NivQdr9CUezRqZ/QEDPzNl3nTuo2SQqvwdyPWpXCHK/wfcosQ/AJ703Xk63sJlH0moM0+9qVA1ou0Vmvz67Jtf0ilKzHqxA706I4XcUTyS5l9+A0YbcE95m1gdp6A/8QQJ1d+9
 vXFOQ9Mg
 so05lGWYpONzDpv8qRR4wQpGA5Nd8Xengdz8/ranBtue8HKpJdl7UqQJ6iDCMeadZoYoymGDV7FOpemvcgOYcJ6ClkscvpgoyVHQ0w1c+CRcvGY0Aiblt53E3ev2jNzfbLql9qAE5j/fFNSE59NoBE0cdi1YQPfB6ggTcb+6zz58ziymMgtFvyg45w0aEK61Dd0Rm12UF4ymhKcC3iHegQT5ZEIbygDRCwk0g878jkSYclm8l6d3DYAB4eubRP4VBAA/sAJsnGeXMuGGrUyROY0r0Mp91x8jZtXW6z4FuyQ+aqKcfaRf1EUolwR3aUhdKozUVJdzg6rBRRZQ+WnWmZuXe5klLQMk0glACIIQIYL7KAfut7EFLcNkZuX+HZWuD9b7cEs3ksrW8D9S6BTpzdcG2P7atqvKicT03l8CWRTeYGb6b4+5tYOS90LQJMRk82I2soIdxqMm81ldYHUQZyY6/y5GIB8h+gy/wJgpFWmOnbmJULdUexbAEnjVMbpmnDMCd/P+hol+Z5oOER8r8yyYwbMMJAR2F5LBDPwBrn8NeHTsoU6Y72KL6UbvoujGaVs+TrwZ7v8OpJP9lksBqrsNIeQonvmiuzJYLKkQuKKcLuSmKR5pUFq4FVkjKAufg/YsIhVyMnGhRQKZ0fuWHMEsdbHaDGO6WEeAs6FiX1TcVgNqfZ6D7HyB03gxcHr/XwovrFtH58wOyl1XFMuyEHPs2Jw==
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


