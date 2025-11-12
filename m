Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D455ECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 09:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200EB8E0010; Wed, 12 Nov 2025 04:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8828E0002; Wed, 12 Nov 2025 04:13:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7248E0010; Wed, 12 Nov 2025 04:13:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8A5C8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:13:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87EB14C8FB
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:13:40 +0000 (UTC)
X-FDA: 84101392200.19.2CE907C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A7114000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:13:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xTn4hJmo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=h4g1xlLI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xTn4hJmo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=h4g1xlLI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762938818; a=rsa-sha256;
	cv=none;
	b=g1snz4k/TU9aReHqvKYjqskep67LLKCfSayEXb6NHaWcfbE1kWt7MuyuaktU4t/Xc29jKJ
	8jRYGm8HhzvCQ7InukVjoToTErLtRhFIivbpc+os3p99fB0aHyTY7l7rXQlhjNr+uyB74p
	zOTbquix2IqAPLJs8JaoguK3IGI3Hoc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xTn4hJmo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=h4g1xlLI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xTn4hJmo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=h4g1xlLI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762938818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOkexIAv3v1duPJ1ViOi5rMNa1miLiwCtXPhdmXLxp0=;
	b=pY5KxtigiqQnHGWFzJbWSMemdrc2f3iCsbrjTp1r/wGGmscCS9Gp5wlDTHMQfNuuyQS6z4
	xCNaeuASJgY2NuTyoa25tn1MuuDVL74Dc5zdY+7A6OfDw4PtWsR+FvYkEgXcZeJDWgjIVF
	Hhvuyg2Su71c0tom5JqNKUbtyKnPhSM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DB7A1F45E;
	Wed, 12 Nov 2025 09:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762938816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lOkexIAv3v1duPJ1ViOi5rMNa1miLiwCtXPhdmXLxp0=;
	b=xTn4hJmoP9BdmIdEZZL+ENruH10vR6IjNXoBgVIDacRFj0dj9+C8I+wpFgqvnhh9wrEQVF
	ZP49g6jiBAZDvAcZqw9j1LyhpW7do6s6zpgFmmvWUeeN7vL8N55WbgCJtSw4cir1JX9p+8
	7pAB5Xuyz+ZMEMCorsjRX954lI5LmU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762938816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lOkexIAv3v1duPJ1ViOi5rMNa1miLiwCtXPhdmXLxp0=;
	b=h4g1xlLIKRO8zI6qtfxagw+bHr+RCvDq3wwpTdTCPXXC4sq84KVWoWCwmxmLn98Pkns8Mi
	8IGK4AexbxaINtDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762938816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lOkexIAv3v1duPJ1ViOi5rMNa1miLiwCtXPhdmXLxp0=;
	b=xTn4hJmoP9BdmIdEZZL+ENruH10vR6IjNXoBgVIDacRFj0dj9+C8I+wpFgqvnhh9wrEQVF
	ZP49g6jiBAZDvAcZqw9j1LyhpW7do6s6zpgFmmvWUeeN7vL8N55WbgCJtSw4cir1JX9p+8
	7pAB5Xuyz+ZMEMCorsjRX954lI5LmU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762938816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lOkexIAv3v1duPJ1ViOi5rMNa1miLiwCtXPhdmXLxp0=;
	b=h4g1xlLIKRO8zI6qtfxagw+bHr+RCvDq3wwpTdTCPXXC4sq84KVWoWCwmxmLn98Pkns8Mi
	8IGK4AexbxaINtDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A12E23EA61;
	Wed, 12 Nov 2025 09:13:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5gSIJL9PFGk2cAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 12 Nov 2025 09:13:35 +0000
Date: Wed, 12 Nov 2025 10:13:34 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
Message-ID: <aRRPvn4DYAhuGtq3@localhost.localdomain>
References: <20251112031631.2315651-1-kartikey406@gmail.com>
 <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A7114000B
X-Stat-Signature: qdx7jkpjj7gpid5ixd4y6oswnfhgmqt4
X-HE-Tag: 1762938817-938214
X-HE-Meta: U2FsdGVkX1/T/8MCaZ+IbZxSQiagIBoETCWGOhHCndpRCp5OsndwyL/MfZfk1OnfFQ5RB5Xi23o1RB1lnZ8d0qB260eqVOGMxrKZ6GRj/wpbUbO/k5QXyDRbYnKH9+tRKoi4Bux8mz7x5acb4wyrh21/jsT9FuEVqXlGzh+OKtflRLWQv3NUG7I7PVRkJas1wZeV26SMYX31AshXGBZpjIbvB8SUDS8F/PWgq6soxqDQcFO8AqIvogPoK8FnwhVzbOKHclVl+lgGuEqKX5/tsdT1Gcd0Sd0b/I9pFLi4YbFlc4emybDK3hQFdZnOcwcC48fsM268FXHLz32w7CuCJS9zYlkulajfGITzQA3UL7s9gP++7nySyliHu6kR3YaPWwWJelzctg6Ogx2SmfU3tvXBeDmkrxjSX9GqbcHw+WuxRPgQ95fCIsBCapoRqkIRUK8SOfB77usF8ezYRjf23GeFuw+O2mWuwDaFEZRmufWkYEVBhBE5Imw1LPIpGy2fJ+KvfLC/OOUS2/p9QHLSHBksYCRq1NalvQGwXfT00vha+wEDTCj6A5YDsqANp8BkBEY6WK1448QIXAqmVjnL4HYrKatNtxxM2Ve6NDpqSQYVSKQVddfsDNuQZXzlOWowSPhJt4HCn8zZf4p+etKq/HAW7WJ4td3JSTW9NIgb0RmxWYhlpk4f6GK5ankQV7oGMVbwzORLvaL4QfEClIcwJRzAqw6PPO1gaDGKlnDISAq4CZcPiupiae/Or0YILS87bNEc15ZoNRtqk/aG9CiFAReF8lSDWP0Ldgnl2ABUMBAxeYpqKTqOs7xfdFVw2Zd9Me3xS1GhDzIeYqIpGEWh89pPm/luAF1tgzyAVYjvcQn8AB+xjVcu4EzUmuIcg6x87NJIGPwuI7PRUJH8Rc788Ie11K5GuJIuj614GmxlBaa7P9Mie7iDRlg0uSE/ew/hySUt0lVDnMkHkbM2Pme
 eh6+efEv
 QiBYKw0s+5F4wkrpzwyMdD2RFEAfkhC6B26/QEnyTfK55Yb6lukDSr0NNpcOGvL85eElWmLjzVomCr4e30QJdsxsbHt892t6FjmQtpbKXa3jdMoHM4WselfETO+KiQKHzUnvUdaENxclLgQzEKc5y8EkJFLZPIwrcQYiO9Lsvla7LIbnazM3qR0irbL4azVW62z0/uDnCekDyDoMndLKqkXvKLYU1AAwynkimAQ0jBl2ckTWkHyghsqpNJyJFKWZlwOUlC+PAmSEORPqhbIdkwIbBv0V8KTT6Kvoge/qGkSfoxFGsgdlU6wWd8Jju7bmWHyRAIj5zRl5+Lwmz1lm9MrvwtJPVqAGSxlgEtDQgUepQ8G0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 10:55:03PM -0800, Hugh Dickins wrote:
> Thanks a lot, Deepanshu and syzbot: this sounds horrid, and important
> to fix very soon; and wlll need a Fixes tag (with stable Cc'ed when
> the fix goes into mm.git), I presume it's
> 
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> 
> But although my name appears against mm/memfd.c, the truth is I know
> little of hugetlb (maintainers now addressed), and when its folios
> are supposed to get zeroed (would a __GFP_ZERO somewhere be better?).
> 
> I was puzzled by how udmabuf came into the picture, since hugetlbfs
> has always supported the read (not write) system call: but see now
> that there is this surprising backdoor into the hugetlb subsystem,
> via memfd and GUP pinning.
> 
> And where does that folio get marked uptodate, or is "uptodate"
> irrelevant on hugetlbfs?  Are the right locks taken, or could
> there be races when adding to hugetlbfs cache in this way?

Thanks Hugh for raising this up.

memfd_alloc_folio() seems to try to recreate what hugetlb_no_page()
would do (slightly different though).

The thing is that as far as I know, we should grab hugetlb mutex before
trying to add a new page in the pagecache, per comment in
hugetlb_fault():

 "
   /*
    * Serialize hugepage allocation and instantiation, so that we don't
    * get spurious allocation failures if two CPUs race to instantiate
    * the same page in the page cache.
    */
 "

and at least that is what all callers of hugetlb_add_to_page_cache() do
at this moment, all except memfd_alloc_folio(), so I guess this one
needs fixing.

Regarding the uptodate question, I do not see what is special about this situation
that we would not need it.
We seem to be marking the folio uptodate every time we do allocate a folio __and__
before adding it into the pagecache (which is expected, right?).

Now, for the GFP_ZERO question.
This one is nasty.
hugetlb_reserve_pages() will allocate surplus folios without zeroing, but those
will be zeroed in the faulting path before mapping them into userspace pagetables
(see folio_zero_user() in hugetlb_no_page()).
So unless I am missing something we need to zero them in this case as well.


-- 
Oscar Salvador
SUSE Labs

