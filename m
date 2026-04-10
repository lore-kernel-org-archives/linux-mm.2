Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E228F44871
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25CB6B00AE; Fri, 10 Apr 2026 09:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD096B00B0; Fri, 10 Apr 2026 09:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12BD6B00B2; Fri, 10 Apr 2026 09:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B04746B00AE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:58:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F1E2E329B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:58:36 +0000 (UTC)
X-FDA: 84642801432.19.CE48EA1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2AAD6180008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:58:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vWZbIC2N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KsEebD9c;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IJqwGUfF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="O/BHxZuF";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829514; a=rsa-sha256;
	cv=none;
	b=tKCvOSsnjLwS5SmrjPlWlkUo8rKt1Z5cw27tQLdZIM7wwFN2dTPzSOuY/8VE4D+WG33qy1
	DLYOvqqv/Szwx59gAiu4wrQ5zwmfZZbcD6+YtnzLKndDXH8pSbg+Aa6W15YO/b13F4xGMw
	SbEfSK3ncNbRCrWsBn/UrpckNMjSeCY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vWZbIC2N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KsEebD9c;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IJqwGUfF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="O/BHxZuF";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RVDMTcGQhdEmFHIKJeFRI47IlLZziJTl8kPSrRvHwM=;
	b=pnJpNEj2fwcijikHdxhEJ9bZe0ipCFlsvREUTXuTBPHgozZPdaBH3djedYscfi9GrYouAA
	y0otHwk6BuJ9mea8lchipX8OGhvvv3sHIr/SKRJt9sh1o0mPQ+RpnB07PJKiSjiTDb/Xpf
	NS/rC7OU3aiXSKVAY4Tc18/ZcwOien8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 968725BCD3;
	Fri, 10 Apr 2026 13:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775829512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4RVDMTcGQhdEmFHIKJeFRI47IlLZziJTl8kPSrRvHwM=;
	b=vWZbIC2NF8lkBqvyg0/EKfRmpKCfCO8hWFxuxCG/0dqa35SGiEkRtyN9ux11DxKdWxsB9d
	6LVXevyYhjYl0xDX8a4MUph28w13wGTbnS4KKqURt7I6kHLw2jf1npOneAHXUvG/h6o5O4
	pWjaUSPmK2k8Ruq03LEXNFU2Sho5y1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775829512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4RVDMTcGQhdEmFHIKJeFRI47IlLZziJTl8kPSrRvHwM=;
	b=KsEebD9cw7SKDbtzjRs+Gy0ivdIvMTCEHq7de8c68gdHEukRkKEFz2AiZtpAQFso9XnKU0
	iSZt9REZLnlOgDAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775829511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4RVDMTcGQhdEmFHIKJeFRI47IlLZziJTl8kPSrRvHwM=;
	b=IJqwGUfFZOg6Ih1PGrjkVkCodwQXc9MzVBVf4F2uPkGyiaonkUmB5VJ/i3zHDmUKBtMBx/
	9we4LYDep/v1o6fOy24k8F8PG74KW/pSg4O6gUn0RNUYw7ll4D42pUmI991YWSb/ctgO59
	ivVKlB2m5Zbqg2xqTjwOnHDem+kvqFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775829511;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4RVDMTcGQhdEmFHIKJeFRI47IlLZziJTl8kPSrRvHwM=;
	b=O/BHxZuFthF5OZ99+JtGVSFI5mxo4uruRfNy8NVjgRY6DST5ZIPGNPcabwMNbYhsCtIkJc
	7pUBpxPp0JHXiFDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 889D24A0B2;
	Fri, 10 Apr 2026 13:58:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PCJUIQcC2WlASgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Apr 2026 13:58:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3C560A0A81; Fri, 10 Apr 2026 15:58:27 +0200 (CEST)
Date: Fri, 10 Apr 2026 15:58:27 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Boris Burkov <boris@bur.io>, Amir Goldstein <amir73il@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <ntokc2yg35cn5etqp4bljd7wkbt2tydl2hhpxamh5svoikzv2k@zvbpiymsxozv>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <CAOQ4uxgYYt8LQqR+feSwqGccqD7Ns3sNgiVHw76mYsbKSwq5ng@mail.gmail.com>
 <20260409164834.GA3472346@zen.localdomain>
 <adjaHn7RnvaMp7mc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adjaHn7RnvaMp7mc@infradead.org>
X-Stat-Signature: cq3oq9iq9eqsr4yyp8wrr3akaisi18od
X-Rspamd-Queue-Id: 2AAD6180008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775829513-613615
X-HE-Meta: U2FsdGVkX1+RmyJBr6vqEuBM6KyzyMf3cAAL4NhplXvOJ7YrWVxkDkkP6yGV0lh0gxbAP0FS46YMAe2kaCtzBc8nOJbYYC0dYqWmLI+WtHXZ/Kya3+SCJ9LW2cF5Xhk2I7VUMRX5kykNGsjbGWrktUq3AUq7Kd6Mt/+icolzOrrWXUbR9wcHX9FFmRqe8WhNFT2xASy0DqMrWiqACcx5t7NJsEY6z8N7K89X1PRuWIakwdUOLwDsKwHtLjLc2cFEoOJsPjmfSU0dCKcRz1smwbgnrGOSNg8a+BgG3oU+GmbAZW+KqsA2VJxhy44sqaZWPI9BFO9jK+uTFL01D62FuN9j9tR43+rLDi+t/1N28lEjWjNVuExOK2Uc1KidYJiltmufwxgpKF+Dx1cW7Vk2VM1z/YlEfvPqtxKYuQdDsGOqU/owp8UU7U4kqOjd/JJzRRv39Cpwndg+1rWGtmF9DLAvBqtowH4ts2DLwT9hgIWQVqnEWG+tr5chMBIdfFm5D7uQbRKzCgFK10BSRnLS57hD8+befjz9+eKwVXXWlEWnlCwIciskmyi2hQXjLqR4jGH7clObtXfTIQIKcIl1xh3Ql2fkLnKjE6HFzbsn570GIthRDbFPE0dCZmkKU1APiu+c/8avTLfbqKHcpZsQM8BBEPkdqeY+We7ebVS2uDEve5mwmBDgXZUhaduB8kos6tAM4Hj/qMrOlgZWlgQchsjYcrftdnRFEZPylbJvpMEWxjRCJwe6U4ma/dfzeYYX+xUdJQTdoTI3THpDNI8+VV3VgPzaiHXqCRBEllaKqAMDTqkIkbNbCCZNJb+7cLSfTsX7p84/8BmAr5CS51voWxmxaK4JjQzofJ7SxXXei0PtR/TeKfkCK0WLS+GkAxH9jafIVPaD28bA7VI5YFj3mxYhybUVC0nl55SsjZQEE+Q08nQFrZYa+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 10-04-26 04:08:14, Christoph Hellwig wrote:
> On Thu, Apr 09, 2026 at 09:48:34AM -0700, Boris Burkov wrote:
> > > > This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> > > > and they can work on freeing memory needed for freeing of hard to reclaim
> > > > inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> > > > they should really be addressed.
> > 
> > One question that pops in my mind (which is similar to an issue you and
> > Qu debugged with the btrfs metadata reclaim floor earlier this year) is:
> > what if the hard to reclaim inodes are the *only* source of significant 
> > reclaimable space?
> 
> (disk)space or memory?  If this about disk space, make sure your file
> system ENOSPC handling triggers inode reclaim, XFS already does it.
> 
> If it is the only source of memory we just need to do the slow reclaim
> to gain memory.  You better use mempools or similar to make it safe.

AFAIU he spoke about memory. Yes, mempools are the standard answer for
guaranteeing forward progress but in this case good luck with properly
tracking down all that needs to be "mempoolized" (and how large the pools
should be!) to guarantee you can run transactions to cleanup inode - for
each filesystem. I don't say it's impossible but IMO its way too big effort
for the gain. So I think just throttling hard to reclaim inode creation is
way more practical solution, although strictly speaking you cannot
guarantee forward progress in all the insane configurations you can think
of.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

