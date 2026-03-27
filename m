Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE4810F284A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705566B009E; Fri, 27 Mar 2026 12:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA286B00A0; Fri, 27 Mar 2026 12:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D93B6B00A3; Fri, 27 Mar 2026 12:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 386356B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:27:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3465B7A9B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:27:05 +0000 (UTC)
X-FDA: 84592372452.27.1B7EA88
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9DF5620008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:27:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PWIRwc8r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="aHy7/HrQ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JdZTa2nF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4tn+bHEd;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628824; a=rsa-sha256;
	cv=none;
	b=uukHUNpcLav/oVpCSpvFjeCjXcJPoW75SQWKbMLtQ1J0NTAFB+umU6McHqwMW0oQaNwrmR
	OGDa+3BRU5rTiNli4fmjOV+9s5T4PfVqioU+ZszZCAs9oK3vvEmTS6O0d8Lt1xz3HNTApF
	CrLDyYVmis/hAUnyPoz2BugIBq4kIeU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PWIRwc8r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="aHy7/HrQ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JdZTa2nF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4tn+bHEd;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=OfCL3DwiuNADcr7dgzABANp8/hM+Xk0OhsmGdvxKMu+dLBH5FxWHS+bS02chUwNReSmYdU
	peCu/bRIhYdU8HYY+A9zPOVZCsuAedPihjJIrc+opB6Eh38MkbyDFdTmDkBF17ZQsUeDcL
	UB/E/V989chW4IdgIcEfUPMx6Wod1po=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E83785BDED;
	Fri, 27 Mar 2026 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774628822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=PWIRwc8rOn9Nb4fu2FlwjtSXS1qkXG0tjm/SzAXF8JeibADY9YCwpulSakhZ9HEai4VzWq
	RcLicvOGKKXUgTc+/f7Ly1MITdhSOlfzYOsT4udpnbmj+3ESJx75D9CmE9de75tAao8tLu
	0iojcawi6Be59m8CiJSr+pgwVrdYaxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774628822;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=aHy7/HrQ2QdAR4JQb/JErLh8xEBvQrwFvXxGaRsi+mCfX+f8aK+cDqc/cqOxstbbH/5D9u
	VP7Z3RP2uGuw0wAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774628821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=JdZTa2nFwYlx7Yz4v0Z1m4tXCmDoIzNzOJNW+8xEWeP8KwfAwRmuW6eBPI9Y4cuUjeAX/l
	tCv7i6kBMRuIOSP+jljGRT7CpbaFnd37x0zUwqg81DbBCJLnjPD9dXPI6iYvqnzSCXv4HD
	z7iMh9qWp9Db6GOOlplSxiGIi58kq90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774628821;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFjcJQasStRPcNI6PQK9qh0uIXtRvK1Btt+CTwCqo3A=;
	b=4tn+bHEdrwopjN6Dk8ZMfXdEshhQTlIfghPu9FONoDvawdc8IUbttoyLrGr2hyy1XwXLDI
	+SyoNvyVCOyLf9DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAEAD4A0A2;
	Fri, 27 Mar 2026 16:27:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3v5vNdWvxml5SgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Mar 2026 16:27:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9A9C2A0976; Fri, 27 Mar 2026 17:26:57 +0100 (CET)
Date: Fri, 27 Mar 2026 17:26:57 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 14/42] fs: Rename generic_file_fsync() to simple_fsync()
Message-ID: <szke56tw43bq2wyv3rai3akrewxbpclbj3finajrwtubkzbgbz@zgj7cc7h2sr2>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-56-jack@suse.cz>
 <acYiH4ByDc1-nPqD@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acYiH4ByDc1-nPqD@infradead.org>
X-Stat-Signature: 7bdp8ajytgsbgbraz3jqag3srseia41a
X-Rspamd-Queue-Id: 9DF5620008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774628823-397412
X-HE-Meta: U2FsdGVkX181W5aYXZoXpS047EulUT8EVFLZGGnJlSoGfQw0Fw+iwH3W1xrd2UedWefPLXRs258fishnfROtolDQ2MnUMvcVjxJflbWNvdQ6oWPai+R0UFp68d4ChTXpJ6x6PzpkGLShi2eSVBXT6RmqzTXtEr0mKlrtx+EIplGGCc/4tnElYAL8wsuN41ZXdk0nOnMGY/eD1aw7bHIpPOnqji2VHUczvM5YaJ1Y0Fn4cXikbYg1IJlGDULfPNaiwhf8UpcnJR3+xHPtj8OkNOqp+bXlz1OEFxfXf/vWNTZaQW+3JXcENCUPYqqVYmkRq4YxE13Dwazlc/IVzjLXYClhmO91SRDusU1Iu7rewaDrtD/I317MKOZtunrCBX+IFicDqVhkS0cGccJU3erl3qe8y11iFUfQoVsPO8jSBH2x4rfB9wojCkS9SFKO+86WTQ6AxMZictquk+q3uKyt5nJOlY/SBuG0metNc/wrhLYvieVOvQzFM7rUpbgN0GoNPq3sZNBTj7xRSjlNk5WgMsjBwOy8zmkrpghPrkpnjkPqVuoiI0rq8N7lIbxYZaEqWdNWyTQS6vLG0vFi3RjBCmWnyYO3jxN2pPF+yOUC79oxlg9fpBx/KY+Ld3eZCVvvm1eglbJLEBZq2Ho3ArO8mne3TmyZDu67v8obMJG6dnbn/3EZxEp2O6QSEBz971E2ddWd/WTvZY+95Vrm0IQr8DTeB5DKzHVI4qx7T1Zxt+7h0AC5j8TEuh4gc7yizja39vKQl0cBaEN2D61erAiRmbqvpdoVQL/5VN2/Xtw2gUY49WsN/GT6g0xITMMjt7XoxeuH+PFBgVw4nr9AodSOGk4Ri+sji8xzdcMHSPXFpdxCsPS/cfY9QH65DXi1WfZ+poYOzNA+ILDDxUvGGSTj5MRs1zVE9VYlJ3L4veCyOeUP6GKYUtHL5fTUtRPmZO9OtHPS9Tjk6M8DPpeyAx+
 6NQQPh99
 AbMn+k8BEz04FUAUNy8aA4B4sjUckAChphENolFo9gsEVwRXekq9BUGrknWaNWAKVUF8mwLkb22yKzRWlQFSJhX/GrGAW3aallibpWF3OsffIk8WpKtmL5K4bYUpejK1byubrFKeMXjicgoTbKgoyUKUMWlL5TzyFiW//6DlcPmXccQqxVwPiYgRR8IoAFB5Tt/calv1w+IUIrep2tBlN4Fl2EURnGFdLRIXuhrQAl4E+tw4Evn396CD342/KVEXzNnYs5qb2Nt9WaSbnAnEVR3HmE/vS8wJzgLz7eqNjnXBTt/Q35mTlAPZd3l55w/oVbq6pqtzUf64X5wrTSI17hzK/52v9P5JHTXPAbNsxLgzGhZezrPvG+94uWmWmM4FcP0H3is1pV50lmVznUfu/qDO+r1BZeEJGKv5Q2iGhFNgfGbnlFAec2zlv2CXfzksFXU8vO832OfcGip0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-03-26 23:22:23, Christoph Hellwig wrote:
> > -extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
> > -extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
> > +extern int simple_fsync_noflush(struct file *, loff_t, loff_t, int);
> > +extern int simple_fsync(struct file *, loff_t, loff_t, int);
> 
> Please drop the pointless externs, and maybe also add the parameter names
> when you touch it.
> 
> Otherwise looks good.

I believe Christian has a patch from Jeff in his tree cleaning up the whole
fs.h header in this way. Not sure how Christian ended up resolving the
conflict but we can clean this up after the merge window if some externs
are still left there.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

