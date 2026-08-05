Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70C76C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F376B0088; Wed,  5 Aug 2026 12:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F14C6B0092; Wed,  5 Aug 2026 12:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9166B0093; Wed,  5 Aug 2026 12:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C916A6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:10:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D271C0512
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:10:18 +0000 (UTC)
X-FDA: 85067702916.29.FF495DC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id BEB6B1C000E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:10:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h5XQ1L1X;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="EWe59/xI";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Xli57Era;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5tcAQy0S;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785946216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=mtHffLmyeTb81lOirI4olL8pWh/ZhmY0mPnBCynY5ArY9vbnX5+O0RCZYNYi/aUMzSJQoj
	oVFRl/g0OAA0pjcg2RrQYJ1jNdkBPHBZrUPwAoPi+3VObmRE4NYI1s7X+T8LjEbPzjh+gV
	smeue75gQMl2dQ+G639vXCBxJ0RnnAk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h5XQ1L1X;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="EWe59/xI";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Xli57Era;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5tcAQy0S;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785946216;
	b=1S5MSiyJSEz8Fqg8EjaBQvbI65wT61RTodx80pmwZMOU9nc7fZOnqKWpECNJsKDCNP51IS
	Rlo1ndi05rjxlCA7G/KRFpZcYhlSMibmFcIztCaDUbeYXLmVfYE0guQHlIK61AYr5rCaJ+
	WcqaqSoH5U5DZdLQT3g1g9ZcoxKJ2qI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC89B7EFC3;
	Wed,  5 Aug 2026 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785946209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=h5XQ1L1XESwBu4lX1BLS0KL8+Qjut/rS9S5KsnvS0BH/pXQUfsfurL8d0Qss8ajH+XLU1P
	3vYz46qTE2pBShledGfdEuNK/ec4MRZJR7Rfa6xD8OayfWt3I28RL/mpk7hnNcD3hBmj/C
	rW+kd2jjx46LtCYmqR8l+cMAX9ZwyvM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785946209;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=EWe59/xIDiP5vTKrNSNXwLfnMgku2cQdCaXx4qm5Nik5EYSY4GCdLqiTDtBX+4+8ddrWOm
	Agh+0USaxFyE3nAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785946205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=Xli57Erab/Nk3CLdJjFnHdG6ttlcEODmtSCxIx/RTtO2VnPgP4fDCbbUdQom+mgzPtmYwm
	VT5eZGsdFQG7Ak4wKU5OceaAW3HgN+ScTaksqBILvtaab8GtVHGeYxjE8MN19dXw0Kuxbx
	3GKIitNOX7OOBuYbwc1F8JRCmUoRRYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785946205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HskJbUE1aNqCuNXRMEy5hyx9jsFoyh9wIHexTfa7E5w=;
	b=5tcAQy0S/zzzaTqeZqq3rXnGjW2LHS4wwXQqWwHF6UQE5kfSV+RNg3zOCC2O6Ov0qvLYc9
	lfuT2s/I/hb2bYBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C44B779C2;
	Wed,  5 Aug 2026 16:10:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ag0eJl1gc2pxUQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 16:10:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4534BA13B1; Wed, 05 Aug 2026 18:10:05 +0200 (CEST)
Date: Wed, 5 Aug 2026 18:10:05 +0200
From: Jan Kara <jack@suse.cz>
To: Zi Yan <ziy@nvidia.com>
Cc: Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Message-ID: <44w5y7ehefqmo4jkvxjm7abfm7bmqh2p2uucfu2cqnizmgzvmx@lk3xamijvglg>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
 <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
 <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
 <ivg5x7hjo4tmpd34i6wrd5cp2v56c3vorwru7h6kqxnqlcpte7@lvd7xa4ncwxu>
 <DKGZEK0AQP6R.1RTQEY44OQD65@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKGZEK0AQP6R.1RTQEY44OQD65@nvidia.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BEB6B1C000E
X-Stat-Signature: 8dr3eym9qe9jkdfgeb1ob5g8enz87zuy
X-Rspam-User: 
X-HE-Tag: 1785946215-269840
X-HE-Meta: U2FsdGVkX18VcwvIf4MFx00cOz7KZtaLjipiuQn7nG560jr/qJ4w0V69qEHlD+gAh88OvUO01NJkiu4ZTu+KYQRZnORejXsguCyTrCFFEDJXUWLyHWOgH9i8Xz9zNP7qB6sxPKkQ2DnD70gJQTlKOuOQiQcbxgPlYzAi8yxQP8q+OBkMte39KLtzNCkPYcoSx0U1S7PcCA+qqozaWF0NWAI+FdXvbp4LBE7JAxIfpCxXB0Hm4z5y5XzBy6Lkztv7EvjBBMWWbmVVa6cGjlePz+wVuJHkBBEW1VcMSDS6vn3f5NWvxaKMDz+RO1gAlzhZFnDAJk7q1kpqkQuqS9jV44U46vSFmPeoLk7aAHPQeexsS6dYO0AA/tmC7FJH/OxnQYH8D3tj7rkA3gTYCN7czqYlVagXDAz860UTI3EJuc6qTM8rpz3nRZNR4a6j56ir2LnH0InEwCTdmkQ7VKZ74TxBlYwfTIbU6B0WteDfopRNAwbm3jddUkltiUhH6P100Oy2JthbC2FxO5PSIQZiy++B0ZmoT7ZOZ9TH5KB1CONW7g8v9iNjI8ISb8reaw/zZRgfbl/tZtSoWtxlCXKGkA7f5h22nZdW3WL7WSqyy2dfr+6CZvVtLqTnuhrnReMYHFCF23WQJ/bIKQFQMnHXU+O5pMHF9sJruiYj2ugijnnzV7VUFbLL6zMVjXNK6+VU7VNw1abWsdCHLFIEkPC6K5Eaz29uujyLQjFYOa0kUOmzWPZlV4/MLh0Fj9FE2k4JuoUimMKpxABAbfiDLSwizQMgDL7cIgy0EJujstu8QGd21eNXEYNKVW4jLW9c7FEVj8igtlQLuPQNdn8iYvQh8/KnhFw3rbuq8ZEbYcR0yVhEwP4gL+CNJoEECbFZ5QoQQCfqNrZ63usYHE/y/j/pvjP1JuqeQE4HA7YTN7FPsxUHGPfZxRDNH7jKxosVz9ndd9VT3q3fMzTi/3PNUGy
 xaTJefRU
 Wg2bmkwaVIr7FRymy2OI4C5PKiuEmuCVzhSFDGhSn1Q1qHSz85pBMTzl1FmvVyUl43bZWke93XdwxcZk78v8maoG+ImRCFBOaT7VECPqxVWD6A/Wpm0qmXj+2b5O8cY30z5Tq+j36OYND9Up1cRzN+E3Fn2wtgzW7iLrsz70L3dR8bsHl23qykEdRrZwb1O1ezXzU4fMh8wUa/IxZKZWoyec0gmeQaBeakcPa46Mnu8wHFjCbLe3B+RGJmo8WQ8Q4wiClmda4WFFmEbEqiMfBMr1vl2tjdB4K6ZG2Fsyxe7sIGPjYiJWFb/sGJ5z3Jo8chxy4QJHJeCF3EI4Wc0Vo5Hpaoc1kYOv5yOfpTKMviwzI9m0JouDhxDxbdrxvUSu/3n3GJWKmo8rGLgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 05-08-26 07:42:37, Zi Yan wrote:
> On Wed Aug 5, 2026 at 5:25 AM EDT, Jan Kara wrote:
> > On Tue 04-08-26 13:09:46, Zi Yan wrote:
> >> On Tue Aug 4, 2026 at 1:04 PM EDT, Jan Kara wrote:
> >> > On Tue 04-08-26 11:54:41, Zi Yan wrote:
> >> >> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
> >> >> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
> >> >> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
> >> >> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
> >> >> >> >> erofs needs to traverse readahead folios in reverse order to achieve
> >> >> >> >> maximum performance by
> >> >> >> >> 1. reading all folios from readahead_folio();
> >> >> >> >> 2. storing the prior folio pointer in folio->private;
> >> >> >> >> 3. traverse from the last folio to the first one.
> >> >> >> >> 
> >> >> >> >> Add readahead_folio_reverse() to achieve the same function without using
> >> >> >> >> folio->private.
> >> >> >> >> 
> >> >> >> >> It prepares for a future commit that replaces PG_private checks with
> >> >> >> >> !folio->private checks. After switching the checks, erofs's use of
> >> >> >> >> folio->private without bumping folio refcount can cause unexpected
> >> >> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> >> >> >> >> reachable.
> >> >> 
> >> >> <snip>
> >> >> 
> >> >> >> 
> >> >> >> The below is what I come up with. I did not add a bool to
> >> >> >> readahead_control, since I think that is the decision of caller of
> >> >> >> __readahead_advance(). But let me know if you disagree.
> >> >> >
> >> >> > The reason why I wanted bool in readahead_control is that if some code
> >> >> > ends up mixing readahead_folio() with readahead_folio_last() things will
> >> >> > get confused (because __readahead_advance() really wants to skip the batch
> >> >> > returned from the *previous* call to readahead_folio[_last]()). With the
> >> >> > bool in rac, even mixed use will properly advance the state of the
> >> >> > readahead_control. I don't think mixed use is very realistic (at this
> >> >> > point at least) so I'm ok with leaving that for later if you don't like it.
> >> >> 
> >> >> Got it. I am trying to figure out your mental model of how the mix of
> >> >> readahead_folio() and readahead_folio_last() works with the bool inside
> >> >> ractl. By looking at readahead_folio_last() code, it is almost the same
> >> >> as readahead_folio() with __readahead_folio() inlined
> >> >> (__readahead_folio() is only used by readahead_folio(), so the inline
> >> >> can happen without any issue). As a result, we can get rid of
> >> >> readahead_folio_last(), add set_readahead_direction() to set the
> >> >> embedded bool read_from_head, and use readahead_folio() only. This
> >> >> removes redundant code in readahead_folio_last(). One thing I am not
> >> >> certain is whether we want to
> >> >> 
> >> >> 1. use set_readahead_direction() explicit and warn readahead_folio() if
> >> >> read_from_head is not initialized, or
> >> >> 
> >> >> 2. set read_from_head to true by default, so that only erofs needs to
> >> >> call set_readahead_direction() to change read_from_head.
> >> >> 
> >> >> The former is less confusing but changes how readahead_folio() works;
> >> >> the latter is simpler but implicit read_from_head state might confuse
> >> >> people at some point.
> >> >
> >> > My idea was: readahead_folio() will call __readahead_advance() and then set
> >> > rac->forward = true. readahead_folio_last() will call __readahead_advance()
> >> > and set rac->forward = false. __readahead_advance() advances from beginning
> >> > / end based on rac->_forward value.
> >> 
> >> Got it. I can do that. Just to be clear, it should be that
> >> readahead_folio() first sets rac->forward = true, then calls
> >> __readahead_advance(), since __readahead_advance() advances based on
> >> rac->forward, right? readahead_folio_last() as well.
> >
> > No. I wrote "and then set" which means after and that is what I really
> > wanted to say. You still don't seem to be understanding the logic of handling
> > the _batch_count. _batch_count is the length of the returned batch.
> > __readahead_advance() updates _index and _nr_pages to remove the folios
> > returned in the last batch from the range. So _forward needs to contain
> > whether the last returned batch was taken from the beginning or the end of
> > the range and __readahead_advance() uses it to update current range
> > accordingly (before we go and return the next batch). We cannot clobber
> > _forward before calling __readahead_advance(). I hope things are clearer
> > now.
> 
> Got it. Sorry I made some assumption instead of asking my question, so I
> misinterpret your words. My question is who sets the initial value of
> _forward? So that __readahead_advance() can update _index and _nr_pages
> correctly at the first time __readahead_folio() is called?

This first time __readahead_folio() is called _batch_count is 0 so the
value of _forward doesn't really matter... But DEFINE_READAHEAD() will
implicitly initialize it to 'false' which is fine.

> __readahead_folio() does:
> 
> 1. update _nr_pages and _index,
> 2. return NULL if _nr_pages is 0 and set _batch_count to 0,
> 3. return folio using xa_load and set _batch_count to folio_nr_pages().
> 
> after the change:
> 
> 1. call __readahead_advance() to update _index, _nr_pages, and
> _batch_count based on _forward,
> 2. update _forward to true, since it is __readahead_folio()
> 3. return NULL or folio based on _nr_pages.
> 
> Then the first time __readahead_folio() is called, who sets _forward to
> make 1 work correctly?

See above...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

