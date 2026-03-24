Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E12C9F54AB9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8896B0005; Tue, 24 Mar 2026 09:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FEA6B00A2; Tue, 24 Mar 2026 09:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1950C6B00A4; Tue, 24 Mar 2026 09:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08DC46B00A2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:37:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 945D014070C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:37:01 +0000 (UTC)
X-FDA: 84581057442.15.D33A696
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 631CB14000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:36:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="OYdnsU/b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cAGqIaMH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="OYdnsU/b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cAGqIaMH;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774359419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=v7xz5ClCwdKbZAI2wWLRrcUnY9i3mW8+rOl/pIe3mQOR6iRbTLkiepIPtMudGNCTCflnHZ
	Gridz4m679c2MKGt4gTUxp2Wh7FBrwwYsvNw4h819SJM5LqgplQayjH+lxW61I6+jZ4bwy
	/NSsIfqMmvbwaftQVEpQzbvUNJHEnvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774359419; a=rsa-sha256;
	cv=none;
	b=oEr/v73u3+tdSAQBPiLG81PiCbBuulFgyvr5lzkZElY5spEqD3pwOLPjY9gKb3DqD1DlFe
	68juHyE3BlQugTVJE9864gB20sGyHKIgLi38WZHiznvlorpAzHS72HdVrPYXh4FnBku6Vo
	95vwAh+dVHp21DrRgrR4nfKiCPKrSsw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="OYdnsU/b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cAGqIaMH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="OYdnsU/b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cAGqIaMH;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79D114D1F5;
	Tue, 24 Mar 2026 13:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774359417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=OYdnsU/bqa7wH78lX/xP4ENpOJBiyZZO1a1HEfPH871pcSsA9hxRzckzP2p2FD/xY1LRyf
	46+FNamy7mSYYYw/iEAmFFXphc3xGZWtbjAHt23G+N3pbmfyh27YvXmW9e0H31f5RuKATG
	P8W0lmrXh6cyc1cz0cYnEWx2zf8NTXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774359417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=cAGqIaMHX9aBjl8trg/9H0ZuskPR38NyCcUZV1e09EHsMTcfZGnGNw1e3+DSZWy0yjhbkA
	+KrYteJU6bfT5PAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774359417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=OYdnsU/bqa7wH78lX/xP4ENpOJBiyZZO1a1HEfPH871pcSsA9hxRzckzP2p2FD/xY1LRyf
	46+FNamy7mSYYYw/iEAmFFXphc3xGZWtbjAHt23G+N3pbmfyh27YvXmW9e0H31f5RuKATG
	P8W0lmrXh6cyc1cz0cYnEWx2zf8NTXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774359417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=cAGqIaMHX9aBjl8trg/9H0ZuskPR38NyCcUZV1e09EHsMTcfZGnGNw1e3+DSZWy0yjhbkA
	+KrYteJU6bfT5PAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C4FD43E76;
	Tue, 24 Mar 2026 13:36:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kOFuGnmTwmnDMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 13:36:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2D129A0B32; Tue, 24 Mar 2026 14:36:53 +0100 (CET)
Date: Tue, 24 Mar 2026 14:36:53 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <rsftk7gdlamfryksv63vhmewdi6etvvfyi6as5m2zs75ctvzkq@fnoiwumyfdsv>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
 <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
 <acKO3NRw852FdGUO@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acKO3NRw852FdGUO@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 631CB14000D
X-Stat-Signature: rnqxrcxpma1zwe3hfosj9f79nocfpn1t
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774359419-551393
X-HE-Meta: U2FsdGVkX1900zWV3RlvGOzy3VY1NdzrrcWLAdLtRt+Vh/+2U++KKrZK0E4pi+LpUeUrGAmptXQBHskUxMOAaM/3qx2WLa4mwrsJid4NolCixIXdMlZrY/APZ9PNCFM58LC6QYN9zeJPuakWMw++lgkl0n8SyLtGKhvMst07bNPI0r8uHgBmmvyN02BeINOzEOyZkqvd4pj1LKDgaLWc4c1QbPnATf3zeXk5gASOzgxev6lphwyE7DP9+WEi1tK2qsXQAZMNlcBgzR7lrGNs7lCgxibqqJpr7iBTLdaO6wSGcaINWlfYl5riwtxWNH3y+qkbnB+aBKCQBiCM7X/2seOkuBC5UK44gSwNmOlbIEPwyTfNHrJouR4U/y39DGP3ygCupLrDulLRDuE4JcW5a9FCRJULgFc6px5UG2Tm5B/tHAfDZ6qyINm4Rb3YSKMYGcXiQXAnlQUnUmAwMPI48uBcgodUod7Oaqa/dSuEBOQTfL4L0WK2aeOrqG1M3vA/RZ2hWWspqQ37d3a3pVw6X++yJT4IQNAa00I1ONc0RUVWC1TqLqCylt9Nut0N/VkKk1XeFoO6IWkYzb0ZDRjZLQ6yvm0M9vnH8qvVV6yuNbay27tczSFoNpA0KOi44r51XVuU4qUQCEmmbXYxS98zXAIVaUDnkNW2MFBNQb297pVm9qqU/gKkdDm9R0KxLmpamrJncPMheCQfljH2YtjUQNpKTaXgY1inD4iNmeJ+5B5w2R51Zx11BUad+ZcYOVpozt9gsvVfPcByPI4Q8Sruy5cofD1wQ67W2pKUu2hLtboQNMa+xbUezVe+GkFKSA6qvnPWvcmWAZUk+GzlidqsdCCs3oKi27yBXRPi67xuei9PrvjXfNc3+oCC/pAChr5Et+kfYEkVmRoQtHmIzQh/XdGC7gHYpkGoQHy1PGaPsGgURgBNfOhymX4a7hQlvZ0A1ieAJp4zH96nSHnVoAi
 x/0vMwDO
 pVbBdze8oSMrGqm5X7J30/q7jJ76v4WbaMzEzk3asSCylFCyWBjpnxI3kU57D0IKFr3fH28nITZqp08E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 24-03-26 06:17:16, Christoph Hellwig wrote:
> On Tue, Mar 24, 2026 at 01:34:57PM +0100, Jan Kara wrote:
> > I'm fine with simple_fsync() name for the helper with the trivial behavior
> > of writing out the mapping and the inode. Code wise this will look somewhat
> > different given what you've suggested for the last patch.
> 
> Yeah, the pitfalls of going sequentially through the series :)
> 
> But sketching this out I'm not even sure all this makes sense any more.
> Maybe instad of the allback we should just have a helper for checking the
> inode state like:
> 
> static inline bool inode_need_fsync(struct inode *inode, bool datasync)
> {
> 	enum inode_state_flags_enum state = inode_state_read_once(inode);
> 
> 	if (!(state & I_DIRTY_ALL))
>                 return false;
>         if (datasync && !(state & I_DIRTY_DATASYNC))
>                 retun false;
> 	return true;
> }
> 
> and otherwise just open code the calls int the two implementations
> without any callbacks, as it feels cleaner to avoid the entanglement.

Leaving the two implementations separate certainly works for me as well
(that's why I've put that patch to the end because I've expected some
discussions around it :)). Just the amount of common trivial calls you need
to do (fdatawrite(), sync_inode_metadata(),
file_check_and_advance_wb_err(), blkdev_issue_flush()) looked high enough
to me to be worth merging the implementations. But I don't feel strongly
either way.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

