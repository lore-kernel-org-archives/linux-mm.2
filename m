Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3B9C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD886B009C; Wed, 23 Jul 2025 06:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DE76B009D; Wed, 23 Jul 2025 06:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125F06B009E; Wed, 23 Jul 2025 06:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F01836B009C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:41:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1BFD133814
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:41:45 +0000 (UTC)
X-FDA: 83695188570.26.0210621
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9413E1C000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:41:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NKBM1xd5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fsknoIhp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0m8UJ27;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xCNm0FJi;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267303; a=rsa-sha256;
	cv=none;
	b=6T5r8fuchETYx0nyJmARad6Q54CtF9qWtati0764nVIFu+xWUGr+D9+VixluEXOskEe1/n
	Hll31n6AZDlIQG73WxLWb3bIMIWXEJxXYrOGtHnN6r7HrzB1yzoG7VPQQMSCOvNL/fs14Z
	UwU8nzmHptNGURvuJUbOMdhkB5kI+Wg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NKBM1xd5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fsknoIhp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0m8UJ27;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xCNm0FJi;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cYDispgFJbcU9UzWuoS/ot0t3xMqhlGClFolkxdcuek=;
	b=5QrE8zZZhTVMaC36cO91o081d3QDlXJd/baBpyhN9iOKpuF59JVoR62L3DFycWsS0qK9Kj
	vISZsH+FUWZBo8+Hs7sIw4taXmF1LjhyIm08QKXCetGl2494L603vQQuMA2kgNblOK/WTb
	fFYkg4EkeTmwEO58wQhDwZLC4sUBYAM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E77722175B;
	Wed, 23 Jul 2025 10:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753267302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cYDispgFJbcU9UzWuoS/ot0t3xMqhlGClFolkxdcuek=;
	b=NKBM1xd5hhTzbTqPiSyk5QXJkcG61Dqusg27TViwKYbLIS08gyHj03IMZxCROsZxjvN8O0
	RBGFlc6StQ2nYf/Hy6ui4z0p+mvq9h5MCdnGDv5xM/BZysG2XzNTMt1Uuq726a9FoEip3s
	h+oodcYtGRud5Czr+Bn0HiA8qC4IPzg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753267302;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cYDispgFJbcU9UzWuoS/ot0t3xMqhlGClFolkxdcuek=;
	b=fsknoIhppO56VFd6H3bw8yT50VVyKKpMwyAyvFBVWZ+zHvR/WN/Rv1Sh28eKhe9f3/TjLv
	e10LCKM9A7eteIDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753267301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cYDispgFJbcU9UzWuoS/ot0t3xMqhlGClFolkxdcuek=;
	b=Z0m8UJ27XSzMXQKk79q7WGSW7TcWfKiQ2J66nsA2YY2izT3H8iU0XPZoZJCriuKne3UBZM
	PfuVs5yrRsN1lmZvNBVnXHw9yx1f6Tuy1c01cZW04qjGkZUxhx1hiTieGzP2pvrtx+MoZY
	1vV67SnMZ9PnADaJa+UWiWox48lIin4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753267301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cYDispgFJbcU9UzWuoS/ot0t3xMqhlGClFolkxdcuek=;
	b=xCNm0FJiM3wqrOGGEIYAVmUhudcOoLDjUxopgEP5QhS5XGvt2DxI8LNg3IcgemTldGzFxN
	/LQ0ilrJzWzg6ABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A34513302;
	Wed, 23 Jul 2025 10:41:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tkwmA2W8gGhdbAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 23 Jul 2025 10:41:41 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Jakub Kicinski <kuba@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	stable@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH] RDMA/siw: Fix the sendmsg byte count in siw_tcp_sendpages
Date: Wed, 23 Jul 2025 11:41:23 +0100
Message-ID: <20250723104123.190518-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9413E1C000A
X-Stat-Signature: zfhxuqta4y3ppn1r7f35yx7odaijsggs
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753267303-562446
X-HE-Meta: U2FsdGVkX1+We0roN3rNF+z6PVXPLtDBLXZ8wlm/D7t6flSehkS9an//uKYf2/ZAX15R5dCkg3YQz5UeuicSBTSd71qxq8dU89Mb1FnpObsEtFiOMn1SEDAakFIbwbdRlmnMTpL8usvgvc4l8+5Btp7HWlDTdXqC+RDspG/qRkKgDuy7557i/JpsW5+BeTTEXuApkUNQvc1PMJKr2KaVYkNRW2X3ujmdtsGpM393Woiq6PDhUa259ZtsJIHZYgKWDmtACOk/vox8hzniqzkqSDRGJl1ogfNRuEO8jn2otNbJ0xlrgo9ePG2g5rGdP6psASrZ2fRbp/tovjJ/KAEWEcYzdtaEPIx8IQMQ170FdKOdHQ2yRXYV6P/lfqllM+ML965+CnQNjO0zeGuuzYcfSJHx9oEUaO9Ly38tqXaoxgI5r+DOdD3Zs+dM7gykHI63rFE6ORmgzdMI/ghpk5kA/CM1CLN7/NG6iKN8XZa5sF5z37/LlR3HeumsPIi+XnpkV1eSPXHv56Gcq6YA/yVEzTHTi32T4OmPYCC44Wey2pexeMRpovcQqkNBokLbUM0AKHAuKH7BnO60Ruz2pN0x6FS/ioNsMDWL0O6tC0bNfQlcgwQV0PwwflGkghjUcjCzfB9SD4CurrZlBWlQtqjuNj8waLkiEuVp4mWgALyNU7runwH0Q7j+uVZKuXDzesax2BtYfdtEiW+zOxpGbkjAPelEsZHreNI9GlDRXQYg3HzqH4MUb9MeEVR5Fukv+gu+4NYggtSAbfyJdnhBoehNFyRjAp2U5DjOKmQrYa74bFJjsv/sSzD954jgg4BJs9Q1W4T8mkAwv/q466/ONgq3sQHsexYqxCq0ItDyQp5wkVOzNNzwdVPISEuGKUi95RBtEd2Qwix4lYO3fum5JQLzjq958P2RmDlXRBJ0a9J+/9SCqdPhnAJe/CP2OK6gqBXvmjnadKm91ThZBXEgRf4
 Jl58PG+5
 x2dLFZWNJQUzFCD84yfHdEgz/CTDMfMUCHtU0VLThyhl0NdlfwwNT6PHvw8iDRcXuqnDQ1x+UUxrS6X/1Ar6OGn7nwmwD7ADnez/UYyfzXWjWRtnpw6gzXSIEzSRw2KNLtjmsZXVi3v8rRbB61H6Htt+6q/PsPGEhpQKaYdCVBFiWH1EtQ/nCTVx3CzSC12LES6184lPmCX55RuGXw/cMDCjNx2JbxyxZsDSyEIKO25qlIHEaCKVHQf63Rf/7boqWAngLJ5MmHI9BgUGqgF1T48/Om9wRVB4zfP49xEEockggT3riVyzH56wqi5wfB852XaC1eQkpHyDbi/5W1kg6KpgpBlDTJiWoQmY4
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
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 3a08f57d2211..9576a2b766c4 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -340,11 +340,11 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
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
-- 
2.50.1


