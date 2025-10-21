Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88C2CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 08:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0146B8E0015; Tue, 21 Oct 2025 04:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E698E0002; Tue, 21 Oct 2025 04:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E441D8E0015; Tue, 21 Oct 2025 04:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D13E68E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:27:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 829E91A0403
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:27:13 +0000 (UTC)
X-FDA: 84021441546.08.213FCE1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 28267180005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:27:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vIz7QdwR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A8eT9kKK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qAc/bZaK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="mZ/rHkbv";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761035231; a=rsa-sha256;
	cv=none;
	b=3UiEYcP53rXzGPJgSsaxEtoM9aVfu4e+smgdqR/PIta6l9jqNXDj48tTMKYJLyuF3eAaEw
	126JRn2+rzbTE2ydyFplJt2dqrVPmg/3A+yfkrCNysXwJOBU9L4Amrkqfpsc6io+tHvHIr
	ngkSqjjKobtV4KhYK7yTeq9aClcOvlA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vIz7QdwR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A8eT9kKK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qAc/bZaK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="mZ/rHkbv";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761035231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eM5uKYPimXpUkghvLJUuBzWoqYrQThF+Lr3Lf5X1p8k=;
	b=XqxBNh+lf/CmC+ueXHPfBmmjy1JivoDEqrRfBjgjUwpUfyhQPbjtjnNyt/9Wac9xiOgeS2
	PMu8GM6IXBOOU9wmecGMcRaVAFco6bng/Fr9yqZF6jdRxmsEq4JBKA5Nq0uQlr5Pr+4V+x
	B4TVzIUOX1fBpxwD+5JHm3ZAOMvvWTE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 681D21F385;
	Tue, 21 Oct 2025 08:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761035225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eM5uKYPimXpUkghvLJUuBzWoqYrQThF+Lr3Lf5X1p8k=;
	b=vIz7QdwR2CK91QXv7Z1+jCI25tUZbdFr6z5NvW5nXkoM9HO5rUzhr9ZgaTAqkysB8bXQjj
	XHlNAtm2P3wLDAdc4BV6h1OApsO++COo+o4vfSmjgBniNrYblZZNy1RU6EIhdB1OEqCRTw
	Y7fX5Gp96b9ZFuLShDNim0Xp9n5XvOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761035225;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eM5uKYPimXpUkghvLJUuBzWoqYrQThF+Lr3Lf5X1p8k=;
	b=A8eT9kKKnUSxIRKGY3rHEZh7CeTywonbwaIsHvaKMXV9kBDL2pRNM3wXin2DwKEfEma7QM
	UqHZmiuoc3zLHZCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761035221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eM5uKYPimXpUkghvLJUuBzWoqYrQThF+Lr3Lf5X1p8k=;
	b=qAc/bZaKzNTb2nkIpj7xU1vZRYyHMoUdIqZgAtOK8zm6z1cE1t4NPCs8Z3KPIkZoHSvWvU
	X5W+34sxNWWUouNwAd6h8Moxjym+kkJIxHcqicgd22VEcwKN0b/suJ2AJs1LDNfuZjjDUc
	h5vj3J3/Np9RJo4CL7ODWqVLSpd1DO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761035221;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eM5uKYPimXpUkghvLJUuBzWoqYrQThF+Lr3Lf5X1p8k=;
	b=mZ/rHkbvmvLqRgVFbdD1Zw0Wd0XaI6+DAJ/IDtl4G/ECbTVa26bHdr+t/uvcOf9CRYAvie
	k1/xY+sUURIfzAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59FA2139B1;
	Tue, 21 Oct 2025 08:27:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZZbxFdVD92giDQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Oct 2025 08:27:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F386BA0990; Tue, 21 Oct 2025 10:27:00 +0200 (CEST)
Date: Tue, 21 Oct 2025 10:27:00 +0200
From: Jan Kara <jack@suse.cz>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	djwong@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <6hedspdzoxjtdim7nruoeh5m4mx3xecubf7einzl67jzjmi3er@o54b7v5njwk5>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <a1cffdbd-ba98-4e24-bbb6-298eba40a11e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1cffdbd-ba98-4e24-bbb6-298eba40a11e@nvidia.com>
X-Rspamd-Action: no action
X-Stat-Signature: yypd7kdf4pnekj39u4ckrjaca9pq1db9
X-Rspamd-Queue-Id: 28267180005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761035230-38533
X-HE-Meta: U2FsdGVkX1+34pEMQq0XRgdy07yE+vl252oCVGhclPly26WNbFGDIbTvhK+yjYLbUvnX2R3N+FvQz8yFELMvF5G33dDwF+28a9HwdMCbwp5dEi/rdXaieIb0aR4eYL0mSrSvmteOy7Pfo4U/3uCdvHLeux/NF3LZy9amKt0/9ayPoSSNKgCvviBe2s2fgeJkq/qJFo0CF6i3s4ySPqvyHFsFZ1L0B7w4c3xXKfhyXBgmYD5OoUOJ3NoGhSYrgTcP3zIukg845nSmSVx82WoW6UQ9UY+rgLMoI9ee+mRgmZc+38mKti2u6EdGR/yinmo5834wDZN550y9+CQFqhKfy9sgG7QPEtLapFOdxATSmRgQCzG6f+F73s7jPsGIhuOe1ZcxtDM5RqbJjVVY8tcvHkotfU5aWwycSrWSu/bGTMX97YPrPeT46vip6IAIIeYB9k+fOimTGeoI66J5yIslw+XRA5iKerdJv4bjerph/g6p3CHdqBTn59I5wbi3wJVAdNNvAeKxanbZOrpbND3PbWTTPIg1BydpQvtH1TL5aRrxP7XB3tuxaP0McYdSUMAjqMQ3G0Gub+7Id++b7s4ssJE6ZH0kXjGq/kPx1g1vH24a1Jp2XPgk43SFXsDlm20Vk4dZ5cR5hhlf6Pg4SD0pla47+pSP8HLS8RrKqjqhaF9Z5Xn5suv7HkXGLieC1US1s7u9qvY8DWsg4JkYgVYzk595UnMQtYsDBK2qhUvLWFsYi59Cjn36bzXdFX4CS3lxL5+K2gOu5B+8BAx5bVJ9YiCMmlJuU7JBsjwOT7P194aBTipnLRQZV9BgI9sFUEAgIIZjNIWn5HKNGbObTHAZ88cCP7G+0kdZX8meMA1LliWPwekfqd2zIlU8FoY0LFMXMTKZxH7PIn5FraFsoVfbvtbdj/a7kSe1AO5WCbB3XmCjcRUTHUxObhaCuxjGGv+1/G+yysvURcX2FIRza3z
 vYIFklv4
 khPFaJGPZ35iz4oOo5qFMrgb/Z0S4vork3tat408Pfdu/zAMfjSw3X5ZHN+3+/36M6FJl4tezAMDMh2lYdOP/PqCc4UGb4TSXdtZ57+Pzeeq3aACrpy8aPEmdtVdRD1o2GLoQosbJK88CiCOxvSMWcXi0CDkhGRof0sXurL3/liV6BzQTti0qYzcI/1ucdfTpZ13lpG2sVVV4Au+8qB6hItcdv6Wnvn68dzVxA4Jj3QQFpdXUj/4hjimxKOYlcXNbMkL6oirMXjFKG5svO5Fc3jnFuIQtJvrX8xEjGhrRJLVVLsw0v6Ac9dXb4QTTLmmLltVgEMuBm74ODywkUqO0rk31RtpDMckUbDyJUl9xOX8KHAGKOyYVDB/UV61inhoktScx1WA83ospR0E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 20-10-25 10:55:06, John Hubbard wrote:
> On 10/20/25 8:58 AM, Jan Kara wrote:
> > On Mon 20-10-25 15:59:07, Matthew Wilcox wrote:
> > > On Mon, Oct 20, 2025 at 03:59:33PM +0200, Jan Kara wrote:
> > > > The idea was to bounce buffer the page we are writing back in case we spot
> > > > a long-term pin we cannot just wait for - hence bouncing should be rare.
> > > > But in this more general setting it is challenging to not bounce buffer for
> > > > every IO (in which case you'd be basically at performance of RWF_DONTCACHE
> > > > IO or perhaps worse so why bother?). Essentially if you hand out the real
> > > > page underlying the buffer for the IO, all other attemps to do IO to that
> > > > page have to block - bouncing is no longer an option because even with
> > > > bouncing the second IO we could still corrupt data of the first IO once we
> > > > copy to the final buffer. And if we'd block waiting for the first IO to
> > > > complete, userspace could construct deadlock cycles - like racing IO to
> > > > pages A, B with IO to pages B, A. So far I'm not sure about a sane way out
> > > > of this...
> > > 
> > > There isn't one.  We might have DMA-mapped this page earlier, and so a
> > > device could write to it at any time.  Even if we remove PTE write
> > > permissions ...
> > 
> > True but writes through DMA to the page are guarded by holding a page pin
> > these days so we could in theory block getting another page pin or mapping
> 
> Do you mean, "setting up to do DMA is guarded by holding a FOLL_LONGTERM
> page pin"? Or something else (that's new to me)?

I meant to say that users that end up setting up DMA to a page also hold a
page pin (either longterm for RDMA and similar users or shortterm for
direct IO). Do you disagree?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

