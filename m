Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE78EA4FBA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E946B008A; Mon, 23 Feb 2026 08:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3698C6B008C; Mon, 23 Feb 2026 08:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241F36B0092; Mon, 23 Feb 2026 08:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106D06B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:02:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B876F1B474F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:02:56 +0000 (UTC)
X-FDA: 84475736352.13.B5B09CB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B51212000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:02:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnKlAEtZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuz5TVcS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnKlAEtZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuz5TVcS;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771851774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVEJ1r6FOlyG4Cpi7q1mYna0gup2PMjct/OLJuDuu38=;
	b=AP5uHf8DFhgEDUO3Fa8xAKpU9XQE2UdD2u5D1hAMKOSFJ+uKq92Bu4WdPY1sTPrHznRYR3
	9skSM1awWrQWaRNX5EbRXYJIVloWmwGslJk/+7M42vzWP3PrCVLwcJ3XWEiuCbRxVoTbxE
	4PRd5j0XM181lDMo8FjtSUvJxgu6kvE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnKlAEtZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuz5TVcS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnKlAEtZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuz5TVcS;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771851774; a=rsa-sha256;
	cv=none;
	b=7VXp4gzdxl03mRl1UabGoKBuIiME0r7QBT+959Q14r4l8vuMvDU2G7dmQjpD69RjHAGDeQ
	019CswtGCb5a2Olyny6MI9VLhuNbc9hzl2u3MwnvvUTbkoSysro8OR5o2cJqToJaxFM2nj
	sujs5+FawFl6BQCO++Ug1ZY/2KVuoVc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 94B135BD1A;
	Mon, 23 Feb 2026 13:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771851772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVEJ1r6FOlyG4Cpi7q1mYna0gup2PMjct/OLJuDuu38=;
	b=pnKlAEtZgmUOCttcp4oSzoCnKnvhyCPS2971xlB0knZzxkDguYRY8/gEQ5eB/ogtbshMeS
	GMw+kDe2KCrRartxRphHGpvb//VBzHQZHCUwZcdh9bhXK5xjxTH9hywtryB3WoXfBsGgrg
	VLRZsDarRzf15cMmHxIwMHpLJ0f7ZfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771851772;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVEJ1r6FOlyG4Cpi7q1mYna0gup2PMjct/OLJuDuu38=;
	b=vuz5TVcSot9WTr9zKNiQ17wzfzc2NyL1HiKWDnvLl224g4ClWijW6Zc7AG0DZN09lfiWig
	doXIGXstrhcp9YCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771851772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVEJ1r6FOlyG4Cpi7q1mYna0gup2PMjct/OLJuDuu38=;
	b=pnKlAEtZgmUOCttcp4oSzoCnKnvhyCPS2971xlB0knZzxkDguYRY8/gEQ5eB/ogtbshMeS
	GMw+kDe2KCrRartxRphHGpvb//VBzHQZHCUwZcdh9bhXK5xjxTH9hywtryB3WoXfBsGgrg
	VLRZsDarRzf15cMmHxIwMHpLJ0f7ZfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771851772;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVEJ1r6FOlyG4Cpi7q1mYna0gup2PMjct/OLJuDuu38=;
	b=vuz5TVcSot9WTr9zKNiQ17wzfzc2NyL1HiKWDnvLl224g4ClWijW6Zc7AG0DZN09lfiWig
	doXIGXstrhcp9YCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 819D53EA68;
	Mon, 23 Feb 2026 13:02:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id clmgH/xPnGnCDgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Feb 2026 13:02:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4D487A0A4A; Mon, 23 Feb 2026 14:02:52 +0100 (CET)
Date: Mon, 23 Feb 2026 14:02:52 +0100
From: Jan Kara <jack@suse.cz>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Dev Jain <dev.jain@arm.com>, 
	lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com, catalin.marinas@arm.com, will@kernel.org, 
	ardb@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Per-process page size
Message-ID: <pqwem5hownnfwcqrubksdwwraqbkthpzucknhavrghmw5lyszs@vdorbx4fyyaf>
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
 <2e68ef61-dcf2-46b2-913f-14980a104faf@kernel.org>
 <aZfn0tbKl_1JD-VM@casper.infradead.org>
 <5f61a5fd-ab38-4635-aab8-5de515c4015a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f61a5fd-ab38-4635-aab8-5de515c4015a@kernel.org>
X-Stat-Signature: 6cz5cw3oc9otryx8h3m5u8w4zyzh3az3
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B51212000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771851774-828847
X-HE-Meta: U2FsdGVkX1/541WOgp4BEhbzEnsqJjxFzRvGsd5eRPQKCgbLkAuXuYH220nK3ZjsfS8jG7hEFFosrfVqQTQ52jsI3/UVih0rrlTC4jqoUPvCKjTjx4grf6pWFQVjkt8SfVtRMI2klsRAr78A1Gxqylp7YCrx/G2f4gUhql6Gsd0BWGo7SNkA4KLPHgqGD2oVquHLBUwasJxG3P9UJVPL1/Av+Wl2pJ7KvHazwRICFuW6i2tbpvovkaC5nA0wiDe9p/NIzEz//dTUHP9G4qH+11xa3oUzgAzCUZGf3hFpoIM4/vMKeSMYtr9YYq7fn0hClRSgfNMltSGjtwaTHOK6tK7KgDHgHcr+NOnS7oXx8pBHYFFpa2/uGeBYaxFoEA5b4df6+XbfmBUOU6H9rKJNZV1MhUcCYbYbmTFBRnnbPndTjUrBMW67tSkC2x5hyiB3tMP0LxHFmKGZWAmDGMCzu5eyo4c8ecU8KmBhFZhUpiSZ4V82PkXblqcJGncI6WlWxXp/z3MJJGuBlFKIf4j2gjxmPYF5a5dmOpXNcJ61fW28Eg1GJ6s6DGyNJsVVf/gjpc43cLiZrlTXbMFuXjBPZBU+TvoChqYGJik3Js4/pPaypId4itl55HhDtVb5OhstcvxDoYh2R2/Jb8HtuPnkzp65fYPbAVEfGZB1MhNa+Wef45GaHvWXVFOLixKW5mc8VMCgVWBITC3/EZZ8U7sX5qR8lFWRknrAh+GvbH78vJXgAFze6+ZKoyA9BD403LmL63Mg642GOvLslFUBIp+zerEVH1pnI7fswm3kgIbbB18jqcnmhV8CimFeROb7gxjUKbdhPAWEzYQj9fqD+ddW8wIBoOe+O9ZoJ1nBta2f+XVjYzIYdcFDd2XI7vXSgJA4/jqdEzB6CFWPYDAWlyPfuDQUxFiFC31ziCVUjjxktE47UfqlwVFTtFaRf0iJH3rZ9FsHhm6879KNJfmCNbT
 2mE8zVzF
 p1ZgJH2U0Ui7n6+NB7DWC4gRBrc+30eK4Mwvf7tf63q/PEyDZutxP6/Jm0o86L+f255EhUXO7jz/a6edweNmYXsa3WJB8bCDqu1iVpGsEAXFKjbjTjcbN4Z3NCzl/uK+Gjggg+lGF+RmH3Y5OBzlaOZUWM3eT07TyIHnGyKRALOx4oXoMdUQkkL1ZXpL5oW74zawnRF5Jf96Jiy8InIsVN2zEzAPoss7K70dKs7STin86jGGolOdmOFyyDJ7ZzHhXTogTc7fDIU6La9p5k4Jf6Ra1hBn2H9dRaSzjhLzhJ6t7vBwR8tHPjcK0xGCS2vNwf489whbaWmLbFD4sjC6W6+z94Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 20-02-26 17:50:44, David Hildenbrand (Arm) via Lsf-pc wrote:
> On 2/20/26 05:49, Matthew Wilcox wrote:
> > And if no pages from the file have been mmaped yet, they cannot be pinned
> > or mlocked.
> 
> Is there some other way for someone to block a page from getting evicted
> from the pagecache?
> 
> We have this memfd_pin_folios() thing, but I don't think we have something
> comparable for ordinary pagecache files.
> 
> ... putting them into a pipe and never reading from the pipe maybe (I assume
> that's what splice() does, but not sure if it actually places the pages in
> there or whether it creates a copy first)?

Standard splice copies data first (it's using standard IO callbacks such as
->read_iter) so that doesn't pin page cache AFAICT. Only vmsplice(2) does
but that requires mmap.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

