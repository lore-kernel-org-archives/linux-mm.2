Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1DF60703AA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kYW8zoDp;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tjn0V528;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kYW8zoDp;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tjn0V528
Received: by kanga.kvack.org (Postfix)
	id 3CD906B05C5; Thu, 12 Nov 2026 09:26:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5096B05C6; Thu, 12 Nov 2026 09:26:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293676B05C7; Thu, 12 Nov 2026 09:26:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC5036B05C5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:26:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88F15A05E8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:26:32 +0000 (UTC)
X-FDA: 85426692624.20.C81D26B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 564541C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:26:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kYW8zoDp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tjn0V528;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kYW8zoDp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tjn0V528;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493590;
	b=fFkf/VAoeBaHKGPqc6/ee18VXe19T2qgSeo6zeTm439Y8FOBinWsaRtmB2OaCe0vFjnxbW
	twVqH+7/rZRfYaBP7I4upCH9iClRdMA99Xez5gc5+CWGMqc29aESA+cfoTBVTGNu+hLQb3
	doZxYkFHUfBY8mYEpcDvR8QyrkSiakA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kYW8zoDp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tjn0V528;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kYW8zoDp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tjn0V528;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHr4RUKl7RY4PSbdL2GT5NxxihQwmpjqwvgP01/M+Ac=;
	b=TIRlly6Z/NH8R7wGpAsjL1AncM3pWTjuA8uUOOlB0lvh1Vy11QJwgYY4sVqmr/j8/q3elF
	8i+2szKWURt8HdLG8Km59QSISXDnzw3W6/D5L0ZBW38wgmaCwl5whcgKCJ/NBvr3t9NOfD
	/MtTwVc/IRFnajAk6hxEfzKsGfbnyVM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2DCCE21C53;
	Thu, 12 Nov 2026 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jHr4RUKl7RY4PSbdL2GT5NxxihQwmpjqwvgP01/M+Ac=;
	b=kYW8zoDpxMShaXbNnc9eapJegGiIybzvqwjxCqnm+R2TdEAh36ASZwVv4xO/eJIdXj+9cM
	9D4IrfT0kvDW90Cves9fCI1ZQjOgverbkC1h8JjL9l8PFxNUq73b7D91YAkzOkysn1ZGw2
	CWXeWI690YBd0qRlSnh9jtU+06mmwdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jHr4RUKl7RY4PSbdL2GT5NxxihQwmpjqwvgP01/M+Ac=;
	b=tjn0V528px+d3pLuk5LH3w+4rInyUgou34GTzbKL3K6IA6KH4ammsRhKZEOQcJQ/txfapm
	aavvgsfYqamIknCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jHr4RUKl7RY4PSbdL2GT5NxxihQwmpjqwvgP01/M+Ac=;
	b=kYW8zoDpxMShaXbNnc9eapJegGiIybzvqwjxCqnm+R2TdEAh36ASZwVv4xO/eJIdXj+9cM
	9D4IrfT0kvDW90Cves9fCI1ZQjOgverbkC1h8JjL9l8PFxNUq73b7D91YAkzOkysn1ZGw2
	CWXeWI690YBd0qRlSnh9jtU+06mmwdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jHr4RUKl7RY4PSbdL2GT5NxxihQwmpjqwvgP01/M+Ac=;
	b=tjn0V528px+d3pLuk5LH3w+4rInyUgou34GTzbKL3K6IA6KH4ammsRhKZEOQcJQ/txfapm
	aavvgsfYqamIknCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A81013432;
	Thu, 12 Nov 2026 14:26:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OIFuDpHM9WrmPwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 14:26:25 +0000
Date: Thu, 12 Nov 2026 14:26:23 +0000
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
	iommu@lists.linux.dev, netdev@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/9] mm: limit pagecache folio refcount when mapping
 pages
Message-ID: <avXMKH__gwi6BwVy@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-1-318625d63a98@kernel.org>
 <avW0HGjF6wuqn12T@pedro-suse.tail5790ac.ts.net>
 <86206f64-fefa-4a13-95bc-eddf756eecc8@kernel.org>
 <avXGtysfRk3uQpNu@pedro-suse.tail5790ac.ts.net>
 <2f9b90fd-fe50-4afa-ab59-0c4a00e5e276@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f9b90fd-fe50-4afa-ab59-0c4a00e5e276@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Stat-Signature: ac7qhqodyaxxbwyybr1rdfk7d8dxkcee
X-Rspamd-Queue-Id: 564541C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794493590-259730
X-HE-Meta: U2FsdGVkX18znZj2bazO8q9qiSV1K+7zpTx9dehJbvZhrhP5kJCSXcc/8RSv9CWgh7+ILqUuOqEV448MOLNN4zDLJHlB9oqCc6wYn+MP8pjHKoDViEqvGSgwiShDbPzsYtOcYGodMR/uCWDWLsIKaH/M8pTQD2S6sRzbCjZPtwusG/hpYreqFJzpXwUMgzhwaW9t8bZTKQ240FhAGp61ZGuiU3dL0MMoTjcI3QF3Oj3dSn+8wNFmFpQ7QhiipFmGDxEz7FRNJNVp2X6veyFzqRsOkdGpNr9w2LPDxKrSDBYZhGglFf1D0Bwg2yp7UGnTxX8y/Xenk7CQMUnby/h3UZ2ieB78939+BM9UrRE2tHlnIL1Y9k9bdsVcOtZk7fza5yXtRk+NsNaG7e6adPSoJSzp73XIFaQt8F+JpImetmDXIfoNNcjLoA0KHbNp0Cqn7UN49U9S8Q+/4c++0RigecmEYeJs7762zewn1COrEJz7DQw+ysldwvLQmiSaqmgx7iIXEkwXyJKtXcyf4XdMZ87VmCVbgaD3O8jlVWdg8QR8DVIeF4dCIfCvmrarHC9JiP0T8vBeoKxiITd7dql+w4Ld0VXPyfE+BSIruKoX1Wyz9OM0ZLgMM6glhmoY9RxiHoHdeYk2IKmHuOGDZqO3eOh5pSAskzJ08L4gVyFqrNTJhnMHm6cNGMsdR3Np5OuLmUQktgAzaFZe4xmsXnt8joOo2OoYKBcTEd2ArZzb8w9oEJ4WU/jfurDrQxLv4Q7qG9q4nN8vZJl37p0bGnP6I9l2Rc/VDLUp6m1/L7t9ZZfXMtg7PJo1TnTCv93BxOOdFdrkafYNNJc1VLK7RK809w75hFp8CUoYWRjs1NTtTyfZgYtQYj6JlJcWPawk6ZWIHTw7Sv2XC7IxCA+TpON38ON5A1vlD10eIQDu8Gr21sAgn2Rr+AkJYemHvpLwqNaHoJCQINipAvglU2bsD9E
 qiqI+Pcp
 C80Qn0Da5Q4IoTDpx1jjiinzzembyrXz5jwFIIkgPQ1ZqX3hyQ8xkmnrh8i5fEhZUdCGclxiAVXNt2Vy3W3b/DS5zbzvNjjaWOGATEIKlfAc4oKwgPfFqcQ+gPHXRP/BF5ShndVJZXCD56jdn/lZWEwAN/2hSw6RVS3rEL9gk1SwlliyPWPtB4uytarEnWHYe3DpGuCRMquKW+Khk47hRmFKflNqS4CfpsA8bOjZFA9rF2hfJIKPVq6Q8iq5EOd7JXqZvnjG+/T3eax8Wg43HY9+wEBgWzllr/bXJREvuK+HyuEVuX/QkXfcX7kaES9+nU1IfE1bgveUOPAfHxGzwo7l1LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 03:16:00PM +0100, David Hildenbrand (Arm) wrote:
> On 11/12/26 15:06, Pedro Falcato wrote:
> > On Thu, Nov 12, 2026 at 02:16:33PM +0100, David Hildenbrand (Arm) wrote:
> >>> Mostly LGTM, with some comments:
> >>>
> >>> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> >>
> >> Thanks for the review, Pedro!
> >>
> >>>
> >>>
> >>> I see you use this pattern often. Would it make sense to have a
> >>> bool folio_get_unless_overflow()?
> >>
> >> I commented somewhere (in v2 I think) that I played with using
> >> folio_get_checked() from #2, but didn't quite like it so I discarded it as
> >>
> >> (a) it cannot be used everywhere here, as I'd need more functions to add
> >> multiple references. next_uptodate_folio() also could use it as I would need yet
> >> another temporary helper for a try_get().
> >>
> >> (b) these changes here are going to get reverted fairly soon once I change the
> >> way how mappings are refcounted (which is, unfortunately, not suitable for
> >> stable, otherwise I wouldn't be throwing in this temporary change in the first
> >> place)
> >>
> >> So everything that is expected to stay in later patches uses the proper helper.
> > 
> > Alright.
> > 
> >>
> >> [...]
> >>
> >>>
> >>> A comment as to what's going on here with VM_MIXEDMAP would be useful. I guess
> >>> the idea is that faulting on a mixedmap later will not necessarily hand you the
> >>> exact same page fault result?
> >>
> >> I can throw in a comment, yes.
> >>
> >> [...]
> >>
> >>>
> >>> In case this function ever returns over limit, we probably want to log this
> >>> in the kernel log. If this function gets the folio you could even print
> >>> the problematic file offset/inode/filesystem/etc. Ratelimited of course.
> >>
> >> You mean, if this function returns "true", right? Is printing always fine?
> >> (e.g., irqs disabled?)
> > 
> > Yes. As far as I know, it's always fine, even under NMI. But definitely fine
> > with IRQs disabled.
> > 
> >>
> >>>
> >>>
> >>> I'm fairly sure this will break the build for a number of non-GPL drivers
> >>> when calling folio_get() with CONFIG_DEBUG_VM=y.
> >>
> >> You mean, breaking OOT drivers, right? I can switch to EXPORT_SYMBOL if that's a
> >> concern.
> > 
> > I had the impression we had some stuff in-tree that isn't marked as GPL. But a quick
> > grep shows that everything is either GPL or dual-licensed.
> > 
> > In any case, yes, this will quite possibly break debug builds for people OOT.
> > I think folio_get() might be a bit too ubiquitous to do this to.
> 
> Thinking again, folio_get() should not be affected, it rightfully only checks
> for a refcount underflow (when we exceed the limit + headroom). So only
> try_get_page() is affected, which OOT very likely doesn't use.

Aha, yes, you're right. I mixed up your folio_get() change. Would it make sense
to VM_WARN_ON() on this as well, or does the <= 0 check cover us already?
> 
> -- 
> Cheers,
> 
> David

-- 
Pedro

