Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF37F54AB4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26CE6B009B; Tue, 24 Mar 2026 09:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3486B0099; Tue, 24 Mar 2026 09:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2746B009D; Tue, 24 Mar 2026 09:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA86B6B009B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:28:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69D7A9389B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:28:43 +0000 (UTC)
X-FDA: 84581036526.13.80FC1A4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC22C180005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:28:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VLRhQVNO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=focKEBP0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aajPyr8d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rX7EZ+XB;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=my/XhVdznRBm9dFFgWI4bfmfYLPPnAcGkM2HHXLNUN/vM7Hxp900j9N8Fsyv2ORfPqP0z3
	hCzyjd8hE/fzk5tVdfp8CTziVL7R4UKQLVEgEAF7WZLSX2gSXZX0ov5JQpkejNDhMXzxKL
	k7tfUF5mIV/YHPKPGUTsAMXcXmWoE00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774358921; a=rsa-sha256;
	cv=none;
	b=ToTRi0wIO5UGP3va1peF/VUBx5Rx7aI0Y3thiIV7bI1kWnCYqKbnuOLRxuk11eIzcScody
	hlynFD3n/4/Vxf0WAAYJqX5s3Ps1/SF+onmoGra7E2r7SmBlRoFkndAp5DidHUIBwFt2e1
	j1+oDFEmMmSEgP+8oOj0opCkMhEat2I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VLRhQVNO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=focKEBP0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aajPyr8d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rX7EZ+XB;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8A874D201;
	Tue, 24 Mar 2026 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774358919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=VLRhQVNOMcakGuxjD8XRZHoDsUzpel+Uj1r1dyAM9I7mjwv7UUc0n0BtxtcQj45GzEoSa3
	w8IVlKC0+QGFIzcZuWkDc4gPz+GVN7igKmsARilZohmARyqIbsG8PzFgP2Q5ZskHHb4rfN
	Fhy+EgK4nv8TEu/ajnfijmqjEB5rut0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774358919;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=focKEBP0E3pHdlM7sQULbEwzuzvsQPBrqJvzjKKxJjgmQRMQxA1cmNw7bSloelqOY2i2Yu
	CBY9LLry/9DKcHBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774358918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=aajPyr8dL2qXEsc5Nma+UUjmL2g2Yg0vA3FN+G85F9wgq4nh1awYXZRDhWxWI31rOCmnIc
	RJq/NmYC6euUAJlHHI4ZOzn3ZrAX/WbuMLkXcKWCNYgZwt8GeG7PNImf9dgShKN3MXp+sh
	4HpgyX1kPaqVsdGto9mQ6PgJEAm56gc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774358918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=rX7EZ+XBlJoOpiXR19mqVLEUK/Q6yZAGakQOxocTCViQTVOBeydbsz4kWJaPCS4a8eu6Ik
	37B2Y9+w5aqtDNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBDBB43E6D;
	Tue, 24 Mar 2026 13:28:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f+C+MYaRwmniKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 13:28:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8D106A0B32; Tue, 24 Mar 2026 14:28:34 +0100 (CET)
Date: Tue, 24 Mar 2026 14:28:34 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 41/41] fs: Unify generic_file_fsync() with mmb methods
Message-ID: <k5422gxvhqqmabpf6csub7opo3vbacvibaqwwigzx7t3b65vna@jzh35hxc4jz7>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-82-jack@suse.cz>
 <acInjoDTJAz62eUp@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acInjoDTJAz62eUp@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DC22C180005
X-Stat-Signature: s8pbzchcpm7w6xtansxkfqhibtj1upks
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774358920-917199
X-HE-Meta: U2FsdGVkX1+IcFUNlz0Sy+hVTookkVHGvdilw2HzweR8kbCmCQLpJBJMBw0YT4I9HkrqLwZm2kcHtJvJM40ib04K20137RvtQbPNbr7xANbYOun1QloqWQmLhxMElU+4YiajpY9tqKJX3MbK3Zgj2pKDxcvPd5Mf0TsEDdNHh5v3QUJP4bSFzvqGE24cw5FI28l2mzbVKcW205jfF6ivuBMbL+tjR1r3DUvIh7GhFxnSkywO0oNF/ZEUM5ZOOehDKvRFaSlsdiVU7t9ErB8hi5904sVbQ61rsgBT+EFSTO1/ShiJ8vykq+67zecLv2fjXK9v+AhkiN+WjKWzKrtKT/oNe0xd99XRSjOadGy3r67XV+L5LCxHnDIZ/bZmdqQo4ojssyewr76GZgcUKljmKgC9qYmKuRwlsz2MqfJVWywo90zWgf9se5q3ozOXVpcEqa0++LJqpsog2pUgd+zx+hFzmkR1I5I0qHxiKBNis3tqwr98oZ42iXoviqxNgAfhR1iX7aMyq0etTIV2hj1hoDDwlvpYxDwE/LZFluwfIwLfdXNPOj0ovWDRk1JjsSl3v22a9GVkpU+tMlv6IGVuYyeEEX34x8T8vl+oektug+P55iLksCex5SDk7CXXjxgQhCCflfROE/CQzLDY/dfDPFKpEntiqvxGl4IFNNKWokNsKb5y9ljxI3YuHM4h7SQFs2BaBfXJwR7llxBf36qCCFUZa71H9PPDE7bfJKXNCfvYjxYPw7tC+XZIn1cxmCa4E6z/sHCOY2F6ygRMkWuPg1TF8qe38ndcizUH9THMRCfh7Z+oU50OGYLNRm6tdyGxqA+wsCi4N8ASQDvwL/EaPhws+MWatLNe/XXKu+30siMFiAATTFEzC6i6n1d+774o2jbZnpA3twCMZ7S1l84+gByJJ8BKFWGzzth9wsoPFYYvPiqu21IyRfQUGOLC8yRR6tvLxDzlkTG9E6vv0Pu
 pNPbfEf+
 pWIe7PZJId5zgks/5zhsM8WP4EUdynpR48MDFGw7aXb/qql1tN3RE3Vpth2VpMy9/Vk48dT8dYI77eeapXQPDhxMTbfYj/7Os9tRPAa3Kc/iKp1JoB6MJlBY0ZjVhTunJesKkGwipqS3aQwswGi4ow8fvypaISceluB5iA0/bx7paBZ/VnY0mHvRFGqOteXhapnKzrGVIU3DNGaldnj8egE4Fqa6ey8U6kG+GEqGxs9ubMYzLR0MTKFC8dVUjr7/VbiHhc6LAsiUnahjJCy4+ftfDV+qJYZtT7mD73xIUTGy1mMV/r1bYYHdJsmYcDj0H3+QcoXcEks4p6ucMIvGIifDAfkvVK8UohRZ6FPFjJ7MuOytdrQQRrrB3GhRf49d82xuVBdHDRXWa2yDhrfJDUXpqHDZgmZ1mDafJm1q2FOjzjgYYJryufJmi4bp4q0HsPpwsymEDHeMgt84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 23-03-26 22:56:30, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:36PM +0100, Jan Kara wrote:
> > Taking inode lock when writing out the inode seems pointless in
> > particular because there are lots of places (most notably sync(2) path)
> > that don't do that so hardly anything can depend on it.
> 
> This is really something that needs to stand out clearly for bisecting
> and documentation.  I.e. make this a patch on its own and preferably
> before all the other refactoring that already is affected by moving
> between the implementations at the beginning of the series.
>
> > So let's remove __generic_file_fsync() and use
> > generic_mmb_fsync_noflush() instead to reduce code duplication. Arguably
> > this leaks a bit of buffer_head knowledge into fs/libfs.c which is not
> > great but avoiding the duplication seems worth it.
> 
> You could just pass a callback to the generic version.  The cost of an
> indirect call should not matter compared to the rest of the fsync code.
> That would also be a nice thing before all the renaming, as that means
> we could add the version with the callback first to unify the
> implementations and then the file systems are switched away from
> the buffers fsync variant to explicitly pass a callback, or to not
> pass a callback when they currently get the default one.

OK, makes sense. I can put the patch removing inode_lock from
__generic_file_fsync() at the place in the series where we start
dealing with fsync handlers. Then I'd introduce fsync variant with the
callback and then convert filesystems. As I was thinking about it, it would
be natural for the callback to be called sync_metadata and handle
writeout of the metadata including the inode. That would actually simplify
life in the following series I wanted to write which will make sure that
fsync properly writes out & waits for the buffer head containing the inode
(currently if background flush work happens to write inode first, buffer
head is not written to the backing device during fsync). And if the
callback isn't provided, we'd just write out the inode. That sounds
reasonable to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

