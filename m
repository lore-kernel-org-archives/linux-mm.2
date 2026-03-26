Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA4910A1E64
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73FD16B013D; Thu, 26 Mar 2026 06:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717516B013F; Thu, 26 Mar 2026 06:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D886B0140; Thu, 26 Mar 2026 06:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 520B16B013D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:47:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 053CE13C11E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:47:38 +0000 (UTC)
X-FDA: 84587888196.23.BF392B4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB525100004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:47:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHomx3ov;
	spf=pass (imf05.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774522056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmw7T0PnOLgxIpELQ9rQpU7AHBZsSNPxjlfKpKQj97s=;
	b=Cudn0FDjLIWAc1+4QM3VTmVupAbFqKMf6cwKmuEL+G3Yl8kAqLf4O0+An7KERgnzd6yOr6
	yLGvc2Pqh7T18bWR12vPcOHnwKVJAe5oeGtrp8oXRxaOl04FMTP6UmzQATg+THLQ3TyS8l
	mB3YdXXYgZR/seQHu9EexJd7oTZMwoY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774522056; a=rsa-sha256;
	cv=none;
	b=apj2zjaE5Y8hkGdpbUrhOZ7LeMpgaM3DnKAhmF5HvqLwMTTaOaNKmTVEsXW24ofrDwrcwj
	INxesR4Sw3nXPiFdGgZj1Hxo5MDbV/pv76GZtNtNm+7rG9M01no1YuGpYrzlzJpBhKPK+p
	OWpECOnFd6aEF2ERYlQEj5eYKJ9UlgE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHomx3ov;
	spf=pass (imf05.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774522055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vmw7T0PnOLgxIpELQ9rQpU7AHBZsSNPxjlfKpKQj97s=;
	b=KHomx3ov+TWDkoUfZjO6EuJwfc5f9y529L2rdXc3WBTYnBt6d9NxAaW8znbnsHmmBy4gVQ
	6w24IP2HqClPzQgj2lijwZabac4y9s9jrjaNtZVTU5ltx9ifb4PeJlEebMtU1AJbgboGGL
	4wGZOVvUr3kcfZTqhVYdhke2ZUOHBqE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-jGSoJECHMrekBUYeanVpuA-1; Thu,
 26 Mar 2026 06:47:29 -0400
X-MC-Unique: jGSoJECHMrekBUYeanVpuA-1
X-Mimecast-MFC-AGG-ID: jGSoJECHMrekBUYeanVpuA_1774522046
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 483F218005B2;
	Thu, 26 Mar 2026 10:47:26 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.121])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8E95019560B1;
	Thu, 26 Mar 2026 10:47:19 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
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
	Paulo Alcantara <pc@manguebit.org>,
	linux-mm@kvack.org
Subject: [PATCH 09/26] mm: Make readahead store folio count in readahead_control
Date: Thu, 26 Mar 2026 10:45:24 +0000
Message-ID: <20260326104544.509518-10-dhowells@redhat.com>
In-Reply-To: <20260326104544.509518-1-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 4tvWGGPxw87XmAGWdisvZOntRwfLwKbx2V5iQ-NTXy0_1774522046
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: EB525100004
X-Stat-Signature: ywzayju8do5xpqaiyhk6wwx5u8nmyyf5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774522055-94762
X-HE-Meta: U2FsdGVkX19xYlOBUFKJKQ9zU2p9kXAxBxvyNTkTUhTwMN9x67prP78EZvlqRu3SfqTrHslzC/81mJFLaSTIs5kSUIrBXztdWDdQCg/hq6Nkm1DPZ69YCGzCzIf+OBiNIzuino4ffiwtAMObh6hrEpww8Ha16COa7+Kuon9RrCmdZ9JEk7CPpdJneJRVcuk191jmCqchFFoRr1i6hNuxCoMg4YEdudaKIjpD71yn3Gg0aVZnPrD7ytUG9KGjII65PqTXkeJgj20Py9Z/0w+0Lvo6303rDO29mMtxuO+le5swZc9GW+7tHChbVhloYrsZX2zbuSqYESo10W/9paYJc4KY7UTmwlpPkEjdUzcen7lfoFB1/oHQ+NhEeW9UW07pIu6Og3Hx25S8DeTnIbJ7qdX1DsNr/gypgJNrraCiNkvttxjNux7hmXFfSY8nGDcTIqPoXtyPUMSy56+O2dAnVKd9nqFo8/SGZ8lhkH+2qffkcKPuDHpQ+abLXXwA+HuntaBgCAS5fDG6qtxc15Mf8c7qEp/10Ojg4Sl7xx8o+b5yix3f8uohuoDeVKRFdknWM04mPUDVB+X/OwQtQJUc4FuIkfi8DYVJ42cPtqqA99YYlcoXddMl9n434bLvcyM/ij9DSZu+nqOPiZzOdtbOano73E/opPEibyKHK+U7z8D3jKZ5k1JyGMV+PVjzfyWatO7DhK1R5NN4JereeycL+GF1LUT1LqutzPXee4PEpqws99+Z/fR+pJ4kJ4DkSLzZwyFwkiF0abVAXs5kSYklLSAcEOibWC0rDp6G5dcsrZ/opBAlfucBFVMlyyP8LrP4wwqPinGu3fLLIWsIGrRv4MuVLhdE6+iliYgYcUt1yrVXvAwx2tk2KQFn5CaW2G7YGjsDmxCRKCpgjFe+oBuu+8TvvOQjVZXRKIb71KGucS/RMqDHxBPdHx1s1k4nzOzScBOTvK56q+fNUrHzfJf
 Uy5SM2fX
 i7c27rGNzxSx8QFUXyRRGyyW4UqtgucODFACb0IeUzUEO+G0sdXngZoxaew7eioK+iow8Qwop2QEmRD9qaEI00PRNsQEDOnVGR6uz6T0udgmQK6mVwHqfq3lKEv7MKUoO3oRYzZ91bOX1vC8IcBiwDGJG/pKReyVj683GzRk4aG0QkHyEzur0FRYmQUlwK0GPzMAcmUr6dH2M+ksO8WZTfJbhIjOGuQbDOWqV7Jv73EWxOU4bmjH4+EfKC4PcqAuO9KSlvSBab0J5kgd45m+5N6ujBXWVjA4b4+mKVpPAqPpFOWyupuh6uHSkIYnLjGB400y5oYIypsfZCFNJ05nKKw9Wr3iOTMeCzU0Yw9Q0lxbwSlqVdA3afKkL4EDpUdJxie0DhArshGHFwqh74Z1nbY+Ztzq/4xZKWmBGR4UWQOu3lxWrwH/4SECGzT+wfvM1SR+DYs/HH/beuBo5XKyYHkJm1/rIyq6Um01LM7FHCYPafFMKGfODov434lrizFCtR6dPfd+hF/t2H/8O0qclVTUlTAHCCFhFzIE7+smLmJG7mO5RNvHtObmdVBSGzGL/+Q32Vs+8Ip4WzQ6LsAnkOmTZXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make readahead store folio count in readahead_control so that the
filesystem can know in advance how many folios it needs to keep track of.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/pagemap.h | 1 +
 mm/readahead.c          | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..3c3e34e5fe8a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1361,6 +1361,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	unsigned int _nr_folios;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c89ea..53134c9d9fe9 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -292,6 +292,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 		if (i == mark)
 			folio_set_readahead(folio);
 		ractl->_workingset |= folio_test_workingset(folio);
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		i += min_nrpages;
 	}
@@ -459,6 +460,7 @@ static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 		return err;
 	}
 
+	ractl->_nr_folios++;
 	ractl->_nr_pages += 1UL << order;
 	ractl->_workingset |= folio_test_workingset(folio);
 	return 0;
@@ -802,6 +804,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		ractl->_index = folio->index;
 	}
@@ -831,6 +834,7 @@ void readahead_expand(struct readahead_control *ractl,
 			ractl->_workingset = true;
 			psi_memstall_enter(&ractl->_pflags);
 		}
+		ractl->_nr_folios++;
 		ractl->_nr_pages += min_nrpages;
 		if (ra) {
 			ra->size += min_nrpages;


