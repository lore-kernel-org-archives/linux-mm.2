Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C90CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 22:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272C06B0005; Mon, 18 May 2026 18:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222976B0088; Mon, 18 May 2026 18:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAE26B008C; Mon, 18 May 2026 18:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F061E6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:30:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E44B1C094B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:30:50 +0000 (UTC)
X-FDA: 84781986660.17.8BC64FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 847A51C0004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:30:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YFDEuHca;
	spf=pass (imf20.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779143448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HD9l3rshhdvjF/dR6TAQujaSrodzR3TFHgxLsri2Hp0=;
	b=L/deL1mwUMic7AchUqqEIjHkDC9wLTtLNFgQzwLgYU6UlwvtVeo1QP0rSU43A0Pyjmt18E
	T5dK3fu58wbYL8DzIP+ijWwx0ncXBzl0Tg9p9VhmSZAiaRpru4mrQjEOwxc8CZ4S8zVJtt
	4aelywRHC0tuBK4FJf7VrLnKFCDKxC8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YFDEuHca;
	spf=pass (imf20.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779143448; a=rsa-sha256;
	cv=none;
	b=Re64HwgL9TcYoi2Rq/7wj2jVFxoRLHpCt7mtlTUj8Gu5ZBssOtF6p3PNlmKrllLtYmrpNl
	2epYKKoU8FVhox2b1/LavxsIVaU9nIPqsPOh3jd6s0cUvCVXsojPfGwQIPT5jPgokdTNn8
	0bj5QyfzKUcYbZvJ8LgZuOyZqfjaTLA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779143447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HD9l3rshhdvjF/dR6TAQujaSrodzR3TFHgxLsri2Hp0=;
	b=YFDEuHcarM9mzVt+OJ8r9M1ZmN/L5kmmkRSKNrLKm/D9XGx05DfEYBkWsTCOnI748T6X4Z
	KXVHdDFYKfnUbeJ0faajBPRaramvjS6mr8nxFcAyLOiL+4KeTTrabF8z/RxwNZV+EGBpzX
	vctERehF4j5uE3xcrdUQK87+TBHDsjQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-RvsjchMwN_myCVkbLd44bg-1; Mon,
 18 May 2026 18:30:43 -0400
X-MC-Unique: RvsjchMwN_myCVkbLd44bg-1
X-Mimecast-MFC-AGG-ID: RvsjchMwN_myCVkbLd44bg_1779143441
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20738195609D;
	Mon, 18 May 2026 22:30:40 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 16B91180034E;
	Mon, 18 May 2026 22:30:32 +0000 (UTC)
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
Subject: [PATCH v2 03/21] mm: Make readahead store folio count in readahead_control
Date: Mon, 18 May 2026 23:29:35 +0100
Message-ID: <20260518222959.488126-4-dhowells@redhat.com>
In-Reply-To: <20260518222959.488126-1-dhowells@redhat.com>
References: <20260518222959.488126-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: kx-r9McFatbX7orAVvy4cIzCau-0lzWNJ5glKD_eLZ0_1779143441
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 847A51C0004
X-Rspam-User: 
X-Stat-Signature: mbzx8spgjsenpe145689rh4r56ay6xx8
X-HE-Tag: 1779143448-450729
X-HE-Meta: U2FsdGVkX1/46iKt6x4pFezVKPzcTbi5qQoKwCWDS077Ww4A3r1NFDENDZBXxbG97tmcsEr9GINF+QjRRXeMgQleeZ1uCEO9jQ/6ZIormMM7XAcdyXaEU7SC2K2KHdupF9sjhFcdbLYXdMDFPMyhIiXNKUbMHdj9hu9Jomr8dawTv8qy7UgsfAVUAPKp0Ttyt3/LL29PxDXLyQrHb1iwF3wvH0E42XVWPKPbZ6vOkBfRYEbo5cw1HGY3IamDNxbC2Rpc2mlAzae1mxHsIun1zdGJXWkVefj+5h5J7gBdO1v5uP//TgmPx1+lkWjeA0zN/ewlWBtDWdMWKy+avaanGO6GwgjLbGleL5DeYe91DovVTbkSe4kx804az5vA+DlfWVaLIOJ5hzXjUHYhBhs2/dCGE65ti6dV9fJ4tR7VRwZebYCrJnt7SBOTrQeMmDyl5g1WbPGYvO8SmmhtdNW/ijVNypGWcLeQY/S+wcV8pF7mMU8E2DeRuZIqEch9tuJLpf24WN0zu2lJLo/fBw8tjH+BujCObyGXdy9CNtwP2hZsGnLJJyx842YEKsEowHzFkmfXltKJaTGXUxVx7aEKtXy2PT1nY8Us8hpJ3PTlbXQryT0Ufa6EFCEUOmUSriiAPwbrs9xWwqycZTSWDLp1i06t4KELt4JkMOO7i13bg//24NoiDARAwlRWlQE07sPPOM949FsSvRD/po3YuHKxu0IXU0LgGogXNifJYFppAMsbpEfZ7qmfhagAYxL9OBy+h68Q04dS6AlMuz39qKF6w+530iifM8GFRKrQQHKxyDD0js8DIAhMao3BOr95Mn5La+2iSzjD4q3ec8vsBxHwnc+W+bulQf7izcm10Aswx6Uk7nTXFi9D0fxKasekAHTbMhS02dg66u4LK8x07MTvhZyTheoXob4GKDB3w9OXBtFtGGj+uoNrhHR9yfaDtZb56tBFBpiPPoe0KYBck39
 oRYJXmJx
 cJcJdSQ6AihZAl0kCAEi0AtkmsVm7dDligcLNoMDjnOZAQMPVtn87X1sdReKx+G4fXNpilu2ndvNuLNBcL+/W7YAWW3dArlogmyt3HGm7gkN1QqVZhGFJZncgr0Fv5bCZ18DsfkglG48qS/8wQA6nm1efhEvw4EGdZm+wUKvlU8AtZEa3s5ArzukvdG7UBtrH3hGcO94gEBswg9CiQYbUrP2Qv2LvEUYhHQnmj1e9dvyBJ8rhrtZ+vV4XxFVZaVR5LD78uTQt2m5RjEaRvN72rDuZ0FTMopr33fmDyfMe75/OXgxThtDkkpobOCMQygjD+n3QDRVCzMnPJh3qqLDgNJH9zLeavHqyqpqiVQOHPWK/Egl5su8cfR2Bgy5USrjVGwHZiWpq0IpK80OxtrKjph4k2SnudCnuyn9hhg7tCmHhIcemRvjSATo/7bL34nRMddvo0U7q5huTJyw4W+aNjS9ySHUp6SBdqmMSorD9LBnPLSgRR9S0knVBdw4Qj6qHOzG0pFU0mJ8XSDh7zvYxdFntiwNLOrDkz3kzK/y4MQOPU4lSgnbTJD6eGOmdZ2X8la0uWS/+f2dnklHVM35hvUQrDg==
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


