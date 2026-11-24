Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC4CE606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 12:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=S4fNvYLc;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ud3hCApx;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=S4fNvYLc;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ud3hCApx
Received: by kanga.kvack.org (Postfix)
	id E1FB46B069C; Tue, 24 Nov 2026 07:18:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0656B069D; Tue, 24 Nov 2026 07:18:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE67F6B069E; Tue, 24 Nov 2026 07:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A89CA6B069C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:18:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 344F1120B2B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:18:13 +0000 (UTC)
X-FDA: 85469914866.25.E0DC750
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 07DA340014
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:18:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S4fNvYLc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ud3hCApx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S4fNvYLc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ud3hCApx;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795522691;
	b=CTgWeq3Z8gJccyt3+yIEoqy1LbH2lHfBQMjRZJFCrzRNs5MgR9irYIM6fptJebhzb6UHGt
	QPqyuDVpQzeYUjGLAj4pUooPRP8m7w9H0/gg7V2Yg/VyXjOd9ELea8ElDEkcroGThgyPwA
	kket+hbPZ/iZXxCEO3PphFNZ0IDq1Zw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795522691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgBHIYkhFTpaNh3EavcAhRQhhc+Otx9Z3NnjYN0VEoA=;
	b=R33Fe+mZPWAh92Ne27Worqpp56yjhbirGgqFOSs2WtRy6ahOCzEIXqAdd6V2q4pdNjMWRH
	8VwJsBmUzKTJBKFyDfp51cfNpTcRAnZPx7lcik4m9rllCbadiq7TllRPdYZvj8qugti578
	0ofGZP1fOycJ+DY/6wtnzNxjo8FqRuA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S4fNvYLc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ud3hCApx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S4fNvYLc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ud3hCApx;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E8C52227F;
	Tue, 24 Nov 2026 12:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795522689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgBHIYkhFTpaNh3EavcAhRQhhc+Otx9Z3NnjYN0VEoA=;
	b=S4fNvYLczCoYZ3Wr8fBL7rFXab2B9AUAKn1QfXgjM0ANpX9kmQ/Y5sSvAq9Rg2l9k4png6
	yw8sgi6WwOw2GX7inan8m1+XFbkRsEqcUH7sKQ2Oz58P1uMALfVjs1C5A9+jzO9BVGkpXm
	5paAoLyG8uiyEdYJ0ayph/P4/zQV+5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795522689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgBHIYkhFTpaNh3EavcAhRQhhc+Otx9Z3NnjYN0VEoA=;
	b=Ud3hCApxs66xrqjMVAVkxCxeCaJXbf5MhAyhFNox8DRyG2ZvO4yI5a7Iulzmev2StO5tLs
	pAwjuxwDH1w68yCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795522689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgBHIYkhFTpaNh3EavcAhRQhhc+Otx9Z3NnjYN0VEoA=;
	b=S4fNvYLczCoYZ3Wr8fBL7rFXab2B9AUAKn1QfXgjM0ANpX9kmQ/Y5sSvAq9Rg2l9k4png6
	yw8sgi6WwOw2GX7inan8m1+XFbkRsEqcUH7sKQ2Oz58P1uMALfVjs1C5A9+jzO9BVGkpXm
	5paAoLyG8uiyEdYJ0ayph/P4/zQV+5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795522689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgBHIYkhFTpaNh3EavcAhRQhhc+Otx9Z3NnjYN0VEoA=;
	b=Ud3hCApxs66xrqjMVAVkxCxeCaJXbf5MhAyhFNox8DRyG2ZvO4yI5a7Iulzmev2StO5tLs
	pAwjuxwDH1w68yCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 415C11352B;
	Tue, 24 Nov 2026 12:18:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IgEsCYGABWsteAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 12:18:09 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CD74927861; Tue, 24 Nov 2026 13:18:08 +0100 (CET)
Date: Tue, 24 Nov 2026 13:18:08 +0100
From: Jan Kara <jack@suse.cz>
To: mohamedalibouhaouala@gmail.com
Cc: willy@infradead.org, jack@suse.cz, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs: filesystems: update filesystem type, superblock
 and inode documentation
Message-ID: <47rkrhjkulqvgfkp3ssvgrrmsfmeof6adtjrght2fcmq6ykbn3@dis6c75io7ri>
References: <20261120182207.97249-1-mohamedalibouhaouala@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120182207.97249-1-mohamedalibouhaouala@gmail.com>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 1qacjezssbadi63g7adm1pnaq5jqfk5b
X-Rspamd-Queue-Id: 07DA340014
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795522690-578244
X-HE-Meta: U2FsdGVkX1/du1s+DzUTA2mXcpHixT9yXHvt1avybZjp3AbiqYfyCa3NMsgmn7LXp3L2MAovl1K9O9LxHmRfQEWJC4Kj453oFO/i0C6y+y41XmCkz12YGD0CsCG+406pZWD+S0TX/leItR1AcXYSZ8DltkZSNCnr3NNDa1A08NBIFn3qqhFr5v8u6oenoZPC5wThWq++Ig4hcrCvFu9l7E2P6gPn2+kV/8mnO1tgonqv4ne5w4j7t/E4IG8lPu6utib80W89rHf3jXxYAhvURH1ezTr1FsOksbhawB8MS3adSE/3ZehhsFllPqZrBuFJ+56a7+loGx8EOFONMqY0blWk3YzCE8NXgjQ2KZZu4yz0xrifQkoJhD/sa5G6qZWAvZGAces/rencmJCE26o8cLe861ZtihyS9JHV6hAAjq+AwaLDLQzXmJeRJuJSY8Gy8nyB7UBVXFya9wtxA/66TBpRyReWleqb8LOy8rQf7iOgktEeDYGCJ0aDj0dKbTY3MRyMuWAQPNZk9NeJOq4ILrnRHlqA9Qmw9Pnj3ZUTQtlO/HvozUmjMTtCymgD/Jx1yS76WOa8QowsvLhLmlsYOuCp06qc7bH24mV8R5O15awXvbnLQ01QwwjjSv166aBxWdqn6jjLdaP0fgNYvuZv0f3QQs0xEiceL6huPahwCvSxhNjR0U/NAAc1iAsfwBFgCSI4bj6QHEg0ZSbvWBgdH545kvK97VozsCV5NJ6ohc1Aw9uThueMaEbRSWd+mhrNW/VzQGwILcrYEoUjqgdX8SVvOkmamZW56gOmzhY7CGGOyoD+FWQhassp3DgYwL48JZ5irRVxbnjVEcKp0Su69dEDwWoW/6+4uFC3/uDtob9MaDLCN4fHDWwuDtBHcuwdrgNCqKJHY8wbRp81/HoreBwV7YCYUhALdUPzG0syi4wYXQflrFo3UdZLslqpkz+Aw0p16hOl7ZcfGJkS6mQ
 05bNPPxG
 f79fVyOZbexyTZ5+8ciWiRDM3SjRKaMr+9y9CP8jwrUblL6jwul+/d1qqqDUcE6c3eqRn0lfx4ybZQqDSlwxYM0CJFYcFoBudKoMugn4itRA0GCpQU2T1R+kJv4KyMP1w7trZ6qgs9a/995RjXc6Eew0WSWqSL1xVR2uJzEx2dEuvpcsOc60w2kCOQ+nqdHjL++Pgb37nN6LLgiwU5z/MUsC76U9O2kiIDc+1BcgOZ33dFnpHmdChOMoVoIiO8IMvlL2J/RjsNXTA1c0wb7J0C57rOZt51EM4epSeFz3v3S7JkKlGkJdhkdyKyFcPAQEErbmnneb/LPLPSxNOMi4NfkvIAWizCUK5V+6V5z9L8oBD0BZvUBnXf7dKwx0cHrEa6hyV1IXWWJYucwUzz7SALVuXBEyNzZRl2XFaG+tUrhbWy7ZZDoEz0K+aJT4lzO397lYikiBlTIfx2Jaq1CHD42othg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 20-11-26 19:22:06, mohamedalibouhaouala@gmail.com wrote:
> From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
> 
> Update the VFS documentation to reflect changes in
> file_system_type, super_operations, inode_operations structs.
> 
> Refresh the documented structure members and callback signatures
> for super_operations and inode_operations, including missing
> members from documented structs  such as sync_inode_metadata(),
> remove_bdev(), shutdown(), report_error(), and fiemap().
> 
> Clarify inode allocation and destruction semantics, RCU requirements,
> inode eviction behavior, filesystem freezing, and block device
> removal handling.
> 
> Also fix outdated terminology, callback descriptions, and
> documentation references.
> 
> Signed-off-by: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

One nit below:
> +``fiemap``
> +	called by the VFS to report the physical or logical extent
					^^^ I'd just write here just
"the extent layout". Because it is both logical and physical, the details
somewhat depend on the filesystem and generally if someone is interested,
he should read fiemap.rst...

> +	layout of a file via the FIEMAP ioctl.
> +	More info in Documentation/filesystems/fiemap.rst.
> +

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

