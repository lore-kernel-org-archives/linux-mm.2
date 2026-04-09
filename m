Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D702CE9DE59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D87B6B0092; Thu,  9 Apr 2026 03:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488726B0093; Thu,  9 Apr 2026 03:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3789B6B0095; Thu,  9 Apr 2026 03:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1386B0092
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:21:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AE3B160408
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:21:45 +0000 (UTC)
X-FDA: 84638172570.08.FDD2DDD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B40D1C0003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:21:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MwgQvcvk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OqpuF0Yw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MwgQvcvk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OqpuF0Yw;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775719303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESt4c0B8oOSEtkd+8LJXFtuu42Yc6K56200il9oR8Ts=;
	b=1G75oyVV9B8GQZFV7AApe+oxLLIOczNEh0yf/Sd4iBwIy4BSV9oCXqxTVihdxkdzCDaItl
	WH0BOzAdmUYVVpDSKzNeQnycVq/ysJ3l6f2FCfWMSZdqdmP094VTTjRaUJrmagHxGZOc3B
	NnKdCJms3VM3wYUew689I259VCMrQ3s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MwgQvcvk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OqpuF0Yw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MwgQvcvk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OqpuF0Yw;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775719303; a=rsa-sha256;
	cv=none;
	b=YRkbbLbv5b+5RpX1EyNKMiYL4bmHQ4SzpoL9tmcsgNnB6vsPG+M81FV2B2+OO6y16o+6Fq
	+bZqO6V6pXu5CKgK3Bgvmi+AAEjK0ZNZjm0NfXTRAYn+ihQSYCOWa8rV1PfX72CKALTV3s
	G19wxK6cQY8lIn8MDFg7WE4n1tGCXuo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F54B4EDF5;
	Thu,  9 Apr 2026 07:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775719301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ESt4c0B8oOSEtkd+8LJXFtuu42Yc6K56200il9oR8Ts=;
	b=MwgQvcvkocHrUrSYzXzcSGpLTN9LmNoPNost69oIb3tYDmegXcIx3mCVExdKZq3IMiWiml
	oWoa5hBrQgtUqIs/jP9iB5yuo5jlpO0TpsY1RQPXlv8mESwV34XV2BxxUfvGsxVq3EnMmW
	yUSSvl4rEanxFGNgqr9ytKBNTCfP9Dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775719301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ESt4c0B8oOSEtkd+8LJXFtuu42Yc6K56200il9oR8Ts=;
	b=OqpuF0YwK4VoT8f/ASHl/EGTw57DTLAUSEpPrZm8NcxxitUZvBvhqcvHVU5vvEdPaynI1P
	hF9BuqaT/bjI5AAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775719301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ESt4c0B8oOSEtkd+8LJXFtuu42Yc6K56200il9oR8Ts=;
	b=MwgQvcvkocHrUrSYzXzcSGpLTN9LmNoPNost69oIb3tYDmegXcIx3mCVExdKZq3IMiWiml
	oWoa5hBrQgtUqIs/jP9iB5yuo5jlpO0TpsY1RQPXlv8mESwV34XV2BxxUfvGsxVq3EnMmW
	yUSSvl4rEanxFGNgqr9ytKBNTCfP9Dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775719301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ESt4c0B8oOSEtkd+8LJXFtuu42Yc6K56200il9oR8Ts=;
	b=OqpuF0YwK4VoT8f/ASHl/EGTw57DTLAUSEpPrZm8NcxxitUZvBvhqcvHVU5vvEdPaynI1P
	hF9BuqaT/bjI5AAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34D924A0B3;
	Thu,  9 Apr 2026 07:21:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CcHhDIVT12mbSwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Apr 2026 07:21:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E4924A0A7E; Thu,  9 Apr 2026 09:21:36 +0200 (CEST)
Date: Thu, 9 Apr 2026 09:21:36 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] mm: kick writeback flusher instead of inline
 flush for IOCB_DONTCACHE
Message-ID: <gpcc6t5unsoepakjdffsmnmd5duuvijxwdochd753ttix75h7l@nahwzi4qfdcq>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
 <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
 <adc-Q1iDWHD5yxHH@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adc-Q1iDWHD5yxHH@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B40D1C0003
X-Stat-Signature: h3xt1rszor8hs96bq5qmdx6iens355du
X-Rspamd-Server: rspam06
X-HE-Tag: 1775719302-937091
X-HE-Meta: U2FsdGVkX1993H4CZmSFeIFRfgzPYZ7hd93NSUQaGADeURN/ZIbbIf21Cz0AaZgK2JNU3j9JzEWsMJSZuICzwx0qFzx82xL/dN462oesvpLfevKxrPb9++4afj/OWjbJ/rUpsl8X6cvwRKS0kzqJpn1TCaXDh15tAWK6xF2Ruo3SSUSLYBFmiHsj2AY227guXjV0cw6LEtSbbY+H2rl9H7sL2TqWuC6SdNjoOHAt/pC1xUoZK9sO5U8FhhDp7zIWwFbyps/Kp6seO+kYa8U88Ba15g+MO1D4XKRpTmyGUagdrOrp1EThJEAmV7hEc4dN5AzbV7lcVH+/h/Lqvi00w/PVKRRkMcRchXFDmdpGO2ZhvqOVB1pNrONlVGC1hXMaSNmz+9Q6RkmeNNlheM4Le0htdUTSrWL/MY7RS8d6yfL6G/YgCWxFpcNSNEp9e6glMhLZ2Z9nK4VOb3t2HLbwh2OnnTuTXFGjauPuF9IpDhDGHIMY9PpEDGF7yxARNJqsJ8WLU5Ea8fqCKV68NrUZhIUrQOQMEAYDTEHswgJEB8hH/QO6aJr6SVa0nOthxJzLcMZsL1PMjylT0CuriLR5jBqsTI/lrpULAhxRCxKx+Di3YiRzGOj69CZzgWGQKqtDUqEfcwu+clDQVZJ50Ciybt+8RRiinEjjF4WZlcsRl8UzUC5ntsTBvG03c6w/fNFSMCRJxrkP22+kDU5p+d38HpOLwnJmLcfh9bUN+40ZKoVwuZI0t2uyutEoyVWHJCD6go3MxP81Sn6FjE9Je0gY78LZ7iGfibbxeeEZpjuZk+wxbLT+Bz4orVOPaxjrw5359f30pBDiGk9+CtWPdXznLbJjH5NUYKKbTB79TES58FNE/kMk7DR3wHOGA4Jc2dMS2l7TCdMd84CGRZbkaf6NW6Ok2RxS3q0DhnjPTOIRjeUGlucxkPABYMhoRMTM2ZvEdgU1+JURx3kGr1hYsAh
 5/ePwrV3
 fzl57BKPvnplRwTclmPoNxqnXX6rsJ+sGODVoZq7GOxfaIBQvleJD0ct0FnJ501lquY4L9iS3q/4j/omthFddGbZjgMOyUNW7jgS+sJtFBewZ7uzapmQTlHBs99U8Dtazs/cWoPgY1bYKWPFrCanlG/6wxMK2VPxwgbeSy1+mUyqC5wf5/+Ifyj1/5hXb165H/16bkL6q8a3yKRRg+ZlX11gxjtNglfazDCgZlRgG2wqDKoJPa0mTlm2R2Mzwm3aCpv3rsfhXc34iznC07peDmDi3X5BmbqQ9+J2oR9VNQCG/iapU3ZMnff0wO5A6zz1gK0DKBJpbWYwDcwsa1vzhYME4uDj0s67NbEthiQt1w1P2jIPE0bMj9jJrMSKwy0V4ye170pdiypQOkzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 08-04-26 22:50:59, Christoph Hellwig wrote:
> On Wed, Apr 08, 2026 at 10:25:21AM -0400, Jeff Layton wrote:
> > +/**
> > + * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
> > + * @mapping:	address_space that was just written to
> > + *
> > + * Wake the BDI flusher thread to start writeback of dirty pages in the
> > + * background.
> > + */
> > +void filemap_dontcache_kick_writeback(struct address_space *mapping)
> > +{
> > +	wakeup_flusher_threads_bdi(inode_to_bdi(mapping->host),
> > +				   WB_REASON_DONTCACHE);
> > +}
> 
> wakeup_flusher_threads_bdi ends up calling wb_start_writeback eventually,
> which sets WB_start_all, pushes the reason to start_all_reason and then
> does the actual wakeup.
> 
> The flusher thread then through wb_check_start_all does a WB_SYNC_NONE
> writeback based on get_nr_dirty_pages.  Which seems wrong - we don't
> want to do a huge writeback evertime the some DONTCACHE write finished.

This is all true and I can certainly construct a workload where this
behavior will lead to big regressions in performance - for example one
process creating say 1G temporary file and deleting it shortly after
creation + one process doing small DONTCACHE writes. Before this change
only DONTCACHE writes will make it to the disk and temporary file will only
be in the page cache, after this change you pay for allocating, writing
back, and deleting the temporary file.

> So I think you'll want a new WB_start_dontcache bit, a new
> get_nr_dontcache_pages() helper on a new node counter, etc.

But I'm not sure how you imagine this would work without restricting
writeback to particular inodes. Maybe we could mark inodes which have
folios with dropbehind set and make flush worker only write such inodes?
That would probably require tracking number of folios with dropbehind flag
per inode but that wouldn't be too bad. Or we could just lazily clear this
"inode has dropbehind folios" flag once the inode is clean.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

