Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61E0F3D32B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154286B0005; Thu,  5 Mar 2026 11:25:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFF76B0092; Thu,  5 Mar 2026 11:25:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98E46B0005; Thu,  5 Mar 2026 11:25:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C65966B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:25:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AF301B6B4B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:25:16 +0000 (UTC)
X-FDA: 84512534232.20.4F8F075
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3428612000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:25:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2+4RAIir;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lw8ztmxw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2+4RAIir;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lw8ztmxw;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772727914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8pGZQYxiUwSuJ7FDd38iB99LH7LuXz309mskHRqXZ8=;
	b=ADXVZQ8fvXfGbohdMBTMcAy8+USIndMh1Moq5BWLXP3KP1rN5keA6Z33OvcXGMrfkFFa29
	+/JleawaUtAzrfl+LANO2O9H7ivP7YORnTRyJyWbfQsnOgFSuiDSavhCuGGFhVT2Umq/XC
	DgCXMQph57Gv/zLL0+LIg3Sb4LypDks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772727914; a=rsa-sha256;
	cv=none;
	b=fmrQIV13Fysv+Np+JJzCB8E5JhPw7G5B3KviZ+9YwZ4rjIct01ZMcP07l51X2MfTLTS06p
	W3Q0yc/DTafwMFxLcaZmS2TyRxlleFuWJbHQSfZDvfj1MFu/A/nJ5nrclfVGHH2sYSpXvf
	ertsIN7a8UAB3GJIT5lYHimpIu5G57E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2+4RAIir;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lw8ztmxw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2+4RAIir;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lw8ztmxw;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 747055BD0A;
	Thu,  5 Mar 2026 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772727912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8pGZQYxiUwSuJ7FDd38iB99LH7LuXz309mskHRqXZ8=;
	b=2+4RAIirMnd079VjgxNdQ+WhBPJIG6qFlRH38xVHshJ+BCiI+HappKXxbfEG2SdE6cgh1F
	3cqgO+ZpNVqU0D2MZ94fRGOaYDNlUB7SC8fBM0S3aGWFE/3UGy0q55QbiawBRVob9uR2qA
	k6Oq4NkjJVOzDdmdZShqobUXNM/b8+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772727912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8pGZQYxiUwSuJ7FDd38iB99LH7LuXz309mskHRqXZ8=;
	b=lw8ztmxw8oFgrhLWMhjRYKEl2VMALU5IC7O1566rTsJE4ol4G6bDJnZGsOq/6FBvfHW4I0
	sFNxmIUMnxfFXPAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772727912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8pGZQYxiUwSuJ7FDd38iB99LH7LuXz309mskHRqXZ8=;
	b=2+4RAIirMnd079VjgxNdQ+WhBPJIG6qFlRH38xVHshJ+BCiI+HappKXxbfEG2SdE6cgh1F
	3cqgO+ZpNVqU0D2MZ94fRGOaYDNlUB7SC8fBM0S3aGWFE/3UGy0q55QbiawBRVob9uR2qA
	k6Oq4NkjJVOzDdmdZShqobUXNM/b8+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772727912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8pGZQYxiUwSuJ7FDd38iB99LH7LuXz309mskHRqXZ8=;
	b=lw8ztmxw8oFgrhLWMhjRYKEl2VMALU5IC7O1566rTsJE4ol4G6bDJnZGsOq/6FBvfHW4I0
	sFNxmIUMnxfFXPAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69FAA3EA68;
	Thu,  5 Mar 2026 16:25:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MKHdGWiuqWlycAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 16:25:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2B2F2A0A8D; Thu,  5 Mar 2026 17:25:12 +0100 (CET)
Date: Thu, 5 Mar 2026 17:25:12 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/32] kvm: Use private inode list instead of
 i_private_list
Message-ID: <f45xf3bgzioldigntjshfl44jj2pqbewtbyesmoxv4blm4dz4f@35t3bco6hfys>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-63-jack@suse.cz>
 <aag2yYtENaE3SFwF@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aag2yYtENaE3SFwF@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3428612000F
X-Stat-Signature: qx56oxdeqgrdzm6bnzccei4nqra1o3dn
X-HE-Tag: 1772727913-891831
X-HE-Meta: U2FsdGVkX183Fy1nI/Pqb7+v3SPazzF3fOql4rrfqOAWuuc1RVi4NoZPO8WiqTMl8RtJuMPtge2SJ1DMLQPUzTdIm8kdoNau6RbpvA4rBwFHA0xZveGkHz5lCPUBT1wPgMgfyBAecT88Z8tHDQ4WXrCzQd3LylriN+1UAx7+cPlWy3O8IXz6GUpc41gj2SsduRBXnK+uJ/VwNGBYII2TjUoskCJczX2psyvrbcH24rzZN9CDE894fwdO0KZiOOSoNpJbwBJpVxoYpVDwEttuyeROHY0mFZp92d5rUOyfjptWMB/N4FO6MTitfVIhTKW9osYJellyp13e8LcVtyn6qrB8TXAEZjmvaeVpT+4O/bJ9T9/WRpZkYoI4Fbcu6U6K9veV2NafXvsZ3fLFQ29N0BQPcGjqbyIukwk3sXUiGhlYTVzxkhLSqJBX0QKtAv93C4IpmHwHgET/hfIqb6EFi0QvSs7HlzMksATqAMdqw4/rFdd5Kg5tMQbEGkDBMqsWj+JJEzSe5F+aYY3ldpkO51VUf5tUjuS8U13XRF098nYuspZPkP+O6klUNaA0zcHgNIE61S/M4knt3B8fnLpcoaeytAy4JElZQ9oJh/I95HbahtsXNfELHu1CtTYZ++DAc4t9iPfaPkBCspK0whlIe2Pn3CoGj7hxDLPD1pVWNrpKAXJSJM9JG5Lmyrzg8d6HV9gdTkApmfHeUmuQIivhBYnruKNmbF2s2fhy5DvOFh1qYHs/9lZ9fD+zW9oA4Qo7sNvg93Ef/Gw99DItWHR5AkooC5sWFltwR6UyKTASUZrkeL4QXbRqsDk2JJ2QbUiwwmL8WeZySX3iXUef1VTfA4t4+aw02qAEJcNvqqpPb+MiM6/N1ibdrCapfs6DPSkyPpGBQw2BrI10zjbYwvRRUnIr0q3ck9eEjX1om8ZOdiTNHaH7VahcW4SO2WIeL0zCLQBMDHQsUn8KzgTkQe2
 H5DWoNpg
 +1b2JWWo8k/vJ0lFIPgZkHH2HA517/aS+Hz342Li/NG6D+hoUW7HuqJdrWQLm+Qs/AlsPlPt0/oHjrLqbJBhRlAbh2t5qVD8j6UZBpYdpoe+Pz+Gu/BBP5PutWNRBEVs3fiO+aGzYRSvSm4oRbCn4x/PxOK/BMObI/xUIM3af/nbUHBd1V3vqUHylonA0/UmAsPkSL/i9O+XIW7EfDSgLJdh49HvHiUTd3jxXdGvm/AYpEn+bXGyyxML9WLlTgI7Ydgd7Rcjt2ej/g4iZkUymtwWZqMBT7YQLIMEipvQhx6VF14ZYIXdgxY2Gw3nN753pg4u4gfgqDGH9FUPiDZzZcuuTfCtCk9a8eXHj0DJ0JaZDmrcUeNc12lVSmQZbvOUBI95OVTO5Ha//1v57XkvU2+umC2jJBaAaFJTrHiPteRCOaP2kEia3QYqQ8fniKuRtWQVP2C63GxXSX9g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 05:42:33, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 11:34:20AM +0100, Jan Kara wrote:
> > Instead of using mapping->i_private_list use a list in private part of
> > the inode.
> 
> Similarly here, I'd be this toward the front with all the other
> switching from i_private_list to private members.

OK, moved.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

