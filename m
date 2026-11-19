Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852E460A2618
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eUas+9Ii;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9uOMWgZ7;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eUas+9Ii;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9uOMWgZ7
Received: by kanga.kvack.org (Postfix)
	id 3D0456B06B4; Thu, 19 Nov 2026 15:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381706B06E0; Thu, 19 Nov 2026 15:11:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294876B06E2; Thu, 19 Nov 2026 15:11:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE8766B06B4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:11:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48B6A40BF3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:32 +0000 (UTC)
X-FDA: 85452963624.25.7125DE1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35F47A0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eUas+9Ii;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9uOMWgZ7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eUas+9Ii;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9uOMWgZ7;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795119090;
	b=MMvwSInHIm5gNgqsmd8hsN2PeUGWCk5w/ezAguDH7pX/N+regB9RtubnBSFMqFPkgdvVIH
	a5l7jS7dWigKoanw9SHB/FRD4raaEpxIfLJthLJRIolWzCpgY988K+1881TQVZ+OMMqCAV
	fpCbIaIk9o5ulFYg6RVNn1jjwLCfm3w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795119090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uo8Olo98zjikgX57G69RkSYYgroY5lrc04l+gH4JzoI=;
	b=dBwc7KDV2zzeb1qo51QOENadWa8gPRjUua4Lq8wg+ByMt5OmwVcaJAvk/1uE0jS4XhK3/7
	/4okeZ3vqZ5n+/RlOAWZo8CBCNIAkO6OP4eGBMUDwRjuIBZx5vWZV6Ne6wb06OpTPUstsI
	eBp8n39TtDEyMdRTldlcsMe3uCH/chI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eUas+9Ii;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9uOMWgZ7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eUas+9Ii;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9uOMWgZ7;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 157D521DE6;
	Thu, 19 Nov 2026 20:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uo8Olo98zjikgX57G69RkSYYgroY5lrc04l+gH4JzoI=;
	b=eUas+9Ii0hUYbJmdigy5WcIR6MFLbDG4Q9+MkKg469E/fJUfE5s9LcwEWCZ3ugZSzJbQ5E
	G227ThVtEgjDER5qFmK1F/+icKCjUX8+0fRswIRqHMGNAHJfdWh4NdyBomb3k1h29ogcpA
	wLvJ+2nCJSl6+n/ZHpjZrYGuTlwOUM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119089;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uo8Olo98zjikgX57G69RkSYYgroY5lrc04l+gH4JzoI=;
	b=9uOMWgZ7LG+LRni/R/J6QJ0QU42oZZHseqFgpO9phvi749VDZI6fswGtgIFGlShqu3eqYu
	vCHCaUFOxZdKZxAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uo8Olo98zjikgX57G69RkSYYgroY5lrc04l+gH4JzoI=;
	b=eUas+9Ii0hUYbJmdigy5WcIR6MFLbDG4Q9+MkKg469E/fJUfE5s9LcwEWCZ3ugZSzJbQ5E
	G227ThVtEgjDER5qFmK1F/+icKCjUX8+0fRswIRqHMGNAHJfdWh4NdyBomb3k1h29ogcpA
	wLvJ+2nCJSl6+n/ZHpjZrYGuTlwOUM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119089;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uo8Olo98zjikgX57G69RkSYYgroY5lrc04l+gH4JzoI=;
	b=9uOMWgZ7LG+LRni/R/J6QJ0QU42oZZHseqFgpO9phvi749VDZI6fswGtgIFGlShqu3eqYu
	vCHCaUFOxZdKZxAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B280134F6;
	Thu, 19 Nov 2026 20:11:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OqV1JuRX/2pPYQAAD6G6ig:T6
	(envelope-from <pfalcato@suse.de>); Thu, 19 Nov 2026 20:11:26 +0000
From: Pedro Falcato <pfalcato@suse.de>
Date: Thu, 19 Nov 2026 20:10:48 +0000
Subject: [PATCH RFC 5/5] mm/filemap: refuse releasing maybe_dma_pinned
 folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-gup-dirty-what-v1-5-236d69f25c24@suse.de>
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
X-Spam-Level: 
X-Spam-Score: -17.30
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 35F47A0003
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 55ttudbjc4xoxhwrnm84rgu5htoyshp9
X-HE-Tag: 1795119090-248650
X-HE-Meta: U2FsdGVkX1+J8fIFjGXY6TU+vPoFdYeryhdj0mmBHXhMdkmXQsYugtSZ7p9IAEwMbBaHZRzYEsL0kCUmM7VD92RsMjF09ekZhzcLyIbDXeQ1ARrsRBvnJvzf9si+tih/57ssTly+XcfpAG2eeJKXUIAIobi6BFqQTh7zOegDN7SaDS04Uy52BQIgUApHQJZ9y4S4wqeXnbhF5s7MJoDGR5qOOIKOxiXAL0BPapyfOlBGtjcEi8vJ++RkWd2R5IO5DBFCbRaLc4G0jjl3SxIWHhw5uepqIQTby5zoTJnpRoD0fCu26dXbhrQ/wWeDT94L9JwiKXDZoeFQYYd7mwguhsxVBbm9coh+ChupsUwmNAPgvHW/E2wh7BOzCdxaM1bp8shCl47Ug/32x8qHgtLfaFIvYhVKYPpwD5t44Me7CgCYYO6jUl4iXZkz9ScqVQaJmXO+kkK2ChtUxTPyX1xGjpojTuXkkTyGVuWbqAWpYzWg5qtnsWNwRPljY3uDKQBavJ3OZC6XqgNv4l9tOUgcRNfbx3zHOrw0NcUTBR3FaijjKma1k1WVpphMsy3JTXJDTi9D8ormJLlqvGn5vGcCIt8hgvJce4QwhZFXvjdehRAqHBZ5sXuTyFXCNC/LivpfHjm4TRboYQvrMVtXAKj7Wlphz/ZiqgHdqYPSMvyrbHnnX3Qc+v1wyLo4Jhu258VJo5bIxYHGvooQ9wGvSa6IVF4XrPIuwR0djCQxgDO5Nka3tS9eSHuQIgJ0iMySirSUBF+PVHaiU79MZTMtA16eaUQP1GIY3MUm6hYAhrRM+GfAiArgSrzOKDTHm4f5QSdW0xvlP/MYHUZ8gP2zZbHOa7b2i/iClLHzSPugjAQx9lGckJD6+bdgP9VYiWitcbGFD7vzi2Zf110F6MAwO2s+A0B9QifGvSlN7+52PuMsbL7RNbv4eBldZd+Yt0DynLDNZJ1GOK99vyzfOecYQsz
 1l6IdM0j
 nBjcAxqT2rDwacjBP5exEbKbubhlKz4upvZsgs6+AJwrqlnLWiBCLaIMiJZdhMI+fSPeXbcU5Xho42f0Pz+njAZ57tAMmdI7+v/YvgxHwliy/+NqDxu1AcZKczMqe+SNquXaq5egCzYmgDXpApl1DYGKyDLdNiFsqlA8PzEto/dnV+rsfYGkQbLEtXh0hhmwoLRH/PDTW9T1mjInSX8paZc/peFOqBxz1kHGqFUtIM/jvUZYNW9mxpEJSe0e3fwBz0KcsqsC62K0Fh5/evma8SEtUREip0BvSy+Zy//7Wei9naMmwFNJc2o4WVi+dk2wy+81sxNDjHQwVvx6yQJmST28fRAf2UJMhqw+j2Wyz3pv5WlcfMJCCZjKil/NrpLpBmow3lPEbBxQnd04wfWyQ4RFc+S8SI1WL8KCWWNNwxyppF/lzI76PZKqrkuIoKuH3mTqtN9z/XmF+4PQJhrtJayYGASNfV7jMMgGcOZd+fDa57r8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Some callers, like folio_unmap_invalidate(), call filemap_release_folio()
without any care for folio refcounts. This is on purpose. As
folio_unmap_invalidate() states, invalidate_inode_pages2() needs stronger
guarantees, and "can't afford to leave folios behind because
shrink_folio_list() has a temp ref on them". Ok.

Use folio_maybe_dma_pinned() universally, in filemap_release_folio(). This
has a much lower false positive rate, and should be ok enough for most
serious cases.

While here, properly assert that no folio passed to release_folio is
mapped.

Cc: stable@vger.kernel.org
Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/filemap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index f9e34144c53c..4fa75663b7f3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4571,8 +4571,11 @@ bool filemap_release_folio(struct folio *folio, gfp_t gfp)
 	struct address_space * const mapping = folio->mapping;
 
 	BUG_ON(!folio_test_locked(folio));
+	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
 	if (!folio_needs_release(folio))
 		return true;
+	if (folio_maybe_dma_pinned(folio))
+		return false;
 	if (folio_test_writeback(folio))
 		return false;
 

-- 
2.56.1


