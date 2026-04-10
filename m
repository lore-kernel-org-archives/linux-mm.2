Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9EBE99076
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BFA6B0099; Fri, 10 Apr 2026 06:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35766B009D; Fri, 10 Apr 2026 06:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BA16B009E; Fri, 10 Apr 2026 06:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D47CA6B0099
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:41:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E405B982F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:41:53 +0000 (UTC)
X-FDA: 84642305706.27.110604F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id EFEFE4000F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:41:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MAuboDUn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vtmoDNux;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MAuboDUn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vtmoDNux;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyzQ6B0JHT7gSiWrC1iUMZgxNFOYNLK1JBVUTUgNXLo=;
	b=7PaNtLJfhKl89hoICngkX7QJ07tqDhZ+fx++tTVBAVVtcMlUK/OfDfZR9BY53TdCWtTVTp
	9ssigTPd/hN047OdvybzyfnTZmlgL9TH4f0N0CDRV3O+WfbkkbyYkzh+uDYUDO5Kc7Ts9o
	6l8AUGXVRENE5Uz7Um1ONQhqA0RelhU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817711; a=rsa-sha256;
	cv=none;
	b=IwUJk/YuocH7CR7BpdP171S9+4/inTbZGGCdxbdjqqp3HkdI5RG8YqC+04SAzamErd+DJL
	ga1hq8yo78jynP9IbZvq09n2Xh0PhSR1/48uB2ldKyk0JjGppH30cJbLd1MFZLOPEmBuHL
	J2uxCuu4dUQJtXfIgvdcVCQ61Sowc9I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MAuboDUn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vtmoDNux;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MAuboDUn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vtmoDNux;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E2A76A7EC;
	Fri, 10 Apr 2026 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775817709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yyzQ6B0JHT7gSiWrC1iUMZgxNFOYNLK1JBVUTUgNXLo=;
	b=MAuboDUnRTvB1p5AvXQd7Ca/a5WeO79Wf5UIWAIi9ly28UBWX9cGVQrc8KS46aTdxhTfXX
	VzyamlIBHdkDvXInTk9Zr1FgQebeP0OHyXLheSxMc5KHtRTiElNDUUpVFEVQu4IpKe8lQc
	MM+jNJalYOIODafPdEpKHQw2erU39QA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775817709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yyzQ6B0JHT7gSiWrC1iUMZgxNFOYNLK1JBVUTUgNXLo=;
	b=vtmoDNuxdf0tOsRkhG44RJJGnBE4d5EyVq5TnJAbPLxhsSB2s8OXZJc3O4Hx+q+tdEejPZ
	6538q4HSX5cBqkDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775817709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yyzQ6B0JHT7gSiWrC1iUMZgxNFOYNLK1JBVUTUgNXLo=;
	b=MAuboDUnRTvB1p5AvXQd7Ca/a5WeO79Wf5UIWAIi9ly28UBWX9cGVQrc8KS46aTdxhTfXX
	VzyamlIBHdkDvXInTk9Zr1FgQebeP0OHyXLheSxMc5KHtRTiElNDUUpVFEVQu4IpKe8lQc
	MM+jNJalYOIODafPdEpKHQw2erU39QA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775817709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yyzQ6B0JHT7gSiWrC1iUMZgxNFOYNLK1JBVUTUgNXLo=;
	b=vtmoDNuxdf0tOsRkhG44RJJGnBE4d5EyVq5TnJAbPLxhsSB2s8OXZJc3O4Hx+q+tdEejPZ
	6538q4HSX5cBqkDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 124FA4A0B2;
	Fri, 10 Apr 2026 10:41:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W1JwBO3T2Gl0BwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Apr 2026 10:41:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CCE51A0A81; Fri, 10 Apr 2026 12:41:48 +0200 (CEST)
Date: Fri, 10 Apr 2026 12:41:48 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] mm: kick writeback flusher instead of inline
 flush for IOCB_DONTCACHE
Message-ID: <quptbqj7jfparfhrxt45cassborouvwggeqkwbk3ixyt74crb6@e7ivbuu5qlox>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
 <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
 <adc-Q1iDWHD5yxHH@infradead.org>
 <gpcc6t5unsoepakjdffsmnmd5duuvijxwdochd753ttix75h7l@nahwzi4qfdcq>
 <ade14lOI1CDiraar@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ade14lOI1CDiraar@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: EFEFE4000F
X-Stat-Signature: rpmy4x6y1eihub3y8ayk1m6s5yo48cme
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775817710-405686
X-HE-Meta: U2FsdGVkX1/FbFLOXQAswN4hwgNgvwtq3zQl1IRc/PxIbjzfZNtoGOKEOtqYBk4ZeTrWrelBKY117CUHEWZV5wOyMeULNZtdaWYEZSAWY1HbNJIV5miQZkx+FXQraftU1hyc7qxsd60UG0EEisDxxfc4LNRGnnSw31TaVFxBFlVydDIY68UYSV4soUqeywNfjYGM+MhrPIFtVXBEvAmxUpUSDeHFdxo+XNxYHGhLtBshT0AcJBVYEON+ro7dvBjn+GzdUTZ00wZRXR1GOiUyha8+HIEnEd2YfCx6BaOPCc6OCbY2DqX32FrQuZFoqkK8jkvm4q303mkyHgLRiwNrM7jh/CVe18Cl3Xwz53VPTU002sjZYPrxY3BIdnGf5b8V0qnV/QyhiKh/LRvGIEg3XdxbY8CPXyQfh+YN+YC4bkHrizZD/gLKsymL8MWsb2IC5B1sgi41NXaGENsyU1/SGqB4G4BQdIufJKlrMroQAe7pCVzcAxLk5wTpxlRHWJEE5lg8XzY3U8zvaJaFw3WxrxGXx4eNoEewwO/Dvd9XBcAXEfsy4b18kHPiQ0TqgFfJQ6NXXj85/jcWzCghUY6eswQASMqJa5jkWPDCVHuaLyVLSZv2dmwHprGTtUczof42Exl2CIlOe1qd7yfdqMNcfq21jWJx4/bAR8bCyiLFIB7wMqWtQbhcgupFFxNoCJpDYQJ0Tfvl8zzG4HPQxh6rs0wrgBnClh5CyvgHG0aGLSTQO4vjYBTwqpT4NSd/28wWcwWlhBOzDTW2SQGDLchDzuT8jfKNtWgz0WzcC2wrbh6PtCe31oKtQT2VMnn84M6CndygM0f5db6/DxQRITjcN87n6np5FmElCBt/aiepHIHQr+IwOEmQQ4vMmVkLoOcYIZxXlOnPjdUinilBtIEaOhAEq/LSj5ynQEP9pYeBgf2nLFRykMrNpH60jETS5FxReUFTUDFXSXDdtsLdoZW
 yCjmdU07
 Br0k4qmBzbT4qxHiIBdsbzcCWsoZO0D1/I+dAf4XM+90A+ULfweHzZzQsTI/koPfdsgK+34PL31xmyg3pgBY1XIpmoblcGlHhqhexi9KisKEKaqIPghzdHgqE7+WCyoXsQVP/S0heCAhuc5cyeXTJCKROQN3gAguBaruv+AmZMuuu6K7X68bj98741Vwt5xvmJzLfzdn663GtYicUNJAv/exDArIwPGWVVJvtHcUGW5X9iwfxQRCPTcTkEsaqbKxAQfFKvk4twV0EOVs+yJqSzT4svcYfvzIzN/0kUpdV8G8k0Bmkm115B4gevzjszWplSJPD8QyScGTYcqNVhzeebABulcI2WZ4fXZfIgr6zUPgGj8HfIpCdduFYnsCbTU/rN8fACrIWdJME2qI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 07:21:22, Christoph Hellwig wrote:
> On Thu, Apr 09, 2026 at 09:21:36AM +0200, Jan Kara wrote:
> > > So I think you'll want a new WB_start_dontcache bit, a new
> > > get_nr_dontcache_pages() helper on a new node counter, etc.
> > 
> > But I'm not sure how you imagine this would work without restricting
> > writeback to particular inodes. Maybe we could mark inodes which have
> > folios with dropbehind set and make flush worker only write such inodes?
> 
> I'd only expedite writing by the number of pending dontcache folios.
> It would still write the least recently dirtied inodes.

So that may result in dontcache folios staying cached for quite some time
if DONTCACHE and normal writes are mixed. But I agree over longer time it
might just level out so maybe that's fine.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

