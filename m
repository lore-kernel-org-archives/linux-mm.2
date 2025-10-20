Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2349CCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A34E8E000A; Mon, 20 Oct 2025 11:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67AE08E0002; Mon, 20 Oct 2025 11:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7308E000A; Mon, 20 Oct 2025 11:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C93D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:59:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2D791601EE
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:59:06 +0000 (UTC)
X-FDA: 84018951492.27.3CDBF69
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 93A791A0014
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:59:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bnhi+g3V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jmb7mHUP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eDSbH0dq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=P5WSTFPT;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760975945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+T13MT5+DVqI4FOljyY2wyHe35kwNpItnKtnAfrs7U=;
	b=7f2+GVjSMHNnk8J9cKMuK/O+k0SEXmMf3SWMeqwsw6Z3IefVD1By3hhCHb1IvErcmBuCsH
	OX4Oc/5hTPWPLKBhLosWV0BVxpDPWT5t65YmfBd8N4wDxwjOtEPeX5OzbFsrfz/Mu5kQB9
	au63iIk5be1ZlbuzAKVXlY5c8dhXHP0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bnhi+g3V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jmb7mHUP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eDSbH0dq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=P5WSTFPT;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760975945; a=rsa-sha256;
	cv=none;
	b=Pt5XZb1Ls2wbvjD9/0eASiE23cYt+eLHu0dv41oFNuDoahPqOXLGfmpqd9mNADyF3GR35b
	AVJcGuAmmeyPTWM0uX5BT/Oad4uw3FU+/9nCTj8Ka32ZLuXVay+8K8TgbzLF71/VspwbZq
	tQKXsvhOC/u+jZN3Jn2iRa7T3nQNMdY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B09F8211AD;
	Mon, 20 Oct 2025 15:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760975938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A+T13MT5+DVqI4FOljyY2wyHe35kwNpItnKtnAfrs7U=;
	b=bnhi+g3V4guyjrFM7W2wvNQYgft8AKwfnrmdAJfYt+OshztZCGnA1OLjpJEGZIFD2RyIeB
	0xCUTtvLxJmDGaz2Hjk5AUzrIJZ2m42QncakyNgpWMG5GRQloTyBkPAyCYSdl47ukrkEAh
	Pxm1sV4k/jmAPJwphJBbggz9CK0Lt8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760975938;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A+T13MT5+DVqI4FOljyY2wyHe35kwNpItnKtnAfrs7U=;
	b=jmb7mHUPVa8eqJyOkhrTMAJqcVl0YdILYwlGdaxHrB9Bg+CkElEHgd7V5CWs/1fw2LgFxM
	7MiFG2FTf5cyVNAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760975934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A+T13MT5+DVqI4FOljyY2wyHe35kwNpItnKtnAfrs7U=;
	b=eDSbH0dqSfRA6WHKd9eLOdNQcxqexCI4JCFeyuSRhL4zpE3t9/I286H+RaDKonEHzKtgkm
	s5JBwkXqBlXOmjwrbCT9ixRSjikaAiX5mfxrkXJwfZY38sixPiNF2z25ST6srKiIHUFz4Y
	vqVvzvIQ0MkIc6GcPvVoNyvIm7A+OLk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760975934;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A+T13MT5+DVqI4FOljyY2wyHe35kwNpItnKtnAfrs7U=;
	b=P5WSTFPTevE66kkbFzbp2BlR5n8P+P85VjF6E9ukLw6GquJTeMbJVLmhe4KZGa+kJD0dNh
	hn8X7c3dF213TYCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1EB413AAC;
	Mon, 20 Oct 2025 15:58:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V4+DJz5c9mhJeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 15:58:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 536C2A088E; Mon, 20 Oct 2025 17:58:54 +0200 (CEST)
Date: Mon, 20 Oct 2025 17:58:54 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, djwong@kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPZOO3dFv61blHBz@casper.infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 93A791A0014
X-Stat-Signature: pfaqjhyopsr5ez8psa4umb3uefpseb4c
X-Rspam-User: 
X-HE-Tag: 1760975944-545251
X-HE-Meta: U2FsdGVkX18Dfhhwuj8V00wu7xOo60tBldeksL5ZuoM/08ha3yPYRpmh7QxWj35teDkNGkkfmnoqzbeOYjHNFfz1FI/MDW1OmpdViZFRKFRkfJwjt2TwpMD8WeisdWwKPO65A0sgyUbmMYJzIXq3h6hqhmPVoZ+eVnAizKmFWd5xidbfoSH9xKlKqILsCVJtBU9Ofg9+A1yO3cFzqfn9W2XmQT69m88xJW5qNuxQPOIMyE9zLwnUCr2ZXIurg1pEbbwNnSjjWykpXBYCaury39SANxyXF4eDMtIsn4V6+DDFHMCBd9e4Ckfwvv1cr5N8sHc+MJTol0zSTkE3J3MWGWGyoNAmwbD8A2d9tUV3izsfXch6n3eA7vSRIdWJxMM9OpCWS+rL64xv1NaSf4/j2wz5q78InkW606TPGfa1pU+nTfXAP4SI+ERwoUx4fHw6wtWSE/8MN9vOkF+3AiUajFWZHuLwsCyLONL8cQVzz+zq0MqNniZGOVoq4jZJ0qt/TtTpAbeZ0z5wMima+l4P8A7Y1Q759hG8lcW4Ht/s/vOuBJ8eVraj4UvN1V7x9x9Ne2lk8j6kE1k0obQJM5HgVdglgeARQ+SCl1TslgSL04/xq6d+34oBYsxZu2p/PbjNqu4E4WkqtcOFCvqlajK6Rf4CyOVJ773OtmGpjr59zppTk3K6UFf203yUyXbmqiWMTbe9sce+bbrDzlWDybv+C4Ko8LFE3BwAtcJJ9RhCN1dfyhv2SbtW2QqgD6xmizHyTz0BgohIjBCb7/ujzZ0Uj7RmNCT2HRsIPuxLvFy0edk9qpZeLMd0iL/VnDEKpwU3fu9fOfufnBqHt+Quq9wOIPHy9cydT8Hi3eT/54+BltzZ4chRrzruO1jHbBkdsQzk4YFzRU5S/rdOphDtq630J2KtatHLxfuUU4cPts2qWr+/uQgUaLAJW8Zmpj4BcXARk8Tb1kMn9nkLsjfer6L
 0Xq1lADf
 M2B2WVbnUWp1xysYsZmAlZHvEXAkhaAB1b4myKnZmdJdhpy9Ms0M8TSB+t5PKz61O9mqYdTkqA+LLZCy7Kr/7Zm13xto8Jj16eid5VNPbUAyizPAkujkYPHzx2n43WRLLs+IIM2eoWpbxH7VLiQBzBz98NzdpuPSkxWguCc0W5MRa8DgG7OyfikNc6bp+AZ9bWMo3+bF/5HMI0kegEJMZPiNdwqefnFKKbJc3wj8IZKh9jyVOR87mIQFAAjPCfhYkROnR6ZSwjVNTaXZfRNF9PKjkO5c6hb93csiW6tT0KPFQ9oTgZqtNbbe+2ODcs5iLXZEcIl3XkSPHe7e3WQV99JL7JOMbQnvGb4Mx3/lsio1WA0asMha7rdfu3BGoZLoOvY0CcQumVW5Uv+o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 20-10-25 15:59:07, Matthew Wilcox wrote:
> On Mon, Oct 20, 2025 at 03:59:33PM +0200, Jan Kara wrote:
> > The idea was to bounce buffer the page we are writing back in case we spot
> > a long-term pin we cannot just wait for - hence bouncing should be rare.
> > But in this more general setting it is challenging to not bounce buffer for
> > every IO (in which case you'd be basically at performance of RWF_DONTCACHE
> > IO or perhaps worse so why bother?). Essentially if you hand out the real
> > page underlying the buffer for the IO, all other attemps to do IO to that
> > page have to block - bouncing is no longer an option because even with
> > bouncing the second IO we could still corrupt data of the first IO once we
> > copy to the final buffer. And if we'd block waiting for the first IO to
> > complete, userspace could construct deadlock cycles - like racing IO to
> > pages A, B with IO to pages B, A. So far I'm not sure about a sane way out
> > of this...
> 
> There isn't one.  We might have DMA-mapped this page earlier, and so a
> device could write to it at any time.  Even if we remove PTE write
> permissions ...

True but writes through DMA to the page are guarded by holding a page pin
these days so we could in theory block getting another page pin or mapping
the page writeably until the pin is released... if we can figure out a
convincing story for dealing with long-term pins from RDMA and dealing with
possible deadlocks created by this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

