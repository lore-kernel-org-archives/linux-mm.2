Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348BD606A883
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KRUt/2rK;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FSWB8QHv;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KRUt/2rK;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FSWB8QHv
Received: by kanga.kvack.org (Postfix)
	id 5004A6B05B3; Thu, 12 Nov 2026 11:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489C26B05B4; Thu, 12 Nov 2026 11:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A2E6B05B5; Thu, 12 Nov 2026 11:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 069076B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:08:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96883A066D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:08:36 +0000 (UTC)
X-FDA: 85426949832.27.D25C013
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 62BB8C0013
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:08:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="KRUt/2rK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FSWB8QHv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="KRUt/2rK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FSWB8QHv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794499714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+T3ab9ZuDlb9AtgbzYcZLqb0pcIRcAvo/vUSdxHxz0c=;
	b=v3MdHaUxTc6Eg+Wru+6OLlPOnRocQsiNaqLkr4Dcii3AEI7zGFzp/icJr2Eu5pl5nb9Jng
	q1kPR0ruadof2iJXnDfUWeMDVsAUPfZpD1WhCPsRQG7jaGmvDkoR6hcnf4Lr+0QBSaTeWw
	SBZrY4Tw07OZdnz0yuUAuBcEPFH7cKU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="KRUt/2rK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FSWB8QHv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="KRUt/2rK";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FSWB8QHv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794499714;
	b=sPjvg8xOK5R76UXF+ulnnLkCZ6XKzCBMhe26a3pvVJJZx502AWdUN8N2eME06VA6SEjC3D
	nOtM/EjnsM0lWe7AUxh2ckjq2HcfO77HhXIUMmTnDKALHDjBZEgEua7A4JxIn2EgjBNoAL
	73aMbGHT12pONF+EOvlq75jwx4edCAQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C62F21CEE;
	Thu, 12 Nov 2026 16:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794499713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+T3ab9ZuDlb9AtgbzYcZLqb0pcIRcAvo/vUSdxHxz0c=;
	b=KRUt/2rKwrPs3sMDIuJyMXommGdOYM0nzrPzs7Z3iopgik2l2//gV9DFuYm5GgLMQ4POe9
	o2USyaY1VE9XW9/M5/A8VPOZA1t441CQHiZDgfKZ4TI9ZxQ8r27SR+L0NwmP16mYRWnMX+
	Vvx0bkEnvdk6oRY91rFnc+cJWho8BZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794499713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+T3ab9ZuDlb9AtgbzYcZLqb0pcIRcAvo/vUSdxHxz0c=;
	b=FSWB8QHvnGUEaCFhAnHsU04CKsBJVvy83XOZE+W934YlVKuXD+597aE4ihv+8p2f7APua7
	+ceuqTju3GmkufDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794499713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+T3ab9ZuDlb9AtgbzYcZLqb0pcIRcAvo/vUSdxHxz0c=;
	b=KRUt/2rKwrPs3sMDIuJyMXommGdOYM0nzrPzs7Z3iopgik2l2//gV9DFuYm5GgLMQ4POe9
	o2USyaY1VE9XW9/M5/A8VPOZA1t441CQHiZDgfKZ4TI9ZxQ8r27SR+L0NwmP16mYRWnMX+
	Vvx0bkEnvdk6oRY91rFnc+cJWho8BZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794499713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+T3ab9ZuDlb9AtgbzYcZLqb0pcIRcAvo/vUSdxHxz0c=;
	b=FSWB8QHvnGUEaCFhAnHsU04CKsBJVvy83XOZE+W934YlVKuXD+597aE4ihv+8p2f7APua7
	+ceuqTju3GmkufDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3101C13432;
	Thu, 12 Nov 2026 16:08:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xpkCK3rk9WrfKwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 16:08:26 +0000
Date: Thu, 12 Nov 2026 16:08:25 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 7/9] RFC: net: limit folio refcount when rearranging
 skb frags
Message-ID: <avXkTuDG89QZgvOr@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-7-318625d63a98@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-refcount_overflow_stable-v3-7-318625d63a98@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62BB8C0013
X-Stat-Signature: rnwn3zh67sbqtgxjgqo5pqhy5tzafebp
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794499714-217598
X-HE-Meta: U2FsdGVkX1/zfhwMdmqi579A9zTxNj09N3Hug2vMjw1NLRPTZpjjy+kFhFGuBD4Co41F0M7vp6AYd95WsYwgtuyC4URbRaef5c1ufEsAoMKTTZM7QeL2WgoXxEs78PklDmPnY4Ud6C8TC8aHFUHlK1MXMxNVCKN321ITY9SGrJ//XiksRgJtlLNqx1vw+BeMd11kv5eVYINWLd21979fZ5Nk0Mu67eRvC4QyHDbBkLSESaERbC9n1ChlLylocKyCJWkCNGIgsQRV9hStNkClHvq/6ig6nd84Lk3Ojs+C/bHQ13LXxek7I1WQWaGbQeEtbxi3YcDciuN0FDH57AtS1JUiJTkv6yzrEnTFAozJdZCusgw3DoSM5W400mF9kn40HqGLCj/Jc8KvWMipMz26h/Kgm2kQwWGjzJN2ZPhCAynv38MZGBzmENwpETYk60KL9wwCoqt+u73GsJCHEGMOSAg9m/C/lRsZTw5SNWbZ+wxJnFj486Thqh9KmLIki8fnGeZn+sPgLV+4gO1toBVCjVWuGdlOyUgMprn2EYjxHSTo/E53Vqf0vuISnquHoVSwuSBfmz9ISFusQPfuBZlBibtptot71bD/n1ofLdGd934hhPnzD+EaTT3POqJvLXhbATrS/h/lYxiiRsNb25snEum6lwp14btpl6ExPHGJzpTWhn1EQHVn26ZFg6SuV+rALywqLo06tB8w5dl+PrvuSbK30319oguQBdDtI5MDXBi/egHTa/KXZChxE+6b7MsB5Jg+8tE+qIwhzHOdD9/QXicLTfUTzM5SIyfXBQdceTIMIKalkw1ibkb8ritmaiMy6Yo+q6EFKWZosjJjkq7qqWgaOwxV8pb0HSgWF6lgLNRhhQptZn4xh02KyWNiqA836hOkT/b5Sitoi+BeEuhn3Qv7Ty1+u41t4ESTxKjxOnUEgEoX3rgsuKbKCdKWLwQ4fJQ5gIKAXfsQRGNqnV1
 CqSfqYuf
 H6Y5H63ijJWb+QByYloSzmZAYNLKoR3AMneO8ywjKHyHIqCHqduNbfVRFyjPH/Gh6hDsvLhtdoW4P3QYmsvNg4tv1bDVh+jwAcbwlmavjpmx3e6bYv4lvefKIc04pVQW+Wue7eTEpUZZPnO3mFxDgnWu/zrhop4a9bYbVgpEH1GekFbrZT6uN39ZC8tDHql8lW7C6YKLJ6/ByayeJPpo7AkgFdnggCN4KIJaa7k/sodhp4SmUW+6Bx+rsoybE2joXm23hxROwU1l/FOf7tlTRzNCQ9mbHJcbacf8VpbOYXcjAbopAq60yy2wo5kXIVRKSiiI8ZYSxvdnZ68ZSrC1xmaTXV3DivYEReyvicCupFbnaCNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:35:47PM +0100, David Hildenbrand (Arm) wrote:
> Various networking features take additional references to frag pages
> that are still referenced elsewhere when rearranging skb frags, for
> example software GSO segmentation, TCP receive coalescing of clones, SACK
> shifting and MTU probing. This is an effective way for multiplying folio
> references held by an skb, allowing for exceeding folio refcount limits.
> 
> This is not specific to large pagecache folios, but with them it is a
> lot easier to reach the refcount limit, as page table mappings can cheaply
> create many references.
> 
> Let's use skb_frag_try_ref() and skb_frags_try_ref() in skb_segment(),
> skb_try_coalesce(), skb_shift() and tcp_clone_payload(). All of these can
> already fail, and their callers handle that.
> 
> skb_split() can still add one reference when splitting a frag. But each
> split also allocates a new skb that is charged to the socket, reaching
> the refcount limit that way would require a lot of socket memory, and the
> references go away once the data was acked, so it's not that relevant in
> practice. Making skb_split() fail is more involved, so let's leave it alone
> for now.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

