Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837AEC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 12:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A046B0096; Tue, 29 Jul 2025 08:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F011E6B0098; Tue, 29 Jul 2025 08:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF946B0099; Tue, 29 Jul 2025 08:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7BB66B0096
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:03:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3556459BB8
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:03:56 +0000 (UTC)
X-FDA: 83717168472.16.9B0B920
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1249B40002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:03:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XtJCeYlB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2gTfL68T;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XtJCeYlB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2gTfL68T;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753790634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J0XRPjML4mLkSrnriwK6SqbV6JTvs/+OMjrGpcQkY60=;
	b=OquZKBwXpksbtjoPrHzwgQusZ9KvICoyhCrUQClx8Q2wsZmih58RgNXcJGlNqnJLEWQpvZ
	izTvkjFBHLqNmVy9Zd3GDP2GpjiAM01IKyiNv5RYsb81HLb5wE1i7GaDOxKXLpIZRNhAGB
	nXDf4cnUdHItZ05tkRnb/DUjMSkWAeQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XtJCeYlB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2gTfL68T;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XtJCeYlB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2gTfL68T;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753790634; a=rsa-sha256;
	cv=none;
	b=RluMjTEQFM7seFtV0m/DWnsLErKlGyKvYYe4AHg8aAmvFZObBS/xBlowTL+gG5ehsM7nps
	Z3zDObp/thkf4m42MehzBq9lDWKhlzPU1XWvl5bvnJgoODmupT5bKbvy2pLeiBOCmvHb0X
	o7YRBiexOgL9He69Cv18lctgbYiFeao=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 69F9A1F385;
	Tue, 29 Jul 2025 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753790632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J0XRPjML4mLkSrnriwK6SqbV6JTvs/+OMjrGpcQkY60=;
	b=XtJCeYlBOBMphfzBASk29AT60ZxONQrTpxdmyfAbTxnb/8JuDfgxqCqqw7xKrrJuFxIHTf
	G6D3J71PFMuPHYax1syPLYD1d4tq27MUdZ30IMxCJKY0H5bed06reZnXB4+c3u4Um+cSKE
	RY3EZ0dANLe6iGx5UVsey6oxM3meKgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753790632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J0XRPjML4mLkSrnriwK6SqbV6JTvs/+OMjrGpcQkY60=;
	b=2gTfL68TAlrWDeCcPnskaHrjv1hiZZJ28qVZramfsYwWXZYLjYF/R/ehHFa3j7XzcGdDSp
	YM0PlqwLRNCIDyAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753790632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J0XRPjML4mLkSrnriwK6SqbV6JTvs/+OMjrGpcQkY60=;
	b=XtJCeYlBOBMphfzBASk29AT60ZxONQrTpxdmyfAbTxnb/8JuDfgxqCqqw7xKrrJuFxIHTf
	G6D3J71PFMuPHYax1syPLYD1d4tq27MUdZ30IMxCJKY0H5bed06reZnXB4+c3u4Um+cSKE
	RY3EZ0dANLe6iGx5UVsey6oxM3meKgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753790632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=J0XRPjML4mLkSrnriwK6SqbV6JTvs/+OMjrGpcQkY60=;
	b=2gTfL68TAlrWDeCcPnskaHrjv1hiZZJ28qVZramfsYwWXZYLjYF/R/ehHFa3j7XzcGdDSp
	YM0PlqwLRNCIDyAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 789BC13A73;
	Tue, 29 Jul 2025 12:03:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ucgnGqe4iGipAwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 29 Jul 2025 12:03:51 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Jakub Kicinski <kuba@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	torvalds@linux-foundation.org,
	Pedro Falcato <pfalcato@suse.de>,
	stable@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2] RDMA/siw: Fix the sendmsg byte count in siw_tcp_sendpages
Date: Tue, 29 Jul 2025 13:03:48 +0100
Message-ID: <20250729120348.495568-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 1249B40002
X-Rspamd-Server: rspam06
X-Stat-Signature: f8bwf4tq4xk59zdge5k3x9nd649q9rj9
X-HE-Tag: 1753790633-762013
X-HE-Meta: U2FsdGVkX181Qft8CxzowjDR9CZubHzXbkrRJ4QdV6Gdn9lcrmt0yswHPixaqu9oC+4KT/w731sYY4qi/xHzFAOMxVRGxZUJwE6HyMPnptgpvjsaRBgIflIeFhQ4486dymdAbiciWRYAV2EZjKyGstKQPUUyx6MvFXJ8sRqhqFNqdxGZwFQcbdJNnYglxhiX6ayiwkRsCqG5BFFjUMmhXVw+GFpn7Vq0N/brN7rh9327w4JJaUpSBXjm91ddnGYx7G1iIXWtJIbJ/TUTHjNuwmlUCUsPqaYTeq8BTh+2YFsr7/a4nbYrvhWnVbiIN03nMUM6FQed3aRoZZJ1hTmyxFw9Lyz5D/tYYHQlMHMy3bsNgXp2ZZDeHqtMh+Ep2DX7/8oFIQiF5tQhhlJSjbBZg2gACMDnqZyk12fYkwYO1OZNKZaxsEVxiPR/gHyd4YQtNw0Yjt5rBNIRtp9aB+gzI6LCMrKxxI33PteHvGzWRxBr9GJHsSyTpColcZFbs4+DjzMgR6nVHbVGXNVkY6zXEOB0+1PtCJlxLBohhPgR4KWCEBOaqI7Y4Z8oJXLs+aZQOycKTUatq/3CRxnohbyF5r7pMmgWYuYSXJuor3+/poshga1korX8lBIEzKWFMAlZuGhfS/busY/v3K7L7Uxy8Mjiq73X/6gck911wj+SmaVXP1XFILkpvT2Ov81+yoJ1LpAb0kJxJywBC54JhT0uPZlPrauwMttpgbE8AlN3rrcbkUQ+eicJj+PgH++urITUWLfzhd/FUzmWVSFzdQ8j9t8hmaSRJ1tfn8JWuCnkyk6GVIPTNUHHfay28cC42YQ8Kxv4a/zehRp80VrXfG5ls2yPvZPvJgykPtkPH4R4cM4cwDNUu/QWXI+3kWfpXASoG85mOkHHMxTLdJbbCPY0UBVqOLYMKres1Ij/3hDZISY+88mDVTd2Vl5yQdffw+EsoM2U2cOkvsQcff3RRr3
 1p+u1hXB
 9SlojPGsD4Vn/AOHHub2vdx+xXrOWXYP7T8kE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since commit c2ff29e99a76 ("siw: Inline do_tcp_sendpages()"),
we have been doing this:

static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
                             size_t size)
[...]
        /* Calculate the number of bytes we need to push, for this page
         * specifically */
        size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
        /* If we can't splice it, then copy it in, as normal */
        if (!sendpage_ok(page[i]))
                msg.msg_flags &= ~MSG_SPLICE_PAGES;
        /* Set the bvec pointing to the page, with len $bytes */
        bvec_set_page(&bvec, page[i], bytes, offset);
        /* Set the iter to $size, aka the size of the whole sendpages (!!!) */
        iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
try_page_again:
        lock_sock(sk);
        /* Sendmsg with $size size (!!!) */
        rv = tcp_sendmsg_locked(sk, &msg, size);

This means we've been sending oversized iov_iters and tcp_sendmsg calls
for a while. This has a been a benign bug because sendpage_ok() always
returned true. With the recent slab allocator changes being slowly
introduced into next (that disallow sendpage on large kmalloc
allocations), we have recently hit out-of-bounds crashes, due to slight
differences in iov_iter behavior between the MSG_SPLICE_PAGES and
"regular" copy paths:

(MSG_SPLICE_PAGES)
skb_splice_from_iter
  iov_iter_extract_pages
    iov_iter_extract_bvec_pages
      uses i->nr_segs to correctly stop in its tracks before OoB'ing everywhere
  skb_splice_from_iter gets a "short" read

(!MSG_SPLICE_PAGES)
skb_copy_to_page_nocache copy=iov_iter_count
 [...]
   copy_from_iter
        /* this doesn't help */
        if (unlikely(iter->count < len))
                len = iter->count;
          iterate_bvec
            ... and we run off the bvecs

Fix this by properly setting the iov_iter's byte count, plus sending the
correct byte count to tcp_sendmsg_locked.

Cc: stable@vger.kernel.org
Fixes: c2ff29e99a76 ("siw: Inline do_tcp_sendpages()")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202507220801.50a7210-lkp@intel.com
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---

v2:
 - Add David Howells's Rb on the original patch
 - Remove the offset increment, since it's dead code

 drivers/infiniband/sw/siw/siw_qp_tx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 3a08f57d2211..f7dd32c6e5ba 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -340,18 +340,17 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
 		if (!sendpage_ok(page[i]))
 			msg.msg_flags &= ~MSG_SPLICE_PAGES;
 		bvec_set_page(&bvec, page[i], bytes, offset);
-		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
 
 try_page_again:
 		lock_sock(sk);
-		rv = tcp_sendmsg_locked(sk, &msg, size);
+		rv = tcp_sendmsg_locked(sk, &msg, bytes);
 		release_sock(sk);
 
 		if (rv > 0) {
 			size -= rv;
 			sent += rv;
 			if (rv != bytes) {
-				offset += rv;
 				bytes -= rv;
 				goto try_page_again;
 			}
-- 
2.50.1


