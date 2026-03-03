Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24322EC1427
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6EA6B0161; Tue,  3 Mar 2026 05:39:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE6D6B0162; Tue,  3 Mar 2026 05:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CAA96B0163; Tue,  3 Mar 2026 05:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E19F6B0161
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:39:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E02CD1602E8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:39:53 +0000 (UTC)
X-FDA: 84504406266.14.525E35C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 77802180012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:39:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cNqkvYj4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a68tipc5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cNqkvYj4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a68tipc5;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDKEWjSVOqkrZc6vTVeKneTnpLaNmie+ySjDkZuCOrk=;
	b=RZ2f3o7Nk2oHISoFi75QbOb3jO6cUU+VOwtHafnAUbLNPeQChMQL/btv+2eMhDs5KHdDdP
	Hyq7Vzxs1WAlZM58B528x60F1uXwSt5HKa+kn9UDmk2MUdcGZg3uNs6vHZI88aZV7sjsQe
	oOeArE625v/YrGdDIbf/SAN9pWZG+6Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cNqkvYj4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a68tipc5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cNqkvYj4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=a68tipc5;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534391; a=rsa-sha256;
	cv=none;
	b=JMcgAZ1H1oMtXTzTcfrz68YngF8Dd3grGe8AKRBcm8YrLuDpXG+0V7yjscyh1DAPsspij+
	AFKyZUSlmU3UAt+pEdg+z3SqoTMiqJ8q0ExGhnclU/jwpPPZ++MLm3uxnHQtWFzBpZJY1M
	Sx25ePzLx25sr+/9lxlmH5yQb3NAzIE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE4CF5BDEA;
	Tue,  3 Mar 2026 10:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UDKEWjSVOqkrZc6vTVeKneTnpLaNmie+ySjDkZuCOrk=;
	b=cNqkvYj4wBqDXl9j0WVpUChli3T7qASE5M+Zr17hq13Fr7BvA48MgQnP8lMjEFS3zlyQdx
	QDa9vELibp292cA2BJMaMq9suPmVkz2N0oZuaSSgwV8yvT2uX0t9129X5pKdNEXzQtPDn0
	2GQD7e8QJZwustXF+VSTHc709NeA/Q8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UDKEWjSVOqkrZc6vTVeKneTnpLaNmie+ySjDkZuCOrk=;
	b=a68tipc5Waz0LebOf6mtviHCUF0ztGCOw8awtTpbzJ2vBfITtpK+dl6TJPz+cXJR1FuREe
	B6XG/A7VhOlQbnCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UDKEWjSVOqkrZc6vTVeKneTnpLaNmie+ySjDkZuCOrk=;
	b=cNqkvYj4wBqDXl9j0WVpUChli3T7qASE5M+Zr17hq13Fr7BvA48MgQnP8lMjEFS3zlyQdx
	QDa9vELibp292cA2BJMaMq9suPmVkz2N0oZuaSSgwV8yvT2uX0t9129X5pKdNEXzQtPDn0
	2GQD7e8QJZwustXF+VSTHc709NeA/Q8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UDKEWjSVOqkrZc6vTVeKneTnpLaNmie+ySjDkZuCOrk=;
	b=a68tipc5Waz0LebOf6mtviHCUF0ztGCOw8awtTpbzJ2vBfITtpK+dl6TJPz+cXJR1FuREe
	B6XG/A7VhOlQbnCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A29173EA69;
	Tue,  3 Mar 2026 10:39:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UTCrJ3W6pmmwGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:39:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5E5C8A0A1B; Tue,  3 Mar 2026 11:39:49 +0100 (CET)
Date: Tue, 3 Mar 2026 11:39:49 +0100
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Tal Zussman <tz2294@columbia.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH RFC v3 1/2] filemap: defer dropbehind invalidation from
 IRQ context
Message-ID: <aaybsigvp33i54w244jy4jarwf53zph5mzwjy2hcfm4v7m5o5o@e5hljmjqa3kq>
References: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
 <20260227-blk-dontcache-v3-1-cd309ccd5868@columbia.edu>
 <wen63cjbk3k54mjzgw7zftsuze6bzxmdk5u5wdjabzdiqg645k@67666k5lrevh>
 <aaXK0_HqEnU5SK61@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaXK0_HqEnU5SK61@casper.infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 77802180012
X-Stat-Signature: 3wd7swt8rtoyw7dnuni4smcuxwdazs81
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772534391-390751
X-HE-Meta: U2FsdGVkX1+qteR9mmVKch3La37xFsNmKvVF5CDFHnYwVyt8ZJLsLPqQ911lUU/YdAWJ+MGunEIVJwAImcBw+jSHnGdIPYDGMczsPURawYDzWVTKnVr9lwb5/n5cTvRDvULh0DwFacfRn58f0FAM5+Kd7nULV4yGDdYtYRsPJ7WWeR5c9EVZS0zCqvSSScM3vJSpjLTT6dewp8gfvcryVuVQs55QgxnUfVXY5xFkMt9kKBh+aDuNMsFd4Lq+VOaFg2JtiM8A0dnrDFI2H0GNEAGn86AxuYVLkxQYSU5IycMmNXLYL9CID16WeKCvDRNXJLUe+GnmzQHGzUIworMwpY7KLk0yRI4mcMA1DD8kDTc3IpHvFBqujg/mVVU4apeIDHE9FG6Th/MP/rgKBLS7yDkz09yR0B4ua7CwFdurICeU9CgvwZe79ju1UDZ7AUTxVSD6ORYvme/pme3Fc6IafYATiQ1E4EoF4KQ0zhHybt1tPR44R4PDPcsLUUwqF0uj5qysMTIqCQQH7zKdaBd37in42MJAEFdQTDb0YYfbiq2H3ChCQqIvPizT8UrKFVDNgTGKgL2iCQL9ar/Iq3F1xaipgG4PYZpsXCoPDL+vJOHX2hCla59aGDg8mbz2NFJglFVfArjacDT0BOvs7zSWwx+D7bdKK1WDHv+HzXP3/SNdZ2n+3lfPA5DhbmyLRNk1xRTvvaVIa0N14B4fQexGiq0Ah95UFdD11ii+VBkov4A3GXqYlSLBXfYHt7HcVE/+akI6t5DggvqY4c4WayStOUfds66gk2kWUPXMj/mIekRJ8B/4/mYE/uNiTgbt11SIjc+JkK+9KjlEaIh8osHC0c/dgtZxU2bwijkXGZDCXcVN7vQHp13BC5kp/Gf4+6zJK4S9pp0FRFycbfi7QdoYfWpmSRD4qobKKi0vbK2UA2vqwQF2YqPVr8kZeOGbSwveF4IWnsxfJOeaDpRPffa
 uVFp0Wbo
 DN+g1QzCkSb1S9dj14NEH1CjZkr5iNj/EpExO08RkL6btDpYEGCKt6xKQyKA5ItHD2dscp+Bh5PncTMVS1mxa6i8D/YYnf9NVEm8sKKSg6eI3B7MrFcUl5zOneIT3SsQuYe8zM112OoNYzOS1m1iNivkKPhAbS2ZU53I5LHaWQmZPEpQMj1Ce3zCJsKTln8OU2TfbMigSCaZonztLQeZi9b0Ux47ANW0FZ4fOqiGF18NGLDaA/3NnaF4Xx1muGZ75lByNsocizKm0uoS7fYxKH2KokWUnTBHAR7DUw8M9tsWdDfFSDuWwSFhq/Xlwu+7xWLV7SQfiky+ihqnzCodA1EXqdeFr8oZFGx/Hh0eu8OLMw6KyRVJ6W/MtQkWcuRSjsI+PM4DpKojR3AH+hh5qkMrBmBbwPvB+tZIW78oO/Jn74Xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 17:37:23, Matthew Wilcox wrote:
> On Mon, Mar 02, 2026 at 10:11:19AM +0100, Jan Kara wrote:
> > Folio batches are relatively small (31 folios). With 4k folios it is very
> > easy to overflow the batch with a single IO completion. Large folios will
> > obviously make this less likely but I'm not sure reasonable working of
> > dropbehind should be dependent on large folios... Not sure how to best
> > address this though. We could use larger batches but that would mean using
> > our own array of folios instead of folio_batch.
> 
> That's why I think we should allow the bio to be tagged as
> "finish the bio in workqueue context",
> https://lore.kernel.org/linux-fsdevel/aaC3LUFa1Jz2ahk3@casper.infradead.org/

Yeah, what you suggested there makes sense to me. The workqueue would
probably have to be a per-cpu one for performance reasons but otherwise I
think it's worth a try.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

