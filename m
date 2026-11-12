Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E008606A8AA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1XqhTbRt;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=W8xNeInm;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=qJ/9tp20;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HJbtW+mO
Received: by kanga.kvack.org (Postfix)
	id 87E9E6B05B1; Thu, 12 Nov 2026 11:05:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F206B05B2; Thu, 12 Nov 2026 11:05:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF256B05B3; Thu, 12 Nov 2026 11:05:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4339F6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:05:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2BE6C0640
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:05:56 +0000 (UTC)
X-FDA: 85426943112.03.75F9B54
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 604CC40015
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:05:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1XqhTbRt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=W8xNeInm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="qJ/9tp20";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HJbtW+mO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794499554;
	b=V1yt9k1gRfAfQGZXxn79TIrdQnoARVztGUPb8hBj49+RV3eU0IPkgZIk/Qb9O0QPQoYZr/
	qkC+T8l8huilosUkXLqA269ZCOOm2D+8IPW5rJW1BYQ9N1ZnBQ99nJsbvbr01+qGu1oqxw
	Nh5srzr8/oSTU0cc6/MRK1LUYdfbD9M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794499554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YufnmZVNechLqcaL+12tnkQkHsQyEMDzCGtNkLwTnI0=;
	b=UuX3MCJNWZhBxkenWUPsdL+BLVD/yyVR4jQG/YRxQWTg4Cie/+hpcDVJEirur9vqC95keV
	7B78a6EewLUlxAx0Zlw1isd1KjBpTkqQw6CtZu9SOf13DAxrZgGDfqqZARDSSEgPk8WA60
	Z3gF2xrVBTMoQjVs9qzfy3tjnE1gXqQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1XqhTbRt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=W8xNeInm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="qJ/9tp20";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HJbtW+mO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 93E3521CEE;
	Thu, 12 Nov 2026 16:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794499552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YufnmZVNechLqcaL+12tnkQkHsQyEMDzCGtNkLwTnI0=;
	b=1XqhTbRtR2Ti2wMF/rvG2bh0JIBFEix+aS565q+brCOymeXkbIxqBQq2r6wsuvjiaO4+2w
	7vfPm9DxdSKjxbS+lm1t4CLNcFuy/aDguieyK4iugLfLvVw7S9L1Jct/nMqrJprcCEIpD/
	nkrRSyW3+pMrvBILTWn/2P65EZiNyIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794499552;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YufnmZVNechLqcaL+12tnkQkHsQyEMDzCGtNkLwTnI0=;
	b=W8xNeInmb51XAqwMI01ZB6ZyLVoJIpxMF250ZX/5Jv8Zkh6KoO3jw58ZSy97gjEKKrw5ff
	TY0JojlmtcRCm4Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794499551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YufnmZVNechLqcaL+12tnkQkHsQyEMDzCGtNkLwTnI0=;
	b=qJ/9tp20/z5EPRCwjV3Ju3oZQSF63/UXEfbK0qWbglccebVbRVJ17Cow0WhCqK2fPx4oDA
	1WXHs3iY8Axd+KkJKQ2VhoFG7bhXpndOn67Jt9IA4ZnjiV/fNLyjHE0RFjIFUqn7pPmRTu
	uOkBoRbKv1DY3FYxsRkePWbviVKDar4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794499551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YufnmZVNechLqcaL+12tnkQkHsQyEMDzCGtNkLwTnI0=;
	b=HJbtW+mODGRUVoEOZT6vq0WsF+o5SBwK9SwP09053w/gNrYQYHXjf1sVhXTvZ+CP7MMNSX
	9U0u9mDp3bfE52Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E26C13432;
	Thu, 12 Nov 2026 16:05:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bcdNCNrj9WqGKQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 16:05:46 +0000
Date: Thu, 12 Nov 2026 16:05:40 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>
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
Subject: Re: [PATCH v3 6/9] RFC: net: limit folio refcount when copying skb
 frag references
Message-ID: <avXi-z1MEb9S93Ii@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-6-318625d63a98@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-refcount_overflow_stable-v3-6-318625d63a98@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 604CC40015
X-Rspamd-Server: rspam12
X-Stat-Signature: wczmq9ud8fgtp3f6hph7iutbbt3ah6bh
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794499554-843145
X-HE-Meta: U2FsdGVkX18gxu8c0OQ5k18wzgQfxXpiriX6o+eLaS9CT8cqap8fCfdRLSwGZwVdbr9e5H6qKJN+8O8IDQsQt1I99vgg+MK8MkZ3O2RtIMeO2KXeYlr/OcsexUy4Th9gMSsxMLE97V001AGf+Wj1gvuJ4rBYeX9PfFCQP/fIQzBjRNKEm7IfMIxYzzn3pINNsYwFVD8TyIzcyDwjFZ1JMUP8GK9bOoXvzANX9vWGhJAsAIqLsUXR5Y1jNcjf9lVCnEe4o0FoKTPmG+3jDQda3j+UoasCT4yM5nA7yJxSeX+/BicSm2pQ00pMjIk1iWQrC3VeetA0nQhpd2/LuRKRnlO3wcqvOsPI/ad8WUqci22krALlolaXgjGAjy31VtD/mAWZ7jLF9ZOyJ0ALoyhpDryHAonjgKMDaXJbKW0tHS3I0Zvleo+jAI8Cn8ERhsJndIEUpEcUYA4lkEO0Er20AoVN6gr0jXwJVFk6RwnbwNBxgJJkUhQTaIXPIi1HVhEMuiPszJEGr634oe46+2y0pD4KkOLJVb6kjblbf56+F961+P3ZFFOctKRACwk0h1SUU2f66w9lPBBIHJsnKc7eQUtGQoY9Kl9YBEoVldisPI069nDIcdqtrWkGaoQ3PUAMr0kAN3FPZhMLlhiDDOace4LPYKGvLURFuJ++rsJUDpgKuoJXyOFNBKhO9aFMVo538UiKBSjEEb8aiTbDgdXF34g8JkOwXmPRCAZEvHFbhZeFpGId+EO2+7LRg/0tIq12Wm9gocxnxhn3aJWPwcihAxfW47CTZhy242m357qOQ9r7fH8LtghpwVePZ///VJ2RHwFXcyoPWy4gy76xMWSxXWrIYzQsvKE9luRrZbYAAJjUSWW9w/zKrrgxrn8rblCgzXr1QfFlFtZ/kKOo1n86t/Nx8YsJrfdPgDLQLyL/NioJxtTCWFSVDlSPwQYR57FdjzFpiyQz1bHftbrJMiy
 ExvLM4dV
 V3QG95HvARTfnBnD610FSCvTniVg4Pl5SirJ6w2X/bOLKLz0pZTGCAsI4+mzC+xaEWmlU9NEJrMgtjqOuLkCenRzysQ+7KYGKkkXTxuN6LCh4fMBqlzNGwV9ox3vQcEN6xnUTe1RuStcYWujIcg08Y7L1MaRBZwLMjHd4sEg1c3r036wKiXAWoYLt/aZ0ul8ugsHdMMibGaGWCRBItZwPz6vH4vPIHIG3o7ECUjwj4z633ytMgzdVPmt7RWMLOoaOnbtHTD+TYJR5dcT6Qvib4Kveqg0cptxOMJ3iGOcuh4MKqqcYF65zhatqVKr3MrQAee4CDQwDjYrpiPIU4xTo/w/kSrLfRNsQk3CtZ/06bFAbMGZt96UIRK0F18gwPioXjfw6ayxo/cTqvH6Yox1ZcMar8bKUehGwiJGulxzj6LGqU61wSF380lsbnNwv9PEOe1H+ieQSkj6lX1Y68Zygc+YiQLCdoPVXWV4ZqdIao/M/D0tW10Wlx+8a3RbWT7RI/Oqw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:35:46PM +0100, David Hildenbrand (Arm) wrote:
> Various networking features copy frag references of an skb, for example
> when unsharing a cloned skb (AF_PACKET trimming a clone), when copying an
> skb (nft dup) or when building NFQUEUE messages. This is an effective
> way for multiplying folio references held by an skb, allowing for
> exceeding folio refcount limits.
> 
> This is not specific to large pagecache folios, but with them it is a
> lot easier to reach the refcount limit, as page table mappings can cheaply
> create many references.
> 
> Let's introduce skb_frag_try_ref() and skb_frags_try_ref(), which use
> try_get_page(), and use them in pskb_expand_head(), __pskb_copy_fclone(),
> skb_zerocopy() and pskb_carve_inside_*(). All of these can already fail,
> and their callers handle that.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de>

For what it's worth, I tried thinking up a way to avoid all of this stuff.
I know there are severe recursion limits that (should) avoid a large copy
chain, but the issue is that, say you have a copy chain limit of 8, you can
still create 2^31/8 skbs (each with their own reference), then clone each 8
times such that you get an overflow. Annoying.

-- 
Pedro

