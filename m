Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC17EB7EBB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ADEA6B0096; Wed,  4 Mar 2026 05:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C866B0095; Wed,  4 Mar 2026 05:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1009E6B0099; Wed,  4 Mar 2026 05:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFB226B0098
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:30:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8791B9CA7
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:30:24 +0000 (UTC)
X-FDA: 84508011168.13.69B5C9A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 04C8440013
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:30:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=siZp4t3A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hRWnixAt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sucmmmmn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yA1+3gNC;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772620222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=WRTkZeHt2obdB7ZrU9569kH7bd7FMNJShX3GuRSk7Z/rHhxAiZBJg2OqCut8MYPGewEDHg
	GxGKfQJQPJDChyoUwXu0zSyA2aTRgjvdE3ko1GaIScgT4HqkrsLChw9MsWGPPF0SL9k5No
	A/cMnyd/i0vDsJjUTiRC2UbqsJKJxT8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772620222; a=rsa-sha256;
	cv=none;
	b=gmOtikeFpQs2f6DTQbTJpF0yFEneDDrLhtcZDO/nDTCdNodxt2vAAGYucZf7IhZDrXIXyC
	+Hew42j+viGlQVEoG+AurCxCBN2FBHadlRPeyov6Q+KDWMUrjQ9QFRSHl3qWIkpoQu7jZ9
	70LgxmBM5iaVFED004OaFpw17zBmYmM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=siZp4t3A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hRWnixAt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sucmmmmn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yA1+3gNC;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B41D45BDE4;
	Wed,  4 Mar 2026 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=siZp4t3A6Gf7DGpcxsRRqAstaAJIVoTJ994JqZJ/yzRrFrOsdoZfaoBS/Eyhe87hyvPA6V
	ACbOl0dkkPmrlELO+M4o7JsWRHqGmA/3Et7bHuhWfPXJJNQc3bJda66Hz5nrMN3c07qkn8
	brVXr3gB0cqoE93ekYMuAdwUe3mH1rU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620220;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=hRWnixAtmwxt16gQu446BAjJv3l0nr8nlvQ2Y2YP7RqDe3+cF9h8sOnCox5H4/p8I4ATlu
	9KBD82KihbPdmGBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=sucmmmmnugeUmrf/mrx7P0vgvqWX5k1t//3lGg5lXWEFgGqkO7enjSQGkoD+bl+uIrL0A1
	LzxnMykHZHeYYQ7dbmpG1Szz+IVO/cZq4nFgfrK3Kqd6rta6XPvnnxnBbXGYmTHT+XiXON
	A6tZeLKBsCIWIy+dxSwdE3CXglxjUtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=yA1+3gNCGVL6lZ/iRstT5HJ6afRStjV0CxO209O7gedN2drYGBQdK9Tc9YwtNB62iHONEH
	X7suKX7Zsk9/HoBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A41743EA6C;
	Wed,  4 Mar 2026 10:30:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IWsNKLsJqGmFDgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Mar 2026 10:30:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 67F9AA0A1B; Wed,  4 Mar 2026 11:30:19 +0100 (CET)
Date: Wed, 4 Mar 2026 11:30:19 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <7irr5gqmatluutbkywhvom7ryzn6j7cl4sw7q2d7e5q3grd7u2@mk54kpnqbi52>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
 <aabqTRvKIWo2mHz1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabqTRvKIWo2mHz1@infradead.org>
X-Stat-Signature: 6bj5syqo536i1uxmyodx7poqe8whep1y
X-Rspam-User: 
X-Rspamd-Queue-Id: 04C8440013
X-Rspamd-Server: rspam12
X-HE-Tag: 1772620221-683474
X-HE-Meta: U2FsdGVkX1/88UVBPPLShZMLwteae4LXtrGrcQBDhGApnqB5bxBrkfrOXihudquZtVgzgEGIsY4oG7rniY55CjI9c0z+uobyRODQSjA+Yre0WPMb8a7k4dpJE7virY/AMu+nsmcg+VS9B2VGCRoZPWjxaoiuymGjW/+36HnDugSfY7kX7w15IiTjoj2KsE/7fCYTvwr2ILmWAUhApQtHYF2RWjw4Qm81Eocv3lMi95OOTZ+fiW2AFZ5itx1vol3SHyzGFE1BfMUwyuUN0nM5BEUdaPFB1z5PqzTODuuT8Reh2UrEUuaXMSyEyzD9FeXnhy3aIy8sSsQf0NlmGuJIAr7hmZDmV6KKixwFQy8bjo4FioaBF79zWirqKcIJmwkEmTteAIOJmeGD1EjAvm293FbIigWAV0VKZ1+H8ayqVCpEQ1xTAje8yF2AztJ9jcoQjEW/4dDkukUlciNqnD/Rxj9vFSeJSX5H0G4z67n2ZuQRlxIu85JZKyXXZWm5Kx+3966yZd30ma+fggxab34dOK2H1udcZXFmQQI935fs3Q62fOfYw7tS84FolIwxcOSSLaGjhnBAyAnzJBpksQ6+9UKF9dahKLX/SfRR6dsw1jGtoadRoVqn40iFEIeVY700ZoI8TXoLaf0qj/T2y5wxL8MsaScuH0jjtE9edp1gNkS098bBhNHiLRO0JOHjZmEW+4pkqMwiSVhStSMKmCKxVxcUhgI1ZjlRYT5wqiMNQF4UyanvcTs6q6UFfUe5EwgykSCvTQoiXeAWGZ8H6K33gWXehLCvGD01ReNBPgA7CaVvarYkJVdiGRI53HrH04pv5nRhCjgwba4Q1S1aLR+cBwlylnG1n3tfAF7+tesLvjy34yzlhsnlCzzb9VvJ3VhO1hUS3e4m+5PlxkN8xX9Sssam6Io3c13j6ZNaRRnS1i8WjS/3bnNlvd5AkhHcwSNFx4hug+6BuKeH7y3tkTQ
 Xqdm02Nu
 f+poEqWxuBgVzeAi2k86DC1hoz0mb/vJ3AmxRv6YiZDRJkPbTxnQP4bzmSo3L9jz5+tzQ0PKQiYY5JNSKo23++dFB9YgqcmzXfJYQ83a2krlKZ6VtnPJSaUFzhBPbiN9oJPuEdWI3LcURqbYQztdxu5VYH2eIPriY3e9rOLnFR8KN9YsyTbBq6bDO6EZ+l9Oo/LZqsOxbGIQcxz2akmXiwF0vl0QKCVdW5Y9aL9oQSA4eqTQoQwwp6lmRnLayk+Dtifpf6GDtHf2rGWvzQ0Snxw2bVrREM3KMozLDi96jMQrX7ny5L1QG4TxtGocu3hljS2paTYyvhYdoQdlC1ftTzVt5JU/j8I3ZjzFFQ69vbYxY5aoyNptGJv7bPrZtAZ+7oqa00SKGUrBYRf8YCuym4QI+b+/jUi9mhraf34FPrfPm/Dbsri5Xcrsziw1l0dickcfyeyYp5wHWdFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 03-03-26 06:03:57, Christoph Hellwig wrote:
> > diff --git a/block/bdev.c b/block/bdev.c
> > index ed022f8c48c7..ad1660b6b324 100644
> > --- a/block/bdev.c
> > +++ b/block/bdev.c
> > @@ -420,7 +420,6 @@ static void init_once(void *data)
> >  static void bdev_evict_inode(struct inode *inode)
> >  {
> >  	truncate_inode_pages_final(&inode->i_data);
> > -	invalidate_inode_buffers(inode); /* is it needed here? */
> >  	clear_inode(inode);
> >  }
> 
> With this, bdev_evict_inode can go away as it is equivalent to the
> default action when no ->evict_inode is provided.

Good point. I'll remove bdev_evict_inode(). Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

