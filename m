Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0E1C47BF2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25386B0095; Tue,  6 Jan 2026 08:55:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA90C6B0096; Tue,  6 Jan 2026 08:55:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A2C6B0098; Tue,  6 Jan 2026 08:55:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87D816B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:55:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48B5554F10
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:55:20 +0000 (UTC)
X-FDA: 84301686000.20.61241FE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86114180002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:55:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tcyMBuWX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3c8YBN/6";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tcyMBuWX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3c8YBN/6";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767707718; a=rsa-sha256;
	cv=none;
	b=NAC5+NGCxJ44FisyVtPLDGYhC8GqVmDcG2AgFixFq+gZFB66GKrTjskTHw1Y7ADhYZNI2Y
	YLv+lyXUS7wP0U/Z+pMjLhw/anIikPXL/dz5H0NUlhel9WYvrYR6Bp5yWbRS5ruvH7vWMr
	5JgeHRH1qMiYJC2HUPThkmjXRpbRW8w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tcyMBuWX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3c8YBN/6";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tcyMBuWX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3c8YBN/6";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767707718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIw/7iDeeJQUH5x9q+0fNCZ0Q/TnxQ1hJVUlKln0ZLo=;
	b=xof5NCLcoqU2S3X/X8urdZvrDcCZ13+nRYsZnLYqG+Fn5zhsjFh9iLStM6nIUdRSbxcYCI
	a3hnJl1TIdbupw1VZ3MBlitC99M2uzWQXHLTgb4ha26lBL+p8khKJsdph93edetc2W1Ty3
	gVUiZLJFjr8/jL7usCAIb6KQjOYSJwY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8BE025BCC5;
	Tue,  6 Jan 2026 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767707715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cIw/7iDeeJQUH5x9q+0fNCZ0Q/TnxQ1hJVUlKln0ZLo=;
	b=tcyMBuWX8hWQv13z3LUyYQsD86Ilvc4Aao09HiB970jJvieceja9F88yvaCWrCOdIjAdSa
	bnCf/ODiRyGzInZmO/Fb9x/Qig6pgqV8IdYMYN6OQ73K5tdLq6t66HDa6Cmd7gKRHgTIfQ
	EctBigC6IgsXHIBrg0BC3T7zMLTp+eI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767707715;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cIw/7iDeeJQUH5x9q+0fNCZ0Q/TnxQ1hJVUlKln0ZLo=;
	b=3c8YBN/6rkpH9JqdIaUJbAaz+qzM51ymmHCezSjUOCSCBnPivoV2qkyXTuCdqSg6Sod22l
	Sr6H8uVOBR64EbDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767707715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cIw/7iDeeJQUH5x9q+0fNCZ0Q/TnxQ1hJVUlKln0ZLo=;
	b=tcyMBuWX8hWQv13z3LUyYQsD86Ilvc4Aao09HiB970jJvieceja9F88yvaCWrCOdIjAdSa
	bnCf/ODiRyGzInZmO/Fb9x/Qig6pgqV8IdYMYN6OQ73K5tdLq6t66HDa6Cmd7gKRHgTIfQ
	EctBigC6IgsXHIBrg0BC3T7zMLTp+eI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767707715;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cIw/7iDeeJQUH5x9q+0fNCZ0Q/TnxQ1hJVUlKln0ZLo=;
	b=3c8YBN/6rkpH9JqdIaUJbAaz+qzM51ymmHCezSjUOCSCBnPivoV2qkyXTuCdqSg6Sod22l
	Sr6H8uVOBR64EbDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 818C33EA63;
	Tue,  6 Jan 2026 13:55:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6XibH0MUXWnCVQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 06 Jan 2026 13:55:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2B8BEA0A4F; Tue,  6 Jan 2026 14:55:15 +0100 (CET)
Date: Tue, 6 Jan 2026 14:55:15 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, 
	carnil@debian.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
Message-ID: <pwq7yurznml7m73zge7zwp7sphdz4h54ulzwqrvvad2dl63wjx@y6xfnb7uzmoj>
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
 <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org>
 <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 86114180002
X-Rspamd-Server: rspam03
X-Stat-Signature: tkpmwpiuhhk1wkj5rch6cwjz5wmghfkp
X-Rspam-User: 
X-HE-Tag: 1767707717-119986
X-HE-Meta: U2FsdGVkX19Y6B5io02/5Dh4GSsOY57R0u9ZoulJ3JMxbqqIAKh4fDnvmairyHe+40rWSL0aA1CsPI5c7fq7tMYX2ZZxaogybCVS5Xt6s8d/9x0/s2p8Y4/LEGgslZPCAhBW95tEl7/zbLCGthCCmNkouptNJNvkl+U0O+Jkwxo85qFtIofPai3a0GMelAF0jVK2Kup3MHKXbzTZmLyzaw6X2shA2LU7VOfwYVEaAnBeoX+OYylVg/3PKuHzxaJy8cvfyAxPaJ3UbK9OuURV78SBNryfT+XLdTiVzOxAaN2mIIjg1B2YETG7aEYzZUQQfGlabWiAeZXzMd4j9+7gKe/zT1fe8eUKxcflnNKroTRsfDt3E+ATDtRCSHblvFYs3jHzjRrCmhlZ/t0buj49JfY25G6rQfqN2GrEyzK+kP5K1Pvx4bEzzME/lwsnouiZsJYGRZU7K010pvVyS1O9fo4VUoizGeDNGsV/C59+WFhKKXP3RaQ+8sL3UbqL6APkyGxenXYkbnm07erm9KXOnBiIZwQ3Fkn4ajujsMF52sXrtwPdDsDaMJpKcq/EAlumlx/YaO9uViL8sMhxn1PaIfaAmq75UqBx7EltOay0FqpFVh7T0EPAntFPFGrAh1mc1jmm9T+2EY60JW/dtzBoSPFVdYoj+Ia82GICCSV/zTStyCdFdr2FuEXBgLalB8ReoQyue7r3NFIU4COqlN5Cekv020nqrVTmxpoCMOzUTAoX6rpp3xDKxXE7+d+AE0o91tdKL0WIIku7vo0QwQzRHNMkaOiIOAH4Oiig0UignUYPg2FKd3+tIEBK/HU6trUhuxB3T3B6OwZJKYr071/tRGGA+YmIy+1fLYP5C+mkSiWNa3R7N9kcIZjLzRDRKGiNafd78dpjTyQ93J5EjdB9neG8ZOWRVaA+XYhKV7a4ryPQQhpZ50/bWzuvEOyU46BOfVgcXSwANx1Ggu+lyVE
 kOP9j2H8
 ChYPDkTkTM8kx6e2dhyJ5TOijpNkbDpt6ckFoFD1LkiIBZtmAVSlnmz7VXPrRH7IuXxQtSEKGhHrnrlfe1qGKQ/2Lzv3mkjlwfvt2UYXRbzkXJqBNkyaL/L6ZenoyZNznMCThXslq80rp8jw7MF3faNh6xDE2b9ojGHcDQmyXnmv7xdG6+F4nRRcLu1grKgNVuKV2dKxkwVrDqRaEDSUXL+wqjZVD5CLMy01VO3LnySc8zG0lA4s0WhBeZip2QtR/qp+DK/LamgPNNMliplJZZBweSysNAXTBllCG/J8qSyMhAoUY2t1n29G8xRlORwxzcyWHTGNCh6AlDZlvFRcSbSZf6EKYz9aC4O7l/U+MhObVPOc+6fAhFceNjSstPCVgB28dfslT/R/riIRh2CZt0anln4qwrvxhWJeU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 14:13:55, Miklos Szeredi wrote:
> On Tue, 6 Jan 2026 at 11:05, David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
> 
> > > So I understand your patch fixes the regression with suspend blocking but I
> > > don't have a high confidence we are not just starting a whack-a-mole game
> 
> Joanne did a thorough analysis, so I still have hope.  Missing a case
> in such a complex thing is not unexpected.
> 
> > Yes, I think so, and I think it is [1] not even only limited to
> > writeback [2].
> 
> You are referring to DoS against compaction?
> 
> It is a much more benign issue, since compaction will just skip locked
> pages, AFAIU (wasn't always so:
> https://lore.kernel.org/all/1288817005.4235.11393.camel@nimitz/).
> 
> Not saying it shouldn't be fixed, but it should be a separate discussion.
> 
> > To handle the bigger picture (I raised another problematic instance in
> > [4]): I don't know how to handle that without properly fixing fuse. Fuse
> > folks should really invest some time to solve this problem for good.
> 
> Fixing it generically in fuse would necessarily involve bringing back
> some sort of temp buffer.  The performance penalty could be minimized,
> but complexity is what really hurts.
> 
> Maybe doing whack-a-mole results in less mess overall :-/

OK, I was wondering about the bigger picture and now I see there's none :)
I can live with this workaround for now as its blast radius is relatively
small and we can see if some other practical issues appear in the future
(in which case I'll probably push for a more systemic solution).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

