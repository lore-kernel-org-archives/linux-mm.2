Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8EF606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83A36B06EC; Thu, 19 Nov 2026 15:11:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C2E6B06EE; Thu, 19 Nov 2026 15:11:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD8A6B06ED; Thu, 19 Nov 2026 15:11:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85B6A6B06EA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:11:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04DE7160BF1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:27 +0000 (UTC)
X-FDA: 85452963456.20.9E49D74
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id EDD5A100003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795119086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/7+jDmw9PPr5XQtRbOeCRcxjCTyR2570BzVPmXYCK3M=;
	b=lQ+p25AApi1D41Z0J2fFObGKehJdWBwRMjQyFHsCVFnNN6luPaeP+2FSyvNnnZSdru3Lpv
	BjbGBfMgDUJHQ4TEhNfzdxcQFf2EtadtpsBCNCXZEdFAdWGgQFK/37xZsBZzBO6RMVkOQo
	Pq1xIBlD6HNZZzUy3DuvhHohHuFmQdM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795119086;
	b=7ppjRXFLy7HO35Sq4ZuIym8Fa4gcBOtEye5G7xCmzyyb7PZr6s7XLKonz1AXnAYKDwiPqT
	DO3S7mQBNODx5xjlQCIluKcOgUex56oxXI79Biku8w6OYVaxBFVKpS+XfY1sEDgycs0FWN
	JeCNpkFvUq367av72TSfF/OtCWv+OsY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F2E4B1FCEE;
	Thu, 19 Nov 2026 20:11:24 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E409A134F6;
	Thu, 19 Nov 2026 20:11:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OqV1JuRX/2pPYQAAD6G6ig:T4
	(envelope-from <pfalcato@suse.de>); Thu, 19 Nov 2026 20:11:22 +0000
From: Pedro Falcato <pfalcato@suse.de>
Date: Thu, 19 Nov 2026 20:10:46 +0000
Subject: [PATCH RFC 3/5] mm/vmscan: avoid releasing FS metadata for
 !FOLL_PIN gup folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-gup-dirty-what-v1-3-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Lorenzo Stoakes <ljs@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: qsfzif84xdrha5ibru5n1eapmt3difh5
X-Rspam-User: 
X-Rspamd-Queue-Id: EDD5A100003
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795119085-507507
X-HE-Meta: U2FsdGVkX1+a9GrnhgrjlsIPgrdy0p43E/te9XUMtcJ+56jXzFivRapSdTFZlzvFkXnL1w5tapYYaItXKFk5JHiMdUzh8zfSSK7kL8UDThg9R6U4XUaVp9732YjVyFUF0ToDds7okHc/4/b1OOgNwOQLZrxu+wBCeKz5uigHl2VUKY76eQMEbZw1Jl6kpXkQzsZLOZGz3fVBYRKFS8kB+7FxjdJCrrfrZgcorz5aU3Du9FCDkgo8MgOe5PtBWNVOvtb+WpDGW+lBedv93OXQZo+7id2st6iA8MpRqM3WrWvkXtluN3iG8cUD2jSSKYdhQYV+QSTU7frGSAfo2to5/tiAxG5xW2kEvnXXEQPvu/Xe89WJKxgGPnD5c+FGhOpt4aNuogpjJBgk+KJBKSqthqHpv/61eONDLxXm+eEnVA6zO6fI0gEV4EPuWAaSR2DATZu/z7T3baZnOSmn04aC5uZWzkwMK39QHN0J6rIqjLEC+uo1gyDLc/YdJWBUtreT+9kgm03ID0CmF7bzapx8iJKV/AasifPWzao0g5Ump0k3/EhRBgGVN5tdfFLrU70TxqvG231sQDoRMkds8GkA6jQw4BOup0Slot2XHsdDMBFAADSPLtdP7MN0ynklbhuLKbZ5r4bugeueEUbr1whktA+8AkY7AE4J+gNSAjlifzQRRPo9wRoYx9xuhqL6BF+7JS2Qv8NGUK2TArDLeB9+/k779trg0R4w/FpfcoaO9D7pSRVRp4r5oE8O5n/TeforfbrIOpz6daUk59V2AeJUoLO5z8+pvs5WATj4lCK7+xz9PS8X98RZmb6Szvp759WLwfRYP8/L9fzdP6DOzQTVrIji+veG7TH0zNK7VztsaLEkN3kgCvcj2Zu/gdXizhw1Q+wg03wcnOkkC5ZXRYgZoawJODngqbFpA6r7UdJ8zwYNmIy9EyVeKgBI7KDufoaLIi9ucPiKmHKOxIaU4mI
 ZRN9a97R
 g6vzlXBc7VknC2fXhX4BXng2lDxfbEX7ukWyF/adUyxKUxaG2u/oLJb2bpvKfJt0izepaehZS6/WJuFv3F8aRGpQQUC7vmoUqaTSj73hzvtRkugMup3al5CoCUpCGMIHUcev6NKxtqUsnt8UGr3GA1XWQe+8BxYrQZJS2AMP7VVEMZiZaZbdvxwLXFGLwTkA46RrKV24QP+Njoe/4jfppkpOF0ryGoLGR9KjGSUXMDQNX7ZRTWHoyvGPk9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The check added in commit d824ec2a1546
("mm: do not reclaim private data from pinned page")
is correct. However, it only handles pages pinned for DMA, using
pin_user_pages(). It completely skips any other get_user_pages() user,
that does not pass FOLL_PIN.

Replace the folio_maybe_dma_pinned() check with
filemap_may_release_folio().

Reported-by: David Hildenbrand <david@kernel.org>
Cc: stable@vger.kernel.org
Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/vmscan.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..d80bbb607a15 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1464,16 +1464,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		/*
-		 * Folio is unmapped now so it cannot be newly pinned anymore.
-		 * No point in trying to reclaim folio if it is pinned.
-		 * Furthermore we don't want to reclaim underlying fs metadata
-		 * if the folio is pinned and thus potentially modified by the
-		 * pinning process as that may upset the filesystem.
-		 */
-		if (folio_maybe_dma_pinned(folio))
-			goto activate_locked;
-
 		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
 			if (folio_is_file_lru(folio)) {
@@ -1566,7 +1556,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * the folio on the LRU so it is swappable.
 		 */
 		if (folio_needs_release(folio)) {
-			if (!filemap_release_folio(folio, sc->gfp_mask))
+			if (!filemap_may_release_folio(folio, 1) ||
+			    !filemap_release_folio(folio, sc->gfp_mask))
 				goto activate_locked;
 			if (!mapping && folio_ref_count(folio) == 1) {
 				folio_unlock(folio);

-- 
2.56.1


