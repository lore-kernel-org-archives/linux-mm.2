Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803FECA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 12:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56128E0015; Fri,  5 Sep 2025 08:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06768E0001; Fri,  5 Sep 2025 08:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF54B8E0015; Fri,  5 Sep 2025 08:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB7DF8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:50:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1586BB698E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:50:39 +0000 (UTC)
X-FDA: 83855180598.09.B7DD740
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id AB6B7180010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:50:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wYssWw15;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GOKncyyN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wYssWw15;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GOKncyyN;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757076637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pi3KQaJbyoNPQY1v66CGkX0xH4AblgnUiTzltu1PAo4=;
	b=BNs1CwJDMv5IO02mYtZXWzShGalaXoGvwM1UlQYPyw5lwA6iioJwf5D/TkfZ2JAtqbzZ21
	wrOVOBunXejzJtt5RUFNm0lLtlbWd1/5e02LBC7PW5W1dS0U5zCS5RC3LiRI7HyeW9a7A/
	dBJm2nZasczAqjwcSxfMZNJlxha74jU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wYssWw15;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GOKncyyN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wYssWw15;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GOKncyyN;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757076637; a=rsa-sha256;
	cv=none;
	b=7Qfx/LqhnZd7TRddS6f+NJT2vAcLKN7Q9ehAR4c5s7fRXGdTQ1hCzYVDk8GmEphrqAIeQe
	DS3GqhVrDEDAqaTDiOI6RJ1eM5lYBJrDS4SO4RQSZXWSuzzqjNyXrhBxFf9wku9ZCZhgxz
	B4puqNFlZqvlkTSFcjbagNqhWWzLMf8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 98D6C5353;
	Fri,  5 Sep 2025 12:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757076634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pi3KQaJbyoNPQY1v66CGkX0xH4AblgnUiTzltu1PAo4=;
	b=wYssWw15OmYErtbM6EH0YruZj8LCHa+nEw2/t6Pw3/Y2Gj3zzp0g2iqnaFLKfCpQMtWAvS
	kjjXbcc6kEUsbqCRw8r/KU/npRQLplmRdSGAd5XtuXMKpyxBSEXh+y/GcWdxbeCjd0CFfb
	8P9lrTkw57w/ti3qAMe4yBJmrM5w33U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757076634;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pi3KQaJbyoNPQY1v66CGkX0xH4AblgnUiTzltu1PAo4=;
	b=GOKncyyNup75bLtMDmNHAuBofvQGgFzgZ0rGeR6+O6k9y7RGISH188pVFCtd/g1j60OjPf
	IXM240S77uuxc7DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757076634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pi3KQaJbyoNPQY1v66CGkX0xH4AblgnUiTzltu1PAo4=;
	b=wYssWw15OmYErtbM6EH0YruZj8LCHa+nEw2/t6Pw3/Y2Gj3zzp0g2iqnaFLKfCpQMtWAvS
	kjjXbcc6kEUsbqCRw8r/KU/npRQLplmRdSGAd5XtuXMKpyxBSEXh+y/GcWdxbeCjd0CFfb
	8P9lrTkw57w/ti3qAMe4yBJmrM5w33U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757076634;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pi3KQaJbyoNPQY1v66CGkX0xH4AblgnUiTzltu1PAo4=;
	b=GOKncyyNup75bLtMDmNHAuBofvQGgFzgZ0rGeR6+O6k9y7RGISH188pVFCtd/g1j60OjPf
	IXM240S77uuxc7DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 87AF813306;
	Fri,  5 Sep 2025 12:50:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8vAbIZrcumh6aQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 05 Sep 2025 12:50:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E3F54A0A48; Fri,  5 Sep 2025 14:50:25 +0200 (CEST)
Date: Fri, 5 Sep 2025 14:50:25 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Youling Tang <youling.tang@linux.dev>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, chizhiling@163.com, Youling Tang <tangyouling@kylinos.cn>, 
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH] mm/filemap: Align last_index to folio size
Message-ID: <bv4t7a6boxh4dmjl7zsmhd74wm5hyfpdivypmrqerlpn23betz@tw52mlf4xf3s>
References: <20250711055509.91587-1-youling.tang@linux.dev>
 <jk3sbqrkfmtvrzgant74jfm2n3yn6hzd7tefjhjys42yt2trnp@avx5stdnkfsc>
 <afff8170-eed3-4c5c-8cc7-1595ccd32052@linux.dev>
 <20250903155046.bd82ae87ab9d30fe32ace2a6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903155046.bd82ae87ab9d30fe32ace2a6@linux-foundation.org>
X-Rspamd-Action: no action
X-Stat-Signature: uwdjp4pt6eyqa1b1oprd3t98nkcfzmn7
X-Rspam-User: 
X-Rspamd-Queue-Id: AB6B7180010
X-Rspamd-Server: rspam05
X-HE-Tag: 1757076636-178446
X-HE-Meta: U2FsdGVkX1+cIEqA1cMPCIJN41D/f7FJe8gKp/RF1RBYlJOmS89fHGXf06g/PGSZk2O/xKGDxKsI9BBrsq7HYAK5M0dptnT3ONMr2DWuGpYEV63CESv+8rbOqf3Op+SLSAiH48u7dRGyYGS90BN3MOETTpxwxlD19OZLGDDwPb2u7gmfAoAs/2v+XqFGdzVOPeU0Sss4kQQpuTGfq7oI8VsIlWiqjiCj+GsepBRc2GTObuXeoQmmdvnFmWdeLMMvYy9aKUxq/HVzCbzycLuId5MzFgE3q8oJh4smdqd3l5dpYS55+jHEWZizL7X3BjaflxE57Lv3lvFMWvrKfD8fggD28wLbQxKLlylZJPqfF33gzv4eno2cULcyXFcJwzPDtGBDR3I8V/TPWyGGAYPmdUwZ7PN+pcSK5KeWIdjQkEmYhVC0pU0jAOUVkcIS2Lz79A75G7ixsCmiqjAuvhlRnzepOMaWJLfgXlko+Mpp/QIAqP3Tuxzn9BONbiRGOMy20/7SfeiTadJ2e3iNmwXjGnQh8dmZszzqcK5UeCnGt18EOwPNvpbjnOvx1r368y9eXdj1MsyJcbMZhy/wO41KxsJXwZDhZtnKTNmfZEuSENoldPEKdFzzCFSEN3v61d6XJGUzyCpQoU8M801nTM/Kt2+8Wnvd/+VsvYbPc/W6r5cG5Eu10kYextSmLhAFHmL1G/fllPwsg3DulcPRbi3MrkOS7RsXWa2NxCdO7yBC0UqIUN3prgCqNps635jKuw+vv5uvQ+s+IARgTlC+Vu+hREYQXVqaPkNm1RWEDjZnmM3gEMckrhxDARTzlhaI8/xR38C7GCTimDrrxHbGAJ2D8Mr1MsGagRp0ddZEZm3ql5Xiy1Z5+yN8FdLiRmTKWfQFomUCl0mgiaa9VC8CiuPumw4vabwlqeNo2tycshgHXuGqmse8x4B4Xrr6lWOuX2k1PAI6YfmjFvGEgnc2Sgd
 zrGtvpqN
 4rnzaqnbBjs+pLAPwiH4it8aUYlZWJFFkr3MCX5kqiXsAykeOCmdaNcjUzAwK47uzqsRcnrZ6mM9UXZpsV4xARRQYardg49p9sJJJXd2MAIn0VhEmJzjNcW5ctpimL4jRm7WO9hjS7m0NVumU1eI9/RQg8eBHVs9YccMFf/m8H0AEPEGTI29kz1N+/9Y5nieprL7w7Oym8OZ2TbhBnhvSwligPwT1C+HrNndCrMD7vVfQUPnwD2fcGHJ+IdiEjAEhdjLSEfZfUfCRAk7k+9fD8r4fr56vgOzSyz0us3Ojv5XQvt86vXRj7pcaPJWY2sBsqvrBUIaKzi7FVN9vRhnYwHfs1ilROcR7pofhSQn+/GjGCwCj+7kx/3GsD4ezsBOkpm09P5AntOjYTOJcF7WW5iwRSzbvNhBk459Por/VO2Yxx64=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-09-25 15:50:46, Andrew Morton wrote:
> On Tue, 12 Aug 2025 17:08:53 +0800 Youling Tang <youling.tang@linux.dev> wrote:
> 
> > Hi, Jan
> > On 2025/7/14 17:33, Jan Kara wrote:
> > > On Fri 11-07-25 13:55:09, Youling Tang wrote:
> > >> From: Youling Tang <tangyouling@kylinos.cn>
> >
> > ...
> >
> > >> --- a/mm/filemap.c
> > >> +++ b/mm/filemap.c
> > >> @@ -2584,8 +2584,9 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
> > >>   	unsigned int flags;
> > >>   	int err = 0;
> > >>   
> > >> -	/* "last_index" is the index of the page beyond the end of the read */
> > >> -	last_index = DIV_ROUND_UP(iocb->ki_pos + count, PAGE_SIZE);
> > >> +	/* "last_index" is the index of the folio beyond the end of the read */
> > >> +	last_index = round_up(iocb->ki_pos + count, mapping_min_folio_nrbytes(mapping));
> > >> +	last_index >>= PAGE_SHIFT;
> > > I think that filemap_get_pages() shouldn't be really trying to guess what
> > > readahead code needs and round last_index based on min folio order. After
> > > all the situation isn't special for LBS filesystems. It can also happen
> > > that the readahead mark ends up in the middle of large folio for other
> > > reasons. In fact, we already do have code in page_cache_ra_order() ->
> > > ra_alloc_folio() that handles rounding of index where mark should be placed
> > > so your changes essentially try to outsmart that code which is not good. I
> > > think the solution should really be placed in page_cache_ra_order() +
> > > ra_alloc_folio() instead.
> > >
> > > In fact the problem you are trying to solve was kind of introduced (or at
> > > least made more visible) by my commit ab4443fe3ca62 ("readahead: avoid
> > > multiple marked readahead pages"). There I've changed the code to round the
> > > index down because I've convinced myself it doesn't matter and rounding
> > > down is easier to handle in that place. But your example shows there are
> > > cases where rounding down has weird consequences and rounding up would have
> > > been better. So I think we need to come up with a method how to round up
> > > the index of marked folio to fix your case without reintroducing problems
> > > mentioned in commit ab4443fe3ca62.
> > Yes, I simply replaced round_up() in ra_alloc_folio() with round_down()
> > to avoid this phenomenon before submitting this patch.
> > 
> > But at present, I haven't found a suitable way to solve both of these 
> > problems
> > simultaneously. Do you have a better solution on your side?
> > 
> 
> fyi, this patch remains stuck in mm.git awaiting resolution.
> 
> Do we have any information regarding its importance?  Which means do we
> have any measurement of its effect upon any real-world workload?

OK, after experimenting with the code some more and with rounding the
readahead mark index up, I've found out we need something like Youling
proposed anyway because otherwise it could happen that the whole readahead
area fits into a single min-order folio and thus with rounding up we
wouldn't have a folio to place readahead mark on. So with that I'm
withdrawing my objections and feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

to Youling's patch.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

