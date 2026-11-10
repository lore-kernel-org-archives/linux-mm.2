Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1377606A335
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=2HGoZ5cA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2B5u+hQa;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=2HGoZ5cA;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2B5u+hQa
Received: by kanga.kvack.org (Postfix)
	id C69B16B05C5; Tue, 10 Nov 2026 13:07:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C403A6B05CC; Tue, 10 Nov 2026 13:07:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A2D6B05CD; Tue, 10 Nov 2026 13:07:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9BF6B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:07:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13C2C80A1E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:07:38 +0000 (UTC)
X-FDA: 85419992196.22.7719E5F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id D396F1C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:07:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2HGoZ5cA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2B5u+hQa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2HGoZ5cA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2B5u+hQa;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794334056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWZ8FKCXM0Bh7P8GZIU9k1z+S20lALWHtRLyiTxNjM4=;
	b=vE4drWrzO7Ekkm6A755qr1dt4PR135NLiJVdk5uyiEXn2/ScBJBgQ1IoBi4zK55dg/cEOz
	Ahv61CDT7Csb3ZtwaClJcR3DQN0k7jm3mMV/qDhHKkF/2d9BP8wcqkOGei04exR+7UH7y+
	q7ujr0BGmRVK7GR7xduzr6vEBbMHPcY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2HGoZ5cA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2B5u+hQa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2HGoZ5cA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2B5u+hQa;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794334056;
	b=JW6bwbig/GRSrSBkHicU82g01R5f02AE9z+B3+2MiYqN866Ili5oasRoH8MJ0V0oBNHPiw
	YNjkhTj3879uOMM4JuhZej5OfbXK6DKIhbpVBPe74L+45VQrhSzQajyJFBAWC+0LZyOMJ4
	xVqQxtVPl+26kF8JwCDzW3EQXGCbABg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 700491F7EE;
	Tue, 10 Nov 2026 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794334054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWZ8FKCXM0Bh7P8GZIU9k1z+S20lALWHtRLyiTxNjM4=;
	b=2HGoZ5cAOrAe3mmS4+YABocIuz5Ag6pcTC2/1Th4hUMh33IHKvRa3J94SuCWU9bYSY1LCh
	szr2TDrCQA2fIWrjvWPUdBQQW796rBnwkAmGrNTVcUDZsWyWcg/2XXHZskdiVLVJqCRmvZ
	aZf/A8v5emBl6+WtPwPC//zq4xqkaN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794334054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWZ8FKCXM0Bh7P8GZIU9k1z+S20lALWHtRLyiTxNjM4=;
	b=2B5u+hQaAWTJjUZ76c4CgyQ1LGXcYy1LrN4Yg7xxgH8i7/iJaYqGENt97WeCrCaQHjvnd1
	KpMNFutH+Rr2VaBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794334054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWZ8FKCXM0Bh7P8GZIU9k1z+S20lALWHtRLyiTxNjM4=;
	b=2HGoZ5cAOrAe3mmS4+YABocIuz5Ag6pcTC2/1Th4hUMh33IHKvRa3J94SuCWU9bYSY1LCh
	szr2TDrCQA2fIWrjvWPUdBQQW796rBnwkAmGrNTVcUDZsWyWcg/2XXHZskdiVLVJqCRmvZ
	aZf/A8v5emBl6+WtPwPC//zq4xqkaN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794334054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWZ8FKCXM0Bh7P8GZIU9k1z+S20lALWHtRLyiTxNjM4=;
	b=2B5u+hQaAWTJjUZ76c4CgyQ1LGXcYy1LrN4Yg7xxgH8i7/iJaYqGENt97WeCrCaQHjvnd1
	KpMNFutH+Rr2VaBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47E0B13479;
	Tue, 10 Nov 2026 18:07:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0sQ9BWVd82pNBgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 10 Nov 2026 18:07:33 +0000
Date: Tue, 10 Nov 2026 18:07:31 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Seunghyun An <san55@wisc.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Message-ID: <avNZtUqWhKK-7noX@pedro-suse.tail5790ac.ts.net>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
 <MN2PR06MB6639D846B30A3357B01BC61DD2722@MN2PR06MB6639.namprd06.prod.outlook.com>
 <avNVoCWBhVQea7Vq@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avNVoCWBhVQea7Vq@gremlin>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Stat-Signature: zbbhsy5e537todxh7jjo843h1b71qxfx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D396F1C0004
X-HE-Tag: 1794334055-370982
X-HE-Meta: U2FsdGVkX1+zdnorQrDLeteyDgCO9LcYrYwLhIY0OUgmC6FKqOqOFIxAbzCotGpBaHz99Ti81zhJye/2iMJVACKkmpUW8ZHrfNkmJx0KS/Ol0k4Zq7b7mf9ZRLVhIkK3IKcuZnIzUPW+m5khjetRT6OV6kffDcQ8EvgeZIWo48m7N3od1oVQrN8H4NRPBE9WZq7aU9VY3pmk3jAHrbEEYqkDARLtg5G93ahpII+m6bR6rvWZ4dwafiwAWAKJUmsyZYCTPEZhk1FZVmiGN+eNTf7UWAQsCj7U4LQaCaC9sFaurS8neoELJx2cnJn1gs/IojAWWuGXVCXBulgKvu7j2qMXNUSgnLXblQhRTqGsKzytb9DHGQXWAd47Bf3oEw3+8LHLIRfhXo5ylOWiBACH/BBlmSvth3po39Src0IorAhXWRnZgeWSZQW8ZtEstYe7ueg/BxwjAJUy/lNW89P6iUQQnwflHVI6h20wJ+/iuvQe1iMRA/TbIEK7YwODLkBg0TvAbz1V+SnrLFlcZnIwVGJa+GsB8QnhKZzJcK5jbTY4380vF0ZyzjNSAosKCR4RT+py7NV6YHyUhv0V3Xi/hT5rXoukOyk9F/ntOq2Rrjv9edGeNzGDCStPd81AI69TUzxM7kbmuyLx6bMFxGrV8As+pb4+mJRDJMhBbo7IBs5gOzzQ6/SMHsX7RlcNpzSTZPqbp5ukDDKqRWMeFyKmOmPHXCg9mLuIJpgRRjnQWAri3p/IvpcTMerCfWVUQJAlOYqVAcOn/ytV6e+3o9NzC4YvyTatp5kVwPPN+t08tMx1lF/dh7hQjesiHmWBmRU7HI8nM4mLbf78DgkdodLnApygwVBq23ScWY4bWJjc7Bk0/lPSWEDL/s1VM3+ANgOcEeFKnpD8orz24j4APsZQ12i3dn61bMR8Z6C+3OYViebZGKydN/DTnZEpJtP/vjzQaWnGmni/7+KMiFoz3HI
 Zk2QKFAl
 4SoXUpfqXUh1L1h6nJskXtv3eZWrlBb39X9EfVWrtqfeh2sFkDLTZErTa/Hi3nBWhlCr0Mq1i+Xvsx35eYbSfLl9K2ZvNQH3rrSByy7NBHjm+ME85YmBhhs/VriGlMaXA6jlc9nCfhonJ5n6ZpJolzUi/Rzk/y1b+b816hdJH7OPmwSs7QzrKg60EUZvUUEUT97r8wnF82wnfawmz+uvsRvCkyWEzlRLtoMwxN/TjdDNDq/C01+mBOoWDXHqSKhtUdgxNmMasMUkVMZgEKfcLqSeEPCtj/Jv9hwIqA2G9ubAUq08H7Zd5oJlFowWREXlqXnygABUeuFHt/mS2kIyTyHxbmhWcRgZCmQv5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 05:37:27PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 10, 2026 at 05:32:17PM +0000, Seunghyun An wrote:
> > On Tue, Nov 10, 2026 at 03:10:40PM +0000, Lorenzo Stoakes (ARM) wrote:
> > > I introduced commit 17fd82c3abe0 ("mm/vma: add and use
> > > vma_assert_stabilised()") with the intent of picking up programmatic bugs
> >
> > Tested on an AMD EPYC 9634 (84 cores, 12 CCDs), CONFIG_DEBUG_VM=n.
> > Applied on d48723711bae; base and patched were measured on the same day.
> > Throughput figures are in faults/s; JVM pretouch time is in ms.
> >
> >                               base      patched
> >   shared-VMA faults, 7 CCDs   1.776M    1.917M   +7.9%
> >   shared-VMA faults, 12 CCDs  2.303M    2.431M   +5.6%
> >   pft, 7 CCDs                 1.910M    2.126M  +11.3%
> >   pft, 84 cores               4.201M    5.028M  +19.7%
> >   JVM G1 pretouch (32G)       1877 ms   1672 ms -10.9%
> >
> > Tested-by: Seunghyun An <san55@wisc.edu>
> 
> Thanks!
> 
> >
> > As a follow-up, I also checked whether avoiding the __vm_anon_pgoff_hi
> > read in __folio_set_anon() provides any further benefit. For comparison,
> > I tested my earlier patch 1 on top, which computes the index from
> > vm_pgoff for anonymous VMAs and avoids that read:
> >
> >                               this patch  + patch 1
> >   shared-VMA faults, 12 CCDs  2.431M      2.941M   +21%
> >   pft, 12 CCDs                2.434M      3.474M   +43%
> >
> > With pft on 12 CCDs, this patch alone is essentially unchanged from
> > base (2.442M faults/s). The additional improvement with patch 1 suggests
> > that avoiding the __vm_anon_pgoff_hi read may be worth investigating on
> > CPUs with high coherency costs between L3 cache domains.
> 
> OK that suggests there are cases other than the one you mentioned that have
> an issue.
> 
> I'm disinclined to do something like that patch, as it's rather a hack.
> 
> Cna you give me the workload you're actually exercising here? Ideally
> something that's easy for me to run + analyse locally.
> 
> I have a zen 5 with 8 CCDs so can probably exercise some stuff over here.

FWIW, some thoughts:

I don't think this is worth worrying about. For starters, the vm_refcnt
cacheline will _always_ be a point of contention, and in extreme page
faulting cases (like the benchmarks Senghyun is running) it will be
dirtied to hell. Say you want to naively get this refcount its own cacheline.
Ok, fine. You're now wasting 56 bytes of a VMA just for padding. Can we fit
more stuff in there? Ehh, kind of, but not really. In theory, perhaps struct
{} shared or the anon_vma_chain that can sometimes change. But those aren't
written to often anyway (certainly not the AVC).

On the other hand, can we get rid of this contention completely? Probably!
But also maybe not. You could try and replace the vm_refcnt with a percpu
counter. That could work, but the percpu allocator does not scale. That would
need to be addressed first.

Theoretically, were per-vma locking structured differently, you could try and
resolve page faults fully under RCU, without needing to write anywhere. It's
a nice thought, but atm is super unfeasible.

Finally, since this is a microbenchmark, I'm not sure this is worth thinking
about. Do we have (many? any?) cases where real world benchmarks hammer
page faults hard (especially on one single VMA) enough where you can see
cacheline contention? I would wager that's not very common.

-- 
Pedro

